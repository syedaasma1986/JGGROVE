/*
   Tuesday, June 27, 20172:20:13 PM
   User: jgrovesa
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
ALTER TABLE dbo.tblAssignedSequencing
	DROP CONSTRAINT FK_tblAssignedSequencing_tblInstallUsers
GO
ALTER TABLE dbo.tblInstallUsers SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblInstallUsers', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblInstallUsers', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblInstallUsers', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblAssignedSequencing
	DROP CONSTRAINT FK_tblAssignedSequencing_tblTask
GO
ALTER TABLE dbo.tblTask SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblTask', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblTask', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblTask', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblAssignedSequencing
	DROP CONSTRAINT DF_tblAssignedSequencing_CreatedDateTime
GO
ALTER TABLE dbo.tblAssignedSequencing
	DROP CONSTRAINT DF_tblAssignedSequencing_ModifiedDateTime
GO
CREATE TABLE dbo.Tmp_tblAssignedSequencing
	(
	Id bigint NOT NULL IDENTITY (1, 1),
	DesignationId int NOT NULL,
	AssignedDesigSeq bigint NOT NULL,
	UserId int NOT NULL,
	IsTechTask bit NOT NULL,
	TaskId bigint NOT NULL,
	IsTemp bit NOT NULL,
	CreatedDateTime datetime NULL,
	ModifiedDateTime datetime NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblAssignedSequencing SET (LOCK_ESCALATION = TABLE)
GO
ALTER TABLE dbo.Tmp_tblAssignedSequencing ADD CONSTRAINT
	DF_tblAssignedSequencing_IsTemp DEFAULT 1 FOR IsTemp
GO
ALTER TABLE dbo.Tmp_tblAssignedSequencing ADD CONSTRAINT
	DF_tblAssignedSequencing_CreatedDateTime DEFAULT (getdate()) FOR CreatedDateTime
GO
ALTER TABLE dbo.Tmp_tblAssignedSequencing ADD CONSTRAINT
	DF_tblAssignedSequencing_ModifiedDateTime DEFAULT (getdate()) FOR ModifiedDateTime
GO
SET IDENTITY_INSERT dbo.Tmp_tblAssignedSequencing ON
GO
IF EXISTS(SELECT * FROM dbo.tblAssignedSequencing)
	 EXEC('INSERT INTO dbo.Tmp_tblAssignedSequencing (Id, DesignationId, AssignedDesigSeq, UserId, IsTechTask, TaskId, CreatedDateTime, ModifiedDateTime)
		SELECT Id, DesignationId, AssignedDesigSeq, UserId, IsTechTask, TaskId, CreatedDateTime, ModifiedDateTime FROM dbo.tblAssignedSequencing WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblAssignedSequencing OFF
GO
DROP TABLE dbo.tblAssignedSequencing
GO
EXECUTE sp_rename N'dbo.Tmp_tblAssignedSequencing', N'tblAssignedSequencing', 'OBJECT' 
GO
ALTER TABLE dbo.tblAssignedSequencing ADD CONSTRAINT
	PK_tblAssignedSequencing PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tblAssignedSequencing ADD CONSTRAINT
	FK_tblAssignedSequencing_tblTask FOREIGN KEY
	(
	TaskId
	) REFERENCES dbo.tblTask
	(
	TaskId
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblAssignedSequencing ADD CONSTRAINT
	FK_tblAssignedSequencing_tblInstallUsers FOREIGN KEY
	(
	UserId
	) REFERENCES dbo.tblInstallUsers
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblAssignedSequencing', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblAssignedSequencing', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblAssignedSequencing', 'Object', 'CONTROL') as Contr_Per 

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_GetUserAssignedDesigSequencnce]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_GetUserAssignedDesigSequencnce   

	END  
GO    
-- =============================================  
-- Author:  Yogesh Keraliya  
-- Create date: 06092017  
-- Description: This will fetch latest sequence assigned to same designation  
-- =============================================  
 -- usp_GetLastAssignedDesigSequencnce 10,0  
  
CREATE PROCEDURE usp_GetUserAssignedDesigSequencnce   
( -- Add the parameters for the stored procedure here  
 @DesignationId INT ,  
 @IsTechTask BIT,
 @UserID  INT  
)  
AS  
BEGIN  

-- Check if already assigned sequence available to given user.

IF NOT EXISTS ( SELECT [Id] FROM tblAssignedSequencing WHERE UserId = @UserID)
BEGIN

INSERT INTO tblAssignedSequencing  
                         (AssignedDesigSeq, UserId, IsTechTask, TaskId, CreatedDateTime, DesignationId,IsTemp)  
SELECT  TOP 1 ISNULL([Sequence],1), @UserID, @IsTechTask , TaskId, GETDATE() , @DesignationId, 1 FROM tblTask   
WHERE [SequenceDesignationId] = @DesignationID AND IsTechTask = @IsTechTask AND [Sequence] IS NOT NULL AND [Sequence] > (     
  
  SELECT       ISNULL(MAX(AssignedDesigSeq),0) AS LastAssignedSequence  
   FROM            tblAssignedSequencing  
  WHERE        (DesignationId = @DesignationId) AND (IsTechTask = @IsTechTask)  
  
)   
ORDER BY [Sequence] ASC  

END 

-- Get newly assigned sequence from inserted sequence / Already assigned sequence
SELECT  Id,[AssignedDesigSeq] AS [AvailableSequence],TBA.TaskId, dbo.udf_GetParentTaskId(TBA.TaskId) AS ParentTaskId, 
(SELECT Title FROM tblTask WHERE TaskId =  dbo.udf_GetParentTaskId(TBA.TaskId)) AS ParentTitle , dbo.udf_GetCombineInstallId(TBA.TaskId) AS InstallId , T.Title 

FROM tblTask AS T 

INNER JOIN tblAssignedSequencing AS TBA ON TBA.TaskId = T.TaskId
 
WHERE TBA.UserId = @UserId	AND TBA.IsTemp = 1
  
END    


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_UpdateUserAssignedSeqAcceptance]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_UpdateUserAssignedSeqAcceptance   

	END  
GO    
-- =============================================  
-- Author:  Yogesh Keraliya  
-- Create date: 06092017  
-- Description: This will update user assigned sequence status to accepted.
-- =============================================  
  
CREATE PROCEDURE usp_UpdateUserAssignedSeqAcceptance   
(   
 @AssignedSeqID INT
)  
AS  
BEGIN  

	UPDATE       tblAssignedSequencing
	SET                IsTemp = 0
	WHERE        (Id = @AssignedSeqID)

END


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_RemoveUserAssignedSeq]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_RemoveUserAssignedSeq   

	END  
GO    
-- =============================================  
-- Author:  Yogesh Keraliya  
-- Create date: 06092017  
-- Description: This will remove any assigned sequence to user , assign task to user and set its status 
-- to rejected with reject reason.
-- =============================================  
  
CREATE PROCEDURE usp_RemoveUserAssignedSeq   
(   
 @AssignedSeqID BIGINT,
 @UserId INT,
 @RejectedUserID INT 
)  
AS  
BEGIN  

-- Remove Assigned sequence from tblAssignedSequence
DELETE FROM  tblAssignedSequencing	WHERE (Id = @AssignedSeqID)

-- Remove Assigned Task from TaskAssigned table

DELETE FROM tblTaskAssignedUsers WHERE UserId = @UserId

-- Set STATUS TO Rejected with reject reason.
UPDATE tblInstallUsers SET [Status] = 9 , RejectionTime = GETDATE(), RejectedUserId = @RejectedUserID, RejectionDate = GETDATE(), StatusReason = 'Rejected Auto Assigned Task' WHERE Id = @UserId

END     


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Live publish 06272017

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_CheckEmailSubscription]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_CheckEmailSubscription   

	END  
GO    
-- =============================================  
-- Author:  Yogesh Keraliya  
-- Create date: 06282017  
-- Description: This will check email subscription for given email address.
-- =============================================  
 -- usp_CheckEmailSubscription 'error@kerconsultancy.com'  
  
CREATE PROCEDURE usp_CheckEmailSubscription   
( 
@Email VARCHAR(250)
)  
AS  
BEGIN  

		SELECT        UnSubscribeId
		FROM            tblUnsubscriberList
		WHERE        (Email = @Email)
  
END    



IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[SaveDesignationSMSTemplate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE SaveDesignationSMSTemplate   

	END  
GO
-- =============================================  
-- Author:  Yogesh  
-- Create date: 27 Jan 2017  
-- Description: Saves designation HTMLTemplate either inserts or updates.  
-- =============================================  
CREATE PROCEDURE [dbo].[SaveDesignationSMSTemplate]  
 (

 @HTMLTemplatesMasterId INT,  
 @MasterCategory   TINYINT,  
 @Designation   VARCHAR(50),  
 @Body     NVARCHAR(max)
 
 )
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
      [Body] = @Body  
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
       ,''  
       ,''
       ,@Body  
       ,''
       ,GETDATE())  
  END  
  
END  

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_updateMasterSMSTemplate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_updateMasterSMSTemplate   

	END  
GO
-- =============================================  
-- Author:  Yogesh Keraliya  
-- Create date: 06/21/2017  
-- Description: This will update master template data for given HTML template ID  
-- =============================================  
CREATE PROCEDURE usp_updateMasterSMSTemplate  
(  -- Add the parameters for the stored procedure here  
 @MasterTemplateID int,  
 @Body VARCHAR(max)
)  
AS  
BEGIN  
  
UPDATE       tblHTMLTemplatesMaster  
SET                 Body = @Body, DateUpdated = GETDATE()  
WHERE [Id] = @MasterTemplateID  
  
  
END    

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_RevertTemplatesToMasterSMSTemplate]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_RevertTemplatesToMasterSMSTemplate     

	END  
GO
-- =============================================  
-- Author:  Yogesh Keraliya  
-- Create date: 06/21/2017  
-- Description: This will revert all child templates of master HTML template for given HTML template ID  
-- =============================================  
CREATE PROCEDURE usp_RevertTemplatesToMasterSMSTemplate  
(   
 -- Add the parameters for the stored procedure here  
 @MasterTemplateID int   
)  
AS  
BEGIN  
  
-- get master template header, body, footer, subject  
DECLARE @Body VARCHAR(max)  

  
SELECT        @Body = Body
FROM            tblHTMLTemplatesMaster  
WHERE        (Id = @MasterTemplateID)  
  
-- update already existing designation html templates.  
UPDATE       tblDesignationHTMLTemplates  
SET                 Body = @Body, DateUpdated = GETDATE()  
WHERE [HTMLTemplatesMasterId] = @MasterTemplateID  
  
  
-- Insert templates which are not already available.  
INSERT INTO tblDesignationHTMLTemplates  
                         (Designation,[Subject], Header, Body, Footer, DateUpdated, HTMLTemplatesMasterId)  
SELECT   CONVERT(VARCHAR(50), D.ID) , '', '', @Body, '', GETDATE(), @MasterTemplateID  
FROM     [dbo].[tbl_Designation] AS D   
WHERE  D.IsActive = 1 AND D.ID NOT IN (SELECT CONVERT(INT,Designation) FROM tblDesignationHTMLTemplates WHERE HTMLTemplatesMasterId = @MasterTemplateID)  
  
END  


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Live publish 06302017

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[sp_GetHrData]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE sp_GetHrData   

	END  
GO

-- =============================================        
-- Author:  Yogesh        
-- Create date: 16 Jan 2017        
-- Description: Gets statictics and records for edit user page.        
-- =============================================        
-- [sp_GetHrData] NULL,'0',0 ,0 , 0, NULL, NULL,0,20, 'CreatedDateTime DESC','5','9','6','1'        
CREATE PROCEDURE [dbo].[sp_GetHrData]        
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
   RejectDetail = case when (t.[Status]=@RejectedStatus ) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR) + ' ' + coalesce(t.RejectionTime,'') 
         else '' end,  
   CASE when (t.[Status]= @RejectedStatus ) THEN t.RejectedUserId ELSE NULL END AS RejectedUserId,
   CASE when (t.[Status]= @RejectedStatus ) THEN ru.FristName + ' ' + ru.LastName ELSE NULL END AS RejectedByUserName,
   CASE when (t.[Status]= @RejectedStatus ) THEN ru.[UserInstallId]  ELSE NULL END AS RejectedByUserInstallId,         
   t.Email,         
   t.DesignationID,         
   ISNULL(t1.[UserInstallId] , t2.[UserInstallId]) As AddedByUserInstallId,         
   ISNULL(t1.Id,t2.Id) As AddedById ,         
   0 as 'EmpType',           
   t.Phone As PrimaryPhone ,         
   t.CountryCode,         
   t.Resumepath  ,      
   --ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId ,       
   Task.TaskId AS 'TechTaskId',    
   Task.ParentTaskId AS 'ParentTechTaskId',     
   Task.InstallId as 'TechTaskInstallId',       
   bm.bookmarkedUser,   
   t.[StatusReason],  
   dbo.udf_GetUserExamPercentile(t.Id) AS [Aggregate] ,  
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
	LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId= ru.Id        
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
   RejectedUserId, 
   RejectedByUserName, 
   RejectedByUserInstallId,       
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
   bookmarkedUser,  
   [StatusReason]    
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
   [Status],        
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
   RejectedUserId,
   RejectedByUserName,
   RejectedByUserInstallId,       
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
   bookmarkedUser,  
   [StatusReason]  
        
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

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[GetInstallUsersForBulkEmail]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE GetInstallUsersForBulkEmail   

	END  
GO

-- =============================================          
        
-- Author:  Yogesh          
       
-- Create date: 16 June 2017          
        
-- Description: Gets all Install Users with status Applicant, Referal Applicant,InterviewDate.          
      
-- =============================================          
        
CREATE PROCEDURE [dbo].[GetInstallUsersForBulkEmail]          
(    
@DesignationId INT    
)    
AS          
        
BEGIN          
        
 SET NOCOUNT ON;          
          
 SELECT * FROM tblInstallUsers WHERE RTRIM(LTRIM([Status])) IN ('2','5','10') AND DesignationID = @DesignationId    
         
END 

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Live publish 07042017

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_SwapTaskSequences]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_SwapTaskSequences   

	END  
GO

  
-- =============================================                
-- Author:  Yogesh Keraliya                
-- Create date: 07172017                
-- Description: This will swap sequence between two tasks.                
-- =============================================                
-- usp_GetAllTaskWithSequence 0,20,'',10,575          
CREATE PROCEDURE usp_SwapTaskSequences                 
(                
              
 @FirstTaskID BIGINT = 0,                 
 @SecondTaskID BIGINT = 0,                 
 @FirstSeq BIGINT = 0,          
 @SecondSeq BIGINT = 0                  
)                
As                
BEGIN                
   
  UPDATE       tblTask
  SET                [Sequence] = @SecondSeq
  WHERE        (TaskId = @FirstTaskID)        
  
  UPDATE       tblTask
  SET                [Sequence] = @FirstSeq
  WHERE        (TaskId = @SecondTaskID)        
  
              
END 


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_GetParentTaskDesignations]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_GetParentTaskDesignations   

	END  
GO

  
-- =============================================                
-- Author:  Yogesh Keraliya                
-- Create date: 07182017                
-- Description: This will load designation for parent tasks.                
-- =============================================                
-- usp_GetParentTaskDesignations 402          
CREATE PROCEDURE usp_GetParentTaskDesignations                 
(                
              
 @ParentTaskID BIGINT = 0                 
 
)                
As                
BEGIN                
   
  SELECT        tbl_Designation.ID, tbl_Designation.DesignationName
FROM            tblTaskDesignations INNER JOIN
                         tbl_Designation ON tblTaskDesignations.DesignationID = tbl_Designation.ID
WHERE        (tblTaskDesignations.TaskId = @ParentTaskID)
              
END 


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Live publish 07182017

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_GetAllTaskWithSequence]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_GetAllTaskWithSequence   

	END  
GO  
-- =============================================                
-- Author:  Yogesh Keraliya                
-- Create date: 05222017                
-- Description: This will load all tasks with title and sequence                
-- =============================================                
-- usp_GetAllTaskWithSequence 0,20,'',10,575          
CREATE PROCEDURE usp_GetAllTaskWithSequence                 
(                
               
 @PageIndex INT = 0,                 
 @PageSize INT =20,          
 @DesignationIds VARCHAR(20) = NULL,          
 @IsTechTask BIT = 0,          
 @HighLightedTaskID BIGINT = NULL          
                  
)                
As                
BEGIN                
          
          
IF( @DesignationIds = '' )          
BEGIN          
          
 SET @DesignationIds = NULL          
          
END          
                
                
;WITH                 
 Tasklist AS                
 (                 
  SELECT DISTINCT TaskId ,[Status],[SequenceDesignationId],[Sequence],               
  Title,ParentTaskId,IsTechTask,ParentTaskTitle,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,  TaskDesignation,
  [AdminStatus] , [TechLeadStatus], [OtherUserStatus],[AdminStatusUpdated],[TechLeadStatusUpdated],[OtherUserStatusUpdated],[AdminUserId],[TechLeadUserId],[OtherUserId], 
  AdminUserInstallId, AdminUserFirstName, AdminUserLastName,
  TechLeadUserInstallId,ITLeadHours,UserHours, TechLeadUserFirstName, TechLeadUserLastName,
  OtherUserInstallId, OtherUserFirstName,OtherUserLastName,
  case                 
   when (ParentTaskId is null and  TaskLevel=1) then InstallId                 
   when (tasklevel =1 and ParentTaskId>0) then                 
    (select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId                  
   when (tasklevel =2 and ParentTaskId>0) then                
    (select InstallId from tbltask where taskid in (                
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))                
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId                 
                     
   when (tasklevel =3 and ParentTaskId>0) then                
   (select InstallId from tbltask where taskid in (                
   (select parenttaskid from tbltask where taskid in (                
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))                
   +'-'+                
    (select InstallId from tbltask where taskid in (                
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))                
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId                 
  end as 'InstallId' ,Row_number() OVER (order by x.TaskId ) AS RowNo_Order                
  from (                
   select DISTINCT a.*                
   ,(select Title from tbltask where TaskId=(select * from [GetParent](a.TaskId))) AS ParentTaskTitle,
   (SELECT EstimatedHours FROM [dbo].[tblTaskApprovals] WHERE TaskId = a.TaskId AND UserId = a.TechLeadUserId) AS ITLeadHours , (SELECT EstimatedHours FROM [dbo].[tblTaskApprovals] WHERE TaskId = a.TaskId AND UserId = a.OtherUserId) AS UserHours,
   ta.InstallId AS AdminUserInstallId, ta.FristName AS AdminUserFirstName, ta.LastName AS AdminUserLastName,
   tT.InstallId AS TechLeadUserInstallId, tT.FristName AS TechLeadUserFirstName, tT.LastName AS TechLeadUserLastName,
   tU.InstallId AS OtherUserInstallId, tU.FristName AS OtherUserFirstName, tU.LastName AS OtherUserLastName,
   --,t.FristName + ' ' + t.LastName AS Assigneduser,              
   (              
   STUFF((SELECT ', {"Name": "' + Designation +'","Id":'+ CONVERT(VARCHAR(5),DesignationID)+'}'            
           FROM tblTaskdesignations td               
           WHERE td.TaskID = a.TaskId               
          FOR XML PATH('')), 1, 2, '')              
  )  AS TaskDesignation      
  --(SELECT TOP 1 DesignationID             
  --         FROM tblTaskdesignations td               
  --         WHERE td.TaskID = a.TaskId ) AS DesignationId             
   from  tbltask a                
   --LEFT OUTER JOIN tblTaskdesignations as b ON a.TaskId = b.TaskId                 
   --LEFT OUTER JOIN tbltaskassignedusers as c ON a.TaskId = c.TaskId                
   LEFT OUTER JOIN tblInstallUsers as ta ON a.[AdminUserId] = ta.Id 
   LEFT OUTER JOIN tblInstallUsers as tT ON a.[TechLeadUserId] = tT.Id 
   LEFT OUTER JOIN tblInstallUsers as tU ON a.[OtherUserId] = tU.Id                  
   WHERE           
  (           
    (a.[Sequence] IS NOT NULL)           
    AND (a.[SequenceDesignationId] IN (SELECT * FROM [dbo].[SplitString](ISNULL(@DesignationIds,a.[SequenceDesignationId]),',') ) )           
    AND (ISNULL(a.[IsTechTask],@IsTechTask) = @IsTechTask)          
             
   )           
   OR          
   (          
     a.TaskId = @HighLightedTaskID  AND IsTechTask = @IsTechTask        
   )               
   --and (CreatedOn >=@startdate and CreatedOn <= @enddate )                 
  ) as x                
 )      
                
 ---- get CTE data into temp table                
 SELECT *                
 INTO #Tasks                
 FROM Tasklist                
          
---- find page number to show taskid sent.          
DECLARE @StartIndex INT  = 0                
          
                
--IF @HighLightedTaskID  > 0          
-- BEGIN          
--  DECLARE @RowNumber BIGINT = NULL          
          
--  -- Find in which rownumber highlighter taskid is.          
--  SELECT @RowNumber = RowNo_Order           
--  FROM #Tasks           
--  WHERE TaskId = @HighLightedTaskID          
          
--  -- if row number found then divide it with page size and round it to nearest integer , so will found pagenumber to be selected.          
--  -- for ex. if total 60 records are there,pagesize is 20 and highlighted task id is at 42 row number than.           
--  -- 42/20 = 2.1 ~ 3 - 1 = 2 = @Page Index          
--  -- StartIndex = (2*20)+1 = 41, so records 41 to 60 will be fetched.          
             
--  IF @RowNumber IS NOT NULL          
--  BEGIN          
--   SELECT @PageIndex = (CEILING(@RowNumber / CAST(@PageSize AS FLOAT))) - 1          
--  END          
-- END            
          
 -- Set start index to fetch record.          
 SET @StartIndex = (@PageIndex * @PageSize) + 1                
           
 -- fetch records from temptable          
 SELECT *                 
 FROM #Tasks                 
 WHERE                 
 (RowNo_Order >= @StartIndex AND                 
 (                
  @PageSize = 0 OR                 
  RowNo_Order < (@StartIndex + @PageSize)                
 ))      
 --ORDER BY  [Sequence]  DESC              
 ORDER BY CASE WHEN (TaskId = @HighLightedTaskID) THEN 0 ELSE 1 END , [Sequence]  DESC              
 --or      
 --(      
 -- TaskId = @HighLightedTaskID      
 --)                
 --ORDER BY CASE WHEN (TaskId = @HighLightedTaskID) THEN 0 ELSE 1 END , [Sequence]  DESC              
                
 -- fetch other statistics, total records, total pages, pageindex to highlighted.               
 SELECT                
 COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex AS PageIndex               
  FROM #Tasks                
          
 DROP TABLE #Tasks          
          
              
END 

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Live publish 07202017

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_UpdateTaskSequence]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_UpdateTaskSequence   

	END  
GO  

-- =============================================    
-- Author:  Yogesh Keraliya    
-- Create date: 05162017    
-- Description: This will update task sequence    
-- =============================================    
CREATE PROCEDURE usp_UpdateTaskSequence     
(     
 @Sequence bigint ,  
 @DesignationID int,     
 @TaskId bigint,  
 @IsTechTask bit 
)    
AS    
BEGIN    


BEGIN TRANSACTION      
  
DECLARE @OriginalSeq BIGINT
DECLARE @OriginalDesignationID INT    

SELECT @OriginalSeq = [Sequence],@OriginalDesignationID =  [SequenceDesignationId] FROM tblTask WHERE TaskId = @TaskId

 UPDATE tblTask    
   SET                [Sequence] = @Sequence , [SequenceDesignationId] = @DesignationID  
 WHERE        (TaskId = @TaskId)   


-- IF SEQ DESIGNATION IS CHANGED THAN UPDATE ORIGINAL SEQUENCE SERIES OF DESIGNATION.
IF ( @OriginalDesignationID IS NOT  NULL AND @OriginalDesignationID <> @DesignationID)
BEGIN

-- if 2 is removed from sequence than all sequence will greater than 2 for that designation will be shifted up by 1. 
 UPDATE       tblTask    
     SET                [Sequence] = [Sequence] - 1       
 WHERE        ([Sequence] >= @OriginalSeq) AND ([SequenceDesignationId] = @OriginalDesignationID) AND IsTechTask = @IsTechTask  


END    
  

  IF (@@Error <> 0)   -- Check if any error
     BEGIN          
        ROLLBACK TRANSACTION       
     END 
   ELSE 
       COMMIT TRANSACTION  

---- if sequence is already assigned to some other task with same designation, all sequence will push back by 1 from alloted sequence for that designation.    
--IF EXISTS(SELECT   T.TaskId  
--FROM            tblTask AS T   
--WHERE        (T.[Sequence] = @Sequence) AND (T.TaskId <> @TaskId) AND (T.[SequenceDesignationId] = @DesignationID) AND T.IsTechTask = @IsTechTask)    
--  BEGIN    
    
--  -- push back all task sequence for 1 from sequence assigned in between.  
--     UPDATE       tblTask    
--     SET                [Sequence] = [Sequence] + 1       
--     WHERE        ([Sequence] >= @Sequence) AND ([SequenceDesignationId] = @DesignationID) AND IsTechTask = @IsTechTask  
    
--  END    
    
  -- Update task sequence and its respective designationid.  
 
  
  
END 

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_isAllExamsGivenByUser]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_isAllExamsGivenByUser   

	END  
GO    
-- =============================================    
-- Author:  Yogesh Keraliya    
-- Create date: 05302017    
-- Description: This will load exam result for user based on his designation    
-- =============================================    
-- usp_isAllExamsGivenByUser 3555    
CREATE PROCEDURE usp_isAllExamsGivenByUser     
(    
 @UserID bigint ,   
 @AggregateScored FLOAT= 0 OUTPUT,  
 @AllExamsGiven BIT = 0 OUTPUT  
)       
AS    
BEGIN    
     
  DECLARE @DesignationID INT    
    
  -- Get users designation based on its user id.    
  SELECT        @DesignationID = DesignationID    
  FROM            tblInstallUsers    
  WHERE        (Id = @UserID)    
    
    
    IF(@DesignationID IS NOT NULL)    
    BEGIN    
    
   DECLARE @ExamCount INT  
   DECLARE @GivenExamCount INT  
  
   -- check exams available for existing designation  
   SELECT      @ExamCount = COUNT(MCQ_Exam.ExamID)  
    FROM          MCQ_Exam   
    WHERE        (@DesignationID IN   
       (SELECT   Item   FROM  dbo.SplitString(MCQ_Exam.DesignationID, ',') AS SplitString_1)) AND  MCQ_Exam.IsActive = 1   
  
    -- check exams given by user  
    SELECT @GivenExamCount = COUNT(ExamID) FROM MCQ_Performance WHERE UserID = @UserID  
  
    -- IF all exam given, calcualte result.     
    IF( @ExamCount = @GivenExamCount AND @GivenExamCount > 0)  
    BEGIN  
  
     SELECT @AggregateScored = (SUM([Aggregate])/@GivenExamCount) FROM MCQ_Performance  WHERE UserID = @UserID  
  
     SET @AllExamsGiven = 1  
  
    END  
    ELSE  
    BEGIN  
     SET @AllExamsGiven = 0  
    END  
  
  
 END    
    
  RETURN @AggregateScored  
    
END    

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[UpdateTaskTechTaskById]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [UpdateTaskTechTaskById]   

	END  
GO    

-- =============================================    
-- Author:  Yogesh    
-- Create date: 19 Apr 17    
-- Description: Updates tech task flag of a Task by Id.    
-- =============================================    
CREATE PROCEDURE [dbo].[UpdateTaskTechTaskById]    
 @TaskId  BIGINT,    
 @IsTechTask BIT    
AS    
BEGIN    

BEGIN TRANSACTION
   
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;      
   
 DECLARE @TaskDesignationId  INT =  (SELECT TOP 1 DesignationID FROM tblTaskDesignations WHERE TaskId = @TaskId)  
  
 DECLARE @MaxSeq INT = (SELECT ISNULL(MAX([Sequence]),0) FROM dbo.tblTask WHERE SequenceDesignationId = @TaskDesignationId AND IsTechTask = @IsTechTask)  

 -- Take original sequence and correct entire series for that designation.
 DECLARE @OriginalSeq BIGINT 

 SELECT @OriginalSeq = [Sequence] FROM tblTask WHERE TaskId = @TaskId


 -- Update task sequence with maximum seq in resepective section. 
 UPDATE tblTask    
 SET    
  IsTechTask = @IsTechTask,  
  [Sequence] = @MaxSeq + 1,  
  [SequenceDesignationId] = @TaskDesignationId  
 WHERE TaskId = @TaskId    


 -- Correct series for inbetween gap in sequencing.

-- if 2 is removed from sequence than all sequence will greater than 2 for that designation will be shifted up by 1. 
 UPDATE       tblTask    
     SET                [Sequence] = [Sequence] - 1       
 WHERE        ([Sequence] >= @OriginalSeq) AND ([SequenceDesignationId] = @TaskDesignationId) AND IsTechTask = @IsTechTask  

   
  IF (@@Error <> 0)   -- Check if any error
     BEGIN          
        ROLLBACK TRANSACTION       
     END 
   ELSE 
       COMMIT TRANSACTION 
  
END    

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_DeleteTaskSequenceByTaskId]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [usp_DeleteTaskSequenceByTaskId]   

	END  
GO    

-- =============================================    
-- Author:  Yogesh    
-- Create date: 31 July 17    
-- Description: Delete Task Sequence Task by Id.    
-- =============================================    
CREATE PROCEDURE [dbo].[usp_DeleteTaskSequenceByTaskId]    
 @TaskId  BIGINT         
AS    
BEGIN    
  
BEGIN TRANSACTION      
  
DECLARE @OriginalSeq BIGINT
DECLARE @OriginalDesignationID INT    
DECLARE @IsTechTask BIT

-- Get Sequence, SequenceDesignation, IsTechTask flag from tak 
SELECT @OriginalSeq = [Sequence], @OriginalDesignationID = [SequenceDesignationId], @IsTechTask = IsTechTask FROM tblTask WHERE TaskId = @TaskId

UPDATE tblTask    
   SET                [Sequence] = NULL , [SequenceDesignationId] = NULL
WHERE        (TaskId = @TaskId)   


-- IF SEQ DESIGNATION IS CHANGED THAN UPDATE ORIGINAL SEQUENCE SERIES OF DESIGNATION.

-- if 2 is removed from sequence than all sequence will greater than 2 for that designation will be shifted up by 1. 
 UPDATE       tblTask    
     SET                [Sequence] = [Sequence] - 1       
 WHERE        ([Sequence] >= @OriginalSeq) AND ([SequenceDesignationId] = @OriginalDesignationID) AND IsTechTask = @IsTechTask  
 

  IF (@@Error <> 0)   -- Check if any error
     BEGIN          
        ROLLBACK TRANSACTION       
     END 
   ELSE 
       COMMIT TRANSACTION    
END       

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Live publish 07312017

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
