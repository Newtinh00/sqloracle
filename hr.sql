SELECT * FROM employees;

--BETWEEN
SELECT * FROM employees 
    WHERE salary BETWEEN 10000 AND 14000;

--IN
SELECT employee_id FROM employees 
    WHERE employee_id IN (100, 200);

--LIKE
SELECT * FROM employees 
    WHERE JOB_ID LIKE 'FI_ACCOUNT';

--NULL
SELECT * FROM employees 
    WHERE manager_id IS NOT NULL;

SELECT * FROM employees 
    WHERE manager_id IS NULL;

--AND, OR, NOT
SELECT * FROM employees 
    WHERE job_id = 'AD_VP' AND salary > 1000 
        OR first_name LIKE 'L%';

SELECT first_name, last_name, job_id, salary FROM employees 
    WHERE (job_id = 'AD_VP' OR job_id = 'FI_ACCOUNT') 
        AND salary > 5000;
        
SELECT first_name, last_name, job_id, salary, salary * 12 AS "ANUAL" FROM employees; 
        
/*
QUIZ
1-C
2-D ERREI
3-C
4-B
5-C
6-C
7-D
8-C
9-B
10-B
*/
      
--ORDER BY
SELECT first_name, last_name, salary FROM employees 
    ORDER BY salary; --funciona com número tbm

--NULLS FIRST
SELECT first_name, salary, commission_pct FROM employees 
    ORDER BY commission_pct NULLS FIRST
  
--NULLS LAST
SELECT first_name, salary, commission_pct FROM employees 
    ORDER BY commission_pct NULLS LAST
    
SELECT first_name, salary, commission_pct FROM employees 
    ORDER BY commission_pct DESC NULLS LAST  --Usando o DESC antes, ele prioriza os números, dps os valores nulls

--ROWID & ROWNUM
SELECT employee_id, first_name, last_name, salary, rowid, rownum
    FROM employees;
/*
O rowid é uma identificação permamente de uma linha no banco de dados
O rownum é uma idenficação temporária de uma linha no banco de dados, ela muda conforme é aprensentada
*/

--FETCH
SELECT first_name, last_name, salary  FROM employees
    ORDER BY salary DESC
    OFFSET 0 ROW -- Dita a partir de qual linha começará o select (é opcional)
    FETCH FIRST 10 ROWS ONLY; -- Determina quantidade de linhas que eu quero e se é o inicio ou o fim do select

--Substitute variable
SELECT * FROM employees
    WHERE department_id = &department_no;
    
SELECT employee_id, first_name, last_name, salary FROM employees
    WHERE salary BETWEEN &&sal AND &sal + 1000;
        
SELECT employee_id, first_name, last_name, &&column_name FROM employees
    ORDER BY &column_name
    
DEFINE emp_num = 100; --Define um valor à variável que eu criei (Pode ser escrito por  'DEF')
UNDEFINE emp_num; --Zera a variável (Pode ser escrito por  'UNDEF')
SELECT * FROM employees WHERE employee_id = &emp_num;

DEFINE; --Mostra as variáveis padrão + as que eu criei    
DEFINE column_name; --Mostra os valores da variável citada    
    
--ACCEPT/PROMPT

ACCEPT emp_id PROMPT 'Entre com o id do empregado';
SELECT employee_id, first_name, last_name, salary FROM employees
    WHERE employee_id = &emp_id;
    
ACCEPT min_salary PROMPT 'Entre com o menor salário';
ACCEPT max_salary PROMPT 'Entre com o maior salário';
SELECT employee_id, last_name, salary FROM employees
    WHERE salary BETWEEN &min_salary AND &max_salary
    ORDER BY salary;
    
--VERIFY 
SET VERIFY ON;
SELECT employee_id, first_name, last_name
FROM employees WHERE employee_id = &emp_id;

--PARA DESABILITAR AS VARIÁVEIS DEFINE DO SCRIPT:
SET DEFINE OFF;


--uppercase
SELECT UPPER(first_name) || ' ' || UPPER(last_name) FROM employees;

--lowercase
SELECT LOWER(first_name) || ' ' || LOWER(last_name) FROM employees;

--initcap
SELECT INITCAP(first_name) || ' ' || INITCAP(last_name) FROM employees;


--NUMERIC FUNCTIONS
SELECT ROUND(12.352,2) FROM dual;
SELECT TRUNC(12.532,2) FROM dual;
SELECT CEIL(3.25) FROM dual;
SELECT FLOOR(3.25) FROM dual;
SELECT MOD(2,2) FROM dual;

--DATE VALUES & FORMATS
SELECT SYSDATE FROM dual;
SELECT CURRENT_DATE FROM dual;
SELECT SESSIONTIMEZONE FROM dual;
SELECT SYSTIMESTAMP FROM dual;
SELECT CURRENT_TIMESTAMP FROM dual;

SELECT SYSDATE, CURRENT_DATE, SESSIONTIMEZONE, SYSTIMESTAMP, CURRENT_TIMESTAMP FROM dual;

-- DATE OPERATIONS
SELECT SYSDATE, SYSDATE  + 15 "Previsão de entrega" FROM dual;

SELECT (SYSDATE + 15) - SYSDATE AS "DIFERENÇA DE DIAS" 
FROM dual -- operações entre duas datas devolvem o número de dias entre elas

--DATE MANIPULATION FUNCTIONS
SELECT sysdate, add_months(sysdate, -2) FROM dual; --ADD_MONTHS(date, n)
SELECT MONTHS_BETWEEN(sysdate, hire_date) FROM employees; --MONTHS_BETWEEN(date1, date2)
SELECT ROUND(sysdate,'MONTH') FROM dual; --ROUND(sysdate,'MONTH')
SELECT EXTRACT (month FROM sysdate) FROM dual; --EXTRACT(month from date)
SELECT NEXT_DAY(Sysdate, 'SEGUNDA') FROM dual; 
SELECT LAST_DAY(sysdate) FROM dual; 

SELECT MOD(2017,30) FROM dual; 

-- Conversion functions
SELECT first_name, hire_date,
        to_char(hire_date, 'YYYY') --TO_CHAR
FROM employees;

SELECT to_number('$5,322.33', '$99,999.000') formatted_number FROM dual;

--NVL Function
SELECT employee_id, salary, commission_pct, salary + salary * nvl(commission_pct,0) nvl_new_salary
FROM employees;
--O NVL substitui valores nulos pelo que foi especificado na segunda expressão, nesse caso é 0

--NVL2 Function
SELECT job_id, first_name, last_name, commission_pct, NVL2(commission_pct, 'tem', 'não tem') AS "NLV2 EXEMPLO"
FROM employees 
    WHERE job_id IN('SA_REP', 'IT_PROG') 
    ORDER BY commission_pct NULLS LAST;

--NULLIF Function
SELECT first_name, last_name,
    LENGTH(first_name) LENG1, LENGTH(last_name) LENG2,
    NULLIF(LENGTH(first_name), LENGTH(last_name)) "RESULT"
FROM employees;

/*Compara a primeira e a segunda expressão, se elas são iguais, returna NULL. 
Mas se elas não forem iguais, retorna expressão 1.*/



--CASE Statement
SELECT first_name, last_name, JOB_ID, salary, hire_date,
    CASE job_id 
        WHEN 'ST_MAN' THEN 1.20*salary
        WHEN 'SH_MAN' THEN 1.30*salary
        WHEN 'SA_MAN' THEN 1.30*salary
        ELSE salary
    END "Resultado"
FROM employees
WHERE job_id IN('ST_MAN','SH_MAN', 'SA_MAN');

--DECODE Function
SELECT first_name, last_name, job_id, salary, hire_date,
    DECODE(job_id,'ST_MAN', salary*1.20,
                  'SH_MAN', salary*1.30,
                  'SA_MAN', salary*1.40) UPDATE_SALARY
FROM employees
WHERE job_id IN('ST_MAN','SH_MAN', 'SA_MAN');

SELECT DECODE(1,1,'One',2,'Two') Result FROM dual;


--GROUP FUNCTIONS
--AVG, SUM, COUNT, MAX, MIN, LISTAGG

--AVG
SELECT AVG(salary), AVG(salary), AVG(DISTINCT salary) FROM employees;

--COUNT 
SELECT COUNT(*) employee_id FROM employees;

--MAX
SELECT MAX(salary) FROM employees;

--MIN
SELECT MIN(salary) FROM employees;

--SUM
SELECT SUM(salary) FROM employees;

--LISTAGG
SELECT LISTAGG(city, ', ') WITHIN GROUP (ORDER BY city) AS CITIES FROM locations
WHERE country_id = 'US';

SELECT MAX(salary), MIN(salary), COUNT(*), AVG(salary), LISTAGG(job_id, ', '), hire_date
FROM employees
GROUP BY hire_date;


--GROUP BY & HAVING
SELECT job_id, avg(salary) AS "media"
FROM employees
GROUP BY job_id
ORDER BY job_id


SELECT job_id, avg(salary) AS "media"
FROM employees
GROUP BY job_id
HAVING AVG(salary) >10000 
ORDER BY job_id

SELECT job_id, COUNT(employee_id) AS "Total de Funcionarios"
FROM employees
GROUP BY job_id
ORDER BY COUNT(employee_id) DESC

SELECT job_id, MIN(salary) "Menor", MAX(salary) "Maior", COUNT(employee_id)"Total" FROM employees
GROUP BY job_id


--JOINS
SELECT * FROM employees; 
SELECT * FROM departments;

--INNER JOIN
SELECT employee_id, first_name || ' ' || last_name AS "FULL NAME", job_id, department_name FROM employees
JOIN departments
    ON departments.department_id = employees.department_id
GROUP BY first_name, last_name, department_name, job_id, employee_id;
    
--NATURAL JOIN
SELECT * FROM employees NATURAL JOIN departments;
/*O natural join consiste em juntar duas tabelas que tenham colunas semelhantes*/ 

--USING
SELECT * FROM employees JOIN departments USING (department_id);
--Ele vai retornar os dados das duas tables que dão match com o parametro usado no USING

--Non-Equijoins (Juntando tables que não semelhantes) usando (<,>,<=,>=,<>)
SELECT e.employee_id, e.first_name, e.last_name, e.job_id, e.salary, j.min_salary,
        j.max_salary, j.job_id
FROM employees e JOIN jobs j
ON e.salary > max_salary AND j.job_id = 'SA_REP';

 --Subqueries
SELECT * FROM employees
WHERE employee_id = 145;

SELECT * FROM employees
WHERE salary > 14000;

SELECT * FROM employees WHERE salary > (SELECT salary FROM employees WHERE employee_id = 145);


SELECT * FROM employees
WHERE department_id =
                    (SELECT department_id FROM employees
                    WHERE employee_id = 145)
AND salary <
                    (SELECT salary FROM employees
                    WHERE employee_id = 145);
                    
SELECT * FROM employees
WHERE hire_date = 
            (SELECT Max(hire_date) FROM employees)
    
    
--Multiple row
--IN
SELECT first_name, last_name, department_id, salary
FROM employees
WHERE salary IN(SELECT MIN(salary) 
                FROM employees  
                GROUP BY department_id)
           
--ANY (=,>,<,>=,<=,!=,<>)                
SELECT first_name, last_name, department_id, salary
FROM employees
WHERE salary > ANY(SELECT salary FROM employees
                    WHERE job_id = 'SA_MAN')
                    
                    
--ALL (=,>,<,>=,<=,!=,<>)                
SELECT first_name, last_name, department_id, salary
FROM employees
WHERE salary < ALL(SELECT salary FROM employees
                    WHERE job_id = 'SA_MAN')
                                        
--Multiple columns
SELECT employee_id, first_name, last_name, department_id, salary
FROM employees
WHERE (department_id, salary) IN
            (SELECT department_id, salary 
            FROM employees WHERE employee_id IN (103,105,110))

--exists operator

SELECT employee_id, first_name, last_name, department_id
FROM employees a
WHERE EXISTS 
    (SELECT * FROM employees WHERE manager_id = a.employee_id)

--not exists operator  
SELECT employee_id, first_name, last_name, department_id
FROM employees a
WHERE NOT EXISTS 
    (SELECT * FROM employees WHERE manager_id = a.employee_id)
         
--SET OPERATORS
--UNION e UNION ALL
SELECT first_name, last_name, email, hire_date, job_id FROM retired_employees
UNION
SELECT first_name, last_name, email, hire_date, job_id FROM employees

SELECT first_name, last_name, email, hire_date, job_id FROM retired_employee
UNION ALL
SELECT first_name, last_name, email, hire_date, job_id FROM employees

--INTERSECT
SELECT first_name, last_name, email, hire_date, job_id FROM retired_employees
INTERSECT
SELECT first_name, last_name, email, hire_date, job_id FROM employees


--MINUS
SELECT first_name, last_name, email, hire_date, job_id FROM retired_employees
MINUS
SELECT first_name, last_name, email, hire_date, job_id FROM employees




                    
