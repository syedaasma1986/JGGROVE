
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author: ALI SHAHABAS  
-- Create date: 26-JUNE-2016  
-- Updated By: Pratixa
-- Updated date: 21-03-2017  
-- Description: To get list of users in order to the status    
-- =============================================    

ALTER PROCEDURE [dbo].[SP_GetInstallUsers]    

	@Key int,  
	@Designations varchar(4000),
	@ActiveStatus varchar(5) = '1',
	@InterviewDateStatus varchar(5) = '5',
	@OfferMadeStatus varchar(5) = '6'
	AS 
BEGIN    

	IF @Key = 1  
	BEGIN
		SELECT
			DISTINCT(Designation) AS Designation 
			FROM tblinstallUsers 
			WHERE Designation IS NOT NULL     
			ORDER BY Designation
	END
	ELSE IF @Key = 2
	BEGIN
			SELECT 
			DISTINCT FristName + ' ' + LastName + '  ' + UserInstallId  AS FristName, tblinstallUsers.Id , [Status]
			FROM tblinstallUsers 
			WHERE  
			(FristName IS NOT NULL AND FristName <> '' )  AND 
			(tblinstallUsers.[Status] = @ActiveStatus OR 
			tblinstallUsers.[Status] = @OfferMadeStatus OR 
			tblinstallUsers.[Status] = @InterviewDateStatus
			) AND 
			(Designation IN (SELECT Item FROM dbo.SplitString(@Designations,','))
			OR
			Convert(Nvarchar(max),DesignationID)  IN (SELECT Item FROM dbo.SplitString(@Designations,','))
			)
			ORDER BY Status, FristName
	END	
END