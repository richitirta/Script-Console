
DROP PROCEDURE QCLAASS_3
GO
CREATE PROCEDURE QCLAASS_3(@P_CNO int,@P_RefNo varchar(50), @P_Type varchar(255),@P_ID varchar(255),@P_CCY varchar(255))   
as   
SELECT    
ClaAss.CNO,  
ClaAss.RefNo,   
Max(ClaAss.Date) as Date,   
Max(ClaAss.BillDate) as BillDate,   
Datediff(day,Max(ClaAss.Date),Max(ClaAss.BillDate)) as Grace,  
ClaAss.TOC,   
Max(ClaAss.DocNo) as DocNo,   
Max(ClaAss.ClaimNo) as ClaimNo,   
Max(ClaAss.Remarks) as Remarks,   
ClaAss.ID,   
Max(Profile.Name) as Name,   
ClaAss.Type,   
ClaAss.Currency,  
Max(ClaAss.BizMapID) as BizMapID,  
Max(ClaAss.Source) as Source,  
Max(ClaAss.MSCode) as MSCode,  
Max(ClaAss.RCode) as RCode,  
Max(ClaAss.TOR) as TOR,  
Max(ClaAss.Currency_OC) as Currency_OC,   
sum(case when ClaAss.code='A' then Amount else 0 end) AS Claim,   
sum(case when ClaAss.code='E' then Amount else 0 end) AS Deductible,   
sum(case when ClaAss.code='L' then Amount else 0 end) AS Cost,   
sum(case when ClaAss.code='S' then Amount else 0 end) AS Salvage,   
sum(case when ClaAss.code='R' then Amount else 0 end) AS Subrogation,   
sum(case when ClaAss.code='P' then Amount else 0 end) AS Premium,   
sum(case when ClaAss.code='I' then Amount else 0 end) AS Adjustment,   
cast(Max(cast(ClaAss.CashLossF as int)) as Bit) as CashLossF,  
cast(Max(cast(ClaAss.Posted as int)) as Bit) as Posted  
FROM  ClaAss  
Inner Join Profile on (Profile.ID=ClaAss.ID)  
WHERE  ClaAss.CNO=@P_CNO   
And ClaAss.RefNo=@P_RefNo   
and ClaAss.Type=@P_Type   
and ClaAss.ID=@P_ID   
and ClaAss.Currency=@P_CCY   
GROUP BY CLAASS.CNO, CLAASS.ID, CLAASS.TOC, CLAASS.Type, CLAASS.Currency, CLAASS.RefNo  
   
GO



insert into PatchVersioning
select '916 Update Script - Patch 2024 (2)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='916 Update Script - Patch 2024 (2)'


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

