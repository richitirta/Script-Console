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
A1.ID, A1.Code, A1.CodeExt, A1.MSCode,          
Case When A2.AType='A' then A1.Amount_OC else A1.CAmount end as CAmount,         
A1.Currency_OC, A1.Rate, A1.Currency, A1.TOC, A1.PolicyNo, A1.Remarks, A1.Prorata, A1.SDate, A1.EDate, A1.Date, A1.BillDate, A1.PProrata, A1.DocNo, A1.RefNo, A1.AdjustableF, A1.RCode,  
CASE 
WHEN COALESCE(R1.NOREFUNDF,0)=1 THEN Cast(1 as Bit)
WHEN COALESCE(R2.NOREFUNDF,0)=1 THEN Cast(1 as Bit)
WHEN COALESCE(A5.NOREFUNDF,COALESCE(A4.NOREFUNDF,A6.NOREFUNDF))=1 THEN Cast(1 as Bit)
WHEN COALESCE(A8.NOREFUNDF,COALESCE(A7.NOREFUNDF,A9.NOREFUNDF))=1 THEN Cast(1 as Bit)
ELSE CAST(A1.NOREFUNDF as BIT)
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

Outer Apply (Select Top 1 R1.NoRefundF, R1.CPREFUND, R1.CPFORMULA from RCover R1 Where R1.ANO=A3.ANO and R1.Code=A1.RCode and ((R1.SDate=A3.SDate and R1.EDate=A3.EDate and A1.SDate=A2.SDate and A1.EDate=A2.EDate) or (R1.SDate=A1.SDate))) R1
Outer Apply (Select Top 1 R2.NoRefundF, R2.CPREFUND from FPart F, RArrDet R2 Where F.ANO=A3.ANO and F.SlipNo=A1.RefNo and F.ID=A1.ID and R2.ANO=F.ANO and R2.FID=F.FID and ((R2.RType='F' and A1.Type in ('FO','FP')) or (R2.RType<>'F' and A1.Type=Case When R2.RType in ('JP') Then 'IC' else R2.RType end)) and R2.Status<>'O') R2

Outer Apply (Select Top 1 UseCurrTypeF, BSType, NoRefundF, NoProrataF from ACCBS A4 Where A4.ANO=A3.ANO and A4.ID=A1.ID and A4.OBSType=substring(A1.Type,2,1) Order By A4.ANO) A4
Outer Apply (Select Top 1 UseCurrTypeF, BSType, NoRefundF, NoProrataF from AACCBS A5 Where A5.ANO=A3.ANO and A5.ID=A1.ID and A5.OBSType=substring(A1.Type,2,1) Order By A5.ANO) A5
Outer Apply (Select Top 1 UseCurrTypeF, BSType, NoRefundF, NoProrataF from ACCBS A6 Where A6.ANO=A3.LANO and A6.ID=A1.ID and A6.OBSType=substring(A1.Type,2,1) Order By A6.ANO) A6

Outer Apply (Select Top 1 NoRefundF from Payor Where ANO=A3.ANO and A1.Type in ('DI','IC','CF','JP') and A1.Code in ('O')) A7
Outer Apply (Select Top 1 NoRefundF from APayor Where ANO=A3.ANO and A1.Type in ('DI','IC','CF','JP') and A1.Code in ('O')) A8
Outer Apply (Select Top 1 NoRefundF from Payor Where ANO=A3.LANO and A1.Type in ('DI','IC','CF','JP') and A1.Code in ('O')) A9

WHERE A2.ANO=@P_ANO AND (A1.CAMOUNT<>0 OR A2.AType='A')     
AND A1.DepositF=0
AND Not (

(A1.TYPE in ('DI','OP') AND A1.CODE IN ('F')) or 
(A1.TYPE in ('DI','IC') AND A1.CODE IN ('D')) or
(A1.TYPE in ('CF') AND A1.CODE IN ('F','D') 
and exists (
	Select TOP 1 ACCFD.ANO
	from Coinsurance
    Inner Join ACCFD on (ACCFD.ANO=A2.ANO And ACCFD.CONTRIBUTIONF=1)
    Inner join FDTAB on (FDTAB.FDID=ACCFD.FDID AND Left(FDTAB.FDTYPE,1)<>'F')
    Where Coinsurance.CNO=A2.CNO 
    and COINSURANCE.ID=A1.ID AND COINSURANCE.DOCNO=A1.REFNO AND COINSURANCE.PCOLLECTIONF=1 AND COINSURANCE.HF=0 AND COINSURANCE.HFAMOUNT=0
	)
)
) 
GO




insert into PatchVersioning
select '1004 Update Script - Patch 2024 (22)',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1004 Update Script - Patch 2024 (22)'


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