BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'GetListActionLog') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE GetListActionLog END
GO
Create Procedure GetListActionLog(@Param2 varchar(10), @Param3 Int, @Param4 int, @Param6 varchar(50))
as 
	if @Param2 in ('UND', 'UND-MW', 'IT', 'MAR')
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), Acceptance A2, Cover C3, Acceptance A3, Cover C4, Acceptance A4, Acceptance A5, SysUser U1
		Where S.Param2 in ('UND','IT','MAR') and S.Param3=A2.ANO and A2.OANO=A3.OANO and ((A4.LANO=-1 and A3.LANO=-1) or (A4.LANO=A4.ANO and A3.LANO=A3.ANO) or (A4.LANO<>-1 and A3.LANO<>-1 and A3.CertificateNo=A4.CertificateNo)) and A3.CNO=C3.CNO and C3.CNO=C4.PCNO and C4.CNO=A4.CNO and A4.OANO=A5.OANO and A5.ANO=@Param3
		and U1.ID=S.UserID
		Union 
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), Acceptance A2, Cover C3, Acceptance A3, Cover C4, Acceptance A4, Acceptance A5, SysUser U1
		Where S.Param2 in ('UND','IT','MAR') and S.Param3=A2.ANO and A2.OANO=A3.OANO and ((A4.LANO=-1 and A3.LANO=-1) or (A4.LANO=A4.ANO and A3.LANO=A3.ANO) or (A4.LANO<>-1 and A3.LANO<>-1 and A3.CertificateNo=A4.CertificateNo)) and A3.CNO=C3.CNO and C3.PCNO=C4.CNO and C4.CNO=A4.CNO and A4.OANO=A5.OANO and A5.ANO=@Param3
		and U1.ID=S.UserID
		Union 
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), Acceptance A2, Acceptance A3, SysUser U1
		Where S.Param2 in ('UND','IT','MAR') and S.Param3=A2.ANO and A2.OANO=A3.OANO and A3.ANO=@Param3
		and U1.ID=S.UserID
		Union 
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), Service S1, Service S2, Acceptance A2, Acceptance A3, SysUser U1
		Where S.Param2 in ('SVC') and S.Param3=S1.SNO and S1.OSNO=S2.OSNO and S2.ANO=A2.ANO and A2.OANO=A3.OANO and A3.ANO=@Param3
		and U1.ID=S.UserID
		Order By S.ID Desc
	else if @Param2 in ('SVC')
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), Service S1, Service S2, SysUser U1
		Where S.Param2=@Param2 and S.Param3=S1.SNO and S1.OSNO=S2.OSNO and S2.SNO=@Param3
		and U1.ID=S.UserID
		Order By S.ID Desc
	else if @Param2 in ('CLM', 'CLM-MW')
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), Claim C1, Claim C2, SysUser U1
		Where S.Param2=@Param2 and S.Param4=C1.CNO and C1.OCNO=C2.OCNO and C2.CNO=@Param4
		and U1.ID=S.UserID
		Order By S.ID Desc
	else if @Param2 in ('CSCLM')
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), CSClaim C1, CSClaim C2, SysUser U1
		Where S.Param2=@Param2 and S.Param4=C1.CNO and C1.OCNO=C2.OCNO and C2.CNO=@Param4
		and U1.ID=S.UserID
		Order By S.ID Desc
	else if @Param2 in ('FA')
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), SysUser U1
		Where S.Param2=@Param2 and S.Param6=@Param6
		and U1.ID=S.UserID 
		Order By S.ID Desc
	else if @Param2 in ('RQ')
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), SysUser U1
		Where S.Param2=@Param2 and S.Param6=@Param6
		and U1.ID=S.UserID
		Order By S.ID Desc
	else if @Param2 in ('UND-OBJ')
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), SysUser U1
		Where S.Param2=@Param2 and S.Param6=@Param6
		and U1.ID=S.UserID 
		Order By S.ID Desc
	else if @Param2 in ('CLM-EXP')
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), SysUser U1
		Where S.Param2=@Param2 and S.Param6=@Param6
		and U1.ID=S.UserID 
		Order By S.ID Desc
	else if @Param2 in ('POLH')
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), Policy P1, Policy P2, SysUser U1
		Where S.Param2=@Param2 and S.Param3=P1.PNO and P1.OPNO=P2.OPNO and P2.PNO=@Param3
		and U1.ID=S.UserID
		Order By S.ID Desc
	else if @Param2 in ('CLMH')
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), ClaimH C1, ClaimH C2, SysUser U1
		Where S.Param2=@Param2 and S.Param4=C1.CNO and C1.OCNO=C2.OCNO and C2.CNO=@Param4
		and U1.ID=S.UserID
		Order By S.ID Desc
	else --else if @Param2 in ('GLH')
		Select S.ID, S.ActionCode, S.UserDate, S.UserTime, S.DueDate, Case When S.Status='P' Then S.LUserDate else Null End as CloseDate, S.UserID+'-'+U1.Name as SentBy, S.Param5+'-'+coalesce(SU.Name, ST.Description) as SentTo, S.Remarks, Case When S.Status='' Then 'Pending' else 'Done' end as Status, A1.Action, A1.ActionDate, A1.ActionTime, S.ApprovedFName, Case When S.ApprovedStatus='A' then 'Approved' When S.ApprovedStatus='C' Then 'Declined' else 'Waiting' end as ApprovedStatus, S.ApprovedRemarks
		from SysRequest S 
		Left Join SysUser SU on (SU.ID=S.Param5) 
		Left Join SysUserType ST on (ST.Type=S.Param5) 
		Left Join actionlog A1 on (A1.PID=S.ID), Pre_Claim_H C1, Pre_Claim_H C2, SysUser U1
		Where S.Param2=@Param2 and S.Param4=C1.PreRegID and C1.GuaranteeNo=C2.GuaranteeNo and C2.PreRegID=@Param4
		and U1.ID=S.UserID
		Order By S.ID Desc

GO

insert into PatchVersioning
select '1377 Update Script - Patch 2025 (31)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1377 Update Script - Patch 2025 (31)'


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

GO