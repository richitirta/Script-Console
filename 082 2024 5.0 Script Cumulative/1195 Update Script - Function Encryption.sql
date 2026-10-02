DROP Function fn_ENCRYPTTEXT
GO
Create Function fn_ENCRYPTTEXT(@PassPhrase varchar(2000),@PlainText varchar(2000))        
RETURNS varchar(2000) AS          
BEGIN        

Declare @EncryptedText varchar(2000)

if @PassPhrase<>'' 
	Select @EncryptedText=convert(varchar(2000), ENCRYPTBYPASSPHRASE(@PassPhrase,@PlainText),1) 
else
	Select @EncryptedText=@Plaintext

return @EncryptedText
End

GO
DROP Function fn_DECRYPTTEXT
GO
Create Function fn_DECRYPTTEXT(@PassPhrase varchar(2000),@EncryptedText varchar(2000))        
RETURNS varchar(2000) AS          
BEGIN        

Declare @DecryptedText varchar(2000)

if @PassPhrase<>'' 
	Select @DecryptedText=cast(DECRYPTBYPASSPHRASE(@PassPhrase,convert(varbinary(2000), @EncryptedText,1)) as varchar(2000))
else
	Select @DecryptedText=cast(@EncryptedText as varchar(2000))
	
return @DecryptedText
End

GO

DROP Function fn_ENCRYPTDATE
GO
Create Function fn_ENCRYPTDATE(@PassPhrase varchar(2000),@PlainDate SmallDatetime)        
RETURNS varchar(2000) AS          
BEGIN        
        
Declare @EncryptedDate varchar(2000)

if @PassPhrase<>'' 
	Select @EncryptedDate=convert(varchar(2000), ENCRYPTBYPASSPHRASE(@PassPhrase,convert(varchar(10), @PlainDate,101)),1)
else
	Select @EncryptedDate=convert(varchar(10), @PlainDate,101)

return @EncryptedDate

End

GO
DROP Function fn_DECRYPTDATE
GO
Create Function fn_DECRYPTDATE(@PassPhrase varchar(2000),@EncryptedDate varchar(2000))        
RETURNS smalldatetime AS          
BEGIN        

Declare @DecryptedDate smalldatetime 

if @PassPhrase<>'' 
	Select @DecryptedDate=cast(cast(DECRYPTBYPASSPHRASE(@PassPhrase,convert(varbinary(2000), @EncryptedDate,1)) as varchar(2000)) as smalldatetime)
else
	Select @DecryptedDate=cast(@EncryptedDate as smalldatetime)

Return @DecryptedDate

End

GO

--Samples
--Declare @EncryptedString varchar(2000)
--Declare @PassPhrase varchar(2000)

--Select @PassPhrase='Learning Encryption !'
--Select @EncryptedString=dbo.fn_ENCRYPTTEXT(@PassPhrase,'ABC')

--Select @EncryptedString

--Select dbo.fn_DECRYPTTEXT(@PassPhrase,@EncryptedString) 

--Declare @BirthDate as smalldatetime
--Select @BirthDate='12/31/2017'

--Select @EncryptedString=dbo.fn_ENCRYPTDATE(@PassPhrase,@BirthDate)

--Select dbo.fn_DECRYPTDATE(@PassPhrase,@EncryptedString) 



  insert into PatchVersioning
select '1195 Update Script - Function Encryption',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1195 Update Script - Function Encryption'


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