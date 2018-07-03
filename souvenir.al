// $GOPATH/bin/alang -c -libc souvenir.al; and gcc -g -no-pie a.o -lX11; ./a.out

struct XDisplay {
	ext_data *void
	private1 *void
	fd s32
	private2 s32
	proto_major_version s32
	proto_minor_version s32
	vendor *u8
	private3 u64
	private4 u64
	private5 u64
	private6 s32
	resource_alloc *void
	byte_order s32
	bitmap_unit s32
	bitmap_pad s32
	bitmap_bit_order s32
	nformats s32
	pixmap_format *void
	private8 s32
	release s32
	private9 *void
	private10 *void
	qlen s32
	last_request_read u64
	request u64
	private11 *u8
	private12 *u8
	private13 *u8
	private14 *u8
	max_request_size u32
	db *void
	private15 *void
	display_name *u8
	default_screen s32
	nscreens s32
	screens *Screen
	motion_buffer u64
	private16 u64
	min_keycode s32
	max_keycode s32
	private17 *u8
	private18 *u8
	private19 s32
	xdefaults *u8

}

struct Screen {
	ext_data *void
	display *XDisplay
	root u64
	width s32
	height s32
	mwidth s32
	mheight s32
    ndepths s32
	depths *void
	root_depth s32
	root_visual *void
	default_gc *void
	cmap u64
	white_pixel u64
	black_pixel u64
	max_maps s32
	min_maps s32
	backing_store s32
	save_unders s32
	root_input_mask s64
}

struct XEvent {
	type s32
	fill [188]u8
}

struct Visual {
	ext_data *void
	visualid u64
	class int
	red_mask u64
	green_mask u64
	blue_mask u64
	bits_per_rgb s32
	map_entires s32
}

struct XSetWindowAttributes {
	background_pixmap u64
	background_pixel u64
	border_pixmap u64
	border_pixel u64
	bit_gravity s32
	win_gravity s32
	backing_store s32
	backing_planes u64
	backing_pixel u64
	save_under s32
	event_mask s64
	do_not_propagate_mask s64
	override_redirect s32
	colormap u64
	cursor u64
}

struct XColor {
	pixel u64
	red u16
	green u16
	blue u16
	flags u8
	pad u8
}

XOpenDisplay :: foreign proc (name *u8) -> *XDisplay

XCreateSimpleWindow :: foreign proc (display *XDisplay, window u64, x s32, y s32, width u32, height u32, border_width u32, border u64, background u64) -> u64

XCreateWindow :: foreign proc (display *XDisplay, window u64, x s32, y s32, width u32, height u32, border_width u32, depth s32, class u32, visual *Visual, valuemask u64, attributes *XSetWindowAttributes) -> u64

myCreateWindow :: foreign proc (display *XDisplay, window u64, x s32, y s32, width u32, height u32, border_width u32, depth s32, class u32, visual *Visual, valuemask u64, attributes *XSetWindowAttributes) -> u64

XMapWindow :: foreign proc (display *XDisplay, w u64) -> s32

XNextEvent :: foreign proc (display *XDisplay, event *XEvent) -> s32

XFillRectangle :: foreign proc (display *XDisplay, d u64, gc *void, x s32, y s32, width u32, height u32) -> s32

XDrawString :: foreign proc (display *XDisplay, d u64, gc *void, x s32, y s32, str *u8, length s32) -> s32

XSelectInput :: foreign proc (display *XDisplay, w u64, event_mask s64) -> int

XCloseDisplay :: foreign proc (display *XDisplay) -> s32

XSetInputFocus :: foreign proc (display *XDisplay, window u64, revert_to s32, time u64) -> s32

XAllocColor :: foreign proc (display *XDisplay, colormap u64, screen_in_out *XColor) -> s32

struct dirent {
	d_ino u64
	d_off s64
	d_reclen u16
	d_type u8
	d_name [256]u8
}


opendir :: foreign proc (name *u8) -> *void
closedir :: foreign proc (dir *void) -> s32
readdir :: foreign proc (dirp *void) -> *dirent
strlen :: foreign proc (str *u8) -> u64
getenv :: foreign proc (name *u8) -> *u8
memcpy :: foreign proc (dest *void, source *void, num u64) -> *u8
malloc :: foreign proc (size u64) -> *void
perror :: foreign proc (s *u8)
free :: foreign proc (buffer *void)

struct executable {
	parentDirectory string
	fileName string
}

main :: proc () {
	var d *XDisplay
	var w u64
	var e XEvent
	msg := "he's done it"

	pathEnv := getenv("PATH".data)
	if !pathEnv {
		die("environmental variable PATH not set")
	}

	var paths [100]string
	pathCount := 0
	pathBufferSize := 1000
	pathBuffer := malloc(pathBufferSize)
	var pathBufferChar *u8
	pathBufferChar = pathBuffer
	pathBufferOffset := 0
	var i int
	start := 0
	writes(pathEnv, strlen(pathEnv))
	puts("\n")
	for true {
		thisChar := @(pathEnv+i)
		// 58 == ':'
		if (thisChar == 58 || thisChar == 0) && i - start > 0 {
			len := i - start
			if pathBufferOffset + 8 + len + 1 >= pathBufferSize {
				break
			}
			newString := pathBufferChar + pathBufferOffset
			newStringSize := makeString(newString, pathEnv + start, len)
			@(newString + newStringSize) = 0
			pathBufferOffset += newStringSize + 1

			paths[pathCount] = string(newString)
			pathCount += 1
			// TODO paths.length
			if pathCount >= 100 {
				break
			}
			if thisChar == 0 {
				break
			}
			start = i + 1
		}
		i += 1
	}
	exeBufferSize := 5000
	var executableList [5000]executable
	// TODO hack before we can do executableList[3].something = 100
	var exeListPtr *executable
	exeListPtr = &executableList
	exeCount := 0
	exeFileNamesBufferSize := 5000 * 256
	var exeFileNames *u8
	exeFileNames = malloc(exeFileNamesBufferSize)
	exeFileNamesOffset := 0
	for i := 0..pathCount-1 {
		dirPath := paths[i]
		dir := opendir(dirPath.data)
		if !dir {
			perror("could not open dir".data)
			continue
		}
		for true {
			entry := readdir(dir)
			if !entry {
				break
			}
			DT_REG := 8
			DT_LNK := 10
			if entry.d_type == DT_REG || entry.d_type == DT_LNK {
				fileName := entry.d_name
				fileNamePtr := &fileName
				fileNameLen := strlen(fileNamePtr)
				if exeFileNamesOffset + fileNameLen >= exeFileNamesBufferSize {
					break
				}
				newString := exeFileNames + exeFileNamesOffset
				stringSize := makeString(newString, fileNamePtr, fileNameLen)
				exeFileNamesOffset += stringSize

				(exeListPtr+exeCount).parentDirectory = dirPath
				(exeListPtr+exeCount).fileName = string(newString)
				exeCount += 1
				if exeCount >= exeBufferSize {
					break
				}
			}
		}
		closedir(dir)
	}

	for i := 1..exeCount-1 {
		exe := executableList[i]
		puts(exe.parentDirectory)
		puts("/")
		puts(exe.fileName)
		puts("\n")
	}

	free(pathBuffer)
	free(exeFileNames)

	var s s32

  	d = XOpenDisplay(nil)
  	if !d {
  		die("Can't open display")
  	}

  	s = d.default_screen
  	screen := d.screens + s
  	rootWindow := screen.root

  	gc := screen.default_gc
  	defaultColorMap := screen.cmap

  	var backgroundColor XColor
  	backgroundColor.red = 0
  	backgroundColor.green = 21845
  	backgroundColor.blue = 30583
  	rc := XAllocColor(d, defaultColorMap, &backgroundColor)
  	if rc == 0 {
  		die("Can't allocate color")
  	}

  	var swa XSetWindowAttributes
  	CopyFromParent := 0
  	swa.override_redirect = 1
  	swa.background_pixel = backgroundColor.pixel
  	// ExposureMask | KeyPressMask | VisibilityChangeMask
  	swa.event_mask = 98305
  	// CWOverrideRedirect | CWBackPixel | CWEventMask
  	value_mask := 2562
    w = XCreateWindow(d, rootWindow, 100, 100, 500, 500, 0, CopyFromParent, CopyFromParent, nil, value_mask, &swa)
    XSelectInput(d, w, 32769)
  	XMapWindow(d, w)

  	RevertToParent := 2
  	CurrentTime := 0
  	XSetInputFocus(d, w, RevertToParent, CurrentTime)

  	Expose := 12
  	KeyPress := 2
  	for true {
		XNextEvent(d, &e)
		if e.type == Expose {
        	XFillRectangle(d, w, gc, 20, 20, 10, 10)
        	XDrawString(d, w, gc, 100, 50, msg.data, msg.length)
		}
		if e.type == KeyPress {
			break
		}
  	}

   XCloseDisplay(d)
}


makeString :: proc (dest *void, data *u8, length int) -> int {
//	print_int(int(dest))
	var lenPtr *int
	var destChar *u8
	lenPtr = dest
	destChar = dest

	@lenPtr = length
	memcpy(destChar + 8, data, length)
//	puts(string(dest))
//	puts("\n")
	return 8 + length
}

die :: proc (info string) {
	puts(info)
	puts("\n")
	exit(1)
}