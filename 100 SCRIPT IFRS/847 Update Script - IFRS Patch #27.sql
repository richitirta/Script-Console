IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_31' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Claim_Expected_31
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_32' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Claim_Expected_32
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_33' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Claim_Expected_33
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_34' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Claim_Expected_34
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_35' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Claim_Expected_35
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_36' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Claim_Expected_36
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_37' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Claim_Expected_37
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_38' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Claim_Expected_38
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_39' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Claim_Expected_39
END
GO

IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_PAD_31' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Claim_Expected_PAD_31
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_PAD_32' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Claim_Expected_PAD_32
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_PAD_33' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Claim_Expected_PAD_33
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_PAD_34' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Claim_Expected_PAD_34
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_PAD_35' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Claim_Expected_PAD_35
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_PAD_36' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Claim_Expected_PAD_36
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_PAD_37' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Claim_Expected_PAD_37
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_PAD_38' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Claim_Expected_PAD_38
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_PAD_39' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL DROP COLUMN BEL_Claim_Expected_PAD_39
END
GO

IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_31' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Claim_Expected_31
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_32' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Claim_Expected_32
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_33' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Claim_Expected_33
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_34' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Claim_Expected_34
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_35' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Claim_Expected_35
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_36' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Claim_Expected_36
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_37' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Claim_Expected_37
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_38' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Claim_Expected_38
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_39' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Claim_Expected_39
END
GO

IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_PAD_31' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Claim_Expected_PAD_31
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_PAD_32' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Claim_Expected_PAD_32
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_PAD_33' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Claim_Expected_PAD_33
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_PAD_34' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Claim_Expected_PAD_34
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_PAD_35' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Claim_Expected_PAD_35
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_PAD_36' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Claim_Expected_PAD_36
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_PAD_37' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Claim_Expected_PAD_37
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_PAD_38' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Claim_Expected_PAD_38
END
GO
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Claim_Expected_PAD_39' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL DROP COLUMN BEL_Claim_Expected_PAD_39
END
GO


IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'NumYearsCP' AND Object_ID = Object_ID(N'IFRS_Calculation'))
BEGIN
ALTER TABLE IFRS_Calculation DROP COLUMN NumYearsCP
END
GO

IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'NumYearsCP' AND Object_ID = Object_ID(N'IFRS_Initial'))
BEGIN
ALTER TABLE IFRS_Initial DROP COLUMN NumYearsCP
END
GO

insert into PatchVersioning
select '847 Update Script - IFRS Patch #27',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='847 Update Script - IFRS Patch #27'


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
