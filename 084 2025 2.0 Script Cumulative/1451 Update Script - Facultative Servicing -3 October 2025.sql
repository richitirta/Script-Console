SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Memo' AND Object_ID = Object_ID(N'dbo.SRArrDet'))
BEGIN
ALTER TABLE dbo.SRArrDet ADD Memo varchar(255) NULL
DECLARE @v sql_variant 
SET @v = N'Facultative Memo'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SRArrDet', N'COLUMN', N'Memo'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FullCoverF' AND Object_ID = Object_ID(N'dbo.SRArrDet'))
BEGIN
ALTER TABLE dbo.SRArrDet ADD FullCoverF bit NULL
DECLARE @v sql_variant 
SET @v = N'Full Cover (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SRArrDet', N'COLUMN', N'FullCoverF'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Remarks' AND Object_ID = Object_ID(N'dbo.SFPART'))
BEGIN
ALTER TABLE dbo.SFPART ADD Remarks varchar(255) NULL
DECLARE @v sql_variant 
SET @v = N'Facultative Remarks'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SFPART', N'COLUMN', N'Remarks'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Comm' AND Object_ID = Object_ID(N'dbo.SFPART'))
BEGIN
ALTER TABLE dbo.SFPART ADD Comm float NULL
DECLARE @v sql_variant 
SET @v = N'% Facultative Commission'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SFPART', N'COLUMN', N'Comm'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NetRate' AND Object_ID = Object_ID(N'dbo.SFPART'))
BEGIN
ALTER TABLE dbo.SFPART ADD NetRate float NULL
DECLARE @v sql_variant 
SET @v = N'Net Rate (0 : Original Rate)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SFPART', N'COLUMN', N'NetRate'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Currency' AND Object_ID = Object_ID(N'dbo.SFPART'))
BEGIN
ALTER TABLE dbo.SFPART ADD Currency varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Currency Code (see Currency)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SFPART', N'COLUMN', N'Currency'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CommAmount' AND Object_ID = Object_ID(N'dbo.SFPART'))
BEGIN
ALTER TABLE dbo.SFPART ADD CommAmount float NULL
DECLARE @v sql_variant 
SET @v = N'Reinsurance Commission in Amount'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SFPART', N'COLUMN', N'CommAmount'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'UNIT' AND Object_ID = Object_ID(N'dbo.SFPART'))
BEGIN
ALTER TABLE dbo.SFPART ADD UNIT varchar(1) NULL
DECLARE @v sql_variant 
SET @v = N'Premium Rate Unit (''C'' : Percent, ''M'' : PerMile, ''F'' : Flat)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SFPART', N'COLUMN', N'UNIT'
END
GO


--Update PROCEDURE QFacultative_DataServicing

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QFacultative_DataServicing') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QFacultative_DataServicing  END 
GO

CREATE Procedure QFacultative_DataServicing(@P_SNO integer, @P_FID varchar(20))                    
AS                                  
SELECT R.FID, R.AType, F.SLIPNO, R.SDATE, R.EDATE, R.RTYPE, F.ID, R.SHARE, F.Share as RShare, R.AMOUNT,                    
R.UserID, R.CDate,                  
R.LUserID, R.LDate,                  
R.AUserID, R.AUserDate,            
R.AcceptedBy, R.AcceptedDate,    
R.SysUserID,         
R.PCALC, F.WPC,       
F.GRACE, F.Remarks, F.Comm, F.Currency, F.NetRate, F.CommAmount, F.UNIT,
R.MEMO, R.FullCoverF
FROM SRARRDET R
INNER JOIN SFPART F on (F.SNO=R.SNO AND F.FID=R.FID)
WHERE R.SNO=@P_SNO AND R.FID=@P_FID

GO

insert into PatchVersioning
select '1451 Update Script - Facultative Servicing -3 October 2025',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrScript='1451 Update Script - Facultative Servicing -3 October 2025'


Declare @ExecScript varchar(100)
Declare @ExecScriptStatus varchar(100)
Declare @Error varchar(200)

Select @Error=''

Begin 
       Select @ExecScript=ExecScript,  @ExecScriptStatus=ExecScriptStatus from systab 
       if @PrevScript<>'' and @ExecScript<>@PrevScript
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

GO


