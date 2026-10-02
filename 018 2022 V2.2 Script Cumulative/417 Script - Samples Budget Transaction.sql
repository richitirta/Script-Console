
Declare @Year int
Declare @Branch varchar(10)
Declare @CT varchar(10)
Declare @AsAt smalldatetime

Select @Year=2022
Select @Branch='10'
Select @CT='10'
Select @Asat='08/31/2022'

Select B1.Hist_No, B1.Year, B1.Branch, B1.CT, B1.GID, B3.Description as GIDDesc, B2.Account_Dr as Account, B2.Description, B1.Total as Nominal, B1.Last_Opr, B1.Last_Update
from Budget_Entry_Hist B1 
Left Join Budget_AccountDetail B2 on (B2.GID=B1.GID and B2.ID=B1.ID)
Left Join Budget_AccountGroup B3 on (B3.GID=B2.GID)
Where B1.Year=@Year
and B1.Branch=@Branch
and B1.CT=@CT
and B1.Last_Update<=@AsAt
Order by B1.Hist_No
go


 insert into PatchVersioning
select '417 Script - Samples Budget Transaction',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='417 Script - Samples Budget Transaction'


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



