
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CASHLOSSE' AND Object_ID = Object_ID(N'dbo.REINSURANCE'))
BEGIN
ALTER TABLE dbo.REINSURANCE ADD CASHLOSSE float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Cash Loss Limit By Event (Default 0 : not applied)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'REINSURANCE', N'COLUMN', N'CASHLOSSE'
END
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGet_TotalOfEventClaimApproved') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QGet_TotalOfEventClaimApproved END
GO

Create Procedure QGet_TotalOfEventClaimApproved(@CNO as Int, @RType as varchar(10), @RID as varchar(20))  
AS  
Select sum(CArr.TAmount) as Amount
from Claim C1
Inner join Claim C2 on (C1.EventNo>0 and C2.EventNo=C1.EventNo and C2.OCNO<C1.OCNO)
Inner Join CArrHeader CArr on (CArr.CNO=C2.CNO and CArr.Status='A')
Inner Join RArrHeader RArr on (RArr.ANO=C2.ANO)
Where C1.CNO=@CNO and
(
	(@RType='Q' and RArr.QID=@RID)
	or
	(@RType='S1' and RArr.SP1ID=@RID)
	or
	(@RType='S2' and RArr.SP2ID=@RID)
	or
	(@RType='S3' and RArr.SP3ID=@RID)
)
GO

insert into PatchVersioning
select '1431 Update Script - 2 September 2025 (1)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrScript='1431 Update Script - 2 September 2025 (1)'


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

GO