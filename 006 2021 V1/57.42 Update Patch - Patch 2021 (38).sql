IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ICPS_PolicyDeductible]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION ICPS_PolicyDeductible 
end
GO
CREATE Function ICPS_PolicyDeductible(@P_ANO as int, @P_Category as varchar(1))     
RETURNS VarChar(512)        
     
AS        
BEGIN        
 Declare @Remarks as varchar(512)        
 Declare @Remark as varchar(512)       
 Declare @Rate  as varchar(512)      
 Declare @Unit as varchar(512)      
          
 Select @Remarks=''        
 DECLARE AccDed_Cursor CURSOR FOR        
    
 Select Distinct Cast(AccDed.Remarks as varchar(512)) as Remark   
 from dbo.AccDed, dbo.Acceptance, dbo.Cover, dbo.RClass     
 Where Cover.CNO=Acceptance.CNO and AccDed.ANO=Acceptance.ANO   
 and RClass.TOC=Acceptance.TOC and RClass.TOR=AccDed.TOR and (RClass.Category=@P_Category or @P_Category='')     
 and Acceptance.ANO=@P_ANO  
  
 OPEN AccDed_Cursor        
 FETCH FROM AccDed_Cursor into @Remark    
 WHILE @@FETCH_STATUS = 0        
 BEGIN        
    if @Remarks=''        
    BEGIN        
  Select @Remarks=@Remark    
    End        
     Else        
    BEGIN        
     Select @Remarks=substring(@Remarks+'|'+@Remark,1,512)        
    End        
    FETCH NEXT FROM AccDed_Cursor into @Remark    
 End        
 Close AccDed_Cursor        
 Deallocate AccDed_Cursor        
 Return (@Remarks)        
End 

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[PCALC01_ADJ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure PCALC01_ADJ
end
GO

CREATE Procedure PCALC01_ADJ(@P_ANO integer)   
As   
SELECT  A1.TOC,   
COVER.PPERIOD,   
DATEDIFF(DAY,A1.SDATE, A1.EDATE) as PRORATA,   
COVER.VOYAGE,   
CASE WHEN RCOVER.UNIT='L' Then 'C' ELSE RCOVER.UNIT END AS UNIT,    
RCOVER.CODE,   
RATECOV.TOR,   
RCOVER.DISCOUNT+RCOVER.DISCOUNT_EXT AS DISCOUNT,    
RCOVER.LOADING*CASE WHEN RCOVER.CATEGORY='M' AND ICOVER.CATEGORY='M' THEN DBO.FN_RATE_LOADING(RCOVER.ANO) ELSE 1 END AS LOADING,
CASE 
WHEN RCOVER.UNIT='L' Then 0 
WHEN RCOVER.CATEGORY='M' AND ICOVER.CATEGORY='M' THEN RCOVER.RATE*RATECOV.PORTION/RCOVER.PORTION*Case When TOI.ADJMETHOD='OVERLIMIT' Then 1 Else RCalc.Prorata end
ELSE RCOVER.RATE*RATECOV.PORTION/RCOVER.PORTION*Case When TOI.ADJMETHOD='OVERLIMIT' Then 1 Else RCalc.Prorata end
END AS RATE,   
case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end as SDATE,   
Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end as EDATE,   
Case WHEN ICOVER.NOTDECRF=1 then 100 else RCOVER.PCTLOSS end as PCTLOSS,   
Case WHEN ICOVER.NOTDECRF=1 then 0 else RCOVER.PADDITION end as PADDITION,   
Case When (Case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end)=A1.SDATE AND (Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end)=A1.EDATE Then RCover.PCalc Else 'P' End as PCalc,   
Case when TOI.ADJMETHOD='OVERLIMIT' then A1.CPCT else (Case When A1.CPCT<>0 then A1.CPCT else 100 end*cast(datediff(day, case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end, Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end) as float)/  cast(DATEDIFF(DAY,RCOVER.SDATE, RCOVER.EDATE) as float)) end as PPRORATA,   
ICOVER.CURRENCY,   
ICOVER.SI,   
(Select sum(DDiscount) from AccDed Where ANO=ICover.ANO and (Currency='' or Currency=ICover.Currency) and TOR=RateCov.TOR) as DDISCOUNT,
ICOVER.Adjustable,   
ICOVER.PCTADJ,   
TOI.ADJMETHOD,   
ICOVER.INO,   
A2.ANO AS SANO,   
PolicyType.SType   
FROM  ACCEPTANCE A1
INNER JOIN ACCEPTANCE A2 ON (A2.OANO=A1.OANO and A2.ANO<=A1.PANO and A2.ANO<@P_ANO and A2.AType not in ('A','C'))
INNER JOIN COVER ON (COVER.CNO=A1.CNO)
Left Join PolicyType on (PolicyType.PolicyType=Cover.PolicyType)
INNER JOIN ICOVER ON (ICOVER.ANO=A1.ANO AND ICOVER.ADJUSTABLE=1)
INNER JOIN RCOVER ON (RCOVER.ANO=A2.ANO)
INNER JOIN RATECOV ON (RATECOV.CODE=RCOVER.CODE)
INNER JOIN RCLASS ON (RCLASS.TOC=A1.TOC AND RCLASS.TOR=RATECOV.TOR)
INNER JOIN PCLASS ON (PCLASS.TOR=RATECOV.TOR AND PCLASS.TOI=ICOVER.TOI)
INNER JOIN TOI ON (TOI.TOI=ICOVER.TOI)
INNER JOIN RCALC ON (RCalc.ANO=A2.ANO and RCalc.Currency=ICover.Currency and RCalc.Code=RCover.Code and RCalc.TOR=RateCov.TOR and RCalc.SDate=RCover.SDate)
Where A1.ANO=@P_ANO AND A1.PDate <= A2.PDate And A1.PPDate >= A2.PPDate And A2.PDate <= A2.PPDate   
and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.AStatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO)   
and (TOI.ADJMETHOD<>'OVERLIMIT' or A2.ANO=A1.PANO)   
and (case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end)<(Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end)
ORDER BY ICOVER.CURRENCY, RCOVER.CODE, RATECOV.TOR, RCOVER.SDATE, A2.ANO   


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCheckObjectInsured]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QCheckObjectInsured
end
GO

CREATE Procedure QCheckObjectInsured(@P_ANO as integer) 
as 
Select max(C1.CoverNo) as QuotationNo, max(A1.RegNo) as CINo, max(A1.PolicyNo+case when A1.CertificateNo='' then '' else '-'+A1.CertificateNo end) as PolicyNo, max(A1.AName) as Insured, max(A1.SDate) as Inception, max(A1.EDate) as Expiry, 
Max(Cast(TOC.FLDTAG1+' : '+A3.ValueDesc1 as varchar(255))) as ObjInfo_1, 
Max(Cast(TOC.FLDTAG2+' : '+A3.ValueDesc2 as varchar(255))) as ObjInfo_2, 
Max(Cast(TOC.FLDTAG3+' : '+A3.ValueDesc3 as varchar(255))) as ObjInfo_3, 
Max(Cast(TOC.FLDTAG4+' : '+A3.ValueDesc4 as varchar(255))) as ObjInfo_4, 
Max(Cast(TOC.FLDTAG5+' : '+A3.ValueDesc5 as varchar(255))) as ObjInfo_5, 
Max(Cast(TOC.FLDTAG6+' : '+A3.ValueDesc6 as varchar(255))) as ObjInfo_6, 
Max(Cast(TOC.FLDTAG7+' : '+A3.ValueDesc7 as varchar(255))) as ObjInfo_7, 
Max(Cast(TOC.FLDTAG8+' : '+A3.ValueDesc8 as varchar(255))) as ObjInfo_8, 
Max(Cast(TOC.FLDTAG9+' : '+A3.ValueDesc9 as varchar(255))) as ObjInfo_9, 
Max(Cast(TOC.FLDTAG10+' : '+A3.ValueDesc10 as varchar(255))) as ObjInfo_10, 
Max(Cast(TOC.FLDTAG11+' : '+A3.ValueDesc11 as varchar(255))) as ObjInfo_11, 
Max(Cast(TOC.FLDTAG12+' : '+A3.ValueDesc12 as varchar(255))) as ObjInfo_12, 
Max(Cast(TOC.FLDTAG13+' : '+A3.ValueDesc13 as varchar(255))) as ObjInfo_13, 
Max(Cast(TOC.FLDTAG14+' : '+A3.ValueDesc14 as varchar(255))) as ObjInfo_14, 
Max(Cast(TOC.FLDTAG15+' : '+A3.ValueDesc15 as varchar(255))) as ObjInfo_15, 
Max(A1.ANO) as ANO 
from Acceptance A2
Inner Join Cover C2 on (C2.CNO=A2.CNO)
Inner Join TOC on (TOC.TOC=A2.TOC)
Inner Join Acceptance A1 on (A1.ANO<>A2.RANO and A1.ANO<>A1.LANO and A1.OANO<>A2.OANO and A1.REGID=A2.REGID and A1.FLDID<>'' and A1.FLDID=A2.FLDID and A1.ValueID=A2.ValueID)
Inner Join Cover C1 on (C1.CNO=A1.CNO)
Left Join AInfo A3 On (A3.ANO=A1.ANO)
Where A2.ANO=@P_ANO and A2.ANO<>A2.LANO 
and A2.AType not in ('A','C') 
and A1.AType not in ('A','C') 
and Not (A1.AType='N' and A1.AStatus='C' and ((C1.CStatus='A' and C1.ASource='MKT') or C1.CStatus='C')) 
and A1.PDate<A1.PPDate 
and ( 
	(A1.pDate<=A2.pDate and ((A1.PPDate>A2.PDate) or (A1.PPDate>=A2.PDate and A1.ExclusiveF=0 and A2.ExclusiveF=1))) Or 
	(A2.pDate<=A1.pDate and ((A2.PPDate>A1.PDate) or (A2.PPDate>=A1.PDate and A2.ExclusiveF=0 and A1.ExclusiveF=1))) 
	) 
and TOC.UniqueRefNoF=0 
group By A1.OANO 
 
Union All 
 
Select max(C1.CoverNo) as QuotationNo, max(A1.RegNo) as CINo, max(A1.PolicyNo+case when A1.CertificateNo='' then '' else '-'+A1.CertificateNo end) as PolicyNo, max(A1.AName) as Insured, max(A1.SDate) as Inception, max(A1.EDate) as Expiry, 
Max(Cast(TOC.FLDTAG1+' : '+A3.ValueDesc1 as varchar(255))) as ObjInfo_1, 
Max(Cast(TOC.FLDTAG2+' : '+A3.ValueDesc2 as varchar(255))) as ObjInfo_2, 
Max(Cast(TOC.FLDTAG3+' : '+A3.ValueDesc3 as varchar(255))) as ObjInfo_3, 
Max(Cast(TOC.FLDTAG4+' : '+A3.ValueDesc4 as varchar(255))) as ObjInfo_4, 
Max(Cast(TOC.FLDTAG5+' : '+A3.ValueDesc5 as varchar(255))) as ObjInfo_5, 
Max(Cast(TOC.FLDTAG6+' : '+A3.ValueDesc6 as varchar(255))) as ObjInfo_6, 
Max(Cast(TOC.FLDTAG7+' : '+A3.ValueDesc7 as varchar(255))) as ObjInfo_7, 
Max(Cast(TOC.FLDTAG8+' : '+A3.ValueDesc8 as varchar(255))) as ObjInfo_8, 
Max(Cast(TOC.FLDTAG9+' : '+A3.ValueDesc9 as varchar(255))) as ObjInfo_9, 
Max(Cast(TOC.FLDTAG10+' : '+A3.ValueDesc10 as varchar(255))) as ObjInfo_10, 
Max(Cast(TOC.FLDTAG11+' : '+A3.ValueDesc11 as varchar(255))) as ObjInfo_11, 
Max(Cast(TOC.FLDTAG12+' : '+A3.ValueDesc12 as varchar(255))) as ObjInfo_12, 
Max(Cast(TOC.FLDTAG13+' : '+A3.ValueDesc13 as varchar(255))) as ObjInfo_13, 
Max(Cast(TOC.FLDTAG14+' : '+A3.ValueDesc14 as varchar(255))) as ObjInfo_14, 
Max(Cast(TOC.FLDTAG15+' : '+A3.ValueDesc15 as varchar(255))) as ObjInfo_15, 
Max(A1.ANO) as ANO 
from Acceptance A2
Inner join TOC on (TOC.TOC=A2.TOC)
Inner Join Cover C2 on (C2.CNO=A2.CNO)
Inner Join Acceptance A1 on (A1.ANO<>A2.RANO and A1.ANO=A1.LANO and A1.OANO<>A2.OANO and A1.TOC=A2.TOC and A1.RefNo=A2.RefNo)
Inner JOin Cover C1 on (C1.CNO=A1.CNO)
Left Join AInfo A3 On (A3.ANO=A1.ANO)
Where A2.ANO=@P_ANO and A2.ANO=A2.LANO 
and A2.AType not in ('A','C') 
and A1.AType not in ('A','C') 
and Not (A1.AType='N' and A1.AStatus='C' and ((C1.CStatus='A' and C1.ASource='MKT') or C1.CStatus='C')) 
and A1.PDate<A1.PPDate 
and ( 
	(A1.pDate<=A2.pDate and ((A1.PPDate>A2.PDate) or (A1.PPDate>=A2.PDate and A1.ExclusiveF=0 and A2.ExclusiveF=1))) Or 
	(A2.pDate<=A1.pDate and ((A2.PPDate>A1.PDate) or (A2.PPDate>=A1.PDate and A2.ExclusiveF=0 and A1.ExclusiveF=1))) 
	) 
and TOC.UniqueRefNoF=1 
group By A1.OANO 

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList11D]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION MList11D 
end
GO
CREATE function MList11D(@P_ANO AS INTEGER, @value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@Value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as 
varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255), @Value13 as varchar(255))  
returns table  
AS return  
(  
SELECT   
 Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as AName,   
 Acceptance.CertificateNo,   
 Cover.CNO,   
 Cover.CStatus,   
 Cover.VSeqNo,   
 Acceptance.LANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.USERID,   
 SysTab.Currency,   
 QPCalc.TSI,   
 QPCalc.OurShare,   
 QPCalc.Gross,   
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(RArrheader.Rdate) AS RYear  
FROM   
 Acceptance,   
 Cover,   
 RArrHeader,   
 SysTab,   
 QMasterAcceptance_PCalc() AS QPCalc,  
 Profile  
WHERE   
 Cover.CNO=Acceptance.CNO   
 And RArrHeader.ANO=Acceptance.ANO   
 And QPCalc.ANO=Acceptance.ANO   
 And Acceptance.ANO<>Acceptance.LANO   
 And Acceptance.LANO=@P_ANO  
  And Cover.PHOLDER=Profile.ID  
 And (Cover.Insured Like @Value1 Or (Cover.Insured is null))   
 And (Cover.CoverNo Like @Value2 Or (Cover.CoverNo is null))   
 And (cover.coverdate=@Value3 Or (cover.coverdate IS NULL) Or cover.coverdate='' or @Value3='')  
 And (cover.expdate=@Value4 Or (cover.expdate IS NULL) Or cover.expdate='' or @Value4='')    
 And (Acceptance.PolicyNo Like @Value5 Or (Acceptance.PolicyNo is null))   
 And (Acceptance.CertificateNo Like @Value6 Or (Acceptance.CertificateNo is null))   
 And (acceptance.policydate=@Value7 Or (acceptance.policydate IS NULL) Or acceptance.policydate='' or @Value7='')  
 And (Cover.CStatus Like @Value8)   
 And (Acceptance.RegNo Like @Value9)   
 And (Profile.Name like @Value10 or Profile.Name is null)  
 and Acceptance.toc like @Value11  
 And (Acceptance.RefNo Like @Value13)   
 And Cover.ISType<>'T'  
)  

GO
  
