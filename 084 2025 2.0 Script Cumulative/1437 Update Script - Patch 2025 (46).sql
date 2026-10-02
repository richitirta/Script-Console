SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'List10') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE List10  END 
GO

CREATE PROCEDURE List10(@P_TOC as varchar(10), @P_Branch as varchar(10), @P_PolicyNO as varchar(50), @P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_AStatus as varchar(1), @P_RefNo as varchar(50)='', @P_RegNo as varchar(50)='')             
AS            
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.ANO AS ANO,             
 Cover.CNO,            
 Cover.CoverDate,            
 Cover.ExpDate,            
 Cast(Acceptance.AName as varchar(128)) as Insured,            
 Cover.UserID,            
 Cover.CStatus,            
 ISource.RType,          
 Acceptance.PolicyNo, 
 Acceptance.RefNo, 
 Acceptance.RegNo,             
 Profile.Name,             
 Acceptance.AStatus,             
 TOC.Description,             
 Acceptance.Branch, 
 ISource.Share, 
 ISource.Fee
FROM  Cover, ISource, Acceptance, Payor, Profile, TOC            
WHERE  Acceptance.ANO=Acceptance.LANO             
 And Cover.CNO=Acceptance.CNO             
 And ISource.CNO=Cover.CNO             
 And Payor.ANO=Acceptance.ANO             
 And Cover.ISType='T' and Cover.ProformaF=0  
 And Profile.ID=Payor.ID             
 And TOC.TOC=Acceptance.TOC            
 And TOC.TOC Like @P_TOC+'%'        
 And Acceptance.Branch Like @P_Branch+'%'        
 And Acceptance.PolicyNo Like @P_PolicyNo +'%'        
 And Acceptance.RegNo Like @P_RegNo +'%'        
 And Acceptance.RefNo Like @P_RefNo +'%'        
 And (Acceptance.AStatus=@P_AStatus or @P_AStatus='')    
 And (@P_SDate between Cover.CoverDate and Cover.ExpDate  or @P_EDate between Cover.CoverDate and Cover.ExpDate or Cover.CoverDate Between @P_SDate and @P_EDate or Cover.ExpDate Between @P_SDate and @P_EDate)      
 order by ACCEPTANCE.RegNo 
 

GO

insert into PatchVersioning
select '1437 Update Script - Patch 2025 (46)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrScript='1437 Update Script - Patch 2025 (46)'


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