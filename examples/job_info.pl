# This example shows how ApMon can be used to send information about a given job 
# to the MonALISA service
# Also, note that:
# - you can monitor multiple jobs
# - the retrieved information is a sum for all processes forked from the given pid
# - you can stop background processes with stopBgProcesses() and still do system and
#   job monitoring. You just have to call sendBgMonitoring() whenever you want to
#   send the data. However, note that also the config checker process is stopped, so
#   if you get the config from a URL, and the configuration changes, you will not get the
#   changes.
use strict;
use warnings;

use ApMon;
use Data::Dumper;

# Each 10 seconds send information about given jobs and no information about the system
my $apm = new ApMon({"aliendb1.cern.ch:8884" => {"job_monitoring" => 1, "job_interval" => 10, 
					"sys_monitoring" => 0, "general_info" => 1, "sys_interval" => 10}});

print "machine: ".Dumper($apm->getCpuType());

$apm->setLogLevel("NOTICE");

# Monitor this process and all its children
$apm->addJobToMonitor($$, "$ENV{PWD}/cucu", "JobInfoTest_Nodes", "job");

print "Sleeping for 5 seconds ".gmtime()."\n";
sleep(5);
$apm->sendBgMonitoring();
$apm->setCpuSI2k(2731);
$apm->setDB12(7.3);
$apm->sendBgMonitoring();

print "Running a forked job ".gmtime()."\n";
#my $n=20000000; for(my $i=1; $i<$n; $i++){ my $j=$i*$i; $j=sqrt($j); }
system('perl -e \'my $n=200000000; for(my $i=1; $i<$n; $i++){ my $j=$i*$i; $j=sqrt($j); }\'');

print "finished the forked job ".gmtime()."\n";

print "si2k=".Dumper($apm->getJobMonInfo($$, "cpu_ksi2k"))."\n";
print "cpu_db12=".Dumper($apm->getJobMonInfo($$, "cpu_db12"))."\n";

print "Sleeping for 5 seconds ".gmtime()."\n";
sleep(5);
$apm->sendBgMonitoring();

print "Working for 60 seconds ".gmtime()."\n";
my $start = time();
while($start + 60 > time()) { };

print "Preparing to finish in 60 seconds\n";
sleep(60);

# Although here this is not needed because program ends, you can stop monitoring a 
# job if you need.
$apm->removeJobToMonitor($$);
