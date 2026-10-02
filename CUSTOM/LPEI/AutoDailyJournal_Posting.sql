CREATE PROCEDURE [dbo].[AutoDailyJournal_Posting](@P_PDate AS smalldatetime)    
----WITH RECOMPILE                       
AS                        
/*Modified By : JKD*/                        
/*Modified On : 12-2-2020*/                        
/*Modified Reason : Changed for rounding decimal number after comma */                        
/*=== Script dari proses Export Daily Journal Finance ===--  */  
/*
select MAX(cast(colvalueold as smalldatetime)) a into #Z from syslogobject where logname='systab' and ColName='flockeddate' --ambil tanggal terakhir EOD/ EOM
*/
select top 1 cast(colvalueold as smalldatetime) a into #z from syslogobject where logname='systab' and ColName='flockeddate' 
order by ID desc --ambil tanggal terakhir EOD/ EOM
Declare @XML TABLE (Voucher Varchar(20),Product Varchar(20),A_SDate Smalldatetime,A_MO Varchar(50),Bank Varchar(10),BIType Varchar(10),                        
     Area Varchar(10),HSCode Varchar(10),RCCOde Varchar(50),Branch Varchar(50),Entity Varchar(50),Remarks Varchar(1024),Date Smalldatetime,DocNo Varchar(50),                        
     RefNo Varchar(50),GL_Code Varchar(50),Description Varchar(100),Currency Varchar(5),Debit_OC Float,Credit_OC Float,Debit Float,Credit Float,                        
     Rate Float, Original_CurrencyF bit)                        
--declare @P_PDate AS smalldatetime='08/22/2025'       
insert into @XML                        
SELECT '' as Voucher,                       
  --'' as CODE,          
  J.Product, ----new  
  '' as A_SDate,                       
  j.A_MO,                       
  '' as Bank,                       
  '' as BIType,                       
  '' as Area,                       
  j.HSCode as HSCode,                         
  J.RCCode,     ----- new                  
  COALESCE(XBranch.Branch, J.Branch) AS Branch,    
  J.Entity, ---- new  
  '' as Remarks,                       
  J.Date,                       
  '' as DocNo,                       
  '' as RefNo,    
  COALESCE(CASE WHEN SysTab.Currency = J.Currency THEN XAccount.Account ELSE XAccount.Account_FCY END,J.GL_Code) AS GL_Code,      -----new                 
    --J.Description,    
   --COALESCE(XAccount.Name, J.Description) AS Description,   
   COALESCE(CASE WHEN SysTab.Currency = J.Currency THEN J.description ELSE XAccount.Description END,J.Description) as Descrition,  --REPLACE DESCRIPTION JIKA ADA FCY DI XACCOUNT                     
  J.Currency,                         
  case when J.CURRENCY='IDR' then round(sum(J.Debit_OC),0)          
   when round(sum(J.Debit_OC),2)<>0 then  round(sum(J.Debit_OC),2)                        
   when round(sum(J.Debit_OC),3)<>0 then  round(sum(J.Debit_OC),3)                        
   when round(sum(J.Debit_OC),4)<>0 then  round(sum(J.Debit_OC),4)                        
  else 0 end as Debit_OC,                         
  case when J.CURRENCY='IDR' then round(sum(J.Credit_OC),0)          
   when round(sum(J.Credit_OC),2) <>0 then  round(sum(J.Credit_OC),2)                        
   when round(sum(J.Credit_OC),3) <>0 then round(sum(J.Credit_OC),3)                        
   when round(sum(J.Credit_OC),4) <>0 then round(sum(J.Credit_OC),4)                        
  else 0 end as Credit_OC,                        
  round(sum(J.Debit),0) AS Debit,                       
  round(sum(J.Credit),0) AS Credit,                        
 -- case           
 --when round((case when J.CURRENCY='IDR' then round(sum(J.Debit_OC),0)          
 --   when round(sum(J.Debit_OC),2)<>0 then  round(sum(J.Debit_OC),2)                        
 --   when round(sum(J.Debit_OC),3)<>0 then  round(sum(J.Debit_OC),3)                        
 --   when round(sum(J.Debit_OC),4)<>0 then  round(sum(J.Debit_OC),4)                        
 --  else 0 end)-(case when J.CURRENCY='IDR' then round(sum(J.Credit_OC),0)          
 --   when round(sum(J.Credit_OC),2) <>0 then  round(sum(J.Credit_OC),2)                        
 --   when round(sum(J.Credit_OC),3) <>0 then round(sum(J.Credit_OC),3)                        
 --   when round(sum(J.Credit_OC),4) <>0 then round(sum(J.Credit_OC),4)                        
 --  else 0 end),2)<>0 then (round(sum(J.Debit),0)-round(sum(J.Credit),0))/((case when J.CURRENCY='IDR' then round(sum(J.Debit_OC),0)          
 --   when round(sum(J.Debit_OC),2)<>0 then  round(sum(J.Debit_OC),2)     
 --   when round(sum(J.Debit_OC),3)<>0 then  round(sum(J.Debit_OC),3)                        
 --   when round(sum(J.Debit_OC),4)<>0 then  round(sum(J.Debit_OC),4)                        
 --  else 0 end)-(case when J.CURRENCY='IDR' then round(sum(J.Credit_OC),0)          
 --   when round(sum(J.Credit_OC),2) <>0 then  round(sum(J.Credit_OC),2)                        
 --   when round(sum(J.Credit_OC),3) <>0 then round(sum(J.Credit_OC),3)                        
 --   when round(sum(J.Credit_OC),4) <>0 then round(sum(J.Credit_OC),4)                        
 --  else 0 end))          
 --else 1          
 -- end as Rate,              
  1 as Rate,          
  J.Original_CurrencyF                        
 FROM                      
 (                        
  /* Production*/                        
  SELECT nVoucher.Voucher,                       
    Admlink.CODE as Product,     -----new                  
    Admlink.A_SDate,                       
    case when sysuser.ID_No='' or sysuser.id_no is null then '8888' else sysuser.ID_No end  AS A_MO,                       
    case when (ProAcc.Bank='' or proacc.bank is null) then '9999' else proacc.bank end as Bank,                       
   case when Profile.BIType='' or profile.BIType is null then '9999' else profile.BIType end as BIType,                       
     case when Profile.Area='' or profile.area is NULL then '9999' else profile.area end as Area,                       
    case when(Profile.HSCode='' or profile.hscode is null) then '1150' else profile.HSCode end as HSCode,                         
    case when admlink.CT <> '' then Admlink.CT else '99999' end as RCCode,-----New                       
    Admlink.Date,                       
    Admlink.Remarks,                       
    Admlink.Branch,  
 Branch.Parent as Entity, ---- new  
    Admlink.DocNo,                       
    Admlink.RefNO,           
    Admlink.Currency,                       
    nJournal.Account as GL_Code, -----new                         
    account.description,                         
    nJournal.Debit_OC AS Debit_OC,                         
    nJournal.Credit_OC AS Credit_OC,                         
    nJournal.Debit AS Debit,                         
    nJournal.Credit AS Credit,                         
    case when round(njournal.debit_oc,2)<>0 then  round(njournal.Debit,0)/round(njournal.Debit_OC,2)              
    when round(njournal.debit_oc,3)<>0 then round(njournal.Debit,0)/round(njournal.Debit_OC,3)              
    when round(njournal.debit_oc,4)<>0 then round(njournal.Debit,0)/round(njournal.Debit_OC,4)              
    when round(njournal.credit_oc,2)<>0 then round(njournal.Credit,0)/round(njournal.Credit_OC,2)              
    when round(njournal.credit_oc,3)<>0 then round(njournal.Credit,0)/round(njournal.Credit_OC,3)              
    when round(njournal.credit_oc,4)<>0 then round(njournal.Credit,0)/round(njournal.Credit_OC,4)               
   end as rate,                          
    case when type.bs_flag = 1 then 1 when type. pl_flag = 1  then 0  end as Original_CurrencyF                        
        FROM nVoucher                         
  inner join Admlink on (Admlink.Voucher = nVoucher.Voucher)                        
  inner join ProAcc on (ProAcc.ProAcc = nVoucher.ProAcc)                        
  inner join nJournal on (nJournal.Voucher = nVoucher.Voucher)                        
  inner join Profile on (Profile.ID = ProAcc.ID)                        
  inner join account on (nJournal.Account = Account.Account)                      
  inner join type on (type.type = account.type)          
  inner join Branch on (Branch.Branch=nVoucher.Branch) ---- new  
  left join sysuser on (sysuser.id=admlink.A_MO)                        
  WHERE nVoucher.STATUS = 'P' AND MONTH(nVoucher.Date) = MONTH(@P_PDate) AND YEAR(nVoucher.Date) = YEAR(@P_PDate)  AND nVoucher.Date <= @P_PDate                        
  UNION ALL                        
  /* Generate Process*/                        
  SELECT mVoucher.Voucher,                       
    AccLink.CODE as Product, ----new                       
    CAST('1900/01/01' AS SmallDateTime) AS A_SDate,                       
     case when sysuser.ID_No='' or sysuser.id_no is null then '8888' else sysuser.ID_No end  AS A_MO,                       
    '9999' AS Bank,                         
    '9999' AS BIType,                     
    '9999' AS Area,                       
    '1150' AS HSCode,                       
    '99999' AS RCCode, -----New                       
    AccLink.Date,                       
    AccLink.Remarks,                       
    AccLink.Branch,      
 Branch.Parent as Entity, -----new  
    AccLink.DocNo,                       
    AccLink.RefNO,                         
    mJournal.Currency,   
    mJournal.Account as GL_Code, -----new                      
    account.description,                         
    mJournal.Debit_OC AS Debit_OC,                         
    mJournal.Credit_OC AS Credit_OC,                         
    mJournal.Debit AS Debit,                         
    mJournal.Credit AS Credit,                         
     case when round(mjournal.debit_oc,2)<>0 then  round(mjournal.Debit,0)/round(mjournal.Debit_OC,2)              
    when round(mjournal.debit_oc,3)<>0 then round(mjournal.Debit,0)/round(mjournal.Debit_OC,3)              
    when round(mjournal.debit_oc,4)<>0 then round(mjournal.Debit,0)/round(mjournal.Debit_OC,4)              
    when round(mjournal.credit_oc,2)<>0 then round(mjournal.Credit,0)/round(mjournal.Credit_OC,2)              
    when round(mjournal.credit_oc,3)<>0 then round(mjournal.Credit,0)/round(mjournal.Credit_OC,3)              
    when round(mjournal.credit_oc,4)<>0 then round(mjournal.Credit,0)/round(mjournal.Credit_OC,4)               
   end as rate,                         
    case when type.bs_flag = 1 then 1 when type. pl_flag = 1  then 0 end as Original_CurrencyF                        
  FROM mVoucher                        
  inner join AccLink on (Acclink.Voucher = mVoucher.Voucher)                        
  inner join mJournal on (mJournal.Voucher = mVoucher.Voucher )                        
  inner join account on (mJournal.Account = Account.Account)                      
  inner join type on (type.type = account.type)    
  inner join branch on (branch.branch=mvoucher.branch) -----new  
  left join sysuser on (sysuser.id=acclink.EXTRA_10)                        
  WHERE  
  --mVoucher.STATUS = 'P' AND mVoucher.Date = @P_PDate   
  mVoucher.STATUS = 'P'                      
   AND MONTH(mVoucher.Date) = MONTH(@P_PDate) AND YEAR(mVoucher.Date) = YEAR(@P_PDate) AND mVoucher.Date <= @P_PDate  
-----------------------------------------------------------------------------------------------------------------------------------------------                      
  --*/ JM */                      
  UNION ALL                      
  /* Generate Process*/                       
  SELECT mVoucher.Voucher,                       
    '0000' Product,     ---new  
    CAST('1900/01/01' AS SmallDateTime) AS A_SDate,                       
     case when sysuser.ID_No='' or sysuser.id_no is null then '8888' else sysuser.ID_No end  AS A_MO,                       
    '9999' AS Bank,                         
    '9999' AS BIType,                       
    '9999' AS Area,                       
    '1150' AS HSCode,                       
    Case when Mvoucher.CT <> '' then Mvoucher.CT else '99999' end as RCCode, ------new                      
    MVOUCHER.Date,                       
    MVOUCHER.Remarks,                       
    MVOUCHER.Branch,  
 branch.parent as Entity,----- new  
    '' DocNo,                       
    MVOUCHER.RefNO,                         
    MJOURNAL.Currency,                       
    mJournal.Account as GL_Code,  -----new                     
    account.description,                         
    case when mJournal.Currency='IDR' and Mjournal.debit_oc=0 and Mjournal.debit <>0 then MJournal.Debit else  MJournal.Debit_OC end AS Debit_OC,             
    case when mJournal.Currency='IDR' and Mjournal.credit_oc=0 and Mjournal.credit <>0 then Mjournal.credit else MJournal.Credit_OC end AS Credit_OC,                            
    mJournal.Debit AS Debit,                         
    mJournal.Credit AS Credit,                         
   case           
    when mJournal.Currency='IDR' and Mjournal.debit_oc=0 and Mjournal.debit <>0 then 1            
    when mJournal.Currency='IDR' and Mjournal.credit_oc=0 and Mjournal.credit <>0 then 1            
    when round(mjournal.debit_oc,2)<>0 then  round(mjournal.Debit,0)/round(mjournal.Debit_OC,2)              
    when round(mjournal.debit_oc,3)<>0 then round(mjournal.Debit,0)/round(mjournal.Debit_OC,3)              
    when round(mjournal.debit_oc,4)<>0 then round(mjournal.Debit,0)/round(mjournal.Debit_OC,4)              
    when round(mjournal.credit_oc,2)<>0 then round(mjournal.Credit,0)/round(mjournal.Credit_OC,2)              
    when round(mjournal.credit_oc,3)<>0 then round(mjournal.Credit,0)/round(mjournal.Credit_OC,3)              
    when round(mjournal.credit_oc,4)<>0 then round(mjournal.Credit,0)/round(mjournal.Credit_OC,4)               
   end as rate,                          
    case when type.bs_flag = 1 then 1 when type. pl_flag = 1  then 0 end as Original_CurrencyF                        
  FROM mVoucher                         
  inner join mJournal on (mJournal.Voucher = mVoucher.Voucher )                        
  inner join account on (mJournal.Account = Account.Account)                      
  inner join type on (type.type = account.type)     
  inner join branch on (branch.branch=mvoucher.branch) -----new  
  left join sysuser on (sysuser.id=MVOUCHER.LAST_OPR)                        
  WHERE  mVoucher.STATUS = 'P'                        
   AND MONTH(mVoucher.Date) = MONTH(@P_PDate) AND YEAR(mVoucher.Date) = YEAR(@P_PDate)                       
   AND mVoucher.Date <= @P_PDate                        
  --AND MVOUCHER.VOUCHER NOT IN (SELECT VOUCHER FROM ACCLINK WHERE DATE<=@P_PDate )  
   AND MVOUCHER.VOUCHER NOT IN (SELECT VOUCHER FROM ACCLINK WHERE MONTH(Date) = MONTH(@P_PDate) AND YEAR(Date) = YEAR(@P_PDate) and DATE<=@P_PDate)     
  AND NOT (MVOUCHER.SL_CAT='X' AND MVOUCHER.REFTYPE in ('Revaluation','Balance Before'))  --JOurnal yang dikirim selain JOurnal Revaluasi    
  ------------------------------------------------------------------------------------------------------------------------------------------------                
--/* Payment */               
--/* Update Lisa terkait Erorr MR Account kosong */                        
  UNION ALL                        
 -- SELECT pvoucher.Voucher,                       
 --   '' CODE,                       
 --   CAST('1900/01/01' AS SmallDateTime) A_SDate,                       
 --   sysuser.ID_No AS A_MO,                         
 --   CASE WHEN ProAcc.Bank = '' OR proacc.bank IS NULL THEN '9999' ELSE Proacc.bank END Bank,                         
 --   Profile.BIType,                       
 --   Profile.Area,                       
 --   CASE WHEN Profile.HSCode = '' OR Profile.HScode IS NULL THEN '9999' ELSE Profile.HSCode END HSCode,                         
 --   CASE WHEN pjournal.CT = '' OR pjournal.ct IS NULL THEN 'ASR' ELSE pjournal.ct END CT,                       
 --   pvoucher.Date,                        
 --   CASE WHEN pvoucher.Remarks = '' OR pvoucher.remarks IS NULL THEN Profile.Name ELSE pvoucher.remarks END remarks,                         
 --   pvoucher.Branch,                       
 --   '' AS DocNo,                       
 --   pvoucher.RefNO,                       
 --   pJournal.Currency,                       
 --   pjournal.Account,                         
 --   account.description,          
 --case when pJournal.Currency='IDR' and pjournal.debit_oc=0 and pjournal.debit <>0 then pJournal.Debit else  pJournal.Debit_OC end AS Debit_OC,             
 --   case when pJournal.Currency='IDR' and pjournal.credit_oc=0 and pjournal.credit <>0 then pjournal.credit else pJournal.Credit_OC end AS Credit_OC,                            
 --   pjournal.Debit AS Debit,                        
 --   pjournal.Credit AS Credit,                         
 --  case          
 --  when pJournal.Currency='IDR' and pjournal.debit_oc=0 and pjournal.debit <>0 then 1            
 --  when pJournal.Currency='IDR' and pjournal.credit_oc=0 and pjournal.credit <>0 then 1            
 --  when pJournal.Currency<>'IDR' and ((pjournal.debit_oc=0 and pjournal.debit <>0) or (pjournal.credit_oc=0 and pjournal.credit <>0)) then (select top 1 Rate from pSL where Voucher=pVoucher.Voucher and Account=pJournal.Account and Doc_CCy=pJournal.Currency)          
 --  when round(pjournal.debit_oc,2)<>0 then  round(pJournal.Debit,0)/round(pJournal.Debit_OC,2)          
 --   when round(pjournal.debit_oc,3)<>0 then round(pJournal.Debit,0)/round(pJournal.Debit_OC,3)          
 --   when round(pjournal.debit_oc,4)<>0 then round(pJournal.Debit,0)/round(pJournal.Debit_OC,4)          
 --   when round(pjournal.credit_oc,2)<>0 then round(pJournal.Credit,0)/round(pJournal.Credit_OC,2)          
 --   when round(pjournal.credit_oc,3)<>0 then round(pJournal.Credit,0)/round(pJournal.Credit_OC,3)          
 --   when round(pjournal.credit_oc,4)<>0 then round(pJournal.Credit,0)/round(pJournal.Credit_OC,4)           
 --  end as rate,                          
 --   case when type.bs_flag = 1 then 1 when type. pl_flag = 1  then 0 end as Original_CurrencyF                        
 --FROM pVoucher                        
 --   inner join ProAcc on (ProAcc.ProAcc = pvoucher.ProAcc)                        
 --   inner join pJournal on (pjournal.Voucher = pvoucher.Voucher)                         
 --   inner join Profile on (Profile.ID = ProAcc.ID)                        
 --   inner join account on (pjournal.Account = Account.Account)                      
 --inner join type on (type.type = account.type)                        
 --   left join sysuser on (profile.MOID=sysuser.ID)              
 --   WHERE pvoucher.STATUS = 'P' AND MONTH(pvoucher.Date) = MONTH(@P_PDate) AND YEAR(pvoucher.Date) = YEAR(@P_PDate) AND pvoucher.Date <= @P_PDate       
 SELECT pvoucher.Voucher,                       
     X.CODE as Product,    ------new                   
    CAST('1900/01/01' AS SmallDateTime) A_SDate,                       
     case when sysuser.ID_No='' or sysuser.id_no is null then '8888' else sysuser.ID_No end  AS A_MO,                         
    CASE WHEN (ProAcc.Bank = '' OR proacc.bank IS NULL) THEN '9999' ELSE Proacc.bank END Bank,                         
       case when Profile.BIType='' or profile.BIType is null then '9999' else profile.BIType end as BIType,                                           
    case when Profile.Area='' or profile.area is null then '9999' else profile.Area end as Area,                       
    CASE WHEN (Profile.HSCode = '' or profile.HSCode is null)  THEN '1150' ELSE Profile.HSCode END HSCode,                         
    CASE WHEN x.CT = '' OR x.ct IS NULL THEN '99999' ELSE x.ct END CT,    ----new                   
    pvoucher.Date,                        
    CASE WHEN pvoucher.Remarks = '' OR pvoucher.remarks IS NULL THEN Profile.Name ELSE pvoucher.remarks END remarks,  
     pvoucher.Branch, 
 branch.Parent as Entity,---- new  
    '' AS DocNo,                       
    pvoucher.RefNO,                       
    x.Currency,                       
    x.Account [GL_code],     ------new                  
    account.description,  
    --case when pJournal.Currency='IDR' and pjournal.debit_oc=0 and pjournal.debit <>0 then pJournal.Debit else  pJournal.Debit_OC end AS Debit_OC,             
    --case when pJournal.Currency='IDR' and pjournal.credit_oc=0 and pjournal.credit <>0 then pjournal.credit else pJournal.Credit_OC end AS Credit_OC,                            
    --pjournal.Debit AS Debit,                         
    --pjournal.Credit AS Credit,   
 Case When (x.Debit_OC-x.Credit_OC)<0 Then 0 else (x.Debit_OC-x.Credit_OC) end as Debit_OC,  
 Case When (x.Debit_OC-x.Credit_OC)<0 Then -(x.Debit_OC-x.Credit_OC) else 0 end as Credit_OC,  
 Case When (x.Debit-x.Credit)<0 Then 0 else (x.Debit-x.Credit) end as Debit,  
 Case When (x.Debit-x.Credit)<0 Then -(x.Debit-x.Credit) else 0 end as Credit,  
   case          
   when X.Currency='IDR' and X.debit_oc=0 and X.debit <>0 then 1            
   when X.Currency='IDR' and X.credit_oc=0 and X.credit <>0 then 1            
   when X.Currency<>'IDR' and ((X.debit_oc=0 and X.debit <>0) or (X.credit_oc=0 and X.credit <>0)) then (select top 1 Rate from pSL where Voucher=pVoucher.Voucher and Account=X.Account and Doc_CCy=X.Currency)          
   when round(X.debit_oc,2)<>0 then  round(X.Debit,0)/round(X.Debit_OC,2)          
    when round(X.debit_oc,3)<>0 then round(X.Debit,0)/round(X.Debit_OC,3)          
    when round(X.debit_oc,4)<>0 then round(X.Debit,0)/round(X.Debit_OC,4)          
    when round(X.credit_oc,2)<>0 then round(X.Credit,0)/round(X.Credit_OC,2)          
    when round(X.credit_oc,3)<>0 then round(X.Credit,0)/round(X.Credit_OC,3)          
    when round(X.credit_oc,4)<>0 then round(X.Credit,0)/round(X.Credit_OC,4)           
   end as rate,                          
 case when type.bs_flag = 1 then 1 when type. pl_flag = 1  then 0 end as Original_CurrencyF                    
 FROM (  
Select   
  case when sl.doc_no IN (Select voucher from admlink) then admlink.code else '0000' end as Code,  
V.Branch,  
V.Voucher,  
  v.proacc,  
  sl.doc_no,  
--Case When Account.Open_ItemF=1 Then SL.Account else V1.Account end as Account,   
  SL.Account,  
V.CT,  
--Case When (Type.BS_Flag=1 and Account.Monetary_Flag=1) then SL.Doc_CCy else 'IDR' end as Currency,  
 Case When Account.Monetary_Flag=1 then SL.Doc_CCy else 'IDR' end as Currency,  
--Max(Account.Description) as Description,  
--sum(Case When V1.Debit<>0 Then Case When (Type.BS_Flag=1 and Account.Monetary_Flag=1) Then SL.Nominal_OC else SL.Nominal*V.Rate end else 0 end) as Debit_OC,  
--sum(Case When V1.Credit<>0 Then Case When (Type.BS_Flag=1 and Account.Monetary_Flag=1) Then SL.Nominal_OC else SL.Nominal*V.Rate end else 0 end) as Credit_OC,  
--sum(Case When V1.Debit<>0 Then Case When Account.Monetary_Flag=1 Then SL.Nominal_OC else SL.Nominal*V.Rate end else 0 end) as Debit_OC,  
--sum(Case When V1.Credit<>0 Then Case When Account.Monetary_Flag=1 Then SL.Nominal_OC else SL.Nominal*V.Rate end else 0 end) as Credit_OC,  
--sum(Case When V1.Debit<>0 Then SL.Nominal*V.Rate else 0 end) as Debit,  
--sum(Case When V1.Credit<>0 Then SL.Nominal*V.Rate else 0 end) as Credit,  
--sum(Case When V1.Debit<>0 Then SL.Nominal*V.Rate_RC else 0 end) as Debit_RC,  
--sum(Case When V1.Credit<>0 Then SL.Nominal*V.Rate_RC else 0 end) as Credit_RC  
Case When V1.Debit<>0 Then Case When Account.Monetary_Flag=1 Then SL.Nominal_OC else SL.Nominal*V.Rate end else 0 end as Debit_OC,  
Case When V1.Credit<>0 Then Case When Account.Monetary_Flag=1 Then SL.Nominal_OC else SL.Nominal*V.Rate end else 0 end as Credit_OC,  
Case When V1.Debit<>0 Then SL.Nominal*V.Rate else 0 end  as Debit,  
Case When V1.Credit<>0 Then SL.Nominal*V.Rate else 0 end  as Credit,  
Case When V1.Debit<>0 Then SL.Nominal*V.Rate_RC else 0 end  as Debit_RC,  
Case When V1.Credit<>0 Then SL.Nominal*V.Rate_RC else 0 end  as Credit_RC  
from pvoucher V  
  inner join pSL SL on (V.Voucher=SL.Voucher)  
  inner join VPattern V1 on (V.vType=V1.vType)  
  inner join Account on (Account.Account=V1.Account)  
  inner join Type on (Type.Type=Account.Type)  
  inner join Branch on (V.Branch=Branch.Branch)  
  left join AdmLink on (sl.doc_no=AdmLink.VOUCHER)  
Where    
SL.Voucher=V.Voucher  and  
--and V1.VType=V.VType and   
V1.Debit+V1.Credit=SL.Hint and  
--and Account.Account=V1.Account and Type.Type=Account.Type   
--and V.Branch=Branch.Branch  
--  and   
 V1.Account not like  '1250000000000'  
Group by   
V.Branch,  
V.Voucher,  
  V.ProAcc,  
  sl.doc_no,  
--Case When Account.Open_ItemF=1 Then SL.Account else V1.Account end,  
  SL.Account,  
V.CT,  
--Case When (Type.BS_Flag=1 and Account.Monetary_Flag=1) then SL.Doc_CCy else 'IDR' end  
Case When Account.Monetary_Flag=1 then SL.Doc_CCy else 'IDR' end,  
  admlink.code,  
  SL.Nominal*v.rate,  
  v1.debit,  
  V1.Credit,  
  Account.Monetary_Flag,  
  SL.Nominal_OC,  
  sl.nominal,  
  V.Rate_RC  
) x  
    inner join ProAcc on (ProAcc.ProAcc = x.ProAcc)                        
    --inner join pJournal on (pjournal.Voucher = x.Voucher)                         
    inner join Profile on (Profile.ID = ProAcc.ID)                        
    inner join account on (x.Account = Account.Account)  
    inner join branch on (x.Branch=branch.Branch)                     
    inner join type on (type.type = account.type)                        
    left join sysuser on (profile.MOID=sysuser.ID)   
    left join pVoucher on (x.voucher=pVoucher.Voucher)  
    WHERE   
 pVoucher.Status = 'P' AND MONTH(pvoucher.Date) = MONTH(@P_PDate) AND YEAR(pvoucher.Date) = YEAR(@P_PDate) AND pvoucher.Date <= @P_PDate      
 ) J                        
 INNER JOIN SysTab ON(1 = 1) 
 inner join #Z on (1=1) -- UPDATE SEPT 2025
 LEFT JOIN XAccount ON(XAccount.AccountCode = J.GL_Code ----new  
 AND ((J.Currency = SysTab.Currency AND XAccount.Account <> '') OR (J.Currency <> SysTab.Currency AND XAccount.Account_FCY <> '')))                        
 LEFT JOIN XBranch ON(XBranch.BranchCode = J.Branch AND XBranch.Branch <> '')      
 left join Branch on (Branch.Branch=J.BRANCH) ----- Add Branch parameter  
WHERE (ROUND(J.Debit, 2) <> 0 OR ROUND(J.Credit, 2) <> 0 OR ROUND(J.Debit_OC, 2) <> 0 OR ROUND(J.Credit_OC, 2) <> 0)                       
 And J.Voucher not in (Select Voucher from Staging_Exception)     
 and J.DATE   > #Z.a and J.date <= @P_Pdate -- rentang waktu pengambilan journal
GROUP BY COALESCE(XBranch.Branch, J.Branch), J.DATE  
 , COALESCE(CASE WHEN SysTab.Currency = J.Currency THEN XAccount.Account ELSE XAccount.Account_FCY END,J.GL_Code) -- new                      
 , COALESCE(CASE WHEN SysTab.Currency = J.Currency THEN J.description ELSE XAccount.Description END,J.Description) --NEW  
 , J.CURRENCY, J.Original_CurrencyF      --NEW       
 , J.Product  
 ,j.A_MO  
 ,J.RCCode  
 ,J.Entity  
 ,j.HSCode  
HAVING (case when J.CURRENCY='IDR' then round(sum(J.Debit_OC),0)          
   when round(sum(J.Debit_OC),2)<>0 then  round(sum(J.Debit_OC),2)                        
   when round(sum(J.Debit_OC),3)<>0 then  round(sum(J.Debit_OC),3)                        
   when round(sum(J.Debit_OC),4)<>0 then  round(sum(J.Debit_OC),4)                        
  else 0 end)<>0          
  or (case when J.CURRENCY='IDR' then round(sum(J.Credit_OC),0)          
   when round(sum(J.Credit_OC),2) <>0 then  round(sum(J.Credit_OC),2)                        
   when round(sum(J.Credit_OC),3) <>0 then round(sum(J.Credit_OC),3)                  
   when round(sum(J.Credit_OC),4) <>0 then round(sum(J.Credit_OC),4)                        
  else 0 end)<>0          
  or round(sum(J.Debit),0)<>0 or round(sum(J.Credit),0)<>0          
ORDER BY J.DATE    
OPTION (OPTIMIZE FOR (@P_PDate UNKNOWN))    
;                 
 Declare @s as Float (50)                        
 Set @S = (Select Sum(Debit-Credit)from @XML)                        
 IF (@S <> 0)                        
 BEGIN                        
 insert into @XML (Voucher, Product /*Code new */, A_SDate, A_MO, Bank, BIType, Area, HSCode, RCCOde /*CT new*/, Branch, Remarks, Date, DocNo, RefNo, GL_Code /*Account new*/, Description, Currency, Debit_OC, Credit_OC, Debit, Credit, Rate,Original_CurrencyF)                         
  Values ('','','','','','','','','','','Selisih Rounding',@P_PDate,'','','1505040000022','SELISIH ROUNDING','IDR',Case when @S<0 then -@s else 0 end,Case when @S>0 then @s else 0 end,Case when @S<0 then -@s else 0 end,Case when @S>0 then @s else 0 end,'1',1 
)                        
 END    
Select  ROW_NUMBER() OVER (ORDER BY ValueDate) AS CurrentNumber, *  into #a      
from (          
 select Branch as BranchCode,  '' BatchNumber, Branch as AccountBranch, GL_Code as AccountNumber, Currency, 
 --debit_OC+credit_OC as Amount, debit+Credit as LocalCurrencyAmount,  
 debit_OC as Amount, debit as LocalCurrencyAmount, 
 CONVERT(CHAR(8), Date, 112) as ValueDate, 
 --case when Debit_oc - Credit_OC > 0 then 'D' else 'C' end as  DebitOrCreditIndicator,   
 'D' as DebitOrCreditIndicator,
 --Case When Debit_OC<>0 then Debit/Debit_OC when Credit_OC<>0 then Credit/Credit_OC else 1 end as ExchangeRate, 
 case when Currency='IDR' then '1' else debit/debit_OC end as ExchangeRate,
 'MSC' TransactionCode, Description as Additionaltext, 'YEAR'+cast(Year(date) as Varchar) as FinancialCycle, 'M'+Cast(FORMAT(date, 'MM') as Varchar) as PeriodCode, '' RelatedCustomer, '' MISGroup, 'CARE' SourceCode, A_MO as  CompositeMIS1,  right(rccode,5) CompositeMIS2, Product as   CompositeMIS3, '' CompositeMIS4, '9999'CompositeMIS5, '0000' CompositeMIS6, '9999' CompositeMIS7, 'PJA' CompositeMIS8,
--left(rccode,3) CompositeMIS8, 
HSCode as CompositeMIS9,'' CompositeMIS10,   
-- Debit, Credit, Debit_OC, Credit_OC,   
 '' TRANSACTIONMIS1, '' TRANSACTIONMIS2, '' TRANSACTIONMIS3,'' TRANSACTIONMIS4,'' TRANSACTIONMIS5,'' TRANSACTIONMIS6,'' TRANSACTIONMIS7,'' TRANSACTIONMIS8,'' TRANSACTIONMIS9,'' TRANSACTIONMIS10,'' FUNDMIS1,'' FUNDMIS2,'' FUNDMIS3,'' FUNDMIS4,'' FUNDMIS5,'' FUNDMIS6,'' FUNDMIS7,'' FUNDMIS8,'' FUNDMIS9,'' FUNDMIS10 ,'' FUNDMIS11
 from @XML   WHERE DEBIT_oc <> 0  
 union all         
 select  Branch as BranchCode,  '' BatchNumber, Branch as AccountBranch, GL_Code as AccountNumber, Currency, 
 --debit_OC+credit_OC as Amount, debit+Credit as LocalCurrencyAmount,
 credit_OC as  Amount, credit as LocalCurrencyAmount,
 CONVERT(CHAR(8), Date, 112) as ValueDate, 
 --case when Debit_oc - Credit_OC < 0 then 'C' else 'D' end as DebitOrCreditIndicator,  
 'C' as DebitOrCreditIndicator,
 --Case When Debit_OC<>0 then Debit/Debit_OC when Credit_OC<>0 then Credit/Credit_OC else 1 end as ExchangeRate, 
 case when Currency='IDR' then '1' else Credit/Credit_OC end as ExchangeRate,
 'MSC' TransactionCode, Description as Additionaltext, 'YEAR'+cast(Year(date) as Varchar) as FinancialCycle, 'M'+Cast(FORMAT(date, 'MM') as Varchar) as PeriodCode, '' RelatedCustomer, '' MISGroup, 'CARE' SourceCode, A_MO as  CompositeMIS1,  right(rccode,5) CompositeMIS2, PRODUCT  as   CompositeMIS3, '' CompositeMIS4, '9999'CompositeMIS5, '0000' CompositeMIS6, '9999' CompositeMIS7, 'PJA' CompositeMIS8,
 --left(rccode,3) CompositeMIS8,
 HSCode as CompositeMIS9,'' CompositeMIS10,  
 --Debit, Credit, Debit_OC, Credit_OC,  
 '' TRANSACTIONMIS1, '' TRANSACTIONMIS2, '' TRANSACTIONMIS3,'' TRANSACTIONMIS4,'' TRANSACTIONMIS5,'' TRANSACTIONMIS6,'' TRANSACTIONMIS7,'' TRANSACTIONMIS8,'' TRANSACTIONMIS9,'' TRANSACTIONMIS10,'' FUNDMIS1,'' FUNDMIS2,'' FUNDMIS3,'' FUNDMIS4,'' FUNDMIS5,'' FUNDMIS6,'' FUNDMIS7,'' FUNDMIS8,'' FUNDMIS9,'' FUNDMIS10,'' FUNDMIS11
 from @XML     
 WHERE CREDIT_oc <> 0  
 ) R 
 where   
 ----Debit + Credit <> 0 and Debit_OC + Credit_OC <> 0 and  
 AccountNumber <> '1505040000022'   --and ValueDate=CONVERT(CHAR(8), @P_PDate, 112)
 order by  BranchCode,currentNumber,  ValueDate 
 SELECT MAX(CurrentNumber)+1 CurrentNumber, BranchCode, '' BatchNumber, AccountBranch, '1505040000022' AccountNumber, 'IDR' Currency, abs(sum(case when DebitOrCreditIndicator='C' then -LocalCurrencyAmount else LocalCurrencyAmount end)) as Amount , abs(sum(case when DebitOrCreditIndicator='C' then -LocalCurrencyAmount else LocalCurrencyAmount end)) as LocalCurrencyAmount, CONVERT(CHAR(8), @P_PDate, 112) as ValueDate,  case when sum(case when DebitOrCreditIndicator='C' then -LocalCurrencyAmount else LocalCurrencyAmount end) <0 then 'D' else 'C' end as DebitOrCreditIndicator, '1' ExchangeRate, 'MSC' TransactionCode, 'SELISIH ROUNDING' Additionaltext, 'YEAR'+cast(Year(@P_pdate) as Varchar) as FinancialCycle, 'M'+Cast(FORMAT(@P_PDate, 'MM') as Varchar) as  PeriodCode, '' RelatedCustomer, '' MISGroup, 'CARE' SourceCode, '8888' CompositeMIS1,  '9999' CompositeMIS2, '0000' ComppositeMIS3, '' CompositeMIS4, '0000' CompositeMIS5, '00000' CompositeMIS6, '99999' CompositeMIS7, 'PJA' CompositeMIS8,'1150' CompositeMIS9,'' CompositeMIS10, ''TRANSACTIONMIS1, ''TRANSACTIONMIS2, ''TRANSACTIONMIS3 ,''TRANSACTIONMIS4, ''TRANSACTIONMIS5, ''TRANSACTIONMIS6,''TRANSACTIONMIS7, ''TRANSACTIONMIS8, ''TRANSACTIONMIS9 ,'' TRANSACTIONMIS10, ''FUNDMIS1, ''FUNDMIS2, ''FUNDMIS3, ''FUNDMIS4, ''FUNDMIS5, ''FUNDMIS6, ''FUNDMIS7, ''FUNDMIS8, ''FUNDMIS9, ''FUNDMIS10, '' FUNDMIS11  into #B from #A
group by #a.BranchCode, #a.AccountBranch
--select * from #a
--select * from #b
select Z.* from(
select * from #a
union all
select * from #b) Z
where amount <> 0
order by Branchcode, z.CurrentNumber
drop table #a
drop table #b
drop table #Z