IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NotApplyPayorScheduleOnRefundF' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	NotApplyPayorScheduleOnRefundF bit NULL
DECLARE @v sql_variant 
SET @v = N'Not Use Payor Schedule for Effective Cancellation (0 : Use Payor Schedule, 1 : Not)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'NotApplyPayorScheduleOnRefundF'
end
GO


DROP FUNCTION fn_Get_Effective_Cancellation_By_Payor_Schedule
GO
CREATE FUNCTION fn_Get_Effective_Cancellation_By_Payor_Schedule(@P_ANO Integer, @P_PDate smalldatetime, @P_EDate smalldatetime)              
RETURNS smalldatetime
AS               
BEGIN              
	Select @P_PDate=coalesce(
	(
	Select Top 1 Case When InstLDate<@P_Edate then InstlDate else @P_Edate end 
	from Acceptance A
	Inner Join Payor_Schedule P on (P.ANO=A.ANO)
	Inner Join TOC on (TOC.TOC=A.TOC and TOC.NotApplyPayorScheduleOnRefundF=0)
	Where A.ANO=@P_ANO and P.InstDate<=@P_PDate and P.InstLDate>@P_PDate order by P.InstDate Desc
	),@P_PDate)
	Return @P_PDate

END  


go


 insert into PatchVersioning
select '248 Update Script - 10 May 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='248 Update Script - 10 May 2022'


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



