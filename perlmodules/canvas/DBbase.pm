package Canvas::DBbase;

use Class::Struct;
use DBI;
use strict;
use vars qw( $numrows $VERSION );

$VERSION = '00.01';
$VERSION = eval $VERSION;

struct(
    sqldatabase => '$', #0
    sqluser => '$',     #1
    sqlpasswd => '$',   #2
    table => '$',       #3
    sqltype => '$',     #4
    dbh => '$'          #5
);

#######################################################################
# setdatabase($mysql_database_name) -- -- passes database_name variable to class

sub setdatabase {
    my $self = shift;
    ( $self->[0] ) = @_;
}

#######################################################################
# setusername($sqluser, $sqlpasswd) -- passes user variable to class

sub setusername {
    my $self = shift;
    ( $self->[1] ) = @_;
}

#######################################################################
# setpassword($mysql_password) -- passes password variable to class

sub setpassword {
    my $self = shift;
    ( $self->[2] ) = @_;
}

#######################################################################
# settable($table) -- passes table name variable to class
# need to test if multiple tables can be used in this manner

sub settable {
    my $self = shift;
    ( $self->[3] ) = @_;
}

#######################################################################
# setsqltype($sqltype) -- passes sql type variable to class (mysql default)

sub setsqltype {
    my $self = shift;
    ( $self->[4] ) = @_;
}

#######################################################################
#script to connect to sql database

sub connectdb {
    my $self = shift;
    my $table = "DBI:" . $self->[4] . ":" . $self->[0] . ":localhost";
    my $user_name = $self->[1];
    my $password  = $self->[2];
    $self->[5] = DBI->connect( $table, $user_name, $password )  || die "Database connection not made: $DBI::errstr";
}

#######################################################################
#script to disconnect sql database

sub disconnectdb {
    my $self = shift;
    my $dbh = $self->[5];
    $dbh->disconnect;
}

#######################################################################  
# Runs generic sql command sent from other object class routines/functions
# runsql($sqlstatement)
sub runsql {
    my $self = shift;
    my ($sqlstatement) = @_;
    my $dbh = $self->[5];
    my $sth = $dbh->prepare($sqlstatement);
    $sth->execute;
    return ($sth);
}
#######################################################################
# Prepares & executes a REPLACE query. Only values are passed to this
# replacerow($values)

sub replacerow {
    my $self = shift;
    my ( $values ) = @_;

    $self->connectdb();

    $values =~ s/'/&#39;/;
    my $query = qq{REPLACE $self->[3] $values};
    my $sth = $self->runsql($query);
    $sth->finish();

    $self->disconnectdb;
}

#######################################################################
# getdata()

sub getdata() {
    my $self = shift;
    my ( $query ) = @_;
    my ( @rows ) = q{};

    $self->connectdb();


    my $sth = $self->runsql($query);

    $numrows = $sth->rows;
    my @result = '';

    my $i = 0;
    while ( @result = $sth->fetchrow_array() ) {
        $rows[$i] = join(',', @result);
        $i++;
    }
    $sth->finish();
    $self->disconnectdb;
    return (@rows);
}

#######################################################################

1; # END PACKAGE: Canvas::DBbase
