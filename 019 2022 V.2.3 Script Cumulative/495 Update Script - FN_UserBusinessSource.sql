DROP FUNCTION FN_UserBusinessSource 
GO
CREATE FUNCTION FN_UserBusinessSource (@P_UserID as varchar(10), @P_PDate as smalldatetime)      
RETURNS TABLE      
as RETURN(      
Select P.ID, P.Name, P.Address_1, P.Address_2, P.Remark, P.Comm, P.TaxType, P.VatF, P.TaxF, P.NetCommF, 

Case 
When P.RestrictedF=1 Then cast(1 as Bit)
When Not (
       (coalesce(P.LicenseNo,'')='' or (coalesce(P.LicenseNo,'')<>'' and coalesce(P.LicenseExpiry,cast('01/01/1900' as smalldatetime))>=cast(convert(varchar(10), @P_PDate,1) as smalldatetime)))
       or
       (coalesce(Up.ID, P.ID)<>P.ID)
)
Then cast(1 as Bit)
When Not (
       (coalesce(AIF.ID,'')='' or (coalesce(AIF.ID,'')<>'' and coalesce(AIF.EDate,cast('01/01/1900' as smalldatetime))>=cast(convert(varchar(10), @P_PDate,1) as smalldatetime)))
)
Then cast(1 as Bit)
else cast(0 as Bit)
end as RestrictedF,

Case 
When P.RestrictedF=1 Then 'Profile is Restricted'
When Not (
       (coalesce(P.LicenseNo,'')='' or (coalesce(P.LicenseNo,'')<>'' and coalesce(P.LicenseExpiry,cast('01/01/1900' as smalldatetime))>=cast(convert(varchar(10), @P_PDate,1) as smalldatetime)))
       or
       (coalesce(Up.ID, P.ID)<>P.ID)
)
Then 'License has expired'
When Not (
       (coalesce(AIF.ID,'')='' or (coalesce(AIF.ID,'')<>'' and coalesce(AIF.EDate,cast('01/01/1900' as smalldatetime))>=cast(convert(varchar(10), @P_PDate,1) as smalldatetime)))
)
Then 'Contract has expired'
else '' 
end as RestrictedRemarks,

P.LOB, 
S1.ID as SID, S1.Name as SName, 
P.DumpF,P.Phone_1,P.Phone_2,
AIF.AgentType 
From Profile P 
Left Join AIF on (AIF.ID=P.ID and AIF.Status='R')
Left Join AIF UL on (UL.AgentID=AIF.ULAgentID and UL.Status='R')
Left Join Profile uP on (uP.ID=UL.ID and (coalesce(uP.LicenseNo,'')='' or (coalesce(uP.LicenseNo,'')<>'' and coalesce(uP.LicenseExpiry,cast('01/01/1900' as smalldatetime))>=cast(convert(varchar(10), @P_PDate,1) as smalldatetime))))
Left Join SysUserAssignment S on (S.AssType='SOURCE' and S.PID=P.ID and S.ID=@P_UserID)
Left join SysUser S1 on (S1.ID=S.ID and S1.AllowedF=1)
Where coalesce(P.DumpF,0)=0 and P.IntermediaryF=1
--and 
--(
--     (coalesce(P.LicenseNo,'')='' or (coalesce(P.LicenseNo,'')<>'' and coalesce(P.LicenseExpiry,cast('01/01/1900' as smalldatetime))>=cast(convert(varchar(10), @P_PDate,1) as smalldatetime)))
--     or
--     (coalesce(Up.ID, P.ID)<>P.ID)
--)
--and
--(
--     (coalesce(AIF.ID,'')='' or (coalesce(AIF.ID,'')<>'' and coalesce(AIF.EDate,cast('01/01/1900' as smalldatetime))>=cast(convert(varchar(10), @P_PDate,1) as smalldatetime)))
--)
and 
(
       not exists(Select Top 1 PID from SysUserAssignment S Where S.AssType='SOURCE' and S.ID=@P_UserID) or coalesce(S1.ID,'')=@P_UserID
)
)    
go




 insert into PatchVersioning
select '495 Update Script - FN_UserBusinessSource',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='495 Update Script - FN_UserBusinessSource'


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
