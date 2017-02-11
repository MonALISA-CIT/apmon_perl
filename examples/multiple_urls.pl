# This example shows how ApMon can be used as a simple host sensor to monitor and send
# the desired parameters to the MonALISA service (configured in the given file/url)
use strict;
use warnings;

use Net::Domain;
use ApMon;

my $apm = new ApMon("http://monalisa2.cern.ch/~catac/apmon/destinations.conf", "destinations.conf");

#my $apm = new ApMon();
#$apm->setLogLevel("ERROR");
#$apm->setDestinations("http://monalisa2.cern.ch/~catac/apmon/destinations.conf", "destinations.conf1");

my $my_host = Net::Domain::hostfqdn();
# the background data about the system will be sent with this cluster and node
$apm->setMonitorClusterNode("MySensor", $ENV{HOSTNAME});

# sleep forever
sleep(1) while(1);

