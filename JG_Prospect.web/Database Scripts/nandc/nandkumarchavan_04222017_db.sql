
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Bhavik J.
-- Create date: 29 - 11- 2016
-- Description:	Get Data of Touch Point Log
-- =============================================
CREATE PROCEDURE [dbo].[Sp_GetTouchPointLogDataByUserID]
	-- Add the parameters for the stored procedure here 
	@userID int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT UserTouchPointLogID , UserID, UpdatedByUserID, UpdatedUserInstallID, ChangeDateTime, LogDescription, CurrentUserGUID 
	FROM tblUserTouchPointLog WITH (NOLOCK)
	WHERE UserID = @userID	
	
	UNION ALL

	--Task ID#: REC001-XIII
	SELECT TOP 1 UserTouchPointLogID = 99999, UserID = ID, UpdatedByUserID = ID, UpdatedUserInstallID = FristName + ' - ' + CAST(ID AS CHAR(10)), ChangeDateTime = CreatedDateTime, LogDescription = Notes, CurrentUserGUID = 0
	FROM tblInstallUsers WITH (NOLOCK)
	WHERE ID = @userID

END

GO


