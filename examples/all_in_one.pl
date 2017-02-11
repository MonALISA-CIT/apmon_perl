#!/usr/bin/perl
use ApMon;

use strict;
use warnings;
use Net::Domain;

# Initalize ApMon. As parameters, you can give a list of destination locations to read the
# configuration from.
#my $apm = new ApMon("http://monalisa2.cern.ch/~catac/apmon/destinations.conf");

# If you prefer setting the configuration later, you can initialize ApMon with no parameters

my $apm = new ApMon();

# and use the following function. This accepts the same parameters as the constructor. You 
# can use this function to change anytime the current configuration.

$apm->setDestinations("http://monalisa2.cern.ch/~catac/apmon/destinations.conf");

# You can stop anytime the background processes (config loader and background monitor)
# calling the following function. 

# $apm->stopBgProcesses();

# However, if you do this, in order to perform the system and jobs (if defined) monitoring 
# and sending of the gathered information, you will have to call

# $apm->sendBgMonitoring();

# If you initialize ApMon passing as parameter to the constructor a reference to an array of strings, 
# each element of this array will be considered a destination (host[:port][ pass]).
# ApMon will send datagrams to all valid given destinations (i.e. hosts that can be resolved), with default options.

# my $apm = ApMon->new(["pcardaab.cern.ch:8884"]);

# You can also initialize ApMon by passing as parameter to the constructor a reference to a hash. In
# this case, the keys will be destinations and the corresponding values will be references to another
# hash in which the key is a configuration option and the value is the value of that option.
# Note that in this case, the options should not be preceded by xApMon_ and options should be 0/1 instead
# of on/off as in the configuration file.

# my $apm = ApMon->new({"pcardaab.cern.ch:8884" => {"sys_monitoring" => 0, "job_monitoring" => 1, "general_info" => 1}, 
#	"lcfg.rogrid.pub.ro" => {"sys_monitoring" => 1, "general_info" => 0}});

# Set cluster and node name for the data that is monitored in background
my $hostname = Net::Domain::hostfqdn();
$apm->setMonitorClusterNode("MyStatus", $hostname);

# Add a job that has to be monitored. 
my $cwd = `pwd`;
chomp $cwd;
$apm->addJobToMonitor($$, $cwd, "MyJobStatus", $$);

my $yesterday = time - 20 * 3600;

my $i = 0;
while(++$i < 100) {
		
	# You can send some parameters like this. The given cluster and node names will
	# be kept as defaults for the next sendParams(..) calls. You can put as many
	# (param, value) pairs as you want.
	$apm->sendParameters("MyCluster", "MyNode", "param1", 14.23e-10, "param2", 234);
	
	# Use this to send parameters with the default cluster and node names.
	$apm->sendParams("param3", 12+$i, "param4", 1.0/$i);

	# If you need to set a certain time for the results that you send, use the 
	# sendTimedParameters. Note that you can use an array instead of passing 
	# all the parameters in the function call. Note that the sendTimedParam* functions
	# will be supported only in MonALISA service version >= 1.2.27.
	my @mylist = ("zxc", 11, "mnb", 22, "aaa", 333);
	$apm->sendTimedParameters("YesterdayCluster", $hostname, $yesterday + $i, @mylist);
	
	# Here is the shorter version, for the same cluster and node. Note that you can also
	# pass a refence to your array. Time is in seconds from Epoch.
	$mylist[1] = 99; $mylist[3] = 88; $mylist[5] = 777;
	$apm->sendTimedParams($yesterday + $i, \@mylist);
	
	# If you don't care about the order in which the given parameters are sent, you can use
	# hash to store your data. As before, you can pass the hash or a reference to it.
	my $myhashRef = {"param5" => $i, "param6" => 876};
	$apm->sendParameters("MyJobStatus", $$, $myhashRef);

	# Stop monitoring a job
	if($i == 100){
		$apm->removeJobToMonitor($$);
	}
	
	# You can also monitor serveral jobs.
	if($i == 200){
		$apm->addJobToMonitor($$, $cwd, "MyJobStatus", $$);
	}
	print "waiting...\n";
	sleep(1);
}

