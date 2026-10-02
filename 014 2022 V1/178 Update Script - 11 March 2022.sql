DROP PROCEDURE View10L 
GO
CREATE PROCEDURE View10L (@pANO as integer)     
AS    
SELECT ACCBS.ID, PROFILE.NAME, ACCBS.BSType, BSTYPE.Description as BSTypeDesc, ACCBS.FEE, ACCBS.DISCOUNT, ACCBS.UPFEE
FROM ACCBS
Inner Join PROFILE on (Profile.ID=ACCBS.ID)
Left Join BSType on (BSTYPE.BSTYPE=ACCBS.BSTYPE)
WHERE ACCBS.ANO=@pANO  
  
union all  
  
SELECT ACCBS.ID, PROFILE.NAME, ACCBS.BSType, BSTYPE.Description as BSTypeDesc, ACCBS.FEE, ACCBS.DISCOUNT, ACCBS.UPFEE 
FROM AACCBS ACCBS
Inner Join PROFILE on (Profile.ID=ACCBS.ID)
Left Join BSType on (BSTYPE.BSTYPE=ACCBS.BSTYPE)
WHERE ACCBS.ANO=@pANO  

GO



 insert into PatchVersioning
select '178 Update Script - 11 March 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='178 Update Script - 11 March 2022'


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