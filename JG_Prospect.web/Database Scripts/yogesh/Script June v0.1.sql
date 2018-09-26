--SP_HELPTEXT 'usp_GetAllTaskWithSequence'

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_GetFilesforDesignation]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_GetAllTaskWithSequence   

	END  
GO    

CREATE Procedure usp_GetFilesforDesignation  
(  
@LocationId int ,
@DesignationId int 
)  
as  
Begin  
 Select f.*,df.*,fo.Name as FolderName,d.DesignationName from DesignationFiles df  
 left join Files f  
  on f.ID = df.FileId  
 left Join Folders fo  
  on fo.ID = f.FolderId  
 left Join tbl_Designation d  
  on d.Id = df.DesignationId  
 Where LocationId = @LocationId  AND df.DesignationId = @DesignationId 
End


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Live

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Create  TRIGGER AfterInsertTblInstallUsers   
   ON  tblInstallUsers  
   AFTER INSERT  
AS   
BEGIN  
 insert into temp values('trigger')  
 Declare @MessageId int, @ChatSourceId Varchar(200), @UserChatGroupId int, @ReceiverIds Varchar(800)  
 Declare @SourceId int, @SenderId int, @msg varchar(500), @Createdon Datetime  
  
 Set @ChatSourceId = NewID()  
  
 SELECT @SenderId = I.Id, @msg = 'User successfully filled in HR form' FROM INSERTED I  
  
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


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

USE JGBS_Dev_New
GO
 
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
CREATE PROCEDURE [dbo].[usp_isAllExamsGivenByUser]         
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
    IF( @GivenExamCount >= @ExamCount)      
  BEGIN      
      
   SELECT @AggregateScored = (SUM([Aggregate])/@GivenExamCount) FROM MCQ_Performance  WHERE UserID = @UserID      
      
   SET @AllExamsGiven = 1      
      
  END      
    ELSE      
  BEGIN      
   SET @AllExamsGiven = 0      
   SET @AggregateScored = 0  
  END      
      
      
 END        
        
RETURN @AggregateScored      
        
  
END        
    