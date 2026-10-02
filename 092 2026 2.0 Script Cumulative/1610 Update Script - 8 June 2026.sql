/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ISType' AND Object_ID = Object_ID(N'ACCEPTANCE'))

ALTER TABLE dbo.ACCEPTANCE ADD
	ISType varchar(1) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Insurance Source Type (see ISTYPE)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCEPTANCE', N'COLUMN', N'ISType'
GO
UPDATE Acceptance set ISType=Cover.ISType from Acceptance, Cover Where Acceptance.CNO=COVER.CNO and Acceptance.ISType is null
GO
COMMIT
GO
DROP Procedure qPolicy_Data
GO
CREATE Procedure qPolicy_Data(@P_ANO integer)                                    
as                                    
SELECT                                    
C.CNO, C.COVERNO, A1.TOC, C.MO, C.SEGMENT, A1.Location, C.VALIDATION, C.REFNO as CREFNO, C.PRORATA, C.PHOLDER, C.PPERIOD, C.CStatus,                                    
A1.ASource, P.ID as PayorID, A1.ISType, C.OpenFlag, C.Voyage, C.PolicyType, C.VSeqNo, C.TBAF,          
A1.ANO, A1.OANO, A1.LANO, A1.CANO, A1.PANO, A1.RANO, A1.REGNO, A1.REGDATE, A1.BRANCH, A1.CT, A1.AStatus, A1.ATYPE, A1.POLICYNO, A1.POLICYDATE, A1.CPOLICYNO, A1.REFNO, A1.REFDATE, A1.RENEWABLEF, A1.CONJUNCTIONF, A1.EXCLUSIVEF, 
A1.SDATE, A1.EDATE, A1.STIME, A1.ETIME,         
A1.NCDate,          
A1.REMARKS, A1.EXTPERIOD, A1.ExtPeriodInDaysF, A1.ADATE, A1.PDATE, A1.PPDATE, A1.AID, A1.ANAME, A1.BUSINESS, A1.TOPRO, A1.Ujroh, A1.WeightedAvgUjrohF,                           
A1.ESeqNo, A1.EESeqNo, A1.Renewal, A1.BatchNo, A1.BankersID, A1.BankersClause,               
C.PUserID, C.PUserDate, C.PUserTime,                           
C.AUSERID as CAUserID, C.AUserDate as CAUserDate, C.AUserTime as CAUserTime,                        
C.CUSERID as CCUserID, C.CLOSEDATE as CCLOSEDATE, C.CloseTime as CCloseTime,    
A1.UserID, A1.CDate, A1.CTime,                                   
A1.CUserID, A1.CloseDate, A1.CloseTime,                             
A1.LUSERID, A1.LDate, A1.LTime,     
A1.RUSERID, A1.RUserDate, A1.RUserTime,                  
A1.AUSERID, A1.AUserDate, A1.AUserTime,                
CACCEPTANCE.REGNO as CREGNO,              
CCOVER.COVERNO AS CCOVERNO, A1.PWordingID,                   
A1.CPCT, A1.SYSUSERID, A1.BizMapID, A1.MSCode, A1.BID,
Interest.Currency, Interest.TSI, Interest.ATSI,          
Premium.Gross/Premium.NumRisk as Premium,
ICoverPol.CURRENCY as Currency_POL, ICoverPol.Amount as Amount_POL,
A2.FLDID1, A2.VALUEID1, A2.VALUEDESC1, 0 as FLDSEARCH1,                                    
A2.FLDID2, A2.VALUEID2, A2.VALUEDESC2, 0 as FLDSEARCH2,                                    
A2.FLDID3, A2.VALUEID3, A2.VALUEDESC3, 0 as FLDSEARCH3,                                    
A2.FLDID4, A2.VALUEID4, A2.VALUEDESC4, 0 as FLDSEARCH4,                                    
A2.FLDID5, A2.VALUEID5, A2.VALUEDESC5, 0 as FLDSEARCH5,                                    
A2.FLDID6, A2.VALUEID6, A2.VALUEDESC6, 0 as FLDSEARCH6,                                    
A2.FLDID7, A2.VALUEID7, A2.VALUEDESC7, 0 as FLDSEARCH7,                                    
A2.FLDID8, A2.VALUEID8, A2.VALUEDESC8, 0 as FLDSEARCH8,                                    
A2.FLDID9, A2.VALUEID9, A2.VALUEDESC9, 0 as FLDSEARCH9,                                    
A2.FLDID10, A2.VALUEID10, A2.VALUEDESC10, 0 as FLDSEARCH10,                                    
A2.FLDID11, A2.VALUEID11, A2.VALUEDESC11, 0 as FLDSEARCH11,                                    
A2.FLDID12, A2.VALUEID12, A2.VALUEDESC12, 0 as FLDSEARCH12,                                    
A2.FLDID13, A2.VALUEID13, A2.VALUEDESC13, 0 as FLDSEARCH13,                                    
A2.FLDID14, A2.VALUEID14, A2.VALUEDESC14, 0 as FLDSEARCH14,                                    
A2.FLDID15, A2.VALUEID15, A2.VALUEDESC15, 0 as FLDSEARCH15                                    
FROM COVER C                        
INNER JOIN ACCEPTANCE A1 ON (C.CNO=A1.CNO)                         
INNER JOIN PAYOR P on (P.ANO=A1.ANO)
LEFT JOIN ACCEPTANCE CACCEPTANCE ON (CACCEPTANCE.ANO=A1.CANO)                        
LEFT JOIN COVER CCOVER ON (CCOVER.CNO=CACCEPTANCE.CNO)                        
Left Join AINFO A2 On (A2.ANO=A1.ANO)                         
Left Join FN_SumInsured(@P_ANO) Interest On (Interest.ANO=A1.ANO and Interest.TSI<>0)                  
Left Join FN_PCalc(@P_ANO) Premium on (Premium.ANO=A1.ANO)
Left Join ICoverPOL on (ICoverPOL.ANO=A1.ANO)
WHERE A1.ANO=@P_ANO 


GO

DROP Procedure QCertificate_Data
GO
CREATE Procedure QCertificate_Data(@P_ANO integer)                                  
as                                  
SELECT                                  
A1.ANO, C.CNO, A1.OANO, A1.LANO, A1.CANO, A1.RANO, A1.REGNO, A1.REGDATE, A1.BRANCH, A1.CT, A1.ATYPE, A1.AStatus, A1.POLICYNO, A1.CERTIFICATENO, A1.POLICYDATE, A1.CPOLICYNO, A1.REFNO, A1.REFDATE, A1.RENEWABLEF, A1.CONJUNCTIONF, A1.EXCLUSIVEF, 
C.COVERNO, C.SEGMENT, A1.ISType, C.OpenFlag, C.Voyage, C.PolicyType, C.PPeriod,
A1.SDATE, A1.EDATE, A1.STIME, A1.ETIME,           
A1.NCDate,            
A1.EXTPERIOD, A1.EXTPERIODINDAYSF,            
A1.ASource, A1.TOC, C.MO, A1.Location,                   
A1.Remarks, A1.ADate, A1.PDate, A1.PPDate, A1.AID, A1.ANAME,A1.BUSINESS, A1.DISCOUNT, A1.QTY, A1.TOPRO, A1.Ujroh, A1.WeightedAvgUjrohF,      
A1.ERSeqNo, A1.ESeqNo, A1.EESeqNo, A1.Renewal, A1.BatchNo, A1.BankersID, A1.BankersClause,         
A1.UserID, A1.CDate, A1.CTime,                                   
A1.CUserID, A1.CloseDate, A1.CloseTime,                             
A1.LUSERID, A1.LDate, A1.LTime,     
A1.RUSERID, A1.RUserDate, A1.RUserTime,                  
A1.AUSERID, A1.AUserDate, A1.AUserTime,                  
CACCEPTANCE.REGNO as CREGNO, 
CCOVER.COVERNO AS CCOVERNO, A1.PWordingID,     
A1.CPCT, A1.SYSUSERID, A1.BizMapID, A1.MSCode, A1.BID,
Interest.Currency, Interest.TSI, Interest.ATSI,                   
Premium.Gross/Premium.NumRisk as Premium,
A2.FLDID1, A2.VALUEID1, A2.VALUEDESC1, 0 as FLDSEARCH1,                                  
A2.FLDID2, A2.VALUEID2, A2.VALUEDESC2, 0 as FLDSEARCH2,                                  
A2.FLDID3, A2.VALUEID3, A2.VALUEDESC3, 0 as FLDSEARCH3,                                  
A2.FLDID4, A2.VALUEID4, A2.VALUEDESC4, 0 as FLDSEARCH4,                                  
A2.FLDID5, A2.VALUEID5, A2.VALUEDESC5, 0 as FLDSEARCH5,                                  
A2.FLDID6, A2.VALUEID6, A2.VALUEDESC6, 0 as FLDSEARCH6,                                  
A2.FLDID7, A2.VALUEID7, A2.VALUEDESC7, 0 as FLDSEARCH7,                                  
A2.FLDID8, A2.VALUEID8, A2.VALUEDESC8, 0 as FLDSEARCH8,                                  
A2.FLDID9, A2.VALUEID9, A2.VALUEDESC9, 0 as FLDSEARCH9,                                  
A2.FLDID10, A2.VALUEID10, A2.VALUEDESC10, 0 as FLDSEARCH10,                                  
A2.FLDID11, A2.VALUEID11, A2.VALUEDESC11, 0 as FLDSEARCH11,                                  
A2.FLDID12, A2.VALUEID12, A2.VALUEDESC12, 0 as FLDSEARCH12,                                  
A2.FLDID13, A2.VALUEID13, A2.VALUEDESC13, 0 as FLDSEARCH13,                                  
A2.FLDID14, A2.VALUEID14, A2.VALUEDESC14, 0 as FLDSEARCH14,                                  
A2.FLDID15, A2.VALUEID15, A2.VALUEDESC15, 0 as FLDSEARCH15              
FROM ACCEPTANCE A1                     
Inner Join Cover C On (C.CNO=A1.CNO)                 
LEFT JOIN ACCEPTANCE CACCEPTANCE ON (CACCEPTANCE.ANO=A1.CANO)                    
LEFT JOIN COVER CCOVER ON (CCOVER.CNO=CACCEPTANCE.CNO)                    
Left Join AINFO A2 On (A2.ANO=A1.ANO)                     
Left Join FN_SumInsured(@P_ANO) Interest On (Interest.ANO=A1.ANO and Interest.TSI<>0)                            
Left Join FN_PCalc(@P_ANO) Premium on (Premium.ANO=A1.ANO)
WHERE A1.ANO=@P_ANO 





