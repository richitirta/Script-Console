IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCheck_Object_SysBatchUp') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QCheck_Object_SysBatchUp
end
GO
CREATE Procedure QCheck_Object_SysBatchUp(
@OBJ_INFO_01 varchar(8000), 
@OBJ_INFO_02 varchar(8000), 
@OBJ_INFO_03 varchar(8000), 
@OBJ_INFO_04 varchar(8000), 
@OBJ_INFO_05 varchar(8000), 
@OBJ_INFO_06 varchar(8000), 
@OBJ_INFO_07 varchar(8000), 
@OBJ_INFO_08 varchar(8000), 
@OBJ_INFO_09 varchar(8000), 
@OBJ_INFO_10 varchar(8000), 
@OBJ_INFO_11 varchar(8000), 
@OBJ_INFO_12 varchar(8000), 
@OBJ_INFO_13 varchar(8000), 
@OBJ_INFO_14 varchar(8000), 
@OBJ_INFO_15 varchar(8000),
@DESCRIPTION1 varchar(8000), 
@DESCRIPTION2 varchar(8000), 
@DESCRIPTION3 varchar(8000), 
@DESCRIPTION4 varchar(8000), 
@DESCRIPTION5 varchar(8000), 
@DESCRIPTION6 varchar(8000), 
@DESCRIPTION7 varchar(8000), 
@DESCRIPTION8 varchar(8000), 
@DESCRIPTION9 varchar(8000), 
@DESCRIPTION10 varchar(8000), 
@DESCRIPTION11 varchar(8000), 
@DESCRIPTION12 varchar(8000), 
@DESCRIPTION13 varchar(8000), 
@DESCRIPTION14 varchar(8000), 
@DESCRIPTION15 varchar(8000)
)   
as   
SELECT  Top 1   
S2.BID,   
S2.PolicyNo as [Policy No],   
S2.Insured,   
S2.Inception,   
S2.Expiry,   
S2.ANO   
from   
SysBatchUP S2  
Inner Join SysBatchUP_Ext S2_Ext on (S2_Ext.BID=S2.BID)
Inner Join SysBatchH S1 on (S1.BatchNO = S2.BatchNO)  
Where OBJ_INFO_01=Case When @OBJ_INFO_01='' Then OBJ_INFO_01 else @OBJ_INFO_01 End
and OBJ_INFO_02=Case When @OBJ_INFO_02='' Then OBJ_INFO_02 else @OBJ_INFO_02 End
and OBJ_INFO_03=Case When @OBJ_INFO_03='' Then OBJ_INFO_03 else @OBJ_INFO_03 End
and OBJ_INFO_04=Case When @OBJ_INFO_04='' Then OBJ_INFO_04 else @OBJ_INFO_04 End
and OBJ_INFO_05=Case When @OBJ_INFO_05='' Then OBJ_INFO_05 else @OBJ_INFO_05 End
and OBJ_INFO_06=Case When @OBJ_INFO_06='' Then OBJ_INFO_06 else @OBJ_INFO_06 End
and OBJ_INFO_07=Case When @OBJ_INFO_07='' Then OBJ_INFO_07 else @OBJ_INFO_07 End
and OBJ_INFO_08=Case When @OBJ_INFO_08='' Then OBJ_INFO_08 else @OBJ_INFO_08 End
and OBJ_INFO_09=Case When @OBJ_INFO_09='' Then OBJ_INFO_09 else @OBJ_INFO_09 End
and OBJ_INFO_10=Case When @OBJ_INFO_10='' Then OBJ_INFO_10 else @OBJ_INFO_10 End
and OBJ_INFO_11=Case When @OBJ_INFO_11='' Then OBJ_INFO_11 else @OBJ_INFO_11 End
and OBJ_INFO_12=Case When @OBJ_INFO_12='' Then OBJ_INFO_12 else @OBJ_INFO_12 End
and OBJ_INFO_13=Case When @OBJ_INFO_13='' Then OBJ_INFO_13 else @OBJ_INFO_13 End
and OBJ_INFO_14=Case When @OBJ_INFO_14='' Then OBJ_INFO_14 else @OBJ_INFO_14 End
and OBJ_INFO_15=Case When @OBJ_INFO_15='' Then OBJ_INFO_15 else @OBJ_INFO_15 End
and DESCRIPTION1=Case When @DESCRIPTION1='' Then DESCRIPTION1 else @DESCRIPTION1 End
and DESCRIPTION2=Case When @DESCRIPTION2='' Then DESCRIPTION2 else @DESCRIPTION2 End
and DESCRIPTION3=Case When @DESCRIPTION3='' Then DESCRIPTION3 else @DESCRIPTION3 End
and DESCRIPTION4=Case When @DESCRIPTION4='' Then DESCRIPTION4 else @DESCRIPTION4 End
and DESCRIPTION5=Case When @DESCRIPTION5='' Then DESCRIPTION5 else @DESCRIPTION5 End
and DESCRIPTION6=Case When @DESCRIPTION6='' Then DESCRIPTION6 else @DESCRIPTION6 End
and DESCRIPTION7=Case When @DESCRIPTION7='' Then DESCRIPTION7 else @DESCRIPTION7 End
and DESCRIPTION8=Case When @DESCRIPTION8='' Then DESCRIPTION8 else @DESCRIPTION8 End
and DESCRIPTION9=Case When @DESCRIPTION9='' Then DESCRIPTION9 else @DESCRIPTION9 End
and DESCRIPTION10=Case When @DESCRIPTION10='' Then DESCRIPTION10 else @DESCRIPTION10 End
and DESCRIPTION11=Case When @DESCRIPTION11='' Then DESCRIPTION11 else @DESCRIPTION11 End
and DESCRIPTION12=Case When @DESCRIPTION12='' Then DESCRIPTION12 else @DESCRIPTION12 End
and DESCRIPTION13=Case When @DESCRIPTION13='' Then DESCRIPTION13 else @DESCRIPTION13 End
and DESCRIPTION14=Case When @DESCRIPTION14='' Then DESCRIPTION14 else @DESCRIPTION14 End
and DESCRIPTION15=Case When @DESCRIPTION15='' Then DESCRIPTION15 else @DESCRIPTION15 End
and OBJ_INFO_15=Case When @OBJ_INFO_15='' Then OBJ_INFO_15 else @OBJ_INFO_15 End
and S1.Status in ('T','R','P')   
and (S2.Status in ('W') or (S2.Status in ('N') and S2.ErrMsg in ('On-Progress...')))  
   
GO



  insert into PatchVersioning
select '1263 Update Script - Patch 2024 (92)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1263 Update Script - Patch 2024 (92)'


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


