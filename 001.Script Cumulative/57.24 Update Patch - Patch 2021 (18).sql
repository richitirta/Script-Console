if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_CollType_Voucher') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN 
DROP FUNCTION FN_CollType_Voucher 
END

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
	Left Join Payor mPayor on (Acceptance.LANO<>-1 and mPayor.ANO=Acceptance.LANO)
	Left Join Payor on (Acceptance.LANO=-1 and Payor.ANO=Acceptance.ANO)
	Left Join APayor on (Acceptance.LANO<>-1 and APayor.ANO=Acceptance.ANO)
	Left Join Profile on (Profile.ID=coalesce(APayor.ID, coalesce(mPayor.ID, Payor.ID)))
	Where C.CollType=@P_CollType
	and (coalesce(C1.Segment, C.Segment)=A.Segment or coalesce(C1.Segment, C.Segment)='')
	and (coalesce(C2.TOC, C.TOC)=A.Code or coalesce(C2.TOC, C.TOC)='')
	and (coalesce(C3.Cgroup, C.CGroup)=coalesce(Profile.Cgroup, P.CGroup) or coalesce(C3.Cgroup, C.CGroup)='')
)
)

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_CollType_Voucher_By_Payor') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN 
DROP FUNCTION FN_CollType_Voucher_By_Payor
END
GO
CREATE FUNCTION FN_CollType_Voucher_By_Payor(@P_CollType as varchar(10))            
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
	Left Join Payor mPayor on (Acceptance.LANO<>-1 and mPayor.ANO=Acceptance.LANO)
	Left Join Payor on (Acceptance.LANO=-1 and Payor.ANO=Acceptance.ANO)
	Left Join APayor on (Acceptance.LANO<>-1 and APayor.ANO=Acceptance.ANO)
	Left Join Profile on (Profile.ID=coalesce(APayor.ID, coalesce(mPayor.ID, Payor.ID)))
	Where C.CollType=@P_CollType
	and (coalesce(C1.Segment, C.Segment)=A.Segment or coalesce(C1.Segment, C.Segment)='')
	and (coalesce(C2.TOC, C.TOC)=A.Code or coalesce(C2.TOC, C.TOC)='')
	and (coalesce(C3.Cgroup, C.CGroup)=coalesce(Profile.Cgroup, P.CGroup) or coalesce(C3.Cgroup, C.CGroup)='')
)
)


GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_CollType_Voucher_By_PHolder') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN 
DROP FUNCTION FN_CollType_Voucher_By_PHolder
END
GO
CREATE FUNCTION FN_CollType_Voucher_By_PHolder(@P_CollType as varchar(10))            
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

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_CollType_Voucher_By_Source') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN 
DROP FUNCTION FN_CollType_Voucher_By_Source
END
GO
CREATE FUNCTION FN_CollType_Voucher_By_Source(@P_CollType as varchar(10))            
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
	Left Join Profile on (Profile.ID=A.Source)
	Where C.CollType=@P_CollType
	and (coalesce(C1.Segment, C.Segment)=A.Segment or coalesce(C1.Segment, C.Segment)='')
	and (coalesce(C2.TOC, C.TOC)=A.Code or coalesce(C2.TOC, C.TOC)='')
	and (coalesce(C3.Cgroup, C.CGroup)=coalesce(Profile.Cgroup, P.CGroup) or coalesce(C3.Cgroup, C.CGroup)='')
)
)


GO


insert into PatchVersioning
select '57.24 Update Patch - Patch 2021 (18)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='57.24 Update Patch - Patch 2021 (18)'


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
			DROP FUNCTION DISPLAY_GROSS_FACULTATIVE_CALCULATION
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End

GO