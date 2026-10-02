/****** Object:  StoredProcedure [dbo].[QProfile_Data]    Script Date: 3/30/2022 6:30:40 PM ******/
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QProfile_Data') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE [dbo].[QProfile_Data]
END
GO

/****** Object:  StoredProcedure [dbo].[QProfile_Data]    Script Date: 3/30/2022 6:30:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[QProfile_Data](@P_ID varchar(10))    
AS     
Select P1.*, P2.*
from Profile P1 Left Join Profile_Ext P2 on (P2.ID=P1.ID)    
Where P1.ID=@P_ID    

GO


