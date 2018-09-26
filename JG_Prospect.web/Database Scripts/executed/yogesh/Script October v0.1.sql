IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_HardDeleteTask]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
    BEGIN
 
    DROP PROCEDURE usp_HardDeleteTask   

    END  
GO    


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 10182017
-- Description:	This will hard delete any task and its related information
-- =============================================
CREATE PROCEDURE usp_HardDeleteTask 
(	
	@TaskId bigint,
	@TaskAttachments  VARCHAR(MAX) = ''	OUTPUT,
	@AllDeleted BIT = 0 OUTPUT
)
AS
BEGIN

BEGIN TRANSACTION;
SAVE TRANSACTION TaskHardDelete;

	BEGIN TRY

		SELECT @TaskAttachments = @TaskAttachments + Attachment + ',' FROM [dbo].[tblTaskUserFiles] WHERE TaskId = @TaskId

		DELETE FROM [dbo].[tblTaskAssignedUsers] WHERE TaskID = @TaskId
		DELETE FROM [dbo].[tblTaskWorkSpecifications] WHERE TaskID = @TaskId
		DELETE FROM [dbo].[tblTaskAcceptance] WHERE TaskID = @TaskId
		DELETE FROM [dbo].[tblTaskAssignmentRequests] WHERE TaskID = @TaskId
		DELETE FROM [dbo].[tblTaskComments] WHERE TaskID = @TaskId
		DELETE FROM [dbo].[tblTaskApprovals] WHERE TaskID = @TaskId
		DELETE FROM [dbo].[tblTaskDesignations] WHERE TaskID = @TaskId
		DELETE FROM [dbo].[tblTaskUserFiles] WHERE TaskID = @TaskId
		DELETE FROM [dbo].[tblTaskUser] WHERE TaskId = @TaskId
		DELETE FROM [dbo].[tblTask] WHERE TaskID = @TaskId

	END TRY
	BEGIN CATCH
			IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION TaskHardDelete; -- rollback to TaskHardDelete
			END
	END CATCH

COMMIT TRANSACTION 

SELECT @AllDeleted = 1

RETURN

END

GO
