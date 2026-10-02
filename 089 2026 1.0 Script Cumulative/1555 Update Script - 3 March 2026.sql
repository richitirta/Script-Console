/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DaysAutoQuotationClose' AND Object_ID = Object_ID(N'ALRule'))

BEGIN
ALTER TABLE dbo.ALRule ADD
	DaysAutoQuotationClose int NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DaysAutoPolicyClose' AND Object_ID = Object_ID(N'ALRule'))

BEGIN
ALTER TABLE dbo.ALRule ADD
	DaysAutoPolicyClose int NULL
END
GO


DECLARE @v sql_variant 
SET @v = N'Number of Days Lapse Quotation will be closed'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ALRule', N'COLUMN', N'DaysAutoQuotationClose'
GO
DECLARE @v sql_variant 
SET @v = N'Number of Days Lapse Policy will be closed'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ALRule', N'COLUMN', N'DaysAutoPolicyClose'
GO



DROP Procedure AutoPolicy_Close
GO
CREATE Procedure AutoPolicy_Close(@P_PDate as smalldatetime)                    
as                    
Select A1.ANO, A1.RegNo, A1.LUserID  
from Acceptance A1  
Inner Join Cover C1 on (C1.CNO=A1.CNO)  
Inner Join TOC on (TOC.TOC=A1.TOC)  
Cross Apply (
	Select Top 1 ALRule.DaysAutoPolicyClose as Validation from ALRule Where ALRule.DaysAutoPolicyClose<>0 and (ALRule.TOC=A1.TOC and (ALRule.Branch='<All>' or (ALRule.Branch=A1.Branch)) and (ALRule.Segment='<All>' or (ALRule.Segment=C1.Segment)) and (ALRule.Source='<All>' or (ALRule.Source=A1.Source)))
) ALRule
Where (A1.LANO=-1 or (C1.OpenFlag=0 and A1.ANO=A1.LANO) or (C1.OpenFlag=1 and A1.ANO<>A1.LANO))  
and A1.AStatus = 'W' And A1.AType = 'N' and C1.ASource<>'MKT'  
and datediff(day,dateadd(day, ALRule.Validation, A1.RegDate),@P_PDate)>0 

GO


DROP Procedure AutoQuotation_Cancellation
GO
CREATE Procedure AutoQuotation_Cancellation(@P_PDate as smalldatetime)                  
as                  
Select A1.ANO, C1.CoverNo, C1.PUserID    
from Acceptance A1  
Inner Join Cover C1 on (C1.CNO=A1.CNO)  
Cross Apply (
	Select Top 1 ALRule.DaysAutoQuotationClose as Validation from ALRule Where ALRule.DaysAutoQuotationClose<>0 and (ALRule.TOC=A1.TOC and (ALRule.Branch='<All>' or (ALRule.Branch=A1.Branch)) and (ALRule.Segment='<All>' or (ALRule.Segment=C1.Segment)) and (ALRule.Source='<All>' or (ALRule.Source=A1.Source)))
) ALRule
Where (A1.LANO=-1 or A1.ANO=A1.LANO)     
and A1.AStatus = 'W' And A1.AType = 'N' and C1.ASource='MKT'   
and C1.CStatus in ('P') And datediff(day,dateadd(day, ALRule.Validation, C1.PUserDate),@P_PDate)>0 
  GO


insert into PatchVersioning
select '1555 Update Script - 3 March 2026.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1555 Update Script - 3 March 2026.sql'


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