package File::StableOrder::Item;

sub new {
	my ($class, %params) = @_;

	my $self = bless { %params }, $class;
	return $self;
}

sub pos {
	my $self = shift;
	
	if(@_){
		$self->{_pos} = shift;
	}
	
	$self->{_pos};
}

1;
