# This example shows how ApMon can be used as a simple host sensor to monitor host
# and a set of daemons running on the same machine. The script should be sitarted
# with an even number of parameters, pairs like <daemon_name> <it's pid>. 
use strict;
use warnings;

use Net::Domain;
use ApMon;

my $apm = new ApMon("http://pcardaab.cern.ch:8888/cgi-bin/ApMonConf?appName=xrootd_test");

my $my_host = Net::Domain::hostfqdn();
# the background data about the system will be sent with this cluster and node
$apm->setMonitorClusterNode("XrootdTest", $my_host);
if(@ARGV % 2 != 0){
	print "Odd number of parameters!\n";
	exit(1);
}

for(my $i = 0; $i < @ARGV; $i += 2){
	print "Will monitor daemon <$ARGV[$i]> with pid <$ARGV[$i+1]>\n";
	$apm->addJobToMonitor($ARGV[$i+1], "", $ARGV[$i], $my_host);
}
print "Initialization finished. Will monitor untill killed.\n";

# sleep forever
sleep(1) while(1);

