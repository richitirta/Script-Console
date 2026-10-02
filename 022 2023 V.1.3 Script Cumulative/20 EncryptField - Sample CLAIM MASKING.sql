--select * from EncryptField where FormName='CLView10'
--select * from claim where cno=232
--update claim set ClaimantEmail ='', ClaimantPhone='08789567891' where cno=232
--GO
--delete from EncryptField where EncryptID not in ('1','2')
--GO
INSERT INTO EncryptField VALUES 
(18,'CLREGFRM','TxtCOLID','COL','','X','1','0','0',GETDATE(),'CARE'),
(19,'CLREGFRM','TxtCOLName','Description','','X','1','0','0',GETDATE(),'CARE'),
(20,'CLREGFRM','TxtLossDate','LossDate','','X','1','0','0',GETDATE(),'CARE'),
(21,'CLREGFRM','TxtLossDesc','LossDesc','','X','1','0','0',GETDATE(),'CARE'),
(22,'CLREGFRM','TxtRefNo','RefNo','','X','1','0','0',GETDATE(),'CARE'),

(23,'CLVIEW10','TxtLossDate','LossDate','','X','1','0','0',GETDATE(),'CARE'),
(24,'CLVIEW05','LblLossDate','LossDate','','X','1','0','0',GETDATE(),'CARE'),

--AIG Indo
(25,'CLVIEW05','LblCOL','COL','','X','1','0','0',GETDATE(),'CARE'),
(26,'CLVIEW05','LblCOLDesc','Description','','X','1','0','0',GETDATE(),'CARE'),

(27,'CLVIEW03','TxtLossDate','LossDate','','X','1','0','0',GETDATE(),'CARE'),
--AIG Indo
(28,'CLVIEW03','LblRefNo','RefNo','','X','1','0','0',GETDATE(),'CARE'),

--Example
(29,'CLREGFRM','TxtPhone','ClaimantPhone','Phone','*','1','0','0',GETDATE(),'CARE'),
(30,'CLREGFRM','TxtEmail','ClaimantEmail','Email','X','1','0','0',GETDATE(),'CARE'),
(31,'CLVIEW07','TxtLossDate','LossDate','','X','1','0','0',GETDATE(),'CARE'),
(32,'CLVIEW06','LblLossDate','LossDate','','X','1','0','0',GETDATE(),'CARE'),
(33,'CLListFrm','LblLossDate','LossDate','','X','1','0','0',GETDATE(),'CARE'),
(34,'CLListFrm','LblDescription','Description','','X','1','0','0',GETDATE(),'CARE'),
(35,'CLCommentDlg','TxtLoss','LossDesc','','X','1','0','0',GETDATE(),'CARE'),
(36,'CLAdmDlg','TxtBankID','ID','','X','1','0','0',GETDATE(),'CARE'),
(37,'CLAdmDlg','TxtBankName','Name','','X','1','0','0',GETDATE(),'CARE'),
(38,'CLLIDlg','TxtReferenceNo','RefNo','','X','1','0','0',GETDATE(),'CARE')


