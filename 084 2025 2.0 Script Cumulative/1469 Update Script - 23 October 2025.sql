/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ApplyApprLimitOCF' AND Object_ID = Object_ID(N'TOC'))

BEGIN

ALTER TABLE dbo.TOC ADD
	ApplyApprLimitOCF bit NULL

End

GO
DECLARE @v sql_variant 
SET @v = N'Apply Approval Limit for Open Cover Certificate (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'ApplyApprLimitOCF'
GO
Update TOC Set ApplyApprLimitOCF=0 Where ApplyApprLimitOCF is null
GO
COMMIT
GO
DROP Procedure QApproval_Production
GO
CREATE Procedure QApproval_Production (@P_ANO integer)              
AS

Declare @ApplyApprLimitByAccRegF as Bit
Declare @ApplyApprLimitByTOLF as Bit
Declare @ApplyApprLimitOCF as Bit
Declare @LANO as int
Declare @OpenFlag as Bit
Declare @TOC as varchar(10)
Declare @Branch as varchar(10)
Declare @ISType as varchar(10)
Declare @PHolder as varchar(10)
Declare @NoRiskAccumulationF as Bit


Select @NoRiskAccumulationF=A.NoRiskAccumulationF, @TOC=A.TOC, @Branch=A.Branch, @ISType=C.ISType, @PHolder=C.PHolder, @LANO=A.LANO, @OpenFlag=C.OpenFlag, @ApplyApprLimitByTOLF=TOC.ApplyApprLimitByTOLF, @ApplyApprLimitByAccRegF=TOC.ApplyApprLimitByAccRegF, @ApplyApprLimitOCF=TOC.ApplyApprLimitOCF
from Acceptance A
Inner Join Cover C on (C.CNO=A.CNO)
Inner Join TOC on (TOC.TOC=A.TOC)
Where A.ANO=@P_ANO

if @ApplyApprLimitByAccRegF=0 
	if @P_ANO<>@LANO
	Begin
		if @OpenFlag=0
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
		else
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			cast(0 as Float) as TotalAmount		
			From Acceptance
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			-- No Master Acceptance Limit Of Liability
			and (@ApplyApprLimitOCF=1 or not exists (Select Top 1 mA.ANO from Acceptance mA Inner Join ICover I on (I.ANO=mA.ANO) Where mA.ANO=Acceptance.LANO and I.Category='M' and I.Amount<>0))
	end
	else 
	Begin
		if @OpenFlag=1	--Master Open Cover
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			100 as ApprLimitPct,  
			sum(ICover.Amount*dbo.fn_GetReinsuranceRate(Acceptance.TOC,ICover.Currency,Acceptance.SDate,@PHolder)) 
			* coalesce((Select sum(Share) from ISource Where ISource.CNO=Acceptance.CNO),100)/100				
			* (100-coalesce((Select sum(Share) from Coinsurance Where CNO=Acceptance.CNO),0))/100				
			as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join ICover on (ICover.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			and ICover.Category='M'
			Group by Acceptance.CNO, Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
		else
			if @NoRiskAccumulationF=0
				SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
				@Branch as Branch,    
				@TOC as TOC, 
				@ISType as ISType,
				Max(Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
				sum(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
				cast(0 as Float) as TotalAmount
				From Acceptance mA
				Inner join Acceptance omA on (omA.OANO=mA.OANO)
				Inner Join Acceptance on (Acceptance.LANO=omA.ANO)
				Left Join Acceptance nAcceptance on (nAcceptance.pANO=Acceptance.ANO)
				Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
				WHERE mA.ANO=@P_ANO 
				and Acceptance.AType not in ('A','C') and Acceptance.AStatus in ('W','T','I') 
				and (coalesce(nAcceptance.ANO,0)=0 or (coalesce(nAcceptance.LANO,0)=mA.ANO and coalesce(nAcceptance.AType,'')='C' and mA.AType='C'))
				Group By Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
				Order By sum(RArrHeader.TAmount-RArrHeader.MAmount) Desc            
			else
				SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
				@Branch as Branch,    
				@TOC as TOC, 
				@ISType as ISType,
				Max(Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
				sum(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
				cast(0 as Float) as TotalAmount
				From Acceptance mA
				Inner Join Acceptance on (Acceptance.LANO=mA.ANO and Acceptance.RegNo=mA.RegNo)
				Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
				WHERE mA.ANO=@P_ANO 
				Group By Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
				Order By sum(RArrHeader.TAmount-RArrHeader.MAmount) Desc            
	end
else
	if @P_ANO<>@LANO
	Begin
		if @OpenFlag=0
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) as TotalAmount
			From Acceptance
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
		else
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) as TotalAmount
			From Acceptance
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			-- No Master Acceptance Limit Of Liability
			and (@ApplyApprLimitOCF=1 or not exists (Select Top 1 mA.ANO from Acceptance mA Inner Join ICover I on (I.ANO=mA.ANO) Where mA.ANO=Acceptance.LANO and I.Category='M' and I.Amount<>0))
	end
	else 
	Begin
		if @OpenFlag=1	--Master Open Cover
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			100 as ApprLimitPct,  
			sum(ICover.Amount*dbo.fn_GetReinsuranceRate(Acceptance.TOC,ICover.Currency,Acceptance.SDate,@PHolder)) 
			* coalesce((Select sum(Share) from ISource Where ISource.CNO=Acceptance.CNO),100)/100				
			* (100-coalesce((Select sum(Share) from Coinsurance Where CNO=Acceptance.CNO),0))/100				
			as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join ICover on (ICover.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			and ICover.Category='M'
			Group by Acceptance.CNO, Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
		else
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo, 
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Max(Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
			Sum(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			Sum(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Min(Acceptance.SDate),Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Max(mA.OANO)),0) as TotalAmount
			From Acceptance mA
			Inner join Acceptance omA on (omA.OANO=mA.OANO)
			Inner Join Acceptance on (Acceptance.LANO=omA.ANO)
			Left Join Acceptance nAcceptance on (nAcceptance.pANO=Acceptance.ANO)
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE mA.ANO=@P_ANO 
			and Acceptance.AType not in ('A','C') and Acceptance.AStatus in ('W','T','I') 
			and (coalesce(nAcceptance.ANO,0)=0 or (coalesce(nAcceptance.LANO,0)=mA.ANO and coalesce(nAcceptance.AType,'')='C' and mA.AType='C'))
			Group By Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
			Order By Sum(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Min(Acceptance.SDate),Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Max(mA.OANO)),0) Desc  

	end


GO

DROP Function FN_Approval_Production
GO
CREATE Function FN_Approval_Production(@P_ANO int)   
RETURNS @Table TABLE (REGID varchar(10), FLDID varchar(255), VALUEID varchar(255), CertificateNo varchar(10), Branch varchar(10), TOC varchar(10), ISType varchar(10), ApprLimitPCT Float, Amount Float, TotalAmount Float)  
AS   
BEGIN   
Declare @ApplyApprLimitByAccRegF as Bit
Declare @ApplyApprLimitByTOLF as Bit
Declare @ApplyApprLimitOCF as Bit
Declare @LANO as int
Declare @OpenFlag as Bit
Declare @TOC as varchar(10)
Declare @Branch as varchar(10)
Declare @ISType as varchar(10)
Declare @PHolder as varchar(10)

Declare @NoRiskAccumulationF as Bit

Select @NoRiskAccumulationF=A.NoRiskAccumulationF, @TOC=A.TOC, @Branch=A.Branch, @ISType=C.ISType, @PHolder=C.PHolder, @LANO=A.LANO, @OpenFlag=C.OpenFlag, @ApplyApprLimitByTOLF=TOC.ApplyApprLimitByTOLF, @ApplyApprLimitByAccRegF=TOC.ApplyApprLimitByAccRegF, @ApplyApprLimitOCF=TOC.ApplyApprLimitOCF

from Acceptance A
Inner Join Cover C on (C.CNO=A.CNO)
Inner Join TOC on (TOC.TOC=A.TOC)
Where A.ANO=@P_ANO

if @ApplyApprLimitByAccRegF=0 
	if @P_ANO<>@LANO
	Begin
		if @OpenFlag=0
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
		else
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			-- No Master Acceptance Limit Of Liability
			and (@ApplyApprLimitOCF=1 or not exists (Select Top 1 mA.ANO from Acceptance mA Inner Join ICover I on (I.ANO=mA.ANO) Where mA.ANO=Acceptance.LANO and I.Category='M' and I.Amount<>0))			
	end
	else 
	Begin
		if @OpenFlag=1	--Master Open Cover
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			100 as ApprLimitPct,  
			sum(ICover.Amount*dbo.fn_GetReinsuranceRate(Acceptance.TOC,ICover.Currency,Acceptance.SDate,@PHolder)) 
			* coalesce((Select sum(Share) from ISource Where ISource.CNO=Acceptance.CNO),100)/100				
			* (100-coalesce((Select sum(Share) from Coinsurance Where CNO=Acceptance.CNO),0))/100				
			as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join ICover on (ICover.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			and ICover.Category='M'
			Group by Acceptance.CNO, Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
		else
			if @NoRiskAccumulationF=0 
				Insert into @Table
				SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
				@Branch as Branch,    
				@TOC as TOC, 
				@ISType as ISType,
				Max(Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
				sum(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
				cast(0 as Float) as TotalAmount
				From Acceptance mA
				Inner join Acceptance omA on (omA.OANO=mA.OANO)
				Inner Join Acceptance on (Acceptance.LANO=omA.ANO)
				Left Join Acceptance nAcceptance on (nAcceptance.pANO=Acceptance.ANO)
				Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
				WHERE mA.ANO=@P_ANO 
				and Acceptance.AType not in ('A','C') and Acceptance.AStatus in ('W','T','I') 
				and (coalesce(nAcceptance.ANO,0)=0 or (coalesce(nAcceptance.LANO,0)=mA.ANO and coalesce(nAcceptance.AType,'')='C' and mA.AType='C'))
				Group By Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
				Order By sum(RArrHeader.TAmount-RArrHeader.MAmount) Desc            
			else
				Insert into @Table
				SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
				@Branch as Branch,    
				@TOC as TOC, 
				@ISType as ISType,
				Max(Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
				sum(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
				cast(0 as Float) as TotalAmount
				From Acceptance mA
				Inner Join Acceptance on (Acceptance.LANO=mA.ANO and Acceptance.RegNo=mA.RegNo)
				Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
				WHERE mA.ANO=@P_ANO 
				Group By Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
				Order By sum(RArrHeader.TAmount-RArrHeader.MAmount) Desc            
	end
else
	if @P_ANO<>@LANO
	Begin
		if @OpenFlag=0
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) as TotalAmount
			From Acceptance
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
		else
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) as TotalAmount
			From Acceptance
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			-- No Master Acceptance Limit Of Liability
			and (@ApplyApprLimitOCF=1 or not exists (Select Top 1 mA.ANO from Acceptance mA Inner Join ICover I on (I.ANO=mA.ANO) Where mA.ANO=Acceptance.LANO and I.Category='M' and I.Amount<>0))
	end
	else 
	Begin
		if @OpenFlag=1	--Master Open Cover
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			100 as ApprLimitPct,  
			sum(ICover.Amount*dbo.fn_GetReinsuranceRate(Acceptance.TOC,ICover.Currency,Acceptance.SDate,@PHolder)) 
			* coalesce((Select sum(Share) from ISource Where ISource.CNO=Acceptance.CNO),100)/100				
			* (100-coalesce((Select sum(Share) from Coinsurance Where CNO=Acceptance.CNO),0))/100				
			as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join ICover on (ICover.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			and ICover.Category='M'
			Group by Acceptance.CNO, Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
		else
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			@Branch as Branch,    
			@TOC as TOC, 
			@ISType as ISType,
			Max(Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
			Sum(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			Sum(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Min(Acceptance.SDate),Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Max(mA.OANO)),0) as TotalAmount
			From Acceptance mA
			Inner join Acceptance omA on (omA.OANO=mA.OANO)
			Inner Join Acceptance on (Acceptance.LANO=omA.ANO)
			Left Join Acceptance nAcceptance on (nAcceptance.pANO=Acceptance.ANO)
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE mA.ANO=@P_ANO 
			and Acceptance.AType not in ('A','C') and Acceptance.AStatus in ('W','T','I') 
			and (coalesce(nAcceptance.ANO,0)=0 or (coalesce(nAcceptance.LANO,0)=mA.ANO and coalesce(nAcceptance.AType,'')='C' and mA.AType='C'))
			Group By Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
			Order By Sum(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Min(Acceptance.SDate),Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Max(mA.OANO)),0) Desc  
	end

	Return
END

go

insert into PatchVersioning
select '1469 Update Script - 23 October 2025.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1469 Update Script - 23 October 2025.sql'


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

GO 
