IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'tblInstallUsers' AND column_name = 'PortalEmail')
BEGIN
	Alter Table tblInstallUsers Add PortalEmail Varchar(50)
END 

IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'tblInstallUsers' AND column_name = 'PortalEmailPassword')
BEGIN
	Alter Table tblInstallUsers Add PortalEmailPassword Varchar(50)
END 

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'UDP_GetInstallerUserDetailsByLoginId' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE UDP_GetInstallerUserDetailsByLoginId
  END
Go
-- =============================================            
-- Author:  Yogesh            
-- Create date: 23 Feb 2017          
-- Updated By : Yogesh      
-- Updated By : Jitendra Pancholi  
-- Updated On : 13 Nov 2017      
--     Added applicant status to allow applicant to login.          
-- Updated By : Nand Chavan (Task ID#: REC001-XIII)        
--                  Replace Source with SourceID        
-- Description: Get an install user by email and status.          
-- =============================================          
-- [dbo].[UDP_GetInstallerUserDetailsByLoginId]  'Surmca17@gmail.com'     
CREATE PROCEDURE [dbo].[UDP_GetInstallerUserDetailsByLoginId]          
	@loginId varchar(50) ,          
	@ActiveStatus varchar(5) = '1',          
	@ApplicantStatus varchar(5) = '2',          
	@InterviewDateStatus varchar(5) = '5',          
	@OfferMadeStatus varchar(5) = '6'          
AS          
BEGIN  
	DECLARE @phone varchar(1000) = @loginId        
        
	--REC001-XIII - create formatted phone#        
	IF ISNUMERIC(@loginId) = 1 AND LEN(@loginId) > 5        
	BEGIN        
		SET @phone =  '(' + SUBSTRING(@phone, 1, 3) + ')-' + SUBSTRING(@phone, 4, 3) + '-' + SUBSTRING(@phone, 7, LEN(@phone))        
	END        
            
	SELECT Id,FristName,Lastname,Email,[Address],Designation,[Status],          
			[Password],[Address],Phone,Picture,Attachements,usertype, Picture,IsFirstTime,DesignationID,      
			CASE WHEN  [Status] = '5' THEN [dbo].[udf_IsUserAssigned](tbi.Id) ELSE 0 END AS AssignedSequence,  
			UserInstallId, LastProfileUpdated,
			ISNULL(PortalEmail,'SEO@jmgroveconstruction.com') As PortalEmail, 
			ISNULL(PortalEmailPassword,'jmgrovejmgrove1') As PortalEmailPassword
			
	FROM tblInstallUsers  AS tbi     
	WHERE (Email = @loginId OR Phone = @loginId  OR Phone = @phone)         
		AND ISNULL(@loginId, '') != ''   AND        
		(          
			[Status] = @ActiveStatus OR           
			[Status] = @ApplicantStatus OR          
			[Status] = @OfferMadeStatus OR           
			[Status] = @InterviewDateStatus  OR  
			[Status] = 16  -- InterviewDateExpired,  Added by Jitendra Pancholi   
		)
END

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetUserById' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetUserById
  END
Go
-- GetUserById 3797
CREATE PROCEDURE GetUserById
	@Id int
AS
BEGIN
	SELECT Id,FristName,Lastname,Email,[Address],Designation,[Status],          
			[Password],[Address],Phone,Picture,Attachements,usertype, Picture,IsFirstTime,DesignationID,      
			CASE WHEN  [Status] = '5' THEN [dbo].[udf_IsUserAssigned](tbi.Id) ELSE 0 END AS AssignedSequence,  
			UserInstallId, LastProfileUpdated,
			ISNULL(PortalEmail,'SEO@jmgroveconstruction.com') As PortalEmail, 
			ISNULL(PortalEmailPassword,'jmgrovejmgrove1') As PortalEmailPassword 
	FROM tblInstallUsers  AS tbi     
		Where tbi.Id = @Id
End

GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'SaveChatFile' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE SaveChatFile
  END
Go
 -- =============================================        
-- Author:  Jitendra Pancholi        
-- Create date: 12 Feb 2018
-- Description: Save file into database
-- =============================================      
/*  
	SaveChatFile '1','1','1',null
*/  
Create PROCEDURE SaveChatFile  
	@DisplayName Varchar(200),
	@SavedName Varchar(200),
	@Mime Varchar(100),
	@DownloadBinary varbinary(Max) = Null
AS      
BEGIN
	Insert Into ChatFile (DisplayName,SavedName,Mime,DownloadBinary)
		Values (@DisplayName,@SavedName,@Mime,@DownloadBinary)

	Select IDENT_CURRENT('ChatFile') As FileId
End


GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetChatFile' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetChatFile
  END
Go
 -- =============================================        
-- Author:  Jitendra Pancholi        
-- Create date: 12 Feb 2018
-- Description: Save file into database
-- =============================================      
/*  
	GetChatFile 1 
*/  
Create PROCEDURE GetChatFile  
	@FileId Int
AS      
BEGIN
	Select Id, DisplayName, SavedName, Mime, DownloadBinary From ChatFile F With(NoLock) Where F.Id = @FileId
End

Go
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ChatRole]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[ChatRole](
		Id int Primary Key,
		RoleName Varchar(200)
	) 
	Insert Into ChatRole Values(1, 'ChatAdmin');
	Insert Into ChatRole Values(2, 'ChatUser');
END

Go
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ChatUserRole]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[ChatUserRole](
		Id int Primary Key Identity(1,1),
		UserId int foreign key references tblInstallUsers(Id),
		RoleId int foreign key references ChatRole(Id)
	) 
END


GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetChatUnReadCount' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetChatUnReadCount
  END
Go
 -- =============================================        
-- Author:  Jitendra Pancholi        
-- Create date: 12 Feb 2018
-- Description: Save file into database
-- =============================================      
/*  
	GetChatUnReadCount 1152
	GetChatUnReadCount 901,2
	GetChatUnReadCount 901
*/  
Create PROCEDURE GetChatUnReadCount
	@UserId Int,
	@ChatSourceId Int = null
AS      
BEGIN
	IF @ChatSourceId IS NULL
	Begin
		Select M.SenderId, Count(SenderId) As UnReadCount From ChatMessageReadStatus S With(NoLock)
		Join ChatMessage M With(NoLock) on S.ChatMessageId = M.Id
		Where S.ReceiverId = @UserId And S.IsRead = 0 And M.ChatSourceId = 10
		Group By SenderId
	End
	Else
	Begin
		Select M.SenderId, Count(SenderId) As UnReadCount From ChatMessageReadStatus S With(NoLock)
		Join ChatMessage M With(NoLock) on S.ChatMessageId = M.Id
		Where S.ReceiverId = @UserId And S.IsRead = 0 And M.ChatSourceId = @ChatSourceId
		Group By SenderId
	End
End

GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetAllChatHistory' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetAllChatHistory
  END
Go
 -- =============================================        
-- Author:  Jitendra Pancholi        
-- Create date: 12 Feb 2018
-- Description: Save file into database
-- =============================================      
/*  
	GetAllChatHistory
*/  
Create PROCEDURE GetAllChatHistory
AS      
BEGIN
	Declare @Min int = 1, @Max int = 1,@ChatUserIds Varchar(1000)
	IF OBJECT_ID('tempdb..#TempChatMessages') IS NOT NULL DROP TABLE #TempChatMessages  
		Create Table #TempChatMessages(Id int Primary Key Identity(1,1), 
			ChatGroupId varchar(100), ChatSourceId int, SenderId int, TextMessage nVarchar(max), ChatFileId int, ReceiverIds varchar(800),
			CreatedOn datetime, ChatUserIds Varchar(1000), SortedChatUserIds Varchar(1000))
	IF OBJECT_ID('tempdb..#OnlineTempGroups') IS NOT NULL DROP TABLE #OnlineTempGroups  
		Create Table #OnlineTempGroups(Id int identity(1,1), ChatGroupId varchar(100), ChatUserIds varchar(800), ChatUserCount int,LastMessage NVarchar(max),
				MessageId int, MessageAt DateTime, Picture Varchar(800))
	IF OBJECT_ID('tempdb..#OnlineGroups') IS NOT NULL DROP TABLE #OnlineGroups  
		Create Table #OnlineGroups(Id int identity(1,1), ChatGroupId varchar(100), ChatUserIds varchar(800), ChatUserCount int,LastMessage NVarchar(max),
				MessageId int, MessageAt DateTime, Picture Varchar(800))
	IF OBJECT_ID('tempdb..#UserIds') IS NOT NULL DROP TABLE #UserIds
		Create Table #UserIds(Id int)
	IF OBJECT_ID('tempdb..#OnlineUsersOrGroups') IS NOT NULL DROP TABLE #OnlineUsersOrGroups  
	Create Table #OnlineUsersOrGroups(Id int Primary Key Identity(1,1), UserId int, 
			ChatGroupId varchar(100), ReceiverIds varchar(800), OnlineAt DateTime,   
			MessageId int, LastMessage NVarchar(max), MessageAt DateTime, LastMessageByUserId int, 
			IsRead Bit Not Null Default(0), GroupOrUsername Varchar(800), Picture Varchar(800),
			UserInstallId Varchar(100), UserRank int, UserStatus int)

	Insert Into #TempChatMessages (ChatGroupId,ChatSourceId, SenderId, TextMessage, ChatFileId,ReceiverIds,
									CreatedOn,ChatUserIds)
		Select S.ChatGroupId,S.ChatSourceId, S.SenderId, S.TextMessage, S.ChatFileId, 
					S.ReceiverIds, S.CreatedOn, Convert(varchar(12), S.SenderId) + ',' + S.ReceiverIds
		From ChatMessage S With(NoLock)
	
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
	Insert Into #OnlineTempGroups(ChatGroupId,ChatUserIds,ChatUserCount,LastMessage,MessageId,MessageAt,Picture)
		Select Distinct M.ChatGroupId, M.SortedChatUserIds As ChatUserIds, 
			(Len( M.SortedChatUserIds) - Len(Replace(M.SortedChatUserIds,',','')) + 1) As UserCount,
			(Select top 1 TextMessage From #TempChatMessages IM With(NoLock) Where IM.ChatGroupId = M.ChatGroupId And IM.SortedChatUserIds = M.SortedChatUserIds Order By IM.CreatedOn Desc) As LastMessage,
			(Select top 1 Id From #TempChatMessages IM With(NoLock) Where IM.ChatGroupId = M.ChatGroupId Order By IM.CreatedOn Desc) As MessageId,
			(Select top 1 CreatedOn From #TempChatMessages IM With(NoLock) Where IM.ChatGroupId = M.ChatGroupId Order By IM.CreatedOn Desc) As MessageAt,
			'chat-group.png' As Picture
		From #TempChatMessages M With(NoLock) 
		Order By MessageAt Desc

	Insert Into #OnlineGroups
		Select Distinct OG.ChatGroupId,OG.ChatUserIds,OG.ChatUserCount,OG.LastMessage,OG.MessageId,ISNULL(OG.MessageAt,'01-010-1900'),OG.Picture 
			From #OnlineTempGroups OG 
				Where /*ChatUserCount = (Select Max(ChatUserCount) From #OnlineTempGroups iOG Group By iOG.ChatGroupId Having iOG.ChatGroupId = OG.ChatGroupId)
					And*/ ChatUserCount > 1
			Order By MessageId Desc

	Select @Min = Min(Id), @Max = Max(Id) from #OnlineGroups  
	While @Min <= @Max  
			Begin  
				Select @ChatUserIds = ChatUserIds From #OnlineGroups Where Id = @Min 
				--print @ChatUserIds
				Truncate Table #UserIds
				Insert Into #UserIds
					Select Convert(int, Result) From dbo.CSVtoTable(@ChatUserIds,',') Order By Convert(int, Result)

				Update #OnlineGroups Set ChatUserIds = SUBSTRING(
					(SELECT ',' + Convert(Varchar(20),s.Id)
					FROM #UserIds s
					ORDER BY s.Id
					FOR XML PATH('')),2,800) Where Id = @Min

				Set @Min = @Min + 1  
			End

	Insert Into #OnlineUsersOrGroups (ChatGroupId,ReceiverIds,LastMessage,MessageId,MessageAt,OnlineAt,Picture, UserRank, UserStatus)
			Select Distinct ChatGroupId,ChatUserIds,LastMessage,MessageId,ISNULL(MessageAt,'01-010-1900'),MessageAt,Picture, 100, Null
				From #OnlineGroups --Where ChatUserIds like '%' + Convert(Varchar(12),@LoggedInUserId) + '%'
		
		Update #OnlineUsersOrGroups Set GroupOrUsername = SUBSTRING(
			(SELECT ' - ' + s.Fullname
			FROM (select (U.FristName + ' ' + U.LastName) as Fullname From tblInstallUsers U 
			Where U.Id in (Select Result From dbo.CSVtoTable(ReceiverIds,','))) s
			ORDER BY s.Fullname
			FOR XML PATH('')),4,800)
		Where UserId IS NULL

		Select * from #OnlineUsersOrGroups Order By MessageAt Desc
End

GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'Sp_InsertTouchPointLog' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE Sp_InsertTouchPointLog
  END
Go
-- =============================================
-- Author:		Bhavik J. Vaishnani
-- Create date: 29-11-2016
-- Description:	Insert value of Touch Point log

--	Exec Sp_InsertTouchPointLog 2877,2877,'','05/09/2018','test data','',6

-- =============================================
CREATE PROCEDURE [dbo].[Sp_InsertTouchPointLog] 
	-- Add the parameters for the stored procedure here
	@userID int = 0, 
	@loginUserID int = 0
	, @loginUserInstallID varchar (50) =''
	, @LogTime datetime
	, @changeLog nvarchar(max)
	,@CurrGUID varchar(40)
	,@TouchPointSource int
AS
-- Sp_InsertTouchPointLog 901,3797,'','10/10/2015','test sfssad','',1
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/*
	INSERT INTO [dbo].[tblUserTouchPointLog]
           ([UserID]  ,[UpdatedByUserID] ,[UpdatedUserInstallID]
           ,[ChangeDateTime]
           ,[LogDescription]
		   ,[CurrentUserGUID]
		   ,[TouchPointSource])
     VALUES
           (@userID , @loginUserID ,@loginUserInstallID            
           , /*@LogTime*/
		   GETUTCDATE()
           ,@changeLog
		   ,@CurrGUID
		   ,@TouchPointSource)
	*/
	Declare @ChatGroupId Varchar(100) = null, @UserChatGroupId int, @ReceiverIds Varchar(800)
	/*
	Select top 1 @ChatGroupId =S.ChatGroupId
		From ChatMessage S With(NoLock)
			Join tblInstallUsers U With(NoLock) On S.SenderId = U.Id
			Join ChatMessageReadStatus MS With(NoLock) On S.Id = MS.ChatMessageId
		Where (S.SenderId = @loginUserID And S.ReceiverIds = Convert(Varchar(12), @userID))
			Or (S.SenderId = @userID And S.ReceiverIds =  Convert(Varchar(12), @loginUserID))
	*/
	Select top 1 @ChatGroupId = S.ChatGroupId, @UserChatGroupId = S.UserChatGroupId
	From ChatMessage S With(NoLock)
	Join tblInstallUsers U With(NoLock) On S.SenderId = U.Id
	Join ChatMessageReadStatus MS With(NoLock) On S.Id = MS.ChatMessageId
	Where (((S.SenderId = 780 Or S.SenderId = 920 OR S.SenderId = @loginUserID) And S.ReceiverIds = Convert(Varchar(12), @userID))
	Or (S.SenderId = @userID And S.ReceiverIds like  '%' + Convert(Varchar(12), 780) + ',' + Convert(Varchar(12), 901) +'%'))
	And S.TaskId IS NULL
	Order By CreatedOn Asc

	Print @ChatGroupId
	IF ISNULL(@ChatGroupId,'') = ''
	begin
		Select @ChatGroupId = NEWID ()  
	end
	print @UserChatGroupId
	IF @UserChatGroupId IS NULL
	begin
		Insert Into UserChatGroup (CreatedBy) Values(@loginUserID)
		Set @UserChatGroupId = IDENT_CURRENT('UserChatGroup')

		IF OBJECT_ID('tempdb..#TempUsers') IS NOT NULL DROP TABLE #TempUsers   
		Create Table #TempUsers(UserId int, UserChatGroupId int)
		Insert Into #TempUsers Values(780, @UserChatGroupId)
		Insert Into #TempUsers Values(901, @UserChatGroupId)
		Insert Into #TempUsers Values(@loginUserID, @UserChatGroupId)

		Insert Into UserChatGroupMember (UserChatGroupId, UserId)
			Select Distinct UserChatGroupId, UserId From #TempUsers
	end
	print @UserChatGroupId
	SELECT @ReceiverIds = SUBSTRING((SELECT ',' + Convert(Varchar(10), s.UserId) FROM #TempUsers s 
		ORDER BY s.UserId Asc FOR XML PATH('')),2,200000) 

	Print '@TouchPointSource ='+Convert(Varchar(10),@TouchPointSource)
	Print '@@ChatGroupId ='+Convert(Varchar(10),@ChatGroupId)
	Print '@@loginUserID ='+Convert(Varchar(10),@loginUserID)
	Print '@@changeLog ='+Convert(Varchar(100),@changeLog)
	Print '@@ReceiverIds ='+Convert(Varchar(100),@ReceiverIds)
	Print '@@UserChatGroupId ='+Convert(Varchar(10),@UserChatGroupId)
	Exec SaveChatMessage  @TouchPointSource, @ChatGroupId, @loginUserID, @changeLog, null, @ReceiverIds,0,0, @UserChatGroupId

	Select IDENT_CURRENT('ChatMessage') as UserTouchPointLogID
END



Go
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ChatSource]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[ChatSource](
		Id int Primary Key,
		SourceName Varchar(200) Not Null
	) 
	Insert Into ChatSource Values(1,'EditUserPage');
	Insert Into ChatSource Values(2,'ITDashboard');
	Insert Into ChatSource Values(3,'InterviewPopup');
	Insert Into ChatSource Values(4,'TouchPointLogPage');
	Insert Into ChatSource Values(5,'ViewSalesUser');
	Insert Into ChatSource Values(6,'ViewApplicantUser');
	Insert Into ChatSource Values(7,'CreateSalesUser');
	Insert Into ChatSource Values(8,'TaskGenerator');
	Insert Into ChatSource Values(9,'TaskChat');
	Insert Into ChatSource Values(10,'UserChat');

	ALTER TABLE ChatMessage ADD CONSTRAINT FK_ChatMessage_ChatSourceId FOREIGN KEY (ChatSourceId)
		REFERENCES ChatSource(Id);
END
go

IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'tblScripts' AND column_name = 'DescriptionPlain')
BEGIN
	Alter Table tblScripts Add DescriptionPlain NVarchar(Max)
END 


GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'SP_GetScripts' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE SP_GetScripts
  END
Go
CREATE Procedure [dbo].[SP_GetScripts]  
(  
 @intScriptId int = null  
)  
As  
Begin  
 Select intScriptId, strScriptName, strScriptDescription, strScriptDescription as DescriptionPlain  from tblScripts  
 Where intScriptId =  CASE WHEN @intScriptId IS NULL THEN intScriptId ELSE @intScriptId END  
End  
