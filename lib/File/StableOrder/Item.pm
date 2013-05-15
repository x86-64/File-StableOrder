package File::StableOrder::Item;

sub new {
	my ($class, %params) = @_;

	my $self = bless { %params }, $class;
	return $self;
}

sub pos {
	my ($self) = @_;
	
	$self->{_pos};
}

1;
