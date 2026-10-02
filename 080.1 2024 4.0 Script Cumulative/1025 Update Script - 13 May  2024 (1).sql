
DROP Procedure GetReinsuranceRate
GO
CREATE Procedure GetReinsuranceRate(@P_TOC as varchar(10), @P_Currency as varchar(10), @P_SDate as smalldatetime, @P_PHolder as varchar(10)='', @P_RDate as smalldatetime=Null)     
as     
if @P_RDate is null
	Select @P_RDate=@P_SDate

SELECT coalesce(ReRate.CCYTo,'') as CCYTo,  
Case   
When coalesce(ReRate.Rate,0)<>0 Then ReRate.Rate   
Else   
 Case  
 When coalesce(ReRate.CCYTO,'')='' or coalesce(ReRate.CCYTO,'')=@P_Currency Then   
  Case When @P_Currency<>SysTab.Currency Then (Select Rate from fn_exchange(@P_SDate) Currency Where Currency=@P_Currency) else 1 end  
 Else  
  Case When @P_Currency<>SysTab.Currency Then (Select Rate from fn_exchange(@P_SDate) Currency Where Currency=@P_Currency) else 1 end  
  /  
  Case When @P_Currency<>ReRate.CCYTO Then (Select Rate from fn_exchange(@P_SDate) Currency Where Currency=ReRate.CCYTO) else 1 end  
 End  
end as Rate,  
Case   
When coalesce(ReRate.CRate,0)<>0 Then ReRate.CRate   
When coalesce(ReRate.Rate,0)<>0 Then ReRate.Rate   
Else   
 Case  
 When coalesce(ReRate.CCYTO,'')='' or coalesce(ReRate.CCYTO,'')=@P_Currency Then   
  Case When @P_Currency<>SysTab.Currency Then (Select Rate from fn_exchange(@P_SDate) Currency Where Currency=@P_Currency) else 1 end  
 Else  
  Case When @P_Currency<>SysTab.Currency Then (Select Rate from fn_exchange(@P_SDate) Currency Where Currency=@P_Currency) else 1 end  
  /  
  Case When @P_Currency<>ReRate.CCYTO Then (Select Rate from fn_exchange(@P_SDate) Currency Where Currency=ReRate.CCYTO) else 1 end  
 End  
end as CRate  
From SysTab  
Left Join ReRate on   
(  
ReRate.TOC=@P_TOC  
and ReRate.Currency=@P_Currency  
and ReRate.RYear=coalesce((     
 Select Top 1 R1.RYear     
 from Reinsurance R1, ReClass R2     
 Left Join RePolicy R3 on (R3.RNO=R2.RNO and R3.ID=@P_PHolder)     
 Where (R1.Category<>'P' or Coalesce(R3.ID,'')<>'') and R1.RType='Q' and R2.RNO=R1.RNO and R2.TOC=@P_TOC and @P_RDate Between R1.SDate and R1.EDate     
 Order By coalesce(R3.ID,'') Desc, (Case When R2.PriorityF=1 Then R2.PriorityF else R1.PriorityF end) Desc),Year(@P_RDate))   
)  
  

  go

  

insert into PatchVersioning
select '1025 Update Script - 13 May  2024 (1)',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1025 Update Script - 13 May  2024 (1)'


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