# Student Course CSV Data Importer

Imports students, courses, and enrollment data from CSV files and laces them into a mySQL database. The CSV files are 3 elements wide and contain data such as students, courses offered, students enrolled in a course.

I originally created this script in a short handful of hours back in 2014 as a simple test.  It can definitely be expanded to handle more complex data and to add a nicer web interface to it.

The script will determine which type of data is being imported (student, course, enrollment, etc). CSV data must include primary or secondary DB keys.

Custom packages / modules are included for the database and CSV objects / functions. These custom Perl module (package) dependencies are loaded locally to the script rather being required to be installed in the Perl distro on the machine.

The CSV data files were excluded from this repo on purpose.
