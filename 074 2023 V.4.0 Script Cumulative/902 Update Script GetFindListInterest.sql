IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'GetFindListInterest') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN 
DROP Procedure GetFindListInterest
END
GO
Create Procedure GetFindListInterest(@ANO Int, @SRecNo Int, @ERecNo Int, @Remark varchar(2048))
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
I2.VALUEID1 AS OBJ_INFO_01,
I2.VALUEDESC1 AS DESCRIPTION1,
I2.VALUEID2 AS OBJ_INFO_02,
I2.VALUEDESC2 AS DESCRIPTION2,
I2.VALUEID3 AS OBJ_INFO_03,
I2.VALUEDESC3 AS DESCRIPTION3,
I2.VALUEID4 AS OBJ_INFO_04,
I2.VALUEDESC4 AS DESCRIPTION4,
I2.VALUEID5 AS OBJ_INFO_05,
I2.VALUEDESC5 AS DESCRIPTION5,
I2.VALUEID6 AS OBJ_INFO_06,
I2.VALUEDESC6 AS DESCRIPTION6,
I2.VALUEID7 AS OBJ_INFO_07,
I2.VALUEDESC7 AS DESCRIPTION7,
I2.VALUEID8 AS OBJ_INFO_08,
I2.VALUEDESC8 AS DESCRIPTION8,
I2.VALUEID9 AS OBJ_INFO_09,
I2.VALUEDESC9 AS DESCRIPTION9,
I2.VALUEID10 AS OBJ_INFO_10,
I2.VALUEDESC10 AS DESCRIPTION10,
I2.VALUEID11 AS OBJ_INFO_11,
I2.VALUEDESC11 AS DESCRIPTION11,
I2.VALUEID12 AS OBJ_INFO_12,
I2.VALUEDESC12 AS DESCRIPTION12,
I2.VALUEID13 AS OBJ_INFO_13,
I2.VALUEDESC13 AS DESCRIPTION13,
I2.VALUEID14 AS OBJ_INFO_14,
I2.VALUEDESC14 AS DESCRIPTION14,
I2.VALUEID15 AS OBJ_INFO_15,
I2.VALUEDESC15 AS DESCRIPTION15,
@MaxRecNo AS MaxRecNo
From @ICover I
Inner Join ICover I1 on (I1.INO=I.INO)
Left Join IInfo I2 on (I2.INO=I.INO)
Where I.RecNo between @SRecNo and @ERecNo
and (TOI like '%'+ @Remark+'%' or Remark Like '%'+ @Remark+'%' or Refno Like '%'+ @Remark+'%' or Docno Like '%'+ @Remark+'%')
Order by I.INO

GO


 insert into PatchVersioning
select '902 Update Script GetFindListInterest',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='902 Update Script GetFindListInterest'


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

