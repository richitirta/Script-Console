--/****** Object:  Table [dbo].[ACGROUP]    Script Date: 5/20/2025 10:12:45 PM ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ACGROUP') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ACGROUP](
	[ACGROUP] [varchar](50) NULL, 
	[DESCRIPTION] [varchar](50) NULL
) ON [PRIMARY]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Account Classification Group' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ACGROUP', @level2type=N'COLUMN',@level2name=N'ACGROUP'
END
GO

IF NOT EXISTS(SELECT * FROM ACGROUP WHERE ACGROUP='CASHFLOW')
BEGIN
insert into ACGROUP(ACGROUP,DESCRIPTION)
Select 'CASHFLOW','CASHFLOW' 
end
go
IF NOT EXISTS(SELECT * FROM ACGROUP WHERE ACGROUP='OPERATING EXPENSES')
BEGIN
insert into ACGROUP(ACGROUP,DESCRIPTION)
Select 'OPERATING EXPENSES','OPERATING EXPENSES'
end
go
IF NOT EXISTS(SELECT * FROM ACGROUP WHERE ACGROUP='CAPITAL EXPENSES')
BEGIN
insert into ACGROUP(ACGROUP,DESCRIPTION)
Select 'CAPITAL EXPENSES', 'CAPITAL EXPENSES'
end
go
IF NOT EXISTS(SELECT * FROM ACGROUP WHERE ACGROUP='OTHER INCOME')
BEGIN
insert into ACGROUP(ACGROUP,DESCRIPTION)
Select 'OTHER INCOME',  'OTHER INCOME'
end
go
IF NOT EXISTS(SELECT * FROM ACGROUP WHERE ACGROUP='SURPLUS-SHARIA')
BEGIN
insert into ACGROUP(ACGROUP,DESCRIPTION)
Select 'SURPLUS-SHARIA','SURPLUS-SHARIA'
end
go
IF NOT EXISTS(SELECT * FROM ACGROUP WHERE ACGROUP='SURPLUS-1')
BEGIN
insert into ACGROUP(ACGROUP,DESCRIPTION)
Select 'SURPLUS-1', 'SURPLUS-1'
end
go
IF NOT EXISTS(SELECT * FROM ACGROUP WHERE ACGROUP='SURPLUS-2')
BEGIN
insert into ACGROUP(ACGROUP,DESCRIPTION)
Select 'SURPLUS-2',  'SURPLUS-2'
end
go
IF NOT EXISTS(SELECT * FROM ACGROUP WHERE ACGROUP='INVESTMENT-RESULT')
BEGIN
insert into ACGROUP(ACGROUP,DESCRIPTION)
Select 'INVESTMENT-RESULT', 'INVESTMENT-RESULT'
end
go
IF NOT EXISTS(SELECT * FROM ACGROUP WHERE ACGROUP='DIRECT EXPENSES')
BEGIN
insert into ACGROUP(ACGROUP,DESCRIPTION)
Select 'DIRECT EXPENSES', 'DIRECT EXPENSES'
end
go
IF NOT EXISTS(SELECT * FROM ACGROUP WHERE ACGROUP='IFRS17')
BEGIN
insert into ACGROUP(ACGROUP,DESCRIPTION)
Select 'IFRS17','IFRS17'
end
go
IF NOT EXISTS(SELECT * FROM ACGROUP WHERE ACGROUP='IFRS4')
BEGIN
insert into ACGROUP(ACGROUP,DESCRIPTION)
Select 'IFRS4','IFRS4'
end
go



  insert into PatchVersioning
select '1340 Update Script - Patch 2025 (24)',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1340 Update Script - Patch 2025 (24)'


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


