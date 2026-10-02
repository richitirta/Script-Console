DROP PROCEDURE ListDet01
GO
CREATE PROCEDURE ListDet01 (@P_ANO as integer)   
AS  
  
Declare @AType varchar(10)  
Declare @AStatus varchar(10)  
Declare @RegNo varchar(50)  
Declare @P_PANO int  
  
Select @AType=A.AType, @AStatus=A.AStatus, @P_PANO=A.pANO, @RegNo=A.RegNo  
from Acceptance A  
Where A.ANO=@P_ANO  
  
Declare @Temp_ANO table(ANO Int, OANO Int Primary key)  
  
insert into @Temp_ANO  
Select ANO, OANO  
from Acceptance Where ANO<>LANO and LANO=@P_ANO  
  
if @AStatus='W' or @AStatus='T'  
 insert into @Temp_ANO  
 Select ANO, OANO  
 from Acceptance Where ANO<>LANO and LANO<>-1 and LANO=@P_PANO  
 and not exists (Select OANO from @Temp_ANO T Where T.OANO=Acceptance.OANO)  
else  
 if @AStatus='C'   
  insert into @Temp_ANO  
  Select ANO, OANO  
  from Acceptance Where ANO<>LANO and RegNo<>'' and RegNo=@RegNo  
  and not exists (Select OANO from @Temp_ANO T Where T.OANO=Acceptance.OANO)  
  
   
SELECT 
 Cast(0 as bit) as ProcessFlag,  
 Acceptance.CertificateNo,   
 Acceptance.RefNo,   
 Acceptance.ESeqNo,  
 Acceptance.ERSeqNo,  
 Cast(Acceptance.AName as varchar(128)) as AName,    
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.LUSERID as UserID,   
 SysTab.Currency,   
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,   
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE,   
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,   
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(RArrheader.Rdate) AS RYear,  
  Acceptance.ValueID,  
  dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,  
 Acceptance.BatchNo  
FROM @Temp_ANO T  
Inner Join Acceptance on (Acceptance.ANO=T.ANO)  
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)  
Inner Join Systab on (1=1)  
Order By Acceptance.CertificateNo   


GO

DROP PROCEDURE ListDet03
GO
CREATE PROCEDURE ListDet03 (@P_ANO as integer,@P_SDATE as smalldatetime, @P_EDATE as smalldatetime) 
AS

Declare @AType varchar(10)
Declare @AStatus varchar(10)
Declare @RegNo varchar(50)
Declare @P_PANO int

Select @AType=A.AType, @AStatus=A.AStatus, @P_PANO=A.pANO, @RegNo=A.RegNo
from Acceptance A
Where A.ANO=@P_ANO

Declare @Temp_ANO table(ANO Int, OANO Int Primary key)

insert into @Temp_ANO
Select ANO, OANO
from Acceptance Where ANO<>LANO and LANO=@P_ANO
And Acceptance.ADate Between @P_Sdate and @P_EDate 

if @AStatus='W' or @AStatus='T'
	insert into @Temp_ANO
	Select ANO, OANO
	from Acceptance Where ANO<>LANO and LANO<>-1 and LANO=@P_PANO
	And Acceptance.ADate Between @P_Sdate and @P_EDate 
	and not exists (Select OANO from @Temp_ANO T Where T.OANO=Acceptance.OANO)
else
	if @AStatus='C' 
		insert into @Temp_ANO
		Select ANO, OANO
		from Acceptance Where ANO<>LANO and RegNo<>'' and RegNo=@RegNo
		And Acceptance.ADate Between @P_Sdate and @P_EDate 
		and not exists (Select OANO from @Temp_ANO T Where T.OANO=Acceptance.OANO)
 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as varchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM @Temp_ANO T
Inner Join Acceptance on (Acceptance.ANO=T.ANO)
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Systab on (1=1)
Order By Acceptance.CertificateNo 

GO
DROP PROCEDURE ListDet04
GO
CREATE PROCEDURE ListDet04 (@P_ANO as integer,@P_FCERTNO as varchar(20), @P_LCERTNO as varchar(20)) 
AS 
Declare @AType varchar(10)
Declare @AStatus varchar(10)
Declare @RegNo varchar(50)
Declare @P_PANO int

Select @AType=A.AType, @AStatus=A.AStatus, @P_PANO=A.pANO, @RegNo=A.RegNo
from Acceptance A
Where A.ANO=@P_ANO

Declare @Temp_ANO table(ANO Int, OANO Int Primary key)

insert into @Temp_ANO
Select ANO, OANO
from Acceptance Where ANO<>LANO and LANO=@P_ANO
And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo 

if @AStatus='W' or @AStatus='T'
	insert into @Temp_ANO
	Select ANO, OANO
	from Acceptance Where ANO<>LANO and LANO<>-1 and LANO=@P_PANO
	And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo 
	and not exists (Select OANO from @Temp_ANO T Where T.OANO=Acceptance.OANO)
else
	if @AStatus='C' 
		insert into @Temp_ANO
		Select ANO, OANO
		from Acceptance Where ANO<>LANO and RegNo<>'' and RegNo=@RegNo
		And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo 
		and not exists (Select OANO from @Temp_ANO T Where T.OANO=Acceptance.OANO)

 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as varchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM @Temp_ANO T
Inner Join Acceptance on (Acceptance.ANO=T.ANO)
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Systab on (1=1)
Order By Acceptance.CertificateNo 

GO

DROP PROCEDURE ListDet05
GO
CREATE PROCEDURE ListDet05 (@P_ANO as integer,@P_FBATCHNO as varchar(20), @P_LBATCHNO as varchar(20)) 
AS 

Declare @AType varchar(10)
Declare @AStatus varchar(10)
Declare @RegNo varchar(50)
Declare @P_PANO int

Select @AType=A.AType, @AStatus=A.AStatus, @P_PANO=A.pANO, @RegNo=A.RegNo
from Acceptance A
Where A.ANO=@P_ANO

Declare @Temp_ANO table(ANO Int, OANO Int Primary key)

insert into @Temp_ANO
Select ANO, OANO
from Acceptance Where ANO<>LANO and LANO=@P_ANO
And Acceptance.BatchNo Between @P_FBatchNo and @P_LBatchNo 

if @AStatus='W' or @AStatus='T'
	insert into @Temp_ANO
	Select ANO, OANO
	from Acceptance Where ANO<>LANO and LANO<>-1 and LANO=@P_PANO
	And Acceptance.BatchNo Between @P_FBatchNo and @P_LBatchNo 
	and not exists (Select OANO from @Temp_ANO T Where T.OANO=Acceptance.OANO)
else
	if @AStatus='C' 
		insert into @Temp_ANO
		Select ANO, OANO
		from Acceptance Where ANO<>LANO and RegNo<>'' and RegNo=@RegNo
		And Acceptance.BatchNo Between @P_FBatchNo and @P_LBatchNo 
		and not exists (Select OANO from @Temp_ANO T Where T.OANO=Acceptance.OANO)
 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as varchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM @Temp_ANO T
Inner Join Acceptance on (Acceptance.ANO=T.ANO)
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Systab on (1=1)
Order By Acceptance.CertificateNo 

GO


insert into PatchVersioning
select '1059 Update Script - Patch 2024 (30)',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1059 Update Script - Patch 2024 (30)'


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
