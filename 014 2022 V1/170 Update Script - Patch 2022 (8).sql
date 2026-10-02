DROP Function fn_GetTotalSumInsured
GO
CREATE Function fn_GetTotalSumInsured(@P_AsAt as smalldatetime,@P_RegID as varchar(10),@P_FLDID as varchar(255),@P_ValueID as varchar(255),@P_OANO as Int)
RETURNS Float AS        
BEGIN      
	Declare @Total as Float
	if @P_FLDID<>'' and @P_ValueID<>''
	Begin
		Select @Total=sum((RArrHeader.TAmount-RArrHeader.MAmount)*Case When coalesce(A.PCTLOSS,100)<>0 Then coalesce(A.PCTLOSS,100) Else 100 End/100*coalesce(P.InstSIPCT,100)/100)
		from
		(
			Select Acceptance.ANO, (Select Top 1 RCover.PCTLOSS from RCover Where RCover.ANO=Acceptance.ANO and RCover.Category='M' and RCover.SDate<=@P_AsAt and ((RCover.EDate=Acceptance.EDate and @P_AsAt<=RCover.EDate) or (@P_AsAt<RCover.EDate))) as PCTLOSS
			from Acceptance
			Inner Join Cover on (Cover.CNO=Acceptance.CNO)
			Left Join Acceptance mA on (MA.ANO=Acceptance.LANO and MA.ANO=MA.LANO)
			Where Acceptance.PolicyNo<>'' and Acceptance.AType not in ('C','A') and Acceptance.AStatus not in ('W','T') and Cover.CStatus<>'C' and Acceptance.pAStatus<>'W'
			and @P_AsAt between Acceptance.PDate and Acceptance.EDate
			and Acceptance.OANO<>@P_OANO and coalesce(mA.OANO,0)<>@P_OANO and Acceptance.RegID=@P_RegID and Acceptance.FLDID=@P_FLDID and Acceptance.ValueID=@P_VALUEID 
			and not exists (
				Select A.PANO
				from Acceptance A
				Inner Join Cover C on (C.CNO=A.CNO)
				Where A.PANO=Acceptance.ANO 
				and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
				and @P_AsAt between A.PDate and A.EDate
			)
			and not exists (
				Select A.RANO
				from Acceptance A
				Inner Join Cover C on (C.CNO=A.CNO)
				Where A.RANO=Acceptance.ANO 
				and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
				and @P_AsAt between A.PDate and A.EDate
			) 
			and not exists (
				Select Claim.ANO
				from Claim
				Inner Join CLLOSS on (CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1)
				WHere Claim.ANO=Acceptance.ANO 
				and Claim.RegDate<=@P_AsAt
				and Claim.CStatus in ('P','T','A','C') and Claim.CType in ('N','E')
				and Not (Claim.CStatus in ('C') and Claim.pCStatus in ('P') and Claim.CSDate<=@P_AsAt)
				and Not Exists (Select pCNO from Claim C Where C.pCNO=Claim.CNO and C.CStatus in ('P','T','A','C') and Claim.RegDate<=@P_AsAt)
			)
		) A
		Inner Join Acceptance A1 on (A1.ANO=A.ANO)
		Left Join Payor_Schedule P on (P.ANO=A1.ANO and P.InstDate<=@P_AsAt and (P.InstLDate>@P_AsAt or (P.InstLDate=@P_AsAt and P.InstLDate=A1.EDate)))
		Inner Join RArrHeader on (RArrHeader.ANO=A1.ANO)
	End

	if @Total is null 
		Select @Total=0

	Return @Total
END     

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
from Acceptance A
Inner Join Cover C on (C.CNO=A.CNO)
Inner Join TOC on (TOC.TOC=A.TOC)
Where A.ANO=@P_ANO

if @ApplyApprLimitByAccRegF=0 
	if @P_ANO<>@LANO
	Begin
		if @OpenFlag=0
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,
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
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,
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
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,
			Acceptance.Branch as Branch,    
			Acceptance.TOC, Cover.ISType,
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
			Group by Acceptance.CNO, Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,
			Acceptance.Branch,    
			Acceptance.TOC, Cover.ISType
		else
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,
			Max(Acceptance.Branch) as Branch,    
			Max(Acceptance.TOC) as TOC, 
			Max(Cover.ISType) as ISType,
			Max(Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
			sum(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance mA
			Inner Join Acceptance on (Acceptance.LANO=mA.ANO)
			Inner Join Cover on (Cover.CNO=Acceptance.CNO)
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE mA.ANO=@P_ANO
			Group By Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID
			Order By sum(RArrHeader.TAmount-RArrHeader.MAmount) Desc            
	end
else
	if @P_ANO<>@LANO
	Begin
		if @OpenFlag=0
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,
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
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,
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
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,
			Acceptance.Branch as Branch,    
			Acceptance.TOC, Cover.ISType,
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
			Group by Acceptance.CNO, Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,
			Acceptance.Branch,    
			Acceptance.TOC, Cover.ISType
		else
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,
			Max(Acceptance.Branch) as Branch,    
			Max(Acceptance.TOC) as TOC, 
			Max(Cover.ISType) as ISType,
			Max(Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
			Sum(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			Sum(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Min(Acceptance.SDate),Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Max(mA.OANO)),0) as TotalAmount
			From Acceptance mA
			Inner Join Acceptance on (Acceptance.LANO=mA.ANO)
			Inner Join Cover on (Cover.CNO=Acceptance.CNO)
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE mA.ANO=@P_ANO
			Group By Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID
			Order By Sum(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Min(Acceptance.SDate),Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Max(mA.OANO)),0) Desc  

	end

GO

DROP Function FN_Approval_Production
GO
CREATE Function FN_Approval_Production(@P_ANO int)   
RETURNS @Table TABLE (REGID varchar(10), FLDID varchar(255), VALUEID varchar(255), Branch varchar(10), TOC varchar(10), ISType varchar(10), ApprLimitPCT Float, Amount Float, TotalAmount Float)  
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
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,
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
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,
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
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,
			Acceptance.Branch as Branch,    
			Acceptance.TOC, Cover.ISType,
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
			Group by Acceptance.CNO, Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,
			Acceptance.Branch,    
			Acceptance.TOC, Cover.ISType
		else
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,
			Max(Acceptance.Branch) as Branch,    
			Max(Acceptance.TOC) as TOC, 
			Max(Cover.ISType) as ISType,
			Max(Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
			sum(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			cast(0 as Float) as TotalAmount
			From Acceptance mA
			Inner Join Acceptance on (Acceptance.LANO=mA.ANO)
			Inner Join Cover on (Cover.CNO=Acceptance.CNO)
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE mA.ANO=@P_ANO
			Group By Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID
			Order By sum(RArrHeader.TAmount-RArrHeader.MAmount) Desc            
	end
else
	if @P_ANO<>@LANO
	Begin
		if @OpenFlag=0
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,
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
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,
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
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,
			Acceptance.Branch as Branch,    
			Acceptance.TOC, Cover.ISType,
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
			Group by Acceptance.CNO, Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,
			Acceptance.Branch,    
			Acceptance.TOC, Cover.ISType
		else
			Insert into @Table
			SELECT top 1 Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,
			Max(Acceptance.Branch) as Branch,    
			Max(Acceptance.TOC) as TOC, 
			Max(Cover.ISType) as ISType,
			Max(Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
			Sum(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
			Sum(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Min(Acceptance.SDate),Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Max(mA.OANO)),0) as TotalAmount
			From Acceptance mA
			Inner Join Acceptance on (Acceptance.LANO=mA.ANO)
			Inner Join Cover on (Cover.CNO=Acceptance.CNO)
			Inner Join RARRHEADER on (RArrheader.ANO=Acceptance.ANO)
			WHERE mA.ANO=@P_ANO
			Group By Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID
			Order By Sum(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Min(Acceptance.SDate),Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Max(mA.OANO)),0) Desc  

	end

	Return
END



go




 insert into PatchVersioning
select '170 Update Script - Patch 2022 (8)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='170 Update Script - Patch 2022 (8)'


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
