IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ApplyTOCF' AND Object_ID = Object_ID(N'FDTAB'))
BEGIN
ALTER TABLE dbo.FDTAB ADD
	ApplyTOCF bit NULL
DECLARE @v sql_variant 
SET @v = N'Apply Fee Duty by Sub Class Of Business (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'FDTAB', N'COLUMN', N'ApplyTOCF'
end
GO



IF Not EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FDTABTOC') AND type in (N'U'))
begin
CREATE TABLE [dbo].[FDTABTOC](
	[FDID] [varchar](10) NOT NULL,
	[TOC] [varchar](10) NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[FDTABTOC]  WITH NOCHECK ADD  CONSTRAINT [FK_FDTABTOC_FDTAB] FOREIGN KEY([FDID])
REFERENCES [dbo].[FDTAB] ([FDID])
ON UPDATE CASCADE
ON DELETE CASCADE

ALTER TABLE [dbo].[FDTABTOC] CHECK CONSTRAINT [FK_FDTABTOC_FDTAB]

Create Unique Index I_FDTABTOC on FDTABTOC(FDID, TOC)

end
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_FDTAB') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function FN_FDTAB
end
GO
Create Function FN_FDTAB(@P_ANO as integer)
RETURNS Table 
AS RETURN ( 

Select FDTAB.*
from FDTAB
Inner Join SysTab on (1=1)
Inner Join Currency on (Currency.Currency=FDTab.Currency and Currency.AllowedF=1)
Left Join (Select ANO, TOC from Acceptance Where ANO=@P_ANO) TOC on (TOC.ANO=@P_ANO)
Left Join FDTABTOC on (FDTABTOC.FDID=FDTAB.FDID and FDTABTOC.TOC=TOC.TOC)
Left Join (Select Distinct ANO, Currency from ICover Where ANO=@P_ANO) ICover on (ICover.ANO=@P_ANO)
Where  (Currency.Currency=SysTab.Currency or Currency.Currency=ICover.Currency)
and (FDTAB.ApplyTOCF=0 or coalesce(FDTABTOC.TOC,'')<>'')
) 


GO

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWCHANGESTAMPDUTYF')
BEGIN
Insert into sysform(FName, Description, FCode, RequestF)
Select 'ALLOWCHANGESTAMPDUTYF', 'Allow Change Stamp Duty', 'ACTIVITIES',0
end
go



 insert into PatchVersioning
select '194 Update Script - 22 March 2022 (1)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='194 Update Script - 22 March 2022 (1)'


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