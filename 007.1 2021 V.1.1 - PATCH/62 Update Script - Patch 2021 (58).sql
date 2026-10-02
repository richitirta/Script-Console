IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'GetReinsuranceRate') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure GetReinsuranceRate 
end
GO
CREATE Procedure GetReinsuranceRate(@P_TOC as varchar(10), @P_Currency as varchar(10), @P_SDate as smalldatetime, @P_PHolder as varchar(10)='')   
as   
SELECT coalesce(ReRate.CCYTo,'') as CCYTo,
Case 
When coalesce(ReRate.Rate,0)<>0 Then ReRate.Rate 
Else 
	Case
	When coalesce(ReRate.CCYTO,'')='' or coalesce(ReRate.CCYTO,'')=@P_Currency Then 
		Case When @P_Currency<>SysTab.Currency Then (Select Rate from fn_exchange(@P_SDate) Currency Where Currency=@P_Currency) else 1 end
	Else
		Case When @P_Currency<>SysTab.Currency Then (Select Rate from fn_exchange(@P_SDate) Currency Where Currency=@P_Currency) else 1 end
		/
		Case When @P_Currency<>ReRate.CCYTO Then (Select Rate from fn_exchange(@P_SDate) Currency Where Currency=ReRate.CCYTO) else 1 end
	End
end as Rate
From SysTab
Left Join ReRate on 
(
ReRate.TOC=@P_TOC
and ReRate.Currency=@P_Currency
and ReRate.RYear=coalesce((   
 Select Top 1 R1.RYear   
 from Reinsurance R1, ReClass R2   
 Left Join RePolicy R3 on (R3.RNO=R2.RNO and R3.ID=@P_PHolder)   
 Where (R1.Category<>'P' or Coalesce(R3.ID,'')<>'') and R1.RType='Q' and R2.RNO=R1.RNO and R2.TOC=@P_TOC and @P_SDate Between R1.SDate and R1.EDate   
 Order By coalesce(R3.ID,'') Desc, (Case When R2.PriorityF=1 Then R2.PriorityF else R1.PriorityF end) Desc),Year(@P_SDate)) 
)
go


insert into PatchVersioning
select '62 Update Script - Patch 2021 (58)',GETDATE()
go

