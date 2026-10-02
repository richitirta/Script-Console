DROP PROCEDURE View10L
go
CREATE PROCEDURE View10L (@pANO as integer)     

AS    

SELECT Cast(0 as bit) as ProcessFlag , ACCBS.ID, PROFILE.NAME, ACCBS.BSType, BSTYPE.Description as BSTypeDesc, ACCBS.FEE, ACCBS.DISCOUNT, ACCBS.UPFEE, ACCBS.UseCurrTypeF

FROM ACCBS

Inner Join PROFILE on (Profile.ID=ACCBS.ID)

Left Join BSType on (BSTYPE.BSTYPE=ACCBS.BSTYPE)

WHERE ACCBS.ANO=@pANO  

  

union all  

  

SELECT Cast(0 as bit) as ProcessFlag , ACCBS.ID, PROFILE.NAME, ACCBS.BSType, BSTYPE.Description as BSTypeDesc, ACCBS.FEE, ACCBS.DISCOUNT, ACCBS.UPFEE, ACCBS.UseCurrTypeF 

FROM AACCBS ACCBS

Inner Join PROFILE on (Profile.ID=ACCBS.ID)

Left Join BSType on (BSTYPE.BSTYPE=ACCBS.BSTYPE)

WHERE ACCBS.ANO=@pANO  
go






 insert into PatchVersioning
select '421 Update Script - View10L',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='421 Update Script - View10L'


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

