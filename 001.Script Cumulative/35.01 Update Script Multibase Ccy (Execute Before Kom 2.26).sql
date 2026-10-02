--multibase currency
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].Update_Closing_Balance_GL') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE Update_Closing_Balance_GL END 
GO
CREATE Procedure Update_Closing_Balance_GL (@P_Branch Varchar(10), @P_pMth as Smallint, @P_pYr as Smallint,@P_Mth as Smallint, @P_Yr as Smallint)
as  
Insert into GL(Branch,[Month],[Year],Account,Starting,Ending,Closing, Starting_RC, Ending_RC, Closing_RC, Revaluation, Revaluation_RC)
Select Branch,@P_Mth, @P_Yr,Account,
Ending,Ending, Case When @P_Mth<>1 Then Closing+Ending-Starting Else 0 End,
Ending_RC, Ending_RC, Case When @P_Mth<>1 Then Closing_RC+Ending_RC-Starting_RC Else 0 End,0,0 
From GL Where GL.Branch=@P_Branch and GL.[Month]=@P_pMth and GL.[Year]=@P_pYr

GO  

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].Update_Closing_Balance_GL_FX') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE Update_Closing_Balance_GL_FX END 
GO
CREATE  Procedure Update_Closing_Balance_GL_FX (@P_Branch Varchar(10), @P_pMth as Smallint, @P_pYr as Smallint,@P_Mth as Smallint, @P_Yr as Smallint)
as
Insert into GL_FX(Branch,[Month],[Year],Account,Currency,Starting,Ending, Closing, Starting_BC, Ending_BC, Closing_BC, Starting_RC, Ending_RC, Closing_RC, Revaluation, Revaluation_RC)
Select Branch,@P_Mth, @P_Yr,Account,Currency,
Ending,Ending,Case When @P_Mth<>1 Then Closing+Ending-Starting Else 0 End,
Ending_BC,Ending_BC,Case When @P_Mth<>1 Then Closing_BC+Ending_BC-Starting_BC Else 0 end,
Ending_RC,Ending_RC,Case When @P_Mth<>1 Then Closing_RC+Ending_RC-Starting_RC Else 0 end,0,0	
From GL_FX Where GL_FX.Branch=@P_Branch and GL_FX.[Month]=@P_pMth and GL_FX.[Year]=@P_pYr

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].Update_Closing_Balance_CA_FX') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE Update_Closing_Balance_CA_FX END 
GO
CREATE  Procedure Update_Closing_Balance_CA_FX (@P_Branch Varchar(10), @P_pMth as Smallint, @P_pYr as Smallint,@P_Mth as Smallint, @P_Yr as Smallint)
as
Insert into CA_FX(Branch,[Month],[Year],Account,Currency,ComAcc,Starting,Ending, Closing, Starting_BC, Ending_BC, Closing_BC, Starting_RC, Ending_RC, Closing_RC, Revaluation, Revaluation_RC)
Select Branch,@P_Mth, @P_Yr,Account,Currency,ComAcc, 
Ending,Ending,Case When @P_Mth<>1 Then Closing+Ending-Starting Else 0 End,
Ending_BC,Ending_BC,Case When @P_Mth<>1 Then Closing_BC+Ending_BC-Starting_BC Else 0 end,
Ending_RC,Ending_RC,Case When @P_Mth<>1 Then Closing_RC+Ending_RC-Starting_RC Else 0 end,0,0
From CA_FX Where CA_FX.Branch=@P_Branch and CA_FX.[Month]=@P_pMth and CA_FX.[Year]=@P_pYr

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].Update_Closing_Balance_SL_FX') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE Update_Closing_Balance_SL_FX END 
GO
CREATE Procedure Update_Closing_Balance_SL_FX (@P_Branch Varchar(10), @P_pMth as Smallint, @P_pYr as Smallint,@P_Mth as Smallint, @P_Yr as Smallint)
as
Insert into SL_FX(Branch,[Month],[Year],Account,Currency,ProAcc, Starting,Ending, Closing, Starting_BC, Ending_BC, Closing_BC, Starting_RC, Ending_RC, Closing_RC, Revaluation, Revaluation_RC)
Select Branch,@P_Mth, @P_Yr,Account,Currency,ProAcc, 
Ending,Ending,Case When @P_Mth<>1 Then Closing+Ending-Starting Else 0 End,
Ending_BC,Ending_BC,Case When @P_Mth<>1 Then Closing_BC+Ending_BC-Starting_BC Else 0 end,
Ending_RC,Ending_RC,Case When @P_Mth<>1 Then Closing_RC+Ending_RC-Starting_RC Else 0 end,0,0
From SL_FX Where SL_FX.Branch=@P_Branch and SL_FX.[Month]=@P_pMth and SL_FX.[Year]=@P_pYr

GO

insert into PatchVersioning
select '35.01 Update Script Multibase Ccy (Execute Before Kom 2.26)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='35 Script Komulatif Konsol 2.25'
Select @CurrSCript='35.01 Update Script Multibase Ccy (Execute Before Kom 2.26)'


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



