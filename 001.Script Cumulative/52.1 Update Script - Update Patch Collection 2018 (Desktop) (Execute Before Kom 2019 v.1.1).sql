/****** Object:  UserDefinedFunction [dbo].[CL_U_COLLECT]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_U_COLLECT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP 
FUNCTION [dbo].[CL_U_COLLECT]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_R_COLLECT_UNPAID_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP 
FUNCTION [dbo].[CL_R_COLLECT_UNPAID_NET_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_UNPAID_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION 
[dbo].[CL_R_COLLECT_UNPAID_NET_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_UNPAID_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
 [dbo].[CL_R_COLLECT_UNPAID_NET_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_UNPAID_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
 [dbo].[CL_R_COLLECT_UNPAID_GROSS_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_UNPAID_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION 
[dbo].[CL_R_COLLECT_UNPAID_GROSS_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_UNPAID_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
 [dbo].[CL_R_COLLECT_UNPAID_GROSS_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_UNPAID_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
 [dbo].[CL_R_COLLECT_UNPAID_COMM_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_UNPAID_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
 [dbo].[CL_R_COLLECT_UNPAID_COMM_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_UNPAID_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
 [dbo].[CL_R_COLLECT_UNPAID_COMM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_PERIOD_DUE_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
 [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_PERIOD_DUE_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION 
[dbo].[CL_R_COLLECT_PERIOD_DUE_NET_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_PERIOD_DUE_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION 
[dbo].[CL_R_COLLECT_PERIOD_DUE_NET_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_PERIOD_DUE_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION 
[dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_PERIOD_DUE_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION 
[dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_PERIOD_DUE_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
 [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_PERIOD_DUE_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_PERIOD_DUE_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_PERIOD_DUE_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_NOT_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION 
[dbo].[CL_R_COLLECT_NOT_NET_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_NOT_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
 [dbo].[CL_R_COLLECT_NOT_NET_END]
 end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_NOT_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
 [dbo].[CL_R_COLLECT_NOT_NET_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_NOT_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION 
[dbo].[CL_R_COLLECT_NOT_GROSS_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_NOT_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION 
[dbo].[CL_R_COLLECT_NOT_GROSS_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_NOT_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION 
[dbo].[CL_R_COLLECT_NOT_GROSS_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_NOT_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION 
[dbo].[CL_R_COLLECT_NOT_COMM_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_NOT_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION 
[dbo].[CL_R_COLLECT_NOT_COMM_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_NOT_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
 [dbo].[CL_R_COLLECT_NOT_COMM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_HOLD_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
 [dbo].[CL_R_COLLECT_HOLD_NET_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_HOLD_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION 
[dbo].[CL_R_COLLECT_HOLD_NET_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_HOLD_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
 [dbo].[CL_R_COLLECT_HOLD_NET_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_HOLD_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
 [dbo].[CL_R_COLLECT_HOLD_GROSS_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_HOLD_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION 
[dbo].[CL_R_COLLECT_HOLD_GROSS_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_HOLD_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION 
[dbo].[CL_R_COLLECT_HOLD_GROSS_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_HOLD_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_HOLD_COMM_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_HOLD_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_HOLD_COMM_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_HOLD_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_HOLD_COMM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_ALL_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_NET_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_ALL_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_NET_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_ALL_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_NET_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_ALL_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_GROSS_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_ALL_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_GROSS_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_ALL_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_GROSS_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_ALL_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_COMM_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_ALL_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_COMM_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_R_COLLECT_ALL_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_R_COLLECT_ALL_COMM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_UNPAID_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_NET_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_UNPAID_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_NET_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_UNPAID_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_NET_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_UNPAID_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_GROSS_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_UNPAID_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_GROSS_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_UNPAID_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_GROSS_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_UNPAID_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_COMM_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_UNPAID_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_COMM_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_UNPAID_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_UNPAID_COMM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_NET_ALL_BYPOLICYNO]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_PERIOD_NET_ALL_BYPOLICYNO]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_NET_ALL_BYPOLICYNO]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_GROSS_ALL_BYPOLICYNO]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_PERIOD_GROSS_ALL_BYPOLICYNO]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_GROSS_ALL_BYPOLICYNO]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_PERIOD_DUE_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_PERIOD_DUE_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_PERIOD_DUE_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_PERIOD_DUE_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_PERIOD_DUE_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_PERIOD_DUE_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_PERIOD_DUE_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_PERIOD_DUE_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_PERIOD_DUE_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_NOT_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_NET_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_NOT_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_NET_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_NOT_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_NET_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_NOT_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_GROSS_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_NOT_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_GROSS_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_NOT_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_GROSS_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_NOT_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_COMM_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_NOT_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_COMM_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_NOT_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_NOT_COMM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_HOLD_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_NET_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_HOLD_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_NET_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_HOLD_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_NET_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_HOLD_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_GROSS_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_HOLD_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_GROSS_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_HOLD_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_GROSS_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_HOLD_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_COMM_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_HOLD_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_COMM_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_HOLD_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_HOLD_COMM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_ALL_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_NET_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_ALL_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_NET_END]
 end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_ALL_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_NET_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_ALL_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_GROSS_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_ALL_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_GROSS_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_ALL_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_GROSS_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_ALL_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_COMM_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_ALL_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_COMM_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_I_COLLECT_ALL_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_I_COLLECT_ALL_COMM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_UNPAID_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_NET_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_UNPAID_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_NET_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_UNPAID_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_NET_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_UNPAID_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_GROSS_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_UNPAID_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_GROSS_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_UNPAID_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_GROSS_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_UNPAID_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_COMM_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_UNPAID_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_COMM_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_UNPAID_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_UNPAID_COMM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_PERIOD_DUE_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_PERIOD_DUE_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_PERIOD_DUE_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_PERIOD_DUE_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_PERIOD_DUE_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_PERIOD_DUE_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_PERIOD_DUE_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_PERIOD_DUE_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_PERIOD_DUE_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_NOT_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_NET_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_NOT_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_NET_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_NOT_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_NET_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_NOT_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_GROSS_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_NOT_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_GROSS_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_NOT_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_GROSS_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_NOT_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_COMM_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_NOT_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_COMM_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_NOT_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_NOT_COMM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_HOLD_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_NET_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_HOLD_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_NET_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_HOLD_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_NET_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_HOLD_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_GROSS_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_HOLD_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_GROSS_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_HOLD_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_GROSS_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_HOLD_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_COMM_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_HOLD_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_COMM_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_HOLD_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_HOLD_COMM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_ALL_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_NET_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_ALL_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_NET_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_ALL_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_NET_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_ALL_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_GROSS_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_ALL_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_GROSS_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_ALL_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_GROSS_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_ALL_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_COMM_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_ALL_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_COMM_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_F_COLLECT_ALL_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_F_COLLECT_ALL_COMM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_D_COLLECT]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_D_COLLECT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_D_COLLECT]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_TREATY_XOL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_C_COLLECT_ALL_TREATY_XOL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_C_COLLECT_ALL_TREATY_XOL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_TREATY]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_C_COLLECT_ALL_TREATY]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_C_COLLECT_ALL_TREATY]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_SUBROGATION]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_C_COLLECT_ALL_SUBROGATION]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_C_COLLECT_ALL_SUBROGATION]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_SALVAGE]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_C_COLLECT_ALL_SALVAGE]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_C_COLLECT_ALL_SALVAGE]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_MAIPARK]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_C_COLLECT_ALL_MAIPARK]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_C_COLLECT_ALL_MAIPARK]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_FACULTATIVE]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_C_COLLECT_ALL_FACULTATIVE]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_C_COLLECT_ALL_FACULTATIVE]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_BPPDAN]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_C_COLLECT_ALL_BPPDAN]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_C_COLLECT_ALL_BPPDAN]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_C_COLLECT_ALL_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_C_COLLECT_ALL_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_UNPAID_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_NET_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_UNPAID_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_NET_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_UNPAID_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_NET_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_UNPAID_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_GROSS_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_UNPAID_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_GROSS_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_UNPAID_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_GROSS_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_UNPAID_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_COMM_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_UNPAID_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_COMM_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_UNPAID_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_UNPAID_COMM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_PERIOD_DUE_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_PERIOD_DUE_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_PERIOD_DUE_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_PERIOD_DUE_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_PERIOD_DUE_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_PERIOD_DUE_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_PERIOD_DUE_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_PERIOD_DUE_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_PERIOD_DUE_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_NOT_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_NET_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_NOT_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_NET_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_NOT_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_NET_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_NOT_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_GROSS_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_NOT_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_GROSS_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_NOT_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_GROSS_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_NOT_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_COMM_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_NOT_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_COMM_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_NOT_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_NOT_COMM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_HOLD_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_NET_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_HOLD_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_NET_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_HOLD_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_NET_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_HOLD_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_GROSS_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_HOLD_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_GROSS_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_HOLD_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_GROSS_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_HOLD_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_COMM_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_HOLD_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_COMM_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_HOLD_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_HOLD_COMM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_ALL_NET_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_NET_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_ALL_NET_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_NET_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_ALL_NET_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_NET_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_ALL_GROSS_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_GROSS_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_ALL_GROSS_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_GROSS_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_ALL_GROSS_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_GROSS_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_ALL_COMM_NEW]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_COMM_NEW]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_ALL_COMM_END]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_COMM_END]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CL_A_COLLECT_ALL_COMM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[CL_A_COLLECT_ALL_COMM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO













CREATE function [dbo].[CL_A_COLLECT_ALL_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code    
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Subject='Premium'  
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)  
  
 
GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO














CREATE function [dbo].[CL_A_COLLECT_ALL_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code    
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.AdmNo=AccAss.AdmNo  
and Acceptance.AType in ('E','C')  
and Acceptance.ANO=AccAss.ANO   
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)  
  
  
  












GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO















CREATE function [dbo].[CL_A_COLLECT_ALL_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code    
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.AdmNo=AccAss.AdmNo  
and Acceptance.AType='N'  
and Acceptance.ANO=AccAss.ANO   
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)  
  
  
  
  
  
  
  













GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO















CREATE function [dbo].[CL_A_COLLECT_ALL_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code    
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('DI','IC','CF','JP','SO')  
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Subject='Premium'  
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)  
  
  












GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO














CREATE function [dbo].[CL_A_COLLECT_ALL_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code    
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('DI','IC','CF','JP','SO')  
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.AdmNo=AccAss.AdmNo  
and Acceptance.AType in ('E','C')  
and Acceptance.ANO=AccAss.ANO   
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)  
  
  












GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO













CREATE function [dbo].[CL_A_COLLECT_ALL_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code    
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('DI','IC','CF','JP','SO')  
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.AdmNo=AccAss.AdmNo  
and Acceptance.AType='N'  
and Acceptance.ANO=AccAss.ANO   
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)  
  
  












GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO













CREATE function [dbo].[CL_A_COLLECT_ALL_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code    
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Subject='Premium'  
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)  
  
  

GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO














CREATE function [dbo].[CL_A_COLLECT_ALL_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code    
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.AdmNo=AccAss.AdmNo  
and Acceptance.AType in ('E','C')  
and Acceptance.ANO=AccAss.ANO   
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)  
  
  
  












GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_ALL_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO















CREATE function [dbo].[CL_A_COLLECT_ALL_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code    
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.AdmNo=AccAss.AdmNo  
and Acceptance.AType='N'  
and Acceptance.ANO=AccAss.ANO   
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)  
  
  
  
  
  
  
  













GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--


CREATE function [dbo].[CL_A_COLLECT_HOLD_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_A_COLLECT_HOLD_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_A_COLLECT_HOLD_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE function [dbo].[CL_A_COLLECT_HOLD_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)






GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_A_COLLECT_HOLD_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_A_COLLECT_HOLD_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--


CREATE function [dbo].[CL_A_COLLECT_HOLD_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_A_COLLECT_HOLD_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_HOLD_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_A_COLLECT_HOLD_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--


--


CREATE function [dbo].[CL_A_COLLECT_NOT_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_A_COLLECT_NOT_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_A_COLLECT_NOT_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

CREATE function [dbo].[CL_A_COLLECT_NOT_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_A_COLLECT_NOT_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_A_COLLECT_NOT_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--


--


CREATE function [dbo].[CL_A_COLLECT_NOT_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_A_COLLECT_NOT_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_NOT_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_A_COLLECT_NOT_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal, Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code    
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Subject='Premium'  
)  






GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)








GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_COMM_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)






GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Subject='Premium'
)






GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)








GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_GROSS_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)






GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal, Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code    
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Subject='Premium'  
)  






GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)








GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






Create function [dbo].[CL_A_COLLECT_PERIOD_DUE_NET_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Admlink.Source like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)






GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















--

--


CREATE function [dbo].[CL_A_COLLECT_UNPAID_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)






















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_A_COLLECT_UNPAID_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_A_COLLECT_UNPAID_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















--

CREATE function [dbo].[CL_A_COLLECT_UNPAID_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)






















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_A_COLLECT_UNPAID_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_A_COLLECT_UNPAID_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















--

--


CREATE function [dbo].[CL_A_COLLECT_UNPAID_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)






















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_A_COLLECT_UNPAID_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType in ('E','C')
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_A_COLLECT_UNPAID_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_A_COLLECT_UNPAID_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.AType='N'
and Acceptance.ANO=AccAss.ANO 
and admlink.Source Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO










CREATE function [dbo].[CL_C_COLLECT_ALL_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code    
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and ((Admlink.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP')) or (Admlink.Type in ('OP') and Admlink.Amount_8+Admlink.Amount_10<>0))
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Subject='Claim'  
and Profile.ID Like @P_ID+'%'  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)  
  
  






GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_BPPDAN]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO










CREATE function [dbo].[CL_C_COLLECT_ALL_BPPDAN] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('CP')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)










GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_FACULTATIVE]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO










CREATE function [dbo].[CL_C_COLLECT_ALL_FACULTATIVE] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('FO')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)










GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_MAIPARK]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO










CREATE function [dbo].[CL_C_COLLECT_ALL_MAIPARK] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('XP')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)










GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_SALVAGE]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE function [dbo].[CL_C_COLLECT_ALL_SALVAGE] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))      
RETURNS TABLE      
AS RETURN      
(      
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,       
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,      
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code        
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)      
where  Voucher.Voucher=AdmLink.Voucher       
and ProAcc.ProAcc=Voucher.ProAcc       
and ProAcc.[ID]=[Profile].[ID]       
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) --Salvage/Excess    
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate      
and Admlink.Subject='Claim'      
and Profile.ID Like @P_ID+'%'      
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)      



GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_SUBROGATION]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE function [dbo].[CL_C_COLLECT_ALL_SUBROGATION] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code    
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('OP') and Admlink.Amount_10<>0	--Subrogation
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Subject='Claim'  
and Profile.ID Like @P_ID+'%'  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)  
  






GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_TREATY]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO










CREATE function [dbo].[CL_C_COLLECT_ALL_TREATY] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DC','QS','QP','S1','S2','S3','AF','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)










GO

/****** Object:  UserDefinedFunction [dbo].[CL_C_COLLECT_ALL_TREATY_XOL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO










CREATE function [dbo].[CL_C_COLLECT_ALL_TREATY_XOL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Claim'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)


























GO

/****** Object:  UserDefinedFunction [dbo].[CL_D_COLLECT]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[CL_D_COLLECT](@P_CollNo as varchar(50)) 
RETURNS TABLE 
AS RETURN 
( 
Select C1.RefNo as NoGrouping, Admlink.A_PolicyNo as NoPolis, Admlink.RefNo as NoKontrak, C2.Amount, (Select Count(*) from CollectionV Where CollNo=@P_CollNo) as JumlahKontrak, C3.TAmount as TotalAmount 
from CollectionH C1, CollectionV C2, CollAmount C3, Admlink 
Where C2.CollNo=C1.CollNo and C3.CollNo=C1.CollNo and C3.Currency=C2.Currency and Admlink.Voucher=C2.Voucher 
and C1.CollNo=@P_CollNo 
) 
 
 
 


GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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
Profile.Name, V.debtorF,V.CreditorF, A.RefType,A.A_PolicyNo,V.Branch, A.BatchNo, A.Code  
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
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>V.CollNo and CollectionV.Voucher=V.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=V.Voucher)
)  



GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_F_COLLECT_ALL_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_F_COLLECT_ALL_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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
Profile.Name, V.debtorF,V.CreditorF, A.RefType,A.A_PolicyNo,V.Branch, A.BatchNo, A.Code  
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
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>V.CollNo and CollectionV.Voucher=V.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=V.Voucher)

)  



GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_F_COLLECT_ALL_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_F_COLLECT_ALL_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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
Profile.Name, V.debtorF,V.CreditorF, A.RefType,A.A_PolicyNo, V.Branch, A.BatchNo, A.Code  
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
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>V.CollNo and CollectionV.Voucher=V.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=V.Voucher)
)  




GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_F_COLLECT_ALL_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_ALL_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_F_COLLECT_ALL_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

CREATE function [dbo].[CL_F_COLLECT_HOLD_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_F_COLLECT_HOLD_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_F_COLLECT_HOLD_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















--


CREATE function [dbo].[CL_F_COLLECT_HOLD_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_F_COLLECT_HOLD_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_F_COLLECT_HOLD_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

CREATE function [dbo].[CL_F_COLLECT_HOLD_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_F_COLLECT_HOLD_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_HOLD_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_F_COLLECT_HOLD_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

CREATE function [dbo].[CL_F_COLLECT_NOT_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_F_COLLECT_NOT_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_F_COLLECT_NOT_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

CREATE function [dbo].[CL_F_COLLECT_NOT_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_F_COLLECT_NOT_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_F_COLLECT_NOT_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

CREATE function [dbo].[CL_F_COLLECT_NOT_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[CL_F_COLLECT_NOT_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_NOT_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_F_COLLECT_NOT_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal, Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code    
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Subject='Premium'  
)  






GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)








GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_COMM_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)






GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Subject='Premium'
)






GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)








GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_GROSS_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)






GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal, Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code    
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Subject='Premium'  
)  






GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)








GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






Create function [dbo].[CL_F_COLLECT_PERIOD_DUE_NET_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)






GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















--

CREATE function [dbo].[CL_F_COLLECT_UNPAID_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)






















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_F_COLLECT_UNPAID_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_F_COLLECT_UNPAID_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















--

CREATE function [dbo].[CL_F_COLLECT_UNPAID_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_F_COLLECT_UNPAID_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_F_COLLECT_UNPAID_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















--

CREATE function [dbo].[CL_F_COLLECT_UNPAID_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)






















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_F_COLLECT_UNPAID_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_F_COLLECT_UNPAID_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_F_COLLECT_UNPAID_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO












CREATE function [dbo].[CL_I_COLLECT_ALL_COMM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal, Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code    
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Subject='Premium'  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)  












GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_I_COLLECT_ALL_COMM_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_I_COLLECT_ALL_COMM_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

CREATE function [dbo].[CL_I_COLLECT_ALL_GROSS_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_I_COLLECT_ALL_GROSS_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_I_COLLECT_ALL_GROSS_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO












CREATE function [dbo].[CL_I_COLLECT_ALL_NET_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal, Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code    
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Subject='Premium'  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)  












GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_I_COLLECT_ALL_NET_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_ALL_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_I_COLLECT_ALL_NET_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

--

CREATE function [dbo].[CL_I_COLLECT_HOLD_COMM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_I_COLLECT_HOLD_COMM_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_I_COLLECT_HOLD_COMM_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--
--

CREATE function [dbo].[CL_I_COLLECT_HOLD_GROSS_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_I_COLLECT_HOLD_GROSS_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_I_COLLECT_HOLD_GROSS_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

--

CREATE function [dbo].[CL_I_COLLECT_HOLD_NET_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_I_COLLECT_HOLD_NET_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_HOLD_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_I_COLLECT_HOLD_NET_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

CREATE function [dbo].[CL_I_COLLECT_NOT_COMM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_I_COLLECT_NOT_COMM_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_I_COLLECT_NOT_COMM_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

CREATE function [dbo].[CL_I_COLLECT_NOT_GROSS_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_I_COLLECT_NOT_GROSS_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_I_COLLECT_NOT_GROSS_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

CREATE function [dbo].[CL_I_COLLECT_NOT_NET_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_I_COLLECT_NOT_NET_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_NOT_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_I_COLLECT_NOT_NET_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)



















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal, Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code    
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.Subject='Premium'  
)  






GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)








GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_COMM_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)






GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.Subject='Premium'
)






GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)








GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_GROSS_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)






GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal, Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code    
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.Subject='Premium'  
)  






GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)








GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






Create function [dbo].[CL_I_COLLECT_PERIOD_DUE_NET_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and Voucher.AmountDue<>0  
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)






GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_GROSS_ALL_BYPOLICYNO]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create function [dbo].[CL_I_COLLECT_PERIOD_GROSS_ALL_BYPOLICYNO](@P_ANO as Int)  
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  0 as Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC as Nominal,
Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],nVoucher Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), AccAss, Acceptance
where Acceptance.ANO=@P_ANO and AccAss.ANO=Acceptance.ANO and Admlink.AdmNo=AccAss.AdmNo and Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')

Union All

select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  0 as Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC as Nominal,
Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],nVoucher Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), AccAss, Acceptance
where Acceptance.LANO=@P_ANO and AccAss.ANO=Acceptance.ANO and Admlink.AdmNo=AccAss.AdmNo and Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
)




GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_PERIOD_NET_ALL_BYPOLICYNO]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create function [dbo].[CL_I_COLLECT_PERIOD_NET_ALL_BYPOLICYNO](@P_ANO as int)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  0 as Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC as Nominal,
Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],nVoucher Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), AccAss, Acceptance
where Acceptance.ANO=@P_ANO and AccAss.ANO=Acceptance.ANO and Admlink.AdmNo=AccAss.AdmNo and Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and Exists (Select Top 1 Source from Acceptance A Where A.ANO=@P_ANO and A.Source=Admlink.Source)

Union All

select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  0 as Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC as Nominal,
Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],nVoucher Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), AccAss, Acceptance
where Acceptance.LANO=@P_ANO and AccAss.ANO=Acceptance.ANO and Admlink.AdmNo=AccAss.AdmNo and Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and Exists (Select Top 1 Source from Acceptance A Where A.ANO=@P_ANO and A.Source=Admlink.Source)
)  





GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















--

--

CREATE function [dbo].[CL_I_COLLECT_UNPAID_COMM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_I_COLLECT_UNPAID_COMM_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)






















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_I_COLLECT_UNPAID_COMM_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















--


--

CREATE function [dbo].[CL_I_COLLECT_UNPAID_GROSS_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_I_COLLECT_UNPAID_GROSS_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_I_COLLECT_UNPAID_GROSS_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















--

--

CREATE function [dbo].[CL_I_COLLECT_UNPAID_NET_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_I_COLLECT_UNPAID_NET_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)






















GO

/****** Object:  UserDefinedFunction [dbo].[CL_I_COLLECT_UNPAID_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_I_COLLECT_UNPAID_NET_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















--

CREATE function [dbo].[CL_R_COLLECT_ALL_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_R_COLLECT_ALL_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_R_COLLECT_ALL_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


















--

CREATE function [dbo].[CL_R_COLLECT_ALL_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_R_COLLECT_ALL_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_R_COLLECT_ALL_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















--

CREATE function [dbo].[CL_R_COLLECT_ALL_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_R_COLLECT_ALL_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_ALL_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_R_COLLECT_ALL_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















--

CREATE function [dbo].[CL_R_COLLECT_HOLD_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_R_COLLECT_HOLD_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_R_COLLECT_HOLD_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















--


CREATE function [dbo].[CL_R_COLLECT_HOLD_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_R_COLLECT_HOLD_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_R_COLLECT_HOLD_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















--

CREATE function [dbo].[CL_R_COLLECT_HOLD_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)





















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_R_COLLECT_HOLD_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_HOLD_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_R_COLLECT_HOLD_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















--

CREATE function [dbo].[CL_R_COLLECT_NOT_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_R_COLLECT_NOT_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_R_COLLECT_NOT_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















--

CREATE function [dbo].[CL_R_COLLECT_NOT_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_R_COLLECT_NOT_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_R_COLLECT_NOT_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















--

CREATE function [dbo].[CL_R_COLLECT_NOT_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[CL_R_COLLECT_NOT_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_NOT_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_R_COLLECT_NOT_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)




















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal, Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code    
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Subject='Premium'  
)  






GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)








GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_COMM_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA')
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)






GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Subject='Premium'
)






GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX') 
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)








GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_GROSS_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)






GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo,Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal, Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code    
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','IR','IT','IX')   
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.Subject='Premium'  
)  






GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_END](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','IR','IT','IX') 
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
)








GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






Create function [dbo].[CL_R_COLLECT_PERIOD_DUE_NET_NEW](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as varchar(10))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','IR','IT','IX') 
and Admlink.ISType in ('R','T')
and Admlink.ID  like @P_ID+'%'
and Voucher.AmountDue<>0  
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
)






GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_COMM_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















--

CREATE function [dbo].[CL_R_COLLECT_UNPAID_COMM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)






















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_COMM_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_R_COLLECT_UNPAID_COMM_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)






















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_COMM_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO





















CREATE function [dbo].[CL_R_COLLECT_UNPAID_COMM_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)










GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_GROSS_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















--

CREATE function [dbo].[CL_R_COLLECT_UNPAID_GROSS_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)






















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_GROSS_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_R_COLLECT_UNPAID_GROSS_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)






















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_GROSS_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO





















CREATE function [dbo].[CL_R_COLLECT_UNPAID_GROSS_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)






















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_NET_ALL]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















--

CREATE function [dbo].[CL_R_COLLECT_UNPAID_NET_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.Subject='Premium'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)






















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_NET_END]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




















CREATE function [dbo].[CL_R_COLLECT_UNPAID_NET_END] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType in ('E','C')
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)






















GO

/****** Object:  UserDefinedFunction [dbo].[CL_R_COLLECT_UNPAID_NET_NEW]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO





















CREATE function [dbo].[CL_R_COLLECT_UNPAID_NET_NEW] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code), Acceptance, AccAss
where  Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BA','BO','IR','IT','IX')
and Admlink.ISType in ('R','T')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate
and Admlink.AdmNo=AccAss.AdmNo
and Acceptance.ANO=AccAss.ANO
and Acceptance.AType='N'
and Profile.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)


)










GO

/****** Object:  UserDefinedFunction [dbo].[CL_U_COLLECT]    Script Date: 12/5/2017 9:52:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[CL_U_COLLECT](@P_PDate smalldatetime, @P_Voucher as varchar(20), @P_PolicyNo as varchar(50), @P_RefNo as varchar(50)) 
RETURNS TABLE 
AS RETURN 
( 
select Voucher.RefNo,Voucher.Voucher, Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, Voucher.[Currency], Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal, Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , 
Admlink.AccountNo, Admlink.Extra_4 
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_PDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) 
where Voucher.Voucher=AdmLink.Voucher 
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO') 
and Admlink.ISType in ('I','L','C') 
and Admlink.Subject='Premium' 
and Admlink.Voucher Like @P_Voucher 
and Admlink.A_PolicyNo Like @P_PolicyNo 
and Admlink.RefNo Like @P_RefNo 
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

) 



GO



/****** Object:  UserDefinedFunction [dbo].[DB_U_R_DISBURSE]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_U_R_DISBURSE]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[DB_U_R_DISBURSE]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_U_I_DISBURSE]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_U_I_DISBURSE]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_U_I_DISBURSE]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_U_F_DISBURSE]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_U_F_DISBURSE]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_U_F_DISBURSE]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_UNPAID_PREMIUM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_UNPAID_PREMIUM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_UNPAID_PREMIUM_ID]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_UNPAID_PREMIUM_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_UNPAID_PREMIUM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_UNPAID_PREMIUM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_UNPAID_CLAIM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_UNPAID_CLAIM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_UNPAID_CLAIM_ID]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_UNPAID_CLAIM_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_UNPAID_CLAIM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_UNPAID_CLAIM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_UNPAID_ALL_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_UNPAID_ALL_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_UNPAID_ALL_ID]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_UNPAID_ALL_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_UNPAID_ALL_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_UNPAID_ALL_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_PERIOD_DUE_PREMIUM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_PERIOD_DUE_PREMIUM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_PERIOD_DUE_PREMIUM_ID]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_PERIOD_DUE_PREMIUM_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_PERIOD_DUE_PREMIUM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_PERIOD_DUE_PREMIUM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_PERIOD_DUE_CLAIM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_PERIOD_DUE_CLAIM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_PERIOD_DUE_CLAIM_ID]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_PERIOD_DUE_CLAIM_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_PERIOD_DUE_CLAIM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_PERIOD_DUE_CLAIM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_PERIOD_DUE_ALL_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_PERIOD_DUE_ALL_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_PERIOD_DUE_ALL_ID]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_PERIOD_DUE_ALL_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_PERIOD_DUE_ALL_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_PERIOD_DUE_ALL_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_NOT_PREMIUM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_NOT_PREMIUM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_NOT_PREMIUM_ID]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_NOT_PREMIUM_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_NOT_PREMIUM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_NOT_PREMIUM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_NOT_CLAIM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_NOT_CLAIM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_NOT_CLAIM_ID]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_NOT_CLAIM_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_NOT_CLAIM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_NOT_CLAIM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_NOT_ALL_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_NOT_ALL_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_NOT_ALL_ID]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_NOT_ALL_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_NOT_ALL_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_NOT_ALL_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_HOLD_PREMIUM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_HOLD_PREMIUM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_HOLD_PREMIUM_ID]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_HOLD_PREMIUM_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_HOLD_PREMIUM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_HOLD_PREMIUM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_HOLD_CLAIM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_HOLD_CLAIM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_HOLD_CLAIM_ID]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_HOLD_CLAIM_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_HOLD_CLAIM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_HOLD_CLAIM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_HOLD_ALL_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_HOLD_ALL_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_HOLD_ALL_ID]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_HOLD_ALL_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_HOLD_ALL_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_HOLD_ALL_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_ALL_PREMIUM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_ALL_PREMIUM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_ALL_PREMIUM_ID]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_ALL_PREMIUM_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_ALL_PREMIUM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_ALL_PREMIUM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_ALL_CLAIM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_ALL_CLAIM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_ALL_CLAIM_ID]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_ALL_CLAIM_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_ALL_CLAIM_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_ALL_CLAIM_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_ALL_ALL_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_ALL_ALL_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_ALL_ALL_ID]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_ALL_ALL_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_R_DISBURSE_ALL_ALL_ALL]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_R_DISBURSE_ALL_ALL_ALL]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_UNPAID_EXCESSREFUND_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_I_DISBURSE_UNPAID_EXCESSREFUND_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_UNPAID_EXCESSREFUND_ID]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_UNPAID_EXCESSREFUND_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_I_DISBURSE_UNPAID_EXCESSREFUND_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_UNPAID_EXCESSREFUND_CLAIMANT]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_UNPAID_CLAIM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_I_DISBURSE_UNPAID_CLAIM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_UNPAID_CLAIM_ID]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_UNPAID_CLAIM_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_I_DISBURSE_UNPAID_CLAIM_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_UNPAID_CLAIM_CLAIMANT]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_NOT_EXCESSREFUND_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_I_DISBURSE_NOT_EXCESSREFUND_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_NOT_EXCESSREFUND_ID]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_NOT_EXCESSREFUND_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_I_DISBURSE_NOT_EXCESSREFUND_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_NOT_EXCESSREFUND_CLAIMANT]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_NOT_CLAIM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_I_DISBURSE_NOT_CLAIM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_NOT_CLAIM_ID]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_NOT_CLAIM_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_I_DISBURSE_NOT_CLAIM_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_NOT_CLAIM_CLAIMANT]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_HOLD_EXCESSREFUND_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_I_DISBURSE_HOLD_EXCESSREFUND_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_HOLD_EXCESSREFUND_ID]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_HOLD_EXCESSREFUND_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_I_DISBURSE_HOLD_EXCESSREFUND_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_HOLD_EXCESSREFUND_CLAIMANT]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_HOLD_CLAIM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_I_DISBURSE_HOLD_CLAIM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_HOLD_CLAIM_ID]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_HOLD_CLAIM_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_I_DISBURSE_HOLD_CLAIM_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_HOLD_CLAIM_CLAIMANT]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_ALL_EXCESSREFUND_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_I_DISBURSE_ALL_EXCESSREFUND_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_ALL_EXCESSREFUND_ID]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_ALL_EXCESSREFUND_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_I_DISBURSE_ALL_EXCESSREFUND_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_ALL_EXCESSREFUND_CLAIMANT]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_ALL_CLAIM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_I_DISBURSE_ALL_CLAIM_ID]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_ALL_CLAIM_ID]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_ALL_CLAIM_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_I_DISBURSE_ALL_CLAIM_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[DB_I_DISBURSE_ALL_CLAIM_CLAIMANT]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_UNPAID_EXCESSREFUND_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_F_DISBURSE_UNPAID_EXCESSREFUND_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_F_DISBURSE_UNPAID_EXCESSREFUND_CLAIMANT]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_UNPAID_CLAIM_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_F_DISBURSE_UNPAID_CLAIM_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[DB_F_DISBURSE_UNPAID_CLAIM_CLAIMANT]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_NOT_EXCESSREFUND_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_F_DISBURSE_NOT_EXCESSREFUND_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[DB_F_DISBURSE_NOT_EXCESSREFUND_CLAIMANT]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_NOT_CLAIM_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_F_DISBURSE_NOT_CLAIM_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_F_DISBURSE_NOT_CLAIM_CLAIMANT]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_HOLD_EXCESSREFUND_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_F_DISBURSE_HOLD_EXCESSREFUND_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_F_DISBURSE_HOLD_EXCESSREFUND_CLAIMANT]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_HOLD_CLAIM_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_F_DISBURSE_HOLD_CLAIM_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_F_DISBURSE_HOLD_CLAIM_CLAIMANT]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_ALL_EXCESSREFUND_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_F_DISBURSE_ALL_EXCESSREFUND_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION [dbo].[DB_F_DISBURSE_ALL_EXCESSREFUND_CLAIMANT]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_ALL_CLAIM_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[DB_F_DISBURSE_ALL_CLAIM_CLAIMANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION [dbo].[DB_F_DISBURSE_ALL_CLAIM_CLAIMANT]
end
GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_ALL_CLAIM_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[DB_F_DISBURSE_ALL_CLAIM_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile], nVoucher Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate
and round(Voucher.Nominal_CC-Voucher.Diff_CC - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0   
and Admlink.A_ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

  
)    
  


GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_ALL_EXCESSREFUND_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[DB_F_DISBURSE_ALL_EXCESSREFUND_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile], Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
and Admlink.A_ID Like @P_ID+'%'    
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)    
  


GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_HOLD_CLAIM_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[DB_F_DISBURSE_HOLD_CLAIM_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))    
RETURNS TABLE      
AS RETURN      
(      
     
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile], nVoucher Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate
and Admlink.A_ID Like @P_ID+'%'
and round(Voucher.Nominal_CC-Voucher.Diff_CC - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0   
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)          
)      



GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_HOLD_EXCESSREFUND_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[DB_F_DISBURSE_HOLD_EXCESSREFUND_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))    
RETURNS TABLE      
AS RETURN      
(      
     
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile], Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)    
and Admlink.A_ID Like @P_ID+'%'      
)      



GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_NOT_CLAIM_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[DB_F_DISBURSE_NOT_CLAIM_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile], nVoucher Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate
and Admlink.A_ID Like @P_ID+'%'
and round(Voucher.Nominal_CC-Voucher.Diff_CC - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0   
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)    
  


GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_NOT_EXCESSREFUND_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[DB_F_DISBURSE_NOT_EXCESSREFUND_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile], Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
and Admlink.A_ID Like @P_ID+'%'    
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)    
  


GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_UNPAID_CLAIM_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[DB_F_DISBURSE_UNPAID_CLAIM_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile], nVoucher Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate
and Admlink.A_ID Like @P_ID+'%'
and round(Voucher.Nominal_CC-Voucher.Diff_CC - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0   
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)    
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)   
  
  
  
  
  

GO

/****** Object:  UserDefinedFunction [dbo].[DB_F_DISBURSE_UNPAID_EXCESSREFUND_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[DB_F_DISBURSE_UNPAID_EXCESSREFUND_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile], Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)    
and Admlink.A_ID Like @P_ID+'%'      
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)   
  


GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_ALL_CLAIM_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[DB_I_DISBURSE_ALL_CLAIM_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate 
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)    



GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_ALL_CLAIM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[DB_I_DISBURSE_ALL_CLAIM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate 
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 
 and AdmLink.ID Like @P_ID+'%'  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)    
  


GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_ALL_EXCESSREFUND_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[DB_I_DISBURSE_ALL_EXCESSREFUND_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)    



GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_ALL_EXCESSREFUND_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[DB_I_DISBURSE_ALL_EXCESSREFUND_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
and AdmLink.ID Like @P_ID+'%'  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)    
  


GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_HOLD_CLAIM_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[DB_I_DISBURSE_HOLD_CLAIM_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)    
RETURNS TABLE    
AS RETURN    
(    
   
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate 
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)    
)    
    


GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_HOLD_CLAIM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[DB_I_DISBURSE_HOLD_CLAIM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))    
RETURNS TABLE    
AS RETURN    
(    
   
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 
and AdmLink.ID Like @P_ID+'%'  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)    
)    
    


GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_HOLD_EXCESSREFUND_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[DB_I_DISBURSE_HOLD_EXCESSREFUND_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)    
RETURNS TABLE    
AS RETURN    
(    
   
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)    
)    
    


GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_HOLD_EXCESSREFUND_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[DB_I_DISBURSE_HOLD_EXCESSREFUND_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))    
RETURNS TABLE    
AS RETURN    
(    
   
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
and AdmLink.ID Like @P_ID+'%'  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)    
)    
    


GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_NOT_CLAIM_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[DB_I_DISBURSE_NOT_CLAIM_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)    
  


GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_NOT_CLAIM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[DB_I_DISBURSE_NOT_CLAIM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate 
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 
and AdmLink.ID Like @P_ID+'%'    
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)    
      


GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_NOT_EXCESSREFUND_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[DB_I_DISBURSE_NOT_EXCESSREFUND_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)    
  


GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_NOT_EXCESSREFUND_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[DB_I_DISBURSE_NOT_EXCESSREFUND_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
and AdmLink.ID Like @P_ID+'%'    
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)    
      


GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_UNPAID_CLAIM_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[DB_I_DISBURSE_UNPAID_CLAIM_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate   
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)    
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

    
)    
    


GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_UNPAID_CLAIM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[DB_I_DISBURSE_UNPAID_CLAIM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.BillDate between @P_SDate and @P_EDate  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 
and AdmLink.ID Like @P_ID+'%'  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)    
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

    
)    



GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_UNPAID_EXCESSREFUND_CLAIMANT]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[DB_I_DISBURSE_UNPAID_EXCESSREFUND_CLAIMANT](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)    
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

    
)    
    


GO

/****** Object:  UserDefinedFunction [dbo].[DB_I_DISBURSE_UNPAID_EXCESSREFUND_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[DB_I_DISBURSE_UNPAID_EXCESSREFUND_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))    
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('DI','SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM' and Upper(Admlink.Extra_3)='REFUND'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate    
and AdmLink.ID Like @P_ID+'%'  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)    
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

    
)    



GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_ALL_ALL_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO








CREATE FUNCTION [dbo].[DB_R_DISBURSE_ALL_ALL_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)  

  
  
  
  




















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_ALL_ALL_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE FUNCTION [dbo].[DB_R_DISBURSE_ALL_ALL_ID] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)  

  
  
  
  



















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_ALL_CLAIM_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO








CREATE FUNCTION [dbo].[DB_R_DISBURSE_ALL_CLAIM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='CLAIM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)  

  
  
  
  




















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_ALL_CLAIM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE FUNCTION [dbo].[DB_R_DISBURSE_ALL_CLAIM_ID] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='CLAIM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)  

  
  
  
  



















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_ALL_PREMIUM_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE FUNCTION [dbo].[DB_R_DISBURSE_ALL_PREMIUM_ALL] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='PREMIUM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)  

  
  
  
  




















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_ALL_PREMIUM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE FUNCTION [dbo].[DB_R_DISBURSE_ALL_PREMIUM_ID] (@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='PREMIUM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)  

  
  
  
  



















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_HOLD_ALL_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


















--  
  
CREATE function [dbo].[DB_R_DISBURSE_HOLD_ALL_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
 
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)  
)  
  
  



















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_HOLD_ALL_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


















--  
  
CREATE function [dbo].[DB_R_DISBURSE_HOLD_ALL_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
 
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)  
)  
  
  



















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_HOLD_CLAIM_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


















--  
  
CREATE function [dbo].[DB_R_DISBURSE_HOLD_CLAIM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
 
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.SUbject)='CLAIM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)  
)  
  
  



















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_HOLD_CLAIM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


















--  
  
CREATE function [dbo].[DB_R_DISBURSE_HOLD_CLAIM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
 
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.SUbject)='CLAIM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)  
)  
  
  



















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_HOLD_PREMIUM_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


















--  
  
CREATE function [dbo].[DB_R_DISBURSE_HOLD_PREMIUM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
 
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.SUbject)='PREMIUM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)  
)  
  
  



















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_HOLD_PREMIUM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


















--  
  
CREATE function [dbo].[DB_R_DISBURSE_HOLD_PREMIUM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
 
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.SUbject)='PREMIUM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Hold<>0 and CollectionV.Voucher=Voucher.Voucher)  
)  
  
  



















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_NOT_ALL_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[DB_R_DISBURSE_NOT_ALL_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)  

  




















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_NOT_ALL_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[DB_R_DISBURSE_NOT_ALL_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)  

  




















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_NOT_CLAIM_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[DB_R_DISBURSE_NOT_CLAIM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='CLAIM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)  

  




















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_NOT_CLAIM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[DB_R_DISBURSE_NOT_CLAIM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLInk.Subject)='CLAIM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)  

  




















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_NOT_PREMIUM_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[DB_R_DISBURSE_NOT_PREMIUM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='PREMIUM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)  

  




















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_NOT_PREMIUM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO



















CREATE function [dbo].[DB_R_DISBURSE_NOT_PREMIUM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLInk.Subject)='PREMIUM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)  

  




















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_PERIOD_DUE_ALL_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[DB_R_DISBURSE_PERIOD_DUE_ALL_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Voucher.AmountDue<>0
)  

  



















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_PERIOD_DUE_ALL_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[DB_R_DISBURSE_PERIOD_DUE_ALL_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Voucher.AmountDue<>0
and AdmLink.ID Like @P_ID+'%'  
)  

  



















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_PERIOD_DUE_CLAIM_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[DB_R_DISBURSE_PERIOD_DUE_CLAIM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Voucher.AmountDue<>0
and Upper(AdmLink.Subject)='CLAIM'
)  

  



















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_PERIOD_DUE_CLAIM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[DB_R_DISBURSE_PERIOD_DUE_CLAIM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Voucher.AmountDue<>0
and Upper(AdmLInk.Subject)='CLAIM'
and AdmLink.ID Like @P_ID+'%'  
)  

  



















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_PERIOD_DUE_PREMIUM_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[DB_R_DISBURSE_PERIOD_DUE_PREMIUM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, 
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Voucher.AmountDue<>0
and Upper(AdmLink.Subject)='PREMIUM'
)  

  



















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_PERIOD_DUE_PREMIUM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


















CREATE function [dbo].[DB_R_DISBURSE_PERIOD_DUE_PREMIUM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo,
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountPeriodDue(@P_SDate, @P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Voucher.AmountDue<>0
and Upper(AdmLInk.Subject)='PREMIUM'
and AdmLink.ID Like @P_ID+'%'  
)  

  



















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_UNPAID_ALL_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

















--  
  
CREATE function [dbo].[DB_R_DISBURSE_UNPAID_ALL_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

  
)  
  
  
  
  
  
  
  
  



















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_UNPAID_ALL_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

















--  
  
CREATE function [dbo].[DB_R_DISBURSE_UNPAID_ALL_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

  
)  
  
  
  
  
  
  









GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_UNPAID_CLAIM_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

















--  
  
CREATE function [dbo].[DB_R_DISBURSE_UNPAID_CLAIM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='CLAIM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

  
)  
  
  
  
  
  
  
  
  



















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_UNPAID_CLAIM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

















--  
  
CREATE function [dbo].[DB_R_DISBURSE_UNPAID_CLAIM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='CLAIM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

  
)  
  
  
  
  
  
  









GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_UNPAID_PREMIUM_ALL]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

















--  
  
CREATE function [dbo].[DB_R_DISBURSE_UNPAID_PREMIUM_ALL](@P_SDate as smalldatetime, @P_EDate as SmallDateTime)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='PREMIUM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

  
)  
  
  
  
  
  
  
  
  



















GO

/****** Object:  UserDefinedFunction [dbo].[DB_R_DISBURSE_UNPAID_PREMIUM_ID]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

















--  
  
CREATE function [dbo].[DB_R_DISBURSE_UNPAID_PREMIUM_ID](@P_SDate as smalldatetime, @P_EDate as SmallDateTime,@P_ID as varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Upper(AdmLink.Subject)='PREMIUM'
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and AdmLink.ID Like @P_ID+'%'
and Voucher.Voucher in (Select CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.CollNo and CollectionH.CollStatus='C' and CollectionV.Paid=0 and CollectionV.Voucher=Voucher.Voucher)  
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

  
)  
  
  
  


  
  
  



















GO

/****** Object:  UserDefinedFunction [dbo].[DB_U_F_DISBURSE]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[DB_U_F_DISBURSE](@P_PDate smalldatetime, @P_Voucher as varchar(20), @P_PolicyNo as varchar(50), @P_RefNo as varchar(50), @P_DocNo as varchar(50)) 
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_PDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) 
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.Date<=@P_PDate
and Admlink.Voucher Like @P_Voucher 
and Admlink.A_PolicyNo Like @P_PolicyNo 
and Admlink.RefNo Like @P_RefNo 
and Admlink.DocNo Like @P_DocNo
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)    
  


GO

/****** Object:  UserDefinedFunction [dbo].[DB_U_I_DISBURSE]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[DB_U_I_DISBURSE](@P_PDate smalldatetime, @P_Voucher as varchar(20), @P_PolicyNo as varchar(50), @P_RefNo as varchar(50), @P_DocNo as varchar(50)) 
RETURNS TABLE    
AS RETURN    
(    
select distinct  Admlink.RefNo as RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,     
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,    
Profile.Name+'-'+Voucher.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_PDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code)  
where  Voucher.Voucher=AdmLink.Voucher     
and ProAcc.ProAcc=Voucher.ProAcc     
and ProAcc.[ID]=[Profile].[ID]     
and Admlink.Type in ('DI','IC','SO','OP')    
and Not ((Admlink.Type in ('OP') and Admlink.Amount_8<>0) or (Admlink.Type in ('SO') and Admlink.Amount_7+Admlink.Amount_12+Admlink.Amount_15=Admlink.Amount)) -- Not Claim Salvage/Excess      
and Upper(AdmLink.Subject)='CLAIM'  
and Admlink.Voucher Like @P_Voucher 
and Admlink.A_PolicyNo Like @P_PolicyNo 
and Admlink.RefNo Like @P_RefNo 
and Admlink.DocNo Like @P_DocNo
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

) 



GO

/****** Object:  UserDefinedFunction [dbo].[DB_U_R_DISBURSE]    Script Date: 12/5/2017 10:04:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[DB_U_R_DISBURSE](@P_PDate smalldatetime, @P_Voucher as varchar(20), @P_PolicyNo as varchar(50), @P_RefNo as varchar(50), @P_DocNo as varchar(50)) 
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Admlink.Extra_3,Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Case When Reinsurance.DocNo is null Then Voucher.Remarks else Reinsurance.Description end +Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType,Voucher.Branch, AdmLink.BatchNo, TOC.TOC as Code  , Admlink.A_PolicyNo, Admlink.EXTRA_4
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_PDate) Voucher,AdmLink Inner Join TOC on (TOC.TOC=Admlink.Code) Left Join Reinsurance On (Reinsurance.DocNo=Admlink.RefNo)
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('PI','FO','QS','QP','S1','S2','S3','CP','XP','AF','DC','X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP','IR','IT','IX')  
and Admlink.Voucher Like @P_Voucher 
and Admlink.A_PolicyNo Like @P_PolicyNo 
and Admlink.RefNo Like @P_RefNo 
and Admlink.DocNo Like @P_DocNo
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)

)  


GO

insert into PatchVersioning
select '52.1 Update Script - Update Patch Collection 2018 (Desktop) (Execute Before Kom 2019 v.1.1)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='52 Script Komulatif Konsol 2019 1.0'
Select @CurrSCript='52.1 Update Script - Update Patch Collection 2018 (Desktop) (Execute Before Kom 2019 v.1.1)'


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
