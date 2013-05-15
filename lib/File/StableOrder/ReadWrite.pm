package File::StableOrder::ReadWrite;

use Carp;
use File::StableOrder::ReadOnly;
use File::StableOrder::WriteOnly;

sub new {
	my ($class, %params) = @_;
	
	my $self = bless { %params }, $class;
	
	$self->{_input}  = File::StableOrder::ReadOnly->new (filename => $params{filename});
	$self->{_output} = File::StableOrder::WriteOnly->new(filename => $self->_tmpfilename);
	
	return $self;
}

sub readline {
	my $self = shift;

	return $self->{_input}->readline();
}

sub returnline {
	my $self = shift;
	
	return $self->{_output}->returnline(@_);
}

sub _tmpfilename {
	my ($self) = @_;
	
	my $filename = $self->{filename};
	$filename = ".$filename" unless ($filename =~ s@/([^/]+)$@/.$1@);
	
	return $filename;
}

sub DESTROY {
	my ($self) = @_;
	
	rename(
		$self->{_output}->{filename},
		$self->{_input}->{filename}
	) || croak "Failed to move file";
	
	undef $self->{_output};
	undef $self->{_input};
}

1;
