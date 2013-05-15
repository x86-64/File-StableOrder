#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;
use File::StableOrder::ReadWrite;

plan tests => 2;

my $testfile = "test.txt";

# prepare file
sub testfile_create {
	my ($testfile, @arr) = @_;
	
	open FH, ">", $testfile or die $!;
	for(@arr){
		print FH $_, $/;
	}
	close FH;
}

sub testfile_check {
	my ($testfile, @arr) = @_;

	open FH, "<", $testfile or die $!;
	while(my $line = <FH>){
		chomp $line;
		$line = int($line);
		
		my $shouldbe = shift @arr;

		return 0 if($shouldbe != $line);
	}
	close FH;
	return 1;
}

my $file;

# SIMPLE LOOP
testfile_create($testfile, 1 .. 10000);
$file = File::StableOrder::ReadWrite->new(
	filename => $testfile
);
while(my $item = $file->readline()){
	$item->{i} = $item->{i}+1; 
	
	$file->returnline($item);
}
undef $file;

ok(testfile_check($testfile, 2 .. 10001), "Inc loop");

# RANDOM RETURNS
my @arr;
testfile_create($testfile, 3 .. 10000);
$file = File::StableOrder::ReadWrite->new(
	filename => $testfile
);
while(my $item = $file->readline()){
	$item->{i} = $item->{i}+1; 
	
	push @arr, $item;
}
while(scalar @arr){
	my $item = splice @arr, ( int(rand(scalar @arr)) ), 1;
	
	$file->returnline($item);
}

undef $file;

ok(testfile_check($testfile, 4 .. 10001), "Random return loop");

