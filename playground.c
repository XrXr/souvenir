#include <X11/Xlib.h>
#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <dirent.h>
#include <unistd.h>

// Window myCreateWindow(
//     Display*        display,
//     Window      parent,
//     int         x,
//     int         y,
//     unsigned int    width,
//     unsigned int    height,
//     unsigned int    border_width,
//     int         depth,
//     unsigned int    class,
//     Visual*     visual,
//     unsigned long   valuemask,
//     XSetWindowAttributes*   attributes
// ) {
//     printf("display %p window %lu x %d y %d width %u height %d border_width %u depth %d class %u visual %p valuemask %lu attributes %p\n", display, parent, x, y, width, height, border_width, depth, class, visual, valuemask, attributes);
//     printf("attributes.event_mask %ld\n", attributes->event_mask);
//     printf("attributes.override_redirect %d\n", attributes->override_redirect);
//     Window w = XCreateWindow(display, parent, x, y, width, height, border_width, depth, class, visual, valuemask, attributes);
//     return w;
//     return 1;
// }

extern char **environ;

char **getEnviron() {
    return environ;
}
int main() {
    printf("sizeof(ssize_t)=%lu\n", sizeof(ssize_t));
    printf("%s\n", environ[0]);
    printf("ExposureMask | KeyPressMask | VisibilityChangeMask = %lu\n", ExposureMask | KeyPressMask | VisibilityChangeMask);
    printf("CWOverrideRedirect | CWBackPixel | CWEventMask = %lu\n", CWOverrideRedirect | CWBackPixel | CWEventMask);
    printf("CWOverrideRedirect | CWEventMask = %lu\n", CWOverrideRedirect | CWEventMask);
    printf("CopyFromParent = %lu\n", CopyFromParent);
    printf("DT_REG  = %d\n", DT_REG);
    printf("DT_LNK  = %d\n", DT_LNK);
    printf("sizeof(XSetWindowAttributes) = %lu\n", sizeof(XSetWindowAttributes));
    printf("offsetof(XSetWindowAttributes, override_redirect) = %lu\n", offsetof(XSetWindowAttributes, override_redirect));
    printf("offsetof(XSetWindowAttributes, event_mask) = %lu\n", offsetof(XSetWindowAttributes, event_mask));
    printf("sizeof(XWindowAttributes) = %lu\n", sizeof(XWindowAttributes));
    printf("R_OK | X_OK = %d\n", R_OK | X_OK);

	Display *d = XOpenDisplay(NULL);
	int s = DefaultScreen(d);
	XID rootWindow = RootWindow(d, s);

    XColor mycolor = {.pixel= 282828, .red = 0, .green = 85, .blue = 119};
    printf("mycolor.pixel before call to XAllocColor: %lu\n", mycolor.pixel);
    Status ret = XAllocColor(d, DefaultColormap(d, s), &mycolor);
    mycolor.red = 12;
    ret = XAllocColor(d, DefaultColormap(d, s), &mycolor);
    mycolor.red = 1282;
    ret = XAllocColor(d, DefaultColormap(d, s), &mycolor);
    printf("XAllocColor status %d\n", ret);
    printf("mycolor.pixel after call to XAllocColor: %lu\n", mycolor.pixel);

	XSetWindowAttributes swa;
	swa.override_redirect = 1;
	swa.event_mask = ExposureMask | KeyPressMask | VisibilityChangeMask;
    XCreateWindow(d, rootWindow, 100, 100, 500, 500, 0, CopyFromParent, CopyFromParent, CopyFromParent, 0, 0);

    int nextensions;
    char **extensions = XListExtensions(d, &nextensions);
    for (int i = 0; i < nextensions; i++) {
        printf("%s\n", extensions[i]);
    }
    XFreeExtensionList(extensions);
}
