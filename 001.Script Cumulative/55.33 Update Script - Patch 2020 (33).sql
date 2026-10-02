IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLLIST07') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE CLLIST07 
END
GO
CREATE PROCEDURE CLLIST07 (@P_EVENTNO AS varchar(255),@P_RYEAR AS INTEGER)
AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
  CLAIM.REGDATE,
  CLAIM.REFNO,
  CLAIM.COL,
  COLTAB.DESCRIPTION,
  CLAIM.LOSSDATE,
  CLAIM.TOC,
  CLAIM.CSDATE,
  CLAIM.LOSSPLACE,
  CLAIM.CTYPE,
  CLAIM.CSTATUS,
  CLAIM.CNO,
  CLAIM.ANO,
  CLAIM.PCNO,
  CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
  SYSTAB.CURRENCY,
  CCALC.LOSS AS ESTIMATE,
  CCALC.CLAIM AS CLAIM,
  CCALC.DEDUCTIBLE AS DEDUCTIBLE,
  CCALC.SALVAGE AS SALVAGE,
  CCALC.COST AS COST,
  CCALC.SUBROGATION AS SUBROGATION,
  CCALC.RESERVED AS OUTSTANDING,
  (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
  CLAIM.VSEQNO,
  CLAIM.CSEQNO,
  Cast(Acceptance.AName as varchar(128)) as AName,
  acceptance.policyno,
  acceptance.certificateno,
  CLAIM.SETTLEDF
FROM CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER ,REINSURANCE, COLTAB, ACCEPTANCE
Where CARRHEADER.CNO = CLAIM.CNO
  And CCALC.CNO=CLAIM.CNO
  And CLAIM.COL=COLTAB.COL
  And CLAIM.EVENTNO=@P_EVENTNO
  And CARRHEADER.STATUS='A'
  and acceptance.ano = claim.ano
  and Reinsurance.RID=
  (
	Case 
	When CARRHEADER.XL1ID<>'' Then CARRHEADER.XL1ID
	When CARRHEADER.XL2ID<>'' Then CARRHEADER.XL2ID
	When CARRHEADER.XL3ID<>'' Then CARRHEADER.XL3ID
	When CARRHEADER.XL4ID<>'' Then CARRHEADER.XL4ID
	When CARRHEADER.XL5ID<>'' Then CARRHEADER.XL5ID
	When CARRHEADER.XL6ID<>'' Then CARRHEADER.XL6ID
	When CARRHEADER.XL7ID<>'' Then CARRHEADER.XL7ID
	Else ''
	end
  )
  and Reinsurance.RYear=@P_RYEAR 
  

  GO
  
insert into PatchVersioning
select '55.33 Update Script - Patch 2020 (33)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='55.32 Update Script - Patch 2020 (32)'
Select @CurrSCript='55.33 Update Script - Patch 2020 (33)'


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


