//
//  YoutubeViewController.swift
//  iKota
//
//  Created by Naoki KODAMA on 2015/01/08.
//  Copyright (c) 2015年 Naoki KODAMA. All rights reserved.
//

import UIKit
import Foundation

class YoutubeViewController: UITableViewController {
    
    var baseString : String = "http://gdata.youtube.com/feeds/api/videos"
    var youtubeData: Array<YoutubeInfo> = []
    var playingTitle: String = ""
    var youtubeConnector: YoutubeConnector = YoutubeConnector()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getYoutube()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.youtubeData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellTmp = tableView.dequeueReusableCellWithIdentifier("video") as? UITableViewCell
        
        if cellTmp == nil {
            cellTmp = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "video")
        }
        
        let cell = cellTmp!
                
        // Cellに部品を配置
        var webView = cell.viewWithTag(1) as! UIWebView
        webView.scrollView.scrollEnabled = false
        webView.scrollView.bounces = false
        webView.loadHTMLString(self.youtubeConnector.getVideoHtml(self.youtubeData[indexPath.row].url, width: 110, height: 110), baseURL: nil)
        
        var title = cell.viewWithTag(2)as! UILabel
        title.text = self.youtubeData[indexPath.row].title

        var author = cell.viewWithTag(3) as! UILabel
        author.text = self.youtubeData[indexPath.row].author

        var count = cell.viewWithTag(4) as! UILabel
        count.text = self.youtubeData[indexPath.row].count
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func getYoutube(){
        self.youtubeConnector.getYoutube(self.playingTitle, resultNum: 10, completionHandler: { youtubeData in
            if youtubeData.count > 0 {
                self.youtubeData = youtubeData
                dispatch_async(dispatch_get_main_queue(),{
                    // ここは mainスレッドの中
                    self.tableView.reloadData()
                })
            }
        })
    }
}
