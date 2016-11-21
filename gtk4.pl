use Glib qw/TRUE FALSE/;
use Gtk2 '-init';
use strict;

# Our callback.
# The data passed to this function is printed to stdout
sub callback
{
	my ($widget, $data) = @_;
	print "Hello again - $data was pressed\n";
}

# This callback quits the program
sub delete_event
{
	Gtk2->main_quit;
	return FALSE;
}

# Create a new window
my $window = Gtk2::Window->new('toplevel');

# Set the window title
$window->set_title("Table");

# Set a handler for delete_event that immediately exits GTK.
$window->signal_connect(delete_event => \&delete_event);

# Sets the border width of the window.
$window->set_border_width(20);

# Create a 2x2 table
my $table = Gtk2::Table->new(2, 2, TRUE);

# Put the table in the main window
$window->add($table);

# Create first button
my $button = Gtk2::Button->new("button 1");

# When the button is clicked, we call the "callback" function
# with the string "button 1" as its argument
$button->signal_connect(clicked => \&callback, 'button 1');

# Insert button 1 into the upper left quadrant of the table
$table->attach_defaults($button, 0, 1, 0, 1);

$button->show;

# Create second button
my $image = Gtk2::Image->new_from_file("test.png");

# Insert button 2 into the upper right quadrant of the table
$table->attach_defaults($image, 1, 2, 0, 1);

$image->show;

# Create "Quit" button
$button = Gtk2::Button->new("Quit");

# When the button is clicked, we call the "delete_event" function
# and the program exits
$button->signal_connect(clicked => \&delete_event);

# Insert the quit button into the both lower quadrants of the table
$table->attach_defaults($button, 0, 2, 1, 2);

$button->show;

$table->show;
$window->show;

Gtk2->main;

0;
