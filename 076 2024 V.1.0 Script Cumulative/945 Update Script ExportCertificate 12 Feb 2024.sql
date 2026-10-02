IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'ExportCertificate') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE ExportCertificate 
end
GO
CREATE PROCEDURE ExportCertificate (@p_ANO as integer)    
AS 
Declare @icoverDet Table(RowNo int, INO	int,
DPERIOD	smallint,
ORDERNO	int,
DESCRIPTION	varchar(255),
QTY	float,
UNIT	varchar(10),
UVALUE	float,
AMOUNT	float,
ANO	int,
MEMO	varchar(Max))

Declare @RefundPremi Table(ANO	int, AMOUNT	float)

insert into @icoverDet
select row_number() OVER(PARTITION BY ANO ORDER BY OrderNo) as RowNo,
icoverDet.* from icoverdet where ano in (select ano from acceptance where lano = @P_ANO)


insert into @RefundPremi
select ANo, sum(Amount) Amount from Accass AC 
where ano in (select ano from acceptance where lano = @P_ANO)
and ac.code='P'
GROUP BY ANO

select Acceptance.CertificateNo, Acceptance.ESeqNo,Acceptance.AName, Acceptance.REGNO, Acceptance.REFNO,Acceptance.ADATE, Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare
, QPCalc.Gross, AC.amount as Refund
, AInfo.Valueid1, AInfo.ValueDesc1, AInfo.Valueid2, AInfo.ValueDesc2, AInfo.Valueid3, AInfo.ValueDesc3, AInfo.Valueid4, AInfo.ValueDesc4, AInfo.Valueid5, AInfo.ValueDesc5, AInfo.Valueid6, AInfo.ValueDesc6, AInfo.Valueid7, AInfo.ValueDesc7, AInfo.Valueid8, AInfo.ValueDesc8, AInfo.Valueid9, AInfo.ValueDesc9, AInfo.Valueid10, AInfo.ValueDesc10, AInfo.Valueid11, AInfo.ValueDesc11, AInfo.Valueid12, AInfo.ValueDesc12, AInfo.Valueid13, AInfo.ValueDesc13, AInfo.Valueid14, AInfo.ValueDesc14, AInfo.Valueid15, AInfo.ValueDesc15,icoverdet.* 
from @RefundPremi AC, Acceptance 
Left Join Rarrheader on (RArrHeader.ANO=Acceptance.ANO) 
Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C')
left join (
select i.ANO,TOI,coalesce(id0.description,'') as description_1,coalesce(id0.qty,'') as quantity_1,coalesce(id0.unit,'') as unit_1,coalesce(id0.uvalue,'') unit_value_1,coalesce(id0.amount,'') as amount_1,coalesce(id1.description,'') as description_2,coalesce(id1.qty,'') as quantity_2,coalesce(id1.unit,'') as unit_2,coalesce(id1.uvalue,'') unit_value_2,coalesce(id1.amount,'') as amount_2, coalesce(id2.description,'') as description_3,coalesce(id2.qty,'') as quantity_3,coalesce(id2.unit,'') as unit_3,coalesce(id2.uvalue,'') unit_value_3,coalesce(id2.amount,'') as amount_3, coalesce(id3.description,'') as description_4,coalesce(id3.qty,'') as quantity_4,coalesce(id3.unit,'') as unit_4,coalesce(id3.uvalue,'') unit_value_4,coalesce(id3.amount,'') as amount_4, 
coalesce(id4.description,'') as description_5,coalesce(id4.qty,'') as quantity_5,coalesce(id4.unit,'') as unit_5,coalesce(id4.uvalue,'') unit_value_5,coalesce(id4.amount,'') as amount_5, coalesce(id5.description,'') as description_6,coalesce(id5.qty,'') as quantity_6,coalesce(id5.unit,'') as unit_6,coalesce(id5.uvalue,'') unit_value_6,coalesce(id5.amount,'') as amount_6, coalesce(id6.description,'') as description_7,coalesce(id6.qty,'') as quantity_7,coalesce(id6.unit,'') as unit_7,coalesce(id6.uvalue,'') unit_value_7,coalesce(id6.amount,'') as amount_7, coalesce(id7.description,'') as description_8,coalesce(id7.qty,'') as quantity_8,coalesce(id7.unit,'') as unit_8,coalesce(id7.uvalue,'') unit_value_8,coalesce(id7.amount,'') as amount_8, coalesce(id8.description,'') as description_9,coalesce(id8.qty,'') as quantity_9,coalesce(id8.unit,'') as unit_9,coalesce(id8.uvalue,'') unit_value_9,coalesce(id8.amount,'') as amount_9,
coalesce(id9.description,'') as description_10,coalesce(id9.qty,'') as quantity_10,coalesce(id9.unit,'') as unit_10,coalesce(id9.uvalue,'') unit_value_10,coalesce(id9.amount,'') as amount_10  from icover i inner join @icoverDet id0 on i.ino = id0.ino and id0.RowNo=1 
left join @icoverDet id1 on i.ino = id1.ino and id1.RowNo=2 left join @icoverDet id2 on i.ino = id2.ino and id2.RowNo=3 left join @icoverDet id3 on i.ino = id3.ino and id3.RowNo=4 left join @icoverDet id4 on i.ino = id4.ino and id4.RowNo=5  left join @icoverDet id5 on i.ino = id5.ino and id5.RowNo=6 
left join @icoverDet id6 on i.ino = id6.ino and id6.RowNo=7 left join @icoverDet id7 on i.ino = id7.ino and id7.RowNo=7 left join @icoverDet id8 on i.ino = id8.ino and id8.RowNo=8 left join @icoverDet id9 on i.ino = id9.ino and id9.RowNo=10 
)icoverDet on icoverDet.ano = Acceptance.ANO, SysTab, Acceptance MAcceptance , AInfo 
where Acceptance.ANO = Ainfo.ANO 
and Acceptance.ANO = AC.ANO 
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) and MAcceptance.ANO=@p_ANO
  order by Acceptance.CERTIFICATENO
  go


  --ExportCertificate  13853617

go




insert into PatchVersioning
select '945 Update Script ExportCertificate 12 Feb 2024',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='945 Update Script ExportCertificate 12 Feb 2024'


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
