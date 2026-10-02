IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue1' AND Object_ID = Object_ID(N'COBext'))
BEGIN
ALTER TABLE dbo.COBext ADD
	DefValue1 varchar(255) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue2' AND Object_ID = Object_ID(N'COBext'))
BEGIN
ALTER TABLE dbo.COBext ADD
	DefValue2 varchar(255) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue3' AND Object_ID = Object_ID(N'COBext'))
BEGIN
ALTER TABLE dbo.COBext ADD
	DefValue3 varchar(255) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue4' AND Object_ID = Object_ID(N'COBext'))
BEGIN
ALTER TABLE dbo.COBext ADD
	DefValue4 varchar(255) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue5' AND Object_ID = Object_ID(N'COBext'))
BEGIN
ALTER TABLE dbo.COBext ADD
	DefValue5 varchar(255) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue6' AND Object_ID = Object_ID(N'COBext'))
BEGIN
ALTER TABLE dbo.COBext ADD
	DefValue6 varchar(255) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue7' AND Object_ID = Object_ID(N'COBext'))
BEGIN
ALTER TABLE dbo.COBext ADD
	DefValue7 varchar(255) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue8' AND Object_ID = Object_ID(N'COBext'))
BEGIN
ALTER TABLE dbo.COBext ADD
	DefValue8 varchar(255) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue9' AND Object_ID = Object_ID(N'COBext'))
BEGIN
ALTER TABLE dbo.COBext ADD
	DefValue9 varchar(255) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue10' AND Object_ID = Object_ID(N'COBext'))
BEGIN
ALTER TABLE dbo.COBext ADD
	DefValue10 varchar(255) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue11' AND Object_ID = Object_ID(N'COBext'))
BEGIN
ALTER TABLE dbo.COBext ADD
	DefValue11 varchar(255) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue12' AND Object_ID = Object_ID(N'COBext'))
BEGIN
ALTER TABLE dbo.COBext ADD
	DefValue12 varchar(255) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue13' AND Object_ID = Object_ID(N'COBext'))
BEGIN
ALTER TABLE dbo.COBext ADD
	DefValue13 varchar(255) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue14' AND Object_ID = Object_ID(N'COBext'))
BEGIN
ALTER TABLE dbo.COBext ADD
	DefValue14 varchar(255) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DefValue15' AND Object_ID = Object_ID(N'COBext'))
BEGIN
ALTER TABLE dbo.COBext ADD
	DefValue15 varchar(255) NULL
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCOBEXT_DEFVALUE') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QCOBEXT_DEFVALUE 
END
GO
CREATE PROCEDURE QCOBEXT_DEFVALUE (@P_COB AS VARCHAR(10),@P_Category as varchar(50)='')  
AS         
Select   
G1.ValueID as ValueID1, coalesce(G1.Description, COB.DefValue1) as ValueDesc1,  
G2.ValueID as ValueID2, coalesce(G2.Description, COB.DefValue2) as ValueDesc2,  
G3.ValueID as ValueID3, coalesce(G3.Description, COB.DefValue3) as ValueDesc3,  
G4.ValueID as ValueID4, coalesce(G4.Description, COB.DefValue4) as ValueDesc4,  
G5.ValueID as ValueID5, coalesce(G5.Description, COB.DefValue5) as ValueDesc5,  
G6.ValueID as ValueID6, coalesce(G6.Description, COB.DefValue6) as ValueDesc6,  
G7.ValueID as ValueID7, coalesce(G7.Description, COB.DefValue7) as ValueDesc7,  
G8.ValueID as ValueID8, coalesce(G8.Description, COB.DefValue8) as ValueDesc8,  
G9.ValueID as ValueID9, coalesce(G9.Description, COB.DefValue9) as ValueDesc9,  
G10.ValueID as ValueID10, coalesce(G10.Description, COB.DefValue10) as ValueDesc10,  
G11.ValueID as ValueID11, coalesce(G11.Description, COB.DefValue11) as ValueDesc11,  
G12.ValueID as ValueID12, coalesce(G12.Description, COB.DefValue12) as ValueDesc12,  
G13.ValueID as ValueID13, coalesce(G13.Description, COB.DefValue13) as ValueDesc13,  
G14.ValueID as ValueID14, coalesce(G14.Description, COB.DefValue14) as ValueDesc14,  
G15.ValueID as ValueID15, coalesce(G15.Description, COB.DefValue15) as ValueDesc15  
from COBEXT COB
Left Join GenDTab G1 on (G1.FLDID=COB.FLDID1 and G1.VALUEID=COB.DefValue1)   
Left Join GenDTab G2 on (G2.FLDID=COB.FLDID2 and G2.VALUEID=COB.DefValue2)   
Left Join GenDTab G3 on (G3.FLDID=COB.FLDID3 and G3.VALUEID=COB.DefValue3)   
Left Join GenDTab G4 on (G4.FLDID=COB.FLDID4 and G4.VALUEID=COB.DefValue4)   
Left Join GenDTab G5 on (G5.FLDID=COB.FLDID5 and G5.VALUEID=COB.DefValue5)   
Left Join GenDTab G6 on (G6.FLDID=COB.FLDID6 and G6.VALUEID=COB.DefValue6)   
Left Join GenDTab G7 on (G7.FLDID=COB.FLDID7 and G7.VALUEID=COB.DefValue7)   
Left Join GenDTab G8 on (G8.FLDID=COB.FLDID8 and G8.VALUEID=COB.DefValue8)   
Left Join GenDTab G9 on (G9.FLDID=COB.FLDID9 and G9.VALUEID=COB.DefValue9)   
Left Join GenDTab G10 on (G10.FLDID=COB.FLDID10 and G10.VALUEID=COB.DefValue10)   
Left Join GenDTab G11 on (G11.FLDID=COB.FLDID11 and G11.VALUEID=COB.DefValue11)   
Left Join GenDTab G12 on (G12.FLDID=COB.FLDID12 and G12.VALUEID=COB.DefValue12)   
Left Join GenDTab G13 on (G13.FLDID=COB.FLDID13 and G13.VALUEID=COB.DefValue13)   
Left Join GenDTab G14 on (G14.FLDID=COB.FLDID14 and G14.VALUEID=COB.DefValue14)   
Left Join GenDTab G15 on (G15.FLDID=COB.FLDID15 and G15.VALUEID=COB.DefValue15)   
WHERE  COB.COB = @P_COB and COB.Category = @P_Category  

GO


  insert into PatchVersioning
select '1163 Update Script - 12 September 2024',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1163 Update Script - 12 September 2024'


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
