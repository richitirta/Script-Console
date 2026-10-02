IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_Admlink_Date_Subject_Type' AND object_id = OBJECT_ID(N'AdmLink'))
Begin
CREATE INDEX I_Admlink_Date_Subject_Type
ON [dbo].[AdmLink] (Date, Subject, Type)
INCLUDE ([ID],[VOUCHER],[SOURCE],[A_PolicyNo],[A_MO],[A_ID],[RefType])
end
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_Admlink_Date' AND object_id = OBJECT_ID(N'Admlink'))
Begin
drop index Admlink.I_Admlink_Date
end
go


insert into PatchVersioning
select '119 Update Script - Patch 2021 (72)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='119 Update Script - Patch 2021 (72)'


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
