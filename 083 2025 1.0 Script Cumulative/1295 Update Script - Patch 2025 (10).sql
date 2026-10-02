IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'I_ARPRINTLOG_Request_DocNo') AND parent_object_id = OBJECT_ID(N'ARPRINTLOG'))
BEGIN 
Alter Table ARPRINTLOG drop constraint I_ARPRINTLOG_Request_DocNo
END
GO
IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_ARPRINTLOG_Request_DocNo' AND object_id = OBJECT_ID('ARPRINTLOG'))
BEGIN
Create index I_ARPRINTLOG_Request_DocNo on ARPRINTLOG(Request, DocNo)
END
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'I_ORPrintLog_Voucher_DocNo') AND parent_object_id = OBJECT_ID(N'ORPRINTLOG'))
BEGIN
Alter Table ORPRINTLOG drop constraint I_ORPrintLog_Voucher_DocNo
END
GO
IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_ORPrintLog_Voucher_DocNo' AND object_id = OBJECT_ID('ORPrintLog'))
BEGIN
Create index I_ORPrintLog_Voucher_DocNo on ORPrintLog(Voucher, DocNo)
end
GO


  insert into PatchVersioning
select '1295 Update Script - Patch 2025 (10)',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1295 Update Script - Patch 2025 (10)'


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