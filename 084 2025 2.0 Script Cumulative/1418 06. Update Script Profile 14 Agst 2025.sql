SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Proc_Profile_Verify') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE Proc_Profile_Verify END
GO

Create Procedure Proc_Profile_Verify(@PID as Varchar(10),@VerifiedBy as varchar(50), @VerifiedDate as smalldatetime, @VerifiedTime as VARCHAR(8))      
AS       
Update Profile Set VerifiedF=1,DumpF=0,VerifiedBy=@VerifiedBy,VerifiedTime=@VerifiedTime,VerifiedDate=@VerifiedDate Where ID=@PID

insert into SYSLOGOBJECT ( [LogName],[LogID],[Last_Opr],[Last_Update],[Last_Time],[ColName],[ColValueOld],[ColValueNew],[Action],[LogKeyID],[LogKeyIDExt1],[LogIDExt1],[LogKeyIDExt2],[LogIDExt2],[LogKeyIDExt3],[LogIDExt3],[LogKeyIDExt4],[LogIDExt4]) SELECT 'Profile',@PID,@VerifiedBy,@VerifiedDate,@VerifiedTime,'DUMPF',1, 0,'Verify','ID','VerifiedF',1,'VerifiedBy',@VerifiedBy,'VerifiedDate',@VerifiedDate,'VerifiedTime',@VerifiedTime

select * from profile where ID=@PID and DumpF=0
go
  

insert into PatchVersioning
select '1418 06. Update Script Profile 14 Agst 2025',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrScript='1418 06. Update Script Profile 14 Agst 2025'


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