
GO

--UPDATE tblInstallUsers SET UserInstallId = NULL WHERE ID = 780
GO
--UPDATE tblInstallUsers SET SourceUser = 780 WHERE SourceUser = ''
--UPDATE tblInstallUsers SET SourceUser = 780 WHERE SourceUser = 0
GO

UPDATE tblInstallUsers SET Source = 'JG - source' WHERE Source is NULL
UPDATE tblInstallUsers SET Source = 'JG - source' WHERE Source =''

GO
Update tblInstallUsers SET EmpType = '0' where EmpType IS NULL 


GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[tblMstCountry](
	[CountryID] [int] IDENTITY(1,1) NOT NULL,
	[CountryName] [varchar](50) NULL,
	[CountryCode] [varchar](15) NULL,
	[CountryISDCode] [varchar](10) NULL,
 CONSTRAINT [PK_tblMstCountry] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


GO

ALTER TABLE tblInstallUsers ADD CountryCode VARCHAR (15)


GO


GO

CREATE FUNCTION Fn_GetUserPrimaryOrDefaultPhone 
(	
	@UserID int
)
RETURNS Varchar(60)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(60)

	-- Add the T-SQL statements to compute the return value here

IF exists(SELECT UserPhoneID FROM tblUserPhone WHERE UserID = @UserID AND IsPrimary = 1)
	BEGIN
		 SELECT @Result = Phone +' $ ' + TUC.ContactName
		 FROM tblUserPhone TP
		 INNER JOIN	tblUserContact TUC ON TP.PhoneTypeID = UserContactID
		 WHERE UserID = @UserID AND IsPrimary = 1

	END
ELSE
	BEGIN
		SELECT @Result = Phone from tblInstallUsers where ID = @UserID 
	END
	 
	RETURN @Result

END
GO




















------------------------------------------------------------------------------------------------



GO
/****** Object:  StoredProcedure [dbo].[GetAllEditSalesUser]    Script Date: 12/28/2016 12:04:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Updated By :		Bhavik J. Vaishnani
-- Updated date: 22-12-2016
-- =============================================
--exec [GetAllEditSalesUser]
ALTER PROCEDURE [dbo].[GetAllEditSalesUser]
	-- Add the parameters for the stored procedure here
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT  
		t.Id,t.FristName,t.LastName,t.Phone,t.Zip,t.Designation,t.Status,t.HireDate,t.InstallId,t.picture, t.CreatedDateTime, Isnull(t.Source,'') AS Source,
		t.SourceUser, ISNULL(t.FristName +' '+ t.LastName,'')  AS AddedBy, U.Id As AddeBy_UserID , ISNULL (t.UserInstallId ,t.id) As UserInstallId ,
		InterviewDetail = case when (t.Status='InterviewDate' or t.Status='Interview Date') then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.InterviewTime,'') else '' end,
		RejectDetail = case when (t.Status='Rejected' ) then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.RejectionTime,'') + ' ' + '-' + coalesce(ru.LastName,'') else '' end,
		t.Email, t1.[UserInstallId] As AddedByUserInstallId
		, t1.Id As AddedById, mcq.[Aggregate] , t.EmpType , dbo.Fn_GetUserPrimaryOrDefaultPhone(t.Id) As PrimaryPhone, t.CountryCode, t.Resumepath
		--ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId

	FROM 
		tblInstallUsers t 
			LEFT OUTER JOIN tblInstallUsers U ON U.Id = t.SourceUser
			LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId=ru.Id
			LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id
			LEFT OUTER JOIN MCQ_Performance mcq on mcq.UserID = t.Id
	WHERE 
		(t.UserType = 'SalesUser' OR t.UserType = 'sales') 
			AND t.Status <> 'Deactive' 
	ORDER BY Id DESC
	
 
END

/****** Object:  StoredProcedure [dbo].[sp_GetHrData]    Script Date: 12/28/2016 12:02:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Updated By :	  Bhavik J. Vaishnani
-- Updated date:  21-12-2016
-- =============================================
--
ALTER PROCEDURE [dbo].[sp_GetHrData]
	@UserId int,
	@FromDate date = null,
	@ToDate date = null
AS
BEGIN
	
	SET NOCOUNT ON;

	IF @FromDate  IS NOT NULL AND @ToDate IS NOT NULL
	BEGIN
		IF(@UserId<>0)
		BEGIN
			SELECT 
				t.status,count(*)cnt 
			FROM 
				tblInstallUsers t 
					LEFT OUTER JOIN tblInstallUsers U ON U.Id = t.SourceUser
					
			WHERE 
				(t.UserType = 'SalesUser' OR t.UserType = 'sales') 
					AND U.Id=@UserId 
					AND CAST(t.CreatedDateTime as date) >= CAST( @FromDate  as date) 
					AND CAST(t.CreatedDateTime  as date) <= CAST( @ToDate  as date)
			GROUP BY t.status
		END
	ELSE 
		BEGIN
			SELECT 
				t.status,count(*)cnt 
			FROM 
				tblInstallUsers t 					   
			WHERE 
				(t.UserType = 'SalesUser' OR t.UserType = 'sales')
					AND CAST(t.CreatedDateTime as date) >= CAST( @FromDate  as date) 
					AND CAST(t.CreatedDateTime  as date) <= CAST( @ToDate  as date)
			GROUP BY t.status
		END
	
	
	IF(@UserId<>0)
		Begin
			SELECT 
				t.Id,t.FristName,t.LastName,t.Phone,t.Zip,t.Designation,t.Status,t.HireDate,t.InstallId,t.picture, t.CreatedDateTime, Isnull(t.Source,'') AS Source,
				t.SourceUser, ISNULL(t.FristName +' '+ t.LastName,'')  AS 'AddedBy' , ISNULL (t.UserInstallId ,t.id) As UserInstallId , 
				InterviewDetail = case when (t.Status='InterviewDate' or t.Status='Interview Date') then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.InterviewTime,'') else '' end,
				RejectDetail = case when (t.Status='Rejected' ) then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.RejectionTime,'') + ' ' + '-' + coalesce(ru.LastName,'') else '' end,
				t.Email, t.DesignationID, t1.[UserInstallId] As AddedByUserInstallId, t1.Id As AddedById
				, mcq.[Aggregate] , t.EmpType, dbo.Fn_GetUserPrimaryOrDefaultPhone(t.Id) As PrimaryPhone, t.CountryCode, t.Resumepath
				--ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId
			FROM 
				tblInstallUsers t 
					LEFT OUTER JOIN tblInstallUsers U ON U.Id = t.SourceUser
					LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId=ru.Id
					LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= t.Id	  
					LEFT OUTER JOIN MCQ_Performance mcq on mcq.UserID = t.Id
			WHERE 
				(t.UserType = 'SalesUser' OR t.UserType = 'sales') 
					AND t.Status <> 'Deactive' 
					AND t.Id=@UserId 
					AND CAST(t.CreatedDateTime as date) >= CAST( @FromDate  as date) 
					AND CAST (t.CreatedDateTime  as date) <= CAST( @ToDate  as date)
			ORDER BY Id DESC
		END
	Else
		BEGIN
			SELECT 
				t.Id,t.FristName,t.LastName,t.Phone,t.Zip,t.Designation,t.Status,t.HireDate,t.InstallId,t.picture, t.CreatedDateTime, Isnull(t.Source,'') AS Source,
				t.SourceUser, ISNULL(U.FristName + ' ' + U.LastName,'')  AS 'AddedBy' , ISNULL (t.UserInstallId ,t.id) As UserInstallId,	
				InterviewDetail = case when (t.Status='InterviewDate' or t.Status='Interview Date') 
				then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.InterviewTime,'') else '' end,
				RejectDetail = case when (t.Status='Rejected' ) then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.RejectionTime,'') + ' ' + '-' + coalesce(ru.LastName,'') else '' end,
				t.Email, t.DesignationID, t1.[UserInstallId] As AddedByUserInstallId, t1.Id As AddedById
				, mcq.[Aggregate], t.EmpType, dbo.Fn_GetUserPrimaryOrDefaultPhone(t.Id) As PrimaryPhone, t.CountryCode, t.Resumepath
				--ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId
			FROM 
				tblInstallUsers t 
					LEFT OUTER JOIN tblInstallUsers U ON U.Id = t.SourceUser
					LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId=ru.Id
					LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
					LEFT OUTER JOIN MCQ_Performance mcq on mcq.UserID = t.Id
			WHERE 
				(t.UserType = 'SalesUser' OR t.UserType = 'sales') 
					AND t.Status <> 'Deactive' 
					AND CAST(t.CreatedDateTime as date) >= CAST( @FromDate  as date) 
					ANd CAST(t.CreatedDateTime  as date) <= CAST( @ToDate  as date)
			ORDER BY Id DESC
		END
	END
	ELSE
	BEGIN 
		IF(@UserId<>0)
		BEGIN
			SELECT 
				t.status,count(*)cnt 
			FROM 
				tblInstallUsers t 
					LEFT OUTER JOIN tblInstallUsers U ON U.Id = t.SourceUser					
			WHERE 
				(t.UserType = 'SalesUser' OR t.UserType = 'sales') 
					AND U.Id=@UserId 
			GROUP BY t.status
		END
	ELSE 
		BEGIN
			SELECT 
				t.status,count(*)cnt 
			FROM 
				tblInstallUsers t 
					 
			WHERE 
				(t.UserType = 'SalesUser' OR t.UserType = 'sales')
			GROUP BY t.status
		END
	
	
	IF(@UserId<>0)
		Begin
			SELECT 
				t.Id,t.FristName,t.LastName,t.Phone,t.Zip,t.Designation,t.Status,t.HireDate,t.InstallId,t.picture, t.CreatedDateTime, Isnull(t.Source,'') AS Source,
				t.SourceUser, ISNULL(U.FristName + ' ' + U.LastName,'')  AS 'AddedBy' , ISNULL (t.UserInstallId ,t.id) As UserInstallId , 
				InterviewDetail = case when (t.Status='InterviewDate' or t.Status='Interview Date') then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.InterviewTime,'') else '' end,
				RejectDetail = case when (t.Status='Rejected' ) then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.RejectionTime,'') + ' ' + '-' + coalesce(ru.LastName,'') else '' end,
				t.Email, t.DesignationID, t1.[UserInstallId] As AddedByUserInstallId, t1.Id As AddedById 
				, mcq.[Aggregate], t.EmpType, dbo.Fn_GetUserPrimaryOrDefaultPhone(t.Id) As PrimaryPhone, t.CountryCode, t.Resumepath
				--ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId
			FROM 
				tblInstallUsers t 
					LEFT OUTER JOIN tblInstallUsers U ON U.Id = t.SourceUser
					LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId=ru.Id
					LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id	  
					LEFT OUTER JOIN MCQ_Performance mcq on mcq.UserID = t.Id
			WHERE 
				(t.UserType = 'SalesUser' OR t.UserType = 'sales') 
					AND t.Status <> 'Deactive' 
					AND U.Id=@UserId 
			ORDER BY Id DESC
		END
	Else
		BEGIN
			SELECT 
				t.Id,t.FristName,t.LastName,t.Phone,t.Zip,t.Designation,t.Status,t.HireDate,t.InstallId,t.picture, t.CreatedDateTime, Isnull(t.Source,'') AS Source,
				t.SourceUser, ISNULL(U.FristName + ' ' + U.LastName,'')  AS 'AddedBy' , ISNULL (t.UserInstallId ,t.id) As UserInstallId,	
				InterviewDetail = case when (t.Status='InterviewDate' or t.Status='Interview Date') 
				then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.InterviewTime,'') else '' end,
				RejectDetail = case when (t.Status='Rejected' ) then coalesce(t.RejectionDate,'') + ' ' + coalesce(t.RejectionTime,'') + ' ' + '-' + coalesce(ru.LastName,'') else '' end,
				t.Email, t.DesignationID, t1.[UserInstallId] As AddedByUserInstallId, t1.Id As AddedById 
				, mcq.[Aggregate], t.EmpType, dbo.Fn_GetUserPrimaryOrDefaultPhone(t.Id) As PrimaryPhone, t.CountryCode, t.Resumepath
				--ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId
			FROM 
				tblInstallUsers t 
					LEFT OUTER JOIN tblInstallUsers U ON U.Id = t.SourceUser
					LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId=ru.Id
					LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id
					LEFT OUTER JOIN MCQ_Performance mcq on mcq.UserID = t.Id			
			WHERE 
				(t.UserType = 'SalesUser' OR t.UserType = 'sales') 
					AND t.Status <> 'Deactive' 
			ORDER BY Id DESC
		END
	END

 
END



------------------------------------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Bhavik J. Vaishnani
-- Create date: 23 - 12 -2016
-- Description:	Get All Countrys
-- =============================================
CREATE PROCEDURE SP_GetAllCountry 
	-- Add the parameters for the stored procedure here	 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [CountryID], [CountryCode],[CountryName] FROM tblMstCountry
END
GO

















GO
/****** Object:  StoredProcedure [dbo].[UDP_GETInstallUserDetails]    Script Date: 12/23/2016 3:41:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Last Updated By : Bhavik J. Vaishnani
Desc : Added CountryCode
*/
--exec [UDP_GETInstallUserDetails] 1105
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
        ,PositionAppliedFor, PhoneExtNo, PhoneISDCode ,DesignationID, CountryCode
	
	FROM tblInstallUsers 
	WHERE ID=@id

END










GO
/****** Object:  StoredProcedure [dbo].[UDP_UpdateInstallUsers]    Script Date: 12/23/2016 3:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Last Updated By : Bhavik J. Vaishnani
Desc : Added @CountryCode
*/

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
	@CountryCode VARCHAR(15),
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
		, CountryCode = @CountryCode
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




GO
/****** Object:  StoredProcedure [dbo].[UDP_AddInstallUser]    Script Date: 12/23/2016 3:31:03 PM ******/
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
	@CountryCode VARCHAR(15),
	@Id int out,
	@result bit output  

AS 
BEGIN  

	DECLARE @MaxId int = 0

	INSERT INTO tblInstallUsers   
		(  
			FristName,LastName,Email,Phone,phonetype,[Address],Zip,[State],[City],
			

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
			,PositionAppliedFor,DesignationID ,PhoneExtNo ,PhoneISDCode, CountryCode
		)  
	VALUES  
		(  
			@FristName,@LastName,@Email,@phone,@phonetype,@address,@Zip,@State,@City,
			
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
			,@PositionAppliedFor,@DesignationID , @PhoneExtNo , @PhoneISDCode , @CountryCode
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
