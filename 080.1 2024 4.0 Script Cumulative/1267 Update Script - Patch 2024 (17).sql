if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'get_objectInfo_Search') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION get_objectInfo_Search
end
GO
Create function get_objectInfo_Search(@Value25 varchar(255))     
RETURNS @AInfo TABLE (ANO int Not Null Primary Key)
AS
BEGIN
	Select @Value25=rtrim(ltrim(replace(replace(replace(@Value25,'"',''),'*',''),'%','')))
	if @Value25<>'' 
	Begin
		Select @Value25='("'+replace(@Value25,' ','*" and "')+'*") or ' + '"'+@Value25+'"'
		Select @Value25=replace(@Value25,'and "*" ','')

		insert into @AInfo
		Select ANO
		from AINFO  
		Where 
		(
			contains((VALUEID1, VALUEDESC1, VALUEID2, VALUEDESC2, VALUEID3, VALUEDESC3, VALUEID4, VALUEDESC4, VALUEID5, VALUEDESC5, VALUEID6, VALUEDESC6, VALUEID7, VALUEDESC7, VALUEID8, VALUEDESC8, VALUEID9, VALUEDESC9, VALUEID10, VALUEDESC10, VALUEID11, VALUEDESC11, VALUEID12, VALUEDESC12, VALUEID13, VALUEDESC13, VALUEID14, VALUEDESC14, VALUEID15, VALUEDESC15),@Value25)
		)
	End
	else
	Begin
		insert into @AInfo
		Select cast(0 as Int) ANO Where 1<>1
	End
RETURN
END

go
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ListQry_3b_a') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
Drop function ListQry_3b_a
end
GO
CREATE function ListQry_3b_a (    
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),     
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),    
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),    
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),  
@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255)      
)          
RETURNS Table      
AS RETURN      
(      
SELECT Cast(0 as bit) as ProcessFlag,      
 [q].[COVERNO],      
 [q].[Insured],      
 [q].[CNO],      
 [q].[CStatus],      
 [q].[lANO],      
 [q].[ANO],      
 [q].[REGNO],      
 [q].[ADATE],      
 [q].[USERID],      
 [q].[Currency],       
 [q].[ASTATUS],      
 [q].[ATYPE],      
 [q].[SDate],      
 [q].[EDate],      
 [q].RYear,      
 [q].[ISType],      
 [q].[Renewal],      
 [q].[ESeqNo],      
 [q].[PolicyNo],      
 [q].[CertificateNo],      
 [q].[RefNo],      
 [q].[ProformaF],      
   a.valueid1, a.valuedesc1,    
  a.valueid2, a.valuedesc2,    
  a.valueid3, a.valuedesc3,    
  a.valueid4, a.valuedesc4,    
  a.valueid5, a.valuedesc5,    
  a.valueid6, a.valuedesc6,    
  a.valueid7, a.valuedesc7,    
  a.valueid8, a.valuedesc8,    
  a.valueid9, a.valuedesc9,    
  a.valueid10, a.valuedesc10,    
  a.valueid11, a.valuedesc11,    
  a.valueid12, a.valuedesc12,    
  a.valueid13, a.valuedesc13,    
  a.valueid14, a.valuedesc14,    
  a.VALUEID15, a.VALUEDESC15,    
  b.valueid16, b.valuedesc16,    
  b.valueid17, b.valuedesc17,    
  b.valueid18, b.valuedesc18,    
  b.valueid19, b.valuedesc19,    
  b.valueid20, b.valuedesc20,    
  b.valueid21, b.valuedesc21,    
  b.valueid22, b.valuedesc22,    
  b.valueid23, b.valuedesc23,    
  b.valueid24, b.valuedesc24,    
  b.valueid25, b.valuedesc25,    
  b.valueid26, b.valuedesc26,    
  b.valueid27, b.valuedesc27,    
  b.valueid28, b.valuedesc28,    
  b.valueid29, b.valuedesc29,    
  b.VALUEID30 , b.VALUEDESC30  
FROM  ListQry_3b (@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18,@Value19,@Value20,@Value21, @Value22, @Value23, @Value24) q  
Cross Apply (
	select 
	a.valueid1, a.valuedesc1,      
	a.valueid2, a.valuedesc2,      
	a.valueid3, a.valuedesc3,      
	a.valueid4, a.valuedesc4,      
	a.valueid5, a.valuedesc5,      
	a.valueid6, a.valuedesc6,      
	a.valueid7, a.valuedesc7,      
	a.valueid8, a.valuedesc8,      
	a.valueid9, a.valuedesc9,      
	a.valueid10, a.valuedesc10,      
	a.valueid11, a.valuedesc11,      
	a.valueid12, a.valuedesc12,      
	a.valueid13, a.valuedesc13,      
	a.valueid14, a.valuedesc14,      
	a.VALUEID15, a.VALUEDESC15
	from AInfo a
	Where a.ANO=q.ANO
) a
Outer Apply (
	select 
	b.valueid16, b.valuedesc16,      
	b.valueid17, b.valuedesc17,      
	b.valueid18, b.valuedesc18,      
	b.valueid19, b.valuedesc19,      
	b.valueid20, b.valuedesc20,      
	b.valueid21, b.valuedesc21,      
	b.valueid22, b.valuedesc22,      
	b.valueid23, b.valuedesc23,      
	b.valueid24, b.valuedesc24,      
	b.valueid25, b.valuedesc25,      
	b.valueid26, b.valuedesc26,      
	b.valueid27, b.valuedesc27,      
	b.valueid28, b.valuedesc28,      
	b.valueid29, b.valuedesc29,      
	b.ValueID30 , b.ValueDesc30
	from Ainfo_Ext b
	Where b.ANO=q.ANO
) b                
)      
  

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ListQry_3b_b') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
Drop function ListQry_3b_b
end
go
CREATE function ListQry_3b_b (      
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),       
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),      
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),      
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),    
@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255), @Value25 as varchar(255)        
)            
RETURNS Table        
AS RETURN        
(        
SELECT Cast(0 as bit) as ProcessFlag,        
 [q].[COVERNO],        
 [q].[Insured],        
 [q].[CNO],        
 [q].[CStatus],        
 [q].[lANO],        
 [q].[ANO],        
 [q].[REGNO],        
 [q].[ADATE],        
 [q].[USERID],        
 [q].[Currency],         
 [q].[ASTATUS],        
 [q].[ATYPE],        
 [q].[SDate],        
 [q].[EDate],        
 [q].RYear,        
 [q].[ISType],        
 [q].[Renewal],        
 [q].[ESeqNo],        
 [q].[PolicyNo],        
 [q].[CertificateNo],        
 [q].[RefNo],        
 [q].[ProformaF],        
   a.valueid1, a.valuedesc1,      
  a.valueid2, a.valuedesc2,      
  a.valueid3, a.valuedesc3,      
  a.valueid4, a.valuedesc4,      
  a.valueid5, a.valuedesc5,      
  a.valueid6, a.valuedesc6,      
  a.valueid7, a.valuedesc7,      
  a.valueid8, a.valuedesc8,      
  a.valueid9, a.valuedesc9,      
  a.valueid10, a.valuedesc10,      
  a.valueid11, a.valuedesc11,      
  a.valueid12, a.valuedesc12,      
  a.valueid13, a.valuedesc13,      
  a.valueid14, a.valuedesc14,      
  a.VALUEID15, a.VALUEDESC15,      
  b.valueid16, b.valuedesc16,      
  b.valueid17, b.valuedesc17,      
  b.valueid18, b.valuedesc18,      
  b.valueid19, b.valuedesc19,      
  b.valueid20, b.valuedesc20,      
  b.valueid21, b.valuedesc21,      
  b.valueid22, b.valuedesc22,      
  b.valueid23, b.valuedesc23,      
  b.valueid24, b.valuedesc24,      
  b.valueid25, b.valuedesc25,      
  b.valueid26, b.valuedesc26,      
  b.valueid27, b.valuedesc27,      
  b.valueid28, b.valuedesc28,      
  b.valueid29, b.valuedesc29,      
  b.VALUEID30 , b.VALUEDESC30    
From ListQry_3b (@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18,@Value19,@Value20,@Value21, @Value22, @Value23, @Value24) q
Inner Join get_objectInfo_Search(@Value25) S on (S.ANO=q.ANO)    
Cross Apply (
	select 
	a.valueid1, a.valuedesc1,      
	a.valueid2, a.valuedesc2,      
	a.valueid3, a.valuedesc3,      
	a.valueid4, a.valuedesc4,      
	a.valueid5, a.valuedesc5,      
	a.valueid6, a.valuedesc6,      
	a.valueid7, a.valuedesc7,      
	a.valueid8, a.valuedesc8,      
	a.valueid9, a.valuedesc9,      
	a.valueid10, a.valuedesc10,      
	a.valueid11, a.valuedesc11,      
	a.valueid12, a.valuedesc12,      
	a.valueid13, a.valuedesc13,      
	a.valueid14, a.valuedesc14,      
	a.VALUEID15, a.VALUEDESC15
	from AInfo a
	Where a.ANO=q.ANO
) a
Outer Apply (
	select 
	b.valueid16, b.valuedesc16,      
	b.valueid17, b.valuedesc17,      
	b.valueid18, b.valuedesc18,      
	b.valueid19, b.valuedesc19,      
	b.valueid20, b.valuedesc20,      
	b.valueid21, b.valuedesc21,      
	b.valueid22, b.valuedesc22,      
	b.valueid23, b.valuedesc23,      
	b.valueid24, b.valuedesc24,      
	b.valueid25, b.valuedesc25,      
	b.valueid26, b.valuedesc26,      
	b.valueid27, b.valuedesc27,      
	b.valueid28, b.valuedesc28,      
	b.valueid29, b.valuedesc29,      
	b.ValueID30 , b.ValueDesc30
	from Ainfo_Ext b
	Where b.ANO=q.ANO
) b          
)        

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ListQry_3_A') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function ListQry_3_A
end
GO
CREATE function ListQry_3_A (      
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),       
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),      
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),      
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),  
@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255)  
)            
RETURNS Table        
AS RETURN        
(        
SELECT Cast(0 as bit) as ProcessFlag,        
 Q.[COVERNO],        
 Q.[Insured],        
 Q.[CNO],        
 Q.[CStatus],        
 Q.[lANO],        
 Q.[ANO],        
 Q.[REGNO],        
 Q.[ADATE],        
 Q.[USERID],        
 Q.[Currency],         
 Q.[ASTATUS],        
 Q.[ATYPE],        
 Q.[SDate],        
 Q.[EDate],        
 Q.RYear,        
 Q.[ISType],        
 Q.[Renewal],        
 Q.[ESeqNo],        
 Q.[PolicyNo],        
 Q.[CertificateNo],        
 Q.RefNo,        
 Q.ProformaF,        
  a.valueid1, a.valuedesc1,    
  a.valueid2, a.valuedesc2,    
  a.valueid3, a.valuedesc3,    
  a.valueid4, a.valuedesc4,    
  a.valueid5, a.valuedesc5,    
  a.valueid6, a.valuedesc6,    
  a.valueid7, a.valuedesc7,    
  a.valueid8, a.valuedesc8,    
  a.valueid9, a.valuedesc9,    
  a.valueid10, a.valuedesc10,    
  a.valueid11, a.valuedesc11,    
  a.valueid12, a.valuedesc12,    
  a.valueid13, a.valuedesc13,    
  a.valueid14, a.valuedesc14,    
  a.VALUEID15, a.VALUEDESC15,  
  b.valueid16, b.valuedesc16,    
  b.valueid17, b.valuedesc17,    
  b.valueid18, b.valuedesc18,    
  b.valueid19, b.valuedesc19,    
  b.valueid20, b.valuedesc20,    
  b.valueid21, b.valuedesc21,    
  b.valueid22, b.valuedesc22,    
  b.valueid23, b.valuedesc23,    
  b.valueid24, b.valuedesc24,    
  b.valueid25, b.valuedesc25,    
  b.valueid26, b.valuedesc26,    
  b.valueid27, b.valuedesc27,    
  b.valueid28, b.valuedesc28,    
  b.valueid29, b.valuedesc29,    
  b.VALUEID30 , b.VALUEDESC30  
From LISTQRY_3(@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10, @Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18, @Value19, @Value20, @Value21, @Value22, @Value23, @Value24) q  
Cross Apply (
	select 
	a.valueid1, a.valuedesc1,      
	a.valueid2, a.valuedesc2,      
	a.valueid3, a.valuedesc3,      
	a.valueid4, a.valuedesc4,      
	a.valueid5, a.valuedesc5,      
	a.valueid6, a.valuedesc6,      
	a.valueid7, a.valuedesc7,      
	a.valueid8, a.valuedesc8,      
	a.valueid9, a.valuedesc9,      
	a.valueid10, a.valuedesc10,      
	a.valueid11, a.valuedesc11,      
	a.valueid12, a.valuedesc12,      
	a.valueid13, a.valuedesc13,      
	a.valueid14, a.valuedesc14,      
	a.VALUEID15, a.VALUEDESC15
	from AInfo a
	Where a.ANO=q.ANO_INFO
) a
Outer Apply (
	select 
	b.valueid16, b.valuedesc16,      
	b.valueid17, b.valuedesc17,      
	b.valueid18, b.valuedesc18,      
	b.valueid19, b.valuedesc19,      
	b.valueid20, b.valuedesc20,      
	b.valueid21, b.valuedesc21,      
	b.valueid22, b.valuedesc22,      
	b.valueid23, b.valuedesc23,      
	b.valueid24, b.valuedesc24,      
	b.valueid25, b.valuedesc25,      
	b.valueid26, b.valuedesc26,      
	b.valueid27, b.valuedesc27,      
	b.valueid28, b.valuedesc28,      
	b.valueid29, b.valuedesc29,      
	b.ValueID30 , b.ValueDesc30
	from Ainfo_Ext b
	Where b.ANO=q.ANO_INFO
) b                
)      

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ListQry_3_b') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function ListQry_3_b
end
GO
CREATE function ListQry_3_b (      
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),       
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),      
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),      
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),  
@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255), @Value25 as varchar(255)  
)            
RETURNS Table        
AS RETURN        
(        
SELECT Cast(0 as bit) as ProcessFlag,        
 Q.[COVERNO],        
 Q.[Insured],        
 Q.[CNO],        
 Q.[CStatus],        
 Q.[lANO],        
 Q.[ANO],        
 Q.[REGNO],        
 Q.[ADATE],        
 Q.[USERID],        
 Q.[Currency],         
 Q.[ASTATUS],        
 Q.[ATYPE],        
 Q.[SDate],        
 Q.[EDate],        
 Q.RYear,        
 Q.[ISType],        
 Q.[Renewal],        
 Q.[ESeqNo],        
 Q.[PolicyNo],        
 Q.[CertificateNo],        
 Q.RefNo,        
 Q.ProformaF,        
  a.valueid1, a.valuedesc1,    
  a.valueid2, a.valuedesc2,    
  a.valueid3, a.valuedesc3,    
  a.valueid4, a.valuedesc4,    
  a.valueid5, a.valuedesc5,    
  a.valueid6, a.valuedesc6,    
  a.valueid7, a.valuedesc7,    
  a.valueid8, a.valuedesc8,    
  a.valueid9, a.valuedesc9,    
  a.valueid10, a.valuedesc10,    
  a.valueid11, a.valuedesc11,    
  a.valueid12, a.valuedesc12,    
  a.valueid13, a.valuedesc13,    
  a.valueid14, a.valuedesc14,    
  a.VALUEID15, a.VALUEDESC15,  
  b.valueid16, b.valuedesc16,    
  b.valueid17, b.valuedesc17,    
  b.valueid18, b.valuedesc18,    
  b.valueid19, b.valuedesc19,    
  b.valueid20, b.valuedesc20,    
  b.valueid21, b.valuedesc21,    
  b.valueid22, b.valuedesc22,    
  b.valueid23, b.valuedesc23,    
  b.valueid24, b.valuedesc24,    
  b.valueid25, b.valuedesc25,    
  b.valueid26, b.valuedesc26,    
  b.valueid27, b.valuedesc27,    
  b.valueid28, b.valuedesc28,    
  b.valueid29, b.valuedesc29,    
  b.VALUEID30 , b.VALUEDESC30  
From LISTQRY_3(@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10, @Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18, @Value19, @Value20, @Value21, @Value22, @Value23, @Value24) q
Inner Join get_objectInfo_Search(@Value25) S on (S.ANO=q.ANO_INFO)    
Cross Apply (
	select 
	a.valueid1, a.valuedesc1,      
	a.valueid2, a.valuedesc2,      
	a.valueid3, a.valuedesc3,      
	a.valueid4, a.valuedesc4,      
	a.valueid5, a.valuedesc5,      
	a.valueid6, a.valuedesc6,      
	a.valueid7, a.valuedesc7,      
	a.valueid8, a.valuedesc8,      
	a.valueid9, a.valuedesc9,      
	a.valueid10, a.valuedesc10,      
	a.valueid11, a.valuedesc11,      
	a.valueid12, a.valuedesc12,      
	a.valueid13, a.valuedesc13,      
	a.valueid14, a.valuedesc14,      
	a.VALUEID15, a.VALUEDESC15
	from AInfo a
	Where a.ANO=q.ANO_INFO
) a
Outer Apply (
	select 
	b.valueid16, b.valuedesc16,      
	b.valueid17, b.valuedesc17,      
	b.valueid18, b.valuedesc18,      
	b.valueid19, b.valuedesc19,      
	b.valueid20, b.valuedesc20,      
	b.valueid21, b.valuedesc21,      
	b.valueid22, b.valuedesc22,      
	b.valueid23, b.valuedesc23,      
	b.valueid24, b.valuedesc24,      
	b.valueid25, b.valuedesc25,      
	b.valueid26, b.valuedesc26,      
	b.valueid27, b.valuedesc27,      
	b.valueid28, b.valuedesc28,      
	b.valueid29, b.valuedesc29,      
	b.ValueID30 , b.ValueDesc30
	from Ainfo_Ext b
	Where b.ANO=q.ANO_INFO
) b          
)        


GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MListQry_3_a') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function MListQry_3_a
end
GO
CREATE function MListQry_3_a(@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@value7 as varchar(255) ,@value8 as varchar(255), @value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255), @Value13 as varchar(255))     
returns table    
as return    
(    
SELECT   Cast(0 as bit) as ProcessFlag,     
  q.CoverNo,     
  q.Insured,     
  q.CNO,     
  q.CStatus,     
  q.VSeqNo,     
  q.lANO,     
  q.ANO,     
  q.REGNO,     
  q.ADATE,     
  q.USERID,     
  q.Currency,     
  q.TSI,     
  q.OurShare,     
  q.Gross,     
  q.ASTATUS,     
  q.ATYPE,     
  q.SDate,     
  q.EDate,     
  q.RYear,     
  q.ISType,     
  q.Renewal,     
  q.ESeqNo,     
  q.PolicyNo,    
  a.valueid1, a.valuedesc1,    
  a.valueid2, a.valuedesc2,    
  a.valueid3, a.valuedesc3,    
  a.valueid4, a.valuedesc4,    
  a.valueid5, a.valuedesc5,    
  a.valueid6, a.valuedesc6,    
  a.valueid7, a.valuedesc7,    
  a.valueid8, a.valuedesc8,    
  a.valueid9, a.valuedesc9,    
  a.valueid10, a.valuedesc10,    
  a.valueid11, a.valuedesc11,    
  a.valueid12, a.valuedesc12,    
  a.valueid13, a.valuedesc13,    
  a.valueid14, a.valuedesc14,    
  a.valueid15, a.valuedesc15,
  b.valueid16, b.valuedesc16,  
  b.valueid17, b.valuedesc17,  
  b.valueid18, b.valuedesc18,  
  b.valueid19, b.valuedesc19,  
  b.valueid20, b.valuedesc20,  
  b.valueid21, b.valuedesc21,  
  b.valueid22, b.valuedesc22,  
  b.valueid23, b.valuedesc23,  
  b.valueid24, b.valuedesc24,  
  b.valueid25, b.valuedesc25,  
  b.valueid26, b.valuedesc26,  
  b.valueid27, b.valuedesc27,  
  b.valueid28, b.valuedesc28,  
  b.valueid29, b.valuedesc29,  
  b.VALUEID30 , b.VALUEDESC30           
FROM  MListQry_3(@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10, @Value11, @Value12, @Value13) q
Cross Apply (
	select 
	a.valueid1, a.valuedesc1,      
	a.valueid2, a.valuedesc2,      
	a.valueid3, a.valuedesc3,      
	a.valueid4, a.valuedesc4,      
	a.valueid5, a.valuedesc5,      
	a.valueid6, a.valuedesc6,      
	a.valueid7, a.valuedesc7,      
	a.valueid8, a.valuedesc8,      
	a.valueid9, a.valuedesc9,      
	a.valueid10, a.valuedesc10,      
	a.valueid11, a.valuedesc11,      
	a.valueid12, a.valuedesc12,      
	a.valueid13, a.valuedesc13,      
	a.valueid14, a.valuedesc14,      
	a.VALUEID15, a.VALUEDESC15
	from AInfo a
	Where a.ANO=q.ano_info 
) a
Outer Apply (
	select 
	b.valueid16, b.valuedesc16,      
	b.valueid17, b.valuedesc17,      
	b.valueid18, b.valuedesc18,      
	b.valueid19, b.valuedesc19,      
	b.valueid20, b.valuedesc20,      
	b.valueid21, b.valuedesc21,      
	b.valueid22, b.valuedesc22,      
	b.valueid23, b.valuedesc23,      
	b.valueid24, b.valuedesc24,      
	b.valueid25, b.valuedesc25,      
	b.valueid26, b.valuedesc26,      
	b.valueid27, b.valuedesc27,      
	b.valueid28, b.valuedesc28,      
	b.valueid29, b.valuedesc29,      
	b.ValueID30 , b.ValueDesc30
	from Ainfo_Ext b
	Where b.ANO=q.ano_info
) b    
)  

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MListQry_3_b') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function MListQry_3_b
end
GO
CREATE function MListQry_3_b(@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@value7 as varchar(255) ,@value8 as varchar(255), @value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255), @Value13 as varchar(255), @Value14 as varchar(255))
returns table    
as return    
(    
SELECT   Cast(0 as bit) as ProcessFlag,     
  q.CoverNo,     
  q.Insured,     
  q.CNO,     
  q.CStatus,     
  q.VSeqNo,     
  q.lANO,     
  q.ANO,     
  q.REGNO,     
  q.ADATE,     
  q.USERID,     
  q.Currency,     
  q.TSI,     
  q.OurShare,     
  q.Gross,     
  q.ASTATUS,     
  q.ATYPE,     
  q.SDate,     
  q.EDate,     
  q.RYear,     
  q.ISType,     
  q.Renewal,     
  q.ESeqNo,     
  q.PolicyNo,    
  a.valueid1, a.valuedesc1,    
  a.valueid2, a.valuedesc2,    
  a.valueid3, a.valuedesc3,    
  a.valueid4, a.valuedesc4,    
  a.valueid5, a.valuedesc5,    
  a.valueid6, a.valuedesc6,    
  a.valueid7, a.valuedesc7,    
  a.valueid8, a.valuedesc8,    
  a.valueid9, a.valuedesc9,    
  a.valueid10, a.valuedesc10,    
  a.valueid11, a.valuedesc11,    
  a.valueid12, a.valuedesc12,    
  a.valueid13, a.valuedesc13,    
  a.valueid14, a.valuedesc14,    
  a.valueid15, a.valuedesc15,
  b.valueid16, b.valuedesc16,  
  b.valueid17, b.valuedesc17,  
  b.valueid18, b.valuedesc18,  
  b.valueid19, b.valuedesc19,  
  b.valueid20, b.valuedesc20,  
  b.valueid21, b.valuedesc21,  
  b.valueid22, b.valuedesc22,  
  b.valueid23, b.valuedesc23,  
  b.valueid24, b.valuedesc24,  
  b.valueid25, b.valuedesc25,  
  b.valueid26, b.valuedesc26,  
  b.valueid27, b.valuedesc27,  
  b.valueid28, b.valuedesc28,  
  b.valueid29, b.valuedesc29,  
  b.VALUEID30 , b.VALUEDESC30           
From MListQry_3(@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10, @Value11, @Value12, @Value13) q
Inner Join get_objectInfo_Search(@Value14) S on (S.ANO=q.ANO_Info)    
Cross Apply (
	select 
	a.valueid1, a.valuedesc1,      
	a.valueid2, a.valuedesc2,      
	a.valueid3, a.valuedesc3,      
	a.valueid4, a.valuedesc4,      
	a.valueid5, a.valuedesc5,      
	a.valueid6, a.valuedesc6,      
	a.valueid7, a.valuedesc7,      
	a.valueid8, a.valuedesc8,      
	a.valueid9, a.valuedesc9,      
	a.valueid10, a.valuedesc10,      
	a.valueid11, a.valuedesc11,      
	a.valueid12, a.valuedesc12,      
	a.valueid13, a.valuedesc13,      
	a.valueid14, a.valuedesc14,      
	a.VALUEID15, a.VALUEDESC15
	from AInfo a
	Where a.ANO=q.ANO_Info
) a
Outer Apply (
	select 
	b.valueid16, b.valuedesc16,      
	b.valueid17, b.valuedesc17,      
	b.valueid18, b.valuedesc18,      
	b.valueid19, b.valuedesc19,      
	b.valueid20, b.valuedesc20,      
	b.valueid21, b.valuedesc21,      
	b.valueid22, b.valuedesc22,      
	b.valueid23, b.valuedesc23,      
	b.valueid24, b.valuedesc24,      
	b.valueid25, b.valuedesc25,      
	b.valueid26, b.valuedesc26,      
	b.valueid27, b.valuedesc27,      
	b.valueid28, b.valuedesc28,      
	b.valueid29, b.valuedesc29,      
	b.ValueID30 , b.ValueDesc30
	from Ainfo_Ext b
	Where b.ANO=q.ANO_Info
) b          
)  

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MListQry_3b_a') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function MListQry_3b_a
end
GO
CREATE function MListQry_3b_a (@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255), @Value13 as varchar(255)) 
returns table
as return
(
SELECT 		Cast(0 as bit) as ProcessFlag, 
		q.[COVERNO], 
		q.[Insured], 
		q.[CNO], 
		q.[CStatus], 
		q.VSeqNo, 
		q.[lANO], 
		q.[ANO], 
		q.[REGNO], 
		q.[ADATE], 
		q.[USERID], 
		q.[Currency], 
		q.[TSI], 
		q.[OurShare], 
		q.[Gross], 
		q.[ASTATUS], 
		q.[ATYPE], 
		q.[SDate], 
		q.[EDate], 
		q.RYear, 
		q.[ISType], 
		q.[Renewal], 
		q.[ESeqNo], 
		q.[PolicyNo],
		a.valueid1, a.valuedesc1,
		a.valueid2, a.valuedesc2,
		a.valueid3, a.valuedesc3,
		a.valueid4, a.valuedesc4,
		a.valueid5, a.valuedesc5,
		a.valueid6, a.valuedesc6,
		a.valueid7, a.valuedesc7,
		a.valueid8, a.valuedesc8,
		a.valueid9, a.valuedesc9,
		a.valueid10, a.valuedesc10,
		a.valueid11, a.valuedesc11,
		a.valueid12, a.valuedesc12,
		a.valueid13, a.valuedesc13,
		a.valueid14, a.valuedesc14,
		a.valueid15, a.valuedesc15,
		b.valueid16, b.valuedesc16,  
		b.valueid17, b.valuedesc17,  
		b.valueid18, b.valuedesc18,  
		b.valueid19, b.valuedesc19,  
		b.valueid20, b.valuedesc20,  
		b.valueid21, b.valuedesc21,  
		b.valueid22, b.valuedesc22,  
		b.valueid23, b.valuedesc23,  
		b.valueid24, b.valuedesc24,  
		b.valueid25, b.valuedesc25,  
		b.valueid26, b.valuedesc26,  
		b.valueid27, b.valuedesc27,  
		b.valueid28, b.valuedesc28,  
		b.valueid29, b.valuedesc29,  
		b.VALUEID30 , b.VALUEDESC30   
FROM 	MListQry_3b(@Value1,@Value2,@Value3,@Value4,@Value5,@Value6,@Value7,@Value8,@Value9,@Value10,@Value11,@Value12, @value13) q
Cross Apply (
	select 
	a.valueid1, a.valuedesc1,      
	a.valueid2, a.valuedesc2,      
	a.valueid3, a.valuedesc3,      
	a.valueid4, a.valuedesc4,      
	a.valueid5, a.valuedesc5,      
	a.valueid6, a.valuedesc6,      
	a.valueid7, a.valuedesc7,      
	a.valueid8, a.valuedesc8,      
	a.valueid9, a.valuedesc9,      
	a.valueid10, a.valuedesc10,      
	a.valueid11, a.valuedesc11,      
	a.valueid12, a.valuedesc12,      
	a.valueid13, a.valuedesc13,      
	a.valueid14, a.valuedesc14,      
	a.VALUEID15, a.VALUEDESC15
	from AInfo a
	Where a.ANO=q.ANO
) a
Outer Apply (
	select 
	b.valueid16, b.valuedesc16,      
	b.valueid17, b.valuedesc17,      
	b.valueid18, b.valuedesc18,      
	b.valueid19, b.valuedesc19,      
	b.valueid20, b.valuedesc20,      
	b.valueid21, b.valuedesc21,      
	b.valueid22, b.valuedesc22,      
	b.valueid23, b.valuedesc23,      
	b.valueid24, b.valuedesc24,      
	b.valueid25, b.valuedesc25,      
	b.valueid26, b.valuedesc26,      
	b.valueid27, b.valuedesc27,      
	b.valueid28, b.valuedesc28,      
	b.valueid29, b.valuedesc29,      
	b.ValueID30 , b.ValueDesc30
	from Ainfo_Ext b
	Where b.ANO=q.ANO
) b      
)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MListQry_3b_b') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function MListQry_3b_b
end
GO
CREATE function MListQry_3b_b (@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255), @Value13 as varchar(255), @Value14 as varchar(255)) 
returns table
as return
(
SELECT 		Cast(0 as bit) as ProcessFlag, 
		q.[COVERNO], 
		q.[Insured], 
		q.[CNO], 
		q.[CStatus], 
		q.VSeqNo, 
		q.[lANO], 
		q.[ANO], 
		q.[REGNO], 
		q.[ADATE], 
		q.[USERID], 
		q.[Currency], 
		q.[TSI], 
		q.[OurShare], 
		q.[Gross], 
		q.[ASTATUS], 
		q.[ATYPE], 
		q.[SDate], 
		q.[EDate], 
		q.RYear, 
		q.[ISType], 
		q.[Renewal], 
		q.[ESeqNo], 
		q.[PolicyNo],
		a.valueid1, a.valuedesc1,
		a.valueid2, a.valuedesc2,
		a.valueid3, a.valuedesc3,
		a.valueid4, a.valuedesc4,
		a.valueid5, a.valuedesc5,
		a.valueid6, a.valuedesc6,
		a.valueid7, a.valuedesc7,
		a.valueid8, a.valuedesc8,
		a.valueid9, a.valuedesc9,
		a.valueid10, a.valuedesc10,
		a.valueid11, a.valuedesc11,
		a.valueid12, a.valuedesc12,
		a.valueid13, a.valuedesc13,
		a.valueid14, a.valuedesc14,
		a.valueid15, a.valuedesc15,
		b.valueid16, b.valuedesc16,  
		b.valueid17, b.valuedesc17,  
		b.valueid18, b.valuedesc18,  
		b.valueid19, b.valuedesc19,  
		b.valueid20, b.valuedesc20,  
		b.valueid21, b.valuedesc21,  
		b.valueid22, b.valuedesc22,  
		b.valueid23, b.valuedesc23,  
		b.valueid24, b.valuedesc24,  
		b.valueid25, b.valuedesc25,  
		b.valueid26, b.valuedesc26,  
		b.valueid27, b.valuedesc27,  
		b.valueid28, b.valuedesc28,  
		b.valueid29, b.valuedesc29,  
		b.VALUEID30 , b.VALUEDESC30   
From MListQry_3b(@Value1,@Value2,@Value3,@Value4,@Value5,@Value6,@Value7,@Value8,@Value9,@Value10,@Value11,@Value12, @value13) q
Inner Join get_objectInfo_Search(@Value14) S on (S.ANO=q.ANO)    
Cross Apply (
	select 
	a.valueid1, a.valuedesc1,      
	a.valueid2, a.valuedesc2,      
	a.valueid3, a.valuedesc3,      
	a.valueid4, a.valuedesc4,      
	a.valueid5, a.valuedesc5,      
	a.valueid6, a.valuedesc6,      
	a.valueid7, a.valuedesc7,      
	a.valueid8, a.valuedesc8,      
	a.valueid9, a.valuedesc9,      
	a.valueid10, a.valuedesc10,      
	a.valueid11, a.valuedesc11,      
	a.valueid12, a.valuedesc12,      
	a.valueid13, a.valuedesc13,      
	a.valueid14, a.valuedesc14,      
	a.VALUEID15, a.VALUEDESC15
	from AInfo a
	Where a.ANO=q.ANO
) a
Outer Apply (
	select 
	b.valueid16, b.valuedesc16,      
	b.valueid17, b.valuedesc17,      
	b.valueid18, b.valuedesc18,      
	b.valueid19, b.valuedesc19,      
	b.valueid20, b.valuedesc20,      
	b.valueid21, b.valuedesc21,      
	b.valueid22, b.valuedesc22,      
	b.valueid23, b.valuedesc23,      
	b.valueid24, b.valuedesc24,      
	b.valueid25, b.valuedesc25,      
	b.valueid26, b.valuedesc26,      
	b.valueid27, b.valuedesc27,      
	b.valueid28, b.valuedesc28,      
	b.valueid29, b.valuedesc29,      
	b.ValueID30 , b.ValueDesc30
	from Ainfo_Ext b
	Where b.ANO=q.ANO
) b    

)

go



 
  insert into PatchVersioning
select '1267 Update Script - Patch 2024 (17)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1267 Update Script - Patch 2024 (17)'


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





