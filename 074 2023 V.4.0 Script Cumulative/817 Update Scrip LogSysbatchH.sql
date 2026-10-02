
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LogSysbatchH]') AND type in (N'U'))
DROP TABLE [dbo].[LogSysbatchH]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LogSysbatchH](
	[BatchNo] [varchar](50) NOT NULL,
	[Validation_date] [smalldatetime] NULL,
	[Validation_Time] [varchar](8) NULL,
	[Start_date] [smalldatetime] NULL,
	[Start_Time] [varchar](8) NULL,
	[End_date] [smalldatetime] NULL,
	[End_Time] [varchar](8) NULL,
 CONSTRAINT [I_SysbatchUpload] PRIMARY KEY NONCLUSTERED 
(
	[BatchNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[LogSysbatchH] SET (LOCK_ESCALATION = DISABLE)
GO

 insert into PatchVersioning
select '817 Update Scrip LogSysbatchH',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='817 Update Scrip LogSysbatchH'


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



