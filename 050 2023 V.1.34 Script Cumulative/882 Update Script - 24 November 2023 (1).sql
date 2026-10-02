IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FANOTES') AND type in (N'U'))
BEGIN
/****** Object:  Table [dbo].[FANOTES]    Script Date: 11/24/2023 9:12:52 PM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[FANOTES](
	[PID] [int] IDENTITY(1,1) NOT NULL,
	[DocNo] [varchar](50) NULL,
	[Date] [smalldatetime] NOT NULL,
	[Time] [varchar](8) NULL,
	[UserID] [varchar](50) NULL,
	[Category] [varchar](50) NULL,
	[Notes] [varchar](max) NULL,
	[SYSTEMF] [bit] NULL,
 CONSTRAINT [I_FANOTES] PRIMARY KEY CLUSTERED 
(
	[PID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
end
GO
IF not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_FANOTES_DOCNO' AND object_id = OBJECT_ID('FANOTES'))
BEGIN
Create Index I_FANOTES_DOCNO on FANOTES(DOCNO)
END
GO




 insert into PatchVersioning
select '882 Update Script - 24 November 2023 (1)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='882 Update Script - 24 November 2023 (1)'


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
