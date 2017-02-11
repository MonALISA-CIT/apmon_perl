# This example shows how ApMon can be used to send parameters with a
# given time, set by user to the MonALISA service

# This feature can be useful, for example, if you generate the parameters by
# parsing a log file and you want that they have the time from the log.
use strict;
use warnings;

use ApMon;

# Initialize ApMon by specifying a ref to a list of hosts having a MonALISA service running
# with monXDRUDP module enabled.
# Note that background monitor process sends information about the host. In ApMon/Common.pm
# is the list with default parameters. If you want to modify what is sent, you can either
# take the configuration from a file or URL, or you can use a hash reference instead
my $apm = new ApMon(["pcardaab.cern.ch:8885"]); #, "lcfg.rogrid.pub.ro:8832"]);
$apm->setMaxMsgRate(100000);
for my $i (1 .. 200) {
	my $time = time() - 2 * 3600 - (20 - $i) * 60;
	my $state = int(rand(10));
	# Note that also there's a sendTimedParams version
	$apm->sendTimedParameters("LogParser", "SomeApp", $time, "state", $i);
	sleep(0.1);
}

