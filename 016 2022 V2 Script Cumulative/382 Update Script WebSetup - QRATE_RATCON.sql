
drop procedure QRate_Ratcon
go
CREATE PROCEDURE QRate_Ratcon (@CODE Varchar(10), @TOC varchar(10) )              

AS              

 BEGIN                      

 SELECT CAST(0 As Bit) ProcessFlag, RATECON, RATECON.CODE AS CODE,MinTSI,MaxTSI,        

RATECON.MINPERIOD, RATECON.MAXPERIOD, RATECON.MINRATE, RATECON.MAXRATE, RATECON.RATE,RATECON.CRATE,  

 RATETAB.SPERIOD,TEXCESS, RATECON.ALLOWEDF, LOADING, RATECON.CRATE,  

(Case When FLDCRITERIA1=1 and RATECON.FLDID1<>'' Then F.FLDTAG1+' : '+Case When RATECON.VALUEID1<>'' Then RATECON.VALUEID1+'-'+cast(RATECON.VALUEDESC1 as varchar(100)) ELSE cast(RATECON.VALUEDESC1 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end  


+Case When FLDCRITERIA2=1 and RATECON.FLDID2<>'' Then F.FLDTAG2+' : '+Case When RATECON.VALUEID2<>'' Then RATECON.VALUEID2+'-'+cast(RATECON.VALUEDESC2 as varchar(100)) ELSE cast(RATECON.VALUEDESC2 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end  


+Case When FLDCRITERIA3=1 and RATECON.FLDID3<>'' Then F.FLDTAG3+' : '+Case When RATECON.VALUEID3<>'' Then RATECON.VALUEID3+'-'+cast(RATECON.VALUEDESC3 as varchar(100)) ELSE cast(RATECON.VALUEDESC3 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end  


+Case When FLDCRITERIA4=1 and RATECON.FLDID4<>'' Then F.FLDTAG4+' : '+Case When RATECON.VALUEID4<>'' Then RATECON.VALUEID4+'-'+cast(RATECON.VALUEDESC4 as varchar(100)) ELSE cast(RATECON.VALUEDESC4 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end  


+Case When FLDCRITERIA5=1 and RATECON.FLDID5<>'' Then F.FLDTAG5+' : '+Case When RATECON.VALUEID5<>'' Then RATECON.VALUEID5+'-'+cast(RATECON.VALUEDESC5 as varchar(100)) ELSE cast(RATECON.VALUEDESC5 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end  


+Case When FLDCRITERIA6=1 and RATECON.FLDID6<>'' Then F.FLDTAG6+' : '+Case When RATECON.VALUEID6<>'' Then RATECON.VALUEID6+'-'+cast(RATECON.VALUEDESC6 as varchar(100)) ELSE cast(RATECON.VALUEDESC6 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end  


+Case When FLDCRITERIA7=1 and RATECON.FLDID7<>'' Then F.FLDTAG7+' : '+Case When RATECON.VALUEID7<>'' Then RATECON.VALUEID7+'-'+cast(RATECON.VALUEDESC7 as varchar(100)) ELSE cast(RATECON.VALUEDESC7 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end  


+Case When FLDCRITERIA8=1 and RATECON.FLDID8<>'' Then F.FLDTAG8+' : '+Case When RATECON.VALUEID8<>'' Then RATECON.VALUEID8+'-'+cast(RATECON.VALUEDESC8 as varchar(100)) ELSE cast(RATECON.VALUEDESC8 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end  


+Case When FLDCRITERIA9=1 and RATECON.FLDID9<>'' Then F.FLDTAG9+' : '+Case When RATECON.VALUEID9<>'' Then RATECON.VALUEID9+'-'+cast(RATECON.VALUEDESC9 as varchar(100)) ELSE cast(RATECON.VALUEDESC9 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end  


+Case When FLDCRITERIA10=1 and RATECON.FLDID10<>'' Then F.FLDTAG10+' : '+Case When RATECON.VALUEID10<>'' Then RATECON.VALUEID10+'-'+cast(RATECON.VALUEDESC10 as varchar(100)) ELSE cast(RATECON.VALUEDESC10 as varchar(100)) END+'; '+char(13)+char(10) ELSE ''


 end  

  

+Case When FLDCRITERIA11=1 and RATECON.FLDID11<>'' Then F.FLDTAG11+' : '+Case When RATECON.VALUEID11<>'' Then RATECON.VALUEID11+'-'+cast(RATECON.VALUEDESC11 as varchar(100)) ELSE cast(RATECON.VALUEDESC11 as varchar(100)) END+'; '+char(13)+char(10) ELSE ''


 end  

  

+Case When FLDCRITERIA12=1 and RATECON.FLDID12<>'' Then F.FLDTAG12+' : '+Case When RATECON.VALUEID12<>'' Then RATECON.VALUEID12+'-'+cast(RATECON.VALUEDESC12 as varchar(100)) ELSE cast(RATECON.VALUEDESC12 as varchar(100)) END+'; '+char(13)+char(10) ELSE ''


 end  

  

+Case When FLDCRITERIA13=1 and RATECON.FLDID13<>'' Then F.FLDTAG13+' : '+Case When RATECON.VALUEID13<>'' Then RATECON.VALUEID13+'-'+cast(RATECON.VALUEDESC13 as varchar(100)) ELSE cast(RATECON.VALUEDESC13 as varchar(100)) END+'; '+char(13)+char(10) ELSE ''


 end  

  

+Case When FLDCRITERIA14=1 and RATECON.FLDID14<>'' Then F.FLDTAG14+' : '+Case When RATECON.VALUEID14<>'' Then RATECON.VALUEID14+'-'+cast(RATECON.VALUEDESC14 as varchar(100)) ELSE cast(RATECON.VALUEDESC14 as varchar(100)) END+'; '+char(13)+char(10) ELSE ''


 end  

  

+Case When FLDCRITERIA15=1 and RATECON.FLDID15<>'' Then F.FLDTAG15+' : '+Case When RATECON.VALUEID15<>'' Then RATECON.VALUEID15+'-'+cast(RATECON.VALUEDESC15 as varchar(100)) ELSE cast(RATECON.VALUEDESC15 as varchar(100)) END+'; '+char(13)+char(10) ELSE ''


 end  

 ) AS OBJ_INFO  

 from RateCon  

  LEFT JOIN RATETAB ON RATETAB.CODE = RATECON.CODE   

  LEFT JOIN FNtoc_genHtab(@TOC) F  ON F.TOC = RATETAB.TOC  

   where RATECON.CODE LIKE @CODE     

 end  
go



 insert into PatchVersioning
select '382 Update Script WebSetup - QRATE_RATCON',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='382 Update Script WebSetup - QRATE_RATCON'


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