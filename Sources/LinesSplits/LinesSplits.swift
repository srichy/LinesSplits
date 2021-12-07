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
                    self.dataCache = dc
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
            if let sepIdx = self.dataCache!.firstIndex(of: self.separator) {
                let retStr = String(data: self.dataCache!.prefix(upTo: sepIdx),
                                    encoding: .ascii)
                self.dataCache = self.dataCache!.dropFirst(sepIdx + 1)
                return retStr
            }
            // So, we have data, but no separator.  This could go on until
            // EOF.  Let's try
            do {
                if try self.refill() {
                    continue
                }
            } catch {
                // Something's gone badly wrong.  Return what we have.
                // Might catch error on the next next()
            }
            // If we land here, we've tried (and maybe succeeded) to refill,
            // but we still have not found sep.  We're at EOF.  Return what
            // we have.
            if self.dataCache!.isEmpty {
                return nil
            }
            let retStr = String(data: self.dataCache!, encoding: .ascii)
            self.dataCache = nil
            return retStr
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
