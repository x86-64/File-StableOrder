package File::StableOrder::ReadWrite;

use Carp;
use File::StableOrder::ReadOnly;
use File::StableOrder::WriteOnly;

sub new {
	my ($class, %params) = @_;
	
	my $self = bless { %params }, $class;
	
	my $output_filename = $params{output_filename};
	if(defined $output_filename){
		$self->{_donot_rename} = 1;
	}else{
		$output_filename = $self->_tmpfilename;
	}

	$self->{_input}  = File::StableOrder::ReadOnly->new (filename => $params{filename});
	$self->{_output} = File::StableOrder::WriteOnly->new(filename => $output_filename);
	
	if($self->{_output}->size > 0){
		if(defined $params{truncate}){
			$self->{_output}->truncate();
		}elsif(defined $params{continue}){
			$self->{_output}->restore_pos();
			
			for(1..$self->{_output}->pos){
				my $line = $self->{_input}->readline();
			}
		}else{
			undef $self->{_output};
			undef $self->{_input};
			croak "Found incomplete output file from previous run. Specify 'truncate' or 'continue' in parameters";
		}
	}

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
	
	if(defined $self->{_output} and defined $self->{_input} and not defined $self->{_donot_rename}){
		rename(
			$self->{_output}->{filename},
			$self->{_input}->{filename}
		) || croak "Failed to move file";
	}
	delete $self->{_output};
	delete $self->{_input};
}

1;
