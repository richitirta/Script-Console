
alter table vPattern drop  constraint FK_vPattern_vType
GO
alter table mVoucher drop  constraint FK_mVoucher_vType
GO
alter table nVoucher drop  constraint FK_nVoucher_vType
GO
alter table pVoucher drop  constraint FK_pVoucher_vType
GO
alter table Cheque drop  constraint FK_Cheque_vType
GO
alter table AssType drop  constraint FK_AssType_vType
GO
alter table VType drop constraint I_VType
GO
alter table vPattern drop constraint I_vPattern
GO

alter Table VType alter Column VType varchar(20) Not Null

GO

Alter Table vPattern Alter Column vType varchar(20) Not Null
 
GO 

Alter Table SysUserVType Alter Column VType varchar(20)
 GO 

Alter Table RPBucket Alter Column VType varchar(20)
 GO 

Alter Table nVoucher Alter Column vType varchar(20)
 GO 



Alter Table AmorType Alter Column VTRegister varchar(20)
 GO 

Alter Table AmorType Alter Column VTAmortization varchar(20)
 GO 

Alter Table AmorType Alter Column VTDisposal varchar(20)
 GO 

Alter Table AssType Alter Column VType varchar(20)
 GO 

Alter Table AssType Alter Column VTRegister varchar(20)
 GO 

Alter Table AssType Alter Column VTDisposal varchar(20)
 GO 

Alter Table AssType Alter Column VTMovement varchar(20)
 GO 

Alter Table AssType Alter Column VTRevaluation varchar(20)
 GO 

Alter Table mVoucher Alter Column vType varchar(20)
 GO 

Alter Table APBucket Alter Column VType varchar(20)
 GO 

Alter Table Request Alter Column VType varchar(20)
 GO 

Alter Table Cheque Alter Column vType varchar(20)
 GO 

Alter Table pVoucher Alter Column vType varchar(20)
 GO 

Alter Table InvGroup Alter Column VTPlacement varchar(20)
 GO 

Alter Table InvGroup Alter Column VTWithdrawal varchar(20)
 GO 

Alter Table InvGroup Alter Column VTInterest varchar(20)
 GO 

Alter Table InvGroup Alter Column VTAllowance varchar(20)
 GO 

Alter Table InvGroup Alter Column VTDeduction varchar(20)
 GO 

Alter Table InvGroup Alter Column VTSell varchar(20)
 GO 

Alter Table InvGroup Alter Column VTBuy varchar(20)
 GO 

Alter Table InvGroup Alter Column VTAmortization varchar(20)
 GO 

Alter Table PettyCashType Alter Column VType varchar(20)
 GO 

Alter Table COLLTYPE Alter Column Vtype_DR varchar(20)
 GO 

Alter Table COLLTYPE Alter Column Vtype_CR varchar(20)
 GO 


Alter Table VType Add Constraint [I_VType] Primary Key Clustered (
	[vType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]



GO

 Alter Table VPattern Add CONSTRAINT [I_vPattern] PRIMARY KEY CLUSTERED 
(
	[vType] ASC,
	[Account] ASC,
	[Debit] ASC,
	[Credit] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


GO


ALTER TABLE [dbo].[mVoucher]  WITH NOCHECK ADD  CONSTRAINT [FK_mVoucher_vType] FOREIGN KEY(VTYPE)
REFERENCES [dbo].[VTYPE] (VTYPE)
GO

ALTER TABLE [dbo].[mVoucher] CHECK CONSTRAINT [FK_mVoucher_vType]
GO

ALTER TABLE [dbo].[nVoucher]  WITH NOCHECK ADD  CONSTRAINT [FK_nVoucher_vType] FOREIGN KEY(VTYPE)
REFERENCES [dbo].[VTYPE] (VTYPE)
GO

ALTER TABLE [dbo].[nVoucher] CHECK CONSTRAINT [FK_nVoucher_vType]
GO

ALTER TABLE [dbo].[pVoucher]  WITH NOCHECK ADD  CONSTRAINT [FK_pVoucher_vType] FOREIGN KEY(VTYPE)
REFERENCES [dbo].[VTYPE] (VTYPE)
GO

ALTER TABLE [dbo].[pVoucher] CHECK CONSTRAINT [FK_pVoucher_vType]
GO

ALTER TABLE [dbo].[AssType]  WITH NOCHECK ADD  CONSTRAINT [FK_AssType_vType] FOREIGN KEY(VTYPE)
REFERENCES [dbo].[VTYPE] (VTYPE)
GO

ALTER TABLE [dbo].[AssType] CHECK CONSTRAINT [FK_AssType_vType]
GO


ALTER TABLE [dbo].[Cheque]  WITH NOCHECK ADD  CONSTRAINT [FK_Cheque_vType] FOREIGN KEY(VTYPE)
REFERENCES [dbo].[VTYPE] (VTYPE)
GO

ALTER TABLE [dbo].[Cheque] CHECK CONSTRAINT [FK_Cheque_vType]
GO


ALTER TABLE [dbo].[vPattern]  WITH NOCHECK ADD  CONSTRAINT [FK_VPattern_vType] FOREIGN KEY([vType])
REFERENCES [dbo].[vType] ([vType])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[vPattern] CHECK CONSTRAINT [FK_VPattern_vType]
GO



 insert into PatchVersioning	
select '619 Update Script - Patch 2023 (30)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='619 Update Script - Patch 2023 (30)'


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


