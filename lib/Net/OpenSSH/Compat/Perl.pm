package Net::OpenSSH::Compat::Perl;

our $VERSION = '0.03';

use strict;
use warnings;
use Carp;

use Net::OpenSSH;
use Net::OpenSSH::Constants qw(OSSH_MASTER_FAILED);

require Exporter;

my $supplant;

our %DEFAULTS = ( session => [ port => 22, proto => '2' ] );

sub import {
    my $class = shift;
    if (!$supplant and
        $class eq __PACKAGE__ and
        grep($_ eq ':supplant', @_)) {
        $supplant = 1;
        for my $end ('', qw(Channel SFTP Dir File)) {
            my $this = __PACKAGE__;
            my $pkg = "Net::SSH::Perl";
            my $file = "Net/SSH/Perl";
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

sub new {
    my $class = shift;
    my $host = shift;
    my %opts = @{$DEFAULTS{session}}, @_;
    my $cpt = { host => $host,
                state => 'new' };

    $cpt{$_} = delete $opts{$_} for qw(port debug interactive
                                       privileged identity_files
                                       cipher ciphers
                                       compression compression_level
                                       use_pty options);

    %opts and Carp::croak "unsupported option(s) given: ".join(", ", keys %opts);
    $cpt{proto} =~ /\b2\b/ or croak "Unsupported protocol version requested $cpt{proto}";

    bless $cpt, $class;
}

sub _entry_method {
    my $n = 1;
    my $last = 'unknown';
    while (1) {
        my $sub = (caller $n++)[3];
        $sub =~ /^Net::OpenSSH::Compat::(?:\w+::)?(\w+)$/ or last;
        $last = $1;
    }
    $last;
}

sub _check_state {
    my ($cpt, $expected) = @_;
    my $state = $cpt->{state};
    return 1 if $expected eq $state;
    my $method = $cpt->_entry_method;
    my $class = ref $cpt;
    croak qq($class object can't do "$method" on state $state);
    return
}

sub _check_error {
    my $cpt = shift;
    my $ssh = $cpt->{ssh};
    return if (!$ssh->error or $ssh->error == OSSH_SLAVE_CMD_FAILED);
    my $method = $cpt->_entry_method;
    $self->{state} = 'failed' if $ssh->error == OSSH_MASTER_FAILED;
    croak "$method failed: " . $ssh->error;
}

sub login {
    my ($cpt, $user, $password, $suppress_shell) = @_;
    $cpt->_check_state('new');

    $cpt->{user} = $user;
    $cpt->{password} = $password;
    $cpt->{suppress_shell} = $shell;

    my @args = (host => $cpt->{host},
                port => $cpt->{port},
                user => $cpt->{user});

    push @args, password => $password if defined $password;
    push @args, batch_mode => 1 if $cpt->{interactive};
    push @args, -o => 'UsePrivilegedPort=yes' if $cpt->{privileged};
    push @args, -o => "Ciphers=$cpt->{ciphers}" if defined $cpt->{ciphers};
    push @args, -o => "Compression=$cpt->{compression}" if defined $cpt->{compression};
    push @args, -o => "CompressionLevel=$cpt->{compression_level}" if defined $cpt->{compression_level};
    if ($cpt->{identity_files}) {
        push @args, -o "IdentityFile=$_" for @{$cpt->{identity_files}};
    }

    my $ssh = $cpt->{ssh} = Net::OpenSSH->new(@args);
    $ssh->die_on_error;

    $cpt->{state} = 'connected';
}

sub cmd {
    my ($cpt, $cmd, $stdin) = @_;
    $cpt->_check_state('connected');
    $ssh = $cpt->{ssh};
    $stdin = '' unless defined $stdin;
    local $?;
    my ($out, $err) = $ssh->capture2({stdin_data => $stdin}, $cmd);
    $cpt->_check_error;
    return ($out, $err, ($? >> 8));
}

sub shell {
    my $cpt = shift;
    $cpt->_check_state('connected');
}


1;
