/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.IFRS_Assumption ADD
	Period_Lower int NULL,
	Period_Upper int NULL
GO
DECLARE @v sql_variant 
SET @v = N'Insurance Coverage Period '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'IFRS_Assumption', N'COLUMN', N'Period_Lower'
GO
DECLARE @v sql_variant 
SET @v = N'Insurance Coverage Period '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'IFRS_Assumption', N'COLUMN', N'Period_Upper'
GO
Update IFRS_Assumption set Period_Lower=0, Period_Upper=0 Where Period_Lower is null
GO
COMMIT

GO

DROP Procedure IFRS_Get_Assumption
GO
Create Procedure IFRS_Get_Assumption(@PDate as smalldatetime, @NumMonths as Integer, @AssumptionID as varchar(10), @TSI as Float, @Segment as varchar(10), @TOC as varchar(10), @CGroup as varchar(10), @Currency as varchar(10))                  
as                  

Declare @NumYears as Integer

Select @NumYears=Case When (@NumMonths % 12)<>0 then @NumMonths/12+1 else @NumMonths/12 end

Select I2.*, I7.DiscRate, I8.*
from IFRS_Assumption I1
cross apply (Select Top 1 * from IFRS_Assumption_Detail I2 Where I2.AssumptionID=I1.AssumptionID and I2.VDate<=@PDate order by I2.VDate Desc) I2
Left Join IFRS_Assumption_Segment I3 on (@AssumptionID='' and I3.AssumptionID=I1.AssumptionID and I3.Segment=@Segment)
Left Join IFRS_Assumption_TOC I4 on (@AssumptionID='' and I4.AssumptionID=I1.AssumptionID and I4.TOC=@TOC)
Left Join IFRS_Assumption_CGroup I5 on (@AssumptionID='' and I5.AssumptionID=I1.AssumptionID and I5.CGroup=@Cgroup)
Left Join IFRS_Assumption_Currency I6 on (@AssumptionID='' and I6.AssumptionID=I1.AssumptionID and I6.Currency=@Currency)
cross apply (
	Select Top 1 I2.DiscRate 
	from IFRS_DiscRate_Detail I2 
	Where I2.DiscRateID=I1.DiscRateID and I2.VDate<=@PDate and I2.Tenor=(@NumYears)
	order by I2.VDate Desc) I7
Outer apply (
	Select Top 1 
	I2.ERatio_1,
	I2.ERatio_2,
	I2.ERatio_3,
	I2.ERatio_4,
	I2.ERatio_5,
	I2.ERatio_6,
	I2.ERatio_7,
	I2.ERatio_8,
	I2.ERatio_9,
	I2.ERatio_10,
	I2.ERatio_11,
	I2.ERatio_12,
	I2.ERatio_13,
	I2.ERatio_14,
	I2.ERatio_15,
	I2.ERatio_16,
	I2.ERatio_17,
	I2.ERatio_18,
	I2.ERatio_19,
	I2.ERatio_20,
	I2.ERatio_21,
	I2.ERatio_22,
	I2.ERatio_23,
	I2.ERatio_24,
	I2.ERatio_25,
	I2.ERatio_26,
	I2.ERatio_27,
	I2.ERatio_28,
	I2.ERatio_29,
	I2.ERatio_30
	from IFRS_ERatio_Detail I2
	Where I2.ERatioID=I1.ERatioID and I2.VDate<=@PDate and I2.Tenor=(@NumYears)
	order by I2.VDate Desc) I8
Where 
(@AssumptionID<>'' 
 and I1.AssumptionID=@AssumptionID) or 
(@AssumptionID='' 
 and (I1.SI_Lower=0 or @TSI>=I1.SI_Lower)
 and (I1.SI_Upper=0 or @TSI<=I1.SI_Upper)
 and (I1.Period_Lower=0 or @NumMonths>=I1.Period_Lower)
 and (I1.Period_Upper=0 or @NumMonths<=I1.Period_Upper)
 and coalesce(I3.Segment,'')=@Segment 
 and coalesce(I4.TOC,'')=@TOC 
 and coalesce(I5.CGroup,'')=@CGroup 
 and coalesce(I6.Currency,'')=@Currency 
 and I1.AllowedF=1
 )

 go

 

 insert into PatchVersioning
select '408 Update Script - IFRS Patch #1',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='408 Update Script - IFRS Patch #1'


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


