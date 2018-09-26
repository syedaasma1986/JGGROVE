Go
IF Not EXISTS (SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[tblInstallUsers]') AND name = 'SecondaryStatus')
	Begin
		Alter Table tblInstallUsers Add SecondaryStatus int
	End
Go


Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'UpdateSecondaryStatus' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE UpdateSecondaryStatus
  END
Go
 ---- =============================================  
-- Author:  Jitendra Pancholi  
-- Create date: 03/30/2018
-- Description: Load all details of task for edit.  
-- =============================================  
-- UpdateSecondaryStatus
 
CREATE PROCEDURE [dbo].[UpdateSecondaryStatus]   
(  
	@SecondaryStatus int,
	@UserId int,
	@LoggedInUserId int
)     
AS  
BEGIN
	IF @SecondaryStatus > 0
		Begin
			Update tblInstallUsers Set SecondaryStatus = @SecondaryStatus Where Id = @UserId
		End
End

Go
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BranchLocation]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[BranchLocation](
		Id int Primary Key,
		BranchAddress1 Varchar(2000) Not Null,
		BranchAddress2 Varchar(2000) Not Null,
		DepartmentId int foreign key references tbl_Department(id),
		Email Varchar(200),
		PhoneNumber Varchar(50) Not Null,
		CreatedOn DateTime Not Null Default(GetUTCDate())
	) 
	Insert Into BranchLocation (Id, BranchAddress1, BranchAddress2, PhoneNumber, DepartmentId, Email) 
		Values(1, '72 E Lancaster Ave','Malvern, PA 19355','(215)483-3098', 1, 'HR@jmgroveconstruction.com');
	Insert Into BranchLocation (Id, BranchAddress1, BranchAddress2, PhoneNumber, DepartmentId, Email) 
		Values(2, 'Test Location','Florida, FL 32004','(415)451-1234', 1, 'HR@jmgroveconstruction.com')
	Insert Into BranchLocation (Id, BranchAddress1, BranchAddress2, PhoneNumber, DepartmentId, Email) 
		Values(3, 'Test Location','Philadelphia, PA 19355','(215)483-1234', 1, 'HR@jmgroveconstruction.com')
	Insert Into BranchLocation (Id, BranchAddress1, BranchAddress2, PhoneNumber, DepartmentId, Email) 
		Values(4, 'Test Location', 'India, ADI 320008','(91)987-123-3098', 2, 'HR@jmgroveconstruction.com')
	Insert Into BranchLocation (Id, BranchAddress1, BranchAddress2, PhoneNumber, DepartmentId, Email) 
		Values(5, 'Test Global Location', 'USA, PA 19355','(800)000-1234', 4, 'HR@jmgroveconstruction.com')
END

Go
IF Not EXISTS (SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[tblInstallUsers]') AND name = 'BranchLocationId')
	Begin
		Alter Table tblInstallUsers Add BranchLocationId int Foreign Key References BranchLocation(Id)
	End

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetUserBranchLocation' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetUserBranchLocation
  END
Go
 ---- =============================================  
-- Author:  Jitendra Pancholi  
-- Create date: 03/30/2018
-- Description: Load all details of task for edit.  
-- =============================================  
-- [GetUserBranchLocation] 2877
 
CREATE PROCEDURE [dbo].[GetUserBranchLocation]   
(  
	@UserId int
)     
AS  
BEGIN
	If Not Exists (Select L.* From tblInstallUsers U Join BranchLocation L On U.BranchLocationId = L.Id	Where U.Id = @UserId)
		Begin
			Select L.Id, L.BranchAddress1,L.BranchAddress2, L.DepartmentId, D.DepartmentName, L.Email,L.PhoneNumber, L.CreatedOn From BranchLocation L 
			Join tbl_Department D On L.DepartmentId = D.Id 
			Where L.Id = 1 And D.IsActive = 1
		ENd
	Else
		Begin
			Select L.Id, L.BranchAddress1,L.BranchAddress2, L.DepartmentId, D.DepartmentName, L.Email,L.PhoneNumber, L.CreatedOn
			 From tblInstallUsers U Join BranchLocation L On U.BranchLocationId = L.Id	
			 Join tbl_Department D On L.DepartmentId = D.Id 
			 Where U.Id = @UserId And D.IsActive = 1
		End
End

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetBranchLocations' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetBranchLocations
  END
Go
 ---- =============================================  
-- Author:  Jitendra Pancholi  
-- Create date: 03/30/2018
-- Description: Load all details of task for edit.  
-- =============================================  
-- [GetBranchLocations]
 
CREATE PROCEDURE [dbo].[GetBranchLocations]       
AS  
BEGIN
	Select L.Id, L.BranchAddress1,L.BranchAddress2, L.DepartmentId, L.Email,L.PhoneNumber, L.CreatedOn ,
		(L.BranchAddress1 + ', ' + L.BranchAddress2) As BranchLocationTitle
	From BranchLocation L
End

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'UDP_UpdateInstallUserOfferMade' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE UDP_UpdateInstallUserOfferMade
  END
Go
 ---- =============================================  
-- Author:		Dharmendra
-- Create date: 2016-06-20
-- Description:	Update install usere offer made
-- =============================================
CREATE PROCEDURE [dbo].[UDP_UpdateInstallUserOfferMade]
	-- Add the parameters for the stored procedure here
	@id int,  
	@Email varchar(100),  
	@password varchar(30),
	@branchLocationId varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if IsNull(@branchLocationId,'') = ''
	begin
		update tblInstallUsers set Email=@Email,[Password]=@password where Id=@id
	end
	else
	Begin
		update tblInstallUsers set Email=@Email,[Password]=@password, BranchLocationId = @branchLocationId where Id=@id
	End

END

Go
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserManagers]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[UserManagers](
		Id int Primary Key Identity(1,1),
		UserId int foreign key references tblInstallUsers(Id),
		ManagerId int foreign key references tblInstallUsers(Id),
		--ManagerDesignationId int foreign key references tbl_Designation(Id),
		CreatedOn DateTime Not Null Default(GetUTCDate())
	) 
	Insert Into UserManagers(UserId, ManagerId) Select Id, 780 From tblInstallUsers Where Id Not in (780,901)
	Insert Into UserManagers(UserId, ManagerId) Select Id, 901 From tblInstallUsers Where Id Not in (780,901)
END

-- Data Cleanup for chatmessage, added userchatgroupid for auto-entries
Go
IF OBJECT_ID('tempdb..#TempIds') IS NOT NULL DROP TABLE #TempIds Create Table #TempIds(Id int identity(1,1), ChatId int)
Insert Into #TempIds (ChatId)
Select Id From (
Select 
ROW_NUMBER()OVER(PARTITION BY ChatSourceId, ChatGroupId, SenderId, TextMessage, ChatFileId, ReceiverIds, TaskId, TaskMultilevelListId, UserChatGroupId
 ORDER BY SenderId) As RN
,Id,ChatSourceId, ChatGroupId, SenderId, TextMessage, ChatFileId, ReceiverIds, TaskId, TaskMultilevelListId, UserChatGroupId 
From ChatMessage Where LTRIM(TextMessage) like 'User %'
) As aa Where RN>1

--Select * From #TempIds
DELETE FROM ChatMessageReadStatus Where ChatMessageId IN (Select ChatId From #TempIds)
Delete from ChatMessage Where Id IN (Select ChatId From #TempIds)
Go 
IF OBJECT_ID('tempdb..#TempIds') IS NOT NULL DROP TABLE #TempIds Create Table #TempIds(Id int identity(1,1), ChatGroupId varchar(200))
Insert Into #TempIds (ChatGroupId)
Select Distinct ChatGroupId From (Select 
ROW_NUMBER()OVER(PARTITION BY ChatSourceId, ChatGroupId, SenderId, TextMessage, ChatFileId, ReceiverIds, TaskId, TaskMultilevelListId, UserChatGroupId
 ORDER BY SenderId) As RN
,Id,ChatSourceId, ChatGroupId, SenderId, TextMessage, ChatFileId, ReceiverIds, TaskId, TaskMultilevelListId, UserChatGroupId 
From ChatMessage Where LTRIM(TextMessage) like 'User %' And UserChatGroupId IS NULL) As aa

--Select * From #TempIds

Declare @Min int=1, @Max int=1, @UserId int, @UserChatGroupId int, @ChatGroupId Varchar(200)

Select @Min=Min(Id), @Max=Max(Id) From #TempIds

While @Min <= @Max
Begin
	Select @ChatGroupId = ChatGroupId From #TempIds Where Id = @Min
	Select top 1 @UserId = SenderId From ChatMessage Where ChatGroupId = @ChatGroupId
	Insert Into UserChatGroup (CreatedBy) Values(@UserId)
	Set @UserChatGroupId = IDENT_CURRENT('UserChatGroup')
	Insert Into UserChatGroupMember (UserChatGroupId, UserId) Values (@UserChatGroupId, 780)
	Insert Into UserChatGroupMember (UserChatGroupId, UserId) Values (@UserChatGroupId, 901)
	Insert Into UserChatGroupMember (UserChatGroupId, UserId) Values (@UserChatGroupId, @UserId)

	Update ChatMessage Set UserChatGroupId = @UserChatGroupId, ReceiverIds = '780,901,' + Convert(Varchar(10), @UserId) 
	Where ChatGroupId = @ChatGroupId
	--Print @UserId
	Set @Min = @Min + 1
End


Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetUserManagers' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetUserManagers
  END
Go
 ---- =============================================  
-- Author:  Jitendra Pancholi  
-- Create date: 03/30/2018
-- Description: Load all details of task for edit.  
-- =============================================  
-- [GetUserManagers] 2877
 
CREATE PROCEDURE [dbo].[GetUserManagers]
(
	@UserId int
)       
AS  
BEGIN
	Select U.Id, U.FristName as FirstName, U.LastName, U.Email From UserManagers M
		Join tblInstallUsers U On M.ManagerId = U.Id
	Where UserId = @UserId
End

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetUserChatGroupAndChatGroup' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetUserChatGroupAndChatGroup
  END
Go
 ---- =============================================  
-- Author:  Jitendra Pancholi  
-- Create date: 03/30/2018
-- Description: Load all details of task for edit.  
-- =============================================  
-- [GetUserChatGroupAndChatGroup] 7305, 780
 
CREATE PROCEDURE [dbo].[GetUserChatGroupAndChatGroup]
(
	@UserId int,
	@LoggedInUserId int
)       
AS  
BEGIN
	--IF OBJECT_ID('tempdb..#TempIds') IS NOT NULL DROP TABLE #TempIds 
	--	Create Table #TempIds(Id int identity(1,1), ManagerId int)
	
	--Insert Into #TempIds(ManagerId)
	--	Select ManagerId From UserManagers Where UserId = @UserId


	Select top 1* From ChatMessage M 
	Where UserChatGroupId Is Not Null ANd TaskId IS NULL And 
	((','+ReceiverIds+',' like '%,'+ Convert(Varchar(10), @LoggedInUserId) +',%' And SenderId = @UserId )
	OR
	(','+ReceiverIds+',' like '%,'+ Convert(Varchar(10), @UserId) +',%' And SenderId =  @LoggedInUserId))
	Order by ID Asc

End

Select top 10 * From ChatMessage Order by Id desc