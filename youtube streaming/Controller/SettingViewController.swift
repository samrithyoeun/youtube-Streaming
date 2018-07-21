//
//  SettingViewController.swift
//  youtube streaming
//
//  Created by Samrith Yoeun on 7/21/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit
import Localize_Swift

class SettingViewController: UIViewController {
    
    @IBOutlet weak var languageButton: UIButton!
    
    var actionSheet: UIAlertController!
    let availableLanguages = Localize.availableLanguages()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name( LCLLanguageChangeNotification), object: nil)
        languageButton.setTitle("choose your language".localized(), for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func languageButtonTapped(_ sender: Any) {
        actionSheet = UIAlertController(title: nil, message: "choose your language".localized(), preferredStyle: UIAlertControllerStyle.actionSheet)
        for index in 0 ..< availableLanguages.count - 1 {
            let language  = availableLanguages[index]
            let displayName = Localize.displayNameForLanguage(language)
            let languageAction = UIAlertAction(title: displayName, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                Localize.setCurrentLanguage(language)
                print(Localize.currentLanguage())
            })
            actionSheet.addAction(languageAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {
            (alert: UIAlertAction) -> Void in
        })
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    @objc func setText(){
        languageButton.setTitle("choose your language".localized(), for: .normal)
        ControllerManager.shared.videoTable?.refreshUI()
        ControllerManager.shared.videoPlayer?.refreshUI()
        ControllerManager.shared.offlineVideo?.refreshUI()
    }
}
