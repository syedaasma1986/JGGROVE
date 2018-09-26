--FOR GITHUB
CREATE PROCEDURE [dbo].[UDP_GETUserGithubUsername]    
(
@Id int  
)
AS    
BEGIN    
SELECT        GitUserName
FROM          [tblInstallUsers]
WHERE Id  = @Id
END

GO

ALTER PROCEDURE [dbo].[usp_UpdateInstallUserConfirmDetails] 
(
	@UserId INT,
	@Address VARCHAR(100),
	@DOB VARCHAR(25),
	@maritalstatus VARCHAR(25),
	@Attachements VARCHAR(MAX),
	@PCLiscense VARCHAR(MAX),
	@Citizenship VARCHAR(50),
	@GithubUsername VARCHAR(50)
)
AS
BEGIN
UPDATE       tblInstallUsers
SET                [Address] = @Address, DOB = @DOB, maritalstatus = @maritalstatus, Attachements = @Attachements , PCLiscense = @PCLiscense, Citizenship = @Citizenship, GitUserName = @GithubUsername
WHERE Id = @UserId
END

GO

ALTER PROCEDURE [dbo].[UDP_GETInstallUserDetails]
	@id int
As 
BEGIN

	SELECT 
		u.Id,FristName,Lastname,Email,[Address], ISNULL(d.DesignationName, Designation) AS Designation,
		[Status],[Password],Phone,Picture,Attachements,zip,[state],city,
		Bussinessname,SSN,SSN1,SSN2,[Signature],DOB,Citizenship,' ',
		EIN1,EIN2,A,B,C,D,E,F,G,H,[5],[6],[7],maritalstatus,PrimeryTradeId,SecondoryTradeId,Source,Notes,StatusReason,GeneralLiability,PCLiscense,WorkerComp,HireDate,TerminitionDate,WorkersCompCode,NextReviewDate,EmpType,LastReviewDate,PayRates,ExtraEarning,ExtraEarningAmt,
		PayMethod,Deduction,DeductionType,AbaAccountNo,AccountNo,AccountType,PTradeOthers,
		STradeOthers,DeductionReason,InstallId,SuiteAptRoom,FullTimePosition,ContractorsBuilderOwner,MajorTools,DrugTest,ValidLicense,TruckTools,PrevApply,LicenseStatus,CrimeStatus,StartDate,SalaryReq,Avialability,ResumePath,skillassessmentstatus,assessmentPath
		,WarrentyPolicy,CirtificationTraining,businessYrs,underPresentComp,websiteaddress,PersonName,PersonType,CompanyPrinciple,UserType,Email2,Phone2,CompanyName,SourceUser,DateSourced,InstallerType,BusinessType,CEO,LegalOfficer,President,Owner,AllParteners,
		MailingAddress,Warrantyguarantee,WarrantyYrs,MinorityBussiness,WomensEnterprise,InterviewTime,CruntEmployement,CurrentEmoPlace,LeavingReason,CompLit,FELONY,shortterm,LongTerm,BestCandidate,TalentVenue,Boardsites,NonTraditional,ConSalTraning,BestTradeOne,
		BestTradeTwo,BestTradeThree
		,aOne,aOneTwo,bOne,cOne,aTwo,aTwoTwo,bTwo,cTwo,aThree,aThreeTwo,bThree,cThree,TC,ExtraIncomeType,RejectionDate ,UserInstallId
        ,PositionAppliedFor, PhoneExtNo, PhoneISDCode ,DesignationID, CountryCode
		,NameMiddleInitial , IsEmailPrimaryEmail, IsPhonePrimaryPhone, IsEmailContactPreference, IsCallContactPreference, IsTextContactPreference, IsMailContactPreference, d.ID AS DesignationId, 
		SourceID,DesignationCode
	
	FROM tblInstallUsers u 
			LEFT JOIN tbl_Designation d ON u.DesignationID = d.ID

	WHERE u.ID=@id

END

GO

create procedure [dbo].[UpdateGithubUsername]
@GithubUsername VARCHAR(50),
@UserId INT
as
begin
update tblInstallUsers set GitUserName = @GithubUsername
WHERE Id = @UserId
end

GO

CREATE PROCEDURE UDP_GETInstallUserDesignationCode
	-- Add the parameters for the stored procedure here
	@UserID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [DesignationCode] FROM [dbo].[tblInstallUsers] JOIN
	[dbo].[tbl_Designation]
	ON
	[dbo].[tbl_Designation].[ID] = [dbo].[tblInstallUsers].[DesignationID]
	WHERE [dbo].[tblInstallUsers].[Id] = @UserID
END
GO
---END


--FOR IT DASHBOARD SEQUENCING/Sequencing popup issues 
ALTER PROCEDURE [dbo].[usp_GetAllTaskWithSequence]                         
(                        
                       
 @PageIndex INT = 0,                         
 @PageSize INT =20,                  
 @DesignationIds VARCHAR(20) = NULL,                  
 @IsTechTask BIT = 0,                  
 @HighLightedTaskID BIGINT = NULL
)                        
As                        
BEGIN                        
                  
                  
IF( @DesignationIds = '' )                  
BEGIN                  
                  
 SET @DesignationIds = NULL                  
                  
END                  
                        
                        
;WITH                         
 Tasklist AS                        
 (                         
  SELECT DISTINCT TaskId ,[Status],[SequenceDesignationId],[Sequence], [SubSequence],                      
  Title,ParentTaskId,IsTechTask,ParentTaskTitle,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,  TaskDesignation,        
  [AdminStatus] , [TechLeadStatus], [OtherUserStatus],[AdminStatusUpdated],[TechLeadStatusUpdated],[OtherUserStatusUpdated],[AdminUserId],[TechLeadUserId],[OtherUserId],         
  AdminUserInstallId, AdminUserFirstName, AdminUserLastName,        
  TechLeadUserInstallId,ITLeadHours,UserHours, TechLeadUserFirstName, TechLeadUserLastName,        
  OtherUserInstallId, OtherUserFirstName,OtherUserLastName,TaskAssignedUserIDs,        
  case                         
   when (ParentTaskId is null and  TaskLevel=1) then InstallId                         
   when (tasklevel =1 and ParentTaskId>0) then                         
    (select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId                          
   when (tasklevel =2 and ParentTaskId>0) then                        
    (select InstallId from tbltask where taskid in (                        
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))                        
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId                         
                             
   when (tasklevel =3 and ParentTaskId>0) then                        
   (select InstallId from tbltask where taskid in (                        
   (select parenttaskid from tbltask where taskid in (                        
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))                        
   +'-'+                        
    (select InstallId from tbltask where taskid in (                        
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))                        
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId                         
  end as 'InstallId' ,Row_number() OVER (order by x.TaskId ) AS RowNo_Order                        
  from (                        
   select DISTINCT a.*                        
   ,(select Title from tbltask where TaskId=(select * from [GetParent](a.TaskId))) AS ParentTaskTitle,        
   (SELECT EstimatedHours FROM [dbo].[tblTaskApprovals] WHERE TaskId = a.TaskId AND UserId = a.TechLeadUserId) AS ITLeadHours , (SELECT EstimatedHours FROM [dbo].[tblTaskApprovals] WHERE TaskId = a.TaskId AND UserId = a.OtherUserId) AS UserHours,        
   ta.InstallId AS AdminUserInstallId, ta.FristName AS AdminUserFirstName, ta.LastName AS AdminUserLastName,        
   tT.InstallId AS TechLeadUserInstallId, tT.FristName AS TechLeadUserFirstName, tT.LastName AS TechLeadUserLastName,        
   tU.InstallId AS OtherUserInstallId, tU.FristName AS OtherUserFirstName, tU.LastName AS OtherUserLastName,        
   --,t.FristName + ' ' + t.LastName AS Assigneduser,                      
   (                      
   STUFF((SELECT ', {"Name": "' + Designation +'","Id":'+ CONVERT(VARCHAR(5),DesignationID)+'}'                    
           FROM tblTaskdesignations td                       
           WHERE td.TaskID = a.TaskId                       
          FOR XML PATH('')), 1, 2, '')                      
  )  AS TaskDesignation,    
  (    
    STUFF((SELECT ', {"Id" : "'+ CONVERT(VARCHAR(5),UserId) + '"}'                    
           FROM tbltaskassignedusers as tau    
           WHERE tau.TaskId = a.TaskId                       
          FOR XML PATH('')), 1, 2, '')                      
  ) AS TaskAssignedUserIDs             
  --(SELECT TOP 1 DesignationID                     
  --         FROM tblTaskdesignations td                       
  --         WHERE td.TaskID = a.TaskId ) AS DesignationId                     
   from  tbltask a                        
   --LEFT OUTER JOIN tblTaskdesignations as b ON a.TaskId = b.TaskId                         
   --LEFT OUTER JOIN tbltaskassignedusers as c ON a.TaskId = c.TaskId                        
   LEFT OUTER JOIN tblInstallUsers as ta ON a.[AdminUserId] = ta.Id         
   LEFT OUTER JOIN tblInstallUsers as tT ON a.[TechLeadUserId] = tT.Id         
   LEFT OUTER JOIN tblInstallUsers as tU ON a.[OtherUserId] = tU.Id     
  -- LEFT OUTER JOIN tbltaskassignedusers as tau ON a.TaskId = tau.TaskId                        
   WHERE                   
  (                 
    (a.[Sequence] IS NOT NULL)                   	
    AND (a.[SequenceDesignationId] IN (SELECT * FROM [dbo].[SplitString](ISNULL(@DesignationIds,a.[SequenceDesignationId]),',') ) )                   
    AND (ISNULL(a.[IsTechTask],@IsTechTask) = @IsTechTask) 
	
   )                   



   OR                  
   (                  
     a.TaskId = @HighLightedTaskID  AND IsTechTask = @IsTechTask                
   )                       
   --and (CreatedOn >=@startdate and CreatedOn <= @enddate )                         
  ) as x                        
 )              
                        
 ---- get CTE data into temp table                        
 SELECT *                        
 INTO #Tasks                        
 FROM Tasklist                        
                  
---- find page number to show taskid sent.                  
DECLARE @StartIndex INT  = 0                        
                  
                        
--IF @HighLightedTaskID  > 0                  
-- BEGIN                  
--  DECLARE @RowNumber BIGINT = NULL                  
                  
--  -- Find in which rownumber highlighter taskid is.                  
--  SELECT @RowNumber = RowNo_Order                   
--  FROM #Tasks                   
--  WHERE TaskId = @HighLightedTaskID                  
                  
--  -- if row number found then divide it with page size and round it to nearest integer , so will found pagenumber to be selected.                  
--  -- for ex. if total 60 records are there,pagesize is 20 and highlighted task id is at 42 row number than.                   
--  -- 42/20 = 2.1 ~ 3 - 1 = 2 = @Page Index                  
--  -- StartIndex = (2*20)+1 = 41, so records 41 to 60 will be fetched.                  
                     
--  IF @RowNumber IS NOT NULL                  
--  BEGIN                  
--   SELECT @PageIndex = (CEILING(@RowNumber / CAST(@PageSize AS FLOAT))) - 1                  
--  END                  
-- END                    
                  
 -- Set start index to fetch record.                  
 SET @StartIndex = (@PageIndex * @PageSize) + 1                        

 ----missing rows bug solution BEGIN: kapil pancholi
 --create temp table for Sequences
 CREATE TABLE #S (TASKID INT, ROW_ID INT,[SEQUENCE] INT)
 
 INSERT INTO #S (TASKID,ROW_ID,[SEQUENCE]) 
 SELECT TASKID, Row_Number() over (order by [Sequence]),[SEQUENCE] FROM #TASKS WHERE SubSequence IS NULL

 update #Tasks set #Tasks.RowNo_Order = #S.ROW_ID
 from #Tasks,#S
 where #Tasks.TaskId=#S.TASKID

 --create temp table for SubSequences
 CREATE TABLE #SS (TASKID INT, ROW_ID INT,[SUB_SEQUENCE] INT)
 
 INSERT INTO #SS (TASKID,ROW_ID,[SUB_SEQUENCE]) 
 SELECT TASKID, Row_Number() over (order by [SUBSEQUENCE]),[SUBSEQUENCE] FROM #TASKS WHERE SubSequence IS NOT NULL

 update #Tasks set #Tasks.RowNo_Order = #SS.ROW_ID
 from #Tasks,#SS
 where #Tasks.TaskId=#SS.TASKID
 ----missing rows bug solution END: kapil pancholi

 -- fetch parent sequence records from temptable                  
 SELECT *                         
 FROM #Tasks                         
 WHERE                         
 (RowNo_Order >= @StartIndex AND                         
 (                        
  @PageSize = 0 OR                         
  RowNo_Order < (@StartIndex + @PageSize)                        
 ))      
 AND                 
 SubSequence IS NULL      
 --ORDER BY  [Sequence]  DESC                      
 ORDER BY CASE WHEN (TaskId = @HighLightedTaskID) THEN 0 ELSE 1 END , [Sequence] DESC
      
 -- fetch sub sequence records from temptable                  
 SELECT *                         
 FROM #Tasks                         
 WHERE                         
 (RowNo_Order >= @StartIndex AND                         
 (                        
  @PageSize = 0 OR                         
  RowNo_Order < (@StartIndex + @PageSize)                        
 ))      
 AND               
 SubSequence IS NOT NULL      
 --ORDER BY  [Sequence]  DESC                      
 ORDER BY CASE WHEN (TaskId = @HighLightedTaskID) THEN 0 ELSE 1 END, [Sequence] DESC
      
      
 --or              
 --(              
 -- TaskId = @HighLightedTaskID          
 --)                        
 --ORDER BY CASE WHEN (TaskId = @HighLightedTaskID) THEN 0 ELSE 1 END , [Sequence]  DESC                      
                        
 -- fetch other statistics, total records, total pages, pageindex to highlighted.                       
 SELECT                        
 COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex AS PageIndex                       
  FROM #Tasks  WHERE SubSequence IS NULL                 
                  
 DROP TABLE #Tasks                  
 DROP TABLE #S    
 DROP TABLE #SS 
                      
END 

GO

CREATE PROCEDURE [dbo].[usp_GetAllInProAssReqTaskWithSequence]                         
(                        
                       
 @PageIndex INT = 0,                         
 @PageSize INT =20,                  
 @DesignationIds VARCHAR(20) = NULL,                  
 @IsTechTask BIT = 0,                  
 @HighLightedTaskID BIGINT = NULL
)                        
As                        
BEGIN                        
                  
                  
IF( @DesignationIds = '' )                  
BEGIN                  
                  
 SET @DesignationIds = NULL                  
                  
END                  
                        
                        
;WITH                         
 Tasklist AS                        
 (                         
  SELECT DISTINCT TaskId ,[Status],[SequenceDesignationId],[Sequence], [SubSequence],                      
  Title,ParentTaskId,IsTechTask,ParentTaskTitle,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,  TaskDesignation,        
  [AdminStatus] , [TechLeadStatus], [OtherUserStatus],[AdminStatusUpdated],[TechLeadStatusUpdated],[OtherUserStatusUpdated],[AdminUserId],[TechLeadUserId],[OtherUserId],         
  AdminUserInstallId, AdminUserFirstName, AdminUserLastName,        
  TechLeadUserInstallId,ITLeadHours,UserHours, TechLeadUserFirstName, TechLeadUserLastName,        
  OtherUserInstallId, OtherUserFirstName,OtherUserLastName,TaskAssignedUserIDs,        
  case                         
   when (ParentTaskId is null and  TaskLevel=1) then InstallId                         
   when (tasklevel =1 and ParentTaskId>0) then                         
    (select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId                          
   when (tasklevel =2 and ParentTaskId>0) then                        
    (select InstallId from tbltask where taskid in (                        
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))                        
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId                         
                             
   when (tasklevel =3 and ParentTaskId>0) then                        
   (select InstallId from tbltask where taskid in (                        
   (select parenttaskid from tbltask where taskid in (                        
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))                        
   +'-'+                        
    (select InstallId from tbltask where taskid in (                        
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))                        
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId                         
  end as 'InstallId' ,Row_number() OVER (order by x.TaskId ) AS RowNo_Order                        
  from (                        
   select DISTINCT a.*                        
   ,(select Title from tbltask where TaskId=(select * from [GetParent](a.TaskId))) AS ParentTaskTitle,        
   (SELECT EstimatedHours FROM [dbo].[tblTaskApprovals] WHERE TaskId = a.TaskId AND UserId = a.TechLeadUserId) AS ITLeadHours , (SELECT EstimatedHours FROM [dbo].[tblTaskApprovals] WHERE TaskId = a.TaskId AND UserId = a.OtherUserId) AS UserHours,        
   ta.InstallId AS AdminUserInstallId, ta.FristName AS AdminUserFirstName, ta.LastName AS AdminUserLastName,        
   tT.InstallId AS TechLeadUserInstallId, tT.FristName AS TechLeadUserFirstName, tT.LastName AS TechLeadUserLastName,        
   tU.InstallId AS OtherUserInstallId, tU.FristName AS OtherUserFirstName, tU.LastName AS OtherUserLastName,        
   --,t.FristName + ' ' + t.LastName AS Assigneduser,                      
   (                      
   STUFF((SELECT ', {"Name": "' + Designation +'","Id":'+ CONVERT(VARCHAR(5),DesignationID)+'}'                    
           FROM tblTaskdesignations td                       
           WHERE td.TaskID = a.TaskId                       
          FOR XML PATH('')), 1, 2, '')                      
  )  AS TaskDesignation,    
  (    
    STUFF((SELECT ', {"Id" : "'+ CONVERT(VARCHAR(5),UserId) + '"}'                    
           FROM tbltaskassignedusers as tau    
           WHERE tau.TaskId = a.TaskId                       
          FOR XML PATH('')), 1, 2, '')                      
  ) AS TaskAssignedUserIDs             
  --(SELECT TOP 1 DesignationID                     
  --         FROM tblTaskdesignations td                       
  --         WHERE td.TaskID = a.TaskId ) AS DesignationId                     
   from  tbltask a                        
   --LEFT OUTER JOIN tblTaskdesignations as b ON a.TaskId = b.TaskId                         
   --LEFT OUTER JOIN tbltaskassignedusers as c ON a.TaskId = c.TaskId                        
   LEFT OUTER JOIN tblInstallUsers as ta ON a.[AdminUserId] = ta.Id         
   LEFT OUTER JOIN tblInstallUsers as tT ON a.[TechLeadUserId] = tT.Id         
   LEFT OUTER JOIN tblInstallUsers as tU ON a.[OtherUserId] = tU.Id     
  -- LEFT OUTER JOIN tbltaskassignedusers as tau ON a.TaskId = tau.TaskId                        
   WHERE                   
  (                 
    (a.[Sequence] IS NOT NULL)                   	
    AND (a.[SequenceDesignationId] IN (SELECT * FROM [dbo].[SplitString](ISNULL(@DesignationIds,a.[SequenceDesignationId]),',') ) )                   
    AND (ISNULL(a.[IsTechTask],@IsTechTask) = @IsTechTask) 
	AND a.[Status] in (1,2,3,4)
   )                   

   OR                  
   (                  
     a.TaskId = @HighLightedTaskID  AND IsTechTask = @IsTechTask                
   )                       
   --and (CreatedOn >=@startdate and CreatedOn <= @enddate )                         
  ) as x                        
 )              
                        
 ---- get CTE data into temp table                        
 SELECT *                        
 INTO #Tasks                        
 FROM Tasklist                        
                  
---- find page number to show taskid sent.                  
DECLARE @StartIndex INT  = 0                        
                  
                        
--IF @HighLightedTaskID  > 0                  
-- BEGIN                  
--  DECLARE @RowNumber BIGINT = NULL                  
                  
--  -- Find in which rownumber highlighter taskid is.                  
--  SELECT @RowNumber = RowNo_Order                   
--  FROM #Tasks                   
--  WHERE TaskId = @HighLightedTaskID                  
                  
--  -- if row number found then divide it with page size and round it to nearest integer , so will found pagenumber to be selected.                  
--  -- for ex. if total 60 records are there,pagesize is 20 and highlighted task id is at 42 row number than.                   
--  -- 42/20 = 2.1 ~ 3 - 1 = 2 = @Page Index                  
--  -- StartIndex = (2*20)+1 = 41, so records 41 to 60 will be fetched.                  
                     
--  IF @RowNumber IS NOT NULL                  
--  BEGIN                  
--   SELECT @PageIndex = (CEILING(@RowNumber / CAST(@PageSize AS FLOAT))) - 1                  
--  END                  
-- END                    
                  
 -- Set start index to fetch record.                  
 SET @StartIndex = (@PageIndex * @PageSize) + 1                        
                   
 ----missing rows bug solution BEGIN: kapil pancholi
 --create temp table for Sequences
 CREATE TABLE #S (TASKID INT, ROW_ID INT,[SEQUENCE] INT)
 
 INSERT INTO #S (TASKID,ROW_ID,[SEQUENCE]) 
 SELECT TASKID, Row_Number() over (order by [Sequence]),[SEQUENCE] FROM #TASKS WHERE SubSequence IS NULL

 update #Tasks set #Tasks.RowNo_Order = #S.ROW_ID
 from #Tasks,#S
 where #Tasks.TaskId=#S.TASKID

 --create temp table for SubSequences
 CREATE TABLE #SS (TASKID INT, ROW_ID INT,[SUB_SEQUENCE] INT)
 
 INSERT INTO #SS (TASKID,ROW_ID,[SUB_SEQUENCE]) 
 SELECT TASKID, Row_Number() over (order by [SUBSEQUENCE]),[SUBSEQUENCE] FROM #TASKS WHERE SubSequence IS NOT NULL

 update #Tasks set #Tasks.RowNo_Order = #SS.ROW_ID
 from #Tasks,#SS
 where #Tasks.TaskId=#SS.TASKID
 ----missing rows bug solution END: kapil pancholi

 -- fetch parent sequence records from temptable                  
 SELECT *                         
 FROM #Tasks                         
 WHERE                         
 (RowNo_Order >= @StartIndex AND                         
 (                        
  @PageSize = 0 OR                         
  RowNo_Order < (@StartIndex + @PageSize)                        
 ))      
 AND                 
 SubSequence IS NULL      
 --ORDER BY  [Sequence]  DESC                      
 ORDER BY CASE WHEN (TaskId = @HighLightedTaskID) THEN 0 ELSE 1 END, [Sequence]
      
 -- fetch sub sequence records from temptable                  
 SELECT *                         
 FROM #Tasks                         
 WHERE                         
 (RowNo_Order >= @StartIndex AND                         
 (                        
  @PageSize = 0 OR                         
  RowNo_Order < (@StartIndex + @PageSize)                        
 ))      
 AND               
 SubSequence IS NOT NULL      
 --ORDER BY  [Sequence]  DESC                      
 ORDER BY CASE WHEN (TaskId = @HighLightedTaskID) THEN 0 ELSE 1 END, [Sequence]
      
      
 --or              
 --(              
 -- TaskId = @HighLightedTaskID          
 --)                        
 --ORDER BY CASE WHEN (TaskId = @HighLightedTaskID) THEN 0 ELSE 1 END , [Sequence]  DESC                      
                        
 -- fetch other statistics, total records, total pages, pageindex to highlighted.                       
 SELECT                        
 COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex AS PageIndex                       
  FROM #Tasks  WHERE SubSequence IS NULL                 
                  
 DROP TABLE #Tasks                  
 DROP TABLE #S    
 DROP TABLE #SS 
                      
END 

GO

CREATE PROCEDURE [dbo].[usp_GetAllInProAssReqUserTaskWithSequence]                         
(                        
                       
 @PageIndex INT = 0,                         
 @PageSize INT =20,                                
 @UserId VARCHAR(MAX),               
 @IsTechTask BIT = 0         
)                        
As                        
BEGIN                                        
                        
                        
;WITH                         
 Tasklist AS                        
 (                         
  SELECT DISTINCT TaskId ,[Status],[SequenceDesignationId],[Sequence], [SubSequence],                      
  Title,ParentTaskId,IsTechTask,ParentTaskTitle,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,  TaskDesignation,        
  [AdminStatus] , [TechLeadStatus], [OtherUserStatus],[AdminStatusUpdated],[TechLeadStatusUpdated],[OtherUserStatusUpdated],[AdminUserId],[TechLeadUserId],[OtherUserId],         
  AdminUserInstallId, AdminUserFirstName, AdminUserLastName,        
  TechLeadUserInstallId,ITLeadHours,UserHours, TechLeadUserFirstName, TechLeadUserLastName,        
  OtherUserInstallId, OtherUserFirstName,OtherUserLastName,TaskAssignedUserIDs,        
  case                         
   when (ParentTaskId is null and  TaskLevel=1) then InstallId                         
   when (tasklevel =1 and ParentTaskId>0) then                         
    (select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId                          
   when (tasklevel =2 and ParentTaskId>0) then                        
    (select InstallId from tbltask where taskid in (                        
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))                        
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId                         
                             
   when (tasklevel =3 and ParentTaskId>0) then                        
   (select InstallId from tbltask where taskid in (                        
   (select parenttaskid from tbltask where taskid in (                        
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))                        
   +'-'+                        
    (select InstallId from tbltask where taskid in (                        
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))                        
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId                         
  end as 'InstallId' ,Row_number() OVER (order by x.TaskId ) AS RowNo_Order                        
  from (                        
   select DISTINCT a.*                        
   ,(select Title from tbltask where TaskId=(select * from [GetParent](a.TaskId))) AS ParentTaskTitle,        
   (SELECT EstimatedHours FROM [dbo].[tblTaskApprovals] WHERE TaskId = a.TaskId AND UserId = a.TechLeadUserId) AS ITLeadHours , (SELECT EstimatedHours FROM [dbo].[tblTaskApprovals] WHERE TaskId = a.TaskId AND UserId = a.OtherUserId) AS UserHours,        
   ta.InstallId AS AdminUserInstallId, ta.FristName AS AdminUserFirstName, ta.LastName AS AdminUserLastName,        
   tT.InstallId AS TechLeadUserInstallId, tT.FristName AS TechLeadUserFirstName, tT.LastName AS TechLeadUserLastName,        
   tU.InstallId AS OtherUserInstallId, tU.FristName AS OtherUserFirstName, tU.LastName AS OtherUserLastName,        
   --,t.FristName + ' ' + t.LastName AS Assigneduser,                      
   (                      
   STUFF((SELECT ', {"Name": "' + Designation +'","Id":'+ CONVERT(VARCHAR(5),DesignationID)+'}'                    
           FROM tblTaskdesignations td                       
           WHERE td.TaskID = a.TaskId                       
          FOR XML PATH('')), 1, 2, '')                      
  )  AS TaskDesignation,    
  (    
    STUFF((SELECT ', {"Id" : "'+ CONVERT(VARCHAR(5),UserId) + '"}'                    
           FROM tbltaskassignedusers as tau    
           WHERE tau.TaskId = a.TaskId                       
          FOR XML PATH('')), 1, 2, '')                      
  ) AS TaskAssignedUserIDs  
  ,
  tau.UserId as AssignedUserId
  --(SELECT TOP 1 DesignationID                     
  --         FROM tblTaskdesignations td                       
  --         WHERE td.TaskID = a.TaskId ) AS DesignationId                     
   from  tbltask a                        
   --LEFT OUTER JOIN tblTaskdesignations as b ON a.TaskId = b.TaskId                         
   --LEFT OUTER JOIN tbltaskassignedusers as c ON a.TaskId = c.TaskId                        
   LEFT OUTER JOIN tblInstallUsers as ta ON a.[AdminUserId] = ta.Id         
   LEFT OUTER JOIN tblInstallUsers as tT ON a.[TechLeadUserId] = tT.Id         
   LEFT OUTER JOIN tblInstallUsers as tU ON a.[OtherUserId] = tU.Id     
   JOIN tbltaskassignedusers as tau ON a.TaskId = tau.TaskId                        
   WHERE                   
  (                   
    (a.[Sequence] IS NOT NULL)                                 
    AND (ISNULL(a.[IsTechTask],@IsTechTask) = @IsTechTask)                  
	AND (tau.UserId in(select * from [dbo].[SplitString](@UserId,',')))
	AND (a.[Status] in (1,2,3,4))
   )                                         
   --and (CreatedOn >=@startdate and CreatedOn <= @enddate )                         
  ) as x                        
 )              
                        
 ---- get CTE data into temp table                        
 SELECT *                        
 INTO #Tasks                        
 FROM Tasklist                        
                  
---- find page number to show taskid sent.                  
DECLARE @StartIndex INT  = 0                        
                  
                        
--IF @HighLightedTaskID  > 0                  
-- BEGIN                  
--  DECLARE @RowNumber BIGINT = NULL                  
                  
--  -- Find in which rownumber highlighter taskid is.                  
--  SELECT @RowNumber = RowNo_Order                   
--  FROM #Tasks                   
--  WHERE TaskId = @HighLightedTaskID                  
                  
--  -- if row number found then divide it with page size and round it to nearest integer , so will found pagenumber to be selected.                  
--  -- for ex. if total 60 records are there,pagesize is 20 and highlighted task id is at 42 row number than.                   
--  -- 42/20 = 2.1 ~ 3 - 1 = 2 = @Page Index                  
--  -- StartIndex = (2*20)+1 = 41, so records 41 to 60 will be fetched.                  
                     
--  IF @RowNumber IS NOT NULL                  
--  BEGIN                  
--   SELECT @PageIndex = (CEILING(@RowNumber / CAST(@PageSize AS FLOAT))) - 1                  
--  END                  
-- END                    
                  
 -- Set start index to fetch record.                  
 SET @StartIndex = (@PageIndex * @PageSize) + 1                        

 ----missing rows bug solution BEGIN: kapil pancholi
 --create temp table for Sequences
 CREATE TABLE #S (TASKID INT, ROW_ID INT,[SEQUENCE] INT)
 
 INSERT INTO #S (TASKID,ROW_ID,[SEQUENCE]) 
 SELECT TASKID, Row_Number() over (order by [Sequence]),[SEQUENCE] FROM #TASKS WHERE SubSequence IS NULL

 update #Tasks set #Tasks.RowNo_Order = #S.ROW_ID
 from #Tasks,#S
 where #Tasks.TaskId=#S.TASKID

 --create temp table for SubSequences
 CREATE TABLE #SS (TASKID INT, ROW_ID INT,[SUB_SEQUENCE] INT)
 
 INSERT INTO #SS (TASKID,ROW_ID,[SUB_SEQUENCE]) 
 SELECT TASKID, Row_Number() over (order by [SUBSEQUENCE]),[SUBSEQUENCE] FROM #TASKS WHERE SubSequence IS NOT NULL

 update #Tasks set #Tasks.RowNo_Order = #SS.ROW_ID
 from #Tasks,#SS
 where #Tasks.TaskId=#SS.TASKID
 ----missing rows bug solution END: kapil pancholi

 -- fetch parent sequence records from temptable                  
 SELECT *                         
 FROM #Tasks                         
 WHERE                         
 (RowNo_Order >= @StartIndex AND                         
 (                        
  @PageSize = 0 OR                         
  RowNo_Order < (@StartIndex + @PageSize)                        
 ))      
 AND                 
 SubSequence IS NULL      
 --ORDER BY  [Sequence]  DESC                      
 ORDER BY [Sequence]  ASC                      
      
 -- fetch sub sequence records from temptable                  
 SELECT *                         
 FROM #Tasks                         
 WHERE                         
 (RowNo_Order >= @StartIndex AND                         
 (                        
  @PageSize = 0 OR                         
  RowNo_Order < (@StartIndex + @PageSize)                        
 ))      
 AND               
 SubSequence IS NOT NULL      
 --ORDER BY  [Sequence]  DESC                      
 ORDER BY [SubSequence]  ASC
      
      
 --or              
 --(              
 -- TaskId = @HighLightedTaskID          
 --)                        
 --ORDER BY CASE WHEN (TaskId = @HighLightedTaskID) THEN 0 ELSE 1 END , [Sequence]  DESC                      
                        
 -- fetch other statistics, total records, total pages, pageindex to highlighted.                       
 SELECT                        
 COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex AS PageIndex                       
  FROM #Tasks  WHERE SubSequence IS NULL                 
                  
 DROP TABLE #Tasks                  
 DROP TABLE #S    
 DROP TABLE #SS   
                      
END 

GO
ALTER PROCEDURE [dbo].[GetClosedTasks] 
	-- Add the parameters for the stored procedure here
	--@userid int,
	@userid nvarchar(MAX)='0',
	@desigid nvarchar(MAX)='',
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
			from dbo.tblTask as a
			Left Join tbltaskassignedusers as b ON a.TaskId=b.TaskId
				Left Join tblInstallUsers as t ON b.UserId=t.Id
			where a.[Status]  in (7,8,9,10,11,12,14)
			AND  (
			t.FristName LIKE '%'+ @search + '%'  or
			t.LastName LIKE '%'+ @search + '%'  or
			t.Email LIKE '%' + @search +'%'  
			) 
			and parenttaskid is not null
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
		COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex AS PageIndex 
		FROM #temp1

		end
   else if @userid='0' and @desigid=''
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
			from dbo.tblTask  as a
			LEFT OUTER JOIN tbltaskassignedusers as b ON a.TaskId = b.TaskId
			LEFT OUTER JOIN tblInstallUsers as t ON t.Id = b.UserId
			where a.[Status]  in (7,8,9,10,11,12,14)
			 and a.parenttaskid is not null
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
		COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex AS PageIndex 
		FROM #temp2

		end
	else if @userid<>'0'  
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
			from dbo.tblTask as a
			left outer join tbltaskassignedusers as b on a.TaskId=b.TaskId
			LEFT OUTER JOIN tblInstallUsers as t ON t.Id = b.UserId
			where a.[Status]  in (7,8,9,10,11,12,14) and b.UserId in (select * from [dbo].[SplitString](@userid,','))
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
		COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex AS PageIndex 
		FROM #temp3

		end
	else if @userid='0' and @desigid<>''
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
			Title,[Hours],a.InstallId,ParentTaskId,TaskLevel, t.FristName + ' ' + t.LastName AS Assigneduser
			from dbo.tblTask as a 
			LEFT JOIN tbltaskassignedusers as c ON a.TaskId = c.TaskId
			LEFT JOIN tblTaskdesignations as b ON b.TaskId = c.TaskId
			LEFT JOIN tblInstallUsers as t ON t.Id = c.UserId
			where a.[Status]  in (7,8,9,10,11,12,14)  and b.DesignationID in (select * from [dbo].[SplitString](@desigid,',')) 
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
		COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex AS PageIndex 
		FROM #temp4

		end
END

GO
--END

--FOR FROZEN/NON FROZEN POPUP/Sequencing popup issues 
CREATE PROCEDURE [dbo].[usp_GetAllNonFrozenTaskWithSequence]                         
(                        
                       
 @PageIndex INT = 0,                         
 @PageSize INT =20,                  
 @DesignationIds VARCHAR(20) = NULL,                  
 @IsTechTask BIT = 0
)                        
As                        
BEGIN                        
                  
                  
IF( @DesignationIds = '' )                  
BEGIN                  
                  
 SET @DesignationIds = NULL                  
                  
END                  
                        
                        
;WITH                         
 Tasklist AS                        
 (                         
  SELECT DISTINCT TaskId ,[Status],[SequenceDesignationId],[Sequence], [SubSequence],                      
  Title,ParentTaskId,IsTechTask,ParentTaskTitle,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,  TaskDesignation,        
  [AdminStatus] , [TechLeadStatus], [OtherUserStatus],[AdminStatusUpdated],[TechLeadStatusUpdated],[OtherUserStatusUpdated],[AdminUserId],[TechLeadUserId],[OtherUserId],         
  AdminUserInstallId, AdminUserFirstName, AdminUserLastName,        
  TechLeadUserInstallId,ITLeadHours,UserHours, TechLeadUserFirstName, TechLeadUserLastName,        
  OtherUserInstallId, OtherUserFirstName,OtherUserLastName,TaskAssignedUserIDs,        
  case                         
   when (ParentTaskId is null and  TaskLevel=1) then InstallId                         
   when (tasklevel =1 and ParentTaskId>0) then                         
    (select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId                          
   when (tasklevel =2 and ParentTaskId>0) then                        
    (select InstallId from tbltask where taskid in (                        
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))                        
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId                         
                             
   when (tasklevel =3 and ParentTaskId>0) then                        
   (select InstallId from tbltask where taskid in (                        
   (select parenttaskid from tbltask where taskid in (                        
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))                        
   +'-'+                        
    (select InstallId from tbltask where taskid in (                        
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))                        
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId                         
  end as 'InstallId' ,Row_number() OVER (order by x.TaskId ) AS RowNo_Order                        
  from (                        
   select DISTINCT a.*                        
   ,(select Title from tbltask where TaskId=(select * from [GetParent](a.TaskId))) AS ParentTaskTitle,        
   (SELECT EstimatedHours FROM [dbo].[tblTaskApprovals] WHERE TaskId = a.TaskId AND UserId = a.TechLeadUserId) AS ITLeadHours , (SELECT EstimatedHours FROM [dbo].[tblTaskApprovals] WHERE TaskId = a.TaskId AND UserId = a.OtherUserId) AS UserHours,        
   ta.InstallId AS AdminUserInstallId, ta.FristName AS AdminUserFirstName, ta.LastName AS AdminUserLastName,        
   tT.InstallId AS TechLeadUserInstallId, tT.FristName AS TechLeadUserFirstName, tT.LastName AS TechLeadUserLastName,        
   tU.InstallId AS OtherUserInstallId, tU.FristName AS OtherUserFirstName, tU.LastName AS OtherUserLastName,        
   --,t.FristName + ' ' + t.LastName AS Assigneduser,                      
   (                      
   STUFF((SELECT ', {"Name": "' + Designation +'","Id":'+ CONVERT(VARCHAR(5),DesignationID)+'}'                    
           FROM tblTaskdesignations td                       
           WHERE td.TaskID = a.TaskId                       
          FOR XML PATH('')), 1, 2, '')                      
  )  AS TaskDesignation,    
  (    
    STUFF((SELECT ', {"Id" : "'+ CONVERT(VARCHAR(5),UserId) + '"}'                    
           FROM tbltaskassignedusers as tau    
           WHERE tau.TaskId = a.TaskId                       
          FOR XML PATH('')), 1, 2, '')                      
  ) AS TaskAssignedUserIDs             
  --(SELECT TOP 1 DesignationID                     
  --         FROM tblTaskdesignations td                       
  --         WHERE td.TaskID = a.TaskId ) AS DesignationId                     
   from  tbltask a                        
   --LEFT OUTER JOIN tblTaskdesignations as b ON a.TaskId = b.TaskId                         
   --LEFT OUTER JOIN tbltaskassignedusers as c ON a.TaskId = c.TaskId                        
   LEFT OUTER JOIN tblInstallUsers as ta ON a.[AdminUserId] = ta.Id         
   LEFT OUTER JOIN tblInstallUsers as tT ON a.[TechLeadUserId] = tT.Id         
   LEFT OUTER JOIN tblInstallUsers as tU ON a.[OtherUserId] = tU.Id     
  -- LEFT OUTER JOIN tbltaskassignedusers as tau ON a.TaskId = tau.TaskId                        
   WHERE                   
  (                 
    (a.[Sequence] IS NOT NULL)                   	
    AND (a.[SequenceDesignationId] IN (SELECT * FROM [dbo].[SplitString](ISNULL(@DesignationIds,a.[SequenceDesignationId]),',') ) )                   
    AND (ISNULL(a.[IsTechTask],@IsTechTask) = @IsTechTask)
	AND (a.AdminStatus = 0 AND a.TechLeadStatus = 0 AND a.OtherUserStatus = 0)
  )                                       
   --and (CreatedOn >=@startdate and CreatedOn <= @enddate )                         
  ) as x                        
 )              
                        
 ---- get CTE data into temp table                        
 SELECT *                        
 INTO #Tasks                        
 FROM Tasklist                        
                  
---- find page number to show taskid sent.                  
DECLARE @StartIndex INT  = 0                        
                  
                        
--IF @HighLightedTaskID  > 0                  
-- BEGIN                  
--  DECLARE @RowNumber BIGINT = NULL                  
                  
--  -- Find in which rownumber highlighter taskid is.                  
--  SELECT @RowNumber = RowNo_Order                   
--  FROM #Tasks                   
--  WHERE TaskId = @HighLightedTaskID                  
                  
--  -- if row number found then divide it with page size and round it to nearest integer , so will found pagenumber to be selected.                  
--  -- for ex. if total 60 records are there,pagesize is 20 and highlighted task id is at 42 row number than.                   
--  -- 42/20 = 2.1 ~ 3 - 1 = 2 = @Page Index                  
--  -- StartIndex = (2*20)+1 = 41, so records 41 to 60 will be fetched.                  
                     
--  IF @RowNumber IS NOT NULL                  
--  BEGIN                  
--   SELECT @PageIndex = (CEILING(@RowNumber / CAST(@PageSize AS FLOAT))) - 1                  
--  END                  
-- END                    
                  
 -- Set start index to fetch record.                  
 SET @StartIndex = (@PageIndex * @PageSize) + 1                        

 ----missing rows bug solution BEGIN: kapil pancholi
 --create temp table for Sequences
 CREATE TABLE #S (TASKID INT, ROW_ID INT,[SEQUENCE] INT)
 
 INSERT INTO #S (TASKID,ROW_ID,[SEQUENCE]) 
 SELECT TASKID, Row_Number() over (order by [Sequence]),[SEQUENCE] FROM #TASKS WHERE SubSequence IS NULL

 update #Tasks set #Tasks.RowNo_Order = #S.ROW_ID
 from #Tasks,#S
 where #Tasks.TaskId=#S.TASKID

 --create temp table for SubSequences
 CREATE TABLE #SS (TASKID INT, ROW_ID INT,[SUB_SEQUENCE] INT)
 
 INSERT INTO #SS (TASKID,ROW_ID,[SUB_SEQUENCE]) 
 SELECT TASKID, Row_Number() over (order by [SUBSEQUENCE]),[SUBSEQUENCE] FROM #TASKS WHERE SubSequence IS NOT NULL

 update #Tasks set #Tasks.RowNo_Order = #SS.ROW_ID
 from #Tasks,#SS
 where #Tasks.TaskId=#SS.TASKID
 ----missing rows bug solution END: kapil pancholi

 -- fetch parent sequence records from temptable                  
 SELECT *                         
 FROM #Tasks                         
 WHERE                         
 (RowNo_Order >= @StartIndex AND                         
 (                        
  @PageSize = 0 OR                         
  RowNo_Order < (@StartIndex + @PageSize)                        
 ))      
 AND                 
 SubSequence IS NULL      
 --ORDER BY  [Sequence]  DESC                      
 ORDER BY [Sequence]
      
 -- fetch sub sequence records from temptable                  
 SELECT *                         
 FROM #Tasks                         
 WHERE                         
 (RowNo_Order >= @StartIndex AND                         
 (                        
  @PageSize = 0 OR                         
  RowNo_Order < (@StartIndex + @PageSize)                        
 ))      
 AND               
 SubSequence IS NOT NULL      
 --ORDER BY  [Sequence]  DESC                      
 ORDER BY [Sequence]
      
      
 --or              
 --(              
 -- TaskId = @HighLightedTaskID          
 --)                        
 --ORDER BY CASE WHEN (TaskId = @HighLightedTaskID) THEN 0 ELSE 1 END , [Sequence]  DESC                      
                        
 -- fetch other statistics, total records, total pages, pageindex to highlighted.                       
 SELECT                        
 COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex AS PageIndex                       
  FROM #Tasks  WHERE SubSequence IS NULL                 
                  
 DROP TABLE #Tasks                  
 DROP TABLE #S    
 DROP TABLE #SS             
                      
END 

GO

CREATE PROCEDURE [dbo].[usp_GetAllNonFrozenUserTaskWithSequence]                         
(                        
                       
 @PageIndex INT = 0,                         
 @PageSize INT =20,                  
 @UserId varchar(max) = '0',                  
 @IsTechTask BIT = 0
)                        
As                        
BEGIN                        
                  
                             
                        
                        
;WITH                         
 Tasklist AS                        
 (                         
  SELECT DISTINCT TaskId ,[Status],[SequenceDesignationId],[Sequence], [SubSequence],                      
  Title,ParentTaskId,IsTechTask,ParentTaskTitle,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,  TaskDesignation,        
  [AdminStatus] , [TechLeadStatus], [OtherUserStatus],[AdminStatusUpdated],[TechLeadStatusUpdated],[OtherUserStatusUpdated],[AdminUserId],[TechLeadUserId],[OtherUserId],         
  AdminUserInstallId, AdminUserFirstName, AdminUserLastName,        
  TechLeadUserInstallId,ITLeadHours,UserHours, TechLeadUserFirstName, TechLeadUserLastName,        
  OtherUserInstallId, OtherUserFirstName,OtherUserLastName,TaskAssignedUserIDs,        
  case                         
   when (ParentTaskId is null and  TaskLevel=1) then InstallId                         
   when (tasklevel =1 and ParentTaskId>0) then                         
    (select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId                          
   when (tasklevel =2 and ParentTaskId>0) then                        
    (select InstallId from tbltask where taskid in (                        
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))                        
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId                         
                             
   when (tasklevel =3 and ParentTaskId>0) then                        
   (select InstallId from tbltask where taskid in (                        
   (select parenttaskid from tbltask where taskid in (                        
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))                        
   +'-'+                        
    (select InstallId from tbltask where taskid in (                        
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))                        
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId                         
  end as 'InstallId' ,Row_number() OVER (order by x.TaskId ) AS RowNo_Order                        
  from (                        
   select DISTINCT a.*                        
   ,(select Title from tbltask where TaskId=(select * from [GetParent](a.TaskId))) AS ParentTaskTitle,        
   (SELECT EstimatedHours FROM [dbo].[tblTaskApprovals] WHERE TaskId = a.TaskId AND UserId = a.TechLeadUserId) AS ITLeadHours , (SELECT EstimatedHours FROM [dbo].[tblTaskApprovals] WHERE TaskId = a.TaskId AND UserId = a.OtherUserId) AS UserHours,        
   ta.InstallId AS AdminUserInstallId, ta.FristName AS AdminUserFirstName, ta.LastName AS AdminUserLastName,        
   tT.InstallId AS TechLeadUserInstallId, tT.FristName AS TechLeadUserFirstName, tT.LastName AS TechLeadUserLastName,        
   tU.InstallId AS OtherUserInstallId, tU.FristName AS OtherUserFirstName, tU.LastName AS OtherUserLastName,        
   --,t.FristName + ' ' + t.LastName AS Assigneduser,                      
   (                      
   STUFF((SELECT ', {"Name": "' + Designation +'","Id":'+ CONVERT(VARCHAR(5),DesignationID)+'}'                    
           FROM tblTaskdesignations td                       
           WHERE td.TaskID = a.TaskId                       
          FOR XML PATH('')), 1, 2, '')                      
  )  AS TaskDesignation,    
  (    
    STUFF((SELECT ', {"Id" : "'+ CONVERT(VARCHAR(5),UserId) + '"}'                    
           FROM tbltaskassignedusers as tau    
           WHERE tau.TaskId = a.TaskId                       
          FOR XML PATH('')), 1, 2, '')                      
  ) AS TaskAssignedUserIDs             
  --(SELECT TOP 1 DesignationID                     
  --         FROM tblTaskdesignations td                       
  --         WHERE td.TaskID = a.TaskId ) AS DesignationId                     
   from  tbltask a                        
   --LEFT OUTER JOIN tblTaskdesignations as b ON a.TaskId = b.TaskId                         
   --LEFT OUTER JOIN tbltaskassignedusers as c ON a.TaskId = c.TaskId                        
   LEFT OUTER JOIN tblInstallUsers as ta ON a.[AdminUserId] = ta.Id         
   LEFT OUTER JOIN tblInstallUsers as tT ON a.[TechLeadUserId] = tT.Id         
   LEFT OUTER JOIN tblInstallUsers as tU ON a.[OtherUserId] = tU.Id     
   JOIN tbltaskassignedusers as tau ON a.TaskId = tau.TaskId                        
   WHERE                   
  (                 
    (a.[Sequence] IS NOT NULL)                   	                
    AND (ISNULL(a.[IsTechTask],@IsTechTask) = @IsTechTask)
	AND (a.AdminStatus = 0 AND a.TechLeadStatus = 0 AND a.OtherUserStatus = 0)
	AND (tau.UserId in (select * from [dbo].[SplitString](@UserId,',')))
  )                                       
   --and (CreatedOn >=@startdate and CreatedOn <= @enddate )                         
  ) as x                        
 )              
                        
 ---- get CTE data into temp table                        
 SELECT *                        
 INTO #Tasks                        
 FROM Tasklist                        
                  
---- find page number to show taskid sent.                  
DECLARE @StartIndex INT  = 0                        
                  
                        
--IF @HighLightedTaskID  > 0                  
-- BEGIN                  
--  DECLARE @RowNumber BIGINT = NULL                  
                  
--  -- Find in which rownumber highlighter taskid is.                  
--  SELECT @RowNumber = RowNo_Order                   
--  FROM #Tasks                   
--  WHERE TaskId = @HighLightedTaskID                  
                  
--  -- if row number found then divide it with page size and round it to nearest integer , so will found pagenumber to be selected.                  
--  -- for ex. if total 60 records are there,pagesize is 20 and highlighted task id is at 42 row number than.                   
--  -- 42/20 = 2.1 ~ 3 - 1 = 2 = @Page Index                  
--  -- StartIndex = (2*20)+1 = 41, so records 41 to 60 will be fetched.                  
                     
--  IF @RowNumber IS NOT NULL                  
--  BEGIN                  
--   SELECT @PageIndex = (CEILING(@RowNumber / CAST(@PageSize AS FLOAT))) - 1                  
--  END                  
-- END                    
                  
 -- Set start index to fetch record.                  
 SET @StartIndex = (@PageIndex * @PageSize) + 1                        

 ----missing rows bug solution BEGIN: kapil pancholi
 --create temp table for Sequences
 CREATE TABLE #S (TASKID INT, ROW_ID INT,[SEQUENCE] INT)
 
 INSERT INTO #S (TASKID,ROW_ID,[SEQUENCE]) 
 SELECT TASKID, Row_Number() over (order by [Sequence]),[SEQUENCE] FROM #TASKS WHERE SubSequence IS NULL

 update #Tasks set #Tasks.RowNo_Order = #S.ROW_ID
 from #Tasks,#S
 where #Tasks.TaskId=#S.TASKID

 --create temp table for SubSequences
 CREATE TABLE #SS (TASKID INT, ROW_ID INT,[SUB_SEQUENCE] INT)
 
 INSERT INTO #SS (TASKID,ROW_ID,[SUB_SEQUENCE]) 
 SELECT TASKID, Row_Number() over (order by [SUBSEQUENCE]),[SUBSEQUENCE] FROM #TASKS WHERE SubSequence IS NOT NULL

 update #Tasks set #Tasks.RowNo_Order = #SS.ROW_ID
 from #Tasks,#SS
 where #Tasks.TaskId=#SS.TASKID
 ----missing rows bug solution END: kapil pancholi

 -- fetch parent sequence records from temptable                  
 SELECT *                         
 FROM #Tasks                         
 WHERE                         
 (RowNo_Order >= @StartIndex AND                         
 (                        
  @PageSize = 0 OR                         
  RowNo_Order < (@StartIndex + @PageSize)                        
 ))      
 AND                 
 SubSequence IS NULL      
 --ORDER BY  [Sequence]  DESC                      
 ORDER BY [Sequence]
      
 -- fetch sub sequence records from temptable                  
 SELECT *                         
 FROM #Tasks                         
 WHERE                         
 (RowNo_Order >= @StartIndex AND                         
 (                        
  @PageSize = 0 OR                         
  RowNo_Order < (@StartIndex + @PageSize)                        
 ))      
 AND               
 SubSequence IS NOT NULL      
 --ORDER BY  [Sequence]  DESC                      
 ORDER BY [Sequence]
      
      
 --or              
 --(              
 -- TaskId = @HighLightedTaskID          
 --)                        
 --ORDER BY CASE WHEN (TaskId = @HighLightedTaskID) THEN 0 ELSE 1 END , [Sequence]  DESC                      
                        
 -- fetch other statistics, total records, total pages, pageindex to highlighted.                       
 SELECT                        
 COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex AS PageIndex                       
  FROM #Tasks  WHERE SubSequence IS NULL                 
                  
 DROP TABLE #Tasks                  
 DROP TABLE #S    
 DROP TABLE #SS         
                      
END 

GO

CREATE PROCEDURE [dbo].[usp_GetAllPartialFrozenTaskWithSequence]                        
(                        
                       
 @PageIndex INT = 0,                         
 @PageSize INT =20,                  
 @DesignationIds VARCHAR(20) = NULL,                  
 @IsTechTask BIT = 0
)                        
As                        
BEGIN                        
                  
                  
IF( @DesignationIds = '' )                  
BEGIN                  
                  
 SET @DesignationIds = NULL                  
                  
END                  
                        
                        
;WITH                         
 Tasklist AS                        
 (                         
  SELECT DISTINCT TaskId ,[Status],[SequenceDesignationId],[Sequence], [SubSequence],                      
  Title,ParentTaskId,IsTechTask,ParentTaskTitle,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,  TaskDesignation,        
  [AdminStatus] , [TechLeadStatus], [OtherUserStatus],[AdminStatusUpdated],[TechLeadStatusUpdated],[OtherUserStatusUpdated],[AdminUserId],[TechLeadUserId],[OtherUserId],         
  AdminUserInstallId, AdminUserFirstName, AdminUserLastName,        
  TechLeadUserInstallId,ITLeadHours,UserHours, TechLeadUserFirstName, TechLeadUserLastName,        
  OtherUserInstallId, OtherUserFirstName,OtherUserLastName,TaskAssignedUserIDs,        
  case                         
   when (ParentTaskId is null and  TaskLevel=1) then InstallId                         
   when (tasklevel =1 and ParentTaskId>0) then                         
    (select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId                          
   when (tasklevel =2 and ParentTaskId>0) then                        
    (select InstallId from tbltask where taskid in (                        
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))                        
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId                         
                             
   when (tasklevel =3 and ParentTaskId>0) then                        
   (select InstallId from tbltask where taskid in (                        
   (select parenttaskid from tbltask where taskid in (                        
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))                        
   +'-'+                        
    (select InstallId from tbltask where taskid in (                        
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))                        
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId                         
  end as 'InstallId' ,Row_number() OVER (order by x.TaskId ) AS RowNo_Order                        
  from (                        
   select DISTINCT a.*                        
   ,(select Title from tbltask where TaskId=(select * from [GetParent](a.TaskId))) AS ParentTaskTitle,        
   (SELECT EstimatedHours FROM [dbo].[tblTaskApprovals] WHERE TaskId = a.TaskId AND UserId = a.TechLeadUserId) AS ITLeadHours , (SELECT EstimatedHours FROM [dbo].[tblTaskApprovals] WHERE TaskId = a.TaskId AND UserId = a.OtherUserId) AS UserHours,        
   ta.InstallId AS AdminUserInstallId, ta.FristName AS AdminUserFirstName, ta.LastName AS AdminUserLastName,        
   tT.InstallId AS TechLeadUserInstallId, tT.FristName AS TechLeadUserFirstName, tT.LastName AS TechLeadUserLastName,        
   tU.InstallId AS OtherUserInstallId, tU.FristName AS OtherUserFirstName, tU.LastName AS OtherUserLastName,        
   --,t.FristName + ' ' + t.LastName AS Assigneduser,                      
   (                      
   STUFF((SELECT ', {"Name": "' + Designation +'","Id":'+ CONVERT(VARCHAR(5),DesignationID)+'}'                    
           FROM tblTaskdesignations td                       
           WHERE td.TaskID = a.TaskId                       
          FOR XML PATH('')), 1, 2, '')                      
  )  AS TaskDesignation,    
  (    
    STUFF((SELECT ', {"Id" : "'+ CONVERT(VARCHAR(5),UserId) + '"}'                    
           FROM tbltaskassignedusers as tau    
           WHERE tau.TaskId = a.TaskId                       
          FOR XML PATH('')), 1, 2, '')                      
  ) AS TaskAssignedUserIDs             
  --(SELECT TOP 1 DesignationID                     
  --         FROM tblTaskdesignations td                       
  --         WHERE td.TaskID = a.TaskId ) AS DesignationId                     
   from  tbltask a                        
   --LEFT OUTER JOIN tblTaskdesignations as b ON a.TaskId = b.TaskId                         
   --LEFT OUTER JOIN tbltaskassignedusers as c ON a.TaskId = c.TaskId                        
   LEFT OUTER JOIN tblInstallUsers as ta ON a.[AdminUserId] = ta.Id         
   LEFT OUTER JOIN tblInstallUsers as tT ON a.[TechLeadUserId] = tT.Id         
   LEFT OUTER JOIN tblInstallUsers as tU ON a.[OtherUserId] = tU.Id     
  -- LEFT OUTER JOIN tbltaskassignedusers as tau ON a.TaskId = tau.TaskId                        
   WHERE                   
  (                 
    (a.[Sequence] IS NOT NULL)                   	
    AND (a.[SequenceDesignationId] IN (SELECT * FROM [dbo].[SplitString](ISNULL(@DesignationIds,a.[SequenceDesignationId]),',') ) )                   
    AND (ISNULL(a.[IsTechTask],@IsTechTask) = @IsTechTask) 
	AND (a.AdminStatus = 1 OR a.TechLeadStatus = 1 OR a.OtherUserStatus = 1)
  )                   

                         
   --and (CreatedOn >=@startdate and CreatedOn <= @enddate )                         
  ) as x                        
 )              
                        
 ---- get CTE data into temp table                        
 SELECT *                        
 INTO #Tasks                        
 FROM Tasklist                        
                  
---- find page number to show taskid sent.                  
DECLARE @StartIndex INT  = 0                        
                  
                        
--IF @HighLightedTaskID  > 0                  
-- BEGIN                  
--  DECLARE @RowNumber BIGINT = NULL                  
                  
--  -- Find in which rownumber highlighter taskid is.                  
--  SELECT @RowNumber = RowNo_Order                   
--  FROM #Tasks                   
--  WHERE TaskId = @HighLightedTaskID                  
                  
--  -- if row number found then divide it with page size and round it to nearest integer , so will found pagenumber to be selected.                  
--  -- for ex. if total 60 records are there,pagesize is 20 and highlighted task id is at 42 row number than.                   
--  -- 42/20 = 2.1 ~ 3 - 1 = 2 = @Page Index                  
--  -- StartIndex = (2*20)+1 = 41, so records 41 to 60 will be fetched.                  
                     
--  IF @RowNumber IS NOT NULL                  
--  BEGIN                  
--   SELECT @PageIndex = (CEILING(@RowNumber / CAST(@PageSize AS FLOAT))) - 1                  
--  END                  
-- END                    
                  
 -- Set start index to fetch record.                  
 SET @StartIndex = (@PageIndex * @PageSize) + 1                        

 ----missing rows bug solution BEGIN: kapil pancholi
 --create temp table for Sequences
 CREATE TABLE #S (TASKID INT, ROW_ID INT,[SEQUENCE] INT)
 
 INSERT INTO #S (TASKID,ROW_ID,[SEQUENCE]) 
 SELECT TASKID, Row_Number() over (order by [Sequence]),[SEQUENCE] FROM #TASKS WHERE SubSequence IS NULL

 update #Tasks set #Tasks.RowNo_Order = #S.ROW_ID
 from #Tasks,#S
 where #Tasks.TaskId=#S.TASKID

 --create temp table for SubSequences
 CREATE TABLE #SS (TASKID INT, ROW_ID INT,[SUB_SEQUENCE] INT)
 
 INSERT INTO #SS (TASKID,ROW_ID,[SUB_SEQUENCE]) 
 SELECT TASKID, Row_Number() over (order by [SUBSEQUENCE]),[SUBSEQUENCE] FROM #TASKS WHERE SubSequence IS NOT NULL

 update #Tasks set #Tasks.RowNo_Order = #SS.ROW_ID
 from #Tasks,#SS
 where #Tasks.TaskId=#SS.TASKID
 ----missing rows bug solution END: kapil pancholi

 -- fetch parent sequence records from temptable                  
 SELECT *                         
 FROM #Tasks                         
 WHERE                         
 (RowNo_Order >= @StartIndex AND                         
 (                        
  @PageSize = 0 OR                         
  RowNo_Order < (@StartIndex + @PageSize)                        
 ))      
 AND                 
 SubSequence IS NULL      
 --ORDER BY  [Sequence]  DESC                      
 ORDER BY [Sequence]
      
 -- fetch sub sequence records from temptable                  
 SELECT *                         
 FROM #Tasks                         
 WHERE                         
 (RowNo_Order >= @StartIndex AND                         
 (                        
  @PageSize = 0 OR                         
  RowNo_Order < (@StartIndex + @PageSize)                        
 ))      
 AND               
 SubSequence IS NOT NULL      
 --ORDER BY  [Sequence]  DESC                      
 ORDER BY [Sequence]
      
      
 --or              
 --(              
 -- TaskId = @HighLightedTaskID          
 --)                        
 --ORDER BY CASE WHEN (TaskId = @HighLightedTaskID) THEN 0 ELSE 1 END , [Sequence]  DESC                      
                        
 -- fetch other statistics, total records, total pages, pageindex to highlighted.                       
 SELECT                        
 COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex AS PageIndex                       
  FROM #Tasks  WHERE SubSequence IS NULL                 
                  
 DROP TABLE #Tasks                  
 DROP TABLE #S    
 DROP TABLE #SS 
                      
END 

GO

CREATE PROCEDURE [dbo].[usp_GetAllPartialFrozenUserTaskWithSequence]                        
(                        
                       
 @PageIndex INT = 0,                         
 @PageSize INT =20,                  
 @UserId varchar(max) = '0',                  
 @IsTechTask BIT = 0
)                        
As                        
BEGIN                                        
                        
                        
;WITH                         
 Tasklist AS                        
 (                         
  SELECT DISTINCT TaskId ,[Status],[SequenceDesignationId],[Sequence], [SubSequence],                      
  Title,ParentTaskId,IsTechTask,ParentTaskTitle,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,  TaskDesignation,        
  [AdminStatus] , [TechLeadStatus], [OtherUserStatus],[AdminStatusUpdated],[TechLeadStatusUpdated],[OtherUserStatusUpdated],[AdminUserId],[TechLeadUserId],[OtherUserId],         
  AdminUserInstallId, AdminUserFirstName, AdminUserLastName,        
  TechLeadUserInstallId,ITLeadHours,UserHours, TechLeadUserFirstName, TechLeadUserLastName,        
  OtherUserInstallId, OtherUserFirstName,OtherUserLastName,TaskAssignedUserIDs,        
  case                         
   when (ParentTaskId is null and  TaskLevel=1) then InstallId                         
   when (tasklevel =1 and ParentTaskId>0) then                         
    (select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId                          
   when (tasklevel =2 and ParentTaskId>0) then                        
    (select InstallId from tbltask where taskid in (                        
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))                        
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId                         
                             
   when (tasklevel =3 and ParentTaskId>0) then                        
   (select InstallId from tbltask where taskid in (                        
   (select parenttaskid from tbltask where taskid in (                        
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))                        
   +'-'+                        
    (select InstallId from tbltask where taskid in (                        
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))                        
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId                         
  end as 'InstallId' ,Row_number() OVER (order by x.TaskId ) AS RowNo_Order                        
  from (                        
   select DISTINCT a.*                        
   ,(select Title from tbltask where TaskId=(select * from [GetParent](a.TaskId))) AS ParentTaskTitle,        
   (SELECT EstimatedHours FROM [dbo].[tblTaskApprovals] WHERE TaskId = a.TaskId AND UserId = a.TechLeadUserId) AS ITLeadHours , (SELECT EstimatedHours FROM [dbo].[tblTaskApprovals] WHERE TaskId = a.TaskId AND UserId = a.OtherUserId) AS UserHours,        
   ta.InstallId AS AdminUserInstallId, ta.FristName AS AdminUserFirstName, ta.LastName AS AdminUserLastName,        
   tT.InstallId AS TechLeadUserInstallId, tT.FristName AS TechLeadUserFirstName, tT.LastName AS TechLeadUserLastName,        
   tU.InstallId AS OtherUserInstallId, tU.FristName AS OtherUserFirstName, tU.LastName AS OtherUserLastName,        
   --,t.FristName + ' ' + t.LastName AS Assigneduser,                      
   (                      
   STUFF((SELECT ', {"Name": "' + Designation +'","Id":'+ CONVERT(VARCHAR(5),DesignationID)+'}'                    
           FROM tblTaskdesignations td                       
           WHERE td.TaskID = a.TaskId                       
          FOR XML PATH('')), 1, 2, '')                      
  )  AS TaskDesignation,    
  (    
    STUFF((SELECT ', {"Id" : "'+ CONVERT(VARCHAR(5),UserId) + '"}'                    
           FROM tbltaskassignedusers as tau    
           WHERE tau.TaskId = a.TaskId                       
          FOR XML PATH('')), 1, 2, '')                      
  ) AS TaskAssignedUserIDs             
  --(SELECT TOP 1 DesignationID                     
  --         FROM tblTaskdesignations td                       
  --         WHERE td.TaskID = a.TaskId ) AS DesignationId                     
   from  tbltask a                        
   --LEFT OUTER JOIN tblTaskdesignations as b ON a.TaskId = b.TaskId                         
   --LEFT OUTER JOIN tbltaskassignedusers as c ON a.TaskId = c.TaskId                        
   LEFT OUTER JOIN tblInstallUsers as ta ON a.[AdminUserId] = ta.Id         
   LEFT OUTER JOIN tblInstallUsers as tT ON a.[TechLeadUserId] = tT.Id         
   LEFT OUTER JOIN tblInstallUsers as tU ON a.[OtherUserId] = tU.Id     
   JOIN tbltaskassignedusers as tau ON a.TaskId = tau.TaskId                        
   WHERE                   
  (                 
    (a.[Sequence] IS NOT NULL)                   	                 
    AND (ISNULL(a.[IsTechTask],@IsTechTask) = @IsTechTask) 
	AND (a.AdminStatus = 1 OR a.TechLeadStatus = 1 OR a.OtherUserStatus = 1)
	AND (tau.UserId in (select * from [dbo].[SplitString](@UserId,',')))
  )                   

                         
   --and (CreatedOn >=@startdate and CreatedOn <= @enddate )                         
  ) as x                        
 )              
                        
 ---- get CTE data into temp table                        
 SELECT *                        
 INTO #Tasks                        
 FROM Tasklist                        
                  
---- find page number to show taskid sent.                  
DECLARE @StartIndex INT  = 0                        
                  
                        
--IF @HighLightedTaskID  > 0                  
-- BEGIN                  
--  DECLARE @RowNumber BIGINT = NULL                  
                  
--  -- Find in which rownumber highlighter taskid is.                  
--  SELECT @RowNumber = RowNo_Order                   
--  FROM #Tasks                   
--  WHERE TaskId = @HighLightedTaskID                  
                  
--  -- if row number found then divide it with page size and round it to nearest integer , so will found pagenumber to be selected.                  
--  -- for ex. if total 60 records are there,pagesize is 20 and highlighted task id is at 42 row number than.                   
--  -- 42/20 = 2.1 ~ 3 - 1 = 2 = @Page Index                  
--  -- StartIndex = (2*20)+1 = 41, so records 41 to 60 will be fetched.                  
                     
--  IF @RowNumber IS NOT NULL                  
--  BEGIN                  
--   SELECT @PageIndex = (CEILING(@RowNumber / CAST(@PageSize AS FLOAT))) - 1                  
--  END                  
-- END                    
                  
 -- Set start index to fetch record.                  
 SET @StartIndex = (@PageIndex * @PageSize) + 1                        

 ----missing rows bug solution BEGIN: kapil pancholi
 --create temp table for Sequences
 CREATE TABLE #S (TASKID INT, ROW_ID INT,[SEQUENCE] INT)
 
 INSERT INTO #S (TASKID,ROW_ID,[SEQUENCE]) 
 SELECT TASKID, Row_Number() over (order by [Sequence]),[SEQUENCE] FROM #TASKS WHERE SubSequence IS NULL

 update #Tasks set #Tasks.RowNo_Order = #S.ROW_ID
 from #Tasks,#S
 where #Tasks.TaskId=#S.TASKID

 --create temp table for SubSequences
 CREATE TABLE #SS (TASKID INT, ROW_ID INT,[SUB_SEQUENCE] INT)
 
 INSERT INTO #SS (TASKID,ROW_ID,[SUB_SEQUENCE]) 
 SELECT TASKID, Row_Number() over (order by [SUBSEQUENCE]),[SUBSEQUENCE] FROM #TASKS WHERE SubSequence IS NOT NULL

 update #Tasks set #Tasks.RowNo_Order = #SS.ROW_ID
 from #Tasks,#SS
 where #Tasks.TaskId=#SS.TASKID
 ----missing rows bug solution END: kapil pancholi

 -- fetch parent sequence records from temptable                  
 SELECT *                         
 FROM #Tasks                         
 WHERE                         
 (RowNo_Order >= @StartIndex AND                         
 (                        
  @PageSize = 0 OR                         
  RowNo_Order < (@StartIndex + @PageSize)                        
 ))      
 AND                 
 SubSequence IS NULL      
 --ORDER BY  [Sequence]  DESC                      
 ORDER BY [Sequence]
      
 -- fetch sub sequence records from temptable                  
 SELECT *                         
 FROM #Tasks                         
 WHERE                         
 (RowNo_Order >= @StartIndex AND                         
 (                        
  @PageSize = 0 OR                         
  RowNo_Order < (@StartIndex + @PageSize)                        
 ))      
 AND               
 SubSequence IS NOT NULL      
 --ORDER BY  [Sequence]  DESC                      
 ORDER BY [Sequence]
      
      
 --or              
 --(              
 -- TaskId = @HighLightedTaskID          
 --)                        
 --ORDER BY CASE WHEN (TaskId = @HighLightedTaskID) THEN 0 ELSE 1 END , [Sequence]  DESC                      
                        
 -- fetch other statistics, total records, total pages, pageindex to highlighted.                       
 SELECT                        
 COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex AS PageIndex                       
  FROM #Tasks  WHERE SubSequence IS NULL                 
                  
 DROP TABLE #Tasks                  
 DROP TABLE #S    
 DROP TABLE #SS   
                      
END 

GO

create procedure GetFrozenNonFrozenTaskCount
as
begin

select count(*) as Frozen from tblTask
where AdminStatus=1 or TechLeadStatus=1 or OtherUserStatus=1

select count(*) as NonFrozen from tblTask
where AdminStatus=0 and TechLeadStatus=0 and OtherUserStatus=0

end

--END

GO

--FOR Sequencing popup issue - ever loading
ALTER PROCEDURE [dbo].[usp_UpdateTaskSequence]           
(           
 @Sequence bigint ,        
 @DesignationID int,           
 @TaskId bigint,        
 @IsTechTask bit       
)          
AS          
BEGIN          
      
      
BEGIN TRANSACTION            
        
DECLARE @OriginalSeq BIGINT      
DECLARE @OriginalDesignationID INT          
      
SELECT @OriginalSeq = [Sequence],@OriginalDesignationID =  [SequenceDesignationId] FROM tblTask WHERE TaskId = @TaskId      
      
   
-- IF TASK HAS NO SEQUENCE ASSIGNED PREVIOUSLY   
--IF( @OriginalSeq IS NULL )  
--  BEGIN 
  
			  UPDATE tblTask          
				  SET   [Sequence] = @Sequence , [SequenceDesignationId] = @DesignationID     
				WHERE TaskId = @TaskId   
  
			  --IF ONLY SEQ IS CHANGED, UPDATE ALL CHILDREN TO THE NEW SEQ (fixed Sequencing popup issue - ever loading: kapil pancholi)
			  UPDATE tblTask 
			  SET [SEQUENCE] = @Sequence, [SequenceDesignationId] = @DesignationID 
			  WHERE [SequenceDesignationId] = @OriginalDesignationID
			  AND [Sequence] = @OriginalSeq AND IsTechTask = @IsTechTask
  --END  
  
--ELSE
--	BEGIN
			  
--     END   
    

	-- IF SEQ DESIGNATION IS CHANGED THAN UPDATE ORIGINAL SEQUENCE SERIES OF DESIGNATION.      
	 IF ( @OriginalDesignationID IS NOT  NULL AND @OriginalDesignationID <> @DesignationID)      
			  BEGIN      
      
			   -- if 2 is removed from sequence than all sequence will greater than 2 for that designation will be shifted up by 1.       
				UPDATE       tblTask          
				 SET                [Sequence] = [Sequence] - 1             
				WHERE        ([Sequence] > @OriginalSeq) AND ([SequenceDesignationId] = @OriginalDesignationID) AND IsTechTask = @IsTechTask        
            
	
			  END           
	

	  
  IF (@@Error <> 0)   -- Check if any error      
     BEGIN                
        ROLLBACK TRANSACTION             
     END       
   ELSE       
       COMMIT TRANSACTION           
        
        
END       
  
  GO

ALTER PROCEDURE [dbo].[usp_UpdateTaskForSubSequencing]  
(                                      
  @TaskId   BIGINT,  
  @TaskIdSeq BIGINT,  
  @SubSeqTaskId BIGINT,    
  @DesignationId INT        
)                          
As                          
BEGIN                          
           
BEGIN TRANSACTION      
  
-- Get original subsequence task seq id.  
  
DECLARE @SubSeqTaskOriginalSeq BIGINT = (SELECT [Sequence] FROM dbo.tblTask WHERE TaskId = @SubSeqTaskId)  
DECLARE @MaxSeq INT = (SELECT [Sequence] FROM dbo.tblTask WHERE [SequenceDesignationId] = @DesignationId AND IsTechTask = 0)            
-- Make Subseq Task Seq, SubSeq to NULL  
  
 UPDATE tblTask SET [Sequence] = NULL,[SubSequence] = NULL WHERE TaskId = @SubSeqTaskId  
  
  IF(@MaxSeq = @TaskIdSeq)
  BEGIN
	-- Correct Sequences for subseq update.  
	-- if 2 is removed from sequence than all sequence will greater than 2 for that designation will be shifted up by 1.     
	 UPDATE       tblTask        
		 SET                [Sequence] = [Sequence] - 1           
	 WHERE        ([Sequence] >= @SubSeqTaskOriginalSeq) AND ([SequenceDesignationId] = @DesignationId) AND IsTechTask = 0   AND TaskId <>  @SubSeqTaskId  
	  AND [Sequence] <> @TaskIdSeq
  END
  ELSE
  BEGIN
	-- Correct Sequences for subseq update.  
	-- if 2 is removed from sequence than all sequence will greater than 2 for that designation will be shifted up by 1.     
	 UPDATE       tblTask        
		 SET                [Sequence] = [Sequence] - 1           
	 WHERE        ([Sequence] >= @SubSeqTaskOriginalSeq) AND ([SequenceDesignationId] = @DesignationId) AND IsTechTask = 0   AND TaskId <>  @SubSeqTaskId  
  END


 -- Fetch new sequence for task to be set.  
  
 SET @TaskIdSeq = (SELECT [Sequence] FROM tblTask WHERE TaskId = @TaskId)  
   
 -- Assign sub seq to SubSeqTaskId  
  
 DECLARE @MaxSubSeq INT = (SELECT ISNULL(MAX([SubSequence]),0) FROM dbo.tblTask WHERE [Sequence] = @TaskIdSeq AND IsTechTask = 0 AND [SequenceDesignationId] = @DesignationId)      
  
 UPDATE tblTask SET [Sequence] = @TaskIdSeq , [SubSequence] = @MaxSubSeq + 1 WHERE TaskId = @SubSeqTaskId  
  
       
  IF (@@Error <> 0)   -- Check if any error    
     BEGIN              
        ROLLBACK TRANSACTION           
     END     
   ELSE     
       COMMIT TRANSACTION     
                        
END 

GO
--END


--FOR Sequencing popup upgrade
ALTER PROCEDURE [dbo].[usp_InsertTaskAssignedUsers] 
(	
	@TaskId int , 
	@UserIds VARCHAR(4000) 
)
AS
BEGIN

DECLARE @DESIGNATIONID INT
DECLARE @SEQUENCE INT
DECLARE @ISTECHTASK BIT

SET @DESIGNATIONID = (SELECT SEQUENCEDESIGNATIONID FROM tblTask WHERE TASKID = @TaskId)
SET @SEQUENCE = (SELECT [SEQUENCE] FROM tblTask WHERE TASKID = @TaskId)
SET @ISTECHTASK = (SELECT ISTECHTASK FROM tblTask WHERE TASKID = @TaskId)
	
-- delete users, which are not in provided new user list.
DELETE 
FROM tblTaskAssignedUsers
WHERE 
	TaskId = @TaskId AND 
	UserId NOT IN (SELECT Item FROM dbo.SplitString(@UserIds,','))

-- insert users, which are not already present in database but are provided in new user list.
INSERT INTO tblTaskAssignedUsers (TaskId, UserId)
SELECT @TaskId , CAST(ss.Item AS BIGINT) 
FROM dbo.SplitString(@UserIds,',') ss 
WHERE NOT EXISTS(
					SELECT CAST(ttau.UserId as varchar) 
					FROM dbo.tblTaskAssignedUsers ttau 
					WHERE ttau.UserId = CAST(ss.Item AS bigint) AND ttau.TaskId = @TaskId
				)

-- Get SubSequence Tasks
CREATE TABLE #SUBSEQUENCES(TASKID INT)


IF EXISTS(SELECT * FROM tblTask WHERE SEQUENCEDESIGNATIONID=@DESIGNATIONID AND ISTECHTASK=@ISTECHTASK AND SUBSEQUENCE IS NULL AND [SEQUENCE] = @SEQUENCE AND TASKID=@TASKID)
BEGIN
	INSERT INTO #SUBSEQUENCES
	SELECT TASKID FROM tblTask 
	WHERE SEQUENCEDESIGNATIONID=@DESIGNATIONID 
	AND ISTECHTASK=@ISTECHTASK 
	AND SUBSEQUENCE IS NOT NULL
	AND [SEQUENCE] = @SEQUENCE
END
ELSE
BEGIN
INSERT INTO #SUBSEQUENCES
	SELECT @TASKID
END

-- ASSIGN USERS TO SUB_SEQUENCE
DELETE 
FROM tblTaskAssignedUsers
WHERE 
	TaskId IN (SELECT TASKID FROM #SUBSEQUENCES) AND 
	UserId NOT IN (SELECT Item FROM dbo.SplitString(@UserIds,','))

	DECLARE @TID INT
	WHILE EXISTS(SELECT * FROM #SUBSEQUENCES)
	BEGIN		
		SET @TID = (SELECT TOP 1 TASKID FROM #SUBSEQUENCES ORDER BY TASKID)

		INSERT INTO tblTaskAssignedUsers (TaskId, UserId)
			SELECT @TID , CAST(ss.Item AS BIGINT) 
					FROM dbo.SplitString(@UserIds,',') ss 
					WHERE NOT EXISTS(
						SELECT CAST(ttau.UserId as varchar) 
						FROM dbo.tblTaskAssignedUsers ttau 
						WHERE ttau.UserId = CAST(ss.Item AS bigint) AND ttau.TaskId = @TID
					) 
		--SET TASKS STATUS TO ASSIGNED
		IF(@UserIds <> '')
			UPDATE tblTask SET [STATUS] = 3 WHERE TASKID = @TID
		ELSE
			--SET TASKS STATUS TO OPEN
			UPDATE tblTask SET [STATUS] = 1 WHERE TASKID = @TID

		DELETE FROM #SUBSEQUENCES WHERE TASKID = @TID

	END

DROP TABLE #SUBSEQUENCES
END

--END

GO

--FOR PROFILE PIC
create procedure GetInstallUserById (@UserId int)
as
begin
select Picture,ResumePath from tblInstallUsers where Id=@UserId
end
--END