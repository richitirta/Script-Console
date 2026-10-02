if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'DISPLAY_CALCULATION') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION fn_Risk_Coverage_LIPPO
END
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ICPS_PolicyCoverage') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function ICPS_PolicyCoverage
END
GO
alter table Rcover
Alter column Remark Varchar (Max)

GO
alter table TOI
Alter column Description Varchar (8000)

GO

Create Function [dbo].[ICPS_PolicyCoverage](@P_ANO as int, @P_Category as varchar(1))   
RETURNS VarChar(1024)      
With SchemaBinding  
AS      
BEGIN      
 Declare @Remarks as varchar(1024)      
 Declare @Remark as varchar(1024)     
 Declare @Rate  as varchar(1024)    
 Declare @Unit as varchar(1024)    
 Select @Remarks=''      
 DECLARE RCover_Cursor CURSOR FOR      
 Select Distinct cast(Remark as varchar(1024)) as Remark, convert(varchar(25),cast(Rate as money),1) as Rate, Case When RCover.Unit='C' Then '%' When RCover.Unit='M' Then '%o' else 'Flat' end as Unit from DBO.RCover RCover     
 Where ANO=@P_ANO and (Category=@P_Category or @P_Category='')      
 OPEN RCover_Cursor      
 FETCH FROM RCover_Cursor into @Remark, @Rate, @Unit    
 WHILE @@FETCH_STATUS = 0      
 BEGIN      
    if @Remarks=''      
    BEGIN      
  Select @Remarks=@Remark+'('+@Rate+@Unit+')'    
    End      
     Else      
    BEGIN      
     Select @Remarks=substring(@Remarks+'|'+@Remark+'('+@Rate+@Unit+')',1,1024)      
    End      
    FETCH NEXT FROM RCover_Cursor into @Remark, @Rate, @Unit    
 End      
 Close RCover_Cursor      
 Deallocate RCover_Cursor      
 Return (@Remarks)      
End      

GO
Create Function fn_Risk_Coverage_LIPPO(@P_ANO as int, @P_Category as varchar(1)) 
RETURNS VarChar(1024)    
With SchemaBinding
AS    
BEGIN    
 Declare @Remarks as varchar(1024)    
 Declare @Remark as varchar(1024)   
 Declare @Rate  as varchar(1024)  
 Declare @Unit as varchar(1024) 
 DECLARE @NewLineChar AS CHAR(2) = CHAR(13) + CHAR(10)
 Select @Remarks=''    
 DECLARE RCover_Cursor CURSOR FOR    
 Select Distinct cast(Remark as varchar(1024)) as Remark, convert(varchar(25),cast(Rate as money),1) as Rate, Case When RCover.Unit='C' Then '%' When RCover.Unit='M' Then '%o' else 'Flat' end as Unit from DBO.RCover RCover   
 Where ANO=@P_ANO and (Category=@P_Category or @P_Category='')    
 OPEN RCover_Cursor    
 FETCH FROM RCover_Cursor into @Remark, @Rate, @Unit  
 WHILE @@FETCH_STATUS = 0    
 BEGIN    
    if @Remarks=''    
    BEGIN    
  Select @Remarks=@Remark+'('+@Rate+@Unit+')'  
    End    
     Else    
    BEGIN    
     Select @Remarks=substring(@Remarks + @NewLineChar + @Remark+'('+@Rate+@Unit+')',1,1024)    
    End    
    FETCH NEXT FROM RCover_Cursor into @Remark, @Rate, @Unit  
 End    
 Close RCover_Cursor    
 Deallocate RCover_Cursor    
 Return (@Remarks)    
End    
GO


 insert into PatchVersioning
select '851 Script Inisialisasi Patch 2023 (117)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='851 Script Inisialisasi Patch 2023 (117)'


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






