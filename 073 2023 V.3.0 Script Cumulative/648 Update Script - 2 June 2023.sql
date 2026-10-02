IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AUserID_Ext' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD
	AUserID_Ext varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Approving User ID (Extended/Second Approval)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Request', N'COLUMN', N'AUserID_Ext'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AUserDate_Ext' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE dbo.Request ADD
	AUserDate_Ext smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Approving User Date (Extended/Second Approval)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Request', N'COLUMN', N'AUserDate_Ext'
end
GO



 insert into PatchVersioning	
select '648 Update Script - 2 June 2023',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='648 Update Script - 2 June 2023'


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


   



