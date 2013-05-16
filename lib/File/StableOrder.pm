package File::StableOrder;

use 5.006;
use strict;
use warnings FATAL => 'all';
use feature qw/switch/;

use Carp;
use File::StableOrder::ReadOnly;
use File::StableOrder::ReadWrite;
use File::StableOrder::WriteOnly;

=head1 NAME

File::StableOrder - The great new File::StableOrder!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use File::StableOrder;

    my $foo = File::StableOrder->new(
    	filename => "file.txt",
	mode     => "r",          # "r", "rw", "w"
	...
	# for Read-Write
	truncate => 1, # truncate file if there are previous results in file OR
	continue => 1, # continue processing from last element OR
	merge    => 1, # merge info from temporary file into main
	output_filename => "output.txt",  #  use this file to store results. original file will be unchanged
    );
    ...
    $foo->rewind;                           # start from beginning of file
    while(my $item = $foo->readline()){     # read item,
       $item->{i} = int($item->{i}) + 1;    # process it,
       
       $foo->returnline($item);             # and return
    }
    $foo->finish;                           # save results and rewind to start

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 function1

=cut

sub new {
	my ($class, %params) = @_;

	my $mode = delete $params{mode};
	given($mode){
		when("r"){  return File::StableOrder::ReadOnly->new(%params); }
		when("rw"){ return File::StableOrder::ReadWrite->new(%params); }
		when("w"){  return File::StableOrder::WriteOnly->new(%params); }
		default{
			croak "Unknown mode: $mode.";
		}
	}
}

=head1 AUTHOR

x86, C<< <x86mail at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-file-stableorder at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=File-StableOrder>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc File::StableOrder


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=File-StableOrder>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/File-StableOrder>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/File-StableOrder>

=item * Search CPAN

L<http://search.cpan.org/dist/File-StableOrder/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2013 x86.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.


=cut

1; # End of File::StableOrder
