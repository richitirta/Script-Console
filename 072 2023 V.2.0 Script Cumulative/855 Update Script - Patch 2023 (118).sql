DROP PROCEDURE List_Of_Summary_AccReg
GO
CREATE PROCEDURE List_Of_Summary_AccReg(@P_REGID varchar(10), @P_FLDID varchar(255), @P_VALUEID varchar(255), @P_VALUEID1 varchar(255), @P_VALUEID2 varchar(255), @P_VALUEID3 varchar(255), @P_VALUEID4 varchar(255), @P_VALUEID5 varchar(255), @P_VALUEID6 varchar(255)) 
As 
SELECT 
sum((CAMOUNT-CCAMOUNT)/(RArrHeader.PctShare / 100 * RArrHeader.PCTLOSS / 100 * (100 - RArrHeader.MShare) / 100)) AS CP, 
sum((DAMOUNT-CDAMOUNT)/(RArrHeader.PctShare / 100 * RArrHeader.PCTLOSS / 100 * (100 - RArrHeader.MShare) / 100)) AS DC, 
sum((XPAMOUNT-CXPAMOUNT)/(RArrHeader.PctShare / 100 * RArrHeader.PCTLOSS / 100 * (100 - RArrHeader.MShare) / 100)) AS XP, 
sum(QAMOUNT-CQAMOUNT) AS QS, 
sum(SP1AMOUNT-CSP1AMOUNT) AS SP1, 
sum(SP2AMOUNT-CSP2AMOUNT) AS SP2, 
sum(SP3AMOUNT-CSP3AMOUNT) AS SP3,
sum(AAMOUNT-CAAMOUNT) AS AA,
sum(QSRAMOUNT+AFRAMOUNT+RAMOUNT+SAMOUNT) AS [OR]
FROM Cover, Acceptance, RArrHeader, GenDTab 
WHERE Cover.CNO=Acceptance.CNO And RArrHeader.Status='A' And RArrHeader.ANO=Acceptance.ANO And Acceptance.RegID=@P_REGID and Acceptance.FLDID=GenDTab.FLDID And Acceptance.ValueID=GenDTab.ValueID 
And GenDTab.FLDID=@P_FLDID 
And (GenDTab.ValueID Like '%'+@P_ValueID + '%' or GenDTab.Description Like '%'+@P_ValueID+'%') 
And (GenDTab.ValueID1 Like @P_ValueID1 + '%' or GenDTab.ValueDesc1 Like @P_ValueID1 + '%') 
And (GenDTab.ValueID2 Like @P_ValueID2 + '%' or GenDTab.ValueDesc2 Like @P_ValueID2 + '%') 
And (GenDTab.ValueID3 Like @P_ValueID3 + '%' or GenDTab.ValueDesc3 Like @P_ValueID3 + '%') 
And (GenDTab.ValueID4 Like @P_ValueID4 + '%' or GenDTab.ValueDesc4 Like @P_ValueID4 + '%') 
And (GenDTab.ValueID5 Like @P_ValueID5 + '%' or GenDTab.ValueDesc5 Like @P_ValueID5 + '%') 
And (GenDTab.ValueID6 Like @P_ValueID6 + '%' or GenDTab.ValueDesc6 Like @P_ValueID6 + '%') 
 
 
GO 


DROP PROCEDURE List_Of_Detail_AccReg 
GO
CREATE PROCEDURE List_Of_Detail_AccReg (@P_REGID varchar(10),@P_FLDID varchar(255), @P_VALUEID varchar(255), @P_VALUEID1 varchar(255), @P_VALUEID2 varchar(255), @P_VALUEID3 varchar(255), @P_VALUEID4 varchar(255), @P_VALUEID5 varchar(255), @P_VALUEID6 varchar(255)) 
As 
SELECT ACCEPTANCE.ANO, ACCEPTANCE.FLDID, ACCEPTANCE.VALUEID, ACCEPTANCE.VALUEDESC, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, Cast(Acceptance.AName as varchar(128)) as Insured, 
(CAMOUNT-CCAMOUNT)/(RArrHeader.PctShare / 100 * RArrHeader.PCTLOSS / 100 * (100 - RArrHeader.MShare) / 100) AS CP, 
(DAMOUNT-CDAMOUNT)/(RArrHeader.PctShare / 100 * RArrHeader.PCTLOSS / 100 * (100 - RArrHeader.MShare) / 100) AS DC, 
(XPAMOUNT-CXPAMOUNT)/(RArrHeader.PctShare / 100 * RArrHeader.PCTLOSS / 100 * (100 - RArrHeader.MShare) / 100) AS XP, 
(QAMOUNT-CQAMOUNT) AS QS, 
(SP1AMOUNT-CSP1AMOUNT) AS SP1, 
(SP2AMOUNT-CSP2AMOUNT) AS SP2, 
(SP3AMOUNT-CSP3AMOUNT) AS SP3,
(AAMOUNT-CAAMOUNT) AS AA,
(QSRAMOUNT+AFRAMOUNT+RAMOUNT+SAMOUNT) AS [OR]
FROM Cover, Acceptance, RArrHeader, GenDTab 
WHERE Cover.CNO=Acceptance.CNO And RArrHeader.Status='A' And RArrHeader.ANO=Acceptance.ANO And Acceptance.REGID=@P_REGID and Acceptance.FLDID=GenDTab.FLDID And Acceptance.ValueID=GenDTab.ValueID 
And GenDTab.FLDID=@P_FLDID 
And (GenDTab.ValueID Like '%'+@P_ValueID + '%' or GenDTab.Description Like '%'+@P_ValueID+'%') 
And (GenDTab.ValueID1 Like @P_ValueID1 + '%' or GenDTab.ValueDesc1 Like @P_ValueID1 + '%') 
And (GenDTab.ValueID2 Like @P_ValueID2 + '%' or GenDTab.ValueDesc2 Like @P_ValueID2 + '%') 
And (GenDTab.ValueID3 Like @P_ValueID3 + '%' or GenDTab.ValueDesc3 Like @P_ValueID3 + '%') 
And (GenDTab.ValueID4 Like @P_ValueID4 + '%' or GenDTab.ValueDesc4 Like @P_ValueID4 + '%') 
And (GenDTab.ValueID5 Like @P_ValueID5 + '%' or GenDTab.ValueDesc5 Like @P_ValueID5 + '%') 
And (GenDTab.ValueID6 Like @P_ValueID6 + '%' or GenDTab.ValueDesc6 Like @P_ValueID6 + '%') 
 
GO

DROP PROCEDURE List_Of_Detail_AccReg_Blank
GO
CREATE PROCEDURE List_Of_Detail_AccReg_Blank (@P_REGID varchar(10), @P_FLDID varchar(255), @P_VALUEID varchar(255)) 
As 
SELECT ACCEPTANCE.ANO, ACCEPTANCE.FLDID, ACCEPTANCE.VALUEID, ACCEPTANCE.VALUEDESC, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, Cast(Acceptance.AName as varchar(128)) as Insured, 
(CAMOUNT-CCAMOUNT)/(RArrHeader.PctShare / 100 * RArrHeader.PCTLOSS / 100 * (100 - RArrHeader.MShare) / 100) AS CP, 
(DAMOUNT-CDAMOUNT)/(RArrHeader.PctShare / 100 * RArrHeader.PCTLOSS / 100 * (100 - RArrHeader.MShare) / 100) AS DC, 
(XPAMOUNT-CXPAMOUNT)/(RArrHeader.PctShare / 100 * RArrHeader.PCTLOSS / 100 * (100 - RArrHeader.MShare) / 100) AS XP, 
(QAMOUNT-CQAMOUNT) AS QS, 
(SP1AMOUNT-CSP1AMOUNT) AS SP1, 
(SP2AMOUNT-CSP2AMOUNT) AS SP2, 
(SP3AMOUNT-CSP3AMOUNT) AS SP3,
(AAMOUNT-CAAMOUNT) AS AA,
(QSRAMOUNT+AFRAMOUNT+RAMOUNT+SAMOUNT) AS [OR]
FROM Cover, Acceptance, RArrHeader 
WHERE Cover.CNO=Acceptance.CNO And RArrHeader.Status='A' And RArrHeader.ANO=Acceptance.ANO And Acceptance.RegID=@P_REGID and Acceptance.FLDID=@P_FLDID and Acceptance.ValueID like @P_VALUEID+'%' 
 
 
GO

DROP PROCEDURE List_Of_Summary_AccReg_Blank
GO
CREATE PROCEDURE List_Of_Summary_AccReg_Blank(@P_REGID varchar(10), @P_FLDID varchar(255), @P_VALUEID varchar(255)) 
As 
Select
sum((CAMOUNT-CCAMOUNT)/(RArrHeader.PctShare / 100 * RArrHeader.PCTLOSS / 100 * (100 - RArrHeader.MShare) / 100)) AS CP, 
sum((DAMOUNT-CDAMOUNT)/(RArrHeader.PctShare / 100 * RArrHeader.PCTLOSS / 100 * (100 - RArrHeader.MShare) / 100)) AS DC, 
sum((XPAMOUNT-CXPAMOUNT)/(RArrHeader.PctShare / 100 * RArrHeader.PCTLOSS / 100 * (100 - RArrHeader.MShare) / 100)) AS XP, 
sum(QAMOUNT-CQAMOUNT) AS QS, 
sum(SP1AMOUNT-CSP1AMOUNT) AS SP1, 
sum(SP2AMOUNT-CSP2AMOUNT) AS SP2, 
sum(SP3AMOUNT-CSP3AMOUNT) AS SP3,
sum(AAMOUNT-CAAMOUNT) AS AA,
sum(QSRAMOUNT+AFRAMOUNT+RAMOUNT+SAMOUNT) AS [OR]
FROM Cover, Acceptance, RArrHeader 
WHERE Cover.CNO=Acceptance.CNO And RArrHeader.Status='A' And RArrHeader.ANO=Acceptance.ANO And Acceptance.RegID=@P_REGID And Acceptance.FLDID=@P_FLDID And Acceptance.ValueID like @P_VALUEID+'%' 
 
 
 
GO


 insert into PatchVersioning
select '855 Update Script - Patch 2023 (118)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='855 Update Script - Patch 2023 (118)'


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




 
 


