IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Name' AND Object_ID = Object_ID(N'CLSub'))
BEGIN
ALTER TABLE dbo.CLSub ADD
	Name varchar(255) NULL
DECLARE @v sql_variant 
SET @v = N'Policy Holder Source Name'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLSub', N'COLUMN', N'Name'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Address_1' AND Object_ID = Object_ID(N'CLSub'))
BEGIN
ALTER TABLE dbo.CLSub ADD
	Address_1 varchar(255) NULL
DECLARE @v sql_variant 
SET @v = cast(N'Profile Address 1' as varchar(15))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLSub', N'COLUMN', N'Address_1'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Address_2' AND Object_ID = Object_ID(N'CLSub'))
BEGIN
ALTER TABLE dbo.CLSub ADD
	Address_2 varchar(255) NULL
DECLARE @v sql_variant 
SET @v = cast(N'Profile Address 2' as varchar(15))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLSub', N'COLUMN', N'Address_2'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Address_3' AND Object_ID = Object_ID(N'CLSub'))
BEGIN
ALTER TABLE dbo.CLSub ADD
	Address_3 varchar(255) NULL
DECLARE @v sql_variant 
SET @v = cast(N'Profile Address 3' as varchar(15))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLSub', N'COLUMN', N'Address_3'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Phone_1' AND Object_ID = Object_ID(N'CLSub'))
BEGIN
ALTER TABLE dbo.CLSub ADD
	Phone_1 varchar(30) NULL
DECLARE @v sql_variant 
SET @v = cast(N'Profile Phone' as varchar(13))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLSub', N'COLUMN', N'Phone_1'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Fax_1' AND Object_ID = Object_ID(N'CLSub'))
BEGIN
ALTER TABLE dbo.CLSub ADD
	Fax_1 varchar(30) NULL
DECLARE @v sql_variant 
SET @v = cast(N'Profile Fax' as varchar(11))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLSub', N'COLUMN', N'Fax_1'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PTYPE' AND Object_ID = Object_ID(N'CLSub'))
BEGIN
ALTER TABLE dbo.CLSub ADD
	PTYPE varchar(1) NULL
DECLARE @v sql_variant 
SET @v = cast(N'Profile Type C=Captive, D=Direct, M=Intermediaries, I=Inward, O=Outward, T=Others (see Method)' as varchar(94))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLSub', N'COLUMN', N'PTYPE'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BRANCH' AND Object_ID = Object_ID(N'CLSub'))
BEGIN
ALTER TABLE dbo.CLSub ADD
	BRANCH varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Segment ID (see Segment)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLSub', N'COLUMN', N'BRANCH'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CGroup' AND Object_ID = Object_ID(N'CLSub'))
BEGIN
ALTER TABLE dbo.CLSub ADD
	CGroup varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Company Group ID (see CGroup)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLSub', N'COLUMN', N'CGroup'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Area' AND Object_ID = Object_ID(N'CLSub'))
BEGIN
ALTER TABLE dbo.CLSub ADD
	Area varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Area (see Area)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLSub', N'COLUMN', N'Area'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PIC_TITLE_1' AND Object_ID = Object_ID(N'CLSub'))
BEGIN
ALTER TABLE dbo.CLSub ADD
	PIC_TITLE_1 varchar(255) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PIC_NAME_1' AND Object_ID = Object_ID(N'CLSub'))
BEGIN
ALTER TABLE dbo.CLSub ADD
	PIC_NAME_1 varchar(50) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PIC_TITLE_2' AND Object_ID = Object_ID(N'CLSub'))
BEGIN
ALTER TABLE dbo.CLSub ADD
	PIC_TITLE_2 varchar(255) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PIC_NAME_2' AND Object_ID = Object_ID(N'CLSub'))
BEGIN
ALTER TABLE dbo.CLSub ADD
	PIC_NAME_2 varchar(50) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PIC_TITLE_3' AND Object_ID = Object_ID(N'CLSub'))
BEGIN
ALTER TABLE dbo.CLSub ADD
	PIC_TITLE_3 varchar(255) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PIC_NAME_3' AND Object_ID = Object_ID(N'CLSub'))
BEGIN
ALTER TABLE dbo.CLSub ADD
	PIC_NAME_3 varchar(50) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'HOMEPAGE' AND Object_ID = Object_ID(N'CLSub'))
BEGIN
ALTER TABLE dbo.CLSub ADD
	HOMEPAGE varchar(50) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PrivilegeType' AND Object_ID = Object_ID(N'CLSub'))
BEGIN
ALTER TABLE dbo.CLSub ADD
	PrivilegeType varchar(10) NULL
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Address_3' AND Object_ID = Object_ID(N'CLSub'))
BEGIN
ALTER TABLE dbo.Service ADD
	Address_3 varchar(255) NULL
DECLARE @v sql_variant 
SET @v = cast(N'Profile Address' as varchar(15))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Service', N'COLUMN', N'Address_3'
END
GO



 insert into PatchVersioning	
select '529 Update Script - 10 January 2023 (2)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='529 Update Script - 10 January 2023 (2)'


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

