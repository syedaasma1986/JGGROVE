
/****** Object:  StoredProcedure [dbo].[USP_GetEmailTemplate]    Script Date: 30-01-2017 10:40:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		-
-- Create date: -
-- Description:	-
-- Updated By : Jaylem
-- Updated Date : 30-Jan-2017
-- =============================================
GO
ALTER PROCEDURE [dbo].[USP_GetEmailTemplate]  
(
	@TemplateName VARCHAR(500),
	@HTMLTemplateID INT = NULL
)
AS  
BEGIN  
	SET NOCOUNT ON;
	SELECT 
		HTMLHeader,
		HTMLBody,
		HTMLFooter,
		HTMLSubject 
	FROM tblSubHtmlTemplates  
	WHERE SubHTMLName = @TemplateName AND HTMLTemplateID = (CASE WHEN @HTMLTemplateID IS NULL OR @HTMLTemplateID=0 THEN HTMLTemplateID ELSE @HTMLTemplateID END)

	SELECT * 
	FROM tblCustomerAttachment 
	WHERE HTMLTemplateID IN (SELECT ID FROM tblSubHtmlTemplates WHERE SubHTMLName = @TemplateName)

END
