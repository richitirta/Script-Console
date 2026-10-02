DROP procedure PI061 
GO
CREATE procedure PI061 (@P_ANO as integer)    
as    
select Ac.ORDERNO as ORDERNO, Ac.shortdesc as ShortDesc, Ac.Description as Description
from AccCla Ac 
where Ac.ANO = @P_ANO 

Union All 

select mAc.ORDERNO as ORDERNO, mAc.shortdesc as ShortDesc, mAc.Description as Description
from Acceptance A
Inner join Cover C on (C.CNO=a.CNO)
Inner Join Acceptance mA on (mA.ANO=mA.LANO and mA.ANO=a.lANO and c.OpenFlag=0)
Inner join AccCla mAc on (mAc.ANO=mA.ANO)
Left join AccCla Ac on (Ac.ANO=A.ANO and Ac.OrderNo=mAc.OrderNO and Ac.Section=mAc.Section)
where A.ANO = @P_ANO and coalesce(Ac.OrderNo,'')=''
order by ORDERNO

GO    
    
DROP procedure PI062
GO
CREATE procedure PI062 (@P_ANO as integer)    
as    
select Ac.ORDERNO as ORDERNO, Ac.shortdesc as ShortDesc, Ac.Description as Description
from AccCon Ac 
where Ac.ANO = @P_ANO 

Union All 

select mAc.ORDERNO as ORDERNO, mAc.shortdesc as ShortDesc, mAc.Description as Description
from Acceptance A
Inner join Cover C on (C.CNO=a.CNO)
Inner Join Acceptance mA on (mA.ANO=mA.LANO and mA.ANO=a.lANO and c.OpenFlag=0)
Inner join AccCon mAc on (mAc.ANO=mA.ANO)
Left join AccCon Ac on (Ac.ANO=A.ANO and Ac.OrderNo=mAc.OrderNO and Ac.Section=mAc.Section)
where A.ANO = @P_ANO and coalesce(Ac.OrderNo,'')=''
order by ORDERNO 
GO

DROP procedure PI063    
GO    
CREATE procedure PI063 (@P_ANO as integer)    
as    
select Ac.ORDERNO as ORDERNO, Ac.shortdesc as ShortDesc, Ac.Description as Description
from AccEx Ac 
where Ac.ANO = @P_ANO 

Union All 

select mAc.ORDERNO as ORDERNO, mAc.shortdesc as ShortDesc, mAc.Description as Description
from Acceptance A
Inner join Cover C on (C.CNO=a.CNO)
Inner Join Acceptance mA on (mA.ANO=mA.LANO and mA.ANO=a.lANO and c.OpenFlag=0)
Inner join AccEx mAc on (mAc.ANO=mA.ANO)
Left join AccEx Ac on (Ac.ANO=A.ANO and Ac.OrderNo=mAc.OrderNO and Ac.Section=mAc.Section)
where A.ANO = @P_ANO and coalesce(Ac.OrderNo,'')=''
order by ORDERNO
GO


  insert into PatchVersioning
select '1316 Update Script - Patch 2025 (17)',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1316 Update Script - Patch 2025 (17)'


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
