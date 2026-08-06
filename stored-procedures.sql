--create function return table
CREATE OR REPLACE FUNCTION country_region()
RETURNS TABLE(id CHARACTER(2), name VARCHAR(40), region VARCHAR(25)) 
AS $$
	BEGIN
		RETURN query
			SELECT country_id, country_name, region_name FROM countries
			INNER JOIN regions ON countries.region_id = regions.region_id;
	END;
$$ LANGUAGE plpgsql;


SELECT * from country_region();


-- create stored procedure
CREATE
OR REPLACE PROCEDURE insert_region_proc (int, varchar) AS $$
BEGIN
	INSERT INTO regions (region_id, region_name)
	VALUES($1, $2);
	
	RAISE NOTICE 'Variables: %, %', $1, $2;
	
-- 	ROLLBACK;
	COMMIT;

END;

$$ LANGUAGE plpgsql;

CALL insert_region_proc(5, 'Central America');

SELECT * FROM regions;


-- Salary increase
SELECT
  current_date AS "date",
  salary,
  max_raise (employee_id),
  max_raise (employee_id) * 0.01 AS amount,
  1 AS percentage
FROM
  employees;

--create stored procedure controlled_raise
CREATE OR REPLACE PROCEDURE controlled_raise(percentage NUMERIC) AS
$$
DECLARE
	real_percentage NUMERIC(8,2);
	total_employees int;

BEGIN
	real_percentage = percentage / 100;
	--   RAISE NOTICE 'Percentage: %', percentage;
	-- history
	INSERT INTO raise_history (date, employee_id, base_salary, amount, percentage)
	SELECT
	  current_date AS "date",
	  employee_id,
	  salary,
	  max_raise (employee_id) * real_percentage AS amount,
	  percentage
	FROM
	  employees;
	  
	-- updated table employees
	UPDATE employees
		SET salary = (max_raise(employee_id) * real_percentage) + salary;
	 
	COMMIT;
	
	SELECT COUNT(*) INTO total_employees FROM employees;
	RAISE NOTICE 'Afected % employees', total_employees;

END;
$$ LANGUAGE plpgsql;

CALL controlled_raise(1);

SELECT * from raise_history;
SELECT * FROM employees;

--install extention pgcrypto
CREATE EXTENSION pgcrypto;

-- insert data with password encrypt
INSERT INTO user_trigger (username, password)
VALUES(
	'job',
	crypt('123456', gen_salt('bf'))
)


SELECT * FROM user_trigger;

SELECT * FROM user_trigger 
WHERE username = 'job' AND password = crypt('123456', password);

SELECT COUNT(*) FROM user_trigger 
WHERE username = 'job' AND password = crypt('123456', password);


--create stored procedure user_login
CREATE OR REPLACE PROCEDURE user_login(user_name VARCHAR, user_password VARCHAR)
AS $$
DECLARE
	was_found BOOLEAN;
BEGIN
	
	SELECT COUNT(*) INTO was_found FROM user_trigger 
		WHERE username = user_name AND password = crypt(user_password, password);
		
	IF (was_found = false) THEN
		INSERT INTO session_failed(username, "when")
		VALUES(user_name, now());
		
		COMMIT;
		
		RAISE EXCEPTION 'User and password are invalid';
	ELSE
		UPDATE user_trigger 
		SET last_login = now() 
		WHERE username = user_name;
		
		COMMIT;
		
		RAISE NOTICE 'User found %', was_found;
	END IF;
END;

$$ LANGUAGE plpgsql;

CALL user_login('job','123456 ');

SELECT * FROM user_trigger;
SELECT * FROM session_failed;


-- CREATE TRIGGER create_session_trigger
CREATE OR REPLACE TRIGGER create_session_trigger AFTER UPDATE ON user_trigger
FOR EACH ROW 
WHEN (OLD.last_login IS DISTINCT FROM NEW.last_login)
EXECUTE FUNCTION create_session_log();

CREATE OR REPLACE FUNCTION create_session_log()
RETURNS TRIGGER AS $$

BEGIN
	INSERT INTO "session"(user_id, last_login) VALUES(NEW.id, now());
	RETURN NEW;
END;

$$ LANGUAGE plpgsql;


CALL user_login('moises','123456');
SELECT * FROM "session";
SELECT * FROM user_trigger;