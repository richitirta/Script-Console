
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ID' AND Object_ID = Object_ID(N'ARBucket'))
BEGIN
ALTER TABLE dbo.ARBucket ADD
	ID varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Profile ID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ARBucket', N'COLUMN', N'ID'
end
go

IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_Admlink_ID' AND object_id = OBJECT_ID('Admlink'))
BEGIN
Create index I_Admlink_ID on Admlink(ID)
end
go


 insert into PatchVersioning
select '473 Update Script - 18 November 2022 (1)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='473 Update Script - 18 November 2022 (1)'


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








