--5 APRL 2017 : TUNING SCRIPT FINANCE 
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='i_AdmLink_BADMNO' AND object_id = OBJECT_ID('admlink'))
BEGIN
drop index admlink.i_AdmLink_BADMNO
END
go
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='SL_Request' AND CONSTRAINT_NAME='FK_SL_Request_Request')
begin
Alter Table SL_Request drop constraint FK_SL_Request_Request
END
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='RequestPic' AND CONSTRAINT_NAME='FK_RequestPic_Request')
begin
Alter Table RequestPic drop constraint FK_RequestPic_Request
END
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='RDOCLIST' AND CONSTRAINT_NAME='FK_RDOCLIST_Request')
begin
Alter Table RDOCLIST drop constraint FK_RDOCLIST_Request
END
GO
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_Request' AND object_id = OBJECT_ID('Request'))
BEGIN
Alter Table Request drop Constraint I_Request
END
GO
IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_Request' AND object_id = OBJECT_ID('Request'))
Create Unique Index I_Request on Request(Request)
GO
ALTER TABLE SL_Request  WITH NOCHECK ADD  CONSTRAINT FK_SL_Request_Request FOREIGN KEY(Request)
REFERENCES Request (Request)
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE RequestPic  WITH CHECK ADD  CONSTRAINT FK_RequestPic_Request FOREIGN KEY(Request)
REFERENCES Request (Request)
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE RDOCLIST WITH CHECK ADD  CONSTRAINT FK_RDOCLIST_Request FOREIGN KEY(Request)
REFERENCES Request (Request)
ON UPDATE CASCADE
ON DELETE CASCADE
GO

--Perbaikan F2 sertifikat di claim tidak bisa
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_CL_CERTIFICATENO') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION FL_CL_CERTIFICATENO END
GO
CREATE FUNCTION FL_CL_CERTIFICATENO(@P_USERID varchar(50), @P_PolicyNo varchar(20),@P_CertificateNo varchar(10))          
RETURNS TABLE          
AS RETURN          
(Select A.CertificateNo, A.AName, A.SDate, A.EDate, A.PDate, A.PPDate, A.NCDate, A.ExtPeriod          
from Acceptance A Inner Join Cover C on (C.CNO=A.CNO)        
Where A.ATYPE Not In ('A','C') And A.ASTATUS NOT IN ('W','T') And C.CStatus<>'C' And A.PDATE<>A.PPDATE And A.ANO<>A.LANO And A.LANO <> -1
and A.PolicyNo=@P_PolicyNo and A.CertificateNo Like @P_CertificateNo+'%'        
and A.Branch in (Select S.Branch from SysUserBranch S Where S.ID=@P_UserID)       
and C.TOC in (Select S.TOC from SysUserTOC S Where S.ID=@P_UserID)        
)
go

-- Perbaikan Payor Discount untuk alternate tidak terhitung nilainya
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Payor_Discount') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION Payor_Discount END
GO
CREATE Function Payor_Discount(@P_ANO as int,@P_Code as varchar(10),@P_Period as int=0)          
RETURNS @DISCOUNT TABLE (GDISCOUNT Float, PDISCOUNT Float, DISCOUNT Float)  
AS          
BEGIN          
 Declare @PDiscount Float          
 Declare @GDiscount Float      
 Declare @NDiscount Float
Declare @SLoading Float    
 Declare @TDiscount Float          
 Declare @RegNo varchar(20)    
 Declare @AStatus varchar(1)    
 Declare @LANO int
Declare @OANO int

Select @GDiscount=0
Select @PDiscount=0
Select @NDiscount=0
Select @SLoading=0
                 
 Select @RegNo=RegNo, @AStatus=AStatus, @LANO=LANO, @OANO=OANO from Acceptance Where ANO=@P_ANO    

if @LANO=-1
BEGIN
         Select @PDiscount=Payor.Discount, @GDiscount=Payor.GDiscount, @NDiscount=Payor.NDiscount, @SLoading=Payor.SLoading, @TDiscount=PayorDet.Discount
         from Acceptance 
         Left Join Payor on (Payor.ANO=Acceptance.ANO)
         Left Join PayorDet on (PayorDet.ANO=Payor.ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period))               
         Where Acceptance.ANO=@P_ANO  
 END
ELSE
BEGIN 
 
         -- Payor Discount from Alternate Discount          
        Select @PDiscount=APayor.Discount from APayor Where ANO=@P_ANO          
        if @PDiscount is null          
        BEGIN           
             if @RegNo='' or @AStatus in ('W','T')   
             Begin       
               Select @PDiscount=Payor.Discount, @GDiscount=Payor.GDiscount, @NDiscount=Payor.NDiscount, @SLoading=Payor.SLoading, @TDiscount=PayorDet.Discount
               from Acceptance 
               Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)
               Left Join Payor on (Payor.ANO=mAcceptance.ANO)
               Left Join PayorDet on (PayorDet.ANO=Payor.ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period))           
               Where Acceptance.ANO=@P_ANO 
           end    
           else    
           Begin    
               Select @PDiscount=Payor.Discount, @GDiscount=Payor.GDiscount, @NDiscount=Payor.NDiscount, @SLoading=Payor.SLoading, @TDiscount=PayorDet.Discount
               from Acceptance 
               Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
               Left Join Payor on (Payor.ANO=mAcceptance.ANO)
               Left Join PayorDet on (PayorDet.ANO=Payor.ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period))           
               Where Acceptance.ANO=@P_ANO 
           end    
             if @TDiscount is not null          
                    Select @PDiscount=@TDiscount                  
        End          
        Else          
        BEGIN          
             Select @TDiscount=PayorDet.Discount from APayorDet PayorDet Where PayorDet.ANO=@P_ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period)          
             if @TDiscount is not null          
                    Select @PDiscount=@TDiscount          
        End          
 END
                        
 insert into @Discount(GDiscount, PDiscount, Discount) Select @GDiscount, @PDiscount, (1 - (1 - @GDiscount / 100) * (1 - @NDiscount / 100) * (1 - @PDiscount / 100) * (1 + @SLoading / 100))*100
Return  
End          


go

--Perbaikan Bugs Scheme Verify untuk divide by zero jika Setting Progressive tanpa Bannd TSI
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QScheme_Verify_6') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QScheme_Verify_6  END 
GO

CREATE Procedure QScheme_Verify_6 
@p_Coverage as varchar (255), 
@p_Interest as varchar (20), 
@p_TSI as float, 
@P_NOfYears as float, 
@p_SchemeNo as varchar (10), 
@p_Description as varchar (255) 
as 
Select Top 1 *
from 
(
	Select Top 1 
	S1.Code, 
	(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end) as SI, 
	Case       
	When S1.Unit='F' then Case When (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)<>0 Then S1.Rate/(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)*100 else 0 end
	When S1.Unit='M' then S1.Rate/10
	else S1.Rate end
	as Rate,
	S1.Unit, S1.Category, S1.Portion, S1.TOI, S1.NOTDECRF, S1.RateBasedID, 
	TOI.Description as TOIDesc, 
	TOI.Adjustable, 
	RateTab.Description as RateDesc 
	from 
	RateTab, 
	TOI, 
	Scheme_Additional S1, 
	Scheme_Class S2 
	Where 
	RateTab.Code=S1.Code 
	and TOI.TOI=S1.TOI 
	and (S1.Coverage='' or S1.Coverage=@P_Coverage) 
	and S1.Interest=@p_Interest 
	and (S1.Lower<=(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end) or S1.Lower=0) 
	and (S1.Upper>=(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end) or S1.Upper=0) 
	and (S1.NOfYearsL<=@p_NOfYears or S1.NOfYearsL=0) 
	and (S1.NOfYearsU>=@p_NOfYears or S1.NOfYearsU=0) 
	and S2.ClassNo=S1.ClassNo 
	and S2.SchemeNo=@p_SchemeNO 
	and @p_Description Like S2.Description 
	and S2.Priority=coalesce((Select Top 1 S3.Priority from Scheme_Class S3 Where S3.SchemeNo=@P_SchemeNo and @P_Description like S3.Description Order By S3.Priority Desc),0) 
	and S1.ProgressiveF=0

	Union All

	Select Top 1 
	S1.Code, 
	Max((Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)) as SI, 
	sum(Case       
	When S1.Unit='F' then Case When (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)<>0 Then S1.Rate/
	(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)*100 else 0 end
	When S1.Unit='M' then 
		Case When (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)>=S1.Upper Then S1.Upper-S1.Lower Else (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)-S1.Lower end*S1.Rate/10/(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)
	else 
	    Case When (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)>=S1.Upper Then S1.Upper-S1.Lower Else (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)-S1.Lower end*S1.Rate/(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end) end 
	) as Rate,
	Max(S1.Unit) as Unit, Max(S1.Category) as Category, Max(S1.Portion) as Portion, 
	Max(S1.TOI) as TOI, 
	cast(Max(Cast(S1.NOTDECRF as Int)) as Bit) as NOTDECRF, 
	Max(S1.RateBasedID) as RateBasedID, 
	Max(TOI.Description) as TOIDesc, 
	cast(Max(Cast(TOI.Adjustable as Int)) as Bit) as Adjustable, 
	Max(RateTab.Description) as RateDesc 
	from 
	RateTab, 
	TOI, 
	Scheme_Additional S1, 
	Scheme_Class S2 
	Where 
	RateTab.Code=S1.Code 
	and TOI.TOI=S1.TOI 
	and (S1.Coverage='' or S1.Coverage=@P_Coverage) 
	and S1.Interest=@p_Interest 
	and ((Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end) Between S1.Lower and S1.Upper or (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)>=S1.Upper)
	and (S1.NOfYearsL<=@p_NOfYears or S1.NOfYearsL=0) 
	and (S1.NOfYearsU>=@p_NOfYears or S1.NOfYearsU=0) 
	and S2.ClassNo=S1.ClassNo 
	and S2.SchemeNo=@p_SchemeNO 
	and @p_Description Like S2.Description 
	and S2.Priority=coalesce((Select Top 1 S3.Priority from Scheme_Class S3 Where S3.SchemeNo=@P_SchemeNo and @P_Description like S3.Description Order By S3.Priority Desc),0) 
	and S1.ProgressiveF=1 and (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)<>0
	Group BY S1.Code
) R

GO


if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_RateCon') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION fn_RateCon
end
GO
CREATE FUNCTION fn_RateCon(@P_ANO as int,@P_Code as varchar(20),@P_TSI as Float=0)       
RETURNS Table       
AS RETURN (       
Select Top 1 *
From
(
	SELECT Top 1 RateTab.Code, RateCon.AllowedF, RateCon.MinRate, RateCon.MaxRate, RateCon.PML, RateCon.TExcess, RateTab.RateLoadingF,       
	Case When coalesce(RateCon.Loading,0)=0 Then 100 else RateCon.Loading end as Loading,       
	Case When coalesce(RateCon.PCTLOSS,0)=0 Then 100 else RateCon.PCTLOSS end as PCTLOSS,       
	--Rate Always in Percent       
	Case       
	When RateCon.Unit='F' then (Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)<>0 Then RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)*100 else 0 end)       
	When RateCon.Unit='M' then RateCon.Rate/10       
	else RateCon.Rate end as Rate       
	From Acceptance       
	INNER JOIN AInfo on (AInfo.ANO=Acceptance.ANO)       
	INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)       
	INNER JOIN RateTab ON (RateTab.Effective<=Acceptance.SDate and (@P_Code='%' or RateTab.Code Like @P_Code or RateTab.PCode Like @P_Code))       
	INNER JOIN RateCon on (    
	 RateTab.TOC=Cover.TOC and RateCon.Code=RateTab.Code And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
	 And RateCon.ALLOWEDF=1
	 And RateCon.ProgressiveF=0
	 And (
	 (RateTab.SPeriod=0 and (    
	 (datediff(month, acceptance.sdate, acceptance.edate)>=RateCon.MinPeriod)     
	 or (datediff(month, acceptance.sdate, acceptance.edate)=RateCon.MinPeriod-1 and day(acceptance.sdate)<day(acceptance.edate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, acceptance.sdate, acceptance.edate)<RateCon.MaxPeriod)     
	 or (datediff(month, acceptance.sdate, acceptance.edate)=RateCon.MaxPeriod and day(acceptance.sdate)>=day(acceptance.edate))     
	 or RateCon.MaxPeriod=0)) OR
	(RateTab.SPeriod=1 
	 and ((datediff(day, acceptance.sdate, acceptance.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, acceptance.sdate, acceptance.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
	) 
	WHERE Acceptance.ANO=@P_ANO       
	And (coalesce(RateCon.ValueID1,'')='' or AINFO.VALUEID1 =RateCon.ValueID1)       
	And (coalesce(RateCon.ValueID2,'')='' or AINFO.VALUEID2 =RateCon.ValueID2)       
	And (coalesce(RateCon.ValueID3,'')='' or AINFO.VALUEID3 =RateCon.ValueID3)       
	And (coalesce(RateCon.ValueID4,'')='' or AINFO.VALUEID4 =RateCon.ValueID4)       
	And (coalesce(RateCon.ValueID5,'')='' or AINFO.VALUEID5 =RateCon.ValueID5)       
	And (coalesce(RateCon.ValueID6,'')='' or AINFO.VALUEID6 =RateCon.ValueID6)       
	And (coalesce(RateCon.ValueID7,'')='' or AINFO.VALUEID7 =RateCon.ValueID7)       
	And (coalesce(RateCon.ValueID8,'')='' or AINFO.VALUEID8 =RateCon.ValueID8)       
	And (coalesce(RateCon.ValueID9,'')='' or AINFO.VALUEID9 =RateCon.ValueID9)       
	And (coalesce(RateCon.ValueID10,'')='' or AINFO.VALUEID10 =RateCon.ValueID10)       
	And (coalesce(RateCon.ValueID11,'')='' or AINFO.VALUEID11 =RateCon.ValueID11)       
	And (coalesce(RateCon.ValueID12,'')='' or AINFO.VALUEID12 =RateCon.ValueID12)       
	And (coalesce(RateCon.ValueID13,'')='' or AINFO.VALUEID13 =RateCon.ValueID13)       
	And (coalesce(RateCon.ValueID14,'')='' or AINFO.VALUEID14 =RateCon.ValueID14)       
	And (coalesce(RateCon.ValueID15,'')='' or AINFO.VALUEID15 =RateCon.ValueID15)       
	Order by       
	RateTab.Effective Desc,       
	len(coalesce(RateCon.ValueID1,'')) Desc,       
	len(coalesce(RateCon.ValueID2,'')) Desc,       
	len(coalesce(RateCon.ValueID3,'')) Desc,       
	len(coalesce(RateCon.ValueID4,'')) Desc,       
	len(coalesce(RateCon.ValueID5,'')) Desc,       
	len(coalesce(RateCon.ValueID6,'')) Desc,       
	len(coalesce(RateCon.ValueID7,'')) Desc,       
	len(coalesce(RateCon.ValueID8,'')) Desc,       
	len(coalesce(RateCon.ValueID9,'')) Desc,       
	len(coalesce(RateCon.ValueID10,'')) Desc,       
	len(coalesce(RateCon.ValueID11,'')) Desc,       
	len(coalesce(RateCon.ValueID12,'')) Desc,       
	len(coalesce(RateCon.ValueID13,'')) Desc,       
	len(coalesce(RateCon.ValueID14,'')) Desc,       
	len(coalesce(RateCon.ValueID15,'')) Desc       

	UNION ALL

	SELECT RateTab.Code, 
	Cast(Max(Cast(RateCon.AllowedF as Int)) as Bit) as AllowedF, 
	sum(Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.MinRate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)) as MinRate,
	sum(Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.MaxRate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)) as MaxRate,
	Max(RateCon.PML) as PML, 
	Max(RateCon.TExcess) as TExcess, 
	cast(Max(cast(RateTab.RateLoadingF as Int)) as Bit) as RateLoadingF,       
	Max(Case When coalesce(RateCon.Loading,0)=0 Then 100 else RateCon.Loading end) as Loading,       
	Max(Case When coalesce(RateCon.PCTLOSS,0)=0 Then 100 else RateCon.PCTLOSS end) as PCTLOSS,       
	--Rate Always in Percent       
	sum(
	Case       
	When RateCon.Unit='F' then (Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)<>0 Then RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)*100 else 0 end)       
	When RateCon.Unit='M' then 
		Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.Rate/10/(Case When @P_TSI=0 Then 1 Else @P_TSI End) 
	else Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI end*RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End) end 
	)as Rate       
	From Acceptance       
	INNER JOIN AInfo on (AInfo.ANO=Acceptance.ANO)       
	INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)       
	INNER JOIN RateTab ON (RateTab.Effective<=Acceptance.SDate and (@P_Code='%' or RateTab.Code Like @P_Code or RateTab.PCode Like @P_Code))       
	INNER JOIN RateCon on (    
	 RateTab.TOC=Cover.TOC and RateCon.Code=RateTab.Code 
	 And ((Case When @P_TSI=0 Then 1 Else @P_TSI End) Between RateCon.MinTSI and RateCon.MaxTSI or RateCon.MaxTSI<=(Case When @P_TSI=0 Then 1 Else @P_TSI End))
	 And RateCon.ALLOWEDF=1
	 And RateCon.ProgressiveF=1
	 And (
	 (RateTab.SPeriod=0 and (    
	 (datediff(month, acceptance.sdate, acceptance.edate)>=RateCon.MinPeriod)     
	 or (datediff(month, acceptance.sdate, acceptance.edate)=RateCon.MinPeriod-1 and day(acceptance.sdate)<day(acceptance.edate))     
	 or RateCon.MinPeriod=0)                               
	 And (    
	 (datediff(month, acceptance.sdate, acceptance.edate)<RateCon.MaxPeriod)     
	 or (datediff(month, acceptance.sdate, acceptance.edate)=RateCon.MaxPeriod and day(acceptance.sdate)>=day(acceptance.edate))     
	 or RateCon.MaxPeriod=0)) OR
	(RateTab.SPeriod=1 
	 and ((datediff(day, acceptance.sdate, acceptance.edate)>=RateCon.MinPeriod) or RateCon.MinPeriod=0)
	 And ((datediff(day, acceptance.sdate, acceptance.edate)<=RateCon.MaxPeriod) or RateCon.MaxPeriod=0))
	 )     
	) 
	WHERE Acceptance.ANO=@P_ANO       
	And (coalesce(RateCon.ValueID1,'')='' or AINFO.VALUEID1 =RateCon.ValueID1)       
	And (coalesce(RateCon.ValueID2,'')='' or AINFO.VALUEID2 =RateCon.ValueID2)       
	And (coalesce(RateCon.ValueID3,'')='' or AINFO.VALUEID3 =RateCon.ValueID3)       
	And (coalesce(RateCon.ValueID4,'')='' or AINFO.VALUEID4 =RateCon.ValueID4)       
	And (coalesce(RateCon.ValueID5,'')='' or AINFO.VALUEID5 =RateCon.ValueID5)       
	And (coalesce(RateCon.ValueID6,'')='' or AINFO.VALUEID6 =RateCon.ValueID6)       
	And (coalesce(RateCon.ValueID7,'')='' or AINFO.VALUEID7 =RateCon.ValueID7)       
	And (coalesce(RateCon.ValueID8,'')='' or AINFO.VALUEID8 =RateCon.ValueID8)       
	And (coalesce(RateCon.ValueID9,'')='' or AINFO.VALUEID9 =RateCon.ValueID9)       
	And (coalesce(RateCon.ValueID10,'')='' or AINFO.VALUEID10 =RateCon.ValueID10)       
	And (coalesce(RateCon.ValueID11,'')='' or AINFO.VALUEID11 =RateCon.ValueID11)       
	And (coalesce(RateCon.ValueID12,'')='' or AINFO.VALUEID12 =RateCon.ValueID12)       
	And (coalesce(RateCon.ValueID13,'')='' or AINFO.VALUEID13 =RateCon.ValueID13)       
	And (coalesce(RateCon.ValueID14,'')='' or AINFO.VALUEID14 =RateCon.ValueID14)       
	And (coalesce(RateCon.ValueID15,'')='' or AINFO.VALUEID15 =RateCon.ValueID15)       
	Group By RateTab.Code
) R
)       


GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CLLISTQRY') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION CLLISTQRY 
end
GO
CREATE FUNCTION CLLISTQRY (@VALUE1 AS VARCHAR(255), @VALUE2 AS VARCHAR(255), @VALUE5 AS VARCHAR(255), @VALUE6 AS VARCHAR(255), @VALUE7 AS VARCHAR(255), @VALUE8 AS VARCHAR(255), @VALUE9 AS VARCHAR(255), @VALUE10 AS VARCHAR(255), @VALUE11 AS VARCHAR(255), @VALUE12 AS VARCHAR(255), @VALUE13 AS VARCHAR(255),@VALUE14 as Varchar(10), @VALUE15 as Varchar(10),@VALUE16 as Varchar(255),@VALUE17 as Varchar(255),@VALUE18 as Varchar(255),@VALUE21 as Varchar(255))              
RETURNS Table              
AS RETURN (              
SELECT Claim.CNO,              
  Claim.ClaimNo,              
  Claim.refno,              
  Claim.PolicyNo,              
  Claim.RegDate,              
  Claim.LossDate,              
  Claim.LossPlace,              
  COLTAB.Description,              
  Claim.ClaimantInfo as Claimant,              
  Payment.Name as Payment,              
  Claim.EventName,              
  Claim.CType,              
  Claim.CStatus,              
  Claim.LargeF,              
  Claim.UniqueF,              
  Claim.TBAF_1,              
  Claim.TBAF_2,              
  Claim.SurveyF,              
  CLLOSS.TOI,              
  Claim.Branch,       
  Claim.TOC,              
  Cover.MO,      
  Case When CLInfo.CNO is null then AInfo.ValueID1 else CLInfo.ValueID1 end as ValueID1,              
  Case When CLInfo.CNO is null then AInfo.ValueID2 else CLInfo.ValueID2 end as ValueID2,              
  Case When CLInfo.CNO is null then AInfo.ValueID3 else CLInfo.ValueID3 end as ValueID3,              
  Case When CLInfo.CNO is null then AInfo.ValueID4 else CLInfo.ValueID4 end as ValueID4,              
  Case When CLInfo.CNO is null then AInfo.ValueID5 else CLInfo.ValueID5 end as ValueID5,              
  Case When CLInfo.CNO is null then AInfo.ValueID6 else CLInfo.ValueID6 end as ValueID6,              
  Case When CLInfo.CNO is null then AInfo.ValueID7 else CLInfo.ValueID7 end as ValueID7,              
  Case When CLInfo.CNO is null then AInfo.ValueID8 else CLInfo.ValueID8 end as ValueID8,              
  Case When CLInfo.CNO is null then AInfo.ValueID9 else CLInfo.ValueID9 end as ValueID9,              
  Case When CLInfo.CNO is null then AInfo.ValueID10 else CLInfo.ValueID10 end as ValueID10,              
  Case When CLInfo.CNO is null then AInfo.ValueID11 else CLInfo.ValueID11 end as ValueID11,              
  Case When CLInfo.CNO is null then AInfo.ValueID12 else CLInfo.ValueID12 end as ValueID12,              
  Case When CLInfo.CNO is null then AInfo.ValueID13 else CLInfo.ValueID13 end as ValueID13,              
  Case When CLInfo.CNO is null then AInfo.ValueID14 else CLInfo.ValueID14 end as ValueID14,              
  Case When CLInfo.CNO is null then AInfo.ValueID15 else CLInfo.ValueID15 end as ValueID15,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc1 else CLInfo.ValueDesc1 end as ValueDesc1,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc2 else CLInfo.ValueDesc2 end as ValueDesc2,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc3 else CLInfo.ValueDesc3 end as ValueDesc3,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc4 else CLInfo.ValueDesc4 end as ValueDesc4,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc5 else CLInfo.ValueDesc5 end as ValueDesc5,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc6 else CLInfo.ValueDesc6 end as ValueDesc6,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc7 else CLInfo.ValueDesc7 end as ValueDesc7,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc8 else CLInfo.ValueDesc8 end as ValueDesc8,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc9 else CLInfo.ValueDesc9 end as ValueDesc9,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc10 else CLInfo.ValueDesc10 end as ValueDesc10,            
  Case When CLInfo.CNO is null then AInfo.ValueDesc11 else CLInfo.ValueDesc11 end as ValueDesc11,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc12 else CLInfo.ValueDesc12 end as ValueDesc12,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc13 else CLInfo.ValueDesc13 end as ValueDesc13,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc14 else CLInfo.ValueDesc14 end as ValueDesc14,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc15 else CLInfo.ValueDesc15 end as ValueDesc15,              
  Acceptance.AName , Acceptance.CertificateNo, Acceptance.RefNo as ARefNo            
From CLAIM              
Inner Join Profile Payment on (Payment.ID=Claim.Payment)        
Left Join CLLoss on (CLLoss.CNO=Claim.CNO and Not (@Value13=''))        
Left Join CLInfo on (CLInfo.CNO=CLLoss.CNO and CLInfo.INO=CLLoss.INO and CLInfo.NOC=CLLOSS.NOC)        
Left Join Acceptance on (Acceptance.ANO=Claim.ANO)              
Left Join AInfo on (AInfo.ANO=Acceptance.ANO)              
Left Join Cover on (Cover.CNO=Acceptance.CNO)              
Left Join COLTab on (COLTAB.COL=Claim.COL)              
Where           
  (@Value1='%' or Claim.ClaimNo Like @Value1+'%')    
  And (@Value2='%' or Claim.PolicyNo Like @Value2+'%')    
  And (@Value5='%' or Claim.LossPlace Like @Value5+'%')    
  And (@Value7='%' or Claim.ClaimantInfo Like @Value7+'%' or exists (Select P.ID from CLLoss C, Profile P Where C.CNO=Claim.CNO and P.ID=C.Claimant and P.Name Like @Value7+'%'))      
  And (@Value8='%' or Payment.Name Like @Value8+'%' or exists (Select P.ID from CLLoss C, Profile P Where C.CNO=Claim.CNO and P.ID=C.Payment and P.Name Like @Value8+'%'))    
  And (@Value9='%' or Claim.EventName Like @Value9+'%')     
  And (@Value12='%' or Claim.Refno Like @Value12+'%')    
  And (@Value10='%' or Claim.CType Like @Value10+'%')    
  And (@Value11='%' or Claim.CStatus Like @Value11+'%')    
  And ((Claim.LargeF=1 and @Value14='Large') or @Value14='')              
  And ((Claim.UniqueF=1 and @Value15='Unique') or @Value15='')              
  And (((Claim.TBAF_1=1 or Claim.TBAF_2=1) and @Value17='TBA') or @Value17='')              
  And ((Claim.SurveyF=1 and @Value18='Survey') or @Value18='')              
  And (@Value16='%' or Claim.TOC Like @Value16+'%')   
  And (@Value13='%' or coalesce(CLLOSS.TOI,'') like @Value13+'%')    
  And (@Value6='%' or coalesce(COLTAB.Description,'') Like @Value6+'%')    
  And (@Value21='%' or coalesce(COVER.RefNo,'') Like @Value21+'%')    
)              





GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Payor_Discount') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function Payor_Discount
end
GO
CREATE Function Payor_Discount(@P_ANO as int,@P_Code as varchar(10),@P_Period as int=0)          
RETURNS @DISCOUNT TABLE (GDISCOUNT Float, PDISCOUNT Float, DISCOUNT Float)  
AS          
BEGIN          
 Declare @PDiscount Float          
 Declare @GDiscount Float      
 Declare @NDiscount Float
Declare @SLoading Float    
 Declare @TDiscount Float          
 Declare @RegNo varchar(20)    
 Declare @AStatus varchar(1)    
 Declare @LANO int
Declare @OANO int

Select @GDiscount=0
Select @PDiscount=0
Select @NDiscount=0
Select @SLoading=0
                 
 Select @RegNo=RegNo, @AStatus=AStatus, @LANO=LANO, @OANO=OANO from Acceptance Where ANO=@P_ANO    

if @LANO=-1
BEGIN
         Select @PDiscount=Payor.Discount, @GDiscount=Payor.GDiscount, @NDiscount=Payor.NDiscount, @SLoading=Payor.SLoading, @TDiscount=PayorDet.Discount
         from Acceptance 
         Left Join Payor on (Payor.ANO=Acceptance.ANO)
         Left Join PayorDet on (PayorDet.ANO=Payor.ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period))               
         Where Acceptance.ANO=@P_ANO  
 END
ELSE
BEGIN 
 
         -- Payor Discount from Alternate Discount          
        Select @PDiscount=APayor.Discount from APayor Where ANO=@P_ANO          
        if @PDiscount is null          
        BEGIN           
             if @RegNo='' or @AStatus in ('W','T')   
             Begin       
               Select @PDiscount=Payor.Discount, @GDiscount=Payor.GDiscount, @NDiscount=Payor.NDiscount, @SLoading=Payor.SLoading, @TDiscount=PayorDet.Discount
               from Acceptance 
               Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)
               Left Join Payor on (Payor.ANO=mAcceptance.ANO)
               Left Join PayorDet on (PayorDet.ANO=Payor.ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period))           
               Where Acceptance.ANO=@P_ANO 
           end    
           else    
           Begin    
               Select @PDiscount=Payor.Discount, @GDiscount=Payor.GDiscount, @NDiscount=Payor.NDiscount, @SLoading=Payor.SLoading, @TDiscount=PayorDet.Discount
               from Acceptance 
               Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
               Left Join Payor on (Payor.ANO=mAcceptance.ANO)
               Left Join PayorDet on (PayorDet.ANO=Payor.ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period))           
               Where Acceptance.ANO=@P_ANO 
           end    
             if @TDiscount is not null          
                    Select @PDiscount=@TDiscount                  
        End          
        Else          
        BEGIN          
             Select @TDiscount=PayorDet.Discount from APayorDet PayorDet Where PayorDet.ANO=@P_ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period)          
             if @TDiscount is not null          
                    Select @PDiscount=@TDiscount          
        End          
 END
                        
 insert into @Discount(GDiscount, PDiscount, Discount) Select @GDiscount, @PDiscount, (1 - (1 - @GDiscount / 100) * (1 - @NDiscount / 100) * (1 - @PDiscount / 100) * (1 + @SLoading / 100))*100
Return  
End          


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'View07') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE View07 
end
GO
CREATE PROCEDURE View07 (@p_ANo as integer)                
AS                
SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,   
dbo.fn_Get_UWYear(Acceptance.SDate, Acceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,
sum(                
 case                
  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then accass.Amount                
  else 0                
 end                
) AS Premium,                 
sum(                
 case                 
  when accass.code='C' then accass.Amount                
  else 0                
 end                
) AS Commision,                 
sum(                
 case                 
  when accass.Type not in ('IR','IT','IX') and accass.code='F' then accass.Amount                
  else 0                
 end                
) AS Fee,                 
sum(                
 case                 
  when accass.code='D' then accass.Amount                
  else 0                
 end                
) AS Duty,                 
sum(                
 case                 
  when accass.code='O' then accass.Amount                
  else 0                
 end                
) AS Discount,                 
sum(                
 case                
  when accass.code='I' then accass.Amount                
  else 0                
 end                
) AS OtherIncome,               
sum(                
 case                
  when accass.type in ('IR','IT','IX') and accass.code='F' then -accass.Amount
  when accass.Type in ('DI','IC') and accass.code='U' then -accass.Amount        
  when accass.Type Not in ('DI','IC') and accass.code='U' then accass.Amount        
  else 0                
 End                
) AS Ujroh,              
sum(                
 case                
  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then accass.Amount                
  else 0                
 end                
) AS Tabarru,         
sum(                
 case                
  when (accass.code in ('J')) then accass.Amount                
  else 0                
 end                
) AS Deposit,          
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14),0)<>0 then Admlink.Amount_11*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14) else 0 end)
as Rounding,        
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14),0)<>0 then Admlink.Amount_13*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14) else 0 end)
as VAT,        
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14),0)<>0 then Admlink.Amount_14*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14) else 0 end)
as TAX    
FROM AccAss 
Inner Join Acceptance on (Acceptance.ANO=AccAss.ANO)
Left Join APayor on (APayor.ANO=Acceptance.ANO and Acceptance.LANO<>-1 and Acceptance.ANO<>Acceptance.LANO)                              
Left Join Payor on (Payor.ANO=Acceptance.ANO and Acceptance.LANO=-1)              
Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)
Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo)
Inner Join Profile on (Profile.ID=AccAss.ID)
Left Join Acceptance mAcceptance on (((Acceptance.RegNo<>'' and Acceptance.RegNo=mAcceptance.RegNo) or (Acceptance.RegNo='' and Acceptance.LANO=MAcceptance.ANO)) and MAcceptance.ANO=MAcceptance.LANO and MAcceptance.CNO=Acceptance.CNO)
Left Join Payor MPayor on (MPayor.ANO=mAcceptance.ANO)      
WHERE Acceptance.ANO=@P_ANO        
GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,   
dbo.fn_Get_UWYear(Acceptance.SDate, Acceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) 

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'View07A') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE View07A 
end
GO
CREATE PROCEDURE View07A (@p_ANo as integer)              
AS              
SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,   
dbo.fn_Get_UWYear(MAcceptance.SDate, MAcceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,
sum(                
 case                
  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then accass.Amount                
  else 0                
 end                
) AS Premium,                 
sum(                
 case                 
  when accass.code='C' then accass.Amount                
  else 0                
 end                
) AS Commision,                 
sum(                
 case                 
  when accass.Type not in ('IR','IT','IX') and accass.code='F' then accass.Amount                
  else 0                
 end                
) AS Fee,                 
sum(                
 case                 
  when accass.code='D' then accass.Amount                
  else 0                
 end                
) AS Duty,                 
sum(                
 case                 
  when accass.code='O' then accass.Amount                
  else 0                
 end                
) AS Discount,                 
sum(                
 case                
  when accass.code='I' then accass.Amount                
  else 0                
 end                
) AS OtherIncome,               
sum(                
 case                
  when accass.type in ('IR','IT','IX') and accass.code='F' then -accass.Amount
  when accass.Type in ('DI','IC') and accass.code='U' then -accass.Amount        
  when accass.Type Not in ('DI','IC') and accass.code='U' then accass.Amount        
  else 0                
 End                
) AS Ujroh,              
sum(                
 case                
  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then accass.Amount                
  else 0                
 end                
) AS Tabarru,         
sum(                
 case                
  when (accass.code in ('J')) then accass.Amount                
  else 0                
 end                
) AS Deposit,          
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14),0)<>0 then Admlink.Amount_11*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14) else 0 end)
as Rounding,        
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14),0)<>0 then Admlink.Amount_13*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14) else 0 end)
as VAT,        
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14),0)<>0 then Admlink.Amount_14*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14) else 0 end)
as TAX    
FROM AccAss 
Inner Join Acceptance on (Acceptance.ANO=AccAss.ANO)
Left Join APayor on (APayor.ANO=Acceptance.ANO and Acceptance.LANO<>-1 and Acceptance.ANO<>Acceptance.LANO)                              
Left Join Payor on (Payor.ANO=Acceptance.ANO and Acceptance.LANO=-1)              
Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)
Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo)
Inner Join Profile on (Profile.ID=AccAss.ID)
Inner Join Acceptance mAcceptance on (((Acceptance.RegNo<>'' and Acceptance.RegNo=mAcceptance.RegNo) or (Acceptance.RegNo='' and Acceptance.LANO=MAcceptance.ANO)) and MAcceptance.ANO=MAcceptance.LANO and MAcceptance.CNO=Acceptance.CNO)
Left Join Payor MPayor on (MPayor.ANO=mAcceptance.ANO)      
WHERE MAcceptance.ANO=@P_ANO        
GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,   
dbo.fn_Get_UWYear(MAcceptance.SDate, MAcceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end)


GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QRCESSIONDET') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QRCESSIONDET
end
GO
CREATE Procedure QRCESSIONDET (@P_ANO integer,@P_RID varchar(255), @P_ID varchar(255), @P_CCY varchar(255), @P_SDate DateTime, @P_EDate DateTime, @P_Code varchar(10), @P_AdjustableF bit,@P_TSI as Float=0, @P_ASDate as DateTime=0)              
AS          
Declare @Premium_Treaty_Discount as Float          
Declare @Premium_Discount as Float          
Declare @Premium_Commission as Float          
Declare @Premium_OutGo as Float          
Declare @P_TOC as varchar(10)  
Declare @P_AType as varchar(1)  
Declare @P_ONGROSSNet as int  
Declare @P_RateConF as Bit  
Declare @P_NETRATE as Float  
Declare @P_NETRATEDet as Float  
Declare @P_NOFYEARS as Int  
Declare @P_COMM as Float  
Declare @P_COMMN as Float  
Declare @P_COMMI as Float  
Declare @P_OnMinPremiumF as Bit  
Declare @P_PPCT as Float  
Declare @P_OnNetPremiumF as Bit  
Declare @P_RNO as int  
Declare @P_RType as varchar(10)  
Declare @P_OPFEE as Float  
Declare @P_OPFEEPCT as Float  
Declare @P_FEE as Float  
Declare @P_OANO as int  
Declare @P_COMMPOLICYF as Bit  
Declare @P_PFactor as Float

Select   
@P_ASDate=Case When @P_ASDate=0 Then A.SDate else @P_ASDate end,  
@P_NOFYEARS=datediff(year,A.sdate, A.edate),   
@P_TOC=C.TOC,   
@P_AType=A.AType,   
@P_ONGROSSNET=R.ONGROSSNET,   
@P_RateConF=R3.RateConF,   
@P_NETRATE=R2.NETRATE,  
@P_NETRATEDet=R4.NETRATE,  
@P_COMM=CASE WHEN R3.COMM<>0 Then R3.COMM ELSE R2.COMM END,  
@P_COMMN=CASE WHEN R3.COMMN<>0 Then R3.COMMN ELSE R2.COMMN END,  
@P_COMMI=R2.COMMI,  
@P_OnMinPremiumF=R2.OnMinPremiumF,  
@P_PPCT=R2.PPCT,  
@P_OnNetPremiumF=R2.OnNetPremiumF,   
@P_RNO=R1.RNO,  
@P_RType=R1.RType,  
@P_OANO=A.OANO,  
@P_FEE=R2.FEE,  
@P_COMMPOLICYF=R2.COMMPOLICYF,
@P_PFactor=Case When C.ISType='R' Then (100-I.UJrohCedant)/100*(100+I.UjrohReins)/100 else 1 end  
from Acceptance A, RarrHeader R, Cover C Left Join ISource I on (I.CNO=C.CNO), Reinsurance R1, RPart R2, ReClass R3 Left Join ReClassDet R4 ON (R4.RNO=R3.RNO AND R4.TOC=R3.TOC AND R4.CODE=@P_CODE)  
Where C.CNO=A.CNO and R.ANO=A.ANO and A.ANO=@P_ANO and R1.RID=@P_RID and R2.RNO=R1.RNO and R3.RNO=R1.RNO and R2.ID=@P_ID and R3.TOC=C.TOC  

Select @Premium_Treaty_Discount=dbo.Premium_Treaty_Discount(@P_ANO, @P_Code,cast(datediff(Month,@P_ASDate, @P_SDate) as integer) / 12 + 1)          
Select @Premium_Discount=dbo.premium_discount(@P_ANO, @P_Code, cast(datediff(Month,@P_ASDate, @P_SDate) as integer) / 12 + 1)  
Select @Premium_Commission=dbo.Premium_Commission(@P_ANO, @P_Code, cast(datediff(Month,@P_ASDate, @P_SDate) as integer) / 12 + 1,0)+dbo.Premium_Commission_Vat(@P_ANO, @P_Code, cast(datediff(Month,@P_ASDate, @P_SDate) as integer) / 12 + 1,0)  
Select @Premium_outGo=@Premium_Discount+@Premium_Commission  

Select 
@P_OPFEE=coalesce(Sum(Case When A1.ContributionF=1 Then A1.Amount*100/coalesce(I.Share,100) else 0 end),0),
@P_OPFEEPCT=coalesce(Sum(Case When A1.ContributionF=0 Then A1.Amount*100/coalesce(I.Share,100) else 0 end)/Max(PCalc.Gross)*100,0)
from AccFD A1 
INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID)
INNER Join PCalc on (PCalc.ANO=A1.ANO and PCalc.Currency=A1.Currency)
, Acceptance A2 Left Join ISource I on (I.CNO=A2.CNO) 
Where @P_RType in ('Q','S1','S2','S3') and FDTAB.FDType='O' and A1.Currency=@P_CCY and A1.ANO=A2.ANO and A2.OANO=@P_OANO and A2.ANO<=@P_ANO  

--Apply OP FEE for ONR
Select @Premium_outGo=@Premium_outGo+@P_OPFEEPCT

Select @P_COMM=CASE WHEN @P_COMMPOLICYF=1 and @P_COMM=0 and @P_COMMN=0 Then @Premium_Commission ELSE @P_COMM END  
 
Select              
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Gross_1 else Gross_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Gross_1 else Gross_2 end) end) as Premium,              
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Comm_1 else Comm_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Comm_1 else Comm_2 end) end) as Commission,              
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Disc_1 else Disc_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Disc_1 else Disc_2 end) end) as Discount,  
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Fee_1 else Fee_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Fee_1 else Fee_2 end) end) as Fee              
From          
(select              
Cast(@P_OnMinPremiumF as integer) as OnMinPremiumF,              
coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When @P_COMMN=0 Then @P_COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (100-@Premium_OutGo)/100*(@P_COMMN)/100 else @P_COMM/100 end) end)),0) AS COMM_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When @P_COMMN=0 Then @P_COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (100-@Premium_OutGo)/100*(@P_COMMN)/100 else @P_COMM/100 end) end)),0) AS COMM_2,              

coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end))*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)),0) AS GROSS_1,            
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)),0) AS GROSS_2,              
             
coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When @P_COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When @P_COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_2,  

coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end))*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS FEE_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS FEE_2  
              
FROM ICALC   
INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)  
INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))  
LEFT JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=@P_ID AND RPARTDET.TOR=ICALC.TOR)  
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI) RateCon On (RateCon.Code=ICalc.Code)  
LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (1=1)              
INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))  
INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)  
INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)  
WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE              
AND RPARTDET.TOR IS NULL AND PCALC.GROSS<>0  

Union All              

select              

Cast(@P_OnMinPremiumF as integer) as OnMinPremiumF,              

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-@Premium_OutGo)/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)),0) AS COMM_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-@Premium_OutGo)/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)),0) AS COMM_2,                  
              
coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)),0) AS GROSS_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)),0) AS GROSS_2,              

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_2,  

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS FEE_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS FEE_2  
FROM ICALC   
INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)  
INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))  
INNER JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=@P_ID AND RPARTDET.TOR=ICALC.TOR AND (RPARTDET.NOFYEARS=0 OR RPARTDET.NOFYEARS=@P_NOFYEARS) and RPARTDET.EXCLUDEF=0)  
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI) RateCon On (RateCon.Code=ICalc.Code)  
LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (1=1)              
INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))  
INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)  
INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)  
WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE              
AND PCALC.GROSS<>0  

) R        

go

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_UW_Ded') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION FL_UW_Ded
end
GO
CREATE FUNCTION FL_UW_Ded(@P_ANO as integer, @P_DCode as varchar(255), @P_TOPF as bit=0)  
RETURNS TABLE  
As Return (  
Select Distinct DedTab.*   
From RCOVER  
Inner Join RATECOV on RATECOV.CODE = RCOVER.CODE  
Inner Join DedTab on DeDTab.TOR = RateCov.TOR   
Inner Join TOR on (TOR.TOR=DedTab.TOR)
Inner Join Acceptance on Acceptance.ANO = RCover.ANO  
Left join TOP_Deductible on TOP_Deductible.TOPRO=Acceptance.TOPRO and TOP_Deductible.DCode=DedTab.DCode   
WHERE RCOVER.ANO=@P_ANO and DedTab.ALLOWEDF=1 AND (DedTab.DCode = @P_DCode OR DedTab.Remarks Like @P_DCode +'%')  
and (@P_TOPF=0 or coalesce(TOP_Deductible.TOPRO,'')=Acceptance.TOPRO)   
AND (coalesce(ValueID1L,'') in ('<All>','') OR EXISTS (SELECT TOP 1 * FROM ACCSEARCH WHERE ACCSEARCH.ANO=@P_ANO AND TOR.RFLDID1=ACCSEARCH.FLDID and right(space(15)+ACCSEARCH.VALUEID,15) Between right(space(15)+ValueID1L,15) and (Case When ValueID1U in (''
) then right(space(15)+ValueID1L,15) else right(space(15)+ValueID1U,15) end)))
AND (coalesce(ValueID2L,'') in ('<All>','') OR EXISTS (SELECT TOP 1 * FROM ACCSEARCH WHERE ACCSEARCH.ANO=@P_ANO AND TOR.RFLDID2=ACCSEARCH.FLDID and right(space(15)+ACCSEARCH.VALUEID,15) Between right(space(15)+ValueID2L,15) and (Case When ValueID2U in (''
) then right(space(15)+ValueID2L,15) else right(space(15)+ValueID2U,15) end)))
AND (coalesce(ValueID3L,'') in ('<All>','') OR EXISTS (SELECT TOP 1 * FROM ACCSEARCH WHERE ACCSEARCH.ANO=@P_ANO AND TOR.RFLDID3=ACCSEARCH.FLDID and right(space(15)+ACCSEARCH.VALUEID,15) Between right(space(15)+ValueID3L,15) and (Case When ValueID3U in (''
) then right(space(15)+ValueID3L,15) else right(space(15)+ValueID3U,15) end)))
AND (coalesce(ValueID4L,'') in ('<All>','') OR EXISTS (SELECT TOP 1 * FROM ACCSEARCH WHERE ACCSEARCH.ANO=@P_ANO AND TOR.RFLDID4=ACCSEARCH.FLDID and right(space(15)+ACCSEARCH.VALUEID,15) Between right(space(15)+ValueID4L,15) and (Case When ValueID4U in (''
) then right(space(15)+ValueID4L,15) else right(space(15)+ValueID4U,15) end)))
AND (coalesce(ValueID5L,'') in ('<All>','') OR EXISTS (SELECT TOP 1 * FROM ACCSEARCH WHERE ACCSEARCH.ANO=@P_ANO AND TOR.RFLDID5=ACCSEARCH.FLDID and right(space(15)+ACCSEARCH.VALUEID,15) Between right(space(15)+ValueID5L,15) and (Case When ValueID5U in (''
) then right(space(15)+ValueID5L,15) else right(space(15)+ValueID5U,15) end)))
)  
GO


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='03 Script Komulatif Konsol 1.1'
Select @CurrSCript='04 Script Komulatif Konsol 1.2'


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
