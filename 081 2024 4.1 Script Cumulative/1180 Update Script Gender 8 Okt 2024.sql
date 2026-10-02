
ALTER TABLE GENDER ADD
DESCRIPTION VARCHAR(50)
GO

ALTER TABLE GENDER ADD
BeneficiariesGENDER VARCHAR(50)
GO

-- Mapping Profile gender to Beneficiary gender
UPDATE GENDER SET DESCRIPTION='Male (Laki-laki)',BeneficiariesGENDER='Laki-laki' where gender like 'male%'
GO
UPDATE GENDER SET DESCRIPTION='Female (Perempuan)',BeneficiariesGENDER='Perempuan' where gender like '%Female%'
GO

select * from GENDER
go



  insert into PatchVersioning
select '1180 Update Script Gender 8 Okt 2024',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1180 Update Script Gender 8 Okt 2024'


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



