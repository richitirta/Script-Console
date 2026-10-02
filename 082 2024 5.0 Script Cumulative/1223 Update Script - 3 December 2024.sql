IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CCSPFee' AND Object_ID = Object_ID(N'SysTab'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


ALTER TABLE dbo.SysTab ADD
	CCSPFee float(53) NULL
DECLARE @v sql_variant 
SET @v = N'% Credit Card Straight Payment (Full Payment) Fee'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'CCSPFee'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CCIPFee' AND Object_ID = Object_ID(N'SysTab'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


ALTER TABLE dbo.SysTab ADD
	CCIPFee float(53) NULL
DECLARE @v sql_variant 
SET @v = N'% Credit Card Installment Payment Fee'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'CCIPFee'
end
go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CCTAX' AND Object_ID = Object_ID(N'SysTab'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


ALTER TABLE dbo.SysTab ADD
	CCTAX float(53) NULL
DECLARE @v sql_variant 
SET @v = N'% Credit Card Tax Charges (from Collection Fee)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'CCTAX'
end
go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CCCOLAccount' AND Object_ID = Object_ID(N'SysTab'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


ALTER TABLE dbo.SysTab ADD
	CCCOLAccount varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Credit Collection Fee Account'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'CCCOLAccount'
end
go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CCTAXAccount' AND Object_ID = Object_ID(N'SysTab'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


ALTER TABLE dbo.SysTab ADD
	CCTAXAccount varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Credit Card Tax Charges Account'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'CCTAXAccount'
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CCPayType' AND Object_ID = Object_ID(N'ARBucket'))
BEGIN
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.ARBucket ADD
	CCPayType varchar(10) Null

DECLARE @v sql_variant 
SET @v = N'CC Payment Type (SP : Straight Payment, IP : Installment Payment)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ARBucket', N'COLUMN', N'CCPayType'
END
GO


  insert into PatchVersioning
select '1223 Update Script - 3 December 2024',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1223 Update Script - 3 December 2024'


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