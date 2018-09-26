-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  [dbo].[GetFirstParentTaskFromChild] 
	@taskid int
AS
BEGIN
	select TaskId as TaskId from tblTask where   TaskLevel=1 and TaskId=@taskid

	union all

	select ParentTaskId as TaskId from tblTask where TaskLevel=2 and TaskId=@taskid

	union all

	select ParentTaskId as TaskId from tblTask where tasklevel=2 and taskid in (
	select ParentTaskId from tblTask where TaskLevel=3 and TaskId=@taskid )
END
GO
