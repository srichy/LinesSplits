# LinesSplits

Convenience "splitting" functions for Swift (growing over time; this
is not "finished").  Basically, when I want some quick-and-dirty text
processing and don't want to have to deal with FileManager and
Data-to-String conversions and all that.

~~Oh, and if there's a built-in way to open a file and return a
line-by-line iterator, for example, please let me know.  I haven't
found it yet.~~  Apple has a since `AsyncSequence` which allows
code like
```swift
import Foundation

let fh = FileHandle.standardInput
for try await l in fh.bytes.lines {
    // Do something with l
}
```
which is _really_ nice.  Unless you want blank lines.  Because, as
far as I can tell, blank lines are filtered out, and there is no way
to tell they were there.  Information lost.  Sigh.  So I am adding an
`allLines` async sequence that returns zero-length `String`s for blank
lines.
