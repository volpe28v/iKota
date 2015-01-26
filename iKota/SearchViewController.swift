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

enum SearchMode {
    case Album
    case Tuning
    case History
    case Count
}

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tuneCollection : TuneCollection! = TuneCollection.sharedInstance

    var searchMode : SearchMode = .Album
    
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
        
        switch self.searchMode
        {
        case .Album:
            return tuneCollection.activeAlbums.count
        case .Tuning:
            return 2;
        case .History:
            break;
        case .Count:
            break;
        default:
            break;
        }

        return 0 // 通らないはず
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch self.searchMode
        {
        case .Album:
            return getAlbumCell(tableView, cellForRowAtIndexPath: indexPath)
        case .Tuning:
            return getTuningCell(tableView, cellForRowAtIndexPath: indexPath)
        case .History:
            break;
        case .Count:
            break;
        default:
            break;
        }
        
        return getAlbumCell(tableView, cellForRowAtIndexPath: indexPath)
    }
    
    func getAlbumCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
    
    func getTuningCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellTmp = tableView.dequeueReusableCellWithIdentifier("tuning") as? UITableViewCell
        
        if cellTmp == nil {
            cellTmp = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "tuning")
        }
        
        let cell = cellTmp!
        
        // Cellに部品を配置
//        let tune : Tune = self.tuneCollection.activeAlbums[indexPath.row]
        
        var title = cell.viewWithTag(1) as UILabel
        title.text = "DADGAD"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("playlist", sender: self.tuneCollection.activeAlbums[indexPath.row])
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch self.searchMode
        {
        case .Album:
            return 69
        case .Tuning:
            return 41
        case .History:
            break;
        case .Count:
            break;
        default:
            break;
        }
        
        return 0
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "playlist" {
            var tune : Tune = sender as Tune!
            var playListController = segue.destinationViewController as ViewController
            playListController.displayAlbum = tune.album
        }
    }
    
    @IBAction func onClickSearchMode(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0: // Album
            self.searchMode = .Album
        case 1: // Tuning
            self.searchMode = .Tuning
        case 2: // History
            self.searchMode = .History
        case 3: // Count
            self.searchMode = .Count
        default:
            break;
        }
        self.tableView.reloadData()
        
    }
    
}
