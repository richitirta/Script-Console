
ALTER INDEX I_ACCEPTANCE on ACCEPTANCE Rebuild 
GO
ALTER INDEX I_AccRegDet_RegID_FLDID_VALUEID_RTYPE_RYear on ACCREGDET Rebuild 
GO
ALTER INDEX ALL ON CURRENCY REBUILD
GO
ALTER INDEX I_TOP_NOC on TOP_NOC Rebuild 
GO

--currency
ALTER TABLE currency NOCHECK CONSTRAINT ALL
go
--Disable Index
ALTER INDEX ALL ON currency DISABLE
go
--Rebuild Index
ALTER INDEX ALL ON currency REBUILD
go
--Enable CONSTRAINT
ALTER TABLE currency CHECK CONSTRAINT ALL
go

--TOR
ALTER TABLE TOR NOCHECK CONSTRAINT ALL
go
--Disable Index
ALTER INDEX ALL ON TOR DISABLE
go
--Rebuild Index
ALTER INDEX ALL ON TOR REBUILD
go
--Enable CONSTRAINT
ALTER TABLE TOR CHECK CONSTRAINT ALL
go

--TOC
ALTER TABLE TOC NOCHECK CONSTRAINT ALL
go
--Disable Index
ALTER INDEX ALL ON TOC DISABLE
go
--Rebuild Index
ALTER INDEX ALL ON TOC REBUILD
go
--Enable CONSTRAINT
ALTER TABLE TOC CHECK CONSTRAINT ALL
go

--TOI
ALTER TABLE TOI NOCHECK CONSTRAINT ALL
go
--Disable Index
ALTER INDEX ALL ON TOI DISABLE
go
--Rebuild Index
ALTER INDEX ALL ON TOI REBUILD
go
--Enable CONSTRAINT
ALTER TABLE TOI CHECK CONSTRAINT ALL
go

--RATETAB
ALTER TABLE RATETAB NOCHECK CONSTRAINT ALL
go
--Disable Index
ALTER INDEX ALL ON RATETAB DISABLE
go
--Rebuild Index
ALTER INDEX ALL ON RATETAB REBUILD
go
--Enable CONSTRAINT
ALTER TABLE RATETAB CHECK CONSTRAINT ALL
go

--TOPRO
ALTER TABLE TOPRO NOCHECK CONSTRAINT ALL
go
--Disable Index
ALTER INDEX ALL ON TOPRO DISABLE
go
--Rebuild Index
ALTER INDEX ALL ON TOPRO REBUILD
go
--Enable CONSTRAINT
ALTER TABLE TOPRO CHECK CONSTRAINT ALL
go

--CT
ALTER TABLE CT NOCHECK CONSTRAINT ALL
go
--Disable Index
ALTER INDEX ALL ON CT DISABLE
go
--Rebuild Index
ALTER INDEX ALL ON CT REBUILD
go
--Enable CONSTRAINT
ALTER TABLE CT CHECK CONSTRAINT ALL
go

--Account
ALTER TABLE Account NOCHECK CONSTRAINT ALL
go
--Disable Index
ALTER INDEX ALL ON Account DISABLE
go
--Rebuild Index
ALTER INDEX ALL ON Account REBUILD
go
--Enable CONSTRAINT
ALTER TABLE Account CHECK CONSTRAINT ALL
go

--vType
ALTER TABLE vType NOCHECK CONSTRAINT ALL
go
--Disable Index
ALTER INDEX ALL ON vType DISABLE
go
--Rebuild Index
ALTER INDEX ALL ON vType REBUILD
go
--Enable CONSTRAINT
ALTER TABLE vType CHECK CONSTRAINT ALL
go

--MParam
ALTER TABLE MParam NOCHECK CONSTRAINT ALL
go
--Disable Index
ALTER INDEX ALL ON MParam DISABLE
go
--Rebuild Index
ALTER INDEX ALL ON MParam REBUILD
go
--Enable CONSTRAINT
ALTER TABLE MParam CHECK CONSTRAINT ALL
go





 insert into PatchVersioning
select '415 Script Disable Constraint Setup Table',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='415 Script Disable Constraint Setup Table'


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


