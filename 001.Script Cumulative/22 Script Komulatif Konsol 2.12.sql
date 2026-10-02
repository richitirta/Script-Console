--5 sept 2017 : tuning script
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_Acceptance_RegNo' AND object_id = OBJECT_ID('Acceptance'))
BEGIN
DROP INDEX Acceptance.I_Acceptance_RegNo
END
GO

CREATE INDEX I_Acceptance_RegNo on Acceptance(RegNo) INCLUDE (ANO,LANO, CNO, ASTATUS, CERTIFICATENO, BATCHNO, CDATE)
go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'AutoInforce_Process') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN
DROP Procedure AutoInforce_Process
END
GO
CREATE Procedure AutoInforce_Process(@P_PDate as smalldatetime)                                                
as                                       

Declare @AIBucket table(PID int, ADate SmallDateTime, Last_Update SmallDateTime, RegNo Varchar(20), CertificateNo varchar(20), BatchNo varchar(20), Status varchar(1))
insert into @AIBucket Select PID, ADate, Last_Update, RegNo, CertificateNo, BatchNo, Status from AIBucket Where Status='R'

--Individual Polis First    
Select AIBucket.ADate, AIBucket.PID, Acceptance.ANO, Acceptance.LANO, Acceptance.RegNo, Acceptance.BatchNo, cast(0 as Bit) as BulkF                  
from @AIBucket AIBucket, Acceptance, Cover                    
where AIBucket.Status='R'     
and Acceptance.RegNo=AIBucket.RegNo and Acceptance.LANO=-1    
and Cover.CNO=Acceptance.CNO and Cover.CStatus='A' and Acceptance.AStatus='W'         
and Acceptance.CDate<=AIBucket.Last_Update     

Union All    

--Certificate Second    
Select AIBucket.ADate, AIBucket.PID, Acceptance.ANO, Acceptance.LANO, Acceptance.RegNo, Acceptance.BatchNo, cast(0 as Bit) as BulkF    
from @AIBucket AIBucket, Acceptance, Cover                    
where AIBucket.Status='R'     
and Acceptance.RegNo=AIBucket.RegNo and AIBucket.CertificateNo<>'' and Acceptance.CertificateNo=AIBucket.CertificateNo and Acceptance.ANO<>Acceptance.LANO and Cover.OpenFlag=1                  
and Cover.CNO=Acceptance.CNO and Cover.CStatus='A' and Acceptance.AStatus='W'         
and Acceptance.CDate<=AIBucket.Last_Update     

Union All        

--Bulk Inforce Certificate    
Select AIBucket.ADate, AIBucket.PID, Max(Acceptance.LANO) as ANO, Max(Acceptance.LANO) as LANO, Max(Acceptance.RegNo) as RegNo, Acceptance.BatchNo, cast(1 as Bit) as BulkF                  
from @AIBucket AIBucket, Acceptance, Cover                    
where AIBucket.Status='R'     
and Acceptance.RegNo=AIBucket.RegNo and AIBucket.CertificateNo='' and Acceptance.BatchNo=AIBucket.BatchNo and Acceptance.ANO<>Acceptance.LANO and Cover.OpenFlag=1                  
and Cover.CNO=Acceptance.CNO and Cover.CStatus='A' and Acceptance.AStatus='W'         
and Acceptance.CDate<=AIBucket.Last_Update     
Group By AIBucket.ADate, AIBucket.PID, Acceptance.BatchNo    

Union All    

--Fleet Polis Last    
Select AIBucket.ADate, AIBucket.PID, Acceptance.ANO, Acceptance.LANO, Acceptance.RegNo, Acceptance.BatchNo, cast(0 as Bit) as BulkF    
from @AIBucket AIBucket, Acceptance, Cover                    
where AIBucket.Status='R'     
and Acceptance.RegNo=AIBucket.RegNo and Acceptance.ANO=Acceptance.LANO    
and Cover.CNO=Acceptance.CNO and Cover.CStatus='A' and Acceptance.AStatus='W'         
and Acceptance.CDate<=AIBucket.Last_Update     
go

--integrasi vendor

alter table Profile alter column Last_Time	varchar	(8)
go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SYNCDATE' AND Object_ID = Object_ID(N'PROFILE'))
BEGIN
ALTER TABLE PROFILE ADD SYNCDATE smalldatetime
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SYNCTIME' AND Object_ID = Object_ID(N'PROFILE'))
BEGIN
ALTER TABLE PROFILE ADD SYNCTIME varchar(8)
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SYNCERRORMESSAGE' AND Object_ID = Object_ID(N'PROFILE'))
BEGIN
ALTER TABLE PROFILE ADD SYNCERRORMESSAGE varchar(MAX)
END
GO

ALTER TABLE Profile ALTER COLUMN SyncDate	varchar(20)
GO
ALTER TABLE Profile ALTER COLUMN SyncTime	varchar(8)
GO
ALTER TABLE PROFILE ALTER COLUMN LAST_TIME varchar(8)
go


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCDOCLIST') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN
DROP Procedure QCDOCLIST
END
GO

CREATE Procedure QCDOCLIST(@P_CNO integer, @P_INO integer, @P_NOC varchar(10))   
as   
Select CDOCLIST.*, CDOCLISTPIC.IMAGEID
from   
(   
select Cast(coalesce(CDOCLIST.AvailableF, 0) as bit) as ProcessFlag, cast(coalesce(DOCLIST.MandatoryF,0) as Bit) as MandatoryF, DOCLIST.DocType, coalesce(CDOCLIST.Description, DOCLIST.Description) as Description, coalesce(CDOCLIST.AvailableF, 0) as AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, CDOCLIST.RecDate   
from DOCLIST Left join DOCTYPE on (DOCTYPE.DOCTYPE=DOCLIST.DOCTYPE) inner join ICOVER on (ICover.INO=@P_INO and DOCLIST.NOC=@P_NOC and DOCLIST.TOI=ICOVER.TOI)   
Left Join CDOCLIST on (CDOCLIST.CNO=@P_CNO and CDOCLIST.INO=ICover.INO and CDOCLIST.DOCTYPE=DOCLIST.DOCTYPE)   
   
Union All   
   
select Cast(coalesce(CDOCLIST.AvailableF, 0) as bit) as ProcessFlag, cast(0 as Bit) as MandatoryF, CDOCList.DocType, CDOCLIST.Description, CDOCLIST.AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, CDOCLIST.RecDate   
from CDOCLIST Left Join DOCTYPE on (DOCTYPE.DOCTYPE=CDOCLIST.DOCTYPE)   
Where CDOCLIST.CNO=@P_CNO AND CDOCLIST.INO=@P_INO   
AND NOT EXISTS (Select DOCLIST.DOCTYPE from DOCLIST, ICOVER Where DOCLIST.DOCTYPE=CDOCLIST.DOCTYPE AND ICOVER.INO=@P_INO AND DOCLIST.NOC=@P_NOC AND DOCLIST.TOI=ICOVER.TOI)   
) CDOCLIST LEFT JOIN CDOCLISTPIC ON (CDOCLISTPIC.CNO=@P_CNO AND CDOCLISTPIC.DOCTYPE=CDOCLIST.DOCTYPE)
Order By CDOCLIST.DOCTYPE   
   
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QACCDOCLIST') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN
DROP Procedure QACCDOCLIST
END
GO

CREATE Procedure QACCDOCLIST(@P_ANO integer)   
as   
Select A1.*, A2.ImageID   
from   
(   
select Cast(coalesce(ACCDOCLIST.AvailableF, 0) as bit) as ProcessFlag, cast(coalesce(PDOCLIST.MandatoryF,0) as Bit) as MandatoryF, PDOCLIST.DocType, coalesce(ACCDOCLIST.Description, PDOCLIST.Description) as Description, coalesce(ACCDOCLIST.AvailableF, 0) as AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, ACCDOCLIST.RECDATE   
from ACCEPTANCE INNER JOIN COVER ON (ACCEPTANCE.ANO=@P_ANO AND COVER.CNO=ACCEPTANCE.CNO) 
INNER JOIN PDOCLIST ON (PDOCLIST.TOC=ACCEPTANCE.TOC) 
Left join DOCTYPE on (DOCTYPE.DOCTYPE=PDOCLIST.DOCTYPE)   
Left Join ACCDOCLIST on (ACCDOCLIST.ANO=@P_ANO and ACCDOCLIST.DOCTYPE=PDOCLIST.DOCTYPE)   
   
Union All   
   
select Cast(coalesce(ACCDOCLIST.AvailableF, 0) as bit) as ProcessFlag, cast(0 as Bit) as MandatoryF, ACCDOCLIST.DocType, ACCDOCLIST.Description, ACCDOCLIST.AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, ACCDOCLIST.RECDATE   
from ACCDOCLIST Left Join DOCTYPE on (DOCTYPE.DOCTYPE=ACCDOCLIST.DOCTYPE)   
Where ACCDOCLIST.ANO=@P_ANO   
AND NOT EXISTS (Select PDOCLIST.DOCTYPE from PDOCLIST, COVER, ACCEPTANCE Where PDOCLIST.DOCTYPE=ACCDOCLIST.DOCTYPE AND ACCEPTANCE.ANO=@P_ANO AND COVER.CNO=ACCEPTANCE.CNO AND PDOCLIST.TOC=ACCEPTANCE.TOC)   
) A1 Left Join ACCDOCLISTPIC A2 on (A2.ANO=@P_ANO and A2.DocType=A1.DocType)
Order By A1.DOCTYPE   


IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_PAlias_Name_Address' AND object_id = OBJECT_ID('pAlias'))
BEGIN
drop index pAlias.I_PAlias_Name_Address
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ctlf' AND Object_ID = Object_ID(N'dedtab'))
BEGIN
alter table dedtab add ctlf bit
END
go

--Perbaikan untuk PCTLOSS

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QScheme_Verify_3') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN
DROP Procedure QScheme_Verify_3
END
GO

CREATE Procedure QScheme_Verify_3
@P_Coverage as varchar(255),
@P_Code as varchar(10),
@p_LMonth as float,
@p_UMonth as float,
@p_SchemeNo as varchar (10),
@p_Description as varchar (255),
@P_TSI as float=0
as
 
Declare @p_ClassNo int
Declare @P_SIInceptionF Bit
Select Top 1 @p_ClassNo=S2.ClassNo, @P_SIInceptionF=S1.SIInceptionF
from scheme_Master S1, Scheme_Class S2
Where S1.SchemeNo=@P_SchemeNo and S2.SchemeNo=S1.SchemeNo and @P_Description like S2.Description
Order by S2.Priority Desc
 
Select
S1.Lower,
S1.NoRefundF,
S1.RateLoadingF,
Coalesce(SI1.HoldF, S1.HoldF) as HoldF,
Max(S1.Upper)as Upper,
Max(coalesce(SI1.PCTLoss, S1.PCTLoss)) as PCTLoss,
Max(coalesce(SI1.PAddition, S1.PAddition)) as PAddition,
Max(coalesce(SI1.Discount, S1.Discount)) as Discount,
Max(coalesce(SI1.RateLower, S1.RateLower)) as RateLower,
Max(coalesce(SI1.Rate,S1.Rate)) as Rate
From
Scheme_Indemnity S1
Left Join Scheme_Indemnity_TSI SI1
On (SI1.ClassNo=S1.ClassNo and SI1.Coverage=S1.Coverage and SI1.Code=S1.Code and SI1.Lower=S1.Lower and SI1.Upper=S1.Upper
-- Range by TSI Compare to Header Only Percentage Of Loss
and (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end>=SI1.MinTSI or SI1.MinTSI=0) and (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end<=SI1.MaxTSI or SI1.MaxTSI=0))
Where
S1.ClassNo=@P_ClassNo
and S1.Coverage=@P_Coverage
and S1.Code=@P_Code
and
(
(S1.Lower>=@p_LMonth and S1.Upper<=@p_UMonth)
or
(S1.Lower<=@p_LMonth and S1.Upper>=@p_UMonth)
or
(S1.Lower<=@p_LMonth and S1.Upper>=@p_LMonth)
or
(S1.Lower<=@p_UMonth and S1.Upper>=@p_UMonth)
)
and NOT EXISTS (Select S3.ClassNo from Scheme_Indemnity S3 Where S3.ClassNo=S1.ClassNo and S3.Coverage=S1.Coverage and S3.Code=S1.Code and S1.Lower=S3.Lower and S1.Upper>S3.Upper and S3.Lower<=@P_LMonth and S3.Upper>=@P_UMonth)
and NOT EXISTS (Select S3.ClassNo from Scheme_Indemnity S3 Where S3.ClassNo=S1.ClassNo and S3.Coverage=S1.Coverage and S3.Code=S1.Code and S1.Lower=S3.Lower and S1.Upper<S3.Upper and S3.Lower>=@P_LMonth and S3.Upper<=@P_UMonth)
Group By S1.Lower, S1.NoRefundF, S1.RateLoadingF, Coalesce(SI1.HoldF, S1.HoldF)
Order By S1.Lower, S1.NoRefundF, S1.RateLoadingF, Coalesce(SI1.HoldF, S1.HoldF)
 go
--VERSIONING
insert into versioning
select '2017 V.2.12.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='21 Script Komulatif Konsol 2.11'
Select @CurrSCript='22 Script Komulatif Konsol 2.12'


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