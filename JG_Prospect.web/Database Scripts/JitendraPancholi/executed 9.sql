/****** Object:  StoredProcedure [dbo].[Sp_InsertTouchPointLog]    Script Date: 11/29/2017 1:58:52 AM ******/
DROP PROCEDURE [dbo].[Sp_InsertTouchPointLog]
GO

/****** Object:  StoredProcedure [dbo].[Sp_InsertTouchPointLog]    Script Date: 11/29/2017 1:58:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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
           , /*@LogTime*/
		   GETUTCDATE()
           ,@changeLog
		   ,@CurrGUID)
	
	Select IDENT_CURRENT('tblUserTouchPointLog') as UserTouchPointLogID
END


/****** Object:  StoredProcedure [dbo].[Sp_UpdateNewUserIDInTouchPointLog]    Script Date: 12/16/2016 3:47:38 PM ******/
SET ANSI_NULLS ON
GO


