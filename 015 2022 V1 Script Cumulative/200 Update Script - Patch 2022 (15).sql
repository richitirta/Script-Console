DROP Function Premium_MaxOutGo_VAT
GO
CREATE Function Premium_MaxOutGo_VAT(@P_ANO as int,@P_Code as varchar(10),@P_Period Int, @P_MinimumPremiumF Bit)                
RETURNS Float                
AS                
BEGIN                
 Declare @GDiscount Float                
 Declare @PDiscount Float                
 Declare @Discount Float                
 Declare @RDiscount Float                
 Declare @RLoading Float
 Declare @ADiscount Float                
 Declare @MShare Float                
 Declare @VAT Float        
 Declare @DetailF bit               
 Declare @RegNo varchar(50)        
 Declare @AStatus varchar(1)        
 Declare @LANO int   
 Declare @OANO int
 Declare @GrossUpComm Float      
 Declare @ADate smalldatetime
      
 select @ADate=case when Acceptance.AUserID<>'' then Acceptance.ADate else cast(convert(varchar(10), getdate(),1) as smalldatetime) end, @ADiscount=Acceptance.Discount, @RegNo=Acceptance.RegNo, @Astatus=Acceptance.AStatus, @LANO=Acceptance.LANO, @OANO=Acceptance.OANO 
 from Acceptance
 Inner Join Cover on (Cover.CNO=Acceptance.CNO)
 Where Acceptance.ANO=@P_ANO                                     
        
 Select @GDiscount=GDiscount, @PDiscount=PDiscount, @Discount=Discount from Payor_Discount(@P_ANO,@P_Code,@P_Period)        
 Select @RDiscount=Discount, @RLoading=Loading from Rate_Discount(@P_ANO,@P_Code)                
 --Select @MShare=dbo.Member_Share(@P_ANO)                                     
 
 if @LANO=-1	
 BEGIN
	  Select @GrossUpComm=
	  sum(
	  coalesce(AccBSDet.Fee,AccBS.Fee)
	  *(
	  Case 
	  When GrossUpF=1 Then 1 
	  else -- NetUpF (Net after VAT and TAX)
		(
		100 +
		(case when @ADate<MParam.Effective then MParam.VatOLD When MParam.Vat>=0 then MParam.Vat else 0 end)*(Case When Profile.VATF=1 Then 1 else 0 end)
		-
		Case 
		When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
		When TaxType.MTaxType='PASAL23' then MParam.PASAL23
		When TaxType.MTaxType='PASAL26' then MParam.Pasal26
		When TaxType.MTaxType='PASAL4' then MParam.PASAL4
		else 0
		end 
		*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
		*(Case When Profile.TaxF=1 Then 1 else 0 end)
		)/100
	  end)
	  + AccBS.UpFee)
	  from Acceptance   
	  inner join AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)   
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
	  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
	  Inner Join Profile on (Profile.ID=AccBS.ID)
	  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
	  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  
          
	  if @GrossUpComm is null    
		 Select @GrossUpComm=0              
		 
	  Select @VAT=        
	   sum(  
	   (  
		Case 
		When AccBS.GrossF=1 then 
			coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading*100/(100-@RDiscount)  
		When AccBS.GrossBLF=1 Then
			coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading
		else  
			coalesce(AccBSDet.Fee,AccBS.Fee)  
		end *
		(  
		 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
		*  
		 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
		 )  
		+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
	   )
	   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
	   *(Case When Profile.VatF=1 Then (case when @ADate<MParam.Effective then MParam.VatOLD When MParam.Vat>=0 then MParam.Vat else 0 end)/100 else 0 end)   
	   )     
	  From Acceptance
	  Inner Join AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
	  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
	  Inner Join Profile on (Profile.ID=AccBS.ID)
	  Where Acceptance.ANO=@P_ANO 
	  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   
 END
 ELSE
 BEGIN
	 Select Top 1 @DetailF=1 from AAccBS Where ANO=@P_ANO                        
	 if @DetailF is null         
	 Begin
		if @RegNo='' or @AStatus in ('W','T')   
		Begin	
		  Select @GrossUpComm=
		  sum(
		  coalesce(AccBSDet.Fee,AccBS.Fee)
		  *(
		  Case 
		  When GrossUpF=1 Then 1 
		  else -- NetUpF (Net after VAT and TAX)
			(
			100 +
			(case when @ADate<MParam.Effective then MParam.VatOLD When MParam.Vat>=0 then MParam.Vat else 0 end)*(Case When Profile.VATF=1 Then 1 else 0 end)
			-
			Case 
			When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
			When TaxType.MTaxType='PASAL23' then MParam.PASAL23
			When TaxType.MTaxType='PASAL26' then MParam.Pasal26
			When TaxType.MTaxType='PASAL4' then MParam.PASAL4
			else 0
			end 
			*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
			*(Case When Profile.TaxF=1 Then 1 else 0 end)
			)/100
		  end)
		  + AccBS.UpFee)
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		  Select @VAT=        
		   sum(  
		   (  
			Case 
			When AccBS.GrossF=1 then 
				coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading*100/(100-@RDiscount)  
			When AccBS.GrossBLF=1 Then
				coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
		   *(Case When Profile.VatF=1 Then (case when @ADate<MParam.Effective then MParam.VatOLD When MParam.Vat>=0 then MParam.Vat else 0 end)/100 else 0 end)   
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  		  
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   		  		  
		end
		else
		Begin
		  Select @GrossUpComm=
		  sum(
		  coalesce(AccBSDet.Fee,AccBS.Fee)
		  *(
		  Case 
		  When GrossUpF=1 Then 1 
		  else -- NetUpF (Net after VAT and TAX)
			(
			100 +
			(case when @ADate<MParam.Effective then MParam.VatOLD When MParam.Vat>=0 then MParam.Vat else 0 end)*(Case When Profile.VATF=1 Then 1 else 0 end)
			-
			Case 
			When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
			When TaxType.MTaxType='PASAL23' then MParam.PASAL23
			When TaxType.MTaxType='PASAL26' then MParam.Pasal26
			When TaxType.MTaxType='PASAL4' then MParam.PASAL4
			else 0
			end 
			*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
			*(Case When Profile.TaxF=1 Then 1 else 0 end)
			)/100
		  end)
		  + AccBS.UpFee)
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)  
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		  Select @VAT=        
		   sum(  
		   (  
			Case 
			When AccBS.GrossF=1 then 
				coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading*100/(100-@RDiscount)  
			When AccBS.GrossBLF=1 Then
				coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
		   *(Case When Profile.VatF=1 Then (case when @ADate<MParam.Effective then MParam.VatOLD When MParam.Vat>=0 then MParam.Vat else 0 end)/100 else 0 end)   
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code and AccBSDet.InceptionF=0)
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))    		  		
		end
	 end
	 else
	 Begin
		  Select @GrossUpComm=
		  sum(
		  coalesce(AAccBSDet.Fee,AAccBS.Fee)
		  *(
		  Case 
		  When GrossUpF=1 Then 1 
		  else -- NetUpF (Net after VAT and TAX)
			(
			100 +
			(case when @ADate<MParam.Effective then MParam.VatOLD When MParam.Vat>=0 then MParam.Vat else 0 end)*(Case When Profile.VATF=1 Then 1 else 0 end)
			-
			Case 
			When TaxType.MTaxType='PASAL21' then MParam.PASAL21*(100-MParam.TAXDISCOUNT)/100
			When TaxType.MTaxType='PASAL23' then MParam.PASAL23
			When TaxType.MTaxType='PASAL26' then MParam.Pasal26
			When TaxType.MTaxType='PASAL4' then MParam.PASAL4
			else 0
			end 
			*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end)
			*(Case When Profile.TaxF=1 Then 1 else 0 end)
			)/100
		  end)
		  + AAccBS.UpFee)
		  From AAccBS 
		  Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code)   
		  Inner Join MParam on (MParam.Type='B'+AAccBS.BSType)
		  Inner Join Profile on (Profile.ID=AAccBS.ID)
		  Left Join TaxType on (TaxType.TaxType=Profile.TaxType)
		  Where AAccBS.ANO=@P_ANO and (AAccBS.GrossUpF=1 or AAccBS.NetUpF=1)    	 
		  
		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              		  
			 
		  Select @VAT=        
		   sum(  
		   (  
			Case 
			When AccBS.GrossF=1 then 
				coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading*100/(100-@RDiscount)  
			When AccBS.GrossBLF=1 Then
				coalesce(AccBSDet.Fee,AccBS.Fee)/@RLoading
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
		   *(Case When Profile.VatF=1 Then (case when @ADate<MParam.Effective then MParam.VatOLD When MParam.Vat>=0 then MParam.Vat else 0 end)/100 else 0 end)   
		   )     
		  From Acceptance
		  Inner Join AAccBS AccBS on (AccBS.ANO=Acceptance.ANO and AccBS.NoProrataF=0)
		  Left Join AAccBSDet AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)
		  Inner Join MParam on (MParam.Type='B'+AccBS.BSType)
		  Inner Join Profile on (Profile.ID=AccBS.ID)
		  Where Acceptance.ANO=@P_ANO 
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                      
	 end
 
 END
                        
 if @VAT is null                
   Select @VAT=0                
                        
 return(@VAT)                
End        


GO

DROP Function Premium_MaxOutGo
GO
CREATE Function Premium_MaxOutGo(@P_ANO as int,@P_Code as varchar(10),@P_Period int=0)        
RETURNS Float        
AS        

BEGIN        
 --Return (dbo.premium_discount(@P_ANO, @P_Code,@P_Period)-dbo.Payor_Group_Discount(@P_ANO, @P_Code,@P_Period)+dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)+dbo.Premium_Commission_Vat(@P_ANO, @P_Code,@P_Period,0))        
 --Return (dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)-dbo.Premium_Commission_UpFee(@P_ANO, @P_Code,@P_Period,0))  
 --Return (100/(100-dbo.premium_discount(@P_ANO, @P_Code,@P_Period))*(dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)-dbo.Premium_Commission_UpFee(@P_ANO, @P_Code,@P_Period,0)))
 --Return (dbo.premium_discount(@P_ANO, @P_Code,@P_Period)+dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)-dbo.Premium_Commission_UpFee(@P_ANO, @P_Code,@P_Period,0))  
 Return (dbo.premium_discount(@P_ANO, @P_Code,@P_Period)+dbo.Premium_Commission(@P_ANO, @P_Code,@P_Period,0)+dbo.Premium_MaxOutGo_VAT(@P_ANO, @P_Code,@P_Period,0)+dbo.Premium_HandlingFee(@P_ANO, @P_Code,@P_Period)-dbo.Premium_Commission_UpFee(@P_ANO, @P_Code,@P_Period,0))  
End      

go





 insert into PatchVersioning
select '200 Update Script - Patch 2022 (15)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='200 Update Script - Patch 2022 (15)'


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




go