DROP PROCEDURE QCLACC_6 
GO
CREATE PROCEDURE QCLACC_6 (@P_ANO as int, @P_CTLF as bit=1) 
AS 
SELECT C1.ClaimNo, C1.RegDate, C1.LossDate, cast(Max(cast(C2.CTLF as Integer)) as Bit) as CTLF
FROM Acceptance A2
Inner Join Acceptance A1 on (A1.OANO=A2.OANO)
Inner Join Claim C1 on (C1.ANO=A1.ANO)
Inner Join CLLoss C2 on (C2.CNO=C1.CNO)
Inner Join ICover I on (I.INO=C2.INO)
WHERE A2.ANO=@P_ANO and C1.CType<>'C' and (C1.CSTATUS IN ('P','T','A') OR C1.PCSTATUS IN ('A')) 
and not exists (Select pCNO from Claim Where Claim.pCNO=C1.CNO and Claim.CStatus<>'R')
and (@P_CTLF=0 or (C2.CTLF=@P_CTLF and I.Category='M')) and C1.TBAF_1=0 and C1.TBAF_2=0 
Group by C1.ClaimNo, C1.RegDate, C1.LossDate
Order by C1.LossDate 
go


  insert into PatchVersioning
select '1334 Update Script - Patch 2025 (21)',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1334 Update Script - Patch 2025 (21)'


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

  