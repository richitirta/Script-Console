IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'COLLATERALSUBTYPE') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[COLLATERALSUBTYPE](
	[COLLATERALSUBTYPE] [varchar](10) NOT NULL,
	[COLLATERALTYPE] [varchar](10) NOT NULL,
	[Description] [varchar](255) NULL,
	[AllowedF] [bit] NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
 CONSTRAINT [I_COLLATERALSUBTYPE] PRIMARY KEY CLUSTERED 
(
	[COLLATERALSUBTYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
end

SET ANSI_PADDING OFF

ALTER TABLE [dbo].[COLLATERALSUBTYPE]  WITH CHECK ADD  CONSTRAINT [FK_COLLATERALSUBTYPE_COLLATERALTYPE1] FOREIGN KEY([COLLATERALTYPE])
REFERENCES [dbo].[COLLATERALTYPE] ([COLLATERALTYPE])

ALTER TABLE [dbo].[COLLATERALSUBTYPE] CHECK CONSTRAINT [FK_COLLATERALSUBTYPE_COLLATERALTYPE1]

SET ANSI_PADDING OFF

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection Sub Type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COLLATERALSUBTYPE', @level2type=N'COLUMN',@level2name=N'COLLATERALSUBTYPE'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection Type (see CollateralType)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COLLATERALSUBTYPE', @level2type=N'COLUMN',@level2name=N'COLLATERALTYPE'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection Sub Type Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COLLATERALSUBTYPE', @level2type=N'COLUMN',@level2name=N'Description'

GO





IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'COLLATERALSUBTYPE' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
BEGIN
ALTER TABLE dbo.ACCCOLLATERAL ADD
	COLLATERALSUBTYPE varchar(10) NULL

DECLARE @v sql_variant 
SET @v = N'Collateral Type (see CollateralType)'
EXECUTE sp_updateextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCCOLLATERAL', N'COLUMN', N'COLLATERALTYPE'

DECLARE @x sql_variant 
SET @x = N'Collateral Sub Type'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCCOLLATERAL', N'COLUMN', N'COLLATERALSUBTYPE'

end
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QACCCOLLATERALLIST') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QACCCOLLATERALLIST
end
GO
CREATE PROCEDURE QACCCOLLATERALLIST(@P_OANO as Integer)    
AS    
SELECT cast(0 as Bit) as ProcessFlag, A.COLLATERALNO, A.COLLATERALTYPE, A.COLLATERALSUBTYPE, A.DOCNO, A.DESCRIPTION, A.CURRENCY, A.NOMINAL, A.REMARKS, C2.AMOUNT AS RECOVERED, C.CashDepositF
FROM ACCCOLLATERAL A   
LEFT JOIN COLLATERALTYPE C on (C.COLLATERALTYPE=A.COLLATERALTYPE)
LEFT JOIN (
	SELECT A1.OANO, C1.ITEM, C3.CURRENCY, sum(C1.AMOUNT) AS AMOUNT 
	FROM CLSUBDET C1, CLAIM C2, CLSUB C3, ACCEPTANCE A1 
	WHERE A1.ANO=C2.ANO AND C1.CNO=C2.CNO AND C3.CNO=C1.CNO AND C3.ID=C1.ID AND C3.CURRENCY=C1.CURRENCY AND C3.REFNO=C1.REFNO
	AND C2.CType<>'C' AND (C2.CStatus<>'C' or C2.PCStatus='A') and not exists (Select pCNO from Claim Where Claim.pCNO=C2.CNO and Claim.CStatus<>'R') 
	AND C3.STATUS='P' AND A1.OANO=@P_OANO
	GROUP BY A1.OANO, C1.ITEM, C3.CURRENCY
	) C2  ON (A.ANO=C2.OANO AND A.COLLATERALNO=C2.ITEM AND A.CURRENCY=C2.CURRENCY)    
WHERE A.ANO=@P_OANO 

go




 insert into PatchVersioning	
select '606 Update Script - 4 April 2023',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='606 Update Script - 4 April 2023'


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
