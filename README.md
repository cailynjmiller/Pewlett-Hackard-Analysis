# Pewlett-Hackard-Analysis
## Overview
Pewlett Hackard is approaching a "silver tsumani", where a lot of their more senior employees will be approaching retirement age. This could lead to a lot of inefficiencies when it comes to finding people to replace those roles and training them. Management has come up with the idea of a mentorship program to combat this issue where the soon-to-retire employees mentor people 10 years behind them so when they take over those roles there will be less transition pains.<br/>
I have been tasked with bulding some new tables to understand who is retiring, how many people are retiring, which roles do people who are retiring have, and who all is eligible for a mentorship program.
## Results
- The retirement_titles table show a list of every employee that is nearing the age of retirement, the role(s) they have held, and the dates of employment.
- The retiring_titles table shows an overview of how many employees are approaching retirement age for each title.
- The unique_titles table shows all active employees that are nearing the age of retirement only showing their current title, so every employee is only in this table once.
- The mentorship_eligibility table shows a list of employees who are eligible for the mentorship program based on their age.
## Summary 
#### Question 1: Who is retiring?
Our analysis in the unique_titles table shows that 90,000 of employees at Pewlett Hackard will reach retirement age in the next 5 years. Of these 90,000 employees, the majority of employees retiring hold senior titles, as seen in the retiring_titles table.<br/>
I wanted to understand what percentage of the total number of retiring empoloyees was to the rest of the company. I counted the total number of active employees by running the query below.<br/>
```
SELECT COUNT (e.emp_no)
FROM employees as e
INNER JOIN dept_emp as de ON (e.emp_no=de.emp_no)
WHERE (de.to_date='9999-01-01');
```
The number returned was 240,124 employees.<br/><br/>
Since I want to understand the number of active employees retiring, I need to get rid of the employees from my analysis who no longer work at Pewlett Hackard. In order to do that, I need to filter the retirement_titles to people who are currently employed. I re-ran all of my tables and did a final count on the active_unique_titles.
```
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
```
The count of active emloyees is 72,458 according to the query above.<br/>
100*(72,458/240,124) = 30.2%. That is a lot of employees retiring!

#### Question 2: Who is eligible for the mentorship program?
According to the mentorship eligibility table, there are a little over 1500 employees who are eligible for the mentorship program, which only a fraction of the number of employees retiring.<br/>
I want to understand how many people are eligible for a mentorship by role, so I ran a query on the mentorship table to show me the number of employees per titles.
```
SELECT COUNT (emp_no) emp_no,title
FROM mentorship_eligibility
GROUP BY title
ORDER BY emp_no DESC;
```
This is what it returned.<br/><br/>
![Mentorship tiles](https://github.com/cailynjmiller/Pewlett-Hackard-Analysis/blob/main/mentorship_titles.png)<br/><br/>
It looks like there are not enough current employees to take the roles of the retiring employeees. In addition to the mentorship program, Pewlett Hackard should look into recruiting people who can take over the roles of soon-to-retire empoloyees.<br/>
