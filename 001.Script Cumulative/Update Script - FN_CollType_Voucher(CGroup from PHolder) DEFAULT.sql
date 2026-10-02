
insert into PatchVersioning
select 'Update Script - FN_CollType_Voucher(CGroup from PHolder) DEFAULT',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='Update Script - FN_CollType_Voucher(CGroup from PHolder) DEFAULT'


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
			DROP FUNCTION FN_CollType_Voucher
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End


GO
CREATE FUNCTION FN_CollType_Voucher(@P_CollType as varchar(10))            
RETURNS TABLE            
as RETURN(  
Select A.Voucher 
from Admlink A 
Inner Join Profile P on (P.ID=A.ID)
Where Exists
(
	Select Top 1 C.CollType
	From CollType C
	Left Join CollType_Segment C1 on (C1.CollType=C.CollType)
	Left Join CollType_TOC C2 on (C2.CollType=C.CollType)
	Left Join CollType_CGroup C3 on (C3.CollType=C.CollType)
	Left Join AccAss on (AccAss.AdmNo=A.AdmNO)
	Left JOin Acceptance on (Acceptance.ANO=AccAss.ANO)
	Left Join Cover on (Cover.CNO=Acceptance.CNO)
	Left Join Profile on (Profile.ID=Cover.PHolder)
	Where C.CollType=@P_CollType
	and (coalesce(C1.Segment, C.Segment)=A.Segment or coalesce(C1.Segment, C.Segment)='')
	and (coalesce(C2.TOC, C.TOC)=A.Code or coalesce(C2.TOC, C.TOC)='')
	and (coalesce(C3.Cgroup, C.CGroup)=coalesce(Profile.Cgroup, P.CGroup) or coalesce(C3.Cgroup, C.CGroup)='')
)
)
