Declare @GL_Cash table(Branch varchar(10), Month Int, Year Int, Account Varchar(10), Description varchar(255), Currency varchar(10), Debit Float, Credit Float)

Declare @Mth as integer
Declare @Yr as Integer
Declare @pMth as Integer
Declare @pYr as Integer
Declare @Branch as varchar(10)

--initialize Period
Select @Mth=12
Select @Yr=2022

Declare Branch_Cursor Cursor For Select Branch from Branch Where ShariaF=1
Open Branch_Cursor

FETCH FROM Branch_Cursor into @Branch
WHILE @@FETCH_STATUS = 0  
BEGIN  


	Select @pMth=@Mth
	Select @pYr=@yr

		---loop Until Last Branch Closing Period + 1
	While @pMth+@pYr*12>=@Mth+@Yr*12-12
	Begin		
	
			--insert into @GL_Cash exec Get_GLCash @Branch,@pMth,@pYr
			insert into @GL_Cash select * from Get_GLCash_FUNC(@Branch,@pMth,@pYr)
			-- Previous Month
			if @pMth=1
			Begin
				Select @pYr=@pYr-1
				Select @pMth=12
			End
			Else
			Begin
				Select @pMth=@pMth-1
			End

	END;


FETCH Next FROM Branch_Cursor into @Branch
End  
Close Branch_Cursor  
Deallocate Branch_Cursor

truncate table GL_Cash

Declare @i as int

--Initialiaze

--ReArrange Level
Update A2 Set Level=A1.Level+1 from Account A1, Account A2 Where A1.Account=A2.Parent
Update A2 Set Level=A1.Level+1 from Account A1, Account A2 Where A1.Account=A2.Parent
Update A2 Set Level=A1.Level+1 from Account A1, Account A2 Where A1.Account=A2.Parent
Update A2 Set Level=A1.Level+1 from Account A1, Account A2 Where A1.Account=A2.Parent
Update A2 Set Level=A1.Level+1 from Account A1, Account A2 Where A1.Account=A2.Parent
Update A2 Set Level=A1.Level+1 from Account A1, Account A2 Where A1.Account=A2.Parent
Update A2 Set Level=A1.Level+1 from Account A1, Account A2 Where A1.Account=A2.Parent
Update A2 Set Level=A1.Level+1 from Account A1, Account A2 Where A1.Account=A2.Parent
Update A2 Set Level=A1.Level+1 from Account A1, Account A2 Where A1.Account=A2.Parent
Update A2 Set Level=A1.Level+1 from Account A1, Account A2 Where A1.Account=A2.Parent


--ReArrange Type
Update A1 Set Type=A2.Type from Account A1, Account A2 Where A2.Account=A1.Parent
Update A1 Set Type=A2.Type from Account A1, Account A2 Where A2.Account=A1.Parent
Update A1 Set Type=A2.Type from Account A1, Account A2 Where A2.Account=A1.Parent
Update A1 Set Type=A2.Type from Account A1, Account A2 Where A2.Account=A1.Parent
Update A1 Set Type=A2.Type from Account A1, Account A2 Where A2.Account=A1.Parent
Update A1 Set Type=A2.Type from Account A1, Account A2 Where A2.Account=A1.Parent
Update A1 Set Type=A2.Type from Account A1, Account A2 Where A2.Account=A1.Parent
Update A1 Set Type=A2.Type from Account A1, Account A2 Where A2.Account=A1.Parent
Update A1 Set Type=A2.Type from Account A1, Account A2 Where A2.Account=A1.Parent
Update A1 Set Type=A2.Type from Account A1, Account A2 Where A2.Account=A1.Parent


Select @I=Max(Account.Level) from Account
WHILE @i>1
BEGIN
	insert into @GL_Cash(Month, Year, Account, Branch, Debit, Credit)
	Select GL.Month, GL.Year, Account.Parent as Account, GL.Branch
	, sum(Debit) as Debit
	, sum(Credit) as Credit
	from @GL_Cash GL, Account Where Account.Account=GL.Account and Account.Level=@i
	Group By GL.Month, GL.Year, Account.Parent, GL.Branch
	
    Select @i=@i-1
END


insert into GL_CASH(Month, Year, Account, Branch, Debit, Credit)
Select GL.Month, GL.Year, GL.Account, GL.Branch
, sum(Debit) as Debit
, sum(Credit) as Credit
from @GL_Cash GL
Group By GL.Month, GL.Year, GL.Account, GL.Branch




GO





 insert into PatchVersioning
select '487 Update Script - Initialize GL CASH',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='487 Update Script - Initialize GL CASH'


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
