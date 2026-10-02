DROP procedure QRegisterData
GO
Create procedure QRegisterData(@P_SQLFilter as varchar(2048), @P_MaxRecord as int=1000)          
as  
  
Declare @SQL as varchar(8000)  
  
Select @P_SQLFILTER=replace(@P_SQLFILTER,'``','''')

if @P_MaxRecord=0 
	Select @P_MaxRecord=1000
	  
Select @SQL=''      
Select @SQL = @SQL + ' Select Top ' + cast(@P_MaxRecord as varchar(10)) + '*'  
Select @SQL = @SQL + ' from '  
Select @SQL = @SQL + ' ('  
Select @SQL = @SQL + '  SELECT ACCEPTANCE.ANO, COVER.TOC AS TOC, COVER.INSURED AS Insured, ACCEPTANCE.AName AS AName, COVER.COVERNO, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO AS PolicyNo, ACCEPTANCE.CERTIFICATENO AS CertificateNo, ACCEPTANCE.REFNO, Acceptance.PDate, Acceptance.PPDate,       '  
Select @SQL = @SQL + '  PROFILE.TAXID, PROFILE_EXT.ID_NO,     '
Select @SQL = @SQL + '  AINFO.VALUEID1, AINFO.VALUEDESC1,      '  
Select @SQL = @SQL + '  AINFO.VALUEID2, AINFO.VALUEDESC2,      '  
Select @SQL = @SQL + '  AINFO.VALUEID3, AINFO.VALUEDESC3,      '  
Select @SQL = @SQL + '  AINFO.VALUEID4, AINFO.VALUEDESC4,      '  
Select @SQL = @SQL + '  AINFO.VALUEID5, AINFO.VALUEDESC5,      '  
Select @SQL = @SQL + '  AINFO.VALUEID6, AINFO.VALUEDESC6,      '  
Select @SQL = @SQL + '  AINFO.VALUEID7, AINFO.VALUEDESC7,      '  
Select @SQL = @SQL + '  AINFO.VALUEID8, AINFO.VALUEDESC8,      '  
Select @SQL = @SQL + '  AINFO.VALUEID9, AINFO.VALUEDESC9,      '  
Select @SQL = @SQL + '  AINFO.VALUEID10, AINFO.VALUEDESC10,     '   
Select @SQL = @SQL + '  AINFO.VALUEID11, AINFO.VALUEDESC11,      '  
Select @SQL = @SQL + '  AINFO.VALUEID12, AINFO.VALUEDESC12,      '  
Select @SQL = @SQL + '  AINFO.VALUEID13, AINFO.VALUEDESC13,      '  
Select @SQL = @SQL + '  AINFO.VALUEID14, AINFO.VALUEDESC14,      '  
Select @SQL = @SQL + '  AINFO.VALUEID15, AINFO.VALUEDESC15      '  
Select @SQL = @SQL + '  FROM COVER INNER JOIN  ACCEPTANCE ON COVER.CNO = ACCEPTANCE.CNO INNER JOIN  AINFO ON ACCEPTANCE.ANO = AINFO.ANO '  
Select @SQL = @SQL + '  INNER JOIN PROFILE ON (PROFILE.ID=ACCEPTANCE.AID) LEFT JOIN PROFILE_EXT ON (PROFILE_EXT.ID=PROFILE.ID) '
Select @SQL = @SQL + '  WHERE (ACCEPTANCE.ATYPE NOT IN (''C'', ''A'')) AND (ACCEPTANCE.ASTATUS NOT IN (''W'',''T'')) AND (COVER.CSTATUS<>''C'') AND (Acceptance.pAStatus<>''W'') AND datediff(day, ACCEPTANCE.PDATE,ACCEPTANCE.PPDATE)>0 AND ACCEPTANCE.REGNO<>''''                '  
Select @SQL = @SQL + ' ) Q'  
if @P_SQLFilter<>''  
 Select @SQL = @SQL + ' Where ' + @P_SQLFilter  

Execute (@SQL)  

go

insert into PatchVersioning
select '86 Update Script - Patch 2021 (64)',GETDATE()
go