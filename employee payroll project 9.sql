-- 💼 EMPLOYEE PAYROLL MANAGEMENT SYSTEM DATABASE

-- -------------------------------
-- DATABASE CREATION
-- -------------------------------
CREATE DATABASE employee_payroll;
USE employee_payroll;

-- -------------------------------
-- TABLE CREATION
-- -------------------------------

-- 1. Departments Table
CREATE TABLE Departments (
  Dept_ID INT PRIMARY KEY AUTO_INCREMENT,
  Dept_Name VARCHAR(50),
  Location VARCHAR(50)
);

-- 2. Employees Table
CREATE TABLE Employees (
  Emp_ID INT PRIMARY KEY AUTO_INCREMENT,
  Emp_Name VARCHAR(50),
  Gender VARCHAR(10),
  Designation VARCHAR(50),
  Dept_ID INT,
  Joining_Date DATE,
  Salary DECIMAL(10,2),
  FOREIGN KEY (Dept_ID) REFERENCES Departments(Dept_ID)
);

-- 3. Attendance Table
CREATE TABLE Attendance (
  Att_ID INT PRIMARY KEY AUTO_INCREMENT,
  Emp_ID INT,
  Date DATE,
  Status VARCHAR(10),
  FOREIGN KEY (Emp_ID) REFERENCES Employees(Emp_ID)
);

-- 4. Payroll Table
CREATE TABLE Payroll (
  Payroll_ID INT PRIMARY KEY AUTO_INCREMENT,
  Emp_ID INT,
  Basic_Pay DECIMAL(10,2),
  Allowances DECIMAL(10,2),
  Deductions DECIMAL(10,2),
  Net_Pay DECIMAL(10,2),
  Pay_Date DATE,
  FOREIGN KEY (Emp_ID) REFERENCES Employees(Emp_ID)
);

-- 5. Leaves Table
CREATE TABLE Leaves (
  Leave_ID INT PRIMARY KEY AUTO_INCREMENT,
  Emp_ID INT,
  Leave_Date DATE,
  Leave_Type VARCHAR(20),
  Status VARCHAR(20),
  FOREIGN KEY (Emp_ID) REFERENCES Employees(Emp_ID)
);

-- 6. Bonuses Table
CREATE TABLE Bonuses (
  Bonus_ID INT PRIMARY KEY AUTO_INCREMENT,
  Emp_ID INT,
  Bonus_Amount DECIMAL(10,2),
  Reason VARCHAR(50),
  Bonus_Date DATE,
  FOREIGN KEY (Emp_ID) REFERENCES Employees(Emp_ID)
);

-- -------------------------------
-- INSERT SAMPLE DATA (10 RECORDS)
-- -------------------------------

-- Departments
INSERT INTO Departments (Dept_Name, Location) VALUES
('HR', 'Delhi'),
('Finance', 'Mumbai'),
('IT', 'Bangalore'),
('Marketing', 'Kolkata'),
('Operations', 'Chennai');

-- Employees
INSERT INTO Employees (Emp_Name, Gender, Designation, Dept_ID, Joining_Date, Salary) VALUES
('Amit Kumar', 'Male', 'Manager', 1, '2020-01-01', 50000.00),
('Pooja Sharma', 'Female', 'Accountant', 2, '2021-02-01', 35000.00),
('Ravi Das', 'Male', 'Developer', 3, '2022-03-01', 40000.00),
('Sneha Rani', 'Female', 'Marketing Lead', 4, '2023-04-01', 45000.00),
('Vikram Joshi', 'Male', 'Operations Head', 5, '2019-05-01', 60000.00);

-- Attendance
INSERT INTO Attendance (Emp_ID, Date, Status) VALUES
(1, '2025-11-01', 'Present'),
(2, '2025-11-01', 'Present'),
(3, '2025-11-01', 'Absent'),
(4, '2025-11-01', 'Present'),
(5, '2025-11-01', 'Present');

-- Payroll
INSERT INTO Payroll (Emp_ID, Basic_Pay, Allowances, Deductions, Net_Pay, Pay_Date) VALUES
(1, 50000.00, 10000.00, 5000.00, 55000.00, '2025-11-05'),
(2, 35000.00, 5000.00, 2000.00, 38000.00, '2025-11-05'),
(3, 40000.00, 8000.00, 3000.00, 45000.00, '2025-11-05'),
(4, 45000.00, 6000.00, 4000.00, 47000.00, '2025-11-05'),
(5, 60000.00, 15000.00, 5000.00, 70000.00, '2025-11-05');

-- Leaves
INSERT INTO Leaves (Emp_ID, Leave_Date, Leave_Type, Status) VALUES
(1, '2025-11-02', 'Casual', 'Approved'),
(2, '2025-11-03', 'Sick', 'Pending'),
(3, '2025-11-04', 'Casual', 'Approved'),
(4, '2025-11-05', 'Paid', 'Rejected'),
(5, '2025-11-06', 'Casual', 'Approved');

-- Bonuses
INSERT INTO Bonuses (Emp_ID, Bonus_Amount, Reason, Bonus_Date) VALUES
(1, 5000.00, 'Performance', '2025-11-01'),
(2, 3000.00, 'Festival', '2025-11-01'),
(3, 2000.00, 'Project Completion', '2025-11-01'),
(4, 2500.00, 'Performance', '2025-11-01'),
(5, 8000.00, 'Target Achievement', '2025-11-01');

-- -------------------------------
-- STORED PROCEDURES (10)
-- -------------------------------
DELIMITER //

-- 1. Add Employee
CREATE PROCEDURE AddEmployee(IN name VARCHAR(50), IN gender VARCHAR(10), IN desg VARCHAR(50), IN dept INT, IN salary DECIMAL(10,2))
BEGIN
  INSERT INTO Employees (Emp_Name, Gender, Designation, Dept_ID, Joining_Date, Salary)
  VALUES (name, gender, desg, dept, CURDATE(), salary);
END //

-- 2. Mark Attendance
CREATE PROCEDURE MarkAttendance(IN eid INT, IN stat VARCHAR(10))
BEGIN
  INSERT INTO Attendance (Emp_ID, Date, Status)
  VALUES (eid, CURDATE(), stat);
END //

-- 3. Apply Leave
CREATE PROCEDURE ApplyLeave(IN eid INT, IN ltype VARCHAR(20))
BEGIN
  INSERT INTO Leaves (Emp_ID, Leave_Date, Leave_Type, Status)
  VALUES (eid, CURDATE(), ltype, 'Pending');
END //

-- 4. Approve Leave
CREATE PROCEDURE ApproveLeave(IN lid INT)
BEGIN
  UPDATE Leaves SET Status = 'Approved' WHERE Leave_ID = lid;
END //

-- 5. Calculate Payroll
CREATE PROCEDURE CalculatePayroll(IN eid INT)
BEGIN
  DECLARE basic, allow, ded, net DECIMAL(10,2);
  SET basic = (SELECT Salary FROM Employees WHERE Emp_ID = eid);
  SET allow = basic * 0.2;
  SET ded = basic * 0.05;
  SET net = basic + allow - ded;
  INSERT INTO Payroll (Emp_ID, Basic_Pay, Allowances, Deductions, Net_Pay, Pay_Date)
  VALUES (eid, basic, allow, ded, net, CURDATE());
END //

-- 6. Add Bonus
CREATE PROCEDURE AddBonus(IN eid INT, IN amt DECIMAL(10,2), IN reason VARCHAR(50))
BEGIN
  INSERT INTO Bonuses (Emp_ID, Bonus_Amount, Reason, Bonus_Date)
  VALUES (eid, amt, reason, CURDATE());
END //

-- 7. Get Employee Payroll
CREATE PROCEDURE GetPayroll(IN eid INT)
BEGIN
  SELECT * FROM Payroll WHERE Emp_ID = eid;
END //

-- 8. Get Department Employees
CREATE PROCEDURE GetDeptEmployees(IN did INT)
BEGIN
  SELECT * FROM Employees WHERE Dept_ID = did;
END //

-- 9. Get Approved Leaves
CREATE PROCEDURE GetApprovedLeaves()
BEGIN
  SELECT * FROM Leaves WHERE Status = 'Approved';
END //

-- 10. Get Employee Bonuses
CREATE PROCEDURE GetBonuses(IN eid INT)
BEGIN
  SELECT * FROM Bonuses WHERE Emp_ID = eid;
END //

DELIMITER ;

-- -------------------------------
-- VIEWS (10)
-- -------------------------------

CREATE VIEW View_Employees AS
SELECT e.Emp_ID, e.Emp_Name, e.Designation, d.Dept_Name, e.Salary
FROM Employees e
JOIN Departments d ON e.Dept_ID = d.Dept_ID;

CREATE VIEW View_Attendance AS
SELECT e.Emp_Name, a.Date, a.Status
FROM Attendance a
JOIN Employees e ON a.Emp_ID = e.Emp_ID;

CREATE VIEW View_Leaves AS
SELECT e.Emp_Name, l.Leave_Type, l.Status
FROM Leaves l
JOIN Employees e ON l.Emp_ID = e.Emp_ID;

CREATE VIEW View_Payroll AS
SELECT e.Emp_Name, p.Basic_Pay, p.Net_Pay, p.Pay_Date
FROM Payroll p
JOIN Employees e ON p.Emp_ID = e.Emp_ID;

CREATE VIEW View_Departments AS
SELECT * FROM Departments;

CREATE VIEW View_Bonuses AS
SELECT e.Emp_Name, b.Bonus_Amount, b.Reason, b.Bonus_Date
FROM Bonuses b
JOIN Employees e ON b.Emp_ID = e.Emp_ID;

CREATE VIEW View_Approved_Leaves AS
SELECT * FROM Leaves WHERE Status = 'Approved';

CREATE VIEW View_Pending_Leaves AS
SELECT * FROM Leaves WHERE Status = 'Pending';

CREATE VIEW View_High_Salary AS
SELECT * FROM Employees WHERE Salary > 45000;

CREATE VIEW View_Top_Bonuses AS
SELECT Emp_ID, SUM(Bonus_Amount) AS TotalBonus
FROM Bonuses
GROUP BY Emp_ID
ORDER BY TotalBonus DESC;

-- -------------------------------
-- TRIGGERS (10)
-- -------------------------------
DELIMITER //

-- 1. Log employee creation
CREATE TABLE Employee_Log (Log_ID INT AUTO_INCREMENT PRIMARY KEY, Emp_ID INT, Action VARCHAR(50), LogTime DATETIME);
CREATE TRIGGER trg_employee_add AFTER INSERT ON Employees
FOR EACH ROW
BEGIN
  INSERT INTO Employee_Log (Emp_ID, Action, LogTime)
  VALUES (NEW.Emp_ID, 'Employee Added', NOW());
END //

-- 2. Log salary update
CREATE TRIGGER trg_salary_update BEFORE UPDATE ON Employees
FOR EACH ROW
BEGIN
  IF NEW.Salary <> OLD.Salary THEN
    INSERT INTO Employee_Log (Emp_ID, Action, LogTime)
    VALUES (NEW.Emp_ID, CONCAT('Salary Updated from ', OLD.Salary, ' to ', NEW.Salary), NOW());
  END IF;
END //

-- 3. Prevent negative salary
CREATE TRIGGER trg_prevent_negative BEFORE UPDATE ON Employees
FOR EACH ROW
BEGIN
  IF NEW.Salary < 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Salary cannot be negative!';
  END IF;
END //

-- 4. Log leave approval
CREATE TABLE Leave_Log (Log_ID INT AUTO_INCREMENT PRIMARY KEY, Leave_ID INT, Action VARCHAR(50), LogTime DATETIME);
CREATE TRIGGER trg_leave_approve AFTER UPDATE ON Leaves
FOR EACH ROW
BEGIN
  IF NEW.Status = 'Approved' THEN
    INSERT INTO Leave_Log (Leave_ID, Action, LogTime)
    VALUES (NEW.Leave_ID, 'Leave Approved', NOW());
  END IF;
END //

-- 5. Log payroll generation
CREATE TABLE Payroll_Log (Log_ID INT AUTO_INCREMENT PRIMARY KEY, Payroll_ID INT, Action VARCHAR(50), LogTime DATETIME);
CREATE TRIGGER trg_payroll_add AFTER INSERT ON Payroll
FOR EACH ROW
BEGIN
  INSERT INTO Payroll_Log (Payroll_ID, Action, LogTime)
  VALUES (NEW.Payroll_ID, 'Payroll Generated', NOW());
END //

-- 6. Prevent duplicate attendance
CREATE TRIGGER trg_duplicate_attendance BEFORE INSERT ON Attendance
FOR EACH ROW
BEGIN
  IF EXISTS (SELECT 1 FROM Attendance WHERE Emp_ID = NEW.Emp_ID AND Date = NEW.Date) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Attendance already marked for this date';
  END IF;
END //

-- 7. Log bonus addition
CREATE TABLE Bonus_Log (Log_ID INT AUTO_INCREMENT PRIMARY KEY, Bonus_ID INT, Action VARCHAR(50), LogTime DATETIME);
CREATE TRIGGER trg_bonus_add AFTER INSERT ON Bonuses
FOR EACH ROW
BEGIN
  INSERT INTO Bonus_Log (Bonus_ID, Action, LogTime)
  VALUES (NEW.Bonus_ID, 'Bonus Added', NOW());
END //

-- 8. Auto deduct absent day
CREATE TRIGGER trg_auto_deduction AFTER INSERT ON Attendance
FOR EACH ROW
BEGIN
  IF NEW.Status = 'Absent' THEN
    UPDATE Payroll SET Deductions = Deductions + 500 WHERE Emp_ID = NEW.Emp_ID;
  END IF;
END //

-- 9. Log department creation
CREATE TABLE Dept_Log (Log_ID INT AUTO_INCREMENT PRIMARY KEY, Dept_ID INT, LogTime DATETIME);
CREATE TRIGGER trg_dept_add AFTER INSERT ON Departments
FOR EACH ROW
BEGIN
  INSERT INTO Dept_Log (Dept_ID, LogTime)
  VALUES (NEW.Dept_ID, NOW());
END //

-- 10. Prevent deleting employee with payroll
CREATE TRIGGER trg_prevent_delete_employee BEFORE DELETE ON Employees
FOR EACH ROW
BEGIN
  IF EXISTS (SELECT 1 FROM Payroll WHERE Emp_ID = OLD.Emp_ID) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete employee with payroll record';
  END IF;
END //

DELIMITER ;

-- ✅ EMPLOYEE PAYROLL MANAGEMENT SYSTEM COMPLETE