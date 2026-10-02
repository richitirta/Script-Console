--Penambahan di Upload Scheme (Upload_SC) untuk Interest Detail (ICoverDet)
--12 jul 2017
IF Not EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Scheme_TransactionDet') AND type in (N'U'))
begin
CREATE TABLE Scheme_TransactionDet(
	TrNo int NOT NULL,
	TOI varchar(10) NULL,
	DESCRIPTION varchar(255) NOT NULL,
	QTY float NULL,
	UNIT varchar(10) NULL,
	UVALUE float NULL,
	AMOUNT float NULL,
 CONSTRAINT I_Scheme_TransactionDet PRIMARY KEY NONCLUSTERED 
(
	TrNo ASC,
	DESCRIPTION ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE Scheme_TransactionDet ADD  CONSTRAINT DF_Scheme_TransactionDet_QTY  DEFAULT ((0)) FOR QTY
ALTER TABLE Scheme_TransactionDet ADD  CONSTRAINT DF_Scheme_TransactionDet_UVALUE  DEFAULT ((0)) FOR UVALUE
ALTER TABLE Scheme_TransactionDet ADD  CONSTRAINT DF_Scheme_TransactionDet_AMOUNT  DEFAULT ((0)) FOR AMOUNT
ALTER TABLE Scheme_TransactionDet  WITH CHECK ADD  CONSTRAINT FK_Scheme_TransactionDet_Scheme_Transaction FOREIGN KEY(TrNo)
REFERENCES Scheme_Transaction (TrNo)
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE Scheme_TransactionDet CHECK CONSTRAINT FK_Scheme_TransactionDet_Scheme_Transaction
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Item Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Scheme_TransactionDet', @level2type=N'COLUMN',@level2name=N'DESCRIPTION'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Item Number Of Qty' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Scheme_TransactionDet', @level2type=N'COLUMN',@level2name=N'QTY'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unit of Measurement' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Scheme_TransactionDet', @level2type=N'COLUMN',@level2name=N'UNIT'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unit Value' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Scheme_TransactionDet', @level2type=N'COLUMN',@level2name=N'UVALUE'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Total Amount (Qty x unit)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Scheme_TransactionDet', @level2type=N'COLUMN',@level2name=N'AMOUNT'
end
go


--7 jul 2017 : pemerksaan total loss 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCLACC_6]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QCLACC_6
end
GO

CREATE PROCEDURE QCLACC_6 (@P_ANO as int, @P_CTLF as bit=1) 
AS 
SELECT C1.ClaimNo, C1.RegDate, C1.LossDate, cast(Max(cast(C2.CTLF as Integer)) as Bit) as CTLF
FROM Claim C1, ClLoss C2, Acceptance A1, Acceptance A2 
WHERE A2.ANO=@P_ANO and A1.OANO=A2.OANO and A1.ANO=C1.ANO and C2.CNO=C1.CNO and C1.CType<>'C' and (C1.CSTATUS IN ('P','T','A') OR C1.PCSTATUS IN ('A')) 
and (@P_CTLF=0 or C2.CTLF=@P_CTLF) and C1.TBAF_1=0 and C1.TBAF_2=0 
Group by C1.ClaimNo, C1.RegDate, C1.LossDate
Order by C1.LossDate 
go

--7 jul 2017 (1) :PENAMBAHAN REFERENCE CURRENCY DATE DAN DIALOG APPROVAL REQUEST
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RefCCYDate' AND Object_ID = Object_ID(N'Request'))
BEGIN
ALTER TABLE Request ADD	RefCCYDate smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Reference Currency Date (Use for Exchange Rate)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Request', N'COLUMN', N'RefCCYDate'
end
GO



--perbaikan terkait update inward bisnis
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QRiskAssLimit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QRiskAssLimit
end
GO

CREATE PROCEDURE QRiskAssLimit (@PANO as integer, @RType as varchar(10)='')                    
AS                    
SELECT top 1 RiskAss.RiskAss, Case When ReClass.AssessmentExInwardF=1 and Cover.ISType in ('R','T') Then 100 else RiskAss.PLimit end PLimit, Case When ReClass.AssessmentExInwardF=1 and Cover.ISType in ('R','T') Then 100 else RiskAss.Limit end Limit,
Cover.ISType, RiskAss.Code, RiskAss.HoldF, RiskAss.Share, RiskAss.Rate, RiskAss.Loading, RiskAss.RType                    
From Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join AInfo on (AInfo.ANO=Acceptance.ANO)
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Reinsurance on (Reinsurance.RType In ('D','Q','S1','S2','S3','A') and RArrHeader.RDate Between Reinsurance.SDate and Reinsurance.EDate)
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Acceptance.TOC and ReClass.AssessmentF=1)
Left Join RiskAss on (
	(RiskAss.RType='' or RiskAss.RType=@RType)
	And Riskass.RYear=Reinsurance.RYear And RiskAss.TOC=ReClass.TOC        
	and (RiskAss.TSILimit=0 or RArrHeader.TAmount-RArrHeader.MAmount<=RiskAss.TSILimit)                  
	And ((RiskAss.ValueID1='' and Ainfo.ValueDesc1 Like RiskAss.ValueDesc1+'%') or (RiskAss.ValueID1<>'' and AInfo.ValueID1 Like RiskAss.ValueID1+'%') or (RiskAss.ValueID1 is null))                    
	And ((RiskAss.ValueID2='' and Ainfo.ValueDesc2 Like RiskAss.ValueDesc2+'%') or (RiskAss.ValueID2<>'' and AInfo.ValueID2 Like RiskAss.ValueID2+'%') or (RiskAss.ValueID2 is null))                    
	And ((RiskAss.ValueID3='' and Ainfo.ValueDesc3 Like RiskAss.ValueDesc3+'%') or (RiskAss.ValueID3<>'' and AInfo.ValueID3 Like RiskAss.ValueID3+'%') or (RiskAss.ValueID3 is null))                    
	And ((RiskAss.ValueID4='' and Ainfo.ValueDesc4 Like RiskAss.ValueDesc4+'%') or (RiskAss.ValueID4<>'' and AInfo.ValueID4 Like RiskAss.ValueID4+'%') or (RiskAss.ValueID4 is null))                    
	And ((RiskAss.ValueID5='' and Ainfo.ValueDesc5 Like RiskAss.ValueDesc5+'%') or (RiskAss.ValueID5<>'' and AInfo.ValueID5 Like RiskAss.ValueID5+'%') or (RiskAss.ValueID5 is null))                    
	And ((RiskAss.ValueID6='' and Ainfo.ValueDesc6 Like RiskAss.ValueDesc6+'%') or (RiskAss.ValueID6<>'' and AInfo.ValueID6 Like RiskAss.ValueID6+'%') or (RiskAss.ValueID6 is null))                    
	And ((RiskAss.ValueID7='' and Ainfo.ValueDesc7 Like RiskAss.ValueDesc7+'%') or (RiskAss.ValueID7<>'' and AInfo.ValueID7 Like RiskAss.ValueID7+'%') or (RiskAss.ValueID7 is null))                    
	And ((RiskAss.ValueID8='' and Ainfo.ValueDesc8 Like RiskAss.ValueDesc8+'%') or (RiskAss.ValueID8<>'' and AInfo.ValueID8 Like RiskAss.ValueID8+'%') or (RiskAss.ValueID8 is null))                    
	And ((RiskAss.ValueID9='' and Ainfo.ValueDesc9 Like RiskAss.ValueDesc9+'%') or (RiskAss.ValueID9<>'' and AInfo.ValueID9 Like RiskAss.ValueID9+'%') or (RiskAss.ValueID9 is null))                    
	And ((RiskAss.ValueID10='' and Ainfo.ValueDesc10 Like RiskAss.ValueDesc10+'%') or (RiskAss.ValueID10<>'' and AInfo.ValueID10 Like RiskAss.ValueID10+'%') or (RiskAss.ValueID10 is null))                    
	And ((RiskAss.ValueID11='' and Ainfo.ValueDesc11 Like RiskAss.ValueDesc11+'%') or (RiskAss.ValueID11<>'' and AInfo.ValueID11 Like RiskAss.ValueID11+'%') or (RiskAss.ValueID11 is null))                    
	And ((RiskAss.ValueID12='' and Ainfo.ValueDesc12 Like RiskAss.ValueDesc12+'%') or (RiskAss.ValueID12<>'' and AInfo.ValueID12 Like RiskAss.ValueID12+'%') or (RiskAss.ValueID12 is null))                    
	And ((RiskAss.ValueID13='' and Ainfo.ValueDesc13 Like RiskAss.ValueDesc13+'%') or (RiskAss.ValueID13<>'' and AInfo.ValueID13 Like RiskAss.ValueID13+'%') or (RiskAss.ValueID13 is null))                    
	And ((RiskAss.ValueID14='' and Ainfo.ValueDesc14 Like RiskAss.ValueDesc14+'%') or (RiskAss.ValueID14<>'' and AInfo.ValueID14 Like RiskAss.ValueID14+'%') or (RiskAss.ValueID14 is null))                    
	And ((RiskAss.ValueID15='' and Ainfo.ValueDesc15 Like RiskAss.ValueDesc15+'%') or (RiskAss.ValueID15<>'' and AInfo.ValueID15 Like RiskAss.ValueID15+'%') or (RiskAss.ValueID15 is null))      
)
WHERE Acceptance.ANO=@PANO 
Order by                   
RiskAss.RYear Desc,        
RiskAss.RType Desc,            
RiskAss.PriorityF Desc,                  
len(coalesce(RiskAss.ValueID1,'')) Desc, len(coalesce(RiskAss.ValueID2,'')) Desc, len(coalesce(RiskAss.ValueID3,'')) Desc, len(coalesce(RiskAss.ValueID4,'')) Desc, len(coalesce(RiskAss.ValueID5,'')) Desc,                   
len(coalesce(RiskAss.ValueID6,'')) Desc, len(coalesce(RiskAss.ValueID7,'')) Desc, len(coalesce(RiskAss.ValueID8,'')) Desc, len(coalesce(RiskAss.ValueID9,'')) Desc, len(coalesce(RiskAss.ValueID10,'')) Desc,                   
len(coalesce(RiskAss.ValueID11,'')) Desc, len(coalesce(RiskAss.ValueID12,'')) Desc, len(coalesce(RiskAss.ValueID13,'')) Desc, len(coalesce(RiskAss.ValueID14,'')) Desc, len(coalesce(RiskAss.ValueID15,'')) Desc,                   
RiskAss.Limit Desc, RiskAss.Loading, RiskAss.HoldF        
go
--VERSIONING
insert into versioning
select '2017 V.2.1.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='09 Script Komulatif Konsol 2.0'
Select @CurrSCript='10 Script Komulatif Konsol 2.1'


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

