IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OPID' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE dbo.Scheme_Transaction ADD
	OPID varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Other Parties Fee ID (See Profile)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'OPID'
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OPFDID' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE dbo.Scheme_Transaction ADD
	OPFDID varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Other Parties Fee Type (see FDTAB)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'OPFDID'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OPFEE' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE dbo.Scheme_Transaction ADD
	OPFEE float(53) NULL

DECLARE @v sql_variant 
SET @v = N'OP Fee in %'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'OPFEE'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OPFEEAMOUNT' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE dbo.Scheme_Transaction ADD
	OPFEEAMOUNT float(53) NULL
DECLARE @v sql_variant 
SET @v = N'OP Fee in Amount'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'OPFEEAMOUNT'
end
go




 insert into PatchVersioning	
select '576 Update Script - 28 February 2023 (1)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='576 Update Script - 28 February 2023 (1)'


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



