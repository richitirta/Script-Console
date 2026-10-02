IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLVIEW08') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE CLVIEW08 
END
GO
CREATE PROCEDURE CLVIEW08 (@P_CNO AS INTEGER)   
AS  
SELECT Cast(0 as bit) as ProcessFlag, CLAREGDET.RTYPE, EVENT.EVENTNO, CLAREGDET.RYEAR, EVENT.EVENTNAME, CLAREGDET.AMOUNT, CLAREGDET.TCLAIM,CLAREGDET.EAMOUNT, CLAREGDET.ETCLAIM  
FROM CLAIM C1, CARRHEADER C2, REINSURANCE R, CLAREGDET, EVENT
WHERE C1.CNO=@P_CNO And C2.CNO=C1.CNO
and R.RID=
(
Case 
When C2.XL1ID<>'' Then C2.XL1ID
When C2.XL2ID<>'' Then C2.XL2ID
When C2.XL3ID<>'' Then C2.XL3ID
When C2.XL4ID<>'' Then C2.XL4ID
When C2.XL5ID<>'' Then C2.XL5ID
When C2.XL6ID<>'' Then C2.XL6ID
When C2.XL7ID<>'' Then C2.XL7ID
Else ''
end)
And CLAREGDET.EVENTNO=C1.EVENTNO And CLAREGDET.RYEAR=R.RYEAR
And Event.EventNo=C1.EventNo

GO

insert into PatchVersioning
select '55.34 Update Script - Patch 2020 (34)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='55.33 Update Script - Patch 2020 (33)'
Select @CurrSCript='55.34 Update Script - Patch 2020 (34)'


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



