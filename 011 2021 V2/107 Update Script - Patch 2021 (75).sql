DROP PROCEDURE PI12 
GO
CREATE PROCEDURE PI12 (@P_ANO as integer)
AS

DECLARE @GROSS Float
DECLARE @P_LANO INT

Select @P_LANO=A.LANO, @GROSS=PCALC.GROSS from ACCEPTANCE A LEFT JOIN FN_PCALC(@P_ANO) PCALC ON (A.ANO=PCALC.ANO) WHERE A.ANO=@P_ANO

if (@P_ANO=@P_LANO or @P_LANO=-1)
Begin
	SELECT PAYOR.*, @GROSS AS GROSS
	FROM PAYOR
	WHERE PAYOR.ANO=@P_ANO
End
else
Begin
	if exists(Select ANO from APayor Where ANO=@P_ANO)
	Begin
		SELECT PAYOR.*, @GROSS AS GROSS
		FROM APAYOR PAYOR
		WHERE PAYOR.ANO=@P_ANO
	End
	else
	Begin
		SELECT PAYOR.*, @GROSS AS GROSS
		FROM PAYOR
		WHERE PAYOR.ANO=@P_LANO
	End
End
go




DROP PROCEDURE PI12_1 
GO
Create  Procedure [dbo].[PI12_1](@P_ANO as integer)      
as        
Begin      
Declare @PI12_1 Table (Item Varchar(1024), Date Varchar(1024), PCT float, Amount float)  
 
Declare @Item1 as varchar(1024)      
Declare @Date1 as varchar(1024)        
Declare @PCT1 as float  
Declare @Amount1 as float  
Declare @Item2 as varchar(1024)      
Declare @Date2 as varchar(1024)        
Declare @PCT2 as float  
Declare @Amount2 as float  
Declare @Item3 as varchar(1024)      
Declare @Date3 as varchar(1024)        
Declare @PCT3 as float  
Declare @Amount3 as float  
Declare @Item4 as varchar(1024)      
Declare @Date4 as varchar(1024)        
Declare @PCT4 as float  
Declare @Amount4 as float  
Declare @Item5 as varchar(1024)      
Declare @Date5 as varchar(1024)        
Declare @PCT5 as float  
Declare @Amount5 as float  
Declare @Item6 as varchar(1024)      
Declare @Date6 as varchar(1024)        
Declare @PCT6 as float  
Declare @Amount6 as float  
Declare @Item7 as varchar(1024)      
Declare @Date7 as varchar(1024)        
Declare @PCT7 as float  
Declare @Amount7 as float  
Declare @Item8 as varchar(1024)      
Declare @Date8 as varchar(1024)        
Declare @PCT8 as float  
Declare @Amount8 as float  
Declare @Item9 as varchar(1024)      
Declare @Date9 as varchar(1024)        
Declare @PCT9 as float  
Declare @Amount9 as float  
Declare @Item10 as varchar(1024)      
Declare @Date10 as varchar(1024)        
Declare @PCT10 as float  
Declare @Amount10 as float  
Declare @Item11 as varchar(1024)      
Declare @Date11 as varchar(1024)        
Declare @PCT11 as float  
Declare @Amount11 as float  
Declare @Item12 as varchar(1024)      
Declare @Date12 as varchar(1024)        
Declare @PCT12 as float  
Declare @Amount12 as float

Declare @Item13 as varchar(1024)      
Declare @Date13 as varchar(1024)        
Declare @PCT13 as float  
Declare @Amount13 as float  
Declare @Item14 as varchar(1024)      
Declare @Date14 as varchar(1024)        
Declare @PCT14 as float  
Declare @Amount14 as float 
Declare @Item15 as varchar(1024)      
Declare @Date15 as varchar(1024)        
Declare @PCT15 as float  
Declare @Amount15 as float  
Declare @Item16 as varchar(1024)      
Declare @Date16 as varchar(1024)        
Declare @PCT16 as float  
Declare @Amount16 as float  
Declare @Item17 as varchar(1024)      
Declare @Date17 as varchar(1024)        
Declare @PCT17 as float  
Declare @Amount17 as float  
Declare @Item18 as varchar(1024)      
Declare @Date18 as varchar(1024)        
Declare @PCT18 as float  
Declare @Amount18 as float  
Declare @Item19 as varchar(1024)      
Declare @Date19 as varchar(1024)        
Declare @PCT19 as float  
Declare @Amount19 as float  
Declare @Item20 as varchar(1024)      
Declare @Date20 as varchar(1024)        
Declare @PCT20 as float  
Declare @Amount20 as float  
Declare @Item21 as varchar(1024)      
Declare @Date21 as varchar(1024)        
Declare @PCT21 as float  
Declare @Amount21 as float
Declare @Item22 as varchar(1024)      
Declare @Date22 as varchar(1024)        
Declare @PCT22 as float  
Declare @Amount22 as float
Declare @Item23 as varchar(1024)      
Declare @Date23 as varchar(1024)        
Declare @PCT23 as float  
Declare @Amount23 as float
Declare @Item24 as varchar(1024)      
Declare @Date24 as varchar(1024)        
Declare @PCT24 as float  
Declare @Amount24 as float

DECLARE @GROSS Float
DECLARE @P_LANO INT
Declare @PayorTemp Table (IDate_1 Smalldatetime, IDate_2 Smalldatetime, IDate_3 Smalldatetime, IDate_4 Smalldatetime,IDate_5 Smalldatetime,IDate_6 Smalldatetime,IDate_7 Smalldatetime,IDate_8 Smalldatetime,IDate_9 Smalldatetime,IDate_10 Smalldatetime,IDate_11 Smalldatetime,IDate_12 Smalldatetime,
IDate_13 Smalldatetime, IDate_14 Smalldatetime, IDate_15 Smalldatetime, IDate_16 Smalldatetime,IDate_17 Smalldatetime,IDate_18 Smalldatetime,IDate_19 Smalldatetime,IDate_20 Smalldatetime,IDate_21 Smalldatetime,IDate_22 Smalldatetime,IDate_23 Smalldatetime,IDate_24 Smalldatetime,
IPCT_1 float,IPCT_2 float,IPCT_3 float,IPCT_4 float,IPCT_5 float,IPCT_6 float,IPCT_7 float,IPCT_8 float,IPCT_9 float,IPCT_10 float,IPCT_11 float,IPCT_12 float, 
IPCT_13 float,IPCT_14 float,IPCT_15 float,IPCT_16 float,IPCT_17 float,IPCT_18 float,IPCT_19 float,IPCT_20 float,IPCT_21 float,IPCT_22 float,IPCT_23 float,IPCT_24 float,
GROSS Float)  


Select @P_LANO=A.LANO, @GROSS=PCALC.GROSS from ACCEPTANCE A LEFT JOIN FN_PCALC(@P_ANO) PCALC ON (A.ANO=PCALC.ANO) WHERE A.ANO=@P_ANO

if (@P_ANO=@P_LANO or @P_LANO=-1)
Begin
	INSERT INTO @PayorTemp
	SELECT IDate_1, IDate_2, IDate_3, IDate_4, IDate_5, IDate_6, IDate_7, IDate_8, IDate_9, IDate_10, IDate_11, IDate_12, IDate_13, IDate_14, IDate_15, IDate_16, IDate_17, IDate_18, IDate_19, IDate_20, IDate_21, IDate_22, IDate_23, IDate_24, IPCT_1, IPCT_2, IPCT_3, IPCT_4, IPCT_5, IPCT_6, IPCT_7, IPCT_8, IPCT_9, IPCT_10, IPCT_11, IPCT_12,IPCT_13, IPCT_14, IPCT_15, IPCT_16, IPCT_17, IPCT_18, IPCT_19, IPCT_20, IPCT_21, IPCT_22, IPCT_23, IPCT_24, @GROSS AS GROSS 
	FROM PAYOR
	WHERE PAYOR.ANO=@P_ANO
End
else
Begin
	if exists(Select ANO from APayor Where ANO=@P_ANO)
	Begin
		INSERT INTO @PayorTemp
		SELECT IDate_1, IDate_2, IDate_3, IDate_4, IDate_5, IDate_6, IDate_7, IDate_8, IDate_9, IDate_10, IDate_11, IDate_12, IDate_13, IDate_14, IDate_15, IDate_16, IDate_17, IDate_18, IDate_19, IDate_20, IDate_21, IDate_22, IDate_23, IDate_24, IPCT_1, IPCT_2, IPCT_3, IPCT_4, IPCT_5, IPCT_6, IPCT_7, IPCT_8, IPCT_9, IPCT_10, IPCT_11, IPCT_12,IPCT_13, IPCT_14, IPCT_15, IPCT_16, IPCT_17, IPCT_18, IPCT_19, IPCT_20, IPCT_21, IPCT_22, IPCT_23, IPCT_24, @GROSS AS GROSS 
		FROM APAYOR PAYOR
		WHERE PAYOR.ANO=@P_ANO
	End
	else
	Begin
		INSERT INTO @PayorTemp
		SELECT IDate_1, IDate_2, IDate_3, IDate_4, IDate_5, IDate_6, IDate_7, IDate_8, IDate_9, IDate_10, IDate_11, IDate_12, IDate_13, IDate_14, IDate_15, IDate_16, IDate_17, IDate_18, IDate_19, IDate_20, IDate_21, IDate_22, IDate_23, IDate_24, IPCT_1, IPCT_2, IPCT_3, IPCT_4, IPCT_5, IPCT_6, IPCT_7, IPCT_8, IPCT_9, IPCT_10, IPCT_11, IPCT_12,IPCT_13, IPCT_14, IPCT_15, IPCT_16, IPCT_17, IPCT_18, IPCT_19, IPCT_20, IPCT_21, IPCT_22, IPCT_23, IPCT_24, @GROSS AS GROSS 
		FROM PAYOR
		WHERE PAYOR.ANO=@P_LANO
	End
End
 
DECLARE PI12_1_Cursor CURSOR FOR        
Select       
'01' as Item1, IDate_1 as Date1, IPCT_1 as PCT1, IPCT_1/100*GROSS as Amount1,  
'02' as Item2, IDate_2 as Date2, IPCT_2 as PCT2, IPCT_2/100*GROSS as Amount2,  
'03' as Item3, IDate_3 as Date3, IPCT_3 as PCT3, IPCT_3/100*GROSS as Amount3,  
'04' as Item4, IDate_4 as Date4, IPCT_4 as PCT4, IPCT_4/100*GROSS as Amount4,  
'05' as Item5, IDate_5 as Date5, IPCT_5 as PCT5, IPCT_5/100*GROSS as Amount5,  
'06' as Item6, IDate_6 as Date6, IPCT_6 as PCT6, IPCT_6/100*GROSS as Amount6,  
'07' as Item7, IDate_7 as Date7, IPCT_7 as PCT7, IPCT_7/100*GROSS as Amount7,  
'08' as Item8, IDate_8 as Date8, IPCT_8 as PCT8, IPCT_8/100*GROSS as Amount8,  
'09' as Item9, IDate_9 as Date9, IPCT_9 as PCT9, IPCT_9/100*GROSS as Amount9,  
'10' as Item10, IDate_10 as Date10, IPCT_10 as PCT10, IPCT_10/100*GROSS as Amount10,  
'11' as Item11, IDate_11 as Date11, IPCT_11 as PCT11, IPCT_11/100*GROSS as Amount11,  
'12' as Item12, IDate_12 as Date12, IPCT_12 as PCT12, IPCT_12/100*GROSS as Amount12,
'13' as Item13, IDate_13 as Date13, IPCT_13 as PCT13, IPCT_13/100*GROSS as Amount13,  
'14' as Item14, IDate_14 as Date14, IPCT_14 as PCT14, IPCT_14/100*GROSS as Amount14,
'15' as Item15, IDate_15 as Date15, IPCT_15 as PCT15, IPCT_15/100*GROSS as Amount15,
'16' as Item16, IDate_16 as Date16, IPCT_16 as PCT16, IPCT_16/100*GROSS as Amount16,  
'17' as Item17, IDate_17 as Date17, IPCT_17 as PCT17, IPCT_17/100*GROSS as Amount17,  
'18' as Item18, IDate_18 as Date18, IPCT_18 as PCT18, IPCT_18/100*GROSS as Amount18, 
'19' as Item19, IDate_19 as Date19, IPCT_19 as PCT19, IPCT_19/100*GROSS as Amount19,
'20' as Item20, IDate_20 as Date20, IPCT_20 as PCT20, IPCT_20/100*GROSS as Amount20,  
'21' as Item21, IDate_21 as Date21, IPCT_21 as PCT21, IPCT_21/100*GROSS as Amount21,  
'22' as Item22, IDate_22 as Date22, IPCT_22 as PCT22, IPCT_22/100*GROSS as Amount22,  
'23' as Item23, IDate_23 as Date23, IPCT_23 as PCT23, IPCT_23/100*GROSS as Amount23,  
'24' as Item24, IDate_24 as Date24, IPCT_24 as PCT24, IPCT_24/100*GROSS as Amount24  
from @PayorTemp   
 
OPEN PI12_1_Cursor        
FETCH FROM PI12_1_Cursor into       
     @Item1, @Date1, @PCT1, @Amount1,      
     @Item2, @Date2, @PCT2, @Amount2,      
     @Item3, @Date3, @PCT3, @Amount3,      
     @Item4, @Date4, @PCT4, @Amount4,      
     @Item5, @Date5, @PCT5, @Amount5,      
     @Item6, @Date6, @PCT6, @Amount6,      
     @Item7, @Date7, @PCT7, @Amount7,      
     @Item8, @Date8, @PCT8, @Amount8,      
     @Item9, @Date9, @PCT9, @Amount9,      
     @Item10, @Date10, @PCT10, @Amount10,      
     @Item11, @Date11, @PCT11, @Amount11,      
     @Item12, @Date12, @PCT12, @Amount12,
	 @Item13, @Date13, @PCT13, @Amount13,
	 @Item14, @Date14, @PCT14, @Amount14,
	 @Item15, @Date15, @PCT15, @Amount15,
	 @Item16, @Date16, @PCT16, @Amount16,
	 @Item17, @Date17, @PCT17, @Amount17,
	 @Item18, @Date18, @PCT18, @Amount18,
	 @Item19, @Date19, @PCT19, @Amount19,
	 @Item20, @Date20, @PCT20, @Amount20,
	 @Item21, @Date21, @PCT21, @Amount21,
	 @Item22, @Date22, @PCT22, @Amount22,
	 @Item23, @Date23, @PCT23, @Amount23,
	 @Item24, @Date24, @PCT24, @Amount24
Close PI12_1_Cursor        
Deallocate PI12_1_Cursor        
 
insert into @PI12_1 Values(@Item1, @Date1, @PCT1, @Amount1)
insert into @PI12_1 Values(@Item2, @Date2, @PCT2, @Amount2)      
insert into @PI12_1 Values(@Item3, @Date3, @PCT3, @Amount3)      
insert into @PI12_1 Values(@Item4, @Date4, @PCT4, @Amount4)      
insert into @PI12_1 Values(@Item5, @Date5, @PCT5, @Amount5)      
insert into @PI12_1 Values(@Item6, @Date6, @PCT6, @Amount6)      
insert into @PI12_1 Values(@Item7, @Date7, @PCT7, @Amount7)      
insert into @PI12_1 Values(@Item8, @Date8, @PCT8, @Amount8)      
insert into @PI12_1 Values(@Item9, @Date9, @PCT9, @Amount9)  
insert into @PI12_1 Values(@Item10, @Date10, @PCT10, @Amount10)  
insert into @PI12_1 Values(@Item11, @Date11, @PCT11, @Amount11)  
insert into @PI12_1 Values(@Item12, @Date12, @PCT12, @Amount12)  
insert into @PI12_1 Values(@Item13, @Date13, @PCT13, @Amount13)  
insert into @PI12_1 Values(@Item14, @Date14, @PCT14, @Amount14)  
insert into @PI12_1 Values(@Item15, @Date15, @PCT15, @Amount15)  
insert into @PI12_1 Values(@Item16, @Date16, @PCT16, @Amount16)  
insert into @PI12_1 Values(@Item17, @Date17, @PCT17, @Amount17)  
insert into @PI12_1 Values(@Item18, @Date18, @PCT18, @Amount18)  
insert into @PI12_1 Values(@Item19, @Date19, @PCT19, @Amount19)  
insert into @PI12_1 Values(@Item20, @Date20, @PCT20, @Amount20)  
insert into @PI12_1 Values(@Item21, @Date21, @PCT21, @Amount21)  
insert into @PI12_1 Values(@Item22, @Date22, @PCT22, @Amount22)  
insert into @PI12_1 Values(@Item23, @Date23, @PCT23, @Amount23)  
insert into @PI12_1 Values(@Item24, @Date24, @PCT24, @Amount24)  
Select * from @PI12_1 
--Where Amount<>0     
end      

go




--VERSIONING
insert into PatchVersioning
select '107 Update Script - Patch 2021 (75)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='107 Update Script - Patch 2021 (75)'


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