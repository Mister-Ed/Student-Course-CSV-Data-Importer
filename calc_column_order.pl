# NOTES:
#
# Error handling if no matches needs to be added.
#
#######################################################################
# Determine if we are dealing with students, courses or enrollments
#    --  as per the first line of each imported file.

sub  calc_column_order {

    my $file_header_line = shift;
    my ( $data_type )  = q{};
    my @rowheader = split( /\,/, $file_header_line );

    my $total_fields = @rowheader; # get number of items
    my $arraycounter = 0;

    COMPAREHEADERS:
    foreach my $table_name ( @data_tables ) {
        $settings_string = join( ',', @$table_name );
        my $matchesfound = 0;
        foreach my $header_item ( @rowheader ) {


            if ( $settings_string =~ /$header_item/ ) {
                $matchesfound++;
            }
            if ( $matchesfound == $total_fields ) {
                $data_type = $data_tables[$arraycounter];
                $matchesfound = 0;
                last COMPAREHEADERS; # immediately exit if all elements found
            }
        }

        if ( $matchesfound != $total_fields ) {
            $arraycounter++; # not found yet
            $matchesfound = 0;
        }

    }

    return ( $data_type, $arraycounter );

}

#######################################################################

1;
