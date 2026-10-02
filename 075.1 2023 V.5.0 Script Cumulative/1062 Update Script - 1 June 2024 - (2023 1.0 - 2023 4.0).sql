--/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
--BEGIN TRANSACTION
--SET QUOTED_IDENTIFIER ON
--SET ARITHABORT ON
--SET NUMERIC_ROUNDABORT OFF
--SET CONCAT_NULL_YIELDS_NULL ON
--SET ANSI_NULLS ON
--SET ANSI_PADDING ON
--SET ANSI_WARNINGS ON
--COMMIT
--BEGIN TRANSACTION
--GO
--ALTER TABLE dbo.SysTab ADD
--	FacDueByEffectiveF bit NULL
--GO
--DECLARE @v sql_variant 
--SET @v = N'Facultative Due Date  (0 : Follow Policy Due Date, 1 : By Facultative Effective)'
--EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'FacDueByEffectiveF'
--GO
--Update SysTab Set FacDueByEffectiveF=0 Where FacDueByEffectiveF is null
--GO
--COMMIT
--GO


DROP Procedure QFacultative_List
GO
Create Procedure QFacultative_List(@P_ANO int)
AS
SELECT Cast(0 as bit) as ProcessFlag, RArrDet.FID, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, RArrDet.Share, RArrDet.Ujrohreins, RArrDet.UjrohCedant, RArrDet.Amount, RArrDet.Prorata, Profile.Name, FPart.SlipNo, FPart.ID, FPart.Share AS RShare, FPart.Comm, FPart.WPC, 
FPart.NetRate, RArrDet.PCALC, RArrDet.CPct, RArrDet.FullCoverF, RArrDet.OriginalF, FPart.Remarks, 
--RArrDet.CurrencyL, 
--RArrDet.RateL,
RArrDet.EXCESS, RArrDet.LIMIT, RArrDet.Retention,
FPart.Grace, FPart.Installment, RArrDet.AcceptedBy, RArrDet.AcceptedDate, 
dateadd(day,FPart.Grace,
--Case 
--When SysTab.FacDueByEffectiveF=1 Then
--	Case When RArrDet.SDate<Acceptance.PDate Then Acceptance.PDate Else RArrDet.SDate End
--Else
	Case When SysTab.DueByEffectiveF=1 then Acceptance.PDate Else Acceptance.ADate end
--End
) as DueDate
From RArrDet
Inner Join FPart on (FPart.ANO=RArrDet.ANO And FPart.FID=RArrDet.FID)
Inner Join Profile on (Profile.ID=FPart.ID)
Inner Join Acceptance on (Acceptance.ANO=RArrDet.ANO)
Inner Join SysTab on (1=1)
WHERE RArrDet.ANO=@P_ANO
Order By RArrDet.FID
GO


insert into PatchVersioning
select '1062 Update Script - 1 June 2024 - (2023 1.0 - 2023 4.0)',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1062 Update Script - 1 June 2024 - (2023 1.0 - 2023 4.0)'


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
