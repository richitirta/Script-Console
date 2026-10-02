IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LocalCountryF' AND Object_ID = Object_ID(N'Country'))
BEGIN
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.Country ADD
	LocalCountryF bit NULL

DECLARE @v sql_variant 
SET @v = N'Flag as Local Country (1 : Local Country, 0 : Foreign Country)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Country', N'COLUMN', N'LocalCountryF'
end
GO
Update Country Set LocalCountryF=0 Where LocalCountryF is null
--specific Country setting
Update Country Set LocalCountryF=1 Where Country='INA'
GO

DROP Procedure QACCBS 
GO
CREATE Procedure QACCBS (@P_ANO integer) 
as 
SELECT 
A.BSID	,
A.ID	,
A.BSType	,
A.FEE	,
A.FeeAmount	,
A.Discount	,
A.UpFeeAmount	,
A.UpFee	,
A.CommPoolF	,
A.BSType	,
A.NoRefundF	,
A.NoProrataF	,
A.NotMinimumPremiumF	,
A.NetF	,
A.NetGroupF	,
A.GrossF	,
A.GrossBLF	,
A.CommAfterMinPremiumF	,
A.NetUpF	,
A.GrossUpF	,
A.MemberF	,
A.MemberFeeF,
coalesce(C.LocalCountryF, Case When coalesce(P.COUNTRY,'INA') in ('','INA') Then cast(1 as bit) Else cast(0 as bit) End) as LocalCountryF
FROM ACCBS A
Inner Join Profile P on (P.ID=A.ID)
Left Join Country C on (C.Country=P.Country)
WHERE A.ANO=@P_ANO 
ORDER BY A.GROSSUPF DESC, A.NETUPF DESC 

GO

DROP Procedure QAACCBS 
GO
CREATE Procedure QAACCBS (@P_ANO integer) 
as 
SELECT 
A.BSID	,
A.ID	,
A.BSType	,
A.FEE	,
A.FeeAmount	,
A.Discount	,
A.UpFeeAmount	,
A.UpFee	,
A.CommPoolF	,
A.BSType	,
A.NoRefundF	,
A.NoProrataF	,
A.NotMinimumPremiumF	,
A.NetF	,
A.NetGroupF	,
A.GrossF	,
A.GrossBLF	,
A.CommAfterMinPremiumF	,
A.NetUpF	,
A.GrossUpF	,
A.MemberF	,
A.MemberFeeF,
coalesce(C.LocalCountryF, Case When coalesce(P.COUNTRY,'INA') in ('','INA') Then cast(1 as bit) Else cast(0 as bit) End) as LocalCountryF
FROM AACCBS A
Inner Join Profile P on (P.ID=A.ID)
Left Join Country C on (C.Country=P.Country)
WHERE A.ANO=@P_ANO 
ORDER BY A.GROSSUPF DESC, A.NETUPF DESC 

go


 insert into PatchVersioning
select '1227 Update Script - 4 October 2024',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1227 Update Script - 4 October 2024'


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