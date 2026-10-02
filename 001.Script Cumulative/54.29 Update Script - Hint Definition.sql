
Begin tran
Delete from HInt

Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -20,'Ujroh Cedant','Ujroh Cedant','0','CARE','12/31/2020','--Un-Used--','--Un-Used--'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -19,'Deposit/Reserve','Deposit/Reserve','0','CARE','12/31/2020','--Un-Used--','--Un-Used--'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -18,'Others Tax #2','Others Tax #2','0','CARE','12/31/2020','Tax Adjustment','Tax Adjustment'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -17,'Others Tax #1','Others Tax #1','0','CARE','12/31/2020','Claim Adjustment','Claim Adjustment'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -16,'Others Fee/Stamp Duty #2','Others Fee/Duty #2','0','CARE','12/31/2020','Claim Stamp Duty','Claim Stamp Duty'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -15,'Others Fee/Stamp Duty #1','Others Fee/Duty #1','0','CARE','12/31/2020','Others Fee','Others Fee'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -14,'Pajak Penghasilan','PPH (TAX)','0','CARE','12/31/2020','Pajak Penghasilan','PPH (TAX)'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -13,'Pajak Pertambahan Nilai','PPN (VAT)','0','CARE','12/31/2020','Pajak Pertambahan Nilai','PPN (VAT)'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -12,'Others Fee/Stamp Duty #3','Others Fee/Duty #3','0','CARE','12/31/2020','Other Income (Claim)','Other Income'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -11,'Other Income (Premium)','Other Income','0','CARE','12/31/2020','--Un-Used--','--Un-Used--'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -10,'Subrogation','Subrogation','0','CARE','12/31/2020','Subrogation Amount','Subrogation'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -9,'Overriding Commission','Overriding Comm','0','CARE','12/31/2020','Claim Expenses','Claim Expenses'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -8,'Profit Sharing','Profit Sharing','0','CARE','12/31/2020','Salvage','Salvage Amount'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -7,'Premium Adjustment','Premium Adjustment','0','CARE','12/31/2020','Deductible Amount','Deductible'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -6,'Claim Amount','Claim Amount','0','CARE','12/31/2020','Claim Amount','Claim Amount'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -5,'Discount/Overriding','Disc. (Over.)','0','CARE','12/31/2020','Discount','Discount'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -4,'Stamp Duty/Guarantee Fund','Stamp Duty/G.Fund','0','CARE','12/31/2020','--Un-Used--','--Un-Used--'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -3,'Fee','Fee','0','CARE','12/31/2020','--Un-Used--','--Un-Used--'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -2,'Commission','Commission','0','CARE','12/31/2020','--Un-Used--','--Un-Used--'
Insert into Hint(Hint, Remarks, ShortDesc, ProAccf, Last_Opr, Last_Update, Remarks_1,ShortDesc_1) 
Select -1,'Premium','Premium','0','CARE','12/31/2020','--Un-Used--','--Un-Used--'

commit tran
go


  insert into PatchVersioning
select '54.29 Update Script - Hint Definition',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='54.28 Update Script WebSetup Standarisasi before 2020 v.1'
Select @CurrSCript='54.29 Update Script - Hint Definition'


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





