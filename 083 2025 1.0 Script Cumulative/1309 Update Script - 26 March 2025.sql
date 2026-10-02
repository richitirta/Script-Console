
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CLCOSTDET') AND type in (N'U'))
BEGIN

SET ANSI_NULLS ON
 

SET QUOTED_IDENTIFIER ON
 

CREATE TABLE [dbo].[CLCOSTDET](
	[CNO] [int] NOT NULL,
	[ID] [varchar](10) NOT NULL,
	[Currency] [varchar](5) NOT NULL,
	[RefNo] [varchar](20) NOT NULL,
	[CCTYPE] [varchar](10) NOT NULL,
	[Item] [varchar](50) NOT NULL,
	[Description] [varchar](255) NULL,
	[TotalAmount] [float] NULL,
	[GrossAmount] [float] NULL,
	[VAT] [float] NULL,
	[Amount] [float] NULL,
	[EstAmount] [float] NULL,
	[TAX] [float] NULL,
	[NetAmount] [float] NULL,
 CONSTRAINT [I_CLCOSTDET] PRIMARY KEY NONCLUSTERED 
(
	[CNO] ASC,
	[ID] ASC,
	[Currency] ASC,
	[RefNo] ASC,
	[CCTYPE] ASC,
	[Item] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[CLCOSTDET]  WITH NOCHECK ADD  CONSTRAINT [FK_CLCOSTDET_CLCOST] FOREIGN KEY(CNO, ID, Currency, RefNo, CCTYPE)
REFERENCES [dbo].[CLCOST] (CNO, ID, Currency, RefNo, CCTYPE)
ON UPDATE CASCADE
ON DELETE CASCADE


ALTER TABLE [dbo].[CLCOSTDET] CHECK CONSTRAINT [FK_CLCOSTDET_CLCOST]



EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Claim No (see Claim)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLCOSTDET', @level2type=N'COLUMN',@level2name=N'CNO'
 
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Profile ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLCOSTDET', @level2type=N'COLUMN',@level2name=N'ID'
 
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Reference No.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLCOSTDET', @level2type=N'COLUMN',@level2name=N'RefNo'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Claim Cost (Expense) Type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLCOSTDET', @level2type=N'COLUMN',@level2name=N'CCTYPE'
 
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Item Salvage' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLCOSTDET', @level2type=N'COLUMN',@level2name=N'Item'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Item Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLCOSTDET', @level2type=N'COLUMN',@level2name=N'Description'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Total  Amount (Before VAT & TAX)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLCOSTDET', @level2type=N'COLUMN',@level2name=N'TotalAmount'
 
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gross Taxable Amount (Before VAT & TAX)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLCOSTDET', @level2type=N'COLUMN',@level2name=N'GrossAmount'
 
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'VAT Amount' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLCOSTDET', @level2type=N'COLUMN',@level2name=N'VAT'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Amount (After VAT)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLCOSTDET', @level2type=N'COLUMN',@level2name=N'Amount'
 

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Estimate Expense Amount' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLCOSTDET', @level2type=N'COLUMN',@level2name=N'EstAmount'
 
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'TAX AMOUNT' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLCOSTDET', @level2type=N'COLUMN',@level2name=N'TAX'
 
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Net Amount (After TAX)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CLCOSTDET', @level2type=N'COLUMN',@level2name=N'NetAmount'


end
go


  insert into PatchVersioning
select '1309 Update Script - 26 March 2025',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1309 Update Script - 26 March 2025'


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




