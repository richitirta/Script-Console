SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Description_1' AND Object_ID = Object_ID(N'City'))
begin
ALTER TABLE City ADD Description_1 varchar (512) NULL
end 
go
update city set Description_1 = '' where Description_1 is null
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Code_ext' AND Object_ID = Object_ID(N'Country'))
begin
ALTER TABLE Country ADD Code_Ext varchar (3) NULL
end 
go

update Country set Code_Ext ='' where Code_Ext is null
go


insert into PatchVersioning
select '1371 R[OONA PH CHISS] - Penambahan Description_1 di table City dan Code_ext di table Country',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1371 R[OONA PH CHISS] - Penambahan Description_1 di table City dan Code_ext di table Country'


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