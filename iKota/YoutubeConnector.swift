//
//  YoutubeConnector.swift
//  iKota
//
//  Created by Naoki KODAMA on 2015/01/10.
//  Copyright (c) 2015年 Naoki KODAMA. All rights reserved.
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


struct YoutubeInfo {
    var title: String = ""
    var videoId: String = ""
    var thumbnail: String = ""
    var author: String = ""
    var count: String = ""
    var description: String = ""
}

class YoutubeConnector{
    
    var baseString : String = "https://www.googleapis.com/youtube/v3/search"

    func getYoutube(_ title: String, resultNum: Int, completionHandler: @escaping ((Array<YoutubeInfo>) -> Void)){
        var youtubeData: Array<YoutubeInfo> = []
        
        let params = [
            "part": "snippet",
            "key": "AIzaSyCUcKtxm3oTogfujXslDQpdpSMGRsEHYI4",
            "type":"video",
            "q": "押尾コータロー " + title,
            "maxResults": String(resultNum),
            ] as Dictionary<String, String>
        
        let url = URL(string: baseString + buildQueryString(fromDictionary:params))!
        print(url)
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            let json = (try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers)) as! NSDictionary


            if let items:NSArray = json.object(forKey: "items") as? NSArray {
                print(items.count)
                for item in items {
                    let id:NSDictionary = (item as AnyObject).object(forKey: "id") as! NSDictionary
                    let snippet:NSDictionary = (item as AnyObject).object(forKey: "snippet") as! NSDictionary
                    
                    var youtube = YoutubeInfo()
                    youtube.title = snippet.object(forKey: "title") as! String
                    youtube.videoId = id.object(forKey: "videoId") as! String
                    youtube.thumbnail = ((snippet.object(forKey: "thumbnails")! as AnyObject).object(forKey: "default")! as AnyObject).object(forKey: "url") as! String
                    youtube.author = snippet.object(forKey: "channelTitle") as! String
                    youtube.description = snippet.object(forKey: "description") as! String
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
            v = v.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            urlVars += [k + "=" + "\(v)"]
        }
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joined(separator: "&")
    }
    
    func getVideoHtml(_ urlString: String, width: Int, height: Int) -> String{
        //let videoID = self.getQueryDictionary(urlString)["v"]as! String
        let videoID = urlString
        let htmlString = "<!DOCTYPE html>" +
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
        
        let html = NSString(format: htmlString as NSString,
            width,
            width,
            height,
            videoID)
        
        return html as String
    }

    func getBlankHtml(_ width: Int, height: Int) -> String{
        let htmlString =
        "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "<meta name=\"viewport\" content=\"initial-scale=1.0, user-scalable=no, width=%dpx\">" +
            "</head>" +
            "<body style=\"background:white; margin-top:0px; margin-left:0px\">" +
            "</body>" +
        "</html>"
        
        let html = NSString(format: htmlString as NSString, width)
        
        return html as String
    }

    func getQueryDictionary(_ urlString: String) -> NSDictionary {
        let comp: URLComponents? = URLComponents(string: urlString)
        for i in (0 ..< (comp?.queryItems?.count)!) {
            let item = comp?.queryItems?[i] as URLQueryItem!
        }
        
        func urlComponentsToDict(_ comp:URLComponents) -> Dictionary<String, String> {
            var dict:Dictionary<String, String> = Dictionary<String, String>()
            
            for i in (0 ..< (comp.queryItems?.count)!) {
                let item = comp.queryItems?[i] as URLQueryItem!
                dict[(item?.name)!] = item?.value
            }
            
            return dict
        }
        
        let dict = urlComponentsToDict(comp!)
        return dict as NSDictionary
    }

}
