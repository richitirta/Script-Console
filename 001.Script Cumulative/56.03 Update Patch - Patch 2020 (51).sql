
insert into PatchVersioning
select '56.3 Update Patch - Patch 2020 (51)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='56.3 Update Patch - Patch 2020 (51)'


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
			DROP Function fn_GetReinsuranceRate
       END TRY  
       BEGIN CATCH  
       END CATCH;

	    BEGIN TRY            
			DROP Function FN_Approval_Production
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End


GO

CREATE Function fn_GetReinsuranceRate(@P_TOC as varchar(10), @P_Currency as varchar(10), @P_SDate as smalldatetime, @P_PHolder as varchar(10))        
RETURNS Float AS          
BEGIN        
Declare @CCYTO as varchar(10)
Declare @RateTo as Float

Declare @BaseCCY as varchar(10)
Declare @Rate as float


Select @BaseCCY=Currency from SysTab
Select @Rate=1

if @P_Currency<>@BaseCCY
Begin 
	Select @CCYTO = @P_Currency
	While @CCYTO<>''
	Begin
		Select @P_Currency= @CCYTO

		SELECT @RateTo=ReRate.Rate, @CCYTO=ReRate.CCYTo   
		From ReRate
		Where 
		ReRate.TOC=@P_TOC
		and ReRate.Currency=@P_Currency
		and ReRate.RYear=coalesce((   
		 Select Top 1 R1.RYear   
		 from Reinsurance R1, ReClass R2   
		 Left Join RePolicy R3 on (R3.RNO=R2.RNO and R3.ID=@P_PHolder)   
		 Where (R1.Category<>'P' or Coalesce(R3.ID,'')<>'') and R1.RType='Q' and R2.RNO=R1.RNO and R2.TOC=@P_TOC and @P_SDate Between R1.SDate and R1.EDate   
		 Order By coalesce(R3.ID,'') Desc, (Case When R2.PriorityF=1 Then R2.PriorityF else R1.PriorityF end) Desc),Year(@P_SDate)) 	

		Select @Rate = @Rate * coalesce(@RateTo,1)

		if coalesce(@CCYTo,'')='' or coalesce(@CCYTo,'')=@P_Currency or coalesce(@CCYTo,'')=@BaseCCY 
			Break
	End
End

return @Rate
End

GO

DROP Procedure QApproval_Production 
GO
CREATE Procedure QApproval_Production (@P_ANO integer)              
AS

Declare @ApplyApprLimitByAccRegF as Bit
Declare @ApplyApprLimitByTOLF as Bit
Declare @LANO as int
Declare @OpenFlag as Bit

Select @LANO=A.LANO, @OpenFlag=C.OpenFlag, @ApplyApprLimitByTOLF=TOC.ApplyApprLimitByTOLF, @ApplyApprLimitByAccRegF=TOC.ApplyApprLimitByAccRegF
from Acceptance A, Cover C, TOC
Where TOC.TOC=C.TOC and C.CNO=A.CNO and A.ANO=@P_ANO

if @ApplyApprLimitByAccRegF=0 
	if @P_ANO<>@LANO
	Begin
		if @OpenFlag=0
			SELECT top 1 Acceptance.PolicyNo, Acceptance.CertificateNo, 
			Acceptance.Branch as Branch,    
			Cover.TOC, Cover.ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			cast(0 as float) as TotalAmount
			From Acceptance, Cover, RARRHEADER
			WHERE Acceptance.ANO=@P_ANO
			and Cover.CNO=Acceptance.CNO and RARRHEADER.ANO=ACCEPTANCE.ANO              
		else
			SELECT top 1 Acceptance.PolicyNo, Acceptance.CertificateNo, 
			Acceptance.Branch as Branch,    
			Cover.TOC, Cover.ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			cast(0 as float) as TotalAmount
			From Acceptance, Cover, RARRHEADER
			WHERE Acceptance.ANO=@P_ANO
			and Cover.CNO=Acceptance.CNO and RARRHEADER.ANO=ACCEPTANCE.ANO              
			-- No Master Acceptance Limit Of Liability
			and not exists (Select Top 1 mA.ANO from Acceptance mA, ICover I Where mA.ANO=Acceptance.LANO and I.ANO=mA.ANO and I.Category='M' and I.Amount<>0)			
	end
	else 
	Begin
		if @OpenFlag=1	--Master Open Cover
			SELECT top 1 Acceptance.PolicyNo, Acceptance.CertificateNo, 
			Acceptance.Branch as Branch,    
			Cover.TOC, Cover.ISType,
			100 as ApprLimitPct,  
			sum(ICover.Amount*dbo.fn_GetReinsuranceRate(Acceptance.TOC,ICover.Currency,Acceptance.SDate,Cover.PHolder)) 
			* coalesce((Select sum(Share) from ISource Where ISource.CNO=Acceptance.CNO),100)/100				
			* (100-coalesce((Select sum(Share) from Coinsurance Where CNO=Acceptance.CNO),0))/100				
			as Amount,
			cast(0 as float) as TotalAmount
			From Acceptance, Cover, ICover
			WHERE Acceptance.ANO=@P_ANO
			and Cover.CNO=Acceptance.CNO and ICover.ANO=Acceptance.ANO and ICover.Category='M'
			Group by Acceptance.CNO, Acceptance.PolicyNo, 
			Acceptance.CertificateNo,
			Acceptance.Branch,    
			Cover.TOC, Cover.ISType
		else
			SELECT top 1 Acceptance.PolicyNo, Acceptance.CertificateNo, 
			Acceptance.Branch as Branch,    
			Cover.TOC, Cover.ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			cast(0 as float) as TotalAmount
			From Acceptance, Cover, RARRHEADER
			WHERE Acceptance.LANO=@P_ANO
			and Cover.CNO=Acceptance.CNO and RARRHEADER.ANO=ACCEPTANCE.ANO              
			Order By (RArrHeader.TAmount-RArrHeader.MAmount) Desc            
	end
else
	if @P_ANO<>@LANO
	Begin
		if @OpenFlag=0
			SELECT top 1 Acceptance.PolicyNo, Acceptance.CertificateNo, 
			Acceptance.Branch as Branch,    
			Cover.TOC, Cover.ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) as TotalAmount
			From Acceptance, Cover, RARRHEADER
			WHERE Acceptance.ANO=@P_ANO
			and Cover.CNO=Acceptance.CNO and RARRHEADER.ANO=ACCEPTANCE.ANO              
		else
			SELECT top 1 Acceptance.PolicyNo, Acceptance.CertificateNo, 
			Acceptance.Branch as Branch,    
			Cover.TOC, Cover.ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) as TotalAmount
			From Acceptance, Cover, RARRHEADER
			WHERE Acceptance.ANO=@P_ANO
			and Cover.CNO=Acceptance.CNO and RARRHEADER.ANO=ACCEPTANCE.ANO              
			-- No Master Acceptance Limit Of Liability
			and not exists (Select Top 1 mA.ANO from Acceptance mA, ICover I Where mA.ANO=Acceptance.LANO and I.ANO=mA.ANO and I.Category='M' and I.Amount<>0)			
	end
	else 
	Begin
		if @OpenFlag=1	--Master Open Cover
			SELECT top 1 Acceptance.PolicyNo, Acceptance.CertificateNo, 
			Acceptance.Branch as Branch,    
			Cover.TOC, Cover.ISType,
			100 as ApprLimitPct,  
			sum(ICover.Amount*dbo.fn_GetReinsuranceRate(Acceptance.TOC,ICover.Currency,Acceptance.SDate,Cover.PHolder)) 
			* coalesce((Select sum(Share) from ISource Where ISource.CNO=Acceptance.CNO),100)/100				
			* (100-coalesce((Select sum(Share) from Coinsurance Where CNO=Acceptance.CNO),0))/100				
			as Amount,
			cast(0 as float) as TotalAmount
			From Acceptance, Cover, ICover
			WHERE Acceptance.ANO=@P_ANO
			and Cover.CNO=Acceptance.CNO and ICover.ANO=Acceptance.ANO and ICover.Category='M'
			Group by Acceptance.CNO, Acceptance.PolicyNo, 
			Acceptance.CertificateNo,
			Acceptance.Branch,    
			Cover.TOC, Cover.ISType
		else
			SELECT top 1 Acceptance.PolicyNo, Acceptance.CertificateNo, 
			Acceptance.Branch as Branch,    
			Cover.TOC, Cover.ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) as TotalAmount
			From Acceptance, Cover, RARRHEADER
			WHERE Acceptance.LANO=@P_ANO
			and Cover.CNO=Acceptance.CNO and RARRHEADER.ANO=ACCEPTANCE.ANO              
			Order By (RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) Desc            
	end


GO



GO
CREATE Function FN_Approval_Production(@P_ANO int)   
RETURNS @Table TABLE (PolicyNo varchar(50), CertificateNo varchar(50), Branch varchar(10), TOC varchar(10), ISType varchar(10), ApprLimitPCT Float, Amount Float, TotalAmount Float)  
AS   
BEGIN   
Declare @ApplyApprLimitByAccRegF as Bit
Declare @ApplyApprLimitByTOLF as Bit
Declare @LANO as int
Declare @OpenFlag as Bit

Select @LANO=A.LANO, @OpenFlag=C.OpenFlag, @ApplyApprLimitByTOLF=TOC.ApplyApprLimitByTOLF, @ApplyApprLimitByAccRegF=TOC.ApplyApprLimitByAccRegF
from Acceptance A, Cover C, TOC
Where TOC.TOC=C.TOC and C.CNO=A.CNO and A.ANO=@P_ANO

if @ApplyApprLimitByAccRegF=0 
	if @P_ANO<>@LANO
	Begin
		if @OpenFlag=0
			insert into @Table
			SELECT top 1 Acceptance.PolicyNo, Acceptance.CertificateNo, 
			Acceptance.Branch as Branch,    
			Cover.TOC, Cover.ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			cast(0 as float) as TotalAmount
			From Acceptance, Cover, RARRHEADER
			WHERE Acceptance.ANO=@P_ANO
			and Cover.CNO=Acceptance.CNO and RARRHEADER.ANO=ACCEPTANCE.ANO              
		else
			insert into @Table
			SELECT top 1 Acceptance.PolicyNo, Acceptance.CertificateNo, 
			Acceptance.Branch as Branch,    
			Cover.TOC, Cover.ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			cast(0 as float) as TotalAmount
			From Acceptance, Cover, RARRHEADER
			WHERE Acceptance.ANO=@P_ANO
			and Cover.CNO=Acceptance.CNO and RARRHEADER.ANO=ACCEPTANCE.ANO              
			-- No Master Acceptance Limit Of Liability
			and not exists (Select Top 1 mA.ANO from Acceptance mA, ICover I Where mA.ANO=Acceptance.LANO and I.ANO=mA.ANO and I.Category='M' and I.Amount<>0)			
	end
	else 
	Begin
		if @OpenFlag=1	--Master Open Cover
			insert into @Table
			SELECT top 1 Acceptance.PolicyNo, Acceptance.CertificateNo, 
			Acceptance.Branch as Branch,    
			Cover.TOC, Cover.ISType,
			100 as ApprLimitPct,  
			sum(ICover.Amount*dbo.fn_GetReinsuranceRate(Acceptance.TOC,ICover.Currency,Acceptance.SDate,Cover.PHolder)) 
			* coalesce((Select sum(Share) from ISource Where ISource.CNO=Acceptance.CNO),100)/100				
			* (100-coalesce((Select sum(Share) from Coinsurance Where CNO=Acceptance.CNO),0))/100				
			as Amount,
			cast(0 as float) as TotalAmount
			From Acceptance, Cover, ICover
			WHERE Acceptance.ANO=@P_ANO
			and Cover.CNO=Acceptance.CNO and ICover.ANO=Acceptance.ANO and ICover.Category='M'
			Group by Acceptance.CNO, Acceptance.PolicyNo, 
			Acceptance.CertificateNo,
			Acceptance.Branch,    
			Cover.TOC, Cover.ISType
		else
			insert into @Table
			SELECT top 1 Acceptance.PolicyNo, Acceptance.CertificateNo, 
			Acceptance.Branch as Branch,    
			Cover.TOC, Cover.ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			cast(0 as float) as TotalAmount
			From Acceptance, Cover, RARRHEADER
			WHERE Acceptance.LANO=@P_ANO
			and Cover.CNO=Acceptance.CNO and RARRHEADER.ANO=ACCEPTANCE.ANO              
			Order By (RArrHeader.TAmount-RArrHeader.MAmount) Desc            
	end
else
	if @P_ANO<>@LANO
	Begin
		if @OpenFlag=0
			insert into @Table
			SELECT top 1 Acceptance.PolicyNo, Acceptance.CertificateNo, 
			Acceptance.Branch as Branch,    
			Cover.TOC, Cover.ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) as TotalAmount
			From Acceptance, Cover, RARRHEADER
			WHERE Acceptance.ANO=@P_ANO
			and Cover.CNO=Acceptance.CNO and RARRHEADER.ANO=ACCEPTANCE.ANO              
		else
			insert into @Table
			SELECT top 1 Acceptance.PolicyNo, Acceptance.CertificateNo, 
			Acceptance.Branch as Branch,    
			Cover.TOC, Cover.ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) as TotalAmount
			From Acceptance, Cover, RARRHEADER
			WHERE Acceptance.ANO=@P_ANO
			and Cover.CNO=Acceptance.CNO and RARRHEADER.ANO=ACCEPTANCE.ANO              
			-- No Master Acceptance Limit Of Liability
			and not exists (Select Top 1 mA.ANO from Acceptance mA, ICover I Where mA.ANO=Acceptance.LANO and I.ANO=mA.ANO and I.Category='M' and I.Amount<>0)			
	end
	else 
	Begin
		if @OpenFlag=1	--Master Open Cover
			insert into @Table
			SELECT top 1 Acceptance.PolicyNo, Acceptance.CertificateNo, 
			Acceptance.Branch as Branch,    
			Cover.TOC, Cover.ISType,
			100 as ApprLimitPct,  
			sum(ICover.Amount*dbo.fn_GetReinsuranceRate(Acceptance.TOC,ICover.Currency,Acceptance.SDate,Cover.PHolder)) 
			* coalesce((Select sum(Share) from ISource Where ISource.CNO=Acceptance.CNO),100)/100				
			* (100-coalesce((Select sum(Share) from Coinsurance Where CNO=Acceptance.CNO),0))/100				
			as Amount,
			cast(0 as float) as TotalAmount
			From Acceptance, Cover, ICover
			WHERE Acceptance.ANO=@P_ANO
			and Cover.CNO=Acceptance.CNO and ICover.ANO=Acceptance.ANO and ICover.Category='M'
			Group by Acceptance.CNO, Acceptance.PolicyNo, 
			Acceptance.CertificateNo,
			Acceptance.Branch,    
			Cover.TOC, Cover.ISType
		else
			insert into @Table
			SELECT top 1 Acceptance.PolicyNo, Acceptance.CertificateNo, 
			Acceptance.Branch as Branch,    
			Cover.TOC, Cover.ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) as TotalAmount
			From Acceptance, Cover, RARRHEADER
			WHERE Acceptance.LANO=@P_ANO
			and Cover.CNO=Acceptance.CNO and RARRHEADER.ANO=ACCEPTANCE.ANO              
			Order By (RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) Desc            
	end

	Return
END
