IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QAccFD]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QAccFD] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCDOCLIST]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QCDOCLIST] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCheckObjectClaimed]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QCheckObjectClaimed] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCheckObjectService]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QCheckObjectService] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCheckObjectValuation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QCheckObjectValuation] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCLACC_5]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QCLACC_5] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCLAIMAMOUNT]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QCLAIMAMOUNT] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QClaimInfo_Data]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QClaimInfo_Data] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCLFACDED]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QCLFACDED] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCLFD]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QCLFD] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCLSAL]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QCLSAL] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCLSUB]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QCLSUB] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QComAcc]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QComAcc] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QGenDTab]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QGenDTab] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QInParty]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QInParty] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QInterest_Data]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QInterest_Data] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[qInwardTreaty_Data]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[qInwardTreaty_Data] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QProAcc]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QProAcc] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QSurveyor]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QSurveyor] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QTREATYACC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QTREATYACC] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[SP_PopulateTCData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[SP_PopulateTCData] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[View03]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[View03] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[View05L1]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[View05L1] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[View05L2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[View05L2] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[View05L3]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[View05L3] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[View07]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[View07] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[View07A]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[View07A] END 
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QDetail_PCalc]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[QDetail_PCalc] END
go
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_ALL_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_COMM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_ALL_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_COMM_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_ALL_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_COMM_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_ALL_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_GROSS_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_ALL_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_GROSS_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_ALL_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_GROSS_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_ALL_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_NET_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_ALL_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_NET_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_ALL_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_NET_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_HOLD_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_COMM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_HOLD_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_COMM_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_HOLD_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_COMM_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_HOLD_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_GROSS_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_HOLD_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_GROSS_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_HOLD_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_GROSS_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_HOLD_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_NET_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_HOLD_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_NET_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_HOLD_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_NET_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_NOT_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_COMM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_NOT_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_COMM_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_NOT_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_COMM_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_NOT_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_GROSS_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_NOT_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_GROSS_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_NOT_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_GROSS_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_NOT_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_NET_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_NOT_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_NET_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_NOT_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_NET_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_PERIOD_DUE_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_PERIOD_DUE_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_PERIOD_DUE_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_UNPAID_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_COMM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_UNPAID_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_COMM_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_UNPAID_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_COMM_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_UNPAID_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_GROSS_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_UNPAID_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_GROSS_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_UNPAID_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_GROSS_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_UNPAID_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_NET_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_UNPAID_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_NET_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_A_COLLECT_UNPAID_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_NET_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_C_COLLECT_ALL_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_C_COLLECT_ALL_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_C_COLLECT_ALL_BPPDAN]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_C_COLLECT_ALL_BPPDAN] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_C_COLLECT_ALL_FACULTATIVE]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_C_COLLECT_ALL_FACULTATIVE] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_C_COLLECT_ALL_MAIPARK]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_C_COLLECT_ALL_MAIPARK] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_C_COLLECT_ALL_SALVAGE]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_C_COLLECT_ALL_SALVAGE] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_C_COLLECT_ALL_SUBROGATION]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_C_COLLECT_ALL_SUBROGATION] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_C_COLLECT_ALL_TREATY]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_C_COLLECT_ALL_TREATY] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_C_COLLECT_ALL_TREATY_XOL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_C_COLLECT_ALL_TREATY_XOL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_D_COLLECT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_D_COLLECT] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_ALL_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_COMM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_ALL_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_COMM_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_ALL_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_COMM_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_ALL_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_GROSS_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_ALL_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_GROSS_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_ALL_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_GROSS_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_ALL_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_NET_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_ALL_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_NET_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_ALL_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_NET_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_HOLD_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_COMM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_HOLD_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_COMM_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_HOLD_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_COMM_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_HOLD_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_GROSS_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_HOLD_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_GROSS_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_HOLD_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_GROSS_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_HOLD_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_NET_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_HOLD_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_NET_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_HOLD_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_NET_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_NOT_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_COMM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_NOT_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_COMM_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_NOT_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_COMM_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_NOT_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_GROSS_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_NOT_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_GROSS_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_NOT_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_GROSS_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_NOT_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_NET_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_NOT_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_NET_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_NOT_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_NET_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_PERIOD_DUE_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_PERIOD_DUE_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_PERIOD_DUE_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_UNPAID_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_COMM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_UNPAID_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_COMM_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_UNPAID_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_COMM_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_UNPAID_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_GROSS_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_UNPAID_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_GROSS_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_UNPAID_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_GROSS_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_UNPAID_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_NET_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_UNPAID_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_NET_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_F_COLLECT_UNPAID_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_NET_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_ALL_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_COMM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_ALL_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_COMM_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_ALL_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_COMM_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_ALL_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_GROSS_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_ALL_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_GROSS_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_ALL_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_GROSS_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_ALL_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_NET_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_ALL_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_NET_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_ALL_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_NET_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_HOLD_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_COMM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_HOLD_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_COMM_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_HOLD_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_COMM_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_HOLD_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_GROSS_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_HOLD_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_GROSS_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_HOLD_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_GROSS_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_HOLD_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_NET_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_HOLD_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_NET_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_HOLD_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_NET_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_NOT_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_COMM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_NOT_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_COMM_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_NOT_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_COMM_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_NOT_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_GROSS_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_NOT_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_GROSS_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_NOT_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_GROSS_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_NOT_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_NET_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_NOT_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_NET_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_NOT_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_NET_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_PERIOD_DUE_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_PERIOD_DUE_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_PERIOD_DUE_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_UNPAID_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_COMM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_UNPAID_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_COMM_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_UNPAID_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_COMM_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_UNPAID_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_GROSS_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_UNPAID_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_GROSS_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_UNPAID_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_GROSS_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_UNPAID_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_NET_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_UNPAID_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_NET_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_UNPAID_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_NET_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_ALL_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_COMM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_ALL_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_COMM_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_ALL_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_COMM_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_ALL_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_GROSS_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_ALL_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_GROSS_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_ALL_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_GROSS_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_ALL_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_NET_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_ALL_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_NET_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_ALL_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_NET_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_HOLD_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_HOLD_COMM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_HOLD_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_HOLD_COMM_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_HOLD_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_HOLD_COMM_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_HOLD_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_HOLD_GROSS_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_HOLD_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_HOLD_GROSS_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_HOLD_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_HOLD_GROSS_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_HOLD_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_HOLD_NET_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_HOLD_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_HOLD_NET_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_HOLD_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_HOLD_NET_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_NOT_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_NOT_COMM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_NOT_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_NOT_COMM_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_NOT_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_NOT_COMM_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_NOT_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_NOT_GROSS_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_NOT_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_NOT_GROSS_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_NOT_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_NOT_GROSS_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_NOT_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_NOT_NET_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_NOT_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_NOT_NET_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_NOT_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_NOT_NET_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_PERIOD_DUE_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_PERIOD_DUE_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_PERIOD_DUE_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_UNPAID_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_UNPAID_COMM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_UNPAID_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_UNPAID_COMM_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_UNPAID_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_UNPAID_COMM_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_UNPAID_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_UNPAID_GROSS_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_UNPAID_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_UNPAID_GROSS_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_UNPAID_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_UNPAID_GROSS_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_UNPAID_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_UNPAID_NET_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_UNPAID_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_UNPAID_NET_END] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_UNPAID_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_UNPAID_NET_NEW] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_U_COLLECT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CL_U_COLLECT] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CLLISTQRY]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[CLLISTQRY] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_F_DISBURSE_ALL_CLAIM_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_F_DISBURSE_ALL_CLAIM_CLAIMANT] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_F_DISBURSE_ALL_EXCESSREFUND_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_F_DISBURSE_ALL_EXCESSREFUND_CLAIMANT] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_F_DISBURSE_HOLD_CLAIM_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_F_DISBURSE_HOLD_CLAIM_CLAIMANT] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_F_DISBURSE_HOLD_EXCESSREFUND_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_F_DISBURSE_HOLD_EXCESSREFUND_CLAIMANT] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_F_DISBURSE_NOT_CLAIM_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_F_DISBURSE_NOT_CLAIM_CLAIMANT] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_F_DISBURSE_NOT_EXCESSREFUND_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_F_DISBURSE_NOT_EXCESSREFUND_CLAIMANT] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_F_DISBURSE_UNPAID_CLAIM_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_F_DISBURSE_UNPAID_CLAIM_CLAIMANT] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_F_DISBURSE_UNPAID_EXCESSREFUND_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_F_DISBURSE_UNPAID_EXCESSREFUND_CLAIMANT] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_I_DISBURSE_ALL_CLAIM_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_ALL_CLAIM_CLAIMANT] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_I_DISBURSE_ALL_CLAIM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_ALL_CLAIM_ID] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_I_DISBURSE_ALL_EXCESSREFUND_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_ALL_EXCESSREFUND_CLAIMANT] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_I_DISBURSE_ALL_EXCESSREFUND_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_ALL_EXCESSREFUND_ID] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_I_DISBURSE_HOLD_CLAIM_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_HOLD_CLAIM_CLAIMANT] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_I_DISBURSE_HOLD_CLAIM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_HOLD_CLAIM_ID] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_I_DISBURSE_HOLD_EXCESSREFUND_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_HOLD_EXCESSREFUND_CLAIMANT] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_I_DISBURSE_HOLD_EXCESSREFUND_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_HOLD_EXCESSREFUND_ID] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_I_DISBURSE_NOT_CLAIM_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_NOT_CLAIM_CLAIMANT] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_I_DISBURSE_NOT_CLAIM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_NOT_CLAIM_ID] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_I_DISBURSE_NOT_EXCESSREFUND_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_NOT_EXCESSREFUND_CLAIMANT] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_I_DISBURSE_NOT_EXCESSREFUND_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_NOT_EXCESSREFUND_ID] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_I_DISBURSE_UNPAID_CLAIM_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_UNPAID_CLAIM_CLAIMANT] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_I_DISBURSE_UNPAID_CLAIM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_UNPAID_CLAIM_ID] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_I_DISBURSE_UNPAID_EXCESSREFUND_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_UNPAID_EXCESSREFUND_CLAIMANT] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_I_DISBURSE_UNPAID_EXCESSREFUND_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_UNPAID_EXCESSREFUND_ID] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_ALL_ALL_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_ALL_ALL_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_ALL_ALL_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_ALL_ALL_ID] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_ALL_CLAIM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_ALL_CLAIM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_ALL_CLAIM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_ALL_CLAIM_ID] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_ALL_PREMIUM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_ALL_PREMIUM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_ALL_PREMIUM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_ALL_PREMIUM_ID] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_HOLD_ALL_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_HOLD_ALL_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_HOLD_ALL_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_HOLD_ALL_ID] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_HOLD_CLAIM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_HOLD_CLAIM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_HOLD_CLAIM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_HOLD_CLAIM_ID] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_HOLD_PREMIUM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_HOLD_PREMIUM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_HOLD_PREMIUM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_HOLD_PREMIUM_ID] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_NOT_ALL_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_NOT_ALL_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_NOT_ALL_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_NOT_ALL_ID] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_NOT_CLAIM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_NOT_CLAIM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_NOT_CLAIM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_NOT_CLAIM_ID] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_NOT_PREMIUM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_NOT_PREMIUM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_NOT_PREMIUM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_NOT_PREMIUM_ID] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_PERIOD_DUE_ALL_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_PERIOD_DUE_ALL_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_PERIOD_DUE_ALL_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_PERIOD_DUE_ALL_ID] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_PERIOD_DUE_CLAIM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_PERIOD_DUE_CLAIM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_PERIOD_DUE_CLAIM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_PERIOD_DUE_CLAIM_ID] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_PERIOD_DUE_PREMIUM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_PERIOD_DUE_PREMIUM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_PERIOD_DUE_PREMIUM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_PERIOD_DUE_PREMIUM_ID] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_UNPAID_ALL_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_UNPAID_ALL_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_UNPAID_ALL_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_UNPAID_ALL_ID] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_UNPAID_CLAIM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_UNPAID_CLAIM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_UNPAID_CLAIM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_UNPAID_CLAIM_ID] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_UNPAID_PREMIUM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_UNPAID_PREMIUM_ALL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DB_R_DISBURSE_UNPAID_PREMIUM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_UNPAID_PREMIUM_ID] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FL_SL_ACCOUNT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[FL_SL_ACCOUNT] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FL_SL_Budget_Account_Actual]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[FL_SL_Budget_Account_Actual] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FL_SL_COMACC]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[FL_SL_COMACC] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_CF_Budget]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[fn_CF_Budget] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_CT_Budget]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[fn_CT_Budget] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_Exchange]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[fn_Exchange] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GL_Budget]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[fn_GL_Budget] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FN_ONECARD]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[FN_ONECARD] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FN_UserMO]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[FN_UserMO] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Get_Claim_APRule]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Get_Claim_APRule] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Get_Open_Item]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Get_Open_Item] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Get_Open_Item_Hint]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Get_Open_Item_Hint] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Get_Open_Item_Hint_I]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Get_Open_Item_Hint_I] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Get_Open_Item_Hint_M]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Get_Open_Item_Hint_M] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Get_Open_Item_Hint_N]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Get_Open_Item_Hint_N] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Get_Open_Item_Hint_P]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Get_Open_Item_Hint_P] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Get_Open_Item_Hint_T]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Get_Open_Item_Hint_T] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Get_Open_Item_I]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Get_Open_Item_I] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Get_Open_Item_M]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Get_Open_Item_M] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Get_Open_Item_N]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Get_Open_Item_N] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Get_Open_Item_P]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Get_Open_Item_P] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Get_Open_Item_T]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Get_Open_Item_T] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Get_Policy_APRule]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Get_Policy_APRule] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_1]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[ListQry_1] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_1_a]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[ListQry_1_a] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_1b]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[ListQry_1b] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_1b_a]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[ListQry_1b_a] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_3]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[ListQry_3] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_3_A]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[ListQry_3_A] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_3b]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[ListQry_3b] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_3b_a]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[ListQry_3b_a] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MListQry_1]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[MListQry_1] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MListQry_1b]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[MListQry_1b] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MListQry_3]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[MListQry_3] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MListQry_3_a]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[MListQry_3_a] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MListQry_3b]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[MListQry_3b] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OPEN_ITEM_ALLOCATED]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[OPEN_ITEM_ALLOCATED] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Open_Item_Voucher]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Open_Item_Voucher] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Open_Item_Voucher_N]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Open_Item_Voucher_N] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Open_Item_Voucher_P]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Open_Item_Voucher_P] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OS_SUSPEND]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[OS_SUSPEND] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OS_VOUCHER]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[OS_VOUCHER] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OS_VOUCHER_I]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[OS_VOUCHER_I] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OS_VOUCHER_M]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[OS_VOUCHER_M] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OS_VOUCHER_N]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[OS_VOUCHER_N] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OS_VOUCHER_P]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[OS_VOUCHER_P] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OS_VOUCHER_T]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[OS_VOUCHER_T] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[oSL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[oSL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OVOUCHER]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[OVOUCHER] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QACCUMULATION_CONTROL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[QACCUMULATION_CONTROL] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QCLAIM_CCALC]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[QCLAIM_CCALC] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R_SL_ALLOCATED_BY_VOUCHER]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[R_SL_ALLOCATED_BY_VOUCHER] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SL_ALLOCATED]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[SL_ALLOCATED] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SL_PAYMENT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[SL_PAYMENT] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SListQry]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[SListQry] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SListSR_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[SListSR_Det] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SMListSR_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[SMListSR_Det] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VOUCHER_AMOUNTDUE]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[VOUCHER_AMOUNTDUE] END


GO

CREATE FUNCTION [dbo].[QDetail_PCalc]() 
RETURNS Table 
AS RETURN ( 
SELECT  PCALC.ANO, 
sum(PCalc.TSI*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS TSI, 
sum(PCalc.OurShare*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS OurShare, 
sum(PCalc.Gross*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Gross 
FROM  PCALC INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=PCALC.ANO) 
GROUP BY PCALC.ANO 
) 
 


GO

CREATE function [dbo].[CL_A_COLLECT_ALL_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Premium'  
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
)  

GO

CREATE function [dbo].[CL_A_COLLECT_ALL_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.AdmNo=AccAss.AdmNo  
and Acceptance.AType in ('E','C')  
and Acceptance.ANO=AccAss.ANO   
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
)  

GO

CREATE function [dbo].[CL_A_COLLECT_ALL_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.AdmNo=AccAss.AdmNo  
and Acceptance.AType='N'  
and Acceptance.ANO=AccAss.ANO   
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
)  

GO

CREATE function [dbo].[CL_A_COLLECT_ALL_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('DI','IC','CF','JP','SO')  
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Premium'  
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
)  

GO

CREATE function [dbo].[CL_A_COLLECT_ALL_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('DI','IC','CF','JP','SO')  
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.AdmNo=AccAss.AdmNo  
and Acceptance.AType in ('E','C')  
and Acceptance.ANO=AccAss.ANO   
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
)  

GO

CREATE function [dbo].[CL_A_COLLECT_ALL_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('DI','IC','CF','JP','SO')  
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.AdmNo=AccAss.AdmNo  
and Acceptance.AType='N'  
and Acceptance.ANO=AccAss.ANO   
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
)  

GO

CREATE function [dbo].[CL_A_COLLECT_ALL_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Premium'  
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
)  
GO
CREATE function [dbo].[CL_A_COLLECT_ALL_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.AdmNo=AccAss.AdmNo  
and Acceptance.AType in ('E','C')  
and Acceptance.ANO=AccAss.ANO   
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
)  
GO
CREATE function [dbo].[CL_A_COLLECT_ALL_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.AdmNo=AccAss.AdmNo  
and Acceptance.AType='N'  
and Acceptance.ANO=AccAss.ANO   
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
)  
GO 
CREATE function [dbo].[CL_A_COLLECT_HOLD_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO
CREATE function [dbo].[CL_A_COLLECT_HOLD_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO
CREATE function [dbo].[CL_A_COLLECT_HOLD_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO
CREATE function [dbo].[CL_A_COLLECT_HOLD_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO
CREATE function [dbo].[CL_A_COLLECT_HOLD_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO
CREATE function [dbo].[CL_A_COLLECT_HOLD_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO
CREATE function [dbo].[CL_A_COLLECT_HOLD_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO
CREATE function [dbo].[CL_A_COLLECT_HOLD_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO
CREATE function [dbo].[CL_A_COLLECT_HOLD_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO
CREATE function [dbo].[CL_A_COLLECT_NOT_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_A_COLLECT_NOT_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_A_COLLECT_NOT_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO 
CREATE function [dbo].[CL_A_COLLECT_NOT_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_A_COLLECT_NOT_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_A_COLLECT_NOT_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_A_COLLECT_NOT_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_A_COLLECT_NOT_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_A_COLLECT_NOT_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal, AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Premium'  
)  
GO
Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)
GO
Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)
GO
Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
)
GO
Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)
GO
Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)
GO
Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal, AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Premium'  
)  
GO
Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)
GO
Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)
GO
CREATE function [dbo].[CL_A_COLLECT_UNPAID_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_A_COLLECT_UNPAID_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_A_COLLECT_UNPAID_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO 
CREATE function [dbo].[CL_A_COLLECT_UNPAID_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_A_COLLECT_UNPAID_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_A_COLLECT_UNPAID_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO 
CREATE function [dbo].[CL_A_COLLECT_UNPAID_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_A_COLLECT_UNPAID_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_A_COLLECT_UNPAID_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_C_COLLECT_ALL_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and ((Admlink.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP')) or (Admlink.Type in ('OP') and Admlink.Amount_8+Admlink.Amount_10<>0))
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Claim'  
and Profile.ID Like @P_ID+'%'  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
)  
GO
CREATE function [dbo].[CL_C_COLLECT_ALL_BPPDAN] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('CP')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_C_COLLECT_ALL_FACULTATIVE] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('FO')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_C_COLLECT_ALL_MAIPARK] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('XP')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_C_COLLECT_ALL_SALVAGE] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))      
RETURNS TABLE      
AS RETURN      
(      
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,       
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,      
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code      
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink      
where  Voucher.Voucher=AdmLink.Voucher       
and ProAcc.ProAcc=Voucher.ProAcc       
and ProAcc.[ID]=[Profile].[ID]       
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) --Salvage/Excess    
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate      
and Admlink.Voucher=Voucher.Voucher      
and Admlink.Subject='Claim'      
and Profile.ID Like @P_ID+'%'      
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)       
)      
GO
CREATE function [dbo].[CL_C_COLLECT_ALL_SUBROGATION] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('OP') and Admlink.Amount_10<>0	--Subrogation
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Claim'  
and Profile.ID Like @P_ID+'%'  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
)  
GO
CREATE function [dbo].[CL_C_COLLECT_ALL_TREATY] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DC','QS','QP','S1','S2','S3','AF','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_C_COLLECT_ALL_TREATY_XOL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function CL_D_COLLECT(@P_CollNo as varchar(50)) 
RETURNS TABLE 
AS RETURN 
( 
Select C1.RefNo as NoGrouping, Admlink.A_PolicyNo as NoPolis, Admlink.RefNo as NoKontrak, C2.Amount, (Select Count(*) from CollectionV Where CollNo=@P_CollNo) as JumlahKontrak, C3.TAmount as TotalAmount 
from CollectionH C1, CollectionV C2, CollAmount C3, Admlink 
Where C2.CollNo=C1.CollNo and C3.CollNo=C1.CollNo and C3.Currency=C2.Currency and Admlink.Voucher=C2.Voucher 
and C1.CollNo=@P_CollNo 
) 
GO 
CREATE function [dbo].[CL_F_COLLECT_ALL_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  V.RefNo, V.Voucher,A.Type, A.Date, A.Subject, V.DocNo, V.StatID, V.ActionBy, V.ActionDate, V.AcceptedBy, V.AcceptedDate, 
V.[Currency],  V.Installment, 
Case When V.Installment=0 then dateadd(day, A.WPC,V.DueDate)    
When V.Payment_CC<=V.AmountDue_1 then V.DueDate_1    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2 then V.DueDate_2    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11    
Else V.DueDate_12    
end as DueDate, 
(Case When V.Installment=0 and dateadd(day,A.WPC,V.DueDate) <=@P_EDate Then V.Nominal_CC-V.Diff_CC else 0 end+    
Case When V.Installment>=1 and V.DueDate_1 <=@P_EDate Then V.AmountDue_1 else 0 end+    
Case When V.Installment>=2 and V.DueDate_2 <=@P_EDate Then V.AmountDue_2 else 0 end+    
Case When V.Installment>=3 and V.DueDate_3 <=@P_EDate Then V.AmountDue_3 else 0 end+    
Case When V.Installment>=4 and V.DueDate_4 <=@P_EDate Then V.AmountDue_4 else 0 end+    
Case When V.Installment>=5 and V.DueDate_5 <=@P_EDate Then V.AmountDue_5 else 0 end+    
Case When V.Installment>=6 and V.DueDate_6 <=@P_EDate Then V.AmountDue_6 else 0 end+    
Case When V.Installment>=7 and V.DueDate_7 <=@P_EDate Then V.AmountDue_7 else 0 end+    
Case When V.Installment>=8 and V.DueDate_8 <=@P_EDate Then V.AmountDue_8 else 0 end+    
Case When V.Installment>=9 and V.DueDate_9 <=@P_EDate Then V.AmountDue_9 else 0 end+    
Case When V.Installment>=10 and V.DueDate_10 <=@P_EDate Then V.AmountDue_10 else 0 end+    
Case When V.Installment>=11 and V.DueDate_11 <=@P_EDate Then V.AmountDue_11 else 0 end+    
Case When V.Installment>=12 and V.DueDate_12 <=@P_EDate Then V.AmountDue_12 else 0 end)-V.Payment_CC-V.Payment_OC as Nominal,  
A.Remarks+
(Case When V.Installment<>0 then ' Installment No. ' else '' end+    
Case When V.Installment>=1 and V.DueDate_1 <=@P_EDate and V.Payment_CC<=V.AmountDue_1 Then '1 ' else '' end+    
Case When V.Installment>=2 and V.DueDate_2 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+    
Case When V.Installment>=3 and V.DueDate_3 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+    
Case When V.Installment>=4 and V.DueDate_4 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+    
Case When V.Installment>=5 and V.DueDate_5 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+    
Case When V.Installment>=6 and V.DueDate_6 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+    
Case When V.Installment>=7 and V.DueDate_7 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+    
Case When V.Installment>=8 and V.DueDate_8 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+    
Case When V.Installment>=9 and V.DueDate_9 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+    
Case When V.Installment>=10 and V.DueDate_10 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  Then '10 ' else '' end+    
Case When V.Installment>=11 and V.DueDate_11 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+          
Case When V.Installment>=12 and V.DueDate_12 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' Else '' end+    
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as AName,    
Profile.Name, V.debtorF,V.CreditorF,A.BatchNo, A.RefType,V.Branch, A.Code
from Profile, nVoucher V, AdmLink A
where  V.Voucher=A.Voucher and Profile.ID=A.ID
and A.Type in ('BB','BA','BO')
and A.ISType in ('I','L','C') and A.Subject='Premium'  
and V.Date<=@P_EDate and ((V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC)<>0 or V.PDate>=@P_EDate)    --Aging Condition
and 
Round((Case When V.Installment=0 and dateadd(day,A.WPC,V.DueDate) <=@P_EDate Then V.Nominal_CC-V.Diff_CC else 0 end+    
Case When V.Installment>=1 and V.DueDate_1 <=@P_EDate Then V.AmountDue_1 else 0 end+    
Case When V.Installment>=2 and V.DueDate_2 <=@P_EDate Then V.AmountDue_2 else 0 end+    
Case When V.Installment>=3 and V.DueDate_3 <=@P_EDate Then V.AmountDue_3 else 0 end+    
Case When V.Installment>=4 and V.DueDate_4 <=@P_EDate Then V.AmountDue_4 else 0 end+    
Case When V.Installment>=5 and V.DueDate_5 <=@P_EDate Then V.AmountDue_5 else 0 end+    
Case When V.Installment>=6 and V.DueDate_6 <=@P_EDate Then V.AmountDue_6 else 0 end+    
Case When V.Installment>=7 and V.DueDate_7 <=@P_EDate Then V.AmountDue_7 else 0 end+    
Case When V.Installment>=8 and V.DueDate_8 <=@P_EDate Then V.AmountDue_8 else 0 end+    
Case When V.Installment>=9 and V.DueDate_9 <=@P_EDate Then V.AmountDue_9 else 0 end+    
Case When V.Installment>=10 and V.DueDate_10 <=@P_EDate Then V.AmountDue_10 else 0 end+    
Case When V.Installment>=11 and V.DueDate_11 <=@P_EDate Then V.AmountDue_11 else 0 end+    
Case When V.Installment>=12 and V.DueDate_12 <=@P_EDate Then V.AmountDue_12 else 0 end)-V.Payment_CC-V.Payment_OC,2)>0
and 
Case When V.Installment=0 then dateadd(day, A.WPC,V.DueDate)    
When V.Payment_CC<=V.AmountDue_1 then V.DueDate_1    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2 then V.DueDate_2    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11    
Else V.DueDate_12    
end between @P_SDate and @P_EDate    
and Profile.ID Like @P_ID+'%'  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=V.Voucher)   
)  
GO
CREATE function [dbo].[CL_F_COLLECT_ALL_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_F_COLLECT_ALL_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_F_COLLECT_ALL_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  V.RefNo, V.Voucher,A.Type, A.Date, A.Subject, V.DocNo, V.StatID, V.ActionBy, V.ActionDate, V.AcceptedBy, V.AcceptedDate, 
V.[Currency],  V.Installment, 
Case When V.Installment=0 then dateadd(day, A.WPC,V.DueDate)    
When V.Payment_CC<=V.AmountDue_1 then V.DueDate_1    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2 then V.DueDate_2    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11    
Else V.DueDate_12    
end as DueDate, 
(Case When V.Installment=0 and dateadd(day,A.WPC,V.DueDate) <=@P_EDate Then V.Nominal_CC-V.Diff_CC else 0 end+    
Case When V.Installment>=1 and V.DueDate_1 <=@P_EDate Then V.AmountDue_1 else 0 end+    
Case When V.Installment>=2 and V.DueDate_2 <=@P_EDate Then V.AmountDue_2 else 0 end+    
Case When V.Installment>=3 and V.DueDate_3 <=@P_EDate Then V.AmountDue_3 else 0 end+    
Case When V.Installment>=4 and V.DueDate_4 <=@P_EDate Then V.AmountDue_4 else 0 end+    
Case When V.Installment>=5 and V.DueDate_5 <=@P_EDate Then V.AmountDue_5 else 0 end+    
Case When V.Installment>=6 and V.DueDate_6 <=@P_EDate Then V.AmountDue_6 else 0 end+    
Case When V.Installment>=7 and V.DueDate_7 <=@P_EDate Then V.AmountDue_7 else 0 end+    
Case When V.Installment>=8 and V.DueDate_8 <=@P_EDate Then V.AmountDue_8 else 0 end+    
Case When V.Installment>=9 and V.DueDate_9 <=@P_EDate Then V.AmountDue_9 else 0 end+    
Case When V.Installment>=10 and V.DueDate_10 <=@P_EDate Then V.AmountDue_10 else 0 end+    
Case When V.Installment>=11 and V.DueDate_11 <=@P_EDate Then V.AmountDue_11 else 0 end+    
Case When V.Installment>=12 and V.DueDate_12 <=@P_EDate Then V.AmountDue_12 else 0 end)-V.Payment_CC-V.Payment_OC as Nominal,  
A.Remarks+
(Case When V.Installment<>0 then ' Installment No. ' else '' end+    
Case When V.Installment>=1 and V.DueDate_1 <=@P_EDate and V.Payment_CC<=V.AmountDue_1 Then '1 ' else '' end+    
Case When V.Installment>=2 and V.DueDate_2 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+    
Case When V.Installment>=3 and V.DueDate_3 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+    
Case When V.Installment>=4 and V.DueDate_4 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+    
Case When V.Installment>=5 and V.DueDate_5 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+    
Case When V.Installment>=6 and V.DueDate_6 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+    
Case When V.Installment>=7 and V.DueDate_7 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+    
Case When V.Installment>=8 and V.DueDate_8 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+    
Case When V.Installment>=9 and V.DueDate_9 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+    
Case When V.Installment>=10 and V.DueDate_10 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  Then '10 ' else '' end+    
Case When V.Installment>=11 and V.DueDate_11 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+          
Case When V.Installment>=12 and V.DueDate_12 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' Else '' end+    
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as AName,    
Profile.Name, V.debtorF,V.CreditorF,A.BatchNo, A.RefType,V.Branch, A.Code
from Profile, nVoucher V, AdmLink A
where  V.Voucher=A.Voucher and Profile.ID=A.ID
and A.Type in ('DI','IC','CF','JP','SO') and A.ISType in ('I','L','C') and A.Subject='Premium'  
and V.Date<=@P_EDate and ((V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC)<>0 or V.PDate>=@P_EDate)    --Aging Condition
and 
Round((Case When V.Installment=0 and dateadd(day,A.WPC,V.DueDate) <=@P_EDate Then V.Nominal_CC-V.Diff_CC else 0 end+    
Case When V.Installment>=1 and V.DueDate_1 <=@P_EDate Then V.AmountDue_1 else 0 end+    
Case When V.Installment>=2 and V.DueDate_2 <=@P_EDate Then V.AmountDue_2 else 0 end+    
Case When V.Installment>=3 and V.DueDate_3 <=@P_EDate Then V.AmountDue_3 else 0 end+    
Case When V.Installment>=4 and V.DueDate_4 <=@P_EDate Then V.AmountDue_4 else 0 end+    
Case When V.Installment>=5 and V.DueDate_5 <=@P_EDate Then V.AmountDue_5 else 0 end+    
Case When V.Installment>=6 and V.DueDate_6 <=@P_EDate Then V.AmountDue_6 else 0 end+    
Case When V.Installment>=7 and V.DueDate_7 <=@P_EDate Then V.AmountDue_7 else 0 end+    
Case When V.Installment>=8 and V.DueDate_8 <=@P_EDate Then V.AmountDue_8 else 0 end+    
Case When V.Installment>=9 and V.DueDate_9 <=@P_EDate Then V.AmountDue_9 else 0 end+    
Case When V.Installment>=10 and V.DueDate_10 <=@P_EDate Then V.AmountDue_10 else 0 end+    
Case When V.Installment>=11 and V.DueDate_11 <=@P_EDate Then V.AmountDue_11 else 0 end+    
Case When V.Installment>=12 and V.DueDate_12 <=@P_EDate Then V.AmountDue_12 else 0 end)-V.Payment_CC-V.Payment_OC,2)>0
and 
Case When V.Installment=0 then dateadd(day, A.WPC,V.DueDate)    
When V.Payment_CC<=V.AmountDue_1 then V.DueDate_1    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2 then V.DueDate_2    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11    
Else V.DueDate_12    
end between @P_SDate and @P_EDate    
and Profile.ID Like @P_ID+'%'  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=V.Voucher)   
)  
GO
CREATE function [dbo].[CL_F_COLLECT_ALL_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_F_COLLECT_ALL_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO 
CREATE function [dbo].[CL_F_COLLECT_ALL_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  V.RefNo, V.Voucher,A.Type, A.Date, A.Subject, V.DocNo, V.StatID, V.ActionBy, V.ActionDate, V.AcceptedBy, V.AcceptedDate, 
V.[Currency],  V.Installment, 
Case When V.Installment=0 then dateadd(day, A.WPC,V.DueDate)    
When V.Payment_CC<=V.AmountDue_1 then V.DueDate_1    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2 then V.DueDate_2    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11    
Else V.DueDate_12    
end as DueDate, 
(Case When V.Installment=0 and dateadd(day,A.WPC,V.DueDate) <=@P_EDate Then V.Nominal_CC-V.Diff_CC else 0 end+    
Case When V.Installment>=1 and V.DueDate_1 <=@P_EDate Then V.AmountDue_1 else 0 end+    
Case When V.Installment>=2 and V.DueDate_2 <=@P_EDate Then V.AmountDue_2 else 0 end+    
Case When V.Installment>=3 and V.DueDate_3 <=@P_EDate Then V.AmountDue_3 else 0 end+    
Case When V.Installment>=4 and V.DueDate_4 <=@P_EDate Then V.AmountDue_4 else 0 end+    
Case When V.Installment>=5 and V.DueDate_5 <=@P_EDate Then V.AmountDue_5 else 0 end+    
Case When V.Installment>=6 and V.DueDate_6 <=@P_EDate Then V.AmountDue_6 else 0 end+    
Case When V.Installment>=7 and V.DueDate_7 <=@P_EDate Then V.AmountDue_7 else 0 end+    
Case When V.Installment>=8 and V.DueDate_8 <=@P_EDate Then V.AmountDue_8 else 0 end+    
Case When V.Installment>=9 and V.DueDate_9 <=@P_EDate Then V.AmountDue_9 else 0 end+    
Case When V.Installment>=10 and V.DueDate_10 <=@P_EDate Then V.AmountDue_10 else 0 end+    
Case When V.Installment>=11 and V.DueDate_11 <=@P_EDate Then V.AmountDue_11 else 0 end+    
Case When V.Installment>=12 and V.DueDate_12 <=@P_EDate Then V.AmountDue_12 else 0 end)-V.Payment_CC-V.Payment_OC as Nominal,  
A.Remarks+
(Case When V.Installment<>0 then ' Installment No. ' else '' end+    
Case When V.Installment>=1 and V.DueDate_1 <=@P_EDate and V.Payment_CC<=V.AmountDue_1 Then '1 ' else '' end+    
Case When V.Installment>=2 and V.DueDate_2 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+    
Case When V.Installment>=3 and V.DueDate_3 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+    
Case When V.Installment>=4 and V.DueDate_4 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+    
Case When V.Installment>=5 and V.DueDate_5 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+    
Case When V.Installment>=6 and V.DueDate_6 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+    
Case When V.Installment>=7 and V.DueDate_7 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+    
Case When V.Installment>=8 and V.DueDate_8 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+    
Case When V.Installment>=9 and V.DueDate_9 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+    
Case When V.Installment>=10 and V.DueDate_10 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  Then '10 ' else '' end+    
Case When V.Installment>=11 and V.DueDate_11 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+          
Case When V.Installment>=12 and V.DueDate_12 <=@P_EDate and V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' Else '' end+    
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as AName,    
Profile.Name, V.debtorF,V.CreditorF,A.BatchNo, A.RefType,V.Branch, A.Code
from Profile, nVoucher V, AdmLink A
where  V.Voucher=A.Voucher and Profile.ID=A.ID
and A.Type in ('BB','BA','BO','DI','IC','CF','JP','SO') and A.ISType in ('I','L','C') and A.Subject='Premium'  
and V.Date<=@P_EDate and ((V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC)<>0 or V.PDate>=@P_EDate)    --Aging Condition
and 
Round((Case When V.Installment=0 and dateadd(day,A.WPC,V.DueDate) <=@P_EDate Then V.Nominal_CC-V.Diff_CC else 0 end+    
Case When V.Installment>=1 and V.DueDate_1 <=@P_EDate Then V.AmountDue_1 else 0 end+    
Case When V.Installment>=2 and V.DueDate_2 <=@P_EDate Then V.AmountDue_2 else 0 end+    
Case When V.Installment>=3 and V.DueDate_3 <=@P_EDate Then V.AmountDue_3 else 0 end+    
Case When V.Installment>=4 and V.DueDate_4 <=@P_EDate Then V.AmountDue_4 else 0 end+    
Case When V.Installment>=5 and V.DueDate_5 <=@P_EDate Then V.AmountDue_5 else 0 end+    
Case When V.Installment>=6 and V.DueDate_6 <=@P_EDate Then V.AmountDue_6 else 0 end+    
Case When V.Installment>=7 and V.DueDate_7 <=@P_EDate Then V.AmountDue_7 else 0 end+    
Case When V.Installment>=8 and V.DueDate_8 <=@P_EDate Then V.AmountDue_8 else 0 end+    
Case When V.Installment>=9 and V.DueDate_9 <=@P_EDate Then V.AmountDue_9 else 0 end+    
Case When V.Installment>=10 and V.DueDate_10 <=@P_EDate Then V.AmountDue_10 else 0 end+    
Case When V.Installment>=11 and V.DueDate_11 <=@P_EDate Then V.AmountDue_11 else 0 end+    
Case When V.Installment>=12 and V.DueDate_12 <=@P_EDate Then V.AmountDue_12 else 0 end)-V.Payment_CC-V.Payment_OC,2)>0
and 
Case When V.Installment=0 then dateadd(day, A.WPC,V.DueDate)    
When V.Payment_CC<=V.AmountDue_1 then V.DueDate_1    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2 then V.DueDate_2    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10    
When V.Payment_CC<=V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11    
Else V.DueDate_12    
end between @P_SDate and @P_EDate    
and Profile.ID Like @P_ID+'%'  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=V.Voucher)   
)  
GO
CREATE function [dbo].[CL_F_COLLECT_ALL_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_F_COLLECT_ALL_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO 
CREATE function [dbo].[CL_F_COLLECT_HOLD_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO
CREATE function [dbo].[CL_F_COLLECT_HOLD_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO
CREATE function [dbo].[CL_F_COLLECT_HOLD_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO 
CREATE function [dbo].[CL_F_COLLECT_HOLD_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO
CREATE function [dbo].[CL_F_COLLECT_HOLD_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO
CREATE function [dbo].[CL_F_COLLECT_HOLD_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO 
CREATE function [dbo].[CL_F_COLLECT_HOLD_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO
CREATE function [dbo].[CL_F_COLLECT_HOLD_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO
CREATE function [dbo].[CL_F_COLLECT_HOLD_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO

CREATE function [dbo].[CL_F_COLLECT_NOT_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)

GO


CREATE function [dbo].[CL_F_COLLECT_NOT_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO

CREATE function [dbo].[CL_F_COLLECT_NOT_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO


CREATE function [dbo].[CL_F_COLLECT_NOT_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO


CREATE function [dbo].[CL_F_COLLECT_NOT_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO

CREATE function [dbo].[CL_F_COLLECT_NOT_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)

GO

CREATE function [dbo].[CL_F_COLLECT_NOT_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO


CREATE function [dbo].[CL_F_COLLECT_NOT_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)

GO

CREATE function [dbo].[CL_F_COLLECT_NOT_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO

Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal, AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Premium'  
)  
GO

Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)
GO

Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)
GO

Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
)

GO

Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)

GO

Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)
GO

Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal, AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Premium'  
)  
GO

Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)
GO

Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)

GO

CREATE function [dbo].[CL_F_COLLECT_UNPAID_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 

)
GO


CREATE function [dbo].[CL_F_COLLECT_UNPAID_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 

)

GO

CREATE function [dbo].[CL_F_COLLECT_UNPAID_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 

)
GO

CREATE function [dbo].[CL_F_COLLECT_UNPAID_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 

)
GO

CREATE function [dbo].[CL_F_COLLECT_UNPAID_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 

)


GO

CREATE function [dbo].[CL_F_COLLECT_UNPAID_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 

)
GO


CREATE function [dbo].[CL_F_COLLECT_UNPAID_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 

)
GO


CREATE function [dbo].[CL_F_COLLECT_UNPAID_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 

)
GO


CREATE function [dbo].[CL_F_COLLECT_UNPAID_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 

)
GO


CREATE function [dbo].[CL_I_COLLECT_ALL_COMM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal, AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  

and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Premium'  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
)  
GO

CREATE function [dbo].[CL_I_COLLECT_ALL_COMM_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)

GO



CREATE function [dbo].[CL_I_COLLECT_ALL_COMM_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO

CREATE function [dbo].[CL_I_COLLECT_ALL_GROSS_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO

CREATE function [dbo].[CL_I_COLLECT_ALL_GROSS_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)

GO

CREATE function [dbo].[CL_I_COLLECT_ALL_GROSS_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO


CREATE function [dbo].[CL_I_COLLECT_ALL_NET_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal, AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  

and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Premium'  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
)  
GO

CREATE function [dbo].[CL_I_COLLECT_ALL_NET_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO


CREATE function [dbo].[CL_I_COLLECT_ALL_NET_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)

GO

CREATE function [dbo].[CL_I_COLLECT_HOLD_COMM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO
CREATE function [dbo].[CL_I_COLLECT_HOLD_COMM_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO

CREATE function [dbo].[CL_I_COLLECT_HOLD_COMM_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)

GO

CREATE function [dbo].[CL_I_COLLECT_HOLD_GROSS_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO


CREATE function [dbo].[CL_I_COLLECT_HOLD_GROSS_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO

CREATE function [dbo].[CL_I_COLLECT_HOLD_GROSS_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO

CREATE function [dbo].[CL_I_COLLECT_HOLD_NET_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO


CREATE function [dbo].[CL_I_COLLECT_HOLD_NET_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)

GO

CREATE function [dbo].[CL_I_COLLECT_HOLD_NET_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)



GO

CREATE function [dbo].[CL_I_COLLECT_NOT_COMM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
)

GO


CREATE function [dbo].[CL_I_COLLECT_NOT_COMM_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)

GO

CREATE function [dbo].[CL_I_COLLECT_NOT_COMM_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)
GO

CREATE function [dbo].[CL_I_COLLECT_NOT_GROSS_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
)
GO

CREATE function [dbo].[CL_I_COLLECT_NOT_GROSS_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)

GO

CREATE function [dbo].[CL_I_COLLECT_NOT_GROSS_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)
GO

CREATE function [dbo].[CL_I_COLLECT_NOT_NET_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
)

GO


CREATE function [dbo].[CL_I_COLLECT_NOT_NET_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)
GO


CREATE function [dbo].[CL_I_COLLECT_NOT_NET_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)
GO
Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal, AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Premium'  
)  
GO
Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)
GO
Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)




GO
Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
)




GO
Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)






GO


Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)




GO



Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal, AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Premium'  
)  




GO

Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)






GO

Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)




GO
CREATE function [dbo].[CL_I_COLLECT_UNPAID_COMM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 

)
GO
CREATE function [dbo].[CL_I_COLLECT_UNPAID_COMM_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 

)
GO

CREATE function [dbo].[CL_I_COLLECT_UNPAID_COMM_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 

)

GO
CREATE function [dbo].[CL_I_COLLECT_UNPAID_GROSS_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_I_COLLECT_UNPAID_GROSS_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 

)
GO

CREATE function [dbo].[CL_I_COLLECT_UNPAID_GROSS_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 

)
GO
CREATE function [dbo].[CL_I_COLLECT_UNPAID_NET_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 

)
GO
CREATE function [dbo].[CL_I_COLLECT_UNPAID_NET_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 

)
GO

CREATE function [dbo].[CL_I_COLLECT_UNPAID_NET_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 

)
GO

CREATE function [dbo].[CL_R_COLLECT_ALL_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)

GO

CREATE function [dbo].[CL_R_COLLECT_ALL_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)

GO

CREATE function [dbo].[CL_R_COLLECT_ALL_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO

CREATE function [dbo].[CL_R_COLLECT_ALL_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)


GO


CREATE function [dbo].[CL_R_COLLECT_ALL_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)

GO

CREATE function [dbo].[CL_R_COLLECT_ALL_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)


GO

CREATE function [dbo].[CL_R_COLLECT_ALL_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)

GO


CREATE function [dbo].[CL_R_COLLECT_ALL_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO

CREATE function [dbo].[CL_R_COLLECT_ALL_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO


CREATE function [dbo].[CL_R_COLLECT_HOLD_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO

CREATE function [dbo].[CL_R_COLLECT_HOLD_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)

GO


CREATE function [dbo].[CL_R_COLLECT_HOLD_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO

CREATE function [dbo].[CL_R_COLLECT_HOLD_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)

GO

CREATE function [dbo].[CL_R_COLLECT_HOLD_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO

CREATE function [dbo].[CL_R_COLLECT_HOLD_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)

GO

CREATE function [dbo].[CL_R_COLLECT_HOLD_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO

CREATE function [dbo].[CL_R_COLLECT_HOLD_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)

GO

CREATE function [dbo].[CL_R_COLLECT_HOLD_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)
)
GO
CREATE function [dbo].[CL_R_COLLECT_NOT_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_R_COLLECT_NOT_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_R_COLLECT_NOT_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO 
CREATE function [dbo].[CL_R_COLLECT_NOT_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_R_COLLECT_NOT_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_R_COLLECT_NOT_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO 
CREATE function [dbo].[CL_R_COLLECT_NOT_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_R_COLLECT_NOT_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_R_COLLECT_NOT_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal, AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Premium'  
)  
GO
Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)
GO
Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)
GO
Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
)
GO
Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX') 
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)
GO
Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)
GO
Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal, AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','IR','IT','IX')   
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher  
and Admlink.Subject='Premium'  
)  
GO
Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','IR','IT','IX') 
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)
GO
Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','IR','IT','IX') 
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)
GO 
CREATE function [dbo].[CL_R_COLLECT_UNPAID_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_R_COLLECT_UNPAID_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_R_COLLECT_UNPAID_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 
)
GO
CREATE function [dbo].[CL_R_COLLECT_UNPAID_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 

)
GO
CREATE function [dbo].[CL_R_COLLECT_UNPAID_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 

)
GO
CREATE function [dbo].[CL_R_COLLECT_UNPAID_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 

)

GO
CREATE function [dbo].[CL_R_COLLECT_UNPAID_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 

)
GO
CREATE function [dbo].[CL_R_COLLECT_UNPAID_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 

)

GO
CREATE function [dbo].[CL_R_COLLECT_UNPAID_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink, Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate

and Admlink.Voucher=Voucher.Voucher
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher) 

)
GO
CREATE function [dbo].[CL_U_COLLECT](@P_PDate smalldatetime, @P_Voucher as varchar(20), @P_PolicyNo as varchar(50), @P_RefNo as varchar(50)) 
RETURNS TABLE 
AS RETURN 
( 
select Voucher.RefNo,Voucher.Voucher, Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal, AdmLink.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.AccountNo, Admlink.Extra_4 
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_PDate) Voucher,AdmLink 
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C') 
and Admlink.Subject='Premium' 
and Admlink.Voucher Like @P_Voucher 
and Admlink.A_PolicyNo Like @P_PolicyNo 
and Admlink.RefNo Like @P_RefNo 
) 


GO
CREATE FUNCTION [dbo].[CLLISTQRY] (@VALUE1 AS VARCHAR(255), @VALUE2 AS VARCHAR(255), @VALUE5 AS VARCHAR(255), @VALUE6 AS VARCHAR(255), @VALUE7 AS VARCHAR(255), @VALUE8 AS VARCHAR(255), @VALUE9 AS VARCHAR(255), @VALUE10 AS VARCHAR(255), @VALUE11 AS VARCHAR(255), @VALUE12 AS VARCHAR(255), @VALUE13 AS VARCHAR(255),@VALUE14 as Varchar(10), @VALUE15 as Varchar(10),@VALUE16 as Varchar(255),@VALUE17 as Varchar(255),@VALUE18 as Varchar(255),@VALUE21 as Varchar(255))              
RETURNS Table              
AS RETURN (              
SELECT Claim.CNO,              
  Claim.ClaimNo,              
  Claim.refno,              
  Claim.PolicyNo,              
  Claim.RegDate,              
  Claim.LossDate,              
  Claim.LossPlace,              
  COLTAB.Description,              
  Claim.ClaimantInfo as Claimant,              
  Payment.Name as Payment,              
  Claim.EventName,              
  Claim.CType,              
  Claim.CStatus,              
  Claim.LargeF,              
  Claim.UniqueF,              
  Claim.TBAF_1,              
  Claim.TBAF_2,              
  Claim.SurveyF,              
  CLLOSS.TOI,              
  Claim.Branch,       
  Claim.TOC,              
  Cover.MO,      
  Case When CLInfo.CNO is null then AInfo.ValueID1 else CLInfo.ValueID1 end as ValueID1,              
  Case When CLInfo.CNO is null then AInfo.ValueID2 else CLInfo.ValueID2 end as ValueID2,              
  Case When CLInfo.CNO is null then AInfo.ValueID3 else CLInfo.ValueID3 end as ValueID3,              
  Case When CLInfo.CNO is null then AInfo.ValueID4 else CLInfo.ValueID4 end as ValueID4,              
  Case When CLInfo.CNO is null then AInfo.ValueID5 else CLInfo.ValueID5 end as ValueID5,              
  Case When CLInfo.CNO is null then AInfo.ValueID6 else CLInfo.ValueID6 end as ValueID6,              
  Case When CLInfo.CNO is null then AInfo.ValueID7 else CLInfo.ValueID7 end as ValueID7,              
  Case When CLInfo.CNO is null then AInfo.ValueID8 else CLInfo.ValueID8 end as ValueID8,              
  Case When CLInfo.CNO is null then AInfo.ValueID9 else CLInfo.ValueID9 end as ValueID9,              
  Case When CLInfo.CNO is null then AInfo.ValueID10 else CLInfo.ValueID10 end as ValueID10,              
  Case When CLInfo.CNO is null then AInfo.ValueID11 else CLInfo.ValueID11 end as ValueID11,              
  Case When CLInfo.CNO is null then AInfo.ValueID12 else CLInfo.ValueID12 end as ValueID12,              
  Case When CLInfo.CNO is null then AInfo.ValueID13 else CLInfo.ValueID13 end as ValueID13,              
  Case When CLInfo.CNO is null then AInfo.ValueID14 else CLInfo.ValueID14 end as ValueID14,              
  Case When CLInfo.CNO is null then AInfo.ValueID15 else CLInfo.ValueID15 end as ValueID15,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc1 else CLInfo.ValueDesc1 end as ValueDesc1,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc2 else CLInfo.ValueDesc2 end as ValueDesc2,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc3 else CLInfo.ValueDesc3 end as ValueDesc3,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc4 else CLInfo.ValueDesc4 end as ValueDesc4,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc5 else CLInfo.ValueDesc5 end as ValueDesc5,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc6 else CLInfo.ValueDesc6 end as ValueDesc6,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc7 else CLInfo.ValueDesc7 end as ValueDesc7,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc8 else CLInfo.ValueDesc8 end as ValueDesc8,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc9 else CLInfo.ValueDesc9 end as ValueDesc9,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc10 else CLInfo.ValueDesc10 end as ValueDesc10,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc11 else CLInfo.ValueDesc11 end as ValueDesc11,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc12 else CLInfo.ValueDesc12 end as ValueDesc12,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc13 else CLInfo.ValueDesc13 end as ValueDesc13,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc14 else CLInfo.ValueDesc14 end as ValueDesc14,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc15 else CLInfo.ValueDesc15 end as ValueDesc15,              
  Acceptance.AName , Acceptance.CertificateNo, Acceptance.RefNo as ARefNo            
From CLAIM              
Inner Join Profile Payment on (Payment.ID=Claim.Payment)        
Left Join CLLoss on (CLLoss.CNO=Claim.CNO and Not (@Value13=''))        
Left Join CLInfo on (CLInfo.CNO=CLLoss.CNO)        
Left Join Acceptance on (Acceptance.ANO=Claim.ANO)              
Left Join AInfo on (AInfo.ANO=Acceptance.ANO)              
Left Join Cover on (Cover.CNO=Acceptance.CNO)              
Left Join COLTab on (COLTAB.COL=Claim.COL)              
Where           
  (@Value1='%' or Claim.ClaimNo Like @Value1+'%')    
  And (@Value2='%' or Claim.PolicyNo Like @Value2+'%')    
  And (@Value5='%' or Claim.LossPlace Like @Value5+'%')    
  And (@Value7='%' or Claim.ClaimantInfo Like @Value7+'%' or exists (Select P.ID from CLLoss C, Profile P Where C.CNO=Claim.CNO and P.ID=C.Claimant and P.Name Like @Value7+'%'))      
  And (@Value8='%' or Payment.Name Like @Value8+'%' or exists (Select P.ID from CLLoss C, Profile P Where C.CNO=Claim.CNO and P.ID=C.Payment and P.Name Like @Value8+'%'))    
  And (@Value9='%' or Claim.EventName Like @Value9+'%')     
  And (@Value12='%' or Claim.Refno Like @Value12+'%')    
  And (@Value10='%' or Claim.CType Like @Value10+'%')    
  And (@Value11='%' or Claim.CStatus Like @Value11+'%')    
  And ((Claim.LargeF=1 and @Value14='Large') or @Value14='')              
  And ((Claim.UniqueF=1 and @Value15='Unique') or @Value15='')              
  And (((Claim.TBAF_1=1 or Claim.TBAF_2=1) and @Value17='TBA') or @Value17='')              
  And ((Claim.SurveyF=1 and @Value18='Survey') or @Value18='')              
  And (@Value16='%' or Claim.TOC Like @Value16+'%')   
  And (@Value13='%' or coalesce(CLLOSS.TOI,'') like @Value13+'%')    
  And (@Value6='%' or COLTAB.Description Like @Value6+'%')    
  And (@Value21='%' or COVER.RefNo Like @Value21+'%')    
)              

GO

CREATE FUNCTION [dbo].[DB_F_DISBURSE_ALL_CLAIM_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile], nVoucher Voucher, AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate
and round(Voucher.Nominal_CC-Voucher.Diff_CC - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0   
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)     
and Admlink.A_ID Like @P_ID+'%'
  
)    
  

GO

CREATE FUNCTION [dbo].[DB_F_DISBURSE_ALL_EXCESSREFUND_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile], Voucher_AmountWPCDue(@P_EDate) Voucher, AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
and Admlink.Voucher=Voucher.Voucher    
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)     
and Admlink.A_ID Like @P_ID+'%'    
)    
  

GO


CREATE function [dbo].[DB_F_DISBURSE_HOLD_CLAIM_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))    
RETURNS TABLE      
AS RETURN      
(      
     
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile], nVoucher Voucher, AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate
and Admlink.A_ID Like @P_ID+'%'
and round(Voucher.Nominal_CC-Voucher.Diff_CC - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0   
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)          
)      


GO


CREATE function [dbo].[DB_F_DISBURSE_HOLD_EXCESSREFUND_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))    
RETURNS TABLE      
AS RETURN      
(      
     
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile], Voucher_AmountWPCDue(@P_EDate) Voucher, AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
and Admlink.Voucher=Voucher.Voucher    
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)    
and Admlink.A_ID Like @P_ID+'%'      
)      


GO


CREATE function [dbo].[DB_F_DISBURSE_NOT_CLAIM_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile], nVoucher Voucher, AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate
and Admlink.A_ID Like @P_ID+'%'
and round(Voucher.Nominal_CC-Voucher.Diff_CC - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0   
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)     
)    
  

GO

CREATE function [dbo].[DB_F_DISBURSE_NOT_EXCESSREFUND_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile], Voucher_AmountWPCDue(@P_EDate) Voucher, AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
and Admlink.Voucher=Voucher.Voucher    
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)     
and Admlink.A_ID Like @P_ID+'%'    
)    
  

GO
CREATE function [dbo].[DB_F_DISBURSE_UNPAID_CLAIM_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile], nVoucher Voucher, AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate
and Admlink.A_ID Like @P_ID+'%'
and round(Voucher.Nominal_CC-Voucher.Diff_CC - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0   
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)    
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)     
)   
  
  
  
  
  
GO

CREATE function [dbo].[DB_F_DISBURSE_UNPAID_EXCESSREFUND_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile], Voucher_AmountWPCDue(@P_EDate) Voucher, AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
and Admlink.Voucher=Voucher.Voucher    
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)    
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)     
and Admlink.A_ID Like @P_ID+'%'      
)   
  

GO


CREATE FUNCTION [dbo].[DB_I_DISBURSE_ALL_CLAIM_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate 
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 
and Admlink.Voucher=Voucher.Voucher    
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)     
)    


GO


CREATE FUNCTION [dbo].[DB_I_DISBURSE_ALL_CLAIM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate 
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 
and AdmLink.ID Like @P_ID+'%'  
and Admlink.Voucher=Voucher.Voucher    
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)     
)    
  

GO


CREATE FUNCTION [dbo].[DB_I_DISBURSE_ALL_EXCESSREFUND_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
and Admlink.Voucher=Voucher.Voucher    
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)     
)    


GO


CREATE FUNCTION [dbo].[DB_I_DISBURSE_ALL_EXCESSREFUND_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
and AdmLink.ID Like @P_ID+'%'  
and Admlink.Voucher=Voucher.Voucher    
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)     
)    
  

GO


CREATE function [dbo].[DB_I_DISBURSE_HOLD_CLAIM_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)    
RETURNS TABLE    
AS RETURN    
(    
   
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate 
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 
and Admlink.Voucher=Voucher.Voucher    
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)    
)    
    

GO


CREATE function [dbo].[DB_I_DISBURSE_HOLD_CLAIM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))    
RETURNS TABLE    
AS RETURN    
(    
   
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 
and AdmLink.ID Like @P_ID+'%'  
and Admlink.Voucher=Voucher.Voucher    
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)    
)    
    

GO


CREATE function [dbo].[DB_I_DISBURSE_HOLD_EXCESSREFUND_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)    
RETURNS TABLE    
AS RETURN    
(    
   
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
and Admlink.Voucher=Voucher.Voucher    
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)    
)    
    

GO


CREATE function [dbo].[DB_I_DISBURSE_HOLD_EXCESSREFUND_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))    
RETURNS TABLE    
AS RETURN    
(    
   
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
and AdmLink.ID Like @P_ID+'%'  
and Admlink.Voucher=Voucher.Voucher    
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)    
)    
    

GO


CREATE function [dbo].[DB_I_DISBURSE_NOT_CLAIM_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 
and Admlink.Voucher=Voucher.Voucher    
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)     
)    
  

GO


CREATE function [dbo].[DB_I_DISBURSE_NOT_CLAIM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate 
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 
and Admlink.Voucher=Voucher.Voucher    
and AdmLink.ID Like @P_ID+'%'    
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)     
)    
      

GO


CREATE function [dbo].[DB_I_DISBURSE_NOT_EXCESSREFUND_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
and Admlink.Voucher=Voucher.Voucher    
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)     
)    
  

GO


CREATE function [dbo].[DB_I_DISBURSE_NOT_EXCESSREFUND_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
and Admlink.Voucher=Voucher.Voucher    
and AdmLink.ID Like @P_ID+'%'    
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)     
)    
      

GO


CREATE function [dbo].[DB_I_DISBURSE_UNPAID_CLAIM_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate   
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 
and Admlink.Voucher=Voucher.Voucher    
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)    
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)     
    
)    
    

GO


CREATE function [dbo].[DB_I_DISBURSE_UNPAID_CLAIM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 
and Admlink.Voucher=Voucher.Voucher    
and AdmLink.ID Like @P_ID+'%'  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)    
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)     
    
)    


GO


CREATE function [dbo].[DB_I_DISBURSE_UNPAID_EXCESSREFUND_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
and Admlink.Voucher=Voucher.Voucher    
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)    
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)     
    
)    
    

GO


CREATE function [dbo].[DB_I_DISBURSE_UNPAID_EXCESSREFUND_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
and Admlink.Voucher=Voucher.Voucher    
and AdmLink.ID Like @P_ID+'%'  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)    
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)     
    
)    


GO


CREATE FUNCTION [dbo].[DB_R_DISBURSE_ALL_ALL_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
)  

  
GO

CREATE FUNCTION [dbo].[DB_R_DISBURSE_ALL_ALL_ID] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'
and Admlink.Voucher=Voucher.Voucher  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
)  
GO

CREATE FUNCTION [dbo].[DB_R_DISBURSE_ALL_CLAIM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='CLAIM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
)  
GO


CREATE FUNCTION [dbo].[DB_R_DISBURSE_ALL_CLAIM_ID] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='CLAIM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'
and Admlink.Voucher=Voucher.Voucher  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
)  

GO

CREATE FUNCTION [dbo].[DB_R_DISBURSE_ALL_PREMIUM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='PREMIUM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
)  
GO


CREATE FUNCTION [dbo].[DB_R_DISBURSE_ALL_PREMIUM_ID] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='PREMIUM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'
and Admlink.Voucher=Voucher.Voucher  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
)  
GO

CREATE function [dbo].[DB_R_DISBURSE_HOLD_ALL_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  

select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)  
)  
  
GO

CREATE function [dbo].[DB_R_DISBURSE_HOLD_ALL_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  

select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'
and Admlink.Voucher=Voucher.Voucher  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)  
)  
GO

  
CREATE function [dbo].[DB_R_DISBURSE_HOLD_CLAIM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  

select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.SUbject)='CLAIM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)  
)  
GO

CREATE function [dbo].[DB_R_DISBURSE_HOLD_CLAIM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  

select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.SUbject)='CLAIM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'
and Admlink.Voucher=Voucher.Voucher  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)  
)  
GO

CREATE function [dbo].[DB_R_DISBURSE_HOLD_PREMIUM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  

select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.SUbject)='PREMIUM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)  
)  
  
GO

CREATE function [dbo].[DB_R_DISBURSE_HOLD_PREMIUM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  

select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.SUbject)='PREMIUM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'
and Admlink.Voucher=Voucher.Voucher  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)  
)  
GO

CREATE function [dbo].[DB_R_DISBURSE_NOT_ALL_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
)  

GO


CREATE function [dbo].[DB_R_DISBURSE_NOT_ALL_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and AdmLink.ID Like @P_ID+'%'  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
)  
GO


CREATE function [dbo].[DB_R_DISBURSE_NOT_CLAIM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='CLAIM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
)  
GO

CREATE function [dbo].[DB_R_DISBURSE_NOT_CLAIM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLInk.Subject)='CLAIM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and AdmLink.ID Like @P_ID+'%'  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
)  
GO


CREATE function [dbo].[DB_R_DISBURSE_NOT_PREMIUM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='PREMIUM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
)  
GO

CREATE function [dbo].[DB_R_DISBURSE_NOT_PREMIUM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLInk.Subject)='PREMIUM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and AdmLink.ID Like @P_ID+'%'  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
)  

GO


CREATE function [dbo].[DB_R_DISBURSE_PERIOD_DUE_ALL_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Admlink.Voucher=Voucher.Voucher  
and Voucher.AmountDue<>0
)  
GO

CREATE function [dbo].[DB_R_DISBURSE_PERIOD_DUE_ALL_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Admlink.Voucher=Voucher.Voucher  
and Voucher.AmountDue<>0
and AdmLink.ID Like @P_ID+'%'  
)  
GO


CREATE function [dbo].[DB_R_DISBURSE_PERIOD_DUE_CLAIM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Admlink.Voucher=Voucher.Voucher  
and Voucher.AmountDue<>0
and Upper(AdmLink.Subject)='CLAIM'
)  

  
GO


CREATE function [dbo].[DB_R_DISBURSE_PERIOD_DUE_CLAIM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Admlink.Voucher=Voucher.Voucher  
and Voucher.AmountDue<>0
and Upper(AdmLInk.Subject)='CLAIM'
and AdmLink.ID Like @P_ID+'%'  
)  
GO


CREATE function [dbo].[DB_R_DISBURSE_PERIOD_DUE_PREMIUM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Admlink.Voucher=Voucher.Voucher  
and Voucher.AmountDue<>0
and Upper(AdmLink.Subject)='PREMIUM'
)  
GO

CREATE function [dbo].[DB_R_DISBURSE_PERIOD_DUE_PREMIUM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo,
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Admlink.Voucher=Voucher.Voucher  
and Voucher.AmountDue<>0
and Upper(AdmLInk.Subject)='PREMIUM'
and AdmLink.ID Like @P_ID+'%'  
)  

GO

CREATE function [dbo].[DB_R_DISBURSE_UNPAID_ALL_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
  
)  
  
GO

CREATE function [dbo].[DB_R_DISBURSE_UNPAID_ALL_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and AdmLink.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
  
)  
GO

CREATE function [dbo].[DB_R_DISBURSE_UNPAID_CLAIM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='CLAIM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
  
)  
GO

CREATE function [dbo].[DB_R_DISBURSE_UNPAID_CLAIM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='CLAIM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and AdmLink.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
  
)  
GO
 
  
CREATE function [dbo].[DB_R_DISBURSE_UNPAID_PREMIUM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='PREMIUM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
  
)  
GO

CREATE function [dbo].[DB_R_DISBURSE_UNPAID_PREMIUM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Admlink.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType,Voucher.Branch, Admlink.Code, Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher, AdmLink Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='PREMIUM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Voucher=Voucher.Voucher  
and AdmLink.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)  
and Not Exists (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=Voucher.Voucher)   
  
)  
  
GO
CREATE FUNCTION [dbo].[FL_SL_ACCOUNT](@P_GID varchar(10), @P_Voucher varchar(20), @P_VType varchar(10), @P_ComAcc varchar(30), @P_Doc_No varchar(20),@P_CCY varchar(10), @P_Payment_Flag bit)                                    
RETURNS @TSL_Account TABLE (Account Varchar(10), Open_ItemF Bit, Branch Varchar(15), Hint Int, Description varchar(512), Currency varchar(10), Outstanding Float)                                    
AS                                        
BEGIN                               
Declare @P_SL_Cat varchar(1)                
                       
if @P_Payment_Flag=1                       
Begin              
Select @P_SL_Cat=SL_Cat from pVoucher Where Voucher=@P_Doc_No                
if @P_SL_Cat is null                 
Begin              
   Select @P_SL_Cat='N'                
End                
if @P_SL_Cat='P'                
Begin                           
   insert into @TSL_Account                                    
   Select A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, A2.Description, V.Currency,           
   (Case When VType.DebtorF=1 Then 1 Else -1 end)*(Case When V.DebtorF=1 then -(Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) else (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) end) as Outstanding              
   from pVoucher V                                     
   Inner Join Get_Open_Item_Hint_P(@P_Doc_No,@P_VType) A1 on (A1.Voucher=V.Voucher)                                     
   Inner join VType on (VType.VType=@P_VType)          
   Inner Join Account A2 on (A2.Account=A1.Account)     
   Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)    
   Left Join Open_Item_Allocated(@P_Doc_No) SL_Alloc on (SL_Alloc.Voucher<>@P_Voucher and SL_Alloc.Doc_no=A1.Voucher and SL_Alloc.Branch=A1.Branch and SL_Alloc.Account=A1.Account)                                     
   Where @P_Doc_No<>'' and A1.Voucher=V.Voucher                                     
   and ((coalesce(ComAcc.ComAcc,'')='' and A2.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A2.AccGroup='' or ComAcc.AccGroup=A2.AccGroup)))     
   Group By A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, VType.DebtorF, V.DebtorF, V.SL_Cat, A2.Description, V.Currency                                    
   Having round(Max(A1.Nominal_OC),2)<>round(sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end),2)                                        
End              
else                
Begin              
   insert into @TSL_Account                                    
   Select A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, A2.Description, V.Currency,           
   (Case When VType.DebtorF=1 Then 1 Else -1 end)*(Case When V.DebtorF=1 then (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) else (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) end) as Outstanding              
   from nVoucher V                                     
   Inner Join Get_Open_Item_Hint_N(@P_Doc_No,@P_VType) A1 on (A1.Voucher=V.Voucher)                                     
   Inner join VType on (VType.VType=@P_VType)          
   Inner Join Account A2 on (A2.Account=A1.Account)       
   Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)
   Left Join Open_Item_Allocated(@P_Doc_No) SL_Alloc on (SL_Alloc.Voucher<>@P_Voucher and SL_Alloc.Doc_no=A1.Voucher and SL_Alloc.Branch=A1.Branch and SL_Alloc.Account=A1.Account)                                     
   Where @P_Doc_No<>'' and A1.Voucher=V.Voucher                                     
   and ((coalesce(ComAcc.ComAcc,'')='' and A2.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A2.AccGroup='' or ComAcc.AccGroup=A2.AccGroup)))     
   Group By A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, VType.DebtorF, V.DebtorF, V.SL_Cat, A2.Description, V.Currency                                    
   Having round(Max(A1.Nominal_OC),2)<>round(sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end),2)                         
End              
End              
Else            
Begin           
if @P_GID=''       
Begin                        
  insert into @TSL_Account                                
  Select A1.Account, A1.Open_ItemF, '' as Branch, max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, A1.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, 0 as Outstanding                 
  from Account A1 
  Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc), Account a2, vPattern, SysTab, VType              
  Where A1.AllowedF=1 and a1.post_flag=1 and a1.parent=a2.parent and a2.account=vPattern.account and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) and VType.Vtype=@P_VType AND VType.VType = VPattern.VType and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1)                                    
  and ((coalesce(ComAcc.ComAcc,'')='' and A1.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A1.AccGroup='' or ComAcc.AccGroup=A1.AccGroup)))     
  Group By A1.Account, A1.Open_ItemF, A1.Description, SysTab.Currency                                    
End      
Else      
Begin      
  insert into @TSL_Account                                    
  Select A1.Account, A1.Open_ItemF, '' as Branch, max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, B.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, 0 as Outstanding                   
  from Budget_AccountDetail B, Account A1 
  Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc), Account a2, vPattern, SysTab, VType                                       
  Where B.GID=@P_GID and B.ID=@P_Doc_No and (A1.Account=B.Account_Dr or A1.Account=B.Account_Cr) and A1.AllowedF=1 and a1.post_flag=1 and a1.parent=a2.parent and a2.account=vPattern.account and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) and VType.Vtype=@P_VType AND VType.VType = VPattern.VType and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1)                                      
  and ((coalesce(ComAcc.ComAcc,'')='' and A1.AccGroup='') or (coalesce(ComAcc.ComAcc,'')<>'' and (ComAcc.AccGroup='' or A1.AccGroup='' or ComAcc.AccGroup=A1.AccGroup)))     
  Group By A1.Account, A1.Open_ItemF, B.Description, SysTab.Currency            
End      
End       
       
Return                                    
END                
            
GO

Create function [dbo].[FL_SL_Budget_Account_Actual](@P_Voucher as varchar(20)) 
RETURNS Table 
AS RETURN 
( 
Select V.Date, SL.Branch, Case When SL.CT<>'' Then SL.CT else V.CT end as CT, V.GID, SL.Doc_No as ID, 
SL.Nominal*V.Rate*(Case When B.Account_DR=SL.Account Then 1 else -1 end)*(Case When V.CreditorF=1 Then 1 else -1 end) as Nominal 
from pVoucher V, 
--Part Of OSL Functions 
( 
    Select pSL.Voucher, pSL.Doc_No, pSL.Doc_Date, pSL.Doc_CCY, pSL.Nominal_OC, pSL.CT, pSL.Nominal, pSL.Remarks, pSL.Hint, 
    Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end as PaymentF, 
    Case When OSL.Account is null then pSL.Account else OSL.Account end as Account, 
    Case When OBranch.Branch is null then pVoucher.Branch else OBranch.Branch end as Branch, pSL.Nominator, pSL.Denominator, pSL.Rate, pSL.SortNo, pSL.pVoucher 
    From dbo.pSL 
    Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher) 
    Left join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account) 
    Left Join dbo.pVoucher OVoucher on (OBranch.Branch=OVoucher.Branch and OVoucher.RefNo=pSL.Voucher and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE') 
    Left join dbo.pSL OSL on (OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo)) 
    Where pVoucher.SL_Cat in ('P') and pVoucher.Voucher=@P_Voucher 
) SL 
, Budget_AccountDetail B 
Where SL.Voucher=V.Voucher and SL.PaymentF=0 and B.GID=V.GID  and B.ID=SL.Doc_No and (B.Account_DR=SL.Account or B.Account_Cr=SL.Account) 
and V.Voucher=@P_Voucher 
) 


GO

CREATE FUNCTION [dbo].[FL_SL_COMACC] (@P_VType as varchar(10), @P_UserID as varchar(10), @P_Branch as varchar(10),@P_sComAcc varchar(30))                    
RETURNS TABLE                    
as RETURN(                    
Select ComAcc.ComAcc, ComAcc.Description, ComAcc.Currency, ComAcc.RestrictedF, VPattern.Debit+VPattern.Credit as Hint, VPattern.Account                
from ComAcc
Inner Join ComAcc sComAcc on (sComAcc.ComAcc=@P_sComAcc and (sComAcc.AccGroup='' or ComAcc.AccGroup='' or ComAcc.AccGroup=sComAcc.AccGroup))  
Inner Join VType on (VType.VType=@P_VType)
Inner Join VPattern on (VType.VType=VPattern.VType and ((vPattern.Debit=-1 and VType.CreditorF=1) or (vPattern.Credit=-1 and VType.DebtorF=1)))
Inner Join Account on (Account.Open_ItemF=1 and Account.Account=Vpattern.Account)
Inner Join SysUser on (SysUser.ID=@P_UserID) 
where ComAcc.NonCBF=0 and (SysUser.Type='SUPERVISOR' or EXISTS (Select SysUserComAcc.ComAcc from SysUserComAcc Where SysUserComAcc.ID=@P_UserID and SysUserComAcc.ComAcc=ComAcc.ComAcc))              
and ((ComAcc.Branch=@P_Branch) or (EXISTS (Select ComAcc from ComAcc_Branch Where ComAcc_Branch.ComAcc=ComAcc.ComAcc and Branch=@P_Branch)) or (ComAcc.Branch='' and NOT EXISTS (Select Top 1 ComAcc from ComAcc_Branch Where ComAcc_Branch.ComAcc=ComAcc.ComAcc)))     
)                                    
GO

CREATE function [dbo].[fn_CF_Budget](@P_Branch as varchar(10), @P_Year int)            
RETURNS TABLE            
AS RETURN            
(            
Select Account.Account, Account.Description,      
'' as TOC,  
'' as TOCDesc,     
-CF_Month_1 as Month_1,    
0 as Actual_1,
0 as PMonth_1,     
-CF_Month_2 as Month_2,         
0 as Actual_2,
0 as PMonth_2,
-CF_Month_3 as Month_3,         
0 as Actual_3,
0 as PMonth_3,
-CF_Month_4 as Month_4,         
0 as Actual_4,
0 as PMonth_4,
-CF_Month_5 as Month_5,         
0 as Actual_5,
0 as PMonth_5,
-CF_Month_6 as Month_6,         
0 as Actual_6,
0 as PMonth_6,
-CF_Month_7 as Month_7,         
0 as Actual_7,
0 as PMonth_7,
-CF_Month_8 as Month_8,         
0 as Actual_8,
0 as PMonth_8,
-CF_Month_9 as Month_9,         
0 as Actual_9,
0 as PMonth_9,
-CF_Month_10 as Month_10,         
0 as Actual_10,
0 as PMonth_10,
-CF_Month_11 as Month_11,         
0 as Actual_11,
0 as PMonth_11,
-CF_Month_12 as Month_12,         
0 as Actual_12,
0 as PMonth_12,
0  as Starting,    
-(CF_Month_1+CF_Month_2+CF_Month_3+CF_Month_4+CF_Month_5+CF_Month_6+CF_Month_7+CF_Month_8+CF_Month_9+CF_Month_10+CF_Month_11+CF_Month_12) as Total,
0 as Starting_Actual,    
0 as Total_Actual,
0 as Starting_Prognosis,
0 as Total_Prognosis


From Account         
Left Join Budget on (Budget.Account=Account.Account and Budget.Branch=@P_Branch and Budget.Year=@P_Year)          
Left Join GL on (GL.Account=Account.Account and GL.Branch=@P_Branch and GL.Year=@P_Year and GL.Month=1)        
)            
        

GO


CREATE function [dbo].[fn_CT_Budget](@P_Branch as varchar(10), @P_Year int,@P_CT as varchar(10))        
RETURNS TABLE        
AS RETURN        
(        
Select Account.Account, Account.Description,     
'' as TOC,  
'' as TOCDesc,     
Month_1 as Month_1,     
actual_1 as Actual_1,   
PMonth_1 as PMonth_1,       
Month_2 as Month_2,     
actual_2 as Actual_2,     
PMonth_2 as PMonth_2,     
Month_3 as Month_3,     
actual_3 as Actual_3,     
PMonth_3 as PMonth_3,     
Month_4 as Month_4,     
actual_4 as Actual_4,     
PMonth_4 as PMonth_4,     
Month_5 as Month_5,     
actual_5 as Actual_5,     
PMonth_5 as PMonth_5,     
Month_6 as Month_6,     
actual_6 as Actual_6,     
PMonth_6 as PMonth_6,     
Month_7 as Month_7,     
Actual_7 as Actual_7,     
PMonth_7 as PMonth_7,     
Month_8 as Month_8,     
Actual_8 as Actual_8,     
PMonth_8 as PMonth_8,     
Month_9 as Month_9,     
Actual_9 as Actual_9,     
PMonth_9 as PMonth_9,     
Month_10 as Month_10,     
Actual_10 as Actual_10,     
PMonth_10 as PMonth_10,     
Month_11 as Month_11,     
Actual_11 as Actual_11,     
PMonth_11 as PMonth_11,     
Month_12 as Month_12,     
Actual_12 as Actual_12,    
PMonth_12 as PMonth_12,  
0 as Starting, 
Month_1+Month_2+Month_3+Month_4+Month_5+Month_6+Month_7+Month_8+Month_9+Month_10+Month_11+Month_12 as Total,     
0 as Starting_Actual,
Actual_1+Actual_2+Actual_3+Actual_4+Actual_5+Actual_6+Actual_7+Actual_8+Actual_9+Actual_10+Actual_11+Actual_12 as Total_Actual,  
0 as Starting_Prognosis,
PMonth_1+PMonth_2+PMonth_3+PMonth_4+PMonth_5+PMonth_6+PMonth_7+PMonth_8+PMonth_9+PMonth_10+PMonth_11+PMonth_12 as Total_Prognosis  
From Account     
Left Join CTBudget Budget on (Budget.Account=Account.Account and Budget.Branch=@P_Branch and Budget.Year=@P_Year and Budget.CT=@P_CT)      
)        
GO
CREATE FUNCTION [dbo].[fn_Exchange](@PDate as smalldatetime) 
RETURNS @EXCHANGE TABLE (Currency varchar(10), Effective smalldatetime, Rate float, TRate Float, BIRate Float, RRate Float, VRate Float) 
AS 
BEGIN 
insert into @EXCHANGE 
Select Currency.Currency, Currency.Effective, Currency.Rate, Currency.TRate, Currency.BIRate, Currency.RRate, Currency.VRate 
from Currency, SysTab 
Where Currency.Currency<>SysTab.Currency and Currency.Effective<=@PDate 

insert into @EXCHANGE 
Select E1.Currency, E1.Effective, E1.Rate, E1.TRate, E1.BIRate, E1.RRate, E1.VRate 
from Exchange E1, Currency, SysTab 
Where Currency.Currency=E1.Currency and E1.Effective<=@PDate and Currency.Effective>@PDate and SysTab.Currency<>E1.Currency 
and E1.Effective=coalesce((Select Top 1 E2.Effective from Exchange E2 Where E2.Currency=E1.Currency and E2.Effective<=@PDate Order By E2.Effective Desc),'01/01/1900') 

insert into @EXCHANGE 
Select Currency, @PDate as Effective, 1 as Rate, 1 as TRate, 1 as BIRate, 1 as RRate, 1 as VRate 
from Currency 
Where NOT EXISTS (Select Currency from @Exchange E Where E.Currency=Currency.Currency) 

RETURN 
END 


GO

CREATE FUNCTION [dbo].[FN_ONECARD](@P_CARDID as varchar(30))    
RETURNS TABLE AS    
RETURN (    
SELECT Distinct Acceptance.ANO  
from Acceptance, Cover, TOC, OneCardD Where TOC.TOC=Cover.TOC and TOC.COB<>'13' and Cover.PHolder=OneCardD.ID and Cover.CNO=Acceptance.CNO and OneCardD.CardID like @P_CardID+'%'    
)    
    
GO
CREATE function [dbo].[FN_UserMO](@P_USERID varchar(50))          
RETURNS Table            
AS RETURN            
(          
SELECT S1.*      
from SysUser S1    
--Not Yet Activated    
--, SysUser S2    
--Where S2.ID=@P_UserID       
--and (S2.Type='SUPERVISOR' or S1.ID in (Select S.MO from SysUserMO S Where S.ID=@P_UserID))      
)              
    
GO

Create function [dbo].[Get_Claim_APRule](@P_CNO as int)    
RETURNS Table    
AS RETURN    
(    
Select AD.RuleID, AD.Class, AD.RepName, AD.ExeName
from APDRuleH AH INNER JOIN APDRULED AD ON (AH.RULEID=AD.RULEID) INNER JOIN SYSCLASS S ON (S.CLASS=AD.CLASS)
Where AH.AllowedF=1 AND AH.APPTYPE='CLAIM'
and 1 in 
(
Select 1 from Acceptance A, Cover C, Claim
Where Claim.CNO=@P_CNO and A.ANO=Claim.ANO and C.CNO=A.CNO and C.PolicyType=AH.PolicyType and C.ISType=AH.ISType and (C.Segment=AH.Segment or AH.Segment='<All>') and C.TOC=AH.TOC and (A.TOPRO=AH.TOPRO or AH.TOPRO='<All>')
and charindex(Claim.CType,S.ClaimCType)<>0
and charindex(Claim.CStatus,S.ClaimCStatus)<>0
)
)   
GO

CREATE function [dbo].[Get_Open_Item_N] (@P_Voucher Varchar(20))    
RETURNS Table    
AS RETURN    
(    
Select Voucher.Voucher, Account.Account, Account.Description, Max(Voucher.Branch) as Branch, Max(Voucher.CT) as CT, Max(SL.Hint) as Hint, sum(Case When Voucher.DebtorF=1 Then SL.Nominal else -SL.Nominal end) as Nominal_OC    
from nVoucher Voucher inner Join nSL SL on (SL.Voucher=Voucher.Voucher) inner Join Account on (Account.Account=SL.Account and Account.Open_ItemF=1)    
Where Voucher.Voucher=@P_Voucher    
Group By Voucher.Voucher, Account.Account, Account.Description  
)                

GO


CREATE function [dbo].[Get_Open_Item_P] (@P_Voucher Varchar(20))      
RETURNS Table      
AS RETURN      
(      
Select SL.Voucher, SL.Account, SL.Description, SL.Branch, Max(SL.Hint) as Hint, sum(SL.Nominal_OC) as Nominal_OC      
From      
(      
--Part Of OSL Functions
Select pVoucher.Voucher, Account.Account, Account.Description, Case When OBranch.Branch is null then pVoucher.Branch else OBranch.Branch end as Branch, pSL.Hint, pSL.Nominal as Nominal_OC
From dbo.pSL      
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)      
Left join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account)      
Left Join dbo.pVoucher OVoucher on (OBranch.Branch=OVoucher.Branch and OVoucher.RefNo=pSL.Voucher and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE')      
Left join dbo.pSL OSL on (OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo))      
Inner Join dbo.Account Account on (Account.Account=coalesce(OSL.Account, pSL.Account) and Account.Open_ItemF=1)
Where pVoucher.SL_Cat='P' and (pVoucher.Voucher=@P_Voucher or @P_Voucher='') and Coalesce(OSL.PaymentF, pSL.PaymentF)=0
     
Union All      
                          
select pVoucher.Voucher, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end as Account, Account.Description, Voucher.Branch, SL.Hint, SL.Nominal as Nominal_OC 
from pVoucher pVoucher, pVoucher Voucher, pSL SL, Account, vPattern      
Where vPattern.VType=Voucher.VType and ((Voucher.DebtorF=1 and vPattern.Debit=SL.Hint) or (Voucher.CreditorF=1 and vPattern.Credit=SL.Hint))     
and (pVoucher.Voucher=@P_Voucher or @P_Voucher='') and pVoucher.SL_Cat='P'    
and Voucher.RefNo=pVoucher.Voucher and Voucher.SL_Cat='A'      
and SL.Voucher=Voucher.Voucher and Account.Account=(Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end) and Account.Open_ItemF=1      
                          
Union All      
                          
select pVoucher.Voucher, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end as Account, Account.Description, Voucher.Branch, SL.Hint, SL.Nominal as Nominal_OC 
from pVoucher pVoucher, pVoucher OVoucher, pVoucher Voucher, pSL SL, Account, vPattern      
Where vPattern.VType=Voucher.VType and ((Voucher.DebtorF=1 and vPattern.Debit=SL.Hint) or (Voucher.CreditorF=1 and vPattern.Credit=SL.Hint))     
and (pVoucher.Voucher=@P_Voucher or @P_Voucher='') and pVoucher.SL_Cat='P'    
and OVoucher.RefNo=pVoucher.Voucher and OVoucher.SL_Cat='B'      
and Voucher.RefNo=OVoucher.Voucher and Voucher.SL_Cat='A' and SL.Voucher=Voucher.Voucher and Account.Account=(Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end) and Account.Open_ItemF=1      
                          
) SL      
Group By SL.Voucher, SL.Account, SL.Description, SL.Branch having sum(SL.Nominal_OC)<>0      
)      
        
      
    
    
GO
CREATE function [dbo].[Get_Open_Item] (@P_Voucher Varchar(20))  
RETURNS Table  
AS RETURN  
(  
Select Voucher, Account, Description, Branch, Hint, Nominal_OC from Get_Open_Item_N(@P_Voucher)  
Union All  
Select Voucher, Account, Description, Branch, Hint, Nominal_OC from Get_Open_Item_P(@P_Voucher)  
)  
      
GO
CREATE function [dbo].[Get_Open_Item_Hint] (@P_Voucher Varchar(20),@P_VType varchar(20))
RETURNS Table
AS RETURN
(
Select A1.* from get_Open_Item(@P_Voucher) as A1,(Select Distinct VPattern.VType, VPattern.Debit+VPattern.Credit as Hint from Vpattern Where VPattern.VType=@P_VType) vPattern where A1.Hint=VPattern.Hint and VPattern.Vtype=@P_VType
        
)
  
GO

CREATE function [dbo].[Get_Open_Item_I] (@P_Voucher Varchar(20))  
RETURNS Table  
AS RETURN  
(  
Select Voucher.Voucher, Account.Account, Account.Description, Max(Voucher.Branch) as Branch, Max(Voucher.CT) as CT, Max(SL.Hint) as Hint, sum(Case When Voucher.DebtorF=1 Then SL.Nominal else -SL.Nominal end) as Nominal_OC  
from nVoucher Voucher, nSL SL, VType, VPattern, Account  
Where Voucher.Voucher=@P_Voucher and Voucher.InvestmentF=1 and Voucher.Voucher=SL.Voucher and VType.VType=Voucher.VType and VPattern.VType=VType.VType and (VPattern.Debit=SL.Hint or VPattern.Credit=SL.Hint) and Account.Account=VPattern.Account and Account.Open_ItemF=1  
Group by Voucher.Voucher, Account.Account, Account.Description  
)  
                
GO
CREATE function [dbo].[Get_Open_Item_Hint_I] (@P_Voucher Varchar(20),@P_VType varchar(20))
RETURNS Table
AS RETURN
(
Select A1.* from get_Open_Item_I(@P_Voucher) as A1,Vpattern where (A1.Hint=VPattern.Debit or A1.Hint=VPattern.Credit) and VPattern.Vtype=@P_VType
)
  

GO
CREATE function [dbo].[Get_Open_Item_M] (@P_Voucher Varchar(20))  
RETURNS Table  
AS RETURN  
(  
Select Voucher.Voucher, Account.Account, Account.Description, Max(Voucher.Branch) as Branch, Max(Voucher.CT) as CT, Max(SL.Hint) as Hint, sum(Case When Voucher.DebtorF=1 Then SL.Nominal else -SL.Nominal end) as Nominal_OC  
from nVoucher Voucher, nSL SL, VType, VPattern, Account  
Where Voucher.Voucher=@P_Voucher and Voucher.InvestmentF=0 and Vtype.TaxF=0 and Voucher.Voucher=SL.Voucher and VType.VType=Voucher.VType and VPattern.VType=VType.VType and (VPattern.Debit=SL.Hint or VPattern.Credit=SL.Hint) and Account.Account=VPattern.Account and Account.Open_ItemF=1  
Group by Voucher.Voucher, Account.Account, Account.Description  
)  

GO
CREATE function [dbo].[Get_Open_Item_Hint_M] (@P_Voucher Varchar(20),@P_VType varchar(20))
RETURNS Table
AS RETURN
(
Select A1.* from get_Open_Item_M(@P_Voucher) as A1,Vpattern where (A1.Hint=VPattern.Debit or A1.Hint=VPattern.Credit) and VPattern.Vtype=@P_VType
)

GO

CREATE function [dbo].[Get_Open_Item_Hint_N] (@P_Voucher Varchar(20),@P_VType varchar(20))  
RETURNS Table  
AS RETURN  
(  
Select A1.* from get_Open_Item_N(@P_Voucher) as A1,Vpattern where (A1.Hint=VPattern.Debit or A1.Hint=VPattern.Credit) and VPattern.Vtype=@P_VType  
        
)  
GO

CREATE function [dbo].[Get_Open_Item_Hint_P] (@P_Voucher Varchar(20),@P_VType varchar(20))
RETURNS Table
AS RETURN
(
Select A1.* from get_Open_Item_P(@P_Voucher) as A1,(Select Distinct VPattern.VType, VPattern.Debit+VPattern.Credit as Hint from Vpattern Where VPattern.VType=@P_VType) vPattern where A1.Hint=VPattern.Hint and VPattern.Vtype=@P_VType
      
)
  
GO

CREATE function [dbo].[Get_Open_Item_T] (@P_Voucher Varchar(20))  
RETURNS Table  
AS RETURN  
(  
Select Voucher.Voucher, Account.Account, Account.Description, Max(Voucher.Branch) as Branch, Max(Voucher.CT) as CT, Max(SL.Hint) as Hint, sum(Case When Voucher.DebtorF=1 Then SL.Nominal else -SL.Nominal end) as Nominal_OC  
from nVoucher Voucher, nSL SL, VType, VPattern, Account  
Where Voucher.Voucher=@P_Voucher and Voucher.Voucher=SL.Voucher and VType.TaxF=1 and VType.VType=Voucher.VType and VPattern.VType=VType.VType and (VPattern.Debit=SL.Hint or VPattern.Credit=SL.Hint) and Account.Account=VPattern.Account and Account.Open_ItemF=1  
Group by Voucher.Voucher, Account.Account, Account.Description  
)  
                  
GO
CREATE function [dbo].[Get_Open_Item_Hint_T] (@P_Voucher Varchar(20),@P_VType varchar(20))
RETURNS Table
AS RETURN
(
Select A1.* from get_Open_Item_T(@P_Voucher) as A1,Vpattern where (A1.Hint=VPattern.Debit or A1.Hint=VPattern.Credit) and VPattern.Vtype=@P_VType
      
)

GO


Create function [dbo].[Get_Policy_APRule](@P_ANO as int)    
RETURNS Table    
AS RETURN    
(    
Select AD.RuleID, AD.Class, AD.RepName, AD.ExeName
from APDRuleH AH INNER JOIN APDRULED AD ON (AH.RULEID=AD.RULEID) INNER JOIN SYSCLASS S ON (S.CLASS=AD.CLASS)
Where AH.AllowedF=1 AND AH.APPTYPE='POLICY'
and 1 in 
(
Select 1 from Acceptance A, Cover C 
Where A.ANO=@P_ANO and C.CNO=A.CNO and C.PolicyType=AH.PolicyType and C.ISType=AH.ISType and (C.Segment=AH.Segment or AH.Segment='<All>') and C.TOC=AH.TOC and (A.TOPRO=AH.TOPRO or AH.TOPRO='<All>')
and charindex(A.AType,S.AccAType)<>0
and charindex(A.AStatus,S.AccAStatus)<>0
and charindex(C.CStatus,S.CoverCStatus)<>0
)
)   
GO

CREATE function [dbo].[ListQry_1] (@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255), @Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255),  @Value10 as varchar(255),@Value11 as varchar(255), @value12 as varchar(255), @value13 as varchar(255), @Value14 as varchar(255),@Value15 as varchar(255),@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255)) 
RETURNS Table 
AS RETURN 
( 
SELECT Cast(0 as bit) as ProcessFlag, 
Cover.CoverNo as [Quotation No], 
Acceptance.RegNo as [CI No], 
Acceptance.PolicyNo as [Policy No], 
Acceptance.CertificateNo as [Certificate No], 
Cast(Acceptance.AName as varchar(128)) as Insured, 
Profile.Name as [Policy Holder], 
Cover.CoverDate as [Cover Date], 
Cover.Expdate as [Expiry Date], 
Acceptance.PolicyDate as [Issued Date], 
Acceptance.SDate as Start, 
Acceptance.EDate as [End], 
Acceptance.AStatus, 
Acceptance.AType, 
Acceptance.ANO, 
Acceptance.LANO, 
Acceptance.RefNo, 
Cover.ProformaF, 
cover.CNO 
From cover, acceptance, Profile 
Where cover.CNO = acceptance.CNO And cover.PHolder = Profile.ID 
And (Acceptance.AName Like @Value1) 
And (Cover.CoverNo Like @Value2 Or Cover.CoverNo is null) 
and (Cover.CoverDate = @Value3 Or Cover.CoverDate is null or @Value3 = '') 
And (Cover.ExpDate = @Value4 Or Cover.ExpDate is null or @Value4 = '') 
And (Acceptance.PolicyNo Like @Value5 Or Acceptance.PolicyNo is null) 
And (Acceptance.CertificateNo Like @Value6 Or Acceptance.CertificateNo is null) 
And (Acceptance.PolicyDate = @Value7 Or Acceptance.PolicyDate is null or @Value7 = '' or Acceptance.PolicyDate Between @Value7 and @Value16) 
And (Acceptance.RegDate = @Value17 Or Acceptance.RegDate is null or @Value17 = '' or Acceptance.RegDate Between @Value17 and @Value18) 
And Acceptance.AType Like @Value8 
And Acceptance.AStatus Like @Value9 
And Acceptance.RegNo Like @Value10 
And (Profile.Name Like @Value11 or Profile.Name is null) 
and Cover.toc like @Value12 
and (Acceptance.Matters=@Value14 or @Value14='') 
and (Acceptance.Refno like @Value13 or Acceptance.Refno is null) 
And (Cover.ISType<>'T' or Cover.ProformaF=1) 
) 


GO

CREATE function [dbo].[ListQry_1_a] (@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255), @Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255),
@Value10 as varchar(255),@Value11 as varchar(255), @value12 as varchar(255), @value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255))
RETURNS Table
AS RETURN
(
SELECT Cast(0 as bit) as ProcessFlag, 
  [q].[Quotation No],
  [q]. [CI No],
  [q].[Policy No],
  [q].[Certificate No],
  [q].[Insured],
  [q].[Policy Holder],
  [q].[Cover Date],
  [q].[Expiry Date],
  [q].[Issued Date],
  [q].[Start],
  [q].[End],
  [q].[AStatus],
  [q].[AType],
  [q].[ANO],
  [q].[LANO],
  q.RefNo,
  q.ProformaF,
  q.cno,
  a.valueid1, a.valuedesc1,
  a.valueid2, a.valuedesc2,
  a.valueid3, a.valuedesc3,
  a.valueid4, a.valuedesc4,
  a.valueid5, a.valuedesc5,
  a.valueid6, a.valuedesc6,
  a.valueid7, a.valuedesc7,
  a.valueid8, a.valuedesc8,
  a.valueid9, a.valuedesc9,
  a.valueid10, a.valuedesc10,
  a.valueid11, a.valuedesc11,
  a.valueid12, a.valuedesc12,
  a.valueid13, a.valuedesc13,
  a.valueid14, a.valuedesc14,
  a.VALUEID15 , a.VALUEDESC15
      
FROM  ListQry_1 (@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @value12, @value13, @Value14,@Value15,@Value16,@Value17,@Value18) as q, ainfo as a
Where [q].[ANO] = [a].[ANO]
)
    

GO

CREATE function [dbo].[ListQry_1b] (@Value1 as varchar(255), @Value2 as 
varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as 
varchar(255), @Value6 varchar(255), @Value7 as varchar(255), @Value8 as 
varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),@Value11 
as varchar(255), @value12 as varchar(255), @value13 as varchar(255), @Value14 as varchar(255),@Value15 as varchar(255),@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255)) 
RETURNS Table 
AS RETURN 
( 
SELECT Cast(0 as bit) as ProcessFlag, 
Cover.CoverNo as [Quotation No], 
Acceptance.RegNo as [CI No], 
Acceptance.PolicyNo as [Policy No], 
Acceptance.CertificateNo as [Certificate No], 
Cast(Acceptance.AName as varchar(128)) as Insured, 
Profile.Name as [Policy Holder], 
Cover.CoverDate as [Cover Date], 
Cover.Expdate as [Expiry Date], 
Acceptance.PolicyDate as [Issued Date], 
Acceptance.SDate as Start, 
Acceptance.EDate as [End], 
Acceptance.AStatus, 
Acceptance.AType, 
Acceptance.ANO, 
Acceptance.LANO, 
Acceptance.RefNo, 
Cover.ProformaF, 
acceptance.CNO 
From cover, acceptance, Profile 
Where cover.CNO = acceptance.CNO And cover.PHolder = Profile.ID 
And (Acceptance.AName Like @Value1) 
And (Cover.CoverNo Like @Value2 Or Cover.CoverNo is null) 
and (Cover.CoverDate = @Value3 Or Cover.CoverDate is null or @Value3 = '') 
And (Cover.ExpDate = @Value4 Or Cover.ExpDate is null or @Value4 = '') 
And (Acceptance.PolicyNo Like @Value5 Or Acceptance.PolicyNo is null) 
And (Acceptance.CertificateNo Like @Value6 Or Acceptance.CertificateNo is null) 
And (Acceptance.PolicyDate = @Value7 Or Acceptance.PolicyDate is null or @Value7 = '' or Acceptance.PolicyDate Between @Value7 and @Value16) 
And (Acceptance.RegDate = @Value17 Or Acceptance.RegDate is null or @Value17 = '' or Acceptance.RegDate Between @Value17 and @Value18) 
And Acceptance.AType Like @Value8 
And Acceptance.AStatus Like @Value9 
And Acceptance.RegNo Like @Value10 
And (Profile.Name Like @Value11 or Profile.Name is null) 
and cover.toc like @value12 
and (acceptance.refno like @value13 or acceptance.refno is null) 
and (Acceptance.Matters=@Value14 or @Value14='') 
and (acceptance.ano = acceptance.lano or acceptance.lano = -1) 
And (Cover.ISType<>'T' or Cover.ProformaF=1) 
) 


GO

CREATE function [dbo].[ListQry_1b_a] (@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255), @Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255),
@Value9 as varchar(255), @Value10 as varchar(255),@Value11 as varchar(255), @value12 as varchar(255), @value13 as varchar(255), @Value14 as varchar(255),@Value15 as varchar(255),@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255))
RETURNS Table
AS RETURN
(
SELECT Cast(0 as bit) as ProcessFlag, 
  [q].[Quotation No],
  [q]. [CI No],
  [q].[Policy No],
  [q].[Certificate No],
  [q].[Insured],
  [q].[Policy Holder],
  [q].[Cover Date],
  [q].[Expiry Date],
  [q].[Issued Date],
  [q].[Start],
  [q].[End],
  [q].[AStatus],
  [q].[AType],
  [q].[ANO],
  [q].[LANO],
  q.RefNo,
  q.ProformaF,
  q.cno,
  a.valueid1, a.valuedesc1,
  a.valueid2, a.valuedesc2,
  a.valueid3, a.valuedesc3,
  a.valueid4, a.valuedesc4,
  a.valueid5, a.valuedesc5,
  a.valueid6, a.valuedesc6,
  a.valueid7, a.valuedesc7,
  a.valueid8, a.valuedesc8,
  a.valueid9, a.valuedesc9,
  a.valueid10, a.valuedesc10,
  a.valueid11, a.valuedesc11,
  a.valueid12, a.valuedesc12,
  a.valueid13, a.valuedesc13,
  a.valueid14, a.valuedesc14,
  a.VALUEID15 , a.VALUEDESC15
      
FROM  ListQry_1b (@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @value12, @value13, @Value14,@Value15,@Value16,@Value17,@Value18) as q, ainfo as a
Where [q].[ANO] = [a].[ANO]
)
    
    

GO

CREATE function [dbo].[ListQry_3] (      
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),       
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),      
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),      
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255)      
)            
RETURNS Table            
AS RETURN            
(            
SELECT   
Cover.COVERNO,            
Cast(Acceptance.AName as varchar(128)) as Insured,            
Cover.CNO,            
Cover.CStatus,            
Acceptance.lANO,            
Acceptance.ANO,            
Acceptance.REGNO,            
Acceptance.ADATE,            
Acceptance.LUSERID as USERID,            
SysTab.Currency,            
Acceptance.ASTATUS,            
Acceptance.ATYPE,            
Acceptance.SDate,            
Acceptance.EDate,            
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,            
Cover.ISType,            
Acceptance.Renewal,            
Acceptance.ESeqNo,            
Acceptance.PolicyNo,            
Acceptance.CertificateNo,            
Acceptance.RefNo,            
Cover.ProformaF,            
Acceptance.ANO as ANO_INFO 
FROM  Cover, Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Profile, SysTab
WHERE  Cover.CNO=Acceptance.CNO   
and cover.PHolder = Profile.ID            
And (@Value1='%' or Acceptance.AName Like @Value1)           
And (@Value2='%' or Cover.CoverNo Like @Value2)            
And (Cover.CoverDate = @Value3 or @Value3='')            
And (Cover.ExpDate = @Value4 or @Value4='')            
And (@Value5='%' or Acceptance.PolicyNo Like @Value5)            
And (@Value6='%' or Acceptance.CertificateNo Like @Value6)            
And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)            
And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)            
And Acceptance.AType Like @Value8            
And Acceptance.AStatus Like @Value9            
And (@Value10='%' or Acceptance.RegNo Like @Value10)
And (@Value11='%' or Profile.Name Like @Value11)           
and (@Value12='%' or cover.toc like @Value12)            
and (@Value13='%' or acceptance.refno like @Value13)            
and (Acceptance.ano = acceptance.lano or Acceptance.LANO=-1)            
and (Acceptance.Matters=@Value14 or @Value14='')            
And (Cover.ISType<>'T' or Cover.ProformaF=1)            
And (Acceptance.BatchNo Like @Value19)       
And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')      
And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance.CANO from Acceptance CAcceptance Where CAcceptance.CANO=Acceptance.ANO)))          
And ((Cover.TBAF=1 and @Value22='1') or @Value22='')      
And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))          
      
Union            
      
SELECT   
Cover.COVERNO,            
Cast(Acceptance.AName as varchar(128)) as Insured,            
Cover.CNO,            
Cover.CStatus,            
Acceptance.lANO,            
Acceptance.ANO,            
Acceptance.REGNO,            
Acceptance.ADATE,            
Acceptance.LUSERID as USERID,            
SysTab.Currency,            
Acceptance.ASTATUS,            
Acceptance.ATYPE,            
Acceptance.SDate,            
Acceptance.EDate,            
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,            
Cover.ISType,            
Acceptance.Renewal,            
Acceptance.ESeqNo,            
Acceptance.PolicyNo,            
Acceptance.CertificateNo,            
Acceptance.RefNo,            
Cover.ProformaF,            
acceptance_detail.ANO as ANO_INFO
FROM  Cover, Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Profile, acceptance as acceptance_detail, SysTab
Where cover.CNO = acceptance.CNO   
And cover.PHolder = Profile.ID            
and acceptance.ano = acceptance_detail.lano            
And (@Value1='%' or Acceptance_Detail.AName Like @Value1)          
And (@Value2='%' or Cover.CoverNo Like @Value2)           
and (Cover.CoverDate = @Value3 or @Value3='')            
And (Cover.ExpDate = @Value4 or @Value4='')            
And (@Value5='%' or Acceptance_Detail.PolicyNo Like @Value5)            
And (@Value6='%' or Acceptance_Detail.CertificateNo Like @Value6)            
And (Acceptance_Detail.PolicyDate = @Value7 or @Value7='' or Acceptance_Detail.PolicyDate Between @Value7 and @Value16)            
And (Acceptance_Detail.RegDate = @Value17 or @Value17='' or Acceptance_Detail.RegDate Between @Value17 and @Value18)            
And Acceptance_Detail.AType Like @Value8            
And Acceptance_Detail.AStatus Like @Value9            
And (@Value10='%' or Acceptance_Detail.RegNo Like @Value10)
And (@Value11='%' or Profile.Name Like @Value11)
and (@Value12='%' or cover.toc like @Value12)
and (@Value13='%' or acceptance_detail.refno like @Value13)            
and (Acceptance_detail.Matters=@Value14 or @Value14='')            
and acceptance_detail.ano <> acceptance_detail.lano and acceptance_detail.lano <> -1            
And (Cover.ISType<>'T' or Cover.ProformaF=1)            
And (Acceptance_Detail.BatchNo Like @Value19)       
And ((Acceptance_Detail.BackDatedF=1 and @Value20='1') or @Value20='')    
And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance_Detail.CANO from Acceptance CAcceptance_Detail Where CAcceptance_Detail.CANO=Acceptance_Detail.ANO)))            
And ((Cover.TBAF=1 and @Value22='1') or @Value22='')      
And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance_Detail.ANO)))          
       
Union      
       
SELECT   
CCover.COVERNO,            
Cast(CAcceptance.AName as varchar(128)) as Insured,            
CCover.CNO,            
CCover.CStatus,            
CAcceptance.lANO,            
CAcceptance.ANO,            
CAcceptance.REGNO,            
CAcceptance.ADATE,            
CAcceptance.LUSERID as USERID,            
SysTab.Currency,            
CAcceptance.ASTATUS,            
CAcceptance.ATYPE,            
CAcceptance.SDate,            
CAcceptance.EDate,            
Year(Coalesce(CRArrHeader.RDate,CAcceptance.SDate)) AS RYear,            
CCover.ISType,            
CAcceptance.Renewal,            
CAcceptance.ESeqNo,            
CAcceptance.PolicyNo,            
CAcceptance.CertificateNo,            
CAcceptance.RefNo,            
CCover.ProformaF,            
CAcceptance.ANO as ANO_INFO
FROM  Cover, Acceptance, Profile, SysTab, Cover CCover, Acceptance CAcceptance 
left Join RArrHeader CRArrHeader on (CRArrHeader.ANO=CAcceptance.ANO) 
WHERE @Value21='1' and CAcceptance.CANO=Acceptance.ANO and CCover.CNO=CAcceptance.CNO        
And (CAcceptance.ano = Cacceptance.lano or CAcceptance.LANO=-1)            
and Cover.CNO=Acceptance.CNO and cover.PHolder = Profile.ID            
And (@Value1='%' or Acceptance.AName Like @Value1)           
And (@Value2='%' or Cover.CoverNo Like @Value2)            
And (Cover.CoverDate = @Value3 or @Value3='')            
And (Cover.ExpDate = @Value4 or @Value4='')            
And (@Value5='%' or Acceptance.PolicyNo Like @Value5)            
And (@Value6='%' or Acceptance.CertificateNo Like @Value6)            
And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)            
And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)            
And Acceptance.AType Like @Value8            
And Acceptance.AStatus Like @Value9            
And (@Value10='%' or Acceptance.RegNo Like @Value10)
And (@Value11='%' or Profile.Name Like @Value11)
and (@Value12='%' or cover.toc like @Value12)
and (@Value13='%' or acceptance.refno like @Value13)            
and (Acceptance.ano = acceptance.lano or Acceptance.LANO=-1)            
and (Acceptance.Matters=@Value14 or @Value14='')            
And (Cover.ISType<>'T' or Cover.ProformaF=1)            
And (Acceptance.BatchNo Like @Value19)       
And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')      
And ((Cover.TBAF=1 and @Value22='1') or @Value22='')      
And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))          
      
Union            
      
SELECT   
CCover.COVERNO,            
Cast(CAcceptance.AName as varchar(128)) as Insured,            
CCover.CNO,            
CCover.CStatus,            
CAcceptance.lANO,            
CAcceptance.ANO,            
CAcceptance.REGNO,            
CAcceptance.ADATE,            
CAcceptance.LUSERID as USERID,            
SysTab.Currency,            
CAcceptance.ASTATUS,            
CAcceptance.ATYPE,            
CAcceptance.SDate,            
CAcceptance.EDate,            
Year(Coalesce(CRArrHeader.RDate,CAcceptance.SDate)) AS RYear,            
CCover.ISType,            
CAcceptance.Renewal,            
CAcceptance.ESeqNo,            
CAcceptance.PolicyNo,            
CAcceptance.CertificateNo,            
CAcceptance.RefNo,            
CCover.ProformaF,            
Cacceptance_detail.ANO as ANO_INFO
FROM  Cover, Acceptance, Profile, systab, acceptance as acceptance_detail, Acceptance as Cacceptance_detail, Cover CCover, Acceptance CAcceptance 
left Join RArrHeader CRArrheader on (CRArrHeader.ANO=CAcceptance.ANO) 
Where  @Value21='1' and CAcceptance_Detail.CANO=Acceptance_Detail.ANO and CAcceptance.ANO=CAcceptance_Detail.LANO and CCover.CNO=CAcceptance.CNO      
and cover.CNO = acceptance.CNO And cover.PHolder = Profile.ID             
and acceptance.ano = acceptance_detail.lano            
And (@Value1='%' or Acceptance_Detail.AName Like @Value1)          
And (@Value2='%' or Cover.CoverNo Like @Value2)           
and (Cover.CoverDate = @Value3 or @Value3='')            
And (Cover.ExpDate = @Value4 or @Value4='')            
And (@Value5='%' or Acceptance_Detail.PolicyNo Like @Value5)            
And (@Value6='%' or Acceptance_Detail.CertificateNo Like @Value6)            
And (Acceptance_Detail.PolicyDate = @Value7 or @Value7='' or Acceptance_Detail.PolicyDate Between @Value7 and @Value16)            
And (Acceptance_Detail.RegDate = @Value17 or @Value17='' or Acceptance_Detail.RegDate Between @Value17 and @Value18)            
And Acceptance_Detail.AType Like @Value8            
And Acceptance_Detail.AStatus Like @Value9            
And (@Value10='%' or Acceptance_Detail.RegNo Like @Value10)
And (@Value11='%' or Profile.Name Like @Value11)
and (@Value12='%' or cover.toc like @Value12)
and (@Value13='%' or acceptance_detail.refno like @Value13)            
and (Acceptance_detail.Matters=@Value14 or @Value14='')            
and acceptance_detail.ano <> acceptance_detail.lano and acceptance_detail.lano <> -1            
And (Cover.ISType<>'T' or Cover.ProformaF=1)            
And (Acceptance_Detail.BatchNo Like @Value19)       
And ((Acceptance_Detail.BackDatedF=1 and @Value20='1') or @Value20='')       
And ((Cover.TBAF=1 and @Value22='1') or @Value22='')      
And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance_Detail.ANO)))          
)            
  

GO

Create function [dbo].[ListQry_3_A] (  
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),   
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),  
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),  
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255)    
)        
RETURNS Table    
AS RETURN    
(    
SELECT Cast(0 as bit) as ProcessFlag,    
Q.[COVERNO],    
Q.[Insured],    
Q.[CNO],    
Q.[CStatus],    
Q.[lANO],    
Q.[ANO],    
Q.[REGNO],    
Q.[ADATE],    
Q.[USERID],    
Q.[Currency],     
Q.[ASTATUS],    
Q.[ATYPE],    
Q.[SDate],    
Q.[EDate],    
Q.RYear,    
Q.[ISType],    
Q.[Renewal],    
Q.[ESeqNo],    
Q.[PolicyNo],    
Q.[CertificateNo],    
Q.RefNo,    
Q.ProformaF,    
A.FLDID1,    
A.VALUEID1,    
A.VALUEDESC1,    
A.FLDID2,    
A.VALUEID2,    
A.VALUEDESC2,    
A.FLDID3,    
A.VALUEID3,    
A.VALUEDESC3,    
A.FLDID4,    
A.VALUEID4,    
A.VALUEDESC4,    
A.FLDID5,    
A.VALUEID5,    
A.VALUEDESC5,    
A.FLDID6,    
A.VALUEID6,    
A.VALUEDESC6,    
A.FLDID7,    
A.VALUEID7,    
A.VALUEDESC7,    
A.FLDID8,    
A.VALUEID8,    
A.VALUEDESC8,    
A.FLDID9,    
A.VALUEID9,    
A.VALUEDESC9,    
A.FLDID10,    
A.VALUEID10,    
A.VALUEDESC10,    
A.FLDID11,    
A.VALUEID11,    
A.VALUEDESC11,    
A.FLDID12,    
A.VALUEID12,    
A.VALUEDESC12,    
A.FLDID13,    
A.VALUEID13,    
A.VALUEDESC13,    
A.FLDID14,    
A.VALUEID14,    
A.VALUEDESC14,    
A.FLDID15,    
A.VALUEID15,    
a.VALUEDESC15    
From    
LISTQRY_3(@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10, @Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18, @Value19, @Value20, @Value21, @Value22, @Value23) AS Q, AINFO AS A    
Where q.ano_info = a.ANO    
)    

GO


CREATE function [dbo].[ListQry_3b] (        
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),         
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),        
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),        
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255)        
)              
RETURNS Table              
AS RETURN              
(              
SELECT   
Cover.COVERNO,              
Cast(Acceptance.AName as varchar(128)) as Insured,              
Cover.CNO,              
Cover.CStatus,              
Acceptance.lANO,              
Acceptance.ANO,              
Acceptance.REGNO,              
Acceptance.ADATE,              
Acceptance.LUSERID as USERID,              
SysTab.Currency,              
Acceptance.ASTATUS,              
Acceptance.ATYPE,              
Acceptance.SDate,              
Acceptance.EDate,              
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,              
Cover.ISType,              
Acceptance.Renewal,              
Acceptance.ESeqNo,              
Acceptance.PolicyNo,              
Acceptance.CertificateNo,              
Acceptance.RefNo,              
cover.ProformaF
FROM  Cover, Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Profile, systab
Where cover.CNO = acceptance.CNO   
And cover.PHolder = Profile.ID                     
And (@Value1='%' or Acceptance.AName Like @Value1)            
And (@Value2='%' or Cover.CoverNo Like @Value2)              
and (Cover.CoverDate = @Value3 or @Value3='')              
And (Cover.ExpDate = @Value4 or @Value4='')              
And (@Value5='%' or Acceptance.PolicyNo Like @Value5)              
And (@Value6='%' or Acceptance.CertificateNo Like @Value6)              
And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)              
And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)              
And Acceptance.AType Like @Value8              
And Acceptance.AStatus Like @Value9              
And (@Value10='%' or Acceptance.RegNo Like @Value10)
And (@Value11='%' or Profile.Name Like @Value11)
and (@Value12='%' or cover.toc like @Value12)
and (@Value13='%' or Acceptance.RefNo like @Value13)              
and (acceptance.ano = acceptance.lano or acceptance.lano = -1)              
and (Acceptance.Matters=@Value14 or @Value14='')              
And (Cover.ISType<>'T' or Cover.ProformaF=1)              
And (Acceptance.BatchNo Like @Value19)         
And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')        
And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance.CANO from Acceptance CAcceptance Where CAcceptance.CANO=Acceptance.ANO)))          
And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))           
         
union        
         
SELECT   
CCover.COVERNO,              
Cast(CAcceptance.AName as varchar(128)) as Insured,              
CCover.CNO,              
CCover.CStatus,              
CAcceptance.lANO,              
CAcceptance.ANO,              
CAcceptance.REGNO,              
CAcceptance.ADATE,              
CAcceptance.LUSERID as USERID,              
SysTab.Currency,              
CAcceptance.ASTATUS,              
CAcceptance.ATYPE,              
CAcceptance.SDate,              
CAcceptance.EDate,              
Year(Coalesce(CRArrHeader.RDate,CAcceptance.SDate)) AS RYear,              
CCover.ISType,              
CAcceptance.Renewal,              
CAcceptance.ESeqNo,              
CAcceptance.PolicyNo,              
CAcceptance.CertificateNo,              
CAcceptance.RefNo,          
Ccover.ProformaF
FROM  Cover, Acceptance, Profile, systab, Cover CCover, Acceptance CAcceptance 
left Join RArrHeader CRArrHeader on (CRArrHeader.ANO=CAcceptance.ANO) 
Where @Value21='1' and CAcceptance.CANO=Acceptance.ANO and CCover.CNO=CAcceptance.CNO          
and (Cacceptance.ano = Cacceptance.lano or Cacceptance.lano = -1)                       
and cover.CNO = acceptance.CNO And cover.PHolder = Profile.ID              
And (@Value1='%' or Acceptance.AName Like @Value1)            
And (@Value2='%' or Cover.CoverNo Like @Value2)              
and (Cover.CoverDate = @Value3 or @Value3='')              
And (Cover.ExpDate = @Value4 or @Value4='')              
And (@Value5='%' or Acceptance.PolicyNo Like @Value5)              
And (@Value6='%' or Acceptance.CertificateNo Like @Value6)              
And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)              
And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)              
And Acceptance.AType Like @Value8              
And Acceptance.AStatus Like @Value9              
And (@Value10='%' or Acceptance.RegNo Like @Value10)
And (@Value11='%' or Profile.Name Like @Value11)
and (@Value12='%' or cover.toc like @Value12)
and (@Value13='%' or Acceptance.RefNo like @Value13)              
and (acceptance.ano = acceptance.lano or acceptance.lano = -1)              
and (Acceptance.Matters=@Value14 or @Value14='')              
And (Cover.ISType<>'T' or Cover.ProformaF=1)              
And (Acceptance.BatchNo Like @Value19)         
And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')        
And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))          
        
)                              

GO

Create function [dbo].[ListQry_3b_a] (  
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),   
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),  
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),  
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255)    
)        
RETURNS Table    
AS RETURN    
(    
SELECT Cast(0 as bit) as ProcessFlag,    
[q].[COVERNO],    
[q].[Insured],    
[q].[CNO],    
[q].[CStatus],    
[q].[lANO],    
[q].[ANO],    
[q].[REGNO],    
[q].[ADATE],    
[q].[USERID],    
[q].[Currency],     
[q].[ASTATUS],    
[q].[ATYPE],    
[q].[SDate],    
[q].[EDate],    
[q].RYear,    
[q].[ISType],    
[q].[Renewal],    
[q].[ESeqNo],    
[q].[PolicyNo],    
[q].[CertificateNo],    
[q].[RefNo],    
[q].[ProformaF],    
a.valueid1, a.valuedesc1,    
a.valueid2, a.valuedesc2,    
a.valueid3, a.valuedesc3,    
a.valueid4, a.valuedesc4,    
a.valueid5, a.valuedesc5,    
a.valueid6, a.valuedesc6,    
a.valueid7, a.valuedesc7,    
a.valueid8, a.valuedesc8,    
a.valueid9, a.valuedesc9,    
a.valueid10, a.valuedesc10,    
a.valueid11, a.valuedesc11,    
a.valueid12, a.valuedesc12,    
a.valueid13, a.valuedesc13,    
a.valueid14, a.valuedesc14,    
a.VALUEID15 , a.VALUEDESC15    
FROM  ListQry_3b (@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18,@Value19,@Value20,@Value21, @Value22, @Value23) as q, ainfo as a    
Where [q].[ANO] = [a].[ANO]    
        
)    
GO

CREATE function [dbo].[MListQry_1](@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@Value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255))  
returns table  
AS return  
(  
SELECT   Cast(0 as bit) as ProcessFlag,    
  [Cover].[CoverNo] AS [Quotation No],   
  [Cover].[VSeqNo],   
  [Acceptance].[RegNo] AS [CI No],   
  [Acceptance].[PolicyNo] AS [Policy No],   
  [Acceptance].[CertificateNo] AS [Certificate No],   
  [Cover].[Insured],   
  [Profile].[Name] AS [Proposer],  
  [Cover].[CoverDate] AS [Cover Date],   
  [Cover].[Expdate] AS [Expiry Date],   
  [Acceptance].[PolicyDate] AS [Policy Date],   
  [Acceptance].[SDate] AS Start,   
  [Acceptance].[EDate] AS [End],   
  [Acceptance].[AType],   
  [Acceptance].[AStatus],   
  [Acceptance].[ANO],   
  [Acceptance].[LANO],  
  [Cover].[CStatus],  
  acceptance.ano as ano_info  
FROM  Cover, Acceptance, [Profile]  
WHERE  [Cover].[CNO]=[Acceptance].[CNO]   
  And Cover.PHOLDER=[Profile].[ID]  
  And (Acceptance.AName Like @Value1)
  And ([Cover].[CoverNo] Like @Value2 Or ([Cover].[CoverNo] is null))   
  And (cover.coverdate=@Value3 Or (cover.coverdate IS NULL) Or cover.coverdate='' or @Value3='')  
  And (cover.expdate=@Value4 Or (cover.expdate IS NULL) Or cover.expdate='' or @Value4='')    
  And ([Acceptance].[PolicyNo] Like @Value5 Or ([Acceptance].[PolicyNo] is null))   
  And ([Acceptance].[CertificateNo] Like @Value6 Or ([Acceptance].[CertificateNo] is null))   
  And (acceptance.policydate=@Value7 Or (acceptance.policydate IS NULL) Or acceptance.policydate='' or @Value7='')  
  And ([Cover].[CStatus] Like @Value8)   
  And ([Acceptance].[RegNo] Like @Value9)   
  And ([Profile].[Name] like @Value10 or [Profile].[Name] is null)  
  and cover.toc like @Value11  
  and acceptance.ano = acceptance.lano  
  And [Cover].[ISType]<>'T'  
union   
SELECT   Cast(0 as bit) as ProcessFlag,   
  [Cover].[CoverNo] AS [Quotation No],   
  [Cover].[VSeqNo],   
  [Acceptance].[RegNo] AS [CI No],   
  [Acceptance].[PolicyNo] AS [Policy No],   
  [Acceptance].[CertificateNo] AS [Certificate No],   
  [Cover].[Insured],   
  [Profile].[Name] AS [Proposer],  
  [Cover].[CoverDate] AS [Cover Date],   
  [Cover].[Expdate] AS [Expiry Date],   
  [Acceptance].[PolicyDate] AS [Policy Date],   
  [Acceptance].[SDate] AS Start,   
  [Acceptance].[EDate] AS [End],   
  [Acceptance].[AType],   
  [Acceptance].[AStatus],   
  [Acceptance].[ANO],   
  [Acceptance].[LANO],  
  [Cover].[CStatus],  
  acceptance.ano as ano_info  
FROM  Cover, Acceptance, [Profile]  
WHERE  [Cover].[CNO]=[Acceptance].[CNO]   
  And Cover.PHOLDER=[Profile].[ID]  
  And (Acceptance.AName Like @Value1)  
  And ([Cover].[CoverNo] Like @Value2 Or ([Cover].[CoverNo] is null))   
  And (cover.coverdate=@Value3 Or (cover.coverdate IS NULL) Or cover.coverdate='' or @Value3='')  
  And (cover.expdate=@Value4 Or (cover.expdate IS NULL) Or cover.expdate='' or @Value4='')    
  And ([Acceptance].[PolicyNo] Like @Value5 Or ([Acceptance].[PolicyNo] is null))   
  And ([Acceptance].[CertificateNo] Like @Value6 Or ([Acceptance].[CertificateNo] is null))   
  And (acceptance.policydate=@Value7 Or (acceptance.policydate IS NULL) Or acceptance.policydate='' or @Value7='')  
  And ([Cover].[CStatus] Like @Value8)   
  And ([Acceptance].[RegNo] Like @Value9)   
  And ([Profile].[Name] like @Value10 or [Profile].[Name] is null)  
  and cover.toc like @Value11  
  and acceptance.lano = -1  
  And [Cover].[ISType]<>'T'  
union  
SELECT   Cast(0 as bit) as ProcessFlag,   
  [Cover].[CoverNo] AS [Quotation No],   
  [Cover].[VSeqNo],   
  [Acceptance_detail].[RegNo] AS [CI No],   
  [Acceptance_detail].[PolicyNo] AS [Policy No],   
  [Acceptance_detail].[CertificateNo] AS [Certificate No],   
  [Cover].[Insured],   
  [Profile].[Name] AS [Proposer],  
  [Cover].[CoverDate] AS [Cover Date],   
  [Cover].[Expdate] AS [Expiry Date],   
  [Acceptance_detail].[PolicyDate] AS [Policy Date],   
  [Acceptance_detail].[SDate] AS Start,   
  [Acceptance_detail].[EDate] AS [End],   
  [Acceptance_detail].[AType],   
  [Acceptance_detail].[AStatus],   
  [Acceptance_detail].[ANO],   
  [acceptance_detail].[LANO],  
  [Cover].[CStatus],  
  acceptance_detail.ano as ano_info  
FROM  Cover, Acceptance, [Profile], acceptance as acceptance_detail  
WHERE  [Cover].[CNO]=[Acceptance_detail].[CNO]   
  And Cover.PHOLDER=[Profile].[ID]  
  and acceptance.ano = acceptance_detail.lano  
  And (Acceptance_detail.AName Like @Value1)
  And ([Cover].[CoverNo] Like @Value2 Or ([Cover].[CoverNo] is null))   
  And (cover.coverdate=@Value3 Or (cover.coverdate IS NULL) Or cover.coverdate='' or @Value3='')  
  And (cover.expdate=@Value4 Or (cover.expdate IS NULL) Or cover.expdate='' or @Value4='')    
  And ([Acceptance_detail].[PolicyNo] Like @Value5 Or ([Acceptance_detail].[PolicyNo] is null))   
  And ([Acceptance_detail].[CertificateNo] Like @Value6 Or ([Acceptance_detail].[CertificateNo] is null))   
  And (acceptance_detail.policydate=@Value7 Or (acceptance_detail.policydate IS NULL) Or acceptance_detail.policydate='' or @Value7='')  
  And ([Cover].[CStatus] Like @Value8)   
  And ([Acceptance_detail].[RegNo] Like @Value9)   
  And ([Profile].[Name] like @Value10 or [Profile].[Name] is null)  
  and cover.toc like @Value11  
  and acceptance_detail.ano <> acceptance_detail.lano and acceptance_detail.lano <> -1  
  And [Cover].[ISType]<>'T'  
)  
  

GO

CREATE function [dbo].[MListQry_1b](@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@Value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255))  
returns table  
AS return  
(  
SELECT    Cast(0 as bit) as ProcessFlag,   
  [Cover].[CoverNo] AS [Quotation No],   
  [Cover].[VSeqNo],   
  [Acceptance].[RegNo] AS [CI No],   
  [Acceptance].[PolicyNo] AS [Policy No],   
  [Acceptance].[CertificateNo] AS [Certificate No],   
  [Cover].[Insured],   
  [Profile].[Name] AS [Proposer],  
  [Cover].[CoverDate] AS [Cover Date],   
  [Cover].[Expdate] AS [Expiry Date],   
  [Acceptance].[PolicyDate] AS [Policy Date],   
  [Acceptance].[SDate] AS Start,   
  [Acceptance].[EDate] AS [End],   
  [Acceptance].[AType],   
  [Acceptance].[AStatus],   
  [Acceptance].[ANO],   
  [Acceptance].[LANO],  
  [Cover].[CStatus]  
FROM  Cover, Acceptance, [Profile]  
WHERE  [Cover].[CNO]=[Acceptance].[CNO]   
  And Cover.PHOLDER=[Profile].[ID]  
  And (Acceptance.AName Like @Value1)
  And ([Cover].[CoverNo] Like @Value2 Or ([Cover].[CoverNo] is null))   
  And (cover.coverdate=@Value3 Or cover.coverdate is NULL or @Value3='')  
  And (cover.expdate=@Value4 Or cover.expdate is NULL or @Value4='')    
  And ([Acceptance].[PolicyNo] Like @Value5 Or ([Acceptance].[PolicyNo] is null))   
  And ([Acceptance].[CertificateNo] Like @Value6 Or ([Acceptance].[CertificateNo] is null))   
  And (acceptance.policydate=@Value7 Or acceptance.policydate is NULL or @Value7='')  
  And ([Cover].[CStatus] Like @Value8)   
  And ([Acceptance].[RegNo] Like @Value9)   
  And ([Profile].[Name] like @Value10 or [Profile].[Name] is null)  
  and cover.toc like @Value11  
  And ([Acceptance].[ANO] = [Acceptance].[LANO] Or [Acceptance].[LANO] = -1)   
  And [Cover].[ISType]<>'T'  
)  
  
  

GO

CREATE function [dbo].[MListQry_3] (@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255)) 
RETURNS Table 
AS return 
( 
SELECT 
Cast(0 as bit) as ProcessFlag, 
Cover.COVERNO, 
Cover.Insured, 
Cover.CNO, 
Cover.CStatus, 
Cover.VSeqNo, 
Acceptance.lANO, 
Acceptance.ANO, 
Acceptance.REGNO, 
Acceptance.ADATE, 
Acceptance.USERID, 
SysTab.Currency, 
QPCalc.TSI, 
QPCalc.OurShare, 
QPCalc.Gross, 
Acceptance.ASTATUS, 
Acceptance.ATYPE, 
Acceptance.SDate, 
Acceptance.EDate, 
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
Cover.ISType, 
Acceptance.Renewal, 
Acceptance.ESeqNo, 
Acceptance.PolicyNo, 
acceptance.ano as ano_info 
FROM  Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Profile 
Where cover.CNO = acceptance.CNO 
And Cover.PHOLDER=Profile.ID 
And (Acceptance.AName Like @Value1) 
And (Cover.CoverNo Like @Value2 Or (Cover.CoverNo is null)) 
and (Cover.CoverDate = @Value3 Or (Cover.CoverDate is null) or @Value3 = '') 
And (Cover.ExpDate = @Value4 Or (Cover.ExpDate is null) or @Value4 = '') 
And (Acceptance.PolicyNo Like @Value5 Or (Acceptance.PolicyNo is null)) 
And (Acceptance.CertificateNo Like @Value6 Or (Acceptance.CertificateNo is null)) 
and (Acceptance.PolicyDate = @Value7 Or (Acceptance.PolicyDate is null) or @Value7 = '') 
And (Cover.CStatus Like @Value8) 
And (Acceptance.RegNo Like @Value9) 
And (Profile.Name Like @Value10 or Profile.ID is null) 
and cover.toc like @Value11 
And (Acceptance.LANO = -1) 
And Cover.ISType<>'T' 

Union All 

SELECT 
Cast(0 as bit) as ProcessFlag, 
Cover.COVERNO, 
Cover.Insured, 
Cover.CNO, 
Cover.CStatus, 
Cover.VSeqNo, 
Acceptance.lANO, 
Acceptance.ANO, 
Acceptance.REGNO, 
Acceptance.ADATE, 
Acceptance.USERID, 
SysTab.Currency, 
0 as TSI, 
0 as OurShare, 
0 as Gross, 
Acceptance.ASTATUS, 
Acceptance.ATYPE, 
Acceptance.SDate, 
Acceptance.EDate, 
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
Cover.ISType, 
Acceptance.Renewal, 
Acceptance.ESeqNo, 
Acceptance.PolicyNo, 
acceptance_detail.ano as ano_info 
From Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Cover, SysTab, Profile, acceptance as acceptance_detail 
Where cover.CNO = acceptance.CNO 
And Cover.PHOLDER=Profile.ID 
and acceptance.ano = acceptance_detail.lano 
And (Acceptance_Detail.AName Like @Value1) 
And (Cover.CoverNo Like @Value2 Or (Cover.CoverNo is null)) 
and (Cover.CoverDate = @Value3 Or (Cover.CoverDate is null) or @Value3 = '') 
And (Cover.ExpDate = @Value4 Or (Cover.ExpDate is null) or @Value4 = '') 
And (Acceptance_Detail.PolicyNo Like @Value5 Or (Acceptance_Detail.PolicyNo is null)) 
And (Acceptance_Detail.CertificateNo Like @Value6 Or (Acceptance_Detail.CertificateNo is null)) 
and (Acceptance_Detail.PolicyDate = @Value7 Or (Acceptance_Detail.PolicyDate is null) or @Value7 = '') 
And (Cover.CStatus Like @Value8) 
And (Acceptance_Detail.RegNo Like @Value9) 
And (Profile.Name Like @Value10 or Profile.ID is null) 
and cover.toc like @Value11 
And (Acceptance_detail.ANO <> Acceptance_detail.LANO and Acceptance_detail.LANO <> -1) 
And Cover.ISType<>'T' 
) 


GO

CREATE function [dbo].[MListQry_3_a](@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255))   
returns table  
as return  
(  
SELECT   Cast(0 as bit) as ProcessFlag,   
  q.[CoverNo],   
  q.[Insured],   
  q.[CNO],   
  q.[CStatus],   
  q.VSeqNo,   
  q.[lANO],   
  q.[ANO],   
  q.[REGNO],   
  q.[ADATE],   
  q.[USERID],   
  q.[Currency],   
  q.[TSI],   
  q.[OurShare],   
  q.[Gross],   
  q.[ASTATUS],   
  q.[ATYPE],   
  q.[SDate],   
  q.[EDate],   
  q.RYear,   
  q.[ISType],   
  q.[Renewal],   
  q.[ESeqNo],   
  q.[PolicyNo],  
  a.valueid1, a.valuedesc1,  
  a.valueid2, a.valuedesc2,  
  a.valueid3, a.valuedesc3,  
  a.valueid4, a.valuedesc4,  
  a.valueid5, a.valuedesc5,  
  a.valueid6, a.valuedesc6,  
  a.valueid7, a.valuedesc7,  
  a.valueid8, a.valuedesc8,  
  a.valueid9, a.valuedesc9,  
  a.valueid10, a.valuedesc10,  
  a.valueid11, a.valuedesc11,  
  a.valueid12, a.valuedesc12,  
  a.valueid13, a.valuedesc13,  
  a.valueid14, a.valuedesc14,  
  a.valueid15, a.valuedesc15    
FROM  MListQry_3(@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10, @Value11, @Value12) as q, ainfo as a  
WHERE  q.ano_info = a.ano  
)  
  

GO

CREATE function [dbo].[MListQry_3b] (@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255)) 
RETURNS Table 
as return 
( 
SELECT 
Cast(0 as bit) as ProcessFlag, 
Cover.COVERNO, 
Cover.Insured, 
Cover.CNO, 
Cover.CStatus, 
Cover.VSeqNo, 
Acceptance.lANO, 
Acceptance.ANO, 
Acceptance.REGNO, 
Acceptance.ADATE, 
Acceptance.USERID, 
SysTab.Currency, 
QPCalc.TSI, 
QPCalc.OurShare, 
QPCalc.Gross, 
Acceptance.ASTATUS, 
Acceptance.ATYPE, 
Acceptance.SDate, 
Acceptance.EDate, 
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
Cover.ISType, 
Acceptance.Renewal, 
Acceptance.ESeqNo, 
acceptance.PolicyNo 
FROM  Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Profile 
Where cover.CNO = acceptance.CNO 
And Cover.PHOLDER=Profile.ID 
And (Acceptance.AName Like @Value1) 
And (Cover.CoverNo Like @Value2 Or (Cover.CoverNo is null)) 
and (Cover.CoverDate = @Value3 Or (Cover.CoverDate is null) or @Value3 = '') 
And (Cover.ExpDate = @Value4 Or (Cover.ExpDate is null) or @Value4 = '') 
And (Acceptance.PolicyNo Like @Value5 Or (Acceptance.PolicyNo is null)) 
And (Acceptance.CertificateNo Like @Value6 Or (Acceptance.CertificateNo is null)) 
and (Acceptance.PolicyDate = @Value7 Or (Acceptance.PolicyDate is null) or @Value7 = '') 
And (Cover.CStatus Like @Value8) 
And (Acceptance.RegNo Like @Value9) 
And (Profile.Name Like @Value10 or Profile.ID is null) 
And (Cover.TOC Like @Value11) 
And (Acceptance.ANO=Acceptance.lANO Or Acceptance.lANO=-1) 
And Cover.ISType<>'T' 
) 


GO


CREATE FUNCTION [dbo].[OPEN_ITEM_ALLOCATED](@P_VOUCHER VARCHAR(20))      
RETURNS TABLE  AS      
RETURN (      
                                
--SL from Overbooking Payment and Adjustment Payment      
Select SL.Voucher, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.Voucher as Doc_No, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end as Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,      
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal_OC else -SL.Nominal_OC end*SL.Rate)) as Nominal_OC      
from pSL SL, pVoucher VoucherP, pVoucher VoucherR, VPattern      
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('B') and VoucherP.SL_Cat='P' and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher and SL.PaymentF=1      
and VPattern.VType=VoucherR.VType and ((VPattern.Debit=SL.hint and VoucherR.DebtorF=1) or (VPattern.Credit=SL.hint and VoucherR.CreditorF=1))      
and (VoucherP.Voucher=@P_Voucher or @P_Voucher='')  
Group By SL.Voucher, VoucherR.Branch, VoucherR.Date, VoucherR.Currency, VoucherP.Voucher, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end, SL.Account      
                          
Union All      
                      
--SL from Sub Ledger Payment Voucher and OverPaid      
Select SL.Voucher, VoucherR.Branch, SL.Doc_Date, SL.Doc_CCY, SL.Doc_No as Doc_No, SL.Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,      
(Case When VoucherR.SL_Cat='O'      
then (case when VoucherR.DebtorF=VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)      
else (case when VoucherR.DebtorF<>VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)      
end) as Nominal_OC      
from pSL SL, pVoucher VoucherP, pVoucher VoucherR      
Where VoucherR.SL_Cat in ('O','P','A','B') and VoucherP.SL_Cat='P' and VoucherR.Voucher=SL.Voucher and SL.Doc_No=VoucherP.Voucher and SL.PaymentF=1      
and (VoucherP.Voucher=@P_Voucher or @P_Voucher='')  
                        
)      
                  
GO

CREATE  function [dbo].[Open_Item_Voucher_N](@P_Branch Varchar(5))  
RETURNS Table  
AS RETURN  
(  
select Voucher.Voucher, Voucher.Branch, Voucher.Payment_CC, Voucher.Nominal_CC-Voucher.Diff_CC as Nominal_CC from nVoucher Voucher Where Voucher.Branch Like @P_Branch+'%'  
)  
GO
CREATE function [dbo].[Open_Item_Voucher_P](@P_Branch Varchar(5))    
RETURNS Table    
AS RETURN    
(    
Select Voucher.Voucher,Voucher.Branch, max(Voucher.Payment_CC) as Payment_CC, Sum(SL.Nominal) as Nominal_CC    
from pVoucher Voucher, pSLSum SL    
where Voucher.Voucher=SL.Voucher and SL.Branch like @P_Branch+'%'    
group by Voucher.Voucher, Voucher.Branch    
)    
        
GO

CREATE function [dbo].[Open_Item_Voucher](@P_Branch Varchar(5))
RETURNS Table
AS RETURN
(
  
Select Voucher, Branch, Payment_CC, Nominal_CC from Open_Item_Voucher_N(@P_Branch)
Union All
Select Voucher, Branch, Payment_CC, Nominal_CC from Open_Item_Voucher_P(@P_Branch)
)
   
GO

CREATE FUNCTION [dbo].[R_SL_ALLOCATED_BY_VOUCHER](@P_PDate as smalldatetime, @P_Voucher as varchar(20)='')                             
RETURNS TABLE  AS                               
RETURN (                             
                     
--SL from Payment Voucher                           
Select SL.Voucher, SL.Branch, SL.Voucher as Doc_No, SL.Account, max(SL.Hint) as Hint, sum(SL.Rate*SL.Nominal_OC) as Nominal_OC
From     
(    
--Part Of OSL Functions    
Select pSL.Voucher, pSL.Doc_No, pSL.Doc_Date, pSL.Doc_CCY, pSL.Nominal_OC, pSL.CT, pSL.Nominal, pSL.Remarks, pSL.Hint,          
Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end as PaymentF,          
Case When OSL.Account is null then pSL.Account else OSL.Account end as Account,          
Case When OBranch.Branch is null then pVoucher.Branch else OBranch.Branch end as Branch, pSL.Nominator, pSL.Denominator, pSL.Rate, pSL.SortNo, pSL.pVoucher        
From dbo.pSL          
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)          
Left join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account)          
Left Join dbo.pVoucher OVoucher on (OBranch.Branch=OVoucher.Branch and OVoucher.RefNo=pSL.Voucher and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE')          
Left join dbo.pSL OSL on (OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo))          
Where pVoucher.SL_Cat in ('P') and Coalesce(OSL.PaymentF, pSL.PaymentF)=1 and pVoucher.Date<=@P_PDate    
and (pSL.Voucher=@P_Voucher or @P_Voucher='')    
) SL, pVoucher Voucher    
Where SL.Voucher=Voucher.Voucher     
Group By SL.Voucher, SL.Branch, SL.Voucher, SL.Account
                           
union all                           
                           
--SL from Overbooking Payment and Adjustment Payment                           
Select SL.Voucher, VoucherR.Branch, VoucherP.Voucher as Doc_No, SL.SAccount as Account, MAX(SL.Hint) AS HINT,
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal_OC else -SL.Nominal_OC end*SL.Rate)) as Nominal_OC                           
from pSL SL, pVoucher VoucherP, pVoucher VoucherR
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('B','A') and VoucherP.SL_Cat='P' and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher and SL.PaymentF=1 and VoucherR.Date<=@P_PDate           
and (VoucherP.Voucher=@P_Voucher or @P_Voucher='')
Group By SL.Voucher, VoucherR.Branch, VoucherP.Voucher, SL.SAccount
                     
union all                           
                           
--SL from Adjustment Overbooking                           
Select SL.Voucher, VoucherR.Branch, VoucherP.RefNo as Doc_No, SL.SAccount as Account, MAX(SL.Hint) AS HINT,
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal_OC else -SL.Nominal_OC end*SL.Rate)) as Nominal_OC                           
from pSL SL, pVoucher VoucherP, pVoucher VoucherR
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('A') and VoucherP.SL_Cat in ('B') and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher and SL.PaymentF=1 and VoucherR.Date<=@P_PDate    
and (VoucherP.RefNo=@P_Voucher or @P_Voucher='')
Group By SL.Voucher, VoucherR.Branch, VoucherP.RefNo, SL.SAccount
                           
union all                           
                           
--SL from Sub Ledger Payment Voucher and OverPaid                           
Select SL.Voucher, VoucherR.Branch, SL.Doc_No as Doc_No, SL.Account, SL.Hint,
(Case When VoucherR.SL_Cat='O'                            
then (case when VoucherR.DebtorF=VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                            
else (case when VoucherR.DebtorF<>VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                           
end) as Nominal_OC                           
from pSL SL, pVoucher VoucherP, pVoucher VoucherR                           
Where VoucherR.SL_Cat in ('O','P','A','B') and VoucherP.SL_Cat in ('P') and VoucherR.Voucher=SL.Voucher and SL.Doc_No=VoucherP.Voucher and SL.PaymentF=1 and VoucherR.Date<=@P_PDate                          
and (SL.Doc_No=@P_Voucher or @P_Voucher='')
                             
)       

GO
CREATE function [dbo].[OS_SUSPEND] (@P_Voucher Varchar(20))                      
RETURNS Table                      
AS RETURN                      
(                      
SELECT VOUCHER.VOUCHER, VOUCHER.DATE, VOUCHER.CURRENCY, VOUCHER.PROACC, VOUCHER.DEBTORF,VOUCHER.CREDITORF,VOUCHER.SL_CAT,                      
CASE WHEN PV.VOUCHER IS NULL THEN VOUCHER.BRANCH ELSE PV.BRANCH END AS BRANCH, VOUCHER.REFNO,VOUCHER.REFDATE, VOUCHER.DOCNO,VOUCHER.VTYPE, VOUCHER.REMARKS, VOUCHER.REFTYPE, VOUCHER.ACCOUNTNO, ' ' as A_RefNo,                      
PV.NOMINAL_CC AS NOMINAL,                      
PV.PAYMENT_CC AS PAYMENT,                      
PV.NOMINAL_CC-PV.PAYMENT_CC AS OUTSTANDING,
PV.ACCOUNT,
PV.HINT
FROM pVoucher VOUCHER                      
Inner JOIN VType ON (VType.VType=Voucher.VType and VType.Code<>'INTERBANK')                  
Inner JOIN             
(            
SELECT VOUCHER, BRANCH, ACCOUNT, MAX(HINT) AS HINT, SUM(NOMINAL_CC) AS NOMINAL_CC, SUM(PAYMENT_CC) AS PAYMENT_CC            
FROM            
(            
SELECT VOUCHER, BRANCH, ACCOUNT, HINT, SL.NOMINAL AS NOMINAL_CC,0 as PAYMENT_CC FROM PSLSUM SL WHERE (SL.VOUCHER=@P_VOUCHER OR @P_VOUCHER='') 
Union All            
SELECT PVOUCHER.VOUCHER, SL.BRANCH, SL.ACCOUNT, MAX(SL.HINT) AS HINT, 0 as NOMINAL_CC, SUM(SL.NOMINAL_OC) AS PAYMENT_CC 
FROM R_SL_ALLOCATED_BY_VOUCHER(GetDate(),@P_VOUCHER) SL, PVOUCHER
WHERE PVOUCHER.NPAYMENT<>0 and PVOUCHER.VOUCHER=SL.DOC_NO AND (PVOUCHER.VOUCHER=@P_VOUCHER OR @P_VOUCHER='') 
Group By PVOUCHER.VOUCHER, SL.BRANCH, SL.ACCOUNT
) PV GROUP BY VOUCHER, BRANCH, ACCOUNT            
) PV ON (PV.VOUCHER=VOUCHER.VOUCHER)            
WHERE VOUCHER.STATUS<>'N' and VOUCHER.REQUESTF=0 AND (VOUCHER.VOUCHER=@P_VOUCHER OR @P_VOUCHER='')    
AND ROUND(PV.NOMINAL_CC-PV.PAYMENT_CC,4)<>0            
)   

GO

CREATE Function [dbo].[oSL](@P_Voucher varchar(20)) 
RETURNS Table 
as Return 
( 
Select pSL.Voucher, pSL.Doc_No, pSL.Doc_Date, pSL.Doc_CCY, pSL.Nominal_OC, pSL.CT, pSL.Nominal, pSL.Remarks, pSL.Hint, 
Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end as PaymentF, 
Case When OSL.Account is null then pSL.Account else OSL.Account end as Account, 
Case When OBranch.Branch is null then pVoucher.Branch else OBranch.Branch end as Branch, pSL.Nominator, pSL.Denominator, pSL.Rate, pSL.SortNo, pSL.pVoucher 
From dbo.pSL 
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher) 
Left join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account) 
Left Join dbo.pVoucher OVoucher on (OBranch.Branch=OVoucher.Branch and OVoucher.RefNo=pSL.Voucher and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE') 
Left join dbo.pSL OSL on (OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo)) 
Where (pVoucher.Voucher=@P_Voucher) 
) 



GO

CREATE function [dbo].[OS_VOUCHER_N] (@P_Voucher Varchar(20))      
RETURNS Table      
AS RETURN      
(      
SELECT VOUCHER.VOUCHER, VOUCHER.DATE, VOUCHER.CURRENCY, VOUCHER.PROACC, VOUCHER.DEBTORF,VOUCHER.CREDITORF,VOUCHER.SL_CAT,      
VOUCHER.BRANCH, VOUCHER.REFNO,VOUCHER.REFDATE,VOUCHER.DOCNO,VOUCHER.VTYPE, VOUCHER.REMARKS, VOUCHER.REFTYPE, VOUCHER.ACCOUNTNO, Admlink.A_RefNo,      
VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC AS NOMINAL,      
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.PAYMENT_CC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VP.NOMINAL END AS PAYMENT,      
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC ELSE VP.NOMINAL END AS OUTSTANDING,  
'' AS ACCOUNT,
cast(0 as Smallint) as HINT  
FROM NVoucher VOUCHER Inner Join Admlink On (Admlink.Voucher=Voucher.Voucher)      
LEFT JOIN PAID_VOUCHER_N(@P_Voucher) VP ON(VOUCHER.VOUCHER=VP.VOUCHER)      
WHERE VOUCHER.STATUS<>'C' AND VOUCHER.REQUESTF=0 AND ROUND(CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC ELSE VP.NOMINAL END,4)<>0      
)      

GO
CREATE function [dbo].[OS_VOUCHER_P] (@P_Voucher Varchar(20))                  
RETURNS Table                  
AS RETURN                  
(                  
SELECT VOUCHER.VOUCHER, VOUCHER.DATE, VOUCHER.CURRENCY, VOUCHER.PROACC, VOUCHER.DEBTORF,VOUCHER.CREDITORF,VOUCHER.SL_CAT,                  
CASE WHEN PV.VOUCHER IS NULL THEN VOUCHER.BRANCH ELSE PV.BRANCH END AS BRANCH, VOUCHER.REFNO,VOUCHER.REFDATE, VOUCHER.DOCNO,VOUCHER.VTYPE, VOUCHER.REMARKS, VOUCHER.REFTYPE, VOUCHER.ACCOUNTNO, ' ' as A_RefNo,                  
CASE WHEN VP.VOUCHER IS NULL THEN PV.NOMINAL_CC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC END AS NOMINAL,                  
CASE WHEN VP.VOUCHER IS NULL THEN PV.PAYMENT_CC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VP.NOMINAL END AS PAYMENT,                  
CASE WHEN VP.VOUCHER IS NULL THEN PV.NOMINAL_CC-PV.PAYMENT_CC ELSE VP.NOMINAL END AS OUTSTANDING,
PV.ACCOUNT,
PV.HINT                 
FROM pVoucher VOUCHER                  
Inner JOIN VType ON (VType.VType=Voucher.VType and VType.Code<>'INTERBANK')              
Inner JOIN         
(        
SELECT VOUCHER, BRANCH, ACCOUNT, MAX(HINT) AS HINT, SUM(NOMINAL_CC) AS NOMINAL_CC, SUM(PAYMENT_CC) AS PAYMENT_CC        
FROM        
(        
SELECT VOUCHER, BRANCH, ACCOUNT, HINT, SL.NOMINAL AS NOMINAL_CC,0 as PAYMENT_CC FROM PSLSUM SL
Union All        
SELECT PVOUCHER.VOUCHER, SL.BRANCH, SL.ACCOUNT, MAX(SL.HINT) AS HINT, 0 as NOMINAL_CC, SUM(SL.NOMINAL_OC) AS PAYMENT_CC 
FROM R_SL_ALLOCATED_BY_VOUCHER(GetDate(),'') SL, PVOUCHER
WHERE PVOUCHER.NPAYMENT<>0 and PVOUCHER.VOUCHER=SL.DOC_NO 
Group By PVOUCHER.VOUCHER, SL.BRANCH, SL.ACCOUNT
) PV GROUP BY VOUCHER, BRANCH, ACCOUNT        
) PV ON (PV.VOUCHER=VOUCHER.VOUCHER)        
LEFT JOIN PAID_VOUCHER_P(@P_Voucher) VP ON(VP.VOUCHER=VOUCHER.VOUCHER)                  
WHERE VOUCHER.STATUS<>'N' and VOUCHER.REQUESTF=0                  
AND ROUND(CASE WHEN VP.VOUCHER IS NULL THEN PV.NOMINAL_CC-PV.PAYMENT_CC ELSE VP.NOMINAL END,4)<>0        
) 

GO
CREATE function [dbo].[OS_VOUCHER_T] (@P_Voucher Varchar(20))    
RETURNS Table    
AS RETURN    
(    
SELECT VOUCHER.VOUCHER, VOUCHER.DATE, VOUCHER.CURRENCY, VOUCHER.PROACC, VOUCHER.DEBTORF,VOUCHER.CREDITORF,VOUCHER.SL_CAT,    
VOUCHER.BRANCH, VOUCHER.REFNO,VOUCHER.REFDATE, VOUCHER.DOCNO,VOUCHER.VTYPE, VOUCHER.REMARKS, VOUCHER.REFTYPE, VOUCHER.ACCOUNTNO, ' ' as A_RefNo,    
VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC AS NOMINAL,    
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.PAYMENT_CC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VP.NOMINAL END AS PAYMENT,    
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC ELSE VP.NOMINAL END AS OUTSTANDING,  
'' AS ACCOUNT,
cast(0 as Smallint) as HINT  
FROM NVoucher VOUCHER Inner Join VType on (VType.VType=Voucher.VType and VType.TaxF=1)    
LEFT JOIN PAID_VOUCHER_N(@P_Voucher) VP ON(VOUCHER.VOUCHER=VP.VOUCHER)    
WHERE VOUCHER.REQUESTF=0 AND ROUND(CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC ELSE VP.NOMINAL END,4)<>0    
)    


GO
CREATE function [dbo].[OS_VOUCHER] (@P_Voucher Varchar(20))    
RETURNS Table    
AS RETURN    
(    
SELECT VOUCHER, DATE, CURRENCY, PROACC, DEBTORF, CREDITORF, SL_CAT, BRANCH, REFNO, REFDATE, DOCNO, VTYPE, REMARKS, REFTYPE, A_Refno, ACCOUNTNO, NOMINAL, PAYMENT, OUTSTANDING, ACCOUNT, HINT
FROM OS_VOUCHER_N(@P_VOUCHER)    
Union All    
SELECT VOUCHER, DATE, CURRENCY, PROACC, DEBTORF, CREDITORF, SL_CAT, BRANCH, REFNO, REFDATE, DOCNO, VTYPE, REMARKS, REFTYPE, A_Refno, ACCOUNTNO, NOMINAL, PAYMENT, OUTSTANDING, ACCOUNT, HINT    
FROM OS_VOUCHER_P(@P_VOUCHER)    
)    
               
GO
CREATE function [dbo].[OS_VOUCHER_I] (@P_Voucher Varchar(20))    
RETURNS Table    
AS RETURN    
(    
SELECT VOUCHER.VOUCHER, VOUCHER.DATE, VOUCHER.CURRENCY, VOUCHER.PROACC, VOUCHER.DEBTORF,VOUCHER.CREDITORF,VOUCHER.SL_CAT,    
VOUCHER.BRANCH, VOUCHER.REFNO,VOUCHER.REFDATE, VOUCHER.DOCNO,VOUCHER.VTYPE, VOUCHER.REMARKS, VOUCHER.REFTYPE, VOUCHER.ACCOUNTNO, ' ' as A_RefNo,    
VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC AS NOMINAL,    
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.PAYMENT_CC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VP.NOMINAL END AS PAYMENT,    
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC ELSE VP.NOMINAL END AS OUTSTANDING,  
'' AS ACCOUNT,
cast(0 as Smallint) as HINT   
FROM NVoucher VOUCHER    
LEFT JOIN PAID_VOUCHER_N(@P_Voucher) VP ON(VOUCHER.VOUCHER=VP.VOUCHER)    
WHERE VOUCHER.INVESTMENTF=1 AND VOUCHER.REQUESTF=0 AND ROUND(CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC ELSE VP.NOMINAL END,4)<>0    
)    

GO
CREATE function [dbo].[OS_VOUCHER_M] (@P_Voucher Varchar(20))    
RETURNS Table    
AS RETURN    
(    
SELECT VOUCHER.VOUCHER, VOUCHER.DATE, VOUCHER.CURRENCY, VOUCHER.PROACC, VOUCHER.DEBTORF,VOUCHER.CREDITORF,VOUCHER.SL_CAT,    
VOUCHER.BRANCH, VOUCHER.REFNO,VOUCHER.REFDATE, VOUCHER.DOCNO,VOUCHER.VTYPE, VOUCHER.REMARKS, VOUCHER.REFTYPE, VOUCHER.ACCOUNTNO, '  ' as A_RefNo,    
VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC AS NOMINAL,    
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.PAYMENT_CC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VP.NOMINAL END AS PAYMENT,    
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC ELSE VP.NOMINAL END AS OUTSTANDING,  
'' AS ACCOUNT,
cast(0 as Smallint) as HINT  
FROM NVoucher VOUCHER    
INNER JOIN VTYPE ON (VTYPE.VTYPE=VOUCHER.VTYPE)    
LEFT JOIN PAID_VOUCHER_N(@P_Voucher) VP ON(VOUCHER.VOUCHER=VP.VOUCHER)    
WHERE VOUCHER.INVESTMENTF=0 AND VTYPE.TAXF=0 AND VOUCHER.REQUESTF=0 AND ROUND(CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC ELSE VP.NOMINAL END,4)<>0    
)    
            
GO
CREATE FUNCTION [dbo].[QACCUMULATION_CONTROL](@P_REGID as varchar(10), @P_FLDID as varchar(50), @P_VALUEID as varchar(50))  
RETURNS Table  
AS RETURN (  
SELECT G1.SFLDID, G1.SVALUEID, Max(G2.Description) as Description, sum(R1.TAmount) as TSI  
from acceptance a1, RArrheader R1, GenDTab G1, GenDTab G2
Where A1.RegID=@P_RegID and A1.FLDID=@P_FLDID and A1.VALUEID=@P_VALUEID and R1.ANO=A1.ANO and R1.Status='A' and G1.FLDID=A1.FLDID and G1.VALUEID=A1.VALUEID and G2.FLDID=G1.SFLDID and G2.VALUEID=G1.SVALUEID  
Group By G1.SFLDID, G1.SVALUEID
)  

GO

CREATE FUNCTION [dbo].[QCLAIM_CCALC] ()    
RETURNS TABLE AS    
RETURN (    
SELECT  CLAIM.CNO,    
SUM(CCALC.LOSS*CCALC.RATE*CCALC.SHARE/100) AS LOSS,    
SUM(CCALC.CLAIM*CCALC.RATE*CCALC.SHARE/100) AS CLAIM,    
SUM(CCALC.DEDUCTIBLE*CCALC.RATE*CCALC.SHARE/100) AS DEDUCTIBLE,    
SUM(CCALC.SALVAGE*CCALC.RATE*CCALC.SHARE/100) AS SALVAGE,    
SUM(CCALC.COST*CCALC.RATE*CCALC.SHARE/100+CCALC.RCOST*CCALC.RATE+(CCALC.TCOST-CCALC.COST-CCALC.RCOST)*CCALC.RATE) AS COST,    
SUM(CCALC.ECOST*CCALC.RATE*CCALC.SHARE/100+CCALC.ERCOST*CCALC.RATE+(CCALC.ETCOST-CCALC.ECOST-CCALC.ERCOST)*CCALC.RATE) AS ECOST,    
SUM(CCALC.SUBROGATION*CCALC.RATE*CCALC.SHARE/100) AS SUBROGATION,    
SUM(CASE    
WHEN CLAIM.CTYPE<>'C' and CLAIM.CSTATUS<>'A' AND CLAIM.PCSTATUS<>'A' THEN   
((CCALC.LOSS-CCALC.EDEDUCTIBLE-CCALC.SALVAGE+CCALC.ECOST-CCALC.SUBROGATION)*CCALC.RATE*CCALC.SHARE/100+CCALC.ERCOST*CCALC.RATE+(CCALC.ETCOST-CCALC.ECOST-CCALC.ERCOST)*CCALC.RATE)  
WHEN CLAIM.CTYPE<>'C' and CLAIM.SETTLEDF=0 THEN  
((CCALC.LOSS-CCALC.EDEDUCTIBLE-CCALC.SALVAGE+CCALC.ECOST-CCALC.SUBROGATION)*CCALC.RATE*CCALC.SHARE/100+CCALC.ERCOST*CCALC.RATE+(CCALC.ETCOST-CCALC.ECOST-CCALC.ERCOST)*CCALC.RATE)  
       -((CCALC.CLAIM-CCALC.DEDUCTIBLE-CCALC.SALVAGE+CCALC.COST-CCALC.SUBROGATION)*CCALC.RATE*CCALC.SHARE/100+CCALC.RCOST*CCALC.RATE+(CCALC.TCOST-CCALC.COST-CCALC.RCOST)*CCALC.RATE)  
ELSE 0 END) AS RESERVED  
FROM  Claim LEFT JOIN CCALC ON CLAIM.CNO=CCALC.CNO    
GROUP BY CLAIM.CNO    
)    
  

GO
CREATE FUNCTION [dbo].[SL_ALLOCATED]()         
RETURNS TABLE  AS         
RETURN (         
                 
--SL from Payment Voucher         
Select SL.Voucher, Voucher.SL_Cat, Voucher.Branch, Voucher.Date as Doc_Date, Voucher.Currency as Doc_CCY, SL.Voucher as Doc_No, SL.Account, 1 as PaymentF, 1 as Rate, sum(SL.Rate*SL.Nominal_OC) as Nominal_OC         
from pSL SL, pVoucher Voucher         
Where Voucher.SL_Cat in ('P') and SL.Voucher=Voucher.Voucher and SL.PaymentF=1         
Group By SL.Voucher, Voucher.SL_Cat, Voucher.Branch, Voucher.Date, Voucher.Currency, SL.Account         
                       
Union All         
                       
--SL from Overbooking Payment and Adjustment Payment         
Select SL.Voucher, VoucherR.SL_Cat, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.Voucher as Doc_No, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end as Account, 1 as PaymentF, 1 as Rate
  
,         
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal_OC else -SL.Nominal_OC end*SL.Rate)) as Nominal_OC         
from pSL SL, pVoucher VoucherP, pVoucher VoucherR, VPattern         
Where VoucherR.SL_Cat in ('B','A') and VoucherP.SL_Cat='P' and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher and SL.PaymentF=1         
and VPattern.VType=VoucherR.VType and ((VPattern.Debit=SL.hint and VoucherR.DebtorF=1) or (VPattern.Credit=SL.hint and VoucherR.CreditorF=1))         
Group By SL.Voucher, VoucherR.SL_Cat, VoucherR.Branch, VoucherR.Date, VoucherR.Currency, VoucherP.Voucher, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end      
           
                 
Union All         
                       
--SL from Adjustment Overbooking         
Select SL.Voucher, VoucherR.SL_Cat, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.RefNo as Doc_No, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end as Account, 1 as PaymentF, 1 as Rate, 
  
        
sum((case When VoucherR.DebtorF=pVoucher.DebtorF Then SL.Nominal_OC else -SL.Nominal_OC end*SL.Rate)) as Nominal_OC         
from pSL SL, pVoucher VoucherP, pVoucher VoucherR, pVoucher, VPattern         
Where VoucherR.SL_Cat in ('A') and VoucherP.SL_Cat in ('B') and VoucherR.RefNo=VoucherP.Voucher and pVoucher.SL_Cat in ('P') and VoucherP.RefNo=pVoucher.Voucher and SL.Voucher=VoucherR.Voucher and SL.PaymentF=1         
and VPattern.VType=VoucherR.VType and ((VPattern.Debit=SL.hint and VoucherR.DebtorF=1) or (VPattern.Credit=SL.hint and VoucherR.CreditorF=1))         
Group By SL.Voucher, VoucherR.SL_Cat, VoucherR.Branch, VoucherR.Date, VoucherR.Currency, VoucherP.RefNo, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end      
                       
Union All         
                       
--SL from Sub Ledger Payment Voucher and OverPaid         
Select SL.Voucher, VoucherR.SL_Cat, VoucherR.Branch, SL.Doc_Date, SL.Doc_CCY, SL.Doc_No as Doc_No, SL.Account, 1 as PaymentF, 1 as Rate,         
(Case When VoucherR.SL_Cat='O'         
then (case when VoucherR.DebtorF=VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)         
else (case when VoucherR.DebtorF<>VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)         
end) as Nominal_OC         
from pSL SL, pVoucher VoucherP, pVoucher VoucherR         
Where VoucherR.SL_Cat in ('O','P','A','B') and VoucherP.SL_Cat in ('P') and VoucherR.Voucher=SL.Voucher and SL.Doc_No=VoucherP.Voucher and SL.PaymentF=1         
)          
        
      
GO
CREATE FUNCTION [dbo].[SL_PAYMENT]()    
RETURNS TABLE  AS      
RETURN (    
Select SL.Voucher, SL.Doc_Date, SL.Doc_CCY, SL.Doc_No, SL.Account, SL.PaymentF, SL.Rate, VoucherP.Date,  
case    
when Voucher.DebtorF=1 then    
Case     
When VoucherP.SL_cat in ('A','B','P') Then    
  Case    
  When VoucherP.DebtorF=Voucher.DebtorF then     
   SL.Nominal_OC    
  Else     
   -SL.Nominal_OC     
  end    
else    
  Case    
  When VoucherP.DebtorF=Voucher.DebtorF then     
   -SL.Nominal_OC    
  Else     
   SL.Nominal_OC     
  end    
end    
else    
Case     
When VoucherP.SL_cat in ('A','B','P') Then    
  Case    
  When VoucherP.DebtorF=Voucher.DebtorF then     
   -SL.Nominal_OC    
  Else     
   SL.Nominal_OC     
  end    
else    
  Case    
  When VoucherP.DebtorF=Voucher.DebtorF then     
   SL.Nominal_OC    
  Else      
   -SL.Nominal_OC     
  end    
end    
end as Nominal_OC     
    
from pSL SL, nVoucher Voucher, pVoucher VoucherP Where Voucher.Voucher=SL.Doc_No and SL.PaymentF=1 and VoucherP.Voucher=SL.Voucher and VoucherP.SL_Cat<>'N'    
    
)    
    
GO

CREATE function [dbo].[SListQry](@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@Value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255),@Value12 as int, @Value13 as int)  
RETURNS Table  
AS return  
(  
SELECT Service.*  
From Service  
WHERE  ServiceNo like @Value1  
and (datediff(day,dateadd(day,validation,cdate),@value2)>=0 or @Value2='')  
and Name like @Value3  
and Insured Like @Value4  
and (CoverDate=@Value5 or @Value5='')  
and (ExpDate=@Value6 or @Value6='')  
and PolicyNo like @Value7  
and CertificateNo like @Value8  
and BSName Like @Value9  
and SStatus like @Value10  
and TOC Like @Value11  
and (InfoF=@Value12 or @Value12=0)  
and (SurveyF=@Value13 or @Value13=0)  
)  
        
GO
CREATE FUNCTION [dbo].[SListSR_Det] (@P_ANO as int, @P_ID as int)  
RETURNS Table  
AS RETURN(  
        
SELECT  
Cast(0 as bit) as ProcessFlag, 
[Acceptance].[CertificateNo],  
Acceptance.ESeqNo,  
[Acceptance].[AName],  
[Acceptance].[ANO],  
[Acceptance].[REGNO],  
[Acceptance].[ADATE],  
[Acceptance].[LUSERID] as UserID,  
[SysTab].[Currency],  
[QPCalc].[TSI],  
[QPCalc].[OurShare],  
[QPCalc].[Gross],  
[Acceptance].[ASTATUS],  
[Acceptance].[ATYPE],  
[Acceptance].[SDate],  
[Acceptance].[EDate],  
Year([acceptance].[SDate]) As RYear  
From  
Acceptance,  
Cover,  
SysTab,  
QMasterAcceptance_PCalc() AS QPCalc,  
TOC,  
SysRequest,  
Service  
Where  
[cover].[CNO] = [acceptance].[CNO]  
And [QPCalc].[ANO]=[Acceptance].[ANO]  
And [Acceptance].[ANO]<>[Acceptance].[LANO]  
And [Acceptance].[LANO]=@P_ANO  
And SysRequest.ID=@P_ID  
And SysRequest.Param2 in ('SVC')  
And SysRequest.Param3=Service.SNO  
And Acceptance.ANO=Service.PANO  
And TOC.TOC=COVER.TOC)  
        
    
      
GO

CREATE FUNCTION [dbo].[SMListSR_Det] (@P_ANO as int, @P_ID as int)
RETURNS Table
AS RETURN(
      
SELECT
Cast(0 as bit) as ProcessFlag, 
Cover.COVERNO,
Acceptance.AName,
Acceptance.CertificateNo,
Cover.CNO,
Cover.CStatus,
Cover.VSeqNo,
Acceptance.LANO,
Acceptance.ANO,
Acceptance.REGNO,
Acceptance.ADATE,
Acceptance.USERID,
SysTab.Currency,
QPCalc.TSI,
QPCalc.OurShare,
QPCalc.Gross,
Acceptance.ASTATUS,
Acceptance.ATYPE,
Acceptance.SDate,
Acceptance.EDate,
Year(RARRHEADER.RDATE) As RYear
From
Acceptance,
RArrHeader,
Cover,
SysTab,
QMasterAcceptance_PCalc() AS QPCalc,
TOC,
SysRequest
Where
cover.CNO = acceptance.CNO
And RArrHeader.ANO=Acceptance.ANO
And QPCalc.ANO=Acceptance.ANO
And Acceptance.ANO<>Acceptance.LANO
And Acceptance.LANO=@P_ANO
And SysRequest.ID=@P_ID
And SysRequest.Param2 in ('SVC')  
And SysRequest.Param3=Acceptance.ANO
And TOC.TOC=COVER.TOC)

GO
CREATE function [dbo].[VOUCHER_AMOUNTDUE](@P_Date as smalldatetime) 
RETURNS Table 
AS RETURN 
( 
Select V.Voucher, V.Branch, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, V.Payment_CC, V.Payment_OC, V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate, 
(Case When V.Installment=0 and V.DueDate <=@P_Date Then V.Nominal_CC-V.Diff_CC else 0 end+ 
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
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date Then V.AmountDue_24 else 0 end) as AmountDue, 

Case When V.Installment=0 then V.DueDate 
When V.Payment_CC<V.AmountDue_1 then V.DueDate_1 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 then V.DueDate_12 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 then V.DueDate_13 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 then V.DueDate_14 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 then V.DueDate_15 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 then V.DueDate_16 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 then V.DueDate_17 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 then V.DueDate_18 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 then V.DueDate_19 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 then V.DueDate_20 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 then V.DueDate_21 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 then V.DueDate_22 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 then V.DueDate_23 
Else V.DueDate_24 
end as DueDate, 
(Case When V.Installment<>0 then ' Installment No. ' else '' end+ 
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and V.Payment_CC<V.AmountDue_1 Then '1 ' else '' end+ 
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+ 
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+ 
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+ 
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+ 
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+ 
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+ 
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+ 
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+ 
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  Then '10 ' else '' end+ 
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+ 
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' else '' end+ 
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 Then '13 ' else '' end+ 
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 Then '14 ' else '' end+ 
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 Then '15 ' else '' end+ 
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 Then '16 ' else '' end+ 
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 Then '17 ' else '' end+ 
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 Then '18 ' else '' end+ 
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 Then '19 ' else '' end+ 
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 Then '20 ' else '' end+ 
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 Then '21 ' else '' end+ 
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 Then '22 ' else '' end+ 
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 Then '23 ' else '' end+ 
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 Then '24 ' else '' end+ 
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment 
from nVoucher V 
Where V.Date<=@P_Date and ((V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC)<>0 or V.PDate>=@P_Date) 
) 


GO

CREATE PROCEDURE [dbo].[QAccFD] (@P_ANO  as integer, @P_FDID as varchar(10), @P_ID as varchar(10), @P_POLICYYEAR as int)
AS
SELECT *
From AccFD
WHERE ANO=@P_ANO and FDID=@P_FDID and ID=@P_ID and POLICYYEAR=@P_POLICYYEAR

GO

CREATE Procedure [dbo].[QCDOCLIST](@P_CNO integer, @P_INO integer, @P_NOC varchar(10)) 
as 
Select * 
from 
( 
select Cast(coalesce(CDOCLIST.AvailableF, 0) as bit) as ProcessFlag, DOCLIST.DocType, coalesce(CDOCLIST.Description, DOCLIST.Description) as Description, coalesce(CDOCLIST.AvailableF, 0) as AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, CDOCLIST.RecDate 
from DOCLIST Left join DOCTYPE on (DOCTYPE.DOCTYPE=DOCLIST.DOCTYPE) inner join ICOVER on (ICover.INO=@P_INO and DOCLIST.NOC=@P_NOC and DOCLIST.TOI=ICOVER.TOI) 
Left Join CDOCLIST on (CDOCLIST.CNO=@P_CNO and CDOCLIST.INO=ICover.INO and CDOCLIST.DOCTYPE=DOCLIST.DOCTYPE) 

Union All 

select Cast(coalesce(CDOCLIST.AvailableF, 0) as bit) as ProcessFlag, CDOCList.DocType, CDOCLIST.Description, CDOCLIST.AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, CDOCLIST.RecDate 
from CDOCLIST Left Join DOCTYPE on (DOCTYPE.DOCTYPE=CDOCLIST.DOCTYPE) 
Where CDOCLIST.CNO=@P_CNO AND CDOCLIST.INO=@P_INO 
AND NOT EXISTS (Select DOCLIST.DOCTYPE from DOCLIST, ICOVER Where DOCLIST.DOCTYPE=CDOCLIST.DOCTYPE AND ICOVER.INO=@P_INO AND DOCLIST.NOC=@P_NOC AND DOCLIST.TOI=ICOVER.TOI) 
) CDOCLIST 
Order By CDOCLIST.DOCTYPE 



GO
CREATE Procedure [dbo].[QCheckObjectClaimed](@P_ClaimNo varchar(20), @P_PolicyNo varchar(20), @P_CertificateNo varchar(20),@P_LossDate smalldatetime='01/01/2007', @P_COL varchar(10)='', @P_Location varchar(10)='')   
as   
select C1.ClaimNo, C1.LossDate,  C1.PolicyNo+case When C1.CertificateNo='' then '' else '-'+C1.CertificateNo end as PolicyNo, C1.CStatus, C1.CNO, C1.ANO, P1.Name as Claimant, c2.DESCRIPTION as 'COL', L.location   
FROM   
(   
select C1.OCNO, Max(C1.CNO) as CNO   
from Claim C1   
Where C1.ClaimNo<>@P_ClaimNo and C1.PolicyNo=@P_PolicyNo and C1.CertificateNo=@P_CertificateNo and C1.LossDate between dateadd(day,-14,@P_LossDate) and dateadd(day,14,@P_LossDate)   
and not (C1.CStatus='C' and C1.pCStatus='P') -- not Close Claim
and not ((C1.CStatus='A' or C1.pCStatus='A') and C1.CType='C')  --not Claim Cancellation
and (@P_COL='' or C1.COL=@P_COL)   
and (@P_Location='' or C1.location=@P_Location)   
Group By C1.OCNO   
) C   
Inner Join Claim C1 on (C1.CNO=C.CNO)   
Inner Join Profile P1 on (P1.ID=C1.Claimant)   
Inner Join COLTAB C2 on (C2.COL=C1.COL)   
Left Join Location L on (L.Location=C1.Location)   
   
   
GO
CREATE Procedure [dbo].[QCheckObjectService](@P_SNO as integer)
as
Select S1.*
from Service S1, Service S2
Where S2.SNO=@P_SNO and S2.ServiceNo<>S1.ServiceNo and S1.Code=S2.Code and S1.Coverage=S2.Coverage
and ((S2.SType<>'NEW' and S1.SStatus in ('R','P') and S1.PolicyNo=S2.PolicyNo and S1.CertificateNo=S2.CertificateNo and S1.REGID=S2.REGID and S1.FLDID=S2.FLDID and S1.ValueID=S2.ValueID)
or (S2.SType='NEW' and ((S1.Insured=S2.Insured and S2.ValueID='') or (S1.REGID=S2.REGID and S1.FLDID=S2.FLDID and S1.ValueID=S2.ValueID and S2.ValueID<>'')) and S2.ServiceDate between dateadd(day,-60,S1.ServiceDate) and dateadd(day,60,S1.ServiceDate)
))
GO


Create Procedure [dbo].[QCheckObjectValuation](@P_TOI as varchar(10), @P_Month as integer, @P_Year as integer
,@P_ValueID1 as varchar(255)
,@P_ValueID2 as varchar(255)
,@P_ValueID3 as varchar(255)
,@P_ValueID4 as varchar(255)
,@P_ValueID5 as varchar(255)
,@P_ValueID6 as varchar(255)
,@P_ValueID7 as varchar(255)
,@P_ValueID8 as varchar(255)
,@P_ValueID9 as varchar(255)
,@P_ValueID10 as varchar(255)
,@P_ValueID11 as varchar(255)
,@P_ValueID12 as varchar(255)
,@P_ValueID13 as varchar(255)
,@P_ValueID14 as varchar(255)
,@P_ValueID15 as varchar(255))
as  
Select * from TOIValue
Where TOIVAlue.Month=@P_Month and TOIValue.Year=@P_Year and TOIValue.TOI=@P_TOI
and (TOIValue.ValueID1=@P_ValueID1 or @P_ValueID1='')
and (TOIValue.ValueID2=@P_ValueID2 or @P_ValueID2='')
and (TOIValue.ValueID3=@P_ValueID3 or @P_ValueID3='')
and (TOIValue.ValueID4=@P_ValueID4 or @P_ValueID4='')
and (TOIValue.ValueID5=@P_ValueID5 or @P_ValueID5='')
and (TOIValue.ValueID6=@P_ValueID6 or @P_ValueID6='')
and (TOIValue.ValueID7=@P_ValueID7 or @P_ValueID7='')
and (TOIValue.ValueID8=@P_ValueID8 or @P_ValueID8='')
and (TOIValue.ValueID9=@P_ValueID9 or @P_ValueID9='')
and (TOIValue.ValueID10=@P_ValueID10 or @P_ValueID10='')
and (TOIValue.ValueID11=@P_ValueID11 or @P_ValueID11='')
and (TOIValue.ValueID12=@P_ValueID12 or @P_ValueID12='')
and (TOIValue.ValueID13=@P_ValueID13 or @P_ValueID13='')
and (TOIValue.ValueID14=@P_ValueID14 or @P_ValueID14='')
and (TOIValue.ValueID15=@P_ValueID15 or @P_ValueID15='')

GO
CREATE PROCEDURE [dbo].[QCLACC_5] (@P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO AS VARCHAR(255), @P_DATE AS SMALLDATETIME) 
AS 
SELECT TOP 1 * 
From Acceptance 
WHERE PolicyNo=@P_PolicyNo and CertificateNo LIKE @P_CertificateNo and AType in ('C') and AStatus not in ('W','T') and ANO<>LANO and PDate<=@P_Date 


GO
CREATE PROCEDURE [dbo].[QCLAIMAMOUNT] (@P_CNO AS INTEGER,@P_PDate as smalldatetime) 
AS 
SELECT 
sum(CASE WHEN nVoucher.DEBTORF=1 THEN (Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) ELSE -(Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) END*nVoucher.RATE) as ClaimAmount, 
MIN(Case When Round(nVoucher.Payment_CC,2)<round((Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end),2) Then isnull(Voucher_Due.DueDate, nVoucher.DueDate) else Null end) AS DUEDATE, 
sum(CASE WHEN nVoucher.DEBTORF=1 THEN nVoucher.PAYMENT_CC ELSE -nVoucher.PAYMENT_CC END*nVoucher.RATE) as ClaimPaid, 
MAX(Case When nVoucher.Payment_CC<>0 then nVoucher.PDATE else Null end) AS DATE, 
MAX(Admlink.WPC) As WPC 
FROM nVoucher Left Join Voucher_AmountDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=nVoucher.Voucher), Admlink 
Where nVoucher.Voucher = Admlink.Voucher and EXISTS (SELECT ClaAss.ADMNO FROM ClaAss, Claim C1, Claim C2 WHERE C1.CNO=@P_CNO and C2.OCNO=C1.OCNO AND ClaAss.CNO=C2.CNO AND ClaAss.TYPE IN ('DI','IC','IR','OP') AND ADMLINK.ADMNO=ClaAss.ADMNO) 


GO
CREATE Procedure [dbo].[QClaimInfo_Data](@P_CNO integer)              
as              
SELECT     
C1.CNO, C1.ANO, C1.ClaimNo, C1.PolicyNo, C1.CertificateNo, C1.Description, C1.Remarks, C1.Comment,        
C1.UniqueF, C1.LargeF, C1.SurveyF, C1.Reason,
C3.Loss,         
C3.Deductible,        
C3.Salvage,        
C3.Cost,        
C3.Subrogation,        
C3.Claim,         
C3.Reserved,        
C4.ETShare,        
C4.ERetention,        
C2.FLDID1, C2.VALUEID1, C2.VALUEDESC1, 0 as FLDSEARCH1,                
C2.FLDID2, C2.VALUEID2, C2.VALUEDESC2, 0 as FLDSEARCH2,                
C2.FLDID3, C2.VALUEID3, C2.VALUEDESC3, 0 as FLDSEARCH3,                
C2.FLDID4, C2.VALUEID4, C2.VALUEDESC4, 0 as FLDSEARCH4,                
C2.FLDID5, C2.VALUEID5, C2.VALUEDESC5, 0 as FLDSEARCH5,                
C2.FLDID6, C2.VALUEID6, C2.VALUEDESC6, 0 as FLDSEARCH6,                
C2.FLDID7, C2.VALUEID7, C2.VALUEDESC7, 0 as FLDSEARCH7,                
C2.FLDID8, C2.VALUEID8, C2.VALUEDESC8, 0 as FLDSEARCH8,                
C2.FLDID9, C2.VALUEID9, C2.VALUEDESC9, 0 as FLDSEARCH9,                
C2.FLDID10, C2.VALUEID10, C2.VALUEDESC10, 0 as FLDSEARCH10,                
C2.FLDID11, C2.VALUEID11, C2.VALUEDESC11, 0 as FLDSEARCH11,                
C2.FLDID12, C2.VALUEID12, C2.VALUEDESC12, 0 as FLDSEARCH12,                
C2.FLDID13, C2.VALUEID13, C2.VALUEDESC13, 0 as FLDSEARCH13,                
C2.FLDID14, C2.VALUEID14, C2.VALUEDESC14, 0 as FLDSEARCH14,                
C2.FLDID15, C2.VALUEID15, C2.VALUEDESC15, 0 as FLDSEARCH15            
FROM CLAIM C1         
Left Join CINFO C2 on (C2.CNO=C1.CNO)         
Left Join QClaim_CCalc() C3 on (C3.CNO=C1.CNO)         
Left Join CArrHeader C4 on (C4.CNO=C1.CNO)        
WHERE C1.CNO=@P_CNO              
      
      
    
GO

CREATE PROCEDURE [dbo].[QCLFACDED](@P_CNO AS INTEGER,@P_FID AS VARCHAR(20), @P_DCODE AS VARCHAR(10)) 
AS
SELECT *
FROM     CLFACDED
WHERE CNO=@P_CNO AND FID=@P_FID AND DCODE=@P_DCODE


GO


CREATE PROCEDURE [dbo].[QCLFD](@P_CNO as integer, @P_FDID  as varchar(10)) 
AS
SELECT *
FROM CLFD
WHERE CNO=@P_CNO and FDID=@P_FDID


GO

CREATE Procedure [dbo].[QCLSAL](@P_CNO as int,@P_INO as int,@P_ID varchar(10),@P_CURRENCY varchar(5))
as
SELECT *
FROM CLSAL
WHERE CNO=@P_CNO AND INO=@P_INO AND [ID]=@P_ID AND Currency=@P_CURRENCY


GO
CREATE  Procedure [dbo].[QCLSUB](@P_CNO as int,@P_ID varchar(10),@P_CURRENCY varchar(5))
as
SELECT *
FROM CLSUB
WHERE CLSUB.CNO=@P_CNO AND CLSUB.ID=@P_ID AND CLSUB.CURRENCY=@P_CURRENCY


GO
create procedure [dbo].[QComAcc] (@ComAcc as varchar(255))  
as  
select * from ComAcc where ComAcc=@ComAcc  
  
GO


CREATE PROCEDURE [dbo].[QGenDTab] (@PFLDID as varchar(255), @PValueID as varchar(255)) 
AS
SELECT *
FROM GENDTAB
WHERE FLDID=@PFLDID AND VALUEID=@PVALUEID
GO


CREATE PROCEDURE [dbo].[QInParty](@P_CNO as Integer, @P_ID as varchar(255),@P_Name as varchar(255))
AS
SELECT InParty.*
From InParty
WHERE InParty.CNO=@P_CNO and InParty.ID=@P_ID and InParty.Name=@P_Name

GO
CREATE Procedure [dbo].[QInterest_Data](@P_INO integer)  
as  
SELECT  
I1.*,  
I2.FLDID1, I2.VALUEID1, I2.VALUEDESC1,  
I2.FLDID2, I2.VALUEID2, I2.VALUEDESC2,  
I2.FLDID3, I2.VALUEID3, I2.VALUEDESC3,  
I2.FLDID4, I2.VALUEID4, I2.VALUEDESC4,  
I2.FLDID5, I2.VALUEID5, I2.VALUEDESC5,  
I2.FLDID6, I2.VALUEID6, I2.VALUEDESC6,  
I2.FLDID7, I2.VALUEID7, I2.VALUEDESC7,  
I2.FLDID8, I2.VALUEID8, I2.VALUEDESC8,  
I2.FLDID9, I2.VALUEID9, I2.VALUEDESC9,  
I2.FLDID10, I2.VALUEID10, I2.VALUEDESC10,  
I2.FLDID11, I2.VALUEID11, I2.VALUEDESC11,  
I2.FLDID12, I2.VALUEID12, I2.VALUEDESC12,  
I2.FLDID13, I2.VALUEID13, I2.VALUEDESC13,  
I2.FLDID14, I2.VALUEID14, I2.VALUEDESC14,  
I2.FLDID15, I2.VALUEID15, I2.VALUEDESC15,  
I3.FLDVALUEF, I3.FLDVALUEL,  
I3.FLDTAG1, I3.FLDVALUE1, I3.FLDOP1,  
I3.FLDTAG2, I3.FLDVALUE2, I3.FLDOP2,  
I3.FLDTAG3, I3.FLDVALUE3, I3.FLDOP3,  
I3.FLDTAG4, I3.FLDVALUE4, I3.FLDOP4,  
I3.FLDTAG5, I3.FLDVALUE5, I3.FLDOP5,  
I3.FLDTAG6 , I3.FLDVALUE6, I3.FLDOP6  
FROM ICOVER I1 Left Join IINFO I2 On (I2.INO=I1.INO) Left Join ICoverExt I3 ON (I3.INO=I1.INO)  
WHERE I1.INO=@P_INO  
        

GO

CREATE Procedure [dbo].[qInwardTreaty_Data](@P_ANO integer)            
as            
Select A1.CNO, A1.ANO, A1.RegNo, A1.Branch, A1.CT, A1.NCDate, C.CoverDate, C.Insured, C.ExpDate, C.TOC, C.RefNo, C.RefDate, C.MO, R.Code, I.RType, I.ID, I.Share, I.Fee as RIComm, I.UJROHCEDANT, I.UJROHREINS,    
A1.CDate,    
A1.UserID,     
A1.LDate,    
A1.LUserID,    
A1.AUserID,    
A1.AUserDate,
A2.FLDID1, A2.VALUEID1, A2.VALUEDESC1, 0 as FLDSEARCH1,                
A2.FLDID2, A2.VALUEID2, A2.VALUEDESC2, 0 as FLDSEARCH2,                
A2.FLDID3, A2.VALUEID3, A2.VALUEDESC3, 0 as FLDSEARCH3,                
A2.FLDID4, A2.VALUEID4, A2.VALUEDESC4, 0 as FLDSEARCH4,                
A2.FLDID5, A2.VALUEID5, A2.VALUEDESC5, 0 as FLDSEARCH5,                
A2.FLDID6, A2.VALUEID6, A2.VALUEDESC6, 0 as FLDSEARCH6,                
A2.FLDID7, A2.VALUEID7, A2.VALUEDESC7, 0 as FLDSEARCH7,                
A2.FLDID8, A2.VALUEID8, A2.VALUEDESC8, 0 as FLDSEARCH8,                
A2.FLDID9, A2.VALUEID9, A2.VALUEDESC9, 0 as FLDSEARCH9,                
A2.FLDID10, A2.VALUEID10, A2.VALUEDESC10, 0 as FLDSEARCH10,                
A2.FLDID11, A2.VALUEID11, A2.VALUEDESC11, 0 as FLDSEARCH11,                
A2.FLDID12, A2.VALUEID12, A2.VALUEDESC12, 0 as FLDSEARCH12,                
A2.FLDID13, A2.VALUEID13, A2.VALUEDESC13, 0 as FLDSEARCH13,                
A2.FLDID14, A2.VALUEID14, A2.VALUEDESC14, 0 as FLDSEARCH14,                
A2.FLDID15, A2.VALUEID15, A2.VALUEDESC15, 0 as FLDSEARCH15,
A3.ID as BSID, A3.Fee as BSFee, A4.ID as OtherID, A4.Fee as OtherFee
from Cover C    
Inner Join Acceptance A1 on (C.CNO=A1.CNO)    
Left Join AINFO A2 On (A2.ANO=A1.ANO) 
Left join ISource I on (I.CNO=C.CNO)    
Left Join RCover R On (R.ANO=A1.ANO)    
Left Join AccBS A3 on (A3.ANO=A1.ANO and A3.BSType='B')    
Left Join AccBS A4 on (A4.ANO=A1.ANO and A4.BSType='O')    
Where A1.ANO=@P_ANO    
    

GO
create procedure [dbo].[QProAcc] (@ProAcc as varchar(255))
as
select * from ProAcc where ProAcc=@ProAcc


GO
CREATE PROCEDURE [dbo].[QSurveyor] (@P_CNO as integer, @P_ID as varchar(255),@P_SDate as smalldatetime)   
AS  
SELECT *  
FROM Surveyor  
WHERE CNO =@P_CNO and ID=@P_ID and SDate=@P_SDate
  
  
GO

CREATE Procedure [dbo].[QTREATYACC](@P_ANO integer) 
as 
SELECT ACCEPTANCE.ANO, ACCEPTANCE.ADATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE,  RArrHeader.RDate, RArrHeader.NRDate, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, AccAss.CURRENCY_OC, AccAss.Currency, 
sum(case accass.code+accass.type 
when 'PIT' then accass.amount_oc 
when 'PIX' then accass.amount_oc 
else 0 end) as Premium, 

sum(case accass.code+accass.type 
when 'UIT' then accass.amount_oc 
when 'UIX' then accass.amount_oc 
else 0 end) as UjrohCedant, 

sum(case accass.code+accass.type 
when 'AIT' then accass.amount_oc 
when 'AIX' then accass.amount_oc 
else 0 end) as Claim, 

sum(case accass.code+accass.type 
when 'RIT' then accass.amount_oc 
when 'RIX' then accass.amount_oc 
else 0 end) as Subrogation, 

sum(case accass.code+accass.type 
when 'CIT' then accass.amount_oc 
when 'CIX' then accass.amount_oc 
else 0 end) as Commission, 

sum(case accass.code+accass.type 
when 'FIT' then accass.amount_oc 
when 'FIX' then accass.amount_oc 
else 0 end) as Fee, 

sum(case accass.code+accass.type 
when 'TIT' then accass.amount_oc 
when 'TIX' then accass.amount_oc 
else 0 end) as Tax, 

sum(case accass.code+accass.type 
when 'CBO' then accass.amount_oc 
when 'OIT' then accass.amount_oc 
when 'OIX' then accass.amount_oc 
else 0 end) as Other, 

sum(case accass.code+accass.type 
when 'DIT' then accass.amount_oc 
when 'DIX' then accass.amount_oc 
else 0 end) as Fund, 
Max(PCalc.TSI) as TSI 
FROM ACCEPTANCE 
Inner Join RARRHEADER on (RArrHeader.ANO=Acceptance.ANO) 
Left Join PCalc on (PCalc.ANO=Acceptance.ANO) 
Left Join AccAss on (AccAss.ANO=Acceptance.ANO) 
WHERE Acceptance.ANO=@P_ANO 
GROUP BY ACCEPTANCE.ANO, ACCEPTANCE.ADATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE,  RArrHeader.RDate, RArrHeader.NRDate, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, AccAss.CURRENCY_OC, AccAss.CURRENCY; 


GO
CREATE procedure [dbo].[SP_PopulateTCData](@P_NumRecords as int) 
as 

Declare @SQL as varchar(4096) 

Select @SQL='' 
Select @SQL = @SQL + 'Update G1 Set StatPop=G2.StatPop ' 
Select @SQL = @SQL + ' From GenCla G1 ' 
Select @SQL = @SQL + ' Inner Join ' 
Select @SQL = @SQL + ' ( ' 
Select @SQL = @SQL + '     Select COB, OrderNo, Count(*) StatPop ' 
Select @SQL = @SQL + '     from ' 
Select @SQL = @SQL + ' ( ' 
Select @SQL = @SQL + ' Select TOP ' + cast(@P_NumRecords as varchar(100))+ ' T.COB, A2.OrderNo ' 
Select @SQL = @SQL + ' from Acceptance A1, AccCla A2, Cover C, TOC T ' 
Select @SQL = @SQL + ' Where T.TOC=C.TOC and C.CNO=A1.CNO and A2.ANO=A1.ANO ' 
Select @SQL = @SQL + ' Order by A1.ANO Desc ' 
Select @SQL = @SQL + '     ) TC ' 
Select @SQL = @SQL + ' Group By COB, OrderNo ' 
Select @SQL = @SQL + ' ) G2 on (G2.COB=G1.COB and G2.OrderNo=G1.OrderNo) ' 
Execute (@SQL) 

Select @SQL='' 
Select @SQL = @SQL + 'Update G1 Set StatPop=G2.StatPop ' 
Select @SQL = @SQL + ' From GenCON G1 ' 
Select @SQL = @SQL + ' Inner Join ' 
Select @SQL = @SQL + ' ( ' 
Select @SQL = @SQL + '     Select COB, OrderNo, Count(*) StatPop ' 
Select @SQL = @SQL + '     from ' 
Select @SQL = @SQL + ' ( ' 
Select @SQL = @SQL + ' Select TOP ' + cast(@P_NumRecords as varchar(100))+ ' T.COB, A2.OrderNo ' 
Select @SQL = @SQL + ' from Acceptance A1, AccCON A2, Cover C, TOC T ' 
Select @SQL = @SQL + ' Where T.TOC=C.TOC and C.CNO=A1.CNO and A2.ANO=A1.ANO ' 
Select @SQL = @SQL + ' Order by A1.ANO Desc ' 
Select @SQL = @SQL + '     ) TC ' 
Select @SQL = @SQL + ' Group By COB, OrderNo ' 
Select @SQL = @SQL + ' ) G2 on (G2.COB=G1.COB and G2.OrderNo=G1.OrderNo) ' 
Execute (@SQL) 


Select @SQL='' 
Select @SQL = @SQL + 'Update G1 Set StatPop=G2.StatPop ' 
Select @SQL = @SQL + ' From GenEX G1 ' 
Select @SQL = @SQL + ' Inner Join ' 
Select @SQL = @SQL + ' ( ' 
Select @SQL = @SQL + '     Select COB, OrderNo, Count(*) StatPop ' 
Select @SQL = @SQL + '     from ' 
Select @SQL = @SQL + ' ( ' 
Select @SQL = @SQL + ' Select TOP ' + cast(@P_NumRecords as varchar(100))+ ' T.COB, A2.OrderNo ' 
Select @SQL = @SQL + ' from Acceptance A1, AccEX A2, Cover C, TOC T ' 
Select @SQL = @SQL + ' Where T.TOC=C.TOC and C.CNO=A1.CNO and A2.ANO=A1.ANO ' 
Select @SQL = @SQL + ' Order by A1.ANO Desc ' 
Select @SQL = @SQL + '     ) TC ' 
Select @SQL = @SQL + ' Group By COB, OrderNo ' 
Select @SQL = @SQL + ' ) G2 on (G2.COB=G1.COB and G2.OrderNo=G1.OrderNo) ' 
Execute (@SQL) 


GO


CREATE PROCEDURE [dbo].[View03] (@pANO as integer) 
AS
SELECT Acceptance.*, [Cover].[CoverNo], [Cover].[CoverDate], [Cover].[ExpDate], [Cover].[Voyage], [Cover].[OpenFlag]
FROM Acceptance, Cover
WHERE [Cover].[CNO]=[Acceptance].[CNO] And [Acceptance].[ANO]=@pANO

GO

CREATE PROCEDURE [dbo].[View05L1] (@p_ANO as integer)    
AS    

Select ANO, Currency, sum(Rate) as Rate, sum(TSI) as TSI, sum(OurShare) as OurShare, sum(Gross) as Gross, sum(CRate) as CRate, sum(Premium) as Premium, sum(Discount) as Discount, sum(Commission) as Commission, sum(Vat) as Vat, sum(Tax) as Tax, sum(FeeDuty) as FeeDuty    
      
From    
(    
SELECT @P_ANO as ANO, P2.Currency, max(coalesce(P1.Rate,0)) as Rate, max(coalesce(P1.TSI,0)) as TSI, max(coalesce(P1.OurShare,0)) as OurShare, Max(coalesce(P1.Gross,0)) as Gross, max(coalesce(P1.CRate,0)) as CRate, sum(P2.Premium) as Premium, sum(P2.Discount) as Discount, sum(P2.Commission) as Commission, sum(P2.Vat) as Vat, sum(P2.Tax) as Tax, sum(P2.FeeDuty) as FeeDuty   
FROM PREMIUM_CALCULATION(@P_ANO) P2 Left Join PCalc P1 On (P2.ANO=P1.ANO and P2.Currency=P1.Currency)    
Group By P2.Currency    
                     
Union All    
      
Select @P_ANO as ANO, AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, Case When FDTAB.FDType<>'O' Then ACCFD.Amount else -ACCFD.Amount end as FeeDuty    
From AccFD, FDTAB, Acceptance
Where Acceptance.ANO=@P_ANO and AccFD.ANO=Acceptance.ANO and FDTAB.FDID=AccFD.FDID 
            
) P    
Group By ANO, Currency    

GO
CREATE PROCEDURE [dbo].[View05L2] (@p_ANO as integer)    
AS    
SELECT ICalc.Currency, ICalc.Code, TOR.TOR, TOR.Description, ICalc.SDate, ICalc.EDate, RCalc.ExTreatyF,  
sum(ICalc.TSI*(CASE WHEN ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN 1 ELSE ICalc.PCTLoss/(ICalc.PCTLoss+RCover.PAddition) END)) as TSI, Max(RCalc.OGross) as OGross, Max(RCalc.Gross) as Gross    
FROM ICalc, ICover,TOR, RCover, RCalc    
WHERE ICalc.ANO=@p_ANO And ICover.INO=ICalc.INO And TOR.TOR=ICALC.TOR and RCover.ANO=ICalc.ANO and RCover.Code=ICalc.Code and RCover.SDate=ICalc.SDate and RCover.EDate=ICalc.EDate    
and RCalc.ANO=ICalc.ANO and RCalc.Code=ICalc.Code and RCALC.TOR=ICALC.TOR and RCalc.SDate=ICalc.SDate and RCalc.EDate=ICalc.EDate and RCalc.Currency=ICalc.Currency    
Group By ICalc.Currency, ICalc.Code, TOR.TOR, TOR.Description, ICalc.SDate,  ICalc.EDate, RCalc.ExTreatyF  
    
GO

CREATE procedure [dbo].[View05L3] (@p_ANO as integer)    
AS    
SELECT ICalc.Currency, ICalc.Code, TOR.Description, ICover.Remark,     
ICalc.TSI*(CASE WHEN ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN 1 ELSE ICalc.PCTLoss/(ICalc.PCTLoss+RCover.PAddition) END) as TSI,     
ICalc.Gross, ICalc.SDate, ICalc.EDate, ICalc.sRate, ICalc.sProrata    
FROM ICalc, ICover, TOR, RCover    
WHERE ICalc.ANO=@p_ANO And ICover.ANO=@p_ANO and ICover.INO=ICalc.INO     
And TOR.TOR=ICALC.TOR and RCover.ANO=ICalc.ANO and     
RCover.Code=ICalc.Code     
and RCover.SDate=ICalc.SDate and RCover.EDate=ICalc.EDate    
ORDER BY ICalc.SDATE, ICalc.EDATE    
    
GO
CREATE PROCEDURE [dbo].[View07] (@p_ANo as integer)            
AS            
SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo,     
sum(            
case            
  when (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC') and AccAss.Code='P') then accass.Amount            
  else 0            
end            
) AS Premium,             
sum(            
case             
  when accass.code='C' then accass.Amount            
  else 0            
end            
) AS Commision,             
sum(            
case             
  when accass.code='F' then accass.Amount            
  else 0            
end            
) AS Fee,             
sum(            
case             
  when accass.code='D' then accass.Amount            
  else 0            
end            
) AS Duty,             
sum(            
case             
  when accass.code='O' then accass.Amount            
  else 0            
end            
) AS Discount,             
sum(            
case            
  when accass.code='I' then accass.Amount            
  else 0            
end            
) AS OtherIncome,           
sum(            
case            
  when accass.Type in ('DI','IC') and accass.code='U' then -accass.Amount    
  when accass.Type Not in ('DI','IC') and accass.code='U' then accass.Amount    
  else 0            
End            
) AS Ujroh,          
sum(            
case            
  when (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC') and AccAss.Code in ('P','U')) then accass.Amount            
  else 0            
end            
) AS Tabarru,     
sum(            
case            
  when (accass.type in ('PD') and accass.code in ('J')) then accass.Amount            
  else 0            
end            
) AS Deposit,      
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14),0)<>0 then Admlink.Amount_11*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14) else 0 end) as Rounding,    
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14),0)<>0 then Admlink.Amount_13*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14) else 0 end) as VAT,    
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14),0)<>0 then Admlink.Amount_14*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14) else 0 end) as TAX    
FROM AccAss Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo), Acceptance, Profile            
WHERE AccAss.ID=Profile.ID And Acceptance.Ano=Accass.Ano And Acceptance.ANO=@p_ANO            
GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.RefNo, AccAss.Admno, AccAss.Currency, Acceptance.RegNo    
      
         
GO
CREATE PROCEDURE [dbo].[View07A] (@p_ANo as integer)          
AS          
SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo,     
sum(          
case            
  when (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC') and AccAss.Code='P') then accass.Amount            
  else 0            
end            
) AS Premium,          
sum(          
case          
  when accass.code='C' then accass.Amount          
  else 0          
End          
) AS Commision,          
sum(          
case          
  when accass.code='F' then accass.Amount          
  else 0          
End          
) AS Fee,          
sum(          
case          
  when accass.code='D' then accass.Amount          
  else 0          
End          
) AS Duty,          
sum(          
case          
  when accass.code='O' then accass.Amount          
  else 0          
End          
) AS Discount,          
sum(          
case          
  when accass.code='I' then accass.Amount          
  else 0          
End          
) AS OtherIncome,        
sum(          
case          
  when accass.Type in ('DI','IC') and accass.code='U' then -accass.Amount    
  when accass.Type Not in ('DI','IC') and accass.code='U' then accass.Amount    
  else 0          
End          
) AS Ujroh,      
sum(            
case            
  when (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC') and AccAss.Code in ('P','U')) then accass.Amount            
  else 0            
end            
) AS Tabarru,    
sum(            
case            
  when (accass.type in ('PD') and accass.code in ('J')) then accass.Amount            
  else 0            
end            
) AS Deposit,    
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14),0)<>0 then Admlink.Amount_11*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14) else 0 end) as Rounding,    
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14),0)<>0 then Admlink.Amount_13*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14) else 0 end) as VAT,    
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14),0)<>0 then Admlink.Amount_14*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-Admlink.Amount_13-Admlink.Amount_14) else 0 end) as TAX
FROM AccAss Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo), Acceptance, Profile, Acceptance AS M          
WHERE AccAss.ID=Profile.ID And Acceptance.Ano=Accass.Ano And Acceptance.RegNo=M.RegNo and Acceptance.PolicyNo=M.PolicyNo and M.ANO=@P_ANO    
GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.RefNo, AccAss.Admno, AccAss.Currency, Acceptance.RegNo    
          
GO
CREATE function fn_GL_Budget(@P_Branch as varchar(10), @P_Year int)            
RETURNS TABLE            
AS RETURN            
(            
Select Account.Account, Account.Description,         
'' as TOC,  
'' as TOCDesc,  
Month_1+CF_Month_1 as Month_1,         
actual_1 as Actual_1,         
PMonth_1 as PMonth_1,         
Month_2+CF_Month_2 as Month_2,         
actual_2 as Actual_2,         
PMonth_2 as PMonth_2,         
Month_3+CF_Month_3 as Month_3,         
actual_3 as Actual_3,         
PMonth_3 as PMonth_3,         
Month_4+CF_Month_4 as Month_4,         
actual_4 as Actual_4,         
PMonth_4 as PMonth_4,         
Month_5+CF_Month_5 as Month_5,         
actual_5 as Actual_5,         
PMonth_5 as PMonth_5,         
Month_6+CF_Month_6 as Month_6,         
actual_6 as Actual_6,         
PMonth_6 as PMonth_6,         
Month_7+CF_Month_7 as Month_7,         
Actual_7 as Actual_7,         
PMonth_7 as PMonth_7,         
Month_8+CF_Month_8 as Month_8,         
Actual_8 as Actual_8,         
PMonth_8 as PMonth_8,         
Month_9+CF_Month_9 as Month_9,         
Actual_9 as Actual_9,         
PMonth_9 as PMonth_9,         
Month_10+CF_Month_10 as Month_10,         
Actual_10 as Actual_10,         
PMonth_10 as PMonth_10,         
Month_11+CF_Month_11 as Month_11,         
Actual_11 as Actual_11,         
PMonth_11 as PMonth_11,         
Month_12+CF_Month_12 as Month_12,         
Actual_12 as Actual_12,      
PMonth_12 as PMonth_12,         
(Case When GL.Starting is null then 0 else GL.Starting end) as Starting,    
Month_1+Month_2+Month_3+Month_4+Month_5+Month_6+Month_7+Month_8+Month_9+Month_10+Month_11+Month_12+CF_Month_1+CF_Month_2+CF_Month_3+CF_Month_4+CF_Month_5+CF_Month_6+CF_Month_7+CF_Month_8+CF_Month_9+CF_Month_10+CF_Month_11+CF_Month_12 as Total,      
(Case When GL.Starting is null then 0 else GL.Starting end) as Starting_Actual,    
Actual_1+Actual_2+Actual_3+Actual_4+Actual_5+Actual_6+Actual_7+Actual_8+Actual_9+Actual_10+Actual_11+Actual_12 as Total_Actual,    
(Case When pGL.Starting is null then 0 else pGL.Starting end) as Starting_Prognosis,    
PMonth_1+PMonth_2+PMonth_3+PMonth_4+PMonth_5+PMonth_6+PMonth_7+PMonth_8+PMonth_9+PMonth_10+PMonth_11+PMonth_12 as Total_Prognosis      
From Account         
Left Join Budget on (Budget.Account=Account.Account and Budget.Branch=@P_Branch and Budget.Year=@P_Year)          
Left Join GL on (GL.Account=Account.Account and GL.Branch=@P_Branch and GL.Year=@P_Year and GL.Month=1)        
Left Join GL pGL on (pGL.Account=Account.Account and pGL.Branch=@P_Branch and pGL.Year=@P_Year-1 and pGL.Month=1)        
  
union All  
  
Select Account.Account, Account.Description,         
Budget.TOC,   
TOC.Description as TOCDesc,  
Month_1+CF_Month_1 as Month_1,         
actual_1 as Actual_1,         
PMonth_1 as PMonth_1,         
Month_2+CF_Month_2 as Month_2,         
actual_2 as Actual_2,         
PMonth_2 as PMonth_2,         
Month_3+CF_Month_3 as Month_3,         
actual_3 as Actual_3,         
PMonth_3 as PMonth_3,         
Month_4+CF_Month_4 as Month_4,         
actual_4 as Actual_4,         
PMonth_4 as PMonth_4,         
Month_5+CF_Month_5 as Month_5,         
actual_5 as Actual_5,         
PMonth_5 as PMonth_5,         
Month_6+CF_Month_6 as Month_6,         
actual_6 as Actual_6,         
PMonth_6 as PMonth_6,         
Month_7+CF_Month_7 as Month_7,         
Actual_7 as Actual_7,         
PMonth_7 as PMonth_7,         
Month_8+CF_Month_8 as Month_8,         
Actual_8 as Actual_8,         
PMonth_8 as PMonth_8,         
Month_9+CF_Month_9 as Month_9,         
Actual_9 as Actual_9,         
PMonth_9 as PMonth_9,         
Month_10+CF_Month_10 as Month_10,         
Actual_10 as Actual_10,         
PMonth_10 as PMonth_10,         
Month_11+CF_Month_11 as Month_11,         
Actual_11 as Actual_11,         
PMonth_11 as PMonth_11,         
Month_12+CF_Month_12 as Month_12,         
Actual_12 as Actual_12,      
PMonth_12 as PMonth_12,         
0  as Starting,    
Month_1+Month_2+Month_3+Month_4+Month_5+Month_6+Month_7+Month_8+Month_9+Month_10+Month_11+Month_12+CF_Month_1+CF_Month_2+CF_Month_3+CF_Month_4+CF_Month_5+CF_Month_6+CF_Month_7+CF_Month_8+CF_Month_9+CF_Month_10+CF_Month_11+CF_Month_12 as Total,      
0 as Starting_Actual,    
Actual_1+Actual_2+Actual_3+Actual_4+Actual_5+Actual_6+Actual_7+Actual_8+Actual_9+Actual_10+Actual_11+Actual_12 as Total_Actual,    
0 as Starting_Prognosis,    
PMonth_1+PMonth_2+PMonth_3+PMonth_4+PMonth_5+PMonth_6+PMonth_7+PMonth_8+PMonth_9+PMonth_10+PMonth_11+PMonth_12 as Total_Prognosis      
From Account         
Inner Join Budget_TOC  Budget on (Budget.Account=Account.Account and Budget.Branch=@P_Branch and Budget.Year=@P_Year)          
Inner join TOC on (TOC.TOC=Budget.TOC)  
)           

go


update versioning Set verNoWS='2016 V2.1.7',verUpdateWS=getdate()
go