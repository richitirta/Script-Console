DROP Procedure QClaim_Data
GO
CREATE Procedure QClaim_Data(@P_CNO integer)   
as   
SELECT C1.CNO, C1.OCNO, C1.ANO, C1.EVENTNO, C1.CLAIMNO, C1.REGDATE, C1.REFNO, C1.REFDATE, C1.REFTIME, C1.POLICYNO, C1.CERTIFICATENO, C1.CLAIMANT, C1.CLAIMANTINFO, C1.PAYMENT, C1.TOC, C1.COL, C1.EVENTNAME, C1.LOCATION, C1.LOSSPLACE, C1.LOSSDATE, C1.LOSSTIME,   
C1.DESCRIPTION, C1.SURVEYOR, C1.ASSESSOR, C1.BRANCH,   
C1.UserID, C1.CDate, C1.CTime,   
C1.LUSERID, C1.LDate, C1.LTime,   
C1.PUSERID, C1.PUserDate, C1.PUserTime,   
C1.RUserID, C1.RUserDate, C1.RUserTime,   
C1.AUSERID, C1.AUserDate, C1.AUserTime,   
C1.CUserID, C1.CloseDate, C1.CloseTime,   
C1.EXGRATIAF, C1.TBAF_1, C1.TBAF_2, (C1.TBAF_1 | C1.TBAF_2) as TBAF, C1.CSTATUS,   
C1.CType, C1.PCSTATUS, C1.VSEQNO, C1.CSEQNO, C1.ISTYPE,   
C1.ASource, C1.BackDatedF, C1.SettledF, C1.CT, C1.SysUserID, C1.Condition, C1.ClaimantEmail, C1.ClaimantMobile, C1.ClaimantPhone, C1.ClaimantType,  
OCLAIM.RegDate as ORegDate  
FROM CLAIM C1 INNER JOIN CLAIM OCLAIM ON (OCLAIM.CNO=C1.OCNO)  
WHERE C1.CNO=@P_CNO   
go


insert into PatchVersioning
select '967 Update Script - Patch 2024 (12)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='967 Update Script - Patch 2024 (12)'


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
	 

  
  
  