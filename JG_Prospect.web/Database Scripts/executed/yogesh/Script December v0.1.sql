USE JGBS_Dev_New
GO

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[usp_QuickSaveInstallUser]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
    BEGIN
 
    DROP PROCEDURE usp_QuickSaveInstallUser

    END  
GO    

  
-- =============================================    
-- Author:  Yogesh    
-- Create date: 09 Sep 2017    
-- Description: Checks if a customer is registered for first time or not.
-- =============================================    
CREATE PROCEDURE [dbo].[usp_QuickSaveInstallUser]   
(

@FirstName VARCHAR(50),
@LastName VARCHAR(50),
@Email VARCHAR(250),
@Phone VARCHAR(25),
@Zip VARCHAR(10),
@DesignationText VARCHAR(50),
@Status VARCHAR(20),
@SourceText VARCHAR(250),
@EmpType VARCHAR(50),
@StartDate VARCHAR(50),
@SalaryReq VARCHAR(50),
@SourceUserId VARCHAR(10), 
@PositionAppliedForDesignationId VARCHAR(50),
@SourceID INT,
@AddedByUserId INT, 
@IsEmailContactPreference BIT,
@IsCallContactPreference BIT,
@IsTextContactPreference BIT,
@IsMailContactPreference BIT,
@Id INT = OUTPUT

)
AS  
BEGIN  
 
 INSERT INTO tblInstallUsers
                         (FristName, LastName, Email, Phone, Zip, Designation, Status, Source, EmpType, StartDate, SalaryReq, UserType, SourceUser, DateSourced, CreatedDateTime, PositionAppliedFor, SourceID, AddedByUserID, IsFirstTime, 
                         IsEmailContactPreference, IsCallContactPreference, IsTextContactPreference, IsMailContactPreference)
 VALUES        (@FirstName,@LastName,@Email,@Phone,@Zip,@DesignationText,@Status,@SourceText,@EmpType,@StartDate,@SalaryReq,'SalesUser',@SourceUserId, GETDATE(), 
                         GETDATE(),@PositionAppliedForDesignationId,@SourceID,@AddedByUserId, 1,@IsEmailContactPreference,@IsCallContactPreference,@IsTextContactPreference,@IsMailContactPreference)
  
SELECT @Id = SCOPE_IDENTITY()

RETURN @Id
 
END  


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =============================================      
-- Author:  Yogesh      
-- Create date: 21 Feb 2017      
-- Description: Bulk upload install users.      
-- =============================================     
--  [dbo].[UDP_BulkInstallUserDuplicateCheck]      
CREATE procedure [dbo].[UDP_BulkInstallUserDuplicateCheck]      
 @XMLDOC2 xml      
AS      
BEGIN      
    
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
  Address varchar(100),      
  Zip varchar (10),      
  State varchar (30),      
  City varchar (30),      
  SuiteAptRoom varchar(10),      
  Notes VARCHAR(50),      
  PrimeryTradeId int,      
  SecondoryTradeId VARCHAR(50),      
  UserType VARCHAR(50),      
  SourceUser VARCHAR(50),      
  ActionTaken VARCHAR(2),    
  RowNum BIGINT    
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
   ,RowNum    
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
  ,[Table].[Column].value('(Row_Num/text()) [1]','BIGINT')    
    FROM      
  @XMLDOC2.nodes('/ArrayOfUser1/user1')AS [Table]([Column])       
    
    
SELECT DISTINCT s.*,TD.DesignationName AS Designation    
FROM #table_xml AS s  LEFT JOIN tbl_Designation AS TD ON s.DesignationId = TD.ID  
WHERE EXISTS (    
SELECT *    
FROM tblInstallUsers As t    
WHERE t.Phone = s.phone OR t.Email = s.Email    
)      
    
      
RETURN;      
END 


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[usp_GetInstallUserDetailsById]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
    BEGIN
 
    DROP PROCEDURE usp_GetInstallUserDetailsById

    END  
GO    
  
     
  
-- =============================================                
-- Author:  Yogesh                
-- Create date: 21 Dec 2017              
-- Updated By : Yogesh Keraliya          
-- Description: Get an install user by id.              
-- =============================================              
-- [dbo].[usp_GetInstallUserDetailsById]    
CREATE PROCEDURE [dbo].[usp_GetInstallUserDetailsById]              
 @UserId INT    
AS              
BEGIN              
                 
  SELECT [Id],[FristName],[NameMiddleInitial],[LastName],[Email],[Phone], [Address],[Zip],[State],[City],[CountryCode],[Password],[Designation],[Status],[Picture],[Source],[EmpType],[InstallId],[DrugTest],    
  [CrimeStatus],[SalaryReq],[StartDate],[ResumePath],[PrevApply],[CruntEmployement],[LeavingReason],[Notes],[FELONY],[DesignationID],[PositionAppliedFor],[SourceID],[IsEmailContactPreference],[IsCallContactPreference],    
  [IsTextContactPreference],[IsMailContactPreference]    
  FROM tblInstallUsers AS tbi WHERE Id = @UserId    
             
END
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[usp_UpdateInstallUserDetailsById]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
    BEGIN
 
    DROP PROCEDURE usp_UpdateInstallUserDetailsById

    END  
GO    
  
-- =============================================              
-- Author:  Yogesh              
-- Create date: 26 Dec 2017            
-- Updated By : Yogesh Keraliya        
-- Description: Update install user by id.            
-- =============================================            
-- [dbo].[usp_UpdateInstallUserDetailsById]  
CREATE PROCEDURE [dbo].[usp_UpdateInstallUserDetailsById]            
 @UserId INT,
 @PositionAppliedFor VARCHAR(50), 
 @SourceID INT,
 @Source VARCHAR(250),
 @FristName VARCHAR(50),
 @LastName VARCHAR(50), 
 @NameMiddleInitial VARCHAR(5),
 @CountryCode VARCHAR(15),
 @Zip VARCHAR(10),  
 @City VARCHAR(30),
 @State VARCHAR(30), 
 @Address VARCHAR(100), 
 @LeavingReason VARCHAR(max), 
 @Phone VARCHAR(25),
 @Email VARCHAR(250), 
 @IsEmailContactPreference BIT, 
 @IsCallContactPreference BIT, 
 @IsTextContactPreference BIT,
 @IsMailContactPreference BIT, 
 @Start_Date VARCHAR(50), 
 @EmpType VARCHAR(50), 
 @SalaryReq VARCHAR(50),
 @CruntEmployement BIT,
 @DrugTest BIT, 
 @FELONY BIT, 
 @PrevApply BIT,
 @Notes VARCHAR(200),
 @Picture VARCHAR(250),
 @ResumePath VARCHAR(250) 
AS            
BEGIN            
               
 UPDATE       tblInstallUsers
SET                PositionAppliedFor = @PositionAppliedFor, SourceID = @SourceID, Source = @Source, FristName = @FristName, LastName = @LastName, NameMiddleInitial = @NameMiddleInitial, CountryCode = @CountryCode, Zip = @Zip, 
                         City = @City, [State] = @State, [Address] = @Address, LeavingReason = @LeavingReason, Phone = @Phone, Email = @Email, IsEmailContactPreference = @IsEmailContactPreference, 
                         IsCallContactPreference = @IsCallContactPreference, IsTextContactPreference = @IsTextContactPreference, IsMailContactPreference = @IsMailContactPreference, [StartDate] = @Start_Date, EmpType = @EmpType, 
                         SalaryReq = @SalaryReq, CruntEmployement = @CruntEmployement, DrugTest = @DrugTest, FELONY = @FELONY, PrevApply = @PrevApply, Notes = @Notes, Picture = @Picture, ResumePath = @ResumePath
WHERE        (Id = @UserId)  
           
END

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Publish Live Dec 27 2017
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[UDP_GetInstallerUserDetailsByLoginId]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
    BEGIN
 
    DROP PROCEDURE UDP_GetInstallerUserDetailsByLoginId

    END  
GO   

-- =============================================            
-- Author:  Yogesh            
-- Create date: 23 Feb 2017          
-- Updated By : Yogesh      
-- Updated By : Jitendra Pancholi  
-- Updated On : 13 Nov 2017      
--     Added applicant status to allow applicant to login.          
-- Updated By : Nand Chavan (Task ID#: REC001-XIII)        
--                  Replace Source with SourceID        
-- Description: Get an install user by email and status.          
-- =============================================          
-- [dbo].[UDP_GetInstallerUserDetailsByLoginId]  'Surmca17@gmail.com'     
CREATE PROCEDURE [dbo].[UDP_GetInstallerUserDetailsByLoginId]          
 @loginId varchar(50) ,          
 @ActiveStatus varchar(5) = '1',          
 @ApplicantStatus varchar(5) = '2',          
 @InterviewDateStatus varchar(5) = '5',          
 @OfferMadeStatus varchar(5) = '6'          
AS          
BEGIN          
        
 DECLARE @phone varchar(1000) = @loginId        
        
 --REC001-XIII - create formatted phone#        
 IF ISNUMERIC(@loginId) = 1 AND LEN(@loginId) > 5        
 BEGIN        
  SET @phone =  '(' + SUBSTRING(@phone, 1, 3) + ')-' + SUBSTRING(@phone, 4, 3) + '-' + SUBSTRING(@phone, 7, LEN(@phone))        
 END        
            
  SELECT Id,FristName,Lastname,Email,[Address],Designation,[Status],          
   [Password],[Address],Phone,Picture,Attachements,usertype, Picture,IsFirstTime,DesignationID,      
   CASE WHEN  [Status] = '5' THEN [dbo].[udf_IsUserAssigned](tbi.Id) ELSE 0 END AS AssignedSequence,  
   UserInstallId, LastProfileUpdated  
  FROM tblInstallUsers  AS tbi     
  WHERE           
   (Email = @loginId OR Phone = @loginId  OR Phone = @phone)         
   AND ISNULL(@loginId, '') != ''   AND        
   (          
    [Status] = @ActiveStatus OR           
    [Status] = @ApplicantStatus OR          
    [Status] = @OfferMadeStatus OR           
    [Status] = @InterviewDateStatus  OR  
 [Status] = 16  -- InterviewDateExpired,  Added by Jitendra Pancholi   
   )          
        
END


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[usp_UpdateInstallUserDetailsById]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
    BEGIN
 
    DROP PROCEDURE usp_UpdateInstallUserDetailsById

    END  
GO    
  
-- =============================================              
-- Author:  Yogesh              
-- Create date: 26 Dec 2017            
-- Updated By : Yogesh Keraliya        
-- Description: Update install user by id.            
-- =============================================            
-- [dbo].[usp_UpdateInstallUserDetailsById]  
CREATE PROCEDURE [dbo].[usp_UpdateInstallUserDetailsById]            
 @UserId INT,
 @PositionAppliedFor VARCHAR(50), 
 @SourceID INT,
 @Source VARCHAR(250),
 @FristName VARCHAR(50),
 @LastName VARCHAR(50), 
 @NameMiddleInitial VARCHAR(5),
 @CountryCode VARCHAR(15),
 @Zip VARCHAR(10),  
 @City VARCHAR(30),
 @State VARCHAR(30), 
 @Address VARCHAR(100), 
 @LeavingReason VARCHAR(max), 
 @Phone VARCHAR(25),
 @Email VARCHAR(250), 
 @IsEmailContactPreference BIT, 
 @IsCallContactPreference BIT, 
 @IsTextContactPreference BIT,
 @IsMailContactPreference BIT, 
 @Start_Date VARCHAR(50), 
 @EmpType VARCHAR(50), 
 @SalaryReq VARCHAR(50),
 @CruntEmployement BIT,
 @DrugTest BIT, 
 @FELONY BIT, 
 @PrevApply BIT,
 @Notes VARCHAR(200),
 @Picture VARCHAR(250),
 @ResumePath VARCHAR(250) 
AS            
BEGIN            
               
 UPDATE       tblInstallUsers
SET                PositionAppliedFor = @PositionAppliedFor, SourceID = @SourceID, Source = @Source, FristName = @FristName, LastName = @LastName, NameMiddleInitial = @NameMiddleInitial, CountryCode = @CountryCode, Zip = @Zip, 
                         City = @City, [State] = @State, [Address] = @Address, LeavingReason = @LeavingReason, Phone = @Phone, Email = @Email, IsEmailContactPreference = @IsEmailContactPreference, 
                         IsCallContactPreference = @IsCallContactPreference, IsTextContactPreference = @IsTextContactPreference, IsMailContactPreference = @IsMailContactPreference, [StartDate] = @Start_Date, EmpType = @EmpType, 
                         SalaryReq = @SalaryReq, CruntEmployement = @CruntEmployement, DrugTest = @DrugTest, FELONY = @FELONY, PrevApply = @PrevApply, Notes = @Notes, Picture = @Picture, ResumePath = @ResumePath, LastProfileUpdated = GETDATE()
WHERE        (Id = @UserId)  
           
END
