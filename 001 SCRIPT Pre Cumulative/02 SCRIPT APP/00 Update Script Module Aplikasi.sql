
/****** Object:  Table [dbo].[CTBudget]    Script Date: 10/20/2016 2:33:17 PM ******/
DROP TABLE [dbo].[CTBudget]
GO

/****** Object:  Table [dbo].[CTBudget]    Script Date: 10/20/2016 2:33:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CTBudget](
	[Branch] [varchar](10) NOT NULL,
	[Year] [smallint] NOT NULL,
	[Account] [varchar](10) NOT NULL,
	[CT] [varchar](10) NOT NULL,
	[Month_1] [float] NULL,
	[Month_2] [float] NULL,
	[Month_3] [float] NULL,
	[Month_4] [float] NULL,
	[Month_5] [float] NULL,
	[Month_6] [float] NULL,
	[Month_7] [float] NULL,
	[Month_8] [float] NULL,
	[Month_9] [float] NULL,
	[Month_10] [float] NULL,
	[Month_11] [float] NULL,
	[Month_12] [float] NULL,
	[Actual_1] [float] NULL,
	[Actual_2] [float] NULL,
	[Actual_3] [float] NULL,
	[Actual_4] [float] NULL,
	[Actual_5] [float] NULL,
	[Actual_6] [float] NULL,
	[Actual_7] [float] NULL,
	[Actual_8] [float] NULL,
	[Actual_9] [float] NULL,
	[Actual_10] [float] NULL,
	[Actual_11] [float] NULL,
	[Actual_12] [float] NULL,
	[PMonth_1] [float] NULL,
	[PMonth_2] [float] NULL,
	[PMonth_3] [float] NULL,
	[PMonth_4] [float] NULL,
	[PMonth_5] [float] NULL,
	[PMonth_6] [float] NULL,
	[PMonth_7] [float] NULL,
	[PMonth_8] [float] NULL,
	[PMonth_9] [float] NULL,
	[PMonth_10] [float] NULL,
	[PMonth_11] [float] NULL,
	[PMonth_12] [float] NULL,
 CONSTRAINT [i_CTBudget] PRIMARY KEY CLUSTERED 
(
	[Account] ASC,
	[Branch] ASC,
	[Year] ASC,
	[CT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[CTBudget] ADD  DEFAULT (0) FOR [Month_1]
GO

ALTER TABLE [dbo].[CTBudget] ADD  DEFAULT (0) FOR [Month_2]
GO

ALTER TABLE [dbo].[CTBudget] ADD  DEFAULT (0) FOR [Month_3]
GO

ALTER TABLE [dbo].[CTBudget] ADD  DEFAULT (0) FOR [Month_4]
GO

ALTER TABLE [dbo].[CTBudget] ADD  DEFAULT (0) FOR [Month_5]
GO

ALTER TABLE [dbo].[CTBudget] ADD  DEFAULT (0) FOR [Month_6]
GO

ALTER TABLE [dbo].[CTBudget] ADD  DEFAULT (0) FOR [Month_7]
GO

ALTER TABLE [dbo].[CTBudget] ADD  DEFAULT (0) FOR [Month_8]
GO

ALTER TABLE [dbo].[CTBudget] ADD  DEFAULT (0) FOR [Month_9]
GO

ALTER TABLE [dbo].[CTBudget] ADD  DEFAULT (0) FOR [Month_10]
GO

ALTER TABLE [dbo].[CTBudget] ADD  DEFAULT (0) FOR [Month_11]
GO

ALTER TABLE [dbo].[CTBudget] ADD  DEFAULT (0) FOR [Month_12]
GO

ALTER TABLE [dbo].[CTBudget] ADD  CONSTRAINT [DF_CTBudget_Actual_1]  DEFAULT (0) FOR [Actual_1]
GO

ALTER TABLE [dbo].[CTBudget] ADD  CONSTRAINT [DF_CTBudget_Actual_2]  DEFAULT (0) FOR [Actual_2]
GO

ALTER TABLE [dbo].[CTBudget] ADD  CONSTRAINT [DF_CTBudget_Actual_3]  DEFAULT (0) FOR [Actual_3]
GO

ALTER TABLE [dbo].[CTBudget] ADD  CONSTRAINT [DF_CTBudget_Actual_4]  DEFAULT (0) FOR [Actual_4]
GO

ALTER TABLE [dbo].[CTBudget] ADD  CONSTRAINT [DF_CTBudget_Actual_11]  DEFAULT (0) FOR [Actual_5]
GO

ALTER TABLE [dbo].[CTBudget] ADD  CONSTRAINT [DF_CTBudget_Actual_21]  DEFAULT (0) FOR [Actual_6]
GO

ALTER TABLE [dbo].[CTBudget] ADD  CONSTRAINT [DF_CTBudget_Actual_31]  DEFAULT (0) FOR [Actual_7]
GO

ALTER TABLE [dbo].[CTBudget] ADD  CONSTRAINT [DF_CTBudget_Actual_41]  DEFAULT (0) FOR [Actual_8]
GO

ALTER TABLE [dbo].[CTBudget] ADD  CONSTRAINT [DF_CTBudget_Actual_11_1]  DEFAULT (0) FOR [Actual_9]
GO

ALTER TABLE [dbo].[CTBudget] ADD  CONSTRAINT [DF_CTBudget_Actual_21_1]  DEFAULT (0) FOR [Actual_10]
GO

ALTER TABLE [dbo].[CTBudget] ADD  CONSTRAINT [DF_CTBudget_Actual_31_1]  DEFAULT (0) FOR [Actual_11]
GO

ALTER TABLE [dbo].[CTBudget] ADD  CONSTRAINT [DF_CTBudget_Actual_41_1]  DEFAULT (0) FOR [Actual_12]
GO

ALTER TABLE [dbo].[CTBudget] ADD  CONSTRAINT [DF_CTBudget_PMonth_1]  DEFAULT (0) FOR [PMonth_1]
GO

ALTER TABLE [dbo].[CTBudget] ADD  CONSTRAINT [DF_CTBudget_PMonth_2]  DEFAULT (0) FOR [PMonth_2]
GO

ALTER TABLE [dbo].[CTBudget] ADD  CONSTRAINT [DF_CTBudget_PMonth_3]  DEFAULT (0) FOR [PMonth_3]
GO

ALTER TABLE [dbo].[CTBudget] ADD  CONSTRAINT [DF_CTBudget_PMonth_4]  DEFAULT (0) FOR [PMonth_4]
GO

ALTER TABLE [dbo].[CTBudget] ADD  CONSTRAINT [DF_CTBudget_PMonth_5]  DEFAULT (0) FOR [PMonth_5]
GO

ALTER TABLE [dbo].[CTBudget] ADD  CONSTRAINT [DF_CTBudget_PMonth_6]  DEFAULT (0) FOR [PMonth_6]
GO

ALTER TABLE [dbo].[CTBudget] ADD  CONSTRAINT [DF_CTBudget_PMonth_7]  DEFAULT (0) FOR [PMonth_7]
GO

ALTER TABLE [dbo].[CTBudget] ADD  CONSTRAINT [DF_CTBudget_PMonth_8]  DEFAULT (0) FOR [PMonth_8]
GO

ALTER TABLE [dbo].[CTBudget] ADD  CONSTRAINT [DF_CTBudget_PMonth_9]  DEFAULT (0) FOR [PMonth_9]
GO

ALTER TABLE [dbo].[CTBudget] ADD  CONSTRAINT [DF_CTBudget_PMonth_10]  DEFAULT (0) FOR [PMonth_10]
GO

ALTER TABLE [dbo].[CTBudget] ADD  CONSTRAINT [DF_CTBudget_PMonth_11]  DEFAULT (0) FOR [PMonth_11]
GO

ALTER TABLE [dbo].[CTBudget] ADD  CONSTRAINT [DF_CTBudget_PMonth_12]  DEFAULT (0) FOR [PMonth_12]
GO

ALTER TABLE [dbo].[CTBudget]  WITH NOCHECK ADD  CONSTRAINT [AccountCTBudget] FOREIGN KEY([Account])
REFERENCES [dbo].[Account] ([Account])
GO

ALTER TABLE [dbo].[CTBudget] CHECK CONSTRAINT [AccountCTBudget]
GO

ALTER TABLE [dbo].[CTBudget]  WITH NOCHECK ADD  CONSTRAINT [BranchCTBudget] FOREIGN KEY([Branch])
REFERENCES [dbo].[Branch] ([Branch])
GO

ALTER TABLE [dbo].[CTBudget] CHECK CONSTRAINT [BranchCTBudget]
GO

ALTER TABLE [dbo].[CTBudget]  WITH NOCHECK ADD  CONSTRAINT [CTCTBudget] FOREIGN KEY([CT])
REFERENCES [dbo].[CT] ([CT])
GO

ALTER TABLE [dbo].[CTBudget] CHECK CONSTRAINT [CTCTBudget]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Branch Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CTBudget', @level2type=N'COLUMN',@level2name=N'Branch'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Accounting Year' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CTBudget', @level2type=N'COLUMN',@level2name=N'Year'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Account Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CTBudget', @level2type=N'COLUMN',@level2name=N'Account'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Profit Center Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CTBudget', @level2type=N'COLUMN',@level2name=N'CT'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Budget Amount Month #1 (in Base Currency)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CTBudget', @level2type=N'COLUMN',@level2name=N'Month_1'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Actual Amount Month #1 (in Base Currency)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CTBudget', @level2type=N'COLUMN',@level2name=N'Actual_1'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Budget Amount Month #1 (in Base Currency)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CTBudget', @level2type=N'COLUMN',@level2name=N'PMonth_1'
GO




DROP PROCEDURE CLLIST11   
GO
CREATE PROCEDURE CLLIST11 AS    
SELECT Cast(0 as bit) as ProcessFlag,    
 [CLAIM].[CLAIMNO],    
 [CLAIM].[REGDATE],    
 [CLAIM].[REFNO],    
 [CLAIM].[COL],    
 [COLTAB].[DESCRIPTION],    
 [CLAIM].[LOSSDATE],    
 [CLAIM].[TOC],    
 [CLAIM].[CSDATE],    
 [CLAIM].[LOSSPLACE],    
 [CLAIM].[CTYPE],    
 [CLAIM].[CSTATUS],    
 [CLAIM].[CNO],    
 [CLAIM].[ANO],    
 [CLAIM].[PCNO],    
 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,    
 [SYSTAB].[CURRENCY],    
 [CCALC].[LOSS] AS ESTIMATE,    
 [CCALC].[CLAIM] AS CLAIM,    
 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,    
 [CCALC].[SALVAGE] AS SALVAGE,    
 [CCALC].[COST] AS COST,    
 [CCALC].[SUBROGATION] AS SUBROGATION, ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,    
 [CLAIM].[VSEQNO],    
 [CLAIM].[CSEQNO],    
 acceptance.aname,    
 acceptance.policyno,    
 acceptance.certificateno,    
 CLAIM.SETTLEDF    
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER, CLAIM AS C1,COLTAB,acceptance    
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]    
 And [CCALC].[CNO]=[CLAIM].[CNO]    
 And CLAIM.COL=COLTAB.COL    
 And [CLAIM].[CNO]=C1.PCNO    
 And C1.CSTATUS='P'    
 And C1.VSEQNO<>0    
 and acceptance.ano=claim.ano    

GO
    
    

-- Perubahan fungsi FL_SR_SchemeNo Penambahan Parameter User ID untuk pemeriksaan pada Scheme Branch Preference terhadap SysUserBranch dan Pemeriksaan TOC pada SysUserTOC
Drop Function FL_SR_SchemeNo
GO

Create function FL_SR_SchemeNo(@p_UserID varchar(10), @P_SchemeNo varchar(10),@P_PolicyNo varchar(10))  
RETURNS Table  
AS RETURN  
(

Select Distinct S.SchemeNo, S.Description, S.Disc, S.DailyBasisF, s.sPeriod, s.AllowedF 
from acceptance as a
inner join cover as c on (a.cno=c.cno and c.OpenFlag=1) 
inner join Scheme_Master S on (S.TOC=C.TOC and S.SchemeNo Like @P_SchemeNo)
inner join SysUser on (SysUser.ID=@P_UserID)
Left Join Scheme_Branch S1 on (SysUser.Type<>'SUPERVISOR' and S1.SchemeNo=S.SchemeNo) 
where a.ano = a.lano and A.AType not in ('A','C') and a.astatus = 'I' and a.PolicyNo Like @P_PolicyNo+'%' and a.ano not in (Select PANO from Acceptance Where Acceptance.PANO=a.ANO)
and (SysUser.Type='SUPERVISOR' or S1.Branch is null or S1.Branch in (Select Branch from SysUserBranch Where AllowedF=1 and ID=@P_UserID))
and (SysUser.Type='SUPERVISOR' or S.TOC in (Select TOC from SysUserTOC Where ID=@P_UserID))
)

GO


-- Perubahan procedure SchemeList untuk menampilkan informasi Gross Premi
Drop procedure SchemeList

GO

CREATE procedure SchemeList(@p_SchemeNo varchar(10),@P_PolicyNo varchar(20), @P_Branch varchar(20), @p_SDate smalldatetime,@p_EDate smalldatetime, @P_Status as varchar(10),@P_UserID as varchar(10), @P_BatchNoF as varchar(10)='', @P_BatchNoL as varchar(10)='')          
as          
              
select  s.*, PCalc.Gross, c.insured, sm.description          
From          
 scheme_transaction as s
 Left join PCalc on (PCalc.ANO=S.ANO) 
 Inner join Acceptance as a on (A.ANO=S.LANO and A.ANO=A.LANO and A.AStatus<>'W')     
 Inner join Cover as C on (C.CNO=A.CNO)
 Inner join scheme_master As sm on (sm.SchemeNo=S.SchemeNo)
Where          
 sm.schemeno Like @p_SchemeNo+'%'   
 and a.PolicyNo Like @P_PolicyNo+'%' and a.Branch like @P_Branch+'%'   
 and s.trdate >=@p_SDate and s.trDate<=@p_EDate   
 and (s.Status=@P_Status or @P_Status='') and (s.LUserID=@P_UserID or @P_UserID='')   
 and s.BatchNo Between @P_BatchNoF and @P_BatchNoL  
order by s.TrNo            

GO

-- Perubahan procedure SchemeList_by_TrNo untuk menampilkan informasi Gross Premi    
Drop procedure SchemeList_by_TrNo  
GO    
CREATE procedure SchemeList_by_TrNo (@p_TrNo integer)
as  
select top 1  
 s.*, PCalc.Gross, c.insured, sm.description  
from   
 scheme_transaction as s
 Left join PCalc on (PCalc.ANO=S.ANO) 
 Inner join Acceptance as a on (A.ANO=S.LANO and A.ANO=A.LANO and A.AStatus<>'W')     
 Inner join Cover as C on (C.CNO=A.CNO)
 Inner join scheme_master As sm on (sm.SchemeNo=S.SchemeNo)
where  S.TrNo=@P_TrNo

GO
  


    
DROP FUNCTION FN_UserSegment 
GO      
CREATE FUNCTION FN_UserSegment (@P_UserID as varchar(10))          
RETURNS TABLE          
as RETURN(          
SELECT Segment.*     
 from Segment     
 Inner join SysUser on (SysUser.ID=@P_UserID)    
 Where (SysUser.Type='SUPERVISOR' or Segment.Segment in (Select SysUserSegment.Segment from SysUserSegment Where SysUserSegment.ID=@P_UserID and SysUserSegment.Segment=Segment.Segment)) 
)        
        
GO
 

--DROP function ListDet05_b
--GO
--ALTER function ListDet05_b (@P_ANO as integer,   
--@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),   
--@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),  
--@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),  
--@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255)  
--)        
--RETURNS Table    
--AS RETURN    
--(    
--SELECT Cast(0 as bit) as ProcessFlag,    
-- q.[CertificateNo],    
-- q.ESeqNo,    
-- q.[AName],    
-- q.[ANO],    
-- q.[REGNO],    
-- q.[ADATE],    
-- q.[USERID],    
-- q.[Currency],    
-- q.[TSI],    
-- q.[OurShare],    
-- q.[Gross],    
-- q.[ASTATUS],    
-- q.[ATYPE],    
-- q.[SDate],    
-- q.[EDate],    
-- q.RYear,    
-- q.ValueID,     
-- q.ValueDesc,    
-- a.valueid1, a.valuedesc1,    
-- a.valueid2, a.valuedesc2,    
-- a.valueid3, a.valuedesc3,    
-- a.valueid4, a.valuedesc4,    
-- a.valueid5, a.valuedesc5,    
-- a.valueid6, a.valuedesc6,    
-- a.valueid7, a.valuedesc7,    
-- a.valueid8, a.valuedesc8,    
-- a.valueid9, a.valuedesc9,    
-- a.valueid10, a.valuedesc10,    
-- a.valueid11, a.valuedesc11,    
-- a.valueid12, a.valuedesc12,    
-- a.valueid13, a.valuedesc13,    
-- a.valueid14, a.valuedesc14,    
-- a.VALUEID15 , a.VALUEDESC15    
--FROM ListDet05_a (@P_ANO, @Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18,@Value19, @Value20, @Value21, @Value22) as q, ainfo as a    
--Where q.ANO = a.ANO    
--)    

--GO

  
ALTER function ListDet05_a (@P_ANO as integer,   
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),   
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),  
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),  
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255)  
)        
RETURNS Table      
AS RETURN      
(      
 SELECT Cast(0 as bit) as ProcessFlag,      
 Acceptance.CertificateNo,      
 Acceptance.ESeqNo,      
 Acceptance.AName,      
 Acceptance.ANO,      
 Acceptance.REGNO,      
 Acceptance.ADATE,      
 Acceptance.LUSERID as UserID,      
 SysTab.Currency,      
 QPCalc.TSI,      
 QPCalc.OurShare,      
 QPCalc.Gross,      
 Acceptance.ASTATUS,      
 Acceptance.ATYPE,      
 Acceptance.SDate,      
 Acceptance.EDate,      
 Year(Acceptance.SDate) AS RYear,      
 Acceptance.ValueID,      
 Acceptance.ValueDesc      
From      
 Acceptance,      
 Cover,      
 SysTab,      
 QMasterAcceptance_PCalc() AS QPCalc,      
 Profile      
Where      
 cover.CNO = acceptance.CNO      
 And QPCalc.ANO=Acceptance.ANO      
 And Acceptance.ANO<>Acceptance.LANO      
 And Acceptance.LANO=@P_ANO      
 And Cover.PHOLDER=Profile.ID      
 And ((Cover.Insured Like @Value1 Or Cover.Insured is null) or (Acceptance.AName Like @Value1 Or Acceptance.AName is null))      
 And (Cover.CoverNo Like @Value2 Or Cover.CoverNo is null)      
 and (Cover.CoverDate = @Value3 Or Cover.CoverDate is null or @Value7 = '')      
 And (Cover.ExpDate = @Value4 Or Cover.ExpDate is null or @Value7 = '')      
 And (Acceptance.PolicyNo Like @Value5 Or Acceptance.PolicyNo is null)      
 And (Acceptance.CertificateNo Like @Value6 Or Acceptance.CertificateNo is null)      
 And (Acceptance.PolicyDate = @Value7 Or Acceptance.PolicyDate is null or @Value7 = '' or Acceptance.PolicyDate Between @Value7 and @Value16)      
 And (Acceptance.RegDate = @Value17 Or Acceptance.RegDate is null or @Value17 = '' or Acceptance.RegDate Between @Value17 and @Value18)      
 And Acceptance.AType Like @Value8      
 And Acceptance.AStatus Like @Value9      
 And Acceptance.RegNo Like @Value10      
 And Profile.Name Like @Value11     
 and cover.toc like @Value12      
 and (acceptance.refno like @Value13 or acceptance.refno is null)      
 and (Acceptance.Matters=@Value14 or @Value14='')      
 And Cover.ISType<>'T'      
 And (@Value15='%' or @Value15='' or 1 in (SELECT top 1 1 from Service Where ((Service.ANO=Acceptance.pANO and Service.ANO<>-1) or Service.ANO=Acceptance.ANO) and SStatus<>'R' and ServiceNo Like @Value15))      
 And (Acceptance.BatchNo Like @Value19 or (Acceptance.BatchNo is null and @Value19='%'))   
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')  
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')  
)      

GO


Drop Procedure View16L
GO
CREATE Procedure View16L(@P_ANO integer)  
as  
SELECT ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO,ACCEPTANCE.ADATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, AccAss.CURRENCY_OC,   
sum(case accass.code  
when 'P' then accass.amount_oc  
else 0 end) as Premium,  
sum(case accass.code  
when 'A' then accass.amount_oc  
else 0 end) as Claim,  
sum(case accass.code  
when 'C' then accass.amount_oc  
else 0 end) as Commission,  
sum(case accass.code  
when 'F' then accass.amount_oc  
else 0 end) as Fee  
FROM ACCEPTANCE Left Join AccAss on (AccAss.ANO=Acceptance.ANO)
WHERE Acceptance.LANO=@P_ANO 
GROUP BY ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO,ACCEPTANCE.ADATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, AccAss.CURRENCY_OC  
  
GO


ALTER FUNCTION List10_Det (@P_ANO as integer)        
RETURNS Table        
AS RETURN(        
                
SELECT Cast(0 as bit) as ProcessFlag,        
 ACCEPTANCE.CNO,ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.ADATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, ACCEPTANCE.BACKDATEDF, AccAss.CURRENCY_OC,           
 sum(case accass.code+accass.type        
 when 'PIT' then accass.amount_oc        
 when 'PIX' then accass.amount_oc        
 else 0 end) as Premium,        
        
 sum(case accass.code+accass.type        
 when 'UIT' then accass.amount_oc        
 when 'UIX' then accass.amount_oc        
 else 0 end) as UjrohCedant,     
         
 sum(case accass.code+accass.type        
 when 'AIT' then accass.amount_oc        
 when 'AIX' then accass.amount_oc        
 else 0 end) as Claim,        

 sum(case accass.code+accass.type        
 when 'RIT' then accass.amount_oc        
 when 'RIX' then accass.amount_oc        
 else 0 end) as Subrogation,        
        
 sum(case accass.code+accass.type        
 when 'CIT' then accass.amount_oc        
 when 'CIX' then accass.amount_oc        
 else 0 end) as Commission,        
        
 sum(case accass.code+accass.type        
 when 'FIT' then accass.amount_oc        
 when 'FIX' then accass.amount_oc        
 else 0 end) as Fee,        
        
 sum(case accass.code+accass.type        
 when 'TIT' then accass.amount_oc        
 when 'TIX' then accass.amount_oc        
 else 0 end) as Tax,        
        
 sum(case accass.code+accass.type        
 when 'CBO' then accass.amount_oc        
 when 'OIT' then accass.amount_oc        
 when 'OIX' then accass.amount_oc        
 else 0 end) as Other,                   
        
 sum(case accass.code+accass.type        
 when 'DIT' then accass.amount_oc        
 when 'DIX' then accass.amount_oc        
 else 0 end) as Fund,        
 Max(PCalc.TSI) as TSI,         
AccAss.Currency          
FROM ACCEPTANCE  
Inner Join RARRHEADER on (RArrHeader.ANO=Acceptance.ANO)  
Left Join PCalc on (PCalc.ANO=Acceptance.ANO)  
Left Join AccAss on (AccAss.ANO=Acceptance.ANO)  
WHERE Acceptance.LANO=@P_ANO            
GROUP BY ACCEPTANCE.ANO, ACCEPTANCE.CNO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.ADATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, ACCEPTANCE.BACKDATEDF, AccAss.CURRENCY_OC, AccAss.CURRENCY        
)          

GO

  
  

  
Alter procedure SchemeList(@p_SchemeNo varchar(10),@P_PolicyNo varchar(20), @P_Branch varchar(20), @p_SDate smalldatetime,@p_EDate smalldatetime, @P_Status as varchar(10),@P_UserID as varchar(10), @P_BatchNoF as varchar(10)='', @P_BatchNoL as varchar(10)='')            
as            
                
select  s.*, PCalc.Gross, c.insured, sm.description            
From            
 scheme_transaction as s  
 Left join PCalc on (PCalc.ANO=S.ANO)   
 Inner join Acceptance as a on (A.ANO=S.LANO and A.ANO=A.LANO and A.AStatus<>'W')       
 Inner join Cover as C on (C.CNO=A.CNO)  
 Inner join scheme_master As sm on (sm.SchemeNo=S.SchemeNo)  
Where            
 sm.schemeno Like @p_SchemeNo+'%'     
 and a.PolicyNo Like @P_PolicyNo+'%' and a.Branch like @P_Branch+'%'     
 and s.trdate >=@p_SDate and s.trDate<=@p_EDate     
 and (s.Status=@P_Status or @P_Status='') and (s.LUserID=@P_UserID or @P_UserID='')     
 and (@P_BatchNoF='' or s.BatchNo>=@P_BatchNoF)
 and (@P_BatchNoL='' or s.BatchNo<=@P_BatchNoL)
order by s.TrNo              

GO


  
--2 April 2013

Alter PROCEDURE QBSType(@PANO as integer=0)   
AS  
SELECT B.*  
FROM BSType B
Left Join Acceptance A on (A.ANO=@PANO)
Left Join Cover C on (C.CNO=A.CNO)
Left Join TOC on (TOC.TOC=C.TOC)
Where (coalesce(TOC.CommPoolBSF,0)=1 or B.BSType<>'C')

GO


DROP FUNCTION List10_Det 
GO
CREATE FUNCTION List10_Det (@P_ANO as integer)            
RETURNS Table            
AS RETURN(            
                    
SELECT Cast(0 as bit) as ProcessFlag,            
 ACCEPTANCE.CNO,ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.ADATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, ACCEPTANCE.BACKDATEDF, AccAss.CURRENCY_OC,               
 sum(case accass.code+accass.type            
 when 'PIT' then accass.amount_oc            
 when 'PIX' then accass.amount_oc            
 else 0 end) as Premium,            
            
 sum(case accass.code+accass.type            
 when 'UIT' then accass.amount_oc            
 when 'UIX' then accass.amount_oc            
 else 0 end) as UjrohCedant,         
             
 sum(case accass.code+accass.type            
 when 'AIT' then accass.amount_oc            
 when 'AIX' then accass.amount_oc            
 else 0 end) as Claim,            
    
 sum(case accass.code+accass.type            
 when 'RIT' then accass.amount_oc            
 when 'RIX' then accass.amount_oc            
 else 0 end) as Subrogation,            
            
 sum(case accass.code+accass.type            
 when 'CIT' then accass.amount_oc            
 when 'CIX' then accass.amount_oc            
 else 0 end) as Commission,            
            
 sum(case accass.code+accass.type            
 when 'FIT' then accass.amount_oc            
 when 'FIX' then accass.amount_oc            
 else 0 end) as Fee,            
            
 sum(case accass.code+accass.type            
 when 'TIT' then accass.amount_oc            
 when 'TIX' then accass.amount_oc            
 else 0 end) as Tax,            
            
 sum(case accass.code+accass.type            
 when 'CBO' then accass.amount_oc            
 when 'OIT' then accass.amount_oc            
 when 'OIX' then accass.amount_oc            
 else 0 end) as Other,                       
            
 sum(case accass.code+accass.type            
 when 'DIT' then accass.amount_oc            
 when 'DIX' then accass.amount_oc            
 else 0 end) as Fund,            
 Max(PCalc.TSI) as TSI,             
AccAss.Currency              
FROM ACCEPTANCE With (Index (I_ACCEPTANCE_LANO))     
Left Join AccAss with (Index (I_ACCASS_ANO)) on (AccAss.ANO=Acceptance.ANO)     
Left Join PCalc with (index(I_PCalc)) on (PCalc.ANO=Acceptance.ANO and PCalc.Currency=AccAss.Currency)       
WHERE Acceptance.LANO=@P_ANO                
GROUP BY ACCEPTANCE.ANO, ACCEPTANCE.CNO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.ADATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, ACCEPTANCE.BACKDATEDF, AccAss.CURRENCY_OC, AccAss.CURRENCY            
) 

GO

Drop Function FL_SR_TOC
GO

Create function FL_SR_TOC(@P_USERID varchar(10), @P_TOC varchar(10),@P_PolicyType varchar(10))  
RETURNS Table  
AS RETURN  
(
Select distinct TOC.TOC,TOC.Description From TOC, PTClass, SysUserTOC S Where TOC.AllowedF=1 and S.ID=@P_USERID and S.TOC=TOC.TOC and PTClass.COB=TOC.COB and PTClass.PolicyType like @P_PolicyType+'%' and TOC.TOC like @P_TOC+'%'
)

GO

Drop Function FL_CL_TOC
GO

Create function FL_CL_TOC(@P_USERID varchar(10), @P_TOC varchar(10))    
RETURNS Table    
AS RETURN    
(  
Select distinct TOC.TOC,TOC.Description From TOC, SysUserTOC S 
Where S.TOC=TOC.TOC And TOC.AllowedF=1 And S.ID=@P_USERID and TOC.TOC like @P_TOC+'%'  
) 

GO

Drop Function FL_CL_COLTAB
GO
    
Create Function FL_CL_COLTAB (@P_COL as varchar(10), @P_PolicyNo as varchar(20), @P_CERTIFICATENO AS varchar(20))    
Returns Table  
As Return  
(  
SELECT COLTAB.COL, COLTAB.description    
From Acceptance, RCALC, COL, COLTAB    
WHERE ACCEPTANCE.ANO=RCalc.ANO And RCalc.TOR=COL.TOR AND COLTAB.COL=COL.COL AND    
ACCEPTANCE.POLICYNO=@P_POLICYNO And ACCEPTANCE.CERTIFICATENO=@P_CERTIFICATENO And COL.COL LIKE @P_COL+'%'   
)
GO

        
Drop Function FL_SR_SchemeNo
GO

Create function FL_SR_SchemeNo( @P_SchemeNo varchar(10),@P_PolicyNo varchar(10))  
RETURNS Table  
AS RETURN  
(

Select Distinct S.SchemeNo, S.Description, S.Disc from acceptance as a, cover as c, Scheme_Master S where S.TOC=C.TOC and S.SchemeNo Like @P_SchemeNo+'%' and a.cno=c.cno and a.ano = a.lano and c.openflag=1 and A.AType not in ('A','C') and a.astatus = 'I' and a.PolicyNo Like @P_PolicyNo+'%' and a.ano not in (Select PANO from Acceptance Where Acceptance.PANO=a.ANO)
)
GO

Drop Function FL_CL_SAL
GO

Create Function FL_CL_SAL (@P_CNO AS INTEGER, @P_INO AS INTEGER, @P_ITEM AS VARCHAR(255))     
Returns Table
As Return (
SELECT ITEM, DESCRIPTION, QTY, AMOUNT    
FROM CLSALITEM    
WHERE STATUS='A' AND CNO=@P_CNO And INO=@P_INO And ITEM Like @P_ITEM + '%'
)
GO

  
drop function FL_UserTopro

go

CREATE function FL_UserTopro(@P_USERID varchar(10), @P_TOPRO varchar(10),@P_TOC varchar(10),@P_SEGMENT varchar(10))    
RETURNS Table      
AS RETURN      
(    
SELECT Distinct TOPRO.TOPRO, TOPRO.Description, TOPRO.TOC, TOPRO.Expiry, TOPRO.CustomizableF, TOPRO.IncludeExtCoverF        
from TOPRO Left Join TOP_Segment on (TOP_Segment.TOPRO=TOPRO.TOPRO)           
Where TOPRO.TOPRO Like @P_TOPRO+'%' and TOPRO.TOC Like @P_TOC+'%' and TOPRO.AllowedF=1           
and (TOPRO.SegmentF=0 or TOP_Segment.Segment like @P_SEGMENT)   
) 

GO

Drop function FL_SR_CertificateNo
GO

Create function FL_SR_CertificateNo(@P_USERID varchar(10), @P_PolicyNo varchar(20),@P_CertificateNo varchar(10))    
RETURNS Table    
AS RETURN    
(Select A.CertificateNo, A.AName, A.SDate, A.EDate
from Acceptance A Inner Join Cover C on (C.CNO=A.CNO)
Where (A.LANO<>-1 or A.LANO<>A.ANO) and A.ATYPE Not In ('A','C') And A.ASTATUS<>'W' and C.Cstatus<>'C' And A.PDATE<>A.PPDATE 
and A.PolicyNo=@P_PolicyNo and A.CertificateNo Like @P_CertificateNo+'%'
and A.Branch in (Select S.Branch from SysUserBranch S Where S.ID=@P_UserID)
and C.TOC in (Select S.TOC from SysUserTOC S Where S.ID=@P_UserID)
)     

GO   

Drop function FL_UserRateCode

GO

Create function FL_UserRateCode(@P_USERID varchar(10), @P_CODE varchar(10),@P_TOPRO varchar(10))
RETURNS Table  
AS RETURN  
(
Select R.Code, R.Description
from RateTab R, TOP_Rate T
Where R.Code=T.Code and R.Code Like @P_CODE+'%' and T.TOPRO=@P_TOPRO
)

GO

DROP Function FL_CLFACDED
GO

Create Function FL_CLFACDED (@P_CNO as Integer, @P_FID as VARCHAR(20))    
Returns Table  
As Return (  
	SELECT *  
	FROM  CLFACDED  
	WHERE CNO=@P_CNO AND FID=@P_FID
 )  

GO

DROP FUNCTION FL_FACDED
GO

CREATE FUNCTION FL_FACDED (@P_ANO as integer, @P_FID as varchar(20), @P_DCODE as varchar(255))     
RETURNS TABLE  
AS RETURN (  
SELECT DISTINCT DEDTAB.*    
FROM RCOVER, RATECOV, DEDTAB, RARRDET    
WHERE RARRDET.ANO=@P_ANO and RARRDET.FID=@P_FID and RARRDET.FULLCOVERF=1     
AND RATECOV.CODE=RCOVER.CODE And DEDTAB.TOR=RATECOV.TOR And RCOVER.ANO=@P_ANO AND DEDTAB.DCODE LIKE @P_DCODE+'%'    
    
    
UNION ALL    
    
    
SELECT DISTINCT DEDTAB.*    
FROM RATECOV, DEDTAB, RARRDET, FPARTDET    
WHERE RARRDET.ANO=@P_ANO and RARRDET.FID=@P_FID and RARRDET.FULLCOVERF=0     
AND FPARTDET.ANO=@P_ANO AND FPARTDET.FID=@P_FID AND FPARTDET.CODE=RATECOV.CODE AND DEDTAB.TOR=RATECOV.TOR AND DEDTAB.DCODE LIKE @P_DCODE+'%'  
)     


GO

drop function FL_SchemePolicy

go

CREATE function FL_SchemePolicy(@P_SchemeNo varchar(10), @P_PolicyNo varchar(10))            
RETURNS Table              
AS RETURN              
(            

Select Distinct a.PolicyNo, a.AName as Insured, a.LANO, a.CNO, a.AID from acceptance as a, cover as c, Scheme_Master S where S.TOC=C.TOC and S.SchemeNo Like @P_SchemeNo+'%' and a.cno=c.cno and a.ano = a.lano and c.openflag=1 and A.AType not in ('A','C') and a.astatus = 'I' and a.PolicyNo like @P_PolicyNo+'%' and a.ano not in (Select PANO from Acceptance Where Acceptance.PANO=a.ANO)
)

GO
   

DROP function FL_SR_PolicyNo
GO  
CREATE function FL_SR_PolicyNo(@P_USERID varchar(10), @P_PolicyNo varchar(20))      
RETURNS Table      
AS RETURN      
(Select A.PolicyNo, A.AName, A.SDate, A.EDate ,A.CertificateNo   
from Acceptance A Inner Join Cover C on (C.CNO=A.CNO)    
Where (A.LANO=-1 or A.LANO=A.ANO) and A.ATYPE Not In ('A','C') 
And A.ASTATUS<>'W' and C.CStatus<>'C' And A.PDATE<>A.PPDATE
And C.ASource='UW'     
and A.PolicyNo Like @P_PolicyNo+'%'    
and A.Branch in (Select S.Branch from SysUserBranch S Where S.ID=@P_UserID)    
and C.TOC in (Select S.TOC from SysUserTOC S Where S.ID=@P_UserID)    
)    

GO
DROP FUNCTION FL_CL_KOL
go  
CREATE FUNCTION FL_CL_KOL(@P_CNO as Int, @P_INO AS Int, @P_KOL AS VARCHAR(10))       
RETURNS TABLE  
AS RETURN (  
      
SELECT KOL.KOL, KOL.DESCRIPTION, KOLVALUE.COST, KOL.VATF, KOL.TAXF, KOL.CATEGORY      
FROM KOL, KOLVALUE, CLInfo, ICover    
WHERE ICover.INO=CLInfo.INO and CLINFO.CNO=@P_CNO and CLINFO.INO=@P_INO and (KOL.KOL LIKE @P_KOL or KOL.DESCRIPTION LIKE @P_KOL) And KOLVALUE.KOL=KOL.KOL And KOL.TOI=ICOVER.TOI     
And ((KOLVALUE.ValueID1)='' Or KOLVALUE.ValueID1 Is Null Or (CLINFO.ValueID1)=(KOLVALUE.ValueID1))     
And ((KOLVALUE.ValueID2)='' Or KOLVALUE.ValueID2 Is Null Or (CLINFO.ValueID2)=(KOLVALUE.ValueID2))     
And ((KOLVALUE.ValueID3)='' Or KOLVALUE.ValueID3 Is Null Or (CLINFO.ValueID3)=(KOLVALUE.ValueID3))     
And ((KOLVALUE.ValueID4)='' Or KOLVALUE.ValueID4 Is Null Or (CLINFO.ValueID4)=(KOLVALUE.ValueID4))     
And ((KOLVALUE.ValueID5)='' Or KOLVALUE.ValueID5 Is Null Or (CLINFO.ValueID5)=(KOLVALUE.ValueID5))     
And ((KOLVALUE.ValueID6)='' Or KOLVALUE.ValueID6 Is Null Or (CLINFO.ValueID6)=(KOLVALUE.ValueID6))     
And ((KOLVALUE.ValueID7)='' Or KOLVALUE.ValueID7 Is Null Or (CLINFO.ValueID7)=(KOLVALUE.ValueID7))     
And ((KOLVALUE.ValueID8)='' Or KOLVALUE.ValueID8 Is Null Or (CLINFO.ValueID8)=(KOLVALUE.ValueID8))     
And ((KOLVALUE.ValueID9)='' Or KOLVALUE.ValueID9 Is Null Or (CLINFO.ValueID9)=(KOLVALUE.ValueID9))     
And KOL.ALLOWEDF=1
      
UNION       
      
SELECT KOL.KOL, KOL.DESCRIPTION, 0 as COST, KOL.VATF, KOL.TAXF, KOL.CATEGORY      
FROM KOL, ICover    
WHERE ICover.INO=@P_INO and (KOL.KOL LIKE @P_KOL or KOL.DESCRIPTION LIKE @P_KOL) AND KOL.TOI=ICOVER.TOI AND KOL.KOL NOT IN     
(SELECT KOLVALUE.KOL FROM KOLVALUE, CLInfo WHERE KOLVALUE.KOL=KOL.KOL AND CLInfo.CNO=@P_CNO and CLInfo.INO=@P_INO     
And ((KOLVALUE.ValueID1)='' Or KOLVALUE.ValueID1 Is Null Or (CLINFO.ValueID1)=(KOLVALUE.ValueID1))     
And ((KOLVALUE.ValueID2)='' Or KOLVALUE.ValueID2 Is Null Or (CLINFO.ValueID2)=(KOLVALUE.ValueID2))     
And ((KOLVALUE.ValueID3)='' Or KOLVALUE.ValueID3 Is Null Or (CLINFO.ValueID3)=(KOLVALUE.ValueID3))     
And ((KOLVALUE.ValueID4)='' Or KOLVALUE.ValueID4 Is Null Or (CLINFO.ValueID4)=(KOLVALUE.ValueID4))     
And ((KOLVALUE.ValueID5)='' Or KOLVALUE.ValueID5 Is Null Or (CLINFO.ValueID5)=(KOLVALUE.ValueID5))     
And ((KOLVALUE.ValueID6)='' Or KOLVALUE.ValueID6 Is Null Or (CLINFO.ValueID6)=(KOLVALUE.ValueID6))     
And ((KOLVALUE.ValueID7)='' Or KOLVALUE.ValueID7 Is Null Or (CLINFO.ValueID7)=(KOLVALUE.ValueID7))     
And ((KOLVALUE.ValueID8)='' Or KOLVALUE.ValueID8 Is Null Or (CLINFO.ValueID8)=(KOLVALUE.ValueID8))     
And ((KOLVALUE.ValueID9)='' Or KOLVALUE.ValueID9 Is Null Or (CLINFO.ValueID9)=(KOLVALUE.ValueID9)))    
And KOL.AllowedF=1    
)  

GO

Drop Function FL_RateCode

GO
CREATE Function FL_RateCode (@P_ANO as integer, @P_Code as varchar(10),@P_AllowedF as bit=0, @P_TSI as float=0)      
RETURNS Table      
AS RETURN      
(    
SELECT  RateTab.Code, RateTab.AllowedF, RateTab.NoRefundF,    
 max(RateTab.Description) as Description,    
 max(RateTab.Unit) as Unit,    
 max(RClass.Category) AS Category,    
 case when max(F.Rate)<>0 then max(F.Rate) else sum(RateTab.Rate*RateCov.Portion/100) end AS Rate,    
 case when max(F.MinRate)<>0 then max(F.MinRate) else sum(RateTab.MinRate*RateCov.Portion/100) end AS MinRate,    
 max(F.PML) as PML,    
 sum(RateCov.Portion) AS Portion,    
 MAX(F.Loading) As Loading    
FROM  RateTab Left Join fn_RateCon(@P_ANO,@P_Code,@P_TSI) F on (F.Code=RateTab.Code), RateCov, RClass, Cover, Acceptance    
WHERE  Acceptance.ANO=@P_ANO    
 And (RateTab.Code Like @P_Code OR RateTab.Description Like @P_Code)    
 And RateTab.Code=RateCov.Code    
 And (RateTab.AllowedF=@P_AllowedF or @P_AllowedF=0)    
 And Cover.CNO=Acceptance.CNO    
 And RClass.TOC=Cover.TOC    
 And RClass.TOR=RateCov.TOR    
 And ((Cover.TOC Like RateTab.TOC+'%') or (ratetab.toc is null))    
 And (Case When F.Code is null then 1 else F.AllowedF end)=1    
 And RateTab.Code in (Select Code from TOP_RATE where Acceptance.Topro = TOP_RATE.Topro )
GROUP BY RateTab.Code, RateTab.AllowedF, RateTab.NoRefundF    

)  

GO

DROP FUNCTION FL_UW_TOI
GO
CREATE FUNCTION FL_UW_TOI(@P_ANO as integer, @P_TOI as varchar(255))

RETURNS TABLE

As Return (

SELECT DISTINCT TOI.TOI,TOI.DESCRIPTION, TOI.ADJUSTABLE, TOI.DISPMODEL, PCLASS.CATEGORY, PCLASS.LIMIT

From TOI, PCLASS, RCOVER, RATECOV

WHERE RCOVER.ANO=@P_ANO

And RATECOV.CODE=RCOVER.CODE And PCLASS.TOR=RATECOV.TOR

And TOI.TOI=PCLASS.TOI And TOI.ALLOWEDF=1 AND (TOI.TOI Like @P_TOI OR TOI.DESCRIPTION Like @P_TOI+'%')

AND (Select round(sum(R.Portion),2) from RATECOV R Where R.CODE=RATECOV.CODE AND R.TOR IN (Select TOR FROM PCLASS P Where P.TOI=TOI.TOI)) in (0,100)

)

go

Drop Function FL_RateCode_1 

GO

CREATE Function FL_RateCode_1 (@P_ANO as integer, @P_Code as varchar(10),@P_AllowedF as bit=0, @P_TSI as float=0)        
RETURNS Table        
AS RETURN        
(      
SELECT  RateTab.Code, RateTab.AllowedF, RateTab.NoRefundF,    
 max(RateTab.Description) as Description,    
 max(RateTab.Unit) as Unit,    
 max(RClass.Category) AS Category,    
 case when max(F.Rate)<>0 then max(F.Rate) else sum(RateTab.Rate*RateCov.Portion/100) end AS Rate,    
 case when max(F.MinRate)<>0 then max(F.MinRate) else sum(RateTab.MinRate*RateCov.Portion/100) end AS MinRate,    
 max(F.PML) as PML,    
 sum(RateCov.Portion) AS Portion,    
 MAX(F.Loading) As Loading    
FROM  RateTab Left Join fn_RateCon(@P_ANO,@P_Code,@P_TSI) F on (F.Code=RateTab.Code), RateCov, RClass, Cover, Acceptance    
WHERE  Acceptance.ANO=@P_ANO    
 And (RateTab.Code Like @P_Code OR RateTab.Description Like @P_Code)    
 And RateTab.Code=RateCov.Code    
 And (RateTab.AllowedF=@P_AllowedF or @P_AllowedF=0)    
 And Cover.CNO=Acceptance.CNO    
 And RClass.TOC=Cover.TOC    
 And RClass.TOR=RateCov.TOR    
 And ((Cover.TOC Like RateTab.TOC+'%') or (ratetab.toc is null))    
 And (Case When F.Code is null then 1 else F.AllowedF end)=1    
GROUP BY RateTab.Code, RateTab.AllowedF, RateTab.NoRefundF
)    


GO    

Drop Function FL_UserRateCode_1
GO

Create function FL_UserRateCode_1(@P_USERID varchar(10), @P_CODE varchar(10),@P_TOC varchar(10))
RETURNS Table
AS RETURN
(
Select Distinct R1.Code, R1.Description From RateTab R1, RateCov R2, RClass R3 Where R3.TOR=R2.TOR and R1.Code=R2.Code and R1.AllowedF=1 and R3.TOC like @P_TOC+'%' and R1.Code Like @P_CODE+'%'
)

GO

Drop function FL_UserBranch_LIKE
                
GO 

Create function FL_UserBranch_LIKE(@P_USERID varchar(10), @P_Branch varchar(10))
RETURNS Table  
AS RETURN  
(
SELECT Branch.Branch, Branch.Name 
from Branch
Where Branch.Branch Like @P_Branch+'%' and Branch.Op_Flag=1 and Branch.Active_Flag=1
and Branch.Branch in (Select S.Branch from SysUserBranch S Where S.ID=@P_UserID)
)

GO

DROP FUNCTION FL_BankBranch
GO

CREATE function FL_BankBranch(@P_Bank varchar(10))      
RETURNS Table        
AS RETURN        
(      
Select A.BankBranch, B.Description +' '+ A.BankBranch as Description , A.BankCity, A.BICode, A.BankCode, A.Area, A.Address_1, A.Address_2, A.Address_3 from BankBranch A, Bank B where A.Bank = B.Bank and A.AllowedF=1 and A.Bank=@P_Bank
)

GO


Drop FUNCTION FL_CL_POLICYNO
GO
CREATE FUNCTION FL_CL_POLICYNO(@P_USERID varchar(10), @P_PolicyNo varchar(20))                    
RETURNS TABLE                    
AS RETURN                    
(Select A.PolicyNo, A.CertificateNo, A.AName, A.SDate, A.EDate, A.PDate, A.PPDate, A.NCDate, A.ExtPeriod               
from Acceptance A Inner Join Cover C on (C.CNO=A.CNO)                
Where A.ATYPE Not In ('A','C') And A.ASTATUS Not in ('W','T') and C.CStatus<>'C'           
And A.PDATE<>A.PPDATE And A.ANO<>A.LANO          
And (C.ASource='UW' or (C.CSTATUS='A' and C.ASource<>'UW'))    
and A.PolicyNo Like @P_PolicyNo+'%'                
and A.Branch in (Select S.Branch from SysUserBranch S Where S.ID=@P_UserID)                
and C.TOC in (Select S.TOC from SysUserTOC S Where S.ID=@P_UserID)                
)   
GO

Drop FUNCTION FL_CL_CERTIFICATENO
GO
CREATE FUNCTION FL_CL_CERTIFICATENO(@P_USERID varchar(10), @P_PolicyNo varchar(20),@P_CertificateNo varchar(10))          
RETURNS TABLE          
AS RETURN          
(Select A.CertificateNo, A.AName, A.SDate, A.EDate, A.PDate, A.PPDate, A.NCDate, A.ExtPeriod          
from Acceptance A Inner Join Cover C on (C.CNO=A.CNO)        
Where A.ATYPE Not In ('A','C') And A.ASTATUS NOT IN ('W','T') And C.CStatus<>'C' And A.PDATE<>A.PPDATE And A.ANO<>A.LANO          
and A.PolicyNo=@P_PolicyNo and A.CertificateNo Like @P_CertificateNo+'%'        
and A.Branch in (Select S.Branch from SysUserBranch S Where S.ID=@P_UserID)        
and C.TOC in (Select S.TOC from SysUserTOC S Where S.ID=@P_UserID)        
)     
GO

DROP FUNCTION FL_CLACC_4
GO

CREATE FUNCTION FL_CLACC_4 (@P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO AS VARCHAR(255), @P_DATE AS SMALLDATETIME)      
RETURNS TABLE    
AS RETURN    
(    
SELECT top 100 Acceptance.ANO, AName, AType, AStatus, PDate as 'Effective Date', PPDate as 'Expiry Date'    
From ACCEPTANCE
WHERE ACCEPTANCE.AType Not in ('A','C') AND ACCEPTANCE.AStatus not in ('W','T') AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO      
AND ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO      
AND ACCEPTANCE.PDate<=@P_Date      
AND ((ExclusiveF=0 AND @P_Date<=dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCEPTANCE.PPDate)) or (ExclusiveF=1 AND @P_Date<dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCEPTANCE.PPDate)))      
AND ACCEPTANCE.NCDate<=@P_Date      
Order By ACCEPTANCE.ANO Desc          
)  

GO
DROP Function FL_REINSURANCE_CESSION 
GO
CREATE Function FL_REINSURANCE_CESSION (@P_ANO integer, @P_ADate smalldatetime, @P_RType varchar(255), @P_TSI Float=0, @P_RID varchar(20)='', @P_ManualF Bit=0)          
Returns Table    
As Return    
(    
SELECT Distinct (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType,                  
ReClass.PLimit,    
Case RECLASS.Limit                  
 WHEN 0 then Reinsurance.Limit                  
 Else RECLASS.Limit                  
end as limit, ReClass.MinTSI, Reinsurance.Share, Reinsurance.PShare, Acceptance.FLDID, Acceptance.ValueID, ReClass.CessionF, ReClass.AssessmentF, ReClass.DirectF                  
From REINSURANCE, RECLASS, cover, acceptance, RArrHeader        
WHERE Reinsurance.RType=@P_RType And Reinsurance.RNO=ReClass.RNo And ReClass.TOC=COVER.TOC And COVER.CNO=ACCEPTANCE.CNO And ACCEPTANCE.ANO=@P_ANO         
And RArrHeader.ANO=Acceptance.ANO        
And Reinsurance.SDate<=@P_ADATE And Reinsurance.EDate>=@P_ADATE  And Reinsurance.Category<>'P'                  
And (@P_RID='' or Reinsurance.RID=@P_RID or RArrHeader.ManualF=0)              
And (@P_ManualF=1 or RArrHeader.ManualF=1 or ((@P_TSI>=ReClass.MinTSI or ReClass.MinTSI=0) and (@P_TSI<=ReClass.MaxTSI or ReClass.MaxTSI=0) 
       
And ((datediff(month, acceptance.sdate, acceptance.edate)>ReClass.MinPeriod) or (datediff(month, acceptance.sdate, acceptance.edate)=ReClass.MinPeriod and day(acceptance.sdate)<=day(acceptance.edate)) or ReClass.MinPeriod=0)                 
And ((datediff(month, acceptance.sdate, acceptance.edate)<ReClass.MaxPeriod) or (datediff(month, acceptance.sdate, acceptance.edate)=ReClass.MaxPeriod and day(acceptance.sdate)>=day(acceptance.edate)) or ReClass.MaxPeriod=0)))      
                
                              
Union All                  
                              
SELECT Distinct (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType,                  
ReClass.PLimit,    
Case RECLASS.Limit                  
 WHEN 0 then Reinsurance.Limit                  
 Else RECLASS.Limit                  
end as limit, ReClass.MinTSI, Reinsurance.Share, Reinsurance.PShare, Acceptance.FLDID, Acceptance.ValueID, ReClass.CessionF, ReClass.AssessmentF, ReClass.DirectF                  
From REINSURANCE, RECLASS, cover, acceptance, RArrHeader, RePolicy                  
WHERE Reinsurance.RType=@P_RType And Reinsurance.RNO=ReClass.RNo And ReClass.TOC=COVER.TOC And COVER.CNO=ACCEPTANCE.CNO And RArrHeader.ANO=Acceptance.ANO And ACCEPTANCE.ANO=@P_ANO And Reinsurance.SDate<=@P_ADATE And Reinsurance.EDate>=@P_ADATE  And Reinsurance.Category='P'                  
And RePolicy.RNO=Reinsurance.RNO and RePolicy.ID=Cover.PHolder                  
And (@P_RID='' or Reinsurance.RID=@P_RID or RArrHeader.ManualF=0)              
And (@P_ManualF=1 or RArrHeader.ManualF=1 or ((@P_TSI>=ReClass.MinTSI or ReClass.MinTSI=0) and (@P_TSI<=ReClass.MaxTSI or ReClass.MaxTSI=0) 
       
And ((datediff(month, acceptance.sdate, acceptance.edate)>ReClass.MinPeriod) or (datediff(month, acceptance.sdate, acceptance.edate)=ReClass.MinPeriod and day(acceptance.sdate)<=day(acceptance.edate)) or ReClass.MinPeriod=0)                 
And ((datediff(month, acceptance.sdate, acceptance.edate)<ReClass.MaxPeriod) or (datediff(month, acceptance.sdate, acceptance.edate)=ReClass.MaxPeriod and day(acceptance.sdate)>=day(acceptance.edate)) or ReClass.MaxPeriod=0)))      
          
)            
  
GO

DROP function FL_Claim_Cession
GO
Create Function FL_Claim_Cession (@PCNO as integer, @pLDate as smalldatetime, @pRType as varchar(255))
Returns Table
As Return
(
SELECT DISTINCT (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType, Reinsurance.Category,          
Reinsurance.Share,          
Case When Event.Category='E' and RECLASS.ELIMIT<>0 Then RECLASS.ELIMIT Else (Case WHEN RECLASS.Limit=0 THEN Reinsurance.Limit Else RECLASS.Limit end)End as Limit,          
Case When Event.Category='E' and RECLASS.EExcess<>0 Then RECLASS.EExcess Else (Case WHEN RECLASS.Excess=0 THEN Reinsurance.Excess Else RECLASS.Excess end) End as Excess,          
Reinsurance.ExcessType,      
RECLASS.CessionF , RECLASS.AssessmentF, REINSURANCE.Deductible, REINSURANCE.A_Deductible, REINSURANCE.A_EDeductible, REINSURANCE.Aggregate, REINSURANCE.A_Aggregate, REINSURANCE.A_EAggregate          
FROM Reinsurance, ReClass, Claim Left Join Event On (Event.EventNo=Claim.EventNo), RArrHeader          
WHERE (coalesce(Event.EventNo,'')<>'' or ReClass.EventF=0) and (Event.Category='E' or Reinsurance.Category<>'E') and Claim.CNO=@PCNO And Reinsurance.RTYPE=@pRType          
And RArrHeader.ANO=Claim.ANO and RArrHeader.EXOLF=0          
And Reinsurance.RNO=ReClass.RNo And Reinsurance.SDate<=@pLDate And Reinsurance.EDate>=@pLDate          
And ReClass.TOC=CLAIM.TOC And Reinsurance.Category not in ('P','S')        
                          
Union All          
                          
SELECT DISTINCT (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType, Reinsurance.Category,             
Reinsurance.Share,          
Case When Event.Category='E' and RECLASS.ELIMIT<>0 Then RECLASS.ELIMIT Else (Case WHEN RECLASS.Limit=0 THEN Reinsurance.Limit Else RECLASS.Limit end)End as Limit,          
Case When Event.Category='E' and RECLASS.EExcess<>0 Then RECLASS.EExcess Else (Case WHEN RECLASS.Excess=0 THEN Reinsurance.Excess Else RECLASS.Excess end) End as Excess,          
Reinsurance.ExcessType,      
RECLASS.CessionF , RECLASS.AssessmentF, REINSURANCE.Deductible, REINSURANCE.A_Deductible, REINSURANCE.A_EDeductible, REINSURANCE.Aggregate, REINSURANCE.A_Aggregate, REINSURANCE.A_EAggregate          
FROM Reinsurance, ReClass, Claim Left Join Event On (Event.EventNo=Claim.EventNo), RePolicy, Acceptance, Cover, RArrHeader          
WHERE (coalesce(Event.EventNo,'')<>'' or ReClass.EventF=0) and (Event.Category='E' or Reinsurance.Category<>'E') and Claim.CNO=@PCNO and Acceptance.ANO=Claim.ANO and Cover.CNO=Acceptance.CNO          
And RArrHeader.ANO=Claim.ANO and RArrHeader.EXOLF=0          
And Reinsurance.RTYPE=@pRType And RePolicy.RNO=Reinsurance.RNO and RePolicy.ID=Cover.PHolder          
And Reinsurance.RNO=ReClass.RNo And Reinsurance.SDate<=@pLDate And Reinsurance.EDate>=@pLDate          
And ReClass.TOC=CLAIM.TOC And Reinsurance.Category='P'          
)

GO

Drop Function FL_CL_TOI
GO
Create Function FL_CL_TOI(@PCNO As Integer)    
Returns Table    
As Return    
(    
SELECT Distinct cast(ICOVER.REMARK as varchar(255)) AS REMARK, ICOVER.CURRENCY,        
CASE        
 WHEN CLAIM.EVENTNO=-1 THEN        
        CASE        
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT        
        ELSE ICOVER.AMOUNT*RCOVER.PCTLOSS/100 END        
 Else        
        CASE        
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT_AOE        
        ELSE ICOVER.AMOUNT_AOE*RCOVER.PCTLOSS/100 END        
 END AS SI, ICOVER.INO, ICOVER.TOI, ICOVER.TOTAL, ICOVER.INDEMNITY, TOI.AGREEDVALF        
From ICOVER, CLAIM, Col, ICALC, RCOVER, TOI, ACCEPTANCE        
WHERE CLAIM.CNO=@PCNO AND ICOVER.ANO=CLAIM.ANO AND RCOVER.ANO=CLAIM.ANO AND ACCEPTANCE.ANO=CLAIM.ANO        
AND ICALC.ANO=CLAIM.ANO AND ICOVER.INO=ICALC.INO AND RCOVER.CODE=ICALC.CODE        
AND ((RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND '12:00'<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))       
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND '12:00'>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))      
AND COL.COL=CLAIM.COL AND ICALC.TOR=COL.TOR AND TOI.TOI=ICOVER.TOI                
)   

  
GO
DROP FUNCTION FL_CL_DED
GO

Create Function FL_CL_DED (@P_CNO AS INTEGER)
RETURNS TABLE
AS RETURN
(
SELECT DISTINCT ACCDED.REMARKS, ACCDED.CURRENCY, ACCDED.DCODE, CLAIM.PAYMENT, CLAIM.CNO      
From CLAIM, ACCDED, Col, ACCEPTANCE      
WHERE CLAIM.CNO=@P_CNO   
AND ACCDED.ANO=CLAIM.ANO AND ACCEPTANCE.ANO=ACCDED.ANO      
AND ((ACCDED.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ACCDED.SDATE<CLAIM.LOSSDATE or (ACCDED.SDATE=CLAIM.LOSSDATE AND '12:00'<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))         
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)=CLAIM.LOSSDATE AND '12:00'>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))        
AND COL.COL=CLAIM.COL AND ACCDED.TOR=COL.TOR          
) 
GO


Drop Function FL_CL_Collateral

GO

  

CREATE Function FL_CL_Collateral(@P_CNO integer, @P_Item varchar(255))      

Returns Table      

as Return      

(      

SELECT A1.COLLATERALNO, C1.DESCRIPTION, C1.CURRENCY, A1.NOMINAL        

FROM ACCCOLLATERAL A1, ACCEPTANCE A2, COLLATERAL C1, CLAIM C2      

WHERE A1.ANO=A2.OANO and A2.ANO=C2.ANO and C1.COLLATERALNO=A1.COLLATERALNO      

and C2.CNO=@P_CNO and A1.COLLATERALNO like @P_ITEM+'%'    

)   
go


ALTER PROCEDURE ListDet04 (@P_ANO as integer,@P_FCERTNO as varchar(20), @P_LCERTNO as varchar(20))        
AS        
SELECT Cast(0 as bit) as ProcessFlag,Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross, QPCalc.RYear, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, QPCalc.ValueID, QPCalc.ValueDesc        
FROM Acceptance, Cover, SysTab, qMasterAcceptance_PCalc() AS QPCalc, Acceptance MAcceptance        
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO        
And      
(      
(Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1 And QPCalc.ANO=Acceptance.ANO)    
or (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1 And QPCalc.ANO=Acceptance.ANO)      
or (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1 And QPCalc.ANO=Acceptance.ANO)      
)            
And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo        
Order By Acceptance.CertificateNo  
      
GO  
ALTER PROCEDURE MListDet04(@P_ANO as integer,@P_FCERTNO as varchar(20), @P_LCERTNO as varchar(20))        
AS        
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Acceptance.AName, Acceptance.CertificateNo, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.LANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE,Acceptance.LUSERID as USERID,SysTab.Currency, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Year(RArrheader.Rdate) AS RYear, qPCalc.ValueID, QPCalc.ValueDesc      
FROM Acceptance, Cover, RArrHeader, SysTab, QMasterAcceptance_PCalc() AS QPCalc      
WHERE       
 Cover.CNO=Acceptance.CNO       
 And RArrHeader.ANO=Acceptance.ANO       
 And QPCalc.ANO=Acceptance.ANO       
 And Acceptance.ANO<>Acceptance.LANO       
 And Acceptance.LANO=@P_ANO       
 And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo        
Order By Acceptance.CertificateNo            
        
GO


-- 13 June 2013

DROP FUNCTION FN_ICALC 
GO
Create FUNCTION FN_ICALC (@P_ANO as integer)        
RETURNS Table        
AS RETURN (        
SELECT  ICALC.ANO,        
 Count(Distinct PCalc.Currency) AS NUMCCY,      
 MAX(PCALC.RATE) AS RATE,      
 sum(ICALC.TSI*PCalc.Rate) AS TSI,          
 sum(ICalc.Gross/ICALC.PRORATA/(ICALC.PCTADJ/100)*PCalc.Rate) AS Gross  
FROM  ICALC  
LEFT JOIN PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CURRENCY=ICALC.CURRENCY)  
WHERE ICALC.ANO=@P_ANO AND ICALC.GROSS<>0  
GROUP BY ICALC.ANO  
) 

GO


DROP function [dbo].[ListQry_3_Sub]     
GO    
CREATE function [dbo].[ListQry_3_Sub] (    
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),     
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),    
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),    
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255)    
)          
RETURNS Table          
AS RETURN          
(          
SELECT 
 Cover.COVERNO,          
 Cast(Acceptance.AName as varchar(128)) as Insured,          
 Cover.CNO,          
 Cover.CStatus,          
 Acceptance.lANO,          
 Acceptance.ANO,          
 Acceptance.REGNO,          
 Acceptance.ADATE,          
 Acceptance.LUSERID as USERID,          
 SysTab.Currency,          
 Acceptance.ASTATUS,          
 Acceptance.ATYPE,          
 Acceptance.SDate,          
 Acceptance.EDate,          
 Year(Acceptance.SDate) AS RYear,          
 Cover.ISType,          
 Acceptance.Renewal,          
 Acceptance.ESeqNo,          
 Acceptance.PolicyNo,          
 Acceptance.CertificateNo,          
 Acceptance.RefNo,          
 Cover.ProformaF,          
 Acceptance.ANO as ANO_INFO          
FROM  Cover, Acceptance, Profile, SysTab          
WHERE  Cover.CNO=Acceptance.CNO and          
cover.PHolder = Profile.ID          
 And (Acceptance.AName Like @Value1)         
 And (Cover.CoverNo Like @Value2)          
 And (Cover.CoverDate = @Value3 or @Value3 = '')          
 And (Cover.ExpDate = @Value4 or @Value4 = '')          
 And (Acceptance.PolicyNo Like @Value5)          
 And (Acceptance.CertificateNo Like @Value6)          
 And (Acceptance.PolicyDate = @Value7 or @Value7 = '' or Acceptance.PolicyDate Between @Value7 and @Value16)          
 And (Acceptance.RegDate = @Value17 or @Value17 = '' or Acceptance.RegDate Between @Value17 and @Value18)          
 And Acceptance.AType Like @Value8          
 And Acceptance.AStatus Like @Value9          
 And Acceptance.RegNo Like @Value10           
 And Profile.Name Like @Value11         
 and cover.toc like @Value12          
 and (acceptance.refno like @Value13)          
 and (Acceptance.ano = acceptance.lano or Acceptance.LANO=-1)          
 and (Acceptance.Matters=@Value14 or @Value14='')          
 And (Cover.ISType<>'T' or Cover.ProformaF=1)          
 And (@Value15='%' or @Value15='' or 1 in (SELECT top 1 1 from Service Where ((Service.ANO=Acceptance.pANO and Service.ANO<>-1) or Service.ANO=Acceptance.ANO) and SStatus<>'R' and ServiceNo Like @Value15))          
 And (Acceptance.BatchNo Like @Value19 or (Acceptance.BatchNo is null and @Value19='%'))     
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')    
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')    
    
Union          
    
SELECT 
 Cover.COVERNO,          
 Cast(Acceptance.AName as varchar(128)) as Insured,          
 Cover.CNO,          
 Cover.CStatus,          
 Acceptance.lANO,          
 Acceptance.ANO,          
 Acceptance.REGNO,          
 Acceptance.ADATE,          
 Acceptance.LUSERID as USERID,          
 SysTab.Currency,          
 Acceptance.ASTATUS,          
 Acceptance.ATYPE,          
 Acceptance.SDate,          
 Acceptance.EDate,          
 Year(Acceptance.SDate) AS RYear,          
 Cover.ISType,          
 Acceptance.Renewal,          
 Acceptance.ESeqNo,          
 Acceptance.PolicyNo,          
 Acceptance.CertificateNo,          
 Acceptance.RefNo,          
 Cover.ProformaF,          
 acceptance_detail.ANO as ANO_INFO          
FROM  Cover, Acceptance, Profile, acceptance as acceptance_detail, SysTab         
Where cover.CNO = acceptance.CNO And cover.PHolder = Profile.ID          
 and acceptance.ano = acceptance_detail.lano          
 And (Acceptance_Detail.AName Like @Value1)        
 And (Cover.CoverNo Like @Value2)         
 and (Cover.CoverDate = @Value3 or @Value3 = '')          
 And (Cover.ExpDate = @Value4 or @Value4 = '')          
 And (Acceptance_Detail.PolicyNo Like @Value5)          
 And (Acceptance_Detail.CertificateNo Like @Value6)          
 And (Acceptance_Detail.PolicyDate = @Value7 or @Value7 = '' or Acceptance_Detail.PolicyDate Between @Value7 and @Value16)          
 And (Acceptance_Detail.RegDate = @Value17 or @Value17 = '' or Acceptance_Detail.RegDate Between @Value17 and @Value18)          
 And Acceptance_Detail.AType Like @Value8          
 And Acceptance_Detail.AStatus Like @Value9          
 And Acceptance_Detail.RegNo Like @Value10          
 And Profile.Name Like @Value11         
 and cover.toc like @Value12          
 and (acceptance_detail.refno like @Value13)          
 and (Acceptance_detail.Matters=@Value14 or @Value14='')          
 and acceptance_detail.ano <> acceptance_detail.lano and acceptance_detail.lano <> -1          
 And (Cover.ISType<>'T' or Cover.ProformaF=1)          
 And (@Value15='%' or @Value15='' or 1 in (SELECT top 1 1 from Service Where ((Service.ANO=acceptance_detail.pANO and Service.ANO<>-1) or Service.ANO=acceptance_detail.ANO) and SStatus<>'R' and ServiceNo Like @Value15))          
 And (Acceptance_Detail.BatchNo Like @Value19 or (Acceptance_Detail.BatchNo is null and @Value19='%'))     
 And ((Acceptance_Detail.BackDatedF=1 and @Value20='1') or @Value20='')    
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')    
     
 Union    
     
 SELECT 
 CCover.COVERNO,          
 Cast(CAcceptance.AName as varchar(128)) as Insured,          
 CCover.CNO,          
 CCover.CStatus,          
 CAcceptance.lANO,          
 CAcceptance.ANO,          
 CAcceptance.REGNO,          
 CAcceptance.ADATE,          
 CAcceptance.LUSERID as USERID,          
 SysTab.Currency,          
 CAcceptance.ASTATUS,          
 CAcceptance.ATYPE,          
 CAcceptance.SDate,          
 CAcceptance.EDate,          
 Year(CAcceptance.SDate) AS RYear,          
 CCover.ISType,          
 CAcceptance.Renewal,          
 CAcceptance.ESeqNo,          
 CAcceptance.PolicyNo,          
 CAcceptance.CertificateNo,          
 CAcceptance.RefNo,          
 CCover.ProformaF,          
 CAcceptance.ANO as ANO_INFO          
FROM  Cover, Acceptance, Profile, SysTab, Cover CCover, Acceptance CAcceptance    
WHERE @Value21='1' and CAcceptance.CANO=Acceptance.ANO and CCover.CNO=CAcceptance.CNO      
 And (CAcceptance.ano = Cacceptance.lano or CAcceptance.LANO=-1)          
 and Cover.CNO=Acceptance.CNO and cover.PHolder = Profile.ID          
 And (Acceptance.AName Like @Value1)         
 And (Cover.CoverNo Like @Value2)          
 And (Cover.CoverDate = @Value3 or @Value3 = '')          
 And (Cover.ExpDate = @Value4 or @Value4 = '')          
 And (Acceptance.PolicyNo Like @Value5)          
 And (Acceptance.CertificateNo Like @Value6)          
 And (Acceptance.PolicyDate = @Value7 or @Value7 = '' or Acceptance.PolicyDate Between @Value7 and @Value16)          
 And (Acceptance.RegDate = @Value17 or @Value17 = '' or Acceptance.RegDate Between @Value17 and @Value18)          
 And Acceptance.AType Like @Value8          
 And Acceptance.AStatus Like @Value9          
 And Acceptance.RegNo Like @Value10           
 And Profile.Name Like @Value11         
 and cover.toc like @Value12          
 and (acceptance.refno like @Value13)          
 and (Acceptance.ano = acceptance.lano or Acceptance.LANO=-1)          
 and (Acceptance.Matters=@Value14 or @Value14='')          
 And (Cover.ISType<>'T' or Cover.ProformaF=1)          
 And (@Value15='%' or @Value15='' or 1 in (SELECT top 1 1 from Service Where ((Service.ANO=Acceptance.pANO and Service.ANO<>-1) or Service.ANO=Acceptance.ANO) and SStatus<>'R' and ServiceNo Like @Value15))          
 And (Acceptance.BatchNo Like @Value19 or (Acceptance.BatchNo is null and @Value19='%'))     
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')    
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')    
    
Union          
    
SELECT 
 CCover.COVERNO,          
 Cast(CAcceptance.AName as varchar(128)) as Insured,          
 CCover.CNO,          
 CCover.CStatus,          
 CAcceptance.lANO,          
 CAcceptance.ANO,          
 CAcceptance.REGNO,          
 CAcceptance.ADATE,          
 CAcceptance.LUSERID as USERID,          
 SysTab.Currency,          
 CAcceptance.ASTATUS,          
 CAcceptance.ATYPE,          
 CAcceptance.SDate,          
 CAcceptance.EDate,          
 Year(CAcceptance.SDate) AS RYear,          
 CCover.ISType,          
 CAcceptance.Renewal,          
 CAcceptance.ESeqNo,          
 CAcceptance.PolicyNo,          
 CAcceptance.CertificateNo,          
 CAcceptance.RefNo,          
 CCover.ProformaF,          
 Cacceptance_detail.ANO as ANO_INFO          
FROM  Cover, Acceptance, Profile, systab, acceptance as acceptance_detail, Acceptance as Cacceptance_detail, Cover CCover, Acceptance CAcceptance    
Where  @Value21='1' and CAcceptance_Detail.CANO=Acceptance_Detail.ANO and CAcceptance.ANO=CAcceptance_Detail.LANO and CCover.CNO=CAcceptance.CNO    
 and cover.CNO = acceptance.CNO And cover.PHolder = Profile.ID           
 and acceptance.ano = acceptance_detail.lano          
 And (Acceptance_Detail.AName Like @Value1)        
 And (Cover.CoverNo Like @Value2)         
 and (Cover.CoverDate = @Value3 or @Value3 = '')          
 And (Cover.ExpDate = @Value4 or @Value4 = '')          
 And (Acceptance_Detail.PolicyNo Like @Value5)          
 And (Acceptance_Detail.CertificateNo Like @Value6)          
 And (Acceptance_Detail.PolicyDate = @Value7 or @Value7 = '' or Acceptance_Detail.PolicyDate Between @Value7 and @Value16)          
 And (Acceptance_Detail.RegDate = @Value17 or @Value17 = '' or Acceptance_Detail.RegDate Between @Value17 and @Value18)          
 And Acceptance_Detail.AType Like @Value8          
 And Acceptance_Detail.AStatus Like @Value9          
 And Acceptance_Detail.RegNo Like @Value10          
 And Profile.Name Like @Value11         
 and cover.toc like @Value12          
 and (acceptance_detail.refno like @Value13)          
 and (Acceptance_detail.Matters=@Value14 or @Value14='')          
 and acceptance_detail.ano <> acceptance_detail.lano and acceptance_detail.lano <> -1          
 And (Cover.ISType<>'T' or Cover.ProformaF=1)          
 And (@Value15='%' or @Value15='' or 1 in (SELECT top 1 1 from Service Where ((Service.ANO=acceptance_detail.pANO and Service.ANO<>-1) or Service.ANO=acceptance_detail.ANO) and SStatus<>'R' and ServiceNo Like @Value15))          
 And (Acceptance_Detail.BatchNo Like @Value19 or (Acceptance_Detail.BatchNo is null and @Value19='%'))     
 And ((Acceptance_Detail.BackDatedF=1 and @Value20='1') or @Value20='')     
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')    
)          

GO


DROP function ListQry_3b_Sub
GO           
CREATE function [dbo].[ListQry_3b_Sub] (      
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),       
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),      
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),      
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255)      
)            
RETURNS Table            
AS RETURN            
(            
SELECT 
 Cover.COVERNO,            
 Cast(Acceptance.AName as varchar(128)) as Insured,            
 Cover.CNO,            
 Cover.CStatus,            
 Acceptance.lANO,            
 Acceptance.ANO,            
 Acceptance.REGNO,            
 Acceptance.ADATE,            
 Acceptance.LUSERID as USERID,            
 SysTab.Currency,            
 Acceptance.ASTATUS,            
 Acceptance.ATYPE,            
 Acceptance.SDate,            
 Acceptance.EDate,            
 Year(Acceptance.SDate) AS RYear,            
 Cover.ISType,            
 Acceptance.Renewal,            
 Acceptance.ESeqNo,            
 Acceptance.PolicyNo,            
 Acceptance.CertificateNo,            
 Acceptance.RefNo,            
 cover.ProformaF
FROM  Cover, Acceptance, Profile, systab            
Where cover.CNO = acceptance.CNO And cover.PHolder = Profile.ID                   
 And (Acceptance.AName Like @Value1)          
 And (Cover.CoverNo Like @Value2)            
 and (Cover.CoverDate = @Value3 or @Value3 = '')            
 And (Cover.ExpDate = @Value4 or @Value4 = '')            
 And (Acceptance.PolicyNo Like @Value5)            
 And (Acceptance.CertificateNo Like @Value6)            
 And (Acceptance.PolicyDate = @Value7 or @Value7 = '' or Acceptance.PolicyDate Between @Value7 and @Value16)            
 And (Acceptance.RegDate = @Value17 or @Value17 = '' or Acceptance.RegDate Between @Value17 and @Value18)            
 And Acceptance.AType Like @Value8            
 And Acceptance.AStatus Like @Value9            
 And Acceptance.RegNo Like @Value10            
 And Profile.Name Like @Value11           
 and cover.toc like @Value12            
 and (Acceptance.RefNo like @Value13)            
 and (acceptance.ano = acceptance.lano or acceptance.lano = -1)            
 and (Acceptance.Matters=@Value14 or @Value14='')            
 And (Cover.ISType<>'T' or Cover.ProformaF=1)            
 And (@Value15='%' or @Value15='' or 1 in (SELECT top 1 1 from Service Where ((Service.ANO=Acceptance.pANO and Service.ANO<>-1) or Service.ANO=Acceptance.ANO) and SStatus<>'R' and ServiceNo Like @Value15))            
 And (Acceptance.BatchNo Like @Value19 or (Acceptance.BatchNo is null and @Value19='%'))       
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')      
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')      
       
 union      
       
 SELECT 
 CCover.COVERNO,            
 Cast(CAcceptance.AName as varchar(128)) as Insured,            
 CCover.CNO,            
 CCover.CStatus,            
 CAcceptance.lANO,            
 CAcceptance.ANO,            
 CAcceptance.REGNO,            
 CAcceptance.ADATE,            
 CAcceptance.LUSERID as USERID,            
 SysTab.Currency,            
 CAcceptance.ASTATUS,            
 CAcceptance.ATYPE,            
 CAcceptance.SDate,            
 CAcceptance.EDate,            
 Year(CAcceptance.SDate) AS RYear,            
 CCover.ISType,            
 CAcceptance.Renewal,            
 CAcceptance.ESeqNo,            
 CAcceptance.PolicyNo,            
 CAcceptance.CertificateNo,            
 CAcceptance.RefNo,            
 Ccover.ProformaF
FROM  Cover, Acceptance, Profile, systab, Cover CCover, Acceptance CAcceptance      
Where @Value21='1' and CAcceptance.CANO=Acceptance.ANO and CCover.CNO=CAcceptance.CNO        
 and (Cacceptance.ano = Cacceptance.lano or Cacceptance.lano = -1)                     
 and cover.CNO = acceptance.CNO And cover.PHolder = Profile.ID            
 And (Acceptance.AName Like @Value1)          
 And (Cover.CoverNo Like @Value2)            
 and (Cover.CoverDate = @Value3 or @Value3 = '')            
 And (Cover.ExpDate = @Value4 or @Value4 = '')            
 And (Acceptance.PolicyNo Like @Value5)            
 And (Acceptance.CertificateNo Like @Value6)            
 And (Acceptance.PolicyDate = @Value7 or @Value7 = '' or Acceptance.PolicyDate Between @Value7 and @Value16)            
 And (Acceptance.RegDate = @Value17 or @Value17 = '' or Acceptance.RegDate Between @Value17 and @Value18)            
 And Acceptance.AType Like @Value8            
 And Acceptance.AStatus Like @Value9            
 And Acceptance.RegNo Like @Value10            
 And Profile.Name Like @Value11           
 and cover.toc like @Value12            
 and (Acceptance.RefNo like @Value13)            
 and (acceptance.ano = acceptance.lano or acceptance.lano = -1)            
 and (Acceptance.Matters=@Value14 or @Value14='')            
 And (Cover.ISType<>'T' or Cover.ProformaF=1)            
 And (@Value15='%' or @Value15='' or 1 in (SELECT top 1 1 from Service Where ((Service.ANO=Acceptance.pANO and Service.ANO<>-1) or Service.ANO=Acceptance.ANO) and SStatus<>'R' and ServiceNo Like @Value15))            
 And (Acceptance.BatchNo Like @Value19 or (Acceptance.BatchNo is null and @Value19='%'))       
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')      
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')      
      
)            

GO



DROP FUNCTION List20_Det_Sub
GO
    
CREATE FUNCTION List20_Det_Sub(@P_ANO as integer, @P_USERID as varchar(255), @P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_AStatus as varchar(1))       
RETURNS TABLE    
AS RETURN(    
    
SELECT 
 [Acceptance].[CertificateNo],     
 Acceptance.ESeqNo,    
 [Acceptance].[AName],     
 [Acceptance].[ANO],     
 [Acceptance].[REGNO],     
 [Acceptance].[ADATE],     
 [Acceptance].[LUSERID] as UserID,     
 [SysTab].[Currency],     
 [Acceptance].[ASTATUS],     
 [Acceptance].[ATYPE],     
 [Acceptance].[SDate],     
 [Acceptance].[EDate],     
 Year([Acceptance].[SDate]) AS RYear,    
 Acceptance.ValueID,    
 Acceptance.ValueDesc    
FROM     
 Acceptance,     
 Cover,     
 SysTab
WHERE     
 [Cover].[CNO]=[Acceptance].[CNO]     
 And [Acceptance].[ANO]<>[Acceptance].[LANO]     
 And [Acceptance].[LANO]=@P_ANO    
 And [Cover].[ISType]<>'T'     
 And [Acceptance].[LUserID] Like @P_UserID    
 And [Acceptance].[LDate] between @P_SDate and @P_EDate     
 And ([Acceptance].AStatus=@P_AStatus or @P_AStatus='')     
)    
    
GO

drop FUNCTION [dbo].[QDetail_PCalc]
go
CREATE FUNCTION [dbo].[QDetail_PCalc]() 
RETURNS Table 
AS RETURN ( 
SELECT  PCALC.ANO, 
sum(PCalc.TSI*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS TSI, 
sum(PCalc.OurShare*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS OurShare, 
sum(PCalc.Gross*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Gross 
FROM  PCALC INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=PCALC.ANO) 
GROUP BY PCALC.ANO 
) 
 


go
DROP FUNCTION List20_Det
GO
    
CREATE FUNCTION List20_Det(@P_ANO as integer, @P_USERID as varchar(255), @P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_AStatus as varchar(1))       
RETURNS TABLE    
AS RETURN(    
    
SELECT 
 Cast(0 as bit) as ProcessFlag,  
 Q.*,
 QPCalc.TSI,            
 QPCalc.OurShare,            
 QPCalc.Gross
from List20_Det_Sub(@P_ANO, @P_USERID, @P_SDATE, @P_EDATE, @P_AStatus) Q, QMasterAcceptance_PCalc() AS QPCalc
Where QPCalc.ANO=Q.ANO    
)    
    
GO

DROP FUNCTION List20_Sub
GO
    
CREATE FUNCTION List20_Sub(@P_USERID as varchar(255),@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_AStatus as varchar(1))       
RETURNS TABLE    
AS RETURN(    
Select
 Cover.COVERNO,       
 Cast(Acceptance.AName as varchar(128)) as Insured,       
 Cover.CNO,       
 Cover.CStatus,       
 Acceptance.lANO,       
 Acceptance.ANO,       
 Acceptance.REGNO,       
 Acceptance.ADATE,       
 Acceptance.LUSERID as USERID,       
 SysTab.Currency,       
 Acceptance.ASTATUS,       
 Acceptance.ATYPE,       
 Acceptance.SDate,       
 Acceptance.EDate,       
 Year(Acceptance.SDate) AS RYear,       
 Cover.ISType,       
 Acceptance.Renewal,       
 Acceptance.ESeqNo,       
 Acceptance.PolicyNo,       
 Acceptance.CertificateNo      
FROM  Acceptance, Cover, SysTab
WHERE  Cover.CNO=Acceptance.CNO       
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)       
 And Cover.ISType<>'T'       
 And Acceptance.LUserID Like @P_UserID      
 And Acceptance.LDate between @P_SDate and @P_EDate      
 And (Acceptance.AStatus=@P_AStatus or @P_AStatus='')  
  
union      

Select      
 Cover.COVERNO,       
 Cast(Acceptance.AName as varchar(128)) as Insured,       
 Cover.CNO,       
 Cover.CStatus,       
 Acceptance.lANO,       
 Acceptance.ANO,       
 Acceptance.REGNO,       
 Acceptance.ADATE,       
 Acceptance.LUSERID as USERID,       
 SysTab.Currency,       
 Acceptance.ASTATUS,       
 Acceptance.ATYPE,       
 Acceptance.SDate,       
 Acceptance.EDate,       
 Year(Acceptance.SDate) AS RYear,       
 Cover.ISType,       
 Acceptance.Renewal,       
 Acceptance.ESeqNo,       
 Acceptance.PolicyNo,       
 Acceptance.CertificateNo      
FROM  Acceptance, Cover, SysTab, Acceptance As Acceptance_Detail      
WHERE  Cover.CNO=Acceptance.CNO       
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO      
 And Cover.ISType<>'T'       
 And Acceptance_Detail.LUserID Like @P_UserID      
 And Acceptance_Detail.LDate between @P_SDate and @P_EDate  
 And (Acceptance_Detail.AStatus=@P_AStatus or @P_AStatus='')       
)    

GO

DROP PROCEDURE List20  
GO
  
CREATE PROCEDURE List20 (@P_USERID as varchar(255),@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_AStatus as varchar(1))       
AS      
SELECT 
 Cast(0 as bit) as ProcessFlag,  
 Q.*,
 QPCalc.TSI,            
 QPCalc.OurShare,            
 QPCalc.Gross
from List20_Sub(@P_USERID, @P_SDATE, @P_EDATE, @P_AStatus) Q, QMasterAcceptance_PCalc() AS QPCalc
Where QPCalc.ANO=Q.ANO   
      
GO

DROP FUNCTION ListDet01_Sub
GO
    
CREATE FUNCTION ListDet01_Sub(@P_ANO as integer)       
RETURNS TABLE    
AS RETURN(    
SELECT Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc        
FROM Acceptance, Cover, SysTab, Acceptance MAcceptance        
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO        
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1)    

Union

SELECT Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc        
FROM Acceptance, Cover, SysTab, Acceptance MAcceptance        
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO        
And (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 

Union

SELECT Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc        
FROM Acceptance, Cover, SysTab, Acceptance MAcceptance        
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO        
And (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1)   
)    

GO

DROP PROCEDURE ListDet01
GO
  
CREATE PROCEDURE ListDet01 (@P_ANO as integer)        
AS        
SELECT 
 Cast(0 as bit) as ProcessFlag,  
 Q.*,
 QPCalc.TSI,            
 QPCalc.OurShare,            
 QPCalc.Gross, 
 QPCalc.RYear
from ListDet01_Sub(@P_ANO) Q, QMasterAcceptance_PCalc() AS QPCalc
Where QPCalc.ANO=Q.ANO  
Order By Q.CertificateNo  
  
GO

DROP FUNCTION ListDet02_Sub
GO
    
CREATE FUNCTION ListDet02_Sub(@P_ANO as integer)       
RETURNS TABLE    
AS RETURN(    
SELECT Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc    
FROM Acceptance, Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO And Acceptance.ANO=@P_ANO  
)    

GO

DROP PROCEDURE ListDet02
GO
  
CREATE PROCEDURE ListDet02 (@P_ANO as integer)        
AS        
SELECT 
 Cast(0 as bit) as ProcessFlag,  
 Q.*,
 QPCalc.TSI,            
 QPCalc.OurShare,            
 QPCalc.Gross, 
 QPCalc.RYear
from ListDet02_Sub(@P_ANO) Q, QMasterAcceptance_PCalc() AS QPCalc
Where QPCalc.ANO=Q.ANO  
Order By Q.CertificateNo  
  
GO

DROP FUNCTION ListDet03_Sub
GO
    
CREATE FUNCTION ListDet03_Sub(@P_ANO as integer,@P_SDATE as smalldatetime, @P_EDATE as smalldatetime) 
RETURNS TABLE    
AS RETURN(    
SELECT Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc        
FROM Acceptance, Cover, SysTab, Acceptance MAcceptance        
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO        
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1)    
And Acceptance.ADate Between @P_Sdate and @P_EDate  

Union

SELECT Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc        
FROM Acceptance, Cover, SysTab, Acceptance MAcceptance        
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO        
And (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1)    
And Acceptance.ADate Between @P_Sdate and @P_EDate  

Union

SELECT Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc        
FROM Acceptance, Cover, SysTab, Acceptance MAcceptance        
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO        
And (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.ADate Between @P_Sdate and @P_EDate  

)    

GO

DROP PROCEDURE ListDet03
GO
  
CREATE PROCEDURE ListDet03 (@P_ANO as integer,@P_SDATE as smalldatetime, @P_EDATE as smalldatetime) 
AS        
SELECT 
 Cast(0 as bit) as ProcessFlag,  
 Q.*,
 QPCalc.TSI,            
 QPCalc.OurShare,            
 QPCalc.Gross, 
 QPCalc.RYear
from ListDet03_Sub(@P_ANO, @P_SDate, @P_EDate) Q, QMasterAcceptance_PCalc() AS QPCalc
Where QPCalc.ANO=Q.ANO  
Order By Q.CertificateNo  
  
GO

DROP FUNCTION ListDet04_Sub
GO
    
CREATE FUNCTION ListDet04_Sub(@P_ANO as integer,@P_FCERTNO as varchar(20), @P_LCERTNO as varchar(20))          
RETURNS TABLE    
AS RETURN(    
SELECT Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc          
FROM Acceptance, Cover, SysTab, Acceptance MAcceptance          
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO          
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1)      
And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo          

Union

SELECT Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc          
FROM Acceptance, Cover, SysTab, Acceptance MAcceptance          
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO          
And (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1)        
And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo          

Union

SELECT Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc          
FROM Acceptance, Cover, SysTab, Acceptance MAcceptance          
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO          
And (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1)
And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo          
)    

GO

DROP PROCEDURE ListDet04
GO
  
CREATE PROCEDURE ListDet04 (@P_ANO as integer,@P_FCERTNO as varchar(20), @P_LCERTNO as varchar(20))          
AS        
SELECT 
 Cast(0 as bit) as ProcessFlag,  
 Q.*,
 QPCalc.TSI,            
 QPCalc.OurShare,            
 QPCalc.Gross, 
 QPCalc.RYear
from ListDet04_Sub(@P_ANO, @P_FCERTNO, @P_LCERTNO) Q, QMasterAcceptance_PCalc() AS QPCalc
Where QPCalc.ANO=Q.ANO  
Order By Q.CertificateNo  
  
GO


 DROP Function FL_REINSURANCE_CESSION
 GO 
CREATE Function FL_REINSURANCE_CESSION (@P_ANO integer, @P_ADate smalldatetime, @P_RType varchar(255), @P_TSI Float=0, @P_RID varchar(20)='', @P_ManualF Bit=0)              
Returns Table        
As Return        
(        
                          
SELECT Distinct Reinsurance.RID, Reinsurance.Description, Reinsurance.RType, (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF,               
Case RECLASS.Limit              
 WHEN 0 then Reinsurance.Limit              
 Else RECLASS.Limit              
end as limit, ReClass.MinTSI, Reinsurance.Share, Reinsurance.PShare, Acceptance.FLDID, Acceptance.ValueID, ReClass.CessionF, ReClass.AssessmentF, ReClass.DirectF              
From REINSURANCE, RECLASS, cover, acceptance, RArrHeader             
WHERE Reinsurance.RType=@P_RType And Reinsurance.RNO=ReClass.RNo And ReClass.TOC=COVER.TOC And COVER.CNO=ACCEPTANCE.CNO And ACCEPTANCE.ANO=@P_ANO And RArrHeader.ANO=Acceptance.ANO      
And Reinsurance.SDate<=@P_ADATE And Reinsurance.EDate>=@P_ADATE  And Reinsurance.Category<>'P'              
And (@P_ManualF=1 or RArrHeader.ManualF=1 or ((@P_TSI>=ReClass.MinTSI or ReClass.MinTSI=0) and (@P_TSI<=ReClass.MaxTSI or ReClass.MaxTSI=0)            
And ((datediff(month, acceptance.sdate, acceptance.edate)>ReClass.MinPeriod) or (datediff(month, acceptance.sdate, acceptance.edate)=ReClass.MinPeriod and day(acceptance.sdate)<=day(acceptance.edate)) or ReClass.MinPeriod=0)             
And ((datediff(month, acceptance.sdate, acceptance.edate)<ReClass.MaxPeriod) or (datediff(month, acceptance.sdate, acceptance.edate)=ReClass.MaxPeriod and day(acceptance.sdate)>=day(acceptance.edate)) or ReClass.MaxPeriod=0)))    
            
                          
Union All              
                          
SELECT Distinct Reinsurance.RID, Reinsurance.Description, Reinsurance.RType, (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF,               
Case RECLASS.Limit              
 WHEN 0 then Reinsurance.Limit              
 Else RECLASS.Limit              
end as limit, ReClass.MinTSI, Reinsurance.Share, Reinsurance.PShare, Acceptance.FLDID, Acceptance.ValueID, ReClass.CessionF, ReClass.AssessmentF, ReClass.DirectF              
From REINSURANCE, RECLASS, cover, acceptance, RArrHeader, RePolicy              
WHERE Reinsurance.RType=@P_RType And Reinsurance.RNO=ReClass.RNo And ReClass.TOC=COVER.TOC And COVER.CNO=ACCEPTANCE.CNO And RArrHeader.ANO=Acceptance.ANO And ACCEPTANCE.ANO=@P_ANO And Reinsurance.SDate<=@P_ADATE And Reinsurance.EDate>=@P_ADATE    
And Reinsurance.Category='P'              
And RePolicy.RNO=Reinsurance.RNO and RePolicy.ID=Cover.PHolder              
And (@P_ManualF=1 or RArrHeader.ManualF=1 or ((@P_TSI>=ReClass.MinTSI or ReClass.MinTSI=0) and (@P_TSI<=ReClass.MaxTSI or ReClass.MaxTSI=0)            
And ((datediff(month, acceptance.sdate, acceptance.edate)>ReClass.MinPeriod) or (datediff(month, acceptance.sdate, acceptance.edate)=ReClass.MinPeriod and day(acceptance.sdate)<=day(acceptance.edate)) or ReClass.MinPeriod=0)             
And ((datediff(month, acceptance.sdate, acceptance.edate)<ReClass.MaxPeriod) or (datediff(month, acceptance.sdate, acceptance.edate)=ReClass.MaxPeriod and day(acceptance.sdate)>=day(acceptance.edate)) or ReClass.MaxPeriod=0)))    
              
) 
GO

alter FUNCTION List10_Det (@P_ANO as integer)              
RETURNS Table              
AS RETURN(              
                      
SELECT Cast(0 as bit) as ProcessFlag,              
 ACCEPTANCE.CNO,ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.ADATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, ACCEPTANCE.BACKDATEDF, AccAss.CURRENCY_OC,                 
 sum(case accass.code+accass.type              
 when 'PIT' then accass.amount_oc              
 when 'PIX' then accass.amount_oc              
 else 0 end) as Premium,              
              
 sum(case accass.code+accass.type              
 when 'UIT' then accass.amount_oc              
 when 'UIX' then accass.amount_oc              
 else 0 end) as UjrohCedant,           
               
 sum(case accass.code+accass.type              
 when 'AIT' then accass.amount_oc              
 when 'AIX' then accass.amount_oc              
 else 0 end) as Claim,              
      
 sum(case accass.code+accass.type              
 when 'RIT' then accass.amount_oc              
 when 'RIX' then accass.amount_oc              
 else 0 end) as Subrogation,              
              
 sum(case accass.code+accass.type              
 when 'CIT' then accass.amount_oc              
 when 'CIX' then accass.amount_oc              
 else 0 end) as Commission,              
              
 sum(case accass.code+accass.type              
 when 'FIT' then accass.amount_oc              
 when 'FIX' then accass.amount_oc              
 else 0 end) as Fee,              
              
 sum(case accass.code+accass.type              
 when 'TIT' then accass.amount_oc              
 when 'TIX' then accass.amount_oc              
 else 0 end) as Tax,              
              
 sum(case accass.code+accass.type              
 when 'CBO' then accass.amount_oc              
 when 'OIT' then accass.amount_oc              
 when 'OIX' then accass.amount_oc              
 else 0 end) as Other,                         
              
 sum(case accass.code+accass.type              
 when 'DIT' then accass.amount_oc              
 when 'DIX' then accass.amount_oc              
 else 0 end) as Fund,              
 Max(PCalc.TSI) as TSI,               
AccAss.Currency                
FROM ACCEPTANCE With (Index (I_ACCEPTANCE_LANO))       
Left Join AccAss with (Index (I_ACCASS_ANO)) on (AccAss.ANO=Acceptance.ANO)       
Left Join PCalc with (index(I_PCalc)) on (PCalc.ANO=Acceptance.ANO and PCalc.Currency=AccAss.Currency)         
WHERE Acceptance.LANO=@P_ANO                   and Acceptance.ANO <> Acceptance.LANO
GROUP BY ACCEPTANCE.ANO, ACCEPTANCE.CNO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.ADATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, ACCEPTANCE.BACKDATEDF, AccAss.CURRENCY_OC, AccAss.CURRENCY              
)  
go  

Drop function FL_SR_SchemeNo
GO
Create function FL_SR_SchemeNo(@p_UserID varchar(10), @P_SchemeNo varchar(10),@P_PolicyNo varchar(10))  
RETURNS Table  
AS RETURN  
(

Select Distinct S.SchemeNo, S.Description, S.Disc, S.DailyBasisF, s.sPeriod, s.AllowedF 
from acceptance as a
inner join cover as c on (a.cno=c.cno and c.OpenFlag=1) 
inner join Scheme_Master S on (S.TOC=C.TOC and S.SchemeNo Like @P_SchemeNo)
inner join SysUser on (SysUser.ID=@P_UserID)
Left Join Scheme_Branch S1 on (SysUser.Type<>'SUPERVISOR' and S1.SchemeNo=S.SchemeNo) 
where a.ano = a.lano and S.AllowedF=1 and A.AType not in ('A','C') and a.astatus = 'I' and a.PolicyNo Like @P_PolicyNo+'%' and a.ano not in (Select PANO from Acceptance Where Acceptance.PANO=a.ANO)
and (SysUser.Type='SUPERVISOR' or S1.Branch is null or S1.Branch in (Select Branch from SysUserBranch Where AllowedF=1 and ID=@P_UserID))
and (SysUser.Type='SUPERVISOR' or S.TOC in (Select TOC from SysUserTOC Where ID=@P_UserID))
)          
go

--04
DROP PROCEDURE CLLIST11   
GO
CREATE PROCEDURE CLLIST11 AS    
SELECT Cast(0 as bit) as ProcessFlag,    
 [CLAIM].[CLAIMNO],    
 [CLAIM].[REGDATE],    
 [CLAIM].[REFNO],    
 [CLAIM].[COL],    
 [COLTAB].[DESCRIPTION],    
 [CLAIM].[LOSSDATE],    
 [CLAIM].[TOC],    
 [CLAIM].[CSDATE],    
 [CLAIM].[LOSSPLACE],    
 [CLAIM].[CTYPE],    
 [CLAIM].[CSTATUS],    
 [CLAIM].[CNO],    
 [CLAIM].[ANO],    
 [CLAIM].[PCNO],    
 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,    
 [SYSTAB].[CURRENCY],    
 [CCALC].[LOSS] AS ESTIMATE,    
 [CCALC].[CLAIM] AS CLAIM,    
 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,    
 [CCALC].[SALVAGE] AS SALVAGE,    
 [CCALC].[COST] AS COST,    
 [CCALC].[SUBROGATION] AS SUBROGATION, ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,    
 [CLAIM].[VSEQNO],    
 [CLAIM].[CSEQNO],    
 acceptance.aname,    
 acceptance.policyno,    
 acceptance.certificateno,    
 CLAIM.SETTLEDF    
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER, CLAIM AS C1,COLTAB,acceptance    
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]    
 And [CCALC].[CNO]=[CLAIM].[CNO]    
 And CLAIM.COL=COLTAB.COL    
 And [CLAIM].[CNO]=C1.PCNO    
 And C1.CSTATUS='P'    
 And C1.VSEQNO<>0    
 and acceptance.ano=claim.ano    

GO

-- Perubahan fungsi FL_SR_SchemeNo Penambahan Parameter User ID untuk pemeriksaan pada Scheme Branch Preference terhadap SysUserBranch dan Pemeriksaan TOC pada SysUserTOC
Drop Function FL_SR_SchemeNo
GO
Create function FL_SR_SchemeNo(@p_UserID varchar(10), @P_SchemeNo varchar(10),@P_PolicyNo varchar(10))  
RETURNS Table  
AS RETURN  
(
Select Distinct S.SchemeNo, S.Description, S.Disc, S.DailyBasisF, s.sPeriod, s.AllowedF 
from acceptance as a
inner join cover as c on (a.cno=c.cno and c.OpenFlag=1) 
inner join Scheme_Master S on (S.TOC=C.TOC and S.SchemeNo Like @P_SchemeNo)
inner join SysUser on (SysUser.ID=@P_UserID)
Left Join Scheme_Branch S1 on (SysUser.Type<>'SUPERVISOR' and S1.SchemeNo=S.SchemeNo) 
where a.ano = a.lano and A.AType not in ('A','C') and a.astatus = 'I' and a.PolicyNo Like @P_PolicyNo+'%' and a.ano not in (Select PANO from Acceptance Where Acceptance.PANO=a.ANO)
and (SysUser.Type='SUPERVISOR' or S1.Branch is null or S1.Branch in (Select Branch from SysUserBranch Where AllowedF=1 and ID=@P_UserID))
and (SysUser.Type='SUPERVISOR' or S.TOC in (Select TOC from SysUserTOC Where ID=@P_UserID))
)
GO

Drop procedure SchemeList
GO
CREATE procedure SchemeList(@p_SchemeNo varchar(10),@P_PolicyNo varchar(20), @P_Branch varchar(20), @p_SDate smalldatetime,@p_EDate smalldatetime, @P_Status as varchar(10),@P_UserID as varchar(10), @P_BatchNoF as varchar(10)='', @P_BatchNoL as varchar(10)='')          
as
select  s.*, PCalc.Gross, c.insured, sm.description          
From          
 scheme_transaction as s
 Left join PCalc on (PCalc.ANO=S.ANO) 
 Inner join Acceptance as a on (A.ANO=S.LANO and A.ANO=A.LANO and A.AStatus<>'W')     
 Inner join Cover as C on (C.CNO=A.CNO)
 Inner join scheme_master As sm on (sm.SchemeNo=S.SchemeNo)
Where          
 sm.schemeno Like @p_SchemeNo+'%'   
 and a.PolicyNo Like @P_PolicyNo+'%' and a.Branch like @P_Branch+'%'   
 and s.trdate >=@p_SDate and s.trDate<=@p_EDate   
 and (s.Status=@P_Status or @P_Status='') and (s.LUserID=@P_UserID or @P_UserID='')   
 and s.BatchNo Between @P_BatchNoF and @P_BatchNoL  
order by s.TrNo            
GO

Drop procedure SchemeList_by_TrNo  
GO    
CREATE procedure SchemeList_by_TrNo (@p_TrNo integer)
as  
select top 1  
 s.*, PCalc.Gross, c.insured, sm.description  
from   
 scheme_transaction as s
 Left join PCalc on (PCalc.ANO=S.ANO) 
 Inner join Acceptance as a on (A.ANO=S.LANO and A.ANO=A.LANO and A.AStatus<>'W')     
 Inner join Cover as C on (C.CNO=A.CNO)
 Inner join scheme_master As sm on (sm.SchemeNo=S.SchemeNo)
where  S.TrNo=@P_TrNo
GO

DROP FUNCTION FN_UserSegment 
GO      
CREATE FUNCTION FN_UserSegment (@P_UserID as varchar(10))          
RETURNS TABLE          
as RETURN(          
SELECT Segment.*     
 from Segment     
 Inner join SysUser on (SysUser.ID=@P_UserID)    
 Where (SysUser.Type='SUPERVISOR' or Segment.Segment in (Select SysUserSegment.Segment from SysUserSegment Where SysUserSegment.ID=@P_UserID and SysUserSegment.Segment=Segment.Segment)) 
)       
GO

Alter procedure SchemeList(@p_SchemeNo varchar(10),@P_PolicyNo varchar(20), @P_Branch varchar(20), @p_SDate smalldatetime,@p_EDate smalldatetime, @P_Status as varchar(10),@P_UserID as varchar(10), @P_BatchNoF as varchar(10)='', @P_BatchNoL as varchar(10)='')            
as            
                
select  s.*, PCalc.Gross, c.insured, sm.description            
From            
 scheme_transaction as s  
 Left join PCalc on (PCalc.ANO=S.ANO)   
 Inner join Acceptance as a on (A.ANO=S.LANO and A.ANO=A.LANO and A.AStatus<>'W')       
 Inner join Cover as C on (C.CNO=A.CNO)  
 Inner join scheme_master As sm on (sm.SchemeNo=S.SchemeNo)  
Where            
 sm.schemeno Like @p_SchemeNo+'%'     
 and a.PolicyNo Like @P_PolicyNo+'%' and a.Branch like @P_Branch+'%'     
 and s.trdate >=@p_SDate and s.trDate<=@p_EDate     
 and (s.Status=@P_Status or @P_Status='') and (s.LUserID=@P_UserID or @P_UserID='')     
 and (@P_BatchNoF='' or s.BatchNo>=@P_BatchNoF)
 and (@P_BatchNoL='' or s.BatchNo<=@P_BatchNoL)
order by s.TrNo              

GO


Alter PROCEDURE QBSType(@PANO as integer=0)   
AS  
SELECT B.*  
FROM BSType B
Left Join Acceptance A on (A.ANO=@PANO)
Left Join Cover C on (C.CNO=A.CNO)
Left Join TOC on (TOC.TOC=C.TOC)
Where (coalesce(TOC.CommPoolBSF,0)=1 or B.BSType<>'C')

GO

DROP FUNCTION FN_ICALC 
GO
Create FUNCTION FN_ICALC (@P_ANO as integer)        
RETURNS Table        
AS RETURN (        
SELECT  ICALC.ANO,        
 Count(Distinct PCalc.Currency) AS NUMCCY,      
 MAX(PCALC.RATE) AS RATE,      
 sum(ICALC.TSI*PCalc.Rate) AS TSI,          
 sum(ICalc.Gross/ICALC.PRORATA/(ICALC.PCTADJ/100)*PCalc.Rate) AS Gross  
FROM  ICALC  
LEFT JOIN PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CURRENCY=ICALC.CURRENCY)  
WHERE ICALC.ANO=@P_ANO AND ICALC.GROSS<>0  
GROUP BY ICALC.ANO  
) 

GO

DROP procedure PI13 
GO
CREATE procedure PI13 (@P_ANO as integer)                
as                
Begin               
 Declare @P_Date as smalldatetime  
 Declare @P_PolicyNo as varchar(20)  
 Declare @P_CertificateNo as varchar(20)  
 Declare @P_OpenFLag as Bit  
 Declare @P_LANO as int    
 Declare @P_A_PolicyNo as varchar(50)  
 Select @P_Date = Getdate()        
   
 Select @P_LANO=A1.LANO, @P_PolicyNo=A1.PolicyNo, @P_CertificateNo=A1.CertificateNo, @P_OpenFlag=C1.OpenFlag from Acceptance A1, Cover C1 Where C1.CNO=A1.CNO and A1.ANO=@P_ANO  
  
 if @P_LANO<>-1   
 if @P_OpenFlag=1 and @P_ANO<>@P_LANO   
  Select @P_A_PolicyNo=@P_PolicyNo + '-' + @P_CertificateNo  
 else  
  Select @P_A_PolicyNo=@P_PolicyNo  
 else  
  Select @P_A_PolicyNo=@P_PolicyNo  
   
 Select Admlink.Subject, Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Voucher_Due.DueDate as NDueDate, 
 Profile.Name, Voucher.Currency, 
 
 case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC) end  as Nominal, 
 case when Voucher.debtorf=1 then (coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) else -(coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) end as AmountDue, 
 case when Voucher.debtorf=1 then Voucher.Payment_CC else -Voucher.Payment_CC end as Payment, 
 case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC) end as Outstanding                
 
 from nVoucher Voucher Left Join Voucher_AmountDue(@P_Date) Voucher_Due on (Voucher_Due.Voucher=Voucher.Voucher), Profile, ProAcc, Admlink         
 Where Profile.ID=ProAcc.ID and ProAcc.ProAcc=Voucher.ProAcc and Admlink.Voucher=Voucher.Voucher              
 and Admlink.Type in ('DI','IC','IR','CF','JP','BB','BA','BO','OP','FO') and Admlink.A_PolicyNo=@P_A_PolicyNo  
  
end               

GO

DROP procedure PI09   
GO
CREATE procedure PI09 (@P_ANO as integer)    
as    
Begin
 Declare @P_Date as smalldatetime  
 Declare @P_PolicyNo as varchar(20)  
 Declare @P_CertificateNo as varchar(20)  
 Declare @P_OpenFLag as Bit  
 Declare @P_LANO as int    
 Declare @P_A_PolicyNo as varchar(50)  
 Select @P_Date = Getdate()        
   
 Select @P_LANO=A1.LANO, @P_PolicyNo=A1.PolicyNo, @P_CertificateNo=A1.CertificateNo, @P_OpenFlag=C1.OpenFlag from Acceptance A1, Cover C1 Where C1.CNO=A1.CNO and A1.ANO=@P_ANO  
  
 if @P_LANO<>-1   
 if @P_OpenFlag=1 and @P_ANO<>@P_LANO   
  Select @P_A_PolicyNo=@P_PolicyNo + '-' + @P_CertificateNo  
 else  
  Select @P_A_PolicyNo=@P_PolicyNo  
 else  
  Select @P_A_PolicyNo=@P_PolicyNo    
 
 Select Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Profile.Name, Voucher.Currency,  
 case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC) end  as Nominal, 
 case when Voucher.debtorf=1 then (Voucher.AmountDue-Voucher.Payment_CC) else -(Voucher.AmountDue-Voucher.Payment_CC) end as AmountDue, 
 case when Voucher.debtorf=1 then Voucher.Payment_CC else -Voucher.Payment_CC end as Payment, 
 case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC) end as Outstanding                 

 from nVoucher Voucher, Profile, ProAcc, Admlink
 Where Profile.ID=ProAcc.ID and ProAcc.ProAcc=Voucher.ProAcc and Admlink.Voucher=Voucher.Voucher              
 and Admlink.Subject='Claim' and Admlink.Type in ('DI','IC','IR','OP') and Admlink.A_PolicyNo=@P_A_PolicyNo  
 and round(Voucher.AmountDue,0)>round(Voucher.Payment_CC,0)   
End

GO

DROP procedure PI08   

GO  
  
CREATE procedure PI08 (@P_ANO as integer)        
as        
Begin      
Declare @P_Date as smalldatetime  
 Declare @P_PolicyNo as varchar(20)  
 Declare @P_CertificateNo as varchar(20)  
 Declare @P_OpenFLag as Bit  
 Declare @P_LANO as int    
 Declare @P_A_PolicyNo as varchar(50)  
 Select @P_Date = Getdate()        
   
 Select @P_LANO=A1.LANO, @P_PolicyNo=A1.PolicyNo, @P_CertificateNo=A1.CertificateNo, @P_OpenFlag=C1.OpenFlag from Acceptance A1, Cover C1 Where C1.CNO=A1.CNO and A1.ANO=@P_ANO  
  
 if @P_LANO<>-1   
 if @P_OpenFlag=1 and @P_ANO<>@P_LANO   
  Select @P_A_PolicyNo=@P_PolicyNo + '-' + @P_CertificateNo  
 else  
  Select @P_A_PolicyNo=@P_PolicyNo  
 else  
  Select @P_A_PolicyNo=@P_PolicyNo    
 
 Select Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Voucher_Due.DueDate as NDueDate, Profile.Name, Voucher.Currency,  
 case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC) end  as Nominal, 
 case when Voucher.debtorf=1 then (coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) else -(coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) end as AmountDue,  
 case when Voucher.debtorf=1 then Voucher.Payment_CC else -Voucher.Payment_CC end as Payment, 
 case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC) end as Outstanding,
 Voucher.Installment,    
 Voucher.DueDate_1, case when Voucher.debtorf=1 then Voucher.AmountDue_1 else -Voucher.AmountDue_1 end AmountDue_1,    
 Voucher.DueDate_2, case when Voucher.debtorf=1 then Voucher.AmountDue_2 else -Voucher.AmountDue_2 end AmountDue_2,    
 Voucher.DueDate_3, case when Voucher.debtorf=1 then Voucher.AmountDue_3 else -Voucher.AmountDue_3 end AmountDue_3,    
 Voucher.DueDate_4, case when Voucher.debtorf=1 then Voucher.AmountDue_4 else -Voucher.AmountDue_4 end AmountDue_4,    
 Voucher.DueDate_5, case when Voucher.debtorf=1 then Voucher.AmountDue_5 else -Voucher.AmountDue_5 end AmountDue_5,    
 Voucher.DueDate_6, case when Voucher.debtorf=1 then Voucher.AmountDue_6 else -Voucher.AmountDue_6 end AmountDue_6,    
 Voucher.DueDate_7, case when Voucher.debtorf=1 then Voucher.AmountDue_7 else -Voucher.AmountDue_7 end AmountDue_7,    
 Voucher.DueDate_8, case when Voucher.debtorf=1 then Voucher.AmountDue_8 else -Voucher.AmountDue_8 end AmountDue_8,    
 Voucher.DueDate_9, case when Voucher.debtorf=1 then Voucher.AmountDue_9 else -Voucher.AmountDue_9 end AmountDue_9,    
 Voucher.DueDate_10, case when Voucher.debtorf=1 then Voucher.AmountDue_10 else -Voucher.AmountDue_10 end AmountDue_10,    
 Voucher.DueDate_11, case when Voucher.debtorf=1 then Voucher.AmountDue_11 else -Voucher.AmountDue_11 end AmountDue_11,    
 Voucher.DueDate_12, case when Voucher.debtorf=1 then Voucher.AmountDue_12 else -Voucher.AmountDue_12 end AmountDue_12  
 from nVoucher Voucher Inner Join Voucher_AmountDue(@P_Date) Voucher_Due on (Voucher_Due.Voucher=Voucher.Voucher), Profile, ProAcc, Admlink
 Where Profile.ID=ProAcc.ID and ProAcc.ProAcc=Voucher.ProAcc and Admlink.Voucher=Voucher.Voucher              
 and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') and Admlink.A_PolicyNo=@P_A_PolicyNo 
End      
      
      
                    

GO

DROP FUNCTION FN_GENDTAB 
GO    
      
CREATE FUNCTION FN_GENDTAB (@P_TOC as varchar(10))          
RETURNS TABLE          
as RETURN(          
Select G1.*
from GenDTab G1 Inner Join GenHTab G2 on (G2.FLDID=G1.FLDID) 
Where 
(
G2.SubClassF=0 or @P_TOC='' 
or (G2.SubClassF=1 and G1.ValueID in (Select Top 1 ValueID from GenDTOC G3 Where G3.FLDID=G1.FLDID and G3.VALUEID=G1.VALUEID and G3.TOC=@P_TOC))
)
)        
        
GO

DROP Function FN_Get_SQL_General
GO
CREATE Function FN_Get_SQL_General(@P_FLDID as varchar(50))  
RETURNS @GenTab TABLE (ValueID1  varchar(1024))  
AS  
BEGIN  
      
    Declare @SQL as varchar(1024)  
    Declare @P_FLDTAG1 as varchar(50)  
    Declare @P_FLDTAG2 as varchar(50)  
    Declare @P_FLDTAG3 as varchar(50)  
    Declare @P_FLDTAG4 as varchar(50)  
    Declare @P_FLDTAG5 as varchar(50)  
    Declare @P_FLDTAG6 as varchar(50)  
    Declare @P_FLDTAG7 as varchar(50)  
    Declare @P_FLDTAG8 as varchar(50)  
    Declare @P_FLDTAG9 as varchar(50)  
    Declare @P_FLDTAG10 as varchar(50)  
    Declare @P_FLDTAG11 as varchar(50)  
    Declare @P_FLDTAG12 as varchar(50)  
    Declare @P_FLDTAG13 as varchar(50)  
    Declare @P_FLDTAG14 as varchar(50)  
    Declare @P_FLDTAG15 as varchar(50)  
  
    Declare GenHTab_Cursor cursor for  
    Select FLDTAG1, FLDTAG2, FLDTAG3, FLDTAG4, FLDTAG5, FLDTAG6, FLDTAG7, FLDTAG8, FLDTAG9, FLDTAG10, FLDTAG11, FLDTAG12, FLDTAG13, FLDTAG14, FLDTAG15  
    from GenHTab Where FLDID=@P_FLDID  
    Open GenHTab_Cursor  
    Fetch from GenhTab_Cursor into @P_FLDTAG1, @P_FLDTAG2, @P_FLDTAG3, @P_FLDTAG4, @P_FLDTAG5, @P_FLDTAG6, @P_FLDTAG7, @P_FLDTAG8, @P_FLDTAG9, @P_FLDTAG10, @P_FLDTAG11, @P_FLDTAG12, @P_FLDTAG13, @P_FLDTAG14, @P_FLDTAG15  
    Deallocate GenhTab_Cursor  
      
    Select @SQL='Select G1.ValueID, G1.Description'  
    if @P_FLDTAG1<>''  
       Select @SQL = @SQL+', G1.ValueDesc1 as ['+@P_FLDTAG1+']'  
    if @P_FLDTAG2<>''  
       Select @SQL = @SQL+', G1.ValueDesc2 as ['+@P_FLDTAG2+']'  
    if @P_FLDTAG3<>''  
       Select @SQL = @SQL+', G1.ValueDesc3 as ['+@P_FLDTAG3+']'  
    if @P_FLDTAG4<>''  
       Select @SQL = @SQL+', G1.ValueDesc4 as ['+@P_FLDTAG4+']'  
    if @P_FLDTAG5<>''  
       Select @SQL = @SQL+', G1.ValueDesc5 as ['+@P_FLDTAG5+']'  
    if @P_FLDTAG6<>''  
       Select @SQL = @SQL+', G1.ValueDesc6 as ['+@P_FLDTAG6+']'  
    if @P_FLDTAG7<>''  
       Select @SQL = @SQL+', G1.ValueDesc7 as ['+@P_FLDTAG7+']'  
    if @P_FLDTAG8<>''  
       Select @SQL = @SQL+', G1.ValueDesc8 as ['+@P_FLDTAG8+']'  
    if @P_FLDTAG9<>''  
       Select @SQL = @SQL+', G1.ValueDesc9 as ['+@P_FLDTAG9+']'  
    if @P_FLDTAG10<>''  
       Select @SQL = @SQL+', G1.ValueDesc10 as ['+@P_FLDTAG10+']'  
    if @P_FLDTAG11<>''  
       Select @SQL = @SQL+', G1.ValueDesc11 as ['+@P_FLDTAG11+']'  
    if @P_FLDTAG12<>''  
       Select @SQL = @SQL+', G1.ValueDesc12 as ['+@P_FLDTAG12+']'  
    if @P_FLDTAG13<>''  
       Select @SQL = @SQL+', G1.ValueDesc13 as ['+@P_FLDTAG13+']'  
    if @P_FLDTAG14<>''  
       Select @SQL = @SQL+', G1.ValueDesc14 as ['+@P_FLDTAG14+']'  
    if @P_FLDTAG15<>''  
       Select @SQL = @SQL+', G1.ValueDesc15 as ['+@P_FLDTAG15+']'  
      
    Select @Sql = @SQL + ' from GENDTAB G1'
    insert into @GenTab Select @SQL  
Return  
End  
  
GO


ALTER function ListDet05_b (@P_ANO as integer,   
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),   
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),  
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),  
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255)  
)        
RETURNS Table    
AS RETURN    
(    
SELECT Cast(0 as bit) as ProcessFlag,    
 q.[CertificateNo],    
 q.ESeqNo,    
 q.[AName],    
 q.[ANO],    
 q.[REGNO],    
 q.[ADATE],    
 q.[USERID],    
 q.[Currency],    
 q.[TSI],    
 q.[OurShare],    
 q.[Gross],    
 q.[ASTATUS],    
 q.[ATYPE],    
 q.[SDate],    
 q.[EDate],    
 q.RYear,    
 q.ValueID,     
 q.ValueDesc,    
 a.valueid1, a.valuedesc1,    
 a.valueid2, a.valuedesc2,    
 a.valueid3, a.valuedesc3,    
 a.valueid4, a.valuedesc4,    
 a.valueid5, a.valuedesc5,    
 a.valueid6, a.valuedesc6,    
 a.valueid7, a.valuedesc7,    
 a.valueid8, a.valuedesc8,    
 a.valueid9, a.valuedesc9,    
 a.valueid10, a.valuedesc10,    
 a.valueid11, a.valuedesc11,    
 a.valueid12, a.valuedesc12,    
 a.valueid13, a.valuedesc13,    
 a.valueid14, a.valuedesc14,    
 a.VALUEID15 , a.VALUEDESC15    
FROM ListDet05_a (@P_ANO, @Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18,@Value19, @Value20, @Value21, @Value22) as q, ainfo as a    
Where q.ANO = a.ANO    
)    
GO

ALTER function ListDet05_a (@P_ANO as integer,   
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),   
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),  
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),  
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255)  
)        
RETURNS Table      
AS RETURN      
(      
 SELECT Cast(0 as bit) as ProcessFlag,      
 Acceptance.CertificateNo,      
 Acceptance.ESeqNo,      
 Acceptance.AName,      
 Acceptance.ANO,      
 Acceptance.REGNO,      
 Acceptance.ADATE,      
 Acceptance.LUSERID as UserID,      
 SysTab.Currency,      
 QPCalc.TSI,      
 QPCalc.OurShare,      
 QPCalc.Gross,      
 Acceptance.ASTATUS,      
 Acceptance.ATYPE,      
 Acceptance.SDate,      
 Acceptance.EDate,      
 Year(Acceptance.SDate) AS RYear,      
 Acceptance.ValueID,      
 Acceptance.ValueDesc      
From      
 Acceptance,      
 Cover,      
 SysTab,      
 QMasterAcceptance_PCalc() AS QPCalc,      
 Profile      
Where      
 cover.CNO = acceptance.CNO      
 And QPCalc.ANO=Acceptance.ANO      
 And Acceptance.ANO<>Acceptance.LANO      
 And Acceptance.LANO=@P_ANO      
 And Cover.PHOLDER=Profile.ID      
 And ((Cover.Insured Like @Value1 Or Cover.Insured is null) or (Acceptance.AName Like @Value1 Or Acceptance.AName is null))      
 And (Cover.CoverNo Like @Value2 Or Cover.CoverNo is null)      
 and (Cover.CoverDate = @Value3 Or Cover.CoverDate is null or @Value7 = '')      
 And (Cover.ExpDate = @Value4 Or Cover.ExpDate is null or @Value7 = '')      
 And (Acceptance.PolicyNo Like @Value5 Or Acceptance.PolicyNo is null)      
 And (Acceptance.CertificateNo Like @Value6 Or Acceptance.CertificateNo is null)      
 And (Acceptance.PolicyDate = @Value7 Or Acceptance.PolicyDate is null or @Value7 = '' or Acceptance.PolicyDate Between @Value7 and @Value16)      
 And (Acceptance.RegDate = @Value17 Or Acceptance.RegDate is null or @Value17 = '' or Acceptance.RegDate Between @Value17 and @Value18)      
 And Acceptance.AType Like @Value8      
 And Acceptance.AStatus Like @Value9      
 And Acceptance.RegNo Like @Value10      
 And Profile.Name Like @Value11     
 and cover.toc like @Value12      
 and (acceptance.refno like @Value13 or acceptance.refno is null)      
 and (Acceptance.Matters=@Value14 or @Value14='')      
 And Cover.ISType<>'T'      
 And (@Value15='%' or @Value15='' or 1 in (SELECT top 1 1 from Service Where ((Service.ANO=Acceptance.pANO and Service.ANO<>-1) or Service.ANO=Acceptance.ANO) and SStatus<>'R' and ServiceNo Like @Value15))      
 And (Acceptance.BatchNo Like @Value19 or (Acceptance.BatchNo is null and @Value19='%'))   
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')  
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')  
)      

GO

Drop Procedure View16L
GO
CREATE Procedure View16L(@P_ANO integer)  
as  
SELECT ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO,ACCEPTANCE.ADATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, AccAss.CURRENCY_OC,   
sum(case accass.code  
when 'P' then accass.amount_oc  
else 0 end) as Premium,  
sum(case accass.code  
when 'A' then accass.amount_oc  
else 0 end) as Claim,  
sum(case accass.code  
when 'C' then accass.amount_oc  
else 0 end) as Commission,  
sum(case accass.code  
when 'F' then accass.amount_oc  
else 0 end) as Fee  
FROM ACCEPTANCE Left Join AccAss on (AccAss.ANO=Acceptance.ANO)
WHERE Acceptance.LANO=@P_ANO 
GROUP BY ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO,ACCEPTANCE.ADATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, AccAss.CURRENCY_OC  
GO

DROP FUNCTION List10_Det 
GO
CREATE FUNCTION List10_Det (@P_ANO as integer)              
RETURNS Table              
AS RETURN(              
                      
SELECT Cast(0 as bit) as ProcessFlag,              
 ACCEPTANCE.CNO,ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.ADATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, ACCEPTANCE.BACKDATEDF, AccAss.CURRENCY_OC,                 
 sum(case accass.code+accass.type              
 when 'PIT' then accass.amount_oc              
 when 'PIX' then accass.amount_oc              
 else 0 end) as Premium,              
              
 sum(case accass.code+accass.type              
 when 'UIT' then accass.amount_oc              
 when 'UIX' then accass.amount_oc              
 else 0 end) as UjrohCedant,           
               
 sum(case accass.code+accass.type              
 when 'AIT' then accass.amount_oc              
 when 'AIX' then accass.amount_oc              
 else 0 end) as Claim,              
      
 sum(case accass.code+accass.type              
 when 'RIT' then accass.amount_oc              
 when 'RIX' then accass.amount_oc              
 else 0 end) as Subrogation,              
              
 sum(case accass.code+accass.type              
 when 'CIT' then accass.amount_oc              
 when 'CIX' then accass.amount_oc              
 else 0 end) as Commission,              
              
 sum(case accass.code+accass.type              
 when 'FIT' then accass.amount_oc              
 when 'FIX' then accass.amount_oc              
 else 0 end) as Fee,              
              
 sum(case accass.code+accass.type              
 when 'TIT' then accass.amount_oc              
 when 'TIX' then accass.amount_oc              
 else 0 end) as Tax,              
              
 sum(case accass.code+accass.type              
 when 'CBO' then accass.amount_oc              
 when 'OIT' then accass.amount_oc              
 when 'OIX' then accass.amount_oc              
 else 0 end) as Other,                         
              
 sum(case accass.code+accass.type              
 when 'DIT' then accass.amount_oc              
 when 'DIX' then accass.amount_oc              
 else 0 end) as Fund,              
 Max(PCalc.TSI) as TSI,               
AccAss.Currency                
FROM ACCEPTANCE With (Index (I_ACCEPTANCE_LANO))       
Left Join AccAss with (Index (I_ACCASS_ANO)) on (AccAss.ANO=Acceptance.ANO)       
Left Join PCalc with (index(I_PCalc)) on (PCalc.ANO=Acceptance.ANO and PCalc.Currency=AccAss.Currency)         
WHERE Acceptance.LANO=@P_ANO and Acceptance.ANO<>Acceptance.LANO                 
GROUP BY ACCEPTANCE.ANO, ACCEPTANCE.CNO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.ADATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, ACCEPTANCE.BACKDATEDF, AccAss.CURRENCY_OC, AccAss.CURRENCY              
)   
        
GO

ALTER PROCEDURE ListDet04 (@P_ANO as integer,@P_FCERTNO as varchar(20), @P_LCERTNO as varchar(20))        
AS        
SELECT Cast(0 as bit) as ProcessFlag,Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross, QPCalc.RYear, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, QPCalc.ValueID, QPCalc.ValueDesc        
FROM Acceptance, Cover, SysTab, qMasterAcceptance_PCalc() AS QPCalc, Acceptance MAcceptance        
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO        
And      
(      
(Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1 And QPCalc.ANO=Acceptance.ANO)    
or (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1 And QPCalc.ANO=Acceptance.ANO)      
or (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1 And QPCalc.ANO=Acceptance.ANO)      
)            
And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo        
Order By Acceptance.CertificateNo  
      
GO  

ALTER PROCEDURE MListDet04(@P_ANO as integer,@P_FCERTNO as varchar(20), @P_LCERTNO as varchar(20))        
AS        
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Acceptance.AName, Acceptance.CertificateNo, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.LANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE,Acceptance.LUSERID as USERID,SysTab.Currency, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Year(RArrheader.Rdate) AS RYear, qPCalc.ValueID, QPCalc.ValueDesc      
FROM Acceptance, Cover, RArrHeader, SysTab, QMasterAcceptance_PCalc() AS QPCalc      
WHERE       
 Cover.CNO=Acceptance.CNO       
 And RArrHeader.ANO=Acceptance.ANO       
 And QPCalc.ANO=Acceptance.ANO       
 And Acceptance.ANO<>Acceptance.LANO       
 And Acceptance.LANO=@P_ANO       
 And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo        
Order By Acceptance.CertificateNo            
        
GO


--14 August 2013
Drop function FL_SR_SchemeNo
GO
Create function FL_SR_SchemeNo(@p_UserID varchar(10), @P_SchemeNo varchar(10),@P_PolicyNo varchar(10))  
RETURNS Table  
AS RETURN  
(

Select Distinct S.SchemeNo, S.Description, S.Disc, S.DailyBasisF, s.sPeriod, s.AllowedF 
from acceptance as a
inner join cover as c on (a.cno=c.cno and c.OpenFlag=1) 
inner join Scheme_Master S on (S.TOC=C.TOC and S.SchemeNo Like @P_SchemeNo)
inner join SysUser on (SysUser.ID=@P_UserID)
Left Join Scheme_Branch S1 on (SysUser.Type<>'SUPERVISOR' and S1.SchemeNo=S.SchemeNo) 
where a.ano = a.lano and S.AllowedF=1 and A.AType not in ('A','C') and a.astatus = 'I' and a.PolicyNo Like @P_PolicyNo+'%' and a.ano not in (Select PANO from Acceptance Where Acceptance.PANO=a.ANO)
and (SysUser.Type='SUPERVISOR' or S1.Branch is null or S1.Branch in (Select Branch from SysUserBranch Where AllowedF=1 and ID=@P_UserID))
and (SysUser.Type='SUPERVISOR' or S.TOC in (Select TOC from SysUserTOC Where ID=@P_UserID))
)          

GO

DROP FUNCTION List20_Det
GO
    
CREATE FUNCTION List20_Det(@P_ANO as integer, @P_USERID as varchar(255), @P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_AStatus as varchar(1))       
RETURNS TABLE    
AS RETURN(    
    
SELECT 
 Cast(0 as bit) as ProcessFlag, 
 [Acceptance].[CertificateNo],     
 Acceptance.ESeqNo,    
 [Acceptance].[AName],     
 [Acceptance].[ANO],     
 [Acceptance].[REGNO],     
 [Acceptance].[ADATE],     
 [Acceptance].[LUSERID] as UserID,     
 [SysTab].[Currency],     
 [Acceptance].[ASTATUS],     
 [Acceptance].[ATYPE],     
 [Acceptance].[SDate],     
 [Acceptance].[EDate],     
 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,    
 Acceptance.ValueID,    
 Acceptance.ValueDesc,
 QPCalc.TSI,            
 QPCalc.OurShare,            
 QPCalc.Gross 
FROM     
 Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
 Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), 
 Cover,     
 SysTab
WHERE     
 [Cover].[CNO]=[Acceptance].[CNO]     
 And [Acceptance].[ANO]<>[Acceptance].[LANO]     
 And [Acceptance].[LANO]=@P_ANO    
 And [Cover].[ISType]<>'T'     
 And [Acceptance].[LUserID] Like @P_UserID    
 And [Acceptance].[LDate] between @P_SDate and @P_EDate     
 And ([Acceptance].AStatus=@P_AStatus or @P_AStatus='')     
)    
   
GO


DROP PROCEDURE List20
GO
    
CREATE PROCEDURE List20 (@P_USERID as varchar(255),@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_AStatus as varchar(1))         
AS        
SELECT  
 Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,       
 Cast(Acceptance.AName as varchar(128)) as Insured,       
 Cover.CNO,       
 Cover.CStatus,       
 Acceptance.lANO,       
 Acceptance.ANO,       
 Acceptance.REGNO,       
 Acceptance.ADATE,       
 Acceptance.LUSERID as USERID,       
 SysTab.Currency,       
 Acceptance.ASTATUS,       
 Acceptance.ATYPE,       
 Acceptance.SDate,       
 Acceptance.EDate,       
 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,       
 Cover.ISType,       
 Acceptance.Renewal,       
 Acceptance.ESeqNo,       
 Acceptance.PolicyNo,       
 Acceptance.CertificateNo,
 QPCalc.TSI,            
 QPCalc.OurShare,            
 QPCalc.Gross       
FROM  Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE  Cover.CNO=Acceptance.CNO       
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)       
 And Cover.ISType<>'T'       
 And Acceptance.LUserID Like @P_UserID      
 And Acceptance.LDate between @P_SDate and @P_EDate      
 And (Acceptance.AStatus=@P_AStatus or @P_AStatus='')  
  
union      

Select 
 Cast(0 as bit) as ProcessFlag,      
 Cover.COVERNO,       
 Cast(Acceptance.AName as varchar(128)) as Insured,       
 Cover.CNO,       
 Cover.CStatus,       
 Acceptance.lANO,       
 Acceptance.ANO,       
 Acceptance.REGNO,       
 Acceptance.ADATE,       
 Acceptance.LUSERID as USERID,       
 SysTab.Currency,       
 Acceptance.ASTATUS,       
 Acceptance.ATYPE,       
 Acceptance.SDate,       
 Acceptance.EDate,       
 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,       
 Cover.ISType,       
 Acceptance.Renewal,       
 Acceptance.ESeqNo,       
 Acceptance.PolicyNo,       
 Acceptance.CertificateNo,
 QPCalc.TSI,            
 QPCalc.OurShare,            
 QPCalc.Gross       
FROM  Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.pStatus='C'), Cover, SysTab, Acceptance As Acceptance_Detail   
WHERE  Cover.CNO=Acceptance.CNO       
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO      
 And Cover.ISType<>'T'       
 And Acceptance_Detail.LUserID Like @P_UserID      
 And Acceptance_Detail.LDate between @P_SDate and @P_EDate  
 And (Acceptance_Detail.AStatus=@P_AStatus or @P_AStatus='')       

GO

DROP PROCEDURE List03
GO
CREATE  PROCEDURE List03(@P_USERID as varchar(255))     
AS    
SELECT Cast(0 as bit) as ProcessFlag,     
 Cover.COVERNO,     
 Cast(Acceptance.AName as varchar(128)) as Insured,     
 Cover.CNO,     
 Cover.CStatus,     
 Acceptance.lANO,     
 Acceptance.ANO,     
 Acceptance.REGNO,     
 Acceptance.ADATE,     
 Acceptance.LUSERID as USERID,     
 SysTab.Currency,     
 QPCalc.TSI,     
 QPCalc.OurShare,     
 QPCalc.Gross,     
 Acceptance.ASTATUS,     
 Acceptance.ATYPE,     
 Acceptance.SDate,     
 Acceptance.EDate,     
 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,     
 Cover.ISType,     
 Acceptance.Renewal,     
 Acceptance.ESeqNo,     
 Acceptance.PolicyNo,     
 Acceptance.CertificateNo    
FROM  Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab  
WHERE  Cover.CNO=Acceptance.CNO       
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)     
 And Acceptance.AStatus Not in ('W','T')  
 And Cover.ISType<>'T'     
 And Acceptance.LUserID Like @P_UserID    
    
union    
    
SELECT Cast(0 as bit) as ProcessFlag,     
 Cover.COVERNO,     
 Cast(Acceptance.AName as varchar(128)) as Insured,     
 Cover.CNO,     
 Cover.CStatus,     
 Acceptance.lANO,     
 Acceptance.ANO,     
 Acceptance.REGNO,     
 Acceptance.ADATE,     
 Acceptance.LUSERID as USERID,     
 SysTab.Currency,     
 0 as TSI,
 0 as OurShare,
 0 as Gross,
 Acceptance.ASTATUS,     
 Acceptance.ATYPE,     
 Acceptance.SDate,     
 Acceptance.EDate,     
 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,     
 Cover.ISType,     
 Acceptance.Renewal,     
 Acceptance.ESeqNo,     
 Acceptance.PolicyNo,     
 Acceptance.CertificateNo    
FROM  Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Cover, SysTab
WHERE  Cover.CNO=Acceptance.CNO      
 And Cover.ISType<>'T'     
 And Acceptance.ANO in 
 (
 Select Top 1 Acceptance_Detail.LANO from Acceptance as Acceptance_Detail 
 Where Acceptance_Detail.LANO=Acceptance.ANO and Acceptance_Detail.LUserID Like @P_UserID  and Acceptance_Detail.LANO<>Acceptance_Detail.ANO And Acceptance_Detail.AStatus Not in ('W','T')   
 )
    
GO

DROP FUNCTION List03_Det 
GO  
CREATE FUNCTION List03_Det (@P_ANO as integer, @P_USERID as varchar(255))     
RETURNS TABLE    
AS RETURN(    
    
SELECT Cast(0 as bit) as ProcessFlag,    
 [Acceptance].[CertificateNo],     
 Acceptance.ESeqNo,    
 [Acceptance].[AName],     
 [Acceptance].[ANO],     
 [Acceptance].[REGNO],     
 [Acceptance].[ADATE],     
 [Acceptance].[LUSERID] as UserID,     
 [SysTab].[Currency],     
 [QPCalc].[TSI],     
 [QPCalc].[OurShare],     
 [QPCalc].[Gross],     
 [Acceptance].[ASTATUS],     
 [Acceptance].[ATYPE],     
 [Acceptance].[SDate],     
 [Acceptance].[EDate],     
 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,    
  Acceptance.ValueID,    
  Acceptance.ValueDesc    
FROM     
 Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
 Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'),   
 Cover,     
 SysTab  
WHERE     
 [Cover].[CNO]=[Acceptance].[CNO]     
 And [Acceptance].[ANO]<>[Acceptance].[LANO]     
 And [Acceptance].[LANO]=@P_ANO    
 And [Acceptance].AStatus Not in ('W','T')  
 And [Cover].[ISType]<>'T'     
 And [Acceptance].[LUserID] Like @P_UserID    
    
)    

GO

DROP PROCEDURE ListDet01
GO
  
CREATE PROCEDURE ListDet01 (@P_ANO as integer)        
AS        
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance        
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO        
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1)    

Union

SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross        
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance        
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO        
And (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 

Union

SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross        
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance        
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO        
And (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1)   
Order By Acceptance.CertificateNo  
GO

DROP PROCEDURE ListDet02
GO
  
CREATE PROCEDURE ListDet02 (@P_ANO as integer)        
AS        
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross    
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO And Acceptance.ANO=@P_ANO  
Order By Acceptance.CertificateNo  
GO


DROP PROCEDURE ListDet03
GO
  
CREATE PROCEDURE ListDet03 (@P_ANO as integer,@P_SDATE as smalldatetime, @P_EDATE as smalldatetime) 
AS        
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross        
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance        
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO        
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1)    
And Acceptance.ADate Between @P_Sdate and @P_EDate  

Union

SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross        
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance        
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO        
And (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1)    
And Acceptance.ADate Between @P_Sdate and @P_EDate  

Union

SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross        
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance        
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO        
And (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.ADate Between @P_Sdate and @P_EDate 
Order By Acceptance.CertificateNo  
  
GO

DROP PROCEDURE ListDet04
GO
  
CREATE PROCEDURE ListDet04 (@P_ANO as integer,@P_FCERTNO as varchar(20), @P_LCERTNO as varchar(20))          
AS        
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance          
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO          
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1)      
And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo          

Union

SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance          
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO          
And (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1)        
And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo          

Union

SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance          
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO          
And (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1)
And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo       
Order By Acceptance.CertificateNo
  
GO  

DROP PROCEDURE ListDet_By_ANO 
GO
CREATE PROCEDURE ListDet_By_ANO (@P_ANO as integer)     
AS    
SELECT Cast(0 as bit) as ProcessFlag,
Acceptance.CertificateNo, 
Acceptance.ESeqNo, 
Acceptance.AName, 
Acceptance.ANO, 
Acceptance.REGNO, 
Acceptance.ADATE, 
Acceptance.LUSERID as USERID, 
SysTab.Currency, 
QPCalc.TSI, 
QPCalc.OurShare, 
QPCalc.Gross, 
Acceptance.ASTATUS, 
Acceptance.ATYPE, 
Acceptance.SDate, 
Acceptance.EDate, 
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,    
Acceptance.ValueID,    
Acceptance.ValueDesc    
FROM 
 Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'),   
 Cover,     
 SysTab  
WHERE Cover.CNO=Acceptance.CNO And Acceptance.ANO=@P_ANO    

GO
DROP PROCEDURE MList12
go
CREATE PROCEDURE MList12 (@P_ANO as integer)     
AS     
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Acceptance.AName, Acceptance.CertificateNo, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.LANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross        
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO And Acceptance.ANO=@P_ANO         
GO

DROP PROCEDURE MListDet_By_ANO
GO
CREATE PROCEDURE MListDet_By_ANO (@P_ANO as integer)     
AS     
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Acceptance.AName, Acceptance.CertificateNo, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.LANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross        
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO And Acceptance.ANO=@P_ANO         

GO

DROP PROCEDURE MListDet01
GO    
CREATE PROCEDURE MListDet01(@P_ANO as Integer)       
AS      
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Acceptance.AName, Acceptance.CertificateNo, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.LANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross        
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE       
 Cover.CNO=Acceptance.CNO       
 And Acceptance.ANO<>Acceptance.LANO       
 And Acceptance.LANO=@P_ANO      
Order By Acceptance.CertificateNo  

GO

DROP PROCEDURE MLISTDET02
GO  
CREATE PROCEDURE MLISTDET02(@P_ANO as Integer)       
AS      
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Acceptance.AName, Acceptance.CertificateNo, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.LANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross        
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE       
 Cover.CNO=Acceptance.CNO       
 And Acceptance.ANO<>Acceptance.LANO       
 And Acceptance.ANO=@P_ANO      
Order By Acceptance.CertificateNo     

GO

DROP PROCEDURE MLISTDET03
GO   
CREATE PROCEDURE MLISTDET03(@P_ANO as Integer, @P_SDATE AS SMALLDATETIME, @P_EDATE AS SMALLDATETIME)       
AS      
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Acceptance.AName, Acceptance.CertificateNo, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.LANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE,Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross        
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE       
 Cover.CNO=Acceptance.CNO       
 And Acceptance.ANO<>Acceptance.LANO       
 And Acceptance.LANO=@P_ANO       
 AND (ACCEPTANCE.SDATE BETWEEN @P_SDATE AND @P_EDATE)      
Order By Acceptance.CertificateNo           
GO

DROP PROCEDURE MListDet04
GO
CREATE PROCEDURE MListDet04(@P_ANO as integer,@P_FCERTNO as varchar(20), @P_LCERTNO as varchar(20))          
AS          
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Acceptance.AName, Acceptance.CertificateNo, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.LANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross        
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE         
 Cover.CNO=Acceptance.CNO         
 And Acceptance.ANO<>Acceptance.LANO         
 And Acceptance.LANO=@P_ANO         
 And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo          
Order By Acceptance.CertificateNo              

GO

Drop Procedure SMListSR
GO
CREATE PROCEDURE SMListSR(@P_ID as int)    
AS 
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Cover.Insured, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.lANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Year(Acceptance.SDate) AS RYear, Cover.OpenFlag, Cover.ISType  
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, TOC, SysRequest  , Service
Where cover.CNO = acceptance.CNO  
And QPCalc.ANO=Acceptance.ANO  
And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)  
And SysRequest.ID=@P_ID  
And SysRequest.Param2 in ('SVC')  
And SysRequest.Param3=service.sNO   
And Acceptance.ANO=Service.PANO     
And TOC.TOC=COVER.TOC  

Union  

SELECT  Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Cover.Insured, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.lANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Year(Acceptance.SDate) AS RYear, Cover.OpenFlag, Cover.ISType  
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, Acceptance As Acceptance_Detail, TOC, SysRequest  , Service   
Where cover.CNO = acceptance.CNO  
And QPCalc.ANO=Acceptance.ANO  
And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO  
And SysRequest.ID=@P_ID  
And SysRequest.Param2 in ('SVC')  
And SysRequest.Param3=Service.SNO    
And Acceptance_Detail.ANO=Service.PANO     
And TOC.TOC=COVER.TOC  

go

DROP function FL_Underwriter
GO  
CREATE function FL_Underwriter(@P_ANO int)        
RETURNS Table          
AS RETURN          
(        
 Select SysUser.*
 From sysuser, Acceptance
 Where SysUser.Role in ('COMMON','UNDERWRITER') and SysUser.AllowedF=1 and Acceptance.ANO=@P_ANO
 and (SysUser.Type='SUPERVISOR' or Acceptance.Branch in (Select S.Branch from SysUserBranch S Where S.AllowedF=1 and S.ID=SysUser.ID))    
)    

GO

ALTER Function FL_CL_DED (@P_CNO AS INTEGER)    
RETURNS TABLE    
AS RETURN    
(    
SELECT DISTINCT ACCDED.DCODE, ACCDED.REMARKS, ACCDED.CURRENCY,  CLAIM.PAYMENT, CLAIM.CNO      
From CLAIM, ACCDED, Col, acceptance      
WHERE CLAIM.CNO=@P_CNO      
AND ACCDED.ANO=CLAIM.ANO AND ACCEPTANCE.ANO=ACCDED.ANO      
AND ((ACCDED.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ACCDED.SDATE<CLAIM.LOSSDATE or (ACCDED.SDATE=CLAIM.LOSSDATE AND '12:00'<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))         
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)=CLAIM.LOSSDATE AND '12:00'>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))        
AND COL.COL=CLAIM.COL AND ACCDED.TOR=COL.TOR          
)   
GO



DROP function FN_BUDGET_TOC
GO
Create function FN_BUDGET_TOC(@P_PDATE as smalldatetime)        
RETURNS TABLE        
AS RETURN        
(        
Select B.Branch, B.Year, B.Account, B.TOC,   
Max(B.Month_1) as Month_1,  
Max(B.Month_2) as Month_2,  
Max(B.Month_3) as Month_3,  
Max(B.Month_4) as Month_4,  
Max(B.Month_5) as Month_5,  
Max(B.Month_6) as Month_6,  
Max(B.Month_7) as Month_7,  
Max(B.Month_8) as Month_8,  
Max(B.Month_9) as Month_9,  
Max(B.Month_10) as Month_10,  
Max(B.Month_11) as Month_11,  
Max(B.Month_12) as Month_12,  
--Max(B.Actual_1)+sum(Case When Month(A.Date)=1 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_1,  
--Max(B.Actual_2)+sum(Case When Month(A.Date)=2 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_2,  
--Max(B.Actual_3)+sum(Case When Month(A.Date)=3 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_3,  
--Max(B.Actual_4)+sum(Case When Month(A.Date)=4 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_4,  
--Max(B.Actual_5)+sum(Case When Month(A.Date)=5 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_5,  
--Max(B.Actual_6)+sum(Case When Month(A.Date)=6 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_6,  
--Max(B.Actual_7)+sum(Case When Month(A.Date)=7 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_7,  
--Max(B.Actual_8)+sum(Case When Month(A.Date)=8 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_8,  
--Max(B.Actual_9)+sum(Case When Month(A.Date)=9 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_9,  
--Max(B.Actual_10)+sum(Case When Month(A.Date)=10 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_10,  
--Max(B.Actual_11)+sum(Case When Month(A.Date)=11 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_11,  
--Max(B.Actual_12)+sum(Case When Month(A.Date)=12 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_12  
sum(Case When Month(A.Date)=1 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_1,  
sum(Case When Month(A.Date)=2 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_2,  
sum(Case When Month(A.Date)=3 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_3,  
sum(Case When Month(A.Date)=4 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_4,  
sum(Case When Month(A.Date)=5 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_5,  
sum(Case When Month(A.Date)=6 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_6,  
sum(Case When Month(A.Date)=7 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_7,  
sum(Case When Month(A.Date)=8 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_8,  
sum(Case When Month(A.Date)=9 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_9,  
sum(Case When Month(A.Date)=10 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_10,  
sum(Case When Month(A.Date)=11 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_11,  
sum(Case When Month(A.Date)=12 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_12  
from Budget_TOC B
Inner Join Account on (Account.Account=B.Account and Account.Post_Flag=1)
Left Join Admlink A on (A.Branch=B.Branch and Year(A.Date)=B.Year and A.Date<=@P_PDate and A.Code=B.TOC)
--Left Join nVoucher V on (V.Branch=B.Branch and Year(V.Date)=B.Year and V.Date<=@P_PDate and V.Voucher=A.Voucher and V.Status='U') 
Left Join nVoucher V on (V.Branch=B.Branch and Year(V.Date)=B.Year and V.Date<=@P_PDate and V.Voucher=A.Voucher) 
Left Join nJournal J on (J.Voucher=V.Voucher and J.Account=B.Account)
Group By B.Branch, B.Year, B.Account, B.TOC  
)        

GO

DROP FUNCTION FN_UserBusinessSource 
GO
CREATE FUNCTION FN_UserBusinessSource (@P_UserID as varchar(10))      
RETURNS TABLE      
as RETURN(      
Select P.*, S1.ID as SID, S1.Name as SName
From Profile P 
Left Join SysUserAssignment S on (S.AssType='SOURCE' and S.PID=P.ID and (S.ID=@P_UserID or @P_UserID=''))
Left join SysUser S1 on (S1.ID=S.ID and S1.AllowedF=1)
Where @P_UserID='' 
or coalesce(S1.ID,'')=@P_UserID
or P.ID not in (Select PID from SysUserAssignment S Where S.AssType='SOURCE' and S.ID<>@P_UserID)
)    

GO

DROP PROCEDURE QREFERENCE_VALUE
GO
CREATE PROCEDURE QREFERENCE_VALUE(@P_CNO as Int, @P_INO AS Int, @P_KOL AS VARCHAR(10))       
AS      
      
SELECT KOL.KOL, KOL.DESCRIPTION, KOL.CATEGORY, Max(coalesce(KOLVALUE.COST,0)) as Cost, KOL.VATF, KOL.TAXF
FROM ICOVER
INNER JOIN KOL ON (KOL.ALLOWEDF=1 and KOL.TOI=ICOVER.TOI AND (KOL.KOL LIKE @P_KOL or KOL.DESCRIPTION LIKE @P_KOL))
LEFT JOIN CLINFO ON (CLINFO.CNO=@P_CNO AND CLINFO.INO=ICOVER.INO)
LEFT JOIN KOLVALUE ON (
KOLVALUE.KOL=KOL.KOL
And (coalesce(KOLVALUE.ValueID1,'')='' Or coalesce(CLINFO.ValueID1,'')=coalesce(KOLVALUE.ValueID1,''))     
And (coalesce(KOLVALUE.ValueID2,'')='' Or coalesce(CLINFO.ValueID2,'')=coalesce(KOLVALUE.ValueID2,''))     
And (coalesce(KOLVALUE.ValueID3,'')='' Or coalesce(CLINFO.ValueID3,'')=coalesce(KOLVALUE.ValueID3,''))     
And (coalesce(KOLVALUE.ValueID4,'')='' Or coalesce(CLINFO.ValueID4,'')=coalesce(KOLVALUE.ValueID4,''))     
And (coalesce(KOLVALUE.ValueID5,'')='' Or coalesce(CLINFO.ValueID5,'')=coalesce(KOLVALUE.ValueID5,''))     
And (coalesce(KOLVALUE.ValueID6,'')='' Or coalesce(CLINFO.ValueID6,'')=coalesce(KOLVALUE.ValueID6,''))     
And (coalesce(KOLVALUE.ValueID7,'')='' Or coalesce(CLINFO.ValueID7,'')=coalesce(KOLVALUE.ValueID7,''))     
And (coalesce(KOLVALUE.ValueID8,'')='' Or coalesce(CLINFO.ValueID8,'')=coalesce(KOLVALUE.ValueID8,''))     
And (coalesce(KOLVALUE.ValueID9,'')='' Or coalesce(CLINFO.ValueID9,'')=coalesce(KOLVALUE.ValueID9,''))     
And (coalesce(KOLVALUE.ValueID10,'')='' Or coalesce(CLINFO.ValueID10,'')=coalesce(KOLVALUE.ValueID10,''))     
And (coalesce(KOLVALUE.ValueID11,'')='' Or coalesce(CLINFO.ValueID11,'')=coalesce(KOLVALUE.ValueID11,''))     
And (coalesce(KOLVALUE.ValueID12,'')='' Or coalesce(CLINFO.ValueID12,'')=coalesce(KOLVALUE.ValueID12,''))     
And (coalesce(KOLVALUE.ValueID13,'')='' Or coalesce(CLINFO.ValueID13,'')=coalesce(KOLVALUE.ValueID13,''))     
And (coalesce(KOLVALUE.ValueID14,'')='' Or coalesce(CLINFO.ValueID14,'')=coalesce(KOLVALUE.ValueID14,''))     
And (coalesce(KOLVALUE.ValueID15,'')='' Or coalesce(CLINFO.ValueID15,'')=coalesce(KOLVALUE.ValueID15,''))     
)
WHERE ICOVER.INO=@P_INO
Group By KOL.KOL, KOL.DESCRIPTION, KOL.CATEGORY, KOL.VATF, KOL.TAXF
    
GO

DROP Procedure QRDOCLIST

GO
  
CREATE Procedure QRDOCLIST(@P_Request as varchar(20))          
as          
Select *    
from      
(            
Select Cast(0 as bit) as ProcessFlag, DOCTYPE.DOCTYPE, DOCTYPE.DESCRIPTION, Cast(0 as bit) as AvailableF
from DocType
Where DocType.Purpose='PAYMENT' and DocType.AllowedF=1 and DocType not in (Select DocType from RDocList Where Request=@P_Request)

Union All

select RDOCLIST.AvailableF as ProcessFlag, RDOCLIST.DOCTYPE, RDOCLIST.Description, RDOCLIST.AvailableF as AvailableF
from RDOCLIST 
Where RDOCLIST.Request=@P_Request  

) RDOCLIST      
Order By RDOCLIST.DOCTYPE

GO

DROP PROCEDURE ListDet05
GO    
CREATE PROCEDURE ListDet05 (@P_ANO as integer,@P_FBATCHNO as varchar(20), @P_LBATCHNO as varchar(20))            
AS          
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross  
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance            
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO            
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1)        
And Acceptance.BatchNo Between @P_FBatchNo and @P_LBatchNo            
  
Union  
  
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross  
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance            
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO            
And (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1)          
And Acceptance.BatchNo Between @P_FBatchNo and @P_LBatchNo            
  
Union  
  
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross  
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance            
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO            
And (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1)  
And Acceptance.BatchNo Between @P_FBatchNo and @P_LBatchNo         
Order By Acceptance.CertificateNo  
      
GO

DROP PROCEDURE List_Of_Detail_AccReg 
GO
CREATE PROCEDURE List_Of_Detail_AccReg (@P_REGID varchar(10),@P_FLDID varchar(255), @P_VALUEID varchar(255), @P_VALUEID1 varchar(255), @P_VALUEID2 varchar(255), @P_VALUEID3 varchar(255), @P_VALUEID4 varchar(255), @P_VALUEID5 varchar(255), @P_VALUEID6 varchar(255))  
As  
SELECT ACCEPTANCE.FLDID, ACCEPTANCE.VALUEID, ACCEPTANCE.VALUEDESC, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, Cast(Acceptance.AName as varchar(128)) as Insured, CAMOUNT AS CP, DAMOUNT-CDAMOUNT AS DC, XPAMOUNT-CXPAMOUNT AS XP, QSRAMOUNT+AFRAMOUNT+SAMOUNT as [OR], QAMOUNT AS QS, SP1AMOUNT-CSP1AMOUNT AS SP1, SP2AMOUNT-CSP2AMOUNT AS SP2, SP3AMOUNT-CSP3AMOUNT AS SP3, ACCEPTANCE.ANO  
FROM Cover, Acceptance, RArrHeader, GenDTab  
WHERE Cover.CNO=Acceptance.CNO And RArrHeader.Status='A' And RArrHeader.ANO=Acceptance.ANO And Acceptance.REGID=@P_REGID and Acceptance.FLDID=GenDTab.FLDID And Acceptance.ValueID=GenDTab.ValueID   
 And GenDTab.FLDID=@P_FLDID   
 And (GenDTab.ValueID Like '%'+@P_ValueID + '%' or GenDTab.Description Like '%'+@P_ValueID+'%')  
 And (GenDTab.ValueID1 Like @P_ValueID1 + '%' or GenDTab.ValueDesc1 Like @P_ValueID1 + '%')  
 And (GenDTab.ValueID2 Like @P_ValueID2 + '%' or GenDTab.ValueDesc2 Like @P_ValueID2 + '%')  
 And (GenDTab.ValueID3 Like @P_ValueID3 + '%' or GenDTab.ValueDesc3 Like @P_ValueID3 + '%')  
 And (GenDTab.ValueID4 Like @P_ValueID4 + '%' or GenDTab.ValueDesc4 Like @P_ValueID4 + '%')  
 And (GenDTab.ValueID5 Like @P_ValueID5 + '%' or GenDTab.ValueDesc5 Like @P_ValueID5 + '%')  
 And (GenDTab.ValueID6 Like @P_ValueID6 + '%' or GenDTab.ValueDesc6 Like @P_ValueID6 + '%')  
  
  
GO
DROP PROCEDURE List_Of_Detail_AccReg_Blank  
GO  
CREATE PROCEDURE List_Of_Detail_AccReg_Blank (@P_REGID varchar(10), @P_FLDID varchar(255), @P_VALUEID varchar(255))  
As  
SELECT ACCEPTANCE.FLDID, ACCEPTANCE.VALUEID, ACCEPTANCE.VALUEDESC, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, Cast(Acceptance.AName as varchar(128)) as Insured, CAMOUNT AS CP, DAMOUNT-CDAMOUNT AS DC, XPAMOUNT-CXPAMOUNT AS XP, QSRAMOUNT+AFRAMOUNT+SAMOUNT AS [OR], QAMOUNT AS QS, SP1AMOUNT-CSP1AMOUNT AS SP1, SP2AMOUNT-CSP2AMOUNT AS SP2, SP3AMOUNT-CSP3AMOUNT AS SP3, ACCEPTANCE.ANO  
FROM Cover, Acceptance, RArrHeader  
WHERE Cover.CNO=Acceptance.CNO And RArrHeader.Status='A' And RArrHeader.ANO=Acceptance.ANO And Acceptance.RegID=@P_REGID and Acceptance.FLDID=@P_FLDID and Acceptance.ValueID like @P_VALUEID+'%'  
  
GO


DROP PROCEDURE List_Of_Summary_AccReg
GO  
  
CREATE PROCEDURE List_Of_Summary_AccReg(@P_REGID varchar(10), @P_FLDID varchar(255), @P_VALUEID varchar(255), @P_VALUEID1 varchar(255), @P_VALUEID2 varchar(255), @P_VALUEID3 varchar(255), @P_VALUEID4 varchar(255), @P_VALUEID5 varchar(255), @P_VALUEID6 varchar(255))  
As  
SELECT sum(CAMOUNT) AS CP, sum(DAMOUNT-CDAMOUNT) AS DC, sum(XPAMOUNT-CXPAMOUNT) AS XP, sum(QSRAMOUNT+AFRAMOUNT+SAMOUNT) as [OR], sum(QAMOUNT) AS QS, sum(SP1AMOUNT-CSP1AMOUNT) AS SP1, sum(SP2AMOUNT-CSP2AMOUNT) AS SP2, sum(SP3AMOUNT-CSP3AMOUNT) AS SP3  
FROM Cover, Acceptance, RArrHeader, GenDTab  
WHERE Cover.CNO=Acceptance.CNO And RArrHeader.Status='A' And RArrHeader.ANO=Acceptance.ANO And Acceptance.RegID=@P_REGID and Acceptance.FLDID=GenDTab.FLDID And Acceptance.ValueID=GenDTab.ValueID   
 And GenDTab.FLDID=@P_FLDID   
 And (GenDTab.ValueID Like '%'+@P_ValueID + '%' or GenDTab.Description Like '%'+@P_ValueID+'%')  
 And (GenDTab.ValueID1 Like @P_ValueID1 + '%' or GenDTab.ValueDesc1 Like @P_ValueID1 + '%')  
 And (GenDTab.ValueID2 Like @P_ValueID2 + '%' or GenDTab.ValueDesc2 Like @P_ValueID2 + '%')  
 And (GenDTab.ValueID3 Like @P_ValueID3 + '%' or GenDTab.ValueDesc3 Like @P_ValueID3 + '%')  
 And (GenDTab.ValueID4 Like @P_ValueID4 + '%' or GenDTab.ValueDesc4 Like @P_ValueID4 + '%')  
 And (GenDTab.ValueID5 Like @P_ValueID5 + '%' or GenDTab.ValueDesc5 Like @P_ValueID5 + '%')  
 And (GenDTab.ValueID6 Like @P_ValueID6 + '%' or GenDTab.ValueDesc6 Like @P_ValueID6 + '%')  
  
  
GO

DROP PROCEDURE List_Of_Summary_AccReg_Blank
GO
CREATE PROCEDURE List_Of_Summary_AccReg_Blank(@P_REGID varchar(10), @P_FLDID varchar(255), @P_VALUEID varchar(255))  
As  
SELECT sum(CAMOUNT) AS CP, sum(DAMOUNT-CDAMOUNT) AS DC, sum(XPAMOUNT-CXPAMOUNT) AS XP, sum(QSRAMOUNT+AFRAMOUNT+SAMOUNT) as [OR], sum(QAMOUNT) AS QS, sum(SP1AMOUNT-CSP1AMOUNT) AS SP1, sum(SP2AMOUNT-CSP2AMOUNT) AS SP2, sum(SP3AMOUNT-CSP3AMOUNT) AS SP3  
FROM Cover, Acceptance, RArrHeader  
WHERE Cover.CNO=Acceptance.CNO And RArrHeader.Status='A' And RArrHeader.ANO=Acceptance.ANO And Acceptance.RegID=@P_REGID And Acceptance.FLDID=@P_FLDID And Acceptance.ValueID like @P_VALUEID+'%'  
  
  go



DROP PROCEDURE List01
GO
CREATE  PROCEDURE List01(@P_USERID as varchar(255))       
AS  
SELECT Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.LUSERID as USERID,   
 SysTab.Currency,   
 QPCalc.TSI,   
 QPCalc.OurShare,   
 QPCalc.Gross,   
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear,   
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc  
WHERE  Cover.CNO=Acceptance.CNO   
 And QPCalc.ANO=Acceptance.ANO   
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)   
 And Acceptance.AStatus='W'   
 And Cover.ISType<>'T'   
 And Cover.CStatus='A'  
 And Acceptance.LUserID Like @P_UserID
 
GO

DROP FUNCTION List01_Det 
GO
CREATE  FUNCTION List01_Det (@P_ANO AS INTEGER, @P_UserID as varchar(255))   
RETURNS TABLE  
AS RETURN(  
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],   
 Acceptance.ESeqNo,  
 [Acceptance].[AName],   
 [Acceptance].[ANO],   
 [Acceptance].[REGNO],   
 [Acceptance].[ADATE],   
 [Acceptance].[LUSERID] as UserID,   
 [SysTab].[Currency],   
 [QPCalc].[TSI],   
 [QPCalc].[OurShare],   
 [QPCalc].[Gross],   
 [Acceptance].[ASTATUS],   
 [Acceptance].[ATYPE],   
 [Acceptance].[SDate],   
 [Acceptance].[EDate],   
 Year([Acceptance].[SDate]) AS RYear,  
  Acceptance.ValueID,  
  Acceptance.ValueDesc  
FROM Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc  
WHERE   
 [Cover].[CNO]=[Acceptance].[CNO]   
 And [QPCalc].[ANO]=[Acceptance].[ANO]   
 And [Acceptance].[ANO]<>[Acceptance].[LANO]   
 And [Acceptance].[LANO]=@P_ANO  
 And [Acceptance].[AStatus]='W'   
 And [Cover].[ISType]<>'T'   
 And [Cover].[CStatus]='A'  
 And Acceptance.LuserID Like @P_UserID
)  
  
GO  

DROP PROCEDURE List02   
GO
CREATE  PROCEDURE List02 (@P_UserID varchar(255), @pEDate as smalldatetime)   
AS  
SELECT Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.LUSERID as USERID,   
 SysTab.Currency,   
 QPCalc.TSI,   
 QPCalc.OurShare,   
 QPCalc.Gross,   
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear,   
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc  
WHERE  Cover.CNO=Acceptance.CNO   
 And QPCalc.ANO=Acceptance.ANO   
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)   
 And Acceptance.AStatus='W'   
 And Cover.ISType<>'T'   
 And Cover.CStatus='A'   
 And Cover.CDate+Cover.Validation<=@pEDate  
 And Acceptance.LUserID Like @P_UserID
 
GO

DROP FUNCTION List02_Det 
GO
CREATE   FUNCTION List02_Det (@P_ANO as integer,@P_UserID as varchar(255), @pEDate as smalldatetime)   
RETURNS TABLE  
AS RETURN(  
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],   
 Acceptance.ESeqNo,  
 [Acceptance].[AName],   
 [Acceptance].[ANO],   
 [Acceptance].[REGNO],   
 [Acceptance].[ADATE],   
 [Acceptance].[LUSERID] as UserID,   
 [SysTab].[Currency],   
 [QPCalc].[TSI],   
 [QPCalc].[OurShare],   
 [QPCalc].[Gross],   
 [Acceptance].[ASTATUS],   
 [Acceptance].[ATYPE],   
 [Acceptance].[SDate],   
 [Acceptance].[EDate],   
 Year([Acceptance].[SDate]) AS RYear,  
  Acceptance.ValueID,  
  Acceptance.ValueDesc  
FROM   
 Acceptance,   
 Cover,   
 SysTab,   
 QMasterAcceptance_PCalc() AS QPCalc  
WHERE   
 [Cover].[CNO]=[Acceptance].[CNO]   
 And [QPCalc].[ANO]=[Acceptance].[ANO]   
 And [Acceptance].[ANO]<>[Acceptance].[LANO]   
 And [Acceptance].[LANO]=@P_ANO  
 And [Acceptance].[AStatus]='W'   
 And [Cover].[ISType]<>'T'   
 And [Cover].[CStatus]='A'   
 And [Cover].[CDate]+[Cover].[Validation]<=@pEDate  
 And Acceptance.LUserID like @P_UserID
)  

GO

DROP PROCEDURE List02A   
GO
CREATE  PROCEDURE List02A (@P_UserID as varchar(255), @pEDate as smalldatetime)   
AS  
SELECT Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.LUSERID as USERID,   
 SysTab.Currency,   
 QPCalc.TSI,   
 QPCalc.OurShare,   
 QPCalc.Gross,   
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear,   
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader  
WHERE  Cover.CNO=Acceptance.CNO   
 And QPCalc.ANO=Acceptance.ANO  
 And RArrHeader.ANO=Acceptance.ANO  
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)   
 And Acceptance.AStatus='W'   
 And Cover.ISType<>'T'   
 And Cover.CStatus='A'   
 And Cover.CDate+Cover.Validation<=@pEDate  
 And RArrHeader.FShare<>0  
 And Acceptance.LUserID Like @P_UserID

union  
  
SELECT Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.LUSERID as USERID,   
 SysTab.Currency,   
 QPCalc.TSI,   
 QPCalc.OurShare,   
 QPCalc.Gross,   
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear,   
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader, Acceptance As Acceptance_Detail  
WHERE  Cover.CNO=Acceptance.CNO   
 And QPCalc.ANO=Acceptance.ANO   
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO  
 And RArrHeader.ANO=Acceptance_Detail.ANO  
 And Acceptance_Detail.AStatus='W'   
 And Cover.ISType<>'T'   
 And Cover.CStatus='A'   
 And Cover.CDate+Cover.Validation<=@pEDate  
 And RArrHeader.FShare<>0  
 And Acceptance_Detail.LUserID Like @P_UserID  

GO

DROP FUNCTION List02A_Det 
GO
CREATE   FUNCTION List02A_Det (@P_ANO as integer,@P_UserID as varchar(255), @pEDate as smalldatetime)   
RETURNS TABLE  
AS RETURN(  
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],   
 Acceptance.ESeqNo,  
 [Acceptance].[AName],   
 [Acceptance].[ANO],   
 [Acceptance].[REGNO],   
 [Acceptance].[ADATE],   
 [Acceptance].[LUSERID] as UserID,   
 [SysTab].[Currency],   
 [QPCalc].[TSI],   
 [QPCalc].[OurShare],   
 [QPCalc].[Gross],   
 [Acceptance].[ASTATUS],   
 [Acceptance].[ATYPE],   
 [Acceptance].[SDate],   
 [Acceptance].[EDate],   
 Year([Acceptance].[SDate]) AS RYear,  
  Acceptance.ValueID,  
  Acceptance.ValueDesc  
FROM   
 Acceptance,   
 Cover,   
 SysTab,   
 QMasterAcceptance_PCalc() AS QPCalc,  
 RArrHeader  
WHERE   
 [Cover].[CNO]=[Acceptance].[CNO]   
 And [QPCalc].[ANO]=[Acceptance].[ANO]   
 And [Acceptance].[ANO]<>[Acceptance].[LANO]   
 And [Acceptance].[LANO]=@P_ANO  
 And [Acceptance].[AStatus]='W'   
 And [Cover].[ISType]<>'T'   
 And [Cover].[CStatus]='A'   
 And [Cover].[CDate]+[Cover].[Validation]<=@pEDate  
 And RArrHeader.ANO=Acceptance.ANO and RArrHeader.FShare<>0  
 And Acceptance.LUserID Like @P_UserID
)  
  
GO

DROP PROCEDURE List04
GO
CREATE  PROCEDURE List04(@P_UserID as varchar(255))
AS  
SELECT Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.LUSERID as USERID,   
 SysTab.Currency,   
 QPCalc.TSI,   
 QPCalc.OurShare,   
 QPCalc.Gross,   
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear,   
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc  
WHERE  Cover.CNO=Acceptance.CNO   
 And QPCalc.ANO=Acceptance.ANO   
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)   
 And Acceptance.AStatus='W'   
 And Cover.ISType<>'T'   
 And Cover.CoverNoteF=1
 And Acceptance.LUserID Like @P_UserID

GO

DROP FUNCTION List04_Det 
GO
CREATE   FUNCTION List04_Det (@P_ANO as integer,@P_UserID as varchar(255))  
RETURNS TABLE  
AS RETURN(  
  
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],   
 Acceptance.ESeqNo,  
 [Acceptance].[AName],   
 [Acceptance].[ANO],   
 [Acceptance].[REGNO],   
 [Acceptance].[ADATE],   
 [Acceptance].[LUSERID] as UserID,   
 [SysTab].[Currency],   
 [QPCalc].[TSI],   
 [QPCalc].[OurShare],   
 [QPCalc].[Gross],   
 [Acceptance].[ASTATUS],   
 [Acceptance].[ATYPE],   
 [Acceptance].[SDate],   
 [Acceptance].[EDate],   
 Year([Acceptance].[SDate]) AS RYear,  
  Acceptance.ValueID,  
  Acceptance.ValueDesc  
FROM   
 Acceptance,   
 Cover,   
 SysTab,   
 QMasterAcceptance_PCalc() AS QPCalc  
WHERE   
 [Cover].[CNO]=[Acceptance].[CNO]   
 And [QPCalc].[ANO]=[Acceptance].[ANO]   
 And [Acceptance].[ANO]<>[Acceptance].[LANO]   
 And [Acceptance].[LANO]=@P_ANO  
 And [Acceptance].[AStatus]='W'   
 And [Cover].[ISType]<>'T'   
 And [Cover].[CoverNoteF]=1  
 And Acceptance.LUserID Like @P_UserID
)  

GO
DROP PROCEDURE List11a  
GO
CREATE PROCEDURE List11a(@P_UserID as varchar(255), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_AStatus as varchar(1))    
AS    
SELECT Cast(0 as bit) as ProcessFlag,     
 Cover.COVERNO,    
 Cast(Acceptance.AName as varchar(128)) as Insured,    
 Cover.CNO,    
 Cover.CStatus,    
 Acceptance.lANO,    
 Acceptance.ANO,    
 Acceptance.REGNO,    
 Acceptance.ADATE,    
 Acceptance.LUSERID as USERID,    
 SysTab.Currency,    
 QPCalc.TSI,    
 QPCalc.OurShare,    
 QPCalc.Gross,    
 Acceptance.ASTATUS,    
 Acceptance.ATYPE,    
 Acceptance.SDate,    
 Acceptance.EDate,    
 Year(Acceptance.SDate) AS RYear,    
 Cover.ISType,    
 Acceptance.Renewal,    
 Acceptance.ESeqNo,    
 Acceptance.PolicyNo,    
 acceptance.CertificateNo    
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader, SysUser
Where cover.CNO = acceptance.CNO    
 And QPCalc.ANO=Acceptance.ANO    
 And RArrHeader.ANO=Acceptance.ANO    
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)    
 And Cover.CStatus<>'C'    
 And Acceptance.AStatus='W'    
 And (RArrHeader.RAmount<>0 or RArrHeader.HoldF=1)    
 And Cover.ISType<>'T'    
 And Cover.TOC Like @P_TOC and Acceptance.Branch Like @P_Branch and (Acceptance.AStatus=@P_AStatus or @P_AStatus='')  
 And SysUser.ID=@P_UserID
 and (SysUser.Type='SUPERVISOR' or 
 (
 Acceptance.Branch in (Select Branch from SysUserBranch S Where S.ID=@P_UserID and S.Branch=Acceptance.Branch)
 and
 Cover.TOC in (Select TOC from SysUserTOC S Where S.ID=@P_UserID and S.TOC=Cover.TOC)
 ))
        
Union    
        
SELECT Cast(0 as bit) as ProcessFlag,     
 Cover.COVERNO,    
 Cast(Acceptance.AName as varchar(128)) as Insured,    
 Cover.CNO,    
 Cover.CStatus,    
 Acceptance.lANO,    
 Acceptance.ANO,    
 Acceptance.REGNO,    
 Acceptance.ADATE,    
 Acceptance.LUSERID as USERID,    
 SysTab.Currency,    
 QPCalc.TSI,    
 QPCalc.OurShare,    
 QPCalc.Gross,    
 Acceptance.ASTATUS,    
 Acceptance.ATYPE,    
 Acceptance.SDate,    
 Acceptance.EDate,    
 Year(Acceptance.SDate) AS RYear,    
 Cover.ISType,    
 Acceptance.Renewal,    
 Acceptance.ESeqNo,    
 Acceptance.PolicyNo,    
 acceptance.CertificateNo    
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader, Acceptance As Acceptance_Detail, SysUser
Where cover.CNO = acceptance.CNO    
 And QPCalc.ANO=Acceptance.ANO    
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO    
 And RArrHeader.ANO=Acceptance_Detail.ANO    
 And Cover.CStatus<>'C'    
 And Acceptance_Detail.AStatus='W'    
 And (RArrHeader.RAmount<>0 or RArrHeader.HoldF=1)    
 And Cover.ISType<>'T'    
 And Cover.TOC Like @P_TOC and Acceptance_Detail.Branch Like @P_Branch and (Acceptance_Detail.AStatus=@P_AStatus or @P_AStatus='')  
 And SysUser.ID=@P_UserID
 and (SysUser.Type='SUPERVISOR' or 
 (
 Acceptance_Detail.Branch in (Select Branch from SysUserBranch S Where S.ID=@P_UserID and S.Branch=Acceptance_Detail.Branch)
 and
 Cover.TOC in (Select TOC from SysUserTOC S Where S.ID=@P_UserID and S.TOC=Cover.TOC)
 )) 
      
GO
DROP FUNCTION List11A_Det 
GO
CREATE FUNCTION List11A_Det (@P_ANO as integer, @P_UserID as varchar(255), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_AStatus as varchar(1))    
RETURNS Table    
AS RETURN(    
      
SELECT Cast(0 as bit) as ProcessFlag,    
 Acceptance.CertificateNo,    
 Acceptance.ESeqNo,    
 Acceptance.AName,    
 Acceptance.ANO,    
 Acceptance.REGNO,    
 Acceptance.ADATE,    
 Acceptance.LUSERID as UserID,    
 SysTab.Currency,    
 QPCalc.TSI,    
 QPCalc.OurShare,    
 QPCalc.Gross,    
 Acceptance.ASTATUS,    
 Acceptance.ATYPE,    
 Acceptance.SDate,    
 Acceptance.EDate,    
 Year(Acceptance.SDate) AS RYear,    
 QPCalc.ValueID,    
 QPCalc.ValueDesc    
From    
 Acceptance,    
 Cover,    
 SysTab,    
 QMasterAcceptance_PCalc() AS QPCalc,    
 RARRHEADER,
 SysUser
Where    
 cover.CNO = acceptance.CNO    
 And Rarrheader.ANO = Acceptance.ANO    
 And QPCalc.ANO=Acceptance.ANO    
 And Acceptance.ANO<>Acceptance.LANO    
 And Acceptance.LANO=@P_ANO    
 And Cover.CStatus<>'C'    
 And Acceptance.AStatus='W'    
 And (RArrHeader.RAmount<>0 or RArrHeader.HoldF=1)    
 And Cover.ISType<>'T'    
 And Cover.TOC Like @P_TOC and Acceptance.Branch Like @P_Branch and (Acceptance.AStatus=@P_AStatus or @P_AStatus='')
 And SysUser.ID=@P_UserID
 and (SysUser.Type='SUPERVISOR' or 
 (
 Acceptance.Branch in (Select Branch from SysUserBranch S Where S.ID=@P_UserID and S.Branch=Acceptance.Branch)
 and
 Cover.TOC in (Select TOC from SysUserTOC S Where S.ID=@P_UserID and S.TOC=Cover.TOC)
 ))   
)    

go  

Drop function FL_SchemePolicy
GO
CREATE function FL_SchemePolicy(@P_SchemeNo varchar(10), @P_PolicyNo varchar(10))              
RETURNS Table                
AS RETURN                
(                
Select Distinct a.PolicyNo, a.AName as Insured, a.LANO, a.CNO, a.AID, S.SchemeNo from acceptance as a, cover as c, Scheme_Master S where S.TOC=C.TOC and S.SchemeNo Like @P_SchemeNo+'%' and a.cno=c.cno and a.ano = a.lano and c.openflag=1 and A.AType not in ('A','C') and a.astatus = 'I' and a.PolicyNo like @P_PolicyNo+'%' and a.ano not in (Select PANO from Acceptance Where Acceptance.PANO=a.ANO)  
)  

go 

DROP Function FL_RateCode
GO  
CREATE Function FL_RateCode(@P_ANO as integer, @P_Code as varchar(10),@P_AllowedF as bit=0, @P_TSI as float=0, @P_TOPF as bit=0)          
RETURNS Table          
AS RETURN          
(        
SELECT  RateTab.Code, RateTab.AllowedF, RateTab.NoRefundF,        
 max(RateTab.Description) as Description,        
 max(RateTab.Unit) as Unit,        
 max(RClass.Category) AS Category,        
 case 
 when max(Case When RateTab.Unit='F' then (Case When @P_TSI<>0 then F.Rate*@P_TSI/100 else 0 end) When RateTab.Unit='M' then F.Rate*10 else F.Rate end )<>0 then max(Case When RateTab.Unit='F' then (Case When @P_TSI<>0 then F.Rate*@P_TSI/100 else 0 end) When RateTab.Unit='M' then F.Rate*10 else F.Rate end ) 
 else sum(RateTab.Rate*RateCov.Portion/100) 
 end AS Rate,   
 case when max(F.MinRate)<>0 then max(F.MinRate) else sum(RateTab.MinRate*RateCov.Portion/100) end AS MinRate,        
 max(F.PML) as PML,        
 sum(RateCov.Portion) AS Portion,        
 MAX(F.Loading) As Loading        
FROM  Acceptance    
Inner join Cover on (Cover.CNO=Acceptance.CNO)    
Inner join RateTab on ((Cover.TOC Like RateTab.TOC+'%') and (RateTab.Code Like @P_Code OR RateTab.Description Like @P_Code) And (RateTab.AllowedF=@P_AllowedF or @P_AllowedF=0))        
Inner join RateCov on (RateCov.Code=RateTab.Code)    
Inner join RClass on (RClass.TOC=Cover.TOC And RClass.TOR=RateCov.TOR)    
Left Join fn_RateCon(@P_ANO,@P_Code,@P_TSI) F on (F.Code=RateTab.Code)    
Left join TOP_RATE on (TOP_RATE.TOPRO=Acceptance.TOPRO and (TOP_Rate.Code=RateTab.Code or TOP_Rate.Code=RateTab.PCode))  
WHERE  Acceptance.ANO=@P_ANO and coalesce(F.AllowedF,1)=1    
and (@P_TOPF=0 or coalesce(TOP_RATE.TOPRO,'')=Acceptance.TOPRO)  
GROUP BY RateTab.Code, RateTab.AllowedF, RateTab.NoRefundF     
)   
  
go

Drop function FL_UserRateCode_1
GO
CREATE function FL_UserRateCode_1(@P_USERID varchar(10), @P_CODE varchar(10),@P_TOC varchar(10))  
RETURNS Table  
AS RETURN  
(  
Select Distinct R1.Code, R1.Description From RateTab R1, RateCov R2, RClass R3 Where R3.TOR=R2.TOR and R1.Code=R2.Code and    
R1.AllowedF=1 and R3.TOC like @P_TOC+'%' and R1.Code Like @P_CODE+''  
)
GO


DROP function VOUCHER_AMOUNTWPCDUE
GO  
CREATE function VOUCHER_AMOUNTWPCDUE(@P_Date as smalldatetime)        
RETURNS Table        
AS RETURN        
(        
Select V.Voucher, V.Branch, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, V.Payment_CC, V.Payment_OC, V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate,      
(Case When V.Installment=0 and dateadd(day,A.WPC,V.DueDate) <=@P_Date Then V.Nominal_CC-V.Diff_CC else 0 end+        
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date Then V.AmountDue_1 else 0 end+        
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date Then V.AmountDue_2 else 0 end+        
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date Then V.AmountDue_3 else 0 end+        
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date Then V.AmountDue_4 else 0 end+        
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date Then V.AmountDue_5 else 0 end+        
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date Then V.AmountDue_6 else 0 end+        
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date Then V.AmountDue_7 else 0 end+        
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date Then V.AmountDue_8 else 0 end+        
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date Then V.AmountDue_9 else 0 end+        
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date Then V.AmountDue_10 else 0 end+        
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date Then V.AmountDue_11 else 0 end+        
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date Then V.AmountDue_12 else 0 end) as AmountDue,        
          
Case When V.Installment=0 then dateadd(day, A.WPC,V.DueDate)        
When V.Payment_CC<V.AmountDue_1 then V.DueDate_1        
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2        
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3        
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4        
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5        
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6        
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7        
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8        
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9        
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10        
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11        
Else V.DueDate_12        
end as DueDate,        
(Case When V.Installment<>0 then ' Installment No. ' else '' end+        
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and V.Payment_CC<V.AmountDue_1 Then '1 ' else '' end+        
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+        
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+        
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+        
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+        
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+        
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+        
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+        
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+        
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  Then '10 ' else '' end+        
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+   
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' 
Else '' end+        
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment        
from nVoucher V inner join Admlink A On (A.Voucher=V.Voucher)        
Where V.Date<=@P_Date and ((V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC)<>0 or V.PDate>=@P_Date)        
)                  

GO



DROP Function FL_CLFACDED
GO

Create Function FL_CLFACDED (@P_CNO as Integer, @P_FID as VARCHAR(20))    
Returns Table  
As Return (  
--- QCLFAC02
      SELECT Distinct CLAIM.CNO, FDEDUCTIBLE.TOR, FDEDUCTIBLE.REMARKS, FDEDUCTIBLE.CURRENCY, FDEDUCTIBLE.DCODE  
      From CLAIM, FDEDUCTIBLE, RArrDet, COL      
      Where RArrDet.ANO = FDEDUCTIBLE.ANO AND RARRDET.FID=FDEDUCTIBLE.FID AND RARRDET.ORIGINALF=0      
       AND FDEDUCTIBLE.ANO=CLAIM.ANO      
       AND CLAIM.CNO=@P_CNO      
       AND FDEDUCTIBLE.FID=@P_FID      
       AND COL.COL=CLAIM.COL AND FDEDUCTIBLE.TOR=COL.TOR     
 )  
GO 

Drop Function FL_SR_SchemeNo
GO

Create function FL_SR_SchemeNo(@p_UserID varchar(10), @P_SchemeNo varchar(10),@P_PolicyNo varchar(10))  
RETURNS Table  
AS RETURN  
(

Select Distinct S.SchemeNo, S.Description, S.Disc, S.DailyBasisF, s.sPeriod, s.AllowedF 
from acceptance as a
inner join cover as c on (a.cno=c.cno and c.OpenFlag=1) 
inner join Scheme_Master S on (S.TOC=C.TOC and S.SchemeNo Like @P_SchemeNo)
inner join SysUser on (SysUser.ID=@P_UserID)
Left Join Scheme_Branch S1 on (SysUser.Type<>'SUPERVISOR' and S1.SchemeNo=S.SchemeNo) 
where a.ano = a.lano and A.AType not in ('A','C') and a.astatus = 'I' and a.PolicyNo Like @P_PolicyNo+'%' and a.ano not in (Select PANO from Acceptance Where Acceptance.PANO=a.ANO)
and (SysUser.Type='SUPERVISOR' or S1.Branch is null or S1.Branch in (Select Branch from SysUserBranch Where AllowedF=1 and ID=@P_UserID))
and (SysUser.Type='SUPERVISOR' or S.TOC in (Select TOC from SysUserTOC Where ID=@P_UserID))
)

GO

Drop procedure SchemeList_by_TrNo  
GO    
CREATE procedure SchemeList_by_TrNo (@p_TrNo integer)
as  
select top 1  
 s.*, PCalc.Gross, c.insured, sm.description  
from   
 scheme_transaction as s
 Left join PCalc on (PCalc.ANO=S.ANO) 
 Inner join Acceptance as a on (A.ANO=S.LANO and A.ANO=A.LANO and A.AStatus<>'W')     
 Inner join Cover as C on (C.CNO=A.CNO)
 Inner join scheme_master As sm on (sm.SchemeNo=S.SchemeNo)
where  S.TrNo=@P_TrNo

GO


 DROP FUNCTION FN_BUDGET_TOC
 GO
Create function FN_BUDGET_TOC(@P_PDATE as smalldatetime)        
RETURNS TABLE        
AS RETURN        
(        
Select B.Branch, B.Year, B.Account, B.TOC,   
Max(B.Month_1) as Month_1,  
Max(B.Month_2) as Month_2,  
Max(B.Month_3) as Month_3,  
Max(B.Month_4) as Month_4,  
Max(B.Month_5) as Month_5,  
Max(B.Month_6) as Month_6,  
Max(B.Month_7) as Month_7,  
Max(B.Month_8) as Month_8,  
Max(B.Month_9) as Month_9,  
Max(B.Month_10) as Month_10,  
Max(B.Month_11) as Month_11,  
Max(B.Month_12) as Month_12,  
--Max(B.Actual_1)+sum(Case When Month(A.Date)=1 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_1,  
--Max(B.Actual_2)+sum(Case When Month(A.Date)=2 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_2,  
--Max(B.Actual_3)+sum(Case When Month(A.Date)=3 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_3,  
--Max(B.Actual_4)+sum(Case When Month(A.Date)=4 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_4,  
--Max(B.Actual_5)+sum(Case When Month(A.Date)=5 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_5,  
--Max(B.Actual_6)+sum(Case When Month(A.Date)=6 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_6,  
--Max(B.Actual_7)+sum(Case When Month(A.Date)=7 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_7,  
--Max(B.Actual_8)+sum(Case When Month(A.Date)=8 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_8,  
--Max(B.Actual_9)+sum(Case When Month(A.Date)=9 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_9,  
--Max(B.Actual_10)+sum(Case When Month(A.Date)=10 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_10,  
--Max(B.Actual_11)+sum(Case When Month(A.Date)=11 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_11,  
--Max(B.Actual_12)+sum(Case When Month(A.Date)=12 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_12  
sum(Case When Month(A.Date)=1 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_1,  
sum(Case When Month(A.Date)=2 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_2,  
sum(Case When Month(A.Date)=3 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_3,  
sum(Case When Month(A.Date)=4 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_4,  
sum(Case When Month(A.Date)=5 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_5,  
sum(Case When Month(A.Date)=6 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_6,  
sum(Case When Month(A.Date)=7 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_7,  
sum(Case When Month(A.Date)=8 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_8,  
sum(Case When Month(A.Date)=9 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_9,  
sum(Case When Month(A.Date)=10 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_10,  
sum(Case When Month(A.Date)=11 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_11,  
sum(Case When Month(A.Date)=12 Then coalesce(J.Debit-J.Credit,0) else 0 end) as Actual_12  
from Budget_TOC B
Inner Join Account on (Account.Account=B.Account and Account.Post_Flag=1)
Left Join Admlink A on (A.Branch=B.Branch and Year(A.Date)=B.Year and A.Date<=@P_PDate and A.Code=B.TOC)
--Left Join nVoucher V on (V.Branch=B.Branch and Year(V.Date)=B.Year and V.Date<=@P_PDate and V.Voucher=A.Voucher and V.Status='U') 
Left Join nVoucher V on (V.Branch=B.Branch and Year(V.Date)=B.Year and V.Date<=@P_PDate and V.Voucher=A.Voucher) 
Left Join nJournal J on (J.Voucher=V.Voucher and J.Account=B.Account)
Group By B.Branch, B.Year, B.Account, B.TOC  
)        

GO





DROP function fn_SL_Request_Budget
GO
Create function fn_SL_Request_Budget(@P_Request as varchar(20))          
RETURNS TABLE          
AS RETURN          
(          
Select     
Budget.Branch,    
YEAR(Budget.Date) as Year,    
Budget.Account,     
MAX(Budget.Budget) as Budget,    
MAX(Budget.Actual)     
+ coalesce(sum(Case When Voucher.Status<>'P' Then (Case When Voucher.DebtorF=1 Then -SL.Nominal*Voucher.Rate else SL.Nominal*Voucher.Rate end) else 0 end),0)     
- Case When MAX(Budget.Status)='P' then MAX(Budget.Nominal) else 0 end    
- coalesce(sum(Case When Voucher.Status='P' Then (Case When Voucher.DebtorF=1 Then -SL.Nominal*Voucher.Rate else SL.Nominal*Voucher.Rate end) else 0 end),0)     
as Actual,    
MAX(Budget.Nominal) as Nominal    
from     
(    
Select (Case When pSL.Branch<>'' Then pSL.Branch else Request.Branch end) as Branch, Request.Request, Request.Date, pSL.Account,     
Max(pVoucher.Voucher) as Voucher,  
Max(coalesce(pVoucher.Status,'')) as Status,     
Max(Case     
When Month(Request.Date)=1 Then coalesce(Budget.Month_1, 0)    
When Month(Request.Date)=2 Then coalesce(Budget.Month_1+Budget.Month_2, 0)    
When Month(Request.Date)=3 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3, 0)    
When Month(Request.Date)=4 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4, 0)    
When Month(Request.Date)=5 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5, 0)    
When Month(Request.Date)=6 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6, 0)    
When Month(Request.Date)=7 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7, 0)    
When Month(Request.Date)=8 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8, 0)    
When Month(Request.Date)=9 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9, 0)    
When Month(Request.Date)=10 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10, 0)    
When Month(Request.Date)=11 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11, 0)    
When Month(Request.Date)=12 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)    
end) as Budget,    
Max(Case     
When Month(Request.Date)=1 Then coalesce(Budget.Actual_1, 0)    
When Month(Request.Date)=2 Then coalesce(Budget.Actual_1+Budget.Actual_2, 0)    
When Month(Request.Date)=3 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3, 0)    
When Month(Request.Date)=4 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4, 0)    
When Month(Request.Date)=5 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5, 0)    
When Month(Request.Date)=6 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6, 0)    
When Month(Request.Date)=7 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7, 0)    
When Month(Request.Date)=8 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8, 0)    
When Month(Request.Date)=9 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9, 0)    
When Month(Request.Date)=10 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10, 0)    
When Month(Request.Date)=11 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10+Budget.Actual_11, 0)    
When Month(Request.Date)=12 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10+Budget.Actual_11+Budget.Actual_12, 0)    
end) as Actual,    
sum(Case When Request.DebtorF=1 Then -pSL.Nominal*Request.Rate else pSL.Nominal*Request.Rate end) as Nominal    
from Request     
inner join SL_Request pSL on (pSL.Request=Request.Request)    
inner join Account on (Account.Account=pSL.Account)    
inner join Type on (Type.Type=Account.Type and Type.PL_Flag=1)    
Left Join pVoucher on (pVoucher.Voucher=Request.Voucher)    
left join Budget on (Budget.Branch=(Case When pSL.Branch<>'' Then pSL.Branch else Request.Branch end) and Budget.Year=Year(Request.Date) and Budget.Account=pSL.Account)     
Where Request.Request=@P_Request    
Group by (Case When pSL.Branch<>'' Then pSL.Branch else Request.Branch end), Request.Request, Request.Date, pSL.Account    
) Budget  
Left join pVoucher Voucher on (Voucher.Voucher<>Budget.Voucher and Voucher.SL_Cat='P' and YEAR(Voucher.Date)=YEAR(Budget.Date) and Month(Voucher.Date)=Month(Budget.Date) and ((Voucher.Status<>'P' and Voucher.Date<Budget.Date) or ((Voucher.Status='P' and Voucher.Date>=Budget.Date))))    
Left join 
 --Part Of OSL Functions    
 (
	Select pSL.Voucher, pSL.Doc_No, pSL.Doc_Date, pSL.Doc_CCY, pSL.Nominal_OC, pSL.CT, pSL.Nominal, pSL.Remarks, pSL.Hint,          
	Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end as PaymentF,          
	Case When OSL.Account is null then pSL.Account else OSL.Account end as Account,          
	Case When OBranch.Branch is null then pVoucher.Branch else OBranch.Branch end as Branch, pSL.Nominator, pSL.Denominator, pSL.Rate, pSL.SortNo, pSL.pVoucher        
	From dbo.pSL          
	Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)          
	Left join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account)          
	Left Join dbo.pVoucher OVoucher on (OBranch.Branch=OVoucher.Branch and OVoucher.RefNo=pSL.Voucher and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE')          
	Left join dbo.pSL OSL on (OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo))          
	Where pVoucher.SL_Cat in ('P') and Coalesce(OSL.PaymentF, pSL.PaymentF)=1 
 ) SL on (SL.Voucher=Voucher.Voucher and SL.Branch=Budget.Branch and SL.Account=Budget.Account)    
Group By Budget.Branch, YEAR(Budget.Date), Budget.Account    
)          

GO   


DROP FUNCTION FL_CL_POLICYNO
GO
CREATE FUNCTION FL_CL_POLICYNO(@P_USERID varchar(10), @P_PolicyNo varchar(20))                      
RETURNS TABLE                      
AS RETURN                      
(Select A.PolicyNo, A.CertificateNo, A.AName, A.SDate, A.EDate, A.PDate, A.PPDate, A.NCDate, A.ExtPeriod                 
from Acceptance A Inner Join Cover C on (C.CNO=A.CNO)                  
Where A.ATYPE Not In ('A','C') And A.ASTATUS Not in ('W','T') and C.CStatus not in ('R','P','C')           
And A.PDATE<A.PPDATE And A.ANO<>A.LANO            
and A.PolicyNo<>'' and A.PolicyNo Like @P_PolicyNo+'%'                  
and A.Branch in (Select S.Branch from SysUserBranch S Where S.ID=@P_UserID)                  
and C.TOC in (Select S.TOC from SysUserTOC S Where S.ID=@P_UserID)                  
)     

GO


DROP PROCEDURE QCLACC_3 
GO
CREATE PROCEDURE QCLACC_3 (@P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO VARCHAR(255))          
AS          
SELECT TOP 100 ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.AID, COVER.INSURED, COVER.ISTYPE, COVER.TOC, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, Cover.PHolder, ACCEPTANCE.BRANCH, ACCEPTANCE.ANAME, PROFILE.RESTRICTEDF, PROFILE.NAME, ACCEPTANCE.PDATE, ACCEPTANCE.PPDATE, ACCEPTANCE.NCDATE,  ACCEPTANCE.EXTPERIOD,          
Case When GenDTab.Description is not null then ACCEPTANCE.ValueDesc else '' end as Description,          
Case When ISource.ID is null then ACCEPTANCE.AID else ISource.ID end as Payment,          
Case When ISource.ID is null then Profile.Name else PProfile.Name end as Payment_Name          
FROM ACCEPTANCE Left Join GenDTab On (GenDTab.FLDID=ACCEPTANCE.FLDID AND GenDTab.ValueID=ACCEPTANCE.ValueID), COVER Left Join ISource On (ISource.CNO=Cover.CNO) Left Join Profile PProfile On (PProfile.ID=ISource.ID), Profile          
WHERE COVER.CNO=ACCEPTANCE.CNO 
AND ACCEPTANCE.ATYPE Not In ('A','C') AND ACCEPTANCE.AStatus not in ('W','T') and COVER.CStatus not in ('R','P','C')           
AND ACCEPTANCE.PDATE<ACCEPTANCE.PPDATE AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO AND ACCEPTANCE.AID=PROFILE.ID         
AND ACCEPTANCE.POLICYNO<>'' AND ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO          
ORDER BY ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.PDATE DESC      
go


DROP function VOUCHER_AMOUNTDUE_BY_VOUCHER
GO
CREATE function VOUCHER_AMOUNTDUE_BY_VOUCHER(@P_Date as smalldatetime, @P_Voucher as varchar(20))                
RETURNS Table                
AS RETURN                
(                
Select V.Voucher, V.Branch, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, V.Payment_CC, V.Payment_OC, V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate,              
(Case When V.Installment=0 and V.DueDate <=@P_Date Then V.Nominal_CC-V.Diff_CC else 0 end+                
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date Then V.AmountDue_1 else 0 end+                
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date Then V.AmountDue_2 else 0 end+                
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date Then V.AmountDue_3 else 0 end+                
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date Then V.AmountDue_4 else 0 end+                
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date Then V.AmountDue_5 else 0 end+                
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date Then V.AmountDue_6 else 0 end+                
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date Then V.AmountDue_7 else 0 end+                
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date Then V.AmountDue_8 else 0 end+                
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date Then V.AmountDue_9 else 0 end+                
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date Then V.AmountDue_10 else 0 end+                
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date Then V.AmountDue_11 else 0 end+                
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date Then V.AmountDue_12 else 0 end) as AmountDue,                
                    
Case When V.Installment=0 then V.DueDate                
When V.Payment_CC<V.AmountDue_1 then V.DueDate_1                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11                
Else V.DueDate_12                
end as DueDate,                
(Case When V.Installment<>0 then ' Installment No. ' else '' end+                
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and V.Payment_CC<V.AmountDue_1 Then '1 ' else '' end+                
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+                
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+                
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+                
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+                
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+                
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+                
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+                
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+                
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  Then '10 ' else '' end+                
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+                              
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 '   
Else '' end+                
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment                
from nVoucher V         
Where V.Date<=@P_Date and ((V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC)<>0 or V.PDate>=@P_Date)                
and V.Voucher=@P_Voucher
)                
      
GO
Drop function fn_SL_Budget
GO
Create function fn_SL_Budget(@P_Voucher as varchar(20))          
RETURNS TABLE          
AS RETURN          
(          
Select     
Budget.Branch,    
YEAR(Budget.Date) as Year,    
Budget.Account,     
MAX(Budget.Budget) as Budget,    
MAX(Budget.Actual)     
+ coalesce(sum(Case When Voucher.Status<>'P' Then (Case When Voucher.DebtorF=1 Then -SL.Nominal*Voucher.Rate else SL.Nominal*Voucher.Rate end) else 0 end),0)     
- Case When MAX(Budget.Status)='P' then MAX(Budget.Nominal) else 0 end    
- coalesce(sum(Case When Voucher.Status='P' Then (Case When Voucher.DebtorF=1 Then -SL.Nominal*Voucher.Rate else SL.Nominal*Voucher.Rate end) else 0 end),0)     
as Actual,    
MAX(Budget.Nominal) as Nominal    
from     
(    
Select pSL.Branch, pVoucher.Date, pSL.Account,     
Max(pVoucher.Voucher) as Voucher,  
max(pVoucher.Status) as Status,     
Max(Case     
When Month(pVoucher.Date)=1 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)
When Month(pVoucher.Date)=2 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)
When Month(pVoucher.Date)=3 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)
When Month(pVoucher.Date)=4 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)
When Month(pVoucher.Date)=5 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)
When Month(pVoucher.Date)=6 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)
When Month(pVoucher.Date)=7 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)
When Month(pVoucher.Date)=8 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)
When Month(pVoucher.Date)=9 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
When Month(pVoucher.Date)=10 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)
When Month(pVoucher.Date)=11 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)
When Month(pVoucher.Date)=12 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)    
end) as Budget,    
Max(Case     
When Month(pVoucher.Date)=1 Then coalesce(Budget.Actual_1, 0)    
When Month(pVoucher.Date)=2 Then coalesce(Budget.Actual_1+Budget.Actual_2, 0)    
When Month(pVoucher.Date)=3 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3, 0)    
When Month(pVoucher.Date)=4 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4, 0)    
When Month(pVoucher.Date)=5 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5, 0)    
When Month(pVoucher.Date)=6 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6, 0)    
When Month(pVoucher.Date)=7 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7, 0)    
When Month(pVoucher.Date)=8 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8, 0)    
When Month(pVoucher.Date)=9 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9, 0)    
When Month(pVoucher.Date)=10 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10, 0)    
When Month(pVoucher.Date)=11 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10+Budget.Actual_11, 0)    
When Month(pVoucher.Date)=12 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10+Budget.Actual_11+Budget.Actual_12, 0)    
end) as Actual,   
sum(Case When pVoucher.DebtorF=1 Then -pSL.Nominal*pVoucher.Rate else pSL.Nominal*pVoucher.Rate end) as Nominal    
from pVoucher    
inner join oSL(@P_Voucher) pSL on (pSL.Voucher=pVoucher.Voucher)    
inner join Account on (Account.Account=pSL.Account)    
inner join Type on (Type.Type=Account.Type and Type.PL_Flag=1)    
left join Budget on (Budget.Branch=pSL.Branch and Budget.Year=Year(pVoucher.Date) and Budget.Account=pSL.Account)     
Where pVoucher.Voucher=@P_Voucher    
Group by pSL.Branch, pVoucher.Date, pSL.Account    
) Budget  
Left join pVoucher Voucher on (Voucher.Voucher<>Budget.Voucher and Voucher.SL_Cat='P' and YEAR(Voucher.Date)=YEAR(Budget.Date) and Month(Voucher.Date)<=Month(Budget.Date) and ((Voucher.Status<>'P' and Voucher.Date<Budget.Date) or ((Voucher.Status='P' and Voucher.Date>=Budget.Date))))    
Left join 
 --Part Of OSL Functions    
 (
	Select pSL.Voucher, pSL.Doc_No, pSL.Doc_Date, pSL.Doc_CCY, pSL.Nominal_OC, pSL.CT, pSL.Nominal, pSL.Remarks, pSL.Hint,          
	Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end as PaymentF,          
	Case When OSL.Account is null then pSL.Account else OSL.Account end as Account,          
	Case When OBranch.Branch is null then pVoucher.Branch else OBranch.Branch end as Branch, pSL.Nominator, pSL.Denominator, pSL.Rate, pSL.SortNo, pSL.pVoucher        
	From dbo.pSL          
	Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)          
	Left join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account)          
	Left Join dbo.pVoucher OVoucher on (OBranch.Branch=OVoucher.Branch and OVoucher.RefNo=pSL.Voucher and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE')          
	Left join dbo.pSL OSL on (OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo))          
	Where pVoucher.SL_Cat in ('P') 
 ) SL on (SL.Voucher=Voucher.Voucher and SL.Branch=Budget.Branch and SL.Account=Budget.Account)    
Group By Budget.Branch, YEAR(Budget.Date), Budget.Account    
    
    
)          
  
GO        


Drop Function FL_CL_KOL
GO
Create Function FL_CL_KOL(@P_CNO as Int, @P_INO AS Int, @P_KOL AS VARCHAR(10))       
RETURNS TABLE  
AS RETURN (  
      
SELECT KOL.KOL, KOL.DESCRIPTION, KOL.CATEGORY, Max(coalesce(KOLVALUE.COST,0)) as Cost, KOL.VATF, KOL.TAXF    
FROM ICOVER    
INNER JOIN KOL ON (KOL.ALLOWEDF=1 and KOL.TOI=ICOVER.TOI AND (KOL.KOL LIKE @P_KOL or KOL.DESCRIPTION LIKE @P_KOL))    
INNER JOIN CLAIM ON (CLAIM.CNO=@P_CNO)
LEFT JOIN CLINFO ON (CLINFO.CNO=@P_CNO AND CLINFO.INO=ICOVER.INO)    
LEFT JOIN IINFO ON (IINFO.INO=ICOVER.INO)    
LEFT JOIN KOLVALUE ON (    
KOLVALUE.KOL=KOL.KOL    
AND (KOLVALUE.BRANCH='<All>' or KOLVALUE.BRANCH=CLAIM.BRANCH)  
And (coalesce(KOLVALUE.ValueID1,'')='' Or coalesce(CLINFO.ValueID1,IINFO.ValueID1)=coalesce(KOLVALUE.ValueID1,''))         
And (coalesce(KOLVALUE.ValueID2,'')='' Or coalesce(CLINFO.ValueID2,IINFO.ValueID2)=coalesce(KOLVALUE.ValueID2,''))         
And (coalesce(KOLVALUE.ValueID3,'')='' Or coalesce(CLINFO.ValueID3,IINFO.ValueID3)=coalesce(KOLVALUE.ValueID3,''))         
And (coalesce(KOLVALUE.ValueID4,'')='' Or coalesce(CLINFO.ValueID4,IINFO.ValueID4)=coalesce(KOLVALUE.ValueID4,''))         
And (coalesce(KOLVALUE.ValueID5,'')='' Or coalesce(CLINFO.ValueID5,IINFO.ValueID5)=coalesce(KOLVALUE.ValueID5,''))         
And (coalesce(KOLVALUE.ValueID6,'')='' Or coalesce(CLINFO.ValueID6,IINFO.ValueID6)=coalesce(KOLVALUE.ValueID6,''))         
And (coalesce(KOLVALUE.ValueID7,'')='' Or coalesce(CLINFO.ValueID7,IINFO.ValueID7)=coalesce(KOLVALUE.ValueID7,''))         
And (coalesce(KOLVALUE.ValueID8,'')='' Or coalesce(CLINFO.ValueID8,IINFO.ValueID8)=coalesce(KOLVALUE.ValueID8,''))         
And (coalesce(KOLVALUE.ValueID9,'')='' Or coalesce(CLINFO.ValueID9,IINFO.ValueID9)=coalesce(KOLVALUE.ValueID9,''))         
And (coalesce(KOLVALUE.ValueID10,'')='' Or coalesce(CLINFO.ValueID10,IINFO.ValueID10)=coalesce(KOLVALUE.ValueID10,''))         
And (coalesce(KOLVALUE.ValueID11,'')='' Or coalesce(CLINFO.ValueID11,IINFO.ValueID11)=coalesce(KOLVALUE.ValueID11,''))         
And (coalesce(KOLVALUE.ValueID12,'')='' Or coalesce(CLINFO.ValueID12,IINFO.ValueID12)=coalesce(KOLVALUE.ValueID12,''))         
And (coalesce(KOLVALUE.ValueID13,'')='' Or coalesce(CLINFO.ValueID13,IINFO.ValueID13)=coalesce(KOLVALUE.ValueID13,''))         
And (coalesce(KOLVALUE.ValueID14,'')='' Or coalesce(CLINFO.ValueID14,IINFO.ValueID14)=coalesce(KOLVALUE.ValueID14,''))         
And (coalesce(KOLVALUE.ValueID15,'')='' Or coalesce(CLINFO.ValueID15,IINFO.ValueID15)=coalesce(KOLVALUE.ValueID15,''))         
)    
WHERE ICOVER.INO=@P_INO    
Group By KOL.KOL, KOL.DESCRIPTION, KOL.CATEGORY, KOL.VATF, KOL.TAXF    
)  

GO


DROP Procedure QPCOLLATERAL
GO
Create Procedure QPCOLLATERAL(@PID AS VARCHAR(20))    
AS    
Select C.COLLATERALNO, MAX(C.COLLATERALTYPE) AS COLLATERALTYPE, MAX(C.DESCRIPTION) AS DESCRIPTION, MAX(C.DOCNO) AS DOCNO, MAX(C.CURRENCY) AS CURRENCY, MAX(C.STATUS) AS STATUS, MAX(C.EXPDATE) AS EXPDATE, MAX(C.RECDATE) AS RECDATE, MAX(C.RECEIVEDBY) AS RECEIVEDBY, MAX(C.RELDATE) AS RELDATE, MAX(C.RELEASEDBY) AS RELEASEDBY, MAX(C.NOMINAL) as NOMINAL, SUM(A.NOMINAL) AS ALLOCATED    
from COLLATERAL C    
LEFT JOIN ACCCOLLATERAL A ON (C.COLLATERALNO=A.COLLATERALNO)    
Where ID=@PID       
GROUP BY C.COLLATERALNO         
GO


--TUNING SCRIPT
Drop Procedure List21
GO
CREATE  PROCEDURE List21 (@P_UserID varchar(255))     
AS  
SELECT Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.LUSERID as USERID,   
 SysTab.Currency,   
 QPCalc.TSI,   
 QPCalc.OurShare,   
 QPCalc.Gross,   
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear,   
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc  
WHERE  Cover.CNO=Acceptance.CNO   
 And QPCalc.ANO=Acceptance.ANO   
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)   
 And Acceptance.RequestF=1 and Acceptance.RequestName Like @P_UserID 
   
union  
  
SELECT Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.LUSERID as USERID,   
 SysTab.Currency,   
 QPCalc.TSI,   
 QPCalc.OurShare,   
 QPCalc.Gross,   
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear,   
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, Acceptance As Acceptance_Detail  
WHERE  Cover.CNO=Acceptance.CNO   
 And QPCalc.ANO=Acceptance.ANO   
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO  
 And Acceptance_Detail.RequestF=1 and Acceptance_Detail.RequestName Like @P_UserID
  
GO

DROP FUNCTION List21_Det 
GO
CREATE FUNCTION List21_Det (@P_ANO as integer,@P_UserID varchar(255))   
RETURNS TABLE  
AS RETURN(  
  
SELECT Cast(0 as bit) as ProcessFlag,    
 [Acceptance].[CertificateNo],   
 Acceptance.ESeqNo,  
 [Acceptance].[AName],   
 [Acceptance].[ANO],   
 [Acceptance].[REGNO],   
 [Acceptance].[ADATE],   
 [Acceptance].[LUSERID] as UserID,   
 [SysTab].[Currency],   
 [QPCalc].[TSI],   
 [QPCalc].[OurShare],   
 [QPCalc].[Gross],   
 [Acceptance].[ASTATUS],   
 [Acceptance].[ATYPE],   
 [Acceptance].[SDate],   
 [Acceptance].[EDate],   
 Year([Acceptance].[SDate]) AS RYear,  
 Acceptance.ValueID,  
        Acceptance.ValueDesc  
FROM    
 Acceptance,   
 Cover,   
 SysTab,   
 QMasterAcceptance_PCalc() AS QPCalc  
WHERE    
 [Cover].[CNO]=[Acceptance].[CNO]   
 And [QPCalc].[ANO]=[Acceptance].[ANO]   
 And [Acceptance].[ANO]<>[Acceptance].[LANO]   
 And [Acceptance].[LANO]=@P_ANO  
 And [Acceptance].[RequestF]=1 and Acceptance.RequestName Like @P_UserID
)  
  
  GO

DROP PROCEDURE List10  
GO      
CREATE PROCEDURE List10(@P_TOC as varchar(10), @P_Branch as varchar(10), @P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_AStatus as varchar(1))         
AS        
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.ANO AS ANO,         
 Cover.CNO,        
 Cover.CoverDate,        
 Cover.ExpDate,        
 Cast(Acceptance.AName as varchar(128)) as Insured,        
 Cover.UserID,        
 Cover.CStatus,        
 ISource.RType,         
 Acceptance.RegNo,         
 Acceptance.PolicyNo,        
 Profile.Name,         
 Acceptance.AStatus,         
 TOC.Description,         
 Acceptance.Branch        
FROM  Cover, ISource, Acceptance, Payor, Profile, TOC        
WHERE  Acceptance.ANO=Acceptance.LANO         
 And Cover.CNO=Acceptance.CNO         
 And ISource.CNO=Cover.CNO         
 And Payor.ANO=Acceptance.ANO         
 And Cover.ISType='T'         
 And Profile.ID=Payor.ID         
 And TOC.TOC=Cover.TOC        
 And TOC.TOC Like @P_TOC+'%'    
 And Acceptance.Branch Like @P_Branch+'%'    
 And (Acceptance.AStatus=@P_AStatus or @P_AStatus='')
 And (@P_SDate between Cover.CoverDate and Cover.ExpDate  or @P_EDate between Cover.CoverDate and Cover.ExpDate or Cover.CoverDate Between @P_SDate and @P_EDate or Cover.ExpDate Between @P_SDate and @P_EDate)  
 order by ACCEPTANCE.RegNo      
      
GO

-- Perbaikan penarikan Account Suspend untuk Branch Inter Office
Drop function FL_UserBranchAccountIO
GO
Create function FL_UserBranchAccountIO(@P_USERID varchar(10), @P_Branch varchar(10), @P_Account varchar(10), @P_DebtorF Bit)          
RETURNS Table            
AS RETURN            
(          
SELECT Branch.Branch, Branch.Name, Branch.Active_Flag, Branch.ShariaF    
from Branch, SysUser, Account, Type        
Where SysUser.ID=@P_UserID and Account.Account=@P_Account and Type.Type=Account.Type     
and Branch.Branch Like @P_Branch+'%' and Branch.Op_Flag=1     
and (SysUser.Type='SUPERVISOR'     
or Branch.Branch in (Select S.Branch from SysUserBranch S     
Where ((Type.PL_Flag=1 and S.IncomeReceiveF=1 and @P_DebtorF=1) or (Type.PL_Flag=1 and S.ExpensePaymentF=1 and @P_DebtorF=0) or (Account.Suspend_Flag=1 and S.SuspendReceiveF=1 and @P_DebtorF=1) or (Account.Suspend_Flag=1 and S.SuspendPaymentF=1 and @P_DebtorF=0)) and S.ID=SysUser.ID))      
)    
  
GO



--perbaikan tuning query select exist
Drop function FL_SR_SchemeNo
GO
Create function FL_SR_SchemeNo(@p_UserID varchar(10), @P_SchemeNo varchar(10),@P_PolicyNo varchar(10))  
RETURNS Table  
AS RETURN  
(

Select Distinct S.SchemeNo, S.Description, S.Disc, S.DailyBasisF, s.sPeriod, s.AllowedF 
from acceptance as a
inner join cover as c on (a.cno=c.cno and c.OpenFlag=1) 
inner join Scheme_Master S on (S.TOC=C.TOC and S.SchemeNo Like @P_SchemeNo)
inner join SysUser on (SysUser.ID=@P_UserID)
Left Join Scheme_Branch S1 on (SysUser.Type<>'SUPERVISOR' and S1.SchemeNo=S.SchemeNo) 
where a.ano = a.lano and S.AllowedF=1 and A.AType not in ('A','C') and a.astatus = 'I' and a.PolicyNo Like @P_PolicyNo+'%' 
and NOT EXISTS (Select PANO from Acceptance Where Acceptance.PANO=a.ANO)
and (SysUser.Type='SUPERVISOR' or S1.Branch is null or EXISTS (Select Branch from SysUserBranch Where SysUserBranch.Branch=S1.Branch and AllowedF=1 and ID=@P_UserID))
and (SysUser.Type='SUPERVISOR' or EXISTS (Select TOC from SysUserTOC Where SysUserTOC.TOC=S.TOC and ID=@P_UserID))
)          

GO

DROP FUNCTION FN_GENDTAB 
GO    
      
CREATE FUNCTION FN_GENDTAB (@P_TOC as varchar(10))          
RETURNS TABLE          
as RETURN(          
Select G1.*
from GenDTab G1 Inner Join GenHTab G2 on (G2.FLDID=G1.FLDID) 
Where 
(
G2.SubClassF=0 or @P_TOC='' 
or (G2.SubClassF=1 and EXISTS (Select Top 1 ValueID from GenDTOC G3 Where G3.FLDID=G1.FLDID and G3.VALUEID=G1.VALUEID and G3.TOC=@P_TOC))
)
)        

GO


DROP function FL_UserBranchAccountIO
GO
Create function FL_UserBranchAccountIO(@P_USERID varchar(10), @P_Branch varchar(10), @P_Account varchar(10), @P_DebtorF Bit)            
RETURNS Table              
AS RETURN              
(            
SELECT Branch.Branch, Branch.Name, Branch.Active_Flag, Branch.ShariaF      
from Branch, SysUser, Account, Type          
Where SysUser.ID=@P_UserID and Account.Account=@P_Account and Account.Inter_Flag=1 and Type.Type=Account.Type       
and Branch.Branch Like @P_Branch+'%' and Branch.Op_Flag=1       
and (SysUser.Type='SUPERVISOR'       
or EXISTS (Select S.Branch from SysUserBranch S       
Where S.Branch=Branch.Branch and ((Type.PL_Flag=1 and S.IncomeReceiveF=1 and @P_DebtorF=1) or (Type.PL_Flag=1 and S.ExpensePaymentF=1 and @P_DebtorF=0) or (Type.BS_Flag=1 and S.SuspendReceiveF=1 and @P_DebtorF=1) or (Type.BS_Flag=1 and S.SuspendPaymentF=1 and @P_DebtorF=0)) and S.ID=SysUser.ID))        
)      

GO


DROP PROCEDURE dbo.List19   
GO  
CREATE PROCEDURE dbo.List19 (@P_Days as smallint,@P_Date as Smalldatetime,@P_COB as varchar(10),@P_Branch as varchar(10), @P_UnPaidOpt as bit)      
AS      
SELECT Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,       
 Cast(Acceptance.AName as varchar(128)) as Insured,       
 Cover.CNO,       
 Cover.CStatus,       
 Acceptance.lANO,       
 Acceptance.ANO,       
 Acceptance.REGNO,       
 Acceptance.ADATE,       
 Acceptance.LUSERID as USERID,       
 SysTab.Currency,       
 QPCalc.TSI,       
 QPCalc.OurShare,       
 QPCalc.Gross,       
 Acceptance.ASTATUS,       
 Acceptance.ATYPE,       
 Acceptance.SDate,       
 Acceptance.EDate,       
 Year(Acceptance.SDate) AS RYear,       
 Cover.ISType,       
 Acceptance.Renewal,       
 Acceptance.ESeqNo,       
 Acceptance.PolicyNo,       
 Acceptance.CertificateNo      
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, TOC    
WHERE  Cover.CNO=Acceptance.CNO     
 And TOC.TOC=Cover.TOC and TOC.COB=@P_COB And Acceptance.Branch Like @P_Branch+'%'
And QPCalc.ANO=Acceptance.ANO      
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)And Cover.ISType<>'T'       
 And Acceptance.AStatus='I' And Acceptance.AType<>'C'      
 And EXISTS (SELECT A1.OANO from Acceptance A1, AccAss, Admlink, nVoucher Voucher Where A1.ANO=AccAss.ANO and A1.OANO=Acceptance.OANO and Voucher.Voucher=Admlink.Voucher and Admlink.AdmNo=AccAss.AdmNo and AccAss.Type in ('DI','IC','IR') and Voucher.nDueDate+@P_Days<@P_Date and Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC<>0 and (@P_UnPaidOpt=0 or Voucher.Payment_CC=0))      
      
union      
      
SELECT Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,       
 Cast(Acceptance.AName as varchar(128)) as Insured,       
 Cover.CNO,       
 Cover.CStatus,       
 Acceptance.lANO,       
 Acceptance.ANO,       
 Acceptance.REGNO,       
 Acceptance.ADATE,       
 Acceptance.LUSERID as USERID,       
 SysTab.Currency,       
 QPCalc.TSI,       
 QPCalc.OurShare,       
 QPCalc.Gross,       
 Acceptance.ASTATUS,       
 Acceptance.ATYPE,       
 Acceptance.SDate,       
 Acceptance.EDate,       
 Year(Acceptance.SDate) AS RYear,       
 Cover.ISType,       
 Acceptance.Renewal,       
 Acceptance.ESeqNo,       
 Acceptance.PolicyNo,       
 Acceptance.CertificateNo      
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, Acceptance As Acceptance_Detail, TOC    
WHERE  Cover.CNO=Acceptance.CNO       
 And TOC.TOC=Cover.TOC and TOC.COB=@P_COB And Acceptance_Detail.Branch Like @P_Branch+'%'
And QPCalc.ANO=Acceptance.ANO       
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO And Cover.ISType<>'T'       
 And Acceptance.AStatus='I' And Acceptance.AType<>'C'      
 And Acceptance_Detail.AStatus='I'  And Acceptance_Detail.AType<>'C'      
 And EXISTS (SELECT A1.OANO from Acceptance A1, AccAss, Admlink, nVoucher Voucher Where A1.ANO=AccAss.ANO and A1.OANO=Acceptance_Detail.OANO and Voucher.Voucher=Admlink.Voucher and Admlink.AdmNo=AccAss.AdmNo and AccAss.Type in ('DI','IC','IR') and Voucher.nDueDate+@P_Days<@P_Date and Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC<>0 and (@P_UnPaidOpt=0 or Voucher.Payment_CC=0))      
    
  
GO  
DROP FUNCTION List19_Det 
GO
CREATE FUNCTION List19_Det (@P_ANO as integer, @P_Days as smallint, @P_Date as Smalldatetime,@P_COB as varchar(10),@P_Branch as varchar(10), @P_UnPaidOpt as Bit)      
RETURNS TABLE      
as RETURN(      
      
SELECT Cast(0 as bit) as ProcessFlag,      
 [Acceptance].[CertificateNo],       
 Acceptance.ESeqNo,      
 [Acceptance].[AName],       
 [Acceptance].[ANO],       
 [Acceptance].[REGNO],       
 [Acceptance].[ADATE],       
 [Acceptance].[LUSERID] as UserID,       
 [SysTab].[Currency],       
 [QPCalc].[TSI],       
 [QPCalc].[OurShare],       
 [QPCalc].[Gross],       
 [Acceptance].[ASTATUS],       
 [Acceptance].[ATYPE],       
 [Acceptance].[SDate],       
 [Acceptance].[EDate],       
 Year([Acceptance].[SDate]) AS RYear,  
 Acceptance.ValueID,  
 Acceptance.ValueDesc  
      
FROM       
 Acceptance,       
 Cover,       
 SysTab,       
 QMasterAcceptance_PCalc() AS QPCalc,    
 TOC    
WHERE       
 [Cover].[CNO]=[Acceptance].[CNO]       
 And TOC.TOC=Cover.TOC and TOC.COB=@P_COB And Acceptance.Branch Like @P_Branch+'%'
And [QPCalc].[ANO]=[Acceptance].[ANO]       
 And [Acceptance].[ANO]<>[Acceptance].[LANO]       
 And [Acceptance].[LANO]=@P_ANO       
 And [Cover].[ISType]<>'T'      
 And Acceptance.AStatus='I'  And Acceptance.AType<>'C'      
 And EXISTS (SELECT A1.OANO from Acceptance A1, AccAss, Admlink, nVoucher Voucher Where A1.ANO=AccAss.ANO and A1.OANO=Acceptance.OANO and Voucher.Voucher=Admlink.Voucher and Admlink.AdmNo=AccAss.AdmNo and AccAss.Type in ('DI','IC','IR') and Voucher.nDueDate+@P_Days<@P_Date and Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC<>0 and (@P_UnPaidOpt=0 or Voucher.Payment_CC=0))      
)      
      
GO


DROP FUNCTION FN_UserSegment 
GO      
CREATE FUNCTION FN_UserSegment (@P_UserID as varchar(10))          
RETURNS TABLE          
as RETURN(          
SELECT Segment.*     
 from Segment     
 Inner join SysUser on (SysUser.ID=@P_UserID)    
 Where (SysUser.Type='SUPERVISOR' or EXISTS (Select SysUserSegment.Segment from SysUserSegment Where SysUserSegment.Segment=Segment.Segment and SysUserSegment.ID=@P_UserID and SysUserSegment.Segment=Segment.Segment)) 
)        

GO


DROP PROCEDURE List11a  
GO
CREATE PROCEDURE List11a(@P_UserID as varchar(255), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_AStatus as varchar(1))    
AS    
SELECT Cast(0 as bit) as ProcessFlag,     
 Cover.COVERNO,    
 Cast(Acceptance.AName as varchar(128)) as Insured,    
 Cover.CNO,    
 Cover.CStatus,    
 Acceptance.lANO,    
 Acceptance.ANO,    
 Acceptance.REGNO,    
 Acceptance.ADATE,    
 Acceptance.LUSERID as USERID,    
 SysTab.Currency,    
 QPCalc.TSI,    
 QPCalc.OurShare,    
 QPCalc.Gross,    
 Acceptance.ASTATUS,    
 Acceptance.ATYPE,    
 Acceptance.SDate,    
 Acceptance.EDate,    
 Year(Acceptance.SDate) AS RYear,    
 Cover.ISType,    
 Acceptance.Renewal,    
 Acceptance.ESeqNo,    
 Acceptance.PolicyNo,    
 acceptance.CertificateNo    
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader, SysUser
Where cover.CNO = acceptance.CNO    
 And QPCalc.ANO=Acceptance.ANO    
 And RArrHeader.ANO=Acceptance.ANO    
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)    
 And Cover.CStatus<>'C'    
 And Acceptance.AStatus='W'    
 And (RArrHeader.RAmount<>0 or RArrHeader.HoldF=1)    
 And Cover.ISType<>'T'    
 And Cover.TOC Like @P_TOC and Acceptance.Branch Like @P_Branch and (Acceptance.AStatus=@P_AStatus or @P_AStatus='')  
 And SysUser.ID=@P_UserID
and (SysUser.Type='SUPERVISOR' or 
 (
EXISTS (Select Branch from SysUserBranch S Where S.ID=@P_UserID and S.Branch=Acceptance.Branch)
and
EXISTS (Select TOC from SysUserTOC S Where S.ID=@P_UserID and S.TOC=Cover.TOC)
))
        
Union    
        
SELECT Cast(0 as bit) as ProcessFlag,     
 Cover.COVERNO,    
 Cast(Acceptance.AName as varchar(128)) as Insured,    
 Cover.CNO,    
 Cover.CStatus,    
 Acceptance.lANO,    
 Acceptance.ANO,    
 Acceptance.REGNO,    
 Acceptance.ADATE,    
 Acceptance.LUSERID as USERID,    
 SysTab.Currency,    
 QPCalc.TSI,    
 QPCalc.OurShare,    
 QPCalc.Gross,    
 Acceptance.ASTATUS,    
 Acceptance.ATYPE,    
 Acceptance.SDate,    
 Acceptance.EDate,    
 Year(Acceptance.SDate) AS RYear,    
 Cover.ISType,    
 Acceptance.Renewal,    
 Acceptance.ESeqNo,    
 Acceptance.PolicyNo,    
 acceptance.CertificateNo    
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader, Acceptance As Acceptance_Detail, SysUser
Where cover.CNO = acceptance.CNO    
 And QPCalc.ANO=Acceptance.ANO    
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO    
 And RArrHeader.ANO=Acceptance_Detail.ANO    
 And Cover.CStatus<>'C'    
 And Acceptance_Detail.AStatus='W'    
 And (RArrHeader.RAmount<>0 or RArrHeader.HoldF=1)    
 And Cover.ISType<>'T'    
 And Cover.TOC Like @P_TOC and Acceptance_Detail.Branch Like @P_Branch and (Acceptance_Detail.AStatus=@P_AStatus or @P_AStatus='')  
 And SysUser.ID=@P_UserID
and (SysUser.Type='SUPERVISOR' or 
 (
EXISTS (Select Branch from SysUserBranch S Where S.ID=@P_UserID and S.Branch=Acceptance_Detail.Branch)
and
EXISTS (Select TOC from SysUserTOC S Where S.ID=@P_UserID and S.TOC=Cover.TOC)
)) 
      
GO
DROP FUNCTION List11A_Det 
GO
CREATE FUNCTION List11A_Det (@P_ANO as integer, @P_UserID as varchar(255), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_AStatus as varchar(1))    
RETURNS Table    
AS RETURN(    
      
SELECT Cast(0 as bit) as ProcessFlag,    
 Acceptance.CertificateNo,    
 Acceptance.ESeqNo,    
 Acceptance.AName,    
 Acceptance.ANO,    
 Acceptance.REGNO,    
 Acceptance.ADATE,    
 Acceptance.LUSERID as UserID,    
 SysTab.Currency,    
 QPCalc.TSI,    
 QPCalc.OurShare,    
 QPCalc.Gross,    
 Acceptance.ASTATUS,    
 Acceptance.ATYPE,    
 Acceptance.SDate,    
 Acceptance.EDate,    
 Year(Acceptance.SDate) AS RYear,    
 QPCalc.ValueID,    
 QPCalc.ValueDesc    
From    
 Acceptance,    
 Cover,    
 SysTab,    
 QMasterAcceptance_PCalc() AS QPCalc,    
 RARRHEADER,
SysUser
Where    
 cover.CNO = acceptance.CNO    
 And Rarrheader.ANO = Acceptance.ANO    
 And QPCalc.ANO=Acceptance.ANO    
 And Acceptance.ANO<>Acceptance.LANO    
 And Acceptance.LANO=@P_ANO    
 And Cover.CStatus<>'C'    
 And Acceptance.AStatus='W'    
 And (RArrHeader.RAmount<>0 or RArrHeader.HoldF=1)    
 And Cover.ISType<>'T'    
 And Cover.TOC Like @P_TOC and Acceptance.Branch Like @P_Branch and (Acceptance.AStatus=@P_AStatus or @P_AStatus='')
And SysUser.ID=@P_UserID
and (SysUser.Type='SUPERVISOR' or 
 (
EXISTS (Select Branch from SysUserBranch S Where S.ID=@P_UserID and S.Branch=Acceptance.Branch)
and
EXISTS (Select TOC from SysUserTOC S Where S.ID=@P_UserID and S.TOC=Cover.TOC)
))   
)    
GO


DROP function FL_Underwriter
GO  
CREATE function FL_Underwriter(@P_ANO int)        
RETURNS Table          
AS RETURN          
(        
 Select SysUser.*
From sysuser, Acceptance
Where SysUser.Role in ('COMMON','UNDERWRITER') and SysUser.AllowedF=1 and Acceptance.ANO=@P_ANO
and (SysUser.Type='SUPERVISOR' or EXISTS (Select S.Branch from SysUserBranch S Where S.Branch=Acceptance.Branch and S.AllowedF=1 and S.ID=SysUser.ID))    
)    

GO



DROP Procedure QRDOCLIST

GO
  
CREATE Procedure QRDOCLIST(@P_Request as varchar(20))          
as          
Select *    
from      
(            
Select Cast(0 as bit) as ProcessFlag, DOCTYPE.DOCTYPE, DOCTYPE.DESCRIPTION, Cast(0 as bit) as AvailableF
from DocType
Where DocType.Purpose='PAYMENT' and DocType.AllowedF=1 and NOT EXISTS (Select DocType from RDocList Where RDocList.DocType=DocType.DocType and Request=@P_Request)

Union All

select RDOCLIST.AvailableF as ProcessFlag, RDOCLIST.DOCTYPE, RDOCLIST.Description, RDOCLIST.AvailableF as AvailableF
from RDOCLIST 
Where RDOCLIST.Request=@P_Request  

) RDOCLIST      
Order By RDOCLIST.DOCTYPE

GO


DROP Procedure QCDOCLIST
GO
CREATE Procedure QCDOCLIST(@P_CNO integer, @P_INO integer, @P_NOC varchar(10))        
as        
Select *  
from    
(    
select Cast(coalesce(CDOCLIST.AvailableF, 0) as bit) as ProcessFlag, DOCLIST.DocType, coalesce(CDOCLIST.Description, DOCLIST.Description) as Description, coalesce(CDOCLIST.AvailableF, 0) as AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, CDOCLIST.RecDate
from DOCLIST Left join DOCTYPE on (DOCTYPE.DOCTYPE=DOCLIST.DOCTYPE) inner join ICOVER on (ICover.INO=@P_INO and DOCLIST.NOC=@P_NOC and DOCLIST.TOI=ICOVER.TOI)    
Left Join CDOCLIST on (CDOCLIST.CNO=@P_CNO and CDOCLIST.INO=ICover.INO and CDOCLIST.DOCTYPE=DOCLIST.DOCTYPE)    
    
Union All    
    
select Cast(coalesce(CDOCLIST.AvailableF, 0) as bit) as ProcessFlag, CDOCList.DocType, CDOCLIST.Description, CDOCLIST.AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, CDOCLIST.RecDate
from CDOCLIST Left Join DOCTYPE on (DOCTYPE.DOCTYPE=CDOCLIST.DOCTYPE)  
Where CDOCLIST.CNO=@P_CNO AND CDOCLIST.INO=@P_INO 
AND NOT EXISTS (Select DOCLIST.DOCTYPE from DOCLIST, ICOVER Where DOCLIST.DOCTYPE=CDOCLIST.DOCTYPE AND ICOVER.INO=@P_INO AND DOCLIST.NOC=@P_NOC AND DOCLIST.TOI=ICOVER.TOI)  
) CDOCLIST    
Order By CDOCLIST.DOCTYPE    
  

GO



DROP FUNCTION FL_CL_POLICYNO
GO
CREATE FUNCTION FL_CL_POLICYNO(@P_USERID varchar(10), @P_PolicyNo varchar(20))                      
RETURNS TABLE                      
AS RETURN                      
(Select A.PolicyNo, A.CertificateNo, A.AName, A.SDate, A.EDate, A.PDate, A.PPDate, A.NCDate, A.ExtPeriod                 
from Acceptance A Inner Join Cover C on (C.CNO=A.CNO)                  
Where A.ATYPE Not In ('A','C') And A.ASTATUS Not in ('W','T') and C.CStatus not in ('R','P','C')           
And A.PDATE<A.PPDATE And A.ANO<>A.LANO            
and A.PolicyNo<>'' and A.PolicyNo Like @P_PolicyNo+'%'                  
and EXISTS (Select S.Branch from SysUserBranch S Where S.Branch=A.Branch and S.ID=@P_UserID)                  
and EXISTS (Select S.TOC from SysUserTOC S Where S.TOC=C.TOC and S.ID=@P_UserID)                  
)     

GO

DROP FUNCTION FL_SL_COMACC 
GO  
CREATE FUNCTION FL_SL_COMACC (@P_VType as varchar(10), @P_UserID as varchar(10), @P_Branch as varchar(10),@P_sComAcc varchar(30))                    
RETURNS TABLE                    
as RETURN(                    
Select ComAcc.ComAcc, ComAcc.Description, ComAcc.Currency, ComAcc.RestrictedF, VPattern.Debit+VPattern.Credit as Hint, VPattern.Account                
from ComAcc
Inner Join ComAcc sComAcc on (sComAcc.ComAcc=@P_sComAcc and (sComAcc.AccGroup='' or ComAcc.AccGroup='' or ComAcc.AccGroup=sComAcc.AccGroup))  
Inner Join VType on (VType.VType=@P_VType)
Inner Join VPattern on (VType.VType=VPattern.VType and ((vPattern.Debit=-1 and VType.CreditorF=1) or (vPattern.Credit=-1 and VType.DebtorF=1)))
Inner Join Account on (Account.Open_ItemF=1 and Account.Account=Vpattern.Account)
Inner Join SysUser on (SysUser.ID=@P_UserID) 
where ComAcc.NonCBF=0 and (SysUser.Type='SUPERVISOR' or EXISTS (Select SysUserComAcc.ComAcc from SysUserComAcc Where SysUserComAcc.ID=@P_UserID and SysUserComAcc.ComAcc=ComAcc.ComAcc))              
and ((ComAcc.Branch=@P_Branch) or (EXISTS (Select ComAcc from ComAcc_Branch Where ComAcc_Branch.ComAcc=ComAcc.ComAcc and Branch=@P_Branch)) or (ComAcc.Branch='' and NOT EXISTS (Select Top 1 ComAcc from ComAcc_Branch Where ComAcc_Branch.ComAcc=ComAcc.ComAcc)))     
)                                    

GO


-- Perbaikan untuk F2 item loss item
Drop Function FL_CL_KOL
GO
Create Function FL_CL_KOL(@P_CNO as Int, @P_INO AS Int, @P_KOL AS VARCHAR(50))           
RETURNS TABLE      
AS RETURN (      
          
SELECT KOL.KOL, KOL.DESCRIPTION, KOL.CATEGORY, Max(coalesce(KOLVALUE.COST,0)) as Cost, KOL.VATF, KOL.TAXF, KOLVALUE.BRANCH
FROM ICOVER        
INNER JOIN KOL ON (KOL.ALLOWEDF=1 and KOL.TOI=ICOVER.TOI AND (KOL.KOL LIKE @P_KOL or KOL.DESCRIPTION LIKE @P_KOL))        
INNER JOIN CLAIM ON (CLAIM.CNO=@P_CNO)    
LEFT JOIN CLINFO ON (CLINFO.CNO=CLAIM.CNO AND CLINFO.INO=ICOVER.INO)        
LEFT JOIN IINFO ON (IINFO.INO=ICOVER.INO)        
LEFT JOIN KOLVALUE ON (        
KOLVALUE.KOL=KOL.KOL        
AND (KOLVALUE.BRANCH='<All>' or KOLVALUE.BRANCH=CLAIM.BRANCH)      
And (coalesce(KOLVALUE.ValueID1,'')='' Or coalesce(CLINFO.ValueID1,IINFO.ValueID1)=coalesce(KOLVALUE.ValueID1,''))             
And (coalesce(KOLVALUE.ValueID2,'')='' Or coalesce(CLINFO.ValueID2,IINFO.ValueID2)=coalesce(KOLVALUE.ValueID2,''))             
And (coalesce(KOLVALUE.ValueID3,'')='' Or coalesce(CLINFO.ValueID3,IINFO.ValueID3)=coalesce(KOLVALUE.ValueID3,''))             
And (coalesce(KOLVALUE.ValueID4,'')='' Or coalesce(CLINFO.ValueID4,IINFO.ValueID4)=coalesce(KOLVALUE.ValueID4,''))             
And (coalesce(KOLVALUE.ValueID5,'')='' Or coalesce(CLINFO.ValueID5,IINFO.ValueID5)=coalesce(KOLVALUE.ValueID5,''))             
And (coalesce(KOLVALUE.ValueID6,'')='' Or coalesce(CLINFO.ValueID6,IINFO.ValueID6)=coalesce(KOLVALUE.ValueID6,''))             
And (coalesce(KOLVALUE.ValueID7,'')='' Or coalesce(CLINFO.ValueID7,IINFO.ValueID7)=coalesce(KOLVALUE.ValueID7,''))             
And (coalesce(KOLVALUE.ValueID8,'')='' Or coalesce(CLINFO.ValueID8,IINFO.ValueID8)=coalesce(KOLVALUE.ValueID8,''))             
And (coalesce(KOLVALUE.ValueID9,'')='' Or coalesce(CLINFO.ValueID9,IINFO.ValueID9)=coalesce(KOLVALUE.ValueID9,''))             
And (coalesce(KOLVALUE.ValueID10,'')='' Or coalesce(CLINFO.ValueID10,IINFO.ValueID10)=coalesce(KOLVALUE.ValueID10,''))             
And (coalesce(KOLVALUE.ValueID11,'')='' Or coalesce(CLINFO.ValueID11,IINFO.ValueID11)=coalesce(KOLVALUE.ValueID11,''))             
And (coalesce(KOLVALUE.ValueID12,'')='' Or coalesce(CLINFO.ValueID12,IINFO.ValueID12)=coalesce(KOLVALUE.ValueID12,''))             
And (coalesce(KOLVALUE.ValueID13,'')='' Or coalesce(CLINFO.ValueID13,IINFO.ValueID13)=coalesce(KOLVALUE.ValueID13,''))             
And (coalesce(KOLVALUE.ValueID14,'')='' Or coalesce(CLINFO.ValueID14,IINFO.ValueID14)=coalesce(KOLVALUE.ValueID14,''))             
And (coalesce(KOLVALUE.ValueID15,'')='' Or coalesce(CLINFO.ValueID15,IINFO.ValueID15)=coalesce(KOLVALUE.ValueID15,''))             
)        
WHERE ICOVER.INO=@P_INO        
Group By KOL.KOL, KOL.DESCRIPTION, KOL.CATEGORY, KOL.VATF, KOL.TAXF, KOLVALUE.BRANCH
)      
      
GO



DROP function VOUCHER_AMOUNTDUE_BY_VOUCHER
GO
CREATE function VOUCHER_AMOUNTDUE_BY_VOUCHER(@P_Date as smalldatetime, @P_Voucher as varchar(20))                
RETURNS Table                
AS RETURN                
(                
Select V.Voucher, V.Branch, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, V.Payment_CC, V.Payment_OC, V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate,              
(Case When V.Installment=0 and V.DueDate <=@P_Date Then V.Nominal_CC-V.Diff_CC else 0 end+                
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date Then V.AmountDue_1 else 0 end+                
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date Then V.AmountDue_2 else 0 end+                
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date Then V.AmountDue_3 else 0 end+                
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date Then V.AmountDue_4 else 0 end+                
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date Then V.AmountDue_5 else 0 end+                
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date Then V.AmountDue_6 else 0 end+                
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date Then V.AmountDue_7 else 0 end+                
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date Then V.AmountDue_8 else 0 end+                
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date Then V.AmountDue_9 else 0 end+                
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date Then V.AmountDue_10 else 0 end+                
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date Then V.AmountDue_11 else 0 end+                
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date Then V.AmountDue_12 else 0 end+ 
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date Then V.AmountDue_13 else 0 end+
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date Then V.AmountDue_14 else 0 end+
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date Then V.AmountDue_15 else 0 end+
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date Then V.AmountDue_16 else 0 end+
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date Then V.AmountDue_17 else 0 end+
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date Then V.AmountDue_18 else 0 end+
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date Then V.AmountDue_19 else 0 end+
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date Then V.AmountDue_20 else 0 end+
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date Then V.AmountDue_21 else 0 end+
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date Then V.AmountDue_22 else 0 end+
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date Then V.AmountDue_23 else 0 end+
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date Then V.AmountDue_24 else 0 end) as AmountDue,                
                    
Case When V.Installment=0 then V.DueDate                
When V.Payment_CC<V.AmountDue_1 then V.DueDate_1                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 then V.DueDate_12
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 then V.DueDate_13
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 then V.DueDate_14
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 then V.DueDate_15
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 then V.DueDate_16
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 then V.DueDate_17
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 then V.DueDate_18
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 then V.DueDate_19
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 then V.DueDate_20
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 then V.DueDate_21
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 then V.DueDate_22
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 then V.DueDate_23
Else V.DueDate_24
end as DueDate,                
(Case When V.Installment<>0 then ' Installment No. ' else '' end+                
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and V.Payment_CC<V.AmountDue_1 Then '1 ' else '' end+                
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+                
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+                
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+                
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+                
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+                
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+                
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+                
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+                
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  Then '10 ' else '' end+                
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+                              
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' else '' end+
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 Then '13 ' else '' end+
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 Then '14 ' else '' end+
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 Then '15 ' else '' end+
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 Then '16 ' else '' end+
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 Then '17 ' else '' end+
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 Then '18 ' else '' end+
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 Then '19 ' else '' end+
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 Then '20 ' else '' end+
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 Then '21 ' else '' end+
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 Then '22 ' else '' end+
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 Then '23 ' else '' end+
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 Then '24 ' else '' end+
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment                
from nVoucher V         
Where V.Date<=@P_Date and ((V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC)<>0 or V.PDate>=@P_Date)                
and V.Voucher=@P_Voucher
)                

GO



DROP function VOUCHER_AMOUNTWPCDUE
GO  
CREATE function VOUCHER_AMOUNTWPCDUE(@P_Date as smalldatetime)        
RETURNS Table        
AS RETURN        
(        
Select V.Voucher, V.Branch, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, V.Payment_CC, V.Payment_OC, V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate,      
(Case When V.Installment=0 and dateadd(day,A.WPC,V.DueDate) <=@P_Date Then V.Nominal_CC-V.Diff_CC else 0 end+        
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date Then V.AmountDue_1 else 0 end+                
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date Then V.AmountDue_2 else 0 end+                
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date Then V.AmountDue_3 else 0 end+                
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date Then V.AmountDue_4 else 0 end+                
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date Then V.AmountDue_5 else 0 end+                
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date Then V.AmountDue_6 else 0 end+                
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date Then V.AmountDue_7 else 0 end+                
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date Then V.AmountDue_8 else 0 end+                
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date Then V.AmountDue_9 else 0 end+                
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date Then V.AmountDue_10 else 0 end+                
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date Then V.AmountDue_11 else 0 end+                
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date Then V.AmountDue_12 else 0 end+ 
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date Then V.AmountDue_13 else 0 end+
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date Then V.AmountDue_14 else 0 end+
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date Then V.AmountDue_15 else 0 end+
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date Then V.AmountDue_16 else 0 end+
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date Then V.AmountDue_17 else 0 end+
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date Then V.AmountDue_18 else 0 end+
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date Then V.AmountDue_19 else 0 end+
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date Then V.AmountDue_20 else 0 end+
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date Then V.AmountDue_21 else 0 end+
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date Then V.AmountDue_22 else 0 end+
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date Then V.AmountDue_23 else 0 end+
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date Then V.AmountDue_24 else 0 end) as AmountDue,                  
          
Case When V.Installment=0 then dateadd(day, A.WPC,V.DueDate)                  
When V.Payment_CC<V.AmountDue_1 then V.DueDate_1                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11                
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 then V.DueDate_12
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 then V.DueDate_13
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 then V.DueDate_14
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 then V.DueDate_15
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 then V.DueDate_16
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 then V.DueDate_17
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 then V.DueDate_18
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 then V.DueDate_19
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 then V.DueDate_20
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 then V.DueDate_21
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 then V.DueDate_22
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 then V.DueDate_23
Else V.DueDate_24
end as DueDate,                
(Case When V.Installment<>0 then ' Installment No. ' else '' end+                
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and V.Payment_CC<V.AmountDue_1 Then '1 ' else '' end+                
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+                
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+                
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+                
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+                
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+                
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+                
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+                
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+                
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  Then '10 ' else '' end+                
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+                              
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' else '' end+
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 Then '13 ' else '' end+
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 Then '14 ' else '' end+
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 Then '15 ' else '' end+
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 Then '16 ' else '' end+
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 Then '17 ' else '' end+
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 Then '18 ' else '' end+
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 Then '19 ' else '' end+
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 Then '20 ' else '' end+
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 Then '21 ' else '' end+
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 Then '22 ' else '' end+
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 Then '23 ' else '' end+
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 Then '24 ' else '' end+
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment   
from nVoucher V inner join Admlink A On (A.Voucher=V.Voucher)        
Where V.Date<=@P_Date and ((V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC)<>0 or V.PDate>=@P_Date)        
)         
GO
DROP procedure PI08 
GO    
CREATE procedure PI08 (@P_ANO as integer)          
as          
Begin        
Declare @P_Date as smalldatetime    
 Declare @P_PolicyNo as varchar(20)    
 Declare @P_CertificateNo as varchar(20)    
 Declare @P_OpenFLag as Bit    
 Declare @P_LANO as int      
 Declare @P_A_PolicyNo as varchar(50)    
 Select @P_Date = Getdate()          
     
 Select @P_LANO=A1.LANO, @P_PolicyNo=A1.PolicyNo, @P_CertificateNo=A1.CertificateNo, @P_OpenFlag=C1.OpenFlag from Acceptance A1, Cover C1 Where C1.CNO=A1.CNO and A1.ANO=@P_ANO    
    
 if @P_LANO<>-1     
 if @P_OpenFlag=1 and @P_ANO<>@P_LANO     
  Select @P_A_PolicyNo=@P_PolicyNo + '-' + @P_CertificateNo    
 else    
  Select @P_A_PolicyNo=@P_PolicyNo    
 else    
  Select @P_A_PolicyNo=@P_PolicyNo      
   
 Select Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Voucher_Due.DueDate as NDueDate, Profile.Name, Voucher.Currency,    
 case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC) end  as Nominal,   
 case when Voucher.debtorf=1 then (coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) else -(coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) end as AmountDue,    
 case when Voucher.debtorf=1 then Voucher.Payment_CC else -Voucher.Payment_CC end as Payment,   
 case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC) end as Outstanding,  
 Voucher.Installment,      
 Voucher.DueDate_1, case when Voucher.debtorf=1 then Voucher.AmountDue_1 else -Voucher.AmountDue_1 end AmountDue_1,      
 Voucher.DueDate_2, case when Voucher.debtorf=1 then Voucher.AmountDue_2 else -Voucher.AmountDue_2 end AmountDue_2,      
 Voucher.DueDate_3, case when Voucher.debtorf=1 then Voucher.AmountDue_3 else -Voucher.AmountDue_3 end AmountDue_3,      
 Voucher.DueDate_4, case when Voucher.debtorf=1 then Voucher.AmountDue_4 else -Voucher.AmountDue_4 end AmountDue_4,      
 Voucher.DueDate_5, case when Voucher.debtorf=1 then Voucher.AmountDue_5 else -Voucher.AmountDue_5 end AmountDue_5,      
 Voucher.DueDate_6, case when Voucher.debtorf=1 then Voucher.AmountDue_6 else -Voucher.AmountDue_6 end AmountDue_6,      
 Voucher.DueDate_7, case when Voucher.debtorf=1 then Voucher.AmountDue_7 else -Voucher.AmountDue_7 end AmountDue_7,      
 Voucher.DueDate_8, case when Voucher.debtorf=1 then Voucher.AmountDue_8 else -Voucher.AmountDue_8 end AmountDue_8,      
 Voucher.DueDate_9, case when Voucher.debtorf=1 then Voucher.AmountDue_9 else -Voucher.AmountDue_9 end AmountDue_9,      
 Voucher.DueDate_10, case when Voucher.debtorf=1 then Voucher.AmountDue_10 else -Voucher.AmountDue_10 end AmountDue_10,      
 Voucher.DueDate_11, case when Voucher.debtorf=1 then Voucher.AmountDue_11 else -Voucher.AmountDue_11 end AmountDue_11,      
 Voucher.DueDate_12, case when Voucher.debtorf=1 then Voucher.AmountDue_12 else -Voucher.AmountDue_12 end AmountDue_12,
 Voucher.DueDate_13, case when Voucher.debtorf=1 then Voucher.AmountDue_13 else -Voucher.AmountDue_13 end AmountDue_13,      
 Voucher.DueDate_14, case when Voucher.debtorf=1 then Voucher.AmountDue_14 else -Voucher.AmountDue_14 end AmountDue_14,      
 Voucher.DueDate_15, case when Voucher.debtorf=1 then Voucher.AmountDue_15 else -Voucher.AmountDue_15 end AmountDue_15,      
 Voucher.DueDate_16, case when Voucher.debtorf=1 then Voucher.AmountDue_16 else -Voucher.AmountDue_16 end AmountDue_16,      
 Voucher.DueDate_17, case when Voucher.debtorf=1 then Voucher.AmountDue_17 else -Voucher.AmountDue_17 end AmountDue_17,      
 Voucher.DueDate_18, case when Voucher.debtorf=1 then Voucher.AmountDue_18 else -Voucher.AmountDue_18 end AmountDue_18,      
 Voucher.DueDate_19, case when Voucher.debtorf=1 then Voucher.AmountDue_19 else -Voucher.AmountDue_19 end AmountDue_19,      
 Voucher.DueDate_20, case when Voucher.debtorf=1 then Voucher.AmountDue_20 else -Voucher.AmountDue_20 end AmountDue_20,      
 Voucher.DueDate_21, case when Voucher.debtorf=1 then Voucher.AmountDue_21 else -Voucher.AmountDue_21 end AmountDue_21,      
 Voucher.DueDate_22, case when Voucher.debtorf=1 then Voucher.AmountDue_22 else -Voucher.AmountDue_22 end AmountDue_22,      
 Voucher.DueDate_23, case when Voucher.debtorf=1 then Voucher.AmountDue_23 else -Voucher.AmountDue_23 end AmountDue_23,      
 Voucher.DueDate_24, case when Voucher.debtorf=1 then Voucher.AmountDue_24 else -Voucher.AmountDue_24 end AmountDue_24
 from nVoucher Voucher Inner Join Voucher_AmountDue(@P_Date) Voucher_Due on (Voucher_Due.Voucher=Voucher.Voucher), Profile, ProAcc, Admlink  
 Where Profile.ID=ProAcc.ID and ProAcc.ProAcc=Voucher.ProAcc and Admlink.Voucher=Voucher.Voucher                
 and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') and Admlink.A_PolicyNo=@P_A_PolicyNo and (Admlink.Extra_1='' or Admlink.Extra_1 is null)  
End        
  
GO


--2 December 2014 : Perbaikan f2 loss item tidak bisa karena ditambahkan branch

DROP Function FL_CL_KOL
GO
Create Function FL_CL_KOL(@P_CNO as Int, @P_INO AS Int, @P_KOL AS VARCHAR(50))             
RETURNS TABLE        
AS RETURN (        
            
SELECT KOL.KOL, KOL.DESCRIPTION, KOL.CATEGORY, Max(coalesce(KOLVALUE.COST,0)) as Cost, KOL.VATF, KOL.TAXF, KOLVALUE.BRANCH  
FROM ICOVER          
INNER JOIN KOL ON (KOL.ALLOWEDF=1 and KOL.TOI=ICOVER.TOI AND (KOL.KOL LIKE @P_KOL or KOL.DESCRIPTION LIKE @P_KOL))          
INNER JOIN CLAIM ON (CLAIM.CNO=@P_CNO)      
LEFT JOIN CLINFO ON (CLINFO.CNO=CLAIM.CNO AND CLINFO.INO=ICOVER.INO)          
LEFT JOIN IINFO ON (IINFO.INO=ICOVER.INO)          
LEFT JOIN KOLVALUE ON (          
KOLVALUE.KOL=KOL.KOL AND KOLVALUE.TOI=KOL.TOI
AND (KOLVALUE.BRANCH='<All>' or KOLVALUE.BRANCH=CLAIM.BRANCH)        
And (coalesce(KOLVALUE.ValueID1,'')='' Or coalesce(CLINFO.ValueID1,IINFO.ValueID1)=coalesce(KOLVALUE.ValueID1,''))               
And (coalesce(KOLVALUE.ValueID2,'')='' Or coalesce(CLINFO.ValueID2,IINFO.ValueID2)=coalesce(KOLVALUE.ValueID2,''))               
And (coalesce(KOLVALUE.ValueID3,'')='' Or coalesce(CLINFO.ValueID3,IINFO.ValueID3)=coalesce(KOLVALUE.ValueID3,''))               
And (coalesce(KOLVALUE.ValueID4,'')='' Or coalesce(CLINFO.ValueID4,IINFO.ValueID4)=coalesce(KOLVALUE.ValueID4,''))               
And (coalesce(KOLVALUE.ValueID5,'')='' Or coalesce(CLINFO.ValueID5,IINFO.ValueID5)=coalesce(KOLVALUE.ValueID5,''))               
And (coalesce(KOLVALUE.ValueID6,'')='' Or coalesce(CLINFO.ValueID6,IINFO.ValueID6)=coalesce(KOLVALUE.ValueID6,''))               
And (coalesce(KOLVALUE.ValueID7,'')='' Or coalesce(CLINFO.ValueID7,IINFO.ValueID7)=coalesce(KOLVALUE.ValueID7,''))               
And (coalesce(KOLVALUE.ValueID8,'')='' Or coalesce(CLINFO.ValueID8,IINFO.ValueID8)=coalesce(KOLVALUE.ValueID8,''))               
And (coalesce(KOLVALUE.ValueID9,'')='' Or coalesce(CLINFO.ValueID9,IINFO.ValueID9)=coalesce(KOLVALUE.ValueID9,''))               
And (coalesce(KOLVALUE.ValueID10,'')='' Or coalesce(CLINFO.ValueID10,IINFO.ValueID10)=coalesce(KOLVALUE.ValueID10,''))               
And (coalesce(KOLVALUE.ValueID11,'')='' Or coalesce(CLINFO.ValueID11,IINFO.ValueID11)=coalesce(KOLVALUE.ValueID11,''))               
And (coalesce(KOLVALUE.ValueID12,'')='' Or coalesce(CLINFO.ValueID12,IINFO.ValueID12)=coalesce(KOLVALUE.ValueID12,''))               
And (coalesce(KOLVALUE.ValueID13,'')='' Or coalesce(CLINFO.ValueID13,IINFO.ValueID13)=coalesce(KOLVALUE.ValueID13,''))               
And (coalesce(KOLVALUE.ValueID14,'')='' Or coalesce(CLINFO.ValueID14,IINFO.ValueID14)=coalesce(KOLVALUE.ValueID14,''))               
And (coalesce(KOLVALUE.ValueID15,'')='' Or coalesce(CLINFO.ValueID15,IINFO.ValueID15)=coalesce(KOLVALUE.ValueID15,''))               
)          
WHERE ICOVER.INO=@P_INO          
Group By KOL.KOL, KOL.DESCRIPTION, KOL.CATEGORY, KOL.VATF, KOL.TAXF, KOLVALUE.BRANCH  
)        

GO


DROP PROCEDURE QREFERENCE_VALUE
GO
CREATE PROCEDURE QREFERENCE_VALUE(@P_CNO as Int, @P_INO AS Int, @P_KOL AS VARCHAR(50))             
AS            
            
SELECT KOL.KOL, KOL.DESCRIPTION, KOL.CATEGORY, Max(coalesce(KOLVALUE.COST,0)) as Cost, KOL.VATF, KOL.TAXF      
FROM ICOVER      
INNER JOIN KOL ON (KOL.ALLOWEDF=1 and KOL.TOI=ICOVER.TOI AND (KOL.KOL LIKE @P_KOL or KOL.DESCRIPTION LIKE @P_KOL))      
INNER JOIN CLAIM ON (CLAIM.CNO=@P_CNO)    
LEFT JOIN CLINFO ON (CLINFO.CNO=CLAIM.CNO AND CLINFO.INO=ICOVER.INO)      
LEFT JOIN IINFO ON (IINFO.INO=ICOVER.INO)      
LEFT JOIN KOLVALUE ON (      
KOLVALUE.KOL=KOL.KOL AND KOLVALUE.TOI=KOL.TOI
AND (KOLVALUE.BRANCH='<All>' or KOLVALUE.BRANCH=CLAIM.BRANCH)    
And (coalesce(KOLVALUE.ValueID1,'')='' Or coalesce(CLINFO.ValueID1,IINFO.ValueID1)=coalesce(KOLVALUE.ValueID1,''))           
And (coalesce(KOLVALUE.ValueID2,'')='' Or coalesce(CLINFO.ValueID2,IINFO.ValueID2)=coalesce(KOLVALUE.ValueID2,''))           
And (coalesce(KOLVALUE.ValueID3,'')='' Or coalesce(CLINFO.ValueID3,IINFO.ValueID3)=coalesce(KOLVALUE.ValueID3,''))           
And (coalesce(KOLVALUE.ValueID4,'')='' Or coalesce(CLINFO.ValueID4,IINFO.ValueID4)=coalesce(KOLVALUE.ValueID4,''))           
And (coalesce(KOLVALUE.ValueID5,'')='' Or coalesce(CLINFO.ValueID5,IINFO.ValueID5)=coalesce(KOLVALUE.ValueID5,''))           
And (coalesce(KOLVALUE.ValueID6,'')='' Or coalesce(CLINFO.ValueID6,IINFO.ValueID6)=coalesce(KOLVALUE.ValueID6,''))           
And (coalesce(KOLVALUE.ValueID7,'')='' Or coalesce(CLINFO.ValueID7,IINFO.ValueID7)=coalesce(KOLVALUE.ValueID7,''))           
And (coalesce(KOLVALUE.ValueID8,'')='' Or coalesce(CLINFO.ValueID8,IINFO.ValueID8)=coalesce(KOLVALUE.ValueID8,''))           
And (coalesce(KOLVALUE.ValueID9,'')='' Or coalesce(CLINFO.ValueID9,IINFO.ValueID9)=coalesce(KOLVALUE.ValueID9,''))           
And (coalesce(KOLVALUE.ValueID10,'')='' Or coalesce(CLINFO.ValueID10,IINFO.ValueID10)=coalesce(KOLVALUE.ValueID10,''))           
And (coalesce(KOLVALUE.ValueID11,'')='' Or coalesce(CLINFO.ValueID11,IINFO.ValueID11)=coalesce(KOLVALUE.ValueID11,''))           
And (coalesce(KOLVALUE.ValueID12,'')='' Or coalesce(CLINFO.ValueID12,IINFO.ValueID12)=coalesce(KOLVALUE.ValueID12,''))           
And (coalesce(KOLVALUE.ValueID13,'')='' Or coalesce(CLINFO.ValueID13,IINFO.ValueID13)=coalesce(KOLVALUE.ValueID13,''))           
And (coalesce(KOLVALUE.ValueID14,'')='' Or coalesce(CLINFO.ValueID14,IINFO.ValueID14)=coalesce(KOLVALUE.ValueID14,''))           
And (coalesce(KOLVALUE.ValueID15,'')='' Or coalesce(CLINFO.ValueID15,IINFO.ValueID15)=coalesce(KOLVALUE.ValueID15,''))           
)      
WHERE ICOVER.INO=@P_INO      
Group By KOL.KOL, KOL.DESCRIPTION, KOL.CATEGORY, KOL.VATF, KOL.TAXF   


GO



--9 December 2014 : Penambahan Flag Interflag pada account

DROP function FL_UserBranchAccountIO
GO
Create function FL_UserBranchAccountIO(@P_USERID varchar(10), @P_Branch varchar(10), @P_Account varchar(10), @P_DebtorF Bit)            
RETURNS Table              
AS RETURN              
(            
SELECT Branch.Branch, Branch.Name, Branch.Active_Flag, Branch.ShariaF      
from Branch, SysUser, Account, Type          
Where SysUser.ID=@P_UserID and Account.Account=@P_Account and Account.Inter_Flag=1 and Type.Type=Account.Type       
and Branch.Branch Like @P_Branch+'%' and Branch.Op_Flag=1       
and (SysUser.Type='SUPERVISOR'       
or Branch.Branch in (Select S.Branch from SysUserBranch S       
Where ((Type.PL_Flag=1 and S.IncomeReceiveF=1 and @P_DebtorF=1) or (Type.PL_Flag=1 and S.ExpensePaymentF=1 and @P_DebtorF=0) or (Account.Suspend_Flag=1 and S.SuspendReceiveF=1 and @P_DebtorF=1) or (Account.Suspend_Flag=1 and S.SuspendPaymentF=1 and @P_DebtorF=0)) and S.ID=SysUser.ID))        
)      
    

GO


--Perubahan Mekanisme Virtual Account

DROP View PaymentType      
GO  
Create View PaymentType    
as    
 Select 'CASH' as PaymentType, 'Cash Payment' as Description    
 union all    
 Select 'CHEQUE' as PaymentType, 'Cheque Payment' as Description    
 union all    
 Select 'GIRO' as PaymentType, 'Giro Payment' as Description    
 union all    
 Select 'CREDIT CARD' as PaymentType, 'Credit Card Payment' as Description    
 union all    
 Select 'TRANSFER' as PaymentType, 'Bank Transfer Payment' as Description    
 union all    
 Select 'AUTODEBIT' as PaymentType, 'Bank Auto Debit Payment' as description    
 union all    
 Select 'VIRTUAL' as PaymentType, 'Virtual Account Payment' as description  
go


--penambahan object info di menu Card Maintenance 


DROP procedure QCardMaintenance
GO
CREATE procedure QCardMaintenance(@P_TOC as varchar(10), @P_TypeOpt as Int, @P_StatusOpt as Int, @P_CardStatus varchar(10), @P_PeriodOpt as int, @P_SDate as smalldatetime, @P_EDate as smalldatetime)        
as          
      
Declare @SQL as varchar(4096)    
Declare @P_FLDTAG1 as varchar(50)    
Declare @P_FLDTAG2 as varchar(50)    
Declare @P_FLDTAG3 as varchar(50)    
Declare @P_FLDTAG4 as varchar(50)    
Declare @P_FLDTAG5 as varchar(50)    
Declare @P_FLDTAG6 as varchar(50)    
Declare @P_FLDTAG7 as varchar(50)    
Declare @P_FLDTAG8 as varchar(50)    
Declare @P_FLDTAG9 as varchar(50)    
Declare @P_FLDTAG10 as varchar(50)    
Declare @P_FLDTAG11 as varchar(50)    
Declare @P_FLDTAG12 as varchar(50)    
Declare @P_FLDTAG13 as varchar(50)    
Declare @P_FLDTAG14 as varchar(50)    
Declare @P_FLDTAG15 as varchar(50)    

Declare TOC_Cursor cursor for    
Select FLDTAG1, FLDTAG2, FLDTAG3, FLDTAG4, FLDTAG5, FLDTAG6, FLDTAG7, FLDTAG8, FLDTAG9, FLDTAG10, FLDTAG11, FLDTAG12, FLDTAG13, FLDTAG14, FLDTAG15    
from TOC Where TOC=@P_TOC
Open TOC_Cursor    
Fetch from TOC_Cursor into @P_FLDTAG1, @P_FLDTAG2, @P_FLDTAG3, @P_FLDTAG4, @P_FLDTAG5, @P_FLDTAG6, @P_FLDTAG7, @P_FLDTAG8, @P_FLDTAG9, @P_FLDTAG10, @P_FLDTAG11, @P_FLDTAG12, @P_FLDTAG13, @P_FLDTAG14, @P_FLDTAG15    
Deallocate TOC_Cursor    
    
Select @SQL=''    
--These Columns don't Change : #, policyNo, CertificateNo, CardNo, CardDate, CardStatus              
Select @SQL = 'Select A1.OANO as [#], A1.PolicyNo, A1.CertificateNo, A2.CardNo as [Card No.], A2.CardDate as [Card Date], A2.CardStatus as [Card Status], '
Select @SQL = @SQL + ' Max(A1.AName) as [Insured Name], '
if @P_FLDTAG1<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc1) as ['+@P_FLDTAG1+'],'    
if @P_FLDTAG2<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc2) as ['+@P_FLDTAG2+'],'    
if @P_FLDTAG3<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc3) as ['+@P_FLDTAG3+'],'    
if @P_FLDTAG4<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc4) as ['+@P_FLDTAG4+'],'    
if @P_FLDTAG5<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc5) as ['+@P_FLDTAG5+'],'    
if @P_FLDTAG6<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc6) as ['+@P_FLDTAG6+'],'    
if @P_FLDTAG7<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc7) as ['+@P_FLDTAG7+'],'    
if @P_FLDTAG8<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc8) as ['+@P_FLDTAG8+'],'    
if @P_FLDTAG9<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc9) as ['+@P_FLDTAG9+'],'    
if @P_FLDTAG10<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc10) as ['+@P_FLDTAG10+'],'    
if @P_FLDTAG11<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc11) as ['+@P_FLDTAG11+'],'    
if @P_FLDTAG12<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc12) as ['+@P_FLDTAG12+'],'    
if @P_FLDTAG13<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc13) as ['+@P_FLDTAG13+'],'    
if @P_FLDTAG14<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc14) as ['+@P_FLDTAG14+'],'    
if @P_FLDTAG15<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc15) as ['+@P_FLDTAG15+'],'       
Select @SQL = @SQL+' Max(A1.Branch) as Branch, Min(A1.SDate) as Inception, Max(A1.EDate) as Expiry, MAx(A1.PDate) as Effective, Max(A1.AStatus) as [Policy Status] '   
Select @SQL = @SQL + ' from Cover C1 Inner join Acceptance A1 on (C1.CNO=A1.CNO) Left Join AccCard A2 on (A2.ANO=A1.OANO) Left Join AInfo A3 on (A3.ANO=A1.ANO) '
Select @SQL = @SQL + ' Where A1.AStatus<>''W'' and A1.AType not in (''A'',''C'') and A1.ANO<>A1.LANO     '
Select @SQL = @SQL + ' and C1.TOC='+''''+@P_TOC+''''    

if @P_TypeOpt=0
	Select @SQL = @SQL + ' and C1.ISType=''I'''
else if @P_TypeOpt=1
	Select @SQL = @SQL + ' and C1.ISType=''L'''
if @P_StatusOpt=1
	Select @SQL = @SQL + ' and A2.CardNo is null'
else if @P_StatusOpt>=2
	Select @SQL = @SQL + ' and A2.CardStatus=' + '''' + @P_CardStatus + ''''


if @P_PeriodOpt=0
	Select @SQL = @SQL + ' and A1.SDate Between ' + '''' + convert(varchar(20), @P_Sdate,1) + '''' + ' and ' + + '''' + convert(varchar(20), @P_EDate,1) + ''''
else if @P_PeriodOpt=1	
	Select @SQL = @SQL + ' and A1.ADate Between ' + '''' + convert(varchar(20), @P_Sdate,1) + '''' + ' and ' + + '''' + convert(varchar(20), @P_EDate,1) + ''''

Select @SQL = @SQL + ' Group By A1.OANO, A1.PolicyNo, A1.CertificateNo,A2.CardNo, A2.CardDate, A2.CardStatus      '    

Execute (@SQL)


GO



--Penambahan Unpaid premium pada aging


DROP PROCEDURE dbo.List19   
GO  
CREATE PROCEDURE dbo.List19 (@P_Days as smallint,@P_Date as Smalldatetime,@P_COB as varchar(10),@P_Branch as varchar(10), @P_UnPaidOpt as bit)      
AS      
SELECT Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,       
 Cast(Acceptance.AName as varchar(128)) as Insured,       
 Cover.CNO,       
 Cover.CStatus,       
 Acceptance.lANO,       
 Acceptance.ANO,       
 Acceptance.REGNO,       
 Acceptance.ADATE,       
 Acceptance.LUSERID as USERID,       
 SysTab.Currency,       
 QPCalc.TSI,       
 QPCalc.OurShare,       
 QPCalc.Gross,       
 Acceptance.ASTATUS,       
 Acceptance.ATYPE,       
 Acceptance.SDate,       
 Acceptance.EDate,       
 Year(Acceptance.SDate) AS RYear,       
 Cover.ISType,       
 Acceptance.Renewal,       
 Acceptance.ESeqNo,       
 Acceptance.PolicyNo,       
 Acceptance.CertificateNo      
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, TOC    
WHERE  Cover.CNO=Acceptance.CNO     
 And TOC.TOC=Cover.TOC and TOC.COB=@P_COB And Acceptance.Branch Like @P_Branch+'%'
 And QPCalc.ANO=Acceptance.ANO      
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)And Cover.ISType<>'T'       
 And Acceptance.AStatus='I' And Acceptance.AType<>'C'      
 And Acceptance.OANO in (SELECT A1.OANO from Acceptance A1, AccAss, Admlink, nVoucher Voucher Where A1.ANO=AccAss.ANO and A1.OANO=Acceptance.OANO and Voucher.Voucher=Admlink.Voucher and Admlink.AdmNo=AccAss.AdmNo and AccAss.Type in ('DI','IC','IR') and Voucher.nDueDate+@P_Days<@P_Date and Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC<>0 and (@P_UnPaidOpt=0 or Voucher.Payment_CC=0))      
      
union      
      
SELECT Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,       
 Cast(Acceptance.AName as varchar(128)) as Insured,       
 Cover.CNO,       
 Cover.CStatus,       
 Acceptance.lANO,       
 Acceptance.ANO,       
 Acceptance.REGNO,       
 Acceptance.ADATE,       
 Acceptance.LUSERID as USERID,       
 SysTab.Currency,       
 QPCalc.TSI,       
 QPCalc.OurShare,       
 QPCalc.Gross,       
 Acceptance.ASTATUS,       
 Acceptance.ATYPE,       
 Acceptance.SDate,       
 Acceptance.EDate,       
 Year(Acceptance.SDate) AS RYear,       
 Cover.ISType,       
 Acceptance.Renewal,       
 Acceptance.ESeqNo,       
 Acceptance.PolicyNo,       
 Acceptance.CertificateNo      
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, Acceptance As Acceptance_Detail, TOC    
WHERE  Cover.CNO=Acceptance.CNO       
 And TOC.TOC=Cover.TOC and TOC.COB=@P_COB And Acceptance_Detail.Branch Like @P_Branch+'%'
 And QPCalc.ANO=Acceptance.ANO       
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO And Cover.ISType<>'T'       
 And Acceptance.AStatus='I' And Acceptance.AType<>'C'      
 And Acceptance_Detail.AStatus='I'  And Acceptance_Detail.AType<>'C'      
 And Acceptance_Detail.OANO in (SELECT A1.OANO from Acceptance A1, AccAss, Admlink, nVoucher Voucher Where A1.ANO=AccAss.ANO and A1.OANO=Acceptance_Detail.OANO and Voucher.Voucher=Admlink.Voucher and Admlink.AdmNo=AccAss.AdmNo and AccAss.Type in ('DI','IC','IR') and Voucher.nDueDate+@P_Days<@P_Date and Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC<>0 and (@P_UnPaidOpt=0 or Voucher.Payment_CC=0))      
    
  
GO  
DROP FUNCTION List19_Det 
GO
CREATE FUNCTION List19_Det (@P_ANO as integer, @P_Days as smallint, @P_Date as Smalldatetime,@P_COB as varchar(10),@P_Branch as varchar(10), @P_UnPaidOpt as Bit)      
RETURNS TABLE      
as RETURN(      
      
SELECT Cast(0 as bit) as ProcessFlag,      
 [Acceptance].[CertificateNo],       
 Acceptance.ESeqNo,      
 [Acceptance].[AName],       
 [Acceptance].[ANO],       
 [Acceptance].[REGNO],       
 [Acceptance].[ADATE],       
 [Acceptance].[LUSERID] as UserID,       
 [SysTab].[Currency],       
 [QPCalc].[TSI],       
 [QPCalc].[OurShare],       
 [QPCalc].[Gross],       
 [Acceptance].[ASTATUS],       
 [Acceptance].[ATYPE],       
 [Acceptance].[SDate],       
 [Acceptance].[EDate],       
 Year([Acceptance].[SDate]) AS RYear,  
 Acceptance.ValueID,  
 Acceptance.ValueDesc  
      
FROM       
 Acceptance,       
 Cover,       
 SysTab,       
 QMasterAcceptance_PCalc() AS QPCalc,    
 TOC    
WHERE       
 [Cover].[CNO]=[Acceptance].[CNO]       
 And TOC.TOC=Cover.TOC and TOC.COB=@P_COB And Acceptance.Branch Like @P_Branch+'%'
 And [QPCalc].[ANO]=[Acceptance].[ANO]       
 And [Acceptance].[ANO]<>[Acceptance].[LANO]       
 And [Acceptance].[LANO]=@P_ANO       
 And [Cover].[ISType]<>'T'      
 And Acceptance.AStatus='I'  And Acceptance.AType<>'C'      
 And Acceptance.OANO in (SELECT A1.OANO from Acceptance A1, AccAss, Admlink, nVoucher Voucher Where A1.ANO=AccAss.ANO and A1.OANO=Acceptance.OANO and Voucher.Voucher=Admlink.Voucher and Admlink.AdmNo=AccAss.AdmNo and AccAss.Type in ('DI','IC','IR') and Voucher.nDueDate+@P_Days<@P_Date and Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC<>0 and (@P_UnPaidOpt=0 or Voucher.Payment_CC=0))      
)      
      
GO


DROP function FL_UserBranchAccountIO
GO
Create function FL_UserBranchAccountIO(@P_USERID varchar(10), @P_Branch varchar(10), @P_Account varchar(10), @P_DebtorF Bit)            
RETURNS Table              
AS RETURN              
(            
SELECT Branch.Branch, Branch.Name, Branch.Active_Flag, Branch.ShariaF      
from Branch, SysUser, Account, Type          
Where SysUser.ID=@P_UserID and Account.Account=@P_Account and Account.Inter_Flag=1 and Type.Type=Account.Type       
and Branch.Branch Like @P_Branch+'%' and Branch.Op_Flag=1       
and (SysUser.Type='SUPERVISOR'       
or Branch.Branch in (Select S.Branch from SysUserBranch S       
Where ((Type.PL_Flag=1 and S.IncomeReceiveF=1 and @P_DebtorF=1) or (Type.PL_Flag=1 and S.ExpensePaymentF=1 and @P_DebtorF=0) or (Type.BS_Flag=1 and S.SuspendReceiveF=1 and @P_DebtorF=1) or (Type.BS_Flag=1 and S.SuspendPaymentF=1 and @P_DebtorF=0)) and S.ID=SysUser.ID))        
)      
            
    
GO


DROP Function FL_CL_KOL
GO
Create Function FL_CL_KOL(@P_CNO as Int, @P_INO AS Int, @P_KOL AS VARCHAR(50))             
RETURNS TABLE        
AS RETURN (        
            
SELECT KOL.KOL, KOL.DESCRIPTION, KOL.CATEGORY, Max(coalesce(KOLVALUE.COST,0)) as Cost, KOL.VATF, KOL.TAXF, KOLVALUE.BRANCH  
FROM ICOVER          
INNER JOIN KOL ON (KOL.ALLOWEDF=1 and KOL.TOI=ICOVER.TOI AND (KOL.KOL LIKE @P_KOL or KOL.DESCRIPTION LIKE @P_KOL))          
INNER JOIN CLAIM ON (CLAIM.CNO=@P_CNO)      
LEFT JOIN CLINFO ON (CLINFO.CNO=CLAIM.CNO AND CLINFO.INO=ICOVER.INO)          
LEFT JOIN IINFO ON (IINFO.INO=ICOVER.INO)          
LEFT JOIN KOLVALUE ON (KOLVALUE.KOL=KOL.KOL AND KOLVALUE.TOI=KOL.TOI 
AND 
(
KOLVALUE.BRANCH='<All>' 
OR EXISTS 
	(
	SELECT CASE WHEN COALESCE(PAYMENT.BRANCH,'')='' THEN CLAIM.BRANCH ELSE PAYMENT.BRANCH END
	FROM CLLOSS, PROFILE PAYMENT 
	WHERE PAYMENT.ID=CLLOSS.PAYMENT AND CLLOSS.CNO=CLAIM.CNO AND CLLOSS.INO=ICOVER.INO AND CASE WHEN COALESCE(PAYMENT.BRANCH,'')='' THEN CLAIM.BRANCH ELSE PAYMENT.BRANCH END=KOLVALUE.BRANCH
	)
)
And (coalesce(KOLVALUE.ValueID1,'')='' Or coalesce(CLINFO.ValueID1,IINFO.ValueID1)=coalesce(KOLVALUE.ValueID1,''))               
And (coalesce(KOLVALUE.ValueID2,'')='' Or coalesce(CLINFO.ValueID2,IINFO.ValueID2)=coalesce(KOLVALUE.ValueID2,''))               
And (coalesce(KOLVALUE.ValueID3,'')='' Or coalesce(CLINFO.ValueID3,IINFO.ValueID3)=coalesce(KOLVALUE.ValueID3,''))               
And (coalesce(KOLVALUE.ValueID4,'')='' Or coalesce(CLINFO.ValueID4,IINFO.ValueID4)=coalesce(KOLVALUE.ValueID4,''))               
And (coalesce(KOLVALUE.ValueID5,'')='' Or coalesce(CLINFO.ValueID5,IINFO.ValueID5)=coalesce(KOLVALUE.ValueID5,''))               
And (coalesce(KOLVALUE.ValueID6,'')='' Or coalesce(CLINFO.ValueID6,IINFO.ValueID6)=coalesce(KOLVALUE.ValueID6,''))               
And (coalesce(KOLVALUE.ValueID7,'')='' Or coalesce(CLINFO.ValueID7,IINFO.ValueID7)=coalesce(KOLVALUE.ValueID7,''))               
And (coalesce(KOLVALUE.ValueID8,'')='' Or coalesce(CLINFO.ValueID8,IINFO.ValueID8)=coalesce(KOLVALUE.ValueID8,''))               
And (coalesce(KOLVALUE.ValueID9,'')='' Or coalesce(CLINFO.ValueID9,IINFO.ValueID9)=coalesce(KOLVALUE.ValueID9,''))               
And (coalesce(KOLVALUE.ValueID10,'')='' Or coalesce(CLINFO.ValueID10,IINFO.ValueID10)=coalesce(KOLVALUE.ValueID10,''))               
And (coalesce(KOLVALUE.ValueID11,'')='' Or coalesce(CLINFO.ValueID11,IINFO.ValueID11)=coalesce(KOLVALUE.ValueID11,''))               
And (coalesce(KOLVALUE.ValueID12,'')='' Or coalesce(CLINFO.ValueID12,IINFO.ValueID12)=coalesce(KOLVALUE.ValueID12,''))               
And (coalesce(KOLVALUE.ValueID13,'')='' Or coalesce(CLINFO.ValueID13,IINFO.ValueID13)=coalesce(KOLVALUE.ValueID13,''))               
And (coalesce(KOLVALUE.ValueID14,'')='' Or coalesce(CLINFO.ValueID14,IINFO.ValueID14)=coalesce(KOLVALUE.ValueID14,''))               
And (coalesce(KOLVALUE.ValueID15,'')='' Or coalesce(CLINFO.ValueID15,IINFO.ValueID15)=coalesce(KOLVALUE.ValueID15,''))               
)          
WHERE ICOVER.INO=@P_INO          
Group By KOL.KOL, KOL.DESCRIPTION, KOL.CATEGORY, KOL.VATF, KOL.TAXF, KOLVALUE.BRANCH  
)        

GO

DROP PROCEDURE QREFERENCE_VALUE
GO
CREATE PROCEDURE QREFERENCE_VALUE(@P_CNO as Int, @P_INO AS Int, @P_KOL AS VARCHAR(50))             
AS            
            
SELECT KOL.KOL, KOL.DESCRIPTION, KOL.CATEGORY, Max(coalesce(KOLVALUE.COST,0)) as Cost, KOL.VATF, KOL.TAXF      
FROM ICOVER      
INNER JOIN KOL ON (KOL.ALLOWEDF=1 and KOL.TOI=ICOVER.TOI AND (KOL.KOL LIKE @P_KOL or KOL.DESCRIPTION LIKE @P_KOL))      
INNER JOIN CLAIM ON (CLAIM.CNO=@P_CNO)    
LEFT JOIN CLINFO ON (CLINFO.CNO=CLAIM.CNO AND CLINFO.INO=ICOVER.INO)      
LEFT JOIN IINFO ON (IINFO.INO=ICOVER.INO)      
LEFT JOIN KOLVALUE ON (KOLVALUE.KOL=KOL.KOL AND KOLVALUE.TOI=KOL.TOI 
AND 
(
KOLVALUE.BRANCH='<All>' 
OR EXISTS 
	(
	SELECT CASE WHEN COALESCE(PAYMENT.BRANCH,'')='' THEN CLAIM.BRANCH ELSE PAYMENT.BRANCH END
	FROM CLLOSS, PROFILE PAYMENT 
	WHERE PAYMENT.ID=CLLOSS.PAYMENT AND CLLOSS.CNO=CLAIM.CNO AND CLLOSS.INO=ICOVER.INO AND CASE WHEN COALESCE(PAYMENT.BRANCH,'')='' THEN CLAIM.BRANCH ELSE PAYMENT.BRANCH END=KOLVALUE.BRANCH
	)
)
And (coalesce(KOLVALUE.ValueID1,'')='' Or coalesce(CLINFO.ValueID1,IINFO.ValueID1)=coalesce(KOLVALUE.ValueID1,''))           
And (coalesce(KOLVALUE.ValueID2,'')='' Or coalesce(CLINFO.ValueID2,IINFO.ValueID2)=coalesce(KOLVALUE.ValueID2,''))           
And (coalesce(KOLVALUE.ValueID3,'')='' Or coalesce(CLINFO.ValueID3,IINFO.ValueID3)=coalesce(KOLVALUE.ValueID3,''))           
And (coalesce(KOLVALUE.ValueID4,'')='' Or coalesce(CLINFO.ValueID4,IINFO.ValueID4)=coalesce(KOLVALUE.ValueID4,''))           
And (coalesce(KOLVALUE.ValueID5,'')='' Or coalesce(CLINFO.ValueID5,IINFO.ValueID5)=coalesce(KOLVALUE.ValueID5,''))           
And (coalesce(KOLVALUE.ValueID6,'')='' Or coalesce(CLINFO.ValueID6,IINFO.ValueID6)=coalesce(KOLVALUE.ValueID6,''))           
And (coalesce(KOLVALUE.ValueID7,'')='' Or coalesce(CLINFO.ValueID7,IINFO.ValueID7)=coalesce(KOLVALUE.ValueID7,''))           
And (coalesce(KOLVALUE.ValueID8,'')='' Or coalesce(CLINFO.ValueID8,IINFO.ValueID8)=coalesce(KOLVALUE.ValueID8,''))           
And (coalesce(KOLVALUE.ValueID9,'')='' Or coalesce(CLINFO.ValueID9,IINFO.ValueID9)=coalesce(KOLVALUE.ValueID9,''))           
And (coalesce(KOLVALUE.ValueID10,'')='' Or coalesce(CLINFO.ValueID10,IINFO.ValueID10)=coalesce(KOLVALUE.ValueID10,''))           
And (coalesce(KOLVALUE.ValueID11,'')='' Or coalesce(CLINFO.ValueID11,IINFO.ValueID11)=coalesce(KOLVALUE.ValueID11,''))           
And (coalesce(KOLVALUE.ValueID12,'')='' Or coalesce(CLINFO.ValueID12,IINFO.ValueID12)=coalesce(KOLVALUE.ValueID12,''))           
And (coalesce(KOLVALUE.ValueID13,'')='' Or coalesce(CLINFO.ValueID13,IINFO.ValueID13)=coalesce(KOLVALUE.ValueID13,''))           
And (coalesce(KOLVALUE.ValueID14,'')='' Or coalesce(CLINFO.ValueID14,IINFO.ValueID14)=coalesce(KOLVALUE.ValueID14,''))           
And (coalesce(KOLVALUE.ValueID15,'')='' Or coalesce(CLINFO.ValueID15,IINFO.ValueID15)=coalesce(KOLVALUE.ValueID15,''))           
)      
WHERE ICOVER.INO=@P_INO      
Group By KOL.KOL, KOL.DESCRIPTION, KOL.CATEGORY, KOL.VATF, KOL.TAXF   


GO

-- Penambahan kolom remark voucher report
DROP FUNCTION R_SL_ALLOCATED
GO
CREATE FUNCTION R_SL_ALLOCATED(@P_PDate as smalldatetime)                                     
RETURNS TABLE  AS                                       
RETURN (                                     
                             
--SL from Payment Voucher                                   
Select SL.Voucher, SL.Remarks, Voucher.Date, SL.Branch, Voucher.Date as Doc_Date, Voucher.Currency as Doc_CCY, SL.Voucher as Doc_No, SL.Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(SL.Rate*SL.Nominal_OC) as Nominal_OC                                
  
   
From             
(            
--Part Of OSL Functions            
Select pSL.Voucher, pSL.Doc_No, pSL.Doc_Date, pSL.Doc_CCY, pSL.Nominal_OC, pSL.CT, pSL.Nominal, pSL.Hint,  
Case When OSL.Remarks is null Then pSL.Remarks else OSL.Remarks end as Remarks,                
Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end as PaymentF,                  
Case When OSL.Account is null then pSL.Account else OSL.Account end as Account,                  
Case When OBranch.Branch is null then pVoucher.Branch else OBranch.Branch end as Branch, pSL.Nominator, pSL.Denominator, pSL.Rate, pSL.SortNo, pSL.pVoucher                
From dbo.pSL                  
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)                  
Left join dbo.Branch OBranch on (OBranch.OP_FLAG=1 and OBranch.IO_Account=pSL.Account)                  
Left Join dbo.pVoucher OVoucher on (OBranch.Branch=OVoucher.Branch and OVoucher.RefNo=pSL.Voucher and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE')                  
Left join dbo.pSL OSL on (OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo))                  
Where pVoucher.SL_Cat in ('P') and Coalesce(OSL.PaymentF, pSL.PaymentF)=1 and pVoucher.Date<=@P_PDate            
            
) SL, pVoucher Voucher            
Where SL.Voucher=Voucher.Voucher             
Group By SL.Voucher, SL.Remarks, Voucher.Date, SL.Branch, Voucher.Date, Voucher.Currency, SL.Account                       
                                   
union all                                   
                                   
--SL from Overbooking Payment and Adjustment Payment                                   
Select SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.Voucher as Doc_No, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end as Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                        
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal_OC else -SL.Nominal_OC end*SL.Rate)) as Nominal_OC                                   
from pSL SL, pVoucher VoucherP, pVoucher VoucherR, VPattern                         
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('B','A') and VoucherP.SL_Cat='P' and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher and SL.PaymentF=1 and VoucherR.Date<=@P_PDate                   
and VPattern.VType=VoucherR.VType and ((VPattern.Debit=SL.hint and VoucherR.DebtorF=1) or (VPattern.Credit=SL.hint and VoucherR.CreditorF=1))                         
Group By SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Date, VoucherR.Currency, VoucherP.Voucher, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end, SL.Account                                
                             
union all                                   
                                   
--SL from Adjustment Overbooking                                   
Select SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.RefNo as Doc_No, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end as Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                        
sum((case When VoucherR.DebtorF=pVoucher.DebtorF Then SL.Nominal_OC else -SL.Nominal_OC end*SL.Rate)) as Nominal_OC                                   
from pSL SL, pVoucher VoucherP, pVoucher VoucherR, pVoucher, VPattern                         
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('A') and VoucherP.SL_Cat in ('B') and VoucherR.RefNo=VoucherP.Voucher and pVoucher.SL_Cat in ('P') and VoucherP.RefNo=pVoucher.Voucher and SL.Voucher=VoucherR.Voucher and SL.PaymentF=1 and VoucherR.Date<=@P_PDate            
and VPattern.VType=VoucherR.VType and ((VPattern.Debit=SL.hint and VoucherR.DebtorF=1) or (VPattern.Credit=SL.hint and VoucherR.CreditorF=1))                         
Group By SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Date, VoucherR.Currency, VoucherP.RefNo, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end, SL.Account                       
                                   
union all                                   
                                   
--SL from Sub Ledger Payment Voucher and OverPaid                                   
Select SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, SL.Doc_Date, SL.Doc_CCY, SL.Doc_No as Doc_No, SL.Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                        
(Case When VoucherR.SL_Cat='O'                                    
then (case when VoucherR.DebtorF=VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                    
else (case when VoucherR.DebtorF<>VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                   
end) as Nominal_OC                                   
from pSL SL, pVoucher VoucherP, pVoucher VoucherR                                   
Where VoucherR.SL_Cat in ('O','P','A','B') and VoucherP.SL_Cat in ('P') and VoucherR.Voucher=SL.Voucher and SL.Doc_No=VoucherP.Voucher and SL.PaymentF=1 and VoucherR.Date<=@P_PDate                                  
                                     
)   

GO


--perbaikan untuk ICPS
alter Function FL_CL_DED (@P_CNO AS INTEGER)  

RETURNS TABLE  

AS RETURN  (

--QCLACC02

      SELECT DISTINCT ACCDED.DCODE,ACCDED.REMARKS,case when coalesce(ACCDED.CURRENCY,'')='' then 'IDR' else ACCDED.CURRENCY end as CURRENCY  ,CLAIM.CNO, ACCDED.TOR,  CLAIM.PAYMENT 

      From CLAIM, ACCDED, COL, ACCEPTANCE        

      WHERE CLAIM.CNO=@P_CNO        

      AND ACCDED.ANO=CLAIM.ANO AND ACCEPTANCE.ANO=ACCDED.ANO        

      AND ((ACCDED.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ACCDED.SDATE<CLAIM.LOSSDATE or (ACCDED.SDATE=CLAIM.LOSSDATE AND '12:00'<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           

      AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)>CLAIM.LOSSDATE
or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)=CLAIM.LOSSDATE AND '12:00'>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          

      AND COL.COL=CLAIM.COL AND ACCDED.TOR=COL.TOR             

)    
go     



--13 March 2015 : Penambahan settingan centangan branch requestF

DROP function FL_UserBranch_RQ
GO  
Create function FL_UserBranch_RQ(@P_USERID varchar(10), @P_Branch varchar(10))        
RETURNS Table          
AS RETURN          
(        
SELECT Branch.Branch, Branch.Name, Branch.Active_Flag, Branch.ShariaF  
from Branch, SysUser      
Where SysUser.ID=@P_UserID and Branch.Branch Like @P_Branch+'%' and Branch.Op_Flag=1      
and (SysUser.Type='SUPERVISOR' or Branch.Branch in (Select S.Branch from SysUserBranch S Where S.RequestF=1 and S.ID=@P_UserID))  
)    
  
  
GO


--19 March 2015 : Penambahan search By Batchno scheme

  
DROP procedure SchemeList
GO    
CREATE procedure SchemeList(@p_SchemeNo varchar(10),@P_PolicyNo varchar(20), @P_Branch varchar(20), @p_SDate smalldatetime,@p_EDate smalldatetime, @P_Status as varchar(10),@P_UserID as varchar(10), @P_BatchNoF as varchar(10)='', @P_BatchNoL as varchar(10)='', @P_CertificateNoF as varchar(10)='', @P_CertificateNoL as varchar(10)='')              
as              
                  
select  s.*, PCalc.Gross, c.insured, sm.description              
From              
 scheme_transaction as s    
 Left join PCalc on (PCalc.ANO=S.ANO)     
 Inner join Acceptance as a on (A.ANO=S.LANO and A.ANO=A.LANO and A.AStatus<>'W')         
 Inner join Cover as C on (C.CNO=A.CNO)    
 Inner join scheme_master As sm on (sm.SchemeNo=S.SchemeNo)    
Where              
 sm.schemeno Like @p_SchemeNo+'%'       
 and a.PolicyNo Like @P_PolicyNo+'%' and a.Branch like @P_Branch+'%'       
 and s.trdate >=@p_SDate and s.trDate<=@p_EDate       
 and (s.Status=@P_Status or @P_Status='') and (s.LUserID=@P_UserID or @P_UserID='')       
 and (@P_BatchNoF='' or s.BatchNo>=@P_BatchNoF)  
 and (@P_BatchNoL='' or s.BatchNo<=@P_BatchNoL)  
 and (@P_CertificateNoF='' or s.BatchNo>=@P_CertificateNoF)  
 and (@P_CertificateNoL='' or s.BatchNo<=@P_CertificateNoL)   
order by s.TrNo                

GO


DROP function ListDet05_a
GO  
Create function ListDet05_a (@P_ANO as integer,   
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),   
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),  
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),  
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255)  
)        
RETURNS Table      
AS RETURN      
(      
 SELECT Cast(0 as bit) as ProcessFlag,      
 Acceptance.CertificateNo,      
 Acceptance.ESeqNo,      
 Acceptance.AName,      
 Acceptance.ANO,      
 Acceptance.REGNO,      
 Acceptance.ADATE,      
 Acceptance.LUSERID as UserID,      
 SysTab.Currency,      
 QPCalc.TSI,      
 QPCalc.OurShare,      
 QPCalc.Gross,      
 Acceptance.ASTATUS,      
 Acceptance.ATYPE,      
 Acceptance.SDate,      
 Acceptance.EDate,      
 Year(Acceptance.SDate) AS RYear,      
 Acceptance.ValueID,      
 Acceptance.ValueDesc      
From      
 Acceptance,      
 Cover,      
 SysTab,      
 QMasterAcceptance_PCalc() AS QPCalc,      
 Profile      
Where      
 cover.CNO = acceptance.CNO      
 And QPCalc.ANO=Acceptance.ANO      
 And Acceptance.ANO<>Acceptance.LANO      
 And Acceptance.LANO=@P_ANO      
 And Cover.PHOLDER=Profile.ID      
 And ((Cover.Insured Like @Value1 Or Cover.Insured is null) or (Acceptance.AName Like @Value1 Or Acceptance.AName is null))      
 And (Cover.CoverNo Like @Value2 Or Cover.CoverNo is null)      
 and (Cover.CoverDate = @Value3 Or Cover.CoverDate is null or @Value7 = '')      
 And (Cover.ExpDate = @Value4 Or Cover.ExpDate is null or @Value7 = '')      
 And (Acceptance.PolicyNo Like @Value5 Or Acceptance.PolicyNo is null)      
 And (Acceptance.CertificateNo Like @Value6 Or Acceptance.CertificateNo is null)      
 And (Acceptance.PolicyDate = @Value7 Or Acceptance.PolicyDate is null or @Value7 = '' or Acceptance.PolicyDate Between @Value7 and @Value16)      
 And (Acceptance.RegDate = @Value17 Or Acceptance.RegDate is null or @Value17 = '' or Acceptance.RegDate Between @Value17 and @Value18)      
 And Acceptance.AType Like @Value8      
 And Acceptance.AStatus Like @Value9      
 And Acceptance.RegNo Like @Value10      
 And Profile.Name Like @Value11     
 and cover.toc like @Value12      
 and (acceptance.refno like @Value13 or acceptance.refno is null)      
 and (Acceptance.Matters=@Value14 or @Value14='')      
 And Cover.ISType<>'T'      
 And (@Value15='%' or @Value15='' or Exists (SELECT top 1 1 from Service Where Service.ANO=Acceptance.ANO and SStatus<>'R' and ServiceNo Like @Value15))      
 And (Acceptance.BatchNo Like @Value19 or (Acceptance.BatchNo is null and @Value19='%'))   
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')  
 And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance.CANO from Acceptance CAcceptance Where CAcceptance.CANO=Acceptance.ANO and CAcceptance.LANO=Acceptance.LANO)))          
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')  
 
 Union 
 
 SELECT Cast(0 as bit) as ProcessFlag,      
 CAcceptance.CertificateNo,      
 CAcceptance.ESeqNo,      
 CAcceptance.AName,      
 CAcceptance.ANO,      
 CAcceptance.REGNO,      
 CAcceptance.ADATE,      
 CAcceptance.LUSERID as UserID,      
 SysTab.Currency,      
 QPCalc.TSI,      
 QPCalc.OurShare,      
 QPCalc.Gross,      
 CAcceptance.ASTATUS,      
 CAcceptance.ATYPE,      
 CAcceptance.SDate,      
 CAcceptance.EDate,      
 Year(CAcceptance.SDate) AS RYear,      
 CAcceptance.ValueID,      
 CAcceptance.ValueDesc      
From      
 Acceptance,      
 Cover,      
 SysTab,      
 QMasterAcceptance_PCalc() AS QPCalc,      
 Profile, 
 Acceptance CAcceptance   
WHERE @Value21='1' and CAcceptance.CANO=Acceptance.ANO and CAcceptance.LANO=Acceptance.LANO
 AND cover.CNO = acceptance.CNO      
 And QPCalc.ANO=CAcceptance.ANO      
 And Acceptance.ANO<>Acceptance.LANO      
 And Acceptance.LANO=@P_ANO      
 And Cover.PHOLDER=Profile.ID      
 And ((Cover.Insured Like @Value1 Or Cover.Insured is null) or (Acceptance.AName Like @Value1 Or Acceptance.AName is null))      
 And (Cover.CoverNo Like @Value2 Or Cover.CoverNo is null)      
 and (Cover.CoverDate = @Value3 Or Cover.CoverDate is null or @Value7 = '')      
 And (Cover.ExpDate = @Value4 Or Cover.ExpDate is null or @Value7 = '')      
 And (Acceptance.PolicyNo Like @Value5 Or Acceptance.PolicyNo is null)      
 And (Acceptance.CertificateNo Like @Value6 Or Acceptance.CertificateNo is null)      
 And (Acceptance.PolicyDate = @Value7 Or Acceptance.PolicyDate is null or @Value7 = '' or Acceptance.PolicyDate Between @Value7 and @Value16)      
 And (Acceptance.RegDate = @Value17 Or Acceptance.RegDate is null or @Value17 = '' or Acceptance.RegDate Between @Value17 and @Value18)      
 And Acceptance.AType Like @Value8      
 And Acceptance.AStatus Like @Value9      
 And Acceptance.RegNo Like @Value10      
 And Profile.Name Like @Value11     
 and cover.toc like @Value12      
 and (acceptance.refno like @Value13 or acceptance.refno is null)      
 and (Acceptance.Matters=@Value14 or @Value14='')      
 And Cover.ISType<>'T'      
 And (@Value15='%' or @Value15='' or Exists (SELECT top 1 1 from Service Where Service.ANO=Acceptance.ANO and SStatus<>'R' and ServiceNo Like @Value15))      
 And (Acceptance.BatchNo Like @Value19 or (Acceptance.BatchNo is null and @Value19='%'))   
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')  
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')  
 
)      

GO

--Update script flclkol
Alter Function FL_CL_KOL(@P_CNO as Int, @P_INO AS Int, @P_Payment as varchar(10), @P_KOL AS VARCHAR(50))             
RETURNS TABLE        
AS RETURN (        
SELECT KOL.KOL, KOL.DESCRIPTION, KOL.CATEGORY, Max(coalesce(KOLVALUE.COST,0)) as Cost, KOL.VATF, KOL.TAXF, KOLVALUE.BRANCH  
FROM ICOVER          
INNER JOIN KOL ON (KOL.ALLOWEDF=1 and KOL.TOI=ICOVER.TOI AND (KOL.KOL LIKE @P_KOL or KOL.DESCRIPTION LIKE @P_KOL))          
INNER JOIN CLAIM ON (CLAIM.CNO=@P_CNO)      
LEFT JOIN CLINFO ON (CLINFO.CNO=CLAIM.CNO AND CLINFO.INO=ICOVER.INO)          
LEFT JOIN IINFO ON (IINFO.INO=ICOVER.INO)          
LEFT JOIN KOLVALUE ON (KOLVALUE.KOL=KOL.KOL AND KOLVALUE.TOI=KOL.TOI 
AND 
(
KOLVALUE.BRANCH='<All>' 
OR EXISTS 
      (
      SELECT CASE WHEN COALESCE(PAYMENT.BRANCH,'')='' THEN CLAIM.BRANCH ELSE PAYMENT.BRANCH END
      FROM PROFILE PAYMENT 
      WHERE PAYMENT.ID=@P_Payment and CASE WHEN COALESCE(PAYMENT.BRANCH,'')='' THEN CLAIM.BRANCH ELSE PAYMENT.BRANCH END=KOLVALUE.BRANCH
      )
)
)          
WHERE ICOVER.INO=@P_INO          
AND (isnull(KOLVALUE.KOL,'')='' OR --No Reference Value Set
(
--Reference Value Set with Specific Claim Info
(coalesce(KOLVALUE.ValueID1,'')='' Or coalesce(CLINFO.ValueID1,IINFO.ValueID1)=coalesce(KOLVALUE.ValueID1,''))               
And (coalesce(KOLVALUE.ValueID2,'')='' Or coalesce(CLINFO.ValueID2,IINFO.ValueID2)=coalesce(KOLVALUE.ValueID2,''))               
And (coalesce(KOLVALUE.ValueID3,'')='' Or coalesce(CLINFO.ValueID3,IINFO.ValueID3)=coalesce(KOLVALUE.ValueID3,''))               
And (coalesce(KOLVALUE.ValueID4,'')='' Or coalesce(CLINFO.ValueID4,IINFO.ValueID4)=coalesce(KOLVALUE.ValueID4,''))               
And (coalesce(KOLVALUE.ValueID5,'')='' Or coalesce(CLINFO.ValueID5,IINFO.ValueID5)=coalesce(KOLVALUE.ValueID5,''))               
And (coalesce(KOLVALUE.ValueID6,'')='' Or coalesce(CLINFO.ValueID6,IINFO.ValueID6)=coalesce(KOLVALUE.ValueID6,''))               
And (coalesce(KOLVALUE.ValueID7,'')='' Or coalesce(CLINFO.ValueID7,IINFO.ValueID7)=coalesce(KOLVALUE.ValueID7,''))               
And (coalesce(KOLVALUE.ValueID8,'')='' Or coalesce(CLINFO.ValueID8,IINFO.ValueID8)=coalesce(KOLVALUE.ValueID8,''))               
And (coalesce(KOLVALUE.ValueID9,'')='' Or coalesce(CLINFO.ValueID9,IINFO.ValueID9)=coalesce(KOLVALUE.ValueID9,''))               
And (coalesce(KOLVALUE.ValueID10,'')='' Or coalesce(CLINFO.ValueID10,IINFO.ValueID10)=coalesce(KOLVALUE.ValueID10,''))               
And (coalesce(KOLVALUE.ValueID11,'')='' Or coalesce(CLINFO.ValueID11,IINFO.ValueID11)=coalesce(KOLVALUE.ValueID11,''))               
And (coalesce(KOLVALUE.ValueID12,'')='' Or coalesce(CLINFO.ValueID12,IINFO.ValueID12)=coalesce(KOLVALUE.ValueID12,''))               
And (coalesce(KOLVALUE.ValueID13,'')='' Or coalesce(CLINFO.ValueID13,IINFO.ValueID13)=coalesce(KOLVALUE.ValueID13,''))               
And (coalesce(KOLVALUE.ValueID14,'')='' Or coalesce(CLINFO.ValueID14,IINFO.ValueID14)=coalesce(KOLVALUE.ValueID14,''))               
And (coalesce(KOLVALUE.ValueID15,'')='' Or coalesce(CLINFO.ValueID15,IINFO.ValueID15)=coalesce(KOLVALUE.ValueID15,''))               
))
Group By KOL.KOL, KOL.DESCRIPTION, KOL.CATEGORY, KOL.VATF, KOL.TAXF, KOLVALUE.BRANCH  
)        
go 


--perbaikan claim entry list
alter PROCEDURE CLLIST17 (@P_USERID as varchar(255),@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_CStatus as varchar(1))     
AS    
SELECT Cast(0 as bit) as ProcessFlag,    
 [CLAIM].[CLAIMNO],    
 [CLAIM].[REGDATE],    
 [CLAIM].[REFNO],    
 [CLAIM].[COL],    
 [COLTAB].[DESCRIPTION],    
 [CLAIM].[LOSSDATE],    
 [CLAIM].[TOC],    
 [CLAIM].[CSDATE],    
 [CLAIM].[PUSERDATE],    
 [CLAIM].[LOSSPLACE],    
 [CLAIM].[CTYPE],    
 [CLAIM].[CSTATUS],    
 [CLAIM].[CNO],    
 [CLAIM].[ANO],    
 [CLAIM].[PCNO],    
 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,    
 [SYSTAB].[CURRENCY],    
 [CCALC].[LOSS] AS ESTIMATE,    
 [CCALC].[CLAIM] AS CLAIM,    
 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,    
 [CCALC].[SALVAGE] AS SALVAGE,    
 [CCALC].[COST] AS COST,    
 [CCALC].[SUBROGATION] AS SUBROGATION,    
 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,    
 [CLAIM].[VSEQNO],    
 [CLAIM].[CSEQNO],    
 acceptance.aname,    
 acceptance.policyno,    
 acceptance.certificateno,    
 CLAIM.SETTLEDF    
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance    
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]    
 And [CCALC].[CNO]=[CLAIM].[CNO]    
 And CLAIM.COL=COLTAB.COL    
 And Acceptance.ANO=Claim.ANO  
 And Claim.LUserID Like @P_UserID      
 And Claim.LDate Between @P_SDate and @P_EDate
 And (Claim.CStatus=@P_CStatus or @P_CStatus='')
 go


--Penambahan parameter ALL Untuk Annual Treaty
DROP PROCEDURE dbo.List11F  
  
GO  
  
CREATE PROCEDURE dbo.List11F(@P_UserID as varchar(10), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_PDate as smalldatetime, @P_ManualF as bit)    
AS    
SELECT Cast(0 as bit) as ProcessFlag,     
 Cover.COVERNO,    
 Cast(Acceptance.AName as varchar(128)) as Insured,    
 Cover.CNO,    
 Cover.CStatus,    
 Acceptance.lANO,    
 Acceptance.ANO,    
 Acceptance.REGNO,    
 Acceptance.ADATE,    
 Acceptance.LUSERID as USERID,    
 SysTab.Currency,    
 QPCalc.TSI,    
 QPCalc.OurShare,    
 QPCalc.Gross,    
 Acceptance.ASTATUS,    
 Acceptance.ATYPE,    
 Acceptance.SDate,    
 Acceptance.EDate,    
 Year(Acceptance.SDate) AS RYear,    
 Cover.ISType,    
 Acceptance.Renewal,    
 Acceptance.ESeqNo,    
 Acceptance.PolicyNo,    
 acceptance.CertificateNo    
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader, SysUserTOC, SysUserBranch    
Where cover.CNO = acceptance.CNO    
 And QPCalc.ANO=Acceptance.ANO    
 And RArrHeader.ANO=Acceptance.ANO    
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)    
 And Cover.CStatus<>'C'    
 And Acceptance.AStatus='I' and Acceptance.AType not in ('A','C')    
 And RArrHeader.NRDate<Acceptance.EDate And RArrHeader.NRDate<=@P_PDate    
 And (@P_ManualF=0 or RArrHeader.ManualF=@P_ManualF)  
 And Cover.ISType<>'T'    
 And SysUserTOC.ID=@P_UserID and Cover.TOC=SysUserTOC.TOC and (SysUserTOC.TOC Like @P_TOC+'%' or @P_TOC='')  
 And SysUserBranch.ID=@P_UserID and Acceptance.BRanch=SysUserBranch.Branch and (SysUserBranch.Branch=@P_Branch or @P_Branch='')  

    
Union    
          
SELECT Cast(0 as bit) as ProcessFlag,     
 Cover.COVERNO,    
 Cast(Acceptance.AName as varchar(128)) as Insured,    
 Cover.CNO,    
 Cover.CStatus,    
 Acceptance.lANO,    
 Acceptance.ANO,    
 Acceptance.REGNO,    
 Acceptance.ADATE,    
 Acceptance.LUSERID as USERID,    
 SysTab.Currency,    
 QPCalc.TSI,    
 QPCalc.OurShare,    
 QPCalc.Gross,    
 Acceptance.ASTATUS,    
 Acceptance.ATYPE,    
 Acceptance.SDate,    
 Acceptance.EDate,    
 Year(Acceptance.SDate) AS RYear,    
 Cover.ISType,    
 Acceptance.Renewal,    
 Acceptance.ESeqNo,    
 Acceptance.PolicyNo,    
 acceptance.CertificateNo    
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader, Acceptance As Acceptance_Detail, SysUserTOC, SysUserBranch
Where cover.CNO = acceptance.CNO    
 And QPCalc.ANO=Acceptance.ANO    
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO    
 And RArrHeader.ANO=Acceptance_Detail.ANO    
 And Cover.CStatus<>'C'    
 And Acceptance_Detail.AStatus='I' and Acceptance_Detail.AType not in ('A','C')    
 And RArrHeader.NRDate<Acceptance_Detail.EDate And RArrHeader.NRDate<=@P_PDate    
 And (@P_ManualF=0 or RArrHeader.ManualF=@P_ManualF)  
 And Cover.ISType<>'T'    
 And SysUserTOC.ID=@P_UserID and Cover.TOC=SysUserTOC.TOC and (SysUserTOC.TOC Like @P_TOC+'%' or @P_TOC='')  
 And SysUserBranch.ID=@P_UserID and Acceptance_Detail.BRanch=SysUserBranch.Branch and (SysUserBranch.Branch=@P_Branch or @P_Branch='')  
        
  
GO

    
DROP FUNCTION List11F_Det     
GO
CREATE FUNCTION List11F_Det (@P_ANO as integer,@P_UserID as varchar(10), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_PDate as smalldatetime, @P_ManualF as bit)    
RETURNS Table    
AS RETURN(    
        
SELECT Cast(0 as bit) as ProcessFlag,    
 Acceptance.CertificateNo,    
 Acceptance.ESeqNo,    
 Acceptance.AName,    
 Acceptance.ANO,    
 Acceptance.REGNO,    
 Acceptance.ADATE,    
 Acceptance.LUSERID as UserID,    
 SysTab.Currency,    
 QPCalc.TSI,    
 QPCalc.OurShare,    
 QPCalc.Gross,    
 Acceptance.ASTATUS,    
 Acceptance.ATYPE,    
 Acceptance.SDate,    
 Acceptance.EDate,    
 Year(Acceptance.SDate) AS RYear,    
 Acceptance.ValueID,    
 Acceptance.ValueDesc    
From    
 Acceptance,    
 Cover,    
 SysTab,    
 QMasterAcceptance_PCalc() AS QPCalc,    
 RARRHEADER, 
 SysUserTOC, 
 SysUserBranch
Where    
 cover.CNO = acceptance.CNO    
 And Rarrheader.ANO = Acceptance.ANO    
 And QPCalc.ANO=Acceptance.ANO    
 And Acceptance.ANO<>Acceptance.LANO    
 And Acceptance.LANO=@P_ANO    
 And Cover.CStatus<>'C'    
 And Acceptance.AStatus='I' and Acceptance.AType not in ('A','C')    
 And RArrHeader.NRDate<Acceptance.EDate And RArrHeader.NRDate<=@P_PDate    
 And (@P_ManualF=0 or RArrHeader.ManualF=@P_ManualF)  
 And Cover.ISType<>'T'    
 And SysUserTOC.ID=@P_UserID and Cover.TOC=SysUserTOC.TOC and (SysUserTOC.TOC Like @P_TOC+'%' or @P_TOC='')  
 And SysUserBranch.ID=@P_UserID and Acceptance.BRanch=SysUserBranch.Branch and (SysUserBranch.Branch=@P_Branch or @P_Branch='')  
 
)    
        
GO



--update script reference value
ALTER PROCEDURE QREFERENCE_VALUE(@P_CNO as Int, @P_INO AS Int, @P_Payment as varchar(10), @P_KOL AS VARCHAR(50))             
AS            
SELECT KOL.KOL, KOL.DESCRIPTION, KOL.CATEGORY, Max(coalesce(KOLVALUE.COST,0)) as Cost, KOL.VATF, KOL.TAXF      
FROM ICOVER      
INNER JOIN KOL ON (KOL.ALLOWEDF=1 and KOL.TOI=ICOVER.TOI AND (KOL.KOL LIKE @P_KOL or KOL.DESCRIPTION LIKE @P_KOL))      
INNER JOIN CLAIM ON (CLAIM.CNO=@P_CNO)    
LEFT JOIN CLINFO ON (CLINFO.CNO=CLAIM.CNO AND CLINFO.INO=ICOVER.INO)      
LEFT JOIN IINFO ON (IINFO.INO=ICOVER.INO)      
LEFT JOIN KOLVALUE ON (KOLVALUE.KOL=KOL.KOL AND KOLVALUE.TOI=KOL.TOI 
AND 
(
KOLVALUE.BRANCH='<All>' 
OR EXISTS 
      (
      SELECT CASE WHEN COALESCE(PAYMENT.BRANCH,'')='' THEN CLAIM.BRANCH ELSE PAYMENT.BRANCH END
      FROM PROFILE PAYMENT 
      WHERE PAYMENT.ID=@P_Payment AND CASE WHEN COALESCE(PAYMENT.BRANCH,'')='' THEN CLAIM.BRANCH ELSE PAYMENT.BRANCH END=KOLVALUE.BRANCH
      )
)          
)      
WHERE ICOVER.INO=@P_INO
AND (isnull(KOLVALUE.KOL,'')='' OR --No Reference Value Set
(
--Reference Value Set with Specific Claim Info
(coalesce(KOLVALUE.ValueID1,'')='' Or coalesce(CLINFO.ValueID1,IINFO.ValueID1)=coalesce(KOLVALUE.ValueID1,''))               
And (coalesce(KOLVALUE.ValueID2,'')='' Or coalesce(CLINFO.ValueID2,IINFO.ValueID2)=coalesce(KOLVALUE.ValueID2,''))               
And (coalesce(KOLVALUE.ValueID3,'')='' Or coalesce(CLINFO.ValueID3,IINFO.ValueID3)=coalesce(KOLVALUE.ValueID3,''))               
And (coalesce(KOLVALUE.ValueID4,'')='' Or coalesce(CLINFO.ValueID4,IINFO.ValueID4)=coalesce(KOLVALUE.ValueID4,''))               
And (coalesce(KOLVALUE.ValueID5,'')='' Or coalesce(CLINFO.ValueID5,IINFO.ValueID5)=coalesce(KOLVALUE.ValueID5,''))               
And (coalesce(KOLVALUE.ValueID6,'')='' Or coalesce(CLINFO.ValueID6,IINFO.ValueID6)=coalesce(KOLVALUE.ValueID6,''))               
And (coalesce(KOLVALUE.ValueID7,'')='' Or coalesce(CLINFO.ValueID7,IINFO.ValueID7)=coalesce(KOLVALUE.ValueID7,''))               
And (coalesce(KOLVALUE.ValueID8,'')='' Or coalesce(CLINFO.ValueID8,IINFO.ValueID8)=coalesce(KOLVALUE.ValueID8,''))               
And (coalesce(KOLVALUE.ValueID9,'')='' Or coalesce(CLINFO.ValueID9,IINFO.ValueID9)=coalesce(KOLVALUE.ValueID9,''))               
and (coalesce(KOLVALUE.ValueID10,'')='' Or coalesce(CLINFO.ValueID10,IINFO.ValueID10)=coalesce(KOLVALUE.ValueID10,''))               
And (coalesce(KOLVALUE.ValueID11,'')='' Or coalesce(CLINFO.ValueID11,IINFO.ValueID11)=coalesce(KOLVALUE.ValueID11,''))               
And (coalesce(KOLVALUE.ValueID12,'')='' Or coalesce(CLINFO.ValueID12,IINFO.ValueID12)=coalesce(KOLVALUE.ValueID12,''))               
And (coalesce(KOLVALUE.ValueID13,'')='' Or coalesce(CLINFO.ValueID13,IINFO.ValueID13)=coalesce(KOLVALUE.ValueID13,''))               
And (coalesce(KOLVALUE.ValueID14,'')='' Or coalesce(CLINFO.ValueID14,IINFO.ValueID14)=coalesce(KOLVALUE.ValueID14,''))               
And (coalesce(KOLVALUE.ValueID15,'')='' Or coalesce(CLINFO.ValueID15,IINFO.ValueID15)=coalesce(KOLVALUE.ValueID15,''))               
)) 
Group By KOL.KOL, KOL.DESCRIPTION, KOL.CATEGORY, KOL.VATF, KOL.TAXF   
GO



ALTER PROCEDURE SList02 (@P_UserID as Varchar(20))    
AS    
SELECT Cast(0 as bit) as ProcessFlag,Service.*    
From Service    
WHERE Service.SStatus='P' and Service.LUserID Like @P_UserID    
GO


--Update untuk perbaikan bugs sql
alter FUNCTION FN_UserComAcc (@P_UserID as varchar(10), @P_Branch as varchar(10))        
RETURNS TABLE        
as RETURN(        
SELECT ComAcc.*   
 from ComAcc   
 Left Join Branch on (Branch.Branch=@P_Branch)  
 Inner join SysUser on (SysUser.ID=@P_UserID)  
 Where (SysUser.Type='SUPERVISOR' or ComAcc.ComAcc in (Select SysUserComAcc.ComAcc from SysUserComAcc Where SysUserComAcc.ID=@P_UserID and SysUserComAcc.ComAcc=ComAcc.ComAcc)) and      
(@P_Branch='' or    
(Coalesce(Branch.Op_Flag,0)=0) or  
(ComAcc.Branch=@P_Branch) or      
(ComAcc.ComAcc in (Select ComAcc from ComAcc_Branch Where Branch=@P_Branch)) or       
(ComAcc.Branch='' and ComAcc.ComAcc Not in (Select ComAcc from ComAcc_Branch)))      
)      
go


 
--30 April 2015 : Tuning Script
DROP FUNCTION R_SL_ALLOCATED
GO
CREATE FUNCTION R_SL_ALLOCATED(@P_PDate as smalldatetime)                                     
RETURNS TABLE  AS                                       
RETURN (                                     
                             
--SL from Payment Voucher                                   
Select pSL.Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pSL.Voucher as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Rate*pSL.Nominal_OC) as Nominal_OC                                
From dbo.pSL                  
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)                  
Where pVoucher.SL_Cat in ('P') and pSL.PaymentF=1 and pVoucher.Date<=@P_PDate            
Group By pSL.Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Currency, pSL.Account                       


Union All

--SL from InterOffice Overbooking Voucher                                   
Select pVoucher.RefNo as Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pVoucher.RefNo as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Rate*pSL.Nominal_OC) as Nominal_OC                                
From dbo.pSL                  
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)          
Inner Join dbo.pVoucher OVoucher on (OVoucher.Voucher=pVoucher.RefNo)        
Where pVoucher.SL_Cat in ('B') and pVoucher.RefType='INTEROFFICE' and pSL.PaymentF=1 and pVoucher.Date<=@P_PDate            
Group By pVoucher.RefNo, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Currency, pSL.Account                       
                                   
union all                                   
                                   
--SL from Overbooking Payment and Adjustment Payment                                   
Select SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.Voucher as Doc_No, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end as Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                        
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal_OC else -SL.Nominal_OC end*SL.Rate)) as Nominal_OC                                   
from pSL SL, pVoucher VoucherP, pVoucher VoucherR, VPattern                         
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('B','A') and VoucherP.SL_Cat='P' and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher and SL.PaymentF=1 and VoucherR.Date<=@P_PDate                   
and VPattern.VType=VoucherR.VType and ((VPattern.Debit=SL.hint and VoucherR.DebtorF=1) or (VPattern.Credit=SL.hint and VoucherR.CreditorF=1))                         
Group By SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Currency, VoucherP.Voucher, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end, SL.Account                                
                             
union all                                   
                                   
--SL from Adjustment Overbooking                                   
Select SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.RefNo as Doc_No, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end as Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                        
sum((case When VoucherR.DebtorF=pVoucher.DebtorF Then SL.Nominal_OC else -SL.Nominal_OC end*SL.Rate)) as Nominal_OC                                   
from pSL SL, pVoucher VoucherP, pVoucher VoucherR, pVoucher, VPattern                         
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('A') and VoucherP.SL_Cat in ('B') and VoucherR.RefNo=VoucherP.Voucher and pVoucher.SL_Cat in ('P') and VoucherP.RefNo=pVoucher.Voucher and SL.Voucher=VoucherR.Voucher and SL.PaymentF=1 and VoucherR.Date<=@P_PDate            
and VPattern.VType=VoucherR.VType and ((VPattern.Debit=SL.hint and VoucherR.DebtorF=1) or (VPattern.Credit=SL.hint and VoucherR.CreditorF=1))                         
Group By SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Currency, VoucherP.RefNo, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end, SL.Account                       
                                   
union all                                   
                                   
--SL from Sub Ledger Payment Voucher and OverPaid                                   
Select SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, SL.Doc_Date, SL.Doc_CCY, SL.Doc_No as Doc_No, SL.Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                        
(Case When VoucherR.SL_Cat='O'                                    
then (case when VoucherR.DebtorF=VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                    
else (case when VoucherR.DebtorF<>VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                   
end) as Nominal_OC                                   
from pSL SL, pVoucher VoucherP, pVoucher VoucherR                                   
Where VoucherR.SL_Cat in ('O','P','A','B') and VoucherP.SL_Cat in ('P') and VoucherR.Voucher=SL.Voucher and SL.Doc_No=VoucherP.Voucher and SL.PaymentF=1 and VoucherR.Date<=@P_PDate                                  
                                     
)   

GO


--Penambahan Pi01 & PI08 untuk virtual account  
DROP PROCEDURE PI01   
GO  
CREATE PROCEDURE PI01 (@P_ANO AS INTEGER)          
AS      
(          
SELECT TOP 1      
 A.POLICYNO, A.CERTIFICATENO, C.PHOLDER, P.PREFERREDF, P.RESTRICTEDF, P.NAME, A.ANAME, A.AID,       
 (LTRIM(RTRIM(P.ADDRESS_1)) + ' ' + LTRIM(RTRIM(P.ADDRESS_2)) + ' ' + LTRIM(RTRIM(P.ADDRESS_3))) AS 'ADDRESS',      
 (LTRIM(RTRIM(P.PHONE_1)) + ' ' + LTRIM(RTRIM(P.PHONE_2))) AS 'PHONE',      
 (LTRIM(RTRIM(P.FAX_1)) + ' ' + LTRIM(RTRIM(P.FAX_2))) AS 'FAX',      
 P.EMAIL, A.SDATE, A.EDATE, A.PDATE, A.PPDATE,
 RA.POLICYNO as PPOLICYNO, RA.CERTIFICATENO as PCERTIFICATENO
FROM COVER C 
INNER JOIN ACCEPTANCE A ON (A.CNO=C.CNO)      
LEFT JOIN ACCEPTANCE RA ON (RA.ANO=A.RANO)
INNER JOIN PROFILE P ON (C.PHOLDER=P.ID)      
WHERE A.ANO=@P_ANO      
)         
  
GO

--Penambahan Informasi Prev Polis & sertifikat No 
DROP procedure PI08 
GO
CREATE procedure PI08 (@P_ANO as integer)            
as            
Begin          
Declare @P_Date as smalldatetime      
 Declare @P_PolicyNo as varchar(20)      
 Declare @P_CertificateNo as varchar(20)      
 Declare @P_OpenFLag as Bit      
 Declare @P_LANO as int        
 Declare @P_A_PolicyNo as varchar(50)      
 Select @P_Date = Getdate()            
       
 Select @P_LANO=A1.LANO, @P_PolicyNo=A1.PolicyNo, @P_CertificateNo=A1.CertificateNo, @P_OpenFlag=C1.OpenFlag from Acceptance A1, Cover C1 Where C1.CNO=A1.CNO and A1.ANO=@P_ANO      
      
 if @P_LANO<>-1       
 if @P_OpenFlag=1 and @P_ANO<>@P_LANO       
  Select @P_A_PolicyNo=@P_PolicyNo + '-' + @P_CertificateNo      
 else      
  Select @P_A_PolicyNo=@P_PolicyNo      
 else      
  Select @P_A_PolicyNo=@P_PolicyNo        
     
 Select Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Voucher_Due.DueDate as NDueDate, Profile.Name, Voucher.Currency,    
 Admlink.RefType,  Admlink.AccountNo, Admlink.Bank, Admlink.BankName,
 case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC) end  as Nominal,     
 case when Voucher.debtorf=1 then (coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) else -(coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) end as AmountDue,      
 case when Voucher.debtorf=1 then Voucher.Payment_CC else -Voucher.Payment_CC end as Payment,     
 case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC) end as Outstanding,    
 Voucher.Installment,        
 Voucher.DueDate_1, case when Voucher.debtorf=1 then Voucher.AmountDue_1 else -Voucher.AmountDue_1 end AmountDue_1,        
 Voucher.DueDate_2, case when Voucher.debtorf=1 then Voucher.AmountDue_2 else -Voucher.AmountDue_2 end AmountDue_2,        
 Voucher.DueDate_3, case when Voucher.debtorf=1 then Voucher.AmountDue_3 else -Voucher.AmountDue_3 end AmountDue_3,        
 Voucher.DueDate_4, case when Voucher.debtorf=1 then Voucher.AmountDue_4 else -Voucher.AmountDue_4 end AmountDue_4,        
 Voucher.DueDate_5, case when Voucher.debtorf=1 then Voucher.AmountDue_5 else -Voucher.AmountDue_5 end AmountDue_5,        
 Voucher.DueDate_6, case when Voucher.debtorf=1 then Voucher.AmountDue_6 else -Voucher.AmountDue_6 end AmountDue_6,        
 Voucher.DueDate_7, case when Voucher.debtorf=1 then Voucher.AmountDue_7 else -Voucher.AmountDue_7 end AmountDue_7,        
 Voucher.DueDate_8, case when Voucher.debtorf=1 then Voucher.AmountDue_8 else -Voucher.AmountDue_8 end AmountDue_8,        
 Voucher.DueDate_9, case when Voucher.debtorf=1 then Voucher.AmountDue_9 else -Voucher.AmountDue_9 end AmountDue_9,        
 Voucher.DueDate_10, case when Voucher.debtorf=1 then Voucher.AmountDue_10 else -Voucher.AmountDue_10 end AmountDue_10,        
 Voucher.DueDate_11, case when Voucher.debtorf=1 then Voucher.AmountDue_11 else -Voucher.AmountDue_11 end AmountDue_11,        
 Voucher.DueDate_12, case when Voucher.debtorf=1 then Voucher.AmountDue_12 else -Voucher.AmountDue_12 end AmountDue_12,  
 Voucher.DueDate_13, case when Voucher.debtorf=1 then Voucher.AmountDue_13 else -Voucher.AmountDue_13 end AmountDue_13,        
 Voucher.DueDate_14, case when Voucher.debtorf=1 then Voucher.AmountDue_14 else -Voucher.AmountDue_14 end AmountDue_14,        
 Voucher.DueDate_15, case when Voucher.debtorf=1 then Voucher.AmountDue_15 else -Voucher.AmountDue_15 end AmountDue_15,        
 Voucher.DueDate_16, case when Voucher.debtorf=1 then Voucher.AmountDue_16 else -Voucher.AmountDue_16 end AmountDue_16,        
 Voucher.DueDate_17, case when Voucher.debtorf=1 then Voucher.AmountDue_17 else -Voucher.AmountDue_17 end AmountDue_17,        
 Voucher.DueDate_18, case when Voucher.debtorf=1 then Voucher.AmountDue_18 else -Voucher.AmountDue_18 end AmountDue_18,        
 Voucher.DueDate_19, case when Voucher.debtorf=1 then Voucher.AmountDue_19 else -Voucher.AmountDue_19 end AmountDue_19,        
 Voucher.DueDate_20, case when Voucher.debtorf=1 then Voucher.AmountDue_20 else -Voucher.AmountDue_20 end AmountDue_20,        
 Voucher.DueDate_21, case when Voucher.debtorf=1 then Voucher.AmountDue_21 else -Voucher.AmountDue_21 end AmountDue_21,        
 Voucher.DueDate_22, case when Voucher.debtorf=1 then Voucher.AmountDue_22 else -Voucher.AmountDue_22 end AmountDue_22,        
 Voucher.DueDate_23, case when Voucher.debtorf=1 then Voucher.AmountDue_23 else -Voucher.AmountDue_23 end AmountDue_23,        
 Voucher.DueDate_24, case when Voucher.debtorf=1 then Voucher.AmountDue_24 else -Voucher.AmountDue_24 end AmountDue_24  
 from nVoucher Voucher Inner Join Voucher_AmountDue(@P_Date) Voucher_Due on (Voucher_Due.Voucher=Voucher.Voucher), Profile, ProAcc, Admlink    
 Where Profile.ID=ProAcc.ID and ProAcc.ProAcc=Voucher.ProAcc and Admlink.Voucher=Voucher.Voucher                  
 and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') and Admlink.A_PolicyNo=@P_A_PolicyNo and (Admlink.Extra_1='' or Admlink.Extra_1 is null)    
End          
    
GO


-- Perbaikan Claim Info
DROP PROCEDURE CLLIST00
GO
CREATE PROCEDURE CLLIST00(@P_CNO as integer) AS  
SELECT  Cast(0 as bit) as ProcessFlag,
[CLAIM].[CLAIMNO],  
 [CLAIM].[REGDATE],  
 [CLAIM].[REFNO],  
 [CLAIM].[COL],  
 [COLTAB].[DESCRIPTION],  
 [CLAIM].[LOSSDATE],  
 [CLAIM].[TOC],  
 [CLAIM].[CSDATE],  
 [CLAIM].[PUserDATE],  
 [CLAIM].[LOSSPLACE],  
 [CLAIM].[CTYPE],  
 [CLAIM].[CSTATUS],  
 [CLAIM].[CNO],  
 [CLAIM].[ANO],  
 [CLAIM].[PCNO],  
 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] AS USERID,  
 [SYSTAB].[CURRENCY],  
 [CCALC].[LOSS] AS ESTIMATE,  
 [CCALC].[CLAIM] AS CLAIM,  
 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,  
 [CCALC].[SALVAGE] AS SALVAGE,  
 [CCALC].[COST] AS COST,  
 [CCALC].[SUBROGATION] AS SUBROGATION,  
 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,  
 [CLAIM].[VSEQNO],  
 [CLAIM].[CSEQNO],  
 ACCEPTANCE.ANAME,  
 CLAIM.POLICYNO,  
 CLAIM.CERTIFICATENO,  
 CLAIM.SETTLEDF  
FROM  CLAIM LEFT JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO), QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB  
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]  
 And [CCALC].[CNO]=[CLAIM].[CNO]  
 And CLAIM.COL=COLTAB.COL  
 And [CLAIM].[CNO]=@P_CNO
go



--13 March 2015

DROP function FL_UserBranch_RQ
GO  
Create function FL_UserBranch_RQ(@P_USERID varchar(10), @P_Branch varchar(10))        
RETURNS Table          
AS RETURN          
(        
SELECT Branch.Branch, Branch.Name, Branch.Active_Flag, Branch.ShariaF  
from Branch, SysUser      
Where SysUser.ID=@P_UserID and Branch.Branch Like @P_Branch+'%' and Branch.Op_Flag=1      
and (SysUser.Type='SUPERVISOR' or Branch.Branch in (Select S.Branch from SysUserBranch S Where S.RequestF=1 and S.ID=@P_UserID))  
)    
  
  
GO



--19 March 2015

  
DROP procedure SchemeList
GO    
CREATE procedure SchemeList(@p_SchemeNo varchar(10),@P_PolicyNo varchar(20), @P_Branch varchar(20), @p_SDate smalldatetime,@p_EDate smalldatetime, @P_Status as varchar(10),@P_UserID as varchar(10), @P_BatchNoF as varchar(10)='', @P_BatchNoL as varchar(10)='', @P_CertificateNoF as varchar(10)='', @P_CertificateNoL as varchar(10)='')              
as              
                  
select  s.*, PCalc.Gross, c.insured, sm.description              
From              
 scheme_transaction as s    
 Left join PCalc on (PCalc.ANO=S.ANO)     
 Inner join Acceptance as a on (A.ANO=S.LANO and A.ANO=A.LANO and A.AStatus<>'W')         
 Inner join Cover as C on (C.CNO=A.CNO)    
 Inner join scheme_master As sm on (sm.SchemeNo=S.SchemeNo)    
Where              
 sm.schemeno Like @p_SchemeNo+'%'       
 and a.PolicyNo Like @P_PolicyNo+'%' and a.Branch like @P_Branch+'%'       
 and s.trdate >=@p_SDate and s.trDate<=@p_EDate       
 and (s.Status=@P_Status or @P_Status='') and (s.LUserID=@P_UserID or @P_UserID='')       
 and (@P_BatchNoF='' or s.BatchNo>=@P_BatchNoF)  
 and (@P_BatchNoL='' or s.BatchNo<=@P_BatchNoL)  
 and (@P_CertificateNoF='' or s.BatchNo>=@P_CertificateNoF)  
 and (@P_CertificateNoL='' or s.BatchNo<=@P_CertificateNoL)   
order by s.TrNo                

GO


DROP function ListDet05_a
GO  
Create function ListDet05_a (@P_ANO as integer,   
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),   
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),  
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),  
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255)  
)        
RETURNS Table      
AS RETURN      
(      
 SELECT Cast(0 as bit) as ProcessFlag,      
 Acceptance.CertificateNo,      
 Acceptance.ESeqNo,      
 Acceptance.AName,      
 Acceptance.ANO,      
 Acceptance.REGNO,      
 Acceptance.ADATE,      
 Acceptance.LUSERID as UserID,      
 SysTab.Currency,      
 QPCalc.TSI,      
 QPCalc.OurShare,      
 QPCalc.Gross,      
 Acceptance.ASTATUS,      
 Acceptance.ATYPE,      
 Acceptance.SDate,      
 Acceptance.EDate,      
 Year(Acceptance.SDate) AS RYear,      
 Acceptance.ValueID,      
 Acceptance.ValueDesc      
From      
 Acceptance,      
 Cover,      
 SysTab,      
 QMasterAcceptance_PCalc() AS QPCalc,      
 Profile      
Where      
 cover.CNO = acceptance.CNO      
 And QPCalc.ANO=Acceptance.ANO      
 And Acceptance.ANO<>Acceptance.LANO      
 And Acceptance.LANO=@P_ANO      
 And Cover.PHOLDER=Profile.ID      
 And ((Cover.Insured Like @Value1 Or Cover.Insured is null) or (Acceptance.AName Like @Value1 Or Acceptance.AName is null))      
 And (Cover.CoverNo Like @Value2 Or Cover.CoverNo is null)      
 and (Cover.CoverDate = @Value3 Or Cover.CoverDate is null or @Value7 = '')      
 And (Cover.ExpDate = @Value4 Or Cover.ExpDate is null or @Value7 = '')      
 And (Acceptance.PolicyNo Like @Value5 Or Acceptance.PolicyNo is null)      
 And (Acceptance.CertificateNo Like @Value6 Or Acceptance.CertificateNo is null)      
 And (Acceptance.PolicyDate = @Value7 Or Acceptance.PolicyDate is null or @Value7 = '' or Acceptance.PolicyDate Between @Value7 and @Value16)      
 And (Acceptance.RegDate = @Value17 Or Acceptance.RegDate is null or @Value17 = '' or Acceptance.RegDate Between @Value17 and @Value18)      
 And Acceptance.AType Like @Value8      
 And Acceptance.AStatus Like @Value9      
 And Acceptance.RegNo Like @Value10      
 And Profile.Name Like @Value11     
 and cover.toc like @Value12      
 and (acceptance.refno like @Value13 or acceptance.refno is null)      
 and (Acceptance.Matters=@Value14 or @Value14='')      
 And Cover.ISType<>'T'      
 And (@Value15='%' or @Value15='' or Exists (SELECT top 1 1 from Service Where Service.ANO=Acceptance.ANO and SStatus<>'R' and ServiceNo Like @Value15))      
 And (Acceptance.BatchNo Like @Value19 or (Acceptance.BatchNo is null and @Value19='%'))   
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')  
 And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance.CANO from Acceptance CAcceptance Where CAcceptance.CANO=Acceptance.ANO and CAcceptance.LANO=Acceptance.LANO)))          
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')  
 
 Union 
 
 SELECT Cast(0 as bit) as ProcessFlag,      
 CAcceptance.CertificateNo,      
 CAcceptance.ESeqNo,      
 CAcceptance.AName,      
 CAcceptance.ANO,      
 CAcceptance.REGNO,      
 CAcceptance.ADATE,      
 CAcceptance.LUSERID as UserID,      
 SysTab.Currency,      
 QPCalc.TSI,      
 QPCalc.OurShare,      
 QPCalc.Gross,      
 CAcceptance.ASTATUS,      
 CAcceptance.ATYPE,      
 CAcceptance.SDate,      
 CAcceptance.EDate,      
 Year(CAcceptance.SDate) AS RYear,      
 CAcceptance.ValueID,      
 CAcceptance.ValueDesc      
From      
 Acceptance,      
 Cover,      
 SysTab,      
 QMasterAcceptance_PCalc() AS QPCalc,      
 Profile, 
 Acceptance CAcceptance   
WHERE @Value21='1' and CAcceptance.CANO=Acceptance.ANO and CAcceptance.LANO=Acceptance.LANO
 AND cover.CNO = acceptance.CNO      
 And QPCalc.ANO=CAcceptance.ANO      
 And Acceptance.ANO<>Acceptance.LANO      
 And Acceptance.LANO=@P_ANO      
 And Cover.PHOLDER=Profile.ID      
 And ((Cover.Insured Like @Value1 Or Cover.Insured is null) or (Acceptance.AName Like @Value1 Or Acceptance.AName is null))      
 And (Cover.CoverNo Like @Value2 Or Cover.CoverNo is null)      
 and (Cover.CoverDate = @Value3 Or Cover.CoverDate is null or @Value7 = '')      
 And (Cover.ExpDate = @Value4 Or Cover.ExpDate is null or @Value7 = '')      
 And (Acceptance.PolicyNo Like @Value5 Or Acceptance.PolicyNo is null)      
 And (Acceptance.CertificateNo Like @Value6 Or Acceptance.CertificateNo is null)      
 And (Acceptance.PolicyDate = @Value7 Or Acceptance.PolicyDate is null or @Value7 = '' or Acceptance.PolicyDate Between @Value7 and @Value16)      
 And (Acceptance.RegDate = @Value17 Or Acceptance.RegDate is null or @Value17 = '' or Acceptance.RegDate Between @Value17 and @Value18)      
 And Acceptance.AType Like @Value8      
 And Acceptance.AStatus Like @Value9      
 And Acceptance.RegNo Like @Value10      
 And Profile.Name Like @Value11     
 and cover.toc like @Value12      
 and (acceptance.refno like @Value13 or acceptance.refno is null)      
 and (Acceptance.Matters=@Value14 or @Value14='')      
 And Cover.ISType<>'T'      
 And (@Value15='%' or @Value15='' or Exists (SELECT top 1 1 from Service Where Service.ANO=Acceptance.ANO and SStatus<>'R' and ServiceNo Like @Value15))      
 And (Acceptance.BatchNo Like @Value19 or (Acceptance.BatchNo is null and @Value19='%'))   
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')  
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')  
 
)      

GO


-- 2015 v.2 : Perbaikan fee duty
DROP PROCEDURE CLVIEW09L
GO
CREATE PROCEDURE CLVIEW09L(@P_CNO as Integer)  
AS  
SELECT CLFD.*, PROFILE.NAME  
FROM CLFD Left Join PROFILE ON  (PROFILE.ID=CLFD.PAYMENT)
WHERE CNO=@P_CNO
  
GO


--Perbaikan Annual Treaty
DROP PROCEDURE dbo.List11F  
  
GO  
  
CREATE PROCEDURE dbo.List11F(@P_UserID as varchar(10), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_PDate as smalldatetime, @P_ManualF as bit)    
AS    
SELECT Cast(0 as bit) as ProcessFlag,     
 Cover.COVERNO,    
 Cast(Acceptance.AName as varchar(128)) as Insured,    
 Cover.CNO,    
 Cover.CStatus,    
 Acceptance.lANO,    
 Acceptance.ANO,    
 Acceptance.REGNO,    
 Acceptance.ADATE,    
 Acceptance.LUSERID as USERID,    
 SysTab.Currency,    
 QPCalc.TSI,    
 QPCalc.OurShare,    
 QPCalc.Gross,    
 Acceptance.ASTATUS,    
 Acceptance.ATYPE,    
 Acceptance.SDate,    
 Acceptance.EDate,    
 Year(Acceptance.SDate) AS RYear,    
 Cover.ISType,    
 Acceptance.Renewal,    
 Acceptance.ESeqNo,    
 Acceptance.PolicyNo,    
 acceptance.CertificateNo    
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader, SysUserTOC, SysUserBranch    
Where cover.CNO = acceptance.CNO    
 And QPCalc.ANO=Acceptance.ANO    
 And RArrHeader.ANO=Acceptance.ANO    
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)    
 And Cover.CStatus<>'C'    
 And Acceptance.AStatus='I' and Acceptance.AType not in ('A','C')    
 And RArrHeader.NRDate<Acceptance.EDate And RArrHeader.NRDate<=@P_PDate    
 And (@P_ManualF=0 or RArrHeader.ManualF=@P_ManualF)  
 And Cover.ISType<>'T'    
 And SysUserTOC.ID=@P_UserID and Cover.TOC=SysUserTOC.TOC and (SysUserTOC.TOC Like @P_TOC+'%' or @P_TOC='')  
 And SysUserBranch.ID=@P_UserID and Acceptance.BRanch=SysUserBranch.Branch and (SysUserBranch.Branch=@P_Branch or @P_Branch='')  

    
Union    
          
SELECT Cast(0 as bit) as ProcessFlag,     
 Cover.COVERNO,    
 Cast(Acceptance.AName as varchar(128)) as Insured,    
 Cover.CNO,    
 Cover.CStatus,    
 Acceptance.lANO,    
 Acceptance.ANO,    
 Acceptance.REGNO,    
 Acceptance.ADATE,    
 Acceptance.LUSERID as USERID,    
 SysTab.Currency,    
 QPCalc.TSI,    
 QPCalc.OurShare,    
 QPCalc.Gross,    
 Acceptance.ASTATUS,    
 Acceptance.ATYPE,    
 Acceptance.SDate,    
 Acceptance.EDate,    
 Year(Acceptance.SDate) AS RYear,    
 Cover.ISType,    
 Acceptance.Renewal,    
 Acceptance.ESeqNo,    
 Acceptance.PolicyNo,    
 acceptance.CertificateNo    
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader, Acceptance As Acceptance_Detail, SysUserTOC, SysUserBranch
Where cover.CNO = acceptance.CNO    
 And QPCalc.ANO=Acceptance.ANO    
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO    
 And RArrHeader.ANO=Acceptance_Detail.ANO    
 And Cover.CStatus<>'C'    
 And Acceptance_Detail.AStatus='I' and Acceptance_Detail.AType not in ('A','C')    
 And RArrHeader.NRDate<Acceptance_Detail.EDate And RArrHeader.NRDate<=@P_PDate    
 And (@P_ManualF=0 or RArrHeader.ManualF=@P_ManualF)  
 And Cover.ISType<>'T'    
 And SysUserTOC.ID=@P_UserID and Cover.TOC=SysUserTOC.TOC and (SysUserTOC.TOC Like @P_TOC+'%' or @P_TOC='')  
 And SysUserBranch.ID=@P_UserID and Acceptance_Detail.BRanch=SysUserBranch.Branch and (SysUserBranch.Branch=@P_Branch or @P_Branch='')  
        
  
GO

    
DROP FUNCTION List11F_Det     
GO
CREATE FUNCTION List11F_Det (@P_ANO as integer,@P_UserID as varchar(10), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_PDate as smalldatetime, @P_ManualF as bit)    
RETURNS Table    
AS RETURN(    
        
SELECT Cast(0 as bit) as ProcessFlag,    
 Acceptance.CertificateNo,    
 Acceptance.ESeqNo,    
 Acceptance.AName,    
 Acceptance.ANO,    
 Acceptance.REGNO,    
 Acceptance.ADATE,    
 Acceptance.LUSERID as UserID,    
 SysTab.Currency,    
 QPCalc.TSI,    
 QPCalc.OurShare,    
 QPCalc.Gross,    
 Acceptance.ASTATUS,    
 Acceptance.ATYPE,    
 Acceptance.SDate,    
 Acceptance.EDate,    
 Year(Acceptance.SDate) AS RYear,    
 Acceptance.ValueID,    
 Acceptance.ValueDesc    
From    
 Acceptance,    
 Cover,    
 SysTab,    
 QMasterAcceptance_PCalc() AS QPCalc,    
 RARRHEADER, 
 SysUserTOC, 
 SysUserBranch
Where    
 cover.CNO = acceptance.CNO    
 And Rarrheader.ANO = Acceptance.ANO    
 And QPCalc.ANO=Acceptance.ANO    
 And Acceptance.ANO<>Acceptance.LANO    
 And Acceptance.LANO=@P_ANO    
 And Cover.CStatus<>'C'    
 And Acceptance.AStatus='I' and Acceptance.AType not in ('A','C')    
 And RArrHeader.NRDate<Acceptance.EDate And RArrHeader.NRDate<=@P_PDate    
 And (@P_ManualF=0 or RArrHeader.ManualF=@P_ManualF)  
 And Cover.ISType<>'T'    
 And SysUserTOC.ID=@P_UserID and Cover.TOC=SysUserTOC.TOC and (SysUserTOC.TOC Like @P_TOC+'%' or @P_TOC='')  
 And SysUserBranch.ID=@P_UserID and Acceptance.BRanch=SysUserBranch.Branch and (SysUserBranch.Branch=@P_Branch or @P_Branch='')  
 
)    
        
GO



--30 April 2015 : Tuning Script
DROP FUNCTION R_SL_ALLOCATED
GO
CREATE FUNCTION R_SL_ALLOCATED(@P_PDate as smalldatetime)                                     
RETURNS TABLE  AS                                       
RETURN (                                     
                             
--SL from Payment Voucher                                   
Select pSL.Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pSL.Voucher as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Rate*pSL.Nominal_OC) as Nominal_OC                                
From dbo.pSL                  
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)                  
Where pVoucher.SL_Cat in ('P') and pSL.PaymentF=1 and pVoucher.Date<=@P_PDate            
Group By pSL.Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Currency, pSL.Account                       


Union All

--SL from InterOffice Overbooking Voucher                                   
Select pVoucher.RefNo as Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pVoucher.RefNo as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Rate*pSL.Nominal_OC) as Nominal_OC                                
From dbo.pSL                  
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)          
Inner Join dbo.pVoucher OVoucher on (OVoucher.Voucher=pVoucher.RefNo)        
Where pVoucher.SL_Cat in ('B') and pVoucher.RefType='INTEROFFICE' and pSL.PaymentF=1 and pVoucher.Date<=@P_PDate            
Group By pVoucher.RefNo, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Currency, pSL.Account                       
                                   
union all                                   
                                   
--SL from Overbooking Payment and Adjustment Payment                                   
Select SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.Voucher as Doc_No, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end as Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                        
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal_OC else -SL.Nominal_OC end*SL.Rate)) as Nominal_OC                                   
from pSL SL, pVoucher VoucherP, pVoucher VoucherR, VPattern                         
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('B','A') and VoucherP.SL_Cat='P' and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher and SL.PaymentF=1 and VoucherR.Date<=@P_PDate                   
and VPattern.VType=VoucherR.VType and ((VPattern.Debit=SL.hint and VoucherR.DebtorF=1) or (VPattern.Credit=SL.hint and VoucherR.CreditorF=1))                         
Group By SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Currency, VoucherP.Voucher, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end, SL.Account                                
                             
union all                                   
                                   
--SL from Adjustment Overbooking                                   
Select SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.RefNo as Doc_No, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end as Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                        
sum((case When VoucherR.DebtorF=pVoucher.DebtorF Then SL.Nominal_OC else -SL.Nominal_OC end*SL.Rate)) as Nominal_OC                                   
from pSL SL, pVoucher VoucherP, pVoucher VoucherR, pVoucher, VPattern                         
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('A') and VoucherP.SL_Cat in ('B') and VoucherR.RefNo=VoucherP.Voucher and pVoucher.SL_Cat in ('P') and VoucherP.RefNo=pVoucher.Voucher and SL.Voucher=VoucherR.Voucher and SL.PaymentF=1 and VoucherR.Date<=@P_PDate            
and VPattern.VType=VoucherR.VType and ((VPattern.Debit=SL.hint and VoucherR.DebtorF=1) or (VPattern.Credit=SL.hint and VoucherR.CreditorF=1))                         
Group By SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Currency, VoucherP.RefNo, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end, SL.Account                       
                                   
union all                                   
                                   
--SL from Sub Ledger Payment Voucher and OverPaid                                   
Select SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, SL.Doc_Date, SL.Doc_CCY, SL.Doc_No as Doc_No, SL.Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                        
(Case When VoucherR.SL_Cat='O'                                    
then (case when VoucherR.DebtorF=VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                    
else (case when VoucherR.DebtorF<>VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                   
end) as Nominal_OC                                   
from pSL SL, pVoucher VoucherP, pVoucher VoucherR                                   
Where VoucherR.SL_Cat in ('O','P','A','B') and VoucherP.SL_Cat in ('P') and VoucherR.Voucher=SL.Voucher and SL.Doc_No=VoucherP.Voucher and SL.PaymentF=1 and VoucherR.Date<=@P_PDate                                  
                                     
)   

GO

--Penambahan Informasi Prev Polis & sertifikat No 
DROP PROCEDURE PI01   
GO  
CREATE PROCEDURE PI01 (@P_ANO AS INTEGER)          
AS      
(          
SELECT TOP 1      
 A.POLICYNO, A.CERTIFICATENO, C.PHOLDER, P.PREFERREDF, P.RESTRICTEDF, P.NAME, A.ANAME, A.AID,       
 (LTRIM(RTRIM(P.ADDRESS_1)) + ' ' + LTRIM(RTRIM(P.ADDRESS_2)) + ' ' + LTRIM(RTRIM(P.ADDRESS_3))) AS 'ADDRESS',      
 (LTRIM(RTRIM(P.PHONE_1)) + ' ' + LTRIM(RTRIM(P.PHONE_2))) AS 'PHONE',      
 (LTRIM(RTRIM(P.FAX_1)) + ' ' + LTRIM(RTRIM(P.FAX_2))) AS 'FAX',      
 P.EMAIL, A.SDATE, A.EDATE, A.PDATE, A.PPDATE,
 RA.POLICYNO as PPOLICYNO, RA.CERTIFICATENO as PCERTIFICATENO
FROM COVER C 
INNER JOIN ACCEPTANCE A ON (A.CNO=C.CNO)      
LEFT JOIN ACCEPTANCE RA ON (RA.ANO=A.RANO)
INNER JOIN PROFILE P ON (C.PHOLDER=P.ID)      
WHERE A.ANO=@P_ANO      
)         
  
GO

DROP procedure PI08 
GO
CREATE procedure PI08 (@P_ANO as integer)            
as            
Begin          
Declare @P_Date as smalldatetime      
 Declare @P_PolicyNo as varchar(20)      
 Declare @P_CertificateNo as varchar(20)      
 Declare @P_OpenFLag as Bit      
 Declare @P_LANO as int        
 Declare @P_A_PolicyNo as varchar(50)      
 Select @P_Date = Getdate()            
       
 Select @P_LANO=A1.LANO, @P_PolicyNo=A1.PolicyNo, @P_CertificateNo=A1.CertificateNo, @P_OpenFlag=C1.OpenFlag from Acceptance A1, Cover C1 Where C1.CNO=A1.CNO and A1.ANO=@P_ANO      
      
 if @P_LANO<>-1       
 if @P_OpenFlag=1 and @P_ANO<>@P_LANO       
  Select @P_A_PolicyNo=@P_PolicyNo + '-' + @P_CertificateNo      
 else      
  Select @P_A_PolicyNo=@P_PolicyNo      
 else      
  Select @P_A_PolicyNo=@P_PolicyNo        
     
 Select Voucher.Voucher, Voucher.DueDate, Voucher.DocNo, Voucher_Due.DueDate as NDueDate, Profile.Name, Voucher.Currency,    
 Admlink.RefType,  Admlink.AccountNo, Admlink.Bank, Admlink.BankName,
 case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC) end  as Nominal,     
 case when Voucher.debtorf=1 then (coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) else -(coalesce(Voucher_Due.AmountDue, Voucher.AmountDue)-Voucher.Payment_CC) end as AmountDue,      
 case when Voucher.debtorf=1 then Voucher.Payment_CC else -Voucher.Payment_CC end as Payment,     
 case when Voucher.debtorf=1 then Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC else -(Voucher.Nominal_CC-Voucher.Diff_CC - Voucher.Payment_CC) end as Outstanding,    
 Voucher.Installment,        
 Voucher.DueDate_1, case when Voucher.debtorf=1 then Voucher.AmountDue_1 else -Voucher.AmountDue_1 end AmountDue_1,        
 Voucher.DueDate_2, case when Voucher.debtorf=1 then Voucher.AmountDue_2 else -Voucher.AmountDue_2 end AmountDue_2,        
 Voucher.DueDate_3, case when Voucher.debtorf=1 then Voucher.AmountDue_3 else -Voucher.AmountDue_3 end AmountDue_3,        
 Voucher.DueDate_4, case when Voucher.debtorf=1 then Voucher.AmountDue_4 else -Voucher.AmountDue_4 end AmountDue_4,        
 Voucher.DueDate_5, case when Voucher.debtorf=1 then Voucher.AmountDue_5 else -Voucher.AmountDue_5 end AmountDue_5,        
 Voucher.DueDate_6, case when Voucher.debtorf=1 then Voucher.AmountDue_6 else -Voucher.AmountDue_6 end AmountDue_6,        
 Voucher.DueDate_7, case when Voucher.debtorf=1 then Voucher.AmountDue_7 else -Voucher.AmountDue_7 end AmountDue_7,        
 Voucher.DueDate_8, case when Voucher.debtorf=1 then Voucher.AmountDue_8 else -Voucher.AmountDue_8 end AmountDue_8,        
 Voucher.DueDate_9, case when Voucher.debtorf=1 then Voucher.AmountDue_9 else -Voucher.AmountDue_9 end AmountDue_9,        
 Voucher.DueDate_10, case when Voucher.debtorf=1 then Voucher.AmountDue_10 else -Voucher.AmountDue_10 end AmountDue_10,        
 Voucher.DueDate_11, case when Voucher.debtorf=1 then Voucher.AmountDue_11 else -Voucher.AmountDue_11 end AmountDue_11,        
 Voucher.DueDate_12, case when Voucher.debtorf=1 then Voucher.AmountDue_12 else -Voucher.AmountDue_12 end AmountDue_12,  
 Voucher.DueDate_13, case when Voucher.debtorf=1 then Voucher.AmountDue_13 else -Voucher.AmountDue_13 end AmountDue_13,        
 Voucher.DueDate_14, case when Voucher.debtorf=1 then Voucher.AmountDue_14 else -Voucher.AmountDue_14 end AmountDue_14,        
 Voucher.DueDate_15, case when Voucher.debtorf=1 then Voucher.AmountDue_15 else -Voucher.AmountDue_15 end AmountDue_15,        
 Voucher.DueDate_16, case when Voucher.debtorf=1 then Voucher.AmountDue_16 else -Voucher.AmountDue_16 end AmountDue_16,        
 Voucher.DueDate_17, case when Voucher.debtorf=1 then Voucher.AmountDue_17 else -Voucher.AmountDue_17 end AmountDue_17,        
 Voucher.DueDate_18, case when Voucher.debtorf=1 then Voucher.AmountDue_18 else -Voucher.AmountDue_18 end AmountDue_18,        
 Voucher.DueDate_19, case when Voucher.debtorf=1 then Voucher.AmountDue_19 else -Voucher.AmountDue_19 end AmountDue_19,        
 Voucher.DueDate_20, case when Voucher.debtorf=1 then Voucher.AmountDue_20 else -Voucher.AmountDue_20 end AmountDue_20,        
 Voucher.DueDate_21, case when Voucher.debtorf=1 then Voucher.AmountDue_21 else -Voucher.AmountDue_21 end AmountDue_21,        
 Voucher.DueDate_22, case when Voucher.debtorf=1 then Voucher.AmountDue_22 else -Voucher.AmountDue_22 end AmountDue_22,        
 Voucher.DueDate_23, case when Voucher.debtorf=1 then Voucher.AmountDue_23 else -Voucher.AmountDue_23 end AmountDue_23,        
 Voucher.DueDate_24, case when Voucher.debtorf=1 then Voucher.AmountDue_24 else -Voucher.AmountDue_24 end AmountDue_24  
 from nVoucher Voucher Inner Join Voucher_AmountDue(@P_Date) Voucher_Due on (Voucher_Due.Voucher=Voucher.Voucher), Profile, ProAcc, Admlink    
 Where Profile.ID=ProAcc.ID and ProAcc.ProAcc=Voucher.ProAcc and Admlink.Voucher=Voucher.Voucher                  
 and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') and Admlink.A_PolicyNo=@P_A_PolicyNo and (Admlink.Extra_1='' or Admlink.Extra_1 is null)    
End          
    
GO



-- Penambahan parameter refno pada servicing
DROP PROCEDURE QSRACC_1 
GO
CREATE PROCEDURE QSRACC_1 (@P_MO as varchar(10), @P_Segment as varchar(10), @P_Branch as varchar(10), @P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO VARCHAR(255))    
AS    
SELECT TOP 50 ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, Acceptance.AID, Acceptance.AName, SysUser.Name as MOName, Acceptance.Branch, Cover.PHolder, COVER.INSURED, COVER.TOC, Cover.CoverDate, Cover.ExpDate, RCover.Code, RCover.Coverage, TOC.RegID,    
TOC.Description as TOCDesc, Profile.Name as PHolderName, Profile.Address_1, Profile.Address_2, Profile.Phone_1, Profile.Phone_2, PCalc.Currency, PCalc.TSI,    
Acceptance.LANO, Acceptance.ANO, Acceptance.Source as BSID, Cover.CNO, Cover.ASource, Cover.PolicyType, Cover.ISType, Cover.Segment, Cover.MO, Branch.Name as BranchName,  
Acceptance.TOPRO, TOPRO.Description as TOPRODesc, Acceptance.RefNo  
FROM ACCEPTANCE Left Join (Select RCover.ANO, Max(RCover.Code) as Code, Max(RateTab.Description) as Coverage from RCover, RateTab Where RateTab.Code=RCover.Code and RCover.Category='M' Group By RCover.ANO) RCover on (RCover.ANO=Acceptance.ANO)    
Left join TOPRO on (TOPRO.TOPRO=Acceptance.TOPRO)  
Inner Join Cover on (Cover.CNO=Acceptance.CNO) inner join TOC on (TOC.TOC=Cover.TOC) inner join Profile on (Profile.ID=Cover.PHolder) inner join SysUser on (SysUser.ID=Cover.MO) inner join Branch on (Branch.Branch=Acceptance.Branch)    
Left Join PCalc on (PCalc.ANO=Acceptance.ANO)    
WHERE ACCEPTANCE.ATYPE Not In ('A','C') And ACCEPTANCE.ASTATUS<>'W' And ACCEPTANCE.PDATE<>ACCEPTANCE.PPDATE    
And Cover.MO like @P_MO and Cover.Segment Like @P_Segment    
And Acceptance.Branch Like @P_Branch and ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO    
--And Acceptance.ANO<>Acceptance.LANO    
ORDER BY ACCEPTANCE.ANO DESC    

GO


--26 May 2015 : Penambahan parameter policyno ketika inquiry query marketing


GO

/****** Object:  StoredProcedure [dbo].[MList01]    Script Date: 05/26/2015 00:18:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList01]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MList01]
GO

/****** Object:  StoredProcedure [dbo].[MList01A]    Script Date: 05/26/2015 00:18:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList01A]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MList01A]
GO

/****** Object:  StoredProcedure [dbo].[MLIST02]    Script Date: 05/26/2015 00:18:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MLIST02]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MLIST02]
GO

/****** Object:  StoredProcedure [dbo].[MList03]    Script Date: 05/26/2015 00:18:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList03]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MList03]
GO

/****** Object:  StoredProcedure [dbo].[MList04]    Script Date: 05/26/2015 00:18:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList04]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MList04]
GO

/****** Object:  StoredProcedure [dbo].[MList04a]    Script Date: 05/26/2015 00:18:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList04a]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MList04a]
GO

/****** Object:  StoredProcedure [dbo].[MList04b]    Script Date: 05/26/2015 00:18:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList04b]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MList04b]
GO

/****** Object:  StoredProcedure [dbo].[MList04c]    Script Date: 05/26/2015 00:18:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList04c]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MList04c]
GO

/****** Object:  StoredProcedure [dbo].[MList05]    Script Date: 05/26/2015 00:18:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList05]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MList05]
GO

/****** Object:  StoredProcedure [dbo].[MList06]    Script Date: 05/26/2015 00:18:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList06]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MList06]
GO

/****** Object:  StoredProcedure [dbo].[MList07]    Script Date: 05/26/2015 00:18:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList07]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MList07]
GO

/****** Object:  StoredProcedure [dbo].[MList08]    Script Date: 05/26/2015 00:18:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList08]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MList08]
GO

/****** Object:  StoredProcedure [dbo].[MList09]    Script Date: 05/26/2015 00:18:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList09]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MList09]
GO

/****** Object:  StoredProcedure [dbo].[MList10]    Script Date: 05/26/2015 00:18:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList10]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MList10]
GO

/****** Object:  StoredProcedure [dbo].[MList12]    Script Date: 05/26/2015 00:18:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList12]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MList12]
GO

/****** Object:  StoredProcedure [dbo].[MList13]    Script Date: 05/26/2015 00:18:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList13]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MList13]
GO

/****** Object:  StoredProcedure [dbo].[MList14]    Script Date: 05/26/2015 00:18:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList14]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MList14]
GO

/****** Object:  StoredProcedure [dbo].[MList15]    Script Date: 05/26/2015 00:18:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList15]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MList15]
GO

/****** Object:  StoredProcedure [dbo].[MList20]    Script Date: 05/26/2015 00:18:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList20]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MList20]
GO

/****** Object:  StoredProcedure [dbo].[MListQry_2]    Script Date: 05/26/2015 00:18:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MListQry_2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MListQry_2]
GO

/****** Object:  StoredProcedure [dbo].[MListSR]    Script Date: 05/26/2015 00:18:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MListSR]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MListSR]
GO


GO

/****** Object:  StoredProcedure [dbo].[MList01]    Script Date: 05/26/2015 00:18:45 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO






CREATE PROCEDURE [dbo].[MList01] (@P_UserID as Varchar(20))
AS
SELECT Cast(0 as bit) as ProcessFlag, [Cover].[COVERNO], [Cover].[Insured], [Cover].[CNO], [Cover].[CStatus], Cover.VSeqNo, [Acceptance].[lANO], [Acceptance].[ANO], [Acceptance].[REGNO], [Acceptance].[ADATE],[Acceptance].[LUSERID] as USERID,  [SysTab].[Currency], [QPCalc].[TSI], [QPCalc].[OurShare], [QPCalc].[Gross], [Acceptance].[ASTATUS], [Acceptance].[ATYPE], [Acceptance].[SDate], [Acceptance].[EDate], 
  Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
  Cover.ISType, 
  Acceptance.Renewal, 
  Acceptance.ESeqNo, 
  Acceptance.PolicyNo  
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE [Cover].[CNO]=[Acceptance].[CNO] 
	And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) 
	And [Acceptance].[AType]='N' 
	And [Acceptance].[LUserID] Like @P_UserID
	And [Cover].[CStatus]='R'


GO

/****** Object:  StoredProcedure [dbo].[MList01A]    Script Date: 05/26/2015 00:18:46 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO




CREATE PROCEDURE [dbo].[MList01A](@P_Date as Smalldatetime) 
AS
SELECT Cast(0 as bit) as ProcessFlag, [Cover].[COVERNO], [Cover].[Insured], [Cover].[CNO], [Cover].[CStatus], Cover.VSeqNo, [Acceptance].[lANO], [Acceptance].[ANO], [Acceptance].[REGNO], [Acceptance].[ADATE], [Acceptance].[LUSERID] as USERID, [SysTab].[Currency], [QPCalc].[TSI], [QPCalc].[OurShare], [QPCalc].[Gross], [Acceptance].[ASTATUS], [Acceptance].[ATYPE], [Acceptance].[SDate], [Acceptance].[EDate], 
  Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
  Cover.ISType, 
  Acceptance.Renewal, 
  Acceptance.ESeqNo, 
  Acceptance.PolicyNo  
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE [Cover].[CNO]=[Acceptance].[CNO] And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) And [Acceptance].[AType]='N' And [Cover].[CStatus]='R' And  [Cover].[CDate]+[Cover].[Validation]<=@p_Date;


GO

/****** Object:  StoredProcedure [dbo].[MLIST02]    Script Date: 05/26/2015 00:18:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[MLIST02] (@P_UserID as varchar(20))
AS
SELECT 		Cast(0 as bit) as ProcessFlag, 
		[Cover].[COVERNO], 
		[Cover].[Insured], 
		[Cover].[CNO], 
		[Cover].[CStatus], 
		[Cover].[VSeqNo], 
		[Acceptance].[lANO], 
		[Acceptance].[ANO], 
		[Acceptance].[REGNO], 
		[Acceptance].[ADATE], 
		[Acceptance].[LUSERID] as USERID, 
		[SysTab].[Currency], 
		[QPCalc].[TSI], 
		[QPCalc].[OurShare], 
		[QPCalc].[Gross], 
		[Acceptance].[ASTATUS], 
		[Acceptance].[ATYPE], 
		[Acceptance].[SDate], 
		[Acceptance].[EDate], 
		Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
		Cover.ISType, 
		Acceptance.Renewal, 
		Acceptance.ESeqNo, 
		Acceptance.PolicyNo		
FROM 	Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE 	[Cover].[CNO]=[Acceptance].[CNO] 
		And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) 
		And [Acceptance].[AType]='N' 
		And [Acceptance].[AStatus]='W' 
		And [Acceptance].[LUserID] Like @P_UserID
		And [Cover].[CStatus]='A'


GO

/****** Object:  StoredProcedure [dbo].[MList03]    Script Date: 05/26/2015 00:18:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE [dbo].[MList03] AS  
SELECT   Cast(0 as bit) as ProcessFlag,   
  [Cover].[COVERNO],   
  [Cover].[Insured],   
  [Cover].[CNO],   
  [Cover].[CStatus],   
  Cover.VSeqNo,   
  [Acceptance].[lANO],   
  [Acceptance].[ANO],   
  [Acceptance].[REGNO],   
  [Acceptance].[ADATE],   
  [Acceptance].[LUSERID] as USERID,   
  [SysTab].[Currency],   
  [QPCalc].[TSI],   
  [QPCalc].[OurShare],   
  [QPCalc].[Gross],   
  [Acceptance].[ASTATUS],   
  [Acceptance].[ATYPE],   
  [Acceptance].[SDate],   
  [Acceptance].[EDate],   
  Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
  Cover.ISType, 
  Acceptance.Renewal, 
  Acceptance.ESeqNo, 
  Acceptance.PolicyNo  
FROM  Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE  [Cover].[CNO]=[Acceptance].[CNO]   
  And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO])   
  And [Acceptance].[AType]='N'   
  And [Acceptance].[AStatus]='C'   
  And [Cover].[CStatus]='C'  
  

GO

/****** Object:  StoredProcedure [dbo].[MList04]    Script Date: 05/26/2015 00:18:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE [dbo].[MList04] (@P_UserID as Varchar(20))
AS
SELECT Cast(0 as bit) as ProcessFlag, [Cover].[COVERNO], [Cover].[Insured], [Cover].[CNO], [Cover].[CStatus], Cover.VSeqNo, [Acceptance].[lANO], [Acceptance].[ANO], [Acceptance].[REGNO], [Acceptance].[ADATE],[Acceptance].[LUSERID] as USERID,  [SysTab].[Currency], [QPCalc].[TSI], [QPCalc].[OurShare], [QPCalc].[Gross], [Acceptance].[ASTATUS], [Acceptance].[ATYPE], [Acceptance].[SDate], [Acceptance].[EDate], 
  Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
  Cover.ISType, 
  Acceptance.Renewal, 
  Acceptance.ESeqNo, 
  Acceptance.PolicyNo  
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
Where [cover].[CNO] = [acceptance].[CNO]
 And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO])
 And [Acceptance].[LUserID] Like @P_UserID
 And [Cover].[CStatus]='R'



GO

/****** Object:  StoredProcedure [dbo].[MList04a]    Script Date: 05/26/2015 00:18:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO






CREATE PROCEDURE [dbo].[MList04a] (@p_date as smalldatetime)
 AS
SELECT Cast(0 as bit) as ProcessFlag, [Cover].[COVERNO], [Cover].[Insured], [Cover].[CNO], [Cover].[CStatus], Cover.VSeqNo, [Acceptance].[lANO], [Acceptance].[ANO], [Acceptance].[REGNO], [Acceptance].[ADATE],[Acceptance].[LUSERID] as USERID,  [SysTab].[Currency], [QPCalc].[TSI], [QPCalc].[OurShare], [QPCalc].[Gross], [Acceptance].[ASTATUS], [Acceptance].[ATYPE], [Acceptance].[SDate], [Acceptance].[EDate], 
  Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
  Cover.ISType, 
  Acceptance.Renewal, 
  Acceptance.ESeqNo, 
  Acceptance.PolicyNo  
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE [Cover].[CNO]=[Acceptance].[CNO] And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) And [Cover].[CStatus]='P' And [Cover].[CDate]+[Cover].[Validation]<=@p_Date;


GO

/****** Object:  StoredProcedure [dbo].[MList04b]    Script Date: 05/26/2015 00:18:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[MList04b](@p_date as smalldatetime)  
AS  
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Cover.Insured, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.lANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE,Acceptance.LUSERID as USERID, SysTab.Currency, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, 
  Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
  Cover.ISType, 
  Acceptance.Renewal, 
  Acceptance.ESeqNo, 
  Acceptance.PolicyNo  
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO And (Acceptance.LANO=-1 Or Acceptance.ANO=Acceptance.LANO) And Acceptance.AType='N' And Acceptance.AStatus='W' And Cover.CStatus='A' and Cover.ASource='MKT'
And Acceptance.SDate+Cover.Validation<=@p_Date  




GO

/****** Object:  StoredProcedure [dbo].[MList04c]    Script Date: 05/26/2015 00:18:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




CREATE PROCEDURE [dbo].[MList04c](@p_date as smalldatetime)
AS
SELECT Cast(0 as bit) as ProcessFlag, [Cover].[COVERNO], [Cover].[Insured], [Cover].[CNO], [Cover].[CStatus], Cover.VSeqNo, [Acceptance].[lANO], [Acceptance].[ANO], [Acceptance].[REGNO], [Acceptance].[ADATE], [Acceptance].[LUSERID] as USERID, [SysTab].[Currency], [QPCalc].[TSI], [QPCalc].[OurShare], [QPCalc].[Gross], [Acceptance].[ASTATUS], [Acceptance].[ATYPE], [Acceptance].[SDate], [Acceptance].[EDate], 
  Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
  Cover.ISType, 
  Acceptance.Renewal, 
  Acceptance.ESeqNo, 
  Acceptance.PolicyNo  
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE [Cover].[CNO]=[Acceptance].[CNO] And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) And [Acceptance].[AType]='N' And [Acceptance].[AStatus]='W' And [Cover].[CStatus]='C' And [Cover].[CDate]+[Cover].[Validation]=@p_Date And Cover.Validation<>0


GO

/****** Object:  StoredProcedure [dbo].[MList05]    Script Date: 05/26/2015 00:18:46 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO




CREATE PROCEDURE [dbo].[MList05] (@P_UserID as varchar(20))
AS
SELECT Cast(0 as bit) as ProcessFlag, [Cover].[COVERNO], [Cover].[Insured], [Cover].[CNO], [Cover].[CStatus], Cover.VSeqNo, [Acceptance].[lANO], [Acceptance].[ANO], [Acceptance].[REGNO], [Acceptance].[ADATE], [Acceptance].[LUSERID] as USERID, [SysTab].[Currency], [QPCalc].[TSI], [QPCalc].[OurShare], [QPCalc].[Gross], [Acceptance].[ASTATUS], [Acceptance].[ATYPE], [Acceptance].[SDate], [Acceptance].[EDate], 
  Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
  Cover.ISType, 
  Acceptance.Renewal, 
  Acceptance.ESeqNo, 
  Acceptance.PolicyNo  
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE [Cover].[CNO]=[Acceptance].[CNO] 
	And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) 
	And [Acceptance].[AType]='N' And [Acceptance].[AStatus]='W' 
	And [Acceptance].[LUserID] Like @P_UserID
	And [Cover].[CStatus]='P'


GO

/****** Object:  StoredProcedure [dbo].[MList06]    Script Date: 05/26/2015 00:18:46 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO















CREATE PROCEDURE [dbo].[MList06] AS
SELECT 		Cast(0 as bit) as ProcessFlag, 
		[Cover].[COVERNO], 
		[Cover].[Insured], 
		[Cover].[CNO], 
		[Cover].[CStatus], 
		Cover.VSeqNo, 
		[Acceptance].[lANO], 
		[Acceptance].[ANO], 
		[Acceptance].[REGNO], 
		[Acceptance].[ADATE], 
		[Acceptance].[LUSERID] as USERID, 
		[SysTab].[Currency], 
		[QPCalc].[TSI], 
		[QPCalc].[OurShare], 
		[QPCalc].[Gross], 
		[Acceptance].[ASTATUS], 
		[Acceptance].[ATYPE], 
		[Acceptance].[SDate], 
		[Acceptance].[EDate], 
		 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
		 Cover.ISType, 
		 Acceptance.Renewal, 
		 Acceptance.ESeqNo, 
		 Acceptance.PolicyNo  
FROM 	Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE 	[Cover].[CNO]=[Acceptance].[CNO] 
		And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) 
		And [Acceptance].[AType]='N' 
		And [Acceptance].[AStatus]='W' 
		And [Cover].[CStatus]='V'


GO

/****** Object:  StoredProcedure [dbo].[MList07]    Script Date: 05/26/2015 00:18:46 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO





CREATE PROCEDURE [dbo].[MList07] AS
SELECT 		Cast(0 as bit) as ProcessFlag, 
		[Cover].[COVERNO], 
		[Cover].[Insured], 
		[Cover].[CNO], 
		[Cover].[CStatus], 
		Cover.VSeqNo, 
		[Acceptance].[lANO], 
		[Acceptance].[ANO], 
		[Acceptance].[REGNO], 
		[Acceptance].[ADATE], 
		[Acceptance].[LUSERID] as USERID, 
		[SysTab].[Currency], 
		[QPCalc].[TSI], 
		[QPCalc].[OurShare], 
		[QPCalc].[Gross], 
		[Acceptance].[ASTATUS], 
		[Acceptance].[ATYPE], 
		[Acceptance].[SDate], 
		[Acceptance].[EDate], 
		 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
		 Cover.ISType, 
		 Acceptance.Renewal, 
		 Acceptance.ESeqNo, 
		 Acceptance.PolicyNo  
FROM 	Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE 	[Cover].[CNO]=[Acceptance].[CNO] 
		And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) 
		And [Acceptance].[AType]='N' 
		And [Acceptance].[AStatus]='W' 
		And [Acceptance].[Renewal]>0


GO

/****** Object:  StoredProcedure [dbo].[MList08]    Script Date: 05/26/2015 00:18:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [dbo].[MList08](@P_CNO as Integer)   
AS  
SELECT Cast(0 as bit) as ProcessFlag, C1.COVERNO, C1.Insured, C1.CNO, C1.CStatus, C1.VSeqNo, Acceptance.lANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, 
  Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
  C1.ISType, 
  Acceptance.Renewal, 
  Acceptance.ESeqNo, 
  Acceptance.PolicyNo  
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover AS C1, Cover AS C2, SysTab
WHERE C1.CNO=Acceptance.CNO And (Acceptance.LANO=-1 Or Acceptance.ANO=Acceptance.LANO) And C1.CNO=C2.PCNO And C2.CNO=@P_CNO;




GO

/****** Object:  StoredProcedure [dbo].[MList09]    Script Date: 05/26/2015 00:18:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[MList09](@P_CNO as Integer)   
AS  
SELECT Cast(0 as bit) as ProcessFlag, C1.COVERNO, C1.Insured, C1.CNO, C1.CStatus, C1.VSeqNo, Acceptance.lANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, 
  Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
  C1.ISType, 
  Acceptance.Renewal, 
  Acceptance.ESeqNo, 
  Acceptance.PolicyNo  
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover AS C1, SysTab
WHERE C1.CNO=Acceptance.CNO And (Acceptance.LANO=-1 Or Acceptance.ANO=Acceptance.LANO) And C1.PCNO=@P_CNO




GO

/****** Object:  StoredProcedure [dbo].[MList10]    Script Date: 05/26/2015 00:18:46 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO















CREATE PROCEDURE [dbo].[MList10](@P_ANO as Integer) 
AS
SELECT Cast(0 as bit) as ProcessFlag, [Cover].[COVERNO], [Cover].[Insured], [Cover].[CNO], [Cover].[CStatus], Cover.VSeqNo, [Acceptance].[lANO], [Acceptance].[ANO], [Acceptance].[REGNO], [Acceptance].[ADATE], [Acceptance].[LUSERID] as USERID,  [SysTab].[Currency], [QPCalc].[TSI], [QPCalc].[OurShare], [QPCalc].[Gross], [Acceptance].[ASTATUS], [Acceptance].[ATYPE], [Acceptance].[SDate], [Acceptance].[EDate], 
  Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
  Cover.ISType, 
  Acceptance.Renewal, 
  Acceptance.ESeqNo, 
  Acceptance.PolicyNo  
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE [Cover].[CNO]=[Acceptance].[CNO] And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) And [Acceptance].[ANO]=@P_ANO


GO

/****** Object:  StoredProcedure [dbo].[MList12]    Script Date: 05/26/2015 00:18:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[MList12] (@P_ANO as integer)     
AS     

Select Cast(0 as bit) as ProcessFlag, [Cover].[COVERNO], [Cover].[Insured], [Cover].[CNO], [Cover].[CStatus], Cover.VSeqNo, [Acceptance].[lANO], [Acceptance].[ANO], [Acceptance].[REGNO], [Acceptance].[ADATE], [Acceptance].[LUSERID] as USERID,[SysTab].[Currency], [QPCalc].[TSI], [QPCalc].[OurShare], [QPCalc].[Gross], [Acceptance].[ASTATUS], [Acceptance].[ATYPE], [Acceptance].[SDate], [Acceptance].[EDate], 
  Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
  Cover.ISType, 
  Acceptance.Renewal, 
  Acceptance.ESeqNo, 
  Acceptance.PolicyNo  
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO And Acceptance.ANO=@P_ANO         

GO

/****** Object:  StoredProcedure [dbo].[MList13]    Script Date: 05/26/2015 00:18:46 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO















CREATE PROCEDURE [dbo].[MList13](@P_ID varchar(255)) AS
SELECT Cast(0 as bit) as ProcessFlag, [Cover].[COVERNO], [Cover].[Insured], [Cover].[CNO], [Cover].[CStatus], Cover.VSeqNo, [Acceptance].[lANO], [Acceptance].[ANO], [Acceptance].[REGNO], [Acceptance].[ADATE], [Acceptance].[LUSERID] as USERID,[SysTab].[Currency], [QPCalc].[TSI], [QPCalc].[OurShare], [QPCalc].[Gross], [Acceptance].[ASTATUS], [Acceptance].[ATYPE], [Acceptance].[SDate], [Acceptance].[EDate], 
  Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
  Cover.ISType, 
  Acceptance.Renewal, 
  Acceptance.ESeqNo, 
  Acceptance.PolicyNo  
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Payor
WHERE [Cover].[CNO]=[Acceptance].[CNO] And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) And [Acceptance].[AType]='N' And [Acceptance].[AStatus]='W' And [Cover].[CStatus] In ('R','P') And [Payor].[ANO]=[Acceptance].[ANO] And [Payor].[ID]=@P_ID


GO

/****** Object:  StoredProcedure [dbo].[MList14]    Script Date: 05/26/2015 00:18:46 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO





CREATE PROCEDURE [dbo].[MList14] AS
SELECT 		Cast(0 as bit) as ProcessFlag, 
		[Cover].[COVERNO], 
		[Cover].[Insured], 
		[Cover].[CNO], 
		[Cover].[CStatus], 
		[Cover].[VSeqNo], 
		[Acceptance].[lANO], 
		[Acceptance].[ANO], 
		[Acceptance].[REGNO], 
		[Acceptance].[ADATE], 
		[Acceptance].[LUSERID] as USERID,
		[SysTab].[Currency], 
		[QPCalc].[TSI], 
		[QPCalc].[OurShare], 
		[QPCalc].[Gross], 
		[Acceptance].[ASTATUS], 
		[Acceptance].[ATYPE], 
		[Acceptance].[SDate], 
		[Acceptance].[EDate], 
		Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
		Cover.ISType, 
		Acceptance.Renewal, 
		Acceptance.ESeqNo, 
		Acceptance.PolicyNo  
FROM 	Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE 	[Cover].[CNO]=[Acceptance].[CNO] 
		And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) 
		And (([RArrHeader].[TreatyF]=1 And ([RArrheader].[TShare]<>100 or RArrHeader.RAmount<>0)) or RArrHeader.HoldF=1)
		And [Acceptance].[AStatus]='W'
  
GO

/****** Object:  StoredProcedure [dbo].[MList15]    Script Date: 05/26/2015 00:18:46 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO





CREATE PROCEDURE [dbo].[MList15] (@P_ID as Varchar(10))
AS
SELECT 		Cast(0 as bit) as ProcessFlag, 
		[Cover].[COVERNO], 
		[Cover].[Insured], 
		[Cover].[CNO], 
		[Cover].[CStatus], 
		Cover.VSeqNo, 
		[Acceptance].[lANO], 
		[Acceptance].[ANO], 
		[Acceptance].[REGNO], 
		[Acceptance].[ADATE], 
		[Acceptance].[LUSERID] as USERID,
		[SysTab].[Currency], 
		[QPCalc].[TSI], 
		[QPCalc].[OurShare], 
		[QPCalc].[Gross], 
		[Acceptance].[ASTATUS], 
		[Acceptance].[ATYPE], 
		[Acceptance].[SDate], 
		[Acceptance].[EDate], 
		Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
		Cover.ISType, 
		Acceptance.Renewal, 
		Acceptance.ESeqNo, 
		Acceptance.PolicyNo  
FROM 	Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Payor
WHERE 	[Cover].[CNO]=[Acceptance].[CNO] 
		And Payor.ANO=Acceptance.ANO
		And Payor.ID=@P_ID
		And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) 
		And [Acceptance].[AType]='N' 
		And [Acceptance].[AStatus]='W' 
		And [Cover].[CStatus] in ('R','P','A')


GO

/****** Object:  StoredProcedure [dbo].[MList20]    Script Date: 05/26/2015 00:18:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



CREATE  PROCEDURE [dbo].[MList20] (@P_USERID as varchar(255),@P_Date as smalldatetime)
AS
SELECT Cast(0 as bit) as ProcessFlag, [Cover].[COVERNO], [Cover].[Insured], [Cover].[CNO], [Cover].[CStatus], Cover.VSeqNo, [Acceptance].[lANO], [Acceptance].[ANO], [Acceptance].[REGNO], [Acceptance].[ADATE],[Acceptance].[LUSERID] as USERID,  [SysTab].[Currency], [QPCalc].[TSI], [QPCalc].[OurShare], [QPCalc].[Gross], [Acceptance].[ASTATUS], [Acceptance].[ATYPE], [Acceptance].[SDate], [Acceptance].[EDate], 
		Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
		Cover.ISType, 
		Acceptance.Renewal, 
		Acceptance.ESeqNo, 
		Acceptance.PolicyNo  
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
Where [cover].[CNO] = [acceptance].[CNO]
 And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO])
 And [Acceptance].[LUserID] Like @P_UserID
 And [Acceptance].[LDate]=@P_Date



GO

/****** Object:  StoredProcedure [dbo].[MListQry_2]    Script Date: 05/26/2015 00:18:46 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO




CREATE PROCEDURE [dbo].[MListQry_2](@P_ANO as Integer)
AS
SELECT Cast(0 as bit) as ProcessFlag, [Cover].[COVERNO], [Cover].[Insured], [Cover].[CNO], [Cover].[CStatus], Cover.VSeqNo, [Acceptance].[lANO], [Acceptance].[ANO], [Acceptance].[REGNO], [Acceptance].[ADATE], [Acceptance].[LUSERID] as USERID,[SysTab].[Currency], [QPCalc].[TSI], [QPCalc].[OurShare], [QPCalc].[Gross], [Acceptance].[ASTATUS], [Acceptance].[ATYPE], [Acceptance].[SDate], [Acceptance].[EDate], 
  Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
  Cover.ISType, 
  Acceptance.Renewal, 
  Acceptance.ESeqNo, 
  Acceptance.PolicyNo  
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE [Cover].[CNO]=[Acceptance].[CNO] And [Acceptance].[ano]=@P_ANO And [Cover].[ISType]<>'T'


GO

/****** Object:  StoredProcedure [dbo].[MListSR]    Script Date: 05/26/2015 00:18:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[MListSR](@P_ID as int)  
AS  
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Cover.Insured, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.lANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, 
		Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
		Cover.ISType, 
		Acceptance.Renewal, 
		Acceptance.ESeqNo, 
		Acceptance.PolicyNo  
FROM  Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, TOC, SysRequest  
Where cover.CNO = acceptance.CNO  
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)  
 And SysRequest.ID=@P_ID  
 And SysRequest.Param2 in ('MAR','UND','CLM')  
 And SysRequest.Param3=Acceptance.ANO  
 And TOC.TOC=COVER.TOC  
      
Union  
      
SELECT  Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Cover.Insured, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.lANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, 
		Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
		Cover.ISType, 
		Acceptance.Renewal, 
		Acceptance.ESeqNo, 
		Acceptance.PolicyNo  
FROM  Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance As Acceptance_Detail, TOC, SysRequest  
Where cover.CNO = acceptance.CNO  
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO  
 And SysRequest.ID=@P_ID  
 And SysRequest.Param2 in ('MAR','UND','CLM')  
 And SysRequest.Param3=Acceptance_Detail.ANO  
 And TOC.TOC=COVER.TOC  



GO



-- 3 June 2015 : Perubahan display premium calculation dan di risk rate nya sama nominal angka di belakang koma.sebelumnya 5 digit di belakang koma. Sekarang jadi 6.


DROP Function FL_RateCode
GO
CREATE Function FL_RateCode(@P_ANO as integer, @P_Code as varchar(10),@P_AllowedF as bit=0, @P_TSI as float=0, @P_TOPF as bit=0)              
RETURNS Table              
AS RETURN              
(            
SELECT  RateTab.Code, RateTab.AllowedF, RateTab.NoRefundF,            
 max(RateTab.Description) as Description,            
 max(RateTab.Unit) as Unit,            
 max(RClass.Category) AS Category,            
 sum(  
 case   
 When coalesce(Case When RateTab.Unit='F' then (Case When @P_TSI<>0 then F.Rate*@P_TSI/100 else 0 end) When RateTab.Unit='M' then F.Rate*10 else F.Rate end,0)<>0 then  
	Case When RateTab.Unit='F' then (Case When @P_TSI<>0 then F.Rate*@P_TSI/100 else 0 end) When RateTab.Unit='M' then F.Rate*10 else F.Rate end  
 else   
	RateTab.Rate  
 end*RateCov.Portion/100) as Rate,   
  --in Percentage        
 sum(case when coalesce(F.MinRate,0)<>0 then F.MinRate else RateTab.MinRate end*RateCov.Portion/100) as MinRate,            
 sum(case when coalesce(F.MaxRate,0)<>0 then F.MaxRate else RateTab.MaxRate end*RateCov.Portion/100) as MaxRate,              
 max(F.PML) as PML,            
 sum(RateCov.Portion) AS Portion,            
 MAX(Case When coalesce(F.Loading,0)=0 Then 1 else F.Loading/100 end) As Loading,  
 Max(F.TExcess) as TExcess  
FROM  Acceptance        
Inner join Cover on (Cover.CNO=Acceptance.CNO)        
Inner join RateTab on ((RateTab.TOC=substring(Cover.TOC,1,len(RateTab.TOC))) and (@P_Code='%' or RateTab.Code Like @P_Code OR RateTab.Description Like @P_Code) And (RateTab.AllowedF=@P_AllowedF or @P_AllowedF=0))            
Inner join RateCov on (RateCov.Code=RateTab.Code)        
Inner join RClass on (RClass.TOC=Cover.TOC And RClass.TOR=RateCov.TOR)        
Left Join fn_RateCon(@P_ANO,@P_Code,@P_TSI) F on (F.Code=RateTab.Code)        
Left join TOP_RATE on (TOP_RATE.TOPRO=Acceptance.TOPRO and (TOP_Rate.Code=RateTab.Code or TOP_Rate.Code=RateTab.PCode))      
WHERE  Acceptance.ANO=@P_ANO and coalesce(F.AllowedF,1)=1  and (@P_TOPF=0 or coalesce(TOP_RATE.TOPRO,'')=Acceptance.TOPRO)      
GROUP BY RateTab.Code, RateTab.AllowedF, RateTab.NoRefundF         
)       

GO

DROP function ListDet05_a 
GO  
Create function ListDet05_a (@P_ANO as integer,   
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),   
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),  
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),  
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255)  
)        
RETURNS Table      
AS RETURN      
(      
 SELECT Cast(0 as bit) as ProcessFlag,      
 Acceptance.CertificateNo,      
 Acceptance.ESeqNo,      
 Acceptance.AName,      
 Acceptance.ANO,      
 Acceptance.REGNO,      
 Acceptance.ADATE,      
 Acceptance.LUSERID as UserID,      
 SysTab.Currency,      
 QPCalc.TSI,      
 QPCalc.OurShare,      
 QPCalc.Gross,      
 Acceptance.ASTATUS,      
 Acceptance.ATYPE,      
 Acceptance.SDate,      
 Acceptance.EDate,      
 Year(Acceptance.SDate) AS RYear,      
 Acceptance.ValueID,      
 Acceptance.ValueDesc      
From      
 Acceptance,      
 Cover,      
 SysTab,      
 QMasterAcceptance_PCalc() AS QPCalc,      
 Profile      
Where      
 cover.CNO = acceptance.CNO      
 And QPCalc.ANO=Acceptance.ANO      
 And Acceptance.ANO<>Acceptance.LANO      
 And Acceptance.LANO=@P_ANO      
 And Cover.PHOLDER=Profile.ID      
 And ((Cover.Insured Like @Value1 Or Cover.Insured is null) or (Acceptance.AName Like @Value1 Or Acceptance.AName is null))      
 And (Cover.CoverNo Like @Value2 Or Cover.CoverNo is null)      
 and (Cover.CoverDate = @Value3 Or Cover.CoverDate is null or @Value7 = '')      
 And (Cover.ExpDate = @Value4 Or Cover.ExpDate is null or @Value7 = '')      
 And (Acceptance.PolicyNo Like @Value5 Or Acceptance.PolicyNo is null)      
 And (Acceptance.CertificateNo Like @Value6 Or Acceptance.CertificateNo is null)      
 And (Acceptance.PolicyDate = @Value7 Or Acceptance.PolicyDate is null or @Value7 = '' or Acceptance.PolicyDate Between @Value7 and @Value16)      
 And (Acceptance.RegDate = @Value17 Or Acceptance.RegDate is null or @Value17 = '' or Acceptance.RegDate Between @Value17 and @Value18)      
 And Acceptance.AType Like @Value8      
 And Acceptance.AStatus Like @Value9      
 And Acceptance.RegNo Like @Value10      
 And Profile.Name Like @Value11     
 and cover.toc like @Value12      
 and (acceptance.refno like @Value13 or acceptance.refno is null)      
 and (Acceptance.Matters=@Value14 or @Value14='')      
 And Cover.ISType<>'T'      
 And (@Value15='%' or @Value15='' or 1 in (SELECT top 1 1 from Service Where ((Service.ANO=Acceptance.pANO and Service.ANO<>-1) or Service.ANO=Acceptance.ANO) and SStatus<>'R' and ServiceNo Like @Value15))      
 And (Acceptance.BatchNo Like @Value19 or (Acceptance.BatchNo is null and @Value19='%'))   
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')  
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')  
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))          
)      

GO

DROP function ListDet05_b      
GO
Create function ListDet05_b (@P_ANO as integer,   
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),   
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),  
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),  
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255)  
)        
RETURNS Table    
AS RETURN    
(    
SELECT Cast(0 as bit) as ProcessFlag,    
 q.[CertificateNo],    
 q.ESeqNo,    
 q.[AName],    
 q.[ANO],    
 q.[REGNO],    
 q.[ADATE],    
 q.[USERID],    
 q.[Currency],    
 q.[TSI],    
 q.[OurShare],    
 q.[Gross],    
 q.[ASTATUS],    
 q.[ATYPE],    
 q.[SDate],    
 q.[EDate],    
 q.RYear,    
 q.ValueID,     
 q.ValueDesc,    
 a.valueid1, a.valuedesc1,    
 a.valueid2, a.valuedesc2,    
 a.valueid3, a.valuedesc3,    
 a.valueid4, a.valuedesc4,    
 a.valueid5, a.valuedesc5,    
 a.valueid6, a.valuedesc6,    
 a.valueid7, a.valuedesc7,    
 a.valueid8, a.valuedesc8,    
 a.valueid9, a.valuedesc9,    
 a.valueid10, a.valuedesc10,    
 a.valueid11, a.valuedesc11,    
 a.valueid12, a.valuedesc12,    
 a.valueid13, a.valuedesc13,    
 a.valueid14, a.valuedesc14,    
 a.VALUEID15 , a.VALUEDESC15    
FROM ListDet05_a (@P_ANO, @Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18,@Value19, @Value20, @Value21, @Value22, @Value23) as q, ainfo as a    
Where q.ANO = a.ANO    
)    

GO


DROP FUNCTION SUM_INSURED_PROCESS  
GO  
CREATE FUNCTION SUM_INSURED_PROCESS (@P_Type varchar(2),@P_Date smalldatetime, @P_PEDate smalldatetime,@P_EDate smalldatetime)              
RETURNS TABLE              
AS RETURN(              
select A.Branch, A.DocNo, A.RefNo, A.Date as Date, A.TOC as Code, @P_Type as Type, A.Currency, 'JOURNAL' as Subject, A.AName as Remarks,                                         
Amount_1=sum(A.Amount_1),                  
Amount_2=sum(A.Amount_2),                  
Amount_3=sum(A.Amount_3),                  
Amount_4=0,                                      
Amount_5=0,                  
Amount=sum(A.Amount_1+A.Amount_2+A.Amount_3),
0 as Rate
from                   
                  
(                  
	-- Open Cover Annual Limit

	Select A1.Branch, A1.ADate as Date, C.TOC, A1.AName, A1.PolicyNo+case When C.OpenFlag=1 and A1.CertificateNo<>'' Then '-'+A1.CertificateNo else '' end +case When A1.ESeqNo<>0 then '-'+cast(A1.ESeqNo as varchar(3))+'/'+cast(A1.EESeqNo as varchar(3)) else '' end as DocNo, A1.RefNo, 
	I1.Currency,
	sum(I1.SI*coalesce(ISource.Share,100)/100) as Amount_1,
	sum(0) as Amount_2, 
	sum(0) as Amount_3
	from Acceptance A1, Cover C Left Join ISource on (ISource.CNO=C.CNO), ICover I1
	Where C.OpenFlag=1 and C.CNO=A1.CNO and A1.ANO=A1.LANO and I1.ANO=A1.ANO and I1.Category='M' and I1.SI<>0
	and A1.AType in ('N','E') 
	and A1.ADate between dateadd(day,1,@P_PEDate) and @P_EDate and A1.AStatus in ('I','C') and C.CStatus<>'C'
	and A1.EDate>@P_EDate
	Group by A1.Branch, A1.ADate, C.TOC, A1.AName, A1.PolicyNo+case When C.OpenFlag=1 and A1.CertificateNo<>'' Then '-'+A1.CertificateNo else '' end +case When A1.ESeqNo<>0 then '-'+cast(A1.ESeqNo as varchar(3))+'/'+cast(A1.EESeqNo as varchar(3)) else '' end, A1.RefNo, I1.Currency

	Union All
	-- Open Cover Annual Limit - Correction
	Select A1.Branch, A1.ADate as Date, C.TOC, A1.AName, A1.PolicyNo+case When C.OpenFlag=1 and A1.CertificateNo<>'' Then '-'+A1.CertificateNo else '' end +case When A1.ESeqNo<>0 then '-'+cast(A1.ESeqNo as varchar(3))+'/'+cast(A1.EESeqNo as varchar(3)) else '' end as DocNo, A1.RefNo,
	I1.Currency,
	sum(-I1.SI*coalesce(ISource.Share,100)/100) as Amount_1,
	sum(0) as Amount_2, 
	sum(0) as Amount_3
	from Acceptance A1, Acceptance pA, Cover C Left Join ISource on (ISource.CNO=C.CNO), ICover I1
	Where C.OpenFlag=1 and C.CNO=A1.CNO and A1.ANO=A1.LANO and pA.ANO=A1.pANO and I1.ANO=A1.pANO and I1.Category='M' and I1.SI<>0
	and pA.AType in ('N','E')
	and A1.ADate between dateadd(day,1,@P_PEDate) and @P_EDate and A1.AStatus in ('I','C') and C.CStatus<>'C'
	and A1.EDate>@P_EDate
	Group by A1.Branch, A1.ADate, C.TOC, A1.AName, A1.PolicyNo+case When C.OpenFlag=1 and A1.CertificateNo<>'' Then '-'+A1.CertificateNo else '' end +case When A1.ESeqNo<>0 then '-'+cast(A1.ESeqNo as varchar(3))+'/'+cast(A1.EESeqNo as varchar(3)) else '' end, A1.RefNo, I1.Currency

	Union All
	-- Open Cover Annual Limit - Expired
	Select A1.Branch, A1.EDate as Date, C.TOC, A1.AName, A1.PolicyNo+case When C.OpenFlag=1 and A1.CertificateNo<>'' Then '-'+A1.CertificateNo else '' end +case When A1.ESeqNo<>0 then '-'+cast(A1.ESeqNo as varchar(3))+'/'+cast(A1.EESeqNo as varchar(3)) else '' end as DocNo, A1.RefNo, 
	I1.Currency,
	sum(-I1.SI*coalesce(ISource.Share,100)/100) as Amount_1,
	sum(0) as Amount_2, 
	sum(0) as Amount_3	
	from Acceptance A1, Cover C Left Join ISource on (ISource.CNO=C.CNO), ICover I1
	Where C.OpenFlag=1 and C.CNO=A1.CNO and A1.ANO=A1.LANO and I1.ANO=A1.ANO and I1.Category='M' and I1.SI<>0
	and A1.AType in ('N','E') 
	and A1.ADate<=@P_EDate and A1.AStatus in ('I','C') and C.CStatus<>'C'
	and A1.EDate between dateadd(day,1,@P_PEDate) and @P_EDate
	Group by A1.Branch, A1.EDate, C.TOC, A1.AName, A1.PolicyNo+case When C.OpenFlag=1 and A1.CertificateNo<>'' Then '-'+A1.CertificateNo else '' end +case When A1.ESeqNo<>0 then '-'+cast(A1.ESeqNo as varchar(3))+'/'+cast(A1.EESeqNo as varchar(3)) else '' end, A1.RefNo, I1.Currency

	Union All

	--Open Cover Shipment
	Select A2.Branch, A2.ADate as Date, C.TOC, A2.AName, A2.PolicyNo+case When C.OpenFlag=1 and A2.CertificateNo<>'' Then '-'+A2.CertificateNo else '' end +case When A2.ESeqNo<>0 then '-'+cast(A2.ESeqNo as varchar(3))+'/'+cast(A2.EESeqNo as varchar(3)) else '' end as DocNo, A2.RefNo,
	I2.Currency,
	sum(0) as Amount_1,
	sum(I2.SI*coalesce(ISource.Share,100)/100) as Amount_2,
	sum(0) as Amount_3
	from Acceptance A1, Acceptance A2, Cover C Left Join ISource on (ISource.CNO=C.CNO), ICover I2
	Where C.OpenFlag=1 and C.CNO=A1.CNO and A1.ANO=A1.LANO 
	and A2.LANO=A1.ANO and I2.Category='M' and I2.ANO=A2.ANO and I2.SI<>0 
	--Open Cover Shipment
	and Exists (Select I.ANO from Acceptance A, Cover C, ICover I Where I.ANO=A2.LANO and A.ANO=A.LANO and C.CNO=A.CNO and C.OpenFlag=1 and I.ANO=A.ANO and I.Category='M' and I.SI<>0)
	and A2.AType in ('N','E')
	and A2.ADate between dateadd(day,1,@P_PEDate) and @P_EDate and A2.AStatus in ('I','C') and C.CStatus<>'C'
	and A2.EDate>@P_EDate
	Group by A2.Branch, A2.ADate, C.TOC, A2.AName, A2.PolicyNo+case When C.OpenFlag=1 and A2.CertificateNo<>'' Then '-'+A2.CertificateNo else '' end +case When A2.ESeqNo<>0 then '-'+cast(A2.ESeqNo as varchar(3))+'/'+cast(A2.EESeqNo as varchar(3)) else '' end, A2.RefNo, I2.Currency

	Union All
	
	--Open Cover Shipment - Correction
	Select A2.Branch, A2.ADate as Date, C.TOC, A2.AName, A2.PolicyNo+case When C.OpenFlag=1 and A2.CertificateNo<>'' Then '-'+A2.CertificateNo else '' end +case When A2.ESeqNo<>0 then '-'+cast(A2.ESeqNo as varchar(3))+'/'+cast(A2.EESeqNo as varchar(3)) else '' end as DocNo, A2.RefNo,
	I2.Currency,
	sum(0) as Amount_1, 
	sum(-I2.SI*coalesce(ISource.Share,100)/100) as Amount_2,
	sum(0) as Amount_3
	from Acceptance A1, Acceptance A2, Acceptance pA, Cover C Left Join ISource on (ISource.CNO=C.CNO), ICover I2
	Where C.OpenFlag=1 and C.CNO=A1.CNO and A1.ANO=A1.LANO 
	and A2.LANO=A1.ANO and pA.ANO=A2.pANO and I2.Category='M' and I2.ANO=A2.pANO and I2.SI<>0 
	--Open Cover Shipment
	and Exists (Select I.ANO from Acceptance A, Cover C, ICover I Where I.ANO=pA.LANO and A.ANO=A.LANO and C.CNO=A.CNO and C.OpenFlag=1 and I.ANO=A.ANO and I.Category='M' and I.SI<>0)
	and pA.AType in ('N','E')
	and A2.ADate between dateadd(day,1,@P_PEDate) and @P_EDate and A2.AStatus in ('I','C') and C.CStatus<>'C'
	and A2.EDate>@P_EDate
	Group by A2.Branch, A2.ADate, C.TOC, A2.AName, A2.PolicyNo+case When C.OpenFlag=1 and A2.CertificateNo<>'' Then '-'+A2.CertificateNo else '' end +case When A2.ESeqNo<>0 then '-'+cast(A2.ESeqNo as varchar(3))+'/'+cast(A2.EESeqNo as varchar(3)) else '' end, A2.RefNo, I2.Currency

	Union All

	--Open Cover Shipment - Expired
	Select A2.Branch, A2.EDate as Date, C.TOC, A2.AName, A2.PolicyNo+case When C.OpenFlag=1 and A2.CertificateNo<>'' Then '-'+A2.CertificateNo else '' end +case When A2.ESeqNo<>0 then '-'+cast(A2.ESeqNo as varchar(3))+'/'+cast(A2.EESeqNo as varchar(3)) else '' end as DocNo, A2.RefNo,
	I2.Currency,
	sum(0) as Amount_1, 
	sum(-I2.SI*coalesce(ISource.Share,100)/100) as Amount_2,
	sum(0) as Amount_3
	from Acceptance A1, Acceptance A2, Cover C Left Join ISource on (ISource.CNO=C.CNO), ICover I2
	Where C.OpenFlag=1 and C.CNO=A1.CNO and A1.ANO=A1.LANO 
	and A2.LANO=A1.ANO and I2.Category='M' and I2.ANO=A2.ANO and I2.SI<>0 
	--Open Cover Shipment
	and Exists (Select I.ANO from Acceptance A, Cover C, ICover I Where I.ANO=A2.LANO and A.ANO=A.LANO and C.CNO=A.CNO and C.OpenFlag=1 and I.ANO=A.ANO and I.Category='M' and I.SI<>0)
	and A2.AType in ('N','E')
	and A2.ADate<=@P_EDate and A2.AStatus in ('I','C') and C.CStatus<>'C'
	and A2.EDate between dateadd(day,1,@P_PEDate) and @P_EDate
	Group by A2.Branch, A2.EDate, C.TOC, A2.AName, A2.PolicyNo+case When C.OpenFlag=1 and A2.CertificateNo<>'' Then '-'+A2.CertificateNo else '' end +case When A2.ESeqNo<>0 then '-'+cast(A2.ESeqNo as varchar(3))+'/'+cast(A2.EESeqNo as varchar(3)) else '' end, A2.RefNo, I2.Currency

	Union All
	
	--Individual Shipment
	Select A1.Branch, A1.ADate as Date, C.TOC, A1.AName, A1.PolicyNo+case When C.OpenFlag=1 and A1.CertificateNo<>'' Then '-'+A1.CertificateNo else '' end +case When A1.ESeqNo<>0 then '-'+cast(A1.ESeqNo as varchar(3))+'/'+cast(A1.EESeqNo as varchar(3)) else '' end as DocNo, A1.RefNo,
	I1.Currency,
	sum(0) as Amount_1,
	sum(0) as Amount_2,
	sum(I1.SI*coalesce(ISource.Share,100)/100) as Amount_3
	from Acceptance A1, Cover C Left Join ISource on (ISource.CNO=C.CNO), ICover I1
	Where C.CNO=A1.CNO and I1.Category='M' and I1.ANO=A1.ANO and I1.SI<>0
	--Not Open Cover with Annual Limit
	and Not Exists (Select I.ANO from Acceptance A, Cover C, ICover I Where I.ANO=A1.LANO and A.ANO=A.LANO and C.CNO=A.CNO and C.OpenFlag=1 and I.ANO=A.ANO and I.Category='M' and I.SI<>0)
	and A1.AType in ('N','E')
	and A1.ADate between dateadd(day,1,@P_PEDate) and @P_EDate and A1.AStatus in ('I','C') and C.CStatus<>'C'
	and A1.EDate>@P_EDate
	Group by A1.Branch, A1.ADate, C.TOC, A1.AName, A1.PolicyNo+case When C.OpenFlag=1 and A1.CertificateNo<>'' Then '-'+A1.CertificateNo else '' end +case When A1.ESeqNo<>0 then '-'+cast(A1.ESeqNo as varchar(3))+'/'+cast(A1.EESeqNo as varchar(3)) else '' end, A1.RefNo, I1.Currency

	Union All
	
	--Individual Shipment - Correction
	Select A1.Branch, A1.ADate as Date, C.TOC, A1.AName, A1.PolicyNo+case When C.OpenFlag=1 and A1.CertificateNo<>'' Then '-'+A1.CertificateNo else '' end +case When A1.ESeqNo<>0 then '-'+cast(A1.ESeqNo as varchar(3))+'/'+cast(A1.EESeqNo as varchar(3)) else '' end as DocNo, A1.RefNo,
	I1.Currency,
	sum(0) as Amount_1,
	sum(0) as Amount_2,	
	sum(-I1.SI*coalesce(ISource.Share,100)/100) as Amount_3
	from Acceptance A1, Acceptance pA, Cover C Left Join ISource on (ISource.CNO=C.CNO), ICover I1
	Where C.CNO=A1.CNO and pA.ANO=A1.pANO and I1.Category='M' and I1.ANO=A1.pANO and I1.SI<>0
	--Not Open Cover with Annual Limit
	and Not Exists (Select I.ANO from Acceptance A, Cover C, ICover I Where I.ANO=pA.LANO and A.ANO=A.LANO and C.CNO=A.CNO and C.OpenFlag=1 and I.ANO=A.ANO and I.Category='M' and I.SI<>0)
	and pA.AType in ('N','E')
	and A1.ADate between dateadd(day,1,@P_PEDate) and @P_EDate and A1.AStatus in ('I','C') and C.CStatus<>'C'
	and A1.EDate>@P_EDate
	Group by A1.Branch, A1.ADate, C.TOC, A1.AName, A1.PolicyNo+case When C.OpenFlag=1 and A1.CertificateNo<>'' Then '-'+A1.CertificateNo else '' end +case When A1.ESeqNo<>0 then '-'+cast(A1.ESeqNo as varchar(3))+'/'+cast(A1.EESeqNo as varchar(3)) else '' end, A1.RefNo, I1.Currency
	
	Union All

	--Individual Shipment - Expired
	Select A1.Branch, A1.EDate as Date, C.TOC, A1.AName, A1.PolicyNo+case When C.OpenFlag=1 and A1.CertificateNo<>'' Then '-'+A1.CertificateNo else '' end +case When A1.ESeqNo<>0 then '-'+cast(A1.ESeqNo as varchar(3))+'/'+cast(A1.EESeqNo as varchar(3)) else '' end as DocNo, A1.RefNo,
	I1.Currency,
	sum(0) as Amount_1,
	sum(0) as Amount_2,	
	sum(-I1.SI*coalesce(ISource.Share,100)/100) as Amount_3
	from Acceptance A1, Cover C Left Join ISource on (ISource.CNO=C.CNO), ICover I1
	Where C.CNO=A1.CNO and I1.Category='M' and I1.ANO=A1.ANO and I1.SI<>0
	--Not Open Cover with Annual Limit
	and Not Exists (Select I.ANO from Acceptance A, Cover C, ICover I Where I.ANO=A1.LANO and A.ANO=A.LANO and C.CNO=A.CNO and C.OpenFlag=1 and I.ANO=A.ANO and I.Category='M' and I.SI<>0)
	and A1.AType in ('N','E')
	and A1.ADate<=@P_EDate and A1.AStatus in ('I','C') and C.CStatus<>'C'
	and A1.EDate between dateadd(day,1,@P_PEDate) and @P_EDate 
	Group by A1.Branch, A1.EDate, C.TOC, A1.AName, A1.PolicyNo+case When C.OpenFlag=1 and A1.CertificateNo<>'' Then '-'+A1.CertificateNo else '' end +case When A1.ESeqNo<>0 then '-'+cast(A1.ESeqNo as varchar(3))+'/'+cast(A1.EESeqNo as varchar(3)) else '' end, A1.RefNo, I1.Currency

)  A                        
Group By A.Branch, A.Date, A.DocNo, A.RefNo, A.TOC, A.Currency, A.AName
)

go



--21 August 2015 : Optimasi Process Query Document Finance


DROP FUNCTION R_SL_ALLOCATED
GO
CREATE FUNCTION R_SL_ALLOCATED(@P_PDate as smalldatetime)                                       
RETURNS TABLE  AS                                         
RETURN (                                       
                               
--SL from Payment Voucher                                     
Select pSL.Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pSL.Voucher as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Rate*pSL.Nominal_OC) as Nominal_OC                                  
From dbo.pSL                    
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)                    
Where pVoucher.SL_Cat in ('P') and pSL.PaymentF=1 and pVoucher.Date<=@P_PDate              
Group By pSL.Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Currency, pSL.Account                           
  
Union All  
  
--SL from InterOffice Overbooking Voucher                                     
Select pVoucher.RefNo as Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pVoucher.RefNo as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Rate*pSL.Nominal_OC) as Nominal_OC                                  
From dbo.pSL                    
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)            
Inner Join dbo.pVoucher OVoucher on (OVoucher.Voucher=pVoucher.RefNo)          
Where pVoucher.SL_Cat in ('B') and pVoucher.RefType='INTEROFFICE' and pSL.PaymentF=1 and pVoucher.Date<=@P_PDate              
Group By pVoucher.RefNo, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Currency, pSL.Account                         
                                     
union all                                     
                                     
--SL from Overbooking Payment and Adjustment Payment                                     
Select SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.Voucher as Doc_No, SL.SAccount as Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                          
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal_OC else -SL.Nominal_OC end*SL.Rate)) as Nominal_OC                                     
from pSL SL, pVoucher VoucherP, pVoucher VoucherR
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('B','A') and VoucherP.SL_Cat='P' and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher and SL.PaymentF=1 and VoucherR.Date<=@P_PDate                     
Group By SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Currency, VoucherP.Voucher, SL.SAccount, SL.Account                                  
                               
union all                                     
                                     
--SL from Adjustment Overbooking                                     
Select SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.RefNo as Doc_No, SL.SAccount as Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                          
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal_OC else -SL.Nominal_OC end*SL.Rate)) as Nominal_OC                                     
from pSL SL, pVoucher VoucherP, pVoucher VoucherR
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('A') and VoucherP.SL_Cat in ('B') and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher and SL.PaymentF=1 and VoucherR.Date<=@P_PDate              
Group By SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Currency, VoucherP.RefNo, SL.SAccount, SL.Account                         
                                     
union all                                     
                                     
--SL from Sub Ledger Payment Voucher and OverPaid                                     
Select SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, SL.Doc_Date, SL.Doc_CCY, SL.Doc_No as Doc_No, SL.Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                          
(Case When VoucherR.SL_Cat='O'                                      
then (case when VoucherR.DebtorF=VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                      
else (case when VoucherR.DebtorF<>VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                     
end) as Nominal_OC                                     
from pSL SL, pVoucher VoucherP, pVoucher VoucherR                                     
Where VoucherR.SL_Cat in ('O','P','A','B') and VoucherP.SL_Cat in ('P') and VoucherR.Voucher=SL.Voucher and SL.Doc_No=VoucherP.Voucher and SL.PaymentF=1 and VoucherR.Date<=@P_PDate                                    
                                       
)     

GO



--9 September 2015 : 3.	Perbaikan List Inward Treaty diluar yang sifatnya Proforma Polis dan Penambahan Inquiry Inward Treaty List berdasarkan Nomor Polis

DROP PROCEDURE List10
GO
CREATE PROCEDURE List10(@P_TOC as varchar(10), @P_Branch as varchar(10), @P_PolicyNO as varchar(10), @P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_AStatus as varchar(1))           
AS          
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.ANO AS ANO,           
 Cover.CNO,          
 Cover.CoverDate,          
 Cover.ExpDate,          
 Cast(Acceptance.AName as varchar(128)) as Insured,          
 Cover.UserID,          
 Cover.CStatus,          
 ISource.RType,           
 Acceptance.RegNo,           
 Acceptance.PolicyNo,          
 Profile.Name,           
 Acceptance.AStatus,           
 TOC.Description,           
 Acceptance.Branch          
FROM  Cover, ISource, Acceptance, Payor, Profile, TOC          
WHERE  Acceptance.ANO=Acceptance.LANO           
 And Cover.CNO=Acceptance.CNO           
 And ISource.CNO=Cover.CNO           
 And Payor.ANO=Acceptance.ANO           
 And Cover.ISType='T' and Cover.ProformaF=0
 And Profile.ID=Payor.ID           
 And TOC.TOC=Cover.TOC          
 And TOC.TOC Like @P_TOC+'%'      
 And Acceptance.Branch Like @P_Branch+'%'      
 And Acceptance.PolicyNo Like @P_PolicyNo +'%'      
 And (Acceptance.AStatus=@P_AStatus or @P_AStatus='')  
 And (@P_SDate between Cover.CoverDate and Cover.ExpDate  or @P_EDate between Cover.CoverDate and Cover.ExpDate or Cover.CoverDate Between @P_SDate and @P_EDate or Cover.ExpDate Between @P_SDate and @P_EDate)    
 order by ACCEPTANCE.RegNo        
 go


 
alter PROCEDURE CLLISTSR(@P_ID as int)  

AS  

SELECT  Cast(0 as bit) as ProcessFlag,  

 CLAIM.CLAIMNO,  

 CLAIM.REGDATE,  

 CLAIM.REFNO,  

 CLAIM.COL,  

 COLTAB.DESCRIPTION,  

 CLAIM.LOSSDATE,  

 CLAIM.TOC,  

 CLAIM.CSDATE,  
  [CLAIM].[PuserDATE],

 CLAIM.LOSSPLACE,  

 CLAIM.CTYPE,  

 CLAIM.CSTATUS,  

 CLAIM.CNO,  

 CLAIM.ANO,  

 CLAIM.PCNO,  

 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,  

 SYSTAB.CURRENCY,  

 CCALC.LOSS AS ESTIMATE,  

 CCALC.CLAIM AS CLAIM,  

 CCALC.DEDUCTIBLE AS DEDUCTIBLE,  

 CCALC.SALVAGE AS SALVAGE,  

 CCALC.COST AS COST,  

 CCALC.SUBROGATION AS SUBROGATION,  

 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,  

 CLAIM.VSEQNO,  

 CLAIM.CSEQNO,  

 acceptance.aname,  

 Claim.policyno,  

 Claim.certificateno,  

 CLAIM.SETTLEDF  

FROM  CLAIM Left Join CArrHeader on (CarrHeader.CNO=Claim.CNO)  

Left Join QClaim_CCalc() as CCalc on (CCalc.CNO=Claim.CNO)  

Left Join Acceptance on (Acceptance.ANO=Claim.ANO)  

inner join COLTAB on (COLTAB.COL=CLAIM.COL)  

, SYSTAB, SysRequest  

WHERE SysRequest.ID=@P_ID  

 And SysRequest.Param2 in ('MAR','UND','CLM')  

 And ((SysRequest.Param4=Claim.CNO and SysRequest.Param2='CLM') or (SysRequest.Param3=Claim.ANO and SysRequest.Param2 in ('MAR','UND')))  

    
go

ALTER PROCEDURE CLLIST15 AS

SELECT Cast(0 as bit) as ProcessFlag,

 [CLAIM].[CLAIMNO],

 [CLAIM].[REGDATE],

 [CLAIM].[REFNO],

 [CLAIM].[COL],

 [COLTAB].[DESCRIPTION],

 [CLAIM].[LOSSDATE],

 [CLAIM].[TOC],

 [CLAIM].[CSDATE],
 [CLAIM].[PuserDATE],
 [CLAIM].[LOSSPLACE],

 [CLAIM].[CTYPE],

 [CLAIM].[CSTATUS],

 [CLAIM].[CNO],

 [CLAIM].[ANO],

 [CLAIM].[PCNO],

 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,

 [SYSTAB].[CURRENCY],

 [CCALC].[LOSS] AS ESTIMATE,

 [CCALC].[CLAIM] AS CLAIM,

 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,

 [CCALC].[SALVAGE] AS SALVAGE,

 [CCALC].[COST] AS COST,

 [CCALC].[SUBROGATION] AS SUBROGATION,

 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,

 [CLAIM].[VSEQNO],

 [CLAIM].[CSEQNO],

 acceptance.aname,

 acceptance.policyno,

 acceptance.certificateno,

 CLAIM.SETTLEDF

FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance

Where [CARRHEADER].[CNO] = [CLAIM].[CNO]

 And [CCALC].[CNO]=[CLAIM].[CNO]

 And CLAIM.COL=COLTAB.COL

 And Acceptance.ANO=Claim.ANO

 And CLAIM.CNO  in

  

(Select CLLOSS.CNO  from CLLOSS, ICOVER, DOCLIST Where

 ICOVER.INO=CLLOSS.INO and CLLOSS.CNO=CLAIM.CNO and DOCLIST.NOC=CLLOSS.NOC and DOCLIST.TOI=ICOVER.TOI and DOCLIST.DOCTYPE Not in

 (Select DocType from CDOCLIST Where CDOCLIST.CNO=CLAIM.CNO and CDOCLIST.INO=CLLOSS.INO and CDOCLIST.NOC=CLLOSS.NOC and CDOCLIST.DOCTYPE=DOCLIST.DOCTYPE))

  


GO



ALTER PROCEDURE CLLIST05 AS

SELECT Cast(0 as bit) as ProcessFlag,

 CLAIM.CLAIMNO,

 CLAIM.REGDATE,

 CLAIM.REFNO,

 CLAIM.COL,

 COLTAB.DESCRIPTION,

 CLAIM.LOSSDATE,

 CLAIM.TOC,

 CLAIM.CSDATE,
  [CLAIM].[PuserDATE],

 CLAIM.LOSSPLACE,

 CLAIM.CTYPE,

 CLAIM.CSTATUS,

 CLAIM.CNO,

 CLAIM.ANO,

 CLAIM.PCNO,

 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,

 SYSTAB.CURRENCY,

 CCALC.LOSS AS ESTIMATE,

 CCALC.CLAIM AS CLAIM,

 CCALC.DEDUCTIBLE AS DEDUCTIBLE,

 CCALC.SALVAGE AS SALVAGE,

 CCALC.COST AS COST,

 CCALC.SUBROGATION AS SUBROGATION,

 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,

 CLAIM.VSEQNO,

 CLAIM.CSEQNO,

 acceptance.aname,

 acceptance.policyno,

 acceptance.certificateno,

 CLAIM.SETTLEDF

FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance

Where CARRHEADER.CNO = CLAIM.CNO

 And CCALC.CNO=CLAIM.CNO

 And CLAIM.COL=COLTAB.COL

 And acceptance.ano=claim.ano

 And CLAIM.REGDATE<=getdate() AND CLAIM.CTYPE<>'C' AND CLAIM.CSTATUS<>'R' AND

 ((CLAIM.SETTLEDF=0 AND CLAIM.CSDATE<=getdate() AND CLAIM.CSTATUS<>'C') OR

              (CLAIM.PSETTLEDF=0 AND CLAIM.CSDATE>getdate() AND (CLAIM.SETTLEDF=0 OR CLAIM.ADATE>getdate())))

  


GO





ALTER PROCEDURE CLLIST03 AS

SELECT Cast(0 as bit) as ProcessFlag,

 [CLAIM].[CLAIMNO],

 [CLAIM].[REGDATE],

 [CLAIM].[REFNO],

 [CLAIM].[COL],

 [COLTAB].[DESCRIPTION],

 [CLAIM].[LOSSDATE],
  [CLAIM].[PuserDATE],

 [CLAIM].[TOC],

 [CLAIM].[CSDATE],

 [CLAIM].[LOSSPLACE],

 [CLAIM].[CTYPE],

 [CLAIM].[CSTATUS],

 [CLAIM].[CNO],

 [CLAIM].[ANO],

 [CLAIM].[PCNO],

 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,

 [SYSTAB].[CURRENCY],

 [CCALC].[LOSS] AS ESTIMATE,

 [CCALC].[CLAIM] AS CLAIM,

 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,

 [CCALC].[SALVAGE] AS SALVAGE,

 [CCALC].[COST] AS COST,

 [CCALC].[SUBROGATION] AS SUBROGATION,

 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,

 [CLAIM].[VSEQNO],

 [CLAIM].[CSEQNO],

 acceptance.aname,

 acceptance.policyno,

 acceptance.certificateno,

 CLAIM.SETTLEDF

FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance

Where [CARRHEADER].[CNO] = [CLAIM].[CNO]

 And [CCALC].[CNO]=[CLAIM].[CNO]

 And CLAIM.COL=COLTAB.COL

 And [CLAIM].[CSTATUS]='T'

 and acceptance.ano=claim.ano






GO



ALTER PROCEDURE CLLIST08 AS

SELECT Cast(0 as bit) as ProcessFlag,

 [CLAIM].[CLAIMNO],

 [CLAIM].[REGDATE],

 [CLAIM].[REFNO],

 [CLAIM].[COL],

 [COLTAB].[DESCRIPTION],

 [CLAIM].[LOSSDATE],

 [CLAIM].[TOC],

 [CLAIM].[CSDATE],
  [CLAIM].[PuserDATE],

 [CLAIM].[LOSSPLACE],

 [CLAIM].[CTYPE],

 [CLAIM].[CSTATUS],

 [CLAIM].[CNO],

 [CLAIM].[ANO],

 [CLAIM].[PCNO],

 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,

 [SYSTAB].[CURRENCY],

 [CCALC].[LOSS] AS ESTIMATE,

 [CCALC].[CLAIM] AS CLAIM,

 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,

 [CCALC].[SALVAGE] AS SALVAGE,

 [CCALC].[COST] AS COST,

 [CCALC].[SUBROGATION] AS SUBROGATION,

 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,

 [CLAIM].[VSEQNO],

 [CLAIM].[CSEQNO],

 acceptance.aname,

 acceptance.policyno,

 acceptance.certificateno,

 CLAIM.SETTLEDF

FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance

Where [CARRHEADER].[CNO] = [CLAIM].[CNO]

 And [CCALC].[CNO]=[CLAIM].[CNO]

 And CLAIM.COL=COLTAB.COL

 And [CLAIM].[CSTATUS]='A'

 And Claim.Settledf=0

 and acceptance.ano = claim.ano




GO

ALTER PROCEDURE CLLIST11 AS    

SELECT Cast(0 as bit) as ProcessFlag,    

 [CLAIM].[CLAIMNO],    

 [CLAIM].[REGDATE],    

 [CLAIM].[REFNO],    

 [CLAIM].[COL],    

 [COLTAB].[DESCRIPTION],    

 [CLAIM].[LOSSDATE],    

 [CLAIM].[TOC],    

 [CLAIM].[CSDATE],   
  [CLAIM].[PuserDATE],

 [CLAIM].[LOSSPLACE],    

 [CLAIM].[CTYPE],    

 [CLAIM].[CSTATUS],    

 [CLAIM].[CNO],    

 [CLAIM].[ANO],    

 [CLAIM].[PCNO],    

 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,    

 [SYSTAB].[CURRENCY],    

 [CCALC].[LOSS] AS ESTIMATE,    

 [CCALC].[CLAIM] AS CLAIM,    

 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,    

 [CCALC].[SALVAGE] AS SALVAGE,    

 [CCALC].[COST] AS COST,    

 [CCALC].[SUBROGATION] AS SUBROGATION, ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,    

 [CLAIM].[VSEQNO],    

 [CLAIM].[CSEQNO],    

 acceptance.aname,    

 acceptance.policyno,    

 acceptance.certificateno,    

 CLAIM.SETTLEDF    

FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER, CLAIM AS C1,COLTAB,acceptance    

Where [CARRHEADER].[CNO] = [CLAIM].[CNO]    

 And [CCALC].[CNO]=[CLAIM].[CNO]    

 And CLAIM.COL=COLTAB.COL    

 And [CLAIM].[CNO]=C1.PCNO    

 And C1.CSTATUS='P'    

 And C1.VSEQNO<>0    

 and acceptance.ano=claim.ano    


GO



ALTER PROCEDURE CLLIST12 AS

SELECT Cast(0 as bit) as ProcessFlag,

 CLAIM.CLAIMNO,

 CLAIM.REGDATE,

 CLAIM.REFNO,

 CLAIM.COL,

 COLTAB.DESCRIPTION,

 CLAIM.LOSSDATE,

 CLAIM.TOC,

 CLAIM.CSDATE,
  [CLAIM].[PuserDATE],

 CLAIM.LOSSPLACE,

 CLAIM.CTYPE,

 CLAIM.CSTATUS,

 CLAIM.CNO,

 CLAIM.ANO,

 CLAIM.PCNO,

 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,

 SYSTAB.CURRENCY,

 CCALC.LOSS AS ESTIMATE,

 CCALC.CLAIM AS CLAIM,

 CCALC.DEDUCTIBLE AS DEDUCTIBLE,

 CCALC.SALVAGE AS SALVAGE,

 CCALC.COST AS COST,

 CCALC.SUBROGATION AS SUBROGATION,

 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,

 CLAIM.VSEQNO,

 CLAIM.CSEQNO,

 acceptance.aname,

 acceptance.policyno,

 acceptance.certificateno,

 CLAIM.SETTLEDF

FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER, CLAIM AS C1,COLTAB,acceptance

Where CARRHEADER.CNO = CLAIM.CNO

 And CCALC.CNO=CLAIM.CNO

 And CLAIM.COL=COLTAB.COL

 And CLAIM.CNO=C1.PCNO

 And C1.CSTATUS='P'

 And C1.CSEQNO<>0

 and acceptance.ano = claim.ano




GO



ALTER PROCEDURE CLLIST16 AS

SELECT Cast(0 as bit) as ProcessFlag,

 [CLAIM].[CLAIMNO],

 [CLAIM].[REGDATE],

 [CLAIM].[REFNO],

 [CLAIM].[COL],

 [COLTAB].[DESCRIPTION],

 [CLAIM].[LOSSDATE],

 [CLAIM].[TOC],

 [CLAIM].[CSDATE],
  [CLAIM].[PuserDATE],

 [CLAIM].[LOSSPLACE],

 [CLAIM].[CTYPE],

 [CLAIM].[CSTATUS],

 [CLAIM].[CNO],

 [CLAIM].[ANO],

 [CLAIM].[PCNO],

 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,

 [SYSTAB].[CURRENCY],

 [CCALC].[LOSS] AS ESTIMATE,

 [CCALC].[CLAIM] AS CLAIM,

 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,

 [CCALC].[SALVAGE] AS SALVAGE,

 [CCALC].[COST] AS COST,

 [CCALC].[SUBROGATION] AS SUBROGATION,

 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,

 [CLAIM].[VSEQNO],

 [CLAIM].[CSEQNO],

 acceptance.aname,

 acceptance.policyno,

 acceptance.certificateno,

 CLAIM.SETTLEDF

FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance

Where [CARRHEADER].[CNO] = [CLAIM].[CNO]

 And [CCALC].[CNO]=[CLAIM].[CNO]

 And CLAIM.COL=COLTAB.COL

 And [CLAIM].[REQUESTF]=1

 and acceptance.ano=claim.ano

  


GO

ALTER PROCEDURE View16 (@P_ANO as integer)
AS
SELECT Cover.*, [ISource].[RType], [Acceptance].[RegNo], [Acceptance].[ANO] AS ANO, [Payor].[ID], [Profile].[Name], [Acceptance].[AStatus], [TOC].[Description], [Acceptance].[Branch]
FROM Cover, ISource, Acceptance, Payor, Profile, TOC
WHERE [Acceptance].[ANO]=[Acceptance].[LANO] And [Cover].[CNO]=[Acceptance].[CNO] And [ISource].[CNO]=[Cover].[CNO] And [Payor].[ANO]=[Acceptance].[ANO] And [Cover].[ISType]='T' And [Profile].[ID]=[Payor].[ID] And [TOC].[TOC]=[Cover].[TOC] And [Acceptance].[ANO]=@P_ANO
GO


GO




ALTER FUNCTION List10_Det (@P_ANO as integer)              
RETURNS Table              
AS RETURN(              
                      
SELECT Cast(0 as bit) as ProcessFlag,              
 ACCEPTANCE.CNO,ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.ADATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, ACCEPTANCE.BACKDATEDF, AccAss.CURRENCY_OC,                 
 sum(case accass.code+accass.type              
 when 'PIT' then accass.amount_oc              
 when 'PIX' then accass.amount_oc              
 else 0 end) as Premium,              
              
 sum(case accass.code+accass.type              
 when 'UIT' then accass.amount_oc              
 when 'UIX' then accass.amount_oc              
 else 0 end) as UjrohCedant,           
               
 sum(case accass.code+accass.type              
 when 'AIT' then accass.amount_oc              
 when 'AIX' then accass.amount_oc              
 else 0 end) as Claim,              
      
 sum(case accass.code+accass.type              
 when 'RIT' then accass.amount_oc              
 when 'RIX' then accass.amount_oc              
 else 0 end) as Subrogation,              
              
 sum(case accass.code+accass.type              
 when 'CIT' then accass.amount_oc              
 when 'CIX' then accass.amount_oc              
 else 0 end) as Commission,              
              
 sum(case accass.code+accass.type              
 when 'FIT' then accass.amount_oc              
 when 'FIX' then accass.amount_oc              
 else 0 end) as Fee,              
              
 sum(case accass.code+accass.type              
 when 'TIT' then accass.amount_oc              
 when 'TIX' then accass.amount_oc              
 else 0 end) as Tax,              
              
 sum(case accass.code+accass.type              
 when 'CBO' then accass.amount_oc              
 when 'OIT' then accass.amount_oc              
 when 'OIX' then accass.amount_oc              
 else 0 end) as Other,                         
              
 sum(case accass.code+accass.type              
 when 'DIT' then accass.amount_oc              
 when 'DIX' then accass.amount_oc              
 else 0 end) as Fund,              
 Max(PCalc.TSI) as TSI,               
AccAss.Currency                
FROM ACCEPTANCE With (Index (I_ACCEPTANCE_LANO))       
Left Join AccAss with (Index (I_ACCASS_ANO)) on (AccAss.ANO=Acceptance.ANO)       
Left Join PCalc with (index(I_PCalc)) on (PCalc.ANO=Acceptance.ANO and PCalc.Currency=AccAss.Currency)         
WHERE Acceptance.LANO=@P_ANO and Acceptance.ANO<>Acceptance.LANO                 
GROUP BY ACCEPTANCE.ANO, ACCEPTANCE.CNO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.ADATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, ACCEPTANCE.BACKDATEDF, AccAss.CURRENCY_OC, AccAss.CURRENCY              



)   
        
GO


DROP PROCEDURE [dbo].[QCLACC01_1] 
GO
CREATE PROCEDURE [dbo].[QCLACC01_1] (@PCNO AS INTEGER, @PINO AS INTEGER)  
AS              
SELECT DISTINCT CAST(ICOVER.REMARK AS VARCHAR(255)) AS REMARK, ICOVER.CURRENCY,              
CASE              
 WHEN CLAIM.EVENTNO=-1 THEN              
        CASE              
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT              
        ELSE ICOVER.AMOUNT*RCOVER.PCTLOSS/100 END              
 ELSE              
        CASE              
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT_AOE              
        ELSE ICOVER.AMOUNT_AOE*RCOVER.PCTLOSS/100 END              
 END AS SI, ICOVER.INO, ICOVER.TOI, ICOVER.TOTAL, ICOVER.INDEMNITY, TOI.AGREEDVALF              
FROM ICOVER, CLAIM, Col, ICALC, RCOVER, TOI, acceptance              
WHERE CLAIM.CNO=@PCNO AND ICOVER.ANO=CLAIM.ANO AND RCOVER.ANO=CLAIM.ANO AND ACCEPTANCE.ANO=CLAIM.ANO              
AND ICALC.ANO=CLAIM.ANO AND ICOVER.INO=ICALC.INO AND RCOVER.CODE=ICALC.CODE              
AND ((RCOVER.SDATE<=CLAIM.LOSSDATE AND Acceptance.ExclusiveF=1) OR ((RCOVER.SDATE<CLAIM.LOSSDATE OR (RCOVER.SDATE=CLAIM.LOSSDATE AND '12:00'<=Claim.LossTime)) AND Acceptance.ExclusiveF=0))             
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) OR ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE OR 
(dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND '12:00'>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))              
AND COL.COL=CLAIM.COL AND ICALC.TOR=COL.TOR AND TOI.TOI=ICOVER.TOI             
AND ICOVER.INO=@PINO  
  
GO


DROP FUNCTION FN_UserBusinessSource
GO
CREATE FUNCTION FN_UserBusinessSource (@P_UserID AS VARCHAR(50))      
RETURNS TABLE      
AS RETURN(      
SELECT P.*, S1.ID AS SID, S1.Name AS SName
FROM Profile P 
LEFT JOIN SysUserAssignment S ON (S.AssType='SOURCE' AND S.PID=P.ID AND (S.ID=@P_UserID OR @P_UserID=''))
LEFT JOIN SysUser S1 ON (S1.ID=S.ID AND S1.AllowedF=1)
WHERE @P_UserID='' 
OR COALESCE(S1.ID,'')=@P_UserID
OR P.ID NOT IN (SELECT PID FROM SysUserAssignment S WHERE S.AssType='SOURCE' AND S.ID<>@P_UserID)
)    

GO


ALTER PROCEDURE CLLIST06 AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.PUserDate,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 ACCEPTANCE.ANAME,
 CLAIM.POLICYNO,
 CLAIM.CERTIFICATENO,
 CLAIM.SETTLEDF
FROM  CLAIM LEFT JOIN COLTAB ON (COLTAB.COL=CLAIM.COL) LEFT JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO), QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And (CLAIM.TBAF_1=1 Or CLAIM.TBAF_2=1)
  

go


ALTER PROCEDURE [dbo].[CLLIST02_1](@pSDate as smalldatetime,@pEDate as smalldatetime,@pBranch as varchar(10))    
AS    
SELECT Cast(0 as bit) as ProcessFlag,    
[CLAIM].[CLAIMNO],    
[CLAIM].[REGDATE],    
[CLAIM].[REFNO],    
[CLAIM].[COL],    
[COLTAB].[DESCRIPTION],    
[CLAIM].[LOSSDATE],    
[CLAIM].[TOC],    
[CLAIM].[CSDATE],    
[CLAIM].[PUSERDATE],   
[CLAIM].[LOSSPLACE],    
[CLAIM].[CTYPE],    
[CLAIM].[CSTATUS],    
[CLAIM].[CNO],    
[CLAIM].[ANO],    
[CLAIM].[PCNO],    
[CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,    
[SYSTAB].[CURRENCY],    
[CCALC].[LOSS] AS ESTIMATE,    
[CCALC].[CLAIM] AS CLAIM,    
[CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,    
[CCALC].[SALVAGE] AS SALVAGE,    
[CCALC].[COST] AS COST,    
[CCALC].[SUBROGATION] AS SUBROGATION,    
([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,    
[CLAIM].[VSEQNO],    
[CLAIM].[CSEQNO],    
acceptance.aname,    
acceptance.policyno,    
acceptance.certificateno,    
CLAIM.SETTLEDF    
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance    
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]    
And [CCALC].[CNO]=[CLAIM].[CNO]    
And [CLAIM].[CSTATUS]='A'    
And CLAIM.SETTLEDF=1    
And CLAIM.COL=COLTAB.COL    
And [CLAIM].[CSDATE] Between @pSDATE And @pEDATE    
And [Claim].[Branch] like @pBranch+'%'  
and acceptance.ano = claim.ano    

GO


ALTER PROCEDURE CLLIST01(@P_dbUser as varchar(10)) AS

SELECT  Cast(0 as bit) as ProcessFlag,

 [CLAIM].[CLAIMNO],

 [CLAIM].[REGDATE],

 [CLAIM].[REFNO],

 [CLAIM].[COL],

 [COLTAB].[DESCRIPTION],

 [CLAIM].[LOSSDATE],
 [CLAIM].[PUserDate],

 [CLAIM].[TOC],

 [CLAIM].[CSDATE],

 [CLAIM].[LOSSPLACE],

 [CLAIM].[CTYPE],

 [CLAIM].[CSTATUS],

 [CLAIM].[CNO],

 [CLAIM].[ANO],

 [CLAIM].[PCNO],

 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] AS USERID,

 [SYSTAB].[CURRENCY],

 [CCALC].[LOSS] AS ESTIMATE,

 [CCALC].[CLAIM] AS CLAIM,

 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,

 [CCALC].[SALVAGE] AS SALVAGE,

 [CCALC].[COST] AS COST,

 [CCALC].[SUBROGATION] AS SUBROGATION,

 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,

 [CLAIM].[VSEQNO],

 [CLAIM].[CSEQNO],

 ACCEPTANCE.ANAME,

 CLAIM.POLICYNO,

 CLAIM.CERTIFICATENO,

 CLAIM.SETTLEDF

FROM  CLAIM LEFT JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO), QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB

Where [CARRHEADER].[CNO] = [CLAIM].[CNO]

 And [CCALC].[CNO]=[CLAIM].[CNO]

 And CLAIM.COL=COLTAB.COL

 And [CLAIM].[CSTATUS]='R'

 AND CLAIM.LUSERID LIKE @P_DBUSER

 GO


ALTER PROCEDURE CLLIST06 AS

SELECT Cast(0 as bit) as ProcessFlag,

 CLAIM.CLAIMNO,

 CLAIM.REGDATE,

 CLAIM.REFNO,

 CLAIM.COL,

 COLTAB.DESCRIPTION,

 CLAIM.LOSSDATE,

 CLAIM.PUSERDATE,

 CLAIM.TOC,

 CLAIM.CSDATE,

 CLAIM.LOSSPLACE,

 CLAIM.CTYPE,

 CLAIM.CSTATUS,

 CLAIM.CNO,

 CLAIM.ANO,

 CLAIM.PCNO,

 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,

 SYSTAB.CURRENCY,

 CCALC.LOSS AS ESTIMATE,

 CCALC.CLAIM AS CLAIM,

 CCALC.DEDUCTIBLE AS DEDUCTIBLE,

 CCALC.SALVAGE AS SALVAGE,

 CCALC.COST AS COST,

 CCALC.SUBROGATION AS SUBROGATION,

 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,

 CLAIM.VSEQNO,

 CLAIM.CSEQNO,

 ACCEPTANCE.ANAME,

 CLAIM.POLICYNO,

 CLAIM.CERTIFICATENO,

 CLAIM.SETTLEDF

FROM  CLAIM LEFT JOIN COLTAB ON (COLTAB.COL=CLAIM.COL) LEFT JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO), QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER

Where CARRHEADER.CNO = CLAIM.CNO

 And CCALC.CNO=CLAIM.CNO

 And (CLAIM.TBAF_1=1 Or CLAIM.TBAF_2=1)

  


GO



DROP PROCEDURE [dbo].[QCLACC01_1] 
go
CREATE PROCEDURE [dbo].[QCLACC01_1] (@PCNO AS INTEGER, @PINO AS INTEGER)  
AS              
SELECT Distinct cast(ICOVER.REMARK as varchar(255)) AS REMARK, ICOVER.CURRENCY,              
CASE              
 WHEN CLAIM.EVENTNO=-1 THEN              
        CASE              
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT              
        ELSE ICOVER.AMOUNT*RCOVER.PCTLOSS/100 END              
 Else              
        CASE              
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT_AOE              
        ELSE ICOVER.AMOUNT_AOE*RCOVER.PCTLOSS/100 END              
 END AS SI, ICOVER.INO, ICOVER.TOI, ICOVER.TOTAL, ICOVER.INDEMNITY, TOI.AGREEDVALF              
From ICOVER, CLAIM, Col, ICALC, RCOVER, TOI, acceptance              
WHERE CLAIM.CNO=@PCNO AND ICOVER.ANO=CLAIM.ANO AND RCOVER.ANO=CLAIM.ANO AND ACCEPTANCE.ANO=CLAIM.ANO              
AND ICALC.ANO=CLAIM.ANO AND ICOVER.INO=ICALC.INO AND RCOVER.CODE=ICALC.CODE              
AND ((RCOVER.SDATE<=CLAIM.LOSSDATE And Acceptance.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE and '12:00'<=Claim.LossTime)) and Acceptance.ExclusiveF=0))             
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE or 
(dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND '12:00'>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))              
AND COL.COL=CLAIM.COL AND ICALC.TOR=COL.TOR AND TOI.TOI=ICOVER.TOI             
AND ICOVER.INO=@PINO  
  
go
DROP FUNCTION FN_UserBusinessSource
GO
CREATE FUNCTION FN_UserBusinessSource (@P_UserID as varchar(50))      
RETURNS TABLE      
as RETURN(      
Select P.*, S1.ID as SID, S1.Name as SName
From Profile P 
Left Join SysUserAssignment S on (S.AssType='SOURCE' and S.PID=P.ID and (S.ID=@P_UserID or @P_UserID=''))
Left join SysUser S1 on (S1.ID=S.ID and S1.AllowedF=1)
Where @P_UserID='' 
or coalesce(S1.ID,'')=@P_UserID
or P.ID not in (Select PID from SysUserAssignment S Where S.AssType='SOURCE' and S.ID<>@P_UserID)
)    

go


ALTER PROCEDURE CLLIST06 AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.PUserDate,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 ACCEPTANCE.ANAME,
 CLAIM.POLICYNO,
 CLAIM.CERTIFICATENO,
 CLAIM.SETTLEDF
FROM  CLAIM LEFT JOIN COLTAB ON (COLTAB.COL=CLAIM.COL) LEFT JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO), QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And (CLAIM.TBAF_1=1 Or CLAIM.TBAF_2=1)
  

go


ALTER PROCEDURE [dbo].[CLLIST02_1](@pSDate as smalldatetime,@pEDate as smalldatetime,@pBranch as varchar(10))    
AS    
SELECT Cast(0 as bit) as ProcessFlag,    
[CLAIM].[CLAIMNO],    
[CLAIM].[REGDATE],    
[CLAIM].[REFNO],    
[CLAIM].[COL],    
[COLTAB].[DESCRIPTION],    
[CLAIM].[LOSSDATE],    
[CLAIM].[TOC],    
[CLAIM].[CSDATE],    
[CLAIM].[PUSERDATE],   
[CLAIM].[LOSSPLACE],    
[CLAIM].[CTYPE],    
[CLAIM].[CSTATUS],    
[CLAIM].[CNO],    
[CLAIM].[ANO],    
[CLAIM].[PCNO],    
[CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,    
[SYSTAB].[CURRENCY],    
[CCALC].[LOSS] AS ESTIMATE,    
[CCALC].[CLAIM] AS CLAIM,    
[CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,    
[CCALC].[SALVAGE] AS SALVAGE,    
[CCALC].[COST] AS COST,    
[CCALC].[SUBROGATION] AS SUBROGATION,    
([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,    
[CLAIM].[VSEQNO],    
[CLAIM].[CSEQNO],    
acceptance.aname,    
acceptance.policyno,    
acceptance.certificateno,    
CLAIM.SETTLEDF    
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance    
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]    
And [CCALC].[CNO]=[CLAIM].[CNO]    
And [CLAIM].[CSTATUS]='A'    
And CLAIM.SETTLEDF=1    
And CLAIM.COL=COLTAB.COL    
And [CLAIM].[CSDATE] Between @pSDATE And @pEDATE    
And [Claim].[Branch] like @pBranch+'%'  
and acceptance.ano = claim.ano    

GO

-- Perbaikan inquiry PUserdate
DROP PROCEDURE [dbo].[CLLIST01]
GO
CREATE PROCEDURE [dbo].[CLLIST01](@P_dbUser as varchar(10)) AS

SELECT  Cast(0 as bit) as ProcessFlag,

 [CLAIM].[CLAIMNO],

 [CLAIM].[REGDATE],

 [CLAIM].[REFNO],

 [CLAIM].[COL],

 [COLTAB].[DESCRIPTION],

 [CLAIM].[LOSSDATE],
 CLAIM.puserdate,  

 [CLAIM].[TOC],

 [CLAIM].[CSDATE],

 [CLAIM].[LOSSPLACE],

 [CLAIM].[CTYPE],

 [CLAIM].[CSTATUS],

 [CLAIM].[CNO],

 [CLAIM].[ANO],

 [CLAIM].[PCNO],

 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] AS USERID,

 [SYSTAB].[CURRENCY],

 [CCALC].[LOSS] AS ESTIMATE,

 [CCALC].[CLAIM] AS CLAIM,

 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,

 [CCALC].[SALVAGE] AS SALVAGE,

 [CCALC].[COST] AS COST,

 [CCALC].[SUBROGATION] AS SUBROGATION,

 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,

 [CLAIM].[VSEQNO],

 [CLAIM].[CSEQNO],

 ACCEPTANCE.ANAME,

 CLAIM.POLICYNO,

 CLAIM.CERTIFICATENO,

 CLAIM.SETTLEDF

FROM  CLAIM LEFT JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO), QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB

Where [CARRHEADER].[CNO] = [CLAIM].[CNO]

 And [CCALC].[CNO]=[CLAIM].[CNO]

 And CLAIM.COL=COLTAB.COL

 And [CLAIM].[CSTATUS]='R'

 AND CLAIM.LUSERID LIKE @P_DBUSER




GO


DROP PROCEDURE [dbo].[CLLIST02_1]
GO
CREATE PROCEDURE [dbo].[CLLIST02_1](@pSDate as smalldatetime,@pEDate as smalldatetime,@pBranch as varchar(10))    
AS    
SELECT Cast(0 as bit) as ProcessFlag,    
[CLAIM].[CLAIMNO],    
[CLAIM].[REGDATE],    
[CLAIM].[REFNO],    
[CLAIM].[COL],    
[COLTAB].[DESCRIPTION],    
[CLAIM].[LOSSDATE],    
[CLAIM].[TOC],    
[CLAIM].[CSDATE],    
[CLAIM].[PUSERDATE],   
[CLAIM].[LOSSPLACE],    
[CLAIM].[CTYPE],    
[CLAIM].[CSTATUS],    
[CLAIM].[CNO],    
[CLAIM].[ANO],    
[CLAIM].[PCNO],    
[CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,    
[SYSTAB].[CURRENCY],    
[CCALC].[LOSS] AS ESTIMATE,    
[CCALC].[CLAIM] AS CLAIM,    
[CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,    
[CCALC].[SALVAGE] AS SALVAGE,    
[CCALC].[COST] AS COST,    
[CCALC].[SUBROGATION] AS SUBROGATION,    
([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,    
[CLAIM].[VSEQNO],    
[CLAIM].[CSEQNO],    
acceptance.aname,    
acceptance.policyno,    
acceptance.certificateno,    
CLAIM.SETTLEDF    
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance    
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]    
And [CCALC].[CNO]=[CLAIM].[CNO]    
And [CLAIM].[CSTATUS]='A'    
And CLAIM.SETTLEDF=1    
And CLAIM.COL=COLTAB.COL    
And [CLAIM].[CSDATE] Between @pSDATE And @pEDATE    
And [Claim].[Branch] like @pBranch+'%'  
and acceptance.ano = claim.ano    






GO





DROP PROCEDURE [dbo].[CLLIST02]
GO
CREATE PROCEDURE [dbo].[CLLIST02](@pSDate as smalldatetime,@pEDate as smalldatetime)
AS
SELECT Cast(0 as bit) as ProcessFlag,
 [CLAIM].[CLAIMNO],
 [CLAIM].[REGDATE],
 [CLAIM].[REFNO],
 [CLAIM].[COL],
 [COLTAB].[DESCRIPTION],
 [CLAIM].[LOSSDATE],
 [CLAIM].[TOC],
 [CLAIM].[CSDATE],
 [CLAIM].[PUSERDATE],

 [CLAIM].[LOSSPLACE],
 [CLAIM].[CTYPE],
 [CLAIM].[CSTATUS],
 [CLAIM].[CNO],
 [CLAIM].[ANO],
 [CLAIM].[PCNO],
 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,
 [SYSTAB].[CURRENCY],
 [CCALC].[LOSS] AS ESTIMATE,
 [CCALC].[CLAIM] AS CLAIM,
 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,
 [CCALC].[SALVAGE] AS SALVAGE,
 [CCALC].[COST] AS COST,
 [CCALC].[SUBROGATION] AS SUBROGATION,
 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,
 [CLAIM].[VSEQNO],
 [CLAIM].[CSEQNO],
 acceptance.aname,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]
 And [CCALC].[CNO]=[CLAIM].[CNO]
 And [CLAIM].[CSTATUS]='A'
 And CLAIM.SETTLEDF=1
 And CLAIM.COL=COLTAB.COL
 And [CLAIM].[CSDATE] Between @pSDATE And @pEDATE
 and acceptance.ano = claim.ano




GO



DROP PROCEDURE [dbo].[CLLIST03]
GO


CREATE PROCEDURE [dbo].[CLLIST03] AS

SELECT Cast(0 as bit) as ProcessFlag,

 [CLAIM].[CLAIMNO],

 [CLAIM].[REGDATE],

 [CLAIM].[REFNO],

 [CLAIM].[COL],

 [COLTAB].[DESCRIPTION],

 [CLAIM].[LOSSDATE],
  [CLAIM].[PuserDATE],

 [CLAIM].[TOC],

 [CLAIM].[CSDATE],

 [CLAIM].[LOSSPLACE],

 [CLAIM].[CTYPE],

 [CLAIM].[CSTATUS],

 [CLAIM].[CNO],

 [CLAIM].[ANO],

 [CLAIM].[PCNO],

 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,

 [SYSTAB].[CURRENCY],

 [CCALC].[LOSS] AS ESTIMATE,

 [CCALC].[CLAIM] AS CLAIM,

 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,

 [CCALC].[SALVAGE] AS SALVAGE,

 [CCALC].[COST] AS COST,

 [CCALC].[SUBROGATION] AS SUBROGATION,

 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,

 [CLAIM].[VSEQNO],

 [CLAIM].[CSEQNO],

 acceptance.aname,

 acceptance.policyno,

 acceptance.certificateno,

 CLAIM.SETTLEDF

FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance

Where [CARRHEADER].[CNO] = [CLAIM].[CNO]

 And [CCALC].[CNO]=[CLAIM].[CNO]

 And CLAIM.COL=COLTAB.COL

 And [CLAIM].[CSTATUS]='T'

 and acceptance.ano=claim.ano







GO


DROP PROCEDURE [dbo].[CLLIST04]
GO


CREATE PROCEDURE [dbo].[CLLIST04](@P_DBUSER AS VARCHAR(10)) AS

SELECT Cast(0 as bit) as ProcessFlag,

 [CLAIM].[CLAIMNO],

 [CLAIM].[REGDATE],

 [CLAIM].[REFNO],

 [CLAIM].[COL],

 [COLTAB].[DESCRIPTION],

 [CLAIM].[LOSSDATE],

 [CLAIM].[TOC],

 [CLAIM].[CSDATE],
  CLAIM.puserdate,  

 [CLAIM].[LOSSPLACE],

 [CLAIM].[CTYPE],

 [CLAIM].[CSTATUS],

 [CLAIM].[CNO],

 [CLAIM].[ANO],

 [CLAIM].[PCNO],

 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,

 [SYSTAB].[CURRENCY],

 [CCALC].[LOSS] AS ESTIMATE,

 [CCALC].[CLAIM] AS CLAIM,

 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,

 [CCALC].[SALVAGE] AS SALVAGE,

 [CCALC].[COST] AS COST,

 [CCALC].[SUBROGATION] AS SUBROGATION,

 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,

 [CLAIM].[VSEQNO],

 [CLAIM].[CSEQNO],

 ACCEPTANCE.ANAME,

 CLAIM.POLICYNO,

 CLAIM.CERTIFICATENO,

 CLAIM.SETTLEDF

FROM  CLAIM LEFT JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO), QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB

Where [CARRHEADER].[CNO] = [CLAIM].[CNO]

 And [CCALC].[CNO]=[CLAIM].[CNO]

 And CLAIM.COL=COLTAB.COL

 And [CLAIM].[CSTATUS]='P'

 AND CLAIM.LUSERID LIKE @P_DBUSER





GO






DROP PROCEDURE [dbo].[CLLIST05]
GO

CREATE PROCEDURE [dbo].[CLLIST05] AS

SELECT Cast(0 as bit) as ProcessFlag,

 CLAIM.CLAIMNO,

 CLAIM.REGDATE,

 CLAIM.REFNO,

 CLAIM.COL,

 COLTAB.DESCRIPTION,

 CLAIM.LOSSDATE,

 CLAIM.TOC,

 CLAIM.CSDATE,
  [CLAIM].[PuserDATE],

 CLAIM.LOSSPLACE,

 CLAIM.CTYPE,

 CLAIM.CSTATUS,

 CLAIM.CNO,

 CLAIM.ANO,

 CLAIM.PCNO,

 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,

 SYSTAB.CURRENCY,

 CCALC.LOSS AS ESTIMATE,

 CCALC.CLAIM AS CLAIM,

 CCALC.DEDUCTIBLE AS DEDUCTIBLE,

 CCALC.SALVAGE AS SALVAGE,

 CCALC.COST AS COST,

 CCALC.SUBROGATION AS SUBROGATION,

 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,

 CLAIM.VSEQNO,

 CLAIM.CSEQNO,

 acceptance.aname,

 acceptance.policyno,

 acceptance.certificateno,

 CLAIM.SETTLEDF

FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance

Where CARRHEADER.CNO = CLAIM.CNO

 And CCALC.CNO=CLAIM.CNO

 And CLAIM.COL=COLTAB.COL

 And acceptance.ano=claim.ano

 And CLAIM.REGDATE<=getdate() AND CLAIM.CTYPE<>'C' AND CLAIM.CSTATUS<>'R' AND

 ((CLAIM.SETTLEDF=0 AND CLAIM.CSDATE<=getdate() AND CLAIM.CSTATUS<>'C') OR

              (CLAIM.PSETTLEDF=0 AND CLAIM.CSDATE>getdate() AND (CLAIM.SETTLEDF=0 OR CLAIM.ADATE>getdate())))

  



GO



DROP PROCEDURE [dbo].[CLLIST06]
GO

CREATE PROCEDURE [dbo].[CLLIST06] AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 ACCEPTANCE.ANAME,
 CLAIM.POLICYNO,
 CLAIM.CERTIFICATENO,
 CLAIM.SETTLEDF
FROM  CLAIM LEFT JOIN COLTAB ON (COLTAB.COL=CLAIM.COL) LEFT JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO), QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And (CLAIM.TBAF_1=1 Or CLAIM.TBAF_2=1)
  


GO



DROP PROCEDURE [dbo].[CLLIST07]
GO

CREATE PROCEDURE [dbo].[CLLIST07] (@P_EVENTNO AS VARCHAR(255),@P_RYEAR AS INTEGER)
AS
SELECT Cast(0 as bit) as ProcessFlag,
 [CLAIM].[CLAIMNO],
  [CLAIM].[REGDATE],
  [CLAIM].[REFNO],
  [CLAIM].[COL],
  [COLTAB].[DESCRIPTION],
  [CLAIM].[LOSSDATE],
  [CLAIM].[TOC],
  [CLAIM].[CSDATE],
    [CLAIM].[PUSERDATE],
  [CLAIM].[LOSSPLACE],
  [CLAIM].[CTYPE],
  [CLAIM].[CSTATUS],
  [CLAIM].[CNO],
  [CLAIM].[ANO],
  [CLAIM].[PCNO],
  [CLAIM].[LUSERID] + '/' + CLAIM.AUSERID as USERID,
  [SYSTAB].[CURRENCY],
  [CCALC].[LOSS] AS ESTIMATE,
  [CCALC].[CLAIM] AS CLAIM,
  [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,
  [CCALC].[SALVAGE] AS SALVAGE,
  [CCALC].[COST] AS COST,
  [CCALC].[SUBROGATION] AS SUBROGATION,
  ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,
  [CLAIM].[VSEQNO],
  [CLAIM].[CSEQNO],
  acceptance.aname,
  acceptance.policyno,
  acceptance.certificateno,
  CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]
  And [CCALC].[CNO]=[CLAIM].[CNO]
  And CLAIM.COL=COLTAB.COL
  And [CLAIM].[EVENTNO]=@P_EVENTNO
  And YEAR([CARRHEADER].[RDATE])=@P_RYEAR
  And [CARRHEADER].[STATUS]='A'
  and acceptance.ano = claim.ano
  



GO



DROP PROCEDURE [dbo].[CLLIST08]
GO

CREATE PROCEDURE [dbo].[CLLIST08] AS

SELECT Cast(0 as bit) as ProcessFlag,

 [CLAIM].[CLAIMNO],

 [CLAIM].[REGDATE],

 [CLAIM].[REFNO],

 [CLAIM].[COL],

 [COLTAB].[DESCRIPTION],

 [CLAIM].[LOSSDATE],

 [CLAIM].[TOC],

 [CLAIM].[CSDATE],
  [CLAIM].[PuserDATE],

 [CLAIM].[LOSSPLACE],

 [CLAIM].[CTYPE],

 [CLAIM].[CSTATUS],

 [CLAIM].[CNO],

 [CLAIM].[ANO],

 [CLAIM].[PCNO],

 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,

 [SYSTAB].[CURRENCY],

 [CCALC].[LOSS] AS ESTIMATE,

 [CCALC].[CLAIM] AS CLAIM,

 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,

 [CCALC].[SALVAGE] AS SALVAGE,

 [CCALC].[COST] AS COST,

 [CCALC].[SUBROGATION] AS SUBROGATION,

 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,

 [CLAIM].[VSEQNO],

 [CLAIM].[CSEQNO],

 acceptance.aname,

 acceptance.policyno,

 acceptance.certificateno,

 CLAIM.SETTLEDF

FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance

Where [CARRHEADER].[CNO] = [CLAIM].[CNO]

 And [CCALC].[CNO]=[CLAIM].[CNO]

 And CLAIM.COL=COLTAB.COL

 And [CLAIM].[CSTATUS]='A'

 And Claim.Settledf=0

 and acceptance.ano = claim.ano





GO



DROP PROCEDURE [dbo].[CLLIST09]
GO

CREATE PROCEDURE [dbo].[CLLIST09] AS
SELECT Cast(0 as bit) as ProcessFlag,
 [CLAIM].[CLAIMNO],
 [CLAIM].[REGDATE],
 [CLAIM].[REFNO],
 [CLAIM].[COL],
 [COLTAB].[DESCRIPTION],
 [CLAIM].[LOSSDATE],
 [CLAIM].[TOC],
 [CLAIM].[CSDATE],
  [CLAIM].[PUSERDATE],
 [CLAIM].[LOSSPLACE],
 [CLAIM].[CTYPE],
 [CLAIM].[CSTATUS],
 [CLAIM].[CNO],
 [CLAIM].[ANO],
 [CLAIM].[PCNO],
 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,
 [SYSTAB].[CURRENCY],
 [CCALC].[LOSS] AS ESTIMATE,
 [CCALC].[CLAIM] AS CLAIM,
 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,
 [CCALC].[SALVAGE] AS SALVAGE,
 [CCALC].[COST] AS COST,
 [CCALC].[SUBROGATION] AS SUBROGATION,
 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,
 [CLAIM].[VSEQNO],
 [CLAIM].[CSEQNO],
 acceptance.aname,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]
 And [CCALC].[CNO]=[CLAIM].[CNO]
 And CLAIM.COL=COLTAB.COL
 And [CLAIM].[CSTATUS]='P'
 And [CLAIM].[VSEQNO]<>0
 and acceptance.ano = claim.ano
  



GO



DROP PROCEDURE [dbo].[CLLIST10]
GO

CREATE PROCEDURE [dbo].[CLLIST10] AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.PUSERDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 acceptance.aname,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And CLAIM.COL=COLTAB.COL
 And CLAIM.CSTATUS='P'
 And CLAIM.CSEQNO<>0
 and acceptance.ano=claim.ano




GO



DROP PROCEDURE [dbo].[CLLIST11]
GO

CREATE PROCEDURE [dbo].[CLLIST11] AS    

SELECT Cast(0 as bit) as ProcessFlag,    

 [CLAIM].[CLAIMNO],    

 [CLAIM].[REGDATE],    

 [CLAIM].[REFNO],    

 [CLAIM].[COL],    

 [COLTAB].[DESCRIPTION],    

 [CLAIM].[LOSSDATE],    

 [CLAIM].[TOC],    

 [CLAIM].[CSDATE],   
  [CLAIM].[PuserDATE],

 [CLAIM].[LOSSPLACE],    

 [CLAIM].[CTYPE],    

 [CLAIM].[CSTATUS],    

 [CLAIM].[CNO],    

 [CLAIM].[ANO],    

 [CLAIM].[PCNO],    

 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,    

 [SYSTAB].[CURRENCY],    

 [CCALC].[LOSS] AS ESTIMATE,    

 [CCALC].[CLAIM] AS CLAIM,    

 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,    

 [CCALC].[SALVAGE] AS SALVAGE,    

 [CCALC].[COST] AS COST,    

 [CCALC].[SUBROGATION] AS SUBROGATION, ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,    

 [CLAIM].[VSEQNO],    

 [CLAIM].[CSEQNO],    

 acceptance.aname,    

 acceptance.policyno,    

 acceptance.certificateno,    

 CLAIM.SETTLEDF    

FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER, CLAIM AS C1,COLTAB,acceptance    

Where [CARRHEADER].[CNO] = [CLAIM].[CNO]    

 And [CCALC].[CNO]=[CLAIM].[CNO]    

 And CLAIM.COL=COLTAB.COL    

 And [CLAIM].[CNO]=C1.PCNO    

 And C1.CSTATUS='P'    

 And C1.VSEQNO<>0    

 and acceptance.ano=claim.ano    



GO



DROP PROCEDURE [dbo].[CLLIST12]
GO

CREATE PROCEDURE [dbo].[CLLIST12] AS

SELECT Cast(0 as bit) as ProcessFlag,

 CLAIM.CLAIMNO,

 CLAIM.REGDATE,

 CLAIM.REFNO,

 CLAIM.COL,

 COLTAB.DESCRIPTION,

 CLAIM.LOSSDATE,

 CLAIM.TOC,

 CLAIM.CSDATE,
  [CLAIM].[PuserDATE],

 CLAIM.LOSSPLACE,

 CLAIM.CTYPE,

 CLAIM.CSTATUS,

 CLAIM.CNO,

 CLAIM.ANO,

 CLAIM.PCNO,

 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,

 SYSTAB.CURRENCY,

 CCALC.LOSS AS ESTIMATE,

 CCALC.CLAIM AS CLAIM,

 CCALC.DEDUCTIBLE AS DEDUCTIBLE,

 CCALC.SALVAGE AS SALVAGE,

 CCALC.COST AS COST,

 CCALC.SUBROGATION AS SUBROGATION,

 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,

 CLAIM.VSEQNO,

 CLAIM.CSEQNO,

 acceptance.aname,

 acceptance.policyno,

 acceptance.certificateno,

 CLAIM.SETTLEDF

FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER, CLAIM AS C1,COLTAB,acceptance

Where CARRHEADER.CNO = CLAIM.CNO

 And CCALC.CNO=CLAIM.CNO

 And CLAIM.COL=COLTAB.COL

 And CLAIM.CNO=C1.PCNO

 And C1.CSTATUS='P'

 And C1.CSEQNO<>0

 and acceptance.ano = claim.ano





GO



DROP PROCEDURE [dbo].[CLLIST15]
GO

CREATE PROCEDURE [dbo].[CLLIST15] AS

SELECT Cast(0 as bit) as ProcessFlag,

 [CLAIM].[CLAIMNO],

 [CLAIM].[REGDATE],

 [CLAIM].[REFNO],

 [CLAIM].[COL],

 [COLTAB].[DESCRIPTION],

 [CLAIM].[LOSSDATE],

 [CLAIM].[TOC],

 [CLAIM].[CSDATE],
 [CLAIM].[PuserDATE],
 [CLAIM].[LOSSPLACE],

 [CLAIM].[CTYPE],

 [CLAIM].[CSTATUS],

 [CLAIM].[CNO],

 [CLAIM].[ANO],

 [CLAIM].[PCNO],

 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,

 [SYSTAB].[CURRENCY],

 [CCALC].[LOSS] AS ESTIMATE,

 [CCALC].[CLAIM] AS CLAIM,

 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,

 [CCALC].[SALVAGE] AS SALVAGE,

 [CCALC].[COST] AS COST,

 [CCALC].[SUBROGATION] AS SUBROGATION,

 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,

 [CLAIM].[VSEQNO],

 [CLAIM].[CSEQNO],

 acceptance.aname,

 acceptance.policyno,

 acceptance.certificateno,

 CLAIM.SETTLEDF

FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance

Where [CARRHEADER].[CNO] = [CLAIM].[CNO]

 And [CCALC].[CNO]=[CLAIM].[CNO]

 And CLAIM.COL=COLTAB.COL

 And Acceptance.ANO=Claim.ANO

 And CLAIM.CNO  in

  

(Select CLLOSS.CNO  from CLLOSS, ICOVER, DOCLIST Where

 ICOVER.INO=CLLOSS.INO and CLLOSS.CNO=CLAIM.CNO and DOCLIST.NOC=CLLOSS.NOC and DOCLIST.TOI=ICOVER.TOI and DOCLIST.DOCTYPE Not in

 (Select DocType from CDOCLIST Where CDOCLIST.CNO=CLAIM.CNO and CDOCLIST.INO=CLLOSS.INO and CDOCLIST.NOC=CLLOSS.NOC and CDOCLIST.DOCTYPE=DOCLIST.DOCTYPE))

  



GO


DROP PROCEDURE [dbo].[CLLIST16]
GO

CREATE PROCEDURE [dbo].[CLLIST16] AS

SELECT Cast(0 as bit) as ProcessFlag,

 [CLAIM].[CLAIMNO],

 [CLAIM].[REGDATE],

 [CLAIM].[REFNO],

 [CLAIM].[COL],

 [COLTAB].[DESCRIPTION],

 [CLAIM].[LOSSDATE],

 [CLAIM].[TOC],

 [CLAIM].[CSDATE],
  [CLAIM].[PuserDATE],

 [CLAIM].[LOSSPLACE],

 [CLAIM].[CTYPE],

 [CLAIM].[CSTATUS],

 [CLAIM].[CNO],

 [CLAIM].[ANO],

 [CLAIM].[PCNO],

 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,

 [SYSTAB].[CURRENCY],

 [CCALC].[LOSS] AS ESTIMATE,

 [CCALC].[CLAIM] AS CLAIM,

 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,

 [CCALC].[SALVAGE] AS SALVAGE,

 [CCALC].[COST] AS COST,

 [CCALC].[SUBROGATION] AS SUBROGATION,

 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,

 [CLAIM].[VSEQNO],

 [CLAIM].[CSEQNO],

 acceptance.aname,

 acceptance.policyno,

 acceptance.certificateno,

 CLAIM.SETTLEDF

FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance

Where [CARRHEADER].[CNO] = [CLAIM].[CNO]

 And [CCALC].[CNO]=[CLAIM].[CNO]

 And CLAIM.COL=COLTAB.COL

 And [CLAIM].[REQUESTF]=1

 and acceptance.ano=claim.ano

  



GO




DROP PROCEDURE [dbo].[CLLIST17]
GO


CREATE PROCEDURE [dbo].[CLLIST17] (@P_USERID as varchar(255),@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_CStatus as varchar(1))     

AS    

SELECT Cast(0 as bit) as ProcessFlag,    

[CLAIM].[CLAIMNO],    

[CLAIM].[REGDATE],    

[CLAIM].[REFNO],    

[CLAIM].[COL],    

[COLTAB].[DESCRIPTION],    

[CLAIM].[LOSSDATE],    

[CLAIM].[TOC],    

[CLAIM].[CSDATE],    

[CLAIM].[PUSERDATE],    

[CLAIM].[LOSSPLACE],    

[CLAIM].[CTYPE],    

[CLAIM].[CSTATUS],    

[CLAIM].[CNO],    

[CLAIM].[ANO],    

[CLAIM].[PCNO],    

[CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,    

[SYSTAB].[CURRENCY],    

[CCALC].[LOSS] AS ESTIMATE,    

[CCALC].[CLAIM] AS CLAIM,    

[CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,    

[CCALC].[SALVAGE] AS SALVAGE,    

[CCALC].[COST] AS COST,    

[CCALC].[SUBROGATION] AS SUBROGATION,    

([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,    

[CLAIM].[VSEQNO],    

[CLAIM].[CSEQNO],    

acceptance.aname,    

acceptance.policyno,    

acceptance.certificateno,    

CLAIM.SETTLEDF    

FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance    

Where [CARRHEADER].[CNO] = [CLAIM].[CNO]    

And [CCALC].[CNO]=[CLAIM].[CNO]    

And CLAIM.COL=COLTAB.COL    

And Acceptance.ANO=Claim.ANO  

And Claim.LUserID Like @P_UserID      

And Claim.LDate Between @P_SDate and @P_EDate

And (Claim.CStatus=@P_CStatus or @P_CStatus='')


GO



DROP PROCEDURE [dbo].[CLLISTSR]
GO

CREATE PROCEDURE [dbo].[CLLISTSR](@P_ID as int)  

AS  

SELECT  Cast(0 as bit) as ProcessFlag,  

 CLAIM.CLAIMNO,  

 CLAIM.REGDATE,  

 CLAIM.REFNO,  

 CLAIM.COL,  

 COLTAB.DESCRIPTION,  

 CLAIM.LOSSDATE,  

 CLAIM.TOC,  

 CLAIM.CSDATE,  
  [CLAIM].[PuserDATE],

 CLAIM.LOSSPLACE,  

 CLAIM.CTYPE,  

 CLAIM.CSTATUS,  

 CLAIM.CNO,  

 CLAIM.ANO,  

 CLAIM.PCNO,  

 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,  

 SYSTAB.CURRENCY,  

 CCALC.LOSS AS ESTIMATE,  

 CCALC.CLAIM AS CLAIM,  

 CCALC.DEDUCTIBLE AS DEDUCTIBLE,  

 CCALC.SALVAGE AS SALVAGE,  

 CCALC.COST AS COST,  

 CCALC.SUBROGATION AS SUBROGATION,  

 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,  

 CLAIM.VSEQNO,  

 CLAIM.CSEQNO,  

 acceptance.aname,  

 Claim.policyno,  

 Claim.certificateno,  

 CLAIM.SETTLEDF  

FROM  CLAIM Left Join CArrHeader on (CarrHeader.CNO=Claim.CNO)  

Left Join QClaim_CCalc() as CCalc on (CCalc.CNO=Claim.CNO)  

Left Join Acceptance on (Acceptance.ANO=Claim.ANO)  

inner join COLTAB on (COLTAB.COL=CLAIM.COL)  

, SYSTAB, SysRequest  

WHERE SysRequest.ID=@P_ID  

 And SysRequest.Param2 in ('MAR','UND','CLM')  

 And ((SysRequest.Param4=Claim.CNO and SysRequest.Param2='CLM') or (SysRequest.Param3=Claim.ANO and SysRequest.Param2 in ('MAR','UND')))  

    

GO




--25 November 2015

DROP PROCEDURE CLVIEW06B
GO
CREATE PROCEDURE CLVIEW06B (@P_CNO AS INTEGER)       
AS      
SELECT C.*, C.TAmount as OurShare, C.ETAmount as Estimate, 
R.CID, R.QID, R.DID, R.XPID, R.SP1ID, R.SP2ID, R.SP3ID, R.AID, R.PCTShare, 
CASE WHEN CLAIM.PSTATUS='C' and (C.CAMOUNT<>0 OR C.ECAMOUNT<>0) THEN R.CSHARE ELSE 0 end as CSHARE,    
CASE WHEN CLAIM.PSTATUS='C' and (C.DAMOUNT<>0 OR C.EDAMOUNT<>0) THEN R.DSHARE ELSE 0 end as DSHARE,    
CASE WHEN CLAIM.PSTATUS='C' and (C.QAMOUNT<>0 OR C.EQAMOUNT<>0) THEN R.QSHARE ELSE 0 end as QSHARE,    
CASE WHEN CLAIM.PSTATUS='C' and (C.XPAMOUNT<>0 OR C.EXPAMOUNT<>0) THEN R.XPSHARE ELSE 0 end as XPSHARE,    
CASE WHEN CLAIM.PSTATUS='C' and (C.SP1AMOUNT<>0 OR C.ESP1AMOUNT<>0) THEN R.SP1SHARE ELSE 0 end as SP1SHARE,    
CASE WHEN CLAIM.PSTATUS='C' and (C.SP2AMOUNT<>0 OR C.ESP2AMOUNT<>0) THEN R.SP2SHARE ELSE 0 end as SP2SHARE,    
CASE WHEN CLAIM.PSTATUS='C' and (C.SP3AMOUNT<>0 OR C.ESP3AMOUNT<>0) THEN R.SP3SHARE ELSE 0 end as SP3SHARE,    
CASE WHEN CLAIM.PSTATUS='C' and (C.AAMOUNT<>0 OR C.EAAMOUNT<>0) THEN R.ASHARE ELSE 0 end as ASHARE,    
CASE WHEN CLAIM.PSTATUS='C' and (C.FAMOUNT<>0 OR C.EFAMOUNT<>0) THEN CASE WHEN C.FAMOUNT<>0 THEN C.FAMOUNT/C.TAMOUNT*100 ELSE C.EFAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS FSHARE
FROM RARRHEADER R, CARRHEADER C, CLAIM    
WHERE CLAIM.CNO=@P_CNO and C.CNO=CLAIM.CNO and R.ANO=CLAIM.ANO    
      
      
GO


--26 November 2015


DROP PROCEDURE List05 
GO
       
CREATE PROCEDURE List05 (@P_UserID as varchar(50), @pSDate as smallDateTime, @pEDate as smallDateTime, @pBranch as varchar(10), @pTOC as varchar(10), @pMO as varchar(10))    
AS    
SELECT Cast(0 as bit) as ProcessFlag,     
 Cover.COVERNO,    
 Cast(Acceptance.AName as varchar(128)) as Insured,    
 Cover.CNO,    
 Cover.CStatus,    
 Acceptance.lANO,    
 Acceptance.ANO,    
 Acceptance.REGNO,    
 Acceptance.ADATE,    
 Acceptance.LUSERID as USERID,    
 SysTab.Currency,    
 QPCalc.TSI,    
 QPCalc.OurShare,    
 QPCalc.Gross,    
 Acceptance.ASTATUS,    
 Acceptance.ATYPE,    
 Acceptance.SDate,    
 Acceptance.EDate,    
 Year(Acceptance.SDate) AS RYear,    
 Cover.ISType,    
 Acceptance.Renewal,    
 Acceptance.ESeqNo,    
 Acceptance.PolicyNo,    
 acceptance.CertificateNo    
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader
Where cover.CNO = acceptance.CNO    
 And QPCalc.ANO=Acceptance.ANO    
 And RArrHeader.ANO=Acceptance.ANO    
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)    
 And Cover.CStatus<>'C'    
 And Acceptance.AStatus='I' and Acceptance.AType not in ('A','C')    
 And Acceptance.EDate between @PSDate and @PEDate    
 And Acceptance.RenewableF=1    
 And Cover.ISType in ('I','C','L')    
 And Acceptance.Branch like @pBranch+'%'  
 And Cover.TOC Like @pTOC+'%'    
 And Cover.MO like @pMO+'%'  
 And not Exists (SELECT ANO from Claim, CLLOSS Where CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 and Claim.ANO=Acceptance.ANO)    
 and Exists (Select S1.ID from SysUser S1 Left Join SysUserBranch S2 on (S2.ID=S1.ID and S2.AllowedF=1 and S2.Branch=Acceptance.Branch) Where S1.ID=@P_UserID and (coalesce(S2.Branch,'')<>'' or S1.Type='SUPERVISOR'))    
 
Union    
          
SELECT Cast(0 as bit) as ProcessFlag,     
 Cover.COVERNO,    
 Cast(Acceptance.AName as varchar(128)) as Insured,    
 Cover.CNO,    
 Cover.CStatus,    
 Acceptance.lANO,    
 Acceptance.ANO,    
 Acceptance.REGNO,    
 Acceptance.ADATE,    
 Acceptance.LUSERID as USERID,    
 SysTab.Currency,    
 QPCalc.TSI,    
 QPCalc.OurShare,    
 QPCalc.Gross,    
 Acceptance.ASTATUS,    
 Acceptance.ATYPE,    
 Acceptance.SDate,    
 Acceptance.EDate,    
 Year(Acceptance.SDate) AS RYear,    
 Cover.ISType,    
 Acceptance.Renewal,    
 Acceptance.ESeqNo,    
 Acceptance.PolicyNo,    
 acceptance.CertificateNo    
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader, Acceptance As Acceptance_Detail    
Where cover.CNO = acceptance.CNO    
 And QPCalc.ANO=Acceptance.ANO    
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO    
 And RArrHeader.ANO=Acceptance_Detail.ANO    
 And Cover.CStatus<>'C'    
 And Acceptance_Detail.AStatus='I' and Acceptance_Detail.AType not in ('A','C')    
 And Acceptance_Detail.EDate between @PSDate and @PEDate    
 And Acceptance_Detail.RenewableF=1    
 And Cover.ISType in ('I','C','L')    
 And Acceptance_Detail.Branch like @pBranch+'%'  
 And Cover.TOC Like @pTOC+'%'    
 And Cover.MO like @pMO+'%'  
 And not exists  (SELECT ANO from Claim, CLLOSS Where CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 and Claim.ANO=Acceptance_Detail.ANO)    
 and Exists (Select S1.ID from SysUser S1 Left Join SysUserBranch S2 on (S2.ID=S1.ID and S2.AllowedF=1 and S2.Branch=Acceptance_Detail.Branch) Where S1.ID=@P_UserID and (coalesce(S2.Branch,'')<>'' or S1.Type='SUPERVISOR'))    
       
    
GO



DROP PROCEDURE List06     
GO
    
CREATE PROCEDURE List06 (@P_UserID as varchar(50), @pSDate as smalldateTime, @pEDate as smallDateTime, @pBranch as varchar(10), @pTOC as varchar(10), @pMO as varchar(10))    
AS    
SELECT Cast(0 as bit) as ProcessFlag,     
 Cover.COVERNO,    
 Cast(Acceptance.AName as varchar(128)) as Insured,    
 Cover.CNO,    
 Cover.CStatus,    
 Acceptance.lANO,    
 Acceptance.ANO,    
 Acceptance.REGNO,    
 Acceptance.ADATE,    
 Acceptance.LUSERID as USERID,    
 SysTab.Currency,    
 QPCalc.TSI,    
 QPCalc.OurShare,    
 QPCalc.Gross,    
 Acceptance.ASTATUS,    
 Acceptance.ATYPE,    
 Acceptance.SDate,    
 Acceptance.EDate,    
 Year(Acceptance.SDate) AS RYear,    
 Cover.ISType,    
 Acceptance.Renewal,    
 Acceptance.ESeqNo,    
 Acceptance.PolicyNo,    
 acceptance.CertificateNo    
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc    
Where cover.CNO = acceptance.CNO    
 And QPCalc.ANO=Acceptance.ANO    
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)    
 And Acceptance.AStatus='I'    
 And Acceptance.AType<>'C'    
 And Cover.ISType<>'T'    
 And Acceptance.Branch like @pBranch+'%'  
 And Cover.TOC Like @pTOC+'%'    
 And Cover.MO like @pMO+'%'  
 And Acceptance.EDate between @pSDate and @pEDate    
 and Exists (Select S1.ID from SysUser S1 Left Join SysUserBranch S2 on (S2.ID=S1.ID and S2.AllowedF=1 and S2.Branch=Acceptance.Branch) Where S1.ID=@P_UserID and (coalesce(S2.Branch,'')<>'' or S1.Type='SUPERVISOR'))    
      
Union    
    
SELECT Cast(0 as bit) as ProcessFlag,     
 Cover.COVERNO,    
 Cast(Acceptance.AName as varchar(128)) as Insured,    
 Cover.CNO,    
 Cover.CStatus,    
 Acceptance.lANO,    
 Acceptance.ANO,    
 Acceptance.REGNO,    
 Acceptance.ADATE,    
 Acceptance.LUSERID as USERID,    
 SysTab.Currency,    
 QPCalc.TSI,    
 QPCalc.OurShare,    
 QPCalc.Gross,    
 Acceptance.ASTATUS,    
 Acceptance.ATYPE,    
 Acceptance.SDate,    
 Acceptance.EDate,    
 Year(Acceptance.SDate) AS RYear,    
 Cover.ISType,    
 Acceptance.Renewal,    
 Acceptance.ESeqNo,    
 Acceptance.PolicyNo,    
 acceptance.CertificateNo    
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, Acceptance As Acceptance_Detail    
Where cover.CNO = acceptance.CNO    
 And QPCalc.ANO=Acceptance.ANO    
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)    
 And Acceptance.ANO=Acceptance_Detail.LANO And Acceptance_Detail.LANO<>Acceptance_Detail.ANO    
 And Acceptance_Detail.AStatus='I'    
 And Acceptance_Detail.AType<>'C'    
 And Cover.ISType<>'T'    
 And Acceptance_Detail.Branch like @pBranch+'%'  
 And Cover.TOC Like @pTOC+'%'    
 And Cover.MO like @pMO+'%'   
 And Acceptance_Detail.EDate between @pSDate and @pEDate    
 and Exists (Select S1.ID from SysUser S1 Left Join SysUserBranch S2 on (S2.ID=S1.ID and S2.AllowedF=1 and S2.Branch=Acceptance_Detail.Branch) Where S1.ID=@P_UserID and (coalesce(S2.Branch,'')<>'' or S1.Type='SUPERVISOR'))          
 
 
 GO
 
DROP FUNCTION List05_Det 
GO   
CREATE FUNCTION List05_Det (@P_ANO as integer, @P_UserID as varchar(50), @pSDate as smallDateTime, @pEDate as smallDateTime, @pBranch as varchar(10), @pTOC as varchar(10), @pMO as varchar(10))    
RETURNS Table    
AS RETURN(    
SELECT Cast(0 as bit) as ProcessFlag,    
 Acceptance.CertificateNo,    
 Acceptance.ESeqNo,    
 Acceptance.AName,    
 Acceptance.ANO,    
 Acceptance.REGNO,    
 Acceptance.ADATE,    
 Acceptance.LUSERID as UserID,    
 SysTab.Currency,    
 QPCalc.TSI,    
 QPCalc.OurShare,    
 QPCalc.Gross,    
 Acceptance.ASTATUS,    
 Acceptance.ATYPE,    
 Acceptance.SDate,    
 Acceptance.EDate,    
 Year(Acceptance.SDate) AS RYear,    
 QPCalc.ValueID,    
 QPCalc.ValueDesc    
From    
 Acceptance,    
 Cover,    
 SysTab,    
 QMasterAcceptance_PCalc() AS QPCalc,    
 RARRHEADER    
Where    
 cover.CNO = acceptance.CNO    
 And Rarrheader.ANO = Acceptance.ANO    
 And QPCalc.ANO=Acceptance.ANO    
 And Acceptance.ANO<>Acceptance.LANO    
 And Acceptance.LANO=@P_ANO    
    
 And Cover.CStatus<>'C'    
 And Acceptance.AStatus='I' and Acceptance.AType not in ('A','C')    
 And Acceptance.EDate between @PSDate and @PEDate    
 And Acceptance.RenewableF=1    
 And Cover.ISType in ('I','C','L')    
 And Acceptance.Branch like @pBranch+'%'  
 And Cover.TOC Like @pTOC+'%'    
 And Cover.MO like @pMO+'%'  
 And not Exists (SELECT ANO from Claim, CLLOSS Where CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 and Claim.ANO=Acceptance.ANO)    
 and Exists (Select S1.ID from SysUser S1 Left Join SysUserBranch S2 on (S2.ID=S1.ID and S2.AllowedF=1 and S2.Branch=Acceptance.Branch) Where S1.ID=@P_UserID and (coalesce(S2.Branch,'')<>'' or S1.Type='SUPERVISOR'))    
)    
    
GO

DROP FUNCTION List06_Det 
GO  
CREATE FUNCTION List06_Det (@P_ANO as integer, @P_UserID as varchar(50), @pSDate as smalldatetime, @pEDate as smallDateTime, @pBranch as varchar(10), @pTOC as varchar(10), @pMO as varchar(10))    
RETURNS TABLE    
AS RETURN(    
    
SELECT Cast(0 as bit) as ProcessFlag,    
 [Acceptance].[CertificateNo],     
 Acceptance.ESeqNo,    
 [Acceptance].[AName],     
 [Acceptance].[ANO],     
 [Acceptance].[REGNO],     
 [Acceptance].[ADATE],     
 [Acceptance].[LUSERID] as UserID,     
 [SysTab].[Currency],     
 [QPCalc].[TSI],     
 [QPCalc].[OurShare],     
 [QPCalc].[Gross],     
 [Acceptance].[ASTATUS],     
 [Acceptance].[ATYPE],     
 [Acceptance].[SDate],     
 [Acceptance].[EDate],     
 Year([Acceptance].[SDate]) AS RYear,    
  Acceptance.ValueID,    
  Acceptance.ValueDesc    
FROM     
 Acceptance,     
 Cover,     
 SysTab,     
 QMasterAcceptance_PCalc() AS QPCalc    
WHERE     
 [Cover].[CNO]=[Acceptance].[CNO]     
 And [QPCalc].[ANO]=[Acceptance].[ANO]     
 And [Acceptance].[ANO]<>[Acceptance].[LANO]     
 And [Acceptance].[LANO]=@P_ANO    
 And [Acceptance].[AStatus]='I'     
 And [Acceptance].[AType]<>'C'     
 And [Cover].[ISType]<>'T'     
 And Acceptance.Branch like @pBranch+'%'  
 And Cover.TOC Like @pTOC+'%'    
 And Cover.MO like @pMO+'%'  
 And [Acceptance].[EDate] between @pSDate and @pEDate     
 And Exists (Select S1.ID from SysUser S1 Left Join SysUserBranch S2 on (S2.ID=S1.ID and S2.AllowedF=1 and S2.Branch=Acceptance.Branch) Where S1.ID=@P_UserID and (coalesce(S2.Branch,'')<>'' or S1.Type='SUPERVISOR'))     
)    
    
GO


DROP FUNCTION R_SL_ALLOCATED_DETAIL
GO
CREATE FUNCTION R_SL_ALLOCATED_DETAIL(@P_PDate as smalldatetime)                                       
RETURNS TABLE  AS                                         
RETURN (                                       
                               
--SL from Payment Voucher                                     
Select pSL.Doc_No as Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pSL.Voucher as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Rate*pSL.Nominal_OC) as Nominal_OC                                  
From dbo.pSL                    
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)                    
Where pVoucher.SL_Cat in ('P') and pSL.PaymentF=1 and pVoucher.Date<=@P_PDate              
Group By pSL.Doc_No, pSL.Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Currency, pSL.Voucher, pSL.Account                           
  
Union All  
  
--SL from InterOffice Overbooking Voucher                                     
Select pSL.Doc_No as Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pVoucher.RefNo as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Rate*pSL.Nominal_OC) as Nominal_OC                                  
From dbo.pSL                    
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)            
Inner Join dbo.pVoucher OVoucher on (OVoucher.Voucher=pVoucher.RefNo)          
Where pVoucher.SL_Cat in ('B') and pVoucher.RefType='INTEROFFICE' and pSL.PaymentF=1 and pVoucher.Date<=@P_PDate              
Group By pSL.Doc_No, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Currency, pVoucher.RefNo, pSL.Account                         
                                     
union all                                     
                                     
--SL from Overbooking Payment and Adjustment Payment                                     
Select SL.Doc_No as Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.Voucher as Doc_No, SL.SAccount as Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                          
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal_OC else -SL.Nominal_OC end*SL.Rate)) as Nominal_OC                                     
from pSL SL, pVoucher VoucherP, pVoucher VoucherR
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('B','A') and VoucherP.SL_Cat='P' and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher and SL.PaymentF=1 and VoucherR.Date<=@P_PDate                     
Group By SL.Doc_No, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Currency, VoucherP.Voucher, SL.SAccount, SL.Account                                  
                               
union all                                     
                                     
--SL from Adjustment Overbooking                                     
Select SL.Doc_No as Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.RefNo as Doc_No, SL.SAccount as Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                          
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal_OC else -SL.Nominal_OC end*SL.Rate)) as Nominal_OC                                     
from pSL SL, pVoucher VoucherP, pVoucher VoucherR
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('A') and VoucherP.SL_Cat in ('B') and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher and SL.PaymentF=1 and VoucherR.Date<=@P_PDate              
Group By SL.Doc_No, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Currency, VoucherP.RefNo, SL.SAccount, SL.Account                         
                                     
union all                                     
                                     
--SL from Sub Ledger Payment Voucher and OverPaid                                     
Select SL.Doc_No as Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, SL.Doc_Date, SL.Doc_CCY, SL.Doc_No as Doc_No, SL.Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                          
(Case When VoucherR.SL_Cat='O'                                      
then (case when VoucherR.DebtorF=VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                      
else (case when VoucherR.DebtorF<>VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                     
end) as Nominal_OC                                     
from pSL SL, pVoucher VoucherP, pVoucher VoucherR                                     
Where VoucherR.SL_Cat in ('O','P','A','B') and VoucherP.SL_Cat in ('P') and VoucherR.Voucher=SL.Voucher and SL.Doc_No=VoucherP.Voucher and SL.PaymentF=1 and VoucherR.Date<=@P_PDate                                    
                                       
)     

GO


ALTER FUNCTION [dbo].[FL_CL_CERTIFICATENO](@P_USERID varchar(50), @P_PolicyNo varchar(20),@P_CertificateNo varchar(10))          
RETURNS TABLE          
AS RETURN          
(Select A.CertificateNo, A.AName, A.SDate, A.EDate, A.PDate, A.PPDate, A.NCDate, A.ExtPeriod          
from Acceptance A Inner Join Cover C on (C.CNO=A.CNO)        
Where A.ATYPE Not In ('A','C') And A.ASTATUS NOT IN ('W','T') And C.CStatus<>'C' And A.PDATE<>A.PPDATE And A.ANO<>A.LANO          
and A.PolicyNo=@P_PolicyNo and A.CertificateNo Like @P_CertificateNo+'%'        
and A.Branch in (Select S.Branch from SysUserBranch S Where S.ID=@P_UserID)        
and C.TOC in (Select S.TOC from SysUserTOC S Where S.ID=@P_UserID)        
)     

GO

ALTER FUNCTION [dbo].[FL_CL_POLICYNO](@P_USERID varchar(50), @P_PolicyNo varchar(20))                      
RETURNS TABLE                      
AS RETURN                      
(Select A.PolicyNo, A.CertificateNo, A.AName, A.SDate, A.EDate, A.PDate, A.PPDate, A.NCDate, A.ExtPeriod                 
from Acceptance A Inner Join Cover C on (C.CNO=A.CNO)                  
Where A.ATYPE Not In ('A','C') And A.ASTATUS Not in ('W','T') and C.CStatus not in ('R','P','C')           
And A.PDATE<A.PPDATE And A.ANO<>A.LANO            
and A.PolicyNo<>'' and A.PolicyNo Like @P_PolicyNo+'%'                  
and A.Branch in (Select S.Branch from SysUserBranch S Where S.ID=@P_UserID)                  
and C.TOC in (Select S.TOC from SysUserTOC S Where S.ID=@P_UserID)                  
)     


GO

ALTER function [dbo].[FL_CL_TOC](@P_USERID varchar(50), @P_TOC varchar(10))    
RETURNS Table    
AS RETURN    
(  
Select distinct TOC.TOC,TOC.Description From TOC, SysUserTOC S 
Where S.TOC=TOC.TOC And TOC.AllowedF=1 And S.ID=@P_USERID and TOC.TOC like @P_TOC+'%'  
) 


GO




ALTER function [dbo].[FL_SR_CertificateNo](@P_USERID varchar(50), @P_PolicyNo varchar(20),@P_CertificateNo varchar(10))    
RETURNS Table    
AS RETURN    
(Select A.CertificateNo, A.AName, A.SDate, A.EDate
from Acceptance A Inner Join Cover C on (C.CNO=A.CNO)
Where (A.LANO<>-1 or A.LANO<>A.ANO) and A.ATYPE Not In ('A','C') And A.ASTATUS<>'W' and C.Cstatus<>'C' And A.PDATE<>A.PPDATE 
and A.PolicyNo=@P_PolicyNo and A.CertificateNo Like @P_CertificateNo+'%'
and A.Branch in (Select S.Branch from SysUserBranch S Where S.ID=@P_UserID)
and C.TOC in (Select S.TOC from SysUserTOC S Where S.ID=@P_UserID)
)     


GO


ALTER function [dbo].[FL_SR_PolicyNo](@P_USERID varchar(50), @P_PolicyNo varchar(20))      
RETURNS Table      
AS RETURN      
(Select A.PolicyNo, A.AName, A.SDate, A.EDate ,A.CertificateNo   
from Acceptance A Inner Join Cover C on (C.CNO=A.CNO)    
Where (A.LANO=-1 or A.LANO=A.ANO) and A.ATYPE Not In ('A','C') 
And A.ASTATUS<>'W' and C.CStatus<>'C' And A.PDATE<>A.PPDATE
And C.ASource='UW'     
and A.PolicyNo Like @P_PolicyNo+'%'    
and A.Branch in (Select S.Branch from SysUserBranch S Where S.ID=@P_UserID)    
and C.TOC in (Select S.TOC from SysUserTOC S Where S.ID=@P_UserID)    
)    


GO

ALTER function [dbo].[FL_SR_SchemeNo](@p_UserID varchar(50), @P_SchemeNo varchar(10),@P_PolicyNo varchar(10))  
RETURNS Table  
AS RETURN  
(

Select Distinct S.SchemeNo, S.Description, S.Disc, S.DailyBasisF, s.sPeriod, s.AllowedF 
from acceptance as a
inner join cover as c on (a.cno=c.cno and c.OpenFlag=1) 
inner join Scheme_Master S on (S.TOC=C.TOC and S.SchemeNo Like @P_SchemeNo)
inner join SysUser on (SysUser.ID=@P_UserID)
Left Join Scheme_Branch S1 on (SysUser.Type<>'SUPERVISOR' and S1.SchemeNo=S.SchemeNo) 
where a.ano = a.lano and S.AllowedF=1 and A.AType not in ('A','C') and a.astatus = 'I' and a.PolicyNo Like @P_PolicyNo+'%' and a.ano not in (Select PANO from Acceptance Where Acceptance.PANO=a.ANO)
and (SysUser.Type='SUPERVISOR' or S1.Branch is null or S1.Branch in (Select Branch from SysUserBranch Where AllowedF=1 and ID=@P_UserID))
and (SysUser.Type='SUPERVISOR' or S.TOC in (Select TOC from SysUserTOC Where ID=@P_UserID))
)          


GO


ALTER function [dbo].[FL_SR_TOC](@P_USERID varchar(50), @P_TOC varchar(10),@P_PolicyType varchar(10))  
RETURNS Table  
AS RETURN  
(
Select distinct TOC.TOC,TOC.Description From TOC, PTClass, SysUserTOC S Where TOC.AllowedF=1 and S.ID=@P_USERID and S.TOC=TOC.TOC and PTClass.COB=TOC.COB and PTClass.PolicyType like @P_PolicyType+'%' and TOC.TOC like @P_TOC+'%'
)


GO




ALTER function [dbo].[FL_UserBranch](@P_USERID varchar(50), @P_Branch varchar(10))    
RETURNS Table      
AS RETURN      
(    
SELECT Branch.Branch, Branch.Name, Branch.Active_Flag, Branch.ShariaF
from Branch, SysUser    
Where SysUser.ID=@P_UserID and Branch.Branch Like @P_Branch+'%' and Branch.Op_Flag=1 and Branch.Active_Flag=1    
and (SysUser.Type='SUPERVISOR' or Branch.Branch in (Select S.Branch from SysUserBranch S Where S.AllowedF=1 and S.ID=@P_UserID))
)    
  

GO


ALTER function [dbo].[FL_UserBranch_FA](@P_USERID varchar(50), @P_Branch varchar(10))      
RETURNS Table        
AS RETURN        
(      
SELECT Branch.Branch, Branch.Name, Branch.Active_Flag, Branch.ShariaF
from Branch, SysUser    
Where SysUser.ID=@P_UserID and Branch.Branch Like @P_Branch+'%' and Branch.Op_Flag=1    
and (SysUser.Type='SUPERVISOR' or Branch.Branch in (Select S.Branch from SysUserBranch S Where S.AllowedF=1 and S.ID=@P_UserID))
)  


GO

ALTER function [dbo].[FL_UserBranch_RQ](@P_USERID varchar(50), @P_Branch varchar(10))        
RETURNS Table          
AS RETURN          
(        
SELECT Branch.Branch, Branch.Name, Branch.Active_Flag, Branch.ShariaF  
from Branch, SysUser      
Where SysUser.ID=@P_UserID and Branch.Branch Like @P_Branch+'%' and Branch.Op_Flag=1      
and (SysUser.Type='SUPERVISOR' or Branch.Branch in (Select S.Branch from SysUserBranch S Where S.RequestF=1 and S.ID=@P_UserID))  
)    
  
  

GO


ALTER function [dbo].[FL_UserBranchAccountIO](@P_USERID varchar(50), @P_Branch varchar(10), @P_Account varchar(10), @P_DebtorF Bit)            
RETURNS Table              
AS RETURN              
(            
SELECT Branch.Branch, Branch.Name, Branch.Active_Flag, Branch.ShariaF      
from Branch, SysUser, Account, Type          
Where SysUser.ID=@P_UserID and Account.Account=@P_Account and Account.Inter_Flag=1 and Type.Type=Account.Type       
and Branch.Branch Like @P_Branch+'%' and Branch.Op_Flag=1       
and (SysUser.Type='SUPERVISOR'       
or EXISTS (Select S.Branch from SysUserBranch S       
Where S.Branch=Branch.Branch and ((Type.PL_Flag=1 and S.IncomeReceiveF=1 and @P_DebtorF=1) or (Type.PL_Flag=1 and S.ExpensePaymentF=1 and @P_DebtorF=0) or (Type.BS_Flag=1 and S.SuspendReceiveF=1 and @P_DebtorF=1) or (Type.BS_Flag=1 and S.SuspendPaymentF=1 and @P_DebtorF=0)) and S.ID=SysUser.ID))        
)      


GO

ALTER function [dbo].[FL_UserRateCode](@P_USERID varchar(50), @P_CODE varchar(10),@P_TOPRO varchar(10))
RETURNS Table  
AS RETURN  
(
Select R.Code, R.Description
from RateTab R, TOP_Rate T
Where R.Code=T.Code and R.Code Like @P_CODE+'%' and T.TOPRO=@P_TOPRO
)


GO


ALTER function [dbo].[FL_UserRateCode_1](@P_USERID varchar(50), @P_CODE varchar(10),@P_TOC varchar(10))  
RETURNS Table  
AS RETURN  
(  
Select Distinct R1.Code, R1.Description From RateTab R1, RateCov R2, RClass R3 Where R3.TOR=R2.TOR and R1.Code=R2.Code and    
R1.AllowedF=1 and R3.TOC like @P_TOC+'%' and R1.Code Like @P_CODE+''  
)

GO


ALTER function [dbo].[FL_UserTopro](@P_USERID varchar(50), @P_TOPRO varchar(10),@P_TOC varchar(10),@P_SEGMENT varchar(10))      
RETURNS Table        
AS RETURN        
(      
SELECT Distinct TOPRO.TOPRO, TOPRO.Description, TOPRO.TOC, TOPRO.Expiry, TOPRO.CustomizableF, TOPRO.IncludeExtCoverF          
from TOPRO Left Join TOP_Segment on (TOP_Segment.TOPRO=TOPRO.TOPRO)             
Where TOPRO.TOPRO Like @P_TOPRO+'%' and TOPRO.TOC Like @P_TOC+'%' and TOPRO.AllowedF=1             
and (TOPRO.SegmentF=0 or TOP_Segment.Segment like @P_SEGMENT)   
and GETDATE() < expiry  
)   
  

GO



ALTER PROCEDURE [dbo].[QUserBranch](@P_UserID as varchar(50),@P_Branch as varchar(10))    
AS    
    
SELECT Branch.Branch, Branch.Name, Branch.ShariaF 
from Branch, SysUser  
Where SysUser.ID=@P_UserID and Branch.Branch Like @P_Branch+'%' and Branch.OP_Flag=1 
and (SysUser.Type='SUPERVISOR' or Branch.Branch in (Select SysUserBranch.Branch from SysUserBranch Where AllowedF=1 and SysUserBranch.ID=@P_UserID and SysUserBranch.Branch=Branch.Branch))    
  

GO



ALTER PROCEDURE [dbo].[QUserBranchClaim](@P_UserID as varchar(50),@P_Branch as varchar(10))    
AS    
    
SELECT Branch.Branch, Branch.Name, Branch.ShariaF 
from Branch, SysUser  
Where SysUser.ID=@P_UserID 
and Branch.Branch Like @P_Branch+'%' and Branch.OP_Flag=1 
and (SysUser.Type='SUPERVISOR' or Branch.Branch in (Select SysUserBranch.Branch from SysUserBranch Where ClaimHandlingF=1 and SysUserBranch.ID=@P_UserID and SysUserBranch.Branch=Branch.Branch))      


GO


ALTER PROCEDURE [dbo].[QUserTOC](@P_UserID as varchar(50),@P_TOC as varchar(10))    
AS    
    
SELECT TOC.TOC, TOC.Description
from TOC, SysUser  
Where SysUser.ID=@P_UserID 
and TOC.TOC Like @P_TOC +'%' 
and (SysUser.Type='SUPERVISOR' or TOC.TOC in (Select SysUserTOC.TOC from SysUserTOC Where SysUserTOC.ID=@P_UserID and SysUserTOC.TOC=TOC.TOC))      


GO


ALTER function [dbo].[FN_UserBranch](@P_USERID varchar(50))      
RETURNS Table        
AS RETURN        
(      
SELECT Branch.*  
from Branch, SysUser  
Where SysUser.ID=@P_UserID   
and (SysUser.Type='SUPERVISOR' or Branch.Branch in (Select S.Branch from SysUserBranch S Where S.AllowedF=1 and S.ID=@P_UserID))  
)          


GO

ALTER FUNCTION [dbo].[FN_UserBusinessSource] (@P_UserID as varchar(10))      
RETURNS TABLE      
as RETURN(      
Select P.*, S1.ID as SID, S1.Name as SName
From Profile P 
Left Join SysUserAssignment S on (S.AssType='SOURCE' and S.PID=P.ID and (S.ID=@P_UserID or @P_UserID=''))
Left join SysUser S1 on (S1.ID=S.ID and S1.AllowedF=1)
Where @P_UserID='' 
or coalesce(S1.ID,'')=@P_UserID
or P.ID not in (Select PID from SysUserAssignment S Where S.AssType='SOURCE' and S.ID<>@P_UserID)
)    


GO



ALTER FUNCTION [dbo].[FN_UserComAcc] (@P_UserID as varchar(10), @P_Branch as varchar(10))            
RETURNS TABLE            
as RETURN(            
SELECT ComAcc.*       
 from ComAcc       
 Left Join Branch on (Branch.Branch=@P_Branch)      
 Inner join SysUser on (SysUser.ID=@P_UserID)      
 Where (SysUser.Type='SUPERVISOR' or ComAcc.ComAcc in (Select SysUserComAcc.ComAcc from SysUserComAcc Where SysUserComAcc.ID=@P_UserID and SysUserComAcc.ComAcc=ComAcc.ComAcc)) and          
(@P_Branch='' or        
(Coalesce(Branch.Op_Flag,0)=0) or      
(ComAcc.Branch=@P_Branch) or          
(ComAcc.ComAcc in (Select ComAcc from ComAcc_Branch Where Branch=@P_Branch)) or           
(ComAcc.Branch='' and ComAcc.ComAcc Not in (Select ComAcc from ComAcc_Branch)))          
) 
go

ALTER function [dbo].[FN_UserCT](@P_USERID varchar(50), @P_Branch varchar(10))  
RETURNS Table    
AS RETURN    
(  
SELECT CT.*
from CT
Where (CT.Branch is null or CT.Branch='' or CT.Branch=@P_Branch)
)  
    




GO


ALTER FUNCTION [dbo].[FN_UserSegment] (@P_UserID as varchar(50))          
RETURNS TABLE          
as RETURN(          
SELECT Segment.*     
 from Segment     
 Inner join SysUser on (SysUser.ID=@P_UserID)    
 Where (SysUser.Type='SUPERVISOR' or Segment.Segment in (Select SysUserSegment.Segment from SysUserSegment Where SysUserSegment.ID=@P_UserID and SysUserSegment.Segment=Segment.Segment)) 
)        
        

GO

ALTER Function [dbo].[fn_MSCode](@P_MO as varchar(50), @P_SDate as DateTime, @P_EDate as DateTime)        
RETURNS VarChar(10)        
AS        
BEGIN        
 Declare @MSCode varchar(10)        
          
 Select TOP 1 @MSCode=M.MSCode from MSCode_Assignment M  
 Where M.ID=@P_MO and M.Effective<=@P_SDate and (@P_EDate<M.CloseDate or M.CloseDate is null)    
    
 if @MSCode is null        
 Select @MSCode=''       
      
 return(@MSCode)        
End     
  
  

GO

ALTER Function [dbo].[fn_BrokerID](@P_ANO as int)        
RETURNS VarChar(10)        
AS        
BEGIN        
Declare @BrokerID varchar(50)      
 Declare @P_LANO int

 Select @P_LANO=LANO from Acceptance Where ANO=@P_ANO
 
 if @P_LANO<>-1
 Begin
	--Alternate Agent/Broker      
	 Select TOP 1 @BrokerID=AccBS.ID from AAccBS AccBS
	 Where AccBS.ANO=@P_ANO and BSType='B'
	 Order By Fee Desc, AccBS.ID Asc  
	 
	 if @BrokerID is null    
	 Select TOP 1 @BrokerID=AccBS.ID from AccBS
	 Where AccBS.ANO=@P_LANO and BSType='B'
	 Order By Fee Desc, AccBS.ID Asc  	 	 
 end
 else
 Begin
	 Select TOP 1 @BrokerID=AccBS.ID from AccBS
	 Where AccBS.ANO=@P_ANO and BSType='B'
	 Order By Fee Desc, AccBS.ID Asc  	 	  
 end
    
 if @BrokerID is null      
 Select @BrokerID=''     
    
 return(@BrokerID)     
End        



GO


ALTER Function [dbo].[fn_AgentID](@P_ANO as int)      
RETURNS VarChar(10)      
AS      
BEGIN      
 Declare @AgentID varchar(50)      
 Declare @P_LANO int

 Select @P_LANO=LANO from Acceptance Where ANO=@P_ANO
 
 if @P_LANO<>-1
 Begin
	--Alternate Agent/Broker      
	 Select TOP 1 @AgentID=AccBS.ID from AAccBS AccBS
	 Where AccBS.ANO=@P_ANO and BSType='A'
	 Order By Fee Desc, AccBS.ID Asc  
	 
	 if @AgentID is null    
	 Select TOP 1 @AgentID=AccBS.ID from AccBS
	 Where AccBS.ANO=@P_LANO and BSType='A'
	 Order By Fee Desc, AccBS.ID Asc  	 	 
 end
 else
 Begin
	 Select TOP 1 @AgentID=AccBS.ID from AccBS
	 Where AccBS.ANO=@P_ANO and BSType='A'
	 Order By Fee Desc, AccBS.ID Asc  	 	  
 end
    
 if @AgentID is null      
 Select @AgentID=''     
    
 return(@AgentID)      
End      
            

GO



ALTER Function [dbo].[fn_BizMap](@P_ANO as int, @P_Source as varchar(10)='')            
RETURNS VarChar(10)            
AS            
          
BEGIN            
 Declare @CType varchar(20)            
 Declare @PType varchar(20)            
 Declare @IType varchar(10)            
 Declare @CGroup varchar(10)            
 Declare @Segment varchar(10)            
 Declare @ISType varchar(10)            
 Declare @Payor_LOB varchar(10)            
 Declare @PHolder_LOB varchar(10)            
 Declare @Insured_LOB varchar(10)            
 Declare @Source_LOB varchar(10)            
 Declare @SegmentGroup varchar(10)            
 Declare @ID varchar(50)            
 
 if @P_ANO>0
 Begin                   
	 if @P_Source=''     
	 Begin                   
	  Select            
	  @CType=Source.CType,            
	  @PType=case When Source.PType='C' Then 'CAPTIVE' When Source.PType='D' Then 'DIRECT INSURED' else 'OTHERS' end,            
	  @IType=I.IType,            
	  @CGroup=PHolder.CGroup,            
	  @Segment=C.Segment,            
	  @ISType=C.ISType,            
	  @Payor_LOB=Payor.LOB,            
	  @PHolder_LOB=PHolder.LOB,            
	  @Insured_LOB=Insured.LOB,            
	  @Source_LOB=Source.LOB,            
	  @SegmentGroup=SegmentGroup.SegmentGroup          
	  from Cover C           
	  Left Join Segment on (Segment.Segment=C.Segment)           
	  Left join SegmentGroup on (Segment.SegmentGroup=SegmentGroup.SegmentGroup)          
	  Left Join InParty I On (I.CNO=C.CNO), Acceptance A, Payor APayor, Profile Payor, Profile Insured, Profile Source, Profile  PHolder Left Join CGroup on (CGroup.CGroup=PHolder.CGroup)            
	  Where C.CNO=A.CNO and (APayor.ANO=A.LANO or APayor.ANO=A.ANO) and Payor.ID=APayor.ID and PHolder.ID=C.PHolder and Insured.ID=A.AID and Source.ID=A.Source and A.ANO=@P_ANO             
	 End     
	 Else    
	 Begin    
	  Select            
	  @CType=Source.CType,            
	  @PType=case When Source.PType='C' Then 'CAPTIVE' When Source.PType='D' Then 'DIRECT INSURED' else 'OTHERS' end,            
	  @IType=I.IType,            
	  @CGroup=PHolder.CGroup,            
	  @Segment=C.Segment,            
	  @ISType=C.ISType,            
	  @Payor_LOB=Payor.LOB,            
	  @PHolder_LOB=PHolder.LOB,            
	  @Insured_LOB=Insured.LOB,            
	  @Source_LOB=Source.LOB,            
	  @SegmentGroup=SegmentGroup.SegmentGroup          
	  from Cover C           
	  Left Join Segment on (Segment.Segment=C.Segment)           
	  Left join SegmentGroup on (Segment.SegmentGroup=SegmentGroup.SegmentGroup)          
	  Left Join InParty I On (I.CNO=C.CNO), Acceptance A, Payor APayor, Profile Payor, Profile Insured, Profile Source, Profile  PHolder Left Join CGroup on (CGroup.CGroup=PHolder.CGroup)            
	  Where C.CNO=A.CNO and (APayor.ANO=A.LANO or APayor.ANO=A.ANO) and Payor.ID=APayor.ID and PHolder.ID=C.PHolder and Insured.ID=A.AID and Source.ID=@P_Source and A.ANO=@P_ANO            
	 End     
 End
 ELSE
 BEGIN
	SELECT 
		@CType=Source.CType,            
		@PType=case When Source.PType='C' Then 'CAPTIVE' When Source.PType='D' Then 'DIRECT INSURED' else 'OTHERS' end,            
		@Source_LOB=Source.LOB,
		@Segment='DIRECT',
	    @ISType='I'
	from Profile Source
	Where Source.ID=@P_Source	
 END
                           
 Select Top 1 @ID=B.ID from BizMap B            
 Where b.Post_Flag = 1            
 and (CType='<ANY>' or CType=@CType)            
 and (PType='<ANY>' or PType=@PType)            
 and (IType='<ANY>' or IType=@IType)            
 and (Cgroup='<ANY>' or CGroup=@CGroup)            
 and (Segment='<ANY>' or Segment=@Segment)            
 and (ISType='<ANY>' or ISType=@ISType)            
 and (Payor_LOB='<ANY>' or Payor_LOB=@Payor_LOB)            
 and (PHolder_LOB='<ANY>' or PHolder_LOB=@PHolder_LOB)            
 and (Insured_LOB='<ANY>' or Insured_LOB=@Insured_LOB)            
 and (Source_LOB='<ANY>' or Source_LOB=@Source_LOB)            
 and (SegmentGroup='<ANY>' or SegmentGroup=SegmentGroup)            
 Order By OrderNo, ID       
 return(@ID)            
End            
                      

GO



ALTER Function [dbo].[fn_BusinessSource](@P_ANO as int)      
RETURNS VarChar(10)      
AS      
BEGIN      
 Declare @Source varchar(50)      
 Declare @P_LANO int

 Select @P_LANO=LANO from Acceptance Where ANO=@P_ANO
 
 if @P_LANO<>-1      
 Begin
	--Alternate Agent/Broker      
	 Select TOP 1 @Source=AccBS.ID from AAccBS AccBS
	 Where AccBS.ANO=@P_ANO      
	 Order By PreferredF Desc, Fee Desc, (Case When BSType='B' Then 3 else (Case When BSType='A' then 2 else 1 end) end) Desc, AccBS.ID Asc      
	      
	--Agent/Broker      
	 if @Source is null    
	 Select TOP 1 @Source=AccBS.ID from AccBS
	 Where AccBS.ANO=@P_LANO      
	 Order By PreferredF Desc, Fee Desc, (Case When BSType='B' Then 3 else (Case When BSType='A' then 2 else 1 end) end) Desc, AccBS.ID Asc      
	                    
	--Alternate Payor      
	 if @Source is null      
	 Select @Source=Payor.ID from APayor Payor
	 Where Payor.ANO=@P_ANO
	                     
	--Payor      
	 if @Source is null      
	 Select @Source=Payor.ID from Payor
	 Where Payor.ANO=@P_LANO
 End
 Else
 Begin
	 Select TOP 1 @Source=AccBS.ID from AccBS
	 Where AccBS.ANO=@P_ANO
	 Order By PreferredF Desc, Fee Desc, (Case When BSType='B' Then 3 else (Case When BSType='A' then 2 else 1 end) end) Desc, AccBS.ID Asc      
	                     
	 if @Source is null      
	 Select @Source=Payor.ID from Payor
	 Where Payor.ANO=@P_ANO
 End
 
 if @Source is null      
 Select @Source=''     
    
 return(@Source)                           
End      
 

GO



ALTER Function [dbo].[fn_CPAID](@P_ANO as int)      
RETURNS VarChar(10)      
AS      
BEGIN      
 Declare @CPAID varchar(50)      
 Declare @P_LANO int

 Select @P_LANO=LANO from Acceptance Where ANO=@P_ANO
 
 if @P_LANO<>-1
 Begin
	--Alternate Agent/Broker      
	 Select TOP 1 @CPAID=AccBS.ID from AAccBS AccBS
	 Where AccBS.ANO=@P_ANO and BSType='C'
	 Order By Fee Desc, AccBS.ID Asc  
	 
	 if @CPAID is null    
	 Select TOP 1 @CPAID=AccBS.ID from AccBS
	 Where AccBS.ANO=@P_LANO and BSType='C'
	 Order By Fee Desc, AccBS.ID Asc  	 	 
 end
 else
 Begin
	 Select TOP 1 @CPAID=AccBS.ID from AccBS
	 Where AccBS.ANO=@P_ANO and BSType='C'
	 Order By Fee Desc, AccBS.ID Asc  	 	  
 end
    
 if @CPAID is null      
 Select @CPAID=''     
    
 return(@CPAID)      
End  

GO



ALTER FUNCTION [dbo].[List11F_Det] (@P_ANO as integer,@P_UserID as varchar(50), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_PDate as smalldatetime, @P_ManualF as bit)    
RETURNS Table    
AS RETURN(    
        
SELECT Cast(0 as bit) as ProcessFlag,    
 Acceptance.CertificateNo,    
 Acceptance.ESeqNo,    
 Acceptance.AName,    
 Acceptance.ANO,    
 Acceptance.REGNO,    
 Acceptance.ADATE,    
 Acceptance.LUSERID as UserID,    
 SysTab.Currency,    
 QPCalc.TSI,    
 QPCalc.OurShare,    
 QPCalc.Gross,    
 Acceptance.ASTATUS,    
 Acceptance.ATYPE,    
 Acceptance.SDate,    
 Acceptance.EDate,    
 Year(Acceptance.SDate) AS RYear,    
 Acceptance.ValueID,    
 Acceptance.ValueDesc    
From    
 Acceptance,    
 Cover,    
 SysTab,    
 QMasterAcceptance_PCalc() AS QPCalc,    
 RARRHEADER, 
 SysUserTOC, 
 SysUserBranch
Where    
 cover.CNO = acceptance.CNO    
 And Rarrheader.ANO = Acceptance.ANO    
 And QPCalc.ANO=Acceptance.ANO    
 And Acceptance.ANO<>Acceptance.LANO    
 And Acceptance.LANO=@P_ANO    
 And Cover.CStatus<>'C'    
 And Acceptance.AStatus='I' and Acceptance.AType not in ('A','C')    
 And RArrHeader.NRDate<Acceptance.EDate And RArrHeader.NRDate<=@P_PDate    
 And (@P_ManualF=0 or RArrHeader.ManualF=@P_ManualF)  
 And Cover.ISType<>'T'    
 And SysUserTOC.ID=@P_UserID and Cover.TOC=SysUserTOC.TOC and (SysUserTOC.TOC Like @P_TOC+'%' or @P_TOC='')  
 And SysUserBranch.ID=@P_UserID and Acceptance.BRanch=SysUserBranch.Branch and (SysUserBranch.Branch=@P_Branch or @P_Branch='')  
 
)    
        

GO



ALTER PROCEDURE [dbo].[List18] (@P_UserID as varchar(50), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_PDate as smalldatetime)  
AS  
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,  
 Cast(Acceptance.AName as varchar(128)) as Insured,  
 Cover.CNO,  
 Cover.CStatus,  
 Acceptance.lANO,  
 Acceptance.ANO,  
 Acceptance.REGNO,  
 Acceptance.ADATE,  
 Acceptance.LUSERID as USERID,  
 SysTab.Currency,  
 QPCalc.TSI,  
 QPCalc.OurShare,  
 QPCalc.Gross,  
 Acceptance.ASTATUS,  
 Acceptance.ATYPE,  
 Acceptance.SDate,  
 Acceptance.EDate,  
 Year(Acceptance.SDate) AS RYear,  
 Cover.ISType,  
 Acceptance.Renewal,  
 Acceptance.ESeqNo,  
 Acceptance.PolicyNo,  
 acceptance.CertificateNo  
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, SysUserTOC, SysUserBranch
Where cover.CNO = acceptance.CNO  
 And QPCalc.ANO=Acceptance.ANO  
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)  
 And Acceptance.AStatus='I'  
 And Acceptance.AType Not in ('C','A')  
 And Cover.ISType<>'T'  
 AND @P_PDate between Acceptance.PDate and Acceptance.PPDate  
 And SysUserTOC.ID=@P_UserID and Cover.TOC=SysUserTOC.TOC and (SysUserTOC.TOC=@P_TOC or @P_TOC='')
 And SysUserBranch.ID=@P_UserID and Acceptance.BRanch=SysUserBranch.Branch and (SysUserBranch.Branch=@P_Branch or @P_Branch='')
 And Acceptance.ANO in (SELECT ANO from Claim, CLLOSS Where (Claim.CSTATUS IN ('R','P','T','A') OR Claim.PCSTATUS IN ('A')) and Claim.CNO=CLLOSS.CNO and CLLOSS.CTLF=1 And Claim.ANO=Acceptance.ANO)  
      
Union All  
      
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,  
 Cast(Acceptance.AName as varchar(128)) as Insured,  
 Cover.CNO,  
 Cover.CStatus,  
 Acceptance.lANO,  
 Acceptance.ANO,  
 Acceptance.REGNO,  
 Acceptance.ADATE,  
 Acceptance.LUSERID as USERID,  
 SysTab.Currency,  
 QPCalc.TSI,  
 QPCalc.OurShare,  
 QPCalc.Gross,  
 Acceptance.ASTATUS,  
 Acceptance.ATYPE,  
 Acceptance.SDate,  
 Acceptance.EDate,  
 Year(Acceptance.SDate) AS RYear,  
 Cover.ISType,  
 Acceptance.Renewal,  
 Acceptance.ESeqNo,  
 Acceptance.PolicyNo,  
 acceptance.CertificateNo  
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, Acceptance As Acceptance_Detail, SysUserTOC, SysUserBranch
Where cover.CNO = acceptance.CNO  
 And QPCalc.ANO=Acceptance.ANO  
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO  
 And Acceptance.AStatus='I'  
 And Acceptance.AType Not in ('C','A')  
 And Cover.ISType<>'T'  
 AND @P_PDate between Acceptance_Detail.PDate and Acceptance_Detail.PPDate  
 And SysUserTOC.ID=@P_UserID and Cover.TOC=SysUserTOC.TOC and (SysUserTOC.TOC=@P_TOC or @P_TOC='')
 And SysUserBranch.ID=@P_UserID and Acceptance_Detail.BRanch=SysUserBranch.Branch and (SysUserBranch.Branch=@P_Branch or @P_Branch='')
 And Acceptance_Detail.ANO in (SELECT ANO from Claim, CLLOSS Where (Claim.CSTATUS IN ('R','P','T','A') OR Claim.PCSTATUS IN ('A')) and Claim.CNO=CLLOSS.CNO and CLLOSS.CTLF=1 And Claim.ANO=Acceptance_Detail.ANO)  
      
          




GO


ALTER PROCEDURE [dbo].[MList01] (@P_UserID as Varchar(50))
AS
SELECT Cast(0 as bit) as ProcessFlag, [Cover].[COVERNO], [Cover].[Insured], [Cover].[CNO], [Cover].[CStatus], Cover.VSeqNo, [Acceptance].[lANO], [Acceptance].[ANO], [Acceptance].[REGNO], [Acceptance].[ADATE],[Acceptance].[LUSERID] as USERID,  [SysTab].[Currency], [QPCalc].[TSI], [QPCalc].[OurShare], [QPCalc].[Gross], [Acceptance].[ASTATUS], [Acceptance].[ATYPE], [Acceptance].[SDate], [Acceptance].[EDate], 
  Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
  Cover.ISType, 
  Acceptance.Renewal, 
  Acceptance.ESeqNo, 
  Acceptance.PolicyNo  
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE [Cover].[CNO]=[Acceptance].[CNO] 
	And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) 
	And [Acceptance].[AType]='N' 
	And [Acceptance].[LUserID] Like @P_UserID
	And [Cover].[CStatus]='R'



GO

ALTER PROCEDURE [dbo].[MLIST02] (@P_UserID as varchar(50))
AS
SELECT 		Cast(0 as bit) as ProcessFlag, 
		[Cover].[COVERNO], 
		[Cover].[Insured], 
		[Cover].[CNO], 
		[Cover].[CStatus], 
		[Cover].[VSeqNo], 
		[Acceptance].[lANO], 
		[Acceptance].[ANO], 
		[Acceptance].[REGNO], 
		[Acceptance].[ADATE], 
		[Acceptance].[LUSERID] as USERID, 
		[SysTab].[Currency], 
		[QPCalc].[TSI], 
		[QPCalc].[OurShare], 
		[QPCalc].[Gross], 
		[Acceptance].[ASTATUS], 
		[Acceptance].[ATYPE], 
		[Acceptance].[SDate], 
		[Acceptance].[EDate], 
		Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
		Cover.ISType, 
		Acceptance.Renewal, 
		Acceptance.ESeqNo, 
		Acceptance.PolicyNo		
FROM 	Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE 	[Cover].[CNO]=[Acceptance].[CNO] 
		And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) 
		And [Acceptance].[AType]='N' 
		And [Acceptance].[AStatus]='W' 
		And [Acceptance].[LUserID] Like @P_UserID
		And [Cover].[CStatus]='A'



GO


ALTER PROCEDURE [dbo].[MList04] (@P_UserID as Varchar(50))
AS
SELECT Cast(0 as bit) as ProcessFlag, [Cover].[COVERNO], [Cover].[Insured], [Cover].[CNO], [Cover].[CStatus], Cover.VSeqNo, [Acceptance].[lANO], [Acceptance].[ANO], [Acceptance].[REGNO], [Acceptance].[ADATE],[Acceptance].[LUSERID] as USERID,  [SysTab].[Currency], [QPCalc].[TSI], [QPCalc].[OurShare], [QPCalc].[Gross], [Acceptance].[ASTATUS], [Acceptance].[ATYPE], [Acceptance].[SDate], [Acceptance].[EDate], 
  Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
  Cover.ISType, 
  Acceptance.Renewal, 
  Acceptance.ESeqNo, 
  Acceptance.PolicyNo  
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
Where [cover].[CNO] = [acceptance].[CNO]
 And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO])
 And [Acceptance].[LUserID] Like @P_UserID
 And [Cover].[CStatus]='R'




GO


ALTER PROCEDURE [dbo].[MList05] (@P_UserID as varchar(50))
AS
SELECT Cast(0 as bit) as ProcessFlag, [Cover].[COVERNO], [Cover].[Insured], [Cover].[CNO], [Cover].[CStatus], Cover.VSeqNo, [Acceptance].[lANO], [Acceptance].[ANO], [Acceptance].[REGNO], [Acceptance].[ADATE], [Acceptance].[LUSERID] as USERID, [SysTab].[Currency], [QPCalc].[TSI], [QPCalc].[OurShare], [QPCalc].[Gross], [Acceptance].[ASTATUS], [Acceptance].[ATYPE], [Acceptance].[SDate], [Acceptance].[EDate], 
  Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
  Cover.ISType, 
  Acceptance.Renewal, 
  Acceptance.ESeqNo, 
  Acceptance.PolicyNo  
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE [Cover].[CNO]=[Acceptance].[CNO] 
	And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) 
	And [Acceptance].[AType]='N' And [Acceptance].[AStatus]='W' 
	And [Acceptance].[LUserID] Like @P_UserID
	And [Cover].[CStatus]='P'



GO


ALTER PROCEDURE [dbo].[MList15] (@P_ID as Varchar(50))
AS
SELECT 		Cast(0 as bit) as ProcessFlag, 
		[Cover].[COVERNO], 
		[Cover].[Insured], 
		[Cover].[CNO], 
		[Cover].[CStatus], 
		Cover.VSeqNo, 
		[Acceptance].[lANO], 
		[Acceptance].[ANO], 
		[Acceptance].[REGNO], 
		[Acceptance].[ADATE], 
		[Acceptance].[LUSERID] as USERID,
		[SysTab].[Currency], 
		[QPCalc].[TSI], 
		[QPCalc].[OurShare], 
		[QPCalc].[Gross], 
		[Acceptance].[ASTATUS], 
		[Acceptance].[ATYPE], 
		[Acceptance].[SDate], 
		[Acceptance].[EDate], 
		Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
		Cover.ISType, 
		Acceptance.Renewal, 
		Acceptance.ESeqNo, 
		Acceptance.PolicyNo  
FROM 	Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Payor
WHERE 	[Cover].[CNO]=[Acceptance].[CNO] 
		And Payor.ANO=Acceptance.ANO
		And Payor.ID=@P_ID
		And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) 
		And [Acceptance].[AType]='N' 
		And [Acceptance].[AStatus]='W' 
		And [Cover].[CStatus] in ('R','P','A')



GO


ALTER PROCEDURE [dbo].[QSRACC_1] (@P_MO as varchar(50), @P_Segment as varchar(10), @P_Branch as varchar(10), @P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO VARCHAR(255))    
AS    
SELECT TOP 50 ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, Acceptance.AID, Acceptance.AName, SysUser.Name as MOName, Acceptance.Branch, Cover.PHolder, COVER.INSURED, COVER.TOC, Cover.CoverDate, Cover.ExpDate, RCover.Code, RCover.Coverage, TOC.RegID,    
TOC.Description as TOCDesc, Profile.Name as PHolderName, Profile.Address_1, Profile.Address_2, Profile.Phone_1, Profile.Phone_2, PCalc.Currency, PCalc.TSI,    
Acceptance.LANO, Acceptance.ANO, Acceptance.Source as BSID, Cover.CNO, Cover.ASource, Cover.PolicyType, Cover.ISType, Cover.Segment, Cover.MO, Branch.Name as BranchName,  
Acceptance.TOPRO, TOPRO.Description as TOPRODesc, Acceptance.RefNo  
FROM ACCEPTANCE Left Join (Select RCover.ANO, Max(RCover.Code) as Code, Max(RateTab.Description) as Coverage from RCover, RateTab Where RateTab.Code=RCover.Code and RCover.Category='M' Group By RCover.ANO) RCover on (RCover.ANO=Acceptance.ANO)    
Left join TOPRO on (TOPRO.TOPRO=Acceptance.TOPRO)  
Inner Join Cover on (Cover.CNO=Acceptance.CNO) inner join TOC on (TOC.TOC=Cover.TOC) inner join Profile on (Profile.ID=Cover.PHolder) inner join SysUser on (SysUser.ID=Cover.MO) inner join Branch on (Branch.Branch=Acceptance.Branch)    
Left Join PCalc on (PCalc.ANO=Acceptance.ANO)    
WHERE ACCEPTANCE.ATYPE Not In ('A','C') And ACCEPTANCE.ASTATUS<>'W' And ACCEPTANCE.PDATE<>ACCEPTANCE.PPDATE    
And Cover.MO like @P_MO and Cover.Segment Like @P_Segment    
And Acceptance.Branch Like @P_Branch and ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO    
--And Acceptance.ANO<>Acceptance.LANO    
ORDER BY ACCEPTANCE.ANO DESC    


GO

-- Perbaikan inquiry PUserdate
DROP PROCEDURE [dbo].[CLLIST01]
GO
CREATE PROCEDURE [dbo].[CLLIST01](@P_dbUser as varchar(10)) AS

SELECT  Cast(0 as bit) as ProcessFlag,

 [CLAIM].[CLAIMNO],

 [CLAIM].[REGDATE],

 [CLAIM].[REFNO],

 [CLAIM].[COL],

 [COLTAB].[DESCRIPTION],

 [CLAIM].[LOSSDATE],
 CLAIM.puserdate,  

 [CLAIM].[TOC],

 [CLAIM].[CSDATE],

 [CLAIM].[LOSSPLACE],

 [CLAIM].[CTYPE],

 [CLAIM].[CSTATUS],

 [CLAIM].[CNO],

 [CLAIM].[ANO],

 [CLAIM].[PCNO],

 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] AS USERID,

 [SYSTAB].[CURRENCY],

 [CCALC].[LOSS] AS ESTIMATE,

 [CCALC].[CLAIM] AS CLAIM,

 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,

 [CCALC].[SALVAGE] AS SALVAGE,

 [CCALC].[COST] AS COST,

 [CCALC].[SUBROGATION] AS SUBROGATION,

 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,

 [CLAIM].[VSEQNO],

 [CLAIM].[CSEQNO],

 ACCEPTANCE.ANAME,

 CLAIM.POLICYNO,

 CLAIM.CERTIFICATENO,

 CLAIM.SETTLEDF

FROM  CLAIM LEFT JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO), QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB

Where [CARRHEADER].[CNO] = [CLAIM].[CNO]

 And [CCALC].[CNO]=[CLAIM].[CNO]

 And CLAIM.COL=COLTAB.COL

 And [CLAIM].[CSTATUS]='R'

 AND CLAIM.LUSERID LIKE @P_DBUSER




GO


DROP PROCEDURE [dbo].[CLLIST02_1]
GO
CREATE PROCEDURE [dbo].[CLLIST02_1](@pSDate as smalldatetime,@pEDate as smalldatetime,@pBranch as varchar(10))    
AS    
SELECT Cast(0 as bit) as ProcessFlag,    
[CLAIM].[CLAIMNO],    
[CLAIM].[REGDATE],    
[CLAIM].[REFNO],    
[CLAIM].[COL],    
[COLTAB].[DESCRIPTION],    
[CLAIM].[LOSSDATE],    
[CLAIM].[TOC],    
[CLAIM].[CSDATE],    
[CLAIM].[PUSERDATE],   
[CLAIM].[LOSSPLACE],    
[CLAIM].[CTYPE],    
[CLAIM].[CSTATUS],    
[CLAIM].[CNO],    
[CLAIM].[ANO],    
[CLAIM].[PCNO],    
[CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,    
[SYSTAB].[CURRENCY],    
[CCALC].[LOSS] AS ESTIMATE,    
[CCALC].[CLAIM] AS CLAIM,    
[CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,    
[CCALC].[SALVAGE] AS SALVAGE,    
[CCALC].[COST] AS COST,    
[CCALC].[SUBROGATION] AS SUBROGATION,    
([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,    
[CLAIM].[VSEQNO],    
[CLAIM].[CSEQNO],    
acceptance.aname,    
acceptance.policyno,    
acceptance.certificateno,    
CLAIM.SETTLEDF    
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance    
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]    
And [CCALC].[CNO]=[CLAIM].[CNO]    
And [CLAIM].[CSTATUS]='A'    
And CLAIM.SETTLEDF=1    
And CLAIM.COL=COLTAB.COL    
And [CLAIM].[CSDATE] Between @pSDATE And @pEDATE    
And [Claim].[Branch] like @pBranch+'%'  
and acceptance.ano = claim.ano    






GO





DROP PROCEDURE [dbo].[CLLIST02]
GO
CREATE PROCEDURE [dbo].[CLLIST02](@pSDate as smalldatetime,@pEDate as smalldatetime)
AS
SELECT Cast(0 as bit) as ProcessFlag,
 [CLAIM].[CLAIMNO],
 [CLAIM].[REGDATE],
 [CLAIM].[REFNO],
 [CLAIM].[COL],
 [COLTAB].[DESCRIPTION],
 [CLAIM].[LOSSDATE],
 [CLAIM].[TOC],
 [CLAIM].[CSDATE],
 [CLAIM].[PUSERDATE],

 [CLAIM].[LOSSPLACE],
 [CLAIM].[CTYPE],
 [CLAIM].[CSTATUS],
 [CLAIM].[CNO],
 [CLAIM].[ANO],
 [CLAIM].[PCNO],
 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,
 [SYSTAB].[CURRENCY],
 [CCALC].[LOSS] AS ESTIMATE,
 [CCALC].[CLAIM] AS CLAIM,
 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,
 [CCALC].[SALVAGE] AS SALVAGE,
 [CCALC].[COST] AS COST,
 [CCALC].[SUBROGATION] AS SUBROGATION,
 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,
 [CLAIM].[VSEQNO],
 [CLAIM].[CSEQNO],
 acceptance.aname,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]
 And [CCALC].[CNO]=[CLAIM].[CNO]
 And [CLAIM].[CSTATUS]='A'
 And CLAIM.SETTLEDF=1
 And CLAIM.COL=COLTAB.COL
 And [CLAIM].[CSDATE] Between @pSDATE And @pEDATE
 and acceptance.ano = claim.ano




GO



DROP PROCEDURE [dbo].[CLLIST03]
GO


CREATE PROCEDURE [dbo].[CLLIST03] AS

SELECT Cast(0 as bit) as ProcessFlag,

 [CLAIM].[CLAIMNO],

 [CLAIM].[REGDATE],

 [CLAIM].[REFNO],

 [CLAIM].[COL],

 [COLTAB].[DESCRIPTION],

 [CLAIM].[LOSSDATE],
  [CLAIM].[PuserDATE],

 [CLAIM].[TOC],

 [CLAIM].[CSDATE],

 [CLAIM].[LOSSPLACE],

 [CLAIM].[CTYPE],

 [CLAIM].[CSTATUS],

 [CLAIM].[CNO],

 [CLAIM].[ANO],

 [CLAIM].[PCNO],

 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,

 [SYSTAB].[CURRENCY],

 [CCALC].[LOSS] AS ESTIMATE,

 [CCALC].[CLAIM] AS CLAIM,

 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,

 [CCALC].[SALVAGE] AS SALVAGE,

 [CCALC].[COST] AS COST,

 [CCALC].[SUBROGATION] AS SUBROGATION,

 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,

 [CLAIM].[VSEQNO],

 [CLAIM].[CSEQNO],

 acceptance.aname,

 acceptance.policyno,

 acceptance.certificateno,

 CLAIM.SETTLEDF

FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance

Where [CARRHEADER].[CNO] = [CLAIM].[CNO]

 And [CCALC].[CNO]=[CLAIM].[CNO]

 And CLAIM.COL=COLTAB.COL

 And [CLAIM].[CSTATUS]='T'

 and acceptance.ano=claim.ano







GO


DROP PROCEDURE [dbo].[CLLIST04]
GO


CREATE PROCEDURE [dbo].[CLLIST04](@P_DBUSER AS VARCHAR(10)) AS

SELECT Cast(0 as bit) as ProcessFlag,

 [CLAIM].[CLAIMNO],

 [CLAIM].[REGDATE],

 [CLAIM].[REFNO],

 [CLAIM].[COL],

 [COLTAB].[DESCRIPTION],

 [CLAIM].[LOSSDATE],

 [CLAIM].[TOC],

 [CLAIM].[CSDATE],
  CLAIM.puserdate,  

 [CLAIM].[LOSSPLACE],

 [CLAIM].[CTYPE],

 [CLAIM].[CSTATUS],

 [CLAIM].[CNO],

 [CLAIM].[ANO],

 [CLAIM].[PCNO],

 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,

 [SYSTAB].[CURRENCY],

 [CCALC].[LOSS] AS ESTIMATE,

 [CCALC].[CLAIM] AS CLAIM,

 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,

 [CCALC].[SALVAGE] AS SALVAGE,

 [CCALC].[COST] AS COST,

 [CCALC].[SUBROGATION] AS SUBROGATION,

 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,

 [CLAIM].[VSEQNO],

 [CLAIM].[CSEQNO],

 ACCEPTANCE.ANAME,

 CLAIM.POLICYNO,

 CLAIM.CERTIFICATENO,

 CLAIM.SETTLEDF

FROM  CLAIM LEFT JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO), QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB

Where [CARRHEADER].[CNO] = [CLAIM].[CNO]

 And [CCALC].[CNO]=[CLAIM].[CNO]

 And CLAIM.COL=COLTAB.COL

 And [CLAIM].[CSTATUS]='P'

 AND CLAIM.LUSERID LIKE @P_DBUSER





GO






DROP PROCEDURE [dbo].[CLLIST05]
GO

CREATE PROCEDURE [dbo].[CLLIST05] AS

SELECT Cast(0 as bit) as ProcessFlag,

 CLAIM.CLAIMNO,

 CLAIM.REGDATE,

 CLAIM.REFNO,

 CLAIM.COL,

 COLTAB.DESCRIPTION,

 CLAIM.LOSSDATE,

 CLAIM.TOC,

 CLAIM.CSDATE,
  [CLAIM].[PuserDATE],

 CLAIM.LOSSPLACE,

 CLAIM.CTYPE,

 CLAIM.CSTATUS,

 CLAIM.CNO,

 CLAIM.ANO,

 CLAIM.PCNO,

 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,

 SYSTAB.CURRENCY,

 CCALC.LOSS AS ESTIMATE,

 CCALC.CLAIM AS CLAIM,

 CCALC.DEDUCTIBLE AS DEDUCTIBLE,

 CCALC.SALVAGE AS SALVAGE,

 CCALC.COST AS COST,

 CCALC.SUBROGATION AS SUBROGATION,

 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,

 CLAIM.VSEQNO,

 CLAIM.CSEQNO,

 acceptance.aname,

 acceptance.policyno,

 acceptance.certificateno,

 CLAIM.SETTLEDF

FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance

Where CARRHEADER.CNO = CLAIM.CNO

 And CCALC.CNO=CLAIM.CNO

 And CLAIM.COL=COLTAB.COL

 And acceptance.ano=claim.ano

 And CLAIM.REGDATE<=getdate() AND CLAIM.CTYPE<>'C' AND CLAIM.CSTATUS<>'R' AND

 ((CLAIM.SETTLEDF=0 AND CLAIM.CSDATE<=getdate() AND CLAIM.CSTATUS<>'C') OR

              (CLAIM.PSETTLEDF=0 AND CLAIM.CSDATE>getdate() AND (CLAIM.SETTLEDF=0 OR CLAIM.ADATE>getdate())))

  



GO



DROP PROCEDURE [dbo].[CLLIST06]
GO

CREATE PROCEDURE [dbo].[CLLIST06] AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 ACCEPTANCE.ANAME,
 CLAIM.POLICYNO,
 CLAIM.CERTIFICATENO,
 CLAIM.SETTLEDF
FROM  CLAIM LEFT JOIN COLTAB ON (COLTAB.COL=CLAIM.COL) LEFT JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO), QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And (CLAIM.TBAF_1=1 Or CLAIM.TBAF_2=1)
  


GO



DROP PROCEDURE [dbo].[CLLIST07]
GO

CREATE PROCEDURE [dbo].[CLLIST07] (@P_EVENTNO AS VARCHAR(255),@P_RYEAR AS INTEGER)
AS
SELECT Cast(0 as bit) as ProcessFlag,
 [CLAIM].[CLAIMNO],
  [CLAIM].[REGDATE],
  [CLAIM].[REFNO],
  [CLAIM].[COL],
  [COLTAB].[DESCRIPTION],
  [CLAIM].[LOSSDATE],
  [CLAIM].[TOC],
  [CLAIM].[CSDATE],
    [CLAIM].[PUSERDATE],
  [CLAIM].[LOSSPLACE],
  [CLAIM].[CTYPE],
  [CLAIM].[CSTATUS],
  [CLAIM].[CNO],
  [CLAIM].[ANO],
  [CLAIM].[PCNO],
  [CLAIM].[LUSERID] + '/' + CLAIM.AUSERID as USERID,
  [SYSTAB].[CURRENCY],
  [CCALC].[LOSS] AS ESTIMATE,
  [CCALC].[CLAIM] AS CLAIM,
  [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,
  [CCALC].[SALVAGE] AS SALVAGE,
  [CCALC].[COST] AS COST,
  [CCALC].[SUBROGATION] AS SUBROGATION,
  ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,
  [CLAIM].[VSEQNO],
  [CLAIM].[CSEQNO],
  acceptance.aname,
  acceptance.policyno,
  acceptance.certificateno,
  CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]
  And [CCALC].[CNO]=[CLAIM].[CNO]
  And CLAIM.COL=COLTAB.COL
  And [CLAIM].[EVENTNO]=@P_EVENTNO
  And YEAR([CARRHEADER].[RDATE])=@P_RYEAR
  And [CARRHEADER].[STATUS]='A'
  and acceptance.ano = claim.ano
  



GO



DROP PROCEDURE [dbo].[CLLIST08]
GO

CREATE PROCEDURE [dbo].[CLLIST08] AS

SELECT Cast(0 as bit) as ProcessFlag,

 [CLAIM].[CLAIMNO],

 [CLAIM].[REGDATE],

 [CLAIM].[REFNO],

 [CLAIM].[COL],

 [COLTAB].[DESCRIPTION],

 [CLAIM].[LOSSDATE],

 [CLAIM].[TOC],

 [CLAIM].[CSDATE],
  [CLAIM].[PuserDATE],

 [CLAIM].[LOSSPLACE],

 [CLAIM].[CTYPE],

 [CLAIM].[CSTATUS],

 [CLAIM].[CNO],

 [CLAIM].[ANO],

 [CLAIM].[PCNO],

 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,

 [SYSTAB].[CURRENCY],

 [CCALC].[LOSS] AS ESTIMATE,

 [CCALC].[CLAIM] AS CLAIM,

 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,

 [CCALC].[SALVAGE] AS SALVAGE,

 [CCALC].[COST] AS COST,

 [CCALC].[SUBROGATION] AS SUBROGATION,

 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,

 [CLAIM].[VSEQNO],

 [CLAIM].[CSEQNO],

 acceptance.aname,

 acceptance.policyno,

 acceptance.certificateno,

 CLAIM.SETTLEDF

FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance

Where [CARRHEADER].[CNO] = [CLAIM].[CNO]

 And [CCALC].[CNO]=[CLAIM].[CNO]

 And CLAIM.COL=COLTAB.COL

 And [CLAIM].[CSTATUS]='A'

 And Claim.Settledf=0

 and acceptance.ano = claim.ano





GO



DROP PROCEDURE [dbo].[CLLIST09]
GO

CREATE PROCEDURE [dbo].[CLLIST09] AS
SELECT Cast(0 as bit) as ProcessFlag,
 [CLAIM].[CLAIMNO],
 [CLAIM].[REGDATE],
 [CLAIM].[REFNO],
 [CLAIM].[COL],
 [COLTAB].[DESCRIPTION],
 [CLAIM].[LOSSDATE],
 [CLAIM].[TOC],
 [CLAIM].[CSDATE],
  [CLAIM].[PUSERDATE],
 [CLAIM].[LOSSPLACE],
 [CLAIM].[CTYPE],
 [CLAIM].[CSTATUS],
 [CLAIM].[CNO],
 [CLAIM].[ANO],
 [CLAIM].[PCNO],
 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,
 [SYSTAB].[CURRENCY],
 [CCALC].[LOSS] AS ESTIMATE,
 [CCALC].[CLAIM] AS CLAIM,
 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,
 [CCALC].[SALVAGE] AS SALVAGE,
 [CCALC].[COST] AS COST,
 [CCALC].[SUBROGATION] AS SUBROGATION,
 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,
 [CLAIM].[VSEQNO],
 [CLAIM].[CSEQNO],
 acceptance.aname,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]
 And [CCALC].[CNO]=[CLAIM].[CNO]
 And CLAIM.COL=COLTAB.COL
 And [CLAIM].[CSTATUS]='P'
 And [CLAIM].[VSEQNO]<>0
 and acceptance.ano = claim.ano
  



GO



DROP PROCEDURE [dbo].[CLLIST10]
GO

CREATE PROCEDURE [dbo].[CLLIST10] AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.PUSERDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 acceptance.aname,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And CLAIM.COL=COLTAB.COL
 And CLAIM.CSTATUS='P'
 And CLAIM.CSEQNO<>0
 and acceptance.ano=claim.ano




GO



DROP PROCEDURE [dbo].[CLLIST11]
GO

CREATE PROCEDURE [dbo].[CLLIST11] AS    

SELECT Cast(0 as bit) as ProcessFlag,    

 [CLAIM].[CLAIMNO],    

 [CLAIM].[REGDATE],    

 [CLAIM].[REFNO],    

 [CLAIM].[COL],    

 [COLTAB].[DESCRIPTION],    

 [CLAIM].[LOSSDATE],    

 [CLAIM].[TOC],    

 [CLAIM].[CSDATE],   
  [CLAIM].[PuserDATE],

 [CLAIM].[LOSSPLACE],    

 [CLAIM].[CTYPE],    

 [CLAIM].[CSTATUS],    

 [CLAIM].[CNO],    

 [CLAIM].[ANO],    

 [CLAIM].[PCNO],    

 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,    

 [SYSTAB].[CURRENCY],    

 [CCALC].[LOSS] AS ESTIMATE,    

 [CCALC].[CLAIM] AS CLAIM,    

 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,    

 [CCALC].[SALVAGE] AS SALVAGE,    

 [CCALC].[COST] AS COST,    

 [CCALC].[SUBROGATION] AS SUBROGATION, ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,    

 [CLAIM].[VSEQNO],    

 [CLAIM].[CSEQNO],    

 acceptance.aname,    

 acceptance.policyno,    

 acceptance.certificateno,    

 CLAIM.SETTLEDF    

FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER, CLAIM AS C1,COLTAB,acceptance    

Where [CARRHEADER].[CNO] = [CLAIM].[CNO]    

 And [CCALC].[CNO]=[CLAIM].[CNO]    

 And CLAIM.COL=COLTAB.COL    

 And [CLAIM].[CNO]=C1.PCNO    

 And C1.CSTATUS='P'    

 And C1.VSEQNO<>0    

 and acceptance.ano=claim.ano    



GO



DROP PROCEDURE [dbo].[CLLIST12]
GO

CREATE PROCEDURE [dbo].[CLLIST12] AS

SELECT Cast(0 as bit) as ProcessFlag,

 CLAIM.CLAIMNO,

 CLAIM.REGDATE,

 CLAIM.REFNO,

 CLAIM.COL,

 COLTAB.DESCRIPTION,

 CLAIM.LOSSDATE,

 CLAIM.TOC,

 CLAIM.CSDATE,
  [CLAIM].[PuserDATE],

 CLAIM.LOSSPLACE,

 CLAIM.CTYPE,

 CLAIM.CSTATUS,

 CLAIM.CNO,

 CLAIM.ANO,

 CLAIM.PCNO,

 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,

 SYSTAB.CURRENCY,

 CCALC.LOSS AS ESTIMATE,

 CCALC.CLAIM AS CLAIM,

 CCALC.DEDUCTIBLE AS DEDUCTIBLE,

 CCALC.SALVAGE AS SALVAGE,

 CCALC.COST AS COST,

 CCALC.SUBROGATION AS SUBROGATION,

 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,

 CLAIM.VSEQNO,

 CLAIM.CSEQNO,

 acceptance.aname,

 acceptance.policyno,

 acceptance.certificateno,

 CLAIM.SETTLEDF

FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER, CLAIM AS C1,COLTAB,acceptance

Where CARRHEADER.CNO = CLAIM.CNO

 And CCALC.CNO=CLAIM.CNO

 And CLAIM.COL=COLTAB.COL

 And CLAIM.CNO=C1.PCNO

 And C1.CSTATUS='P'

 And C1.CSEQNO<>0

 and acceptance.ano = claim.ano





GO



DROP PROCEDURE [dbo].[CLLIST15]
GO

CREATE PROCEDURE [dbo].[CLLIST15] AS

SELECT Cast(0 as bit) as ProcessFlag,

 [CLAIM].[CLAIMNO],

 [CLAIM].[REGDATE],

 [CLAIM].[REFNO],

 [CLAIM].[COL],

 [COLTAB].[DESCRIPTION],

 [CLAIM].[LOSSDATE],

 [CLAIM].[TOC],

 [CLAIM].[CSDATE],
 [CLAIM].[PuserDATE],
 [CLAIM].[LOSSPLACE],

 [CLAIM].[CTYPE],

 [CLAIM].[CSTATUS],

 [CLAIM].[CNO],

 [CLAIM].[ANO],

 [CLAIM].[PCNO],

 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,

 [SYSTAB].[CURRENCY],

 [CCALC].[LOSS] AS ESTIMATE,

 [CCALC].[CLAIM] AS CLAIM,

 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,

 [CCALC].[SALVAGE] AS SALVAGE,

 [CCALC].[COST] AS COST,

 [CCALC].[SUBROGATION] AS SUBROGATION,

 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,

 [CLAIM].[VSEQNO],

 [CLAIM].[CSEQNO],

 acceptance.aname,

 acceptance.policyno,

 acceptance.certificateno,

 CLAIM.SETTLEDF

FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance

Where [CARRHEADER].[CNO] = [CLAIM].[CNO]

 And [CCALC].[CNO]=[CLAIM].[CNO]

 And CLAIM.COL=COLTAB.COL

 And Acceptance.ANO=Claim.ANO

 And CLAIM.CNO  in

  

(Select CLLOSS.CNO  from CLLOSS, ICOVER, DOCLIST Where

 ICOVER.INO=CLLOSS.INO and CLLOSS.CNO=CLAIM.CNO and DOCLIST.NOC=CLLOSS.NOC and DOCLIST.TOI=ICOVER.TOI and DOCLIST.DOCTYPE Not in

 (Select DocType from CDOCLIST Where CDOCLIST.CNO=CLAIM.CNO and CDOCLIST.INO=CLLOSS.INO and CDOCLIST.NOC=CLLOSS.NOC and CDOCLIST.DOCTYPE=DOCLIST.DOCTYPE))

  



GO


DROP PROCEDURE [dbo].[CLLIST16]
GO

CREATE PROCEDURE [dbo].[CLLIST16] AS

SELECT Cast(0 as bit) as ProcessFlag,

 [CLAIM].[CLAIMNO],

 [CLAIM].[REGDATE],

 [CLAIM].[REFNO],

 [CLAIM].[COL],

 [COLTAB].[DESCRIPTION],

 [CLAIM].[LOSSDATE],

 [CLAIM].[TOC],

 [CLAIM].[CSDATE],
  [CLAIM].[PuserDATE],

 [CLAIM].[LOSSPLACE],

 [CLAIM].[CTYPE],

 [CLAIM].[CSTATUS],

 [CLAIM].[CNO],

 [CLAIM].[ANO],

 [CLAIM].[PCNO],

 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,

 [SYSTAB].[CURRENCY],

 [CCALC].[LOSS] AS ESTIMATE,

 [CCALC].[CLAIM] AS CLAIM,

 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,

 [CCALC].[SALVAGE] AS SALVAGE,

 [CCALC].[COST] AS COST,

 [CCALC].[SUBROGATION] AS SUBROGATION,

 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,

 [CLAIM].[VSEQNO],

 [CLAIM].[CSEQNO],

 acceptance.aname,

 acceptance.policyno,

 acceptance.certificateno,

 CLAIM.SETTLEDF

FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance

Where [CARRHEADER].[CNO] = [CLAIM].[CNO]

 And [CCALC].[CNO]=[CLAIM].[CNO]

 And CLAIM.COL=COLTAB.COL

 And [CLAIM].[REQUESTF]=1

 and acceptance.ano=claim.ano

  



GO




DROP PROCEDURE [dbo].[CLLIST17]
GO


CREATE PROCEDURE [dbo].[CLLIST17] (@P_USERID as varchar(255),@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_CStatus as varchar(1))     

AS    

SELECT Cast(0 as bit) as ProcessFlag,    

[CLAIM].[CLAIMNO],    

[CLAIM].[REGDATE],    

[CLAIM].[REFNO],    

[CLAIM].[COL],    

[COLTAB].[DESCRIPTION],    

[CLAIM].[LOSSDATE],    

[CLAIM].[TOC],    

[CLAIM].[CSDATE],    

[CLAIM].[PUSERDATE],    

[CLAIM].[LOSSPLACE],    

[CLAIM].[CTYPE],    

[CLAIM].[CSTATUS],    

[CLAIM].[CNO],    

[CLAIM].[ANO],    

[CLAIM].[PCNO],    

[CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,    

[SYSTAB].[CURRENCY],    

[CCALC].[LOSS] AS ESTIMATE,    

[CCALC].[CLAIM] AS CLAIM,    

[CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,    

[CCALC].[SALVAGE] AS SALVAGE,    

[CCALC].[COST] AS COST,    

[CCALC].[SUBROGATION] AS SUBROGATION,    

([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,    

[CLAIM].[VSEQNO],    

[CLAIM].[CSEQNO],    

acceptance.aname,    

acceptance.policyno,    

acceptance.certificateno,    

CLAIM.SETTLEDF    

FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance    

Where [CARRHEADER].[CNO] = [CLAIM].[CNO]    

And [CCALC].[CNO]=[CLAIM].[CNO]    

And CLAIM.COL=COLTAB.COL    

And Acceptance.ANO=Claim.ANO  

And Claim.LUserID Like @P_UserID      

And Claim.LDate Between @P_SDate and @P_EDate

And (Claim.CStatus=@P_CStatus or @P_CStatus='')


GO



DROP PROCEDURE [dbo].[CLLISTSR]
GO

CREATE PROCEDURE [dbo].[CLLISTSR](@P_ID as int)  

AS  

SELECT  Cast(0 as bit) as ProcessFlag,  

 CLAIM.CLAIMNO,  

 CLAIM.REGDATE,  

 CLAIM.REFNO,  

 CLAIM.COL,  

 COLTAB.DESCRIPTION,  

 CLAIM.LOSSDATE,  

 CLAIM.TOC,  

 CLAIM.CSDATE,  
  [CLAIM].[PuserDATE],

 CLAIM.LOSSPLACE,  

 CLAIM.CTYPE,  

 CLAIM.CSTATUS,  

 CLAIM.CNO,  

 CLAIM.ANO,  

 CLAIM.PCNO,  

 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,  

 SYSTAB.CURRENCY,  

 CCALC.LOSS AS ESTIMATE,  

 CCALC.CLAIM AS CLAIM,  

 CCALC.DEDUCTIBLE AS DEDUCTIBLE,  

 CCALC.SALVAGE AS SALVAGE,  

 CCALC.COST AS COST,  

 CCALC.SUBROGATION AS SUBROGATION,  

 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,  

 CLAIM.VSEQNO,  

 CLAIM.CSEQNO,  

 acceptance.aname,  

 Claim.policyno,  

 Claim.certificateno,  

 CLAIM.SETTLEDF  

FROM  CLAIM Left Join CArrHeader on (CarrHeader.CNO=Claim.CNO)  

Left Join QClaim_CCalc() as CCalc on (CCalc.CNO=Claim.CNO)  

Left Join Acceptance on (Acceptance.ANO=Claim.ANO)  

inner join COLTAB on (COLTAB.COL=CLAIM.COL)  

, SYSTAB, SysRequest  

WHERE SysRequest.ID=@P_ID  

 And SysRequest.Param2 in ('MAR','UND','CLM')  

 And ((SysRequest.Param4=Claim.CNO and SysRequest.Param2='CLM') or (SysRequest.Param3=Claim.ANO and SysRequest.Param2 in ('MAR','UND')))  

    

GO


