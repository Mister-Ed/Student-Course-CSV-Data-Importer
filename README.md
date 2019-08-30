# Student Course CSV Data Importer

Imports students, courses, and enrollment data from CSV files and laces them into a mySQL database. The CSV files are 3 elements wide and contain data such as students, courses offered, students enrolled in a course.

The script will determine which type of data is being imported.

Custom packages / modules are included for the database and CSV objects / functions. These custom Perl module (package) dependencies are loaded locally to the script rather being required to be installed in the Perl distro on the machine.

The CSV data files were excluded from this repo on purpose.
