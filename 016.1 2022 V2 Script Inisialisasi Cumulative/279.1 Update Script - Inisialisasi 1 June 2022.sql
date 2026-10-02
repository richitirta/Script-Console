
insert into PNCategory(Category, AllowedF)
Select 'QUOTATION', 1
union all
Select 'POLICY', 1
union all
Select 'OTHERS',1

GO

insert into CLNCategory(Category, AllowedF)
Select 'CLAIM', 1
union all
Select 'SALVAGE', 1
union all
Select 'SUBROGATION', 1
union all
Select 'OTHERS',1

GO


Update COBExt Set Category='' Where Category is null
GO



 insert into PatchVersioning
select '279.1 Update Script - Inisialisasi 1 June 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='279.1 Update Script - Inisialisasi 1 June 2022'


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

