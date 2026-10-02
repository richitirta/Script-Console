if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'get_TimeStampUser') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN 
DROP FUNCTION get_TimeStampUser
end
GO
Create function get_TimeStampUser(@P_USERID AS VARCHAR(50))     
RETURNS @TimeStampUser TABLE (ID Varchar(50),IPLogin varchar(50),IPLogout varchar(50),Last_Login_Date smalldatetime, Last_Login_Time Varchar(8),Last_Logout_Date smalldatetime, Last_Logout_Time Varchar(8),OTP nvarchar(1020),ByPassOTP BIT
)

AS
BEGIN

declare @TimeStampUserLogin Table (ID Varchar(50),IPLogin varchar(50),Last_Login_Date smalldatetime, Last_Login_Time Varchar(8))
declare @TimeStampUserLogout Table (ID Varchar(50),IPLogout varchar(50),Last_Logout_Date smalldatetime, Last_Logout_Time Varchar(8))
declare @TempSysuserOTP Table (ID Varchar(50),OTP nvarchar(1020))

insert @TimeStampUserLogin
Select top 1 s.ID, S.UserHostName IPLogin, 
S.Last_Login_Date, s.Last_Login_Time
from SysLoginUsers S
where s.ErrMsg='' and
S.ID=@P_USERID 
order by Logid desc
		
insert @TimeStampUserLogout
Select top 1 U.ID, U.UserHostName IPLogout,
U.Last_Logout_Date, U.Last_Logout_Time
from SysLogoutUsers U
where U.ID=@P_USERID 
order by Logid desc

INSERT @TempSysuserOTP
SELECT ID, OTP 
FROM SYSUSER 
where ID=@P_USERID 


insert @TimeStampUser
select L.ID, L.IPLogin, U.IPLogout,L.Last_Login_Date,Last_Login_Time,U.Last_Logout_Date, u.Last_Logout_Time, S.OTP,
case When (OTP='' OR (IPLogin=IPLogout and DATEDIFF(DAY,Last_Logout_Date,Last_Login_Date)>0)) then 0 
else 
case When (OTP='' OR (IPLogin=IPLogout and DATEDIFF(MINUTE,last_logout_time,Last_login_time)>60)) then 0 
else
1
end
end ByPassOTP
from @TimeStampUserLogin L, @TimeStampUserLogout U, @TempSysuserOTP S
where L.ID=U.ID

RETURN
END

go



--select * from get_TimeStampUser('CARE')


  insert into PatchVersioning
select '1117 Update Script TimeStampLoginLogout User',GETDATE()
go
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1117 Update Script TimeStampLoginLogout User'


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

