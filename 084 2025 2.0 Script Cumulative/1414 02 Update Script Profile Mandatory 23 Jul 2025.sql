
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Profile_Mandatory') AND type in (N'U'))
begin
CREATE TABLE [dbo].[Profile_Mandatory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CorporateF] [bit] NULL,
	[IndividualF] [bit] NULL,
	[IntermediaryF] [bit] NULL,
	[PanelName] [varchar](128) NOT NULL,
	[ControlName] [varchar](128) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[FieldName] [varchar](128) NOT NULL,
	[MaxLen] [int] NULL,
	[MaxLen_Ext] [int] NULL,
	[MaxLen_Ext_1] [int] NULL
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
end
GO


insert into PatchVersioning
select '1414 02 Update Script Profile Mandatory 23 Jul 2025',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrScript='1414 02 Update Script Profile Mandatory 23 Jul 2025'


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