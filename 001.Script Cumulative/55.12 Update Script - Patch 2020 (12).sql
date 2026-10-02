if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Premium_Fee') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
Drop Function Premium_Fee
END
GO
CREATE Function Premium_Fee(@P_ANO as int,@P_Period int=0) 
RETURNS Float 
AS 
BEGIN 

Declare @P_OPFEEPCT Float


Select @P_OPFEEPCT=Sum(Fee)
From
(
	Select
		sum(Fee*Pcalc.Rate)/Max(Pcalc.Gross*Pcalc.Rate)*100 as Fee
	from
	(
		SELECT 
		A1.Currency,
		Case When A1.Amount<>0 Then
			A1.Amount*100/coalesce(R.PCTSHARE-R.MSHARE,100)
		Else
			(
				Select 
				sum(D1.Gross*P.Gross/P.OGross)
				from Display_Calculation(A2.ANO) D1, Acceptance A, PCalc P
				Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and D1.Currency=A1.Currency
			)*A1.AmountPCT/100
		End    as FEE
		from 
		Acceptance A3
		Inner Join Acceptance A2 on (A2.OANO=A3.OANO and A2.ANO<=@P_ANO)
		INNER JOIN AccFD A1 on (A1.ANO=A2.ANO and A1.ContributionF=0 And A1.AmountPCTBased=0 And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
		INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID AND Left(FDTAB.FDType,1)='O')
		INNER JOIN RARRHEADER R ON (R.ANO=A3.ANO)
		Where A3.ANO=@P_ANO and A2.ANO>(Select coalesce(Max(ANO),0) from Acceptance Where AType='C' and EMethod='A' and Acceptance.OANO=A2.OANO and Acceptance.ANO<=@P_ANO and AStatus not in ('W','T'))
	) R
	Inner Join PCalc on (PCalc.ANO=@P_ANO and PCalc.Currency=R.Currency)	

	Union All

	--Op Fee from Master Policy
	Select
		sum(Fee*Pcalc.Rate)/Max(Pcalc.Gross*Pcalc.Rate)*100 as Fee
	from
	(
		SELECT
		A1.Currency,
		Case When A1.Amount<>0 Then
			--Not Yet for Master Policy
			0
		Else
			(
				Select 
				sum(D1.Gross*P.Gross/P.OGross)
				from Display_Calculation(A2.ANO) D1, Acceptance A, PCalc P
				Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and D1.Currency=A1.Currency
			)*A1.AmountPCT/100
		End    as FEE
		from
		Acceptance A3 
		Inner Join Acceptance A2 on (A2.OANO=A3.OANO and A2.ANO<=@P_ANO)
		INNER JOIN Acceptance MA on (MA.RegNo=A2.RegNo and MA.ANO=MA.LANO)
		INNER JOIN COVER C on (C.CNO=MA.CNO and C.OPENFLAG=0)
		INNER JOIN AccFD A1 on (A1.ANO=MA.ANO and A1.ContributionF=0 and A1.AmountPCTBased=0 And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
		INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID and left(FDTAB.FDType,1)='O')
		INNER JOIN RARRHEADER R ON (R.ANO=A2.ANO)
		Where A3.ANO=@P_ANO and A2.ANO>(Select coalesce(Max(ANO),0) from Acceptance Where AType='C' and EMethod='A' and Acceptance.OANO=A2.OANO and Acceptance.ANO<=@P_ANO and AStatus not in ('W','T'))
	) R
	Inner Join PCalc on (PCalc.ANO=@P_ANO and PCalc.Currency=R.Currency)	
) A

if @P_OPFEEPCT is null 
	Select @P_OPFEEPCT=0

return (@P_OPFEEPCT) 
 
End


GO

insert into PatchVersioning
select '55.12 Update Script - Patch 2020 (12)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='55.11 Update Script - Patch 2020 (11)'
Select @CurrSCript='55.12 Update Script - Patch 2020 (12)'


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



