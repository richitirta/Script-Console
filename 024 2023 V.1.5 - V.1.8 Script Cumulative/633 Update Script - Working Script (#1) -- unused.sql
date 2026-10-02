


Select 
I1.GroupID, 
I2.GroupType, 
I2.DataID, 
I1.A_PolicyNo, 
I1.Type, 
I1.AssumptionID, 
I1.Method, 
I1.Onerous, 
I1.Branch, 
I1.Segment, 
I1.ISType, 
I1.TOC, 
I1.CGroup, 
I1.Currency, 
I1.Year, 
I1.Month, 
I1.NumMonths, 
I1.Inception, 
I1.Expiry, 
I1.Effective, 
datediff(Month, I1.Inception, I1.Effective)+1 as EffMonth,
I1.BookDate, 
I1.Init_disc_Rate, 
I1.Inflation_Rate_1, 
I2.Premium_Expected, 
I2.Commission_Expected,
I2.Premium_Expected_1,
I2.Premium_Expected_2,
I2.Premium_Expected_3,
I2.Premium_Expected_4,
I2.Premium_Expected_5,
I2.Commission_Expected_1,
I2.Commission_Expected_2,
I2.Commission_Expected_3,
I2.Commission_Expected_4,
I2.Commission_Expected_5,
I2.Premium_Actual, 
I2.Commission_Actual
from IFRS_initial I1
Inner Join IFRS_Initial_Detail I2 on (I2.DataID=I1.DataID)
Cross Apply (
	Select Distinct I.GroupID, I.GroupType 
	from IFRS_Movement I 
	Where I.GroupID=I1.GroupID and I.GroupType=I2.GroupType and I.ProcessDate Between '03/01/2023' and '02/29/2024') I
Order By I1.GroupID, I2.GroupType, I2.DataID

GO
--Property
IFRS_SHOW_MOVEMENT 44,'I','03/01/2023','02/29/2024'
GO
IFRS_SHOW_MOVEMENT 47,'I','03/01/2023','02/29/2024'
GO
IFRS_SHOW_MOVEMENT 49,'I','03/01/2023','02/29/2024'

GO
--Property
IFRS_SHOW_MOVEMENT_JOURNAL 44,'I','03/01/2023','02/29/2024'
GO
IFRS_SHOW_MOVEMENT_JOURNAL 47,'I','03/01/2023','02/29/2024'
GO
IFRS_SHOW_MOVEMENT_JOURNAL 49,'I','03/01/2023','02/29/2024'



--Group Detail (44)
GO
ifrs_show_calculation 44,'I',1
GO
ifrs_show_Initial 76,'I',1
GO
ifrs_show_Initial 81,'I',1
GO
ifrs_show_Initial 82,'I',1
GO
ifrs_show_Initial 83,'I',1
GO
ifrs_show_Initial 84,'I',1

GO

IFRS_Get_Assumption '3/1/2023',24,'A01-01',0,'INDIVIDUAL','I','0109','N/A','IDR','I'
GO



--Group Detail (44)
GO
ifrs_show_calculation 47,'I',1
GO
ifrs_show_Initial 79,'I',1
GO
ifrs_show_Initial 86,'I',1
GO


IFRS_Get_Assumption '3/20/2023',24,'A01-01',0,'INDIVIDUAL','I','0118','N/A','IDR','I'
GO





--Group Detail (49)
GO
ifrs_show_calculation 49,'I',1
GO
ifrs_show_Initial 85,'I',1

GO

IFRS_Get_Assumption '09/30/2023',24,'A01-01',0,'INDIVIDUAL','I','0117','N/A','IDR','I'
GO

--Cancellation
ifrs_show_calculation 47,'I',2
Select * from IFRS_Movement Where GroupID=47 and GRoupType='I'
go



 insert into PatchVersioning	
select '633 Update Script - Working Script (#1)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='633 Update Script - Working Script (#1)'


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



