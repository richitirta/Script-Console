/****** Object:  UserDefinedFunction [dbo].[ListSRR_Det]    Script Date: 4/24/2024 4:26:06 PM ******/
DROP FUNCTION [dbo].[ListSRR_Det]
GO

/****** Object:  UserDefinedFunction [dbo].[ListSRR_Det]    Script Date: 4/24/2024 4:26:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  function [dbo].[ListSRR_Det](@P_LANO AS INTEGER,@P_ANO AS INTEGER)    
returns table    
AS return    
(    
SELECT  DISTINCT    
 Cast(0 as bit) as ProcessFlag,     
 Cover.COVERNO,     
 Cast(Acceptance.AName as varchar(128)) as AName,     
 Acceptance.CertificateNo,
 Acceptance.RefNo,
 Acceptance.ESeqNo,
 Cover.CNO,     
 Cover.CStatus,     
 Cover.VSeqNo,     
 Acceptance.LANO,     
 Acceptance.ANO,     
 Acceptance.REGNO,     
 Acceptance.ADATE,     
 Acceptance.USERID,     
 SysTab.Currency,     
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,     
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE,     
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,     
 Acceptance.ASTATUS,     
 Acceptance.ATYPE,     
 Acceptance.SDate,     
 Acceptance.EDate,     
 Year(RArrheader.Rdate) AS RYear,
 Acceptance.ValueID,
 dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
 Acceptance.BatchNo
FROM     
 Acceptance,     
 Cover,     
 RArrHeader,     
 SysTab,          
 Profile    
WHERE     
 Cover.CNO=Acceptance.CNO     
 And RArrHeader.ANO=Acceptance.ANO     
      
 And Acceptance.ANO<>Acceptance.LANO     
 And Acceptance.LANO=@P_LANO    
 And Acceptance.ANO=@P_ANO  
)  

GO





insert into PatchVersioning
select '1007 Update Script -  ListSRR_Det',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1007 Update Script -  ListSRR_Det'


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