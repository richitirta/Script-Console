if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_Payment_Percentage') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function Get_Payment_Percentage
END
GO
CREATE Function Get_Payment_Percentage(@P_A_PolicyNo varchar(50), @P_Type varchar(10), @P_DocNO varchar(50), @P_Date smalldatetime)
RETURNS Float AS        
  
BEGIN       
Declare @PCT as Float

Select 
@PCT=
sum(case When V.DebtorF=1 Then (V.Payment_CC) Else -(V.Payment_CC) end)/sum(case When V.DebtorF=1 Then (V.Nominal_CC) Else -(V.Nominal_CC) end)*100

from (

       Select V.Voucher, 
       cast(Max(Cast(V.DebtorF as Int)) as Bit) as DebtorF,
       Case 
       When @P_TYPE in ('PI','PL') Then Max(V.Payment_CC)
       When Max(V.Payment_CC)<sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount)) Then 0
       Else Max(V.Payment_CC)-sum((case When V.DebtorF=1 Then 1 else -1 end)*(A.LAmount))
       End as Payment_CC,

       sum(
              (case When V.DebtorF=1 Then 1 else -1 end)*
              Case
              When @P_Type in ('PI','PL') then (A.Amount)
              Else (A.Amount-A.LAmount)
              End
       ) as Nominal_CC
       from nVoucher V, Admlink A
       Where A.Voucher=V.Voucher
       and A.Date<=@P_Date and A.A_PolicyNo=@P_A_PolicyNo and (substring(A.DocNo,1,50)+space(50-len(A.DocNo))+convert(varchar(50), A.Date,102))<=(substring(@P_DocNo,1,50)+space(50-len(@P_DocNo))+convert(varchar(50), @P_Date,102)) and A.Subject='Premium' and A.Type in ('DI','IC','IR')
	   and (substring(A.DocNo,1,50)+space(50-len(A.DocNo))+convert(varchar(50), A.Date,102))> coalesce((Select Top 1 (substring(B.DocNo,1,50)+space(50-len(B.DocNo))+convert(varchar(50), B.Date,102)) from Admlink B Where B.Date<=@P_Date and B.A_PolicyNo=@P_A_PolicyNo and (substring(B.DocNo,1,50)+space(50-len(B.DocNo))+convert(varchar(50), B.Date,102))<(substring(A.DocNo,1,50)+space(50-len(A.DocNo))+convert(varchar(50), A.Date,102)) and B.Subject='Premium' and B.Type=@P_Type order by B.AdmNo Desc),'')	   
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

insert into PatchVersioning
select '55.38 Update Script - Patch 2020 (38)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='55.37 Update Script - Patch 2020 (37)'
Select @CurrSCript='55.38 Update Script - Patch 2020 (38)'


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


