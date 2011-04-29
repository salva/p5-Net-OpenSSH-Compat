package Net::OpenSSH::Compat::SSH2;

our $VERSION = '0.01';

use strict;
use warnings;

use Net::OpenSSH;
use IO::Handle;
use IO::Seekable;
use File::Basename ();
use Fcntl ();
use Carp ();
use Scalar::Util ();

require Exporter;
our @ISA = qw(Exporter Net::OpenSSH::Compat::SSH2::Base);

use Net::OpenSSH::Compat::SSH2::Constants;

our %EXPORT_TAGS;
our @EXPORT_OK = @{$EXPORT_TAGS{all}};
$EXPORT_TAGS{supplant} = [];

our %DEFAULTS = (connection => [],
                 channel    => []
                 sftp       => []);

my $supplant;

sub import {
    my $class = shift;
    if (!$supplant and
        $class eq __PACKAGE__ and
        grep($_ eq ':supplant', @_)) {
        $supplant = 1;
        for my $end ('', qw(Channel SFTP Dir File)) {
            my $this = __PACKAGE__;
            my $pkg = "Net::SSH2";
            my $file = "Net/SSH2";
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

sub version { "1.2.6 (".__PACKAGE__."-$VERSION)" }

sub new {
    my $class = shift;
    my $cpt = { state => 'new',
                error => [0, "", ""],
                blocking => 1,
                channels => [] };
    bless $cpt, $class;
}

sub _free_channels {
    my $cs = shift->{channels};
    @$cs = grep defined, @$cs;
    Scalar::Util::weaken $_ for @$cs;
}

sub banner {}

sub error { wantarray ? @{shift->{error}} : shift->{error}[0] }

sub sock { undef }

sub trace { }

my @_auth_list = qw(publickey password);
sub auth_list {
    wantarray ? @_auth_list : join(',', @_auth_list);
}

sub connect {
    my $cpt = shift;
    $cpt->{connect_args} = [@_];
    $cpt->{state} = 'connected*';
}

sub auth_ok { shift->{state} eq 'ok' }

sub auth_password  { shift->_connect(auth_password    => @_) }
sub auth_publickey { shift->_connect(auth_publickey => @_) }
sub auth           { shift->_connect(auth           => @_) }


sub _connect {
    my $cpt = shift;
    $cpt->_check_state('connected*') or return;

    my ($host, $port, %opts) = @{$cpt->{connect_args}};
    my @args = (@{$DEFAULTS{connection}||[]},
                host => $host, port => $port,
                timeout => delete($opts{Timeout}));
    %opts and Carp::croak "unsupported option(s) given: ".join(", ", keys %opts);

    my $auth = shift;
    $cpt->{auth_method} ||= $auth;
    $cpt->{auth_args} ||= [@_];

    if ($auth eq 'auth_password') {
        my ($user, $passwd) = @_;
        push @args, user => $user, passwd => $passwd;
    }
    elsif ($auth eq 'auth_publickey') {
        my ($user, undef, $private) = @_;
        push @args, user => $user, key_path => $private;
    }
    elsif ($auth eq 'auth') {
        my %opts = @_;
        my $rank = delete $opts{rank};
        $rank = 'publickey,password' unless defined $rank;
        my $username = delete $opts{username};
        my $password = delete $opts{password};
        my $publickey = delete $opts{publickey};
        my $privatekey = delete $opts{privatekey};
        my $hostname = delete $opts{hostname};
        %opts and Carp::croak "unsupported option(s) given: ".join(", ", keys %opts);
        for my $method (split /\s*,\s*/, $rank) {
            $cpt->{state} = 'connected*';
            if ($method eq 'publickey') {
                if (defined $privatekey) {
                    $cpt->_connect(auth_publickey => $username, $publickey, $privatekey)
                }
            }
            elsif ($method eq 'password') {
                if (defined $password) {
                    $cpt->_connect(auth_password => $username, $password);
                }
            }
            $cpt->{state} eq 'ok' and return 1;
        }
        return;
    }
    else {
        Carp::croak "unsupported login method";
    }
    my $ssh = Net::OpenSSH->new(@args);
    if ($ssh->error) {
        $cpt->_set_error(LIBSSH2_ERROR_SOCKET_DISCONNECT => $ssh->error);
        $cpt->{state} = 'failed';
        return
    }
    else {
        $cpt->{ssh} = $ssh;
        $cpt->{state} = 'ok';
        return 1
    }

}

sub tcpip { Carp::croak "method tcpip not implemented" }
sub listen { Carp::croak "method listen not implemented" }
sub poll { Carp::croak "method poll not implemented" }

sub debug {}

sub blocking {
    my ($cpt, $blocking) = @_;
    if ($cpt->{blocking} xor $blocking) {
        $cpt->{blocking} = $blocking;
        $cpt->_free_channels;
        $_->_blocking($blocking) for @{$cpt->{channels}};
    }
    $blocking;
}

sub scp_get {
    my ($cpt, $remote, $local) = @_;
    unless (defined $local) {
        $local = File::Basename::basename($remote);
    }
    my $ssh = $cpt->{ssh};
    $ssh->scp_get($remote, $local);
    if ($ssh->error) {
        $cpt->_set_error(LIBSSH2_ERROR_SCP_PROTOCOL => "scp_get failed");
        return
    }
    1
}

sub scp_put {
    my ($cpt, $local, $remote) = @_;
    unless (defined $remote) {
        $remote = File::Basename::basename($local);
    }
    my $ssh = $cpt->{ssh};
    $ssh->scp_put($local, $remote);
    if ($ssh->error) {
        $cpt->_set_error(LIBSSH2_ERROR_SCP_PROTOCOL => "scp_get failed");
        return
    }
    1
}

sub channel {
    my $cpt = shift;
    my $class = join('::', ref($cpt), 'Channel');
    my $chan = $class->_new($cpt);
    push @{$cpt->{channels}}, $chan;
    $cpt->_free_channels;
    $chan;
}

sub sftp {
    my $cpt = shift;
    my $class = join('::', ref($cpt), 'SFTP');
    $class->_new($cpt);
}

package Net::OpenSSH::Compat::SSH2::Channel;
our @ISA = qw(IO::Handle Net::OpenSSH::Compat::SSH2::Base);

sub _new {
    my ($class, $cpt) = @_;
    my $chan = $class->SUPER::new;

    *$chan = { cpt => $cpt,
               state => 'new',
               error => [0, "", ""],
               blocking => 1 };
    return $chan;
}

sub _hash { *{shift @_}{HASH} }

sub ext_data { $_[0]->_hash->{ext_data} = $_[1] }

sub setenv {
    my $ch = shift->_hash;
    my $env = $ch->{env} ||= {};
    %$env = (%$env, @_);
    1;
}

sub _exec {
    my $chan = shift;
    $chan->_check_state('new') or return;
    my $defs = $DEFAULTS{channel};
    my %opts = ( ($defs     ? %$defs   : ()),
                 (ref $_[0] ? %{$_[0]} : ()),
                 stdinout_socket => 1 );
    my $ch = $chan->_hash;
    my $ssh = $ch->{cpt}{ssh};
    my $mode = $ch->{ext_data};
    $mode ||= 'normal';
    if ($mode eq 'ignore') {
        $opts{stderr_discard} = 1;
    }
    elsif ($mode eq 'merge') {
        $opts{stderr_to_stdout} = 1;
    }
    else {
        $opts{stderr_pipe} = 1;
    }
    local %ENV = (%ENV, %{$ch->{env}}) if $ch->{env};
    my ($io, undef, $err, $pid) = $ssh->open_ex(\%opts, @_);
    $chan->fdopen($io, 'r+');
    $chan->autoflush(1);
    binmode $chan;
    $ch->{err} = $err;
    $ch->{pid} = $pid;
    $ch->{state} = 'exec';
    $chan->_blocking($ch->{cpt}{blocking});
    return 1;
}

sub exec { shift->_exec(@_) }

sub shell { shift->_exec }

sub subsystem { shift->_exec({ssh_opts => ['-s']}, @_) }

sub send_eof {
    my $chan = shift;
    shutdown $chan, 1
}

sub close {
    my $chan = shift;
    $chan->_check_state('exec') or return;
    my $ch = $chan->_hash;
    $chan->SUPER::close;
    $ch->{err} and close($ch->{err});
    # warn "reaping $ch->{pid}";
    waitpid $ch->{pid}, 0;
    $ch->{exit_status} = ($? >> 8);
    $ch->{state} = 'closed';
    1;
}

sub DESTROY {
    my $chan = shift;
    my $ch = $chan->_hash;
    $chan->close if $ch->{state} eq 'exec';
    $chan->SUPER::DESTROY;
}

sub wait_closed {
    my $chan = shift;
    my $ch = $chan->_hash;
    shift->close if $ch->{state} eq 'exec';
    $ch->{state} eq 'closed';
}

sub exit_status {
    my $chan = shift;
    $chan->_check_state('closed') or return;
    $chan->_hash->{exit_status};
}

sub blocking { shift->_hash->{cpt}->blocking(@_) }

sub _blocking {
    my ($chan, $blocking) = @_;
    my $ch = $chan->_hash;
    if (($ch->{state} eq 'exec') and
        ($blocking xor $ch->{blocking})) {
        $ch->{blocking} = $blocking;
        $chan->SUPER::blocking($blocking);
        my $err = $chan->_hash->{err};
        $err->blocking($blocking) if $err;
    }
}

sub write {
    my ($chan, $data, $ext) = @_;
    $chan->_check_state('exec') or return;
    if ($ext) {
        # silently discard data sent to ext channel
        return length $data;
    }
    else {
        $chan->syswrite($data);
    }
}

sub read {
    my ($chan, undef, $size, $ext) = @_;
    $chan->_check_state('exec') or return;
    my $ch = $chan->_hash;
    my $fd;
    if ($ext) {
        $fd = $ch->{err} or
            $chan->_set_error(LIBSSH2_ERROR_CHANNEL_UNKNOWN => 'no ext channel available');
    }
    else {
        $fd = $chan;
    }
    sysread($fd, $_[1], $size || 0)
}

sub flush { 0 }

package Net::OpenSSH::Compat::SSH2::SFTP;

sub _new {
    my ($class, $cpt) = @_;
    my $defs = $DEFAULTS{sftp};
    my $sftp = $cpt->{ssh}->sftp($defs ? %$defs : ());
    my $sw = { cpt => $cpt,
               sftp => $sftp };
    bless $sw, $class;
}

sub error {
    my $sw = shift;
    my $status = $sw->{sftp}->status;
    wantarray ? ($status + 0, "$status") : $status + 0;
}

sub open {
    my ($sw, $file, $flags, $mode) = @_;
    my $sftp = $sw->{sftp};
    my $a = Net::SFTP::Foreign::Attributes->new();
    $a->set_perm(defined $mode ? $mode : 0666);
    my $fh = $sftp->open($file, $flags, $a);
    my $class = join('::', ref($sw->{cpt}), 'File');
    $class->_new($sw, $fh);
}

sub opendir {
    my ($sw, $dir) = @_;
    my $sftp = $sw->{sftp};
    my $dh = $sftp->opendir($dir);
    my $class = join('::', ref($sw->{cpt}), 'Dir');
    $class->_new($sw, $dh);
}

sub unlink {
    my ($sw, $file) = @_;
    my $sftp = $sw->{sftp};
    $sftp->unlink($file);
}

sub rename {
    my ($sw, $old, $new, $flags) = @_;
    my $sftp = $sw->{sftp};
    $sftp->rename($old, $new);
}

sub mkdir {
    my ($sw, $dir, $mode) = @_;
    my $sftp = $sw->{sftp};
    my $a = Net::SFTP::Foreign::Attributes->new;
    $a->set_perm(defined $mode ? $mode : 0777);
    $sftp->mkdir($dir, $a);
}

sub rmdir {
    my ($sw, $dir) = @_;
    my $sftp = $sw->{sftp};
    $sftp->rmdir($dir);
}

my $a2e = sub {
    my $a = shift;
    ( mode  => $a->perm,
      size  => $a->size,
      uid   => $a->uid,
      gid   => $a->gid,
      atime => $a->atime,
      mtime => $a->mtime );
};

my $e2a = sub {
    my %e = @_;
    my $a = Net::SFTP::Foreign::Attributes->new;
    $a->set_perm($e{mode}) if defined $e{mode};
    $a->set_size($e{size}) if defined $e{size};
    $a->set_ugid($e{uid}, $e{gid})
        if grep defined($e{$_}), qw(uid gid);
    $a->set_amtime($e{atime}, $e{mtime})
        if grep defined($e{$_}), qw(atime mtime);
    $a;
};

sub stat {
    my ($sw, $file) = @_;
    my $sftp = $sw->{sftp};
    my $a = $sftp->stat($file) or return;
    my %e = $a2e->($a);
    (wantarray ? %e : \%e);
}

sub setstat {
    my ($sw, $file, %opts) = @_;
    my $sftp = $sw->{sftp};
    my $a = $e2a->(%opts);
    $sftp->setstat($file, $a);
}

sub symlink {
    my ($sw, $path, $target, $type) = @_;
    my $sftp = $sw->{sftp};
    $sftp->symlink($path, $target);
}

sub readlink {
    my ($sw, $path) = @_;
    my $sftp = $sw->{sftp};
    $sftp->readlink($path);
}

sub realpath {
    my ($sw, $path) = @_;
    my $sftp = $sw->{sftp};
    $sftp->realpath($path);
}

package Net::OpenSSH::Compat::SSH2::Dir;

sub _new {
    my ($class, $sw, $dh) = @_;
    my $dw = { dh => $dh,
               sw => $sw };
    bless $dw, $class;
}

sub read {
    my $dw = shift;
    my $e = $dw->{sw}->readdir($dw->{dh}) or return;
    my %e = ( name => $e->{filename}, $a2e->($e->{a}) );
    wantarray ? %e : \%e;
}

package Net::OpenSSH::Compat::SSH2::File;
our @ISA = qw(IO::Handle IO::Seekable);

sub TIEHANDLE { return shift }

sub _new {
    my ($class, $sw, $fh) = @_;
    my $fw = $class->SUPER::new();
    *$fw = { sw => $sw,
             fh => $fh };
    tie *$fw, $fw;
    $fw;
}

our $AUTOLOAD;
sub AUTOLOAD {
    my $fw = shift;
    my $method = $AUTOLOAD;
    $method =~ s/.*:://;
    if ($method =~ /^[A-Z]+$/) {
        my $fh = *{$fw}{HASH}{fh};
        $fh->$method(@_);
    }
    else {
        $method = "SUPER::$method";
        $fw->$method(@_);
    }
}

sub stat {
    my $fw = shift;
    my $sftp = *{$fw}{HASH}{sw}{sftp};
    my $fh = *{$fw}{HASH}{fh};
    my $a = $sftp->fstat($fh) or return;
    my %e = $a2e->($a);
    wantarray ? %e : \%e;
}

sub setstat {
    my $fw = shift;
    my $sftp = *{$fw}{HASH}{sw}{sftp};
    my $fh = *{$fw}{HASH}{fh};
    my $a = $e2a->(@_);
    $sftp->fsetstat($fh, $a);
}

package Net::OpenSSH::Compat::SSH2::Base;

sub _entry_method {
    my $n = 1;
    my $last = 'unknown';
    while (1) {
        my $sub = (caller $n++)[3];
        $sub =~ /^Net::OpenSSH::Compat::SSH2::(?:\w+::)?(\w+)$/ or last;
        $last = $1;
    }
    $last;
}

sub _hash { shift }

sub _parent { undef }

sub error {
    my $self = shift->_hash;
    wantarray ? @{$self->{error}} : $self->{error}[0]
}

sub _set_error {
    my ($self, $error, $msg) = @_;
    my $n = eval $error;
    my $parent = $self->_parent;
    $parent->_set_error(@_) if $parent;
    @{$self->_hash->{error}} = ($n, $error, $msg);
}

sub _bad_state_error { 'LIBSSH2_ERROR_SOCKET_SEND' }

sub _check_state {
    my ($self, $expected) = @_;
    my $state = $self->_state;
    return 1 if $expected eq $state;
    my $method = $self->_entry_method;
    my $class = ref $self;
    $self->_set_error($self->_bad_state_error,
                      qq($class object can't do "$method" on state $state));
    return
}

sub _state { shift->_hash->{state} }

1;

=head1

Net::OpenSSH::Compat::SSH2 - Net::OpenSSH adapter for Net::SSH2 API compatibility

=head1 SYNOPSIS

  use Net::OpenSSH::Compat::SSH2 qw(:supplant);

  use Net::SSH2;

  my $ssh2 = Net::SSH2->new;
  $ssh2->connect('host');
  $ssh2->auth_publickey("jsmith",
                        "/home/jsmith/.ssh/id_dsa.pub",
                        "/home/jsmith/.ssh/id_dsa");
  my $c = $ssh2->channel;
  $c->exec("ls");
  print while <$c>;

  $c->close;
  print "exit status: ", $c->exit_status, "\n";

=head1 DESCRIPTION

This module implements L<Net::SSH2> API on top of L<Net::OpenSSH>.

After the module is loaded as...

  use Net::OpenSSH::Compat::SSH2 qw(:supplant);

it will supplant the Net::SSH2 module as if it was installed on the
machine and use L<Net::OpenSSH> under the hood to handle SSH
operations.

Most programs using L<Net::SSH2> should continue to work unaltered.

=head2 Setting defaults

Thye hash C<%Net::OpenSSH::Compat::SSH2::DEFAULTS> can be used to set
default values for L<Net::OpenSSH> and other modules called under the
hood otherwise not accesible through the Net::SSH2 API.

The currently supported entries are:

=over

=item connection => [ %opts ]

Extra options passed to C<Net::OpenSSH::new> constructor.

Example:

  $Net::OpenSSH::Compat::SSH2::DEFAULTS{connection} =
    [ ssh_path => "/opt/SSH/bin/ssh" ];

=item channel => [ %opts ]

Extra options passed to C<Net::OpenSSH::open_ex> method.

=item sftp => [ %opts ]

Extra options passed to C<Net::SFTP::Foreign::new> constructor.

  $Net::OpenSSH::Compat::SSH2::DEFAULTS{connection} =
    [ read_ahead => 128 * 1024, queue_size => 20 ];

=back

=head1 BUGS AND SUPPORT

B<This is a work in progress.>

Besides that, there are some functionality of Net::SSH2 that can not
be emulated with Net::SSH2. Fortunatelly, the missing bits are rarely
used so probably you may not need them at all.

Anyway, if your Net::SSH2 script fails, fill a bug report at the CPAN
RT bugtracker: L<https://rt.cpan.org/Ticket/Create.html?Queue=AI-FANN>
or just send me a mail with the details.

Include at least:

=over 4

=item 1 - The full source of the script

=item 2 - A description of what happens in your machine

=item 3 - What you thing it should be happening

=item 4 - What happens when you use the real Net::SSH2

=item 5 - The version and name of your operating system

=item 6 - The version of the OpenSSH ssh client installed on your machine (C<ssh -V>)

=item 7 - The Perl version (C<perl -V>)

=item 8 - The versions of the Perl packages Net::OpenSSH, IO::TTY and this Net::OpenSSH::Compat.

=back

=head2 My wishlist

If you like this module and you're feeling generous, take a look at my
Amazon Wish List: L<http://amzn.com/w/1WU1P6IR5QZ42>

Also consider contributing to the OpenSSH project this module builds
upon: L<http://www.openssh.org/donations.html>.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Salvador FandiE<ntilde>o (sfandino@yahoo.com)

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut