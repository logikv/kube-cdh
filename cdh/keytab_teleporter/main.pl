package main::Utils;

BEGIN {}

my @roles = ("hdfs","yarn", "hive");
my $KRB5_PASS = "123123123";
my $KRB5_REALM = "CLOUDERA";

sub pingServer {
    my $host = shift;
    use Net::Ping;
    my $p = Net::Ping->new();
    my $result = $p->ping($host);
    $p->close();
    return $result;
}

sub haveKeytab {
    my $role = shift;
    `cat /etc/$role.keytab`;
    return $? != 0 ? 0 : 1;
}

sub getKeytabFromKDC {
    my $role = shift;
    my $fqdn = shift;
    use Net::OpenSSH;
    my $ssh = Net::OpenSSH->new("kdc-server", user => "root", password => "$KRB5_PASS");
    $ssh->system("kadmin.local -q 'addprinc -pw $KRB5_PASS $role/$fqdn\@$KRB5_REALM'
    && cd /etc/
    && kadmin.local -q 'xst -norandkey -k $role-$fqdn.keytab $role/$fqdn\@$KRB5_REALM'");
    $ssh->scp_get({glob => 1}, '/etc/*.keytab', '/etc')
        or die "scp failed: " . $ssh->error;
}

sub openListener {

}

END {}
1;

use strict;
use warnings;

my $properties = {};

my @args = @ARGV;

for my $arg (@args) {
    my @arg = split("\=", $arg, 2);
    $properties->{$arg[0]} = $arg[1];
}

client();


sub client {
    unless(haveKeytab($properties->{role})){
        pingServer("0.0.0.0");
        my $keytab = getKeytabFromKDC();
        # checkKeytab($keytab);
    }
    exit(0);
}

1;




