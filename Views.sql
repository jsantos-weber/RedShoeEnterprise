--views

CREATE VIEW RSE_Active_Computers AS
	SELECT 
		C.ComputerKey, 
		E.LastName,
		E.FirstName,
		C.PurchaseDate,
		C.ComputerDetails, 
		dbo.RSE_CalcCompValue(C.PurchaseDate, C.PurchaseCost) AS "Current Worth"
	FROM
		dbo.Computers C
		LEFT JOIN
		dbo.EmployeeComputers EC
		ON C.ComputerKey = EC.ComputerKey
		LEFT JOIN
		dbo.Employees E
		ON EC.EmployeeKey = E.EmployeeKey
		JOIN
		dbo.ComputerStatuses CS
		ON C.ComputerStatusKey = CS.ComputerStatusKey
		WHERE CS.ActiveStatus = 1;



CREATE VIEW RSE_Current_Employees AS
  	SELECT 
		E.FirstName + ' ' + E.LastName AS "Employee",
		S.FirstName + ' ' + S.LastName AS "Current Supervisor",
		EJ.Salary,
		EJ.Title,
		CASE
			WHEN EJ.JobStart = E.Hired
				THEN 'NONE'
			ELSE CONVERT(varchar(10),EJ.JobStart,20)
		END AS "LAST INCREASE",
		
		CASE 
			WHEN C.EmployeeJobKey is NULL
			THEN 'NONE'
			ELSE
				(CONVERT(varchar(10),(B.Salary / C.Salary * 100)- 100)) + '%'
					
		END AS "Percentage increase"

	FROM
		dbo.Employees E
		LEFT JOIN
		dbo.Employees S
		ON S.CurrentSupervisorEmployeeKey = E.EmployeeKey
		LEFT JOIN
		dbo.EmployeeJobs EJ
		ON EJ.EmployeeKey = E.EmployeeKey
		LEFT JOIN
		EmployeeJobs B
		ON(B.EmployeeKey = E.EmployeeKey)
		LEFT JOIN 
		(
			SELECT 
				A.EmployeeJobKey, 
				A.EmployeeKey, 
				A.Salary--, D.FirstName, D.LastName
			FROM 
				dbo.EmployeeJobs A 
				JOIN 
				dbo.Employees D 
				ON(A.EmployeeKey = D.EmployeeKey)
				RIGHT JOIN 
				dbo.EmployeeJobs C 
				ON(A.EmployeeJobKey = C.EmployeeJobKey)
			WHERE A.Salary < 
			(
				SELECT 
					max(B.salary) 
				FROM 
					dbo.EmployeeJobs B 
				Where 
					A.EmployeeKey = B.EmployeeKey
			)
			GROUP BY A.EmployeeJobKey, A.EmployeeKey, A.Salary
		) AS C 
		ON (C.EmployeeKey = B.EmployeeKey)
	WHERE EJ.JobFinish is NULL
	    AND B.JobFinish IS NULL
