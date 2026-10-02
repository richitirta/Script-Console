DROP Procedure QScheme_Verify_1
GO
CREATE Procedure QScheme_Verify_1(@p_PolicyNo as varchar(50), @p_LANO int=-1)        
as          
if @p_LANO=-1     
 Select top 1 A.CNO, A.LANO, A.STIME, A.ETIME, A.BRANCH, A.CT, A.REGNO, A.MSCODE, A.BizMapID, A.RenewableF, A.PWordingID, A.Ujroh, A.WeightedAvgUjrohF, A.SysUserID
 from Acceptance A where ANO = LANO and PolicyNo = @p_PolicyNo and AType in ('N','E') and AStatus='I'    
Else    
 Select top 1 A.CNO, A.LANO, A.STIME, A.ETIME, A.BRANCH, A.CT, A.REGNO, A.MSCODE, A.BizMapID, A.RenewableF, A.PWordingID, A.Ujroh, A.WeightedAvgUjrohF, A.SysUserID  
 from Acceptance A, Acceptance oA   
 Where oA.ANO=@P_LANO and oA.ANO=oA.LANO and A.OANO=oA.OANO and A.ANO=A.LANO and A.AType in ('N','E') and A.AStatus='I'    
  
  GO

  
insert into PatchVersioning
select '1113 Update Script - Patch 2024 (47)',GETDATE()
go
	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1113 Update Script - Patch 2024 (47)'


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