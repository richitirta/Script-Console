DROP Procedure QGet_TotalOfEventClaimApproved
GO
Create Procedure QGet_TotalOfEventClaimApproved(@CNO as Int, @RType as varchar(10), @RID as varchar(20), @OnTreatyShareF as Bit=0)  
AS  
Select 
sum(
	case 
	when @OnTreatyShareF=0 Then CArr.TAmount
	When @RType='Q' Then CArr.QAmount
	When @RType='S1' Then CArr.SP1Amount 
	When @RType='S2' Then CArr.SP2Amount 
	When @RType='S3' Then CArr.SP3Amount 
	else 0 
	end
) as Amount
from Claim C1
Inner join Claim C2 on (C1.EventNo>0 and C2.EventNo=C1.EventNo and C2.OCNO<C1.OCNO)
Inner Join CArrHeader CArr on (CArr.CNO=C2.CNO and CArr.Status='A')
Inner Join RArrHeader RArr on (RArr.ANO=C2.ANO)
Where C1.CNO=@CNO and
(
	(@RType='Q' and RArr.QID=@RID)
	or
	(@RType='S1' and RArr.SP1ID=@RID)
	or
	(@RType='S2' and RArr.SP2ID=@RID)
	or
	(@RType='S3' and RArr.SP3ID=@RID)
)


GO
DROP Procedure QGet_TotalOfEventClaimEstimate
GO
Create Procedure QGet_TotalOfEventClaimEstimate(@CNO as Int, @RType as varchar(10), @RID as varchar(20), @OnTreatyShareF as Bit=0)  
AS      
Select
sum(
	case 
	when @OnTreatyShareF=0 Then CArr.ETAmount
	When @RType='Q' Then CArr.EQAmount
	When @RType='S1' Then CArr.ESP1Amount 
	When @RType='S2' Then CArr.ESP2Amount 
	When @RType='S3' Then CArr.ESP3Amount 
	else 0 
	end
) as Amount
from Claim C1    
Inner join Claim C2 on (C1.EventNo>0 and C2.EventNo=C1.EventNo and C2.OCNO<C1.OCNO)    
Inner Join CArrHeader CArr on (CArr.CNO=C2.CNO and CArr.Status='A')    
Inner Join RArrHeader RArr on (RArr.ANO=C2.ANO)    
Where C1.CNO=@CNO and    
(    
 (@RType='Q' and RArr.QID=@RID)    
 or    
 (@RType='S1' and RArr.SP1ID=@RID)    
 or    
 (@RType='S2' and RArr.SP2ID=@RID)    
 or    
 (@RType='S3' and RArr.SP3ID=@RID)    
) 

GO

insert into PatchVersioning
select '1537 Update Script - patch 2026 (2).sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1537 Update Script - patch 2026 (2).sql'


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