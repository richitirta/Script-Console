

Update I1 Set AccNo=I3.AccNo
from IFRS_Movement I1 
Inner join IFRS_Calculation I2 on (I2.GroupID=I1.GroupID)
Inner Join AccLink I3 on (I3.Branch=I2.Branch and I3.CODE=I2.TOC and I1.ProcessDate=I3.PDate and I3.Type=(Case When I1.GroupType='I' and I2.Method='B' then 'IFIB' When I1.GroupType='R' and I2.Method='B' then 'IFRB' When I1.GroupType='I' and I2.Method='P' then 'IFIP' else 'IFRP' end))
go

Update I1 Set AccNo=-1 from IFRS_Movement I1 Where AccNo is null
go



 insert into PatchVersioning	
select '555.1 Update Script - Inisialisasi IFRS Patch #6',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='555.1 Update Script - Inisialisasi IFRS Patch #6'


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

