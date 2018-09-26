IF EXISTS (SELECT * FROM sys.objects WHERE [name] = N'AddDesignationCodeInUserDesigLastSequenceNo' AND [type] = 'TR')
BEGIN
      DROP TRIGGER AddDesignationCodeInUserDesigLastSequenceNo
END
Go
CREATE TRIGGER AddDesignationCodeInUserDesigLastSequenceNo ON tbl_Designation
AFTER INSERT

As
	Declare @DesignationId int, @DesSequence bigint, @DesignationCode varchar(20)
	
	Select @DesignationId = i.Id, @DesignationCode = i.DesignationCode from inserted i;

	SELECT @DesSequence = LastSequenceNo FROM tblUserDesigLastSequenceNo WHERE DesignationId = @DesignationId

	-- if it is first time task is entered for designation start from 001.
	IF(@DesSequence IS NULL)
	BEGIN
		SET @DesSequence = 0  
	END

	SET @DesSequence = @DesSequence + 1 

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
					@DesignationCode,
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