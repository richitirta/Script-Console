SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLVIEW07L') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE CLVIEW07L  END 
GO

CREATE PROCEDURE CLVIEW07L(@P_CNO AS INTEGER)  
AS  
SELECT cast(0 as Bit) as ProcessFlag, ClaAss.AdmNo, ClaAss.RefNo, 
Max(ClaAss.BillDate) as BillDate, 
Max(ClaAss.ClaimNo) as ClaimNo, 
ClaAss.ID, 
Max(Profile.Name) as Name, 
ClaAss.Type, 
ClaAss.RefID, ClaAss.RefName,
ClaAss.Currency, 
'CLAIM'=sum(  
CASE  
        WHEN CLAASS.CODE='A' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'DEDUCTIBLE'=sum(  
CASE  
        WHEN CLAASS.CODE='E' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'COST'=sum(  
CASE  
        WHEN CLAASS.CODE='L' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'SALVAGE'=sum(  
CASE  
        WHEN CLAASS.CODE='S' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'SUBROGATION'=sum(  
CASE  
        WHEN CLAASS.CODE='R' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'ADJUSTMENT'=sum(  
CASE  
        WHEN CLAASS.CODE='I' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'PREMIUM'=sum(  
CASE  
        WHEN CLAASS.CODE='P' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'VAT'=sum(  
CASE  
        WHEN CLAASS.CODE='V' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'TAX'=sum(  
CASE  
        WHEN CLAASS.CODE='T' THEN ClaAss.AMOUNT  
        ELSE 0  
END)
+
Max(coalesce(Admlink.Amount_18,0)),  
'FEE'=sum(  
CASE  
        WHEN CLAASS.CODE='F' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
'DUTY'=sum(  
CASE  
        WHEN CLAASS.CODE='D' THEN ClaAss.AMOUNT  
        ELSE 0  
END),  
cast(Max(cast(ClaAss.CashLossF as int)) as Bit) as CashLossF,
cast(Max(cast(ClaAss.Posted as int)) as Bit) as Posted
FROM ClaAss 
Left Join Admlink on (Admlink.AdmNo=ClaAss.AdmNo)
Inner Join Profile on (Profile.ID=ClaAss.ID)
WHERE ClaAss.CNO=@P_CNO  
GROUP BY ClaAss.AdmNo, ClaAss.RefNo, ClaAss.ID, ClaAss.Type, ClaAss.Currency, ClaAss.RefID, ClaAss.RefName

GO

insert into PatchVersioning
select '1453 Update Script - patch 2025 (50)',GETDATE()
go	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrScript='1453 Update Script - patch 2025 (50)'


Declare @ExecScript varchar(100)
Declare @ExecScriptStatus varchar(100)
Declare @Error varchar(200)

Select @Error=''

Begin 
       Select @ExecScript=ExecScript,  @ExecScriptStatus=ExecScriptStatus from systab 
       if @PrevScript<>'' and @ExecScript<>@PrevScript
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

GO