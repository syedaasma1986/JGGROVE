USE [JGBS_Dev_New]
GO

ALTER PROCEDURE [dbo].[SP_SaveOrDeleteTask]  
	 @Mode tinyint, -- 0:Insert, 1: Update, 2: Delete  
	 @TaskId bigint,  
	 @Title varchar(250),  
	 @Url varchar(250),
	 @Description varchar(MAX),  
	 @Status tinyint,  
	 @DueDate datetime = NULL,  
	 @Hours varchar(25),
	 @CreatedBy int,	
	 @InstallId varchar(50) = NULL,
	 @ParentTaskId bigint = NULL,
	 @TaskType tinyint = NULL,
	 @TaskLevel int,	
	 @TaskPriority tinyint = null,
	 @IsTechTask bit = NULL,
	 @DeletedStatus	TINYINT = 9,
	 @Result int output
AS  
BEGIN  
  
	IF @Mode=0  
	  BEGIN  
		INSERT INTO tblTask 
				(
					Title,
					Url,
					[Description],
					[Status],
					DueDate,
					[Hours],
					CreatedBy,
					CreatedOn,
					IsDeleted,
					InstallId,
					ParentTaskId,
					TaskType,
					TaskPriority,
					IsTechTask,
					AdminStatus,
					TechLeadStatus,
					OtherUserStatus,
					TaskLevel
				)
		VALUES
				(
					@Title,
					@Url,
					@Description,
					@Status,
					@DueDate,
					@Hours,
					@CreatedBy,
					GETDATE(),
					0,
					@InstallId,
					@ParentTaskId,
					@TaskType,
					@TaskPriority,
					@IsTechTask,
					0,
					0,
					0,
					@TaskLevel
				)  
  
		SET @Result=SCOPE_IDENTITY ()  
  
		RETURN @Result  
	END  
	ELSE IF @Mode=1 -- Update  
	BEGIN    
		UPDATE tblTask  
		SET  
			Title=@Title,  
			Url = @Url,
			[Description]=@Description,  
			[Status]=@Status,  
			DueDate=@DueDate,  
			[Hours]=@Hours,
			[TaskType] = @TaskType,
			[TaskPriority] = @TaskPriority,
			[IsTechTask] = @IsTechTask
		WHERE TaskId=@TaskId  

		SET @Result= @TaskId
  
		RETURN @Result  
	END  
	ELSE IF @Mode=2 --Delete  
	BEGIN  
		UPDATE tblTask  
		SET  
			IsDeleted=1,
			[Status] = @DeletedStatus
		WHERE TaskId=@TaskId OR ParentTaskId=@TaskId  
	END  
  
END

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UpdateTaskTitleById]
	@TaskId bigint,
	@Title varchar(300)
AS
BEGIN

	SET NOCOUNT ON;

	UPDATE [dbo].[tblTask]
	SET 
		[Title] = @Title
		
	WHERE TaskId = @TaskId

END



go
CREATE PROCEDURE [dbo].[UpdateTaskURLById]
	@TaskId bigint,
	@URL varchar(250)
AS
BEGIN

	SET NOCOUNT ON;

	UPDATE [dbo].[tblTask]
	SET 
		[Url] = @URL
		
	WHERE TaskId = @TaskId

END


go
CREATE PROCEDURE [dbo].[UpdateTaskDescriptionById]
	@TaskId bigint,
	@Description varchar(max)
AS
BEGIN

	SET NOCOUNT ON;

	UPDATE [dbo].[tblTask]
	SET 
		[Description] = @Description
		
	WHERE TaskId = @TaskId

END

GO

CREATE PROCEDURE [dbo].[usp_GetTaskByaxId] 
	@parentTaskId bigint,
	@taskLVL smallint
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		*
	FROM
		tbltask 
	WHERE
		parenttaskid = @parentTaskId
		AND Taskid = (select max(taskid) from tbltask where parenttaskid = @parentTaskId and tasklevel=@taskLVL) 
	order by taskid
END

