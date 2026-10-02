IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ConsentOnDataKeepByCompanyF' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE dbo.Profile ADD
	ConsentOnDataKeepByCompanyF bit NULL
DECLARE @v sql_variant 
SET @v = N'Consent on Data Keep By Company (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'ConsentOnDataKeepByCompanyF'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ConsentOnDataPrivacyToThirdPartyF' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE dbo.Profile ADD
	ConsentOnDataPrivacyToThirdPartyF bit NULL
DECLARE @v sql_variant 
SET @v = N'Consent on Data Privacy to Third Party (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'ConsentOnDataPrivacyToThirdPartyF'
END
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ConsentOnProductAndServiceOfferingF' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE dbo.Profile ADD
	ConsentOnProductAndServiceOfferingF bit NULL
DECLARE @v sql_variant 
SET @v = N'Persetujuan untuk Penawaran Product dan Jasa (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'ConsentOnProductAndServiceOfferingF'
END
GO



 insert into PatchVersioning	
select '650 Update Script - 29 May 2023 (2)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='650 Update Script - 29 May 2023 (2)'


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



