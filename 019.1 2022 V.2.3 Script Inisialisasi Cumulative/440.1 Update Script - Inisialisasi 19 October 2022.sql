

Update CollectionH Set OCollNo=CollNo from CollectionH Where CollectionH.OCollNo is null and CollectionH.Reminder=0
go
Update CollectionH Set OCollNo=pCollectionH.OCollNo from CollectionH, CollectionH pCollectionH Where CollectionH.OCollNo is null and pCollectionH.CollNo=CollectionH.pCollNo and CollectionH.Reminder=1 
go
Update CollectionH Set OCollNo=pCollectionH.OCollNo from CollectionH, CollectionH pCollectionH Where CollectionH.OCollNo is null and pCollectionH.CollNo=CollectionH.pCollNo and CollectionH.Reminder=2
go
Update CollectionH Set OCollNo=pCollectionH.OCollNo from CollectionH, CollectionH pCollectionH Where CollectionH.OCollNo is null and pCollectionH.CollNo=CollectionH.pCollNo and CollectionH.Reminder=3
GO


 insert into PatchVersioning
select '440.1 Update Script - Inisialisasi 19 October 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='440.1 Update Script - Inisialisasi 19 October 2022'


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
