

IF OBJECT_ID(N'[DBO].[UDF_GetStatusText]') IS NOT NULL
BEGIN
	DROP FUNCTION [DBO].[UDF_GetStatusText]
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  UserDefinedFunction [dbo].[UDF_GetStatusText]    Script Date: 4/27/2017 1:36:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Nand Chavan
-- Create date: Apr 27/2017
-- Description:	Get Status text for given value
-- =============================================
CREATE FUNCTION [dbo].[UDF_GetStatusText] 
(
	-- Add the parameters for the function here
	@StatusVal VARCHAR(20)
)
RETURNS VARCHAR(20)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @StatusText VARCHAR(20) = ''
	SET @StatusVal = RTRIM(LTRIM(@StatusVal))

	-- Add the T-SQL statements to compute the return value here
	SELECT 
		@StatusText = 
			CASE @StatusVal
				WHEN '1' THEN 'Active'
				WHEN '2' THEN 'Applicant'
				WHEN '3' THEN 'Deactive'
				WHEN '4' THEN 'Install Prospect'
				WHEN '5' THEN 'Interview Date'
				WHEN '6' THEN 'Offer Made'
				WHEN '7' THEN 'Phone Screened'
				WHEN '8' THEN 'Phone/Video Screened'
				WHEN '9' THEN 'Rejected'
				WHEN '10' THEN 'Referral Applicant'
				WHEN '11' THEN 'Deleted'
				ELSE ''
			END

	-- Return the result of the function
	RETURN @StatusText

END
GO

-- =============================================
-- Author:		
-- Create date: 
-- Updated By : Nand Chavan 
--                  Get application status text
-- Description:	Get application status text
-- =============================================
ALTER PROCEDURE [dbo].[sp_FilterHrData]
	@status nvarchar(250)='',
	@designation nvarchar(500)='',
	@fromdate date = NULL,
	@todate date
AS
BEGIN
	
	SELECT 
		t.Id,t.FristName, 
		t.LastName,
		t.Designation,
		--t.Status,
		Status = DBO.UDF_GetStatusText(t.Status),
		t.Source, 
		ISNULL(U.Username,'')  AS AddedBy, 
		t.CreatedDateTime 
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
		AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@fromdate, t.CreatedDateTime)  as date) 
		AND CAST (t.CreatedDateTime  as date) <= CAST( @todate  as date)
	
END

GO



