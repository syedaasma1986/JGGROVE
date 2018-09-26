
---------------------------------------------------------------------
-- =============================================  
-- Author:  Pratixa  
-- Create date: 27 March 2017  
-- Description: To INSERT Email Template for Accpeted Task Automail
-- =============================================  

INSERT INTO tblHTMLTemplatesMaster VALUES
(80, 'Task_Accepted_Auto_Email' , 'Task Acceptance Acknowledgement',
'<div style="font-size: 13.3333px;"><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/header.jpg"' + ' />
</div><div style="font-size: 13.3333px;"><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/logo.gif"' + ' /></div>',
'<div>
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
Thanks!</div>',
'<br /><div><p style="font-size: 13.3333px;">J.M. Grove - Construction &amp; Supply&nbsp;<br /><a href=' + '"http://web.jmgrovebuildingsupply.com/Sr_App/jmgroveconstruction.com"' + '>jmgroveconstruction.com&nbsp;</a><br />
<a href=' + '"http://jmgrovebuildingsupply.com/"' + '>http://jmgrovebuildingsupply.com/</a><br />
<a href=' + '"http://web.jmgrovebuildingsupply.com/login.aspx"' + '>http://web.jmgrovebuildingsupply.com/login.aspx</a><br />
<a href=' + '"http://jmgroverealestate.com/"' + '>http://jmgroverealestate.com/</a><br />
<br />72 E Lancaster Ave<br />Malvern, Pa 19355<br />Human Resources<br />Office:(215) 274-5182 Ext. 4<br />
<a href=' + '"mailto:Hr@jmgroveconstruction.com"' + '>Hr@jmgroveconstruction.com</a></p>
<div style="font-size: 13.3333px;"><a href=' + '"https://www.facebook.com/JMGrove1com/"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/fb.png"' + ' />
</a><a href=' + '"http://s49.photobucket.com/user/jmg1/media/twitter_zpsiiplyhiq.png.html"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/tw.png"' + ' />
</a><a href=' + '"http://s49.photobucket.com/user/jmg1/media/236e0d0b-832c-4543-81a6-f6c460d302f0_zpsl4nh3ane.png.html"' + '>
<img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/gpls.png"' + ' /></a><a href=' + '"http://s49.photobucket.com/user/jmg1/media/pinterest_zpspioq6pve.png.html"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/pint.png"' + ' /></a><br />
<a href=' + '"http://s49.photobucket.com/user/jmg1/media/twitter_zpsiiplyhiq.png.html"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/hbt.png"' + ' /></a><a href=' + '"http://s49.photobucket.com/user/jmg1/media/youtube_zpsxyhfmm1b.png.html"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/yt.png"' + ' /></a>
<a href=' + '"http://s49.photobucket.com/user/jmg1/media/c3894afd-7a37-43e2-917c-5ffb7a5036a2_zpschul0pqd.png.html"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/houzz.png"' + ' /></a>&nbsp;
<a href=' + '"http://s49.photobucket.com/user/jmg1/media/4478596b-67f4-444e-992a-624af3e56255_zpsoi8p1uyv.jpg.html"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/linkin.jpg"' + ' /></a></div>
<div style="font-size: 13.3333px;"><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/footer.png"' + ' /></div></div>',
GETDATE(),1,1)

---------------------------------------------------------------------


---------------------------------------------------------------------
-- =============================================  
-- Author:  Pratixa  
-- Create date: 27 March 2017  
-- Description: To INSERT Email Template for Rejected Task Automail
-- =============================================  

INSERT INTO tblHTMLTemplatesMaster VALUES
(81, 'Task_Rejected_Auto_Email' , 'Task Rejection Acknowledgement',
'<div style="font-size: 13.3333px;"><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/header.jpg"' + ' />
</div><div style="font-size: 13.3333px;"><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/logo.gif"' + ' /></div>',
'<div>
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
Thanks!</div>',
'<br /><div><p style="font-size: 13.3333px;">J.M. Grove - Construction &amp; Supply&nbsp;<br /><a href=' + '"http://web.jmgrovebuildingsupply.com/Sr_App/jmgroveconstruction.com"' + '>jmgroveconstruction.com&nbsp;</a><br />
<a href=' + '"http://jmgrovebuildingsupply.com/"' + '>http://jmgrovebuildingsupply.com/</a><br />
<a href=' + '"http://web.jmgrovebuildingsupply.com/login.aspx"' + '>http://web.jmgrovebuildingsupply.com/login.aspx</a><br />
<a href=' + '"http://jmgroverealestate.com/"' + '>http://jmgroverealestate.com/</a><br />
<br />72 E Lancaster Ave<br />Malvern, Pa 19355<br />Human Resources<br />Office:(215) 274-5182 Ext. 4<br />
<a href=' + '"mailto:Hr@jmgroveconstruction.com"' + '>Hr@jmgroveconstruction.com</a></p>
<div style="font-size: 13.3333px;"><a href=' + '"https://www.facebook.com/JMGrove1com/"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/fb.png"' + ' />
</a><a href=' + '"http://s49.photobucket.com/user/jmg1/media/twitter_zpsiiplyhiq.png.html"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/tw.png"' + ' />
</a><a href=' + '"http://s49.photobucket.com/user/jmg1/media/236e0d0b-832c-4543-81a6-f6c460d302f0_zpsl4nh3ane.png.html"' + '>
<img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/gpls.png"' + ' /></a><a href=' + '"http://s49.photobucket.com/user/jmg1/media/pinterest_zpspioq6pve.png.html"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/pint.png"' + ' /></a><br />
<a href=' + '"http://s49.photobucket.com/user/jmg1/media/twitter_zpsiiplyhiq.png.html"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/hbt.png"' + ' /></a><a href=' + '"http://s49.photobucket.com/user/jmg1/media/youtube_zpsxyhfmm1b.png.html"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/yt.png"' + ' /></a>
<a href=' + '"http://s49.photobucket.com/user/jmg1/media/c3894afd-7a37-43e2-917c-5ffb7a5036a2_zpschul0pqd.png.html"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/houzz.png"' + ' /></a>&nbsp;
<a href=' + '"http://s49.photobucket.com/user/jmg1/media/4478596b-67f4-444e-992a-624af3e56255_zpsoi8p1uyv.jpg.html"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/linkin.jpg"' + ' /></a></div>
<div style="font-size: 13.3333px;"><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/footer.png"' + ' /></div></div>',
GETDATE(),1,1)

---------------------------------------------------------------------


----------------------------------------------------------------
-- =============================================
-- Author:		Pratixa Shah
-- Update date: 27 March 2017
-- Description:	To Update Task Link Format along with Task Name
-- =============================================

UPDATE tblHTMLTemplatesMaster SET 
Body='<div>Hi #Fname#,<br/><br/>You are assigned a task.
<br/><br/>Please click or copy below link to view task:<br/><br/>
<a href="#TaskLink#">#TaskLinkName#</a>
<br/><br/>Thanks!</div>'
WHERE Id='71'
	

----------------------------------------------------------------
----------------------------------------------------------------
-- =============================================
-- Author:		Pratixa Shah
-- Update date: 27 March 2017
-- Description:	To Update Task Link Format along with Task Name
-- =============================================

UPDATE tblHTMLTemplatesMaster SET 
Body='<div>Hi #Fname#,<br/><br/>You have requested task assignment..
<br/><br/>Please click or copy below link to view task:<br/><br/>
<a href="#TaskLink#">#TaskLinkName#</a>
<br/><br/>Thanks!</div>'
WHERE Id='72'
	

----------------------------------------------------------------
-- =============================================  
-- Author:  Yogesh  
-- Create date: 27 Jan 2017  
-- Description: Gets all Master HTMLTemplates.  
-- =============================================  

-- Updated To add 80 and 81 for Accepted and Rejected Mail

ALTER PROCEDURE [dbo].[GetHTMLTemplateMasters]  

AS  

BEGIN  



 -- SET NOCOUNT ON added to prevent extra result sets from  
 
 -- interfering with SELECT statements.  


 SET NOCOUNT ON;  
   
 SELECT *
 FROM tblHTMLTemplatesMaster
 WHERE Id IN (1, 7, 12, 28, 36, 41, 48, 50, 57, 58, 60,69,70,71,72,73,74, 75, 76, 77, 78, 79, 80, 81)   
 ORDER BY Id ASC  

 
END  

--------------------------------------------------------------------------

-- ============================================= 
-- Author:  Pratixa  
-- Create date: 27 March 2017  
-- Description: Gets Selected HTMLTemplates.  
-- =============================================  
CREATE PROCEDURE [dbo].[USP_GetEmailTemplateById]  

(
	@HTMLTemplateID INT
)

AS  

BEGIN  

	SET NOCOUNT ON;

	SELECT Header,Body, Footer, Subject 

	FROM tblHTMLTemplatesMaster  

	WHERE Id =  @HTMLTemplateID

	
END

----------------------------------------------------------------------------

-- =============================================

-- Author:		Yogesh Keraliya

-- Create date: 04/07/2016

-- Description:	Load all sub tasks of a task.

-- =============================================

-- Updated SET @hstid int = NULL
-- usp_GetSubTasks 115, 1, 'Description DESC'

ALTER PROCEDURE [dbo].[usp_GetSubTasks] 

(

	@TaskId INT,

	@Admin BIT,

	@SortExpression	VARCHAR(250) = 'CreatedOn DESC',

	@searchterm  as varchar(300),

	@OpenStatus		TINYINT = 1,

    @RequestedStatus	TINYINT = 2,

    @AssignedStatus	TINYINT = 3,

    @InProgressStatus	TINYINT = 4,

    @PendingStatus	TINYINT = 5,

    @ReOpenedStatus	TINYINT = 6,

    @ClosedStatus	TINYINT = 7,

    @SpecsInProgressStatus	TINYINT = 8,

    @DeletedStatus	TINYINT = 9,

	@PageIndex INT = NULL, 

	@PageSize INT = NULL,

	@hstid int = NULL

)

AS

BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from

	-- interfering with SELECT statements.

	SET NOCOUNT ON;

	declare @strt int

	DECLARE @StartIndex INT  = 0

	declare @pagenumber int

	set @pagenumber =0



	IF @PageIndex IS NULL

	BEGIN

		SET @PageIndex = 0

	END



	IF @PageSize IS NULL

	BEGIN

		SET @PageSize = 0

	END



	SET @StartIndex = (@PageIndex * @PageSize) + 1

	

	IF @searchterm = '' 

	BEGIN

		;WITH 

		Tasklist AS

		(	

			SELECT

				Tasks.*,

				(SELECT TOP 1 EstimatedHours 

					FROM [TaskApprovalsView] TaskApprovals 

					WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 1) AS AdminOrITLeadEstimatedHours,

				(SELECT TOP 1 EstimatedHours 

					FROM [TaskApprovalsView] TaskApprovals 

					WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 0) AS UserEstimatedHours,

				Row_number() OVER

				(

					ORDER BY

						CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,

						CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,

						CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,

						CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,

						CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,

						CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,

						CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,

						CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,

						CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,

						CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,

						CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,

						CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,

						CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.StatusOrder END ASC,

						CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.StatusOrder END DESC,

						CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,

						CASE WHEN @SortExpression = 'CreatedOn ASC' THEN Tasks.CreatedOn END ASC

				) AS RowNo_Order

			FROM

				(

					SELECT 

						Tasks.*,

						CASE Tasks.[Status]

							WHEN @AssignedStatus THEN 1

							WHEN @RequestedStatus THEN 1



							WHEN @InProgressStatus THEN 2

							WHEN @PendingStatus THEN 2

							WHEN @ReOpenedStatus THEN 2



							WHEN @OpenStatus THEN 

								CASE 

									WHEN ISNULL([TaskPriority],'') <> '' THEN 3

									ELSE 4

								END



							WHEN @SpecsInProgressStatus THEN 4



							WHEN @ClosedStatus THEN 5



							WHEN @DeletedStatus THEN 6



							ELSE 7



						END AS StatusOrder,

						TaskApprovals.Id AS TaskApprovalId,

						TaskApprovals.EstimatedHours AS TaskApprovalEstimatedHours,

						TaskApprovals.Description AS TaskApprovalDescription,

						TaskApprovals.UserId AS TaskApprovalUserId,

						TaskApprovals.IsInstallUser AS TaskApprovalIsInstallUser

					FROM 

						[TaskListView] Tasks 

							LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin

					WHERE

						Tasks.ParentTaskId = @TaskId 

						-- condition added by DP 23-jan-17 ---

						and Tasks.TaskLevel=1

				) Tasks

		)



		-- get records

		SELECT *

		INTO #temp

		FROM Tasklist

		

		IF @hstid = 0 

			begin



				set @pagenumber = @StartIndex



				SELECT * 

				FROM #temp 

				WHERE 

					RowNo_Order >= @StartIndex AND 

					(

						@PageSize = 0 OR 

						RowNo_Order < (@StartIndex + @PageSize)

					)

				ORDER BY RowNo_Order





			end

		else

			begin

				set @strt =( select RowNo_Order from #temp where TaskId=@hstid)

				print @strt

				--set @PageSize = 0



				declare @cel int

				set @cel =( SELECT CEILING( @strt / cast(@PageSize as float)) * @PageSize)

				print @cel 



				

				set @pagenumber = ( SELECT CEILING(  cast(@cel as float) /@PageSize) )

				



				if  @cel >0

					begin

						set @cel =@cel-  @PageSize

					end



				SELECT * 

				FROM #temp 

				WHERE 

					--RowNo_Order >= @StartIndex AND 

					RowNo_Order >@cel   AND

					(

						@PageSize = 0 OR 

						RowNo_Order < (@cel + @PageSize)

					)

				ORDER BY RowNo_Order

			end

		

		-- get records count

		SELECT

			COUNT(*) AS TotalRecords

		FROM 

			[TaskListView] Tasks 

				LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin

		WHERE

			Tasks.ParentTaskId = @TaskId 

			-- condition added by DP 23-jan-17 ---

			and Tasks.TaskLevel=1





		select @pagenumber  as pagenumber



	END

	ELSE

	BEGIN

		;WITH 

		Tasklist AS

		(	

			SELECT

				Tasks.*,

				(SELECT TOP 1 EstimatedHours 

					FROM [TaskApprovalsView] TaskApprovals 

					WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 1) AS AdminOrITLeadEstimatedHours,

				(SELECT TOP 1 EstimatedHours 

					FROM [TaskApprovalsView] TaskApprovals 

					WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 0) AS UserEstimatedHours,

				Row_number() OVER

				(

					ORDER BY

						CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,

						CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,

						CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,

						CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,

						CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,

						CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,

						CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,

						CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,

						CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,

						CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,

						CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,

						CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,

						CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.StatusOrder END ASC,

						CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.StatusOrder END DESC,

						CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,

						CASE WHEN @SortExpression = 'CreatedOn ASC' THEN Tasks.CreatedOn END ASC

				) AS RowNo_Order

			FROM

				(

					SELECT 

						Tasks.*,

						CASE Tasks.[Status]

							WHEN @AssignedStatus THEN 1

							WHEN @RequestedStatus THEN 1



							WHEN @InProgressStatus THEN 2

							WHEN @PendingStatus THEN 2

							WHEN @ReOpenedStatus THEN 2



							WHEN @OpenStatus THEN 

								CASE 

									WHEN ISNULL([TaskPriority],'') <> '' THEN 3

									ELSE 4

								END



							WHEN @SpecsInProgressStatus THEN 4



							WHEN @ClosedStatus THEN 5



							WHEN @DeletedStatus THEN 6



							ELSE 7



						END AS StatusOrder,

						TaskApprovals.Id AS TaskApprovalId,

						TaskApprovals.EstimatedHours AS TaskApprovalEstimatedHours,

						TaskApprovals.Description AS TaskApprovalDescription,

						TaskApprovals.UserId AS TaskApprovalUserId,

						TaskApprovals.IsInstallUser AS TaskApprovalIsInstallUser

					FROM 

						tblinstallusers as a,

						[TaskListView] Tasks 

							LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin

							LEFT JOIN [tbltaskassignedusers] t on Tasks.TaskId=t.TaskId

					WHERE

						Tasks.ParentTaskId = @TaskId 

						and a.Id=t.UserId and a.Fristname like '%'+@searchterm+'%'

						-- condition added by DP 23-jan-17 ---

						and Tasks.TaskLevel=1

				) Tasks

		)

		-- get records

		SELECT *

		INTO #temp1

		FROM Tasklist

		

		IF @hstid = 0 

			begin

				SELECT * 

				FROM #temp1 

				WHERE 

					RowNo_Order >= @StartIndex AND 

					(

						@PageSize = 0 OR 

						RowNo_Order < (@StartIndex + @PageSize)

					)

				ORDER BY RowNo_Order

			end

		else

			begin

				set @strt =( select RowNo_Order from #temp1 where TaskId=@hstid)

				--print @strt

				--set @PageSize = 0



				declare @cel1 int

				set @cel1 =( SELECT CEILING( @strt / cast(@PageSize as float)) * @PageSize)

				--print @cel 



				

				set @pagenumber = ( SELECT CEILING(  cast(@cel1 as float) /@PageSize) )

				



				if  @cel1 >0

					begin

						set @cel1 =@cel1-  @PageSize

					end



				SELECT * 

				FROM #temp1 

				WHERE 

					--RowNo_Order >= @StartIndex AND 

					RowNo_Order >@cel1   AND

					(

						@PageSize = 0 OR 

						RowNo_Order < (@cel1 + @PageSize)

					)

				ORDER BY RowNo_Order

			end



		-- get records count

		SELECT

			COUNT(*) AS TotalRecords

		FROM 

			tblinstallusers as a,

			[TaskListView] Tasks 

				LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin

				LEFT JOIN [tbltaskassignedusers] t on Tasks.TaskId=t.TaskId

		WHERE

			Tasks.ParentTaskId = @TaskId 

			and a.Id=t.UserId and a.Fristname like '%'+@searchterm+'%'

			-- condition added by DP 23-jan-17 ---

			and Tasks.TaskLevel=1



		

		select @pagenumber  as pagenumber





	END

END






