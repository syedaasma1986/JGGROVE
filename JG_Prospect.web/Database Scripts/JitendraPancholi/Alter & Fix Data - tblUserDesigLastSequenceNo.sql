--use JGBS_DEV_NEW
IF NOT EXISTS( SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'tblUserDesigLastSequenceNo' AND column_name = 'DesignationId')
BEGIN
	Alter Table tblUserDesigLastSequenceNo Add DesignationId int Foreign Key References tbl_designation(Id)
END 
Go

Create Table #TempDesignations(Id int identity(1,1), DesignationCode varchar(10), DesignationId int)
Insert into #TempDesignations
Select DesignationCode, Id From tbl_designation
Declare @Min int, @Max int, @DCode varchar(10), @Did int
Select @Min = Min(Id), @Max = Max(Id) From #TempDesignations
While @Min < = @Max
Begin
	Select @DCode = DesignationCode, @Did = DesignationId From #TempDesignations Where Id = @Min
	-- check for update or insert
	if exists (Select DesignationCode From tblUserDesigLastSequenceNo Where DesignationCode = @DCode)
		Begin
			Update tblUserDesigLastSequenceNo Set DesignationId = @Did Where DesignationCode = @DCode
		End
	Else
		Begin
			Insert Into tblUserDesigLastSequenceNo (DesignationCode,LastSequenceNo,DesignationId)
				Values(@DCode,1,@Did)
		End
	--Select * From tblUserDesigLastSequenceNo Where DesignationCode = @DCode
	Set @Min = @Min + 1
ENd
drop table #TempDesignations

Go
Create Table #TempUsers(Id int identity(1,1), UserId int, UserInstallId varchar(50), DesignationId int)
Insert into #TempUsers 
Select U.Id, U.UserInstallId, U.DesignationId From tblInstallUsers U 
	--Join tblUserDesigLastSequenceNo S on U.DesignationId = S.DesignationId
	--Where U.DesignationID IS NOT NULL
Declare @Min int, @Max int, @DCode varchar(10), @Did int, @DesSequence bigint, @Uid int
Select @Min = Min(Id), @Max = Max(Id) From #TempUsers
While @Min < = @Max
	Begin
		/*Print '@Min = ' + Convert(varchar(10),@Min)*/
		Select @Did = DesignationId, @Uid = UserId From #TempUsers Where Id = @Min
		Select @DCode = DesignationCode From tbl_Designation Where Id = @Did		
		SELECT @DesSequence = LastSequenceNo FROM tblUserDesigLastSequenceNo WHERE DesignationId = @Did
		/*Print '@did='+convert(varchar(10),@Did)
		Print '@DCode='+convert(varchar(10),@DCode)
		Print '@DesSequence='+convert(varchar(10),@DesSequence)
		Print '@Uid='+convert(varchar(10),@Uid)*/
		IF(@DesSequence IS NULL)
			BEGIN
				SET @DesSequence = 0  
			END
		SET @DesSequence = @DesSequence + 1 
		UPDATE tblInstallUsers SET UserInstallId = @DCode + '-A'+ Right('000' + CONVERT(NVARCHAR, @DesSequence), 4)
			WHERE Id = @Uid

		Set @Min = @Min + 1
	End
drop table #TempUsers