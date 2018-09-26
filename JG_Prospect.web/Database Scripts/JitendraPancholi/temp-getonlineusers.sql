
Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetOnlineUsers' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetOnlineUsers
  END
Go 
-- GetOnlineUsers @LoggedInUserId=780, @SortBy='recent', @FilterBy='department', @PageNumber=1, @DepartmentId=1,@PageSize=9999, @Type='chats'
Create PROCEDURE [dbo].[GetOnlineUsers] 
	@LoggedInUserId INT  ,
	@SortBy Varchar(100) = null,
	@FilterBy Varchar(100) = null,
	@PageNumber int = 1,
	@PageSize int = 5,
	@DepartmentId int = null,
	@Type varchar(20) = 'all',
	@MarkAllRead bit = 0
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


	if @PageNumber <= 0 begin set @PageNumber = 1 End
    IF OBJECT_ID('tempdb..#OnlineUsersOrGroups') IS NOT NULL  
        DROP TABLE #OnlineUsersOrGroups;  
    DECLARE @ChatRoleId INT,  @LoggedInUserStatus INT, @LoggedInUserDepartmentId int
  
    SELECT @LoggedInUserStatus = Status  , @LoggedInUserDepartmentId = DT.Id
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
               --NULL AS ChatUserCount,  
               CAST(NULL AS NVARCHAR(1000)) AS GroupNameAnchor,  
               0 AS UnreadCount  
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
                   AND M.ChatSourceId IN ( 2, 10 )  
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
               --(SELECT Count(userid)   
               -- FROM   userchatgroupmember S   
               -- WHERE  S.userchatgroupid = userchatgroupid) AS ChatUserCount,  
               dbo.[Udf_getonlineuserstitle](tbl.TaskId, tbl.TaskMultilevelListId) AS GroupNameAnchor,  
               0 AS UnreadCount  
        FROM  
        (  
            SELECT ROW_NUMBER() OVER (PARTITION BY G.Id ORDER BY M.CreatedOn DESC) AS row,  
                   M.ChatGroupId,  
                   M.TextMessage AS LastMessage,  
                   M.Id AS MessageId,  
                   ISNULL(M.CreatedOn, '01-01-1900') AS MessageAt,  
                   'chat-group.png' AS Picture,  
				   null As DepartmentId ,null As DepartmentName,
                   CASE  
                       WHEN tChatRead.ChatMessageId IS NOT NULL THEN  
                           0  
                       ELSE  
                           1  
                   END AS IsRead,  
                   M.TaskId,  
                   M.TaskMultilevelListId,  
                   G.Id AS UserChatGroupId  
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
    --select * from #OnlineUsersOrGroups  
  
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
                                       AND G.ReceiverIds LIKE '%' + CONVERT(VARCHAR(12), M.SenderId) + '%'  
                                       AND S.ReceiverId = @LoggedInUserId  
                             )  
                             ELSE  
                         (  
                             SELECT COUNT(1)  
                             FROM ChatMessageReadStatus S WITH (NOLOCK)  
                                 JOIN ChatMessage M WITH (NOLOCK)  
                                     ON M.Id = S.ChatMessageId  
                             WHERE S.IsRead = 0  
                                   AND M.ChatGroupId = G.chatgroupid  
                                   AND G.ReceiverIds LIKE '%' + CONVERT(VARCHAR(12), M.SenderId) + '%'  
                                   AND S.ReceiverId = @LoggedInUserId  
                                   AND M.UserChatGroupId IS NULL  
                         )  
                         END  
                        )  
    FROM #OnlineUsersOrGroups G;  
    -- Update Unread Count    
  print @LoggedInUserStatus
    IF @LoggedInUserStatus = 5 -- InterviewDate  
    BEGIN  
        SELECT TOP 200
               *  
        FROM #OnlineUsersOrGroups O  
        WHERE O.UserId IN (  
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
        ORDER BY /*MessageAt,*/ O.MessageAt DESC;  
    END;  
    ELSE  
    BEGIN  
		If @Type = 'Calls'
			Begin
				Select P.ReceiverUserId As UserId, U.LastLoginTimeStamp as OnlineAt, 100 As UserRank, 1 As UserStatus,  
					U.LastLoginTimeStamp AS LastLoginAt, U.FristName +' '+U.LastName As GroupOrUsername, U.UserInstallId, U.Picture, 
					D.DepartmentId, DT.DepartmentName, 'Called at ' + Convert(Varchar(200),P.CallStartTime) As LastMessage, 
					P.CreatedOn As LastMessageAt, null As MessageId, 
					P.CallStartTime As MessageAt, P.ReceiverUserId As ReceiverIds, Convert(Bit,1) As IsRead, NULL AS ChatGroupId, Null As TaskId,
					NUll As TaskMultiLevelListId, NULL As UserChatGroupId, NULL As GroupNameAnchor, 0 As UnreadCount
				From PhoneCallLog P With (NoLock)
					Join tblInstallUsers U On P.ReceiverUserId = U.Id
					Join tbl_Designation D With(NoLock) On D.Id = U.DesignationId
					Join tbl_Department DT on DT.Id = D.DepartmentId
				Where P.CreatedBy = @LoggedInUserId 
				Order by P.CreatedOn Desc
				OFFSET @PageSize * (@PageNumber - 1) ROWS
				FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
			End
		Else if @FilterBy = 'department'
			Begin
				If @DepartmentId IS NULL
					Begin
						SELECT TOP 5 * INTO #DepartmentOnlineUsersOrGroups FROM #OnlineUsersOrGroups Where DepartmentID = @LoggedInUserDepartmentId And  MessageId is not null Order by MessageAt DESC
						Insert Into #DepartmentOnlineUsersOrGroups
						SELECT TOP 5 * FROM #OnlineUsersOrGroups Where DepartmentID = 3 And DepartmentID != @LoggedInUserDepartmentId And  MessageId is not null Order by MessageAt DESC
						Insert Into #DepartmentOnlineUsersOrGroups
						SELECT TOP 5 * FROM #OnlineUsersOrGroups Where DepartmentID = 4 And DepartmentID != @LoggedInUserDepartmentId And  MessageId is not null Order by MessageAt DESC
						Insert Into #DepartmentOnlineUsersOrGroups
						SELECT TOP 5 * FROM #OnlineUsersOrGroups Where DepartmentID = 1 And DepartmentID != @LoggedInUserDepartmentId And  MessageId is not null Order by MessageAt DESC
						Insert Into #DepartmentOnlineUsersOrGroups
						SELECT TOP 5 * FROM #OnlineUsersOrGroups Where DepartmentID = 2 And DepartmentID != @LoggedInUserDepartmentId And  MessageId is not null Order by MessageAt DESC

						Select * From #DepartmentOnlineUsersOrGroups
					End
				Else
					Begin
						SELECT * FROM #OnlineUsersOrGroups Where DepartmentID = @DepartmentId And  MessageId is not null
							Order by MessageAt DESC
							OFFSET @PageSize * (@PageNumber - 1) ROWS
							FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
					End
			End
		Else If @SortBy = 'unread'
			begin
				If  @Type = 'all' 
					Begin
						SELECT TOP 40 * FROM #OnlineUsersOrGroups 
						Where MessageId is not null
						 ORDER BY /*IsNull(MessageAt,'2000-01-01'), */UnreadCount Desc;  
					End
				If  @Type = 'chats' OR  @Type = 'online' 
					Begin
						SELECT TOP 40 * FROM #OnlineUsersOrGroups 
						Where MessageId is not null and UserId is not null
						 ORDER BY /*IsNull(MessageAt,'2000-01-01'), */UnreadCount Desc;  
					End
				If  @Type = 'groups' 
					Begin
						SELECT TOP 40 * FROM #OnlineUsersOrGroups 
						Where MessageId is not null and UserId is null
						 ORDER BY /*IsNull(MessageAt,'2000-01-01'), */UnreadCount Desc;  
					End
			end
		else if @SortBy = 'active'
			Begin
				If  @Type = 'all' 
					Begin
						SELECT TOP 200 * FROM #OnlineUsersOrGroups
						Where MessageId is not null
						ORDER BY OnlineAt DESC;
					End
				If  @Type = 'chats' OR  @Type = 'online' 
					Begin
						SELECT TOP 200 * FROM #OnlineUsersOrGroups
						Where UserId IS NOT NULL And MessageId is not null
						ORDER BY OnlineAt DESC;
					End
				If  @Type = 'groups' 
					Begin
						SELECT TOP 200 * FROM #OnlineUsersOrGroups
						Where UserId IS NULL And MessageId is not null
						ORDER BY OnlineAt DESC;
					End
			End
		else if @SortBy = 'recent'
			Begin
				If  @Type = 'all' 
					Begin
						SELECT TOP 200 * FROM #OnlineUsersOrGroups
						Where MessageId is not null
						ORDER BY MessageAt DESC;
					End
				If  @Type = 'chats' OR  @Type = 'online' 
					Begin
						SELECT TOP 200 * FROM #OnlineUsersOrGroups
						Where UserId IS NOT NULL And MessageId is not null
						ORDER BY MessageAt DESC;
					End
				If  @Type = 'groups' 
					Begin
						SELECT TOP 200 * FROM #OnlineUsersOrGroups
						Where UserId IS NULL And MessageId is not null
						ORDER BY MessageAt DESC;
					End			
			End
		else
			begin
				SELECT TOP 40 * FROM #OnlineUsersOrGroups ORDER BY MessageAt DESC;
			end
        
    END;  
  
END;  
  
  
--SELECT * FROM tblInstallUsers

