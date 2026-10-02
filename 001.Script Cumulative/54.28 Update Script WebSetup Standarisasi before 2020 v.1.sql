
--3 Nov 2019 : Standarisasi WebSetup: RateTable
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'sp_tor') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function sp_tor
end
go
create function sp_tor(@tor varchar(10)='')
RETURNS TABLE
As Return (
select TOR, DESCRIPTION, Description as DetailDescription,  SUBRISKF, AllowedF, RFLDID1, RFLDID2, RFLDID3, RFLDID4,RFLDID5 from  tor
)
go
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_DropMinPrem]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP  Procedure [dbo].[SP_DropMinPrem]
end
GO
 Create Procedure [dbo].[SP_DropMinPrem] (@CODE varchar(10), @TOC varchar(10), @BRANCH varchar(10), @SOURCE varchar(10), @CURRENCY varchar(10), @STYPE varchar(1))    

as    
 begin    
    Delete From RateMin Where CODE=@CODE and TOC=@TOC AND BRANCH=@BRANCH and SOURCE=@SOURCE AND Currency=@CURRENCY and SType=@STYPE;    
 end

  
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FN_QTOPRateCode]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION [dbo].[FN_QTOPRateCode]
end
Go
CREATE FUNCTION [dbo].[FN_QTOPRateCode] (@p_code varchar (10), @p_TOPRO varchar(10))
RETURNS TABLE  
AS RETURN (  
	SELECT RateTab.Code, RateTab.Description, RateTab.Description as Remark, RateTab.Unit, RateTab.NoRefundF, max(RClass.Category) as Category, sum(RateTab.Rate*RateCov.Portion/100) AS Rate, sum(RateCov.Portion) AS Portion  
	From RateTab, RateCov, Rclass, TOPRO  
	Where RateTab.Code Like @P_Code and RateTab.Code=RateCov.Code and Rclass.TOR=RateCov.TOR and Rclass.TOC=TOPRO.TOC and TOPRO.TOPRO=@P_TOPRO  
	Group By RateTab.Code, RateTab.Description, RateTab.Unit, RateTab.NoRefundF
) 
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'TOP_TOICode') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION TOP_TOICode
end
Go
CREATE FUNCTION TOP_TOICode (@p_TOPRO varchar(10), @p_TOI varchar (10))     
RETURNS TABLE  
AS RETURN (  
Select distinct TOI.TOI, TOI.Description, TOI.Description as Remark, PClass.Category
From Rclass, Pclass, TOI, TOPRO
Where TOPRO.TOPRO=@P_TOPRO and Rclass.TOC=TOPRO.TOC and Pclass.TOR=Rclass.TOR and TOI.TOI=PCLASS.TOI and TOI.TOI like @p_TOI
) 
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[pYearSetup]') AND type in (N'U'))
BEGIN
DROP TABLE [dbo].[pYearSetup]
end
GO

CREATE TABLE [dbo].[pYearSetup](
	[Pyear] [smallint] NOT NULL,
	[Description] [varchar](20) NULL,
 CONSTRAINT [i_Pyear] PRIMARY KEY CLUSTERED 
(
	[Pyear] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

insert pYearSetup select '0','0'
go
insert pYearSetup select '1','1'
go
insert pYearSetup select '2','2'
go
insert pYearSetup select '3','3'
go
insert pYearSetup select '4','4'
go
insert pYearSetup select '5','5'
go



IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_Drop_SysUserTypeTOCTOL') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE SP_Drop_SysUserTypeTOCTOL
end
GO


 Create Procedure SP_Drop_SysUserTypeTOCTOL (@BTYPE varchar(10), @Effective smalldatetime,@TOC varchar(10),@TYPE varchar(20),@TOL integer)    
as    
 begin    
  Delete From SysUserTypeTOCTOL  Where (BTYPE = @BTYPE) And (TOC = @TOC) And ([TYPE] = @TYPE) And (Effective=@Effective) And (TOL = @TOL)  ;    
 end 

GO






if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FNtoc_genHtab') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
Drop FUNCTION FNtoc_genHtab
end
go
CREATE FUNCTION FNtoc_genHtab (@P_TOC AS VARCHAR(10))              
RETURNS Table              
AS RETURN (    

SELECT  TOP 1       
TOC.TOC,      
TOC.FLDID1, TOC.FLDTAG1, GENHTAB_1.FLDCRITERIA AS FLDCRITERIA1, 
TOC.FLDID2, TOC.FLDTAG2, GENHTAB_2.FLDCRITERIA AS FLDCRITERIA2, 
TOC.FLDID3, TOC.FLDTAG3, GENHTAB_3.FLDCRITERIA AS FLDCRITERIA3, 
TOC.FLDID4, TOC.FLDTAG4, GENHTAB_4.FLDCRITERIA AS FLDCRITERIA4, 
TOC.FLDID5, TOC.FLDTAG5, GENHTAB_5.FLDCRITERIA AS FLDCRITERIA5,
TOC.FLDID6, TOC.FLDTAG6, GENHTAB_6.FLDCRITERIA AS FLDCRITERIA6,
TOC.FLDID7, TOC.FLDTAG7, GENHTAB_7.FLDCRITERIA AS FLDCRITERIA7, 
TOC.FLDID8, TOC.FLDTAG8, GENHTAB_8.FLDCRITERIA AS FLDCRITERIA8,
TOC.FLDID9, TOC.FLDTAG9, GENHTAB_9.FLDCRITERIA AS FLDCRITERIA9, 
TOC.FLDID10, TOC.FLDTAG10, GENHTAB_10.FLDCRITERIA AS FLDCRITERIA10,
TOC.FLDID11, TOC.FLDTAG11, GENHTAB_11.FLDCRITERIA AS FLDCRITERIA11, 
TOC.FLDID12, TOC.FLDTAG12, GENHTAB_12.FLDCRITERIA AS FLDCRITERIA12,  
TOC.FLDID13, TOC.FLDTAG13, GENHTAB_13.FLDCRITERIA AS FLDCRITERIA13, 
TOC.FLDID14, TOC.FLDTAG14, GENHTAB_14.FLDCRITERIA AS FLDCRITERIA14, 
TOC.FLDID15, TOC.FLDTAG15, GENHTAB_15.FLDCRITERIA AS FLDCRITERIA15
FROM       
TOC       
LEFT OUTER JOIN GENHTAB as GENHTAB_1 ON TOC.FLDID1<>'' AND TOC.FLDID1 = GENHTAB_1.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_2 ON TOC.FLDID2<>'' AND TOC.FLDID2 = GENHTAB_2.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_3 ON TOC.FLDID3<>'' AND TOC.FLDID3 = GENHTAB_3.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_4 ON TOC.FLDID4<>'' AND TOC.FLDID4 = GENHTAB_4.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_5 ON TOC.FLDID5<>'' AND TOC.FLDID5 = GENHTAB_5.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_6 ON TOC.FLDID6<>'' AND TOC.FLDID6 = GENHTAB_6.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_7 ON TOC.FLDID7<>'' AND TOC.FLDID7 = GENHTAB_7.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_8 ON TOC.FLDID8<>'' AND TOC.FLDID8 = GENHTAB_8.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_9 ON TOC.FLDID9<>'' AND TOC.FLDID9 = GENHTAB_9.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_10 ON TOC.FLDID10<>'' AND TOC.FLDID10 = GENHTAB_10.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_11 ON TOC.FLDID11<>'' AND TOC.FLDID11 = GENHTAB_11.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_12 ON TOC.FLDID12<>'' AND TOC.FLDID12 = GENHTAB_12.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_13 ON TOC.FLDID13<>'' AND TOC.FLDID13 = GENHTAB_13.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_14 ON TOC.FLDID14<>'' AND TOC.FLDID14 = GENHTAB_14.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_15 ON TOC.FLDID15<>'' AND TOC.FLDID15 = GENHTAB_15.FLDID       
WHERE  TOC.TOC = @P_TOC 
)
go
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_Search_SysUserTypeTOCTOL') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
Drop Procedure SP_Search_SysUserTypeTOCTOL
end
go
CREATE Procedure SP_Search_SysUserTypeTOCTOL(@BTYPE varchar(10), @Effective smalldatetime,@TOC varchar(10),@TYPE varchar(20))        
as        
Select top 1 CAST(0 As Bit) ProcessFlag,R. *, 
F.FLDTAG1,F.FLDCRITERIA1,F.FLDTAG2,F.FLDCRITERIA2,F.FLDTAG3,F.FLDCRITERIA3,F.FLDTAG4,F.FLDCRITERIA4,F.FLDTAG5,F.FLDCRITERIA5,F.FLDTAG6,F.FLDCRITERIA6,F.FLDTAG7,
F.FLDCRITERIA7,F.FLDTAG8,F.FLDCRITERIA8,F.FLDTAG9,F.FLDCRITERIA9,F.FLDTAG10,F.FLDCRITERIA10,F.FLDTAG11,F.FLDCRITERIA11,F.FLDTAG12,F.FLDCRITERIA12,F.FLDTAG13,
F.FLDCRITERIA13,F.FLDTAG14,F.FLDCRITERIA14,F.FLDTAG15,F.FLDCRITERIA15
from SysUserTypeTOCTOL R, FNtoc_genHtab(@TOC) F
Where R.TOC=F.TOC And (R.BTYPE like @BTYPE + '%') And (R.TOC like @TOC + '%' ) And (R.TYPE like @TYPE + '%' ) And (R.Effective=@Effective) 

go





  insert into PatchVersioning
select '54.28 Update Script WebSetup Standarisasi before 2020 v.1',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='54.27 Update Script - VAT_IN_PROCESS DAN VAT_OUT_PROCESS'
Select @CurrSCript='54.28 Update Script WebSetup Standarisasi before 2020 v.1'


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





