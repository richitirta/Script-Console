DROP PROCEDURE QBRRule
GO
CREATE PROCEDURE QBRRule (@TOC varchar(10),@Branch varchar(10),@BizMapID varchar(10),@FACOPT varchar(10),@TOPRO varchar(10))           
as            
select top 1 * from BRRULE where TOC = @TOC and Branch=@Branch and BizMapID=@BizMapID and FACOPT=@FACOPT and TOPRO=@TOPRO;    

GO

DROP PROCEDURE QBRRuleMin
GO
CREATE PROCEDURE QBRRuleMin (@TOC varchar(10),@Branch varchar(10),@BizMapID varchar(10),@FACOPT varchar(10),@TOPRO varchar(10) )           
as                
select  * from BRRuleMin where TOC = @TOC  and Branch=@Branch and BizMapID=@BizMapID and FACOPT=@FACOPT and TOPRO=@TOPRO; 

GO



 insert into PatchVersioning
select '383 Update Script - (QBRRule,QBRRuleMin)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='383 Update Script - (QBRRule,QBRRuleMin)'


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