package File::StableOrder::ReadOnly;

use base 'File::StableOrder::Common';

use File::StableOrder::Item;

sub new {
	my ($class, %params) = @_;
	
	my $self = bless $class->SUPER::new(%params), $class;
	
	eval {
		$self->_open("<", $self->{filename});
	};
	
	return $self;
}

sub pos {
	my ($self) = @_;

	return $self->{_pos};
}

sub skipline {
	my ($self) = @_;
	
	my $line = $self->_readline() or return undef;
	$self->{_pos}++;
}

sub readline {
	my ($self) = @_;
	
	my $line = $self->_readline() or return undef;
	my $pos  = $self->{_pos}++;
	
	return File::StableOrder::Item->new(i => $line, _pos => $pos);
}

sub returnline {
	my ($self) = @_;
	
	1;
}

1;
