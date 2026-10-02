
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'GL_Cash') AND type in (N'U'))
BEGIN

CREATE TABLE [dbo].[GL_Cash](
	[Month] [smallint] NOT NULL,
	[Year] [smallint] NOT NULL,
	[Account] [varchar](10) NOT NULL,
	[Branch] [varchar](10) NOT NULL,
	[Debit] [float] NULL,
	[Credit] [float] NULL,
 CONSTRAINT [I_GL_Cash] PRIMARY KEY NONCLUSTERED 
(
	[Branch] ASC,
	[Month] ASC,
	[Year] ASC,
	[Account] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)

ALTER TABLE [dbo].[GL_Cash]  WITH NOCHECK ADD  CONSTRAINT [FK_GL_Cash_Account] FOREIGN KEY([Account])
REFERENCES [dbo].[Account] ([Account])

ALTER TABLE [dbo].[GL_Cash] CHECK CONSTRAINT [FK_GL_Cash_Account]
end
GO


if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'DETAIL_SHARIA_SURPLUS') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION DETAIL_SHARIA_SURPLUS
end
GO
CREATE FUNCTION DETAIL_SHARIA_SURPLUS (@P_MONTH as integer, @P_YEAR as integer, @P_NUMMONTH as integer)   
RETURNS TABLE   
AS RETURN(   
Select AccClass.AcGroup, GL.Month, GL.Year, Max((@P_Month+@P_Year*12-1)-(GL.Month+GL.Year*12)+1) as Weighted, AccClass.AccClass, AccClass.ShortDesc, AccClass.Description,   
sum(-GL.Debit+GL.Credit) as Nominal  
from GL_Cash GL, Branch, Account, AccClassdet, AccClass  
Where GL.Month+GL.Year*12 Between @P_Month+@P_Year*12-1-@P_NUMMONTH+1 and @P_Month+@P_Year*12-1 --One Month Before  
and Branch.Branch=GL.Branch and Branch.Op_Flag=1 and Account.Account=GL.Account and AccClassDet.Account=Account.Account and AccClass.AccClass=AccClassDet.AccClass   
and Branch.ShariaF=1  
and AccClass.AcGroup in ('SURPLUS-SHARIA','INVESTMENT-RESULT')
group By AccClass.AcGroup, GL.Month, GL.Year, AccClass.AccClass, AccClass.ShortDesc, AccClass.Description  
)  

go



 insert into PatchVersioning
select '484 Update Script - 29 November 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='484 Update Script - 29 November 2022'


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
