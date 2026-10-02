drop PROCEDURE LoadTreatyLimit
go
CREATE PROCEDURE LoadTreatyLimit (@TOC Varchar(10), @Ryear varchar(10))              

  

AS              

  

BEGIN   

       

SELECT CAST(0 as bit) As ProcessFlag,    

R.RISKASS AS RISKASS,   

R.CATEGORY As Category,   

R.LIMIT As Limit,   

R.SHARE As Share, 

R.PSHARE As PShare,   

R.HOLDF As Hold,   

R.PRIORITYF As Priority,   

R.TSILimit As TSILIMIT,  

('<p align="justify">' +   

CASE WHEN G1.FLDID IS NOT NULL AND R.VALUEID1<>'' THEN G1.FLDTAG + ': ' + R.VALUEDESC1 + ' ;'  + '<br/>' + CHAR(11) ELSE '' END +   

CASE WHEN G2.FLDID IS NOT NULL AND R.VALUEID2<>'' THEN G2.FLDTAG + ': ' + R.VALUEDESC2 + ' ;' + '<br/>' + CHAR(11) ELSE '' END +   

CASE WHEN G3.FLDID IS NOT NULL AND R.VALUEID3<>'' THEN G3.FLDTAG + ': ' + R.VALUEDESC3 + ' ;' + '<br/>' + CHAR(11) ELSE '' END +   

CASE WHEN G4.FLDID IS NOT NULL AND R.VALUEID4<>'' THEN G4.FLDTAG + ': ' + R.VALUEDESC4 + ' ;' + '<br/>' + CHAR(11) ELSE '' END +   

CASE WHEN G5.FLDID IS NOT NULL AND R.VALUEID5<>'' THEN G5.FLDTAG + ': ' + R.VALUEDESC5 + ' ;' + '<br/>' + CHAR(11) ELSE '' END +   

CASE WHEN G6.FLDID IS NOT NULL AND R.VALUEID6<>'' THEN G6.FLDTAG + ': ' + R.VALUEDESC6 + ' ;' + '<br/>' + CHAR(11) ELSE '' END +   

CASE WHEN G7.FLDID IS NOT NULL AND R.VALUEID7<>'' THEN G7.FLDTAG + ': ' + R.VALUEDESC7 + ' ;' + '<br/>' + CHAR(11) ELSE '' END +   

CASE WHEN G8.FLDID IS NOT NULL AND R.VALUEID8<>'' THEN G8.FLDTAG + ': ' + R.VALUEDESC8 + ' ;' + '<br/>' + CHAR(11) ELSE '' END +   

CASE WHEN G9.FLDID IS NOT NULL AND R.VALUEID9<>'' THEN G9.FLDTAG + ': ' + R.VALUEDESC9 + ' ;' + '<br/>' + CHAR(11) ELSE '' END +   

CASE WHEN G10.FLDID IS NOT NULL AND R.VALUEID10<>'' THEN G10.FLDTAG + ': ' + R.VALUEDESC10 + ' ;' + '<br/>' + CHAR(11) ELSE '' END +   

CASE WHEN G11.FLDID IS NOT NULL AND R.VALUEID11<>'' THEN G11.FLDTAG + ': ' + R.VALUEDESC11 + ' ;' + '<br/>' + CHAR(11) ELSE '' END +   

CASE WHEN G12.FLDID IS NOT NULL AND R.VALUEID12<>'' THEN G12.FLDTAG + ': ' + R.VALUEDESC12 + ' ;' + '<br/>' + CHAR(11) ELSE '' END +   

CASE WHEN G13.FLDID IS NOT NULL AND R.VALUEID13<>'' THEN G13.FLDTAG + ': ' + R.VALUEDESC13 + ' ;' + '<br/>' + CHAR(11) ELSE '' END +   

CASE WHEN G14.FLDID IS NOT NULL AND R.VALUEID14<>'' THEN G14.FLDTAG + ': ' + R.VALUEDESC14 + ' ;' + '<br/>' + CHAR(11) ELSE '' END +   

CASE WHEN G15.FLDID IS NOT NULL AND R.VALUEID15<>'' THEN G15.FLDTAG + ': ' + R.VALUEDESC15 + ' ;' ELSE '' END  

+ '</p>')   

As OBJ_INFO  

  

FROM RiskAss R   

LEFT JOIN GENHTAB G1 ON (R.FLDID1=G1.FLDID)  

LEFT JOIN GENHTAB G2 ON (R.FLDID2=G2.FLDID)  

LEFT JOIN GENHTAB G3 ON (R.FLDID3=G3.FLDID)  

LEFT JOIN GENHTAB G4 ON (R.FLDID4=G4.FLDID)  

LEFT JOIN GENHTAB G5 ON (R.FLDID5=G5.FLDID)  

LEFT JOIN GENHTAB G6 ON (R.FLDID6=G6.FLDID)  

LEFT JOIN GENHTAB G7 ON (R.FLDID7=G7.FLDID)  

LEFT JOIN GENHTAB G8 ON (R.FLDID8=G8.FLDID)  

LEFT JOIN GENHTAB G9 ON (R.FLDID9=G9.FLDID)  

LEFT JOIN GENHTAB G10 ON (R.FLDID10=G10.FLDID)  

LEFT JOIN GENHTAB G11 ON (R.FLDID11=G11.FLDID)  

LEFT JOIN GENHTAB G12 ON (R.FLDID12=G12.FLDID)  

LEFT JOIN GENHTAB G13 ON (R.FLDID13=G13.FLDID)  

LEFT JOIN GENHTAB G14 ON (R.FLDID14=G14.FLDID)  

LEFT JOIN GENHTAB G15 ON (R.FLDID15=G15.FLDID)  

WHERE R.TOC = @TOC and R.RYear = @Ryear        

  

End

GO



 insert into PatchVersioning
select '791 Update Script - LoadTreatyLimit',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='791 Update Script - LoadTreatyLimit'


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


