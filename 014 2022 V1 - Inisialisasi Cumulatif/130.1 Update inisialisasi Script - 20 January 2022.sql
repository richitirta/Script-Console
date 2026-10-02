--UDAH UPGRADE & UDAH JALANIN SCRIPT UPDATE AC
IF  EXISTS(SELECT * FROM Profile WHERE VATOLD is null OR VAT=11)
BEGIN
Update Profile Set VATOLD=10 WHERE VAT=11
end
GO

--UDAH UPGRADE TAPI BELUM JALANIN SCRIPT AC
IF EXISTS(SELECT * FROM Profile WHERE VATOLD is null)
BEGIN
Update Profile Set VATOLD=VAT Where VATOLD is null
end
GO

--UDAH UPGRADE & UDAH JALANIN SCRIPT UPDATE AC
IF EXISTS(SELECT * FROM MParam WHERE VATOLD IS NULL OR VAT=11)
BEGIN
Update MParam Set 
Effective='04/01/2022', 
VATOLD=VAT, 
PASAL21OLD=PASAL21, 
PASAL23OLD=PASAL23, 
PASAL26OLD=PASAL26, 
PASAL4OLD=PASAL4 
Where VATOLD IS NULL
end
go


--UDAH UPGRADE TAPI BELUM JALANIN SCRIPT AC
IF NOT EXISTS(SELECT * FROM MParam WHERE VATOLD IS NULL)
BEGIN
Update MParam Set 
Effective='04/01/2022', 
VATOLD=VAT, 
PASAL21OLD=PASAL21, 
PASAL23OLD=PASAL23, 
PASAL26OLD=PASAL26, 
PASAL4OLD=PASAL4 
Where VATOLD IS NULL
end
go




 insert into PatchVersioning
select '130.1 Update inisialisasi Script - 20 January 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='130.1 Update inisialisasi Script - 20 January 2022'


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
