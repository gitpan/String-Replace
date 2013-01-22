use strict;
use warnings;
use String::Replace ':all';
use Test::Subs;


my @repl = ('$test' => 'quoi', 'âccènt' => 'aïŷŷ');
my %repl = @repl;

test {
	replace('$test', @repl) eq 'quoi';
};

test {
	replace('test âccènt', @repl) eq 'test aïŷŷ';
};

test {
	replace('$test', \%repl) eq 'quoi';
};

test {
	unreplace(replace('$test', @repl),@repl) eq '$test';
};

test {
	unreplace(replace('$test', \%repl),\%repl) eq '$test';
};

my $r = String::Replace->new(@repl);
my $u = String::Replace->new_unreplace(@repl);
my $r2 = String::Replace->new(\%repl);
my $u2 = String::Replace->new_unreplace(\%repl);

test {
	$r->replace('$test') eq 'quoi';
};

test {
	$r2->replace('$test') eq 'quoi';
};

test {
	$u->unreplace($r->replace('$test')) eq '$test';
};

test {
	$u2->unreplace($r2->replace('$test')) eq '$test';
};


test {
	$r->replace('$test', '$test') ~~ ['quoi', 'quoi'];
};

test {
	my @l = ('$test', '$test');
	my @m = $r->replace(@l);
	@m ~~ ['quoi', 'quoi'];
};

test {
	my @l = ('$test', '$test');
	$r->replace(@l);
	@l ~~ ['quoi', 'quoi'];
};

{
	package
		FailedScalar;
	use parent 'Tie::Scalar';

	sub TIESCALAR { my $a = 0; return bless \$a, __PACKAGE__ }
}

test {
	tie my $a, 'FailedScalar';
	$r->replace('$test', $a) eq 'quoi';
};

failwith {
	tie my $a, 'FailedScalar';
	my @l = $r->replace('$test', $a);
	1
} 'FailedScalar';

