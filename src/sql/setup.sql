CREATE TABLE Departments(
    name TEXT NOT NULL,
    abbreviation TEXT NOT NULL,
    PRIMARY KEY(name),
    UNIQUE(abbreviation)
);

CREATE TABLE Programs(
    name TEXT NOT NULL,
    abbreviation TEXT NOT NULL,
    department TEXT NOT NULL,
    PRIMARY KEY(name),
    FOREIGN KEY (department) REFERENCES Departments(name)
);

CREATE TABLE Students(
    idnr CHAR(10) NOT NULL,
    name TEXT NOT NULL,
    login TEXT NOT NULL UNIQUE,
    program TEXT NOT NULL,
    PRIMARY KEY(idnr),
    FOREIGN KEY (program) REFERENCES Programs(name),
    UNIQUE(idnr, program)
);

CREATE TABLE Branches(
    name TEXT NOT NULL,
    program TEXT NOT NULL,
    PRIMARY KEY(name, program),
    FOREIGN KEY (program) REFERENCES Programs(name)
);

CREATE TABLE Courses(
    code CHAR(6) NOT NULL,
    name TEXT NOT NULL,
    credits FLOAT NOT NULL CHECK (credits >= 0),
    department TEXT NOT NULL,
    PRIMARY KEY(code),
    FOREIGN KEY (department) REFERENCES Departments(name)
);

CREATE TABLE LimitedCourses(
    code CHAR(6) NOT NULL,
    capacity INT NOT NULL CHECK (capacity >= 0),
    PRIMARY KEY (code),
    FOREIGN KEY (code) REFERENCES Courses(code)
);

CREATE TABLE StudentBranches(
    student CHAR(10) NOT NULL,
    branch TEXT NOT NULL,
    program TEXT NOT NULL,
    PRIMARY KEY(student),
    FOREIGN KEY (student, program) REFERENCES Students(idnr, program),
    FOREIGN KEY (branch, program) REFERENCES branches(name, program)
);

CREATE TABLE Classifications(
    name TEXT NOT NULL,
    PRIMARY KEY (name)
);

CREATE TABLE Classified(
    course CHAR(6) NOT NULL,
    classification TEXT NOT NULL,
    PRIMARY KEY (course, classification),
    FOREIGN KEY (course) REFERENCES Courses(code),
    FOREIGN KEY (classification) REFERENCES Classifications(name)
);

CREATE TABLE MandatoryProgram(
    course CHAR(6) NOT NULL,
    program TEXT NOT NULL,
    PRIMARY KEY (course, program),
    FOREIGN KEY (course) REFERENCES Courses (code),
    FOREIGN KEY (program) REFERENCES Programs(name)
);

CREATE TABLE MandatoryBranch(
    course CHAR(6) NOT NULL,
    branch TEXT NOT NULL,
    program TEXT NOT NULL,
    PRIMARY KEY (course, branch, program),
    FOREIGN KEY (course) REFERENCES Courses (code),
    FOREIGN KEY (branch, program) REFERENCES Branches (name, program)
);

CREATE TABLE RecommendedBranch(
    course CHAR(6) NOT NULL,
    branch TEXT NOT NULL,
    program TEXT NOT NULL,
    PRIMARY KEY (course, branch, program),
    FOREIGN KEY (course) REFERENCES Courses (code),
    FOREIGN KEY (branch, program) REFERENCES Branches (name, program)
);

CREATE TABLE Registered(
    student CHAR(10) NOT NULL,
    course CHAR(6) NOT NULL,
    PRIMARY KEY (student, course),
    FOREIGN KEY (student) REFERENCES Students(idnr),
    FOREIGN KEY (course) REFERENCES Courses(code)
);

CREATE TABLE Taken(
    student CHAR(10) NOT NULL,
    course CHAR(6) NOT NULL,
    grade CHAR(1) NOT NULL CHECK (grade IN ('U', '3', '4', '5')),
    PRIMARY KEY(student, course),
    FOREIGN KEY (student) REFERENCES Students(idnr),
    FOREIGN KEY (course) REFERENCES Courses(code)
);

CREATE TABLE WaitingList(
    student CHAR(10) NOT NULL,
    course CHAR(6) NOT NULL,
    position SERIAL NOT NULL,
    PRIMARY KEY(student, course),
    FOREIGN KEY (student) REFERENCES Students(idnr),
    FOREIGN KEY (course) REFERENCES Courses(code),
    UNIQUE (course, position)
);

CREATE TABLE Prerequisites(
    course CHAR(6),
    requiredCourse CHAR(6),
    PRIMARY KEY(course, requiredCourse),
    FOREIGN KEY (course) REFERENCES Courses(code),
    FOREIGN KEY (requiredCourse) REFERENCES Courses
);




INSERT INTO Departments VALUES ('Dep2','D2');
INSERT INTO Departments VALUES ('Dep1','D1');





INSERT INTO Programs VALUES ('Prog2','P2', 'Dep1');
INSERT INTO Programs VALUES ('Prog1','P1', 'Dep1');





INSERT INTO Students VALUES ('1111111111','N1','ls1','Prog1');
INSERT INTO Students VALUES ('2222222222','N2','ls2','Prog1');
INSERT INTO Students VALUES ('3333333333','N3','ls3','Prog2');
INSERT INTO Students VALUES ('4444444444','N4','ls4','Prog1');
INSERT INTO Students VALUES ('5555555555','Nx','ls5','Prog2');
INSERT INTO Students VALUES ('6666666666','Nx','ls6','Prog2');
INSERT INTO Students VALUES ('7777777777','Nx','ls7','Prog2');




INSERT INTO Branches VALUES ('B1','Prog1');
INSERT INTO Branches VALUES ('B2','Prog1');
INSERT INTO Branches VALUES ('B1','Prog2');





INSERT INTO Courses VALUES ('CCC111','C1',22.5,'Dep1');
INSERT INTO Courses VALUES ('CCC222','C2',20,'Dep1');
INSERT INTO Courses VALUES ('CCC333','C3',30,'Dep1');
INSERT INTO Courses VALUES ('CCC444','C4',60,'Dep1');
INSERT INTO Courses VALUES ('CCC555','C5',50,'Dep1');
INSERT INTO Courses VALUES ('CCC666','C6',20,'Dep1');
INSERT INTO Courses VALUES ('CCC777','C7',20,'Dep1');
INSERT INTO Courses VALUES ('CCC888','C8',20,'Dep1');
INSERT INTO Courses VALUES ('CCC999','C9',20,'Dep1');
INSERT INTO Courses VALUES ('CCC000','C0',20,'Dep1');
INSERT INTO Courses VALUES ('CCC123','C123',20,'Dep1');

INSERT INTO Courses VALUES ('CCC456','C456',20,'Dep1');


INSERT INTO Prerequisites VALUES ('CCC123','CCC111');



INSERT INTO LimitedCourses VALUES ('CCC222',1);
INSERT INTO LimitedCourses VALUES ('CCC333',2);
INSERT INTO LimitedCourses VALUES ('CCC666',1);
INSERT INTO LimitedCourses VALUES ('CCC777',1);
INSERT INTO LimitedCourses VALUES ('CCC888',1);
INSERT INTO LimitedCourses VALUES ('CCC999',4);
INSERT INTO LimitedCourses VALUES ('CCC000',1);
INSERT INTO LimitedCourses VALUES ('CCC456', 1);





INSERT INTO Classifications VALUES ('math');
INSERT INTO Classifications VALUES ('research');
INSERT INTO Classifications VALUES ('seminar');




INSERT INTO Classified VALUES ('CCC333','math');
INSERT INTO Classified VALUES ('CCC444','math');
INSERT INTO Classified VALUES ('CCC444','research');
INSERT INTO Classified VALUES ('CCC444','seminar');




INSERT INTO StudentBranches VALUES ('2222222222','B1','Prog1');
INSERT INTO StudentBranches VALUES ('3333333333','B1','Prog2');
INSERT INTO StudentBranches VALUES ('4444444444','B1','Prog1');
INSERT INTO StudentBranches VALUES ('5555555555','B1','Prog2');




INSERT INTO MandatoryProgram VALUES ('CCC111','Prog1');



INSERT INTO MandatoryBranch VALUES ('CCC333', 'B1', 'Prog1');
INSERT INTO MandatoryBranch VALUES ('CCC444', 'B1', 'Prog2');



INSERT INTO RecommendedBranch VALUES ('CCC222', 'B1', 'Prog1');
INSERT INTO RecommendedBranch VALUES ('CCC333', 'B1', 'Prog2');



INSERT INTO Registered VALUES ('1111111111','CCC111');

INSERT INTO Registered VALUES ('1111111111','CCC222');
INSERT INTO Registered VALUES ('5555555555','CCC222');
INSERT INTO Registered VALUES ('2222222222','CCC222');
INSERT INTO Registered VALUES ('5555555555','CCC444');
INSERT INTO Registered VALUES ('7777777777','CCC444');


INSERT INTO Registered VALUES ('1111111111','CCC333');
INSERT INTO Registered VALUES ('5555555555','CCC333');

INSERT INTO Registered VALUES ('6666666666','CCC777');
INSERT INTO Registered VALUES ('5555555555','CCC777');

INSERT INTO Registered VALUES ('1111111111','CCC999');
INSERT INTO Registered VALUES ('2222222222','CCC999');
INSERT INTO Registered VALUES ('3333333333','CCC999');
INSERT INTO Registered VALUES ('5555555555','CCC888');

INSERT INTO Registered VALUES ('5555555555','CCC000');

INSERT INTO Registered VALUES ('5555555555','CCC456');
INSERT INTO Registered VALUES ('4444444444','CCC456');


INSERT INTO Taken VALUES('4444444444','CCC111','5');
INSERT INTO Taken VALUES('4444444444','CCC222','5');
INSERT INTO Taken VALUES('4444444444','CCC333','5');
INSERT INTO Taken VALUES('4444444444','CCC444','5');
INSERT INTO Taken VALUES('5555555555','CCC111','5');
INSERT INTO Taken VALUES('5555555555','CCC222','4');
INSERT INTO Taken VALUES('5555555555','CCC444','3');
INSERT INTO Taken VALUES('2222222222','CCC111','U');
INSERT INTO Taken VALUES('2222222222','CCC222','U');
INSERT INTO Taken VALUES('2222222222','CCC444','U');



INSERT INTO WaitingList VALUES('3333333333','CCC222',1);
INSERT INTO WaitingList VALUES('3333333333','CCC333',1);
INSERT INTO WaitingList VALUES('2222222222','CCC333',2);
INSERT INTO WaitingList VALUES('2222222222','CCC777',1);

INSERT INTO WaitingList VALUES('4444444444','CCC999',1);
INSERT INTO WaitingList VALUES('5555555555','CCC999',2);
INSERT INTO WaitingList VALUES('6666666666','CCC999',3);

INSERT INTO WaitingList VALUES('6666666666','CCC000',1);

INSERT INTO WaitingList VALUES('6666666666','CCC456',1);



CREATE OR REPLACE VIEW BasicInformation AS
SELECT idnr, name, login, Students.program, StudentBranches.branch
FROM Students 
FULL JOIN StudentBranches 
ON Students.idnr = StudentBranches.student
WHERE (idnr, name, login, Students.program) IS NOT NULL;

CREATE OR REPLACE VIEW FinishedCourses AS 
SELECT student, course, grade, credits
FROM Taken
JOIN Courses ON Taken.course = Courses.code
WHERE (student, course, grade, credits) IS NOT NULL;

CREATE OR REPLACE VIEW PassedCourses AS 
SELECT student, course, credits
FROM FinishedCourses
WHERE (FinishedCourses.student, FinishedCourses.course, FinishedCourses.credits)
IS NOT NULL AND FinishedCourses.grade != 'U';

CREATE OR REPLACE VIEW Registrations AS
SELECT student, course, 'registered' AS status
FROM Registered
UNION
SELECT student, course, 'waiting' AS status
FROM WaitingList;

CREATE OR REPLACE VIEW MandatoryCourses AS
SELECT course, program, branch
FROM MandatoryBranch
UNION
SELECT course, program, NULL as branch
FROM MandatoryProgram;


CREATE OR REPLACE VIEW UnreadMandatory AS
SELECT b.idnr as student, course
FROM BasicInformation b
INNER JOIN (
  SELECT program, branch, course
  FROM MandatoryCourses
) AS courses
ON (b.program = courses.program)
AND (b.branch = courses.branch OR courses.branch IS NULL)
EXCEPT (SELECT student, course FROM PassedCourses);


CREATE OR REPLACE VIEW RecommendedCourses AS
SELECT course, program, branch
FROM RecommendedBranch;


CREATE OR REPLACE VIEW StudentRecomendedCourses AS
SELECT b.idnr as student, course, b.program, b.branch
FROM BasicInformation b
JOIN RecommendedBranch r ON b.program = r.program 
AND b.branch = r.branch;


CREATE OR REPLACE VIEW StudentPassedRecommended AS
SELECT sr.student, sr.course, COALESCE(credits, 0) as credits
FROM StudentRecomendedCourses sr 
JOIN PassedCourses pc ON sr.student = pc.student AND sr.course = pc.course;



CREATE OR REPLACE VIEW PathToGraduation AS
WITH TotalCredits AS (
SELECT student, SUM(COALESCE(credits, 0)) AS totalCredits
FROM passedCourses
GROUP BY student),
MandatoryLeft AS (
SELECT student, COUNT(um.course) AS mandatoryLeft
FROM UnreadMandatory um
GROUP BY student),
MathCredits AS (
SELECT student, COALESCE(SUM(credits), 0) AS mathcredits
FROM PassedCourses p
JOIN Classified c ON p.course = c.course
WHERE c.classification = 'math'
GROUP BY student),
ResearchCredits AS (
SELECT student, COALESCE(SUM(credits), 0) AS researchCredits
FROM PassedCourses pc JOIN Classified c ON pc.course = c.course
WHERE c.classification = 'research'
GROUP BY student),
SeminarCourses AS (
SELECT student, COALESCE(COUNT(c.course), 0) AS seminar
FROM PassedCourses pc JOIN Classified c ON pc.course = c.course
WHERE c.classification = 'seminar'
GROUP BY student),
Qualified AS (
SELECT ph.student as student,
CASE
WHEN COALESCE(mandatoryLeft, 0) = 0
AND COALESCE(mathCredits, 0) >= 20
AND COALESCE(researchCredits, 0) >= 10
AND COALESCE(seminarCourses, 0) >= 1
AND COALESCE(SUM(spr.credits), 0) >= 10
THEN TRUE
ELSE FALSE
END AS qualified
FROM (
SELECT s.idnr as student, totalCredits, mandatoryLeft,
mathCredits, researchCredits, sc.seminar as seminarCourses
FROM Students s
LEFT JOIN TotalCredits tc ON s.idnr = tc.student
LEFT JOIN MandatoryLeft ml ON s.idnr = ml.student
LEFT JOIN MathCredits mc ON s.idnr = mc.student
LEFT JOIN ResearchCredits rc ON s.idnr = rc.student
LEFT JOIN SeminarCourses sc ON s.idnr = sc.student
) ph
JOIN StudentRecomendedCourses sr ON ph.student = sr.student
JOIN PassedCourses pc ON sr.course = pc.course
LEFT JOIN StudentPassedRecommended spr ON sr.student = spr.student
GROUP BY ph.student, mandatoryLeft, mathCredits, researchCredits, seminarCourses
)
SELECT s.idnr as student, COALESCE(tc.totalCredits,0) AS totalcredits, COALESCE(mandatoryLeft, 0) as mandatoryLeft,
COALESCE(mathCredits, 0) as mathCredits, COALESCE(researchCredits, 0) as researchCredits, COALESCE(sc.seminar, 0) as seminarCourses,
COALESCE(qualified, FALSE) as qualified
FROM Students s
LEFT JOIN TotalCredits tc ON s.idnr = tc.student
LEFT JOIN MandatoryLeft ml ON s.idnr = ml.student
LEFT JOIN MathCredits mc ON s.idnr = mc.student
LEFT JOIN ResearchCredits rc ON s.idnr = rc.student
LEFT JOIN SeminarCourses sc ON s.idnr = sc.student
LEFT JOIN Qualified q On s.idnr = q.student
ORDER BY student;




CREATE OR REPLACE VIEW CourseQueuePositions AS 
SELECT course, student, w.position as place
FROM WaitingList w;