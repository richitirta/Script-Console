DROP Procedure QUndo_Claim_To_Adm
GO
CREATE Procedure QUndo_Claim_To_Adm(@P_CNO as int)                      
as                      
Select A1.ADMNO,     
sum(Case When A1.Code='P' then A1.Amount else 0 end) as Amount_1,                      
sum(Case When A1.Code='A' then A1.Amount else 0 end) as Amount_6,                      
sum(Case When A1.Code='E' then A1.Amount else 0 end) as Amount_7,                      
sum(Case When A1.Code='S' then A1.Amount else 0 end) as Amount_8,                      
sum(Case When A1.Code='L' then A1.Amount else 0 end) as Amount_9,                      
sum(Case When A1.Code='R' then A1.Amount else 0 end) as Amount_10,                      
sum(Case When A1.Code='V' then A1.Amount else 0 end) as Amount_13,   
sum(Case When A1.Code='T' then A1.Amount else 0 end) as Amount_14,                      
sum(Case When A1.Code='F' then A1.Amount else 0 end) as Amount_15,                      
sum(Case When A1.Code='D' then A1.Amount else 0 end) as Amount_16,                      
sum(Case When A1.Code='I' then A1.Amount else 0 end) as Amount_17,
Max(A2.Amount_18) as Amount_18		-- Tax Adjustment from Progresif taax
from ClaAss A1                     
Inner Join Admlink A2 on (A2.ADMNO=A1.AdmNo)                      
Where A1.CNO=@P_CNO
Group By A1.AdmNo    

go


 insert into PatchVersioning
select '497 Update Script - Patch 2022 (90)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='497 Update Script - Patch 2022 (90)'


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



