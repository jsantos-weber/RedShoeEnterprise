/*CREATE TABLE Departments
(
	DepartmentKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Department varchar(255)
)

SET IDENTITY_INSERT Departments ON
INSERT Departments (DepartmentKey, Department) VALUES
	(1, 'Finance'),
	(2, 'Business Intelligence'),
	(3, 'Information Technology'),
	(4, 'Accounting')
SET IDENTITY_INSERT Departments OFF

CREATE TABLE EmployeeLevels
(
	EmployeeLevelKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	EmployeeLevel varchar(255) NOT NULL
)

SET IDENTITY_INSERT EmployeeLevels ON
INSERT EmployeeLevels (EmployeeLevelKey, EmployeeLevel) VALUES
	(1, 'Grunt'),
	(2, 'Manager'),
	(3, 'Director/VP'),
	(4, 'Executive')
SET IDENTITY_INSERT EmployeeLevels OFF

CREATE TABLE Employees
(
	EmployeeKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	LastName varchar(25) NOT NULL,
	FirstName varchar(25) NOT NULL,
	Email varchar(50) NOT NULL,
	Hired date NOT NULL,
	Terminated date NULL,
	DepartmentKey int NOT NULL,
	CurrentSupervisorEmployeeKey int NOT NULL --CEO/Top of hierarchy should have their own EmployeeKey
)

SET IDENTITY_INSERT Employees ON
INSERT Employees (EmployeeKey, LastName, FirstName, Email, Hired, DepartmentKey, CurrentSupervisorEmployeeKey) VALUES
	(1, 'Reed', 'Russell', 'russ@mythicalCompany.com', '1/1/2015', 2,  4),
	(2, 'Barnes', 'Eric', 'eric@mythicalCompany.com', '1/1/2015', 3, 1),
	(3, 'Gotti', 'Jason', 'jason@mythicalCompany.com', '1/1/2015', 3, 2),
	(5, 'Roberts', 'Matt', 'matt@mythicalCompany.com', '1/1/2015', 3, 2),
	(4, 'Boss', 'Da', 'DaBoss@mythicalCompany.com', '1/1/2015', 1, 4)
SET IDENTITY_INSERT Employees OFF

CREATE TABLE EmployeeJobs
(
	EmployeeJobKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	EmployeeKey int NOT NULL,
	EmployeeLevelKey int NOT NULL,
	JobStart date NOT NULL,
	JobFinish date NULL,
	Title varchar(50) NOT NULL,
	SupervisorEmployeeKey int NOT NULL,
	Salary money
)

INSERT EmployeeJobs (EmployeeKey, JobStart, JobFinish, Title, SupervisorEmployeeKey, Salary, EmployeeLevelKey) VALUES
(1, '1/1/2015', '7/4/2016', 'Director, IT Development', 4, 60000, 3),
(1, '7/5/2016', '3/1/2017', 'Director, Analytics', 4, 70000, 3),
(1, '3/2/2017', NULL, 'VP, Technology & Analytics', 4, 80000, 3),
(2, '1/1/2015', '3/2/2017', 'Developer 3', 1, 50000, 1),
(2, '3/3/2017', NULL, 'Director, IT Development', 1, 60000, 2),
(3, '1/1/2015', NULL, 'Developer 2', 2, 50000, 1),
(5, '1/1/2015', NULL, 'Developer 1', 2, 45000, 1),
(4, '1/1/2015', NULL, 'Da Boss', 4, 100000, 4)


CREATE TABLE ComputerTypes
(
	ComputerTypeKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	ComputerType varchar(25) NOT NULL
) 
SET IDENTITY_INSERT ComputerTypes ON
INSERT ComputerTypes (ComputerTypeKey, ComputerType) VALUES 
	(1, 'Desktop'),
	(2, 'Laptop'),
	(3, 'Tablet'),
	(4, 'Phone')
SET IDENTITY_INSERT ComputerTypes OFF


CREATE TABLE ComputerStatuses
(
	ComputerStatusKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	ComputerStatus varchar(50) NOT NULL,
	ActiveStatus bit NOT NULL  --an indicator of if this status means the computer is available or not
)

SET IDENTITY_INSERT ComputerStatuses ON
INSERT ComputerStatuses (ComputerStatusKey, ComputerStatus, ActiveStatus) VALUES 
		(0, 'New', 1),
		(1, 'Assigned', 1),
		(2, 'Available', 1),
		(3, 'Lost', 0),
		(4, 'In for Repairs', 0), 
		(5, 'Retired', 1)
SET IDENTITY_INSERT ComputerStatuses OFF


CREATE TABLE Computers
(
	ComputerKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	ComputerTypeKey int NOT NULL,
	ComputerStatusKey int NOT NULL DEFAULT(0),
	PurchaseDate date NOT NULL,
	PurchaseCost money NOT NULL,
	ComputerDetails varchar(max) NULL
)

CREATE TABLE EmployeeComputers
(
	EmployeeComputerKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	EmployeeKey int NOT NULL,
	ComputerKey int NOT NULL,
	Assigned date NOT NULL,
	Returned date NULL
)

CREATE TABLE OnboardingEmployees
(
	OnboardingEmployeeKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	EmployeeKey int NOT NULL,
	Hired date NOT NULL,
	Processed bit DEFAULT (0),
	CreatedOn datetimeoffset NOT NULL DEFAULT(SYSDATETIME())
)

ALTER TABLE Employees
	ADD CONSTRAINT FK_EmployeeDepartment
	FOREIGN KEY (DepartmentKey)
	REFERENCES Departments (DepartmentKey)

ALTER TABLE Employees
	ADD CONSTRAINT FK_EmployeeSupervisor
	FOREIGN KEY (CurrentSupervisorEmployeeKey)
	REFERENCES Employees (EmployeeKey)

ALTER TABLE EmployeeJobs
	ADD CONSTRAINT FK_Employee
	FOREIGN KEY (EmployeeKey)
	REFERENCES Employees (EmployeeKey)

ALTER TABLE EmployeeJobs
	ADD CONSTRAINT FK_EmployeeSupervisorHistory
	FOREIGN KEY (SupervisorEmployeeKey)
	REFERENCES Employees (EmployeeKey)

ALTER TABLE EmployeeJobs
	ADD CONSTRAINT FK_EmployeeLevel
	FOREIGN KEY (EmployeeLevelKey)
	REFERENCES EmployeeLevels (EmployeeLevelKey)

ALTER TABLE Computers 
	ADD CONSTRAINT FK_ComputerComputerTypes 
	FOREIGN KEY (ComputerTypeKey) 
	REFERENCES ComputerTypes (ComputerTypeKey)

ALTER TABLE Computers
	ADD CONSTRAINT FK_ComputerComputerStatus
	FOREIGN KEY (ComputerStatusKey) 
	REFERENCES ComputerStatuses (ComputerStatusKey)

ALTER TABLE EmployeeComputers
	ADD CONSTRAINT FK_EmployeeComputerEmployee
	FOREIGN KEY (EmployeeKey)
	REFERENCES Employees (EmployeeKey)

ALTER TABLE EmployeeComputers
	ADD CONSTRAINT FK_EmployeeComputerComputer
	FOREIGN KEY (ComputerKey)
	REFERENCES Computers (ComputerKey)
GO
*/


/*
DROP TABLE EmployeeComputers
DROP TABLE EmployeeJobs
DROP TABLE Employees
DROP TABLE Departments
DROP TABLE Computers
DROP TABLE ComputerTypes
DROP TABLE ComputerStatuses 
DROP TABLE EmployeeLevels
*/



/* This is a pretty standard employee and asset tracking database */

/* 
Rules of engagement...

 - All objects that you create need to have a prefix in front of them.  It
	should be the same prefix for all objects.  Pick whatever you want - 
	an example..  SuperGroup_AddEmployee or PatriotsRule_NewComputer

 - You can change the table design if you want but you have to provide
	alter table scripts as part of your submission.  

 - Look at the tables and take obvious steps to prevent bad data from getting
	into them as you build stored procedures, triggers, functions, etc.  For
	example - can two people have the same computer at the same time?

 - Always fail gracefully.  Trap errors and return messages

 - There is a lot of work to be done.  Don't wait until the last minute
	or you will not get it done


All the things you have to get done...

 - Stored procedures that accomplish the following things:

	- Create new departments (DONE)
	- Update the name of existing departments (DONE)
	- Create new employees.  Every new employee has to have a job.  Job
		information is stored in "EmployeeJobs".  Make sure you trap
		errors and prevent orphan records in the Employees table. (DONE)
	- Update an employees job.  Any update to a job should generate
		a new record for that employee in the EmployeeJobs table.  This
		would include changing their title, salary, or supervisor.  This
		can be one or many stored procedures (DONE NEEDS TESTING)
	- Update an employees department (DONE)
	- Terminate an employee.  When an employee is terminated, their
		computer equipment is returned to the company.  Their job
		record is also ended. (DONE NEEDS TESTING)
	- Add a new computer to the companies inventory.  The details of the computer
		should be stored in the ComputerDetails field in JSON.  The details
		should include, at a minimum, the brand, serial number, CPU,
		amount of memory, one or more storage devices with their type and
		storage capacity.  Make sure no	bad JSON makes it into your table.
	- Assign/return/report lost/retire a computer.  You cannot retire
		a computer that still has some value left (has to be put back 
		in inventory or reported as lost).
*/

/*
* GetEmployeeKey outputs 0 if no employee key was found,
* else returns the EmployeeKey in @EmployeeKeyOut
* 
* To use this, format the assignment like: @EmployeeKeyOut = @EmployeeKeyTest OUTPUT;
*/
CREATE OR ALTER PROCEDURE dbo.RSE_SP_GetEmployeeKey
	@FirstName varchar(255),
	@LastName varchar(255),
	@EmployeeKeyOut int OUTPUT
AS
BEGIN
	SET @EmployeeKeyOut = 0;
		SELECT
			@EmployeeKeyOut = EmployeeKey
		FROM
			Employees
		WHERE
			FirstName = @FirstName
			AND LastName = @LastName
	IF @EmployeeKeyOut = 0
	BEGIN
		PRINT('Employee: ' + @FirstName + ' ' + @LastName + ' Was not found.')
	END
END
GO

PRINT('GetEmployeeKey Test')
DECLARE @EmployeeKeyTest int;
EXEC RSE_SP_GetEmployeeKey 'Eric', 'Barnes', @EmployeeKeyOut = @EmployeeKeyTest OUTPUT;
PRINT(@EmployeeKeyTest)
GO

/*
* GetDeparmentKey outputs 0 if no Department key was found,
* else returns the DepartmentKey in @DepartmentKeyOut
* 
* To use this, format the assignment like: @DepartmentKeyOut = @DepartmentKeyTest OUTPUT;
*/
CREATE OR ALTER PROCEDURE dbo.RSE_SP_GetDeparmentKey
	@Department varchar(255),
	@DepartmentKeyOut int OUTPUT
AS
BEGIN
	SET @DepartmentKeyOut = 0;
		SELECT
			@DepartmentKeyOut = DepartmentKey
		FROM
			Departments
		WHERE
			Department = @Department
	IF @DepartmentKeyOut = 0
	BEGIN
		PRINT('No department called ' + @Department + ' Found.')
	END
END
GO

PRINT('GetDepartmentKey Test')
DECLARE @DepartmentKeyTest int;
EXEC RSE_SP_GetDeparmentKey 'Business Intelligence', @DepartmentKeyOut = @DepartmentKeyTest OUTPUT;
PRINT(@DepartmentKeyTest)
EXEC RSE_SP_GetDeparmentKey 'Fince', @DepartmentKeyOut = @DepartmentKeyTest OUTPUT;
PRINT(@DepartmentKeyTest)
GO

/*
* GetEmployeeLevelKey outputs 0 if no EmployeeLevel key was found,
* else returns the EmployeeLevelKey in @EmployeeLevelKeyOut
* 
* To use this, format the assignment like: @DepartmentKeyOut = @DepartmentKeyTest OUTPUT;
*/
CREATE OR ALTER PROCEDURE dbo.RSE_SP_GetEmployeeLevelKey
	@EmployeeLevel varchar(255),
	@EmployeeLevelKeyOut INT OUTPUT
AS
BEGIN
	SET @EmployeeLevelKeyOut = 0;
		SELECT
			@EmployeeLevelKeyOut = EmployeeLevelKey
		FROM
			EmployeeLevels
		WHERE
			EmployeeLevel = @EmployeeLevel
	IF @EmployeeLevelKeyOut = 0
	BEGIN
		PRINT('No Employee Level called ' + @EmployeeLevel + ' Found.')
	END
END
GO

PRINT('GetEmployeeLevelKey Test')
DECLARE @EmployeeLevelKeyTest int;
EXEC RSE_SP_GetEmployeeLevelKey 'Grunt', @EmployeeLevelKeyOut = @EmployeeLevelKeyTest OUTPUT;
PRINT(@EmployeeLevelKeyTest)
EXEC RSE_SP_GetEmployeeLevelKey 'Boss', @EmployeeLevelKeyOut = @EmployeeLevelKeyTest OUTPUT;
PRINT(@EmployeeLevelKeyTest)
GO

/*
* GetComputerTypeKey outputs 0 if no ComputerType key was found,
* else returns the ComputerTypeKey in @ComputerTypeKeyOut
* 
* To use this, format the assignment like: @DepartmentKeyOut = @DepartmentKeyTest OUTPUT;
*/
CREATE OR ALTER PROCEDURE dbo.RSE_SP_GetComputerTypeKey
	@ComputerType varchar(25),
	@ComputerTypeKeyOut int OUTPUT
AS
BEGIN
	SET @ComputerTypeKeyOut = 0;
		SELECT
			@ComputerTypeKeyOut = ComputerTypeKey
		FROM
			ComputerTypes
		WHERE
			ComputerType = @ComputerType
	IF @ComputerTypeKeyOut = 0
	BEGIN
		PRINT('No computer type called ' + @ComputerType + ' Found.')
	END
END
GO

PRINT('GetComputerTypeKey Test')
DECLARE @ComputerTypeKeyTest int;
EXEC RSE_SP_GetComputerTypeKey 'Desktop', @ComputerTypeKeyOut = @ComputerTypeKeyTest OUTPUT;
PRINT(@ComputerTypeKeyTest)
EXEC RSE_SP_GetComputerTypeKey 'Desk', @ComputerTypeKeyOut = @ComputerTypeKeyTest OUTPUT;
PRINT(@ComputerTypeKeyTest)
GO

/*
* GetComputerStatusKey outputs -1 if no ComputerStatus key was found,
* else returns the ComputerStatusKey in @ComputerStatusKeyOut
* 
* To use this, format the assignment like: @DepartmentKeyOut = @DepartmentKeyTest OUTPUT;
*/
CREATE OR ALTER PROCEDURE dbo.RSE_SP_GetComputerStatusKey
	@ComputerStatus varchar(50),
	@ComputerStatusKeyOut int OUTPUT
AS
BEGIN
	SET @ComputerStatusKeyOut = -1;
		SELECT
			@ComputerStatusKeyOut = ComputerStatusKey
		FROM
			ComputerStatuses
		WHERE
			ComputerStatus = @ComputerStatus
	IF @ComputerStatusKeyOut = -1
	BEGIN
		PRINT('No computer status called ' + @ComputerStatus + ' found.')
	END
END
GO

PRINT('GetComputerStatusKey Test')
DECLARE @ComputerStatusKeyTest int;
EXEC RSE_SP_GetComputerStatusKey 'New', @ComputerStatusKeyOut = @ComputerStatusKeyTest OUTPUT;
PRINT(@ComputerStatusKeyTest)
EXEC RSE_SP_GetComputerStatusKey 'Old', @ComputerStatusKeyOut = @ComputerStatusKeyTest OUTPUT;
PRINT(@ComputerStatusKeyTest)
GO


-------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.RSE_SP_CreateDepartment
	@DepartmentName varchar(255),
	@DepartmentKey int OUTPUT
AS
BEGIN
	BEGIN TRY
		INSERT INTO dbo.Departments
		(
			Department
		)
		OUTPUT inserted.DepartmentKey
		VALUES (@DepartmentName)
	END TRY
	BEGIN CATCH
		PRINT('INSERT INTO dbo.Departments FAILED')
		PRINT('Attempted to insert department name: ')
		PRINT(@DepartmentName)
	END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.RSE_SP_UpdateDepartment
	@OldDepartmentName varchar(255),
	@NewDepartmentName varchar(255),
	@DepartmentKeyOut int OUTPUT
AS
BEGIN
	DECLARE @currentDepartmentKey int;
	SET @currentDepartmentKey = 0;
		SELECT 
			@currentDepartmentKey = DepartmentKey
		FROM 
			Departments
		WHERE
			Department = @OldDepartmentName
	IF @currentDepartmentKey = 0
	BEGIN
		PRINT('UPDATE DEPARTMENT FAILED!')
		PRINT('Department name was invalid: ')
		PRINT(@OldDepartmentName)
	END
	ELSE
	BEGIN
		BEGIN TRY
			UPDATE dbo.Departments
			SET Department = @NewDepartmentName
			WHERE
				DepartmentKey = @currentDepartmentKey
			SET @DepartmentKeyOut = @currentDepartmentKey
		END TRY
		BEGIN CATCH
			PRINT('UPDATE Department FAILED')
			PRINT('Department name failed was:')
			PRINT(@NewDepartmentName)
		END CATCH
	END
END
GO
--DECLARE @test int
--EXEC RSE_SP_UpdateDepartment 'Finance', 'Financing', @DepartmentKeyOut = @test OUTPUT;
--EXEC RSE_SP_UpdateDepartment 'Financing', 'Finance', @DepartmentKeyOut = @test OUTPUT;

CREATE OR ALTER PROCEDURE dbo.RSE_SP_CreateEmployee
	@LastName varchar(255),
	@FirstName varchar(255),
	@Email varchar(50),
	@Hired date,
	@DepartmentName varchar(255),
	@SupervisorLastName varchar(255),
	@SupervisorFirstName varchar(255),
	@JobTitle varchar(50),
	@EmployeeLevel varchar(255),
	@Salary money
AS
BEGIN
	DECLARE @SupervisorKey int;
	EXEC dbo.RSE_SP_GetEmployeeKey @SupervisorFirstName, @SupervisorLastName, @EmployeeKeyOut = @SupervisorKey OUTPUT;
	DECLARE @DepartmentKey int;
	EXEC dbo.RSE_SP_GetDeparmentKey @DepartmentName, @DepartmentKeyOut = @DepartmentKey OUTPUT;
	DECLARE @EmployeeLevelKey int;
	EXEC dbo.RSE_SP_GetEmployeeLevelKey @EmployeeLevel, @EmployeeLevelKeyOut = @EmployeeLevelKey OUTPUT;

	BEGIN TRY
		SET NOCOUNT ON;
		SET XACT_ABORT ON;
		BEGIN TRANSACTION
			INSERT INTO dbo.Employees
			(
				LastName,
				FirstName,
				Email,
				Hired,
				DepartmentKey,
				CurrentSupervisorEmployeeKey
			)
			VALUES
			(
				@LastName,
				@FirstName,
				@Email,
				@Hired,
				@DepartmentKey,
				@SupervisorKey
			)

			INSERT INTO dbo.EmployeeJobs
			(
				EmployeeKey,
				EmployeeLevelKey,
				JobStart,
				Title,
				SupervisorEmployeeKey,
				Salary
			)
			VALUES
			(
				SCOPE_IDENTITY(),
				@EmployeeLevelKey,
				GETDATE(),
				@JobTitle,
				@SupervisorKey,
				@Salary
			)
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT('Employee Insertion FAILED. Transactions rolled back.')
	END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.RSE_SP_UpdateEmployeeJob
	@FirstName varchar(255),
	@LastName varchar(255),
	@EmployeeLevel varchar(255),
	@SupervisorFirstName varchar(255),
	@SupervisorLastName varchar(255),
	@Salary money,
	@Title varchar(50),
	@StartDate date = NULL,
	@EndDate date = NULL
AS
BEGIN
	DECLARE @EmployeeKey int;
	EXEC RSE_SP_GetEmployeeKey @FirstName, @LastName, @EmployeeKeyOut = @EmployeeKey OUTPUT;
	DECLARE @SupervisorKey int;
	EXEC RSE_SP_GetEmployeeKey @SupervisorFirstName, @SupervisorLastName, @EmployeeKeyOut = @SupervisorKey OUTPUT;
	DECLARE @EmployeeLevelKey int;
	EXEC RSE_SP_GetEmployeeLevelKey @EmployeeLevel, @EmployeeLevelKeyOut = @EmployeeLevelKey OUTPUT;
	IF @StartDate IS NULL
	BEGIN
		SET @StartDate = GETDATE()
	END
	IF @EndDate IS NULL
	BEGIN
		SET @EndDate = GETDATE()-1
	END

	IF @EmployeeKey > 0
	AND @SupervisorKey > 0
	AND @EmployeeLevelKey > 0
	BEGIN
		BEGIN TRY
			UPDATE EmployeeJobs
			SET JobFinish = @EndDate
			WHERE EmployeeKey = @EmployeeKey
				AND JobFinish IS NULL
			
			INSERT INTO EmployeeJobs
			(
				EmployeeKey,
				EmployeeLevelKey,
				JobStart,
				Title,
				SupervisorEmployeeKey,
				Salary
			)
			VALUES
			(
				@EmployeeKey,
				@EmployeeLevelKey,
				@StartDate,
				@Title,
				@SupervisorKey,
				@Salary
			)
		END TRY
		BEGIN CATCH
			PRINT('Updating EmployeeJob Failed!')
		END CATCH
	END
	ELSE IF @EmployeeKey <= 0
	OR @SupervisorKey <= 0
	BEGIN
		PRINT('Employee Name and/or Supervisor Name invalid. Update EmployeeJob terminated')
	END
	ELSE IF @EmployeeLevelKey <= 0 OR @EmployeeLevelKey IS NULL
	BEGIN
		PRINT('EmployeeLevel specified invalid. Update EmployeeJob terminated.')
	END
END
GO

--Testing
DECLARE @Test int;
EXEC RSE_SP_UpdateEmployeeJob 'Eric', 'Barnes', 'Grunt', 'Russell', 'Reed', 55000, 'Developer 2'
GO
CREATE OR ALTER PROCEDURE dbo.RSE_SP_UpdateEmployeeDepartment
	@FirstName varchar(255),
	@LastName varchar(255),
	@NewDepartmentName varchar(255)
AS
BEGIN
	DECLARE @EmployeeKey int;
	EXEC dbo.RSE_SP_GetEmployeeKey @FirstName, @LastName, @EmployeeKeyOut = @EmployeeKey OUTPUT
	IF @EmployeeKey != 0
	BEGIN
		DECLARE @NewDepartmentKey int;
		SET @NewDepartmentKey = 0;
			SELECT
				@NewDepartmentKey = DepartmentKey
			FROM
				Departments
			WHERE
				@NewDepartmentName = Department
		IF @NewDepartmentKey = 0
		BEGIN
			PRINT('Department: ' + @NewDepartmentName + ' Was not found. Update terminated.')
		END
		ELSE
		BEGIN
			BEGIN TRY
				UPDATE dbo.Employees
				SET DepartmentKey = @NewDepartmentKey
				WHERE EmployeeKey = @EmployeeKey
				PRINT('Changed Employee ' + @FirstName + @LastName + ' Department to ' + @NewDepartmentName)
			END TRY
			BEGIN CATCH
				PRINT('UPDATE Employee FAILED. Failed to update ' + @FirstName + ' ' + @LastName + 's department to ' + @NewDepartmentName)
			END CATCH
		END
	END
END
GO

--Testing invalid name and department.
/*
EXEC RSE_SP_UpdateEmployeeDepartment 'Eric', 'Barnes', 'Business Intelligence';
EXEC RSE_SP_UpdateEmployeeDepartment 'Eric', 'Barned', 'Information Technology';
EXEC RSE_SP_UpdateEmployeeDepartment 'Eric', 'Barnes', 'New Department';
EXEC RSE_SP_UpdateEmployeeDepartment 'Eric', 'Barnes', 'Information Technology';
*/

CREATE OR ALTER PROCEDURE dbo.RSE_SP_ReturnComputer
	@FirstName varchar(255),
	@LastName varchar(255),
	@ComputerType varchar(25),
	@ReturnComputerIndex int = 1
AS
BEGIN
	DECLARE @EmployeeKey int;
	EXEC RSE_SP_GetEmployeeKey @FirstName, @LastName, @EmployeeKeyOut = @EmployeeKey OUTPUT;
	DECLARE @ComputerTypeKey int;
	EXEC RSE_SP_GetComputerTypeKey @ComputerType, @ComputerTypeKeyOut = @ComputerTypeKey OUTPUT;
	DECLARE @AssignedStatus int;
	EXEC RSE_SP_GetComputerStatusKey 'Assigned', @ComputerStatusKeyOut = @AssignedStatus OUTPUT
	DECLARE @AvailableStatus int;
	EXEC RSE_SP_GetComputerStatusKey 'Available', @ComputerStatusKeyOut = @AvailableStatus OUTPUT

	SET NOCOUNT ON;
	SET XACT_ABORT ON;
	BEGIN TRANSACTION
	BEGIN TRY
		DECLARE @ModifiedComputerKey int;
		SET @ModifiedComputerKey = (
			SELECT
			LEAD(AssignedKeys.ComputerKey, @ReturnComputerIndex, -1) OVER (ORDER BY ComputerTypeKey) AS 'ReturnKey'
			FROM
				(
				SELECT
					ComputerKey
				FROM
					EmployeeComputers
				WHERE
					EmployeeKey = @EmployeeKey
					AND Returned IS NULL
				) AS AssignedKeys
				INNER JOIN Computers AS c ON AssignedKeys.ComputerKey = c.ComputerKey
			WHERE ComputerTypeKey = @ComputerTypeKey
			AND ComputerStatusKey = @AssignedStatus)
		IF @ModifiedComputerKey != -1
		BEGIN
			UPDATE dbo.Computers
			SET ComputerStatusKey = @AvailableStatus
			WHERE ComputerKey = @ModifiedComputerKey

			UPDATE dbo.EmployeeComputers
			SET Returned = GETDATE()
			WHERE ComputerKey = @ModifiedComputerKey
		END
		ELSE
		BEGIN
			PRINT('Failed to select a valid computer to return.')
		END
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT('Failed to insert. Transaction rolled back.')
	END CATCH
END
GO

CREATE OR ALTER PROCEDURE dbo.RSE_SP_TerminateEmployee
	@FirstName varchar(255),
	@LastName varchar(255),
	@TerminationDate date = GETDATE
AS
BEGIN
	DECLARE @EmployeeKey int;
	EXEC RSE_SP_GetEmployeeKey @FirstName, @LastName, @EmployeeKeyOut = @EmployeeKey OUTPUT;
	DECLARE @AssignedStatus int;
	EXEC RSE_SP_GetComputerStatusKey 'Assigned', @ComputerStatusKeyOut = @AssignedStatus OUTPUT;
	DECLARE @AvailableStatus int;
	EXEC RSE_SP_GetComputerStatusKey 'Available', @ComputerStatusKeyOut = @AvailableStatus OUTPUT;
	SET NOCOUNT ON;
	SET XACT_ABORT ON;
	BEGIN TRANSACTION
	--TODO: Needs THOROUGH checking
	BEGIN TRY
		WHILE ((
			SELECT 
				* 
			FROM 
				EmployeeComputers 
			WHERE
				Returned IS NOT NULL
				AND EmployeeKey = @EmployeeKey) IS NOT NULL)
		BEGIN
			DECLARE @UpdateKey int;
			SET @UpdateKey = (
				SELECT 
					FIRST_VALUE(ComputerKey) OVER (ORDER BY EmployeeKey)
				FROM 
					EmployeeComputers 
				WHERE
					Returned IS NOT NULL
					AND EmployeeKey = @EmployeeKey)

			UPDATE dbo.Computers
			SET ComputerStatusKey = @AvailableStatus
			WHERE ComputerKey = @UpdateKey

			UPDATE dbo.EmployeeComputers
			SET Returned = GETDATE()
			WHERE ComputerKey = @UpdateKey
		END
		UPDATE dbo.EmployeeJobs
		SET JobFinish = @TerminationDate
		WHERE EmployeeKey = @EmployeeKey

		UPDATE dbo.Employees
		SET Terminated = @TerminationDate
		WHERE EmployeeKey = @EmployeeKey
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT('Termination of ' + @FirstName + ' ' + @LastName + ' Failed.')
	END CATCH
END
GO

--Retrieves the first available computer of type Available
CREATE OR ALTER PROCEDURE dbo.RSE_SP_GetFirstAvailableComputerKey
	@ComputerType varchar(25),
	@ComputerKey int OUTPUT
AS
BEGIN
	SET @ComputerKey = -1;
	DECLARE @ComputerTypeKey int;
	SET @ComputerTypeKey = 0;
		SELECT
			@ComputerTypeKey = ComputerTypeKey
		FROM
			ComputerTypes
		WHERE
			ComputerType = @ComputerType
	IF @ComputerTypeKey = 0
	BEGIN
		PRINT('No Computer Type found of ' + @ComputerType)
	END
	ELSE
	BEGIN
		DECLARE @StatusAvailable int;
		DECLARE @StatusNew int;
		SELECT
			@StatusAvailable = ComputerStatusKey
		FROM
			ComputerStatuses
		WHERE
			ComputerStatus = 'Available'

		SELECT
			@StatusNew = ComputerStatusKey
		FROM
			ComputerStatuses
		WHERE
			ComputerStatus = 'New'

		SELECT
			@ComputerKey = FIRST_VALUE(ComputerKey) OVER (ORDER BY ComputerStatusKey DESC)
		FROM
			Computers
		WHERE
			ComputerTypeKey = @ComputerTypeKey
			AND ComputerStatusKey IN (@StatusAvailable, @StatusNew)
		
		IF @ComputerKey = -1
		BEGIN
			PRINT('No computer of Type ' + @ComputerType + ' found')
		END
	END
END
GO

CREATE OR ALTER PROCEDURE dbo.RSE_SP_AssignComputer
	@FirstName varchar(255),
	@LastName varchar(255),
	@ComputerType varchar(25)
AS
BEGIN
	DECLARE @ComputerKey int;
	EXEC dbo.RSE_SP_GetFirstAvailableComputerKey @ComputerType, @ComputerKey
	DECLARE @EmployeeKey int;
	EXEC dbo.RSE_SP_GetEmployeeKey @FirstName, @LastName, @EmployeeKeyOut = @EmployeeKey OUTPUT
	DECLARE @EmployeeComputerKey int;
	IF @ComputerKey >= 0 AND @EmployeeKey > 0
	BEGIN
		BEGIN TRY
			INSERT INTO EmployeeComputers
			(
				EmployeeKey,
				ComputerKey,
				Assigned
			)
			VALUES
			(
				@EmployeeKey,
				@ComputerKey,
				GETDATE()
			)

			BEGIN TRY
				UPDATE dbo.Computers
				SET ComputerStatusKey = (
					SELECT
						ComputerStatusKey
					FROM
						ComputerStatuses
					WHERE
						ComputerStatus = 'Assigned')
				WHERE ComputerKey = @ComputerKey
			END TRY
			BEGIN CATCH
				PRINT('FAILED to update Computers Status')
			END CATCH
		END TRY
		BEGIN CATCH
			PRINT('INSERT INTO EmployeeComputers FAILED. Computer Type: ' + @ComputerType)
		END CATCH
	END
END
GO

CREATE OR ALTER PROCEDURE dbo.RSE_SP_ReportLostComputer
	@FirstName varchar(255),
	@LastName varchar(255),
	@ComputerType varchar(25),
	@LostComputerIndex int = 1
AS
BEGIN
	DECLARE @EmployeeKey int;
	EXEC RSE_SP_GetEmployeeKey @FirstName, @LastName, @EmployeeKeyOut = @EmployeeKey OUTPUT;
	DECLARE @ComputerTypeKey int;
	EXEC RSE_SP_GetComputerTypeKey @ComputerType, @ComputerTypeKeyOut = @ComputerTypeKey OUTPUT;
	DECLARE @AssignedStatus int;
	EXEC RSE_SP_GetComputerStatusKey 'Assigned', @ComputerStatusKeyOut = @AssignedStatus OUTPUT
	DECLARE @AvailableStatus int;
	EXEC RSE_SP_GetComputerStatusKey 'Available', @ComputerStatusKeyOut = @AvailableStatus OUTPUT
	DECLARE @LostStatus int;
	EXEC RSE_SP_GetComputerStatusKey 'Lost', @ComputerStatusKeyOut = @LostStatus OUTPUT

	SET NOCOUNT ON;
	SET XACT_ABORT ON;
	BEGIN TRANSACTION
	BEGIN TRY
		DECLARE @ModifiedComputerKey int;
		SET @ModifiedComputerKey = (
			SELECT
			LEAD(AssignedKeys.ComputerKey, @LostComputerIndex, -1) OVER (ORDER BY ComputerTypeKey) AS 'ReturnKey'
			FROM
				(
				SELECT
					ComputerKey
				FROM
					EmployeeComputers
				WHERE
					EmployeeKey = @EmployeeKey
					AND Returned IS NULL
				) AS AssignedKeys
				INNER JOIN Computers AS c ON AssignedKeys.ComputerKey = c.ComputerKey
			WHERE ComputerTypeKey = @ComputerTypeKey
			AND ComputerStatusKey = @AssignedStatus)
		IF @ModifiedComputerKey != -1
		BEGIN
			UPDATE dbo.Computers
			SET ComputerStatusKey = @LostStatus
			WHERE ComputerKey = @ModifiedComputerKey

			UPDATE dbo.EmployeeComputers
			SET Returned = GETDATE()
			WHERE ComputerKey = @ModifiedComputerKey
		END
		ELSE
		BEGIN
			PRINT('Failed to select a valid computer to return.')
		END
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT('Failed to insert. Transaction rolled back.')
	END CATCH
END
GO

/*
CREATE OR ALTER PROCEDURE dbo.RSE_SP_CreateComputer
	@Brand varchar(50),
	@SerialNumber varchar(20),
	@CPU varchar(50),
	@Memory varchar(5),
	@StorageDevicesList varchar(255)
*/

/*
- Functions to write

	- Write a function that calculates how much a computer is currently
		worth (from an accounting perspective).  Computer equipment is usually 
		depreciated over 36 months - i.e. it loses 1/36th of its value
		each month after it is purchased.  This should be a scalar function - 
		it will be used in views further on.  
	- A function that returns the average salary for a given employee level.
		Use only current salaries.  This will also be a scalar function and
		will be used in queries further on.
*/

GO -- This function returns the value of the computer
CREATE FUNCTION RSE_CalcCompValue(
	@purchaseDate date,
	@purchaseCost money
)
RETURNS money AS
BEGIN
	DECLARE @monthsBetween int = DATEDIFF(MONTH, @purchaseDate, GETDATE())
	DECLARE @ratio float = CAST(@monthsBetween AS float) / CAST(36 AS float)
	RETURN CAST((@purchaseCost - (@ratio * @purchaseCost)) AS money)
END
--drop function dbo.RSE_CalcCompValue
--SELECT dbo.RSE_CalcCompValue('2018-04-16', 1500) -- TEST: Should return 1500 - (18/36)(1500) = 750

GO -- This function returns the average salary for a given employee level
CREATE FUNCTION RSE_CalcAvgSalary(
	@employeeLevelKey int
)
RETURNS money AS
BEGIN
	DECLARE @empCount int = (
		SELECT 
			COUNT(EJ.EmployeeJobKey)
		FROM
			EmployeeJobs AS EJ
		WHERE
			EJ.EmployeeLevelKey = @employeeLevelKey
		)
	DECLARE @empSalaryTotal money = (
		SELECT
			SUM(EJ.Salary)
		FROM
			EmployeeJobs AS EJ
		WHERE 
			EJ.EmployeeJobKey = @employeeLevelKey
	)
	RETURN CAST((@empSalaryTotal / @empCount) AS money)
END
--drop function dbo.RSE_CalcAvgSalary

/*
 - Views that need to be written
 
	 - A list of all active computers (i.e. exclude lost and retired).  Include
		who is assigned the computer (if applicable), when it was purchased, 
		how much it is worth, and the computer details (as described above in
		the add new computer stored procedure).  Each item of the computer details
		needs to have its own column.  For storage devices, you should return
		a comma delimited string of devices ("Samsung SSD (500GB), Seagate HD (4TB)")
	 - A list of current employees, their supervisor, the department they are in,
		their current salary, their current title, the date they last
		recieved their last increase (if any), and the percentage increase 
		that raise was
*/

/*
 - Triggers that need to be written

	- I don't trust people when they have full access to my database.  Write
		something that prevents someone from deleting an employee.  Instead,
		have it add a termination date to their employee record and close
		out their active job record.
	- We have complicated onboarding procedures - write a trigger that drops
		data into the OnboardingEmployee table whenever a new employee is
		created.

- Constraints to write

	- On the Computers table, ensure the data put into the ComputerDetails
		field is properly formatted JSON.
	- At our mythical company, a salary cannot be more than 15% of the 
		average salary of everyone else at the same level (use your function
		from above)
	- Also at our fun company, no computer can cost more than 10k.  
*/

--Ensures ComputerDetails contains properly formatted JSON:
ALTER TABLE Computers
ADD CHECK (ISJSON(ComputerDetails) > 0)

--Ensures that (salary < (0.15 * AverageSalary) + AverageSalary):
ALTER TABLE EmployeeJobs
ADD CHECK (Salary < (0.15 * RSE_CalcAvgSalary(EmployeeLevelKey)  + RSE_CalcAvgSalary(EmployeeLevelKey)))

--Ensures that no computer costs > 10k:
ALTER TABLE Computers
ADD CHECK (PurchaseCost < 10000)
/*
- Queries to write

	-  A query that provides me the active employees for any date I want
		to provide.  Include their job, supervisor, department, title, 
		name, and email address

	- A query that provides a list of computers that were lost or retired.  
		Include the purchase details, how many people were assigned the computer,
		the last person to have the computer, and the last person who had the 
		computer.  If the computer was lost, include a column for how much value
		was left when it was lost. 



Once you have everything done, complete the following:
 
 - Add 5 new employees, one at each level
 - Add 5 new computers and assign them to your new employees
 - Change the salary of 3 people at the grunt level
 - Create a new department.  Assign one of your employees to it
 - Change someone to a new supervisor and give them a new title
 - Terminate two employees.  Run your view of active computers to make
	sure their computers show up as available afterwards.
 - Have a computer be lost.
 - Try to delete all your managers.  Make sure your trigger fires
 - Select all records from your two views.  See if you can find any errors
	that occured with the above work.

Include your lengthly script as part of your submission

*/
	--Query 1 
DECLARE @StartDate DATE = '2015-01-01'
	, @EndDate DATE = '2016-07-05' 

SELECT 
	[E].EmployeeKey 
	,[E].FirstName + ' ' + [E].LastName AS EmployeeName
	,[E].Email, Title
	,[S].FirstName + ' ' + [S].LastName AS SupervisorName 
	,Department
	,JobStart
FROM 
	Employees [E]
	LEFT JOIN EmployeeJobs [EJ] ON [E].EmployeeKey = [EJ].EmployeeKey
	LEFT JOIN Employees [S] ON [S].CurrentSupervisorEmployeeKey = [E].EmployeeKey
	LEFT JOIN Departments [D] ON [D].DepartmentKey = [E].DepartmentKey
WHERE 
	[E].Terminated IS NULL
	AND JobStart BETWEEN @StartDate AND @EndDate

--Query 2 NOT DONE 

SELECT [C].ComputerKey, PurchaseDate, PurchaseCost, ComputerDetails
FROM Computers [C]
LEFT JOIN ComputerStatuses [CS] ON [C].ComputerStatusKey = [CS].ComputerStatusKey
WHERE [CS].ComputerStatus IN ('Lost','Retired')

--Insert 5 new Employees
SET IDENTITY_INSERT Employees ON
INSERT Employees (EmployeeKey, LastName, FirstName, Email, Hired, DepartmentKey, CurrentSupervisorEmployeeKey) VALUES
	(6, 'Bossman', 'Mister', 'mister@mythicalCompany.com', '6/15/2016', 2,  1),
	(7, 'Buttes', 'Seymour', 'seymour@mythicalCompany.com', '6/15/2016', 3, 6),
	(8, 'Hug', 'Amanda', 'amanda@mythicalCompany.com', '6/15/2016', 3, 6),
	(9, 'Kaholic', 'Al', 'al@mythicalCompany.com', '6/15/2016', 3, 6),
	(10, 'Star', 'Patrick', 'Patrick@mythicalCompany.com', '6/15/2016', 1, 6)
SET IDENTITY_INSERT Employees OFF

INSERT EmployeeJobs (EmployeeKey, JobStart, JobFinish, Title, SupervisorEmployeeKey, Salary, EmployeeLevelKey) VALUES
	(6, '6/15/2016', NULL, 'Director, IT Development', 4, 80000, 4),
	(7, '6/15/2016', NULL, 'Director, Analytics', 4, 70000, 3),
	(8, '6/15/2016', NULL, 'VP, Technology & Analytics', 4, 60000, 2),
	(9, '6/15/2016', NULL, 'Developer 3', 1, 50000, 1),
	(10, '6/15/2016', NULL, 'Rookie Developer', 1, 50000, 1)

--Insert 5 Computers
INSERT Computers (ComputerTypeKey, ComputerStatusKey, PurchaseDate, PurchaseCost, ComputerDetails) VALUES
	(1,0,'1/1/2015',$1399.99,'Fancy Pants Laptop'),
	(1,5,'1/1/2015',$999.99,'OK Laptop'),
	(2,1,'1/1/2015',$1099.99,'Decent Desktop'),
	(2,1,'1/1/2015',$1299.99,'Fancy Pants Desktop'),
	(2,2,'1/1/2015',$1199.99,'Decent Desktop')
SET IDENTITY_INSERT Computers OFF

INSERT EmployeeComputers (EmployeeKey, ComputerKey, Assigned, Returned) VALUES
	(6,1,'6/15/2016',NULL),
	(7,2,'6/15/2016',NULL),
	(8,3,'6/15/2016',NULL),
	(9,4,'6/15/2016',NULL),
	(10,5,'6/15/2016',NULL)

--Change the Salary of 3 people at the grunt Level
UPDATE EmployeeJobs
SET Salary = 55000.0
WHERE EmployeeKey 
IN (
	SELECT TOP 3 [E].EmployeeKey
	FROM Employees [E]
	LEFT JOIN EmployeeJobs [EJ] ON [E].EmployeeKey = [EJ].EmployeeKey
	LEFT JOIN EmployeeLevels [EL] ON [EL].EmployeeLevelKey = [EJ].EmployeeLevelKey
	WHERE EmployeeLevel = 'Grunt'
)

-- Create a new Department
SET IDENTITY_INSERT Departments ON
INSERT Departments (DepartmentKey, Department) VALUES
	(5, 'Research')
SET IDENTITY_INSERT Departments OFF

UPDATE Employees
SET DepartmentKey = 5
WHERE EmployeeKey = 9

-- Change someone to a new supervisor and give them a new title
UPDATE Employees
SET CurrentSupervisorEmployeeKey = 6
WHERE EmployeeKey = 3

UPDATE EmployeeJobs
SET Title = 'Super VP, Technology & Analytics'
WHERE EmployeeKey = 3

-- Terminate Two Employees 
--NOT DONE, NEED TO CHECK THE VIEW PART
UPDATE Employees
SET Terminated = '11/12/2019'
WHERE EmployeeKey IN (9,10)

--Have a computer be Lost
UPDATE Computers
SET ComputerStatusKey = 3
WHERE ComputerKey = 3

--Try to Delete all your managers, Make sure Trigger Fires
--NOT DONE, NEED TO CHECK THE TRIGGER
DELETE FROM Employees
WHERE EmployeeKey IN (
SELECT [E].EmployeeKey 
FROM Employees [E]
LEFT JOIN  EmployeeJobs [EJ] ON [E].EmployeeKey = [EJ].EmployeeKey
LEFT JOIN  EmployeeLevels [EL] ON [EJ].EmployeeLevelKey = [EL].EmployeeLevelKey
WHERE EmployeeLevel = 'Manager'
)
--Select all records from your two views, See if you can find any errors that occured 
