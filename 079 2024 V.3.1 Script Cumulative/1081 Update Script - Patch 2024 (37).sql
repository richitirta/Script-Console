Alter Table VoucherPic drop constraint I_VoucherPIC
GO
Alter Table VoucherPic Alter Column Voucher varchar(30)
GO
Create Unique Index I_VoucherPIC on VoucherPic(Voucher,ImageID)
GO
Alter Table RPBucket Alter Column Voucher varchar(30)
GO
Alter Table Request Alter Column Voucher varchar(30)
GO
Alter Table Cheque Alter Column Voucher varchar(30)
GO
Alter Table GL_FiscalH Alter Column Voucher varchar(30)
GO
Alter Table ComAcc_Cheque Alter Column Voucher varchar(30)
GO





insert into PatchVersioning
select '1081 Update Script - Patch 2024 (37)',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1081 Update Script - Patch 2024 (37)'


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