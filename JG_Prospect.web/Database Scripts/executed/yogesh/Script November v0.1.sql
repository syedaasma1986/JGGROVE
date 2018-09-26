-- November 2017 --


/*
   Saturday, November 4, 20174:54:46 PM
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
CREATE TABLE dbo.EmpInstructions
	(
	EmpInstructionId int NOT NULL,
	DesignationId int NULL,
	UsedFor smallint NOT NULL,
	LegalText varchar(MAX) NULL,
	CreatedDateTime datetime NULL,
	UpdatedDateTime datetime NULL,
	CreatedBy int NULL,
	UpdatedBy int NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.EmpInstructions ADD CONSTRAINT
	PK_EmpInstructions PRIMARY KEY CLUSTERED 
	(
	EmpInstructionId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.EmpInstructions SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.EmpInstructions', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.EmpInstructions', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.EmpInstructions', 'Object', 'CONTROL') as Contr_Per 

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
   Friday, November 3, 20177:23:37 PM
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
CREATE TABLE dbo.EmpLegalDesclaimer
	(
	LegalDesclaimerId int NOT NULL,
	DesignationId int NULL,
	UsedFor smallint NOT NULL,
	LegalText varchar(MAX) NULL,
	CreatedDateTime datetime NULL,
	UpdatedDateTime datetime NULL,
	CreatedBy int NULL,
	UpdatedBy int NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.EmpLegalDesclaimer ADD CONSTRAINT
	PK_EmpLegalDesclaimer PRIMARY KEY CLUSTERED 
	(
	LegalDesclaimerId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.EmpLegalDesclaimer SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.EmpLegalDesclaimer', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.EmpLegalDesclaimer', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.EmpLegalDesclaimer', 'Object', 'CONTROL') as Contr_Per 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[usp_GetEmpLegalDesclaimerByDesignationId]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
    BEGIN
 
    DROP PROCEDURE usp_GetEmpLegalDesclaimerByDesignationId   

    END  
GO    

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 11/04/2017
-- Description:	This will fetch legal declaimer on success popup of users apptitude test.
-- =============================================
CREATE PROCEDURE usp_GetEmpLegalDesclaimerByDesignationId 
(	
	@DesignationId INT, 
	@UsedFor SMALLINT
)
AS
BEGIN
	
	SELECT        LegalText
	FROM            EmpLegalDesclaimer
	WHERE        (DesignationId = @DesignationId) AND (UsedFor = @UsedFor)

	
END
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[usp_GetEmpInstructionByDesignationId]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
    BEGIN
 
    DROP PROCEDURE usp_GetEmpInstructionByDesignationId   

    END  
GO    

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 11/06/2017
-- Description:	This will fetch instruction to employee.
-- =============================================
CREATE PROCEDURE usp_GetEmpInstructionByDesignationId 
(	
	@DesignationId INT, 
	@UsedFor SMALLINT
)
AS
BEGIN
	
	SELECT        InstructionText
	FROM          [dbo].[EmpInstructions]
	WHERE        (DesignationId = @DesignationId) AND (UsedFor = @UsedFor)

	
END
GO

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[usp_GetEmployeeInterviewDetails]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
    BEGIN
 
    DROP PROCEDURE usp_GetEmployeeInterviewDetails   

    END  
GO    

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yogesh Keraliya
-- Create date: 11/06/2017
-- Description:	This will fetch employee interview details.
-- =============================================
CREATE PROCEDURE usp_GetEmployeeInterviewDetails 
(	
	@UserId INT
)
AS
BEGIN

	SELECT FristName,LastName,Designation,CONVERT(VARCHAR(10), [RejectionDate],110)AS [RejectionDate],[RejectionTime],DesignationId,UserInstallId FROM tblInstallUsers WHERE Id = @UserId

END
GO


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[usp_CheckNewCustomerFromOtherSite]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
    BEGIN
 
    DROP PROCEDURE usp_CheckNewCustomerFromOtherSite

    END  
GO    

  
-- =============================================    
-- Author:  Yogesh    
-- Create date: 09 Sep 2017    
-- Description: Checks if a customer is registered for first time or not.
-- =============================================    
CREATE PROCEDURE [dbo].[usp_CheckNewCustomerFromOtherSite]   
 (
 @Email VARCHAR(250)
 )
AS  
BEGIN  
 
 SELECT ISNULL(IsFirstTime, 0) AS NewCustomer FROM new_customer WHERE Email = @Email
  
 
END  