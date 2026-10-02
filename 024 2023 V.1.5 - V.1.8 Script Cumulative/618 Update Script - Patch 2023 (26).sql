
alter table vPattern drop  constraint FK_vPattern_vType
GO
alter table vPattern drop  constraint VTypeVPattern
GO
alter table mVoucher drop  constraint FK_mVoucher_vType
GO
alter table nVoucher drop  constraint FK_nVoucher_vType
GO
alter table pVoucher drop  constraint FK_pVoucher_vType
GO
alter table Cheque drop  constraint FK_Cheque_vType
GO
alter table AssType drop  constraint vTypeAssType
GO
alter table AssType drop  constraint FK_AssType_vType
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
select '618 Update Script - Patch 2023 (26)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='618 Update Script - Patch 2023 (26)'


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


