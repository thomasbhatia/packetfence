package pf::SNMP::AlliedTelesis::AT8000GS;

=head1 NAME

pf::SNMP::AlliedTelesis::AT8000GS - Object oriented module to access SNMP enabled AT8000GS Switches

=head1 SYNOPSIS

The pf::SNMP::AlliedTelesis::AT8000GS module implements an object oriented interface
to access SNMP enabled AT8000GS switches.

=head1 STATUS

This module is currently only a placeholder, see pf::SNMP::AlliedTelesis

=over 

=item Supports

=over

=item 802.1X/Mac Authentication without VoIP

=back

=back

=head1 BUGS AND LIMITATIONS

The minimum required firmware version is 2.0.0.26.  However, you cannot do dynamic VLAN assignment
on ports with voice.

=head1 CONFIGURATION AND ENVIRONMENT

F<conf/switches.conf>

=cut

use strict;
use warnings;
use Log::Log4perl;
use Net::SNMP;
use base ('pf::SNMP::AlliedTelesis');

# importing switch constants
use pf::SNMP::constants;
use pf::util;
use pf::config;

=head1 SUBROUTINES

=over

=cut

=back

=head1 AUTHOR

Francois Gaudreault <fgaudreault@inverse.ca>

=head1 COPYRIGHT

Copyright (C) 2012 Inverse Inc.

=head1 LICENSE

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
USA.

=cut

1;

# vim: set shiftwidth=4:
# vim: set expandtab:
# vim: set backspace=indent,eol,start: