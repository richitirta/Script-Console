IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[CLVIEW07L]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure CLVIEW07L
end
GO
CREATE PROCEDURE CLVIEW07L(@P_CNO AS INTEGER)  
AS  
SELECT cast(0 as Bit) as ProcessFlag, ClaAss.AdmNo, ClaAss.RefNo, 
Max(ClaAss.BillDate) as BillDate, 
Max(ClaAss.ClaimNo) as ClaimNo, 
ClaAss.ID, 
Max(Profile.Name) as Name, 
ClaAss.Type, 
ClaAss.Currency, 
'CLAIM'=sum(  
CASE  
        WHEN CLAASS.CODE='A' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'DEDUCTIBLE'=sum(  
CASE  
        WHEN CLAASS.CODE='E' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'COST'=sum(  
CASE  
        WHEN CLAASS.CODE='L' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'SALVAGE'=sum(  
CASE  
        WHEN CLAASS.CODE='S' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'SUBROGATION'=sum(  
CASE  
        WHEN CLAASS.CODE='R' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'ADJUSTMENT'=sum(  
CASE  
        WHEN CLAASS.CODE='I' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'PREMIUM'=sum(  
CASE  
        WHEN CLAASS.CODE='P' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'VAT'=sum(  
CASE  
        WHEN CLAASS.CODE='V' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'TAX'=sum(  
CASE  
        WHEN CLAASS.CODE='T' THEN ClaAss.AMOUNT  
        ELSE 0  
END)
+
Max(coalesce(Admlink.Amount_18,0)),  
'FEE'=sum(  
CASE  
        WHEN CLAASS.CODE='F' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'DUTY'=sum(  
CASE  
        WHEN CLAASS.CODE='D' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
cast(Max(cast(ClaAss.CashLossF as int)) as Bit) as CashLossF,
cast(Max(cast(ClaAss.Posted as int)) as Bit) as Posted
FROM ClaAss 
Left Join Admlink on (Admlink.AdmNo=ClaAss.AdmNo)
Inner Join Profile on (Profile.ID=ClaAss.ID)
WHERE ClaAss.CNO=@P_CNO  
GROUP BY ClaAss.AdmNo, ClaAss.RefNo, ClaAss.ID, ClaAss.Type, ClaAss.Currency

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCLAASS_3]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QCLAASS_3
end
GO
CREATE PROCEDURE QCLAASS_3(@P_CNO int,@P_RefNo varchar(20), @P_Type varchar(255),@P_ID varchar(255),@P_CCY varchar(255)) 
as 
SELECT  
ClaAss.CNO,
ClaAss.RefNo, 
Max(ClaAss.Date) as Date, 
Max(ClaAss.BillDate) as BillDate, 
ClaAss.TOC, 
Max(ClaAss.DocNo) as DocNo, 
Max(ClaAss.ClaimNo) as ClaimNo, 
Max(ClaAss.Remarks) as Remarks, 
ClaAss.ID, 
Max(Profile.Name) as Name, 
ClaAss.Type, 
ClaAss.Currency,
Max(ClaAss.BizMapID) as BizMapID,
Max(ClaAss.Source) as Source,
Max(ClaAss.MSCode) as MSCode,
Max(ClaAss.RCode) as RCode,
Max(ClaAss.TOR) as TOR,
Max(ClaAss.Currency_OC) as Currency_OC, 
sum(case when ClaAss.code='A' then Amount else 0 end) AS Claim, 
sum(case when ClaAss.code='E' then Amount else 0 end) AS Deductible, 
sum(case when ClaAss.code='L' then Amount else 0 end) AS Cost, 
sum(case when ClaAss.code='S' then Amount else 0 end) AS Salvage, 
sum(case when ClaAss.code='R' then Amount else 0 end) AS Subrogation, 
sum(case when ClaAss.code='P' then Amount else 0 end) AS Premium, 
sum(case when ClaAss.code='I' then Amount else 0 end) AS Adjustment, 
cast(Max(cast(ClaAss.CashLossF as int)) as Bit) as CashLossF,
cast(Max(cast(ClaAss.Posted as int)) as Bit) as Posted
FROM  ClaAss
Inner Join Profile on (Profile.ID=ClaAss.ID)
WHERE  ClaAss.CNO=@P_CNO 
And ClaAss.RefNo=@P_RefNo 
and ClaAss.Type=@P_Type 
and ClaAss.ID=@P_ID 
and ClaAss.Currency=@P_CCY 
GROUP BY CLAASS.CNO, CLAASS.ID, CLAASS.TOC, CLAASS.Type, CLAASS.Currency, CLAASS.RefNo
 

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QClaAss]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QClaAss
end
GO
CREATE PROCEDURE QClaAss (@PCNO as integer, @PRefNo as varchar(50), @PType as varchar(2), @PCode as varchar(1), @PID as varchar(10), @PCurrency as varchar(10)) 
AS 
SELECT * 
FROM ClaAss 
WHERE ClaAss.CNO=@PCNO And ClaAss.RefNo=@PRefNo and ClaAss.Type=@PType And ClaAss.Code=@PCode And ClaAss.ID=@PID And ClaAss.Currency=@PCurrency 
GO

 
