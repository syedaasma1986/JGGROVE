USE [JGBS_Dev_New]
GO

/****** Object:  UserDefinedFunction [dbo].[GetParent]    Script Date: 14/Apr/2017 7:55:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GetParent]
(    
      @pid int
)
RETURNS @Output TABLE (
      parenttaskid int
)
AS
BEGIN
		;with name_tree as 
		(
		   select taskid, parenttaskid
		   from tblTask
		   where taskid = @pid
		   union all
		   select C.taskid, C.parenttaskid
		   from tblTask c
		   join name_tree p on C.taskid = P.parenttaskid
			AND C.taskid<>C.parenttaskid 
		)
		
		insert INTO @Output(parenttaskid) select top 1 parenttaskid from name_tree order by parenttaskid OPTION (MAXRECURSION 0)
		 
      RETURN
END
GO


ALTER PROCEDURE [dbo].[GetClosedTasks] 
	-- Add the parameters for the stored procedure here
	@userid int,
	@desigid int,
	@search varchar(100),
	@PageIndex INT, 
	@PageSize INT
AS
BEGIN
DECLARE @StartIndex INT  = 0
SET @StartIndex = (@PageIndex * @PageSize) + 1

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @str nvarchar(700)
	set @str = ''
	if @search<>''
		begin
			;WITH 
		Tasklist AS
		(
			select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],ParentTaskId,TaskLevel,Assigneduser,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,
			case 
				when (ParentTaskId is null and  TaskLevel=1) then InstallId 
				when (tasklevel =1 and ParentTaskId>0) then 
					(select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId  
				when (tasklevel =2 and ParentTaskId>0) then
				 (select InstallId from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
				+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
					
				when (tasklevel =3 and ParentTaskId>0) then
				(select InstallId from tbltask where taskid in (
				(select parenttaskid from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))
				+'-'+
				 (select InstallId from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
				+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
			end as 'InstallId',Row_number() OVER (  order by TaskId ) AS RowNo_Order
			from (

			SELECT a.TaskId,[Description],a.[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],a.InstallId ,ParentTaskId,TaskLevel,t.FristName + ' ' + t.LastName AS Assigneduser
			from dbo.tblTask as a, tbltaskassignedusers as b,tblInstallUsers as t
			where a.[Status]  in (7,8,9,10,11,12,14) and a.TaskId=b.TaskId and b.UserId=t.Id
			AND  (
			t.FristName LIKE '%'+ @search + '%'  or
			t.LastName LIKE '%'+ @search + '%'  or
			t.Email LIKE '%' + @search +'%'  
			) and  tasklevel=1 and parenttaskid is not null
			--order by [Status] desc

			union all

			SELECT a.TaskId,[Description],a.[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],a.InstallId ,ParentTaskId,TaskLevel,t.FristName + ' ' + t.LastName AS Assigneduser
			from dbo.tblTask as a, tbltaskassignedusers as b,tblInstallUsers as t
			where a.[Status]  in (7,8,9,10,11,12,14) and a.MainParentId=b.TaskId and b.UserId=t.Id
			AND  (
			t.FristName LIKE '%'+ @search + '%'  or
			t.LastName LIKE '%'+ @search + '%'  or
			t.Email LIKE '%' + @search +'%'  
			) and  parenttaskid is not null

			) as x
			)
			
		SELECT *
		INTO #temp1
		FROM Tasklist

			SELECT
			*
			FROM #temp1
			WHERE 
			RowNo_Order >= @StartIndex AND 
			(
				@PageSize = 0 OR 
				RowNo_Order < (@StartIndex + @PageSize)
			)
			order by [Status] desc

		SELECT
		COUNT(*) AS TotalRecords
		FROM #temp1

		end
   else if @userid=0 and @desigid=0
		begin
		;WITH 
		Tasklist AS
		(
			select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],ParentTaskId,TaskLevel,Assigneduser,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,
			case 
				when (ParentTaskId is null and  TaskLevel=1) then InstallId 
				when (tasklevel =1 and ParentTaskId>0) then 
					(select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId  
				when (tasklevel =2 and ParentTaskId>0) then
				 (select InstallId from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
				+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
					
				when (tasklevel =3 and ParentTaskId>0) then
				(select InstallId from tbltask where taskid in (
				(select parenttaskid from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))
				+'-'+
				 (select InstallId from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
				+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
			end as 'InstallId',Row_number() OVER (  order by TaskId ) AS RowNo_Order
			from (
			SELECT a.TaskId,[Description],a.[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],a.InstallId,ParentTaskId,TaskLevel,t.FristName + ' ' + t.LastName AS Assigneduser
			from dbo.tblTask  as a, tbltaskassignedusers as b
			LEFT OUTER JOIN tblInstallUsers as t ON t.Id = b.UserId
			where a.[Status]  in (7,8,9,10,11,12,14) and  a.tasklevel=1 and a.parenttaskid is not null
			) as x
			)

			
		SELECT *
		INTO #temp2
		FROM Tasklist

			SELECT
			*
			FROM #temp2
			WHERE 
			RowNo_Order >= @StartIndex AND 
			(
				@PageSize = 0 OR 
				RowNo_Order < (@StartIndex + @PageSize)
			)
			order by [Status] desc
			
		SELECT
		COUNT(*) AS TotalRecords
		FROM #temp2

		end
	else if @userid>0  
		begin
			;WITH 
		Tasklist AS
		(
			select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],ParentTaskId,TaskLevel,Assigneduser,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,
			case 
				when (ParentTaskId is null and  TaskLevel=1) then InstallId 
				when (tasklevel =1 and ParentTaskId>0) then 
					(select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId  
				when (tasklevel =2 and ParentTaskId>0) then
				 (select InstallId from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
				+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
					
				when (tasklevel =3 and ParentTaskId>0) then
				(select InstallId from tbltask where taskid in (
				(select parenttaskid from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))
				+'-'+
				 (select InstallId from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
				+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
			end as 'InstallId',Row_number() OVER (  order by TaskId ) AS RowNo_Order
			from (

			SELECT a.TaskId,[Description],a.[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],a.InstallId ,ParentTaskId,TaskLevel,t.FristName + ' ' + t.LastName AS Assigneduser
			from dbo.tblTask as a, tbltaskassignedusers as b
			LEFT OUTER JOIN tblInstallUsers as t ON t.Id = b.UserId
			where a.[Status]  in (7,8,9,10,11,12,14) and a.TaskId=b.TaskId and b.UserId=@userid
			and  tasklevel=1 and parenttaskid is not null
			--order by [Status] desc

			union all

			SELECT a.TaskId,[Description],a.[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],a.InstallId ,ParentTaskId,TaskLevel,t.FristName + ' ' + t.LastName AS Assigneduser
			from dbo.tblTask as a, tbltaskassignedusers as b
			LEFT OUTER JOIN tblInstallUsers as t ON t.Id = b.UserId
			where a.[Status]  in (7,8,9,10,11,12,14) and a.MainParentId=b.TaskId and b.UserId=@userid
			and parenttaskid is not null
			
			) as x
			)
			
		SELECT *
		INTO #temp3
		FROM Tasklist

		
			SELECT
			*
			FROM #temp3
			WHERE 
			RowNo_Order >= @StartIndex AND 
			(
				@PageSize = 0 OR 
				RowNo_Order < (@StartIndex + @PageSize)
			)
			order by [Status] desc
				
		SELECT
		COUNT(*) AS TotalRecords
		FROM #temp3

		end
	else if @userid=0 and @desigid>0
		begin
;WITH 
		Tasklist AS
		(	
			select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],ParentTaskId,TaskLevel,Assigneduser,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,
			case 
				when (ParentTaskId is null and  TaskLevel=1) then InstallId 
				when (tasklevel =1 and ParentTaskId>0) then 
					(select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId  
				when (tasklevel =2 and ParentTaskId>0) then
				 (select InstallId from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
				+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
					
				when (tasklevel =3 and ParentTaskId>0) then
				(select InstallId from tbltask where taskid in (
				(select parenttaskid from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))
				+'-'+
				 (select InstallId from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
				+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
			end as 'InstallId',Row_number() OVER (  order by TaskId ) AS RowNo_Order
			from (

			SELECT a.TaskId,[Description],a.[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],a.InstallId,ParentTaskId,TaskLevel,' ' AS Assigneduser
			from dbo.tblTask as a, tblTaskdesignations as b
			where a.[Status]  in (7,8,9,10,11,12,14) and a.TaskId=b.TaskId and b.DesignationID=@desigid
			and  tasklevel=1 and parenttaskid is not null
			--order by [Status] desc

			union all

			SELECT a.TaskId,[Description],a.[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],a.InstallId,ParentTaskId,TaskLevel,' ' AS Assigneduser
			from dbo.tblTask as a, tblTaskdesignations as b 
			where a.[Status]  in (7,8,9,10,11,12,14) and a.MainParentId=b.TaskId and b.DesignationID=@desigid
			and  parenttaskid is not null

			) as x
			)
			
		SELECT *
		INTO #temp4
		FROM Tasklist

			SELECT
			*
			FROM #temp4
			WHERE 
			RowNo_Order >= @StartIndex AND 
			(
				@PageSize = 0 OR 
				RowNo_Order < (@StartIndex + @PageSize)
			)
			order by [Status] desc
			
		SELECT
		COUNT(*) AS TotalRecords
		FROM #temp4

		end
END
go


ALTER PROCEDURE [dbo].[GetInProgressTasks] 
	-- Add the parameters for the stored procedure here
	@userid int,
	@desigid int,
	@search varchar(100),
	@PageIndex INT , 
	@PageSize INT 
AS
BEGIN

DECLARE @StartIndex INT  = 0
SET @StartIndex = (@PageIndex * @PageSize) + 1

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @str nvarchar(700)
	set @str = ''
	if @search<>''
		begin
			;WITH 
		Tasklist AS
		(
			select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],ParentTaskId,TaskLevel,Assigneduser,InstallId as InstallId1, (select * from [GetParent](TaskId)) as MainParentId,
			case 
				when (ParentTaskId is null and  TaskLevel=1) then InstallId 
				when (tasklevel =1 and ParentTaskId>0) then 
					(select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId  
				when (tasklevel =2 and ParentTaskId>0) then
				 (select InstallId from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
				+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
					
				when (tasklevel =3 and ParentTaskId>0) then
				(select InstallId from tbltask where taskid in (
				(select parenttaskid from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))
				+'-'+
				 (select InstallId from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
				+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
			end as 'InstallId',Row_number() OVER (  order by TaskId ) AS RowNo_Order
			from (

				SELECT a.TaskId,[Description],a.[Status],convert(Date,DueDate ) as DueDate,
				Title,[Hours],a.InstallId ,ParentTaskId,TaskLevel,t.FristName + ' ' + t.LastName AS Assigneduser
				from dbo.tblTask as a, tbltaskassignedusers as b,tblInstallUsers as t
				where a.[Status]  in (1,2,3,4) and a.TaskId=b.TaskId and b.UserId=t.Id
				AND  (
				t.FristName LIKE '%'+ @search + '%'  or
				t.LastName LIKE '%'+ @search + '%'  or
				t.Email LIKE '%' + @search +'%'  
				) and  tasklevel=1 and parenttaskid is not null
				--order by [Status] desc

				union all

				SELECT a.TaskId,[Description],a.[Status],convert(Date,DueDate ) as DueDate,
				Title,[Hours],a.InstallId ,ParentTaskId,TaskLevel,t.FristName + ' ' + t.LastName AS Assigneduser
				from dbo.tblTask as a, tbltaskassignedusers as b,tblInstallUsers as t
				where a.[Status]  in (1,2,3,4) and a.MainParentId=b.TaskId and b.UserId=t.Id
				AND  (
				t.FristName LIKE '%'+ @search + '%'  or
				t.LastName LIKE '%'+ @search + '%'  or
				t.Email LIKE '%' + @search +'%'  
				) and parenttaskid is not null
			) as x
			)
			
		SELECT *
		INTO #temp1
		FROM Tasklist

			SELECT
			*
			FROM #temp1
			WHERE 
			RowNo_Order >= @StartIndex AND 
			(
				@PageSize = 0 OR 
				RowNo_Order < (@StartIndex + @PageSize)
			)
			order by [Status] desc

		SELECT
		COUNT(*) AS TotalRecords
		FROM #temp1


		end
    else if @userid=0 and @desigid=0
		begin
			;WITH 
		Tasklist AS
		(
			select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],ParentTaskId,TaskLevel,InstallId as InstallId1, Assigneduser,(select * from [GetParent](TaskId)) as MainParentId,
			case 
				when (ParentTaskId is null and  TaskLevel=1) then InstallId 
				when (tasklevel =1 and ParentTaskId>0) then 
					(select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId  
				when (tasklevel =2 and ParentTaskId>0) then
				 (select InstallId from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
				+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
					
				when (tasklevel =3 and ParentTaskId>0) then
				(select InstallId from tbltask where taskid in (
				(select parenttaskid from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))
				+'-'+
				 (select InstallId from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
				+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
			end as 'InstallId',Row_number() OVER (  order by TaskId ) AS RowNo_Order
			from (

				SELECT a.TaskId,a.[Description],a.[Status],convert(Date,DueDate ) as DueDate,
				Title,[Hours],a.InstallId,a.ParentTaskId,a.TaskLevel,t.FristName + ' ' + t.LastName AS Assigneduser
			    from dbo.tblTask as a 
			LEFT OUTER JOIN tblTaskdesignations as b ON a.TaskId = b.TaskId 
			LEFT OUTER JOIN tbltaskassignedusers as c ON a.TaskId = c.TaskId
			LEFT OUTER JOIN tblInstallUsers as t ON c.UserId = t.Id  
				where a.[Status]  in (1,2,3,4)  and parenttaskid is not null

			)as x
			)
				
		SELECT *
		INTO #temp2
		FROM Tasklist

			SELECT
			*
			FROM #temp2
			WHERE 
			RowNo_Order >= @StartIndex AND 
			(
				@PageSize = 0 OR 
				RowNo_Order < (@StartIndex + @PageSize)
			)
			order by [Status] desc
			
		SELECT
		COUNT(*) AS TotalRecords
		FROM #temp2

		end
	else if @userid>0  
		begin

			;WITH 
		Tasklist AS
		(
			select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],ParentTaskId,TaskLevel,Assigneduser,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,
			case 
				when (ParentTaskId is null and  TaskLevel=1) then InstallId 
				when (tasklevel =1 and ParentTaskId>0) then 
					(select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId  
				when (tasklevel =2 and ParentTaskId>0) then
				 (select InstallId from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
				+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
					
				when (tasklevel =3 and ParentTaskId>0) then
				(select InstallId from tbltask where taskid in (
				(select parenttaskid from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))
				+'-'+
				 (select InstallId from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
				+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
			end as 'InstallId',Row_number() OVER (  order by TaskId ) AS RowNo_Order
			from (


			SELECT a.TaskId,[Description],a.[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],a.InstallId ,ParentTaskId,TaskLevel,t.FristName + ' ' + t.LastName AS Assigneduser
			from dbo.tblTask as a, tbltaskassignedusers as b
			LEFT OUTER JOIN tblInstallUsers as t ON t.Id = b.UserId
			where a.[Status]  in (1,2,3,4) and a.TaskId=b.TaskId and b.UserId=@userid
			and  tasklevel=1 and parenttaskid is not null
			--order by [Status] desc

			union all 

			SELECT a.TaskId,[Description],a.[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],a.InstallId ,ParentTaskId,TaskLevel,t.FristName + ' ' + t.LastName AS Assigneduser
			from dbo.tblTask as a, tbltaskassignedusers as b
			LEFT OUTER JOIN tblInstallUsers as t ON t.Id = b.UserId
			where a.[Status]  in (1,2,3,4) and a.MainParentId=b.TaskId and b.UserId=@userid
			and parenttaskid is not null
			 
			) as x  
			)

		SELECT *
		INTO #temp3
		FROM Tasklist
	
			SELECT
			*
			FROM #temp3
			WHERE 
			RowNo_Order >= @StartIndex AND 
			(
				@PageSize = 0 OR 
				RowNo_Order < (@StartIndex + @PageSize)
			)
			order by [Status] desc

		
		SELECT
		COUNT(*) AS TotalRecords
		FROM #temp3

		end
	else if @userid=0 and @desigid>0
		begin
			
			;WITH 
		Tasklist AS
		(	
			select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,
			Title,[Hours],ParentTaskId,TaskLevel,Assigneduser,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,
			case 
				when (ParentTaskId is null and  TaskLevel=1) then InstallId 
				when (tasklevel =1 and ParentTaskId>0) then 
					(select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId  
				when (tasklevel =2 and ParentTaskId>0) then
				 (select InstallId from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
				+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
					
				when (tasklevel =3 and ParentTaskId>0) then
				(select InstallId from tbltask where taskid in (
				(select parenttaskid from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))
				+'-'+
				 (select InstallId from tbltask where taskid in (
				(select parentTaskId from tbltask where   taskid=x.parenttaskid) ))
				+'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid)	+ '-' +InstallId 
			end as 'InstallId',Row_number() OVER (  order by TaskId ) AS RowNo_Order
			from (

			SELECT a.TaskId,a.[Description],a.[Status],convert(Date,DueDate ) as DueDate,
			a.Title,a.[Hours],a.InstallId,a.ParentTaskId,a.TaskLevel,t.FristName + ' ' + t.LastName AS Assigneduser

			from dbo.tblTask as a 
			LEFT OUTER JOIN tblTaskdesignations as b ON a.TaskId = b.TaskId 
			LEFT OUTER JOIN tbltaskassignedusers as c ON a.TaskId = c.UserId
			LEFT OUTER JOIN tblInstallUsers as t ON t.Id = c.UserId
			where a.[Status]  in (1,2,3,4) and a.TaskId=b.TaskId and b.DesignationID=@desigid
			and  tasklevel=1 and parenttaskid is not null
			--order by [Status] desc

			union all 

			SELECT a.TaskId,a.[Description],a.[Status],convert(Date,DueDate ) as DueDate,
			a.Title,a.[Hours],a.InstallId,a.ParentTaskId,a.TaskLevel,t.FristName + ' ' + t.LastName AS Assigneduser
			from dbo.tblTask as a
			LEFT OUTER JOIN tblTaskdesignations as b ON a.TaskId = b.TaskId 
			LEFT OUTER JOIN tbltaskassignedusers as c ON a.TaskId = c.UserId
			LEFT OUTER JOIN tblInstallUsers as t ON t.Id = c.UserId
			where a.[Status]  in (1,2,3,4) and a.MainParentId=b.TaskId and b.DesignationID=@desigid
			and parenttaskid is not null
			) as x

			)

	
		SELECT *
		INTO #temp4
		FROM Tasklist

			SELECT
			*
			FROM #temp4
			WHERE 
			RowNo_Order >= @StartIndex AND 
			(
				@PageSize = 0 OR 
				RowNo_Order < (@StartIndex + @PageSize)
			)
			order by [Status] desc
			
		SELECT
		COUNT(*) AS TotalRecords
		FROM #temp4

		end
END
go


ALTER PROCEDURE [dbo].[SP_SaveOrDeleteTask]  
	 @Mode tinyint, -- 0:Insert, 1: Update, 2: Delete  
	 @TaskId bigint,  
	 @Title varchar(250),  
	 @Url varchar(250),
	 @Description varchar(MAX),  
	 @Status tinyint,  
	 @DueDate datetime = NULL,  
	 @Hours varchar(25),
	 @CreatedBy int,	
	 @InstallId varchar(50) = NULL,
	 @ParentTaskId bigint = NULL,
	 @TaskType tinyint = NULL,
	 @TaskLevel int,
	 @MainTaskId int,
	 @TaskPriority tinyint = null,
	 @IsTechTask bit = NULL,
	 @DeletedStatus	TINYINT = 9,
	 @Result int output
AS  
BEGIN  
  
	IF @Mode=0  
	  BEGIN  
		INSERT INTO tblTask 
				(
					Title,
					Url,
					[Description],
					[Status],
					DueDate,
					[Hours],
					CreatedBy,
					CreatedOn,
					IsDeleted,
					InstallId,
					ParentTaskId,
					TaskType,
					TaskPriority,
					IsTechTask,
					AdminStatus,
					TechLeadStatus,
					OtherUserStatus,
					TaskLevel,
					MainParentId
				)
		VALUES
				(
					@Title,
					@Url,
					@Description,
					@Status,
					@DueDate,
					@Hours,
					@CreatedBy,
					GETDATE(),
					0,
					@InstallId,
					@ParentTaskId,
					@TaskType,
					@TaskPriority,
					@IsTechTask,
					0,
					0,
					0,
					@TaskLevel,
					@MainTaskId
				)  
  
		SET @Result=SCOPE_IDENTITY ()  
  
		RETURN @Result  
	END  
	ELSE IF @Mode=1 -- Update  
	BEGIN    
		UPDATE tblTask  
		SET  
			Title=@Title,  
			Url = @Url,
			[Description]=@Description,  
			[Status]=@Status,  
			DueDate=@DueDate,  
			[Hours]=@Hours,
			[TaskType] = @TaskType,
			[TaskPriority] = @TaskPriority,
			[IsTechTask] = @IsTechTask
		WHERE TaskId=@TaskId  

		SET @Result= @TaskId
  
		RETURN @Result  
	END  
	ELSE IF @Mode=2 --Delete  
	BEGIN  
		UPDATE tblTask  
		SET  
			IsDeleted=1,
			[Status] = @DeletedStatus
		WHERE TaskId=@TaskId OR ParentTaskId=@TaskId  
	END  
  
END

go