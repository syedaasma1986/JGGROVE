USE [JGBS]
GO
ALTER TABLE [dbo].[tblInstallUsers] ADD [Rejection_Date] DateTime NULL;
ALTER TABLE [dbo].[tblInstallUsers] ADD [DateOfBirth] DateTime NULL;
ALTER TABLE [dbo].[tblInstallUsers] ADD [Hire_Date] DateTime NULL;
ALTER TABLE [dbo].[tblInstallUsers] ADD [Termination_Date] DateTime NULL;
ALTER TABLE [dbo].[tblInstallUsers] ADD [NextReview_Date] DateTime NULL;
ALTER TABLE [dbo].[tblInstallUsers] ADD [LastReview_Date] DateTime NULL;
ALTER TABLE [dbo].[tblInstallUsers] ADD [Start_Date] DateTime NULL;
ALTER TABLE [dbo].[tblInstallUsers] ADD [Interview_Time] Time NULL;
ALTER TABLE [dbo].[tblInstallUsers] ADD [Activation_Date] DateTime NULL;
ALTER TABLE [dbo].[tblInstallUsers] ADD [SourceID] INT NULL;
ALTER TABLE [dbo].[tblInstallUsers] ADD CONSTRAINT FK_tblInstallUsers_SourceID_tblSource_ID 
FOREIGN KEY (SourceID) REFERENCES [dbo].[tblSource](ID);
GO
ALTER TABLE [dbo].[tblInstallUsers] ADD [AddedByUserID] INT NULL;
ALTER TABLE [dbo].[tblInstallUsers] ADD CONSTRAINT FK_tblInstallUsers_AddedByUserID_tblUsers_ID 
FOREIGN KEY (AddedByUserID) REFERENCES [dbo].[tblUsers](ID);
GO
