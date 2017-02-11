# This example shows how you cand recreate multiple times the ApMon object

use strict;
use warnings;

use ApMon;

sub doStuff {
	my $i = shift;
	
	print "start $i\n";
	my $apm = new ApMon("http://monalisa2.cern.ch/~catac/apmon/destinations.conf");
	$apm->sendParameters('cluster', 'node', ('param', 34+$i));
	# You absolutely have to call this function here!
	$apm->free();
	print "end $i\n";
}

for my $i (1 .. 3000){
	doStuff($i);
}

