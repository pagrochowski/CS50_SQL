-- Query 1
CREATE INDEX idx_enrollments_course_id ON enrollments(course_id);
CREATE INDEX idx_enrollments_student_id ON enrollments(student_id);

-- Query 2
CREATE INDEX idx_courses_number ON courses(number);

-- Query 3
CREATE INDEX idx_courses_semester ON courses(semester);

-- Query 4
CREATE INDEX idx_courses_department ON courses(department);

-- Query 5
CREATE INDEX idx_satisfies_course_id ON satisfies(course_id);
CREATE INDEX idx_courses_title ON courses(title);

-- Query 6
CREATE INDEX idx_satisfies_requirement_id ON satisfies(requirement_id);