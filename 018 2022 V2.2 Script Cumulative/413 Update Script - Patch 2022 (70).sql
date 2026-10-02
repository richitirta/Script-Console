DROP FUNCTION TREATY_FUNDHELD_PROCESS
GO
CREATE FUNCTION TREATY_FUNDHELD_PROCESS(@P_Type varchar(2),@P_Date smalldatetime, @P_PEDate smalldatetime,@P_EDate smalldatetime, @IRate as Float)            
RETURNS TABLE            
AS RETURN(            
--- replacing A.A_SDate --> (A.Date)
--- replacing A.A_EDate --> (dateadd(year,1,A.Date))
Select A.DocNo, A.RefNo, A.Branch, A.CT, A.Remarks, A.ID, A.A_ID, A.Source, A.ISType, A.Segment, 
A.Type, A.Code, A.Currency, A.A_PolicyNo, A.A_MO, A.RefType, A.AccountNo, A.BankAccount, A.BankName,
A.Bank, A.BankBranch, (A.Date) as A_SDate, (dateadd(year,1,A.Date)) as A_EDate, A.Statement, A.ASource, A.MSCode, A.BizMapID ,

--Fund Held
case when A.Date>@P_PEDate and A.Date<=@P_EDate then -A.Amount_1 else 0 end
+
--Fund Held Previous
Case When @P_PEDate>=(A.Date) then A.Amount_1* dbo.fn_Get_Prorata24((A.Date), (dateadd(year,1,A.Date)), @P_PEDate) else A.Amount_1 end
-
--Fund Held Current
Case When @P_EDate>=(A.Date) then A.Amount_1* dbo.fn_Get_Prorata24((A.Date), (dateadd(year,1,A.Date)), @P_EDate) else A.Amount_1 end as Amount_4,

--Fund_Held_Int
Case When @P_EDate>=(A.Date) then A.Amount_1* dbo.fn_Get_Prorata24((A.Date), (dateadd(year,1,A.Date)), @P_EDate) else A.Amount_1 end*@IRate/12/100 as Amount_15,

--Fund Held WHTax
-dbo.RoundCCY(Case When @P_EDate>=(A.Date) then A.Amount_1* dbo.fn_Get_Prorata24((A.Date), (dateadd(year,1,A.Date)), @P_EDate) else A.Amount_1 end*@IRate/12/100*TaxType.TaxRate/100,A.Currency) as Amount_14,

Case When @P_EDate>=(A.Date) then A.Amount_1* dbo.fn_Get_Prorata24((A.Date), (dateadd(year,1,A.Date)), @P_EDate) else A.Amount_1 end*@IRate/12/100 as PNominal_Tax,
@IRate as IRate

from Admlink A
Inner Join SysTab on (1=1)
Inner Join TaxType on (TaxType.TaxType=SysTab.TaxTypeFH)
inner join RPart on (RPart.DocNo=A.RefNo and RPart.ID=A.ID)
Inner Join Reinsurance on (Reinsurance.RNO=RPart.RNO and Reinsurance.FundHeldF=1)
Where A.Type in ('AF','QS','QP','S1','S2','S3') and A.Subject='Premium' and A.EXTRA_1<>'Fund Held' and A.AMOUNT_1<>0
and A.Date<=@P_EDate
and 
(
((A.Date)>@P_PEDate and (A.Date)<=@P_EDate) or
(@P_EDate Between (A.Date) and (dateadd(year,1,A.Date))) or
((dateadd(year,1,A.Date))>@P_PEDate and (dateadd(year,1,A.Date))<=@P_EDate)
)
)            
go


 insert into PatchVersioning
select '413 Update Script - Patch 2022 (70)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='413 Update Script - Patch 2022 (70)'


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








