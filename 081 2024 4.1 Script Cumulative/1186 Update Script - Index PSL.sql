


IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_pSL_Voucher_Doc_No_SortNo' AND object_id = OBJECT_ID('pSL'))
BEGIN
  drop index pSL.I_pSL_Voucher_Doc_No_SortNo
  end
  GO
  Create index I_pSL_Voucher_Doc_No_SortNo on pSL(Voucher, Doc_No, SortNo)
GO



  insert into PatchVersioning
select '1186 Update Script - Index PSL',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1186 Update Script - Index PSL'


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

