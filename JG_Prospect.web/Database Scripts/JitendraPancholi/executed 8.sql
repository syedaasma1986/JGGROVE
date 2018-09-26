 /* =============================================      
 Author:  Jitendra Pancholi      
 Create date: 07-Nov-2017
 Updated By: Jitendra Pancholi
 Updated On: 15-Nov-2017
 Description: This will free all tasks which were assigned to the users whose interview date has expired.
 ============================================= */
Go
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'FreeTaskIfInterviewPassed')
  BEGIN
      DROP PROCEDURE FreeTaskIfInterviewPassed
  END
 Go
Create Procedure FreeTaskIfInterviewPassed
As
Begin
	Declare @Min int, @Max int, @InterviewDate Date, @UserID  INT
	IF OBJECT_ID('tempdb..#InterviewDetails') IS NOT NULL DROP TABLE #InterviewDetails
		CREATE TABLE #InterviewDetails (Id int identity(1,1), InterviewDate Date, UserID  INT)
	
	/* Fetch all users with interview date expired */
	Insert Into #InterviewDetails (InterviewDate, UserID)
	Select Distinct E.EventDate, E.ApplicantId From tbl_AnnualEvents E With(NoLock) 
		Where E.EventDate < CAST(GetDate() as date) 
			And E.EventName = 'InterViewDetails' And E.IsInstallUser = 1

	/* Creating Task History */
	Select @Min = Min(Id), @Max = Max(Id) From #InterviewDetails
	While @Min <= @Max
		Begin
			If Not Exists (Select 1 from InstallUserTaskHistory H Join tblAssignedSequencing S
				on H.TaskID = S.TaskId And H.InstallUserId = S.UserId)
				Begin
					Select @UserID = UserId From #InterviewDetails Where Id = @Min
						Insert Into InstallUserTaskHistory(InstallUserId, TaskId, AssignedOn)
							Select S.UserId, S.TaskId, S.CreatedDateTime from tblAssignedSequencing S Where UserId = @UserID
						Set @Min = @Min + 1
				End
		End
	
	/* Delete tasks of those users from tblAssignedSequencing table so that task can be assigned to other users */
	Delete from tblAssignedSequencing Where UserId in (Select UserID from #InterviewDetails)
	
	/* Change User status to InterviewDateExpired with enum value 16 */
	Update tblInstallUsers Set [Status] = 16 Where Id in (Select UserID from #InterviewDetails) And [Status] = 5
End

Go
GO
-- =============================================      
-- Author:  Yogesh Keraliya      
-- Create date: 06092017      
-- Description: This will fetch latest sequence assigned to same designation  
-- Modified By: Jitendra Pancholi
-- Modified On: 07-Nov-2017    
-- =============================================      
 -- usp_GetUserAssignedDesigSequencnce 10,1,3797
-- usp_GetUserAssignedDesigSequencnce 10,1,2653        
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'usp_GetUserAssignedDesigSequencnce')
  BEGIN
      DROP PROCEDURE usp_GetUserAssignedDesigSequencnce
  END
 Go
Create PROCEDURE [dbo].[usp_GetUserAssignedDesigSequencnce]       
( -- Add the parameters for the stored procedure here      
 @DesignationId INT ,      
 @IsTechTask BIT,    
 @UserID  INT      
)      
AS      
BEGIN      
    
-- Check if already assigned sequence available to given user.    
    
IF NOT EXISTS ( SELECT [Id] FROM tblAssignedSequencing WHERE UserId = @UserID)    
BEGIN    
    
 
  IF(@DesignationId = 5 OR @DesignationId = 23)
  BEGIN

   INSERT INTO tblAssignedSequencing      
     (AssignedDesigSeq, UserId, IsTechTask, TaskId, CreatedDateTime, DesignationId,IsTemp)      
   SELECT  TOP 1 ISNULL([Sequence],1), @UserID, @IsTechTask , TaskId, GETDATE() , @DesignationId, 1 FROM tblTask       
   WHERE (AdminUserId IS NOT NULL AND TechLeadUserId IS NOT NULL ) AND [SequenceDesignationId] = @DesignationID 
   AND IsTechTask = @IsTechTask AND [Sequence] IS NOT NULL    
   and TaskId not in -- Added by Jitendra
	(Select Distinct S.TaskId From tbl_AnnualEvents E With(NoLock) -- Added by Jitendra
	Join tblAssignedSequencing S on E.ApplicantId = S.UserId -- Added by Jitendra
	Where E.EventDate >= CAST(GetDate() as date) -- Added by Jitendra
			And E.EventName = 'InterViewDetails' And E.IsInstallUser = 1)  -- Added by Jitendra    
   ORDER BY [Sequence] ASC       

  END
  ELSE
   BEGIN

    INSERT INTO tblAssignedSequencing      
           (AssignedDesigSeq, UserId, IsTechTask, TaskId, CreatedDateTime, DesignationId,IsTemp)      
    SELECT  TOP 1 ISNULL([Sequence],1), @UserID, @IsTechTask , TaskId, GETDATE() , @DesignationId, 1 FROM tblTask       
    WHERE (AdminUserId IS NOT NULL AND TechLeadUserId IS NOT NULL ) AND [SequenceDesignationId] = @DesignationID 
    AND IsTechTask = @IsTechTask AND [Sequence] IS NOT NULL AND [Sequence] > (         
      
      SELECT       ISNULL(MAX(AssignedDesigSeq),0) AS LastAssignedSequence      
       FROM            tblAssignedSequencing      
      WHERE        (DesignationId = @DesignationId) AND (IsTechTask = @IsTechTask)      
    And IsTemp = 1 -- Added by Jitendra
    )  and TaskId not in -- Added by Jitendra
	(Select Distinct S.TaskId From tbl_AnnualEvents E With(NoLock) -- Added by Jitendra
	Join tblAssignedSequencing S on E.ApplicantId = S.UserId -- Added by Jitendra
	Where E.EventDate >= CAST(GetDate() as date) -- Added by Jitendra
			And E.EventName = 'InterViewDetails' And E.IsInstallUser = 1)  -- Added by Jitendra    
    ORDER BY [Sequence] ASC       

   END
END   

-- Get newly assigned sequence from inserted sequence / Already assigned sequence      
SELECT  Id,[AssignedDesigSeq] AS [AvailableSequence],TBA.TaskId, dbo.udf_GetParentTaskId(TBA.TaskId) AS ParentTaskId,       
(SELECT Title FROM tblTask WHERE TaskId =  dbo.udf_GetParentTaskId(TBA.TaskId)) AS ParentTitle , dbo.udf_GetCombineInstallId(TBA.TaskId) AS InstallId , T.Title       
      
FROM tblTask AS T       
      
INNER JOIN tblAssignedSequencing AS TBA ON TBA.TaskId = T.TaskId      
       
WHERE TBA.UserId = @UserId AND TBA.IsTemp = 1        

End


Go
-- =============================================  
-- Author:  Yogesh Keraliya  
-- Create date: 06092017  
-- Description: This will update user assigned sequence status to accepted.
-- Modified By: Jitendra Pancholi
-- Modified On: 07-Nov-2017
-- =============================================  
  
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'usp_UpdateUserAssignedSeqAcceptance')
  BEGIN
      DROP PROCEDURE usp_UpdateUserAssignedSeqAcceptance
  END
 Go
Create PROCEDURE [dbo].[usp_UpdateUserAssignedSeqAcceptance]   
(   
 @AssignedSeqID INT
)  
AS  
BEGIN
 /*  Delete the task for all other users who did not accept yet and reasign a new task for each user */
 Declare @TaskId bigint, @UserId int, @Start int, @End int
 Declare @DesignationId INT, @IsTechTask BIT
 IF OBJECT_ID('tempdb..#UserTasks') IS NOT NULL DROP TABLE #UserTasks
 CREATE TABLE #UserTasks (Id int identity(1,1), DesignationId INT , IsTechTask BIT,UserID  INT)

 Select @TaskId = S.TaskId, @UserId = S.UserId From tblAssignedSequencing S Where S.Id = @AssignedSeqID

 Insert Into #UserTasks
 Select S.DesignationId, S.IsTechTask, S.UserId From tblAssignedSequencing S With(NoLock) 
   Where S.TaskId = @TaskId And S.IsTemp = 1 And S.UserId <> @UserId
 Delete From tblAssignedSequencing Where TaskId = @TaskId And IsTemp = 1 And UserId <> @UserId

 Select @Start = Min(Id), @End = Max(Id) From #UserTasks
 While @Start <= @End
  Begin
   Select @DesignationId = DesignationId, @IsTechTask = IsTechTask, @UserID = UserID From #UserTasks Where Id = @Start
   Exec usp_GetUserAssignedDesigSequencnce @DesignationId, @IsTechTask, @UserID
   Set @Start = @Start + 1
  End
  IF OBJECT_ID('tempdb..#UserTasks') IS NOT NULL DROP TABLE #UserTasks
 /*  Delete the task for all other users who did not accept yet and reasign a new task for each user */

 UPDATE tblAssignedSequencing SET  IsTemp = 0 WHERE  (Id = @AssignedSeqID)

END

/* =============================================      
 Author:  Jitendra Pancholi      
 Create date: 08-Nov-2017
 Description: This will call all procedure which needs to be run periodically.
 ============================================= */
Go
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'RunJobs')
  BEGIN
      DROP PROCEDURE RunJobs
  END
 Go
Create Procedure RunJobs
As
Begin
	Declare @JobSchedulerLogId Bigint, @StartsOn DateTime, @ExecutionTime int

	/* Call this procedure to change user's status to InterviewDateExpired. */
	Set @StartsOn = GetDate()
	Insert Into JobSchedulerLog (JobName, StartsOn) Values ('FreeTaskIfInterviewPassed',@StartsOn)
	Exec FreeTaskIfInterviewPassed
	Set @JobSchedulerLogId = ident_current('JobSchedulerLog')
	Set @ExecutionTime = DateDiff(S,@StartsOn,GetDate())
	Update JobSchedulerLog Set EndsOn = GetDate(), ExecutionTime = @ExecutionTime Where Id = @JobSchedulerLogId
	/* Call this procedure to change user's status to InterviewDateExpired. */
	
	
	
	/* Call other job procedures like above */
End

/* =============================================      
 Author:  Jitendra Pancholi      
 Create date: 08-Nov-2017
 Description: This will call all procedure which needs to be run periodically.
 ============================================= */
Go
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetUserAssignedTaskHistory')
  BEGIN
      DROP PROCEDURE GetUserAssignedTaskHistory
  END
 Go
 /*
  GetUserAssignedTaskHistory 3809
 */
 Create PROCEDURE GetUserAssignedTaskHistory      
(
 @UserID  INT      
)      
AS      
BEGIN

-- Get newly assigned sequence from inserted sequence / Already assigned sequence      
SELECT top 1 Id,T.TaskId, dbo.udf_GetParentTaskId(T.TaskId) AS ParentTaskId,       
(SELECT Title FROM tblTask WHERE TaskId =  dbo.udf_GetParentTaskId(T.TaskId)) AS ParentTitle , 
dbo.udf_GetCombineInstallId(T.TaskId) AS InstallId , T.Title       
      
FROM tblTask AS T  Join InstallUserTaskHistory H on T.TaskId = H.TaskId    
       
WHERE H.InstallUserId = @UserId

End


Go
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetUserTouchPointLogs')
  BEGIN
      DROP PROCEDURE GetUserTouchPointLogs
  END
 Go
 /*  
 GetUserTouchPointLogs 3809,0,10,0  
 */  
 CREATE PROCEDURE [dbo].[GetUserTouchPointLogs]        
(  
 @UserID  Int,  
 @PageNumber Int = 0,  
 @PageSize Int = 10,  
 @TotalResults Int output  
)        
AS        
BEGIN  
 Select @TotalResults = Count(T.UserTouchPointLogID)  
   from tblUserTouchPointLog T With(NoLock)   
  Join tblInstallUsers LU With(NoLock) On T.UpdatedByUserId = LU.Id  
  Join tblInstallUsers U With(NoLock) On T.UserId = U.Id  
 Where T.UserID = @UserID  
   
   
 
 Select T.UserTouchPointLogID, T.UserID, T.UpdatedByUserID, T.UpdatedUserInstallID, T.ChangeDateTime,   
   T.LogDescription,  
   LU.FristName As UpdatedByFirstName, LU.LastName As UpdatedByLastName, LU.Email As UpdatedByEmail,  
   U.FristName, U.LastName, U.Email, U.Phone,  
   Format(T.ChangeDateTime, 'MM/dd/yyyy hh:mm tt') as ChangeDateTimeFormatted,   
     LU.Fristname+' '+LU.LastName+' - ' + ISNULL(LU.UserInstallId,LU.Id) As SourceUser,
	 LU.Fristname+' '+LU.LastName As SourceUsername,
	 ISNULL(LU.UserInstallId,LU.Id) As SourceUserInstallId
   from tblUserTouchPointLog T With(NoLock)   
  Join tblInstallUsers LU With(NoLock) On T.UpdatedByUserId = LU.Id  
  Join tblInstallUsers U With(NoLock) On T.UserId = U.Id  
 Where T.UserID = @UserID  
 ORDER BY T.ChangeDateTime Desc  
 OFFSET @PageSize * (@PageNumber) ROWS  
 FETCH NEXT @PageSize ROWS ONLY;   
End

GO

IF EXISTS (SELECT * FROM sys.objects WHERE [name] = N'AfterInsertTblInstallUsers' AND [type] = 'TR')
BEGIN
      DROP TRIGGER AfterInsertTblInstallUsers
END
Go
Create  TRIGGER AfterInsertTblInstallUsers 
   ON  tblInstallUsers
   AFTER INSERT
AS 
BEGIN
	Insert Into tblUserTouchPointLog(UserID, UpdatedByUserID, UpdatedUserInstallID, ChangeDateTime, LogDescription, CurrentUserGUID)
		SELECT I.Id, I.Id, I.FristName + ' ' + I.LastName, GETUTCDATE(), 'User successfully filled in HR form', '' FROM INSERTED I
End

Go

