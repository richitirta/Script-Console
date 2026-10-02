DROP Function fn_BusinessSource
GO
CREATE Function fn_BusinessSource(@P_ANO as int) 
RETURNS VarChar(10) 
AS 
BEGIN 
Declare @Source varchar(10) 
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
DROP Procedure BALANCE_ACCASS
GO
CREATE Procedure BALANCE_ACCASS(@P_ANO integer)                
as                
SELECT A3.LANO, A1.ACNO, A1.BizmapID, A2.AType, 
Case 
When coalesce(A5.UseCurrTypeF, coalesce(A4.UseCurrTypeF, coalesce(A6.UseCurrTypeF, Cast(0 as Bit))))=1 and A1.Type in ('BB','BA','BO','BC','BP','BD') then
	'B'+coalesce(A5.BSType, coalesce(A4.BSType, coalesce(A6.BSType,'')))
else
	A1.Type
end Type,
A1.ID, A1.Code, A1.MSCode,          
Case When A2.AType='A' then A1.Amount_OC else A1.CAmount end as CAmount,         
A1.Currency_OC, A1.Rate, A1.Currency, A1.TOC, A1.PolicyNo, A1.Remarks, A1.Prorata, A1.SDate, A1.EDate, A1.Date, A1.BillDate, A1.PProrata, A1.DocNo, A1.RefNo, A1.AdjustableF, A1.RCode,  
CASE 
WHEN COALESCE(R1.NOREFUNDF,0)=1 THEN R1.NOREFUNDF 
ELSE COALESCE(R2.NOREFUNDF,COALESCE(COALESCE(A5.NOREFUNDF,COALESCE(A4.NOREFUNDF,A6.NOREFUNDF)),CAST(A1.NOREFUNDF as BIT))) 
END AS NOREFUNDF,        
coalesce(A5.NoProrataF, coalesce(A4.NoProrataF, coalesce(A6.NoProrataF, Cast(0 as Bit)))) as NoProrataF,
Case 
When A3.AType='C' and A3.EMethod<>'A' Then 
	Case When A1.Type in ('DI','IC','IR','BB','BA','BO','BC','BP','BD','OP') Then R1.CPRefund else coalesce(R2.CPRefund,0) end
else
	0
end as CPRefund,
Case 
When A3.AType='C' and A3.EMethod<>'A' Then 
	Case When A1.Type in ('DI','IC','IR','BB','BA','BO','BC','BP','BD','OP') Then R1.CPFormula else '' end
else
	''
end as CPFormula,
A1.ADJMETHOD, A1.Source, A1.CommPoolF
FROM ACCEPTANCE A2
INNER JOIN ACCASS A1 ON (A1.ANO=A2.ANO)         
INNER JOIN ACCEPTANCE A3 ON (A3.PANO=A2.ANO AND A3.AType<>'A')         
Left Join RCover R1 on (R1.ANO=A3.ANO and R1.Code=A1.RCode and ((R1.SDate=A3.SDate and R1.EDate=A3.EDate and A1.SDate=A2.SDate and A1.EDate=A2.EDate) or (R1.SDate=A1.SDate)))
Left Join ACCBS A4 on (A4.ANO=A3.ANO and A4.ID=A1.ID and A4.OBSType=substring(A1.Type,2,1))        
Left Join AAccBS A5 on (A5.ANO=A3.ANO and A5.ID=A1.ID and A5.OBSType=substring(A1.Type,2,1))       
Left Join ACCBS A6 on (A6.ANO=A3.LANO and A6.ID=A1.ID and A6.OBSType=substring(A1.Type,2,1))       
Left Join FPart F on (F.ANO=A3.ANO and F.SlipNo=A1.RefNo and F.ID=A1.ID)      
Left Join RArrDet R2 on (R2.ANO=A3.ANO and R2.FID=F.FID and ((R2.RType='F' and A1.Type in ('FO','FP')) or (R2.RType<>'F' and A1.Type=Case When R2.RType in ('JP') Then 'IC' else R2.RType end)) and R2.Status<>'O')      
WHERE A2.ANO=@P_ANO AND (A1.CAMOUNT<>0 OR A2.AType='A')     
AND A1.DepositF=0
AND Not (

(A1.TYPE in ('DI','OP') AND A1.CODE IN ('F')) or 
(A1.TYPE in ('DI','IC') AND A1.CODE IN ('D')) or
(A1.TYPE in ('CF') AND A1.CODE IN ('F','D') 
and exists (
	Select TOP 1 ACCFD.ANO
	from Coinsurance
    Inner Join ACCFD on (ACCFD.ANO=A2.ANO and ACCFD.ID=Coinsurance.ID)
    Inner join FDTAB on (FDTAB.FDID=ACCFD.FDID AND Left(FDTAB.FDTYPE,1)<>'O')
    Where Coinsurance.CNO=A2.CNO And ACCFD.CONTRIBUTIONF = 1
    and COINSURANCE.DOCNO=A1.REFNO AND COINSURANCE.PCOLLECTIONF=1 AND COINSURANCE.HF=0 AND COINSURANCE.HFAMOUNT=0
	)
)
) 

