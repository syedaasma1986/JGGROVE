 
--usp_isExamsGivenByUser 1144,20,0
Create procedure dbo.[usp_isExamsGivenByUser]
(
 @UserID bigint ,         
 @examId bigint ,         
 @ExamGiven BIT = 0 OUTPUT   
)
As
Begin
	set @ExamGiven = (
	Select case when ExamPerformanceStatus = 0 or ExamPerformanceStatus = 1
	then 1 else 0 end from MCQ_Performance where UserId = @UserID and ExamID = @examId)

	select @ExamGiven as ExamGiven
End