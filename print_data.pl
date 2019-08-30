# NOTES:
#
# Rough output. Would build either a template system or remove the
# HTML/CSS into appropriate files, or port out to files(excel, text, etc) if more time devoted to this.
# For now just need the output to screen.
#
# Combined the two original functions/subroutines at the end of project to correct a data error without
# using substantially more code.
#
# Would divided this up as well for a loose MVC paradigm look later.

# print outs for test:
#  1 ) list of active courses w/ total courses found to be active
#  2 ) list of errors found. Some cross over into each other so tired to isolate as uniquely as possible
#  3 ) list of active students for each course a list with active enrollments in that course.
#  4 ) total students enrolled for each course
#  5 ) also output the file name, data type, and number of lines imported from each CSV file
#
#######################################################################

sub list_active_courses {

    my %course_names;
    my %active_courses;
    my %students_names;
    my %active_students;
    my %temp_hash_thingy;
    my $i = 0;
    my $j = 0;
    my @enrollment_courses_nonexists;
    my @enrollment_courses_not_active_in_courses;
    my @active_courses_not_in_enrolled;
    my @enrollment_students_nonexist;
    my @enrollment_students_not_active_in_students;
    my @active_students_not_in_enrolled;
    my @student_enrolled_courses_not_found;

    my $query = Canvas::CSV->new($mysql_username,$mysql_password,$mysql_database_name,$data_tables[1],'mysql');

    # mysql IN and/or nested queries do not work on my test environment for some reason ...
    #... must use perl manual/programmatic way to compare data between courses and enrollments
    #$csv_active_course_lookup =
        #qq|SELECT CONCAT($courses[0],  '%%', $courses[1]) FROM $data_tables[1] WHERE $courses[2] = "$csv_status_active" AND $courses[0] IN (@active_enrollments)|;

    my @active_enrollments = $query->getdata($csv_active_courses_enrollments);
    my @course_names = $query->getdata($csv_course_name_lookup);
    my @active_courses = $query->getdata($csv_active_course_lookup);
    my @active_combined_enrollments = $query->getdata($csv_active_student_enrollments);
    my @studentsnames = $query->getdata($csv_students_names_lookup);
    my @activestudents = $query->getdata($csv_active_students_lookup);


    # COURSE NAMES:
    foreach my $row (@course_names) {
        my ( $key, $name  )  = split( /%%/, $row );
        $course_names{$key} = $name;

    }


    # ACTIVE COURSES:
    foreach my $row (@active_courses) {
        my ( $key, $name  )  = split( /%%/, $row );
        $active_courses{$key} = $name;
    }


    # ACTIVE ENROLLMENTS
    foreach my $row (@active_enrollments) {
        if ( !( $course_names{$row} ) ) {
            if ( $row ) { push( @enrollment_courses_nonexists, $row ); } # capture the non-exist course
            next;
        }
        elsif ( !( $active_courses{$row} ) ) {
            $active_courses{$row} = $course_names{$row}; # add it to active courses for use later
            push( @enrollment_courses_not_active_in_courses, $row );
        }
        $course_enrollments{$row} = $course_names{$row};
    }


    # STUDENT NAMES
    foreach my $row (@studentsnames) {
        my ( $key, $name  )  = split( /%%/, $row );
        $students_names{$key} = $name;
    }


    # ACTIVE STUDENTS
    foreach my $row (@activestudents) {
        my ( $key, $name  )  = split( /%%/, $row );
        $active_students{$key} = $name;
    }


    # ACTIVE ENROLLMENTS
    foreach my $row (@active_combined_enrollments) {
        my ( $student_id, $course_id  )  = split( /%%/, $row );
        if ( !( $students_names{$student_id} ) ) {
            push( @enrollment_students_nonexist, $student_id );
            next;
        }
        elsif ( !( $active_students{$student_id} ) ) {
            $active_students{$student_id} = $students_names{$student_id};
            push( @enrollment_students_not_active_in_students, $student_id );
        }
        if ( !( $course_enrollments{$course_id} ) ) { next; }
        $i++;
        push (@$course_id, $student_id); # build array of student_ids per each course_id
    }


    # TIDY UP COURSE ENROLLMENTS:
    foreach my $row (@active_courses) {
        my ( $key, $name  )  = split( /%%/, $row );
        if ( !( $course_enrollments{$key} ) ) {
            if ( $key ) { push( @active_courses_not_in_enrolled, $key ); } # capture the not used active course
        }
    }

    $i = 0;


     # Printed out put would be dressed up with more time
    print $csv_2blanks_lines;
    print $csv_active_courses_header;


    # courses sorted by course ID
    foreach my $id ( sort ( keys %course_enrollments ) ) {
        # final catch to screen out empty courses after screening student enrollments
        if ( !( @$id ) ) {
            next;
        }
        $temp_hash_thingy{$id} = $course_enrollments{$id};
        print $csv_active_courses_id . $id . $csv_active_courses_name . $course_enrollments{$id} . $csv_newline;
        $i++;
    }
    undef %course_enrollments;
    %course_enrollments = %temp_hash_thingy;
    undef %temp_hash_thingy;

    print $csv_active_courses_total . $i . $csv_2blanks_lines;
    print $csv_2blanks_lines;


    # Output data errors found
    print $csv_active_courses_header2;
    $i = 0;
    foreach my $id (@enrollment_courses_nonexists) {
        print $csv_active_courses_id . $id . $csv_nonexist_course . $data_tables[1] . $csv_newline;
        $i++;
    }
    foreach my $id (@active_courses_not_in_enrolled) {
        print $csv_active_courses_id . $id . $csv_active_no_enrollments . $data_tables[2] . $csv_newline;
        $i++;
    }
    foreach my $id (@enrollment_courses_not_active_in_courses) {
        print $csv_active_courses_id . $id . $csv_not_active_course . $data_tables[1] . $csv_newline;
        $i++;
    }
    foreach my $id (@enrollment_students_nonexist) {
        print $csv_student_id . $id . $csv_nonexist_students . $data_tables[0] . $csv_newline;
        $i++;
    }
    foreach my $id (@enrollment_students_not_active_in_students) {
        print $csv_student_id . $id . $csv_not_active_student . $data_tables[0] . $csv_newline;
        $i++;
    }
    print $csv_active_courses_total2 . $i . $csv_2blanks_lines;
    print $csv_2blanks_lines;
    # output data errors done


    # Output courses sorted by course ID
    foreach my $course_id ( sort ( keys %course_enrollments ) ) {
        $i = 0;
        $j++;
        print $csv_2blanks_lines;
        print "<font size=+2>$csv_active_courses_id $course_id $csv_active_courses_name<b>$course_enrollments{$course_id}:</b></font> $csv_newline";

        # Output students sorted by student_id
        my @sorted_students = sort { $a <=> $b } @$course_id;
        foreach my $student_id ( @sorted_students ) {
            print $csv_student_id . $student_id . $csv_student_name . $students_names{$student_id} . $csv_newline;
            $i++;
        }
        print $csv_total_students_enrolled . $i . $csv_2blanks_lines;

    }
    print $csv_active_courses_total . $j . $csv_2blanks_lines;
    print $csv_2blanks_lines;

}

#######################################################################

1;
