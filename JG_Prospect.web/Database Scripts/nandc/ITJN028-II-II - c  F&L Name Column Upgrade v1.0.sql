
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF OBJECT_ID(N'[DBO].[UDP_ChangeDesignition]') IS NOT NULL
 DROP PROC [dbo].[UDP_ChangeDesignition]
GO

-- =============================================================================  
-- Author:  Nand Chavan
-- Create date: May 05/2017  
-- Description: Updates DesignationID when Designation drop-down changed.
--              Called from edit users grid on EditUser.aspx 
-- ============================================================================= 
CREATE PROCEDURE [dbo].[UDP_ChangeDesignition]   
(  
	 @Id int = 0,  
	 @DesignationID INT = 0   
)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Updates user DesignationID   
 UPDATE 
	[dbo].[tblInstallUsers]  
 SET   
     DesignationID = @DesignationID
 WHERE 
	Id = @Id  
  
  
END  

GO




