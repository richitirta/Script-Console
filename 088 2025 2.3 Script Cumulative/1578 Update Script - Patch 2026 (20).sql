DROP Procedure Update_Closing_Balance_GL 
GO
CREATE Procedure Update_Closing_Balance_GL (@P_Branch Varchar(10), @P_pMth as Smallint, @P_pYr as Smallint,@P_Mth as Smallint, @P_Yr as Smallint)
as  
Insert into GL
(
Branch,[Month],[Year]
, Account,Starting,Ending,Closing, Starting_RC, Ending_RC, Closing_RC, Revaluation, Revaluation_RC, Closing_12, Closing_RC_12
, Debit, Debit_RC, Credit, Credit_RC
, Balance_1, Balance_2, Balance_3, Balance_4, Balance_5, Balance_6, Balance_7, Balance_8, Balance_9, Balance_10, Balance_11, Balance_12, Balance_13, Balance_14, Balance_15
, Balance_16, Balance_17, Balance_18, Balance_19, Balance_20, Balance_21, Balance_22, Balance_23, Balance_24, Balance_25, Balance_26, Balance_27, Balance_28, Balance_29, Balance_30, Balance_31
, Balance_RC_1, Balance_RC_2, Balance_RC_3, Balance_RC_4, Balance_RC_5, Balance_RC_6, Balance_RC_7, Balance_RC_8, Balance_RC_9, Balance_RC_10, Balance_RC_11, Balance_RC_12, Balance_RC_13, Balance_RC_14, Balance_RC_15
, Balance_RC_16, Balance_RC_17, Balance_RC_18, Balance_RC_19, Balance_RC_20, Balance_RC_21, Balance_RC_22, Balance_RC_23, Balance_RC_24, Balance_RC_25, Balance_RC_26, Balance_RC_27, Balance_RC_28, Balance_RC_29, Balance_RC_30, Balance_RC_31
)
Select Branch,@P_Mth, @P_Yr,Account,
Ending,Ending, Case When @P_Mth<>1 Then Closing+Ending-Starting Else 0 End,
Ending_RC, Ending_RC, Case When @P_Mth<>1 Then Closing_RC+Ending_RC-Starting_RC Else 0 End,0,0,
Case When @P_Mth<>12 Then Closing+Ending-Starting Else 0 End,
Case When @P_Mth<>12 Then Closing_RC+Ending_RC-Starting_RC Else 0 End
,0,0,0,0
,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
From GL Where GL.Branch=@P_Branch and GL.[Month]=@P_pMth and GL.[Year]=@P_pYr

GO

DROP Procedure Update_Closing_Balance_GL_FX
GO
CREATE  Procedure Update_Closing_Balance_GL_FX (@P_Branch Varchar(10), @P_pMth as Smallint, @P_pYr as Smallint,@P_Mth as Smallint, @P_Yr as Smallint)
as
Insert into GL_FX
(
Branch,[Month],[Year],Account,Currency,Starting,Ending, Closing, Starting_BC, Ending_BC, Closing_BC, Starting_RC, Ending_RC, Closing_RC, Revaluation, Revaluation_RC, Closing_12, Closing_BC_12, Closing_RC_12
, Debit_BC, Credit_BC, Debit, Debit_RC, Credit, Credit_RC
, Balance_1, Balance_2, Balance_3, Balance_4, Balance_5, Balance_6, Balance_7, Balance_8, Balance_9, Balance_10, Balance_11, Balance_12, Balance_13, Balance_14, Balance_15
, Balance_16, Balance_17, Balance_18, Balance_19, Balance_20, Balance_21, Balance_22, Balance_23, Balance_24, Balance_25, Balance_26, Balance_27, Balance_28, Balance_29, Balance_30, Balance_31
)
Select Branch,@P_Mth, @P_Yr,Account,Currency,
Ending,Ending,Case When @P_Mth<>1 Then Closing+Ending-Starting Else 0 End,
Ending_BC,Ending_BC,Case When @P_Mth<>1 Then Closing_BC+Ending_BC-Starting_BC Else 0 end,
Ending_RC,Ending_RC,Case When @P_Mth<>1 Then Closing_RC+Ending_RC-Starting_RC Else 0 end,0,0,
Case When @P_Mth<>12 Then Closing+Ending-Starting Else 0 End,
Case When @P_Mth<>12 Then Closing_BC+Ending_BC-Starting_BC Else 0 end,
Case When @P_Mth<>12 Then Closing_RC+Ending_RC-Starting_RC Else 0 end
,0,0,0,0,0,0
,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
From GL_FX Where GL_FX.Branch=@P_Branch and GL_FX.[Month]=@P_pMth and GL_FX.[Year]=@P_pYr

GO

DROP Procedure Update_Closing_Balance_CA_FX 
GO
CREATE Procedure Update_Closing_Balance_CA_FX (@P_Branch Varchar(10), @P_pMth as Smallint, @P_pYr as Smallint,@P_Mth as Smallint, @P_Yr as Smallint)
as
Insert into CA_FX(
Branch,[Month],[Year],Account,Currency,ComAcc,Starting,Ending, Closing, Starting_BC, Ending_BC, Closing_BC, Starting_RC, Ending_RC, Closing_RC, Revaluation, Revaluation_RC, Closing_12, Closing_BC_12, Closing_RC_12
, Debit_BC, Credit_BC, Debit, Debit_RC, Credit, Credit_RC
, Balance_1, Balance_2, Balance_3, Balance_4, Balance_5, Balance_6, Balance_7, Balance_8, Balance_9, Balance_10, Balance_11, Balance_12, Balance_13, Balance_14, Balance_15
, Balance_16, Balance_17, Balance_18, Balance_19, Balance_20, Balance_21, Balance_22, Balance_23, Balance_24, Balance_25, Balance_26, Balance_27, Balance_28, Balance_29, Balance_30, Balance_31
)
Select Branch,@P_Mth, @P_Yr,Account,Currency,ComAcc, 
Ending,Ending,Case When @P_Mth<>1 Then Closing+Ending-Starting Else 0 End,
Ending_BC,Ending_BC,Case When @P_Mth<>1 Then Closing_BC+Ending_BC-Starting_BC Else 0 end,
Ending_RC,Ending_RC,Case When @P_Mth<>1 Then Closing_RC+Ending_RC-Starting_RC Else 0 end,0,0,
Case When @P_Mth<>12 Then Closing+Ending-Starting Else 0 End,
Case When @P_Mth<>12 Then Closing_BC+Ending_BC-Starting_BC Else 0 end,
Case When @P_Mth<>12 Then Closing_RC+Ending_RC-Starting_RC Else 0 end
,0,0,0,0,0,0
,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
From CA_FX Where CA_FX.Branch=@P_Branch and CA_FX.[Month]=@P_pMth and CA_FX.[Year]=@P_pYr

GO

insert into PatchVersioning
select '1578 Update Script - Patch 2026 (20).sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1578 Update Script - Patch 2026 (20).sql'


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

GO 