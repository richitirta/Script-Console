DROP Procedure QCheckFacCommission
GO
CREATE Procedure QCheckFacCommission(@P_ANO as integer, @P_FID as varchar(20))   
as   

WITH fn_fpart as (         
	Select F.ANO, F.FID, F.ID,

	--Convert Facultative NetRate to Percentage
	Case 
	When F.UNIT in ('','C') then F.NetRate
	When F.UNIT in ('M') then F.NetRate/10
	When F.Unit in ('F') and coalesce(Gross.TSI,0)<>0 then F.NetRate/coalesce(Gross.TSI,0)*R.Share/100*F.Share/100*100
	Else 0
	End as NetRate,

	F.Comm, 
	F.OComm,
	F.Discount, 
	F.AcqCost,
	coalesce(Gross.GrossRate,0) as GrossRate
	from FPart F
	Inner Join RArrDet R on (R.ANO=F.ANO and R.FID=F.FID)
	Outer Apply (
		Select Gross/TSI*100 as GrossRate, TSI from fn_Icalc(@P_ANO)
	) Gross
	Where F.ANO=@P_ANO and F.FID=@P_FID
)

Select R.Code , dbo.Premium_MaxOutGo(R.ANO, R.Code,0) as OutGo, 
Case 
When F.NetRate<>0 then
	--Premium Adjustment/Discount if Convert to Gross Rate
	(F.GrossRate-F.NetRate)*100/F.GrossRate+
	F.NetRate/F.GrossRate*
	(
		Case When coalesce(Fd.Comm,0)<>0 Then coalesce(Fd.Comm,0) else F.Comm End+
		Case When coalesce(Fd.OComm,0)<>0 Then coalesce(Fd.OComm,0) else F.OComm End+
		F.Discount+
		F.ACQCOST
	)
else
	(
		Case When coalesce(Fd.Comm,0)<>0 Then coalesce(Fd.Comm,0) else F.Comm End+
		Case When coalesce(Fd.OComm,0)<>0 Then coalesce(Fd.OComm,0) else F.OComm End+
		F.Discount+
		F.ACQCOST
	)
End FComm
from fn_fpart F
Inner join RCover R on (R.ANO=F.ANO)
Outer Apply (
	Select Fd.Comm, Fd.OComm
	from FPartDet Fd 
	Where Fd.ANO=F.ANO and Fd.FID=F.FID and Fd.ID=F.ID and 
	(
		FD.Code=R.Code
		or
		(
		Exists (Select Top 1 RCalc.Code from RCalc Inner Join RateCov on (RateCov.Code=Fd.Code and RateCov.TOR=RCalc.TOR) Where RCalc.ANO=Fd.ANO and RCalc.Code=R.Code)
		and not exists (Select FPartDet.Code from FPartDet Where FPartDet.ANO=FD.ANO and FPartDet.FID=Fd.FID And FPartDet.ID=Fd.ID and FPartDet.Code=R.Code)
		)
	)

) Fd
