--26 agst 2017 : PENAMBAHAN SETTING MAIN RISK DI COVERAGE
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TOR' AND Object_ID = Object_ID(N'RATETAB'))
BEGIN
ALTER TABLE RATETAB ADD	TOR varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Main Type Of Risk Where The Additional Rate Code is related'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RATETAB', N'COLUMN', N'TOR'
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QMissing_Risk') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN
DROP procedure QMissing_Risk
END
GO
CREATE  procedure QMissing_Risk(@P_ANO integer) 
as 
Select Top 1 A1.ANO 
from RCover R1, Acceptance A1 
Where A1.ANO=@P_ANO and A1.ANO=R1.ANO 
and (R1.Category='A' or not ((R1.SDate=A1.SDate or  R1.SDate=A1.PDate) and R1.EDate=A1.EDate)) 
and Not Exists
( 
Select Top 1 R2.ANO 
from RCover R2 
Where R2.Category='M' and R2.ANO=R1.ANO and not (R2.Code=R1.Code and R2.Sdate=R1.Sdate) 
and 
( 
(R2.Sdate<=R1.Edate and R2.Edate>=R1.Edate) or (R2.Sdate<=R1.Sdate and R2.Edate>=R1.Sdate) or 
(R1.Sdate<=R2.Sdate and R1.Edate>=R2.Sdate) or (R1.Sdate<=R2.Edate and R1.Edate>=R2.Edate) 
) 
) 

Union All
 
Select Top 1 A1.ANO 
from RCover R1, Acceptance A1, RateTab R3
Where A1.ANO=@P_ANO and A1.ANO=R1.ANO 
and R1.Category='A' and R3.Code=R1.Code and R3.TOR<>''
and Not Exists
(
Select Top 1 R2.ANO 
from RCover R2, RateTab R4, RateCOV R5
Where R2.Category='M' and R2.ANO=R1.ANO and R4.Code=R2.Code and R5.Code=R4.Code and R5.TOR=R3.TOR
and 
( 
(R2.Sdate<=R1.Edate and R2.Edate>=R1.Edate) or (R2.Sdate<=R1.Sdate and R2.Edate>=R1.Sdate) or 
(R1.Sdate<=R2.Sdate and R1.Edate>=R2.Sdate) or (R1.Sdate<=R2.Edate and R1.Edate>=R2.Edate) 
)
)
go

--Penambahan  Source pada Top Rate
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PCTLOSS_Source' AND Object_ID = Object_ID(N'TOP_Rate'))
BEGIN
ALTER TABLE TOP_Rate ADD PCTLOSS_Source varchar(10) NULL

DECLARE @v sql_variant 
SET @v = N'Indemnity Percentage Source Data'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Rate', N'COLUMN', N'PCTLOSS_Source'
END
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_CL_COLTAB') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
drop Function FL_CL_COLTAB
END
GO
Create Function FL_CL_COLTAB (@P_COL as varchar(10), @P_PolicyNo as varchar(20), @P_CERTIFICATENO AS varchar(20))    
Returns Table  
As Return  
(  
SELECT COLTAB.COL, COLTAB.description    
From Acceptance, RCALC, COL, COLTAB    
WHERE ACCEPTANCE.ANO=RCalc.ANO And RCalc.TOR=COL.TOR AND COLTAB.COL=COL.COL AND    
ACCEPTANCE.POLICYNO=@P_POLICYNO And ACCEPTANCE.CERTIFICATENO=@P_CERTIFICATENO And (COL.COL LIKE @P_COL+'%' or  COLtab.DESCRIPTION  like @P_COL+'%')
)
go

--30 agst 2017 : PENAMBAHAN PCTLOSS DAN PREMIUM ADDITION DI SCHEME INDEMNITY
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PCTLOSS' AND Object_ID = Object_ID(N'Scheme_Indemnity_TSI'))
BEGIN
ALTER TABLE Scheme_Indemnity_TSI ADD PCTLOSS float(53) NULL
DECLARE @v sql_variant 
SET @v = N'% Indemnity (PCTLOSS)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Indemnity_TSI', N'COLUMN', N'PCTLOSS'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PADDITION' AND Object_ID = Object_ID(N'Scheme_Indemnity_TSI'))
BEGIN
ALTER TABLE Scheme_Indemnity_TSI ADD PADDITION float(53) NULL
DECLARE @v sql_variant 
SET @v = N'% PREMIUM ADDITION'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Indemnity_TSI', N'COLUMN', N'PADDITION'
END

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QScheme_Verify_3') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN
DROP Procedure QScheme_Verify_3 
END
GO

CREATE Procedure QScheme_Verify_3 
@P_Coverage as varchar(255), 
@P_Code as varchar(10), 
@p_LMonth as float, 
@p_UMonth as float, 
@p_SchemeNo as varchar (10), 
@p_Description as varchar (255), 
@P_TSI as float=0 
as 
 
Declare @p_ClassNo int 
Declare @P_SIInceptionF Bit 
Select Top 1 @p_ClassNo=S2.ClassNo, @P_SIInceptionF=S1.SIInceptionF 
from scheme_Master S1, Scheme_Class S2 
Where S1.SchemeNo=@P_SchemeNo and S2.SchemeNo=S1.SchemeNo and @P_Description like S2.Description 
Order by S2.Priority Desc 
 
Select 
S1.Lower, 
S1.NoRefundF, 
S1.RateLoadingF, 
Coalesce(SI1.HoldF, S1.HoldF) as HoldF, 
Max(S1.Upper)as Upper, 
Max(coalesce(SI1.PCTLoss, S1.PCTLoss)) as PCTLoss, 
Max(coalesce(SI1.PAddition, S1.PAddition)) as PAddition, 
Max(coalesce(SI1.Discount, S1.Discount)) as Discount, 
Max(coalesce(SI1.RateLower, S1.RateLower)) as RateLower, 
Max(coalesce(SI1.Rate,S1.Rate)) as Rate 
From 
Scheme_Indemnity S1 
Left Join Scheme_Indemnity_TSI SI1 
On (SI1.ClassNo=S1.ClassNo and SI1.Coverage=S1.Coverage and SI1.Code=S1.Code and SI1.Lower=S1.Lower and SI1.Upper=S1.Upper 
and (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else coalesce(SI1.PCTLoss, S1.PCTLoss)/100 end>=SI1.MinTSI or SI1.MinTSI=0) and (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else coalesce(SI1.PCTLoss, S1.PCTLoss)/100 end<=SI1.MaxTSI or SI1.MaxTSI=0)) 
Where 
S1.ClassNo=@P_ClassNo 
and S1.Coverage=@P_Coverage 
and S1.Code=@P_Code 
and 
( 
(S1.Lower>=@p_LMonth and S1.Upper<=@p_UMonth) 
or 
(S1.Lower<=@p_LMonth and S1.Upper>=@p_UMonth) 
or 
(S1.Lower<=@p_LMonth and S1.Upper>=@p_LMonth) 
or 
(S1.Lower<=@p_UMonth and S1.Upper>=@p_UMonth) 
) 
and NOT EXISTS (Select S3.ClassNo from Scheme_Indemnity S3 Where S3.ClassNo=S1.ClassNo and S3.Coverage=S1.Coverage and S3.Code=S1.Code and S1.Lower=S3.Lower and S1.Upper>S3.Upper and S3.Lower<=@P_LMonth and S3.Upper>=@P_UMonth) 
and NOT EXISTS (Select S3.ClassNo from Scheme_Indemnity S3 Where S3.ClassNo=S1.ClassNo and S3.Coverage=S1.Coverage and S3.Code=S1.Code and S1.Lower=S3.Lower and S1.Upper<S3.Upper and S3.Lower>=@P_LMonth and S3.Upper<=@P_UMonth) 
Group By S1.Lower, S1.NoRefundF, S1.RateLoadingF, Coalesce(SI1.HoldF, S1.HoldF) 
Order By S1.Lower, S1.NoRefundF, S1.RateLoadingF, Coalesce(SI1.HoldF, S1.HoldF) 
GO

--31 agst 2017 : Download external data
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SysLogDownload') AND type in (N'U'))
BEGIN
CREATE TABLE SysLogDownload(
	FILENAME varchar(255) NOT NULL,
	DOCTYPE varchar(50) NOT NULL,
	DOCNO varchar(50) NOT NULL,
	PDATE smalldatetime NULL,
	PTIME varchar(10) NULL,
	USERID varchar(50) NULL,
 CONSTRAINT I_SysLogDownload PRIMARY KEY NONCLUSTERED 
(
	DOCTYPE ASC,
	DOCNO ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DOCUMENT TO DOWNLOAD (''REQUEST'', ''PVOUCHER'')' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysLogDownload', @level2type=N'COLUMN',@level2name=N'DOCTYPE'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Document No. (Request No/Voucher No)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysLogDownload', @level2type=N'COLUMN',@level2name=N'DOCNO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Processing Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysLogDownload', @level2type=N'COLUMN',@level2name=N'PDATE'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Processing Time' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysLogDownload', @level2type=N'COLUMN',@level2name=N'PTIME'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Processing User ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysLogDownload', @level2type=N'COLUMN',@level2name=N'USERID'
END
GO



--VERSIONING
insert into versioning
select '2017 V.2.10.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='19 Script Komulatif Konsol 2.9'
Select @CurrSCript='20 Script Komulatif Konsol 2.10'


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