/****** Object:  StoredProcedure [dbo].[usp_GetTaskDetails]    Script Date: 30-Nov-16 10:37:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 04/07/2016
-- Description:	Load all details of task for edit.
-- =============================================
-- usp_GetTaskDetails 170
ALTER PROCEDURE [dbo].[usp_GetTaskDetails] 
(
	@TaskId int 
)	  
AS
BEGIN
	
	SET NOCOUNT ON;

	-- task manager detail
	DECLARE @AssigningUser varchar(50) = NULL

	SELECT @AssigningUser = Users.[Username] 
	FROM 
		tblTask AS Task 
		INNER JOIN [dbo].[tblUsers] AS Users  ON Task.[CreatedBy] = Users.Id
	WHERE TaskId = @TaskId

	IF(@AssigningUser IS NULL)
	BEGIN
		SELECT @AssigningUser = Users.FristName + ' ' + Users.LastName 
		FROM 
			tblTask AS Task 
			INNER JOIN [dbo].[tblInstallUsers] AS Users  ON Task.[CreatedBy] = Users.Id
		WHERE TaskId = @TaskId
	END

	-- task's main details
	SELECT Title, [Description], [Status], DueDate,Tasks.[Hours], Tasks.CreatedOn, Tasks.TaskPriority,
		   Tasks.InstallId, Tasks.CreatedBy, @AssigningUser AS AssigningManager ,Tasks.TaskType, Tasks.IsTechTask,
		   STUFF
			(
				(SELECT  CAST(', ' + ttuf.[Attachment] + '@' + ttuf.[AttachmentOriginal] as VARCHAR(max)) AS attachment
				FROM dbo.tblTaskUserFiles ttuf
				WHERE ttuf.TaskId = Tasks.TaskId
				FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
				,1
				,2
				,' '
			) AS attachment
	FROM tblTask AS Tasks
	WHERE Tasks.TaskId = @TaskId

	-- task's designation details
	SELECT Designation
	FROM tblTaskDesignations
	WHERE (TaskId = @TaskId)

	-- task's assigned users
	SELECT UserId, TaskId
	FROM tblTaskAssignedUsers
	WHERE (TaskId = @TaskId)

	-- task's notes and attachment information.
	--SELECT	TaskUsers.Id,TaskUsers.UserId, TaskUsers.UserType, TaskUsers.Notes, TaskUsers.UserAcceptance, TaskUsers.UpdatedOn, 
	--	    TaskUsers.[Status], TaskUsers.TaskId, tblInstallUsers.FristName,TaskUsers.UserFirstName, tblInstallUsers.Designation,
	--		(SELECT COUNT(ttuf.[Id]) FROM dbo.tblTaskUserFiles ttuf WHERE ttuf.[TaskUpdateID] = TaskUsers.Id) AS AttachmentCount,
	--		dbo.UDF_GetTaskUpdateAttachments(TaskUsers.Id) AS attachments
	--FROM    
	--	tblTaskUser AS TaskUsers 
	--	LEFT OUTER JOIN tblInstallUsers ON TaskUsers.UserId = tblInstallUsers.Id
	--WHERE (TaskUsers.TaskId = @TaskId) 
	
	-- Description:	Get All Notes along with Attachments.
	-- Modify by :: Aavadesh Patel :: 10.08.2016 23:28

;WITH TaskHistory
AS 
(
	SELECT	
		TaskUsers.Id,
		TaskUsers.UserId, 
		TaskUsers.UserType, 
		TaskUsers.Notes, 
		TaskUsers.UserAcceptance, 
		TaskUsers.UpdatedOn, 
		TaskUsers.[Status], 
		TaskUsers.TaskId, 
		tblInstallUsers.FristName,
		tblInstallUsers.LastName,
		TaskUsers.UserFirstName, 
		tblInstallUsers.Designation,
		tblInstallUsers.Picture,
		tblInstallUsers.UserInstallId,
		(SELECT COUNT(ttuf.[Id]) FROM dbo.tblTaskUserFiles ttuf WHERE ttuf.[TaskUpdateID] = TaskUsers.Id) AS AttachmentCount,
		dbo.UDF_GetTaskUpdateAttachments(TaskUsers.Id) AS attachments,
		'' as AttachmentOriginal , 0 as TaskUserFilesID,
		'' as Attachment , '' as FileType
	FROM    
		tblTaskUser AS TaskUsers 
		LEFT OUTER JOIN tblInstallUsers ON TaskUsers.UserId = tblInstallUsers.Id
	WHERE (TaskUsers.TaskId = @TaskId) AND (TaskUsers.Notes <> '' OR TaskUsers.Notes IS NOT NULL) 
	
	
	Union All 
		
	SELECT	
		tblTaskUserFiles.Id , 
		tblTaskUserFiles.UserId , 
		'' as UserType , 
		'' as Notes , 
		'' as UserAcceptance , 
		tblTaskUserFiles.AttachedFileDate AS UpdatedOn,
		'' as [Status] , 
		tblTaskUserFiles.TaskId , 
		tblInstallUsers.FristName  ,
		tblInstallUsers.LastName,
		tblInstallUsers.FristName as UserFirstName , 
		'' as Designation , 
		tblInstallUsers.Picture,
		tblInstallUsers.UserInstallId,
		'' as AttachmentCount , 
		'' as attachments,
		 tblTaskUserFiles.AttachmentOriginal,
		 tblTaskUserFiles.Id as  TaskUserFilesID,
		 tblTaskUserFiles.Attachment, 
		 tblTaskUserFiles.FileType
	FROM   tblTaskUserFiles   
	LEFT OUTER JOIN tblInstallUsers ON tblInstallUsers.Id = tblTaskUserFiles.UserId
	WHERE (tblTaskUserFiles.TaskId = @TaskId) AND (tblTaskUserFiles.Attachment <> '' OR tblTaskUserFiles.Attachment IS NOT NULL)
)

SELECT * from TaskHistory ORDER BY  UpdatedOn DESC
	
	-- sub tasks
	SELECT Tasks.TaskId, Title, [Description], Tasks.[Status], DueDate,Tasks.[Hours], Tasks.CreatedOn, Tasks.TaskPriority,
		   Tasks.InstallId, Tasks.CreatedBy, @AssigningUser AS AssigningManager , UsersMaster.FristName,
		   Tasks.TaskType,Tasks.TaskPriority, Tasks.IsTechTask,
		   STUFF
			(
				(SELECT  CAST(', ' + ttuf.[Attachment] + '@' + ttuf.[AttachmentOriginal] as VARCHAR(max)) AS attachment
				FROM dbo.tblTaskUserFiles ttuf
				WHERE ttuf.TaskId = Tasks.TaskId
				FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
				,1
				,2
				,' '
			) AS attachment
	FROM 
		tblTask AS Tasks LEFT OUTER JOIN
        tblTaskAssignedUsers AS TaskUsers ON Tasks.TaskId = TaskUsers.TaskId LEFT OUTER JOIN
        tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id --LEFT OUTER JOIN
		--tblTaskDesignations AS TaskDesignation ON Tasks.TaskId = TaskDesignation.TaskId
	WHERE Tasks.ParentTaskId = @TaskId
    
	-- main task attachments
	SELECT 
		CAST(
				--tuf.[Attachment] + '@' + tuf.[AttachmentOriginal] 
				ISNULL(tuf.[Attachment],'') + '@' + ISNULL(tuf.[AttachmentOriginal],'') 
				AS VARCHAR(MAX)
			) AS attachment,
		ISNULL(u.FirstName,iu.FristName) AS FirstName
	FROM dbo.tblTaskUserFiles tuf
			LEFT JOIN tblUsers u ON tuf.UserId = u.Id --AND tuf.UserType = u.Usertype
			LEFT JOIN tblInstallUsers iu ON tuf.UserId = iu.Id --AND tuf.UserType = u.UserType
	WHERE tuf.TaskId = @TaskId

END
GO


/****** Object:  StoredProcedure [dbo].[UpdateTaskWorkSpecificationStatusByTaskId]    Script Date: 04-Nov-16 11:43:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 13 Sep 16
-- Description:	Updates status of Task specifications including childs by Id.
-- =============================================

ALTER PROCEDURE [dbo].[UpdateTaskWorkSpecificationStatusById]
	@Id		BIGINT,
	@AdminStatus BIT = NULL,
	@TechLeadStatus BIT = NULL,
	@OtherUserStatus BIT = NULL,
	@UserId int,
	@IsInstallUser bit
AS
BEGIN
	
	DECLARE	@tblTemp	TABLE(Id BIGINT)

	-- gets current as well as all child specifications.
	;WITH TWS AS
	(
		SELECT s.*
		FROM tblTaskWorkSpecifications s
		WHERE Id = @Id

		UNION ALL

		SELECT s.*
		FROM tblTaskWorkSpecifications s 
			INNER JOIN TWS t ON s.ParentTaskWorkSpecificationId = t.Id
	)

	INSERT INTO @tblTemp
	SELECT ID FROM TWS

	IF @AdminStatus IS NOT NULL
	BEGIN
		UPDATE tblTaskWorkSpecifications
		SET
			AdminStatus = @AdminStatus,
			AdminUserId= @UserId,
			IsAdminInstallUser = @IsInstallUser,
			AdminStatusUpdated = GETDATE(),
			DateUpdated = GETDATE()
		WHERE Id IN (SELECT ID FROM @tblTemp)
	END
	ELSE IF @TechLeadStatus IS NOT NULL
	BEGIN
		UPDATE tblTaskWorkSpecifications
		SET
			TechLeadStatus = @TechLeadStatus,
			TechLeadUserId= @UserId,
			IsTechLeadInstallUser = @IsInstallUser,
			TechLeadStatusUpdated = GETDATE(),
			DateUpdated = GETDATE()
		WHERE Id IN (SELECT ID FROM @tblTemp)
	END
	ELSE IF @OtherUserStatus IS NOT NULL
	BEGIN
		UPDATE tblTaskWorkSpecifications
		SET
			OtherUserStatus = @OtherUserStatus,
			OtherUserId= @UserId,
			IsOtherUserInstallUser = @IsInstallUser,
			OtherUserStatusUpdated = GETDATE(),
			DateUpdated = GETDATE()
		WHERE Id IN (SELECT ID FROM @tblTemp)
	END

END
GO

--=================================================================================================================================================================================================

-- Published on live 12012016 

--=================================================================================================================================================================================================


-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 04/07/2016
-- Description:	Load all sub tasks of a task.
-- =============================================
-- usp_GetSubTasks 10015
ALTER PROCEDURE [dbo].[usp_GetSubTasks] 
(
	@TaskId int,
	@Admin bit
)	  
AS
BEGIN
	
	SET NOCOUNT ON;

	-- task manager detail
	DECLARE @AssigningUser varchar(50) = NULL

	SELECT @AssigningUser = Users.[Username] 
	FROM 
		tblTask AS Task 
		INNER JOIN [dbo].[tblUsers] AS Users  ON Task.[CreatedBy] = Users.Id
	WHERE TaskId = @TaskId

	IF(@AssigningUser IS NULL)
	BEGIN
		SELECT @AssigningUser = Users.FristName + ' ' + Users.LastName 
		FROM 
			tblTask AS Task 
			INNER JOIN [dbo].[tblInstallUsers] AS Users  ON Task.[CreatedBy] = Users.Id
		WHERE TaskId = @TaskId
	END

	-- sub tasks
	SELECT 
			Tasks.*,
			--Tasks.TaskId, Title, [Description], Tasks.[Status], DueDate,Tasks.[Hours], Tasks.CreatedOn,
			--Tasks.InstallId, Tasks.CreatedBy, Tasks.TaskType,Tasks.TaskPriority,
			@AssigningUser AS AssigningManager,
			UsersMaster.FristName, 
			STUFF
			(
				(SELECT  CAST(', ' + ttuf.[Attachment] + '@' + ttuf.[AttachmentOriginal] as VARCHAR(max)) AS attachment
				FROM dbo.tblTaskUserFiles ttuf
				WHERE ttuf.TaskId = Tasks.TaskId
				FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
				,1
				,2
				,' '
			) AS attachment
	FROM 
		tblTask AS Tasks LEFT OUTER JOIN
        tblTaskAssignedUsers AS TaskUsers ON Tasks.TaskId = TaskUsers.TaskId LEFT OUTER JOIN
        tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id --LEFT OUTER JOIN
		--tblTaskDesignations AS TaskDesignation ON Tasks.TaskId = TaskDesignation.TaskId
	WHERE 
			Tasks.ParentTaskId = @TaskId 
			--AND
			--1 = CASE
			--		-- load records with all status for admin users.
			--		WHEN @Admin = 1 THEN
			--			1
			--		-- load only approved records for non-admin users.
			--		ELSE
			--			CASE
			--				WHEN Tasks.[AdminStatus] = 1 AND Tasks.[TechLeadStatus] = 1 THEN 1
			--				ELSE 0
			--			END
			--	END
    
END
GO

/****** Object:  StoredProcedure [dbo].[uspSearchTasks]    Script Date: 02-Dec-16 8:44:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 8/25/16
-- Description:	This procedure is used to search tasks by different parameters.
-- =============================================
ALTER PROCEDURE [dbo].[uspSearchTasks]
	@Designations	VARCHAR(4000) = '0',
	@UserId			INT = NULL,
	@Status			TINYINT = NULL,
	@CreatedFrom	DATETIME = NULL,
	@CreatedTo		DATETIME = NULL,
	@SearchTerm		VARCHAR(250) = NULL,
	@SortExpression	VARCHAR(250) = 'CreatedOn DESC',
	@ExcludeStatus	TINYINT = NULL,
	@Admin			BIT,
	@PageIndex		INT = 0,
	@PageSize		INT = 10,
	@OpenStatus		TINYINT = 1,
    @RequestedStatus	TINYINT = 2,
    @AssignedStatus	TINYINT = 3,
    @InProgressStatus	TINYINT = 4,
    @PendingStatus	TINYINT = 5,
    @ReOpenedStatus	TINYINT = 6,
    @ClosedStatus	TINYINT = 7,
    @SpecsInProgressStatus	TINYINT = 8,
    @DeletedStatus	TINYINT = 9
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @PageIndex = @PageIndex + 1

	;WITH 
	
	Tasklist AS
	(	
	
		SELECT 
			--TaskUserMatch.IsMatch AS TaskUserMatch,
			--TaskUserRequestsMatch.IsMatch AS TaskUserRequestsMatch,
			--TaskDesignationMatch.IsMatch AS TaskDesignationMatch,
			Tasks.*
		FROM
			(
				SELECT 
					Tasks.*,
					1 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY [Status],
							CASE WHEN @SortExpression = 'UserID DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] IN (@AssignedStatus,@RequestedStatus)
					
				UNION

				SELECT 
					Tasks.*,
					2 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY [Status], [TaskPriority],
							CASE WHEN @SortExpression = 'UserID DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] IN (@OpenStatus) AND ISNULL([TaskPriority],'') <> ''

				UNION

				SELECT 
					Tasks.*,
					3 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY [Status], [TaskPriority],
							CASE WHEN @SortExpression = 'UserID DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] IN (@OpenStatus)

				UNION

				SELECT 
					Tasks.*,
					4 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY
							CASE WHEN @SortExpression = 'UserID DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] = @ClosedStatus

				UNION

				SELECT 
					Tasks.*,
					5 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY
							CASE WHEN @SortExpression = 'UserID DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] = @DeletedStatus
			) Tasks    
			OUTER APPLY
			(
				SELECT TOP 1 
						1 AS IsMatch,
						TaskUsers.UserId AS UserId,
						UsersMaster.FristName AS FristName
				FROM tblTaskAssignedUsers TaskUsers
						LEFT JOIN tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id
				WHERE 
					TaskUsers.TaskId = Tasks.TaskId AND
					TaskUsers.[UserId] = ISNULL(@UserId, TaskUsers.[UserId]) AND
					1 = CASE
							WHEN @UserId IS NOT NULL THEN 1 -- set true, when user id is provided. so that join will handle record filtering and search term will have no effect on user.
							WHEN @SearchTerm IS NULL THEN 1 -- set true, when search term is null. so that join will handle record filtering and search term will have no effect on user.
							WHEN UsersMaster.FristName LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if users with given search terms are available. 
							ELSE 0
						END
			) As TaskUserMatch
			OUTER APPLY
			(
				SELECT TOP 1 
						1 AS IsMatch,
						TaskUsers.UserId AS UserId,
						UsersMaster.FristName AS FristName
				FROM tblTaskAssignmentRequests TaskUsers
						LEFT JOIN tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id
				WHERE 
					TaskUsers.TaskId = Tasks.TaskId AND
					TaskUsers.[UserId] = ISNULL(@UserId, TaskUsers.[UserId]) AND
					1 = CASE
							WHEN @UserId IS NOT NULL THEN 1 -- set true, when user id is provided. so that join will handle record filtering and search term will have no effect on user.
							WHEN @SearchTerm IS NULL THEN 1 -- set true, when search term is null. so that join will handle record filtering and search term will have no effect on user.
							WHEN UsersMaster.FristName LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if users with given search terms are available. 
							ELSE 0
						END
			) As TaskUserRequestsMatch
			OUTER APPLY
			(
				SELECT TOP 1 
						CASE
						WHEN @SearchTerm IS NULL THEN
							CASE
								WHEN @Designations = '0' THEN 1
								WHEN EXISTS (SELECT ss.Item  FROM dbo.SplitString(@Designations,',') ss WHERE ss.Item = TaskDesignations.Designation) THEN 1
								ELSE 0 
							END
						ELSE 
							CASE
								WHEN @Designations = '0' AND TaskDesignations.Designation LIKE '%' + @SearchTerm + '%' THEN 1
								WHEN (Tasks.[InstallId] LIKE '%' + @SearchTerm + '%'  OR Tasks.[Title] LIKE '%' + @SearchTerm + '%') THEN 1
								ELSE 0
							END
						END AS IsMatch,
						TaskDesignations.Designation AS Designation
				FROM tblTaskDesignations AS TaskDesignations
				WHERE 
					TaskDesignations.TaskId = Tasks.TaskId AND
					1 = CASE
							WHEN @Designations = '0' AND @SearchTerm IS NULL THEN 1 -- set true, when '0' (all designations) is provided with no search term.
							WHEN @Designations = '0' AND @SearchTerm IS NOT NULL AND TaskDesignations.Designation LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if designations found by search term.
							WHEN EXISTS (SELECT ss.Item  FROM dbo.SplitString(@Designations,',') ss WHERE ss.Item = TaskDesignations.Designation) THEN 1 -- filter based on provided designations.
							ELSE 0
						END
			)  AS TaskDesignationMatch
		WHERE
			Tasks.ParentTaskId IS NULL 
			AND
			1 = CASE
					WHEN @Admin = 1 THEN 1
					ELSE
						CASE
							WHEN Tasks.[Status] = @ExcludeStatus THEN 0
							ELSE 1
					END
				END
			AND 
			1 = CASE 
					-- filter records only by user, when search term is not provided.
					WHEN @SearchTerm IS NULL THEN
						CASE
							WHEN TaskUserMatch.IsMatch = 1 OR TaskDesignationMatch.IsMatch = 1 THEN 1
							WHEN TaskUserRequestsMatch.IsMatch = 1 OR TaskDesignationMatch.IsMatch = 1 THEN 1
							ELSE 0
						END
					-- filter records by installid, title, users when search term is provided.
					ELSE
						CASE
							WHEN Tasks.[InstallId] LIKE '%' + @SearchTerm + '%' THEN 1
							WHEN Tasks.[Title] LIKE '%' + @SearchTerm + '%' THEN 1
							WHEN TaskUserMatch.IsMatch = 1 THEN 1
							WHEN TaskUserRequestsMatch.IsMatch = 1 THEN 1
							ELSE 0
						END
				END
			AND
			Tasks.[Status] = ISNULL(@Status,Tasks.[Status]) 
			AND
			CONVERT(VARCHAR,Tasks.[CreatedOn],101)  >= ISNULL(@CreatedFrom,CONVERT(VARCHAR,Tasks.[CreatedOn],101)) AND
			CONVERT(VARCHAR,Tasks.[CreatedOn],101)  <= ISNULL(@CreatedTo,CONVERT(VARCHAR,Tasks.[CreatedOn],101))
	),

	FinalData AS
	( 
		SELECT * ,
			Row_number() OVER(ORDER BY SortOrder ASC) AS RowNo
		FROM Tasklist 
	)
	
	-- get records
	SELECT * 
	FROM FinalData 
	WHERE  
		RowNo BETWEEN (@PageIndex - 1) * @PageSize + 1 AND 
		@PageIndex * @PageSize

	-- get record count
	SELECT 
		COUNT(DISTINCT Tasks.TaskId) AS VirtualCount
	FROM          
		tblTask AS Tasks 
		OUTER APPLY
		(
			SELECT TOP 1 
					1 AS IsMatch,
					TaskUsers.UserId AS UserId,
					UsersMaster.FristName AS FristName
			FROM tblTaskAssignedUsers TaskUsers
					LEFT JOIN tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id
			WHERE 
				TaskUsers.TaskId = Tasks.TaskId AND
				TaskUsers.[UserId] = ISNULL(@UserId, TaskUsers.[UserId]) AND
				1 = CASE
						WHEN @UserId IS NOT NULL THEN 1 -- set true, when user id is provided. so that join will handle record filtering and search term will have no effect on user.
						WHEN @SearchTerm IS NULL THEN 1 -- set true, when search term is null. so that join will handle record filtering and search term will have no effect on user.
						WHEN UsersMaster.FristName LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if users with given search terms are available. 
						ELSE 0
					END
		) As TaskUserMatch
		OUTER APPLY
		(
			SELECT TOP 1 
					1 AS IsMatch,
					TaskUsers.UserId AS UserId,
					UsersMaster.FristName AS FristName
			FROM tblTaskAssignmentRequests TaskUsers
					LEFT JOIN tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id
			WHERE 
				TaskUsers.TaskId = Tasks.TaskId AND
				TaskUsers.[UserId] = ISNULL(@UserId, TaskUsers.[UserId]) AND
				1 = CASE
						WHEN @UserId IS NOT NULL THEN 1 -- set true, when user id is provided. so that join will handle record filtering and search term will have no effect on user.
						WHEN @SearchTerm IS NULL THEN 1 -- set true, when search term is null. so that join will handle record filtering and search term will have no effect on user.
						WHEN UsersMaster.FristName LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if users with given search terms are available. 
						ELSE 0
					END
		) As TaskUserRequestsMatch
		OUTER APPLY
		(
			SELECT TOP 1 
					1 AS IsMatch,
					TaskDesignations.Designation AS Designation
			FROM tblTaskDesignations AS TaskDesignations
			WHERE 
				TaskDesignations.TaskId = Tasks.TaskId AND
				1 = CASE
						WHEN @Designations = '0' AND @SearchTerm IS NULL THEN 1 -- set true, when '0' (all designations) is provided with no search term.
						WHEN @Designations = '0' AND @SearchTerm IS NOT NULL AND TaskDesignations.Designation LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if designations found by search term.
						WHEN EXISTS (SELECT ss.Item  FROM dbo.SplitString(@Designations,',') ss WHERE ss.Item = TaskDesignations.Designation) THEN 1 -- filter based on provided designations.
						ELSE 0
					END
		)  AS TaskDesignationMatch
	WHERE
		Tasks.ParentTaskId IS NULL 
		AND 
		1 = CASE 
				-- filter records only by user, when search term is not provided.
				WHEN @SearchTerm IS NULL THEN
					CASE
						WHEN TaskUserMatch.IsMatch = 1 OR TaskDesignationMatch.IsMatch = 1 THEN 1
						WHEN TaskUserRequestsMatch.IsMatch = 1 OR TaskDesignationMatch.IsMatch = 1THEN 1
						ELSE 0
					END
				-- filter records by installid, title, users when search term is provided.
				ELSE
					CASE
						WHEN Tasks.[InstallId] LIKE '%' + @SearchTerm + '%' THEN 1
						WHEN Tasks.[Title] LIKE '%' + @SearchTerm + '%' THEN 1
						WHEN TaskUserMatch.IsMatch = 1 THEN 1
						WHEN TaskUserRequestsMatch.IsMatch = 1 THEN 1
						ELSE 0
					END
			END
		AND
		Tasks.[Status] = ISNULL(@Status,Tasks.[Status]) 
		AND
		CONVERT(VARCHAR,Tasks.[CreatedOn],101)  >= ISNULL(@CreatedFrom,CONVERT(VARCHAR,Tasks.[CreatedOn],101)) AND
		CONVERT(VARCHAR,Tasks.[CreatedOn],101)  <= ISNULL(@CreatedTo,CONVERT(VARCHAR,Tasks.[CreatedOn],101))

END
GO


-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 04/07/2016
-- Description:	Load all sub tasks of a task.
-- =============================================
-- usp_GetSubTasks 10015
ALTER PROCEDURE [dbo].[usp_GetSubTasks] 
(
	@TaskId INT,
	@Admin BIT,
	@SortExpression	VARCHAR(250) = 'Status DESC',
	@OpenStatus		TINYINT = 1,
    @RequestedStatus	TINYINT = 2,
    @AssignedStatus	TINYINT = 3,
    @InProgressStatus	TINYINT = 4,
    @PendingStatus	TINYINT = 5,
    @ReOpenedStatus	TINYINT = 6,
    @ClosedStatus	TINYINT = 7,
    @SpecsInProgressStatus	TINYINT = 8,
    @DeletedStatus	TINYINT = 9
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	;WITH 
	
	Tasklist AS
	(	
	
		SELECT 
			--TaskUserMatch.IsMatch AS TaskUserMatch,
			--TaskUserRequestsMatch.IsMatch AS TaskUserRequestsMatch,
			--TaskDesignationMatch.IsMatch AS TaskDesignationMatch,
			Tasks.*
		FROM
			(
				SELECT 
					Tasks.*,
					1 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY
							CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
							CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
							CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
							CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
							CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
							CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
							CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
							CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
							CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
							CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC,
							CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.[Status] END DESC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] IN (@AssignedStatus,@RequestedStatus)
					
				UNION

				SELECT 
					Tasks.*,
					2 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY
							CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
							CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
							CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
							CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
							CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
							CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
							CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
							CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
							CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
							CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC,
							CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.[Status] END DESC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] IN (@InProgressStatus,@PendingStatus,@ReOpenedStatus)
					
				UNION

				SELECT 
					Tasks.*,
					3 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY 
							CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
							CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
							CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
							CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
							CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
							CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
							CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
							CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
							CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
							CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC,
							CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.[Status] END DESC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] IN (@OpenStatus) AND ISNULL([TaskPriority],'') <> ''

				UNION

				SELECT 
					Tasks.*,
					4 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY 
							CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
							CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
							CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
							CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
							CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
							CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
							CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
							CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
							CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
							CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC,
							CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.[Status] END DESC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] IN (@OpenStatus, @SpecsInProgressStatus)

				UNION

				SELECT 
					Tasks.*,
					5 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY
							CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
							CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
							CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
							CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
							CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
							CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
							CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
							CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
							CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
							CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC,
							CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.[Status] END DESC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] = @ClosedStatus

				UNION

				SELECT 
					Tasks.*,
					6 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY
							CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
							CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
							CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
							CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
							CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
							CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
							CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
							CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC,
							CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.[Status] END DESC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] = @DeletedStatus
			) Tasks
		WHERE
			Tasks.ParentTaskId = @TaskId
	),

	FinalData AS
	( 
		SELECT * ,
			Row_number() OVER(ORDER BY SortOrder ASC) AS RowNo
		FROM Tasklist 
	)
	
	-- get records
	SELECT * 
	FROM FinalData 

END
GO



-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 8/25/16
-- Description:	This procedure is used to search tasks by different parameters.
-- =============================================
ALTER PROCEDURE [dbo].[uspSearchTasks]
	@Designations	VARCHAR(4000) = '0',
	@UserId			INT = NULL,
	@Status			TINYINT = NULL,
	@CreatedFrom	DATETIME = NULL,
	@CreatedTo		DATETIME = NULL,
	@SearchTerm		VARCHAR(250) = NULL,
	@SortExpression	VARCHAR(250) = 'CreatedOn DESC',
	@ExcludeStatus	TINYINT = NULL,
	@Admin			BIT,
	@PageIndex		INT = 0,
	@PageSize		INT = 10,
	@OpenStatus		TINYINT = 1,
    @RequestedStatus	TINYINT = 2,
    @AssignedStatus	TINYINT = 3,
    @InProgressStatus	TINYINT = 4,
    @PendingStatus	TINYINT = 5,
    @ReOpenedStatus	TINYINT = 6,
    @ClosedStatus	TINYINT = 7,
    @SpecsInProgressStatus	TINYINT = 8,
    @DeletedStatus	TINYINT = 9
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @PageIndex = @PageIndex + 1

	;WITH 
	
	Tasklist AS
	(	
	
		SELECT 
			--TaskUserMatch.IsMatch AS TaskUserMatch,
			--TaskUserRequestsMatch.IsMatch AS TaskUserRequestsMatch,
			--TaskDesignationMatch.IsMatch AS TaskDesignationMatch,
			Tasks.*
		FROM
			(
				SELECT 
					Tasks.*,
					1 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY
							CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
							CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
							CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
							CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
							CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
							CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
							CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
							CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
							CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
							CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC,
							CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.[Status] END DESC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] IN (@AssignedStatus,@RequestedStatus)
					
				UNION

				SELECT 
					Tasks.*,
					2 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY
							CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
							CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
							CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
							CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
							CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
							CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
							CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
							CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
							CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
							CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC,
							CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.[Status] END DESC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] IN (@InProgressStatus,@PendingStatus,@ReOpenedStatus)
					
				UNION

				SELECT 
					Tasks.*,
					3 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY 
							CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
							CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
							CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
							CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
							CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
							CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
							CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
							CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
							CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
							CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC,
							CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.[Status] END DESC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] IN (@OpenStatus) AND ISNULL([TaskPriority],'') <> ''

				UNION

				SELECT 
					Tasks.*,
					4 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY 
							CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
							CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
							CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
							CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
							CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
							CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
							CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
							CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
							CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
							CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC,
							CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.[Status] END DESC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] IN (@OpenStatus, @SpecsInProgressStatus)

				UNION

				SELECT 
					Tasks.*,
					5 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY
							CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
							CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
							CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
							CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
							CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
							CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
							CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
							CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
							CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
							CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC,
							CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.[Status] END DESC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] = @ClosedStatus

				UNION

				SELECT 
					Tasks.*,
					6 AS SortOrder,
					Row_number() OVER
					(
						ORDER BY
							CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
							CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
							CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
							CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
							CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
							CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
							CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
							CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
							CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
							CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.[Status] END ASC,
							CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.[Status] END DESC
					) AS RowNo_Order
				FROM          
					[TaskListView] Tasks
				WHERE 
					[Status] = @DeletedStatus
			) Tasks    
			OUTER APPLY
			(
				SELECT TOP 1 
						1 AS IsMatch,
						TaskUsers.UserId AS UserId,
						UsersMaster.FristName AS FristName
				FROM tblTaskAssignedUsers TaskUsers
						LEFT JOIN tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id
				WHERE 
					TaskUsers.TaskId = Tasks.TaskId AND
					TaskUsers.[UserId] = ISNULL(@UserId, TaskUsers.[UserId]) AND
					1 = CASE
							WHEN @UserId IS NOT NULL THEN 1 -- set true, when user id is provided. so that join will handle record filtering and search term will have no effect on user.
							WHEN @SearchTerm IS NULL THEN 1 -- set true, when search term is null. so that join will handle record filtering and search term will have no effect on user.
							WHEN UsersMaster.FristName LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if users with given search terms are available. 
							ELSE 0
						END
			) As TaskUserMatch
			OUTER APPLY
			(
				SELECT TOP 1 
						1 AS IsMatch,
						TaskUsers.UserId AS UserId,
						UsersMaster.FristName AS FristName
				FROM tblTaskAssignmentRequests TaskUsers
						LEFT JOIN tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id
				WHERE 
					TaskUsers.TaskId = Tasks.TaskId AND
					TaskUsers.[UserId] = ISNULL(@UserId, TaskUsers.[UserId]) AND
					1 = CASE
							WHEN @UserId IS NOT NULL THEN 1 -- set true, when user id is provided. so that join will handle record filtering and search term will have no effect on user.
							WHEN @SearchTerm IS NULL THEN 1 -- set true, when search term is null. so that join will handle record filtering and search term will have no effect on user.
							WHEN UsersMaster.FristName LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if users with given search terms are available. 
							ELSE 0
						END
			) As TaskUserRequestsMatch
			OUTER APPLY
			(
				SELECT TOP 1 
						CASE
						WHEN @SearchTerm IS NULL THEN
							CASE
								WHEN @Designations = '0' THEN 1
								WHEN EXISTS (SELECT ss.Item  FROM dbo.SplitString(@Designations,',') ss WHERE ss.Item = TaskDesignations.Designation) THEN 1
								ELSE 0 
							END
						ELSE 
							CASE
								WHEN @Designations = '0' AND TaskDesignations.Designation LIKE '%' + @SearchTerm + '%' THEN 1
								WHEN (Tasks.[InstallId] LIKE '%' + @SearchTerm + '%'  OR Tasks.[Title] LIKE '%' + @SearchTerm + '%') THEN 1
								ELSE 0
							END
						END AS IsMatch,
						TaskDesignations.Designation AS Designation
				FROM tblTaskDesignations AS TaskDesignations
				WHERE 
					TaskDesignations.TaskId = Tasks.TaskId AND
					1 = CASE
							WHEN @Designations = '0' AND @SearchTerm IS NULL THEN 1 -- set true, when '0' (all designations) is provided with no search term.
							WHEN @Designations = '0' AND @SearchTerm IS NOT NULL AND TaskDesignations.Designation LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if designations found by search term.
							WHEN EXISTS (SELECT ss.Item  FROM dbo.SplitString(@Designations,',') ss WHERE ss.Item = TaskDesignations.Designation) THEN 1 -- filter based on provided designations.
							ELSE 0
						END
			)  AS TaskDesignationMatch
		WHERE
			Tasks.ParentTaskId IS NULL 
			AND
			1 = CASE
					WHEN @Admin = 1 THEN 1
					ELSE
						CASE
							WHEN Tasks.[Status] = @ExcludeStatus THEN 0
							ELSE 1
					END
				END
			AND 
			1 = CASE 
					-- filter records only by user, when search term is not provided.
					WHEN @SearchTerm IS NULL THEN
						CASE
							WHEN TaskUserMatch.IsMatch = 1 OR TaskDesignationMatch.IsMatch = 1 THEN 1
							WHEN TaskUserRequestsMatch.IsMatch = 1 OR TaskDesignationMatch.IsMatch = 1 THEN 1
							ELSE 0
						END
					-- filter records by installid, title, users when search term is provided.
					ELSE
						CASE
							WHEN Tasks.[InstallId] LIKE '%' + @SearchTerm + '%' THEN 1
							WHEN Tasks.[Title] LIKE '%' + @SearchTerm + '%' THEN 1
							WHEN TaskUserMatch.IsMatch = 1 THEN 1
							WHEN TaskUserRequestsMatch.IsMatch = 1 THEN 1
							ELSE 0
						END
				END
			AND
			Tasks.[Status] = ISNULL(@Status,Tasks.[Status]) 
			AND
			CONVERT(VARCHAR,Tasks.[CreatedOn],101)  >= ISNULL(@CreatedFrom,CONVERT(VARCHAR,Tasks.[CreatedOn],101)) AND
			CONVERT(VARCHAR,Tasks.[CreatedOn],101)  <= ISNULL(@CreatedTo,CONVERT(VARCHAR,Tasks.[CreatedOn],101))
	),

	FinalData AS
	( 
		SELECT * ,
			Row_number() OVER(ORDER BY SortOrder ASC) AS RowNo
		FROM Tasklist 
	)
	
	-- get records
	SELECT * 
	FROM FinalData 
	WHERE  
		RowNo BETWEEN (@PageIndex - 1) * @PageSize + 1 AND 
		@PageIndex * @PageSize

	-- get record count
	SELECT 
		COUNT(DISTINCT Tasks.TaskId) AS VirtualCount
	FROM          
		tblTask AS Tasks 
		OUTER APPLY
		(
			SELECT TOP 1 
					1 AS IsMatch,
					TaskUsers.UserId AS UserId,
					UsersMaster.FristName AS FristName
			FROM tblTaskAssignedUsers TaskUsers
					LEFT JOIN tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id
			WHERE 
				TaskUsers.TaskId = Tasks.TaskId AND
				TaskUsers.[UserId] = ISNULL(@UserId, TaskUsers.[UserId]) AND
				1 = CASE
						WHEN @UserId IS NOT NULL THEN 1 -- set true, when user id is provided. so that join will handle record filtering and search term will have no effect on user.
						WHEN @SearchTerm IS NULL THEN 1 -- set true, when search term is null. so that join will handle record filtering and search term will have no effect on user.
						WHEN UsersMaster.FristName LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if users with given search terms are available. 
						ELSE 0
					END
		) As TaskUserMatch
		OUTER APPLY
		(
			SELECT TOP 1 
					1 AS IsMatch,
					TaskUsers.UserId AS UserId,
					UsersMaster.FristName AS FristName
			FROM tblTaskAssignmentRequests TaskUsers
					LEFT JOIN tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id
			WHERE 
				TaskUsers.TaskId = Tasks.TaskId AND
				TaskUsers.[UserId] = ISNULL(@UserId, TaskUsers.[UserId]) AND
				1 = CASE
						WHEN @UserId IS NOT NULL THEN 1 -- set true, when user id is provided. so that join will handle record filtering and search term will have no effect on user.
						WHEN @SearchTerm IS NULL THEN 1 -- set true, when search term is null. so that join will handle record filtering and search term will have no effect on user.
						WHEN UsersMaster.FristName LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if users with given search terms are available. 
						ELSE 0
					END
		) As TaskUserRequestsMatch
		OUTER APPLY
		(
			SELECT TOP 1 
					1 AS IsMatch,
					TaskDesignations.Designation AS Designation
			FROM tblTaskDesignations AS TaskDesignations
			WHERE 
				TaskDesignations.TaskId = Tasks.TaskId AND
				1 = CASE
						WHEN @Designations = '0' AND @SearchTerm IS NULL THEN 1 -- set true, when '0' (all designations) is provided with no search term.
						WHEN @Designations = '0' AND @SearchTerm IS NOT NULL AND TaskDesignations.Designation LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if designations found by search term.
						WHEN EXISTS (SELECT ss.Item  FROM dbo.SplitString(@Designations,',') ss WHERE ss.Item = TaskDesignations.Designation) THEN 1 -- filter based on provided designations.
						ELSE 0
					END
		)  AS TaskDesignationMatch
	WHERE
		Tasks.ParentTaskId IS NULL 
		AND 
		1 = CASE 
				-- filter records only by user, when search term is not provided.
				WHEN @SearchTerm IS NULL THEN
					CASE
						WHEN TaskUserMatch.IsMatch = 1 OR TaskDesignationMatch.IsMatch = 1 THEN 1
						WHEN TaskUserRequestsMatch.IsMatch = 1 OR TaskDesignationMatch.IsMatch = 1THEN 1
						ELSE 0
					END
				-- filter records by installid, title, users when search term is provided.
				ELSE
					CASE
						WHEN Tasks.[InstallId] LIKE '%' + @SearchTerm + '%' THEN 1
						WHEN Tasks.[Title] LIKE '%' + @SearchTerm + '%' THEN 1
						WHEN TaskUserMatch.IsMatch = 1 THEN 1
						WHEN TaskUserRequestsMatch.IsMatch = 1 THEN 1
						ELSE 0
					END
			END
		AND
		Tasks.[Status] = ISNULL(@Status,Tasks.[Status]) 
		AND
		CONVERT(VARCHAR,Tasks.[CreatedOn],101)  >= ISNULL(@CreatedFrom,CONVERT(VARCHAR,Tasks.[CreatedOn],101)) AND
		CONVERT(VARCHAR,Tasks.[CreatedOn],101)  <= ISNULL(@CreatedTo,CONVERT(VARCHAR,Tasks.[CreatedOn],101))

END
GO

--=================================================================================================================================================================================================

-- Published on live 12022016 

--=================================================================================================================================================================================================

/****** Object:  StoredProcedure [dbo].[usp_GetSubTasks]    Script Date: 05-Dec-16 9:05:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 04/07/2016
-- Description:	Load all sub tasks of a task.
-- =============================================
-- usp_GetSubTasks 115, 1, 'Description DESC'
ALTER PROCEDURE [dbo].[usp_GetSubTasks] 
(
	@TaskId INT,
	@Admin BIT,
	@SortExpression	VARCHAR(250) = 'CreatedOn DESC',
	@OpenStatus		TINYINT = 1,
    @RequestedStatus	TINYINT = 2,
    @AssignedStatus	TINYINT = 3,
    @InProgressStatus	TINYINT = 4,
    @PendingStatus	TINYINT = 5,
    @ReOpenedStatus	TINYINT = 6,
    @ClosedStatus	TINYINT = 7,
    @SpecsInProgressStatus	TINYINT = 8,
    @DeletedStatus	TINYINT = 9
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	;WITH 
	
	Tasklist AS
	(	
		SELECT
			Tasks.*,
			Row_number() OVER
			(
				ORDER BY
					CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
					CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
					CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
					CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
					CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
					CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
					CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
					CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
					CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
					CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
					CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.StatusOrder END ASC,
					CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.StatusOrder END DESC,
					CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
					CASE WHEN @SortExpression = 'CreatedOn ASC' THEN Tasks.CreatedOn END ASC
			) AS RowNo_Order
		FROM
			(
				SELECT 
					Tasks.*,
					CASE Tasks.[Status]
						WHEN @AssignedStatus THEN 1
						WHEN @RequestedStatus THEN 1

						WHEN @InProgressStatus THEN 2
						WHEN @PendingStatus THEN 2
						WHEN @ReOpenedStatus THEN 2

						WHEN @OpenStatus THEN 
							CASE 
								WHEN ISNULL([TaskPriority],'') <> '' THEN 3
								ELSE 4
							END

						WHEN @SpecsInProgressStatus THEN 4

						WHEN @ClosedStatus THEN 5

						WHEN @DeletedStatus THEN 6

						ELSE 7

					END AS StatusOrder
				FROM 
					[TaskListView] Tasks
				WHERE
					Tasks.ParentTaskId = @TaskId
			) Tasks
	)
	
	-- get records
	SELECT * 
	FROM Tasklist 

END
GO


/****** Object:  StoredProcedure [dbo].[uspSearchTasks]    Script Date: 05-Dec-16 10:20:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 8/25/16
-- Description:	This procedure is used to search tasks by different parameters.
-- =============================================
ALTER PROCEDURE [dbo].[uspSearchTasks]
	@Designations	VARCHAR(4000) = '0',
	@UserId			INT = NULL,
	@Status			TINYINT = NULL,
	@CreatedFrom	DATETIME = NULL,
	@CreatedTo		DATETIME = NULL,
	@SearchTerm		VARCHAR(250) = NULL,
	@SortExpression	VARCHAR(250) = 'CreatedOn DESC',
	@ExcludeStatus	TINYINT = NULL,
	@Admin			BIT,
	@PageIndex		INT = 0,
	@PageSize		INT = 10,
	@OpenStatus		TINYINT = 1,
    @RequestedStatus	TINYINT = 2,
    @AssignedStatus	TINYINT = 3,
    @InProgressStatus	TINYINT = 4,
    @PendingStatus	TINYINT = 5,
    @ReOpenedStatus	TINYINT = 6,
    @ClosedStatus	TINYINT = 7,
    @SpecsInProgressStatus	TINYINT = 8,
    @DeletedStatus	TINYINT = 9
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @PageIndex = @PageIndex + 1

	;WITH 
	
	Tasklist AS
	(	
	
		SELECT 
			--TaskUserMatch.IsMatch AS TaskUserMatch,
			--TaskUserRequestsMatch.IsMatch AS TaskUserRequestsMatch,
			--TaskDesignationMatch.IsMatch AS TaskDesignationMatch,
			Tasks.*,
			Row_number() OVER
			(
				ORDER BY
					CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
					CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
					CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
					CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
					CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
					CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
					CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
					CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
					CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
					CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
					CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.StatusOrder END ASC,
					CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.StatusOrder END DESC,
					CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
					CASE WHEN @SortExpression = 'CreatedOn ASC' THEN Tasks.CreatedOn END ASC
			) AS RowNo_Order
		FROM
			(
				SELECT 
					Tasks.*,
					CASE Tasks.[Status]
						WHEN @AssignedStatus THEN 1
						WHEN @RequestedStatus THEN 1

						WHEN @InProgressStatus THEN 2
						WHEN @PendingStatus THEN 2
						WHEN @ReOpenedStatus THEN 2

						WHEN @OpenStatus THEN 
							CASE 
								WHEN ISNULL([TaskPriority],'') <> '' THEN 3
								ELSE 4
							END

						WHEN @SpecsInProgressStatus THEN 4

						WHEN @ClosedStatus THEN 5

						WHEN @DeletedStatus THEN 6

						ELSE 7

					END AS StatusOrder
				FROM 
					[TaskListView] Tasks
			) Tasks    
			OUTER APPLY
			(
				SELECT TOP 1 
						1 AS IsMatch,
						TaskUsers.UserId AS UserId,
						UsersMaster.FristName AS FristName
				FROM tblTaskAssignedUsers TaskUsers
						LEFT JOIN tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id
				WHERE 
					TaskUsers.TaskId = Tasks.TaskId AND
					TaskUsers.[UserId] = ISNULL(@UserId, TaskUsers.[UserId]) AND
					1 = CASE
							WHEN @UserId IS NOT NULL THEN 1 -- set true, when user id is provided. so that join will handle record filtering and search term will have no effect on user.
							WHEN @SearchTerm IS NULL THEN 1 -- set true, when search term is null. so that join will handle record filtering and search term will have no effect on user.
							WHEN UsersMaster.FristName LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if users with given search terms are available. 
							ELSE 0
						END
			) As TaskUserMatch
			OUTER APPLY
			(
				SELECT TOP 1 
						1 AS IsMatch,
						TaskUsers.UserId AS UserId,
						UsersMaster.FristName AS FristName
				FROM tblTaskAssignmentRequests TaskUsers
						LEFT JOIN tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id
				WHERE 
					TaskUsers.TaskId = Tasks.TaskId AND
					TaskUsers.[UserId] = ISNULL(@UserId, TaskUsers.[UserId]) AND
					1 = CASE
							WHEN @UserId IS NOT NULL THEN 1 -- set true, when user id is provided. so that join will handle record filtering and search term will have no effect on user.
							WHEN @SearchTerm IS NULL THEN 1 -- set true, when search term is null. so that join will handle record filtering and search term will have no effect on user.
							WHEN UsersMaster.FristName LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if users with given search terms are available. 
							ELSE 0
						END
			) As TaskUserRequestsMatch
			OUTER APPLY
			(
				SELECT TOP 1 
						CASE
						WHEN @SearchTerm IS NULL THEN
							CASE
								WHEN @Designations = '0' THEN 1
								WHEN EXISTS (SELECT ss.Item  FROM dbo.SplitString(@Designations,',') ss WHERE ss.Item = TaskDesignations.Designation) THEN 1
								ELSE 0 
							END
						ELSE 
							CASE
								WHEN @Designations = '0' AND TaskDesignations.Designation LIKE '%' + @SearchTerm + '%' THEN 1
								WHEN (Tasks.[InstallId] LIKE '%' + @SearchTerm + '%'  OR Tasks.[Title] LIKE '%' + @SearchTerm + '%') THEN 1
								ELSE 0
							END
						END AS IsMatch,
						TaskDesignations.Designation AS Designation
				FROM tblTaskDesignations AS TaskDesignations
				WHERE 
					TaskDesignations.TaskId = Tasks.TaskId AND
					1 = CASE
							WHEN @Designations = '0' AND @SearchTerm IS NULL THEN 1 -- set true, when '0' (all designations) is provided with no search term.
							WHEN @Designations = '0' AND @SearchTerm IS NOT NULL AND TaskDesignations.Designation LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if designations found by search term.
							WHEN EXISTS (SELECT ss.Item  FROM dbo.SplitString(@Designations,',') ss WHERE ss.Item = TaskDesignations.Designation) THEN 1 -- filter based on provided designations.
							ELSE 0
						END
			)  AS TaskDesignationMatch
		WHERE
			Tasks.ParentTaskId IS NULL 
			AND
			1 = CASE
					WHEN @Admin = 1 THEN 1
					ELSE
						CASE
							WHEN Tasks.[Status] = @ExcludeStatus THEN 0
							ELSE 1
					END
				END
			AND 
			1 = CASE 
					-- filter records only by user, when search term is not provided.
					WHEN @SearchTerm IS NULL THEN
						CASE
							WHEN TaskUserMatch.IsMatch = 1 OR TaskDesignationMatch.IsMatch = 1 THEN 1
							WHEN TaskUserRequestsMatch.IsMatch = 1 OR TaskDesignationMatch.IsMatch = 1 THEN 1
							ELSE 0
						END
					-- filter records by installid, title, users when search term is provided.
					ELSE
						CASE
							WHEN Tasks.[InstallId] LIKE '%' + @SearchTerm + '%' THEN 1
							WHEN Tasks.[Title] LIKE '%' + @SearchTerm + '%' THEN 1
							WHEN TaskUserMatch.IsMatch = 1 THEN 1
							WHEN TaskUserRequestsMatch.IsMatch = 1 THEN 1
							ELSE 0
						END
				END
			AND
			Tasks.[Status] = ISNULL(@Status,Tasks.[Status]) 
			AND
			CONVERT(VARCHAR,Tasks.[CreatedOn],101)  >= ISNULL(@CreatedFrom,CONVERT(VARCHAR,Tasks.[CreatedOn],101)) AND
			CONVERT(VARCHAR,Tasks.[CreatedOn],101)  <= ISNULL(@CreatedTo,CONVERT(VARCHAR,Tasks.[CreatedOn],101))
	)
	
	-- get records
	SELECT * 
	FROM Tasklist 
	WHERE  
		RowNo_Order BETWEEN (@PageIndex - 1) * @PageSize + 1 AND 
		@PageIndex * @PageSize

	-- get record count
	SELECT 
		COUNT(DISTINCT Tasks.TaskId) AS VirtualCount
	FROM          
		tblTask AS Tasks 
		OUTER APPLY
		(
			SELECT TOP 1 
					1 AS IsMatch,
					TaskUsers.UserId AS UserId,
					UsersMaster.FristName AS FristName
			FROM tblTaskAssignedUsers TaskUsers
					LEFT JOIN tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id
			WHERE 
				TaskUsers.TaskId = Tasks.TaskId AND
				TaskUsers.[UserId] = ISNULL(@UserId, TaskUsers.[UserId]) AND
				1 = CASE
						WHEN @UserId IS NOT NULL THEN 1 -- set true, when user id is provided. so that join will handle record filtering and search term will have no effect on user.
						WHEN @SearchTerm IS NULL THEN 1 -- set true, when search term is null. so that join will handle record filtering and search term will have no effect on user.
						WHEN UsersMaster.FristName LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if users with given search terms are available. 
						ELSE 0
					END
		) As TaskUserMatch
		OUTER APPLY
		(
			SELECT TOP 1 
					1 AS IsMatch,
					TaskUsers.UserId AS UserId,
					UsersMaster.FristName AS FristName
			FROM tblTaskAssignmentRequests TaskUsers
					LEFT JOIN tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id
			WHERE 
				TaskUsers.TaskId = Tasks.TaskId AND
				TaskUsers.[UserId] = ISNULL(@UserId, TaskUsers.[UserId]) AND
				1 = CASE
						WHEN @UserId IS NOT NULL THEN 1 -- set true, when user id is provided. so that join will handle record filtering and search term will have no effect on user.
						WHEN @SearchTerm IS NULL THEN 1 -- set true, when search term is null. so that join will handle record filtering and search term will have no effect on user.
						WHEN UsersMaster.FristName LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if users with given search terms are available. 
						ELSE 0
					END
		) As TaskUserRequestsMatch
		OUTER APPLY
		(
			SELECT TOP 1 
					1 AS IsMatch,
					TaskDesignations.Designation AS Designation
			FROM tblTaskDesignations AS TaskDesignations
			WHERE 
				TaskDesignations.TaskId = Tasks.TaskId AND
				1 = CASE
						WHEN @Designations = '0' AND @SearchTerm IS NULL THEN 1 -- set true, when '0' (all designations) is provided with no search term.
						WHEN @Designations = '0' AND @SearchTerm IS NOT NULL AND TaskDesignations.Designation LIKE '%' + @SearchTerm + '%' THEN 1 -- set true if designations found by search term.
						WHEN EXISTS (SELECT ss.Item  FROM dbo.SplitString(@Designations,',') ss WHERE ss.Item = TaskDesignations.Designation) THEN 1 -- filter based on provided designations.
						ELSE 0
					END
		)  AS TaskDesignationMatch
	WHERE
		Tasks.ParentTaskId IS NULL 
		AND 
		1 = CASE 
				-- filter records only by user, when search term is not provided.
				WHEN @SearchTerm IS NULL THEN
					CASE
						WHEN TaskUserMatch.IsMatch = 1 OR TaskDesignationMatch.IsMatch = 1 THEN 1
						WHEN TaskUserRequestsMatch.IsMatch = 1 OR TaskDesignationMatch.IsMatch = 1THEN 1
						ELSE 0
					END
				-- filter records by installid, title, users when search term is provided.
				ELSE
					CASE
						WHEN Tasks.[InstallId] LIKE '%' + @SearchTerm + '%' THEN 1
						WHEN Tasks.[Title] LIKE '%' + @SearchTerm + '%' THEN 1
						WHEN TaskUserMatch.IsMatch = 1 THEN 1
						WHEN TaskUserRequestsMatch.IsMatch = 1 THEN 1
						ELSE 0
					END
			END
		AND
		Tasks.[Status] = ISNULL(@Status,Tasks.[Status]) 
		AND
		CONVERT(VARCHAR,Tasks.[CreatedOn],101)  >= ISNULL(@CreatedFrom,CONVERT(VARCHAR,Tasks.[CreatedOn],101)) AND
		CONVERT(VARCHAR,Tasks.[CreatedOn],101)  <= ISNULL(@CreatedTo,CONVERT(VARCHAR,Tasks.[CreatedOn],101))

END
GO


CREATE TABLE [dbo].[tblTaskApprovals](
	[Id] [bigint] IDENTITY(1,1) PRIMARY KEY,
	[TaskId] [bigint] NOT NULL REFERENCES tblTask,
	[EstimatedHours] VARCHAR(5) NOT NULL,
	[Description] [text] NULL,
	[UserId] INT NULL,
	[IsInstallUser] BIT NULL,
	[DateCreated] [datetime] NOT NULL,
	[DateUpdated] [datetime] NOT NULL)
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 06 Dec 16
-- Description:	Insert Task approval.
-- =============================================
CREATE PROCEDURE [dbo].[InsertTaskApproval]
	@TaskId bigint,
	@EstimatedHours varchar(5),
	@Description text,
	@UserId int,
	@IsInstallUser bit
AS
BEGIN

	INSERT INTO [dbo].[tblTaskApprovals]
           ([TaskId]
           ,[EstimatedHours]
           ,[Description]
           ,[UserId]
           ,[IsInstallUser]
           ,[DateCreated]
           ,[DateUpdated])
     VALUES
           (@TaskId
           ,@EstimatedHours
           ,@Description
           ,@UserId
           ,@IsInstallUser
           ,GETDATE()
           ,GETDATE())

END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 06 Dec 16
-- Description:	Update Task approval.
-- =============================================
CREATE PROCEDURE [dbo].[UpdateTaskApproval]
	@Id		bigint,
	@TaskId bigint,
	@EstimatedHours VARCHAR(5),
	@Description text,
	@UserId int,
	@IsInstallUser bit
AS
BEGIN

	UPDATE [dbo].[tblTaskApprovals]
    SET
	    [TaskId] = @TaskId
       ,[EstimatedHours] = @EstimatedHours
       ,[Description] = @Description
       ,[UserId] = @UserId
       ,[IsInstallUser] = @IsInstallUser
       ,[DateUpdated] = GETDATE()
     WHERE
		Id = @Id

END
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[UDF_GetIsAdminUser]
(
	@Designation VARCHAR(50)
)
RETURNS BIT
AS
BEGIN
	declare @IsAdmin BIT

	SELECT 
		@IsAdmin = CASE UPPER(@Designation)
			WHEN 'ADMIN' THEN 1
			WHEN 'OFFICE MANAGER' THEN 1
			WHEN 'SALES MANAGER' THEN 1
			WHEN 'ITLEAD' THEN 1
			WHEN 'FOREMAN' THEN 1
			ELSE 0 
		END

	RETURN @IsAdmin
END
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[UDF_GetIsAdminOrITLeadUser]
(
	@Designation VARCHAR(50)
)
RETURNS BIT
AS
BEGIN
	declare @IsAdmin BIT

	SELECT 
		@IsAdmin = CASE UPPER(@Designation)
			WHEN 'ADMIN' THEN 1
			WHEN 'ITLEAD' THEN 1
			ELSE 0 
		END

	RETURN @IsAdmin
END
GO




SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[TaskApprovalsView] as

	SELECT
			s.*,
			
			u.Username AS Username,
			u.FirstName AS UserFirstName,
			u.LastName AS UserLastName,
			u.Email AS UserEmail,
			u.Designation AS UserDesignation,
			[dbo].[UDF_GetIsAdminOrITLeadUser](u.Designation) AS IsAdminOrITLead

	FROM tblTaskApprovals s
			OUTER APPLY
			(
				SELECT TOP 1 iu.Id,iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email, iu.Designation
				FROM tblInstallUsers iu
				WHERE iu.Id = s.UserId AND s.IsInstallUser = 1
			
				UNION

				SELECT TOP 1 u.Id,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email, u.Designation
				FROM tblUsers u
				WHERE u.Id = s.UserId AND s.IsInstallUser = 0
			) AS u

GO



/****** Object:  StoredProcedure [dbo].[usp_GetSubTasks]    Script Date: 06-Dec-16 11:30:16 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 04/07/2016
-- Description:	Load all sub tasks of a task.
-- =============================================
-- usp_GetSubTasks 115, 1, 'Description DESC'
ALTER PROCEDURE [dbo].[usp_GetSubTasks] 
(
	@TaskId INT,
	@Admin BIT,
	@SortExpression	VARCHAR(250) = 'CreatedOn DESC',
	@OpenStatus		TINYINT = 1,
    @RequestedStatus	TINYINT = 2,
    @AssignedStatus	TINYINT = 3,
    @InProgressStatus	TINYINT = 4,
    @PendingStatus	TINYINT = 5,
    @ReOpenedStatus	TINYINT = 6,
    @ClosedStatus	TINYINT = 7,
    @SpecsInProgressStatus	TINYINT = 8,
    @DeletedStatus	TINYINT = 9
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	;WITH 
	
	Tasklist AS
	(	
		SELECT
			Tasks.*,
			Row_number() OVER
			(
				ORDER BY
					CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
					CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
					CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
					CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
					CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
					CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
					CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
					CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
					CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
					CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
					CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.StatusOrder END ASC,
					CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.StatusOrder END DESC,
					CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
					CASE WHEN @SortExpression = 'CreatedOn ASC' THEN Tasks.CreatedOn END ASC
			) AS RowNo_Order
		FROM
			(
				SELECT 
					Tasks.*,
					CASE Tasks.[Status]
						WHEN @AssignedStatus THEN 1
						WHEN @RequestedStatus THEN 1

						WHEN @InProgressStatus THEN 2
						WHEN @PendingStatus THEN 2
						WHEN @ReOpenedStatus THEN 2

						WHEN @OpenStatus THEN 
							CASE 
								WHEN ISNULL([TaskPriority],'') <> '' THEN 3
								ELSE 4
							END

						WHEN @SpecsInProgressStatus THEN 4

						WHEN @ClosedStatus THEN 5

						WHEN @DeletedStatus THEN 6

						ELSE 7

					END AS StatusOrder,
					TaskApprovals.Id AS TaskApprovalId,
					TaskApprovals.EstimatedHours AS TaskApprovalEstimatedHours,
					TaskApprovals.Description AS TaskApprovalDescription,
					TaskApprovals.UserId AS TaskApprovalUserId,
					TaskApprovals.IsInstallUser AS TaskApprovalIsInstallUser
				FROM 
					[TaskListView] Tasks 
						LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId 
																	AND TaskApprovals.IsAdminOrITLead = @Admin
				WHERE
					Tasks.ParentTaskId = @TaskId
			) Tasks
	)
	
	-- get records
	SELECT * 
	FROM Tasklist 

END

GO


/****** Object:  StoredProcedure [dbo].[usp_GetSubTasks]    Script Date: 06-Dec-16 11:30:16 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 04/07/2016
-- Description:	Load all sub tasks of a task.
-- =============================================
-- usp_GetSubTasks 115, 1, 'Description DESC'
ALTER PROCEDURE [dbo].[usp_GetSubTasks] 
(
	@TaskId INT,
	@Admin BIT,
	@SortExpression	VARCHAR(250) = 'CreatedOn DESC',
	@OpenStatus		TINYINT = 1,
    @RequestedStatus	TINYINT = 2,
    @AssignedStatus	TINYINT = 3,
    @InProgressStatus	TINYINT = 4,
    @PendingStatus	TINYINT = 5,
    @ReOpenedStatus	TINYINT = 6,
    @ClosedStatus	TINYINT = 7,
    @SpecsInProgressStatus	TINYINT = 8,
    @DeletedStatus	TINYINT = 9
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	;WITH 
	
	Tasklist AS
	(	
		SELECT
			Tasks.*,
			(SELECT EstimatedHours 
				FROM [TaskApprovalsView] TaskApprovals 
				WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 1) AS AdminOrITLeadEstimatedHours,
			(SELECT EstimatedHours 
				FROM [TaskApprovalsView] TaskApprovals 
				WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 0) AS UserEstimatedHours,
			Row_number() OVER
			(
				ORDER BY
					CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
					CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
					CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
					CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
					CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
					CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
					CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
					CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
					CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
					CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
					CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.StatusOrder END ASC,
					CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.StatusOrder END DESC,
					CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
					CASE WHEN @SortExpression = 'CreatedOn ASC' THEN Tasks.CreatedOn END ASC
			) AS RowNo_Order
		FROM
			(
				SELECT 
					Tasks.*,
					CASE Tasks.[Status]
						WHEN @AssignedStatus THEN 1
						WHEN @RequestedStatus THEN 1

						WHEN @InProgressStatus THEN 2
						WHEN @PendingStatus THEN 2
						WHEN @ReOpenedStatus THEN 2

						WHEN @OpenStatus THEN 
							CASE 
								WHEN ISNULL([TaskPriority],'') <> '' THEN 3
								ELSE 4
							END

						WHEN @SpecsInProgressStatus THEN 4

						WHEN @ClosedStatus THEN 5

						WHEN @DeletedStatus THEN 6

						ELSE 7

					END AS StatusOrder,
					TaskApprovals.Id AS TaskApprovalId,
					TaskApprovals.EstimatedHours AS TaskApprovalEstimatedHours,
					TaskApprovals.Description AS TaskApprovalDescription,
					TaskApprovals.UserId AS TaskApprovalUserId,
					TaskApprovals.IsInstallUser AS TaskApprovalIsInstallUser
				FROM 
					[TaskListView] Tasks 
						LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin
				WHERE
					Tasks.ParentTaskId = @TaskId
			) Tasks
	)
	
	-- get records
	SELECT * 
	FROM Tasklist 

END

GO

ALTER TABLE tblTask
ADD Url VARCHAR(250) NULL
GO


/****** Object:  StoredProcedure [dbo].[SP_SaveOrDeleteTask]    Script Date: 07-Dec-16 11:34:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 14 Nov 16
-- Description:	Inserts, Updates or Deletes a task.
-- =============================================
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
					OtherUserStatus
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
					0
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

ALTER VIEW [dbo].[TaskListView] 
AS
SELECT 
	Tasks.*,
	STUFF
	(
		(SELECT  CAST(', ' + td.Designation as VARCHAR) AS Designation
		FROM tblTaskDesignations td
		WHERE td.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskDesignations,
	STUFF
	(
		(SELECT  CAST(', ' + u.FristName as VARCHAR) AS Name
		FROM tblTaskAssignedUsers tu
			INNER JOIN tblInstallUsers u ON tu.UserId = u.Id
		WHERE tu.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskAssignedUsers,
	STUFF
	(
		(SELECT  ',' + CAST(tu.UserId as VARCHAR) AS Id
		FROM tblTaskAssignedUsers tu
		WHERE tu.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,1
		,''
	) AS TaskAssignedUserIds,
	STUFF
	(
		(SELECT  CAST(', ' + CAST(tu.UserId AS VARCHAR) + ':' + u.FristName as VARCHAR) AS Name
		FROM tblTaskAssignmentRequests tu
			INNER JOIN tblInstallUsers u ON tu.UserId = u.Id
		WHERE tu.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskAssignmentRequestUsers,
	STUFF
	(
		(SELECT  ', ' + CAST(tu.UserId AS VARCHAR) AS UserId
		FROM tblTaskAcceptance tu
		WHERE tu.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskAcceptanceUsers,
	STUFF
	(
		(SELECT  CAST(', ' + tuf.[Attachment] + '@' + tuf.[AttachmentOriginal] as VARCHAR(max)) AS attachment
		FROM dbo.tblTaskUserFiles tuf
		WHERE tuf.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskUserFiles
FROM          
	tblTask AS Tasks 

GO



-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 04/07/2016
-- Description:	Load all details of task for edit.
-- =============================================
-- usp_GetTaskDetails 170
ALTER PROCEDURE [dbo].[usp_GetTaskDetails] 
(
	@TaskId int 
)	  
AS
BEGIN
	
	SET NOCOUNT ON;

	-- task manager detail
	DECLARE @AssigningUser varchar(50) = NULL

	SELECT @AssigningUser = Users.[Username] 
	FROM 
		tblTask AS Task 
		INNER JOIN [dbo].[tblUsers] AS Users  ON Task.[CreatedBy] = Users.Id
	WHERE TaskId = @TaskId

	IF(@AssigningUser IS NULL)
	BEGIN
		SELECT @AssigningUser = Users.FristName + ' ' + Users.LastName 
		FROM 
			tblTask AS Task 
			INNER JOIN [dbo].[tblInstallUsers] AS Users  ON Task.[CreatedBy] = Users.Id
		WHERE TaskId = @TaskId
	END

	-- task's main details
	SELECT Title,Url, [Description], [Status], DueDate,Tasks.[Hours], Tasks.CreatedOn, Tasks.TaskPriority,
		   Tasks.InstallId, Tasks.CreatedBy, @AssigningUser AS AssigningManager ,Tasks.TaskType, Tasks.IsTechTask,
		   STUFF
			(
				(SELECT  CAST(', ' + ttuf.[Attachment] + '@' + ttuf.[AttachmentOriginal] as VARCHAR(max)) AS attachment
				FROM dbo.tblTaskUserFiles ttuf
				WHERE ttuf.TaskId = Tasks.TaskId
				FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
				,1
				,2
				,' '
			) AS attachment
	FROM tblTask AS Tasks
	WHERE Tasks.TaskId = @TaskId

	-- task's designation details
	SELECT Designation
	FROM tblTaskDesignations
	WHERE (TaskId = @TaskId)

	-- task's assigned users
	SELECT UserId, TaskId
	FROM tblTaskAssignedUsers
	WHERE (TaskId = @TaskId)

	-- task's notes and attachment information.
	--SELECT	TaskUsers.Id,TaskUsers.UserId, TaskUsers.UserType, TaskUsers.Notes, TaskUsers.UserAcceptance, TaskUsers.UpdatedOn, 
	--	    TaskUsers.[Status], TaskUsers.TaskId, tblInstallUsers.FristName,TaskUsers.UserFirstName, tblInstallUsers.Designation,
	--		(SELECT COUNT(ttuf.[Id]) FROM dbo.tblTaskUserFiles ttuf WHERE ttuf.[TaskUpdateID] = TaskUsers.Id) AS AttachmentCount,
	--		dbo.UDF_GetTaskUpdateAttachments(TaskUsers.Id) AS attachments
	--FROM    
	--	tblTaskUser AS TaskUsers 
	--	LEFT OUTER JOIN tblInstallUsers ON TaskUsers.UserId = tblInstallUsers.Id
	--WHERE (TaskUsers.TaskId = @TaskId) 
	
	-- Description:	Get All Notes along with Attachments.
	-- Modify by :: Aavadesh Patel :: 10.08.2016 23:28

;WITH TaskHistory
AS 
(
	SELECT	
		TaskUsers.Id,
		TaskUsers.UserId, 
		TaskUsers.UserType, 
		TaskUsers.Notes, 
		TaskUsers.UserAcceptance, 
		TaskUsers.UpdatedOn, 
		TaskUsers.[Status], 
		TaskUsers.TaskId, 
		tblInstallUsers.FristName,
		tblInstallUsers.LastName,
		TaskUsers.UserFirstName, 
		tblInstallUsers.Designation,
		tblInstallUsers.Picture,
		tblInstallUsers.UserInstallId,
		(SELECT COUNT(ttuf.[Id]) FROM dbo.tblTaskUserFiles ttuf WHERE ttuf.[TaskUpdateID] = TaskUsers.Id) AS AttachmentCount,
		dbo.UDF_GetTaskUpdateAttachments(TaskUsers.Id) AS attachments,
		'' as AttachmentOriginal , 0 as TaskUserFilesID,
		'' as Attachment , '' as FileType
	FROM    
		tblTaskUser AS TaskUsers 
		LEFT OUTER JOIN tblInstallUsers ON TaskUsers.UserId = tblInstallUsers.Id
	WHERE (TaskUsers.TaskId = @TaskId) AND (TaskUsers.Notes <> '' OR TaskUsers.Notes IS NOT NULL) 
	
	
	Union All 
		
	SELECT	
		tblTaskUserFiles.Id , 
		tblTaskUserFiles.UserId , 
		'' as UserType , 
		'' as Notes , 
		'' as UserAcceptance , 
		tblTaskUserFiles.AttachedFileDate AS UpdatedOn,
		'' as [Status] , 
		tblTaskUserFiles.TaskId , 
		tblInstallUsers.FristName  ,
		tblInstallUsers.LastName,
		tblInstallUsers.FristName as UserFirstName , 
		'' as Designation , 
		tblInstallUsers.Picture,
		tblInstallUsers.UserInstallId,
		'' as AttachmentCount , 
		'' as attachments,
		 tblTaskUserFiles.AttachmentOriginal,
		 tblTaskUserFiles.Id as  TaskUserFilesID,
		 tblTaskUserFiles.Attachment, 
		 tblTaskUserFiles.FileType
	FROM   tblTaskUserFiles   
	LEFT OUTER JOIN tblInstallUsers ON tblInstallUsers.Id = tblTaskUserFiles.UserId
	WHERE (tblTaskUserFiles.TaskId = @TaskId) AND (tblTaskUserFiles.Attachment <> '' OR tblTaskUserFiles.Attachment IS NOT NULL)
)

SELECT * from TaskHistory ORDER BY  UpdatedOn DESC
	
	-- sub tasks
	SELECT Tasks.TaskId, Title, [Description], Tasks.[Status], DueDate,Tasks.[Hours], Tasks.CreatedOn, Tasks.TaskPriority,
		   Tasks.InstallId, Tasks.CreatedBy, @AssigningUser AS AssigningManager , UsersMaster.FristName,
		   Tasks.TaskType,Tasks.TaskPriority, Tasks.IsTechTask,
		   STUFF
			(
				(SELECT  CAST(', ' + ttuf.[Attachment] + '@' + ttuf.[AttachmentOriginal] as VARCHAR(max)) AS attachment
				FROM dbo.tblTaskUserFiles ttuf
				WHERE ttuf.TaskId = Tasks.TaskId
				FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
				,1
				,2
				,' '
			) AS attachment
	FROM 
		tblTask AS Tasks LEFT OUTER JOIN
        tblTaskAssignedUsers AS TaskUsers ON Tasks.TaskId = TaskUsers.TaskId LEFT OUTER JOIN
        tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id --LEFT OUTER JOIN
		--tblTaskDesignations AS TaskDesignation ON Tasks.TaskId = TaskDesignation.TaskId
	WHERE Tasks.ParentTaskId = @TaskId
    
	-- main task attachments
	SELECT 
		CAST(
				--tuf.[Attachment] + '@' + tuf.[AttachmentOriginal] 
				ISNULL(tuf.[Attachment],'') + '@' + ISNULL(tuf.[AttachmentOriginal],'') 
				AS VARCHAR(MAX)
			) AS attachment,
		ISNULL(u.FirstName,iu.FristName) AS FirstName
	FROM dbo.tblTaskUserFiles tuf
			LEFT JOIN tblUsers u ON tuf.UserId = u.Id --AND tuf.UserType = u.Usertype
			LEFT JOIN tblInstallUsers iu ON tuf.UserId = iu.Id --AND tuf.UserType = u.UserType
	WHERE tuf.TaskId = @TaskId

END

--=================================================================================================================================================================================================

-- Published on live 12072016 

--=================================================================================================================================================================================================
INSERT INTO [dbo].[tbl_Designation]
           ([DesignationName]
           ,[IsActive]
           ,[DepartmentID])
     VALUES
           ('Admin-Sales'
           ,1
           ,1)


INSERT INTO [dbo].[tbl_Designation]
           ([DesignationName]
           ,[IsActive]
           ,[DepartmentID])
     VALUES
           ('Admin Recruiter'
           ,1
           ,1)

GO

/****** Object:  UserDefinedFunction [dbo].[UDF_GetIsAdminOrITLeadUser]    Script Date: 15-Dec-16 12:33:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[UDF_GetIsAdminOrITLeadUser]
(
	@Designation VARCHAR(50)
)
RETURNS BIT
AS
BEGIN
	declare @IsAdmin BIT

	SELECT 
		@IsAdmin = CASE UPPER(@Designation)
			WHEN 'ADMIN' THEN 1
			WHEN 'ITLEAD' THEN 1
			WHEN 'ADMIN-SALES' THEN 1
			WHEN 'ADMIN RECRUITER' THEN 1
			ELSE 0 
		END

	RETURN @IsAdmin
END
GO

/****** Object:  UserDefinedFunction [dbo].[UDF_GetIsAdminUser]    Script Date: 15-Dec-16 12:34:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[UDF_GetIsAdminUser]
(
	@Designation VARCHAR(50)
)
RETURNS BIT
AS
BEGIN
	declare @IsAdmin BIT

	SELECT 
		@IsAdmin = CASE UPPER(@Designation)
			WHEN 'ADMIN' THEN 1
			WHEN 'OFFICE MANAGER' THEN 1
			WHEN 'SALES MANAGER' THEN 1
			WHEN 'ITLEAD' THEN 1
			WHEN 'FOREMAN' THEN 1
			WHEN 'ADMIN-SALES' THEN 1
			WHEN 'ADMIN RECRUITER' THEN 1
			ELSE 0 
		END

	RETURN @IsAdmin
END
GO
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 04/07/2016
-- Description:	Load all details of task for edit.
-- =============================================
-- usp_GetTaskDetails 170
ALTER PROCEDURE [dbo].[usp_GetTaskDetails] 
(
	@TaskId int 
)	  
AS
BEGIN
	
	SET NOCOUNT ON;

	-- task manager detail
	DECLARE @AssigningUser varchar(50) = NULL

	SELECT @AssigningUser = Users.[Username] 
	FROM 
		tblTask AS Task 
		INNER JOIN [dbo].[tblUsers] AS Users  ON Task.[CreatedBy] = Users.Id
	WHERE TaskId = @TaskId

	IF(@AssigningUser IS NULL)
	BEGIN
		SELECT @AssigningUser = Users.FristName + ' ' + Users.LastName 
		FROM 
			tblTask AS Task 
			INNER JOIN [dbo].[tblInstallUsers] AS Users  ON Task.[CreatedBy] = Users.Id
		WHERE TaskId = @TaskId
	END

	-- task's main details
	SELECT Title,Url, [Description], [Status], DueDate,Tasks.[Hours], Tasks.CreatedOn, Tasks.TaskPriority,
		   Tasks.InstallId, Tasks.CreatedBy, @AssigningUser AS AssigningManager ,Tasks.TaskType, Tasks.IsTechTask,
		   STUFF
			(
				(SELECT  CAST(', ' + ttuf.[Attachment] + '@' + ttuf.[AttachmentOriginal]  + '@' + CAST( ttuf.[AttachedFileDate] AS VARCHAR(100)) + '@' + (CASE WHEN ctuser.Id IS NULL THEN 'N.A.'ELSE ctuser.FristName + ' ' + ctuser.LastName END) as VARCHAR(max)) AS attachment
				FROM dbo.tblTaskUserFiles ttuf 
				INNER JOIN tblInstallUsers AS ctuser ON ttuf.UserId = ctuser.Id
				WHERE ttuf.TaskId = Tasks.TaskId
				FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
				,1
				,2
				,' '
			) AS attachment
	FROM tblTask AS Tasks
	WHERE Tasks.TaskId = @TaskId

	-- task's designation details
	SELECT Designation
	FROM tblTaskDesignations
	WHERE (TaskId = @TaskId)

	-- task's assigned users
	SELECT UserId, TaskId
	FROM tblTaskAssignedUsers
	WHERE (TaskId = @TaskId)

	-- task's notes and attachment information.
	--SELECT	TaskUsers.Id,TaskUsers.UserId, TaskUsers.UserType, TaskUsers.Notes, TaskUsers.UserAcceptance, TaskUsers.UpdatedOn, 
	--	    TaskUsers.[Status], TaskUsers.TaskId, tblInstallUsers.FristName,TaskUsers.UserFirstName, tblInstallUsers.Designation,
	--		(SELECT COUNT(ttuf.[Id]) FROM dbo.tblTaskUserFiles ttuf WHERE ttuf.[TaskUpdateID] = TaskUsers.Id) AS AttachmentCount,
	--		dbo.UDF_GetTaskUpdateAttachments(TaskUsers.Id) AS attachments
	--FROM    
	--	tblTaskUser AS TaskUsers 
	--	LEFT OUTER JOIN tblInstallUsers ON TaskUsers.UserId = tblInstallUsers.Id
	--WHERE (TaskUsers.TaskId = @TaskId) 
	
	-- Description:	Get All Notes along with Attachments.
	-- Modify by :: Aavadesh Patel :: 10.08.2016 23:28

;WITH TaskHistory
AS 
(
	SELECT	
		TaskUsers.Id,
		TaskUsers.UserId, 
		TaskUsers.UserType, 
		TaskUsers.Notes, 
		TaskUsers.UserAcceptance, 
		TaskUsers.UpdatedOn, 
		TaskUsers.[Status], 
		TaskUsers.TaskId, 
		tblInstallUsers.FristName,
		tblInstallUsers.LastName,
		TaskUsers.UserFirstName, 
		tblInstallUsers.Designation,
		tblInstallUsers.Picture,
		tblInstallUsers.UserInstallId,
		(SELECT COUNT(ttuf.[Id]) FROM dbo.tblTaskUserFiles ttuf WHERE ttuf.[TaskUpdateID] = TaskUsers.Id) AS AttachmentCount,
		dbo.UDF_GetTaskUpdateAttachments(TaskUsers.Id) AS attachments,
		'' as AttachmentOriginal , 0 as TaskUserFilesID,
		'' as Attachment , '' as FileType
	FROM    
		tblTaskUser AS TaskUsers 
		LEFT OUTER JOIN tblInstallUsers ON TaskUsers.UserId = tblInstallUsers.Id
	WHERE (TaskUsers.TaskId = @TaskId) AND (TaskUsers.Notes <> '' OR TaskUsers.Notes IS NOT NULL) 
	
	
	Union All 
		
	SELECT	
		tblTaskUserFiles.Id , 
		tblTaskUserFiles.UserId , 
		'' as UserType , 
		'' as Notes , 
		'' as UserAcceptance , 
		tblTaskUserFiles.AttachedFileDate AS UpdatedOn,
		'' as [Status] , 
		tblTaskUserFiles.TaskId , 
		tblInstallUsers.FristName  ,
		tblInstallUsers.LastName,
		tblInstallUsers.FristName as UserFirstName , 
		'' as Designation , 
		tblInstallUsers.Picture,
		tblInstallUsers.UserInstallId,
		'' as AttachmentCount , 
		'' as attachments,
		 tblTaskUserFiles.AttachmentOriginal,
		 tblTaskUserFiles.Id as  TaskUserFilesID,
		 tblTaskUserFiles.Attachment, 
		 tblTaskUserFiles.FileType
	FROM   tblTaskUserFiles   
	LEFT OUTER JOIN tblInstallUsers ON tblInstallUsers.Id = tblTaskUserFiles.UserId
	WHERE (tblTaskUserFiles.TaskId = @TaskId) AND (tblTaskUserFiles.Attachment <> '' OR tblTaskUserFiles.Attachment IS NOT NULL)
)

SELECT * from TaskHistory ORDER BY  UpdatedOn DESC
	
	-- sub tasks
	SELECT Tasks.TaskId, Title, [Description], Tasks.[Status], DueDate,Tasks.[Hours], Tasks.CreatedOn, Tasks.TaskPriority,
		   Tasks.InstallId, Tasks.CreatedBy, @AssigningUser AS AssigningManager , UsersMaster.FristName,
		   Tasks.TaskType,Tasks.TaskPriority, Tasks.IsTechTask,
		   STUFF
			(
				(SELECT  CAST(', ' + ttuf.[Attachment] + '@' + ttuf.[AttachmentOriginal] + '@' + CAST( ttuf.[AttachedFileDate] AS VARCHAR(100))+ '@'  + (CASE WHEN ctuser.Id IS NULL THEN 'N.A.'ELSE ctuser.FristName + ' ' + ctuser.LastName END) as VARCHAR(max)) AS attachment
				FROM dbo.tblTaskUserFiles ttuf
				INNER JOIN tblInstallUsers AS ctuser ON ttuf.UserId = ctuser.Id
				WHERE ttuf.TaskId = Tasks.TaskId
				FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
				,1
				,2
				,' '
			) AS attachment
	FROM 
		tblTask AS Tasks LEFT OUTER JOIN
        tblTaskAssignedUsers AS TaskUsers ON Tasks.TaskId = TaskUsers.TaskId LEFT OUTER JOIN
        tblInstallUsers AS UsersMaster ON TaskUsers.UserId = UsersMaster.Id --LEFT OUTER JOIN
		--tblTaskDesignations AS TaskDesignation ON Tasks.TaskId = TaskDesignation.TaskId
	WHERE Tasks.ParentTaskId = @TaskId
    
	-- main task attachments
	SELECT 
		CAST(
				--tuf.[Attachment] + '@' + tuf.[AttachmentOriginal] 
				ISNULL(tuf.[Attachment],'') + '@' + ISNULL(tuf.[AttachmentOriginal],'') 
				AS VARCHAR(MAX)
			) AS attachment,
		ISNULL(u.FirstName,iu.FristName) AS FirstName
	FROM dbo.tblTaskUserFiles tuf
			LEFT JOIN tblUsers u ON tuf.UserId = u.Id --AND tuf.UserType = u.Usertype
			LEFT JOIN tblInstallUsers iu ON tuf.UserId = iu.Id --AND tuf.UserType = u.UserType
	WHERE tuf.TaskId = @TaskId

END
GO
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE VIEW [dbo].[TaskListView] 
AS
SELECT 
	Tasks.*,
	STUFF
	(
		(SELECT  CAST(', ' + td.Designation as VARCHAR) AS Designation
		FROM tblTaskDesignations td
		WHERE td.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskDesignations,
	STUFF
	(
		(SELECT  CAST(', ' + u.FristName + ' ' + u.LastName as VARCHAR) AS Name
		FROM tblTaskAssignedUsers tu
			INNER JOIN tblInstallUsers u ON tu.UserId = u.Id
		WHERE tu.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskAssignedUsers,
	STUFF
	(
		(SELECT  ',' + CAST(tu.UserId as VARCHAR) AS Id
		FROM tblTaskAssignedUsers tu
		WHERE tu.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,1
		,''
	) AS TaskAssignedUserIds,
	STUFF
	(
		(SELECT  CAST(', ' + CAST(tu.UserId AS VARCHAR) + ':' + u.FristName as VARCHAR) AS Name
		FROM tblTaskAssignmentRequests tu
			INNER JOIN tblInstallUsers u ON tu.UserId = u.Id
		WHERE tu.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskAssignmentRequestUsers,
	STUFF
	(
		(SELECT  ', ' + CAST(tu.UserId AS VARCHAR) AS UserId
		FROM tblTaskAcceptance tu
		WHERE tu.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskAcceptanceUsers,
	STUFF
	(
		(SELECT  CAST(', ' + tuf.[Attachment] + '@' + tuf.[AttachmentOriginal]  + '@' + CAST( tuf.[AttachedFileDate] AS VARCHAR(100)) + '@' + (CASE WHEN ctuser.Id IS NULL THEN 'N.A.'ELSE ctuser.FristName + ' ' + ctuser.LastName END) as VARCHAR(max)) AS attachment
		FROM dbo.tblTaskUserFiles tuf  INNER JOIN tblInstallUsers AS ctuser ON tuf.UserId = ctuser.Id
		WHERE tuf.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskUserFiles
FROM          
	tblTask AS Tasks 

GO


/****** Object:  StoredProcedure [dbo].[SP_SaveOrDeleteTaskUserFiles]    Script Date: 19-Dec-16 9:25:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_SaveOrDeleteTaskUserFiles]  
(   
	@Mode tinyint, -- 0:Insert, 1: Update 2: Delete  
	@TaskUpDateId bigint= NULL,  
	@TaskId bigint,  
	@FileDestination TINYINT = NULL,
	@UserId int,  
	@Attachment varchar(MAX),
	@OriginalFileName varchar(MAX),
	@UserType BIT,
    @FileType varchar(5)
) 
AS  
BEGIN  
  
	IF @Mode=0 
	BEGIN  

		/* Generate an image name starts */
		DECLARE @NextId INT = 1
		DECLARE @ParentTaskId BIGINT = NULL

		SELECT @ParentTaskId = t.ParentTaskId
		FROM tblTask t
		WHERE t.TaskId = @TaskId

		SELECT @NextId = (COUNT(*) + 1)
		FROM tblTaskUserFiles t
		WHERE 
			  t.TaskId = ISNULL(@ParentTaskId, @TaskId) OR
			  t.TaskId IN (SELECT TaskId FROM tblTask WHERE ParentTaskId = ISNULL(@ParentTaskId, @TaskId))

		SELECT @OriginalFileName = 
						ISNULL(
								CAST(t.InstallId AS VARCHAR), 
								'TASK' + CAST(t.TaskId AS VARCHAR)
							  ) 
						+ '-IMG'
						+ RIGHT('000'+CAST(@NextId AS VARCHAR),3)
						+ '.' + REVERSE(SUBSTRING(REVERSE(@OriginalFileName),0,CHARINDEX('.',REVERSE(@OriginalFileName))))
		FROM tblTask t
		WHERE t.TaskId = ISNULL(@ParentTaskId, @TaskId)

		/* Generate an image name ends */
		
		INSERT INTO tblTaskUserFiles (TaskId,UserId,Attachment,TaskUpdateID,IsDeleted, AttachmentOriginal, UserType,FileDestination, FileType, AttachedFileDate)   
		VALUES(@TaskId,@UserId,@Attachment,@TaskUpDateId,0, @OriginalFileName, @UserType,@FileDestination, @FileType ,GETDATE())  
	END  
	ELSE IF @Mode=1  
	BEGIN  
		UPDATE tblTaskUserFiles  
		SET 
			Attachment=@Attachment  
		WHERE TaskUpdateID = @TaskUpDateId
	END  
	ELSE IF @Mode=2 --DELETE  
	BEGIN  
		UPDATE tblTaskUserFiles  
		SET 
			IsDeleted =1  
		WHERE TaskUpdateID = @TaskUpDateId 
	END  
  
END  
GO


--=======================================================================================================================================================================================================

-- Published on Live 19 Dec 2016

--=======================================================================================================================================================================================================

/****** Object:  StoredProcedure [dbo].[SP_SaveOrDeleteTaskUserFiles]    Script Date: 20-Dec-16 9:46:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_SaveOrDeleteTaskUserFiles]  
(   
	@Mode tinyint, -- 0:Insert, 1: Update 2: Delete  
	@TaskUpDateId bigint= NULL,  
	@TaskId bigint,  
	@FileDestination TINYINT = NULL,
	@UserId int,  
	@Attachment varchar(MAX),
	@OriginalFileName varchar(MAX),
	@UserType BIT,
    @FileType varchar(5)
) 
AS  
BEGIN  
  
	IF @Mode=0 
	BEGIN  

		/* Generate an image name starts */

		DECLARE @ParentTaskId BIGINT = NULL
		DECLARE @NextId VARCHAR(5)
		DECLARE @Initial VARCHAR(5) = '-FILE'
		DECLARE @Extension VARCHAR(5)

		SELECT @ParentTaskId = t.ParentTaskId
		FROM tblTask t
		WHERE t.TaskId = @TaskId

		SELECT @NextId = RIGHT('000'+CAST((COUNT(*) + 1) AS VARCHAR),3)
		FROM tblTaskUserFiles t
		WHERE 
			  t.TaskId = ISNULL(@ParentTaskId, @TaskId) OR
			  t.TaskId IN (SELECT TaskId FROM tblTask WHERE ParentTaskId = ISNULL(@ParentTaskId, @TaskId))

		SET @Extension = '.' + REVERSE(SUBSTRING(REVERSE(@OriginalFileName),0,CHARINDEX('.',REVERSE(@OriginalFileName))))

		IF @Extension = '.png' OR
			@Extension = '.jpg' OR
			@Extension = '.jpeg'
		BEGIN
			SET @Initial = '-IMG'
		END

		SELECT @OriginalFileName = 
						ISNULL(
								CAST(t.InstallId AS VARCHAR), 
								'TASK' + CAST(t.TaskId AS VARCHAR)
							  ) 
						+ @Initial
						+ @NextId
						+ @Extension
		FROM tblTask t
		WHERE t.TaskId = ISNULL(@ParentTaskId, @TaskId)

		/* Generate an image name ends */
		
		INSERT INTO tblTaskUserFiles (TaskId,UserId,Attachment,TaskUpdateID,IsDeleted, AttachmentOriginal, UserType,FileDestination, FileType, AttachedFileDate)   
		VALUES(@TaskId,@UserId,@Attachment,@TaskUpDateId,0, @OriginalFileName, @UserType,@FileDestination, @FileType ,GETDATE())  
	END  
	ELSE IF @Mode=1  
	BEGIN  
		UPDATE tblTaskUserFiles  
		SET 
			Attachment=@Attachment  
		WHERE TaskUpdateID = @TaskUpDateId
	END  
	ELSE IF @Mode=2 --DELETE  
	BEGIN  
		UPDATE tblTaskUserFiles  
		SET 
			IsDeleted =1  
		WHERE TaskUpdateID = @TaskUpDateId 
	END  
  
END  
GO


UPDATE tblTaskUserFiles
SET 
[AttachedFileDate] = UpdatedOn
WHERE [AttachedFileDate] IS NULL


/****** Object:  View [dbo].[TaskListView]    Script Date: 20-Dec-16 8:26:36 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[TaskListView] 
AS
SELECT 
	Tasks.*,
	STUFF
	(
		(SELECT  CAST(', ' + td.Designation as VARCHAR) AS Designation
		FROM tblTaskDesignations td
		WHERE td.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskDesignations,
	STUFF
	(
		(SELECT  CAST(', ' + u.FristName + ' ' + u.LastName as VARCHAR) AS Name
		FROM tblTaskAssignedUsers tu
			INNER JOIN tblInstallUsers u ON tu.UserId = u.Id
		WHERE tu.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskAssignedUsers,
	STUFF
	(
		(SELECT  ',' + CAST(tu.UserId as VARCHAR) AS Id
		FROM tblTaskAssignedUsers tu
		WHERE tu.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,1
		,''
	) AS TaskAssignedUserIds,
	STUFF
	(
		(SELECT  CAST(', ' + CAST(tu.UserId AS VARCHAR) + ':' + u.FristName as VARCHAR) AS Name
		FROM tblTaskAssignmentRequests tu
			INNER JOIN tblInstallUsers u ON tu.UserId = u.Id
		WHERE tu.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskAssignmentRequestUsers,
	STUFF
	(
		(SELECT  ', ' + CAST(tu.UserId AS VARCHAR) AS UserId
		FROM tblTaskAcceptance tu
		WHERE tu.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskAcceptanceUsers,
	STUFF
	(
		(SELECT  CAST(
						', ' + CAST(tuf.[Id] AS VARCHAR) + 
						'@' + tuf.[Attachment] + 
						'@' + tuf.[AttachmentOriginal]  + 
						'@' + CAST( tuf.[AttachedFileDate] AS VARCHAR(100)) + 
						'@' + (
								CASE 
									WHEN ctuser.Id IS NULL THEN 'N.A.' 
									ELSE ISNULL(ctuser.FirstName,'') + ' ' + ISNULL(ctuser.LastName ,'')
								END
							) as VARCHAR(max)) AS attachment
		FROM dbo.tblTaskUserFiles tuf  
			OUTER APPLY
			(
				SELECT TOP 1 iu.Id,iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
				FROM tblInstallUsers iu
				WHERE iu.Id = tuf.UserId
			
				UNION

				SELECT TOP 1 u.Id,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email
				FROM tblUsers u
				WHERE u.Id = tuf.UserId
			) AS ctuser
		WHERE tuf.TaskId = Tasks.TaskId AND tuf.IsDeleted <> 1
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskUserFiles
FROM          
	tblTask AS Tasks 
GO

--=======================================================================================================================================================================================================

-- Published on Live 21 Dec 2016

--=======================================================================================================================================================================================================


ALTER table tblTask
ADD IsUiRequested BIT DEFAULT 0
GO

Update tblTask
Set
	IsUiRequested = 0


/****** Object:  StoredProcedure [dbo].[UpdateTaskUiRequestedById]    Script Date: 22-Dec-16 10:48:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 14 Nov 16
-- Description:	Updates ui requested status of sub Task by Id.
-- =============================================
CREATE PROCEDURE [dbo].[UpdateTaskUiRequestedById]
	@TaskId		BIGINT,
	@IsUiRequested BIT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE tblTask
	SET
		IsUiRequested = @IsUiRequested
	WHERE TaskId = @TaskId
END
GO



/****** Object:  View [dbo].[TaskListView]    Script Date: 22-Dec-16 9:28:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[TaskListView] 
AS
SELECT 
	Tasks.*,
	--AdminUser.Id AS AdminUserId,
	AdminUser.InstallId AS AdminUserInstallId,
	AdminUser.Username AS AdminUsername,
	AdminUser.FirstName AS AdminUserFirstName,
	AdminUser.LastName AS AdminUserLastName,
	AdminUser.Email AS AdminUserEmail,
			
	--TechLeadUser.Id AS TechLeadUserId,
	TechLeadUser.InstallId AS TechLeadUserInstallId,
	TechLeadUser.Username AS TechLeadUsername,
	TechLeadUser.FirstName AS TechLeadUserFirstName,
	TechLeadUser.LastName AS TechLeadUserLastName,
	TechLeadUser.Email AS TechLeadUserEmail,

	--OtherUser.Id AS OtherUserId,
	OtherUser.InstallId AS OtherUserInstallId,
	OtherUser.Username AS OtherUsername,
	OtherUser.FirstName AS OtherUserFirstName,
	OtherUser.LastName AS OtherUserLastName,
	OtherUser.Email AS OtherUserEmail,
	STUFF
	(
		(SELECT  CAST(', ' + td.Designation as VARCHAR) AS Designation
		FROM tblTaskDesignations td
		WHERE td.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskDesignations,
	STUFF
	(
		(SELECT  CAST(', ' + u.FristName + ' ' + u.LastName as VARCHAR) AS Name
		FROM tblTaskAssignedUsers tu
			INNER JOIN tblInstallUsers u ON tu.UserId = u.Id
		WHERE tu.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskAssignedUsers,
	STUFF
	(
		(SELECT  ',' + CAST(tu.UserId as VARCHAR) AS Id
		FROM tblTaskAssignedUsers tu
		WHERE tu.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,1
		,''
	) AS TaskAssignedUserIds,
	STUFF
	(
		(SELECT  CAST(', ' + CAST(tu.UserId AS VARCHAR) + ':' + u.FristName as VARCHAR) AS Name
		FROM tblTaskAssignmentRequests tu
			INNER JOIN tblInstallUsers u ON tu.UserId = u.Id
		WHERE tu.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskAssignmentRequestUsers,
	STUFF
	(
		(SELECT  ', ' + CAST(tu.UserId AS VARCHAR) AS UserId
		FROM tblTaskAcceptance tu
		WHERE tu.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskAcceptanceUsers,
	STUFF
	(
		(SELECT  CAST(
						', ' + CAST(tuf.[Id] AS VARCHAR) + 
						'@' + tuf.[Attachment] + 
						'@' + tuf.[AttachmentOriginal]  + 
						'@' + CAST( tuf.[AttachedFileDate] AS VARCHAR(100)) + 
						'@' + (
								CASE 
									WHEN ctuser.Id IS NULL THEN 'N.A.' 
									ELSE ISNULL(ctuser.FirstName,'') + ' ' + ISNULL(ctuser.LastName ,'')
								END
							) as VARCHAR(max)) AS attachment
		FROM dbo.tblTaskUserFiles tuf  
			OUTER APPLY
			(
				SELECT TOP 1 iu.Id, iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
				FROM tblInstallUsers iu
				WHERE iu.Id = tuf.UserId
			
				UNION

				SELECT TOP 1 u.Id,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email
				FROM tblUsers u
				WHERE u.Id = tuf.UserId
			) AS ctuser
		WHERE tuf.TaskId = Tasks.TaskId AND tuf.IsDeleted <> 1
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskUserFiles
FROM          
	tblTask AS Tasks 
		OUTER APPLY
		(
			SELECT TOP 1 iu.Id, iu.InstallId ,iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
			FROM tblInstallUsers iu
			WHERE iu.Id = Tasks.AdminUserId AND Tasks.IsAdminInstallUser = 1
			
			UNION

			SELECT TOP 1 u.Id, '' AS InstallId ,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email
			FROM tblUsers u
			WHERE u.Id = Tasks.AdminUserId AND Tasks.IsAdminInstallUser = 0
		) AS AdminUser
		OUTER APPLY
		(
			SELECT TOP 1 iu.Id, iu.InstallId ,iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
			FROM tblInstallUsers iu
			WHERE iu.Id = Tasks.TechLeadUserId AND Tasks.IsTechLeadInstallUser = 1
			
			UNION

			SELECT TOP 1 u.Id, '' AS InstallId ,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email
			FROM tblUsers u
			WHERE u.Id = Tasks.TechLeadUserId AND Tasks.IsTechLeadInstallUser = 0
		) AS TechLeadUser
		OUTER APPLY
		(
			SELECT TOP 1 iu.Id, iu.InstallId ,iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
			FROM tblInstallUsers iu
			WHERE iu.Id = Tasks.OtherUserId AND Tasks.IsOtherUserInstallUser = 1
			
			UNION

			SELECT TOP 1 u.Id, '' AS InstallId ,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email
			FROM tblUsers u
			WHERE u.Id = Tasks.OtherUserId AND Tasks.IsOtherUserInstallUser = 0
		) AS OtherUser

GO

/****** Object:  StoredProcedure [dbo].[usp_GetSubTasks]    Script Date: 23-Dec-16 8:57:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 04/07/2016
-- Description:	Load all sub tasks of a task.
-- =============================================
-- usp_GetSubTasks 115, 1, 'Description DESC'
ALTER PROCEDURE [dbo].[usp_GetSubTasks] 
(
	@TaskId INT,
	@Admin BIT,
	@SortExpression	VARCHAR(250) = 'CreatedOn DESC',
	@OpenStatus		TINYINT = 1,
    @RequestedStatus	TINYINT = 2,
    @AssignedStatus	TINYINT = 3,
    @InProgressStatus	TINYINT = 4,
    @PendingStatus	TINYINT = 5,
    @ReOpenedStatus	TINYINT = 6,
    @ClosedStatus	TINYINT = 7,
    @SpecsInProgressStatus	TINYINT = 8,
    @DeletedStatus	TINYINT = 9
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	;WITH 
	
	Tasklist AS
	(	
		SELECT
			Tasks.*,
			(SELECT EstimatedHours 
				FROM [TaskApprovalsView] TaskApprovals 
				WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 1) AS AdminOrITLeadEstimatedHours,
			(SELECT EstimatedHours 
				FROM [TaskApprovalsView] TaskApprovals 
				WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 0) AS UserEstimatedHours,
			Row_number() OVER
			(
				ORDER BY
					CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
					CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
					CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
					CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
					CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
					CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
					CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
					CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
					CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
					CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
					CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.StatusOrder END ASC,
					CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.StatusOrder END DESC,
					CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
					CASE WHEN @SortExpression = 'CreatedOn ASC' THEN Tasks.CreatedOn END ASC
			) AS RowNo_Order
		FROM
			(
				SELECT 
					Tasks.*,
					CASE Tasks.[Status]
						WHEN @AssignedStatus THEN 1
						WHEN @RequestedStatus THEN 1

						WHEN @InProgressStatus THEN 2
						WHEN @PendingStatus THEN 2
						WHEN @ReOpenedStatus THEN 2

						WHEN @OpenStatus THEN 
							CASE 
								WHEN ISNULL([TaskPriority],'') <> '' THEN 3
								ELSE 4
							END

						WHEN @SpecsInProgressStatus THEN 4

						WHEN @ClosedStatus THEN 5

						WHEN @DeletedStatus THEN 6

						ELSE 7

					END AS StatusOrder,
					TaskApprovals.Id AS TaskApprovalId,
					TaskApprovals.EstimatedHours AS TaskApprovalEstimatedHours,
					TaskApprovals.Description AS TaskApprovalDescription,
					TaskApprovals.UserId AS TaskApprovalUserId,
					TaskApprovals.IsInstallUser AS TaskApprovalIsInstallUser
				FROM 
					[TaskListView] Tasks 
						LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin
				WHERE
					Tasks.ParentTaskId = @TaskId
			) Tasks
	)
	
	-- get records
	SELECT * 
	FROM Tasklist 
	ORDER BY RowNo_Order

END
GO

/****** Object:  StoredProcedure [dbo].[usp_GetSubTasks]    Script Date: 23-Dec-16 8:57:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 04/07/2016
-- Description:	Load all sub tasks of a task.
-- =============================================
-- usp_GetSubTasks 115, 1, 'Description DESC'
ALTER PROCEDURE [dbo].[usp_GetSubTasks] 
(
	@TaskId INT,
	@Admin BIT,
	@SortExpression	VARCHAR(250) = 'CreatedOn DESC',
	@OpenStatus		TINYINT = 1,
    @RequestedStatus	TINYINT = 2,
    @AssignedStatus	TINYINT = 3,
    @InProgressStatus	TINYINT = 4,
    @PendingStatus	TINYINT = 5,
    @ReOpenedStatus	TINYINT = 6,
    @ClosedStatus	TINYINT = 7,
    @SpecsInProgressStatus	TINYINT = 8,
    @DeletedStatus	TINYINT = 9
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	;WITH 
	
	Tasklist AS
	(	
		SELECT
			Tasks.*,
			(SELECT TOP 1 EstimatedHours 
				FROM [TaskApprovalsView] TaskApprovals 
				WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 1) AS AdminOrITLeadEstimatedHours,
			(SELECT TOP 1 EstimatedHours 
				FROM [TaskApprovalsView] TaskApprovals 
				WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 0) AS UserEstimatedHours,
			Row_number() OVER
			(
				ORDER BY
					CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
					CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
					CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
					CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
					CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
					CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
					CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
					CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
					CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
					CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
					CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.StatusOrder END ASC,
					CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.StatusOrder END DESC,
					CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
					CASE WHEN @SortExpression = 'CreatedOn ASC' THEN Tasks.CreatedOn END ASC
			) AS RowNo_Order
		FROM
			(
				SELECT 
					Tasks.*,
					CASE Tasks.[Status]
						WHEN @AssignedStatus THEN 1
						WHEN @RequestedStatus THEN 1

						WHEN @InProgressStatus THEN 2
						WHEN @PendingStatus THEN 2
						WHEN @ReOpenedStatus THEN 2

						WHEN @OpenStatus THEN 
							CASE 
								WHEN ISNULL([TaskPriority],'') <> '' THEN 3
								ELSE 4
							END

						WHEN @SpecsInProgressStatus THEN 4

						WHEN @ClosedStatus THEN 5

						WHEN @DeletedStatus THEN 6

						ELSE 7

					END AS StatusOrder,
					TaskApprovals.Id AS TaskApprovalId,
					TaskApprovals.EstimatedHours AS TaskApprovalEstimatedHours,
					TaskApprovals.Description AS TaskApprovalDescription,
					TaskApprovals.UserId AS TaskApprovalUserId,
					TaskApprovals.IsInstallUser AS TaskApprovalIsInstallUser
				FROM 
					[TaskListView] Tasks 
						LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin
				WHERE
					Tasks.ParentTaskId = @TaskId
			) Tasks
	)
	
	-- get records
	SELECT * 
	FROM Tasklist 
	ORDER BY RowNo_Order

END
GO


/****** Object:  StoredProcedure [dbo].[usp_InsertTaskDesignations]    Script Date: 26-Dec-16 8:29:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 07152016
-- Description:	Will insert assigned designations for given task
-- =============================================

ALTER PROCEDURE [dbo].[usp_InsertTaskDesignations] 
(
	@TaskId int ,
	@Designations varchar(4000) ,
	@TaskIDCode varchar(5)
)	
AS
BEGIN

	DECLARE @InstallId VARCHAR(50) = NULL

	SELECT @InstallId = InstallId
	FROM tblTask
	WHERE TaskId = @TaskId

	IF @InstallId IS NULL
	BEGIN
		-- get sequence of last entered task for perticular designation.
		DECLARE @DesSequence bigint

		SELECT @DesSequence = ttds.LastSequenceNo FROM dbo.tblTaskDesignationSequence ttds WHERE ttds.DesignationCode = @TaskIDCode

		-- if it is first time task is entered for designation start from 001.
		IF(@DesSequence IS NULL)
		BEGIN
			SET @DesSequence = 0  
		END

		SET @DesSequence = @DesSequence + 1  

		UPDATE tblTask
			SET InstallId = @TaskIDCode + Right('00' + CONVERT(NVARCHAR, @DesSequence), 3)
		WHERE TaskId=@TaskId

		-- INCREMENT SEQUENCE NUMBER FOR DESIGNATION TO USE NEXT TIME
		IF NOT EXISTS( 
						SELECT ttds.TaskDesigSequenceId 
						FROM dbo.tblTaskDesignationSequence ttds 
						WHERE ttds.DesignationCode = @TaskIDCode 
					 )
		BEGIN
			INSERT INTO dbo.tblTaskDesignationSequence
			(
    
				DesignationCode,
				LastSequenceNo
			)
			VALUES
			(
				@TaskIDCode,
				@DesSequence
			) 
		END
		ELSE		
		BEGIN
			UPDATE dbo.tblTaskDesignationSequence
			SET
				dbo.tblTaskDesignationSequence.LastSequenceNo = @DesSequence
			WHERE dbo.tblTaskDesignationSequence.DesignationCode = @TaskIDCode 
		END
	END

	-- REMOVE ALREADY ADDED DESIGNATIONS IF ANY
	DELETE FROM tblTaskDesignations
	WHERE  (TaskId = @TaskId)

	-- insert comma seperated multiple designations for given task.
	INSERT INTO tblTaskDesignations (TaskId, Designation,DesignationID)
	SELECT @TaskId , (Select top 1 DesignationName From tbl_Designation Where ID=item), item 
	FROM dbo.SplitString(@Designations,',') ss 

	--*********** SUB TASK DESIGNATIONS ****************--
	-- REMOVE ALREADY ADDED DESIGNATIONS IF ANY, FOR ALL SUB TASKS
	DELETE FROM tblTaskDesignations
	WHERE TaskId IN (Select TaskId 
						FROM tblTask 
						WHERE ParentTaskId = @TaskId)

	-- insert comma seperated multiple designations for sub tasks of given task.
	INSERT INTO tblTaskDesignations (TaskId, Designation,DesignationID)
	SELECT st.TaskId , (Select top 1 DesignationName From tbl_Designation Where ID=item), item 
	FROM dbo.SplitString(@Designations,',') ss, tblTask st
	WHERE st.ParentTaskId = @TaskId

END
GO

--=======================================================================================================================================================================================================

-- Published on Live 22 Dec 2016

--=======================================================================================================================================================================================================

/****** Object:  StoredProcedure [dbo].[sp_GetHrData]    Script Date: 06-Jan-17 12:20:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Updated By :	  Bhavik J. Vaishnani
-- Updated date:  21-12-2016
-- =============================================
--
ALTER PROCEDURE [dbo].[sp_GetHrData]
	@UserId int,
	@FromDate date = null,
	@ToDate date = null
AS
BEGIN
	
	SET NOCOUNT ON;

	IF @FromDate  IS NOT NULL AND @ToDate IS NOT NULL
	BEGIN
		IF(@UserId<>0)
		BEGIN
			SELECT 
				t.status,count(*)cnt 
			FROM 
				tblInstallUsers t 
					LEFT OUTER JOIN tblInstallUsers U ON U.Id = t.SourceUser
					
			WHERE 
				(t.UserType = 'SalesUser' OR t.UserType = 'sales') 
					AND U.Id=@UserId 
					AND CAST(t.CreatedDateTime as date) >= CAST( @FromDate  as date) 
					AND CAST(t.CreatedDateTime  as date) <= CAST( @ToDate  as date)
			GROUP BY t.status
		END
	ELSE 
		BEGIN
			SELECT 
				t.status,count(*)cnt 
			FROM 
				tblInstallUsers t 	
			WHERE 
				(t.UserType = 'SalesUser' OR t.UserType = 'sales')
					AND CAST(t.CreatedDateTime as date) >= CAST( @FromDate  as date) 
					AND CAST(t.CreatedDateTime  as date) <= CAST( @ToDate  as date)
			GROUP BY t.status
		END
	
	
	IF(@UserId<>0)
		Begin
			SELECT 
				t.Id,t.FristName,t.LastName,t.Phone,t.Zip,t.Designation,t.Status,t.HireDate,t.InstallId,t.picture, t.CreatedDateTime, Isnull(t.Source,'') AS Source,
				t.SourceUser, ISNULL(t.FristName +' '+ t.LastName,'')  AS 'AddedBy' , ISNULL (t.UserInstallId ,t.id) As UserInstallId , 
				InterviewDetail = case when (t.Status='InterviewDate' or t.Status='Interview Date') then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.InterviewTime,'') else '' end,
				RejectDetail = case when (t.Status='Rejected' ) then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.RejectionTime,'') + ' ' + '-' + coalesce(ru.LastName,'') else '' end,
				t.Email, t.DesignationID, t1.[UserInstallId] As AddedByUserInstallId, t1.Id As AddedById
				, mcq.[Aggregate] , t.EmpType, dbo.Fn_GetUserPrimaryOrDefaultPhone(t.Id) As PrimaryPhone, t.CountryCode, t.Resumepath
				--ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId
				,Task.TechTaskId, Task.TechTaskInstallId
			FROM 
				tblInstallUsers t 
					LEFT OUTER JOIN tblInstallUsers U ON U.Id = t.SourceUser
					LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId=ru.Id
					LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= t.Id	  
					LEFT OUTER JOIN MCQ_Performance mcq on mcq.UserID = t.Id	
					OUTER APPLY
					(
					SELECT tsk.TaskId AS TechTaskId, tsk.InstallId AS TechTaskInstallId
					FROM tblTask tsk 
							INNER JOIN tblTaskAssignedUsers tu ON tsk.TaskId = tu.TaskId
						WHERE tu.UserId = t.Id AND tsk.IsTechTask = 1
					) AS Task			
			WHERE 
				(t.UserType = 'SalesUser' OR t.UserType = 'sales') 
					AND t.Status <> 'Deactive' 
					AND t.Id=@UserId 
					AND CAST(t.CreatedDateTime as date) >= CAST( @FromDate  as date) 
					AND CAST (t.CreatedDateTime  as date) <= CAST( @ToDate  as date)
			ORDER BY Id DESC
		END
	Else
		BEGIN
			SELECT 
				t.Id,t.FristName,t.LastName,t.Phone,t.Zip,t.Designation,t.Status,t.HireDate,t.InstallId,t.picture, t.CreatedDateTime, Isnull(t.Source,'') AS Source,
				t.SourceUser, ISNULL(U.FristName + ' ' + U.LastName,'')  AS 'AddedBy' , ISNULL (t.UserInstallId ,t.id) As UserInstallId,	
				InterviewDetail = case when (t.Status='InterviewDate' or t.Status='Interview Date') 
				then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.InterviewTime,'') else '' end,
				RejectDetail = case when (t.Status='Rejected' ) then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.RejectionTime,'') + ' ' + '-' + coalesce(ru.LastName,'') else '' end,
				t.Email, t.DesignationID, t1.[UserInstallId] As AddedByUserInstallId, t1.Id As AddedById
				, mcq.[Aggregate], t.EmpType, dbo.Fn_GetUserPrimaryOrDefaultPhone(t.Id) As PrimaryPhone, t.CountryCode, t.Resumepath
				--ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId
				,Task.TechTaskId, Task.TechTaskInstallId
			FROM 
				tblInstallUsers t 
					LEFT OUTER JOIN tblInstallUsers U ON U.Id = t.SourceUser
					LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId=ru.Id
					LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
					LEFT OUTER JOIN MCQ_Performance mcq on mcq.UserID = t.Id	
					OUTER APPLY
					(
					SELECT tsk.TaskId AS TechTaskId, tsk.InstallId AS TechTaskInstallId
					FROM tblTask tsk 
							INNER JOIN tblTaskAssignedUsers tu ON tsk.TaskId = tu.TaskId
						WHERE tu.UserId = t.Id AND tsk.IsTechTask = 1
					) AS Task			
			WHERE 
				(t.UserType = 'SalesUser' OR t.UserType = 'sales') 
					AND t.Status <> 'Deactive' 
					AND CAST(t.CreatedDateTime as date) >= CAST( @FromDate  as date) 
					ANd CAST(t.CreatedDateTime  as date) <= CAST( @ToDate  as date)
			ORDER BY Id DESC
		END
	END
	ELSE
	BEGIN 
		IF(@UserId<>0)
		BEGIN
			SELECT 
				t.status,count(*)cnt 
			FROM 
				tblInstallUsers t 
					LEFT OUTER JOIN tblInstallUsers U ON U.Id = t.SourceUser	
			WHERE 
				(t.UserType = 'SalesUser' OR t.UserType = 'sales') 
					AND U.Id=@UserId 
			GROUP BY t.status
		END
	ELSE 
		BEGIN
			SELECT 
				t.status,count(*)cnt 
			FROM 
				tblInstallUsers t 	
					 
			WHERE 
				(t.UserType = 'SalesUser' OR t.UserType = 'sales')
			GROUP BY t.status
		END
	
	
	IF(@UserId<>0)
		Begin
			SELECT 
				t.Id,t.FristName,t.LastName,t.Phone,t.Zip,t.Designation,t.Status,t.HireDate,t.InstallId,t.picture, t.CreatedDateTime, Isnull(t.Source,'') AS Source,
				t.SourceUser, ISNULL(U.FristName + ' ' + U.LastName,'')  AS 'AddedBy' , ISNULL (t.UserInstallId ,t.id) As UserInstallId , 
				InterviewDetail = case when (t.Status='InterviewDate' or t.Status='Interview Date') then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.InterviewTime,'') else '' end,
				RejectDetail = case when (t.Status='Rejected' ) then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.RejectionTime,'') + ' ' + '-' + coalesce(ru.LastName,'') else '' end,
				t.Email, t.DesignationID, t1.[UserInstallId] As AddedByUserInstallId, t1.Id As AddedById 
				, mcq.[Aggregate], t.EmpType, dbo.Fn_GetUserPrimaryOrDefaultPhone(t.Id) As PrimaryPhone, t.CountryCode, t.Resumepath
				--ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId
				,Task.TechTaskId, Task.TechTaskInstallId
			FROM 
				tblInstallUsers t 
					LEFT OUTER JOIN tblInstallUsers U ON U.Id = t.SourceUser
					LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId=ru.Id
					LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
					LEFT OUTER JOIN MCQ_Performance mcq on mcq.UserID = t.Id	
					OUTER APPLY
					(
					SELECT tsk.TaskId AS TechTaskId, tsk.InstallId AS TechTaskInstallId
					FROM tblTask tsk 
							INNER JOIN tblTaskAssignedUsers tu ON tsk.TaskId = tu.TaskId
						WHERE tu.UserId = t.Id AND tsk.IsTechTask = 1
					) AS Task			
			WHERE 
				(t.UserType = 'SalesUser' OR t.UserType = 'sales') 
					AND t.Status <> 'Deactive' 
					AND U.Id=@UserId 
			ORDER BY Id DESC
		END
	Else
		BEGIN
			SELECT 
				t.Id,t.FristName,t.LastName,t.Phone,t.Zip,t.Designation,t.Status,t.HireDate,t.InstallId,t.picture, t.CreatedDateTime, Isnull(t.Source,'') AS Source,
				t.SourceUser, ISNULL(U.FristName + ' ' + U.LastName,'')  AS 'AddedBy' , ISNULL (t.UserInstallId ,t.id) As UserInstallId,	
				InterviewDetail = case when (t.Status='InterviewDate' or t.Status='Interview Date') 
				then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.InterviewTime,'') else '' end,
				RejectDetail = case when (t.Status='Rejected' ) then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.RejectionTime,'') + ' ' + '-' + coalesce(ru.LastName,'') else '' end,
				t.Email, t.DesignationID, t1.[UserInstallId] As AddedByUserInstallId, t1.Id As AddedById 
				, mcq.[Aggregate], t.EmpType, dbo.Fn_GetUserPrimaryOrDefaultPhone(t.Id) As PrimaryPhone, t.CountryCode, t.Resumepath
				--ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId
				,Task.TechTaskId, Task.TechTaskInstallId
			FROM 
				tblInstallUsers t 
					LEFT OUTER JOIN tblInstallUsers U ON U.Id = t.SourceUser
					LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId=ru.Id
					LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id
					LEFT OUTER JOIN MCQ_Performance mcq on mcq.UserID = t.Id		
					OUTER APPLY
					(
					SELECT tsk.TaskId AS TechTaskId, tsk.InstallId AS TechTaskInstallId
					FROM tblTask tsk 
							INNER JOIN tblTaskAssignedUsers tu ON tsk.TaskId = tu.TaskId
						WHERE tu.UserId = t.Id AND tsk.IsTechTask = 1
					) AS Task					
			WHERE 
				(t.UserType = 'SalesUser' OR t.UserType = 'sales') 
					AND t.Status <> 'Deactive' 
			ORDER BY Id DESC
		END
	END

 
END
GO



/****** Object:  StoredProcedure [dbo].[GetAllEditSalesUser]    Script Date: 06-Jan-17 11:35:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Updated By :		Bhavik J. Vaishnani
-- Updated date: 22-12-2016
-- =============================================
--exec [GetAllEditSalesUser]
ALTER PROCEDURE [dbo].[GetAllEditSalesUser]
	-- Add the parameters for the stored procedure here
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT  
		t.Id,t.FristName,t.LastName,t.Phone,t.Zip,t.Designation,t.Status,t.HireDate,t.InstallId,t.picture, t.CreatedDateTime, Isnull(t.Source,'') AS Source,
		t.SourceUser, ISNULL(t.FristName +' '+ t.LastName,'')  AS AddedBy, U.Id As AddeBy_UserID , ISNULL (t.UserInstallId ,t.id) As UserInstallId ,
		InterviewDetail = case when (t.Status='InterviewDate' or t.Status='Interview Date') then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.InterviewTime,'') else '' end,
		RejectDetail = case when (t.Status='Rejected' ) then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.RejectionTime,'') + ' ' + '-' + coalesce(ru.LastName,'') else '' end,
		t.Email, t1.[UserInstallId] As AddedByUserInstallId
		, t1.Id As AddedById, mcq.[Aggregate] , t.EmpType , dbo.Fn_GetUserPrimaryOrDefaultPhone(t.Id) As PrimaryPhone, t.CountryCode, t.Resumepath
		--ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId
		,Task.TechTaskId, Task.TechTaskInstallId
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblInstallUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id
			LEFT OUTER JOIN MCQ_Performance mcq on mcq.UserID = t.Id
			OUTER APPLY
			(
			SELECT tsk.TaskId AS TechTaskId, tsk.InstallId AS TechTaskInstallId
			FROM tblTask tsk 
					INNER JOIN tblTaskAssignedUsers tu ON tsk.TaskId = tu.TaskId
				WHERE tu.UserId = t.Id AND tsk.IsTechTask = 1
			) AS Task
	WHERE 
		(t.UserType = 'SalesUser' OR t.UserType = 'sales') 
			AND t.Status <> 'Deactive' 
	ORDER BY Id DESC
	
 
END
GO


INSERT INTO [dbo].[tblSubHTMLTemplates]
           ([HTMLTemplateID]
           ,[SubHTMLName]
           ,[HTMLSubject]
           ,[HTMLHeader]
           ,[HTMLBody]
           ,[HTMLFooter]
           ,[Updated_On])
     SELECT
           110
           ,SubHTMLName
           ,HTMLSubject
           ,HTMLHeader
           ,HTMLBody
           ,HTMLFooter
           ,GETDATE()
	FROM tblSubHtmlTemplates
	WHERE HTMLTemplateID = 104
GO


--=======================================================================================================================================================================================================
-- Email Template
--=======================================================================================================================================================================================================


/****** Object:  Table [dbo].[tblHTMLTemplatesMater]    Script Date: 11-Jan-17 10:18:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[tblHTMLTemplatesMater](
	[Id] [int] PRIMARY KEY,
	[Name] [varchar](50) NOT NULL,
	[Subject] [varchar](4000) NOT NULL,
	[Header] [nvarchar](max) NOT NULL,
	[Body] [nvarchar](max) NOT NULL,
	[Footer] [nvarchar](max) NOT NULL,
	[DateUpdated] [date] NOT NULL
)
GO
SET ANSI_PADDING OFF
GO


/****** Object:  Table [dbo].[tblHTMLTemplates]    Script Date: 11-Jan-17 10:18:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[tblDesignationHTMLTemplates](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY,
	[HTMLTemplatesMaterId] [int] REFERENCES [tblHTMLTemplatesMater],
	[Designation] VARCHAR(50) NOT NULL,
	[Subject] [varchar](4000) NOT NULL,
	[Header] [nvarchar](max) NOT NULL,
	[Body] [nvarchar](max) NOT NULL,
	[Footer] [nvarchar](max) NOT NULL,
	[DateUpdated] [date] NOT NULL
)
GO
SET ANSI_PADDING OFF
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 11 Jan 2017
-- Description:	Gets all HTMLTemplates
-- =============================================
CREATE PROCEDURE GetHTMLTemplates
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT *
	FROM
		(
			SELECT 
					 0 As IsMaster
					,[Id]
					,[HTMLTemplatesMaterId]
					,[Subject]
					,[Header]
					,[Body]
					,[Footer]
					,[DateUpdated]
			FROM tblDesignationHTMLTemplates

			UNION ALL

			SELECT 
					 1 As IsMaster
					,0 AS [Id]
					,[Id] AS HTMLTemplatesMaterId
					,[Subject]
					,[Header]
					,[Body]
					,[Footer]
					,[DateUpdated]
			FROM tblHTMLTemplatesMater 
			WHERE Id NOT IN (SELECT HTMLTemplatesMaterId FROM tblDesignationHTMLTemplates)

		) AS HTMLTemplates
	ORDER BY HTMLTemplates.IsMaster DESC

END
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 11 Jan 2017
-- Description:	Gets a HTMLTemplate.
-- =============================================
CREATE PROCEDURE GetDesignationHTMLTemplate
	@Id	INT,
	@Designation VARCHAR(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT TOP 1 *
	FROM
		(
			SELECT 
					 0 As IsMaster
					,[Id]
					,[HTMLTemplatesMaterId]
					,[Subject]
					,[Header]
					,[Body]
					,[Footer]
					,[DateUpdated]
			FROM tblDesignationHTMLTemplates
			WHERE 
				HTMLTemplatesMaterId = @Id AND
				Designation = ISNULL(@Designation,Designation)

			UNION

			SELECT 
					 1 As IsMaster
					,0 AS Id
					,[Id] AS HTMLTemplatesMaterId
					,[Subject]
					,[Header]
					,[Body]
					,[Footer]
					,[DateUpdated]
			FROM tblHTMLTemplatesMater 
			WHERE Id = @Id

		) AS HTMLTemplates

END
GO


/****** Object:  StoredProcedure [dbo].[sp_GetHrData]    Script Date: 16-Jan-17 8:59:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 16 Jan 2017
-- Description:	Gets statictics and records for edit user page.
-- =============================================
ALTER PROCEDURE [dbo].[sp_GetHrData]
	@Status VARCHAR(50),
	@Designation VARCHAR(50),
	@Source VARCHAR(50),
	@AddedByUserId int,
	@UserId int,
	@FromDate date = null,
	@ToDate date = null,
	@PageIndex INT = NULL, 
	@PageSize INT = NULL
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF @Status = '0'
	BEGIN
		SET @Status = NULL
	END

	IF @Designation = '0'
	BEGIN
		SET @Designation = NULL
	END
	
	IF @Source = '0'
	BEGIN
		SET @Source = NULL
	END

	IF @AddedByUserId = 0
	BEGIN
		SET @AddedByUserId = NULL
	END

	-- get counts
	SELECT 
		t.status,count(*)cnt 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id	  
	WHERE 
		(t.UserType = 'SalesUser' OR t.UserType = 'sales') 
			AND t.Designation = ISNULL(@Designation, t.Designation)
			AND t.Source = ISNULL(@Source, t.Source)
			AND U.Id=ISNULL(@AddedByUserId,U.Id)
			AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
			AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY t.status

	DECLARE @StartIndex INT  = 0

	IF @PageIndex IS NULL
	BEGIN
		SET @PageIndex = 0
	END

	IF @PageSize IS NULL
	BEGIN
		SET @PageSize = 0
	END

	SET @StartIndex = (@PageIndex * @PageSize) + 1

	;WITH Users
	AS 
	(
		-- get records
		SELECT 
			t.Id,t.FristName,t.LastName,t.Phone,t.Zip,t.Designation,t.Status,t.HireDate,t.InstallId,t.picture, t.CreatedDateTime, Isnull(t.Source,'') AS Source,
			t.SourceUser, ISNULL(U.Username,'')  AS AddedBy , ISNULL (t.UserInstallId ,t.id) As UserInstallId , 
			InterviewDetail = case when (t.Status='InterviewDate' or t.Status='Interview Date') then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.InterviewTime,'') else '' end,
			RejectDetail = case when (t.Status='Rejected' ) then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.RejectionTime,'') + ' ' + '-' + coalesce(ru.LastName,'') else '' end,
			t.Email, t.DesignationID, t1.[UserInstallId] As AddedByUserInstallId, t1.Id As AddedById , 0 as 'EmpType'
			,NULL as [Aggregate] ,t.Phone As PrimaryPhone , NULL as 'CountryCode', t.Resumepath
			--ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId
			,NULL as 'TechTaskId', NULL as 'TechTaskInstallId',
			ROW_NUMBER() OVER(ORDER BY t.Id DESC) AS RowNumber
		FROM 
			tblInstallUsers t 
				LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
				LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
				LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
		WHERE 
			(t.UserType = 'SalesUser' OR t.UserType = 'sales')
				AND t.Status = ISNULL(@Status, t.Status)
				AND t.Designation = ISNULL(@Designation, t.Designation)
				AND t.Source = ISNULL(@Source, t.Source)
				AND U.Id=ISNULL(@AddedByUserId,U.Id)
				AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
				AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	)

	-- get records
	SELECT *
	FROM Users
	WHERE 
		RowNumber >= @StartIndex AND 
		(
			@PageSize = 0 OR 
			RowNumber < (@StartIndex + @PageSize)
		)

	-- get record count
	SELECT COUNT(*) AS TotalRecordCount
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
	WHERE 
		(t.UserType = 'SalesUser' OR t.UserType = 'sales') 
			AND t.Status <> 'Deactive' 
			AND U.Id=ISNULL(@AddedByUserId,U.Id)
			AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
			AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
END
GO


/****** Object:  StoredProcedure [dbo].[sp_GetHrData]    Script Date: 16-Jan-17 8:59:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 16 Jan 2017
-- Description:	Gets statictics and records for edit user page.
-- =============================================
-- [sp_GetHrData] '0','0','0', '0', NULL,NULL,0,10
ALTER PROCEDURE [dbo].[sp_GetHrData]
	@Status VARCHAR(50),
	@Designation VARCHAR(50),
	@Source VARCHAR(50),
	@AddedByUserId int,
	@FromDate date = null,
	@ToDate date = null,
	@PageIndex INT = NULL, 
	@PageSize INT = NULL
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF @Status = '0'
	BEGIN
		SET @Status = NULL
	END

	IF @Designation = '0'
	BEGIN
		SET @Designation = NULL
	END
	
	IF @Source = '0'
	BEGIN
		SET @Source = NULL
	END

	IF @AddedByUserId = 0
	BEGIN
		SET @AddedByUserId = NULL
	END

	DECLARE @StartIndex INT  = 0

	IF @PageIndex IS NULL
	BEGIN
		SET @PageIndex = 0
	END

	IF @PageSize IS NULL
	BEGIN
		SET @PageSize = 0
	END

	SET @StartIndex = (@PageIndex * @PageSize) + 1

	-- get statistics
	SELECT 
		t.status,count(*)cnt 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id	  
	WHERE 
		(t.UserType = 'SalesUser' OR t.UserType = 'sales') 
		AND ISNULL(t.Designation,'') = ISNULL(NULL, ISNULL(t.Designation,''))
		AND ISNULL(t.Source,'') = ISNULL(NULL, ISNULL(t.Source,''))
		AND ISNULL(U.Id,'')=ISNULL(NULL,ISNULL(U.Id,''))
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(NULL,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(NULL,t.CreatedDateTime) as date)

	GROUP BY t.status
	
	-- get records
	;WITH SalesUsers
	AS 
	(
		SELECT 
			t.Id,t.FristName,t.LastName,t.Phone,t.Zip,t.Designation,t.Status,t.HireDate,t.InstallId,t.picture, t.CreatedDateTime, Isnull(t.Source,'') AS Source,
			t.SourceUser, ISNULL(U.Username,'')  AS AddedBy , ISNULL (t.UserInstallId ,t.id) As UserInstallId , 
			InterviewDetail = case when (t.Status='InterviewDate' or t.Status='Interview Date') then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.InterviewTime,'') else '' end,
			RejectDetail = case when (t.Status='Rejected' ) then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.RejectionTime,'') + ' ' + '-' + coalesce(ru.LastName,'') else '' end,
			t.Email, t.DesignationID, t1.[UserInstallId] As AddedByUserInstallId, t1.Id As AddedById , 0 as 'EmpType'
			,NULL as [Aggregate] ,t.Phone As PrimaryPhone , NULL as 'CountryCode', t.Resumepath
			--ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId
			,NULL as 'TechTaskId', NULL as 'TechTaskInstallId',
			ROW_NUMBER() OVER(ORDER BY t.Id DESC) AS RowNumber
		FROM 
			tblInstallUsers t 
				LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
				LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
				LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
		WHERE 
			(t.UserType = 'SalesUser' OR t.UserType = 'sales')
			AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))
			AND ISNULL(t.Designation,'') = ISNULL(NULL, ISNULL(t.Designation,''))
			AND ISNULL(t.Source,'') = ISNULL(NULL, ISNULL(t.Source,''))
			AND ISNULL(U.Id,'')=ISNULL(NULL,ISNULL(U.Id,''))
			AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(NULL,t.CreatedDateTime) as date) 
			AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(NULL,t.CreatedDateTime) as date)
	)

	SELECT *
	FROM SalesUsers
	WHERE 
		RowNumber >= @StartIndex AND 
		(
			@PageSize = 0 OR 
			RowNumber < (@StartIndex + @PageSize)
		)

	-- get record count
	SELECT COUNT(*) AS TotalRecordCount
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))
		AND ISNULL(t.Designation,'') = ISNULL(NULL, ISNULL(t.Designation,''))
		AND ISNULL(t.Source,'') = ISNULL(NULL, ISNULL(t.Source,''))
		AND ISNULL(U.Id,'')=ISNULL(NULL,ISNULL(U.Id,''))
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(NULL,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(NULL,t.CreatedDateTime) as date)
END
GO

/****** Object:  StoredProcedure [dbo].[sp_GetHrData]    Script Date: 17-Jan-17 12:37:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 16 Jan 2017
-- Description:	Gets statictics and records for edit user page.
-- =============================================
-- [sp_GetHrData] '0','0','0', '0', NULL,NULL,0,10
ALTER PROCEDURE [dbo].[sp_GetHrData]
	@Status VARCHAR(50),
	@Designation VARCHAR(50),
	@Source VARCHAR(50),
	@AddedByUserId int,
	@FromDate date = null,
	@ToDate date = null,
	@PageIndex INT = NULL, 
	@PageSize INT = NULL,
	@SortExpression VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF @Status = '0'
	BEGIN
		SET @Status = NULL
	END

	IF @Designation = '0'
	BEGIN
		SET @Designation = NULL
	END
	
	IF @Source = '0'
	BEGIN
		SET @Source = NULL
	END

	IF @AddedByUserId = 0
	BEGIN
		SET @AddedByUserId = NULL
	END

	DECLARE @StartIndex INT  = 0

	IF @PageIndex IS NULL
	BEGIN
		SET @PageIndex = 0
	END

	IF @PageSize IS NULL
	BEGIN
		SET @PageSize = 0
	END

	SET @StartIndex = (@PageIndex * @PageSize) + 1

	-- get statistics
	SELECT 
		t.Status, count(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id	  
	WHERE 
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND ISNULL(t.Designation,'') = ISNULL(@Designation, ISNULL(t.Designation,''))
		AND ISNULL(t.Source,'') = ISNULL(@Source, ISNULL(t.Source,''))
		AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY t.status
	
	-- get records
	;WITH SalesUsers
	AS 
	(
		SELECT 
			t.Id,t.FristName,t.LastName,t.Phone,t.Zip,t.Designation,t.Status,t.HireDate,t.InstallId,t.picture, t.CreatedDateTime, Isnull(t.Source,'') AS Source,
			t.SourceUser, ISNULL(U.Username,'')  AS AddedBy , ISNULL (t.UserInstallId ,t.id) As UserInstallId , 
			InterviewDetail = case when (t.Status='InterviewDate' or t.Status='Interview Date') then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.InterviewTime,'') else '' end,
			RejectDetail = case when (t.Status='Rejected' ) then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.RejectionTime,'') + ' ' + '-' + coalesce(ru.LastName,'') else '' end,
			t.Email, t.DesignationID, t1.[UserInstallId] As AddedByUserInstallId, t1.Id As AddedById , 0 as 'EmpType'
			,NULL as [Aggregate] ,t.Phone As PrimaryPhone , NULL as 'CountryCode', t.Resumepath
			--ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId
			,NULL as 'TechTaskId', NULL as 'TechTaskInstallId',
			ROW_NUMBER() OVER
							(
								ORDER BY
									CASE WHEN @SortExpression = 'Id ASC' THEN t.Id END ASC,
									CASE WHEN @SortExpression = 'Id DESC' THEN t.Id END DESC,
									CASE WHEN @SortExpression = 'Status ASC' THEN t.Status END ASC,
									CASE WHEN @SortExpression = 'Status DESC' THEN t.Status END DESC,
									CASE WHEN @SortExpression = 'FristName ASC' THEN t.FristName END ASC,
									CASE WHEN @SortExpression = 'FristName DESC' THEN t.FristName END DESC,
									CASE WHEN @SortExpression = 'Designation ASC' THEN t.Designation END ASC,
									CASE WHEN @SortExpression = 'Designation DESC' THEN t.Designation END DESC,
									CASE WHEN @SortExpression = 'Source ASC' THEN t.Source END ASC,
									CASE WHEN @SortExpression = 'Source DESC' THEN t.Source END DESC,
									CASE WHEN @SortExpression = 'Phone ASC' THEN t.Phone END ASC,
									CASE WHEN @SortExpression = 'Phone DESC' THEN t.Phone END DESC,
									CASE WHEN @SortExpression = 'Zip ASC' THEN t.Phone END ASC,
									CASE WHEN @SortExpression = 'Zip DESC' THEN t.Phone END DESC
								
							) AS RowNumber
		FROM 
			tblInstallUsers t 
				LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
				LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
				LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
		WHERE 
			(t.UserType = 'SalesUser' OR t.UserType = 'sales')
			AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))
			AND ISNULL(t.Designation,'') = ISNULL(@Designation, ISNULL(t.Designation,''))
			AND ISNULL(t.Source,'') = ISNULL(@Source, ISNULL(t.Source,''))
			AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))
			AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
			AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	)

	SELECT *
	FROM SalesUsers
	WHERE 
		RowNumber >= @StartIndex AND 
		(
			@PageSize = 0 OR 
			RowNumber < (@StartIndex + @PageSize)
		)

	-- get record count
	SELECT COUNT(*) AS TotalRecordCount
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))
		AND ISNULL(t.Designation,'') = ISNULL(@Designation, ISNULL(t.Designation,''))
		AND ISNULL(t.Source,'') = ISNULL(@Source, ISNULL(t.Source,''))
		AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
END
GO



/****** Object:  StoredProcedure [dbo].[sp_GetHrData]    Script Date: 17-Jan-17 12:37:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 16 Jan 2017
-- Description:	Gets statictics and records for edit user page.
-- =============================================
-- [sp_GetHrData] '0','0','0', '0', NULL,NULL,0,10
ALTER PROCEDURE [dbo].[sp_GetHrData]
	@Status VARCHAR(50),
	@Designation VARCHAR(50),
	@Source VARCHAR(50),
	@AddedByUserId int,
	@FromDate date = null,
	@ToDate date = null,
	@PageIndex INT = NULL, 
	@PageSize INT = NULL,
	@SortExpression VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF @Status = '0'
	BEGIN
		SET @Status = NULL
	END

	IF @Designation = '0'
	BEGIN
		SET @Designation = NULL
	END
	
	IF @Source = '0'
	BEGIN
		SET @Source = NULL
	END

	IF @AddedByUserId = 0
	BEGIN
		SET @AddedByUserId = NULL
	END

	DECLARE @StartIndex INT  = 0

	IF @PageIndex IS NULL
	BEGIN
		SET @PageIndex = 0
	END

	IF @PageSize IS NULL
	BEGIN
		SET @PageSize = 0
	END

	SET @StartIndex = (@PageIndex * @PageSize) + 1

	-- get statistics (Status)
	SELECT 
		t.Status, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id	  
	WHERE 
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND ISNULL(t.Designation,'') = ISNULL(@Designation, ISNULL(t.Designation,''))
		AND ISNULL(t.Source,'') = ISNULL(@Source, ISNULL(t.Source,''))
		AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY t.status
	
	-- get statistics (AddedBy)
	SELECT 
		ISNULL(U.Username,'')  AS AddedBy, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY U.Username

	-- get statistics (Designation)
	SELECT 
		t.Designation, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY t.Designation
	
	-- get statistics (Source)
	SELECT 
		t.Source, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY t.Source

	-- get records
	;WITH SalesUsers
	AS 
	(
		SELECT 
			t.Id,t.FristName,t.LastName,t.Phone,t.Zip,t.Designation,t.Status,t.HireDate,t.InstallId,t.picture, t.CreatedDateTime, Isnull(t.Source,'') AS Source,
			t.SourceUser, ISNULL(U.Username,'')  AS AddedBy , ISNULL (t.UserInstallId ,t.id) As UserInstallId , 
			InterviewDetail = case when (t.Status='InterviewDate' or t.Status='Interview Date') then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.InterviewTime,'') else '' end,
			RejectDetail = case when (t.Status='Rejected' ) then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.RejectionTime,'') + ' ' + '-' + coalesce(ru.LastName,'') else '' end,
			t.Email, t.DesignationID, t1.[UserInstallId] As AddedByUserInstallId, t1.Id As AddedById , 0 as 'EmpType'
			,NULL as [Aggregate] ,t.Phone As PrimaryPhone , NULL as 'CountryCode', t.Resumepath
			--ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId
			,NULL as 'TechTaskId', NULL as 'TechTaskInstallId',
			ROW_NUMBER() OVER
							(
								ORDER BY
									CASE WHEN @SortExpression = 'Id ASC' THEN t.Id END ASC,
									CASE WHEN @SortExpression = 'Id DESC' THEN t.Id END DESC,
									CASE WHEN @SortExpression = 'Status ASC' THEN t.Status END ASC,
									CASE WHEN @SortExpression = 'Status DESC' THEN t.Status END DESC,
									CASE WHEN @SortExpression = 'FristName ASC' THEN t.FristName END ASC,
									CASE WHEN @SortExpression = 'FristName DESC' THEN t.FristName END DESC,
									CASE WHEN @SortExpression = 'Designation ASC' THEN t.Designation END ASC,
									CASE WHEN @SortExpression = 'Designation DESC' THEN t.Designation END DESC,
									CASE WHEN @SortExpression = 'Source ASC' THEN t.Source END ASC,
									CASE WHEN @SortExpression = 'Source DESC' THEN t.Source END DESC,
									CASE WHEN @SortExpression = 'Phone ASC' THEN t.Phone END ASC,
									CASE WHEN @SortExpression = 'Phone DESC' THEN t.Phone END DESC,
									CASE WHEN @SortExpression = 'Zip ASC' THEN t.Phone END ASC,
									CASE WHEN @SortExpression = 'Zip DESC' THEN t.Phone END DESC
								
							) AS RowNumber
		FROM 
			tblInstallUsers t 
				LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
				LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
				LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
		WHERE 
			(t.UserType = 'SalesUser' OR t.UserType = 'sales')
			AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))
			AND ISNULL(t.Designation,'') = ISNULL(@Designation, ISNULL(t.Designation,''))
			AND ISNULL(t.Source,'') = ISNULL(@Source, ISNULL(t.Source,''))
			AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))
			AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
			AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	)

	SELECT *
	FROM SalesUsers
	WHERE 
		RowNumber >= @StartIndex AND 
		(
			@PageSize = 0 OR 
			RowNumber < (@StartIndex + @PageSize)
		)

	-- get record count
	SELECT COUNT(*) AS TotalRecordCount
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))
		AND ISNULL(t.Designation,'') = ISNULL(@Designation, ISNULL(t.Designation,''))
		AND ISNULL(t.Source,'') = ISNULL(@Source, ISNULL(t.Source,''))
		AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
END
GO

/****** Object:  StoredProcedure [dbo].[sp_GetHrData]    Script Date: 17-Jan-17 12:37:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 16 Jan 2017
-- Description:	Gets statictics and records for edit user page.
-- =============================================
-- [sp_GetHrData] '0','0','0', '0', NULL,NULL,0,10
ALTER PROCEDURE [dbo].[sp_GetHrData]
	@Status VARCHAR(50),
	@DesignationId INT,
	@SourceId INT,
	@AddedByUserId INT,
	@FromDate DATE = NULL,
	@ToDate DATE = NULL,
	@PageIndex INT = NULL, 
	@PageSize INT = NULL,
	@SortExpression VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF @Status = '0'
	BEGIN
		SET @Status = NULL
	END

	IF @DesignationId = '0'
	BEGIN
		SET @DesignationId = NULL
	END
	
	IF @SourceId = '0'
	BEGIN
		SET @SourceId = NULL
	END

	IF @AddedByUserId = 0
	BEGIN
		SET @AddedByUserId = NULL
	END

	DECLARE @StartIndex INT  = 0

	IF @PageIndex IS NULL
	BEGIN
		SET @PageIndex = 0
	END

	IF @PageSize IS NULL
	BEGIN
		SET @PageSize = 0
	END

	SET @StartIndex = (@PageIndex * @PageSize) + 1

	-- get statistics (Status)
	SELECT 
		t.Status, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id	
	WHERE 
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY t.status
	
	-- get statistics (AddedBy)
	SELECT 
		ISNULL(U.Username,'')  AS AddedBy, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY U.Username

	-- get statistics (Designation)
	SELECT 
		t.Designation, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY t.Designation
	
	-- get statistics (Source)
	SELECT 
		t.Source, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY t.Source

	-- get records
	;WITH SalesUsers
	AS 
	(
		SELECT 
			t.Id,t.FristName,t.LastName,t.Phone,t.Zip,d.DesignationName AS Designation,t.Status,t.HireDate,t.InstallId,t.picture, t.CreatedDateTime, Isnull(s.Source,'') AS Source,
			t.SourceUser, ISNULL(U.Username,'')  AS AddedBy , ISNULL (t.UserInstallId ,t.id) As UserInstallId , 
			InterviewDetail = case when (t.Status='InterviewDate' or t.Status='Interview Date') then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.InterviewTime,'') else '' end,
			RejectDetail = case when (t.Status='Rejected' ) then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.RejectionTime,'') + ' ' + '-' + coalesce(ru.LastName,'') else '' end,
			t.Email, t.DesignationID, t1.[UserInstallId] As AddedByUserInstallId, t1.Id As AddedById , 0 as 'EmpType'
			,NULL as [Aggregate] ,t.Phone As PrimaryPhone , NULL as 'CountryCode', t.Resumepath
			--ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId
			,NULL as 'TechTaskId', NULL as 'TechTaskInstallId',
			ROW_NUMBER() OVER
							(
								ORDER BY
									CASE WHEN @SortExpression = 'Id ASC' THEN t.Id END ASC,
									CASE WHEN @SortExpression = 'Id DESC' THEN t.Id END DESC,
									CASE WHEN @SortExpression = 'Status ASC' THEN t.Status END ASC,
									CASE WHEN @SortExpression = 'Status DESC' THEN t.Status END DESC,
									CASE WHEN @SortExpression = 'FristName ASC' THEN t.FristName END ASC,
									CASE WHEN @SortExpression = 'FristName DESC' THEN t.FristName END DESC,
									CASE WHEN @SortExpression = 'Designation ASC' THEN d.DesignationName END ASC,
									CASE WHEN @SortExpression = 'Designation DESC' THEN d.DesignationName END DESC,
									CASE WHEN @SortExpression = 'Source ASC' THEN s.Source END ASC,
									CASE WHEN @SortExpression = 'Source DESC' THEN s.Source END DESC,
									CASE WHEN @SortExpression = 'Phone ASC' THEN t.Phone END ASC,
									CASE WHEN @SortExpression = 'Phone DESC' THEN t.Phone END DESC,
									CASE WHEN @SortExpression = 'Zip ASC' THEN t.Phone END ASC,
									CASE WHEN @SortExpression = 'Zip DESC' THEN t.Phone END DESC
								
							) AS RowNumber
		FROM 
			tblInstallUsers t 
				LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
				LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
				LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
				LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id  
				LEFT JOIN tblSource s ON t.SourceId = s.Id
		WHERE 
			(t.UserType = 'SalesUser' OR t.UserType = 'sales')
			AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))
			AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))
			AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))
			AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))
			AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
			AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	)

	SELECT *
	FROM SalesUsers
	WHERE 
		RowNumber >= @StartIndex AND 
		(
			@PageSize = 0 OR 
			RowNumber < (@StartIndex + @PageSize)
		)

	-- get record count
	SELECT COUNT(*) AS TotalRecordCount
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id		  
			LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id    
			LEFT JOIN tblSource s ON t.SourceId = s.Id
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))
		AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))
		AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))
		AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
END
GO

/****** Object:  StoredProcedure [dbo].[GetSalesUserAutoSuggestion]    Script Date: 19-Jan-17 7:42:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 01/19/2017
-- Description:	Load auto search suggestions for search term in edit user page.
-- =============================================
-- GetSalesUserAutoSuggestion 'IT'
CREATE PROCEDURE [dbo].[GetSalesUserAutoSuggestion] 
	@SearchTerm varchar(15) 	  
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	; WITH Suggestion (label,Category)
	AS
	(
	
	   SELECT TOP 3 t.InstallId AS AutoSuggest , 'Id#' AS Category 
	   FROM dbo.tblInstallUsers t 
	   WHERE 
			(t.UserType = 'SalesUser' OR t.UserType = 'sales')
			AND t.InstallId LIKE '%'+ @SearchTerm + '%'   

	   UNION

	   SELECT DISTINCT TOP 3 t.FristName AS AutoSuggest , 'FirstName' AS Category 
	   FROM dbo.tblInstallUsers t 
	   WHERE 
			(t.UserType = 'SalesUser' OR t.UserType = 'sales')
			AND t.FristName LIKE '%'+ @SearchTerm + '%'   

	   UNION

	   SELECT DISTINCT TOP 3 t.LastName AS AutoSuggest , 'LastName' AS Category 
	   FROM dbo.tblInstallUsers t 
	   WHERE 
			(t.UserType = 'SalesUser' OR t.UserType = 'sales')
			AND t.LastName LIKE '%'+ @SearchTerm + '%'

	   UNION

	   SELECT DISTINCT TOP 3 t.Email AS AutoSuggest, 'Email' AS Category 
	   from dbo.tblInstallUsers t
	   WHERE 
			(t.UserType = 'SalesUser' OR t.UserType = 'sales')
			AND t.Email LIKE '%' + @SearchTerm +'%'
   
	   UNION
	   
	   SELECT DISTINCT TOP 3 t.Phone AS AutoSuggest, 'Phone' AS Category 
	   from dbo.tblInstallUsers t
	   WHERE 
			(t.UserType = 'SalesUser' OR t.UserType = 'sales')
			AND t.Phone LIKE '%' + @SearchTerm +'%'
   
	   UNION

	   SELECT DISTINCT TOP 3 t.CountryCode AS AutoSuggest , 'CountryCode' AS Category 
	   FROM dbo.tblInstallUsers t
	   WHERE 
			(t.UserType = 'SalesUser' OR t.UserType = 'sales')
			AND t.CountryCode LIKE '%' + @SearchTerm + '%'

	   UNION

	   SELECT DISTINCT TOP 3 t.Zip AS AutoSuggest , 'Zip' AS Category 
	   FROM dbo.tblInstallUsers t
	   WHERE 
			(t.UserType = 'SalesUser' OR t.UserType = 'sales')
			AND t.Zip LIKE '%' + @SearchTerm + '%'

	)

	SELECT * FROM Suggestion s ORDER BY s.Category DESC, s.label

END
GO


/****** Object:  StoredProcedure [dbo].[sp_GetHrData]    Script Date: 17-Jan-17 12:37:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 16 Jan 2017
-- Description:	Gets statictics and records for edit user page.
-- =============================================
-- [sp_GetHrData] '0','0','0', '0', NULL,NULL,0,10
ALTER PROCEDURE [dbo].[sp_GetHrData]
	@SearchTerm VARCHAR(15) = NULL,
	@Status VARCHAR(50),
	@DesignationId INT,
	@SourceId INT,
	@AddedByUserId INT,
	@FromDate DATE = NULL,
	@ToDate DATE = NULL,
	@PageIndex INT = NULL, 
	@PageSize INT = NULL,
	@SortExpression VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF @Status = '0'
	BEGIN
		SET @Status = NULL
	END

	IF @DesignationId = '0'
	BEGIN
		SET @DesignationId = NULL
	END
	
	IF @SourceId = '0'
	BEGIN
		SET @SourceId = NULL
	END

	IF @AddedByUserId = 0
	BEGIN
		SET @AddedByUserId = NULL
	END

	DECLARE @StartIndex INT  = 0

	IF @PageIndex IS NULL
	BEGIN
		SET @PageIndex = 0
	END

	IF @PageSize IS NULL
	BEGIN
		SET @PageSize = 0
	END

	SET @StartIndex = (@PageIndex * @PageSize) + 1

	-- get statistics (Status)
	SELECT 
		t.Status, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id	
	WHERE 
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY t.status
	
	-- get statistics (AddedBy)
	SELECT 
		ISNULL(U.Username,'')  AS AddedBy, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY U.Username

	-- get statistics (Designation)
	SELECT 
		t.Designation, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY t.Designation
	
	-- get statistics (Source)
	SELECT 
		t.Source, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY t.Source

	-- get records
	;WITH SalesUsers
	AS 
	(
		SELECT 
			t.Id,t.FristName,t.LastName,t.Phone,t.Zip,d.DesignationName AS Designation,t.Status,t.HireDate,t.InstallId,t.picture, t.CreatedDateTime, Isnull(s.Source,'') AS Source,
			t.SourceUser, ISNULL(U.Username,'')  AS AddedBy , ISNULL (t.UserInstallId ,t.id) As UserInstallId , 
			InterviewDetail = case when (t.Status='InterviewDate' or t.Status='Interview Date') then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.InterviewTime,'') else '' end,
			RejectDetail = case when (t.Status='Rejected' ) then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.RejectionTime,'') + ' ' + '-' + coalesce(ru.LastName,'') else '' end,
			t.Email, t.DesignationID, t1.[UserInstallId] As AddedByUserInstallId, t1.Id As AddedById , 0 as 'EmpType'
			,NULL as [Aggregate] ,t.Phone As PrimaryPhone , NULL as 'CountryCode', t.Resumepath
			--ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId
			,NULL as 'TechTaskId', NULL as 'TechTaskInstallId',
			ROW_NUMBER() OVER
							(
								ORDER BY
									CASE WHEN @SortExpression = 'Id ASC' THEN t.Id END ASC,
									CASE WHEN @SortExpression = 'Id DESC' THEN t.Id END DESC,
									CASE WHEN @SortExpression = 'Status ASC' THEN t.Status END ASC,
									CASE WHEN @SortExpression = 'Status DESC' THEN t.Status END DESC,
									CASE WHEN @SortExpression = 'FristName ASC' THEN t.FristName END ASC,
									CASE WHEN @SortExpression = 'FristName DESC' THEN t.FristName END DESC,
									CASE WHEN @SortExpression = 'Designation ASC' THEN d.DesignationName END ASC,
									CASE WHEN @SortExpression = 'Designation DESC' THEN d.DesignationName END DESC,
									CASE WHEN @SortExpression = 'Source ASC' THEN s.Source END ASC,
									CASE WHEN @SortExpression = 'Source DESC' THEN s.Source END DESC,
									CASE WHEN @SortExpression = 'Phone ASC' THEN t.Phone END ASC,
									CASE WHEN @SortExpression = 'Phone DESC' THEN t.Phone END DESC,
									CASE WHEN @SortExpression = 'Zip ASC' THEN t.Phone END ASC,
									CASE WHEN @SortExpression = 'Zip DESC' THEN t.Phone END DESC
								
							) AS RowNumber
		FROM 
			tblInstallUsers t 
				LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
				LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
				LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
				LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id  
				LEFT JOIN tblSource s ON t.SourceId = s.Id
		WHERE 
			(t.UserType = 'SalesUser' OR t.UserType = 'sales')
			AND 1 = CASE
						WHEN t.InstallId LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.FristName LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.LastName LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.Email LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.Phone LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.Zip LIKE '%'+ @SearchTerm + '%' THEN 1
						ELSE 0
					END
			AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))
			AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))
			AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))
			AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))
			AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
			AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	)

	SELECT *
	FROM SalesUsers
	WHERE 
		RowNumber >= @StartIndex AND 
		(
			@PageSize = 0 OR 
			RowNumber < (@StartIndex + @PageSize)
		)

	-- get record count
	SELECT COUNT(*) AS TotalRecordCount
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id		  
			LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id    
			LEFT JOIN tblSource s ON t.SourceId = s.Id
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND 1 = CASE
					WHEN t.InstallId LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.FristName LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.LastName LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.Email LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.Phone LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.Zip LIKE '%'+ @SearchTerm + '%' THEN 1
					ELSE 0
				END
		AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))
		AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))
		AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))
		AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
END
GO

-- Create the data type
CREATE TYPE IDs AS TABLE 
(
	Id BIGINT NOT NULL
)
GO

/****** Object:  StoredProcedure [dbo].[DeleteInstallUsers]    Script Date: 19-Jan-17 9:55:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 19 Jan 2017
-- Description:	Deletes / deactivates install users.
-- =============================================
CREATE PROCEDURE [dbo].[DeleteInstallUsers]
	@IDs IDs READONLY
AS
BEGIN
	
	UPDATE dbo.tblInstallUsers 
	SET 
		[STATUS] = 'Deactive' 
	WHERE Id IN (SELECT Id FROM @IDs)
	
	/*DELETE 
	FROM dbo.tblInstallUsers 
	WHERE Id=@id*/
       
 END
GO


--=================================================================================================================================================================================================

-- Published on live 22012016 

--=================================================================================================================================================================================================


/****** Object:  StoredProcedure [dbo].[sp_GetHrData]    Script Date: 17-Jan-17 12:37:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 16 Jan 2017
-- Description:	Gets statictics and records for edit user page.
-- =============================================
-- [sp_GetHrData] '0','0','0', '0', NULL,NULL,0,10
ALTER PROCEDURE [dbo].[sp_GetHrData]
	@SearchTerm VARCHAR(15) = NULL,
	@Status VARCHAR(50),
	@DesignationId INT,
	@SourceId INT,
	@AddedByUserId INT,
	@FromDate DATE = NULL,
	@ToDate DATE = NULL,
	@PageIndex INT = NULL, 
	@PageSize INT = NULL,
	@SortExpression VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF @Status = '0'
	BEGIN
		SET @Status = NULL
	END

	IF @DesignationId = '0'
	BEGIN
		SET @DesignationId = NULL
	END
	
	IF @SourceId = '0'
	BEGIN
		SET @SourceId = NULL
	END

	IF @AddedByUserId = 0
	BEGIN
		SET @AddedByUserId = NULL
	END

	DECLARE @StartIndex INT  = 0

	IF @PageIndex IS NULL
	BEGIN
		SET @PageIndex = 0
	END

	IF @PageSize IS NULL
	BEGIN
		SET @PageSize = 0
	END

	SET @StartIndex = (@PageIndex * @PageSize) + 1

	-- get statistics (Status)
	SELECT 
		t.Status, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id	
	WHERE 
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY t.status
	
	-- get statistics (AddedBy)
	SELECT 
		ISNULL(U.Username,'')  AS AddedBy, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY U.Username

	-- get statistics (Designation)
	SELECT 
		t.Designation, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY t.Designation
	
	-- get statistics (Source)
	SELECT 
		t.Source, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY t.Source

	-- get records
	;WITH SalesUsers
	AS 
	(
		SELECT 
			t.Id,t.FristName,t.LastName,t.Phone,t.Zip,d.DesignationName AS Designation,t.Status,t.HireDate,t.InstallId,t.picture, t.CreatedDateTime, Isnull(s.Source,'') AS Source,
			t.SourceUser, ISNULL(U.Username,'')  AS AddedBy , ISNULL (t.UserInstallId ,t.id) As UserInstallId , 
			InterviewDetail = case when (t.Status='InterviewDate' or t.Status='Interview Date') then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.InterviewTime,'') else '' end,
			RejectDetail = case when (t.Status='Rejected' ) then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.RejectionTime,'') + ' ' + '-' + coalesce(ru.LastName,'') else '' end,
			t.Email, t.DesignationID, t1.[UserInstallId] As AddedByUserInstallId, t1.Id As AddedById , 0 as 'EmpType'
			,NULL as [Aggregate] ,t.Phone As PrimaryPhone , NULL as 'CountryCode', t.Resumepath
			--ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId
			,NULL as 'TechTaskId', NULL as 'TechTaskInstallId',
			ROW_NUMBER() OVER
							(
								ORDER BY
									CASE WHEN @SortExpression = 'Id ASC' THEN t.Id END ASC,
									CASE WHEN @SortExpression = 'Id DESC' THEN t.Id END DESC,
									CASE WHEN @SortExpression = 'Status ASC' THEN t.Status END ASC,
									CASE WHEN @SortExpression = 'Status DESC' THEN t.Status END DESC,
									CASE WHEN @SortExpression = 'FristName ASC' THEN t.FristName END ASC,
									CASE WHEN @SortExpression = 'FristName DESC' THEN t.FristName END DESC,
									CASE WHEN @SortExpression = 'Designation ASC' THEN d.DesignationName END ASC,
									CASE WHEN @SortExpression = 'Designation DESC' THEN d.DesignationName END DESC,
									CASE WHEN @SortExpression = 'Source ASC' THEN s.Source END ASC,
									CASE WHEN @SortExpression = 'Source DESC' THEN s.Source END DESC,
									CASE WHEN @SortExpression = 'Phone ASC' THEN t.Phone END ASC,
									CASE WHEN @SortExpression = 'Phone DESC' THEN t.Phone END DESC,
									CASE WHEN @SortExpression = 'Zip ASC' THEN t.Phone END ASC,
									CASE WHEN @SortExpression = 'Zip DESC' THEN t.Phone END DESC
								
							) AS RowNumber
		FROM 
			tblInstallUsers t 
				LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
				LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
				LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
				LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id  
				LEFT JOIN tblSource s ON t.SourceId = s.Id
		WHERE 
			(t.UserType = 'SalesUser' OR t.UserType = 'sales')
			AND 
			(
				@SearchTerm IS NULL OR 
				1 = CASE
						WHEN t.InstallId LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.FristName LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.LastName LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.Email LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.Phone LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.Zip LIKE '%'+ @SearchTerm + '%' THEN 1
						ELSE 0
					END
			)
			AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))
			AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))
			AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))
			AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))
			AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
			AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	)

	SELECT *
	FROM SalesUsers
	WHERE 
		RowNumber >= @StartIndex AND 
		(
			@PageSize = 0 OR 
			RowNumber < (@StartIndex + @PageSize)
		)

	-- get record count
	SELECT COUNT(*) AS TotalRecordCount
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id		  
			LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id    
			LEFT JOIN tblSource s ON t.SourceId = s.Id
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND 
		(
			@SearchTerm IS NULL OR 
			1 = CASE
					WHEN t.InstallId LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.FristName LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.LastName LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.Email LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.Phone LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.Zip LIKE '%'+ @SearchTerm + '%' THEN 1
					ELSE 0
				END
		)
		AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))
		AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))
		AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))
		AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
END
GO



/****** Object:  Table [dbo].[tblHTMLTemplatesMaster]    Script Date: 11-Jan-17 10:18:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[tblHTMLTemplatesMaster](
	[Id] [int] PRIMARY KEY,
	[Name] [varchar](50) NOT NULL,
	[Subject] [varchar](4000) NOT NULL,
	[Header] [nvarchar](max) NOT NULL,
	[Body] [nvarchar](max) NOT NULL,
	[Footer] [nvarchar](max) NOT NULL,
	[DateUpdated] [date] NOT NULL
)
GO
SET ANSI_PADDING OFF
GO

INSERT INTO [tblHTMLTemplatesMaster]
(
	[Id]
	,[Name]
	,[Subject]
	,[Header]
	,[Body]
	,[Footer]
	,[DateUpdated]
)
SELECT *
FROM [tblHTMLTemplatesMater]
GO


ALTER TABLE tblDesignationHTMLTemplates
ADD HTMLTemplatesMasterId INT NOT NULL REFERENCES tblHTMLTemplatesMaster
GO

UPDATE tblDesignationHTMLTemplates
SET HTMLTemplatesMasterId = HTMLTemplatesMaterId
GO

ALTER TABLE tblDesignationHTMLTemplates
DROP FK__tblDesign__HTMLT__0D45C3B3
GO
ALTER TABLE tblDesignationHTMLTemplates
DROP COLUMN HTMLTemplatesMaterId
GO

DROP TABLE tblHTMLTemplatesMater
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 11 Jan 2017
-- Description:	Gets all HTMLTemplates
-- =============================================
ALTER PROCEDURE GetHTMLTemplates
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT *
	FROM
		(
			SELECT 
					[Id]
					,[Name]
					,[Subject]
					,[Header]
					,[Body]
					,[Footer]
					,[DateUpdated]
			FROM tblHTMLTemplatesMaster 

		) AS HTMLTemplates
	ORDER BY HTMLTemplates.IsMaster DESC

END
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 11 Jan 2017
-- Description:	Gets a HTMLTemplate.
-- =============================================
ALTER PROCEDURE GetDesignationHTMLTemplate
	@Id	INT,
	@Designation VARCHAR(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT TOP 1 *
	FROM
		(
			SELECT 
					 0 As IsMaster
					,[Id]
					,[HTMLTemplatesMasterId]
					,[Subject]
					,[Header]
					,[Body]
					,[Footer]
					,[DateUpdated]
			FROM tblDesignationHTMLTemplates
			WHERE 
				HTMLTemplatesMasterId = @Id AND
				Designation = ISNULL(@Designation,Designation)

			UNION

			SELECT 
					 1 As IsMaster
					,0 AS Id
					,[Id] AS HTMLTemplatesMasterId
					,[Subject]
					,[Header]
					,[Body]
					,[Footer]
					,[DateUpdated]
			FROM tblHTMLTemplatesMaster 
			WHERE Id = @Id

		) AS HTMLTemplates

END
GO


DROP PROCEDURE GetHTMLTemplates
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 27 Jan 2017
-- Description:	Gets all Master HTMLTemplates.
-- =============================================
CREATE PROCEDURE GetHTMLTemplateMasters
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT 
			[Id]
			,[Name]
			,[Subject]
			,[Header]
			,[Body]
			,[Footer]
			,[DateUpdated]
	FROM tblHTMLTemplatesMaster 
	ORDER BY Id ASC

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 27 Jan 2017
-- Description:	Gets a Master HTMLTemplate.
-- =============================================
CREATE PROCEDURE GetHTMLTemplateMasterById
	@Id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT 
			[Id]
			,[Name]
			,[Subject]
			,[Header]
			,[Body]
			,[Footer]
			,[DateUpdated]
	FROM tblHTMLTemplatesMaster 
	WHERE Id = @Id

END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 27 Jan 2017
-- Description:	Saves designation HTMLTemplate either inserts or updates.
-- =============================================
CREATE PROCEDURE SaveDesignationHTMLTemplate
	@HTMLTemplatesMasterId	INT,
	@Designation			VARCHAR(50),
	@Subject				VARCHAR(4000),
	@Header					NVARCHAR(max),
	@Body					NVARCHAR(max),
	@Footer					NVARCHAR(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS (SELECT ID 
					FROM [tblDesignationHTMLTemplates] 
					WHERE HTMLTemplatesMasterId = @HTMLTemplatesMasterId AND Designation = @Designation)
		BEGIN

			UPDATE [dbo].[tblDesignationHTMLTemplates]
			   SET
				  [Subject] = @Subject
				  ,[Header] = @Header
				  ,[Body] = @Body
				  ,[Footer] = @Footer
				  ,[DateUpdated] = GETDATE()
			 WHERE HTMLTemplatesMasterId = @HTMLTemplatesMasterId AND Designation = @Designation

		END
	ELSE
		BEGIN
			INSERT INTO [dbo].[tblDesignationHTMLTemplates]
				   ([HTMLTemplatesMasterId]
				   ,[Designation]
				   ,[Subject]
				   ,[Header]
				   ,[Body]
				   ,[Footer]
				   ,[DateUpdated])
			 VALUES
				   (@HTMLTemplatesMasterId
				   ,@Designation
				   ,@Subject
				   ,@Header
				   ,@Body
				   ,@Footer
				   ,GETDATE())
		END

END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 27 Jan 2017
-- Description:	Deletes designation HTMLTemplate.
-- =============================================
CREATE PROCEDURE DeleteDesignationHTMLTemplate
	@HTMLTemplatesMasterId	INT,
	@Designation			VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE 
	FROM [dbo].[tblDesignationHTMLTemplates]
	WHERE HTMLTemplatesMasterId = @HTMLTemplatesMasterId AND Designation = @Designation

END
GO



UPDATE tblInstallUsers
SET
	Rejection_Date = CONVERT(date, RejectionDate, 101)
WHERE RejectionDate IS NOT NULL AND RejectionDate LIKE '%/%/%'
GO

ALTER TABLE tblInstallUsers
DROP COLUMN RejectionDate
GO

ALTER TABLE tblInstallUsers
ADD RejectionDate DATE NULL
GO

UPDATE tblInstallUsers
SET
	RejectionDate = CAST(Rejection_Date AS date)
WHERE Rejection_Date IS NOT NULL
GO

ALTER TABLE tblInstallUsers
DROP COLUMN Rejection_Date
GO

/****** Object:  StoredProcedure [dbo].[UDP_ChangeStatus]    Script Date: 30-01-2017 14:10:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 22 Sep 2016
-- Description:	Updates status and status related fields for install user.
--				Inserts event and event users for interview status.
--				Deletes any exising events and event users for non interview status.
--				Gets install users details.
-- =============================================
ALTER PROCEDURE [dbo].[UDP_ChangeStatus] 
(
	@Id int = 0,
	@Status varchar(20) = '',
	@RejectionDate DATE = NULL,
	@RejectionTime VARCHAR(20) = NULL,
	@RejectedUserId int = 0,
	@StatusReason varchar(max) = '',
	@UserIds varchar(4000) = NULL,
	@IsInstallUser bit = 0
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Updates user status and status related information.
	UPDATE [dbo].[tblInstallUsers]
	SET 
		 Status = @Status
		,RejectionDate = @RejectionDate
		,RejectionTime = @RejectionTime
		,InterviewTime = @RejectionTime
		,RejectedUserId = @RejectedUserId
		,StatusReason = @StatusReason
	WHERE Id = @Id

	-- Add event and event users for Interview status.
	IF @Status = 'InterviewDate' OR @Status = 'Interview Date'
	BEGIN
		INSERT INTO tbl_AnnualEvents(EventName,EventDate,EventAddedBy,ApplicantId,IsInstallUser)
			VALUES('InterViewDetails',@RejectionDate,@RejectedUserId,@Id,@IsInstallUser)

		IF @UserIds IS NOT NULL
		BEGIN
			DECLARE @EventID INT
			SELECT @EventID = SCOPE_IDENTITY()

			INSERT INTO tbl_AnnualEventAssignedUsers([EventId],	[UserId])
				SELECT @EventID, CAST(ss.Item AS INT) 
				FROM dbo.SplitString(@UserIds,',') ss 
				WHERE NOT EXISTS(
									SELECT CAST(ttau.UserId as varchar) 
									FROM dbo.tbl_AnnualEventAssignedUsers ttau 
									WHERE ttau.UserId = CAST(ss.Item AS bigint) AND ttau.EventId = @EventID)
		END
	END
	-- Delete any event and event users for given install user as 
	-- events are required for interview status only.
	ELSE
	BEGIN
		DELETE 
		FROM tbl_AnnualEventAssignedUsers 
		WHERE EventId IN (SELECT Id 
							FROM tbl_AnnualEvents 
							WHERE ApplicantId=@Id)

		DELETE 
		FROM tbl_AnnualEvents 
		WHERE ApplicantId=@Id
	END

	-- Gets user details required to further process user whoes status is changed.
	SELECT Email,HireDate,EmpType,PayRates, Designation, FristName, LastName 
	FROM tblInstallUsers 
	WHERE Id = @Id

END
GO

/****** Object:  StoredProcedure [dbo].[sp_GetHrData]    Script Date: 30-01-2017 15:19:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 16 Jan 2017
-- Description:	Gets statictics and records for edit user page.
-- =============================================
-- [sp_GetHrData] '0','0','0', '0', NULL,NULL,0,10
ALTER PROCEDURE [dbo].[sp_GetHrData]
	@SearchTerm VARCHAR(15) = NULL,
	@Status VARCHAR(50),
	@DesignationId INT,
	@SourceId INT,
	@AddedByUserId INT,
	@FromDate DATE = NULL,
	@ToDate DATE = NULL,
	@PageIndex INT = NULL, 
	@PageSize INT = NULL,
	@SortExpression VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF @Status = '0'
	BEGIN
		SET @Status = NULL
	END

	IF @DesignationId = '0'
	BEGIN
		SET @DesignationId = NULL
	END
	
	IF @SourceId = '0'
	BEGIN
		SET @SourceId = NULL
	END

	IF @AddedByUserId = 0
	BEGIN
		SET @AddedByUserId = NULL
	END

	DECLARE @StartIndex INT  = 0

	IF @PageIndex IS NULL
	BEGIN
		SET @PageIndex = 0
	END

	IF @PageSize IS NULL
	BEGIN
		SET @PageSize = 0
	END

	SET @StartIndex = (@PageIndex * @PageSize) + 1

	-- get statistics (Status)
	SELECT 
		t.Status, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id	
	WHERE 
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY t.status
	
	-- get statistics (AddedBy)
	SELECT 
		ISNULL(U.Username,'')  AS AddedBy, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY U.Username

	-- get statistics (Designation)
	SELECT 
		t.Designation, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY t.Designation
	
	-- get statistics (Source)
	SELECT 
		t.Source, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY t.Source

	-- get records
	;WITH SalesUsers
	AS 
	(
		SELECT 
			t.Id,
			t.FristName,
			t.LastName,
			t.Phone,
			t.Zip,
			d.DesignationName AS Designation,
			t.Status,
			t.HireDate,
			t.InstallId,
			t.picture, 
			t.CreatedDateTime, 
			Isnull(s.Source,'') AS Source,
			t.SourceUser, 
			ISNULL(U.Username,'')  AS AddedBy ,
			 ISNULL (t.UserInstallId ,t.id) As UserInstallId , 
			InterviewDetail = case when (t.Status='InterviewDate' or t.Status='Interview Date') then CAST(coalesce(t.RejectionDate,'') AS VARCHAR)  + ' ' + coalesce(t.InterviewTime,'') else '' end,
			RejectDetail = case when (t.Status='Rejected' ) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR) + ' ' + coalesce(t.RejectionTime,'') + ' ' + '-' + coalesce(ru.LastName,'') else '' end,
			t.Email, 
			t.DesignationID, 
			t1.[UserInstallId] As AddedByUserInstallId, 
			t1.Id As AddedById , 
			0 as 'EmpType'
			,NULL as [Aggregate] ,
			t.Phone As PrimaryPhone , 
			NULL as 'CountryCode', 
			t.Resumepath
			--ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId
			,NULL as 'TechTaskId', 
			NULL as 'TechTaskInstallId',
			ROW_NUMBER() OVER
							(
								ORDER BY
									CASE WHEN @SortExpression = 'Id ASC' THEN t.Id END ASC,
									CASE WHEN @SortExpression = 'Id DESC' THEN t.Id END DESC,
									CASE WHEN @SortExpression = 'Status ASC' THEN t.Status END ASC,
									CASE WHEN @SortExpression = 'Status DESC' THEN t.Status END DESC,
									CASE WHEN @SortExpression = 'FristName ASC' THEN t.FristName END ASC,
									CASE WHEN @SortExpression = 'FristName DESC' THEN t.FristName END DESC,
									CASE WHEN @SortExpression = 'Designation ASC' THEN d.DesignationName END ASC,
									CASE WHEN @SortExpression = 'Designation DESC' THEN d.DesignationName END DESC,
									CASE WHEN @SortExpression = 'Source ASC' THEN s.Source END ASC,
									CASE WHEN @SortExpression = 'Source DESC' THEN s.Source END DESC,
									CASE WHEN @SortExpression = 'Phone ASC' THEN t.Phone END ASC,
									CASE WHEN @SortExpression = 'Phone DESC' THEN t.Phone END DESC,
									CASE WHEN @SortExpression = 'Zip ASC' THEN t.Phone END ASC,
									CASE WHEN @SortExpression = 'Zip DESC' THEN t.Phone END DESC
								
							) AS RowNumber
		FROM 
			tblInstallUsers t 
				LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
				LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
				LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
				LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id  
				LEFT JOIN tblSource s ON t.SourceId = s.Id
		WHERE 
			(t.UserType = 'SalesUser' OR t.UserType = 'sales')
			AND 
			(
				@SearchTerm IS NULL OR 
				1 = CASE
						WHEN t.InstallId LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.FristName LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.LastName LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.Email LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.Phone LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.Zip LIKE '%'+ @SearchTerm + '%' THEN 1
						ELSE 0
					END
			)
			AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))
			AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))
			AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))
			AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))
			AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
			AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	)

	SELECT *
	FROM SalesUsers
	WHERE 
		RowNumber >= @StartIndex AND 
		(
			@PageSize = 0 OR 
			RowNumber < (@StartIndex + @PageSize)
		)

	-- get record count
	SELECT COUNT(*) AS TotalRecordCount
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id		  
			LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id    
			LEFT JOIN tblSource s ON t.SourceId = s.Id
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND 
		(
			@SearchTerm IS NULL OR 
			1 = CASE
					WHEN t.InstallId LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.FristName LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.LastName LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.Email LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.Phone LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.Zip LIKE '%'+ @SearchTerm + '%' THEN 1
					ELSE 0
				END
		)
		AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))
		AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))
		AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))
		AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
END
GO



UPDATE tblInstallUsers
SET
	[Status] = CASE [Status]
				WHEN  'Active' THEN '1'
				WHEN  'Applicant' THEN '2'
				WHEN  'Deactive' THEN '3'
				WHEN  'InstallProspect' THEN '4'
				WHEN  'InterviewDate' THEN '5'
				WHEN  'OfferMade' THEN '6'
				WHEN  'PhoneScreened' THEN '7'
				WHEN  'Phone_VideoScreened' THEN '8'
				WHEN  'Rejected' THEN '9'
				WHEN  'ReferralApplicant' THEN '10'
				ELSE [Status]
			END
WHERE [Status] IS NOT NULL
GO


/****** Object:  StoredProcedure [dbo].[UDP_ChangeStatus]    Script Date: 30-01-2017 14:10:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 22 Sep 2016
-- Description:	Updates status and status related fields for install user.
--				Inserts event and event users for interview status.
--				Deletes any exising events and event users for non interview status.
--				Gets install users details.
-- =============================================
ALTER PROCEDURE [dbo].[UDP_ChangeStatus] 
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
	SET 
		 Status = @Status
		,RejectionDate = @RejectionDate
		,RejectionTime = @RejectionTime
		,InterviewTime = @RejectionTime
		,RejectedUserId = @RejectedUserId
		,StatusReason = @StatusReason
	WHERE Id = @Id

	-- Add event and event users for Interview status.
	IF @Status = @InterviewDateStatus
	BEGIN
		INSERT INTO tbl_AnnualEvents(EventName,EventDate,EventAddedBy,ApplicantId,IsInstallUser)
			VALUES('InterViewDetails',@RejectionDate,@RejectedUserId,@Id,@IsInstallUser)

		IF @UserIds IS NOT NULL
		BEGIN
			DECLARE @EventID INT
			SELECT @EventID = SCOPE_IDENTITY()

			INSERT INTO tbl_AnnualEventAssignedUsers([EventId],	[UserId])
				SELECT @EventID, CAST(ss.Item AS INT) 
				FROM dbo.SplitString(@UserIds,',') ss 
				WHERE NOT EXISTS(
									SELECT CAST(ttau.UserId as varchar) 
									FROM dbo.tbl_AnnualEventAssignedUsers ttau 
									WHERE ttau.UserId = CAST(ss.Item AS bigint) AND ttau.EventId = @EventID)
		END
	END
	-- Delete any event and event users for given install user as 
	-- events are required for interview status only.
	ELSE
	BEGIN
		DELETE 
		FROM tbl_AnnualEventAssignedUsers 
		WHERE EventId IN (SELECT Id 
							FROM tbl_AnnualEvents 
							WHERE ApplicantId=@Id)

		DELETE 
		FROM tbl_AnnualEvents 
		WHERE ApplicantId=@Id
	END

	-- Gets user details required to further process user whoes status is changed.
	SELECT Email,HireDate,EmpType,PayRates, Designation, FristName, LastName 
	FROM tblInstallUsers 
	WHERE Id = @Id

END
GO

/****** Object:  StoredProcedure [dbo].[sp_GetHrData]    Script Date: 30-01-2017 15:19:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 16 Jan 2017
-- Description:	Gets statictics and records for edit user page.
-- =============================================
-- [sp_GetHrData] '0','0','0', '0', NULL,NULL,0,10
ALTER PROCEDURE [dbo].[sp_GetHrData]
	@SearchTerm VARCHAR(15) = NULL,
	@Status VARCHAR(50),
	@DesignationId INT,
	@SourceId INT,
	@AddedByUserId INT,
	@FromDate DATE = NULL,
	@ToDate DATE = NULL,
	@PageIndex INT = NULL, 
	@PageSize INT = NULL,
	@SortExpression VARCHAR(50),
	@InterviewDateStatus VARChAR(5) = '5',
	@RejectedStatus VARChAR(5) = '9'
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF @Status = '0'
	BEGIN
		SET @Status = NULL
	END

	IF @DesignationId = '0'
	BEGIN
		SET @DesignationId = NULL
	END
	
	IF @SourceId = '0'
	BEGIN
		SET @SourceId = NULL
	END

	IF @AddedByUserId = 0
	BEGIN
		SET @AddedByUserId = NULL
	END

	DECLARE @StartIndex INT  = 0

	IF @PageIndex IS NULL
	BEGIN
		SET @PageIndex = 0
	END

	IF @PageSize IS NULL
	BEGIN
		SET @PageSize = 0
	END

	SET @StartIndex = (@PageIndex * @PageSize) + 1

	-- get statistics (Status)
	SELECT 
		t.Status, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id	
	WHERE 
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY t.status
	
	-- get statistics (AddedBy)
	SELECT 
		ISNULL(U.Username,'')  AS AddedBy, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY U.Username

	-- get statistics (Designation)
	SELECT 
		t.Designation, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY t.Designation
	
	-- get statistics (Source)
	SELECT 
		t.Source, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY t.Source

	-- get records
	;WITH SalesUsers
	AS 
	(
		SELECT 
			t.Id,
			t.FristName,
			t.LastName,
			t.Phone,
			t.Zip,
			d.DesignationName AS Designation,
			t.Status,
			t.HireDate,
			t.InstallId,
			t.picture, 
			t.CreatedDateTime, 
			Isnull(s.Source,'') AS Source,
			t.SourceUser, 
			ISNULL(U.Username,'')  AS AddedBy ,
			 ISNULL (t.UserInstallId ,t.id) As UserInstallId , 
			InterviewDetail = case 
									when (t.Status=@InterviewDateStatus) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR)  + ' ' + coalesce(t.InterviewTime,'') 
									else '' end,
			RejectDetail = case when (t.Status=@RejectedStatus ) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR) + ' ' + coalesce(t.RejectionTime,'') + ' ' + '-' + coalesce(ru.LastName,'') 
									else '' end,
			t.Email, 
			t.DesignationID, 
			t1.[UserInstallId] As AddedByUserInstallId, 
			t1.Id As AddedById , 
			0 as 'EmpType'
			,NULL as [Aggregate] ,
			t.Phone As PrimaryPhone , 
			NULL as 'CountryCode', 
			t.Resumepath
			--ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId
			,NULL as 'TechTaskId', 
			NULL as 'TechTaskInstallId',
			ROW_NUMBER() OVER
							(
								ORDER BY
									CASE WHEN @SortExpression = 'Id ASC' THEN t.Id END ASC,
									CASE WHEN @SortExpression = 'Id DESC' THEN t.Id END DESC,
									CASE WHEN @SortExpression = 'Status ASC' THEN t.Status END ASC,
									CASE WHEN @SortExpression = 'Status DESC' THEN t.Status END DESC,
									CASE WHEN @SortExpression = 'FristName ASC' THEN t.FristName END ASC,
									CASE WHEN @SortExpression = 'FristName DESC' THEN t.FristName END DESC,
									CASE WHEN @SortExpression = 'Designation ASC' THEN d.DesignationName END ASC,
									CASE WHEN @SortExpression = 'Designation DESC' THEN d.DesignationName END DESC,
									CASE WHEN @SortExpression = 'Source ASC' THEN s.Source END ASC,
									CASE WHEN @SortExpression = 'Source DESC' THEN s.Source END DESC,
									CASE WHEN @SortExpression = 'Phone ASC' THEN t.Phone END ASC,
									CASE WHEN @SortExpression = 'Phone DESC' THEN t.Phone END DESC,
									CASE WHEN @SortExpression = 'Zip ASC' THEN t.Phone END ASC,
									CASE WHEN @SortExpression = 'Zip DESC' THEN t.Phone END DESC
								
							) AS RowNumber
		FROM 
			tblInstallUsers t 
				LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
				LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
				LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
				LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id  
				LEFT JOIN tblSource s ON t.SourceId = s.Id
		WHERE 
			(t.UserType = 'SalesUser' OR t.UserType = 'sales')
			AND 
			(
				@SearchTerm IS NULL OR 
				1 = CASE
						WHEN t.InstallId LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.FristName LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.LastName LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.Email LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.Phone LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.Zip LIKE '%'+ @SearchTerm + '%' THEN 1
						ELSE 0
					END
			)
			AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))
			AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))
			AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))
			AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))
			AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
			AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	)

	SELECT *
	FROM SalesUsers
	WHERE 
		RowNumber >= @StartIndex AND 
		(
			@PageSize = 0 OR 
			RowNumber < (@StartIndex + @PageSize)
		)

	-- get record count
	SELECT COUNT(*) AS TotalRecordCount
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id		  
			LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id    
			LEFT JOIN tblSource s ON t.SourceId = s.Id
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND 
		(
			@SearchTerm IS NULL OR 
			1 = CASE
					WHEN t.InstallId LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.FristName LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.LastName LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.Email LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.Phone LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.Zip LIKE '%'+ @SearchTerm + '%' THEN 1
					ELSE 0
				END
		)
		AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))
		AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))
		AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))
		AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
END
GO


/****** Object:  StoredProcedure [dbo].[UDP_IsValidInstallerUser]    Script Date: 30-01-2017 17:44:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER ProcEDURE [dbo].[UDP_IsValidInstallerUser]
	@userid varchar(50),
	@password varchar(50),
	@ActiveStatus varchar(5) = '1',
	@InterviewDateStatus varchar(5) = '5',
	@OfferMadeStatus varchar(5) = '6',
	@result int output
AS
BEGIN
	if exists(
				select Id 
				from tblInstallUsers 
				where Email=@userid and 
					  Password=@password and 
					  (
						Status= @ActiveStatus OR 
						Status=@InterviewDateStatus OR 
						Status = @OfferMadeStatus
					  )
			)
	begin
		Set @result ='1'
	end
	else
	begin
		set @result='0'
	end

	return @result

END
GO


/****** Object:  StoredProcedure [dbo].[UDP_deleteInstalluser]    Script Date: 30-01-2017 17:58:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[UDP_deleteInstalluser]
@id int,
@DeactiveStatus Varchar(5) = '3',
@result bit output
as
begin
	Set @result ='1'
	UPDATE dbo.tblInstallUsers SET STATUS = @DeactiveStatus WHERE id = @id
	
/*delete from dbo.tblInstallUsers where Id=@id
  Set @result ='1'
       Begin
       Set @result ='0'      
       end*/
       
        return @result

 end
 GO

 
/****** Object:  StoredProcedure [dbo].[SP_GetInstallUsers]    Script Date: 30-01-2017 18:23:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author: ALI SHAHABAS  
-- Create date: 26-JUNE-2016  
-- Updated By: Jaylem
-- Updated date: 13-Dec-2016  
-- Description: SP_GetInstallUsers    
-- =============================================    
ALTER PROCEDURE [dbo].[SP_GetInstallUsers]    
	@Key int,  
	@Designations varchar(4000),
	@ActiveStatus varchar(5) = '1',
	@InterviewDateStatus varchar(5) = '5',
	@OfferMadeStatus varchar(5) = '6'
AS    
BEGIN    

	IF @Key = 1  
	BEGIN
		SELECT
			DISTINCT(Designation) AS Designation 
		FROM tblinstallUsers 
		WHERE Designation IS NOT NULL     
		ORDER BY Designation
	END
	ELSE IF @Key = 2  
	BEGIN
		SELECT 
			DISTINCT FristName + ' ' + LastName AS FristName, Id , [Status] 
		FROM tblinstallUsers 
		WHERE  
			(FristName IS NOT NULL OR FristName <> '' )  AND 
			(
				tblinstallUsers.[Status] = @ActiveStatus OR 
				tblinstallUsers.[Status] = @OfferMadeStatus OR 
				tblinstallUsers.[Status] = @InterviewDateStatus
			) AND 
			(
				Designation IN (SELECT Item FROM dbo.SplitString(@Designations,','))
				OR
				Convert(Nvarchar(max),DesignationID)  IN (SELECT Item FROM dbo.SplitString(@Designations,','))
			)
		ORDER BY FristName + ' ' + LastName
	END
END
GO

/****** Object:  StoredProcedure [dbo].[sp_GetHrData]    Script Date: 30-Jan-17 11:16:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 16 Jan 2017
-- Description:	Gets statictics and records for edit user page.
-- =============================================
-- [sp_GetHrData] '0','0','0', '0', NULL,NULL,0,10
ALTER PROCEDURE [dbo].[sp_GetHrData]
	@SearchTerm VARCHAR(15) = NULL,
	@Status VARCHAR(50),
	@DesignationId INT,
	@SourceId INT,
	@AddedByUserId INT,
	@FromDate DATE = NULL,
	@ToDate DATE = NULL,
	@PageIndex INT = NULL, 
	@PageSize INT = NULL,
	@SortExpression VARCHAR(50),
	@InterviewDateStatus VARChAR(5) = '5',
	@RejectedStatus VARChAR(5) = '9'
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF @Status = '0'
	BEGIN
		SET @Status = NULL
	END

	IF @DesignationId = '0'
	BEGIN
		SET @DesignationId = NULL
	END
	
	IF @SourceId = '0'
	BEGIN
		SET @SourceId = NULL
	END

	IF @AddedByUserId = 0
	BEGIN
		SET @AddedByUserId = NULL
	END

	DECLARE @StartIndex INT  = 0

	IF @PageIndex IS NULL
	BEGIN
		SET @PageIndex = 0
	END

	IF @PageSize IS NULL
	BEGIN
		SET @PageSize = 0
	END

	SET @StartIndex = (@PageIndex * @PageSize) + 1

	-- get statistics (Status)
	SELECT 
		t.Status, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id	
	WHERE 
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY t.status
	
	-- get statistics (AddedBy)
	SELECT 
		ISNULL(U.Username,'')  AS AddedBy, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY U.Username

	-- get statistics (Designation)
	SELECT 
		t.Designation, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY t.Designation
	
	-- get statistics (Source)
	SELECT 
		t.Source, COUNT(*) [Count] 
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	GROUP BY t.Source

	-- get records
	;WITH SalesUsers
	AS 
	(
		SELECT 
			t.Id,
			t.FristName,
			t.LastName,
			t.Phone,
			t.Zip,
			d.DesignationName AS Designation,
			t.Status,
			t.HireDate,
			t.InstallId,
			t.picture, 
			t.CreatedDateTime, 
			Isnull(s.Source,'') AS Source,
			t.SourceUser, 
			ISNULL(U.Username,'')  AS AddedBy ,
			 ISNULL (t.UserInstallId ,t.id) As UserInstallId , 
			InterviewDetail = case 
									when (t.Status=@InterviewDateStatus) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR)  + ' ' + coalesce(t.InterviewTime,'') 
									else '' end,
			RejectDetail = case when (t.Status=@RejectedStatus ) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR) + ' ' + coalesce(t.RejectionTime,'') + ' ' + '-' + coalesce(ru.LastName,'') 
									else '' end,
			t.Email, 
			t.DesignationID, 
			t1.[UserInstallId] As AddedByUserInstallId, 
			t1.Id As AddedById , 
			0 as 'EmpType'
			,NULL as [Aggregate] ,
			t.Phone As PrimaryPhone , 
			NULL as 'CountryCode', 
			t.Resumepath
			--ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId
			,NULL as 'TechTaskId', 
			NULL as 'TechTaskInstallId',
			ROW_NUMBER() OVER
							(
								ORDER BY
									CASE WHEN @SortExpression = 'Id ASC' THEN t.Id END ASC,
									CASE WHEN @SortExpression = 'Id DESC' THEN t.Id END DESC,
									CASE WHEN @SortExpression = 'Status ASC' THEN t.Status END ASC,
									CASE WHEN @SortExpression = 'Status DESC' THEN t.Status END DESC,
									CASE WHEN @SortExpression = 'FristName ASC' THEN t.FristName END ASC,
									CASE WHEN @SortExpression = 'FristName DESC' THEN t.FristName END DESC,
									CASE WHEN @SortExpression = 'Designation ASC' THEN d.DesignationName END ASC,
									CASE WHEN @SortExpression = 'Designation DESC' THEN d.DesignationName END DESC,
									CASE WHEN @SortExpression = 'Source ASC' THEN s.Source END ASC,
									CASE WHEN @SortExpression = 'Source DESC' THEN s.Source END DESC,
									CASE WHEN @SortExpression = 'Phone ASC' THEN t.Phone END ASC,
									CASE WHEN @SortExpression = 'Phone DESC' THEN t.Phone END DESC,
									CASE WHEN @SortExpression = 'Zip ASC' THEN t.Phone END ASC,
									CASE WHEN @SortExpression = 'Zip DESC' THEN t.Phone END DESC,
									CASE WHEN @SortExpression = 'CreatedDateTime ASC' THEN t.CreatedDateTime END ASC,
									CASE WHEN @SortExpression = 'CreatedDateTime DESC' THEN t.CreatedDateTime END DESC
								
							) AS RowNumber
		FROM 
			tblInstallUsers t 
				LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
				LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
				LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
				LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id  
				LEFT JOIN tblSource s ON t.SourceId = s.Id
		WHERE 
			(t.UserType = 'SalesUser' OR t.UserType = 'sales')
			AND 
			(
				@SearchTerm IS NULL OR 
				1 = CASE
						WHEN t.InstallId LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.FristName LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.LastName LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.Email LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.Phone LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1
						WHEN t.Zip LIKE '%'+ @SearchTerm + '%' THEN 1
						ELSE 0
					END
			)
			AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))
			AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))
			AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))
			AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))
			AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
			AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
	)

	SELECT *
	FROM SalesUsers
	WHERE 
		RowNumber >= @StartIndex AND 
		(
			@PageSize = 0 OR 
			RowNumber < (@StartIndex + @PageSize)
		)

	-- get record count
	SELECT COUNT(*) AS TotalRecordCount
	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id		  
			LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id    
			LEFT JOIN tblSource s ON t.SourceId = s.Id
	WHERE  
		(t.UserType = 'SalesUser' OR t.UserType = 'sales')
		AND 
		(
			@SearchTerm IS NULL OR 
			1 = CASE
					WHEN t.InstallId LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.FristName LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.LastName LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.Email LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.Phone LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1
					WHEN t.Zip LIKE '%'+ @SearchTerm + '%' THEN 1
					ELSE 0
				END
		)
		AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))
		AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))
		AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))
		AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date) 
		AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)
END
GO

