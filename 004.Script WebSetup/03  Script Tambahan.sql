--1

GO

/****** Object:  UserDefinedFunction [dbo].[FN_SchemeEx]    Script Date: 3/24/2017 10:44:05 AM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FN_SchemeEx]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION  [dbo].[FN_SchemeEx]
end
GO

/****** Object:  UserDefinedFunction [dbo].[FN_SchemeEx]    Script Date: 3/24/2017 10:44:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_SchemeEx] (@p_SchemeNo varchar(10), @p_Coverage varchar(255), @p_Section varchar(10))
  RETURNS @return_variable TABLE 
    (
        ProcessFlag bit, OrderNo varchar(10), ShortDesc VARCHAR(255), Description text, ShortDesc_1 VARCHAR(255), Description_1 text, CompulsoryF bit
    )
AS
BEGIN
    declare @Child TABLE  (OrderNo varchar(10), ShortDesc VARCHAR(255), Description text, ShortDesc_1 VARCHAR(255), Description_1 text, CompulsoryF bit)
    declare @Parent TABLE  (OrderNo varchar(10), ShortDesc VARCHAR(255), Description text, ShortDesc_1 VARCHAR(255), Description_1 text, CompulsoryF bit)
	
    INSERT @Child (OrderNo, ShortDesc, Description, ShortDesc_1, Description_1, CompulsoryF)
    select OrderNo,ShortDesc, GenEx.Description, GenEx.ShortDesc_1, GenEx.Description_1, 0 as CompulsoryF from GenEx, TOC, scheme_master S where GenEx.COB=TOC.COB and TOC.TOC=S.TOC and S.SchemeNo= @p_SchemeNo Order by OrderNo

	INSERT @Parent (OrderNo, ShortDesc, Description, ShortDesc_1, Description_1, CompulsoryF)
	select OrderNo,ShortDesc, Description, ShortDesc_1, Description_1, CompulsoryF from Scheme_EX where Coverage= @p_Coverage and Section like @p_Section + '%' and SchemeNo= @p_SchemeNo Order by OrderNo
    
    INSERT INTO @return_variable
    select * from (
		select case when P.ORDERNO <> '' then 1 else 0 end as ProcessFlag, 
		C.OrderNo, C.ShortDesc, case when P.OrderNo<> '' then p.Description else c.Description end as Description, 
		C.ShortDesc_1, c.Description_1, P.CompulsoryF from @Child C left join @Parent P on C.ORDERNO = P.ORDERNO
	)x

	RETURN
END


GO

--2

GO

/****** Object:  UserDefinedFunction [dbo].[FN_SchemeCon]    Script Date: 3/24/2017 10:44:18 AM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FN_SchemeCon]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 

BEGIN DROP FUNCTION  [dbo].[FN_SchemeCon]
end
GO

/****** Object:  UserDefinedFunction [dbo].[FN_SchemeCon]    Script Date: 3/24/2017 10:44:18 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_SchemeCon] (@p_SchemeNo varchar(10), @p_Coverage varchar(255), @p_Section varchar(10))
  RETURNS @return_variable TABLE 
    (
        ProcessFlag bit, OrderNo varchar(10), ShortDesc VARCHAR(255), Description text, ShortDesc_1 VARCHAR(255), Description_1 text, CompulsoryF bit
    )
AS
BEGIN
    declare @Child TABLE  (OrderNo varchar(10), ShortDesc VARCHAR(255), Description text, ShortDesc_1 VARCHAR(255), Description_1 text, CompulsoryF bit)
    declare @Parent TABLE  (OrderNo varchar(10), ShortDesc VARCHAR(255), Description text, ShortDesc_1 VARCHAR(255), Description_1 text, CompulsoryF bit)
	
    INSERT @Child (OrderNo, ShortDesc, Description, ShortDesc_1, Description_1, CompulsoryF)
    select OrderNo,ShortDesc, GenCon.Description, GenCon.ShortDesc_1, GenCon.Description_1, 0 as CompulsoryF from GenCon, TOC, scheme_master S where GenCon.COB=TOC.COB and TOC.TOC=S.TOC and S.SchemeNo=@p_SchemeNo Order by OrderNo

	INSERT @Parent (OrderNo, ShortDesc, Description, ShortDesc_1, Description_1, CompulsoryF)
	select OrderNo,ShortDesc, Description, ShortDesc_1, Description_1, CompulsoryF from Scheme_CON where Coverage=@p_Coverage and Section like @p_Section + '%' and SchemeNo= @p_SchemeNo Order by OrderNo
    
    INSERT INTO @return_variable
    select * from (
		select case when P.ORDERNO <> '' then 1 else 0 end as ProcessFlag, 
		C.OrderNo, C.ShortDesc, case when P.OrderNo<> '' then p.Description else c.Description end as Description, 
		C.ShortDesc_1, c.Description_1, P.CompulsoryF from @Child C left join @Parent P on C.ORDERNO = P.ORDERNO
	)x

	RETURN
END


GO

--3

GO

/****** Object:  UserDefinedFunction [dbo].[FN_SchemeCla]    Script Date: 3/24/2017 10:44:41 AM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FN_SchemeCla]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 

BEGIN DROP FUNCTION  [dbo].[FN_SchemeCla]
end
GO

/****** Object:  UserDefinedFunction [dbo].[FN_SchemeCla]    Script Date: 3/24/2017 10:44:41 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_SchemeCla] (@p_SchemeNo varchar(10), @p_Coverage varchar(255), @p_Section varchar(10))
  RETURNS @return_variable TABLE 
    (
        ProcessFlag bit, OrderNo varchar(10), ShortDesc VARCHAR(255), Description text, ShortDesc_1 VARCHAR(255), Description_1 text, CompulsoryF bit
    )
AS
BEGIN
    declare @Child TABLE  (OrderNo varchar(10), ShortDesc VARCHAR(255), Description text, ShortDesc_1 VARCHAR(255), Description_1 text, CompulsoryF bit)
    declare @Parent TABLE  (OrderNo varchar(10), ShortDesc VARCHAR(255), Description text, ShortDesc_1 VARCHAR(255), Description_1 text, CompulsoryF bit)
	
    INSERT @Child (OrderNo, ShortDesc, Description, ShortDesc_1, Description_1, CompulsoryF)
    select OrderNo,ShortDesc, GenCla.Description, GenCla.ShortDesc_1, GenCla.Description_1, 0 as CompulsoryF from GenCla, TOC, Scheme_Master S where GenCla.COB=TOC.COB and TOC.TOC=S.TOC and S.SchemeNo=@p_SchemeNo Order by OrderNo

	INSERT @Parent (OrderNo, ShortDesc, Description, ShortDesc_1, Description_1, CompulsoryF)
    select OrderNo,ShortDesc, Description, ShortDesc_1, Description_1, CompulsoryF from Scheme_Cla where Coverage= @p_Coverage and Section like @p_Section + '%' and SchemeNo= @p_SchemeNo Order by OrderNo

    INSERT INTO @return_variable
    select * from (
		select case when P.ORDERNO <> '' then 1 else 0 end as ProcessFlag, 
		C.OrderNo, C.ShortDesc, case when P.OrderNo<> '' then p.Description else c.Description end as Description, 
		C.ShortDesc_1, c.Description_1, P.CompulsoryF from @Child C left join @Parent P on C.ORDERNO = P.ORDERNO
	)x

	RETURN
END


GO

--4

GO

/****** Object:  UserDefinedFunction [dbo].[FN_SchemeBranch]    Script Date: 3/24/2017 10:44:46 AM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FN_SchemeBranch]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION  [dbo].[FN_SchemeBranch]
end
GO

/****** Object:  UserDefinedFunction [dbo].[FN_SchemeBranch]    Script Date: 3/24/2017 10:44:46 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_SchemeBranch] (@p_SchemeNo varchar(10))
  RETURNS @return_variable TABLE 
    (
        ProcessFlag bit, Branch varchar(10), Name VARCHAR(70)
    )
AS
BEGIN
    declare @Branch TABLE  (Branch varchar(10), Name VARCHAR(70), ProcessFlag bit)
    declare @SchemeBranch TABLE  (SchemeNo varchar(10), Branch VARCHAR(10))
	
    INSERT @Branch (Branch, Name, ProcessFlag)
    select Branch, Name, 0 as ProcessFlag from Branch where Op_Flag=1

	INSERT @SchemeBranch (SchemeNo, Branch)
    select * from Scheme_Branch where SchemeNo = @p_SchemeNo

    
        INSERT INTO @return_variable
        select case when Branch in (select Branch from @SchemeBranch where SchemeNo = @p_SchemeNo) then 1 else ProcessFlag end as ProcessFlag, Branch, Name from @Branch
 
    RETURN
END


GO

--5

GO

/****** Object:  UserDefinedFunction [dbo].[FN_RexCla]    Script Date: 3/24/2017 10:44:51 AM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FN_RexCla]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION  [dbo].[FN_RexCla]
end
GO

/****** Object:  UserDefinedFunction [dbo].[FN_RexCla]    Script Date: 3/24/2017 10:44:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_RexCla] (@p_TOC varchar(10), @p_RYear int)
  RETURNS @return_variable TABLE 
    (
        ProcessFlag bit, OrderNo varchar(10), ShortDesc VARCHAR(255), Description text
    )
AS
BEGIN
    declare @Child TABLE  (OrderNo varchar(10), ShortDesc VARCHAR(255), Description text)
    declare @Parent TABLE  (OrderNo varchar(10), ShortDesc VARCHAR(255), Description text)
	
    INSERT @Child (OrderNo, ShortDesc, Description)
    SELECT OrderNo,ShortDesc, GenCla.Description  from GenCla, TOC where TOC.TOC= @p_TOC and GenCla.COB=TOC.COB

	INSERT @Parent (OrderNo, ShortDesc, Description)
    SELECT OrderNo,ShortDesc, Description  from REXCLA where TOC=@p_TOC and RYear=@p_RYear

    --WHILE (@@ROWCOUNT > 0)
    --BEGIN
        INSERT INTO @return_variable
        select * from (select case when P.ORDERNO <> '' then 1 else 0 end as ProcessFlag, C.OrderNo, C.ShortDesc, case when P.OrderNo<> '' then p.Description else c.Description end as Description from @Child C left join @Parent P on C.ORDERNO = P.ORDERNO) x

        --DELETE FROM @Parent

        --INSERT INTO @Parent
        --SELECT * FROM @Child

        --DELETE FROM @Child

        --INSERT INTO @Child (OrderNo, ShortDesc, Description)
        --SELECT OrderNo,ShortDesc, Description  from REXCLA where TOC=@p_TOC and RYear=@p_RYear
    --END
    RETURN
END

GO



/****** Object:  StoredProcedure [dbo].[QDefCla]    Script Date: 3/24/2017 10:14:23 PM ******/
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QDefCla]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE [dbo].[QDefCla]
END
GO

/****** Object:  StoredProcedure [dbo].[QDefCla]    Script Date: 3/24/2017 10:14:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[QDefCla] (@TOC Varchar(10), @OrderNo Varchar(10), @Section varchar(10) )    
AS    
 BEGIN

	SELECT * FROM DefCLA WHERE TOC=@TOC and OrderNo=@OrderNo and Section=@Section
	
 END   

GO

--9

GO

/****** Object:  StoredProcedure [dbo].[QDefCla2]    Script Date: 3/24/2017 10:14:34 PM ******/
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QDefCla2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE [dbo].[QDefCla2]
END
GO

/****** Object:  StoredProcedure [dbo].[QDefCla2]    Script Date: 3/24/2017 10:14:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[QDefCla2] (@TOC Varchar(10), @OrderNo Varchar(10), @Flag varchar(50), @Section varchar(10) )    
AS    
 BEGIN

	IF @FLAG='DefCLA' SELECT * FROM DefCLA WHERE TOC=@TOC and OrderNo=@OrderNo and Section=@Section
	ELSE IF @Flag='DefCon' SELECT * FROM DefCon WHERE TOC=@TOC and OrderNo=@OrderNo and Section=@Section
	ELSE IF @Flag='DefEx' SELECT * FROM DefEx WHERE TOC=@TOC and OrderNo=@OrderNo and Section=@Section
      
 END   

GO


--10

GO

/****** Object:  StoredProcedure [dbo].[QDefCon]    Script Date: 3/24/2017 10:14:49 PM ******/
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QDefCon]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE [dbo].[QDefCon]
end
GO

/****** Object:  StoredProcedure [dbo].[QDefCon]    Script Date: 3/24/2017 10:14:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[QDefCon] (@TOC Varchar(10), @OrderNo Varchar(10), @Section varchar(10) )    
AS    
 BEGIN

	SELECT * FROM DefCON WHERE TOC=@TOC and OrderNo=@OrderNo and Section=@Section
	
 END   

GO


--11

GO

/****** Object:  StoredProcedure [dbo].[QDefEx]    Script Date: 3/24/2017 10:15:02 PM ******/
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QDefEx]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE [dbo].[QDefEx]
end
GO

/****** Object:  StoredProcedure [dbo].[QDefEx]    Script Date: 3/24/2017 10:15:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[QDefEx] (@TOC Varchar(10), @OrderNo Varchar(10), @Section varchar(10) )    
AS    
 BEGIN

	SELECT * FROM DefEX WHERE TOC=@TOC and OrderNo=@OrderNo and Section=@Section
	
 END   

GO

--12

GO

/****** Object:  UserDefinedFunction [dbo].[FN_GENDTAB2]    Script Date: 3/24/2017 10:15:44 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FN_GENDTAB2]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION  [dbo].[FN_GENDTAB2]
end
GO

/****** Object:  UserDefinedFunction [dbo].[FN_GENDTAB2]    Script Date: 3/24/2017 10:15:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_GENDTAB2] (@P_TOC as varchar(10))          
RETURNS TABLE          
as RETURN(          
Select G1.*
from GenDTab G1 Inner Join GenHTab G2 on (G2.FLDID=G1.FLDID) 
Where 
(
G2.SubClassF=0 or @P_TOC='' 
or (G2.SubClassF=1 and EXISTS (Select Top 1 ValueID from GenDTOC G3 Where G3.FLDID=G1.FLDID and G3.VALUEID=G1.VALUEID and G3.TOC=@P_TOC))
)
)        



GO

--13


GO

/****** Object:  UserDefinedFunction [dbo].[FN_QTOPRateCode]    Script Date: 5/8/2017 1:40:15 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FN_QTOPRateCode]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION  [dbo].[FN_QTOPRateCode]
end
GO

/****** Object:  UserDefinedFunction [dbo].[FN_QTOPRateCode]    Script Date: 5/8/2017 1:40:15 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_QTOPRateCode] (@p_code varchar (10), @p_TOPRO varchar(10))
RETURNS TABLE  
AS RETURN (  
	SELECT RateTab.Code, RateTab.Description, RateTab.Unit, RateTab.NoRefundF, max(RClass.Category) as Category, sum(RateTab.Rate*RateCov.Portion/100) AS Rate, sum(RateCov.Portion) AS Portion  
	From RateTab, RateCov, Rclass, TOPRO  
	Where RateTab.Code Like @P_Code and RateTab.Code=RateCov.Code and Rclass.TOR=RateCov.TOR and Rclass.TOC=TOPRO.TOC and TOPRO.TOPRO=@P_TOPRO  
	Group By RateTab.Code, RateTab.Description, RateTab.Unit, RateTab.NoRefundF

) 
GO


--14

GO

/****** Object:  UserDefinedFunction [dbo].[FN_QTOPDedCode]    Script Date: 5/8/2017 1:40:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FN_QTOPDedCode]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION  [dbo].[FN_QTOPDedCode]
end
GO
CREATE FUNCTION [dbo].[FN_QTOPDedCode] (@p_TOPRO varchar(10), @p_DCode varchar(10))
RETURNS TABLE  
AS RETURN (  
	Select Distinct Dedtab.DCODE, Dedtab.REMARKS, Dedtab.PCTTSI, PCTCL, FIXEDMIN, FIXEDMAX, CURRENCY, IUNIT
	From Rclass, DedTAB, TOPRO
	Where TOPRO.TOPRO=@P_TOPRO AND Rclass.TOC=TOPRO.TOC and Rclass.TOR=DedTAB.TOR and DedTAB.DCode Like @P_DCode
) 
GO





IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_Drop_TOC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
drop Procedure [dbo].[SP_Drop_TOC]
end
go

Create Procedure [dbo].[SP_Drop_TOC] (@TOC varchar(10))    
as    
 begin    
  Delete From TOC Where TOC=@TOC;    
 end 

go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_Search_CSTALLOCATIOND') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
drop procedure SP_Search_CSTALLOCATIOND
end
go
CREATE procedure SP_Search_CSTALLOCATIOND (@Branch varchar(10))  
as  
Select Cast(0 as bit) as ProcessFlag, C1.*, C2.Description from CSTALLOCATIOND C1, CT C2 where C2.CT=C1.CT and 
C1.Branch=@Branch
go
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QTOR_Rule') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QTOR_Rule
end
GO
create PROCEDURE QTOR_Rule (@P_TOR AS VARCHAR(10),@DCODE AS VARCHAR(10))       
AS 
select top 1 
TOR.RFLDID1, '' AS ValueID1L,'' AS ValueID1U,
TOR.RFLDID2, '' AS ValueID2L,'' AS ValueID2U,
TOR.RFLDID3, '' AS ValueID3L,'' AS ValueID3U,
TOR.RFLDID4, '' AS ValueID4L,'' AS ValueID4U,
TOR.RFLDID5, '' AS ValueID5L,'' AS ValueID5U
FROM       
TOR left join DEDTAB on (DEDTAB.TOR=TOR.TOR)
LEFT OUTER JOIN GENHTAB as GENHTAB_1 ON TOR.RFLDID1<>'' AND TOR.RFLDID1 = GENHTAB_1.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_2 ON TOR.RFLDID2<>'' AND TOR.RFLDID2 = GENHTAB_2.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_3 ON TOR.RFLDID3<>'' AND TOR.RFLDID3 = GENHTAB_3.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_4 ON TOR.RFLDID4<>'' AND TOR.RFLDID4 = GENHTAB_4.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_5 ON TOR.RFLDID5<>'' AND TOR.RFLDID5 = GENHTAB_5.FLDID       
WHERE TOR.TOR = @P_TOR and @DCODE=''
union all
SELECT  top 1         
TOR.RFLDID1, DEDTAB.ValueID1L AS ValueID1L,DEDTAB.ValueID1U AS ValueID1U,
TOR.RFLDID2, DEDTAB.ValueID2L AS ValueID2L,DEDTAB.ValueID2U AS ValueID2U,
TOR.RFLDID3, DEDTAB.ValueID3L AS ValueID3L,DEDTAB.ValueID3U AS ValueID3U,
TOR.RFLDID4, DEDTAB.ValueID4L AS ValueID4L,DEDTAB.ValueID4U AS ValueID4U,
TOR.RFLDID5, DEDTAB.ValueID5L AS ValueID5L,DEDTAB.ValueID5U AS ValueID5U
FROM       
DEDTAB, TOR
LEFT OUTER JOIN GENHTAB as GENHTAB_1 ON TOR.RFLDID1<>'' AND TOR.RFLDID1 = GENHTAB_1.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_2 ON TOR.RFLDID2<>'' AND TOR.RFLDID2 = GENHTAB_2.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_3 ON TOR.RFLDID3<>'' AND TOR.RFLDID3 = GENHTAB_3.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_4 ON TOR.RFLDID4<>'' AND TOR.RFLDID4 = GENHTAB_4.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_5 ON TOR.RFLDID5<>'' AND TOR.RFLDID5 = GENHTAB_5.FLDID       
WHERE DEDTAB.TOR=TOR.TOR and 
TOR.TOR = @P_TOR and DEDTAB.DCODE=@DCODE
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_Drop_RateTab') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE SP_Drop_RateTab
end
GO

 Create Procedure [dbo].SP_Drop_RateTab (@CODE varchar(10))    
as    
 begin    
  Delete From RATETAB Where CODE=@CODE;    
 end 
 go

 IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QRate_Ratcon]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
   DROP PROCEDURE [dbo].[QRate_Ratcon]
   end
  go
CREATE PROCEDURE [dbo].[QRate_Ratcon] (@CODE Varchar(10) )            
AS            
 BEGIN                    
 SELECT CAST(0 As Bit) ProcessFlag, RATECON, RATECON.CODE AS CODE,MinTSI,MaxTSI,      
 cast(coalesce(MinTSI, '0') as varchar(30)) +' - '+ cast(coalesce(MaxTSI, '0')as varchar(30)) as TSI,       
 cast(coalesce(RATECON.MinRate, '0')  as varchar(30)) + ' - ' + cast(coalesce(RATECON.MaxRate, '0') as varchar(30)) as 'RATEP',       
 cast(coalesce(MINPERIOD, '0')  as varchar(30)) + ' - ' + cast(coalesce(MAXPERIOD, '0') as varchar(30)) as 'Coverage',      
 RATETAB.SPERIOD,TEXCESS, RATECON.ALLOWEDF, LOADING       
 from RateCon   
 LEFT JOIN RATETAB ON RATETAB.CODE = RATECON.CODE  
   
 where RATECON.CODE=@CODE   
 end
 GO  
 
 insert into PatchVersioning
select '03  Script Tambahan',GETDATE()
go