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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.youtubeData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellTmp = tableView.dequeueReusableCell(withIdentifier: "video") as UITableViewCell?
        
        if cellTmp == nil {
            cellTmp = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "video")
        }
        
        let cell = cellTmp!
                
        // Cellに部品を配置
        let youtube = self.youtubeData[indexPath.row]
        let imgData: Data
        
        do {
            let imageView = cell.viewWithTag(1) as! UIImageView
            let thumbnail = URL(string: youtube.thumbnail);
            imgData = try Data(contentsOf: thumbnail!,options: NSData.ReadingOptions.mappedIfSafe)
            imageView.image = UIImage(data:imgData);
            imageView.frame = CGRect(x: 0, y: 0, width: 120, height: 100);
        } catch {
            print("Error: can't create image.")
        }
                
        let title = cell.viewWithTag(2)as! UILabel
        title.text = youtube.title
        print(youtube.title)

        let author = cell.viewWithTag(3) as! UILabel
        author.text = youtube.author
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "youtubePlayer", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "youtubePlayer" {
            let youtubeController = segue.destination as! YoutubePlayerViewController
            youtubeController.youtubeIndex = sender as! Int
            youtubeController.youtubeData = self.youtubeData

        }
    }

    func getYoutube(){
        self.youtubeConnector.getYoutube(self.playingTitle, resultNum: 10, completionHandler: { youtubeData in
            if youtubeData.count > 0 {
                self.youtubeData = youtubeData
                DispatchQueue.main.async(execute: {
                    // ここは mainスレッドの中
                    self.tableView.reloadData()
                })
            }
        })
    }
}
