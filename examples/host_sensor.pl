# This example shows how ApMon can be used as a simple host sensor to monitor and send
# the desired parameters to the MonALISA service (configured in the given file/url)
use strict;
use warnings;

use Net::Domain;
use ApMon;
use Data::Dumper;

my $apm = new ApMon("examples/destinations.conf");

my $my_host = Net::Domain::hostfqdn();
# the background data about the system will be sent with this cluster and node
$apm->setMonitorClusterNode("MySensor", $my_host);

# sleep forever
while(1){
	sleep 15;
	print "final: ".Dumper($apm->getSysMonInfo("load1", "load5", "os_type", "eth0_in", "eth0_out", "em0_in", "em0_out", "em1_in", "em1_out"));
}
