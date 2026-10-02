IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'PI07') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure PI07
end
GO
CREATE Procedure PI07(@P_ANO as integer)  
as  
    
select Claim.CNO, Claim.ClaimNo, Claim.LossDate, Profile.Name, Claim.Description, Claim.CStatus, CCalc.Currency, CCalc.Loss, CCalc.Claim, CCalc.Deductible, CCalc.Cost, CCalc.Salvage, CCalc.Subrogation  
From CLAIM
Left Join Profile on (Profile.ID=Claim.Claimant)
Left Join CCalc on (CCalc.CNO=Claim.CNO),
Cover C, Acceptance A1, Acceptance A2
Where (Claim.Cstatus in ('R','P','T','A') or (Claim.Cstatus='C' and Claim.pCStatus<>''))
and C.CNO=A1.CNO and (A1.ANO=@P_ANO or (C.OpenFlag=0 and A1.LANO=@P_ANO)) and A2.OANO=A1.OANO and A2.ANO=Claim.ANO

Union All

select Claim.CNO, Claim.ClaimNo, Claim.LossDate, Profile.Name, Claim.Description, Claim.CStatus, CCalc.Currency, CCalc.Loss, CCalc.Claim, CCalc.Deductible, CCalc.Cost, CCalc.Salvage, CCalc.Subrogation  
From CLAIM
Left Join Profile on (Profile.ID=Claim.Claimant)
Left Join CCalc on (CCalc.CNO=Claim.CNO),
Cover C, Acceptance A1, Acceptance A2, Acceptance A3 
Where (Claim.Cstatus in ('R','P','T','A') or (Claim.Cstatus='C' and Claim.pCStatus<>''))
and C.CNO=A1.CNO and (A1.ANO=@P_ANO or (C.OpenFlag=0 and A1.LANO=@P_ANO)) and A2.ANO=A1.RANO and A3.OANO=A2.OANO and A3.ANO=Claim.ANO

Union All

select Claim.CNO, Claim.ClaimNo, Claim.LossDate, Profile.Name, Claim.Description, Claim.CStatus, CCalc.Currency, CCalc.Loss, CCalc.Claim, CCalc.Deductible, CCalc.Cost, CCalc.Salvage, CCalc.Subrogation  
From CLAIM
Left Join Profile on (Profile.ID=Claim.Claimant)
Left Join CCalc on (CCalc.CNO=Claim.CNO),
Cover C, Acceptance A1, Acceptance A2, Acceptance A3, Acceptance A4
Where (Claim.Cstatus in ('R','P','T','A') or (Claim.Cstatus='C' and Claim.pCStatus<>''))
and C.CNO=A1.CNO and (A1.ANO=@P_ANO or (C.OpenFlag=0 and A1.LANO=@P_ANO)) and A2.ANO=A1.RANO and A3.ANO=A2.RANO and A4.OANO=A3.OANO and A4.ANO=Claim.ANO

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'List20') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE List20 
end
GO
CREATE PROCEDURE List20 (@P_USERID as varchar(255),@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_AStatus as varchar(1))   
AS   
SELECT   
Cast(0 as bit) as ProcessFlag,   
Cover.COVERNO,   
Cast(Acceptance.AName as varchar(128)) as Insured,   
Cover.CNO,   
Cover.CStatus,   
Acceptance.lANO,   
Acceptance.ANO,   
Acceptance.REGNO,   
Acceptance.ADATE,   
Acceptance.LUSERID as USERID,   
SysTab.Currency,   
Acceptance.ASTATUS,   
Acceptance.ATYPE,   
Acceptance.SDate,   
Acceptance.EDate,   
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,   
Cover.ISType,   
Acceptance.Renewal,   
Acceptance.ESeqNo,   
Acceptance.PolicyNo,   
Acceptance.CertificateNo,   
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS
FROM  Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) And Cover.ISType<>'T'   
And Acceptance.LUserID Like @P_UserID   
And Acceptance.LDate between @P_SDate and @P_EDate   
And (Acceptance.AStatus=@P_AStatus or @P_AStatus='')   
   
union   
   
Select   
Cast(0 as bit) as ProcessFlag,   
Cover.COVERNO,   
Cast(Acceptance.AName as varchar(128)) as Insured,   
Cover.CNO,   
Cover.CStatus,   
Acceptance.lANO,   
Acceptance.ANO,   
Acceptance.REGNO,   
Acceptance.ADATE,   
Acceptance.LUSERID as USERID,   
SysTab.Currency,   
Acceptance.ASTATUS,   
Acceptance.ATYPE,   
Acceptance.SDate,   
Acceptance.EDate,   
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,   
Cover.ISType,   
Acceptance.Renewal,   
Acceptance.ESeqNo,   
Acceptance.PolicyNo,   
Acceptance.CertificateNo,   
cast(0 as Float) as TSI,
cast(0 as Float) as OurShare,
cast(0 as Float) as Gross
FROM  Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Inner Join 
(   
	Select Distinct Acceptance_Detail.LANO 
	from Acceptance as Acceptance_Detail   
	Where Acceptance_Detail.LANO<>Acceptance_Detail.ANO 
	And Acceptance_Detail.LUserID Like @P_UserID   
	And Acceptance_Detail.LDate between @P_SDate and @P_EDate   
	And (Acceptance_Detail.AStatus=@P_AStatus or @P_AStatus='')   
) Acceptance_Detail on (Acceptance_Detail.LANO=Acceptance.ANO)
WHERE (Acceptance.ANO=Acceptance.LANO) And Cover.ISType<>'T'   
go

  insert into PatchVersioning
select '54.11 Update Script - Patch 2019 (14)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='54.10 Update Script - Patch 2019 (13)'
Select @CurrSCript='54.11 Update Script - Patch 2019 (14)'


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
