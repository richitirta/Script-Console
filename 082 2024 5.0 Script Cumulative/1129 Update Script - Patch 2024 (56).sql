Drop View vProAcc
GO
Drop View vProfile
GO
Drop View vProfile_Ext
GO
DROP Function fn_ENCRYPTTEXT
GO
DROP Function fn_DECRYPTTEXT
GO
DROP Function fn_ENCRYPTDATE
GO
DROP Function fn_DECRYPTDATE
GO

Create Function fn_ENCRYPTTEXT(@PassPhrase varchar(2000),@PlainText varchar(2000))        
RETURNS varchar(2000) 
WITH SCHEMABINDING
AS          
BEGIN        

Declare @EncryptedText varchar(2000)

if @PassPhrase<>'' and @PlainText<>''
	Select @EncryptedText=convert(varchar(2000), ENCRYPTBYPASSPHRASE(@PassPhrase,@PlainText),1) 
else
	Select @EncryptedText=@Plaintext

return @EncryptedText
End

GO

Create Function fn_DECRYPTTEXT(@PassPhrase varchar(2000),@EncryptedText varchar(2000))        
RETURNS varchar(2000) 
WITH SCHEMABINDING
AS          
BEGIN        

Declare @DecryptedText varchar(2000)

if @PassPhrase<>'' and @EncryptedText<>''
	Select @DecryptedText=cast(DECRYPTBYPASSPHRASE(@PassPhrase,convert(varbinary(2000), @EncryptedText,1)) as varchar(2000))
else
	Select @DecryptedText=cast(@EncryptedText as varchar(2000))
	
return @DecryptedText
End

GO

Create Function fn_ENCRYPTDATE(@PassPhrase varchar(2000),@PlainDate SmallDatetime)        
RETURNS varchar(2000) 
WITH SCHEMABINDING
AS          
BEGIN        
        
Declare @EncryptedDate varchar(2000)

if @PassPhrase<>'' 
	Select @EncryptedDate=convert(varchar(2000), ENCRYPTBYPASSPHRASE(@PassPhrase,convert(varchar(10), @PlainDate,101)),1)
else
	Select @EncryptedDate=convert(varchar(10), @PlainDate,101)

return @EncryptedDate

End

GO

Create Function fn_DECRYPTDATE(@PassPhrase varchar(2000),@EncryptedDate varchar(2000))        
RETURNS smalldatetime 
WITH SCHEMABINDING
AS          
BEGIN        

Declare @DecryptedDate smalldatetime 

if @PassPhrase<>'' and @EncryptedDate<>''
	Select @DecryptedDate=cast(cast(DECRYPTBYPASSPHRASE(@PassPhrase,convert(varbinary(2000), @EncryptedDate,1)) as varchar(2000)) as smalldatetime)
else
	Select @DecryptedDate=cast(@EncryptedDate as smalldatetime)

Return @DecryptedDate

End

GO


Create View vProAcc
WITH SCHEMABINDING
AS
select 
ProAcc.ProAcc, 
ProAcc.Description, 
ProAcc.Currency, 
ProAcc.ID, 
dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,ProAcc.AccountNo) as AccountNO, 
dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,ProAcc.BankAccount) as BankAccount, 
ProAcc.BankName, 
ProAcc.Bank,
ProAcc.BankBranch,
ProAcc.RestrictedF, 
ProAcc.Last_Opr, 
ProAcc.Last_Update, 
ProAcc.UserID, 
ProAcc.CDate, 
ProAcc.BCTransferBy, 
ProAcc.RESTRICTAFTERUSEDF, 
ProAcc.Remarks, 
ProAcc.PUserID, 
ProAcc.PUserDate,
ProAcc.ExcludeTaxF, 
ProAcc.RefType, 
ProAcc.PRDays, 
ProAcc.Purpose, 
ProAcc.Account_DR, 
ProAcc.Account_CR
from dbo.Proacc ProAcc
Inner Join dbo.SysTab SysTab on (1=1)

GO


Create View vProfile
WITH SCHEMABINDING
AS
select 
Profile.ID, 
Profile.Name, 
dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.TaxID) as TaxID, 
dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.Email) as Email, 
dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.Email_2) as Email_2,
Profile.PREFERREDF,
Profile.RESTRICTEDF ,
Profile.PrivilegeType,
Profile.Address_1  ,
Profile.Address_2  ,
Profile.Address_3  ,
Profile.Phone_1,
Profile.Phone_2,
Profile.Fax_1,
Profile.Fax_2
from dbo.Profile Profile
Inner Join dbo.SysTab SysTab on (1=1)

GO

Create View vProfile_Ext
WITH SCHEMABINDING
AS
select 
Profile.ID, 
dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.ID_No) as ID_No, 
dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.ID_Type) as ID_Type, 
dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.PassportNo) as PassportNo, 
dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.Gender) as Gender, 
dbo.fn_DECRYPTTEXT(SysTab.EncryptionPassPhrase,Profile.MothersName) as MothersName, 
dbo.fn_DECRYPTDATE(SysTab.EncryptionPassPhrase,Profile.BirthDate) as BirthDate 
from dbo.Profile_Ext Profile
Inner Join dbo.SysTab SysTab on (1=1)


GO


DROP procedure qPolicyData
GO
Create procedure qPolicyData(@P_SQLFilter as varchar(2048), @P_MaxRecord as int=1000)          
as  
  
Declare @SQL as varchar(8000)  
  
Select @P_SQLFILTER=replace(@P_SQLFILTER,'``','''')

if @P_MaxRecord=0 
	Select @P_MaxRecord=1000
	  
Select @SQL=''      
Select @SQL = @SQL + ' Select Top ' + cast(@P_MaxRecord as varchar(10)) + '*'  
Select @SQL = @SQL + ' from '  
Select @SQL = @SQL + ' ('  
Select @SQL = @SQL + '  SELECT ACCEPTANCE.ANO, ACCEPTANCE.TOC AS TOC, COVER.INSURED AS Insured, ACCEPTANCE.AName AS AName, COVER.COVERNO, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO AS PolicyNo, ACCEPTANCE.CERTIFICATENO AS CertificateNo, ACCEPTANCE.REFNO, Acceptance.PDate, Acceptance.PPDate,       '  
Select @SQL = @SQL + '  coalesce(APayor.Installment, coalesce(MPayor.Installment, Payor.Installment)) as Installment, '
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
Select @SQL = @SQL + '  FROM ACCEPTANCE '
Select @SQL = @SQL + '  INNER JOIN  COVER ON COVER.CNO = ACCEPTANCE.CNO '
Select @SQL = @SQL + '  INNER JOIN  AINFO ON AINFO.ANO = ACCEPTANCE.ANO  '  
Select @SQL = @SQL + '  INNER JOIN vPROFILE PROFILE ON (PROFILE.ID=ACCEPTANCE.AID) LEFT JOIN vPROFILE_EXT PROFILE_EXT ON (PROFILE_EXT.ID=PROFILE.ID) '  
Select @SQL = @SQL + '  Left Join APayor on (APayor.ANO=ACCEPTANCE.ANO and ACCEPTANCE.LANO<>-1 and ACCEPTANCE.ANO<>ACCEPTANCE.LANO) '
Select @SQL = @SQL + '  Left Join Payor on (Payor.ANO=ACCEPTANCE.ANO and ACCEPTANCE.LANO=-1) '    
Select @SQL = @SQL + '  Left Join Payor MPayor on (MPayor.ANO=ACCEPTANCE.LANO and ACCEPTANCE.LANO<>-1)  '
Select @SQL = @SQL + '  INNER JOIN SYSTAB ON (1=1) '  
Select @SQL = @SQL + '  WHERE (ACCEPTANCE.ANO <> ACCEPTANCE.LANO) AND (ACCEPTANCE.ATYPE NOT IN (''C'', ''A'')) AND (ACCEPTANCE.ASTATUS NOT IN (''W'',''T'')) AND (COVER.CSTATUS<>''C'') AND (Acceptance.pAStatus<>''W'') AND ((ACCEPTANCE.PDATE<ACCEPTANCE.PPDATE) or (ACCEPTANCE.PDATE=ACCEPTANCE.PPDATE and ACCEPTANCE.STime<ACCEPTANCE.ETime)) AND ACCEPTANCE.POLICYNO<>''''                '  
Select @SQL = @SQL + ' ) Q'  
if @P_SQLFilter<>''  
 Select @SQL = @SQL + ' Where ' + @P_SQLFilter  
else
 Select @SQL = @SQL + ' Where 1<>1'
Execute (@SQL)  

GO
DROP procedure QQuotationData
GO
Create procedure QQuotationData(@P_SQLFilter as varchar(2048))          
as  
  
Declare @SQL as varchar(8000)  
  
Select @P_SQLFILTER=replace(@P_SQLFILTER,'``','''')
  
Select @SQL=''      
Select @SQL = @SQL + ' Select *'  
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
Select @SQL = @SQL + '  INNER JOIN vPROFILE PROFILE ON (PROFILE.ID=ACCEPTANCE.AID) LEFT JOIN vPROFILE_EXT PROFILE_EXT ON (PROFILE_EXT.ID=PROFILE.ID) '  
Select @SQL = @SQL + '  INNER JOIN SYSTAB ON (1=1) '  
Select @SQL = @SQL + '  WHERE (ACCEPTANCE.ANO <> ACCEPTANCE.LANO) AND (ACCEPTANCE.ATYPE NOT IN (''C'', ''A'')) AND NOT (COVER.CSTATUS=''C'') AND datediff(day, ACCEPTANCE.PDATE,ACCEPTANCE.PPDATE)>0 '  
Select @SQL = @SQL + ' ) Q'  
if @P_SQLFilter<>''  
 Select @SQL = @SQL + ' Where ' + @P_SQLFilter  

Execute (@SQL)  



GO

DROP Procedure QProfile_Data
GO
CREATE Procedure QProfile_Data(@P_ID varchar(10))      
AS       
Select P1.*, P2.*  
from vProfile P1 Left Join vProfile_Ext P2 on (P2.ID=P1.ID)      
Where P1.ID=@P_ID      

GO

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
  
Select @SQL = @SQL + '  SELECT ACCEPTANCE.ANO, COVER.TOC AS TOC, COVER.INSURED AS Insured, ACCEPTANCE.AName AS AName, COVER.COVERNO, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO AS PolicyNo, ACCEPTANCE.CERTIFICATENO AS CertificateNo, ACCEPTANCE.REFNO, ACCEPTANCE.PDate, ACCEPTANCE.PPDate,       '    
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
Select @SQL = @SQL + '  INNER JOIN vPROFILE PROFILE ON (PROFILE.ID=ACCEPTANCE.AID) LEFT JOIN vPROFILE_EXT PROFILE_EXT ON (PROFILE_EXT.ID=PROFILE.ID) '  
Select @SQL = @SQL + '  INNER JOIN SYSTAB ON (1=1) '  
Select @SQL = @SQL + '  WHERE COVER.CStatus=''A'' and ((ACCEPTANCE.AType=''N'' and COVER.ASource=''UW'') or (ACCEPTANCE.AType=''E'')) and ACCEPTANCE.pAStatus<>''W'' AND datediff(day, ACCEPTANCE.PDATE,ACCEPTANCE.PPDATE)>0 AND ACCEPTANCE.REGNO<>''''        
'    
Select @SQL = @SQL + ' ) Q'    
if @P_SQLFilter<>''    
 Select @SQL = @SQL + ' Where ' + @P_SQLFilter    
  
Execute (@SQL)    

GO  
  
DROP PROCEDURE PI01 
GO
CREATE PROCEDURE PI01 (@P_ANO AS INTEGER) 
AS 
( 
SELECT TOP 1 
A.POLICYNO, A.CERTIFICATENO, C.PHOLDER, P.PREFERREDF, P.RESTRICTEDF, P.NAME, A.ANAME, P.PrivilegeType, A.AID, 
(LTRIM(RTRIM(P.ADDRESS_1)) + ' ' + LTRIM(RTRIM(P.ADDRESS_2)) + ' ' + LTRIM(RTRIM(P.ADDRESS_3))) AS 'ADDRESS', 
(LTRIM(RTRIM(P.PHONE_1)) + ' ' + LTRIM(RTRIM(P.PHONE_2))) AS 'PHONE', 
(LTRIM(RTRIM(P.FAX_1)) + ' ' + LTRIM(RTRIM(P.FAX_2))) AS 'FAX', 
P.EMAIL,A.SDATE, A.EDATE, A.PDATE, A.PPDATE, A.NCDATE,
RA.POLICYNO as PPOLICYNO, RA.CERTIFICATENO as PCERTIFICATENO,
BS.Name as BSName, BS.ID as BSID, BS.PrivilegeType as BSPrivilegeType 
FROM COVER C 
INNER JOIN ACCEPTANCE A ON (A.CNO=C.CNO) 
LEFT JOIN ACCEPTANCE RA ON (RA.ANO=A.RANO) 
INNER JOIN vPROFILE P ON (C.PHOLDER=P.ID) 
LEFT JOIN PROFILE BS ON (BS.ID=A.SOURCE)
INNER JOIN SYSTAB ON (1=1)
WHERE A.ANO=@P_ANO 
) 
go

  insert into PatchVersioning
select '1129 Update Script - Patch 2024 (56)',GETDATE()
go
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1129 Update Script - Patch 2024 (56)'


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




