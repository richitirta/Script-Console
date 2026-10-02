IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'GetFindListInterest_LT') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure GetFindListInterest_LT
end
go
Create Procedure GetFindListInterest_LT(@ANO Int, @SRecNo Int, @ERecNo Int, @Remark varchar(2048))
as

Declare @MaxRecNo as Int

Select @MaxRecNo=count(*) from ICover Where ANO=@ANO

Declare @ICover table(INO Int, RecNo Int, Primary Key (INO))

insert into @ICover
Select INO, count(INO) Over (Order by INO) as RecNo
From ICover I1
Where I1.ANO =  @ANO
Order by I1.INO

Select Cast(0 as bit) as ProcessFlag, I1.*,
@MaxRecNo AS MaxRecNo
From @ICover I
Inner Join ICover I1 on (I1.INO=I.INO)
Where I.RecNo between @SRecNo and @ERecNo
and (TOI like '%'+ @Remark+'%' or Remark Like '%'+ @Remark+'%' or Refno Like '%'+ @Remark+'%' or Docno Like '%'+ @Remark+'%')
Order by I.INO

go


insert into PatchVersioning
select '1154 Update Script GetFindListInterest_LT',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1154 Update Script GetFindListInterest_LT'


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
