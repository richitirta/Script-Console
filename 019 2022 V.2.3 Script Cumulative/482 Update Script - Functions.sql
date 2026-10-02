DROP FUNCTION fn_Get_Prorata24
GO
CREATE FUNCTION fn_Get_Prorata24(@P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_PDate as smalldatetime)                    
RETURNS Float      
AS                     
BEGIN                    
 Declare @P_Denominator as integer                  
 Declare @P_Nominator as integer                  
 Declare @P_Prorata as float      
         
 if datediff(day,@P_PDate, @P_EDate)>0
 Begin      
  --Prorata 24
  Select @P_Denominator = datediff(month, @P_SDate, @P_EDate)*2       
  Select @P_Nominator = datediff(month, Case When datediff(day,@P_SDate, @P_PDate)>=0 Then (Case When datediff(day,@P_EDate, @P_PDate)<=0 Then @P_PDate Else @P_EDate end) else @P_SDate end , @P_EDate)*2-1       

  Select @P_Prorata=cast(@P_Nominator as float)/cast(@P_Denominator as float)      
 end      
 else       
 Begin      
 Select @P_Prorata=0      
 end      
 return(@P_Prorata)      
End 

GO

DROP FUNCTION fn_Get_Prorata
GO
CREATE FUNCTION fn_Get_Prorata(@P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_PDate as smalldatetime)                    
RETURNS Float      
AS                     
BEGIN                    
 Declare @P_Denominator as integer                  
 Declare @P_Nominator as integer                  
 Declare @P_Prorata as float      
         
 if datediff(day,@P_PDate, @P_EDate)>0
 Begin      
  --Days Prorata
  Select @P_Denominator = datediff(day, @P_SDate, @P_EDate)      
  Select @P_Nominator = datediff(day, Case When datediff(day,@P_SDate, @P_PDate)>=0 Then (Case When datediff(day,@P_EDate, @P_PDate)<=0 Then @P_PDate Else @P_EDate end) else @P_SDate end, @P_EDate)

  Select @P_Prorata=cast(@P_Nominator as float)/cast(@P_Denominator as float)      
 end      
 else       
 Begin      
 Select @P_Prorata=0      
 end      
 return(@P_Prorata)      
End 

GO

DROP Function fn_toval
GO
CREATE Function fn_toval(@sValue varchar(255))        
RETURNS Float AS          
BEGIN        
declare @temp as FLoat
set @temp=0          
if (len(@sValue)>1 and isNumeric(@sValue)=1) or (len(@sValue)=1 and charindex(@svalue,'1234567890')<>0)
	set @temp=cast(@svalue as Float)
else
    set @temp=0          
        
return @temp      
End

GO

DROP FUNCTION fn_Premium_Calc_Prorata
GO
CREATE FUNCTION fn_Premium_Calc_Prorata(@P_PSDate as smalldatetime, @P_PEDate as smalldatetime, @DaysProrata as Int, @MonthsProrata as Int, @P_PPeriod as integer)              
RETURNS Float
AS               
BEGIN              

Declare @P_Prorata as Float

if @DaysProrata=0 
Begin
	Select @DaysProrata=datediff(day,@P_PSDate,dateadd(month,@MonthsProrata,@P_PSDate))
End

if @P_PPeriod=3
Begin
	Select @P_Prorata=cast(datediff(Month,@P_PSDate, @P_PEDate) as Float)
	if day(@P_PSDate)>day(@P_PEDate)
	Begin
		Select @P_Prorata=@P_Prorata-1
			if @P_Prorata<0
				Select @P_Prorata=0
	End
	if datediff(day,dateadd(month,@P_Prorata, @P_PSDate),@P_PEDate)>15
		Select @P_Prorata=@P_Prorata+1
	Select @P_Prorata=@P_Prorata / @monthsProrata	
End
Else if @P_PPeriod=2
Begin
	Select @P_Prorata=cast(datediff(Month,@P_PSDate, @P_PEDate) as Float)
	if dateadd(month,@P_Prorata,@P_PSDate)<@P_PEDate
	Begin
		Select @P_Prorata=@P_Prorata+1
	End
	Select @P_Prorata=@P_Prorata / @monthsProrata	
End
Else 
Begin
	if day(@P_PSDate)<>day(@P_PEdate) or @P_PPeriod=1 
	Begin
		Select @P_Prorata=cast(datediff(day,@P_PSDate, @P_PEDate) as Float)/@DaysProrata
	End
	else
	Begin
		Select @P_Prorata=cast(datediff(month,@P_PSDate, @P_PEDate) as Float)/@MonthsProrata
	End
End

Return @P_Prorata

END  

GO

DROP Function fn_Age
GO
CREATE Function fn_Age(@sBirthDate varchar(100),@ComparisonDate as Date, @AgeMethod as int)        
RETURNS Float AS          
BEGIN        
declare @BirthDate as Date
declare @temp as FLoat
set @temp=0          
if isdate(@sBirthDate)=1 
	set @BirthDate=cast(@sBirthDate as Date)
else
	set @BirthDate=@ComparisonDate
        
if @comparisondate<=@BirthDate          
      set @temp=0          
else          
begin          
  set @temp=datediff(year,@BirthDate,@ComparisonDate)       
  if @AgeMethod=4  -- Nearest Birth Date by Month-Day    
  begin              
      if DateAdd(year,@Temp,@BirthDate)>@ComparisonDate      
            set @Temp=@Temp-1      
      if DateDiff(Month,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) = DateDiff(Month,@ComparisonDate, Dateadd(Year,@Temp+1,@BirthDate))      
      Begin  
		if DateAdd(Month, DateDiff(Month,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate),Dateadd(Year,@Temp,@BirthDate))<@ComparisonDate  
			set @Temp=@Temp+1            
	  End  
      else   
      Begin  
		if DateDiff(Month,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) > DateDiff(Month,@ComparisonDate, Dateadd(Year,@Temp+1,@BirthDate))      
           set @Temp=@Temp+1       
      End  
  end      
  else  
  if @AgeMethod=3 --Next Birth Day      
  begin              
      if DateAdd(year,@Temp,@BirthDate)>@ComparisonDate      
            set @Temp=@Temp-1      
      if DateDiff(day,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) > 0      
            set @Temp=@Temp+1          
  end        
  else       
  if @AgeMethod=2  -- Nearest Birth Date by Day    
  begin            
      if DateAdd(year,@Temp,@BirthDate)>@ComparisonDate    
            set @Temp=@Temp-1    
      if DateDiff(day,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) > DateDiff(day,@ComparisonDate, Dateadd(Year,@Temp+1,@BirthDate))    
            set @Temp=@Temp+1        
  end        
  else        
  if @AgeMethod=1 -- Nearest Birth Date by Month      
  begin        
      if DateAdd(year,@Temp,@BirthDate)>@ComparisonDate      
            set @Temp=@Temp-1      
      if DateDiff(Month,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) > DateDiff(Month,@ComparisonDate, Dateadd(Year,@Temp+1,@BirthDate))      
            set @Temp=@Temp+1       
  end            
  else   -- Year Lapse      
  begin         
      if @temp>0          
       if month(@ComparisonDate)< month(@BirthDate) or (month(@BirthDate)=month(@ComparisonDate) and day(@ComparisonDate)<day(@BirthDate))          
        set @temp=@temp-1            
  end      
end        
        
return @temp      
End

GO
DROP Function fn_Get_WorkingDate
GO
CREATE Function fn_Get_WorkingDate(@PDate as Smalldatetime)
RETURNS SmallDateTime AS        
BEGIN      
	Select @PDate=cast(year(@PDate) as varchar(4))+'/'+right('0'+cast(Month(@PDate) as varchar(4)),2)+'/'+right('0'+cast(Day(@PDate) as varchar(4)),2)

	WHILE exists(Select * from Holiday Where HolidayDate=@PDate) or datepart(dw,@PDate)=1 or datepart(dw,@PDate)=7
	 BEGIN  
		Select @PDate=dateadd(day,1,@PDate)
	 End  
	return @PDate
END      
   
GO
DROP Function GetUserRights
GO
CREATE Function GetUserRights(@UserID varchar(50), @FName varchar(50))
RETURNS INT AS        
BEGIN      

Declare @ReadF as bit
Declare @WriteF as bit
Declare @AddF as bit
Declare @DeleteF as bit
Declare @CheckF as bit
Declare @Modify as bit

Declare @UserRights as int
Select @UserRights=0

Select @FName=FName from SysForm Where FName=@FName

if @FName is null 
	return 0
else
Begin 
	Select @ReadF=S1.ReadF, @WriteF=S1.WriteF, @AddF=S1.AddF, @DeleteF=S1.DeleteF, @CheckF=S1.CheckF, @Modify=S1.ModifyF 
	from SysUser S2 
	Inner Join SysUserForm S1 on (S1.Type=S2.Type and S1.FName=@FNAme)
	where S2.ID=@UserID
	if coalesce(@ReadF,0)=1
		Select @UserRights = @UserRights | power(2,0)
	if coalesce(@WriteF,0)=1
		Select @UserRights = @UserRights | power(2,1)
	if coalesce(@AddF,0)=1
		Select @UserRights = @UserRights | power(2,2)
	if coalesce(@DeleteF,0)=1
		Select @UserRights = @UserRights | power(2,3)
	if coalesce(@CheckF,0)=1
		Select @UserRights = @UserRights | power(2,4)
	if coalesce(@Modify,0)=1
		Select @UserRights = @UserRights | power(2,5)
		
	Select @ReadF=S1.ReadF, @WriteF=S1.WriteF, @AddF=S1.AddF, @DeleteF=S1.DeleteF, @CheckF=S1.CheckF, @Modify=S1.ModifyF
	from sysusergrants S1 
	Where S1.ID=@UserID and S1.FName=@FName
	if coalesce(@ReadF,0)=1
		Select @UserRights = @UserRights | power(2,0)
	if coalesce(@WriteF,0)=1
		Select @UserRights = @UserRights | power(2,1)
	if coalesce(@AddF,0)=1
		Select @UserRights = @UserRights | power(2,2)
	if coalesce(@DeleteF,0)=1
		Select @UserRights = @UserRights | power(2,3)
	if coalesce(@CheckF,0)=1
		Select @UserRights = @UserRights | power(2,4)	
	if coalesce(@Modify,0)=1
		Select @UserRights = @UserRights | power(2,5)				
end
	
return @UserRights
END        

GO
DROP Function GetPrivileges
GO
CREATE Function GetPrivileges(@UserID varchar(50), @FName varchar(50))
RETURNS BIT AS        
BEGIN      
	Declare @UserRights as int
	Declare @WriteRights as int
	Declare @Privilege as Bit
	Select @writeRights =2
	Select @UserRights=dbo.GetUserRights(@UserID, @FName)
 
    if (@UserRights & @writeRights)=@WriteRights
		Select @Privilege=1
	else
		Select @Privilege=0
	return @Privilege
END         

GO

DROP Function GetApprovalLimit
GO

CREATE Function GetApprovalLimit(@UserID varchar(50), @TOC varchar(10), @ISType varchar(1), @InOut varchar(10), @Branch varchar(10), @ApprLimitPct Float)
RETURNS Float AS        
BEGIN      
	Declare @BType as varchar(10)
	Declare @UType as varchar(10)
	Declare @LimitIn as Float
	Declare @LimitOut as Float

	Declare @tempLimitIn as Float
	Declare @tempLimitOut as Float
	Declare @ApprovalLimit as Float

	Declare @PDate as smalldatetime

	Select @PDate=cast(year(getdate()) as varchar(4))+'/'+right('0'+cast(Month(getdate()) as varchar(4)),2)+'/'+right('0'+cast(Day(getdate()) as varchar(4)),2)

	if @ApprLimitPct=0 
		Select @ApprLimitPct=100

	If @ISType = 'I' Or @ISType  = 'L' Or @ISType = 'C'
		Select @BType='DIRECT'
	Else
		Select @BType='INDIRECT'

	select 
	@UType=S1.Type,
	@LimitIn=Case When S1.LimitIn<>0 then S1.LimitIn else S2.LimitIn end,
	@LimitOut=Case When S1.LimitOut<>0 then S1.LimitOut else S2.LimitOut end 
	from sysuser S1
	Inner Join SysUserType S2 on (S2.Type=S1.Type)
	where S1.ID=@UserID
    

	if @TOC<>''
	Begin
		Select Top 1 @tempLimitIn=LimitIn, @tempLimitOut=LimitOut 
		from SysUserTypeTOC 
		Where Type=@UType and BType=@BType and TOC=@TOC and Effective<=@PDate 
		Order By Effective Desc
		if @tempLimitIn<>0 
			Select @LimitIn=@TempLimitIn

		if @tempLimitOut<>0 
			Select @LimitOut=@tempLimitOut

		Select Top 1 @tempLimitIn=LimitIn, @tempLimitOut=LimitOut 
		from SysUserTOC 
		Where ID=@UserID and TOC=@TOC and Effective<=@PDate 
		Order By Effective Desc

		if @tempLimitIn<>0 
			Select @LimitIn=@TempLimitIn

		if @tempLimitOut<>0 
			Select @LimitOut=@tempLimitOut

		if @Branch<>''
		Begin
			Select Top 1 @tempLimitIn=LimitIn, @tempLimitOut=LimitOut 
			from SysUserTOCBranch 
			Where ID=@UserID and TOC=@TOC and Branch=@Branch and Effective<=@PDate 
			Order By Effective Desc

			if @tempLimitIn<>0 
				Select @LimitIn=@TempLimitIn

			if @tempLimitOut<>0 
				Select @LimitOut=@tempLimitOut
		end
	End

	if @InOut='IN'
		Select @ApprovalLimit=@LimitIn*@ApprLimitPct/100
	else
		Select @ApprovalLimit=@LimitOut*@ApprLimitPct/100

	return @ApprovalLimit
END        

GO
DROP Function GetApprovalLimitFA
GO
CREATE Function GetApprovalLimitFA(@UserID varchar(50), @VType varchar(10), @InOut varchar(10))
RETURNS Float AS        
BEGIN      
	Declare @LimitIn as Float
	Declare @LimitOut as Float

	Declare @tempLimitIn as Float
	Declare @tempLimitOut as Float
	Declare @ApprovalLimit as Float

	Declare @PDate as smalldatetime

	Select @PDate=cast(year(getdate()) as varchar(4))+'/'+right('0'+cast(Month(getdate()) as varchar(4)),2)+'/'+right('0'+cast(Day(getdate()) as varchar(4)),2)

	select 
	@LimitIn=Case When S1.LimitIn<>0 then S1.LimitIn else S2.LimitIn end,
	@LimitOut=Case When S1.LimitOut<>0 then S1.LimitOut else S2.LimitOut end 
	from sysuser S1
	Inner Join SysUserType S2 on (S2.Type=S1.Type)
	where S1.ID=@UserID
    

	if @VType<>''
	Begin
		Select Top 1 @tempLimitIn=LimitIn, @tempLimitOut=LimitOut 
		from SysUserVType 
		Where ID=@UserID and VType=@VType
		if @tempLimitIn<>0 
			Select @LimitIn=@TempLimitIn

		if @tempLimitOut<>0 
			Select @LimitOut=@tempLimitOut
	End

	if @InOut='IN'
		Select @ApprovalLimit=@LimitIn
	else
		Select @ApprovalLimit=@LimitOut

	return @ApprovalLimit
END        

GO

DROP FUNCTION fn_Calc_Prorata
GO
CREATE FUNCTION fn_Calc_Prorata(@P_PSDate as smalldatetime, @P_PEDate as smalldatetime, @P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_PPeriod as integer)              
RETURNS Float
AS               
BEGIN              

Declare @P_Prorata as Float

if @P_PPeriod=3
Begin
	Select @P_Prorata=cast(dbo.fn_premium_calc_Prorata(@P_PSDate, @P_PEDate,0,1,@P_PPeriod) as Float) / cast(dbo.fn_premium_calc_Prorata(@P_SDate, @P_EDate,0,1,@P_PPeriod) as Float)
End
else if @P_PPeriod=2
Begin
	Select @P_Prorata=cast(dbo.fn_premium_calc_Prorata(@P_PSDate, @P_PEDate,0,1,@P_PPeriod) as Float) / cast(dbo.fn_premium_calc_Prorata(@P_SDate, @P_EDate,0,1,@P_PPeriod) as Float)
End
Else 
Begin
	if day(@P_PSDate)=day(@P_PEdate) and day(@P_PSDate)=day(@P_Edate) and day(@P_SDate)=day(@P_Edate) and @P_PPeriod<>1 and datediff(month,@P_Sdate,@P_Edate)<>0
	Begin
		Select @P_Prorata=cast(datediff(month,@P_PSDate, @P_PEDate) as Float)/cast(datediff(month,@P_SDate, @P_EDate) as Float)
	End
	else
	Begin
		Select @P_Prorata=cast(datediff(day,@P_PSDate, @P_PEDate) as Float)/cast(datediff(day,@P_SDate, @P_EDate) as Float)
	End
End

Return @P_Prorata

END  
  

GO

DROP FUNCTION fn_Calc_SProrata
GO
CREATE FUNCTION fn_Calc_SProrata(@P_PSDate as smalldatetime, @P_PEDate as smalldatetime, @P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_PPeriod as integer)              
RETURNS varchar(255)
AS               
BEGIN              

Declare @P_Prorata as Float
Declare @P_SProrata as varchar(255)

if @P_PPeriod=3
Begin
	if cast(dbo.fn_premium_calc_Prorata(@P_PSDate, @P_PEDate,0,1,@P_PPeriod) as integer)<>cast(dbo.fn_premium_calc_Prorata(@P_SDate, @P_EDate,0,1,@P_PPeriod) as integer)
		Select @P_SProrata= convert(varchar(25),dbo.fn_premium_calc_Prorata(@P_PSDate, @P_PEDate,0,1,@P_PPeriod))+'/'+convert(varchar(25),dbo.fn_premium_calc_Prorata(@P_SDate, @P_EDate,0,1,@P_PPeriod))
	else
		Select @P_SProrata=''
End
else if @P_PPeriod=2
Begin
	if cast(dbo.fn_premium_calc_Prorata(@P_PSDate, @P_PEDate,0,1,@P_PPeriod) as integer)<>cast(dbo.fn_premium_calc_Prorata(@P_SDate, @P_EDate,0,1,@P_PPeriod) as integer)
		Select @P_SProrata= convert(varchar(25),dbo.fn_premium_calc_Prorata(@P_PSDate, @P_PEDate,0,1,@P_PPeriod))+'/'+convert(varchar(25),dbo.fn_premium_calc_Prorata(@P_SDate, @P_EDate,0,1,@P_PPeriod))
	else
		Select @P_SProrata=''

End
Else 
Begin
	if day(@P_PSDate)=day(@P_PEdate) and day(@P_PSDate)=day(@P_Edate) and day(@P_SDate)=day(@P_Edate) and @P_PPeriod<>1 and datediff(month,@P_Sdate,@P_Edate)<>0
	Begin
		if datediff(month,@P_PSDate, @P_PEDate)<>datediff(month,@P_SDate, @P_EDate)
			Select @P_SProrata= convert(varchar(25),datediff(month,@P_PSDate, @P_PEDate))+'/'+convert(varchar(25),datediff(month,@P_SDate, @P_EDate))
		else
			Select @P_SProrata=''
	End
	else
	Begin
		if datediff(day,@P_PSDate, @P_PEDate)<>datediff(day,@P_SDate, @P_EDate)
			Select @P_SProrata= convert(varchar(25),datediff(day,@P_PSDate, @P_PEDate))+'/'+convert(varchar(25),datediff(day,@P_SDate, @P_EDate))
		else
			Select @P_SProrata=''
	End
End

Return @P_SProrata

END  
GO

DROP FUNCTION RoundCCY
GO
CREATE FUNCTION RoundCCY(@P_Nominal as Float, @P_CCY as varchar(10))              
RETURNS Float
AS               
BEGIN              
Declare @P_Decimal as int


if @P_CCY='IDR' or @P_CCY='JPY' or @P_CCY='ITL' or @P_CCY='TWD'
	Select @P_Decimal=0
ELSE
	Select @P_Decimal=2

Select @P_Decimal=Power(10,@P_Decimal)

return round(@P_Nominal*@P_Decimal,0)/@P_Decimal
END  



GO



GO
DROP FUNCTION fn_Get_TreatyDue
GO
CREATE FUNCTION fn_Get_TreatyDue(@RDate as SmallDateTime, @PStatement as Integer, @PDate as SmallDatetime)              
RETURNS SmallDatetime
AS               
BEGIN              
Declare @PMonth as integer
Declare @Period as integer

Select @PMonth=datediff(Month, @RDate, @PDate)

Select @Period=@PMonth / @PStatement + 1

 return(dateadd(month,@Period*@PStatement, @RDate)-1)
END         
GO
DROP Function get_objectInfo
GO
CREATE Function get_objectInfo(@P_ANO int)          
RETURNS varchar(2048) as
  
BEGIN       
Declare @ObjInfo varchar(2048)

Select
@ObjInfo=
cast(
Case When A1.ValueDesc<>'' Then A1.ValueDesc else '' end
+' ('+
+Case When T.IACCREG & POWER(2,1)<>POWER(2,1) and A2.FLDID1<>'' Then T.FLDTAG1+' : '+Case When A2.VALUEID1<>'' Then A2.VALUEID1+'-'+cast(A2.VALUEDESC1 as varchar(100)) ELSE cast(A2.VALUEDESC1 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,2)<>POWER(2,2) and A2.FLDID2<>'' Then T.FLDTAG2+' : '+Case When A2.VALUEID2<>'' Then A2.VALUEID2+'-'+cast(A2.VALUEDESC2 as varchar(100)) ELSE cast(A2.VALUEDESC2 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,3)<>POWER(2,3) and A2.FLDID3<>'' Then T.FLDTAG3+' : '+Case When A2.VALUEID3<>'' Then A2.VALUEID3+'-'+cast(A2.VALUEDESC3 as varchar(100)) ELSE cast(A2.VALUEDESC3 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,4)<>POWER(2,4) and A2.FLDID4<>'' Then T.FLDTAG4+' : '+Case When A2.VALUEID4<>'' Then A2.VALUEID4+'-'+cast(A2.VALUEDESC4 as varchar(100)) ELSE cast(A2.VALUEDESC4 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,5)<>POWER(2,5) and A2.FLDID5<>'' Then T.FLDTAG5+' : '+Case When A2.VALUEID5<>'' Then A2.VALUEID5+'-'+cast(A2.VALUEDESC5 as varchar(100)) ELSE cast(A2.VALUEDESC5 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,6)<>POWER(2,6) and A2.FLDID6<>'' Then T.FLDTAG6+' : '+Case When A2.VALUEID6<>'' Then A2.VALUEID6+'-'+cast(A2.VALUEDESC6 as varchar(100)) ELSE cast(A2.VALUEDESC6 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,7)<>POWER(2,7) and A2.FLDID7<>'' Then T.FLDTAG7+' : '+Case When A2.VALUEID7<>'' Then A2.VALUEID7+'-'+cast(A2.VALUEDESC7 as varchar(100)) ELSE cast(A2.VALUEDESC7 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,8)<>POWER(2,8) and A2.FLDID8<>'' Then T.FLDTAG8+' : '+Case When A2.VALUEID8<>'' Then A2.VALUEID8+'-'+cast(A2.VALUEDESC8 as varchar(100)) ELSE cast(A2.VALUEDESC8 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,9)<>POWER(2,9) and A2.FLDID9<>'' Then T.FLDTAG9+' : '+Case When A2.VALUEID9<>'' Then A2.VALUEID9+'-'+cast(A2.VALUEDESC9 as varchar(100)) ELSE cast(A2.VALUEDESC9 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,10)<>POWER(2,10) and A2.FLDID10<>'' Then T.FLDTAG10+' : '+Case When A2.VALUEID10<>'' Then A2.VALUEID10+'-'+cast(A2.VALUEDESC10 as varchar(100)) ELSE cast(A2.VALUEDESC10 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,11)<>POWER(2,11) and A2.FLDID11<>'' Then T.FLDTAG11+' : '+Case When A2.VALUEID11<>'' Then A2.VALUEID11+'-'+cast(A2.VALUEDESC11 as varchar(100)) ELSE cast(A2.VALUEDESC11 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,12)<>POWER(2,12) and A2.FLDID12<>'' Then T.FLDTAG12+' : '+Case When A2.VALUEID12<>'' Then A2.VALUEID12+'-'+cast(A2.VALUEDESC12 as varchar(100)) ELSE cast(A2.VALUEDESC12 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,13)<>POWER(2,13) and A2.FLDID13<>'' Then T.FLDTAG13+' : '+Case When A2.VALUEID13<>'' Then A2.VALUEID13+'-'+cast(A2.VALUEDESC13 as varchar(100)) ELSE cast(A2.VALUEDESC13 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,14)<>POWER(2,14) and A2.FLDID14<>'' Then T.FLDTAG14+' : '+Case When A2.VALUEID14<>'' Then A2.VALUEID14+'-'+cast(A2.VALUEDESC14 as varchar(100)) ELSE cast(A2.VALUEDESC14 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,15)<>POWER(2,15) and A2.FLDID15<>'' Then T.FLDTAG15+' : '+Case When A2.VALUEID15<>'' Then A2.VALUEID15+'-'+cast(A2.VALUEDESC15 as varchar(100)) ELSE cast(A2.VALUEDESC15 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+')'
as varchar(2048))
from ACCEPTANCE A1
Inner Join AINFO A2 on (A2.ANO=A1.ANO)
Inner Join TOC T on (T.TOC=A1.TOC)
Where A1.ANO=@P_ANO 

return @ObjInfo
  
END    


GO

DROP Function Get_Sub_Branch
GO
CREATE Function Get_Sub_Branch(@Parent varchar(10))          
RETURNS varchar(1024) AS        
  
BEGIN       

Return '/'+dbo.Get_Sub_Branch_Detail(@Parent)+'/'
END   


GO


DROP Function Get_Sub_Branch_Detail
GO
CREATE Function Get_Sub_Branch_Detail(@Parent varchar(10))          
RETURNS varchar(1024) AS        
  
BEGIN       

Declare @Branch as varchar(1024)
Declare @SubBranch as varchar(1024)
Declare @OP_Flag as bit

Select @Branch=@Parent

Declare Branch_Cursor Cursor For Select Branch, Op_Flag from Branch Where Parent=@Branch
Open Branch_Cursor
FETCH FROM Branch_Cursor into @SubBranch, @OP_Flag
WHILE @@FETCH_STATUS = 0  
BEGIN  
	if @Op_FLag=0 
	Begin
		Select @SubBranch=dbo.Get_Sub_Branch_Detail(@SubBranch)
	end

	if @Branch=''
		Select @Branch=@Subbranch	
	else
		Select @Branch=@Branch+'/'+@Subbranch
	FETCH FROM Branch_Cursor into @SubBranch, @OP_Flag
End  
Close Branch_Cursor
Deallocate Branch_Cursor
Return @Branch
END   



GO

DROP Function get_FacCoinsuranceShare
GO
CREATE Function get_FacCoinsuranceShare(@P_CNO integer)          
RETURNS Float AS        
  
BEGIN       
Declare @Share as Float
Select @Share=sum(Share)
from
(
	SELECT Distinct RArrDet.FID, 
	(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*100*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare) end) as Share
	From Claim
	Inner join CArrHeader on (CArrHeader.CNO=Claim.CNO)
	Inner Join Acceptance on (Acceptance.CNO=Claim.ANO)
	Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
	Inner Join RArrDet on (RArrDet.ANO=Acceptance.ANO)
	Inner Join FPart on (FPart.ANO=RArrDet.ANO AND FPart.FID=RArrDet.FID)
	Inner Join Profile on (Profile.ID=FPart.ID)
	
	WHERE Claim.CNO=@P_CNO 
	AND ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=CLAIM.LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
	AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>CLAIM.LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                              
	AND RArrDet.FullCoverF=1               
	AND (FPart.Code='' or EXISTS (Select RateCov.Code from RateCov INNER JOIN COL ON (COL.TOR=RateCov.TOR and COL.COL=CLAIM.COL) Where RateCov.Code=FPart.Code ))                    
	AND RArrDet.Status='A' and RArrDet.RType in ('CF','JP')          
                          
	Union All                    
                          
	SELECT Distinct RArrDet.FID, 
	(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*100*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare) end)*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS WHEN CCALC.INDEMNITY<>0 THEN LCALC.INDEMNITY/CCALC.INDEMNITY ELSE 0 END) as Share
	From Claim
	Inner join CArrHeader on (CArrHeader.CNO=Claim.CNO)
	Inner Join Acceptance on (Acceptance.CNO=Claim.ANO)
	Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
	Inner Join RArrDet on (RArrDet.ANO=Acceptance.ANO)
	Inner Join FPart on (FPart.ANO=RArrDet.ANO AND FPart.FID=RArrDet.FID)
	Inner Join FPartDet on (FPartDet.ANO=FPart.ANO AND FPartDet.FID=FPart.FID AND FPartDet.ID=FPart.ID)
	Inner Join Profile on (Profile.ID=FPart.ID)
	Inner Join (
		SELECT L.CNO, L.TOR, SUM((L.LOSS-L.EDEDUCTIBLE-L.ESALVAGE)*C.RATE) AS LOSS, SUM((L.INDEMNITY-L.DEDUCTIBLE-L.SALVAGE)*C.RATE) AS INDEMNITY
		FROM CCALC C 
		INNER JOIN LCALC L ON (L.CNO=C.CNO and L.CURRENCY=C.CURRENCY)
		WHERE C.CNO=@P_CNO
		GROUP BY L.CNO, L.TOR
	) LCALC on (LCALC.CNO=CLAIM.CNO)
	INNER JOIN COL ON (COL.COL=CLAIM.COL AND COL.TOR=LCALC.TOR)
	Inner Join (
		SELECT C.CNO, SUM((C.LOSS-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS LOSS, SUM((C.CLAIM-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS INDEMNITY
		FROM CCALC C
		WHERE C.CNO=@P_CNO
		GROUP BY C.CNO
	) CCALC ON (CCALC.CNO=LCALC.CNO)

	WHERE Claim.CNO=@P_CNO 	
	AND ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=CLAIM.LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
	AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>CLAIM.LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                              
	AND RArrDet.FullCoverF=0                    
	AND EXISTS (Select RateCov.Code from RateCov Where RateCov.Code=FPartDet.Code AND RateCov.TOR=LCALC.TOR)                    
	AND RArrDet.Status='A' and RArrDet.RType in ('CF','JP')
) R

Return @Share
End



GO
DROP Function FN_Get_SQL_TOC
GO
CREATE Function FN_Get_SQL_TOC(@P_TOC as varchar(50))   
RETURNS @TOC TABLE (SQL varchar(1024))   
AS   
BEGIN   
   
Declare @SQL as varchar(1024)   
Declare @P_FLDTAG1 as varchar(50)   
Declare @P_FLDTAG2 as varchar(50)   
Declare @P_FLDTAG3 as varchar(50)   
Declare @P_FLDTAG4 as varchar(50)   
Declare @P_FLDTAG5 as varchar(50)   
Declare @P_FLDTAG6 as varchar(50)   
Declare @P_FLDTAG7 as varchar(50)   
Declare @P_FLDTAG8 as varchar(50)   
Declare @P_FLDTAG9 as varchar(50)   
Declare @P_FLDTAG10 as varchar(50)   
Declare @P_FLDTAG11 as varchar(50)   
Declare @P_FLDTAG12 as varchar(50)   
Declare @P_FLDTAG13 as varchar(50)   
Declare @P_FLDTAG14 as varchar(50)   
Declare @P_FLDTAG15 as varchar(50)   
     
Declare TOC_Cursor cursor for   
Select FLDTAG1, FLDTAG2, FLDTAG3, FLDTAG4, FLDTAG5, FLDTAG6, FLDTAG7, FLDTAG8, FLDTAG9, FLDTAG10, FLDTAG11, FLDTAG12, FLDTAG13, FLDTAG14, FLDTAG15   
from TOC Where TOC=@P_TOC   
Open TOC_Cursor   
Fetch from TOC_Cursor into @P_FLDTAG1, @P_FLDTAG2, @P_FLDTAG3, @P_FLDTAG4, @P_FLDTAG5, @P_FLDTAG6, @P_FLDTAG7, @P_FLDTAG8, @P_FLDTAG9, @P_FLDTAG10, @P_FLDTAG11, @P_FLDTAG12, @P_FLDTAG13, @P_FLDTAG14, @P_FLDTAG15   
Deallocate TOC_Cursor   
   
Select @SQL='Select AINFO.ANO'   
if @P_FLDTAG1<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID1<>'''' Then AINFO.ValueID1+'' - ''+AINFO.ValueDesc1 Else AINFO.ValueDesc1 End as ['+@P_FLDTAG1+']'   
if @P_FLDTAG2<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID2<>'''' Then AINFO.ValueID2+'' - ''+AINFO.ValueDesc2 Else AINFO.ValueDesc2 End as ['+@P_FLDTAG2+']'   
if @P_FLDTAG3<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID3<>'''' Then AINFO.ValueID3+'' - ''+AINFO.ValueDesc3 Else AINFO.ValueDesc3 End as ['+@P_FLDTAG3+']'   
if @P_FLDTAG4<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID4<>'''' Then AINFO.ValueID4+'' - ''+AINFO.ValueDesc4 Else AINFO.ValueDesc4 End as ['+@P_FLDTAG4+']'   
if @P_FLDTAG5<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID5<>'''' Then AINFO.ValueID5+'' - ''+AINFO.ValueDesc5 Else AINFO.ValueDesc5 End as ['+@P_FLDTAG5+']'   
if @P_FLDTAG6<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID6<>'''' Then AINFO.ValueID6+'' - ''+AINFO.ValueDesc6 Else AINFO.ValueDesc6 End as ['+@P_FLDTAG6+']'   
if @P_FLDTAG7<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID7<>'''' Then AINFO.ValueID7+'' - ''+AINFO.ValueDesc7 Else AINFO.ValueDesc7 End as ['+@P_FLDTAG7+']'   
if @P_FLDTAG8<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID8<>'''' Then AINFO.ValueID8+'' - ''+AINFO.ValueDesc8 Else AINFO.ValueDesc8 End as ['+@P_FLDTAG8+']'   
if @P_FLDTAG9<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID9<>'''' Then AINFO.ValueID9+'' - ''+AINFO.ValueDesc9 Else AINFO.ValueDesc9 End as ['+@P_FLDTAG9+']'   
if @P_FLDTAG10<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID10<>'''' Then AINFO.ValueID10+'' - ''+AINFO.ValueDesc10 Else AINFO.ValueDesc10 End as ['+@P_FLDTAG10+']'   
if @P_FLDTAG11<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID11<>'''' Then AINFO.ValueID11+'' - ''+AINFO.ValueDesc11 Else AINFO.ValueDesc11 End as ['+@P_FLDTAG11+']'   
if @P_FLDTAG12<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID12<>'''' Then AINFO.ValueID12+'' - ''+AINFO.ValueDesc12 Else AINFO.ValueDesc12 End as ['+@P_FLDTAG12+']'   
if @P_FLDTAG13<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID13<>'''' Then AINFO.ValueID13+'' - ''+AINFO.ValueDesc13 Else AINFO.ValueDesc13 End as ['+@P_FLDTAG13+']'   
if @P_FLDTAG14<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID14<>'''' Then AINFO.ValueID14+'' - ''+AINFO.ValueDesc14 Else AINFO.ValueDesc14 End as ['+@P_FLDTAG14+']'   
if @P_FLDTAG15<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID15<>'''' Then AINFO.ValueID15+'' - ''+AINFO.ValueDesc15 Else AINFO.ValueDesc15 End as ['+@P_FLDTAG15+']'   
   
Select @Sql = @SQL + ' from AINFO '   
insert into @TOC Select @SQL   
Return   
End   
   
GO
DROP function FN_POLICY_ONRISK
GO
CREATE function FN_POLICY_ONRISK(@P_AsAt as smalldatetime)          
RETURNS Table            
AS RETURN            
(          
Select Acceptance.ANO, Acceptance.OANO, Acceptance.LANO
from Acceptance, Cover
Where Cover.CNO=Acceptance.CNO 
and Acceptance.ADate<=@P_AsAt and Acceptance.PolicyNo<>'' and Acceptance.AType not in ('C','A') and Acceptance.AStatus not in ('W','T') 
and Cover.CStatus<>'C' and Acceptance.pAStatus<>'W'
and @P_AsAt between Acceptance.PDate and Acceptance.EDate
and not exists (
	Select A.PANO
	from Acceptance A, Cover C
	Where A.PANO=Acceptance.ANO and C.CNO=A.CNO 
	and A.ADate<=@P_AsAt and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
	and @P_AsAt between A.PDate and A.EDate
)
and not exists (
	Select A.RANO
	from Acceptance A, Cover C
	Where A.RANO=Acceptance.ANO and C.CNO=A.CNO 
	and A.ADate<=@P_AsAt and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
	and @P_AsAt between A.PDate and A.EDate
)
)              
        
GO    

DROP Function get_Exchange
GO
CREATE Function get_Exchange(@PDate smalldatetime,@Currency as varchar(10))          
RETURNS Float AS        
  
BEGIN       
declare @PRate as Float

Select @PRate=Case When Currency.Currency=SysTab.Currency Then 1 When Currency.Effective<=@PDate Then Currency.Rate else null end
from Currency
Inner Join SysTab on (1=1)
Where Currency.Currency=@Currency 

if @PRate is null
Begin
	Select @PRate=E1.Rate
	from Currency
	Inner Join Exchange E1 on (E1.Currency=Currency.Currency and E1.Effective<=@PDate)
	Where Currency.Currency=@Currency and Currency.Effective>@PDate
	and E1.Effective=coalesce((Select Top 1 E2.Effective from Exchange E2 Where E2.Currency=E1.Currency and E2.Effective<=@PDate Order By E2.Effective Desc),'01/01/1900') 
End

if @PRate is null
	Select @PRate=1

return @PRate  
END        




GO
DROP FUNCTION fn_Voucher_AmountWPCDue 
GO
Create FUNCTION fn_Voucher_AmountWPCDue (@P_Voucher as varchar(20), @P_Date as smalldatetime)    
RETURNS Float    
AS     
BEGIN    
Declare @AmountDue as Float  
Select  
@AmountDue=  
(Case When V.Installment=0 and dateadd(day,A.WPC,V.DueDate) <=@P_Date Then V.Nominal_CC-V.Diff_CC else 0 end+    
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date Then V.AmountDue_1 else 0 end+    
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date Then V.AmountDue_2 else 0 end+    
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date Then V.AmountDue_3 else 0 end+    
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date Then V.AmountDue_4 else 0 end+    
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date Then V.AmountDue_5 else 0 end+    
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date Then V.AmountDue_6 else 0 end+    
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date Then V.AmountDue_7 else 0 end+    
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date Then V.AmountDue_8 else 0 end+    
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date Then V.AmountDue_9 else 0 end+    
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date Then V.AmountDue_10 else 0 end+    
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date Then V.AmountDue_11 else 0 end+    
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date Then V.AmountDue_12 else 0 end+  
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date Then V.AmountDue_13 else 0 end+    
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date Then V.AmountDue_14 else 0 end+    
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date Then V.AmountDue_15 else 0 end+    
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date Then V.AmountDue_16 else 0 end+    
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date Then V.AmountDue_17 else 0 end+    
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date Then V.AmountDue_18 else 0 end+    
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date Then V.AmountDue_19 else 0 end+    
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date Then V.AmountDue_20 else 0 end+    
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date Then V.AmountDue_21 else 0 end+    
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date Then V.AmountDue_22 else 0 end+    
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date Then V.AmountDue_23 else 0 end+    
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date Then V.AmountDue_24 else 0 end)
from nVoucher V
Inner Join Admlink A on (A.Voucher=V.Voucher)
where V.Voucher=@P_Voucher  
return(@AmountDue)  
END    


GO
DROP FUNCTION fn_Get_Age
GO
CREATE FUNCTION fn_Get_Age (@P_ValueDate as varchar(50), @P_CurrDate as smalldatetime)                
RETURNS Integer
AS                 
BEGIN      
 Declare @P_Year as integer        
 Declare @P_Age as integer
 Declare @P_Date as smalldatetime
 
 Select @P_Date=Case When isdate(@P_ValueDate)=1 then cast(@P_ValueDate as SmallDatetime) When isnumeric(@P_ValueDate)=1 then '01/01/'+cast(cast(@P_ValueDate as integer) as varchar(4)) else @P_CurrDate end
 Select @P_Age=round((Year(@P_CurrDate)*12+Month(@P_CurrDate)-Year(@P_Date)*12-Month(@P_Date))/12,0)
 
 return(@P_Age)                
END   

GO

Drop Function fn_ShareTreatyOnFacultative
GO

Create Function fn_ShareTreatyOnFacultative(@P_ANO as int, @P_Type as varchar(2))    
RETURNS Float
AS    
BEGIN    
	Declare @Share as Float

	Select @Share=coalesce(Sum(RArrDet.Share),0)
	From RArrDet
	WHERE RArrDet.Status='A' and RArrDet.ANO=@P_ANO and RArrDet.RType=@P_Type
 Return (@Share)    
End  

GO
DROP Function fn_Risk_Coverage_Description
GO
Create Function fn_Risk_Coverage_Description(@P_ANO as int, @P_Category as varchar(1))    
RETURNS VarChar(1024)    
AS    
BEGIN    
 Declare @Remarks as varchar(1024)    
 Declare @Remark as varchar(1024)   
 Declare @Rate  as varchar(1024)  
 Declare @Unit as varchar(1024)  
      
 Select @Remarks=''    
 DECLARE RCover_Cursor CURSOR FOR    
 Select Distinct cast(R2.Description as varchar(1024)) as Remark
 from RCover R1
 Inner Join RateTab R2 on (R2.Code=R1.Code) 
 Where R1.ANO=@P_ANO and R1.Category Like @P_Category+'%'
 OPEN RCover_Cursor    
 FETCH FROM RCover_Cursor into @Remark
 WHILE @@FETCH_STATUS = 0    
 BEGIN    
    if @Remarks=''    
    BEGIN    
	 Select @Remarks=@Remark
    End    
     Else    
    BEGIN    
     Select @Remarks=substring(@Remarks+'+'+@Remark,1,1024)    
    End    
    FETCH NEXT FROM RCover_Cursor into @Remark
 End    
 Close RCover_Cursor    
 Deallocate RCover_Cursor    
 Return (@Remarks)    
End    
  

  
GO  
DROP function fn_ObjectInfo
GO
Create function fn_ObjectInfo(@P_ANO as int, @P_FLDID as varchar(10))  
RETURNS varchar(255)                  
AS                   
BEGIN        
 Declare @Description as varchar(255)    

 Select 
 @Description=
 Case
 When A.FLDID1=@P_FLDID then A.ValueDesc1
 When A.FLDID2=@P_FLDID then A.ValueDesc2
 When A.FLDID3=@P_FLDID then A.ValueDesc3
 When A.FLDID4=@P_FLDID then A.ValueDesc4
 When A.FLDID5=@P_FLDID then A.ValueDesc5
 When A.FLDID6=@P_FLDID then A.ValueDesc6
 When A.FLDID7=@P_FLDID then A.ValueDesc7
 When A.FLDID8=@P_FLDID then A.ValueDesc8
 When A.FLDID9=@P_FLDID then A.ValueDesc9
 When A.FLDID10=@P_FLDID then A.ValueDesc10
 When A.FLDID11=@P_FLDID then A.ValueDesc11
 When A.FLDID12=@P_FLDID then A.ValueDesc12
 When A.FLDID13=@P_FLDID then A.ValueDesc13
 When A.FLDID14=@P_FLDID then A.ValueDesc14
 When A.FLDID15=@P_FLDID then A.ValueDesc15
 else	''
 End
 from AINFO A
 Where A.ANO=@P_ANO
         
 Return (@Description)    
END                  
             
GO

DROP function fn_objectInfo_Code
GO
Create function fn_objectInfo_Code(@P_ANO as int, @P_FLDID as varchar(10))  
RETURNS varchar(255)                  
AS                   
BEGIN        
 Declare @Description as varchar(255)    

 Select 
 @Description=
 Case
 When A.FLDID1=@P_FLDID then A.ValueID1
 When A.FLDID2=@P_FLDID then A.ValueID2
 When A.FLDID3=@P_FLDID then A.ValueID3
 When A.FLDID4=@P_FLDID then A.ValueID4
 When A.FLDID5=@P_FLDID then A.ValueID5
 When A.FLDID6=@P_FLDID then A.ValueID6
 When A.FLDID7=@P_FLDID then A.ValueID7
 When A.FLDID8=@P_FLDID then A.ValueID8
 When A.FLDID9=@P_FLDID then A.ValueID9
 When A.FLDID10=@P_FLDID then A.ValueID10
 When A.FLDID11=@P_FLDID then A.ValueID11
 When A.FLDID12=@P_FLDID then A.ValueID12
 When A.FLDID13=@P_FLDID then A.ValueID13
 When A.FLDID14=@P_FLDID then A.ValueID14
 When A.FLDID15=@P_FLDID then A.ValueID15
 else	''
 End
 from AINFO A
 Where A.ANO=@P_ANO
         
 Return (@Description)    
END                  
			 
GO
DROP FUNCTION fn_Get_UWYear 
GO
CREATE FUNCTION fn_Get_UWYear (@P_SDate as DateTime, @P_EDate as DateTime, @P_PDate as DateTime)              
RETURNS Integer            
AS               
BEGIN              
 Declare @P_UWYear as integer            
 Declare @P_PolicyYear as integer            
 if datediff(day, @P_PDate, @P_EDate)<0             
 begin            
 Select @P_PDate=@P_Edate            
 end            
 if datediff(day, @P_PDate, @P_Sdate)>0             
 begin            
 Select @P_PDate=@P_SDate            
 end            
            
 Select @P_PolicyYear = datediff(year,@P_Sdate, @P_PDate)            
 if datediff(day,dateadd(year,@P_PolicyYear, @P_SDate),@P_PDate)<0            
 begin            
 Select @P_PolicyYear=@P_PolicyYear-1            
 end            
           
 if datediff(year,@P_SDate, @P_EDate)-1<@P_PolicyYear and @P_PolicyYear>1          
 begin          
 Select @P_PolicyYear=datediff(year,@P_Sdate,@P_EDate)-1          
 end          
           
 Select @P_UWYear=year(@P_Sdate)+@P_PolicyYear              
            
 return(@P_UWYear)              
END         
        
        
GO
  
Drop function fn_reportyear
GO
Create function fn_reportyear(@P_StartYear as int, @P_EndYear as int)
RETURNS @TReportYear TABLE (PYEAR int)
AS    
BEGIN 
	Declare @PYear as int
	Select @PYear=@P_StartYear
	WHILE (@PYear<=@P_EndYear)
	BEGIN
	   insert into @TReportYear Select @PYear
	   Select @PYear=@PYear+1
	END

Return
end
GO

DROP FUNCTION fn_Get_PolicySDate 

GO

CREATE FUNCTION fn_Get_PolicySDate (@P_PDate as DateTime, @P_SDate as DateTime, @P_EDate as DateTime, @P_UWYear as int)                
RETURNS DateTime  
AS                 
BEGIN              
 Declare @P_PolicyDate as DateTime  
 if month(@P_PDate)=2 and day(@P_PDate)=29 and (@P_UWYear % 4)<>0 --Leap Year  
 begin            
  Select @P_PolicyDate = cast(@P_UWYear as varchar(4))+'/'+cast(month(@P_PDate) as varchar(2))+'/'+cast(day(@P_PDate-1) as varchar(2))  
 end  
 else  
 begin  
   Select @P_PolicyDate = cast(@P_UWYear as varchar(4))+'/'+cast(month(@P_PDate) as varchar(2))+'/'+cast(day(@P_PDate) as varchar(2))  
 end  
 if datediff(day, @P_EDate, @P_PolicyDate)>0               
 begin              
 Select @P_PolicyDate=@P_EDate              
 end    
 if datediff(day, @P_SDate, @P_PolicyDate)<0
 begin              
 Select @P_PolicyDate=@P_SDate
 end    

 return(@P_PolicyDate)                
END           
     
GO     
DROP FUNCTION fn_Get_PolicyEDate 
GO
CREATE FUNCTION fn_Get_PolicyEDate (@P_PDate as DateTime, @P_SDate as DateTime, @P_EDate as DateTime, @P_UWYear as int)                
RETURNS DateTime  
AS                 
BEGIN              
 Declare @P_PolicyDate as DateTime  
 Select @P_PolicyDate = dbo.fn_Get_PolicySDate(@P_PDate,@P_Sdate,@P_EDate,@P_UWYear+1)  
 return(@P_PolicyDate)                
END           
  
GO

DROP FUNCTION fn_Get_ExtPeriodDate

GO

CREATE FUNCTION fn_Get_ExtPeriodDate (@P_ExtPeriod as int, @P_ExtPeriodInDaysF as bit, @P_PDate as smalldatetime)                
RETURNS Smalldatetime  
AS                 
BEGIN              
 Declare @P_ExtPeriodDate as Smalldatetime  
 if @P_ExtPeriodInDaysF=0
 begin            
  Select @P_ExtPeriodDate = dateadd(month, @P_ExtPeriod, @P_PDate)
 end  
 else  
 begin  
   Select @P_ExtPeriodDate = dateadd(Day, @P_ExtPeriod, @P_PDate)
 end  

 return(@P_ExtPeriodDate)                
END           
         

GO

Drop Function fn_Risk_Coverage
GO
Create Function fn_Risk_Coverage(@P_ANO as int, @P_Category as varchar(1))  
RETURNS VarChar(1024)  
AS  
BEGIN  
 Declare @Remarks as varchar(1024)  
 Declare @Remark as varchar(1024) 
 Declare @Rate  as varchar(1024)
 Declare @Unit as varchar(1024)
    
 Select @Remarks=''  
 DECLARE RCover_Cursor CURSOR FOR  
 Select Distinct cast(Remark as varchar(1024)) as Remark, convert(varchar(25),cast(Rate as money),1) as Rate, Case When RCover.Unit='C' Then '%' When RCover.Unit='M' Then '%o' else 'Flat' end as Unit from RCover 
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

DROP Function fn_Risk_Coverage_Detail
GO
Create Function fn_Risk_Coverage_Detail(@P_ANO as int, @P_Category as varchar(1)) 
RETURNS VarChar(1024)    
AS    
BEGIN    
 Declare @Remarks as varchar(1024)    
 Declare @Remark as varchar(1024)   
 Declare @Rate  as varchar(1024)  
 Declare @Unit as varchar(1024) 
 DECLARE @NewLineChar AS CHAR(2) = CHAR(13) + CHAR(10)
 Select @Remarks=''    
 DECLARE RCover_Cursor CURSOR FOR    
 Select Distinct cast(Remark as varchar(1024)) as Remark, convert(varchar(25),cast(Rate as money),1) as Rate, Case When RCover.Unit='C' Then '%' When RCover.Unit='M' Then '%o' else 'Flat' end as Unit from RCover
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




Drop Function fn_Risk_Coverage_Premium
GO

Create Function fn_Risk_Coverage_Premium(@P_ANO as int, @P_Category as varchar(1))  
RETURNS VarChar(1024)  
AS  
BEGIN  
 Declare @Remarks as varchar(1024)  
 Declare @Code as varchar(1024)
 Declare @Remark as varchar(1024)
 Declare @Currency as varchar(1024)
 Declare @Premium as varchar(1024)
    
 Select @Remarks=''  
 DECLARE RCover_Cursor CURSOR FOR  
 Select RCover.Code, max(cast(RCover.Remark as varchar(1024))) as Remark, RCalc.Currency, convert(varchar(25),cast(sum(Gross) as money),1) as Premium 
 from RCover 
 Inner Join RCalc on (RCalc.ANO=RCover.ANO and RCalc.Code=RCover.Code and RCover.SDate=RCalc.SDate)
 Where RCover.ANO=@P_ANO and (RCover.Category=@P_Category or @P_Category='') 
 Group by RCover.Code, RCalc.Currency
 OPEN RCover_Cursor  
 FETCH FROM RCover_Cursor into @Code, @Remark, @Currency, @Premium
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
    if @Remarks=''  
    BEGIN  
  Select @Remarks=@Remark+'('+@Currency+' '+@Premium+')'
    End  
     Else  
    BEGIN  
     Select @Remarks=substring(@Remarks+'|'+@Remark+'('+@Currency+' '+@Premium+')',1,1024)  
    End  
    FETCH NEXT FROM RCover_Cursor into @Code, @Remark, @Currency, @Premium
 End  
 Close RCover_Cursor  
 Deallocate RCover_Cursor  
 Return (@Remarks)  
End  

GO

Drop Function fn_Clauses
GO
Create Function fn_Clauses(@P_ANO as int)  
RETURNS VarChar(1024)  
AS  
BEGIN  
 Declare @Remarks as varchar(1024)  
 Declare @Remark as varchar(1024)  
    
 Select @Remarks=''  
 DECLARE AccCla_Cursor CURSOR FOR  
 
 Select Distinct cast(ShortDesc as varchar(1024)) as Remark from AccCla Where ANO=@P_ANO 
 OPEN AccCla_Cursor  
 FETCH FROM AccCla_Cursor into @Remark  
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
    if @Remarks=''  
    BEGIN  
  Select @Remarks=@Remark  
    End  
     Else  
    BEGIN  
     Select @Remarks=substring(@Remarks+'|'+@Remark,1,1024)  
    End  
    FETCH NEXT FROM AccCla_Cursor into @Remark  
 End  
 Close AccCla_Cursor  
 Deallocate AccCla_Cursor  
 Return (@Remarks)  
End  


GO

DROP Function fn_Add_Interest
GO
Create Function fn_Add_Interest(@P_ANO as int, @P_Currency as varchar(10))    
RETURNS VarChar(1024)    
AS    
BEGIN    
 Declare @Remarks as varchar(1024)    
 Declare @Remark as varchar(1024)    
 Declare @Currency as varchar(1024)  
 Declare @SI as varchar(1024)  
      
 Select @Remarks=''    
 DECLARE ICover_Cursor CURSOR FOR      
  
 Select Cast(TOI.Description as varchar(1024))as Remarks, ICover.Currency, convert(varchar(25),cast(sum(ICover.SI) as money),1) as SI
 From
 (
	Select ICover.TOI, ICover.Currency, Case When Acceptance.AType<>'C' Then ICover.SI else 0 end as SI
	from Acceptance
	Inner Join ICover on (ICover.ANO=Acceptance.ANO And ICover.Currency=@P_Currency)
	WHere Acceptance.ANO=@P_ANO

	union All

	Select ICover.TOI, ICover.Currency, Case When Acceptance.AType<>'C' Then -ICover.SI else 0 end as SI
	from Acceptance
	Inner Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)
	Inner Join ICover on (ICover.ANO=pAcceptance.ANO and ICover.Currency=@P_Currency)
	WHere Acceptance.ANO=@P_ANO 
 ) ICover, TOI
 Where TOI.TOI=ICover.TOI
 Group by TOI.Description, ICover.Currency
 
 OPEN ICover_Cursor    
 FETCH FROM ICover_Cursor into @Remark, @Currency, @SI  
 WHILE @@FETCH_STATUS = 0    
 BEGIN    
    if @Remarks=''    
    BEGIN    
  Select @Remarks=@Remark+' - '+@Currency+' '+@SI+''  
    End    
     Else    
    BEGIN    
     Select @Remarks=substring(@Remarks+'|'+@Remark+' - '+@Currency+' '+@SI+'',1,1024)    
    End    
    FETCH NEXT FROM ICover_Cursor into @Remark, @Currency, @SI  
 End    
 Close ICover_Cursor    
 Deallocate ICover_Cursor    
 Return (@Remarks)    
End 

GO
Drop Function fn_Interest
GO
Create Function fn_Interest(@P_ANO as int, @P_Category as varchar(1))  
RETURNS VarChar(1024)  
AS  
BEGIN  
 Declare @Remarks as varchar(1024)  
 Declare @Remark as varchar(1024)  
 Declare @Currency as varchar(1024)
 Declare @SI as varchar(1024)
    
 Select @Remarks=''  
 DECLARE ICover_Cursor CURSOR FOR  

 Select Remark, Currency, SI
 from 
 (
	 Select 0 as OrderNo, cast(Remark as varchar(1024)) as Remark, Currency, convert(varchar(25),cast(SI as money),1) as SI from ICover 
	 Where SI<>0 and ANO=@P_ANO and (Category=@P_Category or @P_Category='')  
	 Union All
	 Select 1 as OrderNo, 'T o t a l' as Remark, Currency, convert(varchar(25),cast(sum(SI) as money),1) as SI from ICover 
	 Where SI<>0 and ANO=@P_ANO and (Category=@P_Category or @P_Category='')  
	 Group By Currency
 ) R
 Order by Currency, OrderNo
 OPEN ICover_Cursor  
 FETCH FROM ICover_Cursor into @Remark, @Currency, @SI
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
    if @Remarks=''  
    BEGIN  
  Select @Remarks=@Remark+' - '+@Currency+' '+@SI+''
    End  
     Else  
    BEGIN  
     Select @Remarks=substring(@Remarks+'|'+@Remark+' - '+@Currency+' '+@SI+'',1,1024)  
    End  
    FETCH NEXT FROM ICover_Cursor into @Remark, @Currency, @SI
 End  
 Close ICover_Cursor  
 Deallocate ICover_Cursor  
 Return (@Remarks)  
End  

GO
DROP Function fn_Deductible
GO
Create Function fn_Deductible(@P_ANO as int,@P_Category as varchar(1))  
RETURNS VarChar(1024)  
AS  
BEGIN  
 Declare @Remarks as varchar(1024)  
 Declare @Remark as varchar(1024)  
    
 Select @Remarks=''  
 DECLARE AccDed_Cursor CURSOR FOR  

 Select Distinct cast(AccDed.Remarks as varchar(1024)) as Remarks 
 from AccDed
 Inner Join RCalc on (RCalc.ANO=AccDed.ANO and RCalc.TOR=AccDed.TOR)
 Inner Join RCover on (RCover.ANO=RCalc.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)
 Where AccDed.ANO=@P_ANO and RCover.Category Like @P_Category+'%'

 OPEN AccDed_CURSOR  
 FETCH FROM AccDed_CURSOR into @Remark  
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
    if @Remarks=''  
    BEGIN  
  Select @Remarks=@Remark  
    End  
     Else  
    BEGIN  
     Select @Remarks=substring(@Remarks+'|'+@Remark,1,1024)  
    End  
    FETCH NEXT FROM AccDed_CURSOR into @Remark  
 End  
 Close AccDed_CURSOR  
 Deallocate AccDed_CURSOR  
 Return (@Remarks)  
End  
    
GO

DROP function fn_GetPremiumPaid_Date
GO
Create function fn_GetPremiumPaid_Date(@P_ANO as int)
RETURNS Smalldatetime                
AS                 
BEGIN      
 Declare @PremiumPaid_Date as Smalldatetime  

 Select Top 1 @PremiumPaid_Date=Case When nVoucher.Payment_CC<>0 Then nVoucher.PDate Else Null End
 from Acceptance
 Inner Join AccAss on (AccAss.ANO=Acceptance.ANO and AccAss.Type in ('DI','IC','IR','IT','IX') and AccAss.Code='P')
 Inner Join Admlink on (Admlink.AdmNo=AccAss.AdmNo)
 Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)
 Where Acceptance.ANO=@P_ANO 

Return (@PremiumPaid_Date)  

END                
GO

DROP Function fn_Intermediaries
GO
Create Function fn_Intermediaries(@P_ANO as int)
RETURNS VarChar(1024)  
AS  
BEGIN  
 Declare @Remarks as varchar(1024)  
 
 Declare @Name as varchar(1024)
Declare @Fee as varchar(1024)
Declare @Remark as varchar(1024) 
 Declare @FeeDet as varchar(1024)
  
    
 Select @Remarks=''  
 DECLARE AccBS_Cursor CURSOR FOR  

Select Distinct Profile.Name, convert(varchar(20), cast(AccBS.Fee as float),0)+'%' as Fee, Convert(varchar(1024), coalesce(RCover.Remark,'')) as Remark, convert(varchar(20), cast(coalesce(AccBSDet.Fee,0) as float),0)+'%' as FeeDet
from Acceptance
Inner Join AccBS on (AccBS.ANO=Acceptance.ANO or AccBS.ANO=Acceptance.LANO)
left Join AccBSDet on (AccBSDet.ANO=AccBS.ANO and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType) Left Join RCover on (RCover.ANO=AccBSDet.ANO and RCover.Code=AccBSDet.Code )
Inner Join Profile on (Profile.ID=AccBS.ID)
Where Acceptance.ANO=@P_ANO

OPEN AccBS_Cursor  
 FETCH FROM AccBS_Cursor into @Name, @Fee, @Remark, @FeeDet
WHILE @@FETCH_STATUS = 0  
 BEGIN  
    if @Remarks=''  
    BEGIN  
     if @Remark=''
     Begin
       Select @Remarks=@Name+'('+@Fee+')'
     End
     Else
     Begin
       Select @Remarks=@Name+'-'+@Remark+'('+@FeeDet+')'
     End
    End  
    Else  
    Begin
     if @Remark=''
     Begin
       Select @Remarks=substring(@Remarks+'|'+@Name+'('+@Fee+')',1,1024)  
     End
     Else
     Begin
       Select @Remarks=substring(@Remarks+'|'+@Name+'-'+@Remark+'('+@FeeDet+')',1,1024)  
     End
    End
    FETCH NEXT FROM AccBS_Cursor into @Name, @Fee, @Remark, @FeeDet
End  
 Close AccBS_Cursor  
 Deallocate AccBS_Cursor  
 Return (@Remarks)  
End  

GO

Drop Function fn_facultative
GO 

Create Function fn_facultative(@P_ANO as int)
RETURNS VarChar(1024)  
AS  
BEGIN  
 Declare @Remarks as varchar(1024)  
 Declare @Name as varchar(1024)  
 Declare @Share as varchar(1024)
    
 Select @Remarks=''  
 DECLARE Facultative_Cursor CURSOR FOR  
 Select cast(Profile.Name as varchar(1024)) as Name, Convert(varchar(1024), cast(RArrDet.Share as Money),1) as Share
 from RArrDet
 Inner Join FPart on (FPart.FID=RArrDet.FID and FPart.ANO=RArrDet.ANO)
 Inner Join Profile on (Profile.ID=FPart.ID)
 Where RArrDet.ANO=@P_ANO and RArrDet.Status<>'O'

 OPEN Facultative_Cursor  
 FETCH FROM Facultative_Cursor into @Name, @Share  
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
    if @Remarks=''  
    BEGIN  
  Select @Remarks=@Name+'('+@Share+'%'+')'
    End  
     Else  
    BEGIN  
     Select @Remarks=substring(@Remarks+'|'+@Name+'('+@Share+'%'+')',1,1024)  
    End  
    FETCH NEXT FROM Facultative_Cursor into @Name, @Share   
 End  
 Close Facultative_Cursor  
 Deallocate Facultative_Cursor  
 Return (@Remarks)  
End 

GO

Drop Function fn_Claim_Nature_Of_Loss
GO
Create Function fn_Claim_Nature_Of_Loss(@P_CNO as int, @P_Category as varchar(1))  
RETURNS VarChar(1024)  
AS  
BEGIN  
 Declare @Remarks as varchar(1024)  
 Declare @Remark as varchar(1024) 
    
 Select @Remarks=''  
 DECLARE CLLOSS_Cursor CURSOR FOR  
 Select Distinct cast(NOCTAB.Description+'('+NOCTAB.NOC+')' as varchar(1024)) AS Remark 
 from CLLoss
 Inner Join ICover on (ICover.INO=CLLOSS.INO)
 Inner Join NOCTAB on (NOCTAB.NOC=CLLOSS.NOC)
 Where CLLOSS.CNO=@P_CNO and (ICover.Category=@P_Category or @P_Category='')  
 OPEN CLLOSS_Cursor 
 FETCH FROM CLLOSS_Cursor into @Remark
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
    if @Remarks=''  
    BEGIN  
  Select @Remarks=@Remark
    End  
     Else  
    BEGIN  
     Select @Remarks=substring(@Remarks+'|'+@Remark,1,1024)  
    End  
    FETCH NEXT FROM CLLOSS_Cursor into @Remark
 End  
 Close CLLOSS_Cursor  
 Deallocate CLLOSS_Cursor  
 Return (@Remarks)  
End 

GO
DROP FUNCTION FN_Claim_UWYear

GO
CREATE FUNCTION FN_Claim_UWYear (@P_SDate as DateTime, @P_EDate as DateTime, @P_LossDate as DateTime)          
RETURNS Integer        
AS           
BEGIN          
 Declare @P_UWYear as integer        
 Declare @P_PolicyYear as integer        
 if datediff(day, @P_LossDate, @P_EDate)<0         
 begin        
 Select @P_LossDate=@P_Edate        
 end        
 if datediff(day, @P_LossDate, @P_Sdate)>0         
 begin        
 Select @P_LossDate=@P_SDate        
 end        
        
 Select @P_PolicyYear = datediff(year,@P_Sdate, @P_LossDate)        
 if datediff(day,dateadd(year,@P_PolicyYear, @P_SDate),@P_LossDate)<0        
 begin        
 Select @P_PolicyYear=@P_PolicyYear-1        
 end        
       
 if datediff(year,@P_SDate, @P_EDate)-1<@P_PolicyYear       
 begin      
 Select @P_PolicyYear=datediff(year,@P_Sdate,@P_EDate)-1      
 end      
       
 Select @P_UWYear=year(@P_Sdate)+@P_PolicyYear          
        
 return(@P_UWYear)          
END    

GO

DROP TABLE [dbo].ReportYear
GO
Select * into ReportYear from dbo.fn_reportyear(2000,2050)
GO
Create Index I_ReportYear on ReportYear(PYear)
GO

GO  
--Examples Query

-- Select PremiumInfo.*, 
-- dbo.fn_Risk_Coverage(Acceptance.ANO,'') as Risk_Coverage,
-- dbo.fn_Risk_Coverage_Premium(Acceptance.ANO,'') as Premium_Original,
-- dbo.fn_Clauses(Acceptance.ANO) as Clauses,
-- dbo.fn_Interest(Acceptance.ANO,'') as Interest,
-- dbo.fn_Deductible(Acceptance.ANO,'') as Deductible,
-- dbo.fn_Intermediaries(Acceptance.ANO) as Intermediares,
-- dbo.fn_facultative(Acceptance.ANO) as Facultative
-- from
-- Acceptance, Cover, RArrHeader,
-- (Select
-- Acceptance.OANO, 
-- Max(Acceptance.ANO) as ANO,
-- sum(coalesce(PremiumInfo.Premium,0)) as Premium,
-- sum(coalesce(PremiumInfo.Discount,0)) as Discount,
-- sum(coalesce(PremiumInfo.Commission,0)) as Commission,
-- Max(coalesce(PremiumInfo.PaidInfo,0)) as PaidInfo
-- from
-- Acceptance left join 
-- (Select A1.ANO, 
-- sum(Case When A1.Code='P' then A1.Amount else 0 end*V.Rate) as Premium,
-- sum(Case When (A1.Type not in ('BB','BA') and A1.Code='O') or A1.Type in ('BO') then A1.Amount else 0 end*V.Rate) as Discount,
-- sum(Case When A1.Type in ('BB','BA') then A1.Amount else 0 end*V.Rate) as Commission,
-- Max(Case When A1.Type in ('DI','IC','IR') and round(V.Nominal_CC-V.Diff_CC-V.Payment_CC,0)=0 Then 1 else 0 end) as PaidInfo
-- from Accass A1, Admlink A2 Left Join nVoucher V on (V.Voucher=A2.Voucher)
-- Where A1.AdmNo=A2.AdmNo and A1.Type in ('DI','IC','IR','BB','BA','BO') 
-- Group By A1.ANO) PremiumInfo on (PremiumInfo.ANO=Acceptance.ANO)
-- Group By Acceptance.OANO
-- ) as PremiumInfo
-- Where Acceptance.ANO=PremiumInfo.ANO and Acceptance.CNO=Cover.CNO and RArrHeader.ANO=Acceptance.ANO





 insert into PatchVersioning
select '482 Update Script - Functions',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='482 Update Script - Functions'


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





