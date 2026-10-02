
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DOCLEVEL' AND Object_ID = Object_ID(N'TERMOFPMTTYPE'))
BEGIN
ALTER TABLE dbo.TERMOFPMTTYPE ADD
	DOCLEVEL int NULL
DECLARE @v sql_variant 
SET @v = N'Document Level/Value '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TERMOFPMTTYPE', N'COLUMN', N'DOCLEVEL'
END
GO



Delete from TERMOFPMTTYPE 

insert into TERMOFPMTTYPE (TERMOFPMTTYPE, DOCLEVEL)
Select *
from
(
Select 'N/A' as Type, 0 as Value
union all
Select 'O/A' as Type,1 as Value
union all
Select 'DA' as Type,2 as Value
union all
Select 'DP' as Type,2 as Value
union all
Select 'LC' as Type,3 as Value
union all
Select 'SKBDN' as Type,3 as Value
union all
Select 'A/P' as Type,4 as Value
) T
GO


 insert into PatchVersioning
select '443 Update Script - 24 October 2022 (1)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='443 Update Script - 24 October 2022 (1)'


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


