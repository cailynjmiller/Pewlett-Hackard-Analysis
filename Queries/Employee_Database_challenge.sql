SELECT emp_no,first_name,last_name FROM employees;

SELECT title,from_date,to_date FROM titles;

-- Creating retirement titles table by joining employees and titles

SELECT e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as t ON (e.emp_no=t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no ASC;

-- Use Dictinct with Orderby to remove duplicate rows

SELECT DISTINCT ON (emp_no) emp_no,
	first_name,
	last_name,
	title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, from_date DESC;

-- Retrieve number of titles from unique titles
SELECT COUNT (emp_no) emp_no,title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY emp_no DESC;

-- Retrieve list of people eligible for mentorship
SELECT DISTINCT ON (e.emp_no) e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	t.title
INTO mentorship_eligibility
FROM employees AS e
INNER JOIN dept_emp AS de ON (e.emp_no=de.emp_no)
INNER JOIN titles as t ON (e.emp_no=t.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (de.to_date = '9999-01-01')
ORDER BY emp_no ASC;

-- EVERYTHING BELOW IS FOR THE CHALLENGE

-- Count total active employees
SELECT COUNT (e.emp_no)
FROM employees as e
INNER JOIN dept_emp as de ON (e.emp_no=de.emp_no)
WHERE (de.to_date='9999-01-01');

-- find list of active employees retiring
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
INTO active_retirement_titles
FROM employees as e
INNER JOIN titles as t ON (e.emp_no=t.emp_no)
INNER JOIN dept_emp as de ON (e.emp_no=de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (de.to_date='9999-01-01')
ORDER BY e.emp_no ASC;

SELECT DISTINCT ON (emp_no) emp_no,
	first_name,
	last_name,
	title
INTO active_unique_titles
FROM active_retirement_titles
ORDER BY emp_no, from_date DESC;

SELECT COUNT (emp_no) 
FROM active_unique_titles;

-- Count titles for membership eligibility

SELECT COUNT (emp_no) emp_no,title
FROM mentorship_eligibility
GROUP BY title
ORDER BY emp_no DESC;