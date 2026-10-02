IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='RESTRICTVIEWRIINFO')
BEGIN
INSERT INTO SYSFORM(FNAME, DESCRIPTION, FCODE,REQUESTF)
Select 'RESTRICTVIEWRIINFO','RESTRICT VIEW RI INFO','ACTIVITIES',0
end
go

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='RESTRICTVIEWOPINFO')
BEGIN
INSERT INTO SYSFORM(FNAME, DESCRIPTION, FCODE,REQUESTF)
Select 'RESTRICTVIEWOPINFO','ALLOW VIEW OP INFO','ACTIVITIES',0
end
go

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='RESTRICTVIEWBOINFO')
BEGIN
INSERT INTO SYSFORM(FNAME, DESCRIPTION, FCODE,REQUESTF)
Select 'RESTRICTVIEWBOINFO','ALLOW VIEW BO INFO','ACTIVITIES',0
end
go


insert into PatchVersioning
select '970 Update Script - 1 March 2024',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='970 Update Script - 1 March 2024'


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
	 