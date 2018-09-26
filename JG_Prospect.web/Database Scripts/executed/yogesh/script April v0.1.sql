	/*
	   Friday, April 27, 20187:02:11 PM
	   User: sa
	   Server: 35.197.90.163
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
	ALTER TABLE dbo.tblTask ADD
		IsReassignable bit NULL
	GO
	ALTER TABLE dbo.tblTask ADD CONSTRAINT
		DF_tblTask_IsReassignable DEFAULT (0) FOR IsReassignable
	GO
	ALTER TABLE dbo.tblTask SET (LOCK_ESCALATION = TABLE)
	GO
	COMMIT
	select Has_Perms_By_Name(N'dbo.tblTask', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblTask', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblTask', 'Object', 'CONTROL') as Contr_Per 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE JGBS_Dev_New
GO

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[usp_UpdateTaskReassignableStatus]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
    BEGIN
 
    DROP PROCEDURE usp_UpdateTaskReassignableStatus

    END  
GO    

  SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 04272018
-- Description:	Update Task reassignable status
-- =============================================
CREATE PROCEDURE usp_UpdateTaskReassignableStatus 
(
	@TaskId BIGINT , 
	@IsReassignable bit 
)
AS
BEGIN

UPDATE tblTask SET IsReassignable = @IsReassignable WHERE TaskId = @TaskId

END
GO

--------------------------------------------------------------------------------------------------------------------------------------

USE JGBS_Dev_New
GO
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[usp_GetUserAssignedDesigSequencnce]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
    BEGIN
 
    DROP PROCEDURE usp_GetUserAssignedDesigSequencnce

    END  
GO    

Create PROCEDURE [dbo].[usp_GetUserAssignedDesigSequencnce]         
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
      
  -- Reassignable tech task change implemented: check if reroccuring task is available for designation then it will be assigned first.
  IF EXISTS(SELECT TaskId FROM tblTask WHERE [SequenceDesignationId] = @DesignationID  AND IsReassignable = 1 )  
  BEGIN  
  
	   INSERT INTO tblAssignedSequencing        
		 (AssignedDesigSeq, UserId, IsTechTask, TaskId, CreatedDateTime, DesignationId,IsTemp)        
	   SELECT  TOP 1 ISNULL([Sequence],1), @UserID, @IsTechTask , TaskId, GETDATE() , @DesignationId, 1 FROM tblTask         
	   WHERE [SequenceDesignationId] = @DesignationID   
	   AND IsTechTask = @IsTechTask AND [Sequence] IS NOT NULL      
	   AND IsReassignable = 1
  
  END  
  ELSE  
   BEGIN  
  
    INSERT INTO tblAssignedSequencing        
           (AssignedDesigSeq, UserId, IsTechTask, TaskId, CreatedDateTime, DesignationId,IsTemp)        
    SELECT  TOP 1 ISNULL([Sequence],1), @UserID, @IsTechTask , TaskId, GETDATE() , @DesignationId, 1 FROM tblTask         
    WHERE (AdminUserId IS NOT NULL AND TechLeadUserId IS NOT NULL ) AND [SequenceDesignationId] = @DesignationID   
    AND IsTechTask = @IsTechTask AND [Sequence] IS NOT NULL AND [Sequence] > (           
        
      SELECT       ISNULL(MAX(AssignedDesigSeq),0) AS LastAssignedSequence        
       FROM            tblAssignedSequencing        
      WHERE        (DesignationId = @DesignationId) AND (IsTechTask = @IsTechTask)        
    And IsTemp = 1 -- Added by Jitendra  
    )  and TaskId not in -- Added by Jitendra  
 (Select Distinct S.TaskId From tbl_AnnualEvents E With(NoLock) -- Added by Jitendra  
 Join tblAssignedSequencing S on E.ApplicantId = S.UserId -- Added by Jitendra  
 Where E.EventDate >= CAST(GetDate() as date) -- Added by Jitendra  
   And E.EventName = 'InterViewDetails' And E.IsInstallUser = 1)  -- Added by Jitendra      
    ORDER BY [Sequence] ASC         
  
   END  
END     
  
-- Get newly assigned sequence from inserted sequence / Already assigned sequence        
SELECT  Id,[AssignedDesigSeq] AS [AvailableSequence],TBA.TaskId, dbo.udf_GetParentTaskId(TBA.TaskId) AS ParentTaskId,         
(SELECT Title FROM tblTask WHERE TaskId =  dbo.udf_GetParentTaskId(TBA.TaskId)) AS ParentTitle , dbo.udf_GetCombineInstallId(TBA.TaskId) AS InstallId , T.Title         
        
FROM tblTask AS T         
        
INNER JOIN tblAssignedSequencing AS TBA ON TBA.TaskId = T.TaskId        
         
WHERE TBA.UserId = @UserId AND TBA.IsTemp = 1          
  
End