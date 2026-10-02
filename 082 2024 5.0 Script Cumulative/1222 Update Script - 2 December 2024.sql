if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_Payment_OR_Checking') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function Get_Payment_OR_Checking
end
GO
CREATE Function Get_Payment_OR_Checking(@P_Voucher varchar(30), @P_AsAt smalldatetime)  
RETURNS Bit  AS          
    
BEGIN         
Declare @P_SDate smalldatetime
Declare @P_EDate smalldatetime
Declare @P_CheckingFlag bit

--Last Month Period
Select @P_SDate=dateadd(day,1,EOMONTH(@P_AsAt,-2))
Select @P_EDate=EOMONTH(@P_AsAt,-1)
  
Declare @P_ID as varchar(10)

Select @P_ID=A1.ID 
from Admlink A1
Where ((A1.Subject='Premium' and A1.Type in ('BB','BA','BC','BP','BD')) or (A1.Subject='Claim' and A1.Type in ('DI')))
and A1.Voucher=@P_Voucher

Declare @P_ORNo varchar(50)

Select Top 1 @P_OrNo=coalesce(pSL.OrNo,'')
from pSL
Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)
Inner Join Admlink A1 on (A1.Voucher=pSL.Doc_No and pSL.PaymentF=1)
Where ((A1.Subject='Premium' and A1.Type in ('BB','BA','BC','BP','BD')) or (A1.Subject='Claim' and A1.Type in ('DI')))
and pVoucher.Date Between @P_SDate and @P_EDate and A1.ID=@P_ID and coalesce(pSL.OrNo,'')=''

if @P_OrNo is null
	Select @P_CheckingFlag=1
else
	Select @P_CheckingFlag=0

Return @P_CheckingFlag
End  
  
GO  
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='FORCENEXTPAYMENTOR')
BEGIN
Insert into SysForm(FName, Description, FCode, RequestF)
Select 'FORCENEXTPAYMENTOR', 'Force Check Next Payment Of Comm/Claim has previous payment OR already Received','ACTIVITIES',0
end
go



  insert into PatchVersioning
select '1222 Update Script - 2 December 2024',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1222 Update Script - 2 December 2024'


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