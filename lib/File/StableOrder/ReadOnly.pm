package File::StableOrder::ReadOnly;

use Carp;
use File::StableOrder::Item;

sub new {
	my ($class, %params) = @_;

	my $self = bless { %params, _pos => 0 }, $class;

	$self->{_in} = $self->_open("<", $self->{filename});
	
	return $self;
}

sub pos {
	my ($self) = @_;

	return $self->{_pos};
}

sub readline {
	my ($self) = @_;
	
	my $line = $self->_readline($self->{_in}) or return undef;
	my $pos  = $self->{_pos}++;
	
	return File::StableOrder::Item->new(i => $line, _pos => $pos);
}

sub returnline {
	my ($self) = @_;
	
	1;
}

sub DESTROY {
	my ($self) = @_;
	
	$self->_close($self->{_in});
}

sub _open {
	my ($self, $mode, $filename) = @_;

	my $io;
	open $io, $mode, $filename or
		croak $!;
	
	return $io;
}

sub _seek {
	my ($self, $io, $pos, $whe) = @_;
	
	seek $io, $pos, $whe;
}

sub _readline {
	my ($self, $io) = @_;

	my $line = <$io>;
	chomp $line if defined $line;
	return $line;
}

sub _writeline {
	my ($self, $io, $line) = @_;
	
	print $io $line, $/;
}

sub _close {
	my ($self, $io) = @_;
	
	close $io;
}

1;
