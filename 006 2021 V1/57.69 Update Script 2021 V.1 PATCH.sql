--25 JUN 2021
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QInwardTreaty_Data]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QInwardTreaty_Data
end
GO
CREATE Procedure QInwardTreaty_Data(@P_ANO integer)            
as            
Select A1.CNO, A1.ANO, A1.RegNo, A1.Branch, A1.CT, A1.NCDate, C.Segment, C.CoverDate, C.Insured, C.ExpDate, A1.TOC, C.RefNo, C.RefDate, C.MO, R.Code, I.RType, I.CedingID, I.ID, I.Share, I.Fee as RIComm, I.UJROHCEDANT, I.UJROHREINS,    
A1.CDate,    
A1.UserID,     
A1.LDate,    
A1.LUserID,    
A1.AUserID,    
A1.AUserDate,
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
A2.FLDID15, A2.VALUEID15, A2.VALUEDESC15, 0 as FLDSEARCH15,
A3.ID as BSID, A3.Fee as BSFee, A4.ID as OtherID, A4.Fee as OtherFee
from Cover C    
Inner Join Acceptance A1 on (C.CNO=A1.CNO)    
Left Join AINFO A2 On (A2.ANO=A1.ANO) 
Left join ISource I on (I.CNO=C.CNO)    
Left Join RCover R On (R.ANO=A1.ANO)    
Left Join AccBS A3 on (A3.ANO=A1.ANO and A3.BSType='B')    
Left Join AccBS A4 on (A4.ANO=A1.ANO and A4.BSType='O')    
Where A1.ANO=@P_ANO 

GO

Update ISource Set CedingID=ID Where coalesce(CedingID,'')=''
GO
--19 AGST 2021
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
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RATE_Source' AND Object_ID = Object_ID(N'Scheme_Indemnity'))
BEGIN
ALTER TABLE dbo.Scheme_Indemnity ADD
	RATE_Source varchar(10) NULL
	end
GO
DECLARE @v sql_variant 
SET @v = N'Rate Source '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Indemnity', N'COLUMN', N'RATE_Source'
GO
COMMIT
GO
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
GO
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Scheme_Transaction ADD	
	Rate_11 float(53) NULL,
	Rate_12 float(53) NULL,
	Rate_13 float(53) NULL,
	Rate_14 float(53) NULL,
	Rate_15 float(53) NULL,
	Rate_16 float(53) NULL,
	Rate_17 float(53) NULL,
	Rate_18 float(53) NULL,
	Rate_19 float(53) NULL,
	Rate_20 float(53) NULL,
	Rate_21 float(53) NULL,
	Rate_22 float(53) NULL,
	Rate_23 float(53) NULL,
	Rate_24 float(53) NULL,
	Rate_25 float(53) NULL,
	Rate_26 float(53) NULL,
	Rate_27 float(53) NULL,
	Rate_28 float(53) NULL,
	Rate_29 float(53) NULL,
	Rate_30 float(53) NULL,
	Rate_31 float(53) NULL,
	Rate_32 float(53) NULL,
	Rate_33 float(53) NULL,
	Rate_34 float(53) NULL,
	Rate_35 float(53) NULL,
	Rate_36 float(53) NULL,
	Rate_37 float(53) NULL,
	Rate_38 float(53) NULL,
	Rate_39 float(53) NULL,
	Rate_40 float(53) NULL,
	Rate_41 float(53) NULL,
	Rate_42 float(53) NULL,
	Rate_43 float(53) NULL,
	Rate_44 float(53) NULL,
	Rate_45 float(53) NULL,
	Rate_46 float(53) NULL,
	Rate_47 float(53) NULL,
	Rate_48 float(53) NULL,
	Rate_49 float(53) NULL,
	Rate_50 float(53) NULL,
	Rate_51 float(53) NULL,
	Rate_52 float(53) NULL,
	Rate_53 float(53) NULL,
	Rate_54 float(53) NULL,
	Rate_55 float(53) NULL,
	Rate_56 float(53) NULL,
	Rate_57 float(53) NULL,
	Rate_58 float(53) NULL,
	Rate_59 float(53) NULL,
	Rate_60 float(53) NULL,
	Rate_61 float(53) NULL,
	Rate_62 float(53) NULL,
	Rate_63 float(53) NULL,
	Rate_64 float(53) NULL,
	Rate_65 float(53) NULL,
	Rate_66 float(53) NULL,
	Rate_67 float(53) NULL,
	Rate_68 float(53) NULL,
	Rate_69 float(53) NULL,
	Rate_70 float(53) NULL,
	Rate_71 float(53) NULL,
	Rate_72 float(53) NULL,
	Rate_73 float(53) NULL,
	Rate_74 float(53) NULL,
	Rate_75 float(53) NULL,
	Rate_76 float(53) NULL,
	Rate_77 float(53) NULL,
	Rate_78 float(53) NULL,
	Rate_79 float(53) NULL,
	Rate_80 float(53) NULL,
	Rate_81 float(53) NULL,
	Rate_82 float(53) NULL,
	Rate_83 float(53) NULL,
	Rate_84 float(53) NULL,
	Rate_85 float(53) NULL,
	Rate_86 float(53) NULL,
	Rate_87 float(53) NULL,
	Rate_88 float(53) NULL,
	Rate_89 float(53) NULL,
	Rate_90 float(53) NULL,
	Rate_91 float(53) NULL,
	Rate_92 float(53) NULL,
	Rate_93 float(53) NULL,
	Rate_94 float(53) NULL,
	Rate_95 float(53) NULL,
	Rate_96 float(53) NULL,
	Rate_97 float(53) NULL,
	Rate_98 float(53) NULL,
	Rate_99 float(53) NULL,
	Rate_100 float(53) NULL
GO
COMMIT
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QSchemeViewIndemnity]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QSchemeViewIndemnity
end
GO
CREATE procedure QSchemeViewIndemnity(@p_SchemeNo varchar(10),@P_Class_Desc as varchar(100))   
as   
select Top 50000 CAST(0 As Bit) ProcessFlag,S2.classno, S1.description as class_desc, S2.Coverage, S2.Code, S2.Lower, S2.Upper, S2.PCTLoss, S2.PAddition, S2.Discount, S2.RateLower, S2.Rate, S2.HoldF, S2.RateLoadingF, S2.Rate_Source
from Scheme_Class as S1, scheme_indemnity as S2   
where  S1.ClassNo=S2.ClassNo and S1.SchemeNo=@P_SchemeNo and (@P_Class_Desc='<All>' or S1.description=@P_Class_Desc)
order by  S2.ClassNo, S2.Coverage, S2.Code, S2.Lower, S2.Upper 
go


