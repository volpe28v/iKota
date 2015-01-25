//
//  YoutubeViewController.swift
//  iKota
//
//  Created by Naoki KODAMA on 2015/01/08.
//  Copyright (c) 2015年 Naoki KODAMA. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tuneCollection : TuneCollection! = TuneCollection.sharedInstance

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tuneCollection.activeAlbums.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellTmp = tableView.dequeueReusableCellWithIdentifier("album") as? UITableViewCell
        
        if cellTmp == nil {
            cellTmp = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "album")
        }
        
        let cell = cellTmp!
        
        // Cellに部品を配置
        let tune : Tune = self.tuneCollection.activeAlbums[indexPath.row]
        var artwork = tune.item!.valueForProperty(MPMediaItemPropertyArtwork) as MPMediaItemArtwork
        var image = artwork.imageWithSize(CGSizeMake(50,50)) as UIImage
        var imageView = cell.viewWithTag(1) as UIImageView
        imageView.image = image
        
        var title = cell.viewWithTag(2) as UILabel
        title.text = tune.album

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("playlist", sender: self.tuneCollection.activeAlbums[indexPath.row])
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "playlist" {
            var tune : Tune = sender as Tune!
            var playListController = segue.destinationViewController as ViewController
            playListController.displayAlbum = tune.album
        }
    }
}
