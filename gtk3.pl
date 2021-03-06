use Glib qw/TRUE FALSE/;
use Gtk2 '-init';
use strict;

# Our new improved callback.  The data passed to this function
# is printed to stdout.
sub callback
{
	my ($button, $data) = @_;

	print "Hello again - $data was pressed\n";

  if(ref($data) eq 'Gtk2::Window'){ $data->destroy; }
}

# another callback
sub delete_event
{
	Gtk2->main_quit;
	return FALSE;
}

# Create a new window
my $window = Gtk2::Window->new('toplevel');

# This is a new call, which just set the title for our
# new window to "Hello Buttons!"
$window->set_title("Hello Buttons!");

# Here we just set a handler for the delete_event that immediately
# exits GTK.
$window->signal_connect(delete_event => \&delete_event);

# Sets the border width of the window.
$window->set_border_width(10);
# window size
$window->set_size_request(300, 140);

# We create a box to pack widgets into.  This is described in detail
# in the "packing" section. The box is not really visible, it
# is just used as a tool to arrange widgets.
my $box1 = Gtk2::VBox->new(FALSE, 0);
my $box2 = Gtk2::HBox->new(FALSE, 10);
my $box3 = Gtk2::HBox->new(FALSE, 10);

# Put the box into the main window.
$window->add($box1);
$box1->pack_start($box2, TRUE, TRUE, 10);
$box1->pack_start($box3, TRUE, TRUE, 10);

# Creates a new button with the label "Button 1".
my $button = Gtk2::Button->new("Button 1");

# Now when the button is clicked, we call the "callback" function
# with the string "button 1" as its argument.
$button->signal_connect(clicked => \&callback, 'button 1');

# Instead of Gtk2::Container::add, we pack this button into the invisible
# box, which has been packed into the window.
$box2->pack_start($button, TRUE, TRUE, 0);

# Always remember this step, this tells GTK that our preparation for this
# button is complete, and it can now be displayed.
$button->show;

# Do the same steps again to create a second button.
$button = Gtk2::Button->new("Button 2");

# Call the same callback function with a different argument, passing the string
# "button 2" instead.
$button->signal_connect(clicked => \&callback, 'button 2');

$box2->pack_start($button, TRUE, TRUE, 0);

# The order in which we show the buttons is not really important, but I
# recommend showing the window last, so it all pops up at once.

$button->show;
# Do the same steps again to create a second button.
$button = Gtk2::Button->new("Quit");

# Call the same callback function with a different argument, passing the string
# "button 2" instead.
$button->signal_connect(clicked => \&callback, $window);

$box3->pack_start($button, TRUE, TRUE, 0);

# The order in which we show the buttons is not really important, but I
# recommend showing the window last, so it all pops up at once.

$button->show;

$box3->show;
$box2->show;
$box1->show;

$window->show;

# Rest in main and wait for the fun to begin!
Gtk2->main;

0;
