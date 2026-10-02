DROP Function fn_ObjectValuation
GO
Create Function fn_ObjectValuation(@P_INO as int, @P_VDate as smalldatetime)        
RETURNS Table            
AS RETURN            
(          
  Select TOP 1 TOIVALUE.VALUE/dbo.get_Exchange(@P_VDate,ICover.Currency) as Value, TOIVALUE.VALUEPCT  
  From ICOVER
  INNER JOIN TOIVALUE ON (TOIVALUE.Status='A' and TOIVALUE.TOI=ICOVER.TOI AND (TOIVALUE.YEAR<YEAR(@P_VDATE) OR (TOIVALUE.YEAR=YEAR(@P_VDATE) AND TOIVALUE.MONTH<=MONTH(@P_VDATE))))
  LEFT JOIN IINFO ON (IINFO.INO=ICOVER.INO)
  WHERE ICOVER.INO=@P_INO AND ICOVER.NOTDECRF=0
  And ((TOIValue.ValueID1='' and coalesce(IINFO.ValueDesc1,'') Like TOIValue.ValueDesc1+'%') or (TOIValue.ValueID1<>'' and coalesce(IINFO.ValueID1,'') Like TOIValue.ValueID1+'%') or (TOIValue.ValueID1 is null))            
  And ((TOIValue.ValueID2='' and coalesce(IINFO.ValueDesc2,'') Like TOIValue.ValueDesc2+'%') or (TOIValue.ValueID2<>'' and coalesce(IINFO.ValueID2,'') Like TOIValue.ValueID2+'%') or (TOIValue.ValueID2 is null))            
  And ((TOIValue.ValueID3='' and coalesce(IINFO.ValueDesc3,'') Like TOIValue.ValueDesc3+'%') or (TOIValue.ValueID3<>'' and coalesce(IINFO.ValueID3,'') Like TOIValue.ValueID3+'%') or (TOIValue.ValueID3 is null))            
  And ((TOIValue.ValueID4='' and coalesce(IINFO.ValueDesc4,'') Like TOIValue.ValueDesc4+'%') or (TOIValue.ValueID4<>'' and coalesce(IINFO.ValueID4,'') Like TOIValue.ValueID4+'%') or (TOIValue.ValueID4 is null))            
  And ((TOIValue.ValueID5='' and coalesce(IINFO.ValueDesc5,'') Like TOIValue.ValueDesc5+'%') or (TOIValue.ValueID5<>'' and coalesce(IINFO.ValueID5,'') Like TOIValue.ValueID5+'%') or (TOIValue.ValueID5 is null))            
  And ((TOIValue.ValueID6='' and coalesce(IINFO.ValueDesc6,'') Like TOIValue.ValueDesc6+'%') or (TOIValue.ValueID6<>'' and coalesce(IINFO.ValueID6,'') Like TOIValue.ValueID6+'%') or (TOIValue.ValueID6 is null))            
  And ((TOIValue.ValueID7='' and coalesce(IINFO.ValueDesc7,'') Like TOIValue.ValueDesc7+'%') or (TOIValue.ValueID7<>'' and coalesce(IINFO.ValueID7,'') Like TOIValue.ValueID7+'%') or (TOIValue.ValueID7 is null))            
  And ((TOIValue.ValueID8='' and coalesce(IINFO.ValueDesc8,'') Like TOIValue.ValueDesc8+'%') or (TOIValue.ValueID8<>'' and coalesce(IINFO.ValueID8,'') Like TOIValue.ValueID8+'%') or (TOIValue.ValueID8 is null))            
  And ((TOIValue.ValueID9='' and coalesce(IINFO.ValueDesc9,'') Like TOIValue.ValueDesc9+'%') or (TOIValue.ValueID9<>'' and coalesce(IINFO.ValueID9,'') Like TOIValue.ValueID9+'%') or (TOIValue.ValueID9 is null))            
  And ((TOIValue.ValueID10='' and coalesce(IINFO.ValueDesc10,'') Like TOIValue.ValueDesc10+'%') or (TOIValue.ValueID10<>'' and coalesce(IINFO.ValueID10,'') Like TOIValue.ValueID10+'%') or (TOIValue.ValueID10 is null))            
  And ((TOIValue.ValueID11='' and coalesce(IINFO.ValueDesc11,'') Like TOIValue.ValueDesc11+'%') or (TOIValue.ValueID11<>'' and coalesce(IINFO.ValueID11,'') Like TOIValue.ValueID11+'%') or (TOIValue.ValueID11 is null))            
  And ((TOIValue.ValueID12='' and coalesce(IINFO.ValueDesc12,'') Like TOIValue.ValueDesc12+'%') or (TOIValue.ValueID12<>'' and coalesce(IINFO.ValueID12,'') Like TOIValue.ValueID12+'%') or (TOIValue.ValueID12 is null))            
  And ((TOIValue.ValueID13='' and coalesce(IINFO.ValueDesc13,'') Like TOIValue.ValueDesc13+'%') or (TOIValue.ValueID13<>'' and coalesce(IINFO.ValueID13,'') Like TOIValue.ValueID13+'%') or (TOIValue.ValueID13 is null))            
  And ((TOIValue.ValueID14='' and coalesce(IINFO.ValueDesc14,'') Like TOIValue.ValueDesc14+'%') or (TOIValue.ValueID14<>'' and coalesce(IINFO.ValueID14,'') Like TOIValue.ValueID14+'%') or (TOIValue.ValueID14 is null))            
  And ((TOIValue.ValueID15='' and coalesce(IINFO.ValueDesc15,'') Like TOIValue.ValueDesc15+'%') or (TOIValue.ValueID15<>'' and coalesce(IINFO.ValueID15,'') Like TOIValue.ValueID15+'%') or (TOIValue.ValueID15 is null))            
  Order By  
  len(coalesce(TOIValue.ValueID1,'')) Desc, len(coalesce(TOIValue.ValueID2,'')) Desc, len(coalesce(TOIValue.ValueID3,'')) Desc, len(coalesce(TOIValue.ValueID4,'')) Desc, len(coalesce(TOIValue.ValueID5,'')) Desc,               
  len(coalesce(TOIValue.ValueID6,'')) Desc, len(coalesce(TOIValue.ValueID7,'')) Desc, len(coalesce(TOIValue.ValueID8,'')) Desc, len(coalesce(TOIValue.ValueID9,'')) Desc, len(coalesce(TOIValue.ValueID10,'')) Desc,     
  len(coalesce(TOIValue.ValueID11,'')) Desc, len(coalesce(TOIValue.ValueID12,'')) Desc, len(coalesce(TOIValue.ValueID13,'')) Desc, len(coalesce(TOIValue.ValueID14,'')) Desc, len(coalesce(TOIValue.ValueID15,'')) Desc,
  TOIVALUE.Year Desc, TOIVALUE.Month Desc, TOIVALUE.TOIVALUEID Desc  
) 

go



 insert into PatchVersioning
select '496 Update Script - Patch 2022 (89)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='496 Update Script - Patch 2022 (89)'


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



