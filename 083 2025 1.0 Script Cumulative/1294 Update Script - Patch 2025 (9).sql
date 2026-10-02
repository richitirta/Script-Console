DROP PROCEDURE List10
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
 Acceptance.Branch            
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

 DROP Procedure QInwardTreaty_Data
GO
CREATE Procedure QInwardTreaty_Data(@P_ANO integer)                
as                
Select A1.CNO, A1.ANO, A1.PolicyNo, A1.RegNo, A1.Branch, A1.CT, A1.NCDate, 
C.Segment, C.CoverDate, C.Insured, C.ExpDate, A1.TOC, C.RefNo, C.RefDate, C.MO, R.Code, I.RType, I.CedingID, I.ID, I.Share, I.Fee as RIComm, I.UJROHCEDANT, I.UJROHREINS,        
A1.CDate,        
A1.UserID,         
A1.LDate,        
A1.LUserID,        
A1.AUserID,        
A1.AUserDate,    
A2.FLDID1, A2.VALUEID1, A2.VALUEDESC1, 0 as FLDSEARCH1,                    
A2.FLDID2, A2.VALUEID2, A2.VALUEDESC2, 0 as FLDSEARCH2,                    
A2.FLDID3, A2.VALUEID3, A2.VALUEDESC3, 0 as FLDSEARCH3,                    
A2.FLDID4, A2.VALUEID4, A2.VALUEDESC4, 0 as FLDSEARCH4,                    
A2.FLDID5, A2.VALUEID5, A2.VALUEDESC5, 0 as FLDSEARCH5,                    
A2.FLDID6, A2.VALUEID6, A2.VALUEDESC6, 0 as FLDSEARCH6,                    
A2.FLDID7, A2.VALUEID7, A2.VALUEDESC7, 0 as FLDSEARCH7,                    
A2.FLDID8, A2.VALUEID8, A2.VALUEDESC8, 0 as FLDSEARCH8,                    
A2.FLDID9, A2.VALUEID9, A2.VALUEDESC9, 0 as FLDSEARCH9,                    
A2.FLDID10, A2.VALUEID10, A2.VALUEDESC10, 0 as FLDSEARCH10,                    
A2.FLDID11, A2.VALUEID11, A2.VALUEDESC11, 0 as FLDSEARCH11,                    
A2.FLDID12, A2.VALUEID12, A2.VALUEDESC12, 0 as FLDSEARCH12,                    
A2.FLDID13, A2.VALUEID13, A2.VALUEDESC13, 0 as FLDSEARCH13,                    
A2.FLDID14, A2.VALUEID14, A2.VALUEDESC14, 0 as FLDSEARCH14,                    
A2.FLDID15, A2.VALUEID15, A2.VALUEDESC15, 0 as FLDSEARCH15,    
A3.ID as BSID, A3.Fee as BSFee, A4.ID as OtherID, A4.Fee as OtherFee, A1.MSCode  
from Cover C        
Inner Join Acceptance A1 on (C.CNO=A1.CNO)        
Left Join AINFO A2 On (A2.ANO=A1.ANO)     
Left join ISource I on (I.CNO=C.CNO)        
Left Join RCover R On (R.ANO=A1.ANO)        
Left Join AccBS A3 on (A3.ANO=A1.ANO and A3.BSType='B')        
Left Join AccBS A4 on (A4.ANO=A1.ANO and A4.BSType='O')        
Where A1.ANO=@P_ANO 


GO


  insert into PatchVersioning
select '1294 Update Script - Patch 2025 (9)',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1294 Update Script - Patch 2025 (9)'


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