---------------------------------------------

-- TEST #1: Register for an unlimited course.
-- EXPECTED OUTCOME: Pass
INSERT INTO Registrations VALUES ('7777777777', 'CCC111'); 

-- TEST #2: Register an already registered student.
-- EXPECTED OUTCOME: Fail
INSERT INTO Registrations VALUES ('5555555555', 'CCC222'); 

-- TEST #3: Unregister from an unlimited course. 
-- EXPECTED OUTCOME: Pass
DELETE FROM Registrations WHERE student = '7777777777' AND course = 'CCC444';

-- TEST #4: Waiting for a limited course that you are already waiting for; 
-- EXPECTED OUTCOME: Fail
INSERT INTO Registrations VALUES ('2222222222', 'CCC333'); 

-- TEST #5: Unregister from a course that you are not registered to; 
-- EXPECTED OUTCOME: Fail
DELETE FROM Registrations WHERE student = '5555555555' AND course = 'CCC666';

-- TEST #6: Waiting for a limited course; 
-- EXPECTED OUTCOME: Pass
INSERT INTO Registrations VALUES ('6666666666', 'CCC333'); 

-- TEST #7: Register to a limited course; 
-- EXPECTED OUTCOME: Pass
INSERT INTO Registrations VALUES ('5555555555', 'CCC666');

-- TEST #8: Removed from a waiting list (with additional students in it); 
-- EXPECTED OUTCOME: Pass
DELETE FROM Registrations WHERE student = '2222222222' AND course = 'CCC333';

-- TEST #9: Unregister from an overfull course with a waiting list.
-- EXPECTED OUTCOME: Pass
DELETE FROM Registrations WHERE student = '5555555555' AND course = 'CCC777';

-- TEST #10: Register to a course that you are already waiting for; 
-- EXPECTED OUTCOME: Fail
INSERT INTO Registrations VALUES ('2222222222', 'CCC777'); 

-- TEST #11: Unregister from a limited course without a waitinglist
-- EXPECTED OUTCOME: Pass
DELETE FROM Registrations WHERE student = '5555555555' AND course = 'CCC888';

-- TEST #12: Unregister from a limited course with a waiting list, when the student is registered;
-- EXPECTED OUTCOME: Pass
DELETE FROM Registrations WHERE student = '5555555555' AND course = 'CCC000';

-- TEST #13: Unregister from a limited course with a waiting list, when the student is in the middle of the waiting list;
-- EXPECTED OUTCOME: Pass
DELETE FROM Registrations WHERE student = '5555555555' AND course = 'CCC999';


-- TEST #14: Register to a course that you have already passed;
-- EXPECTED OUTCOME: Fail
INSERT INTO Registrations VALUES ('4444444444', 'CCC111'); 


-- TEST #15: Register to a course that demands that you have read another course, which the student has;
-- EXPECTED OUTCOME: Pass
INSERT INTO Registrations VALUES ('5555555555', 'CCC123'); 


-- TEST #16: Register to a course that demands that you have read another course, but you have not fulfilled the prerequisits;
-- EXPECTED OUTCOME: Fail
INSERT INTO Registrations VALUES ('3333333333', 'CCC123'); 


