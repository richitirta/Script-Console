Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Net
Imports System.Net.Mail
Imports System.ComponentModel
Imports CareWebLibrary
Imports CareWebLibrary.CursorTypeEnum
Imports CareWebLibrary.EditTypeEnum

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
<System.Web.Services.WebService(Namespace:="http://tempuri.org/")> _
<System.Web.Services.WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<ToolboxItem(False)> _
Public Class WSFinance
    Inherits System.Web.Services.WebService

    Dim db As ClassLib
    Dim dbName As String
    Dim dbServer As String
    Dim dbSysUser As String
    Dim dbSysPassword As String
    Dim dbUser As String
    Dim dbUserType As String
    Dim dbPassword As String
    Dim dbTimeOut As Integer
    Dim dbTrusted As Boolean
    Dim StrMsg As String
    Dim WI As System.Security.Principal.WindowsIdentity
    Dim WIC As System.Security.Principal.WindowsImpersonationContext
    Public Sub New()
        db = Nothing
        dbUser = ""
        dbPassword = ""
    End Sub
    Private Function OpenConnection(ByRef _dbUser As String, ByRef _dbPassword As String, ByRef ErrMsg As String) As Boolean
        Try
            If db Is Nothing Then
                db = New ClassLib
                dbUser = _dbUser
                dbPassword = _dbPassword
                dbName = GetAppSetting("dbName")
                dbServer = GetAppSetting("dbServer")
                dbSysUser = GetAppSetting("dbSysUser")
                dbSysPassword = GetAppSetting("dbSysPassword")
                dbTimeOut = toval(GetAppSetting("dbTimeout"))
                dbTrusted = toval(GetAppSetting("dbTrusted"))
                If dbTrusted Then
                    WI = CType(HttpContext.Current.User.Identity, System.Security.Principal.WindowsIdentity)
                    WIC = WI.Impersonate
                End If
                If Not db.OpenSession("", _dbUser, _dbPassword, dbName, dbServer, dbSysUser, dbSysPassword, dbTimeOut, False, dbTrusted) Then Throw New Exception("Opening Session Failed !")
                dbTrusted = db.Get_DbTrusted
                dbUserType = db.Var_db_User_Type
                If dbTrusted Then
                    dbUser = db.Var_db_user
                    dbPassword = db.Var_db_Password
                    _dbUser = dbUser
                    _dbPassword = dbPassword
                End If
            End If
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            db = Nothing
            Return False
        End Try
    End Function
    Private Function CloseConnection() As Boolean
        Try
            If Not db Is Nothing Then
                db.CloseSession()
                db = Nothing
                dbUser = ""
                dbPassword = ""
            End If
        Catch ex As Exception
            db = Nothing
        End Try
        Return True
    End Function
    Private Function PreAddVoucherTRTP(ByVal InParam As Object(), ByVal ProAcc As String, ByVal ComAcc As String, ByVal Currency As String, ByRef Errmsg As String) As Boolean

        Dim rs As RemoteSet
        Dim br_End_Date As Date
        Dim br_Month As Integer
        Dim br_Year As Integer
        Dim FLockedDate As Date

        Dim Voucher As String
        Dim Branch As String
        Dim VoucherDate As Date
        Dim RefNo As String
        Dim RefType As String

        Voucher = getInParamValue(InParam, 0)
        Branch = getInParamValue(InParam, 1)
        VoucherDate = getInParamValue(InParam, 2)
        RefNo = getInParamValue(InParam, 5)
        RefType = getInParamValue(InParam, 6)

        On Error GoTo errmsg

        rs = db.OpenRemoteSet("Select * from Branch where branch='" & Branch & "'")
        If Not rs.Eof Then
            br_End_Date = todate(rs.fields("end_date"))
            br_Month = toval(rs.fields("Month"))
            br_Year = toval(rs.fields("year"))
        End If

        If Not db.GetPrivileges("ALLOWLOCKEDPERIOD") Then
            FLockedDate = GetFLockedDate(Branch)
            If DateDiff(DateInterval.Day, FLockedDate, VoucherDate) <= 0 Then
                Errmsg = "Transactions for this period have been closed, Check the Closing Date on " & FLockedDate
                GoTo errmsg
            End If
        End If

        If (DateDiff(DateInterval.Day, VoucherDate, br_End_Date) >= 0) Then
            Errmsg = "Backdated Transaction, Check the Ending Date on " & br_End_Date & " !"
            GoTo errmsg
        End If

        rs = db.OpenRemoteSet("Select ProAcc, Description, Currency, RestrictedF from ProAcc where ProAcc='" & ProAcc & "'")
        If rs.Eof Then
            Errmsg = "Not a Valid Profile Account-" & ProAcc
            Throw New Exception(Errmsg)
        End If

        If toval(rs.fields("RestrictedF")) Then
            Errmsg = "Not Allowed for Restricted Profile Account-" & ProAcc & "-" & rs.fields("Description")
            Throw New Exception(Errmsg)
        End If

        If rs.fields("Currency") <> Currency Then
            Errmsg = "Not a Valid Profile Account-" & ProAcc & " for Voucher Currency-'" & Currency
            Throw New Exception(Errmsg)
        End If

        rs = db.OpenRemoteSet("Select ComAcc, Description, Currency, RestrictedF From FN_UserComAcc ('" & dbUser & "', '" & Branch & "') Where ComAcc='" & ComAcc & "'")
        If rs.Eof Then
            Errmsg = "No Branch's Authorization for Company Account-" & ComAcc
            Throw New Exception(Errmsg)
        End If

        If toval(rs.fields("RestrictedF")) Then
            Errmsg = "Not Allowed for Restricted Company Account-" & ComAcc & "-" & rs.fields("Description")
            Throw New Exception(Errmsg)
        End If

        If RefNo <> "" Then
            If (Not (UCase(dbUserType) = "SUPERVISOR") AndAlso db.GetPrivileges("FORCECHECKVOUCHERREFNO")) Then
                rs = db.OpenRemoteSet("Select top 1 Voucher from pVoucher Where SL_Cat='P' and Voucher<>'" & Voucher & "' and RefNo='" & RefNo & "'")
                If Not rs.Eof Then
                    Errmsg = "Duplicate Reference No " & RefNo & " (" & RefType & ") with Voucher No. " & rs.fields("Voucher")
                    Throw New Exception(Errmsg)
                End If
            End If
        End If

        Return True
errmsg:
        Errmsg = StrError(Errmsg)
        Return False
    End Function
    Private Function PreEditVoucherTRTP(ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim rs As RemoteSet
        Dim VType As String

        Dim Voucher As String
        Dim VoucherDate As Date

        Voucher = getInParamValue(InParam, 0)
        'Branch = getInParamValue(InParam, 1)
        VoucherDate = getInParamValue(InParam, 2)
        'Reference = getInParamValue(InParam, 3)
        'RefNo = getInParamValue(InParam, 4)

        On Error GoTo errmsg

        rs = db.OpenRemoteSet("Select * from pVoucher Where Voucher='" & Voucher & "'")
        If rs.Eof Then
            ErrMsg = "No Voucher Data !"
            GoTo errmsg
        Else
            If rs.fields("DebtorF") Then
                If Not db.GetPrivileges("ALLOWRECEIPT") And rs.fields("Status") <> "N" Then
                    ErrMsg = "Receipt Voucher Already Processed !"
                    GoTo errmsg
                End If
            Else
                If Not db.GetPrivileges("ALLOWPAYMENT") And rs.fields("Status") <> "N" Then
                    ErrMsg = "Payment Voucher Already Processed !"
                    GoTo errmsg
                End If
            End If
        End If

        If Month(VoucherDate) + Year(VoucherDate) * 12 <> Month(rs.fields("Date")) + Year(rs.fields("Date")) * 12 Then
            If Not db.GetPrivileges("ALLOWCHANGEDATE") Then
                ErrMsg = "Not Allowed To Change Booking Date !"
                GoTo errmsg
            End If
        End If

        If rs.fields("BranchF") Then
            ErrMsg = "Branch Data Upload Constraint !"
            GoTo errmsg
        End If

        If Not rs.fields("BackDatedF") And rs.fields("Posting_Flag") = True Then
            ErrMsg = "Voucher Already Processed / Posted !"
            GoTo errmsg
        End If

        If rs.fields("RequestF") And UCase(rs.fields("RequestName")) <> UCase(dbUser) Then
            ErrMsg = "Document is being sent to User-'" & rs.fields("RequestName") & "' !"
            GoTo errmsg
        End If

        VType = rs.fields("VType")

        rs = db.OpenRemoteSet("Select Code from VType Where VType='" & VType & "'")
        If UCase(rs.fields("Code")) = "INTERBANK" Then
            ErrMsg = "Document Related to Inter Company Account Voucher !"
            GoTo errmsg
        End If

        rs = db.OpenRemoteSet("select Top 1 CollNo from CollResult where VoucherR='" & Voucher & "'")
        If Not rs.Eof Then
            ErrMsg = "Document Related to Collection No. '" & tostr(rs.fields("CollNo")) & "' !"
            GoTo errmsg
        End If

        rs = db.OpenRemoteSet("select Top 1 Cheque from Cheque where Voucher='" & Voucher & "'")
        If Not rs.Eof Then
            ErrMsg = "Document Related to Cheque No. '" & tostr(rs.fields("Cheque")) & "' !"
            GoTo errmsg
        End If

        rs = db.OpenRemoteSet("Select Top 1 Voucher.Voucher from pVoucher Voucher, VType where (Voucher.RefType<>'INTEROFFICE' or Voucher.Posting_Flag=1) and Voucher.SL_Cat<>'P' and VType.VType=Voucher.VType and Voucher.RefNo='" & Voucher & "'")
        If Not rs.Eof Then
            ErrMsg = "Document has Constraint with Voucher. '" & tostr(rs.fields("Voucher")) & "' !"
            GoTo errmsg
        End If

        rs = db.OpenRemoteSet("Select Top 1 AVoucher.Voucher from pVoucher AVoucher, pVoucher OVoucher Where OVoucher.RefNo='" & Voucher & "' and OVoucher.RefType='INTEROFFICE' and AVoucher.RefNo=OVoucher.Voucher")
        If Not rs.Eof Then
            ErrMsg = "Document has Constraint with Voucher. '" & tostr(rs.fields("Voucher")) & "' !"
            GoTo errmsg
        End If

        rs = db.OpenRemoteSet("Select Top 1 Voucher from pSL SL where Doc_No='" & Voucher & "' and PaymentF=1", adOpenForwardonly)
        If Not rs.Eof Then
            ErrMsg = "Document Already Used By Voucher. '" & tostr(rs.fields("Voucher")) & "' !"
            GoTo errmsg
        End If

        rs = db.OpenRemoteSet("Select Top 1 nSL.Voucher from nVoucher, nSL where nSL.Voucher=nVoucher.Voucher and nVoucher.DocNo='' and nSL.pVoucher='" & Voucher & "'")
        If Not rs.Eof Then
            ErrMsg = "Document has Constraint with WithHolding Voucher. '" & tostr(rs.fields("Voucher")) & "' !"
            GoTo errmsg
        End If

        ' Withholding Voucher Created By Overbooking
        rs = db.OpenRemoteSet("Select Top 1 nSL.Voucher from nVoucher, nSL, pVoucher where nSL.Voucher=nVoucher.Voucher and nVoucher.DocNo='' and nSL.pVoucher=pVoucher.Voucher and pVoucher.SL_Cat<>'P' and pVoucher.RefNo='" & Voucher & "'")
        If Not rs.Eof Then
            ErrMsg = "Document has Constraint with WithHolding Voucher. '" & tostr(rs.fields("Voucher")) & "' !"
            GoTo errmsg
        End If

        If Not db.GetPrivileges("ALLOWCHANGEVOUCHERWITHPRINTLOG") Then
            rs = db.OpenRemoteSet("Select Top 1 Voucher from VPrintLog Where Voucher='" & Voucher & "'")
            If Not rs.Eof Then
                ErrMsg = "Document Already has Printing Log !"
                GoTo errmsg
            End If
            rs = db.OpenRemoteSet("Select Top 1 Voucher from ORPrintLog Where Voucher='" & Voucher & "'")
            If Not rs.Eof Then
                ErrMsg = "Document Already has Printing Log !"
                GoTo errmsg
            End If
        End If

        Return True
errmsg:
        ErrMsg = StrError(ErrMsg)
        Return False
    End Function
    <WebMethod(EnableSession:=False)> _
        Public Function GenerateChequeNo(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim ComAcc As String
            Dim NoCheque As Long

            ComAcc = getInParamValue(InParam, 0)            ' Company Account
            NoCheque = toval(getInParamValue(InParam, 1))   ' Number Of Generated Cheque

            Dim rs As RemoteSet
            Dim ChequeSeqNo As Long
            Dim ChequeFormat As String

            rs = db.OpenRemoteSet("Select * from ComAcc Where ComAcc='" & ComAcc & "'")
            If rs.Eof Then
                ErrMsg = "Company Account Not Found !"
                Throw New Exception(ErrMsg)
            End If
            ChequeSeqNo = toval(rs.fields("ChequeSeqNo"))
            ChequeFormat = tostr(rs.fields("ChequeFormat"))

            Dim rsCheque As RemoteSet
            rsCheque = db.OpenRemoteSet("Select * from ComAcc_Cheque Where 1<>1")
            Dim i As Long
            For i = ChequeSeqNo + 1 To ChequeSeqNo + NoCheque
                rsCheque.AddNew()
                rsCheque.fields("ComAcc") = ComAcc
                rsCheque.fields("ChequeNo") = Format(i, ChequeFormat)
                rsCheque.fields("Voucher") = ""
                rsCheque.fields("Status") = "O"
                rsCheque.fields("Last_Opr") = dbUser
                rsCheque.fields("Last_Update") = Today.Date
                If Not rsCheque.update Then Throw New Exception(rsCheque.errdesc)
            Next

            ChequeSeqNo = ChequeSeqNo + NoCheque
            rs.Edit()
            rs.fields("ChequeSeqNo") = ChequeSeqNo
            If Not rs.Update Then Throw New Exception(rs.ErrDesc)

            Dataset = rsCheque.GetDataSet

            Dim dc As System.Data.DataColumn
            dc = New DataColumn
            dc.ColumnName = "ProcessFlag"
            dc.DataType = Type.GetType("System.Boolean")
            dc.DefaultValue = 0
            Dataset.Tables(0).Columns.Add(dc)
            Dataset.Tables(0).Columns(dc.ColumnName).SetOrdinal(0)

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SearchChequeNo(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim ComAcc As String = getInParamValue(InParam, 0)
            Dim FChequeNo As String = getInParamValue(InParam, 1)
            Dim LChequeNo As String = getInParamValue(InParam, 2)
            Dim VoucherStatus As Integer = toval(getInParamValue(InParam, 3))  ' 0 : All, 1 : UnUsed, 2 : Used

            Dim SQL As String
            SQL = "Select Cast(0 as bit) as ProcessFlag, *"
            SQL = SQL & " from ComAcc_Cheque"
            SQL = SQL & " Where ComAcc='" & ComAcc & "'"

            If FChequeNo <> "" And LChequeNo <> "" Then
                SQL = SQL & " and ChequeNo Between '" & FChequeNo & "' and '" & LChequeNo & "'"
            ElseIf FChequeNo <> "" Then
                SQL = SQL & " and ChequeNo='" & FChequeNo & "'"
            ElseIf LChequeNo <> "" Then
                SQL = SQL & " and ChequeNo='" & LChequeNo & "'"
            End If

            Select Case VoucherStatus
                Case 0
                Case 1
                    SQL = SQL & " and Voucher=''"
                Case 2
                    SQL = SQL & " and Voucher<>'' and Status='A'"
                Case 3
                    SQL = SQL & " and Voucher<>'' and Status='C'"
            End Select

            Dim rs As RemoteSet
            Dim C_MaxRecords As Long
            C_MaxRecords = toval(GetAppSetting("CareMaxRecords"))
            If toval(GetAppSetting("CareMaxRecords_FA")) > C_MaxRecords Then
                C_MaxRecords = toval(GetAppSetting("CareMaxRecords_FA"))
            End If
            rs = db.OpenRemoteSet(SQL, , , , C_MaxRecords)
            Dataset = rs.GetDataSet

            If Dataset Is Nothing Then Throw New Exception(ErrMsg)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function GetVoucherTR(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef findex As String(), ByRef fbuffer As String(), ByRef Dataset As DataSet, ByRef DsDetail As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String

            Voucher = getInParamValue(InParam, 0)
            Dim rs As RemoteSet

            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='P' and DebtorF=1 and Voucher='" & Voucher & "'")
            findex = rs.fields_index
            fbuffer = rs.GetRecord

            rs = db.OpenRemoteSet("Select cast(0 as Int) as RecNo, Cast(0 as bit) as ProcessFlag, pSL.*, (Select Top 1 Admlink.ValueDesc from Admlink Where Admlink.Voucher=pSL.Doc_No and pSL.PaymentF=1) as Info, (Select Top 1 Admlink.A_PolicyNo from Admlink Where Admlink.Voucher=pSL.Doc_No and pSL.PaymentF=1) as A_PolicyNo, (Select Top 1 Admlink.DocNo from Admlink Where Admlink.Voucher=pSL.Doc_No and pSL.PaymentF=1) as A_DocNo from oSL('" & Voucher & "') pSL where pSL.Voucher='" & Voucher & "' Order By pSL.SortNo")
            Dataset = rs.GetDataSet

            Dim DataRow As DataRow
            For i = 0 To Dataset.Tables(0).Rows.Count - 1
                DataRow = Dataset.Tables(0).Rows(i)
                If toval(DataRow("BucketF")) Then
                    DataRow("PaymentF") = 1
                End If
            Next
            Dataset.AcceptChanges()

            rs = db.OpenRemoteSet("Select * from pSLRef where pSLRef.Voucher ='" & Voucher & "'")
            DsDetail = rs.GetDataSet

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function GetVoucherMR(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef findex As String(), ByRef fbuffer As String(), ByRef Dataset1 As DataSet, ByRef Dataset2 As DataSet, ByRef Dataset3 As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String

            Voucher = getInParamValue(InParam, 0)
            Dim rs As RemoteSet

            rs = db.OpenRemoteSet("Select pVoucher.*, Cast(0 as Float) as AmountDNCN, Cast(0 as Float) as AmountRVPV, Cast(0 as Float) as AmountAccount from pVoucher Where SL_Cat='P' and DebtorF=1 and Voucher='" & Voucher & "'")
            findex = rs.fields_index
            fbuffer = rs.GetRecord

            ' List Of CN/DN
            rs = db.OpenRemoteSet("Select cast(0 as Int) as RecNo, Cast(0 as bit) as ProcessFlag, pSL.*, (Select Top 1 Admlink.ValueDesc from Admlink Where Admlink.Voucher=pSL.Doc_No and (pSL.PaymentF=1 or pSL.BucketF=1)) as Info, (Select Top 1 Admlink.A_PolicyNo from Admlink Where Admlink.Voucher=pSL.Doc_No and (pSL.PaymentF=1 or pSL.BucketF=1)) as A_PolicyNo, (Select Top 1 Admlink.DocNo from Admlink Where Admlink.Voucher=pSL.Doc_No and (pSL.PaymentF=1 or pSL.BucketF=1)) as A_DocNo from oSL('" & Voucher & "') pSL, nVoucher Voucher where Voucher.Voucher=pSL.Doc_No and (pSL.PaymentF=1 or pSL.BucketF=1) and pSL.Voucher='" & Voucher & "' Order By pSL.SortNo")
            Dataset1 = rs.GetDataSet

            ' List Of RV/PV
            rs = db.OpenRemoteSet("Select cast(0 as Int) as RecNo, Cast(0 as bit) as ProcessFlag, pSL.*, '' as Info, '' as A_PolicyNo, '' as A_DocNo from oSL('" & Voucher & "') pSL, pVoucher Voucher where Voucher.Voucher=pSL.Doc_No and (pSL.PaymentF=1) and pSL.Voucher='" & Voucher & "' Order By pSL.SortNo")
            Dataset2 = rs.GetDataSet

            ' List Of Account
            rs = db.OpenRemoteSet("Select cast(0 as Int) as RecNo, Cast(0 as bit) as ProcessFlag, pSL.*, '' as Info, '' as A_PolicyNo, '' as A_DocNo from oSL('" & Voucher & "') pSL where (pSL.PaymentF=0 and pSL.BucketF=0) and pSL.Voucher='" & Voucher & "' Order By pSL.SortNo")
            Dataset3 = rs.GetDataSet

            Dim DataRow As DataRow
            For i = 0 To Dataset1.Tables(0).Rows.Count - 1
                DataRow = Dataset1.Tables(0).Rows(i)
                If toval(DataRow("BucketF")) Then
                    DataRow("PaymentF") = 1
                End If
            Next
            Dataset1.AcceptChanges()

            Dim Amount As Double

            Amount = 0
            For i = 0 To Dataset1.Tables(0).Rows.Count - 1
                Amount = Amount + toval(Dataset1.Tables(0).Rows(i)("Nominal"))
            Next
            fbuffer(GetFieldIndex("AmountDNCN", findex)) = SetFieldValue(Amount)

            Amount = 0
            For i = 0 To Dataset2.Tables(0).Rows.Count - 1
                Amount = Amount + toval(Dataset2.Tables(0).Rows(i)("Nominal"))
            Next
            fbuffer(GetFieldIndex("AmountRVPV", findex)) = SetFieldValue(Amount)

            Amount = 0
            For i = 0 To Dataset3.Tables(0).Rows.Count - 1
                Amount = Amount + toval(Dataset3.Tables(0).Rows(i)("Nominal"))
            Next
            fbuffer(GetFieldIndex("AmountAccount", findex)) = SetFieldValue(Amount)

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function GetVoucherTP(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef findex As String(), ByRef fbuffer As String(), ByRef Dataset As DataSet, ByRef DsDetail As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String

            Voucher = getInParamValue(InParam, 0)
            Dim rs As RemoteSet

            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='P' and CreditorF=1 and Voucher='" & Voucher & "'")
            findex = rs.fields_index
            fbuffer = rs.GetRecord

            rs = db.OpenRemoteSet("Select cast(0 as Int) as RecNo, Cast(0 as bit) as ProcessFlag, pSL.*, (Select Top 1 Admlink.ValueDesc from Admlink Where Admlink.Voucher=pSL.Doc_No and pSL.PaymentF=1) as Info, (Select Top 1 Admlink.A_PolicyNo from Admlink Where Admlink.Voucher=pSL.Doc_No and pSL.PaymentF=1) as A_PolicyNo, (Select Top 1 Admlink.DocNo from Admlink Where Admlink.Voucher=pSL.Doc_No and pSL.PaymentF=1) as A_DocNo, coalesce(nVoucher.BankName,'') as BankName, coalesce(nVoucher.BankAccount,'') as BankAccount, coalesce(nVoucher.AccountNo,'') as AccountNo from oSL('" & Voucher & "') pSL Left Join nVoucher on (nVoucher.Voucher=pSL.Doc_No and pSL.PaymentF=1) where pSL.Voucher='" & Voucher & "' Order By pSL.SortNo")
            Dataset = rs.GetDataSet

            Dim DataRow As DataRow
            For i = 0 To Dataset.Tables(0).Rows.Count - 1
                DataRow = Dataset.Tables(0).Rows(i)
                If toval(DataRow("BucketF")) Then
                    DataRow("PaymentF") = 1
                End If
            Next
            Dataset.AcceptChanges()

            rs = db.OpenRemoteSet("Select * from pSLRef where pSLRef.Voucher ='" & Voucher & "'")
            DsDetail = rs.GetDataSet

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function SaveVoucherTR(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal findex() As String, ByVal fbuffer() As String, ByVal Dataset As DataSet, ByVal DsDetail As DataSet, ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Branch As String
            Dim VoucherDate As Date
            Dim Reference As String
            Dim RefNo As String

            Voucher = getInParamValue(InParam, 0)
            Branch = getInParamValue(InParam, 1)
            VoucherDate = getInParamValue(InParam, 2)
            Reference = getInParamValue(InParam, 3)
            RefNo = getInParamValue(InParam, 4)

            Dim LockedKey As String = ""
            If Voucher <> "" Then
                LockedKey = Voucher
                If Not db.GetLockedObject("Voucher" & LockedKey) Then Throw New Exception(db.ErrDesc)
            End If
            If Dataset.Tables(0).Rows.Count > 0 Then
                If Not db.GetLockedObject("Voucher" & Left(tostr(Dataset.Tables(0).Rows(0)("Doc_No")), 20)) Then Throw New Exception(db.ErrDesc)
            End If

            Dim rs As RemoteSet
            Dim br_Currency As String
            Dim br_Currency_1 As String
            Dim VType As String
            Dim ComAcc As String
            Dim AutoNum As String
            Dim CodeExt As String
            Dim SL_Cat As String
            Dim Currency As String
            Dim Rate As Double
            Dim Rate_RC As Double
            Dim ProAcc As String
            Dim Remarks As String
            Dim Status As String

            Dim BudgetFeaturesF As Boolean
            rs = db.OpenRemoteSet("Select Currency, Currency_1, BudgetFeaturesF from SysTab")
            br_Currency = rs.fields("Currency")
            br_Currency_1 = rs.fields("Currency_1")
            BudgetFeaturesF = rs.fields("BudgetFeaturesF")

            VType = GetFieldValue(fbuffer(GetFieldIndex("VType", findex)))
            ComAcc = GetFieldValue(fbuffer(GetFieldIndex("ComAcc", findex)))
            Currency = GetFieldValue(fbuffer(GetFieldIndex("Currency", findex)))

            Dim RefCCYDate As Date
            RefCCYDate = todate(GetFieldValue(fbuffer(GetFieldIndex("RefCCYDate", findex))))

            Rate = exchange_rate(Currency, RefCCYDate, br_Currency)
            Rate_RC = exchange_rate_RC(Currency, RefCCYDate, br_Currency_1)

            ProAcc = GetFieldValue(fbuffer(GetFieldIndex("ProAcc", findex)))
            Remarks = GetFieldValue(fbuffer(GetFieldIndex("Remarks", findex)))

            rs = db.OpenRemoteSet("select vType, SL_Cat, AutoNum, DebtorF, CreditorF, CodeExt from vType where SL_Cat='P' and DebtorF=1 and vtype = '" & VType & "'")
            AutoNum = tostr(rs.fields("AutoNum"))
            CodeExt = tostr(rs.fields("CodeExt"))
            SL_Cat = tostr(rs.fields("SL_Cat"))

            Dim rsV As RemoteSet
            Dim EditMode As Integer
            rsV = db.OpenRemoteSet("Select * from pVoucher Where Voucher='" & Voucher & "'")
            If rsV.Eof Then
                If Not PreAddVoucherTRTP(InParam, ProAcc, ComAcc, Currency, ErrMsg) Then Throw New Exception(ErrMsg)

                Dim DocID As String
                rs = db.OpenRemoteSet("Select * from ComAcc Where ComAcc='" & ComAcc & "'")
                DocID = tostr(rs.fields("DocID"))
                If Voucher = "" Then
                    Voucher = db.GetNextDocNo(AutoNum, VoucherDate, DocID & Branch)
                End If
                If Voucher = "" Then Throw New Exception("Generate Voucher Number Failed !")

                rsV.AddNew()
            Else
                If Not PreAddVoucherTRTP(InParam, ProAcc, ComAcc, Currency, ErrMsg) Then Throw New Exception(ErrMsg)
                If Not PreEditVoucherTRTP(InParam, ErrMsg) Then Throw New Exception(ErrMsg)

                If toval(GetFieldValue(fbuffer(GetFieldIndex("Nominal_CC", findex)))) - toval(GetFieldValue(fbuffer(GetFieldIndex("Diff_CC", findex)))) <> toval(rsV.fields("Nominal_CC")) - toval(rsV.fields("Diff_CC")) Then
                    If Not db.GetPrivileges("ALLOWCHANGERECEIPT") Then
                        ErrMsg = "Not Allowed To Change Receipt Amount !"
                        Throw New Exception(ErrMsg)
                    End If
                End If

                rsV.Edit()
            End If
            EditMode = rsV.editmode

            If rsV.fields("Status") = "U" Then
                If BudgetFeaturesF Then
                    If Not Update_Budget_Account_Actual(Voucher, -1) Then Throw New Exception("Update Budget Account Failed !")
                End If
            End If

            Dim i As Integer
            Dim j As Integer
            i = 0
            j = UBound(findex)
            Do While i < j
                rsV.fields(findex(i)) = GetFieldValue(fbuffer(i))
                i = i + 1
            Loop
            If Not db.GetPrivileges("ALLOWPASSSCANPAN") Then
                If isContainRestrictedPAN(rsV.fields("AccountNo")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field AccountNo!")
                End If
                If isContainRestrictedPAN(rsV.fields("REFNO")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field REFNO!")
                End If
                If isContainRestrictedPAN(rsV.fields("REMARKS")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field REMARKS!")
                End If
            End If

            If EditMode = AdEditAdd Then
                rsV.fields("Branch") = Branch
                rsV.fields("CDate") = Today.Date
                rsV.fields("CTime") = Time()
                rsV.fields("UserID") = dbUser
                rsV.fields("Voucher") = Voucher
                rsV.fields("RequestF") = False
                rsV.fields("RequestMessage") = ""
                rsV.fields("RequestName") = ""
                rsV.fields("AUserID") = ""
                rsV.fields("AUserDate") = ""
                rsV.fields("AUserID_Ext") = ""
                rsV.fields("AUserDate_Ext") = ""
                rsV.fields("VerifiedBy") = ""
                rsV.fields("OtorizedBy") = ""
                rsV.fields("Otorized2By") = ""
                rsV.fields("AcceptedBy") = ""
                rsV.fields("VerifiedByTitle") = ""
                rsV.fields("OtorizedByTitle") = ""
                rsV.fields("Otorized2ByTitle") = ""
            End If
            rsV.fields("Date") = VoucherDate
            rsV.fields("Rate") = Rate
            rsV.fields("Rate_RC") = Rate_RC
            rsV.fields("ReceiptF") = True
            rsV.fields("PaymentF") = False
            rsV.fields("CreditorF") = False
            rsV.fields("DebtorF") = True
            rsV.fields("SL_Flag") = True
            rsV.fields("SL_Cat") = "P"
            rsV.fields("Num_Doc") = 0
            rsV.fields("SL_Tag") = 1
            rsV.fields("PDate") = VoucherDate
            rsV.fields("Last_Date") = Today.Date
            rsV.fields("Last_Time") = Time()
            rsV.fields("Last_Opr") = dbUser
            rsV.fields("BackDatedF") = False
            rsV.fields("Posting_Flag") = False
            If Not rsV.Update Then Throw New Exception(db.ErrDesc)

            Dim TaxDeductionF As Boolean = False
            Const MaxCols = 18
            Dim Bufferdata(Dataset.Tables(0).Rows.Count - 1, MaxCols - 1) As Object
            For i = 0 To Dataset.Tables(0).Rows.Count - 1
                Bufferdata(i, 0) = tostr(Dataset.Tables(0).Rows(i)("Doc_No"))
                Bufferdata(i, 1) = todate(Dataset.Tables(0).Rows(i)("Doc_Date"))
                Bufferdata(i, 2) = tostr(Dataset.Tables(0).Rows(i)("Doc_CCY"))
                Bufferdata(i, 3) = RoundCCY(toval(Dataset.Tables(0).Rows(i)("Nominal_OC")), UCase(tostr(Dataset.Tables(0).Rows(i)("Doc_CCY"))), toval(GetAppSetting("FARoundingDecimalValue")))
                Bufferdata(i, 4) = tostr(Dataset.Tables(0).Rows(i)("CT"))
                Bufferdata(i, 5) = RoundCCY(toval(Dataset.Tables(0).Rows(i)("Nominal")), UCase(Currency), toval(GetAppSetting("FARoundingDecimalValue")))
                Bufferdata(i, 6) = tostr(Dataset.Tables(0).Rows(i)("Remarks"))
                Bufferdata(i, 7) = toval(Dataset.Tables(0).Rows(i)("Hint"))
                If toval(Dataset.Tables(0).Rows(i)("Hint")) = -14 Then
                    TaxDeductionF = True
                End If
                Bufferdata(i, 8) = IIf(toval(Dataset.Tables(0).Rows(i)("PaymentF")) = 0, False, True)
                Bufferdata(i, 9) = tostr(Dataset.Tables(0).Rows(i)("Account"))
                Bufferdata(i, 10) = toval(Dataset.Tables(0).Rows(i)("Nominator"))
                Bufferdata(i, 11) = toval(Dataset.Tables(0).Rows(i)("Denominator"))
                Bufferdata(i, 12) = tostr(Dataset.Tables(0).Rows(i)("Branch"))
                Bufferdata(i, 13) = tostr(Dataset.Tables(0).Rows(i)("pVoucher"))
                Bufferdata(i, 14) = toval(Dataset.Tables(0).Rows(i)("LockedF"))
                Bufferdata(i, 15) = toval(Dataset.Tables(0).Rows(i)("FundingF"))
                Bufferdata(i, 16) = tostr(Dataset.Tables(0).Rows(i)("GID"))
                Bufferdata(i, 17) = tostr(Dataset.Tables(0).Rows(i)("Description"))
            Next

            If CBool(toval(GetAppSetting("AutoMatchingF"))) Then
                If Not db.Execute("Select Distinct R.Voucher, R.NVoucher, nSL.Account, V.Date as Doc_Date into #RPBucket from RPBucket R, NVoucher V, nSL Where R.Voucher='" & Voucher & "' and R.NVoucher<>'' and R.Status='R' and V.Voucher=R.NVoucher and nSL.Voucher=V.Voucher") Then Throw New Exception(db.ErrDesc)
                If Not db.Execute("Create Unique Index I_RPBucket on #RPBucket(Voucher, NVoucher)") Then Throw New Exception(db.ErrDesc)
                For i = 0 To Dataset.Tables(0).Rows.Count - 1
                    rs = db.OpenRemoteSet("Select * from #RPBucket R Where R.Voucher='" & Voucher & "' and R.NVoucher='" & Bufferdata(i, 0) & "'")
                    If Not rs.Eof Then
                        Bufferdata(i, 1) = todate(rs.fields("Doc_Date"))
                        Bufferdata(i, 8) = True
                        Bufferdata(i, 9) = tostr(rs.fields("Account"))
                    End If
                Next
                If Not db.Execute("Drop table #RPBucket") Then Throw New Exception(db.ErrDesc)

                If Not Delete_Auto_Receipt_Payment(Voucher) Then Throw New Exception("Delete Auto Matching Failed !")

                For i = 0 To Dataset.Tables(0).Rows.Count - 1
                    If DateDiff(DateInterval.Day, todate(Bufferdata(i, 1)), VoucherDate) < 0 AndAlso toval(Bufferdata(i, 8)) Then
                        rs = db.OpenRemoteSet("Select V.Account, A1.Type, A1.Subject from Admlink A1, vPattern V, Account A2 Where A1.Voucher='" & Bufferdata(i, 0) & "' and A2.Account=V.Account and A2.suspend_Flag=1 and V.Credit=" & toval(Bufferdata(i, 7)) & " and V.VType='" & VType & "'")
                        If Not rs.Eof AndAlso InStr("DIICIRITIXPDBBBABOBCBPBDDCCPXPQSQPS1S2S3AFFOFP", tostr(rs.fields("Type")).ToUpper) <> 0 AndAlso tostr(rs.fields("Subject")).ToUpper = "PREMIUM" Then
                            If Insert_Auto_Receipt_Payment(Voucher, tostr(rs.fields("Account")), Bufferdata(i, 0), toval(Bufferdata(i, 5)), todate(Bufferdata(i, 1)), toval(Bufferdata(i, 10)) / toval(Bufferdata(i, 11)), True) Then
                                Bufferdata(i, 1) = VoucherDate
                                Bufferdata(i, 8) = False
                                Bufferdata(i, 9) = tostr(rs.fields("Account"))
                            End If
                        End If
                    End If
                Next

            End If

            Dim Param(12) As Object
            Param(0) = Voucher
            Param(1) = VoucherDate
            Param(2) = VType
            Param(3) = Currency
            Param(4) = Branch
            Param(5) = Rate
            Param(6) = ProAcc
            Param(7) = Reference
            Param(8) = RefNo
            Param(9) = Remarks
            Param(10) = IIf(EditMode = AdEditAdd, "ADD", "EDIT")
            Param(11) = Rate_RC
            Param(12) = rsV.fields("CT")

            Dim OParam As Object = Nothing

            Const MaxRows_2 = 100
            Const MaxCols_2 = 7
            Dim bufferdata_2(MaxRows_2 - 1, MaxCols_2 - 1) As Object
            If Not DsDetail Is Nothing Then
                For i = 0 To DsDetail.Tables(0).Rows.Count - 1
                    bufferdata_2(i, 0) = tostr(DsDetail.Tables(0).Rows(i)("RefDate"))
                    bufferdata_2(i, 1) = tostr(DsDetail.Tables(0).Rows(i)("Description"))
                    bufferdata_2(i, 2) = toval(DsDetail.Tables(0).Rows(i)("Nominal"))
                    bufferdata_2(i, 3) = tostr(DsDetail.Tables(0).Rows(i)("RefNo"))
                    bufferdata_2(i, 4) = tostr(DsDetail.Tables(0).Rows(i)("RefType"))
                    bufferdata_2(i, 5) = tostr(DsDetail.Tables(0).Rows(i)("RefStatus"))
                    bufferdata_2(i, 6) = tostr(DsDetail.Tables(0).Rows(i)("DocRefNo"))
                Next
            End If

            OParam = Me.Direct_Call_Process_Execute("ProcessFAExt.NetV3.Proclib", "SAVE_DETAIL_TR", Param, TrimBuffer(Bufferdata), TrimBuffer(bufferdata_2))
            If TypeName(OParam) <> "Object()" Then Throw New Exception(Me.ErrDesc)

            ' see fields to buffer for converting date field

            ' Refreshing Data
            rsV.Edit()
            rsV.fields("Num_Doc") = toval(OParam(0))
            rsV.fields("Payment_CC") = toval(OParam(1))
            rsV.fields("nPayment") = toval(OParam(2))
            rsV.fields("Nominal_CC") = toval(OParam(3))
            rsV.fields("Diff_CC") = toval(OParam(4))
            rsV.fields("Nominal") = toval(OParam(3)) * Rate
            rsV.fields("Diff") = toval(OParam(4)) * Rate

            Dim TotalAmount As Double
            TotalAmount = rsV.fields("Nominal") - rsV.fields("Diff")
            If Not GetApprovalLimitFA(dbUser, VType, "In", TotalAmount) Or (TotalAmount = 0 And Not db.GetPrivileges("ALLOWZEROPAYMENT")) Or (TotalAmount <> 0 And Not db.GetPrivileges("ALLOWNONZEROPAYMENT")) Or Not db.GetPrivileges("ALLOWRECEIPT") Then
                Status = "N"    ' Not Approved
            Else
                Status = "U"    ' Ok Approved, Un-Posting
            End If
            rsV.fields("Status") = Status
            If Status = "U" Then
                rsV.fields("AUserID") = dbUser
                rsV.fields("AUserDate") = Today.Date
                rsV.fields("AUserID_Ext") = dbUser
                rsV.fields("AUserDate_Ext") = Today.Date
            End If
            If Not rsV.Update Then Throw New Exception(db.ErrDesc)

            ' Update References
            If rsV.fields("RefType") = "CHEQUE" Or rsV.fields("RefType") = "GIRO" Then
                Select Case Reference
                    Case "REQUEST"
                        If Not db.Execute("Update Cheque Set Status='D', Voucher='" & Voucher & "' where Cheque.Status Not in ('D','L') and Cheque.WriteF=0 and Cheque.RefNo='" & RefNo & "' and Cheque.ProAcc='" & ProAcc & "'") Then Throw New Exception(db.ErrDesc)
                    Case "LISTREQUEST"
                        If Not db.Execute("Update Cheque Set Status='D', Voucher='" & Voucher & "' where Cheque.Status Not in ('D','L') and Cheque.WriteF=0 and Cheque.RefNo in " & RefNo & " and Cheque.ProAcc='" & ProAcc & "'") Then Throw New Exception(db.ErrDesc)
                End Select
            End If

            ' Update References
            Select Case Reference
                Case "REQUEST"
                    If Not db.Execute("Update Request Set Voucher='" & Voucher & "' from Request Where Request='" & RefNo & "' and Status<>'C' and (Voucher='' or Voucher='" & Voucher & "')") Then Throw New Exception(db.ErrDesc)
                    If db.RecordsAffected = 0 Then Throw New Exception("No Request Document Updated !")
                Case "LISTREQUEST"
                    If Not db.Execute("Update Request Set Voucher='" & Voucher & "' from Request Where Request in " & RefNo & " and Status<>'C' and (Voucher='' or Voucher='" & Voucher & "')") Then Throw New Exception(db.ErrDesc)
                    If db.RecordsAffected = 0 Then Throw New Exception("No Request Document Updated !")
            End Select

            If EditMode = AdEditAdd AndAlso (Reference = "REQUEST" Or Reference = "LISTREQUEST") Then
                rs = db.OpenRemoteSet("Select R2.ImageID, R2.FileType, R2.Title, R2.Remark, R2.Last_Opr, R2.Last_Update from Request R1, RequestPIC R2 Where R2.Request=R1.Request and R1.Voucher='" & Voucher & "'")
                If Not rs.Eof Then

                    Dim ws As New localhost6.WSCommon(GetAppSetting("CareWSImage"))
                    ws.Timeout = System.Threading.Timeout.Infinite

                    Dim rsPic As RemoteSet
                    rsPic = db.OpenRemoteSet("Select * from VoucherPIC Where 1<>1")
                    Do While Not rs.Eof

                        Dim DataBuffer() As Byte = Nothing
                        Dim ImageID As Long = rs.fields("ImageID")
                        Dim NewImageID As Long = 0

                        'Dim ParamI(1) As Object
                        'Dim ParamO As Object = Nothing

                        'ParamI(0) = ImageID
                        'If Not ws.GetPictureBinary(dbUser, dbPassword, ParamI, ParamO, ErrMsg) Then Throw New Exception(ErrMsg)
                        'DataBuffer = ParamO(0)

                        'ParamI(0) = NewImageID
                        'ParamI(1) = DataBuffer
                        'If Not ws.SaveDocument(dbUser, dbPassword, ParamI, ParamO, ErrMsg) Then Throw New Exception(ErrMsg)
                        'NewImageID = ParamO(0)

                        rsPic.AddNew()
                        rsPic.fields("Voucher") = Voucher
                        rsPic.fields("ImageID") = ImageID
                        rsPic.fields("FileType") = rs.fields("FileType")
                        rsPic.fields("Title") = rs.fields("Title")
                        rsPic.fields("Remark") = rs.fields("Remark")
                        rsPic.fields("Last_Opr") = dbUser
                        rsPic.fields("Last_Update") = Today.Date
                        If Not rsPic.UpdateRow Then Throw New Exception(db.ErrDesc)
                        rs.MoveNext()
                    Loop
                    If Not rsPic.Eof Then
                        If Not rsPic.Update Then Throw New Exception(db.ErrDesc)
                    End If
                End If
            End If

            If rsV.fields("Status") = "U" Then
                If BudgetFeaturesF Then
                    If Not db.GetPrivileges("ALLOWPASSCHECKBUDGET") Then
                        If Not Check_Voucher_Budget_Account(Voucher) Then Throw New Exception("Check Budget Account Failed !" & StrMsg)
                    End If
                    If Not Update_Budget_Account_Actual(Voucher, 1) Then Throw New Exception("Update Budget Account Failed !")
                End If
                If Not db.Execute("Update ProAcc Set RestrictedF=RESTRICTAFTERUSEDF Where ProAcc='" & ProAcc & "'") Then Throw New Exception(db.ErrDesc)
            End If

            If Not TaxDeductionF AndAlso CBool(toval(GetAppSetting("CheckTaxDeductionF"))) Then
                Dim SQL As String
                SQL = "Select sum(Admlink.PNominal_Tax/Admlink.Amount*pSL.Nominal*TaxType.TaxRate/100) as TaxNominal"
                SQL = SQL & " from Admlink, nVoucher, OSL('" & Voucher & "') pSL, pVoucher, Profile, TaxType, MParam"
                SQL = SQL & " Where MParam.Type=Admlink.Type and Admlink.Voucher=nVoucher.Voucher and Admlink.Amount_14=0 and nVoucher.TaxF=1 and nVoucher.Voucher=pSL.Doc_No and pSL.PaymentF=1 and pVoucher.Voucher=pSL.Voucher and pVoucher.Voucher='" & Voucher & "'"
                SQL = SQL & " and Profile.ID=Admlink.ID and TaxType.TaxType=dbo.Get_TaxType(Profile.TaxType,Profile.ID,pVoucher.Date, '',0, MParam.TaxDiscount) "
                SQL = SQL & " and not ('" & Format(VoucherDate, "MM/DD/YYYY") & "' Between coalesce(Profile.TaxHSDate,'01/01/1900') and coalesce(Profile.TaxHEDate,'01/01/1900'))"
                rs = db.OpenRemoteSet(SQL)
                If Math.Round(toval(rs.fields("TaxNominal")), 4, MidpointRounding.AwayFromZero) <> 0 Then
                    Throw New Exception("Tax not yet Deducted !")
                End If
            End If

            ' Set Output Parameter
            ReDim OutParam(7)
            OutParam(0) = Voucher
            OutParam(1) = toval(OParam(0))          ' Num_Doc
            OutParam(2) = toval(OParam(1))          ' Payment_CC
            OutParam(3) = toval(OParam(2))          ' nPayment
            OutParam(4) = toval(OParam(3))          ' Nominal_CC
            OutParam(5) = toval(OParam(4))          ' Diff_CC
            OutParam(6) = toval(OParam(3)) * Rate   ' Nominal
            OutParam(7) = toval(OParam(4)) * Rate   ' Diff


            If Dataset.Tables(0).Rows.Count > 0 Then
                If Not db.ReleaseLockedObject("Voucher" & Left(tostr(Dataset.Tables(0).Rows(0)("Doc_No")), 20)) Then Throw New Exception(db.ErrDesc)
            End If

            If LockedKey <> "" Then If Not db.ReleaseLockedObject("Voucher" & LockedKey) Then Throw New Exception(db.ErrDesc)

            If Status = "U" Then
                If CBool(toval(GetAppSetting("AutoPostingJournalRVF"))) Then
                    If Not AutoPostingJournal(Voucher, SL_Cat, Branch, ErrMsg) Then Throw New Exception(ErrMsg)
                End If

                If CBool(toval(GetAppSetting("AutoPrintORF"))) Then
                    If Not Insert_Receipt_Auto_Print(Voucher, GetAppSetting("AutoPrintORSentTo")) Then
                        Throw New Exception("Can't insert into Auto Receipt Print !")
                    End If
                End If

                If CBool(toval(GetAppSetting("AutoPrintOPF"))) Then
                    If Not Insert_Payment_Auto_Print(Voucher) Then
                        Throw New Exception("Can't insert into Auto Payment Print !")
                    End If
                End If
            End If

            db.Committrans()

            CloseConnection()

            Return True
        Catch ex As Exception
            ' Set Output Parameter
            ReDim OutParam(0)
            OutParam(0) = Voucher

            ErrMsg = ex.Message
            FANotes(Voucher, "Receipt Voucher", "Save : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    Private Function AutoPostingJournal(ByVal Voucher As String, ByVal SL_Cat As String, ByVal Branch As String, ByRef ErrMsg As String) As Boolean
        Try
            Dim InParam(2) As Object
            InParam(0) = Voucher
            InParam(1) = SL_Cat
            InParam(2) = Branch

            Dim findex() As String = Nothing
            Dim fbuffer() As String = Nothing
            Dim Dataset As DataSet = Nothing

            Dim wsAccounting As New WSAccounting
            If Not wsAccounting.GetJournal(db, InParam, findex, fbuffer, Dataset, ErrMsg) Then Throw New Exception(ErrMsg)
            If Not wsAccounting.PostingJournal(db, InParam, Dataset, ErrMsg) Then Throw New Exception(ErrMsg)

            AutoPostingJournal = True

        Catch ex As Exception
            ErrMsg = ex.Message
            AutoPostingJournal = False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SaveVoucherMR(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal findex() As String, ByVal fbuffer() As String, ByVal Dataset1 As DataSet, ByVal Dataset2 As DataSet, ByVal Dataset3 As DataSet, ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Branch As String
            Dim VoucherDate As Date
            Dim Reference As String
            Dim RefNo As String

            Voucher = getInParamValue(InParam, 0)
            Branch = getInParamValue(InParam, 1)
            VoucherDate = getInParamValue(InParam, 2)
            Reference = getInParamValue(InParam, 3)
            RefNo = getInParamValue(InParam, 4)

            Dim LockedKey As String = ""
            If Voucher <> "" Then
                LockedKey = Voucher
                If Not db.GetLockedObject("Voucher" & LockedKey) Then Throw New Exception(db.ErrDesc)
            End If
            If Dataset2.Tables(0).Rows.Count > 0 Then
                If Not db.GetLockedObject("Voucher" & Left(tostr(Dataset2.Tables(0).Rows(0)("Doc_No")), 20)) Then Throw New Exception(db.ErrDesc)
            End If

            Dim rs As RemoteSet
            Dim br_Currency As String
            Dim br_Currency_1 As String
            Dim VType As String
            Dim ComAcc As String
            Dim AutoNum As String
            Dim CodeExt As String
            Dim SL_Cat As String
            Dim Currency As String
            Dim Rate As Double
            Dim Rate_RC As Double
            Dim ProAcc As String
            Dim Remarks As String
            Dim Status As String
            Dim Amount_CC As Double = 0

            Dim BudgetFeaturesF As Boolean
            rs = db.OpenRemoteSet("Select Currency, Currency_1, BudgetFeaturesF from SysTab")
            br_Currency = rs.fields("Currency")
            br_Currency_1 = rs.fields("Currency_1")
            BudgetFeaturesF = rs.fields("BudgetFeaturesF")

            VType = GetFieldValue(fbuffer(GetFieldIndex("VType", findex)))
            ComAcc = GetFieldValue(fbuffer(GetFieldIndex("ComAcc", findex)))
            Currency = GetFieldValue(fbuffer(GetFieldIndex("Currency", findex)))


            Dim RefCCYDate As Date
            RefCCYDate = todate(GetFieldValue(fbuffer(GetFieldIndex("RefCCYDate", findex))))

            Rate = exchange_rate(Currency, RefCCYDate, br_Currency)
            Rate_RC = exchange_rate_RC(Currency, RefCCYDate, br_Currency_1)

            ProAcc = GetFieldValue(fbuffer(GetFieldIndex("ProAcc", findex)))
            Remarks = GetFieldValue(fbuffer(GetFieldIndex("Remarks", findex)))

            rs = db.OpenRemoteSet("select vType, SL_Cat, AutoNum, DebtorF, CreditorF, CodeExt from vType where SL_Cat='P' and DebtorF=1 and vtype = '" & VType & "'")
            AutoNum = tostr(rs.fields("AutoNum"))
            CodeExt = tostr(rs.fields("CodeExt"))
            SL_Cat = tostr(rs.fields("SL_Cat"))

            Dim rsV As RemoteSet
            Dim EditMode As Integer
            rsV = db.OpenRemoteSet("Select * from pVoucher Where Voucher='" & Voucher & "'")
            If rsV.Eof Then
                If Not PreAddVoucherTRTP(InParam, ProAcc, ComAcc, Currency, ErrMsg) Then Throw New Exception(ErrMsg)

                Dim DocID As String
                rs = db.OpenRemoteSet("Select * from ComAcc Where ComAcc='" & ComAcc & "'")
                DocID = tostr(rs.fields("DocID"))
                If Voucher = "" Then
                    Voucher = db.GetNextDocNo(AutoNum, VoucherDate, DocID & Branch)
                End If
                If Voucher = "" Then Throw New Exception("Generate Voucher Number Failed !")

                rsV.AddNew()
            Else
                If Not PreAddVoucherTRTP(InParam, ProAcc, ComAcc, Currency, ErrMsg) Then Throw New Exception(ErrMsg)
                If Not PreEditVoucherTRTP(InParam, ErrMsg) Then Throw New Exception(ErrMsg)

                rsV.Edit()
            End If
            EditMode = rsV.editmode

            If rsV.fields("Status") = "U" Then
                If BudgetFeaturesF Then
                    If Not Update_Budget_Account_Actual(Voucher, -1) Then Throw New Exception("Update Budget Account Failed !")
                End If
            End If

            Dim i As Integer
            Dim j As Integer
            i = 0
            j = UBound(findex)
            Do While i < j
                rsV.fields(findex(i)) = GetFieldValue(fbuffer(i))
                i = i + 1
            Loop
            If EditMode = AdEditAdd Then
                rsV.fields("Branch") = Branch
                rsV.fields("CDate") = Today.Date
                rsV.fields("CTime") = Time()
                rsV.fields("UserID") = dbUser
                rsV.fields("Voucher") = Voucher
            End If
            rsV.fields("Date") = VoucherDate
            rsV.fields("Rate") = Rate
            rsV.fields("Rate_RC") = Rate_RC
            rsV.fields("ReceiptF") = True
            rsV.fields("PaymentF") = False
            rsV.fields("CreditorF") = False
            rsV.fields("DebtorF") = True
            rsV.fields("SL_Flag") = True
            rsV.fields("SL_Cat") = "P"
            rsV.fields("Num_Doc") = 0
            rsV.fields("SL_Tag") = 1
            rsV.fields("PDate") = VoucherDate
            rsV.fields("Last_Date") = Today.Date
            rsV.fields("Last_Time") = Time()
            rsV.fields("Last_Opr") = dbUser
            rsV.fields("BackDatedF") = False
            rsV.fields("Posting_Flag") = False

            Dim RefType As String
            If Dataset1.Tables(0).Rows.Count = 0 Then  ' No RV/PV
                If Dataset2.Tables(0).Rows.Count = 0 Then ' No DN/CN
                    RefType = "MEMO"
                Else
                    RefType = "COMPENSATION"    ' DN/CN Only
                End If
            ElseIf Dataset2.Tables(0).Rows.Count = 0 Then ' No DN/CN
                If Dataset1.Tables(0).Rows.Count = 0 Then ' No RV/PV
                    RefType = "MEMO"
                Else
                    RefType = "OVERPAID"  ' RV/PV Only
                End If
            Else
                RefType = "MATCHING"
            End If
            rsV.fields("RefType") = RefType
            If Not rsV.Update Then Throw New Exception(db.ErrDesc)

            Dim TaxDeductionF As Boolean = False
            Const MaxCols = 18
            Dim NumRows = Dataset1.Tables(0).Rows.Count + Dataset2.Tables(0).Rows.Count + Dataset3.Tables(0).Rows.Count
            Dim Bufferdata(NumRows - 1, MaxCols - 1) As Object
            Dim Dataset As DataSet = Nothing

            ' Check Data Record
            If NumRows = 0 Then Throw New Exception("Transaction Has No Detail !")

            Dim pos1 As Integer = 0
            Dim pos2 As Integer = 0
            Dim pos3 As Integer = 0
            Dim pos As Integer = 0

            j = 0
            For k = 1 To 3
                Select Case k
                    Case 1
                        Dataset = Dataset1
                        pos1 = j
                        pos = j
                    Case 2
                        Dataset = Dataset2
                        pos2 = j
                        pos = j
                    Case 3
                        Dataset = Dataset3
                        pos3 = j
                        pos = j
                End Select

                Dim Nominal_OC As Double
                Dim Nominal As Double
                Dim Nominator As Double
                Dim Denominator As Double
                Dim DocCCY As String

                For i = 0 To Dataset.Tables(0).Rows.Count - 1
                    Nominal_OC = toval(Dataset.Tables(0).Rows(i)("Nominal_OC"))
                    Nominator = toval(Dataset.Tables(0).Rows(i)("Nominator"))
                    Denominator = toval(Dataset.Tables(0).Rows(i)("Denominator"))
                    DocCCY = tostr(Dataset.Tables(0).Rows(i)("Doc_CCY"))

                    Nominal_OC = RoundCCY(Nominal_OC, UCase(DocCCY), toval(GetAppSetting("FARoundingDecimalValue")))
                    Nominal = RoundCCY(Math.Round(Nominal_OC * Nominator / Denominator, 4, MidpointRounding.AwayFromZero), UCase(Currency), toval(GetAppSetting("FARoundingDecimalValue")))

                    Bufferdata(pos + i, 0) = tostr(Dataset.Tables(0).Rows(i)("Doc_No"))
                    Bufferdata(pos + i, 1) = todate(Dataset.Tables(0).Rows(i)("Doc_Date"))
                    Bufferdata(pos + i, 2) = DocCCY

                    Bufferdata(pos + i, 3) = Nominal_OC
                    Bufferdata(pos + i, 4) = tostr(Dataset.Tables(0).Rows(i)("CT"))
                    Bufferdata(pos + i, 5) = Nominal
                    Bufferdata(pos + i, 6) = tostr(Dataset.Tables(0).Rows(i)("Remarks"))
                    Bufferdata(pos + i, 7) = toval(Dataset.Tables(0).Rows(i)("Hint"))
                    If toval(Dataset.Tables(0).Rows(i)("Hint")) = -14 Then
                        TaxDeductionF = True
                    End If
                    'Bufferdata(pos + i, 8) = IIf(toval(Dataset.Tables(0).Rows(i)("PaymentF")) = 0, False, True)
                    Bufferdata(pos + i, 8) = IIf(k = 1 Or k = 2, True, False)
                    Bufferdata(pos + i, 9) = tostr(Dataset.Tables(0).Rows(i)("Account"))
                    Bufferdata(pos + i, 10) = Nominator
                    Bufferdata(pos + i, 11) = Denominator
                    Bufferdata(pos + i, 12) = tostr(Dataset.Tables(0).Rows(i)("Branch"))
                    Bufferdata(pos + i, 13) = tostr(Dataset.Tables(0).Rows(i)("pVoucher"))
                    Bufferdata(pos + i, 14) = toval(Dataset.Tables(0).Rows(i)("LockedF"))
                    Bufferdata(pos + i, 15) = toval(Dataset.Tables(0).Rows(i)("FundingF"))
                    Bufferdata(pos + i, 16) = tostr(Dataset.Tables(0).Rows(i)("GID"))
                    Bufferdata(pos + i, 17) = tostr(Dataset.Tables(0).Rows(i)("Description"))
                    Amount_CC = Amount_CC + Nominal
                    j = j + 1
                Next
            Next

            ' Check Matching Amount should be Zero
            If Math.Abs(Math.Round(Amount_CC, 4, MidpointRounding.AwayFromZero)) > 0.0005 Then Throw New Exception("Total Nominal in CC Must Be Equal to Zero ! (" & Format(Math.Round(Amount_CC, 4, MidpointRounding.AwayFromZero), "###,###,###.0000") & ")")

            If CBool(toval(GetAppSetting("AutoMatchingF"))) Then
                If Not db.Execute("Select Distinct R.Voucher, R.NVoucher, nSL.Account, V.Date as Doc_Date into #RPBucket from RPBucket R, NVoucher V, nSL Where R.Voucher='" & Voucher & "' and R.NVoucher<>'' and R.Status='R' and V.Voucher=R.NVoucher and nSL.Voucher=V.Voucher") Then Throw New Exception(db.ErrDesc)
                If Not db.Execute("Create Unique Index I_RPBucket on #RPBucket(Voucher, NVoucher)") Then Throw New Exception(db.ErrDesc)
                Dataset = Dataset2
                pos = pos2
                For i = 0 To Dataset.Tables(0).Rows.Count - 1
                    rs = db.OpenRemoteSet("Select * from #RPBucket R Where R.Voucher='" & Voucher & "' and R.NVoucher='" & Bufferdata(pos + i, 0) & "'")
                    If Not rs.Eof Then
                        Bufferdata(pos + i, 1) = todate(rs.fields("Doc_Date"))
                        Bufferdata(pos + i, 8) = True
                        Bufferdata(pos + i, 9) = tostr(rs.fields("Account"))
                    End If
                Next
                If Not db.Execute("Drop table #RPBucket") Then Throw New Exception(db.ErrDesc)

                If Not Delete_Auto_Receipt_Payment(Voucher) Then Throw New Exception("Delete Auto Matching Failed !")

                For i = 0 To Dataset.Tables(0).Rows.Count - 1
                    If DateDiff(DateInterval.Day, todate(Bufferdata(pos + i, 1)), VoucherDate) < 0 AndAlso toval(Bufferdata(pos + i, 8)) Then
                        rs = db.OpenRemoteSet("Select V.Account, A1.Type, A1.Subject from Admlink A1, vPattern V, Account A2 Where A1.Voucher='" & Bufferdata(pos + i, 0) & "' and A2.Account=V.Account and A2.suspend_Flag=1 and V.Credit=" & toval(Bufferdata(pos + i, 7)) & " and V.VType='" & VType & "'")
                        If Not rs.Eof AndAlso InStr("DIICIRITIXPDBBBABOBCBPBDDCCPXPQSQPS1S2S3AFFOFP", tostr(rs.fields("Type")).ToUpper) <> 0 AndAlso tostr(rs.fields("Subject")).ToUpper = "PREMIUM" Then
                            If Insert_Auto_Receipt_Payment(Voucher, tostr(rs.fields("Account")), Bufferdata(pos + i, 0), toval(Bufferdata(pos + i, 5)), todate(Bufferdata(pos + i, 1)), toval(Bufferdata(pos + i, 10)) / toval(Bufferdata(pos + i, 11)), True) Then
                                Bufferdata(pos + i, 1) = VoucherDate
                                Bufferdata(pos + i, 8) = False
                                Bufferdata(pos + i, 9) = tostr(rs.fields("Account"))
                            End If
                        End If
                    End If
                Next

            End If

            Dim Param(12) As Object
            Param(0) = Voucher
            Param(1) = VoucherDate
            Param(2) = VType
            Param(3) = Currency
            Param(4) = Branch
            Param(5) = Rate
            Param(6) = ProAcc
            Param(7) = Reference
            Param(8) = RefNo
            Param(9) = Remarks
            Param(10) = IIf(EditMode = AdEditAdd, "ADD", "EDIT")
            Param(11) = Rate_RC
            Param(12) = rsV.fields("CT")

            Dim OParam As Object = Nothing

            Const MaxRows_2 = 100
            Const MaxCols_2 = 3
            Dim bufferdata_2(MaxRows_2 - 1, MaxCols_2 - 1) As Object

            OParam = Me.Direct_Call_Process_Execute("ProcessFAExt.NetV3.Proclib", "SAVE_DETAIL_TR", Param, TrimBuffer(Bufferdata), TrimBuffer(bufferdata_2))
            If TypeName(OParam) <> "Object()" Then Throw New Exception(Me.ErrDesc)

            ' see fields to buffer for converting date field

            ' Refreshing Data
            rsV.Edit()
            rsV.fields("Num_Doc") = toval(OParam(0))
            rsV.fields("Payment_CC") = toval(OParam(1))
            rsV.fields("nPayment") = toval(OParam(2))
            rsV.fields("Nominal_CC") = toval(OParam(3))
            rsV.fields("Diff_CC") = toval(OParam(4))
            rsV.fields("Nominal") = toval(OParam(3)) * Rate
            rsV.fields("Diff") = toval(OParam(4)) * Rate

            If Not db.GetPrivileges("ALLOWMATCHING") Then
                Status = "N"
            Else
                Status = "U"
            End If
            rsV.fields("Status") = Status
            If Status = "U" Then
                rsV.fields("AUserID") = dbUser
                rsV.fields("AUserDate") = Today.Date
                rsV.fields("AUserID_Ext") = dbUser
                rsV.fields("AUserDate_Ext") = Today.Date
            End If
            If Not rsV.Update Then Throw New Exception(db.ErrDesc)

            ' Update References
            If rsV.fields("RefType") = "CHEQUE" Or rsV.fields("RefType") = "GIRO" Then
                If Not db.Execute("Update Cheque Set Status='D', Voucher='" & Voucher & "' where Cheque.Status Not in ('D','L') and Cheque.WriteF=0 and Cheque.RefNo='" & RefNo & "' and Cheque.ProAcc='" & ProAcc & "'") Then Throw New Exception(db.ErrDesc)
            End If

            ' Update References
            Select Case Reference
                Case "REQUEST"
                    If Not db.Execute("Update Request Set Voucher='" & Voucher & "' from Request Where Request='" & RefNo & "' and Status<>'C' and (Voucher='' or Voucher='" & Voucher & "')") Then Throw New Exception(db.ErrDesc)
                    If db.RecordsAffected = 0 Then Throw New Exception("No Request Document Updated !")
                Case "LISTREQUEST"
                    If Not db.Execute("Update Request Set Voucher='" & Voucher & "' from Request Where Request in " & RefNo & " and Status<>'C' and (Voucher='' or Voucher='" & Voucher & "')") Then Throw New Exception(db.ErrDesc)
                    If db.RecordsAffected = 0 Then Throw New Exception("No Request Document Updated !")
            End Select

            If rsV.fields("Status") = "U" Then
                If BudgetFeaturesF Then
                    If Not Update_Budget_Account_Actual(Voucher, 1) Then Throw New Exception("Update Budget Account Failed !")
                End If
            End If

            If Not TaxDeductionF AndAlso CBool(toval(GetAppSetting("CheckTaxDeductionF"))) Then
                Dim SQL As String
                SQL = "Select sum(Admlink.PNominal_Tax/Admlink.Amount*pSL.Nominal*TaxType.TaxRate/100) as TaxNominal"
                SQL = SQL & " from Admlink, nVoucher, OSL('" & Voucher & "') pSL, pVoucher, Profile, TaxType, MParam"
                SQL = SQL & " Where MParam.Type=Admlink.Type and Admlink.Voucher=nVoucher.Voucher and Admlink.Amount_14=0 and nVoucher.TaxF=1 and nVoucher.Voucher=pSL.Doc_No and pSL.PaymentF=1 and pVoucher.Voucher=pSL.Voucher and pVoucher.Voucher='" & Voucher & "'"
                SQL = SQL & " and Profile.ID=Admlink.ID and TaxType.TaxType=dbo.Get_TaxType(Profile.TaxType,Profile.ID,pVoucher.Date, '',0, MParam.TaxDiscount) "
                SQL = SQL & " and not ('" & Format(VoucherDate, "MM/DD/YYYY") & "' Between coalesce(Profile.TaxHSDate,'01/01/1900') and coalesce(Profile.TaxHEDate,'01/01/1900'))"
                rs = db.OpenRemoteSet(SQL)
                If Math.Round(toval(rs.fields("TaxNominal")), 4, MidpointRounding.AwayFromZero) <> 0 Then
                    Throw New Exception("Tax not yet Deducted !")
                End If
            End If

            ' Set Output Parameter
            ReDim OutParam(7)
            OutParam(0) = Voucher
            OutParam(1) = toval(OParam(0))          ' Num_Doc
            OutParam(2) = toval(OParam(1))          ' Payment_CC
            OutParam(3) = toval(OParam(2))          ' nPayment
            OutParam(4) = toval(OParam(3))          ' Nominal_CC
            OutParam(5) = toval(OParam(4))          ' Diff_CC
            OutParam(6) = toval(OParam(3)) * Rate   ' Nominal
            OutParam(7) = toval(OParam(4)) * Rate   ' Diff

            If Dataset2.Tables(0).Rows.Count > 0 Then
                If Not db.ReleaseLockedObject("Voucher" & Left(tostr(Dataset2.Tables(0).Rows(0)("Doc_No")), 20)) Then Throw New Exception(db.ErrDesc)
            End If
            If LockedKey <> "" Then If Not db.ReleaseLockedObject("Voucher" & LockedKey) Then Throw New Exception(db.ErrDesc)

            If Status = "U" Then
                If CBool(toval(GetAppSetting("AutoPostingJournalMRF"))) Then
                    If Not AutoPostingJournal(Voucher, SL_Cat, Branch, ErrMsg) Then Throw New Exception(ErrMsg)
                End If

                If CBool(toval(GetAppSetting("AutoPrintORF"))) Then
                    If Not Insert_Receipt_Auto_Print(Voucher, GetAppSetting("AutoPrintORSentTo")) Then
                        Throw New Exception("Can't insert into Auto Receipt Print !")
                    End If
                End If

                If CBool(toval(GetAppSetting("AutoPrintOPF"))) Then
                    If Not Insert_Payment_Auto_Print(Voucher) Then
                        Throw New Exception("Can't insert into Auto Payment Print !")
                    End If
                End If
            End If

            db.Committrans()
            CloseConnection()

            Return True
        Catch ex As Exception
            ' Set Output Parameter
            ReDim OutParam(0)
            OutParam(0) = Voucher

            ErrMsg = ex.Message
            FANotes(Voucher, "Matching Voucher", "Save : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    Private Function SaveVoucherTP(ByVal InParam As Object(), ByRef OutParam As Object(), ByVal findex() As String, ByVal fbuffer() As String, ByVal Dataset As DataSet, ByVal DsDetail As DataSet, ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            ' Get Input Parameter
            Dim Branch As String
            Dim VoucherDate As Date
            Dim Reference As String
            Dim RefNo As String

            Voucher = getInParamValue(InParam, 0)
            Branch = getInParamValue(InParam, 1)
            VoucherDate = getInParamValue(InParam, 2)
            Reference = getInParamValue(InParam, 3)
            RefNo = getInParamValue(InParam, 4)

            Dim LockedKey As String = ""
            If Voucher <> "" Then
                LockedKey = Voucher
                If Not db.GetLockedObject("Voucher" & LockedKey) Then Throw New Exception(db.ErrDesc)
            End If
            If Dataset.Tables(0).Rows.Count > 0 Then
                If Not db.GetLockedObject("Voucher" & Left(tostr(Dataset.Tables(0).Rows(0)("Doc_No")), 20)) Then Throw New Exception(db.ErrDesc)
            End If

            Dim rs As RemoteSet
            Dim br_Currency As String
            Dim br_Currency_1 As String
            Dim VType As String
            Dim ComAcc As String
            Dim AutoNum As String
            Dim CodeExt As String
            Dim SL_Cat As String
            Dim Currency As String
            Dim Rate As Double
            Dim Rate_RC As Double
            Dim ProAcc As String
            Dim Remarks As String
            Dim Status As String
            Dim Bank As String
            Dim BankBranch As String

            Dim BudgetFeaturesF As Boolean
            Dim CheckCBBalanceF As Boolean
            rs = db.OpenRemoteSet("Select Currency, Currency_1, BudgetFeaturesF, CheckCBBalanceF from SysTab")
            br_Currency = rs.fields("Currency")
            br_Currency_1 = rs.fields("Currency_1")
            BudgetFeaturesF = rs.fields("BudgetFeaturesF")
            CheckCBBalanceF = rs.fields("CheckCBBalanceF")

            VType = GetFieldValue(fbuffer(GetFieldIndex("VType", findex)))
            ComAcc = GetFieldValue(fbuffer(GetFieldIndex("ComAcc", findex)))
            Currency = GetFieldValue(fbuffer(GetFieldIndex("Currency", findex)))

            Dim RefCCYDate As Date
            RefCCYDate = todate(GetFieldValue(fbuffer(GetFieldIndex("RefCCYDate", findex))))

            Rate = exchange_rate(Currency, RefCCYDate, br_Currency)
            Rate_RC = exchange_rate_RC(Currency, RefCCYDate, br_Currency_1)

            ProAcc = GetFieldValue(fbuffer(GetFieldIndex("ProAcc", findex)))
            Remarks = GetFieldValue(fbuffer(GetFieldIndex("Remarks", findex)))

            rs = db.OpenRemoteSet("select vType, SL_Cat, AutoNum, DebtorF, CreditorF, CodeExt from vType where SL_Cat='P' and CreditorF=1 and vtype = '" & VType & "'")
            AutoNum = tostr(rs.fields("AutoNum"))
            CodeExt = tostr(rs.fields("CodeExt"))
            SL_Cat = tostr(rs.fields("SL_Cat"))

            rs = db.OpenRemoteSet("Select Bank, BankBranch from ProAcc Where ProAcc='" & ProAcc & "'")
            Bank = rs.fields("Bank")
            BankBranch = rs.fields("BankBranch")

            Dim rsV As RemoteSet
            Dim EditMode As Integer
            rsV = db.OpenRemoteSet("Select * from pVoucher Where Voucher='" & Voucher & "'")
            If rsV.Eof Then
                If Not PreAddVoucherTRTP(InParam, ProAcc, ComAcc, Currency, ErrMsg) Then Throw New Exception(ErrMsg)

                Dim DocID As String
                rs = db.OpenRemoteSet("Select * from ComAcc Where ComAcc='" & ComAcc & "'")
                DocID = tostr(rs.fields("DocID"))
                If Voucher = "" Then
                    Voucher = db.GetNextDocNo(AutoNum, VoucherDate, DocID & Branch)
                End If
                If Voucher = "" Then Throw New Exception("Generate Voucher Number Failed !")

                rsV.AddNew()
            Else
                If Not PreAddVoucherTRTP(InParam, ProAcc, ComAcc, Currency, ErrMsg) Then Throw New Exception(ErrMsg)
                If Not PreEditVoucherTRTP(InParam, ErrMsg) Then Throw New Exception(ErrMsg)

                If toval(GetFieldValue(fbuffer(GetFieldIndex("Nominal_CC", findex)))) - toval(GetFieldValue(fbuffer(GetFieldIndex("Diff_CC", findex)))) <> toval(rsV.fields("Nominal_CC")) - toval(rsV.fields("Diff_CC")) Then
                    If Not db.GetPrivileges("ALLOWCHANGEPAYMENT") Then
                        ErrMsg = "Not Allowed To Change Payment Amount !"
                        Throw New Exception(ErrMsg)
                    End If
                End If

                rsV.Edit()
            End If
            EditMode = rsV.editmode

            If rsV.fields("Status") = "U" Then
                If BudgetFeaturesF Then
                    If Not Update_Budget_Account_Actual(Voucher, -1) Then Throw New Exception("Update Budget Account Failed !")
                End If
            End If

            Dim i As Integer
            Dim j As Integer
            i = 0
            j = UBound(findex)
            Do While i < j
                rsV.fields(findex(i)) = GetFieldValue(fbuffer(i))
                i = i + 1
            Loop
            If Not db.GetPrivileges("ALLOWPASSSCANPAN") Then
                If isContainRestrictedPAN(rsV.fields("AccountNo")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field AccountNo!")
                End If
                If isContainRestrictedPAN(rsV.fields("REFNO")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field REFNO!")
                End If
                If isContainRestrictedPAN(rsV.fields("REMARKS")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field REMARKS!")
                End If
            End If
            If EditMode = AdEditAdd Then
                rsV.fields("Branch") = Branch
                rsV.fields("CDate") = Today.Date
                rsV.fields("CTime") = Time()
                rsV.fields("UserID") = dbUser
                rsV.fields("Voucher") = Voucher
                rsV.fields("RequestF") = False
                rsV.fields("RequestMessage") = ""
                rsV.fields("RequestName") = ""
                rsV.fields("AUserID") = ""
                rsV.fields("AUserDate") = ""
                rsV.fields("AUserID_Ext") = ""
                rsV.fields("AUserDate_Ext") = ""
                rsV.fields("VerifiedBy") = ""
                rsV.fields("OtorizedBy") = ""
                rsV.fields("Otorized2By") = ""
                rsV.fields("AcceptedBy") = ""
                rsV.fields("VerifiedByTitle") = ""
                rsV.fields("OtorizedByTitle") = ""
                rsV.fields("Otorized2ByTitle") = ""
            End If
            rsV.fields("Date") = VoucherDate
            rsV.fields("Rate") = Rate
            rsV.fields("Rate_RC") = Rate_RC
            rsV.fields("ReceiptF") = False
            rsV.fields("PaymentF") = True
            rsV.fields("CreditorF") = True
            rsV.fields("DebtorF") = False
            rsV.fields("SL_Flag") = True
            rsV.fields("SL_Cat") = "P"
            rsV.fields("Num_Doc") = 0
            rsV.fields("SL_Tag") = 1
            rsV.fields("Bank") = Bank
            rsV.fields("BankBranch") = BankBranch
            rsV.fields("PDate") = VoucherDate
            rsV.fields("Last_Date") = Today.Date
            rsV.fields("Last_Time") = Time()
            rsV.fields("Last_Opr") = dbUser
            rsV.fields("BackDatedF") = False
            rsV.fields("Posting_Flag") = False
            If Not rsV.Update Then Throw New Exception(db.ErrDesc)

            Dim TaxDeductionF As Boolean = False
            Const MaxCols = 18
            Dim Bufferdata(Dataset.Tables(0).Rows.Count - 1, MaxCols - 1) As Object
            For i = 0 To Dataset.Tables(0).Rows.Count - 1
                Bufferdata(i, 0) = tostr(Dataset.Tables(0).Rows(i)("Doc_No"))
                Bufferdata(i, 1) = todate(Dataset.Tables(0).Rows(i)("Doc_Date"))
                Bufferdata(i, 2) = tostr(Dataset.Tables(0).Rows(i)("Doc_CCY"))
                Bufferdata(i, 3) = RoundCCY(toval(Dataset.Tables(0).Rows(i)("Nominal_OC")), UCase(tostr(Dataset.Tables(0).Rows(i)("Doc_CCY"))), toval(GetAppSetting("FARoundingDecimalValue")))
                Bufferdata(i, 4) = tostr(Dataset.Tables(0).Rows(i)("CT"))
                Bufferdata(i, 5) = RoundCCY(toval(Dataset.Tables(0).Rows(i)("Nominal")), UCase(Currency), toval(GetAppSetting("FARoundingDecimalValue")))
                Bufferdata(i, 6) = tostr(Dataset.Tables(0).Rows(i)("Remarks"))
                Bufferdata(i, 7) = toval(Dataset.Tables(0).Rows(i)("Hint"))
                If toval(Dataset.Tables(0).Rows(i)("Hint")) = -14 Then
                    TaxDeductionF = True
                End If
                Bufferdata(i, 8) = IIf(toval(Dataset.Tables(0).Rows(i)("PaymentF")) = 0, False, True)
                Bufferdata(i, 9) = tostr(Dataset.Tables(0).Rows(i)("Account"))
                Bufferdata(i, 10) = toval(Dataset.Tables(0).Rows(i)("Nominator"))
                Bufferdata(i, 11) = toval(Dataset.Tables(0).Rows(i)("Denominator"))
                Bufferdata(i, 12) = tostr(Dataset.Tables(0).Rows(i)("Branch"))
                Bufferdata(i, 13) = tostr(Dataset.Tables(0).Rows(i)("pVoucher"))
                Bufferdata(i, 14) = toval(Dataset.Tables(0).Rows(i)("LockedF"))
                Bufferdata(i, 15) = toval(Dataset.Tables(0).Rows(i)("FundingF"))
                Bufferdata(i, 16) = tostr(Dataset.Tables(0).Rows(i)("GID"))
                Bufferdata(i, 17) = tostr(Dataset.Tables(0).Rows(i)("Description"))
            Next

            If CBool(toval(GetAppSetting("AutoMatchingF"))) Then
                If Not db.Execute("Select Distinct R.Voucher, R.NVoucher, nSL.Account, V.Date as Doc_Date into #RPBucket from RPBucket R, NVoucher V, nSL Where R.Voucher='" & Voucher & "' and R.NVoucher<>'' and R.Status='R' and V.Voucher=R.NVoucher and nSL.Voucher=V.Voucher") Then Throw New Exception(db.ErrDesc)
                If Not db.Execute("Create Unique Index I_RPBucket on #RPBucket(Voucher, NVoucher)") Then Throw New Exception(db.ErrDesc)
                For i = 0 To Dataset.Tables(0).Rows.Count - 1
                    rs = db.OpenRemoteSet("Select * from #RPBucket R Where R.Voucher='" & Voucher & "' and R.NVoucher='" & Bufferdata(i, 0) & "'")
                    If Not rs.Eof Then
                        Bufferdata(i, 1) = todate(rs.fields("Doc_Date"))
                        Bufferdata(i, 8) = True
                        Bufferdata(i, 9) = tostr(rs.fields("Account"))
                    End If
                Next
                If Not db.Execute("Drop table #RPBucket") Then Throw New Exception(db.ErrDesc)

                If Not Delete_Auto_Receipt_Payment(Voucher) Then Throw New Exception("Delete Auto Matching Failed !")

                For i = 0 To Dataset.Tables(0).Rows.Count - 1
                    If DateDiff(DateInterval.Day, todate(Bufferdata(i, 1)), VoucherDate) < 0 AndAlso toval(Bufferdata(i, 8)) Then
                        rs = db.OpenRemoteSet("Select V.Account, A1.Type, A1.Subject from Admlink A1, vPattern V, Account A2 Where A1.Voucher='" & Bufferdata(i, 0) & "' and A2.Account=V.Account and A2.suspend_Flag=1 and V.Debit=" & toval(Bufferdata(i, 7)) & " and V.VType='" & VType & "'")
                        If Not rs.Eof AndAlso InStr("DIICIRITIXPDBBBABOBCBPBDDCCPXPQSQPS1S2S3AFFOFP", tostr(rs.fields("Type")).ToUpper) <> 0 AndAlso tostr(rs.fields("Subject")).ToUpper = "PREMIUM" Then
                            If Insert_Auto_Receipt_Payment(Voucher, tostr(rs.fields("Account")), Bufferdata(i, 0), -toval(Bufferdata(i, 5)), todate(Bufferdata(i, 1)), toval(Bufferdata(i, 10)) / toval(Bufferdata(i, 11)), True) Then
                                Bufferdata(i, 1) = VoucherDate
                                Bufferdata(i, 8) = False
                                Bufferdata(i, 9) = tostr(rs.fields("Account"))
                            End If
                        End If
                    End If
                Next

            End If

            Dim Param(12) As Object
            Param(0) = Voucher
            Param(1) = VoucherDate
            Param(2) = VType
            Param(3) = Currency
            Param(4) = Branch
            Param(5) = Rate
            Param(6) = ProAcc
            Param(7) = Reference
            Param(8) = RefNo
            Param(9) = Remarks
            Param(10) = IIf(EditMode = AdEditAdd, "ADD", "EDIT")
            Param(11) = Rate_RC
            Param(12) = rsV.fields("CT")

            Dim OParam As Object = Nothing

            Const MaxRows_2 = 100
            Const MaxCols_2 = 7
            Dim bufferdata_2(MaxRows_2 - 1, MaxCols_2 - 1) As Object
            If Not DsDetail Is Nothing Then
                For i = 0 To DsDetail.Tables(0).Rows.Count - 1
                    bufferdata_2(i, 0) = tostr(DsDetail.Tables(0).Rows(i)("RefDate"))
                    bufferdata_2(i, 1) = tostr(DsDetail.Tables(0).Rows(i)("Description"))
                    bufferdata_2(i, 2) = toval(DsDetail.Tables(0).Rows(i)("Nominal"))
                    bufferdata_2(i, 3) = tostr(DsDetail.Tables(0).Rows(i)("RefNo"))
                    bufferdata_2(i, 4) = tostr(DsDetail.Tables(0).Rows(i)("RefType"))
                    bufferdata_2(i, 5) = tostr(DsDetail.Tables(0).Rows(i)("RefStatus"))
                    bufferdata_2(i, 6) = tostr(DsDetail.Tables(0).Rows(i)("DocRefNo"))
                Next
            End If
            If Not Remove_Cheque_Vouchered(Voucher, ErrMsg) Then Throw New Exception(ErrMsg)

            OParam = Me.Direct_Call_Process_Execute("ProcessFAExt.NetV3.Proclib", "SAVE_DETAIL_TP", Param, TrimBuffer(Bufferdata), TrimBuffer(bufferdata_2))
            If TypeName(OParam) <> "Object()" Then Throw New Exception(Me.ErrDesc)

            If Not Update_Cheque_Vouchered(Voucher, ErrMsg) Then Throw New Exception(ErrMsg)

            ' see fields to buffer for converting date field

            ' Refreshing Data
            rsV.Edit()
            rsV.fields("Num_Doc") = toval(OParam(0))
            rsV.fields("Payment_CC") = toval(OParam(1))
            rsV.fields("nPayment") = toval(OParam(2))
            rsV.fields("Nominal_CC") = toval(OParam(3))
            rsV.fields("Diff_CC") = toval(OParam(4))
            rsV.fields("Nominal") = toval(OParam(3)) * Rate
            rsV.fields("Diff") = toval(OParam(4)) * Rate

            Dim TotalAmount As Double
            TotalAmount = rsV.fields("Nominal") - rsV.fields("Diff")
            If Not GetApprovalLimitFA(dbUser, VType, "Out", TotalAmount) Or (TotalAmount = 0 And Not db.GetPrivileges("ALLOWZEROPAYMENT")) Or (TotalAmount <> 0 And Not db.GetPrivileges("ALLOWNONZEROPAYMENT")) Or Not db.GetPrivileges("ALLOWPAYMENT") Then
                Status = "N"    ' Not Approved
            Else
                Status = "U"    ' Ok Approved, Un-Posting
            End If
            rsV.fields("Status") = Status
            If Status = "U" Then
                rsV.fields("AUserID") = dbUser
                rsV.fields("AUserDate") = Today.Date
                rsV.fields("AUserID_Ext") = dbUser
                rsV.fields("AUserDate_Ext") = Today.Date
            End If
            If Not rsV.Update Then Throw New Exception(db.ErrDesc)

            ' Update References
            If rsV.fields("RefType") = "CHEQUE" Or rsV.fields("RefType") = "GIRO" Then
                Select Case Reference
                    Case "REQUEST"
                        If Not db.Execute("Update Cheque Set Status='D', Voucher='" & Voucher & "' where Cheque.Status Not in ('D','L') and Cheque.WriteF=0 and Cheque.RefNo='" & RefNo & "' and Cheque.ProAcc='" & ProAcc & "'") Then Throw New Exception(db.ErrDesc)
                    Case "LISTREQUEST"
                        If Not db.Execute("Update Cheque Set Status='D', Voucher='" & Voucher & "' where Cheque.Status Not in ('D','L') and Cheque.WriteF=0 and Cheque.RefNo in " & RefNo & " and Cheque.ProAcc='" & ProAcc & "'") Then Throw New Exception(db.ErrDesc)
                End Select
            End If

            ' Update References
            Select Case Reference
                Case "REQUEST"
                    If Not db.Execute("Update Request Set Voucher='" & Voucher & "' from Request Where Request='" & RefNo & "' and Status<>'C' and (Voucher='' or Voucher='" & Voucher & "')") Then Throw New Exception(db.ErrDesc)
                    If db.RecordsAffected = 0 Then Throw New Exception("No Request Document Updated !")
                Case "LISTREQUEST"
                    If Not db.Execute("Update Request Set Voucher='" & Voucher & "' from Request Where Request in " & RefNo & " and Status<>'C' and (Voucher='' or Voucher='" & Voucher & "')") Then Throw New Exception(db.ErrDesc)
                    If db.RecordsAffected = 0 Then Throw New Exception("No Request Document Updated !")
            End Select

            If EditMode = AdEditAdd AndAlso (Reference = "REQUEST" Or Reference = "LISTREQUEST") Then
                rs = db.OpenRemoteSet("Select R2.ImageID, R2.FileType, R2.Title, R2.Remark, R2.Last_Opr, R2.Last_Update from Request R1, RequestPIC R2 Where R2.Request=R1.Request and R1.Voucher='" & Voucher & "'")
                If Not rs.Eof Then
                    Dim ws As New localhost6.WSCommon(GetAppSetting("CareWSImage"))
                    ws.Timeout = System.Threading.Timeout.Infinite

                    Dim rsPic As RemoteSet
                    rsPic = db.OpenRemoteSet("Select * from VoucherPIC Where 1<>1")
                    Do While Not rs.Eof

                        Dim DataBuffer() As Byte = Nothing
                        Dim ImageID As Long = rs.fields("ImageID")
                        Dim NewImageID As Long = 0

                        'Dim ParamI(1) As Object
                        'Dim ParamO As Object = Nothing

                        'ParamI(0) = ImageID
                        'If Not ws.GetPictureBinary(dbUser, dbPassword, ParamI, ParamO, ErrMsg) Then Throw New Exception(ErrMsg)
                        'DataBuffer = ParamO(0)

                        'ParamI(0) = NewImageID
                        'ParamI(1) = DataBuffer
                        'If Not ws.SaveDocument(dbUser, dbPassword, ParamI, ParamO, ErrMsg) Then Throw New Exception(ErrMsg)
                        'NewImageID = ParamO(0)

                        rsPic.AddNew()
                        rsPic.fields("Voucher") = Voucher
                        rsPic.fields("ImageID") = ImageID
                        rsPic.fields("FileType") = rs.fields("FileType")
                        rsPic.fields("Title") = rs.fields("Title")
                        rsPic.fields("Remark") = rs.fields("Remark")
                        rsPic.fields("Last_Opr") = dbUser
                        rsPic.fields("Last_Update") = Today.Date
                        If Not rsPic.UpdateRow Then Throw New Exception(db.ErrDesc)
                        rs.MoveNext()
                    Loop
                    If Not rsPic.Eof Then
                        If Not rsPic.Update Then Throw New Exception(db.ErrDesc)
                    End If
                End If
            End If

            If rsV.fields("Status") = "U" Then
                If BudgetFeaturesF Then
                    If Not db.GetPrivileges("ALLOWPASSCHECKBUDGET") Then
                        If Not Check_Voucher_Budget_Account(Voucher) Then Throw New Exception("Check Budget Account Failed !" & StrMsg)
                    End If
                    If Not Update_Budget_Account_Actual(Voucher, 1) Then Throw New Exception("Update Budget Account Failed !")
                End If
                If Not db.Execute("Update ProAcc Set RestrictedF=RESTRICTAFTERUSEDF Where ProAcc='" & ProAcc & "'") Then Throw New Exception(db.ErrDesc)

                If CheckCBBalanceF Then
                    If Not Check_Voucher_Company_Account(Voucher) Then Throw New Exception("Check Company Account Failed !" & StrMsg)
                End If
            End If

            If Not TaxDeductionF AndAlso CBool(toval(GetAppSetting("CheckTaxDeductionF"))) Then
                Dim SQL As String
                SQL = "Select sum(Admlink.PNominal_Tax/Admlink.Amount*pSL.Nominal*TaxType.TaxRate/100) as TaxNominal"
                SQL = SQL & " from Admlink, nVoucher, OSL('" & Voucher & "') pSL, pVoucher, Profile, TaxType, MParam"
                SQL = SQL & " Where MParam.Type=Admlink.Type and Admlink.Voucher=nVoucher.Voucher and Admlink.Amount_14=0 and nVoucher.TaxF=1 and nVoucher.Voucher=pSL.Doc_No and pSL.PaymentF=1 and pVoucher.Voucher=pSL.Voucher and pVoucher.Voucher='" & Voucher & "'"
                SQL = SQL & " and Profile.ID=Admlink.ID and TaxType.TaxType=dbo.Get_TaxType(Profile.TaxType,Profile.ID,pVoucher.Date, '',0, MParam.TaxDiscount) "
                SQL = SQL & " and not ('" & Format(VoucherDate, "MM/DD/YYYY") & "' Between coalesce(Profile.TaxHSDate,'01/01/1900') and coalesce(Profile.TaxHEDate,'01/01/1900'))"
                rs = db.OpenRemoteSet(SQL)
                If Math.Round(toval(rs.fields("TaxNominal")), 4, MidpointRounding.AwayFromZero) <> 0 Then
                    Throw New Exception("Tax not yet Deducted !")
                End If
            End If

            ' Set Output Parameter
            ReDim OutParam(7)
            OutParam(0) = Voucher
            OutParam(1) = toval(OParam(0))          ' Num_Doc
            OutParam(2) = toval(OParam(1))          ' Payment_CC
            OutParam(3) = toval(OParam(2))          ' nPayment
            OutParam(4) = toval(OParam(3))          ' Nominal_CC
            OutParam(5) = toval(OParam(4))          ' Diff_CC
            OutParam(6) = toval(OParam(3)) * Rate   ' Nominal
            OutParam(7) = toval(OParam(4)) * Rate   ' Diff

            If Dataset.Tables(0).Rows.Count > 0 Then
                If Not db.ReleaseLockedObject("Voucher" & Left(tostr(Dataset.Tables(0).Rows(0)("Doc_No")), 20)) Then Throw New Exception(db.ErrDesc)
            End If
            If LockedKey <> "" Then If Not db.ReleaseLockedObject("Voucher" & LockedKey) Then Throw New Exception(db.ErrDesc)

            If Status = "U" Then
                If CBool(toval(GetAppSetting("AutoPostingJournalPVF"))) Then
                    If Not AutoPostingJournal(Voucher, SL_Cat, Branch, ErrMsg) Then Throw New Exception(ErrMsg)
                End If

                If CBool(toval(GetAppSetting("AutoPrintORF"))) Then
                    If Not Insert_Receipt_Auto_Print(Voucher, GetAppSetting("AutoPrintORSentTo")) Then
                        Throw New Exception("Can't insert into Auto Receipt Print !")
                    End If
                End If

                If CBool(toval(GetAppSetting("AutoPrintOPF"))) Then
                    If Not Insert_Payment_Auto_Print(Voucher) Then
                        Throw New Exception("Can't insert into Auto Payment Print !")
                    End If
                End If

                If CBool(toval(GetAppSetting("EMailPaymentNotification"))) Then
                    SendPaymentNotification(Voucher, "APPROVED")
                End If
            End If

            Return True
        Catch ex As Exception
            ' Set Output Parameter
            ReDim OutParam(0)
            OutParam(0) = Voucher
            ErrMsg = ex.Message
            FANotes(Voucher, "Payment Voucher", "Save : " & ErrMsg)
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SaveVoucherTP(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal findex() As String, ByVal fbuffer() As String, ByVal Dataset As DataSet, ByVal DsDetail As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            If Not SaveVoucherTP(InParam, OutParam, findex, fbuffer, Dataset, DsDetail, ErrMsg) Then
                Throw New Exception(ErrMsg)
            End If

            db.Committrans()

            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function


    <WebMethod(EnableSession:=False)> _
    Public Function SaveDetailReference(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal DsDetail As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String

            Voucher = getInParamValue(InParam, 0)

            Dim LockedKey As String = ""
            If Voucher <> "" Then
                LockedKey = Voucher
                If Not db.GetLockedObject("Voucher" & LockedKey) Then Throw New Exception(db.ErrDesc)
            End If

            If Not Remove_Cheque_Vouchered(Voucher, ErrMsg) Then Throw New Exception(ErrMsg)

            If Not DsDetail Is Nothing Then
                Dim rs As RemoteSet
                If Not db.Execute("Delete from pSLRef Where Voucher='" & tostr(Voucher) & "'") Then Throw New Exception(db.ErrDesc)
                rs = db.OpenRemoteSet("Select * from pSLRef where 1<>1")

                For i = 0 To DsDetail.Tables(0).Rows.Count - 1
                    If tostr(DsDetail.Tables(0).Rows(i)("RefDate")) <> "" And tostr(DsDetail.Tables(0).Rows(i)("Description")) <> "" Then
                        rs.AddNew()
                        rs.fields("Voucher") = Voucher
                        rs.fields("RefDate") = todate(DsDetail.Tables(0).Rows(i)("RefDate"))
                        rs.fields("Description") = tostr(DsDetail.Tables(0).Rows(i)("Description"))
                        rs.fields("Nominal") = toval(DsDetail.Tables(0).Rows(i)("Nominal"))
                        rs.fields("RefNo") = tostr(DsDetail.Tables(0).Rows(i)("RefNo"))
                        rs.fields("RefType") = tostr(DsDetail.Tables(0).Rows(i)("RefType"))
                        rs.fields("DocRefNo") = tostr(DsDetail.Tables(0).Rows(i)("DocRefNo"))
                        rs.fields("RefStatus") = tostr(DsDetail.Tables(0).Rows(i)("RefStatus"))
                        If Not rs.UpdateRow Then Throw New Exception(rs.ErrDesc)
                    End If
                Next
                If Not rs.Eof Then
                    If Not rs.Update Then Throw New Exception(db.ErrDesc)
                End If

            End If

            If Not Update_Cheque_Vouchered(Voucher, ErrMsg) Then Throw New Exception(ErrMsg)

            If LockedKey <> "" Then If Not db.ReleaseLockedObject("Voucher" & LockedKey) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function SaveRequestDetailReference(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal DsDetail As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Request As String

            Request = getInParamValue(InParam, 0)

            Dim LockedKey As String = ""
            If Request <> "" Then
                LockedKey = Request
                If Not db.GetLockedObject("Request" & LockedKey) Then Throw New Exception(db.ErrDesc)
            End If

            If Not DsDetail Is Nothing Then
                Dim rs As RemoteSet
                If Not db.Execute("Delete from SL_RequestRef Where Request='" & tostr(Request) & "'") Then Throw New Exception(db.ErrDesc)
                rs = db.OpenRemoteSet("Select * from SL_RequestRef where 1<>1")

                For i = 0 To DsDetail.Tables(0).Rows.Count - 1
                    If tostr(DsDetail.Tables(0).Rows(i)("RefDate")) <> "" And tostr(DsDetail.Tables(0).Rows(i)("Description")) <> "" Then
                        rs.AddNew()
                        rs.fields("Request") = Request
                        rs.fields("RefDate") = todate(DsDetail.Tables(0).Rows(i)("RefDate"))
                        rs.fields("Description") = tostr(DsDetail.Tables(0).Rows(i)("Description"))
                        rs.fields("Nominal") = toval(DsDetail.Tables(0).Rows(i)("Nominal"))
                        rs.fields("RefNo") = tostr(DsDetail.Tables(0).Rows(i)("RefNo"))
                        rs.fields("RefType") = tostr(DsDetail.Tables(0).Rows(i)("RefType"))
                        rs.fields("DocRefNo") = tostr(DsDetail.Tables(0).Rows(i)("DocRefNo"))
                        rs.fields("RefStatus") = tostr(DsDetail.Tables(0).Rows(i)("RefStatus"))
                        If Not rs.UpdateRow Then Throw New Exception(rs.ErrDesc)
                    End If
                Next
                If Not rs.Eof Then
                    If Not rs.Update Then Throw New Exception(db.ErrDesc)
                End If

            End If

            If LockedKey <> "" Then If Not db.ReleaseLockedObject("Request" & LockedKey) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SaveRequestDocList(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal DsDetail As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Request As String

            Request = getInParamValue(InParam, 0)

            If Not DsDetail Is Nothing Then
                Dim rs As RemoteSet
                Dim SQL As String
                SQL = "Delete RDOCLIST "
                SQL = SQL & " from RDOCLIST"
                SQL = SQL & " LEFT JOIN DOCTYPE ON (DOCTYPE.DOCTYPE=RDOCLIST.DOCTYPE) "
                SQL = SQL & " LEFT JOIN RDOCLISTPIC on (RDOCLISTPIC.REQUEST=RDOCLIST.REQUEST AND RDOCLISTPIC.DOCTYPE=RDOCLIST.DOCTYPE)"
                SQL = SQL & " where coalesce(DOCTYPE.COLLECTIONF,0)=0 AND coalesce(RDOCLISTPIC.REQUEST,'')='' AND RDOCLIST.REQUEST='" & Request & "'"

                If Not db.Execute(SQL) Then Throw New Exception(db.ErrDesc)

                For i = 0 To DsDetail.Tables(0).Rows.Count - 1
                    If tostr(DsDetail.Tables(0).Rows(i)("DocType")) <> "" And tostr(DsDetail.Tables(0).Rows(i)("Description")) <> "" Then
                        rs = db.OpenRemoteSet("Select * from RDOCLIST Where Request='" & Request & "' and DocType='" & tostr(DsDetail.Tables(0).Rows(i)("DocType")) & "'")
                        If rs.Eof Then
                            rs.AddNew()
                        Else
                            rs.Edit()
                        End If
                        rs.fields("Request") = Request
                        rs.fields("Description") = tostr(DsDetail.Tables(0).Rows(i)("Description"))
                        rs.fields("DocType") = tostr(DsDetail.Tables(0).Rows(i)("DocType"))
                        rs.fields("availablef") = toval(DsDetail.Tables(0).Rows(i)("AvailableF"))
                        rs.fields("RecDate") = todate(DsDetail.Tables(0).Rows(i)("RecDate"))
                        If Not rs.Update Then Throw New Exception(rs.ErrDesc)
                    End If
                Next
            End If

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    Private Function Remove_Cheque_Vouchered(ByVal Voucher As String, ByRef ErrMsg As String) As Boolean
        Try
            If Not db.Execute("Update C Set Voucher='', Status='O' from pVoucher P1, pSLRef P2, ComAcc_Cheque C Where P2.Voucher=P1.Voucher and C.ComAcc=P1.ComAcc and C.ChequeNo=P2.RefNo and P2.RefType='CHEQUE' and C.Voucher=P1.Voucher and P1.Voucher='" & Voucher & "'") Then
                Throw New Exception(db.ErrDesc)
            End If
            Remove_Cheque_Vouchered = True
        Catch ex As Exception
            ErrMsg = ex.Message
            Remove_Cheque_Vouchered = False
        End Try
    End Function
    Private Function Cancelled_Cheque_Vouchered(ByVal Voucher As String, ByRef ErrMsg As String) As Boolean
        Try
            If Not db.Execute("Update C Set Status='C' from pVoucher P1, pSLRef P2, ComAcc_Cheque C Where P2.Voucher=P1.Voucher and C.ComAcc=P1.ComAcc and C.ChequeNo=P2.RefNo and P2.RefType='CHEQUE' and C.Voucher=P1.Voucher and P1.Voucher='" & Voucher & "'") Then
                Throw New Exception(db.ErrDesc)
            End If
            Cancelled_Cheque_Vouchered = True
        Catch ex As Exception
            ErrMsg = ex.Message
            Cancelled_Cheque_Vouchered = False
        End Try
    End Function
    Private Function Update_Cheque_Vouchered(ByVal Voucher As String, ByRef ErrMsg As String) As Boolean
        Try
            Dim rs As RemoteSet
            Dim rsCheque As RemoteSet
            rs = db.OpenRemoteSet("Select P2.ComAcc, P1.RefNo, P1.RefType, P1.Description, P1.Nominal from pSLRef P1, pVoucher P2 Where P2.Voucher='" & Voucher & "' and P1.Voucher=P2.Voucher and P1.RefType='CHEQUE'")
            Do While Not rs.Eof
                rsCheque = db.OpenRemoteSet("Select * from ComAcc_Cheque C Where C.ComAcc='" & rs.fields("ComAcc") & "' and C.ChequeNo='" & rs.fields("RefNo") & "'")
                If Not rsCheque.Eof Then
                    If rsCheque.fields("Voucher") <> "" Then
                        Throw New Exception("Cheque " & rsCheque.fields("ChequeNo") & " already Used by Voucher No. " & rsCheque.fields("Voucher"))
                    End If
                    rsCheque.Edit()
                    rsCheque.fields("Description") = rs.fields("Description")
                    rsCheque.fields("Nominal") = rs.fields("Nominal")
                    rsCheque.fields("Voucher") = Voucher
                    rsCheque.fields("Status") = "A"
                    If Not rsCheque.Update Then Throw New Exception(rsCheque.ErrDesc)
                End If
                rs.MoveNext()
            Loop
            Update_Cheque_Vouchered = True
        Catch ex As Exception
            ErrMsg = ex.Message
            Update_Cheque_Vouchered = False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function DropVoucherTR(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Branch As String
            Dim VoucherDate As Date
            Dim Reference As String
            Dim RefNo As String
            Dim Remarks As String

            Voucher = getInParamValue(InParam, 0)
            Branch = getInParamValue(InParam, 1)
            VoucherDate = getInParamValue(InParam, 2)
            Reference = getInParamValue(InParam, 3)      ' Un-Used
            RefNo = getInParamValue(InParam, 4)          ' Un-Used
            Remarks = getInParamValue(InParam, 5)          ' SysLogObject Remarks

            If Not db.GetLockedObject("Voucher" & Voucher) Then Throw New Exception(db.ErrDesc)

            Dim rs As RemoteSet

            Dim BudgetFeaturesF As Boolean
            rs = db.OpenRemoteSet("Select BudgetFeaturesF from SysTab")
            BudgetFeaturesF = rs.fields("BudgetFeaturesF")

            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='P' and DebtorF=1 and Voucher='" & Voucher & "'")

            If rs.Eof Then
                ErrMsg = "No Voucher Data !"
                Throw New Exception(ErrMsg)
            End If

            If Not PreAddVoucherTRTP(InParam, rs.fields("ProAcc"), rs.fields("ComAcc"), rs.fields("Currency"), ErrMsg) Then Throw New Exception(ErrMsg)
            If Not PreEditVoucherTRTP(InParam, ErrMsg) Then Throw New Exception(ErrMsg)
            If CBool(toval(GetAppSetting("AutoMatchingF"))) Then
                If Not Delete_Auto_Receipt_Payment(Voucher) Then Throw New Exception("Delete Auto Matching Failed !")
            End If

            If Not Save_Log_Object("pVoucher", "Voucher", Voucher, "ProAcc", rs.fields("ProAcc"), "ComAcc", rs.fields("ComAcc"), "Remarks", rs.fields("Remarks"), "", "", "", "Delete", Remarks) Then Throw New Exception("Can't Save to Log !")

            If rs.fields("Status") = "U" Then
                If BudgetFeaturesF Then
                    If Not Update_Budget_Account_Actual(Voucher, -1) Then Throw New Exception("Update Budget Account Failed !")
                End If
            End If

            ' Delete Detail
            If Not db.Execute("Update Voucher set Voucher.Payment_CC=Voucher.Payment_CC-SL.Nominal_OC, Voucher.NPayment=Voucher.NPayment-SL.NPayment from pVoucher Voucher, (Select SL.Doc_no, sum(SL.Nominal_OC) as Nominal_OC, Count(*) as NPayment from oSL('" & Voucher & "') SL Where SL.PaymentF=1 and SL.Voucher='" & Voucher & "' Group by SL.Doc_no) SL Where ((Voucher.CreditorF=1 and SL_Cat in ('P'))) and Voucher.Voucher=SL.DOC_NO") Then Throw New Exception(db.ErrDesc)
            If Not db.Execute("Update Voucher set Voucher.Payment_CC=Voucher.Payment_CC+SL.Nominal_OC, Voucher.NPayment=Voucher.NPayment-SL.NPayment from pVoucher Voucher, (Select SL.Doc_no, sum(SL.Nominal_OC) as Nominal_OC, Count(*) as NPayment from oSL('" & Voucher & "') SL Where SL.PaymentF=1 and SL.Voucher='" & Voucher & "' Group by SL.Doc_no) SL Where ((Voucher.DebtorF=1 and SL_Cat in ('P'))) and Voucher.Voucher=SL.DOC_NO") Then Throw New Exception(db.ErrDesc)
            If Not db.Execute("Update Voucher set Voucher.Payment_CC=Voucher.Payment_CC+SL.Nominal_OC, Voucher.NPayment=Voucher.NPayment-SL.NPayment from nVoucher Voucher, (Select SL.Doc_no, sum(SL.Nominal_OC) as Nominal_OC, Count(*) as NPayment from oSL('" & Voucher & "') SL Where SL.PaymentF=1 and SL.Voucher='" & Voucher & "' Group by SL.Doc_no) SL Where ((Voucher.CreditorF=1 and SL_Cat in ('N'))) and Voucher.Voucher=SL.DOC_NO") Then Throw New Exception(db.ErrDesc)
            If Not db.Execute("Update Voucher set Voucher.Payment_CC=Voucher.Payment_CC-SL.Nominal_OC, Voucher.NPayment=Voucher.NPayment-SL.NPayment from nVoucher Voucher, (Select SL.Doc_no, sum(SL.Nominal_OC) as Nominal_OC, Count(*) as NPayment from oSL('" & Voucher & "') SL Where SL.PaymentF=1 and SL.Voucher='" & Voucher & "' Group by SL.Doc_no) SL Where ((Voucher.DebtorF=1 and SL_Cat in ('N'))) and Voucher.Voucher=SL.DOC_NO") Then Throw New Exception(db.ErrDesc)

            If Not db.Execute("Delete from pSL where Voucher='" & Voucher & "'") Then Throw New Exception(ErrMsg)

            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='B' and RefNo='" & Voucher & "'")
            Do While Not rs.Eof
                If Not Delete_WithholdingTaxByVoucherRef(rs.fields("Voucher")) Then Throw New Exception(StrMsg)

                If Not db.Execute("Delete from pVoucher where Voucher='" & rs.fields("Voucher") & "' and Posting_Flag=0") Then Throw New Exception(db.ErrDesc)
                If db.RecordsAffected = 0 Then Throw New Exception("Can't Delete Overbooking Voucher !")

                rs.MoveNext()
            Loop
            If Not Delete_WithholdingTaxByVoucherRef(Voucher) Then Throw New Exception(StrMsg)

            If Not db.Execute("Update Request Set Voucher='' from Request Where Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)
            If Not db.Execute("Delete from pVoucher where Voucher='" & Voucher & "' and Posting_Flag=0") Then Throw New Exception(db.ErrDesc)
            If db.RecordsAffected = 0 Then Throw New Exception("Can't Delete Voucher !")

            If Not db.Execute("Update SysRequest Set Status='P',LUserID='" & dbUser & "', LUserDate='" & Format(Today.Date, "MM/DD/YYYY") & "',LUserTime='" & Time() & "' from SysRequest Where Status<>'P' and Param1='SEND' and Param2 in ('FA') and Param6='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)

            If Not db.ReleaseLockedObject("Voucher" & Voucher) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Voucher, "Receipt Voucher", "Drop : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function DropVoucherMR(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Branch As String
            Dim VoucherDate As Date
            Dim Reference As String
            Dim RefNo As String
            Dim Remarks As String

            Voucher = getInParamValue(InParam, 0)
            Branch = getInParamValue(InParam, 1)
            VoucherDate = getInParamValue(InParam, 2)
            Reference = getInParamValue(InParam, 3)      ' Un-Used
            RefNo = getInParamValue(InParam, 4)          ' Un-Used
            Remarks = getInParamValue(InParam, 5)          ' SysLogObject Remarks

            If Not db.GetLockedObject("Voucher" & Voucher) Then Throw New Exception(db.ErrDesc)

            Dim rs As RemoteSet
            Dim BudgetFeaturesF As Boolean
            rs = db.OpenRemoteSet("Select BudgetFeaturesF from SysTab")
            BudgetFeaturesF = rs.fields("BudgetFeaturesF")

            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='P' and DebtorF=1 and Voucher='" & Voucher & "'")

            If rs.Eof Then
                ErrMsg = "No Voucher Data !"
                Throw New Exception(ErrMsg)
            End If

            If Not PreAddVoucherTRTP(InParam, rs.fields("ProAcc"), rs.fields("ComAcc"), rs.fields("Currency"), ErrMsg) Then Throw New Exception(ErrMsg)
            If Not PreEditVoucherTRTP(InParam, ErrMsg) Then Throw New Exception(ErrMsg)
            If CBool(toval(GetAppSetting("AutoMatchingF"))) Then
                If Not Delete_Auto_Receipt_Payment(Voucher) Then Throw New Exception("Delete Auto Matching Failed !")
            End If

            If Not Save_Log_Object("pVoucher", "Voucher", Voucher, "ProAcc", rs.fields("ProAcc"), "ComAcc", rs.fields("ComAcc"), "Remarks", rs.fields("Remarks"), "", "", "", "Delete", Remarks) Then Throw New Exception("Can't Save to Log !")

            If rs.fields("Status") = "U" Then
                If BudgetFeaturesF Then
                    If Not Update_Budget_Account_Actual(Voucher, -1) Then Throw New Exception("Update Budget Account Failed !")
                End If
            End If

            ' Delete Detail
            If Not db.Execute("Update Voucher set Voucher.Payment_CC=Voucher.Payment_CC-SL.Nominal_OC, Voucher.NPayment=Voucher.NPayment-SL.NPayment from pVoucher Voucher, (Select SL.Doc_no, sum(SL.Nominal_OC) as Nominal_OC, Count(*) as NPayment from oSL('" & Voucher & "') SL Where SL.PaymentF=1 and SL.Voucher='" & Voucher & "' Group by SL.Doc_no) SL Where ((Voucher.CreditorF=1 and SL_Cat in ('P'))) and Voucher.Voucher=SL.DOC_NO") Then Throw New Exception(db.ErrDesc)
            If Not db.Execute("Update Voucher set Voucher.Payment_CC=Voucher.Payment_CC+SL.Nominal_OC, Voucher.NPayment=Voucher.NPayment-SL.NPayment from pVoucher Voucher, (Select SL.Doc_no, sum(SL.Nominal_OC) as Nominal_OC, Count(*) as NPayment from oSL('" & Voucher & "') SL Where SL.PaymentF=1 and SL.Voucher='" & Voucher & "' Group by SL.Doc_no) SL Where ((Voucher.DebtorF=1 and SL_Cat in ('P'))) and Voucher.Voucher=SL.DOC_NO") Then Throw New Exception(db.ErrDesc)
            If Not db.Execute("Update Voucher set Voucher.Payment_CC=Voucher.Payment_CC+SL.Nominal_OC, Voucher.NPayment=Voucher.NPayment-SL.NPayment from nVoucher Voucher, (Select SL.Doc_no, sum(SL.Nominal_OC) as Nominal_OC, Count(*) as NPayment from oSL('" & Voucher & "') SL Where SL.PaymentF=1 and SL.Voucher='" & Voucher & "' Group by SL.Doc_no) SL Where ((Voucher.CreditorF=1 and SL_Cat in ('N'))) and Voucher.Voucher=SL.DOC_NO") Then Throw New Exception(db.ErrDesc)
            If Not db.Execute("Update Voucher set Voucher.Payment_CC=Voucher.Payment_CC-SL.Nominal_OC, Voucher.NPayment=Voucher.NPayment-SL.NPayment from nVoucher Voucher, (Select SL.Doc_no, sum(SL.Nominal_OC) as Nominal_OC, Count(*) as NPayment from oSL('" & Voucher & "') SL Where SL.PaymentF=1 and SL.Voucher='" & Voucher & "' Group by SL.Doc_no) SL Where ((Voucher.DebtorF=1 and SL_Cat in ('N'))) and Voucher.Voucher=SL.DOC_NO") Then Throw New Exception(db.ErrDesc)

            If Not db.Execute("Delete from pSL where Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)

            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='B' and RefNo='" & Voucher & "'")
            Do While Not rs.Eof
                If Not Delete_WithholdingTaxByVoucherRef(rs.fields("Voucher")) Then Throw New Exception(StrMsg)

                If Not db.Execute("Delete from pVoucher where Voucher='" & rs.fields("Voucher") & "' and Posting_Flag=0") Then Throw New Exception(db.ErrDesc)
                If db.RecordsAffected = 0 Then Throw New Exception("Can't Delete Overbooking Voucher !")

                rs.MoveNext()
            Loop
            If Not Delete_WithholdingTaxByVoucherRef(Voucher) Then Throw New Exception(StrMsg)

            If Not db.Execute("Update Request Set Voucher='' from Request Where Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)
            If Not db.Execute("Delete from pVoucher where Voucher='" & Voucher & "' and Posting_Flag=0") Then Throw New Exception(db.ErrDesc)
            If db.RecordsAffected = 0 Then Throw New Exception("Can't Delete Voucher !")

            If Not db.Execute("Update SysRequest Set Status='P',LUserID='" & dbUser & "', LUserDate='" & Format(Today.Date, "MM/DD/YYYY") & "',LUserTime='" & Time() & "' from SysRequest Where Status<>'P' and Param1='SEND' and Param2 in ('FA') and Param6='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)

            If Not db.ReleaseLockedObject("Voucher" & Voucher) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Voucher, "Matching Voucher", "Drop : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function DropVoucherIR(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter    
            Dim Branch As String
            Dim VoucherDate As Date
            Dim Reference As String
            Dim RefNo As String

            Voucher = getInParamValue(InParam, 0)
            Branch = getInParamValue(InParam, 1)
            VoucherDate = getInParamValue(InParam, 2)
            Reference = getInParamValue(InParam, 3)      ' Un-Used
            RefNo = getInParamValue(InParam, 4)          ' Un-Used

            If Not db.GetLockedObject("Voucher" & Voucher) Then Throw New Exception(db.ErrDesc)
            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='P' and DebtorF=1 and Voucher='" & Voucher & "'")

            If rs.Eof Then
                ErrMsg = "No Voucher Data !"
                Throw New Exception(ErrMsg)
            End If

            If Not PreAddVoucherIRIP(InParam, rs.fields("ProAcc"), rs.fields("ComAcc"), rs.fields("Currency"), ErrMsg) Then Throw New Exception(ErrMsg)
            If Not PreEditVoucherIRIP(InParam, ErrMsg) Then Throw New Exception(ErrMsg)

            If Not Save_Log_Object("pVoucher", "Voucher", Voucher, "ProAcc", rs.fields("ProAcc"), "ComAcc", rs.fields("ComAcc"), "Remarks", rs.fields("Remarks"), "", "", "", "Delete") Then Throw New Exception("Can't Save to Log !")

            ' Delete Detail
            If Not db.Execute("Update Voucher set Voucher.Payment_CC=Voucher.Payment_CC-SL.Nominal_OC, Voucher.NPayment=Voucher.NPayment-1 from pVoucher Voucher, pSL SL Where Voucher.Voucher=SL.DOC_NO and SL.PaymentF=1 and SL.Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)
            rs = db.OpenRemoteSet("select SL.Doc_No From pSL SL Where SL.PaymentF=1 and SL.Voucher='" & Voucher & "'")
            Do While Not rs.Eof
                If Not db.Execute("Delete from pVoucher where Posting_Flag=0 and Voucher='" & tostr(rs.fields("Doc_No")) & "'") Then Throw New Exception(db.ErrDesc)
                If db.RecordsAffected = 0 Then
                    ErrMsg = "Voucher Already Processed !"
                    Throw New Exception(ErrMsg)
                End If
                rs.MoveNext()
            Loop
            If Not db.Execute("Delete from pSL where Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)
            If Not db.Execute("Delete from pVoucher where Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)

            If Not db.Execute("Update SysRequest Set Status='P',LUserID='" & dbUser & "', LUserDate='" & Format(Today.Date, "MM/DD/YYYY") & "',LUserTime='" & Time() & "' from SysRequest Where Status<>'P' and Param1='SEND' and Param2 in ('FA') and Param6='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)
            If Not db.Execute("Update Request Set Voucher='' from Request Where Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)

            If Not db.ReleaseLockedObject("Voucher" & Voucher) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Voucher, "Receipt Inter-Bank", "Drop : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function DropVoucherIP(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Branch As String
            Dim VoucherDate As Date
            Dim Reference As String
            Dim RefNo As String

            Voucher = getInParamValue(InParam, 0)
            Branch = getInParamValue(InParam, 1)
            VoucherDate = getInParamValue(InParam, 2)
            Reference = getInParamValue(InParam, 3)      ' Un-Used
            RefNo = getInParamValue(InParam, 4)          ' Un-Used

            If Not db.GetLockedObject("Voucher" & Voucher) Then Throw New Exception(db.ErrDesc)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='P' and CreditorF=1 and Voucher='" & Voucher & "'")

            If rs.Eof Then
                ErrMsg = "No Voucher Data !"
                Throw New Exception(ErrMsg)
            End If

            If Not PreAddVoucherIRIP(InParam, rs.fields("ProAcc"), rs.fields("ComAcc"), rs.fields("Currency"), ErrMsg) Then Throw New Exception(ErrMsg)
            If Not PreEditVoucherIRIP(InParam, ErrMsg) Then Throw New Exception(ErrMsg)

            If Not Save_Log_Object("pVoucher", "Voucher", Voucher, "ProAcc", rs.fields("ProAcc"), "ComAcc", rs.fields("ComAcc"), "Remarks", rs.fields("Remarks"), "", "", "", "Delete") Then Throw New Exception("Can't Save to Log !")

            ' Delete Detail
            If Not db.Execute("Update Voucher set Voucher.Payment_CC=Voucher.Payment_CC-SL.Nominal_OC, Voucher.NPayment=Voucher.NPayment-1 from pVoucher Voucher, pSL SL Where Voucher.Voucher=SL.DOC_NO and SL.PaymentF=1 and SL.Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)
            rs = db.OpenRemoteSet("select SL.Doc_No From pSL SL Where SL.PaymentF=1 and SL.Voucher='" & Voucher & "'")
            Do While Not rs.Eof
                If Not db.Execute("Delete from pVoucher where Posting_Flag=0 and Voucher='" & tostr(rs.fields("Doc_No")) & "'") Then Throw New Exception(db.ErrDesc)
                If db.RecordsAffected = 0 Then
                    ErrMsg = "Voucher Already Processed !"
                    Throw New Exception(ErrMsg)
                End If
                rs.MoveNext()
            Loop
            If Not db.Execute("Delete from pSL where Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)
            If Not db.Execute("Delete from pVoucher where Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)

            If Not db.Execute("Update SysRequest Set Status='P',LUserID='" & dbUser & "', LUserDate='" & Format(Today.Date, "MM/DD/YYYY") & "',LUserTime='" & Time() & "' from SysRequest Where Status<>'P' and Param1='SEND' and Param2 in ('FA') and Param6='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)

            If Not db.Execute("Update Request Set Voucher='' from Request Where Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)

            If Not db.ReleaseLockedObject("Voucher" & Voucher) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Voucher, "Payment Inter-Bank", "Drop : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function CancelCheque(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim ComAcc As String
            Dim ChequeNo As String

            ComAcc = getInParamValue(InParam, 0)
            ChequeNo = getInParamValue(InParam, 1)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from ComAcc_Cheque Where ComAcc='" & ComAcc & "' and ChequeNo='" & ChequeNo & "'")
            If rs.Eof Then
                ErrMsg = "No Voucher Data !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") <> "O" Then
                ErrMsg = "Please Check Cheque Status !"
            End If

            rs.Edit()
            rs.fields("Status") = "C"
            rs.fields("Last_Opr") = dbUser
            rs.fields("Last_Update") = Today.Date
            If Not rs.Update Then Throw New Exception(rs.ErrDesc)

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function UndoCancelCheque(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim ComAcc As String
            Dim ChequeNo As String

            ComAcc = getInParamValue(InParam, 0)
            ChequeNo = getInParamValue(InParam, 1)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from ComAcc_Cheque Where ComAcc='" & ComAcc & "' and ChequeNo='" & ChequeNo & "'")
            If rs.Eof Then
                ErrMsg = "No Voucher Data !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") <> "C" Then
                ErrMsg = "Please Check Cheque Status !"
            End If

            rs.Edit()
            rs.fields("Status") = "O"
            rs.fields("Last_Opr") = dbUser
            rs.fields("Last_Update") = Today.Date
            If Not rs.Update Then Throw New Exception(rs.ErrDesc)

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function DropVoucherTP(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Branch As String
            Dim VoucherDate As Date
            Dim Reference As String
            Dim RefNo As String
            Dim Remarks As String

            Voucher = getInParamValue(InParam, 0)
            Branch = getInParamValue(InParam, 1)
            VoucherDate = getInParamValue(InParam, 2)
            Reference = getInParamValue(InParam, 3)      ' Un-Used
            RefNo = getInParamValue(InParam, 4)          ' Un-Used
            Remarks = getInParamValue(InParam, 5)          ' SysLogObject Remarks

            If Not db.GetLockedObject("Voucher" & Voucher) Then Throw New Exception(db.ErrDesc)

            Dim rs As RemoteSet
            Dim BudgetFeaturesF As Boolean
            rs = db.OpenRemoteSet("Select BudgetFeaturesF from SysTab")
            BudgetFeaturesF = rs.fields("BudgetFeaturesF")

            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='P' and CreditorF=1 and Voucher='" & Voucher & "'")

            If rs.Eof Then
                ErrMsg = "No Voucher Data !"
                Throw New Exception(ErrMsg)
            End If

            If Not PreAddVoucherTRTP(InParam, rs.fields("ProAcc"), rs.fields("ComAcc"), rs.fields("Currency"), ErrMsg) Then Throw New Exception(ErrMsg)
            If Not PreEditVoucherTRTP(InParam, ErrMsg) Then Throw New Exception(ErrMsg)
            If CBool(toval(GetAppSetting("AutoMatchingF"))) Then
                If Not Delete_Auto_Receipt_Payment(Voucher) Then Throw New Exception("Delete Auto Matching Failed !")
            End If

            If Not Save_Log_Object("pVoucher", "Voucher", Voucher, "ProAcc", rs.fields("ProAcc"), "ComAcc", rs.fields("ComAcc"), "Remarks", rs.fields("Remarks"), "", "", "", "Delete", Remarks) Then Throw New Exception("Can't Save to Log !")

            If rs.fields("Status") = "U" Then
                If BudgetFeaturesF Then
                    If Not Update_Budget_Account_Actual(Voucher, -1) Then Throw New Exception("Update Budget Account Failed !")
                End If
            End If

            If Not Cancelled_Cheque_Vouchered(Voucher, ErrMsg) Then Throw New Exception(ErrMsg)

            ' Delete Detail
            If Not db.Execute("Update Voucher set Voucher.Payment_CC=Voucher.Payment_CC-SL.Nominal_OC, Voucher.NPayment=Voucher.NPayment-SL.NPayment from pVoucher Voucher, (Select SL.Doc_no, sum(SL.Nominal_OC) as Nominal_OC, Count(*) as NPayment from oSL('" & Voucher & "') SL Where SL.PaymentF=1 and SL.Voucher='" & Voucher & "' Group by SL.Doc_no) SL Where ((Voucher.DebtorF=1 and SL_Cat in ('P'))) and Voucher.Voucher=SL.DOC_NO") Then Throw New Exception(db.ErrDesc)
            If Not db.Execute("Update Voucher set Voucher.Payment_CC=Voucher.Payment_CC+SL.Nominal_OC, Voucher.NPayment=Voucher.NPayment-SL.NPayment from pVoucher Voucher, (Select SL.Doc_no, sum(SL.Nominal_OC) as Nominal_OC, Count(*) as NPayment from oSL('" & Voucher & "') SL Where SL.PaymentF=1 and SL.Voucher='" & Voucher & "' Group by SL.Doc_no) SL Where ((Voucher.CreditorF=1 and SL_Cat in ('P'))) and Voucher.Voucher=SL.DOC_NO") Then Throw New Exception(db.ErrDesc)
            If Not db.Execute("Update Voucher set Voucher.Payment_CC=Voucher.Payment_CC+SL.Nominal_OC, Voucher.NPayment=Voucher.NPayment-SL.NPayment from nVoucher Voucher, (Select SL.Doc_no, sum(SL.Nominal_OC) as Nominal_OC, Count(*) as NPayment from oSL('" & Voucher & "') SL Where SL.PaymentF=1 and SL.Voucher='" & Voucher & "' Group by SL.Doc_no) SL Where ((Voucher.DebtorF=1 and SL_Cat in ('N'))) and Voucher.Voucher=SL.DOC_NO") Then Throw New Exception(db.ErrDesc)
            If Not db.Execute("Update Voucher set Voucher.Payment_CC=Voucher.Payment_CC-SL.Nominal_OC, Voucher.NPayment=Voucher.NPayment-SL.NPayment from nVoucher Voucher, (Select SL.Doc_no, sum(SL.Nominal_OC) as Nominal_OC, Count(*) as NPayment from oSL('" & Voucher & "') SL Where SL.PaymentF=1 and SL.Voucher='" & Voucher & "' Group by SL.Doc_no) SL Where ((Voucher.CreditorF=1 and SL_Cat in ('N'))) and Voucher.Voucher=SL.DOC_NO") Then Throw New Exception(db.ErrDesc)

            If Not db.Execute("Delete from pSL where Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)

            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='B' and RefNo='" & Voucher & "'")
            Do While Not rs.Eof
                If Not Delete_WithholdingTaxByVoucherRef(rs.fields("Voucher")) Then Throw New Exception(StrMsg)

                If Not db.Execute("Delete from pVoucher where Voucher='" & rs.fields("Voucher") & "' and Posting_Flag=0") Then Throw New Exception(db.ErrDesc)
                If db.RecordsAffected = 0 Then Throw New Exception("Can't Delete Overbooking Voucher !")

                rs.MoveNext()
            Loop
            If Not Delete_WithholdingTaxByVoucherRef(Voucher) Then Throw New Exception(StrMsg)

            If Not db.Execute("Update Request Set Voucher='' from Request Where Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)
            If Not db.Execute("Delete from pVoucher where Voucher='" & Voucher & "' and Posting_Flag=0") Then Throw New Exception(db.ErrDesc)
            If db.RecordsAffected = 0 Then Throw New Exception("Can't Delete Voucher !")

            If Not db.Execute("Update SysRequest Set Status='P',LUserID='" & dbUser & "', LUserDate='" & Format(Today.Date, "MM/DD/YYYY") & "',LUserTime='" & Time() & "' from SysRequest Where Status<>'P' and Param1='SEND' and Param2 in ('FA') and Param6='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)

            If Not db.ReleaseLockedObject("Voucher" & Voucher) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Voucher, "Payment Voucher", "Drop : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function DropVoucherRA(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Branch As String
            Dim VoucherDate As Date
            Dim Reference As String
            Dim RefNo As String

            Voucher = getInParamValue(InParam, 0)
            Branch = getInParamValue(InParam, 1)
            VoucherDate = getInParamValue(InParam, 2)
            Reference = getInParamValue(InParam, 3)      ' Un-Used
            RefNo = getInParamValue(InParam, 4)          ' RV/PV

            If Not db.GetLockedObject("Voucher" & Voucher) Then Throw New Exception(db.ErrDesc)
            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='A' and CreditorF=1 and Voucher='" & Voucher & "'")

            If rs.Eof Then
                ErrMsg = "No Voucher Data !"
                Throw New Exception(ErrMsg)
            End If

            Dim Payment_CC As Double
            Dim nPayment As Long

            Payment_CC = rs.fields("Payment_CC")
            nPayment = rs.fields("nPayment")

            If Not PreAddVoucherRAPA(InParam, ErrMsg) Then Throw New Exception(ErrMsg)
            If Not PreEditVoucherRAPA(InParam, ErrMsg) Then Throw New Exception(ErrMsg)

            If Not Save_Log_Object("pVoucher", "Voucher", Voucher, "ProAcc", rs.fields("ProAcc"), "ComAcc", rs.fields("ComAcc"), "Remarks", rs.fields("Remarks"), "", "", "", "Delete") Then Throw New Exception("Can't Save to Log !")

            ' Delete Detail
            If Not db.Execute("Update Voucher set Voucher.Payment_CC=Voucher.Payment_CC+SL.Nominal_OC, Voucher.NPayment=Voucher.NPayment-1 from nVoucher Voucher, pSL SL Where Voucher.SL_Cat='N' and Voucher.DebtorF=1 and Voucher.Voucher=SL.DOC_NO and SL.PaymentF=1 and SL.Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)
            If Not db.Execute("Update Voucher set Voucher.Payment_CC=Voucher.Payment_CC-SL.Nominal_OC, Voucher.NPayment=Voucher.NPayment-1 from nVoucher Voucher, pSL SL Where Voucher.SL_Cat='N' and Voucher.CreditorF=1 and Voucher.Voucher=SL.DOC_NO and SL.PaymentF=1 and SL.Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)

            If Not db.Execute("Update Voucher set Voucher.Payment_CC=Voucher.Payment_CC+SL.Nominal_OC, Voucher.NPayment=Voucher.NPayment-1 from pVoucher Voucher, pSL SL Where Voucher.SL_Cat='P' and Voucher.CreditorF=1 and Voucher.Voucher=SL.DOC_NO and SL.PaymentF=1 and SL.Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)
            If Not db.Execute("Update Voucher set Voucher.Payment_CC=Voucher.Payment_CC-SL.Nominal_OC, Voucher.NPayment=Voucher.NPayment-1 from pVoucher Voucher, pSL SL Where Voucher.SL_Cat='P' and Voucher.DebtorF=1 and Voucher.Voucher=SL.DOC_NO and SL.PaymentF=1 and SL.Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)

            ' Check Out Detail
            Dim rsSL As RemoteSet
            Dim SQL As String
            rs = db.OpenRemoteSet("Select * from pSL Where Voucher='" & Voucher & "'")
            Do While Not rs.Eof
                rsSL = db.OpenRemoteSet("Select Nominal_CC-Diff_CC as Nominal_CC, Payment_CC+Payment_OC as Payment_CC from nVoucher Where nVoucher.SL_Cat='N' and nVoucher.Voucher='" & rs.fields("Doc_No") & "'")
                If rsSL.Eof Then
                    SQL = "SELECT VOUCHER, BRANCH, ACCOUNT, SUM(NOMINAL_CC) AS NOMINAL_CC, SUM(PAYMENT_CC) AS PAYMENT_CC            "
                    SQL = SQL & " FROM "
                    SQL = SQL & " ( "
                    SQL = SQL & " SELECT VOUCHER, BRANCH, ACCOUNT, SUM(SL.NOMINAL) AS NOMINAL_CC,0 as PAYMENT_CC "
                    SQL = SQL & " FROM PSLSUM SL "
                    SQL = SQL & " WHERE (SL.VOUCHER='" & rs.fields("Doc_No") & "') AND (SL.BRANCH='" & Branch & "') AND (SL.ACCOUNT='" & rs.fields("Account") & "')"
                    SQL = SQL & " GROUP BY VOUCHER, BRANCH, ACCOUNT            "
                    SQL = SQL & " UNION ALL "
                    SQL = SQL & " SELECT DOC_NO AS VOUCHER, BRANCH, ACCOUNT, 0 as NOMINAL_CC, SUM(NOMINAL_OC) AS PAYMENT_CC "
                    SQL = SQL & " FROM R_SL_ALLOCATED_BY_VOUCHER('" & rs.fields("Doc_No") & "') SL "
                    SQL = SQL & " WHERE SL.VOUCHER<>'" & Voucher & "' AND (SL.DOC_NO='" & rs.fields("Doc_No") & "') AND (SL.BRANCH='" & Branch & "') AND (SL.ACCOUNT='" & rs.fields("Account") & "') "
                    SQL = SQL & " Group By DOC_NO, BRANCH, ACCOUNT            "
                    SQL = SQL & " ) V"
                    SQL = SQL & " GROUP BY VOUCHER, BRANCH, ACCOUNT"
                    SQL = SQL & " HAVING (SUM(NOMINAL_CC)>0 AND ROUND(SUM(NOMINAL_CC)-SUM(PAYMENT_CC),3)<0) OR (SUM(NOMINAL_CC)<0 AND ROUND(SUM(NOMINAL_CC)-SUM(PAYMENT_CC),3)>0)"
                    rsSL = db.OpenRemoteSet(SQL)
                End If
                If Not rsSL.Eof AndAlso (toval(rsSL.fields("Nominal_CC")) > 0 And Math.Round(toval(rsSL.fields("Nominal_CC")) - toval(rsSL.fields("Payment_CC")), 4, MidpointRounding.AwayFromZero) < 0) Or (toval(rsSL.fields("Nominal_CC")) < 0 And Math.Round(toval(rsSL.fields("Nominal_CC")) - toval(rsSL.fields("Payment_CC")), 4, MidpointRounding.AwayFromZero) > 0) Then
                    ErrMsg = "Adjustment Amount Resulting Over Paid Amount for Voucher " & rs.fields("Doc_No") & " !"
                    Throw New Exception(ErrMsg)
                End If
                rs.MoveNext()
            Loop

            rs = db.OpenRemoteSet("Select * from pVoucher Where Voucher='" & RefNo & "'")
            If tostr(rs.fields("SL_Cat")) = "B" Then
                RefNo = tostr(rs.fields("RefNo"))
                rs = db.OpenRemoteSet("Select * from pVoucher Where Voucher='" & RefNo & "'")
            End If

            SQL = "SELECT VOUCHER, BRANCH, ACCOUNT, SUM(NOMINAL_CC) AS NOMINAL_CC, SUM(PAYMENT_CC) AS PAYMENT_CC            "
            SQL = SQL & " FROM "
            SQL = SQL & " ( "
            SQL = SQL & " SELECT VOUCHER, BRANCH, ACCOUNT, SUM(SL.NOMINAL) AS NOMINAL_CC,0 as PAYMENT_CC "
            SQL = SQL & " FROM PSLSUM SL "
            SQL = SQL & " WHERE (SL.VOUCHER='" & RefNo & "') AND (SL.BRANCH='" & Branch & "') AND (SL.ACCOUNT='" & rs.fields("Account") & "')"
            SQL = SQL & " GROUP BY VOUCHER, BRANCH, ACCOUNT            "
            SQL = SQL & " UNION ALL "
            SQL = SQL & " SELECT DOC_NO AS VOUCHER, BRANCH, ACCOUNT, 0 as NOMINAL_CC, SUM(NOMINAL_OC) AS PAYMENT_CC "
            SQL = SQL & " FROM R_SL_ALLOCATED_BY_VOUCHER('" & RefNo & "') SL "
            SQL = SQL & " WHERE SL.VOUCHER<>'" & Voucher & "' AND (SL.DOC_NO='" & RefNo & "') AND (SL.BRANCH='" & Branch & "') AND (SL.ACCOUNT='" & rs.fields("Account") & "') "
            SQL = SQL & " Group By DOC_NO, BRANCH, ACCOUNT            "
            SQL = SQL & " ) V"
            SQL = SQL & " GROUP BY VOUCHER, BRANCH, ACCOUNT"
            SQL = SQL & " HAVING (SUM(NOMINAL_CC)>0 AND ROUND(SUM(NOMINAL_CC)-SUM(PAYMENT_CC),3)<0) OR (SUM(NOMINAL_CC)<0 AND ROUND(SUM(NOMINAL_CC)-SUM(PAYMENT_CC),3)>0)"
            rsSL = db.OpenRemoteSet(SQL)
            If Not rsSL.Eof AndAlso (toval(rsSL.fields("Nominal_CC")) > 0 And Math.Round(toval(rsSL.fields("Nominal_CC")) - toval(rs.fields("Payment_CC")), 4, MidpointRounding.AwayFromZero) < 0) Or (toval(rsSL.fields("Nominal_CC")) < 0 And Math.Round(toval(rsSL.fields("Nominal_CC")) - toval(rs.fields("Payment_CC")), 4, MidpointRounding.AwayFromZero) > 0) Then
                ErrMsg = "Adjustment Amount Resulting Over Paid Amount for Voucher " & RefNo & " !"
                Throw New Exception(ErrMsg)
            End If

            rs.Edit()
            If toval(rs.fields("CreditorF")) = False Then
                rs.fields("Payment_CC") = toval(rs.fields("Payment_CC")) + Payment_CC
            Else
                rs.fields("Payment_CC") = toval(rs.fields("Payment_CC")) - Payment_CC
            End If
            rs.fields("NPayment") = toval(rs.fields("NPayment")) - nPayment
            If Not rs.Update Then Throw New Exception(db.ErrDesc)

            If Not Delete_WithholdingTaxByVoucherRef(Voucher) Then Throw New Exception(StrMsg)

            If Not db.Execute("Delete from pSL where Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)
            If Not db.Execute("Delete from pVoucher where Voucher='" & Voucher & "' and Posting_Flag=0") Then Throw New Exception(db.ErrDesc)
            If db.RecordsAffected = 0 Then Throw New Exception("Can't Delete Voucher !")

            If Not db.Execute("Update SysRequest Set Status='P',LUserID='" & dbUser & "', LUserDate='" & Format(Today.Date, "MM/DD/YYYY") & "',LUserTime='" & Time() & "' from SysRequest Where Status<>'P' and Param1='SEND' and Param2 in ('FA') and Param6='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)

            If Not db.ReleaseLockedObject("Voucher" & Voucher) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Voucher, "Receipt Adjustment", "Drop : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function DropVoucherPA(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Branch As String
            Dim VoucherDate As Date
            Dim Reference As String
            Dim RefNo As String

            Voucher = getInParamValue(InParam, 0)
            Branch = getInParamValue(InParam, 1)
            VoucherDate = getInParamValue(InParam, 2)
            Reference = getInParamValue(InParam, 3)      ' Un-Used
            RefNo = getInParamValue(InParam, 4)          ' RV/PV

            If Not db.GetLockedObject("Voucher" & Voucher) Then Throw New Exception(db.ErrDesc)
            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='A' and DebtorF=1 and Voucher='" & Voucher & "'")

            If rs.Eof Then
                ErrMsg = "No Voucher Data !"
                Throw New Exception(ErrMsg)
            End If

            Dim Payment_CC As Double
            Dim nPayment As Long

            Payment_CC = rs.fields("Payment_CC")
            nPayment = rs.fields("nPayment")

            If Not PreAddVoucherRAPA(InParam, ErrMsg) Then Throw New Exception(ErrMsg)
            If Not PreEditVoucherRAPA(InParam, ErrMsg) Then Throw New Exception(ErrMsg)

            If Not Save_Log_Object("pVoucher", "Voucher", Voucher, "ProAcc", rs.fields("ProAcc"), "ComAcc", rs.fields("ComAcc"), "Remarks", rs.fields("Remarks"), "", "", "", "Delete") Then Throw New Exception("Can't Save to Log !")

            ' Delete Detail
            If Not db.Execute("Update Voucher set Voucher.Payment_CC=Voucher.Payment_CC+SL.Nominal_OC, Voucher.NPayment=Voucher.NPayment-1 from nVoucher Voucher, pSL SL Where Voucher.SL_Cat='N' and Voucher.CreditorF=1 and Voucher.Voucher=SL.DOC_NO and SL.PaymentF=1 and SL.Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)
            If Not db.Execute("Update Voucher set Voucher.Payment_CC=Voucher.Payment_CC-SL.Nominal_OC, Voucher.NPayment=Voucher.NPayment-1 from nVoucher Voucher, pSL SL Where Voucher.SL_Cat='N' and Voucher.DebtorF=1 and Voucher.Voucher=SL.DOC_NO and SL.PaymentF=1 and SL.Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)

            If Not db.Execute("Update Voucher set Voucher.Payment_CC=Voucher.Payment_CC+SL.Nominal_OC, Voucher.NPayment=Voucher.NPayment-1 from pVoucher Voucher, pSL SL Where Voucher.SL_Cat='P' and Voucher.DebtorF=1 and Voucher.Voucher=SL.DOC_NO and SL.PaymentF=1 and SL.Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)
            If Not db.Execute("Update Voucher set Voucher.Payment_CC=Voucher.Payment_CC-SL.Nominal_OC, Voucher.NPayment=Voucher.NPayment-1 from pVoucher Voucher, pSL SL Where Voucher.SL_Cat='P' and Voucher.CreditorF=1 and Voucher.Voucher=SL.DOC_NO and SL.PaymentF=1 and SL.Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)

            ' Check Out Detail
            Dim rsSL As RemoteSet
            Dim SQL As String
            rs = db.OpenRemoteSet("Select * from pSL Where Voucher='" & Voucher & "'")
            Do While Not rs.Eof
                rsSL = db.OpenRemoteSet("Select Nominal_CC-Diff_CC as Nominal_CC, Payment_CC+Payment_OC as Payment_CC from nVoucher Where nVoucher.SL_Cat='N' and nVoucher.Voucher='" & rs.fields("Doc_No") & "'")
                If rsSL.Eof Then
                    SQL = "SELECT VOUCHER, BRANCH, ACCOUNT, SUM(NOMINAL_CC) AS NOMINAL_CC, SUM(PAYMENT_CC) AS PAYMENT_CC            "
                    SQL = SQL & " FROM "
                    SQL = SQL & " ( "
                    SQL = SQL & " SELECT VOUCHER, BRANCH, ACCOUNT, SUM(SL.NOMINAL) AS NOMINAL_CC,0 as PAYMENT_CC "
                    SQL = SQL & " FROM PSLSUM SL "
                    SQL = SQL & " WHERE (SL.VOUCHER='" & rs.fields("Doc_No") & "') AND (SL.BRANCH='" & Branch & "') AND (SL.ACCOUNT='" & rs.fields("Account") & "')"
                    SQL = SQL & " GROUP BY VOUCHER, BRANCH, ACCOUNT            "
                    SQL = SQL & " UNION ALL "
                    SQL = SQL & " SELECT DOC_NO AS VOUCHER, BRANCH, ACCOUNT, 0 as NOMINAL_CC, SUM(NOMINAL_OC) AS PAYMENT_CC "
                    SQL = SQL & " FROM R_SL_ALLOCATED_BY_VOUCHER('" & rs.fields("Doc_No") & "') SL "
                    SQL = SQL & " WHERE SL.VOUCHER<>'" & Voucher & "' AND (SL.DOC_NO='" & rs.fields("Doc_No") & "') AND (SL.BRANCH='" & Branch & "') AND (SL.ACCOUNT='" & rs.fields("Account") & "') "
                    SQL = SQL & " Group By DOC_NO, BRANCH, ACCOUNT            "
                    SQL = SQL & " ) V"
                    SQL = SQL & " GROUP BY VOUCHER, BRANCH, ACCOUNT"
                    SQL = SQL & " HAVING (SUM(NOMINAL_CC)>0 AND ROUND(SUM(NOMINAL_CC)-SUM(PAYMENT_CC),3)<0) OR (SUM(NOMINAL_CC)<0 AND ROUND(SUM(NOMINAL_CC)-SUM(PAYMENT_CC),3)>0)"
                    rsSL = db.OpenRemoteSet(SQL)
                End If
                If Not rsSL.Eof AndAlso (toval(rsSL.fields("Nominal_CC")) > 0 And Math.Round(toval(rsSL.fields("Nominal_CC")) - toval(rsSL.fields("Payment_CC")), 4, MidpointRounding.AwayFromZero) < 0) Or (toval(rsSL.fields("Nominal_CC")) < 0 And Math.Round(toval(rsSL.fields("Nominal_CC")) - toval(rsSL.fields("Payment_CC")), 4, MidpointRounding.AwayFromZero) > 0) Then
                    ErrMsg = "Adjustment Amount Resulting Over Paid Amount for Voucher " & rs.fields("Doc_No") & " !"
                    Throw New Exception(ErrMsg)
                End If
                rs.MoveNext()
            Loop

            rs = db.OpenRemoteSet("Select * from pVoucher Where Voucher='" & RefNo & "'")
            If tostr(rs.fields("SL_Cat")) = "B" Then
                RefNo = tostr(rs.fields("RefNo"))
                rs = db.OpenRemoteSet("Select * from pVoucher Where Voucher='" & RefNo & "'")
            End If

            SQL = "SELECT VOUCHER, BRANCH, ACCOUNT, SUM(NOMINAL_CC) AS NOMINAL_CC, SUM(PAYMENT_CC) AS PAYMENT_CC            "
            SQL = SQL & " FROM "
            SQL = SQL & " ( "
            SQL = SQL & " SELECT VOUCHER, BRANCH, ACCOUNT, SUM(SL.NOMINAL) AS NOMINAL_CC,0 as PAYMENT_CC "
            SQL = SQL & " FROM PSLSUM SL "
            SQL = SQL & " WHERE (SL.VOUCHER='" & RefNo & "') AND (SL.BRANCH='" & Branch & "') AND (SL.ACCOUNT='" & rs.fields("Account") & "')"
            SQL = SQL & " GROUP BY VOUCHER, BRANCH, ACCOUNT            "
            SQL = SQL & " UNION ALL "
            SQL = SQL & " SELECT DOC_NO AS VOUCHER, BRANCH, ACCOUNT, 0 as NOMINAL_CC, SUM(NOMINAL_OC) AS PAYMENT_CC "
            SQL = SQL & " FROM R_SL_ALLOCATED_BY_VOUCHER('" & RefNo & "') SL "
            SQL = SQL & " WHERE SL.VOUCHER<>'" & Voucher & "' AND (SL.DOC_NO='" & RefNo & "') AND (SL.BRANCH='" & Branch & "') AND (SL.ACCOUNT='" & rs.fields("Account") & "') "
            SQL = SQL & " Group By DOC_NO, BRANCH, ACCOUNT            "
            SQL = SQL & " ) V"
            SQL = SQL & " GROUP BY VOUCHER, BRANCH, ACCOUNT"
            SQL = SQL & " HAVING (SUM(NOMINAL_CC)>0 AND ROUND(SUM(NOMINAL_CC)-SUM(PAYMENT_CC),3)<0) OR (SUM(NOMINAL_CC)<0 AND ROUND(SUM(NOMINAL_CC)-SUM(PAYMENT_CC),3)>0)"
            rsSL = db.OpenRemoteSet(SQL)
            If Not rsSL.Eof AndAlso (toval(rsSL.fields("Nominal_CC")) > 0 And Math.Round(toval(rsSL.fields("Nominal_CC")) - toval(rs.fields("Payment_CC")), 4, MidpointRounding.AwayFromZero) < 0) Or (toval(rsSL.fields("Nominal_CC")) < 0 And Math.Round(toval(rsSL.fields("Nominal_CC")) - toval(rs.fields("Payment_CC")), 4, MidpointRounding.AwayFromZero) > 0) Then
                ErrMsg = "Adjustment Amount Resulting Over Paid Amount for Voucher " & RefNo & " !"
                Throw New Exception(ErrMsg)
            End If

            rs.Edit()
            If toval(rs.fields("DebtorF")) = False Then
                rs.fields("Payment_CC") = toval(rs.fields("Payment_CC")) + Payment_CC
            Else
                rs.fields("Payment_CC") = toval(rs.fields("Payment_CC")) - Payment_CC
            End If
            rs.fields("NPayment") = toval(rs.fields("NPayment")) - nPayment
            If Not rs.Update Then Throw New Exception(db.ErrDesc)

            If Not Delete_WithholdingTaxByVoucherRef(Voucher) Then Throw New Exception(StrMsg)

            If Not db.Execute("Delete from pSL where Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)
            If Not db.Execute("Delete from pVoucher where Voucher='" & Voucher & "' and Posting_Flag=0") Then Throw New Exception(db.ErrDesc)
            If db.RecordsAffected = 0 Then Throw New Exception("Can't Delete Voucher !")

            If Not db.Execute("Update SysRequest Set Status='P',LUserID='" & dbUser & "', LUserDate='" & Format(Today.Date, "MM/DD/YYYY") & "',LUserTime='" & Time() & "' from SysRequest Where Status<>'P' and Param1='SEND' and Param2 in ('FA') and Param6='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)

            If Not db.ReleaseLockedObject("Voucher" & Voucher) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Voucher, "Payment Adjustment", "Drop : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    Private Function PreAddVoucherOCOD(ByVal InParam As Object(), ByRef Errmsg As String) As Boolean

        Dim rs As RemoteSet
        Dim br_End_Date As Date
        Dim br_Month As Integer
        Dim br_Year As Integer
        Dim FLockedDate As Date

        Dim Voucher As String
        Dim Branch As String
        Dim VoucherDate As Date


        Voucher = getInParamValue(InParam, 0)
        Branch = getInParamValue(InParam, 1)
        VoucherDate = getInParamValue(InParam, 2)

        On Error GoTo errmsg

        rs = db.OpenRemoteSet("Select * from Branch where branch='" & Branch & "'")
        If Not rs.Eof Then
            br_End_Date = todate(rs.fields("end_date"))
            br_Month = toval(rs.fields("Month"))
            br_Year = toval(rs.fields("year"))
        End If

        If Not db.GetPrivileges("ALLOWLOCKEDPERIOD") Then
            FLockedDate = GetFLockedDate(Branch)
            If DateDiff(DateInterval.Day, FLockedDate, VoucherDate) <= 0 Then
                Errmsg = "Transactions for this period have been closed, Check the Closing Date on " & FLockedDate
                GoTo errmsg
            End If
        End If

        If (DateDiff(DateInterval.Day, VoucherDate, br_End_Date) >= 0) Then
            Errmsg = "Backdated Transaction, Check the Ending Date on " & br_End_Date & " !"
            GoTo errmsg
        End If
        Return True
errmsg:
        Errmsg = StrError(Errmsg)
        Return False
    End Function
    Private Function PreEditVoucherOCOD(ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim rs As RemoteSet

        Dim Voucher As String
        Dim VoucherDate As Date

        Voucher = getInParamValue(InParam, 0)
        'Branch = getInParamValue(InParam, 1)
        VoucherDate = getInParamValue(InParam, 2)
        On Error GoTo errmsg

        rs = db.OpenRemoteSet("Select * from pVoucher Where Voucher='" & Voucher & "'")
        If rs.Eof Then
            ErrMsg = "No Voucher Data !"
            GoTo errmsg
        End If

        If Month(VoucherDate) + Year(VoucherDate) * 12 <> Month(rs.fields("Date")) + Year(rs.fields("Date")) * 12 Then
            If Not db.GetPrivileges("ALLOWCHANGEDATE") Then
                ErrMsg = "Not Allowed To Change Booking Date !"
                GoTo errmsg
            End If
        End If

        If rs.fields("BranchF") Then
            ErrMsg = "Branch Data Upload Constraint !"
            GoTo errmsg
        End If

        If Not rs.fields("BackDatedF") And rs.fields("Posting_Flag") = True Then
            ErrMsg = "Voucher Already Processed / Posted !"
            GoTo errmsg
        End If

        If rs.fields("RequestF") And UCase(rs.fields("RequestName")) <> UCase(dbUser) Then
            ErrMsg = "Document is being sent to User-'" & rs.fields("RequestName") & "' !"
            GoTo errmsg
        End If

        rs = db.OpenRemoteSet("Select Top 1 nSL.Voucher from nVoucher, nSL where nVoucher.DocNo='' and nSL.Voucher=nVoucher.Voucher and nSL.pVoucher='" & Voucher & "'", adOpenForwardonly)
        If Not rs.Eof Then
            ErrMsg = "Document Constraint With WithHolding Voucher. '" & tostr(rs.fields("Voucher")) & "' !"
            GoTo errmsg
        End If

        Return True
errmsg:
        ErrMsg = StrError(ErrMsg)
        Return False
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function DropVoucherOCOD(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter

            Voucher = getInParamValue(InParam, 0)

            If Not db.GetLockedObject("Voucher" & Voucher) Then Throw New Exception(db.ErrDesc)
            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='C' and Voucher='" & Voucher & "'")

            If rs.Eof Then
                ErrMsg = "No Voucher Data !"
                Throw New Exception(ErrMsg)
            End If

            If Not PreAddVoucherOCOD(InParam, ErrMsg) Then Throw New Exception(ErrMsg)
            If Not PreEditVoucherOCOD(InParam, ErrMsg) Then Throw New Exception(ErrMsg)

            If Not Save_Log_Object("pVoucher", "Voucher", Voucher, "ProAcc", rs.fields("ProAcc"), "ComAcc", rs.fields("ComAcc"), "Remarks", rs.fields("Remarks"), "", "", "", "Delete") Then Throw New Exception("Can't Save to Log !")

            ' Update Detail
            If toval(rs.fields("CreditorF")) Then
                If Not db.Execute("Update Voucher set Voucher.Payment_CC=Voucher.Payment_CC-SL.Nominal_OC, Voucher.NPayment=Voucher.NPayment-1 from nVoucher Voucher, pSL SL Where Voucher.DebtorF=1 and Voucher.SL_Cat='N' and Voucher.Voucher=SL.DOC_NO and SL.PaymentF=1 and SL.Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)
                If Not db.Execute("Update Voucher set Voucher.Payment_CC=Voucher.Payment_CC+SL.Nominal_OC, Voucher.NPayment=Voucher.NPayment-1 from nVoucher Voucher, pSL SL Where Voucher.CreditorF=1 and Voucher.SL_Cat='N' and Voucher.Voucher=SL.DOC_NO and SL.PaymentF=1 and SL.Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)
            Else
                If Not db.Execute("Update Voucher set Voucher.Payment_CC=Voucher.Payment_CC-SL.Nominal_OC, Voucher.NPayment=Voucher.NPayment-1 from nVoucher Voucher, pSL SL Where Voucher.CreditorF=1 and Voucher.SL_Cat='N' and Voucher.Voucher=SL.DOC_NO and SL.PaymentF=1 and SL.Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)
                If Not db.Execute("Update Voucher set Voucher.Payment_CC=Voucher.Payment_CC+SL.Nominal_OC, Voucher.NPayment=Voucher.NPayment-1 from nVoucher Voucher, pSL SL Where Voucher.DebtorF=1 and Voucher.SL_Cat='N' and Voucher.Voucher=SL.DOC_NO and SL.PaymentF=1 and SL.Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)
            End If

            If Not db.Execute("Delete from pSL where Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)
            If Not db.Execute("Delete from pVoucher where Voucher='" & Voucher & "' and Posting_Flag=0") Then Throw New Exception(db.ErrDesc)
            If db.RecordsAffected = 0 Then Throw New Exception("Can't Delete Voucher !")

            If Not db.Execute("Update SysRequest Set Status='P',LUserID='" & dbUser & "', LUserDate='" & Format(Today.Date, "MM/DD/YYYY") & "',LUserTime='" & Time() & "' from SysRequest Where Status<>'P' and Param1='SEND' and Param2 in ('FA') and Param6='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)

            If Not db.ReleaseLockedObject("Voucher" & Voucher) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Voucher, "Compensation Voucher", "Drop : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function SearchVoucherTR(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String = getInParamValue(InParam, 0)
            Dim VoucherSDate As String = getInParamValue(InParam, 1)    ' Formatted Date MM/DD/YYYY
            Dim VoucherEDate As String = getInParamValue(InParam, 2)    ' Formatted Date MM/DD/YYYY
            Dim VType As String = getInParamValue(InParam, 3)
            Dim Branch As String = getInParamValue(InParam, 4)
            Dim ProAcc As String = getInParamValue(InParam, 5)
            Dim ComAcc As String = getInParamValue(InParam, 6)
            Dim Currency As String = getInParamValue(InParam, 7)
            Dim DocNo As String = getInParamValue(InParam, 8)
            Dim RefType As String = getInParamValue(InParam, 9)
            Dim RefNo As String = getInParamValue(InParam, 10)
            Dim RefDate As String = getInParamValue(InParam, 11)     ' Formatted Date MM/DD/YYYY
            Dim Remarks As String = getInParamValue(InParam, 12)
            Dim Last_Opr As String = getInParamValue(InParam, 13)
            Dim Status As String = getInParamValue(InParam, 14)      ' Not Approved / Approved / Posted

            Dim SQL As String
            SQL = "Select Cast(0 as bit) as ProcessFlag, V.Voucher, V.DebtorF, V.CreditorF, V.Branch, V.RefNo, V.RefDate, V.DocNo, V.RefType, V.AccountNo, V.Date, V.Vtype, VType.Description as VTypeDesc, V.SL_Cat, V.Status, V.Last_Opr, V.Last_Date, V.Last_Time, "
            SQL = SQL & " V.Remarks, V.ProAcc, P.Description as PDescription, V.ComAcc, C.Description as CDescription, V.Currency, V.Nominal_CC-V.Diff_CC as Nominal,"
            SQL = SQL & " V.Payment_OC+V.Payment_CC as Payment, coalesce(A1.Nominal_CC-V.Payment_OC-V.Payment_CC ,0) as UnPayment"
            SQL = SQL & " from pVoucher V Inner Join fn_userVType('" & dbUser & "') VType on (VType.VType=V.VType) Left Join ProAcc P on (P.ProAcc=V.ProAcc) Left Join ComAcc C on (C.ComAcc=V.ComAcc) Left Join Open_Item_Voucher_P('') as a1 on (a1.Voucher=V.Voucher) "
            SQL = SQL & " Where V.SL_Cat='P' and V.DebtorF=1 and C.NonCBF=0 and Upper(VType.[Code])<>'INTERBANK'"
            If Voucher <> "" Then
                SQL = SQL & " and V.Voucher Like '" & Voucher & "%'"
            End If

            If VoucherSDate <> "" And VoucherEDate <> "" Then
                SQL = SQL & " and V.Date Between '" & VoucherSDate & "' and '" & VoucherEDate & "'"
            ElseIf VoucherSDate <> "" Then
                SQL = SQL & " and V.Date = '" & VoucherSDate & "'"
            ElseIf VoucherEDate <> "" Then
                SQL = SQL & " and V.Date = '" & VoucherEDate & "'"
            End If

            If VType <> "" Then
                SQL = SQL & " and V.VType Like '" & VType & "%'"
            End If
            If Branch <> "" Then
                SQL = SQL & " and V.Branch Like '" & Branch & "%'"
            End If
            If ProAcc <> "" Then
                SQL = SQL & " and V.ProAcc Like '" & ProAcc & "%'"
            End If
            If ComAcc <> "" Then
                SQL = SQL & " and V.ComAcc Like '" & ComAcc & "%'"
            End If
            If Currency <> "" Then
                SQL = SQL & " and V.Currency Like '" & Currency & "%'"
            End If
            If DocNo <> "" Then
                SQL = SQL & " and V.DocNo Like '" & DocNo & "%'"
            End If
            If RefType <> "" Then
                SQL = SQL & " and V.RefType Like '" & RefType & "%'"
            End If
            If RefNo <> "" Then
                SQL = SQL & " and V.RefNo Like '" & RefNo & "%'"
            End If
            If RefDate <> "" Then
                SQL = SQL & " and V.RefDate='" & RefDate & "'"
            End If
            If Remarks <> "" Then
                SQL = SQL & " and V.Remarks Like '" & Remarks & "%'"
            End If
            If Last_Opr <> "" Then
                SQL = SQL & " and V.Last_Opr Like '" & Last_Opr & "%'"
            End If
            Select Case Status
                Case "Not Approved"
                    SQL = SQL & " and V.Status='N'"
                Case "Approved"
                    SQL = SQL & " and V.Status='U'"
                Case "Posted"
                    SQL = SQL & " and V.Status='P'"
            End Select
            If db.GetUserType <> "SUPERVISOR" Then
                SQL = SQL & " and Exists (Select S.Branch from SysUserBranch S Where S.Branch=V.Branch and S.ID='" & dbUser & "' and S.AllowedF=1)"
                SQL = SQL & " and (coalesce(V.CT,'')='' or Exists (Select S.CT from FN_UserCT('" & dbUser & "',V.Branch,'') S Where S.CT=V.CT))"
            End If

            Dim rs As RemoteSet
            Dim C_MaxRecords As Long
            C_MaxRecords = toval(GetAppSetting("CareMaxRecords"))
            If toval(GetAppSetting("CareMaxRecords_FA")) > C_MaxRecords Then
                C_MaxRecords = toval(GetAppSetting("CareMaxRecords_FA"))
            End If
            rs = db.OpenRemoteSet(SQL, , , , C_MaxRecords)
            Dataset = rs.GetDataSet

            If Dataset Is Nothing Then Throw New Exception(ErrMsg)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SearchVoucherMR(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String = getInParamValue(InParam, 0)
            Dim VoucherSDate As String = getInParamValue(InParam, 1)    ' Formatted Date MM/DD/YYYY
            Dim VoucherEDate As String = getInParamValue(InParam, 2)    ' Formatted Date MM/DD/YYYY
            Dim VType As String = getInParamValue(InParam, 3)
            Dim Branch As String = getInParamValue(InParam, 4)
            Dim ProAcc As String = getInParamValue(InParam, 5)
            Dim ComAcc As String = getInParamValue(InParam, 6)
            Dim Currency As String = getInParamValue(InParam, 7)
            Dim DocNo As String = getInParamValue(InParam, 8)
            Dim RefType As String = getInParamValue(InParam, 9)
            Dim RefNo As String = getInParamValue(InParam, 10)
            Dim RefDate As String = getInParamValue(InParam, 11)     ' Formatted Date MM/DD/YYYY
            Dim Remarks As String = getInParamValue(InParam, 12)
            Dim Last_Opr As String = getInParamValue(InParam, 13)
            Dim Status As String = getInParamValue(InParam, 14)      ' Not Approved / Approved / Posted

            Dim SQL As String
            SQL = "Select Cast(0 as bit) as ProcessFlag, V.Voucher, V.DebtorF, V.CreditorF, V.Branch, V.RefNo, V.DocNo, V.RefType, V.AccountNo, V.Date, V.Vtype, V.SL_Cat, V.Status, V.Last_Opr, V.Last_Date, V.Last_Time, "
            SQL = SQL & " V.Remarks, V.ProAcc, P.Description as PDescription, V.ComAcc, C.Description as CDescription, V.Currency, V.Nominal_CC-V.Diff_CC as Nominal,"
            SQL = SQL & " V.Payment_OC+V.Payment_CC as Payment, coalesce(A1.Nominal_CC-V.Payment_OC-V.Payment_CC,0) as UnPayment"
            SQL = SQL & " from pVoucher V Inner Join fn_userVType('" & dbUser & "') VType on (VType.VType=V.VType) Left Join ProAcc P on (P.ProAcc=V.ProAcc) Left Join ComAcc C on (C.ComAcc=V.ComAcc) Left Join Open_Item_Voucher_P('') as a1 on (a1.Voucher=V.Voucher) "
            SQL = SQL & " Where V.SL_Cat='P' and V.DebtorF=1 and C.NonCBF=1"
            If Voucher <> "" Then
                SQL = SQL & " and V.Voucher Like '" & Voucher & "%'"
            End If

            If VoucherSDate <> "" And VoucherEDate <> "" Then
                SQL = SQL & " and V.Date Between '" & VoucherSDate & "' and '" & VoucherEDate & "'"
            ElseIf VoucherSDate <> "" Then
                SQL = SQL & " and V.Date = '" & VoucherSDate & "'"
            ElseIf VoucherEDate <> "" Then
                SQL = SQL & " and V.Date = '" & VoucherEDate & "'"
            End If

            If VType <> "" Then
                SQL = SQL & " and V.VType Like '" & VType & "%'"
            End If
            If Branch <> "" Then
                SQL = SQL & " and V.Branch Like '" & Branch & "%'"
            End If
            If ProAcc <> "" Then
                SQL = SQL & " and V.ProAcc Like '" & ProAcc & "%'"
            End If
            If ComAcc <> "" Then
                SQL = SQL & " and V.ComAcc Like '" & ComAcc & "%'"
            End If
            If Currency <> "" Then
                SQL = SQL & " and V.Currency Like '" & Currency & "%'"
            End If
            If DocNo <> "" Then
                SQL = SQL & " and V.DocNo Like '" & DocNo & "%'"
            End If
            If RefType <> "" Then
                SQL = SQL & " and V.RefType Like '" & RefType & "%'"
            End If
            If RefNo <> "" Then
                SQL = SQL & " and V.RefNo Like '" & RefNo & "%'"
            End If
            If RefDate <> "" Then
                SQL = SQL & " and V.RefDate='" & RefDate & "'"
            End If
            If Remarks <> "" Then
                SQL = SQL & " and V.Remarks Like '" & Remarks & "%'"
            End If
            If Last_Opr <> "" Then
                SQL = SQL & " and V.Last_Opr Like '" & Last_Opr & "%'"
            End If
            Select Case Status
                Case "Not Approved"
                    SQL = SQL & " and V.Status='N'"
                Case "Approved"
                    SQL = SQL & " and V.Status='U'"
                Case "Posted"
                    SQL = SQL & " and V.Status='P'"
            End Select
            If db.GetUserType <> "SUPERVISOR" Then
                SQL = SQL & " and Exists (Select S.Branch from SysUserBranch S Where S.Branch=V.Branch and S.ID='" & dbUser & "' and S.AllowedF=1)"
                SQL = SQL & " and (coalesce(V.CT,'')='' or Exists (Select S.CT from FN_UserCT('" & dbUser & "',V.Branch,'') S Where S.CT=V.CT))"
            End If

            Dim rs As RemoteSet
            Dim C_MaxRecords As Long
            C_MaxRecords = toval(GetAppSetting("CareMaxRecords"))
            If toval(GetAppSetting("CareMaxRecords_FA")) > C_MaxRecords Then
                C_MaxRecords = toval(GetAppSetting("CareMaxRecords_FA"))
            End If
            rs = db.OpenRemoteSet(SQL, , , , C_MaxRecords)
            Dataset = rs.GetDataSet

            If Dataset Is Nothing Then Throw New Exception(ErrMsg)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function SearchVoucherTP(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String = getInParamValue(InParam, 0)
            Dim VoucherSDate As String = getInParamValue(InParam, 1)    ' Formatted Date MM/DD/YYYY
            Dim VoucherEDate As String = getInParamValue(InParam, 2)    ' Formatted Date MM/DD/YYYY
            Dim VType As String = getInParamValue(InParam, 3)
            Dim Branch As String = getInParamValue(InParam, 4)
            Dim ProAcc As String = getInParamValue(InParam, 5)
            Dim ComAcc As String = getInParamValue(InParam, 6)
            Dim Currency As String = getInParamValue(InParam, 7)
            Dim DocNo As String = getInParamValue(InParam, 8)
            Dim RefType As String = getInParamValue(InParam, 9)
            Dim RefNo As String = getInParamValue(InParam, 10)
            Dim RefDate As String = getInParamValue(InParam, 11)     ' Formatted Date MM/DD/YYYY
            Dim Remarks As String = getInParamValue(InParam, 12)
            Dim Last_Opr As String = getInParamValue(InParam, 13)
            Dim Status As String = getInParamValue(InParam, 14)      ' Not Approved / Approved / Posted
            Dim BankAccount As String = getInParamValue(InParam, 15)      ' CN/DN Bank Account Name
            Dim NotPrintLogF As Boolean = toval(getInParamValue(InParam, 16))      ' Not in Print Log

            Dim SQL As String
            SQL = "Select Cast(0 as bit) as ProcessFlag, V.Voucher, V.DebtorF, V.CreditorF, V.Branch, V.RefNo, V.RefDate, V.DocNo, V.RefType, V.Date, "
            SQL = SQL & " V.AccountNo, V.BankAccount, V.BankName, V.DueDate, "
            SQL = SQL & " V.Vtype, VType.Description as VTypeDesc, V.SL_Cat, V.Status, V.Last_Opr, V.Last_Date, V.Last_Time, "
            SQL = SQL & " V.Remarks, V.ProAcc, P.Description as PDescription, V.ComAcc, C.Description as CDescription, V.Currency, V.Nominal_CC-V.Diff_CC as Nominal,"
            SQL = SQL & " V.Payment_OC+V.Payment_CC as Payment, coalesce(A1.Nominal_CC-V.Payment_OC-V.Payment_CC,0) as UnPayment"
            SQL = SQL & " from pVoucher V Inner Join fn_userVType('" & dbUser & "') VType on (VType.VType=V.VType) Left Join ProAcc P on (P.ProAcc=V.ProAcc) Left Join ComAcc C on (C.ComAcc=V.ComAcc) Left Join Open_Item_Voucher_P('') as a1 on (a1.Voucher=V.Voucher) "
            SQL = SQL & " Where V.SL_Cat='P' and V.CreditorF=1 and C.NonCBF=0 and Upper(VType.[Code])<>'INTERBANK'"
            If Voucher <> "" Then
                SQL = SQL & " and V.Voucher Like '" & Voucher & "%'"
            End If

            If VoucherSDate <> "" And VoucherEDate <> "" Then
                SQL = SQL & " and V.Date Between '" & VoucherSDate & "' and '" & VoucherEDate & "'"
            ElseIf VoucherSDate <> "" Then
                SQL = SQL & " and V.Date = '" & VoucherSDate & "'"
            ElseIf VoucherEDate <> "" Then
                SQL = SQL & " and V.Date = '" & VoucherEDate & "'"
            End If

            If VType <> "" Then
                SQL = SQL & " and V.VType Like '" & VType & "%'"
            End If
            If Branch <> "" Then
                SQL = SQL & " and V.Branch Like '" & Branch & "%'"
            End If
            If ProAcc <> "" Then
                SQL = SQL & " and V.ProAcc Like '" & ProAcc & "%'"
            End If
            If ComAcc <> "" Then
                SQL = SQL & " and V.ComAcc Like '" & ComAcc & "%'"
            End If
            If Currency <> "" Then
                SQL = SQL & " and V.Currency Like '" & Currency & "%'"
            End If
            If DocNo <> "" Then
                SQL = SQL & " and V.DocNo Like '" & DocNo & "%'"
            End If
            If RefType <> "" Then
                SQL = SQL & " and V.RefType Like '" & RefType & "%'"
            End If
            If RefNo <> "" Then
                SQL = SQL & " and V.RefNo Like '" & RefNo & "%'"
            End If
            If RefDate <> "" Then
                SQL = SQL & " and V.RefDate='" & RefDate & "'"
            End If
            If Remarks <> "" Then
                SQL = SQL & " and V.Remarks Like '" & Remarks & "%'"
            End If
            If Last_Opr <> "" Then
                SQL = SQL & " and V.Last_Opr Like '" & Last_Opr & "%'"
            End If
            Select Case Status
                Case "Not Approved"
                    SQL = SQL & " and V.Status='N'"
                Case "Approved"
                    SQL = SQL & " and V.Status='U'"
                Case "Posted"
                    SQL = SQL & " and V.Status='P'"
            End Select
            If BankAccount <> "" Then
                SQL = SQL & " and Exists (Select Top 1 SL.Voucher from pSL SL, nVoucher Voucher Where SL.Voucher=V.Voucher and SL.PaymentF=1 and Voucher.Voucher=SL.Doc_No and Voucher.BankAccount Like '" & BankAccount & "%')"
            End If
            If NotPrintLogF Then
                SQL = SQL & " and Not Exists (Select Top 1 vPrintLog.Voucher from vPrintLog Where vPrintLog.Voucher=V.Voucher)"
            End If
            If db.GetUserType <> "SUPERVISOR" Then
                SQL = SQL & " and Exists (Select S.Branch from SysUserBranch S Where S.Branch=V.Branch and S.ID='" & dbUser & "' and S.AllowedF=1)"
                SQL = SQL & " and (coalesce(V.CT,'')='' or Exists (Select S.CT from FN_UserCT('" & dbUser & "',V.Branch,'') S Where S.CT=V.CT))"
            End If

            Dim rs As RemoteSet
            Dim C_MaxRecords As Long
            C_MaxRecords = toval(GetAppSetting("CareMaxRecords"))
            If toval(GetAppSetting("CareMaxRecords_FA")) > C_MaxRecords Then
                C_MaxRecords = toval(GetAppSetting("CareMaxRecords_FA"))
            End If
            rs = db.OpenRemoteSet(SQL, , , , C_MaxRecords)
            Dataset = rs.GetDataSet

            If Dataset Is Nothing Then Throw New Exception(ErrMsg)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SearchVoucherIR(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String = getInParamValue(InParam, 0)
            Dim VoucherSDate As String = getInParamValue(InParam, 1)    ' Formatted Date MM/DD/YYYY
            Dim VoucherEDate As String = getInParamValue(InParam, 2)    ' Formatted Date MM/DD/YYYY
            Dim VType As String = getInParamValue(InParam, 3)
            Dim Branch As String = getInParamValue(InParam, 4)
            Dim ProAcc As String = getInParamValue(InParam, 5)
            Dim ComAcc As String = getInParamValue(InParam, 6)
            Dim Currency As String = getInParamValue(InParam, 7)
            Dim DocNo As String = getInParamValue(InParam, 8)
            Dim RefType As String = getInParamValue(InParam, 9)
            Dim RefNo As String = getInParamValue(InParam, 10)
            Dim RefDate As String = getInParamValue(InParam, 11)     ' Formatted Date MM/DD/YYYY
            Dim Remarks As String = getInParamValue(InParam, 12)
            Dim Last_Opr As String = getInParamValue(InParam, 13)
            Dim Status As String = getInParamValue(InParam, 14)      ' Not Approved / Approved / Posted

            Dim SQL As String
            SQL = "Select Cast(0 as bit) as ProcessFlag, V.Voucher, V.DebtorF, V.CreditorF, V.Branch, V.RefNo, V.DocNo, V.RefType, V.AccountNo, V.Date, V.Vtype, V.SL_Cat, V.Status, V.Last_Opr, V.Last_Date, V.Last_Time, "
            SQL = SQL & " V.Remarks, V.ProAcc, P.Description as PDescription, V.ComAcc, C.Description as CDescription, V.Currency, V.Nominal_CC-V.Diff_CC as Nominal,"
            SQL = SQL & " V.Payment_OC+V.Payment_CC as Payment, coalesce(A1.Nominal_CC-V.Payment_OC-V.Payment_CC,0) as UnPayment"
            SQL = SQL & " from pVoucher V Inner Join fn_userVType('" & dbUser & "') VType on (VType.VType=V.VType) Left Join ProAcc P on (P.ProAcc=V.ProAcc) Left Join ComAcc C on (C.ComAcc=V.ComAcc) Left Join Open_Item_Voucher_P('') as a1 on (a1.Voucher=V.Voucher) "
            SQL = SQL & " Where V.SL_Cat='P' and V.DebtorF=1 and Upper(VType.[Code])='INTERBANK'"
            If Voucher <> "" Then
                SQL = SQL & " and V.Voucher Like '" & Voucher & "%'"
            End If
            If VoucherSDate <> "" And VoucherEDate <> "" Then
                SQL = SQL & " and V.Date Between '" & VoucherSDate & "' and '" & VoucherEDate & "'"
            ElseIf VoucherSDate <> "" Then
                SQL = SQL & " and V.Date = '" & VoucherSDate & "'"
            ElseIf VoucherEDate <> "" Then
                SQL = SQL & " and V.Date = '" & VoucherEDate & "'"
            End If
            If VType <> "" Then
                SQL = SQL & " and V.VType Like '" & VType & "%'"
            End If
            If Branch <> "" Then
                SQL = SQL & " and V.Branch Like '" & Branch & "%'"
            End If
            If ProAcc <> "" Then
                SQL = SQL & " and V.ProAcc Like '" & ProAcc & "%'"
            End If
            If ComAcc <> "" Then
                SQL = SQL & " and V.ComAcc Like '" & ComAcc & "%'"
            End If
            If Currency <> "" Then
                SQL = SQL & " and V.Currency Like '" & Currency & "%'"
            End If
            If DocNo <> "" Then
                SQL = SQL & " and V.DocNo Like '" & DocNo & "%'"
            End If
            If RefType <> "" Then
                SQL = SQL & " and V.RefType Like '" & RefType & "%'"
            End If
            If RefNo <> "" Then
                SQL = SQL & " and V.RefNo Like '" & RefNo & "%'"
            End If
            If RefDate <> "" Then
                SQL = SQL & " and V.RefDate='" & RefDate & "'"
            End If
            If Remarks <> "" Then
                SQL = SQL & " and V.Remarks Like '" & Remarks & "%'"
            End If
            If Last_Opr <> "" Then
                SQL = SQL & " and V.Last_Opr Like '" & Last_Opr & "%'"
            End If
            Select Case Status
                Case "Not Approved"
                    SQL = SQL & " and V.Status='N'"
                Case "Approved"
                    SQL = SQL & " and V.Status='U'"
                Case "Posted"
                    SQL = SQL & " and V.Status='P'"
            End Select
            If db.GetUserType <> "SUPERVISOR" Then
                SQL = SQL & " and Exists (Select S.Branch from SysUserBranch S Where S.Branch=V.Branch and S.ID='" & dbUser & "' and S.AllowedF=1)"
                SQL = SQL & " and (coalesce(V.CT,'')='' or Exists (Select S.CT from FN_UserCT('" & dbUser & "',V.Branch,'') S Where S.CT=V.CT))"
            End If

            Dim rs As RemoteSet
            Dim C_MaxRecords As Long
            C_MaxRecords = toval(GetAppSetting("CareMaxRecords"))
            If toval(GetAppSetting("CareMaxRecords_FA")) > C_MaxRecords Then
                C_MaxRecords = toval(GetAppSetting("CareMaxRecords_FA"))
            End If
            rs = db.OpenRemoteSet(SQL, , , , C_MaxRecords)
            Dataset = rs.GetDataSet

            If Dataset Is Nothing Then Throw New Exception(ErrMsg)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SearchVoucherIP(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String = getInParamValue(InParam, 0)
            Dim VoucherSDate As String = getInParamValue(InParam, 1)    ' Formatted Date MM/DD/YYYY
            Dim VoucherEDate As String = getInParamValue(InParam, 2)    ' Formatted Date MM/DD/YYYY
            Dim VType As String = getInParamValue(InParam, 3)
            Dim Branch As String = getInParamValue(InParam, 4)
            Dim ProAcc As String = getInParamValue(InParam, 5)
            Dim ComAcc As String = getInParamValue(InParam, 6)
            Dim Currency As String = getInParamValue(InParam, 7)
            Dim DocNo As String = getInParamValue(InParam, 8)
            Dim RefType As String = getInParamValue(InParam, 9)
            Dim RefNo As String = getInParamValue(InParam, 10)
            Dim RefDate As String = getInParamValue(InParam, 11)     ' Formatted Date MM/DD/YYYY
            Dim Remarks As String = getInParamValue(InParam, 12)
            Dim Last_Opr As String = getInParamValue(InParam, 13)
            Dim Status As String = getInParamValue(InParam, 14)      ' Not Approved / Approved / Posted

            Dim SQL As String
            SQL = "Select Cast(0 as bit) as ProcessFlag, V.Voucher, V.DebtorF, V.CreditorF, V.Branch, V.RefNo, V.DocNo, V.RefType, V.AccountNo, V.Date, V.Vtype, V.SL_Cat, V.Status, V.Last_Opr, V.Last_Date, V.Last_Time, "
            SQL = SQL & " V.Remarks, V.ProAcc, P.Description as PDescription, V.ComAcc, C.Description as CDescription, V.Currency, V.Nominal_CC-V.Diff_CC as Nominal,"
            SQL = SQL & " V.Payment_OC+V.Payment_CC as Payment, coalesce(A1.Nominal_CC-V.Payment_OC-V.Payment_CC,0) as UnPayment"
            SQL = SQL & " from pVoucher V Inner Join fn_userVType('" & dbUser & "') VType on (VType.VType=V.VType) Left Join ProAcc P on (P.ProAcc=V.ProAcc) Left Join ComAcc C on (C.ComAcc=V.ComAcc) Left Join Open_Item_Voucher_P('') as a1 on (a1.Voucher=V.Voucher) "
            SQL = SQL & " Where V.SL_Cat='P' and V.CreditorF=1 and Upper(VType.[Code])='INTERBANK'"
            If Voucher <> "" Then
                SQL = SQL & " and V.Voucher Like '" & Voucher & "%'"
            End If
            If VoucherSDate <> "" And VoucherEDate <> "" Then
                SQL = SQL & " and V.Date Between '" & VoucherSDate & "' and '" & VoucherEDate & "'"
            ElseIf VoucherSDate <> "" Then
                SQL = SQL & " and V.Date = '" & VoucherSDate & "'"
            ElseIf VoucherEDate <> "" Then
                SQL = SQL & " and V.Date = '" & VoucherEDate & "'"
            End If
            If VType <> "" Then
                SQL = SQL & " and V.VType Like '" & VType & "%'"
            End If
            If Branch <> "" Then
                SQL = SQL & " and V.Branch Like '" & Branch & "%'"
            End If
            If ProAcc <> "" Then
                SQL = SQL & " and V.ProAcc Like '" & ProAcc & "%'"
            End If
            If ComAcc <> "" Then
                SQL = SQL & " and V.ComAcc Like '" & ComAcc & "%'"
            End If
            If Currency <> "" Then
                SQL = SQL & " and V.Currency Like '" & Currency & "%'"
            End If
            If DocNo <> "" Then
                SQL = SQL & " and V.DocNo Like '" & DocNo & "%'"
            End If
            If RefType <> "" Then
                SQL = SQL & " and V.RefType Like '" & RefType & "%'"
            End If
            If RefNo <> "" Then
                SQL = SQL & " and V.RefNo Like '" & RefNo & "%'"
            End If
            If RefDate <> "" Then
                SQL = SQL & " and V.RefDate='" & RefDate & "'"
            End If
            If Remarks <> "" Then
                SQL = SQL & " and V.Remarks Like '" & Remarks & "%'"
            End If
            If Last_Opr <> "" Then
                SQL = SQL & " and V.Last_Opr Like '" & Last_Opr & "%'"
            End If
            Select Case Status
                Case "Not Approved"
                    SQL = SQL & " and V.Status='N'"
                Case "Approved"
                    SQL = SQL & " and V.Status='U'"
                Case "Posted"
                    SQL = SQL & " and V.Status='P'"
            End Select
            If db.GetUserType <> "SUPERVISOR" Then
                SQL = SQL & " and Exists (Select S.Branch from SysUserBranch S Where S.Branch=V.Branch and S.ID='" & dbUser & "' and S.AllowedF=1)"
                SQL = SQL & " and (coalesce(V.CT,'')='' or Exists (Select S.CT from FN_UserCT('" & dbUser & "',V.Branch,'') S Where S.CT=V.CT))"
            End If
            SQL = SQL & " and Exists (Select VType From VType Where Vtype.Vtype=V.VType and Upper(VType.[Code])='INTERBANK')"

            Dim rs As RemoteSet
            Dim C_MaxRecords As Long
            C_MaxRecords = toval(GetAppSetting("CareMaxRecords"))
            If toval(GetAppSetting("CareMaxRecords_FA")) > C_MaxRecords Then
                C_MaxRecords = toval(GetAppSetting("CareMaxRecords_FA"))
            End If
            rs = db.OpenRemoteSet(SQL, , , , C_MaxRecords)
            Dataset = rs.GetDataSet

            If Dataset Is Nothing Then Throw New Exception(ErrMsg)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function SearchVoucherRAPA(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String = getInParamValue(InParam, 0)
            Dim VoucherDate As String = getInParamValue(InParam, 1)    ' Formatted Date MM/DD/YYYY
            Dim VType As String = getInParamValue(InParam, 2)
            Dim Branch As String = getInParamValue(InParam, 3)
            Dim ProAcc As String = getInParamValue(InParam, 4)
            Dim ComAcc As String = getInParamValue(InParam, 5)
            Dim Currency As String = getInParamValue(InParam, 6)
            Dim DocNo As String = getInParamValue(InParam, 7)
            Dim RefType As String = getInParamValue(InParam, 8)
            Dim RefNo As String = getInParamValue(InParam, 9)
            Dim RefDate As String = getInParamValue(InParam, 10)     ' Formatted Date MM/DD/YYYY
            Dim Remarks As String = getInParamValue(InParam, 11)
            Dim Last_Opr As String = getInParamValue(InParam, 12)
            Dim Status As String = getInParamValue(InParam, 13)      ' Not Approved / Approved / Posted

            Dim SQL As String
            SQL = "Select Cast(0 as bit) as ProcessFlag, V.Voucher, V.DebtorF, V.CreditorF, V.Branch, V.RefNo, V.DocNo, V.RefType, V.AccountNo, V.Date, V.Vtype, V.SL_Cat, V.Status, V.Last_Opr, V.Last_Date, V.Last_Time, "
            SQL = SQL & " V.Remarks, V.ProAcc, P.Description as PDescription, V.ComAcc, C.Description as CDescription, V.Currency, V.Nominal_CC-V.Diff_CC as Nominal,"
            SQL = SQL & " V.Payment_OC+V.Payment_CC as Payment, coalesce(A1.Nominal_CC-V.Payment_OC-V.Payment_CC,0) as UnPayment"
            SQL = SQL & " from pVoucher V Inner Join fn_userVType('" & dbUser & "') VType on (VType.VType=V.VType) Left Join ProAcc P on (P.ProAcc=V.ProAcc) Left Join ComAcc C on (C.ComAcc=V.ComAcc) Left Join Open_Item_Voucher_P('') as a1 on (a1.Voucher=V.Voucher) "
            SQL = SQL & " Where V.SL_Cat='A'"
            If Voucher <> "" Then
                SQL = SQL & " and V.Voucher Like '" & Voucher & "%'"
            End If
            If VoucherDate <> "" Then
                SQL = SQL & " and V.Date='" & VoucherDate & "'"
            End If
            If VType <> "" Then
                SQL = SQL & " and V.VType Like '" & VType & "%'"
            End If
            If Branch <> "" Then
                SQL = SQL & " and V.Branch Like '" & Branch & "%'"
            End If
            If ProAcc <> "" Then
                SQL = SQL & " and V.ProAcc Like '" & ProAcc & "%'"
            End If
            If ComAcc <> "" Then
                SQL = SQL & " and V.ComAcc Like '" & ComAcc & "%'"
            End If
            If Currency <> "" Then
                SQL = SQL & " and V.Currency Like '" & Currency & "%'"
            End If
            If DocNo <> "" Then
                SQL = SQL & " and V.DocNo Like '" & DocNo & "%'"
            End If
            If RefType <> "" Then
                SQL = SQL & " and V.RefType Like '" & RefType & "%'"
            End If
            If RefNo <> "" Then
                SQL = SQL & " and V.RefNo Like '" & RefNo & "%'"
            End If
            If RefDate <> "" Then
                SQL = SQL & " and V.RefDate='" & RefDate & "'"
            End If
            If Remarks <> "" Then
                SQL = SQL & " and V.Remarks Like '" & Remarks & "%'"
            End If
            If Last_Opr <> "" Then
                SQL = SQL & " and V.Last_Opr Like '" & Last_Opr & "%'"
            End If
            Select Case Status
                Case "Not Approved"
                    SQL = SQL & " and V.Status='N'"
                Case "Approved"
                    SQL = SQL & " and V.Status='U'"
                Case "Posted"
                    SQL = SQL & " and V.Status='P'"
            End Select
            If db.GetUserType <> "SUPERVISOR" Then
                SQL = SQL & " and Exists (Select S.Branch from SysUserBranch S Where S.Branch=V.Branch and S.ID='" & dbUser & "' and S.AllowedF=1)"
                SQL = SQL & " and (coalesce(V.CT,'')='' or Exists (Select S.CT from FN_UserCT('" & dbUser & "',V.Branch,'') S Where S.CT=V.CT))"
            End If

            Dim rs As RemoteSet
            Dim C_MaxRecords As Long
            C_MaxRecords = toval(GetAppSetting("CareMaxRecords"))
            If toval(GetAppSetting("CareMaxRecords_FA")) > C_MaxRecords Then
                C_MaxRecords = toval(GetAppSetting("CareMaxRecords_FA"))
            End If
            rs = db.OpenRemoteSet(SQL, , , , C_MaxRecords)
            Dataset = rs.GetDataSet

            If Dataset Is Nothing Then Throw New Exception(ErrMsg)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SearchVoucherOROP(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String = getInParamValue(InParam, 0)
            Dim VoucherDate As String = getInParamValue(InParam, 1)    ' Formatted Date MM/DD/YYYY
            Dim VType As String = getInParamValue(InParam, 2)
            Dim Branch As String = getInParamValue(InParam, 3)
            Dim ProAcc As String = getInParamValue(InParam, 4)
            Dim ComAcc As String = getInParamValue(InParam, 5)
            Dim Currency As String = getInParamValue(InParam, 6)
            Dim DocNo As String = getInParamValue(InParam, 7)
            Dim RefType As String = getInParamValue(InParam, 8)
            Dim RefNo As String = getInParamValue(InParam, 9)
            Dim RefDate As String = getInParamValue(InParam, 10)     ' Formatted Date MM/DD/YYYY
            Dim Remarks As String = getInParamValue(InParam, 11)
            Dim Last_Opr As String = getInParamValue(InParam, 12)
            Dim Status As String = getInParamValue(InParam, 13)      ' Not Approved / Approved / Posted

            Dim SQL As String
            SQL = "Select Cast(0 as bit) as ProcessFlag, V.Voucher, V.DebtorF, V.CreditorF, V.Branch, V.RefNo, V.DocNo, V.RefType, V.AccountNo, V.Date, V.Vtype, V.SL_Cat, V.Status, V.Last_Opr, V.Last_Date, V.Last_Time, "
            SQL = SQL & " V.Remarks, V.ProAcc, P.Description as PDescription, V.ComAcc, C.Description as CDescription, V.Currency, V.Nominal_CC-V.Diff_CC as Nominal,"
            SQL = SQL & " V.Payment_OC+V.Payment_CC as Payment, coalesce(A1.Nominal_CC-V.Payment_OC-V.Payment_CC,0) as UnPayment"
            SQL = SQL & " from pVoucher V Inner Join fn_userVType('" & dbUser & "') VType on (VType.VType=V.VType) Left Join ProAcc P on (P.ProAcc=V.ProAcc) Left Join ComAcc C on (C.ComAcc=V.ComAcc) Left Join Open_Item_Voucher_P('') as a1 on (a1.Voucher=V.Voucher) "
            SQL = SQL & " Where V.SL_Cat='B'"
            If Voucher <> "" Then
                SQL = SQL & " and V.Voucher Like '" & Voucher & "%'"
            End If
            If VoucherDate <> "" Then
                SQL = SQL & " and V.Date='" & VoucherDate & "'"
            End If
            If VType <> "" Then
                SQL = SQL & " and V.VType Like '" & VType & "%'"
            End If
            If Branch <> "" Then
                SQL = SQL & " and V.Branch Like '" & Branch & "%'"
            End If
            If ProAcc <> "" Then
                SQL = SQL & " and V.ProAcc Like '" & ProAcc & "%'"
            End If
            If ComAcc <> "" Then
                SQL = SQL & " and V.ComAcc Like '" & ComAcc & "%'"
            End If
            If Currency <> "" Then
                SQL = SQL & " and V.Currency Like '" & Currency & "%'"
            End If
            If DocNo <> "" Then
                SQL = SQL & " and V.DocNo Like '" & DocNo & "%'"
            End If
            If RefType <> "" Then
                SQL = SQL & " and V.RefType Like '" & RefType & "%'"
            End If
            If RefNo <> "" Then
                SQL = SQL & " and V.RefNo Like '" & RefNo & "%'"
            End If
            If RefDate <> "" Then
                SQL = SQL & " and V.RefDate='" & RefDate & "'"
            End If
            If Remarks <> "" Then
                SQL = SQL & " and V.Remarks Like '" & Remarks & "%'"
            End If
            If Last_Opr <> "" Then
                SQL = SQL & " and V.Last_Opr Like '" & Last_Opr & "%'"
            End If
            Select Case Status
                Case "Not Approved"
                    SQL = SQL & " and V.Status='N'"
                Case "Approved"
                    SQL = SQL & " and V.Status='U'"
                Case "Posted"
                    SQL = SQL & " and V.Status='P'"
            End Select
            If db.GetUserType <> "SUPERVISOR" Then
                SQL = SQL & " and Exists (Select S.Branch from SysUserBranch S Where S.Branch=V.Branch and S.ID='" & dbUser & "' and S.AllowedF=1)"
                SQL = SQL & " and (coalesce(V.CT,'')='' or Exists (Select S.CT from FN_UserCT('" & dbUser & "',V.Branch,'') S Where S.CT=V.CT))"
            End If

            Dim rs As RemoteSet
            Dim C_MaxRecords As Long
            C_MaxRecords = toval(GetAppSetting("CareMaxRecords"))
            If toval(GetAppSetting("CareMaxRecords_FA")) > C_MaxRecords Then
                C_MaxRecords = toval(GetAppSetting("CareMaxRecords_FA"))
            End If
            rs = db.OpenRemoteSet(SQL, , , , C_MaxRecords)
            Dataset = rs.GetDataSet

            If Dataset Is Nothing Then Throw New Exception(ErrMsg)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function GetVoucherOROP(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef findex As String(), ByRef fbuffer As String(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String

            Voucher = getInParamValue(InParam, 0)
            Dim rs As RemoteSet

            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='B' and Voucher='" & Voucher & "'")
            findex = rs.fields_index
            fbuffer = rs.GetRecord

            rs = db.OpenRemoteSet("Select Cast(0 as bit) as ProcessFlag, pSL.*, cast('' as varchar(10)) as Branch from pSL where pSL.Voucher='" & Voucher & "' Order By pSL.SortNo")
            Dataset = rs.GetDataSet

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SearchVoucherOCOD(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String = getInParamValue(InParam, 0)
            Dim VoucherDate As String = getInParamValue(InParam, 1)    ' Formatted Date MM/DD/YYYY
            Dim VType As String = getInParamValue(InParam, 2)
            Dim Branch As String = getInParamValue(InParam, 3)
            Dim ProAcc As String = getInParamValue(InParam, 4)
            Dim ComAcc As String = getInParamValue(InParam, 5)
            Dim Currency As String = getInParamValue(InParam, 6)
            Dim DocNo As String = getInParamValue(InParam, 7)
            Dim RefType As String = getInParamValue(InParam, 8)
            Dim RefNo As String = getInParamValue(InParam, 9)
            Dim RefDate As String = getInParamValue(InParam, 10)     ' Formatted Date MM/DD/YYYY
            Dim Remarks As String = getInParamValue(InParam, 11)
            Dim Last_Opr As String = getInParamValue(InParam, 12)
            Dim Status As String = getInParamValue(InParam, 13)      ' Not Approved / Approved / Posted

            Dim SQL As String
            SQL = "Select Cast(0 as bit) as ProcessFlag, V.Voucher, V.DebtorF, V.CreditorF, V.Branch, V.RefNo, V.DocNo, V.RefType, V.AccountNo, V.Date, V.Vtype, V.SL_Cat, V.Status, V.Last_Opr, V.Last_Date, V.Last_Time, "
            SQL = SQL & " V.Remarks, V.ProAcc, P.Description as PDescription, V.ComAcc, C.Description as CDescription, V.Currency, V.Nominal_CC-V.Diff_CC as Nominal,"
            SQL = SQL & " V.Payment_OC+V.Payment_CC as Payment, coalesce(A1.Nominal_CC-V.Payment_OC-V.Payment_CC,0) as UnPayment"
            SQL = SQL & " from pVoucher V Inner Join fn_userVType('" & dbUser & "') VType on (VType.VType=V.VType) Left Join ProAcc P on (P.ProAcc=V.ProAcc) Left Join ComAcc C on (C.ComAcc=V.ComAcc) Left Join Open_Item_Voucher_P('') as a1 on (a1.Voucher=V.Voucher) "
            SQL = SQL & " Where V.SL_Cat='C'"
            If Voucher <> "" Then
                SQL = SQL & " and V.Voucher Like '" & Voucher & "%'"
            End If
            If VoucherDate <> "" Then
                SQL = SQL & " and V.Date='" & VoucherDate & "'"
            End If
            If VType <> "" Then
                SQL = SQL & " and V.VType Like '" & VType & "%'"
            End If
            If Branch <> "" Then
                SQL = SQL & " and V.Branch Like '" & Branch & "%'"
            End If
            If ProAcc <> "" Then
                SQL = SQL & " and V.ProAcc Like '" & ProAcc & "%'"
            End If
            If ComAcc <> "" Then
                SQL = SQL & " and V.ComAcc Like '" & ComAcc & "%'"
            End If
            If Currency <> "" Then
                SQL = SQL & " and V.Currency Like '" & Currency & "%'"
            End If
            If DocNo <> "" Then
                SQL = SQL & " and V.DocNo Like '" & DocNo & "%'"
            End If
            If RefType <> "" Then
                SQL = SQL & " and V.RefType Like '" & RefType & "%'"
            End If
            If RefNo <> "" Then
                SQL = SQL & " and V.RefNo Like '" & RefNo & "%'"
            End If
            If RefDate <> "" Then
                SQL = SQL & " and V.RefDate='" & RefDate & "'"
            End If
            If Remarks <> "" Then
                SQL = SQL & " and V.Remarks Like '" & Remarks & "%'"
            End If
            If Last_Opr <> "" Then
                SQL = SQL & " and V.Last_Opr Like '" & Last_Opr & "%'"
            End If
            Select Case Status
                Case "Not Approved"
                    SQL = SQL & " and V.Status='N'"
                Case "Approved"
                    SQL = SQL & " and V.Status='U'"
                Case "Posted"
                    SQL = SQL & " and V.Status='P'"
            End Select
            If db.GetUserType <> "SUPERVISOR" Then
                SQL = SQL & " and Exists (Select S.Branch from SysUserBranch S Where S.Branch=V.Branch and S.ID='" & dbUser & "' and S.AllowedF=1)"
                SQL = SQL & " and (coalesce(V.CT,'')='' or Exists (Select S.CT from FN_UserCT('" & dbUser & "',V.Branch,'') S Where S.CT=V.CT))"
            End If

            Dim rs As RemoteSet
            Dim C_MaxRecords As Long
            C_MaxRecords = toval(GetAppSetting("CareMaxRecords"))
            If toval(GetAppSetting("CareMaxRecords_FA")) > C_MaxRecords Then
                C_MaxRecords = toval(GetAppSetting("CareMaxRecords_FA"))
            End If
            rs = db.OpenRemoteSet(SQL, , , , C_MaxRecords)
            Dataset = rs.GetDataSet

            If Dataset Is Nothing Then Throw New Exception(ErrMsg)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function GetVoucherOCOD(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef findex As String(), ByRef fbuffer As String(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String

            Voucher = getInParamValue(InParam, 0)
            Dim rs As RemoteSet

            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='C' and Voucher='" & Voucher & "'")
            findex = rs.fields_index
            fbuffer = rs.GetRecord

            rs = db.OpenRemoteSet("Select Cast(0 as bit) as ProcessFlag, pSL.*, cast('' as varchar(10)) as Branch from pSL where pSL.Voucher='" & Voucher & "' Order By pSL.SortNo")
            Dataset = rs.GetDataSet

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SearchVoucherDNCN(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String = getInParamValue(InParam, 0)
            Dim VoucherDate As String = getInParamValue(InParam, 1)  ' Formatted Date MM/DD/YYYY
            Dim VType As String = getInParamValue(InParam, 2)
            Dim Branch As String = getInParamValue(InParam, 3)
            Dim ProAcc As String = getInParamValue(InParam, 4)
            Dim ComAcc As String = getInParamValue(InParam, 5)       ' Un-Used
            Dim Currency As String = getInParamValue(InParam, 6)
            Dim DocNo As String = getInParamValue(InParam, 7)
            Dim RefType As String = getInParamValue(InParam, 8)
            Dim RefNo As String = getInParamValue(InParam, 9)
            Dim RefDate As String = getInParamValue(InParam, 10)     ' Formatted Date MM/DD/YYYY
            Dim Remarks As String = getInParamValue(InParam, 11)
            Dim Last_Opr As String = getInParamValue(InParam, 12)
            Dim Status As String = getInParamValue(InParam, 13)      ' Not Approved / Approved / Posted

            Dim SQL As String
            SQL = "Select Cast(0 as bit) as ProcessFlag, V.Voucher, V.DebtorF, V.CreditorF, V.Branch, V.RefNo, V.DocNo, V.RefType, V.AccountNo, V.Date, V.Vtype, V.SL_Cat, V.Status, "
            SQL = SQL & " V.Remarks, V.ProAcc, P.Description as PDescription, V.ComAcc, C.Description as CDescription, V.Currency, V.Nominal_CC-V.Diff_CC as Nominal,"
            SQL = SQL & " V.Payment_OC+V.Payment_CC as Payment, coalesce(A1.Nominal_CC-V.Payment_OC-V.Payment_CC,0) as UnPayment"
            SQL = SQL & " from nVoucher V Inner Join fn_userVType('" & dbUser & "') VType on (VType.VType=V.VType) Left Join ProAcc P on (P.ProAcc=V.ProAcc) Left Join ComAcc C on (C.ComAcc=V.ComAcc) Left Join Open_Item_Voucher_N('') as a1 on (a1.Voucher=V.Voucher) "
            SQL = SQL & " Where V.SL_Cat='N'"
            If Voucher <> "" Then
                SQL = SQL & " and V.Voucher Like '" & Voucher & "%'"
            End If
            If VoucherDate <> "" Then
                SQL = SQL & " and V.Date='" & VoucherDate & "'"
            End If
            If VType <> "" Then
                SQL = SQL & " and V.VType Like '" & VType & "%'"
            End If
            If Branch <> "" Then
                SQL = SQL & " and V.Branch Like '" & Branch & "%'"
            End If
            If ProAcc <> "" Then
                SQL = SQL & " and V.ProAcc Like '" & ProAcc & "%'"
            End If
            If ComAcc <> "" Then
                SQL = SQL & " and V.ComAcc Like '" & ComAcc & "%'"
            End If
            If Currency <> "" Then
                SQL = SQL & " and V.Currency Like '" & Currency & "%'"
            End If
            If DocNo <> "" Then
                SQL = SQL & " and V.DocNo Like '" & DocNo & "%'"
            End If
            If RefType <> "" Then
                SQL = SQL & " and V.RefType Like '" & RefType & "%'"
            End If
            If RefNo <> "" Then
                SQL = SQL & " and V.RefNo Like '" & RefNo & "%'"
            End If
            If RefDate <> "" Then
                SQL = SQL & " and V.RefDate='" & RefDate & "'"
            End If
            If Remarks <> "" Then
                SQL = SQL & " and V.Remarks Like '" & Remarks & "%'"
            End If
            If Last_Opr <> "" Then
                SQL = SQL & " and V.Last_Opr Like '" & Last_Opr & "%'"
            End If
            Select Case Status
                Case "Not Approved"
                    SQL = SQL & " and V.Status='N'"
                Case "Approved"
                    SQL = SQL & " and V.Status='U'"
                Case "Posted"
                    SQL = SQL & " and V.Status='P'"
            End Select
            If db.GetUserType <> "SUPERVISOR" Then
                SQL = SQL & " and Exists (Select S.Branch from SysUserBranch S Where S.Branch=V.Branch and S.ID='" & dbUser & "' and S.AllowedF=1)"
                SQL = SQL & " and (coalesce(V.CT,'')='' or Exists (Select S.CT from FN_UserCT('" & dbUser & "',V.Branch,'') S Where S.CT=V.CT))"
            End If

            Dim rs As RemoteSet
            Dim C_MaxRecords As Long
            C_MaxRecords = toval(GetAppSetting("CareMaxRecords"))
            If toval(GetAppSetting("CareMaxRecords_FA")) > C_MaxRecords Then
                C_MaxRecords = toval(GetAppSetting("CareMaxRecords_FA"))
            End If
            rs = db.OpenRemoteSet(SQL, , , , C_MaxRecords)
            Dataset = rs.GetDataSet

            If Dataset Is Nothing Then Throw New Exception(ErrMsg)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function GetVoucherDNCN(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef findex As String(), ByRef fbuffer As String(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String

            Voucher = getInParamValue(InParam, 0)
            Dim rs As RemoteSet

            rs = db.OpenRemoteSet("Select * from nVoucher Where SL_Cat='N' and Voucher='" & Voucher & "'")
            findex = rs.fields_index
            fbuffer = rs.GetRecord

            rs = db.OpenRemoteSet("Select Cast(0 as bit) as ProcessFlag, nSL.* from nSL where nSL.Voucher='" & Voucher & "' Order By nSL.SortNo")
            Dataset = rs.GetDataSet

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function GetVoucherIR(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef findex As String(), ByRef fbuffer As String(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String

            Voucher = getInParamValue(InParam, 0)
            Dim rs As RemoteSet

            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='P' and DebtorF=1 and Voucher='" & Voucher & "'")
            findex = rs.fields_index
            fbuffer = rs.GetRecord

            rs = db.OpenRemoteSet("Select Cast(0 as bit) as ProcessFlag, pSL.*, coalesce(pVoucher.Branch,'') as Branch, coalesce(pVoucher.Branch,'') as oBranch, coalesce(pVoucher.ComAcc,'') as ComAcc, coalesce(pVoucher.ComAcc,'') as OComAcc from pSL Left Join pVoucher on (pVoucher.Voucher=pSL.Doc_No and pSL.PaymentF=1) where pSL.Voucher='" & Voucher & "' Order By pSL.SortNo")
            Dataset = rs.GetDataSet

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function GetVoucherIP(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef findex As String(), ByRef fbuffer As String(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String

            Voucher = getInParamValue(InParam, 0)
            Dim rs As RemoteSet

            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='P' and CreditorF=1 and Voucher='" & Voucher & "'")
            findex = rs.fields_index
            fbuffer = rs.GetRecord

            rs = db.OpenRemoteSet("Select Cast(0 as bit) as ProcessFlag, pSL.*, coalesce(pVoucher.Branch,'') as Branch, coalesce(pVoucher.Branch,'') as oBranch, coalesce(pVoucher.ComAcc,'') as ComAcc, coalesce(pVoucher.ComAcc,'') as OComAcc from pSL Left Join pVoucher on (pVoucher.Voucher=pSL.Doc_No and pSL.PaymentF=1) where pSL.Voucher='" & Voucher & "' Order By pSL.SortNo")
            Dataset = rs.GetDataSet

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function GetVoucherRA(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef findex As String(), ByRef fbuffer As String(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String

            Voucher = getInParamValue(InParam, 0)
            Dim rs As RemoteSet

            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='A' and CreditorF=1 and Voucher='" & Voucher & "'")
            findex = rs.fields_index
            fbuffer = rs.GetRecord

            rs = db.OpenRemoteSet("Select Cast(0 as bit) as ProcessFlag, pSL.*, cast('' as varchar(10)) as Branch, (Select Top 1 Admlink.ValueDesc from Admlink Where Admlink.Voucher=pSL.Doc_No and pSL.PaymentF=1) as Info, (Select Top 1 Admlink.A_PolicyNo from Admlink Where Admlink.Voucher=pSL.Doc_No and pSL.PaymentF=1) as A_PolicyNo, (Select Top 1 Admlink.DocNo from Admlink Where Admlink.Voucher=pSL.Doc_No and pSL.PaymentF=1) as A_DocNo from pSL where pSL.Voucher='" & Voucher & "' Order By pSL.SortNo")
            Dataset = rs.GetDataSet

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function GetVoucherPA(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef findex As String(), ByRef fbuffer As String(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String

            Voucher = getInParamValue(InParam, 0)
            Dim rs As RemoteSet

            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='A' and DebtorF=1 and Voucher='" & Voucher & "'")
            findex = rs.fields_index
            fbuffer = rs.GetRecord

            rs = db.OpenRemoteSet("Select Cast(0 as bit) as ProcessFlag, pSL.*, cast('' as varchar(10)) as Branch, (Select Top 1 Admlink.ValueDesc from Admlink Where Admlink.Voucher=pSL.Doc_No and pSL.PaymentF=1) as Info, (Select Top 1 Admlink.A_PolicyNo from Admlink Where Admlink.Voucher=pSL.Doc_No and pSL.PaymentF=1) as A_PolicyNo, (Select Top 1 Admlink.DocNo from Admlink Where Admlink.Voucher=pSL.Doc_No and pSL.PaymentF=1) as A_DocNo from pSL where pSL.Voucher='" & Voucher & "' Order By pSL.SortNo")
            Dataset = rs.GetDataSet

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function

    Private Function PreAddVoucherIRIP(ByVal InParam As Object(), ByVal ProAcc As String, ByVal ComAcc As String, ByVal Currency As String, ByRef Errmsg As String) As Boolean

        Dim rs As RemoteSet
        Dim br_End_Date As Date
        Dim br_Month As Integer
        Dim br_Year As Integer
        Dim FLockedDate As Date

        Dim Voucher As String
        Dim Branch As String
        Dim VoucherDate As Date

        Voucher = getInParamValue(InParam, 0)
        Branch = getInParamValue(InParam, 1)
        VoucherDate = getInParamValue(InParam, 2)

        On Error GoTo errmsg

        rs = db.OpenRemoteSet("Select * from Branch where branch='" & Branch & "'")
        If Not rs.Eof Then
            br_End_Date = todate(rs.fields("end_date"))
            br_Month = toval(rs.fields("Month"))
            br_Year = toval(rs.fields("year"))
        End If

        If Not db.GetPrivileges("ALLOWLOCKEDPERIOD") Then
            FLockedDate = GetFLockedDate(Branch)
            If DateDiff(DateInterval.Day, FLockedDate, VoucherDate) <= 0 Then
                Errmsg = "Transactions for this period have been closed, Check the Closing Date on " & FLockedDate
                GoTo errmsg
            End If
        End If

        If (DateDiff(DateInterval.Day, VoucherDate, br_End_Date) >= 0) Then
            Errmsg = "Backdated Transaction, Check the Ending Date on " & br_End_Date & " !"
            GoTo errmsg
        End If

        rs = db.OpenRemoteSet("Select ProAcc, Description, Currency, RestrictedF from ProAcc where ProAcc='" & ProAcc & "'")
        If rs.Eof Then
            Errmsg = "Not a Valid Profile Account-" & ProAcc
            Throw New Exception(Errmsg)
        End If

        If toval(rs.fields("RestrictedF")) Then
            Errmsg = "Not Allowed for Restricted Profile Account-" & ProAcc & "-" & rs.fields("Description")
            Throw New Exception(Errmsg)
        End If

        If rs.fields("Currency") <> Currency Then
            Errmsg = "Not a Valid Profile Account-" & ProAcc & " for Voucher Currency-'" & Currency
            Throw New Exception(Errmsg)
        End If

        rs = db.OpenRemoteSet("Select ComAcc, Description, Currency, RestrictedF From FN_UserComAcc ('" & dbUser & "', '" & Branch & "') Where ComAcc='" & ComAcc & "'")
        If rs.Eof Then
            Errmsg = "No Branch's Authorization for Company Account-" & ComAcc
            Throw New Exception(Errmsg)
        End If

        If toval(rs.fields("RestrictedF")) Then
            Errmsg = "Not Allowed for Restricted Company Account-" & ComAcc & "-" & rs.fields("Description")
            Throw New Exception(Errmsg)
        End If

        Return True
errmsg:
        Errmsg = StrError(Errmsg)
        Return False
    End Function
    Private Function PreEditVoucherIRIP(ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim rs As RemoteSet

        Dim Voucher As String
        Dim VoucherDate As Date

        Voucher = getInParamValue(InParam, 0)
        'Branch = getInParamValue(InParam, 1)
        VoucherDate = getInParamValue(InParam, 2)
        On Error GoTo errmsg

        rs = db.OpenRemoteSet("Select * from pVoucher Where Voucher='" & Voucher & "'")
        If rs.Eof Then
            ErrMsg = "No Voucher Data !"
            GoTo errmsg
        Else
            If rs.fields("DebtorF") Then
                If (Not db.GetPrivileges("ALLOWRECEIPT") Or Not db.GetPrivileges("ALLOWINTERBANK")) And rs.fields("Status") <> "N" Then
                    ErrMsg = "Receipt Voucher Already Processed !"
                    GoTo errmsg
                End If
            Else
                If (Not db.GetPrivileges("ALLOWPAYMENT") Or Not db.GetPrivileges("ALLOWINTERBANK")) And rs.fields("Status") <> "N" Then
                    ErrMsg = "Payment Voucher Already Processed !"
                    GoTo errmsg
                End If
            End If
        End If

        If Month(VoucherDate) + Year(VoucherDate) * 12 <> Month(rs.fields("Date")) + Year(rs.fields("Date")) * 12 Then
            If Not db.GetPrivileges("ALLOWCHANGEDATE") Then
                ErrMsg = "Not Allowed To Change Booking Date !"
                GoTo errmsg
            End If
        End If

        If rs.fields("BranchF") Then
            ErrMsg = "Branch Data Upload Constraint !"
            GoTo errmsg
        End If

        If Not rs.fields("BackDatedF") And rs.fields("Posting_Flag") = True Then
            ErrMsg = "Voucher Already Processed / Posted !"
            GoTo errmsg
        End If

        If rs.fields("RequestF") And UCase(rs.fields("RequestName")) <> UCase(dbUser) Then
            ErrMsg = "Document is being sent to User-'" & rs.fields("RequestName") & "' !"
            GoTo errmsg
        End If

        rs = db.OpenRemoteSet("Select Voucher from pVoucher where RefNo='" & Voucher & "'")
        If Not rs.Eof Then
            ErrMsg = "Document Constraint With Voucher.'" & tostr(rs.fields("Voucher")) & "' !"
            Exit Function
        End If

        rs = db.OpenRemoteSet("Select Voucher from pSL where Doc_No='" & Voucher & "' and PaymentF=1")
        If Not rs.Eof Then
            ErrMsg = "Document Constraint With Voucher.'" & tostr(rs.fields("Voucher")) & "' !"
            Exit Function
        End If

        Return True
errmsg:
        ErrMsg = StrError(ErrMsg)
        Return False
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function SaveVoucherIR(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal findex() As String, ByVal fbuffer() As String, ByVal Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Branch As String
            Dim VoucherDate As Date

            Voucher = getInParamValue(InParam, 0)
            Branch = getInParamValue(InParam, 1)
            VoucherDate = getInParamValue(InParam, 2)

            Dim LockedKey As String = ""
            If Voucher <> "" Then
                LockedKey = Voucher
                If Not db.GetLockedObject("Voucher" & LockedKey) Then Throw New Exception(db.ErrDesc)
            End If

            Dim rs As RemoteSet
            Dim br_Currency As String
            Dim br_Currency_1 As String
            Dim VType As String
            Dim ComAcc As String
            Dim AutoNum As String
            Dim CodeExt As String
            Dim Currency As String
            Dim Rate As Double
            Dim Rate_RC As Double
            Dim ProAcc As String
            Dim CT As String
            Dim Remarks As String
            Dim Status As String

            rs = db.OpenRemoteSet("Select Currency, Currency_1 from SysTab")
            br_Currency = rs.fields("Currency")
            br_Currency_1 = rs.fields("Currency_1")

            VType = GetFieldValue(fbuffer(GetFieldIndex("VType", findex)))
            ComAcc = GetFieldValue(fbuffer(GetFieldIndex("ComAcc", findex)))
            Currency = GetFieldValue(fbuffer(GetFieldIndex("Currency", findex)))
            Rate = exchange_rate(Currency, VoucherDate, br_Currency)
            Rate_RC = exchange_rate_RC(Currency, VoucherDate, br_Currency_1)
            ProAcc = GetFieldValue(fbuffer(GetFieldIndex("ProAcc", findex)))
            CT = GetFieldValue(fbuffer(GetFieldIndex("CT", findex)))
            Remarks = GetFieldValue(fbuffer(GetFieldIndex("Remarks", findex)))

            rs = db.OpenRemoteSet("select vType, SL_Cat, AutoNum, DebtorF, CreditorF, CodeExt from vType where SL_Cat='P' and DebtorF=1 and vtype = '" & VType & "'")
            AutoNum = tostr(rs.fields("AutoNum"))
            CodeExt = tostr(rs.fields("CodeExt"))

            Dim rsV As RemoteSet
            Dim EditMode As Integer
            rsV = db.OpenRemoteSet("Select * from pVoucher Where Voucher='" & Voucher & "'")
            If rsV.Eof Then
                If Not PreAddVoucherIRIP(InParam, ProAcc, ComAcc, Currency, ErrMsg) Then Throw New Exception(ErrMsg)

                Dim DocID As String
                rs = db.OpenRemoteSet("Select * from ComAcc Where ComAcc='" & ComAcc & "'")
                DocID = tostr(rs.fields("DocID"))
                If Voucher = "" Then
                    Voucher = db.GetNextDocNo(AutoNum, VoucherDate, DocID & Branch)
                End If
                If Voucher = "" Then Throw New Exception("Generate Voucher Number Failed !")

                rsV.AddNew()
            Else
                If Not PreAddVoucherIRIP(InParam, ProAcc, ComAcc, Currency, ErrMsg) Then Throw New Exception(ErrMsg)
                If Not PreEditVoucherIRIP(InParam, ErrMsg) Then Throw New Exception(ErrMsg)

                rsV.Edit()
            End If
            EditMode = rsV.editmode

            Dim i As Integer
            Dim j As Integer
            i = 0
            j = UBound(findex)
            Do While i < j
                rsV.fields(findex(i)) = GetFieldValue(fbuffer(i))
                i = i + 1
            Loop
            If Not db.GetPrivileges("ALLOWPASSSCANPAN") Then
                If isContainRestrictedPAN(rsV.fields("AccountNo")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field AccountNo!")
                End If
                If isContainRestrictedPAN(rsV.fields("REFNO")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field REFNO!")
                End If
                If isContainRestrictedPAN(rsV.fields("REMARKS")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field REMARKS!")
                End If
            End If
            If EditMode = AdEditAdd Then
                rsV.fields("Branch") = Branch
                rsV.fields("CDate") = Today.Date
                rsV.fields("CTime") = Time()
                rsV.fields("UserID") = dbUser
                rsV.fields("Voucher") = Voucher
            End If
            rsV.fields("Date") = VoucherDate
            rsV.fields("Rate") = Rate
            rsV.fields("Rate_RC") = Rate_RC
            rsV.fields("ReceiptF") = True
            rsV.fields("PaymentF") = False
            rsV.fields("CreditorF") = False
            rsV.fields("DebtorF") = True
            rsV.fields("SL_Flag") = True
            rsV.fields("SL_Cat") = "P"
            rsV.fields("Num_Doc") = 0
            rsV.fields("SL_Tag") = 1
            rsV.fields("PDate") = VoucherDate
            rsV.fields("Last_Date") = Today.Date
            rsV.fields("Last_Time") = Time()
            rsV.fields("Last_Opr") = dbUser
            rsV.fields("BackDatedF") = False
            rsV.fields("Posting_Flag") = False
            If Not rsV.Update Then Throw New Exception(db.ErrDesc)

            Const MaxCols = 16
            Dim Bufferdata(Dataset.Tables(0).Rows.Count - 1, MaxCols - 1) As Object
            For i = 0 To Dataset.Tables(0).Rows.Count - 1
                Bufferdata(i, 0) = tostr(Dataset.Tables(0).Rows(i)("Doc_No"))
                Bufferdata(i, 1) = todate(Dataset.Tables(0).Rows(i)("Doc_Date"))
                Bufferdata(i, 2) = tostr(Dataset.Tables(0).Rows(i)("Doc_CCY"))
                Bufferdata(i, 3) = RoundCCY(toval(Dataset.Tables(0).Rows(i)("Nominal_OC")), UCase(tostr(Dataset.Tables(0).Rows(i)("Doc_CCY"))), toval(GetAppSetting("FARoundingDecimalValue")))
                Bufferdata(i, 4) = toval(Dataset.Tables(0).Rows(i)("Nominator")) / toval(Dataset.Tables(0).Rows(i)("Denominator"))
                Bufferdata(i, 5) = RoundCCY(toval(Dataset.Tables(0).Rows(i)("Nominal")), UCase(Currency), toval(GetAppSetting("FARoundingDecimalValue")))
                Bufferdata(i, 6) = tostr(Dataset.Tables(0).Rows(i)("Remarks"))
                Bufferdata(i, 7) = toval(Dataset.Tables(0).Rows(i)("Hint"))
                Bufferdata(i, 8) = IIf(toval(Dataset.Tables(0).Rows(i)("PaymentF")) = 0, False, True)
                Bufferdata(i, 9) = tostr(Dataset.Tables(0).Rows(i)("ComAcc"))
                Bufferdata(i, 10) = tostr(Dataset.Tables(0).Rows(i)("Account"))
                Bufferdata(i, 11) = toval(Dataset.Tables(0).Rows(i)("Nominator"))
                Bufferdata(i, 12) = toval(Dataset.Tables(0).Rows(i)("Denominator"))
                Bufferdata(i, 13) = tostr(Dataset.Tables(0).Rows(i)("OComAcc"))
                Bufferdata(i, 14) = tostr(Dataset.Tables(0).Rows(i)("Branch"))
                Bufferdata(i, 15) = tostr(Dataset.Tables(0).Rows(i)("OBranch"))
            Next

            Dim Param(9) As Object
            Param(0) = Voucher
            Param(1) = VoucherDate
            Param(2) = VType
            Param(3) = Currency
            Param(4) = Branch
            Param(5) = Rate
            Param(6) = ProAcc
            Param(7) = CodeExt
            Param(8) = CT
            Param(9) = ComAcc

            Dim OParam As Object = Nothing

            Const MaxRows_2 = 100
            Const MaxCols_2 = 2
            Dim bufferdata_2(MaxRows_2 - 1, MaxCols_2 - 1) As Object

            OParam = Me.Direct_Call_Process_Execute("ProcessFAExt.NetV3.Proclib", "SAVE_DETAIL_IR", Param, TrimBuffer(Bufferdata, 10), TrimBuffer(bufferdata_2))
            If TypeName(OParam) <> "Object()" Then Throw New Exception(Me.ErrDesc)

            ' see fields to buffer for converting date field

            ' Refreshing Data
            rsV.Edit()
            rsV.fields("Num_Doc") = toval(OParam(0))
            rsV.fields("Payment_CC") = toval(OParam(1))
            rsV.fields("nPayment") = toval(OParam(2))
            rsV.fields("Nominal_CC") = toval(OParam(3))
            rsV.fields("Diff_CC") = toval(OParam(4))
            rsV.fields("Nominal") = toval(OParam(3)) * Rate
            rsV.fields("Diff") = toval(OParam(4)) * Rate

            Dim TotalAmount As Double
            TotalAmount = rsV.fields("Nominal") - rsV.fields("Diff")
            If Not GetApprovalLimitFA(dbUser, VType, "In", TotalAmount) Or (TotalAmount = 0 And Not db.GetPrivileges("ALLOWZEROPAYMENT")) Or (TotalAmount <> 0 And Not db.GetPrivileges("ALLOWNONZEROPAYMENT")) Or Not db.GetPrivileges("ALLOWRECEIPT") Or Not db.GetPrivileges("ALLOWINTERBANK") Then
                Status = "N"    ' Not Approved
            Else
                Status = "U"    ' Ok Approved, Un-Posting
            End If
            rsV.fields("Status") = Status
            If Status = "U" Then
                rsV.fields("AUserID") = dbUser
                rsV.fields("AUserDate") = Today.Date
                rsV.fields("AUserID_Ext") = dbUser
                rsV.fields("AUserDate_Ext") = Today.Date
            End If
            If Not rsV.Update Then Throw New Exception(db.ErrDesc)

            ' Set Output Parameter
            ReDim OutParam(7)
            OutParam(0) = Voucher
            OutParam(1) = toval(OParam(0))          ' Num_Doc
            OutParam(2) = toval(OParam(1))          ' Payment_CC
            OutParam(3) = toval(OParam(2))          ' nPayment
            OutParam(4) = toval(OParam(3))          ' Nominal_CC
            OutParam(5) = toval(OParam(4))          ' Diff_CC
            OutParam(6) = toval(OParam(3)) * Rate   ' Nominal
            OutParam(7) = toval(OParam(4)) * Rate   ' Diff

            If LockedKey <> "" Then If Not db.ReleaseLockedObject("Voucher" & LockedKey) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ' Set Output Parameter
            ReDim OutParam(0)
            OutParam(0) = Voucher

            ErrMsg = ex.Message
            FANotes(Voucher, "Receipt Inter-Bank", "Save : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SaveVoucherIP(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal findex() As String, ByVal fbuffer() As String, ByVal Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Branch As String
            Dim VoucherDate As Date
            Dim Reference As String
            Dim RefNo As String

            Voucher = getInParamValue(InParam, 0)
            Branch = getInParamValue(InParam, 1)
            VoucherDate = getInParamValue(InParam, 2)
            Reference = getInParamValue(InParam, 3)
            RefNo = getInParamValue(InParam, 4)

            Dim LockedKey As String = ""
            If Voucher <> "" Then
                LockedKey = Voucher
                If Not db.GetLockedObject("Voucher" & LockedKey) Then Throw New Exception(db.ErrDesc)
            End If

            Dim rs As RemoteSet
            Dim br_Currency As String
            Dim br_Currency_1 As String
            Dim VType As String
            Dim ComAcc As String
            Dim AutoNum As String
            Dim CodeExt As String
            Dim Currency As String
            Dim Rate As Double
            Dim Rate_RC As Double
            Dim ProAcc As String
            Dim CT As String
            Dim Remarks As String
            Dim Status As String
            Dim CheckCBBalanceF As Boolean

            rs = db.OpenRemoteSet("Select Currency, Currency_1, CheckCBBalanceF from SysTab")
            br_Currency = rs.fields("Currency")
            br_Currency_1 = rs.fields("Currency_1")
            CheckCBBalanceF = rs.fields("CheckCBBalanceF")

            VType = GetFieldValue(fbuffer(GetFieldIndex("VType", findex)))
            ComAcc = GetFieldValue(fbuffer(GetFieldIndex("ComAcc", findex)))
            Currency = GetFieldValue(fbuffer(GetFieldIndex("Currency", findex)))
            Rate = exchange_rate(Currency, VoucherDate, br_Currency)
            Rate_RC = exchange_rate_RC(Currency, VoucherDate, br_Currency_1)
            ProAcc = GetFieldValue(fbuffer(GetFieldIndex("ProAcc", findex)))
            CT = GetFieldValue(fbuffer(GetFieldIndex("CT", findex)))
            Remarks = GetFieldValue(fbuffer(GetFieldIndex("Remarks", findex)))

            rs = db.OpenRemoteSet("select vType, SL_Cat, AutoNum, DebtorF, CreditorF, CodeExt from vType where SL_Cat='P' and CreditorF=1 and vtype = '" & VType & "'")
            AutoNum = tostr(rs.fields("AutoNum"))
            CodeExt = tostr(rs.fields("CodeExt"))

            Dim rsV As RemoteSet
            Dim EditMode As Integer
            rsV = db.OpenRemoteSet("Select * from pVoucher Where Voucher='" & Voucher & "'")
            If rsV.Eof Then
                If Not PreAddVoucherIRIP(InParam, ProAcc, ComAcc, Currency, ErrMsg) Then Throw New Exception(ErrMsg)

                Dim DocID As String
                rs = db.OpenRemoteSet("Select * from ComAcc Where ComAcc='" & ComAcc & "'")
                DocID = tostr(rs.fields("DocID"))
                If Voucher = "" Then
                    Voucher = db.GetNextDocNo(AutoNum, VoucherDate, DocID & Branch)
                End If
                If Voucher = "" Then Throw New Exception("Generate Voucher Number Failed !")

                rsV.AddNew()
            Else
                If Not PreAddVoucherIRIP(InParam, ProAcc, ComAcc, Currency, ErrMsg) Then Throw New Exception(ErrMsg)
                If Not PreEditVoucherIRIP(InParam, ErrMsg) Then Throw New Exception(ErrMsg)

                rsV.Edit()
            End If
            EditMode = rsV.editmode

            Dim i As Integer
            Dim j As Integer
            i = 0
            j = UBound(findex)
            Do While i < j
                rsV.fields(findex(i)) = GetFieldValue(fbuffer(i))
                i = i + 1
            Loop
            If Not db.GetPrivileges("ALLOWPASSSCANPAN") Then
                If isContainRestrictedPAN(rsV.fields("AccountNo")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field AccountNo!")
                End If
                If isContainRestrictedPAN(rsV.fields("REFNO")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field REFNO!")
                End If
                If isContainRestrictedPAN(rsV.fields("REMARKS")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field REMARKS!")
                End If
            End If
            If EditMode = AdEditAdd Then
                rsV.fields("Branch") = Branch
                rsV.fields("CDate") = Today.Date
                rsV.fields("CTime") = Time()
                rsV.fields("UserID") = dbUser
                rsV.fields("Voucher") = Voucher
            End If
            rsV.fields("Date") = VoucherDate
            rsV.fields("Rate") = Rate
            rsV.fields("Rate_RC") = Rate_RC
            rsV.fields("ReceiptF") = False
            rsV.fields("PaymentF") = True
            rsV.fields("CreditorF") = True
            rsV.fields("DebtorF") = False
            rsV.fields("SL_Flag") = True
            rsV.fields("SL_Cat") = "P"
            rsV.fields("Num_Doc") = 0
            rsV.fields("SL_Tag") = 1
            rsV.fields("PDate") = VoucherDate
            rsV.fields("Last_Date") = Today.Date
            rsV.fields("Last_Time") = Time()
            rsV.fields("Last_Opr") = dbUser
            rsV.fields("BackDatedF") = False
            rsV.fields("Posting_Flag") = False
            If Not rsV.Update Then Throw New Exception(db.ErrDesc)

            Const MaxCols = 16
            Dim Bufferdata(Dataset.Tables(0).Rows.Count - 1, MaxCols - 1) As Object
            For i = 0 To Dataset.Tables(0).Rows.Count - 1
                Bufferdata(i, 0) = tostr(Dataset.Tables(0).Rows(i)("Doc_No"))
                Bufferdata(i, 1) = todate(Dataset.Tables(0).Rows(i)("Doc_Date"))
                Bufferdata(i, 2) = tostr(Dataset.Tables(0).Rows(i)("Doc_CCY"))
                Bufferdata(i, 3) = RoundCCY(toval(Dataset.Tables(0).Rows(i)("Nominal_OC")), UCase(tostr(Dataset.Tables(0).Rows(i)("Doc_CCY"))), toval(GetAppSetting("FARoundingDecimalValue")))
                Bufferdata(i, 4) = toval(Dataset.Tables(0).Rows(i)("Nominator")) / toval(Dataset.Tables(0).Rows(i)("Denominator"))
                Bufferdata(i, 5) = RoundCCY(toval(Dataset.Tables(0).Rows(i)("Nominal")), UCase(Currency), toval(GetAppSetting("FARoundingDecimalValue")))
                Bufferdata(i, 6) = tostr(Dataset.Tables(0).Rows(i)("Remarks"))
                Bufferdata(i, 7) = toval(Dataset.Tables(0).Rows(i)("Hint"))
                Bufferdata(i, 8) = IIf(toval(Dataset.Tables(0).Rows(i)("PaymentF")) = 0, False, True)
                Bufferdata(i, 9) = tostr(Dataset.Tables(0).Rows(i)("ComAcc"))
                Bufferdata(i, 10) = tostr(Dataset.Tables(0).Rows(i)("Account"))
                Bufferdata(i, 11) = toval(Dataset.Tables(0).Rows(i)("Nominator"))
                Bufferdata(i, 12) = toval(Dataset.Tables(0).Rows(i)("Denominator"))
                Bufferdata(i, 13) = tostr(Dataset.Tables(0).Rows(i)("OComAcc"))
                Bufferdata(i, 14) = tostr(Dataset.Tables(0).Rows(i)("Branch"))
                Bufferdata(i, 15) = tostr(Dataset.Tables(0).Rows(i)("OBranch"))
            Next

            Dim Param(9) As Object
            Param(0) = Voucher
            Param(1) = VoucherDate
            Param(2) = VType
            Param(3) = Currency
            Param(4) = Branch
            Param(5) = Rate
            Param(6) = ProAcc
            Param(7) = CodeExt
            Param(8) = CT
            Param(9) = ComAcc

            Dim OParam As Object = Nothing

            Const MaxRows_2 = 100
            Const MaxCols_2 = 2
            Dim bufferdata_2(MaxRows_2 - 1, MaxCols_2 - 1) As Object

            OParam = Me.Direct_Call_Process_Execute("ProcessFAExt.NetV3.Proclib", "SAVE_DETAIL_IP", Param, TrimBuffer(Bufferdata, 10), TrimBuffer(bufferdata_2))
            If TypeName(OParam) <> "Object()" Then Throw New Exception(Me.ErrDesc)

            ' see fields to buffer for converting date field

            ' Refreshing Data
            rsV.Edit()
            rsV.fields("Num_Doc") = toval(OParam(0))
            rsV.fields("Payment_CC") = toval(OParam(1))
            rsV.fields("nPayment") = toval(OParam(2))
            rsV.fields("Nominal_CC") = toval(OParam(3))
            rsV.fields("Diff_CC") = toval(OParam(4))
            rsV.fields("Nominal") = toval(OParam(3)) * Rate
            rsV.fields("Diff") = toval(OParam(4)) * Rate

            Dim TotalAmount As Double
            TotalAmount = rsV.fields("Nominal") - rsV.fields("Diff")
            If Not GetApprovalLimitFA(dbUser, VType, "Out", TotalAmount) Or (TotalAmount = 0 And Not db.GetPrivileges("ALLOWZEROPAYMENT")) Or (TotalAmount <> 0 And Not db.GetPrivileges("ALLOWNONZEROPAYMENT")) Or Not db.GetPrivileges("ALLOWPAYMENT") Or Not db.GetPrivileges("ALLOWINTERBANK") Then
                Status = "N"    ' Not Approved
            Else
                Status = "U"    ' Ok Approved, Un-Posting
            End If
            rsV.fields("Status") = Status
            If Status = "U" Then
                rsV.fields("AUserID") = dbUser
                rsV.fields("AUserDate") = Today.Date
                rsV.fields("AUserID_Ext") = dbUser
                rsV.fields("AUserDate_Ext") = Today.Date
            End If
            If Not rsV.Update Then Throw New Exception(db.ErrDesc)

            ' Update References
            Select Case Reference
                Case "REQUEST"
                    If Not db.Execute("Update Request Set Voucher='" & Voucher & "' from Request Where Request='" & RefNo & "' and Status<>'C' and (Voucher='' or Voucher='" & Voucher & "')") Then Throw New Exception(db.ErrDesc)
                    If db.RecordsAffected = 0 Then Throw New Exception("No Request Document Updated !")
                Case "LISTREQUEST"
                    If Not db.Execute("Update Request Set Voucher='" & Voucher & "' from Request Where Request in " & RefNo & " and Status<>'C' and (Voucher='' or Voucher='" & Voucher & "')") Then Throw New Exception(db.ErrDesc)
                    If db.RecordsAffected = 0 Then Throw New Exception("No Request Document Updated !")
            End Select

            If EditMode = AdEditAdd AndAlso (Reference = "REQUEST" Or Reference = "LISTREQUEST") Then
                rs = db.OpenRemoteSet("Select R2.ImageID, R2.FileType, R2.Title, R2.Remark, R2.Last_Opr, R2.Last_Update from Request R1, RequestPIC R2 Where R2.Request=R1.Request and R1.Voucher='" & Voucher & "'")
                If Not rs.Eof Then
                    Dim ws As New localhost6.WSCommon(GetAppSetting("CareWSImage"))
                    ws.Timeout = System.Threading.Timeout.Infinite

                    Dim rsPic As RemoteSet
                    rsPic = db.OpenRemoteSet("Select * from VoucherPIC Where 1<>1")
                    Do While Not rs.Eof

                        Dim DataBuffer() As Byte = Nothing
                        Dim ImageID As Long = rs.fields("ImageID")
                        Dim NewImageID As Long = 0

                        'Dim ParamI(1) As Object
                        'Dim ParamO As Object = Nothing

                        'ParamI(0) = ImageID
                        'If Not ws.GetPictureBinary(dbUser, dbPassword, ParamI, ParamO, ErrMsg) Then Throw New Exception(ErrMsg)
                        'DataBuffer = ParamO(0)

                        'ParamI(0) = NewImageID
                        'ParamI(1) = DataBuffer
                        'If Not ws.SaveDocument(dbUser, dbPassword, ParamI, ParamO, ErrMsg) Then Throw New Exception(ErrMsg)
                        'NewImageID = ParamO(0)

                        rsPic.AddNew()
                        rsPic.fields("Voucher") = Voucher
                        rsPic.fields("ImageID") = ImageID
                        rsPic.fields("FileType") = rs.fields("FileType")
                        rsPic.fields("Title") = rs.fields("Title")
                        rsPic.fields("Remark") = rs.fields("Remark")
                        rsPic.fields("Last_Opr") = dbUser
                        rsPic.fields("Last_Update") = Today.Date
                        If Not rsPic.UpdateRow Then Throw New Exception(db.ErrDesc)
                        rs.MoveNext()
                    Loop
                    If Not rsPic.Eof Then
                        If Not rsPic.Update Then Throw New Exception(db.ErrDesc)
                    End If
                End If
            End If

            If rsV.fields("Status") = "U" Then
                If CheckCBBalanceF Then
                    If Not Check_Voucher_Company_Account(Voucher) Then Throw New Exception("Check Company Account Failed !" & StrMsg)
                End If
            End If

            ' Set Output Parameter
            ReDim OutParam(7)
            OutParam(0) = Voucher
            OutParam(1) = toval(OParam(0))          ' Num_Doc
            OutParam(2) = toval(OParam(1))          ' Payment_CC
            OutParam(3) = toval(OParam(2))          ' nPayment
            OutParam(4) = toval(OParam(3))          ' Nominal_CC
            OutParam(5) = toval(OParam(4))          ' Diff_CC
            OutParam(6) = toval(OParam(3)) * Rate   ' Nominal
            OutParam(7) = toval(OParam(4)) * Rate   ' Diff

            If LockedKey <> "" Then If Not db.ReleaseLockedObject("Voucher" & LockedKey) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ' Set Output Parameter
            ReDim OutParam(0)
            OutParam(0) = Voucher

            ErrMsg = ex.Message
            FANotes(Voucher, "Payment Inter-Bank", "Save : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function

    Private Function PreAddVoucherRAPA(ByVal InParam As Object(), ByRef Errmsg As String) As Boolean

        Dim rs As RemoteSet
        Dim br_End_Date As Date
        Dim br_Month As Integer
        Dim br_Year As Integer
        Dim FLockedDate As Date

        Dim Voucher As String
        Dim Branch As String
        Dim VoucherDate As Date


        Voucher = getInParamValue(InParam, 0)
        Branch = getInParamValue(InParam, 1)
        VoucherDate = getInParamValue(InParam, 2)

        On Error GoTo errmsg

        rs = db.OpenRemoteSet("Select * from Branch where branch='" & Branch & "'")
        If Not rs.Eof Then
            br_End_Date = todate(rs.fields("end_date"))
            br_Month = toval(rs.fields("Month"))
            br_Year = toval(rs.fields("year"))
        End If

        If Not db.GetPrivileges("ALLOWLOCKEDPERIOD") Then
            FLockedDate = GetFLockedDate(Branch)
            If DateDiff(DateInterval.Day, FLockedDate, VoucherDate) <= 0 Then
                Errmsg = "Transactions for this period have been closed, Check the Closing Date on " & FLockedDate
                GoTo errmsg
            End If
        End If

        If (DateDiff(DateInterval.Day, VoucherDate, br_End_Date) >= 0) Then
            Errmsg = "Backdated Transaction, Check the Ending Date on " & br_End_Date & " !"
            GoTo errmsg
        End If
        Return True
errmsg:
        Errmsg = StrError(Errmsg)
        Return False
    End Function
    Private Function PreEditVoucherRAPA(ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim rs As RemoteSet

        Dim Voucher As String
        Dim VoucherDate As Date

        Voucher = getInParamValue(InParam, 0)
        'Branch = getInParamValue(InParam, 1)
        VoucherDate = getInParamValue(InParam, 2)
        On Error GoTo errmsg

        rs = db.OpenRemoteSet("Select * from pVoucher Where Voucher='" & Voucher & "'")
        If rs.Eof Then
            ErrMsg = "No Voucher Data !"
            GoTo errmsg
        End If

        If Month(VoucherDate) + Year(VoucherDate) * 12 <> Month(rs.fields("Date")) + Year(rs.fields("Date")) * 12 Then
            If Not db.GetPrivileges("ALLOWCHANGEDATE") Then
                ErrMsg = "Not Allowed To Change Booking Date !"
                GoTo errmsg
            End If
        End If

        If rs.fields("BranchF") Then
            ErrMsg = "Branch Data Upload Constraint !"
            GoTo errmsg
        End If

        If Not rs.fields("BackDatedF") And rs.fields("Posting_Flag") = True Then
            ErrMsg = "Voucher Already Processed / Posted !"
            GoTo errmsg
        End If

        If rs.fields("RequestF") And UCase(rs.fields("RequestName")) <> UCase(dbUser) Then
            ErrMsg = "Document is being sent to User-'" & rs.fields("RequestName") & "' !"
            GoTo errmsg
        End If

        rs = db.OpenRemoteSet("Select Top 1 nSL.Voucher from nVoucher, nSL where nVoucher.DocNo='' and nSL.Voucher=nVoucher.Voucher and nSL.pVoucher='" & Voucher & "'", adOpenForwardonly)
        If Not rs.Eof Then
            ErrMsg = "Document Constraint With WithHolding Voucher. '" & tostr(rs.fields("Voucher")) & "' !"
            GoTo errmsg
        End If

        Return True
errmsg:
        ErrMsg = StrError(ErrMsg)
        Return False
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function SaveVoucherRA(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal findex() As String, ByVal fbuffer() As String, ByVal Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Branch As String
            Dim VoucherDate As Date
            Dim RefNo As String

            Voucher = getInParamValue(InParam, 0)
            Branch = getInParamValue(InParam, 1)
            VoucherDate = getInParamValue(InParam, 2)
            RefNo = getInParamValue(InParam, 3)

            Dim LockedKey As String = ""
            If Voucher <> "" Then
                LockedKey = Voucher
                If Not db.GetLockedObject("Voucher" & LockedKey) Then Throw New Exception(db.ErrDesc)
            End If
            If Dataset.Tables(0).Rows.Count > 0 Then
                If Not db.GetLockedObject("Voucher" & Left(tostr(Dataset.Tables(0).Rows(0)("Doc_No")), 20)) Then Throw New Exception(db.ErrDesc)
            End If

            Dim rs As RemoteSet
            Dim br_Currency As String
            Dim br_Currency_1 As String
            Dim VType As String
            Dim ComAcc As String
            Dim AutoNum As String
            Dim CodeExt As String
            Dim Currency As String
            Dim Rate As Double
            Dim Rate_RC As Double
            Dim ProAcc As String
            Dim CT As String
            Dim Remarks As String
            Dim Status As String


            rs = db.OpenRemoteSet("Select Currency, Currency_1 from SysTab")
            br_Currency = rs.fields("Currency")
            br_Currency_1 = rs.fields("Currency_1")

            VType = GetFieldValue(fbuffer(GetFieldIndex("VType", findex)))
            ComAcc = GetFieldValue(fbuffer(GetFieldIndex("ComAcc", findex)))
            Currency = GetFieldValue(fbuffer(GetFieldIndex("Currency", findex)))

            If CBool(toval(GetAppSetting("UseBookingRateWhenMatchingF"))) Then
                rs = db.OpenRemoteSet("Select Rate, Rate_RC from pVoucher Voucher Where Voucher='" & RefNo & "'")
                Rate = toval(rs.fields("Rate"))
                Rate_RC = toval(rs.fields("Rate_RC"))
            Else
                Rate = exchange_rate(Currency, VoucherDate, br_Currency)
                Rate_RC = exchange_rate_RC(Currency, VoucherDate, br_Currency_1)
            End If

            ProAcc = GetFieldValue(fbuffer(GetFieldIndex("ProAcc", findex)))
            CT = GetFieldValue(fbuffer(GetFieldIndex("CT", findex)))
            Remarks = GetFieldValue(fbuffer(GetFieldIndex("Remarks", findex)))

            rs = db.OpenRemoteSet("select vType, SL_Cat, AutoNum, DebtorF, CreditorF, CodeExt from vType where SL_Cat='A' and CreditorF=1 and vtype = '" & VType & "'")
            AutoNum = tostr(rs.fields("AutoNum"))
            CodeExt = tostr(rs.fields("CodeExt"))

            Dim rsV As RemoteSet
            Dim EditMode As Integer
            rsV = db.OpenRemoteSet("Select * from pVoucher Where Voucher='" & Voucher & "'")
            If rsV.Eof Then
                If Not PreAddVoucherRAPA(InParam, ErrMsg) Then Throw New Exception(ErrMsg)

                If Voucher = "" Then
                    Voucher = db.GetNextDocNo(AutoNum, VoucherDate, Branch)
                End If
                If Voucher = "" Then Throw New Exception("Generate Voucher Number Failed !")

                rsV.AddNew()
            Else
                If Not PreAddVoucherRAPA(InParam, ErrMsg) Then Throw New Exception(ErrMsg)
                If Not PreEditVoucherRAPA(InParam, ErrMsg) Then Throw New Exception(ErrMsg)

                rsV.Edit()
            End If
            EditMode = rsV.editmode

            Dim i As Integer
            Dim j As Integer
            i = 0
            j = UBound(findex)
            Do While i < j
                rsV.fields(findex(i)) = GetFieldValue(fbuffer(i))
                i = i + 1
            Loop
            If Not db.GetPrivileges("ALLOWPASSSCANPAN") Then
                If isContainRestrictedPAN(rsV.fields("AccountNo")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field AccountNo!")
                End If
                If isContainRestrictedPAN(rsV.fields("REFNO")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field REFNO!")
                End If
                If isContainRestrictedPAN(rsV.fields("REMARKS")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field REMARKS!")
                End If
            End If
            If EditMode = AdEditAdd Then
                rsV.fields("Branch") = Branch
                rsV.fields("CDate") = Today.Date
                rsV.fields("CTime") = Time()
                rsV.fields("UserID") = dbUser
                rsV.fields("Voucher") = Voucher
            End If
            rsV.fields("Date") = VoucherDate
            rsV.fields("Rate") = Rate
            rsV.fields("Rate_RC") = Rate_RC
            rsV.fields("CreditorF") = True
            rsV.fields("DebtorF") = False
            rsV.fields("SL_Flag") = True
            rsV.fields("SL_Cat") = "A"
            rsV.fields("Num_Doc") = 0
            rsV.fields("SL_Tag") = 1
            rsV.fields("PDate") = VoucherDate
            rsV.fields("Last_Date") = Today.Date
            rsV.fields("Last_Time") = Time()
            rsV.fields("Last_Opr") = dbUser
            rsV.fields("BackDatedF") = False
            rsV.fields("Posting_Flag") = False
            If Not rsV.Update Then Throw New Exception(db.ErrDesc)

            Dim TaxDeductionF As Boolean = False
            Const MaxCols = 16
            Dim Bufferdata(Dataset.Tables(0).Rows.Count - 1, MaxCols - 1) As Object
            For i = 0 To Dataset.Tables(0).Rows.Count - 1
                Bufferdata(i, 0) = tostr(Dataset.Tables(0).Rows(i)("Doc_No"))
                Bufferdata(i, 1) = todate(Dataset.Tables(0).Rows(i)("Doc_Date"))
                Bufferdata(i, 2) = tostr(Dataset.Tables(0).Rows(i)("Doc_CCY"))
                Bufferdata(i, 3) = RoundCCY(toval(Dataset.Tables(0).Rows(i)("Nominal_OC")), UCase(tostr(Dataset.Tables(0).Rows(i)("Doc_CCY"))), toval(GetAppSetting("FARoundingDecimalValue")))
                Bufferdata(i, 4) = tostr(Dataset.Tables(0).Rows(i)("CT"))
                Bufferdata(i, 5) = RoundCCY(toval(Dataset.Tables(0).Rows(i)("Nominal")), UCase(Currency), toval(GetAppSetting("FARoundingDecimalValue")))
                Bufferdata(i, 6) = tostr(Dataset.Tables(0).Rows(i)("Remarks"))
                Bufferdata(i, 7) = toval(Dataset.Tables(0).Rows(i)("Hint"))
                If toval(Dataset.Tables(0).Rows(i)("Hint")) = -14 Then
                    TaxDeductionF = True
                End If
                Bufferdata(i, 8) = IIf(toval(Dataset.Tables(0).Rows(i)("PaymentF")) = 0, False, True)
                Bufferdata(i, 9) = tostr(Dataset.Tables(0).Rows(i)("Account"))
                Bufferdata(i, 10) = toval(Dataset.Tables(0).Rows(i)("Nominator"))
                Bufferdata(i, 11) = toval(Dataset.Tables(0).Rows(i)("Denominator"))
                Bufferdata(i, 14) = toval(Dataset.Tables(0).Rows(i)("LockedF"))
                Bufferdata(i, 15) = toval(Dataset.Tables(0).Rows(i)("FundingF"))
            Next

            Dim Param(5) As Object
            Param(0) = Voucher
            Param(1) = VoucherDate
            Param(2) = VType
            Param(3) = Currency
            Param(4) = RefNo
            Param(5) = Branch

            Dim OParam As Object = Nothing

            Const MaxRows_2 = 100
            Const MaxCols_2 = 2
            Dim bufferdata_2(MaxRows_2 - 1, MaxCols_2 - 1) As Object

            OParam = Me.Direct_Call_Process_Execute("ProcessFAExt.NetV3.Proclib", "SAVE_DETAIL_RA", Param, TrimBuffer(Bufferdata), TrimBuffer(bufferdata_2))
            If TypeName(OParam) <> "Object()" Then Throw New Exception(Me.ErrDesc)

            ' see fields to buffer for converting date field

            ' Refreshing Data
            rsV.Edit()
            rsV.fields("Num_Doc") = toval(OParam(0))
            rsV.fields("Payment_CC") = toval(OParam(1))
            rsV.fields("nPayment") = toval(OParam(2))
            rsV.fields("Nominal_CC") = toval(OParam(3))
            rsV.fields("Diff_CC") = toval(OParam(4))
            rsV.fields("Nominal") = toval(OParam(3)) * Rate
            rsV.fields("Diff") = toval(OParam(4)) * Rate

            Dim TotalAmount As Double
            TotalAmount = rsV.fields("Nominal") - rsV.fields("Diff")
            If Not GetApprovalLimitFA(dbUser, VType, "In", TotalAmount) Or Not db.GetPrivileges("ALLOWADJUSTMENT") Then
                Status = "N"    ' Not Approved
            Else
                Status = "U"    ' Ok Approved, Un-Posting
            End If
            rsV.fields("Status") = Status
            If Status = "U" Then
                rsV.fields("AUserID") = dbUser
                rsV.fields("AUserDate") = Today.Date
                rsV.fields("AUserID_Ext") = dbUser
                rsV.fields("AUserDate_Ext") = Today.Date
            End If
            If Not rsV.Update Then Throw New Exception(db.ErrDesc)

            If Not TaxDeductionF AndAlso CBool(toval(GetAppSetting("CheckTaxDeductionF"))) Then
                Dim SQL As String
                SQL = "Select sum(Admlink.PNominal_Tax/Admlink.Amount*pSL.Nominal*TaxType.TaxRate/100) as TaxNominal"
                SQL = SQL & " from Admlink, nVoucher, pSL, pVoucher, Profile, TaxType, MParam"
                SQL = SQL & " Where MParam.Type=Admlink.Type and Admlink.Voucher=nVoucher.Voucher and Admlink.Amount_14=0 and nVoucher.TaxF=1 and nVoucher.Voucher=pSL.Doc_No and pSL.PaymentF=1 and pVoucher.Voucher=pSL.Voucher and pVoucher.Voucher='" & Voucher & "'"
                SQL = SQL & " and Profile.ID=Admlink.ID and TaxType.TaxType=dbo.Get_TaxType(Profile.TaxType,Profile.ID,pVoucher.Date, '',0, MParam.TaxDiscount) "
                SQL = SQL & " and not ('" & Format(VoucherDate, "MM/DD/YYYY") & "' Between coalesce(Profile.TaxHSDate,'01/01/1900') and coalesce(Profile.TaxHEDate,'01/01/1900'))"
                rs = db.OpenRemoteSet(SQL)
                If Math.Round(toval(rs.fields("TaxNominal")), 4, MidpointRounding.AwayFromZero) <> 0 Then
                    Throw New Exception("Tax not yet Deducted !")
                End If
            End If

            ' Set Output Parameter
            ReDim OutParam(7)
            OutParam(0) = Voucher
            OutParam(1) = toval(OParam(0))          ' Num_Doc
            OutParam(2) = toval(OParam(1))          ' Payment_CC
            OutParam(3) = toval(OParam(2))          ' nPayment
            OutParam(4) = toval(OParam(3))          ' Nominal_CC
            OutParam(5) = toval(OParam(4))          ' Diff_CC
            OutParam(6) = toval(OParam(3)) * Rate   ' Nominal
            OutParam(7) = toval(OParam(4)) * Rate   ' Diff

            If Dataset.Tables(0).Rows.Count > 0 Then
                If Not db.ReleaseLockedObject("Voucher" & Left(tostr(Dataset.Tables(0).Rows(0)("Doc_No")), 20)) Then Throw New Exception(db.ErrDesc)
            End If
            If LockedKey <> "" Then If Not db.ReleaseLockedObject("Voucher" & LockedKey) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ' Set Output Parameter
            ReDim OutParam(0)
            OutParam(0) = Voucher

            ErrMsg = ex.Message
            FANotes(Voucher, "Receipt Adjustment", "Save : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SaveVoucherPA(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal findex() As String, ByVal fbuffer() As String, ByVal Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Branch As String
            Dim VoucherDate As Date
            Dim RefNo As String

            Voucher = getInParamValue(InParam, 0)
            Branch = getInParamValue(InParam, 1)
            VoucherDate = getInParamValue(InParam, 2)
            RefNo = getInParamValue(InParam, 3)

            Dim LockedKey As String = ""
            If Voucher <> "" Then
                LockedKey = Voucher
                If Not db.GetLockedObject("Voucher" & LockedKey) Then Throw New Exception(db.ErrDesc)
            End If
            If Dataset.Tables(0).Rows.Count > 0 Then
                If Not db.GetLockedObject("Voucher" & Left(tostr(Dataset.Tables(0).Rows(0)("Doc_No")), 20)) Then Throw New Exception(db.ErrDesc)
            End If

            Dim rs As RemoteSet
            Dim br_Currency As String
            Dim br_Currency_1 As String
            Dim VType As String
            Dim ComAcc As String
            Dim AutoNum As String
            Dim CodeExt As String
            Dim Currency As String
            Dim Rate As Double
            Dim Rate_RC As Double
            Dim ProAcc As String
            Dim CT As String
            Dim Remarks As String
            Dim Status As String


            rs = db.OpenRemoteSet("Select Currency, Currency_1 from SysTab")
            br_Currency = rs.fields("Currency")
            br_Currency_1 = rs.fields("Currency_1")

            VType = GetFieldValue(fbuffer(GetFieldIndex("VType", findex)))
            ComAcc = GetFieldValue(fbuffer(GetFieldIndex("ComAcc", findex)))
            Currency = GetFieldValue(fbuffer(GetFieldIndex("Currency", findex)))

            If CBool(toval(GetAppSetting("UseBookingRateWhenMatchingF"))) Then
                rs = db.OpenRemoteSet("Select Rate, Rate_RC from pVoucher Voucher Where Voucher='" & RefNo & "'")
                Rate = toval(rs.fields("Rate"))
                Rate_RC = toval(rs.fields("Rate_RC"))
            Else
                Rate = exchange_rate(Currency, VoucherDate, br_Currency)
                Rate_RC = exchange_rate_RC(Currency, VoucherDate, br_Currency_1)
            End If

            ProAcc = GetFieldValue(fbuffer(GetFieldIndex("ProAcc", findex)))
            CT = GetFieldValue(fbuffer(GetFieldIndex("CT", findex)))
            Remarks = GetFieldValue(fbuffer(GetFieldIndex("Remarks", findex)))

            rs = db.OpenRemoteSet("select vType, SL_Cat, AutoNum, DebtorF, CreditorF, CodeExt from vType where SL_Cat='A' and DebtorF=1 and vtype = '" & VType & "'")
            AutoNum = tostr(rs.fields("AutoNum"))
            CodeExt = tostr(rs.fields("CodeExt"))

            Dim rsV As RemoteSet
            Dim EditMode As Integer
            rsV = db.OpenRemoteSet("Select * from pVoucher Where Voucher='" & Voucher & "'")
            If rsV.Eof Then
                If Not PreAddVoucherRAPA(InParam, ErrMsg) Then Throw New Exception(ErrMsg)

                If Voucher = "" Then
                    Voucher = db.GetNextDocNo(AutoNum, VoucherDate, Branch)
                End If
                If Voucher = "" Then Throw New Exception("Generate Voucher Number Failed !")
                rsV.AddNew()
            Else
                If Not PreAddVoucherRAPA(InParam, ErrMsg) Then Throw New Exception(ErrMsg)
                If Not PreEditVoucherRAPA(InParam, ErrMsg) Then Throw New Exception(ErrMsg)
                rsV.Edit()
            End If
            EditMode = rsV.editmode

            Dim i As Integer
            Dim j As Integer
            i = 0
            j = UBound(findex)
            Do While i < j
                rsV.fields(findex(i)) = GetFieldValue(fbuffer(i))
                i = i + 1
            Loop
            If Not db.GetPrivileges("ALLOWPASSSCANPAN") Then
                If isContainRestrictedPAN(rsV.fields("AccountNo")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field AccountNo!")
                End If
                If isContainRestrictedPAN(rsV.fields("REFNO")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field REFNO!")
                End If
                If isContainRestrictedPAN(rsV.fields("REMARKS")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field REMARKS!")
                End If
            End If
            If EditMode = AdEditAdd Then
                rsV.fields("Branch") = Branch
                rsV.fields("CDate") = Today.Date
                rsV.fields("CTime") = Time()
                rsV.fields("UserID") = dbUser
                rsV.fields("Voucher") = Voucher
            End If
            rsV.fields("Date") = VoucherDate
            rsV.fields("Rate") = Rate
            rsV.fields("Rate_RC") = Rate_RC
            rsV.fields("CreditorF") = False
            rsV.fields("DebtorF") = True
            rsV.fields("SL_Flag") = True
            rsV.fields("SL_Cat") = "A"
            rsV.fields("Num_Doc") = 0
            rsV.fields("SL_Tag") = 1
            rsV.fields("PDate") = VoucherDate
            rsV.fields("Last_Date") = Today.Date
            rsV.fields("Last_Time") = Time()
            rsV.fields("Last_Opr") = dbUser
            rsV.fields("BackDatedF") = False
            rsV.fields("Posting_Flag") = False
            If Not rsV.Update Then Throw New Exception(db.ErrDesc)

            Dim TaxDeductionF As Boolean = False
            Const MaxCols = 16
            Dim Bufferdata(Dataset.Tables(0).Rows.Count - 1, MaxCols - 1) As Object
            For i = 0 To Dataset.Tables(0).Rows.Count - 1
                Bufferdata(i, 0) = tostr(Dataset.Tables(0).Rows(i)("Doc_No"))
                Bufferdata(i, 1) = todate(Dataset.Tables(0).Rows(i)("Doc_Date"))
                Bufferdata(i, 2) = tostr(Dataset.Tables(0).Rows(i)("Doc_CCY"))
                Bufferdata(i, 3) = RoundCCY(toval(Dataset.Tables(0).Rows(i)("Nominal_OC")), UCase(tostr(Dataset.Tables(0).Rows(i)("Doc_CCY"))), toval(GetAppSetting("FARoundingDecimalValue")))
                Bufferdata(i, 4) = tostr(Dataset.Tables(0).Rows(i)("CT"))
                Bufferdata(i, 5) = RoundCCY(toval(Dataset.Tables(0).Rows(i)("Nominal")), UCase(Currency), toval(GetAppSetting("FARoundingDecimalValue")))
                Bufferdata(i, 6) = tostr(Dataset.Tables(0).Rows(i)("Remarks"))
                Bufferdata(i, 7) = toval(Dataset.Tables(0).Rows(i)("Hint"))
                If toval(Dataset.Tables(0).Rows(i)("Hint")) = -14 Then
                    TaxDeductionF = True
                End If
                Bufferdata(i, 8) = IIf(toval(Dataset.Tables(0).Rows(i)("PaymentF")) = 0, False, True)
                Bufferdata(i, 9) = tostr(Dataset.Tables(0).Rows(i)("Account"))
                Bufferdata(i, 10) = toval(Dataset.Tables(0).Rows(i)("Nominator"))
                Bufferdata(i, 11) = toval(Dataset.Tables(0).Rows(i)("Denominator"))
                Bufferdata(i, 14) = toval(Dataset.Tables(0).Rows(i)("LockedF"))
                Bufferdata(i, 15) = toval(Dataset.Tables(0).Rows(i)("FundingF"))
            Next

            Dim Param(5) As Object
            Param(0) = Voucher
            Param(1) = VoucherDate
            Param(2) = VType
            Param(3) = Currency
            Param(4) = RefNo
            Param(5) = Branch

            Dim OParam As Object = Nothing

            Const MaxRows_2 = 100
            Const MaxCols_2 = 2
            Dim bufferdata_2(MaxRows_2 - 1, MaxCols_2 - 1) As Object

            OParam = Me.Direct_Call_Process_Execute("ProcessFAExt.NetV3.Proclib", "SAVE_DETAIL_PA", Param, TrimBuffer(Bufferdata), TrimBuffer(bufferdata_2))
            If TypeName(OParam) <> "Object()" Then Throw New Exception(Me.ErrDesc)

            ' see fields to buffer for converting date field

            ' Refreshing Data
            rsV.Edit()
            rsV.fields("Num_Doc") = toval(OParam(0))
            rsV.fields("Payment_CC") = toval(OParam(1))
            rsV.fields("nPayment") = toval(OParam(2))
            rsV.fields("Nominal_CC") = toval(OParam(3))
            rsV.fields("Diff_CC") = toval(OParam(4))
            rsV.fields("Nominal") = toval(OParam(3)) * Rate
            rsV.fields("Diff") = toval(OParam(4)) * Rate

            Dim TotalAmount As Double
            TotalAmount = rsV.fields("Nominal") - rsV.fields("Diff")
            If Not GetApprovalLimitFA(dbUser, VType, "Out", TotalAmount) Or Not db.GetPrivileges("ALLOWADJUSTMENT") Then
                Status = "N"    ' Not Approved
            Else
                Status = "U"    ' Ok Approved, Un-Posting
            End If
            rsV.fields("Status") = Status
            If Status = "U" Then
                rsV.fields("AUserID") = dbUser
                rsV.fields("AUserDate") = Today.Date
                rsV.fields("AUserID_Ext") = dbUser
                rsV.fields("AUserDate_Ext") = Today.Date
            End If
            If Not rsV.Update Then Throw New Exception(db.ErrDesc)

            If Not TaxDeductionF AndAlso CBool(toval(GetAppSetting("CheckTaxDeductionF"))) Then
                Dim SQL As String
                SQL = "Select sum(Admlink.PNominal_Tax/Admlink.Amount*pSL.Nominal*TaxType.TaxRate/100) as TaxNominal"
                SQL = SQL & " from Admlink, nVoucher, pSL, pVoucher, Profile, TaxType, MParam"
                SQL = SQL & " Where MParam.Type=Admlink.Type and Admlink.Voucher=nVoucher.Voucher and Admlink.Amount_14=0 and nVoucher.TaxF=1 and nVoucher.Voucher=pSL.Doc_No and pSL.PaymentF=1 and pVoucher.Voucher=pSL.Voucher and pVoucher.Voucher='" & Voucher & "'"
                SQL = SQL & " and Profile.ID=Admlink.ID and TaxType.TaxType=dbo.Get_TaxType(Profile.TaxType,Profile.ID,pVoucher.Date, '',0, MParam.TaxDiscount) "
                SQL = SQL & " and not ('" & Format(VoucherDate, "MM/DD/YYYY") & "' Between coalesce(Profile.TaxHSDate,'01/01/1900') and coalesce(Profile.TaxHEDate,'01/01/1900'))"
                rs = db.OpenRemoteSet(SQL)
                If Math.Round(toval(rs.fields("TaxNominal")), 4, MidpointRounding.AwayFromZero) <> 0 Then
                    Throw New Exception("Tax not yet Deducted !")
                End If
            End If

            ' Set Output Parameter
            ReDim OutParam(7)
            OutParam(0) = Voucher
            OutParam(1) = toval(OParam(0))          ' Num_Doc
            OutParam(2) = toval(OParam(1))          ' Payment_CC
            OutParam(3) = toval(OParam(2))          ' nPayment
            OutParam(4) = toval(OParam(3))          ' Nominal_CC
            OutParam(5) = toval(OParam(4))          ' Diff_CC
            OutParam(6) = toval(OParam(3)) * Rate   ' Nominal
            OutParam(7) = toval(OParam(4)) * Rate   ' Diff

            If Dataset.Tables(0).Rows.Count > 0 Then
                If Not db.ReleaseLockedObject("Voucher" & Left(tostr(Dataset.Tables(0).Rows(0)("Doc_No")), 20)) Then Throw New Exception(db.ErrDesc)
            End If
            If LockedKey <> "" Then If Not db.ReleaseLockedObject("Voucher" & LockedKey) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ' Set Output Parameter
            ReDim OutParam(0)
            OutParam(0) = Voucher

            ErrMsg = ex.Message
            FANotes(Voucher, "Payment Adjustment", "Save : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SaveVoucherWT(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal findex() As String, ByVal fbuffer() As String, ByVal Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Branch As String
            Dim VoucherDate As Date
            Dim CorrectionF As Boolean

            Voucher = getInParamValue(InParam, 0)
            Branch = getInParamValue(InParam, 1)
            VoucherDate = getInParamValue(InParam, 2)
            CorrectionF = toval(getInParamValue(InParam, 3))

            Dim LockedKey As String = ""
            If Voucher <> "" Then
                LockedKey = Voucher
                If Not db.GetLockedObject("Voucher" & LockedKey) Then Throw New Exception(db.ErrDesc)
            End If

            Dim rs As RemoteSet
            Dim br_Currency As String
            Dim br_Currency_1 As String
            Dim VType As String
            Dim ComAcc As String
            Dim AutoNum As String
            Dim CodeExt As String
            Dim Currency As String
            Dim Rate As Double
            Dim Rate_RC As Double
            Dim ProAcc As String
            Dim CT As String
            Dim Remarks As String

            If CorrectionF Then
                Voucher = ""
                rs = db.OpenRemoteSet("Select end_Date from Branch Where Branch='" & Branch & "'")
                If VoucherDate < DateAdd(DateInterval.Day, 1, rs.fields("End_Date")) Then
                    VoucherDate = DateAdd(DateInterval.Day, 1, rs.fields("End_Date"))
                End If
                InParam(0) = Voucher
                InParam(2) = VoucherDate
            End If

            rs = db.OpenRemoteSet("Select Currency, Currency_1 from SysTab")
            br_Currency = rs.fields("Currency")
            br_Currency_1 = rs.fields("Currency_1")

            VType = GetFieldValue(fbuffer(GetFieldIndex("VType", findex)))
            ComAcc = GetFieldValue(fbuffer(GetFieldIndex("ComAcc", findex)))
            Currency = GetFieldValue(fbuffer(GetFieldIndex("Currency", findex)))
            Rate = exchange_rate(Currency, VoucherDate, br_Currency)
            Rate_RC = exchange_rate_RC(Currency, VoucherDate, br_Currency_1)
            ProAcc = GetFieldValue(fbuffer(GetFieldIndex("ProAcc", findex)))
            CT = GetFieldValue(fbuffer(GetFieldIndex("CT", findex)))
            Remarks = GetFieldValue(fbuffer(GetFieldIndex("Remarks", findex)))

            rs = db.OpenRemoteSet("select vType, SL_Cat, AutoNum, DebtorF, CreditorF, CodeExt from vType where SL_Cat='N' and CreditorF=1 and TaxF=1 and vtype = '" & VType & "'")
            AutoNum = tostr(rs.fields("AutoNum"))
            CodeExt = tostr(rs.fields("CodeExt"))

            Dim rsV As RemoteSet
            Dim EditMode As Integer
            rsV = db.OpenRemoteSet("Select * from nVoucher Where Voucher='" & Voucher & "'")
            If rsV.Eof Then
                If Not PreAddVoucherWT(InParam, ProAcc, Currency, ErrMsg) Then Throw New Exception(ErrMsg)

                Voucher = db.GetNextDocNo(AutoNum, VoucherDate, Branch)
                If Voucher = "" Then Throw New Exception("Generate Voucher Number Failed !")

                rsV.AddNew()
            Else
                If Not PreAddVoucherWT(InParam, ProAcc, Currency, ErrMsg) Then Throw New Exception(ErrMsg)
                If Not PreEditVoucherWT(InParam, ErrMsg) Then Throw New Exception(ErrMsg)

                rsV.Edit()
            End If
            EditMode = rsV.editmode

            Dim i As Integer
            Dim j As Integer
            i = 0
            j = UBound(findex)
            Do While i < j
                rsV.fields(findex(i)) = GetFieldValue(fbuffer(i))
                i = i + 1
            Loop
            If EditMode = AdEditAdd Then
                rsV.fields("Branch") = Branch
                rsV.fields("CDate") = Today.Date
                rsV.fields("CTime") = Time()
                rsV.fields("UserID") = dbUser
                rsV.fields("Voucher") = Voucher
                rsV.fields("Date") = VoucherDate
                rsV.fields("Num_Doc") = 0
                rsV.fields("Payment_CC") = 0
                rsV.fields("nPayment") = 0
                rsV.fields("Nominal_CC") = 0
                rsV.fields("Diff_CC") = 0
                rsV.fields("Nominal") = 0
                rsV.fields("Diff") = 0
                rsV.fields("RefAmout") = 0
            End If
            rsV.fields("DocNo") = ""
            rsV.fields("Date") = VoucherDate
            rsV.fields("Rate") = Rate
            rsV.fields("Rate_RC") = Rate_RC
            rsV.fields("ReceiptF") = False
            rsV.fields("PaymentF") = False
            rsV.fields("CreditorF") = True
            rsV.fields("DebtorF") = False
            rsV.fields("SL_Flag") = True
            rsV.fields("SL_Cat") = "N"
            rsV.fields("Num_Doc") = 0
            rsV.fields("SL_Tag") = 0
            rsV.fields("PDate") = VoucherDate
            rsV.fields("Last_Date") = Today.Date
            rsV.fields("Last_Time") = Time()
            rsV.fields("Last_Opr") = dbUser
            rsV.fields("BackDatedF") = False
            rsV.fields("Source") = ""
            rsV.fields("TaxF") = True
            rsV.fields("Posting_Flag") = False
            If Not rsV.Update Then Throw New Exception(db.ErrDesc)

            Const MaxCols = 13
            Dim Bufferdata(Dataset.Tables(0).Rows.Count - 1, MaxCols - 1) As Object
            For i = 0 To Dataset.Tables(0).Rows.Count - 1
                Bufferdata(i, 0) = tostr(Dataset.Tables(0).Rows(i)("Doc_No"))
                Bufferdata(i, 1) = todate(Dataset.Tables(0).Rows(i)("Doc_Date"))
                Bufferdata(i, 2) = tostr(Dataset.Tables(0).Rows(i)("Doc_CCY"))
                Bufferdata(i, 3) = toval(Dataset.Tables(0).Rows(i)("Nominal_OC")) * IIf(CorrectionF, -1, 1)
                Bufferdata(i, 4) = toval(Dataset.Tables(0).Rows(i)("Rate"))
                Bufferdata(i, 5) = toval(Dataset.Tables(0).Rows(i)("Nominal")) * IIf(CorrectionF, -1, 1)
                Bufferdata(i, 6) = tostr(Dataset.Tables(0).Rows(i)("Remarks"))
                Bufferdata(i, 7) = toval(Dataset.Tables(0).Rows(i)("Hint"))
                Bufferdata(i, 8) = IIf(toval(Dataset.Tables(0).Rows(i)("PaymentF")) = 0, False, True)
                Bufferdata(i, 9) = tostr(Dataset.Tables(0).Rows(i)("Account"))
                Bufferdata(i, 10) = tostr(Dataset.Tables(0).Rows(i)("CT"))
                Bufferdata(i, 11) = tostr(Dataset.Tables(0).Rows(i)("pVoucher"))
                Bufferdata(i, 12) = toval(Dataset.Tables(0).Rows(i)("TaxPayment_OC")) * IIf(CorrectionF, -1, 1)
            Next

            Dim Param(8) As Object
            Param(0) = Voucher
            Param(1) = VoucherDate
            Param(2) = VType
            Param(3) = Currency
            Param(4) = ""
            Param(5) = rsV.fields("RefNo")
            Param(6) = CorrectionF
            Param(7) = CodeExt
            Param(8) = rsV.fields("TaxType")

            Dim OParam As Object = Nothing

            OParam = Me.Direct_Call_Process_Execute("ProcessFAExt.NetV3.Proclib", "SAVE_DETAIL_WT", Param, TrimBuffer(Bufferdata))
            If TypeName(OParam) <> "Object()" Then Throw New Exception(Me.ErrDesc)

            ' see fields to buffer for converting date field

            ' Refreshing Data
            rsV.Edit()
            rsV.fields("Num_Doc") = toval(OParam(0))
            rsV.fields("Payment_CC") = toval(OParam(1))
            rsV.fields("nPayment") = toval(OParam(2))
            rsV.fields("Nominal_CC") = toval(OParam(3))
            rsV.fields("Diff_CC") = toval(OParam(4))
            rsV.fields("Nominal") = toval(OParam(3)) * Rate
            rsV.fields("Diff") = toval(OParam(4)) * Rate
            rsV.fields("RefAmout") = toval(OParam(5))
            rsV.fields("Status") = "U"
            rsV.fields("AUserID") = dbUser
            rsV.fields("AUserDate") = Today.Date
            If Not rsV.Update Then Throw New Exception(db.ErrDesc)

            ' Set Output Parameter
            ReDim OutParam(7)
            OutParam(0) = Voucher
            OutParam(1) = toval(OParam(0))          ' Num_Doc
            OutParam(2) = toval(OParam(1))          ' Payment_CC
            OutParam(3) = toval(OParam(2))          ' nPayment
            OutParam(4) = toval(OParam(3))          ' Nominal_CC
            OutParam(5) = toval(OParam(4))          ' Diff_CC
            OutParam(6) = toval(OParam(3)) * Rate   ' Nominal
            OutParam(7) = toval(OParam(4)) * Rate   ' Diff

            If LockedKey <> "" Then If Not db.ReleaseLockedObject("Voucher" & LockedKey) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Voucher, "Withholding Tax", "Save : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    Private Function PreAddVoucherWT(ByVal InParam As Object(), ByVal ProAcc As String, ByVal Currency As String, ByRef Errmsg As String) As Boolean

        Dim rs As RemoteSet
        Dim br_End_Date As Date
        Dim br_Month As Integer
        Dim br_Year As Integer
        Dim FLockedDate As Date

        Dim Voucher As String
        Dim Branch As String
        Dim VoucherDate As Date

        Voucher = getInParamValue(InParam, 0)
        Branch = getInParamValue(InParam, 1)
        VoucherDate = getInParamValue(InParam, 2)

        On Error GoTo errmsg

        rs = db.OpenRemoteSet("Select * from Branch where branch='" & Branch & "'")
        If Not rs.Eof Then
            br_End_Date = todate(rs.fields("end_date"))
            br_Month = toval(rs.fields("Month"))
            br_Year = toval(rs.fields("year"))
        End If

        If Not db.GetPrivileges("ALLOWLOCKEDPERIOD") Then
            FLockedDate = GetFLockedDate(Branch)
            If DateDiff(DateInterval.Day, FLockedDate, VoucherDate) <= 0 Then
                Errmsg = "Transactions for this period have been closed, Check the Closing Date on " & FLockedDate
                GoTo errmsg
            End If
        End If

        If (DateDiff(DateInterval.Day, VoucherDate, br_End_Date) >= 0) Then
            Errmsg = "Backdated Transaction, Check the Ending Date on " & br_End_Date & " !"
            GoTo errmsg
        End If

        rs = db.OpenRemoteSet("Select ProAcc, Description, Currency, RestrictedF from ProAcc where ProAcc='" & ProAcc & "'")
        If rs.Eof Then
            Errmsg = "Not a Valid Profile Account-" & ProAcc
            Throw New Exception(Errmsg)
        End If

        If toval(rs.fields("RestrictedF")) Then
            Errmsg = "Not Allowed for Restricted Profile Account-" & ProAcc & "-" & rs.fields("Description")
            Throw New Exception(Errmsg)
        End If

        If rs.fields("Currency") <> Currency Then
            Errmsg = "Not a Valid Profile Account-" & ProAcc & " for Voucher Currency-'" & Currency
            Throw New Exception(Errmsg)
        End If

        Return True
errmsg:
        Errmsg = StrError(Errmsg)
        Return False
    End Function
    Private Function PreEditVoucherWT(ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim rs As RemoteSet
        Dim VType As String

        Dim Voucher As String
        Dim VoucherDate As Date

        Voucher = getInParamValue(InParam, 0)
        'Branch = getInParamValue(InParam, 1)
        VoucherDate = getInParamValue(InParam, 2)

        On Error GoTo errmsg

        rs = db.OpenRemoteSet("Select * from nVoucher, VType Where VType.VType=nVoucher.VType and nVoucher.SL_Cat='N' and VType.TaxF=1 and nVoucher.CreditorF=1 and nVoucher.Voucher='" & Voucher & "'")
        If rs.Eof Then
            ErrMsg = "No WH Tax Voucher Data !"
            Throw New Exception(ErrMsg)
        End If

        If Month(VoucherDate) + Year(VoucherDate) * 12 <> Month(rs.fields("Date")) + Year(rs.fields("Date")) * 12 Then
            If Not db.GetPrivileges("ALLOWCHANGEDATE") Then
                ErrMsg = "Not Allowed To Change Booking Date !"
                GoTo errmsg
            End If
        End If

        If rs.fields("BranchF") Then
            ErrMsg = "Branch Data Upload Constraint !"
            GoTo errmsg
        End If

        If Not toval(getInParamValue(InParam, 3)) Then
            If rs.fields("DocNo") <> "" Then
                ErrMsg = "Document Constraint With Voucher.'" & rs.fields("DocNo") & "' !"
                GoTo errmsg
            End If
        End If

        If Not rs.fields("BackDatedF") And rs.fields("Posting_Flag") = True Then
            ErrMsg = "Voucher Already Processed / Posted !"
            GoTo errmsg
        End If

        If rs.fields("RequestF") And UCase(rs.fields("RequestName")) <> UCase(dbUser) Then
            ErrMsg = "Document is being sent to User-'" & rs.fields("RequestName") & "' !"
            GoTo errmsg
        End If

        rs = db.OpenRemoteSet("Select Top 1 Voucher from pSL SL where Doc_No='" & Voucher & "' and PaymentF=1", adOpenForwardonly)
        If Not rs.Eof Then
            ErrMsg = "Document Already Used By Voucher. '" & tostr(rs.fields("Voucher")) & "' !"
            GoTo errmsg
        End If

        If Not db.GetPrivileges("ALLOWCHANGEVOUCHERWITHPRINTLOG") Then
            rs = db.OpenRemoteSet("Select Top 1 Voucher from VPrintLog Where Voucher='" & Voucher & "'")
            If Not rs.Eof Then
                ErrMsg = "Document Already has Printing Log !"
                GoTo errmsg
            End If
        End If

        Return True
errmsg:
        ErrMsg = StrError(ErrMsg)
        Return False
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function DropVoucherWT(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Branch As String
            Dim VoucherDate As Date

            Voucher = getInParamValue(InParam, 0)
            Branch = getInParamValue(InParam, 1)
            VoucherDate = getInParamValue(InParam, 2)

            If Not db.GetLockedObject("Voucher" & Voucher) Then Throw New Exception(db.ErrDesc)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select nVoucher.Voucher from nVoucher, VType Where VType.VType=nVoucher.VType and nVoucher.SL_Cat='N' and VType.TaxF=1 and nVoucher.CreditorF=1 and nVoucher.Voucher='" & Voucher & "'")
            If rs.Eof Then
                ErrMsg = "No WH Tax Voucher Data !"
                Throw New Exception(ErrMsg)
            End If

            If Not PreEditVoucherWT(InParam, ErrMsg) Then Throw New Exception(ErrMsg)

            If Not Save_Log_Object("nVoucher", "Voucher", Voucher, "ProAcc", rs.fields("ProAcc"), "RefNo", rs.fields("RefNo"), "Remarks", rs.fields("Remarks"), "", "", "", "Delete") Then Throw New Exception("Can't Save to Log !")

            If Not Delete_WithholdingTax(Voucher) Then Throw New Exception(db.ErrDesc)

            If Not db.Execute("Update SysRequest Set Status='P',LUserID='" & dbUser & "', LUserDate='" & Format(Today.Date, "MM/DD/YYYY") & "',LUserTime='" & Time() & "' from SysRequest Where Status<>'P' and Param1='SEND' and Param2 in ('FA') and Param6='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)

            If Not db.ReleaseLockedObject("Voucher" & Voucher) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Voucher, "Witholding Tax Voucher", "Drop : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function


    <WebMethod(EnableSession:=False)> _
    Public Function SaveVoucherWVAT(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal findex() As String, ByVal fbuffer() As String, ByVal Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Branch As String
            Dim VoucherDate As Date
            Dim CorrectionF As Boolean

            Voucher = getInParamValue(InParam, 0)
            Branch = getInParamValue(InParam, 1)
            VoucherDate = getInParamValue(InParam, 2)
            CorrectionF = toval(getInParamValue(InParam, 3))

            Dim LockedKey As String = ""
            If Voucher <> "" Then
                LockedKey = Voucher
                If Not db.GetLockedObject("Voucher" & LockedKey) Then Throw New Exception(db.ErrDesc)
            End If

            Dim rs As RemoteSet
            Dim br_Currency As String
            Dim br_Currency_1 As String
            Dim VType As String
            Dim ComAcc As String
            Dim AutoNum As String
            Dim CodeExt As String
            Dim Currency As String
            Dim Rate As Double
            Dim Rate_RC As Double
            Dim ProAcc As String
            Dim CT As String
            Dim Remarks As String

            If CorrectionF Then
                Voucher = ""
                rs = db.OpenRemoteSet("Select end_Date from Branch Where Branch='" & Branch & "'")
                If VoucherDate < DateAdd(DateInterval.Day, 1, rs.fields("End_Date")) Then
                    VoucherDate = DateAdd(DateInterval.Day, 1, rs.fields("End_Date"))
                End If
                InParam(0) = Voucher
                InParam(2) = VoucherDate
            End If

            rs = db.OpenRemoteSet("Select Currency, Currency_1 from SysTab")
            br_Currency = rs.fields("Currency")
            br_Currency_1 = rs.fields("Currency_1")

            VType = GetFieldValue(fbuffer(GetFieldIndex("VType", findex)))
            ComAcc = GetFieldValue(fbuffer(GetFieldIndex("ComAcc", findex)))
            Currency = GetFieldValue(fbuffer(GetFieldIndex("Currency", findex)))
            Rate = exchange_rate(Currency, VoucherDate, br_Currency)
            Rate_RC = exchange_rate_RC(Currency, VoucherDate, br_Currency_1)
            ProAcc = GetFieldValue(fbuffer(GetFieldIndex("ProAcc", findex)))
            CT = GetFieldValue(fbuffer(GetFieldIndex("CT", findex)))
            Remarks = GetFieldValue(fbuffer(GetFieldIndex("Remarks", findex)))

            rs = db.OpenRemoteSet("select vType, SL_Cat, AutoNum, DebtorF, CreditorF, CodeExt from vType where SL_Cat='N' and CreditorF=1 and VatF=1 and vtype = '" & VType & "'")
            AutoNum = tostr(rs.fields("AutoNum"))
            CodeExt = tostr(rs.fields("CodeExt"))

            Dim rsV As RemoteSet
            Dim EditMode As Integer
            rsV = db.OpenRemoteSet("Select * from nVoucher Where Voucher='" & Voucher & "'")
            If rsV.Eof Then
                If Not PreAddVoucherWVAT(InParam, ProAcc, Currency, ErrMsg) Then Throw New Exception(ErrMsg)

                Voucher = db.GetNextDocNo(AutoNum, VoucherDate, Branch)
                If Voucher = "" Then Throw New Exception("Generate Voucher Number Failed !")

                rsV.AddNew()
            Else
                If Not PreAddVoucherWVAT(InParam, ProAcc, Currency, ErrMsg) Then Throw New Exception(ErrMsg)
                If Not PreEditVoucherWVAT(InParam, ErrMsg) Then Throw New Exception(ErrMsg)

                rsV.Edit()
            End If
            EditMode = rsV.editmode

            Dim i As Integer
            Dim j As Integer
            i = 0
            j = UBound(findex)
            Do While i < j
                rsV.fields(findex(i)) = GetFieldValue(fbuffer(i))
                i = i + 1
            Loop
            If EditMode = AdEditAdd Then
                rsV.fields("Branch") = Branch
                rsV.fields("CDate") = Today.Date
                rsV.fields("CTime") = Time()
                rsV.fields("UserID") = dbUser
                rsV.fields("Voucher") = Voucher
                rsV.fields("Date") = VoucherDate
            End If
            rsV.fields("DocNo") = ""
            rsV.fields("Date") = VoucherDate
            rsV.fields("Rate") = Rate
            rsV.fields("Rate_RC") = Rate_RC
            rsV.fields("ReceiptF") = False
            rsV.fields("PaymentF") = False
            rsV.fields("CreditorF") = True
            rsV.fields("DebtorF") = False
            rsV.fields("SL_Flag") = True
            rsV.fields("SL_Cat") = "N"
            rsV.fields("Num_Doc") = 0
            rsV.fields("SL_Tag") = 0
            rsV.fields("PDate") = VoucherDate
            rsV.fields("Last_Date") = Today.Date
            rsV.fields("Last_Time") = Time()
            rsV.fields("Last_Opr") = dbUser
            rsV.fields("BackDatedF") = False
            rsV.fields("Source") = ""
            rsV.fields("VatF") = True
            rsV.fields("Posting_Flag") = False
            If Not rsV.Update Then Throw New Exception(db.ErrDesc)

            Const MaxCols = 13
            Dim Bufferdata(Dataset.Tables(0).Rows.Count - 1, MaxCols - 1) As Object
            For i = 0 To Dataset.Tables(0).Rows.Count - 1
                Bufferdata(i, 0) = tostr(Dataset.Tables(0).Rows(i)("Doc_No"))
                Bufferdata(i, 1) = todate(Dataset.Tables(0).Rows(i)("Doc_Date"))
                Bufferdata(i, 2) = tostr(Dataset.Tables(0).Rows(i)("Doc_CCY"))
                Bufferdata(i, 3) = toval(Dataset.Tables(0).Rows(i)("Nominal_OC")) * IIf(CorrectionF, -1, 1)
                Bufferdata(i, 4) = toval(Dataset.Tables(0).Rows(i)("Rate"))
                Bufferdata(i, 5) = toval(Dataset.Tables(0).Rows(i)("Nominal")) * IIf(CorrectionF, -1, 1)
                Bufferdata(i, 6) = tostr(Dataset.Tables(0).Rows(i)("Remarks"))
                Bufferdata(i, 7) = toval(Dataset.Tables(0).Rows(i)("Hint"))
                Bufferdata(i, 8) = IIf(toval(Dataset.Tables(0).Rows(i)("PaymentF")) = 0, False, True)
                Bufferdata(i, 9) = tostr(Dataset.Tables(0).Rows(i)("Account"))
                Bufferdata(i, 10) = tostr(Dataset.Tables(0).Rows(i)("CT"))
                Bufferdata(i, 11) = tostr(Dataset.Tables(0).Rows(i)("pVoucher"))
                Bufferdata(i, 12) = toval(Dataset.Tables(0).Rows(i)("VATPayment_OC")) * IIf(CorrectionF, -1, 1)
            Next

            Dim Param(7) As Object
            Param(0) = Voucher
            Param(1) = VoucherDate
            Param(2) = VType
            Param(3) = Currency
            Param(4) = ""
            Param(5) = rsV.fields("RefNo")
            Param(6) = CorrectionF
            Param(7) = CodeExt

            Dim OParam As Object = Nothing

            OParam = Me.Direct_Call_Process_Execute("ProcessFAExt.NetV3.Proclib", "SAVE_DETAIL_WVAT", Param, TrimBuffer(Bufferdata))
            If TypeName(OParam) <> "Object()" Then Throw New Exception(Me.ErrDesc)

            ' see fields to buffer for converting date field

            ' Refreshing Data
            rsV.Edit()
            rsV.fields("Num_Doc") = toval(OParam(0))
            rsV.fields("Payment_CC") = toval(OParam(1))
            rsV.fields("nPayment") = toval(OParam(2))
            rsV.fields("Nominal_CC") = toval(OParam(3))
            rsV.fields("Diff_CC") = toval(OParam(4))
            rsV.fields("Nominal") = toval(OParam(3)) * Rate
            rsV.fields("Diff") = toval(OParam(4)) * Rate
            rsV.fields("Status") = "U"
            rsV.fields("AUserID") = dbUser
            rsV.fields("AUserDate") = Today.Date
            If Not rsV.Update Then Throw New Exception(db.ErrDesc)

            ' Set Output Parameter
            ReDim OutParam(7)
            OutParam(0) = Voucher
            OutParam(1) = toval(OParam(0))          ' Num_Doc
            OutParam(2) = toval(OParam(1))          ' Payment_CC
            OutParam(3) = toval(OParam(2))          ' nPayment
            OutParam(4) = toval(OParam(3))          ' Nominal_CC
            OutParam(5) = toval(OParam(4))          ' Diff_CC
            OutParam(6) = toval(OParam(3)) * Rate   ' Nominal
            OutParam(7) = toval(OParam(4)) * Rate   ' Diff

            If LockedKey <> "" Then If Not db.ReleaseLockedObject("Voucher" & LockedKey) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Voucher, "WithHolding VAT", "Save : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    Private Function PreAddVoucherWVAT(ByVal InParam As Object(), ByVal ProAcc As String, ByVal Currency As String, ByRef Errmsg As String) As Boolean

        Dim rs As RemoteSet
        Dim br_End_Date As Date
        Dim br_Month As Integer
        Dim br_Year As Integer
        Dim FLockedDate As Date

        Dim Voucher As String
        Dim Branch As String
        Dim VoucherDate As Date

        Voucher = getInParamValue(InParam, 0)
        Branch = getInParamValue(InParam, 1)
        VoucherDate = getInParamValue(InParam, 2)

        On Error GoTo errmsg

        rs = db.OpenRemoteSet("Select * from Branch where branch='" & Branch & "'")
        If Not rs.Eof Then
            br_End_Date = todate(rs.fields("end_date"))
            br_Month = toval(rs.fields("Month"))
            br_Year = toval(rs.fields("year"))
        End If

        If Not db.GetPrivileges("ALLOWLOCKEDPERIOD") Then
            FLockedDate = GetFLockedDate(Branch)
            If DateDiff(DateInterval.Day, FLockedDate, VoucherDate) <= 0 Then
                Errmsg = "Transactions for this period have been closed, Check the Closing Date on " & FLockedDate
                GoTo errmsg
            End If
        End If

        If (DateDiff(DateInterval.Day, VoucherDate, br_End_Date) >= 0) Then
            Errmsg = "Backdated Transaction, Check the Ending Date on " & br_End_Date & " !"
            GoTo errmsg
        End If

        rs = db.OpenRemoteSet("Select ProAcc, Description, Currency, RestrictedF from ProAcc where ProAcc='" & ProAcc & "'")
        If rs.Eof Then
            Errmsg = "Not a Valid Profile Account-" & ProAcc
            Throw New Exception(Errmsg)
        End If

        If toval(rs.fields("RestrictedF")) Then
            Errmsg = "Not Allowed for Restricted Profile Account-" & ProAcc & "-" & rs.fields("Description")
            Throw New Exception(Errmsg)
        End If

        If rs.fields("Currency") <> Currency Then
            Errmsg = "Not a Valid Profile Account-" & ProAcc & " for Voucher Currency-'" & Currency
            Throw New Exception(Errmsg)
        End If

        Return True
errmsg:
        Errmsg = StrError(Errmsg)
        Return False
    End Function
    Private Function PreEditVoucherWVAT(ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim rs As RemoteSet
        Dim VType As String

        Dim Voucher As String
        Dim VoucherDate As Date

        Voucher = getInParamValue(InParam, 0)
        'Branch = getInParamValue(InParam, 1)
        VoucherDate = getInParamValue(InParam, 2)

        On Error GoTo errmsg

        rs = db.OpenRemoteSet("Select * from nVoucher, VType Where VType.VType=nVoucher.VType and nVoucher.SL_Cat='N' and VType.VatF=1 and nVoucher.CreditorF=1 and nVoucher.Voucher='" & Voucher & "'")
        If rs.Eof Then
            ErrMsg = "No WH VAT Voucher Data !"
            Throw New Exception(ErrMsg)
        End If

        If Month(VoucherDate) + Year(VoucherDate) * 12 <> Month(rs.fields("Date")) + Year(rs.fields("Date")) * 12 Then
            If Not db.GetPrivileges("ALLOWCHANGEDATE") Then
                ErrMsg = "Not Allowed To Change Booking Date !"
                GoTo errmsg
            End If
        End If

        If rs.fields("BranchF") Then
            ErrMsg = "Branch Data Upload Constraint !"
            GoTo errmsg
        End If

        If Not toval(getInParamValue(InParam, 3)) Then
            If rs.fields("DocNo") <> "" Then
                ErrMsg = "Document Constraint With Voucher.'" & rs.fields("DocNo") & "' !"
                GoTo errmsg
            End If
        End If

        If Not rs.fields("BackDatedF") And rs.fields("Posting_Flag") = True Then
            ErrMsg = "Voucher Already Processed / Posted !"
            GoTo errmsg
        End If

        If rs.fields("RequestF") And UCase(rs.fields("RequestName")) <> UCase(dbUser) Then
            ErrMsg = "Document is being sent to User-'" & rs.fields("RequestName") & "' !"
            GoTo errmsg
        End If

        rs = db.OpenRemoteSet("Select Top 1 Voucher from pSL SL where Doc_No='" & Voucher & "' and PaymentF=1", adOpenForwardonly)
        If Not rs.Eof Then
            ErrMsg = "Document Already Used By Voucher. '" & tostr(rs.fields("Voucher")) & "' !"
            GoTo errmsg
        End If

        If Not db.GetPrivileges("ALLOWCHANGEVOUCHERWITHPRINTLOG") Then
            rs = db.OpenRemoteSet("Select Top 1 Voucher from VPrintLog Where Voucher='" & Voucher & "'")
            If Not rs.Eof Then
                ErrMsg = "Document Already has Printing Log !"
                GoTo errmsg
            End If
        End If

        Return True
errmsg:
        ErrMsg = StrError(ErrMsg)
        Return False
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function DropVoucherWVAT(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Branch As String
            Dim VoucherDate As Date

            Voucher = getInParamValue(InParam, 0)
            Branch = getInParamValue(InParam, 1)
            VoucherDate = getInParamValue(InParam, 2)

            If Not db.GetLockedObject("Voucher" & Voucher) Then Throw New Exception(db.ErrDesc)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select nVoucher.Voucher from nVoucher, VType Where VType.VType=nVoucher.VType and nVoucher.SL_Cat='N' and VType.VatF=1 and nVoucher.CreditorF=1 and nVoucher.Voucher='" & Voucher & "'")
            If rs.Eof Then
                ErrMsg = "No WH VAT Voucher Data !"
                Throw New Exception(ErrMsg)
            End If

            If Not PreEditVoucherWVAT(InParam, ErrMsg) Then Throw New Exception(ErrMsg)

            If Not Save_Log_Object("nVoucher", "Voucher", Voucher, "ProAcc", rs.fields("ProAcc"), "RefNo", rs.fields("RefNo"), "Remarks", rs.fields("Remarks"), "", "", "", "Delete") Then Throw New Exception("Can't Save to Log !")

            If Not Delete_WithholdingVAT(Voucher) Then Throw New Exception(db.ErrDesc)

            If Not db.Execute("Update SysRequest Set Status='P',LUserID='" & dbUser & "', LUserDate='" & Format(Today.Date, "MM/DD/YYYY") & "',LUserTime='" & Time() & "' from SysRequest Where Status<>'P' and Param1='SEND' and Param2 in ('FA') and Param6='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)

            If Not db.ReleaseLockedObject("Voucher" & Voucher) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Voucher, "Witholding Vat Voucher", "Drop : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SearchRequestP(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Request As String = getInParamValue(InParam, 0)
            Dim RequestSDate As String = getInParamValue(InParam, 1)    ' Formatted Date MM/DD/YYYY
            Dim RequestEDate As String = getInParamValue(InParam, 2)    ' Formatted Date MM/DD/YYYY
            Dim VType As String = getInParamValue(InParam, 3)
            Dim Branch As String = getInParamValue(InParam, 4)
            Dim ProAcc As String = getInParamValue(InParam, 5)
            Dim ComAcc As String = getInParamValue(InParam, 6)
            Dim Currency As String = getInParamValue(InParam, 7)
            Dim DocNo As String = getInParamValue(InParam, 8)
            Dim RefType As String = getInParamValue(InParam, 9)
            Dim RefNo As String = getInParamValue(InParam, 10)
            Dim RefDate As String = getInParamValue(InParam, 11)     ' Formatted Date MM/DD/YYYY
            Dim Remarks As String = getInParamValue(InParam, 12)
            Dim Last_Opr As String = getInParamValue(InParam, 13)
            Dim Status As String = getInParamValue(InParam, 14)      ' Request / Approved / Cancelled
            Dim BankAccount As String = getInParamValue(InParam, 15)      ' CN/DN Bank Account Name
            Dim sNominal As String = getInParamValue(InParam, 16)      ' String Nominal
            Dim CT As String = getInParamValue(InParam, 17)
            Dim DueDate As String = getInParamValue(InParam, 18)     ' Formatted Date MM/DD/YYYY
            Dim sVoucher As String = getInParamValue(InParam, 19)     ' All/Not Yet Vouchered/Already Vouchered
            Dim CollNo As String = getInParamValue(InParam, 20)          ' Collection No
            Dim DocStatus As String = getInParamValue(InParam, 21)          ' Document Availability Status
            Dim InterBankF As Boolean = toval(getInParamValue(InParam, 22))

            Dim SQL As String
            SQL = "Select Cast(0 as bit) as ProcessFlag, R.Request, R.DebtorF, R.CreditorF, R.Voucher, R.Branch, R.RefNo, R.RefDate, R.DocNo, R.RefType, R.Date, "
            SQL = SQL & " R.AccountNo, R.BankAccount, R.BankName, R.DueDate, "
            SQL = SQL & " R.Vtype, VType.Description as VTypeDesc, R.SL_Cat, R.Status, "
            SQL = SQL & " R.Remarks, R.ProAcc, P.Description as PDescription, R.ComAcc, C.Description as CDescription, R.Currency, R.Nominal_CC-R.Diff_CC as Nominal, R.Last_Date, R.Last_Opr"
            SQL = SQL & " from Request R Inner Join fn_userVType('" & dbUser & "') VType on (VType.VType=R.VType) Left Join ProAcc P on (P.ProAcc=R.ProAcc) Left Join ComAcc C on (C.ComAcc=R.ComAcc) "
            SQL = SQL & " Where R.SL_Cat='P' and R.CreditorF=1"
            If Request <> "" Then
                SQL = SQL & " and R.Request Like '" & Request & "%'"
            End If
            If RequestSDate <> "" Or RequestEDate <> "" Then
                If RequestEDate = "" Then
                    SQL = SQL & " and R.Date='" & RequestSDate & "'"
                ElseIf RequestSDate = "" Then
                    SQL = SQL & " and R.Date='" & RequestEDate & "'"
                Else
                    SQL = SQL & " and R.Date Between '" & RequestSDate & "' and '" & RequestEDate & "'"
                End If
            End If
            If VType <> "" Then
                SQL = SQL & " and R.VType Like '" & VType & "%'"
            End If
            If Branch <> "" Then
                SQL = SQL & " and R.Branch Like '" & Branch & "%'"
            End If
            If ProAcc <> "" Then
                SQL = SQL & " and R.ProAcc Like '" & ProAcc & "%'"
            End If
            If ComAcc <> "" Then
                SQL = SQL & " and R.ComAcc Like '" & ComAcc & "%'"
            End If
            If Currency <> "" Then
                SQL = SQL & " and R.Currency Like '" & Currency & "%'"
            End If
            If DocNo <> "" Then
                SQL = SQL & " and R.DocNo Like '" & DocNo & "%'"
            End If
            If RefType <> "" Then
                SQL = SQL & " and R.RefType Like '" & RefType & "%'"
            End If
            If RefNo <> "" Then
                SQL = SQL & " and R.RefNo Like '" & RefNo & "%'"
            End If
            If RefDate <> "" Then
                SQL = SQL & " and R.RefDate='" & RefDate & "'"
            End If
            If Remarks <> "" Then
                SQL = SQL & " and R.Remarks Like '" & Remarks & "%'"
            End If
            If Last_Opr <> "" Then
                SQL = SQL & " and R.Last_Opr Like '" & Last_Opr & "%'"
            End If
            Select Case Status
                Case "R"
                    SQL = SQL & " and R.Status='R'"
                Case "V"
                    SQL = SQL & " and R.Status='V'"
                Case "P"
                    SQL = SQL & " and R.Status='P'"
                Case "C"
                    SQL = SQL & " and R.Status='C'"
            End Select

            If BankAccount <> "" And CollNo <> "" Then
                SQL = SQL & " and Exists (Select Top 1 SL.Request from SL_Request SL, nVoucher Voucher Where SL.Request=R.Request and SL.PaymentF=1 and Voucher.Voucher=SL.Doc_No and (Voucher.BankAccount Like '" & BankAccount & "%' and SL.pVoucher Like '" & CollNo & "%'))"
            ElseIf BankAccount <> "" Then
                SQL = SQL & " and Exists (Select Top 1 SL.Request from SL_Request SL, nVoucher Voucher Where SL.Request=R.Request and SL.PaymentF=1 and Voucher.Voucher=SL.Doc_No and (Voucher.BankAccount Like '" & BankAccount & "%'))"
            ElseIf CollNo <> "" Then
                SQL = SQL & " and Exists (Select Top 1 SL.Request from SL_Request SL, nVoucher Voucher Where SL.Request=R.Request and SL.PaymentF=1 and Voucher.Voucher=SL.Doc_No and (SL.pVoucher Like '" & CollNo & "%'))"
            End If
            If db.GetUserType <> "SUPERVISOR" Then
                SQL = SQL & " and Exists (Select S.Branch from SysUserBranch S Where S.Branch=R.Branch and S.ID='" & dbUser & "' and S.AllowedF=1)"
                SQL = SQL & " and (coalesce(R.CT,'')='' or Exists (Select S.CT from FN_UserCT('" & dbUser & "',R.Branch,'') S Where S.CT=R.CT))"
            End If
            If sNominal <> "" Then
                SQL = SQL & " and (round(R.Nominal_CC-R.Diff_CC,2)=" & tovalSF(Math.Round(toval(sNominal), 2, MidpointRounding.AwayFromZero)) & ")"
            End If
            If CT <> "" Then
                SQL = SQL & " and R.CT Like '" & CT & "%'"
            End If
            If DueDate <> "" Then
                SQL = SQL & " and R.DueDate='" & DueDate & "'"
            End If
            Select Case sVoucher
                Case "N"
                    SQL = SQL & " and R.Voucher=''"
                Case "V"
                    SQL = SQL & " and R.Voucher<>''"
            End Select
            Select Case DocStatus
                Case "N"    ' Not Completed
                    SQL = SQL & " and exists (Select DocType from DocType Where AllowedF=1 and Purpose='PAYMENT' and MandatoryF=1 and DocType not in (Select DocType from RDocList Where RDocList.AvailableF=1 and RDocList.Request=R.Request))"
                Case "P"    ' Completed
                    SQL = SQL & " and Not exists (Select DocType from DocType Where AllowedF=1 and Purpose='PAYMENT' and MandatoryF=1 and DocType not in (Select DocType from RDocList Where RDocList.AvailableF=1 and RDocList.Request=R.Request))"
            End Select

            If InterBankF Then
                SQL = SQL & " and VType.Code='INTERBANK'"
            End If
            SQL = SQL & " Order By R.Request"

            Dim rs As RemoteSet
            Dim C_MaxRecords As Long
            C_MaxRecords = toval(GetAppSetting("CareMaxRecords"))
            If toval(GetAppSetting("CareMaxRecords_FA")) > C_MaxRecords Then
                C_MaxRecords = toval(GetAppSetting("CareMaxRecords_FA"))
            End If
            rs = db.OpenRemoteSet(SQL, , , , C_MaxRecords)
            Dataset = rs.GetDataSet

            If Dataset Is Nothing Then Throw New Exception(ErrMsg)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SearchRequestR(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Request As String = getInParamValue(InParam, 0)
            Dim RequestSDate As String = getInParamValue(InParam, 1)    ' Formatted Date MM/DD/YYYY
            Dim RequestEDate As String = getInParamValue(InParam, 2)    ' Formatted Date MM/DD/YYYY
            Dim VType As String = getInParamValue(InParam, 3)
            Dim Branch As String = getInParamValue(InParam, 4)
            Dim ProAcc As String = getInParamValue(InParam, 5)
            Dim ComAcc As String = getInParamValue(InParam, 6)
            Dim Currency As String = getInParamValue(InParam, 7)
            Dim DocNo As String = getInParamValue(InParam, 8)
            Dim RefType As String = getInParamValue(InParam, 9)
            Dim RefNo As String = getInParamValue(InParam, 10)
            Dim RefDate As String = getInParamValue(InParam, 11)     ' Formatted Date MM/DD/YYYY
            Dim Remarks As String = getInParamValue(InParam, 12)
            Dim Last_Opr As String = getInParamValue(InParam, 13)
            Dim Status As String = getInParamValue(InParam, 14)      ' Request / Approved / Cancelled
            Dim sNominal As String = getInParamValue(InParam, 16)      ' String Nominal
            Dim CT As String = getInParamValue(InParam, 17)
            Dim DueDate As String = getInParamValue(InParam, 18)     ' Formatted Date MM/DD/YYYY
            Dim sVoucher As String = getInParamValue(InParam, 19)     ' All/Not Yet Vouchered/Already Vouchered

            Dim SQL As String
            SQL = "Select Cast(0 as bit) as ProcessFlag, R.Request, R.DebtorF, R.CreditorF, R.Voucher, R.Branch, R.RefNo, R.RefDate, R.DocNo, R.RefType, R.AccountNo, R.Date, R.DueDate, R.Vtype, VType.Description as VTypeDesc, R.SL_Cat, R.Status, "
            SQL = SQL & " R.Remarks, R.ProAcc, P.Description as PDescription, R.ComAcc, C.Description as CDescription, R.Currency, R.Nominal_CC-R.Diff_CC as Nominal, R.Last_Date, R.Last_Opr"
            SQL = SQL & " from Request R Inner Join fn_userVType('" & dbUser & "') VType on (VType.VType=R.VType) Left Join ProAcc P on (P.ProAcc=R.ProAcc) Left Join ComAcc C on (C.ComAcc=R.ComAcc) "
            SQL = SQL & " Where R.SL_Cat='P' and R.DebtorF=1"
            If Request <> "" Then
                SQL = SQL & " and R.Request Like '" & Request & "%'"
            End If
            If RequestSDate <> "" Or RequestEDate <> "" Then
                If RequestEDate = "" Then
                    SQL = SQL & " and R.Date='" & RequestSDate & "'"
                ElseIf RequestSDate = "" Then
                    SQL = SQL & " and R.Date='" & RequestEDate & "'"
                Else
                    SQL = SQL & " and R.Date Between '" & RequestSDate & "' and '" & RequestEDate & "'"
                End If
            End If
            If VType <> "" Then
                SQL = SQL & " and R.VType Like '" & VType & "%'"
            End If
            If Branch <> "" Then
                SQL = SQL & " and R.Branch Like '" & Branch & "%'"
            End If
            If ProAcc <> "" Then
                SQL = SQL & " and R.ProAcc Like '" & ProAcc & "%'"
            End If
            If ComAcc <> "" Then
                SQL = SQL & " and R.ComAcc Like '" & ComAcc & "%'"
            End If
            If Currency <> "" Then
                SQL = SQL & " and R.Currency Like '" & Currency & "%'"
            End If
            If DocNo <> "" Then
                SQL = SQL & " and R.DocNo Like '" & DocNo & "%'"
            End If
            If RefType <> "" Then
                SQL = SQL & " and R.RefType Like '" & RefType & "%'"
            End If
            If RefNo <> "" Then
                SQL = SQL & " and R.RefNo Like '" & RefNo & "%'"
            End If
            If RefDate <> "" Then
                SQL = SQL & " and R.RefDate='" & RefDate & "'"
            End If
            If Remarks <> "" Then
                SQL = SQL & " and R.Remarks Like '" & Remarks & "%'"
            End If
            If Last_Opr <> "" Then
                SQL = SQL & " and R.Last_Opr Like '" & Last_Opr & "%'"
            End If
            Select Case Status
                Case "R"
                    SQL = SQL & " and R.Status='R'"
                Case "V"
                    SQL = SQL & " and R.Status='V'"
                Case "P"
                    SQL = SQL & " and R.Status='P'"
                Case "C"
                    SQL = SQL & " and R.Status='C'"
            End Select
            If db.GetUserType <> "SUPERVISOR" Then
                SQL = SQL & " and Exists (Select S.Branch from SysUserBranch S Where S.Branch=R.Branch and S.ID='" & dbUser & "' and S.AllowedF=1)"
                SQL = SQL & " and (coalesce(R.CT,'')='' or Exists (Select S.CT from FN_UserCT('" & dbUser & "',R.Branch,'') S Where S.CT=R.CT))"
            End If
            If sNominal <> "" Then
                SQL = SQL & " and (round(R.Nominal_CC-R.Diff_CC,2)=" & tovalSF(Math.Round(toval(sNominal), 2, MidpointRounding.AwayFromZero)) & ")"
            End If
            If CT <> "" Then
                SQL = SQL & " and R.CT Like '" & CT & "%'"
            End If
            If DueDate <> "" Then
                SQL = SQL & " and R.DueDate='" & DueDate & "'"
            End If
            Select Case sVoucher
                Case "N"
                    SQL = SQL & " and R.Voucher=''"
                Case "V"
                    SQL = SQL & " and R.Voucher<>''"
            End Select
            SQL = SQL & " Order By R.Request"

            Dim rs As RemoteSet
            Dim C_MaxRecords As Long
            C_MaxRecords = toval(GetAppSetting("CareMaxRecords"))
            If toval(GetAppSetting("CareMaxRecords_FA")) > C_MaxRecords Then
                C_MaxRecords = toval(GetAppSetting("CareMaxRecords_FA"))
            End If
            rs = db.OpenRemoteSet(SQL, , , , C_MaxRecords)
            Dataset = rs.GetDataSet

            If Dataset Is Nothing Then Throw New Exception(ErrMsg)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    Private Function GetRequestP(ByVal InParam As Object(), ByRef findex As String(), ByRef fbuffer As String(), ByRef findex_Ext As String(), ByRef fbuffer_Ext As String(), ByRef Dataset As DataSet, ByRef DsDetail As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            ' Get Input Parameter
            Dim Request As String

            Request = getInParamValue(InParam, 0)
            Dim rs As RemoteSet

            rs = db.OpenRemoteSet("Select * from Request Where SL_Cat='P' and CreditorF=1 and Request='" & Request & "'")
            findex = rs.fields_index
            fbuffer = rs.GetRecord

            rs = db.OpenRemoteSet("Select * from RequestExt Where Request='" & Request & "'")
            findex_Ext = rs.fields_index
            fbuffer_Ext = rs.GetRecord

            rs = db.OpenRemoteSet("Select cast(0 as Int) as RecNo, Cast(0 as bit) as ProcessFlag, pSL.*, (Select Top 1 Admlink.ValueDesc from Admlink Where Admlink.Voucher=pSL.Doc_No and pSL.PaymentF=1) as Info, (Select Top 1 Admlink.A_PolicyNo from Admlink Where Admlink.Voucher=pSL.Doc_No and pSL.PaymentF=1) as A_PolicyNo, (Select Top 1 Admlink.DocNo from Admlink Where Admlink.Voucher=pSL.Doc_No and pSL.PaymentF=1) as A_DocNo, coalesce(nVoucher.BankName,'') as BankName, coalesce(nVoucher.BankAccount,'') as BankAccount, coalesce(nVoucher.AccountNo,'') as AccountNo from SL_Request pSL Left Join nVoucher on (nVoucher.Voucher=pSL.Doc_No and pSL.PaymentF=1) where pSL.Request='" & Request & "' Order By pSL.SortNo")
            Dataset = rs.GetDataSet

            rs = db.OpenRemoteSet("Select * from SL_RequestRef where SL_RequestRef.Request='" & Request & "'")
            DsDetail = rs.GetDataSet

            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function GetRequestP(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef findex As String(), ByRef fbuffer As String(), ByRef findex_Ext As String(), ByRef fbuffer_Ext As String(), ByRef Dataset As DataSet, ByRef DsDetail As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            If Not GetRequestP(InParam, findex, fbuffer, findex_Ext, fbuffer_Ext, Dataset, DsDetail, ErrMsg) Then
                Throw New Exception(ErrMsg)
            End If

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function GetRequestR(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef findex As String(), ByRef fbuffer As String(), ByRef Dataset As DataSet, ByRef DsDetail As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Request As String

            Request = getInParamValue(InParam, 0)
            Dim rs As RemoteSet

            rs = db.OpenRemoteSet("Select * from Request Where SL_Cat='P' and DebtorF=1 and Request='" & Request & "'")
            findex = rs.fields_index
            fbuffer = rs.GetRecord

            rs = db.OpenRemoteSet("Select cast(0 as Int) as RecNo, Cast(0 as bit) as ProcessFlag, pSL.*, (Select Top 1 Admlink.ValueDesc from Admlink Where Admlink.Voucher=pSL.Doc_No and pSL.PaymentF=1) as Info, (Select Top 1 Admlink.A_PolicyNo from Admlink Where Admlink.Voucher=pSL.Doc_No and pSL.PaymentF=1) as A_PolicyNo, (Select Top 1 Admlink.DocNo from Admlink Where Admlink.Voucher=pSL.Doc_No and pSL.PaymentF=1) as A_DocNo from SL_Request pSL where pSL.Request='" & Request & "' Order By pSL.SortNo")
            Dataset = rs.GetDataSet

            rs = db.OpenRemoteSet("Select * from SL_RequestRef where SL_RequestRef.Request='" & Request & "'")
            DsDetail = rs.GetDataSet

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function

    Private Function PreAddRequest(ByVal InParam As Object(), ByVal ProAcc As String, ByVal Currency As String, ByRef DocNo As String, ByRef Errmsg As String) As Boolean

        Dim rs As RemoteSet
        Dim br_End_Date As Date
        Dim br_Month As Integer
        Dim br_Year As Integer
        Dim FLockedDate As Date

        Dim Request As String
        Dim Branch As String
        Dim RequestDate As Date

        Request = getInParamValue(InParam, 0)
        Branch = getInParamValue(InParam, 1)
        RequestDate = getInParamValue(InParam, 2)
        'RefType = getInParamValue(InParam, 3)  

        On Error GoTo errmsg

        'rs = db.OpenRemoteSet("Select * from Branch where branch='" & Branch & "'")
        'If Not rs.Eof Then
        '    br_End_Date = todate(rs.fields("end_date"))
        '    br_Month = toval(rs.fields("Month"))
        '    br_Year = toval(rs.fields("year"))
        'End If

        'Not Apply for Receipt/Payment Request
        'If Not db.GetPrivileges("ALLOWLOCKEDPERIOD") Then
        '    FLockedDate = GetFLockedDate(Branch)
        '    If DateDiff(DateInterval.Day, FLockedDate, RequestDate) <= 0 Then
        '        Errmsg = "Transactions for this period have been closed, Check the Closing Date on " & FLockedDate
        '        GoTo errmsg
        '    End If
        'End If

        'If (DateDiff(DateInterval.Day, RequestDate, br_End_Date) = 0 And br_Month = Month(RequestDate) And br_Year = Year(RequestDate)) Or (DateDiff(DateInterval.Day, RequestDate, br_End_Date) > 0) Then
        '    Errmsg = "Backdated Transaction, Check the Ending Date on " & br_End_Date & " !"
        '    GoTo errmsg
        'End If

        rs = db.OpenRemoteSet("Select ProAcc, Description, Currency, RestrictedF from ProAcc where ProAcc='" & ProAcc & "'")
        If Not rs.Eof Then
            If toval(rs.fields("RestrictedF")) Then
                Errmsg = "Not Allowed for Restricted Profile Account-" & ProAcc & "-" & rs.fields("Description")
                Throw New Exception(Errmsg)
            End If

            If rs.fields("Currency") <> Currency Then
                Errmsg = "Not a Valid Profile Account-" & ProAcc & " for Voucher Currency-'" & Currency
                Throw New Exception(Errmsg)
            End If
        End If

        If DocNo <> "" Then
            If (Not (UCase(dbUserType) = "SUPERVISOR") AndAlso db.GetPrivileges("FORCECHECKREQUESTDOCNO")) Then
                rs = db.OpenRemoteSet("Select top 1 Request from Request Where Request<>'" & Request & "' and DocNo='" & DocNo & "'")
                If Not rs.Eof Then
                    Errmsg = "Duplicate Document No " & DocNo & " with Request No. " & rs.fields("Request")
                    Throw New Exception(Errmsg)
                End If
            End If
        End If

        Return True
errmsg:
        Errmsg = StrError(Errmsg)
        Return False
    End Function

    Private Function PreEditRequest(ByVal InParam As Object(), ByVal ProAcc As String, ByVal Currency As String, ByVal DocNo As String, ByRef ErrMsg As String) As Boolean
        Dim rs As RemoteSet
        Dim Request As String

        If Not PreAddRequest(InParam, ProAcc, Currency, DocNo, ErrMsg) Then GoTo errmsg

        Request = getInParamValue(InParam, 0)
        'Branch = getInParamValue(InParam, 1)
        'RequestDate = getInParamValue(InParam, 2)
        'RefType = getInParamValue(InParam, 3)    

        On Error GoTo errmsg

        rs = db.OpenRemoteSet("Select * from Request Where Request='" & Request & "'")
        If rs.Eof Then
            ErrMsg = "No Request Data !"
            GoTo errmsg
        End If

        If tostr(rs.fields("Voucher")) <> "" Then
            ErrMsg = "Already Transferred to Voucher Document No. : " & rs.fields("Voucher") & " !"
            GoTo errmsg
        ElseIf tostr(rs.fields("RefType")) = "PettyCash" Then
            ErrMsg = "Petty Cash Reimbursement !"
            GoTo errmsg
        ElseIf tostr(rs.fields("Status")) = "V" Then
            ErrMsg = "Already Verified !"
            GoTo errmsg
        ElseIf tostr(rs.fields("Status")) = "P" Then
            ErrMsg = "Already Approved !"
            GoTo errmsg
        ElseIf tostr(rs.fields("Status")) = "C" Then
            ErrMsg = "Already Cancelled !"
            GoTo errmsg
        End If

        If rs.fields("RequestF") And UCase(rs.fields("RequestName")) <> UCase(dbUser) Then
            ErrMsg = "Document is being sent to User-'" & rs.fields("RequestName") & "' !"
            GoTo errmsg
        End If

        Return True
errmsg:
        ErrMsg = StrError(ErrMsg)
        Return False
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SaveRequestExt(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByVal findex() As String, ByVal fbuffer() As String, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Request As String

            Request = getInParamValue(InParam, 0)

            Dim LockedKey As String = ""
            If Request <> "" Then
                LockedKey = Request
                If Not db.GetLockedObject("Request" & LockedKey) Then Throw New Exception(db.ErrDesc)
            End If

            Dim rsV As RemoteSet
            Dim EditMode As Integer
            rsV = db.OpenRemoteSet("Select * from RequestExt Where Request='" & Request & "'")
            If rsV.Eof Then
                rsV.AddNew()
            Else
                rsV.Edit()
            End If
            EditMode = rsV.editmode

            Dim i As Integer
            Dim j As Integer
            i = 0
            j = UBound(findex)
            Do While i < j
                rsV.fields(findex(i)) = GetFieldValue(fbuffer(i))
                i = i + 1
            Loop
            If EditMode = AdEditAdd Then
                rsV.fields("Request") = Request
            End If
            rsV.fields("Last_Date") = Today.Date
            rsV.fields("Last_Time") = Time()
            rsV.fields("Last_Opr") = dbUser
            If Not rsV.Update Then Throw New Exception(db.ErrDesc)

            If LockedKey <> "" Then If Not db.ReleaseLockedObject("Request" & LockedKey) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SaveRequestP(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal findex() As String, ByVal fbuffer() As String, ByVal findex_Ext() As String, ByVal fbuffer_Ext() As String, ByVal Dataset As DataSet, ByVal DsDetail As DataSet, ByRef ErrMsg As String) As Boolean
        Dim Request As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Branch As String
            Dim RequestDate As Date
            Dim RefType As String
            Dim DueDate As Date

            Request = getInParamValue(InParam, 0)
            Branch = getInParamValue(InParam, 1)
            RequestDate = getInParamValue(InParam, 2)
            RefType = getInParamValue(InParam, 3)            ' PettyCash
            DueDate = todate(getInParamValue(InParam, 4))    ' Due Date

            Dim LockedKey As String = ""
            If Request <> "" Then
                LockedKey = Request
                If Not db.GetLockedObject("Request" & LockedKey) Then Throw New Exception(db.ErrDesc)
            End If

            Dim rs As RemoteSet
            Dim br_Currency As String
            Dim br_Currency_1 As String
            Dim VType As String
            Dim ComAcc As String
            Dim AutoNum As String
            Dim CodeExt As String
            Dim Currency As String
            Dim Rate As Double
            Dim Rate_RC As Double
            Dim ProAcc As String
            Dim Remarks As String
            Dim Bank As String
            Dim BankBranch As String
            Dim DocNo As String

            Dim BudgetFeaturesF As Boolean
            rs = db.OpenRemoteSet("Select Currency, Currency_1, BudgetFeaturesF from SysTab")
            br_Currency = rs.fields("Currency")
            br_Currency_1 = rs.fields("Currency_1")
            BudgetFeaturesF = rs.fields("BudgetFeaturesF")

            VType = GetFieldValue(fbuffer(GetFieldIndex("VType", findex)))
            ComAcc = GetFieldValue(fbuffer(GetFieldIndex("ComAcc", findex)))
            Currency = GetFieldValue(fbuffer(GetFieldIndex("Currency", findex)))
            DocNo = GetFieldValue(fbuffer(GetFieldIndex("DocNo", findex)))

            Dim RefCCYDate As Date
            Dim CT As String
            RefCCYDate = todate(GetFieldValue(fbuffer(GetFieldIndex("RefCCYDate", findex))))

            Rate = exchange_rate(Currency, RefCCYDate, br_Currency)
            Rate_RC = exchange_rate_RC(Currency, RefCCYDate, br_Currency_1)

            ProAcc = GetFieldValue(fbuffer(GetFieldIndex("ProAcc", findex)))
            Remarks = GetFieldValue(fbuffer(GetFieldIndex("Remarks", findex)))
            CT = GetFieldValue(fbuffer(GetFieldIndex("CT", findex)))

            rs = db.OpenRemoteSet("select vType, SL_Cat, AutoNum, DebtorF, CreditorF, CodeExt from vType where SL_Cat='P' and CreditorF=1 and vtype = '" & VType & "'")
            AutoNum = tostr(rs.fields("AutoNum"))
            CodeExt = tostr(rs.fields("CodeExt"))

            rs = db.OpenRemoteSet("Select Bank, BankBranch from ProAcc Where ProAcc='" & ProAcc & "'")
            Bank = rs.fields("Bank")
            BankBranch = rs.fields("BankBranch")

            Dim rsV As RemoteSet
            Dim EditMode As Integer
            rsV = db.OpenRemoteSet("Select * from Request Where Request='" & Request & "'")
            If rsV.Eof Then
                If Not PreAddRequest(InParam, ProAcc, Currency, DocNo, ErrMsg) Then Throw New Exception(ErrMsg)

                If Request = "" Then
                    If CBool(toval(GetAppSetting("FARequestNoWithCT"))) Then
                        Request = db.GetNextDocNo("PQ", RequestDate, CT & "/" & Branch)
                    Else
                        Request = db.GetNextDocNo("PQ", RequestDate, Branch)
                    End If
                End If
                If Request = "" Then Throw New Exception("Generate Request Number Failed !")

                rsV.AddNew()
            Else
                If Not PreEditRequest(InParam, ProAcc, Currency, DocNo, ErrMsg) Then Throw New Exception(ErrMsg)

                If toval(GetFieldValue(fbuffer(GetFieldIndex("Nominal_CC", findex)))) - toval(GetFieldValue(fbuffer(GetFieldIndex("Diff_CC", findex)))) <> toval(rsV.fields("Nominal_CC")) - toval(rsV.fields("Diff_CC")) Then
                    If Not db.GetPrivileges("ALLOWCHANGEPAYMENT") Then
                        ErrMsg = "Not Allowed To Change Payment Amount !"
                        Throw New Exception(ErrMsg)
                    End If
                End If

                rsV.Edit()
            End If
            EditMode = rsV.editmode

            Dim i As Integer
            Dim j As Integer
            i = 0
            j = UBound(findex)
            Do While i < j
                rsV.fields(findex(i)) = GetFieldValue(fbuffer(i))
                i = i + 1
            Loop
            If Not db.GetPrivileges("ALLOWPASSSCANPAN") Then
                If isContainRestrictedPAN(rsV.fields("AccountNo")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field AccountNo!")
                End If
                If isContainRestrictedPAN(rsV.fields("REFNO")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field REFNO!")
                End If
                If isContainRestrictedPAN(rsV.fields("REMARKS")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field REMARKS!")
                End If
            End If
            If EditMode = AdEditAdd Then
                rsV.fields("Branch") = Branch
                rsV.fields("CDate") = Today.Date
                rsV.fields("CTime") = Time()
                rsV.fields("UserID") = dbUser
                rsV.fields("Request") = Request
                rsV.fields("RequestF") = False
                rsV.fields("RequestMessage") = ""
                rsV.fields("RequestName") = ""
                rsV.fields("VUserID") = ""
                rsV.fields("VUserDate") = ""
                rsV.fields("CUserID") = ""
                rsV.fields("CloseDate") = ""
                rsV.fields("AUserID") = ""
                rsV.fields("AUserDate") = ""
                rsV.fields("AUserID_Ext") = ""
                rsV.fields("AUserDate_Ext") = ""
                rsV.fields("VerifiedBy") = ""
                rsV.fields("OtorizedBy") = ""
                rsV.fields("Otorized2By") = ""
                rsV.fields("AcceptedBy") = ""
                rsV.fields("VerifiedByTitle") = ""
                rsV.fields("OtorizedByTitle") = ""
                rsV.fields("Otorized2ByTitle") = ""
            End If
            rsV.fields("Rate") = Rate
            rsV.fields("Rate_RC") = Rate_RC
            rsV.fields("CreditorF") = True
            rsV.fields("DebtorF") = False
            rsV.fields("SL_Cat") = "P"
            rsV.fields("Num_Doc") = 0
            rsV.fields("Bank") = Bank
            rsV.fields("BankBranch") = BankBranch
            rsV.fields("Last_Date") = Today.Date
            rsV.fields("Last_Time") = Time()
            rsV.fields("Last_Opr") = dbUser
            rsV.fields("Status") = "R"
            If Not rsV.Update Then Throw New Exception(db.ErrDesc)

            Dim rsI As RemoteSet
            rsI = db.OpenRemoteSet("Select * from RequestExt Where Request='" & Request & "'")
            If rsI.Eof Then
                rsI.AddNew()
            Else
                rsI.Edit()
            End If

            i = 0
            j = UBound(findex_Ext)
            Do While i < j
                rsI.fields(findex_Ext(i)) = GetFieldValue(fbuffer_Ext(i))
                i = i + 1
            Loop
            rsI.fields("Request") = Request
            rsI.fields("Last_Date") = Today.Date
            rsI.fields("Last_Time") = Time()
            rsI.fields("Last_Opr") = dbUser
            If Not rsI.Update Then Throw New Exception(db.ErrDesc)

            Dim TaxDeductionF As Boolean = False
            Const MaxCols = 19
            Dim Bufferdata(Dataset.Tables(0).Rows.Count - 1, MaxCols - 1) As Object
            For i = 0 To Dataset.Tables(0).Rows.Count - 1
                Bufferdata(i, 0) = tostr(Dataset.Tables(0).Rows(i)("Doc_No"))
                Bufferdata(i, 1) = todate(Dataset.Tables(0).Rows(i)("Doc_Date"))
                Bufferdata(i, 2) = tostr(Dataset.Tables(0).Rows(i)("Doc_CCY"))
                Bufferdata(i, 3) = RoundCCY(toval(Dataset.Tables(0).Rows(i)("Nominal_OC")), UCase(tostr(Dataset.Tables(0).Rows(i)("Doc_CCY"))), toval(GetAppSetting("FARoundingDecimalValue")))
                Bufferdata(i, 4) = tostr(Dataset.Tables(0).Rows(i)("CT"))
                Bufferdata(i, 5) = RoundCCY(toval(Dataset.Tables(0).Rows(i)("Nominal")), UCase(Currency), toval(GetAppSetting("FARoundingDecimalValue")))
                Bufferdata(i, 6) = tostr(Dataset.Tables(0).Rows(i)("Remarks"))
                Bufferdata(i, 7) = toval(Dataset.Tables(0).Rows(i)("Hint"))
                If toval(Dataset.Tables(0).Rows(i)("Hint")) = -14 Then
                    TaxDeductionF = True
                End If
                Bufferdata(i, 8) = IIf(toval(Dataset.Tables(0).Rows(i)("PaymentF")) = 0, False, True)
                Bufferdata(i, 9) = tostr(Dataset.Tables(0).Rows(i)("Account"))
                Bufferdata(i, 10) = toval(Dataset.Tables(0).Rows(i)("Nominator"))
                Bufferdata(i, 11) = toval(Dataset.Tables(0).Rows(i)("Denominator"))
                Bufferdata(i, 12) = tostr(Dataset.Tables(0).Rows(i)("Branch"))
                Bufferdata(i, 13) = tostr(Dataset.Tables(0).Rows(i)("pVoucher"))
                Bufferdata(i, 14) = toval(Dataset.Tables(0).Rows(i)("LockedF"))
                Bufferdata(i, 15) = toval(Dataset.Tables(0).Rows(i)("FundingF"))
                Bufferdata(i, 16) = tostr(Dataset.Tables(0).Rows(i)("GID"))
                Bufferdata(i, 17) = tostr(Dataset.Tables(0).Rows(i)("Description"))
                Bufferdata(i, 18) = tostr(Dataset.Tables(0).Rows(i)("ComAcc"))
            Next

            Dim Param(6) As Object
            Param(0) = Request
            Param(1) = RequestDate
            Param(2) = VType
            Param(3) = Currency
            Param(4) = False
            Param(5) = DueDate
            Param(6) = Branch

            Dim OParam As Object = Nothing

            Const MaxRows_2 = 100
            Const MaxCols_2 = 5
            Dim bufferdata_2(MaxRows_2 - 1, MaxCols_2 - 1) As Object

            If Not DsDetail Is Nothing Then
                For i = 0 To DsDetail.Tables(0).Rows.Count - 1
                    bufferdata_2(i, 0) = tostr(DsDetail.Tables(0).Rows(i)("RefDate"))
                    bufferdata_2(i, 1) = tostr(DsDetail.Tables(0).Rows(i)("Description"))
                    bufferdata_2(i, 2) = toval(DsDetail.Tables(0).Rows(i)("Nominal"))
                    bufferdata_2(i, 3) = tostr(DsDetail.Tables(0).Rows(i)("RefNo"))
                    bufferdata_2(i, 4) = tostr(DsDetail.Tables(0).Rows(i)("RefType"))
                Next
            End If

            OParam = Me.Direct_Call_Process_Execute("ProcessFAExt.NetV3.Proclib", "SAVE_DETAIL_REQUEST", Param, TrimBuffer(Bufferdata), TrimBuffer(bufferdata_2))
            If TypeName(OParam) <> "Object()" Then Throw New Exception(Me.ErrDesc)

            ' see fields to buffer for converting date field
            ' Refreshing Data
            rsV.Edit()
            rsV.fields("Num_Doc") = toval(OParam(0))
            rsV.fields("Payment_CC") = toval(OParam(1))
            rsV.fields("nPayment") = toval(OParam(2))
            rsV.fields("Nominal_CC") = toval(OParam(3))
            rsV.fields("Diff_CC") = toval(OParam(4))
            rsV.fields("Nominal") = toval(OParam(3)) * Rate
            rsV.fields("Diff") = toval(OParam(4)) * Rate


            Dim TotalAmount As Double
            Dim Status As String
            TotalAmount = rsV.fields("Nominal") - rsV.fields("Diff")
            If (Not db.GetPrivileges("ALLOWPASSDOCMANDATORY") AndAlso Not CheckPaymentMandatoryDocument(Request)) OrElse (Not GetApprovalLimitFA(dbUser, VType, "Out", TotalAmount)) OrElse (Not db.GetPrivileges("ALLOWPAYMENTREQUEST")) Then
                Status = "R"    ' Not Approved
            Else
                Status = "P"    ' Ok Approved
            End If
            rsV.fields("Status") = Status
            If Status = "P" Then
                rsV.fields("AUserID") = dbUser
                rsV.fields("AUserDate") = Today.Date
                rsV.fields("AUserID_Ext") = dbUser
                rsV.fields("AUserDate_Ext") = Today.Date
            End If
            If Not rsV.Update Then Throw New Exception(db.ErrDesc)

            If RefType = "PettyCash" Then
                If Not db.Execute("Update PCSummary Set Request='" & Request & "' from PCSummary, SL_Request Where PCSummary.PCSummary=SL_Request.Doc_No and SL_Request.Request='" & Request & "'") Then Throw New Exception(db.ErrDesc)
            End If

            If Status = "P" OrElse CBool(toval(GetAppSetting("CheckRequestBudgetOnSaveF"))) Then
                If BudgetFeaturesF Then
                    If Not db.GetPrivileges("ALLOWPASSCHECKBUDGET") Then
                        If Not Check_Request_Budget_Account(Request) Then Throw New Exception("Check Budget Account Failed !" & StrMsg)
                    End If
                End If
            End If

            If Not TaxDeductionF AndAlso CBool(toval(GetAppSetting("CheckTaxDeductionF"))) Then
                Dim SQL As String
                SQL = "Select sum(Admlink.PNominal_Tax/Admlink.Amount*pSL.Nominal*TaxType.TaxRate/100) as TaxNominal"
                SQL = SQL & " from Admlink, nVoucher, SL_Request pSL, Request, Profile, TaxType, MParam"
                SQL = SQL & " Where MParam.Type=Admlink.Type and Admlink.Voucher=nVoucher.Voucher and Admlink.Amount_14=0 and nVoucher.TaxF=1 and nVoucher.Voucher=pSL.Doc_No and pSL.PaymentF=1 and Request.Request=pSL.Request and Request.Request='" & Request & "'"
                SQL = SQL & " and Profile.ID=Admlink.ID and TaxType.TaxType=dbo.Get_TaxType(Profile.TaxType,Profile.ID,Request.Date, '',0, MParam.TaxDiscount) "
                SQL = SQL & " and not ('" & Format(RequestDate, "MM/DD/YYYY") & "' Between coalesce(Profile.TaxHSDate,'01/01/1900') and coalesce(Profile.TaxHEDate,'01/01/1900'))"
                rs = db.OpenRemoteSet(SQL)
                If Math.Round(toval(rs.fields("TaxNominal")), 4, MidpointRounding.AwayFromZero) <> 0 Then
                    Throw New Exception("Tax not yet Deducted !")
                End If
            End If

            ' Set Output Parameter
            ReDim OutParam(7)
            OutParam(0) = Request
            OutParam(1) = toval(OParam(0))          ' Num_Doc
            OutParam(2) = toval(OParam(1))          ' Payment_CC
            OutParam(3) = toval(OParam(2))          ' nPayment
            OutParam(4) = toval(OParam(3))          ' Nominal_CC
            OutParam(5) = toval(OParam(4))          ' Diff_CC
            OutParam(6) = toval(OParam(3)) * Rate   ' Nominal
            OutParam(7) = toval(OParam(4)) * Rate   ' Diff

            If LockedKey <> "" Then If Not db.ReleaseLockedObject("Request" & LockedKey) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ' Set Output Parameter
            ReDim OutParam(0)
            OutParam(0) = Request

            ErrMsg = ex.Message
            FANotes(Request, "Payment Request", "Save : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SaveRequestR(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal findex() As String, ByVal fbuffer() As String, ByVal Dataset As DataSet, ByVal DsDetail As DataSet, ByRef ErrMsg As String) As Boolean
        Dim Request As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Branch As String
            Dim RequestDate As Date
            Dim RefType As String
            Dim DueDate As Date

            Request = getInParamValue(InParam, 0)
            Branch = getInParamValue(InParam, 1)
            RequestDate = getInParamValue(InParam, 2)
            RefType = getInParamValue(InParam, 3)           ' PettyCash
            DueDate = todate(getInParamValue(InParam, 4))   ' DueDate

            Dim LockedKey As String = ""
            If Request <> "" Then
                LockedKey = Request
                If Not db.GetLockedObject("Request" & LockedKey) Then Throw New Exception(db.ErrDesc)
            End If

            Dim rs As RemoteSet
            Dim br_Currency As String
            Dim br_Currency_1 As String
            Dim VType As String
            Dim ComAcc As String
            Dim AutoNum As String
            Dim CodeExt As String
            Dim Currency As String
            Dim Rate As Double
            Dim Rate_RC As Double
            Dim ProAcc As String
            Dim Remarks As String
            Dim Bank As String
            Dim BankBranch As String
            Dim DocNo As String

            Dim BudgetFeaturesF As Boolean
            rs = db.OpenRemoteSet("Select Currency, Currency_1, BudgetFeaturesF from SysTab")
            br_Currency = rs.fields("Currency")
            br_Currency_1 = rs.fields("Currency_1")
            BudgetFeaturesF = rs.fields("BudgetFeaturesF")

            VType = GetFieldValue(fbuffer(GetFieldIndex("VType", findex)))
            ComAcc = GetFieldValue(fbuffer(GetFieldIndex("ComAcc", findex)))
            Currency = GetFieldValue(fbuffer(GetFieldIndex("Currency", findex)))
            DocNo = GetFieldValue(fbuffer(GetFieldIndex("DocNo", findex)))

            Dim RefCCYDate As Date
            Dim CT As String
            RefCCYDate = todate(GetFieldValue(fbuffer(GetFieldIndex("RefCCYDate", findex))))

            Rate = exchange_rate(Currency, RefCCYDate, br_Currency)
            Rate_RC = exchange_rate_RC(Currency, RefCCYDate, br_Currency_1)

            ProAcc = GetFieldValue(fbuffer(GetFieldIndex("ProAcc", findex)))
            Remarks = GetFieldValue(fbuffer(GetFieldIndex("Remarks", findex)))
            CT = GetFieldValue(fbuffer(GetFieldIndex("CT", findex)))

            rs = db.OpenRemoteSet("select vType, SL_Cat, AutoNum, DebtorF, CreditorF, CodeExt from vType where SL_Cat='P' and DebtorF=1 and vtype = '" & VType & "'")
            AutoNum = tostr(rs.fields("AutoNum"))
            CodeExt = tostr(rs.fields("CodeExt"))

            rs = db.OpenRemoteSet("Select Bank, BankBranch from ProAcc Where ProAcc='" & ProAcc & "'")
            Bank = rs.fields("Bank")
            BankBranch = rs.fields("BankBranch")

            Dim rsV As RemoteSet
            Dim EditMode As Integer
            rsV = db.OpenRemoteSet("Select * from Request Where Request='" & Request & "'")
            If rsV.Eof Then
                If Not PreAddRequest(InParam, ProAcc, Currency, DocNo, ErrMsg) Then Throw New Exception(ErrMsg)

                If Request = "" Then
                    If CBool(toval(GetAppSetting("FARequestNoWithCT"))) Then
                        Request = db.GetNextDocNo("RQ", RequestDate, CT & "/" & Branch)
                    Else
                        Request = db.GetNextDocNo("RQ", RequestDate, Branch)
                    End If
                End If

                If Request = "" Then Throw New Exception("Generate Request Number Failed !")

                rsV.AddNew()
            Else
                If Not PreEditRequest(InParam, ProAcc, Currency, DocNo, ErrMsg) Then Throw New Exception(ErrMsg)

                If toval(GetFieldValue(fbuffer(GetFieldIndex("Nominal_CC", findex)))) - toval(GetFieldValue(fbuffer(GetFieldIndex("Diff_CC", findex)))) <> toval(rsV.fields("Nominal_CC")) - toval(rsV.fields("Diff_CC")) Then
                    If Not db.GetPrivileges("ALLOWCHANGERECEIPT") Then
                        ErrMsg = "Not Allowed To Change Receipt Amount !"
                        Throw New Exception(ErrMsg)
                    End If
                End If

                rsV.Edit()
            End If
            EditMode = rsV.editmode

            Dim i As Integer
            Dim j As Integer
            i = 0
            j = UBound(findex)
            Do While i < j
                rsV.fields(findex(i)) = GetFieldValue(fbuffer(i))
                i = i + 1
            Loop
            If Not db.GetPrivileges("ALLOWPASSSCANPAN") Then
                If isContainRestrictedPAN(rsV.fields("AccountNo")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field AccountNo!")
                End If
                If isContainRestrictedPAN(rsV.fields("REFNO")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field REFNO!")
                End If
                If isContainRestrictedPAN(rsV.fields("REMARKS")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field REMARKS!")
                End If
            End If
            If EditMode = AdEditAdd Then
                rsV.fields("Branch") = Branch
                rsV.fields("CDate") = Today.Date
                rsV.fields("CTime") = Time()
                rsV.fields("UserID") = dbUser
                rsV.fields("Request") = Request
                rsV.fields("RequestF") = False
                rsV.fields("RequestMessage") = ""
                rsV.fields("RequestName") = ""
                rsV.fields("VUserID") = ""
                rsV.fields("VUserDate") = ""
                rsV.fields("CUserID") = ""
                rsV.fields("CloseDate") = ""
                rsV.fields("AUserID") = ""
                rsV.fields("AUserDate") = ""
                rsV.fields("AUserID_Ext") = ""
                rsV.fields("AUserDate_Ext") = ""
                rsV.fields("VerifiedBy") = ""
                rsV.fields("OtorizedBy") = ""
                rsV.fields("Otorized2By") = ""
                rsV.fields("AcceptedBy") = ""
                rsV.fields("VerifiedByTitle") = ""
                rsV.fields("OtorizedByTitle") = ""
                rsV.fields("Otorized2ByTitle") = ""
            End If
            rsV.fields("Rate") = Rate
            rsV.fields("Rate_RC") = Rate_RC
            rsV.fields("CreditorF") = False
            rsV.fields("DebtorF") = True
            rsV.fields("SL_Cat") = "P"
            rsV.fields("Num_Doc") = 0
            rsV.fields("Bank") = Bank
            rsV.fields("BankBranch") = BankBranch
            rsV.fields("Last_Date") = Today.Date
            rsV.fields("Last_Time") = Time()
            rsV.fields("Last_Opr") = dbUser
            rsV.fields("Status") = "R"
            If Not rsV.Update Then Throw New Exception(db.ErrDesc)

            Dim TaxDeductionF As Boolean = False
            Const MaxCols = 19
            Dim Bufferdata(Dataset.Tables(0).Rows.Count - 1, MaxCols - 1) As Object
            For i = 0 To Dataset.Tables(0).Rows.Count - 1
                Bufferdata(i, 0) = tostr(Dataset.Tables(0).Rows(i)("Doc_No"))
                Bufferdata(i, 1) = todate(Dataset.Tables(0).Rows(i)("Doc_Date"))
                Bufferdata(i, 2) = tostr(Dataset.Tables(0).Rows(i)("Doc_CCY"))
                Bufferdata(i, 3) = RoundCCY(toval(Dataset.Tables(0).Rows(i)("Nominal_OC")), UCase(tostr(Dataset.Tables(0).Rows(i)("Doc_CCY"))), toval(GetAppSetting("FARoundingDecimalValue")))
                Bufferdata(i, 4) = tostr(Dataset.Tables(0).Rows(i)("CT"))
                Bufferdata(i, 5) = RoundCCY(toval(Dataset.Tables(0).Rows(i)("Nominal")), UCase(Currency), toval(GetAppSetting("FARoundingDecimalValue")))
                Bufferdata(i, 6) = tostr(Dataset.Tables(0).Rows(i)("Remarks"))
                Bufferdata(i, 7) = toval(Dataset.Tables(0).Rows(i)("Hint"))
                If toval(Dataset.Tables(0).Rows(i)("Hint")) = -14 Then
                    TaxDeductionF = True
                End If
                Bufferdata(i, 8) = IIf(toval(Dataset.Tables(0).Rows(i)("PaymentF")) = 0, False, True)
                Bufferdata(i, 9) = tostr(Dataset.Tables(0).Rows(i)("Account"))
                Bufferdata(i, 10) = toval(Dataset.Tables(0).Rows(i)("Nominator"))
                Bufferdata(i, 11) = toval(Dataset.Tables(0).Rows(i)("Denominator"))
                Bufferdata(i, 12) = tostr(Dataset.Tables(0).Rows(i)("Branch"))
                Bufferdata(i, 13) = tostr(Dataset.Tables(0).Rows(i)("pVoucher"))
                Bufferdata(i, 14) = toval(Dataset.Tables(0).Rows(i)("LockedF"))
                Bufferdata(i, 15) = toval(Dataset.Tables(0).Rows(i)("FundingF"))
                Bufferdata(i, 16) = tostr(Dataset.Tables(0).Rows(i)("GID"))
                Bufferdata(i, 17) = tostr(Dataset.Tables(0).Rows(i)("Description"))
                Bufferdata(i, 18) = tostr(Dataset.Tables(0).Rows(i)("ComAcc"))
            Next

            Dim Param(6) As Object
            Param(0) = Request
            Param(1) = RequestDate
            Param(2) = VType
            Param(3) = Currency
            Param(4) = True
            Param(5) = DueDate
            Param(6) = Branch

            Dim OParam As Object = Nothing

            Const MaxRows_2 = 100
            Const MaxCols_2 = 5
            Dim bufferdata_2(MaxRows_2 - 1, MaxCols_2 - 1) As Object

            If Not DsDetail Is Nothing Then
                For i = 0 To DsDetail.Tables(0).Rows.Count - 1
                    bufferdata_2(i, 0) = tostr(DsDetail.Tables(0).Rows(i)("RefDate"))
                    bufferdata_2(i, 1) = tostr(DsDetail.Tables(0).Rows(i)("Description"))
                    bufferdata_2(i, 2) = toval(DsDetail.Tables(0).Rows(i)("Nominal"))
                    bufferdata_2(i, 3) = tostr(DsDetail.Tables(0).Rows(i)("RefNo"))
                    bufferdata_2(i, 4) = tostr(DsDetail.Tables(0).Rows(i)("RefType"))
                Next
            End If

            OParam = Me.Direct_Call_Process_Execute("ProcessFAExt.NetV3.Proclib", "SAVE_DETAIL_REQUEST", Param, TrimBuffer(Bufferdata), TrimBuffer(bufferdata_2))
            If TypeName(OParam) <> "Object()" Then Throw New Exception(Me.ErrDesc)

            ' see fields to buffer for converting date field
            ' Refreshing Data
            rsV.Edit()
            rsV.fields("Num_Doc") = toval(OParam(0))
            rsV.fields("Payment_CC") = toval(OParam(1))
            rsV.fields("nPayment") = toval(OParam(2))
            rsV.fields("Nominal_CC") = toval(OParam(3))
            rsV.fields("Diff_CC") = toval(OParam(4))
            rsV.fields("Nominal") = toval(OParam(3)) * Rate
            rsV.fields("Diff") = toval(OParam(4)) * Rate

            Dim TotalAmount As Double
            Dim Status As String
            TotalAmount = rsV.fields("Nominal") - rsV.fields("Diff")

            If (Not db.GetPrivileges("ALLOWPASSDOCMANDATORY") AndAlso Not CheckReceiptMandatoryDocument(Request)) OrElse (Not GetApprovalLimitFA(dbUser, VType, "In", TotalAmount)) OrElse (Not db.GetPrivileges("ALLOWRECEIPTREQUEST")) Then
                Status = "R"    ' Not Approved
            Else
                Status = "P"    ' Ok Approved
            End If
            rsV.fields("Status") = Status
            If Status = "P" Then
                rsV.fields("AUserID") = dbUser
                rsV.fields("AUserDate") = Today.Date
                rsV.fields("AUserID_Ext") = dbUser
                rsV.fields("AUserDate_Ext") = Today.Date
            End If

            If Not rsV.Update Then Throw New Exception(db.ErrDesc)

            If RefType = "PettyCash" Then
                If Not db.Execute("Update PCSummary Set Request='" & Request & "' from PCSummary, SL_Request Where PCSummary.PCSummary=SL_Request.Doc_No and SL_Request.Request='" & Request & "'") Then Throw New Exception(db.ErrDesc)
            End If

            If Status = "P" OrElse CBool(toval(GetAppSetting("CheckRequestBudgetOnSaveF"))) Then
                If BudgetFeaturesF Then
                    If Not db.GetPrivileges("ALLOWPASSCHECKBUDGET") Then
                        If Not Check_Request_Budget_Account(Request) Then Throw New Exception("Check Budget Account Failed !" & StrMsg)
                    End If
                End If
            End If

            If Not TaxDeductionF AndAlso CBool(toval(GetAppSetting("CheckTaxDeductionF"))) Then
                Dim SQL As String
                SQL = "Select sum(Admlink.PNominal_Tax/Admlink.Amount*pSL.Nominal*TaxType.TaxRate/100) as TaxNominal"
                SQL = SQL & " from Admlink, nVoucher, SL_Request pSL, Request, Profile, TaxType, MParam"
                SQL = SQL & " Where MParam.Type=Admlink.Type and Admlink.Voucher=nVoucher.Voucher and Admlink.Amount_14=0 and nVoucher.TaxF=1 and nVoucher.Voucher=pSL.Doc_No and pSL.PaymentF=1 and Request.Request=pSL.Request and Request.Request='" & Request & "'"
                SQL = SQL & " and Profile.ID=Admlink.ID and TaxType.TaxType=dbo.Get_TaxType(Profile.TaxType,Profile.ID,Request.Date, '',0, MParam.TaxDiscount) "
                SQL = SQL & " and not ('" & Format(RequestDate, "MM/DD/YYYY") & "' Between coalesce(Profile.TaxHSDate,'01/01/1900') and coalesce(Profile.TaxHEDate,'01/01/1900'))"
                rs = db.OpenRemoteSet(SQL)
                If Math.Round(toval(rs.fields("TaxNominal")), 4, MidpointRounding.AwayFromZero) <> 0 Then
                    Throw New Exception("Tax not yet Deducted !")
                End If
            End If

            ' Set Output Parameter
            ReDim OutParam(7)
            OutParam(0) = Request
            OutParam(1) = toval(OParam(0))          ' Num_Doc
            OutParam(2) = toval(OParam(1))          ' Payment_CC
            OutParam(3) = toval(OParam(2))          ' nPayment
            OutParam(4) = toval(OParam(3))          ' Nominal_CC
            OutParam(5) = toval(OParam(4))          ' Diff_CC
            OutParam(6) = toval(OParam(3)) * Rate   ' Nominal
            OutParam(7) = toval(OParam(4)) * Rate   ' Diff

            If LockedKey <> "" Then If Not db.ReleaseLockedObject("Request" & LockedKey) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ' Set Output Parameter
            ReDim OutParam(0)
            OutParam(0) = Request

            ErrMsg = ex.Message
            FANotes(Request, "Receipt Request", "Save : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function DropRequestP(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Request As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter

            Request = getInParamValue(InParam, 0)
            'Branch = getInParamValue(InParam, 1)
            'RequestDate = getInParamValue(InParam, 2)

            If Not db.GetLockedObject("Request" & Request) Then Throw New Exception(db.ErrDesc)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from Request Where SL_Cat='P' and CreditorF=1 and Request='" & Request & "'")
            If rs.Eof Then
                ErrMsg = "No Payment Request Data !"
                Throw New Exception(ErrMsg)
            End If

            If Not PreEditRequest(InParam, rs.fields("ProAcc"), rs.fields("Currency"), "", ErrMsg) Then Throw New Exception(ErrMsg)

            If Not Save_Log_Object("Request", "Request", Request, "ProAcc", rs.fields("ProAcc"), "ComAcc", rs.fields("ComAcc"), "Remarks", rs.fields("Remarks"), "", "", "", "Delete") Then Throw New Exception("Can't Save to Log !")

            If rs.fields("RefType") = "PettyCash" Then
                If Not db.Execute("Update PCSummary Set Request='' from PCSummary Where Request='" & Request & "'") Then Throw New Exception(db.ErrDesc)
            End If

            If Not rs.Delete Then Throw New Exception(db.ErrDesc)

            If Not db.Execute("Update SysRequest Set Status='P',LUserID='" & dbUser & "', LUserDate='" & Format(Today.Date, "MM/DD/YYYY") & "',LUserTime='" & Time() & "' from SysRequest Where Status<>'P' and Param1='SEND' and Param2 in ('RQ') and Param6='" & Request & "'") Then Throw New Exception(ErrMsg)

            If Not db.ReleaseLockedObject("Request" & Request) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Request, "Payment Request", "Drop : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function DropRequestR(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Request As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter

            Request = getInParamValue(InParam, 0)
            'Branch = getInParamValue(InParam, 1)
            'RequestDate = getInParamValue(InParam, 2)

            If Not db.GetLockedObject("Request" & Request) Then Throw New Exception(db.ErrDesc)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from Request Where SL_Cat='P' and DebtorF=1 and Request='" & Request & "'")
            If rs.Eof Then
                ErrMsg = "No Receipt Request Data !"
                Throw New Exception(ErrMsg)
            End If

            If Not PreEditRequest(InParam, rs.fields("ProAcc"), rs.fields("Currency"), "", ErrMsg) Then Throw New Exception(ErrMsg)

            If Not Save_Log_Object("Request", "Request", Request, "ProAcc", rs.fields("ProAcc"), "ComAcc", rs.fields("ComAcc"), "Remarks", rs.fields("Remarks"), "", "", "", "Delete") Then Throw New Exception("Can't Save to Log !")

            If rs.fields("RefType") = "PettyCash" Then
                If Not db.Execute("Update PCSummary Set Request='' from PCSummary Where Request='" & Request & "'") Then Throw New Exception(db.ErrDesc)
            End If

            If Not rs.Delete Then Throw New Exception(db.ErrDesc)

            If Not db.Execute("Update SysRequest Set Status='P',LUserID='" & dbUser & "', LUserDate='" & Format(Today.Date, "MM/DD/YYYY") & "',LUserTime='" & Time() & "' from SysRequest Where Status<>'P' and Param1='SEND' and Param2 in ('RQ') and Param6='" & Request & "'") Then Throw New Exception(ErrMsg)

            If Not db.ReleaseLockedObject("Request" & Request) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Request, "Receipt Request", "Drop : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function CloseRequestP(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Request As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Request = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from Request Where CreditorF=1 and Request='" & Request & "'")
            If rs.Eof Then
                ErrMsg = "No Request Data !"
                Throw New Exception(ErrMsg)
            ElseIf tostr(rs.fields("Status")) = "P" Then
                ErrMsg = "Already Approved !"
                Throw New Exception(ErrMsg)
            ElseIf tostr(rs.fields("Status")) = "C" Then
                ErrMsg = "Already Cancelled !"
                Throw New Exception(ErrMsg)
            End If
            If Not db.Execute("Update Request Set CloseDate='" & Format(Today.Date, "MM/DD/YYYY") & "', CUserID='" & dbUser & "', Status='C' Where Status='R' and Request='" & Request & "'") Then Throw New Exception(db.ErrDesc)
            If db.RecordsAffected = 0 Then
                ErrMsg = "Payment Request Already Processed !"
                Throw New Exception(ErrMsg)
            End If

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Request, "Payment Request", "Close/Decline : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function CloseRequestR(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Request As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Request = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from Request Where DebtorF=1 and Request='" & Request & "'")
            If rs.Eof Then
                ErrMsg = "No Request Data !"
                Throw New Exception(ErrMsg)
            ElseIf tostr(rs.fields("Status")) = "P" Then
                ErrMsg = "Already Approved !"
                Throw New Exception(ErrMsg)
            ElseIf tostr(rs.fields("Status")) = "C" Then
                ErrMsg = "Already Cancelled !"
                Throw New Exception(ErrMsg)
            End If
            If Not db.Execute("Update Request Set CloseDate='" & Format(Today.Date, "MM/DD/YYYY") & "', CUserID='" & dbUser & "', Status='C' Where Status='R' and Request='" & Request & "'") Then Throw New Exception(db.ErrDesc)
            If db.RecordsAffected = 0 Then
                ErrMsg = "Receipt Request Already Processed !"
                Throw New Exception(ErrMsg)
            End If

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Request, "Receipt Request", "Close/Decline : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SearchDocument(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String = getInParamValue(InParam, 0)      ' Source Voucher
            Dim VoucherDate As String = getInParamValue(InParam, 1)  ' Formatted Date MM/DD/YYYY
            Dim VType As String = getInParamValue(InParam, 2)        ' Source Voucher Type
            Dim sSL_Cat As String = getInParamValue(InParam, 3)      ' Source SL_Cat
            Dim SL_Cat As String = getInParamValue(InParam, 4)       ' Search SL_Cat
            Dim ProAcc As String = getInParamValue(InParam, 5)
            Dim Currency As String = getInParamValue(InParam, 6)
            Dim Remarks As String = getInParamValue(InParam, 7)
            Dim SDate As String = getInParamValue(InParam, 8)    ' Formatted Date MM/DD/YYYY
            Dim EDate As String = getInParamValue(InParam, 9)    ' Formatted Date MM/DD/YYYY
            Dim sRefNo As String = getInParamValue(InParam, 10)
            Dim lRefNo As String = getInParamValue(InParam, 11)
            Dim sDocNo As String = getInParamValue(InParam, 12)
            Dim lDocNo As String = getInParamValue(InParam, 13)
            Dim sODocNo As String = getInParamValue(InParam, 14)
            Dim lODocNo As String = getInParamValue(InParam, 15)
            Dim sVoucher As String = getInParamValue(InParam, 16)
            Dim lVoucher As String = getInParamValue(InParam, 17)
            Dim sAccountNo As String = getInParamValue(InParam, 18)
            Dim lAccountNo As String = getInParamValue(InParam, 19)
            Dim RefType As String = getInParamValue(InParam, 20)
            Dim BatchNo As String = getInParamValue(InParam, 21)
            Dim TypeList As String = getInParamValue(InParam, 22)
            Dim RefID As String = getInParamValue(InParam, 23)
            Dim Source As String = getInParamValue(InParam, 24)
            Dim sRefID As String = getInParamValue(InParam, 25)
            Dim Branch As String = getInParamValue(InParam, 26)
            Dim CollNo As String = getInParamValue(InParam, 27)
            Dim pVoucher As String = getInParamValue(InParam, 28)        ' Payment Voucher of Adjustment When sSL_Cat='A'
            Dim InCollectionF As Boolean = getInParamValue(InParam, 29)
            Dim InRequestF As Boolean = getInParamValue(InParam, 30)
            Dim Account As String = getInParamValue(InParam, 31)
            Dim sCollDate As String = getInParamValue(InParam, 32)
            Dim eCollDate As String = getInParamValue(InParam, 33)
            Dim OrderBy As String = getInParamValue(InParam, 34)
            Dim PaidOptionF As Boolean = toval(getInParamValue(InParam, 35))
            Dim PairOptionF As Boolean = toval(getInParamValue(InParam, 36))
            Dim DebtorF As Boolean = toval(getInParamValue(InParam, 37))
            Dim ComAcc As String = getInParamValue(InParam, 38)
            Dim RefCCYDate As String = getInParamValue(InParam, 39)  ' Reference Currency Date, Formatted Date MM/DD/YYYY
            Dim ASource As String = getInParamValue(InParam, 40)  ' Application Source
            Dim CGroup As String = getInParamValue(InParam, 41)  ' Company Group
            Dim PolicyCompensation As String = tostr(getInParamValue(InParam, 42))
            Dim ExcludeTaxF As Boolean = toval(getInParamValue(InParam, 43))
            Dim FundingF As Boolean = toval(getInParamValue(InParam, 44))
            Dim Insured As String = tostr(getInParamValue(InParam, 45))
            Dim Extras As String = tostr(getInParamValue(InParam, 46))

            If FundingF Then PaidOptionF = False

            Dim CheckPaymentPCTF As Boolean = False
            Dim sfilter As String = ""
            Dim sJoin As String = ""
            Dim SQL As String = ""

            Dim UDF As String = ""
            Dim sInstallmentInfo As String = ""
            If ExcludeTaxF Then
                UDF = "VOUCHER_AMOUNTDUE_EXTAX"
            Else
                UDF = "VOUCHER_AMOUNTDUE"
            End If

            sInstallmentInfo = GetAppSetting("sInstallmentInfo")
            If sInstallmentInfo = "" Then sInstallmentInfo = "sInstallment"

            ' Profile ID Except for Business Source
            If ProAcc <> "" Then
                sfilter = sfilter & " and (ProAcc.ID Like '" & ProAcc & "%' or ProAcc.Description Like '" & ProAcc & "%')"
            End If

            If Not PairOptionF Then
                sfilter = sfilter & Const_Additional_Filter(InParam, "A1", "A2")
            Else
                sJoin = Const_Additional_Filter(InParam, "A5", "A5")
                If sJoin <> "" Then
                    sJoin = " Inner Join (Select Distinct A5.A_PolicyNo from Admlink A5 Where 1=1 " & sJoin & ") A5 ON (A5.A_POLICYNO=A2.A_POLICYNO)"
                End If
            End If

            If db.GetUserType <> "SUPERVISOR" Then
                Select Case sSL_Cat
                    Case "P"
                        If DebtorF Then
                            sJoin = sJoin & " Inner Join SysUserBranch on ( ((A2.Subject='Premium' and PremiumReceiveF=1) or (A2.Subject='Claim' and ClaimReceiveF=1) or (coalesce(A2.Subject,'')='' and SuspendReceiveF=1) or (A2.Subject='SURPLUS' and IncomeReceiveF=1) or (A2.Subject='OTHERS' and IncomeReceiveF=1)) and SysUserBranch.Branch=A1.Branch and SysUserBranch.ID='" & dbUser & "')"
                        Else
                            sJoin = sJoin & " Inner Join SysUserBranch on ( ((A2.Subject='Premium' and PremiumPaymentF=1) or (A2.Subject='Claim' and ClaimPaymentF=1) or (coalesce(A2.Subject,'')='' and SuspendPaymentF=1) or (A2.Subject='SURPLUS' and ExpensePaymentF=1) or (A2.Subject='OTHERS' and ExpensePaymentF=1)) and SysUserBranch.Branch=A1.Branch and SysUserBranch.ID='" & dbUser & "')"
                        End If
                    Case Else
                        sJoin = sJoin & " Inner Join SysUserBranch on (SysUserBranch.AllowedF=1 and SysUserBranch.Branch=A1.Branch and SysUserBranch.ID='" & dbUser & "')"
                End Select

                If Not db.GetPrivileges("ALLOWPASSUSERVTYPE") Then
                    sJoin = sJoin & " Inner Join SysUserVType on (SysUserVType.ID='" & dbUser & "' and SysUserVType.VType=A1.VType)"
                End If
            End If

            Dim rs As RemoteSet

            If sSL_Cat <> "A" Then
                If TypeList <> "" AndAlso TypeList <> "<All>" AndAlso TypeList <> "RV/PV" Then
                    If ComAcc <> "" Then
                        rs = db.OpenRemoteSet("Select Purpose from ComAcc Where ComAcc='" & ComAcc & "'")
                        Select Case tostr(rs.fields("Purpose"))
                            Case "DA"   ' Deposit Account
                                sfilter = sfilter & " and coalesce(A2.Type,'') in ('SO','PD')"
                            Case "NA"   ' Non-Deposit Account
                                sfilter = sfilter & " and coalesce(A2.Type,'') Not in ('SO','PD')"
                        End Select
                    End If
                    Select Case TypeList
                        Case "CN/DN"
                            If PaidOptionF And PolicyCompensation <> "1" Then
                                CheckPaymentPCTF = True
                            End If
                        Case "Net Premium with Comm"
                            sfilter = sfilter & " and a2.subject='Premium' and a2.Type in ('DI','IC','CF','JP','BB','BA','BC','BP','BD','BO')"
                            sfilter = sfilter & " and Exists (Select adm2.Source from Admlink Adm2, nVoucher V2 Where Adm2.Date=A2.Date and Adm2.A_PolicyNo=A2.A_PolicyNo and Adm2.Source=A2.Source and Adm2.Subject='Premium' and Adm2.Type in ('DI','IC','IR') and V2.Voucher=Adm2.Voucher and ((A2.Type in ('DI','IC','IR') and V2.DebtorF=A3.DebtorF) or (A2.Type Not in ('DI','IC','IR') and V2.DebtorF=A1.CreditorF)))"
                            If DebtorF = False And sSL_Cat = "P" Then
                                If PaidOptionF And PolicyCompensation <> "1" Then
                                    CheckPaymentPCTF = True
                                End If
                            End If
                        Case "Direct Premium"
                            sfilter = sfilter & " and a2.subject='Premium' and a2.Type in ('DI','IC','CF','JP')"
                            If PaidOptionF And PolicyCompensation <> "1" Then
                                CheckPaymentPCTF = True
                            End If
                        Case "Biz Source Comm"
                            sfilter = sfilter & " and a2.subject='Premium' and a2.Type in ('BB','BA','BC','BP','BD','BO')"
                            If PaidOptionF And PolicyCompensation <> "1" Then
                                CheckPaymentPCTF = True
                            End If
                        Case "Agent/Broker Comm"
                            sfilter = sfilter & " and a2.subject='Premium' and a2.Type in ('BB','BA')"
                            If PaidOptionF And PolicyCompensation <> "1" Then
                                CheckPaymentPCTF = True
                            End If
                        Case "Bank Comm"
                            sfilter = sfilter & " and a2.subject='Premium' and a2.Type in ('BD')"
                            If PaidOptionF And PolicyCompensation <> "1" Then
                                CheckPaymentPCTF = True
                            End If
                        Case "Direct Premium & Comm."
                            sfilter = sfilter & " and a2.subject='Premium' and a2.Type in ('DI','IC','CF','JP','BA','BC','BP','BD','BB','BO')"
                            If PaidOptionF And PolicyCompensation <> "1" Then
                                CheckPaymentPCTF = True
                            End If
                        Case "Claim Payment"
                            sfilter = sfilter & " and a2.subject='Claim' and a2.Type in ('DI','IC','CF','JP','OP','SO') and (a2.Type<>'OP' or a2.Amount_8=0)"
                        Case "Claim Payment (Provider)"
                            sfilter = sfilter & " and a2.subject='Claim' and a2.Type in ('DI','IC','CF','JP','OP','SO') and (a2.Type<>'OP' or a2.Amount_8=0) and A2.Extra_1='CHISS' and A2.Extra_3='' and A2.Extra_4='PROVIDER'"
                        Case "Claim Payment (Reimbursement)"
                            sfilter = sfilter & " and a2.subject='Claim' and a2.Type in ('DI','IC','CF','JP','OP','SO') and (a2.Type<>'OP' or a2.Amount_8=0) and A2.Extra_1='CHISS' and A2.Extra_3='' and A2.Extra_4='REIMBURSEMENT'"
                        Case "Claim Excess/Salvage"
                            sfilter = sfilter & " and a2.subject='Claim' and ((a2.Type='OP' and a2.Amount_8<>0) or (a2.Type='DI' and a2.Amount_7+a2.Amount_12=a2.Amount))"
                        Case "Outward Facultative Premium"
                            sfilter = sfilter & " and a2.subject='Premium' and a2.Type in ('FO')"
                            If PaidOptionF And PolicyCompensation <> "1" Then
                                CheckPaymentPCTF = True
                            End If
                        Case "Outward Facultative Claim"
                            sfilter = sfilter & " and a2.subject='Claim' and a2.Type in ('FO')"
                            If PaidOptionF And PolicyCompensation <> "1" Then
                                CheckPaymentPCTF = True
                            End If
                        Case "Inward Facultative Premium"
                            sfilter = sfilter & " and a2.subject='Premium' and a2.Type in ('IR')"
                        Case "Inward Facultative Claim"
                            sfilter = sfilter & " and a2.subject='Claim' and a2.Type in ('IR')"
                        Case "Reinsurance Premium BPPDAN"
                            sfilter = sfilter & " and a2.subject='Premium' and a2.Type in ('CP')"
                        Case "Reinsurance Claim BPPDAN"
                            sfilter = sfilter & " and a2.subject='Claim' and a2.Type in ('CP')"
                        Case "Reinsurance Premium Mai-Park"
                            sfilter = sfilter & " and a2.subject='Premium' and a2.Type in ('XP')"
                        Case "Reinsurance Claim Mai-Park"
                            sfilter = sfilter & " and a2.subject='Claim' and a2.Type in ('XP')"
                        Case "Reinsurance Premium Outward Treaty Prop"
                            sfilter = sfilter & " and a2.subject='Premium' and a2.Type in ('DC','QS','QP','S1','S2','S3','AF')"
                        Case "Reinsurance Claim Outward Treaty Prop"
                            sfilter = sfilter & " and a2.subject='Claim' and a2.Type in ('DC','QS','QP','S1','S2','S3','AF')"
                        Case "Reinsurance Premium Outward Treaty Non Prop"
                            sfilter = sfilter & " and a2.subject='Premium' and a2.Type in ('X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP')"
                        Case "Reinsurance Claim Outward Treaty Non Prop"
                            sfilter = sfilter & " and a2.subject='Claim' and a2.Type in ('X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP')"
                        Case "Reinsurance Inward Treaty"
                            sfilter = sfilter & " and a2.Type in ('IT','IX')"
                        Case "Other Parties Fee"
                            sfilter = sfilter & " and a2.subject='Premium' and a2.Type in ('OP')"
                            If PaidOptionF And PolicyCompensation <> "1" Then
                                CheckPaymentPCTF = True
                            End If
                        Case "Surplus Calculation"
                            sfilter = sfilter & " and a2.subject='SURPLUS' and a2.Type in ('SC')"
                            If PaidOptionF And PolicyCompensation <> "1" Then
                                CheckPaymentPCTF = True
                            End If
                        Case "Profit Commission Inward Treaty"
                            sfilter = sfilter & " and a2.Type in ('PI')"
                        Case "Profit Commission Outward Treaty"
                            sfilter = sfilter & " and a2.Type in ('PO')"
                        Case "Claim Payment ASO"
                            sfilter = sfilter & " and a2.subject='Claim' and a2.Type in ('SO') and A2.Amount_6<>0"
                            If PaidOptionF And PolicyCompensation <> "1" Then
                                sfilter = sfilter & " and Exists ("
                                sfilter = sfilter & " Select nVoucher.Currency, sum(dbo.fn_SL_Payment_Nominal(pSL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, nVoucher.DebtorF)) as Nominal"
                                sfilter = sfilter & " from Admlink, nVoucher, pSL, pVoucher "
                                sfilter = sfilter & " Where Admlink.Type='SO' and Admlink.Amount_6+Admlink.Amount_7+Admlink.Amount_19<>0 "
                                sfilter = sfilter & " and nVoucher.Voucher=Admlink.Voucher"
                                sfilter = sfilter & " and pSL.Doc_No=Admlink.Voucher and pSL.PaymentF=1 and pVoucher.Voucher=pSL.Voucher"
                                sfilter = sfilter & " and Admlink.A_PolicyNo=A2.A_PolicyNo"
                                sfilter = sfilter & " and pVoucher.Date<='" & Format(VoucherDate, "MM/DD/YYYY") & "'"
                                sfilter = sfilter & " Group by nVoucher.Currency"
                                sfilter = sfilter & " Having sum(dbo.fn_SL_Payment_Nominal(pSL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, nVoucher.DebtorF)) > 0"
                                sfilter = sfilter & ")"
                            End If
                        Case "ASO Fee"
                            sfilter = sfilter & " and a2.subject='Premium' and a2.Type in ('SO') and A2.Amount_19=0"
                        Case "ASO Deposit"
                            sfilter = sfilter & " and a2.subject='Premium' and a2.Type in ('SO') and A2.Amount_19<>0"
                        Case "Claim Payment ASO (Provider)"
                            sfilter = sfilter & " and a2.subject='Claim' and a2.Type in ('SO') and A2.Extra_1='CHISS' and A2.Extra_4='PROVIDER'"
                        Case "Claim Payment ASO (Reimbursement)"
                            sfilter = sfilter & " and a2.subject='Claim' and a2.Type in ('SO') and A2.Extra_1='CHISS' and A2.Extra_4='REIMBURSEMENT'"
                        Case "Others"
                            sfilter = sfilter & " and a2.subject='Others'"
                        Case "VAT Payable"
                            sfilter = sfilter & " and a2.Type in ('VT')"
                        Case "Deposit Receipt"
                            sfilter = sfilter & " and a2.Type in ('DR')"
                        Case "Deposit Payment"
                            sfilter = sfilter & " and a2.Type in ('DP')"
                    End Select
                End If

                If RefID = "" Then
                    If TypeList = "<All>" Then
                        If Not db.GetPrivileges("ALLOWRIDISBURSE") Then
                            sfilter = sfilter & " and a2.Type not in ('FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')"
                        End If
                        If SL_Cat <> "" Then
                            SQL = "select Cast(0 as bit) as ProcessFlag, Cast(0 as Float) as AmountPaid, Cast(0 as Float) as AmountPaidLocked, Cast(0 as Bit) as LockedF, Cast(0 as Bit) as FundingF, a1.*, a3.AmountDue, A3.AmountNextDue, a3." & sInstallmentInfo & " as sInstallment, '' as CollNo, '' as AName, cast(0 as Float) as CNominal, a2.Type, a2.Subject, a2.A_PolicyNo, a2.DocNo as A_DocNo, a2.ValueDesc as Info, a2.Extras, ProAcc.Description as Name from OS_Voucher_" & SL_Cat & "('" & Voucher & "') a1 Left Join " & UDF & "('" & VoucherDate & "') A3 On (A3.Voucher=A1.Voucher) Outer Apply (Select * from FN_GET_ADMLINK_WITH_EXTRAS(A1.Voucher,'" & Extras & "')) A2 " & sJoin & ", ProAcc where a1.SL_Cat='N' and ProAcc.ProAcc=a1.ProAcc " & sfilter & " "
                        Else
                            SQL = "select Cast(0 as bit) as ProcessFlag, Cast(0 as Float) as AmountPaid, Cast(0 as Float) as AmountPaidLocked, Cast(0 as Bit) as LockedF, Cast(0 as Bit) as FundingF, a1.*, a3.AmountDue, A3.AmountNextDue, a3." & sInstallmentInfo & " as sInstallment, '' as CollNo, '' as AName, cast(0 as Float) as CNominal, a2.Type, a2.Subject, a2.A_PolicyNo, a2.DocNo as A_DocNo, a2.ValueDesc as Info, a2.Extras, ProAcc.Description as Name from OS_Voucher('" & Voucher & "') a1 Left Join " & UDF & "('" & VoucherDate & "') A3 On (A3.Voucher=A1.Voucher) Outer Apply (Select * from FN_GET_ADMLINK_WITH_EXTRAS(A1.Voucher,'" & Extras & "')) A2 " & sJoin & ", ProAcc where ProAcc.ProAcc=a1.ProAcc " & sfilter & " "
                        End If
                    Else
                        If TypeList = "RV/PV" And SL_Cat <> "N" Then
                            SQL = "select Cast(0 as bit) as ProcessFlag, Cast(0 as Float) as AmountPaid, Cast(0 as Float) as AmountPaidLocked, Cast(0 as Bit) as LockedF, Cast(0 as Bit) as FundingF, a1.*, 0 as AmountDue, 0 as AmountNextDue, '' as sInstallment, '' as CollNo, '' as AName, cast(0 as Float) as CNominal, a2.Type, a2.Subject, a2.A_PolicyNo, a2.DocNo as A_DocNo, a2.ValueDesc as Info, a2.Extras, ProAcc.Description as Name from OS_Voucher_P('" & Voucher & "') a1 Outer Apply (Select * from FN_GET_ADMLINK_WITH_EXTRAS(A1.Voucher,'" & Extras & "')) A2 " & sJoin & ", ProAcc where a1.SL_Cat='P' and ProAcc.ProAcc=a1.ProAcc " & sfilter & " "
                        ElseIf TypeList = "Withholding Tax" And SL_Cat <> "P" Then
                            SQL = "select Cast(0 as bit) as ProcessFlag, Cast(0 as Float) as AmountPaid, Cast(0 as Float) as AmountPaidLocked, Cast(0 as Bit) as LockedF, Cast(0 as Bit) as FundingF, a1.*, a3.AmountDue, A3.AmountNextDue, a3." & sInstallmentInfo & " as sInstallment, '' as CollNo, '' as AName, cast(0 as Float) as CNominal, a2.Type, a2.Subject, a2.A_PolicyNo, a2.DocNo as A_DocNo, a2.ValueDesc as Info, a2.Extras, ProAcc.Description as Name from OS_Voucher_T('" & Voucher & "') a1 Left Join " & UDF & "('" & VoucherDate & "') A3 On (A3.Voucher=A1.Voucher) Outer Apply (Select * from FN_GET_ADMLINK_WITH_EXTRAS(A1.Voucher,'" & Extras & "')) A2 " & sJoin & ", ProAcc where a1.SL_Cat='N' and ProAcc.ProAcc=a1.ProAcc " & sfilter & " "
                        ElseIf TypeList = "Withholding VAT" And SL_Cat <> "P" Then
                            SQL = "select Cast(0 as bit) as ProcessFlag, Cast(0 as Float) as AmountPaid, Cast(0 as Float) as AmountPaidLocked, Cast(0 as Bit) as LockedF, Cast(0 as Bit) as FundingF, a1.*, a3.AmountDue, A3.AmountNextDue, a3." & sInstallmentInfo & " as sInstallment, '' as CollNo, '' as AName, cast(0 as Float) as CNominal, a2.Type, a2.Subject, a2.A_PolicyNo, a2.DocNo as A_DocNo, a2.ValueDesc as Info, a2.Extras, ProAcc.Description as Name from OS_Voucher_V('" & Voucher & "') a1 Left Join " & UDF & "('" & VoucherDate & "') A3 On (A3.Voucher=A1.Voucher) Outer Apply (Select * from FN_GET_ADMLINK_WITH_EXTRAS(A1.Voucher,'" & Extras & "')) A2 " & sJoin & ", ProAcc where a1.SL_Cat='N' and ProAcc.ProAcc=a1.ProAcc " & sfilter & " "
                        ElseIf TypeList = "Investment" And SL_Cat <> "P" Then
                            SQL = "select Cast(0 as bit) as ProcessFlag, Cast(0 as Float) as AmountPaid, Cast(0 as Float) as AmountPaidLocked, Cast(0 as Bit) as LockedF, Cast(0 as Bit) as FundingF, a1.*, a3.AmountDue, A3.AmountNextDue, a3." & sInstallmentInfo & " as sInstallment, '' as CollNo, '' as AName, cast(0 as Float) as CNominal, a2.Type, a2.Subject, a2.A_PolicyNo, a2.DocNo as A_DocNo, a2.ValueDesc as Info, a2.Extras, ProAcc.Description as Name from OS_Voucher_I('" & Voucher & "') a1 Left Join " & UDF & "('" & VoucherDate & "') A3 On (A3.Voucher=A1.Voucher) Outer Apply (Select * from FN_GET_ADMLINK_WITH_EXTRAS(A1.Voucher,'" & Extras & "')) A2 " & sJoin & ", ProAcc where a1.SL_Cat='N' and ProAcc.ProAcc=a1.ProAcc " & sfilter & " "
                        ElseIf TypeList = "CN/DN Manual" And SL_Cat <> "P" Then
                            SQL = "select Cast(0 as bit) as ProcessFlag, Cast(0 as Float) as AmountPaid, Cast(0 as Float) as AmountPaidLocked, Cast(0 as Bit) as LockedF, Cast(0 as Bit) as FundingF, a1.*, a3.AmountDue, A3.AmountNextDue, a3." & sInstallmentInfo & " as sInstallment, '' as CollNo, '' as AName, cast(0 as Float) as CNominal, a2.Type, a2.Subject, a2.A_PolicyNo, a2.DocNo as A_DocNo, a2.ValueDesc as Info, a2.Extras, ProAcc.Description as Name from OS_Voucher_M('" & Voucher & "') a1 Left Join " & UDF & "('" & VoucherDate & "') A3 On (A3.Voucher=A1.Voucher) Outer Apply (Select * from FN_GET_ADMLINK_WITH_EXTRAS(A1.Voucher,'" & Extras & "')) A2 " & sJoin & ", ProAcc where a1.SL_Cat='N' and ProAcc.ProAcc=a1.ProAcc " & sfilter & " "
                        Else
                            If Not db.GetPrivileges("ALLOWRIDISBURSE") Then
                                sfilter = sfilter & " and a2.Type not in ('FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')"
                            End If
                            If CollNo = "" Then
                                sfilter = sfilter & " and round(a1.NOMINAL_CC-a1.DIFF_CC-a1.PAYMENT_CC-a1.PAYMENT_OC,4)<>0"
                                SQL = "select Cast(0 as bit) as ProcessFlag, Cast(0 as Float) as AmountPaid, Cast(0 as Float) as AmountPaidLocked, Cast(0 as Bit) as LockedF, Cast(0 as Bit) as FundingF, a1.Voucher, a1.Date, a1.Currency, a1.ProAcc, a1.DebtorF, a1.CreditorF, a1.SL_cat, a1.Branch, a1.refNo, a1.refDate, a1.docNo, a1.Vtype, a1.remarks, a1.refType, a1.accountNo, a2.A_RefNo, a1.Nominal_CC-a1.Diff_CC as nominal, a1.Tax_CC as Tax, a1.Payment_CC+a1.PAYMENT_OC as Payment, a1.Nominal_CC-a1.Diff_CC-a1.Payment_CC-a1.PAYMENT_OC as Outstanding, '' as Account,cast(0 as Smallint) as Hint, a3.AmountDue, A3.AmountNextDue, a3." & sInstallmentInfo & " as sInstallment, '' as CollNo, '' as AName, cast(0 as Float) as CNominal, a2.Type, a2.Subject, a2.A_PolicyNo, a2.DocNo as A_DocNo, a2.ValueDesc as Info, a2.Extras, ProAcc.Description as Name from nVoucher a1 Left Join " & UDF & "('" & VoucherDate & "') A3 On (A3.Voucher=A1.Voucher) Outer Apply (Select * from FN_GET_ADMLINK_WITH_EXTRAS(A1.Voucher,'" & Extras & "')) A2 " & sJoin & ", ProAcc where a1.SL_Cat='N' and ProAcc.ProAcc=a1.ProAcc " & sfilter & " "
                            Else
                                'sfilter = sfilter & " and Not Exists (Select pSL.Doc_No from pSL Where pSL.Doc_No=a1.voucher and pSL.pVoucher='" & CollNo & "')"
                                SQL = "select Cast(0 as bit) as ProcessFlag, Cast(0 as Float) as AmountPaid, Cast(0 as Float) as AmountPaidLocked, Cast(0 as Bit) as LockedF, Cast(0 as Bit) as FundingF, a1.Voucher, a1.Date, a1.Currency, a1.ProAcc, a1.DebtorF, a1.CreditorF, a1.SL_cat, a1.Branch, a1.refNo, a1.refDate, a1.docNo, a1.Vtype, a1.remarks, a1.refType, a1.accountNo, a2.A_RefNo, a1.Nominal_CC-a1.Diff_CC as nominal, a1.Tax_CC as Tax, a1.Payment_CC+a1.PAYMENT_OC as Payment, a1.Nominal_CC-a1.Diff_CC-a1.Payment_CC-a1.PAYMENT_OC as Outstanding, '' as Account,cast(0 as Smallint) as Hint,"
                                SQL = SQL & " (case When (A1.DebtorF=1 and C2.CType='C') or (A1.CreditorF=1 and C2.CType='D') Then (C1.Amount-C1.Paid) else -(C1.Amount-C1.Paid) end) as AmountDue, 0 as AmountNextDue, '' as sInstallment, C3.CollNo, C3.AName, (case When (A1.DebtorF=1 and C2.CType='C') or (A1.CreditorF=1 and C2.CType='D') Then (C1.Amount-C1.Paid) else -(C1.Amount-C1.Paid) end) as CNominal, a2.Type, a2.Subject, a2.A_PolicyNo, a2.DocNo as A_DocNo, a2.ValueDesc as Info, a2.Extras, ProAcc.Description as Name from nVoucher a1 Inner Join CollectionV C1 On (C1.Voucher=A1.Voucher and C1.CollNo='" & CollNo & "') Inner Join CollectionH C2 On (C2.CollNo=C1.CollNo and C2.CollStatus='R') Inner Join CollectionD C3 On (C3.CollNo=C1.CollNo and C3.RefNo=C1.RefNo and C3.Currency=C1.Currency) Outer Apply (Select * from FN_GET_ADMLINK_WITH_EXTRAS(A1.Voucher,'" & Extras & "')) A2 " & sJoin & ", ProAcc where ProAcc.ProAcc=a1.ProAcc " & sfilter & " "
                            End If
                        End If
                    End If
                Else
                    If TypeList = "<All>" Then
                        If Not db.GetPrivileges("ALLOWRIDISBURSE") Then
                            sfilter = sfilter & " and a2.Type not in ('FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')"
                        End If
                        If SL_Cat <> "" Then
                            SQL = "select Cast(0 as bit) as ProcessFlag, Cast(0 as Float) as AmountPaid, Cast(0 as Float) as AmountPaidLocked, Cast(0 as Bit) as LockedF, Cast(0 as Bit) as FundingF, a1.*, a3.AmountDue, A3.AmountNextDue, a3." & sInstallmentInfo & " as sInstallment, '' as CollNo, '' as AName, cast(0 as Float) as CNominal, a2.Type, a2.Subject, a2.A_PolicyNo, a2.DocNo as A_DocNo, a2.ValueDesc as Info, a2.Extras, ProAcc.Description as Name from OS_Voucher_" & SL_Cat & "('" & Voucher & "') a1 Left Join " & UDF & "('" & VoucherDate & "') A3 On (A3.Voucher=A1.Voucher) Outer Apply (Select * from FN_GET_ADMLINK_WITH_EXTRAS(A1.Voucher,'" & Extras & "')) A2 " & sJoin & ", ProAcc, Profile where Profile.ID=ProAcc.ID and a1.SL_Cat='N' and ProAcc.ProAcc=a1.ProAcc " & sfilter & " "
                        Else
                            SQL = "select Cast(0 as bit) as ProcessFlag, Cast(0 as Float) as AmountPaid, Cast(0 as Float) as AmountPaidLocked, Cast(0 as Bit) as LockedF, Cast(0 as Bit) as FundingF, a1.*, a3.AmountDue, A3.AmountNextDue, a3." & sInstallmentInfo & " as sInstallment, '' as CollNo, '' as AName, cast(0 as Float) as CNominal, a2.Type, a2.Subject, a2.A_PolicyNo, a2.DocNo as A_DocNo, a2.ValueDesc as Info, a2.Extras, ProAcc.Description as Name from OS_Voucher('" & Voucher & "') a1 Left Join " & UDF & "('" & VoucherDate & "') A3 On (A3.Voucher=A1.Voucher) Outer Apply (Select * from FN_GET_ADMLINK_WITH_EXTRAS(A1.Voucher,'" & Extras & "')) A2 " & sJoin & ", ProAcc, Profile where Profile.ID=ProAcc.ID and ProAcc.ProAcc=a1.ProAcc " & sfilter & " "
                        End If
                    Else
                        If TypeList = "RV/PV" And SL_Cat <> "N" Then
                            SQL = "select Cast(0 as bit) as ProcessFlag, Cast(0 as Float) as AmountPaid, Cast(0 as Float) as AmountPaidLocked, Cast(0 as Bit) as LockedF, Cast(0 as Bit) as FundingF, a1.*, a3.AmountDue, A3.AmountNextDue, a3." & sInstallmentInfo & " as sInstallment, '' as CollNo, '' as AName, cast(0 as Float) as CNominal, a2.Type, a2.Subject, a2.A_PolicyNo, a2.DocNo as A_DocNo, a2.ValueDesc as Info, a2.Extras, ProAcc.Description as Name from OS_Voucher_P('" & Voucher & "') a1 Left Join " & UDF & "('" & VoucherDate & "') A3 On (A3.Voucher=A1.Voucher) Outer Apply (Select * from FN_GET_ADMLINK_WITH_EXTRAS(A1.Voucher,'" & Extras & "')) A2 " & sJoin & ", ProAcc, Profile where Profile.ID=ProAcc.ID and a1.SL_Cat='P' and ProAcc.ProAcc=a1.ProAcc " & sfilter & " "
                        ElseIf TypeList = "Withholding Tax" And SL_Cat <> "P" Then
                            SQL = "select Cast(0 as bit) as ProcessFlag, Cast(0 as Float) as AmountPaid, Cast(0 as Float) as AmountPaidLocked, Cast(0 as Bit) as LockedF, Cast(0 as Bit) as FundingF, a1.*, a3.AmountDue, A3.AmountNextDue, a3." & sInstallmentInfo & " as sInstallment, '' as CollNo, '' as AName, cast(0 as Float) as CNominal, a2.Type, a2.Subject, a2.A_PolicyNo, a2.DocNo as A_DocNo, a2.ValueDesc as Info, a2.Extras, ProAcc.Description as Name from OS_Voucher_T('" & Voucher & "') a1 Left Join " & UDF & "('" & VoucherDate & "') A3 On (A3.Voucher=A1.Voucher) Outer Apply (Select * from FN_GET_ADMLINK_WITH_EXTRAS(A1.Voucher,'" & Extras & "')) A2 " & sJoin & ", ProAcc, Profile where Profile.ID=ProAcc.ID and a1.SL_Cat='N' and ProAcc.ProAcc=a1.ProAcc " & sfilter & " "
                        ElseIf TypeList = "Withholding VAT" And SL_Cat <> "P" Then
                            SQL = "select Cast(0 as bit) as ProcessFlag, Cast(0 as Float) as AmountPaid, Cast(0 as Float) as AmountPaidLocked, Cast(0 as Bit) as LockedF, Cast(0 as Bit) as FundingF, a1.*, a3.AmountDue, A3.AmountNextDue, a3." & sInstallmentInfo & " as sInstallment, '' as CollNo, '' as AName, cast(0 as Float) as CNominal, a2.Type, a2.Subject, a2.A_PolicyNo, a2.DocNo as A_DocNo, a2.ValueDesc as Info, a2.Extras, ProAcc.Description as Name from OS_Voucher_V('" & Voucher & "') a1 Left Join " & UDF & "('" & VoucherDate & "') A3 On (A3.Voucher=A1.Voucher) Outer Apply (Select * from FN_GET_ADMLINK_WITH_EXTRAS(A1.Voucher,'" & Extras & "')) A2 " & sJoin & ", ProAcc, Profile where Profile.ID=ProAcc.ID and a1.SL_Cat='N' and ProAcc.ProAcc=a1.ProAcc " & sfilter & " "
                        ElseIf TypeList = "Investment" And SL_Cat <> "P" Then
                            SQL = "select Cast(0 as bit) as ProcessFlag, Cast(0 as Float) as AmountPaid, Cast(0 as Float) as AmountPaidLocked, Cast(0 as Bit) as LockedF, Cast(0 as Bit) as FundingF, a1.*, a3.AmountDue, A3.AmountNextDue, a3." & sInstallmentInfo & " as sInstallment, '' as CollNo, '' as AName, cast(0 as Float) as CNominal, a2.Type, a2.Subject, a2.A_PolicyNo, a2.DocNo as A_DocNo, a2.ValueDesc as Info, a2.Extras, ProAcc.Description as Name from OS_Voucher_I('" & Voucher & "') a1 Left Join " & UDF & "('" & VoucherDate & "') A3 On (A3.Voucher=A1.Voucher) Outer Apply (Select * from FN_GET_ADMLINK_WITH_EXTRAS(A1.Voucher,'" & Extras & "')) A2 " & sJoin & ", ProAcc, Profile where Profile.ID=ProAcc.ID and a1.SL_Cat='N' and ProAcc.ProAcc=a1.ProAcc " & sfilter & " "
                        ElseIf TypeList = "CN/DN Manual" And SL_Cat <> "P" Then
                            SQL = "select Cast(0 as bit) as ProcessFlag, Cast(0 as Float) as AmountPaid, Cast(0 as Float) as AmountPaidLocked, Cast(0 as Bit) as LockedF, Cast(0 as Bit) as FundingF, a1.*, a3.AmountDue, A3.AmountNextDue, a3." & sInstallmentInfo & " as sInstallment, '' as CollNo, '' as AName, cast(0 as Float) as CNominal, a2.Type, a2.Subject, a2.A_PolicyNo, a2.DocNo as A_DocNo, a2.ValueDesc as Info, a2.Extras, ProAcc.Description as Name from OS_Voucher_M('" & Voucher & "') a1 Left Join " & UDF & "('" & VoucherDate & "') A3 On (A3.Voucher=A1.Voucher) Outer Apply (Select * from FN_GET_ADMLINK_WITH_EXTRAS(A1.Voucher,'" & Extras & "')) A2 " & sJoin & ", ProAcc, Profile where Profile.ID=ProAcc.ID and a1.SL_Cat='N' and ProAcc.ProAcc=a1.ProAcc " & sfilter & " "
                        Else
                            If Not db.GetPrivileges("ALLOWRIDISBURSE") Then
                                sfilter = sfilter & " and a2.Type not in ('FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')"
                            End If
                            If CollNo = "" Then
                                sfilter = sfilter & " and round(a1.NOMINAL_CC-a1.DIFF_CC-a1.PAYMENT_CC-a1.PAYMENT_OC,4)<>0"
                                SQL = "select Cast(0 as bit) as ProcessFlag, Cast(0 as Float) as AmountPaid, Cast(0 as Float) as AmountPaidLocked, Cast(0 as Bit) as LockedF, Cast(0 as Bit) as FundingF, a1.Voucher, a1.Date, a1.Currency, a1.ProAcc, a1.DebtorF, a1.CreditorF, a1.SL_cat, a1.Branch, a1.refNo, a1.refDate, a1.docNo, a1.Vtype, a1.remarks, a1.refType, a1.accountNo, a2.A_RefNo, a1.Nominal_CC-a1.Diff_CC as nominal, a1.Tax_CC as Tax, a1.Payment_CC+a1.PAYMENT_OC as Payment, a1.Nominal_CC-a1.Diff_CC-a1.Payment_CC-a1.PAYMENT_OC as Outstanding, '' as Account, cast(0 as Smallint) as Hint, a3.AmountDue, A3.AmountNextDue, a3." & sInstallmentInfo & " as sInstallment, '' as CollNo, '' as AName, cast(0 as Float) as CNominal, a2.Type, a2.Subject, a2.A_PolicyNo, a2.DocNo as A_DocNo, a2.ValueDesc as Info, a2.Extras, ProAcc.Description as Name from nVoucher a1 Left Join " & UDF & "('" & VoucherDate & "') A3 On (A3.Voucher=A1.Voucher) Outer Apply (Select * from FN_GET_ADMLINK_WITH_EXTRAS(A1.Voucher,'" & Extras & "')) A2 " & sJoin & ", ProAcc, Profile where Profile.ID=ProAcc.ID and a1.SL_Cat='N' and ProAcc.ProAcc=a1.ProAcc " & sfilter & " "
                            Else
                                'sfilter = sfilter & " and Not Exists (Select pSL.Doc_No from pSL Where pSL.Doc_No=a1.voucher and pSL.pVoucher='" & CollNo & "')"
                                SQL = "select Cast(0 as bit) as ProcessFlag, Cast(0 as Float) as AmountPaid, Cast(0 as Float) as AmountPaidLocked, Cast(0 as Bit) as LockedF, Cast(0 as Bit) as FundingF, a1.Voucher, a1.Date, a1.Currency, a1.ProAcc, a1.DebtorF, a1.CreditorF, a1.SL_cat, a1.Branch, a1.refNo, a1.refDate, a1.docNo, a1.Vtype, a1.remarks, a1.refType, a1.accountNo, a2.A_RefNo, a1.Nominal_CC-a1.Diff_CC as nominal, a1.Tax_CC as Tax, a1.Payment_CC+a1.PAYMENT_OC as Payment, a1.Nominal_CC-a1.Diff_CC-a1.Payment_CC-a1.PAYMENT_OC as Outstanding, '' as Account, cast(0 as Smallint) as Hint,"
                                SQL = SQL & " (case When (A1.DebtorF=1 and C2.CType='C') or (A1.CreditorF=1 and C2.CType='D') Then (C1.Amount-C1.Paid) else -(C1.Amount-C1.Paid) end) as AmountDue, 0 as AmountNextDue, '' as sInstallment, C3.CollNo, C3.AName, (case When (A1.DebtorF=1 and C2.CType='C') or (A1.CreditorF=1 and C2.CType='D') Then (C1.Amount-C1.Paid) else -(C1.Amount-C1.Paid) end) as CNominal, a2.Type, a2.Subject, a2.A_PolicyNo, a2.DocNo as A_DocNo, a2.ValueDesc as Info, a2.Extras, ProAcc.Description as Name from nVoucher a1 Inner Join CollectionV C1 On (C1.Voucher=A1.Voucher and C1.CollNo='" & CollNo & "') Inner Join CollectionH C2 On (C2.CollNo=C1.CollNo and C2.CollStatus='R') Inner Join CollectionD C3 On (C3.CollNo=C1.CollNo and C3.RefNo=C1.RefNo and C3.Currency=C1.Currency) Outer Apply (Select * from FN_GET_ADMLINK_WITH_EXTRAS(A1.Voucher,'" & Extras & "')) A2 " & sJoin & ", ProAcc, Profile where Profile.ID=ProAcc.ID and ProAcc.ProAcc=a1.ProAcc " & sfilter & " "
                            End If
                        End If
                    End If
                    SQL = SQL & " and Profile.RefID Like '" & RefID & "%'"
                End If

                'If typelist = "<All>" Then
                '    If SL_Cat <> "" Then
                '        SQL = SQL & "and a1.Voucher in (Select Top 1 SL.Voucher from " & SL_Cat & "SL SL, VPattern Where VPattern.VType='" & VType & "' and SL.hint=vPattern.Debit+VPattern.Credit and SL.Voucher=A1.Voucher) "
                '    Else
                '        SQL = SQL & "and a1.Voucher in (Select Top 1 SL.Voucher from SL SL, VPattern Where VPattern.VType='" & VType & "' and SL.hint=vPattern.Debit+VPattern.Credit and SL.Voucher=A1.Voucher) "
                '    End If
                'Else
                '    If TypeList = "RV/PV" And SL_Cat <> "N" Then
                '        SQL = SQL & "and a1.Voucher in (Select Top 1 SL.Voucher from pSL SL, VPattern Where VPattern.VType='" & VType & "' and SL.hint=vPattern.Debit+VPattern.Credit and SL.Voucher=A1.Voucher) "
                '    Else
                '        SQL = SQL & " and a1.Voucher in (Select Top 1 SL.Voucher from nSL SL, VPattern Where VPattern.VType='" & VType & "' and SL.hint=vPattern.Debit+VPattern.Credit and SL.Voucher=A1.Voucher) "
                '    End If
                'End If
                If CollNo = "" AndAlso TypeList <> "RV/PV" Then
                    If InCollectionF Then
                        SQL = SQL & "and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH where CollectionV.CollNo=CollectionH.CollNo and a3.CollNo<>CollectionV.CollNo and CollectionH.CollStatus<>'C' and CollectionH.CollNo<>'" & CollNo & "' and CollectionV.Voucher=A1.Voucher) "
                    End If
                    Select Case PolicyCompensation
                        Case "1"    ' Policy Cancellation
                            SQL = SQL & " and A3.Payment_CC=0 and Exists (Select A4.A_PolicyNo from nVoucher Voucher, Admlink A4 Where A4.Voucher=Voucher.Voucher and Voucher.Payment_CC=0 and A4.Type=A2.Type and A4.Subject=A2.Subject and A4.A_PolicyNo=A2.A_PolicyNo and A4.ID=A2.ID and A4.Currency=A2.Currency and A4.RefNo=A2.RefNo Group by A4.A_PolicyNo having round(sum(A4.Amount),2)=0)"
                        Case "2"    ' Not In Policy Cancellation
                            SQL = SQL & " and Not (A3.Payment_CC=0 and Exists (Select A4.A_PolicyNo from nVoucher Voucher, Admlink A4 Where A4.Voucher=Voucher.Voucher and Voucher.Payment_CC=0 and A4.Type=A2.Type and A4.Subject=A2.Subject and A4.A_PolicyNo=A2.A_PolicyNo and A4.ID=A2.ID and A4.Currency=A2.Currency and A4.RefNo=A2.RefNo Group by A4.A_PolicyNo having round(sum(A4.Amount),2)=0))"
                        Case "3"    ' Claim with Paid Policy
                            SQL = SQL & " and A2.Subject='Claim' and not exists (Select Top 1 A4.A_PolicyNo from Voucher_AmountWPCDue('" & RefCCYDate & "') Voucher, Admlink A4 Where A4.Voucher=Voucher.Voucher and A4.Type in ('DI','IC','IR','IT','IX','PD') and A4.Subject='Premium' and Voucher.DebtorF=1and A4.A_PolicyNo=A2.A_PolicyNo and a4.Date<=A2.Date and round(Voucher.AmountDue-Voucher.Payment_CC,4)>0)"
                        Case "4"    ' Claim with UnPaid Policy
                            SQL = SQL & " and A2.Subject='Claim' and exists (Select Top 1 A4.A_PolicyNo from Voucher_AmountWPCDue('" & RefCCYDate & "') Voucher, Admlink A4 Where A4.Voucher=Voucher.Voucher and A4.Type in ('DI','IC','IR','IT','IX','PD') and A4.Subject='Premium' and Voucher.DebtorF=1 and A4.A_PolicyNo=A2.A_PolicyNo and a4.Date<=A2.Date and round(Voucher.AmountDue-Voucher.Payment_CC,4)>0)"
                    End Select
                End If
                If InRequestF Then
                    SQL = SQL & "and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=A1.Voucher) "
                End If
            Else
                ' For Adjustment
                SQL = "Select Cast(0 as bit) as ProcessFlag, Cast(0 as Float) as AmountPaid, Cast(0 as Float) as AmountPaidLocked, Cast(0 as Bit) as LockedF, Cast(0 as Bit) as FundingF, A1.Voucher, A1.Date, A1.Currency, A1.ProAcc, A1.DebtorF, A1.CreditorF, A1.SL_Cat, A1.Branch, A1.RefNo, A1.refDate, A1.DocNo, A1.VType, A1.Remarks, A1.RefType, '' as AccountNo, A2.A_Refno, SL.Nominal_OC as Nominal, 0 as Payment, SL.Nominal_OC as Outstanding, SL.Account, SL.Hint, 0 as AmountDue, 0 as AmountNextDue, '' as sInstallment, '' as CollNo, '' as AName, cast(0 as Float) as CNominal, a2.Type, a2.Subject, a2.A_PolicyNo, a2.DocNo as A_DocNo, a2.ValueDesc as Info, a2.Extras, ProAcc.Description as Name from Voucher A1 Outer Apply (Select * from FN_GET_ADMLINK_WITH_EXTRAS(A1.Voucher,'" & Extras & "')) A2 " & sJoin & " Left Join ProAcc on (ProAcc.ProAcc=A1.ProAcc) Left Join Profile on (Profile.ID=ProAcc.ID), pSL SL where A1.Status<>'C' and A1.Voucher=SL.Doc_No and SL.PaymentF=1 and SL.Voucher='" & pVoucher & "' " & sfilter & " "
                If RefID <> "" Then
                    SQL = SQL & " and Profile.RefID Like '" & RefID & "%'"
                End If
            End If

            If Source <> "" Or sRefID <> "" Then
                If sRefID = "" Then
                    SQL = SQL & " and a2.Source Like '" & Source & "%'"
                Else
                    SQL = SQL & " and a2.Source Like '" & Source & "%' and Exists (Select Top 1 ID from Profile Where Profile.ID=A2.Source and Profile.RefID Like '" & sRefID & "%')"
                End If
            End If

            If ASource <> "" Then
                SQL = SQL & " and a2.ASource Like '" & ASource & "%'"
            End If

            If Branch <> "" Then
                SQL = SQL & " and a1.Branch like '" & Branch & "%'"
            End If

            If Remarks <> "" Then
                SQL = SQL & " and A1.Remarks like '%" & Remarks & "%'"
            End If

            If Insured <> "" Then
                SQL = SQL & " and A2.Insured like '%" & Insured & "%'"
            End If

            If CollNo <> "" Then
                If sCollDate <> "" Then
                    sfilter = sfilter & " and C2.CollDate>='" & sCollDate & "'"
                End If

                If eCollDate <> "" Then
                    sfilter = sfilter & " and C2.CollDate<='" & eCollDate & "'"
                End If
            End If

            If Extras <> "" Then
                SQL = SQL & " and ("
                SQL = SQL & " A2.Extra_1 Like '%" & Extras & "%' or "
                SQL = SQL & " A2.Extra_2 Like '%" & Extras & "%' or "
                SQL = SQL & " A2.Extra_3 Like '%" & Extras & "%' or "
                SQL = SQL & " A2.Extra_4 Like '%" & Extras & "%' or "
                SQL = SQL & " A2.Extra_5 Like '%" & Extras & "%' or "
                SQL = SQL & " A2.Extra_6 Like '%" & Extras & "%' or "
                SQL = SQL & " A2.Extra_7 Like '%" & Extras & "%' or "
                SQL = SQL & " A2.Extra_8 Like '%" & Extras & "%' or "
                SQL = SQL & " A2.Extra_9 Like '%" & Extras & "%' or "
                SQL = SQL & " A2.Extra_10 Like '%" & Extras & "%'"
                SQL = SQL & " )"
            End If

            If Account <> "" AndAlso TypeList <> "<All>" Then
                If TypeList = "RV/PV" Then
                    SQL = SQL & " and A1.Account in (" & Get_Sub_Account(Account) & ")"
                Else
                    SQL = SQL & " and Exists (Select nSL.Voucher from nSL Where nSL.Voucher=A1.Voucher and nSL.Account in (" & Get_Sub_Account(Account) & "))"
                End If
            End If

            If CGroup <> "" Then
                SQL = SQL & " and Exists (Select Top 1 ID from Profile Where Profile.ID=A2.ID and Profile.CGroup Like '" & CGroup & "%')"
            End If

            If CBool(toval(GetAppSetting("UseBookingRateWhenMatchingF"))) Then
                If TypeList = "RV/PV" Then
                    If CheckPaymentPCTF Then
                        SQL = "Select Distinct Case When ((A1.Type in ('DI','IC','IR','IT','IX','PD') and A1.Subject='Premium')) Then cast(100 as Float) else dbo.Get_Payment_Percentage(A1.A_PolicyNo, A1.Subject, A1.Type, A1.DocNo, A1.Date, A1.Currency, A1.DebtorF) end as PaymentPCT, A1.*, C.Rate from (" & SQL & ") A1, fn_Exchange('" & RefCCYDate & "') C Where C.Currency=A1.Currency "
                    Else
                        SQL = "Select Distinct cast(100 as Float) as PaymentPCT, A1.*, C.Rate from (" & SQL & ") A1, fn_Exchange('" & RefCCYDate & "') C Where C.Currency=A1.Currency "
                    End If
                Else
                    If CheckPaymentPCTF Then
                        SQL = "Select Distinct Case When ((A1.Type in ('DI','IC','IR','IT','IX','PD') and A1.Subject='Premium')) Then cast(100 as Float) else dbo.Get_Payment_Percentage(A1.A_PolicyNo, A1.Subject, A1.Type, A1.DocNo, A1.Date, A1.Currency, A1.DebtorF) end as PaymentPCT, A1.*, V.Rate from (" & SQL & ") A1, nVoucher V Where V.Voucher=A1.Voucher "
                    Else
                        SQL = "Select Distinct cast(100 as Float) as PaymentPCT, A1.*, V.Rate from (" & SQL & ") A1, nVoucher V Where V.Voucher=A1.Voucher "
                    End If
                End If
            Else
                If CheckPaymentPCTF Then
                    SQL = "Select Distinct Case When ((A1.Type in ('DI','IC','IR','IT','IX','PD') and A1.Subject='Premium')) Then cast(100 as Float) else dbo.Get_Payment_Percentage(A1.A_PolicyNo, A1.Subject, A1.Type, A1.DocNo, A1.Date, A1.Currency, A1.DebtorF) end as PaymentPCT, A1.*, C.Rate from (" & SQL & ") A1, fn_Exchange('" & RefCCYDate & "') C Where C.Currency=A1.Currency "
                Else
                    SQL = "Select Distinct cast(100 as Float) as PaymentPCT, A1.*, C.Rate from (" & SQL & ") A1, fn_Exchange('" & RefCCYDate & "') C Where C.Currency=A1.Currency "
                End If
            End If

            SQL = SQL & " and round(A1.Outstanding,4)<>0"

            Select Case OrderBy
                Case "VOUCHER"
                    SQL = SQL & " Order By A1.Voucher"
                Case "BRANCH"
                    SQL = SQL & " Order By A1.Branch"
                Case "BOOKING DATE"
                    SQL = SQL & " Order By A1.Date"
                Case "PROFILE"
                    SQL = SQL & " Order By A1.ProAcc"
                Case "REMARKS"
                    SQL = SQL & " Order By A1.Remarks"
                Case "DOC. NO."
                    SQL = SQL & " Order By A1.DocNo"
                Case "REF. NO."
                    SQL = SQL & " Order By A1.RefNo"
                Case "CURRENCY"
                    SQL = SQL & " Order By A1.Currency"
                Case "NOMINAL"
                    SQL = SQL & " Order By A1.Nominal"
                Case "PAYMENT"
                    SQL = SQL & " Order By A1.Payment"
                Case "UN-PAYMENT"
                    SQL = SQL & " Order By A1.Outstanding"
            End Select

            Dim C_MaxRecords As Long
            C_MaxRecords = toval(GetAppSetting("CareMaxRecords"))
            If toval(GetAppSetting("CareMaxRecords_MR")) > C_MaxRecords Then
                C_MaxRecords = toval(GetAppSetting("CareMaxRecords_MR"))
            End If
            rs = db.OpenRemoteSet(SQL, , , , C_MaxRecords)
            Dataset = rs.GetDataSet

            If Dataset Is Nothing Then Throw New Exception(ErrMsg)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    Private Function UpdateLogProcess(ByVal LogID As Long, ByVal NumData As Long, ByVal NumProcess As Long, ByRef ErrMsg As String) As Boolean
        Dim db As New ClassLib
        Try

            If Not db.OpenConnection("", dbName, dbServer, dbSysUser, dbSysPassword, dbTimeOut, dbTrusted) Then
                Throw New Exception(db.ErrDesc)
            End If
            db.Var_db_user = dbUser
            db.Var_db_Password = dbPassword
            db.Var_db_User_Type = dbUserType

            db.Begintrans()
            ' for Logging Progress
            Dim rsLog As RemoteSet
            rsLog = db.OpenRemoteSet("Select * from SysLogProgress Where LOGID=" & LogID)
            If rsLog.Eof Then
                rsLog.AddNew()
                rsLog.fields("LogID") = LogID
                rsLog.fields("NumData") = NumData
            Else
                rsLog.Edit()
                rsLog.fields("NumProcess") = NumProcess
            End If
            If Not rsLog.Update Then Throw New Exception(rsLog.ErrDesc)
            db.Committrans()

            db.CloseSession()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            db.RollBack()
            db.CloseSession()
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function SearchDocumentFromExcel(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef dsExcel As DataSet, ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            Dim SQL As String
            SQL = "Select cast(0 as bit) as ProcessFlag, Cast(0 as Float) as PaymentPCT, Cast(0 as Float) as AmountPaid, Cast(0 as Float) as AmountPaidLocked, Cast(0 as Bit) as LockedF, Cast(0 as Bit) as FundingF, '' as Voucher, cast(0 as smalldatetime) as Date, '' as Currency,'' as ProAcc, cast(0 as Bit) as DebtorF, cast(0 as Bit) as CreditorF, '' as SL_Cat, '' as Branch, '' as RefNo, cast(0 as smalldatetime) as RefDate, '' as A_PolicyNo, '' as A_DocNo, '' as DocNo, '' as VType,'' as Remarks, '' as RefType, '' as AccountNo, '' as A_RefNo, cast(0 as Float) as Nominal, cast(0 as Float) as Tax, cast(0 as Float) as Payment, cast(0 as Float) as OutStanding,'' as Account, cast(0 as Smallint) as Hint, cast(0 as Float) as AmountDue, cast(0 as Float) as AmountNextDue, '' as sInstallment, '' as CollNo, '' as AName, cast(0 as Float) as CNominal, '' as Type, '' as Subject, '' as Name, cast(0 as Float) as Rate, '' as BankName, '' as BankAccount, '' as AccountNo, '' as Info, '' as Extras Where 1<>1"

            Dim rs As RemoteSet
            Dim C_MaxRecords As Long
            Dim Matching As String = getInParamValue(InParam, 0)
            Dim RefCCYDate As String = getInParamValue(InParam, 1)  ' Formatted Date MM/DD/YYYY
            Dim LogID As Long = toval(getInParamValue(InParam, 2))
            Dim ExcludeTaxF As Boolean = toval(getInParamValue(InParam, 3))
            Dim PolicyCompensation As String = tostr(getInParamValue(InParam, 4))
            Dim FundingF As Boolean = toval(getInParamValue(InParam, 5))
            Dim DebtorF As Boolean = toval(getInParamValue(InParam, 6))
            Dim PaidOptionF As Boolean = toval(getInParamValue(InParam, 7))
            Dim TypeList As String = tostr(getInParamValue(InParam, 8))
            Dim CheckPaymentPCTF As Boolean = False

            C_MaxRecords = toval(GetAppSetting("CareMaxRecords"))
            If toval(GetAppSetting("CareMaxRecords_MR")) > C_MaxRecords Then
                C_MaxRecords = toval(GetAppSetting("CareMaxRecords_MR"))
            End If
            rs = db.OpenRemoteSet(SQL, , , , C_MaxRecords)
            Dataset = rs.GetDataSet
            Dataset.Tables(0).PrimaryKey = New DataColumn() {Dataset.Tables(0).Columns("Voucher"), Dataset.Tables(0).Columns("Branch"), Dataset.Tables(0).Columns("Account")}

            Dim Voucher As String
            Dim ID As String
            Dim PolicyNo As String
            Dim CertificateNo As String
            Dim AccountNo As String
            Dim TOC As String
            Dim sType As String
            Dim DocNo As String
            Dim RefNo As String
            Dim Subject As String
            Dim AType As String
            Dim Currency As String
            Dim Rate As Double
            Dim NewRow As DataRow

            Dim UDF As String = ""
            Dim sInstallmentInfo As String = ""
            If ExcludeTaxF Then
                UDF = "VOUCHER_AMOUNTDUE_EXTAX"
            Else
                UDF = "VOUCHER_AMOUNTDUE"
            End If

            Dim ALLOWRIDISBURSE As Boolean = db.GetPrivileges("ALLOWRIDISBURSE")

            sInstallmentInfo = GetAppSetting("sInstallmentInfo")
            If sInstallmentInfo = "" Then sInstallmentInfo = "sInstallment"

            db.Execute("Drop Table #Exchange")
            If Not db.Execute("Select * into #Exchange from fn_Exchange('" & RefCCYDate & "') C") Then Throw New Exception(db.ErrDesc)
            For i = 0 To dsExcel.Tables(0).Rows.Count - 1

                If Not UpdateLogProcess(LogID, dsExcel.Tables(0).Rows.Count, i + 1, ErrMsg) Then Throw New Exception(ErrMsg)

                SQL = ""
                Voucher = ""
                ID = ""
                PolicyNo = ""
                CertificateNo = ""
                AccountNo = ""
                TOC = ""
                sType = ""
                DocNo = ""
                RefNo = ""
                Subject = ""
                AType = ""
                Currency = ""
                Rate = 0
                Try
                    Voucher = tostr(dsExcel.Tables(0).Rows(i)("Voucher"))
                Catch ex As Exception
                End Try

                Try
                    ID = tostr(dsExcel.Tables(0).Rows(i)("ID"))
                Catch ex As Exception
                End Try

                Try
                    PolicyNo = tostr(dsExcel.Tables(0).Rows(i)("PolicyNo"))
                Catch ex As Exception
                End Try

                Try
                    CertificateNo = tostr(dsExcel.Tables(0).Rows(i)("CertificateNo"))
                    If PolicyNo <> "" And CertificateNo <> "" Then
                        PolicyNo = PolicyNo & "-" & CertificateNo
                    End If
                Catch ex As Exception
                End Try

                Try
                    AccountNo = tostr(dsExcel.Tables(0).Rows(i)("AccountNo"))
                Catch ex As Exception
                End Try

                Try
                    TOC = tostr(dsExcel.Tables(0).Rows(i)("TOC"))
                Catch ex As Exception
                End Try

                Try
                    sType = tostr(dsExcel.Tables(0).Rows(i)("Type"))
                Catch ex As Exception
                End Try

                Try
                    DocNo = tostr(dsExcel.Tables(0).Rows(i)("DocNo"))
                Catch ex As Exception
                End Try

                Try
                    RefNo = tostr(dsExcel.Tables(0).Rows(i)("RefNo"))
                Catch ex As Exception
                End Try

                Try
                    Subject = tostr(dsExcel.Tables(0).Rows(i)("Subject"))
                Catch ex As Exception
                End Try

                Try
                    AType = tostr(dsExcel.Tables(0).Rows(i)("AType"))
                Catch ex As Exception
                End Try

                Try
                    Currency = tostr(dsExcel.Tables(0).Rows(i)("Currency"))
                Catch ex As Exception
                End Try

                If (UCase(sType) = "RV" Or UCase(sType) = "PV") And (Matching = "RVPV" Or Matching = "") Then
                    If Voucher <> "" Then
                        SQL = "Select C.Rate, A1.Voucher, A1.DocNo, A1.RefType, A1.RefNo, A1.RefDate, A1.AccountNo, '' as Type, '' as Subject, '' as A_RefNo, '' as A_PolicyNo, '' as A_DocNo, '' as Info, '' as Extras, Profile.Name, A1.Date as DueDate, A1.Remarks, A1.Date, A1.Currency, A1.ProAcc, A1.VType, A1.DebtorF, A1.CreditorF, A1.SL_Cat, A1.Outstanding+A1.Payment as AmountDue, 0 as AmountNextDue, '' as sInstallment, A1.Nominal as Nominal_CC, 0 as Diff_CC, 0 as Tax_CC, A1.Payment as Payment_CC, A1.Branch, A1.Account, A1.Hint"
                        SQL = SQL & " from OS_Suspend('" & Voucher & "') a1, ProAcc, Profile, #Exchange C where C.Currency=A1.Currency and a1.SL_Cat='P' and ProAcc.ProAcc=a1.ProAcc  and Profile.ID=ProAcc.ID"
                        SQL = SQL & " and A1.Voucher='" & Voucher & "'"
                    ElseIf RefNo <> "" Then
                        SQL = "Select C.Rate, A1.Voucher, A1.DocNo, A1.RefType, A1.RefNo, A1.RefDate, A1.AccountNo, '' as Type, '' as Subject, '' as A_RefNo, '' as A_PolicyNo, '' as A_DocNo, '' as Info, '' as Extras, Profile.Name, A1.Date as DueDate, A1.Remarks, A1.Date, A1.Currency, A1.ProAcc, A1.VType, A1.DebtorF, A1.CreditorF, A1.SL_Cat, A1.Outstanding+A1.Payment as AmountDue, 0 as AmountNextDue, '' as sInstallment, A1.Nominal as Nominal_CC, 0 as Diff_CC, 0 as Tax_CC, A1.Payment as Payment_CC, A1.Branch, A1.Account, A1.Hint"
                        SQL = SQL & " from OS_Suspend('') a1, ProAcc, Profile, #Exchange C where C.Currency=A1.Currency and a1.SL_Cat='P' and ProAcc.ProAcc=a1.ProAcc  and Profile.ID=ProAcc.ID"
                        If RefNo <> "" Then
                            SQL = SQL & " and A1.RefNo='" & RefNo & "'"
                        End If
                        If Currency <> "" Then
                            SQL = SQL & " and A1.Currency='" & Currency & "'"
                        End If
                    End If
                ElseIf Not (UCase(sType) = "RV" Or UCase(sType) = "PV") And Matching <> "RVPV" Then
                    If Voucher <> "" Then
                        If CBool(toval(GetAppSetting("UseBookingRateWhenMatchingF"))) Then
                            SQL = "Select Voucher.Rate, Voucher.Voucher, Voucher.DocNo, Voucher.RefType, Voucher.RefNo, Voucher.RefDate, Voucher.AccountNo, Admlink.Type, Admlink.Subject, Admlink.A_RefNo, Admlink.A_PolicyNo, Admlink.DocNo as A_DocNo, Admlink.ValueDesc as Info, '' as Extras, Profile.Name, V2.DueDate, Voucher.Remarks, Voucher.Date, Voucher.Currency, Voucher.ProAcc, Voucher.VType, Voucher.DebtorF, Voucher.CreditorF, Voucher.SL_Cat, V2.AmountDue, V2.AmountNextDue, V2." & sInstallmentInfo & " as sInstallment, Voucher.Nominal_CC, Voucher.Diff_CC, Voucher.Tax_CC, Voucher.Payment_CC+Voucher.Payment_OC as Payment_CC, Voucher.Branch,'' as Account, cast(0 as Smallint) as Hint"
                        Else
                            SQL = "Select C.Rate, Voucher.Voucher, Voucher.DocNo, Voucher.RefType, Voucher.RefNo, Voucher.RefDate, Voucher.AccountNo, Admlink.Type, Admlink.Subject, Admlink.A_RefNo, Admlink.A_PolicyNo, Admlink.DocNo as A_DocNo, Admlink.ValueDesc as Info, '' as Extras, Profile.Name, V2.DueDate, Voucher.Remarks, Voucher.Date, Voucher.Currency, Voucher.ProAcc, Voucher.VType, Voucher.DebtorF, Voucher.CreditorF, Voucher.SL_Cat, V2.AmountDue, V2.AmountNextDue, V2." & sInstallmentInfo & " as sInstallment, Voucher.Nominal_CC, Voucher.Diff_CC, Voucher.Tax_CC, Voucher.Payment_CC+Voucher.Payment_OC as Payment_CC, Voucher.Branch,'' as Account, cast(0 as Smallint) as Hint"
                        End If
                        SQL = SQL & " from nVoucher Voucher"
                        SQL = SQL & " INNER JOIN " & UDF & "('" & Format(Today.Date, "MM/DD/YYYY") & "') V2 on (V2.Voucher=Voucher.Voucher)"
                        SQL = SQL & " LEFT JOIN Admlink on (Admlink.Voucher=Voucher.Voucher)"
                        SQL = SQL & " INNER JOIN PROACC on (ProAcc.ProAcc=Voucher.ProAcc)"
                        SQL = SQL & " INNER JOIN Profile on (Profile.ID=ProAcc.ID)"
                        SQL = SQL & " INNER JOIN #Exchange C on (C.Currency=Voucher.Currency)"
                        SQL = SQL & " WHERE (Round(Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC,4)<>0)"
                        SQL = SQL & " and Voucher.Voucher='" & Voucher & "'"
                    ElseIf PolicyNo <> "" Or DocNo <> "" Or RefNo <> "" Or AccountNo <> "" Then
                        If CBool(toval(GetAppSetting("UseBookingRateWhenMatchingF"))) Then
                            SQL = "Select Voucher.Rate, Voucher.Voucher, Voucher.DocNo, Voucher.RefType, Voucher.RefNo, Voucher.RefDate, Voucher.AccountNo, Admlink.Type, Admlink.Subject, Admlink.A_RefNo, Admlink.A_PolicyNo, Admlink.DocNo as A_DocNo, Admlink.ValueDesc as Info, '' as Extras, Profile.Name, V2.DueDate, Voucher.Remarks, Voucher.Date, Voucher.Currency, Voucher.ProAcc, Voucher.VType, Voucher.DebtorF, Voucher.CreditorF, Voucher.SL_Cat, V2.AmountDue, V2.AmountNextDue, V2." & sInstallmentInfo & " as sInstallment, Voucher.Nominal_CC, Voucher.Diff_CC, Voucher.Tax_CC, Voucher.Payment_CC+Voucher.Payment_OC as Payment_CC, Voucher.Branch,'' as Account, cast(0 as Smallint) as Hint"
                        Else
                            SQL = "Select C.Rate, Voucher.Voucher, Voucher.DocNo, Voucher.RefType, Voucher.RefNo, Voucher.RefDate, Voucher.AccountNo, Admlink.Type, Admlink.Subject, Admlink.A_RefNo, Admlink.A_PolicyNo, Admlink.DocNo as A_DocNo, Admlink.ValueDesc as Info, '' as Extras, Profile.Name, V2.DueDate, Voucher.Remarks, Voucher.Date, Voucher.Currency, Voucher.ProAcc, Voucher.VType, Voucher.DebtorF, Voucher.CreditorF, Voucher.SL_Cat, V2.AmountDue, V2.AmountNextDue, V2." & sInstallmentInfo & " as sInstallment, Voucher.Nominal_CC, Voucher.Diff_CC, Voucher.Tax_CC, Voucher.Payment_CC+Voucher.Payment_OC as Payment_CC, Voucher.Branch,'' as Account, cast(0 as Smallint) as Hint"
                        End If
                        SQL = SQL & " from nVoucher Voucher"
                        SQL = SQL & " INNER JOIN " & UDF & "('" & Format(Today.Date, "MM/DD/YYYY") & "') V2 on (V2.Voucher=Voucher.Voucher)"
                        SQL = SQL & " LEFT JOIN Admlink on (Admlink.Voucher=Voucher.Voucher)"
                        SQL = SQL & " INNER JOIN PROACC on (ProAcc.ProAcc=Voucher.ProAcc)"
                        SQL = SQL & " INNER JOIN Profile on (Profile.ID=ProAcc.ID)"
                        SQL = SQL & " INNER JOIN #Exchange C on (C.Currency=Voucher.Currency)"
                        SQL = SQL & " WHERE (Round(Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC,4)<>0)"
                        If ID <> "" Then
                            SQL = SQL & " and Profile.ID='" & ID & "'"
                        End If
                        If PolicyNo <> "" Then
                            SQL = SQL & " and Admlink.A_PolicyNo Like '" & PolicyNo & "%'"
                        End If
                        If AccountNo <> "" Then
                            SQL = SQL & " and Admlink.RefType='VIRTUAL' and Admlink.AccountNo='" & AccountNo & "'"
                        End If
                        If DocNo <> "" Then
                            SQL = SQL & " and Admlink.DocNo='" & DocNo & "'"
                        End If
                        If RefNo <> "" Then
                            SQL = SQL & " and Admlink.RefNo='" & RefNo & "'"
                        End If
                        If TOC <> "" Then
                            SQL = SQL & " and Admlink.Code='" & TOC & "'"
                        End If
                        If sType <> "" Then
                            SQL = SQL & " and Admlink.Type='" & sType & "'"
                        End If
                        If Subject <> "" Then
                            SQL = SQL & " and Admlink.Subject ='" & Subject & "'"
                        End If
                        If AType <> "" Then
                            SQL = SQL & " and Admlink.Extra_4='" & AType & "'"
                        End If
                        If Currency <> "" Then
                            SQL = SQL & " and Admlink.Currency='" & Currency & "'"
                        End If
                    End If
                End If

                If SQL <> "" Then
                    If db.GetUserType <> "SUPERVISOR" Then
                        SQL = "Select A1.* from (" & SQL & ") A1"
                        If DebtorF Then
                            SQL = SQL & " Inner Join SysUserBranch on ( ((A1.Subject='Premium' and PremiumReceiveF=1) or (A1.Subject='Claim' and ClaimReceiveF=1) or (coalesce(A1.Subject,'')='' and SuspendReceiveF=1) or (A1.Subject='SURPLUS' and IncomeReceiveF=1) or (A1.Subject='OTHERS' and IncomeReceiveF=1)) and SysUserBranch.Branch=A1.Branch and SysUserBranch.ID='" & dbUser & "')"
                        Else
                            SQL = SQL & " Inner Join SysUserBranch on ( ((A1.Subject='Premium' and PremiumPaymentF=1) or (A1.Subject='Claim' and ClaimPaymentF=1) or (coalesce(A1.Subject,'')='' and SuspendPaymentF=1) or (A1.Subject='SURPLUS' and ExpensePaymentF=1) or (A1.Subject='OTHERS' and ExpensePaymentF=1)) and SysUserBranch.Branch=A1.Branch and SysUserBranch.ID='" & dbUser & "')"
                        End If

                        If Not db.GetPrivileges("ALLOWPASSUSERVTYPE") Then
                            SQL = SQL & " Inner Join SysUserVType on (SysUserVType.ID='" & dbUser & "' and SysUserVType.VType=A1.VType)"
                        End If

                        If Not (UCase(sType) = "RV" Or UCase(sType) = "PV") And Matching <> "RVPV" Then
                            Dim sFilter As String = ""
                            If Not ALLOWRIDISBURSE Then
                                If sFilter <> "" Then sFilter = sFilter & " and "
                                sFilter = sFilter & " A1.Type not in ('FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')"
                            End If

                            Select Case TypeList
                                Case "CN/DN", "Biz Source Comm", "Agent/Broker Comm", "Bank Comm", "Outward Facultative Premium", "Outward Facultative Claim", "Other Parties Fee", "Surplus Calculation", "Claim Payment ASO"
                                    If PaidOptionF And PolicyCompensation <> "1" Then
                                        CheckPaymentPCTF = True
                                    End If
                                Case Else
                                    CheckPaymentPCTF = False
                            End Select

                            If sFilter <> "" Then
                                SQL = SQL & " Where " & sFilter
                            End If

                            If CheckPaymentPCTF Then
                                SQL = "Select Distinct Case When ((A1.Type in ('DI','IC','IR','IT','IX','PD') and A1.Subject='Premium')) Then cast(100 as Float) else dbo.Get_Payment_Percentage(A1.A_PolicyNo, A1.Subject, A1.Type, A1.DocNo, A1.Date, A1.Currency, A1.DebtorF) end as PaymentPCT, A1.* from (" & SQL & ") A1"
                            Else
                                SQL = "Select Distinct cast(100 as Float) as PaymentPCT, A1.* from (" & SQL & ") A1"
                            End If
                        End If

                    End If
                    rs = db.OpenRemoteSet(SQL)

                    Dim TotalPaid As Double
                    Dim Paid As Double

                    Try
                        TotalPaid = toval(dsExcel.Tables(0).Rows(i)("Paid"))
                    Catch ex As Exception
                        TotalPaid = 0
                    End Try

                    Dim TotalOutstanding As Double = 0
                    If TotalPaid <> 0 Then
                        Do While Not rs.Eof
                            If Not ExcludeTaxF Then
                                TotalOutstanding = TotalOutstanding + IIf(rs.fields("DebtorF"), 1, -1) * (toval(rs.fields("Nominal_CC")) - toval(rs.fields("Diff_CC")) - toval(rs.fields("Payment_CC")))
                            Else
                                TotalOutstanding = TotalOutstanding + IIf(rs.fields("DebtorF"), 1, -1) * (toval(rs.fields("Nominal_CC")) - toval(rs.fields("Diff_CC")) - toval(rs.fields("Tax_CC")) - toval(rs.fields("Payment_CC")))
                            End If
                            rs.MoveNext()
                        Loop
                        rs.MoveFirst()
                    End If

                    If Not rs.Eof Then
                        Do While Not rs.Eof
                            If TotalPaid = 0 Then
                                If toval(rs.fields("AmountDue")) - toval(rs.fields("Payment_CC")) > 0 Then
                                    Paid = toval(rs.fields("AmountDue")) - toval(rs.fields("Payment_CC"))
                                Else
                                    Paid = toval(rs.fields("Nominal_CC")) - toval(rs.fields("Diff_CC")) - toval(rs.fields("Payment_CC"))
                                End If

                                If ExcludeTaxF Then
                                    Paid = Paid * (toval(rs.fields("Nominal_CC")) - toval(rs.fields("Diff_CC")) - toval(rs.fields("Tax_CC"))) / (toval(rs.fields("Nominal_CC")) - toval(rs.fields("Diff_CC")))
                                End If
                            Else
                                If Not ExcludeTaxF Then
                                    Paid = TotalPaid * IIf(rs.fields("DebtorF"), 1, -1) * (toval(rs.fields("Nominal_CC")) - toval(rs.fields("Diff_CC")) - toval(rs.fields("Payment_CC"))) / TotalOutstanding
                                Else
                                    Paid = TotalPaid * IIf(rs.fields("DebtorF"), 1, -1) * (toval(rs.fields("Nominal_CC")) - toval(rs.fields("Diff_CC")) - toval(rs.fields("Tax_CC")) - toval(rs.fields("Payment_CC"))) / TotalOutstanding
                                End If
                                If rs.fields("CreditorF") Then Paid = -Paid
                                If Not ExcludeTaxF Then
                                    If Paid > toval(rs.fields("Nominal_CC")) - toval(rs.fields("Diff_CC")) - toval(rs.fields("Payment_CC")) Then
                                        Paid = toval(rs.fields("Nominal_CC")) - toval(rs.fields("Diff_CC")) - toval(rs.fields("Payment_CC"))
                                    End If
                                Else
                                    If Paid > (toval(rs.fields("Nominal_CC")) - toval(rs.fields("Diff_CC")) - toval(rs.fields("Payment_CC"))) * (toval(rs.fields("Nominal_CC")) - toval(rs.fields("Diff_CC")) - toval(rs.fields("Tax_CC"))) / (toval(rs.fields("Nominal_CC")) - toval(rs.fields("Diff_CC"))) Then
                                        Paid = (toval(rs.fields("Nominal_CC")) - toval(rs.fields("Diff_CC")) - toval(rs.fields("Payment_CC"))) * (toval(rs.fields("Nominal_CC")) - toval(rs.fields("Diff_CC")) - toval(rs.fields("Tax_CC"))) / (toval(rs.fields("Nominal_CC")) - toval(rs.fields("Diff_CC")))
                                    End If
                                End If
                            End If
                            Rate = 0
                            Try
                                Rate = toval(dsExcel.Tables(0).Rows(i)("Rate"))
                            Catch ex As Exception
                            End Try
                            If Rate = 0 Then
                                Rate = toval(rs.fields("Rate"))
                            End If
                            Try
                                NewRow = Dataset.Tables(0).NewRow
                                NewRow("ProcessFlag") = True
                                NewRow("PaymentPCT") = toval(rs.fields("PaymentPCT"))
                                NewRow("Voucher") = tostr(rs.fields("Voucher"))
                                NewRow("Date") = todate(rs.fields("Date"))
                                NewRow("Rate") = Rate
                                NewRow("Currency") = tostr(rs.fields("Currency"))
                                NewRow("ProAcc") = tostr(rs.fields("ProAcc"))
                                NewRow("DebtorF") = toval(rs.fields("DebtorF"))
                                NewRow("CreditorF") = toval(rs.fields("CreditorF"))
                                NewRow("SL_Cat") = tostr(rs.fields("SL_Cat"))
                                NewRow("Branch") = tostr(rs.fields("Branch"))
                                NewRow("RefNo") = tostr(rs.fields("RefNo"))
                                NewRow("RefDate") = todate(rs.fields("RefDate"))
                                NewRow("A_PolicyNo") = tostr(rs.fields("A_PolicyNo"))
                                NewRow("A_DocNo") = tostr(rs.fields("A_DocNo"))
                                NewRow("DocNo") = tostr(rs.fields("DocNo"))
                                NewRow("VType") = tostr(rs.fields("VType"))
                                NewRow("Remarks") = tostr(rs.fields("Remarks"))
                                NewRow("RefType") = tostr(rs.fields("RefType"))
                                NewRow("AccountNo") = tostr(rs.fields("AccountNo"))
                                NewRow("A_RefNo") = tostr(rs.fields("A_RefNo"))
                                NewRow("Type") = tostr(rs.fields("Type"))
                                NewRow("Subject") = tostr(rs.fields("Subject"))
                                NewRow("Name") = tostr(rs.fields("Name"))
                                NewRow("sInstallment") = tostr(rs.fields("sInstallment"))
                                NewRow("AName") = ""
                                NewRow("Account") = tostr(rs.fields("Account"))
                                NewRow("Hint") = tostr(rs.fields("Hint"))
                                NewRow("CollNo") = ""
                                NewRow("AmountPaid") = toval(Paid)
                                NewRow("AmountDue") = toval(rs.fields("AmountDue"))
                                NewRow("AmountNextDue") = toval(rs.fields("AmountNextDue"))
                                NewRow("Nominal") = toval(rs.fields("Nominal_CC")) - toval(rs.fields("Diff_CC"))
                                NewRow("Tax") = toval(rs.fields("Tax_CC"))
                                NewRow("OutStanding") = toval(rs.fields("Nominal_CC")) - toval(rs.fields("Diff_CC")) - toval(rs.fields("Payment_CC"))
                                NewRow("Payment") = toval(rs.fields("Payment_CC"))
                                NewRow("AmountPaidLocked") = 0
                                NewRow("LockedF") = 0
                                NewRow("FundingF") = IIf(FundingF, 1, 0)
                                NewRow("Info") = tostr(rs.fields("Info"))
                                NewRow("Extras") = tostr(rs.fields("Extras"))
                                Dataset.Tables(0).Rows.Add(NewRow)
                            Catch ex As Exception

                            End Try
                            rs.MoveNext()
                        Loop
                        dsExcel.Tables(0).Rows(i)("Status") = "U"
                        dsExcel.Tables(0).Rows(i)("Message") = "Data Uploaded !"
                    Else
                        dsExcel.Tables(0).Rows(i)("Status") = ""
                        dsExcel.Tables(0).Rows(i)("Message") = "Data Not Found !"
                    End If
                Else
                    dsExcel.Tables(0).Rows(i)("Status") = ""
                    dsExcel.Tables(0).Rows(i)("Message") = "Column(s) need for data query not filled !"
                End If
                dsExcel.Tables(0).Rows(i)("ProcessFlag") = True
            Next
            If Not db.Execute("Drop Table #Exchange") Then Throw New Exception(db.ErrDesc)
            If Dataset Is Nothing Then Throw New Exception(ErrMsg)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function LoadAccountFromExcel(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef dsExcel As DataSet, ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            Dim VoucherDate As Date
            Dim VType As String
            Dim HComAcc As String
            Dim CCY As String
            Dim HBranch As String
            Dim RefCCYDate As Date
            Dim HCT As String

            VoucherDate = todate(getInParamValue(InParam, 0))
            VType = getInParamValue(InParam, 1)
            HComAcc = getInParamValue(InParam, 2)
            CCY = getInParamValue(InParam, 3)
            HBranch = getInParamValue(InParam, 4)
            If tostr(getInParamValue(InParam, 5)) = "" Then
                RefCCYDate = todate(getInParamValue(InParam, 0))
            Else
                RefCCYDate = todate(getInParamValue(InParam, 5))
            End If
            HCT = getInParamValue(InParam, 6)

            Dim SQL As String
            Dim Doc_No As String
            Dim GID As String
            Dim Description As string
            Dim Account As String
            Dim ComAcc As String
            Dim Branch As String
            Dim CT As String
            Dim Remarks As String
            Dim Doc_CCY As String
            Dim Nominal_OC As Double
            Dim Hint As Integer
            Dim Nominator As Double
            Dim Denominator As Double
            Dim Nominal_CC As Double
            Dim Diff_CC As Double

            Dim NewRow As DataRow
            Dim rs As RemoteSet
            Dim Code As String
            Dim DebtorF As Boolean

            If Dataset Is Nothing Then Throw New Exception("Dataset is not yet Initialized !")

            rs = db.OpenRemoteSet("Select Code, DebtorF from VType Where VType='" & VType & "'")
            Code = rs.fields("Code")
            DebtorF = toval(rs.fields("DebtorF"))

            Nominal_CC = 0
            Diff_CC = 0
            db.Execute("Drop Table #Exchange")
            If Not db.Execute("Select * into #Exchange from fn_Exchange('" & Format(RefCCYDate, "MM/DD/YYYY") & "') C") Then Throw New Exception(db.ErrDesc)
            For i = 0 To dsExcel.Tables(0).Rows.Count - 1

                SQL = ""
                Account = ""
                ComAcc = ""
                Branch = ""
                CT = ""
                Remarks = ""
                Doc_CCY = ""
                Nominal_OC = 0

                Doc_No = tostr(GetItemValue("Doc_No", dsExcel, i))
                GID = tostr(GetItemValue("GID", dsExcel, i))
                Description = tostr(GetItemValue("Description", dsExcel, i))
                Account = tostr(GetItemValue("Account", dsExcel, i))
                ComAcc = tostr(GetItemValue("ComAcc", dsExcel, i))
                Branch = tostr(GetItemValue("Branch", dsExcel, i))
                If Branch = "" Then Branch = HBranch
                CT = tostr(GetItemValue("CT", dsExcel, i))
                If CT = "" Then CT = HCT
                Remarks = tostr(GetItemValue("Remarks", dsExcel, i))
                Doc_CCY = tostr(GetItemValue("Doc_Ccy", dsExcel, i))
                Nominal_OC = toval(GetItemValue("Nominal_OC", dsExcel, i))

                If Account <> "" And Nominal_OC <> 0 Then

                    If Code.ToUpper = "INTERBANK" Then
                        If Branch <> "" Then
                            rs = db.OpenRemoteSet("Select Branch from FL_UserBranch('" & dbUser & "','" & Branch & "') Where Branch='" & Branch & "'")
                            If rs.Eof Then
                                Throw New Exception("Incorrect Branch Code : " & Branch & " at Line : " & i + 1)
                            End If
                        End If

                        If CT <> "" Then
                            rs = db.OpenRemoteSet("Select CT from FN_UserCT('" & dbUser & "','" & Branch & "','" & Account & "') Where Post_Flag=1 and AllowedF=1 and CT='" & CT & "'")
                            If rs.Eof Then
                                Throw New Exception("Incorrect Profit/Cost Code : " & CT & " at Line : " & i + 1)
                            End If
                        End If
                        If ComAcc <> "" Then
                            rs = db.OpenRemoteSet("Select ComAcc, Currency, Hint, Account, Description from FL_SL_COMACC('" & VType & "','" & dbUser & "','" & Branch & "','" & HComAcc & "') SL Where RestrictedF = 0 and ComAcc='" & ComAcc & "'")
                            If rs.Eof Then
                                Throw New Exception("Incorrect Company Account No. : " & ComAcc & " at Line : " & i + 1)
                            End If
                            Doc_CCY = rs.fields("Currency")
                        Else
                            rs = db.OpenRemoteSet("Select Hint, Account, Description from FL_SL_Account('" & dbUser & "','" & Format(VoucherDate, "MM/DD/YYYY") & "','" & Branch & "','" & CT & "','','','" & VType & "','" & HComAcc & "','','" & CCY & "',0) SL Where Open_ItemF=0 and Account='" & Account & "'")
                            If rs.Eof Then
                                Throw New Exception("Incorrect Account No. : " & Account & " at Line : " & i + 1)
                            End If
                        End If
                    Else
                        If GID <> "" Then
                            rs = db.OpenRemoteSet("Select GID, Description from FL_Budget_AccountGroup('" & HBranch & "','" & HCT & "') Where GID='" & GID & "'")
                            If rs.Eof Then
                                Throw New Exception("Incorrect Budget Group : " & GID & " at Line : " & i + 1)
                            End If
                            If Description = "" Then Description = rs.fields("Description")

                            rs = db.OpenRemoteSet("Select Hint, Account, Description from FL_SL_Account('" & dbUser & "','" & Format(VoucherDate, "MM/DD/YYYY") & "','" & Branch & "','" & CT & "','" & GID & "','','" & VType & "','" & HComAcc & "','','" & CCY & "',0) SL Where Account='" & Account & "'")
                            If rs.Eof Then
                                Throw New Exception("Incorrect Account No. : " & Account & " at Line : " & i + 1)
                            End If
                        Else
                            If Branch <> "" Then
                                rs = db.OpenRemoteSet("Select Branch from FL_UserBranchAccountIO('" & dbUser & "','" & Branch & "','" & Account & "'," & IIf(DebtorF, "1", "0") & ") Where Branch='" & Branch & "'")
                                If rs.Eof Then
                                    Throw New Exception("Incorrect Branch Code : " & Branch & " at Line : " & i + 1)
                                End If
                            End If

                            If CT <> "" Then
                                rs = db.OpenRemoteSet("Select CT from FN_UserCT('" & dbUser & "','" & Branch & "','" & Account & "') Where Post_Flag=1 and AllowedF=1 and CT='" & CT & "'")
                                If rs.Eof Then
                                    Throw New Exception("Incorrect Profit/Cost Code : " & CT & " at Line : " & i + 1)
                                End If
                            End If

                            rs = db.OpenRemoteSet("Select Hint, Account, Description from FL_SL_Account('" & dbUser & "','" & Format(VoucherDate, "MM/DD/YYYY") & "','" & Branch & "','" & CT & "','" & GID & "','','" & VType & "','" & HComAcc & "','','" & CCY & "',0) SL Where Account='" & Account & "'")
                            If rs.Eof Then
                                Throw New Exception("Incorrect Account No. : " & Account & " at Line : " & i + 1)
                            End If
                        End If
                    End If

                    Hint = rs.fields("Hint")
                    Account = rs.fields("Account")
                    If Remarks = "" Then Remarks = rs.fields("Description")
                    If Doc_CCY = "" Then Doc_CCY = CCY

                    If Doc_CCY = CCY Then
                        Nominator = 1
                        Denominator = 1
                    Else
                        Dim Rate As Double

                        rs = db.OpenRemoteSet("Select Rate from #Exchange Where Currency='" & Doc_CCY & "'")
                        Rate = toval(rs.fields("Rate"))
                        rs = db.OpenRemoteSet("Select Rate from #Exchange Where Currency='" & CCY & "'")
                        Rate = Rate / toval(rs.fields("Rate"))
                        If Rate > 1 Then
                            Nominator = Math.Round(Rate, 4, MidpointRounding.AwayFromZero)
                            Denominator = 1
                        Else
                            Nominator = 1
                            Denominator = Math.Round(1 / Rate, 4, MidpointRounding.AwayFromZero)
                        End If
                    End If
                    If Code.ToUpper = "INTERBANK" Then
                        NewRow = Dataset.Tables(0).NewRow
                        NewRow("Branch") = Branch
                        NewRow("OBranch") = Branch
                        NewRow("ComAcc") = ComAcc
                        NewRow("OComAcc") = ComAcc
                        NewRow("Doc_No") = IIf(ComAcc <> "", "", Account)
                        NewRow("Hint") = Hint
                        NewRow("Account") = Account
                        NewRow("CT") = ""
                        NewRow("Doc_Date") = VoucherDate
                        NewRow("Doc_Ccy") = Doc_CCY
                        NewRow("Remarks") = Remarks
                        NewRow("Nominal_OC") = Nominal_OC
                        NewRow("Nominator") = Nominator
                        NewRow("Denominator") = Denominator
                        NewRow("Nominal") = Nominal_OC * Nominator / Denominator
                        NewRow("PaymentF") = IIf(ComAcc <> "", True, False)
                        NewRow("LockedF") = False
                        NewRow("FundingF") = False
                        NewRow("GID") = ""
                        NewRow("Description") = ""
                    Else
                        NewRow = Dataset.Tables(0).NewRow
                        If Code.ToUpper = "ASSET" Then
                            NewRow("Doc_No") = Doc_No
                        Else
                            NewRow("Doc_No") = If(Doc_No = "", Account, Doc_No)
                        End If
                        NewRow("Hint") = Hint
                        NewRow("Account") = Account
                        NewRow("Branch") = Branch
                        NewRow("CT") = CT
                        NewRow("Doc_Date") = VoucherDate
                        NewRow("Doc_Ccy") = Doc_CCY
                        NewRow("Remarks") = Remarks
                        NewRow("Nominal_OC") = Nominal_OC
                        NewRow("Nominator") = Nominator
                        NewRow("Denominator") = Denominator
                        NewRow("Nominal") = Nominal_OC * Nominator / Denominator
                        NewRow("PaymentF") = False
                        NewRow("LockedF") = False
                        NewRow("FundingF") = False
                        NewRow("GID") = GID
                        NewRow("Description") = Description
                    End If
                    Dataset.Tables(0).Rows.Add(NewRow)

                    If Nominal_OC * Nominator / Denominator > 0 Then
                        Nominal_CC = Nominal_CC + Nominal_OC * Nominator / Denominator
                    Else
                        Diff_CC = Diff_CC - Nominal_OC * Nominator / Denominator
                    End If
                End If

            Next
            If Not db.Execute("Drop Table #Exchange") Then Throw New Exception(db.ErrDesc)

            ' Set Output Parameter
            ReDim OutParam(1)
            OutParam(0) = Nominal_CC
            OutParam(1) = Diff_CC


            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function LoadRequestFromExcel(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef dsExcel As DataSet, ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            Dim SQL As String
            Dim Request As String
            Dim rs As RemoteSet

            For i = 0 To dsExcel.Tables(0).Rows.Count - 1
                SQL = ""
                Request = ""
                Try
                    Request = tostr(dsExcel.Tables(0).Rows(i)("Request"))
                Catch ex As Exception
                End Try

                If Request <> "" Then
                    SQL = "Select Cast(0 as bit) as ProcessFlag, R.Request, R.DebtorF, R.CreditorF, R.Voucher, R.Branch, R.RefNo, R.RefDate, R.DocNo, R.RefType, R.AccountNo, R.Date, R.DueDate, R.Vtype, VType.Description as VTypeDesc, R.SL_Cat, R.Status, "
                    SQL = SQL & " R.Remarks, R.ProAcc, P.Description as PDescription, R.ComAcc, C.Description as CDescription, R.Currency, R.Nominal_CC-R.Diff_CC as Nominal, R.Last_Date, R.Last_Opr"
                    SQL = SQL & " from Request R Inner Join fn_userVType('" & dbUser & "') VType on (VType.VType=R.VType) Left Join ProAcc P on (P.ProAcc=R.ProAcc) Left Join ComAcc C on (C.ComAcc=R.ComAcc) "
                    SQL = SQL & " Where R.SL_Cat='P' and R.CreditorF=1"
                    SQL = SQL & " and R.Request='" & Request & "'"
                    rs = db.OpenRemoteSet(SQL)
                    Dim ds As DataSet = rs.GetDataSet

                    If ds.Tables(0).Rows.Count <> 0 Then
                        If Dataset Is Nothing Then
                            Dataset = ds.Clone
                        End If
                        Dim NewRow As DataRow = Dataset.Tables(0).NewRow
                        For j = 0 To Dataset.Tables(0).Columns.Count - 1
                            NewRow(Dataset.Tables(0).Columns(j).ColumnName) = ds.Tables(0).Rows(0)(Dataset.Tables(0).Columns(j).ColumnName)
                        Next
                        NewRow("ProcessFlag") = True
                        Dataset.Tables(0).Rows.Add(NewRow)
                    End If
                End If
            Next

            ' Set Output Parameter

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function

    Private Function Const_Additional_Filter(ByVal InParam As Object(), ByVal TAlias1 As String, ByVal TAlias2 As String) As String
        ' Get Input Parameter
        Dim Voucher As String = getInParamValue(InParam, 0)      ' Source Voucher
        Dim Currency As String = getInParamValue(InParam, 6)
        Dim Remarks As String = getInParamValue(InParam, 7)
        Dim SDate As String = getInParamValue(InParam, 8)    ' Formatted Date MM/DD/YYYY
        Dim EDate As String = getInParamValue(InParam, 9)    ' Formatted Date MM/DD/YYYY
        Dim sRefNo As String = getInParamValue(InParam, 10)
        Dim lRefNo As String = getInParamValue(InParam, 11)
        Dim sDocNo As String = getInParamValue(InParam, 12)
        Dim lDocNo As String = getInParamValue(InParam, 13)
        Dim sODocNo As String = getInParamValue(InParam, 14)
        Dim lODocNo As String = getInParamValue(InParam, 15)
        Dim sVoucher As String = getInParamValue(InParam, 16)
        Dim lVoucher As String = getInParamValue(InParam, 17)
        Dim sAccountNo As String = getInParamValue(InParam, 18)
        Dim lAccountNo As String = getInParamValue(InParam, 19)
        Dim RefType As String = getInParamValue(InParam, 20)
        Dim BatchNo As String = getInParamValue(InParam, 21)

        Dim sfilter As String = ""
        If Currency <> "" Then
            sfilter = sfilter & " and " & TAlias1 & ".Currency='" & Currency & "'"
        End If

        If Remarks <> "" Then
            sfilter = sfilter & " and " & TAlias1 & ".Remarks like " & "'%" & Remarks & "%'"
        End If

        If SDate <> "" Then
            sfilter = sfilter & " and " & TAlias1 & ".Date>='" & SDate & "'"
        End If

        If EDate <> "" Then
            sfilter = sfilter & " and " & TAlias1 & ".Date<='" & EDate & "'"
        End If

        If RefType <> "" Then
            sfilter = sfilter & " and " & TAlias1 & ".RefType='" & RefType & "'"
        End If

        If sRefNo <> "" Then
            If lRefNo <> "" Then
                sfilter = sfilter & " and " & TAlias1 & ".RefNo between '" & sRefNo & "' and '" & lRefNo & "'"
            Else
                sfilter = sfilter & " and " & TAlias1 & ".RefNo like " & "'" & sRefNo & "%'"
            End If
        Else
            If lRefNo <> "" Then
                sfilter = sfilter & " and " & TAlias1 & ".RefNo like " & "'" & lRefNo & "%'"
            End If
        End If

        If sDocNo <> "" Then
            If lDocNo <> "" Then
                sfilter = sfilter & " and " & TAlias1 & ".DocNo between '" & sDocNo & "' and '" & lDocNo & "'"
            Else
                sfilter = sfilter & " and " & TAlias1 & ".DocNo like " & "'" & sDocNo & "%'"
            End If
        Else
            If lDocNo <> "" Then
                sfilter = sfilter & " and " & TAlias1 & ".DocNo like " & "'" & lDocNo & "%'"
            End If
        End If

        If sVoucher <> "" Then
            If lVoucher <> "" Then
                sfilter = sfilter & " and " & TAlias1 & ".Voucher between '" & sVoucher & "' and '" & lVoucher & "'"
            Else
                sfilter = sfilter & " and " & TAlias1 & ".Voucher like " & "'" & sVoucher & "%'"
            End If
        Else
            If lVoucher <> "" Then
                sfilter = sfilter & " and " & TAlias1 & ".Voucher like " & "'" & lVoucher & "%'"
            End If
        End If

        If sAccountNo <> "" Then
            If lAccountNo <> "" Then
                sfilter = sfilter & " and " & TAlias1 & ".AccountNo between '" & sAccountNo & "' and '" & lAccountNo & "'"
            Else
                sfilter = sfilter & " and " & TAlias1 & ".AccountNo like " & "'" & sAccountNo & "%'"
            End If
        Else
            If lAccountNo <> "" Then
                sfilter = sfilter & " and " & TAlias1 & ".AccountNo like " & "'" & lAccountNo & "%'"
            End If
        End If

        If sODocNo <> "" Then
            If lODocNo <> "" Then
                sfilter = sfilter & " and coalesce(" & TAlias2 & ".A_RefNo,'') between '" & sODocNo & "' and '" & lODocNo & "'"
            Else
                sfilter = sfilter & " and coalesce(" & TAlias2 & ".A_RefNo,'') like " & "'" & sODocNo & "%'"
            End If
        Else
            If lODocNo <> "" Then
                sfilter = sfilter & " and coalesce(" & TAlias2 & ".A_RefNo,'') like " & "'" & lODocNo & "%'"
            End If
        End If

        If BatchNo <> "" Then
            sfilter = sfilter & " and coalesce(" & TAlias2 & ".BatchNo,'') Like '" & BatchNo & "%'"
        End If
        Return sfilter
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function RetrieveDocument(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal DSS As DataSet, ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim VoucherDate As Date = getInParamValue(InParam, 0)    ' Source VoucherDate
            Dim TypeList As String = getInParamValue(InParam, 1)     ' TypeList Selection
            Dim sSL_Cat As String = getInParamValue(InParam, 2)      ' Source SL_Cat
            Dim VType As String = getInParamValue(InParam, 3)        ' Source Voucher Type
            Dim DebtorF As Boolean = getInParamValue(InParam, 4)     ' Source DebtorF or CreditorF
            Dim CCY As String = getInParamValue(InParam, 5)          ' Source Currency Voucher
            Dim pVoucher As String = getInParamValue(InParam, 6)     ' Payment Voucher of Adjustment When sSL_Cat='A'
            Dim BookRate As Double = getInParamValue(InParam, 7)     ' Booking Rate

            Dim i As Integer
            Dim Voucher As String
            Dim Branch As String
            Dim CT As String
            Dim SL_Cat As String
            Dim CollNo As String
            Dim Account As String
            Dim Hint As Integer
            Dim LockedF As Boolean
            Dim FundingF As Boolean
            Dim Info As String
            Dim BankName As String
            Dim BankAccount As String
            Dim AccountNo As String
            Dim A_PolicyNo As String
            Dim A_DocNo As String
            Dim OCCY As String
            Dim Rate As Double
            Dim TNominal As Double
            Dim TDiff As Double
            TNominal = 0
            TDiff = 0
            OCCY = ""
            Account = ""

            Dim TempNominal As Double = 0
            Dim TempDiff As Double = 0

            'i = 0
            'While i < Dataset.Tables(0).Rows.Count
            '    If tostr(Dataset.Tables(0).Rows(i)("Doc_No")) = "" Or tostr(Dataset.Tables(0).Rows(i)("Account")) = "" Or toval(Dataset.Tables(0).Rows(i)("Hint")) = 0 Then
            '        If toval(Dataset.Tables(0).Rows(i)("Nominal")) < 0 Then
            '            TempDiff = TempDiff - toval(Dataset.Tables(0).Rows(i)("Nominal"))
            '        Else
            '            TempNominal = TempNominal + toval(Dataset.Tables(0).Rows(i)("Nominal"))
            '        End If
            '        Dataset.Tables(0).Rows.RemoveAt(i)
            '    Else
            '        i = i + 1
            '    End If
            'End While

            For i = 0 To DSS.Tables(0).Rows.Count - 1
                If DSS.Tables(0).Rows(i)("ProcessFlag") = True Then
                    Voucher = tostr(DSS.Tables(0).Rows(i)("Voucher"))
                    Branch = tostr(DSS.Tables(0).Rows(i)("Branch"))
                    SL_Cat = tostr(DSS.Tables(0).Rows(i)("SL_Cat"))
                    CollNo = tostr(DSS.Tables(0).Rows(i)("CollNo"))
                    Account = tostr(DSS.Tables(0).Rows(i)("Account"))
                    Hint = toval(DSS.Tables(0).Rows(i)("Hint"))
                    LockedF = toval(DSS.Tables(0).Rows(i)("LockedF"))
                    FundingF = toval(DSS.Tables(0).Rows(i)("FundingF"))
                    Info = tostr(DSS.Tables(0).Rows(i)("Info"))
                    A_PolicyNo = tostr(DSS.Tables(0).Rows(i)("A_PolicyNo"))
                    A_DocNo = tostr(DSS.Tables(0).Rows(i)("A_DocNo"))
                    CT = ""
                    BankName = ""
                    BankAccount = ""
                    AccountNo = ""
                    'Hint
                    Dim rsHint As RemoteSet
                    Dim SQL As String
                    If sSL_Cat <> "A" And (Account = "" Or Hint = 0) Then
                        If TypeList = "<All>" Then
                            If SL_Cat <> "" Then
                                If SL_Cat = "P" Then
                                    SQL = "Select Top 1 A1.Hint, A1.Account,'' as CT, '' as BankName, '' as BankAccount, '' as AccountNo from get_Open_Item_P('" & Voucher & "') a1 Where A1.Branch='" & Branch & "' "
                                Else
                                    SQL = "Select Top 1 A1.Hint, A1.Account, A1.CT, '' as BankName, '' as BankAccount, '' as AccountNo from (Select TOP 1 nSL.Hint, nSL.Account, nVoucher.Branch, nVoucher.CT from nSL, nVoucher Where nVoucher.SL_Tag=0 and nVoucher.Voucher=nSL.Voucher and nVoucher.Voucher='" & Voucher & "' order by nSL.Hint Desc) a1 Where A1.Branch='" & Branch & "' "
                                End If
                            Else
                                SQL = "Select Top 1 A1.Hint, A1.Account, '' as CT, '' as BankName, '' as BankAccount, '' as AccountNo from Get_Open_Item_Hint('" & Voucher & "','" & VType & "') a1 Left Join Open_Item_Allocated('" & Voucher & "') SL_Alloc on (SL_Alloc.Voucher<>'" & Voucher & "' and SL_Alloc.Doc_no=A1.Voucher and SL_Alloc.Branch=A1.Branch and SL_Alloc.Account=A1.Account) Where A1.Branch='" & Branch & "' Group By A1.Hint, A1.Account, A1.Branch having round(Max(A1.Nominal_OC),4)<>round(sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end),4)"
                            End If
                        Else
                            If SL_Cat = "P" Then
                                SQL = "Select Top 1 A1.Hint, A1.Account, '' as CT, '' as BankName, '' as BankAccount, '' as AccountNo from get_Open_Item_P('" & Voucher & "') a1 Where A1.Branch='" & Branch & "' "
                                'ElseIf TypeList = "Withholding Tax" And SL_Cat <> "P" Then
                                '    SQL = "Select Top 1 A1.Hint, A1.Account, A1.CT from get_Open_Item_T('" & Voucher & "') a1 Where A1.Branch='" & Branch & "' "
                                'ElseIf TypeList = "Investment" And SL_Cat <> "P" Then
                                '    SQL = "Select Top 1 A1.Hint, A1.Account, A1.CT from get_Open_Item_I('" & Voucher & "') a1 Where A1.Branch='" & Branch & "' "
                            ElseIf TypeList = "CN/DN Manual" And SL_Cat <> "P" Then
                                SQL = "Select Top 1 A1.Hint, A1.Account, A1.CT, '' as BankName, '' as BankAccount, '' as AccountNo from get_Open_Item_M('" & Voucher & "') a1 Where A1.Branch='" & Branch & "' "
                            Else
                                SQL = "Select Top 1 A1.Hint, A1.Account, A1.CT, A1.BankName, A1.BankAccount, A1.AccountNo from (Select TOP 1 nSL.Hint, nSL.Account, nVoucher.Branch, nVoucher.CT, nVoucher.BankName, nVoucher.BankAccount, nVoucher.AccountNo from nSL, nVoucher Where nVoucher.SL_Tag=0 and nVoucher.Voucher=nSL.Voucher and nVoucher.Voucher='" & Voucher & "' order by nSL.Hint Desc) a1 Where A1.Branch='" & Branch & "' "
                            End If
                        End If
                        If Account <> "" Then
                            SQL = SQL & " and A1.Account='" & Account & "'"
                        End If
                        rsHint = db.OpenRemoteSet(SQL, adOpenForwardonly)
                        Account = tostr(rsHint.fields("Account"))
                        Hint = toval(rsHint.fields("Hint"))
                        CT = tostr(rsHint.fields("CT"))
                        BankName = tostr(rsHint.fields("BankName"))
                        BankAccount = tostr(rsHint.fields("BankAccount"))
                        AccountNo = tostr(rsHint.fields("AccountNo"))
                    End If

                    Dim Description As String
                    Dim Nominal_CC As Double
                    Dim CreditorF As Boolean
                    Dim Nominator As Double
                    Dim Denominator As Double
                    Dim Doc_Date As Date

                    If Account <> "" And Hint <> 0 Then
                        Doc_Date = todate(DSS.Tables(0).Rows(i)("Date"))
                        Description = tostr(DSS.Tables(0).Rows(i)("DocNo")) & "-" & tostr(DSS.Tables(0).Rows(i)("RefNo"))
                        If tostr(DSS.Tables(0).Rows(i)("AName")) <> "" Then
                            Description = Description & "-" & tostr(DSS.Tables(0).Rows(i)("AName"))
                        Else
                            Description = Description & "-" & tostr(DSS.Tables(0).Rows(i)("Remarks")) & tostr(DSS.Tables(0).Rows(i)("sInstallment"))
                        End If

                        CreditorF = toval(DSS.Tables(0).Rows(i)("CreditorF"))
                        Nominal_CC = toval(DSS.Tables(0).Rows(i)("AmountPaid"))

                        Select Case sSL_Cat
                            Case "C"    ' Compensation
                                If DebtorF Then ' Debit Compensation
                                    If CreditorF = True Then
                                        Nominal_CC = Nominal_CC
                                    Else
                                        Nominal_CC = -Nominal_CC
                                    End If
                                Else            ' Credit Compensation
                                    If CreditorF = False Then
                                        Nominal_CC = Nominal_CC
                                    Else
                                        Nominal_CC = -Nominal_CC
                                    End If
                                End If
                            Case "A"    ' Adjustment
                                Nominal_CC = Nominal_CC
                            Case "O"    ' Overpaid
                                If DebtorF Then ' Receipt Overpaid
                                    If CreditorF = True Then
                                        Nominal_CC = -Nominal_CC
                                    Else
                                        Nominal_CC = Nominal_CC
                                    End If
                                Else    ' Payment Overpaid
                                    If CreditorF = False Then
                                        Nominal_CC = -Nominal_CC
                                    Else
                                        Nominal_CC = Nominal_CC
                                    End If
                                End If
                            Case Else
                                If DebtorF Then
                                    If SL_Cat <> "P" Then
                                        If CreditorF = True Then
                                            Nominal_CC = -Nominal_CC
                                        Else
                                            Nominal_CC = Nominal_CC
                                        End If
                                    Else
                                        If CreditorF = True Then
                                            Nominal_CC = Nominal_CC
                                        Else
                                            Nominal_CC = -Nominal_CC
                                        End If
                                    End If
                                Else
                                    If SL_Cat <> "P" Then
                                        If CreditorF = False Then
                                            Nominal_CC = -Nominal_CC
                                        Else
                                            Nominal_CC = Nominal_CC
                                        End If
                                    Else
                                        If CreditorF = False Then
                                            Nominal_CC = Nominal_CC
                                        Else
                                            Nominal_CC = -Nominal_CC
                                        End If
                                    End If
                                End If
                        End Select

                        OCCY = tostr(DSS.Tables(0).Rows(i)("Currency"))
                        If OCCY = CCY Then
                            Rate = 1
                        Else
                            Rate = toval(DSS.Tables(0).Rows(i)("Rate")) / BookRate
                        End If
                        If Rate > 1 Then
                            Nominator = Math.Round(Rate, 4, MidpointRounding.AwayFromZero)
                            Denominator = 1
                        Else
                            Nominator = 1
                            Denominator = Math.Round(1 / Rate, 4, MidpointRounding.AwayFromZero)
                        End If

                        Dim NewRow As DataRow = Dataset.Tables(0).NewRow

                        Nominal_CC = RoundCCY(Nominal_CC, UCase(OCCY), toval(GetAppSetting("FARoundingDecimalValue")))
                        Dim Nominal As Double = RoundCCY(Math.Round(Nominal_CC * Nominator / Denominator, 4, MidpointRounding.AwayFromZero), UCase(CCY), toval(GetAppSetting("FARoundingDecimalValue")))

                        NewRow("ProcessFlag") = 0
                        NewRow("Doc_No") = Voucher
                        NewRow("Doc_Date") = Doc_Date
                        NewRow("Doc_CCY") = OCCY
                        NewRow("Nominal_OC") = Nominal_CC
                        NewRow("CT") = CT
                        NewRow("Nominal") = Nominal
                        NewRow("Remarks") = Description
                        NewRow("Hint") = Hint
                        NewRow("PaymentF") = True
                        NewRow("Account") = Account
                        NewRow("Nominator") = Nominator
                        NewRow("Denominator") = Denominator
                        NewRow("Branch") = Branch
                        NewRow("pVoucher") = CollNo
                        NewRow("LockedF") = LockedF
                        NewRow("FundingF") = FundingF

                        ' Only for PQ/PV
                        If sSL_Cat = "P" AndAlso Not DebtorF Then
                            NewRow("BankName") = BankName
                            NewRow("BankAccount") = BankAccount
                            NewRow("AccountNo") = AccountNo
                        End If
                        NewRow("Info") = Info
                        NewRow("A_PolicyNo") = A_PolicyNo
                        NewRow("A_DocNo") = A_DocNo
                        Dataset.Tables(0).Rows.Add(NewRow)

                        If Nominal > 0 Then
                            TNominal = TNominal + Nominal
                        Else
                            TDiff = TDiff - (Nominal)
                        End If
                    End If

                End If
            Next

            ' Set Output Parameter
            ReDim OutParam(1)
            OutParam(0) = TNominal - TempNominal
            OutParam(1) = TDiff - TempDiff


            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function ApproveVoucherTR(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Voucher = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            Dim BudgetFeaturesF As Boolean
            rs = db.OpenRemoteSet("Select BudgetFeaturesF from SysTab")
            BudgetFeaturesF = rs.fields("BudgetFeaturesF")

            rs = db.OpenRemoteSet("Select Branch, ProAcc, ComAcc, Currency, Status, VType, Nominal, Diff, AUserID, AUserDate, AUserID_Ext, AUserDate_Ext from pVoucher Where SL_Cat='P' and DebtorF=1 and Voucher='" & Voucher & "'")
            If rs.Eof Then
                ErrMsg = "No Receipt Voucher Data !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") <> "N" Then
                ErrMsg = "Receipt Voucher Already Processed !"
                Throw New Exception(ErrMsg)
            ElseIf Not GetApprovalLimitFA(dbUser, rs.fields("VType"), "In", rs.fields("Nominal") - rs.fields("Diff")) Then
                ErrMsg = "No Limit-In Approval !"
                Throw New Exception(ErrMsg)
            ElseIf (rs.fields("Nominal") - rs.fields("Diff")) = 0 And Not db.GetPrivileges("ALLOWZEROPAYMENT") Then
                ErrMsg = "Not Allow For Zero Payment Transaction"
                Throw New Exception(ErrMsg)
            ElseIf (rs.fields("Nominal") - rs.fields("Diff")) <> 0 And Not db.GetPrivileges("ALLOWNONZEROPAYMENT") Then
                ErrMsg = "Not Allow For Non Zero Payment Transaction"
                Throw New Exception(ErrMsg)
            ElseIf Not db.GetPrivileges("ALLOWRECEIPT") Then
                ErrMsg = "No Receipt Authorization !"
                Throw New Exception(ErrMsg)
            End If

            Dim Branch As String = rs.fields("Branch")

            Dim rsT As RemoteSet
            rsT = db.OpenRemoteSet("Select ProAcc, Description, Currency, RestrictedF from ProAcc where ProAcc='" & rs.fields("ProAcc") & "'")
            If rsT.Eof Then
                ErrMsg = "Not a Valid Profile Account-" & rs.fields("ProAcc")
                Throw New Exception(ErrMsg)
            End If

            If toval(rsT.fields("RestrictedF")) Then
                ErrMsg = "Not Allowed for Restricted Profile Account-" & rsT.fields("ProAcc") & "-" & rsT.fields("Description")
                Throw New Exception(ErrMsg)
            End If

            If rsT.fields("Currency") <> rs.fields("Currency") Then
                ErrMsg = "Not a Valid Profile Account-" & rs.fields("ProAcc") & " for Voucher Currency-'" & rs.fields("Currency")
                Throw New Exception(ErrMsg)
            End If

            rsT = db.OpenRemoteSet("Select ComAcc, Description, Currency, RestrictedF From FN_UserComAcc ('" & dbUser & "', '" & rs.fields("Branch") & "') Where ComAcc='" & rs.fields("ComAcc") & "'")
            If rsT.Eof Then
                ErrMsg = "No Branch's Authorization for Company Account-" & rs.fields("ComAcc")
                Throw New Exception(ErrMsg)
            End If

            If toval(rsT.fields("RestrictedF")) Then
                ErrMsg = "Not Allowed for Restricted Company Account-" & rsT.fields("ComAcc") & "-" & rsT.fields("Description")
                Throw New Exception(ErrMsg)
            End If

            Dim Status As String = rs.fields("Status")
            Dim AUserID As String = tostr(rs.fields("AUserID"))
            Dim AUserDate As Date = todate(rs.fields("AUserDate"))
            Dim AUserID_Ext As String = tostr(rs.fields("AUserID_Ext"))
            Dim AUserDate_Ext As Date = todate(rs.fields("AUserDate_Ext"))

            If CBool(toval(GetAppSetting("NeedExtApprovalVoucherF"))) Then
                If AUserID = AUserID_Ext Then
                    AUserID = dbUser
                    AUserDate = Today.Date
                    AUserID_Ext = ""
                ElseIf AUserID <> dbUser Then
                    AUserID_Ext = dbUser
                    AUserDate_Ext = Today.Date
                Else
                    Throw New Exception("Second/Extended Approval Can't with The Same User !")
                End If
                If AUserID_Ext <> "" Then
                    Status = "U"
                End If
            Else
                AUserID = dbUser
                AUserDate = Today.Date
                AUserID_Ext = dbUser
                AUserDate_Ext = Today.Date
                Status = "U"
            End If

            If Not db.Execute("Update pVoucher Set Status='" & Status & "', AUserID='" & AUserID & "', AUserDate='" & Format(AUserDate, "MM/DD/YYYY") & "', AUserID_Ext='" & AUserID_Ext & "', AUserDate_Ext='" & Format(AUserDate_Ext, "MM/DD/YYYY") & "' from pVoucher Where Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)

            If Status = "U" Then
                If BudgetFeaturesF Then
                    If Not db.GetPrivileges("ALLOWPASSCHECKBUDGET") Then
                        If Not Check_Voucher_Budget_Account(Voucher) Then Throw New Exception("Check Budget Account Failed !" & StrMsg)
                    End If
                    If Not Update_Budget_Account_Actual(Voucher, 1) Then Throw New Exception("Update Budget Account Failed !")
                End If
                If Not db.Execute("Update ProAcc Set RestrictedF=RESTRICTAFTERUSEDF Where ProAcc='" & rs.fields("ProAcc") & "'") Then Throw New Exception(db.ErrDesc)

                ' Auto Done Task if ActionList ActionEndF=1
                rs = db.OpenRemoteSet("Select S.ID from SysRequest S Left Join SysRequest pS on (pS.ID=s.PID) Inner Join ActionList A on (A.ActionCode=(case When coalesce(pS.ActionCode, '')<>'' then  coalesce(pS.ActionCode, '') else s.ActionCode end) and A.ActionEndF=1 and (A.RCondition=4 or A.ApprovedFName='ALLOWPASSAPPLIMIT')) Where S.Status='' and S.Param2='FA' and S.Param6='" & Voucher & "'")
                If Not rs.Eof Then
                    Dim ws As New WSCommon
                    Dim IParam(0) As Object
                    Dim OParam() As Object = Nothing
                    InParam(0) = rs.fields("ID")
                    If Not ws.DoneTask(dbUser, dbPassword, IParam, OParam, ErrMsg) Then
                        Throw New Exception(ErrMsg)
                    End If
                End If

                If CBool(toval(GetAppSetting("AutoPostingJournalRVF"))) Then
                    If Not AutoPostingJournal(Voucher, "P", Branch, ErrMsg) Then Throw New Exception(ErrMsg)
                End If

                If CBool(toval(GetAppSetting("AutoPrintORF"))) Then
                    If Not Insert_Receipt_Auto_Print(Voucher, GetAppSetting("AutoPrintORSentTo")) Then
                        Throw New Exception("Can't insert into Auto Receipt Print !")
                    End If
                End If

                If CBool(toval(GetAppSetting("AutoPrintOPF"))) Then
                    If Not Insert_Payment_Auto_Print(Voucher) Then
                        Throw New Exception("Can't insert into Auto Payment Print !")
                    End If
                End If
            End If

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Voucher, "Receipt Voucher", "Approval : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function ApproveVoucherMR(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Voucher = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            Dim BudgetFeaturesF As Boolean
            rs = db.OpenRemoteSet("Select BudgetFeaturesF from SysTab")
            BudgetFeaturesF = rs.fields("BudgetFeaturesF")

            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='P' and DebtorF=1 and Voucher='" & Voucher & "'")
            If rs.Eof Then
                ErrMsg = "No Matching Voucher Data !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") <> "N" Then
                ErrMsg = "Matching Voucher Already Processed !"
                Throw New Exception(ErrMsg)
            ElseIf Math.Round(rs.fields("Nominal_CC") - rs.fields("Diff_CC"), 4, MidpointRounding.AwayFromZero) <> 0 Then
                ErrMsg = "Not Allow For Non Zero Transaction"
                Throw New Exception(ErrMsg)
            End If

            Dim Branch As String = rs.fields("Branch")

            Dim rsT As RemoteSet
            rsT = db.OpenRemoteSet("Select ProAcc, Description, Currency, RestrictedF from ProAcc where ProAcc='" & rs.fields("ProAcc") & "'")
            If rsT.Eof Then
                ErrMsg = "Not a Valid Profile Account-" & rs.fields("ProAcc")
                Throw New Exception(ErrMsg)
            End If

            If toval(rsT.fields("RestrictedF")) Then
                ErrMsg = "Not Allowed for Restricted Profile Account-" & rsT.fields("ProAcc") & "-" & rsT.fields("Description")
                Throw New Exception(ErrMsg)
            End If

            If rsT.fields("Currency") <> rs.fields("Currency") Then
                ErrMsg = "Not a Valid Profile Account-" & rs.fields("ProAcc") & " for Voucher Currency-'" & rs.fields("Currency")
                Throw New Exception(ErrMsg)
            End If

            rsT = db.OpenRemoteSet("Select ComAcc, Description, Currency, RestrictedF From FN_UserComAcc ('" & dbUser & "', '" & rs.fields("Branch") & "') Where ComAcc='" & rs.fields("ComAcc") & "'")
            If rsT.Eof Then
                ErrMsg = "No Branch's Authorization for Company Account-" & rs.fields("ComAcc")
                Throw New Exception(ErrMsg)
            End If

            If toval(rsT.fields("RestrictedF")) Then
                ErrMsg = "Not Allowed for Restricted Company Account-" & rsT.fields("ComAcc") & "-" & rsT.fields("Description")
                Throw New Exception(ErrMsg)
            End If

            If BudgetFeaturesF Then
                If Not Update_Budget_Account_Actual(Voucher, 1) Then Throw New Exception("Update Budget Account Failed !")
            End If

            rs.Edit()
            rs.fields("AUserID") = dbUser
            rs.fields("AUserDate") = Today.Date
            rs.fields("AUserID_Ext") = dbUser
            rs.fields("AUserDate_Ext") = Today.Date
            rs.fields("Status") = "U"
            If Not rs.Update Then Throw New Exception(rs.ErrDesc)

            If CBool(toval(GetAppSetting("AutoPostingJournalMRF"))) Then
                If Not AutoPostingJournal(Voucher, "P", Branch, ErrMsg) Then Throw New Exception(ErrMsg)
            End If

            If CBool(toval(GetAppSetting("AutoPrintORF"))) Then
                If Not Insert_Receipt_Auto_Print(Voucher, GetAppSetting("AutoPrintORSentTo")) Then
                    Throw New Exception("Can't insert into Auto Receipt Print !")
                End If
            End If

            If CBool(toval(GetAppSetting("AutoPrintOPF"))) Then
                If Not Insert_Payment_Auto_Print(Voucher) Then
                    Throw New Exception("Can't insert into Auto Payment Print !")
                End If
            End If

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Voucher, "Matching Voucher", "Approval : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function ApproveVoucherTP(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Voucher = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            Dim BudgetFeaturesF As Boolean
            Dim CheckCBBalanceF As Boolean
            rs = db.OpenRemoteSet("Select BudgetFeaturesF, CheckCBBalanceF from SysTab")
            BudgetFeaturesF = rs.fields("BudgetFeaturesF")
            CheckCBBalanceF = rs.fields("CheckCBBalanceF")

            rs = db.OpenRemoteSet("Select Branch, ProAcc, ComAcc, Currency, Status, VType, Nominal, Diff, AUserID, AUserDate, AUserID_Ext, AUserDate_Ext from pVoucher Where SL_Cat='P' and CreditorF=1 and Voucher='" & Voucher & "'")
            If rs.Eof Then
                ErrMsg = "No Payment Voucher Data !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") <> "N" Then
                ErrMsg = "Payment Voucher Already Processed !"
                Throw New Exception(ErrMsg)
            ElseIf Not GetApprovalLimitFA(dbUser, rs.fields("VType"), "Out", rs.fields("Nominal") - rs.fields("Diff")) Then
                ErrMsg = "No Limit-Out Approval !"
                Throw New Exception(ErrMsg)
            ElseIf (rs.fields("Nominal") - rs.fields("Diff")) = 0 And Not db.GetPrivileges("ALLOWZEROPAYMENT") Then
                ErrMsg = "Not Allow For Zero Payment Transaction"
                Throw New Exception(ErrMsg)
            ElseIf (rs.fields("Nominal") - rs.fields("Diff")) <> 0 And Not db.GetPrivileges("ALLOWNONZEROPAYMENT") Then
                ErrMsg = "Not Allow For Non Zero Payment Transaction"
                Throw New Exception(ErrMsg)
            ElseIf Not db.GetPrivileges("ALLOWPAYMENT") Then
                ErrMsg = "No Payment Authorization !"
                Throw New Exception(ErrMsg)
            End If

            Dim Branch As String = rs.fields("Branch")

            Dim rsT As RemoteSet
            rsT = db.OpenRemoteSet("Select ProAcc, Description, Currency, RestrictedF from ProAcc where ProAcc='" & rs.fields("ProAcc") & "'")
            If rsT.Eof Then
                ErrMsg = "Not a Valid Profile Account-" & rs.fields("ProAcc")
                Throw New Exception(ErrMsg)
            End If

            If toval(rsT.fields("RestrictedF")) Then
                ErrMsg = "Not Allowed for Restricted Profile Account-" & rsT.fields("ProAcc") & "-" & rsT.fields("Description")
                Throw New Exception(ErrMsg)
            End If

            If rsT.fields("Currency") <> rs.fields("Currency") Then
                ErrMsg = "Not a Valid Profile Account-" & rs.fields("ProAcc") & " for Voucher Currency-'" & rs.fields("Currency")
                Throw New Exception(ErrMsg)
            End If

            rsT = db.OpenRemoteSet("Select ComAcc, Description, Currency, RestrictedF From FN_UserComAcc ('" & dbUser & "', '" & rs.fields("Branch") & "') Where ComAcc='" & rs.fields("ComAcc") & "'")
            If rsT.Eof Then
                ErrMsg = "No Branch's Authorization for Company Account-" & rs.fields("ComAcc")
                Throw New Exception(ErrMsg)
            End If

            If toval(rsT.fields("RestrictedF")) Then
                ErrMsg = "Not Allowed for Restricted Company Account-" & rsT.fields("ComAcc") & "-" & rsT.fields("Description")
                Throw New Exception(ErrMsg)
            End If

            Dim Status As String = rs.fields("Status")
            Dim AUserID As String = tostr(rs.fields("AUserID"))
            Dim AUserDate As Date = todate(rs.fields("AUserDate"))
            Dim AUserID_Ext As String = tostr(rs.fields("AUserID_Ext"))
            Dim AUserDate_Ext As Date = todate(rs.fields("AUserDate_Ext"))

            If CBool(toval(GetAppSetting("NeedExtApprovalVoucherF"))) Then
                If AUserID = AUserID_Ext Then
                    AUserID = dbUser
                    AUserDate = Today.Date
                    AUserID_Ext = ""
                ElseIf AUserID <> dbUser Then
                    AUserID_Ext = dbUser
                    AUserDate_Ext = Today.Date
                Else
                    Throw New Exception("Second/Extended Approval Can't with The Same User !")
                End If
                If AUserID_Ext <> "" Then
                    Status = "U"
                End If
            Else
                AUserID = dbUser
                AUserDate = Today.Date
                AUserID_Ext = dbUser
                AUserDate_Ext = Today.Date
                Status = "U"
            End If

            If Not db.Execute("Update pVoucher Set Status='" & Status & "', AUserID='" & AUserID & "', AUserDate='" & Format(AUserDate, "MM/DD/YYYY") & "', AUserID_Ext='" & AUserID_Ext & "', AUserDate_Ext='" & Format(AUserDate_Ext, "MM/DD/YYYY") & "' from pVoucher Where Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)


            If Status = "U" Then
                If BudgetFeaturesF Then
                    If Not db.GetPrivileges("ALLOWPASSCHECKBUDGET") Then
                        If Not Check_Voucher_Budget_Account(Voucher) Then Throw New Exception("Check Budget Account Failed !" & StrMsg)
                    End If
                    If Not Update_Budget_Account_Actual(Voucher, 1) Then Throw New Exception("Update Budget Account Failed !")
                End If
                If CheckCBBalanceF Then
                    If Not Check_Voucher_Company_Account(Voucher) Then Throw New Exception("Check Company Account Failed !" & StrMsg)
                End If
                If Not db.Execute("Update ProAcc Set RestrictedF=RESTRICTAFTERUSEDF Where ProAcc='" & rs.fields("ProAcc") & "'") Then Throw New Exception(db.ErrDesc)

                ' Auto Done Task if ActionList ActionEndF=1
                rs = db.OpenRemoteSet("Select S.ID from SysRequest S Left Join SysRequest pS on (pS.ID=s.PID) Inner Join ActionList A on (A.ActionCode=(case When coalesce(pS.ActionCode, '')<>'' then  coalesce(pS.ActionCode, '') else s.ActionCode end) and A.ActionEndF=1 and (A.RCondition=4 or A.ApprovedFName='ALLOWPASSAPPLIMIT')) Where S.Status='' and S.Param2='FA' and S.Param6='" & Voucher & "'")
                If Not rs.Eof Then
                    Dim ws As New WSCommon
                    Dim IParam(7) As Object
                    Dim OParam() As Object = Nothing
                    IParam(0) = rs.fields("ID")
                    IParam(5) = "A"
                    IParam(7) = True
                    If Not ws.DoneSMSTask(db, dbUser, dbPassword, IParam, OParam, ErrMsg) Then
                        Throw New Exception(ErrMsg)
                    End If
                End If

                If CBool(toval(GetAppSetting("AutoPostingJournalPVF"))) Then
                    If Not AutoPostingJournal(Voucher, "P", Branch, ErrMsg) Then Throw New Exception(ErrMsg)
                End If

                If CBool(toval(GetAppSetting("AutoPrintORF"))) Then
                    If Not Insert_Receipt_Auto_Print(Voucher, GetAppSetting("AutoPrintORSentTo")) Then
                        Throw New Exception("Can't insert into Auto Receipt Print !")
                    End If
                End If

                If CBool(toval(GetAppSetting("AutoPrintOPF"))) Then
                    If Not Insert_Payment_Auto_Print(Voucher) Then
                        Throw New Exception("Can't insert into Auto Payment Print !")
                    End If
                End If

                If CBool(toval(GetAppSetting("EMailPaymentNotification"))) Then
                    SendPaymentNotification(Voucher, "APPROVED")
                End If
            End If

            db.Committrans()

            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Voucher, "Payment Voucher", "Approval : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function ApproveVoucherIR(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Voucher = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='P' and DebtorF=1 and Voucher='" & Voucher & "'")
            If rs.Eof Then
                ErrMsg = "No Receipt Voucher Data !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") <> "N" Then
                ErrMsg = "Receipt Voucher Already Processed !"
                Throw New Exception(ErrMsg)
            ElseIf Not GetApprovalLimitFA(dbUser, rs.fields("VType"), "In", rs.fields("Nominal") - rs.fields("Diff")) Then
                ErrMsg = "No Limit-In Approval !"
                Throw New Exception(ErrMsg)
            ElseIf (rs.fields("Nominal") - rs.fields("Diff")) = 0 And Not db.GetPrivileges("ALLOWZEROPAYMENT") Then
                ErrMsg = "Not Allow For Zero Payment Transaction"
                Throw New Exception(ErrMsg)
            ElseIf (rs.fields("Nominal") - rs.fields("Diff")) <> 0 And Not db.GetPrivileges("ALLOWNONZEROPAYMENT") Then
                ErrMsg = "Not Allow For Non Zero Payment Transaction"
                Throw New Exception(ErrMsg)
            ElseIf Not db.GetPrivileges("ALLOWRECEIPT") Then
                ErrMsg = "No Receipt Authorization !"
                Throw New Exception(ErrMsg)
            ElseIf Not db.GetPrivileges("ALLOWINTERBANK") Then
                ErrMsg = "No Interbank Authorization !"
            End If

            Dim rsT As RemoteSet
            rsT = db.OpenRemoteSet("Select ProAcc, Description, Currency, RestrictedF from ProAcc where ProAcc='" & rs.fields("ProAcc") & "'")
            If rsT.Eof Then
                ErrMsg = "Not a Valid Profile Account-" & rs.fields("ProAcc")
                Throw New Exception(ErrMsg)
            End If

            If toval(rsT.fields("RestrictedF")) Then
                ErrMsg = "Not Allowed for Restricted Profile Account-" & rsT.fields("ProAcc") & "-" & rsT.fields("Description")
                Throw New Exception(ErrMsg)
            End If

            If rsT.fields("Currency") <> rs.fields("Currency") Then
                ErrMsg = "Not a Valid Profile Account-" & rs.fields("ProAcc") & " for Voucher Currency-'" & rs.fields("Currency")
                Throw New Exception(ErrMsg)
            End If

            rsT = db.OpenRemoteSet("Select ComAcc, Description, Currency, RestrictedF From FN_UserComAcc ('" & dbUser & "', '" & rs.fields("Branch") & "') Where ComAcc='" & rs.fields("ComAcc") & "'")
            If rsT.Eof Then
                ErrMsg = "No Branch's Authorization for Company Account-" & rs.fields("ComAcc")
                Throw New Exception(ErrMsg)
            End If

            If toval(rsT.fields("RestrictedF")) Then
                ErrMsg = "Not Allowed for Restricted Company Account-" & rsT.fields("ComAcc") & "-" & rsT.fields("Description")
                Throw New Exception(ErrMsg)
            End If

            rs.Edit()
            rs.fields("AUserID") = dbUser
            rs.fields("AUserDate") = Today.Date
            rs.fields("AUserID_Ext") = dbUser
            rs.fields("AUserDate_Ext") = Today.Date
            rs.fields("Status") = "U"
            If Not rs.Update Then Throw New Exception(rs.ErrDesc)

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Voucher, "Receipt Inter-Bank", "Approval : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function ApproveVoucherIP(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Voucher = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            Dim CheckCBBalanceF As Boolean
            rs = db.OpenRemoteSet("Select CheckCBBalanceF from SysTab")
            CheckCBBalanceF = rs.fields("CheckCBBalanceF")

            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='P' and CreditorF=1 and Voucher='" & Voucher & "'")
            If rs.Eof Then
                ErrMsg = "No Payment Voucher Data !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") <> "N" Then
                ErrMsg = "Payment Voucher Already Processed !"
                Throw New Exception(ErrMsg)
            ElseIf Not GetApprovalLimitFA(dbUser, rs.fields("VType"), "Out", rs.fields("Nominal") - rs.fields("Diff")) Then
                ErrMsg = "No Limit-Out Approval !"
                Throw New Exception(ErrMsg)
            ElseIf (rs.fields("Nominal") - rs.fields("Diff")) = 0 And Not db.GetPrivileges("ALLOWZEROPAYMENT") Then
                ErrMsg = "Not Allow For Zero Payment Transaction"
                Throw New Exception(ErrMsg)
            ElseIf (rs.fields("Nominal") - rs.fields("Diff")) <> 0 And Not db.GetPrivileges("ALLOWNONZEROPAYMENT") Then
                ErrMsg = "Not Allow For Non Zero Payment Transaction"
                Throw New Exception(ErrMsg)
            ElseIf Not db.GetPrivileges("ALLOWPAYMENT") Then
                ErrMsg = "No Payment Authorization !"
                Throw New Exception(ErrMsg)
            ElseIf Not db.GetPrivileges("ALLOWINTERBANK") Then
                ErrMsg = "No Interbank Authorization !"
                Throw New Exception(ErrMsg)
            End If

            Dim rsT As RemoteSet
            rsT = db.OpenRemoteSet("Select ProAcc, Description, Currency, RestrictedF from ProAcc where ProAcc='" & rs.fields("ProAcc") & "'")
            If rsT.Eof Then
                ErrMsg = "Not a Valid Profile Account-" & rs.fields("ProAcc")
                Throw New Exception(ErrMsg)
            End If

            If toval(rsT.fields("RestrictedF")) Then
                ErrMsg = "Not Allowed for Restricted Profile Account-" & rsT.fields("ProAcc") & "-" & rsT.fields("Description")
                Throw New Exception(ErrMsg)
            End If

            If rsT.fields("Currency") <> rs.fields("Currency") Then
                ErrMsg = "Not a Valid Profile Account-" & rs.fields("ProAcc") & " for Voucher Currency-'" & rs.fields("Currency")
                Throw New Exception(ErrMsg)
            End If

            rsT = db.OpenRemoteSet("Select ComAcc, Description, Currency, RestrictedF From FN_UserComAcc ('" & dbUser & "', '" & rs.fields("Branch") & "') Where ComAcc='" & rs.fields("ComAcc") & "'")
            If rsT.Eof Then
                ErrMsg = "No Branch's Authorization for Company Account-" & rs.fields("ComAcc")
                Throw New Exception(ErrMsg)
            End If

            If toval(rsT.fields("RestrictedF")) Then
                ErrMsg = "Not Allowed for Restricted Company Account-" & rsT.fields("ComAcc") & "-" & rsT.fields("Description")
                Throw New Exception(ErrMsg)
            End If

            If CheckCBBalanceF Then
                If Not Check_Voucher_Company_Account(Voucher) Then Throw New Exception("Check Company Account Failed !" & StrMsg)
            End If

            rs.Edit()
            rs.fields("AUserID") = dbUser
            rs.fields("AUserDate") = Today.Date
            rs.fields("AUserID_Ext") = dbUser
            rs.fields("AUserDate_Ext") = Today.Date
            rs.fields("Status") = "U"
            If Not rs.Update Then Throw New Exception(rs.ErrDesc)

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Voucher, "Payment Inter-Bank", "Approval : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function ApproveVoucherRAPA(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Voucher = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='A' and Voucher='" & Voucher & "'")
            If rs.Eof Then
                ErrMsg = "No Adjustment Voucher Data !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") <> "N" Then
                ErrMsg = "Adjustment Voucher Already Processed !"
                Throw New Exception(ErrMsg)
            ElseIf Not db.GetPrivileges("ALLOWADJUSTMENT") Then
                ErrMsg = "No Adjustment Authorization !"
                Throw New Exception(ErrMsg)
            Else
                If toval(rs.fields("CreditorF")) Then   ' Receipt Adjustment
                    If Not GetApprovalLimitFA(dbUser, rs.fields("VType"), "In", rs.fields("Nominal") - rs.fields("Diff")) Then
                        ErrMsg = "No Limit-Out Approval !"
                        Throw New Exception(ErrMsg)
                    End If
                Else
                    If Not GetApprovalLimitFA(dbUser, rs.fields("VType"), "Out", rs.fields("Nominal") - rs.fields("Diff")) Then
                        ErrMsg = "No Limit-Out Approval !"
                        Throw New Exception(ErrMsg)
                    End If
                End If

            End If

            rs.Edit()
            rs.fields("AUserID") = dbUser
            rs.fields("AUserDate") = Today.Date
            rs.fields("AUserID_Ext") = dbUser
            rs.fields("AUserDate_Ext") = Today.Date
            rs.fields("Status") = "U"
            If Not rs.Update Then Throw New Exception(rs.ErrDesc)

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Voucher, "Receipt Adjustment", "Approval : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
        Public Function ApprovePaymentRequest(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Request As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Request = getInParamValue(InParam, 0)
            Dim DueDate As Date = todate(getInParamValue(InParam, 1))
            Dim VoucherF As Boolean = toval(getInParamValue(InParam, 2))   ' Create Payment Voucher

            Dim rs As RemoteSet
            Dim BudgetFeaturesF As Boolean
            rs = db.OpenRemoteSet("Select BudgetFeaturesF from SysTab")
            BudgetFeaturesF = rs.fields("BudgetFeaturesF")

            rs = db.OpenRemoteSet("Select R.Status, R.VType, R.Nominal, R.Diff, coalesce(P.RESTRICTEDF,0) as RESTRICTEDF, R.AUserID, R.AUserDate, R.AUserID_Ext, R.AUserDate_Ext from Request R Left Join ProAcc P on (P.ProAcc=R.ProAcc) Where R.CreditorF=1 and R.Request='" & Request & "'")
            If rs.Eof Then
                ErrMsg = "No Payment Request Data !"
                Throw New Exception(ErrMsg)
            ElseIf CBool(toval(GetAppSetting("NeedVerifiedRequestF"))) And rs.fields("Status") = "R" Then
                ErrMsg = "Payment Request Not Yet Verified !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") = "P" Then
                ErrMsg = "Payment Request Already Approved !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") = "C" Then
                ErrMsg = "Payment Request Already Cancelled !"
                Throw New Exception(ErrMsg)
            ElseIf Not GetApprovalLimitFA(dbUser, rs.fields("VType"), "Out", rs.fields("Nominal") - rs.fields("Diff")) Then
                ErrMsg = "No Limit-Out Approval !"
                Throw New Exception(ErrMsg)
            ElseIf Not db.GetPrivileges("ALLOWPAYMENTREQUEST") Then
                ErrMsg = "No Payment Request Authorization !"
                Throw New Exception(ErrMsg)
            ElseIf toval(rs.fields("RestrictedF")) Then
                ErrMsg = "Profile Account is Restricted !"
                Throw New Exception(ErrMsg)
            End If

            If Not CBool(toval(GetAppSetting("NeedVerifiedRequestF"))) Then
                If Not CBool(toval(GetAppSetting("CheckRequestBudgetOnSaveF"))) Then
                    If BudgetFeaturesF Then
                        If Not db.GetPrivileges("ALLOWPASSCHECKBUDGET") Then
                            If Not Check_Request_Budget_Account(Request) Then Throw New Exception("Check Budget Account Failed !" & StrMsg)
                        End If
                    End If
                End If

                If Not db.GetPrivileges("ALLOWPASSDOCMANDATORY") Then
                    If Not CheckPaymentMandatoryDocument(Request) Then
                        ErrMsg = "Please Check Mandatory Document Availability for Request No. : '" & Request & "' !"
                        Throw New Exception(ErrMsg)
                    End If
                End If

            End If

            Dim Status As String = rs.fields("Status")
            Dim AUserID As String = tostr(rs.fields("AUserID"))
            Dim AUserDate As Date = todate(rs.fields("AUserDate"))
            Dim AUserID_Ext As String = tostr(rs.fields("AUserID_Ext"))
            Dim AUserDate_Ext As Date = todate(rs.fields("AUserDate_Ext"))

            If CBool(toval(GetAppSetting("NeedExtApprovalRequestF"))) Then
                If AUserID = AUserID_Ext Then
                    AUserID = dbUser
                    AUserDate = Today.Date
                    AUserID_Ext = ""
                ElseIf AUserID <> dbUser Then
                    AUserID_Ext = dbUser
                    AUserDate_Ext = Today.Date
                Else
                    Throw New Exception("Second/Extended Approval Can't with The Same User !")
                End If
                If AUserID_Ext <> "" Then
                    Status = "P"
                End If
            Else
                AUserID = dbUser
                AUserDate = Today.Date
                AUserID_Ext = dbUser
                AUserDate_Ext = Today.Date
                Status = "P"
            End If

            If Not db.Execute("Update Request Set Status='" & Status & "', AUserID='" & AUserID & "', AUserDate='" & Format(AUserDate, "MM/DD/YYYY") & "', AUserID_Ext='" & AUserID_Ext & "', AUserDate_Ext='" & Format(AUserDate_Ext, "MM/DD/YYYY") & "' from Request Where Request='" & Request & "'") Then Throw New Exception(db.ErrDesc)

            ' Auto Done Task if ActionList ActionEndF=1
            rs = db.OpenRemoteSet("Select S.ID from SysRequest S Left Join SysRequest pS on (pS.ID=s.PID) Inner Join ActionList A on (A.ActionCode=(case When coalesce(pS.ActionCode, '')<>'' then  coalesce(pS.ActionCode, '') else s.ActionCode end) and A.ActionEndF=1 and (A.RCondition=3 or A.ApprovedFName='ALLOWPASSAPPLIMIT')) Where S.Status='' and S.Param2='RQ' and S.Param6='" & Request & "'")
            If Not rs.Eof Then
                Dim ws As New WSCommon
                Dim IParam(7) As Object
                Dim OParam() As Object = Nothing
                IParam(0) = rs.fields("ID")
                IParam(5) = "A"
                IParam(7) = True
                If Not ws.DoneSMSTask(db, dbUser, dbPassword, IParam, OParam, ErrMsg) Then
                    Throw New Exception(ErrMsg)
                End If
            End If

            If VoucherF Then
                Dim findex() As String = Nothing
                Dim fbuffer() As String = Nothing
                Dim Dataset As DataSet = Nothing
                Dim Dataset1 As DataSet = Nothing
                Dim Dataset2 As DataSet = Nothing

                ReDim InParam(4)
                InParam(0) = Request
                If Not GetRequestP(InParam, findex, fbuffer, Nothing, Nothing, Dataset1, Dataset2, ErrMsg) Then
                    Throw New Exception(ErrMsg)
                End If

                InParam(0) = tostr(GetFieldValue(fbuffer(GetFieldIndex("Voucher", findex))))
                InParam(1) = tostr(GetFieldValue(fbuffer(GetFieldIndex("Branch", findex))))
                InParam(2) = Today.Date
                InParam(3) = "REQUEST"
                InParam(4) = tostr(GetFieldValue(fbuffer(GetFieldIndex("Request", findex))))
                If Not SaveVoucherTP(InParam, OutParam, findex, fbuffer, Dataset1, Dataset2, ErrMsg) Then
                    Throw New Exception(ErrMsg)
                End If
            End If

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Request, "Payment Request", "Approval : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
        Public Function VerifyPaymentRequest(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Request As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Request = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            Dim BudgetFeaturesF As Boolean
            rs = db.OpenRemoteSet("Select BudgetFeaturesF from SysTab")
            BudgetFeaturesF = rs.fields("BudgetFeaturesF")

            rs = db.OpenRemoteSet("Select * from Request Where CreditorF=1 and Request='" & Request & "'")
            If rs.Eof Then
                ErrMsg = "No Payment Request Data !"
                Throw New Exception(ErrMsg)
            ElseIf CBool(toval(GetAppSetting("NeedVerifiedRequestF"))) Then
                If rs.fields("Status") = "V" Then
                    ErrMsg = "Payment Request Already Verified !"
                    Throw New Exception(ErrMsg)
                ElseIf rs.fields("Status") = "P" Then
                    ErrMsg = "Payment Request Already Approved !"
                    Throw New Exception(ErrMsg)
                ElseIf rs.fields("Status") = "C" Then
                    ErrMsg = "Payment Request Already Cancelled !"
                    Throw New Exception(ErrMsg)
                End If
            Else
                ErrMsg = "Payment Request don't need verification !"
                Throw New Exception(ErrMsg)
            End If

            If Not CBool(toval(GetAppSetting("CheckRequestBudgetOnSaveF"))) Then
                If BudgetFeaturesF Then
                    If Not db.GetPrivileges("ALLOWPASSCHECKBUDGET") Then
                        If Not Check_Request_Budget_Account(Request) Then Throw New Exception("Check Budget Account Failed !" & StrMsg)
                    End If
                End If
            End If

            If Not db.GetPrivileges("ALLOWPASSDOCMANDATORY") Then
                If Not CheckPaymentMandatoryDocument(Request) Then
                    ErrMsg = "Please Check Mandatory Document Availability for Request No. : '" & Request & "' !"
                    Throw New Exception(ErrMsg)
                End If
            End If

            rs.Edit()
            rs.fields("VUserID") = dbUser
            rs.fields("VUserDate") = Today.Date
            rs.fields("Status") = "V"
            If Not rs.Update Then Throw New Exception(rs.ErrDesc)

            db.Committrans()

            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Request, "Payment Request", "Verify : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
        Public Function ApproveReceiptRequest(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Request As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Request = getInParamValue(InParam, 0)
            Dim DueDate As Date = todate(getInParamValue(InParam, 1))

            Dim rs As RemoteSet
            Dim BudgetFeaturesF As Boolean
            rs = db.OpenRemoteSet("Select BudgetFeaturesF from SysTab")
            BudgetFeaturesF = rs.fields("BudgetFeaturesF")

            rs = db.OpenRemoteSet("Select R.Status, R.VType, R.Nominal, R.Diff, coalesce(P.RESTRICTEDF,0) as RESTRICTEDF, R.AUserID, R.AUserDate, R.AUserID_Ext, R.AUserDate_Ext from Request R Left Join ProAcc P on (P.ProAcc=R.ProAcc) Where R.DebtorF=1 and R.Request='" & Request & "'")
            If rs.Eof Then
                ErrMsg = "No Receipt Request Data !"
                Throw New Exception(ErrMsg)
            ElseIf CBool(toval(GetAppSetting("NeedVerifiedRequestF"))) And rs.fields("Status") = "R" Then
                ErrMsg = "Receipt Request Not Yet Verified !"
            ElseIf rs.fields("Status") = "P" Then
                ErrMsg = "Receipt Request Already Approved !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") = "C" Then
                ErrMsg = "Receipt Request Already Cancelled !"
                Throw New Exception(ErrMsg)
            ElseIf Not GetApprovalLimitFA(dbUser, rs.fields("VType"), "In", rs.fields("Nominal") - rs.fields("Diff")) Then
                ErrMsg = "No Limit-In Approval !"
                Throw New Exception(ErrMsg)
            ElseIf Not db.GetPrivileges("ALLOWRECEIPTREQUEST") Then
                ErrMsg = "No Receipt Request Authorization !"
                Throw New Exception(ErrMsg)
            ElseIf toval(rs.fields("RestrictedF")) Then
                ErrMsg = "Profile Account is Restricted !"
                Throw New Exception(ErrMsg)
            End If

            If Not CBool(toval(GetAppSetting("NeedVerifiedRequestF"))) Then
                If Not CBool(toval(GetAppSetting("CheckRequestBudgetOnSaveF"))) Then
                    If BudgetFeaturesF Then
                        If Not db.GetPrivileges("ALLOWPASSCHECKBUDGET") Then
                            If Not Check_Request_Budget_Account(Request) Then Throw New Exception("Check Budget Account Failed !" & StrMsg)
                        End If
                    End If
                End If

                If Not db.GetPrivileges("ALLOWPASSDOCMANDATORY") Then
                    If Not CheckReceiptMandatoryDocument(Request) Then
                        ErrMsg = "Please Check Mandatory Document Availability for Request No. : '" & Request & "' !"
                        Throw New Exception(ErrMsg)
                    End If
                End If
            End If

            Dim Status As String = rs.fields("Status")
            Dim AUserID As String = tostr(rs.fields("AUserID"))
            Dim AUserDate As Date = todate(rs.fields("AUserDate"))
            Dim AUserID_Ext As String = tostr(rs.fields("AUserID_Ext"))
            Dim AUserDate_Ext As Date = todate(rs.fields("AUserDate_Ext"))

            If CBool(toval(GetAppSetting("NeedExtApprovalRequestF"))) Then
                If AUserID = AUserID_Ext Then
                    AUserID = dbUser
                    AUserDate = Today.Date
                    AUserID_Ext = ""
                ElseIf AUserID <> dbUser Then
                    AUserID_Ext = dbUser
                    AUserDate_Ext = Today.Date
                Else
                    Throw New Exception("Second/Extended Approval Can't with The Same User !")
                End If
                If AUserID_Ext <> "" Then
                    Status = "P"
                End If
            Else
                AUserID = dbUser
                AUserDate = Today.Date
                AUserID_Ext = dbUser
                AUserDate_Ext = Today.Date
                Status = "P"
            End If

            If Not db.Execute("Update Request Set Status='" & Status & "', AUserID='" & AUserID & "', AUserDate='" & Format(AUserDate, "MM/DD/YYYY") & "', AUserID_Ext='" & AUserID_Ext & "', AUserDate_Ext='" & Format(AUserDate_Ext, "MM/DD/YYYY") & "' from Request Where Request='" & Request & "'") Then Throw New Exception(db.ErrDesc)

            ' Auto Done Task if ActionList ActionEndF=1
            rs = db.OpenRemoteSet("Select S.ID from SysRequest S Left Join SysRequest pS on (pS.ID=s.PID) Inner Join ActionList A on (A.ActionCode=(case When coalesce(pS.ActionCode, '')<>'' then  coalesce(pS.ActionCode, '') else s.ActionCode end) and A.ActionEndF=1 and (A.RCondition=3 or A.ApprovedFName='ALLOWPASSAPPLIMIT')) Where S.Status='' and S.Param2='RQ' and S.Param6='" & Request & "'")
            If Not rs.Eof Then
                Dim ws As New WSCommon
                Dim IParam(0) As Object
                Dim OParam() As Object = Nothing
                InParam(0) = rs.fields("ID")
                If Not ws.DoneTask(dbUser, dbPassword, IParam, OParam, ErrMsg) Then
                    Throw New Exception(ErrMsg)
                End If
            End If

            db.Committrans()

            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Request, "Receipt Request", "Approval : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
        Public Function VerifyReceiptRequest(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Request As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Request = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            Dim BudgetFeaturesF As Boolean
            rs = db.OpenRemoteSet("Select BudgetFeaturesF from SysTab")
            BudgetFeaturesF = rs.fields("BudgetFeaturesF")

            rs = db.OpenRemoteSet("Select * from Request Where DebtorF=1 and Request='" & Request & "'")
            If rs.Eof Then
                ErrMsg = "No Receipt Request Data !"
                Throw New Exception(ErrMsg)
            ElseIf CBool(toval(GetAppSetting("NeedVerifiedRequestF"))) Then
                If rs.fields("Status") = "V" Then
                    ErrMsg = "Receipt Request Already Verified !"
                    Throw New Exception(ErrMsg)
                ElseIf rs.fields("Status") = "P" Then
                    ErrMsg = "Receipt Request Already Approved !"
                    Throw New Exception(ErrMsg)
                ElseIf rs.fields("Status") = "C" Then
                    ErrMsg = "Receipt Request Already Cancelled !"
                    Throw New Exception(ErrMsg)
                End If
            Else
                ErrMsg = "Receipt Request don't need verification !"
                Throw New Exception(ErrMsg)
            End If

            If Not CBool(toval(GetAppSetting("CheckRequestBudgetOnSaveF"))) Then
                If BudgetFeaturesF Then
                    If Not db.GetPrivileges("ALLOWPASSCHECKBUDGET") Then
                        If Not Check_Request_Budget_Account(Request) Then Throw New Exception("Check Budget Account Failed !" & StrMsg)
                    End If
                End If
            End If

            If Not db.GetPrivileges("ALLOWPASSDOCMANDATORY") Then
                If Not CheckReceiptMandatoryDocument(Request) Then
                    ErrMsg = "Please Check Mandatory Document Availability for Request No. : '" & Request & "' !"
                    Throw New Exception(ErrMsg)
                End If
            End If

            rs.Edit()
            rs.fields("VUserID") = dbUser
            rs.fields("VUserDate") = Today.Date
            rs.fields("Status") = "V"
            If Not rs.Update Then Throw New Exception(rs.ErrDesc)

            db.Committrans()

            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Request, "Receipt Request", "Verify : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function UnApproveVoucherTR(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Voucher = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            Dim BudgetFeaturesF As Boolean
            rs = db.OpenRemoteSet("Select BudgetFeaturesF from SysTab")
            BudgetFeaturesF = rs.fields("BudgetFeaturesF")

            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='P' and DebtorF=1 and Voucher='" & Voucher & "'")
            If rs.Eof Then
                ErrMsg = "No Receipt Voucher Data !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") = "N" Then
                ErrMsg = "Receipt Voucher Not Yet Approved !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") = "P" Then
                ErrMsg = "Payment Voucher Already Posted To GL !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Posting_Flag") = True Then
                ErrMsg = "Payment Voucher Already Posted To Ledger !"
                Throw New Exception(ErrMsg)
            ElseIf Not GetApprovalLimitFA(dbUser, rs.fields("VType"), "In", rs.fields("Nominal") - rs.fields("Diff")) Then
                ErrMsg = "No Limit-In Approval !"
                Throw New Exception(ErrMsg)
            ElseIf (rs.fields("Nominal") - rs.fields("Diff")) = 0 And Not db.GetPrivileges("ALLOWZEROPAYMENT") Then
                ErrMsg = "Not Allow For Zero Payment Transaction"
                Throw New Exception(ErrMsg)
            ElseIf (rs.fields("Nominal") - rs.fields("Diff")) <> 0 And Not db.GetPrivileges("ALLOWNONZEROPAYMENT") Then
                ErrMsg = "Not Allow For Non Zero Payment Transaction"
                Throw New Exception(ErrMsg)
            ElseIf Not db.GetPrivileges("ALLOWRECEIPT") Then
                ErrMsg = "No Receipt Authorization !"
                Throw New Exception(ErrMsg)
            End If

            If BudgetFeaturesF Then
                If Not Update_Budget_Account_Actual(Voucher, -1) Then Throw New Exception("Update Budget Account Failed !")
            End If

            rs.Edit()
            rs.fields("AUserID") = dbUser
            rs.fields("AUserDate") = Today.Date
            rs.fields("AUserID_Ext") = dbUser
            rs.fields("AUserDate_Ext") = Today.Date
            rs.fields("Status") = "N"
            If Not rs.Update Then Throw New Exception(rs.ErrDesc)

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Voucher, "Receipt Voucher", "Undo-Approval : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function UnApproveVoucherMR(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Voucher = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            Dim BudgetFeaturesF As Boolean
            rs = db.OpenRemoteSet("Select BudgetFeaturesF from SysTab")
            BudgetFeaturesF = rs.fields("BudgetFeaturesF")

            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='P' and DebtorF=1 and Voucher='" & Voucher & "'")
            If rs.Eof Then
                ErrMsg = "No Matching Voucher Data !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") = "N" Then
                ErrMsg = "Matching Voucher Not Yet Approved !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") = "P" Then
                ErrMsg = "Payment Voucher Already Posted To GL !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Posting_Flag") = True Then
                ErrMsg = "Payment Voucher Already Posted To Ledger !"
                Throw New Exception(ErrMsg)
            ElseIf Math.Round(rs.fields("Nominal_CC") - rs.fields("Diff_CC"), 4, MidpointRounding.AwayFromZero) <> 0 Then
                ErrMsg = "Not Allow For Non Zero Transaction"
                Throw New Exception(ErrMsg)
            End If

            If BudgetFeaturesF Then
                If Not Update_Budget_Account_Actual(Voucher, -1) Then Throw New Exception("Update Budget Account Failed !")
            End If

            rs.Edit()
            rs.fields("AUserID") = dbUser
            rs.fields("AUserDate") = Today.Date
            rs.fields("AUserID_Ext") = dbUser
            rs.fields("AUserDate_Ext") = Today.Date
            rs.fields("Status") = "N"
            If Not rs.Update Then Throw New Exception(rs.ErrDesc)

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Voucher, "Matching Voucher", "Undo-Approval : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function UnApproveVoucherTP(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Voucher = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            Dim BudgetFeaturesF As Boolean
            rs = db.OpenRemoteSet("Select BudgetFeaturesF from SysTab")
            BudgetFeaturesF = rs.fields("BudgetFeaturesF")

            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='P' and CreditorF=1 and Voucher='" & Voucher & "'")
            If rs.Eof Then
                ErrMsg = "No Payment Voucher Data !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") = "N" Then
                ErrMsg = "Payment Voucher Not Yet Approved !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") = "P" Then
                ErrMsg = "Payment Voucher Already Posted To GL !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Posting_Flag") = True Then
                ErrMsg = "Payment Voucher Already Posted To Ledger !"
                Throw New Exception(ErrMsg)
            ElseIf Not GetApprovalLimitFA(dbUser, rs.fields("VType"), "Out", rs.fields("Nominal") - rs.fields("Diff")) Then
                ErrMsg = "No Limit-Out Approval !"
                Throw New Exception(ErrMsg)
            ElseIf (rs.fields("Nominal") - rs.fields("Diff")) = 0 And Not db.GetPrivileges("ALLOWZEROPAYMENT") Then
                ErrMsg = "Not Allow For Zero Payment Transaction"
                Throw New Exception(ErrMsg)
            ElseIf (rs.fields("Nominal") - rs.fields("Diff")) <> 0 And Not db.GetPrivileges("ALLOWNONZEROPAYMENT") Then
                ErrMsg = "Not Allow For Non Zero Payment Transaction"
                Throw New Exception(ErrMsg)
            ElseIf Not db.GetPrivileges("ALLOWPAYMENT") Then
                ErrMsg = "No Payment Authorization !"
                Throw New Exception(ErrMsg)
            End If

            If BudgetFeaturesF Then
                If Not Update_Budget_Account_Actual(Voucher, -1) Then Throw New Exception("Update Budget Account Failed !")
            End If

            rs.Edit()
            rs.fields("AUserID") = dbUser
            rs.fields("AUserDate") = Today.Date
            rs.fields("AUserID_Ext") = dbUser
            rs.fields("AUserDate_Ext") = Today.Date
            rs.fields("Status") = "N"
            If Not rs.Update Then Throw New Exception(rs.ErrDesc)

            If CBool(toval(GetAppSetting("EMailPaymentNotification"))) Then
                SendPaymentNotification(Voucher, "UN-APPROVED")
            End If

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Voucher, "Payment Voucher", "Undo-Approval : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function UnApproveVoucherIR(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Voucher = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='P' and DebtorF=1 and Voucher='" & Voucher & "'")
            If rs.Eof Then
                ErrMsg = "No Receipt Voucher Data !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") = "N" Then
                ErrMsg = "Receipt Voucher Not Yet Approved !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") = "P" Then
                ErrMsg = "Payment Voucher Already Posted To GL !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Posting_Flag") = True Then
                ErrMsg = "Payment Voucher Already Posted To Ledger !"
                Throw New Exception(ErrMsg)
            ElseIf Not GetApprovalLimitFA(dbUser, rs.fields("VType"), "In", rs.fields("Nominal") - rs.fields("Diff")) Then
                ErrMsg = "No Limit-In Approval !"
                Throw New Exception(ErrMsg)
            ElseIf (rs.fields("Nominal") - rs.fields("Diff")) = 0 And Not db.GetPrivileges("ALLOWZEROPAYMENT") Then
                ErrMsg = "Not Allow For Zero Payment Transaction"
                Throw New Exception(ErrMsg)
            ElseIf (rs.fields("Nominal") - rs.fields("Diff")) <> 0 And Not db.GetPrivileges("ALLOWNONZEROPAYMENT") Then
                ErrMsg = "Not Allow For Non Zero Payment Transaction"
                Throw New Exception(ErrMsg)
            ElseIf Not db.GetPrivileges("ALLOWRECEIPT") Then
                ErrMsg = "No Receipt Authorization !"
                Throw New Exception(ErrMsg)
            ElseIf Not db.GetPrivileges("ALLOWINTERBANK") Then
                ErrMsg = "No Interbank Authorization !"
            End If

            rs.Edit()
            rs.fields("AUserID") = dbUser
            rs.fields("AUserDate") = Today.Date
            rs.fields("AUserID_Ext") = dbUser
            rs.fields("AUserDate_Ext") = Today.Date
            rs.fields("Status") = "N"
            If Not rs.Update Then Throw New Exception(rs.ErrDesc)

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Voucher, "Receipt Inter-Bank", "Undo-Approval : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function UnApproveVoucherIP(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Voucher = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='P' and CreditorF=1 and Voucher='" & Voucher & "'")
            If rs.Eof Then
                ErrMsg = "No Payment Voucher Data !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") = "N" Then
                ErrMsg = "Payment Voucher Not Yet Approved !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") = "P" Then
                ErrMsg = "Payment Voucher Already Posted To GL !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Posting_Flag") = True Then
                ErrMsg = "Payment Voucher Already Posted To Ledger !"
                Throw New Exception(ErrMsg)
            ElseIf Not GetApprovalLimitFA(dbUser, rs.fields("VType"), "Out", rs.fields("Nominal") - rs.fields("Diff")) Then
                ErrMsg = "No Limit-Out Approval !"
                Throw New Exception(ErrMsg)
            ElseIf (rs.fields("Nominal") - rs.fields("Diff")) = 0 And Not db.GetPrivileges("ALLOWZEROPAYMENT") Then
                ErrMsg = "Not Allow For Zero Payment Transaction"
                Throw New Exception(ErrMsg)
            ElseIf (rs.fields("Nominal") - rs.fields("Diff")) <> 0 And Not db.GetPrivileges("ALLOWNONZEROPAYMENT") Then
                ErrMsg = "Not Allow For Non Zero Payment Transaction"
                Throw New Exception(ErrMsg)
            ElseIf Not db.GetPrivileges("ALLOWPAYMENT") Then
                ErrMsg = "No Payment Authorization !"
                Throw New Exception(ErrMsg)
            ElseIf Not db.GetPrivileges("ALLOWINTERBANK") Then
                ErrMsg = "No Interbank Authorization !"
            End If

            rs.Edit()
            rs.fields("AUserID") = dbUser
            rs.fields("AUserDate") = Today.Date
            rs.fields("AUserID_Ext") = dbUser
            rs.fields("AUserDate_Ext") = Today.Date
            rs.fields("Status") = "N"
            If Not rs.Update Then Throw New Exception(rs.ErrDesc)

            db.Committrans()

            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Voucher, "Payment Inter-Bank", "Undo-Approval : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function UnApproveVoucherRAPA(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Voucher As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Voucher = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from pVoucher Where SL_Cat='A' and Voucher='" & Voucher & "'")
            If rs.Eof Then
                ErrMsg = "No Adjustment Voucher Data !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") = "N" Then
                ErrMsg = "Adjustment Voucher Not Yet Approved !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") = "P" Then
                ErrMsg = "Payment Voucher Already Posted To GL !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Posting_Flag") = True Then
                ErrMsg = "Payment Voucher Already Posted To Ledger !"
                Throw New Exception(ErrMsg)
            End If

            rs.Edit()
            rs.fields("AUserID") = dbUser
            rs.fields("AUserDate") = Today.Date
            rs.fields("AUserID_Ext") = dbUser
            rs.fields("AUserDate_Ext") = Today.Date
            rs.fields("Status") = "N"
            If Not rs.Update Then Throw New Exception(rs.ErrDesc)

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Voucher, "Receipt Adjustment", "Undo-Approval : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
       Public Function UnApprovePaymentRequest(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Request As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Request = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from Request Where CreditorF=1 and Request='" & Request & "'")
            If rs.Eof Then
                ErrMsg = "No Payment Request Data !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Voucher") <> "" Then
                ErrMsg = "Payment Request Already Vouchered!"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") = "R" Or rs.fields("Status") = "V" Then
                ErrMsg = "Payment Request Not Yet Approved !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") = "C" Then
                ErrMsg = "Payment Request Already Cancelled !"
                Throw New Exception(ErrMsg)
            ElseIf Not GetApprovalLimitFA(dbUser, rs.fields("VType"), "Out", rs.fields("Nominal") - rs.fields("Diff")) Then
                ErrMsg = "No Limit-In Approval !"
                Throw New Exception(ErrMsg)
            ElseIf Not db.GetPrivileges("ALLOWPAYMENTREQUEST") Then
                ErrMsg = "No Payment Request Authorization !"
                Throw New Exception(ErrMsg)
            End If

            rs.Edit()
            rs.fields("AUserID") = dbUser
            rs.fields("AUserDate") = Today.Date
            rs.fields("AUserID_Ext") = dbUser
            rs.fields("AUserDate_Ext") = Today.Date
            If CBool(toval(GetAppSetting("NeedVerifiedRequestF"))) Then
                rs.fields("Status") = "V"
            Else
                rs.fields("Status") = "R"
            End If
            If Not rs.Update Then Throw New Exception(rs.ErrDesc)

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Request, "Payment Request", "Undo-Approval : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
       Public Function UnVerifyPaymentRequest(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Request As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Request = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from Request Where CreditorF=1 and Request='" & Request & "'")
            If rs.Eof Then
                ErrMsg = "No Payment Request Data !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Voucher") <> "" Then
                ErrMsg = "Payment Request Already Vouchered!"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") = "R" Then
                ErrMsg = "Payment Request Not Yet Verified !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") = "P" Then
                ErrMsg = "Payment Request Already Approved !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") = "C" Then
                ErrMsg = "Payment Request Already Cancelled !"
                Throw New Exception(ErrMsg)
            End If

            rs.Edit()
            rs.fields("VUserID") = dbUser
            rs.fields("VUserDate") = Today.Date
            rs.fields("Status") = "R"
            If Not rs.Update Then Throw New Exception(rs.ErrDesc)

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Request, "Payment Request", "Undo-Verify : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
        Public Function UnApproveReceiptRequest(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Request As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Request = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from Request Where DebtorF=1 and Request='" & Request & "'")
            If rs.Eof Then
                ErrMsg = "No Receipt Request Data !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Voucher") <> "" Then
                ErrMsg = "Receipt Request Already Vouchered!"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") = "R" Or rs.fields("Status") = "V" Then
                ErrMsg = "Receipt Request Not Yet Approved !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") = "C" Then
                ErrMsg = "Receipt Request Already Cancelled !"
                Throw New Exception(ErrMsg)
            ElseIf Not GetApprovalLimitFA(dbUser, rs.fields("VType"), "In", rs.fields("Nominal") - rs.fields("Diff")) Then
                ErrMsg = "No Limit-In Approval !"
                Throw New Exception(ErrMsg)
            ElseIf Not db.GetPrivileges("ALLOWRECEIPTREQUEST") Then
                ErrMsg = "No Receipt Request Authorization !"
                Throw New Exception(ErrMsg)
            End If

            rs.Edit()
            rs.fields("AUserID") = dbUser
            rs.fields("AUserDate") = Today.Date
            rs.fields("AUserID_Ext") = dbUser
            rs.fields("AUserDate_Ext") = Today.Date
            If CBool(toval(GetAppSetting("NeedVerifiedRequestF"))) Then
                rs.fields("Status") = "V"
            Else
                rs.fields("Status") = "R"
            End If
            If Not rs.Update Then Throw New Exception(rs.ErrDesc)

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Request, "Receipt Request", "Undo-Approval : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
       Public Function UnVerifyReceiptRequest(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Dim Request As String = ""
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Request = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from Request Where DebtorF=1 and Request='" & Request & "'")
            If rs.Eof Then
                ErrMsg = "No Receipt Request Data !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Voucher") <> "" Then
                ErrMsg = "Receipt Request Already Vouchered!"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") = "R" Then
                ErrMsg = "Receipt Request Not Yet Verified !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") = "P" Then
                ErrMsg = "Receipt Request Already Approved !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Status") = "C" Then
                ErrMsg = "Receipt Request Already Cancelled !"
                Throw New Exception(ErrMsg)
            End If

            rs.Edit()
            rs.fields("VUserID") = dbUser
            rs.fields("VUserDate") = Today.Date
            rs.fields("Status") = "R"
            If Not rs.Update Then Throw New Exception(rs.ErrDesc)

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            FANotes(Request, "Receipt Request", "Undo-Verify : " & ErrMsg)
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SearchProacc(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim ProAcc As String = getInParamValue(InParam, 0)
            Dim ID As String = getInParamValue(InParam, 1)
            Dim Currency As String = getInParamValue(InParam, 2)
            Dim Description As String = getInParamValue(InParam, 3)
            Dim AccountNo As String = getInParamValue(InParam, 4)
            Dim Bank As String = getInParamValue(InParam, 5)
            Dim Status As String = getInParamValue(InParam, 6)
            Dim SQL As String = getInParamValue(InParam, 7)

            If SQL = "" Then
                SQL = "Select Cast(0 as bit) as ProcessFlag, ProAcc.*"
                SQL = SQL & " from ProAcc"
                SQL = SQL & " Where 1=1"
            End If
            If ProAcc <> "" Then
                SQL = SQL & " and ProAcc.ProAcc Like '" & ProAcc & "%'"
            End If
            If ID <> "" Then
                SQL = SQL & " and ProAcc.ID Like '" & ID & "%'"
            End If
            If Currency <> "" Then
                SQL = SQL & " and ProAcc.Currency Like '" & Currency & "%'"
            End If
            If Description <> "" Then
                SQL = SQL & " and ProAcc.Description Like '" & Description & "%'"
            End If
            If AccountNo <> "" Then
                SQL = SQL & " and ProAcc.AccountNo Like '" & AccountNo & "%'"
            End If
            If Bank <> "" Then
                SQL = SQL & " and ProAcc.Bank Like '" & Bank & "%'"
            End If
            Select Case Status
                Case "All Status"
                Case "Restricted"
                    SQL = SQL & " and coalesce(ProAcc.RestrictedF,0)=1"
                Case "Not Restricted"
                    SQL = SQL & " and coalesce(ProAcc.RestrictedF,0)=0"
            End Select

            Dim rs As RemoteSet
            Dim C_MaxRecords As Long
            C_MaxRecords = toval(GetAppSetting("CareMaxRecords"))
            If toval(GetAppSetting("CareMaxRecords_FA")) > C_MaxRecords Then
                C_MaxRecords = toval(GetAppSetting("CareMaxRecords_FA"))
            End If
            rs = db.OpenRemoteSet(SQL, , , , C_MaxRecords)
            Dataset = rs.GetDataSet

            If Dataset Is Nothing Then Throw New Exception(ErrMsg)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function CheckProAcc(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim ProAcc As String = getInParamValue(InParam, 0)
            Dim Remarks As String = getInParamValue(InParam, 1)
            Dim RESTRICTAFTERUSEDF As Boolean = toval(getInParamValue(InParam, 2))

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from ProAcc Where ProAcc='" & ProAcc & "'")
            If rs.Eof Then
                ErrMsg = "No Profile Account Data !"
                Throw New Exception(ErrMsg)
            ElseIf Not toval(rs.fields("RestrictedF")) Then
                ErrMsg = "Profile Account is not restricted Yet !"
                Throw New Exception(ErrMsg)
            End If
            rs.Edit()
            If toval(rs.fields("RESTRICTAFTERUSEDF")) <> toval(RESTRICTAFTERUSEDF) Then
                If Not Save_Log_Object("ProAcc", "ProAcc", ProAcc, "", "", "", "", "", "", "RESTRICTAFTERUSEDF", toval(rs.fields("RESTRICTAFTERUSEDF")), toval(RESTRICTAFTERUSEDF), "Update") Then Throw New Exception("Can't Save to Log !")
                rs.fields("RESTRICTAFTERUSEDF") = RESTRICTAFTERUSEDF
            End If
            If toval(rs.fields("RestrictedF")) <> toval(False) Then
                If Not Save_Log_Object("ProAcc", "ProAcc", ProAcc, "", "", "", "", "", "", "RestrictedF", toval(rs.fields("RestrictedF")), toval(False), "Update") Then Throw New Exception("Can't Save to Log !")
                rs.fields("RestrictedF") = False
            End If
            If rs.fields("Remarks") <> Remarks Then
                If Not Save_Log_Object("ProAcc", "ProAcc", ProAcc, "", "", "", "", "", "", "Remarks", rs.fields("Remarks"), Remarks, "Update") Then Throw New Exception("Can't Save to Log !")
                rs.fields("Remarks") = Remarks
            End If
            rs.fields("PUserDate") = Today.Date
            rs.fields("PUserID") = dbUser
            If Not rs.Update Then Throw New Exception(rs.ErrDesc)

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function RestrictProAcc(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim ProAcc As String = getInParamValue(InParam, 0)
            Dim Remarks As String = getInParamValue(InParam, 1)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from ProAcc Where ProAcc='" & ProAcc & "'")
            If rs.Eof Then
                ErrMsg = "No Profile Account Data !"
                Throw New Exception(ErrMsg)
            ElseIf toval(rs.fields("RestrictedF")) Then
                ErrMsg = "Profile Account is Already restricted !"
                Throw New Exception(ErrMsg)
            End If
            rs.Edit()
            If toval(rs.fields("RestrictedF")) <> toval(True) Then
                If Not Save_Log_Object("ProAcc", "ProAcc", ProAcc, "", "", "", "", "", "", "RestrictedF", toval(rs.fields("RestrictedF")), toval(True), "Update") Then Throw New Exception("Can't Save to Log !")
                rs.fields("RestrictedF") = True
            End If
            If rs.fields("Remarks") <> Remarks Then
                If Not Save_Log_Object("ProAcc", "ProAcc", ProAcc, "", "", "", "", "", "", "Remarks", rs.fields("Remarks"), Remarks, "Update") Then Throw New Exception("Can't Save to Log !")
                rs.fields("Remarks") = Remarks
            End If
            rs.fields("PUserDate") = Today.Date
            rs.fields("PUserID") = dbUser
            If Not rs.Update Then Throw New Exception(rs.ErrDesc)

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function GetProAcc(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef findex As String(), ByRef fbuffer As String(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim ProAcc As String
            ProAcc = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            rs = db.OpenQueryDef("QProAcc", adOpenKeyset, ProAcc)
            findex = rs.fields_index()
            fbuffer = rs.GetRecord()

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SaveProAcc(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal findex() As String, ByVal fbuffer() As String, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim ProAcc As String
            ProAcc = getInParamValue(InParam, 0)

            Dim rsH As RemoteSet
            Dim EditMode As Integer
            Dim ID As String
            Dim Currency As String


            ID = GetFieldValue(fbuffer(GetFieldIndex("ID", findex)))
            Currency = GetFieldValue(fbuffer(GetFieldIndex("Currency", findex)))

            rsH = db.OpenRemoteSet("Select * from ProAcc Where ProAcc='" & ProAcc & "'")
            If rsH.Eof Then
                If ProAcc = "" Then ProAcc = ID & "-" & Left(Currency, 3)
                If ProAcc = "" Then Throw New Exception("Generate Profile Account Failed !")
                rsH.AddNew()
            Else
                rsH.Edit()
            End If
            EditMode = rsH.editmode

            ' Check Status
            If EditMode = AdEditInProgress Then
                ' Nothing
            End If

            Dim i As Integer
            Dim j As Integer
            i = 0
            j = UBound(findex)
            Do While i < j
                If EditMode = AdEditInProgress Then
                    Save_Log_Object("ProAcc", "ProAcc", ProAcc, "", "", "", "", "", "", findex(i), rsH.fields(findex(i)), GetFieldValue(fbuffer(i)), "Update")
                End If
                rsH.fields(findex(i)) = GetFieldValue(fbuffer(i))
                i = i + 1
            Loop
            If Not db.GetPrivileges("ALLOWPASSSCANPAN") Then
                If isContainRestrictedPAN(rsH.fields("AccountNo")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field AccountNo!")
                End If
                If isContainRestrictedPAN(rsH.fields("REFNO")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field REFNO!")
                End If
                If isContainRestrictedPAN(rsH.fields("REMARKS")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field REMARKS!")
                End If
            End If
            If EditMode = AdEditAdd Then
                rsH.fields("ProAcc") = ProAcc
                rsH.fields("CDate") = Today.Date
                rsH.fields("UserID") = dbUser
            End If
            If Not db.GetPrivileges("UNRESTRICTPROACC") Then
                If toval(rsH.fields("RestrictedF")) <> toval(True) Then
                    If Not Save_Log_Object("ProAcc", "ProAcc", ProAcc, "", "", "", "", "", "", "RestrictedF", toval(rsH.fields("RestrictedF")), toval(True), "Update") Then Throw New Exception("Can't Save to Log !")
                    rsH.fields("RestrictedF") = True
                    rsH.fields("PUserDate") = Today.Date
                    rsH.fields("PUserID") = dbUser
                End If
            Else
                If toval(rsH.fields("RestrictedF")) <> toval(False) Then
                    If Not Save_Log_Object("ProAcc", "ProAcc", ProAcc, "", "", "", "", "", "", "RestrictedF", toval(rsH.fields("RestrictedF")), toval(False), "Update") Then Throw New Exception("Can't Save to Log !")
                    rsH.fields("RestrictedF") = False
                    rsH.fields("PUserDate") = Today.Date
                    rsH.fields("PUserID") = dbUser
                End If
            End If
            rsH.fields("Last_Update") = Today.Date
            rsH.fields("Last_Opr") = dbUser
            If Not rsH.Update Then Throw New Exception(db.ErrDesc)


            ' Set Output Parameter
            ReDim OutParam(1)
            OutParam(0) = rsH.fields("ProAcc")
            OutParam(1) = rsH.fields("RestrictedF")

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function DropProAcc(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim ProAcc As String
            ProAcc = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from ProAcc Where ProAcc='" & ProAcc & "'")
            If rs.Eof Then
                ErrMsg = "No Profile Account Data !"
                Throw New Exception(ErrMsg)
            End If
            If Not rs.Delete Then Throw New Exception(db.ErrDesc)
            If Not Save_Log_Object("ProAcc", "ProAcc", ProAcc, "", "", "", "", "", "", "", "", "", "Delete") Then Throw New Exception("Can't Save to Log !")

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function GetBankAccount(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef findex As String(), ByRef fbuffer As String(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String
            Voucher = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select RefType, AccountNo, BankAccount, Bank, BankBranch, BankName, BankChargesF from Admlink Where Voucher='" & Voucher & "'")
            findex = rs.fields_index()
            fbuffer = rs.GetRecord()

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SaveBankAccount(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal findex() As String, ByVal fbuffer() As String, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String
            Dim UpdateProfileAccountF As Boolean
            Voucher = getInParamValue(InParam, 0)
            UpdateProfileAccountF = toval(getInParamValue(InParam, 1))

            If Not db.GetPrivileges("ALLOWPASSSCANPAN") Then
                If isContainRestrictedPAN(GetFieldValue(fbuffer(GetFieldIndex("AccountNo", findex)))) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field AccountNo!")
                End If
            End If

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from Admlink Where Voucher='" & Voucher & "'")
            Do While Not rs.Eof
                rs.Edit()
                rs.fields("RefType") = GetFieldValue(fbuffer(GetFieldIndex("RefType", findex)))
                rs.fields("AccountNo") = GetFieldValue(fbuffer(GetFieldIndex("AccountNo", findex)))
                rs.fields("BankAccount") = GetFieldValue(fbuffer(GetFieldIndex("BankAccount", findex)))
                rs.fields("Bank") = GetFieldValue(fbuffer(GetFieldIndex("Bank", findex)))
                rs.fields("BankBranch") = GetFieldValue(fbuffer(GetFieldIndex("BankBranch", findex)))
                rs.fields("BankName") = GetFieldValue(fbuffer(GetFieldIndex("BankName", findex)))
                rs.fields("BankChargesF") = GetFieldValue(fbuffer(GetFieldIndex("BankChargesF", findex)))
                If Not rs.Update Then Throw New Exception(rs.ErrDesc)
                rs.MoveNext()
            Loop

            Dim ProAcc As String = ""
            rs = db.OpenRemoteSet("Select * from nVoucher Where Voucher='" & Voucher & "'")
            If rs.Eof Then
                Throw New Exception("DN/CN Voucher Not Found !")
            End If
            ProAcc = rs.fields("ProAcc")
            rs.Edit()
            rs.fields("RefType") = GetFieldValue(fbuffer(GetFieldIndex("RefType", findex)))
            rs.fields("AccountNo") = GetFieldValue(fbuffer(GetFieldIndex("AccountNo", findex)))
            rs.fields("BankAccount") = GetFieldValue(fbuffer(GetFieldIndex("BankAccount", findex)))
            rs.fields("Bank") = GetFieldValue(fbuffer(GetFieldIndex("Bank", findex)))
            rs.fields("BankBranch") = GetFieldValue(fbuffer(GetFieldIndex("BankBranch", findex)))
            rs.fields("BankName") = GetFieldValue(fbuffer(GetFieldIndex("BankName", findex)))
            If Not rs.Update Then Throw New Exception(rs.ErrDesc)

            If UpdateProfileAccountF Then
                rs = db.OpenRemoteSet("Select * from ProAcc Where ProAcc='" & ProAcc & "'")
                rs.Edit()
                Save_Log_Object("ProAcc", "ProAcc", ProAcc, "", "", "", "", "", "", "RefType", rs.fields("RefType"), GetFieldValue(fbuffer(GetFieldIndex("RefType", findex))), "Update")
                rs.fields("RefType") = GetFieldValue(fbuffer(GetFieldIndex("RefType", findex)))

                Save_Log_Object("ProAcc", "ProAcc", ProAcc, "", "", "", "", "", "", "AccountNo", rs.fields("AccountNo"), GetFieldValue(fbuffer(GetFieldIndex("AccountNo", findex))), "Update")
                rs.fields("AccountNo") = GetFieldValue(fbuffer(GetFieldIndex("AccountNo", findex)))

                Save_Log_Object("ProAcc", "ProAcc", ProAcc, "", "", "", "", "", "", "BankAccount", rs.fields("BankAccount"), GetFieldValue(fbuffer(GetFieldIndex("BankAccount", findex))), "Update")
                rs.fields("BankAccount") = GetFieldValue(fbuffer(GetFieldIndex("BankAccount", findex)))

                Save_Log_Object("ProAcc", "ProAcc", ProAcc, "", "", "", "", "", "", "Bank", rs.fields("Bank"), GetFieldValue(fbuffer(GetFieldIndex("Bank", findex))), "Update")
                rs.fields("Bank") = GetFieldValue(fbuffer(GetFieldIndex("Bank", findex)))

                Save_Log_Object("ProAcc", "ProAcc", ProAcc, "", "", "", "", "", "", "BankBranch", rs.fields("BankBranch"), GetFieldValue(fbuffer(GetFieldIndex("BankBranch", findex))), "Update")
                rs.fields("BankBranch") = GetFieldValue(fbuffer(GetFieldIndex("BankBranch", findex)))

                Save_Log_Object("ProAcc", "ProAcc", ProAcc, "", "", "", "", "", "", "BankName", rs.fields("BankName"), GetFieldValue(fbuffer(GetFieldIndex("BankName", findex))), "Update")
                rs.fields("BankName") = GetFieldValue(fbuffer(GetFieldIndex("BankName", findex)))

                If Not db.GetPrivileges("UNRESTRICTPROACC") Then
                    If Not Save_Log_Object("ProAcc", "ProAcc", ProAcc, "", "", "", "", "", "", "RestrictedF", rs.fields("RestrictedF"), True, "Update") Then Throw New Exception("Can't Save to Log !")
                    rs.fields("RestrictedF") = True
                    rs.fields("PUserDate") = Today.Date
                    rs.fields("PUserID") = dbUser
                Else
                    If Not Save_Log_Object("ProAcc", "ProAcc", ProAcc, "", "", "", "", "", "", "RestrictedF", rs.fields("RestrictedF"), False, "Update") Then Throw New Exception("Can't Save to Log !")
                    rs.fields("RestrictedF") = False
                    rs.fields("PUserDate") = Today.Date
                    rs.fields("PUserID") = dbUser
                End If
                rs.fields("Last_Update") = Today.Date
                rs.fields("Last_Opr") = dbUser

                If Not rs.Update Then Throw New Exception(rs.ErrDesc)
            End If


            ' Set Output Parameter
            ReDim OutParam(1)
            If UpdateProfileAccountF Then
                OutParam(0) = Voucher
                OutParam(1) = rs.fields("RestrictedF")
            Else
                OutParam(0) = Voucher
                OutParam(1) = False
            End If


            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function


    <WebMethod(EnableSession:=False)> _
    Public Function GetBudgetEntry(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef findex As String(), ByRef fbuffer As String(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Year As Integer = getInParamValue(InParam, 0)
            Dim Branch As String = getInParamValue(InParam, 1)
            Dim CT As String = getInParamValue(InParam, 2)
            Dim GID As String = getInParamValue(InParam, 3)
            Dim Account As String = getInParamValue(InParam, 4)

            Dim rs As RemoteSet
            Dim SQL As String
            SQL = "Select B1.Branch, B1.CT, B1.GID, B1.Status, B2.ID, B2.Account_Dr as Account, B1.Remarks, B1.Currency, B1.Total"
            SQL = SQL & " from Budget_Entry B1 "
            SQL = SQL & " inner Join Budget_AccountDetail B2 on (B2.GID=B1.GID and B2.ID=B1.ID)"
            SQL = SQL & " Where B1.Year=" & Year
            SQL = SQL & " and B1.Branch='" & Branch & "'"
            SQL = SQL & " and B1.CT='" & CT & "'"
            SQL = SQL & " and B1.GID='" & GID & "'"
            SQL = SQL & " and B2.Account_Dr='" & Account & "'"
            rs = db.OpenRemoteSet(SQL)

            findex = rs.fields_index()
            fbuffer = rs.GetRecord()

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SaveBudgetEntry(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal findex() As String, ByVal fbuffer() As String, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Year As Integer = getInParamValue(InParam, 0)
            Dim Branch As String = getInParamValue(InParam, 1)
            Dim CT As String = getInParamValue(InParam, 2)
            Dim GID As String = getInParamValue(InParam, 3)
            Dim Account As String = getInParamValue(InParam, 4)


            Dim rs As RemoteSet
            Dim ID As String
            Dim Currency As String
            rs = db.OpenRemoteSet("Select B2.ID, B2.Currency from FL_Budget_AccountGroup('" & GetFieldValue(fbuffer(GetFieldIndex("Branch", findex))) & "','" & GetFieldValue(fbuffer(GetFieldIndex("CT", findex))) & "') B1 Inner Join Budget_AccountDetail B2 on (B2.GID=B1.GID and B2.AllowedF=1) Where B2.GID='" & GetFieldValue(fbuffer(GetFieldIndex("GID", findex))) & "' and B2.Account_Dr='" & GetFieldValue(fbuffer(GetFieldIndex("Account", findex))) & "'")
            If rs.Eof Then
                Throw New Exception("Budget Account Not Found !")
            End If

            ID = rs.fields("ID")
            Currency = rs.fields("Currency")

            Dim SQL As String
            SQL = "Select B1.Status, B2.ID"
            SQL = SQL & " from Budget_Entry B1 "
            SQL = SQL & " inner Join Budget_AccountDetail B2 on (B2.GID=B1.GID and B2.ID=B1.ID)"
            SQL = SQL & " Where B1.Year=" & Year
            SQL = SQL & " and B1.Branch='" & Branch & "'"
            SQL = SQL & " and B1.CT='" & CT & "'"
            SQL = SQL & " and B1.GID='" & GID & "'"
            SQL = SQL & " and B2.Account_Dr='" & Account & "'"
            rs = db.OpenRemoteSet(SQL)

            If rs.Eof Then
                rs = db.OpenRemoteSet("Select * from Budget_Entry Where 1<>1")
                rs.AddNew()
                rs.fields("Type") = "I"
                rs.fields("pHist_No") = -1
                rs.fields("Hist_No") = -1
            Else
                If rs.fields("Status") <> "N" Then
                    Throw New Exception("Please Check Budget Entry Status !")
                End If
                rs = db.OpenRemoteSet("Select * from Budget_Entry Where Year=" & Year & " and Branch='" & Branch & "' and CT='" & CT & "' and GID='" & GID & "' and ID='" & rs.fields("ID") & "'")
                rs.Edit()
            End If
            rs.fields("Year") = Year
            rs.fields("Branch") = GetFieldValue(fbuffer(GetFieldIndex("Branch", findex)))
            rs.fields("CT") = GetFieldValue(fbuffer(GetFieldIndex("CT", findex)))
            rs.fields("GID") = GetFieldValue(fbuffer(GetFieldIndex("GID", findex)))
            rs.fields("Remarks") = GetFieldValue(fbuffer(GetFieldIndex("Remarks", findex)))
            rs.fields("ID") = ID
            rs.fields("Currency") = Currency
            rs.fields("Total") = toval(GetFieldValue(fbuffer(GetFieldIndex("Total", findex))))
            For i = 1 To 12
                rs.fields("Month_" & i) = toval(rs.fields("Total")) / 12
            Next
            rs.fields("Status") = "N"
            rs.fields("Last_Opr") = dbUser
            rs.fields("Last_Update") = Today.Date

            If Not rs.Update Then Throw New Exception(rs.ErrDesc)


            ' Set Output Parameter
            ReDim OutParam(3)
            OutParam(0) = GetFieldValue(fbuffer(GetFieldIndex("Branch", findex)))
            OutParam(1) = GetFieldValue(fbuffer(GetFieldIndex("CT", findex)))
            OutParam(2) = GetFieldValue(fbuffer(GetFieldIndex("GID", findex)))
            OutParam(3) = GetFieldValue(fbuffer(GetFieldIndex("Account", findex)))


            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function DropBudgetEntry(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Year As Integer = getInParamValue(InParam, 0)
            Dim Branch As String = getInParamValue(InParam, 1)
            Dim CT As String = getInParamValue(InParam, 2)
            Dim GID As String = getInParamValue(InParam, 3)
            Dim Account As String = getInParamValue(InParam, 4)

            Dim rs As RemoteSet
            Dim SQL As String
            SQL = "Select B1.Status, B2.ID"
            SQL = SQL & " from Budget_Entry B1 "
            SQL = SQL & " inner Join Budget_AccountDetail B2 on (B2.GID=B1.GID and B2.ID=B1.ID)"
            SQL = SQL & " Where B1.Year=" & Year
            SQL = SQL & " and B1.Branch='" & Branch & "'"
            SQL = SQL & " and B1.CT='" & CT & "'"
            SQL = SQL & " and B1.GID='" & GID & "'"
            SQL = SQL & " and B2.Account_Dr='" & Account & "'"
            rs = db.OpenRemoteSet(SQL)

            If rs.Eof Then
                Throw New Exception("Budget Entry Data Not Found !")
            Else
                If rs.fields("Status") <> "N" Then
                    Throw New Exception("Please Check Budget Entry Status !")
                End If
            End If

            Dim ID As String = rs.fields("ID")

            SQL = "Delete B1"
            SQL = SQL & " from Budget_Entry B1 "
            SQL = SQL & " Where B1.Year=" & Year
            SQL = SQL & " and B1.Branch='" & Branch & "'"
            SQL = SQL & " and B1.CT='" & CT & "'"
            SQL = SQL & " and B1.GID='" & GID & "'"
            SQL = SQL & " and B1.ID='" & ID & "'"
            If Not db.Execute(SQL) Then Throw New Exception(db.ErrDesc)

            If Not Save_Log_Object("Budget_Entry", "Year", Year, "Branch", Branch, "CT", CT, "Account", Account, "", "", "", "Delete") Then Throw New Exception("Can't Save to Log !")

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function DeclineBudgetEntry(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Year As Integer = getInParamValue(InParam, 0)
            Dim Branch As String = getInParamValue(InParam, 1)
            Dim CT As String = getInParamValue(InParam, 2)
            Dim GID As String = getInParamValue(InParam, 3)
            Dim Account As String = getInParamValue(InParam, 4)

            Dim rs As RemoteSet
            Dim SQL As String
            SQL = "Select B1.Status, B2.ID"
            SQL = SQL & " from Budget_Entry B1 "
            SQL = SQL & " inner Join Budget_AccountDetail B2 on (B2.GID=B1.GID and B2.ID=B1.ID)"
            SQL = SQL & " Where B1.Year=" & Year
            SQL = SQL & " and B1.Branch='" & Branch & "'"
            SQL = SQL & " and B1.CT='" & CT & "'"
            SQL = SQL & " and B1.GID='" & GID & "'"
            SQL = SQL & " and B2.Account_Dr='" & Account & "'"
            rs = db.OpenRemoteSet(SQL)

            If rs.Eof Then
                Throw New Exception("Budget Entry Data Not Found !")
            Else
                If rs.fields("Status") <> "N" Then
                    Throw New Exception("Please Check Budget Entry Status !")
                End If
            End If

            Dim ID As String = rs.fields("ID")

            SQL = "Update B1 Set Status='C', Last_Opr='" & dbUser & "',Last_Update='" & Format(Today.Date, "MM/DD/YYYY") & "'"
            SQL = SQL & " from Budget_Entry B1 "
            SQL = SQL & " Where B1.Year=" & Year
            SQL = SQL & " and B1.Branch='" & Branch & "'"
            SQL = SQL & " and B1.CT='" & CT & "'"
            SQL = SQL & " and B1.GID='" & GID & "'"
            SQL = SQL & " and B1.ID='" & ID & "'"
            If Not db.Execute(SQL) Then Throw New Exception(db.ErrDesc)

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function ReviseBudgetEntry(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal findex() As String, ByVal fbuffer() As String, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Year As Integer = getInParamValue(InParam, 0)
            Dim Branch As String = getInParamValue(InParam, 1)
            Dim CT As String = getInParamValue(InParam, 2)
            Dim GID As String = getInParamValue(InParam, 3)
            Dim Account As String = getInParamValue(InParam, 4)

            Dim rs As RemoteSet
            Dim ID As String
            Dim Currency As String
            rs = db.OpenRemoteSet("Select B2.ID, B2.Currency from FL_Budget_AccountGroup('" & GetFieldValue(fbuffer(GetFieldIndex("Branch", findex))) & "','" & GetFieldValue(fbuffer(GetFieldIndex("CT", findex))) & "') B1 Inner Join Budget_AccountDetail B2 on (B2.GID=B1.GID and B2.AllowedF=1) Where B2.GID='" & GetFieldValue(fbuffer(GetFieldIndex("GID", findex))) & "' and B2.Account_Dr='" & GetFieldValue(fbuffer(GetFieldIndex("Account", findex))) & "'")
            If rs.Eof Then
                Throw New Exception("Budget Account Not Found !")
            End If

            ID = rs.fields("ID")
            Currency = rs.fields("Currency")

            Dim SQL As String
            SQL = "Select B1.Status, B2.ID"
            SQL = SQL & " from Budget_Entry B1 "
            SQL = SQL & " inner Join Budget_AccountDetail B2 on (B2.GID=B1.GID and B2.ID=B1.ID)"
            SQL = SQL & " Where B1.Year=" & Year
            SQL = SQL & " and B1.Branch='" & Branch & "'"
            SQL = SQL & " and B1.CT='" & CT & "'"
            SQL = SQL & " and B1.GID='" & GID & "'"
            SQL = SQL & " and B2.Account_Dr='" & Account & "'"
            rs = db.OpenRemoteSet(SQL)

            If rs.Eof Then
                Throw New Exception("Budget Entry Not Found !")
            Else
                If rs.fields("Status") = "N" Then
                    Throw New Exception("Please Check Budget Entry Status !")
                End If
            End If

            Dim pHist_No As Long = -1
            Dim Hist_No As Long = -1

            rs = db.OpenRemoteSet("Select * from Budget_Entry Where Year=" & Year & " and Branch='" & Branch & "' and CT='" & CT & "' and GID='" & GID & "' and ID='" & rs.fields("ID") & "'")
            If Not rs.Eof AndAlso rs.fields("Status") = "P" Then
                rs.Edit()
                pHist_No = toval(rs.fields("Hist_No"))
                Hist_No = ProcessBudgetEntry(pHist_No, Year, Branch, CT, GID, rs.fields("ID"), Account, -1, ErrMsg)
                If Hist_No = -1 Then
                    Throw New Exception(ErrMsg)
                End If
                rs.fields("pHist_No") = pHist_No
                rs.fields("Hist_No") = Hist_No
                rs.fields("Status") = "C"
                rs.fields("Last_Opr") = dbUser
                rs.fields("Last_Update") = Today.Date
                If Not rs.Update Then Throw New Exception(rs.Update)
            End If

            ' Revised Budget
            rs = db.OpenRemoteSet("Select * from Budget_Entry Where Year=" & Year & " and Branch='" & GetFieldValue(fbuffer(GetFieldIndex("Branch", findex))) & "' and CT='" & GetFieldValue(fbuffer(GetFieldIndex("CT", findex))) & "' and GID='" & GetFieldValue(fbuffer(GetFieldIndex("GID", findex))) & "' and ID='" & ID & "'")
            If Not (rs.Eof OrElse rs.fields("Status") <> "P") Then
                Throw New Exception("Can't Revise into Budget Entry which already exists !")
            End If

            If rs.Eof Then
                rs.AddNew()
                rs.fields("Type") = "I"
                rs.fields("pHist_No") = -1
                rs.fields("Hist_No") = -1
            Else
                rs.Edit()
            End If
            rs.fields("pHist_No") = pHist_No
            rs.fields("Year") = Year
            rs.fields("Branch") = GetFieldValue(fbuffer(GetFieldIndex("Branch", findex)))
            rs.fields("CT") = GetFieldValue(fbuffer(GetFieldIndex("CT", findex)))
            rs.fields("GID") = GetFieldValue(fbuffer(GetFieldIndex("GID", findex)))
            rs.fields("Remarks") = GetFieldValue(fbuffer(GetFieldIndex("Remarks", findex)))
            rs.fields("ID") = ID
            rs.fields("Currency") = Currency
            rs.fields("Total") = toval(GetFieldValue(fbuffer(GetFieldIndex("Total", findex))))
            For i = 1 To 12
                rs.fields("Month_" & i) = toval(rs.fields("Total")) / 12
            Next
            rs.fields("Status") = "N"
            rs.fields("AUserID") = ""
            rs.fields("AUserDate") = ""
            rs.fields("Last_Opr") = dbUser
            rs.fields("Last_Update") = Today.Date

            If Not rs.Update Then Throw New Exception(rs.ErrDesc)


            ' Set Output Parameter
            ReDim OutParam(3)
            OutParam(0) = GetFieldValue(fbuffer(GetFieldIndex("Branch", findex)))
            OutParam(1) = GetFieldValue(fbuffer(GetFieldIndex("CT", findex)))
            OutParam(2) = GetFieldValue(fbuffer(GetFieldIndex("GID", findex)))
            OutParam(3) = GetFieldValue(fbuffer(GetFieldIndex("Account", findex)))

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function

    Private Function ProcessBudgetEntry(ByVal pHist_No As Long, ByVal Year As Integer, ByVal Branch As String, ByVal CT As String, ByVal GID As String, ByVal ID As String, ByVal Account As String, ByVal sign As Integer, ByRef ErrMsg As String) As Long
        Try
            Dim SQL As String
            Dim rs As RemoteSet

            SQL = "Select B1.*"
            SQL = SQL & " from Budget_Entry B1 "
            SQL = SQL & " Where B1.Year=" & Year
            SQL = SQL & " and B1.Branch='" & Branch & "'"
            SQL = SQL & " and B1.CT='" & CT & "'"
            SQL = SQL & " and B1.GID='" & GID & "'"
            SQL = SQL & " and B1.ID='" & ID & "'"
            rs = db.OpenRemoteSet(SQL)

            Dim rsLog As RemoteSet
            Dim Hist_No As Long
            rsLog = db.OpenRemoteSet("Select * from Budget_Entry_Hist Where 1<>1")
            rsLog.AddNew()
            If Not db.backup_record(rs, rsLog) Then Throw New Exception(db.ErrDesc)
            Hist_No = db.GetIdentity("Budget_Entry_Hist") + 1
            rsLog.fields("pHist_No") = pHist_No
            rsLog.fields("Hist_No") = Hist_No
            For i = 1 To 12
                rsLog.fields("Month_" & i) = sign * toval(rsLog.fields("Month_" & i))
            Next i
            rsLog.fields("Total") = sign * toval(rsLog.fields("Total"))
            rsLog.fields("Last_Opr") = dbUser
            rsLog.fields("Last_Update") = Today.Date
            If Not rsLog.Update Then Throw New Exception(rsLog.ErrDesc)

            Dim pAccount As String
            Dim rsB As RemoteSet
            Dim rs_Account As RemoteSet

            rsB = db.OpenRemoteSet("Select * from CTBudget Where Account='" & Account & "' and Branch='" & Branch & "' and Year=" & Year & " and CT='" & CT & "'")
            If rsB.Eof Then
                rsB.AddNew()
                rsB.fields("Account") = Account
                rsB.fields("Branch") = Branch
                rsB.fields("Year") = Year
                rsB.fields("CT") = CT
            Else
                rsB.Edit()
            End If
            For i = 1 To 12
                rsB.fields("Month_" & i) = toval(rsB.fields("Month_" & i)) + sign * toval(rs.fields("Month_" & i))
            Next i
            If Not rsB.Update Then Throw New Exception(rsB.ErrDesc)

            pAccount = Account
            Do
                rsB = db.OpenRemoteSet("Select * from Budget Where Account='" & pAccount & "' and Branch='" & Branch & "' and Year=" & Year & "")
                If rsB.Eof Then
                    rsB.AddNew()
                    rsB.fields("Account") = pAccount
                    rsB.fields("Branch") = Branch
                    rsB.fields("Year") = Year
                Else
                    rsB.Edit()
                End If
                For i = 1 To 12
                    rsB.fields("Month_" & i) = toval(rsB.fields("Month_" & i)) + sign * toval(rs.fields("Month_" & i))
                Next i
                If Not rsB.Update Then Throw New Exception(rsB.ErrDesc)

                rs_Account = db.OpenRemoteSet("Select Parent from Account Where Account='" & pAccount & "'")
                pAccount = rs_Account.fields("Parent")
            Loop Until pAccount = "0"
            Return Hist_No
        Catch ex As Exception
            ErrMsg = ex.Message
            Return -1
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function ProcessBudgetEntry(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Year As Integer = getInParamValue(InParam, 0)
            Dim Branch As String = getInParamValue(InParam, 1)
            Dim CT As String = getInParamValue(InParam, 2)
            Dim GID As String = getInParamValue(InParam, 3)
            Dim Account As String = getInParamValue(InParam, 4)

            Dim rs As RemoteSet
            Dim SQL As String
            SQL = "Select B1.pHist_No, B1.GID, B1.Status, B2.ID, B2.Account_Dr as Account, B1.Remarks, B1.Currency, B1.Total"
            SQL = SQL & " from Budget_Entry B1 "
            SQL = SQL & " inner Join Budget_AccountDetail B2 on (B2.GID=B1.GID and B2.ID=B1.ID)"
            SQL = SQL & " Where B1.Year=" & Year
            SQL = SQL & " and B1.Branch='" & Branch & "'"
            SQL = SQL & " and B1.CT='" & CT & "'"
            SQL = SQL & " and B1.GID='" & GID & "'"
            SQL = SQL & " and B2.Account_Dr='" & Account & "'"
            rs = db.OpenRemoteSet(SQL)

            If rs.Eof Then
                Throw New Exception("Budget Entry Data Not Found !")
            Else
                If rs.fields("Status") <> "N" Then
                    Throw New Exception("Please Check Budget Entry Status !")
                End If
            End If

            Dim ID As String = rs.fields("ID")
            Dim Hist_No As Long = -1
            Hist_No = ProcessBudgetEntry(toval(rs.fields("pHist_No")), Year, Branch, CT, GID, ID, Account, 1, ErrMsg)
            If Hist_No <> -1 Then
                If Not db.Execute("Update Budget_Entry set Status='P', AUserID='" & dbUser & "', AUserDate='" & Format(Today.Date, "MM/DD/YYYY") & "', Hist_No=" & Hist_No & " Where Year=" & Year & " and Branch='" & Branch & "' and CT='" & CT & "' and GID='" & GID & "' and ID='" & ID & "'") Then
                    Throw New Exception(db.ErrDesc)
                End If
            Else
                Throw New Exception(ErrMsg)
            End If

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function UndoProcessBudgetEntry(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Year As Integer = getInParamValue(InParam, 0)
            Dim Branch As String = getInParamValue(InParam, 1)
            Dim CT As String = getInParamValue(InParam, 2)
            Dim GID As String = getInParamValue(InParam, 3)
            Dim Account As String = getInParamValue(InParam, 4)

            Dim rs As RemoteSet
            Dim SQL As String
            SQL = "Select B1.GID, B1.Status, B2.ID, B2.Account_Dr as Account, B1.Remarks, B1.Currency, B1.Total"
            SQL = SQL & " from Budget_Entry B1 "
            SQL = SQL & " inner Join Budget_AccountDetail B2 on (B2.GID=B1.GID and B2.ID=B1.ID)"
            SQL = SQL & " Where B1.Year=" & Year
            SQL = SQL & " and B1.Branch='" & Branch & "'"
            SQL = SQL & " and B1.CT='" & CT & "'"
            SQL = SQL & " and B1.GID='" & GID & "'"
            SQL = SQL & " and B2.Account_Dr='" & Account & "'"
            rs = db.OpenRemoteSet(SQL)

            If rs.Eof Then
                Throw New Exception("Budget Entry Data Not Found !")
            Else
                If rs.fields("Status") <> "P" Then
                    Throw New Exception("Please Check Budget Entry Status !")
                End If
            End If

            Dim ID As String = rs.fields("ID")

            Dim pHist_No As Long = -1
            Dim Hist_No As Long = -1

            rs = db.OpenRemoteSet("Select * from Budget_Entry Where Year=" & Year & " and Branch='" & Branch & "' and CT='" & CT & "' and GID='" & GID & "' and ID='" & ID & "'")
            If Not rs.Eof AndAlso rs.fields("Status") = "P" Then
                rs.Edit()
                pHist_No = toval(rs.fields("Hist_No"))
                Hist_No = ProcessBudgetEntry(pHist_No, Year, Branch, CT, GID, ID, Account, -1, ErrMsg)
                If Hist_No = -1 Then
                    Throw New Exception(ErrMsg)
                End If
                rs.fields("pHist_No") = pHist_No
                rs.fields("Hist_No") = Hist_No
                rs.fields("Status") = "N"
                rs.fields("AUserID") = ""
                rs.fields("AUserDate") = ""
                rs.fields("Last_Opr") = dbUser
                rs.fields("Last_Update") = Today.Date
                If Not rs.Update Then Throw New Exception(rs.Update)
            End If

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    Private Function GetItemValue(ByVal FName As String, ByVal Dataset As DataSet, ByVal i As Integer) As Object
        Try
            GetItemValue = Dataset.Tables(0).Rows(i)(FName)
        Catch ex As Exception
            GetItemValue = ""
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function VerifyBudgetEntry(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam() As Object, ByRef OutParam() As Object, ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            Dim ProcessOpt As Integer = getInParamValue(InParam, 0)
            Dim Year As Integer = getInParamValue(InParam, 1)

            Dim i As Long
            Dim NumVerify As Long = 0
            db.Begintrans()
            For i = 0 To Dataset.Tables(0).Rows.Count - 1
                If (Dataset.Tables(0).Rows(i)("ProcessFlag") = True) Then
                    Try
                        Dim rs As RemoteSet
                        Dim Branch As String
                        Dim CT As String
                        Dim GID As String
                        Dim Account As String

                        Dim Mode As String
                        Dim NewBranch As String
                        Dim NewCT As String
                        Dim NewGID As String
                        Dim NewAccount As String

                        Dim Remarks As String
                        Dim Total As Double
                        StrMsg = ""

                        Mode = tostr(GetItemValue("Mode", Dataset, i)).ToUpper
                        If Mode = "" Then Mode = "UPDATE"

                        If Mode <> "ADD" AndAlso Mode <> "EDIT" AndAlso Mode <> "UPDATE" AndAlso Mode <> "REVISION" Then
                            StrMsg = StrMsg & "Incorrect Mode (ADD/EDIT/UPDATE/REVISION) !" & vbCrLf
                        End If

                        Branch = tostr(GetItemValue("Branch", Dataset, i))
                        CT = tostr(GetItemValue("CT", Dataset, i))
                        GID = tostr(GetItemValue("GID", Dataset, i))
                        Account = tostr(GetItemValue("Account", Dataset, i))

                        NewBranch = tostr(GetItemValue("NewBranch", Dataset, i))
                        NewCT = tostr(GetItemValue("NewCT", Dataset, i))
                        NewGID = tostr(GetItemValue("NewGID", Dataset, i))
                        NewAccount = tostr(GetItemValue("NewAccount", Dataset, i))

                        If Mode = "ADD" Then
                            NewBranch = Branch
                            NewCT = CT
                            NewGID = GID
                            NewAccount = Account
                        Else
                            If NewBranch = "" Then NewBranch = Branch
                            If NewCT = "" Then NewCT = CT
                            If NewGID = "" Then NewGID = GID
                            If NewAccount = "" Then NewAccount = Account
                        End If

                        Remarks = tostr(GetItemValue("Remarks", Dataset, i))
                        Total = tostr(GetItemValue("Nominal", Dataset, i))

                        rs = db.OpenRemoteSet("Select Branch from FN_UserBranch('" & dbUser & "') B Where B.Branch='" & NewBranch & "'")
                        If rs.Eof Then
                            StrMsg = StrMsg & "Branch Not Found ! (Branch : " & NewBranch & ")" & vbCrLf
                        End If

                        rs = db.OpenRemoteSet("Select Branch from FN_UserCT('" & dbUser & "','" & NewBranch & "','') B Where B.CT='" & NewCT & "'")
                        If rs.Eof Then
                            StrMsg = StrMsg & "CT Not Found ! (CT : " & NewCT & ")" & vbCrLf
                        End If

                        rs = db.OpenRemoteSet("Select GID from FL_Budget_AccountGroup('" & NewBranch & "','" & NewCT & "') B Where B.GID='" & NewGID & "'")
                        If rs.Eof Then
                            StrMsg = StrMsg & "Budget Group Not Found ! (GID : " & NewGID & ")" & vbCrLf
                        End If

                        rs = db.OpenRemoteSet("Select ID from Budget_AccountDetail B Where B.GID='" & NewGID & "' and Account_Dr='" & NewAccount & "'")
                        If rs.Eof Then
                            StrMsg = StrMsg & "Budget Account Not Found ! (GID : " & NewGID & ", Account : " & NewAccount & ")" & vbCrLf
                        End If

                        Dim SQL As String
                        SQL = "Select B1.GID, B1.Status, B2.ID, B2.Account_Dr as Account, B1.Remarks, B1.Currency, B1.Total"
                        SQL = SQL & " from Budget_Entry B1 "
                        SQL = SQL & " inner Join Budget_AccountDetail B2 on (B2.GID=B1.GID and B2.ID=B1.ID)"
                        SQL = SQL & " Where B1.Year=" & Year
                        SQL = SQL & " and B1.Branch='" & Branch & "'"
                        SQL = SQL & " and B1.CT='" & CT & "'"
                        SQL = SQL & " and B1.GID='" & GID & "'"
                        SQL = SQL & " and B2.Account_Dr='" & Account & "'"
                        rs = db.OpenRemoteSet(SQL)

                        Select Case Mode
                            Case "ADD"
                                If Not rs.Eof Then
                                    StrMsg = StrMsg & "Budget Entry already exists ! (GID : " & GID & ", Account : " & Account & ")" & vbCrLf
                                End If
                            Case "EDIT"
                                If rs.Eof Then
                                    StrMsg = StrMsg & "Budget Entry Not Found ! (GID : " & GID & ", Account : " & Account & ")" & vbCrLf
                                ElseIf rs.fields("Status") <> "N" Then
                                    StrMsg = StrMsg & "Please Check Budget Entry Status ! (GID : " & GID & ", Account : " & Account & ")" & vbCrLf
                                End If
                            Case "UPDATE"
                                If Not rs.Eof AndAlso rs.fields("Status") <> "N" Then
                                    StrMsg = StrMsg & "Please Check Budget Entry Status ! (GID : " & GID & ", Account : " & Account & ")" & vbCrLf
                                End If
                            Case "REVISION"
                                If rs.Eof Then
                                    StrMsg = StrMsg & "Budget Entry Not Found ! (GID : " & GID & ", Account : " & Account & ")" & vbCrLf
                                ElseIf rs.fields("Status") = "N" Then
                                    StrMsg = StrMsg & "Please Check Budget Entry Status ! (GID : " & GID & ", Account : " & Account & ")" & vbCrLf
                                End If
                        End Select

                        If StrMsg = "" Then
                            Dataset.Tables(0).Rows(i)("Status") = "Verified"
                        Else
                            Dataset.Tables(0).Rows(i)("Status") = "failed "
                        End If

                    Catch ex As Exception
                        StrMsg = StrMsg & ex.Message
                        Dataset.Tables(0).Rows(i)("Status") = "failed "
                    End Try
                    Dataset.Tables(0).Rows(i)("Message") = StrMsg
                    NumVerify = NumVerify + 1
                End If
            Next


            ReDim OutParam(1)
            OutParam(0) = NumVerify
            OutParam(1) = ""

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function UploadBudgetEntry(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam() As Object, ByRef OutParam() As Object, ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            Dim ProcessOpt As Integer = getInParamValue(InParam, 0)
            Dim Year As Integer = getInParamValue(InParam, 1)

            Dim i As Long
            Dim numProcess As Long = 0
            db.Begintrans()

            For i = 0 To Dataset.Tables(0).Rows.Count - 1
                StrMsg = ""
                If (Dataset.Tables(0).Rows(i)("ProcessFlag") = True) And (Dataset.Tables(0).Rows(i)("Status") = "Verified" Or ProcessOpt <> 0) Then
                    If Dataset.Tables(0).Rows(i)("Status") <> "Verified" And ProcessOpt = 2 Then
                        ErrMsg = "Record No. " & i + 1 & " is not Verified Yet !"
                        Throw New Exception(ErrMsg)
                    End If
                    Try
                        Dim rs As RemoteSet
                        Dim Branch As String
                        Dim CT As String
                        Dim GID As String
                        Dim Remarks As String
                        Dim Account As String
                        Dim Total As Double
                        Dim ID As String
                        Dim Currency As String

                        Dim Mode As String
                        Dim NewBranch As String
                        Dim NewCT As String
                        Dim NewGID As String
                        Dim NewAccount As String
                        Dim j As Integer

                        Mode = tostr(GetItemValue("Mode", Dataset, i)).ToUpper
                        If Mode = "" Then Mode = "ADD"

                        Branch = tostr(GetItemValue("Branch", Dataset, i))
                        CT = tostr(GetItemValue("CT", Dataset, i))
                        GID = tostr(GetItemValue("GID", Dataset, i))
                        Account = tostr(GetItemValue("Account", Dataset, i))
                        Remarks = tostr(GetItemValue("Remarks", Dataset, i))
                        Total = tostr(GetItemValue("Nominal", Dataset, i))

                        NewBranch = tostr(GetItemValue("NewBranch", Dataset, i))
                        NewCT = tostr(GetItemValue("NewCT", Dataset, i))
                        NewGID = tostr(GetItemValue("NewGID", Dataset, i))
                        NewAccount = tostr(GetItemValue("NewAccount", Dataset, i))

                        If Mode = "ADD" Then
                            NewBranch = Branch
                            NewCT = CT
                            NewGID = GID
                            NewAccount = Account
                        Else
                            If NewBranch = "" Then NewBranch = Branch
                            If NewCT = "" Then NewCT = CT
                            If NewGID = "" Then NewGID = GID
                            If NewAccount = "" Then NewAccount = Account
                        End If

                        rs = db.OpenRemoteSet("Select B2.ID, B2.Currency from FL_Budget_AccountGroup('" & NewBranch & "','" & NewCT & "') B1 Inner Join Budget_AccountDetail B2 on (B2.GID=B1.GID and B2.AllowedF=1) Where B2.GID='" & NewGID & "' and B2.Account_Dr='" & NewAccount & "'")
                        If rs.Eof Then
                            Throw New Exception("Budget Account Not Found ! (GID : " & NewGID & ", Account : " & NewAccount & ")")
                        End If

                        ID = rs.fields("ID")
                        Currency = rs.fields("Currency")

                        If Mode = "ADD" OrElse Mode = "EDIT" OrElse Mode = "UPDATE" Then
                            Dim SQL As String
                            SQL = "Select B1.GID, B1.Status, B2.ID, B2.Account_Dr as Account, B1.Remarks, B1.Currency, B1.Total"
                            SQL = SQL & " from Budget_Entry B1 "
                            SQL = SQL & " inner Join Budget_AccountDetail B2 on (B2.GID=B1.GID and B2.ID=B1.ID)"
                            SQL = SQL & " Where B1.Year=" & Year
                            SQL = SQL & " and B1.Branch='" & Branch & "'"
                            SQL = SQL & " and B1.CT='" & CT & "'"
                            SQL = SQL & " and B1.GID='" & GID & "'"
                            SQL = SQL & " and B2.Account_Dr='" & Account & "'"
                            rs = db.OpenRemoteSet(SQL)

                            If rs.Eof Then
                                rs = db.OpenRemoteSet("Select * from Budget_Entry Where 1<>1")
                                rs.AddNew()
                                rs.fields("Type") = "I"
                                rs.fields("pHist_No") = -1
                                rs.fields("Hist_No") = -1
                            Else
                                If rs.fields("Status") <> "N" Then
                                    Throw New Exception("Please Check Budget Entry Status !")
                                End If
                                rs = db.OpenRemoteSet("Select * from Budget_Entry Where Year=" & Year & " and Branch='" & Branch & "' and CT='" & CT & "' and GID='" & GID & "' and ID='" & rs.fields("ID") & "'")
                                rs.Edit()
                            End If
                            rs.fields("Year") = Year
                            rs.fields("Branch") = NewBranch
                            rs.fields("CT") = NewCT
                            rs.fields("GID") = NewGID
                            rs.fields("Remarks") = Remarks
                            rs.fields("ID") = ID
                            rs.fields("Currency") = Currency
                            rs.fields("Total") = Total
                            For j = 1 To 12
                                rs.fields("Month_" & j) = toval(rs.fields("Total")) / 12
                            Next
                            rs.fields("Status") = "N"
                            rs.fields("Last_Opr") = dbUser
                            rs.fields("Last_Update") = Today.Date
                            If Not rs.Update Then Throw New Exception(rs.ErrDesc)
                        Else
                            Dim SQL As String
                            SQL = "Select B1.Status, B2.ID"
                            SQL = SQL & " from Budget_Entry B1 "
                            SQL = SQL & " inner Join Budget_AccountDetail B2 on (B2.GID=B1.GID and B2.ID=B1.ID)"
                            SQL = SQL & " Where B1.Year=" & Year
                            SQL = SQL & " and B1.Branch='" & Branch & "'"
                            SQL = SQL & " and B1.CT='" & CT & "'"
                            SQL = SQL & " and B1.GID='" & GID & "'"
                            SQL = SQL & " and B2.Account_Dr='" & Account & "'"
                            rs = db.OpenRemoteSet(SQL)

                            If rs.Eof Then
                                Throw New Exception("Budget Entry Not Found !")
                            Else
                                If rs.fields("Status") = "N" Then
                                    Throw New Exception("Please Check Budget Entry Status !")
                                End If
                            End If

                            Dim pHist_No As Long = -1
                            Dim Hist_No As Long = -1

                            rs = db.OpenRemoteSet("Select * from Budget_Entry Where Year=" & Year & " and Branch='" & Branch & "' and CT='" & CT & "' and GID='" & GID & "' and ID='" & rs.fields("ID") & "'")
                            If Not rs.Eof AndAlso rs.fields("Status") = "P" Then
                                rs.Edit()
                                pHist_No = toval(rs.fields("Hist_No"))
                                Hist_No = ProcessBudgetEntry(pHist_No, Year, Branch, CT, GID, rs.fields("ID"), Account, -1, ErrMsg)
                                If Hist_No = -1 Then
                                    Throw New Exception(ErrMsg)
                                End If
                                rs.fields("pHist_No") = pHist_No
                                rs.fields("Hist_No") = Hist_No
                                rs.fields("Status") = "C"
                                rs.fields("Last_Opr") = dbUser
                                rs.fields("Last_Update") = Today.Date
                                If Not rs.Update Then Throw New Exception(rs.Update)
                            End If

                            ' Revised Budget
                            rs = db.OpenRemoteSet("Select * from Budget_Entry Where Year=" & Year & " and Branch='" & NewBranch & "' and CT='" & NewCT & "' and GID='" & NewGID & "' and ID='" & ID & "'")
                            If Not (rs.Eof OrElse rs.fields("Status") <> "P") Then
                                Throw New Exception("Can't Revise into Budget Entry which already exists !")
                            End If

                            If rs.Eof Then
                                rs.AddNew()
                                rs.fields("Type") = "I"
                                rs.fields("pHist_No") = -1
                                rs.fields("Hist_No") = -1
                            Else
                                rs.Edit()
                            End If
                            rs.fields("pHist_No") = pHist_No
                            rs.fields("Year") = Year
                            rs.fields("Branch") = NewBranch
                            rs.fields("CT") = NewCT
                            rs.fields("GID") = NewGID
                            rs.fields("Remarks") = Remarks
                            rs.fields("ID") = ID
                            rs.fields("Currency") = Currency
                            rs.fields("Total") = Total
                            For j = 1 To 12
                                rs.fields("Month_" & j) = toval(rs.fields("Total")) / 12
                            Next
                            rs.fields("Status") = "N"
                            rs.fields("AUserID") = ""
                            rs.fields("AUserDate") = ""
                            rs.fields("Last_Opr") = dbUser
                            rs.fields("Last_Update") = Today.Date

                            If Not rs.Update Then Throw New Exception(rs.ErrDesc)
                        End If


                        If StrMsg = "" Then
                            Dataset.Tables(0).Rows(i)("Status") = "Processed"
                        Else
                            Dataset.Tables(0).Rows(i)("Status") = "failed "
                        End If
                    Catch ex As Exception
                        StrMsg = ex.Message
                        Dataset.Tables(0).Rows(i)("Status") = "failed "
                    End Try
                    Dataset.Tables(0).Rows(i)("Message") = StrMsg
                    numProcess = numProcess + 1
                End If

            Next

            ReDim OutParam(0)
            OutParam(0) = numProcess

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SearchComAcc(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim ComAcc As String = getInParamValue(InParam, 0)
            Dim AccName As String = getInParamValue(InParam, 1)
            Dim Currency As String = getInParamValue(InParam, 2)
            Dim Description As String = getInParamValue(InParam, 3)
            Dim AccountNo As String = getInParamValue(InParam, 4)
            Dim Status As String = getInParamValue(InParam, 5)

            Dim SQL As String
            SQL = "Select Cast(0 as bit) as ProcessFlag, ComAcc.*"
            SQL = SQL & " from ComAcc"
            SQL = SQL & " Where 1=1"
            If ComAcc <> "" Then
                SQL = SQL & " and ComAcc Like '" & ComAcc & "%'"
            End If
            If AccName <> "" Then
                SQL = SQL & " and (AccName_1 Like '" & AccName & "%' or AccName_2 Like '" & AccName & "%')"
            End If
            If Currency <> "" Then
                SQL = SQL & " and Currency Like '" & Currency & "%'"
            End If
            If Description <> "" Then
                SQL = SQL & " and Description Like '" & Description & "%'"
            End If
            If AccountNo <> "" Then
                SQL = SQL & " and AccountNo Like '" & AccountNo & "%'"
            End If
            Select Case Status
                Case "All Status"
                Case "Restricted"
                    SQL = SQL & " and RestrictedF=1"
                Case "Not Restricted"
                    SQL = SQL & " and RestrictedF=0"
            End Select

            Dim rs As RemoteSet
            Dim C_MaxRecords As Long
            C_MaxRecords = toval(GetAppSetting("CareMaxRecords"))
            If toval(GetAppSetting("CareMaxRecords_FA")) > C_MaxRecords Then
                C_MaxRecords = toval(GetAppSetting("CareMaxRecords_FA"))
            End If
            rs = db.OpenRemoteSet(SQL, , , , C_MaxRecords)
            Dataset = rs.GetDataSet

            If Dataset Is Nothing Then Throw New Exception(ErrMsg)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function CheckComAcc(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim ComAcc As String = getInParamValue(InParam, 0)
            Dim Remarks As String = getInParamValue(InParam, 1)
            Dim RESTRICTAFTERUSEDF As Boolean = toval(getInParamValue(InParam, 2))

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from ComAcc Where ComAcc='" & ComAcc & "'")
            If rs.Eof Then
                ErrMsg = "No Company Account Data !"
                Throw New Exception(ErrMsg)
            ElseIf Not toval(rs.fields("RestrictedF")) Then
                ErrMsg = "Company Account is not restricted Yet !"
                Throw New Exception(ErrMsg)
            End If
            rs.Edit()
            If toval(rs.fields("RESTRICTAFTERUSEDF")) <> toval(RESTRICTAFTERUSEDF) Then
                If Not Save_Log_Object("ComAcc", "ComAcc", ComAcc, "", "", "", "", "", "", "RESTRICTAFTERUSEDF", toval(rs.fields("RESTRICTAFTERUSEDF")), toval(RESTRICTAFTERUSEDF), "Update") Then Throw New Exception("Can't Save to Log !")
                rs.fields("RESTRICTAFTERUSEDF") = RESTRICTAFTERUSEDF
            End If
            If toval(rs.fields("RestrictedF")) <> toval(False) Then
                If Not Save_Log_Object("ComAcc", "ComAcc", ComAcc, "", "", "", "", "", "", "RestrictedF", toval(rs.fields("RestrictedF")), toval(False), "Update") Then Throw New Exception("Can't Save to Log !")
                rs.fields("RestrictedF") = False
            End If
            If rs.fields("Remarks") <> Remarks Then
                If Not Save_Log_Object("ComAcc", "ComAcc", ComAcc, "", "", "", "", "", "", "Remarks", rs.fields("Remarks"), Remarks, "Update") Then Throw New Exception("Can't Save to Log !")
                rs.fields("Remarks") = Remarks
            End If
            rs.fields("PUserDate") = Today.Date
            rs.fields("PUserID") = dbUser
            If Not rs.Update Then Throw New Exception(rs.ErrDesc)

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function RestrictComAcc(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim ComAcc As String = getInParamValue(InParam, 0)
            Dim Remarks As String = getInParamValue(InParam, 1)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from ComAcc Where ComAcc='" & ComAcc & "'")
            If rs.Eof Then
                ErrMsg = "No Company Account Data !"
                Throw New Exception(ErrMsg)
            ElseIf toval(rs.fields("RestrictedF")) Then
                ErrMsg = "Company Account is Already restricted !"
                Throw New Exception(ErrMsg)
            End If
            rs.Edit()
            If toval(rs.fields("RestrictedF")) <> toval(True) Then
                If Not Save_Log_Object("ComAcc", "ComAcc", ComAcc, "", "", "", "", "", "", "RestrictedF", toval(rs.fields("RestrictedF")), toval(True), "Update") Then Throw New Exception("Can't Save to Log !")
                rs.fields("RestrictedF") = True
            End If
            If rs.fields("Remarks") <> Remarks Then
                If Not Save_Log_Object("ComAcc", "ComAcc", ComAcc, "", "", "", "", "", "", "Remarks", rs.fields("Remarks"), Remarks, "Update") Then Throw New Exception("Can't Save to Log !")
                rs.fields("Remarks") = Remarks
            End If
            rs.fields("PUserDate") = Today.Date
            rs.fields("PUserID") = dbUser
            If Not rs.Update Then Throw New Exception(rs.ErrDesc)

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function GetComAcc(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef findex As String(), ByRef fbuffer As String(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim ComAcc As String
            ComAcc = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            rs = db.OpenQueryDef("QComAcc", adOpenKeyset, ComAcc)
            findex = rs.fields_index()
            fbuffer = rs.GetRecord()

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SaveComAcc(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal findex() As String, ByVal fbuffer() As String, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim ComAcc As String
            ComAcc = getInParamValue(InParam, 0)

            Dim rsH As RemoteSet
            Dim EditMode As Integer

            rsH = db.OpenRemoteSet("Select * from ComAcc Where ComAcc='" & ComAcc & "'")
            If rsH.Eof Then
                rsH.AddNew()
            Else
                rsH.Edit()
            End If
            EditMode = rsH.editmode

            ' Check Status
            If EditMode = AdEditInProgress Then
                ' Nothing
            End If

            Dim i As Integer
            Dim j As Integer
            i = 0
            j = UBound(findex)
            Do While i < j
                If EditMode = AdEditInProgress Then
                    If Not Save_Log_Object("ComAcc", "ComAcc", ComAcc, "", "", "", "", "", "", findex(i), rsH.fields(findex(i)), GetFieldValue(fbuffer(i)), "Update") Then Throw New Exception("Can't Save to Log !")
                End If
                rsH.fields(findex(i)) = GetFieldValue(fbuffer(i))
                i = i + 1
            Loop
            If EditMode = AdEditAdd Then
                rsH.fields("ComAcc") = ComAcc
                rsH.fields("CDate") = Today.Date
                rsH.fields("UserID") = dbUser
            End If
            If Not db.GetPrivileges("UNRESTRICTCOMACC") Then
                If toval(rsH.fields("RestrictedF")) <> toval(True) Then
                    If Not Save_Log_Object("ComAcc", "ComAcc", ComAcc, "", "", "", "", "", "", "RestrictedF", toval(rsH.fields("RestrictedF")), toval(True), "Update") Then Throw New Exception("Can't Save to Log !")
                    rsH.fields("RestrictedF") = True
                    rsH.fields("PUserDate") = Today.Date
                    rsH.fields("PUserID") = dbUser
                End If
            Else
                If toval(rsH.fields("RestrictedF")) <> toval(False) Then
                    If Not Save_Log_Object("ComAcc", "ComAcc", ComAcc, "", "", "", "", "", "", "RestrictedF", toval(rsH.fields("RestrictedF")), toval(False), "Update") Then Throw New Exception("Can't Save to Log !")
                    rsH.fields("RestrictedF") = False
                    rsH.fields("PUserDate") = Today.Date
                    rsH.fields("PUserID") = dbUser
                End If
            End If
            rsH.fields("Last_Update") = Today.Date
            rsH.fields("Last_Opr") = dbUser
            If Not rsH.Update Then Throw New Exception(db.ErrDesc)


            ' Set Output Parameter
            ReDim OutParam(1)
            OutParam(0) = rsH.fields("ComAcc")
            OutParam(1) = rsH.fields("RestrictedF")

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function DropComAcc(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim ComAcc As String
            ComAcc = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from ComAcc Where ComAcc='" & ComAcc & "'")
            If rs.Eof Then
                ErrMsg = "No Company Account Data !"
                Throw New Exception(ErrMsg)
            End If
            If Not rs.Delete Then Throw New Exception(db.ErrDesc)
            If Not Save_Log_Object("ComAcc", "ComAcc", ComAcc, "", "", "", "", "", "", "", "", "", "Delete") Then Throw New Exception("Can't Save to Log !")

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SearchVoucher(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Value1 As String = getInParamValue(InParam, 0)   ' Voucher No,
            Dim Value2 As String = getInParamValue(InParam, 1)   ' RefNo
            Dim Value3 As String = getInParamValue(InParam, 2)   ' Start Voucher Date, Format "MM/DD/YYYY"
            Dim Value4 As String = getInParamValue(InParam, 3)   ' End Voucher Date, Format "MM/DD/YYYY"
            Dim Value5 As String = getInParamValue(InParam, 4)   ' ProAcc
            Dim Value6 As String = getInParamValue(InParam, 5)   ' ProAcc Description
            Dim Value7 As String = getInParamValue(InParam, 6)   ' ComAcc
            Dim Value8 As String = getInParamValue(InParam, 7)   ' VType
            Dim Value9 As String = getInParamValue(InParam, 8)   ' Currency
            Dim Value10 As String = getInParamValue(InParam, 9)  ' Search Nominal
            Dim Value11 As String = getInParamValue(InParam, 10) ' SL_Cat
            Dim Value12 As String = getInParamValue(InParam, 11) ' Voucher Status P/U/N
            Dim Value13 As String = getInParamValue(InParam, 12) ' DocNo
            Dim Value14 As String = getInParamValue(InParam, 13) ' Remarks
            Dim Value15 As String = getInParamValue(InParam, 14) ' AccountNo
            Dim Value16 As String = getInParamValue(InParam, 15) ' RefType
            Dim Value17 As String = getInParamValue(InParam, 16) ' CollNo
            Dim Value18 As String = getInParamValue(InParam, 17) ' Policy No
            Dim Value19 As String = getInParamValue(InParam, 18) ' Original Document No.
            Dim Value20 As String = getInParamValue(InParam, 19) ' Subject 'Premium or Claim
            Dim Value21 As String = getInParamValue(InParam, 20) ' Branch
            Dim Value22 As String = getInParamValue(InParam, 21) ' Last Opr
            Dim Value23 As String = getInParamValue(InParam, 22) ' Journal Status
            Dim Value24 As String = getInParamValue(InParam, 23) ' MO
            Dim Value25 As String = getInParamValue(InParam, 24) ' BatchNo
            Dim Value26 As String = getInParamValue(InParam, 25) ' ASource
            Dim Value27 As String = getInParamValue(InParam, 26) ' Transaction Type
            Dim Value28 As String = getInParamValue(InParam, 27) ' OR NO
            Dim Value29 As String = getInParamValue(InParam, 28) ' Business Source

            Dim sfilter As String
            sfilter = ""
            If Value1 <> "" Then
                sfilter = sfilter & " and (V.Voucher like " & "'" & Value1 & "%')"
            End If

            If Value2 <> "" Then
                sfilter = sfilter & " and (V.RefNo like " & "'" & Value2 & "%')"
            End If

            If Value3 <> "" And Value4 <> "" Then
                sfilter = sfilter & " and (V.Date between '" & Value3 & "' and '" & Value4 & "')"
            ElseIf Value3 <> "" Then
                sfilter = sfilter & " and (V.Date='" & Value3 & "')"
            ElseIf Value4 <> "" Then
                sfilter = sfilter & " and (V.Date='" & Value4 & "')"
            End If

            If Value5 <> "" Then
                sfilter = sfilter & " and (V.ProAcc like " & "'" & Value5 & "%')"
            End If

            If Value6 <> "" Then
                sfilter = sfilter & " and (P.Description like " & "'" & Value6 & "%')"
            End If

            If Value7 <> "" Then
                sfilter = sfilter & " and (V.ComAcc like " & "'" & Value7 & "%')"
            End If

            If Value8 <> "" Then
                sfilter = sfilter & " and (V.VType like " & "'" & Value8 & "%')"
            End If

            If Value9 <> "" Then
                sfilter = sfilter & " and (V.Currency like " & "'" & Value9 & "%')"
            End If

            If Value10 <> "" Then
                If Value11 <> "M" And Value11 <> "X" And Value11 <> "J" Then
                    sfilter = sfilter & " and (round(V.Nominal_CC-V.Diff_CC,2)=" & tovalSF(Math.Round(toval(Value10), 2, MidpointRounding.AwayFromZero)) & ")"
                Else
                    sfilter = sfilter & " and (Exists (Select Voucher from mJournal J Where J.Voucher=V.Voucher and round(J.Debit-J.Credit,2)=" & tovalSF(Math.Round(toval(Value10), 2, MidpointRounding.AwayFromZero)) & "))"
                End If
            End If

            If Value11 <> "" Then
                sfilter = sfilter & " and (V.SL_Cat=" & "'" & Value11 & "')"
            End If

            If Value12 <> "" Then
                sfilter = sfilter & " and (V.Status=" & "'" & Value12 & "')"
            End If

            If Value13 <> "" Then
                sfilter = sfilter & " and (V.DocNo like " & "'" & Value13 & "%')"
            End If

            If Value14 <> "" Then
                sfilter = sfilter & " and (V.Remarks like " & "'" & Value14 & "%')"
            End If

            If Value15 <> "" Then
                sfilter = sfilter & " and (V.AccountNo like " & "'" & Value15 & "%')"
            End If

            If Value16 <> "" Then
                sfilter = sfilter & " and (V.RefType like " & "'" & Value16 & "%')"
            End If

            Dim SQL As String

            If Value11 <> "N" Then
                SQL = "Select Distinct Cast(0 as bit) as ProcessFlag, V.Voucher, V.RefNo,V.DocNo, V.Date, V.Vtype, VType.Code, V.SL_Cat, V.DebtorF, V.Status, "
                SQL = SQL & "V.Remarks, V.ProAcc, coalesce(P.Description,'') as PDescription, V.ComAcc, coalesce(C.NonCBF,0) as NonCBF, coalesce(C.Description,'') as CDescription, V.Currency, V.Nominal_CC-V.Diff_CC as Nominal, "
                SQL = SQL & "V.AccountNo, V.BankAccount, V.BankName, V.DueDate, "
                SQL = SQL & "V.Payment_OC+V.Payment_CC as Payment, coalesce(A1.Nominal_CC-V.Payment_OC-V.Payment_CC,0) as UnPayment, "
                SQL = SQL & "cast('' as varchar(100)) as Request, cast('' as varchar(100)) as CollNo, "
                SQL = SQL & "Admlink.A_MO, Admlink.Source, Admlink.A_SDate, admlink.A_EDate, BS.Name as SourceName, V.PDate, "
                SQL = SQL & "("
                SQL = SQL & " SELECT coalesce(pVoucher.Voucher, OVoucher.Voucher)+char(13)+char(10)+' ' "
                SQL = SQL & " FROM pSL"
                SQL = SQL & " Inner Join pVoucher OVoucher on (oVoucher.Voucher=pSL.Voucher) "
                SQL = SQL & " Left Join pVoucher on (pVoucher.Voucher=OVoucher.RefNo and OVoucher.SL_Cat='B')"
                SQL = SQL & " WHERE pSL.Doc_No=V.Voucher and pSL.PaymentF=1 FOR XML PATH('')"
                SQL = SQL & ") as Reference"
            Else
                SQL = "Select Distinct Cast(0 as bit) as ProcessFlag, V.Voucher, V.RefNo,V.DocNo, V.Date, V.Vtype, VType.Code, V.SL_Cat, V.DebtorF, V.Status, "
                SQL = SQL & "V.Remarks, V.ProAcc, coalesce(P.Description,'') as PDescription, V.ComAcc, coalesce(C.NonCBF,0) as NonCBF, coalesce(C.Description,'') as CDescription, V.Currency, V.Nominal_CC-V.Diff_CC as Nominal, "
                SQL = SQL & "V.AccountNo, V.BankAccount, V.BankName, V.DueDate, "
                SQL = SQL & "V.Payment_OC+V.Payment_CC as Payment, coalesce(V.Nominal_CC-V.Diff_CC-V.Payment_OC-V.Payment_CC,0) as UnPayment, "
                SQL = SQL & "cast('' as varchar(100)) as Request, cast('' as varchar(100)) as CollNo, "
                SQL = SQL & "Admlink.A_MO, Admlink.Source, Admlink.A_SDate, admlink.A_EDate, BS.Name as SourceName, V.PDate, "
                SQL = SQL & "("
                SQL = SQL & " SELECT coalesce(pVoucher.Voucher, OVoucher.Voucher)+char(13)+char(10)+' ' "
                SQL = SQL & " FROM pSL"
                SQL = SQL & " Inner Join pVoucher OVoucher on (oVoucher.Voucher=pSL.Voucher) "
                SQL = SQL & " Left Join pVoucher on (pVoucher.Voucher=OVoucher.RefNo and OVoucher.SL_Cat='B')"
                SQL = SQL & " WHERE pSL.Doc_No=V.Voucher and pSL.PaymentF=1 FOR XML PATH('')"
                SQL = SQL & ") as Reference"
            End If

            Select Case Value11
                Case ""
                    SQL = SQL & " from Voucher V Inner Join fn_userVType('" & dbUser & "') VType on (VType.VType=V.VType)"
                Case "N"
                    SQL = SQL & " from nVoucher V Inner Join fn_userVType('" & dbUser & "') VType on (VType.VType=V.VType)"
                Case "M", "X", "J"
                    SQL = SQL & " from mVoucher V Inner Join fn_userVType('" & dbUser & "') VType on (VType.VType=V.VType)"
                Case Else
                    SQL = SQL & " from pVoucher V Inner Join fn_userVType('" & dbUser & "') VType on (VType.VType=V.VType)"
            End Select

            Select Case Value11
                Case ""
                    SQL = SQL & " Left Join Open_Item_Voucher('') as a1 on (a1.Voucher=V.Voucher) "
                Case "N"
                    ' Nothing
                Case "M", "X", "J"
                    SQL = SQL & " Left Join mVoucher as a1 on (a1.Voucher=V.Voucher) "
                Case Else
                    SQL = SQL & " Left Join Open_Item_Voucher_P('') as a1 on (a1.Voucher=V.Voucher) "
            End Select

            If Value17 <> "" Then
                SQL = SQL & " Inner Join CollectionV ON (CollectionV.Voucher=V.Voucher and CollectionV.CollNo like " & "'" & Value17 & "%')"
            End If

            If Value20 = "Premium" Then
                SQL = SQL & " Inner Join Admlink on (Admlink.Voucher=V.Voucher and Admlink.A_MO Like '" & Value24 & "%' and Admlink.A_PolicyNo Like '" & Value18 & "%' and Admlink.A_RefNo Like '" & Value19 & "%' and Admlink.BatchNo Like '" & Value25 & "%' and Admlink.ASource Like '" & Value26 & "%' and subject='Premium' and Admlink.Type Like '" & Value27 & "%' and Admlink.Source Like '" & Value29 & "%')"
            ElseIf Value20 = "Claim" Then
                SQL = SQL & " Inner Join Admlink on (Admlink.Voucher=V.Voucher and Admlink.A_MO Like '" & Value24 & "%' and Admlink.A_PolicyNo Like '" & Value18 & "%' and Admlink.A_RefNo Like '" & Value19 & "%' and Admlink.BatchNo Like '" & Value25 & "%' and Admlink.ASource Like '" & Value26 & "%' and subject='Claim' and Admlink.Type Like '" & Value27 & "%' and Admlink.Source Like '" & Value29 & "%')"
            ElseIf Value20 = "Claim Excess" Then
                SQL = SQL & " Inner Join Admlink on (((Admlink.Type='OP' and Admlink.Amount_8<>0) or (Admlink.Type='DI' and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) and Admlink.Voucher=V.Voucher and Admlink.A_MO Like '" & Value24 & "%' and Admlink.A_PolicyNo Like '" & Value18 & "%' and Admlink.A_RefNo Like '" & Value19 & "%' and Admlink.BatchNo Like '" & Value25 & "%' and Admlink.ASource Like '" & Value26 & "%' and subject='Claim' and Admlink.Type Like '" & Value27 & "%' and Admlink.Source Like '" & Value29 & "%')"
            ElseIf Value18 <> "" Or Value19 <> "" Or Value24 <> "" Or Value25 <> "" Or Value26 <> "" Or Value27 <> "" Or Value29 <> "" Then
                SQL = SQL & " Inner Join Admlink on (Admlink.Voucher=V.Voucher and Admlink.A_MO Like '" & Value24 & "%' and Admlink.A_PolicyNo Like '" & Value18 & "%' and Admlink.A_RefNo Like '" & Value19 & "%' and Admlink.BatchNo Like '" & Value25 & "%' and Admlink.ASource Like '" & Value26 & "%' and Admlink.Type Like '" & Value27 & "%' and Admlink.Source Like '" & Value29 & "%')"
            Else
                SQL = SQL & " Left Join Admlink on (Admlink.Voucher=V.Voucher)"
            End If

            If Value20 = "WithHolding Tax" Then
                sfilter = sfilter & " and VType.TaxF=1"
            End If

            If Value20 = "WithHolding VAT" Then
                sfilter = sfilter & " and VType.VatF=1"
            End If

            If Value21 <> "" Then
                sfilter = sfilter & " and (V.Branch like " & "'" & Value21 & "%')"
            End If

            If Value22 <> "" Then
                sfilter = sfilter & " and (V.Last_opr like " & "'" & Value22 & "%')"
            End If

            If Value23 <> "" Then
                Select Case Value23
                    Case "Y"
                        sfilter = sfilter & " and (V.Posting_Flag=1)"
                    Case "N"
                        sfilter = sfilter & " and (V.Posting_Flag=0)"
                End Select
            End If

            If Value28 <> "" Then
                sfilter = sfilter & " and exists (Select Top 1 O.Voucher from ORPrintLog O Where O.Voucher=V.Voucher and O.ORNo Like '" & Value28 & "%')"
            End If

            If db.GetUserType <> "SUPERVISOR" Then
                sfilter = sfilter & " and Exists (Select S.Branch from SysUserBranch S Where S.Branch=V.Branch and S.ID='" & dbUser & "' and S.AllowedF=1)"
                sfilter = sfilter & " and (coalesce(V.CT,'')='' or Exists (Select S.CT from FN_UserCT('" & dbUser & "',V.Branch,'') S Where S.CT=V.CT))"
            End If

            SQL = SQL & " Left join ProAcc P on (P.ProAcc=V.ProAcc) "
            SQL = SQL & " Left join ComAcc C on (C.ComAcc=V.ComAcc) "
            SQL = SQL & " Left join Profile BS on (BS.ID=Admlink.Source) "
            If sfilter <> "" Then
                SQL = SQL & " Where 1=1 " & sfilter
            End If

            Dim rs As RemoteSet
            Dim C_MaxRecords As Long
            C_MaxRecords = toval(GetAppSetting("CareMaxRecords"))
            If toval(GetAppSetting("CareMaxRecords_FA")) > C_MaxRecords Then
                C_MaxRecords = toval(GetAppSetting("CareMaxRecords_FA"))
            End If
            rs = db.OpenRemoteSet(SQL, , , , C_MaxRecords)
            Dataset = rs.GetDataSet

            Dim i As Integer
            For i = 0 To Dataset.Tables(0).Rows.Count - 1
                If Dataset.Tables(0).Rows(i)("SL_Cat") = "N" Then
                    Dim sCollNo As String = ""
                    rs = db.OpenRemoteSet("select CollectionH.CollNo, CollectionH.CollStatus from CollectionV, CollectionH where CollectionV.CollNo=CollectionH.CollNo and CollectionV.Voucher='" & Dataset.Tables(0).Rows(i)("Voucher") & "'")
                    Do While Not rs.Eof
                        If sCollNo = "" Then
                            sCollNo = tostr(rs.fields("CollNo")) & "(" & tostr(rs.fields("CollStatus")) & ")"
                        Else
                            sCollNo = sCollNo & vbCrLf & tostr(rs.fields("CollNo")) & "(" & tostr(rs.fields("CollStatus")) & ")"
                        End If
                        rs.MoveNext()
                    Loop
                    Dataset.Tables(0).Rows(i)("CollNo") = sCollNo
                End If
                If Dataset.Tables(0).Rows(i)("SL_Cat") = "N" Or Dataset.Tables(0).Rows(i)("SL_Cat") = "P" Then
                    Dim sRequest As String = ""
                    rs = db.OpenRemoteSet("Select R.Request, R.Status from SL_Request SL, Request R Where R.Request=SL.Request and SL.PaymentF=1 and SL.doc_no='" & Dataset.Tables(0).Rows(i)("Voucher") & "'")
                    Do While Not rs.Eof
                        If sRequest = "" Then
                            sRequest = tostr(rs.fields("Request")) & "(" & tostr(rs.fields("Status")) & ")"
                        Else
                            sRequest = sRequest & vbCrLf & tostr(rs.fields("Request")) & "(" & tostr(rs.fields("Status")) & ")"
                        End If
                        rs.MoveNext()
                    Loop
                    Dataset.Tables(0).Rows(i)("Request") = sRequest
                End If
            Next

            If Dataset Is Nothing Then Throw New Exception(ErrMsg)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function GetListPaidBy(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String
            Dim SL_Cat As String
            Dim SDate As Date
            Dim EDate As Date

            Voucher = getInParamValue(InParam, 0)
            SL_Cat = getInParamValue(InParam, 1)
            SDate = todate(getInParamValue(InParam, 2))
            EDate = todate(getInParamValue(InParam, 3))

            Dim rs As RemoteSet

            If DateDiff(DateInterval.Day, SDate, EDate) = 0 AndAlso DateDiff(DateInterval.Day, EDate, Today.Date) = 0 Then
                If SL_Cat = "P" Then
                    rs = db.OpenRemoteSet("select Cast(0 as bit) as ProcessFlag, SL.Doc_No, V.Voucher, V.RefNo, V.Date, V.RefDate, V.VType, V.SL_Cat, V.DebtorF, V.ProAcc, V.ComAcc, C.NonCBF, V.Currency, V.Status, SL.Doc_CCY, VType.Code, SL.Nominal_OC/SL.Rate as Nominal_OC, SL.Nominal_OC as Nominal, Case When SL.Rate>1 Then SL.Rate else 1 end as Nominator, Case When SL.Rate<1 Then 1/SL.Rate else 1 end as Denominator from pVoucher V Left Join VType On (VType.VType=V.VType) Left Join ComAcc C on (C.ComAcc=V.ComAcc), R_SL_ALLOCATED_BY_VOUCHER('" & tostr(Voucher) & "') SL where V.Voucher=SL.Voucher and SL.PaymentF=1 and SL.Doc_No Like '" & tostr(Voucher) & "%' Order By SL.Doc_No, V.Date")
                Else
                    rs = db.OpenRemoteSet("select Cast(0 as bit) as ProcessFlag, SL.Doc_No, V.Voucher, V.RefNo, V.Date, V.RefDate, V.VType, V.SL_Cat, V.DebtorF, V.ProAcc, V.ComAcc, C.NonCBF, V.Currency, V.Status, SL.Doc_CCY, VType.Code, dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, V.SL_Cat, V.DebtorF, nVoucher.DebtorF) as Nominal_OC, dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, V.SL_Cat, V.DebtorF, nVoucher.DebtorF)*SL.Rate as Nominal, Case When SL.Rate>1 Then SL.Rate else 1 end as Nominator, Case When SL.Rate<1 Then 1/SL.Rate else 1 end as Denominator from pVoucher V Left Join VType On (VType.VType=V.VType) Left Join ComAcc C on (C.ComAcc=V.ComAcc), pSL SL Left Join nVoucher on (nVoucher.Voucher=SL.Doc_No) where V.Voucher=SL.Voucher and SL.PaymentF=1 and SL.Doc_No Like '" & tostr(Voucher) & "%' Order By SL.Doc_No, V.Date")
                End If
            Else
                If SL_Cat = "P" Then
                    rs = db.OpenRemoteSet("select Cast(0 as bit) as ProcessFlag, SL.Doc_No, V.Voucher, V.RefNo, V.Date, V.RefDate, V.VType, V.SL_Cat, V.DebtorF, V.ProAcc, V.ComAcc, C.NonCBF, V.Currency, V.Status, SL.Doc_CCY, VType.Code, SL.Nominal_OC/SL.Rate as Nominal_OC, SL.Nominal_OC as Nominal, Case When SL.Rate>1 Then SL.Rate else 1 end as Nominator, Case When SL.Rate<1 Then 1/SL.Rate else 1 end as Denominator from pVoucher V Left Join VType On (VType.VType=V.VType) Left Join ComAcc C on (C.ComAcc=V.ComAcc), R_SL_ALLOCATED_BY_VOUCHER('" & tostr(Voucher) & "') SL where V.Voucher=SL.Voucher and SL.PaymentF=1 and SL.Doc_No Like '" & tostr(Voucher) & "%' and V.Date Between '" & Format(SDate, "MM/DD/YYYY") & "' and '" & Format(EDate, "MM/DD/YYYY") & "' Order By SL.Doc_No, V.Date")
                Else
                    rs = db.OpenRemoteSet("select Cast(0 as bit) as ProcessFlag, SL.Doc_No, V.Voucher, V.RefNo, V.Date, V.RefDate, V.VType, V.SL_Cat, V.DebtorF, V.ProAcc, V.ComAcc, C.NonCBF, V.Currency, V.Status, SL.Doc_CCY, VType.Code, dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, V.SL_Cat, V.DebtorF, nVoucher.DebtorF) as Nominal_OC, dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, V.SL_Cat, V.DebtorF, nVoucher.DebtorF)*SL.Rate as Nominal, Case When SL.Rate>1 Then SL.Rate else 1 end as Nominator, Case When SL.Rate<1 Then 1/SL.Rate else 1 end as Denominator from pVoucher V Left Join VType On (VType.VType=V.VType) Left Join ComAcc C on (C.ComAcc=V.ComAcc), pSL SL Left Join nVoucher on (nVoucher.Voucher=SL.Doc_No) where V.Voucher=SL.Voucher and SL.PaymentF=1 and SL.Doc_No Like '" & tostr(Voucher) & "%' and V.Date Between '" & Format(SDate, "MM/DD/YYYY") & "' and '" & Format(EDate, "MM/DD/YYYY") & "' Order By SL.Doc_No, V.Date")
                End If
            End If

            Dataset = rs.GetDataSet

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function GetListPaymentFor(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String
            Dim SL_Cat As String

            Voucher = getInParamValue(InParam, 0)
            SL_Cat = getInParamValue(InParam, 1)

            Dim rs As RemoteSet

            rs = db.OpenRemoteSet("select cast(0 as bit) as ProcessFlag, V.Voucher, V.RefNo, V.Date, V.VType, V.SL_Cat,V.DebtorF, V.ProAcc, V.ComAcc, C.NonCBF, V.Currency, V.Status, SL.Doc_CCY, Max(VType.Code) as Code, sum(SL.Nominal_OC/SL.Rate) as Nominal_OC, sum(SL.Nominal_OC) as Nominal, Max(Case When SL.Rate>1 Then SL.Rate else 1 end) as Nominator, Max(Case When SL.Rate<1 Then 1/SL.Rate else 1 end) as Denominator from pVoucher V Left Join VType On (VType.VType=V.VType) Left Join ComAcc C on (C.ComAcc=V.ComAcc), R_SL_ALLOCATED_BY_VOUCHER('" & tostr(Voucher) & "') SL where V.Voucher=SL.Doc_No and SL.PaymentF=1 and SL.Voucher='" & tostr(Voucher) & "' Group By V.Voucher, V.RefNo, V.Date, V.VType, V.SL_Cat,V.DebtorF, V.ProAcc, V.ComAcc, C.NonCBF, V.Currency, V.Status, SL.Doc_CCY Order By V.Date")
            Dataset = rs.GetDataSet

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function GetListVoucherRequest(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Request As String

            Request = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("select Cast(0 as bit) as ProcessFlag, V.Voucher, V.RefNo, V.Date, V.VType, V.SL_Cat, V.DebtorF, V.ProAcc, V.ComAcc, C.NonCBF, V.Currency, V.Status, SL.Doc_CCY, Max(VType.Code) as Code, sum(SL.Nominal_OC/SL.Rate) as Nominal_OC, sum(SL.Nominal_OC) as Nominal, Max(Case When SL.Rate>1 Then SL.Rate else 1 end) as Nominator, Max(Case When SL.Rate<1 Then 1/SL.Rate else 1 end) as Denominator from Request R Inner Join pVoucher V on (V.Voucher=R.Voucher) Left Join VType On (VType.VType=V.VType) Left Join ComAcc C on (C.ComAcc=V.ComAcc), SL_Allocated() SL where V.Voucher=SL.Voucher and SL.PaymentF=1 and R.Request='" & tostr(Request) & "' Group By V.Voucher, V.RefNo, V.Date, V.VType, V.SL_Cat,V.DebtorF, V.ProAcc, V.ComAcc, C.NonCBF, V.Currency, V.Status, SL.Doc_CCY Order By V.Date")

            Dataset = rs.GetDataSet

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function SearchBankBranch(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Bank As String = getInParamValue(InParam, 0)
            Dim BankBranch As String = getInParamValue(InParam, 1)
            Dim SQL As String

            SQL = "Select Cast(0 as bit) as ProcessFlag, BankBranch.*"
            SQL = SQL & " from BankBranch"
            SQL = SQL & " Where 1=1"

            If Bank <> "" Then
                SQL = SQL & " and BankBranch.Bank Like '" & Bank & "%'"
            End If

            If BankBranch <> "" Then
                SQL = SQL & " and BankBranch.BankBranch Like '" & BankBranch & "%'"
            End If

            Dim rs As RemoteSet
            Dim C_MaxRecords As Long
            C_MaxRecords = toval(GetAppSetting("CareMaxRecords"))
            If toval(GetAppSetting("CareMaxRecords_FA")) > C_MaxRecords Then
                C_MaxRecords = toval(GetAppSetting("CareMaxRecords_FA"))
            End If
            rs = db.OpenRemoteSet(SQL, , , , C_MaxRecords)
            Dataset = rs.GetDataSet

            If Dataset Is Nothing Then Throw New Exception(ErrMsg)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function GetBankBranch(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef findex As String(), ByRef fbuffer As String(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Bank As String = getInParamValue(InParam, 0)
            Dim BankBranch As String = getInParamValue(InParam, 1)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from BankBranch Where Bank='" & Bank & "' and BankBranch='" & BankBranch & "'")
            findex = rs.fields_index()
            fbuffer = rs.GetRecord()

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SaveBankBranch(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal findex() As String, ByVal fbuffer() As String, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Bank As String = getInParamValue(InParam, 0)
            Dim BankBranch As String = getInParamValue(InParam, 1)

            Dim rsH As RemoteSet
            Dim EditMode As Integer
            rsH = db.OpenRemoteSet("Select * from BankBranch Where Bank='" & Bank & "' and BankBranch='" & BankBranch & "'")
            If rsH.Eof Then
                rsH.AddNew()
            Else
                rsH.Edit()
            End If
            EditMode = rsH.editmode

            ' Check Status
            If EditMode = AdEditInProgress Then
                Dim NewBank As String = GetFieldValue(fbuffer(GetFieldIndex("Bank", findex)))
                Dim NewBankBranch As String = GetFieldValue(fbuffer(GetFieldIndex("BankBranch", findex)))
                If NewBank <> Bank Or NewBankBranch <> BankBranch Then
                    Dim rs As RemoteSet
                    rs = db.OpenRemoteSet("Select Top 1 Request from Request Where Bank='" & Bank & "' and BankBranch='" & BankBranch & "'")
                    If Not rs.Eof Then
                        ErrMsg = "Can't Change The Bank or Bank Branch; Already Used By Payment Request (" & rs.fields("Request") & ") !"
                        Throw New Exception(ErrMsg)
                    End If
                End If
            End If

            Dim i As Integer
            Dim j As Integer
            i = 0
            j = UBound(findex)
            Do While i < j
                If EditMode = AdEditInProgress Then
                    If Not Save_Log_Object("BankBranch", "Bank", Bank, "BankBranch", BankBranch, "", "", "", "", findex(i), rsH.fields(findex(i)), GetFieldValue(fbuffer(i)), "Update") Then Throw New Exception("Can't Save to Log !")
                End If
                rsH.fields(findex(i)) = GetFieldValue(fbuffer(i))
                i = i + 1
            Loop
            If EditMode = AdEditAdd Then
                rsH.fields("CDate") = Today.Date
                rsH.fields("UserID") = dbUser
            End If
            rsH.fields("Last_Update") = Today.Date
            rsH.fields("Last_Opr") = dbUser
            If Not rsH.Update Then Throw New Exception(db.ErrDesc)


            ' Set Output Parameter
            ReDim OutParam(1)
            OutParam(0) = rsH.fields("Bank")
            OutParam(1) = rsH.fields("BankBranch")

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function DropBankBranch(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Bank As String = getInParamValue(InParam, 0)
            Dim BankBranch As String = getInParamValue(InParam, 1)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select Top 1 Request from Request Where Bank='" & Bank & "' and BankBranch='" & BankBranch & "'")
            If Not rs.Eof Then
                ErrMsg = "Already Used By Payment Request (" & rs.fields("Request") & ") !"
                Throw New Exception(ErrMsg)
            End If

            rs = db.OpenRemoteSet("Select * from BankBranch Where Bank='" & Bank & "' and BankBranch='" & BankBranch & "'")
            If rs.Eof Then
                ErrMsg = "No Bank Branch Data !"
                Throw New Exception(ErrMsg)
            End If
            If Not rs.Delete Then Throw New Exception(db.ErrDesc)
            If Not Save_Log_Object("BankBranch", "Bank", Bank, "BankBranch", BankBranch, "", "", "", "", "", "", "", "Delete") Then Throw New Exception("Can't Save to Log !")

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SaveAccLink(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal findex() As String, ByVal fbuffer() As String, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim AccNo As String
            AccNo = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            Dim EditMode As Integer
            Dim Branch As String = GetFieldValue(fbuffer(GetFieldIndex("Branch", findex)))
            Dim VoucherDate As Date = GetFieldValue(fbuffer(GetFieldIndex("Date", findex)))

            If Not db.GetPrivileges("ALLOWLOCKEDPERIOD") Then
                If DateDiff(DateInterval.Day, GetFLockedDate(Branch), VoucherDate) <= 0 Then
                    ErrMsg = "Transactions for this period have been closed !"
                    Throw New Exception(ErrMsg)
                End If
            End If

            If Check_Backdated(Branch, VoucherDate) Then
                ErrMsg = "Please Check The Last Ending Posting Date !"
                Throw New Exception(ErrMsg)
            End If

            rs = db.OpenRemoteSet("Select * from AccLink Where AccNo=" & AccNo)
            If rs.Eof Then
                rs.AddNew()
            Else
                If rs.fields("VoucherF") Then
                    ErrMsg = "AccLink Already Posted !"
                    Throw New Exception(ErrMsg)
                ElseIf rs.fields("Extra_1") = "" Then
                    ErrMsg = "AccLink is System Generated !"
                    Throw New Exception(ErrMsg)
                End If
                rs.Edit()
            End If
            EditMode = rs.editmode

            If EditMode = AdEditAdd Then
                AccNo = db.GetIdentity("AccLink") + 1
            Else
                AccNo = rs.fields("AccNo")
            End If

            Dim i As Integer
            Dim j As Integer
            i = 0
            j = UBound(findex)
            Do While i < j
                rs.fields(findex(i)) = GetFieldValue(fbuffer(i))
                i = i + 1
            Loop
            rs.fields("Amount") = 0
            For i = 1 To 20
                rs.fields("Amount") = toval(rs.fields("Amount")) + toval(rs.fields("Amount_" & i))
            Next i
            rs.fields("AccNo") = AccNo
            rs.fields("Amount") = toval(rs.fields("Amount_1")) + toval(rs.fields("Amount_2")) + toval(rs.fields("Amount_3")) + toval(rs.fields("Amount_4")) + toval(rs.fields("Amount_5"))
            rs.fields("Subject") = "JOURNAL"
            rs.fields("LUserID") = dbUser
            rs.fields("LDate") = Today.Date
            rs.fields("LTime") = Time()
            If EditMode = AdEditAdd Then
                rs.fields("Extra_1") = "-"
            End If
            If Not rs.Update Then Throw New Exception(db.ErrDesc)

            ' Set Output Parameter
            ReDim OutParam(0)
            OutParam(0) = AccNo

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SaveAdmlink(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal findex() As String, ByVal fbuffer() As String, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim AdmNo As String
            AdmNo = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            Dim EditMode As Integer
            Dim Branch As String = GetFieldValue(fbuffer(GetFieldIndex("Branch", findex)))
            Dim VoucherDate As Date = GetFieldValue(fbuffer(GetFieldIndex("Date", findex)))

            Dim TaxMethod As Integer
            Dim TaxTableF As Boolean
            rs = db.OpenRemoteSet("Select TaxTableF, TaxMethod from SysTab")
            TaxMethod = toval(rs.fields("TaxMethod"))
            TaxTableF = toval(rs.fields("TaxTableF"))

            Dim pCode As String = GetFieldValue(fbuffer(GetFieldIndex("Code", findex)))
            Dim pType As String = GetFieldValue(fbuffer(GetFieldIndex("Type", findex)))
            Dim VAT As Double = toval(GetFieldValue(fbuffer(GetFieldIndex("VAT", findex))))
            Dim TAX As Double = toval(GetFieldValue(fbuffer(GetFieldIndex("TAX", findex))))

            Dim LockedDate As Date
            Dim BLLocked As Integer
            LockedDate = GetLockedDate(Branch)
            BLLocked = GetUserBLLocked(dbUser)

            If (DateDiff(DateInterval.Day, LockedDate, VoucherDate) <= 0 And (DateDiff(DateInterval.Day, LockedDate, Today.Date) > BLLocked Or BLLocked = 0)) Then
                ErrMsg = "Please Check The Transaction Closing Period (Locked Date) !"
                Throw New Exception(ErrMsg)
            End If

            Dim Br_End_Date As Date
            rs = db.OpenRemoteSet("Select End_Date from Branch Where Branch='" & Branch & "'")
            Br_End_Date = todate(rs.fields("End_Date"))

            If (DateDiff(DateInterval.Day, VoucherDate, Br_End_Date) >= 0) Then
                ErrMsg = "Please Check The Last Ending Posting Date !"
                Throw New Exception(ErrMsg)
            End If

            rs = db.OpenRemoteSet("Select * from Admlink Where AdmNo=" & AdmNo)
            If rs.Eof Then
                rs.AddNew()
            Else
                If rs.fields("VoucherF") Then
                    ErrMsg = "Admlink Already Posted !"
                    Throw New Exception(ErrMsg)
                ElseIf rs.fields("Extra_1") = "" Then
                    ErrMsg = "Admlink is System Generated !"
                    Throw New Exception(ErrMsg)
                End If
                rs.Edit()
            End If
            EditMode = rs.editmode

            If EditMode = AdEditAdd Then
                AdmNo = db.GetIdentity("Admlink") + 1
            Else
                AdmNo = rs.fields("AdmNo")
                If toval(rs.fields("TaxTableF")) Then
                    If Not Update_Tax_Table(tostr(rs.fields("ID")), todate(rs.fields("Date")), tostr(rs.fields("Currency")), -(toval(rs.fields("Amount")) - toval(rs.fields("Amount_13")) - toval(rs.fields("Amount_14"))), -toval(rs.fields("Amount_14"))) Then
                        ErrMsg = "Update Tax Table Failed !"
                        Throw New Exception(ErrMsg)
                    End If
                End If
            End If

            Dim i As Integer
            Dim j As Integer
            i = 0
            j = UBound(findex)
            Do While i < j
                rs.fields(findex(i)) = GetFieldValue(fbuffer(i))
                i = i + 1
            Loop
            If Not db.GetPrivileges("ALLOWPASSSCANPAN") Then
                If isContainRestrictedPAN(rs.fields("AccountNo")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field AccountNo!")
                End If
                If isContainRestrictedPAN(rs.fields("REFNO")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field REFNO!")
                End If
                If isContainRestrictedPAN(rs.fields("REMARKS")) Then
                    Throw New Exception("Contain Restricted PAN (Payment Account Number) in field REMARKS!")
                End If
            End If

            rs.fields("Amount") = 0
            For i = 1 To 20
                rs.fields("Amount") = toval(rs.fields("Amount")) + toval(rs.fields("Amount_" & i))
            Next i
            rs.fields("AdmNo") = AdmNo
            rs.fields("LUserID") = dbUser
            rs.fields("LDate") = Today.Date
            rs.fields("LTime") = Time()

            Dim TaxType As String
            TaxType = rs.fields("TaxType")
            If TaxType = "" Then TaxType = GetTaxType(rs.fields("ID"))

            Dim rsTaxType As RemoteSet
            rsTaxType = db.OpenRemoteSet("Select MTaxType from TaxType Where TaxType='" & TaxType & "'")

            If TaxTableF And rsTaxType.fields("MTaxType") = "PASAL21" And toval(rs.fields("Amount_14")) <> 0 Then
                rs.fields("TaxTableF") = TaxTableF
            End If
            If EditMode = AdEditAdd Then
                rs.fields("Extra_1") = "-"
            End If

            Dim PNominal_VAT As Double = 0
            Dim PNominal_Tax As Double = 0
            If TaxMethod = 0 Then   ' Indonesia/Thailand
                If Left(pType, 2) = "OT" Then
                    PNominal_VAT = (toval(rs.fields("Amount_15")))
                Else
                    PNominal_VAT = (toval(rs.fields("Amount_1")) + toval(rs.fields("Amount_2")) + toval(rs.fields("Amount_3")) + toval(rs.fields("Amount_4")) + toval(rs.fields("Amount_5")) + toval(rs.fields("Amount_6")) + toval(rs.fields("Amount_7")) + toval(rs.fields("Amount_8")) + toval(rs.fields("Amount_9")) + toval(rs.fields("Amount_10")) + toval(rs.fields("Amount_15")) + toval(rs.fields("Amount_16")) + toval(rs.fields("Amount_19")) + toval(rs.fields("Amount_20")))
                End If
            Else ' Philipine
                If Left(pType, 2) = "OT" Then
                    PNominal_VAT = (toval(rs.fields("Amount_15")))
                ElseIf (InStr("CPDCQSQPS1S2S3AFXPFOFPIRITIX", pType) <> 0) Then
                    ' VAT Only for Commission
                    PNominal_VAT = (toval(rs.fields("Amount_2")))
                Else
                    PNominal_VAT = (toval(rs.fields("Amount_1")) + toval(rs.fields("Amount_2")) + toval(rs.fields("Amount_5")) + toval(rs.fields("Amount_6")) + toval(rs.fields("Amount_7")) + toval(rs.fields("Amount_8")) + toval(rs.fields("Amount_9")) + toval(rs.fields("Amount_10")) + toval(rs.fields("Amount_19")) + toval(rs.fields("Amount_20")))
                End If
            End If
            If Left(pType, 2) = "OT" Then
                PNominal_Tax = (toval(rs.fields("Amount_15")))
            ElseIf (pType = "FO" Or pType = "FP" Or pType = "QS" Or pType = "QP" Or pType = "S1" Or pType = "S2" Or pType = "S3" Or pType = "AF") Then
                ' Excluding Commission 
                PNominal_Tax = (toval(rs.fields("Amount_1")) + toval(rs.fields("Amount_3")) + toval(rs.fields("Amount_4")) + toval(rs.fields("Amount_5")) + toval(rs.fields("Amount_6")) + toval(rs.fields("Amount_7")) + toval(rs.fields("Amount_8")) + toval(rs.fields("Amount_9")) + toval(rs.fields("Amount_10")) + toval(rs.fields("Amount_15")) + toval(rs.fields("Amount_16")) + toval(rs.fields("Amount_19")) + toval(rs.fields("Amount_20")))
            Else
                PNominal_Tax = (toval(rs.fields("Amount_1")) + toval(rs.fields("Amount_2")) + toval(rs.fields("Amount_3")) + toval(rs.fields("Amount_4")) + toval(rs.fields("Amount_5")) + toval(rs.fields("Amount_6")) + toval(rs.fields("Amount_7")) + toval(rs.fields("Amount_8")) + toval(rs.fields("Amount_9")) + toval(rs.fields("Amount_10")) + toval(rs.fields("Amount_15")) + toval(rs.fields("Amount_16")) + toval(rs.fields("Amount_19")) + toval(rs.fields("Amount_20")))
            End If

            If ((pType = "BB" Or pType = "BA" Or pType = "BC" Or pType = "BP" Or pType = "BD" Or pType = "OP" Or Left(pType, 2) = "OT") Or (VAT <> 0)) Then
                rs.fields("PNominal_VAT") = PNominal_VAT
            End If

            If ((pType = "BB" Or pType = "BA" Or pType = "BC" Or pType = "BP" Or pType = "BD" Or pType = "OP" Or Left(pType, 2) = "OT") Or (TAX <> 0)) Then
                rs.fields("PNominal_Tax") = PNominal_Tax
            End If

            If Not rs.Update Then Throw New Exception(db.ErrDesc)

            If toval(rs.fields("TaxTableF")) Then
                If Not Update_Tax_Table(tostr(rs.fields("ID")), todate(rs.fields("Date")), tostr(rs.fields("Currency")), (toval(rs.fields("Amount")) - toval(rs.fields("Amount_13")) - toval(rs.fields("Amount_14"))), toval(rs.fields("Amount_14"))) Then
                    ErrMsg = "Update Tax Table Failed !"
                    Throw New Exception(ErrMsg)
                End If
            End If

            ' Set Output Parameter
            ReDim OutParam(0)
            OutParam(0) = AdmNo

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    Private Function GetTaxType(ByVal ID As String) As String
        Dim rs As RemoteSet
        rs = db.OpenRemoteSet("Select TaxType from Profile Where ID='" & ID & "'")
        GetTaxType = tostr(rs.fields("TaxType"))
    End Function
    Private Function GetTaxTableFlag() As Boolean
        Dim rs As RemoteSet
        rs = db.OpenRemoteSet("Select TaxTableF from SysTab")
        GetTaxTableFlag = toval(rs.fields("TaxTableF"))
    End Function
    <WebMethod(EnableSession:=False)> _
        Public Function DropAccLink(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim AccNo As Long = getInParamValue(InParam, 0)
            If Not db.GetLockedObject("AccLink" & AccNo) Then Throw New Exception(db.ErrDesc)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from AccLink Where AccNo=" & AccNo)
            If rs.Eof Then
                ErrMsg = "No Acclink Data !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("VoucherF") Then
                ErrMsg = "AccLink Already Posted !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Extra_1") = "" Then
                ErrMsg = "AccLink is System Generated !"
                Throw New Exception(ErrMsg)
            End If

            If Not rs.Delete Then Throw New Exception(db.ErrDesc)

            If Not db.ReleaseLockedObject("AccLink" & AccNo) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
        Public Function DropAdmlink(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim AdmNo As Long = getInParamValue(InParam, 0)
            If Not db.GetLockedObject("Admlink" & AdmNo) Then Throw New Exception(db.ErrDesc)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from admlink Where AdmNo=" & AdmNo)
            If rs.Eof Then
                ErrMsg = "No Admlink Data !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("VoucherF") Then
                ErrMsg = "Admlink Already Posted !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Extra_1") = "" Then
                ErrMsg = "Admlink is System Generated !"
                Throw New Exception(ErrMsg)
            End If
            If toval(rs.fields("TaxTableF")) Then
                If Not Update_Tax_Table(tostr(rs.fields("ID")), todate(rs.fields("Date")), tostr(rs.fields("Currency")), -(toval(rs.fields("Amount")) - toval(rs.fields("Amount_13")) - toval(rs.fields("Amount_14"))), -toval(rs.fields("Amount_14"))) Then
                    ErrMsg = "Update Tax Table Failed !"
                    Throw New Exception(ErrMsg)
                End If
            End If

            If Not rs.Delete Then Throw New Exception(db.ErrDesc)

            If Not db.ReleaseLockedObject("Admlink" & AdmNo) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function CancelMemorial(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String = getInParamValue(InParam, 0)
            If Not db.GetLockedObject("Voucher" & Voucher) Then Throw New Exception(db.ErrDesc)

            Dim rs As RemoteSet

            rs = db.OpenRemoteSet("Select * from mVoucher Where Voucher='" & Voucher & "'")
            If rs.Eof Then
                ErrMsg = "No Memorial Data !"
                Throw New Exception(ErrMsg)
            End If

            If Not db.GetPrivileges("ALLOWLOCKEDPERIOD") Then
                If DateDiff(DateInterval.Day, GetFLockedDate(rs.fields("Branch")), rs.fields("Date")) <= 0 Then
                    ErrMsg = "Transactions for this period have been closed !"
                    Throw New Exception(ErrMsg)
                End If
            End If

            If Not Me.Direct_Call_Process_Execute("ProcessFA.NetV3.Proclib", "Cancel_AccLink_Memorial", Voucher) Then Throw New Exception(Me.ErrDesc)

            If Not db.ReleaseLockedObject("Voucher" & Voucher) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function CancelVoucher(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            If Not Me.Direct_Call_Process_Execute("Process.NetV3.Proclib", "Cancel_Voucher", InParam(0), True) Then Throw New Exception(Me.ErrDesc)

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
        Public Function WriteOffAcclink(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim AccNo As Long = getInParamValue(InParam, 0)
            If Not db.GetLockedObject("AccLink" & AccNo) Then Throw New Exception(db.ErrDesc)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from AccLink Where AccNo=" & AccNo)
            If rs.Eof Then
                ErrMsg = "No Acclink Data !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("VoucherF") Then
                ErrMsg = "AccLink Already Posted !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Extra_1") = "" Then
                ErrMsg = "AccLink is System Generated !"
                Throw New Exception(ErrMsg)
            End If

            rs.Edit()
            rs.fields("WriteF") = True
            If Not rs.Update Then Throw New Exception(db.ErrDesc)

            If Not db.ReleaseLockedObject("AccLink" & AccNo) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
        Public Function WriteOffAdmlink(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim AdmNo As Long = getInParamValue(InParam, 0)
            If Not db.GetLockedObject("Admlink" & AdmNo) Then Throw New Exception(db.ErrDesc)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from admlink Where AdmNo=" & AdmNo)
            If rs.Eof Then
                ErrMsg = "No Admlink Data !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("VoucherF") Then
                ErrMsg = "Admlink Already Posted !"
                Throw New Exception(ErrMsg)
            ElseIf rs.fields("Extra_1") = "" Then
                ErrMsg = "Admlink is System Generated !"
                Throw New Exception(ErrMsg)
            End If
            If toval(rs.fields("TaxTableF")) Then
                If Not Update_Tax_Table(tostr(rs.fields("ID")), todate(rs.fields("Date")), tostr(rs.fields("Currency")), -(toval(rs.fields("Amount")) - toval(rs.fields("Amount_13")) - toval(rs.fields("Amount_14"))), -toval(rs.fields("Amount_14"))) Then
                    ErrMsg = "Update Tax Table Failed !"
                    Throw New Exception(ErrMsg)
                End If
            End If
            rs.Edit()
            rs.fields("WriteF") = True
            If Not rs.Update Then Throw New Exception(db.ErrDesc)

            If Not db.ReleaseLockedObject("Admlink" & AdmNo) Then Throw New Exception(db.ErrDesc)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
        Public Function GetAccLink(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef findex As String(), ByRef fbuffer As String(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim AccNo As Long
            AccNo = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from AccLink Where AccNo=" & AccNo, adOpenForwardonly)
            findex = rs.fields_index()
            fbuffer = rs.GetRecord()

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function

    <WebMethod(EnableSession:=False)> _
    Public Function GetAdmLink(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef findex As String(), ByRef fbuffer As String(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim AdmNo As Long
            AdmNo = getInParamValue(InParam, 0)

            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select * from AdmLink Where AdmNo=" & AdmNo, adOpenForwardonly)
            findex = rs.fields_index()
            fbuffer = rs.GetRecord()

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SaveExchangeRate(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal findex() As String, ByVal fbuffer() As String, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim EditMode As Integer
            Dim Currency As String = getInParamValue(InParam, 0)
            Dim Effective As String = getInParamValue(InParam, 1)     ' Formatted Date MM/DD/YYYY
            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select Top 1 End_Date from Branch Where End_Date>='" & Effective & "'")
            If Not rs.Eof Then
                ErrMsg = "Branch's Posting Date Constraint On '" & todate(rs.fields("End_Date")) & "' !"
                Throw New Exception(ErrMsg)
            End If

            rs = db.OpenRemoteSet("Select * from Exchange where [Currency]='" & Currency & "' and Effective='" & Effective & "'")
            If rs.Eof Then
                rs.AddNew()
            Else
                rs.Edit()
            End If
            EditMode = rs.editmode

            Dim i As Integer
            Dim j As Integer
            i = 0
            j = UBound(findex)
            Do While i < j
                rs.fields(findex(i)) = GetFieldValue(fbuffer(i))
                i = i + 1
            Loop
            rs.fields("Last_Opr") = dbUser
            rs.fields("Last_Update") = Today.Date
            If Not rs.Update Then Throw New Exception(db.ErrDesc)
            If Not Update_Current_Exchange_Currency(Currency) Then
                Throw New Exception("Can't Update Current Exchange Rate !")
            End If

            ' Set Output Parameter

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function DropExchangeRate(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Currency As String = getInParamValue(InParam, 0)
            Dim Effective As String = getInParamValue(InParam, 1)     ' Formatted Date MM/DD/YYYY
            Dim rs As RemoteSet
            rs = db.OpenRemoteSet("Select Top 1 End_Date from Branch Where End_Date>='" & Effective & "'")
            If Not rs.Eof Then
                ErrMsg = "Branch's Posting Date Constraint On '" & todate(rs.fields("End_Date")) & "' !"
                Throw New Exception(ErrMsg)
            End If
            If db.Execute("delete from Exchange where [Currency]='" & Currency & "' and Effective='" & Effective & "'") Then
                If Not Save_Log_Object("Exchange", "Currency", Currency, "Effective", Effective, "", "", "", "", "", "", "", "Delete") Then Throw New Exception("Can't Save to Log !")
                If Not Update_Current_Exchange_Currency(Currency) Then
                    Throw New Exception("Can't Update Current Exchange Rate !")
                End If
            Else
                Throw New Exception(db.ErrDesc)
            End If

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    Private Function Update_Current_Exchange_Currency(ByVal Ccy As String) As Boolean
        Dim SQL As String
        On Error GoTo errmsg
        Dim rs As RemoteSet
        Dim rsCCY As RemoteSet
        rs = db.OpenRemoteSet("Select Top 1 * from Exchange Where Currency='" & Ccy & "' Order by Effective Desc")
        rsCCY = db.OpenRemoteSet("Select * from Currency Where Currency='" & Ccy & "'")
        rsCCY.Edit()
        rsCCY.fields("Effective") = todate(rs.fields("Effective"))
        rsCCY.fields("Rate") = toval(rs.fields("Rate"))
        rsCCY.fields("TRate") = toval(rs.fields("TRate"))
        rsCCY.fields("VRate") = toval(rs.fields("VRate"))
        rsCCY.fields("Rate_RC") = toval(rs.fields("Rate_RC"))
        rsCCY.fields("VRate_RC") = toval(rs.fields("VRate_RC"))
        rsCCY.fields("BIRate") = toval(rs.fields("BIRate"))
        rsCCY.fields("RRate") = toval(rs.fields("RRate"))
        rsCCY.fields("Last_Opr") = dbUser
        rsCCY.fields("Last_Update") = Today.Date
        If Not rsCCY.Update Then GoTo errmsg

        Update_Current_Exchange_Currency = True
        Exit Function
errmsg:
        Update_Current_Exchange_Currency = False
    End Function
    Private Function Tax_Rate(ByVal CCode As String, ByVal PDate As Object) As Double
        Dim rs As RemoteSet

        On Error GoTo errmsg
        rs = db.OpenRemoteSet("Select Currency from SysTab", adOpenForwardonly)
        If CCode.ToUpper <> tostr(rs.fields("Currency")).ToString.ToUpper And IsDate(PDate) Then
            rs = db.OpenRemoteSet("Select TRate from Currency Where Currency='" & CCode & "' and Effective<='" & Format(PDate, "MM/DD/YYYY") & "'")
            If Not rs.Eof Then
                Tax_Rate = rs.fields("TRate")
            Else
                rs = db.OpenRemoteSet("select Top 1 exchange.TRate from exchange where exchange.currency='" & CCode & "' and exchange.effective<='" & Format(PDate, "MM/DD/YYYY") & "' Order by exchange.effective desc", adOpenForwardonly)
                If Not rs.Eof Then
                    Tax_Rate = rs.fields("TRate")
                Else
                    Tax_Rate = 1
                End If
            End If
        Else
            Tax_Rate = 1
        End If
        rs.CloseRemoteSet()
        Exit Function
errmsg:
        StrMsg = StrError(StrMsg)
        Tax_Rate = 1
    End Function
    Private Function Get_Tax_Table(ByVal PID As String, ByVal PDate As Date, ByRef Amount As Double, ByRef Tax As Double) As Boolean
        Dim rs As RemoteSet
        Dim TaxRate As Double
        Dim Yr As Integer
        Dim Mth As Integer
        On Error GoTo errmsg
        Amount = 0
        Tax = 0
        Yr = Year(PDate)
        Mth = Month(PDate)
        rs = db.OpenRemoteSet("Select Currency, PNominal, Tax from TaxTable Where Year=" & Yr & " and Month=" & Mth & " and ID='" & PID & "'")
        Do While Not rs.Eof
            TaxRate = Tax_Rate(rs.fields("Currency"), PDate)
            Amount = Amount + TaxRate * toval(rs.fields("PNominal"))
            Tax = Tax + TaxRate * toval(rs.fields("Tax"))
            rs.MoveNext()
        Loop
        Get_Tax_Table = True
        Exit Function
errmsg:
        StrMsg = StrError(StrMsg)
        Get_Tax_Table = False
    End Function
    Private Function Update_Tax_Table(ByVal PID As String, ByVal PDate As Date, ByVal CCY As String, ByVal Amount As Double, ByVal Tax As Double) As Boolean
        Dim rs As RemoteSet
        Dim Yr As Integer
        Dim Mth As Integer
        On Error GoTo errmsg
        Yr = Year(PDate)
        Mth = Month(PDate)
        rs = db.OpenRemoteSet("Select * from TaxTable Where Year=" & Yr & " and Month=" & Mth & " and ID='" & PID & "' and Currency='" & CCY & "'")
        If rs.Eof Then
            rs.AddNew()
            rs.fields("Year") = Yr
            rs.fields("Month") = Mth
            rs.fields("ID") = PID
            rs.fields("Currency") = CCY
        Else
            rs.Edit()
        End If
        rs.fields("PNominal") = toval(rs.fields("PNominal")) + Amount
        rs.fields("Tax") = toval(rs.fields("Tax")) + Tax
        If Not rs.Update Then GoTo errmsg
        Update_Tax_Table = True
        Exit Function
errmsg:
        StrMsg = StrError(StrMsg)
        Update_Tax_Table = False
    End Function
    Private Function TrimBuffer(ByVal Bufferdata As Object, Optional ByVal CheckedColumn As Integer = 0) As Object
        Dim i As Integer
        Dim j As Integer
        Dim k As Integer
        Dim Rows As Integer
        Dim Cols As Integer
        Dim buffer As Object = Nothing
        If Not Bufferdata Is Nothing Then
            Rows = UBound(Bufferdata, 1) + 1
            Cols = UBound(Bufferdata, 2) + 1

            For i = Rows - 1 To 0 Step -1
                If Bufferdata(i, CheckedColumn) <> "" Then Exit For
            Next i
            ReDim buffer(i, Cols - 1)
            For j = 0 To i
                For k = 0 To Cols - 1
                    buffer(j, k) = Bufferdata(j, k)
                Next k
            Next j
        End If
        TrimBuffer = buffer
    End Function
    Private Function exchange_rate(ByVal CCode As String, ByVal PDate As Date, ByVal br_Currency As String) As Double
        Dim rs As RemoteSet

        On Error GoTo errmsg

        If CCode.ToUpper <> br_Currency.ToUpper And IsDate(PDate) Then
            rs = db.OpenRemoteSet("Select Rate from Currency Where Currency='" & CCode & "' and Effective<='" & Format(PDate, "MM/DD/YYYY") & "'")
            If Not rs.Eof Then
                exchange_rate = rs.fields("Rate")
            Else
                rs = db.OpenRemoteSet("select top 1 exchange.rate from exchange where exchange.currency='" & CCode & "' and exchange.effective<='" & Format(PDate, "MM/DD/YYYY") & "' Order by exchange.effective desc", adOpenForwardonly)
                If Not rs.Eof Then
                    exchange_rate = rs.fields("Rate")
                Else
                    exchange_rate = 1
                End If
            End If
            If exchange_rate <= 0 Then exchange_rate = 1
            rs.CloseRemoteSet()
        Else
            exchange_rate = 1
        End If
        Exit Function
errmsg:
        exchange_rate = 1
    End Function
    Private Function exchange_rate_RC(ByVal CCode As String, ByVal PDate As Date, ByVal br_Currency As String) As Double
        Dim rs As RemoteSet

        On Error GoTo errmsg

        If CCode.ToUpper <> br_Currency.ToUpper And IsDate(PDate) Then
            rs = db.OpenRemoteSet("Select Rate_RC from Currency Where Currency='" & CCode & "' and Effective<='" & Format(PDate, "MM/DD/YYYY") & "'")
            If Not rs.Eof Then
                exchange_rate_RC = rs.fields("Rate_RC")
            Else
                rs = db.OpenRemoteSet("select top 1 exchange.Rate_RC from exchange where exchange.currency='" & CCode & "' and exchange.effective<='" & Format(PDate, "MM/DD/YYYY") & "' Order by exchange.effective desc", adOpenForwardonly)
                If Not rs.Eof Then
                    exchange_rate_RC = rs.fields("Rate_RC")
                Else
                    exchange_rate_RC = 1
                End If
            End If
            If exchange_rate_RC <= 0 Then exchange_rate_RC = 1
            rs.CloseRemoteSet()
        Else
            exchange_rate_RC = 1
        End If
        Exit Function
errmsg:
        exchange_rate_RC = 1
    End Function
    Private Function Check_Backdated(ByVal Branch As String, ByVal PDate As Date) As Boolean
        Dim rs As RemoteSet
        Dim Br_End_Date As Date
        Dim Br_Month As Integer
        Dim br_Year As Integer
        On Error GoTo ErrMsg
        rs = db.OpenRemoteSet("Select End_Date, Month, Year from Branch Where Branch='" & Branch & "'")
        Br_End_Date = todate(rs.fields("End_Date"))
        Br_Month = toval(rs.fields("Month"))
        br_Year = toval(rs.fields("Year"))

        If (DateDiff(DateInterval.Day, PDate, Br_End_Date) = 0 And Br_Month = Month(PDate) And br_Year = Year(PDate)) Or (DateDiff(DateInterval.Day, PDate, Br_End_Date) > 0) Then
            Check_Backdated = True
            Exit Function
        End If

        Check_Backdated = False
        Exit Function
ErrMsg:
        Check_Backdated = True
    End Function
    Private Function GetUserBLLocked(ByVal ID As String) As Integer
        Dim rs As RemoteSet
        rs = db.OpenRemoteSet("Select BLLocked from SysUser Where ID='" & ID & "'")
        GetUserBLLocked = toval(rs.fields("BLLocked"))
    End Function
    Private Function GetLockedDate(ByVal Branch As String) As Date
        Dim LockedDate As Date
        Dim rs As RemoteSet
        rs = db.OpenRemoteSet("Select LockedDate from SysTab", adOpenForwardonly)
        LockedDate = todate(rs.fields("LockedDate"))
        rs = db.OpenRemoteSet("Select LockedDate from Branch Where Branch='" & Branch & "' and LockedDate>'" & Format(LockedDate, "MM/DD/YYYY") & "'")
        If Not rs.Eof Then
            LockedDate = todate(rs.fields("LockedDate"))
        End If
        GetLockedDate = LockedDate
    End Function
    Private Function GetFLockedDate(ByVal Branch As String) As Date
        Dim FLockedDate As Date
        Dim rs As RemoteSet
        rs = db.OpenRemoteSet("Select FLockedDate from SysTab", adOpenForwardonly)
        FLockedDate = todate(rs.fields("FLockedDate"))
        rs = db.OpenRemoteSet("Select FLockedDate from Branch Where Branch='" & Branch & "' and FLockedDate>'" & Format(FLockedDate, "MM/DD/YYYY") & "'")
        If Not rs.Eof Then
            FLockedDate = todate(rs.fields("FLockedDate"))
        End If
        GetFLockedDate = FLockedDate
    End Function
    Private Function GetApprovalLimitFA(ByVal UserID As String, ByVal VType As String, ByVal InOut As String, ByVal Amount As Double) As Boolean
        Dim rs As RemoteSet

        Dim UType As String
        Dim LimitIn As Double
        Dim LimitOut As Double

        On Error GoTo errmsg

        rs = db.OpenRemoteSet("select S1.Type, Case When S1.LimitIn<>0 then S1.LimitIn else S2.LimitIn end as LimitIn, Case When S1.LimitOut<>0 then S1.LimitOut else S2.LimitOut end as LimitOut from sysuser S1, SysUserType S2 where S2.Type=S1.Type and S1.ID='" & UserID & "'")
        If Not rs.Eof Then
            UType = rs.fields("Type")
            If UType = "SUPERVISOR" Then
                Return True
            Else
                LimitIn = toval(rs.fields("LimitIn"))
                LimitOut = toval(rs.fields("LimitOut"))

                If VType <> "" Then
                    rs = db.OpenRemoteSet("Select Top 1 LimitIn, LimitOut from SysUserVType Where ID='" & UserID & "' and VType='" & VType & "'")
                    If toval(rs.fields("LimitIn")) <> 0 Then LimitIn = toval(rs.fields("LimitIn"))
                    If toval(rs.fields("LimitOut")) <> 0 Then LimitOut = toval(rs.fields("LimitOut"))
                End If

                Select Case InOut
                    Case "In"
                        'If Amount <= LimitIn Or LimitIn = 0 Then Return True
                        If Amount <= LimitIn Then Return True
                    Case "Out", "Out_1"
                        'If Amount <= LimitOut Or LimitOut = 0 Then Return True
                        If Amount <= LimitOut Then Return True
                End Select
            End If
            ' Get User Delegation
            rs = db.OpenRemoteSet("Select top 1 ID from SysUserDelegation Where PID='" & UserID & "' and status='R' and cast(convert(varchar(10), getdate(),1) as smalldatetime) between effective and expiry")
            If Not rs.Eof AndAlso rs.fields("ID") <> dbUser Then
                Return GetApprovalLimitFA(rs.fields("ID"), VType, InOut, Amount)
            End If
            Return False
        Else
            Return False
        End If
        Exit Function
errmsg:
        Return False
    End Function

    Private Function exchange_rate(ByVal CCode As String, ByVal PDate As Object) As Double
        Dim rs As RemoteSet

        On Error GoTo ErrMsg

        If CCode <> "" Then
            rs = db.OpenRemoteSet("Select Currency from SysTab", adOpenForwardonly)
            If CCode.ToUpper <> tostr(rs.fields("Currency")).ToString.ToUpper And IsDate(PDate) Then
                rs = db.OpenRemoteSet("Select Rate from Currency Where Currency='" & CCode & "' and Effective<='" & Format(PDate, "MM/DD/YYYY") & "'")
                If Not rs.Eof Then
                    exchange_rate = rs.fields("Rate")
                Else
                    rs = db.OpenRemoteSet("select Top 1 exchange.rate from exchange where exchange.currency='" & CCode & "' and exchange.effective<='" & Format(PDate, "MM/DD/YYYY") & "' Order by exchange.effective desc", adOpenForwardonly)
                    If Not rs.Eof Then
                        exchange_rate = rs.fields("Rate")
                    Else
                        exchange_rate = 1
                    End If
                End If
                If exchange_rate <= 0 Then exchange_rate = 1
            Else
                exchange_rate = 1
            End If
            rs.CloseRemoteSet()
        Else
            exchange_rate = 1
        End If
        Exit Function
ErrMsg:
        exchange_rate = 1
    End Function
    Private Function Get_Exchange_Rate(ByVal PDate As Date, ByVal OCCY As String, ByVal CCY As String) As Double
        Dim Rate As Double

        If OCCY <> CCY Then
            Rate = exchange_rate(OCCY, PDate) / exchange_rate(CCY, PDate)
        Else
            Rate = 1
        End If
        Get_Exchange_Rate = Rate
    End Function
    Private Function Save_Log_Object(ByVal LogName As String, ByVal LogKeyID As String, ByVal LogID As String, ByVal LogKeyIDExt1 As String, ByVal LogIDExt1 As String, ByVal LogKeyIDExt2 As String, ByVal LogIDExt2 As String, ByVal LogKeyIDExt3 As String, ByVal LogIDExt3 As String, ByVal ColName As String, ByVal ColValueOld As String, ByVal ColValueNew As String, ByVal Action As String, Optional ByVal Remarks As String = "") As Boolean
        Dim rs As RemoteSet
        On Error GoTo ErrMessage
        If LogName <> "" And (ColValueOld <> ColValueNew Or Action <> "Update") Then
            rs = db.OpenRemoteSet("Select * from SysLogObject Where 1<>1")
            rs.AddNew()
            rs.fields("LogName") = LogName
            rs.fields("LogKeyID") = Trim(tostr(LogKeyID, 50))
            rs.fields("LogID") = Trim(tostr(LogID, 50))
            rs.fields("LogKeyIDext1") = Trim(tostr(LogKeyIDExt1, 50))
            rs.fields("LogIDExt1") = Trim(tostr(LogIDExt1, 50))
            rs.fields("LogKeyIDExt2") = Trim(tostr(LogKeyIDExt2, 50))
            rs.fields("LogIDExt2") = Trim(tostr(LogIDExt2, 50))
            rs.fields("LogKeyIDExt3") = Trim(tostr(LogKeyIDExt3, 50))
            rs.fields("LogIDExt3") = Trim(tostr(LogIDExt3, 50))
            rs.fields("Last_Opr") = dbUser
            rs.fields("Last_Update") = Today.Date
            rs.fields("Last_Time") = Time()
            rs.fields("ColName") = ColName
            rs.fields("ColValueOLD") = Trim(tostr(ColValueOld, 255))
            rs.fields("ColValueNew") = Trim(tostr(ColValueNew, 255))
            rs.fields("Action") = Action
            rs.fields("Remarks") = Remarks
            If Not rs.Update Then GoTo ErrMessage
        End If
        Save_Log_Object = True
        Exit Function
ErrMessage:
        Save_Log_Object = False
    End Function
    Private Function Get_Sub_Account(ByVal Parent As String) As String
        Dim rs As RemoteSet
        Dim Account As String
        Dim SubAccount As String

        Account = "'" & Parent & "'"

        rs = db.OpenRemoteSet("Select * from Account Where Parent='" & Parent & "'")
        Do While Not rs.Eof
            If toval(rs.fields("Post_Flag")) Then
                SubAccount = "'" & tostr(rs.fields("Account")) & "'"
            Else
                SubAccount = Get_Sub_Account(tostr(rs.fields("Account")))
            End If
            If Account = "" Then
                Account = SubAccount
            Else
                Account = Account & "," & SubAccount
            End If
            rs.MoveNext()
        Loop
        Get_Sub_Account = Account
    End Function
    Private Function Check_Voucher_Budget_Account(ByVal Voucher As String) As Boolean
        Dim rs As RemoteSet
        Dim BudgetCheckF As Boolean = True
        On Error GoTo errmsg

        rs = db.OpenRemoteSet("Select * from fn_SL_BudgetEntry('" & Voucher & "') Budget Where Budget<>0 and round(Budget,2)<round(Actual+Nominal,2)")
        BudgetCheckF = BudgetCheckF And rs.Eof
        Do While Not rs.Eof
            StrMsg = StrMsg & "Account : " & rs.fields("Account") & ", Branch : " & rs.fields("Branch") & ", CT : " & rs.fields("CT") & ", Budget Group : " & rs.fields("GID") & ", Budget : " & Format(rs.fields("Budget"), "###,##0.00") & ", Current : " & Format(rs.fields("Actual") + rs.fields("Nominal"), "###,##0.00") & vbCrLf
            rs.MoveNext()
        Loop

        If BudgetCheckF Then
            rs = db.OpenRemoteSet("Select * from fn_SL_CTBudget('" & Voucher & "') Budget Where Budget<>0 and round(Budget,2)<round(Actual+Nominal,2)")
            BudgetCheckF = BudgetCheckF And rs.Eof
            Do While Not rs.Eof
                StrMsg = StrMsg & "Account : " & rs.fields("Account") & ", Branch : " & rs.fields("Branch") & ", CT : " & rs.fields("CT") & ", Budget : " & Format(rs.fields("Budget"), "###,##0.00") & ", Current : " & Format(rs.fields("Actual") + rs.fields("Nominal"), "###,##0.00") & vbCrLf
                rs.MoveNext()
            Loop
        End If

        If BudgetCheckF Then
            rs = db.OpenRemoteSet("Select * from fn_SL_Budget('" & Voucher & "') Budget Where Budget<>0 and round(Budget,2)<round(Actual+Nominal,2)")
            BudgetCheckF = BudgetCheckF And rs.Eof
            Do While Not rs.Eof
                StrMsg = StrMsg & "Account : " & rs.fields("Account") & ", Branch : " & rs.fields("Branch") & ", Budget : " & Format(rs.fields("Budget"), "###,##0.00") & ", Current : " & Format(rs.fields("Actual") + rs.fields("Nominal"), "###,##0.00") & vbCrLf
                rs.MoveNext()
            Loop
        End If

        Check_Voucher_Budget_Account = BudgetCheckF
        Exit Function
errmsg:
        StrMsg = StrError(StrMsg)
        Check_Voucher_Budget_Account = False
    End Function
    Private Function Check_Request_Budget_Account(ByVal Request As String) As Boolean
        Dim rs As RemoteSet
        Dim BudgetCheckF As Boolean = True
        On Error GoTo errmsg

        rs = db.OpenRemoteSet("Select * from fn_SL_Request_BudgetEntry('" & Request & "') Budget Where Budget<>0 and round(Budget,2)<round(Actual+Nominal,2)")
        BudgetCheckF = BudgetCheckF And rs.Eof
        Do While Not rs.Eof
            StrMsg = StrMsg & "Account : " & rs.fields("Account") & ", Branch : " & rs.fields("Branch") & ", CT : " & rs.fields("CT") & ", Budget Group : " & rs.fields("GID") & ", Budget : " & Format(rs.fields("Budget"), "###,##0.00") & ", Current : " & Format(rs.fields("Actual") + rs.fields("Nominal"), "###,##0.00") & vbCrLf
            rs.MoveNext()
        Loop

        If BudgetCheckF Then
            rs = db.OpenRemoteSet("Select * from fn_SL_Request_CTBudget('" & Request & "') Budget Where Budget<>0 and round(Budget,2)<round(Actual+Nominal,2)")
            BudgetCheckF = BudgetCheckF And rs.Eof
            Do While Not rs.Eof
                StrMsg = StrMsg & "Account : " & rs.fields("Account") & ", Branch : " & rs.fields("Branch") & ", CT : " & rs.fields("CT") & ", Budget : " & Format(rs.fields("Budget"), "###,##0.00") & ", Current : " & Format(rs.fields("Actual") + rs.fields("Nominal"), "###,##0.00") & vbCrLf
                rs.MoveNext()
            Loop
        End If

        If BudgetCheckF Then
            rs = db.OpenRemoteSet("Select * from fn_SL_Request_Budget('" & Request & "') Budget Where Budget<>0 and round(Budget,2)<round(Actual+Nominal,2)")
            BudgetCheckF = BudgetCheckF And rs.Eof
            Do While Not rs.Eof
                StrMsg = StrMsg & "Account : " & rs.fields("Account") & ", Branch : " & rs.fields("Branch") & ", Budget : " & Format(rs.fields("Budget"), "###,##0.00") & ", Current : " & Format(rs.fields("Actual") + rs.fields("Nominal"), "###,##0.00") & vbCrLf
                rs.MoveNext()
            Loop
        End If

        Check_Request_Budget_Account = BudgetCheckF
        Exit Function
errmsg:
        StrMsg = StrError(StrMsg)
        Check_Request_Budget_Account = False
    End Function
    Private Function Update_Budget_Account_Actual(ByVal Voucher As String, ByVal Sign As Integer) As Boolean
        Dim rs As RemoteSet
        Dim rsBudget As RemoteSet
        Dim Nominal As Double
        Dim Yr As Integer
        Dim Mth As Integer
        Dim Branch As String
        Dim CT As String
        Dim GID As String
        Dim ID As String

        On Error GoTo errmessage
        rs = db.OpenRemoteSet("Select BudgetFeaturesF from SysTab")
        If Not rs.fields("BudgetFeaturesF") Then Return True

        rs = db.OpenRemoteSet("Select * from FL_SL_Budget_Account_Actual('" & Voucher & "')")
        Do While Not rs.Eof

            Yr = Year(rs.fields("Date"))
            Mth = Month(rs.fields("Date"))
            Branch = tostr(rs.fields("Branch"))
            CT = tostr(rs.fields("CT"))
            GID = tostr(rs.fields("GID"))
            ID = tostr(rs.fields("ID"))
            Nominal = toval(rs.fields("Nominal")) * Sign
            rsBudget = db.OpenRemoteSet("Select * from Budget_Entry Where Year=" & Yr & " and Branch='" & Branch & "' and CT='" & CT & "' and GID='" & GID & "' and ID='" & ID & "'")
            If rsBudget.Eof Then
                rsBudget.AddNew()
                rsBudget.fields("Year") = Yr
                rsBudget.fields("Branch") = Branch
                rsBudget.fields("CT") = CT
                rsBudget.fields("GID") = GID
                rsBudget.fields("ID") = ID
            Else
                rsBudget.Edit()
            End If
            rsBudget.fields("Actual_" & Mth) = toval(rsBudget.fields("Actual_" & Mth)) + Nominal
            rsBudget.fields("TotalActual") = toval(rsBudget.fields("TotalActual")) + Nominal
            If Not rsBudget.Update Then GoTo errmessage
            rs.MoveNext()
        Loop

        Update_Budget_Account_Actual = True
        Exit Function
errmessage:
        Update_Budget_Account_Actual = False
    End Function
    Private Function Check_Voucher_Company_Account(ByVal Voucher As String) As Boolean
        Dim rs As RemoteSet
        On Error GoTo errmsg

        rs = db.OpenRemoteSet("Select ComAcc, Balance from fn_SL_ComAcc('" & Voucher & "')")
        If toval(rs.fields("Balance")) < 0 Then
            StrMsg = StrMsg & "Account : " & rs.fields("ComAcc") & " Has Negative Balance : " & Format(rs.fields("Balance"), "###,##0.00") & vbCrLf
            GoTo errmsg
        End If
        Check_Voucher_Company_Account = True
        Exit Function
errmsg:
        StrMsg = StrError(StrMsg)
        Check_Voucher_Company_Account = False
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SubmitRequestForRequestApproval(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam() As Object, ByRef OutParam() As Object, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Request As String = getInParamValue(InParam, 0)

            Dim RequestName As String = ""
            Dim RequestMessage As String = "Request for Request Approval.."
            Dim ActionCode As String
            Dim ApprovedFName As String = ""
            Dim DueDate As Date = Today.Date

            Dim rs As RemoteSet
            Dim Branch As String
            Dim CT As String
            Dim VType As String
            Dim Amount As Double
            Dim InOut As String
            Dim Privileges As String
            Dim AUserID As String
            Dim AUserID_Ext As String

            rs = db.OpenRemoteSet("Select S.CT as UserCT, R.Request, R.Branch, R.VType, R.Nominal, R.Diff, R.DebtorF, R.Status, R.AUserID, R.AUserID_Ext from Request R Left Join SysUser S on (S.ID=R.UserID) Where R.Request='" & Request & "'")
            If rs.Eof Then
                Throw New Exception("No Request Data !")
            ElseIf rs.fields("Status") <> "R" And rs.fields("Status") <> "V" Then
                Throw New Exception("Please Check Request Status !")
            End If
            Branch = tostr(rs.fields("Branch"))
            CT = tostr(rs.fields("UserCT"))
            VType = tostr(rs.fields("VType"))
            Amount = toval(rs.fields("Nominal")) - toval(rs.fields("Diff"))
            InOut = IIf(rs.fields("DebtorF"), "In", "Out")
            Privileges = IIf(rs.fields("DebtorF"), "ALLOWRECEIPTREQUEST", "ALLOWPAYMENTREQUEST")
            AUserID = tostr(rs.fields("AUserID"))
            AUserID_Ext = tostr(rs.fields("AUserID_Ext"))

            If CBool(toval(GetAppSetting("NeedExtApprovalRequestF"))) Then
                If AUserID = AUserID_Ext Then
                    AUserID = ""
                End If
            Else
                AUserID = ""
            End If

            Dim SQL As String

            SQL = ""
            SQL = SQL & " Select A1.ActionCode, A1.ApprovedFName "
            SQL = SQL & " from ActionList A1"
            SQL = SQL & " Where A1.ActionGroup='RQ' and A1.ActionStartF=1 and A1.AllowedF=1 and A1.RCondition=3"
            SQL = SQL & " and exists "
            SQL = SQL & " ("
            SQL = SQL & " Select S2.Type, * "
            SQL = SQL & " from ActionUser S1, SysUser S2, SysUserBranch S4"
            SQL = SQL & " Where S1.ActionCode=A1.ActionCode and (S2.ID = S1.ActionUser Or S2.Type = S1.ActionUser) and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0"
            SQL = SQL & " and S4.ID=S2.ID and S4.RequestF=1 and S4.Branch='" & Branch & "'"
            SQL = SQL & " )"

            rs = db.OpenRemoteSet(SQL)
            If rs.Eof Then
                Throw New Exception("No Action List Available for Action Group : 'RQ', Action Task Condition : Check Request Approval !")
            End If

            ActionCode = tostr(rs.fields("ActionCode"))
            ApprovedFName = tostr(rs.fields("ApprovedFName"))

            Dim rsUser As RemoteSet
            SQL = ""
            SQL = SQL & "Select Top 1 S.*"
            SQL = SQL & " from"
            SQL = SQL & " ("
            SQL = SQL & " Select S2.ID, S2.Name, "
            SQL = SQL & " dbo.GetApprovalLimitFA(S2.ID, '" & VType & "', '" & InOut & "') as ApprovalLimit"
            SQL = SQL & " from ActionUser S1, SysUser S2, SysUserBranch S4"
            SQL = SQL & " Where S1.ActionCode='" & ActionCode & "' and (S2.ID=S1.ActionUser or S2.Type=S1.ActionUser) and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0"
            SQL = SQL & " and S4.ID=S2.ID and S4.RequestF=1 and S4.Branch='" & Branch & "'"
            SQL = SQL & " and (dbo.GetApprovalLimitFA(S2.ID, '" & VType & "', '" & InOut & "')>=" & tovalSF(Amount) & " or dbo.GetPrivileges(S2.ID,'" & Privileges & "')=1)"
            SQL = SQL & " and ('" & CT & "'='' or exists(Select CT from fn_UserCT(S2.ID,'" & Branch & "','') CT Where CT.CT='" & CT & "'))"
            SQL = SQL & " and (exists(Select VType from Fn_UserVType(S2.ID) VType Where VType.VType='" & VType & "'))"
            SQL = SQL & " ) S"
            SQL = SQL & " Where S.ID<>'" & AUserID & "'"
            SQL = SQL & " Order by S.ApprovalLimit"
            rsUser = db.OpenRemoteSet(SQL)
            If Not rsUser.Eof Then
                RequestName = rsUser.fields("ID")
            Else
                Throw New Exception("No Limit Authorization To Approve !")
            End If

            ReDim InParam(5)

            InParam(0) = Request
            InParam(1) = RequestName
            InParam(2) = RequestMessage
            InParam(3) = ActionCode
            InParam(4) = ApprovedFName
            InParam(5) = DueDate

            If Not SaveSMSRQ(dbUser, dbPassword, InParam, OutParam, ErrMsg) Then
                Throw New Exception(ErrMsg)
            End If

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SubmitRequestForVoucherApproval(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam() As Object, ByRef OutParam() As Object, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String = getInParamValue(InParam, 0)

            Dim RequestName As String = ""
            Dim RequestMessage As String = "Request for Voucher Approval.."
            Dim ActionCode As String
            Dim ApprovedFName As String = ""
            Dim DueDate As Date = Today.Date

            Dim rs As RemoteSet
            Dim Branch As String
            Dim CT As String
            Dim VType As String
            Dim Amount As Double
            Dim InOut As String
            Dim Privileges As String
            Dim AUserID As String
            Dim AUserID_Ext As String

            rs = db.OpenRemoteSet("Select S.CT as UserCT, V.Voucher, V.Branch, V.VType, V.Nominal, V.Diff, V.DebtorF, V.Status, V.AUserID, V.AUserID_Ext from pVoucher V Left Join SysUser S on (S.ID=V.UserID) Where V.SL_Cat='P' and V.Voucher='" & Voucher & "'")
            If rs.Eof Then
                Throw New Exception("No Voucher Data !")
            ElseIf rs.fields("Status") <> "N" Then
                Throw New Exception("Please Check Voucher Status !")
            End If
            Branch = tostr(rs.fields("Branch"))
            CT = tostr(rs.fields("UserCT"))
            VType = tostr(rs.fields("VType"))
            Amount = toval(rs.fields("Nominal")) - toval(rs.fields("Diff"))
            InOut = IIf(rs.fields("DebtorF"), "In", "Out")
            Privileges = IIf(rs.fields("DebtorF"), "ALLOWRECEIPT", "ALLOWPAYMENT")
            AUserID = tostr(rs.fields("AUserID"))
            AUserID_Ext = tostr(rs.fields("AUserID_Ext"))

            If CBool(toval(GetAppSetting("NeedExtApprovalVoucherF"))) Then
                If AUserID = AUserID_Ext Then
                    AUserID = ""
                End If
            Else
                AUserID = ""
            End If

            Dim SQL As String

            SQL = ""
            SQL = SQL & " Select A1.ActionCode, A1.ApprovedFName "
            SQL = SQL & " from ActionList A1"
            SQL = SQL & " Where A1.ActionGroup='FA' and A1.ActionStartF=1 and A1.AllowedF=1 and A1.RCondition=4"
            SQL = SQL & " and exists "
            SQL = SQL & " ("
            SQL = SQL & " Select S2.Type, * "
            SQL = SQL & " from ActionUser S1, SysUser S2, SysUserBranch S4"
            SQL = SQL & " Where S1.ActionCode=A1.ActionCode and (S2.ID = S1.ActionUser Or S2.Type = S1.ActionUser) and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0"
            SQL = SQL & " and S4.ID=S2.ID and S4.Branch='" & Branch & "'"
            SQL = SQL & " )"

            rs = db.OpenRemoteSet(SQL)
            If rs.Eof Then
                Throw New Exception("No Action List Available for Action Group : 'FA', Action Task Condition : Check Voucher Approval !")
            End If

            ActionCode = tostr(rs.fields("ActionCode"))
            ApprovedFName = tostr(rs.fields("ApprovedFName"))

            Dim rsUser As RemoteSet
            SQL = ""
            SQL = SQL & "Select Top 1 S.*"
            SQL = SQL & " from"
            SQL = SQL & " ("
            SQL = SQL & " Select S2.ID, S2.Name, "
            SQL = SQL & " dbo.GetApprovalLimitFA(S2.ID, '" & VType & "', '" & InOut & "') as ApprovalLimit"
            SQL = SQL & " from ActionUser S1, SysUser S2, SysUserBranch S4"
            SQL = SQL & " Where S1.ActionCode='" & ActionCode & "' and (S2.ID=S1.ActionUser or S2.Type=S1.ActionUser) and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0"
            SQL = SQL & " and S4.ID=S2.ID and S4.Branch='" & Branch & "'"
            SQL = SQL & " and (dbo.GetApprovalLimitFA(S2.ID, '" & VType & "', '" & InOut & "')>=" & tovalSF(Amount) & " or dbo.GetPrivileges(S2.ID,'" & Privileges & "')=1)"
            SQL = SQL & " and ('" & CT & "'='' or exists(Select CT from fn_UserCT(S2.ID,'" & Branch & "','') CT Where CT.CT='" & CT & "'))"
            SQL = SQL & " and (exists(Select VType from Fn_UserVType(S2.ID) VType Where VType.VType='" & VType & "'))"
            SQL = SQL & " ) S"
            SQL = SQL & " Where S.ID<>'" & AUserID & "'"
            SQL = SQL & " Order by S.ApprovalLimit"
            rsUser = db.OpenRemoteSet(SQL)
            If Not rsUser.Eof Then
                RequestName = rsUser.fields("ID")
            Else
                Throw New Exception("No Limit Authorization To Approve !")
            End If

            ReDim InParam(5)

            InParam(0) = Voucher
            InParam(1) = RequestName
            InParam(2) = RequestMessage
            InParam(3) = ActionCode
            InParam(4) = ApprovedFName
            InParam(5) = DueDate

            If Not SaveSMSFA(dbUser, dbPassword, InParam, OutParam, ErrMsg) Then
                Throw New Exception(ErrMsg)
            End If

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    Private Function SaveSMSFA(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Try
            ' Get Input Parameter
            Dim Voucher As String
            Dim RequestName As String
            Dim RequestMessage As String
            Dim ActionCode As String
            Dim ApprovedFName As String
            Dim DueDate As Date

            Voucher = getInParamValue(InParam, 0)
            RequestName = getInParamValue(InParam, 1)
            RequestMessage = getInParamValue(InParam, 2)
            ActionCode = getInParamValue(InParam, 3)
            ApprovedFName = getInParamValue(InParam, 4)
            DueDate = todate(getInParamValue(InParam, 5))

            Dim EmailF As Boolean = CBool(toval(GetAppSetting("EmailTaskF")))
            Dim EmailBody As String = ""

            Dim rs As RemoteSet

            rs = db.OpenRemoteSet("Select sum(Case When Param5<>UserID Then 1 else 0 end) as NumToOthers, sum(case When UserID<>'" & dbUser & "' and Param5=UserID then 1 else 0 end) as NumToMeOthers from SysRequest Where Param1='SEND' and Param2 in ('FA') and Param6='" & Voucher & "' and Status=''")
            If UCase(RequestName) = UCase(dbUser) Then
                If toval(rs.fields("NumToMeOthers")) <> 0 Then
                    Throw New Exception("Already in Message Request !")
                End If
            Else
                If toval(rs.fields("NumToOthers")) <> 0 Then
                    Throw New Exception("Already in Message Request !")
                End If
            End If

            rs = db.OpenRemoteSet("Select Voucher, Remarks, SL_Cat from Voucher Where Voucher='" & Voucher & "'")
            If Not rs.Eof Then
                Select Case rs.fields("SL_Cat")
                    Case "N"
                        If Not db.Execute("Update nVoucher Set RequestF=1, RequestMessage='" & RequestMessage & "',RequestName='" & RequestName & "' Where Voucher='" & Voucher & "'") Then
                            Throw New Exception(db.ErrDesc)
                        End If
                    Case "M", "X", "J"
                        If Not db.Execute("Update mVoucher Set RequestF=1, RequestMessage='" & RequestMessage & "',RequestName='" & RequestName & "' Where Voucher='" & Voucher & "'") Then
                            Throw New Exception(db.ErrDesc)
                        End If
                    Case Else
                        If Not db.Execute("Update pVoucher Set RequestF=1, RequestMessage='" & RequestMessage & "',RequestName='" & RequestName & "' Where Voucher='" & Voucher & "'") Then
                            Throw New Exception(db.ErrDesc)
                        End If
                End Select
                EmailBody = "Voucher No : " & rs.fields("Voucher") & " " & ", Remarks : " & rs.fields("Remarks")
            Else
                ErrMsg = "No Data Available !"
                Throw New Exception(ErrMsg)
            End If
            rs.CloseRemoteSet()
            If Not IPCRequest("CARE", RequestMessage, "SEND", "FA", 0, 0, RequestName, Voucher, dbUser, Today.Date, Time(), ActionCode, ApprovedFName, DueDate, -1, dbUser, ErrMsg, EmailF, EmailBody) Then Throw New Exception(ErrMsg)

            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
        Public Function SaveMessageFA(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            If Not SaveSMSFA(dbUser, dbPassword, InParam, OutParam, ErrMsg) Then
                Throw New Exception(ErrMsg)
            End If

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    Private Function SaveSMSRQ(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Try
            ' Get Input Parameter
            Dim Request As String
            Dim RequestName As String
            Dim RequestMessage As String
            Dim ActionCode As String
            Dim ApprovedFName As String
            Dim DueDate As Date

            Request = getInParamValue(InParam, 0)
            RequestName = getInParamValue(InParam, 1)
            RequestMessage = getInParamValue(InParam, 2)
            ActionCode = getInParamValue(InParam, 3)
            ApprovedFName = getInParamValue(InParam, 4)
            DueDate = todate(getInParamValue(InParam, 5))

            Dim EmailF As Boolean = CBool(toval(GetAppSetting("EmailTaskF")))
            Dim EmailBody As String = ""

            Dim rs As RemoteSet

            rs = db.OpenRemoteSet("Select sum(Case When Param5<>UserID Then 1 else 0 end) as NumToOthers, sum(case When UserID<>'" & dbUser & "' and Param5=UserID then 1 else 0 end) as NumToMeOthers from SysRequest Where Param1='SEND' and Param2 in ('RQ') and Param6='" & Request & "' and Status=''")
            If UCase(RequestName) = UCase(dbUser) Then
                If toval(rs.fields("NumToMeOthers")) <> 0 Then
                    Throw New Exception("Already in Message Request !")
                End If
            Else
                If toval(rs.fields("NumToOthers")) <> 0 Then
                    Throw New Exception("Already in Message Request !")
                End If
            End If

            rs = db.OpenRemoteSet("Select Request, Remarks from Request Where Request='" & Request & "'")
            If Not rs.Eof Then
                If Not db.Execute("Update Request Set RequestF=1, RequestMessage='" & RequestMessage & "',RequestName='" & RequestName & "' Where Request='" & Request & "'") Then
                    Throw New Exception(db.ErrDesc)
                End If
                EmailBody = "Request No : " & rs.fields("Request") & " " & ", Remarks : " & rs.fields("Remarks")
            Else
                ErrMsg = "No Data Available !"
                Throw New Exception(ErrMsg)
            End If

            rs.CloseRemoteSet()
            If Not IPCRequest("CARE", RequestMessage, "SEND", "RQ", 0, 0, RequestName, Request, dbUser, Today.Date, Time(), ActionCode, ApprovedFName, DueDate, -1, dbUser, ErrMsg, EmailF, EmailBody) Then Throw New Exception(ErrMsg)

            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
        Public Function SaveMessageRQ(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            If Not SaveSMSRQ(dbUser, dbPassword, InParam, OutParam, ErrMsg) Then
                Throw New Exception(ErrMsg)
            End If

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            db.RollBack()
            CloseConnection()
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
        Public Function SearchComAccBranch(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Branch As String = getInParamValue(InParam, 0)
            Dim Currency As String = getInParamValue(InParam, 1)
            Dim CommType As String = getInParamValue(InParam, 2) ' 0 : Bank, 1 : Cash, 2 : Non-Cash-Bank

            Dim SQL As String
            SQL = "Select cast(Case When C2.ComAcc is null then 0 else 1 end as bit) as ProcessFlag, C1.*"
            SQL = SQL & " from ComAcc C1 "
            SQL = SQL & " Left Join ComAcc_Branch C2 on (C2.ComAcc=C1.ComAcc and C2.Branch='" & Branch & "')"
            SQL = SQL & " Where C1.Currency='" & Currency & "'"

            Select Case CommType
                Case 0
                    SQL = SQL & " and C1.BankF=1"
                Case 1
                    SQL = SQL & " and C1.CashF=1"
                Case 2
                    SQL = SQL & " and C1.NonCBF=1"
            End Select

            Dim rs As RemoteSet
            Dim C_MaxRecords As Long
            C_MaxRecords = toval(GetAppSetting("CareMaxRecords"))
            If toval(GetAppSetting("CareMaxRecords_FA")) > C_MaxRecords Then
                C_MaxRecords = toval(GetAppSetting("CareMaxRecords_FA"))
            End If
            rs = db.OpenRemoteSet(SQL, , , , C_MaxRecords)
            Dataset = rs.GetDataSet

            If Dataset Is Nothing Then Throw New Exception(ErrMsg)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
            Public Function SearchComAccSegment(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Segment As String = getInParamValue(InParam, 0)
            Dim Currency As String = getInParamValue(InParam, 1)
            Dim CommType As String = getInParamValue(InParam, 2) ' 0 : Bank, 1 : Cash, 2 : Non-Cash-Bank

            Dim SQL As String
            SQL = "Select cast(Case When C2.ComAcc is null then 0 else 1 end as bit) as ProcessFlag, C1.*"
            SQL = SQL & " from ComAcc C1 "
            SQL = SQL & " Left Join ComAcc_Segment C2 on (C2.ComAcc=C1.ComAcc and C2.Segment='" & Segment & "')"
            SQL = SQL & " Where C1.Currency='" & Currency & "'"

            Select Case CommType
                Case 0
                    SQL = SQL & " and C1.BankF=1"
                Case 1
                    SQL = SQL & " and C1.CashF=1"
                Case 2
                    SQL = SQL & " and C1.NonCBF=1"
            End Select

            Dim rs As RemoteSet
            Dim C_MaxRecords As Long
            C_MaxRecords = toval(GetAppSetting("CareMaxRecords"))
            If toval(GetAppSetting("CareMaxRecords_FA")) > C_MaxRecords Then
                C_MaxRecords = toval(GetAppSetting("CareMaxRecords_FA"))
            End If
            rs = db.OpenRemoteSet(SQL, , , , C_MaxRecords)
            Dataset = rs.GetDataSet

            If Dataset Is Nothing Then Throw New Exception(ErrMsg)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
            Public Function SearchComAccPHolder(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim PHolder As String = getInParamValue(InParam, 0)
            Dim Currency As String = getInParamValue(InParam, 1)
            Dim CommType As String = getInParamValue(InParam, 2) ' 0 : Bank, 1 : Cash, 2 : Non-Cash-Bank

            Dim SQL As String
            SQL = "Select cast(Case When C2.ComAcc is null then 0 else 1 end as bit) as ProcessFlag, C1.*"
            SQL = SQL & " from ComAcc C1 "
            SQL = SQL & " Left Join Comacc_Pholder C2 on (C2.ComAcc=C1.ComAcc and C2.PHolder='" & PHolder & "')"
            SQL = SQL & " Where C1.Currency='" & Currency & "'"

            Select Case CommType
                Case 0
                    SQL = SQL & " and C1.BankF=1"
                Case 1
                    SQL = SQL & " and C1.CashF=1"
                Case 2
                    SQL = SQL & " and C1.NonCBF=1"
            End Select

            Dim rs As RemoteSet
            Dim C_MaxRecords As Long
            C_MaxRecords = toval(GetAppSetting("CareMaxRecords"))
            If toval(GetAppSetting("CareMaxRecords_FA")) > C_MaxRecords Then
                C_MaxRecords = toval(GetAppSetting("CareMaxRecords_FA"))
            End If
            rs = db.OpenRemoteSet(SQL, , , , C_MaxRecords)
            Dataset = rs.GetDataSet

            If Dataset Is Nothing Then Throw New Exception(ErrMsg)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function UpdateComAccBranch(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal DataSet As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Branch As String = getInParamValue(InParam, 0)
            Dim Total As Long = 0
            Dim rs As RemoteSet

            For i = 0 To DataSet.Tables(0).Rows.Count - 1
                rs = db.OpenRemoteSet("Select * from ComAcc_Branch Where ComAcc='" & DataSet.Tables(0).Rows(i)("ComAcc") & "' and Branch='" & Branch & "'")

                If DataSet.Tables(0).Rows(i)("ProcessFlag") = True Then
                    If rs.Eof Then
                        rs.AddNew()
                        rs.fields("ComAcc") = DataSet.Tables(0).Rows(i)("ComAcc")
                        rs.fields("Branch") = Branch
                        If Not rs.Update Then Throw New Exception(rs.ErrDesc)
                    End If
                    rs = db.OpenRemoteSet("Select * from ComAcc Where ComAcc='" & DataSet.Tables(0).Rows(i)("ComAcc") & "'")
                    rs.Edit()
                    rs.fields("InterF") = toval(DataSet.Tables(0).Rows(i)("InterF"))
                    rs.fields("TransferF") = toval(DataSet.Tables(0).Rows(i)("TransferF"))
                    rs.fields("DefaultF") = toval(DataSet.Tables(0).Rows(i)("DefaultF"))
                    If Not rs.Update Then Throw New Exception(rs.ErrDesc)
                    Total = Total + 1
                Else
                    If Not rs.Eof Then
                        rs.Delete()
                    End If
                End If
            Next

            ReDim OutParam(0)
            OutParam(0) = Total

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function UpdateComAccSegment(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal DataSet As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Segment As String = getInParamValue(InParam, 0)
            Dim Total As Long = 0
            Dim rs As RemoteSet

            For i = 0 To DataSet.Tables(0).Rows.Count - 1
                rs = db.OpenRemoteSet("Select * from ComAcc_Segment Where ComAcc='" & DataSet.Tables(0).Rows(i)("ComAcc") & "' and Segment='" & Segment & "'")

                If DataSet.Tables(0).Rows(i)("ProcessFlag") = True Then
                    If rs.Eof Then
                        rs.AddNew()
                        rs.fields("ComAcc") = DataSet.Tables(0).Rows(i)("ComAcc")
                        rs.fields("Segment") = Segment
                        If Not rs.Update Then Throw New Exception(rs.ErrDesc)
                    End If
                    rs = db.OpenRemoteSet("Select * from ComAcc Where ComAcc='" & DataSet.Tables(0).Rows(i)("ComAcc") & "'")
                    rs.Edit()
                    rs.fields("InterF") = toval(DataSet.Tables(0).Rows(i)("InterF"))
                    rs.fields("TransferF") = toval(DataSet.Tables(0).Rows(i)("TransferF"))
                    rs.fields("DefaultF") = toval(DataSet.Tables(0).Rows(i)("DefaultF"))
                    If Not rs.Update Then Throw New Exception(rs.ErrDesc)
                    Total = Total + 1
                Else
                    If Not rs.Eof Then
                        rs.Delete()
                    End If
                End If
            Next

            ReDim OutParam(0)
            OutParam(0) = Total

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function UpdateComAccPHolder(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal DataSet As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim PHolder As String = getInParamValue(InParam, 0)
            Dim Total As Long = 0
            Dim rs As RemoteSet

            For i = 0 To DataSet.Tables(0).Rows.Count - 1
                rs = db.OpenRemoteSet("Select * from ComAcc_PHolder Where ComAcc='" & DataSet.Tables(0).Rows(i)("ComAcc") & "' and PHolder='" & PHolder & "'")

                If DataSet.Tables(0).Rows(i)("ProcessFlag") = True Then
                    If rs.Eof Then
                        rs.AddNew()
                        rs.fields("ComAcc") = DataSet.Tables(0).Rows(i)("ComAcc")
                        rs.fields("PHolder") = PHolder
                        If Not rs.Update Then Throw New Exception(rs.ErrDesc)
                    End If
                    rs = db.OpenRemoteSet("Select * from ComAcc Where ComAcc='" & DataSet.Tables(0).Rows(i)("ComAcc") & "'")
                    rs.Edit()
                    rs.fields("InterF") = toval(DataSet.Tables(0).Rows(i)("InterF"))
                    rs.fields("TransferF") = toval(DataSet.Tables(0).Rows(i)("TransferF"))
                    rs.fields("DefaultF") = toval(DataSet.Tables(0).Rows(i)("DefaultF"))
                    If Not rs.Update Then Throw New Exception(rs.ErrDesc)
                    Total = Total + 1
                Else
                    If Not rs.Eof Then
                        rs.Delete()
                    End If
                End If
            Next

            ReDim OutParam(0)
            OutParam(0) = Total

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SearchTaxInvoiceFromExcel(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByVal dsExcel As DataSet, ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            Dim SQL As String
            SQL = "select cast(0 as bit) as ProcessFlag, '' as TaxType, "
            SQL = SQL & " '' as A_PolicyNo, '' as Subject, '' as Type, '' as Name, '' as Voucher, cast('1/1/1900' as Smalldatetime) as Date,'' as [DN/CN], cast('1/1/1900' as Smalldatetime) as [DN/CN Date], "
            SQL = SQL & " '' as DocNo, '' as RefNo, '' as Currency, cast(0 as Float) as Nominal, cast(0 as Float) as Tax, '' as TaxNo, cast('1/1/1900' as Smalldatetime) as TaxDate, cast('1/1/1900' as Smalldatetime) as TaxIssuedDate, cast(0 as Int) as NumAttachments"
            SQL = SQL & " Where 1<>1"

            Dim rs As RemoteSet

            Dim VATType As String = getInParamValue(InParam, 0)

            rs = db.OpenRemoteSet(SQL)
            Dataset = rs.GetDataSet
            Dataset.Tables(0).PrimaryKey = New DataColumn() {Dataset.Tables(0).Columns("Voucher"), Dataset.Tables(0).Columns("[DN/CN]")}

            Dim Voucher As String
            Dim DNCN As String
            Dim DocNo As String
            Dim RefNo As String
            Dim A_PolicyNo As String
            Dim TaxNo As String
            Dim TaxIssuedDate As Date
            Dim NewRow As DataRow

            For i = 0 To dsExcel.Tables(0).Rows.Count - 1


                SQL = ""
                Voucher = ""
                DNCN = ""
                DocNo = ""
                RefNo = ""
                A_PolicyNo = ""
                TaxNo = ""

                Try
                    Voucher = tostr(dsExcel.Tables(0).Rows(i)("Voucher"))
                Catch ex As Exception
                End Try

                Try
                    DNCN = tostr(dsExcel.Tables(0).Rows(i)("DNCN"))
                Catch ex As Exception
                End Try

                Try
                    DocNo = tostr(dsExcel.Tables(0).Rows(i)("DocNo"))
                Catch ex As Exception
                End Try

                Try
                    RefNo = tostr(dsExcel.Tables(0).Rows(i)("RefNo"))
                Catch ex As Exception
                End Try

                Try
                    A_PolicyNo = tostr(dsExcel.Tables(0).Rows(i)("PolicyNo"))
                Catch ex As Exception
                End Try

                Try
                    TaxNo = tostr(dsExcel.Tables(0).Rows(i)("TaxNo"))
                Catch ex As Exception
                End Try

                Try
                    TaxIssuedDate = todate(dsExcel.Tables(0).Rows(i)("TaxIssuedDate"))
                Catch ex As Exception
                End Try

                If Voucher <> "" AndAlso (DNCN <> "" Or DocNo <> "" Or RefNo <> "" Or A_PolicyNo <> "") Then
                    If VATType = 1 Then ' VAT OUT
                        SQL = "Select 'VAT-OUT' as TaxType, A.A_PolicyNo, A.Subject, A.Type, P.Name, V.Voucher, V.Date, V.Voucher as [DN/CN], V.Date as [DN/CN Date], V.Docno, V.RefNo, V.Currency, (V.Nominal_CC-V.Diff_CC) as Nominal, A.Amount_13 as TAX, V.TaxNo, V.Taxdate, V.TaxIssuedDate, (Select count(*) from VoucherPIC Where Voucher=V.Voucher) as NumAttachments"
                        SQL = SQL & " from Admlink A, nVoucher V, Profile P, TOC "
                        SQL = SQL & " where A.Voucher = V.Voucher and P.ID=A.ID and TOC.TOC=A.Code and (A.Amount_13<>0 or TOC.TAXINVOICEF=1)"
                        SQL = SQL & " and ((A.Subject='Premium' and A.Type in ('DI','IC','IR','IT','IX')) or (A.Subject='Claim' and A.Type in ('OP') and A.Amount_8<>0))"
                        If Voucher <> "" Then SQL = SQL & " And V.voucher Like '" & Voucher & "%'"
                        If DNCN <> "" Then SQL = SQL & " And V.voucher Like '" & DNCN & "%'"
                        If DocNo <> "" Then SQL = SQL & " And V.DocNo Like '" & DocNo & "%'"
                        If RefNo <> "" Then SQL = SQL & " And V.Refno Like '" & RefNo & "%'"
                        If A_PolicyNo <> "" Then SQL = SQL & " And A.A_PolicyNo Like '" & A_PolicyNo & "%'"
                        SQL = SQL & " Order by V.Date Asc"
                    Else
                        SQL = "Select 'VAT-IN' as TaxType, A.A_PolicyNo, A.Subject, A.Type, P.Name, pVoucher.Voucher, pVoucher.Date, V.Voucher as [DN/CN], V.Date as [DN/CN Date], V.Docno, V.RefNo, V.Currency, (V.Nominal_CC-V.Diff_CC) as Nominal, dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)*A.Amount_13/A.Amount as TAX, SL.TaxNo, SL.Taxdate, SL.TaxIssuedDate, (Select count(*) from VoucherPIC Where Voucher=pVoucher.Voucher) as NumAttachments"
                        SQL = SQL & " from Admlink A, nVoucher V, pSL SL, pVoucher, Profile P"
                        SQL = SQL & " where A.Voucher=V.Voucher and A.Amount_13<>0 and P.ID=A.ID and pVoucher.Voucher=SL.Voucher and V.Voucher=SL.Doc_No and SL.PaymentF=1 "
                        SQL = SQL & " and ((A.Subject='Premium' and A.Type in ('BB','BA','BC','BP','BD','BO','OP')) or (A.Subject='Premium' and A.Type in ('DC','XP','CP','QS','QP','S1','S2','S3','AF','FO')) or (A.Subject='Claim' and A.Type in ('DI','IC','IR','IT','IX')) or (A.Subject='Claim' and A.Type in ('OP') and A.Amount_9<>0) Or (A.Subject='Others' and A.Type like 'OT%'))"
                        If Voucher <> "" Then SQL = SQL & " And pVoucher.voucher Like '" & Voucher & "%'"
                        If DNCN <> "" Then SQL = SQL & " And V.voucher Like '" & DNCN & "%'"
                        If DocNo <> "" Then SQL = SQL & " And V.DocNo Like '" & DocNo & "%'"
                        If RefNo <> "" Then SQL = SQL & " And V.Refno Like '" & RefNo & "%'"
                        If A_PolicyNo <> "" Then SQL = SQL & " And A.A_PolicyNo Like '" & A_PolicyNo & "%'"
                        SQL = SQL & " Order by pVoucher.Date Asc"
                    End If
                End If

                If SQL <> "" Then
                    rs = db.OpenRemoteSet(SQL)
                    Do While Not rs.Eof
                        Try
                            NewRow = Dataset.Tables(0).NewRow
                            NewRow("ProcessFlag") = True
                            NewRow("TaxType") = tostr(rs.fields("TaxType"))
                            NewRow("A_PolicyNo") = tostr(rs.fields("A_PolicyNo"))
                            NewRow("Subject") = tostr(rs.fields("Subject"))
                            NewRow("Type") = tostr(rs.fields("Type"))
                            NewRow("Name") = tostr(rs.fields("Name"))
                            NewRow("Voucher") = tostr(rs.fields("Voucher"))
                            NewRow("Date") = todate(rs.fields("Date"))
                            NewRow("DN/CN") = tostr(rs.fields("DN/CN"))
                            NewRow("DN/CN Date") = todate(rs.fields("DN/CN Date"))
                            NewRow("DocNo") = tostr(rs.fields("DocNo"))
                            NewRow("RefNo") = tostr(rs.fields("RefNo"))
                            NewRow("Currency") = tostr(rs.fields("Currency"))
                            NewRow("Nominal") = toval(rs.fields("Nominal"))
                            NewRow("Tax") = toval(rs.fields("Tax"))
                            NewRow("TaxNo") = TaxNo
                            NewRow("TaxDate") = Today.Date
                            NewRow("TaxIssuedDate") = TaxIssuedDate
                            Dataset.Tables(0).Rows.Add(NewRow)
                        Catch ex As Exception

                        End Try
                        rs.MoveNext()
                    Loop
                End If
            Next
            If Dataset Is Nothing Then Throw New Exception(ErrMsg)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SearchTAXInvoice(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef Dataset As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            ' Get Input Parameter
            Dim VATType As String = getInParamValue(InParam, 0)
            Dim Voucher As String = getInParamValue(InParam, 1)
            Dim DNCN As String = getInParamValue(InParam, 2)
            Dim DocNo As String = getInParamValue(InParam, 3)
            Dim RefNo As String = getInParamValue(InParam, 4)
            Dim A_PolicyNo As String = getInParamValue(InParam, 5)
            Dim SDate As String = getInParamValue(InParam, 6)   ' Formatted Date MM/DD/YYYY
            Dim EDate As String = getInParamValue(InParam, 7)   ' Formatted Date MM/DD/YYYY
            Dim Status As String = getInParamValue(InParam, 8)
            Dim Subject As String = getInParamValue(InParam, 9)
            Dim TaxNo As String = getInParamValue(InParam, 10)
            Dim SQL As String

            If VATType = 1 Then ' VAT OUT
                SQL = "select Cast(0 as bit) as ProcessFlag, 'VAT-OUT' as TaxType, A.A_PolicyNo, A.Subject, A.Type, P.Name, V.Voucher, V.Date, V.Voucher as [DN/CN], V.Date as [DN/CN Date], V.Docno, V.RefNo, V.Currency, (V.Nominal_CC-V.Diff_CC) as Nominal, A.Amount_13 as TAX, V.TaxNo, V.Taxdate, V.TaxIssuedDate, (Select count(*) from VoucherPIC Where Voucher=V.Voucher) as NumAttachments"
                SQL = SQL & " from Admlink A, nVoucher V, Profile P, TOC "
                SQL = SQL & " where A.Voucher = V.Voucher and P.ID=A.ID and TOC.TOC=A.Code and (A.Amount_13<>0 or TOC.TAXINVOICEF=1)"
                SQL = SQL & " and ((A.Subject='Premium' and A.Type in ('DI','IC','IR','IT','IX')) or (A.Subject='Claim' and A.Type in ('OP') and A.Amount_8<>0))"
                If SDate <> "" And EDate <> "" Then
                    SQL = SQL & " and (V.Date between '" & SDate & "' and '" & EDate & "')"
                ElseIf SDate <> "" Then
                    SQL = SQL & " and (V.Date='" & SDate & "')"
                ElseIf EDate <> "" Then
                    SQL = SQL & " and (V.Date='" & EDate & "')"
                End If
                If Status = 1 Then
                    SQL = SQL & " And V.TaxNo<>''"
                ElseIf Status = 2 Then
                    SQL = SQL & " And V.TaxNo=''"
                End If
                If Voucher <> "" Then SQL = SQL & " And V.voucher Like '" & Voucher & "%'"
                If DNCN <> "" Then SQL = SQL & " And V.voucher Like '" & DNCN & "%'"
                If DocNo <> "" Then SQL = SQL & " And V.DocNo Like '" & DocNo & "%'"
                If RefNo <> "" Then SQL = SQL & " And V.Refno Like '" & RefNo & "%'"
                If A_PolicyNo <> "" Then SQL = SQL & " And A.A_PolicyNo Like '" & A_PolicyNo & "%'"
                If TaxNo <> "" Then SQL = SQL & " and V.TaxNo Like '" & TaxNo & "%'"
                Select Case Subject
                    Case "1"
                        SQL = SQL & " And A.Subject='Premium'"
                    Case "2"
                        SQL = SQL & " And A.Subject='Claim'"
                    Case "3"
                        SQL = SQL & " And A.Subject='Others'"
                End Select
                SQL = SQL & " Order by V.Date Asc"
            Else
                SQL = "select Cast(0 as bit) as ProcessFlag, 'VAT-IN' as TaxType, A.A_PolicyNo, A.Subject, A.Type, P.Name, pVoucher.Voucher, pVoucher.Date, V.Voucher as [DN/CN], V.Date as [DN/CN Date], V.Docno, V.RefNo, V.Currency, (V.Nominal_CC-V.Diff_CC) as Nominal, dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)*A.Amount_13/A.Amount as TAX, SL.TaxNo, SL.Taxdate, SL.TaxIssuedDate, (Select count(*) from VoucherPIC Where Voucher=pVoucher.Voucher) as NumAttachments"
                SQL = SQL & " from Admlink A, nVoucher V, pSL SL, pVoucher, Profile P"
                SQL = SQL & " where A.Voucher=V.Voucher and A.Amount_13<>0 and P.ID=A.ID and pVoucher.Voucher=SL.Voucher and V.Voucher=SL.Doc_No and SL.PaymentF=1 "
                SQL = SQL & " and ((A.Subject='Premium' and A.Type in ('BB','BA','BC','BP','BD','BO','OP')) or (A.Subject='Premium' and A.Type in ('DC','XP','CP','QS','QP','S1','S2','S3','AF','FO')) or (A.Subject='Claim' and A.Type in ('DI','IC','IR','IT','IX')) or (A.Subject='Claim' and A.Type in ('OP') and A.Amount_9<>0) Or (A.Subject='Others' and A.Type like 'OT%'))"
                If SDate <> "" And EDate <> "" Then
                    SQL = SQL & " and (pVoucher.Date between '" & SDate & "' and '" & EDate & "')"
                ElseIf SDate <> "" Then
                    SQL = SQL & " and (pVoucher.Date='" & SDate & "')"
                ElseIf EDate <> "" Then
                    SQL = SQL & " and (pVoucher.Date='" & EDate & "')"
                End If
                If Status = 1 Then
                    SQL = SQL & " And SL.TaxNo<>''"
                ElseIf Status = 2 Then
                    SQL = SQL & " And SL.TaxNo=''"
                End If
                If Voucher <> "" Then SQL = SQL & " And pVoucher.voucher Like '" & Voucher & "%'"
                If DNCN <> "" Then SQL = SQL & " And V.voucher Like '" & DNCN & "%'"
                If DocNo <> "" Then SQL = SQL & " And V.DocNo Like '" & DocNo & "%'"
                If RefNo <> "" Then SQL = SQL & " And V.Refno Like '" & RefNo & "%'"
                If A_PolicyNo <> "" Then SQL = SQL & " And A.A_PolicyNo Like '" & A_PolicyNo & "%'"
                If TaxNo <> "" Then SQL = SQL & " and SL.TaxNo Like '" & TaxNo & "%'"
                Select Case Subject
                    Case "1"
                        SQL = SQL & " And A.Subject='Premium'"
                    Case "2"
                        SQL = SQL & " And A.Subject='Claim'"
                    Case "3"
                        SQL = SQL & " And A.Subject='Others'"
                End Select
                SQL = SQL & " Order by pVoucher.Date Asc"
            End If

            Dim rs As RemoteSet
            Dim C_MaxRecords As Long
            C_MaxRecords = toval(GetAppSetting("CareMaxRecords"))
            If toval(GetAppSetting("CareMaxRecords_FA")) > C_MaxRecords Then
                C_MaxRecords = toval(GetAppSetting("CareMaxRecords_FA"))
            End If
            rs = db.OpenRemoteSet(SQL, , , , C_MaxRecords)
            Dataset = rs.GetDataSet

            If Dataset Is Nothing Then Throw New Exception(ErrMsg)
            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function UpdateTAXInvoice(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String = getInParamValue(InParam, 0)
            Dim DNCN As String = getInParamValue(InParam, 1)
            Dim TaxNo As String = getInParamValue(InParam, 2)
            Dim TaxIssuedDate As Date = getInParamValue(InParam, 3)
            Dim TaxDate As Date = getInParamValue(InParam, 4)

            Dim rs As RemoteSet

            rs = db.OpenRemoteSet("Select * from nVoucher Where Voucher='" & DNCN & "'")
            If rs.Eof Then
                Throw New Exception("DN/CN Voucher Not Found !")
            End If
            Dim Branch As String
            Dim br_end_date As Date
            Branch = rs.fields("Branch")


            rs = db.OpenRemoteSet("Select * from Branch where branch='" & Branch & "'")
            If Not rs.Eof Then
                br_end_date = todate(rs.fields("end_date"))
            End If

            Dim FLockedDate As Date
            If Not db.GetPrivileges("ALLOWLOCKEDPERIOD") Then
                FLockedDate = GetFLockedDate(Branch)
                If DateDiff(DateInterval.Day, FLockedDate, TaxDate) <= 0 Then
                    ErrMsg = "Transactions for this period have been closed, Check the Closing Date on " & FLockedDate
                    Throw New Exception(ErrMsg)
                End If
            End If

            If (DateDiff(DateInterval.Day, TaxDate, br_end_date) >= 0) Then
                ErrMsg = "Backdated Transaction, Check the Ending Date on " & br_end_date & " !"
                Throw New Exception(ErrMsg)
            End If

            If Not db.Execute("Update pSL Set TaxNo='" & TaxNo & "', TaxDate='" & Format(TaxDate, "MM/DD/YYYY") & "', TaxIssuedDate='" & Format(TaxIssuedDate, "MM/DD/YYYY") & "' Where Doc_No='" & DNCN & "' and Voucher='" & Voucher & "'") Then Throw New Exception(db.ErrDesc)


            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    Private Function Delete_WithholdingTax(ByVal Voucher As String) As Boolean
        On Error GoTo ErrMsg

        If Not db.Execute("Update Voucher Set Voucher.TaxPayment_CC=Voucher.TaxPayment_CC+SL.Nominal_OC from nVoucher Voucher, (Select Voucher.Voucher, sum(SL.TaxPayment_OC) as Nominal_OC from nVoucher Voucher, nSL SL Where Voucher.Voucher=SL.Doc_No and SL.PaymentF=1 and Voucher.CreditorF=1 and SL.Voucher='" & Voucher & "' Group by Voucher.Voucher) SL Where SL.Voucher=Voucher.Voucher") Then GoTo errmsg
        If Not db.Execute("Update Voucher Set Voucher.TaxPayment_CC=Voucher.TaxPayment_CC-SL.Nominal_OC from nVoucher Voucher, (Select Voucher.Voucher, sum(SL.TaxPayment_OC) as Nominal_OC from nVoucher Voucher, nSL SL Where Voucher.Voucher=SL.Doc_No and SL.PaymentF=1 and Voucher.DebtorF=1 and SL.Voucher='" & Voucher & "' Group by Voucher.Voucher) SL Where SL.Voucher=Voucher.Voucher") Then GoTo errmsg

        If Not db.Execute("Update T Set PNominal=PNominal-(-V.RefAmount), Tax=Tax-(V.Nominal_CC-V.Diff_CC) from nVoucher V, TaxTablePaid T Where T.Year=Year(V.Date) and T.Month=Month(V.Date) and T.ID=V.RefNo and V.RefAmount<>0 and V.Voucher='" & Voucher & "'") Then GoTo ErrMsg

        If Not db.Execute("Delete from nVoucher Where Voucher='" & Voucher & "' and Status='U' and Payment_CC=0 and Posting_Flag=0") Then GoTo ErrMsg
        If db.RecordsAffected = 0 Then GoTo ErrMsg

        ' Delete BPP Record
        'If Not db.Execute("Delete from BPP Where Voucher='" & Voucher & "'") Then GoTo ErrMsg
        Delete_WithholdingTax = True
        Exit Function
ErrMsg:
        StrMsg = StrError(StrMsg)
        Delete_WithholdingTax = False
    End Function
    Private Function Delete_WithholdingTaxByVoucherRef(ByVal VoucherRef As String) As Boolean
        Dim rs As RemoteSet
        On Error GoTo ErrMsg
        ' Get WithHolding Voucher
        rs = db.OpenRemoteSet("Select Distinct Voucher.Voucher, Voucher.RefNo, VType.TaxType, Voucher.Posting_Flag from nVoucher Voucher, VType Where VType.VType=Voucher.VType and VType.TaxF=1 and Voucher.DocNo='" & VoucherRef & "'", adOpenForwardonly)
        Do While Not rs.Eof
            If rs.fields("Posting_Flag") Then
                StrMsg = "WithHolding Tax Voucher : " & rs.fields("Voucher") & " Already Processed / Posted !"
                GoTo errmsg
            End If
            If Not Delete_WithholdingTax(rs.fields("Voucher")) Then GoTo ErrMsg
            rs.MoveNext()
        Loop
        Delete_WithholdingTaxByVoucherRef = True
        Exit Function
ErrMsg:
        StrMsg = StrError(StrMsg)
        Delete_WithholdingTaxByVoucherRef = False
    End Function
    Private Function Delete_WithholdingVAT(ByVal Voucher As String) As Boolean
        On Error GoTo ErrMsg

        If Not db.Execute("Update Voucher Set Voucher.VATPayment_CC=Voucher.VATPayment_CC+SL.Nominal_OC from nVoucher Voucher, (Select Voucher.Voucher, sum(SL.VATPayment_OC) as Nominal_OC from nVoucher Voucher, nSL SL Where Voucher.Voucher=SL.Doc_No and SL.PaymentF=1 and Voucher.CreditorF=1 and SL.Voucher='" & Voucher & "' Group by Voucher.Voucher) SL Where SL.Voucher=Voucher.Voucher") Then GoTo errmsg
        If Not db.Execute("Update Voucher Set Voucher.VATPayment_CC=Voucher.VATPayment_CC-SL.Nominal_OC from nVoucher Voucher, (Select Voucher.Voucher, sum(SL.VATPayment_OC) as Nominal_OC from nVoucher Voucher, nSL SL Where Voucher.Voucher=SL.Doc_No and SL.PaymentF=1 and Voucher.DebtorF=1 and SL.Voucher='" & Voucher & "' Group by Voucher.Voucher) SL Where SL.Voucher=Voucher.Voucher") Then GoTo errmsg

        If Not db.Execute("Delete from nVoucher Where Voucher='" & Voucher & "' and Status='U' and Payment_CC=0 and Posting_Flag=0") Then GoTo ErrMsg
        If db.RecordsAffected = 0 Then GoTo ErrMsg


        Delete_WithholdingVAT = True
        Exit Function
ErrMsg:
        StrMsg = StrError(StrMsg)
        Delete_WithholdingVAT = False
    End Function
    Private Function Delete_WithholdingVATByVoucherRef(ByVal VoucherRef As String) As Boolean
        Dim rs As RemoteSet
        On Error GoTo ErrMsg
        ' Get WithHolding Voucher
        rs = db.OpenRemoteSet("Select Distinct Voucher.Voucher, Voucher.RefNo, Voucher.Posting_Flag from nVoucher Voucher, VType Where VType.VType=Voucher.VType and VType.VatF=1 and Voucher.DocNo='" & VoucherRef & "'", adOpenForwardonly)
        Do While Not rs.Eof
            If rs.fields("Posting_Flag") Then
                StrMsg = "WithHolding VAT Voucher : " & rs.fields("Voucher") & " Already Processed / Posted !"
                GoTo errmsg
            End If
            If Not Delete_WithholdingVAT(rs.fields("Voucher")) Then GoTo ErrMsg
            rs.MoveNext()
        Loop
        Delete_WithholdingVATByVoucherRef = True
        Exit Function
ErrMsg:
        StrMsg = StrError(StrMsg)
        Delete_WithholdingVATByVoucherRef = False
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function CalculateTaxDeduction(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef OutParam As Object(), ByVal DataSet As DataSet, ByRef dsResult As DataSet, ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim pVoucher As String
            Dim PDate As Date
            Dim DebtorF As Boolean
            Dim CCY As String
            Dim RefCCYDate As Date
            pVoucher = tostr(getInParamValue(InParam, 0))
            PDate = todate(getInParamValue(InParam, 1))
            DebtorF = toval(getInParamValue(InParam, 2))
            CCY = tostr(getInParamValue(InParam, 3))
            RefCCYDate = todate(getInParamValue(InParam, 4))

            Dim i As Integer
            Dim rs As RemoteSet
            Dim DataRow As DataRow
            Dim TaxNominal As Double = 0
            Dim TaxNominal_BC As Double = 0
            Dim DS As DataSet = Nothing
            Dim AmountPaid_OC As Double = 0
            Dim SQL As String = ""
            Dim BookRate As Double

            Dim br_Currency As String
            rs = db.OpenRemoteSet("Select Currency from SysTab")
            br_Currency = rs.fields("Currency")

            rs = db.OpenRemoteSet("Select Rate from fn_exchange('" & Format(RefCCYDate, "MM/DD/YYYY") & "') Currency Where Currency='" & CCY & "'")
            BookRate = toval(rs.fields("Rate"))
            If BookRate = 0 Then BookRate = 1

            If Not db.Execute("Select cast('' as varchar(20)) Voucher, cast(0 as Float) as AmountPaid_OC, cast(0 as Float) as AmountPaid into #Admlink Where 1<>1") Then
                Throw New Exception(db.ErrDesc)
            End If

            rs = db.OpenRemoteSet("Select * from #Admlink")

            For i = 0 To DataSet.Tables(0).Rows.Count - 1
                DataRow = DataSet.Tables(0).Rows(i)
                If toval(DataRow("PaymentF")) Then
                    If DebtorF Then
                        AmountPaid_OC = -toval(DataRow("Nominal_OC"))
                    Else
                        AmountPaid_OC = toval(DataRow("Nominal_OC"))
                    End If
                    rs.AddNew()
                    rs.fields("AmountPaid_OC") = AmountPaid_OC
                    rs.fields("AmountPaid") = AmountPaid_OC * toval(DataRow("Nominator")) / toval(DataRow("Denominator")) * BookRate
                    rs.fields("Voucher") = DataRow("Doc_No")
                    If Not rs.UpdateRow Then Throw New Exception(rs.ErrDesc)
                End If
            Next

            If Not rs.Eof Then If Not rs.Update Then Throw New Exception(rs.ErrDesc)

            SQL = ""
            SQL = SQL & " Select Admlink.Branch, Admlink.Currency, Admlink.Voucher as Voucher, Max(MParam.TaxDiscount) as TaxDiscount, Max(nVoucher.TaxType) as TaxType, "
            SQL = SQL & " Max(Admlink.A_PolicyNo) as A_PolicyNo, Max(left(admlink.Remarks,50)) as Remarks, Max(Admlink.Type) as Type, Max(Admlink.ID) as ID, "
            SQL = SQL & " sum(Admlink.PNominal_Tax/(Case When nVoucher.DebtorF=1 Then (nVoucher.Nominal_CC-nVoucher.Diff_CC) else -(nVoucher.Nominal_CC-nVoucher.Diff_CC) End)*#Admlink.AmountPaid_OC) as Taxable_OC, "
            SQL = SQL & " sum(Admlink.PNominal_Tax/(Case When nVoucher.DebtorF=1 Then (nVoucher.Nominal_CC-nVoucher.Diff_CC) else -(nVoucher.Nominal_CC-nVoucher.Diff_CC) End)*nVoucher.Rate*#Admlink.AmountPaid_OC) as Taxable_BC, "
            SQL = SQL & " sum(Admlink.PNominal_Tax/(Case When nVoucher.DebtorF=1 Then (nVoucher.Nominal_CC-nVoucher.Diff_CC) else -(nVoucher.Nominal_CC-nVoucher.Diff_CC) End)*#Admlink.AmountPaid) as Taxable"
            SQL = SQL & " from MParam, Admlink, nVoucher, #Admlink"
            SQL = SQL & " Where MParam.Type=Admlink.Type and Admlink.Voucher=nVoucher.Voucher and Admlink.Amount_14=0 and nVoucher.TaxF=1 and nVoucher.Voucher=#Admlink.Voucher"
            SQL = SQL & " Group By Admlink.Branch, Admlink.Currency, Admlink.Voucher"

            If SQL <> "" Then
                Dim SSQLA As String = ""
                Dim SSQLB As String = ""

                SSQLA = "Select A.ID, Max(A.TaxDiscount) as TaxDiscount, sum(A.Taxable_BC) as Taxable_BC, sum(A.Taxable) as Taxable into #A"
                SSQLA = SSQLA & " from "
                SSQLA = SSQLA & " ("
                SSQLA = SSQLA & SQL
                SSQLA = SSQLA & " ) A"
                SSQLA = SSQLA & " Group By A.ID"
                If Not db.Execute(SSQLA) Then Throw New Exception(db.ErrDesc)

                SSQLB = "Select B.Branch, B.Currency, B.TaxType, B.ID, sum(B.Taxable_OC) as Taxable_OC, sum(B.Taxable_BC) as Taxable_BC, sum(B.Taxable) as Taxable into #B"
                SSQLB = SSQLB & " from "
                SSQLB = SSQLB & " ("
                SSQLB = SSQLB & SQL
                SSQLB = SSQLB & " ) B"
                SSQLB = SSQLB & " Group By B.Branch, B.Currency, B.TaxType, B.ID"
                If Not db.Execute(SSQLB) Then Throw New Exception(db.ErrDesc)

                SQL = "Select B.Branch, B.Currency, Profile.ID, Profile.Name, TaxType.TaxType, "
                SQL = SQL & " sum(cast(B.Taxable*(Case When TaxType.MTaxType='PASAL21' Then (100-A.TaxDiscount)/100 Else 1 End) as Decimal(16,4))) as Taxable, "
                SQL = SQL & " Max(cast(TaxType.TaxRate*(Case When Profile.TaxPCT=0 Then 1 Else Profile.TaxPCT/100 end) as Decimal(16,4))) as TaxRate, "
                SQL = SQL & " sum(cast(B.Taxable_OC*(Case When TaxType.MTaxType='PASAL21' Then (100-A.TaxDiscount)/100 Else 1 End)*TaxType.TaxRate/100*(Case When Profile.TaxPCT=0 Then 1 Else Profile.TaxPCT/100 end) as Decimal(16,4))) as TaxNominal_OC, "
                SQL = SQL & " sum(cast(B.Taxable_BC*(Case When TaxType.MTaxType='PASAL21' Then (100-A.TaxDiscount)/100 Else 1 End)*TaxType.TaxRate/100*(Case When Profile.TaxPCT=0 Then 1 Else Profile.TaxPCT/100 end) as Decimal(16,4))) as TaxNominal_BC, "
                SQL = SQL & " sum(cast(B.Taxable*(Case When TaxType.MTaxType='PASAL21' Then (100-A.TaxDiscount)/100 Else 1 End)*TaxType.TaxRate/100*(Case When Profile.TaxPCT=0 Then 1 Else Profile.TaxPCT/100 end) as Decimal(16,4))) as TaxNominal"
                SQL = SQL & " from #A A, #B B, TaxType, Profile"
                SQL = SQL & " Where Profile.ID=A.ID and B.ID=A.ID and TaxType.TaxType=dbo.Get_TaxType(Profile.TaxType,Profile.ID,'" & Format(PDate, "MM/DD/YYYY") & "','" & pVoucher & "',A.Taxable_BC, A.TaxDiscount) "
                SQL = SQL & " and not ('" & Format(PDate, "MM/DD/YYYY") & "' Between coalesce(Profile.TaxHSDate,'01/01/1900') and coalesce(Profile.TaxHEDate,'01/01/1900'))"
                SQL = SQL & " Group By B.Branch, B.Currency, Profile.ID, Profile.Name, TaxType.TaxType"
                SQL = SQL & " Having sum(cast(B.Taxable_BC*TaxType.TaxRate/100 as Decimal(16,4))) <>0"

                rs = db.OpenRemoteSet(SQL)
                dsResult = rs.GetDataSet

                For i = 0 To dsResult.Tables(0).Rows.Count - 1
                    DataRow = dsResult.Tables(0).Rows(i)
                    DataRow.BeginEdit()

                    If DebtorF Then
                        DataRow("Taxable") = DataRow("Taxable") / BookRate
                        DataRow("TaxNominal") = RoundCCY(DataRow("TaxNominal") / BookRate, UCase(CCY), toval(GetAppSetting("FARoundingDecimalValue")))
                        DataRow("TaxNominal_OC") = RoundCCY(DataRow("TaxNominal_OC"), UCase(DataRow("Currency")), toval(GetAppSetting("FARoundingDecimalValue")))
                        DataRow("TaxNominal_BC") = RoundCCY(DataRow("TaxNominal_BC"), br_Currency, toval(GetAppSetting("FARoundingDecimalValue")))
                    Else
                        DataRow("Taxable") = -DataRow("Taxable") / BookRate
                        DataRow("TaxNominal") = -RoundCCY(DataRow("TaxNominal") / BookRate, UCase(CCY), toval(GetAppSetting("FARoundingDecimalValue")))
                        DataRow("TaxNominal_OC") = -RoundCCY(DataRow("TaxNominal_OC"), UCase(DataRow("Currency")), toval(GetAppSetting("FARoundingDecimalValue")))
                        DataRow("TaxNominal_BC") = -RoundCCY(DataRow("TaxNominal_BC"), br_Currency, toval(GetAppSetting("FARoundingDecimalValue")))
                    End If
                    TaxNominal = TaxNominal + DataRow("TaxNominal")
                    TaxNominal_BC = TaxNominal_BC + DataRow("TaxNominal_BC")
                    DataRow.EndEdit()
                Next

                If Not db.Execute("Drop Table #A") Then
                    Throw New Exception(db.ErrDesc)
                End If

                If Not db.Execute("Drop Table #B") Then
                    Throw New Exception(db.ErrDesc)
                End If

            Else
                dsResult = Nothing
            End If

            If Not db.Execute("Drop Table #Admlink") Then
                Throw New Exception(db.ErrDesc)
            End If

            ' Set Output Parameter
            ReDim OutParam(1)
            OutParam(0) = TaxNominal
            OutParam(1) = TaxNominal_BC

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    Private Function PreSubmitAutoPrintConditionsOk(ByVal Voucher As String, ByRef ErrMsg As String) As Boolean
        Try
            Dim rsVoucher As RemoteSet

            Dim DocumentReprintF As Boolean = db.GetPrivileges("DOCUMENTREPRINT")
            Dim DocumentReprintORF As Boolean = db.GetPrivileges("DOCUMENTREPRINTOR")

            ErrMsg = ""
            rsVoucher = db.OpenRemoteSet("Select Voucher, DebtorF, SL_Cat from pVoucher Where Voucher in (" & Voucher & ")")
            Do While Not rsVoucher.Eof
                Dim rs As RemoteSet

                rs = db.OpenRemoteSet("Select Top 1 APPID from APDBucket Where Status='R' and AppType in ('RECEIPT','PAYMENT') and AppID='" & rsVoucher.fields("Voucher") & "'")
                If Not rs.Eof Then
                    ErrMsg = ErrMsg & "Voucher No : " & rsVoucher.fields("Voucher") & ", Already in Queue Print Bucket !"
                End If

                Dim SQL As String

                If toval(rsVoucher.fields("DebtorF")) And tostr(rsVoucher.fields("SL_Cat")) = "P" Then
                    SQL = "Select R.RuleID, R.NeedeStampDutyF, Profile.ID, Profile.Name, Profile.CorporateF, Profile.TaxID, Profile.TaxName, Profile_Ext.ID_No"
                    SQL = SQL & " from Get_RECEIPT_APRule('" & rsVoucher.fields("Voucher") & "','" & GetAppSetting("AutoPrintORSentTo") & "') R"
                    SQL = SQL & " Inner Join Profile on (Profile.ID=R.ID) "
                    SQL = SQL & " Left Join Profile_Ext on (Profile_Ext.ID=Profile.ID)"
                    rs = db.OpenRemoteSet(SQL)
                    If rs.Eof Then
                        ErrMsg = ErrMsg & "Voucher No : " & rsVoucher.fields("Voucher") & ", No Data Insert into Queue Print Bucket !" & vbCrLf
                    Else
                        Do While Not rs.Eof
                            If toval(rs.fields("NeedeStampDutyF")) Then
                                If toval(rs.fields("CorporateF")) Then
                                    If (rs.fields("TaxID") = "" OrElse rs.fields("TaxName") = "") Then
                                        ErrMsg = ErrMsg & "Voucher No : " & rsVoucher.fields("Voucher") & ", Please Check TaxID or TaxName for Profile ID : " & rs.fields("ID") & "-" & rs.fields("Name") & ", Required for e-Stamp !" & vbCrLf
                                    End If
                                Else
                                    If (rs.fields("ID_No") = "") Then
                                        ErrMsg = ErrMsg & "Voucher No : " & rsVoucher.fields("Voucher") & ", Please Check ID No for Profile ID : " & rs.fields("ID") & "-" & rs.fields("Name") & ", Required for e-Stamp !" & vbCrLf
                                    End If
                                End If
                            End If

                            rs.MoveNext()
                        Loop
                    End If

                    If Not DocumentReprintORF Then
                        rs = db.OpenRemoteSet("Select Top 1 Voucher from ORPrintLog Where Voucher='" & rsVoucher.fields("Voucher") & "'")
                        If Not rs.Eof Then
                            ErrMsg = ErrMsg & "Voucher No : " & rsVoucher.fields("Voucher") & ", Not Allowed for Document Reprinting" & vbCrLf
                        End If
                    End If
                Else
                    SQL = "Select R.RuleID "
                    SQL = SQL & " from Get_PAYMENT_APRule('" & rsVoucher.fields("Voucher") & "') R"
                    rs = db.OpenRemoteSet(SQL)
                    If rs.Eof Then
                        ErrMsg = ErrMsg & "Voucher No : " & rsVoucher.fields("Voucher") & ", No Data Insert into Queue Print Bucket !" & vbCrLf
                    End If

                    If Not DocumentReprintF Then
                        rs = db.OpenRemoteSet("Select Top 1 Voucher from VPrintLog Where Voucher='" & rsVoucher.fields("Voucher") & "'")
                        If Not rs.Eof Then
                            ErrMsg = ErrMsg & "Voucher No : " & rsVoucher.fields("Voucher") & ", Not Allowed for Document Reprinting" & vbCrLf
                        End If
                    End If
                End If
                rsVoucher.MoveNext()
            Loop

            If ErrMsg <> "" Then
                Throw New Exception(ErrMsg)
            End If

            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            Return False
        End Try
    End Function
    <WebMethod(EnableSession:=False)> _
    Public Function SubmitAutoPrint(ByVal dbUser As String, ByVal dbPassword As String, ByVal InParam As Object(), ByRef ErrMsg As String) As Boolean
        Try
            If Not OpenConnection(dbUser, dbPassword, ErrMsg) Then
                Return False
            End If

            db.Begintrans()

            ' Get Input Parameter
            Dim Voucher As String
            Dim rs As RemoteSet

            Voucher = getInParamValue(InParam, 0)
            Voucher = Replace(Voucher, "\", "")

            If Not PreSubmitAutoPrintConditionsOk(Voucher, ErrMsg) Then
                Throw New Exception(ErrMsg)
            End If

            rs = db.OpenRemoteSet("Select Voucher from pVoucher Where Voucher in (" & Voucher & ")")
            Do While Not rs.Eof

                If Not Insert_Receipt_Auto_Print(rs.fields("Voucher"), GetAppSetting("AutoPrintORSentTo")) Then
                    Throw New Exception("Can't insert into Auto Receipt Print !")
                End If

                If Not Insert_Payment_Auto_Print(rs.fields("Voucher")) Then
                    Throw New Exception("Can't insert into Auto Payment Print !")
                End If

                rs.MoveNext()
            Loop

            db.Committrans()
            CloseConnection()
            Return True
        Catch ex As Exception
            ErrMsg = db.ErrDesc
            db.RollBack()
            CloseConnection()
            If ErrMsg = "" Then ErrMsg = ex.Message
            Return False
        End Try
    End Function
    Private Function Delete_Auto_Receipt_Payment(ByVal Voucher As String) As Boolean
        On Error GoTo errmsg

        If Not db.Execute("Delete from RPBucket Where Voucher='" & Voucher & "' and Status='R'") Then GoTo errmsg

        Delete_Auto_Receipt_Payment = True
        Exit Function
errmsg:
        Delete_Auto_Receipt_Payment = False
        Exit Function
    End Function
    Private Function Insert_Auto_Receipt_Payment(ByVal Voucher As String, ByVal Account As String, ByVal NVoucher As String, ByVal Payment As Double, ByVal Payment_Date As Date, ByVal Rate As Double, ByVal NetPaidF As Boolean) As Boolean
        On Error GoTo errmsg
        Dim rs As RemoteSet
        rs = db.OpenRemoteSet("Select * from RPBucket Where Voucher='" & Voucher & "' and nVoucher='" & NVoucher & "' and Status='R'")
        If rs.Eof Then
            rs.AddNew()
        Else
            rs.Edit()
        End If
        rs.fields("Voucher") = Voucher
        rs.fields("Account") = Account
        rs.fields("NVoucher") = NVoucher
        rs.fields("Payment") = Payment
        rs.fields("Payment_Date") = Payment_Date
        rs.fields("Rate") = Rate
        rs.fields("NetPaidF") = NetPaidF
        rs.fields("Status") = "R"
        rs.fields("Last_Opr") = dbUser
        rs.fields("Last_Date") = Today.Date
        If Not rs.Update Then GoTo errmsg

        Insert_Auto_Receipt_Payment = True
        Exit Function
errmsg:
        Insert_Auto_Receipt_Payment = False
        Exit Function
    End Function
    Private Function GetPickUpList(ByVal Param2 As String, ByVal Param3 As Long, ByVal UserID As String) As String
        Dim FName As String = ""
        Try
            If Param2 <> "" Then
                Dim rs As RemoteSet
                Dim ASource As String
                Dim Status As String
                Dim AType As String
                Dim Role As String
                rs = db.OpenRemoteSet("Select Role from SysUser Where ID = '" & UserID & "'")
                Role = tostr(rs.fields("Role"))
                Select Case Param2
                    Case "UND", "UND-MW", "IT", "MAR"
                        rs = db.OpenRemoteSet("Select Cover.ASource, Acceptance.AStatus, Acceptance.AType from Acceptance, Cover Where Acceptance.CNO=Cover.CNO and Acceptance.ANO=" & Param3)
                        ASource = rs.fields("ASource")
                        Status = rs.fields("AStatus")
                        AType = rs.fields("AType")

                        If Param2 <> "IT" Then
                            Select Case Role
                                Case "ASSESSOR", "SURVEYOR"
                                    FName = GetAppSetting("CareListPolicy")
                                Case "COMMON", "OPERATION", "MARKETING OFFICER"
                                    If ASource = "MKT" And AType = "N" Then
                                        FName = GetAppSetting("CareListQuotation")
                                    Else
                                        FName = GetAppSetting("CareListPolicy")
                                    End If
                                Case "UNDERWRITER"
                                    FName = GetAppSetting("CareListPolicy")
                                Case Else
                                    If ASource = "MKT" And AType = "N" Then
                                        FName = GetAppSetting("CareListQuotation")
                                    Else
                                        FName = GetAppSetting("CareListPolicy")
                                    End If
                            End Select
                        Else
                            FName = GetAppSetting("CareListIT")
                        End If
                    Case "SVC"
                        rs = db.OpenRemoteSet("Select Service.ASource, Service.SStatus from Service Where Service.SNO=" & Param3)
                        ASource = rs.fields("ASource")
                        Status = rs.fields("SStatus")

                        If Status = "R" Then
                            FName = GetAppSetting("CareListServicing")
                        ElseIf UCase(ASource) = "CLM" Then
                            FName = GetAppSetting("CareListClaim2")
                        Else
                            Select Case Role
                                Case "ASSESSOR", "SURVEYOR"
                                    FName = GetAppSetting("CareListClaim2")
                                Case "MARKETING OFFICER"
                                    If ASource = "MKT" Then
                                        FName = GetAppSetting("CareListQuotation2")
                                    Else
                                        FName = GetAppSetting("CareListPolicy2")
                                    End If
                                Case "COMMON", "UNDERWRITER", "OPERATION"
                                    FName = GetAppSetting("CareListPolicy2")
                                Case Else
                                    If ASource = "MKT" Then
                                        FName = GetAppSetting("CareListQuotation2")
                                    Else
                                        FName = GetAppSetting("CareListPolicy2")
                                    End If
                            End Select
                        End If
                    Case "CLM", "CLM-MW"
                        Select Case Role
                            Case "ASSESSOR", "SURVEYOR", "COMMON", "OPERATION"
                                FName = GetAppSetting("CareListClaim")
                            Case "MARKETING OFFICER", "UNDERWRITER"
                                FName = GetAppSetting("CareListPolicy")
                            Case Else
                                FName = GetAppSetting("CareListClaim")
                        End Select
                    Case "CSCLM"
                        FName = GetAppSetting("CareListCSClaim")
                    Case "FA"
                        FName = GetAppSetting("CareListVoucher")
                    Case "RQ"
                        FName = GetAppSetting("CareListRequest")
                    Case "POLH"
                        FName = GetAppSetting("CHISSListPolicy")
                    Case "CLMH"
                        FName = GetAppSetting("CHISSListClaim")
                    Case "GLH"
                        FName = GetAppSetting("CHISSListGL")
                End Select
                rs.CloseRemoteSet()
            End If
        Catch ex As Exception
            FName = ""
        End Try
        Return FName
    End Function
    Private Function IPCRequest(ByVal ProcName As String, ByVal Remarks As String, ByVal Param1 As String, ByVal Param2 As String, ByVal Param3 As Long, ByVal Param4 As Long, ByVal Param5 As String, ByVal Param6 As String, ByVal UserID As String, ByVal UserDate As Date, ByVal UserTime As String, ByVal ActionCode As String, ByVal ApprovedFName As String, ByVal DueDate As Date, ByVal PID As Long, ByVal RequestingUser As String, ByRef Errmsg As String, ByVal EmailF As Boolean, ByVal EmailSubject As String) As Boolean
        IPCRequest = db.Execute("Insert into SysRequest (ProcName, Remarks, Param1, Param2, Param3, Param4, Param5, Param6, UserID, UserDate, UserTime,ActionCode,ApprovedFName, DueDate, PID, RequestingUser, Status) Values ('" & ProcName & "','" & Remarks & "','" & Param1 & "','" & Param2 & "'," & Param3 & "," & Param4 & ",'" & Param5 & "','" & Param6 & "','" & UserID & "','" & Format(UserDate, "MM/DD/YYYY") & "','" & UserTime & "','" & ActionCode & "','" & ApprovedFName & "','" & Format(DueDate, "MM/DD/YYYY") & "'," & PID & ",'" & RequestingUser & "','')")
        Errmsg = db.ErrDesc
        If Errmsg = "" AndAlso Param5 <> "" Then
            If EmailF Then
                Try
                    Dim rs As RemoteSet
                    If ActionCode <> "" Then
                        rs = db.OpenRemoteSet("Select A1.ActionName from ActionList A1 Where A1.ActionCode='" & ActionCode & "'")
                        EmailF = EmailF OrElse toval(rs.fields("EmailF"))
                        EmailSubject = tostr(rs.fields("ActionName")) & "-" & EmailSubject
                    End If

                    rs = db.OpenRemoteSet("Select TOP 1 ID from SysRequest Where ProcName='" & ProcName & "' and Param1='" & Param1 & "' and Param2='" & Param2 & "' and Param3=" & Param3 & " and Param4=" & Param4 & " and Param5='" & Param5 & "' and Param6='" & Param6 & "' and UserID='" & UserID & "' and UserDate='" & Format(UserDate, "MM/DD/YYYY") & "' and UserTime='" & UserTime & "' and PID=" & PID & "")

                    EmailSubject = "Pending Task : " & EmailSubject
                    Dim EmailFrom As String = UserID
                    Dim EmailTo As String = Param5
                    Dim EmailBody As String = EmailSubject & vbCrLf & Remarks

                    Dim FName As String = GetPickUpList(Param2, Param3, Param5)
                    If FName <> "" Then
                        FName = FName & "&Mode=PickUp&Param=" & tostr(rs.fields("ID"))
                        EmailBody = EmailBody & vbCrLf & vbCrLf & "Follow This URL : " & FName
                    End If
                    SendMail(EmailFrom, EmailTo, EmailSubject, EmailBody, Errmsg)

                Catch ex As Exception

                End Try
            End If
        End If

    End Function
    Private Function SendMail(ByVal UserFrom As String, ByVal UserTo As String, ByVal EMailSubject As String, ByVal EMailBody As String, ByRef ErrMsg As String) As Boolean
        Try
            Dim rs As RemoteSet
            Dim SMTPServer As String = ""
            Dim SMTPPort As Integer = 0
            Dim SMTPEmail As String = ""
            Dim EmailFrom As String = ""
            Dim EmailTo As String = ""

            rs = db.OpenRemoteSet("Select SMTPServer, SMTPPort, SMTPEmail from SysTab")
            SMTPServer = rs.fields("SMTPServer")
            SMTPPort = toval(rs.fields("SMTPPort"))
            SMTPEmail = rs.fields("SMTPEmail")


            If SMTPEmail <> "" Then
                rs = db.OpenRemoteSet("Select EMail from SysUser Where ID='" & UserFrom & "'")
                EmailFrom = rs.fields("EMail")
            End If
            If EmailFrom = "" Then EmailFrom = SMTPEmail

            Dim msgMail As New System.Net.Mail.MailMessage()
            Dim smtSender As SmtpClient = New SmtpClient()

            If (SMTPServer = "" AndAlso smtSender.Host = "") Or (SMTPPort = 0 AndAlso toval(smtSender.Port) = 0) Or (EmailFrom = "" AndAlso IsNothing(msgMail.From)) Then
                Throw New Exception("Please Check SMTP Configuration in Parameter/Application Configuration Setting !")
            End If

            If EmailFrom <> "" AndAlso IsNothing(msgMail.From) Then
                msgMail.From = New System.Net.Mail.MailAddress(EmailFrom)
            Else
                If Not IsNothing(msgMail.From) Then
                    EmailFrom = msgMail.From.Address
                End If
            End If

            With smtSender
                .DeliveryMethod = SmtpDeliveryMethod.Network
                If .Host = "" Then
                    .Host = SMTPServer
                End If
                If .Port = 0 Then
                    .Port = SMTPPort
                End If
                If .EnableSsl = False AndAlso CBool(toval(GetAppSetting("SMTPEnableSSL"))) Then
                    .EnableSsl = CBool(toval(GetAppSetting("SMTPEnableSSL")))
                End If

                If .EnableSsl And GetAppSetting("EmailSecurityProtocolType") <> "" Then
                    ServicePointManager.Expect100Continue = True
                    ServicePointManager.DefaultConnectionLimit = 9999
                    ServicePointManager.SecurityProtocol = toval(GetAppSetting("EmailSecurityProtocolType"))
                End If
            End With

            If smtSender.Host <> "" AndAlso EmailFrom <> "" Then

                rs = db.OpenRemoteSet("Select S.Email from SysUser S Where (ID='" & UserTo & "' or Exists (Select Type from SysuserType ST WHere ST.Type=S.Type and ST.Type='" & UserTo & "')) and LockedF=0 and AllowedF=1 and coalesce(Email,'')<>''")
                Do While Not rs.Eof
                    If rs.fields("EMail") <> "" AndAlso ValidateEmail(rs.fields("EMail")) Then
                        EmailTo = rs.fields("EMail")
                        msgMail.To.Add(New System.Net.Mail.MailAddress(EmailTo))
                    End If
                    rs.MoveNext()
                Loop

                If EmailTo <> "" Then
                    msgMail.Subject = EMailSubject
                    msgMail.IsBodyHtml = True
                    msgMail.BodyEncoding = UTF8Encoding.UTF8
                    Try
                        msgMail.Body = EMailBody
                        smtSender.Send(msgMail)
                    Catch ex As Exception
                        ErrMsg = ex.Message
                        Return False
                    End Try
                End If
            End If
            msgMail.Dispose()
            Return True
        Catch ex As Exception
            ErrMsg = ex.Message
            Return False
        End Try
    End Function
    Private Function StrError(Optional ByVal errmsg As String = "") As String
        Dim str As String
        Dim ErrDesc As String
        ErrDesc = Err.Description
        On Error GoTo errmsg
        str = errmsg
        If str = "" Then str = ErrDesc
        If str = "" Then str = db.ErrDesc
        StrError = str
        Exit Function
errmsg:
        StrError = "Connection is Broken !"
    End Function

    Public Function CheckPaymentMandatoryDocument(ByVal Request As String) As Boolean
        Dim rs As RemoteSet

        rs = db.OpenRemoteSet("Select DocType from DocType Where AllowedF=1 and Purpose='PAYMENT' and MandatoryF=1 and DocType not in (Select DocType from RDocList Where AvailableF=1 and Request='" & Request & "')")
        CheckPaymentMandatoryDocument = (rs.Eof)
    End Function
    Public Function CheckReceiptMandatoryDocument(ByVal Request As String) As Boolean
        Dim rs As RemoteSet

        rs = db.OpenRemoteSet("Select DocType from DocType Where AllowedF=1 and Purpose='RECEIPT' and MandatoryF=1 and DocType not in (Select DocType from RDocList Where AvailableF=1 and Request='" & Request & "')")
        CheckReceiptMandatoryDocument = (rs.Eof)
    End Function
    Private Function Insert_Event_Notification(ByVal APPID As String, ByVal APPTYPE As String, ByVal Category As String, ByVal ERule As String) As Boolean
        On Error GoTo ErrMsg
        Dim rs As RemoteSet
        rs = db.OpenRemoteSet("Select * from AEBucket Where APPID='" & APPID & "' and APPTYPE='" & APPTYPE & "' and Category='" & Category & "' and ERule='" & ERule & "' and Status='R'")
        If rs.Eof Then
            rs.AddNew()
            rs.fields("AppID") = APPID
            rs.fields("AppType") = APPTYPE
            rs.fields("Category") = Category
            rs.fields("ERule") = ERule
            rs.fields("Last_Opr") = dbUser
            rs.fields("Last_Update") = Today.Date
            rs.fields("Status") = "R"
            If Not rs.Update Then GoTo ErrMsg
        End If

        Insert_Event_Notification = True
        Exit Function
ErrMsg:
        Insert_Event_Notification = False
        Exit Function
    End Function
    Private Function SendPaymentNotification(ByVal Voucher As String, ByVal PaymentType As String) As Boolean
        SendPaymentNotification = Insert_Event_Notification(Voucher, "PAYMENT", "FA", PaymentType)        
    End Function
    'Private Function SendPaymentNotification(ByVal Voucher As String, ByVal PaymentType As String) As Boolean
    '    Dim rs As RemoteSet

    '    Dim CompanyName As String
    '    Dim CompanyPhone As String
    '    rs = db.OpenRemoteSet("Select Company, CompanyPhone, CompanyFax from SysTab")
    '    CompanyName = tostr(rs.fields("Company"))
    '    CompanyPhone = tostr(rs.fields("CompanyPhone"))

    '    Dim SQL As String

    '    Try
    '        SQL = "Select Policy_Member.Email, Policy_Member.Email_2, Policy_Member.Name, Policy.PolicyNo, ClaimH.ClaimNo, ClaimH.Start, ClaimH.Finish, ClaimH.Billed, ClaimH.Accepted, ClaimH.AccountNo, ClaimH.BankName, ClaimH.BankAccount, dbo.fn_CHISS_ClaimDetail_Reason(ClaimH.CNO) as Reason, Claim.Date, Claim.Currency, Claim.Amount"
    '        SQL = SQL & " from"
    '        SQL = SQL & " ("
    '        SQL = SQL & " Select pVoucher.Date, ClaimH.OCNO, Max(ClaimH.CNO) as CNO, Admlink.Currency, sum(-ClaimLedger.Amount) as Amount"
    '        SQL = SQL & " from ClaimLedger, ClaimH, Admlink, oSL('" & Voucher & "') pSL, pVoucher"
    '        SQL = SQL & " Where Admlink.AdmNo = ClaimLedger.AdmNo"
    '        SQL = SQL & " and ClaimH.CNO=ClaimLedger.CNO"
    '        SQL = SQL & " and ClaimH.Reimburse=1 "
    '        SQL = SQL & " and Admlink.Type='DI'"
    '        SQL = SQL & " and pSL.Doc_No=Admlink.Voucher and pSL.PaymentF=1"
    '        SQL = SQL & " and pVoucher.Voucher=pSL.Voucher"
    '        SQL = SQL & " and pVoucher.RefType='TRANSFER' and pVoucher.Voucher='" & Voucher & "'"
    '        SQL = SQL & " Group By pVoucher.Date, ClaimH.OCNO, Admlink.Currency"
    '        SQL = SQL & " having sum(ClaimLedger.Amount)<>0"
    '        SQL = SQL & " ) Claim, ClaimH, Policy_Member, Policy"
    '        SQL = SQL & " Where ClaimH.CNO = Claim.CNO And Policy_Member.MNO = ClaimH.MNO And Policy.PNO = Policy_Member.PNO"
    '        SQL = SQL & " and (ClaimH.AccountNo<>'' or ClaimH.BankAccount<>'')"
    '        rs = db.OpenRemoteSet(SQL)
    '    Catch ex As Exception
    '        rs = Nothing
    '    End Try
    '    If Not rs Is Nothing AndAlso Not rs.Eof Then
    '        Do While Not rs.Eof
    '            Dim EmailSubject As String = ""
    '            Dim EmailBody As String = ""
    '            Select Case PaymentType
    '                Case "APPROVED"
    '                    If Math.Round(rs.fields("Billed"), 2) = Math.Round(rs.fields("Accepted"), 2) Then  ' Full Payment
    '                        EmailSubject = "Pembayaran Klaim Health ke Rekening Karyawan Atas " & rs.fields("Name") & " (Tidak Perlu Dibalas)"
    '                        EmailBody = "<table cellpadding='0' cellspacing='0' width='730px' style='font-family: Calibri; font-size: 14px;'>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>--------------------------------------------------------------------------------------------------------------------------------------------------</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>Yth Bapak/Ibu " & rs.fields("Name") & " </td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>Bersama ini kami informasikan bahwa Klaim Bapak/Ibu dengan data-data sebagai berikut </td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                        "<tr><td style='width: 130px;' valign='top'>Nama</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & rs.fields("Name") & "</td></tr>" & _
    '                                        "<tr><td style='width: 130px;' valign='top'>No Polis</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & rs.fields("PolicyNo") & "</td></tr>" & _
    '                                        "<tr><td style='width: 130px;' valign='top'>No Klaim</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & rs.fields("ClaimNo") & "</td></tr>" & _
    '                                        "<tr><td style='width: 130px;' valign='top'>Tanggal Klaim</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & Format(rs.fields("Start"), "dd/MM/yyyy") & "-" & Format(rs.fields("Finish"), "dd/MM/yyyy") & "</td></tr>" & _
    '                                        "<tr><td style='width: 130px;' valign='top'>Nilai Klaim</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & rs.fields("Currency") & " " & FormatNumber(Format(rs.fields("Billed"), "###,###,###,###,###.##"), 2) & "</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>Telah kami bayarkan pada tanggal " & Format(rs.fields("Date"), "dd/MM/yyyy") & " senilai " & rs.fields("Currency") & " " & FormatNumber(Format(rs.fields("Amount"), "###,###,###,###,###.##"), 2) & " ke rekening </td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>nomor " & rs.fields("AccountNo") & " di Bank " & rs.fields("BankName") & " atas nama " & rs.fields("BankAccount") & ". </td></tr>" & _
    '                                        "<tr><td  style='width: 100%;'colspan='3' valign='top'>Untuk informasi lebih lanjut, Bapak/Ibu dapat menghubungi " & CompanyPhone & " </td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>Hormat kami,</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>" & CompanyName & "</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>--------------------------------------------------------------------------------------------------------------------------------------------------</td></tr>" & _
    '                                        "</table>"
    '                    Else
    '                        EmailSubject = "Pembayaran Klaim Health ke Rekening Karyawan Atas " & rs.fields("Name") & " (Tidak Perlu Dibalas)"
    '                        EmailBody = "<table cellpadding='0' cellspacing='0' width='730px' style='font-family: Calibri; font-size: 14px;'>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>--------------------------------------------------------------------------------------------------------------------------------------------------</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>Yth Bapak/Ibu " & rs.fields("Name") & " </td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>Bersama ini kami informasikan bahwa Klaim Bapak/Ibu dengan data-data sebagai berikut </td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                        "<tr><td style='width: 130px;' valign='top'>Nama</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & rs.fields("Name") & "</td></tr>" & _
    '                                        "<tr><td style='width: 130px;' valign='top'>No Polis</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & rs.fields("PolicyNo") & "</td></tr>" & _
    '                                        "<tr><td style='width: 130px;' valign='top'>No Klaim</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & rs.fields("ClaimNo") & "</td></tr>" & _
    '                                        "<tr><td style='width: 130px;' valign='top'>Tanggal Klaim</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & Format(rs.fields("Start"), "dd/MM/yyyy") & "-" & Format(rs.fields("Finish"), "dd/MM/yyyy") & "</td></tr>" & _
    '                                        "<tr><td style='width: 130px;' valign='top'>Nilai Klaim</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & rs.fields("Currency") & " " & FormatNumber(Format(rs.fields("Billed"), "###,###,###,###,###.##"), 2) & "</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>Telah kami bayarkan pada tanggal " & Format(rs.fields("Date"), "dd/MM/yyyy") & " senilai " & rs.fields("Currency") & " " & FormatNumber(Format(rs.fields("Amount"), "###,###,###,###,###.##"), 2) & " ke rekening </td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>nomor " & rs.fields("AccountNo") & " di Bank " & rs.fields("BankName") & " atas nama " & rs.fields("BankAccount") & ". </td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>Nilai pembayaran tidak sama dengan nilai klaim yang Bapak/Ibu ajukan, disebabkan karena :</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>" & rs.fields("Reason") & " </td></tr>" & _
    '                                        "<tr><td  style='width: 100%;'colspan='3' valign='top'>Untuk informasi lebih lanjut, Bapak/Ibu dapat menghubungi " & CompanyPhone & " </td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>Hormat kami,</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>" & CompanyName & "</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>--------------------------------------------------------------------------------------------------------------------------------------------------</td></tr>" & _
    '                                        "</table>"
    '                    End If

    '                Case "UN-APPROVED"
    '                    If rs.fields("Billed") = rs.fields("Accepted") Then  ' Full Payment                            
    '                        EmailSubject = "Koreksi Pembayaran Klaim Health ke Rekening Karyawan Atas " & rs.fields("Name") & " (Tidak Perlu Dibalas)"
    '                        EmailBody = "<table cellpadding='0' cellspacing='0' width='730px' style='font-family: Calibri; font-size: 14px;'>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>--------------------------------------------------------------------------------------------------------------------------------------------------</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>Yth Bapak/Ibu " & rs.fields("Name") & " </td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>Mohon maaf, terdapat KOREKSI informasi transfer dana ke rekening Anda:</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                        "<tr><td style='width: 130px;' valign='top'>Nama</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & rs.fields("Name") & "</td></tr>" & _
    '                                        "<tr><td style='width: 130px;' valign='top'>No Polis</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & rs.fields("PolicyNo") & "</td></tr>" & _
    '                                        "<tr><td style='width: 130px;' valign='top'>No Klaim</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & rs.fields("ClaimNo") & "</td></tr>" & _
    '                                        "<tr><td style='width: 130px;' valign='top'>Tanggal Klaim</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & Format(rs.fields("Start"), "dd/MM/yyyy") & "-" & Format(rs.fields("Finish"), "dd/MM/yyyy") & "</td></tr>" & _
    '                                        "<tr><td style='width: 130px;' valign='top'>Nilai Klaim</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & rs.fields("Currency") & " " & FormatNumber(Format(rs.fields("Billed"), "###,###,###,###,###.##"), 2) & "</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>Akan dikirimkan notifikasi lagi apabila sudah diproses kembali.</td></tr>" & _
    '                                        "<tr><td  style='width: 100%;'colspan='3' valign='top'>Mohon maaf atas ketidak nyamanannya.</td></tr>" & _
    '                                        "<tr><td  style='width: 100%;'colspan='3' valign='top'>Untuk informasi lebih lanjut, Bapak/Ibu dapat menghubungi " & CompanyPhone & " </td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>Hormat kami,</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>" & CompanyName & "</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>--------------------------------------------------------------------------------------------------------------------------------------------------</td></tr>" & _
    '                                        "</table>"
    '                    Else
    '                        EmailSubject = "Koreksi Pembayaran Klaim Health ke Rekening Karyawan Atas " & rs.fields("Name") & " (Tidak Perlu Dibalas)"
    '                        EmailBody = "<table cellpadding='0' cellspacing='0' width='730px' style='font-family: Calibri; font-size: 14px;'>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>--------------------------------------------------------------------------------------------------------------------------------------------------</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>Yth Bapak/Ibu " & rs.fields("Name") & " </td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>Mohon maaf, terdapat KOREKSI informasi transfer dana ke rekening Anda:</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                        "<tr><td style='width: 130px;' valign='top'>Nama</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & rs.fields("Name") & "</td></tr>" & _
    '                                        "<tr><td style='width: 130px;' valign='top'>No Polis</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & rs.fields("PolicyNo") & "</td></tr>" & _
    '                                        "<tr><td style='width: 130px;' valign='top'>No Klaim</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & rs.fields("ClaimNo") & "</td></tr>" & _
    '                                        "<tr><td style='width: 130px;' valign='top'>Tanggal Klaim</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & Format(rs.fields("Start"), "dd/MM/yyyy") & "-" & Format(rs.fields("Finish"), "dd/MM/yyyy") & "</td></tr>" & _
    '                                        "<tr><td style='width: 130px;' valign='top'>Nilai Klaim</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & rs.fields("Currency") & " " & FormatNumber(Format(rs.fields("Billed"), "###,###,###,###,###.##"), 2) & "</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>Akan dikirimkan notifikasi lagi apabila sudah diproses kembali.</td></tr>" & _
    '                                        "<tr><td  style='width: 100%;'colspan='3' valign='top'>Mohon maaf atas ketidak nyamanannya.</td></tr>" & _
    '                                        "<tr><td  style='width: 100%;'colspan='3' valign='top'>Untuk informasi lebih lanjut, Bapak/Ibu dapat menghubungi " & CompanyPhone & " </td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>Hormat kami,</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>" & CompanyName & "</td></tr>" & _
    '                                        "<tr><td style='width: 100%;' colspan='3' valign='top'>--------------------------------------------------------------------------------------------------------------------------------------------------</td></tr>" & _
    '                                        "</table>"
    '                    End If

    '            End Select

    '            If tostr(rs.fields("Email")) <> "" Then
    '                SendMailNotification(tostr(rs.fields("Email")), EmailSubject, EmailBody)
    '            End If
    '            If tostr(rs.fields("Email_2")) <> "" Then
    '                SendMailNotification(tostr(rs.fields("Email_2")), EmailSubject, EmailBody)
    '            End If

    '            rs.MoveNext()
    '        Loop
    '    Else
    '        SQL = "Select Profile.Email, Profile.EMail_2, ProAcc.ID, ProAcc.Description, pVoucher.Date, pVoucher.BankName, pVoucher.AccountNo, pVoucher.BankAccount, pVoucher.Currency, pVoucher.Nominal_CC, pVoucher.Diff_CC, pVoucher.Remarks"
    '        SQL = SQL & " from pVoucher"
    '        SQL = SQL & " inner join ProAcc on (ProAcc.ProAcc=pVoucher.ProAcc)"
    '        SQL = SQL & " inner join Profile on (Profile.ID=ProAcc.ID)"
    '        SQL = SQL & " Where pVoucher.RefType='TRANSFER' and (pVoucher.AccountNo<>'' or pVoucher.BankAccount<>'') and pVoucher.Voucher='" & Voucher & "'"
    '        rs = db.OpenRemoteSet(SQL)

    '        If Not rs.Eof Then
    '            Dim EmailSubject As String = ""
    '            Dim EmailBody As String = ""
    '            Select Case PaymentType
    '                Case "APPROVED"
    '                    EmailSubject = "Notifikasi Transfer Dana Masuk dari " & CompanyName & " (Tidak Perlu Dibalas)"
    '                    EmailBody = "<table cellpadding='0' cellspacing='0' width='730px' style='font-family: Calibri; font-size: 14px;'>" & _
    '                                    "<tr><td style='width: 100%;' colspan='3' valign='top'>--------------------------------------------------------------------------------------------------------------------------------------------------</td></tr>" & _
    '                                    "<tr><td style='width: 100%;' colspan='3' valign='top'>Yth Bapak/Ibu,</td></tr>" & _
    '                                    "<tr><td style='width: 100%;' colspan='3' valign='top'>Bersama ini kami informasikan bahwa telah dilakukan transfer dana dari " & CompanyName & " ke rekening Anda:</td></tr>" & _
    '                                    "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                    "<tr><td style='width: 130px;' valign='top'>Tanggal</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & Format(rs.fields("Date"), "dd/MM/yyyy") & "</td></tr>" & _
    '                                    "<tr><td style='width: 130px;' valign='top'>ID Profile</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & rs.fields("ID") & "-" & rs.fields("Description") & "</td></tr>" & _
    '                                    "<tr><td style='width: 130px;' valign='top'>Bank</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & rs.fields("BankName") & "</td></tr>" & _
    '                                    "<tr><td style='width: 130px;' valign='top'>No Rekening</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & rs.fields("AccountNo") & "-" & rs.fields("BankAccount") & "</td></tr>" & _
    '                                    "<tr><td style='width: 130px;' valign='top'>Jumlah</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & rs.fields("Currency") & " " & FormatNumber(Format(rs.fields("Nominal_CC") - rs.fields("Diff_CC"), "###,###,###,###,###.##"), 2) & "</td></tr>" & _
    '                                    "<tr><td style='width: 130px;' valign='top'>Keterangan</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & rs.fields("Remarks") & "</td></tr>" & _
    '                                    "<tr><td style='width: 130px;' valign='top'>No. Pembayaran</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & Voucher & "</td></tr>" & _
    '                                    "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                    "<tr><td style='width: 100%;' colspan='3' valign='top'>Untuk pertanyaan lebih lanjut, silahkan kirim email ke : " & GetAppSetting("Email") & "</td></tr>" & _
    '                                    "<tr><td  style='width: 100%;'colspan='3' valign='top'>atau hubungi : " & CompanyName & " di " & CompanyPhone & " bagian Finance Departement / PIC Terkait.</td></tr>" & _
    '                                    "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                    "<tr><td style='width: 100%;' colspan='3' valign='top'>Hormat kami,</td></tr>" & _
    '                                    "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                    "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                    "<tr><td style='width: 100%;' colspan='3' valign='top'>" & CompanyName & "</td></tr>" & _
    '                                    "<tr><td style='width: 100%;' colspan='3' valign='top'>--------------------------------------------------------------------------------------------------------------------------------------------------</td></tr>" & _
    '                                    "</table>"
    '                Case "UN-APPROVED"
    '                    EmailSubject = "Koreksi Notifikasi Transfer Dana Masuk dari " & CompanyName & " (Tidak Perlu Dibalas)"
    '                    EmailBody = "<table cellpadding='0' cellspacing='0' width='730px' style='font-family: Calibri; font-size: 14px;'>" & _
    '                                    "<tr><td style='width: 100%;' colspan='3' valign='top'>--------------------------------------------------------------------------------------------------------------------------------------------------</td></tr>" & _
    '                                    "<tr><td style='width: 100%;' colspan='3' valign='top'>Yth Bapak/Ibu,</td></tr>" & _
    '                                    "<tr><td style='width: 100%;' colspan='3' valign='top'>Mohon maaf, terdapat KOREKSI informasi transfer dana dari " & CompanyName & " ke rekening Anda:</td></tr>" & _
    '                                    "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                    "<tr><td style='width: 130px;' valign='top'>Tanggal</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & Format(rs.fields("Date"), "dd/MM/yyyy") & "</td></tr>" & _
    '                                    "<tr><td style='width: 130px;' valign='top'>ID Profile</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & rs.fields("ID") & "-" & rs.fields("Description") & "</td></tr>" & _
    '                                    "<tr><td style='width: 130px;' valign='top'>Bank</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & rs.fields("BankName") & "</td></tr>" & _
    '                                    "<tr><td style='width: 130px;' valign='top'>No Rekening</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & rs.fields("AccountNo") & "-" & rs.fields("BankAccount") & "</td></tr>" & _
    '                                    "<tr><td style='width: 130px;' valign='top'>Jumlah</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & rs.fields("Currency") & " " & FormatNumber(Format(rs.fields("Nominal_CC") - rs.fields("Diff_CC"), "###,###,###,###,###.##"), 2) & "</td></tr>" & _
    '                                    "<tr><td style='width: 130px;' valign='top'>Keterangan</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & rs.fields("Remarks") & "</td></tr>" & _
    '                                    "<tr><td style='width: 130px;' valign='top'>No. Pembayaran</td><td align='center' style='width: 10px;' valign='top'>:</td><td style='width: 590px;' valign='top'>" & Voucher & "</td></tr>" & _
    '                                    "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                    "<tr><td style='width: 100%;' colspan='3' valign='top'>Akan dikirimkan notifikasi lagi apabila sudah diproses kembali.</td></tr>" & _
    '                                    "<tr><td  style='width: 100%;'colspan='3' valign='top'>Mohon maaf atas ketidak nyamanannya.</td></tr>" & _
    '                                    "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                    "<tr><td style='width: 100%;' colspan='3' valign='top'>Untuk pertanyaan lebih lanjut, silahkan kirim email ke : " & GetAppSetting("Email") & "</td></tr>" & _
    '                                    "<tr><td  style='width: 100%;'colspan='3' valign='top'>atau hubungi : " & CompanyName & " di " & CompanyPhone & " bagian Finance Departement / PIC Terkait.</td></tr>" & _
    '                                    "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                    "<tr><td style='width: 100%;' colspan='3' valign='top'>Hormat kami,</td></tr>" & _
    '                                    "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                    "<tr><td style='width: 100%;' colspan='3' valign='top'>&nbsp;</td></tr>" & _
    '                                    "<tr><td style='width: 100%;' colspan='3' valign='top'>" & CompanyName & "</td></tr>" & _
    '                                    "<tr><td style='width: 100%;' colspan='3' valign='top'>--------------------------------------------------------------------------------------------------------------------------------------------------</td></tr>" & _
    '                                    "</table>"
    '            End Select

    '            If tostr(rs.fields("Email")) <> "" Then
    '                SendMailNotification(tostr(rs.fields("Email")), EmailSubject, EmailBody, GetAppSetting("EmailNotification"))
    '            End If
    '            If tostr(rs.fields("Email_2")) <> "" Then
    '                SendMailNotification(tostr(rs.fields("Email_2")), EmailSubject, EmailBody, GetAppSetting("EmailNotification"))
    '            End If
    '        End If
    '    End If
    'End Function
    Private Function SendMailNotification(ByVal EmailTo As String, ByVal EmailSubject As String, ByVal EmailBody As String, Optional ByVal EmailCC As String = "") As Boolean
        Try
            Dim rs As RemoteSet
            Dim SMTPServer As String
            Dim SMTPPort As String
            Dim SMTPEmail As String
            Dim EmailFrom As String = ""

            rs = db.OpenRemoteSet("Select SMTPServer, SMTPPort, SMTPEmail from SysTab")
            SMTPServer = rs.fields("SMTPServer")
            SMTPPort = rs.fields("SMTPPort")
            SMTPEmail = rs.fields("SMTPEmail")

            If EmailFrom = "" Then EmailFrom = SMTPEmail

            Dim msgMail As New System.Net.Mail.MailMessage()
            Dim smtSender As SmtpClient = New SmtpClient()

            If EmailFrom <> "" AndAlso IsNothing(msgMail.From) Then
                msgMail.From = New System.Net.Mail.MailAddress(EmailFrom)
            Else
                If Not IsNothing(msgMail.From) Then
                    EmailFrom = msgMail.From.Address
                End If
            End If

            With smtSender
                .DeliveryMethod = SmtpDeliveryMethod.Network
                If .Host = "" Then
                    .Host = SMTPServer
                End If
                If .Port = 0 Then
                    .Port = SMTPPort
                End If
                If .EnableSsl = False AndAlso CBool(toval(GetAppSetting("SMTPEnableSSL"))) Then
                    .EnableSsl = CBool(toval(GetAppSetting("SMTPEnableSSL")))
                End If

                If .EnableSsl And GetAppSetting("EmailSecurityProtocolType") <> "" Then
                    ServicePointManager.Expect100Continue = True
                    ServicePointManager.DefaultConnectionLimit = 9999
                    ServicePointManager.SecurityProtocol = toval(GetAppSetting("EmailSecurityProtocolType"))
                End If
            End With

            If smtSender.Host <> "" AndAlso EmailFrom <> "" Then
                Dim tmpRecipient As String()
                Dim AddEmailBody As String = ""
                tmpRecipient = EmailTo.Replace(";", ",").Split(",")
                For i As Integer = 0 To tmpRecipient.Length - 1
                    If InStr(tmpRecipient(i).Trim, GetAppSetting("AutoForwardEmailDomain")) <> 0 And GetAppSetting("AutoForwardEmailTo") <> "" Then
                        If AddEmailBody = "" Then
                            AddEmailBody = tmpRecipient(i).Trim
                            tmpRecipient(i) = GetAppSetting("AutoForwardEmailTo")
                        Else
                            AddEmailBody = AddEmailBody & ";" & tmpRecipient(i).Trim
                            tmpRecipient(i) = ""
                        End If
                    End If
                    If ValidateEmail(tmpRecipient(i).Trim) Then
                        msgMail.To.Add(New System.Net.Mail.MailAddress(tmpRecipient(i).Trim))
                    End If
                Next

                If EmailCC <> "" Then
                    Dim tmpCC As String()
                    tmpCC = EmailTo.Replace(";", ",").Split(",")
                    For i As Integer = 0 To tmpCC.Length - 1
                        If ValidateEmail(tmpCC(i).Trim) Then
                            msgMail.CC.Add(New System.Net.Mail.MailAddress(tmpCC(i).Trim))
                        End If
                    Next
                End If
                msgMail.SubjectEncoding = UTF8Encoding.UTF8
                msgMail.Subject = EmailSubject
                msgMail.IsBodyHtml = True
                msgMail.BodyEncoding = UTF8Encoding.UTF8
                Try
                    If AddEmailBody <> "" Then
                        msgMail.Body = AddEmailBody & vbCrLf & EmailBody
                    Else
                        msgMail.Body = EmailBody
                    End If
                    smtSender.Send(msgMail)
                Catch ex As Exception
                End Try
            End If
            msgMail.Dispose()
        Catch ex As Exception

        End Try
        Return True
    End Function

    Private Function AutoPrintOR(ByVal Voucher As String, ByRef ErrMsg As String) As Boolean
        Try
            Dim rs As RemoteSet
            Dim SQL As String

            SQL = "Select Top 1 SL.Doc_No"
            SQL = SQL & " from oSL('" & Voucher & "') SL "
            SQL = SQL & " Inner join nVoucher on (nVoucher.Voucher=SL.Doc_No and SL.PaymentF=1 and nVoucher.DebtorF=1)"
            SQL = SQL & " inner Join Admlink on (Admlink.Voucher=nVoucher.Voucher and Admlink.Type in ('DI','IC','IR','IT','IX'))"
            rs = db.OpenRemoteSet(SQL)
            If Not rs.Eof Then
            End If

            AutoPrintOR = True
        Catch ex As Exception
            ErrMsg = ex.Message
            AutoPrintOR = False
        End Try
    End Function
    Private Function Insert_Receipt_Auto_Print(ByVal Voucher As String, ByVal SentTo As Integer) As Boolean
        On Error GoTo errmsg
        Dim rs As RemoteSet
        Dim rsA As RemoteSet
        rsA = db.OpenRemoteSet("Select * from APDBucket Where Status='R' and AppType='RECEIPT' and AppID='" & Voucher & "'")
        If rsA.Eof Then
            rs = db.OpenRemoteSet("Select * from Get_RECEIPT_APRule('" & Voucher & "','" & SentTo & "')")
            Do While Not rs.Eof
                rsA.AddNew()
                rsA.fields("AppID") = Voucher
                rsA.fields("DocNo") = rs.fields("DocNo")
                rsA.fields("SentTo") = SentTo
                rsA.fields("AppType") = "RECEIPT"
                rsA.fields("RuleID") = rs.fields("RuleID")
                rsA.fields("Class") = rs.fields("Class")
                rsA.fields("RepName") = rs.fields("RepName")
                rsA.fields("ExeName") = rs.fields("ExeName")
                rsA.fields("Version") = ""
                rsA.fields("eStampDutyF") = toval(rs.fields("ApplyeStampDutyF"))
                rsA.fields("NeedEmailF") = toval(rs.fields("NeedEmailF"))
                rsA.fields("NeedPrintF") = toval(rs.fields("NeedPrintF"))
                rsA.fields("NeedeStampDutyF") = toval(rs.fields("NeedeStampDutyF"))
                rsA.fields("Last_Opr") = dbUser
                rsA.fields("Last_Update") = Today.Date
                rsA.fields("Status") = "R"
                If Not rsA.Update Then GoTo errmsg
                rs.MoveNext()
            Loop
        End If

        Insert_Receipt_Auto_Print = True
        Exit Function
errmsg:
        Insert_Receipt_Auto_Print = False
        Exit Function
    End Function
    Private Function Insert_Payment_Auto_Print(ByVal Voucher As String) As Boolean
        On Error GoTo errmsg
        Dim rs As RemoteSet
        Dim rsA As RemoteSet
        rsA = db.OpenRemoteSet("Select * from APDBucket Where Status='R' and AppType='PAYMENT' and AppID='" & Voucher & "'")
        If rsA.Eof Then
            rs = db.OpenRemoteSet("Select * from Get_PAYMENT_APRule('" & Voucher & "')")
            Do While Not rs.Eof
                rsA.AddNew()
                rsA.fields("AppID") = Voucher
                rsA.fields("AppType") = "PAYMENT"
                rsA.fields("RuleID") = rs.fields("RuleID")
                rsA.fields("Class") = rs.fields("Class")
                rsA.fields("RepName") = rs.fields("RepName")
                rsA.fields("ExeName") = rs.fields("ExeName")
                rsA.fields("Version") = ""
                rsA.fields("eStampDutyF") = toval(rs.fields("ApplyeStampDutyF"))
                rsA.fields("NeedEmailF") = toval(rs.fields("NeedEmailF"))
                rsA.fields("NeedPrintF") = toval(rs.fields("NeedPrintF"))
                rsA.fields("NeedeStampDutyF") = toval(rs.fields("NeedeStampDutyF"))
                rsA.fields("Last_Opr") = dbUser
                rsA.fields("Last_Update") = Today.Date
                rsA.fields("Status") = "R"
                If Not rsA.Update Then GoTo errmsg
                rs.MoveNext()
            Loop
        End If

        Insert_Payment_Auto_Print = True
        Exit Function
errmsg:
        Insert_Payment_Auto_Print = False
        Exit Function
    End Function
    Private Function FANotes(ByVal DocNo As String, ByVal Category As String, ByVal Notes As String) As Boolean
        Dim db As New ClassLib
        Try
            If Not db.OpenConnection("", dbName, dbServer, dbSysUser, dbSysPassword, dbTimeOut, dbTrusted) Then
                Throw New Exception(db.ErrDesc)
            End If
            db.Var_db_user = dbUser
            db.Var_db_Password = dbPassword
            db.Var_db_User_Type = dbUserType
            db.Begintrans()
            FANotes = db.Execute("Insert into FANotes(DocNo,Date,Time, UserID, Category,Notes, SystemF) Select '" & DocNo & "','" & Format(Today.Date, "MM/DD/YYYY") & "','" & Time() & "','" & dbUser & "','" & Category & "','" & tostr(Notes) & "'," & 1)

            db.Committrans()
            db.CloseSession()
            Return True
        Catch ex As Exception
            db.RollBack()
            db.CloseSession()
            Return False
        End Try
    End Function
    Private ReadOnly Property ErrDesc() As String
        Get
            ErrDesc = StrMsg
        End Get
    End Property
    Private Function Direct_Call_Process_Execute(ByVal ProcLib As String, ByVal ProcName As String, Optional ByVal Param1 As Object = Nothing, Optional ByVal Param2 As Object = Nothing, Optional ByVal Param3 As Object = Nothing, Optional ByVal Param4 As Object = Nothing, Optional ByVal Param5 As Object = Nothing, Optional ByVal Param6 As Object = Nothing, Optional ByVal NewSessionFlag As Boolean = False) As Object
        Dim PObj As Object = Nothing
        Try
            StrMsg = ""
            Select Case UCase(ProcLib)
                Case "PROCESSFA.NETV4.PROCLIB", "PROCESSFA.NETV3.PROCLIB"
                    PObj = New ProcessFA.NetV4.Proclib
                Case "PROCESSFAEXT.NETV4.PROCLIB", "PROCESSFAEXT.NETV3.PROCLIB"
                    PObj = New ProcessFAExt.NetV4.Proclib
                Case "PROCESS.NETV4.PROCLIB", "PROCESS.NETV3.PROCLIB"
                    PObj = New Process.NetV4.Proclib
                Case "PROCESSEXT.NETV4.PROCLIB", "PROCESSEXT.NETV3.PROCLIB"
                    PObj = New ProcessExt.NetV4.Proclib
                Case "PROCESSCLEXT.NETV4.PROCLIB", "PROCESSCLEXT.NETV3.PROCLIB"
                    PObj = New ProcessCLExt.NetV4.Proclib
                Case "PROCESSUL.NETV4.PROCLIB", "PROCESSUL.NETV3.PROCLIB"
                    PObj = New ProcessUL.NetV4.Proclib
                Case "PROCESSHK.NETV4.PROCLIB", "PROCESSHK.NETV3.PROCLIB"
                    PObj = New ProcessHK.NetV4.Proclib
                Case "PROCESSSC.NETV4.PROCLIB", "PROCESSSC.NETV3.PROCLIB"
                    PObj = New ProcessSC.NetV4.Proclib
            End Select

            PObj.Var_db_User = dbUser
            PObj.Var_db_User_Type = dbUserType
            PObj.Var_db_User_CCode = CCode
            PObj.Var_Db_Name = dbName
            PObj.Var_Db_Server = dbServer
            PObj.Var_db_Password = dbPassword
            PObj.Var_db_SysUser = dbSysUser
            PObj.Var_db_SysPassword = dbSysPassword
            PObj.Var_db_TimeOut = dbTimeOut
            PObj.Var_db_Trusted = dbTrusted
            PObj.Var_ObjSession = db.Var_ObjSession

            If NewSessionFlag Then
                Direct_Call_Process_Execute = PObj.Call_Process("", ProcName, Param1, Param2, Param3, Param4, Param5, Param6)
            Else
                Direct_Call_Process_Execute = PObj.Call_Process_Execute("", ProcName, Param1, Param2, Param3, Param4, Param5, Param6, NewSessionFlag)
            End If
            StrMsg = PObj.ErrDesc
            PObj = Nothing
        Catch ex As Exception
            StrMsg = ex.Message
            PObj = Nothing
            Return False
        End Try
    End Function
    Private Function Direct_Call_Ext_Process(ByVal ProcLib As String, ByVal ProcName As String, Optional ByVal Param1 As Object = Nothing, Optional ByVal Param2 As Object = Nothing, Optional ByVal Param3 As Object = Nothing, Optional ByVal Param4 As Object = Nothing, Optional ByVal Param5 As Object = Nothing, Optional ByVal Param6 As Object = Nothing) As Object
        Direct_Call_Ext_Process = Direct_Call_Process_Execute(ProcLib, ProcName, Param1, Param2, Param3, Param4, Param5, Param6, True)
    End Function

End Class