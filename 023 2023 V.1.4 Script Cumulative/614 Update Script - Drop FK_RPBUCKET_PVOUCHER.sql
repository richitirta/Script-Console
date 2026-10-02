
ALTER TABLE [dbo].[RPBucket] DROP CONSTRAINT [FK_RPBUCKET_PVOUCHER]
GO

--ALTER TABLE [dbo].[RPBucket]  WITH NOCHECK ADD  CONSTRAINT [FK_RPBUCKET_PVOUCHER] FOREIGN KEY([Voucher])
--REFERENCES [dbo].[pVoucher] ([Voucher])
--ON UPDATE CASCADE
--ON DELETE CASCADE
--GO

--ALTER TABLE [dbo].[RPBucket] CHECK CONSTRAINT [FK_RPBUCKET_PVOUCHER]
--GO




 insert into PatchVersioning	
select '614 Update Script - Drop FK_RPBUCKET_PVOUCHER',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='614 Update Script - Drop FK_RPBUCKET_PVOUCHER'


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


