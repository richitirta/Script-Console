drop Procedure SP_Search_SysUserTypeTOCTOL

go

create Procedure SP_Search_SysUserTypeTOCTOL(@BTYPE varchar(10), @Effective smalldatetime,@TOC varchar(10),@TYPE varchar(20))        

as        

Select  CAST(0 As Bit) ProcessFlag,R. *, 

F.FLDTAG1,F.FLDCRITERIA1,F.FLDTAG2,F.FLDCRITERIA2,F.FLDTAG3,F.FLDCRITERIA3,F.FLDTAG4,F.FLDCRITERIA4,F.FLDTAG5,F.FLDCRITERIA5,F.FLDTAG6,F.FLDCRITERIA6,F.FLDTAG7,

F.FLDCRITERIA7,F.FLDTAG8,F.FLDCRITERIA8,F.FLDTAG9,F.FLDCRITERIA9,F.FLDTAG10,F.FLDCRITERIA10,F.FLDTAG11,F.FLDCRITERIA11,F.FLDTAG12,F.FLDCRITERIA12,F.FLDTAG13,

F.FLDCRITERIA13,F.FLDTAG14,F.FLDCRITERIA14,F.FLDTAG15,F.FLDCRITERIA15

from SysUserTypeTOCTOL R, FNtoc_genHtab(@TOC) F

Where R.TOC=F.TOC And (R.BTYPE like @BTYPE + '%') And (R.TOC like @TOC + '%' ) And (R.TYPE like @TYPE + '%' ) And (R.Effective=@Effective) 

go



 insert into PatchVersioning	
select '538 SP_Search_SysUserTypeTOCTOL',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='538 SP_Search_SysUserTypeTOCTOL'


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




