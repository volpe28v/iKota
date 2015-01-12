//
//  YoutubeViewController.swift
//  iKota
//
//  Created by Naoki KODAMA on 2015/01/08.
//  Copyright (c) 2015年 Naoki KODAMA. All rights reserved.
//

import UIKit
import Foundation

class SearchViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellTmp = tableView.dequeueReusableCellWithIdentifier("video") as? UITableViewCell
        
        if cellTmp == nil {
            cellTmp = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "video")
        }
        
        let cell = cellTmp!
        
        // Cellに部品を配置
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}
