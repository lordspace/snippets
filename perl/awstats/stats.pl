#!/usr/bin/perl

# Executes the stat script and builds the reports and if you have htmldoc installed it will generate PDF reports too.
# Make sure that the stats dir is secured either by PWD or an IP check.
# Usage: setup a cron job
# 0 0 * * * /usr/bin/perl /root/scripts/stats.pl > /dev/null 2>&1
# (c) Svetoslav Marinov | slavi@slavi.biz | slavi.biz | devcha.com | webweb.ca
# (c) 2011
# LGPL

use strict;

$|++;

my $perl = '/usr/bin/perl';
my $awstats = '/usr/share/awstats/wwwroot/cgi-bin/awstats.pl';
my $awstats_build_stats = '/usr/share/awstats/tools/awstats_buildstaticpages.pl';
my $stats_dir = '/var/www/vhosts/webweb.ca/domains/stats.webweb.ca/htdocs/stats/';

my @sites = </etc/awstats/awstats.*>;
#my @sites = </tmp/awstats.*>;

# cleanup the files and just leave the host cfg name awstats.localhost.localdomain.conf -> localhost.localdomain
@sites = map { 
	$_ =~ s!^.*awstats\.!!gis; # clear the leading path and awstats prefix
	$_ =~ s!\.conf$!!gis; # clear the trailing stuff
	$_; # return the modified one
} @sites;

foreach my $site (@sites) {	
	next if $site =~ /model|rex|localhost.localdomain/i;
	print "Processing: $site\n-------------------------------------------------\n";
	print `$perl $awstats -config=$site -update 2>&1`;
	print `$perl $awstats_build_stats -update -config=$site -buildpdf -builddate=%YYYY%MM%DD -dir=$stats_dir 2>&1`;
	print "Processing: $site done...\n-------------------------------------------------\n\n";
}

exit(0);
