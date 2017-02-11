# This example shows how ApMon can be used to send hashes
# to the MonALISA service (given in the constructor)
use strict;
use warnings;

use Net::Domain;
use ApMon;

# Initialize ApMon by reading the configuration from a url
my $apm = new ApMon("http://monalisa2.cern.ch/~catac/apmon/destinations.conf");

my @month = ("Jannuary", "February", "March", "April", "May", "June", "July",
	"August", "Septembter", "October", "November", "December");

my $hostname = Net::Domain::hostfqdn();

#Don't send any parameters; just set the default cluster and node
$apm->sendParameters("CurrentDate", $hostname);

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday) = gmtime(time);
my $date = {"year" => 1900 + $year, "month" => $month[$mon], "day" => $mday};

for my $i (1 .. 20) {
	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday) = gmtime(time);
	$date->{"hour"} = $hour;
	$date->{"minute"} = $min;
	$date->{"second"} = $sec;
	# we pass the reference to the hash.
	# Note that being a hash, the keys order might vary. Use an array or
	# a reference to an array if you are concerned about their order.
	$apm->sendParams($date);
	sleep(1);
}

