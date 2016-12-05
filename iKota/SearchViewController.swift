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
    case album
    case tuning
    case history
    case count
}

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tuneCollection : TuneCollection! = TuneCollection.sharedInstance
    var sortedTunes : Array<Tune>! = []

    var searchMode : SearchMode = .album
    
    @IBOutlet weak var tableView: UITableView!
    
    func dispatch_async_global(_ block: @escaping () -> ()) {
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: block)
    }
    
    func dispatch_async_main(_ block: @escaping () -> ()) {
        DispatchQueue.main.async(execute: block)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch self.searchMode
        {
        case .album:
            return tuneCollection.activeAlbums.count
        case .tuning:
            return tuneCollection.activeTunings.count
        case .count:
            return self.sortedTunes.count
        case .history:
            break;
        }

        return 0 // 通らないはず
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.searchMode
        {
        case .album:
            return getAlbumCell(tableView, cellForRowAtIndexPath: indexPath)
        case .tuning:
            return getTuningCell(tableView, cellForRowAtIndexPath: indexPath)
        case .count:
            return getCountCell(tableView, cellForRowAtIndexPath: indexPath)
        case .history:
            break;
        }
        
        return getAlbumCell(tableView, cellForRowAtIndexPath: indexPath)
    }
    
    func getAlbumCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        var cellTmp = tableView.dequeueReusableCell(withIdentifier: "album") as UITableViewCell?
        
        if cellTmp == nil {
            cellTmp = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "album")
        }
        
        let cell = cellTmp!
        
        // Cellに部品を配置
        let tune : Tune = self.tuneCollection.activeAlbums[indexPath.row]
        let artwork = tune.item!.value(forProperty: MPMediaItemPropertyArtwork) as! MPMediaItemArtwork
        let image = artwork.image(at: CGSize(width: 50,height: 50)) as UIImage?
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = image
        
        let title = cell.viewWithTag(2) as! UILabel
        title.text = tune.album
        
        return cell
    }
    
    func getTuningCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        var cellTmp = tableView.dequeueReusableCell(withIdentifier: "tuning") as UITableViewCell?
        
        if cellTmp == nil {
            cellTmp = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "tuning")
        }
        
        let cell = cellTmp!
        
        // Cellに部品を配置
        let tune : Tune = self.tuneCollection.activeTunings[indexPath.row]
        
        let title = cell.viewWithTag(1) as! UILabel
        title.text = tune.tuning
        
        return cell
    }

    func getCountCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        var cellTmp = tableView.dequeueReusableCell(withIdentifier: "count") as UITableViewCell?
        
        if cellTmp == nil {
            cellTmp = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "count")
        }
        
        let cell = cellTmp!
        
        var tune : Tune? = nil
        tune = self.sortedTunes[indexPath.row]

        let item = tune!.item as! MPMediaItem
        let titleString: String = tune!.title
        let tuningString: String = tune!.getTuningName()
        
        // Cellに部品を配置
        if let artwork = item.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork {
            let image = artwork.image(at: CGSize(width: 50,height: 50))! as UIImage
            let imageView = cell.viewWithTag(1) as! UIImageView
            imageView.image = image
        }
        
        
        let title = cell.viewWithTag(2) as! UILabel
        title.text = titleString
        
        let tuning = cell.viewWithTag(3) as! UILabel
        tuning.text = tuningString
        
        let playCount = cell.viewWithTag(4) as! UILabel
        let count = tune!.getPlayCount()
        if count > 0 {
            playCount.text = String(count)
        }else{
            playCount.text = ""
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.searchMode
        {
        case .album:
            performSegue(withIdentifier: "playlist", sender: self.tuneCollection.activeAlbums[indexPath.row])
        case .tuning:
            performSegue(withIdentifier: "playlistWithTuning", sender: self.tuneCollection.activeTunings[indexPath.row])
        case .count:
            performSegue(withIdentifier: "playlistWithCountTune", sender: self.sortedTunes[indexPath.row])
            break;
        case .history:
            break;
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.searchMode
        {
        case .album:
            return 69
        case .tuning:
            return 41
        case .count:
            return 54
        case .history:
            break;
        }
        
        return 0
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let playListController = segue.destination as! ViewController
        switch segue.identifier as String!
        {
            case "playlist":
                let tune : Tune = sender as! Tune!
                playListController.displayAlbum = tune.album
            case "playlistWithTuning":
                playListController.displayTuneForTuning = sender as! Tune!
            case "playlistWithCountTune":
                playListController.displayTuneForCount = sender as! Tune!
            default:
                break
        }
    }
    
    @IBAction func onClickSearchMode(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0: // Album
            self.searchMode = .album
            self.tableView.reloadData()
        case 1: // Tuning
            self.searchMode = .tuning
            self.tableView.reloadData()
        case 2: // Count
            self.searchMode = .count
            self.updateSortedTuneList()
        case 3: // History
            self.searchMode = .history
        default:
            break;
        }
    }
    
    func updateSortedTuneList(){
        self.sortedTunes = []
        
        dispatch_async_global {
            // 別スレッド
            // 再生回数上位を抽出
            let targetTunes = self.tuneCollection.getUpperLevelCountTunes()
            
            self.dispatch_async_main {
                // UIスレッド
                self.sortedTunes = targetTunes
                
                // テーブルを更新
                self.tableView.reloadData()
            }
        }

    }
    
}
