IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_Source_Date_Branch_RefNo_RefType_ProAcc_ComAcc_SL_Cat_SType' AND object_id = OBJECT_ID('Source'))
BEGIN
drop index Source.I_Source_Date_Branch_RefNo_RefType_ProAcc_ComAcc_SL_Cat_SType
END
GO
Create Index I_Source_Date_Branch_SL_Cat_SType on Source(Date, Branch, SL_Cat, SType)
GO



  insert into PatchVersioning
select '1118 Update Script - Patch 2024 (49)',GETDATE()
go
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1118 Update Script - Patch 2024 (49)'


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

