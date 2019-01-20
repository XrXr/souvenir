# Souvenir

Text based application launcher heavily inspired by dmenu written in [Alang].

![demo](https://user-images.githubusercontent.com/6457510/51446733-072cab80-1ce4-11e9-98e1-ec2bfa930e93.gif)

### Building

- Setup [Alang]
- `$GOPATH/bin/alang -c -libc souvenir.al` to compile into object file
- `cc -g a.o -o souvenir -lX11 -lXft` to link with `libc`, `libX11` and `libXft`

### Why would someone use this?

I personally use this as my application launcher under [i3wm](https://i3wm.org/).

[Alang]: https://github.com/XrXr/alang
