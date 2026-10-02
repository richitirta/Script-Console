IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'KOLCATEGORY') AND type in (N'U'))
begin
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[KOLCATEGORY](
	[KOLCATEGORY] [varchar](20) NOT NULL,
	[TAX] [float] NULL
) ON [PRIMARY]

ALTER TABLE KOLCATEGORY ADD PRIMARY KEY (KOLCATEGORY)


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'KIND OF LOSS CATEGORY' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'KOLCATEGORY', @level2type=N'COLUMN',@level2name=N'KOLCATEGORY'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'TAX RATE (0 NOT APPLY, ELSE OVERWRITE PROFILE TAX RATE FOR LOSS ITEM CLAIM)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'KOLCATEGORY', @level2type=N'COLUMN',@level2name=N'TAX'

end
go


INSERT INTO KOLCATEGORY(KOLCATEGORY,TAX)
Select *
from
(
SELECT 'ACCESSORIES' as KOLCategory, 0 as TAX
UNION ALL
SELECT 'INDEMNITY' as KOLCategory, 0 as TAX
UNION ALL
SELECT 'INS.BENEFIT' as KOLCategory, 0 as TAX
UNION ALL
SELECT 'MATERIAL' as KOLCategory, 0 as TAX
UNION ALL
SELECT 'REINSTATEMENT' as KOLCategory, 0 as TAX
UNION ALL
SELECT 'REPAIR' as KOLCategory, 0 as TAX
UNION ALL
SELECT 'REPLACEMENT' as KOLCategory, 0 as TAX
UNION ALL
SELECT 'SERVICE' as KOLCategory, 0 as TAX
UNION ALL
SELECT 'SPAREPART' as KOLCategory, 0 as TAX
UNION ALL
SELECT 'SPECIAL REPAIR' as KOLCategory, 0 as TAX
UNION ALL
SELECT 'REIMBURSEMENT' as KOLCategory, 0 as TAX
UNION ALL
SELECT 'FNOL' as KOLCategory, 0 as TAX
) C
go



  insert into PatchVersioning
select '1189 Update Script - 18 October 2024',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1189 Update Script - 18 October 2024'


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

