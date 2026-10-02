
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MAP_PLB') AND type in (N'U'))

BEGIN

CREATE TABLE [dbo].[MAP_PLB](
	[MapID] Int NOT NULL,
	[TbName] [Varchar] (50) NOT NULL,
	[ColName] [Varchar] (50) NOT NULL,
	[Col_Description] [varchar](512) NOT NULL,
	[ColName_Ext] [Varchar] (50) NOT NULL,
	[Col_Ext_Description] [varchar](512) NOT NULL,
	[Remarks] [varchar](512) NOT NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL
	
 CONSTRAINT [i_MAP_PLB] PRIMARY KEY NONCLUSTERED 
(
	[MapID] ASC
	
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

ALTER TABLE [dbo].[MAP_PLB] SET (LOCK_ESCALATION = DISABLE)
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mapping ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MAP_PLB', @level2type=N'COLUMN',@level2name=N'MapID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Table Mapping' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MAP_PLB', @level2type=N'COLUMN',@level2name=N'TbName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Field Name In Care' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MAP_PLB', @level2type=N'COLUMN',@level2name=N'ColName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Field Name In Care Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MAP_PLB', @level2type=N'COLUMN',@level2name=N'Col_Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Field Name In PLB' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MAP_PLB', @level2type=N'COLUMN',@level2name=N'ColName_Ext'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Field Name In PLB Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MAP_PLB', @level2type=N'COLUMN',@level2name=N'Col_Ext_Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Remarks Mapping Field' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MAP_PLB', @level2type=N'COLUMN',@level2name=N'Remarks'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last User Update' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MAP_PLB', @level2type=N'COLUMN',@level2name=N'Last_Opr'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last Date Update' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MAP_PLB', @level2type=N'COLUMN',@level2name=N'Last_Update'
GO



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Table_PLB') AND type in (N'U'))

BEGIN

CREATE TABLE [dbo].[Table_PLB](
	[TbName] [Varchar] (50) NOT NULL,
	[Description] [varchar](512) NULL)

END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Table Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Table_PLB', @level2type=N'COLUMN',@level2name=N'TbName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Table_PLB', @level2type=N'COLUMN',@level2name=N'Description'
GO

ALTER TABLE [dbo].[Table_PLB] SET (LOCK_ESCALATION = DISABLE)
GO


insert into Table_PLB select 'Underwriter','Underwriter'
go
insert into Table_PLB select 'Processor','Processor'
go
insert into Table_PLB select 'TFSCode','TFS Code and Name'
go
insert into Table_PLB select 'Intermediary','Intermediary Name and Code'
go
insert into Table_PLB select 'Brokers','Brokers'
go
insert into Table_PLB select 'RIBrokers','RI Brokers'
go
insert into Table_PLB select 'ProcessingOffice','Processing Office'
go
insert into Table_PLB select 'COL','Cause of Loss'
go
insert into Table_PLB select 'Carrier','Carrier'
go
insert into Table_PLB select 'RIStructure','RI Structure'
go
insert into Table_PLB select 'LOB','Minor LOB'
go



insert into PatchVersioning
select '1546 Update Script - 13 Feb 2026.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1546 Update Script - 13 Feb 2026.sql'


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