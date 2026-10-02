
--AutoNum untuk GDV-nya di cleansing saja; berikut script-nya

Begin tran

DECLARE @PFORMAT2 VARCHAR(10)
SELECT @PFORMAT2=PFormat2  
FROM AutoNum WHERE AUTONUM='GDV'

IF @PFORMAT2='00000'
BEGIN
SELECT * INTO TEMP_SEQNO20220325 from SeqNo Where AutoNum='GDV'
Delete from SeqNo Where AutoNum='GDV'
Insert into SeqNo(LDocNo, RDocNo, SeqNo, AutoNum)
Select LDocNo, '' as RDocNo, round(Max(SeqNo),0) as SeqNo, 'GDV' as AutoNum
from 
(
       Select ValueID, Left(ValueID,10) as LDocNo, substring(valueID,11,len(ValueID)) as SeqNo 
       from GendTab
) G
Where ISNUMERIC(SeqNo)=1
Group By LDocNo
Having round(Max(SeqNo),0)>0
END


--rollback
commit
GO




 insert into PatchVersioning
select '197 Script Cleansing GDV',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='197 Script Cleansing GDV'


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