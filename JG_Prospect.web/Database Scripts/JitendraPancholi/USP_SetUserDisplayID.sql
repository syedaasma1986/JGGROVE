IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'USP_SetUserDisplayID')
  BEGIN
      DROP PROCEDURE USP_SetUserDisplayID
  END
 Go
-- =============================================
-- Author:		Bhavik
-- Create date: 16 11 2016
-- Description:	Get Designation ID For a user
-- Updated By:	Jitendra Pancholi
-- Update On:	06 Dec 2017
-- =============================================
CREATE PROCEDURE [dbo].[USP_SetUserDisplayID] 
	-- Add the parameters for the stored procedure here
	@InstallUserID int = 0, 
	--@DesignationsCode varchar(15),
	@DesignationId int = 0,
	@UpdateCurrentSequence varchar (10) =''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

IF (@UpdateCurrentSequence = 'YES')
BEGIN
-- SET UserInstallId as NULL. so following process will generae a new ID for respective user.

	UPDATE tblInstallUsers SET UserInstallId = null	WHERE Id = @InstallUserID
END


DECLARE @InstallId VARCHAR(50) = NULL, @DesignationsCode varchar(15) = ''
	Select @DesignationsCode = DesignationsCode From tblUserDesigLastSequenceNo Where DesignationId = @DesignationId
	SELECT @InstallId = UserInstallId FROM tblInstallUsers WHERE Id = @InstallUserID 
	
IF @InstallId IS NULL
BEGIN
	-- get sequence of last entered task for perticular designation.
	DECLARE @DesSequence bigint

	SELECT @DesSequence = LastSequenceNo FROM tblUserDesigLastSequenceNo WHERE DesignationCode = @DesignationsCode

	-- if it is first time task is entered for designation start from 001.
	IF(@DesSequence IS NULL)
	BEGIN
		SET @DesSequence = 0  
	END

	SET @DesSequence = @DesSequence + 1  
	

	UPDATE tblInstallUsers
		SET UserInstallId = @DesignationsCode + '-A'+ Right('000' + CONVERT(NVARCHAR, @DesSequence), 4)
	WHERE Id = @InstallUserID
	

	-- INCREMENT SEQUENCE NUMBER FOR DESIGNATION TO USE NEXT TIME
	IF NOT EXISTS( 
					SELECT uds.UserDesigSequenceId 
					FROM dbo.tblUserDesigLastSequenceNo uds 
					WHERE uds.DesignationId = @DesignationId 
				 )
	BEGIN

	INSERT INTO dbo.tblUserDesigLastSequenceNo
		(    
			DesignationCode,
			LastSequenceNo,
			DesignationId
		)
		VALUES
		(
			@DesignationsCode,
			@DesSequence,
			@DesignationId
		) 
	END
	ELSE		
	BEGIN
		UPDATE dbo.tblUserDesigLastSequenceNo
		SET
			dbo.tblUserDesigLastSequenceNo.LastSequenceNo = @DesSequence
		WHERE dbo.tblUserDesigLastSequenceNo.DesignationId = @DesignationId 
	END

	END
END


 



GO

