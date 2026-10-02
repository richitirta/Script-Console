DROP procedure PI24 
GO
CREATE procedure PI24 (@P_ANO as integer)                
as                
Begin                

	Declare @P_AsAt as smalldatetime
	Declare @P_OANO as int
	Declare @P_TOPRO as varchar(10)
	Declare @P_PHolder as varchar(10)

	Select Top 1 @P_OANO=A.OANO, @P_AsAt=A.PDate, @P_TOPRO=A.TOPRO, @P_PHolder=C.PHOLDER 
	from Acceptance A, Cover C
	Where C.CNO=A.CNO and A.ANO=@P_ANO


	Select A1.PolicyNo, A1.CertificateNo, A1.ANO, A1.AName, A1.ADate, A1.TOPRO, C.PHolder, PHolder.Name as Name,
	(RArrHeader.TAmount-RArrHeader.MAmount)*Case When coalesce(A.PCTLOSS,100)<>0 Then coalesce(A.PCTLOSS,100) Else 100 End/100*coalesce(P.InstSIPCT,100)/100 as SI,
	SUM (
		(RArrHeader.TAmount-RArrHeader.MAmount)*Case When coalesce(A.PCTLOSS,100)<>0 Then coalesce(A.PCTLOSS,100) Else 100 End/100*coalesce(P.InstSIPCT,100)/100
	) OVER (ORDER BY A.ANO) AS TotalSI
	from
	(
		Select Acceptance.ANO, (Select Top 1 RCover.PCTLOSS from RCover Where RCover.ANO=Acceptance.ANO and RCover.Category='M' and RCover.SDate<=@P_AsAt and ((RCover.EDate=Acceptance.EDate and @P_AsAt<=RCover.EDate) or (@P_AsAt<RCover.EDate))) as PCTLOSS
		from Acceptance
		Inner Join Cover on (Cover.CNO=Acceptance.CNO)
		Where ((Acceptance.AType in ('E') and Acceptance.AStatus not in ('W','T')) or (Acceptance.AType in ('N') and Acceptance.pStatus='C' and Acceptance.pAStatus<>'W' and Cover.CStatus<>'C' and Cover.ASource='UW')) 
		and @P_AsAt between Acceptance.PDate and Acceptance.EDate
		and Acceptance.OANO<>@P_OANO and Acceptance.TOPRO=@P_TOPRO and Cover.PHolder=@P_PHolder 
		and not exists (
			Select A.PANO
			from Acceptance A, Cover C
			Where A.PANO=Acceptance.ANO and C.CNO=A.CNO 
			and ((A.AType in ('E','C') and A.AStatus not in ('W','T')) or (A.AType in ('N') and A.pStatus='C' and A.pAStatus<>'W' and C.CStatus<>'C' and C.ASource='UW')) 
			and @P_AsAt between A.PDate and A.EDate
		)
		and not exists (
			Select A.RANO
			from Acceptance A, Cover C
			Where A.RANO=Acceptance.ANO and C.CNO=A.CNO 
			and ((A.AType in ('E','C') and A.AStatus not in ('W','T')) or (A.AType in ('N') and A.pStatus='C' and A.pAStatus<>'W' and C.CStatus<>'C' and C.ASource='UW')) 
			and @P_AsAt between A.PDate and A.EDate
		) 
		and not exists (
			Select Claim.ANO
			from Claim, CLLOSS
			WHere Claim.ANO=Acceptance.ANO and CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 
			and Claim.RegDate<=@P_AsAt
			and Claim.CStatus in ('P','T','A','C') and Claim.CType in ('N','E')
			and Not (Claim.CStatus in ('C') and Claim.pCStatus in ('P') and Claim.CSDate<=@P_AsAt)
			and Not Exists (Select pCNO from Claim C Where C.pCNO=Claim.CNO and C.CStatus in ('P','T','A','C') and Claim.RegDate<=@P_AsAt)
		)
	) A
	Inner Join Acceptance A1 on (A1.ANO=A.ANO)
	Inner Join Cover C on (C.CNO=A1.CNO)
	Inner Join Profile PHolder on (PHolder.ID=C.PHolder)
	Left Join Payor_Schedule P on (P.ANO=A1.ANO and P.InstDate<=@P_AsAt and (P.InstLDate>@P_AsAt or (P.InstLDate=@P_AsAt and P.InstLDate=A1.EDate)))
	Inner Join RArrHeader on (RArrHeader.ANO=A1.ANO)
	Order by A.ANO

end

GO



insert into PatchVersioning
select '1586 Update Script - Patch 2026 (23).sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1586 Update Script - Patch 2026 (23).sql'


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





