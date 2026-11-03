Drop table if exists employees cascade ;
Drop table if exists departments cascade ;
Drop table if exists projects cascade ;
-- Create table: employees
CREATE TABLE employees (
                           emp_id INT PRIMARY KEY,
                           emp_name VARCHAR(50),
                           dept_id INT,
                           salary DECIMAL(10, 2)
);
-- Create table: departments
CREATE TABLE departments (
                             dept_id INT PRIMARY KEY,
                             dept_name VARCHAR(50),
                             location VARCHAR(50)
);
-- Create table: projects
CREATE TABLE projects (
                          project_id INT PRIMARY KEY,
                          project_name VARCHAR(50),
                          dept_id INT,
                          budget DECIMAL(10, 2)
);
-- Insert data into employees
INSERT INTO employees (emp_id, emp_name, dept_id, salary)
VALUES
    (1, 'John Smith', 101, 50000),
    (2, 'Jane Doe', 102, 60000),
    (3, 'Mike Johnson', 101, 55000),
    (4, 'Sarah Williams', 103, 65000),
    (5, 'Tom Brown', NULL, 45000);
-- Insert data into departments
INSERT INTO departments (dept_id, dept_name, location) VALUES
                                                           (101, 'IT', 'Building A'),
                                                           (102, 'HR', 'Building B'),
                                                           (103, 'Finance', 'Building C'),
                                                           (104, 'Marketing', 'Building D');
-- Insert data into projects
INSERT INTO projects (project_id, project_name, dept_id,
                      budget) VALUES
                                  (1, 'Website Redesign', 101, 100000),
                                  (2, 'Employee Training', 102, 50000),
                                  (3, 'Budget Analysis', 103, 75000),
                                  (4, 'Cloud Migration', 101, 150000),
                                  (5, 'AI Research', NULL, 200000);
--Part 2
--Exercise 2.1
Select e.emp_name,d.dept_name
From employees e
Cross join departments d;
--20 rows
--Exercise 2.2
--a)
Select e.emp_name,d.dept_name
From employees e,departments d;
--b)
Select e.emp_name,d.dept_name
From employees e
inner join departments d on true;
--Exercise 2.3
Select e.emp_name,p.project_name
From employees e
Cross join projects p;
--Part 3
--Exercise 3.1
Select e.emp_name,d.dept_name,d.location
From employees e
Inner join departments d
on e.dept_id=d.dept_id;
--4 rows, Tom Brown is Null
--Exercise 3.2
Select emp_name,dept_name,location
From employees
Inner join departments
using (dept_id);
--Difference: USING displays the common column dept_id once, and when ON, you can display e.dept_id and d.dept_id separately.
--Exercise 3.3
Select emp_name,dept_name,location
From employees
natural inner join departments;
--Exercise 3.4
Select e.emp_name,d.dept_name,p.project_name
From employees e
inner join departments d
on e.dept_id=d.dept_id
inner join projects p
on d.dept_id=p.dept_id;
--Part 4
--Exercise 4.1
Select e.emp_name,e.dept_id as emp_dept,d.dept_id as dept_dept,d.dept_name
From employees e
left join departments d
on e.dept_id =d.dept_id;
--Tom Brown result is Null
--Exercise 4.2
Select e.emp_name,e.dept_id as emp_dept,d.dept_id as dept_dept,d.dept_name
From employees e
left join departments d
using (dept_id);
--Exercise 4.3
Select e.emp_name,e.dept_id
From employees e
left join departments d
on e.dept_id=d.dept_id
where d.dept_id is null;
--Exercise 4.4
Select d.dept_name,count(e.emp_id) as employee_count
From departments d
left join employees e
on d.dept_id=e.dept_id
group by d.dept_id,d.dept_name
order by employee_count desc;
--Part 5
--Exercise 5.1
Select e.emp_name,d.dept_name
From employees e
right join departments d
using (dept_id);
--Exercise 5.2
Select e.emp_name,d.dept_name
From departments d
left join employees e
on d.dept_id=e.dept_id;
--Exercise 5.3
Select e.emp_name,d.dept_name
From employees e
right join departments d
using (dept_id)
where e.emp_name is Null;
--Part 6
--Exercise 6.1
Select e.emp_name,d.dept_name
From employees e
full join departments d
using(dept_id);
--Exercise 6.2
Select d.dept_name,p.project_name,p.budget
From departments d
full join projects p
using (dept_id);
--Exercise 6.3
SELECT
    CASE
        WHEN e.emp_id IS NULL
            THEN 'Department without employees'
        WHEN d.dept_id IS NULL
            THEN 'Employee without department'
        ELSE 'Matched'
        END AS record_status,
    e.emp_name,
    d.dept_name
FROM employees e
         FULL JOIN departments d
                   ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL
   OR d.dept_id IS NULL;
--Part 7
--Exercise 7.1
SELECT
    e.emp_name,
    d.dept_name,
    e.salary
FROM employees e
         LEFT JOIN departments d
                   ON e.dept_id = d.dept_id
                       AND d.location = 'Building A';
--Exercise 7.2
SELECT
    e.emp_name,
    d.dept_name,
    e.salary
FROM employees e
         LEFT JOIN departments d
                   ON e.dept_id = d.dept_id
WHERE d.location = 'Building A';
--7.3
SELECT
    e.emp_name,
    d.dept_name,
    e.salary
FROM employees e
         INNER JOIN departments d
                    ON e.dept_id = d.dept_id
                        AND d.location = 'Building A';
--
SELECT
    e.emp_name,
    d.dept_name,
    e.salary
FROM employees e
         INNER JOIN departments d
                    ON e.dept_id = d.dept_id
WHERE d.location = 'Building A';
--Part 8
--8.1
SELECT d.dept_name, e.emp_name, e.salary,
       p.project_name, p.budget
FROM departments d
         LEFT JOIN employees e
                   ON d.dept_id = e.dept_id
         LEFT JOIN projects p
                   ON d.dept_id = p.dept_id
ORDER BY d.dept_name, e.emp_name;

--8.2
SELECT d.dept_name, SUM(e.salary) AS total_salary
FROM departments d
         LEFT JOIN employees e
                   ON d.dept_id = e.dept_id
GROUP BY d.dept_name;
--8.3
SELECT d.dept_name, AVG(e.salary) AS average_salary
FROM departments d
         INNER JOIN employees e
                    ON d.dept_id = e.dept_id
GROUP BY d.dept_name
HAVING AVG(e.salary) > 50000;



