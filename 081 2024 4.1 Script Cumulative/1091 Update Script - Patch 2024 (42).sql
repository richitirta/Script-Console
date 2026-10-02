Alter Table ReminderV Drop Constraint  FK_ReminderV_nVoucher
GO
Alter Table nVoucher drop constraint I_NVoucher
GO
ALTER TABLE nVoucher DROP CONSTRAINT [DF__nVoucher__Rate_R__0EC85418]
GO
Create Unique Index I_NVoucher on nVoucher(Voucher)
GO
ALTER INDEX I_NVoucher ON nVoucher REBUILD WITH (ALLOW_PAGE_LOCKS = OFF, ALLOW_ROW_LOCKS = ON)
 GO 
ALTER INDEX I_Voucher_ComAcc ON nVoucher REBUILD WITH (ALLOW_PAGE_LOCKS = OFF, ALLOW_ROW_LOCKS = ON)
 GO 
ALTER INDEX I_Voucher_ProAcc ON nVoucher REBUILD WITH (ALLOW_PAGE_LOCKS = OFF, ALLOW_ROW_LOCKS = ON)
 GO 
ALTER INDEX I_Voucher_DocNo ON nVoucher REBUILD WITH (ALLOW_PAGE_LOCKS = OFF, ALLOW_ROW_LOCKS = ON)
 GO 
ALTER INDEX I_Voucher_RefNo ON nVoucher REBUILD WITH (ALLOW_PAGE_LOCKS = OFF, ALLOW_ROW_LOCKS = ON)
 GO 
ALTER INDEX I_Voucher_Date ON nVoucher REBUILD WITH (ALLOW_PAGE_LOCKS = OFF, ALLOW_ROW_LOCKS = ON)
 GO 
ALTER INDEX I_Voucher_DueDate ON nVoucher REBUILD WITH (ALLOW_PAGE_LOCKS = OFF, ALLOW_ROW_LOCKS = ON)
 GO 
ALTER INDEX I_Voucher_PDate ON nVoucher REBUILD WITH (ALLOW_PAGE_LOCKS = OFF, ALLOW_ROW_LOCKS = ON)
 GO 
ALTER INDEX I_NVoucher_Branch_Date ON nVoucher REBUILD WITH (ALLOW_PAGE_LOCKS = OFF, ALLOW_ROW_LOCKS = ON)
 GO 

 
insert into PatchVersioning
select '1091 Update Script - Patch 2024 (42)',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1091 Update Script - Patch 2024 (42)'


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
