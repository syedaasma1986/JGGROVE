Alter PROCEDURE [dbo].[UDP_GETInstallUserDetails]      
 @id int      

As       
BEGIN      
      
 SELECT       
  u.Id,FristName,Lastname,Email,[Address], ISNULL(d.DesignationName, Designation) AS Designation,      
  [Status],[Password],Phone,Picture,Attachements,zip,[state],city,      
  Bussinessname,SSN,SSN1,SSN2,[Signature],DOB,Citizenship,' ',      
  EIN1,EIN2,A,B,C,D,E,F,G,H,[5],[6],[7],maritalstatus,PrimeryTradeId,SecondoryTradeId,Source,Notes,StatusReason,GeneralLiability,PCLiscense,WorkerComp,HireDate,TerminitionDate,WorkersCompCode,NextReviewDate,EmpType,LastReviewDate,PayRates,ExtraEarning,  
  ExtraEarningAmt,      
  PayMethod,Deduction,DeductionType,AbaAccountNo,AccountNo,AccountType,PTradeOthers,      
  STradeOthers,DeductionReason,InstallId,SuiteAptRoom,FullTimePosition,ContractorsBuilderOwner,MajorTools,DrugTest,ValidLicense,TruckTools,PrevApply,LicenseStatus,CrimeStatus,StartDate,SalaryReq,Avialability,ResumePath,skillassessmentstatus,assessmentPath
  ,WarrentyPolicy,CirtificationTraining,businessYrs,underPresentComp,websiteaddress,PersonName,PersonType,CompanyPrinciple,UserType,Email2,Phone2,CompanyName,SourceUser,DateSourced,InstallerType,BusinessType,CEO,LegalOfficer,President,Owner,AllParteners, 
  MailingAddress,Warrantyguarantee,WarrantyYrs,MinorityBussiness,WomensEnterprise,InterviewTime,CruntEmployement,CurrentEmoPlace,LeavingReason,CompLit,FELONY,shortterm,LongTerm,BestCandidate,TalentVenue,Boardsites,NonTraditional,ConSalTraning,BestTradeOne,      
  BestTradeTwo,BestTradeThree      
  ,aOne,aOneTwo,bOne,cOne,aTwo,aTwoTwo,bTwo,cTwo,aThree,aThreeTwo,bThree,cThree,TC,ExtraIncomeType,RejectionDate ,UserInstallId      
  ,PositionAppliedFor, PhoneExtNo, PhoneISDCode ,DesignationID, CountryCode      
  ,NameMiddleInitial , IsEmailPrimaryEmail, IsPhonePrimaryPhone, IsEmailContactPreference, IsCallContactPreference, IsTextContactPreference, IsMailContactPreference, d.ID AS DesignationId,       
  SourceID,DesignationCode, AddedByUserId  , ISNULL(U.UserInstallID,U.Id) as UserInstallID,u.CurrencyId  
 FROM tblInstallUsers u       
   LEFT JOIN tbl_Designation d ON u.DesignationID = d.ID      
      
 WHERE u.ID=@id      
      
END 
