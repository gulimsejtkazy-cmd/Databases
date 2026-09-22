CREATE DATABASE university_main
    WITH
    OWNER = postgres
    TEMPLATE = template0
    ENCODING = 'UTF8';
CREATE DATABASE university_archive
    WITH
    TEMPLATE = template0
    CONNECTION LIMIT = 50;
-- 3. university_test
CREATE DATABASE university_test
    WITH
    TEMPLATE = template0
    CONNECTION LIMIT = 10
    IS_TEMPLATE = true;
SELECT
    datname,
    pg_encoding_to_char(encoding) AS encoding,
    datconnlimit,
    datistemplate
FROM pg_database
WHERE datname IN (
                  'university_main',
                  'university_archive',
                  'university_test'
    );

-- Task 1.2: Tablespace Operations
-- 1. Create tablespace student_data
CREATE TABLESPACE student_data
    LOCATION '/data/students';

-- 2. Create tablespace course_data
CREATE TABLESPACE course_data
    OWNER CURRENT_USER
    LOCATION '/data/courses';

-- 3. Create database university_distributed
CREATE DATABASE university_distributed
    WITH
    TABLESPACE = student_data
    ENCODING = 'LATIN9';

-- 4. Проверка результатов
SELECT spcname AS tablespace_name,
       pg_catalog.pg_get_userbyid(spcowner) AS owner,
       pg_tablespace_location(oid) AS location
FROM pg_tablespace
WHERE spcname IN ('student_data', 'course_data');

SELECT datname AS database_name,
       pg_encoding_to_char(encoding) AS encoding,
       spcname AS default_tablespace
FROM pg_database d
         JOIN pg_tablespace t ON d.dattablespace = t.oid
WHERE datname = 'university_distributed';

-- 1. Создание таблицы students
CREATE TABLE students (
                          student_id SERIAL PRIMARY KEY,
                          first_name VARCHAR(50),
                          last_name VARCHAR(50),
                          email VARCHAR(100),
                          phone CHAR(15),
                          date_of_birth DATE,
                          enrollment_date DATE,
                          gpa NUMERIC(3, 2),
                          is_active BOOLEAN,
                          graduation_year SMALLINT
);

-- 2. Создание таблицы professors
CREATE TABLE professors (
                            professor_id SERIAL PRIMARY KEY,
                            first_name VARCHAR(50),
                            last_name VARCHAR(50),
                            email VARCHAR(100),
                            office_number VARCHAR(20),
                            hire_date DATE,
                            salary NUMERIC(12, 2),
                            is_tenured BOOLEAN,
                            years_experience INTEGER
);

-- 3. Создание таблицы courses
CREATE TABLE courses (
                         course_id SERIAL PRIMARY KEY,
                         course_code CHAR(8),
                         course_title VARCHAR(100),
                         description TEXT,
                         credits SMALLINT,
                         max_enrollment INTEGER,
                         course_fee NUMERIC(10, 2),
                         is_online BOOLEAN,
                         created_at TIMESTAMP WITHOUT TIME ZONE
);

-- Проверка созданных таблиц и их колонок
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_name IN ('students', 'professors', 'courses')
ORDER BY table_name, ordinal_position;

--Task 2.2:
-- 1. Создание таблицы class_schedule
CREATE TABLE class_schedule (
                                schedule_id SERIAL PRIMARY KEY,
                                course_id INTEGER,
                                professor_id INTEGER,
                                classroom VARCHAR(20),
                                class_date DATE,
                                start_time TIME WITHOUT TIME ZONE,
                                end_time TIME WITHOUT TIME ZONE,
                                duration INTERVAL
);

-- 2. Создание таблицы student_records
CREATE TABLE student_records (
                                 record_id SERIAL PRIMARY KEY,
                                 student_id INTEGER,
                                 course_id INTEGER,
                                 semester VARCHAR(20),
                                 year INTEGER,
                                 grade CHAR(2),
                                 attendance_percentage NUMERIC(4, 1),
                                 submission_timestamp TIMESTAMP WITH TIME ZONE,
                                 last_updated TIMESTAMP WITH TIME ZONE
);

-- 3. Проверка созданных таблиц
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_name IN ('class_schedule', 'student_records')
ORDER BY table_name, ordinal_position;

--Part 3: Advanced ALTER TABLE Operations
--Task 3.1: Modifying Existing Tables

-- 1. Модификация таблицы students
ALTER TABLE students
    ADD COLUMN middle_name VARCHAR(30),
    ADD COLUMN student_status VARCHAR(20) DEFAULT 'ACTIVE',
    ALTER COLUMN phone TYPE VARCHAR(20),
    ALTER COLUMN gpa SET DEFAULT 0.00;

-- 2. Модификация таблицы professors
ALTER TABLE professors
    ADD COLUMN department_code CHAR(5),
    ADD COLUMN research_area TEXT,
    ALTER COLUMN years_experience TYPE SMALLINT,
    ALTER COLUMN is_tenured SET DEFAULT FALSE,
    ADD COLUMN last_promotion_date DATE;

-- 3. Модификация таблицы courses
ALTER TABLE courses
    ADD COLUMN prerequisite_course_id INTEGER,
    ADD COLUMN difficulty_level SMALLINT,
    ALTER COLUMN course_code TYPE VARCHAR(10),
    ALTER COLUMN credits SET DEFAULT 3,
    ADD COLUMN lab_required BOOLEAN DEFAULT FALSE;

-- 4. Проверка изменений (структуры и значений по умолчанию)
SELECT table_name, column_name, data_type, column_default
FROM information_schema.columns
WHERE table_name IN ('students', 'professors', 'courses')
ORDER BY table_name, ordinal_position;

--Task 3.2: Column Management Operations
-- 1. Модификация таблицы class_schedule
ALTER TABLE class_schedule
    ADD COLUMN room_capacity INTEGER,
    DROP COLUMN duration,
    ADD COLUMN session_type VARCHAR(15),
    ALTER COLUMN classroom TYPE VARCHAR(30),
    ADD COLUMN equipment_needed TEXT;

-- 2. Модификация таблицы student_records
ALTER TABLE student_records
    ADD COLUMN extra_credit_points NUMERIC(3, 1) DEFAULT 0.0,
    ALTER COLUMN grade TYPE VARCHAR(5),
    ADD COLUMN final_exam_date DATE,
    DROP COLUMN last_updated;

-- 3. Проверка обновленной структуры
SELECT table_name, column_name, data_type, column_default
FROM information_schema.columns
WHERE table_name IN ('class_schedule', 'student_records')
ORDER BY table_name, ordinal_position;

--Part 4: Table Relationships and Management
-- 1. Создание таблицы departments
CREATE TABLE departments (
                             department_id SERIAL PRIMARY KEY,
                             department_name VARCHAR(100),
                             department_code CHAR(5),
                             building VARCHAR(50),
                             phone VARCHAR(15),
                             budget NUMERIC(15, 2),
                             established_year INTEGER
);

-- 2. Создание таблицы library_books
CREATE TABLE library_books (
                               book_id SERIAL PRIMARY KEY,
                               isbn CHAR(13),
                               title VARCHAR(200),
                               author VARCHAR(100),
                               publisher VARCHAR(100),
                               publication_date DATE,
                               price NUMERIC(10, 2),
                               is_available BOOLEAN,
                               acquisition_timestamp TIMESTAMP WITHOUT TIME ZONE
);

-- 3. Создание таблицы student_book_loans
CREATE TABLE student_book_loans (
                                    loan_id SERIAL PRIMARY KEY,
                                    student_id INTEGER,
                                    book_id INTEGER,
                                    loan_date DATE,
                                    due_date DATE,
                                    return_date DATE,
                                    fine_amount NUMERIC(8, 2),
                                    loan_status VARCHAR(20)
);

-- 4. Проверка созданных таблиц
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_name IN ('departments', 'library_books', 'student_book_loans')
ORDER BY table_name, ordinal_position;


--Task 4.2: Table Modifications for Integration
-- 1. Добавление внешних ключей (пока только столбцов, без FOREIGN KEY связей)
ALTER TABLE professors
    ADD COLUMN department_id INTEGER;

ALTER TABLE students
    ADD COLUMN advisor_id INTEGER;

ALTER TABLE courses
    ADD COLUMN department_id INTEGER;

-- 2. Создание таблицы-справочника grade_scale
CREATE TABLE grade_scale (
                             grade_id SERIAL PRIMARY KEY,
                             letter_grade CHAR(2),
                             min_percentage NUMERIC(4, 1),
                             max_percentage NUMERIC(4, 1),
                             gpa_points NUMERIC(3, 2)
);

-- 3. Создание таблицы-справочника semester_calendar
CREATE TABLE semester_calendar (
                                   semester_id SERIAL PRIMARY KEY,
                                   semester_name VARCHAR(20),
                                   academic_year INTEGER,
                                   start_date DATE,
                                   end_date DATE,
                                   registration_deadline TIMESTAMP WITH TIME ZONE,
                                   is_current BOOLEAN
);

-- 4. Проверка созданных столбцов и таблиц
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE (table_name IN ('professors', 'students', 'courses') AND column_name IN ('department_id', 'advisor_id'))
   OR table_name IN ('grade_scale', 'semester_calendar')
ORDER BY table_name, ordinal_position;

-- =========================================================
-- Part 5: Table Deletion and Cleanup
-- Task 5.1: Conditional Table Operations
-- =========================================================

-- 1. Удаление таблиц, если они существуют
DROP TABLE IF EXISTS student_book_loans;
DROP TABLE IF EXISTS library_books;
DROP TABLE IF EXISTS grade_scale;

-- 2. Пересоздание таблицы grade_scale с новым столбцом description
CREATE TABLE grade_scale (
                             grade_id SERIAL PRIMARY KEY,
                             letter_grade CHAR(2),
                             min_percentage NUMERIC(4, 1),
                             max_percentage NUMERIC(4, 1),
                             gpa_points NUMERIC(3, 2),
                             description TEXT
);

-- 3. Удаление таблицы semester_calendar с опцией CASCADE и её пересоздание
DROP TABLE IF EXISTS semester_calendar CASCADE;

CREATE TABLE semester_calendar (
                                   semester_id SERIAL PRIMARY KEY,
                                   semester_name VARCHAR(20),
                                   academic_year INTEGER,
                                   start_date DATE,
                                   end_date DATE,
                                   registration_deadline TIMESTAMP WITH TIME ZONE,
                                   is_current BOOLEAN
);

-- =========================================================
-- Task 5.2: Database Cleanup
-- Примечание: Для выполнения CREATE/DROP DATABASE переключитесь на базу postgres!
-- =========================================================

-- 1. Снимаем статус шаблона с баз данных
ALTER DATABASE university_test IS_TEMPLATE false;
ALTER DATABASE university_distributed IS_TEMPLATE false;

-- 2. Теперь удаляем базы данных
DROP DATABASE IF EXISTS university_test;
DROP DATABASE IF EXISTS university_distributed;

-- 3. Создаём резервную копию из шаблона university_main
CREATE DATABASE university_backup TEMPLATE university_main;

-- Проверка наличия баз данных
SELECT datname FROM pg_database
WHERE datname IN ('university_test', 'university_distributed', 'university_backup');