Go
IF NOT EXISTS (SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[ChatMessage]') AND name = 'EmailStatusId')
BEGIN
	Alter Table ChatMessage Add EmailStatusId bigint Foreign Key References EmailStatus(Id)
END

Go
IF NOT EXISTS (SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[UserStatusAudit]'))
BEGIN
	Create Table UserStatusAudit
	(
		Id int Primary Key Identity(1,1),
		UserId int foreign key references tblInstallUsers(Id),
		PrimaryStatus int,
		SecondaryStatus int,
		PageLocation varchar(800),
		CreatedBy int foreign key references tblInstallUsers(Id),
		CreatedOn DateTime Default(GetUTCDate()),
		IsManual bit not null default(0)
	)
END
Go
IF EXISTS (SELECT * FROM   sys.columns  WHERE  object_id = OBJECT_ID(N'[dbo].[ChatMessage]') AND name = 'ReceiverIds')
	Begin
		ALTER TABLE ChatMessage ALTER COLUMN ReceiverIds varchar(800) NOT NULL
	End

GO
IF NOT EXISTS (SELECT * FROM   sys.columns  WHERE  object_id = OBJECT_ID(N'[dbo].[UserChatGroup]') AND name = 'ChatGroupType')
	Begin
		ALTER TABLE UserChatGroup Add ChatGroupType int 
	End
Go
IF NOT EXISTS (SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[PhoneScript]') AND name = 'DesignationId')
BEGIN
	Alter Table PhoneScript Add DesignationId int Foreign Key References tbl_Designation(Id)
END

Go
IF EXISTS (SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[PhoneScript]') AND name = 'DesignationId')
BEGIN
	Update PhoneScript Set DesignationId=23
END

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetPhoneScripts' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetPhoneScripts
  END
Go 
 -- =============================================      
-- Author:  Jitendra Pancholi      
-- Create date: 9 Jan 2017   
-- Description: Add offline user to chatuser table
-- =============================================    
/*
	GetPhoneScripts 
	GetPhoneScripts 1
	select * from tbl_Designation
*/
CREATE PROCEDURE [dbo].[GetPhoneScripts]
	@Id Int = Null
AS    
BEGIN
	If @Id IS NULL OR @Id = 0
		Begin
			Select P.Id,P.[Type],P.SubType,P.Title,P.[Description],P.CreatedOn, P.FAQTitle, P.FAQDescription, P.DesignationId, D.DesignationName
			From PhoneScript P With(NoLock) Left Join tbl_Designation D On P.DesignationId = D.Id
			Order By P.[Type], P.SubType
		End
	Else
		Begin
			Select P.Id,P.[Type],P.SubType,P.Title,P.[Description],P.CreatedOn, P.FAQTitle, P.FAQDescription, P.DesignationId, D.DesignationName
			From PhoneScript P With(NoLock) Left Join tbl_Designation D On P.DesignationId = D.Id
				Where P.Id = @Id Order By P.[Type], P.SubType
		End
End

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'UpdatePhoneScript' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE UpdatePhoneScript
  END
Go 
 ---- =============================================    
-- Author:  Jitendra Pancholi    
-- Create date: 03/30/2018  
-- Description: Load all details of task for edit.    
-- =============================================    
-- UpdatePhoneScript  
   
CREATE PROCEDURE [dbo].[UpdatePhoneScript]     
(    
 @Id int,  
 @Title nvarchar(2000),  
 @Script nVarchar(max),  
 @DesignationId int  
)       
AS    
BEGIN  
 Update PhoneScript Set  
  Title = @Title,  
  Description = @Script,  
  DesignationId = @DesignationId  
 Where Id = @Id  
End  
  

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'AddUpdatePhoneScript' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE AddUpdatePhoneScript
  END
Go 
 ---- =============================================  
-- Author:  Jitendra Pancholi  
-- Create date: 03/30/2018
-- Description: Load all details of task for edit.  
-- =============================================  
-- AddUpdatePhoneScript
 
CREATE PROCEDURE [dbo].[AddUpdatePhoneScript]   
(  
	@Id int,
	@Type int,
	@SubType int,
	@Title nvarchar(2000),
	@Script nVarchar(max),
	@DesignationId int,
	@ScriptType varchar(20) = 'script'
)     
AS  
BEGIN
	If Exists (Select 1 From PhoneScript Where Id = @Id)
		Begin
			If @ScriptType = 'script'
				Begin
					Update PhoneScript Set
							Title = @Title,
							Description = @Script
					Where Id = @Id
				End
			Else
				Begin
					Update PhoneScript Set
							FAQTitle = @Title,
							FAQDescription = @Script
					Where Id = @Id
				End
			Select @Id As Id
		End
	Else
		Begin
			If @ScriptType = 'script'
				Begin
					Insert Into PhoneScript(Type, SubType, Title, Description, CreatedOn, DesignationId)
						Values(@Type, @SubType, @Title, @Script, GetUTCDate(), @DesignationId)
				End
			Else
				Begin
					Insert Into PhoneScript(Type, SubType, FAQTitle, FAQDescription, CreatedOn, DesignationId)
						Values(@Type, @SubType, @Title, @Script, GetUTCDate(), @DesignationId)
				End
			Select IDENT_CURRENT('PhoneScript') As Id
		End
End

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'AddUpdatePhoneScriptFAQ' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE AddUpdatePhoneScriptFAQ
  END
Go 
 

IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'UpdatePhoneScriptFAQ' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE UpdatePhoneScriptFAQ
  END
Go 
 ---- =============================================  
-- Author:  Jitendra Pancholi  
-- Create date: 03/30/2018
-- Description: Load all details of task for edit.  
-- =============================================  
-- UpdatePhoneScriptFAQ
 
CREATE PROCEDURE [dbo].[UpdatePhoneScriptFAQ]   
(  
	@Id int,
	@Title nvarchar(2000),
	@Script nVarchar(max)
)     
AS  
BEGIN
	Update PhoneScript Set
		FAQTitle = @Title,
		FAQDescription = @Script
	Where Id = @Id
End
GO

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetPhoneScriptByDesignationId' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetPhoneScriptByDesignationId
  END
Go 
 -- =============================================      
-- Author:  Jitendra Pancholi      
-- Create date: 9 Jan 2017   
-- Description: Add offline user to chatuser table
-- =============================================    
/*
	GetPhoneScriptByDesignationId 
	GetPhoneScriptByDesignationId 23,1,1
*/
CREATE PROCEDURE [dbo].[GetPhoneScriptByDesignationId]
	@DesignationId Int,
	@Type int,
	@SubType int
AS    
BEGIN	
	Select P.Id,P.[Type],P.SubType,P.Title,P.[Description],P.CreatedOn, P.FAQTitle, P.FAQDescription,
	 P.DesignationId, D.DesignationName
	From PhoneScript P With(NoLock) Left Join tbl_Designation D On P.DesignationId = D.Id
		Where P.DesignationId = @DesignationId 
		And P.Type = @Type And P.SubType = @SubType
		Order By P.[Type], P.SubType
End

Go
IF NOT EXISTS (SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[CallPosition]'))
BEGIN
	Create Table CallPosition
	(
		Id int Primary Key Identity(1,1),
		CallerUserId int foreign key references tblInstallUsers(Id),
		CandidateUserId int foreign key references tblInstallUsers(Id),
		CreatedOn DateTime Default(GetUTCDate())
	)
END


Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetCallPosition' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetCallPosition
  END
Go 
 -- =============================================      
-- Author:  Jitendra Pancholi      
-- Create date: 9 Jan 2017   
-- Description: Add offline user to chatuser table
-- =============================================    
/*
	GetCallPosition 
	GetCallPosition 23
*/
CREATE PROCEDURE [dbo].[GetCallPosition]
	@CallerUserId Int
AS    
BEGIN	
	Select top 1 Id, CallerUserId, CandidateUserId, CreatedOn From CallPosition Where CallerUserId = @CallerUserId
End

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'SaveCallPosition' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE SaveCallPosition
  END
Go 
 ---- =============================================  
-- Author:  Jitendra Pancholi  
-- Create date: 03/30/2018
-- Description: Load all details of task for edit.  
-- =============================================  
-- SaveCallPosition
 
CREATE PROCEDURE [dbo].[SaveCallPosition]   
(  
	@CallerUserId int,
	@CandidateUserId int
)     
AS  
BEGIN
	Delete from CallPosition Where CallerUserId = @CallerUserId
	If @CandidateUserId > 0 
		Begin
			Insert Into CallPosition(CallerUserId, CandidateUserId) Values(@CallerUserId, @CandidateUserId)
		End
End

GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'SavePhoneCallLog' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE SavePhoneCallLog
  END
Go 
 ---- =============================================  
-- Author:  Jitendra Pancholi  
-- Create date: 03/30/2018
-- Description: Load all details of task for edit.  
-- =============================================  
-- SavePhoneCallLog
 
CREATE PROCEDURE [dbo].[SavePhoneCallLog]   
(  
	@CallDurationInSeconds decimal(18,2),
	@CallerNumber varchar(20),	
	@Mode Varchar(20),
	@CreatedBy int,
	@ReceiverNumber varchar(20),
	@ReceiverUserId int = null,
	@NextReceiverUserId int = null
)     
AS  
BEGIN
	
if @Mode = 'out' OR @Mode = 'in'
	Begin
		-- Calculate StartTime
		Declare @CreatedOn DateTime = CONVERT(datetime, SWITCHOFFSET(GetUtcDate(), DATEPART(TZOFFSET, GetUtcDate() AT TIME ZONE 'Eastern Standard Time')))
		Declare @CallStartTime Datetime, @UserStatusWhenCalled Int
		Set @CallStartTime = DateAdd(second, -@CallDurationInSeconds, @CreatedOn)

		IF @ReceiverUserId IS NOT NULL
			Begin
				Select @UserStatusWhenCalled = Status From tblInstallUsers Where Id = @ReceiverUserId
			End
	
		Insert Into PhoneCallLog(CallDurationInSeconds, CallerNumber, CallStartTime, Mode, CreatedBy, ReceiverNumber, ReceiverUserId, CreatedOn, UserStatusWhenCalled)
			Values(@CallDurationInSeconds, @CallerNumber, @CallStartTime, @Mode, @CreatedBy, @ReceiverNumber, @ReceiverUserId, @CreatedOn, @UserStatusWhenCalled)

		-- Auto Entry in Chats
		Declare @ChatGroupId varchar(100) = nULL, @msg NVarchar(max)
		Declare @CreatedByFullName Varchar(200), @ReceiverUserFullName Varchar(200)

		IF @ReceiverUserId IS NOT NULL
			Begin
				Select @ReceiverUserFullName = ISNULL(FristName,'') + ' ' + ISNULL(LastName,'') + '-' + ISNULL(UserInstallId,'') From tblInstallUsers Where Id = @ReceiverUserId
				Select @CreatedByFullName = ISNULL(FristName,'') + ' ' + ISNULL(LastName,'') + '-' + ISNULL(UserInstallId,'') From tblInstallUsers Where Id = @CreatedBy

				Select top 1 @ChatGroupId = S.ChatGroupId
					From ChatMessage S With(NoLock)
					Where ((S.SenderId = @CreatedBy And S.ReceiverIds = Convert(Varchar(12), @ReceiverUserId))
						Or (S.SenderId = @ReceiverUserId And S.ReceiverIds =  Convert(Varchar(12), @CreatedBy)))
						And S.ChatSourceId Not In (2) And S.UserChatGroupId IS NULL
				IF ISNULL(@ChatGroupId,'') = ''
					Begin
						Set @ChatGroupId = NEWID()
					End
				/*
				IF @CallDurationInSeconds = 0
					Begin
						Set @msg ='Call Not Connected: ' + @CreatedByFullName + ' auto dialed ' + @ReceiverUserFullName + ' on ' + Convert(Varchar(200), @CallStartTime)
						--Update tblInstallUsers Set SecondaryStatus = 2 Where Id = @ReceiverUserId
					End
				Else
					Begin 
						Set @msg ='Call Connected: ' + @CreatedByFullName + ' auto dialed ' + @ReceiverUserFullName + ' on ' + Convert(Varchar(200), @CallStartTime)
						-- Change User Secondary Staus to autoemail-Sent(date& time) - A
						Insert Into UserStatusAudit(UserId, PrimaryStatus, SecondaryStatus, PageLocation, CreatedBy, IsManual)
							Values(@ReceiverUserId, null, (select top 1 SecondaryStatus from tblInstallUsers Where Id = @ReceiverUserId), 'Dialer', @CreatedBy, 0)
						Exec UpdateSecondaryStatus @SecondaryStatus = 10, @UserId = @ReceiverUserId, @LoggedInUserId = @CreatedBy
						
					End
				Exec SaveChatMessage 11,@ChatGroupId, @CreatedBy, @msg,null, @ReceiverUserId,null,null
				*/
				--
				Delete from CallPosition Where CallerUserId = @CreatedBy
				If @NextReceiverUserId > 0 
					Begin
						Insert Into CallPosition(CallerUserId, CandidateUserId) Values(@CreatedBy, @NextReceiverUserId)
					End
			End
	End
End
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
	@FromDate='01/01/1999', @ToDate='08/21/2018',@PageIndex=0,@PageSize=200, @SortExpression='CreatedDateTime DESC',
	@InterviewDateStatus='5',
	@RejectedStatus='9',@OfferMadeStatus='6',@ActiveStatus='1' ,@FirstTimeOpen=1,@LoggedInUserId=780
	
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
              
 IF @Status = ''              
 BEGIN              
  SET @Status = NULL              
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
WHERE RowNumber >= @StartIndex AND (@PageSize = 0 OR RowNumber <= (@StartIndex + @PageSize))              
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
 t.[StatusReason], dbo.udf_GetUserExamPercentile(t.Id) AS [Aggregate],t.LastLoginTimeStamp,t.SecondaryStatus,              
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
   CASE WHEN @SortExpression = 'LastLoginTimeStamp DESC' THEN t.LastLoginTimeStamp END DESC ,
   CASE WHEN @SortExpression = 'SecondaryStatus ASC' THEN t.SecondaryStatus END ASC,    
	   CASE WHEN @SortExpression = 'SecondaryStatus DESC' THEN t.SecondaryStatus END DESC
	   , IsNull(t.SecondaryStatus,0) Asc                         
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
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetHTMLTemplateMasters' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetHTMLTemplateMasters
  END
Go 
 -- =============================================      
-- Author:  Jitendra Pancholi      
-- Create date: 9 Jan 2017   
-- Description: Add offline user to chatuser table
-- =============================================    
/*
	GetHTMLTemplateMasters 
	GetHTMLTemplateMasters 1
	select * from tbl_Designation
*/
CREATE PROCEDURE [dbo].[GetHTMLTemplateMasters]          
(      
@UsedFor INT      
)        
AS          
        
BEGIN          
        
 SET NOCOUNT ON;          
          
 SELECT * FROM tblHTMLTemplatesMaster  WHERE 
	Id IN (1, 7, 12, 28, 36, 41, 48, 50, 57, 58, 60,69,70,71,72,73,74, 75, 76, 77, 78, 79, 80, 81,104,105,107,108)   
	AND UsedFor = @UsedFor ORDER BY Id ASC
END   

Go
IF object_id(N'GetTaskInstallId', N'FN') IS NOT NULL
    DROP FUNCTION GetTaskInstallId
GO
CREATE FUNCTION [dbo].[GetTaskInstallId] (@TaskId INT, @TaskMultilevelListId INT) 
returns NVARCHAR(1000) 
AS 
  BEGIN 
	Declare  @MainParentTaskId int, @ParentTaskId int
	Declare @TempChatGroupName varchar(200), @ChatGroupName varchar(200)='', 
	@TempTitle varchar(200), @Title varchar(200)

	Set @TaskId=237
	set @TaskMultilevelListId=null
	SELECT @ParentTaskId = IsNull(T.parenttaskid,''), 
				@TempChatGroupName = T.installid, 
				@Title = '', 
				@TempTitle = T.title 
		FROM   tbltask T WITH(nolock) 
		WHERE  T.taskid = @TaskId 
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
		-- Print @ChatGroupName
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

	SET @Title = @Title 
					+ Substring(@ChatGroupName, 0, Len(@ChatGroupName)) 
				-- + '</a>-' + @TempTitle 
	--SET @Title = Replace(@Title, '{MainParentTaskId}', 
	--             ISNULL(CONVERT(VARCHAR(12), @MainParentTaskId),'')) 
		Return @Title
  End

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GlobalSearch' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GlobalSearch
  END
Go 
 -- =============================================      
-- Author:  Jitendra Pancholi      
-- Create date: 9 Jan 2017   
-- Description: Add offline user to chatuser table
-- =============================================    
/*
	GlobalSearch 't',720
*/
CREATE PROCEDURE [dbo].[GlobalSearch]          
(      
	@Keyword Varchar(200),
	@LoggedInUserId int 
)        
AS                  
BEGIN    
	Select top 3 Id, FristName, LastName, Email From tblInstallUsers Where FristName like @Keyword + '%' Order by FristName

	Select top 3 Id, FristName, LastName, Email From tblInstallUsers Where LastName like @Keyword + '%' Order by LastName

	Select top 3 Id, FristName, LastName, Email From tblInstallUsers Where Email like @Keyword + '%' Order by Email
	/*
	Select top 3 dbo.[Udf_getonlineuserstitle](TaskId, null) AS Title From tblTask Where Title Like @Keyword + '%' Order by Title

	Select top 3 dbo.[Udf_getonlineuserstitle](ParentTaskId, Id) AS Title From tblTaskMultilevelList Where [Description] Like @Keyword + '%' Order by [Description]
	*/
END  

Go
IF NOT EXISTS (SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[tblTaskAssignedUsers]') AND name = 'StepCompleted')
BEGIN
	Alter Table tblTaskAssignedUsers Add StepCompleted bit not null default(0)
END


Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetTaskUsers' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetTaskUsers
  END
  -- =============================================        
-- Author:  Jitendra Pancholi        
-- Create date: 9 Jan 2017     
-- Description: Add offline user to chatuser table  
-- =============================================      
/*   
 GetTaskUsers 10816  
*/  
Go
CREATE PROCEDURE [dbo].[GetTaskUsers]  
	@TaskId int  
AS      
Begin  
	IF OBJECT_ID('tempdb..#TempUsers') IS NOT NULL DROP TABLE #TempUsers 
		Create Table #TempUsers(UserId int, Acceptance bit, CreatedDate datetime, StepCompleted bit)
	
	If NOT Exists (Select 1 From tblTaskAssignedUsers U With(NoLock) Where U.TaskId = @TaskId And U.UserId = 901)
		Begin
			Insert Into tblTaskAssignedUsers(TaskId, UserId,CreatedDate,StepCompleted) Values(@TaskId, 901, GetUTCDate(),0)
		End

	If NOT Exists (Select 1 From tblTaskAssignedUsers U With(NoLock) Where U.TaskId = @TaskId And U.UserId = 780)
		Begin
			Insert Into tblTaskAssignedUsers(TaskId, UserId,CreatedDate,StepCompleted) Values(@TaskId, 780, GetUTCDate(),0)
		End

	 Select UserId, Acceptance, CreatedDate, StepCompleted From tblTaskAssignedUsers U With(NoLock) Where U.TaskId = @TaskId
End  
    
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
	Declare @ParentTaskId int = null, @ChatGroupName NVarchar(2000) = '', @TempChatGroupName NVarchar(200) = '', 
			@Title NVarchar(1000), @MainParentTaskId int , @CustomTitle Varchar(800)

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
		case when U.designationId=1 Then 'red'
			 when U.designationId=21 Then 'black'
			 when U.designationId = 12 OR U.designationId = 22 Then 'green'
			 When U.designationId = 14 OR U.designationId = 20 THen 'orange'
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
	Order By U.Id Asc

	Set @Title = SUBSTRING(@Title, 0, LEN(@Title)) + ')'

	Select @Title As TaskTitle
	/* Proper Task Title with ID */
END  


Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'SetTaskStepStatus' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE SetTaskStepStatus
  END
  -- =============================================        
-- Author:  Jitendra Pancholi        
-- Create date: 9 Jan 2017     
-- Description: Add offline user to chatuser table  
-- =============================================      
/*   
 SetTaskStepStatus 10816,780
*/  
Go
CREATE PROCEDURE [dbo].[SetTaskStepStatus]  
	@TaskId int,
	@UserId int
AS      
Begin  
	If (Select top 1 StepCompleted From tblTaskAssignedUsers Where TaskID = @TaskId And UserId = @UserId) = 1
		Begin
			Update tblTaskAssignedUsers Set StepCompleted = 0 Where TaskID = @TaskId And UserId = @UserId
			Select convert(Bit, 0) StepCompleted
		End
	Else
		Begin
			Update tblTaskAssignedUsers Set StepCompleted = 1 Where TaskID = @TaskId And UserId = @UserId
			Select convert(Bit, 1) StepCompleted
		End	
End


Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'ChangeTaskChatTitle' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE ChangeTaskChatTitle
  END
Go 
 ---- =============================================  
-- Author:  Yogesh Keraliya  
-- Create date: 04/07/2016  
-- Description: Load all details of task for edit.  
-- =============================================  
-- ChangeTaskChatTitle 10816,3797  
Create PROCEDURE [dbo].[ChangeTaskChatTitle]   
(  
	@TaskId int,
	@LoggedInUserId int,
	@TaskMultilevelListId int,
	@Title varchar(800)
)     
AS  
BEGIN  
	IF @TaskMultilevelListId = 0
		Set @TaskMultilevelListId = null
	IF @TaskMultilevelListId IS NULL
		Begin
			Update UserChatGroup Set UserChatGroupTitle = @Title Where TaskId = @TaskId And TaskMultilevelListId IS NULL
		End
	Else
		Begin
			Update UserChatGroup Set UserChatGroupTitle = @Title Where TaskId = @TaskId And TaskMultilevelListId = @TaskMultilevelListId
		End 
End


Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetTaskMultilevelListItem' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetTaskMultilevelListItem
  END
Go 
---- =============================================    
-- Author:  Jitendra Pancholi    
-- Create date: 03/30/2018  
-- Description: Load all details of task for edit.    
-- =============================================    
-- GetTaskMultilevelListItem  
   
Create PROCEDURE [dbo].[GetTaskMultilevelListItem]     
(    
 @TaskMultilevelListId int  ,
 @LoggedInUserId int = null
)       
AS    
BEGIN  
 --Select * From tblTaskMultilevelList Where Id = @TaskMultilevelListId  
  
 /* Proper Task Title with ID */  /* Table[0] */  
 Declare @TaskId int, @ParentTaskId int = null, @ChatGroupName NVarchar(2000) = '', @TempChatGroupName NVarchar(200) = '',   
   @Title NVarchar(1000), @MainParentTaskId int   
   
 Select @TaskId = ParentTaskId From tblTaskMultilevelList Where Id = @TaskMultilevelListId  
  
 Select @TaskId = TaskId, @ParentTaskId = T.ParentTaskId, @TempChatGroupName = T.InstallId,   
   @Title = T.Title From tblTask T With(NoLock) Where T.TaskId = @TaskId  
  
 Select @Title = ISNULL(Title,@Title) From tblTaskMultilevelList Where Id = @TaskMultilevelListId  
  
 If @TaskId IS NOT NULL AND @ParentTaskId IS NOT NULL  
   Begin  
    If @TaskMultilevelListId IS NULL  
    Begin  
     Set @Title = @Title + ' <a target="_blank" onclick="event.stopPropagation();" href="/Sr_App/TaskGenerator.aspx?TaskId={MainParentTaskId}&hstid=' + Convert(Varchar(12),@TaskId) + '">'  
    End  
    Else  
    Begin  
     Set @Title = @Title + ' <a target="_blank" onclick="event.stopPropagation();" href="/Sr_App/TaskGenerator.aspx?TaskId={MainParentTaskId}&hstid=' + Convert(Varchar(12),@TaskId) + '&mcid='+ Convert(Varchar(12),@TaskMultilevelListId) +'">'  
    End  
   End  
  Else IF @TaskId IS NOT NULL  
   Begin  
    If @TaskMultilevelListId IS NULL  
    Begin  
     Set @Title = @Title + '<a target="_blank" onclick="event.stopPropagation();" href="/Sr_App/TaskGenerator.aspx?TaskId=' + Convert(Varchar(12),@TaskId) + '">'  
    End  
    Else  
    Begin  
     Set @Title = @Title + '<a target="_blank" onclick="event.stopPropagation();" href="/Sr_App/TaskGenerator.aspx?TaskId=' + Convert(Varchar(12),@TaskId) + '&mcid=' + Convert(Varchar(12),@TaskMultilevelListId) + '">'   
    End  
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
  
  /*
 Select @Title = @Title + ISNULL(U.FristName,'') + ' ' + ISNULL(U.LastName,'') + '-' + '<a target="_blank" href="/Sr_App/ViewSalesUser.aspx?id='+Convert(Varchar(12),U.Id)+'" uid="'+Convert(Varchar(12),U.Id)+'">'+ISNULL(U.UserInstallId,'')+'</a>' + ', ' 
 From #TaskUsers T With(NoLock)   
 Join tblInstallUsers U With(NoLock) On T.UserId = U.Id  
 Order By U.Id Asc  
 */
 Select @Title = @Title + '<div class="chk-box-outer '+ 
		case when U.designationId=1 Then 'red'
			 when U.designationId=21 Then 'black'
			 when U.designationId = 12 OR U.designationId = 22 Then 'green'
			 When U.designationId = 14 OR U.designationId = 20 THen 'orange'
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
	Order By U.Id Asc
  
 Set @Title = SUBSTRING(@Title, 0, LEN(@Title)) + ')'  
  
 Select @Title As FormattedTitle,* From tblTaskMultilevelList Where Id = @TaskMultilevelListId  
 /* Proper Task Title with ID */  
End



Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetOnlineUsers' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetOnlineUsers
  END
Go 
/*

 GetOnlineUsers @LoggedInUserId=8472, @SortBy='recent', @FilterBy='', @PageNumber=1, @DepartmentId=null,
			@PageSize=50, @Type='groups', @UserStatus = null

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
								SELECT * FROM #OnlineUsersOrGroups Where MessageId is not null
									And UserChatGroupId Is Null And
									(UserStatus in (1)) And (UserID != @LoggedInUserId OR UserId IS NULL) 
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
								SELECT * FROM #OnlineUsersOrGroups Where MessageId is not null And (UserID != @LoggedInUserId OR UserId IS NULL)
								 ORDER BY MessageAt DESC, GroupOrUsername ASC
								OFFSET @PageSize * (@PageNumber - 1) ROWS
								FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
							End
						Else
							Begin
								SELECT * FROM #OnlineUsersOrGroups Where MessageId is not null And (UserStatus in (1) )
								 And (UserID != @LoggedInUserId OR UserId IS NULL) ORDER BY MessageAt DESC, GroupOrUsername ASC
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
	--insert into temp values('trigger')
	Declare @MessageId int, @ChatSourceId Varchar(200), @UserChatGroupId int, @ReceiverIds Varchar(800)
	Declare @SourceId int, @SenderId int, @msg varchar(500), @Createdon Datetime, @SourceUser Varchar(12)

	Set @ChatSourceId = NewID()

	SELECT @SenderId = I.Id, @msg = '<span class="auto-entry">User successfully filled in HR form<span>', @SourceUser = I.SourceUser FROM INSERTED I
	
	Insert Into UserChatGroup (CreatedBy) Values(@SenderId)
	Set @UserChatGroupId = IDENT_CURRENT('UserChatGroup')

	IF OBJECT_ID('tempdb..#TempUsers') IS NOT NULL DROP TABLE #TempUsers   
	Create Table #TempUsers(UserId int, UserChatGroupId int)
	Insert Into #TempUsers Values(780, @UserChatGroupId)
	Insert Into #TempUsers Values(901, @UserChatGroupId)
	Insert Into #TempUsers Values(@SenderId, @UserChatGroupId)

	Insert Into UserChatGroupMember (UserChatGroupId, UserId)
		Select Distinct UserChatGroupId, UserId From #TempUsers
	
	SELECT @ReceiverIds = SUBSTRING((SELECT ',' + Convert(varchar(12),s.UserId) FROM #TempUsers s 
		ORDER BY s.UserId Asc FOR XML PATH('')),2,200000) 
	
	--Insert Into tblUserTouchPointLog(UserID, UpdatedByUserID, UpdatedUserInstallID, ChangeDateTime, LogDescription, CurrentUserGUID)
	
	
	Exec SaveChatMessage 1,@ChatSourceId, @SenderId, @msg,null, @ReceiverIds,null,null, @UserChatGroupId
	Declare @SenderName Varchar(200)
	Select @SenderName =  IsNULL(FristName,'')+' '+IsNULL(LastName,'') +'-'+IsNULL(UserInstallId,'')
		From tblINstallUsers Where Id = 1537 

	Declare @ESTTime DateTime
	Set @ESTTime = CONVERT(datetime, SWITCHOFFSET(GetUTCDate(), DATEPART(TZOFFSET, GetUTCDate() AT TIME ZONE 'Eastern Standard Time')))
	
	Set @msg = '<span class="auto-entry">Auto Email sent by ' + @SenderName + ' - HR Welcome Email - ' + Convert(varchar(20), @ESTTime, 101) + right(convert(varchar(32),@ESTTime,100),8) + ' (EST)</span>'

	/*Exec SaveChatMessage 1,@ChatSourceId, @SenderId, @msg,null, @ReceiverIds,null,null, @UserChatGroupId*/
		/*
SaveChatMessage
	@ChatSourceId int,
	@ChatGroupId Varchar(100),
	@SenderId int,
	@TextMessage nvarchar(max),
	@ChatFileId int,
	@ReceiverIds varchar(800),
	@TaskId int = null,
	@TaskMultilevelListId int =null

	*/

	-- Set UserInstallId if not set yet.
	Declare @UserInstallId Varchar(50), @DesignationCode varchar(10), @DesignationId int
	Select @UserInstallId = UserInstallId, @DesignationId = DesignationId From tblInstallUsers Where Id = @SenderId
	Select @DesignationCode = DesignationCode From tbl_Designation Where Id = @DesignationId

	IF ISNULL(@UserInstallId,'') = '' AND @DesignationId > 0
		Begin
			Exec USP_SetUserDisplayID @InstallUserID = @SenderId, @DesignationsCode = @DesignationCode, @UpdateCurrentSequence = 'YES'
		End
End

Go
IF NOT EXISTS (Select 1 From tblHTMLTemplatesMaster Where Id=109)
Begin
	
	Insert Into tblHTMLTemplatesMaster(Id, Name, Subject, Header, Body, Footer, DateUpdated, Type, Category, FromID, TriggerText, FrequencyInDays, FrequencyStartDate, FrequencyStartTime, UsedFor)
	Select 109, 'Call_Connected_Auto_Email', Subject, 
	'<span style="font-size: 13.3333px;">&nbsp; &nbsp; &nbsp;</span><img alt="" height="83" src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/logo.gif" width="81" style="font-size: 13.3333px;" /><span style="font-size: 13.3333px;">&nbsp;&nbsp; &nbsp;</span><img alt="" src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/header.jpg" style="font-size: 13.3333px;" /><br />
	<br />', 
	'<p class="MsoNormal" style="margin-bottom:0in;margin-bottom:.0001pt;line-height:normal"><span style="font-size: 10pt; font-family: arial, sans-serif; color: #222222; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">You have an unread message from JMGROVE user,</span></p>
	<p class="MsoNormal" style="margin-bottom:0in;margin-bottom:.0001pt;line-height:normal"><span style="font-size: 10pt; font-family: arial, sans-serif; color: #222222; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;"><br />
	<br />
	</span></p>
	<div style="width:250px;float:left;">        
	<div style="float:left;width:75px;height:75px;"><img src="{ImageUrl}" style="width:75px;height:75px;" /></div>        
	<div style="float:left;margin-left:5px;">            
	<div style="margin-bottom:5px;"><a href="{ProfileUrl}" target="_self">{SenderUserInstallID}</a></div>            
	<div style="margin-bottom:5px;">{SenderName}</div>            
	<div>{SenderDesignation}</div>        </div>    </div><span style="font-family: arial, helvetica, sans-serif; font-size: 9.5pt;">Hi,&nbsp;<br />
	My name is {SenderName} and below is the instructions to reply for the open job. If you have any questions, you can reply here and we can chat inside our software.<br />
	<br />
	Thanks</span>
	<p class="MsoNormal" style="margin-bottom:0in;margin-bottom:.0001pt;line-height:normal"><span style="background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; font-size: 9.5pt; font-family: arial, sans-serif; color: #222222;"><br />
	</span></p>
	<p class="MsoNormal" style="margin-bottom:0in;margin-bottom:.0001pt;line-height:normal"><span style="background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; font-size: 9.5pt; font-family: arial, sans-serif; color: #222222;">&nbsp;</span><span style="background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; font-size: 9.5pt; font-family: arial, sans-serif; color: #1155cc;"><a href="{MessageUrl}" target="_self" style="padding: 0 18px 3px 18px;background: url(http://web.jmgrovebuildingsupply.com/img/btn.png) no-repeat;line-height: 46px;color: #fff;font-weight: bold;font-size: 36px;cursor: pointer;text-decoration: none;display: inline-block;border-radius: 10px;box-shadow: 0 0 10px #a1a0a0;box-sizing: border-box;background-size: 134px 50px;">Reply   </a><br />
	</span></p>
	<p class="MsoNormal" style="margin-bottom:0in;margin-bottom:.0001pt;line-height:normal"><br />
	</p>
	<p class="MsoNormal" style="font-size: 13.3333px; margin-bottom: 0.0001pt; line-height: normal;"><span style="background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; font-size: 9.5pt; font-family: arial, sans-serif; color: #222222;">Dear {ReceiverName},</span></p>
	<p class="MsoNormal" style="font-size: 13.3333px; margin-bottom: 0.0001pt; line-height: normal;"><span style="background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial; font-size: 9.5pt; font-family: arial, sans-serif; color: #222222;">Thank you for applying and welcome to JMGrove LLC family of companies. To continue the interview process, you may log in with credentials below:</span></p>
	<p class="MsoNormal" style="font-size: 13.3333px; margin-bottom: 0.0001pt; line-height: normal;"><span style="background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;"><br />
	<font color="#222222" face="arial, sans-serif"><span style="font-size: 12.6667px;"><a href="https://web.jmgrovebuildingsupply.com/Stafflogin.aspx" target="_blank"><span style="color: #0000ff;">https://web.jmgrovebuildingsupply.com/Stafflogin.aspx</span></a><br />
	Username: </span></font><font color="#222222" face="arial, sans-serif"><span style="font-size: 12.6667px; color: #ff0000;">{ReceiverEmail}</span></font><font color="#222222" face="arial, sans-serif"><span style="font-size: 12.6667px;"> Or </span></font><font color="#222222" face="arial, sans-serif"><span style="font-size: 12.6667px; color: #ff0000;">{ReceiverPhone}</span></font><font color="#222222" face="arial, sans-serif"><span style="font-size: 12.6667px;"><br />
	Default Password: </span></font><font color="#222222" face="arial, sans-serif"><span style="font-size: 12.6667px; color: #ff0000;">jmgrove</span></font></span></p>
	<p class="MsoNormal" style="font-size: 13.3333px; margin-bottom: 0.0001pt; line-height: normal;"><span style="background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;"><font color="#222222" face="arial, sans-serif"><span style="font-size: 12.6667px;">Once logged in, you will be asked to fill out some additional contact info and take a short aptitude test for the position you are applying for. Once completed you will be asked to provide an interview date &amp; time to further discuss the job opportunity and review sample assignments.</span></font></span></p>
	<p class="MsoNormal" style="font-size: 13.3333px; margin-bottom: 0.0001pt; line-height: normal;"><span style="background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;"><font color="#222222" face="arial, sans-serif"><span style="font-size: 12.6667px;"><br />
	Once again, thank you for your interest with JMGrove. We look forward to the opportunity to assist you in the future.</span></font></span></p>
	<p class="MsoNormal" style="font-size: 13.3333px; margin-bottom: 0.0001pt; line-height: normal;"><span style="background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;"><font color="#222222" face="arial, sans-serif"><span style="font-size: 12.6667px;"><br />
	Sincerely, JMG Human Resource Team<br />
	<br />
	</span></font></span></p>
	<p class="MsoNormal" style="font-size: 13.3333px; margin-bottom: 0.0001pt; line-height: normal;"><span style="background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;"><font color="#222222" face="arial, sans-serif"><span style="font-size: 12.6667px;"><br />
	</span></font></span></p>
	<table cellspacing="0" cellpadding="0" width="100%" border="0" align="center" bgcolor="#f2f2f2" style="color: #222222; font-family: arial, sans-serif; font-size: 12.8px;">
	<tbody>
	<tr>
	<td valign="top" align="center" width="100%" style="font-family: arial, sans-serif; margin: 0px; padding-bottom: 15px;"></td></tr></tbody></table>', 
	Footer, DateUpdated, Type, Category, FromID, TriggerText, FrequencyInDays, FrequencyStartDate, FrequencyStartTime, UsedFor 
	From tblHTMLTemplatesMaster
	Where Id=104

ENd

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'USP_ChangeUserStatusToRejectByEmail' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE USP_ChangeUserStatusToRejectByEmail
  END
Go 
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
	@StatusId int=0,
	@RejectionDate DATE=NULL,
	@RejectionTime VARCHAR(20)=NULL,
	@RejectedUserId int=0,
	@StatusReason varchar(max)=''
)     
AS    
BEGIN 
  -- Updates user status and status related information.        
	UPDATE [dbo].[tblInstallUsers]      
		SET 
			[Status] = @StatusId      
			,RejectionDate = @RejectionDate      
			,RejectionTime = @RejectionTime      
			,InterviewTime = @RejectionTime      
			,RejectedUserId = @RejectedUserId      
			,StatusReason = @StatusReason      
		WHERE Email = @UserEmail

	Declare @UserId int
	Select @UserId = Id From tblInstallUsers Where Email = @UserEmail

	-- Change Secondary Status to RejectedOptOut (11)
	Insert Into UserStatusAudit(UserId, PrimaryStatus, SecondaryStatus, PageLocation, CreatedBy, IsManual)
			Values(@UserId, null, (select top 1 SecondaryStatus from tblInstallUsers Where Id = @UserId), 'UnsubscribeEmail', @UserId, 1)
	Exec UpdateSecondaryStatus @SecondaryStatus = 11, @UserId = @UserId, @LoggedInUserId = @UserId	
END

Go
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'EmailStatus') AND type in (N'U'))
BEGIN
	CREATE TABLE EmailStatus(
		Id Bigint Primary Key Identity(1,1),
		EmailType Varchar(100),
		MessageId Varchar(200) Not Null,
		TransactionId Varchar(200) Not Null,
		ToEmail Varchar(200) not null,
		FromEmail Varchar(200) not null,
		DateSend DateTime Not null,
		DateOpened DateTime,
		DateClicked DateTime,
		Status int NOT NULL,
		StatusChangeDate DateTime NOT NULL,
		ErrorMessage Varchar(Max),
		CreatedOn DateTime Not Null Default(GetDate())
	)
END 

Go
IF NOT EXISTS (SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[EmailStatus]') AND name = 'EmailBody')
BEGIN
	Alter Table EmailStatus Add EmailBody NVarchar(Max)
END

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'SaveEmailStatus' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE SaveEmailStatus
  END
Go 
-- =============================================        
       
-- =============================================        
CREATE PROCEDURE [dbo].[SaveEmailStatus]
(
	@EmailType Varchar(100),
	@MessageId Varchar(200),
	@TransactionId Varchar(200),
	@ToEmail Varchar(200),
	@FromEmail Varchar(200),
	/*@DateSend DateTime,*/
	@DateOpened DateTime,
	@DateClicked DateTime,
	@Status int,
	@StatusName Varchar(200),
	@StatusChangeDate DateTime,
	@ErrorMessage Varchar(Max),
	@EmailBody NVarchar(Max)
)     
AS    
BEGIN 
	Insert Into EmailStatus(EmailType, MessageId, TransactionId, ToEmail, FromEmail, DateSend, DateOpened, DateClicked, Status, 
								StatusChangeDate, ErrorMessage, EmailBody)
		Values(@EmailType, @MessageId, @TransactionId, @ToEmail, @FromEmail, GetUTCDate(), @DateOpened, @DateClicked, @Status, 
								@StatusChangeDate, @ErrorMessage, @EmailBody)
	Select IDENT_CURRENT('EmailStatus') As Id
End

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
			Exec AddHRChatMessage @UserId, @Note, NULL
		End
End


Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetActiveUsersByLoggedInUser' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetActiveUsersByLoggedInUser
  END
Go 
-- =============================================        
/*

	GetActiveUsersByLoggedInUser @LoggedInUserId=780,@ConnectedUsers='780'

*/
-- =============================================        
CREATE PROCEDURE [dbo].[GetActiveUsersByLoggedInUser]
(        
	@ConnectedUsers Varchar(Max),
	@LoggedInUserId int
)     
AS    
BEGIN
	IF OBJECT_ID('tempdb..#TempUsers') IS NOT NULL DROP TABLE #TempUsers   
		Create Table #TempUsers(Id int identity(1,1), UserId int)

	IF OBJECT_ID('tempdb..#TempActiveUsers') IS NOT NULL DROP TABLE #TempActiveUsers   
		Create Table #TempActiveUsers(Id int identity(1,1), UserId int)
	
	Insert Into #TempUsers(UserId) Select Distinct Item From dbo.Split(@ConnectedUsers, ',')

	Declare @Min int = 1, @Max int =1, @ReceiverId int
	Select @Min = Min(Id), @Max = Max(Id) From #TempUsers
	While @Min <= @Max
		Begin
			Select @ReceiverId = UserId From #TempUsers Where Id = @Min
			If Exists (Select 1 From ChatMessage Where (SenderId = @LoggedInUserId Or ',' + ReceiverIds + ',' like '%,' + Convert(Varchar(12), @LoggedInUserId) + '%,')
				And (SenderId = @ReceiverId Or ',' + ReceiverIds + ',' like '%,' + Convert(Varchar(12), @ReceiverId) + '%,'))
				Begin
					IF NOT EXISTS (Select 1 From #TempActiveUsers Where UserId = @ReceiverId)
						Begin
							Insert Into #TempActiveUsers(UserId) Values (@ReceiverId)
						End
				End
			Set @Min = @Min + 1
		End

	Select Id, UserId From #TempActiveUsers
End
go


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

	  Declare @TempCustomTaskTitle varchar(800) = 'Temp'
	
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
-- select dbo.[Udf_getonlineuserstitle] (11009,null) 


Go
IF NOT EXISTS (SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[ChatMessage]') AND name = 'IsWelcomeEmail')
BEGIN
	Alter Table ChatMessage Add IsWelcomeEmail bit not null default(0)
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
	Else IF @TaskId IS NULL And @UserChatGroupId IS NULL And @ChatSourceId != 10
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
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'UDP_ChangeStatus' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE UDP_ChangeStatus
  END
Go 
  
--SELECT * FROM tblInstallUsers

   
-- =============================================        
-- Author:  Yogesh        
-- Create date: 22 Sep 2016        
-- Description: Updates status and status related fields for install user.        
--    Inserts event and event users for interview status.        
--    Deletes any exising events and event users for non interview status.        
--    Gets install users details.    
/*

[UDP_ChangeStatus] @Id=8446,@Status='',@RejectedUserId=901

*/    
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

 Declare @oldStatus int
 Select @oldStatus = Status From [tblInstallUsers] WHERE Id = @Id  
        
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
        
		Insert Into UserStatusAudit(UserId, PrimaryStatus, SecondaryStatus, PageLocation, CreatedBy, IsManual)
			Values(@Id, @oldStatus, null, 'ChangeStatus', @RejectedUserId, 1)

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

 -- Make entry in chat for this status change.
 Declare @ChatGroupId Varchar(200), @UserChatGroupId int, @ReceiverIds Varchar(800), @msg varchar(800)

 --IF OBJECT_ID('tempdb..#TempUserIds') IS NOT NULL DROP TABLE #TempUserIds
	--Create Table #TempUserIds(Id int identity(1,1), UserId int)
	--Insert Into #TempUserIds(UserId)
	--	select Item from dbo.SplitString(@UserIds,',')

	Declare @Min int =1, @Max int = 1, @ReceiverUserId int
	--Select @Min =Min(Id), @Max = Max(Id) From #TempUserIds
	
--While @Min <= @Max
--	Begin
		--Select @ReceiverUserId = UserId From #TempUserIds Where Id = @Min

		Select top 1 @ChatGroupId = S.ChatGroupId, @UserChatGroupId = S.UserChatGroupId
			From ChatMessage S With(NoLock)
			Where ((S.SenderId = @Id And ',' + S.ReceiverIds + ',' like '%,' + Convert(Varchar(12), @RejectedUserId) + ',%')
				Or (S.SenderId = @RejectedUserId And ',' + S.ReceiverIds + ',' like  '%,' + Convert(Varchar(12), @Id)+ ',%')) 
			 And S.UserChatGroupId IS Not NULL And S.TaskId IS NULL
			Order by S.Id Asc
		IF ISNULL(@ChatGroupId,'') = ''
			Begin
				Set @ChatGroupId = NEWID()
			End
		If IsNull(@UserChatGroupId,0) = 0
			Begin
				Insert Into UserChatGroup (CreatedBy) Values(@Id)
				Set @UserChatGroupId = IDENT_CURRENT('UserChatGroup') 
		
				Insert Into UserChatGroupMember (UserChatGroupId, UserId) Values(@UserChatGroupId, 780)
				Insert Into UserChatGroupMember (UserChatGroupId, UserId) Values(@UserChatGroupId, 901)
				Insert Into UserChatGroupMember (UserChatGroupId, UserId) Values(@UserChatGroupId, @Id)
				If Not exists (Select 1 From UserChatGroupMember Where UserChatGroupId = @UserChatGroupId And UserId = @RejectedUserId)
					begin
						Insert Into UserChatGroupMember (UserChatGroupId, UserId) Values(@UserChatGroupId, @RejectedUserId)
					end
			End
		Print @ChatGroupId
		Print @UserChatGroupId
		Print @ReceiverIds

		SELECT @ReceiverIds = SUBSTRING((SELECT ',' + Convert(Varchar(12), s.UserId) FROM UserChatGroupMember s 
			Where UserChatGroupId = @UserChatGroupId And UserId not in (@RejectedUserId)
			ORDER BY s.UserId Asc FOR XML PATH('')),2,200000) 
		Print @ReceiverIds
		Declare @NewStatusText varchar(50), @OldStatusText Varchar(50), @SenderName Varchar(200)

		If @status = 1 Begin Set @NewStatusText = 'Active' End
		Else If @status = 2 Begin Set @NewStatusText = 'Applicant' End
		Else If @status = 3 Begin Set @NewStatusText = 'Deactive' End
		Else If @status = 4 Begin Set @NewStatusText = 'Install Prospect' End
		Else If @status = 5 Begin Set @NewStatusText = 'Interview Date : Applicant' End
		Else If @status = 6 Begin Set @NewStatusText = 'Offer Made: Applicant' End
		Else If @status = 7 Begin Set @NewStatusText = 'Phone Screened' End
		Else If @status = 8 Begin Set @NewStatusText = 'Phone Video Screened' End
		Else If @status = 9 Begin Set @NewStatusText = 'Rejected' End
		Else If @status = 10 Begin Set @NewStatusText = 'Referral Applicant' End
		Else If @status = 11 Begin Set @NewStatusText = 'Deleted' End
		Else If @status = 15 Begin Set @NewStatusText = 'Hidden' End
		Else If @status = 16 Begin Set @NewStatusText = 'Interview Date Expired' End
		Else If @status = 17 Begin Set @NewStatusText = 'Applicant: Aptitude Test' End
		Else If @status = 18 Begin Set @NewStatusText = 'Opportunity Notice: Applicant' End

		If @oldStatus = 1 Begin Set @OldStatusText = 'Active' End
		Else If @oldStatus = 2 Begin Set @OldStatusText = 'Applicant' End
		Else If @oldStatus = 3 Begin Set @OldStatusText = 'Deactive' End
		Else If @oldStatus = 4 Begin Set @OldStatusText = 'Install Prospect' End
		Else If @oldStatus = 5 Begin Set @OldStatusText = 'Interview Date : Applicant' End
		Else If @oldStatus = 6 Begin Set @OldStatusText = 'Offer Made: Applicant' End
		Else If @oldStatus = 7 Begin Set @OldStatusText = 'Phone Screened' End
		Else If @oldStatus = 8 Begin Set @OldStatusText = 'Phone Video Screened' End
		Else If @oldStatus = 9 Begin Set @OldStatusText = 'Rejected' End
		Else If @oldStatus = 10 Begin Set @OldStatusText = 'Referral Applicant' End
		Else If @oldStatus = 11 Begin Set @OldStatusText = 'Deleted' End
		Else If @oldStatus = 15 Begin Set @OldStatusText = 'Hidden' End
		Else If @oldStatus = 16 Begin Set @OldStatusText = 'Interview Date Expired' End
		Else If @oldStatus = 17 Begin Set @OldStatusText = 'Applicant: Aptitude Test' End
		Else If @oldStatus = 18 Begin Set @OldStatusText = 'Opportunity Notice: Applicant' End

		Select @SenderName = UserInstallId +'-'+FristName+' '+LastName From tblINstallUsers Where Id = @RejectedUserId

		Declare @ESTTime DateTime
		Set @ESTTime = CONVERT(datetime, SWITCHOFFSET(GetUTCDate(), DATEPART(TZOFFSET, GetUTCDate() AT TIME ZONE 'Eastern Standard Time')))
		Set @msg = '<span class="auto-entry">Status Changed By '+@SenderName+' - <span style="color:orange;">'+ @OldStatusText+'</span> -> <span style="color:green;">'+@NewStatusText+'</span> Date - '+ Convert(varchar(20), @ESTTime, 101) + right(convert(varchar(32), @ESTTime,100),8) +'(EST)</span>'
		
		Exec SaveChatMessage 1,@ChatGroupId, @RejectedUserId, @msg,null, @ReceiverIds,null,null, @UserChatGroupId, 1

		--Set @Min = @Min + 1
  --  End
END   


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
	GetChatMessages 'C8A93145-106C-4B79-9CD4-6F6C3E586BC8','901,8446',10,780,11645
*/
CREATE PROCEDURE [dbo].[GetChatMessages]
	@ChatGroupId varchar(100),
	@ReceiverIds Varchar(800),
	@ChatSourceId Int = 0,
	@LoggedInUserId int = 780,
	@UserChatGroupId int = 0
AS    
BEGIN
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
					Order By S.CreatedOn Asc
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
					Order By S.CreatedOn Asc
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
						Order By S.CreatedOn Asc
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
						Order By S.CreatedOn Asc
					End
			End
END

GO

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
	GetChatMessagesByUsers @UserId=780, @ReceiverId=8487, @ChatSourceId=6
*/  
Create PROCEDURE [dbo].[GetChatMessagesByUsers]  
	@UserId int,
	@ReceiverId int,
	@ChatSourceId int
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
		Order By S.CreatedOn Asc
End


Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'SetChatMessageReadByChatGroupId' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE SetChatMessageReadByChatGroupId
  END
Go 
 -- =============================================        
-- Author:  Jitendra Pancholi        
-- Create date: 27 Nov 2017     
-- Description: Get a list of top 5 users by starts with name, email   
-- =============================================      
/*  
	SetChatMessageReadByChatGroupId 31, 3797  
*/  
Create PROCEDURE [dbo].[SetChatMessageReadByChatGroupId]  
	@ChatGroupId Varchar(100)  ,
	@ReceiverId int,
	@UserChatGroupId int = 0
AS      
BEGIN
	Declare @ChatMessageId Int
	IF @UserChatGroupId = 0 OR @UserChatGroupId Is NULL
		Begin
			If EXISTS(Select 1 From ChatMessageReadStatus S
				Join ChatMessage M On S.ChatMessageId = M.Id 
			Where M.ChatGroupId = @ChatGroupId  And S.ReceiverId = @ReceiverId And M.UserChatGroupId IS NULL)
				Begin
					
					UPDATE S Set IsRead = 1
					From ChatMessageReadStatus S
						Join ChatMessage M On S.ChatMessageId = M.Id 
					Where M.ChatGroupId = @ChatGroupId  And S.ReceiverId = @ReceiverId And M.UserChatGroupId IS NULL

					Select Convert(Bit, 1) As IsRead,
					(Case when exists 
						(Select top 1 E.Status From EmailStatus E Join tblInstallUsers U on E.ToEmail = U.Email
									Where E.EmailType='Welcome' And U.Id = @ReceiverId Order by E.Id Desc) 
							Then (Select top 1 E.Status From EmailStatus E Join tblInstallUsers U on E.ToEmail = U.Email
									Where E.EmailType='Welcome' And U.Id = @ReceiverId Order by E.Id Desc)
								Else 0 End)
									As WelcomeEmailStatus
				End
			Else
				Begin
					Select Convert(Bit, 0) As IsRead,
					(Case when exists 
						(Select top 1 E.Status From EmailStatus E Join tblInstallUsers U on E.ToEmail = U.Email
									Where E.EmailType='Welcome' And U.Id = @ReceiverId Order by E.Id Desc) 
							Then (Select top 1 E.Status From EmailStatus E Join tblInstallUsers U on E.ToEmail = U.Email
									Where E.EmailType='Welcome' And U.Id = @ReceiverId Order by E.Id Desc)
								Else 0 End)
									As WelcomeEmailStatus
				End
		End
	Else
		Begin
			UPDATE S Set IsRead = 1
			From ChatMessageReadStatus S
			Join ChatMessage M On S.ChatMessageId = M.Id 
			Where M.ChatGroupId = @ChatGroupId  And S.ReceiverId = @ReceiverId And M.UserChatGroupId = @UserChatGroupId

			IF (Select Count(S.IsRead) From ChatMessageReadStatus S
						Join ChatMessage M On S.ChatMessageId = M.Id 
							Where M.ChatGroupId = @ChatGroupId  /*And S.ReceiverId = @ReceiverId */
										And M.UserChatGroupId = @UserChatGroupId)
				= (Select Count(S.IsRead) From ChatMessageReadStatus S
						Join ChatMessage M On S.ChatMessageId = M.Id 
							Where M.ChatGroupId = @ChatGroupId  /*And S.ReceiverId = @ReceiverId */
							And M.UserChatGroupId = @UserChatGroupId And S.IsRead = 1)
				Begin
					Select Convert(Bit, 1) As IsRead,
					(Case when exists 
						(Select top 1 E.Status From EmailStatus E Join tblInstallUsers U on E.ToEmail = U.Email
									Where E.EmailType='Welcome' And U.Id = @ReceiverId Order by E.Id Desc) 
							Then (Select top 1 E.Status From EmailStatus E Join tblInstallUsers U on E.ToEmail = U.Email
									Where E.EmailType='Welcome' And U.Id = @ReceiverId Order by E.Id Desc)
								Else 0 End)
									As WelcomeEmailStatus
				End
			Else
				Begin
					Select Convert(Bit, 0) As IsRead,
						(Case when exists 
						(Select top 1 E.Status From EmailStatus E Join tblInstallUsers U on E.ToEmail = U.Email
									Where E.EmailType='Welcome' And U.Id = @ReceiverId Order by E.Id Desc) 
							Then (Select top 1 E.Status From EmailStatus E Join tblInstallUsers U on E.ToEmail = U.Email
									Where E.EmailType='Welcome' And U.Id = @ReceiverId Order by E.Id Desc)
								Else 0 End)
									As WelcomeEmailStatus
				End
		ENd
	
End
GO

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetUserManagers' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetUserManagers
  END
Go 
 ---- =============================================    
-- Author:  Jitendra Pancholi    
-- Create date: 08/08/2018
-- Description: Load all details of task for edit.    
-- =============================================    
-- [GetUserManagers]  
   
CREATE PROCEDURE [dbo].[GetUserManagers]  
(  
 @UserId int  
)         
AS    
BEGIN  
	If Exists (
		 Select U.Id, U.FristName as FirstName, U.LastName, U.Email From UserManagers M  
		  Join tblInstallUsers U On M.ManagerId = U.Id  
		 Where UserId = @UserId  )
			Begin
				Select U.Id, U.FristName as FirstName, U.LastName, U.Email From UserManagers M  
				  Join tblInstallUsers U On M.ManagerId = U.Id  
				 Where UserId = @UserId
			End
	Else
		Begin
			Select U.Id, U.FristName as FirstName, U.LastName, U.Email 
				From tblInstallUsers U Where U.Id in (780,901)
		End
End

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
	@UserId int,
	@LoggedInUserId int
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
		
		Declare @NewStatusText varchar(50), @OldStatusText Varchar(50), @SenderName Varchar(200)

		If @SecondaryStatus = 1 Begin Set @NewStatusText = 'Applicant Self Reject' End
		Else If @SecondaryStatus = 2 Begin Set @NewStatusText = 'Admin Rejected Applicant: Uncooperative/Unqualified' End
		Else If @SecondaryStatus = 3 Begin Set @NewStatusText = 'Admin Rejected Applicant: Other' End
		Else If @SecondaryStatus = 4 Begin Set @NewStatusText = 'Bad/Wrong Contact Info' End
		Else If @SecondaryStatus = 5 Begin Set @NewStatusText = 'Call Disconnected' End
		Else If @SecondaryStatus = 6 Begin Set @NewStatusText = 'Offer informal Accepte' End
		Else If @SecondaryStatus = 7 Begin Set @NewStatusText = 'Offer Terms Renegotiated' End
		Else If @SecondaryStatus = 8 Begin Set @NewStatusText = 'Applicant Hungup' End
		Else If @SecondaryStatus = 9 Begin Set @NewStatusText = 'Applicant Answered Interested' End
		Else If @SecondaryStatus = 10 Begin Set @NewStatusText = 'AutoEmail Sent' End
		Else If @SecondaryStatus = 11 Begin Set @NewStatusText = 'Rejected Opt Out' End
		Else If @SecondaryStatus = 12 Begin Set @NewStatusText = 'Autoemail Opened' End
		Else If @SecondaryStatus = 13 Begin Set @NewStatusText = 'Autoemailed Loggedin' End
		Else If @SecondaryStatus = 14 Begin Set @NewStatusText = 'Autoemailed Open' End
		Else If @SecondaryStatus = 15 Begin Set @NewStatusText = 'Offer Rejected By Applicant' End
		Else If @SecondaryStatus = 16 Begin Set @NewStatusText = 'Offer Is Open' End
		Else If @SecondaryStatus = 17 Begin Set @NewStatusText = 'Offer Expired' End
		Else If @SecondaryStatus = 18 Begin Set @NewStatusText = 'Call Not Answered' End

		If @oldStatus = 1 Begin Set @OldStatusText = 'Applicant Self Reject' End
		Else If @oldStatus = 2 Begin Set @OldStatusText = 'Admin Rejected Applicant: Uncooperative/Unqualified' End
		Else If @oldStatus = 3 Begin Set @OldStatusText = 'Admin Rejected Applicant: Other' End
		Else If @oldStatus = 4 Begin Set @OldStatusText = 'Bad/Wrong Contact Info' End
		Else If @oldStatus = 5 Begin Set @OldStatusText = 'Call Disconnected' End
		Else If @oldStatus = 6 Begin Set @OldStatusText = 'Offer informal Accepte' End
		Else If @oldStatus = 7 Begin Set @OldStatusText = 'Offer Terms Renegotiated' End
		Else If @oldStatus = 8 Begin Set @OldStatusText = 'Applicant Hungup' End
		Else If @oldStatus = 9 Begin Set @OldStatusText = 'Applicant Answered Interested' End
		Else If @oldStatus = 10 Begin Set @OldStatusText = 'AutoEmail Sent' End
		Else If @oldStatus = 11 Begin Set @OldStatusText = 'Rejected Opt Out' End
		Else If @oldStatus = 12 Begin Set @OldStatusText = 'Autoemail Opened' End
		Else If @oldStatus = 13 Begin Set @OldStatusText = 'Autoemailed Loggedin' End
		Else If @oldStatus = 14 Begin Set @OldStatusText = 'Autoemailed Open' End
		Else If @oldStatus = 15 Begin Set @OldStatusText = 'Offer Rejected By Applicant' End
		Else If @oldStatus = 16 Begin Set @NewStatusText = 'Offer Is Open' End
		Else If @oldStatus = 17 Begin Set @NewStatusText = 'Offer Expired' End
		Else If @oldStatus = 18 Begin Set @NewStatusText = 'Call Not Answered' End

		Select @SenderName = IsNULL(FristName,'')+' '+IsNULL(LastName,'') +'-'+IsNULL(UserInstallId,'') From tblINstallUsers Where Id = 1537
		Declare @ESTTime DateTime
		Set @ESTTime = CONVERT(datetime, SWITCHOFFSET(GetUTCDate(), DATEPART(TZOFFSET, GetUTCDate() AT TIME ZONE 'Eastern Standard Time')))
	
		IF ISNULL(@OldStatusText,'') = ''
			Begin
				Set @msg = '<span class="auto-entry">Secondary Status Changed By '+@SenderName+' to <span style="color:green;">'+@NewStatusText+'</span> Date - '+ Convert(varchar(20), @ESTTime, 101) + right(convert(varchar(32), @ESTTime,100),8) +'(EST)</span>'
			End
		Else
			Begin
				Set @msg = '<span class="auto-entry">Secondary Status Changed By '+@SenderName+' - <span style="color:orange;">'+ @OldStatusText+'</span> -> <span style="color:green;">'+@NewStatusText+'</span> Date - '+ Convert(varchar(20), @ESTTime, 101) + right(convert(varchar(32), @ESTTime,100),8) +'(EST)</span>'
			End
		Exec SaveChatMessage 1, @ChatGroupId, @LoggedInUserId, @msg,null, @ReceiverIds,null,null, @UserChatGroupId, 0

		Update tblInstallUsers Set SecondaryStatus = @SecondaryStatus Where Id = @UserId
	End

End


Go
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
	
	Declare @ChatGroupId Varchar(100) = null, @UserChatGroupId int, @ReceiverIds Varchar(800)
	
	Select top 1 @ChatGroupId = S.ChatGroupId, @UserChatGroupId = S.UserChatGroupId
			From ChatMessage S With(NoLock)
			Where ((S.SenderId = @userID And ',' + S.ReceiverIds + ',' like '%,' + Convert(Varchar(12), @loginUserID) + ',%')
				Or (S.SenderId = @loginUserID And ',' + S.ReceiverIds + ',' like  '%,' + Convert(Varchar(12), @userID)+ ',%')) 
			 And S.UserChatGroupId IS Not NULL And S.TaskId IS NULL
			Order by S.Id Asc

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


	Exec SaveChatMessage  @TouchPointSource, @ChatGroupId, @loginUserID, @changeLog, null, @ReceiverIds,null,null, @UserChatGroupId, 0

	Select IDENT_CURRENT('ChatMessage') as UserTouchPointLogID
END


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
-- GetChatParametersByUser 3696, 3797, null, null
 
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
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetTaskIdByTaskSequence' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetTaskIdByTaskSequence
  END
Go 
 ---- =============================================  
-- Author:  Jitendra Pancholi  
-- Create date: 08/14/2018
-- Description: Load all details of task for edit.  
-- =============================================  
-- GetTaskIdByTaskSequence 8446, 780, null, null
 
CREATE PROCEDURE [dbo].[GetTaskIdByTaskSequence]   
(
	@AssignedSeqID bigint
)     
AS  
BEGIN
	Select S.TaskId From tblAssignedSequencing S Where S.Id = @AssignedSeqID 
End


Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'usp_UpdateUserLoginTimeStamp' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE usp_UpdateUserLoginTimeStamp
  END
Go 
-- =============================================      
-- Author:  Yogesh      
-- Create date: 27 Jan 2018     
-- Description: Enter User Last Login Time Stamp  
-- Modified by: Jitendra Pancholi
-- =============================================      
CREATE PROCEDURE [dbo].[usp_UpdateUserLoginTimeStamp]     
(  
	 @Id INT,  
	 @LastLoginTimeStamp DATETIME  
)  
AS    
BEGIN    
	UPDATE tblInstallUsers 
		SET [LastLoginTimeStamp] = 
			CONVERT(datetime, SWITCHOFFSET(GetUTCDate(), DATEPART(TZOFFSET, GetUTCDate() AT TIME ZONE 'Eastern Standard Time')))
		WHERE Id = @Id

	Declare @PrimaryStatus int
	Select @PrimaryStatus = Status from tblInstallUsers Where Id = @Id
	-- Log activity into HR group chat
	If @PrimaryStatus != 1
		Begin
			Declare @ChatGroupId Varchar(100) = null, @UserChatGroupId int, @ReceiverIds Varchar(800)
	
			Select top 1 @ChatGroupId = S.ChatGroupId, @UserChatGroupId = S.UserChatGroupId
					From ChatMessage S With(NoLock)
					Where (((S.SenderId = 780 OR S.SenderId = 901) And ',' + S.ReceiverIds + ',' like '%,' + Convert(Varchar(12), @Id) + ',%')
						Or (S.SenderId = @Id And ',' + S.ReceiverIds + ',' like  '%,' + Convert(Varchar(12), 780,901)+ ',%')) 
					 And S.UserChatGroupId IS Not NULL And S.TaskId IS NULL
					Order by S.Id Asc

			IF ISNULL(@ChatGroupId,'') = ''
			begin
				Select @ChatGroupId = NEWID ()  
			end
			IF @UserChatGroupId IS NULL
			begin
				Insert Into UserChatGroup (CreatedBy) Values(@Id)
				Set @UserChatGroupId = IDENT_CURRENT('UserChatGroup')

				IF OBJECT_ID('tempdb..#TempUsers') IS NOT NULL DROP TABLE #TempUsers   
				Create Table #TempUsers(UserId int, UserChatGroupId int)
				Insert Into #TempUsers Values(780, @UserChatGroupId)
				Insert Into #TempUsers Values(901, @UserChatGroupId)
				Insert Into #TempUsers Values(@Id, @UserChatGroupId)

				Insert Into UserChatGroupMember (UserChatGroupId, UserId)
					Select Distinct UserChatGroupId, UserId From #TempUsers
			end

			SELECT @ReceiverIds = SUBSTRING((SELECT ',' + Convert(Varchar(10), s.UserId) FROM UserChatGroupMember s 
				Where s.UserChatGroupId = @UserChatGroupId
				ORDER BY s.UserId Asc FOR XML PATH('')),2,200000) 

			Declare @msg varchar(800), @UserNameWithInstallId Varchar(200)
			Select @UserNameWithInstallId = IsNull(FristName,'') + ' ' + IsNull(LastName,'') + '-' + IsNull(UserInstallId,''),
					@LastLoginTimeStamp = LastLoginTimeStamp
					from tblInstallUsers Where Id = @Id
			Set @msg = '<span class="auto-entry">' + @UserNameWithInstallId + ' logged in at - ' + Convert(varchar(20), @LastLoginTimeStamp, 101) + right(convert(varchar(32),@LastLoginTimeStamp,100),8) + ' (EST)</span>'
			Exec SaveChatMessage  1, @ChatGroupId, @Id, @msg, null, @ReceiverIds,null,null, @UserChatGroupId, 0
		End
END    
GO

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'AddHRChatMessage' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE AddHRChatMessage
  END
Go 
-- =============================================      
-- Author:  Yogesh      
-- Create date: 27 Jan 2018     
-- Description: Enter User Last Login Time Stamp  
-- Modified by: Jitendra Pancholi
/*

	AddHRChatMessage 8524, 'User successfully accepted tech task',20146

*/
-- =============================================      
CREATE PROCEDURE [dbo].[AddHRChatMessage]     
(  
	 @Id INT,
	 @Message Varchar(2000),
	 @EmailStatusId BigInt = null
)  
AS    
BEGIN    
	-- Log activity into HR group chat
	Declare @ChatGroupId Varchar(100) = null, @UserChatGroupId int, @ReceiverIds Varchar(800)
	
	Select top 1 @ChatGroupId = S.ChatGroupId, @UserChatGroupId = S.UserChatGroupId
			From ChatMessage S With(NoLock)
			Where ((S.SenderId = 780 And ',' + S.ReceiverIds + ',' like '%,' + Convert(Varchar(12), @Id) + ',%')
				Or (S.SenderId = @Id And ',' + S.ReceiverIds + ',' like  '%,' + Convert(Varchar(12), 780)+ ',%')) 
			 And S.UserChatGroupId IS Not NULL And S.TaskId IS NULL
			Order by S.Id Asc

	IF ISNULL(@ChatGroupId,'') = ''
	begin
		Select @ChatGroupId = NEWID ()  
	end
	IF @UserChatGroupId IS NULL
	begin
		Insert Into UserChatGroup (CreatedBy) Values(@Id)
		Set @UserChatGroupId = IDENT_CURRENT('UserChatGroup')

		IF OBJECT_ID('tempdb..#TempUsers') IS NOT NULL DROP TABLE #TempUsers   
		Create Table #TempUsers(UserId int, UserChatGroupId int)
		Insert Into #TempUsers Values(780, @UserChatGroupId)
		Insert Into #TempUsers Values(901, @UserChatGroupId)
		Insert Into #TempUsers Values(@Id, @UserChatGroupId)

		Insert Into UserChatGroupMember (UserChatGroupId, UserId)
			Select Distinct UserChatGroupId, UserId From #TempUsers
	end

	SELECT @ReceiverIds = SUBSTRING((SELECT ',' + Convert(Varchar(10), s.UserId) FROM UserChatGroupMember s 
		Where S.UserChatGroupId = @UserChatGroupId
		ORDER BY s.UserId Asc FOR XML PATH('')),2,200000) 

	Declare @UserNameWithInstallId Varchar(200), @LastLoginTimeStamp DateTime
	Set @LastLoginTimeStamp = CONVERT(datetime, SWITCHOFFSET(GetUTCDate(), DATEPART(TZOFFSET, GetUTCDate() AT TIME ZONE 'Eastern Standard Time')))
	
	Select @UserNameWithInstallId = IsNull(FristName,'') + ' ' + IsNull(LastName,'') + '-' + IsNull(UserInstallId,''),
			@LastLoginTimeStamp = LastLoginTimeStamp
			from tblInstallUsers Where Id = @Id
	
	Exec SaveChatMessage  1, @ChatGroupId, @Id, @Message, null, @ReceiverIds,null,null, @UserChatGroupId, 0, @EmailStatusId

END    



/******************************/
Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'SP_InsertPerfomace' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE SP_InsertPerfomace
  END
Go 
-- =============================================        
-- Author: Yogesh Keraliya        
-- Create date: 05262017        
-- Description: Update users exam performance.        
-- =============================================        
CREATE PROCEDURE [dbo].[SP_InsertPerfomace]         
 (  
 -- Add the parameters for the stored procedure here        
	@installUserID varchar(20),         
	@examID int = 0        
	,@marksEarned int  
)  
AS        
BEGIN        
	-- SET NOCOUNT ON added to prevent extra result sets from        
	-- interfering with SELECT statements.        
	SET NOCOUNT ON;        
      
	DECLARE @totalMarks INT        
	DECLARE @Aggregate REAL        
	DECLARE @PassPercentage REAL      
          
	DECLARE @ExamPerformanceStatus INT        
  
	-- Get total marks for exam.  
	SELECT @totalMarks = SUM(PositiveMarks) FROM MCQ_Question WHERE ExamID = @examID      
   
	-- User obtained percentage.  
	SET @Aggregate = (CONVERT(REAL,@marksEarned) / CONVERT(REAL,@totalMarks)) * 100 
   
	-- Get total pass percentage for exam.      
	SELECT @PassPercentage = [PassPercentage] FROM MCQ_Exam WHERE [ExamID] = @examID      
   
  
	-- Add user pass and fail result.      
	IF(@PassPercentage < @Aggregate)      
		BEGIN
			SET @ExamPerformanceStatus = 1      
		END      
	ELSE      
		BEGIN
			SET @ExamPerformanceStatus = 0
		END
       
	-- Insert user exam result  
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
	
	Declare @msg varchar(800), @UserNameWithInstallId varchar(500), @TestName Varchar(800), @TimeStamp DateTime
	
	Select @UserNameWithInstallId = IsNull(FristName,'') + ' ' + IsNull(LastName,'') + '-' + IsNull(UserInstallId,'')
			from tblInstallUsers Where Id = @installUserID
	Select @TestName = ExamTitle From MCQ_Exam Where ExamId = @examID
	Select * From MCQ_Performance

	Set @TimeStamp = CONVERT(datetime, SWITCHOFFSET(GetUTCDate(), DATEPART(TZOFFSET, GetUTCDate() AT TIME ZONE 'Eastern Standard Time')))

	Set @msg = '<span class="auto-entry">' + @UserNameWithInstallId + ' completed the test ' + @TestName + ' with ' + Convert(Varchar(12), @Aggregate) + '% scroe on - ' + Convert(varchar(20), @TimeStamp, 101) + right(convert(varchar(32),@TimeStamp,100),8) + ' (EST)</span>'
	
	Exec AddHRChatMessage @Id=@installUserID, @Message=@msg
END        
  

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'AddMemberToChatGroup' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE AddMemberToChatGroup
  END
Go 
 ---- =============================================  
-- Author:  Jitendra Pancholi  
-- Create date: 03/30/2018
-- Description: Load all details of task for edit.  
-- =============================================  
-- AddMemberToChatGroup '',3697,3797,'901',null
 
CREATE PROCEDURE [dbo].[AddMemberToChatGroup]   
(  
	@ChatGroupId varchar(200),
	@UserId int,
	@LoggedInUserId Int,
	@ExistingUsers Varchar(800),
	@UserChatGroupId int = null
)     
AS  
BEGIN
	/*

		ChatGroupType = 1 (Normal Group Chat)

	*/
	If IsNull(@UserChatGroupId,0) = 0
	Begin
		Insert Into UserChatGroup (CreatedBy, ChatGroupType) Values(@LoggedInUserId, 1)
		Set @UserChatGroupId = IDENT_CURRENT('UserChatGroup') 
		Insert Into UserChatGroupMember (UserChatGroupId, UserId)
		Select @UserChatGroupId, Result From dbo.CSVtoTable(@ExistingUsers,',')

		Insert Into UserChatGroupMember (UserChatGroupId, UserId) values(@UserChatGroupId,@LoggedInUserId)
	End

	Insert Into UserChatGroupMember (UserChatGroupId, UserId) values (@UserChatGroupId, @UserId)

	Select @UserChatGroupId As UserChatGroupId
End

Go
IF OBJECT_ID('dbo.ChatGroupUserImagesByChatGroupId') IS NOT NULL
  DROP FUNCTION ChatGroupUserImagesByChatGroupId
GO

/*
	Select dbo.ChatGroupUserImagesByChatGroupId (9634)
	select * from UserChatGroupMember Where UserChatGroupId=9634
*/

CREATE FUNCTION [dbo].[ChatGroupUserImagesByChatGroupId] 
(
	@UserChatGroupId INT
)
RETURNS NVARCHAR(max)
	AS
BEGIN
	Declare @ChatGroupUserImages Varchar(Max)

	Select @ChatGroupUserImages = SubString((Select '^' + (Case When G.CreatedBy = M.UserId Then '1@' Else '0@' End) + U.Picture
	From UserChatGroupMember M
		Join tblInstallUsers U On M.UserId = U.Id
		Join UserChatGroup G on G.Id = M.UserChatGroupId
		Where M.UserChatGroupId = @UserChatGroupId
		Order by U.Picture Asc
		FOR XML PATH('')),2,8000)

	RETURN ISNULL(@ChatGroupUserImages,'')
END 
GO



Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'UDP_UpdateInstallUsers' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE UDP_UpdateInstallUsers
  END
Go 



-- ===================================================================================  
-- Author:    
-- Create date:  
-- Update By : Bhavik J . Vaishnani On 30-12-2016
--				Script Date: 12/30/2016
-- Updated By : Nand Chavan 
--                  Update SourceID (Task ID#: REC001-XIII)
-- Description: Update install user record.
-- ===================================================================================  
CREATE PROCEDURE [dbo].[UDP_UpdateInstallUsers]  
	@id int,  
	@FristName varchar(50),  
	@LastName varchar(50),  
	@Email varchar(100),  
	@phone varchar(50),  
	@Address varchar(20),  
	@Zip varchar(10),  
	@State varchar(30),  
	@City varchar(30),  
	@password varchar(30),
	@designation varchar(30),
	@status varchar(30),
	@Picture varchar(max),  
	@attachement varchar(max),
	@bussinessname varchar(100),
	@ssn varchar(20),
	@ssn1 varchar(20),
	@ssn2 varchar(20),
	@signature varchar(25),
	@dob varchar(20),  
	@citizenship varchar(50),
	@ein1 varchar(20),
	@ein2 varchar(20), 
	@a varchar(20),
	@b varchar(20),
	@c varchar(20),
	@d varchar(20),
	@e varchar(20),
	@f varchar(20),
	@g varchar(20),
	@h varchar(20),
	@i varchar(20),
	@j varchar(20),
	@k varchar(20),
	@maritalstatus varchar(20),
	@PrimeryTradeId int = 0,
	@SecondoryTradeId int = 0,
	@Source	varchar(MAX)='',
	@Notes	varchar(MAX)='',
	@StatusReason varchar(MAX)='',
	@GeneralLiability	varchar(MAX) = '',
	@PCLiscense	varchar(MAX) = '',
	@WorkerComp	varchar(MAX) = '',
	@HireDate varchar(50) = '',
	@TerminitionDate varchar(50) = '',
	@WorkersCompCode varchar(20) = '',
	@NextReviewDate	varchar(50) = '',
	@EmpType varchar(50) = '',
	@LastReviewDate	varchar(50) = '',
	@PayRates varchar(50) = '',
	@ExtraEarning varchar(MAX) = '',
	@ExtraEarningAmt varchar(MAX) = 0,
	@PayMethod varchar(50) = '',
	@Deduction VARCHAR(MAX) = 0,
	@DeductionType varchar(50) = '',
	@AbaAccountNo varchar(50) = '',
	@AccountNo varchar(50) = '',
	@AccountType varchar(50) = '',
	@PTradeOthers varchar(100) = '',
	@STradeOthers varchar(100) = '',
	@DeductionReason varchar(MAX) = '',
	@SuiteAptRoom varchar(10) = '',
	@FullTimePosition int = 0,
	@ContractorsBuilderOwner VARCHAR(500) = '',
	@MajorTools VARCHAR(250) = '',
	@DrugTest bit = null,
	@ValidLicense bit = null,
	@TruckTools bit = null,
	@PrevApply bit = null,
	@LicenseStatus bit = null,
	@CrimeStatus bit = null,
	@StartDate VARCHAR(50) = '',
	@SalaryReq VARCHAR(50) = '',
	@Avialability VARCHAR(50) = '',
	@ResumePath VARCHAR(MAX) = '',
	@skillassessmentstatus bit = null,
	@assessmentPath VARCHAR(MAX) = '',
	@WarrentyPolicy  VARCHAR(50) = '',
	@CirtificationTraining VARCHAR(MAX) = '',
	@businessYrs decimal = 0,
	@underPresentComp decimal = 0,
	@websiteaddress VARCHAR(MAX) = '',
	@PersonName VARCHAR(MAX) = '',
	@PersonType VARCHAR(MAX) = '',
	@CompanyPrinciple VARCHAR(MAX) = '',
	@UserType VARCHAR(25) = '',
	@Email2	varchar(70)	= '',
	@Phone2	varchar(70)	= '',
	@CompanyName	varchar(100) = '',
	@SourceUser	varchar(10)	= '',
	@DateSourced	varchar(50)	= '',
	@InstallerType VARCHAR(20) = '',
	@BusinessType varchar(50) = '',
	@CEO varchar(100) = '',
	@LegalOfficer	varchar(100) = '',
	@President	varchar(100) = '',
	@Owner	varchar(100) = '',
	@AllParteners	varchar(MAX) = '',
	@MailingAddress	varchar(100) = '',
	@Warrantyguarantee	bit = null,
	@WarrantyYrs	int = 0,
	@MinorityBussiness	bit = null,
	@WomensEnterprise	bit = null,
	@InterviewTime varchar(20) ='',
	@LIBC VARCHAR(5) = '',
	@Flag int = 0,

	@CruntEmployement bit = null,
	@CurrentEmoPlace varchar(100) = '',
	@LeavingReason varchar(MAX) = '',
	@CompLit bit = null,
	@FELONY	bit = null,
	@shortterm	varchar(250) = '',
	@LongTerm	varchar(250) = '',
	@BestCandidate	varchar(MAX) = '',
	@TalentVenue	varchar(MAX) = '',
	@Boardsites	varchar(300) = '',
	@NonTraditional	varchar(MAX) = '',
	@ConSalTraning	varchar(100) = '',
	@BestTradeOne	varchar(50) = '',
	@BestTradeTwo	varchar(50) = '',
	@BestTradeThree	varchar(50) = '',

	@aOne	varchar(50)	= '',
	@aOneTwo	varchar(50)	= '',
	@bOne	varchar(50)	= '',
	@cOne	varchar(50)	= '',
	@aTwo	varchar(50)	= '',
	@aTwoTwo	varchar(50)	= '',
	@bTwo	varchar(50)	= '',
	@cTwo	varchar(50)	= '',
	@aThree	varchar(50)	= '',
	@aThreeTwo	varchar(50)	= '',
	@bThree	varchar(50)	= '',
	@cThree	varchar(50)	= '',
	@RejectionDate	varchar(50)	='',
	@RejectionTime	varchar(50)	='',
	@RejectedUserId  int = 0,
	@TC bit = null,
	@ExtraIncomeType varchar(MAX) = '',
	@PositionAppliedFor varchar(50) = '',
	@PhoneISDCode VARCHAR(10),
	@PhoneExtNo VARCHAR(30),
	@AddedBy int = 0,
	@DesignationID int=0,
	@CountryCode VARCHAR(15),
	@NameMiddleInitial VARCHAR (5) ,
	@IsEmailPrimaryEmail BIT ,
	@IsPhonePrimaryPhone BIT ,
	@IsEmailContactPreference BIT ,
	@IsCallContactPreference BIT ,
	@IsTextContactPreference BIT ,
	@IsMailContactPreference BIT ,
	@SourceID	INT = 0,
	@loggedInUserId int,
	@result int output  
AS 
BEGIN  
	Declare @OldStatus varchar(20), @NewStatus varchar(20)

	Select @OldStatus = Status From tblInstallUsers Where Id = @id
	Set @NewStatus = @status

	IF(Select ID FROM tblInstallUsers WHERE Id=@id) IS NOT NULL
	BEGIN
		UPDATE tblInstallUsers 
		SET 
		FristName=@FristName,LastName=@LastName,Email=@Email,Phone=@phone,[Address]=@Address,Zip=@Zip,
		[State]=@State,City=@City,[Password]=@password,Designation=@designation,
		/*[Status]=@status,*/
		Picture=@Picture,Attachements=@attachement,Bussinessname=@bussinessname,SSN=@ssn,SSN1=@ssn1,SSN2=@ssn2,[Signature]=@signature,DOB=@dob,
		Citizenship=@citizenship,EIN1=@ein1,EIN2=@ein2,A=@a,B=@b,C=@c,D=@d,E=@e,F=@f,G=@g,H=@h,[5]=@i,[6]=@j,[7]=@k,
		maritalstatus=@maritalstatus,
		PrimeryTradeId=@PrimeryTradeId,
		SecondoryTradeId=@SecondoryTradeId,
		[Source] = @Source,
		Notes = @Notes,
		/*StatusReason = @StatusReason,*/
		GeneralLiability = @GeneralLiability,
		PCLiscense = @PCLiscense,
		WorkerComp = @WorkerComp,
		HireDate = @HireDate,
		TerminitionDate = @TerminitionDate,
		WorkersCompCode = @WorkersCompCode,
		NextReviewDate = @NextReviewDate,
		EmpType = @EmpType,
		LastReviewDate = @LastReviewDate,
		PayRates = @PayRates,
		ExtraEarning = @ExtraEarning,
		ExtraEarningAmt = @ExtraEarningAmt,
		PayMethod = @PayMethod,
		Deduction = @Deduction,
		AbaAccountNo = @AbaAccountNo ,
		AccountNo = @AccountNo,
		AccountType = @AccountType,
		DeductionType = @DeductionType,
		PTradeOthers = @PTradeOthers,
		STradeOthers = @STradeOthers,
		DeductionReason = @DeductionReason,
		SuiteAptRoom = @SuiteAptRoom,
		FullTimePosition = @FullTimePosition
		,ContractorsBuilderOwner = @ContractorsBuilderOwner
		,MajorTools = @MajorTools
		,DrugTest = @DrugTest
		,ValidLicense = @ValidLicense
		,TruckTools = @TruckTools
		,PrevApply = @PrevApply
		,LicenseStatus = @LicenseStatus
		,CrimeStatus = @CrimeStatus
		,StartDate = @StartDate
		,SalaryReq = @SalaryReq
		,Avialability = @Avialability
		,ResumePath = @ResumePath
		,skillassessmentstatus = @skillassessmentstatus
		,assessmentPath = @assessmentPath
		,WarrentyPolicy = @WarrentyPolicy
		,CirtificationTraining = @CirtificationTraining
		,businessYrs = @businessYrs
		,underPresentComp = @underPresentComp
		,websiteaddress = @websiteaddress
		,PersonName = @PersonName
		,PersonType = @PersonType
		,CompanyPrinciple = @CompanyPrinciple
		,UserType = @UserType
		,Email2 = @Email2
		,Phone2 = @Phone2
		,CompanyName = @CompanyName
		,SourceUser = @SourceUser
		,DateSourced = @DateSourced
		,InstallerType = @InstallerType
		,BusinessType = @BusinessType
		,CEO = @CEO
		,LegalOfficer = @LegalOfficer
		,President = @President
		,[Owner] = @Owner
		,AllParteners = @AllParteners
		,MailingAddress = @MailingAddress
		,Warrantyguarantee = @Warrantyguarantee
		,WarrantyYrs = @WarrantyYrs
		,MinorityBussiness = @MinorityBussiness
		,WomensEnterprise = @WomensEnterprise
		,InterviewTime = @InterviewTime 
		,LIBC = @LIBC
		,CruntEmployement = @CruntEmployement,
		CurrentEmoPlace = @CurrentEmoPlace,
		LeavingReason = @LeavingReason,
		CompLit = @CompLit,
		FELONY = @FELONY,
		shortterm = @shortterm,
		LongTerm = @LongTerm,
		BestCandidate = @BestCandidate,
		TalentVenue = @TalentVenue,
		Boardsites = @Boardsites,
		NonTraditional = @NonTraditional,
		ConSalTraning = @ConSalTraning,
		BestTradeOne =  @BestTradeOne,
		BestTradeTwo = @BestTradeTwo,
		BestTradeThree = @BestTradeThree,

		aOne = @aOne,aOneTwo = @aOneTwo,bOne = @bOne,cOne = @cOne,aTwo = @aTwo,aTwoTwo = @aTwoTwo,bTwo = @bTwo,cTwo = @cTwo,aThree = @aThree,aThreeTwo = @aThreeTwo,
		bThree = @bThree,cThree = @cThree,

		RejectionDate = @RejectionDate,RejectionTime = @RejectionTime,RejectedUserId = @RejectedUserId,
		TC = @TC,ExtraIncomeType = @ExtraIncomeType,
		PositionAppliedFor = @PositionAppliedFor,
		DesignationID=@DesignationID
		,PhoneISDCode = @PhoneISDCode
        ,PhoneExtNo = @PhoneExtNo
		, CountryCode = @CountryCode
		, NameMiddleInitial = @NameMiddleInitial 
		, IsEmailPrimaryEmail =@IsEmailPrimaryEmail
		, IsPhonePrimaryPhone = @IsPhonePrimaryPhone 
		, IsEmailContactPreference = @IsEmailContactPreference 
		, IsCallContactPreference = @IsCallContactPreference 
		, IsTextContactPreference = @IsTextContactPreference 
		, IsMailContactPreference = @IsMailContactPreference,
		  SourceID = @SourceID
		WHERE 
			Id=@id  

		IF @Flag <> 0
		BEGIN
			INSERT INTO [tblInstalledReport]([SourceId],[InstallerId],[Status])
			VALUES(Cast(@SourceUser as int),@id,@status)
		END

		IF @status = 'InterviewDate' OR @status = 'Interview Date'
		BEGIN
			--UPDATE tbl_AnnualEvents SET EventDate=@StatusReason where ApplicantId=@id
			INSERT tbl_AnnualEvents (EventName,EventDate,EventAddedBy,ApplicantId)values('InterViewDetails',@StatusReason,@AddedBy,@id)		
		END

		SET @result ='1'  

	END
	ELSE
	BEGIN         
		SET @result ='0'        
	END  
		
	If @OldStatus != @NewStatus
		Begin
			 Exec UDP_ChangeStatus @Id=@Id, @Status = @NewStatus, @RejectedUserId = @loggedInUserId, @StatusReason = @StatusReason
		End

	RETURN @result  
 END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE [name] = N'AfterUpdateTblInstallUsers' AND [type] = 'TR')
BEGIN
      DROP TRIGGER AfterUpdateTblInstallUsers
END
Go
CREATE TRIGGER [dbo].AfterUpdateTblInstallUsers
ON [dbo].tblInstallUsers  
FOR  UPDATE
AS 
Begin
	-- Set UserInstallId if not set yet.
	Declare @UserInstallId Varchar(50), @DesignationCode varchar(10), @DesignationId int, @UserId int
	Select @UserId = i.Id From INSERTED i

	Select @UserInstallId = UserInstallId, @DesignationId = DesignationId From tblInstallUsers Where Id = @UserId
	Select @DesignationCode = DesignationCode From tbl_Designation Where Id = @DesignationId

	IF ISNULL(@UserInstallId,'') = '' AND @DesignationId > 0
		Begin
			Exec USP_SetUserDisplayID @InstallUserID = @UserId, @DesignationsCode = @DesignationCode, @UpdateCurrentSequence = 'YES'
		End
End

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'UDP_UpdateStatus' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE UDP_UpdateStatus
  END
Go 
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UDP_UpdateStatus] 
	@id int,  
	@status varchar(30),
	@loggedInUserId int,
	@result int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Declare @oldStatus int
	Select @oldStatus = Status From [tblInstallUsers] WHERE Id = @Id  

    -- Insert statements for procedure here
	update tblInstallUsers 
	set [Status] = @status
	WHERE Id=@id  
	Set @result ='1'  
       Begin         
          Set @result ='0'        
       end  
        return @result  



	 -- Make entry in chat for this status change.
 Declare @ChatGroupId Varchar(200), @UserChatGroupId int, @ReceiverIds Varchar(800), @msg varchar(800)

 --IF OBJECT_ID('tempdb..#TempUserIds') IS NOT NULL DROP TABLE #TempUserIds
	--Create Table #TempUserIds(Id int identity(1,1), UserId int)
	--Insert Into #TempUserIds(UserId)
	--	select Item from dbo.SplitString(@UserIds,',')

	Declare @Min int =1, @Max int = 1, @ReceiverUserId int
	--Select @Min =Min(Id), @Max = Max(Id) From #TempUserIds
	
--While @Min <= @Max
--	Begin
		--Select @ReceiverUserId = UserId From #TempUserIds Where Id = @Min

		Select top 1 @ChatGroupId = S.ChatGroupId, @UserChatGroupId = S.UserChatGroupId
			From ChatMessage S With(NoLock)
			Where ((S.SenderId = @Id And ',' + S.ReceiverIds + ',' like '%,' + Convert(Varchar(12), @loggedInUserId) + ',%')
				Or (S.SenderId = @loggedInUserId And ',' + S.ReceiverIds + ',' like  '%,' + Convert(Varchar(12), @Id)+ ',%')) 
			 And S.UserChatGroupId IS Not NULL And S.TaskId IS NULL
			Order by S.Id Asc
		IF ISNULL(@ChatGroupId,'') = ''
			Begin
				Set @ChatGroupId = NEWID()
			End
		If IsNull(@UserChatGroupId,0) = 0
			Begin
				Insert Into UserChatGroup (CreatedBy) Values(@Id)
				Set @UserChatGroupId = IDENT_CURRENT('UserChatGroup') 
		
				Insert Into UserChatGroupMember (UserChatGroupId, UserId) Values(@UserChatGroupId, 780)
				Insert Into UserChatGroupMember (UserChatGroupId, UserId) Values(@UserChatGroupId, 901)
				Insert Into UserChatGroupMember (UserChatGroupId, UserId) Values(@UserChatGroupId, @Id)
				If Not exists (Select 1 From UserChatGroupMember Where UserChatGroupId = @UserChatGroupId And UserId = @loggedInUserId)
					begin
						Insert Into UserChatGroupMember (UserChatGroupId, UserId) Values(@UserChatGroupId, @loggedInUserId)
					end
			End
		Print @ChatGroupId
		Print @UserChatGroupId
		Print @ReceiverIds

		SELECT @ReceiverIds = SUBSTRING((SELECT ',' + Convert(Varchar(12), s.UserId) FROM UserChatGroupMember s 
			Where UserChatGroupId = @UserChatGroupId And UserId not in (@loggedInUserId)
			ORDER BY s.UserId Asc FOR XML PATH('')),2,200000) 
		Print @ReceiverIds
		Declare @NewStatusText varchar(50), @OldStatusText Varchar(50), @SenderName Varchar(200)

		If @status = 1 Begin Set @NewStatusText = 'Active' End
		Else If @status = 2 Begin Set @NewStatusText = 'Applicant' End
		Else If @status = 3 Begin Set @NewStatusText = 'Deactive' End
		Else If @status = 4 Begin Set @NewStatusText = 'Install Prospect' End
		Else If @status = 5 Begin Set @NewStatusText = 'Interview Date : Applicant' End
		Else If @status = 6 Begin Set @NewStatusText = 'Offer Made: Applicant' End
		Else If @status = 7 Begin Set @NewStatusText = 'Phone Screened' End
		Else If @status = 8 Begin Set @NewStatusText = 'Phone Video Screened' End
		Else If @status = 9 Begin Set @NewStatusText = 'Rejected' End
		Else If @status = 10 Begin Set @NewStatusText = 'Referral Applicant' End
		Else If @status = 11 Begin Set @NewStatusText = 'Deleted' End
		Else If @status = 15 Begin Set @NewStatusText = 'Hidden' End
		Else If @status = 16 Begin Set @NewStatusText = 'Interview Date Expired' End
		Else If @status = 17 Begin Set @NewStatusText = 'Applicant: Aptitude Test' End
		Else If @status = 18 Begin Set @NewStatusText = 'Opportunity Notice: Applicant' End

		If @oldStatus = 1 Begin Set @OldStatusText = 'Active' End
		Else If @oldStatus = 2 Begin Set @OldStatusText = 'Applicant' End
		Else If @oldStatus = 3 Begin Set @OldStatusText = 'Deactive' End
		Else If @oldStatus = 4 Begin Set @OldStatusText = 'Install Prospect' End
		Else If @oldStatus = 5 Begin Set @OldStatusText = 'Interview Date : Applicant' End
		Else If @oldStatus = 6 Begin Set @OldStatusText = 'Offer Made: Applicant' End
		Else If @oldStatus = 7 Begin Set @OldStatusText = 'Phone Screened' End
		Else If @oldStatus = 8 Begin Set @OldStatusText = 'Phone Video Screened' End
		Else If @oldStatus = 9 Begin Set @OldStatusText = 'Rejected' End
		Else If @oldStatus = 10 Begin Set @OldStatusText = 'Referral Applicant' End
		Else If @oldStatus = 11 Begin Set @OldStatusText = 'Deleted' End
		Else If @oldStatus = 15 Begin Set @OldStatusText = 'Hidden' End
		Else If @oldStatus = 16 Begin Set @OldStatusText = 'Interview Date Expired' End
		Else If @oldStatus = 17 Begin Set @OldStatusText = 'Applicant: Aptitude Test' End
		Else If @oldStatus = 18 Begin Set @OldStatusText = 'Opportunity Notice: Applicant' End

		Select @SenderName = UserInstallId +'-'+FristName+' '+LastName From tblINstallUsers Where Id = @loggedInUserId

		Declare @ESTTime DateTime
		Set @ESTTime = CONVERT(datetime, SWITCHOFFSET(GetUTCDate(), DATEPART(TZOFFSET, GetUTCDate() AT TIME ZONE 'Eastern Standard Time')))
		Set @msg = '<span class="auto-entry">Status Changed By '+@SenderName+' - <span style="color:orange;">'+ @OldStatusText+'</span> -> <span style="color:green;">'+@NewStatusText+'</span> Date - '+ Convert(varchar(20), @ESTTime, 101) + right(convert(varchar(32), @ESTTime,100),8) +'(EST)</span>'
		
		Exec SaveChatMessage 1,@ChatGroupId, @loggedInUserId, @msg,null, @ReceiverIds,null,null, @UserChatGroupId, 1

END


Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetAllActiveDesignation' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetAllActiveDesignation
  END
Go 
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE GetAllActiveDesignation
AS
BEGIN
	Select ID,DesignationName,IsActive,DepartmentID,DesignationCode 
		From tbl_Designation 
		Where IsActive=1
		Order by DesignationName
End

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetPhoneCallLog' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetPhoneCallLog
  END
Go 
 ---- =============================================  
-- Author:  Jitendra Pancholi  
-- Create date: 03/30/2018
-- Description: Load all details of task for edit.  
-- =============================================  
-- GetPhoneCallLog 3797,'missed',1,50
 
CREATE PROCEDURE [dbo].[GetPhoneCallLog]
(
	@LoggedInUserId int,
	@CallType varchar(20) = 'recent',
	@PageIndex int = 1,
	@PageSize int = 10
)
AS  
BEGIN
	If @CallType = 'recent'
		Begin
			Select P.Id,P.Mode, P.CallerNumber, P.ReceiverNumber,P.ReceiverUserId,P.CallDurationInSeconds,
					P.CallStartTime, P.CreatedOn, P.CreatedBy, 
					U.FristName, U.LastName, ISNULL(U.Picture,'no-phone.png') as ReceiverProfilePic, U.UserInstallId,
					UU.FristName As CallerFristName, UU.LastName As CallerLastName , 
					ISNULL(UU.Picture,'no-phone.png') as CallerProfilePic, UU.UserInstallId As CallerUserInstallId
			From PhoneCallLog P With(NoLock) 
			Left Join tblInstallUsers U With(NoLock) On U.Id = P.ReceiverUserId
			Join tblInstallUsers UU With(NoLock) On UU.Id = P.CreatedBy
			Where P.CreatedBy = @LoggedInUserId
			Order by P.CreatedOn Desc
			OFFSET (@PageIndex - 1) * @PageSize ROWS
			FETCH NEXT @PageSize ROWS ONLY
		End
	Else if @CallType = 'missed'
		Begin
			Select P.Id,P.Mode, P.CallerNumber, P.ReceiverNumber,P.ReceiverUserId,P.CallDurationInSeconds,
					P.CallStartTime, P.CreatedOn, P.CreatedBy, 
					U.FristName, U.LastName, ISNULL(U.Picture,'no-phone.png') as ReceiverProfilePic, U.UserInstallId,
					UU.FristName As CallerFristName, UU.LastName As CallerLastName , 
					ISNULL(UU.Picture,'no-phone.png') as CallerProfilePic, UU.UserInstallId As CallerUserInstallId
			From PhoneCallLog P With(NoLock) 
			Left Join tblInstallUsers U With(NoLock) On U.Id = P.ReceiverUserId
			Join tblInstallUsers UU With(NoLock) On UU.Id = P.CreatedBy
			Where P.CreatedBy = @LoggedInUserId And P.Mode = 'out' And P.CallDurationInSeconds = 0
			Order by P.CreatedOn Desc
			OFFSET (@PageIndex - 1) * @PageSize ROWS
			FETCH NEXT @PageSize ROWS ONLY
		End
	Else if @CallType = 'mngr'
		Begin
			Select P.Id,P.Mode, P.CallerNumber, P.ReceiverNumber,P.ReceiverUserId,P.CallDurationInSeconds,
					P.CallStartTime, P.CreatedOn, P.CreatedBy, 
					U.FristName, U.LastName, ISNULL(U.Picture,'no-phone.png') as ReceiverProfilePic, U.UserInstallId,
					UU.FristName As CallerFristName, UU.LastName As CallerLastName , 
					ISNULL(UU.Picture,'no-phone.png') as CallerProfilePic, UU.UserInstallId As CallerUserInstallId
			From PhoneCallLog P With(NoLock) 
			Left Join tblInstallUsers U With(NoLock) On U.Id = P.ReceiverUserId
			Join tblInstallUsers UU With(NoLock) On UU.Id = P.CreatedBy
			Where  P.CreatedBy != @LoggedInUserId
		End
End


GO


Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetDesignationById' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetDesignationById
  END
Go 
 ---- =============================================  
-- Author:  Jitendra Pancholi  
-- Create date: 03/30/2018
-- Description: Load all details of task for edit.  
-- =============================================  
-- GetDesignationById 1
 
CREATE PROCEDURE [dbo].GetDesignationById
(
	@DesignationId int
)
AS  
BEGIN
	Select * From tbl_Designation Where Id = @DesignationId
End

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'IsManager' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE IsManager
  END
Go 
 ---- =============================================  
-- Author:  Jitendra Pancholi  
-- Create date: 03/30/2018
-- Description: Load all details of task for edit.  
-- =============================================  
-- IsManager 780
-- IsManager 3797
 
CREATE PROCEDURE [dbo].IsManager
(
	@UserId int
)
AS  
BEGIN
	IF Exists (Select DesignationID From tblInstallUsers U 
				Join tbl_Designation D On U.DesignationId = D.ID 
				Where U.Id = @UserId And D.DesignationCode in ('ADM','REC','ITL'))
		Begin
			Select Convert(Bit, 1) As IsManager
		End
	Else
		Begin
			Select Convert(Bit, 0) As IsManager
		End
End

Go