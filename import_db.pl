# NOTES:
#
# For importing files into a mySQL table.
# Handles all the data types, files, etc for 3 values.
# Prgramatic builds could be added with more time to handle more fields dynamically.
#
# Alternative method could have been used to import data directly from files if it were clean and uniform:
# LOAD DATA INFILE 'filename.csv'
# but I opted to take a possibly safer/faster coding route where the data was evaluated per each line.
#
#######################################################################

sub import_database {

    my ( $userid, $username, $status  )  = @$data_column_type;
    my ( $lookup_criteria, $replace_criteria ) = q{};
    my %hash;
    local ( @items  )  = q{};

    my ( @columns_in  )  = split( /\,/, $data_file_header );

    split_data_line($data_column_line);

    # build hash to save time -- keeps it flexible
    @hash{@columns_in} = @items;

    my $replace_criteria = qq|VALUES ( "$hash{$userid}", "$hash{$username}", "$hash{$status}" )|;

    my $query = Canvas::CSV->new($mysql_username,$mysql_password,$mysql_database_name,$data_column_type,'mysql');
    $query->settable( $data_column_type );
    $query->replacerow($replace_criteria);

}

#######################################################################

1;
