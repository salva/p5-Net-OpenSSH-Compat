package Net::OpenSSH::Compat::SSH2;

use strict;
use warnings;

use Net::OpenSSH;
use IO::Handle;
use IO::Seekable;
use File::Basename;

sub new {
    my $class = shift;
    my $cpt = {};
    bless $cpt, $class;
}

sub banner {}

sub version { "1.2.6-emulated" }

sub error { 0 }

sub sock { undef }

sub trace { }

my @_auth_list = qw(publickey password);
sub auth_list {
    wantarray ? @_auth_list : join(',', @_auth_list);
}

sub connect {
    my $cpt = shift;
    $cpt->{connect_args} = [@_];
}

sub auth_password {
    my $cpt = shift;
    $cpt->{auth_password_args} = [@_];
    $cpt->_connect;
}

sub auth_publickey {
    my $cpt = shift;
    $cpt->{auth_publickey_args} = [@_];
    $cpt->_connect;
}

sub auth_ok {
    my $cpt = shift;
    defined $cpt->{ssh};
}

sub _connect {
    my $cpt = shift;
    defined $cpt->{connect_args} or die "connect not called";
    my ($host, $port, %opts) = @{$cpt->{connect_args}};
    my @args = (host => $host, port => $port);
    if ($cpt->{auth_password_args}) {
        my ($user, $passwd) = @{$cpt->{auth_password_args}};
        push @args, user => $user, passwd => $passwd;
    }
    elsif ($cpt->{auth_publickey_args}) {
        my ($user, undef, $private) = @{$cpt->{auth_publickey_args}};
        push @args, user => $user, key_path => $private;
    }
    else {
        die "unsupported login method";
    }
    my $ssh = Net::OpenSSH->new(@args);
    $cpt->{ssh} = $ssh;
    1;
}

sub tcpip { die "method tcpip not implemented" }
sub listen { die "method listen not implemented" }
sub poll { die "method poll not implemented" }

sub debug {}

sub blocking { warn "blocking method not implemented" }

sub scp_get {
    my ($cpt, $remote, $local) = @_;
    unless (defined $local) {
        $local = basename $remote;
    }
    my $ssh = $cpt->{ssh};
    $ssh->scp_get($remote, $local);
}

sub scp_put {
    my ($cpt, $local, $remote) = @_;
    unless (defined $remote) {
        $remote = basename $local;
    }
    my $ssh = $cpt->{ssh};
    $ssh->scp_put($local, $remote);
}

sub channel {
    my $cpt = shift;
    my $class = join('::', ref($cpt), 'Channel');
    $class->_new($cpt);
}

sub sftp {
    my $cpt = shift;
    my $class = join('::', ref($cpt), 'SFTP');
    $class->_new($cpt);
}



package Net::OpenSSH::Compat::SSH2::Channel;
our @ISA = qw(IO::Handle);

sub _new {
    my ($class, $cpt) = @_;
    my $chan = $class->SUPER::new;
    *$chan = { cpt => $cpt };
    return $chan;
}

sub ext_data {
    my $ch = *{shift @_}{HASH};
    my $mode = shift;
    $ch->{ext_data} = $mode;
}

sub setenv {
    my $ch = *{shift @_}{HASH};
    my %env = @_;
    my $env = $ch->{env} ||= {};
    %$env = (%$env, @_);
}

sub _exec {
    my $chan = shift;
    my $ch = *{$chan}{HASH};
    my %opts = %{ref $_[0] ? shift : {}};
    $opts{stdinout_socket} = 1;
    my $ssh = $ch->{cpt}{ssh};
    my $mode = $ch->{ext_data};
    if (defined $mode) {
        if ($mode eq 'ignore') {
            $opts{stderr_discard} = 1;
        }
        elsif ($mode eq 'merge') {
            $opts{stderr_to_stdout} = 1;
        }
        elsif ($mode ne 'normal') {
            die "bad ext_data mode";
        }
    }
    local %ENV = (%ENV, %{$ch->{env}}) if $ch->{env};
    my ($io, undef, $err, $pid) = $ssh->open_ex(\%opts, @_);
    $chan->fdopen($io, 'r+');
    $ch->{err} = $err;
    $ch->{pid} = $pid;
    1;
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
    my $ch = *{$chan}{HASH};
    $chan->SUPER::close;
    $ch->{err} and close($ch->{err});
    waitpid $ch->{pid}, 0;
    $ch->{exit_status} = ($? >> 8);
    1;
}

sub wait_closed { shift->close }

sub exit_status {
    my $ch = *{shift @_}{HASH};
    $ch->{exit_status};
}

sub blocking {
    my $ch = *{shift @_}{HASH};
    $ch->{cpt}->blocking;
}


package Net::OpenSSH::Compat::SSH2::SFTP;

sub _new {
    my ($class, $cpt) = @_;
    my $sftp = $cpt->{ssh}->sftp;
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

1;

=head1

Net::OpenSSH::Compat::SSH2 - Net::SSH2 compatibility module for Net::OpenSSH

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

This is a work in progress.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Salvador FandiE<ntilde>o
(sfandino@yahoo.com)

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
