/*
   Wednesday, November 15, 20176:28:42 PM
   User: sa
   Server: 35.197.90.163
   Database: JGBS_Dev_New
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblShuttersEstimate
	DROP CONSTRAINT FK_tblShuttersEstimate_tblUsers
GO
ALTER TABLE dbo.tblcustomer_followup
	DROP CONSTRAINT FK_tblcustomer_followup_tblUsers
GO
ALTER TABLE dbo.tblUsers SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblUsers', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblUsers', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblUsers', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblShuttersEstimate
	DROP CONSTRAINT FK_tblShuttersEstimate_tblSurfaceMount
GO
ALTER TABLE dbo.tblSurfaceMount SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblSurfaceMount', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblSurfaceMount', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblSurfaceMount', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblShuttersEstimate
	DROP CONSTRAINT FK_tblShuttersEstimate_tblShutterWidth
GO
ALTER TABLE dbo.tblShutterWidth SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblShutterWidth', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblShutterWidth', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblShutterWidth', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblShuttersEstimate
	DROP CONSTRAINT FK_tblShuttersEstimate_tblShutterTop
GO
ALTER TABLE dbo.tblShutterTop SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblShutterTop', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblShutterTop', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblShutterTop', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblShuttersEstimate
	DROP CONSTRAINT FK_tblShuttersEstimate_tblShutters
GO
ALTER TABLE dbo.tblShutters SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblShutters', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblShutters', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblShutters', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblShuttersEstimate
	DROP CONSTRAINT FK_tblShuttersEstimate_tblShutterColor
GO
ALTER TABLE dbo.tblShutterColor SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblShutterColor', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblShutterColor', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblShutterColor', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblCustomer
	DROP CONSTRAINT DF_new_customer_CreatedDate
GO
ALTER TABLE dbo.tblCustomer
	DROP CONSTRAINT DF_new_customer_ModifiedDate
GO
ALTER TABLE dbo.tblCustomer
	DROP CONSTRAINT DF_new_customer_IsFirstTime
GO
CREATE TABLE dbo.Tmp_tblCustomer
	(
	Id bigint NOT NULL IDENTITY (1, 1),
	CustomerName varchar(200) NULL,
	CustomerAddress varchar(5000) NULL,
	State varchar(20) NULL,
	City varchar(20) NULL,
	ZipCode varchar(20) NULL,
	JobLocation varchar(100) NULL,
	EstDateSchdule date NULL,
	EstTime varchar(50) NULL,
	CellPh varchar(20) NULL,
	HousePh varchar(20) NULL,
	Email varchar(250) NULL,
	CallTakenBy int NULL,
	Service varchar(500) NULL,
	AddedBy varchar(100) NULL,
	LeadType varchar(50) NULL,
	AlternatePh varchar(20) NULL,
	BillingAddress varchar(100) NULL,
	BestTimetocontact nvarchar(MAX) NULL,
	PrimaryContact varchar(20) NULL,
	ContactPreference varchar(20) NULL,
	PeriodId int NULL,
	AssignedToId int NULL,
	Map1 varchar(100) NULL,
	Map2 varchar(100) NULL,
	ReasonofClosed varchar(250) NULL,
	Status varchar(30) NULL,
	IsRepeated bit NULL,
	Missing_contacts int NULL,
	Followup_date varchar(20) NULL,
	CreatedDate date NULL,
	ModifiedDate date NULL,
	ProductOfInterest varchar(500) NULL,
	SecondaryProductOfInterest int NULL,
	ProjectManager varchar(100) NULL,
	lastname varchar(50) NULL,
	Email2 varchar(100) NULL,
	Email3 varchar(100) NULL,
	Disable bit NULL,
	Reason varchar(MAX) NULL,
	Password varchar(20) NULL,
	AdditionalEmail varchar(MAX) NULL,
	DateOfBirth varchar(50) NULL,
	AdditionalPhoneNo varchar(MAX) NULL,
	PhoneType varchar(MAX) NULL,
	AdditionalPhoneType varchar(MAX) NULL,
	oauth varchar(50) NULL,
	oid varchar(30) NULL,
	AccType varchar(50) NULL,
	ConPref varchar(100) NULL,
	strAddressType varchar(50) NULL,
	strContactType varchar(50) NULL,
	strBillingAddressType varchar(50) NULL,
	strCompetitorBids varchar(50) NULL,
	IsFirstTime bit NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblCustomer SET (LOCK_ESCALATION = TABLE)
GO
ALTER TABLE dbo.Tmp_tblCustomer ADD CONSTRAINT
	DF_new_customer_CreatedDate DEFAULT (getdate()) FOR CreatedDate
GO
ALTER TABLE dbo.Tmp_tblCustomer ADD CONSTRAINT
	DF_new_customer_ModifiedDate DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.Tmp_tblCustomer ADD CONSTRAINT
	DF_new_customer_IsFirstTime DEFAULT ((1)) FOR IsFirstTime
GO
SET IDENTITY_INSERT dbo.Tmp_tblCustomer ON
GO
IF EXISTS(SELECT * FROM dbo.tblCustomer)
	 EXEC('INSERT INTO dbo.Tmp_tblCustomer (Id, CustomerName, CustomerAddress, State, City, ZipCode, JobLocation, EstDateSchdule, EstTime, CellPh, HousePh, Email, CallTakenBy, Service, AddedBy, LeadType, AlternatePh, BillingAddress, BestTimetocontact, PrimaryContact, ContactPreference, PeriodId, AssignedToId, Map1, Map2, ReasonofClosed, Status, IsRepeated, Missing_contacts, Followup_date, CreatedDate, ModifiedDate, ProductOfInterest, SecondaryProductOfInterest, ProjectManager, lastname, Email2, Email3, Disable, Reason, Password, AdditionalEmail, DateOfBirth, AdditionalPhoneNo, PhoneType, AdditionalPhoneType, oauth, oid, AccType, ConPref, strAddressType, strContactType, strBillingAddressType, strCompetitorBids, IsFirstTime)
		SELECT CONVERT(bigint, id), CustomerName, CustomerAddress, State, City, ZipCode, JobLocation, EstDateSchdule, EstTime, CellPh, HousePh, Email, CallTakenBy, Service, AddedBy, LeadType, AlternatePh, BillingAddress, BestTimetocontact, PrimaryContact, ContactPreference, PeriodId, AssignedToId, Map1, Map2, ReasonofClosed, Status, IsRepeated, Missing_contacts, Followup_date, CreatedDate, ModifiedDate, ProductOfInterest, SecondaryProductOfInterest, ProjectManager, lastname, Email2, Email3, Disable, Reason, Password, AdditionalEmail, DateOfBirth, AdditionalPhoneNo, PhoneType, AdditionalPhoneType, oauth, oid, AccType, ConPref, strAddressType, strContactType, strBillingAddressType, strCompetitorBids, IsFirstTime FROM dbo.tblCustomer WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblCustomer OFF
GO
ALTER TABLE dbo.tblBillingAddress
	DROP CONSTRAINT FK__tblBillin__intCu__76EBA2E9
GO
ALTER TABLE dbo.tblCustomersDocument
	DROP CONSTRAINT FK_tblCustomersDocument_new_customer
GO
ALTER TABLE dbo.tblCustomerLocationPics
	DROP CONSTRAINT FK_tblCustomerLocationPics_new_customer
GO
ALTER TABLE dbo.tblShuttersEstimate
	DROP CONSTRAINT FK_tblShuttersEstimate_new_customer
GO
ALTER TABLE dbo.tblCustomersAddress
	DROP CONSTRAINT FK_tblCustomersAddress_new_customer
GO
ALTER TABLE dbo.tblcustomer_followup
	DROP CONSTRAINT FK_tblcustomer_followup_new_customer
GO
DROP TABLE dbo.tblCustomer
GO
EXECUTE sp_rename N'dbo.Tmp_tblCustomer', N'tblCustomer', 'OBJECT' 
GO
ALTER TABLE dbo.tblCustomer ADD CONSTRAINT
	PK_new_customer PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblCustomer', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblCustomer', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblCustomer', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblcustomer_followup
	DROP CONSTRAINT DF_tblcustomer_followup_CreatedOn
GO
CREATE TABLE dbo.Tmp_tblcustomer_followup
	(
	Id int NOT NULL IDENTITY (1, 1),
	CustomerId bigint NULL,
	MeetingDate datetime NULL,
	MeetingStatus nvarchar(1000) NULL,
	UserId int NULL,
	CreatedOn datetime NULL,
	EstimateId int NULL,
	ProductId smallint NULL,
	IsNote bit NULL,
	AssignedTo int NULL,
	FileName varchar(MAX) NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblcustomer_followup SET (LOCK_ESCALATION = TABLE)
GO
ALTER TABLE dbo.Tmp_tblcustomer_followup ADD CONSTRAINT
	DF_tblcustomer_followup_CreatedOn DEFAULT (getdate()) FOR CreatedOn
GO
SET IDENTITY_INSERT dbo.Tmp_tblcustomer_followup ON
GO
IF EXISTS(SELECT * FROM dbo.tblcustomer_followup)
	 EXEC('INSERT INTO dbo.Tmp_tblcustomer_followup (Id, CustomerId, MeetingDate, MeetingStatus, UserId, CreatedOn, EstimateId, ProductId, IsNote, AssignedTo, FileName)
		SELECT Id, CONVERT(bigint, CustomerId), MeetingDate, MeetingStatus, UserId, CreatedOn, EstimateId, ProductId, IsNote, AssignedTo, FileName FROM dbo.tblcustomer_followup WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblcustomer_followup OFF
GO
DROP TABLE dbo.tblcustomer_followup
GO
EXECUTE sp_rename N'dbo.Tmp_tblcustomer_followup', N'tblcustomer_followup', 'OBJECT' 
GO
ALTER TABLE dbo.tblcustomer_followup ADD CONSTRAINT
	PK_tblcustomer_followup PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tblcustomer_followup ADD CONSTRAINT
	FK_tblcustomer_followup_tblUsers FOREIGN KEY
	(
	UserId
	) REFERENCES dbo.tblUsers
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblcustomer_followup ADD CONSTRAINT
	FK_tblcustomer_followup_new_customer FOREIGN KEY
	(
	CustomerId
	) REFERENCES dbo.tblCustomer
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblcustomer_followup', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblcustomer_followup', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblcustomer_followup', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tblCustomersAddress
	(
	intAddressId int NOT NULL IDENTITY (1, 1),
	intCustomerId bigint NOT NULL,
	strAddress nvarchar(MAX) NOT NULL,
	strZipCode nvarchar(10) NOT NULL,
	strAddressType nvarchar(100) NULL,
	strCity nvarchar(100) NULL,
	strState nvarchar(100) NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblCustomersAddress SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tblCustomersAddress ON
GO
IF EXISTS(SELECT * FROM dbo.tblCustomersAddress)
	 EXEC('INSERT INTO dbo.Tmp_tblCustomersAddress (intAddressId, intCustomerId, strAddress, strZipCode, strAddressType, strCity, strState)
		SELECT intAddressId, CONVERT(bigint, intCustomerId), strAddress, strZipCode, strAddressType, strCity, strState FROM dbo.tblCustomersAddress WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblCustomersAddress OFF
GO
DROP TABLE dbo.tblCustomersAddress
GO
EXECUTE sp_rename N'dbo.Tmp_tblCustomersAddress', N'tblCustomersAddress', 'OBJECT' 
GO
ALTER TABLE dbo.tblCustomersAddress ADD CONSTRAINT
	PK_tblCustomersAddress PRIMARY KEY CLUSTERED 
	(
	intAddressId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tblCustomersAddress ADD CONSTRAINT
	FK_tblCustomersAddress_new_customer FOREIGN KEY
	(
	intCustomerId
	) REFERENCES dbo.tblCustomer
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblCustomersAddress', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblCustomersAddress', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblCustomersAddress', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblShuttersEstimate
	DROP CONSTRAINT DF_tblShuttersEstimate_TotalPrice
GO
ALTER TABLE dbo.tblShuttersEstimate
	DROP CONSTRAINT DF_tblShuttersEstimate_Createddate
GO
CREATE TABLE dbo.Tmp_tblShuttersEstimate
	(
	Id int NOT NULL IDENTITY (1, 1),
	CustomerId bigint NULL,
	UserId int NULL,
	ShutterId int NULL,
	ShutterTopId int NULL,
	ShutterWidthId int NULL,
	ShutterLength varchar(20) NULL,
	ShutterColorId int NULL,
	Quantity int NULL,
	SurfaceMountId int NULL,
	WorkArea varchar(100) NULL,
	Style varchar(50) NULL,
	SpecialInstruction varchar(MAX) NULL,
	LocationPicture varchar(200) NULL,
	Status varchar(50) NULL,
	TotalPrice numeric(18, 2) NULL,
	Createddate datetime NULL,
	Modifieddate datetime NULL,
	TransactionId varchar(100) NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblShuttersEstimate SET (LOCK_ESCALATION = TABLE)
GO
ALTER TABLE dbo.Tmp_tblShuttersEstimate ADD CONSTRAINT
	DF_tblShuttersEstimate_TotalPrice DEFAULT ((0.00)) FOR TotalPrice
GO
ALTER TABLE dbo.Tmp_tblShuttersEstimate ADD CONSTRAINT
	DF_tblShuttersEstimate_Createddate DEFAULT (getdate()) FOR Createddate
GO
SET IDENTITY_INSERT dbo.Tmp_tblShuttersEstimate ON
GO
IF EXISTS(SELECT * FROM dbo.tblShuttersEstimate)
	 EXEC('INSERT INTO dbo.Tmp_tblShuttersEstimate (Id, CustomerId, UserId, ShutterId, ShutterTopId, ShutterWidthId, ShutterLength, ShutterColorId, Quantity, SurfaceMountId, WorkArea, Style, SpecialInstruction, LocationPicture, Status, TotalPrice, Createddate, Modifieddate, TransactionId)
		SELECT Id, CONVERT(bigint, CustomerId), UserId, ShutterId, ShutterTopId, ShutterWidthId, ShutterLength, ShutterColorId, Quantity, SurfaceMountId, WorkArea, Style, SpecialInstruction, LocationPicture, Status, TotalPrice, Createddate, Modifieddate, TransactionId FROM dbo.tblShuttersEstimate WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblShuttersEstimate OFF
GO
DROP TABLE dbo.tblShuttersEstimate
GO
EXECUTE sp_rename N'dbo.Tmp_tblShuttersEstimate', N'tblShuttersEstimate', 'OBJECT' 
GO
ALTER TABLE dbo.tblShuttersEstimate ADD CONSTRAINT
	PK_tblShuttersEstimate PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tblShuttersEstimate ADD CONSTRAINT
	FK_tblShuttersEstimate_tblShutterColor FOREIGN KEY
	(
	ShutterColorId
	) REFERENCES dbo.tblShutterColor
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblShuttersEstimate ADD CONSTRAINT
	FK_tblShuttersEstimate_tblShutters FOREIGN KEY
	(
	ShutterId
	) REFERENCES dbo.tblShutters
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblShuttersEstimate ADD CONSTRAINT
	FK_tblShuttersEstimate_tblShutterTop FOREIGN KEY
	(
	ShutterTopId
	) REFERENCES dbo.tblShutterTop
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblShuttersEstimate ADD CONSTRAINT
	FK_tblShuttersEstimate_tblShutterWidth FOREIGN KEY
	(
	ShutterWidthId
	) REFERENCES dbo.tblShutterWidth
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblShuttersEstimate ADD CONSTRAINT
	FK_tblShuttersEstimate_tblSurfaceMount FOREIGN KEY
	(
	SurfaceMountId
	) REFERENCES dbo.tblSurfaceMount
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblShuttersEstimate ADD CONSTRAINT
	FK_tblShuttersEstimate_tblUsers FOREIGN KEY
	(
	UserId
	) REFERENCES dbo.tblUsers
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblShuttersEstimate ADD CONSTRAINT
	FK_tblShuttersEstimate_new_customer FOREIGN KEY
	(
	CustomerId
	) REFERENCES dbo.tblCustomer
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblShuttersEstimate', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblShuttersEstimate', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblShuttersEstimate', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblCustomerLocationPics
	DROP CONSTRAINT DF_tblCustomerLocationPics_UploadedDate
GO
CREATE TABLE dbo.Tmp_tblCustomerLocationPics
	(
	Id int NOT NULL IDENTITY (1, 1),
	CustomerId bigint NULL,
	PictureName varchar(150) NULL,
	UploadedDate datetime NULL,
	ProductId int NULL,
	ProductTypeId int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblCustomerLocationPics SET (LOCK_ESCALATION = TABLE)
GO
ALTER TABLE dbo.Tmp_tblCustomerLocationPics ADD CONSTRAINT
	DF_tblCustomerLocationPics_UploadedDate DEFAULT (getdate()) FOR UploadedDate
GO
SET IDENTITY_INSERT dbo.Tmp_tblCustomerLocationPics ON
GO
IF EXISTS(SELECT * FROM dbo.tblCustomerLocationPics)
	 EXEC('INSERT INTO dbo.Tmp_tblCustomerLocationPics (Id, CustomerId, PictureName, UploadedDate, ProductId, ProductTypeId)
		SELECT Id, CONVERT(bigint, CustomerId), PictureName, UploadedDate, ProductId, ProductTypeId FROM dbo.tblCustomerLocationPics WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblCustomerLocationPics OFF
GO
DROP TABLE dbo.tblCustomerLocationPics
GO
EXECUTE sp_rename N'dbo.Tmp_tblCustomerLocationPics', N'tblCustomerLocationPics', 'OBJECT' 
GO
ALTER TABLE dbo.tblCustomerLocationPics ADD CONSTRAINT
	PK_tblCustomerLocationPics PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tblCustomerLocationPics ADD CONSTRAINT
	FK_tblCustomerLocationPics_new_customer FOREIGN KEY
	(
	CustomerId
	) REFERENCES dbo.tblCustomer
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblCustomerLocationPics', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblCustomerLocationPics', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblCustomerLocationPics', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tblCustomersDocument
	(
	Id int NOT NULL IDENTITY (1, 1),
	CustomerId bigint NULL,
	ProductId int NULL,
	DocName varchar(100) NULL,
	DocType varchar(20) NULL,
	CreatedOn datetime NULL,
	TempName varchar(100) NULL,
	ProductTypeId int NULL,
	VendorId int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblCustomersDocument SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tblCustomersDocument ON
GO
IF EXISTS(SELECT * FROM dbo.tblCustomersDocument)
	 EXEC('INSERT INTO dbo.Tmp_tblCustomersDocument (Id, CustomerId, ProductId, DocName, DocType, CreatedOn, TempName, ProductTypeId, VendorId)
		SELECT Id, CONVERT(bigint, CustomerId), ProductId, DocName, DocType, CreatedOn, TempName, ProductTypeId, VendorId FROM dbo.tblCustomersDocument WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblCustomersDocument OFF
GO
DROP TABLE dbo.tblCustomersDocument
GO
EXECUTE sp_rename N'dbo.Tmp_tblCustomersDocument', N'tblCustomersDocument', 'OBJECT' 
GO
ALTER TABLE dbo.tblCustomersDocument ADD CONSTRAINT
	PK_tblCustomersDocument PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tblCustomersDocument ADD CONSTRAINT
	FK_tblCustomersDocument_new_customer FOREIGN KEY
	(
	CustomerId
	) REFERENCES dbo.tblCustomer
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblCustomersDocument', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblCustomersDocument', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblCustomersDocument', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tblBillingAddress
	(
	intCustomerId bigint NOT NULL,
	strAddressType nvarchar(50) NULL,
	strBillingAddress nvarchar(MAX) NULL,
	intBillingAddress int NOT NULL IDENTITY (1, 1)
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblBillingAddress SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tblBillingAddress ON
GO
IF EXISTS(SELECT * FROM dbo.tblBillingAddress)
	 EXEC('INSERT INTO dbo.Tmp_tblBillingAddress (intCustomerId, strAddressType, strBillingAddress, intBillingAddress)
		SELECT CONVERT(bigint, intCustomerId), strAddressType, strBillingAddress, intBillingAddress FROM dbo.tblBillingAddress WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblBillingAddress OFF
GO
DROP TABLE dbo.tblBillingAddress
GO
EXECUTE sp_rename N'dbo.Tmp_tblBillingAddress', N'tblBillingAddress', 'OBJECT' 
GO
ALTER TABLE dbo.tblBillingAddress ADD CONSTRAINT
	PK__tblBilli__63D72DD4570D9C33 PRIMARY KEY CLUSTERED 
	(
	intBillingAddress
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tblBillingAddress ADD CONSTRAINT
	FK__tblBillin__intCu__76EBA2E9 FOREIGN KEY
	(
	intCustomerId
	) REFERENCES dbo.tblCustomer
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblBillingAddress', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblBillingAddress', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblBillingAddress', 'Object', 'CONTROL') as Contr_Per 


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
   Wednesday, November 15, 20176:28:42 PM
   User: sa
   Server: 35.197.90.163
   Database: JGBS_Dev_New
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblShuttersEstimate
	DROP CONSTRAINT FK_tblShuttersEstimate_tblUsers
GO
ALTER TABLE dbo.tblcustomer_followup
	DROP CONSTRAINT FK_tblcustomer_followup_tblUsers
GO
ALTER TABLE dbo.tblUsers SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblUsers', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblUsers', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblUsers', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblShuttersEstimate
	DROP CONSTRAINT FK_tblShuttersEstimate_tblSurfaceMount
GO
ALTER TABLE dbo.tblSurfaceMount SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblSurfaceMount', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblSurfaceMount', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblSurfaceMount', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblShuttersEstimate
	DROP CONSTRAINT FK_tblShuttersEstimate_tblShutterWidth
GO
ALTER TABLE dbo.tblShutterWidth SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblShutterWidth', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblShutterWidth', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblShutterWidth', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblShuttersEstimate
	DROP CONSTRAINT FK_tblShuttersEstimate_tblShutterTop
GO
ALTER TABLE dbo.tblShutterTop SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblShutterTop', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblShutterTop', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblShutterTop', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblShuttersEstimate
	DROP CONSTRAINT FK_tblShuttersEstimate_tblShutters
GO
ALTER TABLE dbo.tblShutters SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblShutters', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblShutters', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblShutters', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblShuttersEstimate
	DROP CONSTRAINT FK_tblShuttersEstimate_tblShutterColor
GO
ALTER TABLE dbo.tblShutterColor SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblShutterColor', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblShutterColor', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblShutterColor', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblCustomer
	DROP CONSTRAINT DF_new_customer_CreatedDate
GO
ALTER TABLE dbo.tblCustomer
	DROP CONSTRAINT DF_new_customer_ModifiedDate
GO
ALTER TABLE dbo.tblCustomer
	DROP CONSTRAINT DF_new_customer_IsFirstTime
GO
CREATE TABLE dbo.Tmp_tblCustomer
	(
	Id bigint NOT NULL IDENTITY (1, 1),
	CustomerName varchar(200) NULL,
	CustomerAddress varchar(5000) NULL,
	State varchar(20) NULL,
	City varchar(20) NULL,
	ZipCode varchar(20) NULL,
	JobLocation varchar(100) NULL,
	EstDateSchdule date NULL,
	EstTime varchar(50) NULL,
	CellPh varchar(20) NULL,
	HousePh varchar(20) NULL,
	Email varchar(250) NULL,
	CallTakenBy int NULL,
	Service varchar(500) NULL,
	AddedBy varchar(100) NULL,
	LeadType varchar(50) NULL,
	AlternatePh varchar(20) NULL,
	BillingAddress varchar(100) NULL,
	BestTimetocontact nvarchar(MAX) NULL,
	PrimaryContact varchar(20) NULL,
	ContactPreference varchar(20) NULL,
	PeriodId int NULL,
	AssignedToId int NULL,
	Map1 varchar(100) NULL,
	Map2 varchar(100) NULL,
	ReasonofClosed varchar(250) NULL,
	Status varchar(30) NULL,
	IsRepeated bit NULL,
	Missing_contacts int NULL,
	Followup_date varchar(20) NULL,
	CreatedDate date NULL,
	ModifiedDate date NULL,
	ProductOfInterest varchar(500) NULL,
	SecondaryProductOfInterest int NULL,
	ProjectManager varchar(100) NULL,
	lastname varchar(50) NULL,
	Email2 varchar(100) NULL,
	Email3 varchar(100) NULL,
	Disable bit NULL,
	Reason varchar(MAX) NULL,
	Password varchar(20) NULL,
	AdditionalEmail varchar(MAX) NULL,
	DateOfBirth varchar(50) NULL,
	AdditionalPhoneNo varchar(MAX) NULL,
	PhoneType varchar(MAX) NULL,
	AdditionalPhoneType varchar(MAX) NULL,
	oauth varchar(50) NULL,
	oid varchar(30) NULL,
	AccType varchar(50) NULL,
	ConPref varchar(100) NULL,
	strAddressType varchar(50) NULL,
	strContactType varchar(50) NULL,
	strBillingAddressType varchar(50) NULL,
	strCompetitorBids varchar(50) NULL,
	IsFirstTime bit NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblCustomer SET (LOCK_ESCALATION = TABLE)
GO
ALTER TABLE dbo.Tmp_tblCustomer ADD CONSTRAINT
	DF_new_customer_CreatedDate DEFAULT (getdate()) FOR CreatedDate
GO
ALTER TABLE dbo.Tmp_tblCustomer ADD CONSTRAINT
	DF_new_customer_ModifiedDate DEFAULT (getdate()) FOR ModifiedDate
GO
ALTER TABLE dbo.Tmp_tblCustomer ADD CONSTRAINT
	DF_new_customer_IsFirstTime DEFAULT ((1)) FOR IsFirstTime
GO
SET IDENTITY_INSERT dbo.Tmp_tblCustomer ON
GO
IF EXISTS(SELECT * FROM dbo.tblCustomer)
	 EXEC('INSERT INTO dbo.Tmp_tblCustomer (Id, CustomerName, CustomerAddress, State, City, ZipCode, JobLocation, EstDateSchdule, EstTime, CellPh, HousePh, Email, CallTakenBy, Service, AddedBy, LeadType, AlternatePh, BillingAddress, BestTimetocontact, PrimaryContact, ContactPreference, PeriodId, AssignedToId, Map1, Map2, ReasonofClosed, Status, IsRepeated, Missing_contacts, Followup_date, CreatedDate, ModifiedDate, ProductOfInterest, SecondaryProductOfInterest, ProjectManager, lastname, Email2, Email3, Disable, Reason, Password, AdditionalEmail, DateOfBirth, AdditionalPhoneNo, PhoneType, AdditionalPhoneType, oauth, oid, AccType, ConPref, strAddressType, strContactType, strBillingAddressType, strCompetitorBids, IsFirstTime)
		SELECT CONVERT(bigint, id), CustomerName, CustomerAddress, State, City, ZipCode, JobLocation, EstDateSchdule, EstTime, CellPh, HousePh, Email, CallTakenBy, Service, AddedBy, LeadType, AlternatePh, BillingAddress, BestTimetocontact, PrimaryContact, ContactPreference, PeriodId, AssignedToId, Map1, Map2, ReasonofClosed, Status, IsRepeated, Missing_contacts, Followup_date, CreatedDate, ModifiedDate, ProductOfInterest, SecondaryProductOfInterest, ProjectManager, lastname, Email2, Email3, Disable, Reason, Password, AdditionalEmail, DateOfBirth, AdditionalPhoneNo, PhoneType, AdditionalPhoneType, oauth, oid, AccType, ConPref, strAddressType, strContactType, strBillingAddressType, strCompetitorBids, IsFirstTime FROM dbo.tblCustomer WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblCustomer OFF
GO
ALTER TABLE dbo.tblBillingAddress
	DROP CONSTRAINT FK__tblBillin__intCu__76EBA2E9
GO
ALTER TABLE dbo.tblCustomersDocument
	DROP CONSTRAINT FK_tblCustomersDocument_new_customer
GO
ALTER TABLE dbo.tblCustomerLocationPics
	DROP CONSTRAINT FK_tblCustomerLocationPics_new_customer
GO
ALTER TABLE dbo.tblShuttersEstimate
	DROP CONSTRAINT FK_tblShuttersEstimate_new_customer
GO
ALTER TABLE dbo.tblCustomersAddress
	DROP CONSTRAINT FK_tblCustomersAddress_new_customer
GO
ALTER TABLE dbo.tblcustomer_followup
	DROP CONSTRAINT FK_tblcustomer_followup_new_customer
GO
DROP TABLE dbo.tblCustomer
GO
EXECUTE sp_rename N'dbo.Tmp_tblCustomer', N'tblCustomer', 'OBJECT' 
GO
ALTER TABLE dbo.tblCustomer ADD CONSTRAINT
	PK_new_customer PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblCustomer', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblCustomer', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblCustomer', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblcustomer_followup
	DROP CONSTRAINT DF_tblcustomer_followup_CreatedOn
GO
CREATE TABLE dbo.Tmp_tblcustomer_followup
	(
	Id int NOT NULL IDENTITY (1, 1),
	CustomerId bigint NULL,
	MeetingDate datetime NULL,
	MeetingStatus nvarchar(1000) NULL,
	UserId int NULL,
	CreatedOn datetime NULL,
	EstimateId int NULL,
	ProductId smallint NULL,
	IsNote bit NULL,
	AssignedTo int NULL,
	FileName varchar(MAX) NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblcustomer_followup SET (LOCK_ESCALATION = TABLE)
GO
ALTER TABLE dbo.Tmp_tblcustomer_followup ADD CONSTRAINT
	DF_tblcustomer_followup_CreatedOn DEFAULT (getdate()) FOR CreatedOn
GO
SET IDENTITY_INSERT dbo.Tmp_tblcustomer_followup ON
GO
IF EXISTS(SELECT * FROM dbo.tblcustomer_followup)
	 EXEC('INSERT INTO dbo.Tmp_tblcustomer_followup (Id, CustomerId, MeetingDate, MeetingStatus, UserId, CreatedOn, EstimateId, ProductId, IsNote, AssignedTo, FileName)
		SELECT Id, CONVERT(bigint, CustomerId), MeetingDate, MeetingStatus, UserId, CreatedOn, EstimateId, ProductId, IsNote, AssignedTo, FileName FROM dbo.tblcustomer_followup WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblcustomer_followup OFF
GO
DROP TABLE dbo.tblcustomer_followup
GO
EXECUTE sp_rename N'dbo.Tmp_tblcustomer_followup', N'tblcustomer_followup', 'OBJECT' 
GO
ALTER TABLE dbo.tblcustomer_followup ADD CONSTRAINT
	PK_tblcustomer_followup PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tblcustomer_followup ADD CONSTRAINT
	FK_tblcustomer_followup_tblUsers FOREIGN KEY
	(
	UserId
	) REFERENCES dbo.tblUsers
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblcustomer_followup ADD CONSTRAINT
	FK_tblcustomer_followup_new_customer FOREIGN KEY
	(
	CustomerId
	) REFERENCES dbo.tblCustomer
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblcustomer_followup', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblcustomer_followup', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblcustomer_followup', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tblCustomersAddress
	(
	intAddressId int NOT NULL IDENTITY (1, 1),
	intCustomerId bigint NOT NULL,
	strAddress nvarchar(MAX) NOT NULL,
	strZipCode nvarchar(10) NOT NULL,
	strAddressType nvarchar(100) NULL,
	strCity nvarchar(100) NULL,
	strState nvarchar(100) NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblCustomersAddress SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tblCustomersAddress ON
GO
IF EXISTS(SELECT * FROM dbo.tblCustomersAddress)
	 EXEC('INSERT INTO dbo.Tmp_tblCustomersAddress (intAddressId, intCustomerId, strAddress, strZipCode, strAddressType, strCity, strState)
		SELECT intAddressId, CONVERT(bigint, intCustomerId), strAddress, strZipCode, strAddressType, strCity, strState FROM dbo.tblCustomersAddress WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblCustomersAddress OFF
GO
DROP TABLE dbo.tblCustomersAddress
GO
EXECUTE sp_rename N'dbo.Tmp_tblCustomersAddress', N'tblCustomersAddress', 'OBJECT' 
GO
ALTER TABLE dbo.tblCustomersAddress ADD CONSTRAINT
	PK_tblCustomersAddress PRIMARY KEY CLUSTERED 
	(
	intAddressId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tblCustomersAddress ADD CONSTRAINT
	FK_tblCustomersAddress_new_customer FOREIGN KEY
	(
	intCustomerId
	) REFERENCES dbo.tblCustomer
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblCustomersAddress', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblCustomersAddress', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblCustomersAddress', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblShuttersEstimate
	DROP CONSTRAINT DF_tblShuttersEstimate_TotalPrice
GO
ALTER TABLE dbo.tblShuttersEstimate
	DROP CONSTRAINT DF_tblShuttersEstimate_Createddate
GO
CREATE TABLE dbo.Tmp_tblShuttersEstimate
	(
	Id int NOT NULL IDENTITY (1, 1),
	CustomerId bigint NULL,
	UserId int NULL,
	ShutterId int NULL,
	ShutterTopId int NULL,
	ShutterWidthId int NULL,
	ShutterLength varchar(20) NULL,
	ShutterColorId int NULL,
	Quantity int NULL,
	SurfaceMountId int NULL,
	WorkArea varchar(100) NULL,
	Style varchar(50) NULL,
	SpecialInstruction varchar(MAX) NULL,
	LocationPicture varchar(200) NULL,
	Status varchar(50) NULL,
	TotalPrice numeric(18, 2) NULL,
	Createddate datetime NULL,
	Modifieddate datetime NULL,
	TransactionId varchar(100) NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblShuttersEstimate SET (LOCK_ESCALATION = TABLE)
GO
ALTER TABLE dbo.Tmp_tblShuttersEstimate ADD CONSTRAINT
	DF_tblShuttersEstimate_TotalPrice DEFAULT ((0.00)) FOR TotalPrice
GO
ALTER TABLE dbo.Tmp_tblShuttersEstimate ADD CONSTRAINT
	DF_tblShuttersEstimate_Createddate DEFAULT (getdate()) FOR Createddate
GO
SET IDENTITY_INSERT dbo.Tmp_tblShuttersEstimate ON
GO
IF EXISTS(SELECT * FROM dbo.tblShuttersEstimate)
	 EXEC('INSERT INTO dbo.Tmp_tblShuttersEstimate (Id, CustomerId, UserId, ShutterId, ShutterTopId, ShutterWidthId, ShutterLength, ShutterColorId, Quantity, SurfaceMountId, WorkArea, Style, SpecialInstruction, LocationPicture, Status, TotalPrice, Createddate, Modifieddate, TransactionId)
		SELECT Id, CONVERT(bigint, CustomerId), UserId, ShutterId, ShutterTopId, ShutterWidthId, ShutterLength, ShutterColorId, Quantity, SurfaceMountId, WorkArea, Style, SpecialInstruction, LocationPicture, Status, TotalPrice, Createddate, Modifieddate, TransactionId FROM dbo.tblShuttersEstimate WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblShuttersEstimate OFF
GO
DROP TABLE dbo.tblShuttersEstimate
GO
EXECUTE sp_rename N'dbo.Tmp_tblShuttersEstimate', N'tblShuttersEstimate', 'OBJECT' 
GO
ALTER TABLE dbo.tblShuttersEstimate ADD CONSTRAINT
	PK_tblShuttersEstimate PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tblShuttersEstimate ADD CONSTRAINT
	FK_tblShuttersEstimate_tblShutterColor FOREIGN KEY
	(
	ShutterColorId
	) REFERENCES dbo.tblShutterColor
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblShuttersEstimate ADD CONSTRAINT
	FK_tblShuttersEstimate_tblShutters FOREIGN KEY
	(
	ShutterId
	) REFERENCES dbo.tblShutters
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblShuttersEstimate ADD CONSTRAINT
	FK_tblShuttersEstimate_tblShutterTop FOREIGN KEY
	(
	ShutterTopId
	) REFERENCES dbo.tblShutterTop
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblShuttersEstimate ADD CONSTRAINT
	FK_tblShuttersEstimate_tblShutterWidth FOREIGN KEY
	(
	ShutterWidthId
	) REFERENCES dbo.tblShutterWidth
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblShuttersEstimate ADD CONSTRAINT
	FK_tblShuttersEstimate_tblSurfaceMount FOREIGN KEY
	(
	SurfaceMountId
	) REFERENCES dbo.tblSurfaceMount
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblShuttersEstimate ADD CONSTRAINT
	FK_tblShuttersEstimate_tblUsers FOREIGN KEY
	(
	UserId
	) REFERENCES dbo.tblUsers
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.tblShuttersEstimate ADD CONSTRAINT
	FK_tblShuttersEstimate_new_customer FOREIGN KEY
	(
	CustomerId
	) REFERENCES dbo.tblCustomer
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblShuttersEstimate', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblShuttersEstimate', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblShuttersEstimate', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblCustomerLocationPics
	DROP CONSTRAINT DF_tblCustomerLocationPics_UploadedDate
GO
CREATE TABLE dbo.Tmp_tblCustomerLocationPics
	(
	Id int NOT NULL IDENTITY (1, 1),
	CustomerId bigint NULL,
	PictureName varchar(150) NULL,
	UploadedDate datetime NULL,
	ProductId int NULL,
	ProductTypeId int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblCustomerLocationPics SET (LOCK_ESCALATION = TABLE)
GO
ALTER TABLE dbo.Tmp_tblCustomerLocationPics ADD CONSTRAINT
	DF_tblCustomerLocationPics_UploadedDate DEFAULT (getdate()) FOR UploadedDate
GO
SET IDENTITY_INSERT dbo.Tmp_tblCustomerLocationPics ON
GO
IF EXISTS(SELECT * FROM dbo.tblCustomerLocationPics)
	 EXEC('INSERT INTO dbo.Tmp_tblCustomerLocationPics (Id, CustomerId, PictureName, UploadedDate, ProductId, ProductTypeId)
		SELECT Id, CONVERT(bigint, CustomerId), PictureName, UploadedDate, ProductId, ProductTypeId FROM dbo.tblCustomerLocationPics WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblCustomerLocationPics OFF
GO
DROP TABLE dbo.tblCustomerLocationPics
GO
EXECUTE sp_rename N'dbo.Tmp_tblCustomerLocationPics', N'tblCustomerLocationPics', 'OBJECT' 
GO
ALTER TABLE dbo.tblCustomerLocationPics ADD CONSTRAINT
	PK_tblCustomerLocationPics PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tblCustomerLocationPics ADD CONSTRAINT
	FK_tblCustomerLocationPics_new_customer FOREIGN KEY
	(
	CustomerId
	) REFERENCES dbo.tblCustomer
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblCustomerLocationPics', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblCustomerLocationPics', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblCustomerLocationPics', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tblCustomersDocument
	(
	Id int NOT NULL IDENTITY (1, 1),
	CustomerId bigint NULL,
	ProductId int NULL,
	DocName varchar(100) NULL,
	DocType varchar(20) NULL,
	CreatedOn datetime NULL,
	TempName varchar(100) NULL,
	ProductTypeId int NULL,
	VendorId int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblCustomersDocument SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tblCustomersDocument ON
GO
IF EXISTS(SELECT * FROM dbo.tblCustomersDocument)
	 EXEC('INSERT INTO dbo.Tmp_tblCustomersDocument (Id, CustomerId, ProductId, DocName, DocType, CreatedOn, TempName, ProductTypeId, VendorId)
		SELECT Id, CONVERT(bigint, CustomerId), ProductId, DocName, DocType, CreatedOn, TempName, ProductTypeId, VendorId FROM dbo.tblCustomersDocument WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblCustomersDocument OFF
GO
DROP TABLE dbo.tblCustomersDocument
GO
EXECUTE sp_rename N'dbo.Tmp_tblCustomersDocument', N'tblCustomersDocument', 'OBJECT' 
GO
ALTER TABLE dbo.tblCustomersDocument ADD CONSTRAINT
	PK_tblCustomersDocument PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tblCustomersDocument ADD CONSTRAINT
	FK_tblCustomersDocument_new_customer FOREIGN KEY
	(
	CustomerId
	) REFERENCES dbo.tblCustomer
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblCustomersDocument', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblCustomersDocument', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblCustomersDocument', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tblBillingAddress
	(
	intCustomerId bigint NOT NULL,
	strAddressType nvarchar(50) NULL,
	strBillingAddress nvarchar(MAX) NULL,
	intBillingAddress int NOT NULL IDENTITY (1, 1)
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblBillingAddress SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tblBillingAddress ON
GO
IF EXISTS(SELECT * FROM dbo.tblBillingAddress)
	 EXEC('INSERT INTO dbo.Tmp_tblBillingAddress (intCustomerId, strAddressType, strBillingAddress, intBillingAddress)
		SELECT CONVERT(bigint, intCustomerId), strAddressType, strBillingAddress, intBillingAddress FROM dbo.tblBillingAddress WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblBillingAddress OFF
GO
DROP TABLE dbo.tblBillingAddress
GO
EXECUTE sp_rename N'dbo.Tmp_tblBillingAddress', N'tblBillingAddress', 'OBJECT' 
GO
ALTER TABLE dbo.tblBillingAddress ADD CONSTRAINT
	PK__tblBilli__63D72DD4570D9C33 PRIMARY KEY CLUSTERED 
	(
	intBillingAddress
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tblBillingAddress ADD CONSTRAINT
	FK__tblBillin__intCu__76EBA2E9 FOREIGN KEY
	(
	intCustomerId
	) REFERENCES dbo.tblCustomer
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblBillingAddress', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblBillingAddress', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblBillingAddress', 'Object', 'CONTROL') as Contr_Per 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
   Wednesday, November 15, 20176:49:23 PM
   User: sa
   Server: 35.197.90.163
   Database: JGBS_Dev_New
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblProductMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblProductMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblProductMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblProductMaster', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblCustomer SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblCustomer', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblCustomer', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblCustomer', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblCustomerQuote
	DROP CONSTRAINT DF_tblQuoteSequence_CreatedOn
GO
CREATE TABLE dbo.Tmp_tblCustomerQuote
	(
	Id int NOT NULL IDENTITY (1, 1),
	CustomerId bigint NOT NULL,
	ProductId int NOT NULL,
	EstimateId int NOT NULL,
	QuoteNumber varchar(100) NOT NULL,
	CreatedOn date NOT NULL,
	Status varchar(100) NULL,
	StatusChangeDate date NULL,
	CloseReason varchar(MAX) NULL,
	CreatedBy int NULL,
	CreatedDate datetime NULL,
	ModifiedBy int NULL,
	ModifiedDate datetime NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblCustomerQuote SET (LOCK_ESCALATION = TABLE)
GO
ALTER TABLE dbo.Tmp_tblCustomerQuote ADD CONSTRAINT
	DF_tblQuoteSequence_CreatedOn DEFAULT (getdate()) FOR CreatedOn
GO
ALTER TABLE dbo.Tmp_tblCustomerQuote ADD CONSTRAINT
	DF_tblCustomerQuote_CreatedDate DEFAULT (getdate()) FOR CreatedDate
GO
ALTER TABLE dbo.Tmp_tblCustomerQuote ADD CONSTRAINT
	DF_tblCustomerQuote_ModifiedDate DEFAULT (getdate()) FOR ModifiedDate
GO
SET IDENTITY_INSERT dbo.Tmp_tblCustomerQuote ON
GO
IF EXISTS(SELECT * FROM dbo.tblCustomerQuote)
	 EXEC('INSERT INTO dbo.Tmp_tblCustomerQuote (Id, CustomerId, ProductId, EstimateId, QuoteNumber, CreatedOn, Status, StatusChangeDate, CloseReason)
		SELECT Id, CONVERT(bigint, CustomerId), ProductId, EstimateId, QuoteNumber, CreatedOn, Status, StatusChangeDate, CloseReason FROM dbo.tblCustomerQuote WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblCustomerQuote OFF
GO
DROP TABLE dbo.tblCustomerQuote
GO
EXECUTE sp_rename N'dbo.Tmp_tblCustomerQuote', N'tblCustomerQuote', 'OBJECT' 
GO
ALTER TABLE dbo.tblCustomerQuote ADD CONSTRAINT
	PK_tblQuoteSequence PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tblCustomerQuote ADD CONSTRAINT
	FK_tblCustomerQuote_tblCustomer FOREIGN KEY
	(
	CustomerId
	) REFERENCES dbo.tblCustomer
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
   Wednesday, November 15, 20176:50:24 PM
   User: sa
   Server: 35.197.90.163
   Database: JGBS_Dev_New
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblProductMaster SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblProductMaster', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblProductMaster', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblProductMaster', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblCustomer SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
select Has_Perms_By_Name(N'dbo.tblCustomer', 'Object', 'ALTER') as ALT_Per, Has_Perms_By_Name(N'dbo.tblCustomer', 'Object', 'VIEW DEFINITION') as View_def_Per, Has_Perms_By_Name(N'dbo.tblCustomer', 'Object', 'CONTROL') as Contr_Per BEGIN TRANSACTION
GO
ALTER TABLE dbo.tblCustomerQuote
	DROP CONSTRAINT DF_tblQuoteSequence_CreatedOn
GO
CREATE TABLE dbo.Tmp_tblCustomerQuote
	(
	Id int NOT NULL IDENTITY (1, 1),
	CustomerId bigint NOT NULL,
	ProductId int NOT NULL,
	EstimateId int NOT NULL,
	QuoteNumber varchar(100) NOT NULL,
	CreatedOn date NOT NULL,
	Status varchar(100) NULL,
	StatusChangeDate date NULL,
	CloseReason varchar(MAX) NULL,
	CreatedBy int NULL,
	CreatedDate datetime NULL,
	ModifiedBy int NULL,
	ModifiedDate datetime NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tblCustomerQuote SET (LOCK_ESCALATION = TABLE)
GO
ALTER TABLE dbo.Tmp_tblCustomerQuote ADD CONSTRAINT
	DF_tblQuoteSequence_CreatedOn DEFAULT (getdate()) FOR CreatedOn
GO
ALTER TABLE dbo.Tmp_tblCustomerQuote ADD CONSTRAINT
	DF_tblCustomerQuote_CreatedDate DEFAULT (getdate()) FOR CreatedDate
GO
ALTER TABLE dbo.Tmp_tblCustomerQuote ADD CONSTRAINT
	DF_tblCustomerQuote_ModifiedDate DEFAULT (getdate()) FOR ModifiedDate
GO
SET IDENTITY_INSERT dbo.Tmp_tblCustomerQuote ON
GO
IF EXISTS(SELECT * FROM dbo.tblCustomerQuote)
	 EXEC('INSERT INTO dbo.Tmp_tblCustomerQuote (Id, CustomerId, ProductId, EstimateId, QuoteNumber, CreatedOn, Status, StatusChangeDate, CloseReason)
		SELECT Id, CONVERT(bigint, CustomerId), ProductId, EstimateId, QuoteNumber, CreatedOn, Status, StatusChangeDate, CloseReason FROM dbo.tblCustomerQuote WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tblCustomerQuote OFF
GO
DROP TABLE dbo.tblCustomerQuote
GO
EXECUTE sp_rename N'dbo.Tmp_tblCustomerQuote', N'tblCustomerQuote', 'OBJECT' 
GO
ALTER TABLE dbo.tblCustomerQuote ADD CONSTRAINT
	PK_tblQuoteSequence PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tblCustomerQuote ADD CONSTRAINT
	FK_tblCustomerQuote_tblCustomer FOREIGN KEY
	(
	CustomerId
	) REFERENCES dbo.tblCustomer
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/****** Object:  Table [dbo].[tblQuoteSequence]    Script Date: 11/15/2017 7:05:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblQuoteSequence](
	[Id] [bigint] NOT NULL,
	[CustomerId] [bigint] NOT NULL,
	[LastQuoteNumber] [bigint] NOT NULL,
 CONSTRAINT [PK_tblQuoteSequence_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tblQuoteSequence]  WITH CHECK ADD  CONSTRAINT [FK_tblQuoteSequence_tblQuoteSequence] FOREIGN KEY([Id])
REFERENCES [dbo].[tblQuoteSequence] ([Id])
GO

ALTER TABLE [dbo].[tblQuoteSequence] CHECK CONSTRAINT [FK_tblQuoteSequence_tblQuoteSequence]
GO


