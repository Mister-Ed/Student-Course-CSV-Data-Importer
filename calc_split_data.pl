# NOTES:
#
# Changing @items array from calling routine.
#
#######################################################################

sub split_data_line {

    my $line_in = shift;
    my ( $quotes_first, $quotes_second, $quotes_third )  = q{};

    # Where are quotes used as data demarcation?
    # Looking only for doubles. Single quote easy to add later to regex using: [\'\"]
    # Assuming only 3 fields for now. Can expand to dynamic data ranges later

    if ( $line_in =~ /^\"/ ) { $quotes_first = 'yes'; }
    if ( $line_in =~ /\,\"/ ) { $quotes_second = 'yes'; }
    if ( $line_in =~ /\"$/ ) { $quotes_third = 'yes'; }

    # Split line. Based on 3 items per data line
    if ( $quotes_first eq 'yes' )  {
         ( $items[0], $line_in ) = split( /\"\,/, $line_in, 2 );
         $items[0] =~ s/\"//g;
    }
    else {
         ( $items[0], $line_in ) = split( /\,/, $line_in, 2 );
    }

    if ( $quotes_second eq 'yes' )  {
         ( $items[1], $items[2] ) = split( /\"\,/, $line_in, 2 );
         $items[1] =~ s/\"//g;
         $items[2] =~ s/\"//g;
    }
    else {
         ( $items[1], $items[2] ) = split( /\,/, $line_in, 2 );
         $items[1] =~ s/\"//g;
         $items[2] =~ s/\"//g;
     }

}

#######################################################################

1;
