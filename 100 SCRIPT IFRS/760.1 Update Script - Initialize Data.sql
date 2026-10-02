
DROP function FN_CH_POLICY_ONRISK
GO
CREATE function FN_CH_POLICY_ONRISK(@P_AsAt as smalldatetime)          
RETURNS Table            
AS RETURN            
( 
Select Policy.PNO, Policy.OPNO
from Policy
Where Policy.CancelF=0 
and Policy.PStatus<>'O' and Policy.BookDate<=@P_AsAt and @P_AsAt between Policy.EffectiveDate and Policy.RenewalDate
and not exists (Select P.PPNO from Policy P Where P.PPNO=Policy.PNO and P.PStatus<>'O' and P.BookDate<=@P_AsAt and @P_AsAt between P.EffectiveDate and P.RenewalDate)
and not exists (Select P.RenewalPPNO from Policy P Where P.RenewalPPNO=Policy.PNO and P.PStatus<>'O' and P.BookDate<=@P_AsAt and @P_AsAt between P.EffectiveDate and P.RenewalDate)
)              

GO

DROP function FN_POLICY_ONRISK
GO
CREATE function FN_POLICY_ONRISK(@P_AsAt as smalldatetime)          
RETURNS Table            
AS RETURN            
(          
Select Acceptance.ANO, Acceptance.OANO, Acceptance.LANO
from Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Left Join Acceptance nA on (nA.pANO=Acceptance.ANO and nA.AType not in ('A') and nA.AStatus not in ('W','T') and nA.ADate<=@P_AsAt and nA.PDate<=@P_AsAt)
Where Acceptance.PolicyNo<>'' and Acceptance.AType not in ('C','A') and Acceptance.AStatus not in ('W','T') and Cover.CStatus<>'C' and Acceptance.pAStatus<>'W'
and Acceptance.ADate<=@P_AsAt and coalesce(nA.PDate, Acceptance.PDate)<=@P_AsAt
and @P_AsAt between Acceptance.PDate and Acceptance.EDate
and not exists (
       Select A.PANO
       from Acceptance A
       Inner Join Cover C on (C.CNO=A.CNO)
       Left Join Acceptance nA on (nA.pANO=A.ANO and nA.AType not in ('A') and nA.AStatus not in ('W','T') and nA.ADate<=@P_AsAt and nA.PDate<=@P_AsAt)
       Where A.PANO=Acceptance.ANO 
       and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
       and A.ADate<=@P_AsAt and coalesce(nA.PDate, A.PDate)<=@P_AsAt
)
and not exists (
       Select A.RANO
       from Acceptance A
       Inner Join Cover C on (C.CNO=A.CNO)
       Left Join Acceptance nA on (nA.pANO=A.ANO and nA.AType not in ('A') and nA.AStatus not in ('W','T') and nA.ADate<=@P_AsAt and nA.PDate<=@P_AsAt)
       Where A.RANO=Acceptance.ANO 
       and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
       and A.ADate<=@P_AsAt and coalesce(nA.PDate, A.PDate)<=@P_AsAt
)
) 

go

--Create Temporary Table for Policy OnRisk


drop table TEMP_POLICY_ONRISK 
go
drop table TEMP_CH_POLICY_ONRISK 
go
Select Distinct OANO into TEMP_POLICY_ONRISK 
from FN_POLICY_ONRISK('03/31/2023')
Create Index I_TEMP_POLICY_ONRISK on TEMP_POLICY_ONRISK(OANO)
go

Select Distinct OPNO into TEMP_CH_POLICY_ONRISK 
from FN_CH_POLICY_ONRISK('03/31/2023')
Create Index I_TEMP_CH_POLICY_ONRISK on TEMP_CH_POLICY_ONRISK(OPNO)
go

--Looking for the intial starting Date

--Select min(A.SDate)
--from TEMP_Policy_OnRisk T, Acceptance  A
--Where A.OANO=T.OANO

----Truncate

--Select distinct Source into #Source from mVoucher Where VType like 'IF%' and Date<='03/31/2023'

--Delete V from mVoucher V Where V.VType Like 'IF%' and V.Date<='03/31/2023'

--Delete Source from Source, #Source Where #Source.Source=Source.Source

--drop table #Source

--GO

--Delete from AccLog Where TYpe Like 'IF%' and Date<='03/31/2023'  
--Delete from Acclink Where Type Like 'IF%' and Date<='03/31/2023'  


--Delete from IFRS_Initial
--Delete from IFRS_Initial_Detail
--Delete from IFRS_Initial_Detail_BEL
--Delete from IFRS_Initial_Detail_RA
--Delete from IFRS_Initial_Detail_CSM
--Delete from IFRS_Initial_Detail_LOSS

--Delete from IFRS_CALCULATION
--Delete from IFRS_CALCULATION_Detail
--Delete from IFRS_CALCULATION_Detail_BEL
--Delete from IFRS_CALCULATION_Detail_RA
--Delete from IFRS_CALCULATION_Detail_CSM
--Delete from IFRS_CALCULATION_Detail_LOSS

--Delete from IFRS_Movement


-----CGroup & Segment N/A harus ada di semua asumsi

insert into CGroup(CGroup, Description)
Select 'N/A','NOT AVAILABLE'
go
insert into IFRS_assumption_CGroup(AssumptionID, CGroup)
Select AssumptionID, 'N/A' 
from IFRS_Assumption
go

insert into Segment(Segment, Description)
Select 'N/A','NOT AVAILABLE'
go
insert into IFRS_assumption_Segment(AssumptionID, Segment)
Select AssumptionID, 'N/A' 
from IFRS_Assumption
go

---- User BackdatedF=1
--Update SysUser Set backdatedF=1 where id='MR'

----Backdated Date
--Update Branch Set BackdatedDate='03/31/2023' from Branch Where ShariaF=0
--go


 insert into PatchVersioning	
select '760 Update Script - Initialize Data',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='760 Update Script - Initialize Data'


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



     



