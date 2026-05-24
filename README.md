# xib2coder

xib2coder parses a XIB file and generates Objective-C NSCoding category
implementations for the custom classes contained in the archive.  The generated
categories can be added beside existing class implementations without replacing
those classes.  The goal is to make it easier to produce accurate code for
GNUstep while keeping the tool buildable on both GNUstep under Linux and macOS.

## Building

On macOS with Xcode:

```sh
xcodebuild -project xib2coder.xcodeproj -target xib2coder
```

On GNUstep:

```sh
make
```

If your GNUstep environment is not already loaded, source the GNUstep make
environment first, for example:

```sh
. /usr/share/GNUstep/Makefiles/GNUstep.sh
```

## Usage

```sh
xib2coder path/to/file.xib
```

For each custom class in the XIB, xib2coder writes a category implementation
beside the input XIB using the form:

```text
ClassName+XIB2CoderNSCoding.m
```
