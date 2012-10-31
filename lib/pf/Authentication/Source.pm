=item

We must at least always have one rule defined, the fallback one.

=cut
package pf::Authentication::Source;
use Moose;

use pf::config qw($TRUE $FALSE);

has 'id' => (isa => 'Str', is => 'rw', required => 1);
has 'description' => (isa => 'Str', is => 'rw', required => 0);
has 'rules' => (isa => 'ArrayRef', is => 'rw', required => 0);

sub add_rule {
  my ($self, $rule) = @_;
  push(@{$self->{'rules'}}, $rule);
}

sub available_attributes {
  my $self = shift;
  return $self->common_attributes();
}

sub common_attributes {
  my $self = shift;
  return ["SSID"];
}

sub authenticate {
  my $self = shift;

  return 0;
}

=item

The first rule for which its conditions are matched wins, and stops everything.

Subclasses will implement this method.

params is a hash of things to match. "username" is a mandatory attribute, but it
might also contain the "SSID", etc..

Returns the actions of the first matched rule.

=cut
sub match {
  my ($self, $params) = @_;

  return [];
}

sub match_condition {
  my ($self, $condition, $params) = @_;
  
  my $r = 0;
  
  if (grep {$_ eq $condition->attribute } @{$self->common_attributes()}) {
    $r = $condition->matches($condition->attribute, $params->{$condition->attribute});
  }

  return $r;
}

=back

=head1 COPYRIGHT

Copyright (C) 2012 Inverse inc.

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
