IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWMANUALJOURNAL')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'ALLOWMANUALJOURNAL','ALLOW INPUT MANUAL JOURNAL', 'ACTIVITIES',0
end
go

insert into SysUserForm(Type, FName, ReadF, WriteF, AddF, DeleteF, CheckF, ModifyF)
Select Type,'ALLOWMANUALJOURNAL',0,1,0,0,0,0
from sysusertype
go



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AUserID' AND Object_ID = Object_ID(N'mVoucher'))
BEGIN
ALTER TABLE dbo.mVoucher ADD
	AUserID varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Approving User ID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'mVoucher', N'COLUMN', N'AUserID'
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AUserDate' AND Object_ID = Object_ID(N'mVoucher'))
BEGIN
ALTER TABLE dbo.mVoucher ADD
	AUserDate smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Approving User Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'mVoucher', N'COLUMN', N'AUserDate'
end
GO



 insert into PatchVersioning	
select '643 Update Script - 29 May 2023',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='643 Update Script - 29 May 2023'


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


