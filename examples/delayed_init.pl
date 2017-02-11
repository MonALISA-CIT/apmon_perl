# This example shows how ApMon can be initalised after creating the ApMon object.
# This feature is useful if:
# - you want to instrument a big application, that allocates a lot of objects. Note that
#   because threads are not well supported in perl, ApMon uses processes for background
#   monitoring of host and jobs, so it would be desirable that the ApMon background
#   processes be created before initializing your application
# - you know the configuration for ApMon only after your app initializes

use strict;
use warnings;

use ApMon;

# The fork happens here, so it has a minimum impact over the memory footprint
my $apm = new ApMon();

# do some complex initialization of your application here
# and get the ApMon configuration
my $readConfigFrom = "destinations.conf";

# Initialize the apmon 
$apm->setDestinations($readConfigFrom);

for my $k (50 .. 100) {
	$apm->sendParameters("Late_init", "myApp", "var_k", $k);
	sleep(1);
}

