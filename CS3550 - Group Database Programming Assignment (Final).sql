CREATE TABLE Departments
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

	- Create new departments
	- Update the name of existing departments
	- Create new employees.  Every new employee has to have a job.  Job
		information is stored in "EmployeeJobs".  Make sure you trap
		errors and prevent orphan records in the Employees table.
	- Update an employees job.  Any update to a job should generate
		a new record for that employee in the EmployeeJobs table.  This
		would include changing their title, salary, or supervisor.  This
		can be one or many stored procedures
	- Update an employees department
	- Terminate an employee.  When an employee is terminated, their
		computer equipment is returned to the company.  Their job
		record is also ended.
	- Add a new computer to the companies inventory.  The details of the computer
		should be stored in the ComputerDetails field in JSON.  The details
		should include, at a minimum, the brand, serial number, CPU,
		amount of memory, one or more storage devices with their type and
		storage capacity.  Make sure no	bad JSON makes it into your table.
	- Assign/return/report lost/retire a computer.  You cannot retire
		a computer that still has some value left (has to be put back 
		in inventory or reported as lost).
*/
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