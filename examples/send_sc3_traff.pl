# This example simulates some traffic on the WAN links
# from SC3. The produced farm/cluster/node/param-s are
# similar with those coming from the SNMP ML module
use strict;
use warnings;

use Net::Domain;
use ApMon;

# Initialize ApMon by reading the configuration from a url
my $apm = new ApMon("http://monalisa2.cern.ch/~catac/apmon/destinations.conf");

my %farm_ip = ( "CERN"      => "1.1.1.1",
		"SARA"      => "1.1.1.2",
		"RAL"       => "1.1.1.3",
		"ASCC"      => "1.1.1.4",
		"TRIUMF"    => "1.1.2.1",
		"IN2P3"     => "1.1.2.2",
		"FZK"       => "1.1.2.3",
		"DESY"      => "1.1.2.4",
		"CNAF"      => "1.1.2.5",
		"PIC"       => "1.1.2.6",
		"NORDUgrid" => "1.1.2.7",
		"BNL"       => "1.1.3.1",
		"FNAL"      => "1.1.3.2" );

my %farm_loc = ("CERN"      => "CH	6.15	46.22",
		"SARA"      => "NL	4.893	52.373",
		"RAL"       => "UK	-1.232	51.602",
		"ASCC"      => "TW	121.60	25.05",
		"TRIUMF"    => "CA	-123.11	49.262",
		"IN2P3"     => "FR	4.829	45.759",
		"FZK"       => "DE	8.4	49.05",
		"DESY"      => "DE	10.00	53.55",
		"CNAF"      => "IT	10.40	43.72",
		"PIC"       => "ES	-3.72	40.42",
		"NORDUgrid" => "SE	18.08	59.33",
		"BNL"       => "US	-72.888	40.863",
		"FNAL"      => "US	-88.309	41.852" );


my %capa = ( "CERN-SARA"      => 1000,
	     "CERN-RAL"       => 1000,
	     "CERN-ASCC"      => 1000,
	     "CERN-TRIUMF"    => 2000,
	     
	     "CERN-IN2P3"     => 1000,
	     "CERN-FZK"      => 10000,
	     "CERN-DESY"      => 1000,
	     "CERN-CNAF"      => 1000,
	     "CERN-PIC"       => 1000,
	     "CERN-NORDUgrid" => 1000,

	     "CERN-BNL"      => 10000,
	     "CERN-FNAL"     => 10000 );


my %to_send = ();
for my $link (keys %capa){
	my $smax = $capa{$link};
	my $sin = rand($smax);
	my $sout = rand($smax);
	$link =~ /(.+)-(.+)/;
	my ($src, $dst) = ($1, $2);
	print "${link}_OUT\t$farm_ip{$src}\t$farm_ip{$dst}\t$smax\n";
	print "${link}_IN\t$farm_ip{$dst}\t$farm_ip{$src}\t$smax\n";
	$to_send{"${link}_IN"} = $sin;
	$to_send{"${link}_OUT"} = $sout;
	$to_send{"${link}_SPEED"} = $smax;
}
print "\n";
print "[Cities]	# do NOT delete this line\n";
print "\n";

for my $farm (keys %farm_ip){
	print "$farm\t$farm_loc{$farm}\t$farm_ip{$farm}\n";
}

print "\n";

for my $i (1 .. 3000) {
	print "sending $i...\n";
	$apm->sendParameters("WAN", "fake.router", %to_send);
	sleep(1);
}

