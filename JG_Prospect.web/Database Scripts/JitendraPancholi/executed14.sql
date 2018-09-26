Go
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PhoneScript]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[PhoneScript](
		Id int Primary Key Identity(1,1),
		[Type] int,-- 1: Inbound, 2: Outbound
		SubType int,-- 1: HR, 2: Sales, 3: Customer Service,
		Title NVarchar(2000) Not Null,
		[Description] NVarchar(Max) Not Null,
		CreatedOn DateTime Not Null Default(GetUTCDate())
	) 
END
-- use JGBS_Dev_new
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
	GetPhoneScripts 0
*/
CREATE PROCEDURE [dbo].[GetPhoneScripts]
	@Id Int = Null
AS    
BEGIN
	If @Id IS NULL OR @Id = 0
		Begin
			Select P.Id,P.[Type],P.SubType,P.Title,P.[Description],P.CreatedOn, P.FAQTitle, P.FAQDescription From PhoneScript P With(NoLock) Order By P.[Type], P.SubType
		End
	Else
		Begin
			Select P.Id,P.[Type],P.SubType,P.Title,P.[Description],P.CreatedOn, P.FAQTitle, P.FAQDescription From PhoneScript P With(NoLock)
				Where P.Id = @Id Order By P.[Type], P.SubType
		End
End
/*

Insert Into PhoneScript(Type,SubType,Title,Description)Values(1,1,'In Bound Phone Calls','In Bound Phone Calls')
Insert Into PhoneScript(Type,SubType,Title,Description)Values(1,2,'In Bound Phone Calls','In Bound Phone Calls')
Insert Into PhoneScript(Type,SubType,Title,Description)Values(1,2,'In Bound Phone Calls','In Bound Phone Calls')
Insert Into PhoneScript(Type,SubType,Title,Description)Values(1,3,'In Bound Phone Calls','In Bound Phone Calls')
Insert Into PhoneScript(Type,SubType,Title,Description)Values(2,1,'Outbound Phone Calls','Outbound Phone Calls')
Insert Into PhoneScript(Type,SubType,Title,Description)Values(2,2,'Outbound Phone Calls','Outbound Phone Calls')
Insert Into PhoneScript(Type,SubType,Title,Description)Values(2,3,'Outbound Phone Calls','Outbound Phone Calls')
Insert Into PhoneScript(Type,SubType,Title,Description)Values(1,4,'Inbound Vendor Phone Calls','Inbound Vendor Phone Calls Desc')
Insert Into PhoneScript(Type,SubType,Title,Description)Values(2,4,'Outbound Vendor Phone Calls','Outbound Vendor Phone Calls')

*/

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetUserDesignations' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetUserDesignations
  END
Go
 -- =============================================      
-- Author:  Jitendra Pancholi      
-- Create date: 9 Jan 2017   
-- Description: Add offline user to chatuser table
-- =============================================    
/*
	GetUserDesignations
	GetUserDesignations 1
*/
CREATE PROCEDURE GetUserDesignations
	@Id Int = Null
AS    
BEGIN
	If @Id Is Null
		Begin
			Select Id, DesignationName, IsActive, DepartmentId, DesignationCode 
				From tbl_Designation D With(NoLock) Where D.IsActive = 1
		End
	Else
		Begin
			Select Id, DesignationName, IsActive, DepartmentId, DesignationCode 
			From tbl_Designation D With(NoLock) Where D.IsActive = 1 And D.Id = @Id
		End
End

Go
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
-- use JGBS_DEV_NEW
-- [GetSalesUsers] '','0',0,0, 0, NULL, NULL,0,20, 'LastLoginTimeStamp DESC','5','9','6','1'    
Create PROCEDURE [dbo].[GetSalesUsers]    
	 @SearchTerm VARCHAR(15) = NULL, @Status VARCHAR(50), @DesignationId INT, @SourceId INT, @AddedByUserId INT, @FromDate DATE = NULL,    
	 @ToDate DATE = NULL, @PageIndex INT = NULL,  @PageSize INT = NULL, @SortExpression VARCHAR(50), @InterviewDateStatus VARChAR(5) = '5',    
	 @RejectedStatus VARChAR(5) = '9', @OfferMadeStatus VARChAR(5) = '6', @ActiveStatus VARChAR(5) = '1'     
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
   CASE WHEN @SortExpression = 'LastLoginTimeStamp ASC' THEN t.LastLoginTimeStamp END ASC,    
   CASE WHEN @SortExpression = 'LastLoginTimeStamp DESC' THEN t.LastLoginTimeStamp END DESC,
   CASE WHEN @SortExpression = 'SecondaryStatus ASC' THEN t.SecondaryStatus END ASC,    
   CASE WHEN @SortExpression = 'SecondaryStatus DESC' THEN t.SecondaryStatus END DESC
   , IsNull(t.SecondaryStatus,0) Asc
       ) AS RowNumber,    
    '' as Country,
	t.LastLoginTimeStamp, t.SecondaryStatus
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
 AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))    
 AND t.Status NOT IN (@OfferMadeStatus, @ActiveStatus, 3,9)    -- Exclude Deactive(3) & Rejected(9) status Users
 And t.Phone Like'[0-9]%' And IsNull(t.CountryCode,'') !='' -- Exclude Bad number users
 AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))    
 AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))    
 --AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))    
 AND ISNULL(t1.Id,t2.Id)=ISNULL(@AddedByUserId,ISNULL(t1.Id,t2.Id))    
 AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)    
 AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)    
)    
SELECT  Id, FristName, LastName, Phone, Zip, Designation, Status, HireDate, InstallId, picture, CreatedDateTime, Source, SourceUser,    
AddedBy, UserInstallId, InterviewDetail, RejectDetail, RejectedUserId, RejectedByUserName, RejectedByUserInstallId, Email, DesignationID,    
AddedByUserInstallId, AddedById, EmpType, [Aggregate], PrimaryPhone, CountryCode, Resumepath, TechTaskId, ParentTechTaskId,    
TechTaskInstallId, bookmarkedUser,  [StatusReason], Country, City,
(Select top 1 CallStartTime From PhoneCallLog PCL WIth(NoLOck) Where PCL.ReceiverUserId = SalesUsers.Id Order by CreatedOn Desc) as LastCalledAt,
IsNull((Select top 1 PhoneCode From Country CT WIth(NoLOck) 
	Where CT.CountryCodeTwoChar = SalesUsers.CountryCode Or CT.CountryCodeThreeChar = SalesUsers.CountryCode),'1') as PhoneCode,
	CONVERT(datetime, SWITCHOFFSET(LastLoginTimeStamp, DATEPART(TZOFFSET, LastLoginTimeStamp AT TIME ZONE 'Eastern Standard Time'))) AS LastLoginTimeInEST, SecondaryStatus
FROM SalesUsers    
WHERE RowNumber >= @StartIndex AND (@PageSize = 0 OR RowNumber < (@StartIndex + @PageSize))    
group by Id, FristName, LastName, Phone, Zip, Designation, Status, HireDate, InstallId, picture, CreatedDateTime, Source, SourceUser,    
AddedBy, UserInstallId, InterviewDetail, RejectDetail, RejectedUserId, RejectedByUserName, RejectedByUserInstallId, Email, DesignationID,    
AddedByUserInstallId, AddedById, EmpType, [Aggregate], PrimaryPhone, CountryCode, Resumepath, TechTaskId, ParentTechTaskId,    
TechTaskInstallId, bookmarkedUser,  [StatusReason], Country, City, LastLoginTimeStamp, SecondaryStatus
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
 -- get record count - Table 5    
 SELECT COUNT(*) AS TotalRecordCount    
 FROM tblInstallUsers t    
 LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser    
 LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id    
 LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id    
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
  AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))    
  AND t.Status NOT IN (@OfferMadeStatus, @ActiveStatus,3,9)  -- Exclude Deactive(3) & Rejected(9) status Users
  And t.Phone Like'[0-9]%' And IsNull(t.CountryCode,'') !='' -- Exclude Bad number users
  AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))    
  AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))    
  AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))    
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
   AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))    
   AND t.Status NOT IN (@OfferMadeStatus, @ActiveStatus, 3, 9)        -- Exclude Deactive(3) & Rejected(9) status Users
   And t.Phone Like'[0-9]%' And IsNull(t.CountryCode,'') !='' -- Exclude Bad number users
   AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))    
   AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))    
   --AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))    
   AND ISNULL(t1.Id,t2.Id)=ISNULL(@AddedByUserId,ISNULL(t1.Id,t2.Id))    
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
    CASE WHEN @SortExpression = 'LastLoginTimeStamp ASC' THEN t.LastLoginTimeStamp END ASC,    
   CASE WHEN @SortExpression = 'LastLoginTimeStamp DESC' THEN t.LastLoginTimeStamp END DESC,
   CASE WHEN @SortExpression = 'SecondaryStatus ASC' THEN t.SecondaryStatus END ASC,    
   CASE WHEN @SortExpression = 'SecondaryStatus DESC' THEN t.SecondaryStatus END DESC
       , IsNull(t.SecondaryStatus,0) Asc) AS RowNumber,    
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
 AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))    
 AND t.Status NOT IN (@OfferMadeStatus, @ActiveStatus,3,9)        -- Exclude Deactive(3) & Rejected(9) status Users
 And t.Phone Like'[0-9]%' And IsNull(t.CountryCode,'') !='' -- Exclude Bad number users
 AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))    
 AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))    
 --AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))    
 AND ISNULL(t1.Id,t2.Id)=ISNULL(@AddedByUserId,ISNULL(t1.Id,t2.Id))    
 AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)    
 AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)    
)    
Insert Into #TempUserIds SELECT  Id   
FROM SalesUsers    
WHERE RowNumber >= @StartIndex AND (@PageSize = 0 OR RowNumber < (@StartIndex + @PageSize))    
group by Id, FristName, LastName, Phone, Zip, Designation, Status, HireDate, InstallId, picture, CreatedDateTime, Source, SourceUser,    
AddedBy, UserInstallId, InterviewDetail, RejectDetail, RejectedUserId, RejectedByUserName, RejectedByUserInstallId, Email, DesignationID,    
AddedByUserInstallId, AddedById, EmpType, [Aggregate], PrimaryPhone, CountryCode, Resumepath, TechTaskId, ParentTechTaskId,    
TechTaskInstallId, bookmarkedUser,  [StatusReason], Country, City, LastLoginTimeStamp, SecondaryStatus
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
   CASE WHEN @SortExpression = 'CreatedDateTime DESC' THEN CreatedDateTime END DESC ,
    CASE WHEN @SortExpression = 'LastLoginTimeStamp ASC' THEN LastLoginTimeStamp END ASC,    
   CASE WHEN @SortExpression = 'LastLoginTimeStamp DESC' THEN LastLoginTimeStamp END DESC ,
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
END 


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
-- usp_GetTaskDetails 10785  
CREATE PROCEDURE [dbo].[usp_GetTaskDetails]   
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
			@Title NVarchar(1000), @MainParentTaskId int 

	Select @TaskId = TaskId, @ParentTaskId = T.ParentTaskId, @TempChatGroupName = T.InstallId, 
			@Title = T.Title From tblTask T With(NoLock) Where T.TaskId = @TaskId

	If @TaskId IS NOT NULL AND @ParentTaskId IS NOT NULL
			Begin
				Set @Title = @Title + ' <a target="_blank" onclick="event.stopPropagation();" href="/Sr_App/TaskGenerator.aspx?TaskId={MainParentTaskId}&hstid=' + Convert(Varchar(12),@TaskId) + '">'
			End
		Else IF @TaskId IS NOT NULL
			Begin
				Set @Title = @Title + ' <a target="_blank" onclick="event.stopPropagation();" href="/Sr_App/TaskGenerator.aspx?TaskId=' + Convert(Varchar(12),@TaskId) + '">'
			End

	IF OBJECT_ID('tempdb..#TaskUsers') IS NOT NULL DROP TABLE #TaskUsers   
	Create Table #TaskUsers(UserId int, Aceptance bit, CreatedOn DateTime)
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

	Select @Title = @Title + ISNULL(U.FristName,'') + ' ' + ISNULL(U.LastName,'') + '-' + '<a target="_blank" href="/Sr_App/ViewSalesUser.aspx?id='+Convert(Varchar(12),U.Id)+'" uid="'+Convert(Varchar(12),U.Id)+'">'+ISNULL(U.UserInstallId,'')+'</a>' + ', ' From #TaskUsers T With(NoLock) 
	Join tblInstallUsers U With(NoLock) On T.UserId = U.Id
	Order By U.Id Asc

	Set @Title = SUBSTRING(@Title, 0, LEN(@Title)) + ')'

	Select @Title As TaskTitle
	/* Proper Task Title with ID */
END  

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
	Declare @SourceId int, @SenderId int, @msg varchar(500), @Createdon Datetime, @SourceUser int

	Set @ChatSourceId = NewID()

	SELECT @SenderId = I.Id, @msg = 'User successfully filled in HR form', @SourceUser = I.SourceUser FROM INSERTED I

	Insert Into UserChatGroup (CreatedBy) Values(@SenderId)
	Set @UserChatGroupId = IDENT_CURRENT('UserChatGroup')

	IF OBJECT_ID('tempdb..#TempUsers') IS NOT NULL DROP TABLE #TempUsers   
	Create Table #TempUsers(UserId int, UserChatGroupId int)
	Insert Into #TempUsers Values(780, @UserChatGroupId)
	Insert Into #TempUsers Values(901, @UserChatGroupId)
	Insert Into #TempUsers Values(@SenderId, @UserChatGroupId)

	Insert Into UserChatGroupMember (UserChatGroupId, UserId)
		Select Distinct UserChatGroupId, UserId From #TempUsers

	SELECT @ReceiverIds = SUBSTRING((SELECT ',' + s.UserId FROM #TempUsers s 
		ORDER BY s.UserId Asc FOR XML PATH('')),2,200000) 
	
	--Insert Into tblUserTouchPointLog(UserID, UpdatedByUserID, UpdatedUserInstallID, ChangeDateTime, LogDescription, CurrentUserGUID)
	

	Exec SaveChatMessage 1,@ChatSourceId, @SenderId, @msg,null, @ReceiverIds,null,null, @UserChatGroupId
	Declare @SenderName Varchar(200)
	Select @SenderName = UserInstallId +'-'+FristName+' '+LastName From tblINstallUsers Where Id = @SourceUser
	Set @msg = 'Auto Email sent by ' + @SenderName + ' - HR Welcome Email - ' + Convert(varchar, GetDate(), 113) + ' (EST)'

	Exec SaveChatMessage 1,@ChatSourceId, @SenderId, @msg,null, @ReceiverIds,null,null, @UserChatGroupId
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
	
End

/* Data Correction for Chat
Update S
Set S.ReceiverId = 780
From ChatMessageReadStatus S Join ChatMessage M On S.ChatMessageId = M.Id
Where LTrim(M.TextMessage) like 'User%'

Update M
Set M.ReceiverIds = '780'
From ChatMessage M Where LTrim(M.TextMessage) like 'User%'



 IF OBJECT_ID('tempdb..#TempChatMessages') IS NOT NULL DROP TABLE #TempChatMessages  
 Create Table #TempChatMessages(Id int Primary Key Identity(1,1), 
								SourceId int, SenderId int, Msg varchar(2000), Rid varchar(200),CreatedOn Datetime)
	Insert Into #TempChatMessages
       select 1,UpdatedByUserId, LogDescription,UserId,ChangeDateTime
	   From JGBS.dbo.tblUserTouchPointLog T
		Join tblInstallUsers U on U.Id = UserId
		 Where LTrim(LogDescription) like 'User successfully filled in HR form%' 
		And ChangeDateTime > '2018-01-01'
		 Order by ChangeDateTime Desc

		 Declare @Min int =1, @Max int =1
		 Declare @SourceId int, @SenderId int, @msg varchar(500), @Createdon Datetime
		 Select @Min = Min(Id), @Max = Max(Id) From #TempChatMessages

		 While @Min <= @Max
			Begin
				 Select @SourceId = SourceId, @SenderId=SenderId, @msg=Msg, @Createdon= CreatedOn From
					#TempChatMessages Where Id = @Min
				Exec SaveChatMessageTemp @SourceId, @SenderId, @msg, '780',@Createdon
				--Print @Createdon
					Set @Min = @Min + 1
			End



			
GO
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'SaveChatMessageTemp' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE SaveChatMessageTemp
  END
Go
 -- =============================================      
-- Author:  Jitendra Pancholi      
-- Create date: 9 Jan 2017   
-- Description: Add offline user to chatuser table
-- =============================================    
/*
	SaveChatMessageTemp 3797
*/
CREATE PROCEDURE [dbo].[SaveChatMessageTemp]
	@ChatSourceId int,
	@SenderId int,
	@TextMessage nvarchar(max),
	@ReceiverIds varchar(800),
	@CreatedOn Datetime
AS    
BEGIN
	Declare @MessageId int, @ChatGroupId varchar(500) = null
	-- Find ChatGroupId
	Select top 1 @ChatGroupId = M.ChatGroupId From ChatMessage M With(NoLock) Where M.SenderId = @SenderId And M.ReceiverIds = @ReceiverIds
	If @ChatGroupId IS NULL
	Begin
		Set @ChatGroupId = NewID()
	End
	Insert Into ChatMessage(ChatSourceId, SenderId, ChatGroupId, TextMessage, ChatFileId, ReceiverIds, TaskId,TaskMultilevelListId, CreatedOn) 
	Values
		(@ChatSourceId, @SenderId, @ChatGroupId, @TextMessage, NULL, @ReceiverIds,NULL,NULL, @CreatedOn)
	Set @MessageId = IDENT_CURRENT('ChatMessage')
	Insert Into ChatMessageReadStatus (ChatMessageId, ReceiverId) 
		Select @MessageId, RESULT from dbo.CSVtoTable(@ReceiverIds,',') Where RESULT > 0
END

*/

Go
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PhoneCallLog]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[PhoneCallLog](
		Id int Primary Key Identity(1,1),
		Mode varchar(20) Not Null,
		CallerNumber varchar(20) not null,
		ReceiverNumber varchar(20) not null,
		ReceiverUserId int foreign key references tblInstallUsers(Id),
		CallDurationInSeconds decimal(18,2) not null,
		CallStartTime DateTime Not NUll,
		CreatedOn DateTime not null default(DATEADD(HH,-5,GetUTCDate())),
		CreatedBy int not null foreign key references tblInstallUsers(Id)
	) 
END

Go
IF Not EXISTS (SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[PhoneCallLog]') AND name = 'UserStatusWhenCalled')
	Begin
		Alter Table PhoneCallLog Add UserStatusWhenCalled int
	End

Go

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
	@ReceiverUserId int = null
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
				IF @CallDurationInSeconds = 0
					Begin
						Set @msg ='Call Not Connected: ' + @CreatedByFullName + ' auto dialed ' + @ReceiverUserFullName + ' on ' + Convert(Varchar(200), @CallStartTime)
						--Update tblInstallUsers Set SecondaryStatus = 2 Where Id = @ReceiverUserId
					End
				Else
					Begin 
						Set @msg ='Call Connected: ' + @CreatedByFullName + ' auto dialed ' + @ReceiverUserFullName + ' on ' + Convert(Varchar(200), @CallStartTime)
					End
				Exec SaveChatMessage 11,@ChatGroupId, @CreatedBy, @msg,null, @ReceiverUserId,null,null
			End
	End
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
-- GetPhoneCallLog 1,50
 
CREATE PROCEDURE [dbo].[GetPhoneCallLog]
(
	@PageIndex int = 1,
	@PageSize int = 10
)
AS  
BEGIN
	Select P.Id,P.Mode, P.CallerNumber, P.ReceiverNumber,P.ReceiverUserId,P.CallDurationInSeconds,
			P.CallStartTime, P.CreatedOn, P.CreatedBy, 
			U.FristName, U.LastName, ISNULL(U.Picture,'no-phone.png') as ReceiverProfilePic, U.UserInstallId
	From PhoneCallLog P With(NoLock) 
	Left Join tblInstallUsers U With(NoLock) On U.Id = P.ReceiverUserId
	Order by P.CreatedOn Desc
	OFFSET (@PageIndex - 1) * @PageSize ROWS
	FETCH NEXT @PageSize ROWS ONLY
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
	@Script nVarchar(max)
)     
AS  
BEGIN
	Update PhoneScript Set
		Title = @Title,
		Description = @Script
	Where Id = @Id
End

Go
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Country]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[Country](
		Id int Primary Key Identity(1,1),
		CountryName varchar(200),
		CountryCodeTwoChar Varchar(3),
		CountryCodeThreeChar Varchar(4),
		PhoneCode varchar(20)
	) 
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Afghanistan','AF','AFG','93')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Albania','AL','ALB','355')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Algeria','DZ','DZA','213')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('American Samoa','AS','ASM','1-684')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Andorra','AD','AND','376')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Angola','AO','AGO','244')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Anguilla','AI','AIA','1-264')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Antarctica','AQ','ATA','672')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Antigua and Barbuda','AG','ATG','1-268')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Argentina','AR','ARG','54')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Armenia','AM','ARM','374')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Aruba','AW','ABW','297')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Australia','AU','AUS','61')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Austria','AT','AUT','43')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Azerbaijan','AZ','AZE','994')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Bahamas','BS','BHS','1-242')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Bahrain','BH','BHR','973')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Bangladesh','BD','BGD','880')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Barbados','BB','BRB','1-246')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Belarus','BY','BLR','375')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Belgium','BE','BEL','32')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Belize','BZ','BLZ','501')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Benin','BJ','BEN','229')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Bermuda','BM','BMU','1-441')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Bhutan','BT','BTN','975')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Bolivia','BO','BOL','591')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Bosnia and Herzegovina','BA','BIH','387')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Botswana','BW','BWA','267')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Brazil','BR','BRA','55')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('British Indian Ocean Territory','IO','IOT','246')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('British Virgin Islands','VG','VGB','1-284')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Brunei','BN','BRN','673')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Bulgaria','BG','BGR','359')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Burkina Faso','BF','BFA','226')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Burundi','BI','BDI','257')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Cambodia','KH','KHM','855')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Cameroon','CM','CMR','237')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Canada','CA','CAN','1')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Cape Verde','CV','CPV','238')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Cayman Islands','KY','CYM','1-345')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Central African Republic','CF','CAF','236')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Chad','TD','TCD','235')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Chile','CL','CHL','56')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('China','CN','CHN','86')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Christmas Island','CX','CXR','61')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Cocos Islands','CC','CCK','61')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Colombia','CO','COL','57')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Comoros','KM','COM','269')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Cook Islands','CK','COK','682')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Costa Rica','CR','CRI','506')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Croatia','HR','HRV','385')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Cuba','CU','CUB','53')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Curacao','CW','CUW','599')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Cyprus','CY','CYP','357')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Czech Republic','CZ','CZE','420')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Democratic Republic of the Congo','CD','COD','243')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Denmark','DK','DNK','45')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Djibouti','DJ','DJI','253')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Dominica','DM','DMA','1-767')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Dominican Republic','DO','DOM','1-809, 1-829, 1-849')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('East Timor','TL','TLS','670')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Ecuador','EC','ECU','593')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Egypt','EG','EGY','20')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('El Salvador','SV','SLV','503')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Equatorial Guinea','GQ','GNQ','240')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Eritrea','ER','ERI','291')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Estonia','EE','EST','372')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Ethiopia','ET','ETH','251')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Falkland Islands','FK','FLK','500')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Faroe Islands','FO','FRO','298')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Fiji','FJ','FJI','679')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Finland','FI','FIN','358')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('France','FR','FRA','33')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('French Polynesia','PF','PYF','689')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Gabon','GA','GAB','241')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Gambia','GM','GMB','220')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Georgia','GE','GEO','995')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Germany','DE','DEU','49')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Ghana','GH','GHA','233')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Gibraltar','GI','GIB','350')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Greece','GR','GRC','30')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Greenland','GL','GRL','299')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Grenada','GD','GRD','1-473')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Guam','GU','GUM','1-671')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Guatemala','GT','GTM','502')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Guernsey','GG','GGY','44-1481')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Guinea','GN','GIN','224')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Guinea-Bissau','GW','GNB','245')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Guyana','GY','GUY','592')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Haiti','HT','HTI','509')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Honduras','HN','HND','504')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Hong Kong','HK','HKG','852')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Hungary','HU','HUN','36')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Iceland','IS','ISL','354')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('India','IN','IND','91')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Indonesia','ID','IDN','62')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Iran','IR','IRN','98')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Iraq','IQ','IRQ','964')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Ireland','IE','IRL','353')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Isle of Man','IM','IMN','44-1624')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Israel','IL','ISR','972')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Italy','IT','ITA','39')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Ivory Coast','CI','CIV','225')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Jamaica','JM','JAM','1-876')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Japan','JP','JPN','81')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Jersey','JE','JEY','44-1534')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Jordan','JO','JOR','962')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Kazakhstan','KZ','KAZ','7')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Kenya','KE','KEN','254')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Kiribati','KI','KIR','686')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Kosovo','XK','XKX','383')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Kuwait','KW','KWT','965')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Kyrgyzstan','KG','KGZ','996')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Laos','LA','LAO','856')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Latvia','LV','LVA','371')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Lebanon','LB','LBN','961')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Lesotho','LS','LSO','266')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Liberia','LR','LBR','231')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Libya','LY','LBY','218')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Liechtenstein','LI','LIE','423')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Lithuania','LT','LTU','370')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Luxembourg','LU','LUX','352')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Macau','MO','MAC','853')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Macedonia','MK','MKD','389')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Madagascar','MG','MDG','261')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Malawi','MW','MWI','265')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Malaysia','MY','MYS','60')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Maldives','MV','MDV','960')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Mali','ML','MLI','223')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Malta','MT','MLT','356')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Marshall Islands','MH','MHL','692')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Mauritania','MR','MRT','222')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Mauritius','MU','MUS','230')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Mayotte','YT','MYT','262')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Mexico','MX','MEX','52')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Micronesia','FM','FSM','691')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Moldova','MD','MDA','373')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Monaco','MC','MCO','377')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Mongolia','MN','MNG','976')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Montenegro','ME','MNE','382')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Montserrat','MS','MSR','1-664')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Morocco','MA','MAR','212')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Mozambique','MZ','MOZ','258')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Myanmar','MM','MMR','95')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Namibia','NA','NAM','264')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Nauru','NR','NRU','674')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Nepal','NP','NPL','977')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Netherlands','NL','NLD','31')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Netherlands Antilles','AN','ANT','599')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('New Caledonia','NC','NCL','687')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('New Zealand','NZ','NZL','64')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Nicaragua','NI','NIC','505')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Niger','NE','NER','227')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Nigeria','NG','NGA','234')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Niue','NU','NIU','683')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('North Korea','KP','PRK','850')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Northern Mariana Islands','MP','MNP','1-670')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Norway','NO','NOR','47')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Oman','OM','OMN','968')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Pakistan','PK','PAK','92')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Palau','PW','PLW','680')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Palestine','PS','PSE','970')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Panama','PA','PAN','507')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Papua New Guinea','PG','PNG','675')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Paraguay','PY','PRY','595')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Peru','PE','PER','51')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Philippines','PH','PHL','63')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Pitcairn','PN','PCN','64')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Poland','PL','POL','48')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Portugal','PT','PRT','351')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Puerto Rico','PR','PRI','1-787, 1-939')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Qatar','QA','QAT','974')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Republic of the Congo','CG','COG','242')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Reunion','RE','REU','262')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Romania','RO','ROU','40')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Russia','RU','RUS','7')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Rwanda','RW','RWA','250')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Saint Barthelemy','BL','BLM','590')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Saint Helena','SH','SHN','290')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Saint Kitts and Nevis','KN','KNA','1-869')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Saint Lucia','LC','LCA','1-758')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Saint Martin','MF','MAF','590')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Saint Pierre and Miquelon','PM','SPM','508')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Saint Vincent and the Grenadines','VC','VCT','1-784')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Samoa','WS','WSM','685')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('San Marino','SM','SMR','378')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Sao Tome and Principe','ST','STP','239')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Saudi Arabia','SA','SAU','966')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Senegal','SN','SEN','221')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Serbia','RS','SRB','381')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Seychelles','SC','SYC','248')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Sierra Leone','SL','SLE','232')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Singapore','SG','SGP','65')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Sint Maarten','SX','SXM','1-721')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Slovakia','SK','SVK','421')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Slovenia','SI','SVN','386')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Solomon Islands','SB','SLB','677')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Somalia','SO','SOM','252')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('South Africa','ZA','ZAF','27')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('South Korea','KR','KOR','82')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('South Sudan','SS','SSD','211')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Spain','ES','ESP','34')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Sri Lanka','LK','LKA','94')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Sudan','SD','SDN','249')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Suriname','SR','SUR','597')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Svalbard and Jan Mayen','SJ','SJM','47')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Swaziland','SZ','SWZ','268')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Sweden','SE','SWE','46')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Switzerland','CH','CHE','41')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Syria','SY','SYR','963')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Taiwan','TW','TWN','886')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Tajikistan','TJ','TJK','992')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Tanzania','TZ','TZA','255')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Thailand','TH','THA','66')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Togo','TG','TGO','228')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Tokelau','TK','TKL','690')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Tonga','TO','TON','676')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Trinidad and Tobago','TT','TTO','1-868')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Tunisia','TN','TUN','216')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Turkey','TR','TUR','90')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Turkmenistan','TM','TKM','993')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Turks and Caicos Islands','TC','TCA','1-649')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Tuvalu','TV','TUV','688')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('U.S. Virgin Islands','VI','VIR','1-340')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Uganda','UG','UGA','256')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Ukraine','UA','UKR','380')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('United Arab Emirates','AE','ARE','971')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('United Kingdom','GB','GBR','44')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('United States','US','USA','1')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Uruguay','UY','URY','598')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Uzbekistan','UZ','UZB','998')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Vanuatu','VU','VUT','678')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Vatican','VA','VAT','379')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Venezuela','VE','VEN','58')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Vietnam','VN','VNM','84')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Wallis and Futuna','WF','WLF','681')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Western Sahara','EH','ESH','212')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Yemen','YE','YEM','967')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Zambia','ZM','ZMB','260')
	Insert Into Country(CountryName, CountryCodeTwoChar, CountryCodeThreeChar, PhoneCode) Values('Zimbabwe','ZW','ZWE','263')
END

Go
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserChatGroup]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[UserChatGroup](
		Id int Primary Key Identity(1,1),
		TaskId bigint foreign key references tblTask(TaskId),
		TaskMultilevelListId int foreign key references tblTaskMultilevelList(Id),
		UserChatGroupTitle Nvarchar(Max),
		CreatedBy int foreign key references tblInstallUsers(id),
		CreatedOn DateTime Not Null Default(GetUTCDate())
	) 
END

Go
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserChatGroupMember]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[UserChatGroupMember](
		Id int Primary Key Identity(1,1),
		UserChatGroupId int foreign key references UserChatGroup(Id),
		UserId int foreign key references tblInstallUsers(id),
		CreatedOn DateTime Not Null Default(GetUTCDate())
	) 
END
Go
IF Not EXISTS (SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[ChatMessage]') AND name = 'UserChatGroupId')
BEGIN
	Alter Table ChatMessage Add UserChatGroupId int foreign key references UserChatGroup(Id)
End


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
	If IsNull(@UserChatGroupId,0) = 0
	Begin
		Insert Into UserChatGroup (CreatedBy) Values(@LoggedInUserId)
		Set @UserChatGroupId = IDENT_CURRENT('UserChatGroup') 
		
		Insert Into UserChatGroupMember (UserChatGroupId, UserId)
			Select @UserChatGroupId, Result From dbo.CSVtoTable(@ExistingUsers,',')

		Insert Into UserChatGroupMember (UserChatGroupId, UserId) values(@UserChatGroupId,@LoggedInUserId)
	End

	Insert Into UserChatGroupMember (UserChatGroupId, UserId) values (@UserChatGroupId, @UserId)

	Select @UserChatGroupId As UserChatGroupId
End



Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetUserChatGroupId' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetUserChatGroupId
  END
Go
 ---- =============================================  
-- Author:  Jitendra Pancholi  
-- Create date: 03/30/2018
-- Description: Load all details of task for edit.  
-- =============================================  
-- GetUserChatGroupId
 
CREATE PROCEDURE [dbo].GetUserChatGroupId   
(  
	@ChatGroupId varchar(200)
)     
AS  
BEGIN
    Select top 1 UserChatGroupId From ChatMessage M With(NoLock) 
	Where M.ChatGroupId = @ChatGroupId And UserChatGroupId Is Not Null
End


Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetChatGroupMembers' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetChatGroupMembers
  END
Go
 ---- =============================================  
-- Author:  Jitendra Pancholi  
-- Create date: 03/30/2018
-- Description: Load all details of task for edit.  
-- =============================================  
-- GetChatGroupMembers 1,780
 
CREATE PROCEDURE [dbo].GetChatGroupMembers   
(  
	@UserChatGroupId int,
	@LoggedInUserId int = null
)     
AS  
BEGIN
	IF ISNULL(@LoggedInUserId,0) = 0
		Begin
			Select U.Id, U.FristName, U.LastName, U.UserInstallId, M.CreatedOn from UserChatGroupMember M With(NoLock) 
				Join tblInstallUsers U With(NoLock) On M.UserId = U.Id
				Join UserChatGroup G With(NoLock) On G.Id = M.UserChatGroupId
			Where M.UserChatGroupId = @UserChatGroupId
		End
	Else
		Begin
			Select U.Id, U.FristName, U.LastName, U.UserInstallId, M.CreatedOn from UserChatGroupMember M With(NoLock) 
				Join tblInstallUsers U With(NoLock) On M.UserId = U.Id
				Join UserChatGroup G With(NoLock) On G.Id = M.UserChatGroupId
			Where M.UserChatGroupId = @UserChatGroupId And G.CreatedBy = @LoggedInUserId
		End
End

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'RemoveChatGroupMember' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE RemoveChatGroupMember
  END
Go
 ---- =============================================  
-- Author:  Jitendra Pancholi  
-- Create date: 03/30/2018
-- Description: Load all details of task for edit.  
-- =============================================  
-- RemoveChatGroupMember 1
 
CREATE PROCEDURE [dbo].RemoveChatGroupMember   
(  
	@UserChatGroupId int,
	@UserId int
)     
AS  
BEGIN
    Delete From UserChatGroupMember 
		Where UserChatGroupId = @UserChatGroupId And UserId = @UserId
End

Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'CreateTaskChatGroup' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE CreateTaskChatGroup
  END
Go
 ---- =============================================  
-- Author:  Jitendra Pancholi  
-- Create date: 03/30/2018
-- Description: Load all details of task for edit.   
-- =============================================  
-- CreateTaskChatGroup 10803,0
 
CREATE PROCEDURE [dbo].CreateTaskChatGroup   
(  
	@TaskId int,
	@TaskMultilevelListId int
)     
AS  
BEGIN
	Declare @UserChatGroupId int = null

	IF ISNULL(@TaskMultilevelListId,0) = 0 And @TaskId IS NOT NULL
		Begin
			Select top 1 @UserChatGroupId = Id From UserChatGroup Where TaskId = @TaskId And TaskMultilevelListId IS NULL
		End
	Else
		Begin
			Select top 1 @UserChatGroupId = Id From UserChatGroup Where TaskId = @TaskId And TaskMultilevelListId = @TaskMultilevelListId
		End

	IF ISNULL(@UserChatGroupId,0) = 0
		Begin
			If @TaskMultilevelListId = 0 Begin Set @TaskMultilevelListId = NULL End
			Insert Into UserChatGroup (TaskId,TaskMultilevelListId,CreatedBy)
				Values(@TaskId,@TaskMultilevelListId, 780)
	
			Set @UserChatGroupId = IDENT_CURRENT('UserChatGroup') 

			IF OBJECT_ID('tempdb..#TaskUsers') IS NOT NULL DROP TABLE #TaskUsers   
			Create Table #TaskUsers(UserId int, Aceptance bit, CreatedOn DateTime)
			Insert Into #TaskUsers Exec GetTaskUsers @TaskId

			Insert Into UserChatGroupMember (UserChatGroupId, UserId)
				Select @UserChatGroupId, UserId From #TaskUsers
		End

	Select @UserChatGroupId As UserChatGroupId
End

Go
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserChatActivity]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[UserChatActivity](
		Id int Primary Key Identity(1,1),
		SenderUserId int foreign key references tblInstallUsers(Id), -- Used in 1-1 Chat
		ChatSeenAt DateTime Not Null Default(GetUTCDate()),
		UserChatGroupId int foreign key references UserChatGroup(Id), -- Used in Group Chat
		ReceiverUserId int foreign key references tblInstallUsers(Id), -- Last Seen Saved for This user
		CreatedOn DateTime Not Null Default(GetUTCDate())
	) 
END


Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'sp_GetMultiLevelList' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE sp_GetMultiLevelList
  END
Go
-- sp_GetMultiLevelList 535  
Create procedure [dbo].[sp_GetMultiLevelList]       
@ParentTaskId varchar(max)        
as        
begin      
 select m.*, (u.FristName + ' ' + u.LastName) as ITLeadName      
     , (u1.FristName + ' ' + u1.LastName) as UserName,      
  --   (      
  --   STUFF((SELECT ', {"Id" : "'+ CONVERT(VARCHAR(5),UserId) + '"}'                                        
  --         FROM tblTaskMultiLevelAssignedUsers as tau                        
  --         WHERE tau.TaskId = m.Id                                           
  --        FOR XML PATH('')), 1, 2, '')                                          
  --) AS TaskAssignedUserIDs,  
  UCG.Id As UserChatGroupId  
  from tblTaskMultilevelList m       
  left join tblInstallUsers u on      
  m.ITLeadId = u.Id      
  left join tblInstallUsers u1 on      
  m.UserId = u1.Id      
  Left Join UserChatGroup UCG on m.Id = UCG.TaskMultilevelListId And m.ParentTaskId = UCG.TaskId  
 where ParentTaskId in (SELECT * FROM [dbo].[SplitString](ISNULL(@ParentTaskId,m.ParentTaskId),',') )      
 --order by DisplayOrder    
end  

--use JGBS_DEV_NEW
Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'SaveLastChatSeen' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE SaveLastChatSeen
  END
Go
-- SaveLastChatSeen 535

-- select * From UserChatActivity order by chatseenat desc

CREATE procedure [dbo].[SaveLastChatSeen]
(
	@SenderUserId int = 0,
	@UserChatGroupId int = 0,
	@ReceiverUserId int
)
As      
Begin
	IF @UserChatGroupId = 0 Begin Set @UserChatGroupId = NULL End
	IF @SenderUserId = 0 Begin Set @SenderUserId = NULL End
	
	IF @UserChatGroupId IS NULL -- 1-1 Chat
		Begin
			IF Not EXISTS (Select 1 From UserChatActivity Where SenderUserId = @SenderUserId And ReceiverUserId = @ReceiverUserId)
				Begin
					Insert Into UserChatActivity (SenderUserId, UserChatGroupId, ReceiverUserId, ChatSeenAt) 
					Values (@SenderUserId, NULL, @ReceiverUserId, CONVERT(datetime, SWITCHOFFSET(GetUTCDate(), DATEPART(TZOFFSET, GetUTCDate() AT TIME ZONE 'Eastern Standard Time'))))
				End
			Else
				Begin
					Update UserChatActivity Set ChatSeenAt = CONVERT(datetime, SWITCHOFFSET(GetUTCDate(), DATEPART(TZOFFSET, GetUTCDate() AT TIME ZONE 'Eastern Standard Time')))
						Where ReceiverUserId = @ReceiverUserId And SenderUserId = @SenderUserId
				End
		End
	Else
		Begin
			IF Not EXISTS (Select 1 From UserChatActivity Where UserChatGroupId = @UserChatGroupId And ReceiverUserId = @ReceiverUserId)
				Begin
					Insert Into UserChatActivity (SenderUserId, UserChatGroupId, ReceiverUserId, ChatSeenAt) 
					Values (NULL, @UserChatGroupId, @ReceiverUserId,CONVERT(datetime, SWITCHOFFSET(GetUTCDate(), DATEPART(TZOFFSET, GetUTCDate() AT TIME ZONE 'Eastern Standard Time'))))
				End
			Else
				Begin
					Update UserChatActivity Set ChatSeenAt = CONVERT(datetime, SWITCHOFFSET(GetUTCDate(), DATEPART(TZOFFSET, GetUTCDate() AT TIME ZONE 'Eastern Standard Time')))
						Where ReceiverUserId = @ReceiverUserId And UserChatGroupId = @UserChatGroupId
				End
		End
End


Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetLastChatSeen' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetLastChatSeen
  END
Go
-- GetLastChatSeen 3797,0,901

-- select * From UserChatActivity
--truncate table UserChatActivity
CREATE procedure [dbo].[GetLastChatSeen]
(
	@SenderUserId int = 0,
	@UserChatGroupId int = 0,
	@ReceiverUserId int
)
As      
Begin
	IF @UserChatGroupId = 0 Begin Set @UserChatGroupId = NULL End
	IF @SenderUserId = 0 Begin Set @SenderUserId = NULL End
	
	IF @UserChatGroupId IS NULL
		Begin
			Select ChatSeenAt From UserChatActivity Where
				SenderUserId = @SenderUserId And ReceiverUserId = @ReceiverUserId AND UserChatGroupId IS NULL
		End
	Else
		Begin
			Select ChatSeenAt From UserChatActivity Where
				ReceiverUserId = @ReceiverUserId And UserChatGroupId = @UserChatGroupId And SenderUserId IS NULL
		End
End

-- Use JGBS_Dev_New


Go
IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetPhoneCallStatistics' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetPhoneCallStatistics
  END
Go
 ---- =============================================  
-- Author:  Jitendra Pancholi  
-- Create date: 03/30/2018
-- Description: Load all details of task for edit.  
-- =============================================  
-- GetPhoneCallStatistics 
 
CREATE PROCEDURE [dbo].[GetPhoneCallStatistics]
AS  
BEGIN
	Select Count(P.ID) As TotalOutBound, Sum(P.CallDurationInSeconds) As TotalCallDurationInSeconds, P.Mode,
	IsNull((Select Count(PP.ID) From PhoneCallLog PP Where PP.ReceiverUserId IS NOT NULL ANd PP.UserStatusWhenCalled = 1 And PP.Mode = P.Mode And PP.CallDurationInSeconds > 0),0) As TotalApplicantCalled,
	IsNull((Select Sum(PP.CallDurationInSeconds) From PhoneCallLog PP Where PP.ReceiverUserId IS NOT NULL ANd PP.UserStatusWhenCalled =1 And PP.Mode = P.Mode And PP.CallDurationInSeconds > 0),0) As TotalApplicantDuration,
	IsNull((Select Count(PP.ID) From PhoneCallLog PP Where PP.ReceiverUserId IS NOT NULL ANd PP.UserStatusWhenCalled = 10 And PP.Mode = P.Mode And PP.CallDurationInSeconds > 0),0) As TotalReferralApplicantCalled,
	IsNull((Select Sum(PP.CallDurationInSeconds) From PhoneCallLog PP Where PP.ReceiverUserId IS NOT NULL ANd PP.UserStatusWhenCalled = 10 And PP.Mode = P.Mode And PP.CallDurationInSeconds > 0),0) As TotalReferralApplicantDuration,
	IsNull((Select Count(PP.ID) From PhoneCallLog PP Where PP.ReceiverUserId IS NOT NULL ANd PP.UserStatusWhenCalled = 5 And PP.Mode = P.Mode And PP.CallDurationInSeconds > 0),0) As TotalInterviewDateCalled,
	IsNull((Select Sum(PP.CallDurationInSeconds) From PhoneCallLog PP Where PP.ReceiverUserId IS NOT NULL ANd PP.UserStatusWhenCalled = 5 And PP.Mode = P.Mode And PP.CallDurationInSeconds > 0),0) As TotalInterviewDateDuration
	From PhoneCallLog P With(NoLock) 
	Join tblInstallUsers U With(NoLock) On U.Id = P.ReceiverUserId
	Where P.CallDurationInSeconds > 0
	Group By P.Mode
	
End

Go
IF Not EXISTS (SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[PhoneScript]') AND name = 'FAQTitle')
BEGIN
	Alter Table PhoneScript Add FAQTitle NVarchar(2000)
End

Go
IF Not EXISTS (SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[PhoneScript]') AND name = 'FAQDesciption')
BEGIN
	Alter Table PhoneScript Add FAQDescription NVarchar(Max)
End

-- use JGBS_DEV_NEW
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
-- GetTaskMultilevelListItem 2324
 
CREATE PROCEDURE [dbo].[GetTaskMultilevelListItem]   
(  
	@TaskMultilevelListId int
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
	Create Table #TaskUsers(UserId int, Aceptance bit, CreatedOn DateTime)
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

	Select @Title = @Title + ISNULL(U.FristName,'') + ' ' + ISNULL(U.LastName,'') + '-' + '<a target="_blank" href="/Sr_App/ViewSalesUser.aspx?id='+Convert(Varchar(12),U.Id)+'" uid="'+Convert(Varchar(12),U.Id)+'">'+ISNULL(U.UserInstallId,'')+'</a>' + ', ' From #TaskUsers T With(NoLock) 
	Join tblInstallUsers U With(NoLock) On T.UserId = U.Id
	Order By U.Id Asc

	Set @Title = SUBSTRING(@Title, 0, LEN(@Title)) + ')'

	Select @Title As FormattedTitle,* From tblTaskMultilevelList Where Id = @TaskMultilevelListId
	/* Proper Task Title with ID */
End
