if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'DISPLAY_GROSS_FACULTATIVE_CALCULATION') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION DISPLAY_GROSS_FACULTATIVE_CALCULATION
end
GO
CREATE FUNCTION DISPLAY_GROSS_FACULTATIVE_CALCULATION(@P_ANO int, @P_FID Varchar(20))      
RETURNS @PCALC TABLE (ANO Int, Currency varchar(10), Code varchar(10), FCode varchar(10), SDate SmallDateTime, EDate SmallDateTime, Gross Float, Calculation varchar(1024))
AS
BEGIN

DECLARE @ACCEPTANCE TABLE (ANO Int, CNO Int, PANO Int, ATYPE varchar(1), EMethod varchar(1))
INSERT INTO @ACCEPTANCE
SELECT ANO, CNO, PANO, ATYPE, EMethod FROM ACCEPTANCE WHERE ANO=@P_ANO

DECLARE @RARRDET TABLE (ANO Int, ATYPE Varchar(1), FID varchar(20), Limit Float, PCalc varchar(1), SDate SmallDateTime, EDate SmallDateTime, Share Float, FLPCT Float, OnGrossAfterCommF Bit, FullCoverF Bit, NoRefundF Bit)
INSERT INTO @RARRDET
Select ANO, ATYPE, FID, Limit, PCalc, SDate, EDate, Share, FLPCT, OnGrossAfterCommF, FullCoverF, NOREFUNDF FROM RarrDet Where ANO=@P_ANO and FID=@P_FID

Declare @P_FullcoverF Bit
Declare @P_PANO Int

Select @P_PANO=PANO from @ACCEPTANCE 
Select @P_FullcoverF=FullCoverF from @RArrDet


if @P_FullcoverF=1
Begin
	--1
	Insert into @PCALC
	Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,   
	Gross=    
	Case     
	 When sum(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
	  else    
	   sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end  
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			sum(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*sum(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*sum(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   			
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			sum(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*sum(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*sum(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end    
	 end,     
	Calculation=      
	Case     
	 When sum(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
		End
	  else    
	   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    

	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), Cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				convert(varchar(25), Cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), sum(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), sum(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				convert(varchar(25), sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), sum(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), sum(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end    
	 
	 End    
	From      
	(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPart.Code) as FCode,
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end) AS GROSS,          
	AVG(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	SUM(ICalc.Rate) as Rate,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRateProrata,    
	Sum(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end/I.RiskNum) as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
	from ICalc, PCalc, (Select ANO, Currency, SDate, EDate, Count(*) as RiskNum from ICalc Where Gross<>0 and ANO=@P_ANO Group By ANO, Currency, SDate, EDate) I, DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D, FPart, @RARRDET RArrDet, @Acceptance Acceptance, Cover    
	Where Acceptance.ANO=@P_ANO and Cover.CNO=Acceptance.CNO and ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0 and PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency    
	and I.ANO=ICalc.ANO and I.Currency=ICalc.Currency and I.SDate=ICalc.SDate and I.EDate=ICalc.EDate        
	and D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.Code=ICalc.Code and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    
	and RArrDet.AType<>'C' 
	and RArrDet.FullCoverF=1 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID 
	and RArrDet.NoRefundF=0
	and (FPart.Currency='' or FPart.Currency=ICalc.Currency)
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj    
	) ICalc    
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj      
End
    

--2 (Refund from Endorsement)    
If @P_PANO<>-1 AND @P_FullcoverF=1
BEGIN
	Insert into @PCALC
	Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,   
	Gross=-    
	Case     
	 When sum(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
	  else    
		sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end    
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			Sum(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Sum(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Sum(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			Sum(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Sum(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Sum(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end  
	 end
	 * Case When Max(ICalc.AType)='C' and Max(ICalc.EMethod)<>'A' and Max(ICalc.CPRefund)<>0 then Max(ICalc.CPRefund)/100 else 1 end,
	Calculation=      
	Case     
	 When Sum(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
		End
	  else    
	   '- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    
	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), Cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				'- ' + convert(varchar(25), Cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), Sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Sum(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Sum(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				'- ' + convert(varchar(25), Sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Sum(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Sum(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end     
	 End    
	  +  
	  Case When Max(ICalc.AType)='C' and Max(ICalc.EMethod)<>'A' and Max(ICalc.CPRefund)<>0 then ' x '+convert(varchar(25),Max(ICalc.CPRefund),0)+'%' else '' end     
	From      
	(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPart.Code) as FCode,
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end) AS GROSS,          
	AVG(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	SUM(ICalc.Rate) as Rate,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRateProrata,    
	Sum(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end/I.RiskNum) as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(RArrDet.CPRefund) as CPRefund,
	Max(pAcceptance.AType) as AType,
	Max(pAcceptance.EMethod) as EMethod,
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
	from ICalc, PCalc, (Select I.ANO, I.Currency, I.SDate, I.EDate, Count(*) as RiskNum from ICalc I, Acceptance A Where I.Gross<>0 and I.ANO=A.PANO and A.ANO=@P_ANO Group By I.ANO, I.Currency, I.SDate, I.EDate) I, DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D, FPart, RArrDet, @RARRDET pRArrDet, @Acceptance pAcceptance, Acceptance, Cover    
	Where pAcceptance.ANO=@P_ANO and Acceptance.ANO=pAcceptance.PANO and Cover.CNO=Acceptance.CNO and ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0 and PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency    
	and I.ANO=ICalc.ANO and I.Currency=ICalc.Currency and I.SDate=ICalc.SDate and I.EDate=ICalc.EDate        
	and D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.Code=ICalc.Code and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    
	and RArrDet.AType<>'C' 
	and RArrDet.Status in ('A','R') and RArrDet.FullCoverF=1 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID    
	and pRArrDet.ANO=pAcceptance.ANO and pRArrDet.FID=@P_FID and pRArrDet.NoRefundF=0
	and (FPart.Currency='' or FPart.Currency=ICalc.Currency)
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj    
	) ICalc    
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj                  
End

--3 Detail    
IF @P_FullcoverF=0
BEGIN
	Insert into @PCALC
	Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,   
	Gross=    
	Case     
	 When sum(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
	  else    
	   sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end  
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			sum(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*sum(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*sum(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			sum(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*sum(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*sum(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end    
	 end,     
	Calculation=      
	Case     
	 When sum(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
		End
	  else    
	   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    

	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), Cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				convert(varchar(25), Cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), sum(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), sum(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				convert(varchar(25), sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), sum(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), sum(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end    
	 
	 End    
	From      
	(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPart.Code) as FCode,
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end) AS GROSS,          
	AVG(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	SUM(ICalc.Rate) as Rate,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRateProrata,    
	Max(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
	from ICalc, PCalc, DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D, FPartDet FPart, RateCov, @RARRDET RArrDet, @Acceptance Acceptance, Cover    
	Where Acceptance.ANO=@P_ANO and Cover.CNO=Acceptance.CNO and ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0 and PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency    
	and D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    
	and RArrDet.FullCoverF=0 and RArrDet.ANO=D.ANO 
	and RArrDet.AType<>'C' and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID and RateCov.Code=FPart.Code and RateCov.TOR=ICalc.TOR
	and RArrDet.NoRefundF=0
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj 
	) ICalc    
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj      
END

--4 Refund/Endorsement Detail    
IF @P_PANO<>-1 AND @P_FullcoverF=0    
BEGIN
	Insert into @PCALC
	Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,   
	Gross=-    
	Case     
	 When sum(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
	  else    
		sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end    
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			Sum(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Sum(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Sum(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			Sum(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Sum(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Sum(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end  
	 end
	 * Case When Max(ICalc.AType)='C' and Max(ICalc.EMethod)<>'A' and Max(ICalc.CPRefund)<>0 then Max(ICalc.CPRefund)/100 else 1 end,
	Calculation=      
	Case     
	 When Sum(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
		End
	  else    
	   '- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    
	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), Cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				'- ' + convert(varchar(25), Cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), Sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Sum(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Sum(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				'- ' + convert(varchar(25), Sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Sum(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Sum(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end     
	 End    
	  +  
	  Case When Max(ICalc.AType)='C' and Max(ICalc.EMethod)<>'A' and Max(ICalc.CPRefund)<>0 then ' x '+convert(varchar(25),Max(ICalc.CPRefund),0)+'%' else '' end     
	From      
	(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPart.Code) as FCode,
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end) AS GROSS,          
	AVG(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	SUM(ICalc.Rate) as Rate,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRateProrata,    
	Max(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(RArrDet.CPRefund) as CPRefund,
	Max(pAcceptance.AType) as AType,
	Max(pAcceptance.EMethod) as EMethod,
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
	from ICalc, PCalc, DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D, FPartDet FPart, RateCov, RArrDet, @RARRDET pRArrDet, @Acceptance pAcceptance, Acceptance, Cover    
	Where pAcceptance.ANO=@P_ANO and Acceptance.ANO=pAcceptance.PANO and Cover.CNO=Acceptance.CNO and ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0 and PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency    
	and D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    
	and RArrDet.Status in ('A','R') and RArrDet.FullCoverF=0 and RArrDet.ANO=D.ANO 
	and RArrDet.AType<>'C' and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID and RateCov.Code=FPart.Code and RateCov.TOR=ICalc.TOR
	and pRArrDet.ANO=pAcceptance.ANO and pRArrDet.FID=@P_FID and pRArrDet.NoRefundF=0
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj 
	) ICalc
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj        
END
    
RETURN
END

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'DISPLAY_FACULTATIVE_PRORATA_CALCULATION') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION DISPLAY_FACULTATIVE_PRORATA_CALCULATION
end
GO
CREATE FUNCTION DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO int, @P_FID varchar(20))            
RETURNS TABLE  AS            
RETURN (            
select            
Distinct    
RCalc.ANO,            
RCalc.Code,            
RCalc.Currency,            
RCalc.SDate,            
RCalc.EDate,    
RCalc.TOR,    
RCalc.Gross,     
RCalc.OGross,    
FacProrata_Calculation=    
Case    
When Cover.Voyage=1 then ICalc.sProrata    
When RArrDet.PCalc='F' and RArrDet.NetRate=0 then ICalc.sProrata    
When RArrDet.PCalc='P' and RArrDet.CPCT<>0 then convert(varchar(25),Cast(RArrDet.CPCT as float),0)+'%'     
When Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float)<>0 then    
 Case    
 When RArrDet.PCalc='F' then     
         convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12'    
 else    
  Case    
  When RArrDet.NetRate=0 then    
   Case     
   When RArrDet.PCalc='P' then    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then    
            convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12'    
    else    
            convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata)    
    end    
   else    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then    
            convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float))    
    else    
            convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cast(Datediff(Day, RCalc.Sdate, RCalc.EDate) as Float))    
    end    
   end    
  else    
   Case    
   When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then    
           convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12'    
   else    
           convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata)    
   end       
  end    
    
 end    
Else    
 Case    
 When RArrDet.PCalc='P' then    
  convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata)    
 else     
  ICalc.sProrata    
 end    
end,    
FacProrata=    
Case    
When Cover.Voyage=1 then ICalc.Prorata    
When RArrDet.PCalc='F' and RArrDet.NetRate=0 then ICalc.Prorata    
When RArrDet.PCalc='P' and RArrDet.CPCT<>0 then RArrDet.CPCT/100    
When Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float)<>0 then    
 Case    
 When RArrDet.PCalc='F' then     
  Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float) / 12    
 else    
  Case    
  When RArrDet.NetRate=0 then    
   Case     
   When RArrDet.PCalc='P' then    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then    
     Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/12    
    else    
     Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata    
    end    
   else    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then    
     Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float)    
    else    
     Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) /Cast(Datediff(Day, RCalc.Sdate, RCalc.EDate) as Float)    
    end    
   end    
  else    
   Case    
   When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then    
    Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/12    
   else    
    Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata    
   end       
  end    
    
 end    
Else    
 Case    
 When RArrDet.PCalc='P' then     
  Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata    
 else     
  ICalc.Prorata    
 end    
end    
From acceptance            
inner Join Cover on (Cover.CNO=Acceptance.CNO)             
inner join RCalc on (RCalc.ANO=Acceptance.ANO)         
inner join ICalc on (ICalc.ANO=RCalc.ANO and ICalc.Currency=RCalc.Currency and ICalc.Code=RCalc.Code and ICalc.SDate=RCalc.SDate and ICalc.EDate=RCalc.EDate and ICalc.TOR=RCalc.TOR)       
inner join (Select RArrDet.ANO, RCalc.Currency, Rcalc.Code, RCalc.SDate, RCalc.EDate, RArrDet.PCalc, RArrDet.CPCT, FPart.NetRate, Case When datediff(day, RCalc.SDate, RArrDet.SDate)>=0 then RArrDet.SDate else RCalc.SDate end as FSDate, Case When datediff(
day, RArrDet.EDate, RCalc.EDate)>=0 then RArrDet.EDate else RCalc.EDate end as FEDate from RArrDet, FPart, RCalc, Acceptance Where Acceptance.ANO=@P_ANO and RArrDet.ANO=Acceptance.ANO and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.
FID and RCalc.ANO=RArrDet.ANO and RArrDet.FullCoverF=1) RArrDet  on (RArrDet.ANO=RCalc.ANO and RArrDet.Currency=RCalc.Currency and RArrDet.Code=RCalc.Code and RArrDet.SDate=RCalc.SDate and RArrDet.EDate=RCalc.EDate)    
Where Acceptance.ANO=@P_ANO and RCalc.OGross<>0 and Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) >  0    
    
union all    
    
select            
Distinct    
RCalc.ANO,            
RCalc.Code,            
RCalc.Currency,            
RCalc.SDate,            
RCalc.EDate,    
RCalc.TOR,    
RCalc.Gross,     
RCalc.OGross,    
FacProrata_Calculation=    
Case    
When Cover.Voyage=1 then ICalc.sProrata    
When RArrDet.PCalc='F' and RArrDet.NetRate=0 then ICalc.sProrata    
When RArrDet.PCalc='P' and RArrDet.CPCT<>0 then convert(varchar(25),Cast(RArrDet.CPCT as float),0)+'%'     
When Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float)<>0 then    
 Case    
 When RArrDet.PCalc='F' then     
         convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12'    
 else    
  Case    
  When RArrDet.NetRate=0 then    
   Case     
   When RArrDet.PCalc='P' then    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then    
            convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12'    
    else    
            convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata)    
    end    
   else    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then    
            convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float))    
    else    
            convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cast(Datediff(Day, RCalc.Sdate, RCalc.EDate) as Float))    
    end    
   end    
  else    
   Case    
   When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then    
           convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12'    
   else    
           convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata)    
   end       
  end    
    
 end    
Else    
 Case    
 When RArrDet.PCalc='P' then    
  convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata)    
 else     
  ICalc.sProrata    
 end    
end,    
FacProrata=    
Case    
When Cover.Voyage=1 then ICalc.Prorata    
When RArrDet.PCalc='F' and RArrDet.NetRate=0 then ICalc.Prorata    
When RArrDet.PCalc='P' and RArrDet.CPCT<>0 then RArrDet.CPCT/100    
When Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float)<>0 then    
 Case    
 When RArrDet.PCalc='F' then     
  Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float) / 12    
 else    
  Case    
  When RArrDet.NetRate=0 then    
   Case     
   When RArrDet.PCalc='P' then    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then    
     Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/12    
    else    
     Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata    
    end    
   else    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then    
     Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float)    
    else    
     Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) /Cast(Datediff(Day, RCalc.Sdate, RCalc.EDate) as Float)    
    end    
   end    
  else    
   Case    
   When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then    
    Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/12    
   else    
    Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata    
   end       
  end    
    
 end    
Else    
 Case    
 When RArrDet.PCalc='P' then     
  Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata    
 else     
  ICalc.Prorata    
 end    
end    
From acceptance pAcceptance           
inner join Acceptance on (Acceptance.ANO=pAcceptance.pANO)    
inner Join Cover on (Cover.CNO=Acceptance.CNO)             
inner join RCalc on (RCalc.ANO=Acceptance.ANO)      
inner join ICalc on (ICalc.ANO=RCalc.ANO and ICalc.Currency=RCalc.Currency and ICalc.Code=RCalc.Code and ICalc.SDate=RCalc.SDate and ICalc.EDate=RCalc.EDate and ICalc.TOR=RCalc.TOR)          
inner join (Select RArrDet.ANO, RCalc.Currency, Rcalc.Code, RCalc.SDate, RCalc.EDate, RArrDet.PCalc, RArrDet.CPCT, FPart.NetRate, Case When datediff(day, RCalc.SDate, RArrDet.SDate)>=0 then RArrDet.SDate else RCalc.SDate end as FSDate, Case When datediff(
day, RArrDet.EDate, RCalc.EDate)>=0 then RArrDet.EDate else RCalc.EDate end as FEDate from RArrDet, FPart, RCalc, Acceptance Where Acceptance.ANO=@P_ANO and RArrDet.ANO=Acceptance.pANO and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet
.FID and RCalc.ANO=RArrDet.ANO and RArrDet.FullCoverF=1) RArrDet  on (RArrDet.ANO=RCalc.ANO and RArrDet.Currency=RCalc.Currency and RArrDet.Code=RCalc.Code and RArrDet.SDate=RCalc.SDate and RArrDet.EDate=RCalc.EDate)    
Where pAcceptance.ANO=@P_ANO and RCalc.OGross<>0 and Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) >  0    
    
UNION ALL    
    
select            
Distinct    
RCalc.ANO,            
RCalc.Code,            
RCalc.Currency,            
RCalc.SDate,            
RCalc.EDate,    
RCalc.TOR,    
RCalc.Gross,     
RCalc.OGross,    
FacProrata_Calculation=    
Case    
When Cover.Voyage=1 then ICalc.sProrata    
When RArrDet.PCalc='F' and RArrDet.NetRate=0 then ICalc.sProrata    
When RArrDet.PCalc='P' and RArrDet.CPCT<>0 then convert(varchar(25),Cast(RArrDet.CPCT as float),0)+'%'     
When Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float)<>0 then    
 Case    
 When RArrDet.PCalc='F' then     
         convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12'    
 else    
  Case    
  When RArrDet.NetRate=0 then    
   Case     
   When RArrDet.PCalc='P' then    
 Case   
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then    
            convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12'    
    else    
            convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata)    
    end    
   else    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then    
            convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float))    
    else    
            convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cast(Datediff(Day, RCalc.Sdate, RCalc.EDate) as Float))    
    end    
   end    
  else    
   Case    
   When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then    
           convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12'    
   else    
           convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata)    
   end       
  end    
    
 end    
Else    
 Case    
 When RArrDet.PCalc='P' then    
  convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata)    
 else     
  ICalc.sProrata    
 end    
end,    
FacProrata=    
Case    
When Cover.Voyage=1 then ICalc.Prorata    
When RArrDet.PCalc='F' and RArrDet.NetRate=0 then ICalc.Prorata    
When RArrDet.PCalc='P' and RArrDet.CPCT<>0 then RArrDet.CPCT/100    
When Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float)<>0 then    
 Case    
 When RArrDet.PCalc='F' then     
  Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float) / 12    
 else    
  Case    
  When RArrDet.NetRate=0 then    
   Case     
   When RArrDet.PCalc='P' then    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then    
     Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/12    
    else    
     Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata    
    end    
   else    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then    
     Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float)    
    else    
     Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) /Cast(Datediff(Day, RCalc.Sdate, RCalc.EDate) as Float)    
    end    
   end    
  else    
   Case    
   When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then    
    Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/12    
   else    
    Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata    
   end       
  end    
    
 end    
Else    
 Case    
 When RArrDet.PCalc='P' then     
  Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata    
 else     
  ICalc.Prorata    
 end    
end    
From acceptance            
inner Join Cover on (Cover.CNO=Acceptance.CNO)             
inner join RCalc on (RCalc.ANO=Acceptance.ANO)         
inner join ICalc on (ICalc.ANO=RCalc.ANO and ICalc.Currency=RCalc.Currency and ICalc.Code=RCalc.Code and ICalc.SDate=RCalc.SDate and ICalc.EDate=RCalc.EDate and ICalc.TOR=RCalc.TOR)       
inner join (  
 Select RArrDet.ANO, RCalc.Currency, Rcalc.TOR, RCalc.SDate, RCalc.EDate, RArrDet.PCalc, RArrDet.CPCT, FPart.NetRate, Case When datediff(day, RCalc.SDate, RArrDet.SDate)>=0 then RArrDet.SDate else RCalc.SDate end as FSDate, Case When datediff(day, RArrDet.EDate, RCalc.EDate)>=0 then RArrDet.EDate else RCalc.EDate end as FEDate   
 from RArrDet, FPartDet FPart, RateCov, RCalc, Acceptance   
 Where Acceptance.ANO=@P_ANO and RArrDet.ANO=Acceptance.ANO and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID   
 and RateCov.Code=FPart.Code and RateCov.TOR=RCalc.TOR and RCalc.ANO=RArrDet.ANO and RArrDet.FullCoverF=0  
) RArrDet  on (RArrDet.ANO=RCalc.ANO and RArrDet.Currency=RCalc.Currency and RArrDet.TOR=RCalc.TOR and RArrDet.SDate=RCalc.SDate and RArrDet.EDate=RCalc.EDate)    
Where Acceptance.ANO=@P_ANO and RCalc.OGross<>0 and Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) >  0    
    
union all    
    
select            
Distinct    
RCalc.ANO,            
RCalc.Code,            
RCalc.Currency,            
RCalc.SDate,            
RCalc.EDate,    
RCalc.TOR,    
RCalc.Gross,     
RCalc.OGross,    
FacProrata_Calculation=    
Case    
When Cover.Voyage=1 then ICalc.sProrata    
When RArrDet.PCalc='F' and RArrDet.NetRate=0 then ICalc.sProrata    
When RArrDet.PCalc='P' and RArrDet.CPCT<>0 then convert(varchar(25),Cast(RArrDet.CPCT as float),0)+'%'     
When Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float)<>0 then    
 Case    
 When RArrDet.PCalc='F' then     
         convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12'    
 else    
  Case    
  When RArrDet.NetRate=0 then    
   Case     
   When RArrDet.PCalc='P' then    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then    
            convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12'    
    else    
            convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata)    
    end    
   else    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then    
            convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float))    
    else    
            convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cast(Datediff(Day, RCalc.Sdate, RCalc.EDate) as Float))    
    end    
   end    
  else    
   Case    
   When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then    
           convert(varchar(25),Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/12'    
   else    
           convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata)    
   end       
  end    
    
 end    
Else    
 Case    
 When RArrDet.PCalc='P' then    
  convert(varchar(25),Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float))+'/'+convert(varchar(25),Cover.Prorata)    
 else     
  ICalc.sProrata    
 end    
end,    
FacProrata=    
Case    
When Cover.Voyage=1 then ICalc.Prorata    
When RArrDet.PCalc='F' and RArrDet.NetRate=0 then ICalc.Prorata    
When RArrDet.PCalc='P' and RArrDet.CPCT<>0 then RArrDet.CPCT/100    
When Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float)<>0 then    
 Case    
 When RArrDet.PCalc='F' then     
  Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float) / 12    
 else    
  Case    
  When RArrDet.NetRate=0 then    
   Case     
   When RArrDet.PCalc='P' then    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then    
     Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/12    
    else    
     Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata    
    end    
   else    
    Case    
    When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then    
     Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/Cast(Datediff(month, RCalc.Sdate, RCalc.EDate) as Float)    
    else    
     Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) /Cast(Datediff(Day, RCalc.Sdate, RCalc.EDate) as Float)    
    end    
   end    
  else    
   Case    
   When day(RArrDet.FSDate)=day(RArrDet.FEDate) and day(RCalc.SDate)=day(RCalc.EDate) and Cover.PPeriod<>1 then    
    Cast(Datediff(month, RArrDet.FSDate, RArrDet.FEDate) as Float)/12    
   else    
    Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata    
   end       
  end    
    
 end    
Else    
 Case    
 When RArrDet.PCalc='P' then     
  Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) / Cover.Prorata    
 else     
  ICalc.Prorata    
 end    
end    
From acceptance pAcceptance           
inner join Acceptance on (Acceptance.ANO=pAcceptance.pANO)    
inner Join Cover on (Cover.CNO=Acceptance.CNO)             
inner join RCalc on (RCalc.ANO=Acceptance.ANO)         
inner join ICalc on (ICalc.ANO=RCalc.ANO and ICalc.Currency=RCalc.Currency and ICalc.Code=RCalc.Code and ICalc.SDate=RCalc.SDate and ICalc.EDate=RCalc.EDate and ICalc.TOR=RCalc.TOR)       
inner join (  
 Select RArrDet.ANO, RCalc.Currency, Rcalc.TOR, RCalc.SDate, RCalc.EDate, RArrDet.PCalc, RArrDet.CPCT, FPart.NetRate, Case When datediff(day, RCalc.SDate, RArrDet.SDate)>=0 then RArrDet.SDate else RCalc.SDate end as FSDate, Case When datediff(day, RArrDet.EDate, RCalc.EDate)>=0 then RArrDet.EDate else RCalc.EDate end as FEDate   
 from RArrDet, FPartDet FPart, RateCov, RCalc, Acceptance   
 Where Acceptance.ANO=@P_ANO and RArrDet.ANO=Acceptance.pANO and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID   
 and RateCov.Code=FPart.Code and RateCov.TOR=RCalc.TOR and RCalc.ANO=RArrDet.ANO and RArrDet.FullCoverF=0  
) RArrDet  on (RArrDet.ANO=RCalc.ANO and RArrDet.Currency=RCalc.Currency and RArrDet.TOR=RCalc.TOR and RArrDet.SDate=RCalc.SDate and RArrDet.EDate=RCalc.EDate)    
Where pAcceptance.ANO=@P_ANO and RCalc.OGross<>0 and Cast(DateDiff(day, RArrDet.FSDate, RArrDet.FEDate) as Float) >  0    
    
)            



GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'DISPLAY_GROSS_CALCULATION') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION DISPLAY_GROSS_CALCULATION
end
GO
CREATE FUNCTION DISPLAY_GROSS_CALCULATION(@P_ANO int)      
RETURNS TABLE  AS      
RETURN (      
Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, sum(ICalc.Gross) as Gross,      
Calculation=      
Case When ICalc.SRate<>'Flat' then convert(varchar(25),Cast(sum(ICalc.TSI) as Money),1) + ' x ' + (case When RCover.Unit='C' then convert(varchar(25), Cast(sum(ICalc.Rate*100)/Count(*) as Numeric(38,8)),2)+'%' else convert(varchar(25), Cast(sum(ICalc.Rate*1000)/Count(*) as Numeric(38,8)),3)+'‰' end) else convert(varchar(25), Cast(sum(ICalc.Rate) as Money),1) end +      
Case When ICalc.sProrata<>'' then ' x '+ICalc.sProrata else '' end +      
Case When ICalc.SRate<>'Flat' and ICalc.PCTAdj<>100 then ' x '+Cast(Icalc.PCTAdj as varchar(10))+'%' else '' end      
From      
(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end as PCTAdj, sum(ICalc.Gross) as Gross, Max(ICalc.SRate) as SRate, Max(ICalc.TSI) as TSI, sum(ICalc.Rate) as Rate, Max(ICalc.sProrata) as sProrata      
from ICalc, Acceptance Where ICalc.ANO=Acceptance.ANO and Acceptance.ANO=@P_ANO and ICalc.Rate<>0      
Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end      
) ICalc, RCover      
Where RCOVER.ANO = ICALC.ANO And RCOVER.Code = ICALC.Code And RCOVER.SDate = ICALC.SDate And RCOVER.EDate = ICALC.EDate      
Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.SRate, RCover.Unit, ICalc.sProrata, ICalc.PCTadj      
                
Union All      
                
Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, -sum(ICalc.Gross)*Case When Max(ICalc.AType)='C' and Max(ICalc.EMethod)<>'A' and Max(RCover.CPRefund)<>0 then Max(RCover.CPRefund)/100 else 1 end as Gross,      
Calculation='- '+      
Case When ICalc.SRate<>'Flat' then convert(varchar(25),Cast(sum(ICalc.TSI) as Money),1) + ' x ' + (case When RCover.Unit='C' then convert(varchar(25), Cast(sum(ICalc.Rate*100)/Count(*) as Numeric(38,8)),2)+'%' else convert(varchar(25), Cast(sum(ICalc.Rate*1000)/Count(*) as Numeric(38,8)),3)+'‰' end) else convert(varchar(25), Cast(sum(ICalc.Rate) as Money),1) end +      
Case When ICalc.sProrata<>'' then ' x '+ICalc.sProrata else '' end +      
Case When ICalc.SRate<>'Flat' and ICalc.PCTAdj<>100 then ' x '+Cast(Icalc.PCTAdj as varchar(10))+'%' else '' end +  
Case When Max(ICalc.AType)='C' and Max(ICalc.EMethod)<>'A' and Max(RCover.CPRefund)<>0 then ' x '+convert(varchar(25),Max(RCover.CPRefund),0)+'%' else '' end  
From      
(Select Acceptance.AType, Acceptance.EMethod, ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end as PCTAdj, sum(ICalc.Gross) as Gross, Max(ICalc.SRate) as SRate, Max(ICalc.TSI) as TSI, sum(ICalc.Rate) as Rate, Max(ICalc.sProrata) as sProrata      
from ICalc, Acceptance Where ICalc.ANO=Acceptance.PANO and Acceptance.ANO=@P_ANO and ICalc.Rate<>0      
Group By Acceptance.AType, Acceptance.EMethod, ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end      
) ICalc, RCover      
Where RCOVER.ANO = ICALC.ANO And RCOVER.Code = ICALC.Code And RCOVER.SDate = ICALC.SDate And RCOVER.EDate = ICALC.EDate      
Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.SRate, RCover.Unit, ICalc.sProrata, ICalc.PCTadj      
      
Union All      
        
Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, sum(ICalc.Gross) as Gross,      
Calculation=      
Case When ICalc.SRate<>'Flat' then convert(varchar(25),Cast(sum(ICalc.TSI) as Money),1) + ' x ' + (case When RCover.Unit='C' then convert(varchar(25), Cast(sum(ICalc.Rate*100)/Count(*) as Numeric(38,8)),2)+'%' else convert(varchar(25), Cast(sum(ICalc.Rate*1000)/Count(*) as Numeric(38,8)),3)+'‰' end) else convert(varchar(25), Cast(sum(ICalc.Rate) as Money),1) end +      
Case When ICalc.sProrata<>'' then ' x '+ICalc.sProrata else '' end +      
Case When ICalc.SRate<>'Flat' and ICalc.PCTAdj<>100 then ' x '+Cast(Icalc.PCTAdj as varchar(10))+'%' else '' end      
From      
(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end as PCTAdj, sum(ICalc.Reinstatement) as Gross, Max(ICalc.SRate) as SRate, Max(ICalc.Indemnity) as TSI, sum(ICalc.Rate) as Rate, Max(ICalc.sProrata) as sProrata      
from ICalc, Acceptance Where Acceptance.EMethod='R' and ICalc.ANO=Acceptance.ANO and Acceptance.ANO=@P_ANO and ICalc.Rate<>0      
Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Case When ICalc.SRate='Flat' then 100 else ICalc.PCTAdj end      
) ICalc, RCover      
Where RCOVER.ANO = ICALC.ANO And RCOVER.Code = ICALC.Code And RCOVER.SDate = ICALC.SDate And RCOVER.EDate = ICALC.EDate      
Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.SRate, RCover.Unit, ICalc.sProrata, ICalc.PCTadj      
)     

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'DISPLAY_PRORATA_CALCULATION') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION DISPLAY_PRORATA_CALCULATION
end
GO
CREATE FUNCTION DISPLAY_PRORATA_CALCULATION(@P_ANO int)        
RETURNS TABLE  AS        
RETURN (        
select        
Distinct        
RCalc.ANO,        
RCalc.Code,        
RCalc.Currency,        
RCalc.SDate,        
RCalc.EDate,        
Prorata_Calculation=        
case        
When Acceptance.AType<>'N' then        

 case        
 when DateDiff(day, RCalc.Edate, acceptance.pdate)>=0 then ''
 when DateDiff(day, acceptance.pdate, RCalc.SDate)>0 then ''        
 Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),0)+'%' else '' end        
  Else        
	--Prorata Calculation
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then
		dbo.fn_calc_sprorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
	else
		dbo.fn_calc_sprorata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
	End
  End
 End        
Else        
 ''        
end,        
          
Prorata=        
case        
When Acceptance.AType<>'N' then        
 case        
 when DateDiff(day, RCalc.Edate, acceptance.pdate)>=0 then 0        
 when DateDiff(day, acceptance.pdate, RCalc.SDate)>0 then 1        
 Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end        
  Else        
	--Prorata Calculation
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then
		dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
	else
		dbo.fn_calc_prorata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
	End
  End
 End        

Else        
	1        
End        
          
                      
From acceptance        
inner Join Cover on (Cover.CNO=Acceptance.CNO)        
inner join PCalc on (PCalc.ANO=Acceptance.ANO)        
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)        
inner Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)        
Where Acceptance.AType not in ('A','C')        
and (Acceptance.AType='N' or (Acceptance.NoRefundF not in (2,4) and RCover.NoRefundF=0 and (Acceptance.NoRefundF in (0,3,5,6) or (DateDiff(day, acceptance.pdate, RCalc.SDate) > 0))))
and Acceptance.ANO=@P_ANO        
          
Union All        
          
select        
Distinct        
RCalc.ANO,        
RCalc.Code,        
RCalc.Currency,        
RCalc.SDate,        
RCalc.EDate,        
Prorata_Calculation=        
case        
when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''        
when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''        

Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),0)+'%' else '' end        
  Else        
    case        
		When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then        
			--Prorata Calculation
			Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
				dbo.fn_Calc_SProrata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
			else
				dbo.fn_Calc_SProrata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
			End
		Else        
		 -- Endorsement Period        
			''        
		End       
	End        
End        
,        
Prorata=        
case        
when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0        
when DateDiff(day, acceptance.pdate, rcalc.SDate)>0  and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1        

Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end        
  Else        
    case        
		When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then        
			--Prorata Calculation
			Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
				dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
			else
				dbo.fn_calc_prorata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
			End
		Else        
		 -- Endorsement Period        
			1        
		End        
	End        
End        
          
From acceptance        
inner Join Cover on (Cover.CNO=Acceptance.CNO)        
inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)        
inner join PCalc on (PCalc.ANO=pAcceptance.ANO)        
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)        
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)        
Where Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C')        
and Acceptance.NoRefundF Not in (2,4) and coalesce(RCover.NoRefundF,0)=0
and (Acceptance.NoRefundF in (0,3,5,6) or (DateDiff(day, acceptance.pdate, rcalc.SDate) > 0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate))      
and Acceptance.ANO=@P_ANO        
)        
       
go

	   
  insert into PatchVersioning
select '54.10 Update Script - Patch 2019 (13)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='54.9 Update Script - Patch 2019 (12)'
Select @CurrSCript='54.10 Update Script - Patch 2019 (13)'


Declare @ExecScript varchar(100)
Declare @ExecScriptStatus varchar(100)
Declare @Error varchar(200)

Select @Error=''

Begin 
       Select @ExecScript=Execscript,  @ExecScriptStatus=ExecScriptStatus from systab 
       if @PrevScript<>'' and @ExecSCript<>@PrevScript
              THROW 51000, 'Not the Next Sequence Script', 1;
       else 
              if @ExecScriptStatus<>'' and @ExecScriptStatus<>'DONE'
              THROW 51000, 'Pending Script Execution', 1;

       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='PENDING'             
       
       BEGIN TRY            
			PRINT '--EXECUTE DONE--'
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End

