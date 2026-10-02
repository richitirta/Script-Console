

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DDay' AND Object_ID = Object_ID(N'PAYOR'))
BEGIN
ALTER TABLE dbo.PAYOR ADD
	DDay int NULL
DECLARE @v sql_variant 
SET @v = N'Due Day (Execution Day)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PAYOR', N'COLUMN', N'DDay'
end
GO


DROP function FL_BillingGroup 
GO
Create function FL_BillingGroup (@Bank varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
Select P.BillingGroup, P.BankName, P.DDay from Payor P, Acceptance A Where A.AStatus='I' and (A.ANO=A.LANO) and P.ANO=A.ANO and P.Bank=@Bank and P.BillingGroup<>''
) 

GO

DROP Procedure AUTORENEWALANDCLOSESCHEME_PROCESS
GO
CREATE Procedure AUTORENEWALANDCLOSESCHEME_PROCESS(@P_PDate as smalldatetime, @P_TrNo as Int=0)                                                
as                                       

Select S1.TrNo, S2.NumLapseBeforeClose, S1.SDate, mA.STime, S1.EDate, mA.ETime, C.Segment, S2.TOC
from Scheme_Transaction S1
Inner Join Acceptance mA on (mA.ANO=S1.LANO)
Inner Join Payor on (Payor.ANO=mA.ANO)
Inner Join Cover C on (C.CNO=mA.CNO)
Inner Join Scheme_Master S2 on (S2.SchemeNo=S1.SchemeNo)
WHere S2.AutoRenewalF=1 and S1.Status<>'C'
and S1.SDate<=@P_PDate
and (@P_TrNo=0 or S1.TrNo=@P_TrNo)
--Not Yet Renewed
and Not Exists (Select Top 1 rTrNo from Scheme_transaction S Where S.rTrNo=S1.TrNo)
and Payor.DDay=day(@P_PDate)

--has no total loss
and Not Exists (
	Select Top 1 A.PolicyNo, A.RefNo
	from Acceptance A
	Inner Join Claim on (Claim.ANO=A.ANO)
	Inner Join CLLOSS on (CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1)
	Where ((Claim.CStatus='A' or Claim.pCStatus='A') and Claim.SettledF=1 and Claim.CType in ('N','E') and Claim.ADate<=@P_PDate) 
	and A.PolicyNo=S1.PolicyNo and A.RefNo=S1.ContractNo 
)

GO

DROP Function get_SchemePremiumSimulation
GO
CREATE Function get_SchemePremiumSimulation(@P_TrNo int)          
RETURNS Float as
  
BEGIN       
Declare @SDate as smalldatetime
Declare @Edate as smalldatetime
Declare @TSI as float
Declare @NOfYears_1 as Float
Declare @Coverage_1 as varchar(255)
Declare @ClassNo Int
Declare @Premium Float


Select @ClassNo=S1.ClassNo, @TSI=S.TSI, @SDate=S.SDate, @EDate=S.EDate, @Coverage_1=S.Coverage_1, @NOfYears_1=S.NOfYears_1
from Scheme_Transaction S
Cross Apply 
	(
		Select Top 1 ClassNo 
		from Scheme_Class S1 
		Where S1.SchemeNo=S.SchemeNo 
		and 
		(
			(case when S1.ValueID1='' Then S.ValueID1 else S1.ValueID1 end)=S.ValueID1 and
			(case when S1.ValueID2='' Then S.ValueID2 else S1.ValueID2 end)=S.ValueID2 and
			(case when S1.ValueID3='' Then S.ValueID3 else S1.ValueID3 end)=S.ValueID3 and
			(case when S1.ValueID4='' Then S.ValueID4 else S1.ValueID4 end)=S.ValueID4 and
			(case when S1.ValueID5='' Then S.ValueID5 else S1.ValueID5 end)=S.ValueID5 and
			(case when S1.ValueID6='' Then S.ValueID6 else S1.ValueID6 end)=S.ValueID6 and
			(case when S1.ValueID7='' Then S.ValueID7 else S1.ValueID7 end)=S.ValueID7 and
			(case when S1.ValueID8='' Then S.ValueID8 else S1.ValueID8 end)=S.ValueID8 and
			(case when S1.ValueID9='' Then S.ValueID9 else S1.ValueID9 end)=S.ValueID9 and
			(case when S1.ValueID10='' Then S.ValueID10 else S1.ValueID10 end)=S.ValueID10 and
			(case when S1.ValueID11='' Then S.ValueID11 else S1.ValueID11 end)=S.ValueID11 and
			(case when S1.ValueID12='' Then S.ValueID12 else S1.ValueID12 end)=S.ValueID12 and
			(case when S1.ValueID13='' Then S.ValueID13 else S1.ValueID13 end)=S.ValueID13 and
			(case when S1.ValueID14='' Then S.ValueID14 else S1.ValueID14 end)=S.ValueID14 and
			(case when S1.ValueID15='' Then S.ValueID15 else S1.ValueID15 end)=S.ValueID15 
		)	
		Order by S1.Priority Desc
	) S1
Where S.TrNo=@P_TrNo


Select 
@Premium=
sum
(
--Annualized Rate
Case 
When SM.SPeriod<>1 Then cast(12 as Float)/cast((S3.Upper-S3.Lower+1) as Float)*S3.Rate
Else
	Case 
	When SM.PCalc='N' then S3.Rate
	else
		Case 
		When SM.Prorata=0 Then
			datediff(day,@SDate, dateadd(month,12,@SDate))/cast((S3.Upper-S3.Lower+1) as Float)*S3.Rate
		else
			SM.Prorata/cast((S3.Upper-S3.Lower+1) as Float)*S3.Rate
		end			
	end           
End

*
--Prorate
Case When SM.PCalc='N' Then 1 else 
	case 
	when (Case When SM.SPeriod=0 Then round(@NOfYears_1*12,0) Else datediff(day,@SDate, @EDate) end) <=S3.Upper Then 
		Case 
		When SM.RoundUpF=1 Then
			Case 
			When SM.SPeriod=0 Then cast((S3.Upper-S3.Lower+1) as Float) / 12
			Else
				Case 
				When SM.Prorata=0 Then
					cast((S3.Upper-S3.Lower+1) as Float) / datediff(day,@SDate, dateadd(month,12,@SDate))
				else
					cast((S3.Upper-S3.Lower+1) as Float) / SM.Prorata
				end
			End
		else
			Case 
			When SM.SPeriod=0 Then cast((round(@NOfYears_1*12,0)-S3.Lower+1) as Float)/ 12
			Else
				Case 
				When SM.Prorata=0 Then
					DateDiff(Day, @SDate, @EDate) / datediff(day,@SDate, dateadd(month,12,@SDate))
				else
					DateDiff(Day, @SDate, @EDate) / SM.Prorata
				end
			End				
		End
	else 
		Case 
		When SM.RoundUpF=1 Then
			Case 
			When SM.SPeriod=0 Then cast((S3.Upper-S3.Lower+1) as Float) / 12
			Else
				Case 
				When SM.Prorata=0 Then
					cast((S3.Upper-S3.Lower+1) as Float) / datediff(day,@SDate, dateadd(month,12,@SDate))
				else
					cast((S3.Upper-S3.Lower+1) as Float) / SM.Prorata
				end
			End
		else
			Case 
			When SM.SPeriod=0 Then cast((S3.Upper-S3.Lower+1) as Float) / 12
			Else
				Case 
				When SM.Prorata=0 Then
					DateDiff(Day, @SDate, @EDate) / datediff(day,@SDate, dateadd(month,12,@SDate))
				else
					DateDiff(Day, @SDate, @EDate) / SM.Prorata
				end
			End				
		End		
	end
end
* 
Case When S2.Unit='F' Then 1 When S2.Unit='C' Then @TSI/100 *(S3.PCTLOSS+S3.PAddition)/100 Else @TSI/1000 *(S3.PCTLOSS+S3.PAddition)/100 end
)
from Scheme_Class S1
Inner join Scheme_Master SM on (SM.SchemeNo=S1.SchemeNo)
Inner Join Scheme_Coverage S2 on (S2.ClassNo=S1.ClassNo and S2.Coverage=@Coverage_1)
Inner join Scheme_Indemnity S3 on (
	S3.ClassNo=S2.ClassNo and S3.Coverage=S2.Coverage and S3.Code=S2.Code and (Case When SM.SPeriod=0 Then round(@NOfYears_1*12,0) Else datediff(day,@SDate, @EDate) end)<=S3.Upper
	)
Where S1.ClassNo=@ClassNo

return @Premium
End


GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'get_SchemeTSISimulation') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function get_SchemeTSISimulation
end
GO
CREATE Function get_SchemeTSISimulation(@P_TrNo int)          
RETURNS Float as
  
BEGIN       
Declare @TSI as float
Declare @ClassNo1 Int
Declare @ClassNo2 Int


Select @ClassNo1=S1.ClassNo, @ClassNo2=S2.ClassNo
from Scheme_Transaction S
Cross Apply 
	(
		Select Top 1 S1.ClassNo 
		from Scheme_Class S1 
		Inner Join Scheme_Interest S2 on (S2.ClassNo=S1.ClassNo)
		Where S1.SchemeNo=S.SchemeNo 
		and 
		(
			(case when S1.ValueID1='' Then S.ValueID1 else S1.ValueID1 end)=S.ValueID1 and
			(case when S1.ValueID2='' Then S.ValueID2 else S1.ValueID2 end)=S.ValueID2 and
			(case when S1.ValueID3='' Then S.ValueID3 else S1.ValueID3 end)=S.ValueID3 and
			(case when S1.ValueID4='' Then S.ValueID4 else S1.ValueID4 end)=S.ValueID4 and
			(case when S1.ValueID5='' Then S.ValueID5 else S1.ValueID5 end)=S.ValueID5 and
			(case when S1.ValueID6='' Then S.ValueID6 else S1.ValueID6 end)=S.ValueID6 and
			(case when S1.ValueID7='' Then S.ValueID7 else S1.ValueID7 end)=S.ValueID7 and
			(case when S1.ValueID8='' Then S.ValueID8 else S1.ValueID8 end)=S.ValueID8 and
			(case when S1.ValueID9='' Then S.ValueID9 else S1.ValueID9 end)=S.ValueID9 and
			(case when S1.ValueID10='' Then S.ValueID10 else S1.ValueID10 end)=S.ValueID10 and
			(case when S1.ValueID11='' Then S.ValueID11 else S1.ValueID11 end)=S.ValueID11 and
			(case when S1.ValueID12='' Then S.ValueID12 else S1.ValueID12 end)=S.ValueID12 and
			(case when S1.ValueID13='' Then S.ValueID13 else S1.ValueID13 end)=S.ValueID13 and
			(case when S1.ValueID14='' Then S.ValueID14 else S1.ValueID14 end)=S.ValueID14 and
			(case when S1.ValueID15='' Then S.ValueID15 else S1.ValueID15 end)=S.ValueID15 
		)	
		Order by S1.Priority Desc
	) S1
Cross Apply 
	(
		Select Top 1 S1.ClassNo 
		from Scheme_Class S1 
		Inner Join Scheme_Coverage S2 on (S2.ClassNo=S1.ClassNo)
		Where S1.SchemeNo=S.SchemeNo 
		and 
		(
			(case when S1.ValueID1='' Then S.ValueID1 else S1.ValueID1 end)=S.ValueID1 and
			(case when S1.ValueID2='' Then S.ValueID2 else S1.ValueID2 end)=S.ValueID2 and
			(case when S1.ValueID3='' Then S.ValueID3 else S1.ValueID3 end)=S.ValueID3 and
			(case when S1.ValueID4='' Then S.ValueID4 else S1.ValueID4 end)=S.ValueID4 and
			(case when S1.ValueID5='' Then S.ValueID5 else S1.ValueID5 end)=S.ValueID5 and
			(case when S1.ValueID6='' Then S.ValueID6 else S1.ValueID6 end)=S.ValueID6 and
			(case when S1.ValueID7='' Then S.ValueID7 else S1.ValueID7 end)=S.ValueID7 and
			(case when S1.ValueID8='' Then S.ValueID8 else S1.ValueID8 end)=S.ValueID8 and
			(case when S1.ValueID9='' Then S.ValueID9 else S1.ValueID9 end)=S.ValueID9 and
			(case when S1.ValueID10='' Then S.ValueID10 else S1.ValueID10 end)=S.ValueID10 and
			(case when S1.ValueID11='' Then S.ValueID11 else S1.ValueID11 end)=S.ValueID11 and
			(case when S1.ValueID12='' Then S.ValueID12 else S1.ValueID12 end)=S.ValueID12 and
			(case when S1.ValueID13='' Then S.ValueID13 else S1.ValueID13 end)=S.ValueID13 and
			(case when S1.ValueID14='' Then S.ValueID14 else S1.ValueID14 end)=S.ValueID14 and
			(case when S1.ValueID15='' Then S.ValueID15 else S1.ValueID15 end)=S.ValueID15 
		)	
		Order by S1.Priority Desc
	) S2
Where S.TrNo=@P_TrNo


select @TSI=sum(S1.SI)
From scheme_interest S1
Inner Join TOI on (TOI.TOI=S1.TOI)
Inner Join Scheme_Coverage S2 on (S2.ClassNo=@ClassNo2)
Inner Join RateCov on (RateCov.Code=S2.Code)
Inner Join PClass on (PClass.TOI=TOI.TOI and PClass.TOR=RateCov.TOR)
Where S1.ClassNo=@ClassNo1 and S1.Category='M'


return @TSI
End

go


 insert into PatchVersioning
select '409 Update Script - 13 September 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='409 Update Script - 13 September 2022'


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



