CREATE TABLE employees ( 
emp_id INT PRIMARY KEY, 
first_name VARCHAR(30), 
last_name VARCHAR(30), 
job_title VARCHAR(30), 
salary INT, 
department VARCHAR(30), 
phone VARCHAR(15) 
); 

INSERT INTO employees VALUES 
(1, 'Ali', 'Khan', 'CLERK', 1200, 'HR', '0301-1111111'), 
(2, 'Sara', 'Ahmed', 'MANAGER', 3500, 'HR', NULL), 
(3, 'Omar', 'Raza', 'CLERK', 1100, 'Finance', '0302-2222222'), 
(4, 'Ayesha', 'Malik', 'ANALYST', 2800, 'IT', NULL), 
(5, 'Bilal', 'Sheikh', 'CLERK', 1000, 'IT', '0303-3333333'), 
(6, 'Hina', 'Iqbal', 'MANAGER', 4000, 'Finance', NULL), 
(7, 'Usman', 'Ali', 'CLERK', 1150, 'HR', '0304-4444444'), 
(8, 'Zara', 'Noor', 'ANALYST', 3000, 'IT', NULL), 
(9, 'Hamza', 'Khan', 'CLERK', 1250, 'Finance', '0305-5555555'), 
(10, 'Noor', 'Fatima', 'MANAGER', 4200, 'IT', NULL), 
(11, 'John', 'Doe', 'CLERK', 1300, 'HR', NULL), 
(12, 'Adam', 'Smith', 'ANALYST', 2600, 'Finance', '0306-6666666'), 
(13, 'Jamie', 'Rice', 'CLERK', 1100, 'HR', '0307-7777777'), 
(14, 'Jamie', 'Rice', 'CLERK', 1150, 'IT', NULL), 
(15, 'Ann', 'Brown', 'ANALYST', 2700, 'HR', NULL), 
(16, 'Anne', 'Brown', 'MANAGER', 3900, 'Finance', '0308-8888888'), 
(17, 'Annie', 'Green', 'CLERK', 1050, 'IT', NULL), 
(18, 'Brandy', 'Graves', 'ANALYST', 2500, 'HR', '0309-9999999'), 
(19, 'Brad', 'McCurdy', 'CLERK', 1200, 'Finance', NULL), 
(20, 'Robert', 'Motley', 'MANAGER', 4100, 'IT', '0310-1010101'), 
(21, 'Amy', 'Stone', 'CLERK', 1000, 'HR', NULL), 
(22, 'Andy', 'Stone', 'ANALYST', 2900, 'Finance', NULL), 
(23, 'Aaron', 'Hall', 'CLERK', 1100, 'IT', '0311-1111111'), 
(24, 'Albert', 'Hall', 'MANAGER', 3600, 'HR', NULL), 
(25, 'April', 'Young', 'ANALYST', 2750, 'Finance', NULL), 
(26, 'Angela', 'White', 'CLERK', 1200, 'IT', '0312-2222222'), 
(27, 'Agnes', 'Lee', 'MANAGER', 4300, 'HR', NULL), 
(28, 'Brian', 'Scott', 'CLERK', 1150, 'Finance', '0313-3333333'), 
(29, 'Bruce', 'Wayne', 'ANALYST', 3200, 'IT', NULL), 
(30, 'Clark', 'Kent', 'MANAGER', 4500, 'HR', '0314-4444444');

SELECT  
salary * 12 AS annual_salary 
FROM employees 
WHERE annual_salary > 50000; 

ALTER TABLE employees
ADD annual_salary INT;

UPDATE employees
SET annual_salary = 
    CASE job_title
        WHEN 'CLERK' THEN salary * 12
        WHEN 'ANALYST' THEN salary * 12
        WHEN 'MANAGER' THEN salary * 12
    END;


SELECT first_name, last_name, annual_salary
FROM employees
WHERE annual_salary > 50000;

SELECT emp_id, first_name, job_title, salary
FROM employees
WHERE job_title = 'CLERK' and salary >= 1100

SELECT DISTINCT department
FROM employees
WHERE phone IS NULL;

SELECT first_name, last_name, salary * 12 AS annual_salary
FROM employees
WHERE (department = 'HR' OR department = 'IT')
  AND salary BETWEEN 2000 AND 4000
  AND first_name LIKE 'A%';
  





