-- create database
DROP DATABASE IF EXISTS quan_ly_diem;
CREATE DATABASE IF NOT EXISTS quan_ly_diem;
USE quan_ly_diem;
-- create table student
DROP TABLE IF EXISTS Student;
CREATE TABLE Student
(
  Student_ID TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  Student_Name VARCHAR(50) NOT NULL,
  Student_Age DATE NOT NULL,
  Gender ENUM ("Nam", "Nu", "Unknown")
);
-- create table Subject
DROP TABLE IF EXISTS `Subject`;
CREATE TABLE `Subject`
(
  Subject_ID TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  Subject_Name VARCHAR (100) NOT NULL
);
-- create table StudentSubject
DROP TABLE IF EXISTS Student_Subject;
CREATE TABLE Student_Subject
(  
  Student_ID TINYINT UNSIGNED NOT NULL,
  Subject_ID TINYINT UNSIGNED NOT NULL,
  Mark DOUBLE UNSIGNED CHECK(Mark <= 10),
  Student_Subject_date DATE NOT NULL,
  PRIMARY KEY(Student_ID,Subject_ID),
  FOREIGN KEY(Student_ID) REFERENCES Student(Student_ID),
  FOREIGN KEY(Subject_ID) REFERENCES `Subject`(Subject_ID)
);
-- add data student
INSERT INTO Student (Student_ID, Student_Name   , Student_Age , Gender   )
VALUES              (1         , 'tran van b'   , '2000-01-01', 'Nam'    ),
					(2         , 'nguyen van a' , '2000-02-02', 'Nam'    ),
                    (3         , 'tran thi anh' , '2000-03-03', 'Nu'     ),
                    (4         , 'nhu thi trang', '2000-04-04', 'Nu'     ),
                    (5         , 'tran van c'   , '2000-05-05', 'Unknown');
-- add data subject
INSERT INTO `Subject` (Subject_ID, Subject_Name )
VALUES                (1         , 'Toan'       ),
                      (2         , 'van'        ),
                      (3         , 'Anh'        );
-- add data Student_Subject
INSERT INTO Student_Subject (Student_ID, Subject_ID, Mark, Student_Subject_date)
VALUES                      (1         , 1         , 9   ,'2021-01-01'         ),
                            (1         , 2         , 6   ,'2021-01-01'         ),
                            (1         , 3         , 8   ,'2021-01-01'         ),
                            (2         , 1         , 7   ,'2021-01-02'         ),
                            (2         , 2         , 9   ,'2021-01-02'         ),
                            (2         , 3         , 5   ,'2021-01-02'         ),
                            (3         , 1         , 4   ,'2021-01-03'         ),
                            (3         , 2         , 6   ,'2021-01-03'         ),
                            (3         , 3         , 9   ,'2021-01-01'         ),
                            (4         , 1         , 8   ,'2021-01-01'         ),
                            (4         , 3         , 2   ,'2021-01-01'         ),
                            (5         , 2         , 7   ,'2021-01-01'         );
-- cau 2a
SELECT subject.Subject_Name
FROM `subject`
LEFT JOIN student_subject ON subject.Subject_ID = student_subject.Subject_ID
WHERE student_subject.Subject_ID IS NULL;
-- cau 2b 
SELECT subject.Subject_Name, student_subject.Mark
FROM `subject` JOIN student_subject ON subject.Subject_ID = student_subject.Subject_ID
GROUP BY student_subject.Subject_ID
HAVING count(student_subject.Mark >= 2);
-- cau 3 
CREATE VIEW view_StudentInfo AS
SELECT *
FROM student, subject, student_subject
WHERE student.Student_ID = student_subject.Student_ID AND subject.Subject_ID = student_subject.Subject_ID;
-- cau 4a
DROP TRIGGER IF EXISTS Subject_Update_ID;
DELIMITER $$ 
CREATE TRIGGER Subject_Update_ID
AFTER UPDATE ON `subject`
FOR EACH ROW
BEGIN
    UPDATE student_subject
    SET Subject_ID = new.Subject_ID
    WHERE Subject_ID = old.Subject_ID;
END$$
DELIMITER ;
SET FOREIGN_KEY_CHECKS=0;
UPDATE `subject` SET subject.Subject_ID = '6' WHERE subject.Subject_ID = '1';
-- cau 4b
DROP TRIGGER IF EXISTS  Student_Delete_ID;
DELIMITER $$ 
CREATE TRIGGER Student_Delete_ID
BEFORE DELETE ON student
FOR EACH ROW
BEGIN
     DELETE 
     FROM student_subject
     WHERE Student_ID = old.Student_ID;
END$$
DELIMITER ;
SET SQL_SAFE_UPDATES = 0;
DELETE FROM student WHERE Student_ID = '3';
-- cau 5 
DROP PROCEDURE IF EXISTS delete_student;
DELIMITER $$
CREATE PROCEDURE delete_student (
  IN student_name_in VARCHAR(50)
)
BEGIN
     IF(student_name_in = '*') THEN
     DELETE FROM student;
     ELSE
     DELETE FROM student WHERE Student_Name = student_name_in;
     END IF;
END $$
DELIMITER ;
SET @student_name_in = '';
CALL delete_student('tran van b');