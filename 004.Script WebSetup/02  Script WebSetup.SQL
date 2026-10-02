----------- COB-----------
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCOB') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE QCOB
end
GO
CREATE PROCEDURE [dbo].[QCOB] (@COB Varchar(30) )    
AS    
 BEGIN    
  SELECT * FROM COB WHERE COB=@COB ;    
 END 

GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCOBReg2') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE QCOBReg2
end
GO
CREATE PROCEDURE [dbo].[QCOBReg2] (@COB Varchar(10) )        
AS        
 BEGIN        
select  CAST(0 As Bit) ProcessFlag,c2.Id,c.COB,c2.FLDID,c2.FLDTAG,c2.FLDTAGA  from COB c         
 cross apply      
(      
  values       
    ('1',FLDID1,FLDTAG1,FLDTAGA1),      
    ('2',FLDID2,FLDTAG2,FLDTAGA2),      
    ('3',FLDID3,FLDTAG3,FLDTAGA3),      
    ('4',FLDID4,FLDTAG4,FLDTAGA4),      
    ('5',FLDID5,FLDTAG5,FLDTAGA5),      
    ('6',FLDID6,FLDTAG6,FLDTAGA6),      
    ('7',FLDID7,FLDTAG7,FLDTAGA7),      
    ('8',FLDID8,FLDTAG8,FLDTAGA8),      
    ('9',FLDID9,FLDTAG9,FLDTAGA9),      
    ('10',FLDID10,FLDTAG10,FLDTAGA10),      
    ('11',FLDID11,FLDTAG11,FLDTAGA11),      
    ('12',FLDID12,FLDTAG12,FLDTAGA12),         
    ('13',FLDID13,FLDTAG13,FLDTAGA13),      
    ('14',FLDID14,FLDTAG14,FLDTAGA14),      
    ('15',FLDID15,FLDTAG15,FLDTAGA15)      
) c2 (Id,FLDID,FLDTAG,FLDTAGA) where c.COB=@COB  ;        
 END 
 

GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCOBEXTReg2') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE QCOBEXTReg2
end
GO
CREATE PROCEDURE [dbo].[QCOBEXTReg2] (@COB Varchar(10) )      
AS      
 BEGIN      
select  CAST(0 As Bit) ProcessFlag,c2.Id,c.COB,c2.FLDID,c2.FLDTAG,c2.FLDTAGA  from COBEXT c       
 cross apply    
(    
  values     
    ('1',FLDID1,FLDTAG1,FLDTAGA1),    
    ('2',FLDID2,FLDTAG2,FLDTAGA2),    
    ('3',FLDID3,FLDTAG3,FLDTAGA3),    
    ('4',FLDID4,FLDTAG4,FLDTAGA4),    
    ('5',FLDID5,FLDTAG5,FLDTAGA5),    
    ('6',FLDID6,FLDTAG6,FLDTAGA6),    
    ('7',FLDID7,FLDTAG7,FLDTAGA7),    
    ('8',FLDID8,FLDTAG8,FLDTAGA8),    
    ('9',FLDID9,FLDTAG9,FLDTAGA9),    
    ('10',FLDID10,FLDTAG10,FLDTAGA10),    
    ('11',FLDID11,FLDTAG11,FLDTAGA11),    
    ('12',FLDID12,FLDTAG12,FLDTAGA12),       
    ('13',FLDID13,FLDTAG13,FLDTAGA13),    
    ('14',FLDID14,FLDTAG14,FLDTAGA14),    
    ('15',FLDID15,FLDTAG15,FLDTAGA15)    
) c2 (Id,FLDID,FLDTAG,FLDTAGA) where c.COB=@COB  ;      
 END 
 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_Drop_GenCon') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE SP_Drop_GenCon
end
GO
CREATE Procedure  SP_Drop_GenCon (@COB varchar(10),@ORDERNO varchar(10) )          
as          
 begin          
  Delete From GenCon Where COB=@COB and ORDERNO=@ORDERNO  ;          
 end 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_Drop_GenEx') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE SP_Drop_GenEx
end
GO
 CREATE Procedure  SP_Drop_GenEx (@COB varchar(10),@ORDERNO varchar(10) )        
as        
 begin        
  Delete From Genex Where COB=@COB and ORDERNO=@ORDERNO  ;        
 end 
 
 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGenConDlg_GenEx') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE QGenConDlg_GenEx       
end
GO
CREATE PROCEDURE QGenConDlg_GenEx       
(@COB as varchar(10),@OrderNo as varchar(10) )      
AS      
BEGIN      
 SET NOCOUNT ON;      
    SELECT * FROM GenEx   WHERE  OrderNo=@OrderNo and COB=@COB;       
END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGenConDlg_GenCla') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QGenConDlg_GenCla       
end
GO
CREATE PROCEDURE QGenConDlg_GenCla       
 (@COB as varchar(10),@OrderNo as varchar(10) )      
AS      
BEGIN      
 SET NOCOUNT ON;      
      
    SELECT * FROM GenCla  WHERE  OrderNo=@OrderNo and COB=@COB;       
END

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_Drop_GenCla') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE SP_Drop_GenCla 
end
GO
CREATE Procedure  SP_Drop_GenCla (@COB varchar(10),@ORDERNO varchar(10) )      
as      
 begin      
  Delete From GenCla Where COB=@COB and ORDERNO=@ORDERNO  ;      
 end 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_INSERT_ScaleTab') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE SP_INSERT_ScaleTab 
end
GO
CREATE PROCEDURE SP_INSERT_ScaleTab (@COB VARCHAR(10), @Basis  VARCHAR(1), @NOP FLOAT, @Pct FLOAT, @Last_Opr  VARCHAR(10))      
AS      
 BEGIN      
  INSERT ScaleTab  (COB,Basis ,NOP,Pct,Last_Opr,Last_Update)  
  SELECT @COB, @Basis, @NOP,@Pct, @Last_Opr,GETDATE()    
        
 END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_Drop_ScaleTab') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE SP_Drop_ScaleTab 
end
GO
CREATE Procedure  SP_Drop_ScaleTab (@COB varchar(10),@Basis varchar(1),@NOP float )    
as    
 begin    
  Delete From ScaleTab Where COB=@COB and Basis=@Basis and NOP=@NOP ;    
 end 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_INSERT_FLScaleTab') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE SP_INSERT_FLScaleTab 
end
GO
 CREATE PROCEDURE SP_INSERT_FLScaleTab (@COB VARCHAR(10), @FLValue FLOAT, @FLPct FLOAT, @Last_Opr  VARCHAR(10))    
AS    
 BEGIN    
  INSERT FLScaleTab  (COB,FLValue,FLPct,Last_Opr,Last_Update)
  SELECT @COB, @FLValue, @FLPct, @Last_Opr,GETDATE()  
      
 END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_Drop_FLScale') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE SP_Drop_FLScale 
end
GO
CREATE Procedure  SP_Drop_FLScale (@COB varchar(10),@FLValue float )    
as    
 begin    
  Delete From FLScaleTab Where COB=@COB and FLValue=@FLValue ;    
 end 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_INSERT_RLTable') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE SP_INSERT_RLTable 
end
GO
 CREATE PROCEDURE SP_INSERT_RLTable (@COB VARCHAR(10), @Lower FLOAT, @Upper FLOAT, @Last_Opr  VARCHAR(10))  
AS  
 BEGIN  
  INSERT RLTable (COB, Lower, Upper, Basis,Last_Opr,Last_Update)   
  SELECT @COB, @Lower, @Upper, 'R', @Last_Opr,GETDATE()
    
 END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_Drop_Range]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[SP_Drop_Range]
end
GO
Create Procedure [dbo].[SP_Drop_Range] (@COB varchar(10),@Lower float,@Upper float,@Basis varchar(50))  
as  
 begin  
  Delete From RLTable Where COB=@COB and Lower=@Lower and Upper=@Upper and Basis=@Basis;  
 end  

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_Drop_COB]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[SP_Drop_COB] 
end
GO
Create Procedure [dbo].[SP_Drop_COB] (@COB varchar(10))  
as  
 begin  
  Delete From COB Where COB=@COB;  
 end  

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QTOR') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE QTOR
end
GO
CREATE PROCEDURE QTOR(@TOR VARCHAR(10) )      
AS      
 BEGIN      
   Select TOR, Description from TOR Where TOR.TOR Like @TOR+'%'
 END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_Drop_RClass') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE SP_Drop_RClass
end
GO
Create Procedure [dbo].[SP_Drop_RClass] (@TOC varchar(10),@TOR varchar(10))      
as      
 begin      
  Delete From RClass Where TOC=@TOC and  TOR=@TOR;      
 end  
 
 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QSection2') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QSection2
end
GO
CREATE PROCEDURE [dbo].[QSection2] (@TOC Varchar(10),@Section  Varchar(10))        
AS        
BEGIN        
SELECT CAST(0 As Bit) ProcessFlag ,*   
from Section   
where TOC=@TOC and Section=@Section  ;        
END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QSectDlg_Section') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QSectDlg_Section         
end
GO
CREATE PROCEDURE QSectDlg_Section         
(@TOC as varchar(10),@Section as varchar(10) )        
AS        
BEGIN        
SET NOCOUNT ON;        
   SELECT * FROM section  WHERE  TOC=@TOC and Section=@Section;         
END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_Drop_Section') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE SP_Drop_Section
end
GO
Create Procedure [dbo].[SP_Drop_Section] (@TOC varchar(10),@Section varchar(10))        
as        
begin        
 Delete From Section Where TOC=@TOC and  Section=@Section;        
end 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QRRight') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QRRight 
end
GO
create procedure QRRight (@TOC as varchar(10),@RCode as varchar(10))  
as  
select top 1 * from RenewalRight where toc = @TOC and RCode=@RCode

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_Drop_RRights') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE SP_Drop_RRights
end
GO
 Create Procedure [dbo].[SP_Drop_RRights] (@TOC varchar(10),@RCode varchar(10))      
as      
 begin      
  Delete From  RenewalRight Where TOC=@TOC and  RCode=@RCode;      
 end 
 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QRRule') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE QRRule 
end
GO
CREATE procedure QRRule (@RID as int)   
as    
select top 1 * from RenewalRule where RID = @RID 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QPScale') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE QPScale
end
GO
CREATE PROCEDURE [dbo].[QPScale] (@TOC Varchar(30) )        
AS        
BEGIN        
 SELECT  CAST(0 As Bit) ProcessFlag,* FROM PScale WHERE TOC=@TOC ;        
END

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_INSERT_PScale') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE SP_INSERT_PScale 
end
GO
 CREATE PROCEDURE SP_INSERT_PScale (@TOC VARCHAR(10), @Basis  VARCHAR(1), @NOP FLOAT, @Pct FLOAT, @Last_Opr  VARCHAR(10))        
AS        
 BEGIN        
  INSERT PScale  (TOC,Basis ,NOP,Pct,Last_Opr,Last_Update)    
  SELECT @TOC, @Basis, @NOP,@Pct, @Last_Opr,GETDATE()      
          
 END 
 
 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_Drop_PScale') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE SP_Drop_PScale
end
GO
  Create Procedure [dbo].[SP_Drop_PScale] (@TOC varchar(10),@Basis varchar(1),@NOP float)      
as      
 begin      
  Delete From  PScale Where TOC=@TOC and  Basis=@Basis and NOP =@NOP;      
 end 
 
 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_Drop_RenewalRule') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE SP_Drop_RenewalRule
end
GO
  Create Procedure [dbo].[SP_Drop_RenewalRule] (@TOC varchar(10),@RID int)      
as      
 begin      
  Delete From  RenewalRule Where TOC=@TOC and  RID=@RID;      
 end 
 
 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QPFLSCALE') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE QPFLSCALE
end
GO
  CREATE PROCEDURE [dbo].[QPFLSCALE] (@TOC Varchar(30) )        
AS        
 BEGIN        
  SELECT CAST(0 As Bit) ProcessFlag,* FROM PFLSCALE WHERE TOC=@TOC ;        
 END 
 
 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_INSERT_PFLSCALE') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE SP_INSERT_PFLSCALE 
end
GO
 CREATE PROCEDURE SP_INSERT_PFLSCALE (@TOC VARCHAR(10), @FLValue FLOAT, @FLPct FLOAT, @Last_Opr  VARCHAR(10))      
AS      
 BEGIN      
  INSERT PFLSCALE  (TOC,FLValue,FLPct,Last_Opr,Last_Update)  
  SELECT @TOC, @FLValue, @FLPct, @Last_Opr,GETDATE()    
 END 
 
 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_Drop_PFLScale') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE SP_Drop_PFLScale
end
GO
Create Procedure [dbo].[SP_Drop_PFLScale] (@TOC varchar(10),@FLValue float)      
as      
begin      
 Delete From  PFLScale Where TOC=@TOC and  FLValue=@FLValue  ;      
end 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QBRRule') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QBRRule 
end
GO
CREATE procedure QBRRule (@TOC varchar(10),@Branch varchar(10),@BizMapID varchar(10))     
as      
select top 1 * from BRRULE where TOC = @TOC  and Branch=@Branch and BizMapID=@BizMapID;

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_Drop_BRRule') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE SP_Drop_BRRule
end
GO
  Create Procedure [dbo].[SP_Drop_BRRule] (@TOC varchar(10),@Branch varchar(10),@BizMapID varchar(10))      
as      
 begin      
  Delete From  BRRule Where TOC=@TOC and  Branch=@Branch  and BizMapID =@BizMapID;      
 end 
 
 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QALRule') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE QALRule 
end
GO
create procedure QALRule (@TOC as varchar(10),@Branch as varchar(10),@Segment as varchar(10))    
as    
select top 1 * from ALRule where toc = @TOC and Branch=@Branch and Segment=@Segment;

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_Drop_ALRule') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE SP_Drop_ALRule
end
GO
  Create Procedure [dbo].[SP_Drop_ALRule] (@TOC varchar(10),@Branch varchar(10),@Segment varchar(10))      
as      
 begin      
  Delete From  ALRule Where TOC=@TOC and  Branch=@Branch  and Segment =@Segment;      
 end 
 
 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_DefCLA') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE SP_DefCLA
end
GO
CREATE PROCEDURE SP_DefCLA(@TOC varchar(10),@SECTION varchar(10))            
AS            
 BEGIN            
 select case when b.ProcessFlag ='1' then  b.ProcessFlag else  '0' end as ProcessFlag ,      
a.OrderNo,case when b.SHORTDESC  IS NULL  then a.SHORTDESC else b.SHORTDESC end as  ShortDesc  ,      
case when b.ShortDesc_1   IS NULL  then a.ShortDesc_1 else b.ShortDesc_1 end as  ShortDesc_1,      
case when b.DESCRIPTION   IS NULL  then a.DESCRIPTION else b.DESCRIPTION end as   DESCRIPTION ,      
case when b.DESCRIPTION_1  IS  null then a.DESCRIPTION_1 else b.DESCRIPTION_1 end as  DESCRIPTION_1,      
b.SECTION, case when b.CompulsoryF   IS  null then 0 else b.CompulsoryF   end as  CompulsoryF       
from       
(select TOC.TOC,OrderNo,ShortDesc, ShortDesc_1, GenCla.Description, GenCla.Description_1       
from GenCla, TOC where GenCla.COB=TOC.COB)a       
left join       
(SELECT Cast(1 As Bit)as ProcessFlag,toc,OrderNo,ShortDesc, ShortDesc_1, Description, Description_1, Section, CompulsoryF       
from DefCLA a where  a.SECTION=@SECTION )b on a.ORDERNO=b.ORDERNO        
and a.TOC=b.TOC  where a.toc=@TOC         
              
 END
 
 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_DefCon_GenCon') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE SP_DefCon_GenCon
end
GO
create PROCEDURE SP_DefCon_GenCon(@TOC varchar(10),@SECTION varchar(10))          
AS          
 BEGIN          
 select case when b.ProcessFlag ='1' then  b.ProcessFlag else  '0' end as ProcessFlag ,    
a.OrderNo,case when b.SHORTDESC  IS NULL  then a.SHORTDESC else b.SHORTDESC end as  ShortDesc  ,    
case when b.ShortDesc_1   IS NULL  then a.ShortDesc_1 else b.ShortDesc_1 end as  ShortDesc_1,    
case when b.DESCRIPTION   IS NULL  then a.DESCRIPTION else b.DESCRIPTION end as   DESCRIPTION ,    
case when b.DESCRIPTION_1  IS  null then a.DESCRIPTION_1 else b.DESCRIPTION_1 end as  DESCRIPTION_1,    
b.SECTION, case when b.CompulsoryF   IS  null then 0 else b.CompulsoryF   end as  CompulsoryF     
from     
(select TOC.TOC,OrderNo,ShortDesc, ShortDesc_1, GenCon.Description, GenCon.Description_1     
from GenCon, TOC where GenCon.COB=TOC.COB)a     
left join     
(SELECT Cast(1 As Bit)as ProcessFlag,toc,OrderNo,ShortDesc, ShortDesc_1, Description, Description_1, Section, CompulsoryF     
from DefCon a where  a.SECTION=@SECTION )b on a.ORDERNO=b.ORDERNO      
and a.TOC=b.TOC  where a.toc=@TOC       
            
 END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_DefEx_GENEX') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE SP_DefEx_GENEX
end
GO
CREATE PROCEDURE SP_DefEx_GENEX(@TOC varchar(10),@SECTION varchar(10))          
AS          
 BEGIN          
 select case when b.ProcessFlag ='1' then  b.ProcessFlag else  '0' end as ProcessFlag ,    
a.OrderNo,case when b.SHORTDESC  IS NULL  then a.SHORTDESC else b.SHORTDESC end as  ShortDesc  ,    
case when b.ShortDesc_1   IS NULL  then a.ShortDesc_1 else b.ShortDesc_1 end as  ShortDesc_1,    
case when b.DESCRIPTION   IS NULL  then a.DESCRIPTION else b.DESCRIPTION end as   DESCRIPTION ,    
case when b.DESCRIPTION_1  IS  null then a.DESCRIPTION_1 else b.DESCRIPTION_1 end as  DESCRIPTION_1,    
b.SECTION, case when b.CompulsoryF   IS  null then 0 else b.CompulsoryF   end as  CompulsoryF     
from     
(select TOC.TOC,OrderNo,ShortDesc, ShortDesc_1, GENEX.Description, GENEX.Description_1     
from GENEX, TOC where GENEX.COB=TOC.COB)a     
left join     
(SELECT Cast(1 As Bit)as ProcessFlag,toc,OrderNo,ShortDesc, ShortDesc_1, Description, Description_1, Section, CompulsoryF     
from DefEx a where  a.SECTION=@SECTION )b on a.ORDERNO=b.ORDERNO      
and a.TOC=b.TOC  where a.toc=@TOC       
            
 END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_DefCLA_GenCla') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE SP_DefCLA_GenCla
end
GO
CREATE PROCEDURE SP_DefCLA_GenCla(@TOC varchar(10),@SECTION varchar(10))            
AS            
 BEGIN            
 select case when b.ProcessFlag ='1' then  b.ProcessFlag else  '0' end as ProcessFlag ,      
a.OrderNo,case when b.SHORTDESC  IS NULL  then a.SHORTDESC else b.SHORTDESC end as  ShortDesc  ,      
case when b.ShortDesc_1   IS NULL  then a.ShortDesc_1 else b.ShortDesc_1 end as  ShortDesc_1,      
case when b.DESCRIPTION   IS NULL  then a.DESCRIPTION else b.DESCRIPTION end as   DESCRIPTION ,      
case when b.DESCRIPTION_1  IS  null then a.DESCRIPTION_1 else b.DESCRIPTION_1 end as  DESCRIPTION_1,      
b.SECTION, case when b.CompulsoryF   IS  null then 0 else b.CompulsoryF   end as  CompulsoryF       
from       
(select TOC.TOC,OrderNo,ShortDesc, ShortDesc_1, GenCla.Description, GenCla.Description_1       
from GenCla, TOC where GenCla.COB=TOC.COB)a       
left join       
(SELECT Cast(1 As Bit)as ProcessFlag,toc,OrderNo,ShortDesc, ShortDesc_1, Description, Description_1, Section, CompulsoryF       
from DefCLA a where  a.SECTION=@SECTION )b on a.ORDERNO=b.ORDERNO        
and a.TOC=b.TOC  where a.toc=@TOC         
              
 END 

  
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_SEARCH_COB') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE SP_SEARCH_COB 
end
GO
 CREATE PROCEDURE SP_SEARCH_COB (@COB VARCHAR(10), @DESCRIPTION VARCHAR(255))
AS
	BEGIN
		SELECT CAST(0 AS BIT) PROCESSFLAG, COB, DESCRIPTION, LAST_OPR, LAST_UPDATE FROM COB WHERE (COB LIKE @COB + '%') AND (DESCRIPTION LIKE @DESCRIPTION + '%')
	END

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QRange') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE QRange
end
GO
CREATE PROCEDURE [dbo].[QRange] (@COB Varchar(30) )      
AS      
 BEGIN      
  SELECT CAST(0 As Bit) ProcessFlag, * FROM RLTable WHERE COB=@COB ;      
 END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QFLScale') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE QFLScale
end
GO
CREATE PROCEDURE [dbo].[QFLScale] (@COB Varchar(30) )      
AS      
 BEGIN      
  SELECT CAST(0 As Bit) ProcessFlag,* FROM FLScaleTab WHERE COB=@COB ;      
 END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QScaleTab') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QScaleTab
end
GO
CREATE PROCEDURE [dbo].[QScaleTab] (@COB Varchar(30) )        
AS        
 BEGIN        
  SELECT  CAST(0 As Bit) ProcessFlag,* FROM ScaleTab WHERE COB=@COB ;        
 END   

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGENCla') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QGENCla
end
GO
CREATE PROCEDURE [dbo].[QGENCla] (@COB Varchar(30) )    
AS    
 BEGIN    
  SELECT CAST(0 As Bit) ProcessFlag,* FROM GENCla WHERE COB=@COB ;    
 END   

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGENEX') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE QGENEX
end
GO
CREATE PROCEDURE [dbo].[QGENEX] (@COB Varchar(30) )    
AS    
 BEGIN    
  SELECT CAST(0 As Bit) ProcessFlag,* FROM GENEX WHERE COB=@COB ;    
 END    

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGENCON') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QGENCON
end
GO
CREATE PROCEDURE [dbo].[QGENCON] (@COB Varchar(30) )    
AS    
 BEGIN    
  SELECT CAST(0 As Bit) ProcessFlag,* FROM GENCON WHERE COB=@COB ;    
 END    

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCOBReg') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QCOBReg
end
GO
CREATE PROCEDURE [dbo].[QCOBReg] (@COB Varchar(10) )        
AS        
 BEGIN        
select  CAST(0 As Bit) ProcessFlag,c2.Id,c.COB,c2.FLDID,c2.FLDTAG,c2.FLDTAGA  from COB c         
 cross apply      
(      
  values       
    ('1',FLDID1,FLDTAG1,FLDTAGA1),      
    ('2',FLDID2,FLDTAG2,FLDTAGA2),      
    ('3',FLDID3,FLDTAG3,FLDTAGA3),      
    ('4',FLDID4,FLDTAG4,FLDTAGA4),      
    ('5',FLDID5,FLDTAG5,FLDTAGA5),      
    ('6',FLDID6,FLDTAG6,FLDTAGA6),      
    ('7',FLDID7,FLDTAG7,FLDTAGA7),      
    ('8',FLDID8,FLDTAG8,FLDTAGA8),      
    ('9',FLDID9,FLDTAG9,FLDTAGA9),      
    ('10',FLDID10,FLDTAG10,FLDTAGA10),      
    ('11',FLDID11,FLDTAG11,FLDTAGA11),      
    ('12',FLDID12,FLDTAG12,FLDTAGA12),         
    ('13',FLDID13,FLDTAG13,FLDTAGA13),      
    ('14',FLDID14,FLDTAG14,FLDTAGA14),      
    ('15',FLDID15,FLDTAG15,FLDTAGA15)      
) c2 (Id,FLDID,FLDTAG,FLDTAGA) where c.COB=@COB and  FLDID <>'';        
 END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCOBEXTReg') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QCOBEXTReg
end
GO
CREATE PROCEDURE [dbo].[QCOBEXTReg] (@COB Varchar(10) )    
AS    
 BEGIN    
select  CAST(0 As Bit) ProcessFlag,c2.Id,c.COB,c2.FLDID,c2.FLDTAG,c2.FLDTAGA  from COBEXT c     
 cross apply  
(  
  values   
    ('1',FLDID1,FLDTAG1,FLDTAGA1),  
    ('2',FLDID2,FLDTAG2,FLDTAGA2),  
    ('3',FLDID3,FLDTAG3,FLDTAGA3),  
    ('4',FLDID4,FLDTAG4,FLDTAGA4),  
    ('5',FLDID5,FLDTAG5,FLDTAGA5),  
    ('6',FLDID6,FLDTAG6,FLDTAGA6),  
    ('7',FLDID7,FLDTAG7,FLDTAGA7),  
    ('8',FLDID8,FLDTAG8,FLDTAGA8),  
    ('9',FLDID9,FLDTAG9,FLDTAGA9),  
    ('10',FLDID10,FLDTAG10,FLDTAGA10),  
    ('11',FLDID11,FLDTAG11,FLDTAGA11),  
    ('12',FLDID12,FLDTAG12,FLDTAGA12),     
    ('13',FLDID13,FLDTAG13,FLDTAGA13),  
    ('14',FLDID14,FLDTAG14,FLDTAGA14),  
    ('15',FLDID15,FLDTAG15,FLDTAGA15)  
) c2 (Id,FLDID,FLDTAG,FLDTAGA) where c.COB=@COB and c2.FLDID<>'';    
 END    

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_Search_TOC') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE SP_Search_TOC
end
GO
 CREATE Procedure [dbo].[SP_Search_TOC](@TOC varchar(10), @Description varchar(50))          
as          
Select CAST(0 As Bit) ProcessFlag,  
T.TOC,T.DESCRIPTION AS TOCDescription,  
T.COB,C.DESCRIPTION AS COBDescription,  
T.POLICYTITLE,T.POLICYTITLE_1,  
T.TOCGroup, TG.DESCRIPTION TOCGDESCRIPTION ,T.REGID,T.AllowedF,T.Last_Opr,T.Last_Update  
From TOC T LEFT JOIN COB C ON T.COB=C.COB  
LEFT JOIN TOCGroup TG ON  T.TOCGroup=TG.TOCGROUP  
Where (T.TOC like @TOC + '%') And (T.Description like @Description + '%' )   

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QTOC_AR') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QTOC_AR
end
GO
create PROCEDURE [dbo].[QTOC_AR] (@TOC Varchar(10))                
AS                
 BEGIN                
  Select CAST(0 As Bit) ProcessFlag , ALRule.*,Branch.Name as BName, Segment.Description as SDescription from ALRule Left join Branch On (Branch.Branch=ALRule.Branch) Left Join Segment On (Segment.Segment=ALRule.Segment) where ALRule.TOC = @TOC;  
         
 END 

  
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QTOC_BRRule2') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QTOC_BRRule2
end
GO
 CREATE PROCEDURE [dbo].[QTOC_BRRule2] (@TOC Varchar(10))                      
AS                      
 BEGIN                      
          
  
Select CAST(0 As Bit) ProcessFlag ,BRRule.TOC, BRRule.Branch, coalesce(Branch.Name,'<All Branches>') as BranchName,         
coalesce( BizMap.ID ,'<All>')  as BizMapID,coalesce(BizMap.Description,'<All Business Maps>') as BizMapName,        
BRRule.*   
 from BRRule Left join Branch on (Branch.Branch=BRRule.Branch)         
 Left Join BizMap on (BizMap.ID=BRRule.BizMapID) where BRRule.TOC =@TOC;    
   
--Select CAST(0 As Bit) ProcessFlag ,BRRule.TOC, BRRule.Branch, coalesce(Branch.Name,'<All Branches>') as BranchName,         
--coalesce( BizMap.ID ,'<All>')  as BizMapID,coalesce(BizMap.Description,'<All Business Maps>') as BizMapName,        
--(ExtraCostDesc_1 + ' - '+  convert (varchar(100), ExtraCost_1 )) as ExtraCost_1,        
--(ExtraCostDesc_2 + ' - '+  convert (varchar(100), ExtraCost_2 )) as ExtraCost_2,        
--(ExtraCostDesc_3 + ' - '+  convert (varchar(100), ExtraCost_3 )) as ExtraCost_3,        
--(ExtraCostDesc_4 + ' - '+  convert (varchar(100), ExtraCost_4 )) as ExtraCost_4,        
--(ExtraCostDesc_5 + ' - '+  convert (varchar(100), ExtraCost_5 )) as ExtraCost_5,        
--(ExtraCostDesc_6 + ' - '+  convert (varchar(100), ExtraCost_6 )) as ExtraCost_6,          
--Branch.Last_Opr,Branch.Last_Update        
-- from BRRule Left join Branch on (Branch.Branch=BRRule.Branch)         
-- Left Join BizMap on (BizMap.ID=BRRule.BizMapID) where BRRule.TOC = @TOC;        
               
 END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QTOC_PFLScale]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE [dbo].[QTOC_PFLScale] 
end
GO
 create PROCEDURE [dbo].[QTOC_PFLScale] (@TOC Varchar(10))                
AS                
 BEGIN                
 SELECT CAST(0 As Bit) ProcessFlag ,*           
 from PFLScale           
 where TOC=@TOC;                
 END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QTOC_PScale]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[QTOC_PScale] 
end
GO
 CREATE PROCEDURE [dbo].[QTOC_PScale] (@TOC Varchar(10))                
AS                
 BEGIN                
 SELECT CAST(0 As Bit) ProcessFlag ,*           
 from PScale           
 where TOC=@TOC;                
 END

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QTOC_RenewalRule]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[QTOC_RenewalRule] 
end
GO
 CREATE PROCEDURE [dbo].[QTOC_RenewalRule] (@TOC Varchar(10), @PolicyType Varchar(10), @Segment Varchar(10))              
AS              
 BEGIN              
 SELECT CAST(0 As Bit) ProcessFlag ,*         
 from RenewalRule         
 where TOC=@TOC and PolicyType like @PolicyType +'%' and  Segment like @Segment +'%' ;              
 END   

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QTOC_RRight]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[QTOC_RRight] 
end
GO
 CREATE PROCEDURE [dbo].[QTOC_RRight] (@TOC Varchar(10) )            
AS            
 BEGIN            
 SELECT CAST(0 As Bit) ProcessFlag ,*       
 from RenewalRight       
 where TOC=@TOC ;            
 END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QTOC_Section]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[QTOC_Section] 
end
GO
 CREATE PROCEDURE [dbo].[QTOC_Section] (@TOC Varchar(10) )          
AS          
 BEGIN          
 SELECT CAST(0 As Bit) ProcessFlag ,*     
 from Section     
 where TOC=@TOC ;          
 END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QTOC_RClass]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE [dbo].[QTOC_RClass] 
end
GO
 CREATE PROCEDURE [dbo].[QTOC_RClass] (@TOC Varchar(10) )        
AS        
 BEGIN        
 SELECT CAST(0 As Bit) ProcessFlag ,*,TOR.Description     
 from RClass,TOR     
 where  TOR.TOR = RClass.TOR and RClass.TOC=@TOC ;        
 END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QPDOCLIST]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE [dbo].[QPDOCLIST] 
end
GO
 CREATE PROCEDURE [dbo].[QPDOCLIST] (@TOC Varchar(10) )    
AS    
 BEGIN    
  SELECT CAST(0 As Bit) ProcessFlag,* FROM PDOCLIST WHERE TOC=@TOC ;    
 END   

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QRRCode]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[QRRCode] 
end
GO
CREATE PROCEDURE [dbo].[QRRCode] (@RCode Varchar(10),@TOC Varchar(10) )    
AS    
 BEGIN    
  Select RR.*, Tp.Description as PrevTOPRODesc, Tc.Description as TOPRODesc, Rp.Description as PrevCodeDesc,
 Rc.Description as CodeDesc from RenewalRightCode RR  
 Left Join TOPRO Tp
  On (Tp.TOPRO=RR.PrevTOPRO) 
  Left Join TOPRO Tc On (Tc.TOPRO=RR.TOPRO)
   Left Join RateTab Rp On (Rp.Code=RR.PrevCode) 
   Left Join RateTab Rc On (Rc.Code=RR.Code)
    Where RR.RCode=@RCode and RR.TOC=@TOC;
 END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_INSERT_RClass') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE SP_INSERT_RClass
end
GO
  CREATE PROCEDURE SP_INSERT_RClass(@TOC VARCHAR(10), @TOR  VARCHAR(10), @CATEGORY  VARCHAR(1), @Last_Opr  VARCHAR(10))      
AS      
 BEGIN      
  INSERT RClass  (TOC,TOR ,CATEGORY,Last_Opr,Last_Update)  
  SELECT @TOC, @TOR, @CATEGORY,  @Last_Opr,GETDATE()    
        
 END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QSection]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE [dbo].[QSection] 
end
GO
 CREATE PROCEDURE [dbo].[QSection] (@TOC Varchar(10) )      
AS      
 BEGIN      
 SELECT CAST(0 As Bit) ProcessFlag ,* 
 from Section 
 where TOC=@TOC ;      
 END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QBRRuleMin') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE QBRRuleMin 
end
GO
 CREATE procedure QBRRuleMin (@TOC varchar(10),@Branch varchar(10),@BizMapID varchar(10) )       
as        
select  * from BRRuleMin where TOC = @TOC  and Branch=@Branch and BizMapID=@BizMapID;

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_Search_TOR]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[SP_Search_TOR]
end
GO
CREATE Procedure [dbo].[SP_Search_TOR](@TOR varchar(10), @Description varchar(50))        
as        
Select CAST(0 As Bit) ProcessFlag, *
from TOR T
Where (T.TOR like @TOR + '%') And (T.Description like @Description + '%' ) 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QTOR_COL]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[QTOR_COL] 
end
GO
CREATE PROCEDURE [dbo].[QTOR_COL] (@TOR Varchar(10) )        
AS        
 BEGIN        
  Select CAST(0 As Bit) ProcessFlag, COLTAB.COL,COLTAB.DESCRIPTION,COL.TOR from COL,COLTAB where COL.COL=COLTAB.COL AND COL.TOR = @TOR Order By COLTAB.COL
 END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QTOR_PremiumClass]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[QTOR_PremiumClass] 
end
GO
 CREATE PROCEDURE [dbo].[QTOR_PremiumClass] (@TOR Varchar(10) )        
AS        
 BEGIN        
  Select CAST(0 As Bit) ProcessFlag, PClass.*,TOI.Description from PClass,TOI where PClass.TOR = @TOR and TOI.TOI = PClass.TOI order by PClass.TOI
 END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QTOR_SubRisk]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE [dbo].[QTOR_SubRisk] 
end
GO
 CREATE PROCEDURE [dbo].[QTOR_SubRisk] (@TOR Varchar(10) )        
AS        
 BEGIN        
 Select CAST(0 As Bit) ProcessFlag, TOR.TOR, TOR.Description from TORSUB, TOR where TOR.TOR=TORSUB.TORSUB AND TORSUB.TOR = @TOR
 END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QTOR_Deductible]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[QTOR_Deductible] 
end
GO
 CREATE PROCEDURE [dbo].[QTOR_Deductible] (@TOR Varchar(10) )      
AS      
 BEGIN      
 SELECT CAST(0 As Bit) ProcessFlag, DCODE, PCTTSI, PCTCL, Currency, +' ' + FIXEDMIN as 'MinLimit',
 Currency + ' ' + FIXEDMAX as 'MaxLimit', IUNIT, REMARKS, AllowedF from DEDTAB  
 where TOR = @TOR
 END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_Search_TOI]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [dbo].[SP_Search_TOI]
end
GO
 CREATE Procedure [dbo].[SP_Search_TOI](@TOI varchar(10), @Description varchar(50))        
as        
Select CAST(0 As Bit) ProcessFlag, 
coalesce(TOI,'') as TOI,
coalesce(DESCRIPTION, '') as DESCRIPTION,
coalesce(AllowedF,0) as AllowedF,
coalesce(ADJUSTABLE,0) as ADJUSTABLE,
coalesce(AGREEDVALF,0) as AGREEDVALF, 
coalesce(PCTADJ,0) as PCTADJ, 
coalesce(DISPMODEL,'') as DISPMODEL,
coalesce(DEDUCTIBLEF,0) as DEDUCTIBLEF,
coalesce(ADJMETHOD,'') as ADJMETHOD,
Last_Opr,
Last_Update,
coalesce(ICPSF,0) as ICPSF
from TOI T
Where (T.TOI like @TOI + '%') And (T.Description like @Description + '%' ) 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QTOI_KOL]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[QTOI_KOL] 
end
GO
CREATE PROCEDURE [dbo].[QTOI_KOL] (@TOI Varchar(10) )      
AS      
BEGIN      
SELECT CAST(0 As Bit) ProcessFlag, * from KOL where TOI= @TOI
END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QTOI_NOC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[QTOI_NOC] 
end
GO
CREATE PROCEDURE [dbo].[QTOI_NOC] (@TOI Varchar(10) )      
AS      
BEGIN      
SELECT CAST(0 As Bit) ProcessFlag, * from NOC where TOI= @TOI
END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QTOI_TOIVALUE]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE [dbo].[QTOI_TOIVALUE] 
end
GO
CREATE PROCEDURE [dbo].[QTOI_TOIVALUE] (@TOI Varchar(10), @Month int, @Year int )      
AS      
BEGIN      
SELECT CAST(0 As Bit) ProcessFlag, * from TOIVALUE
where TOI = @TOI and [Month] = @Month and [Year] = @Year
END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_Search_DocList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[SP_Search_DocList]
end
GO
create Procedure [dbo].[SP_Search_DocList](@TOI varchar(10), @NOC varchar(10))        
as        
Select CAST(0 As Bit) ProcessFlag, * from DocList
where TOI = @TOI and NOC = @NOC

GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QTOI_KOLValue]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[QTOI_KOLValue] 
end
GO
CREATE PROCEDURE [dbo].[QTOI_KOLValue] (@KOL Varchar(50), @TOI Varchar(10) )      
AS      
BEGIN      
SELECT CAST(0 As Bit) ProcessFlag, KOLValueID, KOL, TOI, Cost, A.Last_Opr, A.Last_Update, C.Name as 'BranchDesc'--, A.Currency  
from KOLValue A
--Join Currency B on A.Currency = B.Currency
Join Branch C on A.Branch = C.Branch
where KOL = @KOL and TOI = @TOI
END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_Search_RateTab]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[SP_Search_RateTab]
end
GO
CREATE Procedure [dbo].[SP_Search_RateTab](@CODE varchar(10), @Description varchar(50))        
as        
Select CAST(0 As Bit) ProcessFlag, *
from RATETAB R
Where (R.CODE like @CODE + '%') And (R.Description like @Description + '%' ) 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QRate_RiskCoverage]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE [dbo].[QRate_RiskCoverage] 
END
GO
CREATE PROCEDURE [dbo].[QRate_RiskCoverage] (@CODE Varchar(10) )      

AS      
 BEGIN      
 SELECT CAST(0 As Bit) ProcessFlag, CODE, TOR, PORTION,DESCRIPTION,NOREFUNDF,Last_Opr,Last_Update from RATECOV
 where CODE = @CODE 
 END 

  
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QRate_DiscTab]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE [dbo].[QRate_DiscTab] 
end
GO
 CREATE PROCEDURE [dbo].[QRate_DiscTab] (@CODE Varchar(10) )      

AS      
 BEGIN      
 SELECT CAST(0 As Bit) ProcessFlag, CODE, DNO, DESCRIPTION,DISCOUNT,Last_Opr,Last_Update from DISTAB
 where CODE = @CODE 
 END

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QRate_MinPrem]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE [dbo].[QRate_MinPrem] 
end
GO
 CREATE PROCEDURE [dbo].[QRate_MinPrem] (@CODE Varchar(10) )      

AS      
 BEGIN      
 SELECT CAST(0 As Bit) ProcessFlag, CODE,Branch,TOC,Source,Currency,SType,MPremium,FPremiumF,Last_Opr,Last_Update from RateMin
 where CODE = @CODE 
 END 

  
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QRate_Ratcon]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[QRate_Ratcon] 
end
GO
 CREATE PROCEDURE [dbo].[QRate_Ratcon] (@CODE Varchar(10) )      
AS      
 BEGIN      
 SELECT CAST(0 As Bit) ProcessFlag, RATECON, CODE, coalesce(MinTSI, 0) +' - '+coalesce(MaxTSI, 0) as TSI, 
 coalesce(MinRate, 0) + ' - ' + coalesce(MaxRate, 0) as 'RATEP', 
 coalesce(MINPERIOD, 0) + ' - ' + coalesce(MAXPERIOD, 0) as 'Coverage',
 TEXCESS, ALLOWEDF, LOADING from RateCon where CODE = @CODE 
 END

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QRate_Period]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[QRate_Period] 
end
GO
CREATE PROCEDURE [dbo].[QRate_Period] (@CODE Varchar(10) )      
AS      
 BEGIN      
 SELECT CAST(0 As Bit) ProcessFlag, CODE,Basis,NOP,Pct,Last_Opr,Last_Update from RateIndemnity
 where CODE = @CODE 
 END 

  
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QRate_RATECON_M1]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE [dbo].[QRate_RATECON_M1] 
end
GO
 CREATE PROCEDURE [dbo].[QRate_RATECON_M1] (@CODE Varchar(10) )      
AS      
 BEGIN      
 SELECT CAST(0 As Bit) ProcessFlag, * from RATECON_M1 where CODE = @CODE 
 END

  
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QRate_RATECON_M2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[QRate_RATECON_M2] 
end
GO
 CREATE PROCEDURE [dbo].[QRate_RATECON_M2] (@CODE Varchar(10) )      
AS      
 BEGIN      
 SELECT CAST(0 As Bit) ProcessFlag, * from RATECON_M2 where CODE = @CODE 
 END

  
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QRate_RATECON_M3]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[QRate_RATECON_M3] 
end
GO
 CREATE PROCEDURE [dbo].[QRate_RATECON_M3] (@CODE Varchar(10) )      
AS      
 BEGIN      
 SELECT CAST(0 As Bit) ProcessFlag, * from RATECON_M3 where CODE = @CODE 
 END

  
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_DropRateDisc]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[SP_DropRateDisc] 
end
GO
   Create Procedure [dbo].[SP_DropRateDisc] (@CODE varchar(10), @DNO varchar(10))    
as    
 begin    
    Delete From DISTAB Where CODE=@CODE and DNO=@DNO;    
 end

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_DropRiskCov]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE [dbo].[SP_DropRiskCov] 
end
GO
 Create Procedure [dbo].[SP_DropRiskCov] (@CODE varchar(10), @TOR varchar(10))    

as    
 begin    
    Delete From RATECOV Where CODE=@CODE and TOR=@TOR;    
 end

  
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_DropMinPrem]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE [dbo].[SP_DropMinPrem] 
end
GO
 Create Procedure [dbo].[SP_DropMinPrem] (@CODE varchar(10), @TOC varchar(10))    

as    
 begin    
    Delete From RateMin Where CODE=@CODE and TOC=@TOC;    
 end

  
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_DropRateCon_M1]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[SP_DropRateCon_M1] 
end
GO
  Create Procedure [dbo].[SP_DropRateCon_M1] (@RATECON int)    
 as    
 begin    
 Delete From RateCon_M1 Where RATECON=@RATECON;
 end

  
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_DropRateCon]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[SP_DropRateCon] 
end
GO
  Create Procedure [dbo].[SP_DropRateCon] (@RATECON int)    
 as    
 begin    
 Delete From RATECON Where RATECON=@RATECON;
 end

  
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_DropRateCon_M2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[SP_DropRateCon_M2] 
end
GO
  Create Procedure [dbo].[SP_DropRateCon_M2] (@RATECON int)    
 as    
 begin    
 Delete From RateCon_M2 Where RATECON=@RATECON;
 end

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_DropRateCon_M3]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE [dbo].[SP_DropRateCon_M3] 
end
GO
 Create Procedure [dbo].[SP_DropRateCon_M3] (@RATECON int)    
 as    
 begin    
 Delete From RateCon_M3 Where RATECON=@RATECON;
 end

  
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_Search_TOL]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE [dbo].[SP_Search_TOL]
 end
GO
 CREATE Procedure [dbo].[SP_Search_TOL](@TOC varchar(10), @Description varchar(50))        
as        
Select CAST(0 As Bit) ProcessFlag, 
coalesce(C.TOC,'') as TOC,
coalesce(C.description, '') as Description,
coalesce(D.description, '') as CDesc,
coalesce(C.AllowedF,0) as AllowedF,
coalesce(C.RenewableF, 0) as RenewableF,
coalesce(C.ReinstatementF, 0) as ReinstatementF,
C.Last_Opr,
C.Last_Update
from TOC C 
join COB D on C.COB  =D.COB
Where (C.TOC like @TOC + '%') And (C.Description like @Description + '%' )

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QTOL_ReinsuranceRate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[QTOL_ReinsuranceRate] 
end
GO
CREATE PROCEDURE [dbo].[QTOL_ReinsuranceRate] (@TOC varchar(10), @RYear int)        
AS        
BEGIN        
  Select CAST(0 As Bit) ProcessFlag, 
  coalesce(TOC, '') TOC,
  coalesce(RYEAR, 0) RYEAR,
  coalesce(Currency, '') Currency,
  coalesce(CCYTo, '') CCYTo,
  coalesce(RType, '') RType,
  coalesce(Rate, 0) Rate,
  coalesce(CRate, 0) CRate,
 Last_Opr,
 Last_Update
 FROM RERATE WHERE TOC=@TOC and RYear= @RYear
END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QTOL_CessionLimit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[QTOL_CessionLimit]
end
GO
Create Procedure [dbo].[QTOL_CessionLimit](@TOC varchar(10), @RYear int)        
as        
Select CAST(0 As Bit) ProcessFlag,
coalesce(TOL.ISTYPE, '') SourceType,
coalesce(ISType.Description, '') Description,
coalesce(TOL.MINRANGE + ' - ' + TOL.MAXRANGE, '0-0') InwardShare,
coalesce(TOL.MINCOYS + ' - ' + TOL.MAXCOYS, '0-0') NumberCoys,
coalesce(TOL.MINYEAR + ' - ' + TOL.MAXYEAR, '0-0') NumberYears,
coalesce(TOL.LIMIT, 0) Limit,
coalesce(TOL.HoldF, 0) HoldF,
TOL.Last_Opr,
TOL.Last_Update
from TOL, ISType 
where ISType.ISType=TOL.ISType and TOL.TOC= @TOC and RYear=@RYear

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QTOL_TtyLimit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[QTOL_TtyLimit]
end
GO
CREATE Procedure [dbo].[QTOL_TtyLimit](@TOC varchar(10), @RYear int)        
as        
Select CAST(0 As Bit) ProcessFlag, 
coalesce(RiskAss.RiskAss,0) as RiskAss,
coalesce(RiskAss.CATEGORY,'') as CATEGORY,
RiskAss.LIMIT+ ' - '+ RiskAss.PLimit as 'Limit', 
coalesce(RiskAss.SHARE, 0) as 'SHARE', 
coalesce(RiskAss.HOLDF, 0) as 'HOLDF', 
coalesce(RiskAss.PRIORITYF, 0) as 'PRIORITYF', 
coalesce(RiskAss.TSILimit, 0) as 'TSILimit'
from RiskAss left Outer join Ratetab on Ratetab.code=RiskAss.Code WHERE RiskAss.TOC =@TOC and RiskAss.RYear=@RYear

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_RexCla]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[SP_RexCla] 
end
GO
CREATE PROCEDURE [dbo].[SP_RexCla] (@TOC varchar(10))         
AS  
Select case when D.ORDERNO in (select ORDERNO from REXCLA where TOC = @TOC) then 1
else 0 end as ProcessFlag,
a.*, C.TOC from GENCLA A join COB B on A.COB = B.COB
left join TOC C on B.COB = C.COB And A.COB = C.COB
left join REXCLA D on A.ORDERNO = D.ORDERNO and C.TOC = D.TOC
where C.TOC = @TOC

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_DropRiskAss]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE [dbo].[SP_DropRiskAss] 
end
GO
create Procedure [dbo].[SP_DropRiskAss] (@RISKASS int)    
as    
begin    
Delete from RISKASS where RISKASS=@RISKASS
end

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_DropTOL]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[SP_DropTOL] 
end
GO
create Procedure [dbo].[SP_DropTOL] (@TOC varchar(10), @RYear int, @ISType varchar(1), @LIMIT int )    
as    
begin    
Delete from TOL where TOC=@TOC and RYear=@RYear and ISType=@ISType and Limit=@LIMIT
end

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_DropReinsuranceRate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE [dbo].[SP_DropReinsuranceRate] 
end
GO
create Procedure [dbo].[SP_DropReinsuranceRate] (@TOC varchar(10), @RYear int, @Currency varchar(10))    
as    
begin    
Delete from RERATE where TOC=@TOC and RYear=@RYear and [Currency]=@Currency
end

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_Search_TOPRO]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[SP_Search_TOPRO]
end
GO
CREATE Procedure [dbo].[SP_Search_TOPRO](@TOPRO varchar(10), @Description varchar(50))        
as        
Select CAST(0 As Bit) ProcessFlag, *
from TOPRO T
Where (T.TOPRO like @TOPRO + '%') And (T.Description like @Description + '%' )

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QDefault_feeDuty]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[QDefault_feeDuty] 
end
GO
CREATE PROCEDURE [dbo].[QDefault_feeDuty] (@TOPRO Varchar(10) )      
AS      
 BEGIN      
  SELECT CAST(0 As Bit) ProcessFlag, TOPRO,FDID,REMARK,Currency,AMOUNT,AMOUNT_I,AMOUNT_G,Amount_O,Last_Opr,Last_Update from TOP_FD
   where TOPRO = @TOPRO 
 END

  
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QDefault_Deductible]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[QDefault_Deductible] 
end
GO
  CREATE PROCEDURE [dbo].[QDefault_Deductible] (@TOPRO Varchar(10) )      
AS      
 BEGIN      
  SELECT CAST(0 As Bit) ProcessFlag, TOPRO,DCode,TOR,REMARKS,PCTTSI,PCTCL,FIXEDMIN,FIXEDMAX,CURRENCY,IUNIT,Method,FixedMin_AOE,FixedMax_AOE,
STRTSI,Last_Opr,Last_Update from TOP_DEDUCTIBLE
   where TOPRO = @TOPRO 
 END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QDefault_Interest]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE [dbo].[QDefault_Interest] 
end
GO
CREATE PROCEDURE [dbo].[QDefault_Interest] (@TOPRO Varchar(10) )      
AS      
BEGIN      
SELECT CAST(0 As Bit) ProcessFlag, A.*, B.DESCRIPTION from TOP_Interest A join TOI B on A.TOI = B.TOI
where TOPRO = @TOPRO 
END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QDefault_Rate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE [dbo].[QDefault_Rate] 
end
GO
CREATE PROCEDURE [dbo].[QDefault_Rate] (@TOPRO Varchar(10) )      
AS      
 BEGIN      
  SELECT CAST(0 As Bit) ProcessFlag, TOPRO, Code, Remark,Rate,Unit,Category,Portion,NOREFUNDF,Last_Opr,Last_Update from TOP_RATE
   where TOPRO = @TOPRO 
 END 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[Q_TopCla]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[Q_TopCla] 
end
GO
 CREATE PROCEDURE [dbo].[Q_TopCla] (@TOPRO varchar(10))         
AS  
select case when E.ORDERNO in (select ORDERNO from TOP_CLA where TOPRO = @TOPRO) then 1 else 0 end as ProcessFlag, 
A.*, D.TOPRO, coalesce(E.COMPULSORYF, '', 0) as COMPULSORYF from GENCLA A 
left join COB B on A.COB = B.COB 
left join TOC C on B.COB = C.COB 
left join TOPRO D on C.TOC = D.TOC
left join TOP_CLA E on E.TOPRO = D.TOPRO and A.ORDERNO = E.ORDERNO
where 
D.TOPRO = @TOPRO

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QTopSegment') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE QTopSegment
end
GO
CREATE procedure QTopSegment(@TOPRO varchar(10))
as
select distinct case when B.Segment in (select Segment from TOP_SEGMENT where TOPRO = @TOPRO) then 1 else 0
end as ProcessFlag, B.* from Segment B join TOP_SEGMENT A on B.Segment = A.Segment

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[Q_TopCon]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[Q_TopCon] 
end
GO
CREATE PROCEDURE [dbo].[Q_TopCon] (@TOPRO varchar(10))         
AS  
select case when E.ORDERNO in (select ORDERNO from TOP_CON where TOPRO = @TOPRO) then 1 else 0 end as ProcessFlag, 
A.*, D.TOPRO, coalesce(E.COMPULSORYF, '', 0) as COMPULSORYF from GENCLA A 
left join COB B on A.COB = B.COB 
left join TOC C on B.COB = C.COB 
left join TOPRO D on C.TOC = D.TOC
left join TOP_CON E on E.TOPRO = D.TOPRO and A.ORDERNO = E.ORDERNO
where 
D.TOPRO = @TOPRO

 
GO 

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Func_RateCode') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION  dbo.Func_RateCode
end
GO
create FUNCTION dbo.Func_RateCode()  
RETURNS TABLE AS RETURN
(
SELECT RateTab.Code, RateTab.Description, RateTab.Unit, RateTab.NoRefundF, max(RClass.Category) as Category, sum(RateTab.Rate*RateCov.Portion/100) AS Rate, sum(RateCov.Portion) AS Portion  
From RateTab, RateCov, Rclass, TOPRO  
Where RateTab.Code Like RateTab.Code  and RateTab.Code=RateCov.Code and Rclass.TOR=RateCov.TOR and Rclass.TOC=TOPRO.TOC and TOPRO.TOPRO= TOPRO.TOPRO
Group By RateTab.Code, RateTab.Description, RateTab.Unit, RateTab.NoRefundF
)

 
GO 

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FUNC_TOI') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION  dbo.FUNC_TOI 
end
GO
create FUNCTION dbo.FUNC_TOI ()
RETURNS TABLE AS RETURN
(
Select distinct TOI.TOI, TOI.Description, PClass.Category
From Rclass, Pclass, TOI, TOPRO
Where TOPRO.TOPRO=TOPRO.TOPRO and Rclass.TOC=TOPRO.TOC and Pclass.TOR=Rclass.TOR and TOI.TOI=PCLASS.TOI and TOI.TOI like TOI.TOI
)

 
GO 

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FUNC_DedCode') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION  dbo.FUNC_DedCode 
end
GO
CREATE FUNCTION dbo.FUNC_DedCode ()
RETURNS TABLE
AS RETURN

	(
	Select Distinct Dedtab.* From Rclass, DedTAB, TOPRO Where TOPRO.TOPRO=TOPRO.TOPRO AND Rclass.TOC=TOPRO.TOC and Rclass.TOR=DedTAB.TOR and DedTAB.DCode Like DedTAB.DCode
	)

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_Drop_DefaultFD]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE [dbo].[SP_Drop_DefaultFD] 
end
GO
create Procedure [dbo].[SP_Drop_DefaultFD] (@TOPRO varchar(10),@FDID varchar(10))    
as    
 begin    
  Delete From TOP_FD Where TOPRO=@TOPRO and FDID=@FDID;    
 end

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_Drop_DefaultDeductible]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[SP_Drop_DefaultDeductible] 
end
GO
 create Procedure [dbo].[SP_Drop_DefaultDeductible] (@TOPRO varchar(10),@DCode varchar(10) )    
as    
 begin    
  Delete From TOP_Deductible Where TOPRO=@TOPRO and DCode=@DCode;    
 end

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_Drop_DefaultInterest]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[SP_Drop_DefaultInterest] 
end
GO
CREATE Procedure [dbo].[SP_Drop_DefaultInterest] (@TOPRO varchar(10), @TOI varchar(10))    
as    
 begin    
  Delete From TOP_Interest Where TOPRO=@TOPRO and TOI=@TOI;    
 end

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_Drop_defaultRate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE [dbo].[SP_Drop_defaultRate] 
end
GO
 create Procedure [dbo].[SP_Drop_defaultRate] (@TOPRO varchar(10), @Code varchar(10))    
as    
 begin    
  Delete From TOP_Rate Where TOPRO=@TOPRO and Code=@Code;    
 end

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_Drop_TOPRO]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE [dbo].[SP_Drop_TOPRO] 
end
GO
Create Procedure [dbo].[SP_Drop_TOPRO] (@TOPRO varchar(10))    
as    
 begin    
  Delete From TOPRO Where TOPRO=@TOPRO;    
 end

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QProCap]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE [dbo].[QProCap] 
end
GO
 CREATE PROCEDURE [dbo].[QProCap] (@ID Varchar(10) )    
AS    
 BEGIN    
  SELECT CAST(0 As Bit) ProcessFlag,A.*, B.Name FROM ProCap A left join Profile B on A.ID = B.ID  WHERE a.ID=@ID ;   
 END    

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_DefCon') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE SP_DefCon
end
GO
 Create PROCEDURE SP_DefCon(@TOC varchar(10),@SECTION varchar(10))            
AS            
 BEGIN            
 select  top 5 case when b.ProcessFlag ='1' then  b.ProcessFlag else  '0' end as ProcessFlag ,      
a.OrderNo,case when b.SHORTDESC  IS NULL  then a.SHORTDESC else b.SHORTDESC end as  ShortDesc  ,      
case when b.ShortDesc_1   IS NULL  then a.ShortDesc_1 else b.ShortDesc_1 end as  ShortDesc_1,      
case when b.DESCRIPTION   IS NULL  then a.DESCRIPTION else b.DESCRIPTION end as   DESCRIPTION ,      
case when b.DESCRIPTION_1  IS  null then a.DESCRIPTION_1 else b.DESCRIPTION_1 end as  DESCRIPTION_1,      
b.SECTION, case when b.CompulsoryF   IS  null then 0 else b.CompulsoryF   end as  CompulsoryF       
from       
(select TOC.TOC,OrderNo,ShortDesc, ShortDesc_1, GENCON.Description, GENCON.Description_1       
from GENCON, TOC where GENCON.COB=TOC.COB)a       
left join       
(SELECT Cast(1 As Bit)as ProcessFlag,toc,OrderNo,ShortDesc, ShortDesc_1, Description, Description_1, Section, CompulsoryF       
from DefCON a where  a.SECTION=@SECTION )b on a.ORDERNO=b.ORDERNO        
and a.TOC=b.TOC  where a.toc=@TOC         
              
 END

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_DefEx') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE SP_DefEx
end
GO
 create PROCEDURE SP_DefEx(@TOC varchar(10),@SECTION varchar(10))            
AS            
 BEGIN            
 select  top 5 case when b.ProcessFlag ='1' then  b.ProcessFlag else  '0' end as ProcessFlag ,      
a.OrderNo,case when b.SHORTDESC  IS NULL  then a.SHORTDESC else b.SHORTDESC end as  ShortDesc  ,      
case when b.ShortDesc_1   IS NULL  then a.ShortDesc_1 else b.ShortDesc_1 end as  ShortDesc_1,      
case when b.DESCRIPTION   IS NULL  then a.DESCRIPTION else b.DESCRIPTION end as   DESCRIPTION ,      
case when b.DESCRIPTION_1  IS  null then a.DESCRIPTION_1 else b.DESCRIPTION_1 end as  DESCRIPTION_1,      
b.SECTION, case when b.CompulsoryF   IS  null then 0 else b.CompulsoryF   end as  CompulsoryF       
from       
(select TOC.TOC,OrderNo,ShortDesc, ShortDesc_1, GENEX.Description, GENEX.Description_1       
from GENEX, TOC where GENEX.COB=TOC.COB)a       
left join       
(SELECT Cast(1 As Bit)as ProcessFlag,toc,OrderNo,ShortDesc, ShortDesc_1, Description, Description_1, Section, CompulsoryF       
from DefEX a where  a.SECTION=@SECTION )b on a.ORDERNO=b.ORDERNO        
and a.TOC=b.TOC  where a.toc=@TOC         
              
 END

 
GO 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QSysClass_GENHTAB]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE [dbo].[QSysClass_GENHTAB] 
end
GO
CREATE PROCEDURE [dbo].[QSysClass_GENHTAB] (@P_Class AS VARCHAR(10)) 
AS 
SELECT  TOP 1 
C.CLASS, C.DESCRIPTION, 
C.FLDID1, C.FLDTAG1, C.FLDTAG1, GENHTAB_1.FLDTAB AS FLDTAB1, GENHTAB_1.FLDCOM AS FLDCOM1, GENHTAB_1.FLDCOMA AS FLDCOMA1, GENHTAB_1.FLDDFORMAT AS FLDDFORMAT1, GENHTAB_1.FLDIFORMAT AS FLDIFORMAT1, GENHTAB_1.FLDTYPE AS FLDTYPE1, GENHTAB_1.SUBLINKF AS SUBLINKF1,  GENHTAB_1.FLDSEARCH AS FLDSEARCH1, GENHTAB_1.FLDCRITERIA AS FLDCRITERIA1, GENHTAB_1.FLDCHGINF as FLDCHGINF1, 
C.FLDID2, C.FLDTAG2, C.FLDTAG2, GENHTAB_2.FLDTAB AS FLDTAB2, GENHTAB_2.FLDCOM AS FLDCOM2, GENHTAB_2.FLDCOMA AS FLDCOMA2, GENHTAB_2.FLDDFORMAT AS FLDDFORMAT2, GENHTAB_2.FLDIFORMAT AS FLDIFORMAT2, GENHTAB_2.FLDTYPE AS FLDTYPE2, GENHTAB_2.SUBLINKF AS SUBLINKF2,  GENHTAB_2.FLDSEARCH AS FLDSEARCH2, GENHTAB_2.FLDCRITERIA AS FLDCRITERIA2, GENHTAB_2.FLDCHGINF as FLDCHGINF2, 
C.FLDID3, C.FLDTAG3, C.FLDTAG3, GENHTAB_3.FLDTAB AS FLDTAB3, GENHTAB_3.FLDCOM AS FLDCOM3, GENHTAB_3.FLDCOMA AS FLDCOMA3, GENHTAB_3.FLDDFORMAT AS FLDDFORMAT3, GENHTAB_3.FLDIFORMAT AS FLDIFORMAT3, GENHTAB_3.FLDTYPE AS FLDTYPE3, GENHTAB_3.SUBLINKF AS SUBLINKF3,  GENHTAB_3.FLDSEARCH AS FLDSEARCH3, GENHTAB_3.FLDCRITERIA AS FLDCRITERIA3, GENHTAB_3.FLDCHGINF as FLDCHGINF3, 
C.FLDID4, C.FLDTAG4, C.FLDTAG4, GENHTAB_4.FLDTAB AS FLDTAB4, GENHTAB_4.FLDCOM AS FLDCOM4, GENHTAB_4.FLDCOMA AS FLDCOMA4, GENHTAB_4.FLDDFORMAT AS FLDDFORMAT4, GENHTAB_4.FLDIFORMAT AS FLDIFORMAT4, GENHTAB_4.FLDTYPE AS FLDTYPE4, GENHTAB_4.SUBLINKF AS SUBLINKF4,  GENHTAB_4.FLDSEARCH AS FLDSEARCH4, GENHTAB_4.FLDCRITERIA AS FLDCRITERIA4, GENHTAB_4.FLDCHGINF as FLDCHGINF4, 
C.FLDID5, C.FLDTAG5, C.FLDTAG5, GENHTAB_5.FLDTAB AS FLDTAB5, GENHTAB_5.FLDCOM AS FLDCOM5, GENHTAB_5.FLDCOMA AS FLDCOMA5, GENHTAB_5.FLDDFORMAT AS FLDDFORMAT5, GENHTAB_5.FLDIFORMAT AS FLDIFORMAT5, GENHTAB_5.FLDTYPE AS FLDTYPE5, GENHTAB_5.SUBLINKF AS SUBLINKF5,  GENHTAB_5.FLDSEARCH AS FLDSEARCH5, GENHTAB_5.FLDCRITERIA AS FLDCRITERIA5, GENHTAB_5.FLDCHGINF as FLDCHGINF5, 
C.FLDID6, C.FLDTAG6, C.FLDTAG6, GENHTAB_6.FLDTAB AS FLDTAB6, GENHTAB_6.FLDCOM AS FLDCOM6, GENHTAB_6.FLDCOMA AS FLDCOMA6, GENHTAB_6.FLDDFORMAT AS FLDDFORMAT6, GENHTAB_6.FLDIFORMAT AS FLDIFORMAT6, GENHTAB_6.FLDTYPE AS FLDTYPE6, GENHTAB_6.SUBLINKF AS SUBLINKF6,  GENHTAB_6.FLDSEARCH AS FLDSEARCH6, GENHTAB_6.FLDCRITERIA AS FLDCRITERIA6, GENHTAB_6.FLDCHGINF as FLDCHGINF6, 
C.FLDID7, C.FLDTAG7, C.FLDTAG7, GENHTAB_7.FLDTAB AS FLDTAB7, GENHTAB_7.FLDCOM AS FLDCOM7, GENHTAB_7.FLDCOMA AS FLDCOMA7, GENHTAB_7.FLDDFORMAT AS FLDDFORMAT7, GENHTAB_7.FLDIFORMAT AS FLDIFORMAT7, GENHTAB_7.FLDTYPE AS FLDTYPE7, GENHTAB_7.SUBLINKF AS SUBLINKF7,  GENHTAB_7.FLDSEARCH AS FLDSEARCH7, GENHTAB_7.FLDCRITERIA AS FLDCRITERIA7, GENHTAB_7.FLDCHGINF as FLDCHGINF7, 
C.FLDID8, C.FLDTAG8, C.FLDTAG8, GENHTAB_8.FLDTAB AS FLDTAB8, GENHTAB_8.FLDCOM AS FLDCOM8, GENHTAB_8.FLDCOMA AS FLDCOMA8, GENHTAB_8.FLDDFORMAT AS FLDDFORMAT8, GENHTAB_8.FLDIFORMAT AS FLDIFORMAT8, GENHTAB_8.FLDTYPE AS FLDTYPE8, GENHTAB_8.SUBLINKF AS SUBLINKF8,  GENHTAB_8.FLDSEARCH AS FLDSEARCH8, GENHTAB_8.FLDCRITERIA AS FLDCRITERIA8, GENHTAB_8.FLDCHGINF as FLDCHGINF8, 
C.FLDID9, C.FLDTAG9, C.FLDTAG9, GENHTAB_9.FLDTAB AS FLDTAB9, GENHTAB_9.FLDCOM AS FLDCOM9, GENHTAB_9.FLDCOMA AS FLDCOMA9, GENHTAB_9.FLDDFORMAT AS FLDDFORMAT9, GENHTAB_9.FLDIFORMAT AS FLDIFORMAT9, GENHTAB_9.FLDTYPE AS FLDTYPE9, GENHTAB_9.SUBLINKF AS SUBLINKF9,  GENHTAB_9.FLDSEARCH AS FLDSEARCH9, GENHTAB_9.FLDCRITERIA AS FLDCRITERIA9, GENHTAB_9.FLDCHGINF as FLDCHGINF9, 
C.FLDID10, C.FLDTAG10, C.FLDTAG10, GENHTAB_10.FLDTAB AS FLDTAB10, GENHTAB_10.FLDCOM AS FLDCOM10, GENHTAB_10.FLDCOMA AS FLDCOMA10, GENHTAB_10.FLDDFORMAT AS FLDDFORMAT10, GENHTAB_10.FLDIFORMAT AS FLDIFORMAT10, GENHTAB_10.FLDTYPE AS FLDTYPE10, GENHTAB_10.SUBLINKF AS SUBLINKF10,  GENHTAB_10.FLDSEARCH AS FLDSEARCH10, GENHTAB_10.FLDCRITERIA AS FLDCRITERIA10, GENHTAB_10.FLDCHGINF as FLDCHGINF10, 
C.FLDID11, C.FLDTAG11, C.FLDTAG11, GENHTAB_11.FLDTAB AS FLDTAB11, GENHTAB_11.FLDCOM AS FLDCOM11, GENHTAB_11.FLDCOMA AS FLDCOMA11, GENHTAB_11.FLDDFORMAT AS FLDDFORMAT11, GENHTAB_11.FLDIFORMAT AS FLDIFORMAT11, GENHTAB_11.FLDTYPE AS FLDTYPE11, GENHTAB_11.SUBLINKF AS SUBLINKF11,  GENHTAB_11.FLDSEARCH AS FLDSEARCH11, GENHTAB_11.FLDCRITERIA AS FLDCRITERIA11, GENHTAB_11.FLDCHGINF as FLDCHGINF11, 
C.FLDID12, C.FLDTAG12, C.FLDTAG12, GENHTAB_12.FLDTAB AS FLDTAB12, GENHTAB_12.FLDCOM AS FLDCOM12, GENHTAB_12.FLDCOMA AS FLDCOMA12, GENHTAB_12.FLDDFORMAT AS FLDDFORMAT12, GENHTAB_12.FLDIFORMAT AS FLDIFORMAT12, GENHTAB_12.FLDTYPE AS FLDTYPE12, GENHTAB_12.SUBLINKF AS SUBLINKF12,  GENHTAB_12.FLDSEARCH AS FLDSEARCH12, GENHTAB_12.FLDCRITERIA AS FLDCRITERIA12, GENHTAB_12.FLDCHGINF as FLDCHGINF12, 
C.FLDID13, C.FLDTAG13, C.FLDTAG13, GENHTAB_13.FLDTAB AS FLDTAB13, GENHTAB_13.FLDCOM AS FLDCOM13, GENHTAB_13.FLDCOMA AS FLDCOMA13, GENHTAB_13.FLDDFORMAT AS FLDDFORMAT13, GENHTAB_13.FLDIFORMAT AS FLDIFORMAT13, GENHTAB_13.FLDTYPE AS FLDTYPE13, GENHTAB_13.SUBLINKF AS SUBLINKF13,  GENHTAB_13.FLDSEARCH AS FLDSEARCH13, GENHTAB_13.FLDCRITERIA AS FLDCRITERIA13, GENHTAB_13.FLDCHGINF as FLDCHGINF13, 
C.FLDID14, C.FLDTAG14, C.FLDTAG14, GENHTAB_14.FLDTAB AS FLDTAB14, GENHTAB_14.FLDCOM AS FLDCOM14, GENHTAB_14.FLDCOMA AS FLDCOMA14, GENHTAB_14.FLDDFORMAT AS FLDDFORMAT14, GENHTAB_14.FLDIFORMAT AS FLDIFORMAT14, GENHTAB_14.FLDTYPE AS FLDTYPE14, GENHTAB_14.SUBLINKF AS SUBLINKF14,  GENHTAB_14.FLDSEARCH AS FLDSEARCH14, GENHTAB_14.FLDCRITERIA AS FLDCRITERIA14, GENHTAB_14.FLDCHGINF as FLDCHGINF14, 
C.FLDID15, C.FLDTAG15, C.FLDTAG15, GENHTAB_15.FLDTAB AS FLDTAB15, GENHTAB_15.FLDCOM AS FLDCOM15, GENHTAB_15.FLDCOMA AS FLDCOMA15, GENHTAB_15.FLDDFORMAT AS FLDDFORMAT15, GENHTAB_15.FLDIFORMAT AS FLDIFORMAT15, GENHTAB_15.FLDTYPE AS FLDTYPE15, GENHTAB_15.SUBLINKF AS SUBLINKF15,  GENHTAB_15.FLDSEARCH AS FLDSEARCH15, GENHTAB_15.FLDCRITERIA AS FLDCRITERIA15, GENHTAB_15.FLDCHGINF as FLDCHGINF15 
FROM 
SysClass C 
LEFT OUTER JOIN GENHTAB as GENHTAB_1 ON C.FLDID1 = GENHTAB_1.FLDID 
LEFT OUTER JOIN GENHTAB as GENHTAB_2 ON C.FLDID2 = GENHTAB_2.FLDID 
LEFT OUTER JOIN GENHTAB as GENHTAB_3 ON C.FLDID3 = GENHTAB_3.FLDID 
LEFT OUTER JOIN GENHTAB as GENHTAB_4 ON C.FLDID4 = GENHTAB_4.FLDID 
LEFT OUTER JOIN GENHTAB as GENHTAB_5 ON C.FLDID5 = GENHTAB_5.FLDID 
LEFT OUTER JOIN GENHTAB as GENHTAB_6 ON C.FLDID6 = GENHTAB_6.FLDID 
LEFT OUTER JOIN GENHTAB as GENHTAB_7 ON C.FLDID7 = GENHTAB_7.FLDID 
LEFT OUTER JOIN GENHTAB as GENHTAB_8 ON C.FLDID8 = GENHTAB_8.FLDID 
LEFT OUTER JOIN GENHTAB as GENHTAB_9 ON C.FLDID9 = GENHTAB_9.FLDID 
LEFT OUTER JOIN GENHTAB as GENHTAB_10 ON C.FLDID10 = GENHTAB_10.FLDID 
LEFT OUTER JOIN GENHTAB as GENHTAB_11 ON C.FLDID11 = GENHTAB_11.FLDID 
LEFT OUTER JOIN GENHTAB as GENHTAB_12 ON C.FLDID12 = GENHTAB_12.FLDID 
LEFT OUTER JOIN GENHTAB as GENHTAB_13 ON C.FLDID13 = GENHTAB_13.FLDID 
LEFT OUTER JOIN GENHTAB as GENHTAB_14 ON C.FLDID14 = GENHTAB_14.FLDID 
LEFT OUTER JOIN GENHTAB as GENHTAB_15 ON C.FLDID15 = GENHTAB_15.FLDID 
WHERE  C.CLASS = @P_Class 
 
GO 

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_QSchemeDedCode') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION  FN_QSchemeDedCode 
end
GO
CREATE FUNCTION FN_QSchemeDedCode (@p_TOC varchar(10),	@p_DCode varchar(10))     
RETURNS TABLE  
AS RETURN (  
	Select Distinct Dedtab.*
	From Rclass, DedTAB
	Where Rclass.TOC=@P_TOC and Rclass.TOR=DedTAB.TOR and DedTAB.DCode Like @P_DCode
) 

 
GO 

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FN_QSchemeTOICode]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION  [dbo].[FN_QSchemeTOICode]
end
GO
create FUNCTION [dbo].[FN_QSchemeTOICode](@p_TOC varchar(10), @p_Category varchar(1), @p_TOI varchar (10))   
RETURNS Table   
AS RETURN (   
Select distinct TOI.TOI, TOI.Description, PClass.Category
From RCLASS, PCLASS, TOI
Where Rclass.TOC=@p_TOC and Pclass.TOR=Rclass.TOR and Toi.TOI=Pclass.TOI
and TOI.TOI like @p_TOI
  
)  

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QSchemeViewAdditional') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QSchemeViewAdditional
end
GO
CREATE procedure QSchemeViewAdditional(@p_SchemeNo varchar(10),@P_Class_Desc as varchar(100))   
as      
select top 50000 CAST(0 As Bit) ProcessFlag,
 additional.classno,      
 class.description as class_desc,   
 additional.coverage,  
 additional.interest,      
 additional.toi,      
 toi.description as toi_desc,      
 additional.lower, additional.upper,      
 additional.NOfYearsL, additional.NOfYearsU,      
 additional.SI,    
 additional.code,ratetab.description as ratetab_desc,      
 additional.rate,      
 case       
 when additional.unit = 'M' then 'Per Mil'      
 when additional.unit = 'C' then 'Percentage'      
 when additional.unit = 'F' then 'Flat'      
 else additional.unit      
 end as unit,      
 case       
 when additional.category='A' then 'Additional'      
 when additional.category='M' then 'Main'      
 else additional.category      
 end as category       
from scheme_additional as additional, scheme_class as class, toi,ratetab      
where additional.classno=class.classno 
and additional.toi =toi.toi 
and additional.code=ratetab.code 
and class.schemeno=@p_schemeno and (@P_Class_Desc='<All>' or class.description=@P_Class_Desc)
  
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QSchemeViewCoverage') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QSchemeViewCoverage
end
GO
Create procedure QSchemeViewCoverage(@p_SchemeNo varchar(10),@P_Class_Desc as varchar(100))   
as   
select Top 50000 CAST(0 As Bit) ProcessFlag,
coverage.classno,   
class.description as class_desc, coverage.coverage,   
coverage.code, ratetab.description as ratetab_desc,   
coverage.rate,   
Coverage.GrossUpF,   
case   
when coverage.unit='M' then 'Per Mil'   
when coverage.unit='C' then 'Percentage'   
when coverage.unit='F' then 'Flat'   
else coverage.unit   
end as unit,   
case   
when coverage.category='A' then 'Additional'   
when coverage.category='M' then 'Main'   
else coverage.category   
end as category,   
Coverage.RateLoadingF   
from scheme_coverage as coverage, scheme_class as class, ratetab   
where   
coverage.classno=class.classno 
and coverage.code=ratetab.code 
and class.schemeno=@p_schemeno 
and (@P_Class_Desc='<All>' or class.description=@P_Class_Desc)


GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QSchemeViewInterest') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QSchemeViewInterest
end
GO
Create procedure QSchemeViewInterest(@p_SchemeNo varchar(10),@P_Class_Desc as varchar(100))   
as   
select top 50000 CAST(0 As Bit) ProcessFlag, S2.ClassNo, S1.Description as Class_Desc, S2.TOI, TOI.Description as TOI_Desc, Case When S2.Category='M' then 'Main' else 'Additional' end as Category, S2.SI   
from scheme_Class as S1, scheme_interest as S2, toi   
where  S1.ClassNo=S2.ClassNo and TOI.TOI=S2.TOI and S1.SchemeNo=@P_SchemeNo and (@P_Class_Desc='<All>' or S1.description=@P_Class_Desc)


GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QSchemeViewDeductible') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE QSchemeViewDeductible
end
GO
Create procedure QSchemeViewDeductible(@p_SchemeNo varchar(10),@P_Class_Desc as varchar(100))   
as  
select Top 50000 CAST(0 As Bit) ProcessFlag, deductible.classno,class.description as class_desc, deductible.coverage, deductible.lower, deductible.upper, deductible.dcode, deductible.remarks  
from scheme_deductible as deductible, scheme_class as class  
where  deductible.classno=class.classno and class.schemeno=@p_schemeno and (@P_Class_Desc='<All>' or class.description=@P_Class_Desc)

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QSchemeViewIndemnity') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE QSchemeViewIndemnity
end
GO
Create procedure QSchemeViewIndemnity(@p_SchemeNo varchar(10),@P_Class_Desc as varchar(100))   
as   
select Top 50000 CAST(0 As Bit) ProcessFlag, S2.classno, S1.description as class_desc, S2.Coverage, S2.Code, S2.Lower, S2.Upper, S2.PCTLoss, S2.PAddition, S2.Discount, S2.Rate, S2.RateLower, S2.HoldF, S2.RateLoadingF   
from Scheme_Class as S1, scheme_indemnity as S2   
where  S1.ClassNo=S2.ClassNo and S1.SchemeNo=@P_SchemeNo and (@P_Class_Desc='<All>' or S1.description=@P_Class_Desc)
order by  S2.ClassNo, S2.Coverage, S2.Code, S2.Lower, S2.Upper   
   
 
GO 

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_SearchSubCompanyGroup') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION  FN_SearchSubCompanyGroup 
end
GO
CREATE FUNCTION FN_SearchSubCompanyGroup (@SCGroup varchar(10),	@CGroup varchar(10), @Description varchar(100))     
RETURNS TABLE  
AS RETURN (  
SELECT Cast(0 as bit) as ProcessFlag, SCGroup.*, coalesce(CGroup.Description,'') as N'CGroupDesc'  
from SCGroup Left Join CGroup on SCGroup.CGroup = CGroup.CGroup Where SCGroup Like  @SCGroup + '%' and SCGroup.CGroup Like @CGroup + '%' and SCGroup.Description Like @Description + '%'

) 

 
GO 

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'TOP_TOICode') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION  TOP_TOICode 
end
GO
CREATE FUNCTION TOP_TOICode (@p_TOPRO varchar(10), @p_TOI varchar (10))     
RETURNS TABLE  
AS RETURN (  
Select distinct TOI.TOI, TOI.Description, PClass.Category
From Rclass, Pclass, TOI, TOPRO
Where TOPRO.TOPRO=@P_TOPRO and Rclass.TOC=TOPRO.TOC and Pclass.TOR=Rclass.TOR and TOI.TOI=PCLASS.TOI and TOI.TOI like @p_TOI

) 

 
GO 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QTOCExt]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[QTOCExt] 
end
GO
CREATE PROCEDURE [dbo].[QTOCExt] (@TOC varchar(10))         
AS  
select CAST(0 As Bit) ProcessFlag,* from TOC_EXT where TOC=@TOC


GO
-- 27 Maret 2017

--1
 
GO

/****** Object:  UserDefinedFunction [dbo].[FN_SchemeEx]    Script Date: 3/24/2017 10:44:05 AM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FN_SchemeEx]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION  [dbo].[FN_SchemeEx]
end
GO

/****** Object:  UserDefinedFunction [dbo].[FN_SchemeEx]    Script Date: 3/24/2017 10:44:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FN_SchemeEx] (@p_SchemeNo varchar(10), @p_Coverage varchar(255), @p_Section varchar(10))
  RETURNS @return_variable TABLE 
    (
        ProcessFlag bit, OrderNo varchar(10), ShortDesc VARCHAR(255), Description text, ShortDesc_1 VARCHAR(255), Description_1 text, CompulsoryF bit
    )
AS
BEGIN
    declare @Child TABLE  (OrderNo varchar(10), ShortDesc VARCHAR(255), Description text, ShortDesc_1 VARCHAR(255), Description_1 text, CompulsoryF bit)
    declare @Parent TABLE  (OrderNo varchar(10), ShortDesc VARCHAR(255), Description text, ShortDesc_1 VARCHAR(255), Description_1 text, CompulsoryF bit)
	
    INSERT @Child (OrderNo, ShortDesc, Description, ShortDesc_1, Description_1, CompulsoryF)
    select OrderNo,ShortDesc, GenEx.Description, GenEx.ShortDesc_1, GenEx.Description_1, 0 as CompulsoryF from GenEx, TOC, scheme_master S where GenEx.COB=TOC.COB and TOC.TOC=S.TOC and S.SchemeNo= @p_SchemeNo Order by OrderNo

	INSERT @Parent (OrderNo, ShortDesc, Description, ShortDesc_1, Description_1, CompulsoryF)
	select OrderNo,ShortDesc, Description, ShortDesc_1, Description_1, CompulsoryF from Scheme_EX where Coverage= @p_Coverage and Section like @p_Section + '%' and SchemeNo= @p_SchemeNo Order by OrderNo
    
    INSERT INTO @return_variable
    select * from (
		select case when P.ORDERNO <> '' then 1 else 0 end as ProcessFlag, 
		C.OrderNo, C.ShortDesc, case when P.OrderNo<> '' then p.Description else c.Description end as Description, 
		C.ShortDesc_1, c.Description_1, P.CompulsoryF from @Child C left join @Parent P on C.ORDERNO = P.ORDERNO
	)x

	RETURN
END


GO

--2
 
GO

/****** Object:  UserDefinedFunction [dbo].[FN_SchemeCon]    Script Date: 3/24/2017 10:44:18 AM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FN_SchemeCon]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION  [dbo].[FN_SchemeCon]
end
GO

/****** Object:  UserDefinedFunction [dbo].[FN_SchemeCon]    Script Date: 3/24/2017 10:44:18 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_SchemeCon] (@p_SchemeNo varchar(10), @p_Coverage varchar(255), @p_Section varchar(10))
  RETURNS @return_variable TABLE 
    (
        ProcessFlag bit, OrderNo varchar(10), ShortDesc VARCHAR(255), Description text, ShortDesc_1 VARCHAR(255), Description_1 text, CompulsoryF bit
    )
AS
BEGIN
    declare @Child TABLE  (OrderNo varchar(10), ShortDesc VARCHAR(255), Description text, ShortDesc_1 VARCHAR(255), Description_1 text, CompulsoryF bit)
    declare @Parent TABLE  (OrderNo varchar(10), ShortDesc VARCHAR(255), Description text, ShortDesc_1 VARCHAR(255), Description_1 text, CompulsoryF bit)
	
    INSERT @Child (OrderNo, ShortDesc, Description, ShortDesc_1, Description_1, CompulsoryF)
    select OrderNo,ShortDesc, GenCon.Description, GenCon.ShortDesc_1, GenCon.Description_1, 0 as CompulsoryF from GenCon, TOC, scheme_master S where GenCon.COB=TOC.COB and TOC.TOC=S.TOC and S.SchemeNo=@p_SchemeNo Order by OrderNo

	INSERT @Parent (OrderNo, ShortDesc, Description, ShortDesc_1, Description_1, CompulsoryF)
	select OrderNo,ShortDesc, Description, ShortDesc_1, Description_1, CompulsoryF from Scheme_CON where Coverage=@p_Coverage and Section like @p_Section + '%' and SchemeNo= @p_SchemeNo Order by OrderNo
    
    INSERT INTO @return_variable
    select * from (
		select case when P.ORDERNO <> '' then 1 else 0 end as ProcessFlag, 
		C.OrderNo, C.ShortDesc, case when P.OrderNo<> '' then p.Description else c.Description end as Description, 
		C.ShortDesc_1, c.Description_1, P.CompulsoryF from @Child C left join @Parent P on C.ORDERNO = P.ORDERNO
	)x

	RETURN
END


GO

--3
 
GO

/****** Object:  UserDefinedFunction [dbo].[FN_SchemeCla]    Script Date: 3/24/2017 10:44:41 AM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FN_SchemeCla]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION  [dbo].[FN_SchemeCla]
end
GO

/****** Object:  UserDefinedFunction [dbo].[FN_SchemeCla]    Script Date: 3/24/2017 10:44:41 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_SchemeCla] (@p_SchemeNo varchar(10), @p_Coverage varchar(255), @p_Section varchar(10))
  RETURNS @return_variable TABLE 
    (
        ProcessFlag bit, OrderNo varchar(10), ShortDesc VARCHAR(255), Description text, ShortDesc_1 VARCHAR(255), Description_1 text, CompulsoryF bit
    )
AS
BEGIN
    declare @Child TABLE  (OrderNo varchar(10), ShortDesc VARCHAR(255), Description text, ShortDesc_1 VARCHAR(255), Description_1 text, CompulsoryF bit)
    declare @Parent TABLE  (OrderNo varchar(10), ShortDesc VARCHAR(255), Description text, ShortDesc_1 VARCHAR(255), Description_1 text, CompulsoryF bit)
	
    INSERT @Child (OrderNo, ShortDesc, Description, ShortDesc_1, Description_1, CompulsoryF)
    select OrderNo,ShortDesc, GenCla.Description, GenCla.ShortDesc_1, GenCla.Description_1, 0 as CompulsoryF from GenCla, TOC, Scheme_Master S where GenCla.COB=TOC.COB and TOC.TOC=S.TOC and S.SchemeNo=@p_SchemeNo Order by OrderNo

	INSERT @Parent (OrderNo, ShortDesc, Description, ShortDesc_1, Description_1, CompulsoryF)
    select OrderNo,ShortDesc, Description, ShortDesc_1, Description_1, CompulsoryF from Scheme_Cla where Coverage= @p_Coverage and Section like @p_Section + '%' and SchemeNo= @p_SchemeNo Order by OrderNo

    INSERT INTO @return_variable
    select * from (
		select case when P.ORDERNO <> '' then 1 else 0 end as ProcessFlag, 
		C.OrderNo, C.ShortDesc, case when P.OrderNo<> '' then p.Description else c.Description end as Description, 
		C.ShortDesc_1, c.Description_1, P.CompulsoryF from @Child C left join @Parent P on C.ORDERNO = P.ORDERNO
	)x

	RETURN
END


GO

--4
 
GO

/****** Object:  UserDefinedFunction [dbo].[FN_SchemeBranch]    Script Date: 3/24/2017 10:44:46 AM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FN_SchemeBranch]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION  [dbo].[FN_SchemeBranch]
end
GO

/****** Object:  UserDefinedFunction [dbo].[FN_SchemeBranch]    Script Date: 3/24/2017 10:44:46 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_SchemeBranch] (@p_SchemeNo varchar(10))
  RETURNS @return_variable TABLE 
    (
        ProcessFlag bit, Branch varchar(10), Name VARCHAR(70)
    )
AS
BEGIN
    declare @Branch TABLE  (Branch varchar(10), Name VARCHAR(70), ProcessFlag bit)
    declare @SchemeBranch TABLE  (SchemeNo varchar(10), Branch VARCHAR(10))
	
    INSERT @Branch (Branch, Name, ProcessFlag)
    select Branch, Name, 0 as ProcessFlag from Branch where Op_Flag=1

	INSERT @SchemeBranch (SchemeNo, Branch)
    select * from Scheme_Branch where SchemeNo = @p_SchemeNo

    
        INSERT INTO @return_variable
        select case when Branch in (select Branch from @SchemeBranch where SchemeNo = @p_SchemeNo) then 1 else ProcessFlag end as ProcessFlag, Branch, Name from @Branch
 
    RETURN
END


GO

--5
 
GO

/****** Object:  UserDefinedFunction [dbo].[FN_RexCla]    Script Date: 3/24/2017 10:44:51 AM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FN_RexCla]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION  [dbo].[FN_RexCla]
end
GO

/****** Object:  UserDefinedFunction [dbo].[FN_RexCla]    Script Date: 3/24/2017 10:44:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_RexCla] (@p_TOC varchar(10), @p_RYear int)
  RETURNS @return_variable TABLE 
    (
        ProcessFlag bit, OrderNo varchar(10), ShortDesc VARCHAR(255), Description text
    )
AS
BEGIN
    declare @Child TABLE  (OrderNo varchar(10), ShortDesc VARCHAR(255), Description text)
    declare @Parent TABLE  (OrderNo varchar(10), ShortDesc VARCHAR(255), Description text)
	
    INSERT @Child (OrderNo, ShortDesc, Description)
    SELECT OrderNo,ShortDesc, GenCla.Description  from GenCla, TOC where TOC.TOC= @p_TOC and GenCla.COB=TOC.COB

	INSERT @Parent (OrderNo, ShortDesc, Description)
    SELECT OrderNo,ShortDesc, Description  from REXCLA where TOC=@p_TOC and RYear=@p_RYear

    --WHILE (@@ROWCOUNT > 0)
    --BEGIN
        INSERT INTO @return_variable
        select * from (select case when P.ORDERNO <> '' then 1 else 0 end as ProcessFlag, C.OrderNo, C.ShortDesc, case when P.OrderNo<> '' then p.Description else c.Description end as Description from @Child C left join @Parent P on C.ORDERNO = P.ORDERNO) x

        --DELETE FROM @Parent

        --INSERT INTO @Parent
        --SELECT * FROM @Child

        --DELETE FROM @Child

        --INSERT INTO @Child (OrderNo, ShortDesc, Description)
        --SELECT OrderNo,ShortDesc, Description  from REXCLA where TOC=@p_TOC and RYear=@p_RYear
    --END
    RETURN
END

GO

--8
 
GO

/****** Object:  StoredProcedure [dbo].[QDefCla]    Script Date: 3/24/2017 10:14:23 PM ******/
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QDefCla]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[QDefCla]
end
GO

/****** Object:  StoredProcedure [dbo].[QDefCla]    Script Date: 3/24/2017 10:14:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[QDefCla] (@TOC Varchar(10), @OrderNo Varchar(10), @Section varchar(10) )    
AS    
 BEGIN

	SELECT * FROM DefCLA WHERE TOC=@TOC and OrderNo=@OrderNo and Section=@Section
	
 END   

GO

--9
 
GO

/****** Object:  StoredProcedure [dbo].[QDefCla2]    Script Date: 3/24/2017 10:14:34 PM ******/
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QDefCla2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE [dbo].[QDefCla2]
end
GO

/****** Object:  StoredProcedure [dbo].[QDefCla2]    Script Date: 3/24/2017 10:14:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[QDefCla2] (@TOC Varchar(10), @OrderNo Varchar(10), @Flag varchar(50), @Section varchar(10) )    
AS    
 BEGIN

	IF @FLAG='DefCLA' SELECT * FROM DefCLA WHERE TOC=@TOC and OrderNo=@OrderNo and Section=@Section
	ELSE IF @Flag='DefCon' SELECT * FROM DefCon WHERE TOC=@TOC and OrderNo=@OrderNo and Section=@Section
	ELSE IF @Flag='DefEx' SELECT * FROM DefEx WHERE TOC=@TOC and OrderNo=@OrderNo and Section=@Section
      
 END   

GO


--10
 
GO

/****** Object:  StoredProcedure [dbo].[QDefCon]    Script Date: 3/24/2017 10:14:49 PM ******/
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QDefCon]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[QDefCon]
end
GO

/****** Object:  StoredProcedure [dbo].[QDefCon]    Script Date: 3/24/2017 10:14:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[QDefCon] (@TOC Varchar(10), @OrderNo Varchar(10), @Section varchar(10) )    
AS    
 BEGIN

	SELECT * FROM DefCON WHERE TOC=@TOC and OrderNo=@OrderNo and Section=@Section
	
 END   

GO


--11
 
GO

/****** Object:  StoredProcedure [dbo].[QDefEx]    Script Date: 3/24/2017 10:15:02 PM ******/
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QDefEx]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [dbo].[QDefEx]
end
GO

/****** Object:  StoredProcedure [dbo].[QDefEx]    Script Date: 3/24/2017 10:15:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[QDefEx] (@TOC Varchar(10), @OrderNo Varchar(10), @Section varchar(10) )    
AS    
 BEGIN

	SELECT * FROM DefEX WHERE TOC=@TOC and OrderNo=@OrderNo and Section=@Section
	
 END   

GO

--12
 
GO

/****** Object:  UserDefinedFunction [dbo].[FN_GENDTAB2]    Script Date: 3/24/2017 10:15:44 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FN_GENDTAB2]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION  [dbo].[FN_GENDTAB2]
end
GO

/****** Object:  UserDefinedFunction [dbo].[FN_GENDTAB2]    Script Date: 3/24/2017 10:15:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_GENDTAB2] (@P_TOC as varchar(10))          
RETURNS TABLE          
as RETURN(          
Select G1.*
from GenDTab G1 Inner Join GenHTab G2 on (G2.FLDID=G1.FLDID) 
Where 
(
G2.SubClassF=0 or @P_TOC='' 
or (G2.SubClassF=1 and EXISTS (Select Top 1 ValueID from GenDTOC G3 Where G3.FLDID=G1.FLDID and G3.VALUEID=G1.VALUEID and G3.TOC=@P_TOC))
)
)        

GO

/****** Object:  UserDefinedFunction [dbo].[FN_QTOPRateCode]    Script Date: 5/8/2017 1:40:15 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FN_QTOPRateCode]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION  [FN_QTOPRateCode]
end
GO

/****** Object:  UserDefinedFunction [dbo].[FN_QTOPRateCode]    Script Date: 5/8/2017 1:40:15 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_QTOPRateCode] (@p_code varchar (10), @p_TOPRO varchar(10))
RETURNS TABLE  
AS RETURN (  
	SELECT RateTab.Code, RateTab.Description, RateTab.Unit, RateTab.NoRefundF, max(RClass.Category) as Category, sum(RateTab.Rate*RateCov.Portion/100) AS Rate, sum(RateCov.Portion) AS Portion  
	From RateTab, RateCov, Rclass, TOPRO  
	Where RateTab.Code Like @P_Code and RateTab.Code=RateCov.Code and Rclass.TOR=RateCov.TOR and Rclass.TOC=TOPRO.TOC and TOPRO.TOPRO=@P_TOPRO  
	Group By RateTab.Code, RateTab.Description, RateTab.Unit, RateTab.NoRefundF

) 
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FN_QTOPDedCode]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION  [FN_QTOPDedCode]
end
GO
/****** Object:  UserDefinedFunction [dbo].[FN_QTOPDedCode]    Script Date: 5/8/2017 1:40:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_QTOPDedCode] (@p_TOPRO varchar(10), @p_DCode varchar(10))
RETURNS TABLE  
AS RETURN (  
	Select Distinct Dedtab.DCODE, Dedtab.REMARKS, Dedtab.PCTTSI, PCTCL, FIXEDMIN, FIXEDMAX, CURRENCY, IUNIT
	From Rclass, DedTAB, TOPRO
	Where TOPRO.TOPRO=@P_TOPRO AND Rclass.TOC=TOPRO.TOC and Rclass.TOR=DedTAB.TOR and DedTAB.DCode Like @P_DCode
) 
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QRate_Ratcon]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE [QRate_Ratcon]
end
GO
CREATE PROCEDURE [dbo].[QRate_Ratcon] (@CODE Varchar(10) )      
AS      
 BEGIN      
 
 SELECT CAST(0 As Bit) ProcessFlag, RATECON, CODE,
 cast(coalesce(MinTSI, '0') as varchar(30)) +' - '+ cast(coalesce(MaxTSI, '0')as varchar(30)) as TSI, 
 cast(coalesce(MinRate, '0')  as varchar(30)) + ' - ' + cast(coalesce(MaxRate, '0') as varchar(30)) as 'RATEP', 
 cast(coalesce(MINPERIOD, '0')  as varchar(30)) + ' - ' + cast(coalesce(MAXPERIOD, '0') as varchar(30)) as 'Coverage',
 TEXCESS, ALLOWEDF, LOADING 
 from RateCon where CODE = @CODE 
 END

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[FN_QTOPRateCode]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION  [dbo].[FN_QTOPRateCode] 
end
GO
CREATE FUNCTION [dbo].[FN_QTOPRateCode] (@p_code varchar (10), @p_TOPRO varchar(10))
RETURNS TABLE  
AS RETURN (  
 SELECT RateTab.Code, RateTab.Description, RateTab.Unit, RateTab.NoRefundF, max(RClass.Category) as Category, sum(RateTab.Rate*RateCov.Portion/100) AS Rate, sum(RateCov.Portion) AS Portion , Max(RateTab.Description) as 'Remark'
 From RateTab, RateCov, Rclass, TOPRO  
 Where RateTab.Code Like @P_Code and RateTab.Code=RateCov.Code and Rclass.TOR=RateCov.TOR and Rclass.TOC=TOPRO.TOC and TOPRO.TOPRO=@P_TOPRO  
 Group By RateTab.Code, RateTab.Description, RateTab.Unit, RateTab.NoRefundF
 )




go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_Drop_TOC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE [dbo].[SP_Drop_TOC]
end
GO
Create Procedure [dbo].[SP_Drop_TOC] (@TOC varchar(10))    
as    
 begin    
  Delete From TOC Where TOC=@TOC;    
 end 

go





IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QTOC_RRule') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE QTOC_RRule
end
GO
CREATE PROCEDURE QTOC_RRule (@P_TOC AS VARCHAR(10),@RID AS int)       
AS       
SELECT  TOP 1           
TOC.RFLDID1, TOC.FLDTAG1, RenewalRule.ValueID1L AS ValueID1L,RenewalRule.ValueID1U AS ValueID1U,
TOC.RFLDID2, TOC.FLDTAG2,RenewalRule.ValueID2L AS ValueID2L,RenewalRule.ValueID2U AS ValueID2U,
TOC.RFLDID3, TOC.FLDTAG3, RenewalRule.ValueID3L AS ValueID3L,RenewalRule.ValueID3U AS ValueID3U,
TOC.RFLDID4, TOC.FLDTAG4, RenewalRule.ValueID4L AS ValueID4L,RenewalRule.ValueID4U AS ValueID4U,
TOC.RFLDID5, TOC.FLDTAG5, RenewalRule.ValueID5L AS ValueID5L,RenewalRule.ValueID5U AS ValueID5U
FROM       
RenewalRule, TOC      
LEFT OUTER JOIN GENHTAB as GENHTAB_1 ON TOC.RFLDID1<>'' AND TOC.RFLDID1 = GENHTAB_1.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_2 ON TOC.RFLDID2<>'' AND TOC.RFLDID2 = GENHTAB_2.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_3 ON TOC.RFLDID3<>'' AND TOC.RFLDID3 = GENHTAB_3.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_4 ON TOC.RFLDID4<>'' AND TOC.RFLDID4 = GENHTAB_4.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_5 ON TOC.RFLDID5<>'' AND TOC.RFLDID5 = GENHTAB_5.FLDID       
WHERE  
RenewalRule.TOC=TOC.TOC and 
TOC.TOC = @P_TOC and 
RenewalRule.RID=@RID
go

insert into PatchVersioning
select '02  Script WebSetup',GETDATE()
go