alter FUNCTION [dbo].[FL_UW_Ded](@P_ANO as integer, @P_DCode as varchar(255), @P_TOPF as bit=0)
RETURNS TABLE
As Return (
Select Distinct DedTab.* 
From RCOVER
Inner Join RATECOV on RATECOV.CODE = RCOVER.CODE
Inner Join DedTab on DeDTab.TOR = RateCov.TOR 
Inner Join Acceptance on Acceptance.ANO = RCover.ANO
Left join TOP_Deductible on TOP_Deductible.TOPRO=Acceptance.TOPRO and TOP_Deductible.DCode=DedTab.DCode 
WHERE RCOVER.ANO=@P_ANO and DedTab.ALLOWEDF=1 AND (DedTab.DCode Like @P_DCode OR DedTab.Remarks Like @P_DCode +'%')
and (@P_TOPF=0 or coalesce(TOP_Deductible.TOPRO,'')=Acceptance.TOPRO) 
)
go