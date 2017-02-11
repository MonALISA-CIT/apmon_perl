# This example shows how ApMon can get its configuration from a cgi script or a servlet -
# there's no change needed in the code. You just have to point the URL from where to read
# the configuration to your cgi script / servlet. This allows generating the configuration
# based on the IP from where the request came, or based on some parameters sent by the user.

# Being able to get the configuration based on the IP address of the
# request can be useful if for example you have a distributed system that
# allows users to run jobs and each worker node where the job is run
# you want to report the data to the closest MonALISA service without having
# to know apriori on which site the job would run.

# Generating the config based on parameters is useful for example to send the
# the information from 2 or more different applications to different dedicated
# MonALISA services.

use strict;
use warnings;

use Net::Domain;
use ApMon;

my $apm = new ApMon("http://pcardaab.cern.ch:8888/cgi-bin/ApMonConf?appName=confgen_test");

$apm->setLogLevel("NOTICE");

my $my_host = Net::Domain::hostfqdn();
# the background data about the system will be sent with this cluster and node
$apm->setMonitorClusterNode("MyStatus", $my_host);

# just send some data
my $x = 0;
while( $x++ < 10 ){
	$apm->sendParameters("MyCluster", "MyNode", "x", $x);
	sleep(1);
}

