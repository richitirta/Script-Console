DROP procedure PI20 
GO
CREATE procedure PI20 (@P_ANO as integer)                
as                
Begin                
	Declare @P_AsAt as smalldatetime
	Declare @P_Currency as varchar(10)
	Declare @P_MOANO as int
	Declare @P_OANO as Int
	Declare @P_Limit as float
	Declare @P_TotalLiability as Float

	Declare @P_FLDID as varchar(255)
	Declare @P_VALUEID as varchar(255)
	Declare @P_VALUEDESC as varchar(255)


	Select Top 1 @P_AsAt=A.PDate, @P_OANO=A.OANO, @P_MOANO=A1.OANO, @P_Currency=A2.Currency, @P_Limit=A2.Limit, @P_FLDID=A.FLDID, @P_VALUEID=A.VALUEID, @P_VALUEDESC=A.VALUEDESC
	from Acceptance A
	Left Join Acceptance A1 on (A1.ANO=A.LANO)
	Left Join AInfoDet A2 on (A2.ANO=A1.ANO and A2.FLDID=A.FLDID and (A2.VALUEID='<All>' or A2.VALUEID=A.VALUEID) and A2.Limit<>0 and A2.Status='A')
	Where A.ANO=@P_ANO
	Order By Case When A2.VALUEID='<All>' Then 1 else 0 end

	Select @P_TotalLiability=coalesce(sum(TotalLiability),0)
	from
	(
	Select 
	I.Amount*coalesce(P.InstSIPCT,100)/100 as TotalLiability
	from Acceptance mA
	Inner Join Acceptance A on (A.LANO=mA.ANO and A.LANO<>A.ANO)
	Left Join Payor_Schedule P on (P.ANO=A.ANO and P.InstDate<=@P_AsAt and (P.InstLDate>@P_AsAt or (P.InstLDate=@P_AsAt and P.InstLDate=A.EDate)))
	Inner Join ICover I on (I.ANO=A.ANO and I.Currency=@P_Currency)
	Left Join AccInvoice Av on (Av.INO=I.INO and Av.InvoiceNominal>0)
	Where MA.OANO=@P_MOANO and A.OANO<>@P_OANO and A.FLDID=@P_FLDID and A.VALUEID=@P_VALUEID
	and A.ADate<=@P_AsAt and A.AType not in ('C','A') and A.AStatus not in ('W','T') 
	and @P_AsAt between A.PDate and Case When coalesce(Av.InvoiceDate,A.EDate)<= A.EDate Then coalesce(Av.InvoiceDate,A.EDate) else A.EDate end
	and not exists (
		  Select B.PANO
		  from Acceptance B
		  Where B.PANO = A.ANO
		  and B.ADate<=@P_AsAt and B.AType not in ('A') and B.AStatus not in ('W','T')
		  and @P_AsAt between B.PDate and Case When coalesce(Av.InvoiceDate,B.EDate)<= B.EDate Then coalesce(Av.InvoiceDate,B.EDate) else B.EDate end
	)

	Union All

	Select I.Amount*coalesce(P.InstSIPCT,100)/100 as TotalLiability
	from Acceptance A
	Left Join Payor_Schedule P on (P.ANO=A.ANO and P.InstDate<=@P_AsAt and (P.InstLDate>@P_AsAt or (P.InstLDate=@P_AsAt and P.InstLDate=A.EDate)))
	Inner Join ICover I on (I.ANO=A.ANO and I.Currency=@P_Currency)
	Where A.ANO=@P_ANO and A.AType not in ('C','A')
	) A


	Select @P_VALUEID as VALUEID, @P_VALUEDESC as Description, @P_Limit as Limit, @P_TotalLiability as TotalLiability, @P_Limit-@P_TotalLiability as Remaining
end   


GO

DROP procedure PI21 
GO
CREATE procedure PI21 (@P_ANO as integer)                
as                
Begin                
Select LANO, ANO, OANO, CertificateNo, ValueDesc, AName, SDate, EDate, TotalLimit, SUM (TotalLimit) OVER (PARTITION BY LANO ORDER BY LANO, ANO) AS Balance
	from
	(
	Select 
		la.LANO, lA.ANO, lA.OANO, lA.CertificateNo, 'BB' as ValueID, 'Beginning Balance' as ValueDesc,'' as AName, lA.SDate, lA.EDate, I1.SI as TotalLimit
		from Acceptance lA
		Inner Join Cover C on (C.CNO=lA.CNO and C.OpenFlag=1)
		Inner Join ICover I1 on (I1.ANO=lA.ANO and I1.Category='M' and I1.SI<>0)
		Where lA.ANO=@P_ANO and lA.ANO=lA.LANO 

	Union All 

	Select 
		la.LANO, A.ANO, A.OANO, A.CertificateNo, A.ValueID, A.ValueDesc, A.AName, A.SDate, A.EDate, -I2.SI as TotalLimit
		from Acceptance lA
		Inner Join Cover C on (C.CNO=lA.CNO and C.OpenFlag=1)
		Inner Join ICover I1 on (I1.ANO=lA.ANO and I1.Category='M' and I1.SI<>0)
		Inner Join Acceptance A on (A.LANO=lA.ANO and A.ANO<>A.LANO and A.AType in ('N','E')  and A.AStatus='I')
		Inner Join ICover I2 on (I2.ANO=A.ANO and I2.TOI=I1.TOI and I2.Currency=I1.Currency)
		Where lA.ANO=@P_ANO and lA.ANO=lA.LANO 
	) S

	Order by LANO, ANO
end   





GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'PI22') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP procedure PI22
END
GO
CREATE procedure PI22 (@P_ANO as integer)                
as                
Begin                

	Declare @P_AsAt as smalldatetime
	Declare @P_REGID as varchar(255)
	Declare @P_FLDID as varchar(255)
	Declare @P_VALUEID as varchar(255)

	Select Top 1 @P_AsAt=A.PDate, @P_REGID=A.REGID, @P_FLDID=A.FLDID, @P_VALUEID=A.VALUEID
	from Acceptance A
	Where A.ANO=@P_ANO


	Select A.PolicyNo, A.CertificateNo, A.ANO, A.AName, A.Astatus, A.ADate, (RArrHeader.TAmount-RArrHeader.MAmount) as OSI, (RArrHeader.TAmount-RArrHeader.MAmount)*coalesce(R.PCTLOSS,100)/100 as SI, SUM ((RArrHeader.TAmount-RArrHeader.MAmount)*coalesce(R.PCTLOSS,100)/100) OVER (ORDER BY R.ANO) AS TotalSI
	from
	(
			Select Acceptance.ANO, (Select Top 1 RCover.PCTLOSS from RCover Where RCover.ANO=Acceptance.ANO and RCover.Category='M' and RCover.SDate<=@P_AsAt and ((RCover.EDate=Acceptance.EDate and @P_AsAt<=RCover.EDate) or (@P_AsAt<RCover.EDate))) as PCTLOSS
			from Acceptance
			Inner Join Cover on (Cover.CNO=Acceptance.CNO)
			Where Acceptance.AType not in ('C','A') and Cover.CStatus<>'C' and Acceptance.pAStatus<>'W'
			and ((Acceptance.PolicyNo<>'' and Acceptance.AStatus not in ('W','T')) or (Acceptance.ANO=@P_ANO))
			and @P_AsAt between Acceptance.PDate and Acceptance.EDate
			and Acceptance.RegID=@P_RegID and Acceptance.FLDID=@P_FLDID and Acceptance.ValueID=@P_VALUEID 
			and not exists (
				Select A.PANO
				from Acceptance A
				Inner Join Cover C on (C.CNO=A.CNO)
				Where A.PANO=Acceptance.ANO 
				and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
				and @P_AsAt between A.PDate and A.EDate
			)
			and not exists (
				Select A.RANO
				from Acceptance A
				Inner Join Cover C on (C.CNO=A.CNO)
				Where A.RANO=Acceptance.ANO 
				and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
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




 insert into PatchVersioning
select '169 Update Script - 4 March 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='169 Update Script - 4 March 2022'


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
