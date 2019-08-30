package Canvas::CSV;

use Canvas::DBbase;

use vars qw( @ISA $VERSION );

@ISA = qw( Canvas::DBbase );

$VERSION = '00.01';
$VERSION = eval $VERSION;

#######################################################################
# new -- passes DB, table, user and password variables to class

sub new {
    my $class = shift;
    my ( $username, $password, $database, $table, $sqltype ) = @_;

    unless ( $sqltype ) { $sqltype = 'mysql' }

    my $self = Canvas::DBbase->new;

    $self->setdatabase($database);
    $self->setusername($username);
    $self->setpassword($password);
    $self->settable($table);
    $self->setsqltype($sqltype);

    # now create object/class
    return ( bless $self, $class );
}

#######################################################################
1; # END PACKAGE: Canvas::CSV
#######################################################################
