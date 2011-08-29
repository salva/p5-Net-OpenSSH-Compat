package Net::OpenSSH::Compat::SSH;

our $VERSION = '0.04';

use strict;
use warnings;
use Carp ();
use IPC::Open2;
use IPC::Open3;
use Net::OpenSSH;
use Net::OpenSSH::Constants qw(OSSH_MASTER_FAILED OSSH_SLAVE_CMD_FAILED);

require Exporter;
our @ISA = qw(Exporter);

my $supplant;
my $session_id = 1;

our %DEFAULTS = ( connection => [] );

sub import {
    my $class = shift;
    if (!$supplant and
        $class eq __PACKAGE__ and
        grep($_ eq ':supplant', @_)) {
        $supplant = 1;
        for my $end ('') {
            my $this = __PACKAGE__;
            my $pkg = "Net::SSH";
            my $file = "Net/SSH";
            if ($end) {
                $this .= "::$end";
                $pkg .= "::$end";
                $file .= "/$end";
            }
            $INC{$file . '.pm'} = __FILE__;
            no strict 'refs';
            @{"${pkg}::ISA"} = ($this);
            ${"${pkg}::VERSION"} = __PACKAGE__->version;
        }
    }
    __PACKAGE__->export_to_level(1, @_);
}

sub version { "0.09 (".__PACKAGE__."-$VERSION)" }

sub ssh {
    my $host = shift;
    my $ssh = Net::OpenSSH->new($host);
    if ($ssh->error) {
        $? = (255<<8);
        return -1;
    }
    my @cmd = $ssh->make_remote_command({quote_args => 0}, @_);
    system (@cmd);
}

sub ssh_cmd {
    my ($host, $user, $command, @args, $stdin);
    if (ref $_[0] eq 'HASH') {
        my %opts = $_[0];
        $host = delete $opts{host};
        $user = delete $opts{user};
        $command = delete $opts{command};
        $stdin = delete $opts{stdin_string};
        my $args = delete $opts{args};
        @args = @$args if defined $args;
    }
    else {
        ($host, $command, @args) = @_;
    }
    $stdin = '' unless defined $stdin;
    my $ssh = Net::OpenSSH->new($host, user => $user);
    if ($ssh->error) {
        $? = (255<<8);
        die $ssh->error;
    }
    my ($out, $err) = $ssh->capture2({quote_args => 0, stdin_data => $stdin},
                                     $command, @args);
    die $err if length $err;
    $out;
}

sub sshopen2 {
    my($host, $reader, $writer, $cmd, @args) = @_;
    my $ssh = Net::OpenSSH->new($host);
    $ssh->die_on_error;
    my @cmd = $ssh->make_remote_command({quote_args => 0}, $cmd, @args);
    open2($reader, $writer, @cmd);
}

sub sshopen2 {
    my($host, $reader, $writer, $erro, $cmd, @args) = @_;
    my $ssh = Net::OpenSSH->new($host);
    $ssh->die_on_error;
    my @cmd = $ssh->make_remote_command({quote_args => 0}, $cmd, @args);
    open3($writer, $reader, $error, @cmd);
}

1;
