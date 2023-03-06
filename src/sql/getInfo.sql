CREATE OR REPLACE VIEW studentInformation AS
SELECT idnr as student, b.name, b.login, b.program, b.branch, 
f.course as readCourses, f.grade as finishedGrade, f.credits as finishedCredits, 
r.course as regCourses, r.status, 
    CASE
        WHEN r.status = 'registered' THEN 0
        WHEN r.status = 'waiting' THEN c.place
    END as position,
p.seminarCourses as seminarCoursePass, 
p.mathCredits, p.researchCredits, p.totalCredits, p.qualified as canGraduate
FROM BasicInformation b
LEFT JOIN FinishedCourses f ON idnr = f.student
LEFT JOIN Registrations r ON idnr = r.student
LEFT JOIN CourseQueuePositions c ON r.course = c.course AND r.status = 'waiting' AND idnr = c.student
LEFT JOIN PathToGraduation p ON idnr = p.student
ORDER BY idnr;


-- SUCCESS
WITH CourseAndName AS 
(SELECT code, name FROM Courses),
FinishedCoursesAgg AS
(SELECT f.student,
       json_agg(
        json_build_object(
        'course', cn.name,
        'code', cn.code,
        'credits', credits,
        'grade', grade
            ))
        AS courses
        FROM FinishedCourses f
        JOIN CourseAndName cn 
        ON f.course = cn.code
        GROUP BY f.student
        ORDER BY f.student
    ),
RegisteredCoursesAgg AS 
(SELECT r.student,
        json_agg(
        json_build_object(
        'course', cn.name,
        'code', cn.code,
        'status', r.status,
        'position', CASE
                        WHEN r.status = 'registered' THEN 0
                        WHEN r.status = 'waiting' THEN c.place
                    END
                    ))
        AS courses
        FROM Registrations r 
        LEFT JOIN CourseQueuePositions c 
        ON r.course = c.course
        AND r.student = c.student
        JOIN CourseAndName cn ON r.course = cn.code
        GROUP BY r.student
        ORDER BY r.student
    )
SELECT DISTINCT ON (si.student)
    json_build_object(
        'student', si.student,
        'name', si.name,
        'login', si.login,
        'program', si.program,
        'branch', si.branch,
        'finished', COALESCE(fc.courses, '[]' :: json),
        'registered', COALESCE(rc.courses, '[]' :: json),
        'seminarCourses', si.seminarCoursePass,
        'mathCredits', si.mathCredits,
        'researchCredits', si.researchCredits,
        'totalCredits', si.totalCredits,
        'canGraduate', si.canGraduate
    )
FROM studentInformation si
LEFT JOIN FinishedCoursesAgg fc ON si.student = fc.student
LEFT JOIN RegisteredCoursesAgg rc ON si.student = rc.student
ORDER BY si.student;





-- FINished

WITH CourseAndName AS 
(SELECT code, name FROM Courses)
SELECT f.student,
       json_agg(
        json_build_object(
        'course', cn.name,
        'code', cn.code,
        'credits', credits,
        'grade', grade
            ))
        AS courses
        FROM FinishedCourses f
        JOIN CourseAndName cn 
        ON f.course = cn.code
        GROUP BY f.student
        ORDER BY f.student;



--REgistered | DO NOT JOIN with studentInformation as this will get you duplicate values of courses
WITH CourseAndName AS 
(SELECT code, name FROM Courses)
SELECT r.student,
        json_agg(
        json_build_object(
        'course', cn.name,
        'code', cn.code,
        'status', r.status,
        'position', CASE
                        WHEN r.status = 'registered' THEN 0
                        WHEN r.status = 'waiting' THEN c.place
                    END
                    ))
        AS courses
        FROM Registrations r 
        LEFT JOIN CourseQueuePositions c 
        ON r.course = c.course
        AND r.student = c.student
        JOIN CourseAndName cn ON r.course = cn.code
        GROUP BY r.student
        ORDER BY r.student;


-- WITH CourseAndName AS 
--     (SELECT code, name 
--     FROM Courses)
-- SELECT r.student, cn.name as course_name, r.course as code, r.status, c.place as position
-- FROM Registrations r 
-- LEFT JOIN CourseQueuePositions c 
--     ON r.course = c.course
--     AND c.student = r.student
-- JOIN CourseAndName cn ON 
--     r.course = cn.code
-- ORDER BY r.student;


-- 'registered', (SELECT json_agg(
--                     json_build_object(
--                         'course', cn.name,
--                         'code', cn.code,
--                         'status', r.status,
--                         'position', CASE
--                                         WHEN r.status = 'registered' THEN 0
--                                         WHEN r.status = 'waiting' THEN c.place
--                                     END
--                     )
--                 )
--                 FROM Registrations r 
--                 LEFT JOIN CourseQueuePositions c 
--                     ON r.course = c.course
--                     AND c.student = r.student
--                 JOIN CourseAndName cn ON r.course = cn.code),


-- WITH CourseAndName AS 
--     (SELECT code, name 
--     FROM Courses)
-- SELECT json_agg(
--                     json_build_object(
--                         'course', cn.name,
--                         'code', cn.code,
--                         'status', r.status,
--                         'position', CASE
--                                         WHEN r.status = 'registered' THEN 0
--                                         WHEN r.status = 'waiting' THEN c.place
--                                     END
--                     )
--                 )
--                 FROM Registrations r 
--                 LEFT JOIN CourseQueuePositions c 
--                     ON r.course = c.course
--                     AND c.student = r.student
--                 JOIN CourseAndName cn ON r.course = cn.code;



-- [{"student" : "2222222222", 
-- "name" : "N2", 
-- "login" : "ls2", 
-- "program" : "Prog1", 
-- "branch" : "B1", 
-- "finished" : 
-- [{"course" : "C1", "code" : "CCC111", "credits" : 22.5, "grade" : "U"}, {"course" : "C2", "code" : "CCC222", "credits" : 20, "grade" : "U"}, {"course" : "C4", "code" : "CCC444", "credits" : 60, "grade" : "U"}],
-- "registered": [{"course" : "C2", "code" : "CCC222", "status" : "registered", "position" : 0}, {"course" : "C7", "code" : "CCC777", "status" : "waiting", "position" : 1}, {"course" : "C9", "code" : "CCC999", "status" : "registered", "position" : 0}],
-- "seminarCourses": 0,
-- "mathCredits": 0,
-- "researchCredits": 0,
-- "totalCredits": 0,
-- "canGraduate": false },

-- { "student": "2222222222",
-- "name": "N2",
-- "login": "ls2",
-- "program": "Prog1",
-- "branch": "B1",
-- "finished": 
-- [{"course" : "C1", "code" : "CCC111", "credits" : 22.5, "grade" : "U"}, {"course" : "C2", "code" : "CCC222", "credits" : 20, "grade" : "U"}, {"course" : "C4", "code" : "CCC444", "credits" : 60, "grade" : "U"}],
-- "registered": [{"course" : "C2", "code" : "CCC222", "status" : "registered", "position" : 0}, {"course" : "C7", "code" : "CCC777", "status" : "waiting", "position" : 1}, {"course" : "C9", "code" : "CCC999", "status" : "registered", "position" : 0}],
-- "seminarCourses": 0,
-- "mathCredits": 0,
-- "researchCredits": 0,
-- "totalCredits": 0,
-- "canGraduate": false },