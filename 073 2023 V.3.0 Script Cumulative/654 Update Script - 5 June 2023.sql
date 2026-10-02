DROP procedure PI22 
GO
CREATE procedure PI22 (@P_ANO as integer)                
as                
Begin                

	Declare @P_AsAt as smalldatetime
	Declare @P_OANO as int
	Declare @P_REGID as varchar(255)
	Declare @P_FLDID as varchar(255)
	Declare @P_VALUEID as varchar(255)

	Select Top 1 @P_OANO=A.OANO, @P_AsAt=A.PDate, @P_REGID=A.REGID, @P_FLDID=A.FLDID, @P_VALUEID=A.VALUEID
	from Acceptance A
	Where A.ANO=@P_ANO


	Select A.PolicyNo, A.CertificateNo, A.ANO, A.AName, A.Astatus, A.ADate, 
	(RArrHeader.TAmount-RArrHeader.MAmount) as OSI, 
	(RArrHeader.TAmount-RArrHeader.MAmount)*coalesce(R.PCTLOSS,100)/100 as SI, 
	SUM ((RArrHeader.TAmount-RArrHeader.MAmount)*coalesce(R.PCTLOSS,100)/100) OVER (ORDER BY R.ANO) AS TotalSI,
	(Select AH.CID+' - '+C.Description+' ; ' from AccCompSheetH Ah, Compliance C Where C.CID=Ah.CID and Ah.ANO=A.OANO FOR XML PATH('')) as ComplianceInfo
	from
	(
			Select Acceptance.ANO, (Select Top 1 RCover.PCTLOSS from RCover Where RCover.ANO=Acceptance.ANO and RCover.Category='M' and RCover.SDate<=@P_AsAt and ((RCover.EDate=Acceptance.EDate and @P_AsAt<=RCover.EDate) or (@P_AsAt<RCover.EDate))) as PCTLOSS
			from Acceptance
			Inner Join Cover on (Cover.CNO=Acceptance.CNO)
			Where ((Acceptance.AType in ('E') and Acceptance.AStatus not in ('W','T')) or (Acceptance.AType in ('N') and Acceptance.pStatus='C' and Acceptance.pAStatus<>'W' and Cover.CStatus<>'C' and Cover.ASource='UW') or (Acceptance.ANO=@P_ANO)) 
			and @P_AsAt between Acceptance.PDate and Acceptance.EDate
			and Acceptance.RegID=@P_RegID and Acceptance.FLDID=@P_FLDID and Acceptance.ValueID=@P_VALUEID 
			and not exists (
				Select A.PANO
				from Acceptance A
				Inner Join Cover C on (C.CNO=A.CNO)
				Where A.PANO=Acceptance.ANO 
				and ((A.AType in ('E','C') and A.AStatus not in ('W','T')) or (A.AType in ('N') and A.pStatus='C' and A.pAStatus<>'W' and C.CStatus<>'C' and C.ASource='UW')) 
				and @P_AsAt between A.PDate and A.EDate
			)			
			and not exists (
				Select A.RANO
				from Acceptance A
				Inner Join Cover C on (C.CNO=A.CNO)
				Where A.RANO=Acceptance.ANO 
				and ((A.AType in ('E','C') and A.AStatus not in ('W','T')) or (A.AType in ('N') and A.pStatus='C' and A.pAStatus<>'W' and C.CStatus<>'C' and C.ASource='UW')) 
				and @P_AsAt between A.PDate and A.EDate
			) 
			and not exists (
				Select Claim.ANO
				from Claim
				Inner Join CLLOSS on (CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1)
				WHere Claim.ANO=Acceptance.ANO 
				and Claim.RegDate<=@P_AsAt
				and Claim.CStatus in ('P','T','A','C') and Claim.CType in ('N','E')
				and Not (Claim.CStatus in ('C') and Claim.pCStatus in ('P') and Claim.CSDate<=@P_AsAt)
				and Not Exists (Select pCNO from Claim C Where C.pCNO=Claim.CNO and C.CStatus in ('P','T','A','C') and Claim.RegDate<=@P_AsAt)
			)	
	) R
	Inner Join Acceptance A on (A.ANO=R.ANO)
	Inner Join RArrHeader on (RArrHeader.ANO=A.ANO)
	Order by R.ANO
end


GO

DROP Function fn_GetTotalSumInsured
GO
CREATE Function fn_GetTotalSumInsured(@P_AsAt as smalldatetime,@P_RegID as varchar(10),@P_FLDID as varchar(255),@P_ValueID as varchar(255),@P_OANO as Int)
RETURNS Float AS        
BEGIN      
	Declare @Total as Float
	if @P_FLDID<>'' and @P_ValueID<>''
	Begin
		Select @Total=sum((RArrHeader.TAmount-RArrHeader.MAmount)*Case When coalesce(A.PCTLOSS,100)<>0 Then coalesce(A.PCTLOSS,100) Else 100 End/100*coalesce(P.InstSIPCT,100)/100)
		from
		(
			Select Acceptance.ANO, (Select Top 1 RCover.PCTLOSS from RCover Where RCover.ANO=Acceptance.ANO and RCover.Category='M' and RCover.SDate<=@P_AsAt and ((RCover.EDate=Acceptance.EDate and @P_AsAt<=RCover.EDate) or (@P_AsAt<RCover.EDate))) as PCTLOSS
			from Acceptance
			Inner Join Cover on (Cover.CNO=Acceptance.CNO)
			Left Join Acceptance mA on (MA.ANO=Acceptance.LANO and MA.ANO=MA.LANO)
			Where ((Acceptance.AType in ('E') and Acceptance.AStatus not in ('W','T')) or (Acceptance.AType in ('N') and Acceptance.pStatus='C' and Acceptance.pAStatus<>'W' and Cover.CStatus<>'C' and Cover.ASource='UW')) 
			and @P_AsAt between Acceptance.PDate and Acceptance.EDate
			and Acceptance.OANO<>@P_OANO and coalesce(mA.OANO,0)<>@P_OANO and Acceptance.RegID=@P_RegID and Acceptance.FLDID=@P_FLDID and Acceptance.ValueID=@P_VALUEID 
			and not exists (
				Select A.PANO
				from Acceptance A
				Inner Join Cover C on (C.CNO=A.CNO)
				Where A.PANO=Acceptance.ANO 
				and ((A.AType in ('E','C') and A.AStatus not in ('W','T')) or (A.AType in ('N') and A.pStatus='C' and A.pAStatus<>'W' and C.CStatus<>'C' and C.ASource='UW')) 
				and @P_AsAt between A.PDate and A.EDate
			)
			and not exists (
				Select A.RANO
				from Acceptance A
				Inner Join Cover C on (C.CNO=A.CNO)
				Where A.RANO=Acceptance.ANO 
				and ((A.AType in ('E','C') and A.AStatus not in ('W','T')) or (A.AType in ('N') and A.pStatus='C' and A.pAStatus<>'W' and C.CStatus<>'C' and C.ASource='UW')) 
				and @P_AsAt between A.PDate and A.EDate
			) 
			and not exists (
				Select Claim.ANO
				from Claim
				Inner Join CLLOSS on (CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1)
				WHere Claim.ANO=Acceptance.ANO 
				and Claim.RegDate<=@P_AsAt
				and Claim.CStatus in ('P','T','A','C') and Claim.CType in ('N','E')
				and Not (Claim.CStatus in ('C') and Claim.pCStatus in ('P') and Claim.CSDate<=@P_AsAt)
				and Not Exists (Select pCNO from Claim C Where C.pCNO=Claim.CNO and C.CStatus in ('P','T','A','C') and Claim.RegDate<=@P_AsAt)
			)
		) A
		Inner Join Acceptance A1 on (A1.ANO=A.ANO)
		Left Join Payor_Schedule P on (P.ANO=A1.ANO and P.InstDate<=@P_AsAt and (P.InstLDate>@P_AsAt or (P.InstLDate=@P_AsAt and P.InstLDate=A1.EDate)))
		Inner Join RArrHeader on (RArrHeader.ANO=A1.ANO)
	End

	if @Total is null 
		Select @Total=0

	Return @Total
END     


GO

DROP Function fn_GetTotalSumInsuredByPHolder
GO
CREATE Function fn_GetTotalSumInsuredByPHolder(@P_AsAt as smalldatetime, @P_PHolder as varchar(10),@P_RegID as varchar(10),@P_FLDID as varchar(255),@P_ValueID as varchar(255),@P_OANO as Int)
RETURNS Float AS        
BEGIN      
	Declare @Total as Float
	if @P_FLDID<>'' and @P_ValueID<>''
	Begin
		Select @Total=sum((RArrHeader.TAmount-RArrHeader.MAmount)*Case When coalesce(A.PCTLOSS,100)<>0 Then coalesce(A.PCTLOSS,100) Else 100 End/100*coalesce(P.InstSIPCT,100)/100)
		from
		(
			Select Acceptance.ANO, (Select Top 1 RCover.PCTLOSS from RCover Where RCover.ANO=Acceptance.ANO and RCover.Category='M' and RCover.SDate<=@P_AsAt and ((RCover.EDate=Acceptance.EDate and @P_AsAt<=RCover.EDate) or (@P_AsAt<RCover.EDate))) as PCTLOSS
			from Acceptance
			Inner Join Cover on (Cover.CNO=Acceptance.CNO)
			Where ((Acceptance.AType in ('E') and Acceptance.AStatus not in ('W','T')) or (Acceptance.AType in ('N') and Acceptance.pStatus='C' and Acceptance.pAStatus<>'W' and Cover.CStatus<>'C' and Cover.ASource='UW')) 
			and @P_AsAt between Acceptance.PDate and Acceptance.EDate
			and Acceptance.OANO<>@P_OANO and Cover.PHolder=@P_PHolder and Acceptance.RegID=@P_RegID and Acceptance.FLDID=@P_FLDID and Acceptance.ValueID=@P_VALUEID 
			and not exists (
				Select A.PANO
				from Acceptance A, Cover C
				Where A.PANO=Acceptance.ANO and C.CNO=A.CNO 
				and ((A.AType in ('E','C') and A.AStatus not in ('W','T')) or (A.AType in ('N') and A.pStatus='C' and A.pAStatus<>'W' and C.CStatus<>'C' and C.ASource='UW')) 
				and @P_AsAt between A.PDate and A.EDate
			)
			and not exists (
				Select A.RANO
				from Acceptance A, Cover C
				Where A.RANO=Acceptance.ANO and C.CNO=A.CNO 
				and ((A.AType in ('E','C') and A.AStatus not in ('W','T')) or (A.AType in ('N') and A.pStatus='C' and A.pAStatus<>'W' and C.CStatus<>'C' and C.ASource='UW')) 
				and @P_AsAt between A.PDate and A.EDate
			) 
			and not exists (
				Select Claim.ANO
				from Claim, CLLOSS
				WHere Claim.ANO=Acceptance.ANO and CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 
				and Claim.RegDate<=@P_AsAt
				and Claim.CStatus in ('P','T','A','C') and Claim.CType in ('N','E')
				and Not (Claim.CStatus in ('C') and Claim.pCStatus in ('P') and Claim.CSDate<=@P_AsAt)
				and Not Exists (Select pCNO from Claim C Where C.pCNO=Claim.CNO and C.CStatus in ('P','T','A','C') and Claim.RegDate<=@P_AsAt)
			)
		) A
		Inner Join Acceptance A1 on (A1.ANO=A.ANO)
		Left Join Payor_Schedule P on (P.ANO=A1.ANO and P.InstDate<=@P_AsAt and (P.InstLDate>@P_AsAt or (P.InstLDate=@P_AsAt and P.InstLDate=A1.EDate)))
		Inner Join RArrHeader on (RArrHeader.ANO=A1.ANO)
	End

	if @Total is null 
		Select @Total=0

	Return @Total

END     

GO
DROP Function fn_GetTotalSumInsuredByProduct
GO
CREATE Function fn_GetTotalSumInsuredByProduct(@P_AsAt as smalldatetime,@P_TOPRO as varchar(10),@P_RegID as varchar(10),@P_FLDID as varchar(255),@P_ValueID as varchar(255),@P_OANO as Int)
RETURNS Float AS        
BEGIN      
	Declare @Total as Float
	if @P_FLDID<>'' and @P_ValueID<>''
	Begin
		Select @Total=sum((RArrHeader.TAmount-RArrHeader.MAmount)*Case When coalesce(A.PCTLOSS,100)<>0 Then coalesce(A.PCTLOSS,100) Else 100 End/100*coalesce(P.InstSIPCT,100)/100)
		from
		(
			Select Acceptance.ANO, (Select Top 1 RCover.PCTLOSS from RCover Where RCover.ANO=Acceptance.ANO and RCover.Category='M' and RCover.SDate<=@P_AsAt and ((RCover.EDate=Acceptance.EDate and @P_AsAt<=RCover.EDate) or (@P_AsAt<RCover.EDate))) as PCTLOSS
			from Acceptance
			Inner Join Cover on (Cover.CNO=Acceptance.CNO)
			Where ((Acceptance.AType in ('E') and Acceptance.AStatus not in ('W','T')) or (Acceptance.AType in ('N') and Acceptance.pStatus='C' and Acceptance.pAStatus<>'W' and Cover.CStatus<>'C' and Cover.ASource='UW')) 
			and @P_AsAt between Acceptance.PDate and Acceptance.EDate
			and Acceptance.OANO<>@P_OANO and Acceptance.TOPRO=@P_TOPRO and Acceptance.RegID=@P_RegID and Acceptance.FLDID=@P_FLDID and Acceptance.ValueID=@P_VALUEID 
			and not exists (
				Select A.PANO
				from Acceptance A, Cover C
				Where A.PANO=Acceptance.ANO and C.CNO=A.CNO 
				and ((A.AType in ('E','C') and A.AStatus not in ('W','T')) or (A.AType in ('N') and A.pStatus='C' and A.pAStatus<>'W' and C.CStatus<>'C' and C.ASource='UW')) 
				and @P_AsAt between A.PDate and A.EDate
			)
			and not exists (
				Select A.RANO
				from Acceptance A, Cover C
				Where A.RANO=Acceptance.ANO and C.CNO=A.CNO 
				and ((A.AType in ('E','C') and A.AStatus not in ('W','T')) or (A.AType in ('N') and A.pStatus='C' and A.pAStatus<>'W' and C.CStatus<>'C' and C.ASource='UW')) 
				and @P_AsAt between A.PDate and A.EDate
			) 
			and not exists (
				Select Claim.ANO
				from Claim, CLLOSS
				WHere Claim.ANO=Acceptance.ANO and CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 
				and Claim.RegDate<=@P_AsAt
				and Claim.CStatus in ('P','T','A','C') and Claim.CType in ('N','E')
				and Not (Claim.CStatus in ('C') and Claim.pCStatus in ('P') and Claim.CSDate<=@P_AsAt)
				and Not Exists (Select pCNO from Claim C Where C.pCNO=Claim.CNO and C.CStatus in ('P','T','A','C') and Claim.RegDate<=@P_AsAt)
			)
		) A
		Inner Join Acceptance A1 on (A1.ANO=A.ANO)
		Left Join Payor_Schedule P on (P.ANO=A1.ANO and P.InstDate<=@P_AsAt and (P.InstLDate>@P_AsAt or (P.InstLDate=@P_AsAt and P.InstLDate=A1.EDate)))
		Inner Join RArrHeader on (RArrHeader.ANO=A1.ANO)

	End

	if @Total is null 
		Select @Total=0

	Return @Total
END     

GO
DROP Function fn_GetTotalSumInsuredByProductAndPHolder
GO
CREATE Function fn_GetTotalSumInsuredByProductAndPHolder(@P_AsAt as smalldatetime,@P_TOPRO as varchar(10),@P_PHolder as varchar(10),@P_OANO as Int)
RETURNS Float AS        
BEGIN      
	Declare @Total as Float

	Select @Total=sum((RArrHeader.TAmount-RArrHeader.MAmount)*Case When coalesce(A.PCTLOSS,100)<>0 Then coalesce(A.PCTLOSS,100) Else 100 End/100*coalesce(P.InstSIPCT,100)/100)
	from
	(
		Select Acceptance.ANO, (Select Top 1 RCover.PCTLOSS from RCover Where RCover.ANO=Acceptance.ANO and RCover.Category='M' and RCover.SDate<=@P_AsAt and ((RCover.EDate=Acceptance.EDate and @P_AsAt<=RCover.EDate) or (@P_AsAt<RCover.EDate))) as PCTLOSS
		from Acceptance
		Inner Join Cover on (Cover.CNO=Acceptance.CNO)
		Where ((Acceptance.AType in ('E') and Acceptance.AStatus not in ('W','T')) or (Acceptance.AType in ('N') and Acceptance.pStatus='C' and Acceptance.pAStatus<>'W' and Cover.CStatus<>'C' and Cover.ASource='UW')) 
		and @P_AsAt between Acceptance.PDate and Acceptance.EDate
		and Acceptance.OANO<>@P_OANO and Acceptance.TOPRO=@P_TOPRO and Cover.PHolder=@P_PHolder 
		and not exists (
			Select A.PANO
			from Acceptance A, Cover C
			Where A.PANO=Acceptance.ANO and C.CNO=A.CNO 
			and ((A.AType in ('E','C') and A.AStatus not in ('W','T')) or (A.AType in ('N') and A.pStatus='C' and A.pAStatus<>'W' and C.CStatus<>'C' and C.ASource='UW')) 
			and @P_AsAt between A.PDate and A.EDate
		)
		and not exists (
			Select A.RANO
			from Acceptance A, Cover C
			Where A.RANO=Acceptance.ANO and C.CNO=A.CNO 
			and ((A.AType in ('E','C') and A.AStatus not in ('W','T')) or (A.AType in ('N') and A.pStatus='C' and A.pAStatus<>'W' and C.CStatus<>'C' and C.ASource='UW')) 
			and @P_AsAt between A.PDate and A.EDate
		) 
		and not exists (
			Select Claim.ANO
			from Claim, CLLOSS
			WHere Claim.ANO=Acceptance.ANO and CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 
			and Claim.RegDate<=@P_AsAt
			and Claim.CStatus in ('P','T','A','C') and Claim.CType in ('N','E')
			and Not (Claim.CStatus in ('C') and Claim.pCStatus in ('P') and Claim.CSDate<=@P_AsAt)
			and Not Exists (Select pCNO from Claim C Where C.pCNO=Claim.CNO and C.CStatus in ('P','T','A','C') and Claim.RegDate<=@P_AsAt)
		)
	) A
	Inner Join Acceptance A1 on (A1.ANO=A.ANO)
	Left Join Payor_Schedule P on (P.ANO=A1.ANO and P.InstDate<=@P_AsAt and (P.InstLDate>@P_AsAt or (P.InstLDate=@P_AsAt and P.InstLDate=A1.EDate)))
	Inner Join RArrHeader on (RArrHeader.ANO=A1.ANO)

	if @Total is null 
		Select @Total=0

	Return @Total
END     

GO
DROP Function fn_GetTotalSumInsuredByProductAndInsured
GO
CREATE Function fn_GetTotalSumInsuredByProductAndInsured(@P_AsAt as smalldatetime,@P_TOPRO as varchar(10),@P_AID as varchar(10),@P_OANO as Int)
RETURNS Float AS        
BEGIN      
	Declare @Total as Float

	Select @Total=sum((RArrHeader.TAmount-RArrHeader.MAmount)*Case When coalesce(A.PCTLOSS,100)<>0 Then coalesce(A.PCTLOSS,100) Else 100 End/100*coalesce(P.InstSIPCT,100)/100)
	from
	(
		Select Acceptance.ANO, (Select Top 1 RCover.PCTLOSS from RCover Where RCover.ANO=Acceptance.ANO and RCover.Category='M' and RCover.SDate<=@P_AsAt and ((RCover.EDate=Acceptance.EDate and @P_AsAt<=RCover.EDate) or (@P_AsAt<RCover.EDate))) as PCTLOSS
		from Acceptance
		Inner Join Cover on (Cover.CNO=Acceptance.CNO)
		Where ((Acceptance.AType in ('E') and Acceptance.AStatus not in ('W','T')) or (Acceptance.AType in ('N') and Acceptance.pStatus='C' and Acceptance.pAStatus<>'W' and Cover.CStatus<>'C' and Cover.ASource='UW')) 
		and @P_AsAt between Acceptance.PDate and Acceptance.EDate
		and Acceptance.OANO<>@P_OANO and Acceptance.TOPRO=@P_TOPRO and Acceptance.AID=@P_AID
		and not exists (
			Select A.PANO
			from Acceptance A, Cover C
			Where A.PANO=Acceptance.ANO and C.CNO=A.CNO 
			and ((A.AType in ('E','C') and A.AStatus not in ('W','T')) or (A.AType in ('N') and A.pStatus='C' and A.pAStatus<>'W' and C.CStatus<>'C' and C.ASource='UW')) 
			and @P_AsAt between A.PDate and A.EDate
		)
		and not exists (
			Select A.RANO
			from Acceptance A, Cover C
			Where A.RANO=Acceptance.ANO and C.CNO=A.CNO 
			and ((A.AType in ('E','C') and A.AStatus not in ('W','T')) or (A.AType in ('N') and A.pStatus='C' and A.pAStatus<>'W' and C.CStatus<>'C' and C.ASource='UW')) 
			and @P_AsAt between A.PDate and A.EDate
		) 
		and not exists (
			Select Claim.ANO
			from Claim, CLLOSS
			WHere Claim.ANO=Acceptance.ANO and CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 
			and Claim.RegDate<=@P_AsAt
			and Claim.CStatus in ('P','T','A','C') and Claim.CType in ('N','E')
			and Not (Claim.CStatus in ('C') and Claim.pCStatus in ('P') and Claim.CSDate<=@P_AsAt)
			and Not Exists (Select pCNO from Claim C Where C.pCNO=Claim.CNO and C.CStatus in ('P','T','A','C') and Claim.RegDate<=@P_AsAt)
		)
	) A
	Inner Join Acceptance A1 on (A1.ANO=A.ANO)
	Left Join Payor_Schedule P on (P.ANO=A1.ANO and P.InstDate<=@P_AsAt and (P.InstLDate>@P_AsAt or (P.InstLDate=@P_AsAt and P.InstLDate=A1.EDate)))
	Inner Join RArrHeader on (RArrHeader.ANO=A1.ANO)

	if @Total is null 
		Select @Total=0

	Return @Total
END     


GO

IF NOT EXISTS(SELECT * FROM sysprocess WHERE ProcName='AUTOCLAIMDECLINED_CANCELLATION')
BEGIN
insert into sysprocess(MainProcName, ProcName, ProcGroup,TimeOut, StartTime, EndTime, Schedule, StartDay, EndDay, FreqDay, ScheduleF,UserID, Last_Opr, Last_Update, Last_Error, ExecCheckF, RepetitiveF )
Select 'AUTOCLAIMDECLINED_CANCELLATION' as MainProcName, 'AUTOCLAIMDECLINED_CANCELLATION' as ProcName,'UW',0,'00:00','24:00',0,1,31,0,0,'CARE','CARE',cast(convert(varchar(10), getdate(),1) as smalldatetime),'',0,0
end
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'AutoClaimDeclined_Cancellation') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure AutoClaimDeclined_Cancellation
end
GO
CREATE Procedure AutoClaimDeclined_Cancellation(@P_PDate as smalldatetime)              
as              
Select Distinct NAcceptance.ANO, Claim.CSDate as CSDate, Cover.OpenFlag, NAcceptance.LANO, NAcceptance.RegNo, NAcceptance.RefNo, NAcceptance.RefDate, NAcceptance.Branch, NAcceptance.TOC, Claim.ClaimNo, NAcceptance.PolicyNo, NAcceptance.CertificateNo, 
NAcceptance.PolicyNo+Case When NAcceptance.CertificateNo='' then '' else '-'+NAcceptance.CertificateNo end as A_PolicyNo, 
cast(1 as Bit) as AutoInforceF, Reason.NOREFUNDF, Reason.RefundType 
from Claim  
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)
Inner Join Acceptance NAcceptance on (NAcceptance.OANO=Acceptance.OANO and NAcceptance.AType in ('N','E') and NAcceptance.AStatus='I')
Inner Join Cover on (Cover.CNO=NAcceptance.CNO)
Inner Join Reason on (Reason.Reason=Claim.Reason and Reason.AutoCancelF=1)
Where Claim.CStatus='C' and Claim.pCStatus='P' and Claim.CSDate<=@P_PDate 
--only for Open Cover Certificate or Individual Policy
and Acceptance.ANO<>Acceptance.LANO and (Cover.OpenFlag=1 or Acceptance.LANO=-1)

go


 insert into PatchVersioning	
select '654 Update Script - 5 June 2023',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='654 Update Script - 5 June 2023'


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



