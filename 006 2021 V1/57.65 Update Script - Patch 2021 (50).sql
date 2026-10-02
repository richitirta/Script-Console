IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('DISPLAY_GROSS_FACULTATIVE_CALCULATION') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION DISPLAY_GROSS_FACULTATIVE_CALCULATION
end
GO
CREATE FUNCTION DISPLAY_GROSS_FACULTATIVE_CALCULATION(@P_ANO int, @P_FID Varchar(20))      
RETURNS @PCALC TABLE (ANO Int, Currency varchar(10), Code varchar(10), FCode varchar(10), SDate SmallDateTime, EDate SmallDateTime, Gross Float, Calculation varchar(1024))
AS
BEGIN

DECLARE @ACCEPTANCE TABLE (ANO Int, CNO Int, PANO Int, ATYPE varchar(1), EMethod varchar(1), SDate Smalldatetime, EDate Smalldatetime)
INSERT INTO @ACCEPTANCE
SELECT ANO, CNO, PANO, ATYPE, EMethod, SDate, EDate FROM ACCEPTANCE WHERE ANO=@P_ANO

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
	 When max(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
	  else    
	   sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end  
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   			
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end    
	 end,     
	Calculation=      
	Case     
	 When max(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
		End
	  else    
	   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    

	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end    
	 
	 End    
	From      
	(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPart.Code) as FCode,
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end*(Case When RArrDet.Limit<>0 Then RArrDet.Limit/RArrHeader.TAmount Else 1 end)) AS GROSS,         
 
	AVG(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end) as NetRateProrata,    
	Sum(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end/I.RiskNum) as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
		
	from @Acceptance Acceptance
	Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
	Inner Join ICalc on (ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0)
	Inner Join PCalc on (PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency)
	Inner Join (
		Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Count(*) as RiskNum 
		from ICalc 
		Where Gross<>0 and ANO=@P_ANO 
		Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate
		) I on (I.ANO=ICalc.ANO and I.INO=ICalc.INO and I.Currency=ICalc.Currency and I.Code=ICalc.Code and I.SDate=ICalc.SDate and I.EDate=ICalc.EDate)	
	Inner Join DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D on (D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.Code=ICalc.Code and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    )
	Inner Join @RARRDET RArrDet on (RArrDet.AType<>'C' and RArrDet.FullCoverF=1 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID)
	Inner Join FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID and (FPart.Currency='' or FPart.Currency=ICalc.Currency))
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)
	Where Acceptance.ANO=@P_ANO 
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
	 When max(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
	  else    
		sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end    
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end  
	 end,
	 
	Calculation=      
	Case     
	 When max(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
		End
	  else    
	   '- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    
	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				'- ' + convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				'- ' + convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end     
	 End    

	From      
	(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPart.Code) as FCode,
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end*(Case When RArrDet.Limit<>0 Then RArrDet.Limit/RArrHeader.TAmount Else 1 end)) AS GROSS,         
	AVG(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end) as NetRateProrata,    
	Sum(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end/I.RiskNum) as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(pAcceptance.AType) as AType,
	Max(pAcceptance.EMethod) as EMethod,
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
	from @Acceptance pAcceptance
	Inner Join Acceptance on (Acceptance.ANO=pAcceptance.pANO)
	Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
	Inner Join ICalc on (ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0)
	Inner Join PCalc on (PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency)
	Inner Join (
		Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Count(*) as RiskNum 
		from ICalc 
		Where Gross<>0 and ANO=@P_PANO  
		Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate
		) I on (I.ANO=ICalc.ANO and I.INO=ICalc.INO and I.Currency=ICalc.Currency and I.Code=ICalc.Code and I.SDate=ICalc.SDate and I.EDate=ICalc.EDate)	
	Inner Join DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D on (D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.Code=ICalc.Code and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR)
	Inner Join RArrDet on (RArrDet.AType<>'C' and RArrDet.Status in ('A','R') and RArrDet.FullCoverF=1 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID)
	Inner Join FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID and (FPart.Currency='' or FPart.Currency=ICalc.Currency))
	Inner Join @RARRDET nRArrDet on (nRArrDet.ANO=pAcceptance.ANO and nRArrDet.FID=@P_FID)
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)
	Where pAcceptance.ANO=@P_ANO 
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
	 When max(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
	  else    
	   sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end  
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end    
	 end,     
	Calculation=      
	Case     
	 When max(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
		End
	  else    
	   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    

	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end    
	 
	 End    
	From      
	(
	Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPart.Code) as FCode,
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	Max(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end*(Case When RArrDet.Limit<>0 Then RArrDet.Limit/RArrHeader.TAmount Else 1 end)) AS GROSS,          
	Max(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end) as NetRateProrata,    
	Max(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end) as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
	from @Acceptance Acceptance
	Inner Join RArrheader on (RArrHeader.ANO=Acceptance.ANO)
	Inner Join ICalc on (ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0)
	Inner Join PCalc on (PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency)
	Inner Join DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D on (D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    )
	Inner Join @RARRDET RArrDet on (RArrDet.AType<>'C' and RArrDet.FullCoverF=0 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID)
	Inner Join FPartDet FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID)
	Inner Join RateCov on (RateCov.Code=FPart.Code and RateCov.TOR=ICalc.TOR)
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)
	Where Acceptance.ANO=@P_ANO 
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
	 When max(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
	  else    
		sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end    
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end  
	 end,

	Calculation=      
	Case     
	 When max(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
		End
	  else    
	   '- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    
	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				'- ' + convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				'- ' + convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end     
	 End    

	From      
	(
	Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPart.Code) as FCode,
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	Max(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end*(Case When RArrDet.Limit<>0 Then RArrDet.Limit/RArrHeader.TAmount Else 1 end)) AS GROSS,          
	Max(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end) as NetRateProrata,    
	Max(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end) as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(pAcceptance.AType) as AType,
	Max(pAcceptance.EMethod) as EMethod,
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
	from @Acceptance pAcceptance
	Inner Join Acceptance on (Acceptance.ANO=pAcceptance.pANO)
	Inner Join RArrheader on (RArrHeader.ANO=Acceptance.ANO)
	Inner Join ICalc on (ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0)
	Inner Join PCalc on (PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency)
	Inner Join DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D on (D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR)
	Inner Join RArrDet on (RArrDet.AType<>'C' and RArrDet.Status in ('A','R') and RArrDet.FullCoverF=0 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID)
	Inner Join FPartDet FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID)
	Inner Join RateCov on (RateCov.Code=FPart.Code and RateCov.TOR=ICalc.TOR)
	Inner Join @RARRDET nRArrDet on (nRArrDet.ANO=pAcceptance.ANO and nRArrDet.FID=@P_FID)
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)
	Where pAcceptance.ANO=@P_ANO 
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj 
	) ICalc
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj        
END
    
RETURN
END


GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('DISPLAY_FACULTATIVE_CALCULATION') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION DISPLAY_FACULTATIVE_CALCULATION 
end
GO
CREATE FUNCTION DISPLAY_FACULTATIVE_CALCULATION(@P_ANO int, @P_FID varchar(20))            
RETURNS TABLE  AS            
RETURN (            
Select A.ANO, CASE WHEN D1.FCODE<>'' THEN D1.FCODE ELSE D1.CODE END Code, D1.SDate, D1.EDate, D1.Gross, D2.Prorata, D1.Currency,  D1.Calculation as Premium_Calculation, D2.Prorata_Calculation,            
D1.Calculation + Case When D2.Prorata=0 or D2.Prorata_Calculation='' Then '' else ' x '+D2.Prorata_Calculation end            
+ Case When A.Qty>1 Then ' x '+ Convert(varchar(25), Cast(A.Qty as Int),1) Else '' end            
+ ' = ' + Convert(varchar(50), Cast(D1.Gross*(Case When D2.Prorata<>0 or D2.Prorata_Calculation<>'' Then D2.Prorata else 1 end)*Case When A.Qty>1 Then A.Qty Else 1 End as Money),1) as Calculation      
from Display_Gross_Facultative_Calculation(@P_ANO, @P_FID) D1, DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION(@P_ANO, @P_FID) D2, Acceptance A 
Where a.ANO = D1.ANO And D1.ANO = D2.ANO And D1.Currency = D2.Currency And D1.Code = D2.Code And D1.SDate = D2.SDate And D1.EDate = D2.EDate and D2.Prorata<>0 
) 
GO
DROP FUNCTION DISPLAY_GROSS_FACULTATIVE_CALCULATION
GO
CREATE FUNCTION DISPLAY_GROSS_FACULTATIVE_CALCULATION(@P_ANO int, @P_FID Varchar(20))      
RETURNS @PCALC TABLE (ANO Int, Currency varchar(10), Code varchar(10), FCode varchar(10), SDate SmallDateTime, EDate SmallDateTime, Gross Float, Calculation varchar(1024))
AS
BEGIN

DECLARE @ACCEPTANCE TABLE (ANO Int, CNO Int, PANO Int, ATYPE varchar(1), EMethod varchar(1), SDate Smalldatetime, EDate Smalldatetime)
INSERT INTO @ACCEPTANCE
SELECT ANO, CNO, PANO, ATYPE, EMethod, SDate, EDate FROM ACCEPTANCE WHERE ANO=@P_ANO

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
	 When max(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
	  else    
	   sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end  
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   			
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end    
	 end,     
	Calculation=      
	Case     
	 When max(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
		End
	  else    
	   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    

	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end    
	 
	 End    
	From      
	(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPart.Code) as FCode,
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end*(Case When RArrDet.Limit<>0 Then RArrDet.Limit/RArrHeader.TAmount Else 1 end)) AS GROSS,         
 
	AVG(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end) as NetRateProrata,    
	Sum(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end/I.RiskNum) as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
		
	from @Acceptance Acceptance
	Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
	Inner Join ICalc on (ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0)
	Inner Join PCalc on (PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency)
	Inner Join (
		Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Count(*) as RiskNum 
		from ICalc 
		Where Gross<>0 and ANO=@P_ANO 
		Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate
		) I on (I.ANO=ICalc.ANO and I.INO=ICalc.INO and I.Currency=ICalc.Currency and I.Code=ICalc.Code and I.SDate=ICalc.SDate and I.EDate=ICalc.EDate)	
	Inner Join DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D on (D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.Code=ICalc.Code and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    )
	Inner Join @RARRDET RArrDet on (RArrDet.AType<>'C' and RArrDet.FullCoverF=1 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID)
	Inner Join FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID and (FPart.Currency='' or FPart.Currency=ICalc.Currency))
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)
	Where Acceptance.ANO=@P_ANO 
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
	 When max(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
	  else    
		sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end    
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end  
	 end,
	 
	Calculation=      
	Case     
	 When max(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
		End
	  else    
	   '- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    
	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				'- ' + convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				'- ' + convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end     
	 End    

	From      
	(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPart.Code) as FCode,
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end*(Case When RArrDet.Limit<>0 Then RArrDet.Limit/RArrHeader.TAmount Else 1 end)) AS GROSS,         
	AVG(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end) as NetRateProrata,    
	Sum(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end/I.RiskNum) as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(pAcceptance.AType) as AType,
	Max(pAcceptance.EMethod) as EMethod,
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
	from @Acceptance pAcceptance
	Inner Join Acceptance on (Acceptance.ANO=pAcceptance.pANO)
	Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
	Inner Join ICalc on (ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0)
	Inner Join PCalc on (PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency)
	Inner Join (
		Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, Count(*) as RiskNum 
		from ICalc 
		Where Gross<>0 and ANO=@P_PANO  
		Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate
		) I on (I.ANO=ICalc.ANO and I.INO=ICalc.INO and I.Currency=ICalc.Currency and I.Code=ICalc.Code and I.SDate=ICalc.SDate and I.EDate=ICalc.EDate)	
	Inner Join DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D on (D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.Code=ICalc.Code and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR)
	Inner Join RArrDet on (RArrDet.AType<>'C' and RArrDet.Status in ('A','R') and RArrDet.FullCoverF=1 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID)
	Inner Join FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID and (FPart.Currency='' or FPart.Currency=ICalc.Currency))
	Inner Join @RARRDET nRArrDet on (nRArrDet.ANO=pAcceptance.ANO and nRArrDet.FID=@P_FID)
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)
	Where pAcceptance.ANO=@P_ANO 
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
	 When max(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
	  else    
	   sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end  
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end    
	 end,     
	Calculation=      
	Case     
	 When max(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
		End
	  else    
	   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    

	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end    
	 
	 End    
	From      
	(
	Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPart.Code) as FCode,
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	Max(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end*(Case When RArrDet.Limit<>0 Then RArrDet.Limit/RArrHeader.TAmount Else 1 end)) AS GROSS,          
	Max(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end) as NetRateProrata,    
	Max(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end) as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
	from @Acceptance Acceptance
	Inner Join RArrheader on (RArrHeader.ANO=Acceptance.ANO)
	Inner Join ICalc on (ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0)
	Inner Join PCalc on (PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency)
	Inner Join DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D on (D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    )
	Inner Join @RARRDET RArrDet on (RArrDet.AType<>'C' and RArrDet.FullCoverF=0 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID)
	Inner Join FPartDet FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID)
	Inner Join RateCov on (RateCov.Code=FPart.Code and RateCov.TOR=ICalc.TOR)
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)
	Where Acceptance.ANO=@P_ANO 
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
	 When max(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
	  else    
		sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end    
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			max(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*max(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end  
	 end,

	Calculation=      
	Case     
	 When max(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
		End
	  else    
	   '- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Facultative_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    
	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				'- ' + convert(varchar(25), Cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(max(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),0)+'%'    		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				'- ' + convert(varchar(25), max(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), max(ICalc.NetRate),0)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end     
	 End    

	From      
	(
	Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPart.Code) as FCode,
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	Max(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end*(Case When RArrDet.Limit<>0 Then RArrDet.Limit/RArrHeader.TAmount Else 1 end)) AS GROSS,          
	Max(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end) as NetRateProrata,    
	Max(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,case WHen RArrDet.SDate>ICalc.SDate Then RArrDet.Sdate else ICalc.SDate end, Case When RArrDet.EDate<ICalc.EDate then RArrDet.EDate else ICalc.EDate end) as float) end) as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(pAcceptance.AType) as AType,
	Max(pAcceptance.EMethod) as EMethod,
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
	from @Acceptance pAcceptance
	Inner Join Acceptance on (Acceptance.ANO=pAcceptance.pANO)
	Inner Join RArrheader on (RArrHeader.ANO=Acceptance.ANO)
	Inner Join ICalc on (ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0)
	Inner Join PCalc on (PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency)
	Inner Join DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D on (D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR)
	Inner Join RArrDet on (RArrDet.AType<>'C' and RArrDet.Status in ('A','R') and RArrDet.FullCoverF=0 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID)
	Inner Join FPartDet FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID)
	Inner Join RateCov on (RateCov.Code=FPart.Code and RateCov.TOR=ICalc.TOR)
	Inner Join @RARRDET nRArrDet on (nRArrDet.ANO=pAcceptance.ANO and nRArrDet.FID=@P_FID)
	Inner Join Cover on (Cover.CNO=Acceptance.CNO)
	Where pAcceptance.ANO=@P_ANO 
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj 
	) ICalc
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj        
END
    
RETURN
END


GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION 
end
GO
CREATE FUNCTION DISPLAY_FACULTATIVE_BALANCE_PRORATA_CALCULATION(@P_ANO int, @P_FID Varchar(20))          
-- From Display_Prorata Calculation   
-- RCalc.Sdate Replaced with (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end) 
-- RCalc.Edate Replaced with (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end) 
-- Acceptance.AType Replaced with RArrDet.AType  
RETURNS TABLE  AS          
RETURN (          
select          
Distinct          
RCalc.ANO,          
RCalc.Code,          
RCalc.Currency,          
RCalc.Sdate,
RCalc.EDate,
Prorata_Calculation=        
case        
When RArrDet.AType<>'N' then        

 case        
 when DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 then ''
 when DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>0 then ''        
 Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),0)+'%' else '' end        
  Else        
	--Prorata Calculation
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)=Acceptance.EDate Then
		dbo.fn_calc_sprorata(acceptance.pDate, dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)
	else
		dbo.fn_calc_sprorata(acceptance.pDate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)
	End
  End
 End        
Else        
 ''        
end,        
          
Prorata=        
case        
When RArrDet.AType<>'N' then        
 case        
 when DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 then 0        
 when DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>0 then 1        
 Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end        
  Else        
	--Prorata Calculation
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)=Acceptance.EDate Then
		dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)
	else
		dbo.fn_calc_prorata(acceptance.pDate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)
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
inner join RArrDet on (RArrDet.ANO=Acceptance.ANO and RArrDet.FID=@P_FID)    
inner Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)        
Where RArrDet.AType not in ('A','C')        
and not (RArrDet.AType<>'N' and (RCover.NoRefundF=1 or RArrDet.NoRefundF=1 or Acceptance.NoRefundF in (2) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end)) <= 0)))
and Acceptance.ANO=@P_ANO        
            
Union All          
            
select          
Distinct          
RCalc.ANO,          
RCalc.Code,          
RCalc.Currency,          
RCalc.Sdate,
RCalc.EDate,
Prorata_Calculation=        
case        
when DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''        
when DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''        

Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),0)+'%' else '' end        
  Else        
    case        
		When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then        
			--Prorata Calculation
			Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)=pAcceptance.EDate Then
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
					'('+dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)+') ^ 2'
				ELSE
					CASE WHEN RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)
					Else
						dbo.fn_Calc_SProrata(acceptance.pDate, dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)
					End
				END				
			else
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
					'('+dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)+') ^ 2'
				ELSE
					CASE WHEN RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_Calc_SProrata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)
					Else
						dbo.fn_Calc_SProrata(acceptance.pDate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)
					End
				END				
			End

		Else        
		 -- Endorsement Period        
			''        
		End       
	End        
End        
+ (Case When Acceptance.CPCT=0 and Acceptance.AType='C' and Acceptance.EMethod<>'A' and NRarrDet.CPRefund<>0 Then ' x '+convert(varchar(25),NRArrDet.CPRefund,0)+'%' else '' end)

,        
Prorata=        
case        
when DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0        
when DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end))>0  and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1        

Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end        
  Else        
    case        
		When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then        
			--Prorata Calculation
			Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)=pAcceptance.EDate Then
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
					POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod),2)
				ELSE
					CASE WHEN RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end))), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)
					Else
						dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), dateadd(day,1,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), Cover.PPeriod)
					End
				END				
			else
				CASE WHEN RCOVER.CPFORMULA = 'PRORATE SQ' and RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
					POWER(dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod),2)
				ELSE
					CASE WHEN RArrDet.AType='C' and Acceptance.EMethod<>'A' THEN
						dbo.fn_calc_prorata(dbo.fn_Get_Effective_Cancellation_By_Payor_Schedule(Acceptance.ANO, Acceptance.PDate,(Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end)), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)
					Else
						dbo.fn_calc_prorata(acceptance.pDate, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end), (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), Cover.PPeriod)
					End
				END				
			End
		Else        
		 -- Endorsement Period        
			1        
		End        
	End        
End        
* (Case When Acceptance.CPCT=0 and Acceptance.AType='C' and Acceptance.EMethod<>'A' and NRarrDet.CPRefund<>0 Then NRarrDet.CPRefund/100 else 1 end)
	             
From acceptance          
inner Join Cover on (Cover.CNO=Acceptance.CNO)          
inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)          
inner join PCalc on (PCalc.ANO=pAcceptance.ANO)          
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)     
inner join RArrDet NRArrDet on (NRArrDet.ANO=Acceptance.ANO and NRArrDet.FID=@P_FID)         
inner join RArrDet on (RArrDet.ANO=pAcceptance.ANO and RArrDet.FID=@P_FID)         
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=Rcalc.Code and ((RCover.SDate=Acceptance.SDate and RCover.EDate=Acceptance.EDate and RCalc.SDate=pAcceptance.SDate and RCalc.EDate=pAcceptance.EDate) or (RCover.SDate=RCalc.SDate)))
Where NRArrDet.AType<>'A' and Not (NRArrDet.AType='C' and Acceptance.EMethod='A') and RArrDet.AType not in ('A','C')        
and Not (NRArrDet.AType<>'N' and (coalesce(RCover.NoRefundF,0)=1 or NRArrDet.NoRefundF=1 or Acceptance.NoRefundF in (2) or (Acceptance.NoRefundF in (1) and DateDiff(day, acceptance.pdate, (Case When Datediff(day, RArrDet.SDate, RCalc.SDate)>=0 Then RCalc.SDate else RArrDet.SDate end)) <= 0)))
and Not (DateDiff(day, (Case When Datediff(day, RCalc.EDate, RArrDet.EDate)>=0 Then RCalc.EDate else RArrDet.EDate end), acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate)
and Acceptance.ANO=@P_ANO        
)



go




