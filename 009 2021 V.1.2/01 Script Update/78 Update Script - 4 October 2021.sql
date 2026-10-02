IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'View04') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE View04
end
GO
CREATE PROCEDURE View04(@P_ANO as integer)       
AS      
SELECT R.*, TOC.REGID, A.AnnualTreatyF, A.NoRiskAccumulationF, A.FLDID, A.ValueID, C.OpenFlag, A.TOC, A.PolicyNo, A.CertificateNo, A.RegNo, C.CoverNo, C.ISType, A.RANO, A.AType, A.AStatus, A.SDate, A.EDate, MA.SDate as M_SDate, MA.EDate as M_EDate
FROM Acceptance A
Inner Join Cover C on (C.CNO=A.CNO)
Inner Join TOC on (TOC.TOC=A.TOC)
Inner Join RArrHeader R on (R.ANO=A.ANO)
Left Join ACCEPTANCE MA on (MA.ANO=A.LANO)
WHERE A.ANO=@P_ANO 


GO
IF NOT EXISTS(SELECT * FROM SysForm WHERE FName='ALLOWCHANGENORISKACCUMULATIONFLAG')
BEGIN
Insert into sysform(FName, Description, FCode, RequestF) Select 'ALLOWCHANGENORISKACCUMULATIONFLAG',
'Allow Change Risk Accumulation Flag', 'ACTIVITIES',0
end
go

insert into PatchVersioning
select '78 Update Script - 4 October 2021',GETDATE()
go
