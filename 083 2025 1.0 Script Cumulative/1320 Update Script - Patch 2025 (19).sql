
IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_nVoucher_Date' AND object_id = OBJECT_ID('nVoucher'))
BEGIN
Create index I_nVoucher_Date on nVoucher(Date)
end
GO
IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_mVoucher_Date' AND object_id = OBJECT_ID('nVoucher'))
BEGIN
Create index I_mVoucher_Date on mVoucher(Date)
end
GO
IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_Source_Date' AND object_id = OBJECT_ID('nVoucher'))
BEGIN
Create index I_Source_Date on Source(Date)
end
go


  insert into PatchVersioning
select '1320 Update Script - Patch 2025 (19)',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1320 Update Script - Patch 2025 (19)'


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


