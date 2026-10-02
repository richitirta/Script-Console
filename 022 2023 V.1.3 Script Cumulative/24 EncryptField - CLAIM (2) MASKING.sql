
BEGIN TRAN
go

DELETE FROM EncryptField WHERE FormName='CLAdmDlg' and ControlName in ('TxtBankID','TxtBankName')
GO

INSERT INTO EncryptField
VALUES (CAST((SELECT TOP 1 EncryptID FROM EncryptField ORDER BY EncryptID DESC) AS int) + 1,
'CLAdmDlg', 'TxtAccNo', 'AccountNo', '', '*', 1, 0, 0, GETDATE(), 'CARE')
GO

COMMIT

SELECT *  FROM EncryptField WHERE FormName='CLAdmDlg'

--DELETE FROM EncryptField WHERE ENCRYPTID = '40'

