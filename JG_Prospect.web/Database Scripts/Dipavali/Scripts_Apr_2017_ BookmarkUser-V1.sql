

CREATE TABLE [dbo].[InstallUserBMLog](
	[Id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[bookmarkedUser] [numeric](18, 0) NULL,
	[bookmarkingUser] [numeric](18, 0) NULL,
	[createdDateTime] [datetime] NULL,
	[isDeleted] [int] NULL,
 CONSTRAINT [PK_InstallUserBMLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO



create PROCEDURE [dbo].[GetBookMarkingUserDetails]    
(
@Id int  
)
AS    
BEGIN    


SELECT       t.Id, FristName, LastName, Email,Designation,ISNULL (t.UserInstallId ,t.id) As UserInstallId ,    b.createdDateTime
FROM         InstallUserBMLog as b,   tblInstallUsers AS t
WHERE			b.bookmarkedUser  = @Id  and b.bookmarkingUser=t.Id
				and b.isDeleted=0

END




create PROCEDURE [dbo].[GetStarBookMarkUsers]
	-- Add the parameters for the stored procedure here
	@bookmarkedUser int,
	@bookmarkingUser int,
	@isdelete int
AS
BEGIN


	if @isdelete=0 
		begin 

			declare @cnt int =0
			set @cnt = (select count(*) from InstallUserBMLog where bookmarkedUser=@bookmarkedUser and bookmarkingUser=@bookmarkingUser  )
			select @cnt

			if @cnt>0
				begin
					update dbo.InstallUserBMLog 
					set  isDeleted = @isdelete
					where bookmarkedUser=@bookmarkedUser and bookmarkingUser=@bookmarkingUser

				end
			else
				begin
					-- Insert statements for procedure here
					insert into dbo.InstallUserBMLog 
					(bookmarkedUser,bookmarkingUser,createdDateTime,isDeleted)
					values
					(@bookmarkedUser,@bookmarkingUser,getdate(),@isdelete )

				end
		end
	else
		begin

				-- Insert statements for procedure here
			update dbo.InstallUserBMLog 
			 set  isDeleted = @isdelete
			where bookmarkedUser=@bookmarkedUser and bookmarkingUser=@bookmarkingUser
		end 
	 
END




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
   bm.bookmarkedUser, 
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
	 left outer join InstallUserBMLog as bm on t.id  =bm.bookmarkedUser and bm.isDeleted=0
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
   --AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))    
   AND ISNULL(t1.Id,t2.Id)=ISNULL(@AddedByUserId,ISNULL(t1.Id,t2.Id))    
   AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)     
   AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)    
 )    
    
 SELECT Id,    
   FristName,    
   LastName,    
   Phone,    
   Zip,    
    Designation,    
   Status,    
   HireDate,    
   InstallId,    
   picture,     
   CreatedDateTime,     
   Source,    
   SourceUser,     
   AddedBy ,    
    UserInstallId ,     
   InterviewDetail,    
   RejectDetail,    
   Email,     
   DesignationID,     
     AddedByUserInstallId,     
   AddedById ,     
   EmpType  ,  
    [Aggregate] ,    
    PrimaryPhone ,     
   CountryCode,     
   Resumepath  ,  
   TechTaskId ,
   ParentTechTaskId ,
   TechTaskInstallId   , 
   bookmarkedUser    
 FROM SalesUsers    
 WHERE     
  RowNumber >= @StartIndex AND     
  (    
   @PageSize = 0 OR     
   RowNumber < (@StartIndex + @PageSize)    
  )    
    group by 
   Id,    
   FristName,    
   LastName,    
   Phone,    
   Zip,    
    Designation,    
   Status,    
   HireDate,    
   InstallId,    
   picture,     
   CreatedDateTime,     
   Source,    
   SourceUser,     
   AddedBy ,    
    UserInstallId ,     
   InterviewDetail,    
   RejectDetail,    
   Email,     
   DesignationID,     
     AddedByUserInstallId,     
   AddedById ,     
   EmpType  ,  
    [Aggregate] ,    
    PrimaryPhone ,     
   CountryCode,     
   Resumepath  ,  
   TechTaskId ,
   ParentTechTaskId ,
   TechTaskInstallId   , 
   bookmarkedUser
    
   ORDER BY    
         CASE WHEN @SortExpression = 'Id ASC' THEN Id END ASC,    
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
         CASE WHEN @SortExpression = 'CreatedDateTime DESC' THEN CreatedDateTime END DESC    

    
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


