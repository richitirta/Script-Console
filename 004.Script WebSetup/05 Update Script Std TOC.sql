

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QPScale]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE  [dbo].[QPScale] 
end
GO
CREATE PROCEDURE [dbo].[QPScale] (@TOC Varchar(30),@BASIS as varchar(1),@NOP as FLOAT )        
AS        
BEGIN        
 SELECT  * FROM PScale WHERE TOC=@TOC and BASIS=@BASIS and NOP=@NOP;
       
END

 
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QPFLSCALE]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE  [dbo].[QPFLSCALE] 
end
GO
  CREATE PROCEDURE [dbo].[QPFLSCALE] (@TOC Varchar(30),@FLValue as FLOAT )        
AS        
 BEGIN        
  SELECT * FROM PFLSCALE WHERE TOC=@TOC and FLValue=@FLValue;
 END 
 go
 
 
 IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InsertFields]') AND type in (N'U'))
begin
CREATE TABLE [dbo].[InsertFields](
	[Insert] [varchar](100) NULL,
	[InsertDesc] [varchar](512) NULL,
) ON [PRIMARY]


SET ANSI_PADDING OFF
end
GO



insert [InsertFields] select 'Company Name','<<COMPANY>>'
go
insert [InsertFields] select 'Policy Holder','<<PHOLDER>>'
go
insert [InsertFields] select 'Deductibler','<<DEDUCTIBLE&...>>'
go

insert [InsertFields] select 'Interest','<<INTEREST&...>>'
go
insert [InsertFields] select 'Sum Insured','<<SUMINSURED>>'
go
insert [InsertFields] select 'Leader','<<LEADER>>'
go

insert [InsertFields] select 'Members','<<MEMBERS>>'
go
insert [InsertFields] select 'Instalments','<<INSTALMENT>>'
go
insert [InsertFields] select 'Bankers Clauses','<<BANKERS CLAUSE>>'
go

insert [InsertFields] select 'Insured','<<INSURED>>'
go
insert [InsertFields] select 'Issue Date','<<ISSUEDATE>>'
go
insert [InsertFields] select 'Premium Calculation','<<PREMIUMCALCULATION>>'
go


insert [InsertFields] select 'Effective Date','<<EFFECTIVEDATE>>'
go
insert [InsertFields] select 'Expiry Date','<<EXPIRYDATE>>'
go
insert [InsertFields] select 'STNC Date','<<STNCDATE>>'
go

insert [InsertFields] select 'Insurance Period','<<INSURANCEPERIOD>>'
go


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_MenuSetD') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE  SP_MenuSetD
end
go
CREATE procedure SP_MenuSetD (@MenuID Varchar(10) )      

AS      

 BEGIN  
Select Cast(0 as bit) as ProcessFlag, M.*, S.Description From MenuSetD M, SysProcID S Where S.ProcID=M.ProcID and M.MenuID =@MenuID order by M.ProcID
 END 
go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_RepReg') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE  SP_RepReg
end
GO
CREATE procedure SP_RepReg (@code Varchar(20) )      

AS      

 BEGIN  

select CAST(0 As Bit) ProcessFlag,* From SysReport Where Code=@code

 END 
GO

 IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QTOC_BSOPEX]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
 BEGIN DROP PROCEDURE  [dbo].[QTOC_BSOPEX]
 end
 GO

 CREATE PROCEDURE [dbo].[QTOC_BSOPEX] (@TOC Varchar(10) )        
AS        
 BEGIN        
 SELECT CAST(0 As Bit) ProcessFlag ,*
 from BSOPEX  
 where TOC=@TOC ;        
 END 

 
GO


 IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[SP_Drop_BSOPEX]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
 BEGIN DROP PROCEDURE  [dbo].[SP_Drop_BSOPEX]
 end
 GO
Create Procedure [dbo].[SP_Drop_BSOPEX] (@TOC varchar(10),@ID varchar(10))      
as      
 begin      
  Delete From BSOPEX Where TOC=@TOC and  ID=@ID;      
 end  
 
 
go


insert into PatchVersioning
select '05 Update Script Std TOC',GETDATE()
go