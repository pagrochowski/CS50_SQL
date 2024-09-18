CREATE TABLE IF NOT EXISTS "students" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "enrollments" (
    "id" INTEGER,
    "student_id" INTEGER,
    "course_id" INTEGER,
    PRIMARY KEY("id"),
    FOREIGN KEY("student_id") REFERENCES "students"("id"),
    FOREIGN KEY("course_id") REFERENCES "courses"("id")
);
CREATE TABLE IF NOT EXISTS "courses" (
    "id" INTEGER,
    "department" TEXT NOT NULL,
    "number" INTEGER NOT NULL,
    "semester" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "satisfies" (
    "id" INTEGER,
    "course_id" INTEGER,
    "requirement_id" INTEGER,
    PRIMARY KEY("id"),
    FOREIGN KEY("course_id") REFERENCES "courses"("id"),
    FOREIGN KEY("requirement_id") REFERENCES "requirements"("id")
);
CREATE TABLE IF NOT EXISTS "requirements" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    PRIMARY KEY("id")
);


-- Query 1
EXPLAIN QUERY PLAN
SELECT "courses"."title", "courses"."semester"
FROM "enrollments"
JOIN "courses" ON "enrollments"."course_id" = "courses"."id"
JOIN "students" ON "enrollments"."student_id" = "students"."id"
WHERE "students"."id" = 3;

Run Time: real 0.435 user 0.031156 sys 0.045306

CREATE INDEX idx_enrollments_course_id ON enrollments(course_id);
CREATE INDEX idx_enrollments_student_id ON enrollments(student_id);

DROP INDEX idx_enrollments_course_id;
DROP INDEX idx_enrollments_student_id;

Run Time: real 0.005 user 0.000796 sys 0.000122

CREATE INDEX idx_enrollments_course_student ON enrollments(course_id, student_id);
DROP INDEX idx_enrollments_course_student;

Run Time: real 0.448 user 0.073870 sys 0.003460

QUERY PLAN
|--SEARCH students USING INTEGER PRIMARY KEY (rowid=?)
|--SCAN enrollments
`--SEARCH courses USING INTEGER PRIMARY KEY (rowid=?)`


-- Query 2

EXPLAIN QUERY PLAN
SELECT "id", "name"
FROM "students"
WHERE "id" IN (
    SELECT "student_id"
    FROM "enrollments"
    WHERE "course_id" = (
        SELECT "id"
        FROM "courses"
        WHERE "courses"."department" = 'Computer Science'
        AND "courses"."number" = 50
        AND "courses"."semester" = 'Fall 2023'
    )
);

Run Time: real 0.012 user 0.001433 sys 0.000432

QUERY PLAN
|--SEARCH students USING INTEGER PRIMARY KEY (rowid=?)
`--LIST SUBQUERY 2
   |--SEARCH enrollments USING INDEX idx_enrollments_course_id (course_id=?)
   `--SCALAR SUBQUERY 1
      `--SCAN courses`


CREATE INDEX idx_courses_department ON courses(department);
CREATE INDEX idx_courses_number ON courses(number);
CREATE INDEX idx_courses_semester ON courses(semester);

Run Time: real 0.008 user 0.000924 sys 0.000276

DROP INDEX idx_courses_department;
DROP INDEX idx_courses_semester;

Run Time: real 0.001 user 0.000000 sys 0.000380

-- Query 3

EXPLAIN QUERY PLAN
SELECT "courses"."id", "courses"."department", "courses"."number", "courses"."title", COUNT(*) AS "enrollment"
FROM "courses"
JOIN "enrollments" ON "enrollments"."course_id" = "courses"."id"
WHERE "courses"."semester" = 'Fall 2023'
GROUP BY "courses"."id"
ORDER BY "enrollment" DESC;

Run Time: real 0.146 user 0.012492 sys 0.010998

QUERY PLAN
|--SCAN courses
|--SEARCH enrollments USING COVERING INDEX idx_enrollments_course_id (course_id=?)
`--USE TEMP B-TREE FOR ORDER BY`

CREATE INDEX idx_courses_semester ON courses(semester);

Run Time: real 0.137 user 0.017570 sys 0.002192

-- Query 4

EXPLAIN QUERY PLAN
SELECT "courses"."id", "courses"."department", "courses"."number", "courses"."title"
FROM "courses"
WHERE "courses"."department" = 'Computer Science'
AND "courses"."semester" = 'Spring 2024';

Run Time: real 0.030 user 0.002870 sys 0.000875

QUERY PLAN
`--SEARCH courses USING INDEX idx_courses_semester (semester=?)`

CREATE INDEX idx_courses_department ON courses(department);

Run Time: real 0.002 user 0.000707 sys 0.000000

-- Query 5

EXPLAIN QUERY PLAN
SELECT "requirements"."name"
FROM "requirements"
WHERE "requirements"."id" = (
    SELECT "requirement_id"
    FROM "satisfies"
    WHERE "course_id" = (
        SELECT "id"
        FROM "courses"
        WHERE "title" = 'Advanced Databases'
        AND "semester" = 'Fall 2023'
    )
);

Run Time: real 0.009 user 0.001292 sys 0.000000

QUERY PLAN
|--SEARCH requirements USING INTEGER PRIMARY KEY (rowid=?)
`--SCALAR SUBQUERY 2
   |--SCAN satisfies
   `--SCALAR SUBQUERY 1
      `--SEARCH courses USING INDEX idx_courses_semester (semester=?)`

CREATE INDEX idx_satisfies_requirement_id ON satisfies(requirement_id);
CREATE INDEX idx_satisfies_course_id ON satisfies(course_id);
CREATE INDEX idx_courses_title ON courses(title);

Run Time: real 0.002 user 0.000245 sys 0.000075

QUERY PLAN
|--SEARCH requirements USING INTEGER PRIMARY KEY (rowid=?)
`--SCALAR SUBQUERY 2
   |--SEARCH satisfies USING INDEX idx_satisfies_course_id (course_id=?)
   `--SCALAR SUBQUERY 1
      `--SEARCH courses USING INDEX idx_courses_title (title=?)`

DROP INDEX idx_satisfies_requirement_id;

Run Time: real 0.001 user 0.000000 sys 0.000202


-- Query 6

EXPLAIN QUERY PLAN
SELECT "requirements"."name", COUNT(*) AS "courses"
FROM "requirements"
JOIN "satisfies" ON "requirements"."id" = "satisfies"."requirement_id"
WHERE "satisfies"."course_id" IN (
    SELECT "course_id"
    FROM "enrollments"
    WHERE "enrollments"."student_id" = 8
)
GROUP BY "requirements"."name";

Run Time: real 0.006 user 0.000000 sys 0.000770

QUERY PLAN
|--SEARCH satisfies USING INDEX idx_satisfies_course_id (course_id=?)
|--LIST SUBQUERY 1
|  `--SEARCH enrollments USING INDEX idx_enrollments_student_id (student_id=?)
|--SEARCH requirements USING INTEGER PRIMARY KEY (rowid=?)
`--USE TEMP B-TREE FOR GROUP BY

CREATE INDEX idx_satisfies_requirement_id ON satisfies(requirement_id);
CREATE INDEX idx_enrollments_student_id ON enrollments(student_id);
CREATE INDEX idx_enrollments_course_id ON enrollments(course_id);

Run Time: real 0.001 user 0.000410 sys 0.000000

QUERY PLAN
|--SEARCH satisfies USING INDEX idx_satisfies_course_id (course_id=?)
|--LIST SUBQUERY 1
|  `--SEARCH enrollments USING INDEX idx_enrollments_student_id (student_id=?)
|--SEARCH requirements USING INTEGER PRIMARY KEY (rowid=?)
`--USE TEMP B-TREE FOR GROUP BY


DROP INDEX idx_enrollments_course_id;

-- Query 7

EXPLAIN QUERY PLAN
SELECT "department", "number", "title"
FROM "courses"
WHERE "title" LIKE "History%"
AND "semester" = 'Fall 2023';

Run Time: real 0.032 user 0.002853 sys 0.000875

QUERY PLAN
`--SEARCH courses USING INDEX idx_courses_semester (semester=?)`