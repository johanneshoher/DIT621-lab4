# DIT621-lab4
Front-end application for the database created during the course DIT621, which represents the Domain Description (See Below).

# Domain Description

The domain that you will model in this assignment is that of courses and students at a university.  Note that the described domain is not that of Chalmers nor GU.

The university for which you are building this system is organized into departments, such as the Dept. of Computing Science (CS), and educational programs for students, such as the Computer Science and Engineering program (CSEP). Several departments may collaborate on a program, which is the case with CSEP that is co-hosted by the CS department and the Department of Computer Engineering (CE). Department names and abbreviations are unique, as are program names but not necessarily program abbreviations.

Each program is further divided into branches, for example CSEP has branches Computer Languages, Algorithms, Software Engineering etc. Note that branch names are unique within a given program, but not necessarily across several programs. For instance, both CSEP and a program in Automation Technology have a branch called Interaction Design. For each program, there are mandatory courses. For each branch, there are additional mandatory courses that the students taking that branch must read. Branches also name a set of recommended courses from which all students taking that branch must read a certain amount to fulfill the requirements of graduation (see below for additional requirements).

A student always belongs to a program. Students must choose a single branch within that program, and fulfill its graduation requirements, in order to graduate. Typically students choose which branch to take in their fourth year, which means that students who are in the early parts of their studies may not yet belong to any branch.

Each course is given by a department (e.g. CS gives the Databases course). Each course has a unique six character course code. All courses may be read by students from any program. Some courses may be mandatory for certain program, but not for others. Students get academic credits for passing courses, the exact number may vary between courses (but all students get the same number of credits for the same course). Some courses, but not all, have a restriction on the number of students that may take the course at the same time. Courses can be classified as being mathematical courses, research courses or seminar courses. Not all courses need to be classified, and some courses may have more than one classification. The university will occasionally introduce new classifications, so the database needs to allow this. Some courses have prerequisites, i.e. other courses that must be passed before a student is allowed to register to it.

Students need to register for courses in order to read them. To be allowed to register, the student must first fulfill all prerequisites for the course. It should not be possible for a student to register to a course unless the prerequisite courses are already passed. It should not be possible either for students to register for a course which they have already passed.

If a course becomes full, subsequent registering students are put on a waiting list. If one of the previously registered students decides to drop out, such that there is an open slot on the course, that slot is given to the student who has waited the longest. Unless the course has been overbooked (see paragraph below) by an administrator! When the course is finished, all students are graded on a scale of 'U', '3', '4', '5'. Getting a 'U' means the student has not passed the course, while the other grades denote various degrees of success.

A study administrator (a person with direct access to the database) can override both course prerequisite requirements and size restrictions, and add a student directly as registered to a course. (Note: you will not implement any front end application for study administrators, only for students. The database must still be able to handle this situation.)

For a student to graduate there are a number of requirements they must first fulfill. They must have passed (have at least grade 3) in all mandatory courses of the educational program they belong to, as well as the mandatory courses of the particular branch that they must have chosen. Also they must have passed at least 10 credits worth of courses among the recommended courses for the branch. Furthermore they need to have read and passed (at least) 20 credits worth of courses classified as mathematical courses, 10 credits worth of courses classified as research courses, and at least one seminar course. Mandatory and recommended courses that are also classified in some way are counted just like any other course, so if one of the mandatory courses of a program is also a seminar course, students of that program will not be required to read any additional seminar courses.



