IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PolicyYear' AND Object_ID = Object_ID(N'TOP_NOC'))
BEGIN
ALTER TABLE dbo.TOP_NOC ADD
	PolicyYear int NULL
DECLARE @v sql_variant 
SET @v = N'Deductible Applicable Policy Year (0 : Whole Policy Year, 1 : 1st Policy Year, ..)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_NOC', N'COLUMN', N'PolicyYear'
END
GO


IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_TOP_NOC' AND object_id = OBJECT_ID(N'TOP_NOC'))
Begin
drop index TOP_NOC.I_TOP_NOC
end
GO
Create Unique Index I_TOP_NOC On TOP_NOC(TOPRO, TOI, FIlterCode, NOC, PolicyYear)
GO


 insert into PatchVersioning
select '520 Update Script - 4 January 2023',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='520 Update Script - 4 January 2023'


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

