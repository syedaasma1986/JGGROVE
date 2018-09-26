IF EXISTS(SELECT 1 FROM   INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'UDP_IsValidInstallerUser' AND SPECIFIC_SCHEMA = 'dbo')
  BEGIN
      DROP PROCEDURE UDP_IsValidInstallerUser
  END
Go
 -- =============================================      
-- Author:  Yogesh      
-- Create date: 23 Feb 2017    
-- Updated By : Yogesh    
-- Updated By : Jitendra Pancholi
-- Updated On : 13 Nov 2017
--  Added applicant status to allow applicant to login.    
-- Updated By : Nand Chavan (Task ID#: REC001-XIII)  
--                  Replace Source with SourceID  
-- Description: Get an install user by email, pwd and status.    
-- =============================================    
CREATE PROCEDURE [dbo].[UDP_IsValidInstallerUser]   
  @userid varchar(50),    
  @password varchar(50),    
  @ActiveStatus varchar(5) = '1',    
  @ApplicantStatus varchar(5) = '2',    
  @InterviewDateStatus varchar(5) = '5',    
  @OfferMadeStatus varchar(5) = '6',    
  @result int output    
AS    
BEGIN    
     
 DECLARE @phone varchar(1000) = @userid  
  
 --REC001-XIII - create formatted phone#  
 IF ISNUMERIC(@userid) = 1 AND LEN(@userid) > 5  
 BEGIN  
  SET @phone =  '(' + SUBSTRING(@phone, 1, 3) + ')-' + SUBSTRING(@phone, 4, 3) + '-' + SUBSTRING(@phone, 7, LEN(@phone))  
 END  
  
 IF EXISTS(    
  SELECT Id     
  FROM tblInstallUsers     
  WHERE     
   (Email = @userid OR Phone = @userid OR Phone = @phone)  
   AND ISNULL(@userid, '') != ''  
   AND    
   [Password] = @password AND     
     (    
    [Status] = @ActiveStatus OR     
    [Status] = @ApplicantStatus OR     
    [Status] = @InterviewDateStatus OR     
    [Status] = @OfferMadeStatus   OR
	[Status] = 16  -- InterviewDateExpired,  Added by Jitendra Pancholi 
     )    
    )    
  BEGIN    
   SET @result = 1    
  END    
  ELSE    
  BEGIN    
   SET @result=0    
  END    
    
  RETURN @result    
    
END    
GO


