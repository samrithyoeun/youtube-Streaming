//
//  OfflineVideoTableViewController.swift
//  youtube streaming
//
//  Created by PM Academy 3 on 7/9/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit

class OfflineVideoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var videos = VideoEntity.getOfflineVideo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }

}

extension OfflineVideoViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
}

extension OfflineVideoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let video = videos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "offline cell")  as! OfflineVideoTableViewCell
        cell.bindWith(video)
        return cell
    }
}
