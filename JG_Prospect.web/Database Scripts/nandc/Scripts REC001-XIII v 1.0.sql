
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Bhavik J.
-- Create date: 29 - 11- 2016
-- Updated By : Nand Chavan (Task ID#: REC001-XIII)
--                  Replace Source with SourceID
-- Description:	Get Data of Touch Point Log
-- =============================================
ALTER PROCEDURE [dbo].[Sp_GetTouchPointLogDataByUserID]
	-- Add the parameters for the stored procedure here 
	@userID int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT UserTouchPointLogID , UserID, UpdatedByUserID, UpdatedUserInstallID, ChangeDateTime, LogDescription, CurrentUserGUID 
	FROM tblUserTouchPointLog WITH (NOLOCK)
	WHERE UserID = @userID	
	
	UNION ALL

	--Task ID#: REC001-XIII
	SELECT TOP 1 UserTouchPointLogID = 99999, UserID = ID, UpdatedByUserID = ID, UpdatedUserInstallID = FristName + ' - ' + CAST(ID AS CHAR(10)), ChangeDateTime = CreatedDateTime, LogDescription = Notes, CurrentUserGUID = 0
	FROM tblInstallUsers WITH (NOLOCK)
	WHERE ID = @userID

END

GO
 -- =============================================    
-- Author:  Yogesh    
-- Create date: 23 Feb 2017  
-- Updated By : Yogesh  
--     Added applicant status to allow applicant to login.  
-- Updated By : Nand Chavan (Task ID#: REC001-XIII)
--                  Replace Source with SourceID
-- Description: Get an install user by email, pwd and status.  
-- =============================================  
ALTER PROCEDURE [dbo].[UDP_IsValidInstallerUser] 
	 @userid varchar(50),  
	 @password varchar(50),  
	 @ActiveStatus varchar(5) = '1',  
	 @ApplicantStatus varchar(5) = '2',  
	 @InterviewDateStatus varchar(5) = '5',  
	 @OfferMadeStatus varchar(5) = '6',  
	 @result int output  
AS  
BEGIN  
   
	DECLARE @phone varchar(1000) = @userid

	--REC001-XIII - create formatted phone#
	IF ISNUMERIC(@userid) = 1 AND LEN(@userid) > 5
	BEGIN
		SET @phone =  '(' + SUBSTRING(@phone, 1, 3) + ')-' + SUBSTRING(@phone, 4, 3) + '-' + SUBSTRING(@phone, 7, LEN(@phone))
	END

	IF EXISTS(  
		SELECT Id   
		FROM tblInstallUsers   
		WHERE   
		 (Email = @userid OR Phone = @userid OR Phone = @phone)
		 AND ISNULL(@userid, '') != ''
		 AND  
		 [Password] = @password AND   
		   (  
		  [Status] = @ActiveStatus OR   
		  [Status] = @ApplicantStatus OR   
		  [Status] = @InterviewDateStatus OR   
		  [Status] = @OfferMadeStatus  
		   )  
	   )  
	 BEGIN  
	  SET @result = 1  
	 END  
	 ELSE  
	 BEGIN  
	  SET @result=0  
	 END  
  
	 RETURN @result  
  
END  
GO

-- =============================================    
-- Author:  Yogesh    
-- Create date: 23 Feb 2017  
-- Updated By : Yogesh  
--     Added applicant status to allow applicant to login.  
-- Updated By : Nand Chavan (Task ID#: REC001-XIII)
--                  Replace Source with SourceID
-- Description: Get an install user by email and status.  
-- =============================================  
ALTER PROCEDURE [dbo].[UDP_GetInstallerUserDetailsByLoginId]  
 @loginId varchar(50) ,  
 @ActiveStatus varchar(5) = '1',  
 @ApplicantStatus varchar(5) = '2',  
 @InterviewDateStatus varchar(5) = '5',  
 @OfferMadeStatus varchar(5) = '6'  
AS  
BEGIN  

	DECLARE @phone varchar(1000) = @loginId

	--REC001-XIII - create formatted phone#
	IF ISNUMERIC(@loginId) = 1 AND LEN(@loginId) > 5
	BEGIN
		SET @phone =  '(' + SUBSTRING(@phone, 1, 3) + ')-' + SUBSTRING(@phone, 4, 3) + '-' + SUBSTRING(@phone, 7, LEN(@phone))
	END
	   
	 SELECT Id,FristName,Lastname,Email,Address,Designation,[Status],  
	  [Password],[Address],Phone,Picture,Attachements,usertype , Picture,IsFirstTime,DesignationID  
	 FROM tblInstallUsers   
	 WHERE   
	  (Email = @loginId OR Phone = @loginId  OR Phone = @phone) 
	  AND ISNULL(@loginId, '') != ''   AND
	  (  
	   [Status] = @ActiveStatus OR   
	   [Status] = @ApplicantStatus OR  
	   [Status] = @OfferMadeStatus OR   
	   [Status] = @InterviewDateStatus  
	  )  

END  
GO

-- ===================================================================================  
-- Author:  Yogesh  
-- Create date: 23 Feb 2017  
-- Updated By : Bhavik J. Vaishnani
--					 Added CountryCode
-- Updated By : Yogesh
--					Added designation join to support new as well as old structure.
-- Updated By : Nand Chavan (Task ID#: REC001-XIII)
--                  Get SourceID
-- Description: Get an install user by id.
-- ===================================================================================  
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
		SourceID
	
	FROM tblInstallUsers u 
			LEFT JOIN tbl_Designation d ON u.DesignationID = d.ID

	WHERE u.ID=@id

END
GO

-- ===================================================================================  
-- Author:    
-- Create date:  
-- Update By : Bhavik J . Vaishnani On 30-12-2016
--				Script Date: 12/30/2016
-- Updated By : Nand Chavan 
--                  Update SourceID (Task ID#: REC001-XIII)
-- Description: Update install user record.
-- ===================================================================================  
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
	@NameMiddleInitial VARCHAR (5) ,
	@IsEmailPrimaryEmail BIT ,
	@IsPhonePrimaryPhone BIT ,
	@IsEmailContactPreference BIT ,
	@IsCallContactPreference BIT ,
	@IsTextContactPreference BIT ,
	@IsMailContactPreference BIT ,
	@SourceID	INT = 0,

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
		, NameMiddleInitial = @NameMiddleInitial 
		, IsEmailPrimaryEmail =@IsEmailPrimaryEmail
		, IsPhonePrimaryPhone = @IsPhonePrimaryPhone 
		, IsEmailContactPreference = @IsEmailContactPreference 
		, IsCallContactPreference = @IsCallContactPreference 
		, IsTextContactPreference = @IsTextContactPreference 
		, IsMailContactPreference = @IsMailContactPreference,
		  SourceID = @SourceID
		WHERE 
			Id=@id  

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

 GO
-- ===================================================================================  
-- Author:    
-- Create date:  
--
-- Updated By : Nand Chavan 
--                  Update SourceID (Task ID#: REC001-XIII)
-- Description: Create install user record.
-- ===================================================================================  
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
	@NameMiddleInitial VARCHAR (5) ,
	@IsEmailPrimaryEmail BIT ,
	@IsPhonePrimaryPhone BIT ,
	@IsEmailContactPreference BIT ,
	@IsCallContactPreference BIT ,
	@IsTextContactPreference BIT ,
	@IsMailContactPreference BIT,
	@SourceID	INT = 0,

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
			,NameMiddleInitial, IsEmailPrimaryEmail, IsPhonePrimaryPhone, IsEmailContactPreference, IsCallContactPreference, IsTextContactPreference, IsMailContactPreference,
			SourceID
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
			, @NameMiddleInitial ,@IsEmailPrimaryEmail ,@IsPhonePrimaryPhone , @IsEmailContactPreference ,@IsCallContactPreference 
			, @IsTextContactPreference , @IsMailContactPreference,
			@SourceID 
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

  GO


