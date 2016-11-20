# Use the TRUE and FALSE constants exported by the Glib module.
use Glib qw/TRUE FALSE/;
use Gtk2 '-init';
use strict;

sub hello
{
	my ($widget, $window) = @_;
	print "Hello, World\n";

	$window->destroy;
}

sub delete_event
{
	# If you return FALSE in the "delete_event" signal handler,
	# GTK will emit the "destroy" signal. Returning TRUE means
	# you don't want the window to be destroyed.
	# This is useful for popping up 'are you sure you want to quit?'
	# type dialogs.
	print "delete event occurred\n";

	# Change TRUE to FALSE and the main window will be destroyed with
	# a "delete_event".
	return TRUE;
}

my $window = Gtk2::Window->new('toplevel');

$window->signal_connect(delete_event => \&delete_event);
$window->signal_connect(destroy => sub { Gtk2->main_quit; });

# Sets the border width of the window.
$window->set_border_width(10);
$window->set_size_request(300, 300);

# Creates a new button with a label "Hello World".
my $button = Gtk2::Button->new("Hello World");

# When the button receives the "clicked" signal, it will call the function
# hello() with the window reference passed to it.The hello() function is
# defined above.
$button->signal_connect(clicked => \&hello, $window);

# This packs the button into the window (a gtk container).
$window->add($button);

# The final step is to display this newly created widget.
$button->show;

$window->show;

Gtk2->main;

0;
