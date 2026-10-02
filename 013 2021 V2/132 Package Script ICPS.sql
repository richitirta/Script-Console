/****** Object:  UserDefinedFunction [dbo].[ICPS_PolicyDeductible]    Script Date: 20/04/2021 19:08:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF EXISTS ( SELECT  1
            FROM    Information_schema.Routines
            WHERE   Specific_schema = 'dbo'
                    AND specific_name = 'ICPS_PolicyDeductible'
                    AND Routine_Type = 'FUNCTION' ) 
BEGIN
	DROP Function [dbo].[ICPS_PolicyDeductible]
END
GO
CREATE Function [dbo].[ICPS_PolicyDeductible](@P_ANO as int, @P_Category as varchar(1))     
RETURNS VarChar(512)        
     
AS        
BEGIN        
 Declare @Remarks as varchar(512)        
 Declare @Remark as varchar(512)       
 Declare @Rate  as varchar(512)      
 Declare @Unit as varchar(512)      
          
 Select @Remarks=''        
 DECLARE AccDed_Cursor CURSOR FOR        
    
 Select Distinct Cast(AccDed.Remarks as varchar(512)) as Remark   
 from dbo.AccDed, dbo.Acceptance, dbo.Cover, dbo.RClass     
 Where Cover.CNO=Acceptance.CNO and AccDed.ANO=Acceptance.ANO   
 and RClass.TOC=Cover.TOC and RClass.TOR=AccDed.TOR and (RClass.Category=@P_Category or @P_Category='')     
 and Acceptance.ANO=@P_ANO  
  
 OPEN AccDed_Cursor        
 FETCH FROM AccDed_Cursor into @Remark    
 WHILE @@FETCH_STATUS = 0        
 BEGIN        
    if @Remarks=''        
    BEGIN        
  Select @Remarks=@Remark    
    End        
     Else        
    BEGIN        
     Select @Remarks=substring(@Remarks+'|'+@Remark,1,512)        
    End        
    FETCH NEXT FROM AccDed_Cursor into @Remark    
 End        
 Close AccDed_Cursor        
 Deallocate AccDed_Cursor        
 Return (@Remarks)        
End 

GO
/****** Object:  UserDefinedFunction [dbo].[ICPS_PolicyFacultative]    Script Date: 20/04/2021 19:08:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT  1
            FROM    Information_schema.Routines
            WHERE   Specific_schema = 'dbo'
                    AND specific_name = 'ICPS_PolicyFacultative'
                    AND Routine_Type = 'FUNCTION' ) 
BEGIN
	DROP Function [dbo].[ICPS_PolicyFacultative]
END
GO
CREATE Function [dbo].[ICPS_PolicyFacultative](@P_ANO as integer)            
RETURNS integer                     
AS                
BEGIN                
 Declare @FacultativeF as integer            
 DECLARE PolicyFacultative_Cursor CURSOR FOR   
 select (  
(Select count(*) from ACCEPTANCE A  
 inner join RARRDET RD on RD.ANO = A.ANO  
  where A.ANO=@P_ANO and RTYPE in ('AF','F'))  
+  
(Select count(*) from ACCEPTANCE A  
  inner join RARRHEADER RH on RH.ANO = A.ANO and RH.AID <> ''  
 where A.ANO=@P_ANO)  
 ) as sum  
 OPEN PolicyFacultative_Cursor        
  
 FETCH FROM PolicyFacultative_Cursor into @FacultativeF    
  
 Close PolicyFacultative_Cursor        
  
 Deallocate PolicyFacultative_Cursor        
  
 Return (@FacultativeF)                
  
End        
GO
/****** Object:  UserDefinedFunction [dbo].[ICPS_EfectiveDate]    Script Date: 20/04/2021 19:08:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT  1
            FROM    Information_schema.Routines
            WHERE   Specific_schema = 'dbo'
                    AND specific_name = 'ICPS_EfectiveDate'
                    AND Routine_Type = 'FUNCTION' ) 
BEGIN
	DROP Function [dbo].[ICPS_EfectiveDate]
END
GO
CREATE function [dbo].[ICPS_EfectiveDate](@P_PolicyNo as varchar(50),@P_CertificateNo as varchar(50), @P_Date as smalldatetime, @P_LOSSTIME as varchar(5))               
RETURNS Table               
AS Return (               
SELECT top 1 Acceptance.ANO, Acceptance.AName, Acceptance.PDate, Acceptance.PPDate, Acceptance.NCDate  
From ACCEPTANCE, COVER     
WHERE COVER.CNO=ACCEPTANCE.CNO AND COVER.CStatus not in ('R','P','C') AND ACCEPTANCE.AType Not in ('A','C') AND ACCEPTANCE.AStatus not in ('W','T') AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO     
AND ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO     
AND (  
(Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or  
(ACCEPTANCE.PDATE<=@P_DATE AND ACCEPTANCE.ExclusiveF=1) or   
 ((ACCEPTANCE.PDATE<@P_DATE or (ACCEPTANCE.PDATE=@P_DATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0)  
)               
AND   
(  
(dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCEPTANCE.PPDATE)>@P_DATE AND ACCEPTANCE.ExclusiveF=1) or   
((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCEPTANCE.PPDATE)>@P_DATE or   
(dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCEPTANCE.PPDATE)=@P_DATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0)  
)          
Order By ACCEPTANCE.ANO Desc    
)   
  
GO
/****** Object:  UserDefinedFunction [dbo].[ICPS_PolicyCoverage]    Script Date: 20/04/2021 19:08:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF EXISTS ( SELECT  1
            FROM    Information_schema.Routines
            WHERE   Specific_schema = 'dbo'
                    AND specific_name = 'ICPS_PolicyCoverage'
                    AND Routine_Type = 'FUNCTION' ) 
BEGIN
	DROP Function [dbo].[ICPS_PolicyCoverage]
END
GO
Create Function [dbo].[ICPS_PolicyCoverage](@P_ANO as int, @P_Category as varchar(1))   
RETURNS VarChar(1024)      
With SchemaBinding  
AS      
BEGIN      
 Declare @Remarks as varchar(1024)      
 Declare @Remark as varchar(1024)     
 Declare @Rate  as varchar(1024)    
 Declare @Unit as varchar(1024)    
        
 Select @Remarks=''      
 DECLARE RCover_Cursor CURSOR FOR      
 Select Distinct cast(Remark as varchar(1024)) as Remark, convert(varchar(25),cast(Rate as money),1) as Rate, Case When RCover.Unit='C' Then '%' When RCover.Unit='M' Then '%o' else 'Flat' end as Unit from DBO.RCover RCover     
 Where ANO=@P_ANO and (Category=@P_Category or @P_Category='')      
 OPEN RCover_Cursor      
 FETCH FROM RCover_Cursor into @Remark, @Rate, @Unit    
 WHILE @@FETCH_STATUS = 0      
 BEGIN      
    if @Remarks=''      
    BEGIN      
  Select @Remarks=@Remark+'('+@Rate+@Unit+')'    
    End      
     Else      
    BEGIN      
     Select @Remarks=substring(@Remarks+'|'+@Remark+'('+@Rate+@Unit+')',1,1024)      
    End      
    FETCH NEXT FROM RCover_Cursor into @Remark, @Rate, @Unit    
 End      
 Close RCover_Cursor      
 Deallocate RCover_Cursor      
 Return (@Remarks)      
End      

GO
/****** Object:  UserDefinedFunction [dbo].[ICPS_POLICYDATA]    Script Date: 20/04/2021 19:08:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT  1
            FROM    Information_schema.Routines
            WHERE   Specific_schema = 'dbo'
                    AND specific_name = 'ICPS_POLICYDATA'
                    AND Routine_Type = 'FUNCTION' ) 
BEGIN
	DROP Function [dbo].[ICPS_POLICYDATA]
END
GO
CREATE FUNCTION [dbo].[ICPS_POLICYDATA](@P_PolicyNo as varchar(50), @P_CertificateNo as varchar(50), @P_AName as varchar(255), @P_PoliceNo as varchar(255), @P_MachineNo as varchar(255), @P_ChasisNo as varchar(255), @P_PDate as smalldatetime)           
RETURNS Table               
AS Return (             
SELECT top 1 Acceptance.ANO, Acceptance.LANO,            
Case When Acceptance.LANO=-1 or Acceptance.ANO=Acceptance.LANO or Cover.OpenFlag=0 or Acceptance.BulkF=1 Then Acceptance.PolicyNo else Acceptance.PolicyNo+'-'+Acceptance.CertificateNo end as A_PolicyNo,                 
cast(ACCEPTANCE.AName as varchar(255)) AS AName, (Profile.Address_1 +' '+ Profile.Address_2 +' '+ Profile.Address_3)  as Address,             
Acceptance.Source as AGENTID,            
PROFILEAGENT.name as AGENTNAME,PROFILEAGENT.email as AGENTEMAIL,              
Profile.Email, Profile.Mobile_1 as Mobile,Profile.Phone_1 as Phone,            
ACCEPTANCE.POLICYNO AS PolicyNo,                 
ACCEPTANCE.CERTIFICATENO AS CertificateNo,                 
ACCEPTANCE.REFNO,                 
Acceptance.PDate,                 
Acceptance.PPDate,                 
COVER.ISTYPE,       
Acceptance.SDate as Inception,                 
Acceptance.EDate as Expiry,              
CAST(Case                 
  When AINFO.FLDID1='V34' Then AINFO.VALUEDESC1 When AINFO.FLDID2='V34' Then AINFO.VALUEDESC2 When AINFO.FLDID3='V34' Then AINFO.VALUEDESC3 When AINFO.FLDID4='V34' Then AINFO.VALUEDESC4 When AINFO.FLDID5='V34' Then AINFO.VALUEDESC5        
  When AINFO.FLDID6='V34' Then AINFO.VALUEDESC6 When AINFO.FLDID7='V34' Then AINFO.VALUEDESC7 When AINFO.FLDID8='V34' Then AINFO.VALUEDESC8 When AINFO.FLDID9='V34' Then AINFO.VALUEDESC9 When AINFO.FLDID10='V34' Then AINFO.VALUEDESC10        
  When AINFO.FLDID11='V34' Then AINFO.VALUEDESC11 When AINFO.FLDID12='V34' Then AINFO.VALUEDESC12 When AINFO.FLDID13='V34' Then AINFO.VALUEDESC13 When AINFO.FLDID14='V34' Then AINFO.VALUEDESC14 When AINFO.FLDID15='V34' Then AINFO.VALUEDESC15        
  END As Varchar(255)) As 'CAPACITY',                   
CAST(Case         
  When AINFO.FLDID1='V02' Then AINFO.VALUEID1 When AINFO.FLDID2='V02' Then AINFO.VALUEID2 When AINFO.FLDID3='V02' Then AINFO.VALUEID3 When AINFO.FLDID4='V02' Then AINFO.valueid4 When AINFO.FLDID5='V02' Then AINFO.valueid5                       
  When AINFO.FLDID6='V02' Then AINFO.VALUEID6 When AINFO.FLDID7='V02' Then AINFO.VALUEID7 When AINFO.FLDID8='V02' Then AINFO.VALUEID8 When AINFO.FLDID9='V02' Then AINFO.VALUEID9 When AINFO.FLDID10='V02' Then AINFO.valueid10                      
  When AINFO.FLDID11='V02' Then AINFO.VALUEID11 When AINFO.FLDID12='V02' Then AINFO.valueid12 When AINFO.FLDID13='V02' Then AINFO.valueid13 When AINFO.FLDID14='V02' Then AINFO.valueid14 When AINFO.FLDID15='V02' Then AINFO.valueid15                       
  END As Varchar(255)) As 'COLOUR',                      
      
CAST(Case                       
  When AINFO.FLDID1='V04' Then AINFO.VALUEDESC1 When AINFO.FLDID2='V04' Then AINFO.VALUEDESC2 When AINFO.FLDID3='V04' Then AINFO.VALUEDESC3 When AINFO.FLDID4='V04' Then AINFO.VALUEDESC4 When AINFO.FLDID5='V04' Then AINFO.VALUEDESC5                       
  When AINFO.FLDID6='V04' Then AINFO.VALUEDESC6 When AINFO.FLDID7='V04' Then AINFO.VALUEDESC7 When AINFO.FLDID8='V04' Then AINFO.VALUEDESC8 When AINFO.FLDID9='V04' Then AINFO.VALUEDESC9 When AINFO.FLDID10='V04' Then AINFO.VALUEDESC10                      
  When AINFO.FLDID11='V04' Then AINFO.VALUEDESC11 When AINFO.FLDID12='V04' Then AINFO.VALUEDESC12 When AINFO.FLDID13='V04' Then AINFO.VALUEDESC13 When AINFO.FLDID14='V04' Then AINFO.VALUEDESC14 When AINFO.FLDID15='V04' Then AINFO.VALUEDESC15              
  END As Varchar(255)) As 'POLICENO',                      
      
CAST(Case                       
  When AINFO.FLDID1='V13' Then AINFO.VALUEDESC1 When AINFO.FLDID2='V13' Then AINFO.VALUEDESC2 When AINFO.FLDID3='V13' Then AINFO.VALUEDESC3 When AINFO.FLDID4='V13' Then AINFO.VALUEDESC4 When AINFO.FLDID5='V13' Then AINFO.VALUEDESC5                       
  When AINFO.FLDID6='V13' Then AINFO.VALUEDESC6 When AINFO.FLDID7='V13' Then AINFO.VALUEDESC7 When AINFO.FLDID8='V13' Then AINFO.VALUEDESC8 When AINFO.FLDID9='V13' Then AINFO.VALUEDESC9 When AINFO.FLDID10='V13' Then AINFO.VALUEDESC10                      
  When AINFO.FLDID11='V13' Then AINFO.VALUEDESC11 When AINFO.FLDID12='V13' Then AINFO.VALUEDESC12 When AINFO.FLDID13='V13' Then AINFO.VALUEDESC13 When AINFO.FLDID14='V13' Then AINFO.VALUEDESC14 When AINFO.FLDID15='V13' Then AINFO.VALUEDESC15              
  END As Varchar(255)) As 'CHASISNO',                
            
CAST(Case                       
  When AINFO.FLDID1='V05' Then AINFO.VALUEDESC1 When AINFO.FLDID2='V05' Then AINFO.VALUEDESC2 When AINFO.FLDID3='V05' Then AINFO.VALUEDESC3 When AINFO.FLDID4='V05' Then AINFO.VALUEDESC4 When AINFO.FLDID5='V05' Then AINFO.VALUEDESC5                       
  When AINFO.FLDID6='V05' Then AINFO.VALUEDESC6 When AINFO.FLDID7='V05' Then AINFO.VALUEDESC7 When AINFO.FLDID8='V05' Then AINFO.VALUEDESC8 When AINFO.FLDID9='V05' Then AINFO.VALUEDESC9 When AINFO.FLDID10='V05' Then AINFO.VALUEDESC10                      
  When AINFO.FLDID11='V05' Then AINFO.VALUEDESC11 When AINFO.FLDID12='V05' Then AINFO.VALUEDESC12 When AINFO.FLDID13='V05' Then AINFO.VALUEDESC13 When AINFO.FLDID14='V05' Then AINFO.VALUEDESC14 When AINFO.FLDID15='V05' Then AINFO.VALUEDESC15              
  END As Varchar(255)) As 'MACHINENO',                
            
CAST(Case                       
  When AINFO.FLDID1='V16' Then AINFO.VALUEDESC1 When AINFO.FLDID2='V16' Then AINFO.VALUEDESC2 When AINFO.FLDID3='V16' Then AINFO.VALUEDESC3 When AINFO.FLDID4='V16' Then AINFO.VALUEDESC4 When AINFO.FLDID5='V16' Then AINFO.VALUEDESC5                       
  When AINFO.FLDID6='V16' Then AINFO.VALUEDESC6 When AINFO.FLDID7='V16' Then AINFO.VALUEDESC7 When AINFO.FLDID8='V16' Then AINFO.VALUEDESC8 When AINFO.FLDID9='V16' Then AINFO.VALUEDESC9 When AINFO.FLDID10='V16' Then AINFO.VALUEDESC10                      
  When AINFO.FLDID11='V16' Then AINFO.VALUEDESC11 When AINFO.FLDID12='V16' Then AINFO.VALUEDESC12 When AINFO.FLDID13='V16' Then AINFO.VALUEDESC13 When AINFO.FLDID14='V16' Then AINFO.VALUEDESC14 When AINFO.FLDID15='V16' Then AINFO.VALUEDESC15              
  END As Varchar(255)) As 'YEARBUILT',                
            
CAST(Case                       
  When AINFO.FLDID1='V31' Then AINFO.VALUEID1 When AINFO.FLDID2='V31' Then AINFO.VALUEID2 When AINFO.FLDID3='V31' Then AINFO.VALUEID3 When AINFO.FLDID4='V31' Then AINFO.VALUEID4 When AINFO.FLDID5='V31' Then AINFO.VALUEID5                       
  When AINFO.FLDID6='V31' Then AINFO.VALUEID6 When AINFO.FLDID7='V31' Then AINFO.VALUEID7 When AINFO.FLDID8='V31' Then AINFO.VALUEID8 When AINFO.FLDID9='V31' Then AINFO.VALUEID9 When AINFO.FLDID10='V31' Then AINFO.VALUEID10                      
  When AINFO.FLDID11='V31' Then AINFO.VALUEID11 When AINFO.FLDID12='V31' Then AINFO.VALUEID12 When AINFO.FLDID13='V31' Then AINFO.VALUEID13 When AINFO.FLDID14='V31' Then AINFO.VALUEID14 When AINFO.FLDID15='V31' Then AINFO.VALUEID15                      
  END As Varchar(255)) As 'CARMODEL',           
          
CAST(Case                       
  When AINFO.FLDID1='V31' Then AINFO.VALUEDESC1 When AINFO.FLDID2='V31' Then AINFO.VALUEDESC2 When AINFO.FLDID3='V31' Then AINFO.VALUEDESC3 When AINFO.FLDID4='V31' Then AINFO.VALUEDESC4 When AINFO.FLDID5='V31' Then AINFO.VALUEDESC5                       
  When AINFO.FLDID6='V31' Then AINFO.VALUEDESC6 When AINFO.FLDID7='V31' Then AINFO.VALUEDESC7 When AINFO.FLDID8='V31' Then AINFO.VALUEDESC8 When AINFO.FLDID9='V31' Then AINFO.VALUEDESC9 When AINFO.FLDID10='V31' Then AINFO.VALUEDESC10                      
  When AINFO.FLDID11='V31' Then AINFO.VALUEDESC11 When AINFO.FLDID12='V31' Then AINFO.VALUEDESC12 When AINFO.FLDID13='V31' Then AINFO.VALUEDESC13 When AINFO.FLDID14='V31' Then AINFO.VALUEDESC14 When AINFO.FLDID15='V31' Then AINFO.VALUEDESC15              
  END As Varchar(255)) As 'CARMODELDESC',                
            
CAST(Case                       
  When AINFO.FLDID1='V06' Then AINFO.VALUEID1 When AINFO.FLDID2='V06' Then AINFO.VALUEID2 When AINFO.FLDID3='V06' Then AINFO.VALUEID3 When AINFO.FLDID4='V06' Then AINFO.VALUEID4 When AINFO.FLDID5='V06' Then AINFO.VALUEID5                       
  When AINFO.FLDID6='V06' Then AINFO.VALUEID6 When AINFO.FLDID7='V06' Then AINFO.VALUEID7 When AINFO.FLDID8='V06' Then AINFO.VALUEID8 When AINFO.FLDID9='V06' Then AINFO.VALUEID9 When AINFO.FLDID10='V06' Then AINFO.VALUEID10                      
  When AINFO.FLDID11='V06' Then AINFO.VALUEID11 When AINFO.FLDID12='V06' Then AINFO.VALUEID12 When AINFO.FLDID13='V06' Then AINFO.VALUEID13 When AINFO.FLDID14='V06' Then AINFO.VALUEID14 When AINFO.FLDID15='V06' Then AINFO.VALUEID15                       
  END As Varchar(255)) As 'CARTYPE',         
          
CAST(Case                       
  When AINFO.FLDID1='V06' Then AINFO.VALUEDESC1 When AINFO.FLDID2='V06' Then AINFO.VALUEDESC2 When AINFO.FLDID3='V06' Then AINFO.VALUEDESC3 When AINFO.FLDID4='V06' Then AINFO.VALUEDESC4 When AINFO.FLDID5='V06' Then AINFO.VALUEDESC5                       
  When AINFO.FLDID6='V06' Then AINFO.VALUEDESC6 When AINFO.FLDID7='V06' Then AINFO.VALUEDESC7 When AINFO.FLDID8='V06' Then AINFO.VALUEDESC8 When AINFO.FLDID9='V06' Then AINFO.VALUEDESC9 When AINFO.FLDID10='V06' Then AINFO.VALUEDESC10                      
  When AINFO.FLDID11='V06' Then AINFO.VALUEDESC11 When AINFO.FLDID12='V06' Then AINFO.VALUEDESC12 When AINFO.FLDID13='V06' Then AINFO.VALUEDESC13 When AINFO.FLDID14='V06' Then AINFO.VALUEDESC14 When AINFO.FLDID15='V06' Then AINFO.VALUEDESC15              
  END As Varchar(255)) As 'CARTYPEDESC',                
            
CAST(Case                       
  When AINFO.FLDID1='V17' Then AINFO.VALUEID1 When AINFO.FLDID2='V17' Then AINFO.VALUEID2 When AINFO.FLDID3='V17' Then AINFO.VALUEID3 When AINFO.FLDID4='V17' Then AINFO.VALUEID4 When AINFO.FLDID5='V17' Then AINFO.VALUEID5                       
  When AINFO.FLDID6='V17' Then AINFO.VALUEID6 When AINFO.FLDID7='V17' Then AINFO.VALUEID7 When AINFO.FLDID8='V17' Then AINFO.VALUEID8 When AINFO.FLDID9='V17' Then AINFO.VALUEID9 When AINFO.FLDID10='V17' Then AINFO.VALUEID10                      
  When AINFO.FLDID11='V17' Then AINFO.VALUEID11 When AINFO.FLDID12='V17' Then AINFO.VALUEID12 When AINFO.FLDID13='V17' Then AINFO.VALUEID13 When AINFO.FLDID14='V17' Then AINFO.VALUEID14 When AINFO.FLDID15='V17' Then AINFO.VALUEID15                      
  END As Varchar(255)) As 'CARCLASS',           
          
CAST(Case        
  When AINFO.FLDID1='V17' Then AINFO.VALUEDESC1 When AINFO.FLDID2='V17' Then AINFO.VALUEDESC2 When AINFO.FLDID3='V17' Then AINFO.VALUEDESC3 When AINFO.FLDID4='V17' Then AINFO.VALUEDESC4 When AINFO.FLDID5='V17' Then AINFO.VALUEDESC5                 
  When AINFO.FLDID6='V17' Then AINFO.VALUEDESC6 When AINFO.FLDID7='V17' Then AINFO.VALUEDESC7 When AINFO.FLDID8='V17' Then AINFO.VALUEDESC8 When AINFO.FLDID9='V17' Then AINFO.VALUEDESC9 When AINFO.FLDID10='V17' Then AINFO.VALUEDESC10                      
  When AINFO.FLDID11='V17' Then AINFO.VALUEDESC11 When AINFO.FLDID12='V17' Then AINFO.VALUEDESC12 When AINFO.FLDID13='V17' Then AINFO.VALUEDESC13 When AINFO.FLDID14='V17' Then AINFO.VALUEDESC14 When AINFO.FLDID15='V17' Then AINFO.VALUEDESC15              
  END As Varchar(255)) As 'CARCLASSDESC',                
CAST(Case                       
  When AINFO.FLDID1='V01' Then AINFO.VALUEID1 When AINFO.FLDID2='V01' Then AINFO.VALUEID2 When AINFO.FLDID3='V01' Then AINFO.VALUEID3 When AINFO.FLDID4='V01' Then AINFO.VALUEID4 When AINFO.FLDID5='V01' Then AINFO.VALUEID5                       
  When AINFO.FLDID6='V01' Then AINFO.VALUEID6 When AINFO.FLDID7='V01' Then AINFO.VALUEID7 When AINFO.FLDID8='V01' Then AINFO.VALUEID8 When AINFO.FLDID9='V01' Then AINFO.VALUEID9 When AINFO.FLDID10='V01' Then AINFO.VALUEID10   
  When AINFO.FLDID11='V01' Then AINFO.VALUEID11 When AINFO.FLDID12='V01' Then AINFO.VALUEID12 When AINFO.FLDID13='V01' Then AINFO.VALUEID13 When AINFO.FLDID14='V01' Then AINFO.VALUEID14 When AINFO.FLDID15='V01' Then AINFO.VALUEID15                      
  END As Varchar(255)) As 'CARBRAND',        
CAST(Case                       
  When AINFO.FLDID1='V01' Then AINFO.VALUEDESC1 When AINFO.FLDID2='V01' Then AINFO.VALUEDESC2 When AINFO.FLDID3='V01' Then AINFO.VALUEDESC3 When AINFO.FLDID4='V01' Then AINFO.VALUEDESC4 When AINFO.FLDID5='V01' Then AINFO.VALUEDESC5                       
  When AINFO.FLDID6='V01' Then AINFO.VALUEDESC6 When AINFO.FLDID7='V01' Then AINFO.VALUEDESC7 When AINFO.FLDID8='V01' Then AINFO.VALUEDESC8 When AINFO.FLDID9='V01' Then AINFO.VALUEDESC9 When AINFO.FLDID10='V01' Then AINFO.VALUEDESC10                     
  When AINFO.FLDID11='V01' Then AINFO.VALUEDESC11 When AINFO.FLDID12='V01' Then AINFO.VALUEDESC12 When AINFO.FLDID13='V01' Then AINFO.VALUEDESC13 When AINFO.FLDID14='V01' Then AINFO.VALUEDESC14 When AINFO.FLDID15='V01' Then AINFO.VALUEDESC15              
  END As Varchar(255)) As 'CARBRANDDESC'        
FROM                      
COVER       
INNER JOIN ACCEPTANCE ON COVER.CNO = ACCEPTANCE.CNO                      
INNER JOIN AINFO AINFO ON ACCEPTANCE.ANO = AINFO.ANO                     
INNER JOIN PROFILE ON ACCEPTANCE.AID = PROFILE.ID                  
LEFT JOIN PROFILE PROFILEAGENT on PROFILEAGENT.id =  ACCEPTANCE.SOURCE                  
WHERE                       
(ACCEPTANCE.TOC Like '02%' OR ACCEPTANCE.TOC Like '52%')                       
AND (ACCEPTANCE.ANO<>ACCEPTANCE.LANO)                       
AND (ACCEPTANCE.ATYPE NOT IN ('C', 'A'))                       
AND (ACCEPTANCE.ASTATUS NOT IN ('W','T'))                       
AND (ACCEPTANCE.PDATE<>ACCEPTANCE.PPDATE)                       
AND (NOT (COVER.CSTATUS='C' AND ACCEPTANCE.ASTATUS='C'))                      
AND (@P_POLICYNO='' OR ACCEPTANCE.POLICYNO=@P_POLICYNO)                       
AND (@P_CERTIFICATENO='' OR ACCEPTANCE.CERTIFICATENO=@P_CERTIFICATENO)                      
AND (@P_ANAME='' OR ACCEPTANCE.ANAME Like '%'+@P_ANAME+'%')                       
AND (      
 @P_POLICENO='' OR       
 CAST(Case                       
   When AINFO.FLDID1='V04' Then AINFO.VALUEDESC1 When AINFO.FLDID2='V04' Then AINFO.VALUEDESC2 When AINFO.FLDID3='V04' Then AINFO.VALUEDESC3 When AINFO.FLDID4='V04' Then AINFO.VALUEDESC4 When AINFO.FLDID5='V04' Then AINFO.VALUEDESC5                       
   When AINFO.FLDID6='V04' Then AINFO.VALUEDESC6 When AINFO.FLDID7='V04' Then AINFO.VALUEDESC7 When AINFO.FLDID8='V04' Then AINFO.VALUEDESC8 When AINFO.FLDID9='V04' Then AINFO.VALUEDESC9 When AINFO.FLDID10='V04' Then AINFO.VALUEDESC10                     
   When AINFO.FLDID11='V04' Then AINFO.VALUEDESC11 When AINFO.FLDID12='V04' Then AINFO.VALUEDESC12 When AINFO.FLDID13='V04' Then AINFO.VALUEDESC13 When AINFO.FLDID14='V04' Then AINFO.VALUEDESC14 When AINFO.FLDID15='V04' Then AINFO.VALUEDESC15             
   END As Varchar(255))=@P_POLICYNO)      
AND (      
 @P_CHASISNO='' OR       
 CAST(Case                       
   When AINFO.FLDID1='V13' Then AINFO.VALUEDESC1 When AINFO.FLDID2='V13' Then AINFO.VALUEDESC2 When AINFO.FLDID3='V13' Then AINFO.VALUEDESC3 When AINFO.FLDID4='V13' Then AINFO.VALUEDESC4 When AINFO.FLDID5='V13' Then AINFO.VALUEDESC5                       
   When AINFO.FLDID6='V13' Then AINFO.VALUEDESC6 When AINFO.FLDID7='V13' Then AINFO.VALUEDESC7 When AINFO.FLDID8='V13' Then AINFO.VALUEDESC8 When AINFO.FLDID9='V13' Then AINFO.VALUEDESC9 When AINFO.FLDID10='V13' Then AINFO.VALUEDESC10                     
   When AINFO.FLDID11='V13' Then AINFO.VALUEDESC11 When AINFO.FLDID12='V13' Then AINFO.VALUEDESC12 When AINFO.FLDID13='V13' Then AINFO.VALUEDESC13 When AINFO.FLDID14='V13' Then AINFO.VALUEDESC14 When AINFO.FLDID15='V13' Then AINFO.VALUEDESC15             
   END As Varchar(255))=@P_CHASISNO)      
AND (      
 @P_MACHINENO='' OR      
 CAST(Case                       
   When AINFO.FLDID1='V05' Then AINFO.VALUEDESC1 When AINFO.FLDID2='V05' Then AINFO.VALUEDESC2 When AINFO.FLDID3='V05' Then AINFO.VALUEDESC3 When AINFO.FLDID4='V05' Then AINFO.VALUEDESC4 When AINFO.FLDID5='V05' Then AINFO.VALUEDESC5         
   When AINFO.FLDID6='V05' Then AINFO.VALUEDESC6 When AINFO.FLDID7='V05' Then AINFO.VALUEDESC7 When AINFO.FLDID8='V05' Then AINFO.VALUEDESC8 When AINFO.FLDID9='V05' Then AINFO.VALUEDESC9 When AINFO.FLDID10='V05' Then AINFO.VALUEDESC10                    
   When AINFO.FLDID11='V05' Then AINFO.VALUEDESC11 When AINFO.FLDID12='V05' Then AINFO.VALUEDESC12 When AINFO.FLDID13='V05' Then AINFO.VALUEDESC13 When AINFO.FLDID14='V05' Then AINFO.VALUEDESC14 When AINFO.FLDID15='V05' Then AINFO.VALUEDESC15             
   END As Varchar(255))=@P_MACHINENO)  
order by             
Case When (@P_PDATE Between ACCEPTANCE.PDATE and ACCEPTANCE.PPDATE) Then 1 Else 0 end Desc,            
Acceptance.ano desc                  
) 
GO
/****** Object:  UserDefinedFunction [dbo].[ICPS_PolicyDeductibleAmount]    Script Date: 20/04/2021 19:08:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT  1
            FROM    Information_schema.Routines
            WHERE   Specific_schema = 'dbo'
                    AND specific_name = 'ICPS_PolicyDeductibleAmount'
                    AND Routine_Type = 'FUNCTION' ) 
BEGIN
	DROP Function [dbo].[ICPS_PolicyDeductibleAmount]
END
GO
CREATE Function [dbo].[ICPS_PolicyDeductibleAmount](@P_ANO as integer, @P_COL as varchar(20), @P_INO as integer, @P_CTLF as bit, @P_PDate as smalldatetime, @P_LossTime as varchar(5))            
RETURNS TABLE  
AS Return  
(     
       Select  Max(Case When ACCDED.FixedMin<ACCDED.FixedMax Then ACCDED.FixedMax Else ACCDED.FixedMin end) as OwnRisk            
       From ACCEPTANCE, ACCDED, RCOVER, Col, DEDTAB, ICALC, ICOVER, TOI, COLNOCCLASS, NOC, NOCTAB  
       Where     
       ACCEPTANCE.ANO=@P_ANO  
       AND ACCDED.ANO=ACCEPTANCE.ANO  
       AND DEDTAB.DCODE=ACCDED.DCODE AND (DEDTAB.CTLF=0 OR DEDTAB.CTLF=@P_CTLF)  
       AND RCOVER.ANO=ACCEPTANCE.ANO  
       AND (RCover.RetroActiveF=1 or (ACCDED.SDATE<=@P_PDate AND ACCEPTANCE.ExclusiveF=1) or ((ACCDED.SDATE<@P_PDate or (ACCDED.SDATE=@P_PDate AND ACCEPTANCE.STIME<=@P_LossTime)) AND ACCEPTANCE.ExclusiveF=0))     
       AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)>@P_PDate AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)>@P_PDate or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)=@P_PDate AND ACCEPTANCE.STIME>@P_LossTime)) AND ACCEPTANCE.ExclusiveF=0))     
       AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=@P_PDate AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_PDate or (RCOVER.SDATE=@P_PDate AND ACCEPTANCE.STIME<=@P_LossTime)) AND ACCEPTANCE.ExclusiveF=0))     
       AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_PDate AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_PDate or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_PDate AND ACCEPTANCE.STIME>@P_LossTime)) AND ACCEPTANCE.ExclusiveF=0))     
       AND COL.COL=@P_COL  
       AND COL.TOR=ACCDED.TOR    
       AND ICALC.ANO=RCOVER.ANO  
       AND ICALC.CODE=RCOVER.CODE  
       AND ICALC.SDATE=RCOVER.SDATE  
       AND ICALC.TOR=COL.TOR     
       AND ICOVER.INO=ICALC.INO  
       AND ICOVER.INO=@P_INO  
       AND TOI.TOI=ICOVER.TOI  
       AND COLNOCCLASS.COL=COL.COL  
       AND NOC.NOC=COLNOCCLASS.NOC  
       AND NOC.TOI=ICOVER.TOI  
       AND NOC.CTLF=@P_CTLF  
       AND NOCTAB.NOC=NOC.NOC   
       AND NOCTAB.ICPSF=1   
       AND TOI.ICPSF=1  
       AND DEDTAB.ICPSF=1  
)  
GO
/****** Object:  UserDefinedFunction [dbo].[ICPS_PolicyInterestLimit]    Script Date: 20/04/2021 19:08:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT  1
            FROM    Information_schema.Routines
            WHERE   Specific_schema = 'dbo'
                    AND specific_name = 'ICPS_PolicyInterestLimit'
                    AND Routine_Type = 'FUNCTION' ) 
BEGIN
	DROP Function [dbo].[ICPS_PolicyInterestLimit]
END
GO
CREATE FUNCTION [dbo].[ICPS_PolicyInterestLimit](@P_ANO as Int, @P_COL as varchar(10), @P_CTLF as bit, @P_LossDate as smalldatetime, @P_LossTime as varchar(5), @P_ICPSCASCO as varchar(50), @P_ICPSTPL as varchar(50), @P_ICPSPADRIVER as varchar(50), @P_ICPSPAPASSENGER as varchar(50))     
         
RETURNS TABLE                 
AS RETURN (        
Select     
Max(Case When Category='M' or (charindex(TOI, @P_ICPSCASCO)<>0 or @P_ICPSCASCO='') Then Amount_1 else 0 end) as MainLimit,    
Max(Case When charindex(TOI, @P_ICPSTPL)<>0 Then Amount_1 else 0 end) as AddLimitTPL,    
Max(Case When charindex(TOI, @P_ICPSPADRIVER)<>0 Then Amount_1 else 0 end) as AddLimitPADRIVER,    
Max(Case When charindex(TOI, @P_ICPSPAPASSENGER)<>0 Then Amount_1 else 0 end) as AddLimitPAPASSENGER    
from    
(    
       Select Distinct     
       ICOVER.CATEGORY,     
       TOI.TOI,    
       ICOVERNOC.CURRENCY,     
       CASE     
       WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT/100*ICOVER.AMOUNT<>0 THEN    
              CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT/100*ICOVER.AMOUNT THEN ICOVERNOC.PCT/100*ICOVER.AMOUNT ELSE ICOVERNOC.AMOUNT END    
       WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT    
       ELSE ICOVERNOC.PCT/100*ICOVER.AMOUNT    
       END*(CASE WHEN ICOVERNOC.MAXQTY=0 THEN 1 ELSE ICOVERNOC.MAXQTY END) AS AMOUNT_1    
    
       from ICOVER, TOI, ICOVERNOC, NOC, COLNOCCLASS, NOCTAB, ACCEPTANCE             
       Where ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI    
          AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL  
       AND ACCEPTANCE.ANO=ICOVER.ANO      
       AND ((Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or (ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                         
       AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                                  
       AND ICOVER.ANO=@P_ANO AND TOI.TOI=ICOVER.TOI AND TOI.ICPSF=1             
       and NOCTAB.NOC=NOC.NOC and NOCTAB.ICPSF=1 and NOC.CTLF=@P_CTLF    
    
       Union All                            
                                                        
       Select Distinct     
       ICOVER.CATEGORY,     
       TOI.TOI,    
       ICOVER.CURRENCY,                          
       CASE                            
       WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT     
       ELSE ICOVER.AMOUNT*RCOVER.PCTLOSS/100      
       END  AS AMOUNT_1    
       From RCOVER, Col, RATECOV, PCLASS, ICOVER, TOI, NOC, NOCTAB, COLNOCCLASS, ACCEPTANCE                     
       Where RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL          
       AND (RCover.RetroActiveF=1 Or (RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                         
       AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                        
       AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                      
       AND NOC.TOI=ICOVER.TOI     
       AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=ICOVER.INO AND ICOVERNOC.NOC=NOC.NOC)                            
          AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL          
       AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)               
       AND ICOVER.ANO=@P_ANO AND TOI.TOI=ICOVER.TOI AND TOI.ICPSF=1     
       and NOCTAB.NOC=NOC.NOC and NOCTAB.ICPSF=1 and NOC.CTLF=@P_CTLF    
       ) C    
)           
GO
/****** Object:  UserDefinedFunction [dbo].[ICPS_PolicyPayment]    Script Date: 20/04/2021 19:08:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT  1
            FROM    Information_schema.Routines
            WHERE   Specific_schema = 'dbo'
                    AND specific_name = 'ICPS_PolicyPayment'
                    AND Routine_Type = 'FUNCTION' ) 
BEGIN
	DROP Function [dbo].[ICPS_PolicyPayment]
END
GO
CREATE FUNCTION [dbo].[ICPS_PolicyPayment](@P_A_PolicyNo as varchar(50),@P_PDate as smalldatetime)         
RETURNS Table         
AS return         
(       
Select  
       sum(PremiumPaid) as PremiumPaid,  
       Min(PremiumPaidDate) as PremiumPaidDate,  
       sum(PremiumOutstanding) as PremiumOutstanding,  
       sum(PremiumDue) as PremiumDue,  
       Min(PremiumDueDate) as PremiumDueDate  
from  
(  
       Select   
       nVoucher.Voucher,   
       case when nVoucher.DebtorF=1 Then nVoucher.Payment_CC else -nVoucher.Payment_CC end as PremiumPaid,   
       (Select Max(Case When coalesce(OVoucher.RefDate, pVoucher.RefDate)<coalesce(OVoucher.PDate, pVoucher.PDate) Then coalesce(OVoucher.RefDate, pVoucher.RefDate) else coalesce(OVoucher.PDate, pVoucher.PDate) end)       
              from pSL   
              Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)       
              Left Join pVoucher oVoucher on (oVoucher.Voucher=pVoucher.RefNo and oVoucher.SL_Cat='P')       
              Where pSL.PaymentF=1 and pSL.Doc_No=nVoucher.Voucher      
       ) as PremiumPaidDate,   
       case when nVoucher.DebtorF=1 Then (nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC) else -(nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC) end as PremiumOutstanding,    
       case when nVoucher.DebtorF=1 Then coalesce(Voucher_Due.AmountDue, nVoucher.Nominal_CC-nVoucher.Diff_CC) else -coalesce(Voucher_Due.AmountDue, nVoucher.Nominal_CC-nVoucher.Diff_CC) end as PremiumDue,  
       Case When Round(nVoucher.Payment_CC,2)<round((Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end),2) Then isnull(Voucher_Due.DueDate, nVoucher.DueDate) else Null end AS PremiumDueDate  
       FROM Admlink   
       Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)     
       Left Join Voucher_AmountDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=nVoucher.Voucher)     
       Where Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR')   
       and nVoucher.Date<=@P_PDate  
       and Admlink.A_PolicyNo=@P_A_PolicyNo  
) P  
)            
GO



 insert into PatchVersioning
select '132 Package Script ICPS',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='132 Package Script ICPS'


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