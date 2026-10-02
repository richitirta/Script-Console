--8 sept 2017 : Update Supaya bisa setting topro per COB

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QTOPRateCode') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN
DROP procedure QTOPRateCode
END
GO
CREATE procedure QTOPRateCode(@p_code varchar (10), @p_TOPRO varchar(10))  
as  
SELECT RateTab.Code, Max(RateTab.Description) as Description, 
Max(RateTab.Unit) as Unit, cast(Max(cast(RateTab.NoRefundF as Int)) as bit) as NoRefundF, max(RClass.Category) as Category, sum(RateTab.Rate*RateCov.Portion/100) AS Rate, sum(RateCov.Portion) AS Portion  
From RateTab, RateCov, Rclass, TOPRO  
Where RateTab.Code Like @P_Code and RateTab.Code=RateCov.Code and Rclass.TOR=RateCov.TOR 
and TOPRO.TOPRO=@P_TOPRO and TOPRO.TOC=Substring(RClass.TOC, 1, len(TOPRO.TOC))
Group By RateTab.Code, RClass.TOC
Having sum(RateCov.Portion)=100

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QTOPDedCode') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN
DROP procedure QTOPDedCode
END
GO
CREATE procedure QTOPDedCode(@p_TOPRO varchar(10), @p_DCode varchar(10))
as
Select Distinct Dedtab.*
From Rclass, DedTAB, TOPRO
Where TOPRO.TOPRO=@P_TOPRO and TOPRO.TOC=Substring(RClass.TOC, 1, len(TOPRO.TOC)) and Rclass.TOR=DedTAB.TOR and DedTAB.DCode Like @P_DCode
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QTOPTOICode') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN
DROP procedure QTOPTOICode
END
GO
CREATE procedure QTOPTOICode(@p_TOPRO varchar(10), @p_TOI varchar (10))
as
Select distinct TOI.TOI, TOI.Description, PClass.Category
From Rclass, Pclass, TOI, TOPRO
Where TOPRO.TOPRO=@P_TOPRO and TOPRO.TOC=Substring(RClass.TOC, 1, len(TOPRO.TOC)) and Pclass.TOR=Rclass.TOR and TOI.TOI=PCLASS.TOI and TOI.TOI like @p_TOI

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_UserTopro') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function FL_UserTopro
END
GO
CREATE function FL_UserTopro(@P_USERID varchar(50), @P_TOPRO varchar(10),@P_TOC varchar(10),@P_SEGMENT varchar(10))    
RETURNS Table      
AS RETURN      
(    
SELECT Distinct TOPRO.TOPRO, TOPRO.Description, TOPRO.TOC, TOPRO.Expiry, TOPRO.CustomizableF, TOPRO.IncludeExtCoverF        
from TOPRO Left Join TOP_Segment on (TOP_Segment.TOPRO=TOPRO.TOPRO)           
Where TOPRO.TOPRO Like @P_TOPRO+'%' and 
TOPRO.TOC=Substring(@P_TOC, 1, len(TOPRO.TOC))
and TOPRO.AllowedF=1           
and (TOPRO.SegmentF=0 or TOP_Segment.Segment like @P_SEGMENT)   
) 
go


--11 sept 2017 : PENAMBAHAN RATE SOURCE PADA TOP_RATE
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RATE_Source' AND Object_ID = Object_ID(N'TOP_Rate'))
BEGIN
ALTER TABLE TOP_Rate ADD RATE_Source varchar(10) NULL

DECLARE @v sql_variant 
SET @v = N'Rate Source '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Rate', N'COLUMN', N'RATE_Source'
END
GO


--12 sept 2017 : UPDATE MAP REFERENCE
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TOPRO' AND Object_ID = Object_ID(N'MAP_REFERENCE'))
BEGIN
ALTER TABLE MAP_REFERENCE ADD TOPRO varchar(10) NULL

DECLARE @v sql_variant 
SET @v = N'Using Type Of Product (see TOPRO)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'MAP_REFERENCE', N'COLUMN', N'TOPRO'
END
GO

--13 sept 2017 :  PENAMBAHAN PRIVILEGE ALLOWCHANGEWPC
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWCHANGEWPC')
BEGIN
insert into Sysform (FName, Description, FCode)
Select 'ALLOWCHANGEWPC','ALLOW CHANGE WPC','ACTIVITIES'
END
go

--13 sept 2017 (1) : PENAMBAHAN COMMISSION DEPOSIT

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QPOLICY_DEPOSIT') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QPOLICY_DEPOSIT
END
GO
CREATE Procedure QPOLICY_DEPOSIT(@P_LANO integer)                
as                
Select     
sum(AccAss.Amount) as Total_Deposit    
from Acceptance MA1     
Inner Join Acceptance MA2 on (MA2.OANO=MA1.OANO)    
Inner join AccAss on (AccAss.ANO=MA2.ANO)    
Where MA1.ANO=@P_LANO and MA2.ANO<=@P_LANO and AccAss.DepositF=1 and AccAss.Type in ('DI','IC')

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QPOLICY_DEPOSIT_USAGE') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QPOLICY_DEPOSIT_USAGE
END
GO
CREATE Procedure QPOLICY_DEPOSIT_USAGE(@P_ANO integer)                
as                
Select     
AccAss.Currency,     
sum(Case When AccAss.DepositF=0 Then AccAss.Amount else 0 end) as Total_Premium,    
sum(Case When AccAss.DepositF=1 Then -AccAss.Amount else 0 end) as Deposit_Usage    
from Acceptance A1    
Inner Join Acceptance MA1 on (MA1.ANO=A1.LANO)    
Inner Join Acceptance MA2 on (MA2.OANO=MA1.OANO AND MA2.ANO<=MA1.ANO)    
Inner Join Acceptance A2 on (A2.LANO=MA2.LANO and A2.ANO<>A2.LANO)    
Inner Join AccAss on (AccAss.ANO=A2.ANO)    
Where A1.ANO=@P_ANO and (A2.AStatus Not in ('W','T') or A2.ANO=@P_ANO)
and ((AccAss.Type in ('DI','IC') and AccAss.Code in ('P','U','O','J')) or (AccAss.Type in ('IR','IT','IX') and AccAss.Code in ('P','O','J')))     
Group by AccAss.Currency   

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QREINSURANCE_DEPOSIT') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QREINSURANCE_DEPOSIT
END
GO
CREATE Procedure QREINSURANCE_DEPOSIT(@P_LANO integer)                
as                
Select     
AccAss.ID, 
Max(AccAss.Type) as Type,
max(AccAss.RefNo) as RefNo, 
sum(-AccAss.Amount) as Total_Deposit, 
Max(RPart.Comm) as Comm 
from Acceptance MA1     
Inner Join Acceptance MA2 on (MA2.OANO=MA1.OANO)    
Inner join AccAss on (AccAss.ANO=MA2.ANO)    
Left Join RPart on (RPart.DocNo=AccAss.RefNo and RPart.ID=AccAss.ID)
Left Join Reinsurance on (Reinsurance.RNO=RPart.RNO)
Where MA1.ANO=@P_LANO and MA2.ANO<=@P_LANO and AccAss.DepositF=1 and AccAss.Type in ('QS','QP')
Group by AccAss.ID
GO



IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QREINSURANCE_DEPOSIT_USAGE') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QREINSURANCE_DEPOSIT_USAGE
END
GO
CREATE Procedure QREINSURANCE_DEPOSIT_USAGE(@P_ANO integer, @P_ID as varchar(10))                
as                
Select     
AccAss.Currency,     
sum(Case When AccAss.DepositF=0 Then -AccAss.Amount else 0 end) as Total_Premium,    
sum(Case When AccAss.DepositF=1 Then AccAss.Amount else 0 end) as Deposit_Usage   
from Acceptance A1    
Inner Join Acceptance MA1 on (MA1.ANO=A1.LANO)    
Inner Join Acceptance MA2 on (MA2.OANO=MA1.OANO AND MA2.ANO<=MA1.ANO)    
Inner Join Acceptance A2 on (A2.LANO=MA2.LANO and A2.ANO<>A2.LANO)    
Inner Join AccAss on (AccAss.ANO=A2.ANO)    
Where A1.ANO=@P_ANO and AccAss.ID=@P_ID and (A2.AStatus Not in ('W','T') or A2.ANO=@P_ANO)
and ((AccAss.Type in ('QS','QP') and AccAss.Code in ('P','C','O','J')))
Group by AccAss.Currency 
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCOMMISSION_DEPOSIT') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QCOMMISSION_DEPOSIT
END
GO
CREATE Procedure QCOMMISSION_DEPOSIT(@P_LANO integer)                
as                
Select     
AccAss.ID, 
AccAss.Type,
sum(-AccAss.Amount) as Total_Deposit
from Acceptance MA1     
Inner Join Acceptance MA2 on (MA2.OANO=MA1.OANO)    
Inner join AccAss on (AccAss.ANO=MA2.ANO)    
Where MA1.ANO=@P_LANO and MA2.ANO<=@P_LANO and AccAss.DepositF=1 and AccAss.Type in ('BB','BA','BO','BC')
Group by AccAss.ID, AccAss.Type
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCOMMISSION_DEPOSIT_USAGE') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QCOMMISSION_DEPOSIT_USAGE
END
GO
CREATE Procedure QCOMMISSION_DEPOSIT_USAGE(@P_ANO integer, @P_ID as varchar(10), @P_Type as varchar(10))                
as                
Select     
AccAss.Currency,     
sum(Case When AccAss.DepositF=0 Then -AccAss.Amount else 0 end) as Total_Commission,    
sum(Case When AccAss.DepositF=1 Then AccAss.Amount else 0 end) as Deposit_Usage   
from Acceptance A1    
Inner Join Acceptance MA1 on (MA1.ANO=A1.LANO)    
Inner Join Acceptance MA2 on (MA2.OANO=MA1.OANO AND MA2.ANO<=MA1.ANO)    
Inner Join Acceptance A2 on (A2.LANO=MA2.LANO and A2.ANO<>A2.LANO)    
Inner Join AccAss on (AccAss.ANO=A2.ANO)    
Where A1.ANO=@P_ANO and AccAss.Type=@P_Type and AccAss.ID=@P_ID and (A2.AStatus Not in ('W','T') or A2.ANO=@P_ANO)
and ((AccAss.Type in ('BB','BA','BO','BC') and AccAss.Code in ('C')))
Group by AccAss.Currency 

go

--14 sept 2017 : Penambahan Otorisasi ALLOWCHANGECT (termasuk perubahan ALLOWCHANGEBRANCH juga berlaku untuk Claim).

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWCHANGECT')
BEGIN
insert into SysForm(FName, Description, FCode)
Select 'ALLOWCHANGECT','Allow Change CT (UW/CL)','ACTIVITIES'
END
go


alter table profile
alter column 
SyncDate varchar(20)
go


--VERSIONING
insert into versioning
select '2017 V.2.13.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='22 Script Komulatif Konsol 2.12'
Select @CurrSCript='23 Script Komulatif Konsol 2.13'


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