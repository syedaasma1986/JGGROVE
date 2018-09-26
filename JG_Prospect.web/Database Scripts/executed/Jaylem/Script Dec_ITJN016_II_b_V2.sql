USE [JGBS_Dev]

GO
-- =============================================    
-- Author: ALI SHAHABAS  
-- Create date: 26-JUNE-2016  
-- Updated By: Jaylem
-- Updated date: 13-Dec-2016  
-- Description: SP_GetInstallUsers    
-- =============================================    
ALTER PROCEDURE [dbo].[SP_GetInstallUsers]    
	@Key int,  
	@Designations varchar(4000)  
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
			DISTINCT FristName + ' ' + LastName AS FristName, Id , [Status] 
		FROM tblinstallUsers 
		WHERE  
			(FristName IS NOT NULL OR FristName <> '' )  AND 
			(
				tblinstallUsers.[Status] = 'OfferMade' OR 
				tblinstallUsers.[Status] = 'Offer Made' OR 
				tblinstallUsers.[Status] = 'Active' OR 
				tblinstallUsers.[Status] = 'Interview Date' OR 
				tblinstallUsers.[Status] = 'InterviewDate'
			) AND 
			(
				Designation IN (SELECT Item FROM dbo.SplitString(@Designations,','))
				OR
				Convert(Nvarchar(max),DesignationID)  IN (SELECT Item FROM dbo.SplitString(@Designations,','))
			)
		ORDER BY FristName + ' ' + LastName
	END
END

GO

ALTER PROCEDURE [dbo].[sp_FilterHrData]
	@status nvarchar(250)='',
	@designation nvarchar(500)='',
	@fromdate date,
	@todate date
AS
BEGIN
	
	SELECT t.Id,t.FristName, t.LastName,t.Designation,t.Status ,t.Source, ISNULL(U.Username,'')  AS AddedBy, t.CreatedDateTime 
	FROM tblInstallUsers t 
		LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser
		LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id
	WHERE t.Status=@status 
		AND 
			(
				t.Designation=(Case When @designation = 'ALL' Then t.Designation Else @designation End)
				OR
				Convert(Nvarchar(max),t.DesignationID)=(Case When @designation IN ('All','0') Then t.DesignationID Else @designation End)
			)
		AND CAST(t.CreatedDateTime as date) >= CAST( @fromdate  as date) 
		AND CAST (t.CreatedDateTime  as date) <= CAST( @todate  as date)
	
END

GO

ALTER PROCEDURE [dbo].[UDP_changepassword]
	--@usertype varchar(20),
	@loginid varchar(50),
	@password varchar(50),
	@IsCustomer bit,
	@result int output
AS BEGIN

	If @IsCustomer = 0
	BEGIN
		IF EXISTS (SELECT Id FROM tblInstallUsers WHERE Id=@loginid)
		BEGIN
			UPDATE tblInstallUsers Set [Password]=@password,IsFirstTime=0 WHERE Id = @loginid
			Set @result ='1'
		END
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT Id FROM new_customer WHERE Id=@loginid)
		BEGIN
			UPDATE new_customer Set [Password]=@password,IsFirstTime=0 WHERE Id=@loginid
			Set @result ='1'
		END
	END
     
    return @result

 END
 