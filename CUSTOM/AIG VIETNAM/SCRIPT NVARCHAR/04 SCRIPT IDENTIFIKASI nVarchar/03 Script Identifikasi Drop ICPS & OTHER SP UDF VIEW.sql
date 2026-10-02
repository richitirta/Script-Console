--REFRESH SP UDF VIEW
SELECT DISTINCT * FROM (
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
(M.definition like '%ICPS%' or  O.NAME='fn_Risk_Coverage_LIPPO')
AND O.NAME NOT IN ('FL_ICPS_COLTAB','QSpreadInfo_Default','SP_Search_TOI')

UNION ALL

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
O.NAME IN ('R_PMK10_2011_Deductible','VQuotationData','vPolicyData',
'R_PMK10_2014_COL','R_PMK10_2014_GeneralTable','R_PMK10_2011_GeneralTable',
'R_OJK_2021_KOTA','R_OJK_2021_PROVINSI')
) U

ORDER BY U.NAME
