// $GOPATH/bin/alang -c -libc souvenir.al; and gcc -g a.o -lX11; ./a.out

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

struct XKeyEvent {
	type s32
	serial u64
	send_event s32
	display *XDisplay
	window u64
	root u64
	subwindow u64
	time u64
	x s32
	y s32
	x_root s32
	y_root s32
	state u32
	keycode u32
	same_screen s32
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

XClearWindow :: foreign proc (display *XDisplay, window u64) -> s32

XLookupString :: foreign proc (event_struct *XKeyEvent, buffer_return *u8, bytes_buffer s32, keysym_return *void, status_in_out *void) -> s32

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
posix_spawn :: foreign proc (pid *void, path *u8, file_actions *void, attrp *void, argv **u8, envp **u8) -> s32

getEnviron :: foreign proc () -> **u8

struct executable {
	parentDirectory string
	fileName string
}

struct souvenir {
	display *XDisplay
	window u64
	normalTextGc *void
	exeCount int
	exeList *[5000]executable
	selectedPath *[5000]u8
	selected int
	filter string
	maxFilterLength int
}

main :: proc () {
	var d *XDisplay
	var w u64

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


  	var filterBuffer [5000]u8
  	var selectedPathBuffer [5000]u8
	var app souvenir
	app.display = d
	app.window = w
	app.exeList = &executableList
	app.exeCount = exeCount
	app.normalTextGc = gc
	app.filter = string(&filterBuffer)
	app.maxFilterLength = 5000 - 8
	app.selectedPath = &selectedPathBuffer

	app.filter.length = 3
	@(app.filter.data) = 97
	@(app.filter.data + 1) = 100
	@(app.filter.data + 2) = 100

	mainLoop(&app)

	free(pathBuffer)
	free(exeFileNames)
	XCloseDisplay(d)
}

mainLoop :: proc (app *souvenir) {
	var e XEvent
  	Expose := 12
  	KeyPress := 2
  	for true {
		XNextEvent(app.display, &e)
		if e.type == Expose {
			draw(app)
		}
		if e.type == KeyPress {
			var keyEvent *XKeyEvent
			var castHack *void
			castHack = &e
			keyEvent = castHack

			if keyEvent.keycode == 111 {
				app.selected -= 1
				draw(app)
			}
			if keyEvent.keycode == 116 {
				app.selected += 1
				draw(app)
			}
			if keyEvent.keycode == 9 {
				break
			}
			if keyEvent.keycode == 22 {
				if app.filter.length > 0 {
					app.filter.length -= 1
					app.selected = 0
					draw(app)
				}
			}
			// enter
			if keyEvent.keycode == 36 {
				var argv [2]*u8
				argv[0] = app.selectedPath
				argv[1] = nil
				env := environ()

				posix_spawn(nil, app.selectedPath, nil, nil, &argv, env)
				puts("have a nice trip!\n")
				break
			}
			var keysym u8
			diff := XLookupString(keyEvent, &keysym, 1, nil, nil)
			if diff > 0 && keysym >= 32 && keysym <= 126 && app.filter.length < app.maxFilterLength {
				@(app.filter.data + app.filter.length) = keysym
				app.filter.length += diff
				app.selected = 0
				draw(app)
			}
		}
  	}
}

draw :: proc (app *souvenir) {
	stringBufferSize := 5000
	var stringBuffer [5000]u8
	var stringBufferPointer *u8
	stringBufferPointer = &stringBuffer

	XClearWindow(app.display, app.window)
	y := 70
	x := 50
	XDrawString(app.display, app.window, app.normalTextGc, x, 20, app.filter.data, app.filter.length)
	entryNumber := 0
	for i := 0..app.exeCount-1 {
		exe := app.exeList[i]
		if app.filter.length > 0 {
			match := false
			for i := 0..exe.fileName.length-app.filter.length {
				same := true
				for j := 0..app.filter.length-1 {
					if @(app.filter.data + j) != @(exe.fileName.data + i + j) {
						same = false
					}
				}
				if same {
					match = true
					break
				}
			}
			if !match {
				continue
			}
		}
		if exe.parentDirectory.length + exe.fileName.length > stringBufferSize {
			die("path too large")
		}
		memcpy(stringBufferPointer, exe.fileName.data, exe.fileName.length)
		XDrawString(app.display, app.window, app.normalTextGc, x, y, stringBufferPointer, exe.fileName.length)

		if entryNumber == app.selected {
			memcpy(stringBufferPointer, exe.parentDirectory.data, exe.parentDirectory.length)
			// 47 is '/'
			@(stringBufferPointer + exe.parentDirectory.length) = 47
			memcpy(stringBufferPointer + exe.parentDirectory.length + 1, exe.fileName.data, exe.fileName.length)
			totalLength := exe.parentDirectory.length + exe.fileName.length + 1
			XDrawString(app.display, app.window, app.normalTextGc, 200, y, stringBufferPointer, totalLength)
			memcpy(app.selectedPath, stringBufferPointer, totalLength)
			app.selectedPath[totalLength] = 0
		}
		entryNumber += 1
		y += 30
		if y >= 500 {
			break
		}
	}
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