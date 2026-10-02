
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='ACCEX' AND CONSTRAINT_NAME='I_ACCEX')
Begin
ALTER TABLE ACCEX DROP CONSTRAINT i_ACCEX
--DROP INDEX i_ACCEX ON ACCEX
end
GO


IF EXISTS (SELECT * FROM sys.indexes WHERE name='i_ACCEX' AND object_id = OBJECT_ID(N'ACCEX'))
Begin
DROP INDEX i_ACCEX ON ACCEX
end
GO
update accex set section='' where section is null
go
update accex set ORDERNO='' where ORDERNO is null
go

alter table accex alter column ORDERNO varchar(10) not null
go
alter table accex alter column SECTION varchar(10) not null
go

IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_ACCEX' AND object_id = OBJECT_ID(N'ACCEX'))
Begin
ALTER TABLE [dbo].[ACCEX] ADD  CONSTRAINT [I_ACCEX] PRIMARY KEY NONCLUSTERED
(
[ANO] ASC,
[SECTION] ASC,
[ORDERNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
end
GO



 insert into PatchVersioning
select '264 Update Script - Inisialisasi Section OrderNo ACCEX',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='264 Update Script - Inisialisasi Section OrderNo ACCEX'


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
