IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QACCBSDET_1') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QACCBSDET_1
end
GO
CREATE Procedure QACCBSDET_1(@P_ANO integer, @P_ID varchar(255), @P_BSType as varchar(10), @P_CODE varchar(255),@P_PERIOD int)
as
SELECT A.ANO, A.ID, A.BSType, A.Code, A.Period, A.Fee, A.FeeAmount/
Case When AC.ANO=AC.LANO then 1 Else (Select Count(Distinct cast(R.SDATE as varchar(11))+' '+Cast(Case When Ac.AType='A' Then 0 Else I.Adjustable End as varchar(3))) from ICalc R, Acceptance Ac, ICover I Where I.INO=R.INO and Ac.ANO=R.ANO and R.ANO=@P_ANO and R.Code=@P_Code and (A.Period=0 or cast(DateDiff(month, AC.SDATE, R.SDATE) as Integer) / 12 + 1=@P_Period)) End as FeeAmount, A.Discount
From Acceptance AC
Inner Join AccBSDet A on (A.ANO=AC.ANO And A.ID=@P_ID And A.BSType=@P_BSType And A.CODE=@P_CODE AND (A.PERIOD=0 or A.PERIOD=@P_PERIOD))
WHERE AC.ANO=@P_ANO 

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QAACCBSDET_1') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
drop procedure QAACCBSDET_1
end
go
CREATE Procedure QAACCBSDET_1(@P_ANO integer, @P_ID varchar(255), @P_BSType as varchar(10), @P_CODE varchar(255),@P_PERIOD int)
as
SELECT A.ANO, A.ID, A.BSType, A.Code, A.Period, A.Fee, A.FeeAmount/
Case When AC.ANO=AC.LANO then 1 Else (Select Count(Distinct cast(R.SDATE as varchar(11))+' '+Cast(Case When Ac.AType='A' Then 0 Else I.Adjustable End as varchar(3))) from ICalc R, Acceptance Ac, ICover I Where I.INO=R.INO and Ac.ANO=R.ANO and R.ANO=@P_ANO and R.Code=@P_Code and (A.Period=0 or cast(DateDiff(month, AC.SDATE, R.SDATE) as Integer) / 12 + 1=@P_Period)) End as FeeAmount, A.Discount
From Acceptance AC
Inner Join AAccBSDet A on (A.ANO=AC.ANO And A.ID=@P_ID And A.BSType=@P_BSType And A.CODE=@P_CODE AND (A.PERIOD=0 or A.PERIOD=@P_PERIOD))
WHERE AC.ANO=@P_ANO 

go



  insert into PatchVersioning
select '54.4 Update Script - Patch 2019 (7)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='54.3 Update Script - Patch 2019 (6)'
Select @CurrSCript='54.4 Update Script - Patch 2019 (7)'


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


