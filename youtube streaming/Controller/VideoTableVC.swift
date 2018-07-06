//
//  VideoTableVC.swift
//  youtube streaming
//
//  Created by PM Academy 3 on 7/5/18.
//  Copyright © 2018 PM Academy 3. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class VideoTableVC: UITableViewController {
    
    var videos = [VideoEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIRequest.get { (json, code, error) in
            self.videos = APIRequest.map(json)
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let videoPlayerVC = segue.destination as? VideoPlayerVC, let cell = sender as? UITableViewCell {
            if let indexPath = tableView.indexPath(for: cell) {
                videoPlayerVC.video = videos[indexPath.row]
            }
        }
    }
    
}

extension VideoTableVC {
    
    //Mark: UITableView Delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //Mark: UITableView Datasource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let video = videos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "video tableview cell")  as! VideoTableViewCell
        cell.bindData(with: video)
        return cell
    }
    
}


