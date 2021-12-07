//
//  LinesSplits.swift
//
//  Created by Steven Rich on 12/4/21.
//

import Foundation

public enum LinesError: Error {
    case cannotOpenFile(String)
}

public struct Lines: Sequence, IteratorProtocol {
    let fromFile: String?
    let fileHandle: FileHandle?
    let chunkSize: Int
    let separator: UInt8
    var dataCache: Data?

    public typealias Element = String

    @discardableResult
    mutating func refill() throws -> Bool {
        if let fh = self.fileHandle {
            let newData = try fh.read(upToCount: self.chunkSize)
            if var dc = self.dataCache {
                if let nd = newData {
                    dc.append(nd)
                }
            } else {
                self.dataCache = newData
            }

            if newData != nil {
                return true
            }
        }
        return false
    }

    public mutating func next() -> Self.Element? {
        if self.dataCache == nil {
            do {
                try self.refill()
            } catch {
                return nil
            }
        }
        if self.dataCache == nil {
            return nil
        }

        repeat {
            let parts = self.dataCache!.split(separator: self.separator,
                                              maxSplits: 1,
                                              omittingEmptySubsequences: false)
            self.dataCache = nil
            if parts.count == 2 {
                self.dataCache = parts[1]
                return String(data: parts[0], encoding: .ascii)
            }
            // If we reach here, then we split and got only a single Data element.
            // That means no NL character.  We may be at the very end of our buffer
            // and just need to refill it.  Try that.
            do {
                if try self.refill() {
                    // Ok.  We got more data.  Let's append that to
                    // our single chunk and try again.
                    var newCache = parts[0]
                    newCache.append(self.dataCache!)
                    self.dataCache = newCache
                } else {
                    // No more data.  Must be at EOL.  Return what we have.
                    // BUT WAIT!  There's more!  Inexplicably, a Data.split()
                    // on a zero-length Data instance returns... wait for it...
                    // A one-length array of [Data] with a single zero-length
                    // Data instance.  Why?  IDK.  IMO, it should return a
                    // zero-length [Data] Array.  Oh well.  Life goes on.
                    // However, one must distinguish between an original
                    // zero-length Data and a Data with a single sep character...
                    if parts[0].count == 0 {
                        return nil
                    }
                    return String(data: parts[0], encoding: .ascii)
                }
            } catch {
                // Something failed in read, but we do have data.  Return that.
                // The next iteration may fail-fail
                return String(data: parts[0], encoding: .ascii)
            }
        } while true
    }

    public init(fromFile: String, separator: UInt8 = 10, chunkSize:Int = 65536) throws {
        self.fromFile = fromFile
        self.fileHandle = FileHandle.init(forReadingAtPath: fromFile)
        self.chunkSize = chunkSize
        self.separator = separator
        self.dataCache = nil

        if self.fileHandle == nil {
            throw LinesError.cannotOpenFile(fromFile)
        }
    }

    public init(fromData: Data, separator: UInt8 = 10) {
        self.fromFile = nil
        self.fileHandle = nil
        self.chunkSize = 0
        self.separator = separator
        self.dataCache = fromData
    }
}
