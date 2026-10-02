DROP Procedure QGet_AutoApplyFeeDuty
GO
CREATE Procedure QGet_AutoApplyFeeDuty(@P_ANO as integer)
AS
Declare @FDTAB Table(LANO Int, Segment varchar(10), FDID varchar(10), FDType varchar(2), REMARK varchar(255), Currency varchar(10), Amount Float, AmountPCT Float, AmountPCTBased Int)

Declare @P_LANO as integer


insert into @FDTAB
Select A.LANO, C.Segment, F.FDID, F.FDType, F.Description as Remark, F.Currency, F.Amount, F.AmountPCT, F.AMOUNTPCTBASED 
from Acceptance A
Inner Join Cover C on (C.CNO=A.CNO and C.ISType in ('I','L'))
Left Join PCalc P on (P.ANO=A.ANO)
Inner Join SysTab on (1=1)
Inner Join FDTAB F on ((F.Atype='ALL' or F.Atype = A.AType) and F.Currency=coalesce(P.Currency, SysTab.Currency) and F.AutoApplyF=1 and F.FDType in ('F','D'))
Left Join FDTABTOC on (FDTABTOC.FDID=F.FDID and FDTABTOC.TOC=A.TOC)
Where A.ANO=@P_ANO and (F.ApplyTOCF=0 or coalesce(FDTABTOC.TOC,'')<>'')

if exists(
	Select Top 1 F.FDID
	from @FDTAB F
	Inner join FDTABDET Fd on (Fd.FDID=F.FDID and (FD.Segment='<All>' or FD.Segment=F.Segment) and fd.Amount<>0)
)
BEGIN
	Select @P_LANO=LANO from @FDTAB F

	if @P_LANO<>@P_ANO -- Individual or Certificate
	BEGIN
		Select Top 1 F.FDID, F.FDType, F.REMARK, F.Currency, Fd.Amount, 0 as AmountPCT, 0 as AmountPCTBased
		from @FDTAB F
		Cross Apply (
			Select 
			sum(Premium) as Premium,             
			sum(Premium*dbo.Premium_Discount(P.CANO,P.Code,P.PolicyYear)/100) as Discount
			from PREMIUM_CALCULATION_BASE(@P_ANO) P
			Where P.Currency=F.Currency
		) P
		Cross Apply (
			Select Fd.Amount
			from FDTABDET FD
			Where Fd.FDID=F.FDID and (FD.Segment='<All>' or FD.Segment=F.Segment) and (P.Premium-P.Discount) Between fd.Lower and fd.upper and fd.Amount<>0
		) Fd
	End
	ELSE
	BEGIN
		Select Top 1 F.FDID, F.FDType, F.REMARK, F.Currency, Fd.Amount, 0 as AmountPCT, 0 as AmountPCTBased
		from @FDTAB F
		Cross Apply (
			Select sum(P.Premium) as Premium, sum(P.Discount) as Discount
			from Acceptance
			Cross Apply (
				Select 
				sum(Premium) as Premium,             
				sum(Premium*dbo.Premium_Discount(P.CANO,P.Code,P.PolicyYear)/100) as Discount
				from PREMIUM_CALCULATION_BASE(Acceptance.ANO) P
				Where P.Currency=F.Currency
			) P
			Where Acceptance.AType='N' and Acceptance.LANO=@P_ANO 
		) P
		Cross Apply (
			Select Fd.Amount
			from FDTABDET FD
			Where Fd.FDID=F.FDID and (FD.Segment='<All>' or FD.Segment=F.Segment) and (P.Premium-P.Discount) Between fd.Lower and fd.upper and fd.Amount<>0
		) Fd


	END
END
Else
BEGIN
	Select Top 1 F.FDID, F.FDType, F.REMARK, F.Currency, F.Amount, F.AmountPCT as AmountPCT, F.AmountPCTBased as AmountPCTBased
	from @FDTAB F
	Where F.AmountPCT<>0 or F.AMOUNTPCTBASED=2
END
go



  insert into PatchVersioning
select '1166 Update Script - Patch 2024 (68) - REV',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1166 Update Script - Patch 2024 (68) - REV'


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
