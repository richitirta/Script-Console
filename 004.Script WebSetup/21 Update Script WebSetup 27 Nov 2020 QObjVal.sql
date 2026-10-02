IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QObjVal') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QObjVal
end
GO
CREATE PROCEDURE QObjVal (@TOI Varchar(10), @Month varchar(10), @Year varchar(10) )              
AS              
 BEGIN 
Select  Cast(0 as bit) as ProcessFlag,TOIValue.Value,TOIValue.ValuePCT,TOIVALUEID,
(Case When FLDCRITERIA2=1 and TOIValue.FLDID1<>'' Then F.FLDTAG1+' : '+Case When TOIValue.VALUEID1<>'' Then TOIValue.VALUEID1+'-'+cast(TOIValue.VALUEDESC1 as varchar(100)) ELSE cast(TOIValue.VALUEDESC1 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end  
+Case When FLDCRITERIA2=1 and TOIValue.FLDID2<>'' Then F.FLDTAG2+' : '+Case When TOIValue.VALUEID2<>'' Then TOIValue.VALUEID2+'-'+cast(TOIValue.VALUEDESC2 as varchar(100)) ELSE cast(TOIValue.VALUEDESC2 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end  
+Case When FLDCRITERIA3=1 and TOIValue.FLDID3<>'' Then F.FLDTAG3+' : '+Case When TOIValue.VALUEID3<>'' Then TOIValue.VALUEID3+'-'+cast(TOIValue.VALUEDESC3 as varchar(100)) ELSE cast(TOIValue.VALUEDESC3 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end  
+Case When FLDCRITERIA4=1 and TOIValue.FLDID4<>'' Then F.FLDTAG4+' : '+Case When TOIValue.VALUEID4<>'' Then TOIValue.VALUEID4+'-'+cast(TOIValue.VALUEDESC4 as varchar(100)) ELSE cast(TOIValue.VALUEDESC4 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end  
+Case When FLDCRITERIA5=1 and TOIValue.FLDID5<>'' Then F.FLDTAG5+' : '+Case When TOIValue.VALUEID5<>'' Then TOIValue.VALUEID5+'-'+cast(TOIValue.VALUEDESC5 as varchar(100)) ELSE cast(TOIValue.VALUEDESC5 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end  
+Case When FLDCRITERIA6=1 and TOIValue.FLDID6<>'' Then F.FLDTAG6+' : '+Case When TOIValue.VALUEID6<>'' Then TOIValue.VALUEID6+'-'+cast(TOIValue.VALUEDESC6 as varchar(100)) ELSE cast(TOIValue.VALUEDESC6 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end  
+Case When FLDCRITERIA7=1 and TOIValue.FLDID7<>'' Then F.FLDTAG7+' : '+Case When TOIValue.VALUEID7<>'' Then TOIValue.VALUEID7+'-'+cast(TOIValue.VALUEDESC7 as varchar(100)) ELSE cast(TOIValue.VALUEDESC7 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end  
+Case When FLDCRITERIA8=1 and TOIValue.FLDID8<>'' Then F.FLDTAG8+' : '+Case When TOIValue.VALUEID8<>'' Then TOIValue.VALUEID8+'-'+cast(TOIValue.VALUEDESC8 as varchar(100)) ELSE cast(TOIValue.VALUEDESC8 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end  
+Case When FLDCRITERIA9=1 and TOIValue.FLDID9<>'' Then F.FLDTAG9+' : '+Case When TOIValue.VALUEID9<>'' Then TOIValue.VALUEID9+'-'+cast(TOIValue.VALUEDESC9 as varchar(100)) ELSE cast(TOIValue.VALUEDESC9 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end  
+Case When FLDCRITERIA10=1 and TOIValue.FLDID10<>'' Then F.FLDTAG10+' : '+Case When TOIValue.VALUEID10<>'' Then TOIValue.VALUEID10+'-'+cast(TOIValue.VALUEDESC10 as varchar(100)) ELSE cast(TOIValue.VALUEDESC10 as varchar(100)) END+'; '+char(13)+char(10) ELSE ''
 end  
  
+Case When FLDCRITERIA11=1 and TOIValue.FLDID11<>'' Then F.FLDTAG11+' : '+Case When TOIValue.VALUEID11<>'' Then TOIValue.VALUEID11+'-'+cast(TOIValue.VALUEDESC11 as varchar(100)) ELSE cast(TOIValue.VALUEDESC11 as varchar(100)) END+'; '+char(13)+char(10) ELSE ''
 end  
  
+Case When FLDCRITERIA12=1 and TOIValue.FLDID12<>'' Then F.FLDTAG12+' : '+Case When TOIValue.VALUEID12<>'' Then TOIValue.VALUEID12+'-'+cast(TOIValue.VALUEDESC12 as varchar(100)) ELSE cast(TOIValue.VALUEDESC12 as varchar(100)) END+'; '+char(13)+char(10) ELSE ''
 end  
  
+Case When FLDCRITERIA13=1 and TOIValue.FLDID13<>'' Then F.FLDTAG13+' : '+Case When TOIValue.VALUEID13<>'' Then TOIValue.VALUEID13+'-'+cast(TOIValue.VALUEDESC13 as varchar(100)) ELSE cast(TOIValue.VALUEDESC13 as varchar(100)) END+'; '+char(13)+char(10) ELSE ''
 end  
  
+Case When FLDCRITERIA14=1 and TOIValue.FLDID14<>'' Then F.FLDTAG14+' : '+Case When TOIValue.VALUEID14<>'' Then TOIValue.VALUEID14+'-'+cast(TOIValue.VALUEDESC14 as varchar(100)) ELSE cast(TOIValue.VALUEDESC14 as varchar(100)) END+'; '+char(13)+char(10) ELSE ''
 end  
  
+Case When FLDCRITERIA15=1 and TOIValue.FLDID15<>'' Then F.FLDTAG15+' : '+Case When TOIValue.VALUEID15<>'' Then TOIValue.VALUEID15+'-'+cast(TOIValue.VALUEDESC15 as varchar(100)) ELSE cast(TOIValue.VALUEDESC15 as varchar(100)) END+'; '+char(13)+char(10) ELSE ''
 end  
 ) AS OBJ_INFO

 from TOIValue 
 LEFT JOIN FNTOI_genHtab(@TOI) F  ON F.TOI = TOIValue.TOI  
   where TOIValue.TOI =@TOI and TOIValue.Month=@Month and TOIValue.Year =@Year
    Order By TOIValue.TOIValueID
 end  



 --QObjVal M09,6,2016




 --select * from TOIValue
 --select * from GENDTAB where FLDID='V01'

 GO

 insert into PatchVersioning
select 'Update Script WebSetup 27 Nov 2020 QObjVal',GETDATE()
go
