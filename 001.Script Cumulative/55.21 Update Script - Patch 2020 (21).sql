if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_Get_WorkingDate') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_Get_WorkingDate
END
GO
CREATE Function fn_Get_WorkingDate(@PDate as Smalldatetime)
RETURNS SmallDateTime AS        
BEGIN      
	Select @PDate=cast(year(@PDate) as varchar(4))+'/'+right('0'+cast(Month(@PDate) as varchar(4)),2)+'/'+right('0'+cast(Day(@PDate) as varchar(4)),2)

	WHILE exists(Select * from Holiday Where HolidayDate=@PDate) or datepart(dw,@PDate)=1 or datepart(dw,@PDate)=7
	 BEGIN  
		Select @PDate=dateadd(day,1,@PDate)
	 End  
	return @PDate
END      

GO

insert into PatchVersioning
select '55.21 Update Script - Patch 2020 (21)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='55.20 Update Script - Patch 2020 (20)'
Select @CurrSCript='55.21 Update Script - Patch 2020 (21)'


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


