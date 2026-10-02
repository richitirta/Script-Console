IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PolicyYear' AND Object_ID = Object_ID(N'Scheme_Deductible'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.Scheme_Deductible ADD
	PolicyYear int NULL
DECLARE @v sql_variant 
SET @v = N'Deductible Applicable Policy Year (0 : Whole Policy Year, 1 : 1st Policy Year, ..)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Deductible', N'COLUMN', N'PolicyYear'
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PolicyYear' AND Object_ID = Object_ID(N'Scheme_Deductible'))
BEGIN
Alter Table Scheme_Deductible Alter Column PolicyYear Int Not Null
end
GO

Alter Table Scheme_Deductible drop constraint i_Scheme_Deductible
GO
ALTER TABLE Scheme_Deductible Add Constraint i_Scheme_Deductible Primary Key (ClassNo, Coverage, Lower, DCode, PolicyYear)

GO

DROP Procedure QScheme_Verify_5    
GO
CREATE Procedure QScheme_Verify_5    
@p_TSI as float,    
@P_Coverage as varchar(255),    
@p_SchemeNo as varchar (10),    
@p_Description as varchar (255),
@p_SDate as smalldatetime,
@p_EDate as smalldatetime
as  
  
Declare @p_ClassNo int   
Select Top 1 @p_ClassNo=S.ClassNo   
from   
Scheme_Class S  
Inner Join Scheme_Coverage S1 on (S1.ClassNo=S.ClassNo and S1.Coverage=@p_Coverage)  
Where S.SchemeNo=@P_SchemeNo and @P_Description like S.Description   
Order by S.Priority Desc   
    
Select S1.DCode, S1.PCTTSI, S1.PCTCL, S1.FIXEDMIN, S1.FIXEDMAX, S1.Currency, S1.IUNIT, S1.Remarks, S1.Remarks_1, S1.TOR, S1.STRTSI, S1.PolicyYear
from Scheme_Coverage S3   
Inner Join Scheme_Deductible S1 on (S1.ClassNo=S3.ClassNo and S1.Coverage=S3.Coverage)  
Inner join RateCov on (RateCov.Code=S3.Code and RateCov.TOR=S1.TOR)  
Where S3.ClassNo=@p_ClassNo and S3.Coverage=@P_Coverage and @p_TSI Between S1.Lower and S1.Upper  
and S1.PolicyYear<=
(
	Case 
	When DateAdd(Year, DateDiff(Year, @p_SDate, @p_EDate), @p_SDate) < @p_Edate then 
		DateAdd(Year, DateDiff(Year, @p_SDate, @p_EDate), @p_SDate)+1
	Else
		DateAdd(Year, DateDiff(Year, @p_SDate, @p_EDate), @p_SDate)
	End
)

GO

Drop procedure QSchemeViewDeductible
GO
CREATE procedure QSchemeViewDeductible(@p_SchemeNo varchar(10),@P_Class_Desc as varchar(100))     
as    
select Top 50000 deductible.classno,class.description as class_desc, deductible.coverage, deductible.lower, deductible.upper, deductible.dcode, deductible.PolicyYear, deductible.remarks    
from scheme_deductible as deductible, scheme_class as class    
where  deductible.classno=class.classno and class.schemeno=@p_schemeno and (@P_Class_Desc='<All>' or class.description=@P_Class_Desc)  
    
  
GO

 
insert into PatchVersioning
select '1114 Update Script - 31 July 2024',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1114 Update Script - 31 July 2024'


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