DROP Procedure AUTORECEIPTPAYMENT_PROCESS
GO
CREATE Procedure AUTORECEIPTPAYMENT_PROCESS(@P_PDate as smalldatetime, @P_PID as int=0, @P_GPID as int=0)                                        
as                               

if @P_PID<>0
Begin
	Select Top 1 @P_GPID=GPID
	from RPBucket with (ReadCommitted)
	where Status='R' 
	and PID=@P_PID

	if @P_GPID is null
		Select @P_GPID=0

	if @P_GPID<>0	
		Select @P_PID=0
End

Select * 
from RPBucket with (ReadCommitted)
where Status='R' 
and ((@P_PID<>0 and PID = @P_PID) or (@P_GPID<>0 and GPID=@P_GPID) or (@P_PID=0 and @P_GPID=0 and GPID=0))
and not exists (
	select R.GPID
	from RPBucket R
	Where R.GPID<>0 and R.GPID=RPBucket.GPID 
	and exists (Select Top 1 ObjName from SysLockedObject Where ObjName='RPBUCKET'+cast(R.PID as varchar(10)) and Status='L')
	)
and not exists (Select Top 1 ObjName from SysLockedObject Where ObjName='RPBUCKET'+cast(RPBucket.PID as varchar(10)) and Status='L')
order by GPID, PID 

GO



 insert into PatchVersioning	
select '765 Update Script - AutoReceiptPayment_Process',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='765 Update Script - AutoReceiptPayment_Process'


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


