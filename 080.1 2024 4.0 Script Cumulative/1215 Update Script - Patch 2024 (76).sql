IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'TreatyReallocation_Process') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
Drop Procedure TreatyReallocation_Process
end
GO
Create Procedure TreatyReallocation_Process(@P_dbUser as varchar(50), @P_ADate as smalldatetime, @P_PDate as smalldatetime, @P_TOC as varchar(10), @P_Branch as varchar(10))
as
Declare @P_ALLOWQRYALLBRANCH as Bit
Declare @P_ALLOWQRYALLTOC as Bit

Select 
@P_ALLOWQRYALLBRANCH=case When Type='SUPERVISOR' Then cast(1 as Bit) else dbo.GetPrivileges(SysUser.ID, 'ALLOWQRYALLBRANCH') end,
@P_ALLOWQRYALLTOC=case When Type='SUPERVISOR' Then cast(1 as Bit) else dbo.GetPrivileges(SysUser.ID, 'ALLOWQRYALLTOC') end
from sysuser 
where ID=@P_dbUser

Select A1.EMethod, A1.AUserID, A1.PolicyNo, A1.CertificateNo, A1.Branch, 
Case When A1.BackDatedF=1 and datediff(day, @P_ADate, Branch.BackdatedDate)>=0 Then 1 else 0 end as BackDatedF, 
A1.TOC, C1.OpenFlag, A1.RANO, A1.ANO, A1.LANO, A1.AStatus, A1.AType, 
Case When R1.NRDate<A1.EDate and R1.NRDate<=@P_PDate Then R1.NRDate Else A1.PDate end as PDate,
A1.RefNo, A1.RefDate, A1.ADate
from RArrHeader R1 
Inner Join Acceptance A1 on (A1.ANO=R1.ANO)
Inner Join Cover C1 on (C1.CNO=A1.CNO)
Inner Join TOC on (TOC.TOC=A1.TOC)
Inner Join Branch on (Branch.Branch=A1.Branch)
Left Join Acceptance A2 on (A2.AType<>'A' and A2.PANO<>-1 and A2.ANO=A2.LANO and A2.PANO=A1.LANO)
Left Join Acceptance A3 on (A3.AType<>'A' and A3.PANO<>-1 and A3.ANO<>A3.LANO and A3.PANO=A1.ANO)
OUTER APPLY (Select Top 1 C2.CNO from Claim C1 Inner Join CLLoss C2 on (C2.CNO=C1.CNO) Where C1.ANO=A1.ANO and C1.CType<>'C' and (C1.CSTATUS IN ('P','T','A') OR C1.PCSTATUS IN ('A')) and not exists (Select pCNO from Claim Where Claim.pCNO=C1.CNO and Claim.CStatus<>'R') and C2.CTLF=1) CTL
Where C1.CStatus<>'C' and A1.AType not in ('A','C') and A1.AStatus='I' and C1.ISType<>'T'
--Exclude Claim Total Loss
and coalesce(CTL.CNO,0)=0
and A2.ANO IS NULL and A3.ANO IS NULL
and 
(
-- Anniversary Policy Cession
(A1.AnnualTreatyF=1 and R1.NRDate<A1.EDate and R1.NRDate<=@P_PDate)
or 
--- Clean Cut
(R1.PPDate<R1.NRDate and R1.PPDate<=@P_PDate)
)
and A1.TOC Like @P_TOC+'%' and A1.Branch Like @P_Branch+'%'
and (@P_ALLOWQRYALLBRANCH=1 or Exists (Select TOP 1 S.ID from SysUserBranch S Where S.AllowedF=1 and S.Branch=A1.Branch and S.ID=@P_dbUser))
and (@P_ALLOWQRYALLTOC=1 or Exists (Select TOP 1 S.ID from SysUserTOC S Where S.TOC=A1.TOC and S.ID=@P_dbUser and S.Effective<=@P_PDate))
Order by A1.Branch, A1.LANO, A1.ANO
go



  insert into PatchVersioning
select '1215 Update Script - Patch 2024 (76)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1215 Update Script - Patch 2024 (76)'


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