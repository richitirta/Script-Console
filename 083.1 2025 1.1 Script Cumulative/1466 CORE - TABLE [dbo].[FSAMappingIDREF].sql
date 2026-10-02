SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON

GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FSAMappingIDRef') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[FSAMappingIDRef](
	[IDREF] [varchar](100) NOT NULL,
	[Description] [varchar](255) NULL,
	[AllowedF] [bit] NULL
 CONSTRAINT [I_FSAMappingIDREF] PRIMARY KEY CLUSTERED 
(
	[IDREF] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

ALTER TABLE [dbo].[FSAMappingIDRef] SET (LOCK_ESCALATION = DISABLE)
GO


insert into PatchVersioning
select '1466 CORE - TABLE [dbo].[FSAMappingIDREF].sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1466 CORE - TABLE [dbo].[FSAMappingIDREF].sql'


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