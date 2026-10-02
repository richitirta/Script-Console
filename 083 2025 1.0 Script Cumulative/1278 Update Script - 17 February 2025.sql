IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCheckFacCommission') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QCheckFacCommission
end
GO
CREATE Procedure QCheckFacCommission(@P_ANO as integer, @P_FID as varchar(20))   
as   
Select R.Code , dbo.Premium_MaxOutGo(R.ANO, R.Code,0) as OutGo, 
Case When coalesce(Fd.Comm,0)<>0 Then coalesce(Fd.Comm,0) else F.Comm End+
Case When coalesce(Fd.OComm,0)<>0 Then coalesce(Fd.OComm,0) else F.OComm End+
F.Discount+
F.ACQCOST as FCOMM
from FPart F
Inner join RCover R on (R.ANO=F.ANO)
Cross Apply (
	Select Fd.Comm, Fd.OComm
	from FPartDet Fd 
	Where Fd.ANO=F.ANO and Fd.FID=F.FID and Fd.ID=F.ID and 
	(
		FD.Code=R.Code
		or
		(
		Exists (Select Top 1 RCalc.Code from RCalc Inner Join RateCov on (RateCov.Code=Fd.Code and RateCov.TOR=RCalc.TOR) Where RCalc.ANO=Fd.ANO and RCalc.Code=R.Code)
		and not exists (Select FPartDet.Code from FPartDet Where FPartDet.ANO=FD.ANO and FPartDet.FID=Fd.FID And FPartDet.ID=Fd.ID and FPartDet.Code=R.Code)
		)
	)

) Fd
Where F.ANO=@P_ANO and F.FID=@P_FID

GO
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWFACCOMMLESSTHANOUTGO')
BEGIN
insert into SysForm(FName, Description, FCode, RequestF)
Select 'ALLOWFACCOMMLESSTHANOUTGO', 'ALLOW FACULTATIVE COMMISSION LESS THAN OUTGO', 'ACTIVITIES', 0
end
go


  insert into PatchVersioning
select '1278 Update Script - 17 February 2025',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1278 Update Script - 17 February 2025'


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