BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT

/****** Object:  Table [dbo].[CRArrDet]    Script Date: 7/5/2025 4:34:44 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CRArrDet') AND type in (N'U'))
begin
CREATE TABLE [dbo].[CRArrDet](
	[CNO] [int] NOT NULL,
	[FID] [varchar](20) NOT NULL,
	[LIMIT] [float] NULL,
	[Excess] [float] NULL,
	[ELIMIT] [float] NULL,
	[EExcess] [float] NULL
) ON [PRIMARY]
END
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Acceptance No. (see Acceptance)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRArrDet', @level2type=N'COLUMN',@level2name=N'CNO'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Facultative ID (Auto Generate)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRArrDet', @level2type=N'COLUMN',@level2name=N'FID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Facultative Limit Usage' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRArrDet', @level2type=N'COLUMN',@level2name=N'LIMIT'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Facultative Excess Usage' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRArrDet', @level2type=N'COLUMN',@level2name=N'Excess'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Facultative Estimate Limit Usage' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRArrDet', @level2type=N'COLUMN',@level2name=N'ELIMIT'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Facultative Estimate Excess Usage' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRArrDet', @level2type=N'COLUMN',@level2name=N'EExcess'
GO

Create Unique Index I_CRArrDet on CRArrDet(CNO, FID)
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Drop_Claim_Link') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE Drop_Claim_Link END
GO
Create Procedure Drop_Claim_Link(@P_CNO as Int)      
AS       
      
Delete From CLAASS Where CNO=@P_CNO      
Delete From CLFD Where CNO=@P_CNO      
Delete From CLINFO Where CNO=@P_CNO      
Delete From CLFACDED Where CNO=@P_CNO      
Delete From CINFO Where CNO=@P_CNO      
Delete From CLSALITEM Where CNO=@P_CNO      
Delete From CLDED Where CNO=@P_CNO      
Delete From LCALC Where CNO=@P_CNO      
Delete From CLLOSS Where CNO=@P_CNO      
Delete From CLSAL Where CNO=@P_CNO      
Delete From CLNotify Where CNO=@P_CNO      
Delete From CLPIC Where CNO=@P_CNO      
Delete From CLCOST Where CNO=@P_CNO      
Delete From CLPrintLog Where CNO=@P_CNO      
Delete From CDOCSTAT Where CNO=@P_CNO      
Delete From CARRHEADER Where CNO=@P_CNO      
Delete From CLSub Where CNO=@P_CNO      
Delete From CCALC Where CNO=@P_CNO      
Delete From CLSurvey Where CNO=@P_CNO      
Delete From CDOCLIST Where CNO=@P_CNO      
Delete From CDOCLISTPIC Where CNO=@P_CNO      
Delete From CArrDetail Where CNO=@P_CNO      
Delete From CLNotes Where CNO=@P_CNO    
Delete From CLINFOSUPL Where CNO=@P_CNO    
Delete From CLSUBPIC Where CNO=@P_CNO    
Delete From CLCOSTPIC Where CNO=@P_CNO    
Delete From CFINDICATORH Where CNO=@P_CNO    
Delete From CRArrDet Where CNO=@P_CNO    
        
GO    
 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGetClaimFacultativeLimitAndExcessUsage') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QGetClaimFacultativeLimitAndExcessUsage END
GO 

Create Procedure QGetClaimFacultativeLimitAndExcessUsage(@P_CNO as integer, @P_FID as varchar(20))    
as         
Select C3.Limit, C3.Excess, C3.ELimit, C3.EExcess
from Claim C1    
Inner Join Acceptance A1 on (A1.ANO=C1.ANO)    
Inner Join Claim C2 on (C2.PolicyNo=A1.PolicyNo and C2.CERTIFICATENO=A1.CERTIFICATENO and C2.OCNO<>C1.OCNO)    
Inner Join CRArrDet C3 on (C3.CNO=C2.CNO and C3.FID=@P_FID)
Where C1.CNO=@P_CNO     
and C2.CType<>'C' and C2.CStatus<>'R' and (C2.CStatus<>'C' or C2.PCstatus='A')     
and not exists (Select pCNO from Claim Where Claim.pCNO=C2.CNO and Claim.CStatus<>'R')    

GO

--Initialize CArrDet

insert into CRArrDet(CNO, FID, ELimit, EExcess,Limit, Excess)             
SELECT Distinct Claim.CNO, RArrDet.FID,
Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.ETAmount>RArrDet.Excess*RArrDet.RateL Then 
	Case When CArrHeader.ETAmount>(RArrDet.Excess+RArrDet.Limit)*RArrDet.RateL Then
		(RArrDet.Limit*RArrDet.RateL)
	Else	
		(CArrHeader.ETAmount-RArrDet.Excess*RArrDet.RateL)
	End
 Else	
	0
 End
Else
	0
End
as ELimitUsage,

Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.ETAmount>RArrDet.Excess*RArrDet.RateL Then 
	RArrDet.Excess*RArrDet.RateL
 Else	
	CArrHeader.ETAmount
 End
Else
	0
End
as EExcessUsage,

Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.TAmount>RArrDet.Excess*RArrDet.RateL Then 
	Case When CArrHeader.TAmount>(RArrDet.Excess+RArrDet.Limit)*RArrDet.RateL Then
		(RArrDet.Limit*RArrDet.RateL)
	Else	
		(CArrHeader.TAmount-RArrDet.Excess*RArrDet.RateL)
	End
 Else	
	0
 End
Else
	0
End
as LimitUsage,

Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.TAmount>RArrDet.Excess*RArrDet.RateL Then 
	RArrDet.Excess*RArrDet.RateL
 Else	
	CArrHeader.TAmount
 End
Else
	0
End
as ExcessUsage
From Claim
Inner Join CArrHeader on (CArrHeader.CNO=Claim.CNO)
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)
Inner Join RArrHeader on (RArrHeader.ANO=Claim.ANO)
Inner Join RArrDet on (RArrDet.ANO=Claim.ANO)
Left Join CRArrDet on (CRArrDet.CNO=Claim.CNO and CRArrDet.FID=RArrDet.FID)
INner Join FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID)
Inner Join Profile on (Profile.ID=FPart.ID)
WHERE ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                  
AND RArrDet.FullCoverF=1               
AND (FPart.Code='' or EXISTS (Select Top 1 RateCov.Code from COL Inner Join RateCov on (RateCov.Code=FPart.Code AND RateCov.TOR=COL.TOR) Where COL.COL=Claim.COL))  
AND RArrDet.Status='A'           
AND coalesce(CRArrDet.CNO,0)=0

Union All                    
                          
SELECT Claim.CNO, RArrDet.FID,
Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.ETAmount>RArrDet.Excess*RArrDet.RateL Then 
	Case When CArrHeader.ETAmount>(RArrDet.Excess+RArrDet.Limit)*RArrDet.RateL Then
		(RArrDet.Limit*RArrDet.RateL)
	Else	
		(CArrHeader.ETAmount-RArrDet.Excess*RArrDet.RateL)
	End
 Else	
	0
 End
Else
	0
End
as ELimitUsage,

Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.ETAmount>RArrDet.Excess*RArrDet.RateL Then 
	RArrDet.Excess*RArrDet.RateL
 Else	
	CArrHeader.ETAmount
 End
Else
	0
End
as EExcessUsage,

Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.TAmount>RArrDet.Excess*RArrDet.RateL Then 
	Case When CArrHeader.TAmount>(RArrDet.Excess+RArrDet.Limit)*RArrDet.RateL Then
		(RArrDet.Limit*RArrDet.RateL)
	Else	
		(CArrHeader.TAmount-RArrDet.Excess*RArrDet.RateL)
	End
 Else	
	0
 End
Else
	0
End
as LimitUsage,

Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.TAmount>RArrDet.Excess*RArrDet.RateL Then 
	RArrDet.Excess*RArrDet.RateL
 Else	
	CArrHeader.TAmount
 End
Else
	0
End
as ExcessUsage

From Claim
Inner Join COL on (COL.COL=Claim.COL)
Inner Join CArrHeader on (CarrHeader.CNO=Claim.CNO)
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)
Inner Join RArrHeader on (RArrHeader.ANO=Claim.ANO)
Inner Join RArrDet on (RArrDet.ANO=Claim.ANO)
Left Join CRArrDet on (CRArrDet.CNO=Claim.CNO and CRArrDet.FID=RArrDet.FID)
INner Join FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID)
Inner Join FPartDet on (FPartDet.ANO=RArrDet.ANO AND FPartDet.FID=RArrDet.FID AND FPartDet.ID=FPart.ID)
Inner Join RateCov on (RateCov.Code=FPartDet.Code AND RateCov.TOR=COL.TOR)
Inner Join Profile on (Profile.ID=FPart.ID)
Cross Apply
(
	SELECT L.CNO, L.TOR, SUM((L.LOSS-L.EDEDUCTIBLE-L.ESALVAGE)*C.RATE) AS LOSS, SUM((L.INDEMNITY-L.DEDUCTIBLE-L.SALVAGE)*C.RATE) AS INDEMNITY
	FROM CCALC C 
	Inner Join LCALC L on (L.CNO=C.CNO and L.Currency=C.Currency)
	WHERE L.CNO=Claim.CNO AND L.TOR=COL.TOR
	GROUP BY L.CNO, L.TOR
) LCALC 
Cross Apply
(
	SELECT C.CNO, SUM((C.LOSS-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS LOSS, SUM((C.CLAIM-C.DEDUCTIBLE-C.SALVAGE)*C.RATE) AS INDEMNITY
	FROM CCALC C
	WHERE C.CNO=Claim.CNO
	GROUP BY C.CNO
) CCALC 
WHERE ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                  
AND RArrDet.FullCoverF=0                    
AND RArrDet.Status='A'     
AND coalesce(CRArrDet.CNO,0)=0

GO

insert into PatchVersioning
select '1376 Update Script - 5 July 2025',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1376 Update Script - 5 July 2025'


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
