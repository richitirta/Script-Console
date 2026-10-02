DROP Procedure BALANCE_ACCASS_ADJUSTMENT
GO
CREATE Procedure BALANCE_ACCASS_ADJUSTMENT(@P_ANO integer)     
as     

Declare @OANO as Int
Declare @PANO as int
Declare @PLANO as int
Declare @PDate as smalldatetime
Declare @PPDate as smalldatetime
Declare @CPDate as smalldatetime
Declare @CANO as Int
Declare @ManualF as bit
Declare @AType varchar(1)
Declare @EMethod varchar(1)

Select Top 1 @OANO=A1.OANO, @AType=A1.AType, @EMethod=A1.EMethod, @PANO=A1.PANO, @PLANO=pA1.LANO, @PDate=A1.PDate, @PPDate=A1.PPDate, @CPDate=A2.PDate, @CANO=coalesce(A2.ANO,0), @ManualF=coalesce(R.ManualF,0)
from Acceptance A1
Inner join Acceptance pA1 on (pA1.ANO=A1.pANO)
Left Join RArrHeader R on (R.ANO=A1.ANO)
Left Join Acceptance A2 on (A2.OANO=A1.OANO and A2.Atype='C' and A2.EMethod='A' and A2.ANO<@P_ANO)
Where A1.ANO=@P_ANO
Order By A1.OANO, A2.ANO Desc

Select 
Case 
When coalesce(A5.UseCurrTypeF, coalesce(A4.UseCurrTypeF, coalesce(A6.UseCurrTypeF, Cast(0 as Bit))))=1 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') then
	'B'+coalesce(A5.BSType, coalesce(A4.BSType, coalesce(A6.BSType,'')))
else
	AccAss.Type
end Type
, AccAss.ID, AccAss.Code, AccAss.CAmount, AccAss.Currency_OC, AccAss.Amount_OC, AccAss.Amount, AccAss.Rate, AccAss.Currency
, AccAss.RefNo, AccAss.TOC, AccAss.PolicyNo, AccAss.Remarks, AccAss.Prorata, AccAss.SDate, AccAss.EDate, AccAss.PProrata, AccAss.DocNo
, AccAss.AdjustableF, AccAss.AdjMethod, AccAss.RCode, AccAss.NoRefundF, AccAss.BizMapID, AccAss.Source, AccAss.MSCode, AccAss.CommPoolF, AccAss.DepositF, AccAss.CodeExt
, @ManualF as ManualF
From Acceptance A2 
inner join AccAss on (AccAss.ANO=A2.ANO)     
Left join Acceptance pA2  on (pA2.ANO=A2.pANO)     
Left Join ACCBS A4 on (A4.ANO=@PANO and A4.ID=AccAss.ID and A4.OBSType=substring(AccAss.Type,2,1))        
Left Join AAccBS A5 on (A5.ANO=@PANO and A5.ID=AccAss.ID and A5.OBSType=substring(AccAss.Type,2,1))       
Left Join ACCBS A6 on (A6.ANO=@PLANO and A6.ID=AccAss.ID and A6.OBSType=substring(AccAss.Type,2,1))       
Where A2.OANO=@OANO and A2.ANO<@P_ANO
and   
( 
 (
 @AType='A' and
 (    
	 (  
	 pA2.ANO=@PANO and @PDate<=pA2.PDate and @PPDate>=pA2.PPDate and (A2.AType='E' and coalesce(pA2.AType,'') in ('N','E'))   
	 and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT' and AccAss.CAmount=0  
	 and NOT EXISTS (Select Top 1 PANO from Acceptance A3 Where A3.OANO=@OANO and A3.PANO>=pA2.ANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<@P_ANO)  
	 )     
	 or   
	 (  
	 A2.ANO<=@PANO and @PDate<=A2.PDate and @PPDate>=A2.PPDate and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
	 and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT'  
	 and NOT EXISTS (Select Top 1 PANO from Acceptance A3 Where A3.OANO=@OANO and A3.PANO>=A2.ANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<@P_ANO)  
	 )     
	 or   
	 (  
	 A2.ANO<=@PANO and @PDate<=A2.PDate and @PPDate>=A2.PPDate and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
	 and AccAss.AdjustableF=1 and AccAss.AdjMethod='OVERLIMIT' and A2.PDATE<A2.PPDATE and AccAss.CAmount<>0  
	 and NOT EXISTS (Select Top 1 PANO from Acceptance A3 Where A3.OANO=@OANO and A3.PANO=A2.ANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<@P_ANO)  
	 )     
 )
 )
 or    
 (  
 --Cancel All
 @AType='C' and @EMethod='A'and 
 (
	(
	case when A2.ANO<=@CANO and A2.PDate>coalesce(@CPDate,A2.PDate) Then coalesce(@CPDate,A2.PDate) else A2.PDate end>=@PDate and AccAss.CAmount<>0
	) 
	or 
	(
	case when A2.ANO<=@CANO and coalesce(pA2.pDate,A2.PDate)>coalesce(@CPDate,coalesce(pA2.pDate,A2.PDate)) Then coalesce(@CPDate,coalesce(pA2.pDate,A2.PDate)) else coalesce(pA2.pDate,A2.PDate) end>=@PDate and AccAss.CAmount=0
	)
 )
 )  
 or
 (
 --Adjustment Cancel
 @AType='C' and A2.AType='A' and A2.ANO=@PANO
 )
)     

go




 insert into PatchVersioning
select '276 Update Script - Patch 2022 (35)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='276 Update Script - Patch 2022 (35)'


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
