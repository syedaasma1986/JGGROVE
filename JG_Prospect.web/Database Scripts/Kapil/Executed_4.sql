alter PROCEDURE [dbo].[SP_GetInstallUsers]          
 @Key int,        
 @Designations varchar(4000),      
 @ActiveStatus varchar(5) = '1',      
 @InterviewDateStatus varchar(5) = '5',      
 @OfferMadeStatus varchar(5) = '6'      
AS          
BEGIN          
      
 IF @Key = 1        
 BEGIN      
  SELECT      
   DISTINCT(Designation) AS Designation       
  FROM tblinstallUsers       
  WHERE Designation IS NOT NULL           
  ORDER BY Designation      
 END      
 ELSE IF @Key = 2        
 BEGIN      
 IF @Designations = ''
 BEGIN
 SELECT FristName + ' ' + ISNULL(NameMiddleInitial + '. ','') + LastName + ' - ' + ISNULL(UserInstallId,'') as FristName,Id , [Status],ISNULL(UserInstallId,'') as  UserInstallId      
  FROM tblinstallUsers       
  WHERE        
   (FristName IS NOT NULL AND RTRIM(LTRIM(FristName)) <> '' )  AND       
   (      
    tblinstallUsers.[Status] = @ActiveStatus OR       
    tblinstallUsers.[Status] = @OfferMadeStatus OR       
    tblinstallUsers.[Status] = @InterviewDateStatus      
   )      
  ORDER BY CASE WHEN [Status] = '1' THEN 1 ELSE 2 END, [Status], DesignationID ,FristName + ' ' + LastName      
 END
 ELSE
 BEGIN
  SELECT FristName + ' ' + ISNULL(NameMiddleInitial + '. ','') + LastName + ' - ' + ISNULL(UserInstallId,'') as FristName,Id , [Status],ISNULL(UserInstallId,'') as  UserInstallId      
  FROM tblinstallUsers       
  WHERE        
   (FristName IS NOT NULL AND RTRIM(LTRIM(FristName)) <> '' )  AND       
   (      
    tblinstallUsers.[Status] = @ActiveStatus OR       
    tblinstallUsers.[Status] = @OfferMadeStatus OR       
    tblinstallUsers.[Status] = @InterviewDateStatus      
   ) AND       
   (      
    Designation IN (SELECT Item FROM dbo.SplitString(@Designations,','))      
    OR      
    Convert(Nvarchar(max),DesignationID)  IN (SELECT Item FROM dbo.SplitString(@Designations,','))      
   )      
  ORDER BY CASE WHEN [Status] = '1' THEN 1 ELSE 2 END, [Status], DesignationID ,FristName + ' ' + LastName      
  END
 END      
END       
  GO

  INSERT [dbo].[tblHTMLTemplatesMaster] ([Id], [Name], [Subject], [Header], [Body], [Footer], [DateUpdated], [Type], [Category], [FromID], [TriggerText], [FrequencyInDays], [FrequencyStartDate], 
[FrequencyStartTime], [UsedFor]) VALUES (106, N'HR_User_Task_Shared', N'Task Shared', N'<div style="font-size: 13.3333px;"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/header.jpg" /></div>
<div style="font-size: 13.3333px;"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/logo.gif" /></div>', N'<div>Hi #Fname#,<br/><br/>Following task has been shared with you:<br/><br/>Please click or copy below link to view task:<br/><br/><a href="#TaskLink#">#TaskTitle#</a><br/><br/>Thanks!</div>', N'<br />
<div>
<p style="font-size: 13.3333px;">J.M. Grove - Construction &amp; Supply&nbsp;<br />
<a href="http://web.jmgrovebuildingsupply.com/Sr_App/jmgroveconstruction.com">jmgroveconstruction.com&nbsp;</a><br />
<a href="http://jmgrovebuildingsupply.com/">http://jmgrovebuildingsupply.com/</a><br />
<a href="http://web.jmgrovebuildingsupply.com/login.aspx">http://web.jmgrovebuildingsupply.com/login.aspx</a><br />
<a href="http://jmgroverealestate.com/">http://jmgroverealestate.com/</a><br />
<br />
72 E Lancaster Ave<br />
Malvern, Pa 19355<br />
Human Resources<br />
Office:(215) 274-5182 Ext. 4<br />
<a href="mailto:Hr@jmgroveconstruction.com">Hr@jmgroveconstruction.com</a></p>
<div style="font-size: 13.3333px;"><a href="https://www.facebook.com/JMGrove1com/"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/fb.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/twitter_zpsiiplyhiq.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/tw.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/236e0d0b-832c-4543-81a6-f6c460d302f0_zpsl4nh3ane.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/gpls.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/pinterest_zpspioq6pve.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/pint.png" /></a><br />
<a href="http://s49.photobucket.com/user/jmg1/media/twitter_zpsiiplyhiq.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/hbt.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/youtube_zpsxyhfmm1b.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/yt.png" /></a><a href="http://s49.photobucket.com/user/jmg1/media/c3894afd-7a37-43e2-917c-5ffb7a5036a2_zpschul0pqd.png.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/houzz.png" /></a>&nbsp;<a href="http://s49.photobucket.com/user/jmg1/media/4478596b-67f4-444e-992a-624af3e56255_zpsoi8p1uyv.jpg.html"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/linkin.jpg" /></a></div>
<div style="font-size: 13.3333px;"><img src="http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/footer.png" /></div></div>', CAST(N'2017-06-17' AS Date), 1, 1, NULL, NULL, NULL, NULL, NULL, 2)
GO

-- =============================================            
-- Author: Kapil Pancholi
-- Create date: 12/7/2017
-- Updated By: Kapil Pancholi   
-- Updated date: 12/7/2017
-- Description: SP_GetInstallUsers            
 --[dbo].[SP_GetInstallUsersWithStatus] 2,'',6
-- =============================================            
CREATE PROCEDURE [dbo].[SP_GetInstallUsersWithStatus]
 @Key int,          
 @Designations varchar(4000),        
 @UserStatus int        
AS            
BEGIN            
        
 IF @Key = 1          
 BEGIN        
  SELECT        
   DISTINCT(Designation) AS Designation         
  FROM tblinstallUsers         
  WHERE Designation IS NOT NULL             
  ORDER BY Designation        
 END        
 ELSE IF @Key = 2          
 BEGIN        
 IF @Designations = ''  
 BEGIN  
 SELECT FristName + ' ' + ISNULL(NameMiddleInitial + '. ','') + LastName + ' - ' + ISNULL(UserInstallId,'') as FristName,Id , [Status],ISNULL(UserInstallId,'') as  UserInstallId        
  FROM tblinstallUsers         
  WHERE          
   (FristName IS NOT NULL AND RTRIM(LTRIM(FristName)) <> '' )  AND         
   (        
    tblinstallUsers.[Status] = @UserStatus      
   )        
  ORDER BY CASE WHEN [Status] = '1' THEN 1 ELSE 2 END, [Status], DesignationID ,FristName + ' ' + LastName        
 END  
 ELSE  
 BEGIN  
  SELECT FristName + ' ' + ISNULL(NameMiddleInitial + '. ','') + LastName + ' - ' + ISNULL(UserInstallId,'') as FristName,Id , [Status],ISNULL(UserInstallId,'') as  UserInstallId        
  FROM tblinstallUsers         
  WHERE          
   (FristName IS NOT NULL AND RTRIM(LTRIM(FristName)) <> '' )  AND         
   (        
    tblinstallUsers.[Status] = @UserStatus       
   ) AND         
   (        
    Designation IN (SELECT Item FROM dbo.SplitString(@Designations,','))        
    OR        
    Convert(Nvarchar(max),DesignationID)  IN (SELECT Item FROM dbo.SplitString(@Designations,','))        
   )        
  ORDER BY CASE WHEN [Status] = '1' THEN 1 ELSE 2 END, [Status], DesignationID ,FristName + ' ' + LastName        
  END  
 END        
END         