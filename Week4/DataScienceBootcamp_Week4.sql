-- Question 1
-- Find actor-director pairs who collaborated at least three times
SELECT actor_id, director_id
FROM ActorDirector
GROUP BY actor_id, director_id
HAVING COUNT(timestamp) >= 3;

-- Question 2
-- Format each user's name with only the first letter capitalized
SELECT user_id,
       CONCAT(UPPER(LEFT(name, 1)), LOWER(SUBSTRING(name, 2))) AS name
FROM Users
ORDER BY user_id;

-- Question 3
-- Retrieve people with their associated address information
SELECT firstName, lastName, city, state
FROM Person
LEFT JOIN Address
ON Person.personId = Address.personId;

-- Question 4
-- Get the second-highest salary from the Employee table
SELECT MAX(salary) AS "SecondHighestSalary"
FROM Employee
WHERE salary NOT IN (SELECT MAX(salary) FROM Employee);

-- Question 5
-- Find products that sold at least 100 units in February
SELECT p.product_name, SUM(o.unit) AS unit
FROM Products p
JOIN Orders o
ON p.product_id = o.product_id
WHERE MONTH(o.order_date) = '02'
GROUP BY p.product_name
HAVING unit >= 100;

-- Question 6
-- List employees along with their unique IDs (if available)
SELECT eu.unique_id, e.name
FROM Employees e
LEFT JOIN EmployeeUNI eu
ON eu.id = e.id;

-- Question 7
-- Calculate the fraction of players who returned the day after their first login
WITH first_login AS (
    SELECT player_id, MIN(event_date) AS first_date
    FROM Activity
    GROUP BY player_id
)
SELECT ROUND(
           COALESCE(
               SUM(CASE WHEN DATEDIFF(a.event_date, f.first_date) = 1 THEN 1 END) / COUNT(DISTINCT a.player_id),
           0), 2
       ) AS fraction
FROM Activity a
JOIN first_login f
ON a.player_id = f.player_id;

-- Question 8
-- Calculate the average experience (in years) of employees per project
SELECT project_id, ROUND(AVG(experience_years), 2) AS average_years
FROM Project
JOIN Employee
ON Project.employee_id = Employee.employee_id
GROUP BY project_id;

-- Question 9
-- Retrieve the top three highest-paid employees within each department
SELECT Department, Employee, Salary
FROM (
    SELECT 
        d.name AS Department,
        e.name AS Employee,
        e.salary AS Salary,
        DENSE_RANK() OVER (PARTITION BY d.name ORDER BY Salary DESC) AS rnk
    FROM Employee e
    JOIN Department d
    ON e.departmentId = d.id
) AS ranked
WHERE rnk <= 3;
