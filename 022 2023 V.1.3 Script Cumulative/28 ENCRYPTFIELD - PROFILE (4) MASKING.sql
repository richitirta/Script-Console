
INSERT INTO EncryptField
VALUES (CAST((SELECT TOP 1 EncryptID FROM EncryptField ORDER BY EncryptID DESC) AS int) + 1,
'PROFILEFRM', 'LblAddress', 'Address', '', 'x', 1, 0, 0, GETDATE(), 'CARE')
GO

INSERT INTO EncryptField
VALUES (CAST((SELECT TOP 1 EncryptID FROM EncryptField ORDER BY EncryptID DESC) AS int) + 1,
'PROFILEFRM', 'LblPhone1', 'PHONE_1', '', 'x', 1, 0, 0, GETDATE(), 'CARE')
GO

INSERT INTO EncryptField
VALUES (CAST((SELECT TOP 1 EncryptID FROM EncryptField ORDER BY EncryptID DESC) AS int) + 1,
'PROFILEFRM', 'LblPhone2', 'PHONE_2', '', 'x', 1, 0, 0, GETDATE(), 'CARE')
GO

INSERT INTO EncryptField
VALUES (CAST((SELECT TOP 1 EncryptID FROM EncryptField ORDER BY EncryptID DESC) AS int) + 1,
'PROFILEFRM', 'LblMPhone1', 'Mobile_1', '', 'x', 1, 0, 0, GETDATE(), 'CARE')
GO

INSERT INTO EncryptField
VALUES (CAST((SELECT TOP 1 EncryptID FROM EncryptField ORDER BY EncryptID DESC) AS int) + 1,
'PROFILEFRM', 'LblMPhone2', 'Mobile_2', '', 'x', 1, 0, 0, GETDATE(), 'CARE')
GO
