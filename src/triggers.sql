CREATE OR REPLACE VIEW CourseQueuePositions AS 
SELECT course, student, w.position as place
FROM WaitingList w;



CREATE OR REPLACE FUNCTION insert_student_reg(param1 TEXT, param2 TEXT, param3 TEXT) RETURNS VOID AS $$
BEGIN
  INSERT INTO Registered (student, course, status) VALUES (param1, param2, param3);
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION check_reg_student() RETURNS TRIGGER AS $$
  DECLARE
    notWaiting BOOLEAN := true;
    BEGIN

      IF EXISTS (SELECT student, course FROM PassedCourses p WHERE (p.student = NEW.student) AND (p.course = NEW.course)) OR
         EXISTS (SELECT student, course FROM CourseQueuePositions w WHERE (w.student = NEW.student) AND (w.course = NEW.course)) THEN
        RAISE EXCEPTION 'Tries to register to course more than once, therefore action not allowed.';
      END IF;

      IF ((SELECT Count(requiredcourse) -- Checks if the student has passed the required course  
      FROM Prerequisites WHERE (course = NEW.course) AND (requiredcourse NOT IN 
      (SELECT course FROM PassedCourses WHERE student= NEW.student))) > 0) THEN
        RAISE EXCEPTION '% do not fulfill requirement to get registrated', NEW.student;
      END IF;
      
      IF EXISTS (SELECT code, capacity FROM LimitedCourses l WHERE l.code = NEW.course) THEN
        DECLARE
            capacity INT := (SELECT capacity FROM LimitedCourses l WHERE l.code = NEW.course);
            new_pos INT;
        BEGIN
        IF ((SELECT COUNT(student) FROM Registrations r WHERE r.course = NEW.course) >= capacity) THEN
          
          new_pos := ((SELECT MAX(place) FROM CourseQueuePositions c WHERE c.course = NEW.course) + 1);
          INSERT INTO WaitingList VALUES(NEW.student, NEW.course, new_pos);
          notWaiting = false;
        END IF;
        END;
      END IF;

      IF notWaiting THEN
        INSERT INTO Registered VALUES(NEW.student, NEW.course);
      END IF;


      RETURN NEW;
      
    END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER reg_student
INSTEAD OF INSERT ON Registrations
    FOR EACH ROW EXECUTE FUNCTION check_reg_student();


CREATE OR REPLACE FUNCTION decrement_place(course_code CHAR(6), prev_place INT) RETURNS VOID AS $$
  BEGIN
    UPDATE WaitingList v
    SET position = position - 1 
    WHERE v.course = course_code AND position >= prev_place;
  END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION unreg_student() RETURNS TRIGGER AS $$
DECLARE 
    old_course CHAR(6);
    old_position INT;
    sts TEXT;
    cap INT;
BEGIN
    old_course := OLD.course;

    IF (NOT EXISTS (SELECT 1 FROM Registrations r WHERE r.student = OLD.student 
    AND r.course = old_course 
    AND (r.status = 'registered' OR r.status = 'waiting'))) 
    THEN
      RAISE EXCEPTION 'Not Registered or in Waiting-list';
    END IF;
    

    -- Match on status
    IF EXISTS (SELECT student, course, status FROM Registrations r WHERE r.student = OLD.student AND r.course = old_course) THEN
        sts = (SELECT status FROM Registrations r WHERE r.student = OLD.student AND r.course = old_course);
        
        IF (sts = 'registered') THEN
            DELETE FROM Registered r WHERE r.student = OLD.student AND r.course = old_course;
            -- RAISE EXCEPTION '% Student has been deleted';

            IF EXISTS (SELECT 1 FROM LimitedCourses l WHERE l.code = old_course) THEN
                
                cap = (SELECT capacity FROM LimitedCourses l WHERE l.code = old_course);
                BEGIN
                    -- RAISE EXCEPTION '% Course is in LIMITED';
                    IF EXISTS (SELECT course, student, place FROM CourseQueuePositions c WHERE c.course = old_course AND c.place = 1) 
                        AND (SELECT COUNT(student) FROM Registrations r WHERE r.course = old_course) < cap THEN
                        -- Remove found student from CourseQueuePositions and
                        DELETE FROM WaitingList c WHERE c.course = old_course AND c.place = 1;
                        -- RAISE EXCEPTION '% Row has been removed from CourseQueuePositions';
                        -- Decrement all others then
                        PERFORM decrement_place(old_course, 1);
                        -- RAISE EXCEPTION '% CourseQueuePositions place column has decremented';
                        -- Register the waiting student to the course
                        PERFORM insert_student_reg(student, old_course, sts);
                        -- RAISE EXCEPTION '% Student has been registered';
                    END IF;
                END;
            END IF;
        ELSE
            -- If there exists a row in the waiting table with the attributes of the DELETING action
            -- Save the place and call decrement function with the saved variable.
            IF EXISTS (SELECT course, student, place FROM CourseQueuePositions c WHERE c.course = old_course AND c.student = OLD.student) THEN
                old_position = (SELECT place FROM CourseQueuePositions c WHERE c.course = old_course AND c.student = OLD.student);
                DELETE FROM WaitingList c WHERE c.student = OLD.student AND c.course = old_course;
                PERFORM decrement_place(old_course, old_position);
            END IF;
        END IF;
      
    END IF;
  
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER unreg_student_trigger 
INSTEAD OF DELETE ON Registrations 
  FOR EACH ROW EXECUTE FUNCTION unreg_student();
