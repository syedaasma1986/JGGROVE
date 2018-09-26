IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'tblUserTouchPointLog' AND column_name = 'TouchPointSource')
BEGIN
	Alter Table tblUserTouchPointLog Add TouchPointSource int not null default(0)
END 
Go
/****** Object:  StoredProcedure [dbo].[Sp_InsertTouchPointLog]    Script Date: 11/29/2017 1:58:52 AM ******/
DROP PROCEDURE [dbo].[Sp_InsertTouchPointLog]
GO

-- =============================================
-- Author:		Bhavik J. Vaishnani
-- Create date: 29-11-2016
-- Description:	Insert value of Touch Point log
-- =============================================
CREATE PROCEDURE [dbo].[Sp_InsertTouchPointLog] 
	-- Add the parameters for the stored procedure here
	@userID int = 0, 
	@loginUserID int = 0
	, @loginUserInstallID varchar (50) =''
	, @LogTime datetime
	, @changeLog varchar(max)
	,@CurrGUID varchar(40)
	,@TouchPointSource int
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
		   ,[CurrentUserGUID]
		   ,[TouchPointSource])
     VALUES
           (@userID , @loginUserID ,@loginUserInstallID            
           , /*@LogTime*/
		   GETUTCDATE()
           ,@changeLog
		   ,@CurrGUID
		   ,@TouchPointSource)
	
	Select IDENT_CURRENT('tblUserTouchPointLog') as UserTouchPointLogID
END

Go
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE  ROUTINE_NAME = 'GetUserTouchPointLogs')
  BEGIN
      DROP PROCEDURE GetUserTouchPointLogs
  END
 Go
 /*  
 GetUserTouchPointLogs 3809,0,10,0  
 */  
 CREATE PROCEDURE [dbo].[GetUserTouchPointLogs]        
(  
 @UserID  Int,  
 @PageNumber Int = 0,  
 @PageSize Int = 10,  
 @TotalResults Int output  
)        
AS        
BEGIN  
 Select @TotalResults = Count(T.UserTouchPointLogID)  
   from tblUserTouchPointLog T With(NoLock)   
  Join tblInstallUsers LU With(NoLock) On T.UpdatedByUserId = LU.Id  
  Join tblInstallUsers U With(NoLock) On T.UserId = U.Id  
 Where T.UserID = @UserID  
   
   
 
 Select T.UserTouchPointLogID, T.UserID, T.UpdatedByUserID, T.UpdatedUserInstallID, T.ChangeDateTime,   
   T.LogDescription,  
   LU.FristName As UpdatedByFirstName, LU.LastName As UpdatedByLastName, LU.Email As UpdatedByEmail,  
   U.FristName, U.LastName, U.Email, U.Phone,  
   Format(T.ChangeDateTime, 'MM/dd/yyyy hh:mm tt') as ChangeDateTimeFormatted,   
     LU.Fristname+' '+LU.LastName+' - ' + ISNULL(LU.UserInstallId,LU.Id) As SourceUser,
	 LU.Fristname+' '+LU.LastName As SourceUsername,
	 ISNULL(LU.UserInstallId,LU.Id) As SourceUserInstallId,
	 T.TouchPointSource
   from tblUserTouchPointLog T With(NoLock)   
  Join tblInstallUsers LU With(NoLock) On T.UpdatedByUserId = LU.Id  
  Join tblInstallUsers U With(NoLock) On T.UserId = U.Id  
 Where T.UserID = @UserID  
 ORDER BY T.ChangeDateTime Desc  
 OFFSET @PageSize * (@PageNumber) ROWS  
 FETCH NEXT @PageSize ROWS ONLY;   
End

GO