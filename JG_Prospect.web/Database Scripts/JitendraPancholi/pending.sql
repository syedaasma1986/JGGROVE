
Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetOnlineUsers' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetOnlineUsers
  END
Go 
/*

 GetOnlineUsers @LoggedInUserId=780, @SortBy='recent', @FilterBy='', @PageNumber=1, @DepartmentId=null,
			@PageSize=15, @Type='all', @UserStatus = 6

*/
Create PROCEDURE [dbo].[GetOnlineUsers] 
	@LoggedInUserId INT  ,
	@SortBy Varchar(100) = null,
	@FilterBy Varchar(100) = null,
	@PageNumber int = 1,
	@PageSize int = 5,
	@DepartmentId int = null,
	@Type varchar(20) = 'all',
	@MarkAllRead bit = 0,
	@UserStatus int = null
AS  
BEGIN  
	
	IF @MarkAllRead = 1
		Begin
			if @Type = 'all'
				begin
					Update S Set IsRead = 1 From ChatMessage M Join ChatMessageReadStatus S On S.ChatMessageId = M.Id
					Where S.IsRead = 0 
					And S.ReceiverId = @LoggedInUserId
				End
			Else If @Type = 'chats'
				begin
					Update S Set IsRead = 1 From ChatMessage M Join ChatMessageReadStatus S On S.ChatMessageId = M.Id
					Where S.IsRead = 0 And M.UserChatGroupId IS NULL 
					And S.ReceiverId = @LoggedInUserId
				End
			Else If @Type = 'groups'
				begin
					Update S Set IsRead = 1 From ChatMessage M Join ChatMessageReadStatus S On S.ChatMessageId = M.Id
					Where S.IsRead = 0 And M.UserChatGroupId IS NOT NULL 
					And S.ReceiverId = @LoggedInUserId
				End
		End


	if @PageNumber <= 0 
		begin set @PageNumber = 1 
	End
	Print 'page number'
	Print @PageNumber
    IF OBJECT_ID('tempdb..#OnlineUsersOrGroups') IS NOT NULL  
        DROP TABLE #OnlineUsersOrGroups;  
    DECLARE @ChatRoleId INT,  @LoggedInUserStatus INT, @LoggedInUserDepartmentId int, @LoggedInUserDesignationId int
  
    SELECT 
		@LoggedInUserStatus = Status  , 
		@LoggedInUserDepartmentId = DT.Id,
		@LoggedInUserDesignationId = LA.DesignationID
    FROM tblInstallUsers LA
	Join tbl_Designation D With(NoLock) On D.Id = LA.DesignationId
	Join tbl_Department DT on DT.Id = D.DepartmentId
    WHERE LA.Id = @LoggedInUserId;  
  
    IF OBJECT_ID('tempdb..#TempUserManagers') IS NOT NULL  
        DROP TABLE #TempUserManagers;  
    CREATE TABLE #TempUserManagers  
    (  
        Id INT PRIMARY KEY IDENTITY(1, 1),  
        ManagerId INT  
    );  
    INSERT INTO #TempUserManagers  
    (  
        ManagerId  
    )  
    SELECT DISTINCT  
           ManagerId  
    FROM UserManagers  
    WHERE UserId = @LoggedInUserId;  
  
    SELECT @ChatRoleId = RoleId  
    FROM ChatUserRole RU WITH (NOLOCK)  
        JOIN ChatRole R WITH (NOLOCK)  
            ON RU.RoleId = R.Id  
    WHERE RU.UserId = @LoggedInUserId;  
  
    ;WITH cte  
    AS (SELECT U.UserId,  
               MAX(U.OnlineAt) AS OnlineAt,  
               100 AS UserRank,  
               LA.Status AS UserStatus,  
               MAX(LA.LastLoginTimeStamp) AS LastLoginAt,  
               LA.FristName + ' ' + LA.LastName AS GroupOrUsername,  
               UserInstallId,  
               Picture, D.DepartmentId, DT.DepartmentName
        FROM ChatUser U WITH (NOLOCK)  
            JOIN tblInstallUsers LA WITH (NOLOCK) ON U.UserId = LA.Id  
			Join tbl_Designation D With(NoLock) On D.Id = LA.DesignationId
			Join tbl_Department DT on DT.Id = D.DepartmentId
        GROUP BY U.UserId,  
                 LA.Status,  
                 LA.FristName,  
                 LA.LastName,  
                 UserInstallId,  
                 Picture,
				 D.DepartmentId, 
				 DT.DepartmentName  
        UNION ALL  
        SELECT U.Id,  
               NULL,  
               CASE  
                   WHEN U.Status = 16 THEN  
                       1  
                   WHEN U.Status = 10 THEN  
                       2  
                   WHEN U.Status = 2 THEN  
                       3  
                   WHEN U.Status = 5 THEN  
                       4  
                   WHEN U.Status = 6  
                        AND ISNULL(@ChatRoleId, 0) = 1 THEN  
                       5  
                   WHEN U.Status = 1  
                        AND ISNULL(@ChatRoleId, 0) = 1 THEN  
                       6  
                   WHEN U.Status = 6  
                        AND ISNULL(@ChatRoleId, 0) <> 1 THEN  
                       1  
                   WHEN U.Status = 1  
                        AND ISNULL(@ChatRoleId, 0) <> 1 THEN  
                       2  
               END AS UserRank,  
               U.Status AS UserStatus,  
               U.LastLoginTimeStamp AS LastLoginAt,  
               U.FristName + ' ' + U.LastName AS UserFullName,  
               UserInstallId,  
               Picture  ,
			   D.DepartmentID, 
				DT.DepartmentName  
        FROM tblInstallUsers U WITH (NOLOCK)  
			Join tbl_Designation D With(NoLock) On D.Id = U.DesignationId
			Join tbl_Department DT on DT.Id = D.DepartmentID
            LEFT JOIN ChatUser AS cu WITH (NOLOCK)  
                ON cu.UserId = U.Id  
        WHERE cu.Id IS NULL  
              AND  
              (  
                  (  
                      ISNULL(@ChatRoleId, 0) = 1  
                      AND U.Status IN ( 16, 10, 2, 5, 6, 1 )  
                  )  
                  OR  
                  (  
                      ISNULL(@ChatRoleId, 0) <> 1  
                      AND U.Status IN ( 6, 1 )  
                  )  
              )),  
          cteonlineusers  
    AS (SELECT ROW_NUMBER() OVER (PARTITION BY c.UserId ORDER BY M.CreatedOn DESC) AS row,  
               c.*,  
               M.TextMessage AS LastMessage,  
               M.Id AS MessageId,  
               ISNULL(M.CreatedOn, '01-01-1900') AS MessageAt,  
               CAST(c.UserId AS NVARCHAR(1000)) AS ReceiverIds,  
               ISNULL(S.IsRead, 0) AS IsRead,  
               CAST(M.ChatGroupId AS NVARCHAR(MAX)) AS chatgroupid,  
               NULL AS TaskId,  
               NULL AS TaskMultilevelListId,  
               NULL AS UserChatGroupId,
			   NULL AS ChatGroupType,
			   CAST(NULL AS VARCHAR(8000)) As ChatGroupMemberImages,
               --NULL AS ChatUserCount,  
               CAST(NULL AS NVARCHAR(1000)) AS GroupNameAnchor,  
               0 AS UnreadCount,
			   0 As TotalAutoEntries
        FROM cte AS c  
            LEFT JOIN ChatMessage M WITH (NOLOCK)  
     ON (  
                       (  
                           M.SenderId = @LoggedInUserId  
                           AND M.ReceiverIds = CONVERT(VARCHAR(12), c.UserId)  
                       )  
                       OR  
                       (  
                           M.SenderId = c.UserId  
                           AND M.ReceiverIds = CONVERT(VARCHAR(12), @LoggedInUserId)  
                       )  
                   )  
                  -- AND M.ChatSourceId IN ( 2, 10 )  
                   AND M.UserChatGroupId IS NULL  
            LEFT JOIN ChatMessageReadStatus S WITH (NOLOCK)  
                ON S.ChatMessageId = M.Id  
                   AND  
                   (  
                       S.ReceiverId = @LoggedInUserId  
                       OR S.ReceiverId = c.UserId  
                   ))  
    SELECT *  
    INTO #OnlineUsersOrGroups  
    FROM cteonlineusers  
  WHERE row = 1;  
 
    WITH ctegroupusers  
    AS (SELECT row,  
               NULL AS UserId,  
               NULL AS OnlineAt,  
               NULL AS Userrank,  
               NULL AS userstatus,  
               NULL AS LastLoginAt,  
               CASE  
                   WHEN T.TaskId IS NOT NULL THEN  
                       T.Title  
                   WHEN TML.Id IS NOT NULL THEN  
                       TML.Title  
                   ELSE  
                       ''  
               END AS GroupOrUsername,  
               NULL AS UserInstallId,  
               Picture,  
			   DepartmentId, 
				DepartmentName  ,
               LastMessage,  
               MessageId,  
               MessageAt,  
               SUBSTRING(  
               (  
                   SELECT ',' + CONVERT(VARCHAR(20), S.UserId)  
                   FROM UserChatGroupMember S  
                   WHERE S.UserChatGroupId = tbl.UserChatGroupId  
                   ORDER BY S.UserId  
                   FOR XML PATH('')  
               ),  
               2,  
               800  
                        ) AS ReceiverIds,  
               IsRead,  
               ChatGroupId,  
               tbl.TaskId,  
               tbl.TaskMultilevelListId,  
               UserChatGroupId,
			   ChatGroupType,
			   dbo.ChatGroupUserImagesByChatGroupId(UserChatGroupId) As ChatGroupMemberImages,
               --(SELECT Count(userid)   
               -- FROM   userchatgroupmember S   
               -- WHERE  S.userchatgroupid = userchatgroupid) AS ChatUserCount,  
               dbo.[Udf_getonlineuserstitle](tbl.TaskId, tbl.TaskMultilevelListId) AS GroupNameAnchor,  
               0 AS UnreadCount,
			   0 As TotalAutoEntries
        FROM  
        (  
            SELECT ROW_NUMBER() OVER (PARTITION BY G.Id ORDER BY M.CreatedOn DESC) AS row,  
                   M.ChatGroupId,  
                   M.TextMessage AS LastMessage,  
                   M.Id AS MessageId,  
                   ISNULL(M.CreatedOn, '01-01-1900') AS MessageAt,  
                   (case When M.TaskId IS NULL Then 'hr_logo.jpg' Else 'op_logo.jpg' End) AS Picture,  
				   null As DepartmentId ,null As DepartmentName,
                   CASE  
                       WHEN tChatRead.ChatMessageId IS NOT NULL THEN  
                           0  
                       ELSE  
                           1  
                   END AS IsRead,  
                   M.TaskId,  
                   M.TaskMultilevelListId,  
                   G.Id AS UserChatGroupId,
				   G.ChatGroupType,
				   dbo.ChatGroupUserImagesByChatGroupId(G.Id) As ChatGroupMemberImages
            FROM UserChatGroup G WITH (NOLOCK)  
                JOIN UserChatGroupMember MM WITH (NOLOCK)  
                    ON G.Id = MM.UserChatGroupId  
                LEFT JOIN ChatMessage M WITH (NOLOCK)  
    ON M.UserChatGroupId = G.Id  
                LEFT JOIN  
                (  
                    SELECT ChatMessageId  
                    FROM ChatMessageReadStatus S WITH (NOLOCK)  
                    WHERE ISNULL(IsRead, 0) = 0  
         GROUP BY ChatMessageId  
                ) AS tChatRead  
                    ON tChatRead.ChatMessageId = M.Id  
            WHERE MM.UserId = @LoggedInUserId  
        ) AS tbl  
            LEFT JOIN tblTask T  
                ON tbl.TaskId = T.TaskId  
            LEFT JOIN tblTaskMultilevelList TML  
                ON tbl.TaskMultilevelListId = TML.Id  
        WHERE row = 1)  
    INSERT INTO #OnlineUsersOrGroups  
    SELECT *  
    FROM ctegroupusers G;  
   -- select * from #OnlineUsersOrGroups  
  
    UPDATE #OnlineUsersOrGroups  
    SET GroupOrUsername = SUBSTRING(  
                          (  
                              SELECT ' - ' + s.Fullname  
                              FROM  
                              (  
                                  SELECT (U.FristName + ' ' + U.LastName) AS Fullname  
                                  FROM tblInstallUsers U  
                                  WHERE U.Id IN (  
                                                    SELECT RESULT FROM dbo.CSVtoTable(ReceiverIds, ',')  
                                                )  
                              ) s  
                              ORDER BY s.Fullname  
                              FOR XML PATH('')  
                          ),  
                          4,  
                          800  
                                   )  
    WHERE UserId IS NULL AND ISNULL(GroupOrUsername,'') = '';  
  
    UPDATE G  
    SET G.UnreadCount = (CASE  
                             WHEN G.UserChatGroupId IS NOT NULL THEN  
                             (  
                                 SELECT COUNT(1)  
                                 FROM ChatMessageReadStatus S WITH (NOLOCK)  
                                     JOIN ChatMessage M WITH (NOLOCK)  
                                         ON M.Id = S.ChatMessageId  
                                 WHERE S.IsRead = 0  
                                       AND M.UserChatGroupId = G.UserChatGroupId  
                                       AND ',' + G.ReceiverIds + ',' LIKE '%,' + CONVERT(VARCHAR(12), M.SenderId) + ',%'  
                                       AND S.ReceiverId = @LoggedInUserId
									   And M.TextMessage not like '<span class="auto-entry"%' 
									   And M.TextMessage not like '<span class=''auto-entry''%'
                             )  
                             ELSE  
                         (  
                             SELECT COUNT(1)  
                             FROM ChatMessageReadStatus S WITH (NOLOCK)  
                                 JOIN ChatMessage M WITH (NOLOCK)  
                                     ON M.Id = S.ChatMessageId  
                             WHERE S.IsRead = 0  
                                   AND M.ChatGroupId = G.chatgroupid  
                                   
								   AND ',' + G.ReceiverIds + ',' LIKE '%,' + CONVERT(VARCHAR(12), M.SenderId) + ',%'  
                                   AND S.ReceiverId = @LoggedInUserId  
                                   AND M.UserChatGroupId IS NULL  
								   And M.TextMessage not like '<span class="auto-entry"%' 
								   And M.TextMessage not like '<span class=''auto-entry''%'
                         )  
                         END  
                        )  ,
	G.TotalAutoEntries = (Case When G.UserChatGroupId IS Not NUll Then
								(
									Select Count(Id) From ChatMessage M Where M.UserChatGroupId = G.UserChatGroupId
									And (M.TextMessage like '<span class="auto-entry"%' OR M.TextMessage like '<span class=''auto-entry''%')
								) Else 0 End)
    FROM #OnlineUsersOrGroups G;  
    -- Update Unread Count   
	
	
	 
  print @LoggedInUserStatus
  /*
	check for applicant, referral applicant, interview date applicant, offermade – applicant, Interview Date Expired, Applicant: Aptitude Test, Opportunity Notice: Applicant
*/
    IF @LoggedInUserStatus in (2, 10, 5, 6, 16, 17, 18) -- InterviewDate  
    BEGIN  
        SELECT TOP 200
               *  
        FROM #OnlineUsersOrGroups O Where UserChatGroupId IS NOT NULL
        
		/*WHERE O.UserId IN (  
                              SELECT ManagerId FROM #TempUserManagers  
                          )  
              OR  
              (  
                  SELECT COUNT(1)  
                  FROM #TempUserManagers M  
                      JOIN UserChatGroupMember UM  
                          ON M.ManagerId = UM.UserId  
                  WHERE UM.UserChatGroupId = O.UserChatGroupId  
              ) > 0  
		*/
        ORDER BY MessageAt /*,O.MessageAt*/ DESC;  
    END;  
    ELSE  
    BEGIN  
		If @Type = 'Calls'
			Begin
				If @SortBy = 'recent'
					Begin
						Select P.ReceiverUserId As UserId, U.LastLoginTimeStamp as OnlineAt, 100 As UserRank, 1 As UserStatus,  
							U.LastLoginTimeStamp AS LastLoginAt, U.FristName +' '+U.LastName As GroupOrUsername, U.UserInstallId, U.Picture, 
							D.DepartmentId, DT.DepartmentName, 'Called at ' + Convert(Varchar(200),P.CallStartTime) As LastMessage, 
							P.CreatedOn As LastMessageAt, null As MessageId, 
							P.CallStartTime As MessageAt, P.ReceiverUserId As ReceiverIds, Convert(Bit,1) As IsRead, NULL AS ChatGroupId, Null As TaskId,
							NUll As TaskMultiLevelListId, NULL As UserChatGroupId, '' As ChatGroupType, 
							CAST(NULL AS VARCHAR(8000)) As ChatGroupMemberImages,
							NULL As GroupNameAnchor, 0 As UnreadCount, 0 As TotalAutoEntries
						From PhoneCallLog P With (NoLock)
							Join tblInstallUsers U On P.ReceiverUserId = U.Id
							Join tbl_Designation D With(NoLock) On D.Id = U.DesignationId
							Join tbl_Department DT on DT.Id = D.DepartmentId
						Where P.CreatedBy = @LoggedInUserId
						Order by P.CreatedOn Desc
						OFFSET @PageSize * (@PageNumber - 1) ROWS
						FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
					End
				If @SortBy = 'missed'
					Begin
						Select P.ReceiverUserId As UserId, U.LastLoginTimeStamp as OnlineAt, 100 As UserRank, 1 As UserStatus,  
							U.LastLoginTimeStamp AS LastLoginAt, U.FristName +' '+U.LastName As GroupOrUsername, U.UserInstallId, U.Picture, 
							D.DepartmentId, DT.DepartmentName, 'Called at ' + Convert(Varchar(200),P.CallStartTime) As LastMessage, 
							P.CreatedOn As LastMessageAt, null As MessageId, 
							P.CallStartTime As MessageAt, P.ReceiverUserId As ReceiverIds, Convert(Bit,1) As IsRead, NULL AS ChatGroupId, Null As TaskId,
							NUll As TaskMultiLevelListId, NULL As UserChatGroupId, '' As ChatGroupType, 
							CAST(NULL AS VARCHAR(8000)) As ChatGroupMemberImages,
							NULL As GroupNameAnchor, 0 As UnreadCount, 0 As TotalAutoEntries
						From PhoneCallLog P With (NoLock)
							Join tblInstallUsers U On P.ReceiverUserId = U.Id
							Join tbl_Designation D With(NoLock) On D.Id = U.DesignationId
							Join tbl_Department DT on DT.Id = D.DepartmentId
						Where P.CreatedBy = @LoggedInUserId And P.CallDurationInSeconds = 0
						Order by P.CreatedOn Desc
						OFFSET @PageSize * (@PageNumber - 1) ROWS
						FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
					End
				If @SortBy = 'mngr'
					Begin
						Select P.ReceiverUserId As UserId, U.LastLoginTimeStamp as OnlineAt, 100 As UserRank, 1 As UserStatus,  
							U.LastLoginTimeStamp AS LastLoginAt, U.FristName +' '+U.LastName As GroupOrUsername, U.UserInstallId, U.Picture, 
							D.DepartmentId, DT.DepartmentName, 'Called at ' + Convert(Varchar(200),P.CallStartTime) As LastMessage, 
							P.CreatedOn As LastMessageAt, null As MessageId, 
							P.CallStartTime As MessageAt, P.ReceiverUserId As ReceiverIds, Convert(Bit,1) As IsRead, NULL AS ChatGroupId, Null As TaskId,
							NUll As TaskMultiLevelListId, NULL As UserChatGroupId, '' As ChatGroupType, 
							CAST(NULL AS VARCHAR(8000)) As ChatGroupMemberImages,
							NULL As GroupNameAnchor, 0 As UnreadCount, 0 As TotalAutoEntries
						From PhoneCallLog P With (NoLock)
							Join tblInstallUsers U On P.ReceiverUserId = U.Id
							Join tbl_Designation D With(NoLock) On D.Id = U.DesignationId
							Join tbl_Department DT on DT.Id = D.DepartmentId
						Where P.CreatedBy != @LoggedInUserId
						Order by P.CreatedOn Desc
						OFFSET @PageSize * (@PageNumber - 1) ROWS
						FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
					End
				/*OFFSET @PageSize * (@PageNumber - 1) ROWS
				FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);*/
			End
		Else if @FilterBy = 'department'
			Begin
				If @DepartmentId IS NULL
					Begin
						SELECT TOP 5 * INTO #DepartmentOnlineUsersOrGroups FROM #OnlineUsersOrGroups Where 1=2
						If @LoggedInUserDesignationId in (1, 3, 4, 5, 6, 21, 22, 23, 1034, 1035)
							Begin
								Insert Into #DepartmentOnlineUsersOrGroups
								SELECT TOP 5 * FROM #OnlineUsersOrGroups Where DepartmentID = @LoggedInUserDepartmentId 
								And  MessageId is not null And (UserID != @LoggedInUserId OR UserId IS NULL)
								ORDER BY MessageAt DESC, GroupOrUsername ASC
							End
						Else
							Begin
								Insert Into #DepartmentOnlineUsersOrGroups
								SELECT TOP 5 * FROM #OnlineUsersOrGroups Where DepartmentID = @LoggedInUserDepartmentId And  
								MessageId is not null And UserStatus in (1)  And (UserID != @LoggedInUserId OR UserId IS NULL)
								ORDER BY MessageAt DESC, GroupOrUsername ASC
							End
						If @LoggedInUserDesignationId in (1, 3, 4, 5, 6, 21, 22, 23, 1034, 1035)
							Begin
								Insert Into #DepartmentOnlineUsersOrGroups
								SELECT TOP 5 * FROM #OnlineUsersOrGroups Where DepartmentID = 3 And DepartmentID != @LoggedInUserDepartmentId 
								And  MessageId is not null  And (UserID != @LoggedInUserId OR UserId IS NULL)
								ORDER BY MessageAt DESC, GroupOrUsername ASC
							End
						Else
							Begin
								Insert Into #DepartmentOnlineUsersOrGroups
								SELECT TOP 5 * FROM #OnlineUsersOrGroups Where DepartmentID = 3 And DepartmentID != @LoggedInUserDepartmentId 
								And  MessageId is not null And UserStatus in (1) And (UserID != @LoggedInUserId OR UserId IS NULL) 
								ORDER BY MessageAt DESC, GroupOrUsername ASC
							End
						If @LoggedInUserDesignationId in (1, 3, 4, 5, 6, 21, 22, 23, 1034, 1035)
							Begin
								Insert Into #DepartmentOnlineUsersOrGroups
								SELECT TOP 5 * FROM #OnlineUsersOrGroups Where DepartmentID = 4 And DepartmentID != @LoggedInUserDepartmentId 
								And  MessageId is not null And (UserID != @LoggedInUserId OR UserId IS NULL) 
								ORDER BY MessageAt DESC, GroupOrUsername ASC
							End
						Else
							Begin
								Insert Into #DepartmentOnlineUsersOrGroups
								SELECT TOP 5 * FROM #OnlineUsersOrGroups Where DepartmentID = 4 And DepartmentID != @LoggedInUserDepartmentId 
								And  MessageId is not null And UserStatus in (1) And (UserID != @LoggedInUserId OR UserId IS NULL) 
								ORDER BY MessageAt DESC, GroupOrUsername ASC
							End
						If @LoggedInUserDesignationId in (1, 3, 4, 5, 6, 21, 22, 23, 1034, 1035)
							Begin
								Insert Into #DepartmentOnlineUsersOrGroups
								SELECT TOP 5 * FROM #OnlineUsersOrGroups Where DepartmentID = 1 And DepartmentID != @LoggedInUserDepartmentId 
								And  MessageId is not null And (UserID != @LoggedInUserId OR UserId IS NULL) 
								ORDER BY MessageAt DESC, GroupOrUsername ASC
							End
						Else
							Begin
								Insert Into #DepartmentOnlineUsersOrGroups
								SELECT TOP 5 * FROM #OnlineUsersOrGroups Where DepartmentID = 1 And DepartmentID != @LoggedInUserDepartmentId 
								And  MessageId is not null And UserStatus in (1) And (UserID != @LoggedInUserId OR UserId IS NULL) 
								ORDER BY MessageAt DESC, GroupOrUsername ASC
							End
						If @LoggedInUserDesignationId in (1, 3, 4, 5, 6, 21, 22, 23, 1034, 1035)
							Begin
								Insert Into #DepartmentOnlineUsersOrGroups
								SELECT TOP 5 * FROM #OnlineUsersOrGroups Where DepartmentID = 2 And DepartmentID != @LoggedInUserDepartmentId 
								And  MessageId is not null And (UserID != @LoggedInUserId OR UserId IS NULL) 
								ORDER BY MessageAt DESC, GroupOrUsername ASC
							End
						Else
							Begin
								Insert Into #DepartmentOnlineUsersOrGroups
								SELECT TOP 5 * FROM #OnlineUsersOrGroups Where DepartmentID = 2 And DepartmentID != @LoggedInUserDepartmentId 
								And  MessageId is not null And UserStatus in (1) And (UserID != @LoggedInUserId OR UserId IS NULL) 
								ORDER BY MessageAt DESC, GroupOrUsername ASC
							End

						Select * From #DepartmentOnlineUsersOrGroups
					End
				Else
					Begin
						SELECT * FROM #OnlineUsersOrGroups Where DepartmentID = @DepartmentId And  MessageId is not null
							 And (UserID != @LoggedInUserId OR UserId IS NULL)
							ORDER BY MessageAt DESC, GroupOrUsername ASC
							OFFSET @PageSize * (@PageNumber - 1) ROWS
							FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
					End
			End
		Else If @SortBy = 'unread'
			begin
				If  @Type = 'all' 
					Begin
						If @LoggedInUserDesignationId in (1, 3, 4, 5, 6, 21, 22, 23, 1034, 1035)
							Begin
								SELECT * FROM #OnlineUsersOrGroups Where MessageId is not null 
								 And (UserID != @LoggedInUserId OR UserId IS NULL)
								ORDER BY UnreadCount, GroupOrUsername Desc
								OFFSET @PageSize * (@PageNumber - 1) ROWS
								FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
							End
						Else
							Begin	
								SELECT * FROM #OnlineUsersOrGroups Where MessageId is not null And 
								(UserStatus in (1) OR UserStatus IS NULL) 
								 And (UserID != @LoggedInUserId OR UserId IS NULL)
								 ORDER BY UnreadCount, GroupOrUsername Desc
								OFFSET @PageSize * (@PageNumber - 1) ROWS
								FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
							End
					End
				If  @Type = 'groups' 
					Begin
						SELECT * FROM #OnlineUsersOrGroups Where MessageId is not null and UserId is null 
						 And (UserID != @LoggedInUserId OR UserId IS NULL)
						ORDER BY UnreadCount, GroupOrUsername Desc
						OFFSET @PageSize * (@PageNumber - 1) ROWS
						FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
					End
			end
		else if @SortBy = 'active'
			Begin
				If  @Type = 'all' 
					Begin
						If @LoggedInUserDesignationId in (1, 3, 4, 5, 6, 21, 22, 23, 1034, 1035)
							Begin
								SELECT * FROM #OnlineUsersOrGroups Where MessageId is not null 
									And UserChatGroupId Is Null
									And (UserStatus in (1))  And (UserID != @LoggedInUserId OR UserId IS NULL)
									ORDER BY OnlineAt, GroupOrUsername DESC
									OFFSET @PageSize * (@PageNumber - 1) ROWS
									FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
							End
						Else
							Begin
								SELECT * FROM #OnlineUsersOrGroups Where MessageId is not null And 
								(UserStatus in (1) OR UserStatus IS NULL)
								And (UserID != @LoggedInUserId OR UserId IS NULL)  And UserChatGroupId IS NULL
								ORDER BY OnlineAt, GroupOrUsername DESC
								OFFSET @PageSize * (@PageNumber - 1) ROWS
								FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
							End
					End
				If  @Type = 'chats'
					Begin
						If @LoggedInUserDesignationId in (1, 3, 4, 5, 6, 21, 22, 23, 1034, 1035)
							Begin
								SELECT * FROM #OnlineUsersOrGroups Where UserId IS NOT NULL And MessageId is not null 
								And UserChatGroupId Is Null And UserStatus in (1) And (UserID != @LoggedInUserId OR UserId IS NULL)
								ORDER BY OnlineAt, GroupOrUsername DESC
								OFFSET @PageSize * (@PageNumber - 1) ROWS
								FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
							End
						Else
							Begin
								SELECT * FROM #OnlineUsersOrGroups Where UserId IS NOT NULL And MessageId is not null 
								And UserChatGroupId Is Null And UserStatus in (1) And (UserID != @LoggedInUserId OR UserId IS NULL) 
								ORDER BY OnlineAt, GroupOrUsername DESC
								OFFSET @PageSize * (@PageNumber - 1) ROWS
								FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
							End
					End
				If  @Type = 'groups' 
					Begin
						SELECT * FROM #OnlineUsersOrGroups Where UserId IS NULL And MessageId is not null
						 And (UserID != @LoggedInUserId OR UserId IS NULL) ORDER BY OnlineAt, GroupOrUsername DESC
						OFFSET @PageSize * (@PageNumber - 1) ROWS
						FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
					End
			End
		else if @SortBy = 'recent'
			Begin
				If  @Type = 'all' 
					Begin
						If @LoggedInUserDesignationId in (1, 3, 4, 5, 6, 21, 22, 23, 1034, 1035)
							Begin
								SELECT * FROM #OnlineUsersOrGroups Where MessageId is not null 
								 And (UserID != @LoggedInUserId OR UserId IS NULL)
								 ORDER BY MessageAt DESC, GroupOrUsername ASC
								OFFSET @PageSize * (@PageNumber - 1) ROWS
								FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
							End
						Else
							Begin
								SELECT * FROM #OnlineUsersOrGroups Where MessageId is not null 
								And (UserStatus in (1) OR UserStatus IS NULL)
								 And (UserID != @LoggedInUserId OR UserId IS NULL)
								  ORDER BY MessageAt DESC, GroupOrUsername ASC
								OFFSET @PageSize * (@PageNumber - 1) ROWS
								FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
							End
					End
				If  @Type = 'chats'
					Begin
						If @LoggedInUserDesignationId in (1, 3, 4, 5, 6, 21, 22, 23, 1034, 1035)
							Begin
								SELECT * FROM #OnlineUsersOrGroups Where UserId IS NOT NULL And MessageId is not null
								 And (UserID != @LoggedInUserId OR UserId IS NULL) ORDER BY MessageAt DESC, GroupOrUsername ASC
								OFFSET @PageSize * (@PageNumber - 1) ROWS
								FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
							End
						Else
							Begin
								SELECT * FROM #OnlineUsersOrGroups Where UserId IS NOT NULL And MessageId is not null And UserStatus in (1)
								 And (UserID != @LoggedInUserId OR UserId IS NULL) ORDER BY MessageAt DESC, GroupOrUsername ASC
								OFFSET @PageSize * (@PageNumber - 1) ROWS
								FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
							End
					End
				If  @Type = 'online' 
					Begin
						If @LoggedInUserDesignationId in (1, 3, 4, 5, 6, 21, 22, 23, 1034, 1035)
							Begin
								SELECT TOP 5 * INTO #PrimaryStatusOnlineUsersOrGroups FROM #OnlineUsersOrGroups Where 1=2
								
								IF @UserStatus IS NULL OR @UserStatus = 1
									Begin
										Insert Into #PrimaryStatusOnlineUsersOrGroups
										SELECT * FROM #OnlineUsersOrGroups Where UserId IS NOT NULL And UserStatus in (1)
										 And (UserID != @LoggedInUserId OR UserId IS NULL) ORDER BY MessageAt DESC,OnlineAt Desc, GroupOrUsername ASC
											OFFSET @PageSize * (@PageNumber - 1) ROWS
											FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
									End
								IF @UserStatus IS NULL OR @UserStatus = 6
									Begin
										print 'status=6'
										print @PageSize
										print @PageNumber
										Insert Into #PrimaryStatusOnlineUsersOrGroups
										SELECT * FROM #OnlineUsersOrGroups Where UserId IS NOT NULL And UserStatus in (6)
										 And (UserID != @LoggedInUserId OR UserId IS NULL) ORDER BY MessageAt DESC,OnlineAt Desc, GroupOrUsername ASC
											OFFSET @PageSize * (@PageNumber - 1) ROWS
											FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
									End
								IF @UserStatus IS NULL OR @UserStatus = 5
									Begin
										Insert Into #PrimaryStatusOnlineUsersOrGroups
										SELECT * FROM #OnlineUsersOrGroups Where UserId IS NOT NULL And UserStatus in (5)
										 And (UserID != @LoggedInUserId OR UserId IS NULL) ORDER BY MessageAt DESC,OnlineAt Desc, GroupOrUsername ASC
											OFFSET @PageSize * (@PageNumber - 1) ROWS
											FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
									End
								IF @UserStatus IS NULL OR @UserStatus = 2
									Begin
										Insert Into #PrimaryStatusOnlineUsersOrGroups
										SELECT * FROM #OnlineUsersOrGroups Where UserId IS NOT NULL And UserStatus in (2)
										 And (UserID != @LoggedInUserId OR UserId IS NULL) ORDER BY MessageAt DESC,OnlineAt Desc, GroupOrUsername ASC
											OFFSET @PageSize * (@PageNumber - 1) ROWS
											FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
									End	
								IF @UserStatus IS NULL OR @UserStatus = 10
									Begin
										Insert Into #PrimaryStatusOnlineUsersOrGroups
										SELECT * FROM #OnlineUsersOrGroups Where UserId IS NOT NULL And UserStatus in (10)
										 And (UserID != @LoggedInUserId OR UserId IS NULL) ORDER BY MessageAt DESC,OnlineAt Desc, GroupOrUsername ASC
											OFFSET @PageSize * (@PageNumber - 1) ROWS
											FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
									End	
								Select * From #PrimaryStatusOnlineUsersOrGroups
							End							
						Else
							Begin
								SELECT * FROM #OnlineUsersOrGroups Where UserId IS NOT NULL /*And MessageId is not null */
								And UserStatus in (1) And (UserID != @LoggedInUserId OR UserId IS NULL) ORDER BY MessageAt DESC,OnlineAt Desc, GroupOrUsername ASC
								OFFSET @PageSize * (@PageNumber - 1) ROWS
								FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
							End
					End
				If  @Type = 'groups' 
					Begin
						If @LoggedInUserDesignationId in (1, 3, 4, 5, 6, 21, 22, 23, 1034, 1035)
							Begin
								SELECT * FROM #OnlineUsersOrGroups Where UserId IS NULL And MessageId is not null
								 And (UserID != @LoggedInUserId OR UserId IS NULL) ORDER BY MessageAt DESC, GroupOrUsername ASC
									OFFSET @PageSize * (@PageNumber - 1) ROWS
									FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
							End
						Else
							Begin
								SELECT * FROM #OnlineUsersOrGroups Where UserId IS NULL And MessageId is not null 
								And (UserStatus in (1) OR UserStatus IS NULL)
								 And (UserID != @LoggedInUserId OR UserId IS NULL) ORDER BY MessageAt DESC, GroupOrUsername ASC
									OFFSET @PageSize * (@PageNumber - 1) ROWS
									FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
							End
					End
			End
		else
			begin
				If @LoggedInUserDesignationId in (1, 3, 4, 5, 6, 21, 22, 23, 1034, 1035)
					Begin
						SELECT * FROM #OnlineUsersOrGroups Where MessageId is not null
						 And (UserID != @LoggedInUserId OR UserId IS NULL) ORDER BY MessageAt DESC, GroupOrUsername ASC
						OFFSET @PageSize * (@PageNumber - 1) ROWS
						FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
					End
				Else
					Begin
						SELECT * FROM #OnlineUsersOrGroups Where MessageId is not null And (UserStatus in (1) OR UserStatus IS NULL)
						 And (UserID != @LoggedInUserId OR UserId IS NULL) ORDER BY MessageAt DESC, GroupOrUsername ASC
							OFFSET @PageSize * (@PageNumber - 1) ROWS
							FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
					End
			end
    END;
	If @Type = 'Calls'
		Begin
			If @SortBy = 'recent'
					Begin
						Select Count(P.Id) As TotalCalls
						From PhoneCallLog P With (NoLock)
							Join tblInstallUsers U On P.ReceiverUserId = U.Id
							Join tbl_Designation D With(NoLock) On D.Id = U.DesignationId
							Join tbl_Department DT on DT.Id = D.DepartmentId
						Where P.CreatedBy = @LoggedInUserId 
					End
				If @SortBy = 'missed'
					Begin
						Select Count(P.Id) As TotalCalls
						From PhoneCallLog P With (NoLock)
							Join tblInstallUsers U On P.ReceiverUserId = U.Id
							Join tbl_Designation D With(NoLock) On D.Id = U.DesignationId
							Join tbl_Department DT on DT.Id = D.DepartmentId
						Where P.CreatedBy = @LoggedInUserId And P.CallDurationInSeconds = 0
					End
				If @SortBy = 'mngr'
					Begin
						Select Count(P.Id) As TotalCalls
						From PhoneCallLog P With (NoLock)
							Join tblInstallUsers U On P.ReceiverUserId = U.Id
							Join tbl_Designation D With(NoLock) On D.Id = U.DesignationId
							Join tbl_Department DT on DT.Id = D.DepartmentId
						Where P.CreatedBy != @LoggedInUserId
					End
		End
	Else
		Begin
			Select Count(P.ReceiverUserId) As TotalCalls
			From PhoneCallLog P With (NoLock)
				Join tblInstallUsers U On P.ReceiverUserId = U.Id
				Join tbl_Designation D With(NoLock) On D.Id = U.DesignationId
				Join tbl_Department DT on DT.Id = D.DepartmentId
			Where P.CreatedBy = @LoggedInUserId 
	End

	Select Count(id) As TotalAutoEntries From ChatMessage 
		Where (TextMessage like '<span class="auto-entry"%' OR TextMessage like '<span class=''auto-entry''%')		
		And (SenderId = @LoggedInUserId OR ',' + ReceiverIds + ',' like '%,' + Convert(Varchar(12), @LoggedInUserId) + ',%')

END;

Go
/*

Select dbo.Udf_getonlineuserstitle(11020,null)

*/
IF object_id(N'Udf_getonlineuserstitle', N'FN') IS NOT NULL
    DROP FUNCTION Udf_getonlineuserstitle
GO
CREATE FUNCTION [dbo].[Udf_getonlineuserstitle] (@TaskId               INT, 
                                                @TaskMultilevelListId INT) 
returns NVARCHAR(1000) 
AS 
  BEGIN 
      Declare @ParentTaskId int = null, @ChatGroupName NVarchar(2000) = '',  
   @TempChatGroupName NVarchar(200) = '', @Title NVarchar(1000), @TempTitle NVarchar(2000), @MainParentTaskId int
   , @OriginalTaskId int
   Set @OriginalTaskId = @TaskId
      SELECT @ParentTaskId = IsNull(T.parenttaskid,''), 
             @TempChatGroupName = T.installid, 
             @Title = '<a href="javascript:;">', 
             @TempTitle = T.title 
      FROM   tbltask T WITH(nolock) 
      WHERE  T.taskid = @TaskId 

      IF @TaskId IS NOT NULL 
         AND @ParentTaskId IS NOT NULL 
        BEGIN 
            IF @TaskMultilevelListId IS NULL 
              BEGIN 
                  SET @Title = 
'<a target="_blank" onclick="event.stopPropagation();" href="/Sr_App/TaskGenerator.aspx?TaskId={MainParentTaskId}&hstid=' 
+ CONVERT(VARCHAR(12), @TaskId) + '">' 
END 
ELSE 
  BEGIN 
      SET @Title = 
'<a target="_blank" onclick="event.stopPropagation();" href="/Sr_App/TaskGenerator.aspx?TaskId={MainParentTaskId}&hstid=' 
+ CONVERT(VARCHAR(12), @TaskId) + '&mcid=' 
+ CONVERT(VARCHAR(12), @TaskMultilevelListId) 
+ '">' 
END 
END 
ELSE IF @TaskId IS NOT NULL 
  BEGIN 
      IF @TaskMultilevelListId IS NULL 
        BEGIN 
            SET @Title = 
'<a target="_blank" onclick="event.stopPropagation();" href="/Sr_App/TaskGenerator.aspx?TaskId='
+ CONVERT(VARCHAR(12), @TaskId) + '">' 
END 
ELSE 
  BEGIN 
      SET @Title = 
'<a target="_blank" onclick="event.stopPropagation();" href="/Sr_App/TaskGenerator.aspx?TaskId='
+ CONVERT(VARCHAR(12), @TaskId) + '&mcid=' 
+ CONVERT(VARCHAR(12), @TaskMultilevelListId) 
+ '">' 
END 
END 

    WHILE @ParentTaskId IS NOT NULL 
      BEGIN 
          SELECT @TempChatGroupName = T.installid, 
                 @ParentTaskId = T.parenttaskid, 
                 @TaskId = T.parenttaskid 
          FROM   tbltask T WITH(nolock) 
          WHERE  T.taskid = @TaskId 
                 AND T.taskid = @TaskId 

          SET @ChatGroupName = @TempChatGroupName + '-' + @ChatGroupName 

          IF @ParentTaskId IS NOT NULL 
            BEGIN 
                SET @MainParentTaskId = @ParentTaskId 
            END 
      END 

    IF @TaskMultilevelListId IS NOT NULL 
      BEGIN 
          IF (SELECT title 
              FROM   tbltaskmultilevellist 
              WHERE  id = @TaskMultilevelListId) IS NOT NULL 
            BEGIN 
                SELECT @TempTitle = title 
                FROM   tbltaskmultilevellist 
                WHERE  id = @TaskMultilevelListId 
            END 
      END 

	  Declare @TempCustomTaskTitle varchar(800) = ''
	
	IF @TaskMultilevelListId IS NULL
		Begin
			Select @TempCustomTaskTitle = UserChatGroupTitle 
				From UserChatGroup Where TaskId = @OriginalTaskId And TaskMultilevelListId IS NULL
		End
	Else 
		Begin
			Select @TempCustomTaskTitle = UserChatGroupTitle 
			From UserChatGroup Where TaskId = @OriginalTaskId And TaskMultilevelListId = @TaskMultilevelListId
		End

	IF ISNULL(@TempCustomTaskTitle,'') != ''
		Begin
			Set @TempTitle = @TempCustomTaskTitle
		End

    SET @Title = @Title 
                 + Substring(@ChatGroupName, 0, Len(@ChatGroupName)) 
                 + '</a> - ' + @TempTitle 
    SET @Title = Replace(@Title, '{MainParentTaskId}', 
                 ISNULL(CONVERT(VARCHAR(12), @MainParentTaskId),''))  
	
	
    RETURN @Title
END 

Go
/*

Select dbo.Udf_getonlineuserstitle(11020,null)

*/
IF object_id(N'Udf_getonlineuserstitle', N'FN') IS NOT NULL
    DROP FUNCTION Udf_getonlineuserstitle
GO
CREATE FUNCTION [dbo].[Udf_getonlineuserstitle] (@TaskId               INT, 
                                                @TaskMultilevelListId INT) 
returns NVARCHAR(1000) 
AS 
  BEGIN 
      Declare @ParentTaskId int = null, @ChatGroupName NVarchar(2000) = '',  
   @TempChatGroupName NVarchar(200) = '', @Title NVarchar(1000), @TempTitle NVarchar(2000), @MainParentTaskId int
   , @OriginalTaskId int
   Set @OriginalTaskId = @TaskId
      SELECT @ParentTaskId = IsNull(T.parenttaskid,''), 
             @TempChatGroupName = T.installid, 
             @Title = '<a href="javascript:;">', 
             @TempTitle = T.title 
      FROM   tbltask T WITH(nolock) 
      WHERE  T.taskid = @TaskId 

      IF @TaskId IS NOT NULL 
         AND @ParentTaskId IS NOT NULL 
        BEGIN 
            IF @TaskMultilevelListId IS NULL 
              BEGIN 
                  SET @Title = 
'<a target="_blank" onclick="event.stopPropagation();" href="/Sr_App/TaskGenerator.aspx?TaskId={MainParentTaskId}&hstid=' 
+ CONVERT(VARCHAR(12), @TaskId) + '">' 
END 
ELSE 
  BEGIN 
      SET @Title = 
'<a target="_blank" onclick="event.stopPropagation();" href="/Sr_App/TaskGenerator.aspx?TaskId={MainParentTaskId}&hstid=' 
+ CONVERT(VARCHAR(12), @TaskId) + '&mcid=' 
+ CONVERT(VARCHAR(12), @TaskMultilevelListId) 
+ '">' 
END 
END 
ELSE IF @TaskId IS NOT NULL 
  BEGIN 
      IF @TaskMultilevelListId IS NULL 
        BEGIN 
            SET @Title = 
'<a target="_blank" onclick="event.stopPropagation();" href="/Sr_App/TaskGenerator.aspx?TaskId='
+ CONVERT(VARCHAR(12), @TaskId) + '">' 
END 
ELSE 
  BEGIN 
      SET @Title = 
'<a target="_blank" onclick="event.stopPropagation();" href="/Sr_App/TaskGenerator.aspx?TaskId='
+ CONVERT(VARCHAR(12), @TaskId) + '&mcid=' 
+ CONVERT(VARCHAR(12), @TaskMultilevelListId) 
+ '">' 
END 
END 

    WHILE @ParentTaskId IS NOT NULL 
      BEGIN 
          SELECT @TempChatGroupName = T.installid, 
                 @ParentTaskId = T.parenttaskid, 
                 @TaskId = T.parenttaskid 
          FROM   tbltask T WITH(nolock) 
          WHERE  T.taskid = @TaskId 
                 AND T.taskid = @TaskId 

          SET @ChatGroupName = @TempChatGroupName + '-' + @ChatGroupName 

          IF @ParentTaskId IS NOT NULL 
            BEGIN 
                SET @MainParentTaskId = @ParentTaskId 
            END 
      END 

    IF @TaskMultilevelListId IS NOT NULL 
      BEGIN 
          IF (SELECT title 
              FROM   tbltaskmultilevellist 
              WHERE  id = @TaskMultilevelListId) IS NOT NULL 
            BEGIN 
                SELECT @TempTitle = title 
                FROM   tbltaskmultilevellist 
                WHERE  id = @TaskMultilevelListId 
            END 
      END 

	  Declare @TempCustomTaskTitle varchar(800) = ''
	
	IF @TaskMultilevelListId IS NULL
		Begin
			Select @TempCustomTaskTitle = UserChatGroupTitle 
				From UserChatGroup Where TaskId = @OriginalTaskId And TaskMultilevelListId IS NULL
		End
	Else 
		Begin
			Select @TempCustomTaskTitle = UserChatGroupTitle 
			From UserChatGroup Where TaskId = @OriginalTaskId And TaskMultilevelListId = @TaskMultilevelListId
		End

	IF ISNULL(@TempCustomTaskTitle,'') != ''
		Begin
			Set @TempTitle = @TempCustomTaskTitle
		End

    SET @Title = @Title 
                 + Substring(@ChatGroupName, 0, Len(@ChatGroupName)) 
                 + '</a> - ' + @TempTitle 
    SET @Title = Replace(@Title, '{MainParentTaskId}', 
                 ISNULL(CONVERT(VARCHAR(12), @MainParentTaskId),''))  
	
	
    RETURN @Title
END 


Go
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
	SaveChatMessage @ChatSourceId=1,@ChatGroupId='dce9d4e6-3c50-459b-8ffb-15e9f3a7f439',@SenderId=780,@TextMessage='test msg',@ChatFileId=null,
					@ReceiverIds='858,901',@TaskId='0',@TaskMultilevelListId=0,@UserChatGroupId=0,@IsWelcomeEmail=0,@EmailStatusId=20145
*/
CREATE PROCEDURE [dbo].[SaveChatMessage]
	@ChatSourceId int,
	@ChatGroupId Varchar(100),
	@SenderId int,
	@TextMessage nvarchar(max),
	@ChatFileId int,
	@ReceiverIds varchar(800),
	@TaskId int = null,
	@TaskMultilevelListId int = null,
	@UserChatGroupId int = null,
	@IsWelcomeEmail bit = 0,
	@EmailStatusId bigint = null
AS    
BEGIN
	Declare @MessageId int
	IF @TaskId = 0 Begin Set @TaskId = Null End
	IF @TaskMultilevelListId = 0 Begin Set @TaskMultilevelListId = Null End
	IF @UserChatGroupId = 0 Begin Set @UserChatGroupId = Null End
	IF @EmailStatusId = 0 Begin Set @EmailStatusId = NULL End
	Declare @CreatedOn Datetime
	Set @CreatedOn = CONVERT(datetime, SWITCHOFFSET(GetUtcDate(), DATEPART(TZOFFSET, GetUtcDate() AT TIME ZONE 'Eastern Standard Time')))

	IF @TaskId IS NOT NULL And @UserChatGroupId IS NULL
		Begin
			If @TaskMultilevelListId IS NULL
				Begin
					Select @UserChatGroupId = Id From UserChatGroup Where TaskId = @TaskId
				End
			Else
				Begin
					Select @UserChatGroupId = Id From UserChatGroup Where TaskId = @TaskId And TaskMultilevelListId = @TaskMultilevelListId
				End
			IF @UserChatGroupId IS NULL
				Begin
					-- Create a group
					Insert Into UserChatGroup (CreatedBy) Values(@SenderId)
					Set @UserChatGroupId = IDENT_CURRENT('UserChatGroup')
					
					IF OBJECT_ID('tempdb..#TaskUsers') IS NOT NULL DROP TABLE #TaskUsers   
					Create Table #TaskUsers(UserId int, Aceptance bit, CreatedOn DateTime, StepCompeted int)
					Insert Into #TaskUsers Exec GetTaskUsers @TaskId

					Insert Into UserChatGroupMember (UserChatGroupId, UserId)
					Select @UserChatGroupId, UserId From #TaskUsers
				End
			Else
				Begin
					-- Check for new members
					IF OBJECT_ID('tempdb..#TaskUpdatedUsers') IS NOT NULL DROP TABLE #TaskUpdatedUsers   
					Create Table #TaskUpdatedUsers(UserId int, Aceptance bit, CreatedOn DateTime, StepCompeted int)
					Insert Into #TaskUpdatedUsers Exec GetTaskUsers @TaskId

					Delete from UserChatGroupMember Where UserChatGroupId = @UserChatGroupId
					Insert Into UserChatGroupMember (UserChatGroupId, UserId)
					Select @UserChatGroupId, UserId From #TaskUpdatedUsers
				End
		End
	Else IF @TaskId IS NULL And @UserChatGroupId IS NULL And @ChatSourceId NOT IN (10,11,12)
		Begin
			-- Create a group
			Insert Into UserChatGroup (CreatedBy) Values(@SenderId)
			Set @UserChatGroupId = IDENT_CURRENT('UserChatGroup')

			Insert Into UserChatGroupMember (UserChatGroupId, UserId) Values(@UserChatGroupId, 780)
			Insert Into UserChatGroupMember (UserChatGroupId, UserId) Values(@UserChatGroupId, 901)
			Insert Into UserChatGroupMember (UserChatGroupId, UserId) Values(@UserChatGroupId, @SenderId)

		End

	Insert Into ChatMessage(ChatSourceId, SenderId, ChatGroupId, TextMessage, ChatFileId, ReceiverIds, TaskId,
							TaskMultilevelListId, UserChatGroupId, CreatedOn, IsWelcomeEmail, EmailStatusId) 
	Values (@ChatSourceId, @SenderId, @ChatGroupId, @TextMessage, @ChatFileId, @ReceiverIds,@TaskId,
				@TaskMultilevelListId,@UserChatGroupId, @CreatedOn, @IsWelcomeEmail, @EmailStatusId)
	
	Set @MessageId = IDENT_CURRENT('ChatMessage')
	Insert Into ChatMessageReadStatus (ChatMessageId, ReceiverId) 
		Select @MessageId, RESULT from dbo.CSVtoTable(@ReceiverIds,',') Where RESULT > 0
END

Go
Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'usp_GetTaskDetails' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE usp_GetTaskDetails
  END
Go 
 ---- =============================================  
-- Author:  Yogesh Keraliya  
-- Create date: 04/07/2016  
-- Description: Load all details of task for edit.  
-- =============================================  
-- usp_GetTaskDetails 10816,3797  
Create PROCEDURE [dbo].[usp_GetTaskDetails]   
(  
 @TaskId int,
 @LoggedInUserId int = null
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
    (SELECT  CAST(', ' + ttuf.[Attachment] + '@' + ttuf.[AttachmentOriginal]  + '@' + CAST( ttuf.[AttachedFileDate] AS VARCHAR(100)) + '@' + (CASE WHEN ctuser.Id IS NULL THEN 'N.A.'ELSE ctuser.FristName + ' ' + ctuser.LastName END) as VARCHAR(max)) 
	AS attachment  
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
 --SELECT TaskUsers.Id,TaskUsers.UserId, TaskUsers.UserType, TaskUsers.Notes, TaskUsers.UserAcceptance, TaskUsers.UpdatedOn,   
 --     TaskUsers.[Status], TaskUsers.TaskId, tblInstallUsers.FristName,TaskUsers.UserFirstName, tblInstallUsers.Designation,  
 --  (SELECT COUNT(ttuf.[Id]) FROM dbo.tblTaskUserFiles ttuf WHERE ttuf.[TaskUpdateID] = TaskUsers.Id) AS AttachmentCount,  
 --  dbo.UDF_GetTaskUpdateAttachments(TaskUsers.Id) AS attachments  
 --FROM      
 -- tblTaskUser AS TaskUsers   
 -- LEFT OUTER JOIN tblInstallUsers ON TaskUsers.UserId = tblInstallUsers.Id  
 --WHERE (TaskUsers.TaskId = @TaskId)   
   
 -- Description: Get All Notes along with Attachments.  
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
    (SELECT  CAST(', ' + ttuf.[Attachment] + '@' + ttuf.[AttachmentOriginal] + '@' + CAST( ttuf.[AttachedFileDate] AS VARCHAR(100))+ '@'  + (CASE WHEN ctuser.Id IS NULL THEN 'N.A.'ELSE ctuser.FristName + ' ' + ctuser.LastName END) as VARCHAR(max))
	 AS attachment  
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
  
  /* Proper Task Title with ID */  /* Table[6] */
	Declare @ParentTaskId int = null, @ChatGroupName NVarchar(Max) = '', @TempChatGroupName NVarchar(Max) = '', 
			@Title NVarchar(Max), @MainParentTaskId int , @CustomTitle Varchar(Max)

	Select @TaskId = TaskId, @ParentTaskId = T.ParentTaskId, @TempChatGroupName = T.InstallId, 
			@Title = T.Title From tblTask T With(NoLock) Where T.TaskId = @TaskId

	Select @CustomTitle = UserChatGroupTitle From UserChatGroup Where TaskId = @TaskId And TaskMultilevelListId IS NULL
	IF ISNULL(@CustomTitle,'') != ''
		Begin
			Set @Title = @CustomTitle
		End

	If @TaskId IS NOT NULL AND @ParentTaskId IS NOT NULL
			Begin
				Set @Title = @Title + ' <a target="_blank" onclick="event.stopPropagation();" href="/Sr_App/TaskGenerator.aspx?TaskId={MainParentTaskId}&hstid=' + Convert(Varchar(12),@TaskId) + '">'
			End
		Else IF @TaskId IS NOT NULL
			Begin
				Set @Title = @Title + ' <a target="_blank" onclick="event.stopPropagation();" href="/Sr_App/TaskGenerator.aspx?TaskId=' + Convert(Varchar(12),@TaskId) + '">'
			End

	IF OBJECT_ID('tempdb..#TaskUsers') IS NOT NULL DROP TABLE #TaskUsers   
	Create Table #TaskUsers(UserId int, Aceptance bit, CreatedOn DateTime, StepCompleted bit)
	Insert Into #TaskUsers Exec GetTaskUsers @TaskId

	While @ParentTaskId Is Not Null
		Begin
			Select @TempChatGroupName = T.InstallId, @ParentTaskId = T.ParentTaskId, @TaskId = T.ParentTaskId
				From tblTask T With(NoLock) Where T.TaskId = @TaskId And T.TaskId = @TaskId
			Set @ChatGroupName =  @TempChatGroupName + '-' + @ChatGroupName
			IF @ParentTaskId Is NOT NUll
				Begin
					Set @MainParentTaskId = @ParentTaskId
				End
		End

	Set @Title = SUBSTRING(@Title + @ChatGroupName, 0, LEN(@Title + @ChatGroupName)) + '</a> : '
	Set @Title = Replace(@Title,'{MainParentTaskId}',Convert(Varchar(12),@MainParentTaskId))

	Select @Title = @Title + '<div class="chk-box-outer '+ 
		case when D.DesignationCode = 'ADM' Then 'red'
			 when D.DesignationCode = 'ITL' Then 'black'
			 when D.DesignationCode = 'ITJBA' OR D.DesignationCode = 'ITSBA' Then 'green'
			 When D.DesignationCode = 'ITQS' OR D.DesignationCode = 'ITQJ' THen 'orange'
			 Else 'blue'
		End	
	+' ' + Case When T.StepCompleted = 1 Then ' checked' Else '' End +'
	'+ Case When T.UserId = @LoggedInUserId Then '' Else ' disabled' End +
	'"><input uid="' + Convert(Varchar(12),U.Id) + '" '+
	Case When T.UserId = @LoggedInUserId Then '' Else ' disabled="disabled"' End + 
	'type="checkbox" '+ Case When T.StepCompleted = 1 Then 'checked="checked"' Else '' End +' /></div>' + 
	ISNULL(U.FristName,'') + ' ' + ISNULL(U.LastName,'') + '-' + '<a target="_blank" href="/Sr_App/ViewSalesUser.aspx?id='
	+Convert(Varchar(12),U.Id)+'" uid="'+Convert(Varchar(12),U.Id)+'">'+ISNULL(U.UserInstallId,'')+'</a>' + ', ' 
	From #TaskUsers T With(NoLock) 
	Join tblInstallUsers U With(NoLock) On T.UserId = U.Id
	Join tbl_Designation D On U.designationId = D.Id
	Order By U.Id Asc

	Set @Title = SUBSTRING(@Title, 0, LEN(@Title))

	Select @Title As TaskTitle
	/* Proper Task Title with ID */
END  

GO

GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetSalesUsers' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetSalesUsers
  END
Go 
  -- =============================================                
-- Author:  Jitendra Pancholi                
-- Create date: 9 Jan 2017             
-- Description: Add offline user to chatuser table          
-- =============================================               
/*
 [GetSalesUsers] @SearchTerm='',@Status=null,@SecondaryStatus=null,@DesignationId=null,@SourceId=null, @AddedByUserId=null, 
	@FromDate='01/01/1999', @ToDate='09/05/2018',@PageIndex=0,@PageSize=25, @SortExpression='CreatedDateTime DESC',
	@InterviewDateStatus='5',
	@RejectedStatus='9',@OfferMadeStatus='6',@ActiveStatus='1' ,@FirstTimeOpen=0,@LoggedInUserId=780
	
	*/           
CREATE PROCEDURE [dbo].[GetSalesUsers]              
	@SearchTerm VARCHAR(15) = NULL, @Status VARCHAR(50) = NULL, @SecondaryStatus Varchar (200) = null, @DesignationId VARCHAR(50) = NULL, 
	@SourceId VARCHAR(50)= NULL, @AddedByUserId VARCHAR(50) = NULL, @FromDate DATE = NULL,              
	@ToDate DATE = NULL, @PageIndex INT = NULL,  @PageSize INT = NULL, @SortExpression VARCHAR(50), 
	@InterviewDateStatus VARChAR(5) = '5',              
	@RejectedStatus VARChAR(5) = '9', @OfferMadeStatus VARChAR(5) = '6', @ActiveStatus VARChAR(5) = '1' ,
	@FirstTimeOpen bit = 0 , @LoggedInUserId  int              
AS              
BEGIN               
SET NOCOUNT ON;           
              
 IF IsNull(@Status,'') = ''              
 BEGIN              
  SET @Status = '2,17,18,5,6,10,19,20,21,12,9,1,3'              
 END  
 IF @SecondaryStatus = ''
	Begin
		Set @SecondaryStatus = null
	End            
 IF @DesignationId = ''              
 BEGIN              
  SET @DesignationId = NULL              
 END              
 IF @SourceId = ''              
 BEGIN              
  SET @SourceId = NULL              
 END              
 IF @AddedByUserId = ''             
 BEGIN              
  SET @AddedByUserId = NULL              
 END              
               
 SET @PageIndex = isnull(@PageIndex,0)              
 SET @PageSize = isnull(@PageSize,0)              
Declare @PageNumber float = 0
 DECLARE @StartIndex INT  = 0              
 SET @StartIndex = (@PageIndex * @PageSize) + 1              
Set @PageNumber = @PageIndex
Print @StartIndex
Print @PageNumber
  -- get statistics (Status) - Table 0               
  SELECT t.Status, COUNT(*) [Count]              
  FROM tblInstallUsers t               
   LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser              
   LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id              
   WHERE               
  (t.UserType = 'SalesUser' OR t.UserType = 'sales')              
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)               
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)              
 GROUP BY t.status              
              
 -- get statistics (AddedBy) - Table 1              
 SELECT ISNULL(U.Username, t2.FristName + '' + t2.LastName)  AS AddedBy, COUNT(*) [Count]               
 FROM tblInstallUsers t              
   LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser              
   LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser              
   LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id              
   LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id              
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales')              
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)              
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)              
 GROUP BY U.Username,t2.FristName,t2.LastName              
              
 -- get statistics (Designation) - Table 2              
 SELECT t.Designation, COUNT(*) [Count]               
 FROM tblInstallUsers t              
   LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser              
   LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id              
   LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id              
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales')              
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)              
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)              
 GROUP BY t.Designation              
              
 -- get statistics (Source) - Table 3              
 SELECT t.Source, COUNT(*) [Count]              
 FROM tblInstallUsers t              
   LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser         
   LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id              
   LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id              
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales')              
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)        
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)              
 GROUP BY t.Source              

/************************/
 Declare @CandidateUserId int = 0
  Select @CandidateUserId = CandidateUserId From CallPosition Where CallerUserId = @LoggedInUserId
  Print @CandidateUserId
  IF @FirstTimeOpen = 1 And @CandidateUserId > 0
	Begin
	 Declare @TempUsers TABLE  
	(  
	   Id int,
	   RowNumber int
	)  
	 ;WITH SalesUsers              
 AS              
 (SELECT t.Id, t.FristName, t.LastName, t.Phone, t.Zip, t.City, d.DesignationName AS Designation, t.Status, t.HireDate, t.InstallId,              
 t.picture, t.CreatedDateTime, Isnull(s.Source,'') AS Source, t.SourceUser, ISNULL(U.Username,t2.FristName + ' ' + t2.LastName)              
 AS AddedBy, ISNULL (t.UserInstallId,t.id) As UserInstallId,              
 InterviewDetail = case when (t.Status=@InterviewDateStatus) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR)  + ' ' + coalesce(t.InterviewTime,'')               
       else '' end,              
 RejectDetail = case when (t.[Status]=@RejectedStatus ) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR) + ' ' + coalesce(t.RejectionTime,'')               
       else '' end,              
 CASE when (t.[Status]= @RejectedStatus ) THEN t.RejectedUserId ELSE NULL END AS RejectedUserId,              
 CASE when (t.[Status]= @RejectedStatus ) THEN ru.FristName + ' ' + ru.LastName ELSE NULL END AS RejectedByUserName,              
 CASE when (t.[Status]= @RejectedStatus ) THEN ru.[UserInstallId]  ELSE NULL END AS RejectedByUserInstallId,              
 t.Email, t.DesignationID, ISNULL(t1.[UserInstallId], t2.[UserInstallId]) As AddedByUserInstallId,              
 ISNULL(t1.Id,t2.Id) As AddedById, t.emptype as 'EmpType', t.Phone As PrimaryPhone, t.CountryCode, t.Resumepath,              
 --ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId,              
 /*Task.TaskId AS 'TechTaskId', Task.ParentTaskId AS 'ParentTechTaskId', Task.InstallId as 'TechTaskInstallId'*/            
 0 AS 'TechTaskId', 0 AS 'ParentTechTaskId', '' as 'TechTaskInstallId'            
 , bm.bookmarkedUser,              
 t.[StatusReason], dbo.udf_GetUserExamPercentile(t.Id) AS [Aggregate],              
 ROW_NUMBER() OVER(ORDER BY              
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
   CASE WHEN @SortExpression = 'City ASC' THEN t.City END ASC,              
   CASE WHEN @SortExpression = 'City DESC' THEN t.City END DESC,               
   CASE WHEN @SortExpression = 'CreatedDateTime ASC' THEN t.CreatedDateTime END ASC,              
   CASE WHEN @SortExpression = 'CreatedDateTime DESC' THEN t.CreatedDateTime END DESC,              
   CASE WHEN @SortExpression = 'LastLoginTimeStamp DESC' THEN t.LastLoginTimeStamp END DESC   ,
   CASE WHEN @SortExpression = 'SecondaryStatus ASC' THEN t.SecondaryStatus END ASC,    
	   CASE WHEN @SortExpression = 'SecondaryStatus DESC' THEN t.SecondaryStatus END DESC
	   , IsNull(t.SecondaryStatus,0) Asc            
       ) AS RowNumber,            
    '' as Country,ISNULL(t.SalaryReq,'') as SalaryReq,ISNULL(c.Name,'') as CurrencyName  ,
	t.LastLoginTimeStamp, t.SecondaryStatus            
  FROM tblInstallUsers t              
  LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser              
  LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser              
  LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId= ru.Id              
  LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id              
  LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id              
  LEFT JOIN tblSource s ON t.SourceId = s.Id          
  LEFT JOIN Currency c on t.CurrencyID = c.CurrencyID      
  left outer join InstallUserBMLog as bm on t.id  =bm.bookmarkedUser and bm.isDeleted=0              
  OUTER APPLY              
 (               
 SELECT tsk.TaskId, tsk.ParentTaskId, tsk.InstallId, ROW_NUMBER() OVER(ORDER BY u.TaskUserId DESC) AS RowNo              
 FROM tblTaskAssignedUsers u              
 INNER JOIN tblTask tsk ON u.TaskId = tsk.TaskId AND              
 (tsk.ParentTaskId IS NOT NULL OR tsk.IsTechTask = 1)              
 WHERE u.UserId = t.Id              
 ) AS Task              
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales') AND (@SearchTerm IS NULL OR               
    1 = CASE WHEN t.InstallId LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.FristName LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.LastName LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.Email LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.Phone LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1
  WHEN t.Zip LIKE ''+ @SearchTerm + '%' THEN 1
  WHEN t.City LIKE ''+ @SearchTerm + '%' THEN 1
  ELSE 0
  END
  )              
AND t.[Status] IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@Status,t.[Status]),',') ss)
AND (t.[SecondaryStatus] IN (SELECT ss.Item  FROM dbo.SplitString(@SecondaryStatus,',') ss) Or (@SecondaryStatus IS Null))
 AND t.[Status] NOT IN (@OfferMadeStatus, @ActiveStatus)            
  And t.Phone Like'[0-9]%' And IsNull(t.CountryCode,'') !='' -- Exclude Bad number users  
 AND d.Id IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@DesignationId,d.Id),',') ss)         
 AND ISNULL(s.Id,'') IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@SourceId,ISNULL(s.Id,'')),',') ss)        
 AND ISNULL(t1.Id,t2.Id) IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@AddedByUserId,ISNULL(t1.Id,t2.Id)),',') ss)         
 AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)              
 AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)              
) 
Insert Into @TempUsers(ID, RowNumber)
	SELECT  Id, RowNumber
	FROM SalesUsers    
	ORDER BY CASE WHEN @SortExpression = 'Id ASC' THEN Id END ASC,    
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
	   CASE WHEN @SortExpression = 'CreatedDateTime DESC' THEN CreatedDateTime END DESC,
	   CASE WHEN @SortExpression = 'LastLoginTimeStamp ASC' THEN LastLoginTimeStamp END ASC,    
	   CASE WHEN @SortExpression = 'LastLoginTimeStamp DESC' THEN LastLoginTimeStamp END DESC,
	   CASE WHEN @SortExpression = 'SecondaryStatus ASC' THEN SecondaryStatus END ASC,    
	   CASE WHEN @SortExpression = 'SecondaryStatus DESC' THEN SecondaryStatus END DESC
		, IsNull(SecondaryStatus,0) Asc

		If Exists (Select 1 From @TempUsers Where Id = @CandidateUserId)
		Begin
			Select @PageIndex = RowNumber From @TempUsers Where Id = @CandidateUserId
			print @PageIndex


			Set @PageNumber = Convert(float, @PageIndex) / @PageSize
			If @PageNumber > (@PageIndex/ @PageSize) 
				Begin
					SET @StartIndex =  (Convert(int, @PageNumber) * @PageSize) + 1
					Set @PageNumber = Convert(int, @PageNumber)
				End
			Else
				Begin
					SET @StartIndex = (Convert(int, @PageNumber) - 1) * @PageSize + 1
					Set @PageNumber = Convert(int, @PageNumber) - 1
				End
			  /*   ((@PageIndex-1) * @PageSize) + 1 */

			Print 'ssss'
			Print @StartIndex
			Print @PageNumber
			End
 End
 
 
 /****************************/  
 -- get records - Table 4          
 ;WITH SalesUsers              
 AS              
 (SELECT t.Id, t.FristName, t.LastName, t.Phone, t.Zip, t.City, d.DesignationName AS Designation, t.Status, t.HireDate, t.InstallId,              
 t.picture, t.CreatedDateTime, Isnull(s.Source,'') AS Source, t.SourceUser, ISNULL(U.Username,t2.FristName + ' ' + t2.LastName)              
 AS AddedBy, ISNULL (t.UserInstallId,t.id) As UserInstallId,              
 InterviewDetail = case when (t.Status=@InterviewDateStatus) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR)  + ' ' + coalesce(t.InterviewTime,'')               
       else '' end,              
 RejectDetail = case when (t.[Status]=@RejectedStatus ) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR) + ' ' + coalesce(t.RejectionTime,'')               
       else '' end,              
 CASE when (t.[Status]= @RejectedStatus ) THEN t.RejectedUserId ELSE NULL END AS RejectedUserId,              
 CASE when (t.[Status]= @RejectedStatus ) THEN ru.FristName + ' ' + ru.LastName ELSE NULL END AS RejectedByUserName,              
 CASE when (t.[Status]= @RejectedStatus ) THEN ru.[UserInstallId]  ELSE NULL END AS RejectedByUserInstallId,              
 t.Email, t.DesignationID, ISNULL(t1.[UserInstallId], t2.[UserInstallId]) As AddedByUserInstallId,              
 ISNULL(t1.Id,t2.Id) As AddedById, t.emptype as 'EmpType', t.Phone As PrimaryPhone, t.CountryCode, t.Resumepath,              
 --ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId,              
 /*Task.TaskId AS 'TechTaskId', Task.ParentTaskId AS 'ParentTechTaskId', Task.InstallId as 'TechTaskInstallId'*/            
 0 AS 'TechTaskId', 0 AS 'ParentTechTaskId', '' as 'TechTaskInstallId'            
 , bm.bookmarkedUser,              
 t.[StatusReason], dbo.udf_GetUserExamPercentile(t.Id) AS [Aggregate],              
 ROW_NUMBER() OVER(ORDER BY              
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
   CASE WHEN @SortExpression = 'City ASC' THEN t.City END ASC,              
   CASE WHEN @SortExpression = 'City DESC' THEN t.City END DESC,               
   CASE WHEN @SortExpression = 'CreatedDateTime ASC' THEN t.CreatedDateTime END ASC,              
   CASE WHEN @SortExpression = 'CreatedDateTime DESC' THEN t.CreatedDateTime END DESC,              
   CASE WHEN @SortExpression = 'LastLoginTimeStamp DESC' THEN t.LastLoginTimeStamp END DESC   ,
   CASE WHEN @SortExpression = 'SecondaryStatus ASC' THEN t.SecondaryStatus END ASC,    
	   CASE WHEN @SortExpression = 'SecondaryStatus DESC' THEN t.SecondaryStatus END DESC
	   , IsNull(t.SecondaryStatus,0) Asc            
       ) AS RowNumber,            
    '' as Country,ISNULL(t.SalaryReq,'') as SalaryReq,ISNULL(c.Name,'') as CurrencyName  ,
	t.LastLoginTimeStamp, t.SecondaryStatus            
  FROM tblInstallUsers t              
  LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser              
  LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser              
  LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId= ru.Id              
  LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id              
  LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id              
  LEFT JOIN tblSource s ON t.SourceId = s.Id          
  LEFT JOIN Currency c on t.CurrencyID = c.CurrencyID      
  left outer join InstallUserBMLog as bm on t.id  =bm.bookmarkedUser and bm.isDeleted=0              
  OUTER APPLY              
 (               
 SELECT tsk.TaskId, tsk.ParentTaskId, tsk.InstallId, ROW_NUMBER() OVER(ORDER BY u.TaskUserId DESC) AS RowNo              
 FROM tblTaskAssignedUsers u              
 INNER JOIN tblTask tsk ON u.TaskId = tsk.TaskId AND              
 (tsk.ParentTaskId IS NOT NULL OR tsk.IsTechTask = 1)              
 WHERE u.UserId = t.Id              
 ) AS Task              
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales') AND (@SearchTerm IS NULL OR               
    1 = CASE WHEN t.InstallId LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.FristName LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.LastName LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.Email LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.Phone LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1              
  WHEN t.Zip LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.City LIKE ''+ @SearchTerm + '%' THEN 1              
  ELSE 0              
  END              
  )              
AND t.[Status] IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@Status,t.[Status]),',') ss)
AND (t.[SecondaryStatus] IN (SELECT ss.Item  FROM dbo.SplitString(@SecondaryStatus,',') ss) Or (@SecondaryStatus IS Null))
 AND t.[Status] NOT IN (@OfferMadeStatus, @ActiveStatus)            
  And t.Phone Like'[0-9]%' And IsNull(t.CountryCode,'') !='' -- Exclude Bad number users  
 AND d.Id IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@DesignationId,d.Id),',') ss)         
 AND ISNULL(s.Id,'') IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@SourceId,ISNULL(s.Id,'')),',') ss)        
 AND ISNULL(t1.Id,t2.Id) IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@AddedByUserId,ISNULL(t1.Id,t2.Id)),',') ss)         
 AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)              
 AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)              
)              
SELECT  Id, FristName, LastName, Phone, Zip, Designation, Status, HireDate, InstallId, picture, CreatedDateTime, Source, SourceUser,LastLoginTimeStamp,              
AddedBy, UserInstallId, InterviewDetail, RejectDetail, RejectedUserId, RejectedByUserName, RejectedByUserInstallId, Email, DesignationID,              
AddedByUserInstallId, AddedById, EmpType, [Aggregate], PrimaryPhone, CountryCode, Resumepath, TechTaskId, ParentTechTaskId,              
TechTaskInstallId, bookmarkedUser,  [StatusReason], Country, City,          
(Select top 1 CallStartTime From PhoneCallLog PCL WIth(NoLOck) Where PCL.ReceiverUserId = SalesUsers.Id Order by CreatedOn Desc) as LastCalledAt,          
IsNull((Select top 1 PhoneCode From Country CT WIth(NoLOck)           
 Where CT.CountryCodeTwoChar = SalesUsers.CountryCode Or CT.CountryCodeThreeChar = SalesUsers.CountryCode),'1') as PhoneCode,
 SalesUsers.SalaryReq,SalesUsers.CurrencyName,
 CONVERT(datetime, SWITCHOFFSET(LastLoginTimeStamp, DATEPART(TZOFFSET, LastLoginTimeStamp AT TIME ZONE 'Eastern Standard Time'))) AS LastLoginTimeInEST, SecondaryStatus
FROM SalesUsers              
WHERE RowNumber >= @StartIndex AND (@PageSize = 0 OR RowNumber < (@StartIndex + @PageSize))              
group by Id, FristName, LastName, Phone, Zip, Designation, Status, HireDate, InstallId, picture, CreatedDateTime, Source, SourceUser,              
AddedBy, UserInstallId, InterviewDetail, RejectDetail, RejectedUserId, RejectedByUserName, RejectedByUserInstallId, Email, DesignationID,              
AddedByUserInstallId, AddedById, EmpType, [Aggregate], PrimaryPhone, CountryCode, Resumepath, TechTaskId, ParentTechTaskId,              
TechTaskInstallId, bookmarkedUser,  [StatusReason], Country, City,LastLoginTimeStamp,SalesUsers.SalaryReq,SalesUsers.CurrencyName,
SecondaryStatus          
ORDER BY CASE WHEN @SortExpression = 'Id ASC' THEN Id END ASC,              
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
   CASE WHEN @SortExpression = 'CreatedDateTime DESC' THEN CreatedDateTime END DESC,    
   CASE WHEN @SortExpression = 'LastLoginTimeStamp DESC' THEN LastLoginTimeStamp END DESC   ,
   CASE WHEN @SortExpression = 'SecondaryStatus ASC' THEN SecondaryStatus END ASC,    
	   CASE WHEN @SortExpression = 'SecondaryStatus DESC' THEN SecondaryStatus END DESC
	   , IsNull(SecondaryStatus,0) Asc                     
            
 -- get record count - Table 5              
 SELECT COUNT(*) AS TotalRecordCount              
 FROM tblInstallUsers t              
  LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser              
  LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser              
  LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId= ru.Id              
  LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id              
  LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id              
  LEFT JOIN tblSource s ON t.SourceId = s.Id          
  LEFT JOIN Currency c on t.CurrencyID = c.CurrencyID      
  left outer join InstallUserBMLog as bm on t.id  =bm.bookmarkedUser and bm.isDeleted=0              
  OUTER APPLY              
 (               
 SELECT tsk.TaskId, tsk.ParentTaskId, tsk.InstallId, ROW_NUMBER() OVER(ORDER BY u.TaskUserId DESC) AS RowNo              
 FROM tblTaskAssignedUsers u              
 INNER JOIN tblTask tsk ON u.TaskId = tsk.TaskId AND              
 (tsk.ParentTaskId IS NOT NULL OR tsk.IsTechTask = 1)              
 WHERE u.UserId = t.Id              
 ) AS Task              
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales') AND (@SearchTerm IS NULL OR               
    1 = CASE WHEN t.InstallId LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.FristName LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.LastName LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.Email LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.Phone LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1              
  WHEN t.Zip LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.City LIKE ''+ @SearchTerm + '%' THEN 1              
  ELSE 0              
  END              
  )              
AND t.[Status] IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@Status,t.[Status]),',') ss)
AND (t.[SecondaryStatus] IN (SELECT ss.Item  FROM dbo.SplitString(@SecondaryStatus,',') ss) Or (@SecondaryStatus IS Null))
 AND t.[Status] NOT IN (@OfferMadeStatus, @ActiveStatus)            
  And t.Phone Like'[0-9]%' And IsNull(t.CountryCode,'') !='' -- Exclude Bad number users  
 AND d.Id IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@DesignationId,d.Id),',') ss)         
 AND ISNULL(s.Id,'') IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@SourceId,ISNULL(s.Id,'')),',') ss)        
 AND ISNULL(t1.Id,t2.Id) IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@AddedByUserId,ISNULL(t1.Id,t2.Id)),',') ss)         
 AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)              
 AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)              
              
  -- Get the Total Count - Table 6              
   SELECT Count(*) as TCount              
  FROM tblInstallUsers t              
  LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser              
  LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser              
  LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId= ru.Id              
  LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id              
  LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id              
  LEFT JOIN tblSource s ON t.SourceId = s.Id          
  LEFT JOIN Currency c on t.CurrencyID = c.CurrencyID      
  left outer join InstallUserBMLog as bm on t.id  =bm.bookmarkedUser and bm.isDeleted=0              
  OUTER APPLY              
 (               
 SELECT tsk.TaskId, tsk.ParentTaskId, tsk.InstallId, ROW_NUMBER() OVER(ORDER BY u.TaskUserId DESC) AS RowNo              
 FROM tblTaskAssignedUsers u              
 INNER JOIN tblTask tsk ON u.TaskId = tsk.TaskId AND              
 (tsk.ParentTaskId IS NOT NULL OR tsk.IsTechTask = 1)              
 WHERE u.UserId = t.Id              
 ) AS Task              
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales') AND (@SearchTerm IS NULL OR               
    1 = CASE WHEN t.InstallId LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.FristName LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.LastName LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.Email LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.Phone LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1              
  WHEN t.Zip LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.City LIKE ''+ @SearchTerm + '%' THEN 1              
  ELSE 0              
  END              
  )              
AND t.[Status] IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@Status,t.[Status]),',') ss)
AND (t.[SecondaryStatus] IN (SELECT ss.Item  FROM dbo.SplitString(@SecondaryStatus,',') ss) Or (@SecondaryStatus IS Null))
 AND t.[Status] NOT IN (@OfferMadeStatus, @ActiveStatus)            
  And t.Phone Like'[0-9]%' And IsNull(t.CountryCode,'') !='' -- Exclude Bad number users  
 AND d.Id IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@DesignationId,d.Id),',') ss)         
 AND ISNULL(s.Id,'') IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@SourceId,ISNULL(s.Id,'')),',') ss)        
 AND ISNULL(t1.Id,t2.Id) IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@AddedByUserId,ISNULL(t1.Id,t2.Id)),',') ss)         
 AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)              
 AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)                       
                 
     -- Get the Total Count - Table 7              
 IF OBJECT_ID('tempdb..#TempUserIds') IS NOT NULL DROP TABLE #TempUserIds          
  Create Table #TempUserIds(Id int)          
           
;WITH SalesUsers              
 AS              
 (SELECT t.Id, t.FristName, t.LastName, t.Phone, t.Zip, t.City, d.DesignationName AS Designation, t.Status, t.HireDate, t.InstallId,              
 t.picture, t.CreatedDateTime, Isnull(s.Source,'') AS Source, t.SourceUser, ISNULL(U.Username,t2.FristName + ' ' + t2.LastName)              
 AS AddedBy, ISNULL (t.UserInstallId,t.id) As UserInstallId,              
 InterviewDetail = case when (t.Status=@InterviewDateStatus) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR)  + ' ' + coalesce(t.InterviewTime,'')               
       else '' end,              
 RejectDetail = case when (t.[Status]=@RejectedStatus ) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR) + ' ' + coalesce(t.RejectionTime,'')               
       else '' end,              
 CASE when (t.[Status]= @RejectedStatus ) THEN t.RejectedUserId ELSE NULL END AS RejectedUserId,              
 CASE when (t.[Status]= @RejectedStatus ) THEN ru.FristName + ' ' + ru.LastName ELSE NULL END AS RejectedByUserName,              
 CASE when (t.[Status]= @RejectedStatus ) THEN ru.[UserInstallId]  ELSE NULL END AS RejectedByUserInstallId,              
 t.Email, t.DesignationID, ISNULL(t1.[UserInstallId], t2.[UserInstallId]) As AddedByUserInstallId,              
 ISNULL(t1.Id,t2.Id) As AddedById, t.emptype as 'EmpType', t.Phone As PrimaryPhone, t.CountryCode, t.Resumepath,              
 --ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId,              
 /*Task.TaskId AS 'TechTaskId', Task.ParentTaskId AS 'ParentTechTaskId', Task.InstallId as 'TechTaskInstallId'*/            
 0 AS 'TechTaskId', 0 AS 'ParentTechTaskId', '' as 'TechTaskInstallId'            
 , bm.bookmarkedUser,              
 t.[StatusReason], dbo.udf_GetUserExamPercentile(t.Id) AS [Aggregate],              
 ROW_NUMBER() OVER(ORDER BY              
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
   CASE WHEN @SortExpression = 'City ASC' THEN t.City END ASC,              
   CASE WHEN @SortExpression = 'City DESC' THEN t.City END DESC,               
   CASE WHEN @SortExpression = 'CreatedDateTime ASC' THEN t.CreatedDateTime END ASC,              
   CASE WHEN @SortExpression = 'CreatedDateTime DESC' THEN t.CreatedDateTime END DESC,              
   CASE WHEN @SortExpression = 'LastLoginTimeStamp DESC' THEN t.LastLoginTimeStamp END DESC   ,
   CASE WHEN @SortExpression = 'SecondaryStatus ASC' THEN t.SecondaryStatus END ASC,    
	   CASE WHEN @SortExpression = 'SecondaryStatus DESC' THEN t.SecondaryStatus END DESC
	   , IsNull(t.SecondaryStatus,0) Asc            
       ) AS RowNumber,            
    '' as Country,ISNULL(t.SalaryReq,'') as SalaryReq,ISNULL(c.Name,'') as CurrencyName  ,
	t.LastLoginTimeStamp, t.SecondaryStatus            
  FROM tblInstallUsers t              
  LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser              
  LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser              
  LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId= ru.Id              
  LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id              
  LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id              
  LEFT JOIN tblSource s ON t.SourceId = s.Id          
  LEFT JOIN Currency c on t.CurrencyID = c.CurrencyID      
  left outer join InstallUserBMLog as bm on t.id  =bm.bookmarkedUser and bm.isDeleted=0              
  OUTER APPLY              
 (               
 SELECT tsk.TaskId, tsk.ParentTaskId, tsk.InstallId, ROW_NUMBER() OVER(ORDER BY u.TaskUserId DESC) AS RowNo              
 FROM tblTaskAssignedUsers u              
 INNER JOIN tblTask tsk ON u.TaskId = tsk.TaskId AND              
 (tsk.ParentTaskId IS NOT NULL OR tsk.IsTechTask = 1)              
 WHERE u.UserId = t.Id              
 ) AS Task              
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales') AND (@SearchTerm IS NULL OR               
    1 = CASE WHEN t.InstallId LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.FristName LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.LastName LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.Email LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.Phone LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1              
  WHEN t.Zip LIKE ''+ @SearchTerm + '%' THEN 1              
  WHEN t.City LIKE ''+ @SearchTerm + '%' THEN 1              
  ELSE 0              
  END              
  )              
AND t.[Status] IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@Status,t.[Status]),',') ss)
AND (t.[SecondaryStatus] IN (SELECT ss.Item  FROM dbo.SplitString(@SecondaryStatus,',') ss) Or (@SecondaryStatus IS Null))
 AND t.[Status] NOT IN (@OfferMadeStatus, @ActiveStatus)            
  And t.Phone Like'[0-9]%' And IsNull(t.CountryCode,'') !='' -- Exclude Bad number users  
 AND d.Id IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@DesignationId,d.Id),',') ss)         
 AND ISNULL(s.Id,'') IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@SourceId,ISNULL(s.Id,'')),',') ss)        
 AND ISNULL(t1.Id,t2.Id) IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@AddedByUserId,ISNULL(t1.Id,t2.Id)),',') ss)         
 AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)              
 AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)              
)
Insert Into #TempUserIds SELECT  Id             
FROM SalesUsers              
WHERE RowNumber >= @StartIndex AND (@PageSize = 0 OR RowNumber < (@StartIndex + @PageSize))              
group by Id, FristName, LastName, Phone, Zip, Designation, Status, HireDate, InstallId, picture, CreatedDateTime, Source, SourceUser,              
AddedBy, UserInstallId, InterviewDetail, RejectDetail, RejectedUserId, RejectedByUserName, RejectedByUserInstallId, Email, DesignationID,              
AddedByUserInstallId, AddedById, EmpType, [Aggregate], PrimaryPhone, CountryCode, Resumepath, TechTaskId, ParentTechTaskId,              
TechTaskInstallId, bookmarkedUser,  [StatusReason], Country, City,LastLoginTimeStamp ,SecondaryStatus             
ORDER BY CASE WHEN @SortExpression = 'Id ASC' THEN Id END ASC,              
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
   CASE WHEN @SortExpression = 'CreatedDateTime DESC' THEN CreatedDateTime END DESC,    
   CASE WHEN @SortExpression = 'LastLoginTimeStamp DESC' THEN LastLoginTimeStamp END DESC,
   CASE WHEN @SortExpression = 'SecondaryStatus ASC' THEN SecondaryStatus END ASC,    
	CASE WHEN @SortExpression = 'SecondaryStatus DESC' THEN SecondaryStatus END DESC
, IsNull(SecondaryStatus,0) Asc                     
    
	

	IF OBJECT_ID('tempdb..#TempEmails') IS NOT NULL DROP TABLE #TempEmails 
		Create Table #TempEmails(emailID varchar(100), UserId int)

	Insert Into #TempEmails
		Select E.emailID, T.Id From #TempUserIds T Join tblUserEmail E On T.Id = E.UserID Where IsNull(EmailId,'') != ''
	Insert Into #TempEmails
		Select U.Email,U.Id From #TempUserIds T Join tblInstallUsers U On T.Id = U.ID Where IsNull(U.Email,'') != ''
	Select Distinct * From #TempEmails Order by UserId
	          
/* Select E.* From #TempUserIds T Join tblUserEmail E On T.Id = E.UserID           */
          
   -- Get the Total Count - Table 8              
  IF OBJECT_ID('tempdb..#TempPhones') IS NOT NULL DROP TABLE #TempPhones 
		Create Table #TempPhones(Phone varchar(100), UserId int)
	Insert Into #TempPhones
		Select P.Phone, P.UserId From #TempUserIds T Join tblUserPhone P On T.Id = P.UserID  Where IsNull(P.Phone,'') != ''
    Insert Into #TempPhones
		Select U.Phone,U.Id From #TempUserIds T Join tblInstallUsers U On T.Id = U.ID Where IsNull(U.Phone,'') != ''
    
	Select Distinct * from #TempPhones Order by UserId        
              
              
  -- Get Notes from tblUserNotes - Table 9              
--  SELECT I.FristName+' - '+CAST(I.ID as varchar) as [AddedBy],N.AddedOn,N.Notes, N.UserID from tblInstallUsers I INNER JOIN tblUserNotes N ON              
--(I.ID = N.UserID)              
              
 SELECt UserTouchPointLogID , UserID, UpdatedByUserID, UpdatedUserInstallID, replace(LogDescription,'Note : ','') LogDescription, CurrentUserGUID,              
 CONVERT(VARCHAR,ChangeDateTime,101) + ' ' + convert(varchar, ChangeDateTime, 108) as CreatedDate              
 FROM tblUserTouchPointLog n WITH (NOLOCK)              
 --inner join tblinstallusers I on I.id=n.userid              
 where isnull(UserId,0)>0 and LogDescription like 'Note :%'              
 order by ChangeDateTime desc 
 
 -- Get the Total Count - Table 9
 Select @PageNumber As PageIndex   
              
END 
GO


Go
IF NOT EXISTS (Select 1 From tblHTMLTemplatesMaster Where Id=110)
Begin
	
	Insert Into tblHTMLTemplatesMaster(Id, Name, Subject, Header, Body, Footer, DateUpdated, Type, Category, FromID, TriggerText, FrequencyInDays, FrequencyStartDate, FrequencyStartTime, UsedFor)
	Select 110, 'Missed Call Alert Email', Subject, 
	'<span style="font-size: 13.3333px;">&nbsp; &nbsp; &nbsp;</span><img alt="" height="83" src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/logo.gif" width="81" style="font-size: 13.3333px;" /><span style="font-size: 13.3333px;">&nbsp;&nbsp; &nbsp;</span><img alt="" src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/header.jpg" style="font-size: 13.3333px;" /><br />',
	'<p class="MsoNormal" style="margin-bottom:0in;margin-bottom:.0001pt;line-height:normal"><span style="font-size: 10pt; font-family: arial, sans-serif; color: #222222; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">You have an unread message from JMGROVE user,</span></p>
	<p class="MsoNormal" style="margin-bottom:0in;margin-bottom:.0001pt;line-height:normal"><span style="font-size: 10pt; font-family: arial, sans-serif; color: #222222; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;"><br />
	<br />
	</span></p>
	<div style="width:250px;float:left;">        
	<div style="float:left;width:75px;height:75px;"><img src="{ImageUrl}" style="width:75px;height:75px;" /></div>        
	<div style="float:left;margin-left:5px;">            
	<div style="margin-bottom:5px;"><a href="{ProfileUrl}" target="_self">{SenderUserInstallID}</a></div>            
	<div style="margin-bottom:5px;">{SenderName}</div>            
	<div>{SenderDesignation}</div>        </div>    </div>
	<p class="MsoNormal" style="margin-bottom:0in;margin-bottom:.0001pt;line-height:normal"><span style="background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; font-size: 9.5pt; font-family: arial, sans-serif; color: #222222;"><br />
	</span></p>
	<div style="float:left;width:100%;text-align:center;">
	<span style="font-family: arial, helvetica, sans-serif; font-size: 9.5pt;">
	Missed call from {SenderName}-<a href="{ProfileUrl}" target="_self">{SenderUserInstallID}</a> at {MissedCallTime}</span>
	</div>
	<p class="MsoNormal" style="float:left;width:100%;margin-bottom:0in;margin-bottom:.0001pt;line-height:normal"><span style="background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; font-size: 9.5pt; font-family: arial, sans-serif; color: #222222;">&nbsp;</span>
	<span style="background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; font-size: 9.5pt; font-family: arial, sans-serif; color: #1155cc;"><a href="{MessageUrl}" target="_self" style="padding: 0 18px 3px 18px;background: url(http://web.jmgrovebuildingsupply.com/img/btn.png) no-repeat;line-height: 46px;color: #fff;font-weight: bold;font-size: 36px;cursor: pointer;text-decoration: none;display: inline-block;border-radius: 10px;box-shadow: 0 0 10px #a1a0a0;box-sizing: border-box;background-size: 134px 50px;">Reply   </a><br />
	</span></p>
	<p class="MsoNormal" style="margin-bottom:0in;margin-bottom:.0001pt;line-height:normal"><br />
	</p>
	<br />
	</span></font></span></p>
	<table cellspacing="0" cellpadding="0" width="100%" border="0" align="center" bgcolor="#f2f2f2" style="color: #222222; font-family: arial, sans-serif; font-size: 12.8px;">
	<tbody>	<tr><td valign="top" align="center" width="100%" style="font-family: arial, sans-serif; margin: 0px; padding-bottom: 15px;"></td></tr></tbody></table>', 
	Footer, DateUpdated, Type, Category, FromID, TriggerText, FrequencyInDays, FrequencyStartDate, FrequencyStartTime, UsedFor 
	From tblHTMLTemplatesMaster
	Where Id=104

ENd

Go
IF NOT EXISTS (Select 1 From tblHTMLTemplatesMaster Where Id=111)
Begin
	
	Insert Into tblHTMLTemplatesMaster(Id, Name, Subject, Header, Body, Footer, DateUpdated, Type, Category, FromID, TriggerText, FrequencyInDays, FrequencyStartDate, FrequencyStartTime, UsedFor)
	Select 111, 'Missed Call Alert Email With Attachment', Subject, 
	'<span style="font-size: 13.3333px;">&nbsp; &nbsp; &nbsp;</span><img alt="" height="83" src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/logo.gif" width="81" style="font-size: 13.3333px;" /><span style="font-size: 13.3333px;">&nbsp;&nbsp; &nbsp;</span><img alt="" src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/header.jpg" style="font-size: 13.3333px;" /><br />',
	'<p class="MsoNormal" style="margin-bottom:0in;margin-bottom:.0001pt;line-height:normal"><span style="font-size: 10pt; font-family: arial, sans-serif; color: #222222; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">You have an unread message from JMGROVE user,</span></p>
	<p class="MsoNormal" style="margin-bottom:0in;margin-bottom:.0001pt;line-height:normal"><span style="font-size: 10pt; font-family: arial, sans-serif; color: #222222; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;"><br />
	<br />
	</span></p>
	<div style="width:250px;float:left;">        
	<div style="float:left;width:75px;height:75px;"><img src="{ImageUrl}" style="width:75px;height:75px;" /></div>        
	<div style="float:left;margin-left:5px;">            
	<div style="margin-bottom:5px;"><a href="{ProfileUrl}" target="_self">{SenderUserInstallID}</a></div>            
	<div style="margin-bottom:5px;">{SenderName}</div>            
	<div>{SenderDesignation}</div>        </div>    </div>
	<p class="MsoNormal" style="margin-bottom:0in;margin-bottom:.0001pt;line-height:normal"><span style="background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; font-size: 9.5pt; font-family: arial, sans-serif; color: #222222;"><br />
	</span></p>
	<div style="float:left;width:100%;text-align:center;">
	<span style="font-family: arial, helvetica, sans-serif; font-size: 9.5pt;">
	Missed call from {SenderName}-<a href="{ProfileUrl}" target="_self">{SenderUserInstallID}</a> at {MissedCallTime}.</span>
	<span style="font-family: arial, helvetica, sans-serif; font-size: 9.5pt;">To see recorded message, click <a href="{AudioVideoUrl}">here</a> </span>
	</div>
	<p class="MsoNormal" style="float:left;width:100%;margin-bottom:0in;margin-bottom:.0001pt;line-height:normal"><span style="background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; font-size: 9.5pt; font-family: arial, sans-serif; color: #222222;">&nbsp;</span>
	<span style="background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; font-size: 9.5pt; font-family: arial, sans-serif; color: #1155cc;"><a href="{MessageUrl}" target="_self" style="padding: 0 18px 3px 18px;background: url(http://web.jmgrovebuildingsupply.com/img/btn.png) no-repeat;line-height: 46px;color: #fff;font-weight: bold;font-size: 36px;cursor: pointer;text-decoration: none;display: inline-block;border-radius: 10px;box-shadow: 0 0 10px #a1a0a0;box-sizing: border-box;background-size: 134px 50px;">Reply   </a><br />
	</span></p>
	<p class="MsoNormal" style="margin-bottom:0in;margin-bottom:.0001pt;line-height:normal"><br />
	</p>
	<br />
	</span></font></span></p>
	<table cellspacing="0" cellpadding="0" width="100%" border="0" align="center" bgcolor="#f2f2f2" style="color: #222222; font-family: arial, sans-serif; font-size: 12.8px;">
	<tbody>	<tr><td valign="top" align="center" width="100%" style="font-family: arial, sans-serif; margin: 0px; padding-bottom: 15px;"></td></tr></tbody></table>', 
	Footer, DateUpdated, Type, Category, FromID, TriggerText, FrequencyInDays, FrequencyStartDate, FrequencyStartTime, UsedFor 
	From tblHTMLTemplatesMaster
	Where Id=104

ENd


Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'UpdateEmailStatus' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE UpdateEmailStatus
  END
Go 
-- =============================================        
       
-- =============================================        
CREATE PROCEDURE [dbo].[UpdateEmailStatus]
(        
	@TransactionId Varchar(200),
	@ToEmail Varchar(200),
	@Status int,
	@StatusChangeDate DateTime
)     
AS    
BEGIN
	/*
	
	 public enum LogJobStatus: int
    {
        /// <summary>
        /// All emails
        /// </summary>
        All = 0,

        /// <summary>
        /// Email has been submitted successfully and is queued for sending.
        /// </summary>
        ReadyToSend = 1,

        /// <summary>
        /// Email has soft bounced and is scheduled to retry.
        /// </summary>
        WaitingToRetry = 2,

        /// <summary>
        /// Email is currently sending.
        /// </summary>
        Sending = 3,

        /// <summary>
        /// Email has errored or bounced for some reason.
        /// </summary>
        Error = 4,

        /// <summary>
        /// Email has been successfully delivered.
        /// </summary>
        Sent = 5,

        /// <summary>
        /// Email has been opened by the recipient.
        /// </summary>
        Opened = 6,

        /// <summary>
        /// Email has had at least one link clicked by the recipient.
        /// </summary>
        Clicked = 7,

        /// <summary>
        /// Email has been unsubscribed by the recipient.
        /// </summary>
        Unsubscribed = 8,

        /// <summary>
        /// Email has been complained about or marked as spam by the recipient.
        /// </summary>
        AbuseReport = 9,

    }

	*/

	/*
		public enum EmailTypes
        {
            None = 0,
            Error = 1,
            Welcome = 2,
            TaskAutoEmail = 3,
            InterviewEmail = 4,
            OfferMadeEmail = 5,
            UserStatusChange = 6,
            ReminderEmail = 7,
            CallConectedAutoEmail = 8,
            ChatMessage = 9,
            VendorCategories = 10,
            Vendors = 11,
            Orders = 12
        }
	*/
	Declare @EmailType varchar(50), @EmailStatusId nVarchar(200)
	Update EmailStatus Set Status = @Status, StatusChangeDate = @StatusChangeDate Where TransactionId = @TransactionId And ToEmail = @ToEmail

	Select Top 1 @EmailType = EmailType, @EmailStatusId = Id From EmailStatus Where TransactionId = @TransactionId And ToEmail = @ToEmail
	
	Declare @UserId int, @UserInstallId Varchar(50), @Note Varchar(800), @Fullname Varchar(200)
	Select @UserId = Id, @UserInstallId = IsNull(UserInstallId,''), 
		@Fullname = IsNull(FristName,'') + ' ' + IsNULL(LastName,'') From tblINstallUsers Where Email = @ToEmail
	-- Change user secondary status
	If @Status = 6 And @EmailType in ('Welcome', 'ReminderEmail', 'CallConectedAutoEmail')
		Begin
			Insert Into UserStatusAudit(UserId, PrimaryStatus, SecondaryStatus, PageLocation, CreatedBy, IsManual)
					Values(@UserId, null, (select top 1 SecondaryStatus from tblInstallUsers Where Email = @ToEmail), 'UserEmailAction', NULL, 0)
			Update tblInstallUsers Set SecondaryStatus = 12 Where Email = @ToEmail /* AutoemailOpened = 12 */			
		End
	Declare @ESTTime DateTime
	Set @ESTTime = CONVERT(datetime, SWITCHOFFSET(GetUTCDate(), DATEPART(TZOFFSET, GetUTCDate() AT TIME ZONE 'Eastern Standard Time')))

	If @Status in (6, 7)
		Begin
			Set @Note = '<span class="auto-entry">' + @UserInstallId + '-' + @Fullname + ' ' +
				Case When @Status = 6 Then 'opened' ELse 'clicked ' End
			 + ' ' + 
					Case 
						When @EmailType = 'Welcome' Then 'Welcome' 
						When @EmailType = 'CallConectedAutoEmail' Then 'Call Conected Auto' 
						When @EmailType = 'Interview Date Reminder' Then 'Interview Date Reminder' 
						When @EmailType = 'InterviewEmail' Then 'Interview' 
						When @EmailType = 'MissedCallAlert' Then 'Missed Call Alert' 
						When @EmailType = 'OfferMadeEmail' Then 'Offer Made' 
						When @EmailType = 'TaskAutoEmail' Then 'Task Auto' 
						When @EmailType = 'MissedCallAlert' Then 'Missed Call Alert' 
						Else @EmailType End + 
					' Email at ' + Convert(varchar(20), @ESTTime, 101) + right(convert(varchar(32),@ESTTime,100),8) + ' (EST)</span>'
			
			/* Identify where to log entry. In HR Group Chat Or In Personal Chat */
			Declare @ChatGroupId nVarchar(200), @UserChatGroupId int, @ReceiverIds Varchar(200), @SenderId int

			Select top 1 @ChatGroupId = ChatGroupId, @UserChatGroupId = UserChatGroupId, 
						@ReceiverIds = ReceiverIds, @SenderId = SenderId			
			From ChatMessage Where EmailStatusId = @EmailStatusId
			
			IF @UserChatGroupId IS NULL
				Begin
					if @SenderId != @UserId Begin Set @ReceiverIds = @SenderId End
						
					Exec SaveChatMessage @ChatSourceId=12, @ChatGroupId = @ChatGroupId, @SenderId = @UserId , 
										 @TextMessage=@Note,@ChatFileId=null, @ReceiverIds = @ReceiverIds,@TaskId='0',
										 @TaskMultilevelListId=0, @UserChatGroupId=0, @IsWelcomeEmail=0, 
										 @EmailStatusId = @EmailStatusId
				End
			Else
				Begin
					Exec AddHRChatMessage @UserId, @Note, NULL
				End
		End
End


Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetChatMessages' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetChatMessages
  END
Go 
 -- =============================================      
-- Author:  Jitendra Pancholi      
-- Create date: 9 Jan 2017   
-- Description: Add offline user to chatuser table
-- =============================================    
/*
	GetChatMessages '2460b8fe-cd88-4c61-a973-3ada10b34711','780,901,3797,8472',2,780,2732, 1, 5
*/
CREATE PROCEDURE [dbo].[GetChatMessages]
	@ChatGroupId varchar(100),
	@ReceiverIds Varchar(800),
	@ChatSourceId Int = 0,
	@LoggedInUserId int = 780,
	@UserChatGroupId int = 0,
	@PageNumber int = 1,
	@PageSize int = 50
AS    
BEGIN
	if @PageNumber <= 0 Begin Set @PageNumber = 1 End
	If @UserChatGroupId = 0 Begin Set @UserChatGroupId = NULL End
	-- Find UserChatGroupId if exists
	--Declare @UserChatGroupId int
	--Select top 1 @UserChatGroupId = UserChatGroupId From ChatMessage M With(NoLock) 
	--		Where M.ChatGroupId = @ChatGroupId And UserChatGroupId Is Not Null

	IF OBJECT_ID('tempdb..#TempChatMessages') IS NOT NULL DROP TABLE #TempChatMessages  
	Create Table #TempChatMessages(Id int Primary Key Identity(1,1), 
			ChatGroupId varchar(100), ChatSourceId int, SenderId int, TextMessage nVarchar(max), ChatFileId int, ReceiverIds varchar(800),
			CreatedOn datetime, ChatUserIds Varchar(1000), SortedChatUserIds Varchar(1000), ChatMessageId int, UserChatGroupId int,
			WelcomeEmailStatus int)

	Insert Into #TempChatMessages (ChatGroupId,ChatSourceId, SenderId, TextMessage, ChatFileId,ReceiverIds,
									CreatedOn,ChatUserIds, ChatMessageId, UserChatGroupId, WelcomeEmailStatus)
		Select S.ChatGroupId,S.ChatSourceId, S.SenderId, S.TextMessage, S.ChatFileId, 
					S.ReceiverIds, S.CreatedOn, Convert(varchar(12), S.SenderId) + ',' + S.ReceiverIds, S.Id, 
					S.UserChatGroupId, 
					(Select top 1 E.Status From EmailStatus E Join tblInstallUsers U on E.ToEmail = U.Email
						Where S.EmailStatusId = E.Id Order by E.Id Desc)
		From ChatMessage S With(NoLock)
		Where S.ChatGroupId = @ChatGroupId

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
	Update #TempChatMessages Set WelcomeEmailStatus = 0 Where WelcomeEmailStatus IS NULL


	IF ISNULL(@UserChatGroupId,0) = 0
		Begin
			If ISNULL(@ChatSourceId,'0') = '0'
				Begin					
					Select S.Id, S.ChatGroupId,S.ChatSourceId, S.SenderId, S.TextMessage, S.ChatFileId, S.ReceiverIds, S.CreatedOn,
						U.FristName As FirstName, U.LastName, (U.FristName + ' ' + U.LastName) As Fullname,
						U.UserInstallId, U.Picture, --MS.IsRead,
						IsNull((Select top 1 MS.IsRead From ChatMessageReadStatus MS Where MS.ChatMessageId = S.ChatMessageId And ReceiverId = @LoggedInUserId),0) As IsRead
						, WelcomeEmailStatus
					From #TempChatMessages S With(NoLock) 
					Join tblInstallUsers U With(NoLock) On S.SenderId = U.Id
					--Join ChatMessageReadStatus MS With(NoLock) On S.ChatMessageId = MS.ChatMessageId
					Where /*S.SortedChatUserIds = @ReceiverIds */ S.UserChatGroupId IS NULL
					Order By S.CreatedOn Desc
					OFFSET (@PageNumber - 1) * @PageSize ROWS
					FETCH NEXT @PageSize ROWS ONLY
				End
			Else
				Begin
					Select S.Id, S.ChatGroupId,S.ChatSourceId, S.SenderId, S.TextMessage, S.ChatFileId, S.ReceiverIds, S.CreatedOn,
						U.FristName As FirstName, U.LastName, (U.FristName + ' ' + U.LastName) As Fullname,
						U.UserInstallId, U.Picture,-- MS.IsRead
						IsNull((Select top 1 MS.IsRead From ChatMessageReadStatus MS Where MS.ChatMessageId = S.ChatMessageId And ReceiverId = @LoggedInUserId),0) As IsRead
						, WelcomeEmailStatus
					From #TempChatMessages S With(NoLock) 
					Join tblInstallUsers U With(NoLock) On S.SenderId = U.Id
					--Join ChatMessageReadStatus MS With(NoLock) On S.ChatMessageId = MS.ChatMessageId
					Where S.UserChatGroupId  IS NULL /*S.SortedChatUserIds = @ReceiverIds*/ /*And S.ChatSourceId = @ChatSourceId*/
					And S.ChatSourceId Not in (2)
					Order By S.CreatedOn Desc
					OFFSET (@PageNumber - 1) * @PageSize ROWS
					FETCH NEXT @PageSize ROWS ONLY
				End
		End
		Else
			Begin
				If ISNULL(@ChatSourceId,'0') = '0'
					Begin
						Select S.Id, S.ChatGroupId,S.ChatSourceId, S.SenderId, S.TextMessage, S.ChatFileId, S.ReceiverIds, S.CreatedOn,
							U.FristName As FirstName, U.LastName, (U.FristName + ' ' + U.LastName) As Fullname,
							U.UserInstallId, U.Picture, --MS.IsRead,
							IsNull((Select top 1 MS.IsRead From ChatMessageReadStatus MS Where MS.ChatMessageId = S.ChatMessageId And ReceiverId = @LoggedInUserId),0) As IsRead
							, WelcomeEmailStatus
						From #TempChatMessages S With(NoLock) 
						Join tblInstallUsers U With(NoLock) On S.SenderId = U.Id
						--Join ChatMessageReadStatus MS With(NoLock) On S.ChatMessageId = MS.ChatMessageId
						Where /*S.SortedChatUserIds = @ReceiverIds */ S.UserChatGroupId = @UserChatGroupId
						Order By S.CreatedOn Desc
						OFFSET (@PageNumber - 1) * @PageSize ROWS
						FETCH NEXT @PageSize ROWS ONLY
					End
				Else
					Begin
						Select S.Id, S.ChatGroupId,S.ChatSourceId, S.SenderId, S.TextMessage, S.ChatFileId, S.ReceiverIds, S.CreatedOn,
							U.FristName As FirstName, U.LastName, (U.FristName + ' ' + U.LastName) As Fullname,
							U.UserInstallId, U.Picture,-- MS.IsRead
							IsNull((Select top 1 MS.IsRead From ChatMessageReadStatus MS Where MS.ChatMessageId = S.ChatMessageId And ReceiverId = @LoggedInUserId),0) As IsRead
							, WelcomeEmailStatus
						From #TempChatMessages S With(NoLock) 
						Join tblInstallUsers U With(NoLock) On S.SenderId = U.Id
						--Join ChatMessageReadStatus MS With(NoLock) On S.ChatMessageId = MS.ChatMessageId
						Where S.UserChatGroupId = @UserChatGroupId /*S.SortedChatUserIds = @ReceiverIds*/ /*And S.ChatSourceId = @ChatSourceId*/
						And S.ChatSourceId Not in (2)
						Order By S.CreatedOn Desc
						OFFSET (@PageNumber - 1) * @PageSize ROWS
						FETCH NEXT @PageSize ROWS ONLY
					End
			End
END

Go
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
	@LoggedInUserId Int = 780,
	@PageNumber int = 1,
	@PageSize int = 50
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
			Order By S.CreatedOn Desc
			OFFSET (@PageNumber - 1) * @PageSize ROWS
			FETCH NEXT @PageSize ROWS ONLY
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
			/*Where S.SortedChatUserIds = @ReceiverIds And S.ChatSourceId = @ChatSourceId*/
			Order By S.CreatedOn Desc
			OFFSET (@PageNumber - 1) * @PageSize ROWS
			FETCH NEXT @PageSize ROWS ONLY
		End
END

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetChatMessagesByUsers' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetChatMessagesByUsers
  END
Go 
 -- =============================================        
-- Author:  Jitendra Pancholi        
-- Create date: 27 Nov 2017     
-- Description: Get a list of top 5 users by starts with name, email   
-- =============================================      
/*  Use JGBS_DEV_NEW
	GetChatMessagesByUsers 780,7523,10
	GetChatMessagesByUsers 7523,780,0
	GetChatMessagesByUsers 3797,3569,0
	GetChatMessagesByUsers @UserId=780, @ReceiverId=3797, @ChatSourceId=162
*/  
Create PROCEDURE [dbo].[GetChatMessagesByUsers]  
	@UserId int,
	@ReceiverId int,
	@ChatSourceId int,
	@PageNumber int = 1,
	@PageSize int = 50
AS      
BEGIN
	Select S.Id, S.ChatGroupId, S.ChatSourceId, S.SenderId, S.TextMessage, S.ChatFileId, S.ReceiverIds, S.CreatedOn,
			U.FristName As FirstName, U.LastName, (U.FristName + ' ' + U.LastName) As Fullname,
			U.UserInstallId, U.Picture,
			IsNull((Select MS.IsRead From ChatMessageReadStatus MS 
				Where MS.ChatMessageId = S.Id And ReceiverId = @UserId),1) As IsRead,
			(Case when exists 
			(Select top 1 E.Status From EmailStatus E Join tblInstallUsers U on E.ToEmail = U.Email
						Where S.EmailStatusId = E.Id Order by E.Id Desc) 
				Then (Select top 1 E.Status From EmailStatus E Join tblInstallUsers U on E.ToEmail = U.Email
						Where S.EmailStatusId = E.Id Order by E.Id Desc)
					Else 0 End)
						As WelcomeEmailStatus
		From ChatMessage S With(NoLock)
			Join tblInstallUsers U With(NoLock) On S.SenderId = U.Id
			--Join ChatMessageReadStatus MS With(NoLock) On S.Id = MS.ChatMessageId
		Where ((S.SenderId = @UserId And S.ReceiverIds = Convert(Varchar(12), @ReceiverId))
			Or (S.SenderId = @ReceiverId And S.ReceiverIds =  Convert(Varchar(12), @UserId)))
			/*And S.ChatSourceId = @ChatSourceId*/
			And S.ChatSourceId Not In (2) And S.UserChatGroupId IS NULL
		Order By S.CreatedOn Desc
		OFFSET (@PageNumber - 1) * @PageSize ROWS
		FETCH NEXT @PageSize ROWS ONLY
End

GO

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetChatGroup' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetChatGroup
  END
Go 
 -- =============================================        
-- Author:  Jitendra Pancholi        
-- Create date: 27 Nov 2017     
-- Description: Get a list of top 5 users by starts with name, email   
-- =============================================      
/*  Use JGBS_DEV_NEW
	[GetChatGroup] 2847
*/  
Create PROCEDURE [dbo].[GetChatGroup]  
	@UserChatGroupId int
AS      
BEGIN
	Select * From UserChatGroup Where Id = @UserChatGroupId
End

Update tblInstallUsers Set Status = 2 Where Status In (7,8) 
Update tblInstallUsers Set Status = 5, SecondaryStatus=19 Where Status In (16)

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
-- UpdateSecondaryStatus 10, 8446, 901
 
CREATE PROCEDURE [dbo].[UpdateSecondaryStatus]   
(  
	@SecondaryStatus int,
	@OldSecondaryStatus int,
	@OldSecondaryStatusText NVarchar(200),
	@SecondaryStatusText NVarchar(200),
	@UserId int,
	@LoggedInUserId int,
	@AddHrChatLog bit = 1
)     
AS  
BEGIN
	IF @SecondaryStatus > 0
		Begin
			
			Declare @ChatGroupId Varchar(200), @UserChatGroupId int, @ReceiverIds Varchar(800), @msg varchar(800), @oldStatus int
			Select @oldStatus =  SecondaryStatus from tblInstallUsers Where Id = @UserId

			Select top 1 @ChatGroupId = S.ChatGroupId, @UserChatGroupId = S.UserChatGroupId
			From ChatMessage S With(NoLock)
			Where ((S.SenderId = @UserId And ',' + S.ReceiverIds + ',' like '%,' + Convert(Varchar(12), @LoggedInUserId) + ',%')
				Or (S.SenderId = @LoggedInUserId And ',' + S.ReceiverIds + ',' like  '%,' + Convert(Varchar(12), @UserId)+ ',%')) 
			 And S.UserChatGroupId IS Not NULL And S.TaskId IS NULL
			Order by S.Id Asc
		
		IF ISNULL(@ChatGroupId,'') = ''
			Begin
				Set @ChatGroupId = NEWID()
			End
		If IsNull(@UserChatGroupId,0) = 0
			Begin
				Insert Into UserChatGroup (CreatedBy) Values(@LoggedInUserId)
				Set @UserChatGroupId = IDENT_CURRENT('UserChatGroup') 
		
				Insert Into UserChatGroupMember (UserChatGroupId, UserId) Values(@UserChatGroupId, 780)
				Insert Into UserChatGroupMember (UserChatGroupId, UserId) Values(@UserChatGroupId, 901)
				Insert Into UserChatGroupMember (UserChatGroupId, UserId) Values(@UserChatGroupId, @UserId)
				If Not exists (Select 1 From UserChatGroupMember Where UserChatGroupId = @UserChatGroupId And UserId = @LoggedInUserId)
					begin
						Insert Into UserChatGroupMember (UserChatGroupId, UserId) Values(@UserChatGroupId, @LoggedInUserId)
					end
			End
		SELECT @ReceiverIds = SUBSTRING((SELECT ',' + Convert(Varchar(12), s.UserId) FROM UserChatGroupMember s 
			Where UserChatGroupId = @UserChatGroupId And UserId not in (@LoggedInUserId)
			ORDER BY s.UserId Asc FOR XML PATH('')),2,200000) 
		
		Declare @SenderName Varchar(200)

		Select @SenderName = IsNULL(FristName,'')+' '+IsNULL(LastName,'') +'-'+IsNULL(UserInstallId,'') From tblINstallUsers Where Id = 1537
		Declare @ESTTime DateTime
		Set @ESTTime = CONVERT(datetime, SWITCHOFFSET(GetUTCDate(), DATEPART(TZOFFSET, GetUTCDate() AT TIME ZONE 'Eastern Standard Time')))
	
		IF ISNULL(@OldSecondaryStatusText,'') = ''
			Begin
				Set @msg = '<span class="auto-entry">Secondary Status Changed By '+@SenderName+' to <span style="color:green;">'+@SecondaryStatusText+'</span> Date - '+ Convert(varchar(20), @ESTTime, 101) + right(convert(varchar(32), @ESTTime,100),8) +'(EST)</span>'
			End
		Else
			Begin
				Set @msg = '<span class="auto-entry">Secondary Status Changed By '+@SenderName+' - <span style="color:orange;">'+ @OldSecondaryStatusText+'</span> -> <span style="color:green;">'+@SecondaryStatusText+'</span> Date - '+ Convert(varchar(20), @ESTTime, 101) + right(convert(varchar(32), @ESTTime,100),8) +'(EST)</span>'
			End
		IF @AddHrChatLog = 1
			Begin
				Exec SaveChatMessage 1, @ChatGroupId, @LoggedInUserId, @msg,null, @ReceiverIds,null,null, @UserChatGroupId, 0
			End

		Update tblInstallUsers Set SecondaryStatus = @SecondaryStatus Where Id = @UserId

		Select @msg As LogNote
	End

End


Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetChatParametersByUser' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetChatParametersByUser
  END
Go 
 ---- =============================================  
-- Author:  Jitendra Pancholi  
-- Create date: 08/14/2018
-- Description: Load all details of task for edit.  
-- =============================================  
-- GetChatParametersByUser 3797, 780, null, null

CREATE PROCEDURE [dbo].[GetChatParametersByUser]   
(
	@UserId int,
	@LoggedInUserId int,
	@TaskId int =null,
	@TaskMultilevelListId int=null
)     
AS  
BEGIN
	Declare @ChatGroupId Varchar(100) = null, @UserChatGroupId int, @ReceiverIds Varchar(800)

	If @TaskId IS NULL
		Begin
			Select top 1 @ChatGroupId = S.ChatGroupId, @UserChatGroupId = S.UserChatGroupId
			From ChatMessage S With(NoLock)
			Where ((S.SenderId = @UserId And ',' + S.ReceiverIds + ',' like '%,' + Convert(Varchar(12), @LoggedInUserId) + ',%')
				Or (S.SenderId = @LoggedInUserId And ',' + S.ReceiverIds + ',' like  '%,' + Convert(Varchar(12), @UserId)+ ',%')) 
				And S.UserChatGroupId IS Not NULL And S.TaskId IS NULL
			Order by S.Id Asc
		End
	Else IF @TaskId IS NOT NULL And @TaskMultilevelListId IS NULL
		Begin
			Select top 1 @ChatGroupId = S.ChatGroupId, @UserChatGroupId = S.UserChatGroupId
			From ChatMessage S With(NoLock)
			Where ((S.SenderId = @UserId And ',' + S.ReceiverIds + ',' like '%,' + Convert(Varchar(12), @LoggedInUserId) + ',%')
				Or (S.SenderId = @LoggedInUserId And ',' + S.ReceiverIds + ',' like  '%,' + Convert(Varchar(12), @UserId)+ ',%')) 
				And S.UserChatGroupId IS Not NULL And S.TaskId IS Not NULL And S.TaskMultilevelListId IS NULL
			Order by S.Id Asc
		End
	Else IF @TaskId IS NOT NULL And @TaskMultilevelListId IS NOT NULL
		Begin
			Select top 1 @ChatGroupId = S.ChatGroupId, @UserChatGroupId = S.UserChatGroupId
			From ChatMessage S With(NoLock)
			Where ((S.SenderId = @UserId And ',' + S.ReceiverIds + ',' like '%,' + Convert(Varchar(12), @LoggedInUserId) + ',%')
				Or (S.SenderId = @LoggedInUserId And ',' + S.ReceiverIds + ',' like  '%,' + Convert(Varchar(12), @UserId)+ ',%')) 
				And S.UserChatGroupId IS Not NULL And S.TaskId IS Not NULL And S.TaskMultilevelListId IS NOT NULL
			Order by S.Id Asc
		End
	
	IF ISNULL(@ChatGroupId,'') = ''
		begin
			Select @ChatGroupId = NEWID ()  
		end
	IF @UserChatGroupId IS NULL
		begin
			--Insert Into UserChatGroup (CreatedBy) Values(@loginUserID)
			--Set @UserChatGroupId = IDENT_CURRENT('UserChatGroup')

			IF OBJECT_ID('tempdb..#TempUsers') IS NOT NULL DROP TABLE #TempUsers   
			Create Table #TempUsers(UserId int)
			Insert Into #TempUsers Values(780)
			Insert Into #TempUsers Values(901)
			Insert Into #TempUsers Values(@LoggedInUserId)

			--Insert Into UserChatGroupMember (UserChatGroupId, UserId)
			--	Select Distinct UserChatGroupId, UserId From #TempUsers
			SELECT @ReceiverIds = SUBSTRING((SELECT ',' + Convert(Varchar(10), s.UserId) FROM #TempUsers s 
			ORDER BY s.UserId Asc FOR XML PATH('')),2,200000) 
		end
	Else
		Set @ReceiverIds = COnvert(Varchar(12),@UserId)
	
	Select @ChatGroupId As ChatGroupId, IsNull(@UserChatGroupId,0) As UserChatGroupId, @ReceiverIds As ReceiverIds
End


Go
If NOT EXISTS (Select * From ChatSource S WHere S.Id = 12)
	Begin
		Insert Into ChatSource(Id, SourceName) Values (12, 'WebToWebCall')
	End


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
--     Added applicant status to allow applicant to login.            
-- Updated By : Nand Chavan (Task ID#: REC001-XIII)          
--                  Replace Source with SourceID          
-- Description: Get an install user by email and status.            
-- =============================================            
-- [dbo].[UDP_GetInstallerUserDetailsByLoginId]  'Surmca17@gmail.com'       
Create PROCEDURE [dbo].[UDP_GetInstallerUserDetailsByLoginId]            
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
 SELECT Id,FristName,Lastname,Email,[Address],Designation,[Status], City,Zip,EmpType,           
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
   [Status] = @ApplicantStatus OR   [Status] = 10     OR     
   [Status] = @OfferMadeStatus OR   [Status] = 22     OR     
   [Status] = @InterviewDateStatus  OR    [Status] =  21 OR
   [Status] = 17  OR    [Status] =  19 OR
   [Status] = 18  OR    [Status] =  20 OR
   [Status] = 16
  )  
END  
  

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'UDP_IsValidInstallerUser' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE UDP_IsValidInstallerUser
  END
Go
 -- =============================================          
-- Author:  Yogesh          
-- Create date: 23 Feb 2017        
-- Updated By : Yogesh        
-- Updated By : Jitendra Pancholi    
-- Updated On : 13 Nov 2017    
--  Added applicant status to allow applicant to login.        
-- Updated By : Nand Chavan (Task ID#: REC001-XIII)      
--                  Replace Source with SourceID      
-- Description: Get an install user by email, pwd and status.        
-- =============================================        
Create PROCEDURE [dbo].[UDP_IsValidInstallerUser]       
  @userid varchar(50),        
  @password varchar(50),        
  @ActiveStatus varchar(5) = '1',        
  @ApplicantStatus varchar(5) = '2',        
  @InterviewDateStatus varchar(5) = '5',        
  @OfferMadeStatus varchar(5) = '6',        
  @ReferalApplicant varchar(5) = '10' ,  
  @result int output        
AS        
BEGIN        
         
 DECLARE @phone varchar(1000) = @userid      
      
 --REC001-XIII - create formatted phone#      
 IF ISNUMERIC(@userid) = 1 AND LEN(@userid) > 5      
 BEGIN      
  SET @phone =  '(' + SUBSTRING(@phone, 1, 3) + ')-' + SUBSTRING(@phone, 4, 3) + '-' + SUBSTRING(@phone, 7, LEN(@phone))      
 END      
      
 IF EXISTS(        
  SELECT Id         
  FROM tblInstallUsers         
  WHERE         
   (Email = @userid OR Phone = @userid OR Phone = @phone)      
   AND ISNULL(@userid, '') != ''      
   AND        
   [Password] = @password AND         
     ( 
   [Status] = @ActiveStatus OR             
   [Status] = @ApplicantStatus OR   [Status] = 10     OR     
   [Status] = @OfferMadeStatus OR   [Status] = 22     OR     
   [Status] = @InterviewDateStatus  OR    [Status] =  21 OR
   [Status] = 17  OR    [Status] =  19 OR
   [Status] = 18  OR    [Status] =  20 OR
   [Status] = 16

     )        
    )        
  BEGIN        
   SET @result = 1        
  END        
  ELSE        
  BEGIN        
   SET @result=0        
  END        
        
  RETURN @result        
        
END 


Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'sp_GetHrData' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE sp_GetHrData
  END
Go
 -- =============================================                  
-- Author:  Jitendra Pancholi                  
-- Create date: 9 Jan 2017               
-- Description: Add offline user to chatuser table            
-- =============================================                 
-- [sp_GetHrData] '','0',0,0, 0, NULL, NULL,0,20, 'CreatedDateTime DESC','5','9','6','1'                
Create PROCEDURE [dbo].[sp_GetHrData]                
 @SearchTerm VARCHAR(15) = NULL, @Status VARCHAR(50) = NULL, @DesignationId VARCHAR(50) = NULL, @SourceId VARCHAR(50)= NULL, @AddedByUserId VARCHAR(50) = NULL, @FromDate DATE = NULL,                
 @ToDate DATE = NULL, @PageIndex INT = NULL,  @PageSize INT = NULL, @SortExpression VARCHAR(50), @InterviewDateStatus VARChAR(5) = '5',                
 @RejectedStatus VARChAR(5) = '9', @OfferMadeStatus VARChAR(5) = '6', @ActiveStatus VARChAR(5) = '1'                 
AS                
BEGIN                 
SET NOCOUNT ON;                
                
 --IF @Status = '0'                
 --BEGIN                
 -- SET @Status = NULL                
 --END                
 --IF @DesignationId = '0'                
 --BEGIN                
 -- SET @DesignationId = NULL                
 --END                
 --IF @SourceId = '0'                
 --BEGIN                
 -- SET @SourceId = NULL                
 --END                
 --IF @AddedByUserId = 0                
 --BEGIN                
 -- SET @AddedByUserId = NULL                
 --END                
                 
 SET @PageIndex = isnull(@PageIndex,0)                
 SET @PageSize = isnull(@PageSize,0)                
                 
 DECLARE @StartIndex INT  = 0                
 SET @StartIndex = (@PageIndex * @PageSize) + 1                
                  
  -- get statistics (Status) - Table 0                 
  SELECT t.Status, COUNT(*) [Count]                
  FROM tblInstallUsers t                 
   LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser                
   LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id                
   WHERE                 
  (t.UserType = 'SalesUser' OR t.UserType = 'sales')                
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)                 
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)                
 GROUP BY t.status                
                
 -- get statistics (AddedBy) - Table 1                
 SELECT ISNULL(U.Username, t2.FristName + '' + t2.LastName)  AS AddedBy, COUNT(*) [Count]                 
 FROM tblInstallUsers t                
   LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser                
   LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser                
   LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id                
   LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id                
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales')                
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)                
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)                
 GROUP BY U.Username,t2.FristName,t2.LastName                
                
 -- get statistics (Designation) - Table 2                
 SELECT t.Designation, COUNT(*) [Count]                 
 FROM tblInstallUsers t                
   LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser                
   LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id                
   LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id                
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales')                
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)                
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)                
 GROUP BY t.Designation                
                
 -- get statistics (Source) - Table 3                 
 SELECT t.Source, COUNT(*) [Count]                
 FROM tblInstallUsers t                
   LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser           
   LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id                
   LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id                
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales')                
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)          
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)                
 GROUP BY t.Source                
                
 -- get records - Table 4            
 ;WITH SalesUsers                
 AS                
 (SELECT t.Id, t.FristName, t.LastName, t.Phone, t.Zip, t.City, d.DesignationName AS Designation, t.Status,t.SecondaryStatus, t.HireDate, t.InstallId,t.LastLoginTimeStamp,                
 t.picture, t.CreatedDateTime, Isnull(s.Source,'') AS Source, t.SourceUser, ISNULL(U.Username,t2.FristName + ' ' + t2.LastName)                
 AS AddedBy, ISNULL (t.UserInstallId,t.id) As UserInstallId,                
 InterviewDetail = case when (t.Status=@InterviewDateStatus) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR)  + ' ' + coalesce(t.InterviewTime,'')                 
       else '' end,                
 RejectDetail = case when (t.[Status]=@RejectedStatus ) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR) + ' ' + coalesce(t.RejectionTime,'')                 
       else '' end,                
 CASE when (t.[Status]= @RejectedStatus ) THEN t.RejectedUserId ELSE NULL END AS RejectedUserId,                
 CASE when (t.[Status]= @RejectedStatus ) THEN ru.FristName + ' ' + ru.LastName ELSE NULL END AS RejectedByUserName,                
 CASE when (t.[Status]= @RejectedStatus ) THEN ru.[UserInstallId]  ELSE NULL END AS RejectedByUserInstallId,                
 t.Email, t.DesignationID, ISNULL(t1.[UserInstallId], t2.[UserInstallId]) As AddedByUserInstallId,                
 ISNULL(t1.Id,t2.Id) As AddedById, t.emptype as 'EmpType', t.Phone As PrimaryPhone, t.CountryCode, t.Resumepath,                
 --ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId,                
 /*Task.TaskId AS 'TechTaskId', Task.ParentTaskId AS 'ParentTechTaskId', Task.InstallId as 'TechTaskInstallId'*/              
 0 AS 'TechTaskId', 0 AS 'ParentTechTaskId', '' as 'TechTaskInstallId'              
 , bm.bookmarkedUser,                
 t.[StatusReason], dbo.udf_GetUserExamPercentile(t.Id) AS [Aggregate],                
 ROW_NUMBER() OVER(ORDER BY                
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
   CASE WHEN @SortExpression = 'City ASC' THEN t.City END ASC,                
   CASE WHEN @SortExpression = 'City DESC' THEN t.City END DESC,                 
   CASE WHEN @SortExpression = 'CreatedDateTime ASC' THEN t.CreatedDateTime END ASC,     
   CASE WHEN @SortExpression = 'CreatedDateTime DESC' THEN t.CreatedDateTime END DESC,                
   CASE WHEN @SortExpression = 'LastLoginTimeStamp DESC' THEN t.LastLoginTimeStamp END DESC                 
       ) AS RowNumber,              
    '' as Country,ISNULL(t.SalaryReq,'') as SalaryReq,ISNULL(c.Name,'') as CurrencyName                
  FROM tblInstallUsers t                
  LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser                
  LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser                
  LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId= ru.Id                
  LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id                
  LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id                
  LEFT JOIN tblSource s ON t.SourceId = s.Id            
  LEFT JOIN Currency c on t.CurrencyID = c.CurrencyID        
  left outer join InstallUserBMLog as bm on t.id  =bm.bookmarkedUser and bm.isDeleted=0                
  OUTER APPLY                
 (                 
 SELECT tsk.TaskId, tsk.ParentTaskId, tsk.InstallId, ROW_NUMBER() OVER(ORDER BY u.TaskUserId DESC) AS RowNo                
 FROM tblTaskAssignedUsers u                
 INNER JOIN tblTask tsk ON u.TaskId = tsk.TaskId AND                
 (tsk.ParentTaskId IS NOT NULL OR tsk.IsTechTask = 1)                
 WHERE u.UserId = t.Id                
 ) AS Task                
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales') AND (@SearchTerm IS NULL OR                 
    1 = CASE WHEN t.InstallId LIKE ''+ @SearchTerm + '%' THEN 1                
  WHEN t.FristName LIKE ''+ @SearchTerm + '%' THEN 1                
  WHEN t.LastName LIKE ''+ @SearchTerm + '%' THEN 1                
  WHEN t.Email LIKE ''+ @SearchTerm + '%' THEN 1                
  WHEN t.Phone LIKE ''+ @SearchTerm + '%' THEN 1                
  WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1                
  WHEN t.Zip LIKE ''+ @SearchTerm + '%' THEN 1                
  WHEN t.City LIKE ''+ @SearchTerm + '%' THEN 1                
  ELSE 0                
  END                
  )                
AND t.[Status] IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@Status,t.[Status]),',') ss)           
 AND t.[Status] NOT IN (@OfferMadeStatus, @ActiveStatus)                
 AND d.Id IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@DesignationId,d.Id),',') ss)           
 AND ISNULL(s.Id,'') IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@SourceId,ISNULL(s.Id,'')),',') ss)          
 AND ISNULL(t1.Id,t2.Id) IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@AddedByUserId,ISNULL(t1.Id,t2.Id)),',') ss)           
 AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)                
 AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)                
)                
SELECT  Id, FristName, LastName, Phone, Zip, Designation, Status, SecondaryStatus,HireDate, InstallId, picture, CreatedDateTime, Source, SourceUser,LastLoginTimeStamp,                
AddedBy, UserInstallId, InterviewDetail, RejectDetail, RejectedUserId, RejectedByUserName, RejectedByUserInstallId, Email, DesignationID,                
AddedByUserInstallId, AddedById, EmpType, [Aggregate], PrimaryPhone, CountryCode, Resumepath, TechTaskId, ParentTechTaskId,                
TechTaskInstallId, bookmarkedUser,  [StatusReason], Country, City,            
(Select top 1 CallStartTime From PhoneCallLog PCL WIth(NoLOck) Where PCL.ReceiverUserId = SalesUsers.Id Order by CreatedOn Desc) as LastCalledAt,            
IsNull((Select top 1 PhoneCode From Country CT WIth(NoLOck)             
 Where CT.CountryCodeTwoChar = SalesUsers.CountryCode Or CT.CountryCodeThreeChar = SalesUsers.CountryCode),'1') as PhoneCode,  
 SalesUsers.SalaryReq,SalesUsers.CurrencyName  
FROM SalesUsers                
WHERE RowNumber >= @StartIndex AND (@PageSize = 0 OR RowNumber < (@StartIndex + @PageSize))                
group by Id, FristName, LastName, Phone, Zip, Designation, Status,SecondaryStatus, HireDate, InstallId, picture, CreatedDateTime, Source, SourceUser,                
AddedBy, UserInstallId, InterviewDetail, RejectDetail, RejectedUserId, RejectedByUserName, RejectedByUserInstallId, Email, DesignationID,                
AddedByUserInstallId, AddedById, EmpType, [Aggregate], PrimaryPhone, CountryCode, Resumepath, TechTaskId, ParentTechTaskId,                
TechTaskInstallId, bookmarkedUser,  [StatusReason], Country, City,LastLoginTimeStamp,SalesUsers.SalaryReq,SalesUsers.CurrencyName            
ORDER BY CASE WHEN @SortExpression = 'Id ASC' THEN Id END ASC,                
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
   CASE WHEN @SortExpression = 'CreatedDateTime DESC' THEN CreatedDateTime END DESC,      
   CASE WHEN @SortExpression = 'LastLoginTimeStamp DESC' THEN LastLoginTimeStamp END DESC                          
              
 -- get record count - Table 5                
 SELECT COUNT(*) AS TotalRecordCount                
 FROM tblInstallUsers t                
 LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser                
 LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id                
 LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id        
 LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser                        
 LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id                
 LEFT JOIN tblSource s ON t.SourceId = s.Id                
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales') AND (@SearchTerm IS NULL OR                
   1 = CASE WHEN t.InstallId LIKE ''+ @SearchTerm + '%' THEN 1                
    WHEN t.FristName LIKE ''+ @SearchTerm + '%' THEN 1                
    WHEN t.LastName LIKE ''+ @SearchTerm + '%' THEN 1                
    WHEN t.Email LIKE ''+ @SearchTerm + '%' THEN 1                
    WHEN t.Phone LIKE ''+ @SearchTerm + '%' THEN 1                
    WHEN t.CountryCode LIKE ''+ @SearchTerm + '%' THEN 1                
    WHEN t.Zip LIKE ''+ @SearchTerm + '%' THEN 1                
    ELSE 0 END)                
 AND t.[Status] IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@Status,t.[Status]),',') ss)           
 AND t.[Status] NOT IN (@OfferMadeStatus, @ActiveStatus)                
 AND d.Id IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@DesignationId,d.Id),',') ss)           
 AND ISNULL(s.Id,'') IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@SourceId,ISNULL(s.Id,'')),',') ss)          
 AND ISNULL(t1.Id,t2.Id) IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@AddedByUserId,ISNULL(t1.Id,t2.Id)),',') ss)           
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)                
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)                
                
  -- Get the Total Count - Table 6                
   SELECT Count(*) as TCount                
  FROM tblInstallUsers t                
  LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser                
  LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser                
  LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId= ru.Id                
  LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id                
  LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id                
  LEFT JOIN tblSource s ON t.SourceId = s.Id                
  left outer join InstallUserBMLog as bm on t.id  =bm.bookmarkedUser and bm.isDeleted=0                
  OUTER APPLY(    SELECT TOP 1 tsk.TaskId, tsk.ParentTaskId, tsk.InstallId, ROW_NUMBER() OVER(ORDER BY u.TaskUserId DESC) AS RowNo                
  FROM tblTaskAssignedUsers u                
  INNER JOIN tblTask tsk ON u.TaskId = tsk.TaskId AND (tsk.ParentTaskId IS NOT NULL OR tsk.IsTechTask = 1)                
  WHERE u.UserId = t.Id                
   ) AS Task                
  WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales') AND (@SearchTerm IS NULL OR                
    1 = CASE WHEN t.InstallId LIKE ''+ @SearchTerm + '%' THEN 1                
  WHEN t.FristName LIKE ''+ @SearchTerm + '%' THEN 1                
  WHEN t.LastName LIKE ''+ @SearchTerm + '%' THEN 1                
  WHEN t.Email LIKE ''+ @SearchTerm + '%' THEN 1                
  WHEN t.Phone LIKE ''+ @SearchTerm + '%' THEN 1                
  WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1                
  WHEN t.Zip LIKE ''+ @SearchTerm + '%' THEN 1                
  WHEN t.City LIKE ''+ @SearchTerm + '%' THEN 1                
  ELSE 0 END)                
   AND t.[Status] IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@Status,t.[Status]),',') ss)           
 AND t.[Status] NOT IN (@OfferMadeStatus, @ActiveStatus)                
 AND d.Id IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@DesignationId,d.Id),',') ss)           
 AND ISNULL(s.Id,'') IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@SourceId,ISNULL(s.Id,'')),',') ss)          
 AND ISNULL(t1.Id,t2.Id) IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@AddedByUserId,ISNULL(t1.Id,t2.Id)),',') ss)           
   AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)             
   AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)                
                   
     -- Get the Total Count - Table 7                
 IF OBJECT_ID('tempdb..#TempUserIds') IS NOT NULL DROP TABLE #TempUserIds            
  Create Table #TempUserIds(Id int)            
             
  ;WITH SalesUsers                
 AS                
 (SELECT t.Id, t.FristName, t.LastName, t.Phone, t.Zip, t.City, d.DesignationName AS Designation, t.Status,t.SecondaryStatus,t.HireDate, t.InstallId,                
 t.picture, t.CreatedDateTime, Isnull(s.Source,'') AS Source, t.SourceUser, ISNULL(U.Username,t2.FristName + ' ' + t2.LastName)                
 AS AddedBy, ISNULL (t.UserInstallId,t.id) As UserInstallId, t.LastLoginTimeStamp,               
 InterviewDetail = case when (t.Status=@InterviewDateStatus) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR)  + ' ' + coalesce(t.InterviewTime,'')                 
       else '' end,                
 RejectDetail = case when (t.[Status]=@RejectedStatus ) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR) + ' ' + coalesce(t.RejectionTime,'')                 
       else '' end,                
 CASE when (t.[Status]= @RejectedStatus ) THEN t.RejectedUserId ELSE NULL END AS RejectedUserId,                
 CASE when (t.[Status]= @RejectedStatus ) THEN ru.FristName + ' ' + ru.LastName ELSE NULL END AS RejectedByUserName,                
 CASE when (t.[Status]= @RejectedStatus ) THEN ru.[UserInstallId]  ELSE NULL END AS RejectedByUserInstallId,                
 t.Email, t.DesignationID, ISNULL(t1.[UserInstallId], t2.[UserInstallId]) As AddedByUserInstallId,                
 ISNULL(t1.Id,t2.Id) As AddedById, t.emptype as 'EmpType', t.Phone As PrimaryPhone, t.CountryCode, t.Resumepath,                
 --ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId,                
 /*Task.TaskId AS 'TechTaskId', Task.ParentTaskId AS 'ParentTechTaskId', Task.InstallId as 'TechTaskInstallId'*/              
 0 AS 'TechTaskId', 0 AS 'ParentTechTaskId', '' as 'TechTaskInstallId'              
 , bm.bookmarkedUser,                
 t.[StatusReason], dbo.udf_GetUserExamPercentile(t.Id) AS [Aggregate],                
 ROW_NUMBER() OVER(ORDER BY                
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
   CASE WHEN @SortExpression = 'City ASC' THEN t.City END ASC,                
   CASE WHEN @SortExpression = 'City DESC' THEN t.City END DESC,                 
   CASE WHEN @SortExpression = 'CreatedDateTime ASC' THEN t.CreatedDateTime END ASC,                
   CASE WHEN @SortExpression = 'CreatedDateTime DESC' THEN t.CreatedDateTime END DESC,      
   CASE WHEN @SortExpression = 'LastLoginTimeStamp DESC' THEN t.LastLoginTimeStamp END DESC                            
       ) AS RowNumber,                
    '' as Country                
  FROM tblInstallUsers t                
  LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser                
  LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser                
  LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId= ru.Id                
  LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id                
  LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id                
  LEFT JOIN tblSource s ON t.SourceId = s.Id                
  left outer join InstallUserBMLog as bm on t.id  =bm.bookmarkedUser and bm.isDeleted=0                
  OUTER APPLY                
 (                 
 SELECT tsk.TaskId, tsk.ParentTaskId, tsk.InstallId, ROW_NUMBER() OVER(ORDER BY u.TaskUserId DESC) AS RowNo                
 FROM tblTaskAssignedUsers u                
 INNER JOIN tblTask tsk ON u.TaskId = tsk.TaskId AND                
 (tsk.ParentTaskId IS NOT NULL OR tsk.IsTechTask = 1)                
 WHERE u.UserId = t.Id                
 ) AS Task                
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales') AND (@SearchTerm IS NULL OR                 
    1 = CASE WHEN t.InstallId LIKE ''+ @SearchTerm + '%' THEN 1                
  WHEN t.FristName LIKE ''+ @SearchTerm + '%' THEN 1                
  WHEN t.LastName LIKE ''+ @SearchTerm + '%' THEN 1                
  WHEN t.Email LIKE ''+ @SearchTerm + '%' THEN 1                
  WHEN t.Phone LIKE ''+ @SearchTerm + '%' THEN 1                
  WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1                
  WHEN t.Zip LIKE ''+ @SearchTerm + '%' THEN 1                
  WHEN t.City LIKE ''+ @SearchTerm + '%' THEN 1                
  ELSE 0                
  END                
  )                
AND t.[Status] IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@Status,t.[Status]),',') ss)           
 AND t.[Status] NOT IN (@OfferMadeStatus, @ActiveStatus)               
 AND d.Id IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@DesignationId,d.Id),',') ss)           
 AND ISNULL(s.Id,'') IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@SourceId,ISNULL(s.Id,'')),',') ss)          
 AND ISNULL(t1.Id,t2.Id) IN (SELECT ss.Item  FROM dbo.SplitString(ISNULL(@AddedByUserId,ISNULL(t1.Id,t2.Id)),',') ss)           
 AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)                
 AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)                
)                
Insert Into #TempUserIds SELECT  Id               
FROM SalesUsers                
WHERE RowNumber >= @StartIndex AND (@PageSize = 0 OR RowNumber < (@StartIndex + @PageSize))                
group by Id, FristName, LastName, Phone, Zip, Designation, Status, SecondaryStatus, HireDate, InstallId, picture, CreatedDateTime, Source, SourceUser,                
AddedBy, UserInstallId, InterviewDetail, RejectDetail, RejectedUserId, RejectedByUserName, RejectedByUserInstallId, Email, DesignationID,                
AddedByUserInstallId, AddedById, EmpType, [Aggregate], PrimaryPhone, CountryCode, Resumepath, TechTaskId, ParentTechTaskId,                
TechTaskInstallId, bookmarkedUser,  [StatusReason], Country, City,LastLoginTimeStamp                
ORDER BY CASE WHEN @SortExpression = 'Id ASC' THEN Id END ASC,                
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
   CASE WHEN @SortExpression = 'CreatedDateTime DESC' THEN CreatedDateTime END DESC,      
   CASE WHEN @SortExpression = 'LastLoginTimeStamp DESC' THEN LastLoginTimeStamp END DESC                           
                
 Select E.* From #TempUserIds T Join tblUserEmail E On T.Id = E.UserID            
            
   -- Get the Total Count - Table 8                
  Select P.* From #TempUserIds T Join tblUserPhone P On T.Id = P.UserID            
                
                
  -- Get Notes from tblUserNotes - Table 9                
--  SELECT I.FristName+' - '+CAST(I.ID as varchar) as [AddedBy],N.AddedOn,N.Notes, N.UserID from tblInstallUsers I INNER JOIN tblUserNotes N ON                
--(I.ID = N.UserID)                
                
 SELECt UserTouchPointLogID , UserID, UpdatedByUserID, UpdatedUserInstallID, replace(LogDescription,'Note : ','') LogDescription, CurrentUserGUID,                
 CONVERT(VARCHAR,ChangeDateTime,101) + ' ' + convert(varchar, ChangeDateTime, 108) as CreatedDate                
 FROM tblUserTouchPointLog n WITH (NOLOCK)                
 --inner join tblinstallusers I on I.id=n.userid                
 where isnull(UserId,0)>0 and LogDescription like 'Note :%'                
 order by ChangeDateTime desc                
END 


Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'UDP_GETInstallUserDetails' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE UDP_GETInstallUserDetails
  END
Go 

CREATE PROCEDURE [dbo].[UDP_GETInstallUserDetails]      
 @id int      

As       
BEGIN      
      
 SELECT       
  u.Id,FristName,Lastname,Email,[Address], ISNULL(d.DesignationName, Designation) AS Designation,      
  [Status],[Password],Phone,Picture,Attachements,zip,[state],city,      
  Bussinessname,SSN,SSN1,SSN2,[Signature],DOB,Citizenship,' ',      
  EIN1,EIN2,A,B,C,D,E,F,G,H,[5],[6],[7],maritalstatus,PrimeryTradeId,SecondoryTradeId,Source,Notes,StatusReason,GeneralLiability,PCLiscense,WorkerComp,HireDate,TerminitionDate,WorkersCompCode,NextReviewDate,EmpType,LastReviewDate,PayRates,ExtraEarning,  
  ExtraEarningAmt,      
  PayMethod,Deduction,DeductionType,AbaAccountNo,AccountNo,AccountType,PTradeOthers,      
  STradeOthers,DeductionReason,InstallId,SuiteAptRoom,FullTimePosition,ContractorsBuilderOwner,MajorTools,DrugTest,ValidLicense,TruckTools,PrevApply,LicenseStatus,CrimeStatus,StartDate,SalaryReq,Avialability,ResumePath,skillassessmentstatus,assessmentPath
  ,WarrentyPolicy,CirtificationTraining,businessYrs,underPresentComp,websiteaddress,PersonName,PersonType,CompanyPrinciple,UserType,Email2,Phone2,CompanyName,SourceUser,DateSourced,InstallerType,BusinessType,CEO,LegalOfficer,President,Owner,AllParteners, 
  MailingAddress,Warrantyguarantee,WarrantyYrs,MinorityBussiness,WomensEnterprise,InterviewTime,CruntEmployement,CurrentEmoPlace,LeavingReason,CompLit,FELONY,shortterm,LongTerm,BestCandidate,TalentVenue,Boardsites,NonTraditional,ConSalTraning,BestTradeOne,      
  BestTradeTwo,BestTradeThree      
  ,aOne,aOneTwo,bOne,cOne,aTwo,aTwoTwo,bTwo,cTwo,aThree,aThreeTwo,bThree,cThree,TC,ExtraIncomeType,RejectionDate ,UserInstallId      
  ,PositionAppliedFor, PhoneExtNo, PhoneISDCode ,DesignationID, CountryCode      
  ,NameMiddleInitial , IsEmailPrimaryEmail, IsPhonePrimaryPhone, IsEmailContactPreference, IsCallContactPreference, IsTextContactPreference, IsMailContactPreference, d.ID AS DesignationId,       
  SourceID,DesignationCode, AddedByUserId  , ISNULL(U.UserInstallID,U.Id) as UserInstallID,u.CurrencyId,
  u.SecondaryStatus
 FROM tblInstallUsers u       
   LEFT JOIN tbl_Designation d ON u.DesignationID = d.ID      
      
 WHERE u.ID=@id      
      
END 

GO


