USE M3_School;

# System administrator

# 1.1 - create schools
CALL Create_Schools('elfarouk', 'masr elgedida', 'elfarouk@gmail.com', 'madrsa gamela',
                    'to make our education better', 'we will make our students the best', 'english', 'interantional',
                    50000);
CALL Create_Schools('elola', 'elzahraa', 'elola@gmail.com', 'madrsa fola', 'make egypt better'
, 'fight', 'arabic', 'national', 10000);

# 1.2, 1.3, 1.4 - make schools (elementary, middle, high)
CALL Make_Schools_Middle(4, 'calculators w man2la w elmo3asr');
CALL Make_Schools_Middle(5, 'calculators w man2la w elmo3asr');
CALL Make_Schools_High(5, 'lamy w bs');

# 1.5 - adding phone numbers to the schools
CALL Add_PhoneNumbers_To_Schools(1, '26060606');
CALL Add_PhoneNumbers_To_Schools(1, '26060607');
CALL Add_PhoneNumbers_To_Schools(2, '26080808');

# 2 - add courses to the system
CALL Add_Courses(109, 'maths 1', 1, 1, 'addition w multiplication w kfea');
CALL Add_Courses(110, 'arabic 1', 1, 1, 'e2ra el7rof w bs');

# 3 - add courses prerequisites
CALL Add_Course_Prerequisites(101, 102);

# 4 - add admins to the system
CALL Add_Admins('omar', 'ashraf', 'sallam', '1990-10-10', 'madinty', 'omarkojaks@kojak.com',
'kojaks', '1234', 'male', 1);

# 5 - Delete Schools
CALL Delete_Schools(4);

# 6 - Change Employee Username
CALL ChangeEmployeeUsername('rand101');

# System User
# 1 - Search
CALL Search_For_School_By_Name('GUC');
CALL Search_For_School_By_Address('5th tagamo3');

CALL Search_For_School_By_Type('national');
CALL Search_For_School_By_Type('international');

# 2- View All Schools
CALL View_AllAvailable_Schools();

# 3- View info about specific school.
CALL View_Specific_School(1);
CALL View_Specific_School_Reviews(1);
CALL View_Specific_School_Teachers(1);
CALL View_Specific_School_PhoneNumbers(1);

# ADMINISTRATOR
# 1 - View and verify teachers
CALL View_Teachers_As_Administrator('Nour');
CALL Verify_Teacher_As_Administrator('Nour', 'Melzarei', 'NewUS', '12345', 6);

# 2 - View And Verify Students
CALL View_Students_As_Administrator('Nour');
CALL Verify_Enrolled_Student_As_Administrator('Nour', 1, 'balabizo', 'pass');

# 3- Add other admins
CALL Add_New_Administrator_ToSchool('Nour', 'ahmed', 'aly', 'samy', '1980-5-3', 'rehab', '1@g.com',
                                    'sami', '1234', 'male');

# 4 - Delete employees
CALL Delete_Employee('Nour', 'rand101');

# 5 - Edit School Info
CALL Edit_School_Information('Nour', 'Ismailia Language School', 'Vision', 'Mission', 'Arabic', 'national', 1235.3,
                             'Ismailia', 'ism@ismailia.com', 'some useless info');

# 6 - Post Announcement
CALL Post_Announcement('Nour', '2016-3-3', 'Warning', 'Aprils Fool', 'What Title?');

# 7 - Create School Activity
CALL Create_School_Activity('Nour', 'Melzarei', '2016-5-3', 'Alexandria', 'None', 'Outing', 'What desc?');

# 8 - Change Activity Teacher
CALL Change_Activity_Teacher('Nour', 1, 'Melzarei');

# 9 - Assign teachers to courses
CALL Assign_Teacher_To_Courses('Nour',  103, 'Melzarei');

# 10 - Assign Supervisors
CALL Assign_Teacher_To_Be_Supervisors('Nour','Melzarei','MelzareiPlus');

# 11 - Accept or Reject Child
CALL Accept_Or_Reject_Child('Nour', 6,'kojak', 0);

# Enrolled Students
# 1 - Update my account
CALL UpdateMyAccount('mego', '114', 'a', 'b', '1936-1-1', '111m');

# 2 - View a list of courses
CALL ViewCoursesNames('mego');

# 3 - Post questions I have about a certain course.
CALL PostQuestionsOnCourses('mego', 'no title', 'no content');
CALL PostQuestionsOnCourses2('mego', 4, 101);

# 4 -  View all questions
CALL ViewQuestions('mego',101);

# 5 - View the assignments
CALL ViewAssignments('mego');

# 6 - Solve assignments
CALL SolveAssignments('mego',4,'sol');

# 7 - View the grade of the assignments
CALL ViewAssignmentsGrades('mego');

# 8 - View the announcements
CALL ViewAnnouncements('mego');

# 9 - ViewActivities
CALL ViewActivities('mego');

# 10 - Apply for activities
CALL ApplyForActivity('mego',1);

# 11 - Join Clubs
CALL JoinClubs('moody','bdaya');

# 12 - Search
CALL SearchCourseByName('mego','MATH');
CALL SearchCourseByCode('mego',101);

# Parent
# 1 - Signup
CALL Parent_Signup('ahmed','Ashraf','omarkojaks@koja.com','Tagamo3','01003434123','ahmed','1234');
CALL ParentAddPhoneNumber('ahmed','12345');

# 2 - Parent Apply For Child
CALL ParentApplyForChildren('kojak',1011,'1995-2-2','female',1,'ahmed','sami');

# 3 - View a list of schools
CALL ViewSchools('kojak');

# 4- Choose one of the schools that accepted my child to enroll him/her.
CALL Accepted_In_School(1);
CALL ChooseSchool(7,1);

# 5 - View reports written about my children by their teachers.
use M3_School;
CALL ViewReports('kojak');

# 6 - Reply to reports
CALL ReplyToReports(1,'Melzarei','2016-11-11 00:00:00','123');

# 7 - View a list of all schools of all my children ordered by its name.
CALL ViewSchoolsList('kojak');

# 8 - Parent View Announcements
CALL ParentViewAnnouncements('kojak',2);

# 9 - Rate any teacher that teaches my children.
CALL RateTeachers('kojak','Melzarei',3);

# 10 - Write reviews about my children’s school(s).
CALL ReviewSchools('kojak',3,'123');

# 11 - Delete a review that i have written.
CALL DeleteReview('kojak',2);

# 12 - View the overall rating
CALL ViewRating('Melzarei');

# 13 - View the top 10 schools
CALL ViewHighestSchoolsByReviews('kojak');

# 14 - Find the international school which has a reputation higher
# than all national schools, i.e. has the highest number of reviews.

CALL ViewInternationalSchools();

# Teacher
# 1 - Teacher Signup
CALL TeacherSignUp('rand101','ali','ibrahim','sameh','1980-1-1','Masr','aliib@gmail.com','male',1);

# 2 - View a list of courses’ names I teach categorized by level and grade.
CALL ViewCoursesTaughtByTeacher('Melzarei');

# 3 - Post assignments for the course(s) I teach.
CALL PostAssigmentByTeacher('Melzarei',101,'2016-1-1','2016-1-6','content');

# 4 - View the students’ solutions for the assignments I posted ordered by students’ ids.
CALL TeacherViewAssignmentSolution('Melzarei');

# 5 - Grade the students’ solutions for the assignments I posted.
CALL TeacherUpdatesAssignmentGrade('Melzarei',1,1,10);

# 6 - Delete assignments.
CALL TeacherDeleteAssignment('Melzarei',1);

# 7- Write monthly reports about every student I teach.
CALL ReportAboutStudentByTeacher('Melzarei','Hello World.','2016-1-1',1);

# 8 - Teacher View Questions
CALL Teacher_View_Questions('Melzarei');

# 9 - Teacher Answer Questions
CALL Teacher_Answer_Questions('Melzarei',1,'Hello World.');

# 10 - Teacher list Students
CALL Teacher_list_Students('Melzarei');

# 11 - Teacher View Students With No Activities
CALL TeacherViewStudentsWithNoActivities();

# 12 - View Student With Highest Clubs
CALL ViewStudentWithHighestClubs('YoussefF');