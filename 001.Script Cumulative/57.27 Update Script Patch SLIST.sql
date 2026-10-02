
insert into PatchVersioning
select '57.27 Update Script Patch SLIST',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='57.26 Script inisialisasi Hint OPFee (Execute after cumulative 20202 v1.2)'
Select @CurrSCript='57.27 Update Script Patch SLIST'


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
			
		DROP PROCEDURE [dbo].[SList01]
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End

GO
CREATE PROCEDURE [dbo].[SList01] (@P_UserID as Varchar(50)) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Service.* 
From Service 
WHERE Service.SStatus='R' and Service.LUserID Like @P_UserID 
go
