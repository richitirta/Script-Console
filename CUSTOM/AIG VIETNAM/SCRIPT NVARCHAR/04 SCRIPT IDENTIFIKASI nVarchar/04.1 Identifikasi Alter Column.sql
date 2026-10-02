--select * from sysdefinitions where type='varchar' order by TBName

select * from sysdefinitions where tbname not like 'budget%' and tbname not like 'CALL%' AND TBNAME NOT LIKE 'ClaimLetter%'
and tbname not like 'CARD%' and tbname not like 'Certificate%' and tbname not like 'ClaimDetail%' AND TBNAME NOT LIKE 'ClaimH%'
AND TBNAME NOT LIKE 'ClaimTracking%' AND (TBNAME NOT LIKE 'Policy%' OR TBNAME='PolicyType') AND TBNAME NOT LIKE 'Member%'
AND TBNAME NOT LIKE 'MOP%' AND TBNAME NOT LIKE 'PLAN%' AND TBNAME NOT LIKE 'POST%' AND TBNAME NOT LIKE 'PPLAN%' AND TBNAME NOT LIKE 'PRE%'
AND TBNAME NOT LIKE 'PRODUCT%' AND TBNAME NOT LIKE 'Provider%' AND TBNAME NOT LIKE 'Quotation%' AND TBNAME NOT LIKE 'RefPolicy%'
AND TBNAME NOT LIKE 'RPBucket_%' AND TBNAME NOT LIKE 'SAP_GLFX_%' AND TBNAME NOT LIKE 'T_AROS%' AND TBNAME NOT LIKE 'T_LL_%'
AND TBNAME NOT LIKE 'TEMP%'
and TBNAME NOT LIKE 'MAP_FIELD_%' and TBNAME NOT LIKE 'MAP_HEADER_%' and TBNAME NOT LIKE 'MAP_REFERENCE_%' 
AND TBNAME NOT IN('Claim_Confinement','Claim_Diagnosis','Claim_TermCon','Claim_Treatment','ClaimDailyRemarks',
'ClaimDocument','ClaimGL_DocumentList','ClaimTracking','PCB_Scan','QPrintLogH','ReasonH','Renewal_CHISS',
'Regency','RefPolicyDetail'
)
and type='varchar'
and (COLNAME like '%USERID%' or  COLNAME like '%Address%'
or COLNAME like '%ITEM%' or  COLNAME like '%Last_Opr%'
or COLNAME like '%Name%' or  COLNAME like '%ShortDesc%'
or COLNAME like '%Description%' or  COLNAME like '%Attrib%'
or COLNAME like '%Description_1%' or  COLNAME like '%COMMENT%'
or COLNAME like '%Remark%' or  COLNAME like '%SYSUSERID%'
or COLNAME like '%ClaimantInfo%' or  COLNAME like '%RequestName%'
or COLNAME like '%RequestMessage%' or  COLNAME like '%ActionUser%'
or COLNAME like '%VALUEDESC%' or  COLNAME like '%Email%'
or COLNAME like '%Location%' or COLNAME like '%ObjInfo%'
or COLNAME like '%HoldMessage%' or COLNAME like '%ObjInfo%'
)
order by TBName
