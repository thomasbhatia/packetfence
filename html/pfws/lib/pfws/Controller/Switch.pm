package pfws::Controller::Switch;
use Moose;
use namespace::autoclean;
use JSON;

BEGIN {extends 'Catalyst::Controller::HTML::FormFu'; }

=head1 NAME

pfws::Controller::Switch - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->visit('get', ['all'], ['get']);
}

=head2 object

Chained dispatch for a switch.

=cut

sub object :Chained('/') :PathPart('switch') :CaptureArgs(1) {
  my ($self, $c, $section) = @_;

  unless ($c->model('Switch')->sectionExists($section)) {
    $c->res->status(404);
    $c->stash->{result} = "Unknown switch $section";
    $c->detach();
  }
  
  $c->stash->{section} = $section;
}

=head2 get

/switch/<section>/get

=cut

sub get :Chained('object') :PathPart('get') :Args(0) {
  my ($self, $c) = @_;
  my $section = $c->stash->{section};

  my $result;
  eval {
    $result = $c->model('Switch')->get($section);
  };
  if ($@) {
    chomp $@;
    $c->res->status(500);
    $c->stash->{result} = $@;
  }
  else {
    $c->res->status(200);
    $c->stash->{switches} = $result;
  }
}

=head2 delete

/switch/<ip>/delete

=cut

sub delete :Chained('object') :PathPart('delete') :Args(0) {
  my ($self, $c) = @_;
  my $section = $c->stash->{section};

  my $result;
  eval {
    $result = $c->model('Switch')->remove($section);
  };
  if ($@) {
    chomp $@;
    $c->res->status(500);
    $c->stash->{result} = $@;
  }
  else {
    $c->res->status(200);
    $c->stash->{result} = $result;
  }
}

=head2 edit

/switch/<ip>/edit

=cut

sub edit :Chained('object') :PathPart('edit') :Args(0) {
  my ($self, $c) = @_;
  my $section = $c->stash->{section};

  my $assignments = $c->request->params->{assignments};

  if ($assignments) {
    my $result;
    eval {
      $assignments = decode_json($assignments);
    };
    if ($@) {
      # Malformed JSON
      chomp $@;
      $c->res->status(400);
      $c->stash->{result} = $@;
    }
    else {
      eval { $result = $c->model('Switch')->edit($section, $assignments); };
      if ($@) {
        chomp $@;
        $c->res->status(500);
        $c->stash->{result} = $@;
      }
      else {
        $c->res->status(201);
        $c->stash->{result} = $result;
      }
    }
  }
  else {
    $c->res->status(400);
    $c->stash->{result} = 'Missing parameters';
  }
}

=head2 add

/switch/add/<ip>
/switch/add?section=<ip>

=cut

sub add :Local :FormConfig {
  my ($self, $c, $section) = @_;

  $section = $c->request->params->{section} unless ($section);
  my $assignments = $c->request->params->{assignments};

  my $result;
  eval {
    $assignments = decode_json($assignments);
  };
  if ($@) {
    # Malformed JSON
    chomp $@;
    $c->res->status(400);
    $c->stash->{result} = $@;
  }
  else {
    eval { $result = $c->model('Switch')->add($section, $assignments); };
    if ($@) {
      chomp $@;
      $c->res->status(500);
      $c->stash->{result} = $@;
    }
    else {
      $c->res->status(201);
      $c->stash->{result} = $result;
    }
  }
}

sub add_FORM_NOT_VALID {
  my ($self, $c) = @_;

  my $form = $c->stash->{form};
  my $exceptions = $form->get_errors({stage => 'constraint'});
  my %errors = ();
  foreach my $ex (@{$exceptions}) {
    $errors{$ex->name} = $ex->message; #$ex->constraint->message;
  }
  $c->stash->{errors} = \%errors;
  $c->res->status(400);
  $c->stash->{template} = $c->namespace.'/add.tt';
  $c->forward('View::HTML');
}

sub add_FORM_NOT_SUBMITTED {
  my ($self, $c) = @_;

  $c->stash->{template} = $c->namespace.'/add.tt';
  $c->forward('View::HTML');
}

=head1 AUTHOR

root

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
