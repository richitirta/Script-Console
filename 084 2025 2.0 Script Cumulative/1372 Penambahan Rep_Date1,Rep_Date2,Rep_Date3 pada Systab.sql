SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'rep_date1' AND Object_ID = Object_ID(N'systab'))
begin
alter table systab
add rep_date1 smalldatetime
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'rep_date2' AND Object_ID = Object_ID(N'systab'))
begin
alter table systab
add rep_date2 smalldatetime
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'rep_date3' AND Object_ID = Object_ID(N'systab'))
begin
alter table systab
add rep_date3 smalldatetime
end
go

insert into PatchVersioning
select '1372 Penambahan Rep_Date1,Rep_Date2,Rep_Date3 pada Systab',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1372 Penambahan Rep_Date1,Rep_Date2,Rep_Date3 pada Systab'


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