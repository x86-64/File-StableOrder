package File::StableOrder::WriteOnly;

use base 'File::StableOrder::Common';

use Carp;

sub new {
	my ($class, %params) = @_;
	
	my $self = bless $class->SUPER::new(%params), $class;
	
	return undef if $self->size() > 0;
	
	$self->_open(">", $self->{filename});
	$self->{_return_arr} = {};
	
	return $self;
}

sub returnline {
	my ($self, $item) = @_;
	
	$self->{_return_arr}->{$item->pos} = $item;
	$self->_flush();
}

sub _flush {
	my ($self) = @_;
	
	while(defined $self->{_return_arr}->{$self->{_pos}}){
		my $item = delete $self->{_return_arr}->{$self->{_pos}};
		$self->_writeline($item->{i});
		
		$self->{_pos}++;
	}
}

sub DESTROY {
	my ($self) = @_;
	
	croak "Return array still contain elements"
		if scalar keys %{$self->{_return_arr}} > 0;
	
	$self->SUPER::DESTROY();
}

1;
