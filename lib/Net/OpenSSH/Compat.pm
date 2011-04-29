package Net::OpenSSH::Compat;

our $VERSION = '0.01';

use strict;
use warnings;
use Carp;

my %impl = ('Net::SSH2' => 'SSH2');

sub import {
    my $class = shift;
    for my $mod (@_) {
        my $impl = $impl{$mod};
        defined $impl or croak "$mod compatibility is not available";
        my $adapter = __PACKAGE__ . "::$impl";
        eval "use $adapter ':supplant';";
        die if $@;
    }
    1;
}

1;
__END__

=head1 NAME

Net::OpenSSH::Compat - Compatibility modules for Net::OpenSSH

=head1 SYNOPSIS

  use Net::OpenSSH::Compat 'Net::SSH2';


=head1 DESCRIPTION

This package contains a set of adapter modules that run on top of
Net::OpenSSH providing the APIs of other SSH modules available from
CPAN.

Currently, there are an only adapter available for
L<Net::SSH2>. Adapters for L<Net::SSH> and L<Net::SSH::Perl> are
planned... maybe also for L<Net::SCP> and L<Net::SCP::Expect> if
somebody request then.

=head1 SEE ALSO

L<Net::OpenSSH>, L<Net::OpenSSH::Compat::SSH2>.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Salvador Fandino (sfandino@yahoo.com)

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.1 or,
at your option, any later version of Perl 5 you may have available.

=cut
