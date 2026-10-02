
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Monetary_Flag' AND Object_ID = Object_ID(N'Type'))
BEGIN
ALTER TABLE DBO.Type ADD Monetary_Flag bit NULL
END
GO

 IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='Type' AND CONSTRAINT_NAME='DF_Type_Monetary_Flag')
 Begin
ALTER TABLE [dbo].[Type] DROP CONSTRAINT [DF_Type_Monetary_Flag]
END
GO

ALTER TABLE [dbo].[Type] ADD  CONSTRAINT [DF_Type_Monetary_Flag]  DEFAULT ((1)) FOR [Monetary_Flag]
GO


  insert into PatchVersioning
select '1257 Script Monetary_Flag',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1257 Script Monetary_Flag'


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
