SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


IF NOT EXISTS(SELECT * FROM ISType WHERE ISType in('N','Q','S','A','P'))
begin
insert into ISType(ISType, Description)
Select 'N','Inward Facultative-Non Prop'
Union all
Select 'Q','Inward Treaty-Prop-Quota Share'
Union all
Select 'S','Inward Treaty-Prop-Surplus'
Union all
Select 'A','Inward Treaty-Prop-Auto Fac/Obligatory'
Union all
Select 'P','Inward Treaty-Non Prop- Stop Loss'
END
GO

Update ISType Set Description='Inward Treaty-Non Prop-Excess Of Loss' Where ISType='X'
GO

IF NOT EXISTS(SELECT * FROM MParam WHERE Type='FX')
begin
Insert into MParam(Type, Remarks, MemorialF, Effective, Last_Opr, Last_Update) 
Select 'FX', 'Facultative Non Propportional',0,cast(convert(varchar(10), getdate(),1) as smalldatetime),'care',cast(convert(varchar(10), getdate(),1) as smalldatetime)
END
GO

Update MParam Set Remarks= 'Excess Of Loss - Stop Loss' Where Type='XX'
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AllowedF' AND Object_ID = Object_ID(N'ISTYPE'))
BEGIN
ALTER TABLE dbo.ISTYPE ADD AllowedF bit NULL
END
GO

Update ISType Set AllowedF=0 Where AllowedF is null
GO

Update ISType Set AllowedF=1 Where ISType in ('C','I','L','R','T')
GO

insert into PatchVersioning
select '1344 Update Script - Patch 2025 (25)',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1344 Update Script - Patch 2025 (25)'


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



