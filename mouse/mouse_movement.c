#include <ApplicationServices/ApplicationServices.h>
#include <unistd.h>
#include <stdio.h>

int main(int argc, char ** argv) {
	if (argc == 4) {
		int x = atoi(argv[1]), y = atoi(argv[2]);

		// Left button down at 250x250
		CGEventRef click1_down = CGEventCreateMouseEvent(
		    NULL, kCGEventLeftMouseDown,
		    CGPointMake(x, y),
		    kCGMouseButtonLeft
		);
		// Left button up at 250x250
		CGEventRef click1_up = CGEventCreateMouseEvent(
		    NULL, kCGEventLeftMouseUp,
		    CGPointMake(x, y),
		    kCGMouseButtonLeft
		);

		CGEventPost(kCGHIDEventTap, click1_down);
		sleep(1);
		CGEventPost(kCGHIDEventTap, click1_up);
		CFRelease(click1_down);
		CFRelease(click1_up);
	} else {
		int x = atoi(argv[1]), y = atoi(argv[2]);


		CGEventRef move1 = CGEventCreateMouseEvent(
		    NULL, kCGEventMouseMoved,
		    CGPointMake(x, y),
		    kCGMouseButtonLeft // ignored
		);

	    CGEventPost(kCGHIDEventTap, move1);
	    CFRelease(move1);
	}

    return 0;
}