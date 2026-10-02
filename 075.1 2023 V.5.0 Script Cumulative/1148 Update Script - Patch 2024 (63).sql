IF  not EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_pSL_Currency') AND parent_object_id = OBJECT_ID(N'Doc_CCY'))
begin
ALTER TABLE [dbo].[pSL]  WITH NOCHECK ADD  CONSTRAINT [FK_pSL_Currency] FOREIGN KEY([Doc_CCY])
REFERENCES [dbo].[Currency] ([Currency])
end
GO

ALTER TABLE [dbo].[pSL] CHECK CONSTRAINT [FK_pSL_Currency]
GO



  insert into PatchVersioning
select '1148 Update Script - Patch 2024 (63)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1148 Update Script - Patch 2024 (63)'


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
