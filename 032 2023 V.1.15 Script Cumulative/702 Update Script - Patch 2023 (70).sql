IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_TOP_Interest_TOPRO_FilterCode' AND object_id = OBJECT_ID('TOP_Interest'))
BEGIN
Create Index I_TOP_Interest_TOPRO_FilterCode on TOP_Interest(TOPRO, FilterCode)
end
GO
IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_TOP_CLA_TOPRO_FilterCode' AND object_id = OBJECT_ID('TOP_CLA'))
BEGIN
Create Index I_TOP_CLA_TOPRO_FilterCode on TOP_CLA(TOPRO, FilterCode)
end
GO
IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_TOP_EX_TOPRO_FilterCode' AND object_id = OBJECT_ID('TOP_EX'))
BEGIN
Create Index I_TOP_EX_TOPRO_FilterCode on TOP_EX(TOPRO, FilterCode)
end
GO
IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_TOP_CON_TOPRO_FilterCode' AND object_id = OBJECT_ID('TOP_CON'))
BEGIN
Create Index I_TOP_CON_TOPRO_FilterCode on TOP_CON(TOPRO, FilterCode)
end
GO



 insert into PatchVersioning	
select '702 Update Script - Patch 2023 (70)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(1004)

Select @PrevScript=''
Select @CurrSCript='702 Update Script - Patch 2023 (70)'


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



