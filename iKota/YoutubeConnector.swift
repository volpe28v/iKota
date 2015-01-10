//
//  YoutubeConnector.swift
//  iKota
//
//  Created by Naoki KODAMA on 2015/01/10.
//  Copyright (c) 2015年 Naoki KODAMA. All rights reserved.
//

import Foundation

struct YoutubeInfo {
    var title: String = ""
    var url: String = ""
    var thumbnail: String = ""
    var author: String = ""
    var count: String = ""
}

class YoutubeConnector{
    
    var baseString : String = "http://gdata.youtube.com/feeds/api/videos"

    func getYoutube(title: String, resultNum: Int, completionHandler: ((Array<YoutubeInfo>) -> Void)){
        var youtubeData: Array<YoutubeInfo> = []
        
        var params = ["vq": "押尾コータロー " + title
            ,"orderby": "relevance"
            ,"start-index": "1"
            ,"max-results": String(resultNum)
            ,"alt": "json"] as Dictionary<String, String>
        
        var url = NSURL(string: baseString + buildQueryString(fromDictionary:params))!
        
        var task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { data, response, error in
            
            var videos = NSJSONSerialization.JSONObjectWithData(data, options: nil,error: nil) as NSDictionary
            
            var feed = videos["feed"] as NSDictionary
            if let entries = feed["entry"] as NSArray? {
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
                    youtubeData.append(youtube)
                }
            }

            // コールバック経由で動画情報を返す
            completionHandler(youtubeData)
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
    
    func getVideoHtml(urlString: String, width: Int, height: Int) -> String{
        let videoID = self.getQueryDictionary(urlString)["v"] as String
        
        var htmlString: NSString =
        "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "<meta name=\"viewport\" content=\"initial-scale=1.0, user-scalable=no, width=%dpx\">" +
            "</head>" +
            "<body style=\"background:#000000; margin-top:0px; margin-left:0px\">" +
            "<iframe width=\"%dpx\" height=\"%dpx\" " +
            "src=\"http://www.youtube.com/embed/%@?showinfo=0\" " +
            "frameborder=\"0\" " +
            "allowfullscreen> " +
            "</iframe>" +
            "</body>" +
        "</html>"
        
        let html = NSString(format: htmlString,
            width,
            width,
            height,
            videoID)
        
        return html
    }

    func getBlankHtml(width: Int, height: Int) -> String{
        var htmlString: NSString =
        "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "<meta name=\"viewport\" content=\"initial-scale=1.0, user-scalable=no, width=%dpx\">" +
            "</head>" +
            "<body style=\"background:white; margin-top:0px; margin-left:0px\">" +
            "</body>" +
        "</html>"
        
        let html = NSString(format: htmlString, width)
        
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