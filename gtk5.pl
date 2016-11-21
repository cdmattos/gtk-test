use Glib qw/TRUE FALSE/;
use Gtk2 '-init';
use strict;


sub progress_timeout
{
	my $pbar = shift;
	if ($pbar->{activity_mode})
	{
		$pbar->pulse;
	}
	else
	{
		# Calculate the value of the progress bar using the
		# value range set in the adjustment object
		my $new_val = $pbar->get_fraction() + 0.01;

		$new_val = 0.0 if $new_val > 1.0;

		# Set the new value
		$pbar->set_fraction($new_val);
	}

	# As this is a timeout function, return TRUE so that it
	# continues to get called
	return TRUE;
}

# Remove the timer
sub destroy_progress
{
	my $window = shift;

	Glib::Source->remove($window->{pbar}->{timer});
	Gtk2->main_quit;
}

my $window = Gtk2::Window->new('toplevel');
$window->set_resizable(TRUE);
$window->signal_connect(destroy => \&destroy_progress);
$window->set_title("Gtk2::ProgressBar");
$window->set_border_width(0);

my $vbox = Gtk2::VBox->new(FALSE, 5);
$vbox->set_border_width(10);
$window->add($vbox);
$vbox->show;

# Create a centering alignment object;
my $align = Gtk2::Alignment->new(0.5, 0.5, 0, 0);
$vbox->pack_start($align, FALSE, FALSE, 5);
$align->show;

# Create the Gtk2::ProgressBar and attach it to the window reference.
my $pbar = Gtk2::ProgressBar->new;
$window->{pbar} = $pbar;
$align->add($pbar);
$pbar->show;

# Add a timer callback to update the value of the progress bar
$pbar->{timer} = Glib::Timeout->add(100, \&progress_timeout, $pbar);

my $separator = Gtk2::HSeparator->new;
$vbox->pack_start($separator, FALSE, FALSE, 0);
$separator->show;

# rows, columns, homogeneous
my $table = Gtk2::Table->new(2, 3, FALSE);
$vbox->pack_start($table, FALSE, TRUE, 0);
$table->show;

# Add a check button to select displaying of the trough text
my $check = Gtk2::CheckButton->new_with_label("Show Text");
$table->attach($check, 0, 1, 0, 1,
		['expand', 'fill'],
		['expand', 'fill'],
		5, 5);
$check->signal_connect(clicked => sub {
		my ($check, $progress) = @_;

		if ($progress->get_text)
		{
			$progress->set_text('');
		}
		else
		{
			$progress->set_text('some text');
		}
	}, $pbar);
$check->show;

# Add a check button to toggle activity mode
$pbar->{activity_mode} = 0;
$check = Gtk2::CheckButton->new_with_label("Activity Mode");
$table->attach($check, 0, 1, 1, 2,
		['expand', 'fill'],
		['expand', 'fill'],
		5, 5);
$check->signal_connect(clicked => sub {
		my ($check, $progress) = @_;

		$progress->{activity_mode} = not $progress->{activity_mode};
		if ($progress->{activity_mode})
		{
			$progress->pulse;
		}
		else
		{
			$progress->set_fraction(0.0);
		}
	}, $pbar);
$check->show;

# Add a check button to toggle orientation
$check = Gtk2::CheckButton->new_with_label("Right to Left");
$table->attach($check, 0, 1, 2, 3,
		['expand', 'fill'],
		['expand', 'fill'],
		5, 5);
$check->signal_connect(clicked => sub {
		my ($check, $progress) = @_;

		my $orientation = $progress->get_orientation;
		if    ('left-to-right' eq $orientation)
		{
			$progress->set_orientation('right-to-left');
		}
		elsif ('right-to-left' eq $orientation)
		{
			$progress->set_orientation('left-to-right');
		}
	}, $pbar);
$check->show;

# Add a button to exit the program.
my $button = Gtk2::Button->new("Close");
$button->signal_connect_swapped(clicked => sub { $_[0]->destroy; }, $window);
$vbox->pack_start($button, FALSE, FALSE, 0);

# This makes it so the button is the default.
$button->can_default(TRUE);

# This grabs this button to be the default button. Simply hitting the "Enter"
# key will cause this button to activate.
$button->grab_default;
$button->show;

$window->show;

Gtk2->main;

0;
