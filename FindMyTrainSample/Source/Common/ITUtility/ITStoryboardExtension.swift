//
//  ITStoryboardExtension.swift
//  FindMyTrainSample
//
//  Created by Govind Sah on 31/03/19.
//  Copyright © 2019 Govind Sah. All rights reserved.
//

import UIKit

extension UIStoryboard {
    /// returns main story board
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: ITConstants.ITStoryboardConstants.main, bundle: nil)
    }
}
