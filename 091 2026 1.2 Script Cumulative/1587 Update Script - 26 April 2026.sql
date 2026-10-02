/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'MINRATE' AND Object_ID = Object_ID(N'TOPRO_RATECON'))

BEGIN
ALTER TABLE dbo.TOPRO_RATECON ADD
	MINRATE float(53) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RATE' AND Object_ID = Object_ID(N'TOPRO_RATECON'))

BEGIN
ALTER TABLE dbo.TOPRO_RATECON ADD
	RATE float(53) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LOADING' AND Object_ID = Object_ID(N'TOPRO_RATECON'))

BEGIN
ALTER TABLE dbo.TOPRO_RATECON ADD
	LOADING float(53) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PML' AND Object_ID = Object_ID(N'TOPRO_RATECON'))

BEGIN
ALTER TABLE dbo.TOPRO_RATECON ADD
	PML float(53) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'unit' AND Object_ID = Object_ID(N'TOPRO_RATECON'))

BEGIN
ALTER TABLE dbo.TOPRO_RATECON ADD
	unit varchar(1) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'MAXRATE' AND Object_ID = Object_ID(N'TOPRO_RATECON'))

BEGIN
ALTER TABLE dbo.TOPRO_RATECON ADD
	MAXRATE float(53) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TEXCESS' AND Object_ID = Object_ID(N'TOPRO_RATECON'))

BEGIN
ALTER TABLE dbo.TOPRO_RATECON ADD
	TEXCESS int NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PCTLOSS' AND Object_ID = Object_ID(N'TOPRO_RATECON'))

BEGIN
ALTER TABLE dbo.TOPRO_RATECON ADD
	PCTLOSS float(53) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ProgressiveF' AND Object_ID = Object_ID(N'TOPRO_RATECON'))

BEGIN
ALTER TABLE dbo.TOPRO_RATECON ADD
	ProgressiveF bit NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PCALC' AND Object_ID = Object_ID(N'TOPRO_RATECON'))

BEGIN
ALTER TABLE dbo.TOPRO_RATECON ADD
	PCALC varchar(1) NULL
END
GO
DECLARE @v sql_variant 
SET @v = N'% Minimum Rate '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOPRO_RATECON', N'COLUMN', N'MINRATE'
GO
DECLARE @v sql_variant 
SET @v = N'Premium Rate'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOPRO_RATECON', N'COLUMN', N'RATE'
GO
DECLARE @v sql_variant 
SET @v = N'Rate Loading'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOPRO_RATECON', N'COLUMN', N'LOADING'
GO
DECLARE @v sql_variant 
SET @v = N'Probable Max. Loss (in %)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOPRO_RATECON', N'COLUMN', N'PML'
GO
DECLARE @v sql_variant 
SET @v = N'% Maximum Rate '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOPRO_RATECON', N'COLUMN', N'MAXRATE'
GO
DECLARE @v sql_variant 
SET @v = N'Time Excess (In Day(s))'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOPRO_RATECON', N'COLUMN', N'TEXCESS'
GO
DECLARE @v sql_variant 
SET @v = N'% Indemnity Loss'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOPRO_RATECON', N'COLUMN', N'PCTLOSS'
GO
DECLARE @v sql_variant 
SET @v = N'Progressive Rate Flag (0 : No, 1 : yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOPRO_RATECON', N'COLUMN', N'ProgressiveF'
GO
DECLARE @v sql_variant 
SET @v = N'Premium Calculation Method (''Full, ''P''rorata,'''' default)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOPRO_RATECON', N'COLUMN', N'PCALC'
GO


DROP FUNCTION fn_TOPRORateCon
GO

CREATE FUNCTION fn_TOPRORateCon(@P_ANO as int,@P_Code as varchar(20),@P_TSI as Float, @P_SDate as smalldatetime)       
RETURNS Table       
AS RETURN (       
Select Top 1 *
From
(
	SELECT Top 1 cast(0 as Bit) as ProgressiveF, RateTab.Code, RateCon.AllowedF, 
	case 
	When RateCon.minPeriod=0 and RateCon.MaxPeriod=0 then RateCon.MinRate 
	Else 
		case 
		When RateTab.SPeriod=1 Then Cover.Prorata/(RateCon.MaxPeriod-RateCon.MinPeriod+1)*RateCon.MinRate
		else Case When TOC.PTerm=0 Then 12 else TOC.PTerm End /(RateCon.MaxPeriod-RateCon.MinPeriod+1)*RateCon.MinRate
		End
	End as MinRate,
	case 
	When RateCon.minPeriod=0 and RateCon.MaxPeriod=0 then RateCon.MaxRate
	Else 
		case 
		When RateTab.SPeriod=1 Then Cover.Prorata/(RateCon.MaxPeriod-RateCon.MinPeriod+1)*RateCon.MaxRate
		else Case When TOC.PTerm=0 Then 12 else TOC.PTerm End/(RateCon.MaxPeriod-RateCon.MinPeriod+1)*RateCon.MaxRate
		End
	End as MaxRate,
	RateCon.PML, RateCon.TExcess, RateTab.RateLoadingF,       
	Case When coalesce(RateCon.Loading,0)=0 Then 100 else RateCon.Loading end as Loading,       
	Case When coalesce(RateCon.PCTLOSS,0)=0 Then 100 else RateCon.PCTLOSS end as PCTLOSS,       
	--Rate Always in Percent       
	Case       
	When coalesce(AInfoDet.Rate,0)<>0 then coalesce(AInfoDet.Rate,0)  
	When RateCon.Unit='F' then (Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)<>0 Then RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)*100 else 0 end)       
	When RateCon.Unit='M' then RateCon.Rate/10       
	else RateCon.Rate end as Rate,       
	RateCon.MaxTSI as MaxTSI,
	RateCon.PCalc     
	From Acceptance       
	LEFT JOIN Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO and Acceptance.EMethod='S')
	INNER JOIN TOC on (TOC.TOC=Acceptance.TOC)
	INNER JOIN AInfo on (AInfo.ANO=Acceptance.ANO)       
	INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)       
	INNER JOIN RateTab ON (RateTab.Code=@P_Code) 
	Left Join AInfoDet on (AInfoDet.ANO=Acceptance.LANO and AInfoDet.FLDID=Acceptance.FLDID and AInfoDet.ValueID=Acceptance.ValueID and AInfoDet.Status='A')  
	INNER JOIN TOPRO_RateCon RateCon on (    
	 RateCon.TOPRO=Acceptance.TOPRO and RateCon.Code=RateTab.Code 
	 And ((Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MinTSI or RateCon.MinTSI=0) and ((Case When @P_TSI=0 Then 1 Else @P_TSI End)<=RateCon.MaxTSI or RateCon.MaxTSI=0)     
	 And RateCon.ALLOWEDF=1
	 And RateCon.ProgressiveF=0
	 And (
	 (
	 RateTab.SPeriod=0 
	 and 
	 (    
		 (
			ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When Acceptance.ExclusiveF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,Acceptance.EDate) else Acceptance.EDate end,Cover.Prorata,12,Case When Cover.PPeriod in (0,1,2) Then 2 Else Cover.PPeriod End)*12)
			-
			Case 
			When Acceptance.EMethod='S' then
				ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When pAcceptance.ExclusiveF=0 and pAcceptance.STime<pAcceptance.ETime Then dateadd(day,1,pAcceptance.EDate) else pAcceptance.EDate end,Cover.Prorata,12,Case When Cover.PPeriod in (0,1,2) Then 2 Else Cover.PPeriod End)*12)
			else 0
			end
			>=RateCon.MinPeriod
		 )
	 or RateCon.MinPeriod=0
	 )                               
	 And 
	 (    
		 (
			ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When Acceptance.ExclusiveF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,Acceptance.EDate) else Acceptance.EDate end,Cover.Prorata,12,Case When Cover.PPeriod in (0,1,2) Then 2 Else Cover.PPeriod End)*12)
			-
			Case 
			When Acceptance.EMethod='S' then
				ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When pAcceptance.ExclusiveF=0 and pAcceptance.STime<pAcceptance.ETime Then dateadd(day,1,pAcceptance.EDate) else pAcceptance.EDate end,Cover.Prorata,12,Case When Cover.PPeriod in (0,1,2) Then 2 Else Cover.PPeriod End)*12)
			else 0
			end
			<=RateCon.MaxPeriod
		 )     
	 or RateCon.MaxPeriod=0
	 )
	 ) OR
	 (
	 RateTab.SPeriod=1 
	 and 
		(
			(

				dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When Acceptance.ExclusiveF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,Acceptance.EDate) else Acceptance.EDate end,1,0,1)
				-
				Case 
				When Acceptance.EMethod='S' then
					dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When pAcceptance.ExclusiveF=0 and pAcceptance.STime<pAcceptance.ETime Then dateadd(day,1,pAcceptance.EDate) else pAcceptance.EDate end,1,0,1)
				else 0
				end
				>=RateCon.MinPeriod
			) 
		or RateCon.MinPeriod=0
		)
	 And 
		(
			(
				dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When Acceptance.ExclusiveF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,Acceptance.EDate) else Acceptance.EDate end,1,0,1)
				-
				Case 
				When Acceptance.EMethod='S' then
					dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When pAcceptance.ExclusiveF=0 and pAcceptance.STime<pAcceptance.ETime Then dateadd(day,1,pAcceptance.EDate) else pAcceptance.EDate end,1,0,1)
				else 0
				end
				<=RateCon.MaxPeriod
			) 
		or RateCon.MaxPeriod=0
		)
	 ) 
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

	SELECT 
	cast(1 as Bit) as ProgressiveF,
	RateTab.Code, 
	Cast(Max(Cast(RateCon.AllowedF as Int)) as Bit) as AllowedF, 
	sum(Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI+1 Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI+1 end*RateCon.MinRate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)) as MinRate,
	sum(Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI+1 Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI+1 end*RateCon.MaxRate/(Case When @P_TSI=0 Then 1 Else @P_TSI End)) as MaxRate,
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
		Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI+1 Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI+1 end*RateCon.Rate/10/(Case When @P_TSI=0 Then 1 Else @P_TSI End) 
	else Case When (Case When @P_TSI=0 Then 1 Else @P_TSI End)>=RateCon.MaxTSI Then RateCon.MaxTSI-RateCon.MinTSI+1 Else (Case When @P_TSI=0 Then 1 Else @P_TSI End)-RateCon.MinTSI+1 end*RateCon.Rate/(Case When @P_TSI=0 Then 1 Else @P_TSI End) end 
	)as Rate,
	Max(RateCon.MaxTSI) as MaxTSI,
	Max(RateCon.PCalc) as PCalc
	From Acceptance       
	LEFT JOIN Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO and Acceptance.EMethod='S')
	INNER JOIN TOC on (TOC.TOC=Acceptance.TOC)
	INNER JOIN AInfo on (AInfo.ANO=Acceptance.ANO)       
	INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)       
	INNER JOIN RateTab ON (RateTab.Code=@P_Code)       
	INNER JOIN TOPRO_RateCon RateCon on (    
	 RateCon.TOPRO=Acceptance.TOPRO and RateCon.Code=RateTab.Code 
	 And ((Case When @P_TSI=0 Then 1 Else @P_TSI End) Between RateCon.MinTSI and RateCon.MaxTSI or RateCon.MaxTSI<=(Case When @P_TSI=0 Then 1 Else @P_TSI End))
	 And RateCon.ALLOWEDF=1
	 And RateCon.ProgressiveF=1
	 And (
	 (
	 RateTab.SPeriod=0 
	 and 
	 (    
		 (
			ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When Acceptance.ExclusiveF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,Acceptance.EDate) else Acceptance.EDate end,Cover.Prorata,12,Case When Cover.PPeriod in (0,1,2) Then 2 Else Cover.PPeriod End)*12)
			-
			Case 
			When Acceptance.EMethod='S' then
				ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When pAcceptance.ExclusiveF=0 and pAcceptance.STime<pAcceptance.ETime Then dateadd(day,1,pAcceptance.EDate) else pAcceptance.EDate end,Cover.Prorata,12,Case When Cover.PPeriod in (0,1,2) Then 2 Else Cover.PPeriod End)*12)
			else 0
			end
			>=RateCon.MinPeriod
		 )
	 or RateCon.MinPeriod=0
	 )                               
	 And 
	 (    
		 (
			ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When Acceptance.ExclusiveF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,Acceptance.EDate) else Acceptance.EDate end,Cover.Prorata,12,Case When Cover.PPeriod in (0,1,2) Then 2 Else Cover.PPeriod End)*12)
			-
			Case 
			When Acceptance.EMethod='S' then
				ceiling(dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When pAcceptance.ExclusiveF=0 and pAcceptance.STime<pAcceptance.ETime Then dateadd(day,1,pAcceptance.EDate) else pAcceptance.EDate end,Cover.Prorata,12,Case When Cover.PPeriod in (0,1,2) Then 2 Else Cover.PPeriod End)*12)
			else 0
			end
			<=RateCon.MaxPeriod
		 )     
	 or RateCon.MaxPeriod=0
	 )
	 ) OR
	 (
	 RateTab.SPeriod=1 
	 and 
		(
			(
				dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When Acceptance.ExclusiveF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,Acceptance.EDate) else Acceptance.EDate end,1,0,1)
				-
				Case 
				When Acceptance.EMethod='S' then
					dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When pAcceptance.ExclusiveF=0 and pAcceptance.STime<pAcceptance.ETime Then dateadd(day,1,pAcceptance.EDate) else pAcceptance.EDate end,1,0,1)
				else 0
				end
				>=RateCon.MinPeriod
			) 
		or RateCon.MinPeriod=0
		)
	 And 
		(
			(
				dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When Acceptance.ExclusiveF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,Acceptance.EDate) else Acceptance.EDate end,1,0,1)
				-
				Case 
				When Acceptance.EMethod='S' then
					dbo.fn_Premium_Calc_Prorata(@P_SDate, Case When pAcceptance.ExclusiveF=0 and pAcceptance.STime<pAcceptance.ETime Then dateadd(day,1,pAcceptance.EDate) else pAcceptance.EDate end,1,0,1)
				else 0
				end
				<=RateCon.MaxPeriod
			) 
		or RateCon.MaxPeriod=0
		)
	 ) 
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



insert into PatchVersioning
select '1587 Update Script - 26 April 2026.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1587 Update Script - 26 April 2026.sql'


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

GO 


