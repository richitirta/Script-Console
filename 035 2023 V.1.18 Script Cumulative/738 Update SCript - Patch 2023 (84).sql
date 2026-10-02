
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='AccInvoice' AND CONSTRAINT_NAME='FK_ACCINVOICE_ICOVER')
Begin
Alter Table AccInvoice drop constraint FK_ACCINVOICE_ICOVER
end
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='ICoverDet' AND CONSTRAINT_NAME='FK_ICOVERDET_ICOVER')
Begin
Alter Table ICoverDet drop constraint FK_ICOVERDET_ICOVER
end
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='ICoverExt' AND CONSTRAINT_NAME='FK_ICoverExt_ICOVER')
Begin
Alter Table ICoverExt drop constraint FK_ICoverExt_ICOVER
end
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='ICoverNOC' AND CONSTRAINT_NAME='FK_ICoverNOC_ICOVER')
Begin
Alter Table ICoverNOC drop constraint FK_ICoverNOC_ICOVER
end
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='IINFO' AND CONSTRAINT_NAME='FK_IINFO_ICOVER')
Begin
Alter Table IINFO drop constraint FK_IINFO_ICOVER
end
GO

DROP TRIGGER DROP_ICOVER_LINK
GO
CREATE TRIGGER DROP_ICOVER_LINK
ON ICOVER
AFTER DELETE
AS
BEGIN
       Delete I from ICOVERDET I, Deleted D Where I.INO=D.INO
       Delete I from ICOVERNOC I, Deleted D Where I.INO=D.INO
       Delete I from ICoverExt I, Deleted D Where I.INO=D.INO
       Delete I from IINFO I, Deleted D Where I.INO=D.INO
       Delete I from ACCINVOICE I, Deleted D Where I.INO=D.INO
END

GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='nJournal' AND CONSTRAINT_NAME='FK_nJournal_nVoucher')
Begin
Alter Table nJournal Drop Constraint FK_nJournal_nVoucher
end
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='nSL' AND CONSTRAINT_NAME='FK_nSL_nVoucher')
Begin
Alter Table nSL Drop Constraint FK_nSL_nVoucher
end
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='ORPrintLog' AND CONSTRAINT_NAME='FK_ORPrintLog_pVoucher')
Begin
Alter Table ORPrintLog Drop Constraint FK_ORPrintLog_pVoucher
end
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='pJournal' AND CONSTRAINT_NAME='FK_pJournal_pVoucher')
Begin
Alter Table pJournal Drop Constraint FK_pJournal_pVoucher
end
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='pSL' AND CONSTRAINT_NAME='FK_pSL_pVoucher')
Begin
Alter Table pSL Drop Constraint FK_pSL_pVoucher
end
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='pSLRef' AND CONSTRAINT_NAME='FK_pSLRef_pVoucher')
Begin
Alter Table pSLRef Drop Constraint FK_pSLRef_pVoucher
end
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='pSLSum' AND CONSTRAINT_NAME='FK_pSLSum_pVoucher')
Begin
Alter Table pSLSum Drop Constraint FK_pSLSum_pVoucher
end
GO

DROP TRIGGER DROP_NVOUCHER_LINK
GO
CREATE TRIGGER DROP_NVOUCHER_LINK
ON NVOUCHER
AFTER DELETE
AS
BEGIN
       Delete I from NJournal I, Deleted D Where I.Voucher=D.Voucher
	   Delete I from nSL I, Deleted D Where I.Voucher=D.Voucher
END

GO

DROP TRIGGER DROP_PVOUCHER_LINK
GO
CREATE TRIGGER DROP_PVOUCHER_LINK
ON PVOUCHER
AFTER DELETE
AS
BEGIN
       Delete I from pJournal I, Deleted D Where I.Voucher=D.Voucher
	   Delete I from pSL I, Deleted D Where I.Voucher=D.Voucher
	   Delete I from pSLRef I, Deleted D Where I.Voucher=D.Voucher
	   Delete I from pSLSum I, Deleted D Where I.Voucher=D.Voucher
	   Delete I from ORPrintLog I, Deleted D Where I.Voucher=D.Voucher
END


go


 insert into PatchVersioning	
select '738 Update SCript - Patch 2023 (84)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(1004)

Select @PrevScript=''
Select @CurrSCript='738 Update SCript - Patch 2023 (84)'


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
