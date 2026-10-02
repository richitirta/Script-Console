SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[HospitalCode]') AND type in (N'U'))

BEGIN

CREATE TABLE [dbo].[HospitalCode](
	[HospitalCode] [varchar](10) NOT NULL,
	[DESCRIPTION] [nvarchar](255) NULL,
	[DESCRIPTION_1] [nvarchar](255) NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
	[AllowedF] [bit] NULL,
 CONSTRAINT [I_HospitalCode] PRIMARY KEY CLUSTERED 
(
	[HospitalCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[[MedicalCode]]') AND type in (N'U'))

BEGIN

CREATE TABLE [dbo].[MedicalCode](
	[MedicalCode] [varchar](10) NOT NULL,
	[DESCRIPTION] [nvarchar](255) NULL,
	[DESCRIPTION_1] [nvarchar](255) NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
	[AllowedF] [bit] NULL,
 CONSTRAINT [I_MedicalCode] PRIMARY KEY CLUSTERED 
(
	[MedicalCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[[[PetitionType]]]') AND type in (N'U'))

BEGIN
CREATE TABLE [dbo].[PetitionType](
	[PetitionType] [varchar](10) NOT NULL,
	[DESCRIPTION] [nvarchar](255) NULL
 CONSTRAINT [I_PetitionType] PRIMARY KEY CLUSTERED 
(
	[PetitionType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[[[[CLITEM_EXT]]]]') AND type in (N'U'))

BEGIN
CREATE TABLE [dbo].[CLITEM_EXT](
	[CNO] [int] NOT NULL,
	[INO] [int] NOT NULL,
	[Payment] [varchar](10) NOT NULL,
	[NOC] [varchar](10) NOT NULL,
	[Currency] [varchar](5) NOT NULL,
	[RefNo] [varchar](50) NULL,
	[HospitalCode] [varchar](10) NULL,
	[ReceiptNo] [varchar](50) NULL,
	[ReceiptDate] [smalldatetime] NULL,
	[PetitionType] [varchar](10) NULL,
	[MedicalCode] [varchar](10) NULL,
	[MedicalAmount] [float] NULL,
	[OrderNo] [Int] NULL
) ON [PRIMARY]
END
GO

ALTER TABLE [dbo].[CLITEM_EXT] SET (LOCK_ESCALATION = DISABLE)
GO

ALTER TABLE [dbo].[CLITEM_EXT]  WITH NOCHECK ADD  CONSTRAINT [FK_CLITEM_EXT_CLLOSS] FOREIGN KEY([CNO], [INO], [NOC], [Payment], [Currency], [RefNo])
REFERENCES [dbo].[CLLOSS] ([CNO], [INO], [NOC], [Payment], [Currency], [RefNo])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[CLITEM_EXT] CHECK CONSTRAINT [FK_CLITEM_EXT_CLLOSS]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Claim No. (see Claim)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLITEM_EXT', @level2type=N'COLUMN',@level2name=N'CNO'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Interest No. (see ICover)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLITEM_EXT', @level2type=N'COLUMN',@level2name=N'INO'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Payment Profile ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLITEM_EXT', @level2type=N'COLUMN',@level2name=N'Payment'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nature Of Claim Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLITEM_EXT', @level2type=N'COLUMN',@level2name=N'NOC'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Claim Currency' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLITEM_EXT', @level2type=N'COLUMN',@level2name=N'Currency'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Loss Item Reference No' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLITEM_EXT', @level2type=N'COLUMN',@level2name=N'RefNo'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'HospitalCode (see HospitalCode Table)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLITEM_EXT', @level2type=N'COLUMN',@level2name=N'HospitalCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'MedicalCode (see MedicalCode Table)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLITEM_EXT', @level2type=N'COLUMN',@level2name=N'MedicalCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PetitionType (see PetitionType Table)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLITEM_EXT', @level2type=N'COLUMN',@level2name=N'PetitionType'
GO


Create unique index I_CLITEM_EXT ON CLITEM_EXT(CNO, INO, NOC, Payment, Currency, RefNo, HospitalCode, MedicalCode)
GO


insert into PatchVersioning
select '1533 Update Script - 08 October 2025.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1533 Update Script - 08 October 2025.sql'


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