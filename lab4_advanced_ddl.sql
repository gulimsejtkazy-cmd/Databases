--Laboratory Work 4
DROP TABLE employees CASCADE;
CREATE TABLE employees(
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary NUMERIC(10,2),
    hire_date DATE,
    manager_id INTEGER,
    email VARCHAR(100)
);
DROP TABLE projects CASCADE;
CREATE TABLE projects(
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100),
    budget NUMERIC(12,2),
    start_date DATE,
    end_date DATE ,
    status VARCHAR(20)
);
CREATE TABLE assignments(
    assignment_id SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employees(employee_id),
    project_id INTEGER REFERENCES projects(project_id),
    hours_worked NUMERIC(5,1),
    assignment_date DATE
);
INSERT INTO employees (first_name, last_name, department,salary, hire_date, manager_id, email)
VALUES
    ('John', 'Smith', 'IT', 75000, '2020-01-15', NULL,
     'john.smith@company.com'),
    ('Sarah', 'Johnson', 'IT', 65000, '2020-03-20', 1,
     'sarah.j@company.com'),
    ('Michael', 'Brown', 'Sales', 55000, '2019-06-10', NULL,
     'mbrown@company.com'),
    ('Emily', 'Davis', 'HR', 60000, '2021-02-01', NULL,
     'emily.davis@company.com'),
    ('Robert', 'Wilson', 'IT', 70000, '2020-08-15', 1, NULL),
    ('Lisa', 'Anderson', 'Sales', 58000, '2021-05-20', 3,
     'lisa.a@company.com');

INSERT INTO projects (project_name, budget, start_date,end_date, status)
VALUES
    ('Website Redesign', 150000, '2024-01-01', '2024-06-30',
     'Active'),
    ('CRM Implementation', 200000, '2024-02-15', '2024-12-31',
     'Active'),
    ('Marketing Campaign', 80000, '2024-03-01', '2024-05-31',
     'Completed'),
    ('Database Migration', 120000, '2024-01-10', NULL, 'Active');

INSERT INTO assignments (employee_id, project_id,hours_worked, assignment_date)
VALUES
    (1, 1, 120.5, '2024-01-15'),
    (2, 1, 95.0, '2024-01-20'),
    (1, 4, 80.0, '2024-02-01'),
    (3, 3, 60.0, '2024-03-05'),
    (5, 2, 110.0, '2024-02-20'),
    (6, 3, 75.5, '2024-03-10');

--Part 1: Basic SELECT Queries
--TASK 1.1
SELECT
    first_name ||' '|| last_name AS  full_name,
    department,salary
FROM employees;
--Task 1.2
SELECT DISTINCT department-- DISTINCT → убирает повторяющиеся значения
                FROM employees;
--Task 1.3
SELECT project_name,budget,
       CASE-- CASE → работает как IF / ELSE
           WHEN budget>150000 then 'Large'
           WHEN budget between 100000 and 150000 then 'Medium'
           ELSE 'Small'
END AS budget_category
FROM projects;
--Task 1.4
SELECT
    first_name || ' ' || last_name AS full_name,
    COALESCE(email, 'No email provided') AS email-- COALESCE → берёт первое значение, которое НЕ NULL
FROM employees;
--Part 2: WHERE Clause and Comparison Operators
--Task 2.1
SELECT * FROM employees
WHERE hire_date >'2020-01-01';
--Task 2.2
SELECT * FROM employees
WHERE salary between 60000 and 70000;

--Task 2.3
SELECT * FROM employees
WHERE last_name LIKE  'S%' OR last_name LIKE 'J%';

--Task 2.4
SELECT * FROM employees
WHERE manager_id is not null and
      department ='IT';

--Part 3: String and Mathematical Functions
--Task 3.1
SELECT
    UPPER(first_name||' '||last_name) as employee_name,
    LENGTH(last_name)as last_name_lenght,
    SUBSTRING(email FROM 1 FOR 3) AS email_first_3--SUBSTRING() → берёт часть строки
FROM employees;
--Task 3.2
SELECT
    first_name||' '||last_name AS full_name,
    salary AS annual_salary,
    ROUND(salary/12,2) AS monthly_salary,
    salary * 0.10 AS raise_amount
from employees;

--Task 3.3
SELECT
    FORMAT(--FORMAT() → создаёт строку по шаблону
            'Project: %s - Budget: $%s - Status: %s',
            project_name,
            budget,
            status
    ) AS project_info
FROM projects;
--Task 3.4
SELECT
    first_name||' '||last_name AS full_name,
    hire_date,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE,hire_date)) AS years_with_company
FROM employees;-- EXTRACT() → достаёт часть даты

--Part 4: Aggregate Functions and GROUP BY
--Task 4.1
SELECT
    department,
    ROUND(avg(salary),2) AS salary_average
FROM employees
GROUP BY department;

--Task 4.2
SELECT
    p.project_name,
    SUM(a.hours_worked) AS total_hours_worked
FROM projects p
         JOIN assignments a
              ON p.project_id = a.project_id
GROUP BY p.project_id, p.project_name;

--Task 4.3
SELECT
    department,
    COUNT(*) AS emloyees_count
FROM employees
GROUP BY department
HAVING count(*)>1;
--Task 4.4
SELECT
    MAX(salary) AS max_salary,
    MIN(salary) AS min_salary,
    SUM(salary) AS  sum_all_salary
FROM employees;

--Part 5: Set Operations
--Task 5.1
SELECT employee_id,first_name||' '||last_name AS full_name,employees.salary
FROM employees
WHERE salary>65000
UNION SELECT-- UNION → объединяет результаты и убирает дубликаты
          employee_id,first_name||' '||last_name AS full_name,employees.salary
FROM employees
WHERE hire_date>'2020-01-01';
--Task 5.2
SELECT
    first_name||' '||last_name AS full_name,department,salary
FROM employees
WHERE salary>65000
INTERSECT SELECT  first_name||' '||last_name AS full_name,department,salary
FROM employees-- INTERSECT → возвращает только общие строки
WHERE department='IT';

--Task 5.3
SELECT
    e.employee_id,
    e.first_name || ' ' || e.last_name AS full_name
FROM employees e
EXCEPT-- EXCEPT → первое множество БЕЗ второго
SELECT
    e.employee_id,
    e.first_name || ' ' || e.last_name AS full_name
FROM employees e
         JOIN assignments ep
              ON e.employee_id = ep.employee_id;

--Part 6: Subqueries
--Task 6.1
SELECT
    e.employee_id,
    e.first_name || ' ' || e.last_name AS full_name
FROM employees e
WHERE EXISTS(-- EXISTS → проверяет, существует ли хотя бы одна строка
    SELECT 1
    FROM assignments ep
    WHERE ep.employee_id = e.employee_id
);

--Task 6.2
SELECT
    e.employee_id,
    e.first_name || ' ' || e.last_name AS full_name
FROM employees e
WHERE e.employee_id IN (
    SELECT a.employee_id
    FROM assignments a
        JOIN projects p
            ON a.project_id = p.project_id
    WHERE p.status = 'Active'
);

--Task 6.3
SELECT
    first_name||' '||last_name AS full_name,department,salary
FROM employees
WHERE salary>ANY(
    SELECT
        salary
    FROM employees
    where department='Sales'
    );


--Part 7: Complex Queries
--Task 7.1
SELECT
    e.first_name || ' ' || e.last_name AS employee_name,
    e.department,
    AVG(a.hours_worked) AS avg_hours,
    RANK() OVER (
        PARTITION BY e.department
        ORDER BY e.salary DESC
        ) AS salary_rank
FROM employees e
         JOIN assignments a
              ON e.employee_id = a.employee_id
GROUP BY
    e.employee_id,
    e.first_name,
    e.last_name,
    e.department,
    e.salary;
--Task 7.2
SELECT
    p.project_name,
    SUM(a.hours_worked) AS total_hours,
    COUNT(DISTINCT a.employee_id) AS employee_count
FROM projects p
         JOIN assignments a
              ON p.project_id = a.project_id
GROUP BY p.project_id, p.project_name
HAVING SUM(a.hours_worked) > 150;
--Task 7.3
SELECT
    e.department,
    COUNT(*) AS total_employees,
    AVG(e.salary) AS average_salary,
    (
        SELECT e2.first_name || ' ' || e2.last_name
        FROM employees e2
        WHERE e2.department = e.department
        ORDER BY e2.salary DESC
        LIMIT 1
    ) AS highest_paid_employee,
    GREATEST(MAX(e.salary), AVG(e.salary)) AS greatest_salary_value,
    LEAST(MIN(e.salary), AVG(e.salary)) AS least_salary_value
FROM employees e
GROUP BY e.department;