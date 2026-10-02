
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_UserBusinessSource') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION FN_UserBusinessSource 
END
GO
CREATE FUNCTION FN_UserBusinessSource (@P_UserID as varchar(10), @P_PDate as smalldatetime)      
RETURNS TABLE      
as RETURN(      
Select P.ID, P.Name, P.Address_1, P.Address_2, P.Remark, P.Comm, P.TaxType, P.VatF, P.TaxF, P.NetCommF, 
Case When P.RestrictedF=1 or not (coalesce(P.LicenseExpiry,cast(convert(varchar(10), @P_PDate,1) as smalldatetime))>=cast(convert(varchar(10), @P_PDate,1) as smalldatetime)) Then cast(1 as Bit) else cast(0 as Bit) end as RestrictedF,
Case 
When P.RestrictedF=1 Then 'Profile is Restricted'
When Not (coalesce(P.LicenseExpiry,cast(convert(varchar(10), @P_PDate,1) as smalldatetime))>=cast(convert(varchar(10), @P_PDate,1) as smalldatetime)) Then 'License has expired'
else '' 
end as RestrictedRemarks,
P.LOB, 
S1.ID as SID, S1.Name as SName, 
P.DumpF,P.Phone_1,P.Phone_2,
AIF.AgentType 
From Profile P 
Left Join AIF on (AIF.ID=P.ID)
Left Join SysUserAssignment S on (S.AssType='SOURCE' and S.PID=P.ID and S.ID=@P_UserID)
Left join SysUser S1 on (S1.ID=S.ID and S1.AllowedF=1)
Where coalesce(P.DumpF,0)=0 and P.IntermediaryF=1
--and (coalesce(P.LicenseExpiry,cast(convert(varchar(10), @P_PDate,1) as smalldatetime))>=cast(convert(varchar(10), @P_PDate,1) as smalldatetime))
and
(
not exists(Select Top 1 PID from SysUserAssignment S Where S.AssType='SOURCE' and S.ID=@P_UserID)
or coalesce(S1.ID,'')=@P_UserID
)
)    
GO


insert into PatchVersioning
select '55.15 Update Script - Patch 2020 (15)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='55.14 Update Script - Patch 2020 (14)'
Select @CurrSCript='55.15 Update Script - Patch 2020 (15)'


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





