//
//  UIViewControllerEx.swift
//  youtube streaming
//
//  Created by Samrith Yoeun on 7/9/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import Foundation

extension UIViewController {
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
