//
//  WernerLog.swift
//  TrailerInspection
//
//  Created by Robert Grimm on 2015-05-04.
//  Copyright (c) 2015 Werner Enterprises, Inc. All rights reserved.
//

import Foundation

public protocol WernerLogDelegate {
    
    func logv(format : String, args : CVaListPointer)
    
}

#if DEBUG
    var wernerLoggers : [WernerLogDelegate] = [ WernerLogNSLog() ]
#else
    var wernerLoggers = [WernerLogDelegate]()
#endif

public func WernerLog(format : String, args : CVarArgType...) {
    WernerLogv(format, getVaList(args))
}

public func WernerLogv(format : String, args : CVaListPointer) {
    for logger in wernerLoggers {
        logger.logv(format, args: args)
    }
}

#if DEBUG
    public class WernerLogNSLog : WernerLogDelegate {
        
        public init() {}
        
        public func logv(format : String, args : CVaListPointer) {
            
            NSLogv(format, args)
            
        }
        
    }
#endif
