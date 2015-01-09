//
//  ViewController.swift
//  iKota
//
//  Created by Naoki KODAMA on 2015/01/04.
//  Copyright (c) 2015年 Naoki KODAMA. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var player : MPMusicPlayerController!
    var query : MPMediaQuery!
    var ncenter : NSNotificationCenter!
    var tuneCollection : TuneCollection!
    var relateItems : Array<AnyObject>!
    var currentTuningBase : String!
    var playingRelateIndex : Int!
    var isAlbumMode : Bool

    var avplayer : AVAudioPlayer!
    
    @IBOutlet weak var playingImageView: UIImageView!
    @IBOutlet weak var playingTitleLabel: UILabel!
    @IBOutlet weak var playingTuningLabel: UILabel!
    @IBOutlet weak var playingAlbumLabel: UILabel!
    
    @IBOutlet weak var tunesTable: UITableView!
    @IBOutlet weak var tunesIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var playOrStopButton: UIBarButtonItem!
    
    override init() {
        self.isAlbumMode = false
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.isAlbumMode = false
        super.init(coder: aDecoder)
    }

    func dispatch_async_global(block: () -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
    }
    
    func dispatch_async_main(block: () -> ()) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
    
    func setCurrentPlayOrStopButtonLabel(){
        switch (self.player.playbackState){
        case MPMusicPlaybackState.Stopped,MPMusicPlaybackState.Paused:
            println("Stop")
            self.playOrStopButton.title = "▶︎"
        case MPMusicPlaybackState.Playing,MPMusicPlaybackState.Interrupted,MPMusicPlaybackState.SeekingForward,MPMusicPlaybackState.SeekingBackward:
            println("Playing")
            self.playOrStopButton.title = "■"
        }
        
        if self.player.playbackState != MPMusicPlaybackState.Stopped && self.player.playbackState != MPMusicPlaybackState.Paused {
        }else{
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.tunesTable.dataSource = self;
        self.tunesTable.delegate = self;

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
        self.setCurrentPlayOrStopButtonLabel()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.relateItems != nil) {
            return self.relateItems.count
        }
        else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        var cellTmp = tableView.dequeueReusableCellWithIdentifier("tune") as? UITableViewCell
        
        if cellTmp == nil {
            cellTmp = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "tune")
            var backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.lightGrayColor()
            cellTmp!.selectedBackgroundView = backgroundView
            cellTmp!.detailTextLabel?.textColor = UIColor.darkGrayColor()
        }
        
        let cell = cellTmp!
        
        let item = self.relateItems[indexPath.row] as MPMediaItem
        var titleString: String = item.valueForProperty(MPMediaItemPropertyTitle) as String
        var albumString: String = item.valueForProperty(MPMediaItemPropertyAlbumTitle) as String
        var tuningString: String = self.tuneCollection.getTuningByTune(titleString, album: albumString)

        // Cellに部品を配置
        var artwork = item.valueForProperty(MPMediaItemPropertyArtwork) as MPMediaItemArtwork
        var image = artwork.imageWithSize(CGSizeMake(50,50)) as UIImage
        var imageView = cell.viewWithTag(1) as UIImageView
        imageView.image = image

        var title = cell.viewWithTag(2) as UILabel
        title.text = titleString

        var tuning = cell.viewWithTag(3) as UILabel
        tuning.text = tuningString
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath!) {
        var tunes = Array<AnyObject>()
        for (i,item : AnyObject) in enumerate(self.relateItems as Array){
            if (i < indexPath.row){
                tunes.append(item)
            }else if (i == indexPath.row){
                tunes.insert(item,atIndex: 0)
            }else{
                tunes.insert(item,atIndex: tunes.count - indexPath.row)
            }
        }
        
        /* // 再生速度を変更するコード
        let item: MPMediaItem = self.relateItems[indexPath.row] as MPMediaItem
        let url: NSURL = item.valueForProperty(MPMediaItemPropertyAssetURL) as NSURL
        self.avplayer = AVAudioPlayer(contentsOfURL: url, error:nil)
        self.avplayer.enableRate = true
        self.avplayer.rate = 0.75
        self.avplayer.play()
        */
        
        self.playingRelateIndex = indexPath.row
        var items = MPMediaItemCollection(items: tunes)
        self.player.setQueueWithItemCollection(items)
        self.player.shuffleMode = MPMusicShuffleMode.Off
        self.player.repeatMode = MPMusicRepeatMode.All       //全曲でリピート
        self.player.play()
    }
    
    // 再生曲が変わったら呼ばれるハンドラ
    func handle_NowPlayingItemChanged(){
        if self.isAlbumMode {
            self.updateTunelistForAlbum()
        }else{
            self.updateTunelist()
        }
    }
    
    func updateTunelist(){
        let item = player.nowPlayingItem as MPMediaItem
        
        // 再生中の曲情報を表示
        var titleString: String = item.valueForProperty(MPMediaItemPropertyTitle) as String
        var albumString: String = item.valueForProperty(MPMediaItemPropertyAlbumTitle) as String
        var tuning: String = self.tuneCollection.getTuningByTune(titleString, album: albumString)
        var tuningBase: String = self.tuneCollection.getTuningBaseByTune(titleString, album: albumString)

        println(titleString)

        if let image = self.playingImageView {
            let artwork = item.valueForProperty(MPMediaItemPropertyArtwork) as MPMediaItemArtwork
            // 90x90 にすると落ちるので 80x80にしている
            let aw_image = artwork.imageWithSize(CGSizeMake(80,80)) as UIImage
            
            image.image = aw_image
        }
        self.playingTitleLabel.text = titleString
        self.playingTuningLabel.text = tuning
        self.playingAlbumLabel.text = albumString
        
        // 表示中のチューニングを保持
        if self.isAlbumMode == false && self.currentTuningBase == tuningBase {
            // 関連曲の再生曲を選択状態にする
            let selectedIndex = self.tunesTable.indexPathForSelectedRow()
            if (selectedIndex != nil){
                println(selectedIndex?.row)
                var nextRow:Int = player.indexOfNowPlayingItem + self.playingRelateIndex
                let currentIndexPath = NSIndexPath(forRow:nextRow, inSection:0)
                self.tunesTable.selectRowAtIndexPath(currentIndexPath, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
            }
            return
        }

        self.isAlbumMode = false
        
        // テーブルをクリア
        self.relateItems = []
        self.tunesTable.reloadData()
        self.tunesIndicator.startAnimating()
        self.currentTuningBase = tuningBase
        
        dispatch_async_global {
            // 別スレッド
            println("tuningBase: " + tuningBase)
            // チューニングが同じ曲をテーブルに表示
            var target_items = Array<AnyObject>()
            for item : AnyObject in self.query.items{
                if self.currentTuningBase != tuningBase {
                    println("tuning changed! :" + tuningBase + " -> " + self.currentTuningBase)
                    return
                }
                var titleString: String = item.valueForProperty(MPMediaItemPropertyTitle) as String
                var albumString: String = item.valueForProperty(MPMediaItemPropertyAlbumTitle) as String
                if self.tuneCollection.isTuning(tuningBase, title: titleString, album: albumString){
                    target_items.append(item)
                }
            }
            
            self.dispatch_async_main {
                // UIスレッド
                println("show:" + tuningBase)
                self.relateItems = target_items
                
                // テーブルを更新
                self.tunesIndicator.stopAnimating()
                self.tunesTable.reloadData()
            }
        }
    }
    
    func updateTunelistForAlbum(){
        let item = player.nowPlayingItem as MPMediaItem
        
        // 再生中の曲情報を表示
        var titleString: String = item.valueForProperty(MPMediaItemPropertyTitle) as String
        var albumString: String = item.valueForProperty(MPMediaItemPropertyAlbumTitle) as String
        var tuning: String = self.tuneCollection.getTuningByTune(titleString, album: albumString)
        var tuningBase: String = self.tuneCollection.getTuningBaseByTune(titleString, album: albumString)
        
        println(titleString)
        
        if let image = self.playingImageView {
            let artwork = item.valueForProperty(MPMediaItemPropertyArtwork) as MPMediaItemArtwork
            // 90x90 にすると落ちるので 80x80にしている
            let aw_image = artwork.imageWithSize(CGSizeMake(80,80)) as UIImage
            
            image.image = aw_image
        }
        self.playingTitleLabel.text = titleString
        self.playingTuningLabel.text = tuning
        
        println(self.playingAlbumLabel)
        println(albumString)
        
        if self.isAlbumMode && self.playingAlbumLabel.text == albumString{
            // 関連曲の再生曲を選択状態にする
            let selectedIndex = self.tunesTable.indexPathForSelectedRow()
            if (selectedIndex != nil){
                println(selectedIndex?.row)
                var nextRow:Int = player.indexOfNowPlayingItem + self.playingRelateIndex
                let currentIndexPath = NSIndexPath(forRow:nextRow, inSection:0)
                self.tunesTable.selectRowAtIndexPath(currentIndexPath, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
            }
            return
        }
        
        self.isAlbumMode = true
        self.playingAlbumLabel.text = albumString
        
        // テーブルをクリア
        self.relateItems = []
        self.tunesTable.reloadData()
        self.tunesIndicator.startAnimating()
        self.currentTuningBase = tuningBase
        
        dispatch_async_global {
            // 別スレッド
            println("tuningBase: " + tuningBase)
            // チューニングが同じ曲をテーブルに表示
            var target_items = Array<AnyObject>()
            for item : AnyObject in self.query.items{
                if self.currentTuningBase != tuningBase {
                    println("tuning changed! :" + tuningBase + " -> " + self.currentTuningBase)
                    return
                }
                var titleString: String = item.valueForProperty(MPMediaItemPropertyTitle) as String
                var itemAlbumString: String = item.valueForProperty(MPMediaItemPropertyAlbumTitle) as String
                if itemAlbumString == albumString {
                    target_items.append(item)
                }
            }
            
            self.dispatch_async_main {
                // UIスレッド
                println("show:" + tuningBase)
                self.relateItems = target_items
                
                // テーブルを更新
                self.tunesIndicator.stopAnimating()
                self.tunesTable.reloadData()
            }
        }
        
    }

    // 再生状態が変わったら呼ばれるハンドラ
    func handle_PlaybackStateDidChanged(){
        self.setCurrentPlayOrStopButtonLabel()
    }

    @IBAction func onClickPlayOrStopButton(sender: AnyObject) {
        if self.player.playbackState == MPMusicPlaybackState.Playing {
            self.playOrStopButton.title = "▶︎"
            self.player.pause()
        }else{
            self.playOrStopButton.title = "■"
            self.player.play()
        }
    }
    
    @IBAction func onClickRewindButton(sender: AnyObject) {
        self.player.skipToPreviousItem()
    }
    
    @IBAction func onClickForwardButton(sender: AnyObject) {
        self.player.skipToNextItem()
    }
    
    @IBAction func onClickShuffleButton(sender: AnyObject) {
        self.isAlbumMode = false
        
        self.player.setQueueWithQuery(query)
        self.player.shuffleMode = MPMusicShuffleMode.Songs   //全曲でシャッフル
        self.player.repeatMode = MPMusicRepeatMode.All       //全曲でリピート
        self.player.play()
    }
    
    @IBAction func onClickTuningButton(sender: AnyObject) {
        self.updateTunelist()
    }

    @IBAction func onClickAlbumButton(sender: AnyObject) {
        self.updateTunelistForAlbum()
    }
    
    @IBAction func onClickYoutubeButton(sender: AnyObject) {
        performSegueWithIdentifier("youtube", sender: nil)
    }
    
}

