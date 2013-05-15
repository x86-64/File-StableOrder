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

sub rewind {
	my ($self) = @_;

	$self->{_input}->rewind;
	$self->{_output}->rewind;
}

sub readline {
	my $self = shift;

	return $self->{_input}->readline();
}

sub returnline {
	my $self = shift;
	
	$self->{_have_changes} = 1;
	return $self->{_output}->returnline(@_);
}

sub _tmpfilename {
	my ($self) = @_;
	
	my $filename = $self->{filename};
	$filename = ".$filename" unless ($filename =~ s@/([^/]+)$@/.$1@);
	
	return $filename;
}

sub finish {
	my $self      = shift;
	my $final     = (shift || 0);
	
	return if defined $self->{_donot_rename};
	return if not defined $self->{_output};
	return if not defined $self->{_input};
	
	if(defined $self->{_have_changes}){
		my ($in, $out) = ($self->{filename}, $self->_tmpfilename);
		
		undef $self->{_output}; # flush changes to disk
		undef $self->{_input};
		
		rename(
			$out,
			$in,
		) || croak "Failed to finalize file";
		
		delete $self->{_have_changes};
	}else{
		unlink($self->_tmpfilename);
	}
	
	return if $final != 0;
	$self->{_input}  = File::StableOrder::ReadOnly->new (filename => $self->{filename});
	$self->{_output} = File::StableOrder::WriteOnly->new(filename => $self->_tmpfilename);
}

sub DESTROY {
	my ($self) = @_;
	
	$self->finish(1); # don't recreate file
}

1;
