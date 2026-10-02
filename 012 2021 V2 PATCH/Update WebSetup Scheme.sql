IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_Scheme_ListInterestType') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION FN_Scheme_ListInterestType 
end
GO
CREATE FUNCTION FN_Scheme_ListInterestType(@SchemeNo varchar(10))   
RETURNS Table   
AS RETURN (   
SELECT DISTINCT INTEREST, INTEREST AS INTEREST_DESC FROM 
(
SELECT 'TPL' AS INTEREST
UNION ALL
SELECT  'DRIVER' AS INTEREST
UNION ALL
SELECT  'PASSENGER' AS INTEREST
UNION ALL
SELECT  'ACCESSORIES' AS INTEREST
UNION ALL
SELECT  'OTHERS' AS INTEREST
UNION ALL
Select Interest from Scheme_InterestType Where SchemeNo=@SchemeNo
) SC_INTEREST
  
)  

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_ListScheme_CoverageType') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION FN_ListScheme_CoverageType 
end
GO
CREATE FUNCTION FN_ListScheme_CoverageType(@SchemeNo varchar(10))   
RETURNS Table   
AS RETURN (   
SELECT DISTINCT Coverage, Coverage AS COVERAGE_DESC FROM 
(
SELECT 'Comprehensive' AS Coverage
UNION ALL
SELECT 'Comprehensive+RSCC' AS Coverage
UNION ALL
SELECT 'TLO' AS Coverage
UNION ALL
SELECT 'TLO+RSCC' AS Coverage
UNION ALL
SELECT 'RSCC' AS Coverage
UNION ALL
SELECT 'RSMD' AS Coverage
UNION ALL
SELECT'AOG' AS Coverage
UNION ALL
SELECT 'TS' AS Coverage
UNION ALL
Select Coverage from Scheme_CoverageType  Where SchemeNo=@SchemeNo
) SC_CoverageType
  
)  

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QSchemeClassRateCodeUpload') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QSchemeClassRateCodeUpload
end
GO
CREATE  procedure QSchemeClassRateCodeUpload(@p_code varchar (10), @p_toc varchar(10))
as
Select RATE, UNIT, RATELOADINGF, Sum(Portion) as Portion, RCLASS.Category 
from RATECOV 
inner join RATETAB on RATECOV.CODE=RATETAB.CODE 
inner join RCLASS on RCLASS.TOR=RATECOV.tor and RATETAB.Code=@p_code 
and RCLASS.TOC=@p_toc
group by RATE, UNIT, RATELOADINGF, RCLASS.CATEGORY
go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QSchemeTOICodeUpload') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QSchemeTOICodeUpload
end
GO
CREATE procedure QSchemeTOICodeUpload(@p_TOC varchar(10), @p_TOI varchar (10))
as
Select P.TOI,  P.Category
from PClass P
INNER JOIN RateCov C ON P.TOR = C.TOR 
inner join RCLASS on RCLASS.TOR=C.tor 
where  P.TOI = @p_TOI and RCLASS.TOC=@p_toc
go
  

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QSchemeDeductibleUpload') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QSchemeDeductibleUpload
end
GO
CREATE procedure QSchemeDeductibleUpload(@p_Coverage varchar(255), @p_DCode varchar (10))
as
Select D.*
From DEDTAB D, RateCov R, scheme_coverage S 
where S.Coverage=@p_Coverage 
and D.TOR = R.TOR 
and R.Code = S.Code 
and D.Dcode = @p_DCode
GO



IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QSchemeAdditionalRateCodeUpload') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QSchemeAdditionalRateCodeUpload
end
GO
CREATE  procedure QSchemeAdditionalRateCodeUpload(@p_TOC varchar(10),@p_Code varchar(10))
as
Select UNIT, Sum(Portion) as Portion, RCLASS.Category 
from RATECOV 
inner join RATETAB on RATECOV.CODE=RATETAB.CODE 
inner join RCLASS on RCLASS.TOR=RATECOV.tor 
and RATETAB.Code=@p_Code and RCLASS.TOC=@p_TOC 
group by RATE, UNIT, RATELOADINGF, RCLASS.CATEGORY
go

 

DROP FUNCTION FN_SchemeCla
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Q_SchemeCla') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure Q_SchemeCla
end
GO
CREATE Procedure Q_SchemeCla(@p_SchemeNo varchar(10), @p_Coverage varchar(255), @p_Section varchar(10))                              
as                              
Select cast((Case When T2.OrderNo is null then 0 else 1 end) as bit) as ProcessFlag, 
coalesce(T2.OrderNo, G.OrderNo) as OrderNo, coalesce(T2.ShortDesc, G.ShortDesc) as ShortDesc, 
coalesce(T2.ShortDesc_1, G.ShortDesc_1) as ShortDesc_1, coalesce(T2.Description, G.Description) as Description, 
coalesce(T2.Description_1, G.Description_1) as Description_1, coalesce(T2.Section,'') as Section, 
coalesce(T2.CompulsoryF,0) as CompulsoryF, Cast(0 as bit) as DetailF
from Scheme_Master T1
Inner Join TOC on (TOC.TOC=T1.TOC)
Inner Join GenCla G on (G.COB=TOC.COB)
Left Join Scheme_CLA T2 on (T2.SchemeNo=@p_SchemeNo and T2.OrderNo=G.OrderNo and T2.Section=@p_Section and T2.Coverage = @p_Coverage)
Where T1.SchemeNo =@p_SchemeNo 
Order By G.OrderNo

go



DROP FUNCTION FN_SchemeCon
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Q_SchemeCon') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure Q_SchemeCon
end
GO
CREATE Procedure Q_SchemeCon(@p_SchemeNo varchar(10), @p_Coverage varchar(255), @p_Section varchar(10))                              
as                              
Select cast((Case When T2.OrderNo is null then 0 else 1 end) as bit) as ProcessFlag, 
coalesce(T2.OrderNo, G.OrderNo) as OrderNo, coalesce(T2.ShortDesc, G.ShortDesc) as ShortDesc, 
coalesce(T2.ShortDesc_1, G.ShortDesc_1) as ShortDesc_1, coalesce(T2.Description, G.Description) as Description, 
coalesce(T2.Description_1, G.Description_1) as Description_1, coalesce(T2.Section,'') as Section, 
coalesce(T2.CompulsoryF,0) as CompulsoryF, Cast(0 as bit) as DetailF
from Scheme_Master T1
Inner Join TOC on (TOC.TOC=T1.TOC)
Inner Join GenCon G on (G.COB=TOC.COB)
Left Join Scheme_Con T2 on (T2.SchemeNo=@p_SchemeNo and T2.OrderNo=G.OrderNo and T2.Section=@p_Section and T2.Coverage = @p_Coverage)
Where T1.SchemeNo =@p_SchemeNo 
Order By G.OrderNo

go


DROP FUNCTION FN_SchemeEx
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Q_SchemeEx') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure Q_SchemeEx
end
GO
CREATE Procedure Q_SchemeEx(@p_SchemeNo varchar(10), @p_Coverage varchar(255), @p_Section varchar(10))                              
as                              
Select cast((Case When T2.OrderNo is null then 0 else 1 end) as bit) as ProcessFlag, 
coalesce(T2.OrderNo, G.OrderNo) as OrderNo, coalesce(T2.ShortDesc, G.ShortDesc) as ShortDesc, 
coalesce(T2.ShortDesc_1, G.ShortDesc_1) as ShortDesc_1, coalesce(T2.Description, G.Description) as Description, 
coalesce(T2.Description_1, G.Description_1) as Description_1, coalesce(T2.Section,'') as Section, 
coalesce(T2.CompulsoryF,0) as CompulsoryF, Cast(0 as bit) as DetailF
from Scheme_Master T1
Inner Join TOC on (TOC.TOC=T1.TOC)
Inner Join GenEx G on (G.COB=TOC.COB)
Left Join Scheme_Ex T2 on (T2.SchemeNo=@p_SchemeNo and T2.OrderNo=G.OrderNo and T2.Section=@p_Section and T2.Coverage = @p_Coverage)
Where T1.SchemeNo =@p_SchemeNo 
Order By G.OrderNo

go