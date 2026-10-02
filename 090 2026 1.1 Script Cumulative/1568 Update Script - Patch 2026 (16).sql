DROP Function get_SchemeRateCode
GO
CREATE Function get_SchemeRateCode(@P_TrNo int, @P_Category varchar(1))          
RETURNS  varchar(10) as
  
BEGIN       
Declare @Coverage_1 as varchar(255)
Declare @ClassNo Int
Declare @Code as varchar(10)

Select @ClassNo=S1.ClassNo, @Coverage_1=S.Coverage_1
from Scheme_Transaction S
Cross Apply 
	(
		Select Top 1 ClassNo 
		from Scheme_Class S1 
		Where S1.SchemeNo=S.SchemeNo 
		and 
		(
			(case when S1.ValueID1='' Then S.ValueID1 else S1.ValueID1 end)=S.ValueID1 and
			(case when S1.ValueID2='' Then S.ValueID2 else S1.ValueID2 end)=S.ValueID2 and
			(case when S1.ValueID3='' Then S.ValueID3 else S1.ValueID3 end)=S.ValueID3 and
			(case when S1.ValueID4='' Then S.ValueID4 else S1.ValueID4 end)=S.ValueID4 and
			(case when S1.ValueID5='' Then S.ValueID5 else S1.ValueID5 end)=S.ValueID5 and
			(case when S1.ValueID6='' Then S.ValueID6 else S1.ValueID6 end)=S.ValueID6 and
			(case when S1.ValueID7='' Then S.ValueID7 else S1.ValueID7 end)=S.ValueID7 and
			(case when S1.ValueID8='' Then S.ValueID8 else S1.ValueID8 end)=S.ValueID8 and
			(case when S1.ValueID9='' Then S.ValueID9 else S1.ValueID9 end)=S.ValueID9 and
			(case when S1.ValueID10='' Then S.ValueID10 else S1.ValueID10 end)=S.ValueID10 and
			(case when S1.ValueID11='' Then S.ValueID11 else S1.ValueID11 end)=S.ValueID11 and
			(case when S1.ValueID12='' Then S.ValueID12 else S1.ValueID12 end)=S.ValueID12 and
			(case when S1.ValueID13='' Then S.ValueID13 else S1.ValueID13 end)=S.ValueID13 and
			(case when S1.ValueID14='' Then S.ValueID14 else S1.ValueID14 end)=S.ValueID14 and
			(case when S1.ValueID15='' Then S.ValueID15 else S1.ValueID15 end)=S.ValueID15 
		)	
	) S1
Where S.TrNo=@P_TrNo

Select 
@Code=S2.Code
from Scheme_Class S1
Inner Join Scheme_Coverage S2 on (S2.ClassNo=S1.ClassNo and S2.Coverage=@Coverage_1 and S2.Category=@P_Category)
Where S1.ClassNo=@ClassNo

return @Code
End

GO



insert into PatchVersioning
select '1568 Update Script - Patch 2026 (16).sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1568 Update Script - Patch 2026 (16).sql'


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

GO 



