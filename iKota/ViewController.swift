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
    var tuneCollection : TuneCollection! = TuneCollection()
    var relateItems : Array<AnyObject>!
    var playingTuningBase : String! = ""
    var playingAlbum : String! = ""
    var playingRelateIndex : Int!
    var isAlbumMode : Bool = false
    var youtubeConnector : YoutubeConnector! = YoutubeConnector()


//    var avplayer : AVAudioPlayer!
    
    @IBOutlet weak var playingImageView: UIImageView!
    @IBOutlet weak var playingTitleLabel: UILabel!
    @IBOutlet weak var playingTuningLabel: UILabel!
    @IBOutlet weak var playingAlbumLabel: UILabel!
    @IBOutlet weak var playingWebView: UIWebView!

    @IBOutlet weak var tunesTable: UITableView!
    @IBOutlet weak var tunesIndicator: UIActivityIndicatorView!

    @IBOutlet weak var playOrStopButton: UIBarButtonItem!
    
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

        self.tunesTable.dataSource = self;
        self.tunesTable.delegate = self;

        // 押尾コータローの全曲を取得して登録
        self.player = MPMusicPlayerController.iPodMusicPlayer()
        self.query = MPMediaQuery.artistsQuery()
        var pred : MPMediaPropertyPredicate! = MPMediaPropertyPredicate(value:"押尾コータロー", forProperty:MPMediaItemPropertyArtist)
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
        self.changeTune()
    }
    
    func changeTune(){
        // 再生中の曲情報を取得
        let item = player.nowPlayingItem as MPMediaItem
        var titleString: String = item.valueForProperty(MPMediaItemPropertyTitle) as String
        var albumString: String = item.valueForProperty(MPMediaItemPropertyAlbumTitle) as String
        var tuning: String = self.tuneCollection.getTuningByTune(titleString, album: albumString)
        var tuningBase: String = self.tuneCollection.getTuningBaseByTune(titleString, album: albumString)
        
        if self.isAlbumMode {
            if self.playingAlbum == albumString{
                self.focusPlayingTuneInTunelist()
            }else{
                self.updateTunelistForAlbum()
            }
        }else{
            if self.playingTuningBase == tuningBase {
                self.focusPlayingTuneInTunelist()
            }else{
                self.updateTunelistForTuning()
            }
        }
        
        // 再生中の情報を更新
        self.playingTuningBase = tuningBase
        self.playingAlbum = albumString
        
        let artwork = item.valueForProperty(MPMediaItemPropertyArtwork) as MPMediaItemArtwork
        let aw_image = artwork.imageWithSize(CGSizeMake(80,80)) as UIImage // 90x90 にすると落ちるので 80x80にしている
        self.playingImageView?.image = aw_image
        self.playingTitleLabel.text = titleString
        self.playingTuningLabel.text = tuning
        
        self.playingWebView.loadHTMLString(
            self.youtubeConnector.getBlankHtml(60,height: 60),baseURL: nil)
        self.youtubeConnector.getYoutube(titleString, resultNum: 1, completionHandler: { youtubeData in
            if youtubeData.count > 0 {
                self.dispatch_async_main {
                    self.playingWebView.scrollView.scrollEnabled = false
                    self.playingWebView.scrollView.bounces = false
                    self.playingWebView.loadHTMLString(
                        self.youtubeConnector.getVideoHtml(youtubeData[0].url,width: 60,height: 60),
                        baseURL: nil)
                }
            }
        })
    }

    func focusPlayingTuneInTunelist(){
        let selectedIndex = self.tunesTable.indexPathForSelectedRow()
        if (selectedIndex != nil){
            var nextRow:Int = player.indexOfNowPlayingItem + self.playingRelateIndex
            if nextRow >= self.relateItems.count {
                nextRow -= self.relateItems.count
            }
            let currentIndexPath = NSIndexPath(forRow:nextRow, inSection:0)
            self.tunesTable.selectRowAtIndexPath(currentIndexPath, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
        }
    }
        
    func updateTunelistForTuning() {
        // テーブルをクリア
        self.relateItems = []
        self.tunesTable.reloadData()
        self.tunesIndicator.startAnimating()
        
        self.dispatch_async_global {
            // 別スレッド
            // チューニングが同じ曲をテーブルに表示
            var target_items = Array<AnyObject>()
            for item : AnyObject in self.query.items{
                var titleString: String = item.valueForProperty(MPMediaItemPropertyTitle) as String
                var albumString: String = item.valueForProperty(MPMediaItemPropertyAlbumTitle) as String
                if self.tuneCollection.isTuning(self.playingTuningBase, title: titleString, album: albumString){
                    target_items.append(item)
                }
            }
            
            self.dispatch_async_main {
                // UIスレッド
                self.relateItems = target_items
                
                // テーブルを更新
                self.tunesIndicator.stopAnimating()
                self.tunesTable.reloadData()
            }
        }
    }
    
    func updateTunelistForAlbum(){
        // テーブルをクリア
        self.relateItems = []
        self.tunesTable.reloadData()
        self.tunesIndicator.startAnimating()
        
        dispatch_async_global {
            // アルバムが同じ曲をテーブルに表示
            var target_items = Array<AnyObject>()
            for item : AnyObject in self.query.items{
                var titleString: String = item.valueForProperty(MPMediaItemPropertyTitle) as String
                var itemAlbumString: String = item.valueForProperty(MPMediaItemPropertyAlbumTitle) as String
                if itemAlbumString == self.playingAlbum {
                    target_items.append(item)
                }
            }
            
            self.dispatch_async_main {
                // UIスレッド
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
        self.isAlbumMode = false
        self.updateTunelistForTuning()
    }

    @IBAction func onClickAlbumButton(sender: AnyObject) {
        self.isAlbumMode = true
        self.updateTunelistForAlbum()
    }
    
    @IBAction func onClickYoutubeButton(sender: AnyObject) {
        performSegueWithIdentifier("youtube", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let item = player.nowPlayingItem as MPMediaItem
        var titleString: String = item.valueForProperty(MPMediaItemPropertyTitle) as String
        
        if segue.identifier == "youtube" {
            var youtubeController = segue.destinationViewController as YoutubeViewController
            youtubeController.playingTitle = titleString
        }
    }
    
}

