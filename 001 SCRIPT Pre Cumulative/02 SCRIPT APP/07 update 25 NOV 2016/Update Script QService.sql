

-- Until Here

alter Procedure [dbo].[QService](@P_SNO as int)
as
Select  Cast(0 as bit) as ProcessFlag, * from Service Where SNO=@P_SNO


go
