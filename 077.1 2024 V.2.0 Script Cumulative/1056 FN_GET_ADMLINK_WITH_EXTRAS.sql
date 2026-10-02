DROP FUNCTION FN_GET_ADMLINK_WITH_EXTRAS
GO
CREATE FUNCTION FN_GET_ADMLINK_WITH_EXTRAS(@Voucher varchar(30), @Extras varchar(255))
RETURNS TABLE            
AS RETURN(  
       Select
       Top 1 
       A1.Voucher,
       A1.ID,
       A1.Currency,
       A1.DocNo,
       A1.RefNo,
       A1.A_PolicyNo,
       A1.A_RefNo,
       A1.Subject,
       A1.Type,
       A1.Date,
       A1.Source,
       A1.ASource,
       A1.ValueDesc,
       A1.Remarks,
       A1.Insured,
       A1.Amount, 
       A1.Amount_6, 
       A1.Amount_7, 
       A1.Amount_8, 
       A1.Amount_12, 
       A1.Amount_19,
       A1.Extra_1,
       A1.Extra_2,
       A1.Extra_3,
       A1.Extra_4,
       A1.Extra_5,
       A1.Extra_6,
       A1.Extra_7,
       A1.Extra_8,
       A1.Extra_9,
       A1.Extra_10,
	   A1.BATCHNO,
       case 
       When @Extras='' then @Extras
       when A1.Extra_1 like '%'+@Extras+'%' then A1.Extra_1
       when A1.Extra_2 like '%'+@Extras+'%' then A1.Extra_2
       when A1.Extra_3 like '%'+@Extras+'%' then A1.Extra_3
       when A1.Extra_4 like '%'+@Extras+'%' then A1.Extra_4
       when A1.Extra_5 like '%'+@Extras+'%' then A1.Extra_5
       when A1.Extra_6 like '%'+@Extras+'%' then A1.Extra_6
       when A1.Extra_7 like '%'+@Extras+'%' then A1.Extra_7
       when A1.Extra_8 like '%'+@Extras+'%' then A1.Extra_8
       when A1.Extra_9 like '%'+@Extras+'%' then A1.Extra_9
       when A1.Extra_10 like '%'+@Extras+'%' then A1.Extra_10
       else ''
       end as Extras
       from Admlink A1
       Where A1.Voucher=@Voucher
)
GO



insert into PatchVersioning
select '1056 FN_GET_ADMLINK_WITH_EXTRAS',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1056 FN_GET_ADMLINK_WITH_EXTRAS'


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