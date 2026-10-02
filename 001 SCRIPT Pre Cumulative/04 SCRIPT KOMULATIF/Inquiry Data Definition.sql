

drop table sysDefinitions
GO
Select 
S1.name as TBName,
S2.name as ColName,
Case S2.user_type_id 
When 56 Then 'Int'
When 34 then 'Image'
When 35 Then 'Memo/Text'
When 167 then 'VarChar'
When 104 then 'Bit'
When 38 Then 'Int'
When 58 Then 'SmallDateTime'
when 61 Then 'DateTime'
When 109 Then 'Float'
When 62 Then 'Float'
When 52 Then 'Int'
When 231 then 'nVarChar'
When 175 then 'Char'
When 256 then 'sysname'
When 165 then 'VarBinary'
When 98 then 'sql_variant'
else cast(S2.user_type_id as varchar(10)) end as Type,
S2.Max_Length as Length,
cast(S3.Value as varchar(1024)) as Description
into sysdefinitions
from sys.all_objects S1, sys.all_columns S2 Left Join sys.extended_properties S3 on (S3.major_id=S2.object_id and S3.minor_id=S2.column_id and S3.name='MS_Description')
Where S1.Type='U' and S1.object_id=S2.object_id
Order By Type, TBName, S2.column_id 
GO
-- 
-- GO
-- sp_configure 'Allow Update', 1
-- GO
-- RECONFIGURE WITH OVERRIDE
-- GO
-- Update S3 Set S3.Value=S4.Description
-- from sys.all_objects S1, sys.all_columns S2 Left Join sys.extended_properties S3 on (S3.major_id=S2.object_id and S3.minor_id=S2.column_id and S3.name='MS_Description'), sysdefinitions S4
-- Where S1.Type='U' and S1.object_id=S2.object_id and S2.name=S4.ColName and S1.Name=S4.TBName
-- GO
-- sp_configure 'Allow Update', 0
-- GO
-- RECONFIGURE WITH OVERRIDE
-- 
-- 
-- EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User Type (see SysUserType)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysUserTypeTOC', @level2type=N'COLUMN',@level2name=N'Type'
-- 


Delete from sysdefinitions Where TBname like '[zxWy]%' and TBname<>'Wording'
Delete from sysdefinitions Where TBname like 'tA%' and TBName not like 'TAX%'
Delete from sysdefinitions Where TBname like 'tI%' 
Delete from sysdefinitions Where TBname like 'tP%' 
Delete from sysdefinitions Where TBname like 'tR%' 
Delete from sysdefinitions Where TBname like 'tSL%' 
Delete from sysdefinitions Where TBname like 'tVoucher%' 
Delete from sysdefinitions Where TBname like 'dtProper%' 
Delete from sysdefinitions Where TBName like 'AIF%'
Delete from sysdefinitions Where TBName like 'AGENT%'
Delete from sysdefinitions Where TBName like 'ICPS%'
--Delete from sysdefinitions Where TBName like 'SysBatch%'
Delete from sysdefinitions Where TBName like 'Inv%'
Delete from sysdefinitions Where TBName like 'Ass%'
Delete from sysdefinitions Where TBName like 'SMS%'
Delete from sysdefinitions Where TBName like 'IO%'
Delete from sysdefinitions Where TBName like 'SysDiagram%' 
delete sysdefinitions Where TBName='sysdefinitions'
Update sysDefinitions Set Description='Last User Update' Where ColName like 'Last_Opr%'
Update sysDefinitions Set Description='Last Date Update' Where ColName like 'Last_Update%'
Update sysDefinitions Set Description='Last Modification Date' Where ColName like 'Last_Date%'
Update sysDefinitions Set Description='Last Modification Time' Where ColName like 'Last_Time%'
Update sysDefinitions Set Description='Last Login Date' Where ColName like 'Last_Login_Date%'
Update sysDefinitions Set Description='Last Login Time' Where ColName like 'Last_Login_Time%'
Update sysDefinitions Set Description='Allow Selection Flag (0 : No, 1 : Yes)' Where ColName like 'Allowedf%'





--For Datawarehouse

Update SysDefinitions set description='TSI Lower (see Risk and Loss Table Setting)' Where ColName='TSI_Lower'
Update SysDefinitions set description='TSI Upper (see Risk and Loss Table Setting)' Where ColName='TSI_Upper'
Update SysDefinitions set description='Branch Code (see Branch)' Where ColName='BRANCH'
Update SysDefinitions set description='Segment ID (see Segment)' Where ColName='SEGMENT'
Update SysDefinitions set description='Segment Group (see Segment Group)' Where ColName='SEGMENT_Group'
Update SysDefinitions set description='Marketing Officer Code (see SysUser)' Where ColName='MO_Code'
Update SysDefinitions set description='Nature Of Loss ID (see NOCTAB)' Where ColName='NATURE_OF_LOSS'
Update SysDefinitions set description='Cause Of Loss ID (see COLTAB)' Where ColName='CAUSE_OF_LOSS'
Update SysDefinitions set description='Transaction Date' Where ColName='DATE'
Update SysDefinitions set description='Insurance Source type (see ISType)' Where ColName='ISTYPE'
Update SysDefinitions set description='Class Of Business ID (see COB)' Where ColName='COB'
Update SysDefinitions set description='Sub-Class Of Business ID (see TOC)' Where ColName='TOC'
Update SysDefinitions set description='Sub-Class Of Business Group (see TOC_GROUP)' Where ColName='TOC_GROUP'
Update SysDefinitions set description='Type Of Product (see TOPRO)' Where ColName='PRODUCT'
Update SysDefinitions set description='Rate code (see RateTab)' Where ColName='COVERAGE'
Update SysDefinitions set description='Marketing Structure Code (See MSCode)' Where ColName='MS_CODE'
Update SysDefinitions set description='Payer Profile ID (see Profile)' Where ColName='PAYER_ID'
Update SysDefinitions set description='Business Source profile ID (see Profile)' Where ColName='SOURCE_ID'
Update SysDefinitions set description='Agent Profile ID (see Profile)' Where ColName='AGENT_ID'
Update SysDefinitions set description='Broker Profile ID (see Broker)' Where ColName='BROKER_ID'
Update SysDefinitions set description='Original Currency' Where ColName='CURRENCY'
Update SysDefinitions set description='Month Of Loss Occurence' Where ColName='LossMonth'
Update SysDefinitions set description='Year Of Loss Occurence' Where ColName='LossYear'
Update SysDefinitions set description='Policy Underwriting Month' Where ColName='UWMonth'
Update SysDefinitions set description='Policy Underwriting Year' Where ColName='UWYear'
Update SysDefinitions set description='Transaction Type (‘New’,’Endorsement’, ‘Cancellation’, ‘Adjustment’) ' Where ColName='Transaction_Type'
Update SysDefinitions set description='Kurs Booking Rate' Where ColName='Rate'
Update SysDefinitions set description='Unearned Premium Factor (in Days) since Transaction Date' Where ColName='UPFACTOR'
Update SysDefinitions set description='Number Of Days Reserve' Where ColName='DAYS_RESERVE'
Update SysDefinitions set description='Date Reserve Start' Where ColName='START_RESERVE'
Update SysDefinitions set description='Date Reserve End' Where ColName='End_RESERVE'


