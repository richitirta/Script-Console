DROP Function Premium_Discount
GO
CREATE Function Premium_Discount(@P_ANO as int,@P_Code as varchar(10),@P_Period int=0) 
RETURNS Float 
AS 
BEGIN 
Declare @GDiscount Float 
Declare @PDiscount Float 
Declare @Discount Float 
Declare @ADiscount Float 
 
Select @GDiscount=(100-PDiscount)/100*GDiscount, @PDiscount=PDiscount, @Discount=Discount from Payor_Discount(@P_ANO,@P_Code,@P_Period) 
if @Discount is null 
	Select @Discount=0 

if @GDiscount is null
	Select @GDiscount=0

--Agent Discount is Not Longer Used 
--Select @ADiscount=dbo.agent_discount(@P_ANO,@P_Code,@P_Period) 
Select @ADiscount=0 

-- Exclude Group Discount 
return (@Discount+@ADiscount-@GDiscount) 
End 
go


 insert into PatchVersioning
select '845 Update Script - Patch 2023 (114)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='845 Update Script - Patch 2023 (114)'


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



