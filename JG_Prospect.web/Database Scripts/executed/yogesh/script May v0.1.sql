--EXEC usp_GetCandidateTestsResults '2736'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 051472017
-- Description:	This will load candidates apptitude test results.
-- =============================================
-- usp_GetCandidateTestsResults '2736'
CREATE PROCEDURE usp_GetCandidateTestsResults 
(
	@UserID VARCHAR(MAX) 
)
AS
BEGIN


	SET NOCOUNT ON;

SELECT        TestResults.ExamID, MCQ_Exam.ExamTitle, TestResults.[Aggregate], ISNULL(TestResults.ExamPerformanceStatus,0) AS Result, TestResults.UserID
FROM            MCQ_Performance AS TestResults INNER JOIN
                         MCQ_Exam ON TestResults.ExamID = MCQ_Exam.ExamID
WHERE        (TestResults.UserID = @UserID)


END
GO
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
   Friday, May 19, 20176:50:34 PM
   User: jgrovesa
   Server: jgdbserver001.cdgdaha6zllk.us-west-2.rds.amazonaws.com,1433
   Database: JGBS_Dev_New
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblTask ADD
	Sequence bigint NULL
GO
ALTER TABLE dbo.tblTask SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblTask', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblTask', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblTask', 'Object', 'CONTROL') as Contr_Per 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 05162017
-- Description:	This will update task sequence
-- =============================================
CREATE PROCEDURE usp_UpdateTaskSequence 
(	
	@Sequence bigint , 
	@TaskId bigint 
)
AS
BEGIN

-- if sequence is already assigned to some other task, all sequence will push back by 1 from alloted sequence.
		IF EXISTS(SELECT TaskId FROM tblTask WHERE [Sequence] = @Sequence AND TaskId <> @TaskId)
		BEGIN

			UPDATE       tblTask
			SET                [Sequence] = [Sequence] + 1			
			WHERE        ([Sequence] >= @Sequence)

		END
		
			UPDATE tblTask
			SET                [Sequence] = @Sequence	
			WHERE        (TaskId = @TaskId)


END
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


DROP VIEW [dbo].[TaskListView] 
GO

/****** Object:  View [dbo].[TaskListView]    Script Date: 5/19/2017 8:05:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[TaskListView] 
AS
SELECT 
	Tasks.*,

	TaskCreator.Id AS TaskCreatorId,
	TaskCreator.InstallId AS TaskCreatorInstallId,
	TaskCreator.FristName AS TaskCreatorUsername, 
	TaskCreator.FristName AS TaskCreatorFirstName, 
	TaskCreator.LastName AS TaskCreatorLastName, 
	TaskCreator.Email AS TaskCreatorEmail,

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
		LEFT JOIN tblInstallUsers TaskCreator ON TaskCreator.Id = Tasks.CreatedBy
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

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 05152017
-- Description:	This will load last available sequence for task
-- =============================================
CREATE PROCEDURE usp_GetLastAvailableSequence 

AS
BEGIN

	SELECT ISNULL(MAX([Sequence])+1,1) AS [Sequence] FROM tblTask

END
GO

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DROP PROCEDURE [dbo].GetTaskHierarchy
GO
-- =============================================    
-- Author:  Yogesh    
-- Create date: 20 March 2017    
-- Description: Get one or all tasks with all sub tasks from all levels.    
-- =============================================    
-- [GetTaskHierarchy] 418, 1  
    
CREATE PROCEDURE  [dbo].[GetTaskHierarchy]     
 @TaskId INT = NULL    
 ,@Admin BIT    
AS    
BEGIN    
     
 ;WITH cteTasks    
 AS    
 (    
  SELECT t1.*    
  FROM [TaskListView] t1    
  WHERE 1 = CASE      
      WHEN @TaskId IS NULL AND ParentTaskId IS NULL THEN 1    
      WHEN @TaskId = TaskId THEN 1    
      ELSE 0    
    END    
    
  UNION ALL    
    
  SELECT t2.*    
  FROM [TaskListView] t2 inner join cteTasks    
   on t2.ParentTaskId = cteTasks.TaskId  AND cteTasks.IsTechTask = 1  
  WHERE t2.IsTechTask = 1  
 )    
    
 SELECT *    
 FROM cteTasks LEFT JOIN [TaskApprovalsView] TaskApprovals     
   ON cteTasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin    
   
 ORDER BY [Sequence],cteTasks.TaskLevel, cteTasks.ParentTaskId    
    
END 

----------------------------------------------------------------------------------------------------------------------------------------

-- Live Published on 05212017

----------------------------------------------------------------------------------------------------------------------------------------



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 05222017
-- Description:	This will load all tasks with title and sequence
-- =============================================
CREATE PROCEDURE usp_GetAllTaskWithSequence 

AS
BEGIN

	SELECT Title, [Sequence] AS TaskSequence FROM tblTask WHERE [Sequence] IS NOT NULL ORDER BY [Sequence] DESC

END
GO



-- =============================================  
-- Author:  Yogesh  
-- Create date: 14 Nov 16  
-- Description: Inserts, Updates or Deletes a task.  
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
  @TaskLevel int,  
  @MainTaskId int,  
  @TaskPriority tinyint = null,  
  @IsTechTask bit = NULL,  
  @DeletedStatus TINYINT = 9,  
  @Sequence bigint = NULL,
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
     TaskLevel,  
     MainParentId  
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
     @TaskLevel,  
     @MainTaskId  
    )    
    
  SET @Result=SCOPE_IDENTITY ()    
    
	--- Update task sequence
			IF(@Result > 0)
			BEGIN


			-- if sequence is already assigned to some other task, all sequence will push back by 1 from alloted sequence.
				IF EXISTS(SELECT TaskId FROM tblTask WHERE [Sequence] = @Sequence AND TaskId <> @Result)
				BEGIN

					UPDATE       tblTask
					SET                [Sequence] = [Sequence] + 1			
					WHERE        ([Sequence] >= @Sequence)

				END
		
					UPDATE tblTask
					SET                [Sequence] = @Sequence	
					WHERE        (TaskId = @Result)


		    END

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

----------------------------------------------------------------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 05252017
-- Description:	This will load exams for user based on his designation
-- =============================================
-- usp_GetAptTestsByUserID 2934
CREATE PROCEDURE usp_GetAptTestsByUserID 
(
	@UserID bigint
)	  
AS
BEGIN
	
	DECLARE @DesignationID INT

	-- Get users designation based on its user id.
    SELECT        @DesignationID = DesignationID
	FROM            tblInstallUsers
	WHERE        (Id = @UserID)


	  IF(@DesignationID IS NOT NULL)
	  BEGIN

	     SELECT        MCQ_Exam.ExamID, MCQ_Exam.ExamDuration, MCQ_Exam.ExamTitle, ExamResult.MarksEarned, ExamResult.TotalMarks, ExamResult.[Aggregate], ExamResult.ExamPerformanceStatus
FROM            MCQ_Exam LEFT OUTER JOIN
                         MCQ_Performance AS ExamResult ON MCQ_Exam.ExamID = ExamResult.ExamID AND ExamResult.UserID = @UserID
WHERE        (@DesignationID IN
                             (SELECT        Item
                               FROM            dbo.SplitString(MCQ_Exam.DesignationID, ',') AS SplitString_1))

	  END



END
GO

-- =============================================  
-- Author:  Yogesh Keraliya  
-- Create date: 05252017  
-- Description: This will load exam questions randomly  
-- =============================================  
-- usp_GetQuestionsByExamID  20  
CREATE PROCEDURE usp_GetQuestionsByExamID   
(   
 @ExamId int   
)  
AS  
BEGIN  
  
DECLARE @Lower INT ---- The lowest random number  
DECLARE @Upper INT  
  
-- Generate random number and orderby questions according to it to load different sequence of exam everytime.  
SET @Lower = 1 ---- The lowest random number  
SET @Upper = 999 ---- The highest random number  
  
SELECT        MCQ_Question.QuestionID, MCQ_Question.Question, MCQ_Question.PositiveMarks, MCQ_Question.NegetiveMarks, MCQ_Question.ExamID, ABS(CAST(NEWID() AS binary(6)) % 1000) + 1 AS QuestionOrder, 
                         MCQ_Exam.ExamDuration
FROM            MCQ_Question INNER JOIN
                         MCQ_Exam ON MCQ_Question.ExamID = MCQ_Exam.ExamID
WHERE        (MCQ_Question.ExamID = @ExamId)
ORDER BY QuestionOrder  
  
END  
  
    
-- =============================================    
-- Author: Yogesh Keraliya    
-- Create date: 05262017    
-- Description: Update users exam performance.    
-- =============================================    
ALTER PROCEDURE [dbo].[SP_InsertPerfomace]     
 -- Add the parameters for the stored procedure here    
 @installUserID varchar(20),     
 @examID int = 0    
 ,@marksEarned int    
 ,@totalMarks int    
 ,@Aggregate real    
 ,@ExamPerformanceStatus int    
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
  
 DECLARE @PassPercentage REAL  
   
 SELECT @PassPercentage = [PassPercentage] FROM MCQ_Exam WHERE [ExamID] = @examID  
  
  
 IF(@PassPercentage < @Aggregate)  
 BEGIN  
  
 SET @ExamPerformanceStatus = 1  
  
 END  
 ELSE  
  BEGIN  
   
  SET @ExamPerformanceStatus = 0  
  
  END  
 
 -- Get Total Marks Properly from Database
 
 SELECT @totalMarks = SUM([PositiveMarks]) FROM MCQ_Question WHERE ExamID = @examID
   
    -- Insert statements for procedure here    
 INSERT INTO [MCQ_Performance]    
           ([UserID]    
           ,[ExamID]    
           ,[MarksEarned]    
           ,[TotalMarks]    
           ,[Aggregate]    
     ,[ExamPerformanceStatus]               
     )    
     VALUES    
           (@installUserID    
           ,@examID    
           ,@marksEarned    
           ,@totalMarks    
           ,@Aggregate    
     ,@ExamPerformanceStatus    
           )    
END    


-- =============================================  
-- Author:  Yogesh Keraliya  
-- Create date: 05302017  
-- Description: This will load exam result for user based on his designation  
-- =============================================  
-- usp_isAllExamsGivenByUser 2934  
CREATE PROCEDURE usp_isAllExamsGivenByUser   
(  
 @UserID bigint , 
 @AggregateScored FLOAT= 0 OUTPUT,
 @AllExamsGiven BIT = 0 OUTPUT
)     
AS  
BEGIN  
   
	 DECLARE @DesignationID INT  
  
	 -- Get users designation based on its user id.  
	 SELECT        @DesignationID = DesignationID  
	 FROM            tblInstallUsers  
	 WHERE        (Id = @UserID)  
  
  
	   IF(@DesignationID IS NOT NULL)  
	   BEGIN  
  
			DECLARE @ExamCount INT
			DECLARE @GivenExamCount INT

			-- check exams available for existing designation
			SELECT      @ExamCount = COUNT(MCQ_Exam.ExamID)
		  FROM          MCQ_Exam 
		  WHERE        (@DesignationID IN 
						 (SELECT   Item   FROM  dbo.SplitString(MCQ_Exam.DesignationID, ',') AS SplitString_1))  

				-- check exams given by user
				SELECT @GivenExamCount = COUNT(ExamID) FROM MCQ_Performance WHERE UserID = @UserID

				-- IF all exam given, calcualte result.	  
				IF( @ExamCount = @GivenExamCount AND @GivenExamCount > 0)
				BEGIN

				 SELECT @AggregateScored = (SUM([Aggregate])/@GivenExamCount) FROM MCQ_Performance  WHERE UserID = @UserID

				 SET @AllExamsGiven = 1

				END
				ELSE
				BEGIN
					SET @AllExamsGiven = 0
				END


	END  
  
  RETURN @AggregateScored
  
END  
 
 

-- =============================================    
  
-- Author:  Yogesh    
  
-- Create date: 22 Sep 2016    
  
-- Description: Updates status and status related fields for install user.    
  
--    Inserts event and event users for interview status.    
  
--    Deletes any exising events and event users for non interview status.    
  
--    Gets install users details.    
  
-- =============================================    
  
CREATE PROCEDURE [dbo].[USP_ChangeUserStatusToReject]
(    
  
 @UserID BIGINT ,

 @StatusId int = 0,    
  
 @RejectionDate DATE = NULL,    
  
 @RejectionTime VARCHAR(20) = NULL,    
  
 @RejectedUserId int = 0,    
  
 @StatusReason varchar(max) = ''
  
)    
  
AS    
  
BEGIN  
  
		-- SET NOCOUNT ON added to prevent extra result sets from    
  
		-- interfering with SELECT statements.    
  
		SET NOCOUNT ON;  
  
  
		-- Updates user status and status related information.    
  
		UPDATE [dbo].[tblInstallUsers]  
  
		SET [Status] = @StatusId  
  
		 ,RejectionDate = @RejectionDate  
  
		 ,RejectionTime = @RejectionTime  
  
		 ,InterviewTime = @RejectionTime  
  
		 ,RejectedUserId = @RejectedUserId  
  
		 ,StatusReason = @StatusReason  
  
		WHERE Id = @UserID
  

END  
 
-- =============================================  
-- Author:  Jaylem  
-- Create date: 13-Dec-2016  
-- Description: Returns all/selected Active Designation   
  
-- Updated : Added DesignationCode.  
--  date: 22 Mar 2017  
--  by : Yogesh  
-- =============================================  
-- [dbo].[UDP_GetAllDesignationByTaskID] 418
CREATE PROCEDURE [dbo].[UDP_GetAllDesignationByTaskID]  
 (
 @TaskID As Int  
 )
AS  
BEGIN  

 SET NOCOUNT ON;   
   
SELECT        TD.DesignationID, D.DesignationName, TD.TaskId
FROM            tblTaskDesignations AS TD LEFT OUTER JOIN
                         tbl_Designation AS D ON TD.DesignationID = D.ID
WHERE        (TD.TaskId = @TaskID)

END


-- =============================================  
-- Author:  Yogesh Keraliya  
-- Create date: 05222017  
-- Description: This will load all tasks with title and sequence  
-- =============================================  
-- usp_GetAllTaskWithSequence 0,20
ALTER PROCEDURE usp_GetAllTaskWithSequence   
(  
 
 @PageIndex INT = 0,   
 @PageSize INT =20   
   
)  
As  
BEGIN  
  
DECLARE @StartIndex INT  = 0  
SET @StartIndex = (@PageIndex * @PageSize) + 1  
  
  
;WITH   
 Tasklist AS  
 (   
  select DISTINCT TaskId ,[Status],[Sequence], 
  Title,ParentTaskId,Assigneduser,ParentTaskTitle,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,  TaskDesignation,
  case   
   when (ParentTaskId is null and  TaskLevel=1) then InstallId   
   when (tasklevel =1 and ParentTaskId>0) then   
    (select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId    
   when (tasklevel =2 and ParentTaskId>0) then  
    (select InstallId from tbltask where taskid in (  
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))  
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId   
       
   when (tasklevel =3 and ParentTaskId>0) then  
   (select InstallId from tbltask where taskid in (  
   (select parenttaskid from tbltask where taskid in (  
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))  
   +'-'+  
    (select InstallId from tbltask where taskid in (  
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))  
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId   
  end as 'InstallId' ,Row_number() OVER (order by x.TaskId ) AS RowNo_Order  
  from (  
   select DISTINCT a.*  
   ,(select Title from tbltask where TaskId=(select * from [GetParent](a.TaskId))) AS ParentTaskTitle  
   ,t.FristName + ' ' + t.LastName AS Assigneduser,
   (
   STUFF((SELECT ', ' + Designation
           FROM tblTaskdesignations td 
           WHERE td.TaskID = a.TaskId 
          FOR XML PATH('')), 1, 2, '')
  )  AS TaskDesignation
   from  tbltask a  
   LEFT OUTER JOIN tblTaskdesignations as b ON a.TaskId = b.TaskId   
   LEFT OUTER JOIN tbltaskassignedusers as c ON a.TaskId = c.TaskId  
   LEFT OUTER JOIN tblInstallUsers as t ON c.UserId = t.Id    
   where a.[Sequence] IS NOT NULL
  
   --and (CreatedOn >=@startdate and CreatedOn <= @enddate )   
  ) as x  
 )  
  
 ---- get CTE data into temp table  
 SELECT *  
 INTO #temp  
 FROM Tasklist  
   
 SELECT *   
 FROM #temp   
 WHERE   
 RowNo_Order >= @StartIndex AND   
 (  
  @PageSize = 0 OR   
  RowNo_Order < (@StartIndex + @PageSize)  
 )  
 ORDER BY [Sequence]  DESC
  
  
 SELECT  
 COUNT(*) AS TotalRecords  
  FROM #temp  

END

/*
   Monday, June 5, 20171:02:30 PM
   User: jgrovesa
   Server: jgdbserver001.cdgdaha6zllk.us-west-2.rds.amazonaws.com,1433
   Database: JGBS_Dev_New
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblTask ADD
	SequenceDesignationId int NULL,
	UpdatedBy int NULL,
	UpdatedOn datetime NULL
GO
ALTER TABLE dbo.tblTask ADD CONSTRAINT
	DF_tblTask_UpdatedOn DEFAULT getdate() FOR UpdatedOn
GO
ALTER TABLE dbo.tblTask SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblTask', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblTask', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblTask', 'Object', 'CONTROL') as Contr_Per 
  

USE JGBS_Dev_New
GO


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_UpdateTaskSequence]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_UpdateTaskSequence   

	END
		
GO
-- =============================================  
-- Author:  Yogesh Keraliya  
-- Create date: 05162017  
-- Description: This will update task sequence  
-- =============================================  
CREATE PROCEDURE usp_UpdateTaskSequence   
(   
 @Sequence bigint ,
 @DesignationID int,   
 @TaskId bigint,
 @IsTechTask bit   
)  
AS  
BEGIN  
  

-- if sequence is already assigned to some other task with same designation, all sequence will push back by 1 from alloted sequence for that designation.  
IF EXISTS(SELECT   T.TaskId
FROM            tblTask AS T 
WHERE        (T.[Sequence] = @Sequence) AND (T.TaskId <> @TaskId) AND (T.[SequenceDesignationId] = @DesignationID) AND T.IsTechTask = @IsTechTask)  
  BEGIN  
  
		-- push back all task sequence for 1 from sequence assigned in between.
		   UPDATE       tblTask  
		   SET                [Sequence] = [Sequence] + 1     
		   WHERE        ([Sequence] >= @Sequence) AND ([SequenceDesignationId] = @DesignationID) AND IsTechTask = @IsTechTask
  
  END  
  
  -- Update task sequence and its respective designationid.
  UPDATE tblTask  
   SET                [Sequence] = @Sequence , [SequenceDesignationId] = @DesignationID
   WHERE        (TaskId = @TaskId) 


END  
GO

--SP_HELPTEXT 'usp_GetAllTaskWithSequence'

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_GetAllTaskWithSequence]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_GetAllTaskWithSequence   

	END  
GO    
-- =============================================          
-- Author:  Yogesh Keraliya          
-- Create date: 05222017          
-- Description: This will load all tasks with title and sequence          
-- =============================================          
-- usp_GetAllTaskWithSequence 2,2,'',0,516    
CREATE PROCEDURE usp_GetAllTaskWithSequence           
(          
         
 @PageIndex INT = 0,           
 @PageSize INT =20,    
 @DesignationIds VARCHAR(20) = NULL,    
 @IsTechTask BIT = 0,    
 @HighLightedTaskID BIGINT = NULL    
            
)          
As          
BEGIN          
    
    
IF( @DesignationIds = '' )    
BEGIN    
    
 SET @DesignationIds = NULL    
    
END    
          
          
;WITH           
 Tasklist AS          
 (           
  SELECT DISTINCT TaskId ,[Status],[SequenceDesignationId],[Sequence],         
  Title,ParentTaskId,Assigneduser,IsTechTask,ParentTaskTitle,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,  TaskDesignation,        
  case           
   when (ParentTaskId is null and  TaskLevel=1) then InstallId           
   when (tasklevel =1 and ParentTaskId>0) then           
    (select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId            
   when (tasklevel =2 and ParentTaskId>0) then          
    (select InstallId from tbltask where taskid in (          
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))          
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId           
               
   when (tasklevel =3 and ParentTaskId>0) then          
   (select InstallId from tbltask where taskid in (          
   (select parenttaskid from tbltask where taskid in (          
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))          
   +'-'+          
    (select InstallId from tbltask where taskid in (          
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))          
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId           
  end as 'InstallId' ,Row_number() OVER (order by x.TaskId ) AS RowNo_Order          
  from (          
   select DISTINCT a.*          
   ,(select Title from tbltask where TaskId=(select * from [GetParent](a.TaskId))) AS ParentTaskTitle          
   ,t.FristName + ' ' + t.LastName AS Assigneduser,        
   (        
   STUFF((SELECT ', ' + Designation        
           FROM tblTaskdesignations td         
           WHERE td.TaskID = a.TaskId         
          FOR XML PATH('')), 1, 2, '')        
  )  AS TaskDesignation        
   from  tbltask a          
   LEFT OUTER JOIN tblTaskdesignations as b ON a.TaskId = b.TaskId           
   LEFT OUTER JOIN tbltaskassignedusers as c ON a.TaskId = c.TaskId          
   LEFT OUTER JOIN tblInstallUsers as t ON c.UserId = t.Id            
   WHERE     
  (     
    (a.[Sequence] IS NOT NULL)     
    AND (a.[SequenceDesignationId] IN (SELECT * FROM [dbo].[SplitString](ISNULL(@DesignationIds,a.[SequenceDesignationId]),',') ) )     
    AND (ISNULL(a.[IsTechTask],@IsTechTask) = @IsTechTask)    
       
   )     
   OR    
   (    
     a.TaskId = @HighLightedTaskID    
   )         
   --and (CreatedOn >=@startdate and CreatedOn <= @enddate )           
  ) as x          
 )          
          
 ---- get CTE data into temp table          
 SELECT *          
 INTO #Tasks          
 FROM Tasklist          
    
---- find page number to show taskid sent.    
DECLARE @StartIndex INT  = 0          
    
          
--IF @HighLightedTaskID  > 0    
-- BEGIN    
--  DECLARE @RowNumber BIGINT = NULL    
    
--  -- Find in which rownumber highlighter taskid is.    
--  SELECT @RowNumber = RowNo_Order     
--  FROM #Tasks     
--  WHERE TaskId = @HighLightedTaskID    
    
--  -- if row number found then divide it with page size and round it to nearest integer , so will found pagenumber to be selected.    
--  -- for ex. if total 60 records are there,pagesize is 20 and highlighted task id is at 42 row number than.     
--  -- 42/20 = 2.1 ~ 3 - 1 = 2 = @Page Index    
--  -- StartIndex = (2*20)+1 = 41, so records 41 to 60 will be fetched.    
       
--  IF @RowNumber IS NOT NULL    
--  BEGIN    
--   SELECT @PageIndex = (CEILING(@RowNumber / CAST(@PageSize AS FLOAT))) - 1    
--  END    
-- END      
    
 -- Set start index to fetch record.    
 SET @StartIndex = (@PageIndex * @PageSize) + 1          
     
 -- fetch records from temptable    
 SELECT *           
 FROM #Tasks           
 WHERE           
 (RowNo_Order >= @StartIndex AND           
 (          
  @PageSize = 0 OR           
  RowNo_Order < (@StartIndex + @PageSize)          
 ))
 or
 (
  TaskId = @HighLightedTaskID
 )          
 ORDER BY CASE WHEN (TaskId = @HighLightedTaskID) THEN 0 ELSE 1 END , [Sequence]  DESC        
          
 -- fetch other statistics, total records, total pages, pageindex to highlighted.         
 SELECT          
 COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex + 1 AS PageIndex         
  FROM #Tasks          
    
 DROP TABLE #Tasks    
    
        
END 
GO
      
USE JGBS_Dev_New
GO


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_GetLastAvailableSequence]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_GetLastAvailableSequence   

	END
		
GO

-- =============================================  
-- Author:  Yogesh Keraliya  
-- Create date: 05152017  
-- Description: This will load last available sequence for task  
-- =============================================  
CREATE PROCEDURE usp_GetLastAvailableSequence   
(
	@DesignationID INT,
	@IsTechTask BIT
)  
AS  
BEGIN  
  
-- Got MAX allocated sequence to same designation and techtask or non techtask tasks.
SELECT  ISNULL(MAX([Sequence])+1,1) [Sequence] FROM tblTask WHERE [SequenceDesignationId] = @DesignationID AND IsTechTask = @IsTechTask    

  
END        
GO

--SP_HELPTEXT 'usp_GetAllTaskWithSequence'

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_GetAllTaskWithSequence]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_GetAllTaskWithSequence   

	END  
GO    
-- =============================================          
-- Author:  Yogesh Keraliya          
-- Create date: 05222017          
-- Description: This will load all tasks with title and sequence          
-- =============================================          
-- usp_GetAllTaskWithSequence 0,2,'',0,516    
CREATE PROCEDURE usp_GetAllTaskWithSequence           
(          
         
 @PageIndex INT = 0,           
 @PageSize INT =20,    
 @DesignationIds VARCHAR(20) = NULL,    
 @IsTechTask BIT = 0,    
 @HighLightedTaskID BIGINT = NULL    
            
)          
As          
BEGIN          
    
    
IF( @DesignationIds = '' )    
BEGIN    
    
 SET @DesignationIds = NULL    
    
END    
          
          
;WITH           
 Tasklist AS          
 (           
  SELECT DISTINCT TaskId ,[Status],[SequenceDesignationId],[Sequence],         
  Title,ParentTaskId,Assigneduser,IsTechTask,ParentTaskTitle,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,  TaskDesignation,        
  case           
   when (ParentTaskId is null and  TaskLevel=1) then InstallId           
   when (tasklevel =1 and ParentTaskId>0) then           
    (select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId            
   when (tasklevel =2 and ParentTaskId>0) then          
    (select InstallId from tbltask where taskid in (          
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))          
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId           
               
   when (tasklevel =3 and ParentTaskId>0) then          
   (select InstallId from tbltask where taskid in (          
   (select parenttaskid from tbltask where taskid in (          
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))          
   +'-'+          
    (select InstallId from tbltask where taskid in (          
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))          
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId           
  end as 'InstallId' ,Row_number() OVER (order by x.TaskId ) AS RowNo_Order          
  from (          
   select DISTINCT a.*          
   ,(select Title from tbltask where TaskId=(select * from [GetParent](a.TaskId))) AS ParentTaskTitle          
   ,t.FristName + ' ' + t.LastName AS Assigneduser,        
   (        
   STUFF((SELECT ', {"Name": "' + Designation +'","Id":'+ CONVERT(VARCHAR(5),DesignationID)+'}'      
           FROM tblTaskdesignations td         
           WHERE td.TaskID = a.TaskId         
          FOR XML PATH('')), 1, 2, '')        
  )  AS TaskDesignation
  --(SELECT TOP 1 DesignationID       
  --         FROM tblTaskdesignations td         
  --         WHERE td.TaskID = a.TaskId ) AS DesignationId       
   from  tbltask a          
   --LEFT OUTER JOIN tblTaskdesignations as b ON a.TaskId = b.TaskId           
   LEFT OUTER JOIN tbltaskassignedusers as c ON a.TaskId = c.TaskId          
   LEFT OUTER JOIN tblInstallUsers as t ON c.UserId = t.Id            
   WHERE     
  (     
    (a.[Sequence] IS NOT NULL)     
    AND (a.[SequenceDesignationId] IN (SELECT * FROM [dbo].[SplitString](ISNULL(@DesignationIds,a.[SequenceDesignationId]),',') ) )     
    AND (ISNULL(a.[IsTechTask],@IsTechTask) = @IsTechTask)    
       
   )     
   OR    
   (    
     a.TaskId = @HighLightedTaskID    
   )         
   --and (CreatedOn >=@startdate and CreatedOn <= @enddate )           
  ) as x          
 )          
          
 ---- get CTE data into temp table          
 SELECT *          
 INTO #Tasks          
 FROM Tasklist          
    
---- find page number to show taskid sent.    
DECLARE @StartIndex INT  = 0          
    
          
--IF @HighLightedTaskID  > 0    
-- BEGIN    
--  DECLARE @RowNumber BIGINT = NULL    
    
--  -- Find in which rownumber highlighter taskid is.    
--  SELECT @RowNumber = RowNo_Order     
--  FROM #Tasks     
--  WHERE TaskId = @HighLightedTaskID    
    
--  -- if row number found then divide it with page size and round it to nearest integer , so will found pagenumber to be selected.    
--  -- for ex. if total 60 records are there,pagesize is 20 and highlighted task id is at 42 row number than.     
--  -- 42/20 = 2.1 ~ 3 - 1 = 2 = @Page Index    
--  -- StartIndex = (2*20)+1 = 41, so records 41 to 60 will be fetched.    
       
--  IF @RowNumber IS NOT NULL    
--  BEGIN    
--   SELECT @PageIndex = (CEILING(@RowNumber / CAST(@PageSize AS FLOAT))) - 1    
--  END    
-- END      
    
 -- Set start index to fetch record.    
 SET @StartIndex = (@PageIndex * @PageSize) + 1          
     
 -- fetch records from temptable    
 SELECT *           
 FROM #Tasks           
 WHERE           
 (RowNo_Order >= @StartIndex AND           
 (          
  @PageSize = 0 OR           
  RowNo_Order < (@StartIndex + @PageSize)          
 ))
 ORDER BY  [Sequence]  DESC        
 --or
 --(
 -- TaskId = @HighLightedTaskID
 --)          
 --ORDER BY CASE WHEN (TaskId = @HighLightedTaskID) THEN 0 ELSE 1 END , [Sequence]  DESC        
          
 -- fetch other statistics, total records, total pages, pageindex to highlighted.         
 SELECT          
 COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex AS PageIndex         
  FROM #Tasks          
    
 DROP TABLE #Tasks    
    
        
END 

GO

DROP VIEW [dbo].[TaskListView] 
GO

/****** Object:  View [dbo].[TaskListView]    Script Date: 6/7/2017 5:09:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[TaskListView] 
AS
SELECT 
	Tasks.*,

	TaskCreator.Id AS TaskCreatorId,
	TaskCreator.InstallId AS TaskCreatorInstallId,
	TaskCreator.FristName AS TaskCreatorUsername, 
	TaskCreator.FristName AS TaskCreatorFirstName, 
	TaskCreator.LastName AS TaskCreatorLastName, 
	TaskCreator.Email AS TaskCreatorEmail,

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
		LEFT JOIN tblInstallUsers TaskCreator ON TaskCreator.Id = Tasks.CreatedBy
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

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Published on live 06082017

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

USE [JGBS]
GO

/****** Object:  Table [dbo].[tblAssignedSequencing]    Script Date: 6/10/2017 4:06:13 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblAssignedSequencing](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[DesignationId] [int] NOT NULL,
	[AssignedDesigSeq] [bigint] NOT NULL,
	[UserId] [int] NOT NULL,
	[IsTechTask] [bit] NOT NULL,
	[TaskId] [bigint] NOT NULL,
	[CreatedDateTime] [datetime] NULL,
	[ModifiedDateTime] [datetime] NULL,
 CONSTRAINT [PK_tblAssignedSequencing] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tblAssignedSequencing] ADD  CONSTRAINT [DF_tblAssignedSequencing_CreatedDateTime]  DEFAULT (getdate()) FOR [CreatedDateTime]
GO

ALTER TABLE [dbo].[tblAssignedSequencing] ADD  CONSTRAINT [DF_tblAssignedSequencing_ModifiedDateTime]  DEFAULT (getdate()) FOR [ModifiedDateTime]
GO

ALTER TABLE [dbo].[tblAssignedSequencing]  WITH CHECK ADD  CONSTRAINT [FK_tblAssignedSequencing_tblInstallUsers] FOREIGN KEY([UserId])
REFERENCES [dbo].[tblInstallUsers] ([Id])
GO

ALTER TABLE [dbo].[tblAssignedSequencing] CHECK CONSTRAINT [FK_tblAssignedSequencing_tblInstallUsers]
GO

ALTER TABLE [dbo].[tblAssignedSequencing]  WITH CHECK ADD  CONSTRAINT [FK_tblAssignedSequencing_tblTask] FOREIGN KEY([TaskId])
REFERENCES [dbo].[tblTask] ([TaskId])
GO

ALTER TABLE [dbo].[tblAssignedSequencing] CHECK CONSTRAINT [FK_tblAssignedSequencing_tblTask]
GO





IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_GetAllTaskWithSequence]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_GetAllTaskWithSequence   

	END  
GO    


-- =============================================            
-- Author:  Yogesh Keraliya            
-- Create date: 05222017            
-- Description: This will load all tasks with title and sequence            
-- =============================================            
-- usp_GetAllTaskWithSequence 0,20,'',10,575      
CREATE PROCEDURE usp_GetAllTaskWithSequence             
(            
           
 @PageIndex INT = 0,             
 @PageSize INT =20,      
 @DesignationIds VARCHAR(20) = NULL,      
 @IsTechTask BIT = 0,      
 @HighLightedTaskID BIGINT = NULL      
              
)            
As            
BEGIN            
      
      
IF( @DesignationIds = '' )      
BEGIN      
      
 SET @DesignationIds = NULL      
      
END      
            
            
;WITH             
 Tasklist AS            
 (             
  SELECT DISTINCT TaskId ,[Status],[SequenceDesignationId],[Sequence],           
  Title,ParentTaskId,IsTechTask,ParentTaskTitle,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,  TaskDesignation,          
  case             
   when (ParentTaskId is null and  TaskLevel=1) then InstallId             
   when (tasklevel =1 and ParentTaskId>0) then             
    (select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId              
   when (tasklevel =2 and ParentTaskId>0) then            
    (select InstallId from tbltask where taskid in (            
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))            
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId             
                 
   when (tasklevel =3 and ParentTaskId>0) then            
   (select InstallId from tbltask where taskid in (            
   (select parenttaskid from tbltask where taskid in (            
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))            
   +'-'+            
    (select InstallId from tbltask where taskid in (            
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))            
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId             
  end as 'InstallId' ,Row_number() OVER (order by x.TaskId ) AS RowNo_Order            
  from (            
   select DISTINCT a.*            
   ,(select Title from tbltask where TaskId=(select * from [GetParent](a.TaskId))) AS ParentTaskTitle,            
   --,t.FristName + ' ' + t.LastName AS Assigneduser,          
   (          
   STUFF((SELECT ', {"Name": "' + Designation +'","Id":'+ CONVERT(VARCHAR(5),DesignationID)+'}'        
           FROM tblTaskdesignations td           
           WHERE td.TaskID = a.TaskId           
          FOR XML PATH('')), 1, 2, '')          
  )  AS TaskDesignation  
  --(SELECT TOP 1 DesignationID         
  --         FROM tblTaskdesignations td           
  --         WHERE td.TaskID = a.TaskId ) AS DesignationId         
   from  tbltask a            
   --LEFT OUTER JOIN tblTaskdesignations as b ON a.TaskId = b.TaskId             
   --LEFT OUTER JOIN tbltaskassignedusers as c ON a.TaskId = c.TaskId            
  -- LEFT OUTER JOIN tblInstallUsers as t ON c.UserId = t.Id              
   WHERE       
  (       
    (a.[Sequence] IS NOT NULL)       
    AND (a.[SequenceDesignationId] IN (SELECT * FROM [dbo].[SplitString](ISNULL(@DesignationIds,a.[SequenceDesignationId]),',') ) )       
    AND (ISNULL(a.[IsTechTask],@IsTechTask) = @IsTechTask)      
         
   )       
   OR      
   (      
     a.TaskId = @HighLightedTaskID      
   )           
   --and (CreatedOn >=@startdate and CreatedOn <= @enddate )             
  ) as x            
 )            
            
 ---- get CTE data into temp table            
 SELECT *            
 INTO #Tasks            
 FROM Tasklist            
      
---- find page number to show taskid sent.      
DECLARE @StartIndex INT  = 0            
      
            
--IF @HighLightedTaskID  > 0      
-- BEGIN      
--  DECLARE @RowNumber BIGINT = NULL      
      
--  -- Find in which rownumber highlighter taskid is.      
--  SELECT @RowNumber = RowNo_Order       
--  FROM #Tasks       
--  WHERE TaskId = @HighLightedTaskID      
      
--  -- if row number found then divide it with page size and round it to nearest integer , so will found pagenumber to be selected.      
--  -- for ex. if total 60 records are there,pagesize is 20 and highlighted task id is at 42 row number than.       
--  -- 42/20 = 2.1 ~ 3 - 1 = 2 = @Page Index      
--  -- StartIndex = (2*20)+1 = 41, so records 41 to 60 will be fetched.      
         
--  IF @RowNumber IS NOT NULL      
--  BEGIN      
--   SELECT @PageIndex = (CEILING(@RowNumber / CAST(@PageSize AS FLOAT))) - 1      
--  END      
-- END        
      
 -- Set start index to fetch record.      
 SET @StartIndex = (@PageIndex * @PageSize) + 1            
       
 -- fetch records from temptable      
 SELECT *             
 FROM #Tasks             
 WHERE             
 (RowNo_Order >= @StartIndex AND             
 (            
  @PageSize = 0 OR             
  RowNo_Order < (@StartIndex + @PageSize)            
 ))  
 ORDER BY  [Sequence]  DESC          
 --or  
 --(  
 -- TaskId = @HighLightedTaskID  
 --)            
 --ORDER BY CASE WHEN (TaskId = @HighLightedTaskID) THEN 0 ELSE 1 END , [Sequence]  DESC          
            
 -- fetch other statistics, total records, total pages, pageindex to highlighted.           
 SELECT            
 COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex AS PageIndex           
  FROM #Tasks            
      
 DROP TABLE #Tasks      
      
          
END   



DROP VIEW [dbo].[TaskListView] 
GO

/****** Object:  View [dbo].[TaskListView]    Script Date: 6/9/2017 5:44:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[TaskListView] 
AS
SELECT 
	Tasks.*,

	TaskCreator.Id AS TaskCreatorId,
	TaskCreator.InstallId AS TaskCreatorInstallId,
	TaskCreator.FristName AS TaskCreatorUsername, 
	TaskCreator.FristName AS TaskCreatorFirstName, 
	TaskCreator.LastName AS TaskCreatorLastName, 
	TaskCreator.Email AS TaskCreatorEmail,

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
		(SELECT  CAST(', ' + CONVERT(VARCHAR(5), td.DesignationID) as VARCHAR)
		FROM tblTaskDesignations td
		WHERE td.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskDesignationIds,
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
		LEFT JOIN tblInstallUsers TaskCreator ON TaskCreator.Id = Tasks.CreatedBy
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



IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_GetLastAssignedDesigSequencnce]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_GetLastAssignedDesigSequencnce   

	END  
GO    

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 06092017
-- Description:	This will fetch latest sequence assigned to same designation
-- =============================================
 -- usp_GetLastAssignedDesigSequencnce 10,0

CREATE PROCEDURE usp_GetLastAssignedDesigSequencnce 
(	-- Add the parameters for the stored procedure here
	@DesignationId int ,
	@IsTechTask BIT 
)
AS
BEGIN

-- Got MAX allocated sequence to same designation and techtask or non techtask tasks.
SELECT  TOP 1 ISNULL([Sequence],1) AS [AvailableSequence],TaskId, Title FROM tblTask 
WHERE [SequenceDesignationId] = @DesignationID AND IsTechTask = @IsTechTask AND [Sequence] IS NOT NULL AND [Sequence] > (   

		SELECT       ISNULL(MAX(AssignedDesigSeq),0) AS LastAssignedSequence
		 FROM            tblAssignedSequencing
		WHERE        (DesignationId = @DesignationId) AND (IsTechTask = @IsTechTask)

)

ORDER BY [Sequence] ASC

END
GO



IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_InsertLastAssignedDesigSequencnce]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_InsertLastAssignedDesigSequencnce   

	END  
GO    

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 06092017
-- Description:	This will update latest sequence assigned to same designation
-- =============================================
 -- usp_UpdateLastAssignedDesigSequencnce

CREATE PROCEDURE usp_InsertLastAssignedDesigSequencnce 
(	-- Add the parameters for the stored procedure here
	@AssignedSequence BIGINT,
	@DesignationId INT ,
	@IsTechTask BIT,
	@TaskId BIGINT,
	@UserId INT 
)
AS
BEGIN

INSERT INTO tblAssignedSequencing
                         (AssignedDesigSeq, UserId, IsTechTask, TaskId, CreatedDateTime, DesignationId)
VALUES        (@AssignedSequence,@UserId,@IsTechTask,@TaskId, GETDATE(),@DesignationId)

END
GO


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_GetAptTestsByUserID]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_GetAptTestsByUserID   

	END  
GO    


-- =============================================  
-- Author:  Yogesh Keraliya  
-- Create date: 05252017  
-- Description: This will load exams for user based on his designation  
-- =============================================  
-- usp_GetAptTestsByUserID 2934  
CREATE PROCEDURE usp_GetAptTestsByUserID   
(  
 @UserID bigint  
)     
AS  
BEGIN  
   
 DECLARE @DesignationID INT  
  
 -- Get users designation based on its user id.  
    SELECT        @DesignationID = DesignationID  
 FROM            tblInstallUsers  
 WHERE        (Id = @UserID)  
  
  
   IF(@DesignationID IS NOT NULL)  
   BEGIN  
  
      SELECT        MCQ_Exam.ExamID, MCQ_Exam.ExamDuration, MCQ_Exam.ExamTitle, ExamResult.MarksEarned, ExamResult.TotalMarks, ExamResult.[Aggregate], ExamResult.ExamPerformanceStatus, @DesignationID AS DesignationID,
	  (SELECT DesignationName FROM [dbo].[tbl_Designation] WHERE ID = @DesignationID) AS Designation
FROM            MCQ_Exam LEFT OUTER JOIN  
                         MCQ_Performance AS ExamResult ON MCQ_Exam.ExamID = ExamResult.ExamID AND ExamResult.UserID = @UserID  
WHERE        (@DesignationID IN  
                             (SELECT        Item  
                               FROM            dbo.SplitString(MCQ_Exam.DesignationID, ',') AS SplitString_1))  
  
   END  
  
  
  
END  

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 06102017
-- Description:	Get parent task id for given task
-- =============================================
CREATE FUNCTION udf_GetParentTaskId 
(
	
	@TaskId bigint
)
RETURNS BIGINT 
AS
BEGIN

DECLARE @ParentTaskId BIGINT 
	
;WITH MyCTE
AS ( 

SELECT  t.TaskId,t.ParentTaskId
FROM tblTask AS t
WHERE t.ParentTaskId IS NULL

UNION ALL

SELECT t2.TaskId,t2.ParentTaskId
      FROM tblTask AS t2
INNER JOIN MyCTE ON t2.ParentTaskId = MyCTE.TaskId
WHERE t2.ParentTaskId IS NOT NULL 

)



SELECT @ParentTaskId = ParentTaskId
FROM MyCTE 
where TaskId = @TaskId

-- Return the result of the function
RETURN @ParentTaskId

END

GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 06102017
-- Description:	Get combine intall id for task id
-- =============================================
CREATE FUNCTION dbo.udf_GetCombineInstallId
(
	
	@TaskId bigint
)
RETURNS VARCHAR(1000)
AS
BEGIN

DECLARE @InstallId VARCHAR(1000)
	
;WITH MyCTE
AS ( 

SELECT  t.TaskId,t.ParentTaskId, CAST( InstallId AS VARCHAR(1000)) AS InstallId 
FROM tblTask AS t
WHERE t.ParentTaskId IS NULL

UNION ALL

SELECT t2.TaskId,t2.ParentTaskId,  CAST(( MyCTE.InstallId+ ' - ' + t2.InstallId )AS VARCHAR(1000))
      FROM tblTask AS t2
INNER JOIN MyCTE ON t2.ParentTaskId = MyCTE.TaskId
WHERE t2.ParentTaskId IS NOT NULL 

)


SELECT @InstallId = InstallId
FROM MyCTE 
where TaskId = @TaskId

-- Return the result of the function
RETURN @InstallId

END

GO

use jgbs_dev_new
go
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_GetLastAssignedDesigSequencnce]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_GetLastAssignedDesigSequencnce   

	END  
GO    

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 06092017
-- Description:	This will fetch latest sequence assigned to same designation
-- =============================================
 -- usp_GetLastAssignedDesigSequencnce 10,0

CREATE PROCEDURE usp_GetLastAssignedDesigSequencnce 
(	-- Add the parameters for the stored procedure here
	@DesignationId int ,
	@IsTechTask BIT 
)
AS
BEGIN

-- Got MAX allocated sequence to same designation and techtask or non techtask tasks.
SELECT  TOP 1 ISNULL([Sequence],1) AS [AvailableSequence],TaskId, dbo.udf_GetParentTaskId(TaskId) AS ParentTaskId, dbo.udf_GetCombineInstallId(TaskId) AS InstallId , Title FROM tblTask 
WHERE [SequenceDesignationId] = @DesignationID AND IsTechTask = @IsTechTask AND [Sequence] IS NOT NULL AND [Sequence] > (   

		SELECT       ISNULL(MAX(AssignedDesigSeq),0) AS LastAssignedSequence
		 FROM            tblAssignedSequencing
		WHERE        (DesignationId = @DesignationId) AND (IsTechTask = @IsTechTask)

)

ORDER BY [Sequence] ASC

END
GO


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Live publish 06102017

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[GetHTMLTemplateMasters]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [dbo].[GetHTMLTemplateMasters]   

	END  
GO    
 
-- =============================================    
  
-- Author:  Yogesh    
 
-- Create date: 27 Jan 2017    
  
-- Description: Gets all Master HTMLTemplates.    

-- =============================================    
  
CREATE PROCEDURE [dbo].[GetHTMLTemplateMasters]    
(
@UsedFor INT
)  
AS    
  
BEGIN    
  
 SET NOCOUNT ON;    
    
 SELECT * FROM tblHTMLTemplatesMaster  WHERE Id IN (1, 7, 12, 28, 36, 41, 48, 50, 57, 58, 60,69,70,71,72,73,74, 75, 76, 77, 78, 79, 80, 81)   AND UsedFor = @UsedFor  ORDER BY Id ASC    
  
   
END


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_UpdateTemplateFromID]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [dbo].[usp_UpdateTemplateFromID]   

	END  
GO    
 
-- =============================================    
  
-- Author:  Yogesh    
 
-- Create date: 15 June 2017    
  
-- Description: Updates FromID for give html template.

-- =============================================    
  
CREATE PROCEDURE [dbo].[usp_UpdateTemplateFromID]    
(
@Id INT,
@FromID varchar(250)
)  
AS    
  
BEGIN    
  
UPDATE       tblHTMLTemplatesMaster
SET          FromID = @FromID
WHERE        (Id = @Id)

END    


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_UpdateTemplateSubject]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [dbo].[usp_UpdateTemplateSubject]   

	END  
GO    
 
-- =============================================    
  
-- Author:  Yogesh    
 
-- Create date: 15 June 2017    
  
-- Description: Updates Subject for give html template.

-- =============================================    
  
CREATE PROCEDURE [dbo].[usp_UpdateTemplateSubject]    
(
@Id INT,
@Subject varchar(4000)
)  
AS    
  
BEGIN    
  
   UPDATE       tblHTMLTemplatesMaster
	SET             [Subject] = @Subject
   WHERE        (Id = @Id)

END        



IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].usp_UpdateTemplateTriggerText') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [dbo].usp_UpdateTemplateTriggerText   

	END  
GO    
 
-- =============================================    
  
-- Author:  Yogesh    
 
-- Create date: 15 June 2017    
  
-- Description: Updates TriggerText for given html template.

-- =============================================    
  
CREATE PROCEDURE [dbo].[usp_UpdateTemplateTriggerText]    
(
@Id INT,
@TriggerText varchar(5000)
)  
AS    
  
BEGIN    
  
   UPDATE       tblHTMLTemplatesMaster
	SET             [TriggerText] = @TriggerText
   WHERE        (Id = @Id)

END    




IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_UpdateTemplateFrequency]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [dbo].[usp_UpdateTemplateFrequency]   

	END  
GO    
 
-- =============================================    
  
-- Author:  Yogesh    
 
-- Create date: 15 June 2017    
  
-- Description: Updates Frequency details for given html template.

-- =============================================    
  
CREATE PROCEDURE [dbo].[usp_UpdateTemplateFrequency]    
(
@Id INT,
@FrequencyInDays INT,
@FrequencyStartDate Datetime,
@FrequencyStartTime Datetime

)  
AS    
  
BEGIN    
  
   
UPDATE       tblHTMLTemplatesMaster
SET                FrequencyInDays = @FrequencyInDays, FrequencyStartDate = @FrequencyStartDate, FrequencyStartTime = @FrequencyStartTime
WHERE        (Id = @Id)

END    
GO

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[GetSMSTemplateMasters]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [dbo].[GetSMSTemplateMasters]   

	END  
GO      
-- =============================================      
    
-- Author:  Yogesh      
   
-- Create date: 16 June 2017      
    
-- Description: Gets all Master SMSTemplates.      
  
-- =============================================      
    
CREATE PROCEDURE [dbo].[GetSMSTemplateMasters]      
(  
@UsedFor INT  
)    
AS      
    
BEGIN      
    
 SET NOCOUNT ON;      
      
 SELECT * FROM tblHTMLTemplatesMaster  WHERE Id > 81 AND Id < 106 AND UsedFor = @UsedFor  ORDER BY Id ASC      
     
END
 

Declare @TemplateId INT

Declare InsertTemplate CURSOR FOR
SELECT Id FROM tblHTMLTemplatesMaster  WHERE Id IN (1, 7, 12, 28, 36, 41, 48, 50, 57, 58, 60,69,70,71,72,73,74, 75, 76, 77, 78, 79, 80, 81)

Open InsertTemplate
Fetch Next from InsertTemplate INTO @TemplateId
While @@FETCH_STATUS = 0
BEGIN

DECLARE @Id INT
SELECT @Id = MAX(Id) + 1 FROM tblHTMLTemplatesMaster

INSERT INTO tblHTMLTemplatesMaster
                         (Id, [Name], [Subject], Header, Body, Footer, DateUpdated, [Type], Category, FromID, FrequencyInDays, TriggerText, FrequencyStartDate, FrequencyStartTime, UsedFor)
SELECT       @Id , [Name], [Subject], Header, Body, Footer, GETDATE(), [Type], Category, FromID, FrequencyInDays, TriggerText, FrequencyStartDate, FrequencyStartTime, 2
FROM            tblHTMLTemplatesMaster AS tblHTMLTemplatesMaster_1
WHERE        (Id = @TemplateId)        

        Fetch Next from InsertTemplate INTO @TemplateId
END

close InsertTemplate
deallocate InsertTemplate

GO



IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[GetInstallUsersForBulkEmail]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [dbo].[GetInstallUsersForBulkEmail]   

	END  
GO      
-- =============================================      
    
-- Author:  Yogesh      
   
-- Create date: 16 June 2017      
    
-- Description: Gets all Install Users with status Applicant, Referal Applicant,InterviewDate.      
  
-- =============================================      
    
CREATE PROCEDURE [dbo].[GetInstallUsersForBulkEmail]      
(
@DesignationId INT
)
AS      
    
BEGIN      
    
 SET NOCOUNT ON;      
      
 SELECT * FROM tblInstallUsers WHERE [Status] IN ('2','5','10') AND DesignationID = @DesignationId
     
END

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Live publish 06172017

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/****** Object:  Table [dbo].[tblEmailSubscription]    Script Date: 6/19/2017 10:36:13 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblEmailSubscription](
	[UnSubscribeId] [bigint] IDENTITY(1,1) NOT NULL,
	[Email] [varchar](250) NOT NULL,
	[UnSubscribeType] [int] NOT NULL,
	[CreatedDateTime] [datetime] NULL,
 CONSTRAINT [PK_tblEmailSubscription] PRIMARY KEY CLUSTERED 
(
	[UnSubscribeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tblEmailSubscription] ADD  CONSTRAINT [DF_tblEmailSubscription_UnSubscribeType]  DEFAULT ((1)) FOR [UnSubscribeType]
GO

ALTER TABLE [dbo].[tblEmailSubscription] ADD  CONSTRAINT [DF_tblEmailSubscription_CreatedDateTime]  DEFAULT (getdate()) FOR [CreatedDateTime]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This will be type of unsubscription, i.e. User Email might be registered for more than one category of email, like job, marketing etc.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblEmailSubscription', @level2type=N'COLUMN',@level2name=N'UnSubscribeType'
GO




IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_GetAptTestsByUserID]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [dbo].[usp_GetAptTestsByUserID]   

	END  
GO      
  
-- =============================================    
-- Author:  Yogesh Keraliya    
-- Create date: 05252017    
-- Description: This will load exams for user based on his designation    
-- =============================================    
-- usp_GetAptTestsByUserID 3565     
CREATE PROCEDURE usp_AddUnsubscribeEmail    
(    
 @EmailId VARCHAR(250)
)       
AS    
BEGIN    
 
    INSERT INTO tblEmailSubscription
                         (Email, UnSubscribeType)
VALUES        (@EmailId, 1)
    
END    


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_RemoveUnsubscribeEmail]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [dbo].[usp_RemoveUnsubscribeEmail]   

	END  
GO      
  
-- =============================================    
-- Author:  Yogesh Keraliya    
-- Create date: 05252017    
-- Description: This will load exams for user based on his designation    
-- =============================================    
-- usp_GetAptTestsByUserID 3565     
CREATE PROCEDURE usp_RemoveUnsubscribeEmail    
(    
 @EmailId VARCHAR(250)
)       
AS    
BEGIN    
 
    DELETE FROM tblEmailSubscription WHERE Email = @EmailId
    
END

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_GetAptTestsByUserID]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_GetAptTestsByUserID   

	END  
GO    


-- =============================================  
-- Author:  Yogesh Keraliya  
-- Create date: 05252017  
-- Description: This will load exams for user based on his designation  
-- =============================================  
-- usp_GetAptTestsByUserID 2934  
CREATE PROCEDURE usp_GetAptTestsByUserID   
(  
 @UserID bigint  
)     
AS  
BEGIN  
   
 DECLARE @DesignationID INT  
  
 -- Get users designation based on its user id.  
    SELECT        @DesignationID = DesignationID  
 FROM            tblInstallUsers  
 WHERE        (Id = @UserID)  
  
  
   IF(@DesignationID IS NOT NULL)  
   BEGIN  
  
      SELECT        MCQ_Exam.ExamID, MCQ_Exam.ExamDuration, MCQ_Exam.ExamTitle, ExamResult.MarksEarned, ExamResult.TotalMarks, ExamResult.[Aggregate], ExamResult.ExamPerformanceStatus, @DesignationID AS DesignationID,
	  (SELECT DesignationName FROM [dbo].[tbl_Designation] WHERE ID = @DesignationID) AS Designation
FROM            MCQ_Exam LEFT OUTER JOIN  
                         MCQ_Performance AS ExamResult ON MCQ_Exam.ExamID = ExamResult.ExamID AND ExamResult.UserID = @UserID  
WHERE        (@DesignationID IN  
                             (SELECT        Item  
                               FROM            dbo.SplitString(MCQ_Exam.DesignationID, ',') AS SplitString_1))  
			AND MCQ_Exam.IsActive = 1	AND MCQ_Exam.EXAMID IN (SELECT ExamID FROM	MCQ_Question GROUP BY ExamID )
  
   END  
  
  
  
END  

GO
 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Live publish 06202017

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
   Tuesday, June 20, 20179:18:56 PM
   User: jgrovesa
   Server: jgdbserver001.cdgdaha6zllk.us-west-2.rds.amazonaws.com,1433
   Database: JGBS_Dev_New
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblUnsubscriberList
	DROP CONSTRAINT DF_tblEmailSubscription_UnSubscribeType
GO
ALTER TABLE dbo.tblUnsubscriberList
	DROP CONSTRAINT DF_tblEmailSubscription_CreatedDateTime
GO
CREATE TABLE dbo.Tmp_tblUnsubscriberList
	(
	UnSubscribeId bigint NOT NULL IDENTITY (1, 1),
	Email varchar(250) NULL,
	Mobile varchar(50) NULL,
	UnSubscribeType int NOT NULL,
	CreatedDateTime datetime NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblUnsubscriberList SET (LOCK_ESCALATION = TABLE)
GO
DECLARE @v sql_variant 
SET @v = N'This will be type of unsubscription, i.e. User Email might be registered for more than one category of email, like job, marketing etc.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Tmp_tblUnsubscriberList', N'COLUMN', N'UnSubscribeType'
GO
ALTER TABLE dbo.Tmp_tblUnsubscriberList ADD CONSTRAINT
	DF_tblEmailSubscription_UnSubscribeType DEFAULT ((1)) FOR UnSubscribeType
GO
ALTER TABLE dbo.Tmp_tblUnsubscriberList ADD CONSTRAINT
	DF_tblEmailSubscription_CreatedDateTime DEFAULT (getdate()) FOR CreatedDateTime
GO
SET IDENTITY_INSERT dbo.Tmp_tblUnsubscriberList ON
GO
IF EXISTS(SELECT * FROM dbo.tblUnsubscriberList)
	 EXEC('INSERT INTO dbo.Tmp_tblUnsubscriberList (UnSubscribeId, Email, UnSubscribeType, CreatedDateTime)
		SELECT UnSubscribeId, Email, UnSubscribeType, CreatedDateTime FROM dbo.tblUnsubscriberList WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblUnsubscriberList OFF
GO
DROP TABLE dbo.tblUnsubscriberList
GO
EXECUTE sp_rename N'dbo.Tmp_tblUnsubscriberList', N'tblUnsubscriberList', 'OBJECT' 
GO
ALTER TABLE dbo.tblUnsubscriberList ADD CONSTRAINT
	PK_tblEmailSubscription PRIMARY KEY CLUSTERED 
	(
	UnSubscribeId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblUnsubscriberList', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblUnsubscriberList', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblUnsubscriberList', 'Object', 'CONTROL') as Contr_Per 


USE JGBS_Dev_New
GO

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_AddUnsubscribeEmail]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [dbo].[usp_AddUnsubscribeEmail]   

	END  
GO      
  
-- =============================================    
-- Author:  Yogesh Keraliya    
-- Create date: 05252017    
-- Description: This will load exams for user based on his designation    
-- =============================================    
-- usp_GetAptTestsByUserID 3565     
CREATE PROCEDURE usp_AddUnsubscribeEmail    
(    
 @EmailId VARCHAR(250)
)       
AS    
BEGIN    
 
    INSERT INTO tblUnsubscriberList
                         (Email, UnSubscribeType)
VALUES        (@EmailId, 1)
    
END    

GO

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_RemoveUnsubscribeEmail]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [dbo].[usp_RemoveUnsubscribeEmail]   

	END  
GO      
  
-- =============================================    
-- Author:  Yogesh Keraliya    
-- Create date: 05252017    
-- Description: This will load exams for user based on his designation    
-- =============================================    
-- usp_GetAptTestsByUserID 3565     
CREATE PROCEDURE usp_RemoveUnsubscribeEmail    
(    
 @EmailId VARCHAR(250)
)       
AS    
BEGIN    
 
    DELETE FROM tblUnsubscriberList WHERE Email = @EmailId
    
END

GO


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_AddUnsubscribeMobile]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [dbo].[usp_AddUnsubscribeMobile]   

	END  
GO      
  
-- =============================================    
-- Author:  Yogesh Keraliya    
-- Create date: 06202017    
-- Description: This will add any unsubscriber of SMS.    
-- =============================================    
-- usp_GetAptTestsByUserID 3565     
CREATE PROCEDURE usp_AddUnsubscribeMobile    
(    
 @Mobile VARCHAR(250)
)       
AS    
BEGIN    
 
    INSERT INTO tblUnsubscriberList
                         (Mobile, UnSubscribeType)
	VALUES        (@Mobile, 1)
    
END    

GO

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_RemoveUnsubscribeMobile]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [dbo].[usp_RemoveUnsubscribeMobile]   

	END  
GO      
  
-- =============================================    
-- Author:  Yogesh Keraliya    
-- Create date: 05252017    
-- Description: This will remove any mobile from unsubscription list.
-- =============================================    
     
CREATE PROCEDURE usp_RemoveUnsubscribeMobile    
(    
 @Mobile VARCHAR(250)
)       
AS    
BEGIN    
 
    DELETE FROM tblUnsubscriberList WHERE Mobile = @Mobile
    
END

GO

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[USP_ChangeUserStatusToRejectByEmail]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [dbo].[USP_ChangeUserStatusToRejectByEmail]   

	END  
GO 

-- =============================================      
    
-- Author:  Yogesh Keraliya
    
-- Create date: 22 Sep 2016      
    
-- Description: Updates status and status related fields for install user by their email id.      
    
--    Inserts event and event users for interview status.      
    
--    Deletes any exising events and event users for non interview status.      
    
--    Gets install users details.      
    
-- =============================================      
    
CREATE PROCEDURE [dbo].[USP_ChangeUserStatusToRejectByEmail]  
(      
    
 @UserEmail VARCHAR(250),  
  
 @StatusId int = 0,      
    
 @RejectionDate DATE = NULL,      
    
 @RejectionTime VARCHAR(20) = NULL,      
    
 @RejectedUserId int = 0,      
    
 @StatusReason varchar(max) = ''  
    
)      
    
AS      
    
BEGIN    
    
     
    
  -- Updates user status and status related information.      
    
  UPDATE [dbo].[tblInstallUsers]    
    
  SET [Status] = @StatusId    
    
   ,RejectionDate = @RejectionDate    
    
   ,RejectionTime = @RejectionTime    
    
   ,InterviewTime = @RejectionTime    
    
   ,RejectedUserId = @RejectedUserId    
    
   ,StatusReason = @StatusReason    
    
  WHERE Email = @UserEmail  
    
  
END    


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[USP_ChangeUserStatusToRejectByMobile]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [dbo].[USP_ChangeUserStatusToRejectByMobile]   

	END  
GO 

-- =============================================      
    
-- Author:  Yogesh Keraliya
    
-- Create date: 22 Sep 2016      
    
-- Description: Updates status and status related fields for install user by their mobile.      
    
--    Inserts event and event users for interview status.      
    
--    Deletes any exising events and event users for non interview status.      
    
--    Gets install users details.      
    
-- =============================================      
    
CREATE PROCEDURE [dbo].[USP_ChangeUserStatusToRejectByMobile]  
(      
    
 @UserMobile VARCHAR(20),  
  
 @StatusId int = 0,      
    
 @RejectionDate DATE = NULL,      
    
 @RejectionTime VARCHAR(20) = NULL,      
    
 @RejectedUserId int = 0,      
    
 @StatusReason varchar(max) = ''  
    
)      
    
AS      
    
BEGIN    
    
     
    
  -- Updates user status and status related information.      
    
  UPDATE [dbo].[tblInstallUsers]    
    
  SET [Status] = @StatusId    
    
   ,RejectionDate = @RejectionDate    
    
   ,RejectionTime = @RejectionTime    
    
   ,InterviewTime = @RejectionTime    
    
   ,RejectedUserId = @RejectedUserId    
    
   ,StatusReason = @StatusReason    
    
  WHERE Phone = @UserMobile  
    
  
END  


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_RevertTemplatesToMasterHTMLTemplate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [dbo].usp_RevertTemplatesToMasterHTMLTemplate   

	END  
GO 


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 06/21/2017
-- Description:	This will revert all child templates of master HTML template for given HTML template ID
-- =============================================
CREATE PROCEDURE usp_RevertTemplatesToMasterHTMLTemplate
( 
	-- Add the parameters for the stored procedure here
	@MasterTemplateID int 
)
AS
BEGIN

-- get master template header, body, footer, subject
DECLARE @Subject VARCHAR(4000)
DECLARE @Header VARCHAR(max)
DECLARE @Body VARCHAR(max)
DECLARE @Footer VARCHAR(max)

SELECT       @Subject = [Subject], @Header = Header, @Body = Body, @Footer = Footer
FROM            tblHTMLTemplatesMaster
WHERE        (Id = @MasterTemplateID)

-- update already existing designation html templates.
UPDATE       tblDesignationHTMLTemplates
SET                [Subject] = @Subject, Header = @Header, Body = @Body, Footer = @Footer, DateUpdated = GETDATE()
WHERE [HTMLTemplatesMasterId] = @MasterTemplateID


-- Insert templates which are not already available.
INSERT INTO tblDesignationHTMLTemplates
                         (Designation,[Subject], Header, Body, Footer, DateUpdated, HTMLTemplatesMasterId)
SELECT   CONVERT(VARCHAR(50), D.ID) , @Subject, @Header, @Body, @Footer, GETDATE(), @MasterTemplateID
FROM     [dbo].[tbl_Designation] AS D 
WHERE  D.IsActive = 1 AND D.ID NOT IN (SELECT CONVERT(INT,Designation) FROM tblDesignationHTMLTemplates WHERE HTMLTemplatesMasterId = @MasterTemplateID)

END
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 060212017
-- Description:	This will get aggregate % for user's given exam if any
-- =============================================
CREATE FUNCTION [dbo].[udf_GetUserExamPercentile] 
(	
	@UserID INT
)
RETURNS FLOAT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @AggregateScored FLOAT = NULL
    DECLARE @ExamCount INT  
    DECLARE @GivenExamCount INT  
  
  
    -- check exams given by user  
    SELECT @GivenExamCount = COUNT(ExamID) FROM MCQ_Performance WHERE UserID = @UserID  
  
    
    
IF( @GivenExamCount > 0 )
BEGIN

SELECT @AggregateScored = (SUM([Aggregate])/@GivenExamCount) FROM MCQ_Performance  WHERE UserID = @UserID   

END

-- Return the result of the function
RETURN @AggregateScored

END
GO


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_updateMasterHTMLTemplate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [dbo].usp_updateMasterHTMLTemplate   

	END  
GO 


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 06/21/2017
-- Description:	This will update master template data for given HTML template ID
-- =============================================
CREATE PROCEDURE usp_updateMasterHTMLTemplate
( 	-- Add the parameters for the stored procedure here
	@MasterTemplateID int,
	@Subject VARCHAR(4000),
	@Header VARCHAR(max),
	@Body VARCHAR(max),
	@Footer VARCHAR(max)
)
AS
BEGIN

UPDATE       tblHTMLTemplatesMaster
SET                [Subject] = @Subject, Header = @Header, Body = @Body, Footer = @Footer, DateUpdated = GETDATE()
WHERE [Id] = @MasterTemplateID


END
GO


USE JGBS_Dev_New
GO

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[sp_GetHrData]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [dbo].[sp_GetHrData]   

	END  
GO 

-- =============================================      
-- Author:  Yogesh      
-- Create date: 16 Jan 2017      
-- Description: Gets statictics and records for edit user page.      
-- =============================================      
-- [sp_GetHrData] '0','0','0', '0', NULL,NULL,0,10      
CREATE PROCEDURE [dbo].[sp_GetHrData]      
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
 @RejectedStatus VARChAR(5) = '9',      
 @OfferMadeStatus VARChAR(5) = '6',      
 @ActiveStatus VARChAR(5) = '1'    
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
  ISNULL(U.Username, t2.FristName + '' + t2.LastName)  AS AddedBy, COUNT(*) [Count]       
 FROM       
  tblInstallUsers t   
     
   LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser      
   LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser  
   LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id      
   LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id   
        
 WHERE        
  (t.UserType = 'SalesUser' OR t.UserType = 'sales')      
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)       
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)      
 GROUP BY U.Username,t2.FristName,t2.LastName      
      
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
   ISNULL(U.Username,t2.FristName + ' ' + t2.LastName)  AS AddedBy ,      
    ISNULL (t.UserInstallId ,t.id) As UserInstallId ,       
   InterviewDetail = case       
         when (t.Status=@InterviewDateStatus) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR)  + ' ' + coalesce(t.InterviewTime,'')       
         else '' end,      
   RejectDetail = case when (t.[Status]=@RejectedStatus ) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR) + ' ' + coalesce(t.RejectionTime,'') + ' ' + '-' + coalesce(ru.LastName,'')       
         else '' end,      
   t.Email,       
   t.DesignationID,       
   ISNULL(t1.[UserInstallId] , t2.[UserInstallId]) As AddedByUserInstallId,       
   ISNULL(t1.Id,t2.Id) As AddedById ,       
   0 as 'EmpType',         
   t.Phone As PrimaryPhone ,       
   t.CountryCode,       
   t.Resumepath  ,    
   --ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId ,     
   Task.TaskId AS 'TechTaskId',  
   Task.ParentTaskId AS 'ParentTechTaskId',   
   Task.InstallId as 'TechTaskInstallId',     
   bm.bookmarkedUser, 
   t.[StatusReason],
   dbo.udf_GetUserExamPercentile(t.Id) AS [Aggregate] ,
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
    LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser  
 LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id      
    LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id         
    LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id        
    LEFT JOIN tblSource s ON t.SourceId = s.Id      
  left outer join InstallUserBMLog as bm on t.id  =bm.bookmarkedUser and bm.isDeleted=0  
 OUTER APPLY  
 (  
  SELECT TOP 1 tsk.TaskId, tsk.ParentTaskId, tsk.InstallId, ROW_NUMBER() OVER(ORDER BY u.TaskUserId DESC) AS RowNo  
  FROM tblTaskAssignedUsers u   
    INNER JOIN tblTask tsk ON u.TaskId = tsk.TaskId AND   
     (tsk.ParentTaskId IS NOT NULL OR tsk.IsTechTask = 1)   
  WHERE u.UserId = t.Id  
 ) AS Task  
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
   AND t.Status NOT IN (@OfferMadeStatus, @ActiveStatus)    
   AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))      
   AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))      
   --AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))      
   AND ISNULL(t1.Id,t2.Id)=ISNULL(@AddedByUserId,ISNULL(t1.Id,t2.Id))      
   AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)       
   AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)      
 )      
      
 SELECT Id,      
   FristName,      
   LastName,      
   Phone,      
   Zip,      
    Designation,      
   Status,      
   HireDate,      
   InstallId,      
   picture,       
   CreatedDateTime,       
   Source,      
   SourceUser,       
   AddedBy ,      
    UserInstallId ,       
   InterviewDetail,      
   RejectDetail,      
   Email,       
   DesignationID,       
     AddedByUserInstallId,       
   AddedById ,       
   EmpType  ,    
    [Aggregate] ,      
    PrimaryPhone ,       
   CountryCode,       
   Resumepath  ,    
   TechTaskId ,  
   ParentTechTaskId ,  
   TechTaskInstallId   ,   
   bookmarkedUser,
   [StatusReason]  
 FROM SalesUsers      
 WHERE       
  RowNumber >= @StartIndex AND       
  (      
   @PageSize = 0 OR       
   RowNumber < (@StartIndex + @PageSize)      
  )      
    group by   
   Id,      
   FristName,      
   LastName,      
   Phone,      
   Zip,      
   Designation,      
   [Status],      
   HireDate,      
   InstallId,      
   picture,       
   CreatedDateTime,       
   Source,      
   SourceUser,       
   AddedBy ,      
    UserInstallId ,       
   InterviewDetail,      
   RejectDetail,      
   Email,       
   DesignationID,       
     AddedByUserInstallId,       
   AddedById ,       
   EmpType  ,    
    [Aggregate] ,      
    PrimaryPhone ,       
   CountryCode,       
   Resumepath  ,    
   TechTaskId ,  
   ParentTechTaskId ,  
   TechTaskInstallId   ,   
   bookmarkedUser,
   [StatusReason]
      
   ORDER BY      
         CASE WHEN @SortExpression = 'Id ASC' THEN Id END ASC,      
         CASE WHEN @SortExpression = 'Id DESC' THEN Id END DESC,      
         CASE WHEN @SortExpression = 'Status ASC' THEN Status END ASC,      
         CASE WHEN @SortExpression = 'Status DESC' THEN Status END DESC,      
         CASE WHEN @SortExpression = 'FristName ASC' THEN FristName END ASC,      
         CASE WHEN @SortExpression = 'FristName DESC' THEN FristName END DESC,      
         CASE WHEN @SortExpression = 'Designation ASC' THEN Designation END ASC,      
         CASE WHEN @SortExpression = 'Designation DESC' THEN Designation END DESC,      
         CASE WHEN @SortExpression = 'Source ASC' THEN Source END ASC,      
         CASE WHEN @SortExpression = 'Source DESC' THEN Source END DESC,      
         CASE WHEN @SortExpression = 'Phone ASC' THEN Phone END ASC,      
         CASE WHEN @SortExpression = 'Phone DESC' THEN Phone END DESC,      
         CASE WHEN @SortExpression = 'Zip ASC' THEN Phone END ASC,      
         CASE WHEN @SortExpression = 'Zip DESC' THEN Phone END DESC,      
         CASE WHEN @SortExpression = 'CreatedDateTime ASC' THEN CreatedDateTime END ASC,      
         CASE WHEN @SortExpression = 'CreatedDateTime DESC' THEN CreatedDateTime END DESC      
  
      
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
  AND t.Status NOT IN (@OfferMadeStatus, @ActiveStatus)       
  AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))      
  AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))      
  AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))      
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)       
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)      
END  


----------------------------------------------------------------------------------------------------------------------------------------

-- Live Published on 06212017

----------------------------------------------------------------------------------------------------------------------------------------


 USE [JGBS_Dev_New]
GO

/****** Object:  Table [dbo].[tblDesignationPayRates]    Script Date: 5/4/2018 10:54:23 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblDesignationPayRates](
	[PayRateId] [int] IDENTITY(1,1) NOT NULL,
	[DesignationId] [int] NOT NULL,
	[EmploymentType] [int] NOT NULL,
	[BaseRate] [smallmoney] NOT NULL,
	[DisplayRate] [smallmoney] NULL,
	[DisplayRateCurrencyCode] [nvarchar](10) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_DesignationPayRates] PRIMARY KEY CLUSTERED 
(
	[PayRateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tblDesignationPayRates] ADD  CONSTRAINT [DF_DesignationPayRates_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[tblDesignationPayRates] ADD  CONSTRAINT [DF_DesignationPayRates_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

ALTER TABLE [dbo].[tblDesignationPayRates]  WITH CHECK ADD  CONSTRAINT [FK_DesignationPayRates_tbl_Designation] FOREIGN KEY([DesignationId])
REFERENCES [dbo].[tbl_Designation] ([ID])
GO

ALTER TABLE [dbo].[tblDesignationPayRates] CHECK CONSTRAINT [FK_DesignationPayRates_tbl_Designation]
GO

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[usp_InsertPayRate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
    BEGIN
 
    DROP PROCEDURE [usp_InsertPayRate]

    END  
GO    

/****** Object:  StoredProcedure [dbo].[usp_InsertPayRate]    Script Date: 5/4/2018 11:01:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =======================================================================
-- Author:		Yogesh Keraliya
-- Create date: 05042018
-- Description:	Insert Payrate for given designation and employment type
-- =======================================================================
CREATE PROCEDURE [dbo].[usp_InsertPayRate] 
(
	@DesigntionId int , 
	@EmploymentType int ,
	@BaseRate smallmoney,
	@DisplayRate smallmoney,
	@DisplayRateCurrencyCode nvarchar(10) = NULL,
	@CreatedDate datetime = NULL,
	@CreatedBy  int = NULL
)
AS
BEGIN

IF EXISTS (SELECT PayRateId FROM tblDesignationPayRates WHERE  DesignationId = @DesigntionId AND  EmploymentType = @EmploymentType )
	BEGIN
		
		UPDATE tblDesignationPayRates
							 SET BaseRate = @BaseRate, DisplayRate = @DisplayRate, DisplayRateCurrencyCode = @DisplayRateCurrencyCode, ModifiedDate = GETDATE(), ModifiedBy = @CreatedBy
		WHERE  DesignationId = @DesigntionId AND  EmploymentType = @EmploymentType				
	
	END

ELSE
	BEGIN

		INSERT INTO tblDesignationPayRates
							 (DesignationId, EmploymentType, BaseRate, DisplayRate, DisplayRateCurrencyCode, CreatedDate, CreatedBy)
		VALUES        (@DesigntionId,@EmploymentType,@BaseRate,@DisplayRate,@DisplayRateCurrencyCode,GETDATE(),@CreatedBy) 
		
	END



END


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[usp_GetDesignationPayRate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
    BEGIN
 
    DROP PROCEDURE [usp_GetDesignationPayRate]

    END  
GO    

/****** Object:  StoredProcedure [usp_GetDesignationPayRate]    Script Date: 5/4/2018 11:01:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================
-- Author:		Yogesh Keraliya
-- Create date: 05042018
-- Description:	Get Payrate for given designation id
-- =================================================================================================
CREATE PROCEDURE [dbo].[usp_GetDesignationPayRate] 
(
	@DesignationId int,
	@EmploymentType int
)
AS
BEGIN

SELECT PayRateId,DesignationId, EmploymentType, BaseRate, DisplayRate, DisplayRateCurrencyCode FROM tblDesignationPayRates
                         
WHERE  DesignationId = @DesignationId AND  EmploymentType = @EmploymentType

END


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[usp_GetPayRateById]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
    BEGIN
 
    DROP PROCEDURE [usp_GetPayRateById]

    END  
GO    

/****** Object:  StoredProcedure [usp_GetPayRateById]    Script Date: 5/4/2018 11:01:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===================================================================
-- Author:		Yogesh Keraliya
-- Create date: 05042018
-- Description:	Get Payrate for given payrate id
-- ===================================================================
CREATE PROCEDURE [dbo].[usp_GetPayRateById] 
(
	@PayrateId int	
)
AS
BEGIN

SELECT PayrateId,DesignationId, EmploymentType, BaseRate, DisplayRate, DisplayRateCurrencyCode FROM tblDesignationPayRates
                         
WHERE  PayrateId = @PayrateId

END



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[usp_GetDesignationPayRates]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
    BEGIN
 
    DROP PROCEDURE [usp_GetDesignationPayRates]

    END  
GO    

/****** Object:  StoredProcedure [usp_GetDesignationPayRates]    Script Date: 5/4/2018 11:01:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================
-- Author:		Yogesh Keraliya
-- Create date: 05042018
-- Description:	Get Payrate for given designation id
-- =================================================================================================
CREATE PROCEDURE [dbo].[usp_GetDesignationPayRates] 
(
	@DesignationId int
)
AS
BEGIN

SELECT tdp.PayRateId,tdp.DesignationId,td.DesignationName, tdp.EmploymentType, tdp.BaseRate, tdp.DisplayRate, tdp.DisplayRateCurrencyCode FROM tblDesignationPayRates AS tdp   
INNER JOIN tbl_Designation AS td ON tdp.DesignationId = td.ID  
                           
WHERE  tdp.DesignationId = @DesignationId   


END



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[UDP_ChangeStatus]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
    BEGIN
 
    DROP PROCEDURE [UDP_ChangeStatus]

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
 SET         
   Status = @Status        
  ,RejectionDate = @RejectionDate        
  ,RejectionTime = @RejectionTime        
  ,InterviewTime = @RejectionTime        
  ,RejectedUserId = @RejectedUserId        
  ,StatusReason = @StatusReason        
 WHERE Id = @Id        
        
  IF @Status = '2'    
 BEGIN    
   -- Updates user status and status related information.        
   UPDATE [dbo].[tblInstallUsers]        
   SET         
       
   RejectedUserId = NULL    
    ,RejectionDate = NULL        
    ,RejectionTime = NULL        
    
   WHERE Id = @Id     
    
 END    
    
 -- Add event and event users for Interview status.        
 IF @Status = @InterviewDateStatus        
 BEGIN        
  INSERT INTO tbl_AnnualEvents(EventName,EventDate,EventAddedBy,ApplicantId,IsInstallUser)        
   VALUES('InterViewDetails',@RejectionDate,@RejectedUserId,@Id,@IsInstallUser)        
        
  IF @UserIds IS NOT NULL        
  BEGIN        
   DECLARE @EventID INT        
   SELECT @EventID = SCOPE_IDENTITY()        
        
   INSERT INTO tbl_AnnualEventAssignedUsers([EventId], [UserId])        
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
 SELECT tiu.Email, tiu.HireDate, tiu.EmpType, CASE WHEN (tiu.PayRates IS NULL OR tiu.PayRates = '' OR tiu.PayRates = 0)  
 THEN (SELECT Convert(VARCHAR(7),DisplayRate) + ' ' + DisplayRateCurrencyCode FROM tblDesignationPayRates WHERE DesignationId = tiu.DesignationId AND EmploymentType = tiu.[EmpType]) ELSE tiu.PayRates  END AS PayRates , tiu.Designation, tiu.FristName, tiu.
LastName, tiu.[Address],tiu.GitUserName          
 FROM tblInstallUsers AS tiu         
 WHERE tiu.Id = @Id        
  


END      
    
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Live 05132018

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO [dbo].[tblHTMLTemplatesMaster]
           (
		   [Id]
           ,[Name]
           ,[Subject]
           ,[Header]
           ,[Body]
           ,[Footer]
           ,[DateUpdated]
           ,[Type]
           ,[Category]           
           ,[UsedFor]
		   )
     VALUES
           (107
           ,'Carrer_Path'
           ,'Carrer path bifurcated by designation Id'
           ,'<div><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/header.jpg" /></div>  <div><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/logo.gif" /></div>'
           ,'<p class="MsoNormal">Carrer Path Master</p>'
           ,'<p>J.M. Grove - Construction &amp; Supply <br />  <a href="jmgroveconstruction.com">jmgroveconstruction.com </a><br />  <a href="http://jmgrovebuildingsupply.com/"> http://jmgrovebuildingsupply.com/</a><br />  <a href="http://web.jmgrovebuildingsupply.com/login.aspx">http://web.jmgrovebuildingsupply.com/login.aspx</a><br />  <a href="http://jmgroverealestate.com/">http://jmgroverealestate.com/</a><br />  <br />   72 E Lancaster Ave<br />  Malvern, Pa 19355<br />  Human Resources<br />  Office:(215) 274-5182 Ext. 4<br />  <a href="mailto:Hr@jmgroveconstruction.com">Hr@jmgroveconstruction.com </a></p>  <div><a href="https://www.facebook.com/JMGrove1com/"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/fb.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/twitter_zpsiiplyhiq.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/tw.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/236e0d0b-832c-4543-81a6-f6c460d302f0_zpsl4nh3ane.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/gpls.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/pinterest_zpspioq6pve.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/pint.png" /></a><br />   <a href="http://s49.photobucket.com/user/jmg1/media/twitter_zpsiiplyhiq.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/hbt.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/youtube_zpsxyhfmm1b.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/yt.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/c3894afd-7a37-43e2-917c-5ffb7a5036a2_zpschul0pqd.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/houzz.png" /></a> <a href="http://s49.photobucket.com/user/jmg1/media/4478596b-67f4-444e-992a-624af3e56255_zpsoi8p1uyv.jpg.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/linkin.jpg" /></a></div>  <div><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/footer.png" /></div>'
           ,'2018-05-14'
           ,2
           ,1           
           ,1)
GO



-- =============================================        
      
-- Author:  Yogesh        
     
-- Create date: 27 Jan 2017        
      
-- Description: Gets all Master HTMLTemplates.        
    
-- =============================================        
      
ALTER PROCEDURE [dbo].[GetHTMLTemplateMasters]        
(    
@UsedFor INT    
)      
AS        
      
BEGIN        
      
 SET NOCOUNT ON;        
        
 SELECT * FROM tblHTMLTemplatesMaster  WHERE Id IN (1, 7, 12, 28, 36, 41, 48, 50, 57, 58, 60,69,70,71,72,73,74, 75, 76, 77, 78, 79, 80, 81,104,105,107)   AND UsedFor = @UsedFor  ORDER BY Id ASC        
      
       
END    


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Live 05172018

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO [dbo].[tblHTMLTemplatesMaster]
           (
		   [Id]
           ,[Name]
           ,[Subject]
           ,[Header]
           ,[Body]
           ,[Footer]
           ,[DateUpdated]
           ,[Type]
           ,[Category]           
           ,[UsedFor]
		   )
     VALUES
           (108
           ,'Legal_Desclaimer'
           ,'Legal disclaimer for each designation'
           ,'<div><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/header.jpg" /></div>  <div><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/logo.gif" /></div>'
           ,'<p class="MsoNormal">Legal Disclaimer</p>'
           ,'<p>J.M. Grove - Construction &amp; Supply <br />  <a href="jmgroveconstruction.com">jmgroveconstruction.com </a><br />  <a href="http://jmgrovebuildingsupply.com/"> http://jmgrovebuildingsupply.com/</a><br />  <a href="http://web.jmgrovebuildingsupply.com/login.aspx">http://web.jmgrovebuildingsupply.com/login.aspx</a><br />  <a href="http://jmgroverealestate.com/">http://jmgroverealestate.com/</a><br />  <br />   72 E Lancaster Ave<br />  Malvern, Pa 19355<br />  Human Resources<br />  Office:(215) 274-5182 Ext. 4<br />  <a href="mailto:Hr@jmgroveconstruction.com">Hr@jmgroveconstruction.com </a></p>  <div><a href="https://www.facebook.com/JMGrove1com/"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/fb.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/twitter_zpsiiplyhiq.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/tw.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/236e0d0b-832c-4543-81a6-f6c460d302f0_zpsl4nh3ane.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/gpls.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/pinterest_zpspioq6pve.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/pint.png" /></a><br />   <a href="http://s49.photobucket.com/user/jmg1/media/twitter_zpsiiplyhiq.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/hbt.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/youtube_zpsxyhfmm1b.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/yt.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/c3894afd-7a37-43e2-917c-5ffb7a5036a2_zpschul0pqd.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/houzz.png" /></a> <a href="http://s49.photobucket.com/user/jmg1/media/4478596b-67f4-444e-992a-624af3e56255_zpsoi8p1uyv.jpg.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/linkin.jpg" /></a></div>  <div><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/footer.png" /></div>'
           ,'2018-06-05'
           ,2
           ,1           
           ,1)
GO



-- =============================================        
      
-- Author:  Yogesh        
     
-- Create date: 27 Jan 2017        
      
-- Description: Gets all Master HTMLTemplates.        
    
-- =============================================        
      
ALTER PROCEDURE [dbo].[GetHTMLTemplateMasters]        
(    
@UsedFor INT    
)      
AS        
      
BEGIN        
      
 SET NOCOUNT ON;        
        
 SELECT * FROM tblHTMLTemplatesMaster  WHERE Id IN (1, 7, 12, 28, 36, 41, 48, 50, 57, 58, 60,69,70,71,72,73,74, 75, 76, 77, 78, 79, 80, 81,104,105,107,108)   AND UsedFor = @UsedFor  ORDER BY Id ASC        
      
       
END    



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Live 06052018

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

 