USE JGBS_Dev_New
GO

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[usp_UpdateUserLoginTimeStamp]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
    BEGIN
 
    DROP PROCEDURE usp_UpdateUserLoginTimeStamp

    END  
GO    

  
-- =============================================    
-- Author:  Yogesh    
-- Create date: 27 Jan 2018   
-- Description: Enter User Last Login Time Stamp
-- =============================================    
CREATE PROCEDURE [dbo].[usp_UpdateUserLoginTimeStamp]   
(

	@Id INT,
	@LastLoginTimeStamp DATETIME

)
AS  
BEGIN  
 
 UPDATE tblInstallUsers SET [LastLoginTimeStamp] = @LastLoginTimeStamp WHERE Id = @Id

 
END  
