--HAPUS BERKAITAN ICPS

Select 'DROP ' 
+ CASE WHEN O.type_desc='VIEW' THEN 'VIEW ' 
 WHEN O.type_desc lIKE '%FUNCTION%' THEN 'FUNCTION '
 WHEN O.type_desc='SQL_STORED_PROCEDURE' THEN 'PROCEDURE '
END
+ O.NAME    + char(13) + char(10) + ' GO '  As SQL_TextDrop
,O.NAME 
, M.definition + char(13) + char(10) + ' GO ' As SQL_Text
,O.type_desc
from sys.all_sql_modules M
INNER JOIN sys.objects O ON O.object_id = M.object_id
where
-- Filter SP/UDF/View yang ingin di Recreate
(M.definition like '%USERID VARCHAR%' or  M.definition like '%UserID as Varchar%'
or M.definition like '%ITEM AS VARCHAR%' or  M.definition like '%Item varchar%'
or M.definition like '%Name as varchar%' or  M.definition like '%Name varchar%'
or M.definition like '%Description as VARCHAR%' or  M.definition like '%Description VARCHAR%'
or M.definition like '%Description_1 as VARCHAR%' or  M.definition like '%Description_1 VARCHAR%'
or M.definition like '%Remarks as VARCHAR%' or  M.definition like '%Remarks VARCHAR%'
or M.definition like '%ClaimantInfo as VARCHAR%' or  M.definition like '%ClaimantInfo VARCHAR%'
or M.definition like '%VALUEDESC as varchar%' or  M.definition like '%VALUEDESC varchar%'
or M.definition like '%.ID AS VARCHAR%' or M.definition like '%ObjInfo varchar%' 
or M.definition like '%SQL as varchar%' 
-- VALUE1 VALUE23 PEMANGGILAN LISTQRY diubah jadi NVARCHAR
or M.definition like '%VALUE1 as VARCHAR%' or  M.definition like '%VALUE1 VARCHAR%'
or M.definition like '%VALUE2 as VARCHAR%' or  M.definition like '%VALUE2 VARCHAR%'
or M.definition like '%VALUE3 as VARCHAR%' or  M.definition like '%VALUE3 VARCHAR%'
or M.definition like '%VALUE4 as VARCHAR%' or  M.definition like '%VALUE4 VARCHAR%'
or M.definition like '%VALUE5 as VARCHAR%' or  M.definition like '%VALUE5 VARCHAR%'
or M.definition like '%VALUE6 as VARCHAR%' or  M.definition like '%VALUE6 VARCHAR%'
or M.definition like '%VALUE7 as VARCHAR%' or  M.definition like '%VALUE7 VARCHAR%'
or M.definition like '%VALUE8 as VARCHAR%' or  M.definition like '%VALUE8 VARCHAR%'
or M.definition like '%VALUE9 as VARCHAR%' or  M.definition like '%VALUE9 VARCHAR%'
or M.definition like '%VALUE10 as VARCHAR%' or  M.definition like '%VALUE10 VARCHAR%'
or M.definition like '%VALUE11 as VARCHAR%' or  M.definition like '%VALUE11 VARCHAR%'
or M.definition like '%VALUE12 as VARCHAR%' or  M.definition like '%VALUE12 VARCHAR%'
or M.definition like '%VALUE13 as VARCHAR%' or  M.definition like '%VALUE13 VARCHAR%'
or M.definition like '%VALUE14 as VARCHAR%' or  M.definition like '%VALUE14 VARCHAR%'
or M.definition like '%VALUE15 as VARCHAR%' or  M.definition like '%VALUE15 VARCHAR%'
or M.definition like '%VALUE16 as VARCHAR%' or  M.definition like '%VALUE16 VARCHAR%'
or M.definition like '%VALUE17 as VARCHAR%' or  M.definition like '%VALUE17 VARCHAR%'
or M.definition like '%VALUE18 as VARCHAR%' or  M.definition like '%VALUE18 VARCHAR%'
or M.definition like '%VALUE19 as VARCHAR%' or  M.definition like '%VALUE19 VARCHAR%'
or M.definition like '%VALUE20 as VARCHAR%' or  M.definition like '%VALUE20 VARCHAR%'
or M.definition like '%VALUE21 as VARCHAR%' or  M.definition like '%VALUE21 VARCHAR%'
or M.definition like '%VALUE22 as VARCHAR%' or  M.definition like '%VALUE22 VARCHAR%'
or M.definition like '%VALUE23 as VARCHAR%' or  M.definition like '%VALUE23 VARCHAR%'
)
and o.name not like 'R_%' AND O.name NOT LIKE 'dt_%'
AND O.name not like 'ICPS_%' and o.name not like 'Outstanding%'
AND O.name not like 'Premium%' and o.name not like 'Proc_%'
AND O.name not like 'SP_EDC_%' and o.name not like 'Func_%'
AND O.name not like 'ACCUMULATION%' and o.name not like 'DELIMITER%'
AND O.name not like 'EXPOSURE%' and o.name not like 'FN_CH_%'
and o.name not in('getAdmedikaReimburse','getClaimDiagnosis','getClaimDiagnosis2','getClaimDiagnosis3',
'getClaimDiagnosisACA','getClaimDocument','getClaimReason','getEmployee','getGLDiagnosis','getmemberperbatchclient',
'getPLANPType','getPreClaimDiagnosis2','getQPlanMembershipPT','getTotalAcceptedClaim','getTotalBilledClaim',
'getTotalExcessClaim','getVisitClaim','AcceptanceRatio_BS')
ORDER BY O.NAME

--INCLUDE GetPrivileges GetUserRights get_objectInfo




