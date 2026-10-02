
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='CTYPE' AND CONSTRAINT_NAME='I_CTYPE')
Begin
ALTER TABLE [dbo].[CTYPE] DROP CONSTRAINT [I_CTYPE] WITH ( ONLINE = OFF )
end
GO
alter table ctype alter column ctype varchar(255)  NOT NULL
go
alter table profile alter column ctype varchar(255)
go
IF not EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='CTYPE' AND CONSTRAINT_NAME='I_CTYPE')
Begin
ALTER TABLE [dbo].[CTYPE] ADD  CONSTRAINT [I_CTYPE] PRIMARY KEY CLUSTERED 
(
       [CTYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
end
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='EMPLOYMENT' AND CONSTRAINT_NAME='I_EMPLOYMENT')
Begin
ALTER TABLE [dbo].[EMPLOYMENT] DROP CONSTRAINT [I_EMPLOYMENT] WITH ( ONLINE = OFF )
end
GO

alter table employment alter column employment varchar(100) NOT NULL
go
alter table Profile_ext alter column employment varchar(100) 
go
IF not EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='EMPLOYMENT' AND CONSTRAINT_NAME='I_EMPLOYMENT')
Begin
ALTER TABLE [dbo].[EMPLOYMENT] ADD  CONSTRAINT [I_EMPLOYMENT] PRIMARY KEY CLUSTERED 
(
       [EMPLOYMENT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
end
GO


update ID_TYPE set FixedLength=16
go




 insert into PatchVersioning
select '298 Update Script - Table Data Profile',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='298 Update Script - Table Data Profile'


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


