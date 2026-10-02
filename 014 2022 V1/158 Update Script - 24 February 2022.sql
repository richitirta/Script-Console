SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'TOPRO_RATECON') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[TOPRO_RATECON](
	[TOPRO_RATECON] [int] NOT NULL,
	[TOPRO] [varchar](10) NULL,
	[CODE] [varchar](10) NULL,
	[MINTSI] [float] NULL,
	[MAXTSI] [float] NULL,
	[ALLOWEDF] [bit] NULL,
	[FLDID1] [varchar](10) NULL,
	[VALUEID1] [varchar](15) NULL,
	[VALUEDESC1] [varchar](255) NULL,
	[FLDID2] [varchar](10) NULL,
	[VALUEID2] [varchar](15) NULL,
	[VALUEDESC2] [varchar](255) NULL,
	[FLDID3] [varchar](10) NULL,
	[VALUEID3] [varchar](15) NULL,
	[VALUEDESC3] [varchar](255) NULL,
	[FLDID4] [varchar](10) NULL,
	[VALUEID4] [varchar](15) NULL,
	[VALUEDESC4] [varchar](255) NULL,
	[FLDID5] [varchar](10) NULL,
	[VALUEID5] [varchar](15) NULL,
	[VALUEDESC5] [varchar](255) NULL,
	[FLDID6] [varchar](10) NULL,
	[VALUEID6] [varchar](15) NULL,
	[VALUEDESC6] [varchar](255) NULL,
	[FLDID7] [varchar](10) NULL,
	[VALUEID7] [varchar](15) NULL,
	[VALUEDESC7] [varchar](255) NULL,
	[FLDID8] [varchar](10) NULL,
	[VALUEID8] [varchar](15) NULL,
	[VALUEDESC8] [varchar](255) NULL,
	[FLDID9] [varchar](10) NULL,
	[VALUEID9] [varchar](15) NULL,
	[VALUEDESC9] [varchar](255) NULL,
	[FLDID10] [varchar](10) NULL,
	[VALUEID10] [varchar](15) NULL,
	[VALUEDESC10] [varchar](255) NULL,
	[FLDID11] [varchar](10) NULL,
	[VALUEID11] [varchar](15) NULL,
	[VALUEDESC11] [varchar](255) NULL,
	[FLDID12] [varchar](10) NULL,
	[VALUEID12] [varchar](15) NULL,
	[VALUEDESC12] [varchar](255) NULL,
	[FLDID13] [varchar](10) NULL,
	[VALUEID13] [varchar](15) NULL,
	[VALUEDESC13] [varchar](255) NULL,
	[FLDID14] [varchar](50) NULL,
	[VALUEID14] [varchar](15) NULL,
	[VALUEDESC14] [varchar](255) NULL,
	[FLDID15] [varchar](10) NULL,
	[VALUEID15] [varchar](15) NULL,
	[VALUEDESC15] [varchar](255) NULL,
	[MinPeriod] [int] NULL,
	[MaxPeriod] [int] NULL,
	[CRATE] [float] NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
 CONSTRAINT [I_TOPRO_RATECON] PRIMARY KEY NONCLUSTERED 
(
	[TOPRO_RATECON] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Rate Condition ID (Auto Generated)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'TOPRO_RATECON'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'TOPRO Code (see TOPRO)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'TOPRO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Code (see RateTab)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'Code'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Minimum Sum Insured' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'MINTSI'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Maximum Sum Insured' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'MAXTSI'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Allow Selection Flag (0 : No, 1 : Yes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'ALLOWEDF'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Field ID #1 (See GenhTAB)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'FLDID1'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Value ID #1 (see GenDTab)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEID1'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Value Description #1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEDESC1'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'FLDID2'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEID2'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEDESC2'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'FLDID3'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEID3'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEDESC3'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'FLDID4'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEID4'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEDESC4'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'FLDID5'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEID5'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEDESC5'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'FLDID6'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEID6'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEDESC6'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'FLDID7'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEID7'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEDESC7'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'FLDID8'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEID8'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEDESC8'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'FLDID9'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEID9'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEDESC9'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'FLDID10'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEID10'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEDESC10'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'FLDID11'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEID11'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEDESC11'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'FLDID12'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEID12'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEDESC12'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'FLDID13'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEID13'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEDESC13'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'FLDID14'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEID14'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEDESC14'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'FLDID15'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEID15'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'VALUEDESC15'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Minimum Period in Months' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'MinPeriod'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Maximum Period in Months' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'MaxPeriod'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Combined Rate / Package See TOPRO for Risk with RateIncludeF=1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TOPRO_RATECON', @level2type=N'COLUMN',@level2name=N'CRATE'

end
GO

SET ANSI_PADDING OFF
GO

IF not EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='TOPRO_RATECON' AND CONSTRAINT_NAME='FK_TOPRO_RATECON_TOPRO')
Begin
ALTER TABLE [dbo].[TOPRO_RATECON]  WITH NOCHECK ADD  CONSTRAINT [FK_TOPRO_RATECON_TOPRO] FOREIGN KEY([TOPRO])
REFERENCES [dbo].[TOPRO] ([TOPRO])
ON UPDATE CASCADE
ON DELETE CASCADE
end
GO
ALTER TABLE [dbo].[TOPRO_RATECON] CHECK CONSTRAINT [FK_TOPRO_RATECON_TOPRO]
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QTOPRateConCode') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QTOPRateConCode  END 
GO
CREATE procedure QTOPRateConCode(@p_code varchar (10), @p_TOPRO varchar(10))  
as  
SELECT Distinct RateTab.Code, RateTab.Description, RateTab.SIBasedID, RateTab.SPeriod
From TOP_RATE T
Inner join RateTab on (RateTab.Code=T.Code and T.Category='M')
Where T.TOPRO=@P_TOPRO and RateTab.Code Like @P_Code 


go




 insert into PatchVersioning
select '158 Update Script - 24 February 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='158 Update Script - 24 February 2022'


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