

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SCHEME_INPARTY') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SCHEME_INPARTY](
	[TrNo] [int] NOT NULL,
	[ID] [varchar](10) NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[IType] [varchar](20) NULL,
	[ID_Type] [varchar](10) NULL,
	[ID_NO] [varchar](20) NULL,
	[Address_1] [varchar](255) NULL,
	[Address_2] [varchar](255) NULL,
	[GENDER] [varchar](30) NULL,
	[RELATION] [varchar](30) NULL,
	[BirthDate] [smalldatetime] NULL,
	[BirthPlace] [varchar](255) NULL,
	[REMARK] [varchar](255) NULL,
	[PassPortNo] [varchar](30) NULL,
	[Beneficiary_Name] [varchar](255) NULL,
	[Beneficiary_Relation] [varchar](30) NULL,
	[WNIF] [bit] NULL,
	[Citizen] [varchar](50) NULL,
	[IPNO] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [I_SCHEME_INPARTY] PRIMARY KEY NONCLUSTERED 
(
	[TrNo] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


SET ANSI_PADDING OFF


ALTER TABLE [dbo].[SCHEME_INPARTY]  WITH NOCHECK ADD  CONSTRAINT [FK_SCHEME_INPARTY_Scheme_Transaction] FOREIGN KEY([TrNo])
REFERENCES [dbo].[Scheme_Transaction] ([TrNo])
ON UPDATE CASCADE
ON DELETE CASCADE


ALTER TABLE [dbo].[SCHEME_INPARTY] CHECK CONSTRAINT [FK_SCHEME_INPARTY_Scheme_Transaction]


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Scheme Transaction No' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCHEME_INPARTY', @level2type=N'COLUMN',@level2name=N'TRNO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Interested Party Profile ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCHEME_INPARTY', @level2type=N'COLUMN',@level2name=N'ID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Beneficiaries Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCHEME_INPARTY', @level2type=N'COLUMN',@level2name=N'Name'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Interest Type (''MORTGAGE'',''LEASED ASSET'',''OTHERS)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCHEME_INPARTY', @level2type=N'COLUMN',@level2name=N'IType'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identification Type (SIM/KTP/etc)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCHEME_INPARTY', @level2type=N'COLUMN',@level2name=N'ID_Type'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identification No. (KTP No/etc)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCHEME_INPARTY', @level2type=N'COLUMN',@level2name=N'ID_NO'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Beneficiaries Address' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCHEME_INPARTY', @level2type=N'COLUMN',@level2name=N'Address_1'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Beneficiaries Zip Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCHEME_INPARTY', @level2type=N'COLUMN',@level2name=N'Address_2'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gender' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCHEME_INPARTY', @level2type=N'COLUMN',@level2name=N'GENDER'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Insured Relation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCHEME_INPARTY', @level2type=N'COLUMN',@level2name=N'RELATION'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Remarks' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCHEME_INPARTY', @level2type=N'COLUMN',@level2name=N'REMARK'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CitizenShip Flag (0 : Non WNI/Asing, 1 : WNI)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCHEME_INPARTY', @level2type=N'COLUMN',@level2name=N'WNIF'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Citizen Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCHEME_INPARTY', @level2type=N'COLUMN',@level2name=N'Citizen'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Record No.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SCHEME_INPARTY', @level2type=N'COLUMN',@level2name=N'IPNO'



END
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QSchemeInParty') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN 
DROP PROCEDURE QSchemeInParty
END
GO
CREATE PROCEDURE QSchemeInParty(@P_TrNo as integer, @P_Name varchar(255))     
AS    
Select *
from Scheme_InParty
Where TrNo=@P_TrNo and Name=@P_Name
GO



 insert into PatchVersioning
select '362 Update Script - 2 August 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='362 Update Script - 2 August 2022'


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