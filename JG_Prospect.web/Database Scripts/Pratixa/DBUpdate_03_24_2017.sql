----------------------------------------------------------------
-- =============================================
-- Author:		Pratixa Shah
-- Create date: 03/24/2017
-- Description:	Get Task Detail for EMail
-- =============================================

CREATE PROCEDURE [dbo].[sp_GetTaskDetailsForMail] 
(
	@TaskId int 
)	  
AS

BEGIN

	SET NOCOUNT ON;

	SELECT TaskId,InstallId,Title FROM [TaskListView] 
	WHERE ParentTaskId=@TaskId OR (TaskId=@TaskId AND TaskLevel='1')
	ORDER BY TaskId

END

----------------------------------------------------------------

----------------------------------------------------------------
-- =============================================
-- Author:		Pratixa Shah
-- Update date: 03/24/2017
-- Description:	To Update Task Link Format along with Task Name
-- =============================================

UPDATE tblSubHtmlTemplates SET 
HTMLBody='<div>Hi #Fname#,<br/><br/>You are assigned a task.
<br/><br/>Please click or copy below link to view task:<br/><br/>
<a href="#TaskLink#">#TaskLinkName#</a>
<br/><br/>Thanks!</div>'
WHERE HTMLTemplateId='108'

UPDATE tblSubHtmlTemplates SET HTMLBody='<div>
Hi #Fname#,
<br/><br/>
You have accepted the task.
<br/><br/>
Please click or copy below link to view task:
<br/><br/>
<a href="#ParentTaskLink#">#ParentTaskLinkName#</a>
<br/><br/>
SubTask List
<br/><br/>
#SubTaskLink#
<br/><br/>
Quick View
<br/><br/>
<a href="#QuickViewLink#">#QuickViewLinkName#</a>
<br/><br/>
View More...
<br/><br/>
<a href="#ViewMoreLink#">#ViewMoreLinkName#</a>
<br/><br/>
Thanks!</div>'
WHERE HTMLTemplateId='111'

----------------------------------------------------------------

----------------------------------------------------------------
-- =============================================
-- Author:		Pratixa Shah
-- Update date: 03/24/2017
-- Description:	To Update Task Link Format along with Task Name
-- =============================================

UPDATE tblSubHtmlTemplates SET HTMLBody='<div>
Hi #Fname#,
<br/><br/>
You have rejected the task.
<br/><br/>
Please click or copy below link to view task:
<br/><br/>
<a href="#ParentTaskLink#">#ParentTaskLinkName#</a>
<br/><br/>
SubTask List
<br/><br/>
#SubTaskLink#
<br/><br/>
Quick View
<br/><br/>
<a href="#QuickViewLink#">#QuickViewLinkName#</a>
<br/><br/>
View More...
<br/><br/>
<a href="#ViewMoreLink#">#ViewMoreLinkName#</a>
<br/><br/>
Thanks!</div>'
WHERE HTMLTemplateId='112'

----------------------------------------------------------------