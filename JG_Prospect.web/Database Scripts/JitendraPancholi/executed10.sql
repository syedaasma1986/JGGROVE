IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetCurrentScheduledHtmlTemplates' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetCurrentScheduledHtmlTemplates
  END
Go
/* 

Exec GetCurrentScheduledHtmlTemplates

*/
Create Procedure GetCurrentScheduledHtmlTemplates
As
Begin
	Create Table #TempData(Id int identity(1,1), StartDateTime DateTime, Frequency int, TemplateId int)  
	Insert Into #TempData  
	SELECT FORMAT(CONVERT(DateTime, convert(varchar(20), CONVERT(date, T.FrequencyStartDate)) + ' ' +  
	RIGHT('0'+CAST(DATEPART(hour, T.FrequencyStartTime) as varchar(2)),2) + ':' +  
	RIGHT('0'+CAST(DATEPART(minute, T.FrequencyStartTime)as varchar(2)),2)),'yyyy-MM-dd HH:mm') As StartDateTime,      
	T.FrequencyInDays, T.Id--, T.Subject  
	from tblHTMLTemplatesMaster T Where T.FrequencyStartTime Is Not Null  
	Select *, DateAdd(Day, (Frequency*((DATEDIFF(Day,StartDateTime,GetDate()) / Frequency))), StartDateTime) As RunsOn,
	Convert(DateTime, Format(GetDate(),'yyyy-MM-dd HH:mm')) As Today
	FROM #TempData  
	Where Convert(DateTime, Format(GetDate(),'yyyy-MM-dd HH:mm')) = DateAdd(Day, (Frequency*((DATEDIFF(Day,StartDateTime,GetDate()) / Frequency))), StartDateTime)  
  
	Drop Table #TempData  
End


Go

IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'UpdateEmpType' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE UpdateEmpType
  END
Go
Create PROCEDURE UpdateEmpType
	@ID int,
	@EmpType varchar(50)
AS
BEGIN
	update tblInstallUsers set EmpType=@EmpType where ID=@ID
END

Go
/* =============================================      
 Author:  Jitendra Pancholi      
 Create date: 08-Nov-2017
 Description: This will call all procedure which needs to be run periodically.
 ============================================= */
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetUserAssignedTaskHistory')
  BEGIN
      DROP PROCEDURE GetUserAssignedTaskHistory
  END
 Go
 /*
  GetUserAssignedTaskHistory 3797
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
dbo.udf_GetCombineInstallId(T.TaskId) AS InstallId , T.Title,ISNULL(T.Sequence,1) As AvailableSequence     
      
FROM tblTask AS T  Join InstallUserTaskHistory H on T.TaskId = H.TaskId    
       
WHERE H.InstallUserId = @UserId

End


go
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserLoginCode]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserLoginCode](
   Id UniqueIdentifier Primary Key DEFAULT (NEWID()),
   UserId int null foreign key references tblInstallUsers(Id),
   CreatedOn DateTime Not Null Default(GetUTCDATE()),
   IsExpired bit not null default(0),
   LoggedInOn DateTime
) 

END

Go
/* =============================================      
 Author:  Jitendra Pancholi      
 Create date: 08-Nov-2017
 Description: This will Generate or Select Unique Login for a particular user
 ============================================= */
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GenerateLoginCode')
  BEGIN
      DROP PROCEDURE GenerateLoginCode
  END
 Go
 /*
	GenerateLoginCode 3797
 */
 Create PROCEDURE GenerateLoginCode      
(
	@UserId  INT      
)      
AS      
BEGIN
	DECLARE @MyTableVar table(Id uniqueidentifier);
	if exists (Select * From UserLoginCode Where UserId = @UserId And IsExpired = 0 And LoggedInOn Is Null)
		Begin
			Select Id From UserLoginCode Where UserId = @UserId And IsExpired = 0 And LoggedInOn Is Null
		End
	Else
		Begin
			Insert Into UserLoginCode (UserId) OUTPUT INSERTED.Id INTO @MyTableVar Values (@UserId)
			Select Id from @MyTableVar
		End
End

Go
/* =============================================      
 Author:  Jitendra Pancholi      
 Create date: 08-Nov-2017
 Description: This will expire the login code when user logs into the system.
 ============================================= */
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'ExpireLoginCode')
  BEGIN
      DROP PROCEDURE ExpireLoginCode
  END
 Go
 /*
	ExpireLoginCode '3B9FF355-9164-40B2-A701-8C6C0C259E2D'
 */
 Create PROCEDURE ExpireLoginCode      
(
	@Id NVarchar(50)
)      
AS      
BEGIN
	If exists (Select * from UserLoginCode Where Id = @Id And IsExpired = 0 and LoggedInOn IS NULL)
		Begin
			IF EXISTS (Select * from UserLoginCode Where Id = @Id And IsExpired = 0 and LoggedInOn IS NULL And DateDiff(MINUTE, CreatedOn, Getutcdate()) > 2880)
				Begin
					Update UserLoginCode Set IsExpired = 1, LoggedInOn = NULL Where Id = @Id
					Select '' As Email
				End
			Else
				Begin
					Update UserLoginCode Set IsExpired = 1, LoggedInOn = GetUTCDate() Where Id = @Id
					Select U.Email From tblInstallUsers U Join UserLoginCode L on U.Id = L.UserId Where L.Id = @Id
				End
		End
	Else 
		Begin
			Select '' As Email
		End
End

Go
/* =============================================      
 Author:  Jitendra Pancholi      
 Create date: 08-Nov-2017
 Description: This will expire the login code when user logs into the system.
 ============================================= */
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'ExpireAllLoginCode')
  BEGIN
      DROP PROCEDURE ExpireAllLoginCode
  END
 Go
 /*
	ExpireAllLoginCode
 */
 Create PROCEDURE ExpireAllLoginCode      
(
	@Id NVarchar(50)
)      
AS      
BEGIN
	Update UserLoginCode Set IsExpired = 1 
		Where IsExpired = 0 And LoggedInOn Is NULL And DateDiff(MINUTE, CreatedOn, Getutcdate()) > 2880
End

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
	
	
	/* Expire All LoggedInCodes After 48 hours of generation */
	Exec ExpireAllLoginCode
	

	/* Call other job procedures like above */
End