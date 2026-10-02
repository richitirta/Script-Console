IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QSetupTOC_BSOPEX') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
begin
DROP PROCEDURE QSetupTOC_BSOPEX
end
GO

create PROCEDURE [dbo].QSetupTOC_BSOPEX(@TOC Varchar(10),@ID Varchar(10))                
AS                
 BEGIN                
  Select CAST(0 As Bit) ProcessFlag , [BSOPEXDET].TOC, [BSOPEXDET].ID,[BSOPEXDET].ObjID,[BSOPEXDET].AMOUNTPCT,[BSOPEXDET].PriorityF
,(Case When FLDCRITERIA1=1 and BSOPEXDET.FLDID1<>'' Then F.FLDTAG1+' : '+Case When BSOPEXDET.VALUEID1<>'' Then BSOPEXDET.VALUEID1+'-'+cast(BSOPEXDET.VALUEDESC1 as varchar(100)) ELSE cast(BSOPEXDET.VALUEDESC1 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When FLDCRITERIA2=1 and BSOPEXDET.FLDID2<>'' Then F.FLDTAG2+' : '+Case When BSOPEXDET.VALUEID2<>'' Then BSOPEXDET.VALUEID2+'-'+cast(BSOPEXDET.VALUEDESC2 as varchar(100)) ELSE cast(BSOPEXDET.VALUEDESC2 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When FLDCRITERIA3=1 and BSOPEXDET.FLDID3<>'' Then F.FLDTAG3+' : '+Case When BSOPEXDET.VALUEID3<>'' Then BSOPEXDET.VALUEID3+'-'+cast(BSOPEXDET.VALUEDESC3 as varchar(100)) ELSE cast(BSOPEXDET.VALUEDESC3 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When FLDCRITERIA4=1 and BSOPEXDET.FLDID4<>'' Then F.FLDTAG4+' : '+Case When BSOPEXDET.VALUEID4<>'' Then BSOPEXDET.VALUEID4+'-'+cast(BSOPEXDET.VALUEDESC4 as varchar(100)) ELSE cast(BSOPEXDET.VALUEDESC4 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When FLDCRITERIA5=1 and BSOPEXDET.FLDID5<>'' Then F.FLDTAG5+' : '+Case When BSOPEXDET.VALUEID5<>'' Then BSOPEXDET.VALUEID5+'-'+cast(BSOPEXDET.VALUEDESC5 as varchar(100)) ELSE cast(BSOPEXDET.VALUEDESC5 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When FLDCRITERIA6=1 and BSOPEXDET.FLDID6<>'' Then F.FLDTAG6+' : '+Case When BSOPEXDET.VALUEID6<>'' Then BSOPEXDET.VALUEID6+'-'+cast(BSOPEXDET.VALUEDESC6 as varchar(100)) ELSE cast(BSOPEXDET.VALUEDESC6 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When FLDCRITERIA7=1 and BSOPEXDET.FLDID7<>'' Then F.FLDTAG7+' : '+Case When BSOPEXDET.VALUEID7<>'' Then BSOPEXDET.VALUEID7+'-'+cast(BSOPEXDET.VALUEDESC7 as varchar(100)) ELSE cast(BSOPEXDET.VALUEDESC7 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When FLDCRITERIA8=1 and BSOPEXDET.FLDID8<>'' Then F.FLDTAG8+' : '+Case When BSOPEXDET.VALUEID8<>'' Then BSOPEXDET.VALUEID8+'-'+cast(BSOPEXDET.VALUEDESC8 as varchar(100)) ELSE cast(BSOPEXDET.VALUEDESC8 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When FLDCRITERIA9=1 and BSOPEXDET.FLDID9<>'' Then F.FLDTAG9+' : '+Case When BSOPEXDET.VALUEID9<>'' Then BSOPEXDET.VALUEID9+'-'+cast(BSOPEXDET.VALUEDESC9 as varchar(100)) ELSE cast(BSOPEXDET.VALUEDESC9 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When FLDCRITERIA10=1 and BSOPEXDET.FLDID10<>'' Then F.FLDTAG10+' : '+Case When BSOPEXDET.VALUEID10<>'' Then BSOPEXDET.VALUEID10+'-'+cast(BSOPEXDET.VALUEDESC10 as varchar(100)) ELSE cast(BSOPEXDET.VALUEDESC10 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When FLDCRITERIA11=1 and BSOPEXDET.FLDID11<>'' Then F.FLDTAG11+' : '+Case When BSOPEXDET.VALUEID11<>'' Then BSOPEXDET.VALUEID11+'-'+cast(BSOPEXDET.VALUEDESC11 as varchar(100)) ELSE cast(BSOPEXDET.VALUEDESC11 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When FLDCRITERIA12=1 and BSOPEXDET.FLDID12<>'' Then F.FLDTAG12+' : '+Case When BSOPEXDET.VALUEID12<>'' Then BSOPEXDET.VALUEID12+'-'+cast(BSOPEXDET.VALUEDESC12 as varchar(100)) ELSE cast(BSOPEXDET.VALUEDESC12 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When FLDCRITERIA13=1 and BSOPEXDET.FLDID13<>'' Then F.FLDTAG13+' : '+Case When BSOPEXDET.VALUEID13<>'' Then BSOPEXDET.VALUEID13+'-'+cast(BSOPEXDET.VALUEDESC13 as varchar(100)) ELSE cast(BSOPEXDET.VALUEDESC13 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When FLDCRITERIA14=1 and BSOPEXDET.FLDID14<>'' Then F.FLDTAG14+' : '+Case When BSOPEXDET.VALUEID14<>'' Then BSOPEXDET.VALUEID14+'-'+cast(BSOPEXDET.VALUEDESC14 as varchar(100)) ELSE cast(BSOPEXDET.VALUEDESC14 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When FLDCRITERIA15=1 and BSOPEXDET.FLDID15<>'' Then F.FLDTAG15+' : '+Case When BSOPEXDET.VALUEID15<>'' Then BSOPEXDET.VALUEID15+'-'+cast(BSOPEXDET.VALUEDESC15 as varchar(100)) ELSE cast(BSOPEXDET.VALUEDESC15 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
 ) AS OBJ_INFO 
  from [BSOPEXDET] 
    LEFT JOIN FNtoc_genHtab(@TOC) F  ON F.TOC = [BSOPEXDET].TOC
	where [BSOPEXDET].TOC = @TOC AND [BSOPEXDET].ID = @ID;  
 END 
 GO

  
  

 insert into PatchVersioning
select '133 Update Script WebSetup 19 Nov 2020 (Toc_BSOPEX)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='133 Update Script WebSetup 19 Nov 2020 (Toc_BSOPEX)'


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