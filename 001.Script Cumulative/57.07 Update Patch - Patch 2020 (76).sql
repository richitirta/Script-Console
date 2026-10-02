
insert into PatchVersioning
select '57.07 Update Patch - Patch 2020 (76)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='57.06 Update Patch - Patch 2020 (75)'
Select @CurrSCript='57.07 Update Patch - Patch 2020 (76)'


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
			DROP PROCEDURE QRenewalRight
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End


GO
CREATE PROCEDURE QRenewalRight(@P_ANO as int) 
AS 
Select Top 1 Renewal.RCode, Renewal.TOC, Acceptance.TOPRO as PrevTOPRO, RCover.Code as PrevCode, 
Coalesce(R2.TOPRO, R1.TOPRO) as TOPRO, 
Coalesce(R2.Code, R1.Code) as Code, 
Coalesce(R2.Discount, R1.Discount) as Discount, 
Coalesce(R2.RDiscount, R1.RDiscount) as RDiscount, 
Coalesce(R2.DLoading, R1.DLoading) as DLoading, 
Coalesce(R2.Deductible, R1.Deductible) as Deductible, 
Coalesce(R2.Loyalty, R1.Loyalty) as Loyalty, 
Coalesce(R2.Loyalty, R1.Rate) as Rate, 
Coalesce(R2.Unit, R1.Unit) as Unit, 
Interest.Currency, Interest.TSI, Interest.ATSI, 
Renewal.Loading 
from Acceptance 
Inner join Cover on (Cover.CNO=Acceptance.CNO) 
Inner Join Renewal on (Acceptance.ANO=Renewal.ANO and ((Renewal.RenewalF=1 and Renewal.Action=0) or Renewal.Action=2)) 
Inner Join RCover on (RCover.ANO=Acceptance.ANO and RCover.SDate=Acceptance.SDate and RCover.Category='M') 
Inner Join RenewalRight R1 on (R1.TOC=Renewal.TOC and R1.RCode=Renewal.RCode) 
Left Join RenewalRightCode R2 on (R1.TOC=R2.TOC and R1.RCode=R2.RCode and (R2.PrevTOPRO='<Any>' or R2.PrevTOPRO='' or R2.PrevTOPRO=Acceptance.TOPRO) and (R2.PrevCode='<Any>' or R2.PrevCode='' or R2.PrevCode=RCover.Code)) 
Left Join fn_sumInsured(@P_ANO) Interest on (Interest.ANO=@P_ANO) 
Where Acceptance.ANO=@P_ANO
 
