

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OCollNo' AND Object_ID = Object_ID(N'COLLECTIONH'))
BEGIN
ALTER TABLE dbo.COLLECTIONH ADD
	OCollNo varchar(20) NULL
DECLARE @v sql_variant 
SET @v = N'Original Collection No (CollNo from Reminder=0)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'COLLECTIONH', N'COLUMN', N'OCollNo'
end
GO
 
 

 insert into PatchVersioning
select '440 Update Script - 19 October 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='440 Update Script - 19 October 2022'


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
