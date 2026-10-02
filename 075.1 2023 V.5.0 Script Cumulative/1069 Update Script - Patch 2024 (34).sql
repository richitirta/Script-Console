DROP Procedure Get_Fee_Amount_By_Percentage
GO
Create Procedure Get_Fee_Amount_By_Percentage(@P_ANO as Int, @P_Code as varchar(10), @P_FDType as varchar(1), @P_AmountPCT as Float, @P_AmountPCTBased as Int=0, @P_PolicyYear as Int=0)
as
Declare @P_LANO as integer
Declare @P_REGNO as varchar(50)
Declare @P_AStatus as varchar(1)
Declare @P_CStatus as varchar(1)
Declare @P_ASource as varchar(10)
Declare @P_AType as varchar(1)
Declare @P_OpenFlag as Bit
Declare @P_Fee as Float

Select @P_LANO=A.LANO, @P_REGNO=A.REGNO, @P_AType=A.AType, @P_AStatus=A.AStatus, @P_ASource=C.ASource, @P_CStatus=C.CStatus, @P_OpenFlag=C.OpenFlag 
from Acceptance A
Inner Join Cover C on (C.CNO=A.CNO)
Where C.CNO=A.CNO and A.ANO=@P_ANO

--Not Confirm Quotation nor Open Master Policy
IF not ((@P_ASource='MKT' and @P_AType='N' and @P_CStatus='A') or (@P_OpenFlag=0 and @P_ANO=@P_LANO)) 
Begin

	if @P_LANO<>@P_ANO -- Individual or Certificate
	BEGIN
		if @P_AmountPCTBased=0 or @P_AmountPCTBased=3
		BEGIN
			Select 
			@P_FEE=
			Case 
			When Left(@P_FDTYPE,1)<>'O' Then 
				sum(D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*case When @P_AmountPCTBased=3 Then (1-dbo.Premium_Commission(D1.ANO, D1.Code,@P_PolicyYear,0)/100) else 1 end)
			Else
				sum(D1.Gross*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100*case When @P_AmountPCTBased=3 Then (1-dbo.Premium_Commission(D1.ANO, D1.Code,@P_PolicyYear,0)/100) else 1 end)
			End*@P_AmountPCT/100
			from Display_Calculation(@P_ANO) D1
			Inner Join Acceptance A on (A.ANO=D1.ANO)
			Inner Join RArrHeader R on (R.ANO=D1.ANO)
			Inner Join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)
			Where D1.Currency=@P_Code
			and (@P_PolicyYear=0 or (D1.SDate>=dateadd(month,12*(@P_PolicyYear-1),A.SDate) and D1.SDate<dateadd(month,12*(@P_PolicyYear),A.SDate)))
		END
		ELSE
		BEGIN
			Select 
			@P_FEE=
			Case 
			When Left(@P_FDTYPE,1)<>'O' Then 
				coalesce(Max(P.OurShare),0)-coalesce(Max(PP.OurShare),0)
			Else
				coalesce(Max(P.OurShare*(100-R.MSHARE)/100),0)-coalesce(Max(PP.OurShare*(100-PR.MSHARE)/100),0)
			End*@P_AmountPCT/100
			from Acceptance A
			Left Join Acceptance PA on (PA.ANO=A.PANO)
			Left Join PCalc P on (P.ANO=A.ANO and P.Currency=@P_Code and A.AType Not in ('A','C'))
			Left Join RArrHeader R on (R.ANO=A.ANO and A.AType Not in ('A','C'))
			Left Join PCalc PP on (PP.ANO=A.PANO and PP.Currency=P.Currency and PA.AType Not in ('A','C'))
			Left Join RArrHeader PR on (PR.ANO=A.PANO and PA.AType Not in ('A','C'))		
			Where A.ANO=@P_ANO
		END
	END
	ELSE	-- Fleet Only
	BEGIN
		if @P_AmountPCTBased=0 or @P_AmountPCTBased=3
		BEGIN
			SELECT @P_FEE=SUM(FEE)
			FROM
			(
				SELECT
				ACCEPTANCE.ANO,
				(
					Select 
					Case 
					When Left(@P_FDTYPE,1)<>'O' Then 
						sum(D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*case When @P_AmountPCTBased=3 Then (1-dbo.Premium_Commission(D1.ANO, D1.Code,@P_PolicyYear,0)/100) else 1 end)
					ELSE 
						sum(D1.Gross*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100*case When @P_AmountPCTBased=3 Then (1-dbo.Premium_Commission(D1.ANO, D1.Code,@P_PolicyYear,0)/100) else 1 end)
					End*@P_AmountPCT/100
					from Display_Calculation(ACCEPTANCE.ANO) D1
					Inner Join Acceptance A on (A.ANO=D1.ANO)
					Inner Join RArrHeader R on (R.ANO=D1.ANO)
					Inner Join PCalc P on (P.ANO=D1.ANO and P.Currency=D1.Currency)
					Where D1.Currency=@P_Code
					and (@P_PolicyYear=0 or (D1.SDate>=dateadd(month,12*(@P_PolicyYear-1),A.SDate) and D1.SDate<dateadd(month,12*(@P_PolicyYear),A.SDate)))
				) as FEE
				FROM ACCEPTANCE
				WHERE ACCEPTANCE.ANO<>ACCEPTANCE.LANO 				
				And ((Acceptance.AStatus in ('W','T') and Acceptance.LANO=@P_ANO) or (Acceptance.AStatus not in ('W','T') and Acceptance.RegNo<>'' and Acceptance.RegNo=@P_RegNo))
			) A
		END
		ELSE
		BEGIN
			SELECT @P_FEE=SUM(FEE)
			FROM
			(
				SELECT
				ACCEPTANCE.ANO,
				(
					Select 
					Case 
					When Left(@P_FDTYPE,1)<>'O' Then 
						coalesce(Max(P.OurShare),0)-coalesce(Max(PP.OurShare),0)
					Else
						coalesce(Max(P.OurShare*(100-R.MSHARE)/100),0)-coalesce(Max(PP.OurShare*(100-PR.MSHARE)/100),0)
					End*@P_AmountPCT/100
					from Acceptance A
					Left Join Acceptance PA on (PA.ANO=A.PANO)
					Left Join PCalc P on (P.ANO=A.ANO and P.Currency=@P_Code and A.AType Not in ('A','C'))
					Left Join RArrHeader R on (R.ANO=A.ANO and A.AType Not in ('A','C'))
					Left Join PCalc PP on (PP.ANO=A.PANO and PP.Currency=P.Currency and PA.AType Not in ('A','C'))
					Left Join RArrHeader PR on (PR.ANO=A.PANO and PA.AType Not in ('A','C'))		
					Where A.ANO=ACCEPTANCE.ANO
				) as FEE
				FROM ACCEPTANCE
				WHERE ACCEPTANCE.ANO<>ACCEPTANCE.LANO 
				And ((Acceptance.AStatus in ('W','T') and Acceptance.LANO=@P_ANO) or (Acceptance.AStatus not in ('W','T') and Acceptance.RegNo<>'' and Acceptance.RegNo=@P_RegNo))
			) A
		END
	END
END
ELSE
BEGIN
	SELECT @P_FEE=0
END

SELECT @P_FEE AS FEE
go



 insert into PatchVersioning	
select '1069 Update Script - Patch 2024 (34)',GETDATE()
go

insert into PatchVersioning
select '1069 Update Script - Patch 2024 (34)',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1069 Update Script - Patch 2024 (34)'


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
