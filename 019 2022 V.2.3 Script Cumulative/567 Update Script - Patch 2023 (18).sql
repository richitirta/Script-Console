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

Declare @Branch varchar(10)
Declare @TOC varchar(10)
Declare @ID varchar(10)


Select @Branch=S.Branch, @ID=S.ID, @ClassNo=S1.ClassNo, @TSI=S.TSI, @SDate=S.SDate, @EDate=S.EDate, @Coverage_1=S.Coverage_1, @NOfYears_1=S.NOfYears_1
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
@TOC=Max(SM.TOC),
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

--Get VAT
Declare @VAT Float
Declare @VAT_1 Float
Declare @VAT_2 Float

Select 
@VAT=Case When Profile.VatF=1 and TOC.VATBusinessF=1 Then 1 else 0 end*MParam.VAT/100*@Premium,
@VAT_1=Case When Profile.BVatF=1 Then 1 else 0 end*Branch.VAT/100*@Premium,
@VAT_2=Case When Profile.TVatF=1 Then 1 else 0 end*TOC.VAT/100*@Premium
from Profile, MParam, TOC, Branch
Where Profile.ID=@ID and MParam.Type='DI' and TOC.TOC=@TOC and Branch.Branch=@Branch 

if @VAT is null 
Begin
	Select @VAT=0
	Select @VAT_1=0
	Select @VAT_2=0
End

return @Premium+@VAT+@VAT_1+@VAT_2
End

go


 insert into PatchVersioning	
select '567 Update Script - Patch 2023 (18)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='567 Update Script - Patch 2023 (18)'


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





