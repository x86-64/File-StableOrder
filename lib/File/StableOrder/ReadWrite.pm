package File::StableOrder::ReadWrite;

use base 'File::StableOrder::ReadOnly';

use Carp;

sub new {
	my ($class, %params) = @_;
	
	my $self = bless $class->SUPER::new(%params), $class;
	
	return undef if $self->_size > 0;
	
	$self->{_out}        = $self->_open($self->_tmpfilename());
	$self->{_write_pos}  = 0;
	$self->{_return_arr} = {};
	
	return $self;
}

sub size {
	my ($self) = @_;
	
	return (-s $self->_tmpfilename());
}

sub returnline {
	my ($self, $item) = @_;
	
	$self->{_return_arr}->{$item->pos} = $item;
	$self->_flush();
}

sub _tmpfilename {
	my ($self) = @_;
	
	my $filename = $self->{filename};
	$filename = ".$filename" unless ($filename =~ s@/([^/]+)$@/.$1@);
	
	return $filename;
}

sub _flush {
	my ($self) = @_;
	
	while(defined $self->{_return_arr}->{$self->{_write_pos}}){
		my $item = delete $self->{_return_arr}->{$self->{_write_pos}};
		$self->_writeline($self->{_out}, $item->{i});
		
		$self->{_write_pos}++;
	}
}

sub DESTROY {
	my ($self) = @_;
	
	croak "Return array still contain elements"
		if scalar keys $self->{_return_arr} > 0;
	
	$self->SUPER::DESTROY();
}

1;
