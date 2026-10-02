IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'City') AND type in (N'U'))
BEGIN
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
CREATE TABLE [dbo].[City](
	[City] [varchar](10) NOT NULL,
	[Description] [varchar](255) NULL,
	[Name] [varchar](255) NULL,
	[Province] [varchar](10) NOT NULL,
	[AllowedF] [bit] NULL,
	[Last_Update] [smalldatetime] NULL,
	[Last_OPR] [varchar](10) NULL,
 CONSTRAINT [I_City] PRIMARY KEY CLUSTERED 
(
	[City] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
SET ANSI_PADDING OFF
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Name' AND Object_ID = Object_ID(N'City'))
BEGIN
Alter Table City Add Name Varchar(255)
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Province' AND Object_ID = Object_ID(N'City'))
BEGIN
Alter Table City Add Province Varchar(50)
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Update' AND Object_ID = Object_ID(N'City'))
BEGIN
Alter Table City Add Last_Update smalldatetime
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Opr' AND Object_ID = Object_ID(N'City'))
BEGIN
Alter Table City Add Last_Opr Varchar(10)
end
GO
Update Province set Country = '' where Country is Null
GO
Update City set Province = '' where Province is Null
GO
Update City set AllowedF = 1 where AllowedF is null
GO
Update City set AllowedF = 1 where AllowedF = 0
GO


insert into PatchVersioning
select '120 Update Script - Table City',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='120 Update Script - Table City'


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
