IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QKOLValue') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QKOLValue
end
GO
Create PROCEDURE QKOLValue (@TOI Varchar(10), @KOL varchar(10))                
AS                
 BEGIN   
Select  Cast(0 as bit) as ProcessFlag,KOLValue.KOL,KOLValue.KOLValueID,KOLValue.Branch,KOLValue.Cost,  
(Case When FLDCRITERIA2=1 and KOLValue.FLDID1<>'' Then F.FLDTAG1+' : '+Case When KOLValue.VALUEID1<>'' Then KOLValue.VALUEID1+'-'+cast(KOLValue.VALUEDESC1 as varchar(100)) ELSE cast(KOLValue.VALUEDESC1 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end    
+Case When FLDCRITERIA2=1 and KOLValue.FLDID2<>'' Then F.FLDTAG2+' : '+Case When KOLValue.VALUEID2<>'' Then KOLValue.VALUEID2+'-'+cast(KOLValue.VALUEDESC2 as varchar(100)) ELSE cast(KOLValue.VALUEDESC2 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end    
+Case When FLDCRITERIA3=1 and KOLValue.FLDID3<>'' Then F.FLDTAG3+' : '+Case When KOLValue.VALUEID3<>'' Then KOLValue.VALUEID3+'-'+cast(KOLValue.VALUEDESC3 as varchar(100)) ELSE cast(KOLValue.VALUEDESC3 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end    
+Case When FLDCRITERIA4=1 and KOLValue.FLDID4<>'' Then F.FLDTAG4+' : '+Case When KOLValue.VALUEID4<>'' Then KOLValue.VALUEID4+'-'+cast(KOLValue.VALUEDESC4 as varchar(100)) ELSE cast(KOLValue.VALUEDESC4 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end    
+Case When FLDCRITERIA5=1 and KOLValue.FLDID5<>'' Then F.FLDTAG5+' : '+Case When KOLValue.VALUEID5<>'' Then KOLValue.VALUEID5+'-'+cast(KOLValue.VALUEDESC5 as varchar(100)) ELSE cast(KOLValue.VALUEDESC5 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end    
+Case When FLDCRITERIA6=1 and KOLValue.FLDID6<>'' Then F.FLDTAG6+' : '+Case When KOLValue.VALUEID6<>'' Then KOLValue.VALUEID6+'-'+cast(KOLValue.VALUEDESC6 as varchar(100)) ELSE cast(KOLValue.VALUEDESC6 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end    
+Case When FLDCRITERIA7=1 and KOLValue.FLDID7<>'' Then F.FLDTAG7+' : '+Case When KOLValue.VALUEID7<>'' Then KOLValue.VALUEID7+'-'+cast(KOLValue.VALUEDESC7 as varchar(100)) ELSE cast(KOLValue.VALUEDESC7 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end    
+Case When FLDCRITERIA8=1 and KOLValue.FLDID8<>'' Then F.FLDTAG8+' : '+Case When KOLValue.VALUEID8<>'' Then KOLValue.VALUEID8+'-'+cast(KOLValue.VALUEDESC8 as varchar(100)) ELSE cast(KOLValue.VALUEDESC8 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end    
+Case When FLDCRITERIA9=1 and KOLValue.FLDID9<>'' Then F.FLDTAG9+' : '+Case When KOLValue.VALUEID9<>'' Then KOLValue.VALUEID9+'-'+cast(KOLValue.VALUEDESC9 as varchar(100)) ELSE cast(KOLValue.VALUEDESC9 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end    
+Case When FLDCRITERIA10=1 and KOLValue.FLDID10<>'' Then F.FLDTAG10+' : '+Case When KOLValue.VALUEID10<>'' Then KOLValue.VALUEID10+'-'+cast(KOLValue.VALUEDESC10 as varchar(100)) ELSE cast(KOLValue.VALUEDESC10 as varchar(100)) END+'; '+char(13)+char(10) ELSE ''  
 end    
    
+Case When FLDCRITERIA11=1 and KOLValue.FLDID11<>'' Then F.FLDTAG11+' : '+Case When KOLValue.VALUEID11<>'' Then KOLValue.VALUEID11+'-'+cast(KOLValue.VALUEDESC11 as varchar(100)) ELSE cast(KOLValue.VALUEDESC11 as varchar(100)) END+'; '+char(13)+char(10) ELSE ''  
 end    
    
+Case When FLDCRITERIA12=1 and KOLValue.FLDID12<>'' Then F.FLDTAG12+' : '+Case When KOLValue.VALUEID12<>'' Then KOLValue.VALUEID12+'-'+cast(KOLValue.VALUEDESC12 as varchar(100)) ELSE cast(KOLValue.VALUEDESC12 as varchar(100)) END+'; '+char(13)+char(10) ELSE ''  
 end    
    
+Case When FLDCRITERIA13=1 and KOLValue.FLDID13<>'' Then F.FLDTAG13+' : '+Case When KOLValue.VALUEID13<>'' Then KOLValue.VALUEID13+'-'+cast(KOLValue.VALUEDESC13 as varchar(100)) ELSE cast(KOLValue.VALUEDESC13 as varchar(100)) END+'; '+char(13)+char(10) ELSE ''  
 end    
    
+Case When FLDCRITERIA14=1 and KOLValue.FLDID14<>'' Then F.FLDTAG14+' : '+Case When KOLValue.VALUEID14<>'' Then KOLValue.VALUEID14+'-'+cast(KOLValue.VALUEDESC14 as varchar(100)) ELSE cast(KOLValue.VALUEDESC14 as varchar(100)) END+'; '+char(13)+char(10) ELSE ''  
 end    
    
+Case When FLDCRITERIA15=1 and KOLValue.FLDID15<>'' Then F.FLDTAG15+' : '+Case When KOLValue.VALUEID15<>'' Then KOLValue.VALUEID15+'-'+cast(KOLValue.VALUEDESC15 as varchar(100)) ELSE cast(KOLValue.VALUEDESC15 as varchar(100)) END+'; '+char(13)+char(10) ELSE ''  
 end    
 ) AS OBJ_INFO  
  
 from KOLValue   
 LEFT JOIN FNTOI_genHtab(@TOI) F  ON F.TOI = KOLValue.TOI    
   where KOLValue.TOI =@TOI and KOLValue.KOL=@KOL   
   Order By KOLValue.TOI  
 end    
  
  GO
  insert into PatchVersioning
select 'Update Script WebSetup 27 Nov 2020 QKOLValue',GETDATE()
go
