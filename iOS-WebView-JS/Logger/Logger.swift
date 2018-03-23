//
//  Logger.swift
//  PocketCrane
//
//  Created by pike young on 2018/2/22.
//  Copyright © 2018年 Livestar. All rights reserved.
//

import Foundation

let log = Logger()

struct Logger {
    public func printLog<T>(_ message: T, file: String = #file, method: String = #function, line: Int = #line) {
        #if DEBUG
            print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
        #endif
    }
}
