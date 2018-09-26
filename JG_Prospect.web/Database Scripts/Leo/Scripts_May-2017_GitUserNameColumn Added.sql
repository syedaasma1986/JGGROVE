IF NOT EXISTS (SELECT
		*
	FROM sys.columns
	WHERE object_id = OBJECT_ID(N'dbo.tblInstallUsers')
	AND name = 'GitUserName')
BEGIN
ALTER TABLE [dbo].[tblInstallUsers]
ADD GitUserName VARCHAR(50) NULL;
END
--===================================

IF EXISTS (SELECT
		*
	FROM sysobjects
	WHERE id = OBJECT_ID(N'[dbo].[UDP_ChangeStatus]')
	AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
BEGIN
DROP PROCEDURE [dbo].[UDP_ChangeStatus]
END
GO
-- =============================================  

-- Author:  Yogesh  

-- Create date: 22 Sep 2016  

-- Description: Updates status and status related fields for install user.  

--    Inserts event and event users for interview status.  

--    Deletes any exising events and event users for non interview status.  

--    Gets install users details.  

-- =============================================  

CREATE PROCEDURE [dbo].[UDP_ChangeStatus]   

(  

 @Id int = 0,  

 @Status varchar(20) = '',  

 @RejectionDate DATE = NULL,  

 @RejectionTime VARCHAR(20) = NULL,  

 @RejectedUserId int = 0,  

 @StatusReason varchar(max) = '',  

 @UserIds varchar(4000) = NULL,  

 @IsInstallUser bit = 0,  

 @InterviewDateStatus VARChAR(5) = '5'  

)  

AS  

BEGIN

-- SET NOCOUNT ON added to prevent extra result sets from  

-- interfering with SELECT statements.  

SET NOCOUNT ON;



-- Updates user status and status related information.  

UPDATE [dbo].[tblInstallUsers]

SET	Status = @Status

	,RejectionDate = @RejectionDate

	,RejectionTime = @RejectionTime

	,InterviewTime = @RejectionTime

	,RejectedUserId = @RejectedUserId

	,StatusReason = @StatusReason

WHERE Id = @Id



-- Add event and event users for Interview status.  

IF @Status = @InterviewDateStatus

BEGIN

INSERT INTO tbl_AnnualEvents (EventName, EventDate, EventAddedBy, ApplicantId, IsInstallUser)

	VALUES ('InterViewDetails', @RejectionDate, @RejectedUserId, @Id, @IsInstallUser)



IF @UserIds IS NOT NULL

BEGIN

DECLARE @EventID INT

SELECT
	@EventID = SCOPE_IDENTITY()



INSERT INTO tbl_AnnualEventAssignedUsers ([EventId], [UserId])

		SELECT
			@EventID
			,CAST(ss.Item AS INT)

		FROM dbo.SplitString(@UserIds, ',') ss

		WHERE NOT EXISTS (SELECT
				CAST(ttau.UserId AS VARCHAR)

			FROM dbo.tbl_AnnualEventAssignedUsers ttau

			WHERE ttau.UserId = CAST(ss.Item AS BIGINT)
			AND ttau.EventId = @EventID)

END

END

-- Delete any event and event users for given install user as   

-- events are required for interview status only.  

ELSE

BEGIN

DELETE FROM tbl_AnnualEventAssignedUsers

WHERE EventId IN (SELECT
			Id

		FROM tbl_AnnualEvents

		WHERE ApplicantId = @Id)



DELETE FROM tbl_AnnualEvents

WHERE ApplicantId = @Id

END



-- Gets user details required to further process user whoes status is changed.  

SELECT
	Email
	,HireDate
	,EmpType
	,PayRates
	,Designation
	,FristName
	,LastName
	,[Address]
	,[GitUserName]
FROM tblInstallUsers
WHERE Id = @Id
END
GO