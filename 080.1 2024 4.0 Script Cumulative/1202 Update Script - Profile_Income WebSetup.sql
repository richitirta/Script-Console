 
DROP INDEX [I_Profile_Income_CorporateF] ON [dbo].[Profile_Income]
GO 
ALTER TABLE [dbo].[Profile_Income] DROP CONSTRAINT [I_Profile_Income_Income_CorporateF]
GO

ALTER TABLE Profile_Income ALTER COLUMN Description VARCHAR(20) NULL
GO
ALTER TABLE Profile_Income ALTER COLUMN CorporateF BIT  NOT NULL
GO




SET ANSI_PADDING ON
GO 
ALTER TABLE [dbo].[Profile_Income] ADD  CONSTRAINT [I_Profile_Income_Income_CorporateF] UNIQUE NONCLUSTERED 
(
	[Income] ASC,
	[CorporateF] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
 


  insert into PatchVersioning
select '1202 Update Script - Profile_Income WebSetup',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1202 Update Script - Profile_Income WebSetup'


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