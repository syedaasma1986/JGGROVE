IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'JobSchedulerLog') AND type in (N'U'))
BEGIN
	CREATE TABLE JobSchedulerLog(
		Id Bigint Primary Key Identity(1,1),
		JobName Varchar(200) Not Null,
		StartsOn DateTime Not Null Default(GetDate()),
		EndsOn DateTime,
		ExecutionTime int
	)
END 

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'InstallUserTaskHistory') AND type in (N'U'))
BEGIN
	CREATE TABLE InstallUserTaskHistory(
		Id Bigint Primary Key Identity(1,1),
		InstallUserId int foreign key references tblInstallUsers(Id),
		TaskId bigint foreign key references tblTask(TaskId),
		AssignedOn DateTime Not Null,
		CreatedOn DateTime Not Null Default(GetDate())
	)
END 

