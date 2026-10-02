
-- 3 Apr 2017 : Lookup Salutation

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Salutation') AND type in (N'U'))
BEGIN
CREATE TABLE Salutation(
	Salutation varchar(10) NULL
) ON [PRIMARY]
CREATE UNIQUE INDEX I_SALUTATION ON SALUTATION(SALUTATION)
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='N/A')
BEGIN
insert into Salutation values('N/A')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='PD')
BEGIN
insert into Salutation values('PD')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='PT')
BEGIN
insert into Salutation values('PT')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='CV')
BEGIN
insert into Salutation values('CV')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='Mr')
BEGIN
insert into Salutation values('Mr')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='Mrs')
BEGIN
insert into Salutation values('Mrs')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='Miss')
BEGIN
insert into Salutation values('Miss')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='Tn')
BEGIN
insert into Salutation values('Tn')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='Ny')
BEGIN
insert into Salutation values('Ny')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='Nn')
BEGIN
insert into Salutation values('Nn')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='RS')
BEGIN
insert into Salutation values('RS')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='RSIA')
BEGIN
insert into Salutation values('RSIA')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='KLINIK')
BEGIN
insert into Salutation values('KLINIK')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='RSUD')
BEGIN
insert into Salutation values('RSUD')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='PUSKESMAS')
BEGIN
insert into Salutation values('PUSKESMAS')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='RB')
BEGIN
insert into Salutation values('RB')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='BIDAN')
BEGIN
insert into Salutation values('BIDAN')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='OPTIK')
BEGIN
insert into Salutation values('OPTIK')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='APOTIK')
BEGIN
insert into Salutation values('APOTIK')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='BP')
BEGIN
insert into Salutation values('BP')
end
GO
IF NOT EXISTS(SELECT * FROM Salutation WHERE Salutation='BALKESMAS')
BEGIN
insert into Salutation values('BALKESMAS')
end
GO
--18 APR 2017 : TUNING SCRIPT 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLACC_3') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QCLACC_3
end
GO
CREATE PROCEDURE QCLACC_3 (@P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO VARCHAR(255), @P_REFNO varchar(50)='', @P_TOC varchar(10)='')     
AS     
SELECT TOP 10 ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.AID, COVER.INSURED, COVER.ISTYPE, ACCEPTANCE.TOC, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, Cover.PHolder, ACCEPTANCE.BRANCH, ACCEPTANCE.ANAME, PROFILE.RESTRICTEDF, PROFILE.
NAME, ACCEPTANCE.PDATE, ACCEPTANCE.PPDATE, ACCEPTANCE.NCDATE,  ACCEPTANCE.EXTPERIOD,     
Case When GenDTab.Description is not null then ACCEPTANCE.ValueDesc else '' end as Description,     
Case When ISource.ID is null then ACCEPTANCE.AID else ISource.ID end as Payment,     
Case When ISource.ID is null then Profile.Name else PProfile.Name end as Payment_Name     
FROM ACCEPTANCE WITH (INDEX(I_Acceptance_PolicyNo_CertificateNo))  
Left Join GenDTab On (GenDTab.FLDID=ACCEPTANCE.FLDID AND GenDTab.ValueID=ACCEPTANCE.ValueID)  
Inner Join COVER on (Cover.CNO=Acceptance.CNO)  
Left Join ISource On (ISource.CNO=Cover.CNO)   
Left Join Profile PProfile On (PProfile.ID=ISource.ID)  
Left Join Profile on (Profile.ID=Acceptance.AID)  
WHERE ACCEPTANCE.ATYPE Not In ('A','C') AND ACCEPTANCE.AStatus not in ('W','T') and COVER.CStatus not in ('R','P','C')     
AND ACCEPTANCE.PDATE<ACCEPTANCE.PPDATE AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO   
AND ACCEPTANCE.POLICYNO<>'' AND ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO     
AND ACCEPTANCE.TOC LIKE @P_TOC+'%' AND ACCEPTANCE.REFNO LIKE @P_REFNO+'%'  
ORDER BY ACCEPTANCE.ANO DESC     

go

--perbaikan save proacc
IF NOT EXISTS(SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID('DF__ProAcc__Remarks_B__0A9FF7E0') AND parent_object_id = OBJECT_ID('ProAcc'))
BEGIN
ALTER TABLE ProAcc ADD  CONSTRAINT DF__ProAcc__Remarks_B__0A9FF7E0  DEFAULT ('') FOR Remarks
END
GO



Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='04 Script Komulatif Konsol 1.2'
Select @CurrSCript='05 Script Komulatif Konsol 1.3'


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


