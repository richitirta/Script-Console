IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_Admlink_Bank_AccountNo' AND object_id = OBJECT_ID('AdmLink'))
BEGIN
DROP INDEX [I_Admlink_Bank_AccountNo] ON [dbo].[AdmLink]
end
GO

SET ANSI_PADDING ON
GO

CREATE NONCLUSTERED INDEX [I_Admlink_Bank_AccountNo_Bank_Ext_AccountNo_Ext] ON [dbo].[AdmLink]
(
	[Bank] ASC,
	[AccountNo] ASC,
	[Bank_Ext] ASC,
	[AccountNo_Ext] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO



 insert into PatchVersioning
select '1239 Script Index Admlink AccountNo_Ext',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1239 Script Index Admlink AccountNo_Ext'


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

