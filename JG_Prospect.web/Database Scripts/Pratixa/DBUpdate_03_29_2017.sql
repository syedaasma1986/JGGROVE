-- =============================================

-- Author:		<Author,,Name>

-- Create date: <Create Date,,>

-- Description:	<Description,,>

-- =============================================
ALTER PROCEDURE  [dbo].[GetParentChildTasks]

	-- Add the parameters for the stored procedure here

	@taskid int

AS

BEGIN

	

select TaskId,ParentTaskId,InstallId,MainParentId,Description,Title,URL,TaskLevel,(SELECT InstallId FROM tblTask WHERE TaskId = (SELECT ParentTaskId FROM tblTask WHERE TaskId=@taskid)) AS ParentTaskInstallId

 from tbltask where taskid=@taskid  and tasklevel=1

union all

--- level-2

select TaskId,ParentTaskId,InstallId,MainParentId,Description,Title,URL,TaskLevel,(SELECT InstallId FROM tblTask WHERE TaskId = (SELECT ParentTaskId FROM tblTask WHERE TaskId=@taskid)) AS ParentTaskInstallId

 from tbltask where parenttaskid=@taskid and tasklevel=2

union all

--- level-3

select TaskId,ParentTaskId,InstallId,MainParentId,Description,Title,URL,TaskLevel,(SELECT InstallId FROM tblTask WHERE TaskId = (SELECT ParentTaskId FROM tblTask WHERE TaskId=@taskid)) AS ParentTaskInstallId

 from tbltask where tasklevel=3 and parenttaskid in (select taskid from tbltask where parenttaskid=@taskid) 

END


