SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF OBJECT_ID(N'[DBO].[JG_PARAMETERS]') IS NOT NULL
 DROP TABLE [dbo].[JG_PARAMETERS]
GO

CREATE TABLE [dbo].[JG_PARAMETERS](
 [ID] [int] IDENTITY(1,1) NOT NULL,
 [ParaName] [varchar](50) NOT NULL,
 [ParaValue] [varchar](500) NOT NULL,
 [ParaDescription] [varchar](1000) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

CREATE UNIQUE NONCLUSTERED INDEX [ixParameterName] ON [dbo].[JG_PARAMETERS]
(
 [ParaName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = OFF, ALLOW_PAGE_LOCKS = OFF)
GO

IF (DB_NAME() =  'JGBS_Interview')
BEGIN
 INSERT INTO DBO.JG_PARAMETERS (ParaName, ParaValue, ParaDescription) 
 VALUES ('UserIdUrl', 'http://interview.jmgrovebuildingsupply.com/Sr_App/ViewSalesUser.aspx?id=',
         'This parameter is used in proc usp_GeAddedBytUsersFilter. The proc is used to populate AddedBy drop-down field.')

END
ELSE IF (DB_NAME() =  'JGBS_Dev_New' OR DB_NAME() =  'JGBS_Test') -- DEV
BEGIN
 INSERT INTO JG_PARAMETERS (ParaName, ParaValue, ParaDescription) 
 VALUES ('UserIdUrl', 'http://test.jmgrovebuildingsupply.com/Sr_App/ViewSalesUser.aspx?id=',
         'This parameter is used in proc usp_GeAddedBytUsersFilter. The proc is used to populate AddedBy drop-down field.')

 --UPDATE DBO.JG_PARAMETERS SET ParameterValue = 'http://localhost:61394/Sr_App/ViewSalesUser.aspx?id='
 --WHERE ParameterName = 'UserIdUrl'
END
ELSE IF (DB_NAME() =  'JGBS') -- PRODUCTION
BEGIN
 INSERT INTO JG_PARAMETERS (ParaName, ParaValue, ParaDescription) 
 VALUES ('UserIdUrl', 'http://web.jmgrovebuildingsupply.com/Sr_App/ViewSalesUser.aspx?id=',
         'This parameter is used in proc usp_GeAddedBytUsersFilter. The proc is used to populate AddedBy drop-down field.')

END
ELSE IF NOT EXISTS (SELECT * FROM JG_PARAMETERS WHERE ParaName = 'UserIdUrl')
	PRINT 'UserIdUrl COULD NOT BE INSERTED INTO JG_PARAMETERS TABLE'
GO


-- ==================================================================================
-- Author:		Shekhar Pawar
-- Create date: 16/11/2016
-- Updated By : Nand Chavan (Task ID#: ITJN028-VII - HR edit page)
--                  Include "Offer Made" status
-- Description:	Fetch all sales and install users for who are in edit user in system
--              Note: This proc is called in usp_GeAddedBytUsersFilter. Any changes to signiture
--              should be updated in that proc.
-- ==================================================================================
ALTER PROCEDURE [dbo].[usp_GetUsersNDesignationForSalesFilter] 
AS
BEGIN

SET NOCOUNT ON;

	SELECT * FROM (
		SELECT  
			DISTINCT Users.Id, FristName + ' ' + LastName +'-'+ ISNULL(UserInstallId,'') AS FirstName,[Status], 'Group1' AS GroupNumber
		FROM tblInstallUsers AS Users 
		WHERE 
			Users.FristName IS NOT NULL AND 
			Users.FristName <> '' AND
			(
				[Status] = '1' --Active=1
			)
			AND Designation IN('Admin Recruiter','Recruiter', 'Admin', 'Office Manager', 'Jr. Sales', 'Sales Manager', 'Operations Manager')

		UNION ALL

		SELECT  
			DISTINCT Users.Id, FristName + ' ' + LastName +'-'+ ISNULL(UserInstallId,'') AS FirstName,[Status], 'Group2' AS GroupNumber
		FROM tblInstallUsers AS Users 
		WHERE 
			Users.FristName IS NOT NULL AND 
			Users.FristName <> '' AND
			(
				[Status] = '5' --Interview Date
			)
			AND Designation IN('Admin Recruiter','Recruiter', 'Admin', 'Office Manager', 'Jr. Sales', 'Sales Manager', 'Operations Manager')

		UNION ALL

		SELECT  
			DISTINCT Users.Id, FristName + ' ' + LastName +'-'+ ISNULL(UserInstallId,'') AS FirstName,[Status], 'Group2' AS GroupNumber
		FROM tblInstallUsers AS Users 
		WHERE 
			Users.FristName IS NOT NULL AND 
			Users.FristName <> '' AND
			(
				[Status] = '6' -- 'Offer Made'
			)
			AND Designation IN('Admin Recruiter','Recruiter', 'Admin', 'Office Manager', 'Jr. Sales', 'Sales Manager', 'Operations Manager')

		UNION ALL

		SELECT  
			DISTINCT Users.Id, FristName + ' ' + LastName +'-'+ ISNULL(UserInstallId,'') AS FirstName,[Status], 'Group3' AS GroupNumber
		FROM tblInstallUsers AS Users 
		WHERE 
			Users.FristName IS NOT NULL AND 
			Users.FristName <> '' AND
			(
				[Status] = '3' --Deactive
			)
			AND Designation IN('Admin Recruiter','Recruiter', 'Admin', 'Office Manager', 'Jr. Sales', 'Sales Manager', 'Operations Manager')

		--ORDER BY GroupNumber, [Status], FristName + ' ' + LastName +'-'+ ISNULL(UserInstallId,'')
		) as T

	WHERE T.Id in (
		SELECT     
			distinct
			ISNULL(t1.Id,t2.Id) As AddedById 
		FROM     
			tblInstallUsers t     
			LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser    
			LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser
			LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id    
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id       
			LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id      
			LEFT JOIN tblSource s ON t.SourceId = s.Id    
			OUTER APPLY
			(
				SELECT TOP 1 tsk.TaskId, tsk.ParentTaskId, tsk.InstallId, ROW_NUMBER() OVER(ORDER BY u.TaskUserId DESC) AS RowNo
				FROM tblTaskAssignedUsers u 
						INNER JOIN tblTask tsk ON u.TaskId = tsk.TaskId AND 
							(tsk.ParentTaskId IS NOT NULL OR tsk.IsTechTask = 1) 
				WHERE u.UserId = t.Id
			) AS Task
		WHERE  
			t.Status NOT IN ('6', '1')  
		)
ORDER BY GroupNumber

END

GO


IF OBJECT_ID(N'[DBO].[usp_GeAddedBytUsersFilter]') IS NOT NULL
BEGIN
	DROP PROC [DBO].[usp_GeAddedBytUsersFilter]
END
GO


-- =================================================================================
-- Author:		Nand Chavan
-- Create date: May 01/2017
-- Description:	Task ID#: ITJN028-VII: Get all Users for AddedBy filter, with html tags
--              using usp_GetUsersNDesignationForSalesFilter
-- =================================================================================
CREATE PROCEDURE DBO.usp_GeAddedBytUsersFilter 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET CONCAT_NULL_YIELDS_NULL OFF 

	DECLARE @UserIdUrl VARCHAR(500)
	DECLARE @AddedBy TABLE (
		Id	         INT,
		FullName	 VARCHAR(500),
		Status	     VARCHAR(20),
		GroupNumber	 VARCHAR(6),
		UserID       VARCHAR(200)
		)

    -- Insert statements for procedure here, tblInstallUsers
	INSERT INTO @AddedBy (Id, FullName, Status, GroupNumber)
	EXEC DBO.usp_GetUsersNDesignationForSalesFilter

	-- Get NameMiddleInitial and tblInstallUsers
	UPDATE A
	SET 
		FullName = FristName + ' ' + NameMiddleInitial + ' ' +  LastName,
		UserID = ISNULL(B.UserInstallId,'') 
	FROM 
		@AddedBy A, tblInstallUsers B
	WHERE 
		A.Id = B.Id

	-- format records
	SELECT @UserIdUrl=ParaValue FROM  DBO.JG_PARAMETERS WITH (NOLOCK) WHERE ParaName = 'UserIdUrl'

	-- format records '5' Interview Date, '1' --Active=1, '6' THEN 'Offer Made'
	UPDATE 
		@AddedBy
	SET FullName = 
		CASE GroupNumber
			WHEN 'Group1' THEN --Active=1
					N'<span style=''color:red;''>' + FullName + ' - ' + N'</span> <span class=''ddlstatus-per-text''> <a href=' 
							   + @UserIdUrl + CAST(Id AS VARCHAR(9)) + '>' + UserID + '</a> </span>'
			WHEN 'Group2' THEN  --'5' Interview Date, 'Offer Made'
					 N'<span style=''color:blue;''>' + FullName + ' - ' + N'</span> <span class=''ddlstatus-per-text''> <a href=' 
							   + @UserIdUrl + CAST(Id AS VARCHAR(9)) + '>' + UserID + '</a> </span>'
			ELSE
					N'<span style=''color:grey;''>' + FullName + ' - ' + N'</span> <span class=''ddlstatus-per-text''> <a href=' 
							   + @UserIdUrl + CAST(Id AS VARCHAR(9)) + '>' + UserID + '</a> </span>'
		END 

	-- return recors data
	SELECT 
		Id, 
		FirstName = FullName, 
		Status, 
		GroupNumber 
	FROM 
		@AddedBy

END

GO
