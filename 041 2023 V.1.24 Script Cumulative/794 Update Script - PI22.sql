DROP PROCEDURE PI22
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


 insert into PatchVersioning
select '794 Update Script - PI22',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='794 Update Script - PI22'


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


