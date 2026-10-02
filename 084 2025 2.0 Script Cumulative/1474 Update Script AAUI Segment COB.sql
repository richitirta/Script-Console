
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[COBGROUP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[COBGROUP](
	[COBGROUP] [varchar](10) NOT NULL,
	[Description] [varchar](255) NULL,
	[AllowedF] [bit] NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL
 CONSTRAINT [I_COBGROUP] PRIMARY KEY CLUSTERED 
(
	[COBGROUP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [dbo].[COBGROUP] SET (LOCK_ESCALATION = DISABLE)
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'COB GROUP ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COBGROUP', @level2type=N'COLUMN',@level2name=N'COBGROUP'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'COB GROUP Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COBGROUP', @level2type=N'COLUMN',@level2name=N'Description'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'COBGROUP' AND Object_ID = Object_ID(N'COB'))
BEGIN
ALTER TABLE dbo.COB ADD
	COBGROUP varchar(10)
	DECLARE @v sql_variant 
SET @v = N'COBGROUP'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'COB', N'COLUMN', N'COBGROUP'
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DESCRIPTION_1' AND Object_ID = Object_ID(N'COB'))
BEGIN
ALTER TABLE dbo.COB ADD
	DESCRIPTION_1	varchar(50)
	DECLARE @v sql_variant 
DECLARE @v sql_variant 
SET @v = N'DESCRIPTION For AAUI'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'COB', N'COLUMN', N'DESCRIPTION_1'
go


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Segment_AAUI]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Segment_AAUI](
	[Segment_AAUI] [varchar](10) NOT NULL,
	[Description] [varchar](255) NULL,
	[AllowedF] [bit] NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL

 CONSTRAINT [I_Segment_AAUI] PRIMARY KEY CLUSTERED 
(
	[Segment_AAUI] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [dbo].[Segment_AAUI] SET (LOCK_ESCALATION = DISABLE)
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Segment_AAUI ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Segment_AAUI', @level2type=N'COLUMN',@level2name=N'Segment_AAUI'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Segment_AAUI Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Segment_AAUI', @level2type=N'COLUMN',@level2name=N'Description'
end
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Segment_AAUI' AND Object_ID = Object_ID(N'Segment'))
BEGIN
ALTER TABLE dbo.Segment ADD
	Segment_AAUI varchar(10)
end
DECLARE @v sql_variant 
SET @v = N'Segment_AAUI'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Segment', N'COLUMN', N'Segment_AAUI'
GO
go




insert into PatchVersioning
select '1474 Update Script AAUI Segment COB.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1474 Update Script AAUI Segment COB.sql'


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

GO 

