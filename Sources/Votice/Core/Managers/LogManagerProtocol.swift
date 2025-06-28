//
//  LogManager+Protocol.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 27/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

protocol LogManagerProtocol {
    func devLog(_ logType: LogManagerType,
                _ message: String,
                utf8Data: Data?,
                ignoreFunctionName: Bool,
                function: String)
    func devLog(_ logType: LogManagerType,
                _ message: String,
                userInfo: [AnyHashable: Any],
                function: String)
}
