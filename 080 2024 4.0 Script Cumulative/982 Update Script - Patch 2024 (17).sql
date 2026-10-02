Drop function ListQry_3b_a
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
  a.VALUEID15 , a.VALUEDESC15,    
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
	a.VALUEID15 , a.VALUEDESC15
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


DROP function ListQry_3b_b
GO
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
  a.VALUEID15 , a.VALUEDESC15,      
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
Inner Join AInfo A on (a.ANO=q.ANO)    
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
Where 
(
	concat(valueID1,valuedesc1) Like '%'+@Value25+'%'  
	or concat(valueID2,valuedesc2) Like '%'+@Value25+'%'  
	or concat(valueID3,valuedesc3) Like '%'+@Value25+'%'  
	or concat(valueID4,valuedesc4) Like '%'+@Value25+'%'  
	or concat(valueID5,valuedesc5) Like '%'+@Value25+'%'  
	or concat(valueID6,valuedesc6) Like '%'+@Value25+'%'  
	or concat(valueID7,valuedesc7) Like '%'+@Value25+'%'  
	or concat(valueID8,valuedesc8) Like '%'+@Value25+'%'  
	or concat(valueID9,valuedesc9) Like '%'+@Value25+'%'  
	or concat(valueID10,valuedesc10) Like '%'+@Value25+'%'  
	or concat(valueID11,valuedesc11) Like '%'+@Value25+'%'  
	or concat(valueID12,valuedesc12) Like '%'+@Value25+'%'  
	or concat(valueID13,valuedesc13) Like '%'+@Value25+'%'  
	or concat(valueID14,valuedesc14) Like '%'+@Value25+'%'  
	or concat(valueID15,valuedesc15) Like '%'+@Value25+'%'  
)
)        

GO

DROP function ListQry_3_A
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
  a.VALUEID15 , a.VALUEDESC15,  
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
	a.VALUEID15 , a.VALUEDESC15
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

DROP function ListQry_3_b
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
  a.VALUEID15 , a.VALUEDESC15,  
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
Inner Join AInfo A on (a.ANO=q.ANO)    
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
Where 
(
	concat(valueID1,valuedesc1) Like '%'+@Value25+'%'  
	or concat(valueID2,valuedesc2) Like '%'+@Value25+'%'  
	or concat(valueID3,valuedesc3) Like '%'+@Value25+'%'  
	or concat(valueID4,valuedesc4) Like '%'+@Value25+'%'  
	or concat(valueID5,valuedesc5) Like '%'+@Value25+'%'  
	or concat(valueID6,valuedesc6) Like '%'+@Value25+'%'  
	or concat(valueID7,valuedesc7) Like '%'+@Value25+'%'  
	or concat(valueID8,valuedesc8) Like '%'+@Value25+'%'  
	or concat(valueID9,valuedesc9) Like '%'+@Value25+'%'  
	or concat(valueID10,valuedesc10) Like '%'+@Value25+'%'  
	or concat(valueID11,valuedesc11) Like '%'+@Value25+'%'  
	or concat(valueID12,valuedesc12) Like '%'+@Value25+'%'  
	or concat(valueID13,valuedesc13) Like '%'+@Value25+'%'  
	or concat(valueID14,valuedesc14) Like '%'+@Value25+'%'  
	or concat(valueID15,valuedesc15) Like '%'+@Value25+'%'  
)
)  

GO


      
insert into PatchVersioning
select '982 Update Script - Patch 2024 (17)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='982 Update Script - Patch 2024 (17)'


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
