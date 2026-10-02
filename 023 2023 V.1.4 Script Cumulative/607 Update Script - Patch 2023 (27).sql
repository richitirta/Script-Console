DROP function fn_GL_Budget
GO
CREATE function fn_GL_Budget(@P_Branch as varchar(10), @P_Year int)            
RETURNS TABLE            
AS RETURN            
(            
Select 
@P_Branch as Branch, 
@P_Year as Year,
Account.Account, Account.Description,         
'' as TOC,  
'' as TOCDesc,  
coalesce(Month_1+CF_Month_1,0) as Month_1,         
coalesce(actual_1,0) as Actual_1,         
coalesce(PMonth_1,0) as PMonth_1,         
coalesce(Month_2+CF_Month_2,0) as Month_2,         
coalesce(actual_2,0) as Actual_2,         
coalesce(PMonth_2,0) as PMonth_2,         
coalesce(Month_3+CF_Month_3,0) as Month_3,         
coalesce(actual_3,0) as Actual_3,         
coalesce(PMonth_3,0) as PMonth_3,         
coalesce(Month_4+CF_Month_4,0) as Month_4,         
coalesce(actual_4,0) as Actual_4,         
coalesce(PMonth_4,0) as PMonth_4,         
coalesce(Month_5+CF_Month_5,0) as Month_5,         
coalesce(actual_5,0) as Actual_5,         
coalesce(PMonth_5,0) as PMonth_5,         
coalesce(Month_6+CF_Month_6,0) as Month_6,         
coalesce(actual_6,0) as Actual_6,         
coalesce(PMonth_6,0) as PMonth_6,         
coalesce(Month_7+CF_Month_7,0) as Month_7,         
coalesce(Actual_7,0) as Actual_7,         
coalesce(PMonth_7,0) as PMonth_7,         
coalesce(Month_8+CF_Month_8,0) as Month_8,         
coalesce(Actual_8,0) as Actual_8,         
coalesce(PMonth_8,0) as PMonth_8,         
coalesce(Month_9+CF_Month_9,0) as Month_9,         
coalesce(Actual_9,0) as Actual_9,         
coalesce(PMonth_9,0) as PMonth_9,         
coalesce(Month_10+CF_Month_10,0) as Month_10,         
coalesce(Actual_10,0) as Actual_10,         
coalesce(PMonth_10,0) as PMonth_10,         
coalesce(Month_11+CF_Month_11,0) as Month_11,         
coalesce(Actual_11,0) as Actual_11,         
coalesce(PMonth_11,0) as PMonth_11,         
coalesce(Month_12+CF_Month_12,0) as Month_12,         
coalesce(Actual_12,0) as Actual_12,      
coalesce(PMonth_12,0) as PMonth_12,         
coalesce(GL.Starting,0) as Starting,    
coalesce(Month_1+Month_2+Month_3+Month_4+Month_5+Month_6+Month_7+Month_8+Month_9+Month_10+Month_11+Month_12+CF_Month_1+CF_Month_2+CF_Month_3+CF_Month_4+CF_Month_5+CF_Month_6+CF_Month_7+CF_Month_8+CF_Month_9+CF_Month_10+CF_Month_11+CF_Month_12,0) as Total,      
coalesce(GL.Starting,0) as Starting_Actual,    
coalesce(Actual_1+Actual_2+Actual_3+Actual_4+Actual_5+Actual_6+Actual_7+Actual_8+Actual_9+Actual_10+Actual_11+Actual_12,0) as Total_Actual,    
coalesce(pGL.Starting,0) as Starting_Prognosis,    
coalesce(PMonth_1+PMonth_2+PMonth_3+PMonth_4+PMonth_5+PMonth_6+PMonth_7+PMonth_8+PMonth_9+PMonth_10+PMonth_11+PMonth_12,0) as Total_Prognosis      
From Account         
Left Join Budget on (Budget.Account=Account.Account and Budget.Branch=@P_Branch and Budget.Year=@P_Year)          
Left Join GL on (GL.Account=Account.Account and GL.Branch=@P_Branch and GL.Year=@P_Year and GL.Month=1)        
Left Join GL pGL on (pGL.Account=Account.Account and pGL.Branch=@P_Branch and pGL.Year=@P_Year-1 and pGL.Month=1)        
  
union All  
  
Select 
@P_Branch as Branch, 
@P_Year as Year,
Account.Account, Account.Description,         
Budget.TOC,   
TOC.Description as TOCDesc,  
Month_1+CF_Month_1 as Month_1,         
actual_1 as Actual_1,         
PMonth_1 as PMonth_1,         
Month_2+CF_Month_2 as Month_2,         
actual_2 as Actual_2,         
PMonth_2 as PMonth_2,         
Month_3+CF_Month_3 as Month_3,         
actual_3 as Actual_3,         
PMonth_3 as PMonth_3,         
Month_4+CF_Month_4 as Month_4,         
actual_4 as Actual_4,         
PMonth_4 as PMonth_4,         
Month_5+CF_Month_5 as Month_5,         
actual_5 as Actual_5,         
PMonth_5 as PMonth_5,         
Month_6+CF_Month_6 as Month_6,         
actual_6 as Actual_6,         
PMonth_6 as PMonth_6,         
Month_7+CF_Month_7 as Month_7,         
Actual_7 as Actual_7,         
PMonth_7 as PMonth_7,         
Month_8+CF_Month_8 as Month_8,         
Actual_8 as Actual_8,         
PMonth_8 as PMonth_8,         
Month_9+CF_Month_9 as Month_9,         
Actual_9 as Actual_9,         
PMonth_9 as PMonth_9,         
Month_10+CF_Month_10 as Month_10,         
Actual_10 as Actual_10,         
PMonth_10 as PMonth_10,         
Month_11+CF_Month_11 as Month_11,         
Actual_11 as Actual_11,         
PMonth_11 as PMonth_11,         
Month_12+CF_Month_12 as Month_12,         
Actual_12 as Actual_12,      
PMonth_12 as PMonth_12,         
0  as Starting,    
Month_1+Month_2+Month_3+Month_4+Month_5+Month_6+Month_7+Month_8+Month_9+Month_10+Month_11+Month_12+CF_Month_1+CF_Month_2+CF_Month_3+CF_Month_4+CF_Month_5+CF_Month_6+CF_Month_7+CF_Month_8+CF_Month_9+CF_Month_10+CF_Month_11+CF_Month_12 as Total,      
0 as Starting_Actual,    
Actual_1+Actual_2+Actual_3+Actual_4+Actual_5+Actual_6+Actual_7+Actual_8+Actual_9+Actual_10+Actual_11+Actual_12 as Total_Actual,    
0 as Starting_Prognosis,    
PMonth_1+PMonth_2+PMonth_3+PMonth_4+PMonth_5+PMonth_6+PMonth_7+PMonth_8+PMonth_9+PMonth_10+PMonth_11+PMonth_12 as Total_Prognosis      
From Account         
Inner Join Budget_TOC  Budget on (Budget.Account=Account.Account and Budget.Branch=@P_Branch and Budget.Year=@P_Year)          
Inner join TOC on (TOC.TOC=Budget.TOC)  
)           


GO

DROP function fn_CT_Budget
GO
CREATE function fn_CT_Budget(@P_Branch as varchar(10), @P_Year int,@P_CT as varchar(10))        
RETURNS TABLE        
AS RETURN        
(        
Select 
@P_Branch as Branch, 
@P_Year as Year,
Account.Account, Account.Description,     
'' as TOC,  
'' as TOCDesc,     
Coalesce(Month_1,0) as Month_1,     
Coalesce(actual_1,0) as Actual_1,   
Coalesce(PMonth_1,0) as PMonth_1,       
Coalesce(Month_2,0) as Month_2,     
Coalesce(actual_2,0) as Actual_2,     
Coalesce(PMonth_2,0) as PMonth_2,     
Coalesce(Month_3,0) as Month_3,     
Coalesce(actual_3,0) as Actual_3,     
Coalesce(PMonth_3,0) as PMonth_3,     
Coalesce(Month_4,0) as Month_4,     
Coalesce(actual_4,0) as Actual_4,     
Coalesce(PMonth_4,0) as PMonth_4,     
Coalesce(Month_5,0) as Month_5,     
Coalesce(actual_5,0) as Actual_5,     
Coalesce(PMonth_5,0) as PMonth_5,     
Coalesce(Month_6,0) as Month_6,     
Coalesce(actual_6,0) as Actual_6,     
Coalesce(PMonth_6,0) as PMonth_6,     
Coalesce(Month_7,0) as Month_7,     
Coalesce(Actual_7,0) as Actual_7,     
Coalesce(PMonth_7,0) as PMonth_7,     
Coalesce(Month_8,0) as Month_8,     
Coalesce(Actual_8,0) as Actual_8,     
Coalesce(PMonth_8,0) as PMonth_8,     
Coalesce(Month_9,0) as Month_9,     
Coalesce(Actual_9,0) as Actual_9,     
Coalesce(PMonth_9,0) as PMonth_9,     
Coalesce(Month_10,0) as Month_10,     
Coalesce(Actual_10,0) as Actual_10,     
Coalesce(PMonth_10,0) as PMonth_10,     
Coalesce(Month_11,0) as Month_11,     
Coalesce(Actual_11,0) as Actual_11,     
Coalesce(PMonth_11,0) as PMonth_11,     
Coalesce(Month_12,0) as Month_12,     
Coalesce(Actual_12,0) as Actual_12,    
Coalesce(PMonth_12,0) as PMonth_12,  
Coalesce(0,0) as Starting, 
Coalesce(Month_1+Month_2+Month_3+Month_4+Month_5+Month_6+Month_7+Month_8+Month_9+Month_10+Month_11+Month_12,0) as Total,     
Coalesce(0,0) as Starting_Actual,
Coalesce(Actual_1+Actual_2+Actual_3+Actual_4+Actual_5+Actual_6+Actual_7+Actual_8+Actual_9+Actual_10+Actual_11+Actual_12,0) as Total_Actual,  
Coalesce(0,0) as Starting_Prognosis,
Coalesce(PMonth_1+PMonth_2+PMonth_3+PMonth_4+PMonth_5+PMonth_6+PMonth_7+PMonth_8+PMonth_9+PMonth_10+PMonth_11+PMonth_12,0) as Total_Prognosis  
From Account     
Left Join CTBudget Budget on (Budget.Account=Account.Account and Budget.Branch=@P_Branch and Budget.Year=@P_Year and Budget.CT=@P_CT)      
)        
    
go




 insert into PatchVersioning	
select '607 Update Script - Patch 2023 (27)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='607 Update Script - Patch 2023 (27)'


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
