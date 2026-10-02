IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_CLCOST' AND object_id = OBJECT_ID(N'CLCOST'))
Begin
drop index CLCOST.I_CLCOST
end
go
IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_CLCOST_CNO' AND object_id = OBJECT_ID(N'CLCOST'))
Begin
drop index CLCOST.I_CLCOST_CNO
end
go
IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_CLCOST_REFNO' AND object_id = OBJECT_ID(N'CLCOST'))
Begin
drop index CLCOST.I_CLCOST_REFNO
end
go
IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_CLCOST' AND object_id = OBJECT_ID(N'CLCOST'))
Begin
Create Unique Index I_CLCOST on CLCOST(CNO, ID, CURRENCY, REFNO, CCTYPE)
end
go
IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_CLDED_CNO' AND object_id = OBJECT_ID(N'CLDED'))
Begin
drop index CLDED.I_CLDED_CNO
end
go
IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_CLDED_CNO_ID_CURRENCY_REFNO' AND object_id = OBJECT_ID(N'CLDED'))
Begin
Create Index I_CLDED_CNO_ID_CURRENCY_REFNO on CLDED(CNO, ID, CURRENCY, REFNO)
end
go
IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_CLSUB_CNO' AND object_id = OBJECT_ID(N'CLSUB'))
Begin
drop index CLSUB.I_CLSUB_CNO
end
go



 insert into PatchVersioning
select '323 Update Script - Patch 2022 (49)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='323 Update Script - Patch 2022 (49)'


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


