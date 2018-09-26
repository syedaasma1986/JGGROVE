GO
/****** Object:  StoredProcedure [dbo].[SP_InsertUserEmail]    Script Date: 12/4/2016 12:58:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Bhavik
-- Create date: 22-11-2016
-- Description:	Insert email data
-- =============================================
ALTER PROCEDURE [dbo].[SP_InsertUserEmail] 
	-- Add the parameters for the stored procedure here
	@EmailID varchar(max), 
	@UserID int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

---SPLIT THE VALUE --- START--
DECLARE @Split char(3),
        @X xml

SELECT @Split = '|,|'



SELECT @X = CONVERT(xml,' <root> <s>' + REPLACE(@EmailID,@Split,'</s> <s>') + '</s>   </root> ')
---SPLIT THE VALUE --- END--


DELETE FROM tblUserEmail WHERE UserID = @UserID

IF @EmailID <> ''
BEGIN
		INSERT INTO [dbo].[tblUserEmail]
				   ([emailID]
				   ,[IsPrimary]
				   ,[UserID])
		 SELECT [Value] = T.c.value('.','varchar(255)') , 0 ,@UserID
		FROM @X.nodes('/root/s') T(c)
		where T.c.value('.','varchar(255)') <> ''

END


END


GO

ALTER TABLE tblUserPhone ADD PhoneExtNo VARCHAR(20)
ALTER TABLE tblUserPhone ADD PhoneISDCode VARCHAR(8)

GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MCQ_Exam](
	[ExamID] [bigint] IDENTITY(1,1) NOT NULL,
	[ExamTitle] [varchar](max) NOT NULL,
	[ExamDescription] [varchar](max) NULL,
	[ExamType] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CourseID] [bigint] NOT NULL,
	[ExamDuration] [int] NULL,	
	[PassPercentage] [float] NULL,
 CONSTRAINT [PK_MCQ_Exam] PRIMARY KEY CLUSTERED 
(
	[ExamID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO




/****** Object:  Table [dbo].[MCQ_Question]    Script Date: 12/15/2016 6:54:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MCQ_Question](
	[QuestionID] [bigint] IDENTITY(1,1) NOT NULL,
	[Question] [varchar](max) NOT NULL,
	[QuestionType] [bigint] NOT NULL,
	[PositiveMarks] [bigint] NULL,
	[NegetiveMarks] [bigint] NOT NULL,
	[PictureURL] [varchar](50) NULL,
	[ExamID] [bigint] NULL,
	[AnswerTemplate] [varchar](max) NULL,
 CONSTRAINT [PK_MCQ_Question] PRIMARY KEY CLUSTERED 
(
	[QuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


GO

/****** Object:  Table [dbo].[MCQ_CorrectAnswer]    Script Date: 12/15/2016 7:11:10 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MCQ_CorrectAnswer](
	[AnswerID] [bigint] IDENTITY(1,1) NOT NULL,
	[AnswerText] [varchar](max) NOT NULL,
	[QuestionID] [bigint] NOT NULL,
 CONSTRAINT [PK_MCQ_CorrectAnswer] PRIMARY KEY CLUSTERED 
(
	[AnswerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


GO

/****** Object:  Table [dbo].[MCQ_Option]   Script Date: 12/15/2016 7:19:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MCQ_Option](
	[OptionID] [bigint] IDENTITY(1,1) NOT NULL,
	[OptionText] [varchar](max) NOT NULL,
	[QuestionID] [bigint] NOT NULL,
 CONSTRAINT [PK_MCQ_Option] PRIMARY KEY CLUSTERED 
(
	[OptionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



 


GO

/****** Object:  Table [dbo].[MCQ_Performance]    Script Date: 12/15/2016 7:45:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MCQ_Performance](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [varchar](max) NOT NULL,
	[ExamID] [bigint] NOT NULL,
	[MarksEarned] [int] NULL,
	[TotalMarks] [int] NULL,
	[Aggregate] [real] NULL,
	[ExamPerformanceStatus] [int] NULL,
 CONSTRAINT [PK_MCQ_Performance] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
 




--------------------------

GO

/****** Object:  StoredProcedure [dbo].[SP_InsertPerfomace]    Script Date: 12/15/2016 8:21:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SP_InsertPerfomace] 
	-- Add the parameters for the stored procedure here
	@installUserID varchar(20), 
	@examID int = 0
	,@marksEarned int
	,@totalMarks int
	,@Aggregate real

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [MCQ_Performance]
           ([UserID]
           ,[ExamID]
           ,[MarksEarned]
           ,[TotalMarks]
           ,[Aggregate]           
		   )
     VALUES
           (@installUserID
           ,@examID
           ,@marksEarned
           ,@totalMarks
           ,@Aggregate
           )
END

GO


 ------------------------






/****** Object:  StoredProcedure [dbo].[SP_CheckNewUserFromOtherSite]    Script Date: 12/15/2016 8:26:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [dbo].[SP_CheckNewUserFromOtherSite] 
	-- Add the parameters for the stored procedure here
	@userEmail Varchar(50), 
	@userID int = 0,
	@DefaultPassWord Varchar(50)

AS
BEGIN

	DECLARE @IsNewUser NVARCHAR(10)='';
	
	
IF EXISTS (SELECT Id from tblInstallUsers 
		WHERE ID = @userID  
		AND  Email = @userEmail
		AND  Password = @DefaultPassWord )
	BEGIN
		SET  @IsNewUser	 ='YES'
	END
ELSE
	BEGIN
			SET  @IsNewUser	 ='NO'
	END
	SELECT @IsNewUser

END

GO


GO



IF OBJECT_ID('dbo.tblUserPhone', 'U') IS NOT NULL 
  DROP TABLE dbo.tblUserPhone; 


/****** Object:  Table [dbo].[tblUserPhone]    Script Date: 12/16/2016 10:00:11 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblUserPhone](
	[UserPhoneID] [int] IDENTITY(1,1) NOT NULL,
	[Phone] [varchar](50) NULL,
	[IsPrimary] [bit] NULL,
	[PhoneTypeID] [int] NULL,
	[UserID] [int] NULL,
	[PhoneExtNo] [varchar](20) NULL,
	[PhoneISDCode] [varchar](8) NULL,
 CONSTRAINT [PK_tblUserPhone] PRIMARY KEY CLUSTERED 
(
	[UserPhoneID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO




/****** Object:  StoredProcedure [dbo].[Sp_InsertUpdateUserPhone]    Script Date: 12/15/2016 8:27:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Bhavik J. Vaishnani
-- Create date: 23-11-2016
-- Description:	Insert/ Update User Phone
-- =============================================
ALTER PROCEDURE [dbo].[Sp_InsertUpdateUserPhone] 
	-- Add the parameters for the stored procedure here
	@isPrimaryPhone bit,
	@phoneText varchar(256),
	@phoneType varchar(50),
	@UserID int,
	@PhoneExtNo varchar(50),
	@PhoneISDCode varchar(50),
	@ClearPastRecord bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if (@ClearPastRecord = 1)
	BEGIN
		DELETE FROM tblUserPhone WHERE UserID = @UserID
	END
ELSE
  BEGIN
    INSERT INTO [dbo].[tblUserPhone]
           ([Phone]
           ,[IsPrimary]
           ,[PhoneTypeID]
           ,[UserID]
		   ,[PhoneExtNo]
		   ,[PhoneISDCode])
     VALUES
           (@phoneText
           ,@isPrimaryPhone
           ,@phoneType
           ,@UserID
		   ,@PhoneExtNo
		   ,@PhoneISDCode)
  END	
END





SET ANSI_NULLS ON

GO







/****** Object:  StoredProcedure [dbo].[SP_GetUserPhoneUserId]    Script Date: 12/15/2016 8:27:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Bhavik J
-- Create date: 
-- Description:	Get the List of user Phone
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetUserPhoneUserId] 
	-- Add the parameters for the stored procedure here
	@UserID int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * From tblUserPhone tue where  tue.UserID = @UserID

END

GO



-----------------------------------------------------------------------------------------------------------------------------
GO

ALTER Table tblInstallUsers ADD

[PhoneISDCode] [varchar](10) NULL,
[PhoneExtNo] [varchar](30) NULL

GO



/****** Object:  StoredProcedure [dbo].[UDP_AddInstallUser]    Script Date: 12/15/2016 8:37:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[UDP_AddInstallUser]  
	@FristName varchar(50),  
	@LastName varchar(50),  
	@Email varchar(100),  
	@phone varchar(20),  
	@phonetype char(15),
	@address varchar(100),  
	@Zip varchar(10),  
	@State varchar(30),  
	@City varchar(30),  

	--@Zip2 varchar(10) = null,  
	--@State2 varchar(30) = null,  
	--@City2 varchar(30) = null,
	  

	@password varchar(50),  
	@designation varchar(50),  
	@status varchar(20),  
	@Picture varchar(max),  
	@Attachements varchar(max),
	@bussinessname varchar(100),
	@ssn varchar(20),
	@ssn1 varchar(20),
	@ssn2 varchar(20),
	@signature varchar(25),
	@dob varchar(20),
	@citizenship varchar(50),
	@ein1 varchar(20),
	@ein2 varchar(20), 
	@a varchar(20),
	@b varchar(20),
	@c varchar(20),
	@d varchar(20),
	@e varchar(20),
	@f varchar(20),
	@g varchar(20),
	@h varchar(20),
	@i varchar(20),
	@j varchar(20),
	@k varchar(20),
	@maritalstatus varchar(20),
	@PrimeryTradeId int = 0,
	@SecondoryTradeId varchar(200) = '',
	@Source	varchar(MAX)='',
	@Notes	varchar(MAX)='',
	@StatusReason varchar(MAX) = '',
	@GeneralLiability	varchar(MAX) = '',
	@PCLiscense	varchar(MAX) = '',
	@WorkerComp	varchar(MAX) = '',
	@HireDate varchar(50) = '',
	@TerminitionDate varchar(50) = '',
	@WorkersCompCode varchar(20) = '',
	@NextReviewDate	varchar(50) = '',
	@EmpType varchar(50) = '',
	@LastReviewDate	varchar(50) = '',
	@PayRates varchar(50) = '',
	@ExtraEarning varchar(max) = '',
	@ExtraEarningAmt varchar(max) = 0,
	@PayMethod varchar(50) = '',
	@Deduction VARCHAR(MAX) = '',
	@DeductionType varchar(50) = '',
	@AbaAccountNo varchar(50) = '',
	@AccountNo varchar(50) = '',
	@AccountType varchar(50) = '',
	@InstallId VARCHAR(MAX) = '',
	@PTradeOthers varchar(100) = '',
	@STradeOthers varchar(100) = '',
	@DeductionReason varchar(MAX) = '',
	@SuiteAptRoom varchar(10) = '',
	@FullTimePosition int = 0,
	@ContractorsBuilderOwner VARCHAR(500) = '',
	@MajorTools VARCHAR(250) = '',
	@DrugTest bit = null,
	@ValidLicense bit = null,
	@TruckTools bit = null,
	@PrevApply bit = null,
	@LicenseStatus bit = null,
	@CrimeStatus bit = null,
	@StartDate VARCHAR(50) = '',
	@SalaryReq VARCHAR(50) = '',
	@Avialability VARCHAR(50) = '',
	@ResumePath VARCHAR(MAX) = '',
	@skillassessmentstatus bit = null,
	@assessmentPath VARCHAR(MAX) = '',
	@WarrentyPolicy  VARCHAR(50) = '',
	@CirtificationTraining VARCHAR(MAX) = '',
	@businessYrs decimal = 0,
	@underPresentComp decimal = 0,
	@websiteaddress VARCHAR(MAX) = '',
	@PersonName VARCHAR(MAX) = '',
	@PersonType VARCHAR(MAX) = '',
	@CompanyPrinciple VARCHAR(MAX) = '',
	@UserType VARCHAR(25) = '',
	@Email2	varchar(70)	= '',
	@Phone2	varchar(70)	= '',
	@CompanyName	varchar(100) = '',
	@SourceUser	varchar(10)	= '',
	@DateSourced	varchar(50)	= '',
	@InstallerType varchar(20) = '',
	@BusinessType varchar(50) = '',
	@CEO varchar(100) = '',
	@LegalOfficer	varchar(100) = '',
	@President	varchar(100) = '',
	@Owner	varchar(100) = '',
	@AllParteners	varchar(MAX) = '',
	@MailingAddress	varchar(100) = '',
	@Warrantyguarantee	bit = null,
	@WarrantyYrs	int = 0,
	@MinorityBussiness	bit = null,
	@WomensEnterprise	bit = null,
	@InterviewTime varchar(20) ='',
	@ActivationDate	varchar(50)	= '',
	@UserActivated	varchar(100) = '',
	@LIBC VARCHAR(5) = '',

	@CruntEmployement bit = null,
	@CurrentEmoPlace varchar(100) = '',
	@LeavingReason varchar(MAX) = '',
	@CompLit bit = null,
	@FELONY	bit = null,
	@shortterm	varchar(250) = '',
	@LongTerm	varchar(250) = '',
	@BestCandidate	varchar(MAX) = '',
	@TalentVenue	varchar(MAX) = '',
	@Boardsites	varchar(300) = '',
	@NonTraditional	varchar(MAX) = '',
	@ConSalTraning	varchar(100) = '',
	@BestTradeOne	varchar(50) = '',
	@BestTradeTwo	varchar(50) = '',
	@BestTradeThree	varchar(50) = '',

	@aOne	varchar(50)	= '',
	@aOneTwo	varchar(50)	= '',
	@bOne	varchar(50)	= '',
	@cOne	varchar(50)	= '',
	@aTwo	varchar(50)	= '',
	@aTwoTwo	varchar(50)	= '',
	@bTwo	varchar(50)	= '',
	@cTwo	varchar(50)	= '',
	@aThree	varchar(50)	= '',
	@aThreeTwo	varchar(50)	= '',
	@bThree	varchar(50)	= '',
	@cThree	varchar(50)	= '',
	@RejectionDate	varchar(50)	='',
	@RejectionTime	varchar(50)	='',
	@RejectedUserId  int = 0,
	@TC bit = null,
	@ExtraIncomeType varchar(MAX) = '',
	@AddedBy int = 0,
	@PositionAppliedFor varchar(50)	='',
	@DesignationID int=0,
	@PhoneISDCode VARCHAR(10),
	@PhoneExtNo VARCHAR(30),
	@Id int out,
	@result bit output  

AS 
BEGIN  

	DECLARE @MaxId int = 0

	INSERT INTO tblInstallUsers   
		(  
			FristName,LastName,Email,Phone,phonetype,[Address],Zip,[State],[City],
			--Zip2,[State2],[City2],

			[Password],Designation,[Status],Picture,Attachements,Bussinessname,SSN,SSN1,SSN2,[Signature]
			,DOB,Citizenship,EIN1,EIN2,A,B,C,D,E,F,G,H,[5],[6],[7],maritalstatus,PrimeryTradeId
			,SecondoryTradeId,Source,Notes,StatusReason,GeneralLiability,PCLiscense,WorkerComp,HireDate,TerminitionDate,WorkersCompCode,NextReviewDate,EmpType,LastReviewDate
			,PayRates,ExtraEarning,ExtraEarningAmt,PayMethod,Deduction,DeductionType,AbaAccountNo,AccountNo,AccountType
			,InstallId,PTradeOthers,STradeOthers,DeductionReason,SuiteAptRoom,FullTimePosition,ContractorsBuilderOwner,MajorTools,DrugTest,ValidLicense,TruckTools
			,PrevApply,LicenseStatus,CrimeStatus,StartDate,SalaryReq,Avialability,ResumePath,skillassessmentstatus,assessmentPath,WarrentyPolicy,CirtificationTraining
			,businessYrs,underPresentComp,websiteaddress,PersonName,PersonType,CompanyPrinciple,UserType,Email2,Phone2,CompanyName,SourceUser,DateSourced,InstallerType
			,BusinessType,CEO,LegalOfficer,President,Owner,AllParteners,MailingAddress,Warrantyguarantee,WarrantyYrs,MinorityBussiness,WomensEnterprise,InterviewTime
			,ActivationDate,UserActivated,LIBC,CruntEmployement,CurrentEmoPlace,LeavingReason,CompLit,FELONY,shortterm,LongTerm,BestCandidate,TalentVenue,Boardsites
			,NonTraditional,ConSalTraning,BestTradeOne,BestTradeTwo,BestTradeThree,aOne,aOneTwo,bOne,cOne,aTwo,aTwoTwo,bTwo,cTwo,aThree,aThreeTwo,bThree,cThree
			,RejectionDate,RejectionTime,RejectedUserId,TC,ExtraIncomeType
			,PositionAppliedFor,DesignationID ,PhoneExtNo ,PhoneISDCode
		)  
	VALUES  
		(  
			@FristName,@LastName,@Email,@phone,@phonetype,@address,@Zip,@State,@City,
			--@Zip2,@State2,@City2,
			@password,@designation,@status,@Picture,@Attachements,@bussinessname,@ssn,@ssn1,@ssn2,@signature
			,@dob,@citizenship,@ein1,@ein2,@a,@b,@c,@d,@e,@f,@g,@h,@i,@j,@k,@maritalstatus,@PrimeryTradeId,@SecondoryTradeId,@Source,@Notes,@StatusReason,@GeneralLiability
			,@PCLiscense,@WorkerComp,@HireDate,@TerminitionDate,@WorkersCompCode,@NextReviewDate,@EmpType,@LastReviewDate
			,@PayRates,@ExtraEarning,@ExtraEarningAmt,@PayMethod,@Deduction,@DeductionType,@AbaAccountNo,@AccountNo,@AccountType,@InstallId,@PTradeOthers,@STradeOthers
			,@DeductionReason,@SuiteAptRoom,@FullTimePosition,@ContractorsBuilderOwner,@MajorTools,@DrugTest,@ValidLicense,@TruckTools,@PrevApply,@LicenseStatus
			,@CrimeStatus,@StartDate,@SalaryReq,@Avialability,@ResumePath,@skillassessmentstatus,@assessmentPath,@WarrentyPolicy,@CirtificationTraining,@businessYrs
			,@underPresentComp,@websiteaddress,@PersonName,@PersonType,@CompanyPrinciple,@UserType,@Email2,@Phone2,@CompanyName,@SourceUser,@DateSourced,@InstallerType
			,@BusinessType,@CEO,@LegalOfficer,@President,@Owner,@AllParteners,@MailingAddress,@Warrantyguarantee,@WarrantyYrs,@MinorityBussiness,@WomensEnterprise,@InterviewTime
			,@ActivationDate,@UserActivated,@LIBC,@CruntEmployement,@CurrentEmoPlace,@LeavingReason,@CompLit,@FELONY,@shortterm,@LongTerm,@BestCandidate,@TalentVenue
			,@Boardsites,@NonTraditional,@ConSalTraning,@BestTradeOne,@BestTradeTwo,@BestTradeThree,@aOne,@aOneTwo,@bOne,@cOne,@aTwo,@aTwoTwo,@bTwo,@cTwo,@aThree,@aThreeTwo
			,@bThree,@cThree,@RejectionDate,@RejectionTime,@RejectedUserId,@TC,@ExtraIncomeType
			,@PositionAppliedFor,@DesignationID , @PhoneExtNo , @PhoneISDCode
		) 

	SELECT @Id = SCOPE_IDENTITY();

	SELECT @MaxId = MAX(Id) FROM tblInstallUsers

	INSERT INTO [tblInstalledReport]
	([SourceId],[InstallerId],[Status])
	VALUES(Cast(@SourceUser as int),@MaxId,@status)

	IF @status = 'InterviewDate' OR @status = 'Interview Date'
	BEGIN
		INSERT INTO tbl_AnnualEvents(EventName,EventDate,EventAddedBy,ApplicantId)
		VALUES('InterViewDetails',@StatusReason,@AddedBy,@MaxId)--CAST(@SourceUser as int)(Added by Sandeep...)
	END

	SET @result ='1'  
  
	RETURN @result  
  
 END



 /****** Object:  StoredProcedure [dbo].[UDP_UpdateInstallUsers]    Script Date: 12/15/2016 8:44:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[UDP_UpdateInstallUsers]  
	@id int,  
	@FristName varchar(50),  
	@LastName varchar(50),  
	@Email varchar(100),  
	@phone varchar(50),  
	@Address varchar(20),  
	@Zip varchar(10),  
	@State varchar(30),  
	@City varchar(30),  
	@password varchar(30),
	@designation varchar(30),
	@status varchar(30),
	@Picture varchar(max),  
	@attachement varchar(max),
	@bussinessname varchar(100),
	@ssn varchar(20),
	@ssn1 varchar(20),
	@ssn2 varchar(20),
	@signature varchar(25),
	@dob varchar(20),  
	@citizenship varchar(50),
	@ein1 varchar(20),
	@ein2 varchar(20), 
	@a varchar(20),
	@b varchar(20),
	@c varchar(20),
	@d varchar(20),
	@e varchar(20),
	@f varchar(20),
	@g varchar(20),
	@h varchar(20),
	@i varchar(20),
	@j varchar(20),
	@k varchar(20),
	@maritalstatus varchar(20),
	@PrimeryTradeId int = 0,
	@SecondoryTradeId int = 0,
	@Source	varchar(MAX)='',
	@Notes	varchar(MAX)='',
	@StatusReason varchar(MAX)='',
	@GeneralLiability	varchar(MAX) = '',
	@PCLiscense	varchar(MAX) = '',
	@WorkerComp	varchar(MAX) = '',
	@HireDate varchar(50) = '',
	@TerminitionDate varchar(50) = '',
	@WorkersCompCode varchar(20) = '',
	@NextReviewDate	varchar(50) = '',
	@EmpType varchar(50) = '',
	@LastReviewDate	varchar(50) = '',
	@PayRates varchar(50) = '',
	@ExtraEarning varchar(MAX) = '',
	@ExtraEarningAmt varchar(MAX) = 0,
	@PayMethod varchar(50) = '',
	@Deduction VARCHAR(MAX) = 0,
	@DeductionType varchar(50) = '',
	@AbaAccountNo varchar(50) = '',
	@AccountNo varchar(50) = '',
	@AccountType varchar(50) = '',
	@PTradeOthers varchar(100) = '',
	@STradeOthers varchar(100) = '',
	@DeductionReason varchar(MAX) = '',
	@SuiteAptRoom varchar(10) = '',
	@FullTimePosition int = 0,
	@ContractorsBuilderOwner VARCHAR(500) = '',
	@MajorTools VARCHAR(250) = '',
	@DrugTest bit = null,
	@ValidLicense bit = null,
	@TruckTools bit = null,
	@PrevApply bit = null,
	@LicenseStatus bit = null,
	@CrimeStatus bit = null,
	@StartDate VARCHAR(50) = '',
	@SalaryReq VARCHAR(50) = '',
	@Avialability VARCHAR(50) = '',
	@ResumePath VARCHAR(MAX) = '',
	@skillassessmentstatus bit = null,
	@assessmentPath VARCHAR(MAX) = '',
	@WarrentyPolicy  VARCHAR(50) = '',
	@CirtificationTraining VARCHAR(MAX) = '',
	@businessYrs decimal = 0,
	@underPresentComp decimal = 0,
	@websiteaddress VARCHAR(MAX) = '',
	@PersonName VARCHAR(MAX) = '',
	@PersonType VARCHAR(MAX) = '',
	@CompanyPrinciple VARCHAR(MAX) = '',
	@UserType VARCHAR(25) = '',
	@Email2	varchar(70)	= '',
	@Phone2	varchar(70)	= '',
	@CompanyName	varchar(100) = '',
	@SourceUser	varchar(10)	= '',
	@DateSourced	varchar(50)	= '',
	@InstallerType VARCHAR(20) = '',
	@BusinessType varchar(50) = '',
	@CEO varchar(100) = '',
	@LegalOfficer	varchar(100) = '',
	@President	varchar(100) = '',
	@Owner	varchar(100) = '',
	@AllParteners	varchar(MAX) = '',
	@MailingAddress	varchar(100) = '',
	@Warrantyguarantee	bit = null,
	@WarrantyYrs	int = 0,
	@MinorityBussiness	bit = null,
	@WomensEnterprise	bit = null,
	@InterviewTime varchar(20) ='',
	@LIBC VARCHAR(5) = '',
	@Flag int = 0,

	@CruntEmployement bit = null,
	@CurrentEmoPlace varchar(100) = '',
	@LeavingReason varchar(MAX) = '',
	@CompLit bit = null,
	@FELONY	bit = null,
	@shortterm	varchar(250) = '',
	@LongTerm	varchar(250) = '',
	@BestCandidate	varchar(MAX) = '',
	@TalentVenue	varchar(MAX) = '',
	@Boardsites	varchar(300) = '',
	@NonTraditional	varchar(MAX) = '',
	@ConSalTraning	varchar(100) = '',
	@BestTradeOne	varchar(50) = '',
	@BestTradeTwo	varchar(50) = '',
	@BestTradeThree	varchar(50) = '',

	@aOne	varchar(50)	= '',
	@aOneTwo	varchar(50)	= '',
	@bOne	varchar(50)	= '',
	@cOne	varchar(50)	= '',
	@aTwo	varchar(50)	= '',
	@aTwoTwo	varchar(50)	= '',
	@bTwo	varchar(50)	= '',
	@cTwo	varchar(50)	= '',
	@aThree	varchar(50)	= '',
	@aThreeTwo	varchar(50)	= '',
	@bThree	varchar(50)	= '',
	@cThree	varchar(50)	= '',
	@RejectionDate	varchar(50)	='',
	@RejectionTime	varchar(50)	='',
	@RejectedUserId  int = 0,
	@TC bit = null,
	@ExtraIncomeType varchar(MAX) = '',
	@PositionAppliedFor varchar(50) = '',
	@PhoneISDCode VARCHAR(10),
	@PhoneExtNo VARCHAR(30),
	@AddedBy int = 0,
	@DesignationID int=0,
	@result int output  
AS 
BEGIN  
	
	IF(Select ID FROM tblInstallUsers WHERE Id=@id) IS NOT NULL
	BEGIN
		UPDATE tblInstallUsers 
		SET 
		FristName=@FristName,LastName=@LastName,Email=@Email,Phone=@phone,[Address]=@Address,Zip=@Zip,
		[State]=@State,City=@City,[Password]=@password,Designation=@designation,
		[Status]=@status,Picture=@Picture,Attachements=@attachement,Bussinessname=@bussinessname,SSN=@ssn,SSN1=@ssn1,SSN2=@ssn2,[Signature]=@signature,DOB=@dob,
		Citizenship=@citizenship,EIN1=@ein1,EIN2=@ein2,A=@a,B=@b,C=@c,D=@d,E=@e,F=@f,G=@g,H=@h,[5]=@i,[6]=@j,[7]=@k,
		maritalstatus=@maritalstatus,
		PrimeryTradeId=@PrimeryTradeId,
		SecondoryTradeId=@SecondoryTradeId,
		[Source] = @Source,
		Notes = @Notes,
		StatusReason = @StatusReason,
		GeneralLiability = @GeneralLiability,
		PCLiscense = @PCLiscense,
		WorkerComp = @WorkerComp,
		HireDate = @HireDate,
		TerminitionDate = @TerminitionDate,
		WorkersCompCode = @WorkersCompCode,
		NextReviewDate = @NextReviewDate,
		EmpType = @EmpType,
		LastReviewDate = @LastReviewDate,
		PayRates = @PayRates,
		ExtraEarning = @ExtraEarning,
		ExtraEarningAmt = @ExtraEarningAmt,
		PayMethod = @PayMethod,
		Deduction = @Deduction,
		AbaAccountNo = @AbaAccountNo ,
		AccountNo = @AccountNo,
		AccountType = @AccountType,
		DeductionType = @DeductionType,
		PTradeOthers = @PTradeOthers,
		STradeOthers = @STradeOthers,
		DeductionReason = @DeductionReason,
		SuiteAptRoom = @SuiteAptRoom,
		FullTimePosition = @FullTimePosition
		,ContractorsBuilderOwner = @ContractorsBuilderOwner
		,MajorTools = @MajorTools
		,DrugTest = @DrugTest
		,ValidLicense = @ValidLicense
		,TruckTools = @TruckTools
		,PrevApply = @PrevApply
		,LicenseStatus = @LicenseStatus
		,CrimeStatus = @CrimeStatus
		,StartDate = @StartDate
		,SalaryReq = @SalaryReq
		,Avialability = @Avialability
		,ResumePath = @ResumePath
		,skillassessmentstatus = @skillassessmentstatus
		,assessmentPath = @assessmentPath
		,WarrentyPolicy = @WarrentyPolicy
		,CirtificationTraining = @CirtificationTraining
		,businessYrs = @businessYrs
		,underPresentComp = @underPresentComp
		,websiteaddress = @websiteaddress
		,PersonName = @PersonName
		,PersonType = @PersonType
		,CompanyPrinciple = @CompanyPrinciple
		,UserType = @UserType
		,Email2 = @Email2
		,Phone2 = @Phone2
		,CompanyName = @CompanyName
		,SourceUser = @SourceUser
		,DateSourced = @DateSourced
		,InstallerType = @InstallerType
		,BusinessType = @BusinessType
		,CEO = @CEO
		,LegalOfficer = @LegalOfficer
		,President = @President
		,[Owner] = @Owner
		,AllParteners = @AllParteners
		,MailingAddress = @MailingAddress
		,Warrantyguarantee = @Warrantyguarantee
		,WarrantyYrs = @WarrantyYrs
		,MinorityBussiness = @MinorityBussiness
		,WomensEnterprise = @WomensEnterprise
		,InterviewTime = @InterviewTime 
		,LIBC = @LIBC
		,CruntEmployement = @CruntEmployement,
		CurrentEmoPlace = @CurrentEmoPlace,
		LeavingReason = @LeavingReason,
		CompLit = @CompLit,
		FELONY = @FELONY,
		shortterm = @shortterm,
		LongTerm = @LongTerm,
		BestCandidate = @BestCandidate,
		TalentVenue = @TalentVenue,
		Boardsites = @Boardsites,
		NonTraditional = @NonTraditional,
		ConSalTraning = @ConSalTraning,
		BestTradeOne =  @BestTradeOne,
		BestTradeTwo = @BestTradeTwo,
		BestTradeThree = @BestTradeThree,

		aOne = @aOne,aOneTwo = @aOneTwo,bOne = @bOne,cOne = @cOne,aTwo = @aTwo,aTwoTwo = @aTwoTwo,bTwo = @bTwo,cTwo = @cTwo,aThree = @aThree,aThreeTwo = @aThreeTwo,
		bThree = @bThree,cThree = @cThree,

		RejectionDate = @RejectionDate,RejectionTime = @RejectionTime,RejectedUserId = @RejectedUserId,
		TC = @TC,ExtraIncomeType = @ExtraIncomeType,
		PositionAppliedFor = @PositionAppliedFor,
		DesignationID=@DesignationID
		,PhoneISDCode = @PhoneISDCode
                ,PhoneExtNo = @PhoneExtNo
		WHERE Id=@id  

		IF @Flag <> 0
		BEGIN
			INSERT INTO [tblInstalledReport]([SourceId],[InstallerId],[Status])
			VALUES(Cast(@SourceUser as int),@id,@status)
		END

		IF @status = 'InterviewDate' OR @status = 'Interview Date'
		BEGIN
			--UPDATE tbl_AnnualEvents SET EventDate=@StatusReason where ApplicantId=@id
			INSERT tbl_AnnualEvents (EventName,EventDate,EventAddedBy,ApplicantId)values('InterViewDetails',@StatusReason,@AddedBy,@id)		
		END

		SET @result ='1'  

	END
	ELSE
	BEGIN         
		SET @result ='0'        
	END  
		
	RETURN @result  
 END
--modified/created by Other Party





/****** Object:  StoredProcedure [dbo].[Sp_InsertUpdateUserPhone]    Script Date: 12/16/2016 10:04:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================= 
 -- Description:	Insert/ Update User Phone
-- =============================================
ALTER PROCEDURE [dbo].[Sp_InsertUpdateUserPhone] 
	-- Add the parameters for the stored procedure here
	@isPrimaryPhone bit,
	@phoneText varchar(256),
	@phoneType varchar(50),
	@UserID int,
	@PhoneExtNo varchar(50),
	@PhoneISDCode varchar(50),
	@ClearPastRecord bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if (@ClearPastRecord = 1)
	BEGIN
		DELETE FROM tblUserPhone WHERE UserID = @UserID
	END
ELSE
  BEGIN
    INSERT INTO [dbo].[tblUserPhone]
           ([Phone]
           ,[IsPrimary]
           ,[PhoneTypeID]
           ,[UserID]
		   ,[PhoneExtNo]
		   ,[PhoneISDCode])
     VALUES
           (@phoneText
           ,@isPrimaryPhone
           ,@phoneType
           ,@UserID
		   ,@PhoneExtNo
		   ,@PhoneISDCode)
  END	
END


SET ANSI_NULLS ON



/****** Object:  StoredProcedure [dbo].[UDP_GETInstallUserDetails]    Script Date: 12/16/2016 10:14:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[UDP_GETInstallUserDetails]
	@id int
As 
BEGIN

	SELECT Id,FristName,Lastname,Email,[Address],Designation,
	[Status],[Password],Phone,Picture,Attachements,zip,[state],city,
	Bussinessname,SSN,SSN1,SSN2,[Signature],DOB,Citizenship,' ',
	EIN1,EIN2,A,B,C,D,E,F,G,H,[5],[6],[7],maritalstatus,PrimeryTradeId,SecondoryTradeId,Source,Notes,StatusReason,GeneralLiability,PCLiscense,WorkerComp,HireDate,TerminitionDate,WorkersCompCode,NextReviewDate,EmpType,LastReviewDate,PayRates,ExtraEarning,ExtraEarningAmt,PayMethod,Deduction,DeductionType,AbaAccountNo,AccountNo,AccountType,PTradeOthers,
	STradeOthers,DeductionReason,InstallId,SuiteAptRoom,FullTimePosition,ContractorsBuilderOwner,MajorTools,DrugTest,ValidLicense,TruckTools,PrevApply,LicenseStatus,CrimeStatus,StartDate,SalaryReq,Avialability,ResumePath,skillassessmentstatus,assessmentPath,WarrentyPolicy,CirtificationTraining,businessYrs,underPresentComp,websiteaddress,PersonName,PersonType,CompanyPrinciple,UserType,Email2,Phone2,CompanyName,SourceUser,DateSourced,InstallerType,BusinessType,CEO,LegalOfficer,President,Owner,AllParteners,MailingAddress,Warrantyguarantee,WarrantyYrs,MinorityBussiness,WomensEnterprise,InterviewTime,CruntEmployement,CurrentEmoPlace,LeavingReason,CompLit,FELONY,shortterm,LongTerm,BestCandidate,TalentVenue,Boardsites,NonTraditional,ConSalTraning,BestTradeOne,BestTradeTwo,BestTradeThree
	,aOne,aOneTwo,bOne,cOne,aTwo,aTwoTwo,bTwo,cTwo,aThree,aThreeTwo,bThree,cThree,TC,ExtraIncomeType,RejectionDate ,UserInstallId
        ,PositionAppliedFor, PhoneExtNo, PhoneISDCode ,DesignationID
	DesignationID
	FROM tblInstallUsers 
	WHERE ID=@id

END


-------------------------------------------------------------------------------------------

GO

ALTER TABLE tblUserTouchPointLog
ADD CurrentUserGUID VARCHAR(40)


GO



GO
/****** Object:  StoredProcedure [dbo].[Sp_InsertTouchPointLog]    Script Date: 12/16/2016 3:22:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Bhavik J. Vaishnani
-- Create date: 29-11-2016
-- Description:	Insert value of Touch Point log
-- =============================================
ALTER PROCEDURE [dbo].[Sp_InsertTouchPointLog] 
	-- Add the parameters for the stored procedure here
	@userID int = 0, 
	@loginUserID int = 0
	, @loginUserInstallID varchar (50) =''
	, @LogTime datetime
	, @changeLog varchar(max)
	,@CurrGUID varchar(40)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[tblUserTouchPointLog]
           ([UserID]  ,[UpdatedByUserID] ,[UpdatedUserInstallID]
           ,[ChangeDateTime]
           ,[LogDescription]
		   ,[CurrentUserGUID])
     VALUES
           (@userID , @loginUserID ,@loginUserInstallID            
           , @LogTime
           ,@changeLog
		   ,@CurrGUID)
END


/****** Object:  StoredProcedure [dbo].[Sp_UpdateNewUserIDInTouchPointLog]    Script Date: 12/16/2016 3:47:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Bhavik J
-- Create date: 
-- Description:	Update Guid of New user From And set GUID a
-- =============================================
CREATE PROCEDURE [dbo].[Sp_UpdateNewUserIDInTouchPointLog] 
	-- Add the parameters for the stored procedure here
	@NewuserID int , 
	@CurrGUID VARCHAR(40)  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE tblUserTouchPointLog 

	SET UserID = @NewuserID
	WHERE CurrentUserGUID = @CurrGUID

END

GO




GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Bhavik J.
-- Create date: 15 - 12- 2016
-- Description:	Get Data of Touch Point Log
-- =============================================
CREATE PROCEDURE [dbo].[Sp_GetTouchPointLogDataByGUID]
	-- Add the parameters for the stored procedure here 
	@CurrentGID VARCHAR(40)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * from tblUserTouchPointLog where CurrentUserGUID = @CurrentGID
	
	END