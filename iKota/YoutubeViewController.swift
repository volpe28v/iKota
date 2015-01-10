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
        var webView = cell.viewWithTag(1) as UIWebView
        webView.scrollView.scrollEnabled = false
        webView.scrollView.bounces = false
        webView.loadHTMLString(self.getVideoHtml(self.youtubeData[indexPath.row].url), baseURL: nil)
        
        var title = cell.viewWithTag(2) as UILabel
        title.text = self.youtubeData[indexPath.row].title

        var author = cell.viewWithTag(3) as UILabel
        author.text = self.youtubeData[indexPath.row].author

        var count = cell.viewWithTag(4) as UILabel
        count.text = self.youtubeData[indexPath.row].count
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func getYoutube(){
        var params = ["vq": "押尾コータロー " + self.playingTitle
            ,"orderby": "relevance"
            ,"start-index": "1"
            ,"max-results": "12"
            ,"alt":"json"] as Dictionary<String, String>
        

        var url = NSURL(string: baseString + buildQueryString(fromDictionary:params))!
        
        var task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { data, response, error in
            
            var videos = NSJSONSerialization.JSONObjectWithData(data, options: nil,error: nil) as NSDictionary

            var feed = videos["feed"] as NSDictionary
            var entries = feed["entry"] as NSArray
            for item in entries {
                var group = item["media$group"] as NSDictionary
                var players = group["media$player"] as NSArray
                var player = players[0] as NSDictionary
                var url = player["url"] as String
                
                var thumbnails = group["media$thumbnail"] as NSArray
                var thumbnail = thumbnails[0] as NSDictionary
                var thumbnail_url = thumbnail["url"] as String
                
                var title = item["title"] as NSDictionary
                var title_body = title["$t"] as String
                
                var authors = item["author"] as NSArray
                var author = authors[0] as NSDictionary
                var author_name = author["name"] as NSDictionary
                var author_name_body = author_name["$t"] as String
                
                var statistics = item["yt$statistics"] as NSDictionary
                var viewCount = statistics["viewCount"] as String
                
                var youtube = YoutubeInfo()
                youtube.title = title_body
                youtube.url = url
                youtube.thumbnail = thumbnail_url
                youtube.author = author_name_body
                youtube.count = viewCount
                self.youtubeData.append(youtube)
            }

            dispatch_async(dispatch_get_main_queue(),{
                // ここは mainスレッドの中
                self.tableView.reloadData()
            })
        })
        
        task.resume()
    }

    func buildQueryString(fromDictionary parameters: [String:String]) -> String {
        var urlVars = [String]()
        for (k, var v) in parameters {
            v = v.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            urlVars += [k + "=" + "\(v)"]
        }
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }

    func getVideoHtml(urlString: String) -> String{
        let videoID = self.getQueryDictionary(urlString)["v"] as String
        
        var htmlString: NSString =
        "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "<meta name=\"viewport\" content=\"initial-scale=1.0, user-scalable=no, width=110px\">" +
            "</head>" +
            "<body style=\"background:#000000; margin-top:0px; margin-left:0px\">" +
            "<iframe width=\"110px\" height=\"110px\" " +
            "src=\"http://www.youtube.com/embed/%@?showinfo=0\" " +
            "frameborder=\"0\" " +
            "allowfullscreen> " +
            "</iframe>" +
            "</body>" +
        "</html>"
        
        let html = NSString(format: htmlString,
            videoID)
  
        return html
    }
    
    func getQueryDictionary(urlString: String) -> NSDictionary {
        let comp: NSURLComponents? = NSURLComponents(string: urlString)
        
        for (var i=0; i < comp?.queryItems?.count; i++) {
            let item = comp?.queryItems?[i] as NSURLQueryItem
        }
        
        func urlComponentsToDict(comp:NSURLComponents) -> Dictionary<String, String> {
            var dict:Dictionary<String, String> = Dictionary<String, String>()
            
            for (var i=0; i < comp.queryItems?.count; i++) {
                let item = comp.queryItems?[i] as NSURLQueryItem
                dict[item.name] = item.value
            }
            
            return dict
        }
        
        var dict = urlComponentsToDict(comp!)
        return dict
    }

}
