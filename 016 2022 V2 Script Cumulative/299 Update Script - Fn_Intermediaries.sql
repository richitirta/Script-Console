DROP Function fn_Intermediaries
GO
Create Function fn_Intermediaries(@P_ANO as int)
RETURNS VarChar(1024)  
AS  
BEGIN  
 Declare @Remarks as varchar(1024)  
 
 Declare @Name as varchar(1024)
Declare @Fee as varchar(1024)
Declare @Remark as varchar(1024) 
 Declare @FeeDet as varchar(1024)
  
    
 Select @Remarks=''  
 DECLARE AccBS_Cursor CURSOR FOR  

Select Distinct Profile.Name, convert(varchar(20), cast(AccBS.Fee as float),0)+'%' as Fee, Convert(varchar(1024), coalesce(RCover.Remark,'')) as Remark, convert(varchar(20), cast(coalesce(AccBSDet.Fee,0) as float),0)+'%' as FeeDet
from Acceptance
Inner Join AccBS on (AccBS.ANO=Acceptance.ANO or AccBS.ANO=Acceptance.LANO)
left Join AccBSDet on (AccBSDet.ANO=AccBS.ANO and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType) Left Join RCover on (RCover.ANO=AccBSDet.ANO and RCover.Code=AccBSDet.Code )
Inner Join Profile on (Profile.ID=AccBS.ID)
Where Acceptance.ANO=@P_ANO

OPEN AccBS_Cursor  
 FETCH FROM AccBS_Cursor into @Name, @Fee, @Remark, @FeeDet
WHILE @@FETCH_STATUS = 0  
 BEGIN  
    if @Remarks=''  
    BEGIN  
     if @Remark=''
     Begin
       Select @Remarks=@Name+'('+@Fee+')'
     End
     Else
     Begin
       Select @Remarks=@Name+'-'+@Remark+'('+@FeeDet+')'
     End
    End  
    Else  
    Begin
     if @Remark=''
     Begin
       Select @Remarks=substring(@Remarks+'|'+@Name+'('+@Fee+')',1,1024)  
     End
     Else
     Begin
       Select @Remarks=substring(@Remarks+'|'+@Name+'-'+@Remark+'('+@FeeDet+')',1,1024)  
     End
    End
    FETCH NEXT FROM AccBS_Cursor into @Name, @Fee, @Remark, @FeeDet
End  
 Close AccBS_Cursor  
 Deallocate AccBS_Cursor  
 Return (@Remarks)  
End  

GO


 insert into PatchVersioning
select '299 Update Script - Fn_Intermediaries',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='299 Update Script - Fn_Intermediaries'


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