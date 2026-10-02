SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QSchemeViewDeductible') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QSchemeViewDeductible END
GO

CREATE procedure QSchemeViewDeductible(@p_SchemeNo varchar(10),@P_Class_Desc as varchar(100))       
as      
select Top 50000 CAST(0 As Bit) ProcessFlag, deductible.classno,class.description as class_desc, deductible.coverage, deductible.lower, deductible.upper, deductible.dcode, deductible.PolicyYear, deductible.remarks      
from scheme_deductible as deductible, scheme_class as class      
where  deductible.classno=class.classno and class.schemeno=@p_schemeno and (@P_Class_Desc='<All>' or class.description=@P_Class_Desc)    
      
    
GO
insert into PatchVersioning
select '1406 CARE - SETUP - PROCEDURE QSchemeViewDeductible',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1406 CARE - SETUP - PROCEDURE QSchemeViewDeductible'


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