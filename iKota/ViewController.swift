//
//  ViewController.swift
//  iKota
//
//  Created by Naoki KODAMA on 2015/01/04.
//  Copyright (c) 2015年 Naoki KODAMA. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UITableViewController {
    var player : MPMusicPlayerController!
    var query : MPMediaQuery!
    var ncenter : NSNotificationCenter!
    var tuneCollection : TuneCollection!
    var relateItems : Array<AnyObject>!
    var currentTuningBase : String!
    var playingRelateIndex : Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.currentTuningBase = ""
        
        // 曲情報を取得
        self.tuneCollection = TuneCollection()
        
        // 押尾コータローの全曲を取得して登録
        self.player = MPMusicPlayerController.iPodMusicPlayer()
        self.query = MPMediaQuery.artistsQuery()
        var pred : MPMediaPropertyPredicate!
        pred = MPMediaPropertyPredicate(value:"押尾コータロー", forProperty:MPMediaItemPropertyArtist)
        self.query.addFilterPredicate(pred)
        
        // 再生変更通知を登録
        self.ncenter = NSNotificationCenter.defaultCenter()
        self.ncenter.addObserver(
            self,
            selector: "handle_NowPlayingItemChanged",   // 再生曲変更
            name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification,
            object: self.player
        )
        self.ncenter.addObserver(
            self,
            selector: "handle_PlaybackStateDidChanged", // 再生状態変更
            name: MPMusicPlayerControllerPlaybackStateDidChangeNotification,
            object: self.player
        )
        
        self.player.beginGeneratingPlaybackNotifications()
        //self.setCurrentPlayOrStopButtonLabel()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "tune")
        cell.textLabel?.text = "tune"
        return cell
    }
    
    
    // 再生曲が変わったら呼ばれるハンドラ
    func handle_NowPlayingItemChanged(){

    }
    
    // 再生状態が変わったら呼ばれるハンドラ
    func handle_PlaybackStateDidChanged(){
    }

}

