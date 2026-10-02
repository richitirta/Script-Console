IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='SysLogDownload' AND CONSTRAINT_NAME='I_SysLogDownload')
Begin
ALTER TABLE [dbo].[SysLogDownload] DROP CONSTRAINT [I_SysLogDownload]
end
GO

--IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_SysLogDownload' AND object_id = OBJECT_ID(N'SysLogDownload'))
--Begin
--ALTER TABLE [dbo].[SysLogDownload] DROP CONSTRAINT [I_SysLogDownload]
--end
--GO


CREATE UNIQUE NONCLUSTERED INDEX [I_SysLogDownload] ON [dbo].[SysLogDownload]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


 insert into PatchVersioning	
select '729 Query Fixing Index WebDextData',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(1004)

Select @PrevScript=''
Select @CurrSCript='729 Query Fixing Index WebDextData'


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



