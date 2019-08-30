# NOTES:
#
# All global variables (except those for mySQL and a handful of arrays), start with the 'csv_' prefix.
#
# The arrays and mySQL items would be renamed with more time so they are consistent
# with the 'csv_' convention that was adopted.
#
#######################################################################
#   mySQL
#######################################################################

$mysql_username = q{usernamehere};
$mysql_password = q{passwordhere};
$mysql_database_name = q{dbnamehere};
$mysql_host = q{}; # not used, for expansion if needed
$mysql_port = q{}; # not used, for expansion if needed

#######################################################################
#   Variables to keep her flexible
#######################################################################

# local directory where the csv files are located
$csv_data_import_dir = qq{./data_2_import};

# Content type for web scripting
$csv_content_header = "Content-type: text/html\n\n";

# Data Import info below.
@students = (
    'user_id','user_name','state'
);

@courses = (
    'course_id','course_name','state'
);

@enrollments = (
    'user_id','course_id','state'
);

# The statuses.
$csv_status_active = q{active};

# Array: names of the types of data files.
# Also used for library & subroutine/function names.
@data_tables = ( "students","courses","enrollments" );

#######################################################################
#   Query Builds
#######################################################################

$csv_active_course_lookup =  qq|SELECT CONCAT($courses[0],  '%%', $courses[1]) FROM $data_tables[1] WHERE $courses[2] = "$csv_status_active"|;

$csv_course_name_lookup = qq|SELECT CONCAT($courses[0],  '%%', $courses[1]) FROM $data_tables[1]|;

$csv_deleted_course_lookup = qq|SELECT CONCAT($courses[0],  '%%', $courses[1]) FROM $data_tables[1] WHERE $courses[2] = "$csv_status_deleted"|;

$csv_active_courses_enrollments =  qq|SELECT DISTINCT $enrollments[1] FROM $data_tables[2] WHERE $enrollments[2] = "$csv_status_active"|;

$csv_students_names_lookup  = qq|SELECT CONCAT($students[0],  '%%', $students[1]) FROM $data_tables[0]|;

$csv_active_students_lookup = qq|SELECT CONCAT($students[0],  '%%', $students[1]) FROM $data_tables[0] WHERE $students[2] = "$csv_status_active"|;

$csv_active_student_enrollments = qq|SELECT DISTINCT CONCAT($enrollments[0],  '%%', $enrollments[1]) FROM $data_tables[2] WHERE $enrollments[2] = "$csv_status_active"|;

#######################################################################
#   Display / Messages
#######################################################################

$csv_require_file_error_message = q{I am sorry but I was unable to require };
$csv_import_file_name = q|<br>Processing File: |;
$csv_data_type_name = q|Data Type: |;
$csv_total_lines_processsed = q|Total Lines Processed: |;
$csv_newline = "<br>\n";
$csv_2blanks_lines = "<br><br>\n";
$csv_active_courses_header = qq|<font size=+2><b>Active Courses:</b></font><br><i>( arranged by Course ID )</i><br>|;
$csv_active_courses_header2 = qq|<font size=+2><b>Course Data Errors:</b></font><br><i>( Errors discovered from cross checking data in "$data_tables[1]" table and "$data_tables[2]" after data import )</i><br>|;
$csv_active_courses_id = qq|<b>Course ID:</b> |;
$csv_active_courses_name = qq| <b>Course Name:</b>  |;
$csv_active_courses_total = qq|<i>Total Courses Found:</i>  |;
$csv_active_courses_total2 = qq|<i>Total Unique Course & Student Errors Found:</i>  |;
$csv_active_courses_enrollments_header = qq|<font size=+2><b>Active Courses w/ Active Enrollments:</b></font><br><i>( from the "$data_tables[2]" DB table )</i><br>|;
$csv_nonexist_course = qq| <font color=red><b>Problem:</b></font> "$courses[0]" in "$data_tables[2]" table does not exist in database table: |;
$csv_not_active_course = qq| <font color=green><b>Problem:</b></font> course from  "$data_tables[2]" table included in active output, but not set to "$csv_status_active" in database table: |;
$csv_active_no_enrollments = qq| <font color=red><b>Problem:</b></font> "$courses[0]" in "$data_tables[1]" table does not have any enrolled  students in database table: |;
$csv_nonexist_students = qq| <font color=red><b>Problem:</b></font> "$students[0]" in "$data_tables[2]" table does not exist in database table: |;
$csv_not_active_student = qq| <font color=green><b>Problem:</b></font> student from  "$data_tables[2]" table included in active output, but not set to "$csv_status_active" in database table: |;
$csv_student_id = qq|<b>Student ID:</b> |;
$csv_student_name = qq| <b>Student Name:</b>  |;
$csv_total_students_enrolled = qq|Total Students Enrolled in this course: |;

#######################################################################

1;
