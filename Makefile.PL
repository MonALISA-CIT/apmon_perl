use 5.008;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		 => 'ApMon_perl',
    'VERSION_FROM'	 =>'ApMon/Common.pm', # finds $VERSION
    'PREREQ_PM'		 => {
	'Data::Dumper'   => 0,
	'LWP::UserAgent' => 0,
	'Net::Domain'    => 0,
	'Socket'         => 0,
	'Exporter'       => 0,
     }, # e.g., Module::Name => 1.1
     'PMLIBDIRS'         => ['ApMon'],
     'AUTHOR'            => 'MonALISA-CIT@cern.ch',
);
