DROP PROCEDURE QObjectValuation
GO
CREATE PROCEDURE QObjectValuation(@P_INO as integer, @P_VDate as smalldatetime='1900/01/01', @P_SI as Float=0)       
AS       
Declare @P_Value as float  
Declare @P_ValuePCT as Float  
  
IF @P_VDate='1900/01/01'     
	SELECT @P_VDate=ACCEPTANCE.SDATE FROM ICOVER INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=ICOVER.ANO) WHERE  ICOVER.INO=@P_INO
  
SELECT @P_Value=Value, @P_ValuePCT=ValuePCT from fn_ObjectValuation(@P_INO, @P_VDATE)       
  
IF @P_SI<>0  
BEGIN
	SELECT @P_SI = @P_SI * (100 + @P_ValuePCT)/100

	--SPECIAL FOR FPG PHILIPPINES
	SET @P_SI = 
	CASE WHEN @P_SI > 100000 THEN
		CASE WHEN @P_SI > ROUND(@P_SI, -4) THEN ROUND(@P_SI, -4) + 10000 ELSE ROUND(@P_SI, -4) END
	ELSE
		CASE WHEN @P_SI > ROUND(@P_SI, -3) THEN ROUND(@P_SI, -3) + 1000 ELSE ROUND(@P_SI, -3) END
	END
END
ELSE
BEGIN
	SELECT @P_SI = @P_Value
END
  
IF @P_Value<>0 AND @P_SI>@P_Value
BEGIN
	SELECT @P_SI = @P_Value
END

SELECT @P_Value AS VALUE, @P_ValuePCT AS ValuePCT, @P_SI AS SI  
  
GO
DROP PROCEDURE GET_FEE_AMOUNT_BY_PERCENTAGE
GO
CREATE PROCEDURE GET_FEE_AMOUNT_BY_PERCENTAGE(@P_ANO AS INT, @P_CODE AS VARCHAR(10), @P_FDTYPE AS VARCHAR(1), @P_AMOUNTPCT AS FLOAT, @P_AMOUNTPCTBASED AS INT=0, @P_POLICYYEAR AS INT=0)
AS
DECLARE @P_LANO AS INTEGER
DECLARE @P_REGNO AS VARCHAR(50)
DECLARE @P_ASTATUS AS VARCHAR(1)
DECLARE @P_FEE AS FLOAT
DECLARE @P_TOC AS VARCHAR(4)

SELECT @P_LANO=LANO, @P_REGNO=REGNO, @P_ASTATUS=ASTATUS, @P_TOC=TOC FROM ACCEPTANCE WHERE ANO=@P_ANO

IF @P_LANO<>@P_ANO -- INDIVIDUAL OR CERTIFICATE
BEGIN
	IF @P_AMOUNTPCTBASED=0 OR (@P_AMOUNTPCTBASED=2 AND LEFT(@P_TOC,2) NOT IN ('06','07'))
	BEGIN
		SELECT 
		@P_FEE=
		CASE 
		WHEN LEFT(@P_FDTYPE,1)<>'O' THEN 
			SUM(D1.GROSS*(100-D1.DISCOUNT)/100*D1.PRORATA*P.GROSS/P.OGROSS*P.OURSHARE/P.TSI)
	    ELSE
			SUM(D1.GROSS*D1.PRORATA*P.GROSS/P.OGROSS*P.OURSHARE/P.TSI*(100-R.MSHARE)/100)
		END*@P_AMOUNTPCT/100
		FROM DISPLAY_CALCULATION(@P_ANO) D1
		INNER JOIN ACCEPTANCE A ON (A.ANO=D1.ANO)
		INNER JOIN RARRHEADER R ON (R.ANO=D1.ANO)
		INNER JOIN PCALC P ON (P.ANO=D1.ANO AND P.CURRENCY=D1.CURRENCY)
		WHERE  D1.CURRENCY=@P_CODE
		AND (@P_POLICYYEAR=0 OR (D1.SDATE>=DATEADD(MONTH,12*(@P_POLICYYEAR-1),A.SDATE) AND D1.SDATE<DATEADD(MONTH,12*(@P_POLICYYEAR),A.SDATE)))
	END
	ELSE
	BEGIN
		SELECT 
		@P_FEE=
		CASE 
		WHEN LEFT(@P_FDTYPE,1)<>'O' THEN 
			CASE WHEN @P_AMOUNTPCTBASED=2 THEN
				CASE WHEN (COALESCE(MAX(P.OURSHARE),0)-COALESCE(MAX(PP.OURSHARE),0)) > 1000000 THEN
					200
				WHEN (COALESCE(MAX(P.OURSHARE),0)-COALESCE(MAX(PP.OURSHARE),0)) > 750000 AND (COALESCE(MAX(P.OURSHARE),0)-COALESCE(MAX(PP.OURSHARE),0)) <= 1000000 THEN
					150
				WHEN (COALESCE(MAX(P.OURSHARE),0)-COALESCE(MAX(PP.OURSHARE),0)) > 500000 AND (COALESCE(MAX(P.OURSHARE),0)-COALESCE(MAX(PP.OURSHARE),0)) <= 750000 THEN
					100
				WHEN (COALESCE(MAX(P.OURSHARE),0)-COALESCE(MAX(PP.OURSHARE),0)) > 300000 AND (COALESCE(MAX(P.OURSHARE),0)-COALESCE(MAX(PP.OURSHARE),0)) <= 500000 THEN
					50
				WHEN (COALESCE(MAX(P.OURSHARE),0)-COALESCE(MAX(PP.OURSHARE),0)) > 100000 AND (COALESCE(MAX(P.OURSHARE),0)-COALESCE(MAX(PP.OURSHARE),0)) <= 300000 THEN
					20
				ELSE
					0
				END	 
			ELSE
				(COALESCE(MAX(P.OURSHARE),0)-COALESCE(MAX(PP.OURSHARE),0)) * @P_AMOUNTPCT/100
			END						
	    ELSE
			(COALESCE(MAX(P.OURSHARE*(100-R.MSHARE)/100),0)-COALESCE(MAX(PP.OURSHARE*(100-PR.MSHARE)/100),0)) * @P_AMOUNTPCT/100
		END
		FROM ACCEPTANCE A
		LEFT JOIN ACCEPTANCE PA ON (PA.ANO=A.PANO)
		LEFT JOIN PCALC P ON (P.ANO=A.ANO AND P.CURRENCY=@P_CODE AND A.ATYPE NOT IN ('A','C'))
		LEFT JOIN RARRHEADER R ON (R.ANO=A.ANO AND A.ATYPE NOT IN ('A','C'))
		LEFT JOIN PCALC PP ON (PP.ANO=A.PANO AND PP.CURRENCY=P.CURRENCY AND PA.ATYPE NOT IN ('A','C'))
		LEFT JOIN RARRHEADER PR ON (PR.ANO=A.PANO AND PA.ATYPE NOT IN ('A','C'))		
		WHERE A.ANO=@P_ANO
	END
END
ELSE	-- FLEET ONLY
BEGIN
	IF @P_AMOUNTPCTBASED=0
	BEGIN
		SELECT @P_FEE=SUM(FEE)
		FROM
		(
			SELECT
			ACCEPTANCE.ANO,
			(
				SELECT 
				CASE 
				WHEN LEFT(@P_FDTYPE,1)<>'O' THEN 
					SUM(D1.GROSS*(100-D1.DISCOUNT)/100*D1.PRORATA*P.GROSS/P.OGROSS*P.OURSHARE/P.TSI)
				ELSE 
					SUM(D1.GROSS*D1.PRORATA*P.GROSS/P.OGROSS*P.OURSHARE/P.TSI*(100-R.MSHARE)/100)
				END * @P_AMOUNTPCT/100
				FROM DISPLAY_CALCULATION(ACCEPTANCE.ANO) D1
				INNER JOIN ACCEPTANCE A ON (A.ANO=D1.ANO)
				INNER JOIN RARRHEADER R ON (R.ANO=D1.ANO)
				INNER JOIN PCALC P ON (P.ANO=D1.ANO AND P.CURRENCY=D1.CURRENCY)
				WHERE  D1.CURRENCY=@P_CODE
				AND (@P_POLICYYEAR=0 OR (D1.SDATE>=DATEADD(MONTH,12*(@P_POLICYYEAR-1),A.SDATE) AND D1.SDATE<DATEADD(MONTH,12*(@P_POLICYYEAR),A.SDATE)))
			) AS FEE
			FROM ACCEPTANCE
			INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)
			WHERE  COVER.OPENFLAG=0 AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO
			AND NOT (COVER.ASOURCE='MKT' AND ACCEPTANCE.ATYPE='N' AND COVER.CSTATUS='A') --NOT CONFIRM QUOTATION
			AND ((ACCEPTANCE.ASTATUS IN ('W','T') AND ACCEPTANCE.LANO=@P_ANO) OR (ACCEPTANCE.ASTATUS NOT IN ('W','T') AND ACCEPTANCE.REGNO<>'' AND ACCEPTANCE.REGNO=@P_REGNO))
		) A
	END
	ELSE
	BEGIN
		SELECT @P_FEE=SUM(FEE)
		FROM
		(
			SELECT 
			F.COB, 
			CASE 
			WHEN @P_AMOUNTPCTBASED=2 AND F.COB IN ('06','07') THEN
				CASE 
				WHEN SUM(OURSHARE) > 1000000 THEN
					200
				WHEN SUM(OURSHARE) > 750000 AND SUM(OURSHARE) <= 1000000 THEN      
					150      
				WHEN SUM(OURSHARE) > 500000 AND SUM(OURSHARE) <= 750000 THEN      
					100      
				WHEN SUM(OURSHARE) > 300000 AND SUM(OURSHARE) <= 500000 THEN      
					50      
				WHEN SUM(OURSHARE) > 100000 AND SUM(OURSHARE) <= 300000 THEN      
					20      
				ELSE      
					0      
				END  
			ELSE
				SUM(OURSHARE) * @P_AMOUNTPCT/100
			END	AS FEE
			FROM
			(	
				SELECT
				ACCEPTANCE.ANO, LEFT(ACCEPTANCE.TOC,2) AS COB,
				(
					SELECT 
					CASE 
					WHEN LEFT(@P_FDTYPE,1)<>'O' THEN 
						COALESCE(MAX(P.OURSHARE),0)-COALESCE(MAX(PP.OURSHARE),0)
					ELSE
						COALESCE(MAX(P.OURSHARE*(100-R.MSHARE)/100),0)-COALESCE(MAX(PP.OURSHARE*(100-PR.MSHARE)/100),0)
					END
					FROM ACCEPTANCE A
					LEFT JOIN ACCEPTANCE PA ON (PA.ANO=A.PANO)
					LEFT JOIN PCALC P ON (P.ANO=A.ANO AND P.CURRENCY=@P_CODE AND A.ATYPE NOT IN ('A','C'))
					LEFT JOIN RARRHEADER R ON (R.ANO=A.ANO AND A.ATYPE NOT IN ('A','C'))
					LEFT JOIN PCALC PP ON (PP.ANO=A.PANO AND PP.CURRENCY=P.CURRENCY AND PA.ATYPE NOT IN ('A','C'))
					LEFT JOIN RARRHEADER PR ON (PR.ANO=A.PANO AND PA.ATYPE NOT IN ('A','C'))		
					WHERE A.ANO=ACCEPTANCE.ANO
				) AS OURSHARE
				FROM ACCEPTANCE
				INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)
				WHERE  COVER.OPENFLAG=0 AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO 
				AND NOT (COVER.ASOURCE='MKT' AND ACCEPTANCE.ATYPE='N' AND COVER.CSTATUS='A') --NOT CONFIRM QUOTATION
				AND ((ACCEPTANCE.ASTATUS IN ('W','T') AND ACCEPTANCE.LANO=@P_ANO) OR (ACCEPTANCE.ASTATUS NOT IN ('W','T') AND ACCEPTANCE.REGNO<>'' AND ACCEPTANCE.REGNO=@P_REGNO))
				AND (@P_AMOUNTPCTBASED=1 OR (@P_AMOUNTPCTBASED=2 AND LEFT(ACCEPTANCE.TOC,2) IN ('06','07')))

				UNION ALL

				SELECT
				ACCEPTANCE.ANO, LEFT(ACCEPTANCE.TOC,2) AS COB,
				(
					SELECT 
					CASE 
					WHEN LEFT(@P_FDTYPE,1)<>'O' THEN 
						SUM(D1.GROSS*(100-D1.DISCOUNT)/100*D1.PRORATA*P.GROSS/P.OGROSS*P.OURSHARE/P.TSI)
					ELSE 
						SUM(D1.GROSS*D1.PRORATA*P.GROSS/P.OGROSS*P.OURSHARE/P.TSI*(100-R.MSHARE)/100)
					END
					FROM DISPLAY_CALCULATION(ACCEPTANCE.ANO) D1
					INNER JOIN ACCEPTANCE A ON (A.ANO=D1.ANO)
					INNER JOIN RARRHEADER R ON (R.ANO=D1.ANO)
					INNER JOIN PCALC P ON (P.ANO=D1.ANO AND P.CURRENCY=D1.CURRENCY)
					WHERE  D1.CURRENCY=@P_CODE
					AND (@P_POLICYYEAR=0 OR (D1.SDATE>=DATEADD(MONTH,12*(@P_POLICYYEAR-1),A.SDATE) AND D1.SDATE<DATEADD(MONTH,12*(@P_POLICYYEAR),A.SDATE)))
				) AS FEE
				FROM ACCEPTANCE
				INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)
				WHERE COVER.OPENFLAG=0 AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO
				AND NOT (COVER.ASOURCE='MKT' AND ACCEPTANCE.ATYPE='N' AND COVER.CSTATUS='A') --NOT CONFIRM QUOTATION
				AND ((ACCEPTANCE.ASTATUS IN ('W','T') AND ACCEPTANCE.LANO=@P_ANO) OR (ACCEPTANCE.ASTATUS NOT IN ('W','T') AND ACCEPTANCE.REGNO<>'' AND ACCEPTANCE.REGNO=@P_REGNO))
				AND @P_AMOUNTPCTBASED=2 AND LEFT(ACCEPTANCE.TOC,2) NOT IN ('06','07')

			)F GROUP BY F.COB
		) A
	END
END

IF @P_FDTYPE = 'D'       
BEGIN      
	SET @P_FEE =       
	CASE WHEN @P_FEE >= 0 THEN      
		CASE WHEN ROUND((@P_FEE-FLOOR(@P_FEE)), 10) = 0 THEN @P_FEE WHEN ROUND((@P_FEE-FLOOR(@P_FEE)), 10) > 0.5 THEN CEILING(@P_FEE) WHEN ROUND((@P_FEE-FLOOR(@P_FEE)), 10) <= 0.5 THEN FLOOR(@P_FEE) + 0.5 END      
	ELSE      
		CASE WHEN ROUND((@P_FEE-CEILING(@P_FEE)), 10) = 0 THEN @P_FEE WHEN ROUND((@P_FEE-CEILING(@P_FEE)), 10) < -0.5 THEN FLOOR(@P_FEE) WHEN ROUND((@P_FEE-CEILING(@P_FEE)), 10) >= -0.5 THEN CEILING(@P_FEE) - 0.5 END      
	END      
END      
SELECT @P_FEE AS FEE

GO



DROP Function Get_Payment_Percentage
GO
CREATE Function Get_Payment_Percentage(@P_A_PolicyNo varchar(50), @P_Type varchar(10), @P_DocNO varchar(50), @P_Date smalldatetime, @P_Currency varchar(10))
RETURNS Float AS        
  
BEGIN       
Declare @PCT as Float

Declare @Admlink Table(AdmNo int, DocNo varchar(50), Date SmallDatetime, Voucher varchar(50), Amount Float, LAmount Float)

insert into @Admlink(AdmNo, DocNo, Date, Voucher, Amount, LAmount)
Select A.AdmNo, A.DocNo, A.Date, A.Voucher, A.Amount, (A.Amount_4+A.Amount_15+A.Amount_16+A.Amount_17+A.Amount_18)
from Admlink A
Inner Join nVoucher V on (V.Voucher=A.Voucher)
Where A.Date<=@P_Date and A.A_PolicyNo=@P_A_PolicyNo and A.Currency=@P_Currency and A.Subject='Premium' and A.Type in ('DI','IC','IR')
and (substring(A.DocNo,1,50)+space(50-len(A.DocNo))+convert(varchar(50), A.Date,102))<=(substring(@P_DocNo,1,50)+space(50-len(@P_DocNo))+convert(varchar(50), @P_Date,102)) 
and Round(V.Nominal_CC-V.Diff_CC,4)>0

Select Top 1 @P_DocNo=A.DocNo, @P_Date=A.Date
from @Admlink A
Order by AdmNo Desc

Select 
@PCT=
sum(case When V.DebtorF=1 Then (V.Payment_CC) Else -(V.Payment_CC) end)/sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)*100

from (

       Select V.Voucher, 
       cast(Max(Cast(V.DebtorF as Int)) as Bit) as DebtorF,
       Case 
       When @P_TYPE in ('PI','PL') Then Max(V.Payment_CC*V.Rate)
       When Max(V.Payment_CC*V.Rate)<sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate) Then 0
       Else Max(V.Payment_CC*V.Rate)-sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)*V.Rate)
       End as Payment_CC,

       sum(
              (case When V.DebtorF=1 Then 1 else -1 end)*
              Case
              When @P_Type in ('PI','PL') then (A.Amount)
              Else (A.Amount-A.LAmount)
              End*V.Rate
       ) as Nominal_CC
       from @Admlink A
	   Inner Join nVoucher V on (V.Voucher=A.Voucher)
		Where (substring(A.DocNo,1,50)+space(50-len(A.DocNo))+convert(varchar(50), A.Date,102))>
		coalesce(
		(
		Select Top 1 (substring(B.DocNo,1,50)+space(50-len(B.DocNo))+convert(varchar(50), B.Date,102)) 
		from Admlink B
		Inner Join @Admlink C on (C.DocNo=B.DocNo and C.Date=B.Date)
		Where B.Date<=@P_Date and B.A_PolicyNo=@P_A_PolicyNo and B.Currency=@P_Currency and B.Subject='Premium' and B.Type=@P_Type 
		and (substring(B.DocNo,1,50)+space(50-len(B.DocNo))+convert(varchar(50), B.Date,102))<(substring(@P_DocNo,1,50)+space(50-len(@P_DocNo))+convert(varchar(50), @P_Date,102))  
		order by B.AdmNo Desc
		),'')
       Group By V.Voucher
) V

Having sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)<>0

if @PCT IS NULL 
       SELECT @PCT=100

if @PCT<0
       SELECT @PCT=0

if @PCT>100
       SELECT @PCT=100

Return @PCT
End



GO

DROP Procedure QCLAIMRCESSION 
GO
CREATE Procedure QCLAIMRCESSION (@P_RID varchar(255), @P_CNO int)      
as      

DECLARE @TOTALINDEMNITY AS FLOAT
DECLARE @TOTALESTIMATE AS FLOAT

SELECT
	@TOTALINDEMNITY=SUM((CCALC.CLAIM-CCALC.DEDUCTIBLE-CCALC.SALVAGE)*CCALC.RATE),
	@TOTALESTIMATE=SUM((CCALC.LOSS-CCALC.EDEDUCTIBLE-CCALC.ESALVAGE)*CCALC.RATE)
FROM CCALC WHERE CNO=@P_CNO

Declare @ClaimEvents table(TOC varchar(10), RID varchar(20))

Declare @EventNo int
Declare @ANO int
Declare @TOC varchar(10)
Declare @Category varchar(1)

Select @EventNo=Claim.EventNo, @ANO=Claim.ANO, @TOC=Claim.TOC, @Category=coalesce(Event.Category,'R') from Claim Left Join Event on (Event.EventNo=Claim.EventNo) Where Claim.CNO=@P_CNO

if @EventNo>0
Begin
	insert into @ClaimEvents
	Select Distinct C1.TOC, 
	(
		Case 
		When Reinsurance.RType='X1' Then C2.XL1ID
		When Reinsurance.RType='X2' Then C2.XL2ID
		When Reinsurance.RType='X3' Then C2.XL3ID
		When Reinsurance.RType='X4' Then C2.XL4ID
		When Reinsurance.RType='X5' Then C2.XL5ID
		When Reinsurance.RType='X6' Then C2.XL6ID
		When Reinsurance.RType='X7' Then C2.XL7ID
		Else ''
		end) as RID
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join Reinsurance on (Reinsurance.RID=@P_RID)
	Where @EventNo>0 and C1.EventNo=@EventNo and C2.Status='A' 
end


SELECT RPART.ID, RPART.SHARE, RPART.JP, 
--CLAIM REINSURANCE PORTION
	CASE WHEN @TOTALINDEMNITY<>0 THEN
		(
			COALESCE((
				SELECT SUM((LCALC.INDEMNITY-LCALC.DEDUCTIBLE-LCALC.SALVAGE)*CCALC.RATE) FROM CCALC INNER JOIN LCALC ON (LCALC.CNO=CCALC.CNO AND LCALC.CURRENCY=CCALC.CURRENCY) WHERE CCALC.CNO=@P_CNO
				AND NOT EXISTS (SELECT TOP 1 1 FROM RPARTDET WHERE RPARTDET.RNO=RPART.RNO AND RPARTDET.ID=RPART.ID AND RPARTDET.DOCNO=RPART.DOCNO AND RPARTDET.TOR=LCALC.TOR AND RPARTDET.EXCLUDEF=1)
				AND NOT EXISTS (SELECT TOP 1 1 FROM RCALC WHERE RCALC.ANO=@ANO AND RCALC.TOR=LCALC.TOR AND RCALC.EXTREATYF=1)
			),0)
		)
		/
		@TOTALINDEMNITY*100
	WHEN @TOTALESTIMATE<>0 THEN
		(
			COALESCE((
				SELECT SUM((LCALC.Loss-LCALC.EDEDUCTIBLE-LCALC.ESALVAGE)*CCALC.RATE) FROM CCALC INNER JOIN LCALC ON (LCALC.CNO=CCALC.CNO AND LCALC.CURRENCY=CCALC.CURRENCY) WHERE CCALC.CNO=@P_CNO     
				AND NOT EXISTS (SELECT TOP 1 1 FROM RPARTDET WHERE RPARTDET.RNO=RPART.RNO AND RPARTDET.ID=RPART.ID AND RPARTDET.DOCNO=RPART.DOCNO AND RPARTDET.TOR=LCALC.TOR AND RPARTDET.EXCLUDEF=1)    
				AND NOT EXISTS (SELECT TOP 1 1 FROM RCALC WHERE RCALC.ANO=@ANO AND RCALC.TOR=LCALC.TOR AND RCALC.EXTREATYF=1)         
			),0)
		)
		/
		@TOTALESTIMATE*100
	ELSE
		100    
	END AS RPORTION,
REINSURANCE.RID, REINSURANCE.CESSION, REINSURANCE.RYEAR,
CASE WHEN COALESCE(RPART.DOCNO,'')='' THEN REINSURANCE.DOCNO ELSE RPART.DOCNO END AS DOCNO,
Case When @Category='E' and RECLASS.ELIMIT<>0 Then RECLASS.ELIMIT Else (Case WHEN RECLASS.Limit=0 THEN Reinsurance.Limit Else RECLASS.Limit end) End*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) End as Limit,
CASE WHEN RPART.CASHLOSS<>0 THEN RPART.CASHLOSS ELSE REINSURANCE.CASHLOSS END*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) End as CASHLOSS, 
REINSURANCE.CASHLOSSCOMBINE*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) End as CASHLOSSCOMBINE, 
REINSURANCE.PRIORITYF,      
CASE WHEN @Category<>'E' OR REINSURANCE.EREINSTATEMENT=0 THEN REINSURANCE.REINSTATEMENT ELSE REINSURANCE.EREINSTATEMENT END AS REINSTATEMENT,     
CASE WHEN @Category<>'E' OR REINSURANCE.EREINSTATEMENT_1=0 THEN REINSURANCE.REINSTATEMENT_1 ELSE REINSURANCE.EREINSTATEMENT_1 END AS REINSTATEMENT_1,     
CASE WHEN @Category<>'E' OR REINSURANCE.EREINSTATEMENT_2=0 THEN REINSURANCE.REINSTATEMENT_2 ELSE REINSURANCE.EREINSTATEMENT_2 END AS REINSTATEMENT_2,     
CASE WHEN @Category<>'E' OR REINSURANCE.EREINSTATEMENT_3=0 THEN REINSURANCE.REINSTATEMENT_3 ELSE REINSURANCE.EREINSTATEMENT_3 END AS REINSTATEMENT_3,     
CASE WHEN @Category<>'E' OR REINSURANCE.EAP_1=0 THEN REINSURANCE.AP_1 ELSE REINSURANCE.EAP_1 END AS AP_1,     
CASE WHEN @Category<>'E' OR REINSURANCE.EAP_2=0 THEN REINSURANCE.AP_2 ELSE REINSURANCE.EAP_2 END AS AP_2,     
CASE WHEN @Category<>'E' OR REINSURANCE.EAP_3=0 THEN REINSURANCE.AP_3 ELSE REINSURANCE.EAP_3 END AS AP_3    
From REINSURANCE
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=@ANO)
INNER JOIN RPART ON (RPART.RNO=REINSURANCE.RNO AND RPART.SHARE<>0)
Inner Join ReClass on (
	ReClass.RNO=Reinsurance.RNO 
	and 
	ReClass.TOC=
	(
		Select Top 1 R.TOC
		from ReClass R
		Where R.RNO=Reinsurance.RNO 
		and exists (
			Select @TOC Where R.TOC=@TOC
			
			union All

			Select Distinct C.TOC 
			from @ClaimEvents C
			Where C.TOC=R.TOC and C.RID=@P_RID
		)
		Order by Case When @Category='E' and R.ELIMIT<>0 Then R.ELIMIT Else (Case WHEN R.Limit=0 THEN Reinsurance.Limit Else R.Limit end) End
	)
	)          
Left Join ReRate R1 on (R1.TOC=@TOC and R1.RYear=Reinsurance.RYEAR and R1.Currency=Reinsurance.Currency)
Left Join ReRate R2 on (R2.TOC=R1.TOC and R2.RYear=R1.RYear and R2.Currency=R1.CCYTo and R1.Currency<>R1.CCYTO)
Inner Join SysTab on (1=1)
WHERE REINSURANCE.RID=@P_RID 
-- If Risk is Excluded      
AND NOT EXISTS (SELECT TOP 1 1 FROM RPARTDET Inner Join LCALC on (LCALC.CNO=@P_CNO AND LCALC.TOR=RPARTDET.TOR) WHERE RPARTDET.RNO=RPART.RNO AND RPARTDET.ID=RPART.ID AND RPARTDET.DOCNO=RPART.DOCNO AND RPARTDET.EXCLUDEF=1)      
-- If Risk is Excluded      
AND NOT EXISTS (SELECT TOP 1 1 FROM RCALC Inner Join LCALC on (LCALC.CNO=@P_CNO AND LCALC.TOR=RCALC.TOR) WHERE RCALC.ANO=@ANO AND RCALC.EXTREATYF=1)     


GO


GO
DROP Function fn_Rate_Loading
GO
Create Function fn_Rate_Loading(@P_ANO as int)    
RETURNS Float
AS    
BEGIN    
 Declare @Rate  as Float
 Declare @TotalRate as Float
      
 Select @TotalRate=1
 DECLARE RCover_Cursor CURSOR FOR    
 Select R1.Rate*(100-R1.DISCOUNT-R1.DISCOUNT_EXT)/100*R1.Loading       
 from RCover R1
 Where R1.ANO=@P_ANO and R1.Unit='L'
 
 OPEN RCover_Cursor    
 FETCH FROM RCover_Cursor into @Rate
 WHILE @@FETCH_STATUS = 0    
 BEGIN    
	Select @TotalRate=@TotalRate+(@Rate)
    FETCH NEXT FROM RCover_Cursor into @Rate
 End    
 Close RCover_Cursor    
 Deallocate RCover_Cursor    
 Return (@TotalRate)    
End    


GO

DROP FUNCTION FN_UserBusinessSource 
GO
CREATE FUNCTION FN_UserBusinessSource (@P_UserID as varchar(10), @P_PDate as smalldatetime)      
RETURNS TABLE      
as RETURN(      
Select P.ID, P.Name, P.Address_1, P.Address_2, P.Remark, P.Comm, P.TaxType, P.VatF, P.TaxF, P.NetCommF, 
Case When P.RestrictedF=1 or not (coalesce(P.LicenseExpiry,cast(convert(varchar(10), @P_PDate,1) as smalldatetime))>=cast(convert(varchar(10), @P_PDate,1) 
as smalldatetime)) Then cast(1 as Bit) else cast(0 as Bit) end as RestrictedF,
Case 
When P.RestrictedF=1 Then 'Profile is Restricted'
When Not (
(P.LicenseNo<>'' and coalesce(P.LicenseExpiry,cast(convert(varchar(10), @P_PDate,1) as smalldatetime))>=cast(convert(varchar(10), @P_PDate,1) as smalldatetime))
or
(coalesce(Up.ID, P.ID)<>P.ID)
)
Then 'License has expired'
else '' 
end as RestrictedRemarks,
P.LOB, 
S1.ID as SID, S1.Name as SName, 
P.DumpF,P.Phone_1,P.Phone_2,
AIF.AgentType 
From Profile P 
Left Join AIF on (AIF.ID=P.ID)
Left Join AIF UL on (UL.AgentID=AIF.ULAgentID)
Left Join Profile uP on (uP.ID=UL.ID and Not (uP.LicenseNo='' or (coalesce(uP.LicenseExpiry,cast(convert(varchar(10), @P_PDate,1) as smalldatetime))<cast(convert(varchar(10), @P_PDate,1) as smalldatetime))))
Left Join SysUserAssignment S on (S.AssType='SOURCE' and S.PID=P.ID and S.ID=@P_UserID)
Left join SysUser S1 on (S1.ID=S.ID and S1.AllowedF=1)
Where coalesce(P.DumpF,0)=0 and P.IntermediaryF=1
--and 
--(
--	(coalesce(P.LicenseNo,'')<>'' and coalesce(P.LicenseExpiry,cast('01/01/1900' as smalldatetime))>=cast(convert(varchar(10), @P_PDate,1) as smalldatetime))
--	or
--	(coalesce(Up.ID, P.ID)<>P.ID)
--)
and 
(
	not exists(Select Top 1 PID from SysUserAssignment S Where S.AssType='SOURCE' and S.ID=@P_UserID) or coalesce(S1.ID,'')=@P_UserID
)
)    

GO



 insert into PatchVersioning
select '173 Update Script - Patch 2022-PHI',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='173 Update Script - Patch 2022-PHI'


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
