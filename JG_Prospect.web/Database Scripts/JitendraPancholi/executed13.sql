IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'ChatMessage' AND column_name = 'TaskId')
BEGIN
	Alter Table ChatMessage Add TaskId Bigint foreign key references tblTask(TaskId);
END

IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'ChatMessage' AND column_name = 'TaskMultilevelListId')
BEGIN
	Alter Table ChatMessage Add TaskMultilevelListId int foreign key references tblTaskMultilevelList(Id)
END

GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetTaskChatMessages' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetTaskChatMessages
  END
Go

 -- =============================================      
-- Author:  Jitendra Pancholi      
-- Create date: 9 Jan 2017   
-- Description: Add offline user to chatuser table
-- =============================================    
/*
	GetTaskChatMessages 535,2324,2,3797
*/
CREATE PROCEDURE [dbo].[GetTaskChatMessages]
	@TaskId int,
	@TaskMultilevelListId int = 0,
	@ChatSourceId Int = 0,
	@LoggedInUserId Int = 780
AS    
BEGIN
	Set @ChatSourceId = 2 -- Source is 2 for Tasks
	IF @TaskMultilevelListId IS NULL Begin Set @TaskMultilevelListId = 0 End
	
	IF OBJECT_ID('tempdb..#TempChatMessages') IS NOT NULL DROP TABLE #TempChatMessages  
	Create Table #TempChatMessages(Id int Primary Key Identity(1,1), 
			ChatGroupId varchar(100), ChatSourceId int, SenderId int, TextMessage nVarchar(max), ChatFileId int, ReceiverIds varchar(800),
			CreatedOn datetime, ChatUserIds Varchar(1000), SortedChatUserIds Varchar(1000), ChatMessageId int,
			TaskId int, TaskMultilevelListId int, UserChatGroupId int)

	If @TaskMultilevelListId = 0
		Begin
			Insert Into #TempChatMessages (ChatGroupId,ChatSourceId, SenderId, TextMessage, ChatFileId,ReceiverIds,
										CreatedOn,ChatUserIds, ChatMessageId, TaskId, TaskMultilevelListId, UserChatGroupId)
			Select S.ChatGroupId,S.ChatSourceId, S.SenderId, S.TextMessage, S.ChatFileId, 
						S.ReceiverIds, S.CreatedOn, Convert(varchar(12), S.SenderId) + ',' + S.ReceiverIds, S.Id,
						S.TaskId, S.TaskMultilevelListId, S.UserChatGroupId
			From ChatMessage S With(NoLock) 
			Where S.TaskId = @TaskId
		End
	Else
		Begin
			Insert Into #TempChatMessages (ChatGroupId,ChatSourceId, SenderId, TextMessage, ChatFileId,ReceiverIds,
										CreatedOn,ChatUserIds, ChatMessageId, TaskId, TaskMultilevelListId, UserChatGroupId)
			Select S.ChatGroupId,S.ChatSourceId, S.SenderId, S.TextMessage, S.ChatFileId, 
						S.ReceiverIds, S.CreatedOn, Convert(varchar(12), S.SenderId) + ',' + S.ReceiverIds, S.Id,
						S.TaskId, S.TaskMultilevelListId, S.UserChatGroupId
			From ChatMessage S With(NoLock) 
			Where S.TaskId = @TaskId And S.TaskMultilevelListId = @TaskMultilevelListId
		End

	Declare @Min int =1, @Max int =1, @ChatUserIds Varchar(1000)

	Select @Min = Min(Id), @Max = Max(Id) From #TempChatMessages

	While @Min <= @Max
	Begin
		Select @ChatUserIds = ChatUserIds From #TempChatMessages Where Id = @Min

		Update #TempChatMessages Set SortedChatUserIds = SUBSTRING(
					(SELECT ',' + Convert(Varchar(20),Result)
					From dbo.CSVtoTable(@ChatUserIds, ',') 
					Order by Result Asc
					FOR XML PATH('')),2,800) Where Id = @Min

		Set @Min = @Min + 1
	End
	--Select * From #TempChatMessages S Where S.SortedChatUserIds = @ReceiverIds And S.ChatSourceId = @ChatSourceId
	If ISNULL(@ChatSourceId,'0') = '0'
		Begin
			Select Distinct S.Id, S.ChatGroupId,S.ChatSourceId, S.SenderId, S.TextMessage, S.ChatFileId, S.ReceiverIds, S.CreatedOn,
				U.FristName As FirstName, U.LastName, (U.FristName + ' ' + U.LastName) As Fullname,
				U.UserInstallId, U.Picture, 
				--Convert(bit,1) As IsRead
				IsNull((Select MS.IsRead From ChatMessageReadStatus MS Where MS.ChatMessageId = S.ChatMessageId And ReceiverId = @LoggedInUserId),1) As IsRead,
				S.UserChatGroupId, S.TaskId, S.TaskMultilevelListId
				/*(Select MS.IsRead From ChatMessageReadStatus MS Where MS.ChatMessageId = S.ChatMessageId And S.ReceiverIds like '%'+ Convert(Varchar(12), MS.ReceiverId)+'%') As IsRead*/
			From #TempChatMessages S With(NoLock) 
			Join tblInstallUsers U With(NoLock) On S.SenderId = U.Id
			--Join ChatMessageReadStatus MS With(NoLock) On S.ChatMessageId = MS.ChatMessageId
			--Where S.SortedChatUserIds = @ReceiverIds
			Order By S.CreatedOn Asc
		End
	Else
		Begin
			Select Distinct S.Id, S.ChatGroupId,S.ChatSourceId, S.SenderId, S.TextMessage, S.ChatFileId, S.ReceiverIds, S.CreatedOn,
				U.FristName As FirstName, U.LastName, (U.FristName + ' ' + U.LastName) As Fullname,
				U.UserInstallId, U.Picture, /*MS.IsRead*/
				--Convert(bit,1) As IsRead
				IsNull((Select MS.IsRead From ChatMessageReadStatus MS Where MS.ChatMessageId = S.ChatMessageId And ReceiverId = @LoggedInUserId),1) As IsRead,
				S.UserChatGroupId, S.TaskId, S.TaskMultilevelListId
				/*(Select MS.IsRead From ChatMessageReadStatus MS Where MS.ChatMessageId = S.ChatMessageId And S.ReceiverIds like '%'+ Convert(Varchar(12), MS.ReceiverId)+'%') As IsRead*/
			From #TempChatMessages S With(NoLock) 
			Join tblInstallUsers U With(NoLock) On S.SenderId = U.Id
			--Join ChatMessageReadStatus MS With(NoLock) On S.ChatMessageId = MS.ChatMessageId
			Where /*S.SortedChatUserIds = @ReceiverIds And*/ S.ChatSourceId = @ChatSourceId
			Order By S.CreatedOn Asc
		End
END

GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetTaskUsers' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetTaskUsers
  END
Go
 -- =============================================      
-- Author:  Jitendra Pancholi      
-- Create date: 9 Jan 2017   
-- Description: Add offline user to chatuser table
-- =============================================    
/* 
	GetTaskUsers 781
*/
CREATE PROCEDURE [dbo].[GetTaskUsers]
	@TaskId int
AS    
Begin
	Select UserId, Acceptance, CreatedDate From tblTaskAssignedUsers U With(NoLock) Where U.TaskId = @TaskId
	Union
	Select 901,1, GetUTCDate()
	Union
	Select 780,1, GetUTCDate()
End

GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'SaveChatMessage' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE SaveChatMessage
  END
Go
 -- =============================================      
-- Author:  Jitendra Pancholi      
-- Create date: 9 Jan 2017   
-- Description: Add offline user to chatuser table
-- =============================================    
/*
	SaveChatMessage 3797
*/
CREATE PROCEDURE [dbo].[SaveChatMessage]
	@ChatSourceId int,
	@ChatGroupId Varchar(100),
	@SenderId int,
	@TextMessage nvarchar(max),
	@ChatFileId int,
	@ReceiverIds varchar(800),
	@TaskId int = null,
	@TaskMultilevelListId int =null,
	@UserChatGroupId int =null
AS    
BEGIN
	Declare @MessageId int
	IF @TaskId = 0 Begin Set @TaskId = Null End
	IF @TaskMultilevelListId = 0 Begin Set @TaskMultilevelListId = Null End
	IF @UserChatGroupId = 0 Begin Set @UserChatGroupId = Null End
	
	IF @TaskId IS NOT NULL AND @UserChatGroupId IS NULL
	Begin
		-- Fetch Existing UserChatGroupId 
		IF @TaskMultilevelListId IS NULL
		Begin
			Select top 1 @UserChatGroupId = Id From UserChatGroup Where TaskId = @TaskId And TaskMultilevelListId IS NULL
		End
		Else
		Begin
			Select top 1 @UserChatGroupId = Id From UserChatGroup Where TaskId = @TaskId And TaskMultilevelListId = @TaskMultilevelListId	
		End
	End

	Insert Into ChatMessage(ChatSourceId, SenderId, ChatGroupId, TextMessage, ChatFileId, ReceiverIds, TaskId,TaskMultilevelListId, UserChatGroupId) 
	Values
		(@ChatSourceId, @SenderId, @ChatGroupId, @TextMessage, @ChatFileId, @ReceiverIds,@TaskId,@TaskMultilevelListId,@UserChatGroupId)
	Set @MessageId = IDENT_CURRENT('ChatMessage')
	Insert Into ChatMessageReadStatus (ChatMessageId, ReceiverId) 
		Select @MessageId, RESULT from dbo.CSVtoTable(@ReceiverIds,',') Where RESULT > 0
END

