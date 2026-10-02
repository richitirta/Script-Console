IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QScheme_Verify_3') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QScheme_Verify_3 
end
GO
CREATE Procedure QScheme_Verify_3 
@P_Coverage as varchar(255), 
@P_Code as varchar(10), 
@p_LMonth as float, 
@p_UMonth as float, 
@p_SchemeNo as varchar (10), 
@p_Description as varchar (255), 
@P_TSI as float=0 
as 
 
Declare @p_ClassNo int 
Declare @P_SIInceptionF Bit 
Select Top 1 @p_ClassNo=S2.ClassNo, @P_SIInceptionF=S1.SIInceptionF 
from scheme_Master S1, Scheme_Class S2 
Where S1.SchemeNo=@P_SchemeNo and S2.SchemeNo=S1.SchemeNo and @P_Description like S2.Description 
Order by S2.Priority Desc  


Select 
S1.Lower, 
Cast(Max(cast(S1.NoRefundF as Int)) as Bit) as NoRefundF, 
Cast(Max(cast(S1.RateLoadingF as Int)) as Bit) as RateLoadingF, 
Cast(Max(cast(Coalesce(SI1.HoldF, S1.HoldF) as Int)) as Bit) as HoldF, 
Max(S1.Upper)as Upper, 
Max(coalesce(SI1.PCTLoss, S1.PCTLoss)) as PCTLoss, 
Max(coalesce(SI1.PAddition, S1.PAddition)) as PAddition, 
Max(coalesce(SI1.Discount, S1.Discount)) as Discount, 
Max(coalesce(SI1.RateLower, S1.RateLower)) as RateLower, 
Max(coalesce(SI1.Rate,S1.Rate)) as Rate 
From 
Scheme_Indemnity S1 
Left Join Scheme_Indemnity_TSI SI1 
On (SI1.ClassNo=S1.ClassNo and SI1.Coverage=S1.Coverage and SI1.Code=S1.Code and SI1.Lower=S1.Lower and SI1.Upper=S1.Upper)
Where 
-- Range by TSI Compare to Header Only Percentage Of Loss
(coalesce(SI1.ClassNo,'')='' or ((@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end>=SI1.MinTSI or SI1.MinTSI=0) and (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end<=SI1.MaxTSI or SI1.MaxTSI=0)))
and S1.ClassNo=@P_ClassNo 
and S1.Coverage=@P_Coverage 
and S1.Code=@P_Code 
and 
( 
(S1.Lower>=@p_LMonth and S1.Upper<=@p_UMonth) 
or 
(S1.Lower<=@p_LMonth and S1.Upper>=@p_UMonth) 
or 
(S1.Lower<=@p_LMonth and S1.Upper>=@p_LMonth) 
or 
(S1.Lower<=@p_UMonth and S1.Upper>=@p_UMonth) 
) 
and NOT EXISTS (Select S3.ClassNo from Scheme_Indemnity S3 Where S3.ClassNo=S1.ClassNo and S3.Coverage=S1.Coverage and S3.Code=S1.Code and S1.Lower=S3.Lower and S1.Upper>S3.Upper and S3.Lower<=@P_LMonth and S3.Upper>=@P_UMonth) 
and NOT EXISTS (Select S3.ClassNo from Scheme_Indemnity S3 Where S3.ClassNo=S1.ClassNo and S3.Coverage=S1.Coverage and S3.Code=S1.Code and S1.Lower=S3.Lower and S1.Upper<S3.Upper and S3.Lower>=@P_LMonth and S3.Upper<=@P_UMonth) 
and S1.ProgressiveF=0

Group By S1.Lower
 
Union All

Select 
S1.Lower, 
Cast(Max(cast(S1.NoRefundF as Int)) as Bit) as NoRefundF, 
Cast(Max(cast(S1.RateLoadingF as Int)) as Bit) as RateLoadingF, 
Cast(Max(cast(S1.HoldF as Int)) as Bit) as HoldF, 
Max(S1.Upper)as Upper, 
Max(S1.PCTLoss) as PCTLoss, 
Max(S1.PAddition) as PAddition, 
Max(S1.Discount) as Discount, 
sum(
	Case       
	When S3.Unit='F' then 
		Case When (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)<>0 Then SI1.RateLower/(@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)*100 else 0 end
	When S3.Unit='M' then 
		Case When (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)>=SI1.MaxTSI Then SI1.MaxTSI-SI1.MinTSI Else (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)-SI1.MinTSI end*SI1.RateLower/10/(@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)
	else 
	    Case When (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)>=SI1.MaxTSI Then SI1.MaxTSI-SI1.MinTSI Else (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)-SI1.MinTSI end*SI1.RateLower/(@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end) 
	end 
	) as RateLower,
sum(
	Case       
	When S3.Unit='F' then 
		Case When (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)<>0 Then SI1.Rate/(@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)*100 else 0 end
	When S3.Unit='M' then 
		Case When (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)>=SI1.MaxTSI Then SI1.MaxTSI-SI1.MinTSI Else (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)-SI1.MinTSI end*SI1.Rate/10/(@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)
	else 
	    Case When (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)>=SI1.MaxTSI Then SI1.MaxTSI-SI1.MinTSI Else (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)-SI1.MinTSI end*SI1.Rate/(@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end) 
	end 
	) as Rate
From 
Scheme_Indemnity S1 
Inner Join Scheme_Indemnity_TSI SI1 
On (SI1.ClassNo=S1.ClassNo and SI1.Coverage=S1.Coverage and SI1.Code=S1.Code and SI1.Lower=S1.Lower and SI1.Upper=S1.Upper 
-- Range by TSI Compare to Header Only Percentage Of Loss
and ((@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end) Between SI1.MinTSI and SI1.MaxTSI or (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)>=SI1.MaxTSI)) 
Inner Join Scheme_Coverage S3 on (S3.ClassNo=S1.ClassNo and S3.Coverage=S1.Coverage and S3.Code=S1.Code)
Where 
S1.ClassNo=@P_ClassNo 
and S1.Coverage=@P_Coverage 
and S1.Code=@P_Code 
and 
( 
(S1.Lower>=@p_LMonth and S1.Upper<=@p_UMonth) 
or 
(S1.Lower<=@p_LMonth and S1.Upper>=@p_UMonth) 
or 
(S1.Lower<=@p_LMonth and S1.Upper>=@p_LMonth) 
or 
(S1.Lower<=@p_UMonth and S1.Upper>=@p_UMonth) 
) 
and NOT EXISTS (Select S3.ClassNo from Scheme_Indemnity S3 Where S3.ClassNo=S1.ClassNo and S3.Coverage=S1.Coverage and S3.Code=S1.Code and S1.Lower=S3.Lower and S1.Upper>S3.Upper and S3.Lower<=@P_LMonth and S3.Upper>=@P_UMonth) 
and NOT EXISTS (Select S3.ClassNo from Scheme_Indemnity S3 Where S3.ClassNo=S1.ClassNo and S3.Coverage=S1.Coverage and S3.Code=S1.Code and S1.Lower=S3.Lower and S1.Upper<S3.Upper and S3.Lower>=@P_LMonth and S3.Upper<=@P_UMonth) 
and S1.ProgressiveF=1 and (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)<>0
Group By S1.Lower
Order By Lower
 

 go
 
  insert into PatchVersioning
select '54.5 Update Script - Patch 2019 (8)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='54.4 Update Script - Patch 2019 (7)'
Select @CurrSCript='54.5 Update Script - Patch 2019 (8)'


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


