--usp_isAllExamsGivenByUserId 8473,0      
CREATE procedure dbo.[usp_isAllExamsGivenByUserId]      
(      
 @UserID bigint ,               
 @ExamGiven BIT = 0 OUTPUT         
)      
As      
Begin  

	DECLARE @DesignationID INT    
	DECLARE @temp table (ExamID int)  
	 -- Get users designation based on its user id.    
	 SELECT  @DesignationID = DesignationID FROM tblInstallUsers WHERE (Id = @UserID)    
    
    
   IF(@DesignationID IS NOT NULL)    
   BEGIN    
      INSERT INTO @temp
      SELECT MCQ_Exam.ExamID
	  FROM            
	  MCQ_Exam 
      LEFT OUTER JOIN MCQ_Performance AS ExamResult ON MCQ_Exam.ExamID = ExamResult.ExamID AND ExamResult.UserID = @UserID    
	  WHERE  (@DesignationID IN (SELECT Item FROM dbo.SplitString(MCQ_Exam.DesignationID, ',') AS SplitString_1))    
      AND MCQ_Exam.IsActive = 1 AND MCQ_Exam.EXAMID IN (SELECT ExamID FROM MCQ_Question GROUP BY ExamID )  
   END    
    
   DECLARE @GivenExamCount INT
   DECLARE @TotalExamCount INT
   SET @GivenExamCount = ISNULL((SELECT count(ID) from MCQ_Performance where UserId = @UserID),0)
   SET @TotalExamCount = (SELECT count(EXAMID) from @temp)

   if(@GivenExamCount < @TotalExamCount)
   Begin
		set @ExamGiven = 0
   End
   Else
   Begin
		set @ExamGiven = 1
   End
   print @ExamGiven
End 