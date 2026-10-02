
alter table ACCEPTANCE alter column remarks varchar(1024)
GO
alter table accass alter column remarks varchar(1024)
GO
alter table CLAASS alter column remarks varchar(1024)
GO

drop function R_PMK10_2011_Deductible
go
alter table Accded alter column remarks varchar(1024)
GO
CREATE FUNCTION [dbo].[R_PMK10_2011_Deductible] (@P_ANO as integer) 

RETURNS varchar(255) 

With SchemaBinding 

AS 

BEGIN 

 Declare @OwnRisks as varchar(255) 

 Declare @OwnRisk as varchar(255) 

 

 Select @OwnRisks='' 

 DECLARE PolicyDeductible_Cursor CURSOR FOR 

 Select distinct ltrim(rtrim(AccDed.Remarks)) as OwnRisk 

 FROM DBO.COVER COVER 

 INNER JOIN DBO.ACCEPTANCE ACCEPTANCE ON COVER.CNO = ACCEPTANCE.CNO 

 INNER JOIN DBO.ACCDED ACCDED ON (ACCDED.ANO=ACCEPTANCE.ANO) 

 INNER JOIN DBO.RCLASS RCLASS ON (RCLASS.TOR=ACCDED.TOR AND RCLASS.TOC=COVER.TOC AND RCLASS.CATEGORY='M') 

 WHERE ACCEPTANCE.ANO=@P_ANO 

 AND ACCDED.DCODE IN ('C01-1','C01-2','C01-3','C01-4','C01-6','C01-7','C01-10', 'C01-11','T02-1','T02-6','T02-8','T02-9','T02-10','T02-12') -- SPECIFIED DEDUCTIBLE CODE 

 

 OPEN PolicyDeductible_Cursor 

 FETCH FROM PolicyDeductible_Cursor into @OwnRisk 

 WHILE @@FETCH_STATUS = 0 

 BEGIN 

 if @OwnRisks='' 

 BEGIN 

 Select @OwnRisks=@OwnRisk 

 End 

 Else 

 BEGIN 

 Select @OwnRisks=substring(@OwnRisks+'; '+@OwnRisk,1,255) 

 End 

 FETCH NEXT FROM PolicyDeductible_Cursor into @OwnRisk 

 End 

 

 Close PolicyDeductible_Cursor 

 Deallocate PolicyDeductible_Cursor 

 Return (coalesce(@OwnRisks,'')) 

End 
go
