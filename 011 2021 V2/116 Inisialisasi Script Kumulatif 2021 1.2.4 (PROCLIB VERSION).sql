

Update SysTab Set RiskAccumulationByTreatyYearF=0 Where RiskAccumulationByTreatyYearF is null
GO

Update TOP_Rate set PCTINDEMNITY_SOURCE='' Where PCTINDEMNITY_SOURCE is null
GO


Update ComAcc set RESTRICTAFTERUSEDF=0, Remarks='' Where RESTRICTAFTERUSEDF is null
GO
