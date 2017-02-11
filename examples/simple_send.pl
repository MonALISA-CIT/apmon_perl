# Thome complex initialization of your application here
# # and get the ApMon configuration
# my $readConfigFrom = "destinations.conf";
#
# # Initialize the apmon
# $apm->setDestinations($readConfigFrom);
# s example shows how ApMon can be used to send the parameters 
# to the MonALISA service (given in the constructor)
use strict;
use warnings;

use ApMon;

# Initialize ApMon specifying that it should not send information about the system. 
# Note that in this case the background monitoring process isn't stopped, in case you may
# want later to monitor a job.
my $apm = new ApMon({"lxgate35.cern.ch:58884" => {"sys_monitoring" => 0, "general_info" => 0}});

$apm->setMaxMsgRate(145);

my $var = $apm;

for my $i (1 .. 20) {
	# you can put as many pairs of parameter_name, parameter_value as you want
	# but be careful not to create packets longer than 8K.
	$apm->sendParameters("SimpleCluster", "SimpleNode", "var_i", $i, "var_i^2", $i * $i);
	my $f = (20.0 / $i);
	# send in the same cluster and node as last time
	$apm->sendParams("var_f", $f, "5_times_f", 5 * $f, "i+f", $i + $f);
#	sleep(1);

	select(undef, undef, undef, 0.015);

	# some busy waiting to slow down the things
#	for my $k (1 .. 100000){
#		$k *= 1;
#	}
	
#	if($i > 20000){
#	    for my $j (1 .. 100000){
#		$j *= 1;
#	    }
#	}

#	if($i % 10000 == 0){
#		print "Sleeping 10 sec\n";
#		sleep (10);
#	}
}

