IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TaxTypeFH' AND Object_ID = Object_ID(N'SysTab'))
BEGIN
ALTER TABLE dbo.SysTab ADD
	TaxTypeFH varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Tax Type for Treaty Fund With Held (see TaxType Table)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'TaxTypeFH'
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IRate' AND Object_ID = Object_ID(N'AdmLink'))
BEGIN
ALTER TABLE dbo.AdmLink ADD
	IRate float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Interest Rate (see Fund Held)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AdmLink', N'COLUMN', N'IRate'
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FundHeldF' AND Object_ID = Object_ID(N'REINSURANCE'))
BEGIN
ALTER TABLE dbo.REINSURANCE ADD
	FundHeldF bit NULL
DECLARE @v sql_variant 
SET @v = N'Fund With Held (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'REINSURANCE', N'COLUMN', N'FundHeldF'
end
GO



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ADMLOG') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[ADMLOG](
	[TYPE] [varchar](10) NOT NULL,
	[DATE] [smalldatetime] NOT NULL,
	[DB_USER] [varchar](50) NULL,
	[PDATE] [smalldatetime] NULL,
	[PTIME] [varchar](8) NULL,
	[PEDATE] [smalldatetime] NULL,
 CONSTRAINT [I_ADMLOG] PRIMARY KEY NONCLUSTERED 
(
	[TYPE] ASC,
	[DATE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING OFF
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Process Type (Ex. ''Fund Held''' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ADMLOG', @level2type=N'COLUMN',@level2name=N'TYPE'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Booking Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ADMLOG', @level2type=N'COLUMN',@level2name=N'DATE'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Processing User' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ADMLOG', @level2type=N'COLUMN',@level2name=N'DB_USER'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Processing Date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ADMLOG', @level2type=N'COLUMN',@level2name=N'PDATE'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Processing Time' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ADMLOG', @level2type=N'COLUMN',@level2name=N'PTIME'
end
GO


IF NOT EXISTS(SELECT * FROM SysProcess WHERE ProcName='PROCESS_ADMLINK')
BEGIN
insert into sysprocess(ProcName,ProcGroup,TimeOut,StartTime,EndTime,Schedule,StartDay,EndDay,FreqDay,ScheduleF,UserID,Last_Opr,Last_Update, ExecCheckF, MainProcName,RepetitiveF)
Select 'PROCESS_ADMLINK','FA',	0,'00:00','24:00',	0,	1,	31,	0,	0,	'CARE','care',cast(convert(varchar(10), getdate(),1) as smalldatetime),1,'PROCESS_ADMLINK',0
end
go

IF NOT EXISTS(SELECT * FROM SysProcess WHERE ProcName='DELETE_ADMLINK')
BEGIN
insert into sysprocess(ProcName,ProcGroup,TimeOut,StartTime,EndTime,Schedule,StartDay,EndDay,FreqDay,ScheduleF,UserID,Last_Opr,Last_Update, ExecCheckF, MainProcName,RepetitiveF)
Select 'DELETE_ADMLINK','FA',	0,'00:00','24:00',	0,	1,	31,	0,	0,	'CARE','care',cast(convert(varchar(10), getdate(),1) as smalldatetime),1,'DELETE_ADMLINK',0
end
GO


if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_Get_Prorata24') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN
drop function fn_Get_Prorata24
end
go
CREATE FUNCTION fn_Get_Prorata24(@P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_PDate as smalldatetime)                    

RETURNS Float      

AS                     

BEGIN                    

 Declare @P_Denominator as integer                  

 Declare @P_Nominator as integer                  

 Declare @P_Prorata as float      

         

 if datediff(day,@P_PDate, @P_EDate)>0

 Begin      

  --Prorata 24

  Select @P_Denominator = datediff(month, @P_SDate, @P_EDate)*2       

  Select @P_Nominator = datediff(month, Case When datediff(day,@P_SDate, @P_PDate)>=0 Then (Case When datediff(day,@P_EDate, @P_PDate)<=0 Then @P_PDate Else @P_EDate end) else @P_SDate end , @P_EDate)*2-1       



  Select @P_Prorata=cast(@P_Nominator as float)/cast(@P_Denominator as float)      

 end      

 else       

 Begin      

 Select @P_Prorata=0      

 end      

 return(@P_Prorata)      

End 

go

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'TREATY_FUNDHELD_PROCESS') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN
DROP FUNCTION TREATY_FUNDHELD_PROCESS
end
GO
CREATE FUNCTION TREATY_FUNDHELD_PROCESS(@P_Type varchar(2),@P_Date smalldatetime, @P_PEDate smalldatetime,@P_EDate smalldatetime, @IRate as Float)            
RETURNS TABLE            
AS RETURN(            

Select A.DocNo, A.RefNo, A.Branch, A.CT, A.Remarks, A.ID, A.A_ID, A.Source, A.ISType, A.Segment, 
A.Type, A.Code, A.Currency, A.A_PolicyNo, A.A_MO, A.RefType, A.AccountNo, A.BankAccount, A.BankName,
A.Bank, A.BankBranch, A.A_Sdate, A.A_EDate, A.Statement, A.ASource, A.MSCode, A.BizMapID ,

--Fund Held
case when A.Date>@P_PEDate and A.Date<=@P_EDate then -A.Amount_1 else 0 end
+
--Fund Held Previous
Case When @P_PEDate>=A.A_SDate then A.Amount_1* dbo.fn_Get_Prorata24(A.A_Sdate, A.A_EDate, @P_PEDate) else A.Amount_1 end
-
--Fund Held Current
Case When @P_EDate>=A.A_SDate then A.Amount_1* dbo.fn_Get_Prorata24(A.A_Sdate, A.A_EDate, @P_EDate) else A.Amount_1 end as Amount_4,

--Fund_Held_Int
Case When @P_EDate>=A.A_SDate then A.Amount_1* dbo.fn_Get_Prorata24(A.A_Sdate, A.A_EDate, @P_EDate) else A.Amount_1 end*@IRate/12/100 as Amount_15,

--Fund Held WHTax
-dbo.RoundCCY(Case When @P_EDate>=A.A_SDate then A.Amount_1* dbo.fn_Get_Prorata24(A.A_Sdate, A.A_EDate, @P_EDate) else A.Amount_1 end*@IRate/12/100*TaxType.TaxRate/100,A.Currency) as Amount_14,

Case When @P_EDate>=A.A_SDate then A.Amount_1* dbo.fn_Get_Prorata24(A.A_Sdate, A.A_EDate, @P_EDate) else A.Amount_1 end*@IRate/12/100 as PNominal_Tax,
@IRate as IRate

from Admlink A
Inner Join SysTab on (1=1)
Inner Join TaxType on (TaxType.TaxType=SysTab.TaxTypeFH)
inner join RPart on (RPart.DocNo=A.RefNo and RPart.ID=A.ID)
Inner Join Reinsurance on (Reinsurance.RNO=RPart.RNO and Reinsurance.FundHeldF=1)
Where A.Type in ('QS','QP','S1','S2','S3') 
and A.Date<=@P_EDate
and 
(
(A_SDate>@P_PEDate and A_SDate<=@P_EDate) or
(@P_EDate Between A_Sdate and A_Edate) or
(A_EDate>@P_PEDate and A_EDate<=@P_EDate)
)
)            

GO




 insert into PatchVersioning
select '221 Update Script - 13 April 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='221 Update Script - 13 April 2022'


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




go



	
