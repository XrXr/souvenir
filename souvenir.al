// eval $GOPATH/bin/alang -c -libc souvenir.al; and gcc -g a.o -lX11 -lXft; and ./a.out

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

struct XWindowAttributes {
    x s32
    y s32
    width s32
    height s32
    pad [120]u8
}

struct XColor {
    pixel u64
    red u16
    green u16
    blue u16
    flags u8
    pad u8
}

struct XRenderColor {
    red u16
    green u16
    blue u16
    alph u16
}

struct XftColor {
    pixel u64
    color XRenderColor
}

struct XGlyphInfo {
    width u16
    height u16
    x s16
    y s16
    xOff s16
    yOff s16
}

struct XftFont{
    ascent s32
    descent s32
    height s32
}

struct XftDraw {
}

XOpenDisplay :: foreign proc (name *u8) -> *XDisplay

XCreateWindow :: foreign proc (display *XDisplay, window u64, x s32, y s32, width u32, height u32, border_width u32, depth s32, class u32, visual *Visual, valuemask u64, attributes *XSetWindowAttributes) -> u64

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

XGetWindowAttributes :: foreign proc (display *XDisplay, window u64, window_attributes_return *XWindowAttributes) -> s32

XftColorAllocName :: foreign proc (display *XDisplay, visual *Visual, cmap u64, colorName *u8, result *XftColor) -> s32

XftFontOpenName :: foreign proc (display *XDisplay, screen s32, name *u8) -> *XftFont

XftDrawCreate :: foreign proc (display *XDisplay, drawable u64, visual *Visual, colormap u64) -> *XftDraw

XftTextExtentsUtf8 :: foreign proc (display *XDisplay, pub *XftFont, string *u8, len s32, extents *XGlyphInfo)

XftDrawStringUtf8 :: foreign proc (draw  *XftDraw, color *XftColor, pub *XftFont, x s32, y s32, string *u8, len s32)

XftDrawRect :: foreign proc (d *XftDraw, color *XftColor, x s32, y s32, width u32, height u32)

XGrabKeyboard :: foreign proc (display *XDisplay, grab_window u64, owner_events s32, pointer_mode s32, keyboard_mode s32, time u64) -> s32

access :: foreign proc (path *u8, mod s32) -> s32


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
usleep :: foreign proc (usec u32) -> s32

getEnviron :: foreign proc () -> **u8

struct executable {
    dirPath string
    fileName string
}

struct souvenir {
    display *XDisplay
    window u64
    windowWidth int
    normalTextGc *void
    exeCount int
    exeList *[5000]executable
    selectedPath *[5000]u8
    filteredExeList *[50]*executable
    nFilteredExeList int
    selected int
    filter string
    maxFilterLength int
    xftWindowDraw *XftDraw
    font *XftFont
    selectionColor XftColor
    textColor XftColor
    filterInputWidth int
    widthOfThreeDots int
    leftPadding int
    interItemPadding int
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
    for {
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
        for {
            entry := readdir(dir)
            if !entry {
                break
            }
            DT_REG := 8
            DT_LNK := 10
            if entry.d_type == DT_REG || entry.d_type == DT_LNK {
                fileName := &entry.d_name
                fileNameLen := strlen(fileName)
                if exeFileNamesOffset + fileNameLen >= exeFileNamesBufferSize {
                    break
                }
                newString := exeFileNames + exeFileNamesOffset
                stringSize := makeString(newString, fileName, fileNameLen)
                exeFileNamesOffset += stringSize

                (exeListPtr+exeCount).dirPath = dirPath
                (exeListPtr+exeCount).fileName = string(newString)

                exeCount += 1
                if exeCount >= exeBufferSize {
                    break
                }
            }
        }
        closedir(dir)
    }

    var app souvenir

    d = XOpenDisplay(nil)
    if !d {
        die("Can't open display")
    }

    s := d.default_screen
    screen := d.screens + s
    rootWindow := screen.root

    gc := screen.default_gc
    defaultColorMap := screen.cmap

    var rootWindowAttr XWindowAttributes
    if XGetWindowAttributes(d, rootWindow, &rootWindowAttr) == 0 {
        die("Fail to get width of the root window")
    }
    app.windowWidth = rootWindowAttr.width

    var xftColor XftColor

    if XftColorAllocName(d, screen.root_visual, screen.cmap, "#005577".data, &xftColor) == 0 {
        die("Can't allocate selection color")
    }
    app.selectionColor = xftColor


    if XftColorAllocName(d, screen.root_visual, screen.cmap, "#bbbbbb".data, &xftColor) == 0 {
        die("Can't allocate text color")
    }
    app.textColor = xftColor

    if XftColorAllocName(d, screen.root_visual, screen.cmap, "#222222".data, &xftColor) == 0 {
        die("Can't allocate background color")
    }
    backgroundPixel := xftColor.pixel

    app.font = XftFontOpenName(d, s, "monospace-12".data)
    if !app.font {
        die("Can't open font")
    }

    var swa XSetWindowAttributes
    CopyFromParent := 0
    swa.override_redirect = 1
    swa.background_pixel = backgroundPixel
    // ExposureMask | KeyPressMask | VisibilityChangeMask
    swa.event_mask = 98305
    // CWOverrideRedirect | CWBackPixel | CWEventMask
    value_mask := 2562
    w = XCreateWindow(d, rootWindow, 0, 100, rootWindowAttr.width, app.font.height, 0, CopyFromParent, CopyFromParent, nil, value_mask, &swa)
    XSelectInput(d, w, 32769)
    XMapWindow(d, w)

    app.xftWindowDraw = XftDrawCreate(d, w, screen.root_visual, screen.cmap)
    if !app.xftWindowDraw {
        die("can't make XftDraw for the window")
    }

    if !grabKeyboard(d, w) {
        die("can't grab keyboard")
    }

    var filterBuffer [5000]u8
    var selectedPathBuffer [5000]u8
    var filteredExeList [50]*executable
    app.display = d
    app.window = w
    app.exeList = &executableList
    app.exeCount = exeCount
    app.normalTextGc = gc
    app.filter = string(&filterBuffer)
    app.maxFilterLength = 5000 - 8
    app.selectedPath = &selectedPathBuffer
    app.filter.length = 0
    app.filteredExeList = &filteredExeList
    app.widthOfThreeDots = stringWidth(&app, "...")
    app.leftPadding = 5
    app.interItemPadding = 20
    // arbitary
    app.filterInputWidth = stringWidth(&app, "M") * 15

    filter(&app)
    mainLoop(&app)

    free(pathBuffer)
    free(exeFileNames)
    XCloseDisplay(d)
}

mainLoop :: proc (app *souvenir) {
    var e XEvent
    Expose := 12
    KeyPress := 2
    for {
        XNextEvent(app.display, &e)
        if e.type == Expose {
            draw(app)
        }
        if e.type == KeyPress {
            var keyEvent *XKeyEvent
            var castHack *void
            castHack = &e
            keyEvent = castHack
            // left arrow
            if keyEvent.keycode == 113 {
                if app.selected > 0 {
                    app.selected -= 1
                }
                draw(app)
            }
            // right arrow
            if keyEvent.keycode == 114 {
                if app.selected < app.nFilteredExeList - 1 {
                    app.selected += 1
                }
                draw(app)
            }
            // esc
            if keyEvent.keycode == 9 {
                break
            }
            // backspace
            if keyEvent.keycode == 22 {
                if app.filter.length > 0 {
                    app.filter.length -= 1
                    app.selected = 0
                    filter(app)
                    draw(app)
                }
            }
            // enter
            if keyEvent.keycode == 36 {
                if app.nFilteredExeList > 0 {
                    launch(app.filteredExeList[app.selected])
                    return
                }
            }
            var keysym u8
            diff := XLookupString(keyEvent, &keysym, 1, nil, nil)
            // check for whether the character is printable
            if diff > 0 && keysym >= 32 && keysym <= 126 && app.filter.length < app.maxFilterLength {
                @(app.filter.data + app.filter.length) = keysym
                app.filter.length += diff
                app.selected = 0
                filter(app)
                draw(app)
            }
        }
    }
}

swap :: proc (a **executable, b **executable) {
    temp := @a
    @a = @b
    @b = temp
}

partition :: proc (arr *[50]*executable, startIdx int, endIdx int) -> int {
    length := endIdx - startIdx
    // TODO: pick pivot randomly
    pivotIdx := startIdx
    pivot := arr[pivotIdx]
    swap(&arr[endIdx-1], &arr[pivotIdx])
    lesserCount := 0
    greaterCount := 0
    done := false
    for lesserCount + greaterCount + 1 != length {
        // compiler bug: arr[startIdx+lesserCount].fileName.length doesn't work
        for (@(arr[startIdx+lesserCount])).fileName.length > pivot.fileName.length {
            nextGreaterIdx := endIdx - 2 - greaterCount
            swap(&arr[nextGreaterIdx], &arr[startIdx+lesserCount])
            greaterCount += 1
            done = lesserCount + greaterCount + 1 == length
            if done {
                break
            }
        }
        if done {
            break
        }
        lesserCount += 1
    }
    pivotIdx = endIdx - 1 - greaterCount
    swap(&arr[endIdx-1], &arr[pivotIdx])
    return pivotIdx
}

sortByLength :: proc (arr *[50]*executable, startIdx int, endIdx int) {
    if (endIdx - startIdx) <= 1 {
        return
    }
    pivotIdx := partition(arr, startIdx, endIdx)
    sortByLength(arr, startIdx, pivotIdx)
    sortByLength(arr, pivotIdx+1, endIdx)
}

filter :: proc (app *souvenir) {
    nMatches := 0
    widthSoFar := app.leftPadding + app.filterInputWidth
    var pathBuffer [5000]u8
    for i := 0..app.exeCount-1 {
        if widthSoFar > app.windowWidth {
            nMatches -= 1
            break
        }
        exe := &app.exeList[i]
        if app.filter.length > 0 {
            // Sorry, no Knuth–Morris–Pratt for today.
            match := false
            for i := 0..exe.fileName.length-app.filter.length {
                match = true
                for j := 0..app.filter.length-1 {
                    if @(app.filter.data + j) != @(exe.fileName.data + i + j) {
                        match = false
                        break
                    }
                }
                if match {
                    break
                }
            }
            if !match {
                continue
            }
        }
        totalLength := exe.dirPath.length + 1 + exe.fileName.length + 1
        if totalLength > 5000 {
            continue
        }
        fullExePath(exe, &pathBuffer)
        // R_OK | X_OK = 5
        if access(&pathBuffer, 5) != 0 {
            continue
        }

        app.filteredExeList[nMatches] = exe
        nMatches += 1
        widthSoFar += stringWidth(app, exe.fileName) + app.interItemPadding
    }
    app.nFilteredExeList = nMatches
    // The longer the string is, the more different it is from the filter.
    // All the items in app.filteredExeList have the filter as a substring.
    sortByLength(app.filteredExeList, 0, nMatches)
}

launch :: proc (exe *executable) {
    totalLength := exe.dirPath.length + 1 + exe.fileName.length + 1
    var pathBuffer [5000]u8
    if totalLength > 5000 {
        die("the path for the selected executable is too long")
    }
    var pBuffer *u8
    pBuffer = &pathBuffer
    fullExePath(exe, pBuffer)

    var argv [2]*u8
    argv[0] = pBuffer
    argv[1] = nil
    env := environ()
    posix_spawn(nil, pBuffer, nil, nil, &argv, env)
    writes(pBuffer, totalLength - 1)
    puts("\n")
}

fullExePath :: proc(exe *executable, buffer *[5000]u8) {
    // 47 is '/'
    memcpy(buffer, exe.dirPath.data, exe.dirPath.length)
    buffer[exe.dirPath.length] = 47
    memcpy(&buffer[exe.dirPath.length + 1], exe.fileName.data, exe.fileName.length)
    buffer[exe.dirPath.length + 1 + exe.fileName.length] = 0
}

stringWidth :: proc (app *souvenir, str string) -> int {
    var metrics XGlyphInfo
    XftTextExtentsUtf8(app.display, app.font, str.data, str.length, &metrics)
    return metrics.width
}


draw :: proc (app *souvenir) {
    pTextColor := &app.textColor

    XClearWindow(app.display, app.window)
    x := app.leftPadding

    filterWidth := stringWidth(app, app.filter)

    truncate := filterWidth > app.filterInputWidth - app.widthOfThreeDots
    filterLength := app.filter.length
    var filterMetrics XGlyphInfo
    if truncate {
        for filterLength > 0 && (filterWidth > app.filterInputWidth - app.widthOfThreeDots) {
            filterLength -= 1
            XftTextExtentsUtf8(app.display, app.font, app.filter.data, filterLength, &filterMetrics)
            filterWidth = filterMetrics.width
        }
    }
    XftDrawStringUtf8(app.xftWindowDraw, pTextColor, app.font, x, app.font.ascent, app.filter.data, filterLength)
    if truncate {
        XftDrawStringUtf8(app.xftWindowDraw, pTextColor, app.font, x + filterWidth, app.font.ascent, "...".data, "...".length)
    }
    x += app.filterInputWidth

    for i := 0..app.nFilteredExeList-1 {
        exe := app.filteredExeList[i]

        itemWidth := stringWidth(app, exe.fileName)

        if i == app.selected {
            XftDrawRect(app.xftWindowDraw, &app.selectionColor, x-5, 0, itemWidth+10, app.font.height)
        }
        XftDrawStringUtf8(app.xftWindowDraw, pTextColor, app.font, x, app.font.ascent, exe.fileName.data, exe.fileName.length)

        x += itemWidth + app.interItemPadding
    }
}

grabKeyboard :: proc (display *XDisplay, window u64) -> bool {
    CurrentTime := 0
    GrabModeAsync := 1
    GrabSuccess := 0
    // Try for about a second. XGrabKeyboard fails if we call it too
    // quickly after being launched by i3wm
    for 1..1000000 {
        if XGrabKeyboard(display, window, 1, GrabModeAsync, GrabModeAsync, CurrentTime) == GrabSuccess {
            return true
        }
        usleep(1)
    }
    return false
}

makeString :: proc (dest *void, data *u8, length int) -> int {
    var lenPtr *int
    var destChar *u8
    lenPtr = dest
    destChar = dest

    @lenPtr = length
    memcpy(destChar + 8, data, length)
    return 8 + length
}

die :: proc (info string) {
    puts("[souvenir] ")
    puts(info)
    puts("\n")
    exit(1)
}
