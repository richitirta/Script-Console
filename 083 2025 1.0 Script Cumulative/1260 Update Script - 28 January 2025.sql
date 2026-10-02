IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'VDOCLIST') AND type in (N'U'))
BEGIN
SET ANSI_NULLS ON
 

SET QUOTED_IDENTIFIER ON
 
CREATE TABLE [dbo].[VDOCLIST](
	[VOUCHER] [varchar](30) NOT NULL,
	[DOCTYPE] [varchar](10) NOT NULL,
	[DESCRIPTION] [varchar](255) NULL,
	[AVAILABLEF] [bit] NULL,
	[DOCNO] [varchar](50) NULL,
	[REMARKS] [varchar](512) NULL,
	[RECDATE] [smalldatetime] NULL,
	[RELDATE] [smalldatetime] NULL,
	[LOCID] [varchar](100) NULL,
	[DOCSTATUS] [varchar](50) NULL,
	[LAST_OPR] [varchar](50) NULL,
	[LAST_UPDATE] [smalldatetime] NULL,
 CONSTRAINT [I_VDOCLIST] PRIMARY KEY NONCLUSTERED 
(
	[VOUCHER] ASC,
	[DOCTYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]
 

ALTER TABLE [dbo].[VDOCLIST] SET (LOCK_ESCALATION = DISABLE)
end
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'VDOCLISTPIC') AND type in (N'U'))
BEGIN
SET ANSI_NULLS ON
 

SET QUOTED_IDENTIFIER ON
 

CREATE TABLE [dbo].[VDOCLISTPIC](
	[VOUCHER] [varchar](30) NOT NULL,
	[DOCTYPE] [varchar](10) NOT NULL,
	[ImageID] [int] NOT NULL,
	[FileType] [varchar](10) NULL,
	[Title] [varchar](255) NULL,
	[Remark] [varchar](max) NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
 
ALTER TABLE [dbo].[VDOCLISTPIC] SET (LOCK_ESCALATION = DISABLE)

end
GO

 IF not EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='VDOCLIST' AND CONSTRAINT_NAME='FK_VDOCLIST_VOUCHER')
 Begin
ALTER TABLE [dbo].[VDOCLIST]  WITH NOCHECK ADD  CONSTRAINT [FK_VDOCLIST_VOUCHER] FOREIGN KEY([VOUCHER])
REFERENCES [dbo].[pVOUCHER] ([VOUCHER])
ON UPDATE CASCADE
ON DELETE CASCADE
ENd
go
 
  IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='VDOCLIST' AND CONSTRAINT_NAME='FK_VDOCLIST_VOUCHER')
 Begin
ALTER TABLE [dbo].[VDOCLIST] CHECK CONSTRAINT [FK_VDOCLIST_VOUCHER]
 end
 go

 IF not EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='VDOCLISTPIC' AND CONSTRAINT_NAME='FK_VDOCLISTPIC_VDOCLIST')
 Begin
ALTER TABLE [dbo].[VDOCLISTPIC]  WITH CHECK ADD  CONSTRAINT [FK_VDOCLISTPIC_VDOCLIST] FOREIGN KEY([VOUCHER], [DOCTYPE])
REFERENCES [dbo].[VDOCLIST] ([VOUCHER], [DOCTYPE])
ON UPDATE CASCADE
ON DELETE CASCADE
end
go
 IF not EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='VDOCLISTPIC' AND CONSTRAINT_NAME='FK_VDOCLISTPIC_VDOCLIST')
 Begin
ALTER TABLE [dbo].[VDOCLISTPIC] CHECK CONSTRAINT [FK_VDOCLISTPIC_VDOCLIST]
end
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Payment VOUCHER (see VOUCHER)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VDOCLIST', @level2type=N'COLUMN',@level2name=N'VOUCHER'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Document Type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VDOCLIST', @level2type=N'COLUMN',@level2name=N'DOCTYPE'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Document Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VDOCLIST', @level2type=N'COLUMN',@level2name=N'DESCRIPTION'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Available or No' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VDOCLIST', @level2type=N'COLUMN',@level2name=N'AVAILABLEF'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Document No.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VDOCLIST', @level2type=N'COLUMN',@level2name=N'DOCNO'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Document Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VDOCLIST', @level2type=N'COLUMN',@level2name=N'REMARKS'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Released Date (Released for Recovery)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VDOCLIST', @level2type=N'COLUMN',@level2name=N'RELDATE'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Custodian Location ID ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VDOCLIST', @level2type=N'COLUMN',@level2name=N'LOCID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N''''', ''N/A'', ''RECEIVED'', ''RELEASED''' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VDOCLIST', @level2type=N'COLUMN',@level2name=N'DOCSTATUS'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'VOUCHER No (Payment VOUCHER No)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VDOCLISTPIC', @level2type=N'COLUMN',@level2name=N'VOUCHER'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Document Type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VDOCLISTPIC', @level2type=N'COLUMN',@level2name=N'DOCTYPE'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Image ID (see SysImage)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VDOCLISTPIC', @level2type=N'COLUMN',@level2name=N'ImageID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Document File Type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VDOCLISTPIC', @level2type=N'COLUMN',@level2name=N'FileType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Image Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VDOCLISTPIC', @level2type=N'COLUMN',@level2name=N'Title'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Remark' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'VDOCLISTPIC', @level2type=N'COLUMN',@level2name=N'Remark'
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QVDOCLIST') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QVDOCLIST
end
GO

CREATE Procedure QVDOCLIST(@P_Voucher as varchar(30))     
as     
Select VDOCLIST.*, R1.CountImage, R2.ImageId, R2.FileType  
from     
pVoucher
Cross Apply
(     
 Select Cast(0 as bit) as ProcessFlag, DOCTYPE.DOCTYPE, DOCTYPE.DESCRIPTION as DOCTYPEDESC, DOCTYPE.DESCRIPTION, coalesce(DocType.MandatoryF, cast(0 as Bit)) as MandatoryF, Cast(0 as bit) as AvailableF, Cast(Null as smalldatetime) as RECDATE    
 from DocType     
 Where DocType.Purpose=Case When pVoucher.CreditorF=1 Then 'PAYMENT' Else 'RECEIPT' end and DocType.AllowedF=1 and NOT EXISTS (Select DocType from VDOCLIST Where VDOCLIST.DocType=DocType.DocType and VDOCLIST.Voucher=pVoucher.Voucher)     
     
 Union All     
     
 select VDOCLIST.AvailableF as ProcessFlag, VDOCLIST.DOCTYPE, DOCTYPE.DESCRIPTION as DOCTYPEDESC, VDOCLIST.Description, coalesce(DocType.MandatoryF, cast(0 as Bit)) as MandatoryF, VDOCLIST.AvailableF as AvailableF, VDOCLIST.RECDATE     
 from VDOCLIST     
 Left Join DocType on (DocType.DocType=VDOCLIST.DocType)    
 Where VDOCLIST.Voucher=pVoucher.Voucher
) VDOCLIST     
Outer Apply (    
 Select count(R.ImageID) as CountImage from VDOCLISTPIC R Where R.Voucher=pVoucher.Voucher and R.DocType=VDOCLIST.DocType    
) R1    
Outer Apply (    
 Select Top 1 R.ImageID, R.FileType from VDOCLISTPIC R Where R.Voucher=pVoucher.Voucher and R.DocType=VDOCLIST.DocType Order by R.ImageID Desc  
) R2    
Where pVoucher.Voucher=@P_Voucher
Order By VDOCLIST.DOCTYPE   
GO


  insert into PatchVersioning
select '1260 Update Script - 28 January 2025',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1260 Update Script - 28 January 2025'


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
