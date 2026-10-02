
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AccTo' AND Object_ID = Object_ID(N'CSTALLOCATIOND'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.CSTALLOCATIOND ADD
	AccTo varchar(10) NULL
end
go

IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_CSTALLOCATIOND' AND object_id = OBJECT_ID(N'CSTALLOCATIOND'))
Begin
drop index CSTALLOCATIOND.I_CSTALLOCATIOND
end
GO
create unique index I_CSTALLOCATIOND on CSTALLOCATIOND(Branch, Account, AccTo, CT)
go



 insert into PatchVersioning
select '860 Update Script - 10 November 2023 (1)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='860 Update Script - 10 November 2023 (1)'


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

