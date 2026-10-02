--WebSetup IFRS Forms
INSERT INTO SysForm VALUES 
('IFRSDiscRateListFrm', 'IFRS Disc Rate Inquiry','SETUP',0),
('IFRSDiscRateFrm', 'IFRS Disc Rate Register','SETUP',0),
('IFRSDiscRateDlg', 'IFRS Disc Rate Detail','SETUP',0),
('IFRSInfRateListFrm', 'IFRS Inflation Rate Inquiry','SETUP',0),
('IFRSInfRateFrm', 'IFRS Inflation Rate Register','SETUP',0),
('IFRSInfRateDlg', 'IFRS Inflation Rate Detail','SETUP',0),
('IFRSERatioListFrm', 'IFRS Pattern Ratio Inquiry','SETUP',0),
('IFRSERatioFrm', 'IFRS Pattern Ratio Register','SETUP',0),
('IFRSERatioDlg', 'IFRS Pattern Ratio Detail','SETUP',0),
('IFRSCancelRateListFrm', 'IFRS Cancel Rate Inquiry','SETUP',0),
('IFRSCancelRateFrm', 'IFRS Cancel Rate Register','SETUP',0),
('IFRSCancelRateDlg', 'IFRS Cancel Rate Detail','SETUP',0),
('IFRSAssumptionListFrm', 'IFRS Assumption Inquiry','SETUP',0),
('IFRSAssumptionFrm', 'IFRS Assumption Register','SETUP',0),
('IFRSAssumptionDlg', 'IFRS Assumption Detail','SETUP',0),
('IFRSAssumptionSegmentDlg', 'IFRS Assumption Segment','SETUP',0),
('IFRSAssumptionTOCDlg', 'IFRS Assumption TOC','SETUP',0),
('IFRSAssumptionCGroupDlg', 'IFRS Assumption Company Group','SETUP',0),
('IFRSAssumptionCurrencyDlg', 'IFRS Assumption Currency','SETUP',0),
('IFRSAssumptionISTypeDlg', 'IFRS Assumption - Insurance Source','SETUP',0)

GO

--SysUserForm
----insert into SysUserForm
----select s.TYPE,f.fname,1,1,1,1,1,1
----from SysUserType s, SysForm f
----where f.FName in
----('IFRSDiscRateListFrm', 'IFRSDiscRateFrm', 'IFRSDiscRateDlg', 'IFRSInfRateListFrm', 'IFRSInfRateFrm', 'IFRSInfRateDlg', 
----'IFRSERatioListFrm', 'IFRSERatioFrm', 'IFRSERatioDlg', 'IFRSCancelRateListFrm', 'IFRSCancelRateFrm', 'IFRSCancelRateDlg', 
----'IFRSAssumptionListFrm', 'IFRSAssumptionFrm', 'IFRSAssumptionDlg', 'IFRSAssumptionSegmentDlg', 
----'IFRSAssumptionTOCDlg', 'IFRSAssumptionCGroupDlg', 'IFRSAssumptionCurrencyDlg', 'IFRSAssumptionISTypeDlg')
----and 1 not in (Select 1 from SysUserForm S1 Where S1.type=S.type and S1.fname=f.fname)

----GO




  insert into PatchVersioning
select '1331 CORE - Update Patch SysForm - WebSetup IFRS',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1331 CORE - Update Patch SysForm - WebSetup IFRS'


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

