
--perbaikan sms jika f2 loadingnya gak selesai"
DROP View UserSendTo
GO
Create View UserSendTo
as 
(
Select S1.ID, S1.Name, 'U' as Type from SysUser S1 Where S1.expiry >=  convert(date, getdate()) and S1.AllowedF=1 
union all 
Select Type as ID, Description as Name, 'T' as Type from SysUserType
)
GO