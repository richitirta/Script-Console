IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Opr' AND Object_ID = Object_ID(N'CLINFO'))
BEGIN
ALTER TABLE dbo.CLINFO ADD
	Last_Opr varchar(50) NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Update' AND Object_ID = Object_ID(N'CLINFO'))
BEGIN
ALTER TABLE dbo.CLINFO ADD
	Last_Update smalldatetime NULL
end
GO




IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CLINFOSUPL') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[CLINFOSUPL](
	[CNO] [int] NOT NULL,
	[CATEGORY] [varchar](50) NOT NULL,
	[FLDID1] [varchar](10) NULL,
	[VALUEID1] [varchar](15) NULL,
	[VALUEDESC1] [varchar](8000) NULL,
	[FLDID2] [varchar](10) NULL,
	[VALUEID2] [varchar](15) NULL,
	[VALUEDESC2] [varchar](8000) NULL,
	[FLDID3] [varchar](10) NULL,
	[VALUEID3] [varchar](15) NULL,
	[VALUEDESC3] [varchar](8000) NULL,
	[FLDID4] [varchar](10) NULL,
	[VALUEID4] [varchar](15) NULL,
	[VALUEDESC4] [varchar](8000) NULL,
	[FLDID5] [varchar](10) NULL,
	[VALUEID5] [varchar](15) NULL,
	[VALUEDESC5] [varchar](8000) NULL,
	[FLDID6] [varchar](10) NULL,
	[VALUEID6] [varchar](15) NULL,
	[VALUEDESC6] [varchar](8000) NULL,
	[FLDID7] [varchar](10) NULL,
	[VALUEID7] [varchar](15) NULL,
	[VALUEDESC7] [varchar](8000) NULL,
	[FLDID8] [varchar](10) NULL,
	[VALUEID8] [varchar](15) NULL,
	[VALUEDESC8] [varchar](8000) NULL,
	[FLDID9] [varchar](10) NULL,
	[VALUEID9] [varchar](15) NULL,
	[VALUEDESC9] [varchar](8000) NULL,
	[FLDID10] [varchar](10) NULL,
	[VALUEID10] [varchar](15) NULL,
	[VALUEDESC10] [varchar](8000) NULL,
	[FLDID11] [varchar](10) NULL,
	[VALUEID11] [varchar](15) NULL,
	[VALUEDESC11] [varchar](8000) NULL,
	[FLDID12] [varchar](10) NULL,
	[VALUEID12] [varchar](15) NULL,
	[VALUEDESC12] [varchar](8000) NULL,
	[FLDID13] [varchar](10) NULL,
	[VALUEID13] [varchar](15) NULL,
	[VALUEDESC13] [varchar](8000) NULL,
	[FLDID14] [varchar](10) NULL,
	[VALUEID14] [varchar](15) NULL,
	[VALUEDESC14] [varchar](8000) NULL,
	[FLDID15] [varchar](10) NULL,
	[VALUEID15] [varchar](15) NULL,
	[VALUEDESC15] [varchar](8000) NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL
) ON [PRIMARY]



SET ANSI_PADDING OFF

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Original Claim No. (see Claim)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'CNO'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Claim Notes Category' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'CATEGORY'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Field ID #1 (see GenHTab)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'FLDID1'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Value ID #1 (see GenDTab)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEID1'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Value Desc #1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEDESC1'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'FLDID2'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEID2'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEDESC2'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'FLDID3'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEID3'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEDESC3'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'FLDID4'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEID4'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEDESC4'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'FLDID5'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEID5'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEDESC5'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'FLDID6'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEID6'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEDESC6'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'FLDID7'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEID7'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEDESC7'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'FLDID8'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEID8'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEDESC8'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'FLDID9'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEID9'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEDESC9'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'FLDID10'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEID10'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEDESC10'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'FLDID11'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEID11'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEDESC11'
 
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'FLDID12'
 
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEID12'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEDESC12'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'FLDID13'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEID13'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEDESC13'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'FLDID14'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEID14'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEDESC14'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'FLDID15'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEID15'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'-' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLINFOSUPL', @level2type=N'COLUMN',@level2name=N'VALUEDESC15'
end
GO 

IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_CLINFOSUPL' AND object_id = OBJECT_ID('CLINFOSUPL'))
BEGIN
Create Unique Index I_CLINFOSUPL ON CLINFOSUPL(CNO, CATEGORY)
end
go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Drop_Claim_Link') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure Drop_Claim_Link
end
GO
Create Procedure Drop_Claim_Link(@P_CNO as Int)  
AS   
  
Delete From CLAASS Where CNO=@P_CNO  
Delete From CLFD Where CNO=@P_CNO  
Delete From CLINFO Where CNO=@P_CNO  
Delete From CLFACDED Where CNO=@P_CNO  
Delete From CINFO Where CNO=@P_CNO  
Delete From CLSALITEM Where CNO=@P_CNO  
Delete From CLDED Where CNO=@P_CNO  
Delete From LCALC Where CNO=@P_CNO  
Delete From CLLOSS Where CNO=@P_CNO  
Delete From CLSAL Where CNO=@P_CNO  
Delete From CLNotify Where CNO=@P_CNO  
Delete From CLPIC Where CNO=@P_CNO  
Delete From CLCOST Where CNO=@P_CNO  
Delete From CLPrintLog Where CNO=@P_CNO  
Delete From CDOCSTAT Where CNO=@P_CNO  
Delete From CARRHEADER Where CNO=@P_CNO  
Delete From CLSub Where CNO=@P_CNO  
Delete From CCALC Where CNO=@P_CNO  
Delete From CLSurvey Where CNO=@P_CNO  
Delete From CDOCLIST Where CNO=@P_CNO  
Delete From CDOCLISTPIC Where CNO=@P_CNO  
Delete From CArrDetail Where CNO=@P_CNO  
Delete From CLNotes Where CNO=@P_CNO
Delete From CLINFOSUPL Where CNO=@P_CNO





go



 insert into PatchVersioning
select '280 Update Script - 3 June 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='280 Update Script - 3 June 2022'


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
