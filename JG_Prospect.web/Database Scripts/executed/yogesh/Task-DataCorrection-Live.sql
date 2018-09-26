-- Query to check if string has special character or not.
DECLARE @MyString VARCHAR(100)
SET @MyString = 'III-a'

IF (@MyString LIKE '%[^a-zA-Z0-9]%')
    PRINT 'Contains "special" characters'
ELSE
    PRINT 'Does not contain "special" characters'


USE JGBS
GO
-- Parent Level Task

SELECT InstallId, TaskLevel  FROM tblTask WHERE InstallId IS NOT NULL AND ParentTaskId IS NULL

UPDATE tblTask SET TaskLevel = 0 WHERE InstallId IS NOT NULL AND ParentTaskId IS NULL

SELECT InstallId, TaskLevel  FROM tblTask WHERE InstallId IS NOT NULL AND ParentTaskId IS NULL

-- First Level Tasks

SELECT InstallId, TaskLevel   FROM tblTask WHERE ParentTaskId IS NOT NULL AND InstallId NOT LIKE '%[^a-zA-Z0-9]%' AND TaskLevel <> 3

-- Second Level Tasks

SELECT InstallId, TaskLevel   FROM tblTask WHERE  ParentTaskId IS NOT NULL AND InstallId  LIKE '%[^a-zA-Z0-9]%'

UPDATE tblTask SET TaskLevel = 2  WHERE  ParentTaskId IS NOT NULL AND InstallId  LIKE '%[^a-zA-Z0-9]%'


-- Third Level Tasks

SELECT InstallId, TaskLevel   FROM tblTask WHERE  ParentTaskId IS NOT NULL AND InstallId NOT  LIKE '%[^a-zA-Z0-9]%' AND TaskLevel > 1


-- Pratiall frozen task

SELECT  COUNT(TaskId) AS PartialllyFrozenTask FROM tblTask WHERE TaskLevel IN (1,2) AND (AdminStatus = 1 OR TechLeadStatus = 1)

-- Non frozen Task

SELECT  COUNT(TaskId) AS NonFrozenTask FROM tblTask WHERE TaskLevel IN (1,2) AND (AdminStatus = 0 AND TechLeadStatus = 0 AND OtherUserStatus = 0)

-- All Tasks

SELECT  COUNT(TaskId) AS AllTasks FROM tblTask WHERE TaskLevel IN (1,2)


-- SubTasks on level 1-2 withh Admin,TechLead,OtherUserStatus is null

SELECT  Title,InstallId,AdminStatus,TechLeadStatus,OtherUserStatus   FROM tblTask WHERE TaskLevel IN (1,2) AND (AdminStatus IS NULL OR TechLeadStatus IS NULL OR OtherUserStatus IS NULL)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


WITH Tasks ( TaskId,InstallId, ParentTaskId,Title,TaskLevel , Level)
AS
(
-- Anchor member definition
    SELECT T.[TaskId],T.[InstallId],T.[ParentTaskId],T.[Title],T.[TaskLevel],0 AS Level
    FROM  dbo.tblTask AS T
    WHERE T.[ParentTaskId] IS NULL AND TaskID = 418
    UNION ALL
-- Recursive tasks definition
    SELECT T.[TaskId],T.[InstallId],T.[ParentTaskId],T.[Title],T.[TaskLevel],Level + 1
    FROM  dbo.tblTask AS T
    INNER JOIN Tasks AS T1
        ON T.[ParentTaskId] = T1.[TaskId]
)

-- Statement that executes the CTE
SELECT * FROM Tasks

GO





-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DECLARE @ParentTaskId INT
DECLARE @ParentTasks CURSOR

SET @ParentTasks = CURSOR FOR
SELECT TaskId
FROM tblTask WHERE ParentTaskId IS NULL

OPEN @ParentTasks

FETCH NEXT
FROM @ParentTasks INTO @ParentTaskId

WHILE @@FETCH_STATUS = 0
BEGIN

--------------------------------------------------------------------------------------------------------------------------------------------------------------
      
		-- Set all second level tasks with appropriate parent task id of level 1 task.
				DECLARE @SubParentTaskId INT
				DECLARE @SubParentTasks CURSOR

				SET @SubParentTasks = CURSOR FOR
				SELECT TaskId
				FROM tblTask WHERE ParentTaskId = @ParentTaskId

				OPEN @SubParentTasks

				FETCH NEXT
				FROM @SubParentTasks INTO @SubParentTaskId

				WHILE @@FETCH_STATUS = 0
				BEGIN

				DECLARE @InstallId VARCHAR(50)

				SELECT @InstallId = InstallId FROM tblTask WHERE TaskId = @SubParentTaskId

				PRINT 'SubTask' 
				SELECT @InstallId

				IF (@InstallId LIKE '%[^a-zA-Z0-9]%')
				BEGIN

				DECLARE @TaskPId INT

				SELECT @TaskPId = TaskId FROM tblTask WHERE ParentTaskId = @ParentTaskId AND InstallId LIKE '%' + LTRIM(RTRIM(SUBSTRING(InstallId,0,CHARINDEX('-',InstallId)))) + '%' AND InstallId NOT LIKE '%[^a-zA-Z0-9]%'
				
				IF( @TaskPId IS NOT NULL )
				BEGIN

					SELECT @TaskPId

					UPDATE tblTask SET ParentTaskId = @TaskPId  WHERE  TaskId = @SubParentTaskId 

				END


				END
				
				FETCH NEXT
				FROM @SubParentTasks INTO @SubParentTaskId
				END

				CLOSE @SubParentTasks
				DEALLOCATE @SubParentTasks


--------------------------------------------------------------------------------------------------------------------------------------------------------------

FETCH NEXT
FROM @ParentTasks INTO @ParentTaskId
END

CLOSE @ParentTasks
DEALLOCATE @ParentTasks

GO

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


WITH Tasks ( TaskId,InstallId, ParentTaskId,Title,TaskLevel , Level)
AS
(
-- Anchor member definition
    SELECT T.[TaskId],T.[InstallId],T.[ParentTaskId],T.[Title],T.[TaskLevel],0 AS Level
    FROM  dbo.tblTask AS T
    WHERE T.[ParentTaskId] IS NULL AND TaskId = 402
    UNION ALL
-- Recursive tasks definition
    SELECT T.[TaskId],T.[InstallId],T.[ParentTaskId],T.[Title],T.[TaskLevel],Level + 1
    FROM  dbo.tblTask AS T
    INNER JOIN Tasks AS T1
        ON T.[ParentTaskId] = T1.[TaskId]
)

-- Statement that executes the CTE
SELECT * FROM Tasks Order By ParentTaskId

GO


