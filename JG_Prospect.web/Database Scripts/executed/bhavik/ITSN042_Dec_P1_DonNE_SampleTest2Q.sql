
TRUNCATE TABLE [MCQ_CorrectAnswer]
SET IDENTITY_INSERT [dbo].[MCQ_CorrectAnswer] ON 

INSERT [dbo].[MCQ_CorrectAnswer] ([AnswerID], [AnswerText], [QuestionID]) VALUES (75, N'Shared Assemblies', 64)
INSERT [dbo].[MCQ_CorrectAnswer] ([AnswerID], [AnswerText], [QuestionID]) VALUES (76, N'ngen', 65)

INSERT [dbo].[MCQ_CorrectAnswer] ([AnswerID], [AnswerText], [QuestionID]) VALUES (77, N'.NET class libraries',66)
INSERT [dbo].[MCQ_CorrectAnswer] ([AnswerID], [AnswerText], [QuestionID]) VALUES (78, N'Garbage Collector',67)
INSERT [dbo].[MCQ_CorrectAnswer] ([AnswerID], [AnswerText], [QuestionID]) VALUES (79, N'Shared Assemblies',68)
INSERT [dbo].[MCQ_CorrectAnswer] ([AnswerID], [AnswerText], [QuestionID]) VALUES (80, N'Managed Code',69)
INSERT [dbo].[MCQ_CorrectAnswer] ([AnswerID], [AnswerText], [QuestionID]) VALUES (81, N'System.Object',70)
INSERT [dbo].[MCQ_CorrectAnswer] ([AnswerID], [AnswerText], [QuestionID]) VALUES (82, N'Webforms',71)
INSERT [dbo].[MCQ_CorrectAnswer] ([AnswerID], [AnswerText], [QuestionID]) VALUES (83, N'Page_Init()',72)
INSERT [dbo].[MCQ_CorrectAnswer] ([AnswerID], [AnswerText], [QuestionID]) VALUES (84, N'System.Web.UI.Page',73)
INSERT [dbo].[MCQ_CorrectAnswer] ([AnswerID], [AnswerText], [QuestionID]) VALUES (85, N'Regular expressions',74)
INSERT [dbo].[MCQ_CorrectAnswer] ([AnswerID], [AnswerText], [QuestionID]) VALUES (86, N'Implement application and session level events',75)

SET IDENTITY_INSERT [dbo].[MCQ_CorrectAnswer] OFF
 

Truncate Table [MCQ_Exam]
SET IDENTITY_INSERT [dbo].[MCQ_Exam] ON 
INSERT [dbo].[MCQ_Exam] ([ExamID], [ExamTitle], [ExamDescription], [ExamType], [IsActive], [CourseID], [ExamDuration], [PassPercentage]) VALUES (20, N'.Net Test JG Aptitude Screen Test ', N' Test for .Net Sr. and Jr. Developer ', 2, 1, 1, 17, 0)
SET IDENTITY_INSERT [dbo].[MCQ_Exam] OFF 

TRUNCATE TABLE [MCQ_Option]
SET IDENTITY_INSERT [dbo].[MCQ_Option] ON 

INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (202, N'Private Assemblies', 64)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (203, N'Friend Assemblies', 64)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (204, N'Shared Assemblies', 64)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (205, N'Public Assemblies', 64)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (206, N'gacutil', 65)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (207, N'ngen', 65)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (208, N'sn', 65)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (209, N'dumpbin', 65)



INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (210,N'.NET class libraries',66)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (211,N'Common Language Runtime',66)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (212,N'Common Language Infrastructure',66)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (213,N'Component Object Model',66)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (214,N'Common Type System',66)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (215,N'Common Language Infrastructure',67)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (216,N'CLR',67)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (217,N'Garbage Collector',67)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (218,N'Class Loader',67)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (219,N'CTS',67)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (220,N'Private Assemblies',68)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (221,N'Friend Assemblies',68)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (222,N'Shared Assemblies',68)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (223,N'Public Assemblies',68)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (224,N'Protected Assemblies',68)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (225,N'Unmanaged',69)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (226,N'Distributed',69)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (227,N'Legacy',69)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (228,N'Managed Code',69)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (229,N'Native Code',69)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (230,N'System.Object',70)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (231,N'System.Type',70)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (232,N'System.Base',70)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (233,N'System.Parent',70)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (234,N'System.Root',70)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (235,N'HTMLForms',71)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (236,N'Webforms',71)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (237,N'Winforms',71)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (238,N'Page_Init()',72)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (239,N' Page_Load()',72)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (240,N' Page_click()',72)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (241,N'System.Web.UI.Page',73)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (242,N'System.Web.UI.Form',73)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (243,N'System.Web.GUI.Page',73)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (244,N'System.Web.Form',73)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (245,N'Extended expressions',74)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (246,N'Basic expressions',74)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (247,N'Regular expressions',74)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (248,N'Irregular expressions',74)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (249,N'Declare Global variables',75)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (250,N'Implement application and session level events',75)
INSERT [dbo].[MCQ_Option] ([OptionID], [OptionText], [QuestionID]) VALUES (251,N'No use',75)



SET IDENTITY_INSERT [dbo].[MCQ_Option] OFF



TRUNCATE TABLE [MCQ_Question]
SET IDENTITY_INSERT [dbo].[MCQ_Question] ON 

INSERT [dbo].[MCQ_Question] ([QuestionID], [Question], [QuestionType], [PositiveMarks], [NegetiveMarks], [PictureURL], [ExamID], [AnswerTemplate]) VALUES (64, N'<p>&nbsp;Which of the following assemblies can be stored in Global Assembly Cache?</p>', 1, 1, 0, N'0', 20, N'')
INSERT [dbo].[MCQ_Question] ([QuestionID], [Question], [QuestionType], [PositiveMarks], [NegetiveMarks], [PictureURL], [ExamID], [AnswerTemplate]) VALUES (65, N'<p>&nbsp;Which of the following utilities can be used to compile managed assemblies into processor-specific native code?</p>', 1, 1, 0, N'0', 20, N'')
INSERT [dbo].[MCQ_Question] ([QuestionID], [Question], [QuestionType], [PositiveMarks], [NegetiveMarks], [PictureURL], [ExamID], [AnswerTemplate]) VALUES (66, N'<p>&nbsp;Which of the following components of the .NET framework provide an extensible set of classes that can be used by any .NET compliant programming language?</p>', 1, 1, 0, N'0', 20, N'')
INSERT [dbo].[MCQ_Question] ([QuestionID], [Question], [QuestionType], [PositiveMarks], [NegetiveMarks], [PictureURL], [ExamID], [AnswerTemplate]) VALUES (67, N'<p>&nbsp;Which of the following .NET components can be used to remove unused references from the managed heap?</p>', 1, 1, 0, N'0', 20, N'')
INSERT [dbo].[MCQ_Question] ([QuestionID], [Question], [QuestionType], [PositiveMarks], [NegetiveMarks], [PictureURL], [ExamID], [AnswerTemplate]) VALUES (68, N'<p>&nbsp;Which of the following assemblies can be stored in Global Assembly Cache?</p>', 1, 1, 0, N'0', 20, N'')
INSERT [dbo].[MCQ_Question] ([QuestionID], [Question], [QuestionType], [PositiveMarks], [NegetiveMarks], [PictureURL], [ExamID], [AnswerTemplate]) VALUES (69, N'<p>&nbsp;Code that targets the Common Language Runtime is known as</p>', 1, 1, 0, N'0', 20, N'')
INSERT [dbo].[MCQ_Question] ([QuestionID], [Question], [QuestionType], [PositiveMarks], [NegetiveMarks], [PictureURL], [ExamID], [AnswerTemplate]) VALUES (70, N'<p>&nbsp;Which of the following is the root of the .NET type hierarchy?</p>', 1, 1, 0, N'0', 20, N'')
INSERT [dbo].[MCQ_Question] ([QuestionID], [Question], [QuestionType], [PositiveMarks], [NegetiveMarks], [PictureURL], [ExamID], [AnswerTemplate]) VALUES (71, N'<p>&nbsp;Choose the form in which Postback occur</p>', 1, 1, 0, N'0', 20, N'')
INSERT [dbo].[MCQ_Question] ([QuestionID], [Question], [QuestionType], [PositiveMarks], [NegetiveMarks], [PictureURL], [ExamID], [AnswerTemplate]) VALUES (72, N'<p>&nbsp;The first event triggers in an aspx page is.</p>', 1, 1, 0, N'0', 20, N'')
INSERT [dbo].[MCQ_Question] ([QuestionID], [Question], [QuestionType], [PositiveMarks], [NegetiveMarks], [PictureURL], [ExamID], [AnswerTemplate]) VALUES (73, N'<p>&nbsp;What class does the ASP.NET Web Form class inherit from by default?</p>', 1, 1, 0, N'0', 20, N'')
INSERT [dbo].[MCQ_Question] ([QuestionID], [Question], [QuestionType], [PositiveMarks], [NegetiveMarks], [PictureURL], [ExamID], [AnswerTemplate]) VALUES (74, N'<p>&nbsp;What is used to validate complex string patterns like an e-mail address?</p>', 1, 1, 0, N'0', 20, N'')
INSERT [dbo].[MCQ_Question] ([QuestionID], [Question], [QuestionType], [PositiveMarks], [NegetiveMarks], [PictureURL], [ExamID], [AnswerTemplate]) VALUES (75, N'<p>&nbsp;Why is Global.asax is used?</p>', 1, 1, 0, N'0', 20, N'')



SET IDENTITY_INSERT [dbo].[MCQ_Question] OFF





