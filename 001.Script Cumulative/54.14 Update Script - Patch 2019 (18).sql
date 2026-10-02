IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_nSL_Doc_No_PVoucher' AND object_id = OBJECT_ID('nSL'))
BEGIN
drop index nSL.I_nSL_Doc_No_PVoucher
end
GO
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_nSL_Doc_No_PVoucher' AND object_id = OBJECT_ID('nSL'))
BEGIN
create index I_nSL_PVoucher_DocNo on nSL(pVoucher,Doc_No) include (voucher)
end
go


  insert into PatchVersioning
select '54.14 Update Script - Patch 2019 (18)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='54.13 Update Script - Patch 2019 (17)'
Select @CurrSCript='54.14 Update Script - Patch 2019 (18)'


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

