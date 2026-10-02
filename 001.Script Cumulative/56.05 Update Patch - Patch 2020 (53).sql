
insert into PatchVersioning
select '56.5 Update Patch - Patch 2020 (53)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='56.4 Update Patch - Patch 2020 (52)'
Select @CurrSCript='56.5 Update Patch - Patch 2020 (53)'


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
			
		DROP PROCEDURE CLVIEW07L
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End

GO
CREATE PROCEDURE CLVIEW07L(@P_CNO AS INTEGER)  
AS  
SELECT cast(0 as Bit) as ProcessFlag, ClaAss.AdmNo, ClaAss.RefNo, ClaAss.BillDate, ClaAss.ClaimNo, ClaAss.ID, Profile.Name, ClaAss.Type, ClaAss.Currency as Currency_OC,  
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
END),  
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
ClaAss.Posted AS Posted  
FROM ClaAss Left Join Admlink on (Admlink.AdmNo=ClaAss.AdmNo), Profile  
WHERE Profile.ID=ClaAss.ID And ClaAss.CNO=@P_CNO  
GROUP BY ClaAss.AdmNo, ClaAss.RefNo, ClaAss.BillDate, ClaAss.ClaimNo, ClaAss.ID, Profile.Name, ClaAss.Type, ClaAss.Currency, ClaAss.Posted        


