IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='IFRS_ERatio_Detail' AND CONSTRAINT_NAME='I_IFRS_ERatio_Detail')
Begin
Alter Table IFRS_ERatio_Detail drop constraint I_IFRS_ERatio_Detail
end
GO
IF not EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='IFRS_ERatio_Detail' AND CONSTRAINT_NAME='I_IFRS_ERatio_Detail')
Begin
Alter Table IFRS_ERatio_Detail add constraint I_IFRS_ERatio_Detail primary key clustered (ERatioID, Tenor, VDate)
end
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='IFRS_DiscRate_Detail' AND CONSTRAINT_NAME='I_IFRS_DiscRate_Detail')
Begin
Alter Table IFRS_DiscRate_Detail drop constraint I_IFRS_DiscRate_Detail
end
GO
IF not EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='IFRS_DiscRate_Detail' AND CONSTRAINT_NAME='I_IFRS_DiscRate_Detail')
Begin
Alter Table IFRS_DiscRate_Detail add constraint I_IFRS_DiscRate_Detail primary key clustered (DiscRateID, Tenor, VDate)
end
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_IFRS_Calculation_AssumptionID_Method_Branch_Segment_ISType_TOC_CGroup_Currency_Year_Month_NumMonths_Onerous' AND object_id = OBJECT_ID(N'IFRS_Calculation'))
Begin
drop index IFRS_Calculation.I_IFRS_Calculation_AssumptionID_Method_Branch_Segment_ISType_TOC_CGroup_Currency_Year_Month_NumMonths_Onerous
end
GO
create index I_IFRS_Calculation_AssumptionID_Method_Branch_Segment_ISType_TOC_CGroup_Currency_Year_Month_NumMonths_Onerous on IFRS_Calculation(AssumptionID, Method, Branch, Segment, ISType, TOC, CGroup, Currency, Year, Month, NumMonths, Onerous)

GO
IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_IFRS_Initial_A_PolicyNo_Type_Branch_Segment_ISType_TOC_CGroup_Currency_Year_Month_NumMonths' AND object_id = OBJECT_ID(N'IFRS_Initial'))
Begin
drop index IFRS_Initial.I_IFRS_Initial_A_PolicyNo_Type_Branch_Segment_ISType_TOC_CGroup_Currency_Year_Month_NumMonths
end
GO
create index I_IFRS_Initial_A_PolicyNo_Type_Branch_Segment_ISType_TOC_CGroup_Currency_Year_Month_NumMonths on IFRS_Initial(A_PolicyNo, Type, Branch, ISType, Segment, TOC, CGroup, Currency, Year, Month, NumMonths)
go

 insert into PatchVersioning	
select '747 Update Script - IFRS Patch #19',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(1004)

Select @PrevScript=''
Select @CurrSCript='747 Update Script - IFRS Patch #19'


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



