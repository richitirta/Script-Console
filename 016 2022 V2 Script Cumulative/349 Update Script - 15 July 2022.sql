
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ISID' AND Object_ID = Object_ID(N'SysUser'))
BEGIN
ALTER TABLE dbo.SysUser ADD
	ISID varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Integrated Security ID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysUser', N'COLUMN', N'ISID'
end
GO

IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_SysUser_ISID' AND object_id = OBJECT_ID('SysUser'))
BEGIN
Create Index I_SysUser_ISID on SysUser(ISID)
end
go


 insert into PatchVersioning
select '349 Update Script - 15 July 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='349 Update Script - 15 July 2022'


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

