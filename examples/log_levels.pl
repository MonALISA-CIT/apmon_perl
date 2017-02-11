# This is an example that shows how Log Levels can be used.
# The logLevel can also be specified in the configuration file like:
# xApMon_loglevel = INFO

use strict;
use warnings;

use ApMon;

my $apm = new ApMon({"pcardaab.cern.ch" => {"loglevel" => "DEBUG"}});

for my $i (1 .. 100){
	print "Sending i=$i\n";
	$apm->setLogLevel("NOTICE") if $i == 10;
	$apm->setLogLevel("INFO") if $i == 50;
	$apm->sendParameters("MyCluster", "MyNode", "val_i", $i);
	$apm->sendTimedParameters("MyClusterOld", "MyNodeOld", time() - 5*3600, "val_ii", $i);
	sleep(1);
}

