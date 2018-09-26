

DROP PROCEDURE UDP_deleteInstalluser
GO

/****** Object:  StoredProcedure [dbo].[DeleteInstallUsers]    Script Date: 03-Feb-17 9:59:43 AM ******/
SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 19 Jan 2017
-- Description:	Deletes install users.
-- =============================================
ALTER PROCEDURE [dbo].[DeleteInstallUsers]
	@IDs IDs READONLY
AS
BEGIN

	DELETE
	FROM dbo.tblInstallUsers 
	WHERE Id IN (SELECT Id FROM @IDs)
	
 END
 GO

 /****** Object:  StoredProcedure [dbo].[DeleteInstallUsers]    Script Date: 03-Feb-17 9:59:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 19 Jan 2017
-- Description:	Deactivates install users.
-- =============================================
CREATE PROCEDURE [dbo].[DeactivateInstallUsers]
	@IDs IDs READONLY,
	@DeactiveStatus Varchar(5) = '3'
AS
BEGIN
	
	UPDATE dbo.tblInstallUsers 
	SET 
		[STATUS] = @DeactiveStatus
	WHERE Id IN (SELECT Id FROM @IDs)
       
 END
 GO


CREATE TABLE tblRoles_ApplicationFeatures
(
Id INT IDENTITY(1,1) UNIQUE NOT NULL,
RoleId INT NOT NULL,
ApplicationFeatureId INT NOT NULL,
IsEnabled BIT NOT NULL,
PRIMARY KEY(RoleId, ApplicationFeatureId)
)
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 07 Feb 2017
-- Description:	Gets all application features for role.
-- =============================================
CREATE PROCEDURE [dbo].[GetApplicationFeaturesByRoleId]
	@RoleId INT
AS
BEGIN
	
	SELECT *
	FROM tblRoles_ApplicationFeatures
	WHERE RoleId = @RoleId
	ORDER BY RoleId

 END
 GO

 
/****** Object:  StoredProcedure [dbo].[sp_GetHrData]    Script Date: 07-Feb-17 10:24:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author:  Yogesh    
-- Create date: 16 Jan 2017    
-- Description: Gets statictics and records for edit user page.    
-- =============================================    
-- [sp_GetHrData] '0','0','0', '0', NULL,NULL,0,10    
ALTER PROCEDURE [dbo].[sp_GetHrData]    
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
 @RejectedStatus VARChAR(5) = '9'    
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
   RejectDetail = case when (t.Status=@RejectedStatus ) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR) + ' ' + coalesce(t.RejectionTime,'') + ' ' + '-' + coalesce(ru.LastName,'')     
         else '' end,    
   t.Email,     
   t.DesignationID,     
   ISNULL(t1.[UserInstallId] , t2.[UserInstallId]) As AddedByUserInstallId,     
   ISNULL(t1.Id,t2.Id) As AddedById ,     
   0 as 'EmpType'    
   ,NULL as [Aggregate] ,    
   t.Phone As PrimaryPhone ,     
   t.CountryCode,     
   t.Resumepath    
   --ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId    
   ,Task.TaskId AS 'TechTaskId',     
   Task.InstallId as 'TechTaskInstallId',    
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
	OUTER APPLY
	(
		SELECT TOP 1 tsk.TaskId, tsk.InstallId, ROW_NUMBER() OVER(ORDER BY u.TaskUserId DESC) AS RowNo
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
   AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))    
   AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))    
   AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))    
   AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)     
   AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)    
 )    
    
 SELECT *    
 FROM SalesUsers    
 WHERE     
  RowNumber >= @StartIndex AND     
  (    
   @PageSize = 0 OR     
   RowNumber < (@StartIndex + @PageSize)    
  )    
    
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
  AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))    
  AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))    
  AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))    
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)     
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)    
END    
GO

/****** Object:  StoredProcedure [dbo].[sp_GetHrData]    Script Date: 08-Feb-17 9:20:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author:  Yogesh    
-- Create date: 16 Jan 2017    
-- Description: Gets statictics and records for edit user page.    
-- =============================================    
-- [sp_GetHrData] '0','0','0', '0', NULL,NULL,0,10    
ALTER PROCEDURE [dbo].[sp_GetHrData]    
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
 @RejectedStatus VARChAR(5) = '9'    
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
   RejectDetail = case when (t.Status=@RejectedStatus ) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR) + ' ' + coalesce(t.RejectionTime,'') + ' ' + '-' + coalesce(ru.LastName,'')     
         else '' end,    
   t.Email,     
   t.DesignationID,     
   ISNULL(t1.[UserInstallId] , t2.[UserInstallId]) As AddedByUserInstallId,     
   ISNULL(t1.Id,t2.Id) As AddedById ,     
   0 as 'EmpType'    
   ,NULL as [Aggregate] ,    
   t.Phone As PrimaryPhone ,     
   t.CountryCode,     
   t.Resumepath  ,  
   --ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId ,   
   Task.TaskId AS 'TechTaskId',
   Task.ParentTaskId AS 'ParentTechTaskId', 
   Task.InstallId as 'TechTaskInstallId',    
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
   AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))    
   AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))    
   AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))    
   AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)     
   AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)    
 )    
    
 SELECT *    
 FROM SalesUsers    
 WHERE     
  RowNumber >= @StartIndex AND     
  (    
   @PageSize = 0 OR     
   RowNumber < (@StartIndex + @PageSize)    
  )    
    
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
  AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))    
  AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))    
  AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))    
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)     
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)    
END
GO

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---- Published on Live 02132017 -----

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[UDP_BulkInstallUser]    Script Date: 15-Feb-17 11:10:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[UDP_BulkInstallUser]
	@XMLDOC2 xml
AS
BEGIN

SET NOCOUNT ON; 

	CREATE TABLE #table_xml
	(
		FirstName varchar(50),
		LastName varchar(50),
		Email varchar(50),
		phone VARCHAR(50),
		Designation VARCHAR(50),
		Status VARCHAR(50),
		Notes VARCHAR(50),
		PrimeryTradeId int,
		SecondoryTradeId VARCHAR(50),
		Source VARCHAR(50),
		UserType VARCHAR(50),
		Email2 VARCHAR(50),
		Phone2 VARCHAR(50),
		CompanyName VARCHAR(50),
		SourceUser VARCHAR(50),
		DateSourced VARCHAR(50),
		ActionTaken VARCHAR(2)
	)


	CREATE TABLE #UploadableData
	(
		FirstName varchar(50),
		LastName varchar(50),
		Email varchar(50),
		phone VARCHAR(50),
		Designation VARCHAR(50),
		Status VARCHAR(50),
		Notes VARCHAR(50),
		PrimeryTradeId int,
		SecondoryTradeId VARCHAR(50),
		Source VARCHAR(50),
		UserType VARCHAR(50),
		Email2 VARCHAR(50),
		Phone2 VARCHAR(50),
		CompanyName VARCHAR(50),
		SourceUser VARCHAR(50),
		DateSourced VARCHAR(50),
		ActionTaken VARCHAR(2)
	)


	DECLARE @rowexistcnt INT

	INSERT INTO #table_xml
		(FirstName,LastName,Email,phone,[Designation],[Status],[Notes],[PrimeryTradeId],[SecondoryTradeId],[Source],[UserType],[Email2],[Phone2],[CompanyName],[SourceUser],[DateSourced] ,ActionTaken)
	SELECT
		   [Table].[Column].value('(firstname/text()) [1]','VARCHAR(50)') AS FirstName,
		   [Table].[Column].value('(lastname/text()) [1]','VARCHAR(50)') AS LastName,
		   [Table].[Column].value('(Email/text()) [1]','VARCHAR(50)') AS Email,
		   [Table].[Column].value('(phone/text()) [1]','VARCHAR(50)') AS phone,
		   [Table].[Column].value('(Designation/text()) [1]','VARCHAR(50)') AS Designation,
		   [Table].[Column].value('(status/text()) [1]','VARCHAR(20)') AS status,
		   [Table].[Column].value('(Notes/text()) [1]','VARCHAR(50)') AS Notes,
		   [Table].[Column].value('(PrimeryTradeId/text()) [1]','int') AS PrimeryTradeId,
		   [Table].[Column].value('(SecondoryTradeId/text()) [1]','VARCHAR(50)') AS SecondoryTradeId,
		   [Table].[Column].value('(Source/text()) [1]','VARCHAR(50)') AS Source,
		   [Table].[Column].value('(UserType/text()) [1]','VARCHAR(50)') AS EmaUserType,
		   [Table].[Column].value('(Email2/text()) [1]','VARCHAR(50)') AS Email2,
		   [Table].[Column].value('(Phone2/text()) [1]','VARCHAR(50)') AS Phone2,
		   [Table].[Column].value('(CompanyName/text()) [1]','VARCHAR(50)') AS CompanyName,
		   [Table].[Column].value('(SourceUser/text()) [1]','VARCHAR(50)') AS SourceUser,
		   [Table].[Column].value('(DateSourced/text()) [1]','VARCHAR(50)') AS DateSourced ,
		   'U'
      FROM
			@XMLDOC2.nodes('/ArrayOfUser1/user1')AS [Table]([Column])	

	  --select @rowexistcnt = count(*) from tblInstallUsers inner join #table_xml on  tblInstallUsers.Phone =#table_xml.phone or tblInstallUsers.Email = #table_xml.Email 
	  SELECT @rowexistcnt = count(*) 
	  FROM #table_xml 
	  WHERE phone NOT IN (
							SELECT phone 
							FROM tblInstallUsers 
							WHERE phone != ''
						) OR 
			Email NOT IN (	
							SELECT Email 
							FROM tblInstallUsers 
							WHERE Email != ''
						)

	  --insert into #UploadableData
			--(FirstName,LastName,Email,phone,Designation,Status,Notes,PrimeryTradeId,SecondoryTradeId,Source,UserType,Email2,Phone2,CompanyName,SourceUser,DateSourced)
	  --select FirstName,LastName,Email,phone,Designation,Status,Notes,PrimeryTradeId,SecondoryTradeId,Source,UserType,Email2,Phone2,CompanyName,SourceUser,DateSourced
	  ----select #table_xml.FirstName,#table_xml.LastName,#table_xml.Email,#table_xml.phone,#table_xml.Designation,#table_xml.Status,#table_xml.Notes,#table_xml.PrimeryTradeId,#table_xml.SecondoryTradeId,#table_xml.Source,#table_xml.UserType,#table_xml.Email2,#table_xml.Phone2,#table_xml.CompanyName,#table_xml.SourceUser,#table_xml.DateSourced 
	  
	  --from #table_xml 
	  --  #table_xml where 
			--	phone IN (select phone from tblInstallUsers where phone != '') or 
			--	Email IN (select Email from tblInstallUsers where Email != '')

		--inner join tblInstallUsers on  #table_xml.phone = tblInstallUsers.Phone  
		--or #table_xml.Email = tblInstallUsers.Email 

	IF (@rowexistcnt>0)
	BEGIN
		UPDATE #table_xml 
		SET 
			ActionTaken = 'I'
		WHERE 
			phone NOT IN (select phone from tblInstallUsers where phone != '') or 
			Email NOT IN (select Email from tblInstallUsers where Email != '')

		INSERT INTO tblInstallUsers
	  			 ([FristName],[LastName],[Email],[Phone],[DesignationId],[Status],[Notes],[PrimeryTradeId],[SecondoryTradeId],[Source],[UserType],[Email2],[Phone2],[CompanyName],[SourceUser],[DateSourced])
		SELECT FirstName,LastName,Email,phone,CAST(Designation AS INT),Status,Notes,PrimeryTradeId,SecondoryTradeId,Source,UserType,Email2,Phone2,CompanyName,SourceUser,DateSourced 
		FROM #table_xml 
		WHERE phone NOT IN(select phone from tblInstallUsers where phone != '') 
				OR 
			Email NOT IN(select Email from tblInstallUsers where Email != '')

		SELECT * 
		FROM #table_xml
	END
	ELSE
	BEGIN
		SELECT * FROM #table_xml
		--select * from #UploadableData 
		--inner join #table_xml on  tblInstallUsers.Phone =#table_xml.phone --or tblInstallUsers.Email =user1.Email 
	END

	RETURN;
END
GO

/****** Object:  StoredProcedure [dbo].[GetAllAnnualEvent]    Script Date: 16-Feb-17 8:06:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[GetAllAnnualEvent] 
	-- Add the parameters for the stored procedure here
	@Year varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--select a.ID,a.EventName,a.EventDate,a.EventAddedBy,a.ApplicantId,u.Username,i.FristName,i.LastName,i.Phone
	--from tbl_AnnualEvents a INNER JOIN  tblUsers u ON u.Id = a.EventAddedBy LEFT JOIN tblInstallUsers i ON i.Id = a.ApplicantId
	--where DATEPART(yyyy,EventDate)=@Year

	SELECT 
		a.ID,a.EventName,a.EventDate,a.EventAddedBy,a.ApplicantId,u.Username,i.FristName,i.LastName,i.Phone,i.Id,
		i.Status, i.Designation, i.Email, Task.TaskId , ISNULL(Task.InstallId,'') AS InstallId ,
		STUFF
		(
			(SELECT  CAST(', ' + u.FristName as VARCHAR) AS Name
			FROM tbl_AnnualEventAssignedUsers tu
				INNER JOIN tblInstallUsers u ON tu.UserId = u.Id
			WHERE tu.EventId = a.Id
			FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
			,1
			,2
			,' '
		) AS AssignedUserFristNames
	FROM 
		tbl_AnnualEvents a 
		OUTER APPLY 
		(
			SELECT TOP 1 Id, Username, FirstName AS FristName
			FROM tblUsers
			WHERE tblUsers.id = a.EventAddedBy AND ISNULL(a.IsInstallUser,0) = 0

			UNION

			SELECT TOP 1  Id, Email AS Username, FristName
			FROM tblInstallUsers
			WHERE tblInstallUsers.id = a.EventAddedBy AND ISNULL(a.IsInstallUser,1) = 1
		) u --INNER JOIN  tblUsers u ON u.Id = a.EventAddedBy 
		LEFT JOIN tblInstallUsers i ON i.Id = a.ApplicantId 
		OUTER APPLY
		(
			SELECT TOP 1 tTask.TaskId, tTask.InstallId, ROW_NUMBER() OVER (ORDER BY TaskAss.TaskUserId DESC) AS Row_No
			FROM tblTaskAssignedUsers TaskAss
					LEFT JOIN tblTask tTask ON tTask.TaskId = TaskAss.TaskId
			WHERE TaskAss.UserId = i.Id
		) Task
	WHERE 
		a.EventName IS NOT NULL AND 
		a.EventName !='InterViewDetails' AND 
		DATEPART(yyyy,EventDate)=@Year
	
	UNION 

	SELECT 
		a.ID,( a.EventName + '  '+u.Username + ' '+i.Designation+  '  ' + i.Phone +'   '+i.FristName) as EventName,
		EventDate = CONVERT(datetime,EventDate) + CONVERT(datetime,InterviewTime),a.EventAddedBy,a.ApplicantId,u.Username,i.FristName,i.LastName,i.Phone,i.Id,
		i.Status, i.Designation, i.Email, Task.TaskId , ISNULL(Task.InstallId,'') AS InstallId,
		STUFF
		(
			(SELECT  CAST(', ' + u.FristName as VARCHAR) AS Name
			FROM tbl_AnnualEventAssignedUsers tu
				INNER JOIN tblInstallUsers u ON tu.UserId = u.Id
			WHERE tu.EventId = a.Id
			FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
			,1
			,2
			,' '
		) AS AssignedUserFristNames
	FROM 
		tbl_AnnualEvents a 
		OUTER APPLY 
		(
			SELECT TOP 1 Id, Username, FirstName AS FristName
			FROM tblUsers
			WHERE tblUsers.id = a.EventAddedBy AND ISNULL(a.IsInstallUser,0) = 0

			UNION

			SELECT TOP 1  Id, Email AS Username, FristName
			FROM tblInstallUsers
			WHERE tblInstallUsers.id = a.EventAddedBy AND ISNULL(a.IsInstallUser,1) = 1
		) u --INNER JOIN  tblUsers u ON u.Id = a.EventAddedBy 
		LEFT JOIN tblInstallUsers i ON i.Id = a.ApplicantId
		OUTER APPLY
		(
			SELECT TOP 1 tTask.TaskId, tTask.InstallId, ROW_NUMBER() OVER (ORDER BY TaskAss.TaskUserId DESC) AS Row_No
			FROM tblTaskAssignedUsers TaskAss
					LEFT JOIN tblTask tTask ON tTask.TaskId = TaskAss.TaskId
			WHERE TaskAss.UserId = i.Id
		) Task
	WHERE 
		a.EventName='InterViewDetails' AND 
		DATEPART(yyyy,EventDate)=@Year

END
GO

/****** Object:  StoredProcedure [dbo].[GetHRCalendar]    Script Date: 16-Feb-17 8:23:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[GetHRCalendar]
	-- Add the parameters for the stored procedure here
	@Year varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT 
	--	a.ID,( a.EventName + '  '+u.Username + ' '+i.FristName+  '  ' + i.Phone +'   '+i.Designation) as EventName,
	--	EventDate = CONVERT(Varchar(50),EventDate)+' '+ CONVERT(varchar(50),InterviewTime),a.EventAddedBy,a.ApplicantId,u.Username,i.FristName,i.LastName,i.Phone
	--FROM 
	--	dbo.tbl_AnnualEvents a 
	--		INNER JOIN  dbo.tblUsers u ON u.Id = a.EventAddedBy LEFT JOIN dbo.tblInstallUsers i ON i.Id = a.ApplicantId
	--WHERE 
	--	a.EventName='InterViewDetails' AND 
	--	DATEPART(yyyy,EventDate)=@Year

	SELECT 
		a.ID,( a.EventName + '  '+u.Username + ' '+i.Designation+  '  ' + i.Phone +'   '+i.FristName) as EventName,
		EventDate = CONVERT(datetime,EventDate) + CONVERT(datetime,InterviewTime),a.EventAddedBy,a.ApplicantId,u.Username,i.FristName,i.LastName,i.Phone,i.Id,
		i.Status, i.Designation, i.Email, Task.TaskId , ISNULL(Task.InstallId,'') AS InstallId,
		STUFF
		(
			(SELECT  CAST(', ' + u.FristName as VARCHAR) AS Name
			FROM tbl_AnnualEventAssignedUsers tu
				INNER JOIN tblInstallUsers u ON tu.UserId = u.Id
			WHERE tu.EventId = a.Id
			FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
			,1
			,2
			,' '
		) AS AssignedUserFristNames
	FROM 
		tbl_AnnualEvents a 
		OUTER APPLY 
		(
			SELECT TOP 1 Id, Username, FirstName AS FristName
			FROM tblUsers
			WHERE tblUsers.id = a.EventAddedBy AND ISNULL(a.IsInstallUser,0) = 0

			UNION

			SELECT TOP 1  Id, Email AS Username, FristName
			FROM tblInstallUsers
			WHERE tblInstallUsers.id = a.EventAddedBy AND ISNULL(a.IsInstallUser,1) = 1
		) u --INNER JOIN  tblUsers u ON u.Id = a.EventAddedBy 
		LEFT JOIN tblInstallUsers i ON i.Id = a.ApplicantId
		OUTER APPLY
		(
			SELECT TOP 1 tTask.TaskId, tTask.InstallId, ROW_NUMBER() OVER (ORDER BY TaskAss.TaskUserId DESC) AS Row_No
			FROM tblTaskAssignedUsers TaskAss
					LEFT JOIN tblTask tTask ON tTask.TaskId = TaskAss.TaskId
			WHERE TaskAss.UserId = i.Id
		) Task
	WHERE 
		a.EventName='InterViewDetails' AND 
		DATEPART(yyyy,EventDate)=@Year

END
GO

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---- Published on Live 02162017 -----

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [dbo].[UDP_BulkInstallUser]    Script Date: 21-Feb-17 10:31:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 21 Feb 2017
-- Description:	Bulk upload install users.
-- =============================================
ALTER procedure [dbo].[UDP_BulkInstallUser]
	@XMLDOC2 xml
AS
BEGIN

SET NOCOUNT ON; 

	-- all records from xml
	CREATE TABLE #table_xml
	(
		DesignationId INT,
		Status VARCHAR(50),
		DateSourced VARCHAR(50),
		Source VARCHAR(50),
		SourceId int,
		FirstName varchar(50),
		LastName varchar(50),
		Email varchar(50),
		phone VARCHAR(50),
		phonetype char(15),
		phone2 VARCHAR(50),
		phone2type char(15),
		Address	varchar(100),
		Zip	varchar	(10),
		State	varchar	(30),
		City	varchar	(30),
		SuiteAptRoom	varchar(10),
		Notes VARCHAR(50),

		PrimeryTradeId int,
		SecondoryTradeId VARCHAR(50),
		UserType VARCHAR(50),
		SourceUser VARCHAR(50),
		ActionTaken VARCHAR(2)
	)

	-- valid data from xml
	CREATE TABLE #UploadableData
	(
		DesignationId INT,
		Status VARCHAR(50),
		DateSourced VARCHAR(50),
		Source VARCHAR(50),
		SourceId int,
		FirstName varchar(50),
		LastName varchar(50),
		Email varchar(50),
		phone VARCHAR(50),
		phonetype char(15),
		phone2 VARCHAR(50),
		phone2type char(15),
		Address	varchar(100),
		Zip	varchar	(10),
		State	varchar	(30),
		City	varchar	(30),
		SuiteAptRoom	varchar(10),
		Notes VARCHAR(50),

		PrimeryTradeId int,
		SecondoryTradeId VARCHAR(50),
		UserType VARCHAR(50),
		SourceUser VARCHAR(50),
		ActionTaken VARCHAR(2)
	)


	DECLARE @rowexistcnt INT

	INSERT INTO #table_xml
		(
			DesignationId
			,Status
			,DateSourced
			,Source
			,SourceId
			,FirstName
			,LastName
			,Email
			,phone
			,phonetype
			,phone2
			,phone2type
			,Address
			,Zip
			,State
			,City
			,SuiteAptRoom
			,Notes

			,PrimeryTradeId
			,SecondoryTradeId
			,UserType
			,SourceUser
			,ActionTaken
		)
	SELECT
		[Table].[Column].value('(DesignationId/text()) [1]','INT')
		,[Table].[Column].value('(status/text()) [1]','VARCHAR(50)')
		,[Table].[Column].value('(DateSourced/text()) [1]','VARCHAR(50)')
		,[Table].[Column].value('(Source/text()) [1]','VARCHAR(50)')
		,[Table].[Column].value('(SourceId/text()) [1]','INT')
		,[Table].[Column].value('(firstname/text()) [1]','VARCHAR(50)')
		,[Table].[Column].value('(lastname/text()) [1]','VARCHAR(50)')
		,[Table].[Column].value('(Email/text()) [1]','VARCHAR(50)')
		,[Table].[Column].value('(phone/text()) [1]','VARCHAR(50)')
		,[Table].[Column].value('(phonetype/text()) [1]','VARCHAR(50)')
		,[Table].[Column].value('(phone2/text()) [1]','VARCHAR(50)')
		,[Table].[Column].value('(phone2type/text()) [1]','VARCHAR(50)')
		,[Table].[Column].value('(address/text()) [1]','VARCHAR(50)')
		,[Table].[Column].value('(zip/text()) [1]','VARCHAR(50)')
		,[Table].[Column].value('(state/text()) [1]','VARCHAR(50)')
		,[Table].[Column].value('(city/text()) [1]','VARCHAR(50)')
		,[Table].[Column].value('(SuiteAptRoom/text()) [1]','VARCHAR(50)')
		,[Table].[Column].value('(Notes/text()) [1]','VARCHAR(50)')

		,[Table].[Column].value('(PrimeryTradeId/text()) [1]','int')
		,[Table].[Column].value('(SecondoryTradeId/text()) [1]','VARCHAR(50)')
		,[Table].[Column].value('(UserType/text()) [1]','VARCHAR(50)')
		,[Table].[Column].value('(SourceUser/text()) [1]','VARCHAR(50)')
		,'U'
    FROM
		@XMLDOC2.nodes('/ArrayOfUser1/user1')AS [Table]([Column])	


	SELECT @rowexistcnt = count(*) 
	FROM #table_xml 
	WHERE 
		phone NOT IN (
						SELECT phone 
						FROM tblInstallUsers 
						WHERE phone != ''
					) OR 
		Email NOT IN (	
						SELECT Email 
						FROM tblInstallUsers 
						WHERE Email != ''
					)

	  --insert into #UploadableData
			--(FirstName,LastName,Email,phone,Designation,Status,Notes,PrimeryTradeId,SecondoryTradeId,Source,UserType,Email2,Phone2,CompanyName,SourceUser,DateSourced)
	  --select FirstName,LastName,Email,phone,Designation,Status,Notes,PrimeryTradeId,SecondoryTradeId,Source,UserType,Email2,Phone2,CompanyName,SourceUser,DateSourced
	  ----select #table_xml.FirstName,#table_xml.LastName,#table_xml.Email,#table_xml.phone,#table_xml.Designation,#table_xml.Status,#table_xml.Notes,#table_xml.PrimeryTradeId,#table_xml.SecondoryTradeId,#table_xml.Source,#table_xml.UserType,#table_xml.Email2,#table_xml.Phone2,#table_xml.CompanyName,#table_xml.SourceUser,#table_xml.DateSourced 
	  
	  --from #table_xml 
	  --  #table_xml where 
			--	phone IN (select phone from tblInstallUsers where phone != '') or 
			--	Email IN (select Email from tblInstallUsers where Email != '')

		--inner join tblInstallUsers on  #table_xml.phone = tblInstallUsers.Phone  
		--or #table_xml.Email = tblInstallUsers.Email 

	IF (@rowexistcnt > 0)
	BEGIN
		UPDATE #table_xml 
		SET 
			ActionTaken = 'I'
		WHERE 
			phone NOT IN (select phone from tblInstallUsers where phone != '') or 
			Email NOT IN (select Email from tblInstallUsers where Email != '')

		INSERT INTO tblInstallUsers
	  		(
				[DesignationId]
				,[Status]
				,[DateSourced]
				,Source
				,SourceId
				,FristName
				,LastName
				,Email
				,phone
				,phonetype
				,phone2
				--,phone2type
				,Address
				,Zip
				,State
				,City
				,SuiteAptRoom
				,Notes

				,PrimeryTradeId
				,SecondoryTradeId
				,UserType
				,SourceUser
			)

		SELECT 
				DesignationId
				,Status
				,DateSourced
				,Source
				,SourceId
				,FirstName
				,LastName
				,Email
				,phone
				,phonetype
				,phone2
				--,phone2type
				,Address
				,Zip
				,State
				,City
				,SuiteAptRoom
				,Notes

				,PrimeryTradeId
				,SecondoryTradeId
				,UserType
				,SourceUser
		FROM #table_xml 
		WHERE phone NOT IN(select phone from tblInstallUsers where phone != '') 
				OR 
			Email NOT IN(select Email from tblInstallUsers where Email != '')

		SELECT * 
		FROM #table_xml
	END
	ELSE
	BEGIN
		SELECT * FROM #table_xml
	END

	RETURN;
END
GO

/****** Object:  StoredProcedure [dbo].[GetHTMLTemplateMasters]    Script Date: 22-Feb-17 10:25:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Yogesh  
-- Create date: 27 Jan 2017  
-- Description: Gets all Master HTMLTemplates.  
-- =============================================  
ALTER PROCEDURE [dbo].[GetHTMLTemplateMasters]  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
 SELECT   
   [Id]  
   ,[Name]  
   ,[Subject]  
   ,[Header]  
   ,[Body]  
   ,[Footer]  
   ,[DateUpdated]  
 FROM tblHTMLTemplatesMaster
 WHERE Id IN (1,36,60,69,70,71,72,73,74)   
 ORDER BY Id ASC  
  
END  
GO


/****** Object:  StoredProcedure [dbo].[SP_CheckNewUserFromOtherSite]    Script Date: 22-Feb-17 11:03:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  Yogesh  
-- Create date: 22 Feb 2017  
-- Description: Checks if a user is new or not, by comparing the pwd with default pwd.
-- =============================================  
ALTER PROCEDURE [dbo].[SP_CheckNewUserFromOtherSite] 
	@userEmail VARCHAR(50), 
	@userID INT = 0,
	@DefaultPassWord VARCHAR(50)
AS
BEGIN

	DECLARE @IsNewUser NVARCHAR(10) = 'NO';
	
	IF EXISTS (
				SELECT Id 
				FROM tblInstallUsers 
				WHERE 
					ID = @userID
					AND  Email = @userEmail
					AND  Password = @DefaultPassWord
			  )
	BEGIN
		SET  @IsNewUser	 ='YES'
	END

	SELECT @IsNewUser
END
GO


UPDATE tblHTMLTemplatesMaster
SET
	Subject = '*Interview Date Reminder -- JMGrove -Construction & Supply',
	Header = '<div><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/header.jpg" /></div>
<div><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/logo.gif" /></div>',
	Body = '<p class="MsoNormal">Dear #name#,Welcome to JMGrove Construction &amp; SupplyLLC. I would like to invite you an informational interview soon to discuss the position of: #Designation#.<span style="font-size: 10pt; font-family: verdana, sans-serif;"><o:p /></span></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">You will be meeting&nbsp;at:<o:p /></span></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;72 E.Lancaster Ave,&nbsp;<o:p /></span></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Malvern Pa,19355<o:p /></span></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">Feel free to browse our family of companies and our about uspage for more information. If you have any questions or need help locating theoffice, feel free to contact me on my cell phone 717-669-1930<o:p /></span></p>
<p class="MsoNormal"><b><u><span style="font-size: 10pt; font-family: verdana, sans-serif;">Directions &amp; Temporary Parking</span></u></b><span style="font-size: 10pt; font-family: verdana, sans-serif;">:&nbsp;Theinterview location is at our future Corporate office (72 E. Lancaster Ave,Malvern Pa, 19355). It is a commercial new construction site, and the interviewwill be&nbsp;conducted&nbsp;in our construction trailer on site. (See attached)<o:p /></span></p>
<p class="MsoNormal" style="margin-bottom: 0.0001pt;"><span style="font-size: 10pt; font-family: verdana, sans-serif;">&nbsp;</span></p>
<p></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">&nbsp;located on the shoulder of the road in front of the&quot;Harron Building - 70 E. Lancaster Ave&quot; and between &quot;Sunrise ofPaoli: Senior Living center - 324 E Lancaster Ave&quot; and across from&quot;Extra Space Storage- 65 E Lancaster Ave&quot; (Please see attached)<o:p /></span></p>
<p><br />
</p>',
	Footer = '<p>J.M. Grove - Construction &amp; Supply <br />
<a href="jmgroveconstruction.com">jmgroveconstruction.com </a><br />
<a href="http://jmgrovebuildingsupply.com/"> http://jmgrovebuildingsupply.com/</a><br />
<a href="http://web.jmgrovebuildingsupply.com/login.aspx">http://web.jmgrovebuildingsupply.com/login.aspx</a><br />
<a href="http://jmgroverealestate.com/">http://jmgroverealestate.com/</a><br />
<br />
 72 E Lancaster Ave<br />
Malvern, Pa 19355<br />
Human Resources<br />
Office:(215) 274-5182 Ext. 4<br />
<a href="mailto:Hr@jmgroveconstruction.com">Hr@jmgroveconstruction.com </a></p>
<div><a href="https://www.facebook.com/JMGrove1com/"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/fb.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/twitter_zpsiiplyhiq.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/tw.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/236e0d0b-832c-4543-81a6-f6c460d302f0_zpsl4nh3ane.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/gpls.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/pinterest_zpspioq6pve.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/pint.png" /></a><br />
 <a href="http://s49.photobucket.com/user/jmg1/media/twitter_zpsiiplyhiq.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/hbt.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/youtube_zpsxyhfmm1b.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/yt.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/c3894afd-7a37-43e2-917c-5ffb7a5036a2_zpschul0pqd.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/houzz.png" /></a> <a href="http://s49.photobucket.com/user/jmg1/media/4478596b-67f4-444e-992a-624af3e56255_zpsoi8p1uyv.jpg.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/linkin.jpg" /></a></div>
<div><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/footer.png" /></div>'

WHERE ID IN (73, 74)
GO

/****** Object:  StoredProcedure [dbo].[UDP_GETInstallUserDetails]    Script Date: 23-Feb-17 9:44:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  Yogesh  
-- Create date: 23 Feb 2017  
-- Updated By : Bhavik J. Vaishnani
--					 Added CountryCode
-- Updated By : Yogesh
--					Added designation join to support new as well as old structure.
-- Description: Get an install user by id.
-- =============================================
ALTER PROCEDURE [dbo].[UDP_GETInstallUserDetails]
	@id int
As 
BEGIN

	SELECT 
		u.Id,FristName,Lastname,Email,[Address], ISNULL(d.DesignationName, Designation) AS Designation,
		[Status],[Password],Phone,Picture,Attachements,zip,[state],city,
		Bussinessname,SSN,SSN1,SSN2,[Signature],DOB,Citizenship,' ',
		EIN1,EIN2,A,B,C,D,E,F,G,H,[5],[6],[7],maritalstatus,PrimeryTradeId,SecondoryTradeId,Source,Notes,StatusReason,GeneralLiability,PCLiscense,WorkerComp,HireDate,TerminitionDate,WorkersCompCode,NextReviewDate,EmpType,LastReviewDate,PayRates,ExtraEarning,ExtraEarningAmt,PayMethod,Deduction,DeductionType,AbaAccountNo,AccountNo,AccountType,PTradeOthers,
		STradeOthers,DeductionReason,InstallId,SuiteAptRoom,FullTimePosition,ContractorsBuilderOwner,MajorTools,DrugTest,ValidLicense,TruckTools,PrevApply,LicenseStatus,CrimeStatus,StartDate,SalaryReq,Avialability,ResumePath,skillassessmentstatus,assessmentPath,WarrentyPolicy,CirtificationTraining,businessYrs,underPresentComp,websiteaddress,PersonName,PersonType,CompanyPrinciple,UserType,Email2,Phone2,CompanyName,SourceUser,DateSourced,InstallerType,BusinessType,CEO,LegalOfficer,President,Owner,AllParteners,MailingAddress,Warrantyguarantee,WarrantyYrs,MinorityBussiness,WomensEnterprise,InterviewTime,CruntEmployement,CurrentEmoPlace,LeavingReason,CompLit,FELONY,shortterm,LongTerm,BestCandidate,TalentVenue,Boardsites,NonTraditional,ConSalTraning,BestTradeOne,BestTradeTwo,BestTradeThree
		,aOne,aOneTwo,bOne,cOne,aTwo,aTwoTwo,bTwo,cTwo,aThree,aThreeTwo,bThree,cThree,TC,ExtraIncomeType,RejectionDate ,UserInstallId
        ,PositionAppliedFor, PhoneExtNo, PhoneISDCode ,DesignationID, CountryCode
		,NameMiddleInitial , IsEmailPrimaryEmail, IsPhonePrimaryPhone, IsEmailContactPreference, IsCallContactPreference, IsTextContactPreference, IsMailContactPreference, d.ID AS DesignationId
	
	FROM tblInstallUsers u 
			LEFT JOIN tbl_Designation d ON u.DesignationID = d.ID

	WHERE u.ID=@id

END
GO


/****** Object:  StoredProcedure [dbo].[UDP_GetInstallerUserDetailsByLoginId]    Script Date: 23-Feb-17 10:38:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  Yogesh  
-- Create date: 23 Feb 2017
-- Updated By : Yogesh
--					Added applicant status to allow applicant to login.
-- Description: Get an install user by email and status.
-- =============================================
ALTER ProcEDURE [dbo].[UDP_GetInstallerUserDetailsByLoginId]
	@loginId varchar(50) ,
	@ActiveStatus varchar(5) = '1',
	@ApplicantStatus varchar(5) = '2',
	@InterviewDateStatus varchar(5) = '5',
	@OfferMadeStatus varchar(5) = '6'
AS
BEGIN
	
	SELECT Id,FristName,Lastname,Email,Address,Designation,[Status],
		[Password],[Address],Phone,Picture,Attachements,usertype , Picture,IsFirstTime,DesignationID
	FROM tblInstallUsers 
	WHERE 
		Email = @loginId AND 
		(
			[Status] = @ActiveStatus OR 
			[Status] = @ApplicantStatus OR
			[Status] = @OfferMadeStatus OR 
			[Status] = @InterviewDateStatus
		)

	--# This query does not make sense, the guy was really stupid.
	/*SELECT Id,FristName,Lastname,Email,Address,Designation,[Status],
		[Password],[Address],Phone,Picture,Attachements,usertype 
	from tblInstallUsers 
	where (Email = @loginId and Status='Active')  OR 
	(Email = @loginId AND (Designation = 'SubContractor' OR Designation='Installer') AND 
	(Status='OfferMade' OR Status='Offer Made' OR Status='Active'))*/
END
GO


/****** Object:  StoredProcedure [dbo].[UDP_IsValidInstallerUser]    Script Date: 23-Feb-17 10:43:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  Yogesh  
-- Create date: 23 Feb 2017
-- Updated By : Yogesh
--					Added applicant status to allow applicant to login.
-- Description: Get an install user by email, pwd and status.
-- =============================================
ALTER ProcEDURE [dbo].[UDP_IsValidInstallerUser]
	@userid varchar(50),
	@password varchar(50),
	@ActiveStatus varchar(5) = '1',
	@ApplicantStatus varchar(5) = '2',
	@InterviewDateStatus varchar(5) = '5',
	@OfferMadeStatus varchar(5) = '6',
	@result int output
AS
BEGIN
	
	IF EXISTS(
				SELECT Id 
				FROM tblInstallUsers 
				WHERE 
					Email = @userid AND 
					Password = @password AND 
					  (
						[Status] = @ActiveStatus OR 
						[Status] = @ApplicantStatus OR 
						[Status] = @InterviewDateStatus OR 
						[Status] = @OfferMadeStatus
					  )
			)
	BEGIN
		SET @result ='1'
	END
	ELSE
	BEGIN
		SET @result='0'
	END

	RETURN @result

END
GO

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---- Published on Live 02242017 -----

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[sp_GetHrData]    Script Date: 01-Mar-17 9:42:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author:  Yogesh    
-- Create date: 16 Jan 2017    
-- Description: Gets statictics and records for edit user page.    
-- =============================================    
-- [sp_GetHrData] '0','0','0', '0', NULL,NULL,0,10    
ALTER PROCEDURE [dbo].[sp_GetHrData]    
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
   RejectDetail = case when (t.Status=@RejectedStatus ) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR) + ' ' + coalesce(t.RejectionTime,'') + ' ' + '-' + coalesce(ru.LastName,'')     
         else '' end,    
   t.Email,     
   t.DesignationID,     
   ISNULL(t1.[UserInstallId] , t2.[UserInstallId]) As AddedByUserInstallId,     
   ISNULL(t1.Id,t2.Id) As AddedById ,     
   0 as 'EmpType'    
   ,NULL as [Aggregate] ,    
   t.Phone As PrimaryPhone ,     
   t.CountryCode,     
   t.Resumepath  ,  
   --ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId ,   
   Task.TaskId AS 'TechTaskId',
   Task.ParentTaskId AS 'ParentTechTaskId', 
   Task.InstallId as 'TechTaskInstallId',    
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
   AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))    
   AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)     
   AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)    
 )    
    
 SELECT *    
 FROM SalesUsers    
 WHERE     
  RowNumber >= @StartIndex AND     
  (    
   @PageSize = 0 OR     
   RowNumber < (@StartIndex + @PageSize)    
  )    
    
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
GO

/****** Object:  StoredProcedure [dbo].[sp_FilterHrData]    Script Date: 01-Mar-17 10:40:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_FilterHrData]
	@status nvarchar(250)='',
	@designation nvarchar(500)='',
	@fromdate date = NULL,
	@todate date
AS
BEGIN
	
	SELECT t.Id,t.FristName, t.LastName,t.Designation,t.Status ,t.Source, ISNULL(U.Username,'')  AS AddedBy, t.CreatedDateTime 
	FROM tblInstallUsers t 
		LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
		LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
	WHERE t.Status=@status 
		AND 
			(
				t.Designation=(Case When @designation = 'ALL' Then t.Designation Else @designation End)
				OR
				Convert(Nvarchar(max),t.DesignationID)=(Case When @designation IN ('All','0') Then t.DesignationID Else @designation End)
			)
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@fromdate, t.CreatedDateTime)  as date) 
		AND CAST (t.CreatedDateTime  as date) <= CAST( @todate  as date)
	
END
GO

/****** Object:  StoredProcedure [dbo].[sp_GetActiveUserContractor]    Script Date: 01-Mar-17 11:37:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_GetActiveUserContractor]
	@action nvarchar(5)=null,    
	@ActiveStatus VARChAR(5) = '1'  
AS
BEGIN
	IF(@action='1')
	BEGIN
		SELECT 
				t.Id,t.FristName, t.LastName,t.Designation,t.Status ,t.Source, ISNULL(U.Username,'')  AS AddedBy, t.CreatedDateTime,t.notes 
		FROM tblInstallUsers t LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
				LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
		WHERE t.status = @ActiveStatus
	END	
	ELSE IF(@action='2')
	BEGIN
		SELECT t.Id,t.FristName, t.LastName,t.Designation,t.Status ,t.Source, ISNULL(U.Username,'')  AS AddedBy, t.CreatedDateTime,t.notes 
		FROM tblInstallUsers t LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
				LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
		WHERE t.status = @ActiveStatus and (t.Designation='SubContractor' OR t.Designation='CommercialOnly')
	END	
END
GO


ALTER TABLE tblHTMLTemplatesMaster
ADD [Type] TINYINT DEFAULT 1

UPDATE tblHTMLTemplatesMaster
SET [Type] = 1
WHERE ID NOT IN (7, 50, 60)
GO

UPDATE tblHTMLTemplatesMaster
SET [Type] = 2
WHERE ID IN (7, 50, 60)
GO


/****** Object:  StoredProcedure [dbo].[GetHTMLTemplateMasterById]    Script Date: 03-Mar-17 8:50:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 27 Jan 2017
-- Description:	Gets a Master HTMLTemplate.
-- =============================================
ALTER PROCEDURE [dbo].[GetHTMLTemplateMasterById]
	@Id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT *
	FROM tblHTMLTemplatesMaster 
	WHERE Id = @Id

END
GO


/****** Object:  StoredProcedure [dbo].[GetHTMLTemplateMasters]    Script Date: 03-Mar-17 8:52:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Yogesh  
-- Create date: 27 Jan 2017  
-- Description: Gets all Master HTMLTemplates.  
-- =============================================  
ALTER PROCEDURE [dbo].[GetHTMLTemplateMasters]  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
 SELECT *
 FROM tblHTMLTemplatesMaster
 WHERE Id IN (1, 7, 12, 28, 36, 41, 48, 50, 57, 58, 60,69,70,71,72,73,74)
 ORDER BY Id ASC  
  
END  
GO


/****** Object:  StoredProcedure [dbo].[GetHTMLTemplates]    Script Date: 03-Mar-17 8:55:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 11 Jan 2017
-- Description:	Gets all HTMLTemplates
-- =============================================
ALTER PROCEDURE [dbo].[GetHTMLTemplates]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT *
	FROM tblHTMLTemplatesMaster 
	ORDER BY Id ASC

END
GO


UPDATE tblHTMLTemplatesMaster
SET
Subject = 'Deactive Auto Email',
Header = '<div><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/header.jpg" /></div>
<div><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/logo.gif" /></div>',
Body = '',
Footer = '<p>J.M. Grove - Construction &amp; Supply <br />
<a href="jmgroveconstruction.com">jmgroveconstruction.com </a><br />
<a href="http://jmgrovebuildingsupply.com/"> http://jmgrovebuildingsupply.com/</a><br />
<a href="http://web.jmgrovebuildingsupply.com/login.aspx">http://web.jmgrovebuildingsupply.com/login.aspx</a><br />
<a href="http://jmgroverealestate.com/">http://jmgroverealestate.com/</a><br />
<br />
 72 E Lancaster Ave<br />
Malvern, Pa 19355<br />
Human Resources<br />
Office:(215) 274-5182 Ext. 4<br />
<a href="mailto:Hr@jmgroveconstruction.com">Hr@jmgroveconstruction.com </a></p>
<div><a href="https://www.facebook.com/JMGrove1com/"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/fb.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/twitter_zpsiiplyhiq.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/tw.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/236e0d0b-832c-4543-81a6-f6c460d302f0_zpsl4nh3ane.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/gpls.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/pinterest_zpspioq6pve.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/pint.png" /></a><br />
 <a href="http://s49.photobucket.com/user/jmg1/media/twitter_zpsiiplyhiq.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/hbt.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/youtube_zpsxyhfmm1b.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/yt.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/c3894afd-7a37-43e2-917c-5ffb7a5036a2_zpschul0pqd.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/houzz.png" /></a> <a href="http://s49.photobucket.com/user/jmg1/media/4478596b-67f4-444e-992a-624af3e56255_zpsoi8p1uyv.jpg.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/linkin.png" /></a></div>
<div><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/footer.png" /></div>'

WHERE ID = 70
GO


UPDATE tblHTMLTemplatesMaster
SET
Subject = 'Active Auto Email',
Header = '<div><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/header.jpg" /></div>
<div><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/logo.gif" /></div>',
Body = '',
Footer = '<p>J.M. Grove - Construction &amp; Supply <br />
<a href="jmgroveconstruction.com">jmgroveconstruction.com </a><br />
<a href="http://jmgrovebuildingsupply.com/"> http://jmgrovebuildingsupply.com/</a><br />
<a href="http://web.jmgrovebuildingsupply.com/login.aspx">http://web.jmgrovebuildingsupply.com/login.aspx</a><br />
<a href="http://jmgroverealestate.com/">http://jmgroverealestate.com/</a><br />
<br />
 72 E Lancaster Ave<br />
Malvern, Pa 19355<br />
Human Resources<br />
Office:(215) 274-5182 Ext. 4<br />
<a href="mailto:Hr@jmgroveconstruction.com">Hr@jmgroveconstruction.com </a></p>
<div><a href="https://www.facebook.com/JMGrove1com/"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/fb.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/twitter_zpsiiplyhiq.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/tw.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/236e0d0b-832c-4543-81a6-f6c460d302f0_zpsl4nh3ane.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/gpls.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/pinterest_zpspioq6pve.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/pint.png" /></a><br />
 <a href="http://s49.photobucket.com/user/jmg1/media/twitter_zpsiiplyhiq.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/hbt.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/youtube_zpsxyhfmm1b.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/yt.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/c3894afd-7a37-43e2-917c-5ffb7a5036a2_zpschul0pqd.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/houzz.png" /></a> <a href="http://s49.photobucket.com/user/jmg1/media/4478596b-67f4-444e-992a-624af3e56255_zpsoi8p1uyv.jpg.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/linkin.png" /></a></div>
<div><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/footer.png" /></div>'

WHERE ID = 69

GO

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---- Published on Live 03032017 -----

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE tblHTMLTemplatesMaster
ADD [Category] TINYINT NULL
GO

UPDATE tblHTMLTemplatesMaster
SET [Category] = 1
WHERE [Type] = 1
GO

UPDATE tblHTMLTemplatesMaster
SET [Category] = 2
WHERE ID IN (48)
GO

UPDATE tblHTMLTemplatesMaster
SET [Category] = 3
WHERE ID IN (57, 58)
GO

INSERT INTO [dbo].[tblHTMLTemplatesMaster]
           ([Id]
           ,[Name]
           ,[Subject]
           ,[Header]
           ,[Body]
           ,[Footer]
           ,[DateUpdated]
           ,[Type]
           ,[Category])
     VALUES
           (75
           ,'Deactive_Attachment_Template'
           ,''
           ,'<div><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/header.jpg" /></div>
<div><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/logo.gif" /></div>'
           ,'<p class="MsoNormal">Dear #name#,On behalf of JMGrove Construction &amp; SupplyLLC, I would like to invite you an informational interview on &nbsp;#Date# &amp; #time# &nbsp;to discuss the position of: #Designation#.<span style="font-size: 10pt; font-family: verdana, sans-serif;"><o:p /></span></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">You will be meeting&nbsp;at:<o:p /></span></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;72 E.Lancaster Ave,&nbsp;<o:p /></span></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Malvern Pa,19355<o:p /></span></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">Feel free to browse our family of companies and our about uspage for more information. If you have any questions or need help locating theoffice, feel free to contact me on my cell phone 717-669-1930<o:p /></span></p>
<p class="MsoNormal"><b><u><span style="font-size: 10pt; font-family: verdana, sans-serif;">Directions &amp; Temporary Parking</span></u></b><span style="font-size: 10pt; font-family: verdana, sans-serif;">:&nbsp;Theinterview location is at our future Corporate office (72 E. Lancaster Ave,Malvern Pa, 19355). It is a commercial new construction site, and the interviewwill be&nbsp;conducted&nbsp;in our construction trailer on site. (See attached)<o:p /></span></p>
<p class="MsoNormal" style="margin-bottom: 0.0001pt;"><span style="font-size: 10pt; font-family: verdana, sans-serif;">&nbsp;</span></p>
<p></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">&nbsp;located on the shoulder of the road in front of the&quot;Harron Building - 70 E. Lancaster Ave&quot; and between &quot;Sunrise ofPaoli: Senior Living center - 324 E Lancaster Ave&quot; and across from&quot;Extra Space Storage- 65 E Lancaster Ave&quot; (Please see attached)<o:p /></span></p>
<p><br />
</p>'
           ,'J.M. Grove - Construction & Supply 
jmgroveconstruction.com 
http://jmgrovebuildingsupply.com/
http://web.jmgrovebuildingsupply.com/login.aspx
http://jmgroverealestate.com/

72 E Lancaster Ave
Malvern, Pa 19355
Human Resources
Office:(215) 274-5182 Ext. 4
Hr@jmgroveconstruction.com


 
'
           ,GETDATE()
           ,2
           ,NULL)
GO

INSERT INTO [dbo].[tblHTMLTemplatesMaster]
           ([Id]
           ,[Name]
           ,[Subject]
           ,[Header]
           ,[Body]
           ,[Footer]
           ,[DateUpdated]
           ,[Type]
           ,[Category])
     VALUES
           (76
           ,'JG_Personal_Company_EmailTemplate'
           ,'*Interview Date Reminder -- JMGrove -Construction & Supply'
           ,'<div><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/header.jpg" /></div>
<div><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/logo.gif" /></div>'
           ,'<p class="MsoNormal">Dear #name#,On behalf of JMGrove Construction &amp; SupplyLLC, I would like to invite you an informational interview on &nbsp;#Date# &amp; #time# &nbsp;to discuss the position of: #Designation#.<span style="font-size: 10pt; font-family: verdana, sans-serif;"><o:p /></span></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">You will be meeting&nbsp;at:<o:p /></span></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;72 E.Lancaster Ave,&nbsp;<o:p /></span></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Malvern Pa,19355<o:p /></span></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">Feel free to browse our family of companies and our about uspage for more information. If you have any questions or need help locating theoffice, feel free to contact me on my cell phone 717-669-1930<o:p /></span></p>
<p class="MsoNormal"><b><u><span style="font-size: 10pt; font-family: verdana, sans-serif;">Directions &amp; Temporary Parking</span></u></b><span style="font-size: 10pt; font-family: verdana, sans-serif;">:&nbsp;Theinterview location is at our future Corporate office (72 E. Lancaster Ave,Malvern Pa, 19355). It is a commercial new construction site, and the interviewwill be&nbsp;conducted&nbsp;in our construction trailer on site. (See attached)<o:p /></span></p>
<p class="MsoNormal" style="margin-bottom: 0.0001pt;"><span style="font-size: 10pt; font-family: verdana, sans-serif;">&nbsp;</span></p>
<p></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">&nbsp;located on the shoulder of the road in front of the&quot;Harron Building - 70 E. Lancaster Ave&quot; and between &quot;Sunrise ofPaoli: Senior Living center - 324 E Lancaster Ave&quot; and across from&quot;Extra Space Storage- 65 E Lancaster Ave&quot; (Please see attached)<o:p /></span></p>
<p><br />
</p>'
           ,'J.M. Grove - Construction & Supply 
jmgroveconstruction.com 
http://jmgrovebuildingsupply.com/
http://web.jmgrovebuildingsupply.com/login.aspx
http://jmgroverealestate.com/

72 E Lancaster Ave
Malvern, Pa 19355
Human Resources
Office:(215) 274-5182 Ext. 4
Hr@jmgroveconstruction.com


 
'
           ,GETDATE()
           ,1
           ,1)
GO

INSERT INTO [dbo].[tblHTMLTemplatesMaster]
           ([Id]
           ,[Name]
           ,[Subject]
           ,[Header]
           ,[Body]
           ,[Footer]
           ,[DateUpdated]
           ,[Type]
           ,[Category])
     VALUES
           (77
           ,'HR_Request_FormFill_EmailTemplate'
           ,'*Interview Date Reminder -- JMGrove -Construction & Supply'
           ,'<div><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/header.jpg" /></div>
<div><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/logo.gif" /></div>'
           ,'<p class="MsoNormal">Dear #name#,On behalf of JMGrove Construction &amp; SupplyLLC, I would like to invite you an informational interview on &nbsp;#Date# &amp; #time# &nbsp;to discuss the position of: #Designation#.<span style="font-size: 10pt; font-family: verdana, sans-serif;"><o:p /></span></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">You will be meeting&nbsp;at:<o:p /></span></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;72 E.Lancaster Ave,&nbsp;<o:p /></span></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Malvern Pa,19355<o:p /></span></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">Feel free to browse our family of companies and our about uspage for more information. If you have any questions or need help locating theoffice, feel free to contact me on my cell phone 717-669-1930<o:p /></span></p>
<p class="MsoNormal"><b><u><span style="font-size: 10pt; font-family: verdana, sans-serif;">Directions &amp; Temporary Parking</span></u></b><span style="font-size: 10pt; font-family: verdana, sans-serif;">:&nbsp;Theinterview location is at our future Corporate office (72 E. Lancaster Ave,Malvern Pa, 19355). It is a commercial new construction site, and the interviewwill be&nbsp;conducted&nbsp;in our construction trailer on site. (See attached)<o:p /></span></p>
<p class="MsoNormal" style="margin-bottom: 0.0001pt;"><span style="font-size: 10pt; font-family: verdana, sans-serif;">&nbsp;</span></p>
<p></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">&nbsp;located on the shoulder of the road in front of the&quot;Harron Building - 70 E. Lancaster Ave&quot; and between &quot;Sunrise ofPaoli: Senior Living center - 324 E Lancaster Ave&quot; and across from&quot;Extra Space Storage- 65 E Lancaster Ave&quot; (Please see attached)<o:p /></span></p>
<p><br />
</p>'
           ,'J.M. Grove - Construction & Supply 
jmgroveconstruction.com 
http://jmgrovebuildingsupply.com/
http://web.jmgrovebuildingsupply.com/login.aspx
http://jmgroverealestate.com/

72 E Lancaster Ave
Malvern, Pa 19355
Human Resources
Office:(215) 274-5182 Ext. 4
Hr@jmgroveconstruction.com


 
'
           ,GETDATE()
           ,1
           ,1)
GO

INSERT INTO [dbo].[tblHTMLTemplatesMaster]
           ([Id]
           ,[Name]
           ,[Subject]
           ,[Header]
           ,[Body]
           ,[Footer]
           ,[DateUpdated]
           ,[Type]
           ,[Category])
     VALUES
           (78
           ,'Verbal_Warning_AutoEmailTemplate'
           ,'*Interview Date Reminder -- JMGrove -Construction & Supply'
           ,'<div><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/header.jpg" /></div>
<div><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/logo.gif" /></div>'
           ,'<p class="MsoNormal">Dear #name#,On behalf of JMGrove Construction &amp; SupplyLLC, I would like to invite you an informational interview on &nbsp;#Date# &amp; #time# &nbsp;to discuss the position of: #Designation#.<span style="font-size: 10pt; font-family: verdana, sans-serif;"><o:p /></span></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">You will be meeting&nbsp;at:<o:p /></span></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;72 E.Lancaster Ave,&nbsp;<o:p /></span></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Malvern Pa,19355<o:p /></span></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">Feel free to browse our family of companies and our about uspage for more information. If you have any questions or need help locating theoffice, feel free to contact me on my cell phone 717-669-1930<o:p /></span></p>
<p class="MsoNormal"><b><u><span style="font-size: 10pt; font-family: verdana, sans-serif;">Directions &amp; Temporary Parking</span></u></b><span style="font-size: 10pt; font-family: verdana, sans-serif;">:&nbsp;Theinterview location is at our future Corporate office (72 E. Lancaster Ave,Malvern Pa, 19355). It is a commercial new construction site, and the interviewwill be&nbsp;conducted&nbsp;in our construction trailer on site. (See attached)<o:p /></span></p>
<p class="MsoNormal" style="margin-bottom: 0.0001pt;"><span style="font-size: 10pt; font-family: verdana, sans-serif;">&nbsp;</span></p>
<p></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">&nbsp;located on the shoulder of the road in front of the&quot;Harron Building - 70 E. Lancaster Ave&quot; and between &quot;Sunrise ofPaoli: Senior Living center - 324 E Lancaster Ave&quot; and across from&quot;Extra Space Storage- 65 E Lancaster Ave&quot; (Please see attached)<o:p /></span></p>
<p><br />
</p>'
           ,'J.M. Grove - Construction & Supply 
jmgroveconstruction.com 
http://jmgrovebuildingsupply.com/
http://web.jmgrovebuildingsupply.com/login.aspx
http://jmgroverealestate.com/

72 E Lancaster Ave
Malvern, Pa 19355
Human Resources
Office:(215) 274-5182 Ext. 4
Hr@jmgroveconstruction.com


 
'
           ,GETDATE()
           ,1
           ,1)
GO

INSERT INTO [dbo].[tblHTMLTemplatesMaster]
           ([Id]
           ,[Name]
           ,[Subject]
           ,[Header]
           ,[Body]
           ,[Footer]
           ,[DateUpdated]
           ,[Type]
           ,[Category])
     VALUES
           (79
           ,'Written_Warning_AutoEmailTemplate'
           ,'*Interview Date Reminder -- JMGrove -Construction & Supply'
           ,'<div><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/header.jpg" /></div>
<div><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/logo.gif" /></div>'
           ,'<p class="MsoNormal">Dear #name#,On behalf of JMGrove Construction &amp; SupplyLLC, I would like to invite you an informational interview on &nbsp;#Date# &amp; #time# &nbsp;to discuss the position of: #Designation#.<span style="font-size: 10pt; font-family: verdana, sans-serif;"><o:p /></span></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">You will be meeting&nbsp;at:<o:p /></span></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;72 E.Lancaster Ave,&nbsp;<o:p /></span></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Malvern Pa,19355<o:p /></span></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">Feel free to browse our family of companies and our about uspage for more information. If you have any questions or need help locating theoffice, feel free to contact me on my cell phone 717-669-1930<o:p /></span></p>
<p class="MsoNormal"><b><u><span style="font-size: 10pt; font-family: verdana, sans-serif;">Directions &amp; Temporary Parking</span></u></b><span style="font-size: 10pt; font-family: verdana, sans-serif;">:&nbsp;Theinterview location is at our future Corporate office (72 E. Lancaster Ave,Malvern Pa, 19355). It is a commercial new construction site, and the interviewwill be&nbsp;conducted&nbsp;in our construction trailer on site. (See attached)<o:p /></span></p>
<p class="MsoNormal" style="margin-bottom: 0.0001pt;"><span style="font-size: 10pt; font-family: verdana, sans-serif;">&nbsp;</span></p>
<p></p>
<p class="MsoNormal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">&nbsp;located on the shoulder of the road in front of the&quot;Harron Building - 70 E. Lancaster Ave&quot; and between &quot;Sunrise ofPaoli: Senior Living center - 324 E Lancaster Ave&quot; and across from&quot;Extra Space Storage- 65 E Lancaster Ave&quot; (Please see attached)<o:p /></span></p>
<p><br />
</p>'
           ,'J.M. Grove - Construction & Supply 
jmgroveconstruction.com 
http://jmgrovebuildingsupply.com/
http://web.jmgrovebuildingsupply.com/login.aspx
http://jmgroverealestate.com/

72 E Lancaster Ave
Malvern, Pa 19355
Human Resources
Office:(215) 274-5182 Ext. 4
Hr@jmgroveconstruction.com


 
'
           ,GETDATE()
           ,1
           ,1)
GO

/****** Object:  StoredProcedure [dbo].[GetHTMLTemplateMasters]    Script Date: 06-Mar-17 9:42:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Yogesh  
-- Create date: 27 Jan 2017  
-- Description: Gets all Master HTMLTemplates.  
-- =============================================  
ALTER PROCEDURE [dbo].[GetHTMLTemplateMasters]  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
 SELECT *
 FROM tblHTMLTemplatesMaster
 WHERE Id IN (1, 7, 12, 28, 36, 41, 48, 50, 57, 58, 60,69,70,71,72,73,74, 75, 76, 77, 78, 79)   
 ORDER BY Id ASC  
  
END  
GO

/****** Object:  StoredProcedure [dbo].[SaveDesignationHTMLTemplate]    Script Date: 06-Mar-17 8:54:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 27 Jan 2017
-- Description:	Saves designation HTMLTemplate either inserts or updates.
-- =============================================
ALTER PROCEDURE [dbo].[SaveDesignationHTMLTemplate]
	@HTMLTemplatesMasterId	INT,
	@MasterCategory			TINYINT,
	@Designation			VARCHAR(50),
	@Subject				VARCHAR(4000),
	@Header					NVARCHAR(max),
	@Body					NVARCHAR(max),
	@Footer					NVARCHAR(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE [tblHTMLTemplatesMaster]
	SET
		Category = @MasterCategory
	WHERE Id = @HTMLTemplatesMasterId

	IF EXISTS (SELECT ID 
					FROM [tblDesignationHTMLTemplates] 
					WHERE HTMLTemplatesMasterId = @HTMLTemplatesMasterId AND Designation = @Designation)
		BEGIN

			UPDATE [dbo].[tblDesignationHTMLTemplates]
			   SET
				  [Subject] = @Subject
				  ,[Header] = @Header
				  ,[Body] = @Body
				  ,[Footer] = @Footer
				  ,[DateUpdated] = GETDATE()
			 WHERE HTMLTemplatesMasterId = @HTMLTemplatesMasterId AND Designation = @Designation

		END
	ELSE
		BEGIN
			INSERT INTO [dbo].[tblDesignationHTMLTemplates]
				   ([HTMLTemplatesMasterId]
				   ,[Designation]
				   ,[Subject]
				   ,[Header]
				   ,[Body]
				   ,[Footer]
				   ,[DateUpdated])
			 VALUES
				   (@HTMLTemplatesMasterId
				   ,@Designation
				   ,@Subject
				   ,@Header
				   ,@Body
				   ,@Footer
				   ,GETDATE())
		END

END
GO

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Live publish on 03072017

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE MCQ_Exam
DROP COLUMN ExamType
GO

ALTER TABLE MCQ_Exam
ADD DesignationID INT REFERENCES tbl_Designation DEFAULT 1 NOT NULL
GO

ALTER TABLE MCQ_CorrectAnswer
ADD OptionID BIGINT REFERENCES MCQ_Option
GO

UPDATE a
SET
	a.OptionID = o.OptionID
FROM MCQ_CorrectAnswer a INNER JOIN MCQ_Option o
	ON a.AnswerText = o.OptionText
GO

ALTER TABLE MCQ_CorrectAnswer
DROP COLUMN AnswerText
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 09 Mar 2017
-- Description:	Gets all exams by designation.
-- =============================================
CREATE PROCEDURE [dbo].[GetMCQ_Exams]
	@DesignationID	INT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT e.*, d.DesignationName
	FROM MCQ_Exam e INNER JOIN tbl_Designation d
		ON e.DesignationID = d.ID
	WHERE d.ID = ISNULL(@DesignationID, d.ID)

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 09 Mar 2017
-- Description:	Gets exam details by exam id.
-- =============================================
CREATE PROCEDURE [dbo].[GetMCQ_ExamByID]
	@ExamID	INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT e.*, d.DesignationName
	FROM MCQ_Exam e INNER JOIN tbl_Designation d
		ON e.DesignationID = d.ID
	WHERE e.ExamID = @ExamID

	SELECT q.*, a.OptionID AS AnswerOptionID
	FROM MCQ_Question q INNER JOIN MCQ_CorrectAnswer a
			ON q.QuestionID = a.QuestionID
	WHERE q.ExamID = @ExamID
	ORDER BY q.QuestionID ASC

	SELECT o.*
	FROM MCQ_Option o 
	WHERE o.QuestionID IN (
							SELECT q.QuestionID 
							FROM MCQ_Question q
							WHERE q.ExamID = @ExamID )
	ORDER BY o.QuestionID ASC

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 14 Mar 2017
-- Description:	Adds exam details.
-- =============================================
CREATE PROCEDURE [dbo].[InsertMCQ_Exam]
	@ExamTitle	varchar(500)
	,@ExamDescription	varchar(500)
	,@IsActive	bit
	,@CourseID	bigint
	,@ExamDuration	int
	,@PassPercentage	float
	,@DesignationID	int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO [dbo].[MCQ_Exam]
           ([ExamTitle]
           ,[ExamDescription]
           ,[IsActive]
           ,[CourseID]
           ,[ExamDuration]
           ,[PassPercentage]
           ,[DesignationID])
     VALUES
           (@ExamTitle
           ,@ExamDescription
           ,@IsActive
           ,@CourseID
           ,@ExamDuration
           ,@PassPercentage
           ,@DesignationID)

	SELECT SCOPE_IDENTITY()

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 14 Mar 2017
-- Description:	Updates exam details.
-- =============================================
CREATE PROCEDURE [dbo].[UpdateMCQ_Exam]
	@ExamID	bigint
	,@ExamTitle	varchar(500)
	,@ExamDescription	varchar(500)
	,@IsActive	bit
	,@CourseID	bigint
	,@ExamDuration	int
	,@PassPercentage	float
	,@DesignationID	int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE [dbo].[MCQ_Exam]
	   SET [ExamTitle] = @ExamTitle
		  ,[ExamDescription] = @ExamDescription
		  ,[IsActive] = @IsActive
		  ,[CourseID] = @CourseID
		  ,[ExamDuration] = @ExamDuration
		  ,[PassPercentage] = @PassPercentage
		  ,[DesignationID] = @DesignationID
	 WHERE ExamID = @ExamID

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 14 Mar 2017
-- Description:	Adds exam questions.
-- =============================================
CREATE PROCEDURE [dbo].[InsertMCQ_Question]
	@Question	varchar(500)
	,@QuestionType	bigint
	,@PositiveMarks	bigint
	,@NegetiveMarks	bigint
	,@PictureURL	varchar(500)
	,@ExamID	bigint
	,@AnswerTemplate	varchar(500)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO [dbo].[MCQ_Question]
           ([Question]
           ,[QuestionType]
           ,[PositiveMarks]
           ,[NegetiveMarks]
           ,[PictureURL]
           ,[ExamID]
           ,[AnswerTemplate])
     VALUES
           (@Question
           ,@QuestionType
           ,@PositiveMarks
           ,@NegetiveMarks
           ,@PictureURL
           ,@ExamID
           ,@AnswerTemplate)

	SELECT SCOPE_IDENTITY()

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 14 Mar 2017
-- Description:	Updates exam question.
-- =============================================
CREATE PROCEDURE [dbo].[UpdateMCQ_Question]
	@QuestionID	bigint
	,@Question	varchar(500)
	,@QuestionType	bigint
	,@PositiveMarks	bigint
	,@NegetiveMarks	bigint
	,@PictureURL	varchar(500)
	,@ExamID	bigint
	,@AnswerTemplate	varchar(500)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE [dbo].[MCQ_Question]
	   SET [Question] = @Question
		  ,[QuestionType] = @QuestionType
		  ,[PositiveMarks] = @PositiveMarks
		  ,[NegetiveMarks] = @NegetiveMarks
		  ,[PictureURL] = @PictureURL
		  ,[ExamID] = @ExamID
		  ,[AnswerTemplate] = @AnswerTemplate
	 WHERE QuestionID = @QuestionID

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 14 Mar 2017
-- Description:	Deletes exam question including options and answers.
-- =============================================
CREATE PROCEDURE [dbo].[DeleteMCQ_Question]
	@QuestionID	bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DELETE
	FROM [dbo].[MCQ_CorrectAnswer]
	WHERE QuestionID = @QuestionID

	DELETE
	FROM [dbo].[MCQ_Option]
	WHERE QuestionID = @QuestionID

	DELETE
	FROM [dbo].[MCQ_Question]
	WHERE QuestionID = @QuestionID

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 14 Mar 2017
-- Description:	Adds option for exam questions.
-- =============================================
CREATE PROCEDURE [dbo].[InsertMCQ_Option]
	@OptionText varchar(500)
	,@QuestionID bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO [dbo].[MCQ_Option]
           ([OptionText]
           ,[QuestionID])
     VALUES
           (@OptionText
           ,@QuestionID)

	SELECT SCOPE_IDENTITY()

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 14 Mar 2017
-- Description:	Updates option for exam question.
-- =============================================
CREATE PROCEDURE [dbo].[UpdateMCQ_Option]
	@OptionID	bigint
	,@OptionText varchar(500)
	,@QuestionID bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE [dbo].[MCQ_Option]
	   SET OptionText = @OptionText
		  ,QuestionID = @QuestionID
	 WHERE OptionID = @OptionID

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 14 Mar 2017
-- Description:	Adds answer for exam question.
-- =============================================
CREATE PROCEDURE [dbo].[InsertMCQ_CorrectAnswer]
	@OptionText varchar(500)
	,@QuestionID bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @OptionID BIGINT

	SELECT TOP 1 @OptionID = OptionID
	FROM [dbo].[MCQ_Option] o
	WHERE o.OptionText = @OptionText AND QuestionID = @QuestionID

	INSERT INTO [dbo].[MCQ_CorrectAnswer]
           ([OptionID]
           ,[QuestionID])
     VALUES
           (@OptionID
           ,@QuestionID)

	SELECT SCOPE_IDENTITY()

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 14 Mar 2017
-- Description:	Updates answer for exam question.
-- =============================================
CREATE PROCEDURE [dbo].[UpdateMCQ_CorrectAnswer]
	@OptionText varchar(500)
	,@QuestionID bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @OptionID BIGINT

	SELECT TOP 1 @OptionID = OptionID
	FROM [dbo].[MCQ_Option] o
	WHERE o.OptionText = @OptionText AND QuestionID = @QuestionID

	UPDATE [dbo].[MCQ_CorrectAnswer]
	   SET OptionID = @OptionID
	WHERE OptionID = @OptionID

END
GO


/****** Object:  StoredProcedure [dbo].[usp_GetSubTasks]    Script Date: 16-Mar-17 10:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 04/07/2016
-- Description:	Load all sub tasks of a task.
-- =============================================
-- usp_GetSubTasks 115, 1, 'Description DESC'
ALTER PROCEDURE [dbo].[usp_GetSubTasks] 
(
	@TaskId INT,
	@Admin BIT,
	@SortExpression	VARCHAR(250) = 'CreatedOn DESC',
	@searchterm  as varchar(300),
	@OpenStatus		TINYINT = 1,
    @RequestedStatus	TINYINT = 2,
    @AssignedStatus	TINYINT = 3,
    @InProgressStatus	TINYINT = 4,
    @PendingStatus	TINYINT = 5,
    @ReOpenedStatus	TINYINT = 6,
    @ClosedStatus	TINYINT = 7,
    @SpecsInProgressStatus	TINYINT = 8,
    @DeletedStatus	TINYINT = 9
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
IF @searchterm = '' 
	BEGIN
		;WITH 
		Tasklist AS
		(	


			SELECT
				Tasks.*,
				(SELECT TOP 1 EstimatedHours 
					FROM [TaskApprovalsView] TaskApprovals 
					WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 1) AS AdminOrITLeadEstimatedHours,
				(SELECT TOP 1 EstimatedHours 
					FROM [TaskApprovalsView] TaskApprovals 
					WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 0) AS UserEstimatedHours,
				Row_number() OVER
				(
					ORDER BY
						CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
						CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
						CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
						CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
						CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
						CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
						CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
						CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
						CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
						CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
						CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
						CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
						CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.StatusOrder END ASC,
						CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.StatusOrder END DESC,
						CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
						CASE WHEN @SortExpression = 'CreatedOn ASC' THEN Tasks.CreatedOn END ASC
				) AS RowNo_Order
			FROM
				(
					SELECT 
						Tasks.*,
						CASE Tasks.[Status]
							WHEN @AssignedStatus THEN 1
							WHEN @RequestedStatus THEN 1

							WHEN @InProgressStatus THEN 2
							WHEN @PendingStatus THEN 2
							WHEN @ReOpenedStatus THEN 2

							WHEN @OpenStatus THEN 
								CASE 
									WHEN ISNULL([TaskPriority],'') <> '' THEN 3
									ELSE 4
								END

							WHEN @SpecsInProgressStatus THEN 4

							WHEN @ClosedStatus THEN 5

							WHEN @DeletedStatus THEN 6

							ELSE 7

						END AS StatusOrder,
						TaskApprovals.Id AS TaskApprovalId,
						TaskApprovals.EstimatedHours AS TaskApprovalEstimatedHours,
						TaskApprovals.Description AS TaskApprovalDescription,
						TaskApprovals.UserId AS TaskApprovalUserId,
						TaskApprovals.IsInstallUser AS TaskApprovalIsInstallUser
					FROM 
						[TaskListView] Tasks 
							LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin
					WHERE
						Tasks.ParentTaskId = @TaskId 
						-- condition added by DP 23-jan-17 ---
						and Tasks.TaskLevel=1
				) Tasks
			)
			-- get records
			SELECT * 
			FROM Tasklist 
			ORDER BY RowNo_Order
	END
ELSE
	BEGIN
		;WITH 
		Tasklist AS
		(	
			SELECT
				Tasks.*,
				(SELECT TOP 1 EstimatedHours 
					FROM [TaskApprovalsView] TaskApprovals 
					WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 1) AS AdminOrITLeadEstimatedHours,
				(SELECT TOP 1 EstimatedHours 
					FROM [TaskApprovalsView] TaskApprovals 
					WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 0) AS UserEstimatedHours,
				Row_number() OVER
				(
					ORDER BY
						CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
						CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
						CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
						CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
						CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
						CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
						CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
						CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
						CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
						CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
						CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
						CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
						CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.StatusOrder END ASC,
						CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.StatusOrder END DESC,
						CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
						CASE WHEN @SortExpression = 'CreatedOn ASC' THEN Tasks.CreatedOn END ASC
				) AS RowNo_Order
			FROM
				(
					SELECT 
						Tasks.*,
						CASE Tasks.[Status]
							WHEN @AssignedStatus THEN 1
							WHEN @RequestedStatus THEN 1

							WHEN @InProgressStatus THEN 2
							WHEN @PendingStatus THEN 2
							WHEN @ReOpenedStatus THEN 2

							WHEN @OpenStatus THEN 
								CASE 
									WHEN ISNULL([TaskPriority],'') <> '' THEN 3
									ELSE 4
								END

							WHEN @SpecsInProgressStatus THEN 4

							WHEN @ClosedStatus THEN 5

							WHEN @DeletedStatus THEN 6

							ELSE 7

						END AS StatusOrder,
						TaskApprovals.Id AS TaskApprovalId,
						TaskApprovals.EstimatedHours AS TaskApprovalEstimatedHours,
						TaskApprovals.Description AS TaskApprovalDescription,
						TaskApprovals.UserId AS TaskApprovalUserId,
						TaskApprovals.IsInstallUser AS TaskApprovalIsInstallUser
					FROM 
						tblinstallusers as a,
						[TaskListView] Tasks 
							LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin
							left join [tbltaskassignedusers] t on Tasks.TaskId=t.TaskId 
					WHERE
						Tasks.ParentTaskId = @TaskId 
						and a.Id=t.UserId and a.Fristname like '%'+@searchterm+'%'
						-- condition added by DP 23-jan-17 ---
						and Tasks.TaskLevel=1
				) Tasks
			)
			-- get records
			SELECT * 
			FROM Tasklist 
			ORDER BY RowNo_Order
	END
END
GO


/****** Object:  StoredProcedure [dbo].[usp_GetSubTasks]    Script Date: 16-Mar-17 10:15:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 04/07/2016
-- Description:	Load all sub tasks of a task.
-- =============================================
-- usp_GetSubTasks 115, 1, 'Description DESC'
ALTER PROCEDURE [dbo].[usp_GetSubTasks] 
(
	@TaskId INT,
	@Admin BIT,
	@SortExpression	VARCHAR(250) = 'CreatedOn DESC',
	@searchterm  as varchar(300),
	@OpenStatus		TINYINT = 1,
    @RequestedStatus	TINYINT = 2,
    @AssignedStatus	TINYINT = 3,
    @InProgressStatus	TINYINT = 4,
    @PendingStatus	TINYINT = 5,
    @ReOpenedStatus	TINYINT = 6,
    @ClosedStatus	TINYINT = 7,
    @SpecsInProgressStatus	TINYINT = 8,
    @DeletedStatus	TINYINT = 9,
	@PageIndex INT = NULL, 
	@PageSize INT = NULL
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
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
	
	IF @searchterm = '' 
	BEGIN
		;WITH 
		Tasklist AS
		(	
			SELECT
				Tasks.*,
				(SELECT TOP 1 EstimatedHours 
					FROM [TaskApprovalsView] TaskApprovals 
					WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 1) AS AdminOrITLeadEstimatedHours,
				(SELECT TOP 1 EstimatedHours 
					FROM [TaskApprovalsView] TaskApprovals 
					WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 0) AS UserEstimatedHours,
				Row_number() OVER
				(
					ORDER BY
						CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
						CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
						CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
						CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
						CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
						CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
						CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
						CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
						CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
						CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
						CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
						CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
						CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.StatusOrder END ASC,
						CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.StatusOrder END DESC,
						CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
						CASE WHEN @SortExpression = 'CreatedOn ASC' THEN Tasks.CreatedOn END ASC
				) AS RowNo_Order
			FROM
				(
					SELECT 
						Tasks.*,
						CASE Tasks.[Status]
							WHEN @AssignedStatus THEN 1
							WHEN @RequestedStatus THEN 1

							WHEN @InProgressStatus THEN 2
							WHEN @PendingStatus THEN 2
							WHEN @ReOpenedStatus THEN 2

							WHEN @OpenStatus THEN 
								CASE 
									WHEN ISNULL([TaskPriority],'') <> '' THEN 3
									ELSE 4
								END

							WHEN @SpecsInProgressStatus THEN 4

							WHEN @ClosedStatus THEN 5

							WHEN @DeletedStatus THEN 6

							ELSE 7

						END AS StatusOrder,
						TaskApprovals.Id AS TaskApprovalId,
						TaskApprovals.EstimatedHours AS TaskApprovalEstimatedHours,
						TaskApprovals.Description AS TaskApprovalDescription,
						TaskApprovals.UserId AS TaskApprovalUserId,
						TaskApprovals.IsInstallUser AS TaskApprovalIsInstallUser
					FROM 
						[TaskListView] Tasks 
							LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin
					WHERE
						Tasks.ParentTaskId = @TaskId 
						-- condition added by DP 23-jan-17 ---
						and Tasks.TaskLevel=1
				) Tasks
		)

		-- get records
		SELECT * 
		FROM Tasklist 
		WHERE 
			RowNo_Order >= @StartIndex AND 
			(
				@PageSize = 0 OR 
				RowNo_Order < (@StartIndex + @PageSize)
			)
		ORDER BY RowNo_Order

		-- get records count
		SELECT
			COUNT(*) AS TotalRecords
		FROM 
			[TaskListView] Tasks 
				LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin
		WHERE
			Tasks.ParentTaskId = @TaskId 
			-- condition added by DP 23-jan-17 ---
			and Tasks.TaskLevel=1
	END
	ELSE
	BEGIN
		;WITH 
		Tasklist AS
		(	
			SELECT
				Tasks.*,
				(SELECT TOP 1 EstimatedHours 
					FROM [TaskApprovalsView] TaskApprovals 
					WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 1) AS AdminOrITLeadEstimatedHours,
				(SELECT TOP 1 EstimatedHours 
					FROM [TaskApprovalsView] TaskApprovals 
					WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 0) AS UserEstimatedHours,
				Row_number() OVER
				(
					ORDER BY
						CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
						CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
						CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
						CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
						CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
						CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
						CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
						CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
						CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
						CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
						CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
						CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
						CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.StatusOrder END ASC,
						CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.StatusOrder END DESC,
						CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
						CASE WHEN @SortExpression = 'CreatedOn ASC' THEN Tasks.CreatedOn END ASC
				) AS RowNo_Order
			FROM
				(
					SELECT 
						Tasks.*,
						CASE Tasks.[Status]
							WHEN @AssignedStatus THEN 1
							WHEN @RequestedStatus THEN 1

							WHEN @InProgressStatus THEN 2
							WHEN @PendingStatus THEN 2
							WHEN @ReOpenedStatus THEN 2

							WHEN @OpenStatus THEN 
								CASE 
									WHEN ISNULL([TaskPriority],'') <> '' THEN 3
									ELSE 4
								END

							WHEN @SpecsInProgressStatus THEN 4

							WHEN @ClosedStatus THEN 5

							WHEN @DeletedStatus THEN 6

							ELSE 7

						END AS StatusOrder,
						TaskApprovals.Id AS TaskApprovalId,
						TaskApprovals.EstimatedHours AS TaskApprovalEstimatedHours,
						TaskApprovals.Description AS TaskApprovalDescription,
						TaskApprovals.UserId AS TaskApprovalUserId,
						TaskApprovals.IsInstallUser AS TaskApprovalIsInstallUser
					FROM 
						tblinstallusers as a,
						[TaskListView] Tasks 
							LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin
							LEFT JOIN [tbltaskassignedusers] t on Tasks.TaskId=t.TaskId
					WHERE
						Tasks.ParentTaskId = @TaskId 
						and a.Id=t.UserId and a.Fristname like '%'+@searchterm+'%'
						-- condition added by DP 23-jan-17 ---
						and Tasks.TaskLevel=1
				) Tasks
		)
		-- get records
		SELECT * 
		FROM Tasklist 
		WHERE 
			RowNo_Order >= @StartIndex AND 
			(
				@PageSize = 0 OR 
				RowNo_Order < (@StartIndex + @PageSize)
			)
		ORDER BY RowNo_Order

		-- get records count
		SELECT
			COUNT(*) AS TotalRecords
		FROM 
			tblinstallusers as a,
			[TaskListView] Tasks 
				LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin
				LEFT JOIN [tbltaskassignedusers] t on Tasks.TaskId=t.TaskId
		WHERE
			Tasks.ParentTaskId = @TaskId 
			and a.Id=t.UserId and a.Fristname like '%'+@searchterm+'%'
			-- condition added by DP 23-jan-17 ---
			and Tasks.TaskLevel=1
	END
END
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh
-- Create date: 20 March 2017
-- Description:	Get one or all tasks with all sub tasks from all levels.
-- =============================================
-- [GetTaskHierarchy] 192, 1
ALTER PROCEDURE  [dbo].[GetTaskHierarchy] 
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
			on t2.ParentTaskId = cteTasks.TaskId
	)

	SELECT *
	FROM cteTasks LEFT JOIN [TaskApprovalsView] TaskApprovals 
			ON cteTasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin
	ORDER BY cteTasks.TaskLevel, cteTasks.ParentTaskId

END
GO
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Published on 22 March 2017

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE tbl_Designation
ADD DesignationCode Varchar(10) NULL
GO

UPDATE tbl_Designation
SET
	DesignationCode =
			CASE ID
				WHEN 1 THEN 'ADM'
                WHEN 2 THEN  'JSL'
                WHEN 3 THEN  'JPM'
                WHEN 4 THEN  'OFM'
                WHEN 5 THEN  'REC'
                WHEN 6 THEN  'SLM'
                WHEN 7 THEN  'SSL'
                WHEN 8 THEN  'ITNA'
                WHEN 9 THEN  'ITJN'
                WHEN 10 THEN  'ITSN'
                WHEN 11 THEN  'ITAD'
                WHEN 12 THEN  'ITPH'
                WHEN 13 THEN  'ITSB'
                WHEN 14 THEN  'INH'
                WHEN 15 THEN  'INJ'
                WHEN 16 THEN  'INM'
                WHEN 17 THEN  'INLM'
                WHEN 18 THEN  'INF'
                WHEN 19 THEN  'COM'
                WHEN 20 THEN  'SBC'
                WHEN 21 THEN  'ITL'
                WHEN 22 THEN  'ASL'
                WHEN 23 THEN  'AREC'
                ELSE 'OUID'
			END
GO

/****** Object:  StoredProcedure [dbo].[UDP_DesignationInsertUpdate]    Script Date: 22-Mar-17 11:14:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jaylem
-- Create date: 26-Nov-2016
-- Description:	Add/Edit Designation details.

-- Updated : Added DesignationCode.
--		date: 22 Mar 2017
--		by : Yogesh
-- =============================================
ALTER PROCEDURE [dbo].[UDP_DesignationInsertUpdate] 
	@ID int,
	@DesignationName varchar(50),
	@DesignationCode varchar(10),
	@IsActive bit,
	@DepartmentID Int,
	@result int output  
AS
BEGIN
	SET NOCOUNT ON;
	SET @result=0;

	IF (SELECT TOP 1 ID FROM tbl_Designation WHERE ID=@ID) Is Null
	BEGIN
		INSERT INTO tbl_Designation(DesignationName,IsActive,DepartmentID,DesignationCode)
		VALUES (@DesignationName,@IsActive,@DepartmentID,@DesignationCode)
		Set @result =@@IDENTITY;
	END
	ELSE
	BEGIN
		UPDATE tbl_Designation
		SET DesignationName=@DesignationName
		,DepartmentID=@DepartmentID
		,IsActive = @IsActive
		,DesignationCode=@DesignationCode
		WHERE ID=@ID
		Set @result =@ID;
	END
	return @result
END
GO


/****** Object:  StoredProcedure [dbo].[UDP_GetAllActiveDesignationByFilter]    Script Date: 22-Mar-17 11:20:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jaylem
-- Create date: 13-Dec-2016
-- Description:	Returns all/selected Active Designation 

-- Updated : Added DesignationCode.
--		date: 22 Mar 2017
--		by : Yogesh
-- =============================================
ALTER PROCEDURE [dbo].[UDP_GetAllActiveDesignationByFilter]
	@DepartmentID As Int,
	@DesignationID As Int
AS
BEGIN
	SET NOCOUNT ON;	
	
	SELECT ds.ID
	,ds.DesignationName
	,ds.DesignationCode
	,ds.IsActive
	,ds.DepartmentID
	,dt.DepartmentName
	FROM tbl_Designation ds
	INNER JOIN tbl_Department dt On dt.ID = ds.DepartmentID
	WHERE ds.IsActive=1
	AND ds.ID = (CASE WHEN @DesignationID=0 THEN ds.ID ELSE @DesignationID END)
	AND ds.DepartmentID = (CASE WHEN @DepartmentID=0 THEN ds.DepartmentID ELSE @DepartmentID END)

END
GO

/****** Object:  StoredProcedure [dbo].[UDP_GetAllDesignationsForHumanResource]    Script Date: 22-Mar-17 11:37:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shekhar Pawar
-- Create date: 15-Nov-2016
-- Description:	Returns all Designation Names from database table

-- Updated : Added DesignationCode.
--		date: 22 Mar 2017
--		by : Yogesh
-- =============================================
ALTER PROCEDURE [dbo].[UDP_GetAllDesignationsForHumanResource]
	-- Add the parameters for the stored procedure here
	AS
BEGIN
	SET NOCOUNT ON;	
  SELECT [ID]
      ,[DesignationName]
      ,[IsActive]
	  ,DesignationCode
  FROM [dbo].[tbl_Designation] WITH(NOLOCK)
  WHERE [IsActive] = 1 AND DepartmentID = 1
  ORDER BY [DesignationName]

END
GO

/****** Object:  StoredProcedure [dbo].[UDP_GetDesignationByFilter]    Script Date: 22-Mar-17 11:38:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jaylem
-- Create date: 26-Nov-2016
-- Description:	Returns all/selected Designation 

-- Updated : Added DesignationCode.
--		date: 22 Mar 2017
--		by : Yogesh
-- =============================================
ALTER PROCEDURE [dbo].[UDP_GetDesignationByFilter]
	@DepartmentID As Int,
	@DesignationID As Int
	AS
BEGIN
	SET NOCOUNT ON;	
	
	SELECT ds.ID
	,ds.DesignationName
	,ds.IsActive
	,ds.DepartmentID
	,dt.DepartmentName
	,ds.DesignationCode
	FROM tbl_Designation ds
	INNER JOIN tbl_Department dt On dt.ID = ds.DepartmentID
	WHERE ds.ID = (CASE WHEN @DesignationID=0 THEN ds.ID ELSE @DesignationID END)
	AND ds.DepartmentID = (CASE WHEN @DepartmentID=0 THEN ds.DepartmentID ELSE @DepartmentID END)

END
GO


/****** Object:  StoredProcedure [dbo].[usp_GetSubTasks_New]    Script Date: 25-Mar-17 12:52:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================

-- Author:		Yogesh Keraliya
-- Create date: 04/07/2016
-- Description:	Load all sub tasks of a task.
-- =============================================
-- usp_GetSubTasks_New 200, 1, 'TaskLevel ASC','',1,2,3,4,5,6,7,8,9, 0, 10, 0
CREATE PROCEDURE [dbo].[usp_GetSubTasks_New] 
(
	@TaskId INT,
	@Admin BIT,
	@SortExpression	VARCHAR(250) = 'TaskLevel ASC',
	@searchterm  as varchar(300),
	@OpenStatus		TINYINT = 1,
    @RequestedStatus	TINYINT = 2,
    @AssignedStatus	TINYINT = 3,
    @InProgressStatus	TINYINT = 4,
    @PendingStatus	TINYINT = 5,
    @ReOpenedStatus	TINYINT = 6,
    @ClosedStatus	TINYINT = 7,
    @SpecsInProgressStatus	TINYINT = 8,
    @DeletedStatus	TINYINT = 9,
	@PageIndex INT = NULL, 
	@PageSize INT = NULL,
	@HighlightTaskId INT = 0
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @strt INT
	DECLARE @StartIndex INT  = 0

	IF @searchterm = '' 
	BEGIN
		SET @searchterm = NULL
	END

	IF @PageIndex IS NULL
	BEGIN
		SET @PageIndex = 0
	END

	IF @PageSize IS NULL
	BEGIN
		SET @PageSize = 0
	END

	;WITH
	cteTaskList AS
	(
		SELECT 
			Tasks.*,
			CASE Tasks.[Status]
				WHEN @AssignedStatus THEN 1
				WHEN @RequestedStatus THEN 1

				WHEN @InProgressStatus THEN 2
				WHEN @PendingStatus THEN 2
				WHEN @ReOpenedStatus THEN 2

				WHEN @OpenStatus THEN 
					CASE 
						WHEN ISNULL([TaskPriority],'') <> '' THEN 3
						ELSE 4
					END

				WHEN @SpecsInProgressStatus THEN 4

				WHEN @ClosedStatus THEN 5

				WHEN @DeletedStatus THEN 6

				ELSE 7
			END AS StatusOrder
		FROM 
			[TaskListView] Tasks 
				LEFT JOIN [tbltaskassignedusers] tu ON Tasks.TaskId = tu.TaskId
				LEFT JOIN [tblInstallUsers] u ON tu.UserId = u.Id 
		WHERE
			Tasks.ParentTaskId = @TaskId 
			AND (
					@searchterm IS NULL 
					OR u.Fristname like '%'+@searchterm+'%'
				)
			-- condition added by DP 23-jan-17 ---
			--AND Tasks.TaskLevel=1
	), 
	cteSortedTaskList AS
	(	
		SELECT
			Tasks.*,
			Row_number() OVER
			(
				ORDER BY
					CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
					CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
					CASE WHEN @SortExpression = 'TaskLevel DESC' THEN Tasks.TaskLevel END DESC,
					CASE WHEN @SortExpression = 'TaskLevel ASC' THEN Tasks.TaskLevel END ASC,
					CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
					CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
					CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
					CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
					CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
					CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
					CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
					CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
					CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.StatusOrder END ASC,
					CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.StatusOrder END DESC,
					CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
					CASE WHEN @SortExpression = 'CreatedOn ASC' THEN Tasks.CreatedOn END ASC
			) AS RowNo_Order
		FROM
			cteTaskList Tasks
	)
	,
	cteTasks
	AS
	(
		SELECT t1.*
		FROM cteSortedTaskList t1

		UNION ALL

		SELECT Tasks.*,
			cteTasks.StatusOrder AS StatusOrder,
			cteTasks.RowNo_Order
		FROM [TaskListView] Tasks 
				INNER JOIN cteTasks ON Tasks.ParentTaskId = cteTasks.TaskId
	)

	-- add records to temp table
	SELECT *
	INTO #Tasks
	FROM cteTasks
	
	-- update page index as per task to be highlighted
	IF @HighlightTaskId > 0
	BEGIN
		DECLARE @RowNumber BIGINT = NULL

		SELECT @RowNumber = RowNo_Order 
		FROM #Tasks 
		WHERE TaskId = @HighlightTaskId

		IF @RowNumber IS NOT NULL
		BEGIN
			SELECT @PageIndex = (CEILING(@RowNumber / CAST(@PageSize AS FLOAT))) - 1
		END
	END		

	SET @StartIndex = (@PageIndex * @PageSize) + 1

	-- get records
	SELECT 
		Tasks.* ,
		TaskApprovals.Id AS TaskApprovalId,
		TaskApprovals.EstimatedHours AS TaskApprovalEstimatedHours,
		TaskApprovals.Description AS TaskApprovalDescription,
		TaskApprovals.UserId AS TaskApprovalUserId,
		TaskApprovals.IsInstallUser AS TaskApprovalIsInstallUser,
		(SELECT TOP 1 EstimatedHours 
			FROM [TaskApprovalsView] TaskApprovals 
			WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 1) AS AdminOrITLeadEstimatedHours,
		(SELECT TOP 1 EstimatedHours 
			FROM [TaskApprovalsView] TaskApprovals
			WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 0) AS UserEstimatedHours
	FROM #Tasks AS Tasks
			LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin
	WHERE 
		RowNo_Order >= @StartIndex AND 
		(
			@PageSize = 0 OR 
			RowNo_Order < (@StartIndex + @PageSize)
		)
	ORDER BY RowNo_Order

	-- get records count
	SELECT
		COUNT(*) AS TotalRecords
	FROM
		[TaskListView] Tasks 
			LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin
			LEFT JOIN [tbltaskassignedusers] tu ON Tasks.TaskId = tu.TaskId
			LEFT JOIN [tblInstallUsers] u ON tu.UserId = u.Id 
	WHERE
		Tasks.ParentTaskId = @TaskId 
		AND (
				@searchterm IS NULL 
				OR u.Fristname like '%'+@searchterm+'%'
			)
		-- condition added by DP 23-jan-17 ---
		--AND Tasks.TaskLevel=1

	-- get page index
	SELECT @PageIndex AS PageIndex

	DROP TABLE #Tasks

END
GO


/****** Object:  StoredProcedure [dbo].[usp_GetSubTasks_New]    Script Date: 28-Mar-17 11:32:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================

-- Author:		Yogesh Keraliya
-- Create date: 04/07/2016
-- Description:	Load all sub tasks of a task.
-- =============================================
-- usp_GetSubTasks_New 418, 1, 'TaskLevel ASC','',1,2,3,4,5,6,7,8,9, 0, 10, 0
ALTER PROCEDURE [dbo].[usp_GetSubTasks_New] 
(
	@TaskId INT,
	@Admin BIT,
	@SortExpression	VARCHAR(250) = 'TaskLevel ASC',
	@searchterm  as varchar(300),
	@OpenStatus		TINYINT = 1,
    @RequestedStatus	TINYINT = 2,
    @AssignedStatus	TINYINT = 3,
    @InProgressStatus	TINYINT = 4,
    @PendingStatus	TINYINT = 5,
    @ReOpenedStatus	TINYINT = 6,
    @ClosedStatus	TINYINT = 7,
    @SpecsInProgressStatus	TINYINT = 8,
    @DeletedStatus	TINYINT = 9,
	@PageIndex INT = NULL, 
	@PageSize INT = NULL,
	@HighlightTaskId INT = 0
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @strt INT
	DECLARE @StartIndex INT  = 0

	IF @searchterm = '' 
	BEGIN
		SET @searchterm = NULL
	END

	IF @PageIndex IS NULL
	BEGIN
		SET @PageIndex = 0
	END

	IF @PageSize IS NULL
	BEGIN
		SET @PageSize = 0
	END

	;WITH
	cteTaskList AS
	(
		SELECT 
			DISTINCT Tasks.*,
			CASE Tasks.[Status]
				WHEN @AssignedStatus THEN 1
				WHEN @RequestedStatus THEN 1

				WHEN @InProgressStatus THEN 2
				WHEN @PendingStatus THEN 2
				WHEN @ReOpenedStatus THEN 2

				WHEN @OpenStatus THEN 
					CASE 
						WHEN ISNULL([TaskPriority],'') <> '' THEN 3
						ELSE 4
					END

				WHEN @SpecsInProgressStatus THEN 4

				WHEN @ClosedStatus THEN 5

				WHEN @DeletedStatus THEN 6

				ELSE 7
			END AS StatusOrder
		FROM 
			[TaskListView] Tasks 
				LEFT JOIN [tbltaskassignedusers] tu ON Tasks.TaskId = tu.TaskId
				LEFT JOIN [tblInstallUsers] u ON tu.UserId = u.Id 
		WHERE
			Tasks.ParentTaskId = @TaskId 
			AND (
					@searchterm IS NULL 
					OR u.Fristname like '%'+@searchterm+'%'
				)
			-- condition added by DP 23-jan-17 ---
			--AND Tasks.TaskLevel=1
	), 
	cteSortedTaskList AS
	(	
		SELECT
			Tasks.*,
			Row_number() OVER
			(
				ORDER BY
					CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
					CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
					CASE WHEN @SortExpression = 'TaskLevel DESC' THEN Tasks.TaskLevel END DESC,
					CASE WHEN @SortExpression = 'TaskLevel ASC' THEN Tasks.TaskLevel END ASC,
					CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
					CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
					CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
					CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
					CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
					CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
					CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
					CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
					CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.StatusOrder END ASC,
					CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.StatusOrder END DESC,
					CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
					CASE WHEN @SortExpression = 'CreatedOn ASC' THEN Tasks.CreatedOn END ASC
			) AS RowNo_Order
		FROM
			cteTaskList Tasks
	)
	,
	cteTasks
	AS
	(
		SELECT t1.*
		FROM cteSortedTaskList t1

		UNION ALL

		SELECT Tasks.*,
			cteTasks.StatusOrder AS StatusOrder,
			cteTasks.RowNo_Order
		FROM [TaskListView] Tasks 
				INNER JOIN cteTasks ON Tasks.ParentTaskId = cteTasks.TaskId
	)

	-- add records to temp table
	SELECT *
	INTO #Tasks
	FROM cteTasks
	
	-- update page index as per task to be highlighted
	IF @HighlightTaskId > 0
	BEGIN
		DECLARE @RowNumber BIGINT = NULL

		SELECT @RowNumber = RowNo_Order 
		FROM #Tasks 
		WHERE TaskId = @HighlightTaskId

		IF @RowNumber IS NOT NULL
		BEGIN
			SELECT @PageIndex = (CEILING(@RowNumber / CAST(@PageSize AS FLOAT))) - 1
		END
	END		

	SET @StartIndex = (@PageIndex * @PageSize) + 1

	-- get records
	SELECT 
		Tasks.* ,
		TaskApprovals.Id AS TaskApprovalId,
		TaskApprovals.EstimatedHours AS TaskApprovalEstimatedHours,
		TaskApprovals.Description AS TaskApprovalDescription,
		TaskApprovals.UserId AS TaskApprovalUserId,
		TaskApprovals.IsInstallUser AS TaskApprovalIsInstallUser,
		(SELECT TOP 1 EstimatedHours 
			FROM [TaskApprovalsView] TaskApprovals 
			WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 1) AS AdminOrITLeadEstimatedHours,
		(SELECT TOP 1 EstimatedHours 
			FROM [TaskApprovalsView] TaskApprovals
			WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 0) AS UserEstimatedHours
	FROM #Tasks AS Tasks
			LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin
	WHERE 
		RowNo_Order >= @StartIndex AND 
		(
			@PageSize = 0 OR 
			RowNo_Order < (@StartIndex + @PageSize)
		)
	ORDER BY RowNo_Order

	-- get records count
	SELECT
		COUNT(*) AS TotalRecords
	FROM
		[TaskListView] Tasks 
			LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin
			LEFT JOIN [tbltaskassignedusers] tu ON Tasks.TaskId = tu.TaskId
			LEFT JOIN [tblInstallUsers] u ON tu.UserId = u.Id 
	WHERE
		Tasks.ParentTaskId = @TaskId 
		AND (
				@searchterm IS NULL 
				OR u.Fristname like '%'+@searchterm+'%'
			)
		-- condition added by DP 23-jan-17 ---
		--AND Tasks.TaskLevel=1

	-- get page index
	SELECT @PageIndex AS PageIndex

	DROP TABLE #Tasks

END
GO


/*
   28 March 201711:59:41
   User: devloperuser
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
ALTER TABLE dbo.tblInstallUsers
	DROP CONSTRAINT FK_tblInstallUsers_AddedByUserID_tblUsers_ID
GO
ALTER TABLE dbo.tblUsers SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblInstallUsers ADD CONSTRAINT
	FK_tblInstallUsers_AddedByUserID_tblInstallUsers_Id FOREIGN KEY
	(
	AddedByUserID
	) REFERENCES dbo.tblInstallUsers
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblInstallUsers SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


/****** Object:  StoredProcedure [dbo].[usp_GetSubTasks_New]    Script Date: 30-Mar-17 12:01:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================

-- Author:		Yogesh Keraliya
-- Create date: 04/07/2016
-- Description:	Load all sub tasks of a task.
-- =============================================
-- usp_GetSubTasks_New 418, 1, 'TaskLevel ASC','',1,2,3,4,5,6,7,8,9, 0, 10, 0
ALTER PROCEDURE [dbo].[usp_GetSubTasks_New] 
(
	@TaskId INT,
	@Admin BIT,
	@SortExpression	VARCHAR(250) = 'TaskLevel ASC',
	@searchterm  as varchar(300),
	@OpenStatus		TINYINT = 1,
    @RequestedStatus	TINYINT = 2,
    @AssignedStatus	TINYINT = 3,
    @InProgressStatus	TINYINT = 4,
    @PendingStatus	TINYINT = 5,
    @ReOpenedStatus	TINYINT = 6,
    @ClosedStatus	TINYINT = 7,
    @SpecsInProgressStatus	TINYINT = 8,
    @DeletedStatus	TINYINT = 9,
	@PageIndex INT = NULL, 
	@PageSize INT = NULL,
	@HighlightTaskId INT = 0
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @strt INT
	DECLARE @StartIndex INT  = 0

	IF @searchterm = '' 
	BEGIN
		SET @searchterm = NULL
	END

	IF @PageIndex IS NULL
	BEGIN
		SET @PageIndex = 0
	END

	IF @PageSize IS NULL
	BEGIN
		SET @PageSize = 0
	END

	;WITH
	cteTaskList AS
	(
		SELECT 
			DISTINCT Tasks.*,
			CASE Tasks.[Status]
				WHEN @AssignedStatus THEN 1
				WHEN @RequestedStatus THEN 1

				WHEN @InProgressStatus THEN 2
				WHEN @PendingStatus THEN 2
				WHEN @ReOpenedStatus THEN 2

				WHEN @OpenStatus THEN 
					CASE 
						WHEN ISNULL([TaskPriority],'') <> '' THEN 3
						ELSE 4
					END

				WHEN @SpecsInProgressStatus THEN 4

				WHEN @ClosedStatus THEN 5

				WHEN @DeletedStatus THEN 6

				ELSE 7
			END AS StatusOrder
		FROM 
			[TaskListView] Tasks 
				LEFT JOIN [tbltaskassignedusers] tu ON Tasks.TaskId = tu.TaskId
				LEFT JOIN [tblInstallUsers] u ON tu.UserId = u.Id 
		WHERE
			Tasks.ParentTaskId = @TaskId 
			AND (
					@searchterm IS NULL 
					OR u.Fristname like '%'+@searchterm+'%'
				)
			-- condition added by DP 23-jan-17 ---
			--AND Tasks.TaskLevel=1
	), 
	cteSortedTaskList AS
	(	
		SELECT
			Tasks.*,
			Row_number() OVER
			(
				ORDER BY
					CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
					CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
					CASE WHEN @SortExpression = 'TaskLevel DESC' THEN Tasks.TaskLevel END DESC,
					CASE WHEN @SortExpression = 'TaskLevel ASC' THEN Tasks.TaskLevel END ASC,
					CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
					CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
					CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
					CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
					CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
					CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
					CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
					CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
					CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.StatusOrder END ASC,
					CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.StatusOrder END DESC,
					CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
					CASE WHEN @SortExpression = 'CreatedOn ASC' THEN Tasks.CreatedOn END ASC
			) AS RowNo_Order
		FROM
			cteTaskList Tasks
	)
	,
	cteTasks
	AS
	(
		SELECT t1.*, 0 AS NestLevel
		FROM cteSortedTaskList t1

		UNION ALL

		SELECT Tasks.*,
			cteTasks.StatusOrder AS StatusOrder,
			cteTasks.RowNo_Order,
			(cteTasks.NestLevel + 1) AS NestLevel
		FROM [TaskListView] Tasks 
				INNER JOIN cteTasks ON Tasks.ParentTaskId = cteTasks.TaskId
	)

	-- add records to temp table
	SELECT *
	INTO #Tasks
	FROM cteTasks
	
	-- update page index as per task to be highlighted
	IF @HighlightTaskId > 0
	BEGIN
		DECLARE @RowNumber BIGINT = NULL

		SELECT @RowNumber = RowNo_Order 
		FROM #Tasks 
		WHERE TaskId = @HighlightTaskId

		IF @RowNumber IS NOT NULL
		BEGIN
			SELECT @PageIndex = (CEILING(@RowNumber / CAST(@PageSize AS FLOAT))) - 1
		END
	END		

	SET @StartIndex = (@PageIndex * @PageSize) + 1

	-- get records
	SELECT 
		Tasks.* ,
		TaskApprovals.Id AS TaskApprovalId,
		TaskApprovals.EstimatedHours AS TaskApprovalEstimatedHours,
		TaskApprovals.Description AS TaskApprovalDescription,
		TaskApprovals.UserId AS TaskApprovalUserId,
		TaskApprovals.IsInstallUser AS TaskApprovalIsInstallUser,
		(SELECT TOP 1 EstimatedHours 
			FROM [TaskApprovalsView] TaskApprovals 
			WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 1) AS AdminOrITLeadEstimatedHours,
		(SELECT TOP 1 EstimatedHours 
			FROM [TaskApprovalsView] TaskApprovals
			WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 0) AS UserEstimatedHours
	FROM #Tasks AS Tasks
			LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin
	WHERE 
		RowNo_Order >= @StartIndex AND 
		(
			@PageSize = 0 OR 
			RowNo_Order < (@StartIndex + @PageSize)
		)
	ORDER BY RowNo_Order

	-- get records count
	SELECT
		COUNT(*) AS TotalRecords
	FROM
		[TaskListView] Tasks 
			LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin
			LEFT JOIN [tbltaskassignedusers] tu ON Tasks.TaskId = tu.TaskId
			LEFT JOIN [tblInstallUsers] u ON tu.UserId = u.Id 
	WHERE
		Tasks.ParentTaskId = @TaskId 
		AND (
				@searchterm IS NULL 
				OR u.Fristname like '%'+@searchterm+'%'
			)
		-- condition added by DP 23-jan-17 ---
		--AND Tasks.TaskLevel=1

	-- get page index
	SELECT @PageIndex AS PageIndex

	DROP TABLE #Tasks

END
GO



/****** Object:  StoredProcedure [dbo].[usp_GetSubTasks_New]    Script Date: 01-Apr-17 7:45:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================

-- Author:		Yogesh Keraliya
-- Create date: 04/07/2016
-- Description:	Load all sub tasks of a task.
-- =============================================
-- usp_GetSubTasks_New 418, 1, 'TaskLevel ASC','',1,2,3,4,5,6,7,8,9, 0, 10, 0
ALTER PROCEDURE [dbo].[usp_GetSubTasks_New] 
(
	@TaskId INT,
	@Admin BIT,
	@SortExpression	VARCHAR(250) = 'TaskLevel ASC',
	@searchterm  as varchar(300),
	@OpenStatus		TINYINT = 1,
    @RequestedStatus	TINYINT = 2,
    @AssignedStatus	TINYINT = 3,
    @InProgressStatus	TINYINT = 4,
    @PendingStatus	TINYINT = 5,
    @ReOpenedStatus	TINYINT = 6,
    @ClosedStatus	TINYINT = 7,
    @SpecsInProgressStatus	TINYINT = 8,
    @DeletedStatus	TINYINT = 9,
	@PageIndex INT = NULL, 
	@PageSize INT = NULL,
	@HighlightTaskId INT = 0
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @strt INT
	DECLARE @StartIndex INT  = 0

	IF @searchterm = '' 
	BEGIN
		SET @searchterm = NULL
	END

	IF @PageIndex IS NULL
	BEGIN
		SET @PageIndex = 0
	END

	IF @PageSize IS NULL
	BEGIN
		SET @PageSize = 0
	END

	;WITH
	cteTaskList AS
	(
		SELECT 
			DISTINCT Tasks.*,
			CASE Tasks.[Status]
				WHEN @AssignedStatus THEN 1
				WHEN @RequestedStatus THEN 1

				WHEN @InProgressStatus THEN 2
				WHEN @PendingStatus THEN 2
				WHEN @ReOpenedStatus THEN 2

				WHEN @OpenStatus THEN 
					CASE 
						WHEN ISNULL([TaskPriority],'') <> '' THEN 3
						ELSE 4
					END

				WHEN @SpecsInProgressStatus THEN 4

				WHEN @ClosedStatus THEN 5

				WHEN @DeletedStatus THEN 6

				ELSE 7
			END AS StatusOrder
		FROM 
			[TaskListView] Tasks 
				LEFT JOIN [tbltaskassignedusers] tu ON Tasks.TaskId = tu.TaskId
				LEFT JOIN [tblInstallUsers] u ON tu.UserId = u.Id 
		WHERE
			Tasks.ParentTaskId = @TaskId 
			AND (
					@searchterm IS NULL 
					OR u.Fristname like '%'+@searchterm+'%'
				)
			-- condition added by DP 23-jan-17 ---
			--AND Tasks.TaskLevel=1
	), 
	cteSortedTaskList AS
	(	
		SELECT
			Tasks.*,
			Row_number() OVER
			(
				ORDER BY
					CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,
					CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,
					CASE WHEN @SortExpression = 'TaskLevel DESC' THEN Tasks.TaskLevel END DESC,
					CASE WHEN @SortExpression = 'TaskLevel ASC' THEN Tasks.TaskLevel END ASC,
					CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,
					CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,
					CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,
					CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,
					CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,
					CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,
					CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,
					CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,
					CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,
					CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.StatusOrder END ASC,
					CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.StatusOrder END DESC,
					CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,
					CASE WHEN @SortExpression = 'CreatedOn ASC' THEN Tasks.CreatedOn END ASC
			) AS RowNo_Order
		FROM
			cteTaskList Tasks
	)
	,
	cteTasks
	AS
	(
		SELECT 
			t1.*, 
			1 AS NestLevel
		FROM cteSortedTaskList t1

		UNION ALL

		SELECT Tasks.*,
			cteTasks.StatusOrder AS StatusOrder,
			cteTasks.RowNo_Order,
			(cteTasks.NestLevel + 1) AS NestLevel
		FROM [TaskListView] Tasks 
				INNER JOIN cteTasks ON Tasks.ParentTaskId = cteTasks.TaskId
	)

	-- add records to temp table
	SELECT *
	INTO #Tasks
	FROM cteTasks
	
	-- update page index as per task to be highlighted
	IF @HighlightTaskId > 0
	BEGIN
		DECLARE @RowNumber BIGINT = NULL

		SELECT @RowNumber = RowNo_Order 
		FROM #Tasks 
		WHERE TaskId = @HighlightTaskId

		IF @RowNumber IS NOT NULL
		BEGIN
			SELECT @PageIndex = (CEILING(@RowNumber / CAST(@PageSize AS FLOAT))) - 1
		END
	END		

	SET @StartIndex = (@PageIndex * @PageSize) + 1

	-- get records
	SELECT 
		Tasks.* ,
		TaskApprovals.Id AS TaskApprovalId,
		TaskApprovals.EstimatedHours AS TaskApprovalEstimatedHours,
		TaskApprovals.Description AS TaskApprovalDescription,
		TaskApprovals.UserId AS TaskApprovalUserId,
		TaskApprovals.IsInstallUser AS TaskApprovalIsInstallUser,
		(SELECT TOP 1 EstimatedHours 
			FROM [TaskApprovalsView] TaskApprovals 
			WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 1) AS AdminOrITLeadEstimatedHours,
		(SELECT TOP 1 EstimatedHours 
			FROM [TaskApprovalsView] TaskApprovals
			WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 0) AS UserEstimatedHours,
		(SELECT TOP 1 InstallId 
			FROM tblTask t 
			WHERE ParentTaskId = Tasks.TaskId 
			ORDER BY t.TaskId DESC) AS LastSubTaskInstallId
	FROM #Tasks AS Tasks
			LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin
	WHERE 
		RowNo_Order >= @StartIndex AND 
		(
			@PageSize = 0 OR 
			RowNo_Order < (@StartIndex + @PageSize)
		)
	ORDER BY RowNo_Order

	-- get records count
	SELECT
		COUNT(*) AS TotalRecords
	FROM
		[TaskListView] Tasks 
			LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin
			LEFT JOIN [tbltaskassignedusers] tu ON Tasks.TaskId = tu.TaskId
			LEFT JOIN [tblInstallUsers] u ON tu.UserId = u.Id 
	WHERE
		Tasks.ParentTaskId = @TaskId 
		AND (
				@searchterm IS NULL 
				OR u.Fristname like '%'+@searchterm+'%'
			)
		-- condition added by DP 23-jan-17 ---
		--AND Tasks.TaskLevel=1

	-- get page index
	SELECT @PageIndex AS PageIndex

	DROP TABLE #Tasks
	
	-- gets last sub task installId
	SELECT TOP 1 InstallId AS LastSubTaskInstallId
	FROM tblTask t 
	WHERE ParentTaskId = @TaskId
	ORDER BY t.TaskId DESC
	
END
GO



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Live publish 04042017

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
