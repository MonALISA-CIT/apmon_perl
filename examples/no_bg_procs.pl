# This example shows how ApMon can be initalised without creating the background
# processes, and also how to do background monitoring on demand.

use strict;
use warnings;

use ApMon;

# Pass the parameter 0 to the constructor to avoid doing the fork.
my $apm = new ApMon(0);

# initialize ApMon in one of the possible late init ways
#my $config = "destinations.conf";
my $config = ['pcardaab.cern.ch:8884'];
#my $config = {'pcardaab.cern.ch' => {'hostname' => 0, 'cpu_MHz' => 0}};

# set default Cluster and Node for system monitoring parames
$apm->setMonitorClusterNode("No_Bg_Procs", "myHost");
$apm->setLogLevel('DEBUG');

# Initialize the apmon 
$apm->setDestinations($config);

for my $k (50 .. 100) {
	$apm->sendParameters("No_Bg_Procs", "myTest", "var_s", $k);
	sleep(1);
	$apm->sendBgMonitoring();
	sleep(1);
}

