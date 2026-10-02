
--20 nov 2017
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SysUserID' AND Object_ID = Object_ID(N'RARRDET'))
BEGIN
ALTER TABLE RARRDET ADD	SysUserID varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Claim Controller (see SysUser with Role Controller/Common)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RARRDET', N'COLUMN', N'SysUserID'
end
go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QFacultative_Data') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QFacultative_Data
end
GO
CREATE Procedure QFacultative_Data(@P_ANO integer, @P_FID varchar(20))                    
AS                                  
SELECT R.FID, R.AType, F.SLIPNO, R.SDATE, R.EDATE, R.RTYPE, F.ID, R.SHARE, R.FLPCT, R.AMOUNT, R.LIMIT, R.EXCESS, R.UJROHREINS, R.UJROHCEDANT,                    
R.UserID, R.CDate,                  
R.LUserID, R.LDate,                  
R.AUserID, R.AUserDate,            
R.AcceptedBy, R.AcceptedDate,    
R.SysUserID,         
R.ClaimCOOP, R.PrecedeFacCessionF, R.NoRefundF,   
F.Code, F.COMM, F.OCOMM, F.ACQCOST, F.NETRATE, F.Currency, F.Unit, R.PCALC, R.CPCT, R.Memo, F.REMARKS, F.WPC, F.BinderNo, F.BinderWarranty, R.FULLCOVERF, R.ORIGINALF, R.OnGrossAfterCommF, R.OnNetRateF, R.CPRefund, F.PERIOD, F.INSTALLMENT,       
F.GRACE, R.JPSLIPNO, R.JPSHARE, R.JPCOMM,                    
F.CommAmount, F.OCommAmount, F.ProfitSharing, F.Discount, F.DiscAmount, F.BRID, F.BRComm,
F.IDATE_1, F.IPCT_1,                    
F.IDATE_2, F.IPCT_2,                    
F.IDATE_3, F.IPCT_3,                    
F.IDATE_4, F.IPCT_4,                    
F.IDATE_5, F.IPCT_5,                    
F.IDATE_6, F.IPCT_6,                    
F.IDATE_7, F.IPCT_7,                    
F.IDATE_8, F.IPCT_8,                    
F.IDATE_9, F.IPCT_9,                    
F.IDATE_10, F.IPCT_10,                    
F.IDATE_11, F.IPCT_11,                    
F.IDATE_12 , F.IPCT_12,      
F.IDATE_13 , F.IPCT_13,                    
F.IDATE_14 , F.IPCT_14,                    
F.IDATE_15 , F.IPCT_15,                    
F.IDATE_16 , F.IPCT_16,                    
F.IDATE_17 , F.IPCT_17,                    
F.IDATE_18 , F.IPCT_18,                    
F.IDATE_19 , F.IPCT_19,                    
F.IDATE_20 , F.IPCT_20,                    
F.IDATE_21 , F.IPCT_21,                    
F.IDATE_22 , F.IPCT_22,                    
F.IDATE_23 , F.IPCT_23,                    
F.IDATE_24 , F.IPCT_24      
FROM RARRDET R, FPART F                    
WHERE R.ANO=@P_ANO AND R.FID=@P_FID AND F.ANO=R.ANO AND F.FID=R.FID   
go


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Get_Fee_Amount_By_Percentage') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure Get_Fee_Amount_By_Percentage
end
GO
Create Procedure Get_Fee_Amount_By_Percentage(@P_ANO as Int, @P_Code as varchar(10), @P_FDType as varchar(1), @P_AmountPCT as Float, @P_AmountPCTBased as Int=0, @P_PolicyYear as Int=0)
as
Declare @P_LANO as integer
Declare @P_REGNO as varchar(20)
Declare @P_Fee as Float

Select @P_LANO=LANO, @P_REGNO=REGNO from Acceptance Where ANO=@P_ANO

if @P_LANO<>@P_ANO -- Individual or Certificate
		Select 
		@P_FEE=
		Case 
		When @P_FDTYPE<>'O' Then 
			 Case 
			 When @P_AmountPCTBased=0 then
				sum(D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100)
			 Else
				Max(P.OurShare*(100-R.MSHARE)/100)
			 End
	    Else
			 Case
			 When @P_AmountPCTBased=0 then
				sum(D1.Gross*P.Gross/P.OGross*P.OurShare/P.TSI)
			 Else
				Max(P.OurShare)
			 End
		End*@P_AmountPCT/100
		from Display_Calculation(@P_ANO) D1, Acceptance A, PCalc P, RARRHEADER R
		Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO and D1.Currency=@P_Code
		and (D1.ANO=@P_ANO or @P_FDTYPE<>'O')
		and (@P_PolicyYear=0 or (D1.SDate>=dateadd(month,12*(@P_PolicyYear-1),A.SDate) and D1.SDate<dateadd(month,12*(@P_PolicyYear),A.SDate)))

ELSE	-- Fleet Only
		SELECT @P_FEE=SUM(FEE)
		FROM
		(
			SELECT
			ACCEPTANCE.ANO,
			(
				Select 
				Case 
				When @P_FDTYPE<>'O' Then 
					Case
					When @P_AmountPCTBased=0 then
						sum(D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100)
					Else
						Max(P.OurShare*(100-R.MSHARE)/100)
					End
				ELSE 
					Case
					When @P_AmountPCTBased=0 then
						sum(D1.Gross*P.Gross/P.OGross*P.OurShare/P.TSI)
					Else
						Max(P.OurShare)
					End
				End*@P_AmountPCT/100
				from Display_Calculation(ACCEPTANCE.ANO) D1, Acceptance A, PCalc P, RARRHEADER R
				Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO and D1.Currency=@P_Code
				and (D1.ANO=ACCEPTANCE.ANO or @P_FDTYPE<>'O')
				and (@P_PolicyYear=0 or (D1.SDate>=dateadd(month,12*(@P_PolicyYear-1),A.SDate) and D1.SDate<dateadd(month,12*(@P_PolicyYear),A.SDate)))
			) as FEE
			FROM ACCEPTANCE, COVER
			WHERE COVER.CNO=ACCEPTANCE.CNO AND COVER.OPENFLAG=0 AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO AND ACCEPTANCE.LANO=@P_ANO AND ACCEPTANCE.REGNO=@P_REGNO
		) A
SELECT @P_FEE AS FEE
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BRID' AND Object_ID = Object_ID(N'RPART'))
BEGIN
ALTER TABLE RPART ADD	BRID varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Broker Re Profile ID (see Profile)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RPART', N'COLUMN', N'BRID'
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BRComm' AND Object_ID = Object_ID(N'RPART'))
BEGIN
ALTER TABLE RPART ADD	BRComm float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Broker Re Comm (in %)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RPART', N'COLUMN', N'BRComm'
end
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QRCESSION') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QRCESSION 
end
GO
CREATE Procedure QRCESSION (@P_RID varchar(255))      
as      
Select R1.ID, R1.SHARE, R1.COMM, R1.COMMI, R1.COMMN, R1.JP,R2.RID, R1.BRID, R1.BRCOMM, R2.CESSION, CASE WHEN COALESCE(R1.DOCNO,'')='' THEN R2.DOCNO ELSE R1.DOCNO END AS DOCNO, R2.LIMIT, R2.MDP, R2.CASHLOSS, R2.PRIORITYF, R2.STATEMENT, R2.UJROHREINS, R2.UJROHCEDANT, R2.TPPERIOD, R2.POLICYRUNOFFF  
from RPart R1, Reinsurance R2
WHERE R1.RNO = R2.RNO and R2.RID=@P_RID AND R1.SHARE<>0      

go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Condition' AND Object_ID = Object_ID(N'CLAIM'))
BEGIN
ALTER TABLE CLAIM ADD	Condition varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Claim Condition (see CCONDITION)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLAIM', N'COLUMN', N'Condition'
end
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QClaim_Data') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QClaim_Data
end
GO
CREATE Procedure QClaim_Data(@P_CNO integer) 
as 
SELECT CNO, ANO, EVENTNO, CLAIMNO, REGDATE,REFNO,REFDATE,REFTIME, POLICYNO, CERTIFICATENO, CLAIMANT, CLAIMANTINFO, PAYMENT, TOC, COL, EVENTNAME, LOCATION, LOSSPLACE, LOSSDATE, LOSSTIME, DESCRIPTION, SURVEYOR, ASSESSOR, BRANCH, 
UserID, CDate, CTime, 
LUSERID, LDate, LTime, 
PUSERID, PUserDate, PUserTime, 
AUSERID, AUserDate, AUserTime, 
CUserID, CloseDate, CloseTime, 
EXGRATIAF, TBAF_1, TBAF_2, (TBAF_1 | TBAF_2) as TBAF, CSTATUS, 
CType, PCSTATUS, VSEQNO, CSEQNO, ISTYPE, 
ASource, BackDatedF, SettledF, CT, SysUserID, Condition
FROM CLAIM C1 
WHERE C1.CNO=@P_CNO 
 
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CCondition') AND type in (N'U'))
BEGIN
CREATE TABLE CCondition(
	Condition varchar(10) NULL
) ON [PRIMARY]
Insert into CCondition
Select 'Express'
union all
Select 'Major'
union all
Select 'Complex'
end
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QRegisterData') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP procedure QRegisterData
end
GO
Create procedure QRegisterData(@P_SQLFilter as varchar(2048))          
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
Select @SQL = @SQL + '  INNER JOIN PROFILE ON (PROFILE.ID=ACCEPTANCE.AID) LEFT JOIN PROFILE_EXT ON (PROFILE_EXT.ID=PROFILE.ID) '
Select @SQL = @SQL + '  WHERE (ACCEPTANCE.ANO <> ACCEPTANCE.LANO) AND (ACCEPTANCE.ATYPE NOT IN (''C'', ''A'')) AND (COVER.CSTATUS=''A'') AND datediff(day, ACCEPTANCE.PDATE,ACCEPTANCE.PPDATE)>0 AND ACCEPTANCE.REGNO<>''''                '  
Select @SQL = @SQL + ' ) Q'  
if @P_SQLFilter<>''  
 Select @SQL = @SQL + ' Where ' + @P_SQLFilter  

Execute (@SQL)  

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QQuotationData') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP procedure QQuotationData
end
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
Select @SQL = @SQL + '  INNER JOIN PROFILE ON (PROFILE.ID=ACCEPTANCE.AID) LEFT JOIN PROFILE_EXT ON (PROFILE_EXT.ID=PROFILE.ID) '
Select @SQL = @SQL + '  WHERE (ACCEPTANCE.ANO <> ACCEPTANCE.LANO) AND (ACCEPTANCE.ATYPE NOT IN (''C'', ''A'')) AND NOT (COVER.CSTATUS=''C'') AND datediff(day, ACCEPTANCE.PDATE,ACCEPTANCE.PPDATE)>0 '  
Select @SQL = @SQL + ' ) Q'  
if @P_SQLFilter<>''  
 Select @SQL = @SQL + ' Where ' + @P_SQLFilter  

Execute (@SQL)  

go

--22 Nov 2017
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'PI04') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP procedure PI04
end
GO
CREATE procedure PI04 (@P_ANO as integer)  
as  
Select I1.INO, I1.Category, Cast(substring(I1.Remark,1,255) as varchar(255)) as Remark, I1.Currency, Max(I1.SI) as SI, Max(I1.Total) as Aggregate, sum(I2.SI) as Declared, sum(I2.Indemnity) as Indemnity
from ICover I1 Left Join Acceptance A2 on (A2.LANO=I1.ANO and A2.AStatus='I') Left Join ICover I2 on (I2.ANO=A2.ANO and I2.Category='M' and I2.Currency=I1.Currency and I2.TOI=I1.TOI)  
Where I1.ANO=@P_ANO  
Group By I1.INO, I1.Category, Cast(substring(I1.Remark,1,255) as varchar(255)), I1.Currency  
Order By I1.Category Desc, I1.INO  
GO


--VERSIONING
insert into versioning
select '2017 V.2.24.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='33 Script Komulatif Konsol 2.23'
Select @CurrSCript='34 Script Komulatif Konsol 2.24'


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
