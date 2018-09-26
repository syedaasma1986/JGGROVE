IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetUsersByKeyword' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE GetUsersByKeyword
  END
Go
 -- =============================================      
-- Author:  Jitendra Pancholi      
-- Create date: 27 Nov 2017   
-- Description: Get a list of top 5 users by starts with name, email 
-- =============================================    
/*
	GetUsersByKeyword 'jite'
*/
CREATE PROCEDURE [dbo].[GetUsersByKeyword]   
  @Keyword varchar(50)
AS    
BEGIN
	Select * From tblInstallUsers U With(NoLock)
		Where (FristName like @Keyword + '%' OR LastName like @Keyword + '%' OR Email like @Keyword + '%' )
END    
GO


