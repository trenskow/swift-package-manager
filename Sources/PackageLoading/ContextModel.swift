//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift open source project
//
// Copyright (c) 2014-2021 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

@_implementationOnly import Foundation

struct ContextModel {
    let packageDirectory : String
    
    init(packageDirectory : String) {
        self.packageDirectory = packageDirectory
    }
    
    var environment : [String : String] {
        ProcessInfo.processInfo.environment
    }
}

extension ContextModel : Codable {
    func encode() throws -> String {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        return String(decoding: data, as: UTF8.self)
    }

    static func decode() throws -> ContextModel {
        var args = Array(ProcessInfo.processInfo.arguments[1...]).makeIterator()
        while let arg = args.next() {
            if arg == "-context", let json = args.next() {
                let decoder = JSONDecoder()
                let data = Data(json.utf8)
                return try decoder.decode(ContextModel.self, from: data)
            }
        }
        throw StringError(description: "Could not decode ContextModel parameter.")
    }

    struct StringError: Error, CustomStringConvertible {
        let description: String
    }
}
