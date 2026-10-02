IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_Admlink_Date_Subject_Type' AND object_id = OBJECT_ID(N'admlink'))
Begin
drop index admlink.I_Admlink_Date_Subject_Type
end
GO
IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_Admlink_Date_Subject_Type' AND object_id = OBJECT_ID(N'Admlink'))
Begin
create index I_Admlink_Date_Subject_Type on Admlink(DATE, Subject, TYPE) INCLUDE ([ID],[CURRENCY],[REFNO],[A_PolicyNo],[RefType],[VOUCHER])
end
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_Admlink_DocNo' AND object_id = OBJECT_ID(N'admlink'))
Begin
drop index admlink.I_Admlink_DocNo
end
go



 insert into PatchVersioning
select '324 Update Script - Patch 2022 (50)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='324 Update Script - Patch 2022 (50)'


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


