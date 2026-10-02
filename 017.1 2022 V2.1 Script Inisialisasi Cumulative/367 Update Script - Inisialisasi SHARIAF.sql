


----SELECT SHARIAF,* FROM BRANCH
----GO

--UPDATE BRANCH SET ShariaF = 0 WHERE ShariaF IS NULL
--GO

----SELECT ShariaF,* FROM TOC
----GO

--UPDATE TOC SET ShariaF = 0 WHERE ShariaF IS NULL
--GO



-- insert into PatchVersioning
--select '367 Update Script - Inisialisasi SHARIAF',GETDATE()
--go


--Declare @PrevScript varchar(100)
--Declare @CurrScript varchar(100)

--Select @PrevScript=''
--Select @CurrSCript='367 Update Script - Inisialisasi SHARIAF'


--Declare @ExecScript varchar(100)
--Declare @ExecScriptStatus varchar(100)
--Declare @Error varchar(200)

--Select @Error=''

--Begin 
--       Select @ExecScript=Execscript,  @ExecScriptStatus=ExecScriptStatus from systab 
--       if @PrevScript<>'' and @ExecSCript<>@PrevScript
--              THROW 51000, 'Not the Next Sequence Script', 1;
--       else 
--              if @ExecScriptStatus<>'' and @ExecScriptStatus<>'DONE'
--              THROW 51000, 'Pending Script Execution', 1;

--       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='PENDING'             
       
--       BEGIN TRY            
--			PRINT '--EXECUTE DONE--'
--       END TRY  
--       BEGIN CATCH  
--       END CATCH;


--       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
--End




--go