
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_GET_ADMLINK_WITH_EXTRAS') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION FN_GET_ADMLINK_WITH_EXTRAS
end
GO
CREATE FUNCTION FN_GET_ADMLINK_WITH_EXTRAS(@Voucher varchar(30), @Extras varchar(255))
RETURNS TABLE            
AS RETURN(  
	Select
	Top 1 
	Voucher,
	ID,
	Currency,
	DocNo,
	RefNo,
	A_POLICYNO,
	A_RefNo,
	Subject,
	Type,
	Date,
	Source,
	ASource,
	ValueDesc,
	Remarks,
	Insured,
	Amount, 
	Amount_6, 
	Amount_7, 
	Amount_8, 
	Amount_12, 
	Amount_19,
	Extra_1,
	Extra_2,
	Extra_3,
	Extra_4,
	Extra_5,
	Extra_6,
	Extra_7,
	Extra_8,
	Extra_9,
	Extra_10,
	case 
	When @Extras='' then @Extras
	when A2.Extra_1 like '%'+@Extras+'%' then A2.Extra_1
	when A2.Extra_2 like '%'+@Extras+'%' then A2.Extra_2
	when A2.Extra_3 like '%'+@Extras+'%' then A2.Extra_3
	when A2.Extra_4 like '%'+@Extras+'%' then A2.Extra_4
	when A2.Extra_5 like '%'+@Extras+'%' then A2.Extra_5
	when A2.Extra_6 like '%'+@Extras+'%' then A2.Extra_6
	when A2.Extra_7 like '%'+@Extras+'%' then A2.Extra_7
	when A2.Extra_8 like '%'+@Extras+'%' then A2.Extra_8
	when A2.Extra_9 like '%'+@Extras+'%' then A2.Extra_9
	when A2.Extra_10 like '%'+@Extras+'%' then A2.Extra_10
	else ''
	end as Extras
	from Admlink A2
	Where A2.Voucher=@Voucher
)


GO


insert into PatchVersioning
select '913 Update Script - 28 Desember 2023',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='913 Update Script - 28 Desember 2023'


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





