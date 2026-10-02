IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='I_ARBucket_A_PolicyNo' AND object_id = OBJECT_ID(N'ARBucket'))
Begin
Create Index I_ARBucket_A_PolicyNo on ARBucket(A_PolicyNO)
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='I_ARBucket_Voucher' AND object_id = OBJECT_ID(N'ARBucket'))
Begin
Create Index I_ARBucket_Voucher on ARBucket(Voucher)
END
GO


insert into PatchVersioning
select '55.4 Update Script - Patch 2020 (3)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='55.3 Update Script - Patch 2020 (2)'
Select @CurrSCript='55.4 Update Script - Patch 2020 (3)'


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


