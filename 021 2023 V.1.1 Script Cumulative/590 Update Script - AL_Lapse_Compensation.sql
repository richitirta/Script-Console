DROP Procedure AL_Lapse_Compensation_In_Request
GO
CREATE Procedure AL_Lapse_Compensation_In_Request(@P_PDate as smalldatetime, @P_A_PolicyNo as varchar(50))            
as            
Select Top 1 Request.Request, Admlink.Voucher        
from ALBucket
Inner Join Admlink on (Admlink.A_PolicyNo=ALBucket.A_PolicyNo and Admlink.Type in ('DI','IC','IR','CF','JP','BB','BA','BC','BP','BD','BO','BC','BP') and Admlink.Subject='Premium')       
Inner Join SL_Request on (SL_Request.Doc_No=Admlink.Voucher and SL_Request.PaymentF=1)
Inner Join Request on (Request.Request=SL_Request.Request and Request.Status<>'C' and Request.Voucher = '')
Where ALBucket.A_PolicyNo=@P_A_PolicyNo and ALBucket.Status in ('N','H','P')
GO

DROP Procedure AL_Lapse_Compensation_In_Collection
GO
CREATE Procedure AL_Lapse_Compensation_In_Collection(@P_PDate as smalldatetime, @P_A_PolicyNo as varchar(50))                      
as                
Select Top 1 CollectionH.CollNo, Admlink.Voucher            
from ALBucket
Inner Join Admlink on (Admlink.A_PolicyNo=ALBucket.A_PolicyNo and Admlink.Type in ('DI','IC','IR','CF','JP','BB','BA','BC','BP','BD','BO','BC','BP') and Admlink.Subject='Premium')
Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)
Inner Join CollectionV on (CollectionV.CollNo<>nVoucher.CollNo and CollectionV.Voucher=nVoucher.Voucher) 
Inner Join CollectionH on (CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus<>'C')
Where ALBucket.A_PolicyNo=@P_A_PolicyNo and ALBucket.Status in ('N','H','P')
and CollectionV.CollNo=CollectionH.CollNo  and CollectionV.Voucher=Admlink.Voucher 
GO


DROP Procedure AL_Lapse_Compensation_In_Paid
GO
CREATE Procedure AL_Lapse_Compensation_In_Paid(@P_PDate as smalldatetime, @P_A_PolicyNo as varchar(50))                
as                
Select Top 1 pVoucher.Voucher as pVoucher, Admlink.Voucher            
from ALBucket
Inner Join Admlink on (Admlink.A_PolicyNo=ALBucket.A_PolicyNo and Admlink.Type in ('DI','IC','IR','CF','JP','BB','BA','BC','BP','BD','BO','BC','BP') and Admlink.Subject='Premium')
Inner join pSL on (pSL.Doc_No=Admlink.Voucher and pSL.PaymentF=1)
Inner join pVoucher on (pVoucher.Voucher=pSL.Voucher and pVoucher.Date>=ALBucket.PDate)
Where ALBucket.A_PolicyNo=@P_A_PolicyNo and ALBucket.Status in ('N','H','P')

GO


 insert into PatchVersioning	
select '590 Update Script - AL_Lapse_Compensation',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='590 Update Script - AL_Lapse_Compensation'


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


