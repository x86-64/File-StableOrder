package File::StableOrder::Common;

use Carp;

sub new {
	my ($class, %params) = @_;
	
	my $self = bless { %params, _pos => 0 }, $class;
	return $self;
}

sub size {
	my ($self) = @_;
	
	return (-s $self->{filename}) || 0;
}

sub _open {
	my ($self, $mode, $filename) = @_;

	my $io;
	open $io, $mode, $filename or
		croak $!;
	
	$self->{_fh} = $io;
}

sub _seek {
	my ($self, $pos, $whe) = @_;
	
	my $io = $self->{_fh};
	seek $io, $pos, $whe;
}

sub _readline {
	my ($self) = @_;

	my $io = $self->{_fh};
	my $line = <$io>;
	chomp $line if defined $line;
	return $line;
}

sub _writeline {
	my ($self, $line) = @_;
	
	my $io = $self->{_fh};
	print $io $line, $/;
}

sub _close {
	my ($self) = @_;
	
	my $io = delete $self->{_fh};
	close $io;
}

sub DESTROY {
	my ($self) = @_;
	
	$self->_close($self->{_fh});
}

1;
