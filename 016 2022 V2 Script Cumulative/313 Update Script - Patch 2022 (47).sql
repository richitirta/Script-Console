
drop view VQuotationData
go
drop view vPolicyData
go
Alter Table COLLECTIOND Alter Column AName varchar(2048)
go
Alter Table Renewal Alter Column AName varchar(2048)
go
Alter Table Scheme_Transaction Alter Column AName varchar(2048)
go
Alter Table ACCEPTANCE Alter Column AName varchar(2048)
go
Alter Table ALBucket Alter Column Insured varchar(2048)
go
Alter Table Service Alter Column Insured varchar(2048)
go
Alter Table Cover Alter Column Insured varchar(2048)
go
Alter Table Admlink Alter COlumn Remarks varchar(2048)
go
Alter Table nVoucher Alter COlumn Remarks varchar(2048)
go
Alter Table pvoucher Alter COlumn Remarks varchar(2048)
go
Alter Table mVoucher Alter COlumn Remarks varchar(2048)
go
Alter Table ACCASS Alter COlumn Remarks varchar(2048)
go

CREATE VIEW VQuotationData with SchemaBinding  

AS        

SELECT ACCEPTANCE.ANO, COVER.TOC AS TOC, COVER.INSURED AS Insured, ACCEPTANCE.AName AS AName, COVER.COVERNO, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO AS PolicyNo, ACCEPTANCE.CERTIFICATENO AS CertificateNo, ACCEPTANCE.REFNO, Acceptance.PDate, Acceptance.PPDate,   

AINFO.VALUEID1, AINFO.VALUEDESC1,  

AINFO.VALUEID2, AINFO.VALUEDESC2,  

AINFO.VALUEID3, AINFO.VALUEDESC3,  

AINFO.VALUEID4, AINFO.VALUEDESC4,  

AINFO.VALUEID5, AINFO.VALUEDESC5,  

AINFO.VALUEID6, AINFO.VALUEDESC6,  

AINFO.VALUEID7, AINFO.VALUEDESC7,  

AINFO.VALUEID8, AINFO.VALUEDESC8,  

AINFO.VALUEID9, AINFO.VALUEDESC9,  

AINFO.VALUEID10, AINFO.VALUEDESC10,  

AINFO.VALUEID11, AINFO.VALUEDESC11,  

AINFO.VALUEID12, AINFO.VALUEDESC12,  

AINFO.VALUEID13, AINFO.VALUEDESC13,  

AINFO.VALUEID14, AINFO.VALUEDESC14,  

AINFO.VALUEID15, AINFO.VALUEDESC15  

FROM DBO.COVER as COVER 

INNER JOIN  DBO.ACCEPTANCE ACCEPTANCE ON COVER.CNO = ACCEPTANCE.CNO 

INNER JOIN  DBO.RARRHEADER RARRHEADER ON (RARRHEADER.ANO=ACCEPTANCE.ANO)

INNER JOIN  DBO.AINFO AINFO ON ACCEPTANCE.ANO = AINFO.ANO        

WHERE (ACCEPTANCE.ANO <> ACCEPTANCE.LANO) AND RARRHEADER.STATUS='A' AND COVER.CSTATUS NOT IN ('C') AND datediff(day, ACCEPTANCE.PDATE,ACCEPTANCE.PPDATE)>0 

go

CREATE VIEW vPolicyData with SchemaBinding    

AS          

SELECT ACCEPTANCE.ANO, COVER.TOC AS TOC, COVER.INSURED AS Insured, ACCEPTANCE.AName AS AName, COVER.COVERNO, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO AS PolicyNo, ACCEPTANCE.CERTIFICATENO AS CertificateNo, ACCEPTANCE.REFNO, Acceptance.PDate, Acceptance.PPDate,     

AINFO.VALUEID1, AINFO.VALUEDESC1,    

AINFO.VALUEID2, AINFO.VALUEDESC2,    

AINFO.VALUEID3, AINFO.VALUEDESC3,    

AINFO.VALUEID4, AINFO.VALUEDESC4,    

AINFO.VALUEID5, AINFO.VALUEDESC5,    

AINFO.VALUEID6, AINFO.VALUEDESC6,    

AINFO.VALUEID7, AINFO.VALUEDESC7,    

AINFO.VALUEID8, AINFO.VALUEDESC8,    

AINFO.VALUEID9, AINFO.VALUEDESC9,    

AINFO.VALUEID10, AINFO.VALUEDESC10,    

AINFO.VALUEID11, AINFO.VALUEDESC11,    

AINFO.VALUEID12, AINFO.VALUEDESC12,    

AINFO.VALUEID13, AINFO.VALUEDESC13,    

AINFO.VALUEID14, AINFO.VALUEDESC14,    

AINFO.VALUEID15, AINFO.VALUEDESC15    

FROM DBO.COVER as COVER INNER JOIN  DBO.ACCEPTANCE ACCEPTANCE ON COVER.CNO = ACCEPTANCE.CNO INNER JOIN  DBO.AINFO AINFO ON ACCEPTANCE.ANO = AINFO.ANO          

WHERE (ACCEPTANCE.ANO <> ACCEPTANCE.LANO) AND (ACCEPTANCE.ATYPE NOT IN ('C', 'A')) AND (ACCEPTANCE.ASTATUS NOT IN ('W','T')) AND NOT (COVER.CSTATUS='C' AND ACCEPTANCE.ASTATUS='C') AND datediff(day, ACCEPTANCE.PDATE,ACCEPTANCE.PPDATE)>0 AND ACCEPTANCE.POLICYNO<>''              




go

 insert into PatchVersioning
select '313 Update Script - Patch 2022 (47)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='313 Update Script - Patch 2022 (47)'


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

