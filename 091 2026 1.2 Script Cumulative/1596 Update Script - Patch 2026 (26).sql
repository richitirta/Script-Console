DROP function get_Acceptance_Search
GO
Create function get_Acceptance_Search(@Value varchar(255))     
RETURNS @Acceptance TABLE (ANO int Not Null Primary Key)
AS
BEGIN
	if @Value<>'%'
	Begin 
		Select @Value=replace(replace(replace(@Value,'"',''),'*',''),'near','')
		Select @Value=replace(replace(@Value,'%',' '),'  ',' ')
		Select @Value=ltrim(rtrim(@Value))
		Select @Value=replace(@value,' ','*" near "*')
		Select @Value='"*'+@Value+'*"'
		insert into @Acceptance
		Select ANO
		from Acceptance  
		Where 
		(
			contains(AName,@Value)
		)
	End
	else
	Begin
		insert into @Acceptance
		Select cast(0 as Int) ANO 
	End
RETURN
END
go


insert into PatchVersioning
select '1596 Update Script - Patch 2026 (26).sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1596 Update Script - Patch 2026 (26).sql'


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