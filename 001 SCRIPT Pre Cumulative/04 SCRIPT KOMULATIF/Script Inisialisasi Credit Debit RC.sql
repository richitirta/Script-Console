UPDATE pJournal SET Credit_RC = 0 WHERE Credit_RC IS NULL
GO
UPDATE pJournal SET Debit_RC = 0 WHERE Debit_RC IS NULL
GO

UPDATE mJournal SET Credit_RC = 0 WHERE Credit_RC IS NULL
GO
UPDATE mJournal SET Debit_RC = 0 WHERE Debit_RC IS NULL
GO

UPDATE nJournal SET Credit_RC = 0 WHERE Credit_RC IS NULL
GO
UPDATE nJournal SET Debit_RC = 0 WHERE Debit_RC IS NULL
GO