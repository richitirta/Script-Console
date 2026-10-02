
drop view [dbo].[ICPS_CARBRAND]  
go
drop view [dbo].[ICPS_CARCLASS]  
go
drop VIEW [dbo].[ICPS_CARMODEL] 
go
drop view [ICPS_CARTYPE]

ALTER TABLE GENDTAB ALTER COLUMN DESCRIPTION varchar(8000) NULL
GO


CREATE VIEW [dbo].[ICPS_CARBRAND]  
WITH SCHEMABINDING  
AS  
SELECT '<ANY>' as CARBRAND, '<ANY CAR BRANDS>' as Description, 1 as AllowedF
UNION ALL
SELECT VALUEID AS 'CARBRAND', DESCRIPTION, ALLOWEDF  FROM dbo.GENDTAB WHERE FLDID='V01' AND ICPSF=1 AND ALLOWEDF=1
go
insert into PatchVersioning
select '1112 ALTER COLUMN DESCRIPTION - GENDTAB',GETDATE()
go
	
CREATE VIEW [dbo].[ICPS_CARCLASS]
AS  
SELECT '<ANY>' as CARCLASS, '<ANY CAR CLASSES>' as Description, 1 as AllowedF
UNION ALL
SELECT VALUEID AS 'CARCLASS', DESCRIPTION, ALLOWEDF FROM dbo.GENDTAB WHERE FLDID='V17' AND ICPSF=1 AND ALLOWEDF=1 
go
CREATE VIEW [dbo].[ICPS_CARMODEL]  
WITH SCHEMABINDING  
AS  
SELECT '<ANY>' as CARMODEL, '<ANY>' as Description, '<ANY>' as CARBRAND, '<ANY>' as CARTYPE, '<ANY>' as CARCLASS, 1 as AllowedF
UNION ALL
SELECT VALUEID AS 'CARMODEL', DESCRIPTION, VALUEID1 AS 'CARBRAND', VALUEID2 AS 'CARTYPE', VALUEID4 AS 'CARCLASS', ALLOWEDF FROM dbo.GENDTAB WHERE FLDID ='V30' AND ICPSF=1 AND ALLOWEDF=1
go

CREATE VIEW [dbo].[ICPS_CARTYPE]  
WITH SCHEMABINDING  
AS  
SELECT '<ANY>' as CARTYPE, '<ANY CAR TYPES>' as Description, 1 as AllowedF
UNION ALL
SELECT VALUEID AS 'CARTYPE', DESCRIPTION, ALLOWEDF FROM dbo.GENDTAB WHERE FLDID='V06' AND ICPSF=1 AND ALLOWEDF=1  
go


insert into PatchVersioning
select '1112 ALTER COLUMN DESCRIPTION - GENDTAB',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1112 ALTER COLUMN DESCRIPTION - GENDTAB'


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