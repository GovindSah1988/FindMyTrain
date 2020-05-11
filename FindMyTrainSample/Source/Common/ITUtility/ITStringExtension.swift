//
//  ITStringExtension.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 31/03/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import Foundation

extension String {
    
    /// used for trimming Strings with trailing Spaces
    func trailingSpacesTrimmed() -> String {
        var aString = self
        
        while aString.hasSuffix(" ") {
            aString = String(aString.dropLast())
        }
        
        return aString
    }
}
