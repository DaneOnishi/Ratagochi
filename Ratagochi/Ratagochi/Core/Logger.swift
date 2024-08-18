//
//  Logger.swift
//  Ratagochi
//
//  Created by Enzo Maruffa Moreira on 17/08/24.
//

import Foundation
import SwiftyBeaver

class Logger {
    private static let log = SwiftyBeaver.self
    
    static func configure() {
        let console = ConsoleDestination()
        console.minLevel = .debug
        console.format = "$DHH:mm:ss.SSS$d $C$L$c $N.$F:$l - $M"
        
//        let file = FileDestination()
//        file.format = "$DHH:mm:ss.SSS$d $C$L$c $N.$F:$l - $M"
//        file.logFileURL = getDocumentsDirectory().appendingPathComponent("app_logs.log")
        
        log.addDestination(console)
//        log.addDestination(file)
    }
    
    static func verbose(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log.verbose(message, file: file, function: function, line: line)
    }
    
    static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log.debug(message, file: file, function: function, line: line)
    }
    
    static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log.info(message, file: file, function: function, line: line)
    }
    
    static func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log.warning(message, file: file, function: function, line: line)
    }
    
    static func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log.error(message, file: file, function: function, line: line)
    }
    
    private static func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
