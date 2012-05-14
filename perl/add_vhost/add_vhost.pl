#!/usr/bin/perl
######################################################################################################
# Adds a vhost on my vps and creates the necessary folders, permissions, ownerships and reloads the web server.
# Must be run as root.
# Svetoslav Marinov | http://WebWeb.ca | http://Orbisius.com | http://twitter.com/lordspace
# Copyright 2011-2012 All Rights Reserved.
# License: LGPL
######################################################################################################

usage() unless @ARGV;

my $domain = shift(@ARGV);
my $domain_copy;

# spaces are OK so we'll remove them.
$domain =~ s/^\s*//sig;
$domain =~ s/\s*$//sig;
$domain =~ s/w+\.//sig; # www prefix needed

$domain_copy = $domain;
$domain =~ s/[^\w-\.]//sig;

if ($domain ne $domain_copy || $domain !~ /\.\w{2,5}$/si) {
	die("Domain: [$domain_copy] is invalid or contains bad characters.\n");
} elsif (-d "/var/www/vhosts/$domain") {
	die("Domain: $domain already exists.\n");
}

print "Setting up folders /var/www/vhosts/$domain ...\n";
print `mkdir -p /var/www/vhosts/$domain`;
print `mkdir -p /var/www/vhosts/$domain/htdocs`;
print `mkdir -p /var/www/vhosts/$domain/logs`;

local *FILE;

print "Creating a sample index.php file.\n";
my $index_file = "/var/www/vhosts/$domain/htdocs/index.php";
open FILE, '>' . $index_file || die("Error: $!");
print FILE "Under Construction.";
close FILE;

print "Setting up permissions.\n";
print `chown -R apache:apache /var/www/vhosts/$domain`;
print `chmod -R 775 /var/www/vhosts/$domain`; # slavi user has to have access to the files too

my $vhost_file = "/etc/httpd/conf.d/zz_" . $domain . ".conf";
print "Setting up vhost file [$vhost_file].\n";
open FILE, '>' . $vhost_file || die("Error: $!");
print FILE vhost_conf($domain);
close FILE;

print "Asking WebServer to reload.\n";
print `/etc/init.d/httpd reload`;
print "Done\n";

sub usage {
	die("$0 domain.com - will setup the domain name. It must not exist already.\n");
}

sub vhost_conf {
	my ($dom) = @_;
	my $buff = "
# $dom
<VirtualHost *:80>
    ServerAdmin admin@$dom
    DocumentRoot /var/www/vhosts/$dom/htdocs

	ServerName $dom
	ServerAlias *.$dom

    ErrorLog /var/www/vhosts/$dom/logs/apache_error.log
    #CustomLog /var/www/vhosts/$dom/logs/apache_common.log common
    CustomLog /var/www/vhosts/$dom/logs/apache_combined.log catch_all_combined

    <Directory /var/www/vhosts/$dom/htdocs>
		Options Indexes FollowSymLinks Includes ExecCGI
		AllowOverride All
   </Directory>
</VirtualHost>	

";
	return $buff;
}

exit(0);
