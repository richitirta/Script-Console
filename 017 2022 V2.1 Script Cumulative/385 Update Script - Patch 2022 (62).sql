DROP Procedure QApproval_Production 
GO
CREATE Procedure QApproval_Production (@P_ANO integer)              
AS

Declare @ApplyApprLimitByAccRegF as Bit
Declare @ApplyApprLimitByTOLF as Bit
Declare @LANO as int
Declare @OpenFlag as Bit

Select @LANO=A.LANO, @OpenFlag=C.OpenFlag, @ApplyApprLimitByTOLF=TOC.ApplyApprLimitByTOLF, @ApplyApprLimitByAccRegF=TOC.ApplyApprLimitByAccRegF
from Acceptance A
Inner Join Cover C on (C.CNO=A.CNO)
Inner Join TOC on (TOC.TOC=A.TOC)
Where A.ANO=@P_ANO

if @ApplyApprLimitByAccRegF=0 
	if @P_ANO<>@LANO
	Begin
		if @OpenFlag=0
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			Acceptance.Branch as Branch,    
			Acceptance.TOC, Cover.ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join Cover on (Cover.CNO=Acceptance.CNO)
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
		else
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			Acceptance.Branch as Branch,    
			Acceptance.TOC, Cover.ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			cast(0 as Float) as TotalAmount		
			From Acceptance
			Inner Join Cover on (Cover.CNO=Acceptance.CNO)
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			-- No Master Acceptance Limit Of Liability
			and not exists (Select Top 1 mA.ANO from Acceptance mA Inner Join ICover I on (I.ANO=mA.ANO) Where mA.ANO=Acceptance.LANO and I.Category='M' and I.Amount<>0)			
	end
	else 
	Begin
		if @OpenFlag=1	--Master Open Cover
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			Max(Acceptance.Branch) as Branch,    
			Max(Acceptance.TOC) as TOC, 
			Max(Cover.ISType) as ISType,
			100 as ApprLimitPct,  
			sum(ICover.Amount*dbo.fn_GetReinsuranceRate(Acceptance.TOC,ICover.Currency,Acceptance.SDate,Cover.PHolder)) 
			* coalesce((Select sum(Share) from ISource Where ISource.CNO=Acceptance.CNO),100)/100				
			* (100-coalesce((Select sum(Share) from Coinsurance Where CNO=Acceptance.CNO),0))/100				
			as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join Cover on (Cover.CNO=Acceptance.CNO)
			Inner Join ICover on (ICover.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			and ICover.Category='M'
			Group by Acceptance.CNO, Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
		else
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			Max(Acceptance.Branch) as Branch,    
			Max(Acceptance.TOC) as TOC, 
			Max(Cover.ISType) as ISType,
			Max(Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
			sum(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance mA
			Inner join Acceptance omA on (omA.OANO=mA.OANO)
			Inner Join Acceptance on (Acceptance.LANO=omA.ANO)
			Left Join Acceptance nAcceptance on (nAcceptance.pANO=Acceptance.ANO)
			Inner Join Cover on (Cover.CNO=Acceptance.CNO)
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE mA.ANO=@P_ANO 
			and Acceptance.AType not in ('A','C') and Acceptance.AStatus in ('W','T','I') and coalesce(nAcceptance.ANO,0)<>0
			Group By Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
			Order By sum(RArrHeader.TAmount-RArrHeader.MAmount) Desc            
	end
else
	if @P_ANO<>@LANO
	Begin
		if @OpenFlag=0
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			Acceptance.Branch as Branch,    
			Acceptance.TOC, Cover.ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) as TotalAmount
			From Acceptance
			Inner Join Cover on (Cover.CNO=Acceptance.CNO)
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
		else
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			Acceptance.Branch as Branch,    
			Acceptance.TOC, Cover.ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) as TotalAmount
			From Acceptance
			Inner Join Cover on (Cover.CNO=Acceptance.CNO)
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			-- No Master Acceptance Limit Of Liability
			and not exists (Select Top 1 mA.ANO from Acceptance mA Inner Join ICover I on (I.ANO=mA.ANO) Where mA.ANO=Acceptance.LANO and I.Category='M' and I.Amount<>0)			
	end
	else 
	Begin
		if @OpenFlag=1	--Master Open Cover
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			Max(Acceptance.Branch) as Branch,    
			Max(Acceptance.TOC) as TOC, 
			Max(Cover.ISType) as ISType,
			100 as ApprLimitPct,  
			sum(ICover.Amount*dbo.fn_GetReinsuranceRate(Acceptance.TOC,ICover.Currency,Acceptance.SDate,Cover.PHolder)) 
			* coalesce((Select sum(Share) from ISource Where ISource.CNO=Acceptance.CNO),100)/100				
			* (100-coalesce((Select sum(Share) from Coinsurance Where CNO=Acceptance.CNO),0))/100				
			as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join Cover on (Cover.CNO=Acceptance.CNO)
			Inner Join ICover on (ICover.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			and ICover.Category='M'
			Group by Acceptance.CNO, Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
		else
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo, 
			Max(Acceptance.Branch) as Branch,    
			Max(Acceptance.TOC) as TOC, 
			Max(Cover.ISType) as ISType,
			Max(Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
			Sum(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			Sum(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Min(Acceptance.SDate),Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Max(mA.OANO)),0) as TotalAmount
			From Acceptance mA
			Inner join Acceptance omA on (omA.OANO=mA.OANO)
			Inner Join Acceptance on (Acceptance.LANO=omA.ANO)
			Left Join Acceptance nAcceptance on (nAcceptance.pANO=Acceptance.ANO)
			Inner Join Cover on (Cover.CNO=Acceptance.CNO)
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE mA.ANO=@P_ANO 
			and Acceptance.AType not in ('A','C') and Acceptance.AStatus in ('W','T','I') and coalesce(nAcceptance.ANO,0)<>0
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
Declare @LANO as int
Declare @OpenFlag as Bit

Select @LANO=A.LANO, @OpenFlag=C.OpenFlag, @ApplyApprLimitByTOLF=TOC.ApplyApprLimitByTOLF, @ApplyApprLimitByAccRegF=TOC.ApplyApprLimitByAccRegF
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
			Acceptance.Branch as Branch,    
			Acceptance.TOC, Cover.ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join Cover on (Cover.CNO=Acceptance.CNO)
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
		else
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			Acceptance.Branch as Branch,    
			Acceptance.TOC, Cover.ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join Cover on (Cover.CNO=Acceptance.CNO)
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			-- No Master Acceptance Limit Of Liability
			and not exists (Select Top 1 mA.ANO from Acceptance mA Inner Join ICover I on (I.ANO=mA.ANO) Where mA.ANO=Acceptance.LANO and I.Category='M' and I.Amount<>0)			
	end
	else 
	Begin
		if @OpenFlag=1	--Master Open Cover
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			Max(Acceptance.Branch) as Branch,    
			Max(Acceptance.TOC) as TOC, 
			Max(Cover.ISType) as ISType,
			100 as ApprLimitPct,  
			sum(ICover.Amount*dbo.fn_GetReinsuranceRate(Acceptance.TOC,ICover.Currency,Acceptance.SDate,Cover.PHolder)) 
			* coalesce((Select sum(Share) from ISource Where ISource.CNO=Acceptance.CNO),100)/100				
			* (100-coalesce((Select sum(Share) from Coinsurance Where CNO=Acceptance.CNO),0))/100				
			as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join Cover on (Cover.CNO=Acceptance.CNO)
			Inner Join ICover on (ICover.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			and ICover.Category='M'
			Group by Acceptance.CNO, Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
		else
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			Max(Acceptance.Branch) as Branch,    
			Max(Acceptance.TOC) as TOC, 
			Max(Cover.ISType) as ISType,
			Max(Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
			sum(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance mA
			Inner join Acceptance omA on (omA.OANO=mA.OANO)
			Inner Join Acceptance on (Acceptance.LANO=omA.ANO)
			Left Join Acceptance nAcceptance on (nAcceptance.pANO=Acceptance.ANO)
			Inner Join Cover on (Cover.CNO=Acceptance.CNO)
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE mA.ANO=@P_ANO 
			and Acceptance.AType not in ('A','C') and Acceptance.AStatus in ('W','T','I') and coalesce(nAcceptance.ANO,0)<>0
			Group By Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
			Order By sum(RArrHeader.TAmount-RArrHeader.MAmount) Desc            
	end
else
	if @P_ANO<>@LANO
	Begin
		if @OpenFlag=0
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			Acceptance.Branch as Branch,    
			Acceptance.TOC, Cover.ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) as TotalAmount
			From Acceptance
			Inner Join Cover on (Cover.CNO=Acceptance.CNO)
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
		else
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			Acceptance.Branch as Branch,    
			Acceptance.TOC, Cover.ISType,
			Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
			(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) as TotalAmount
			From Acceptance
			Inner Join Cover on (Cover.CNO=Acceptance.CNO)
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			-- No Master Acceptance Limit Of Liability
			and not exists (Select Top 1 mA.ANO from Acceptance mA Inner Join ICover I on (I.ANO=mA.ANO) Where mA.ANO=Acceptance.LANO and I.Category='M' and I.Amount<>0)			
	end
	else 
	Begin
		if @OpenFlag=1	--Master Open Cover
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			Max(Acceptance.Branch) as Branch,    
			Max(Acceptance.TOC) as TOC, 
			Max(Cover.ISType) as ISType,
			100 as ApprLimitPct,  
			sum(ICover.Amount*dbo.fn_GetReinsuranceRate(Acceptance.TOC,ICover.Currency,Acceptance.SDate,Cover.PHolder)) 
			* coalesce((Select sum(Share) from ISource Where ISource.CNO=Acceptance.CNO),100)/100				
			* (100-coalesce((Select sum(Share) from Coinsurance Where CNO=Acceptance.CNO),0))/100				
			as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance
			Inner Join Cover on (Cover.CNO=Acceptance.CNO)
			Inner Join ICover on (ICover.ANO=Acceptance.ANO)
			WHERE Acceptance.ANO=@P_ANO
			and ICover.Category='M'
			Group by Acceptance.CNO, Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
		else
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end as CertificateNo,
			Max(Acceptance.Branch) as Branch,    
			Max(Acceptance.TOC) as TOC, 
			Max(Cover.ISType) as ISType,
			Max(Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
			Sum(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			Sum(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Min(Acceptance.SDate),Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Max(mA.OANO)),0) as TotalAmount
			From Acceptance mA
			Inner join Acceptance omA on (omA.OANO=mA.OANO)
			Inner Join Acceptance on (Acceptance.LANO=omA.ANO)
			Left Join Acceptance nAcceptance on (nAcceptance.pANO=Acceptance.ANO)
			Inner Join Cover on (Cover.CNO=Acceptance.CNO)
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE mA.ANO=@P_ANO 
			and Acceptance.AType not in ('A','C') and Acceptance.AStatus in ('W','T','I') and coalesce(nAcceptance.ANO,0)<>0
			Group By Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID, Case When Acceptance.ValueID='' Then Acceptance.CertificateNo else '' end
			Order By Sum(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Min(Acceptance.SDate),Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Max(mA.OANO)),0) Desc  
	end

	Return
END


go


 insert into PatchVersioning
select '385 Update Script - Patch 2022 (62)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='385 Update Script - Patch 2022 (62)'


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






