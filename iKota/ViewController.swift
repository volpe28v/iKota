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
    var relateTunes : Array<Tune>! = []
    var similarTunes : Array<Tune>! = []
    var playingTune : Tune? = nil
    var playingRelateIndex : Int!
    var isAlbumMode : Bool = false
    var youtubeConnector : YoutubeConnector! = YoutubeConnector()
    var sections: Array<String> = ["Same Tuning", "Similar Tuning"]

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
        
        for item : AnyObject in self.query.items{
            if (!self.tuneCollection.registItem(item)){
                var titleString: String = item.valueForProperty(MPMediaItemPropertyTitle) as String
                var albumString: String = item.valueForProperty(MPMediaItemPropertyAlbumTitle) as String
                println("unregist - " + titleString + " : " + albumString)
            }
        }

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

    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        if self.similarTunes.count == 0 {
            return 1;
        }else{
            return sections.count
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section] as String
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.relateTunes.count
        }else{
            return self.similarTunes.count
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
        
        var tune : Tune? = nil
        if indexPath.section == 0 {
            tune = self.relateTunes[indexPath.row]
        }else {
            tune = self.similarTunes[indexPath.row]
        }
        
        let item = tune!.item as MPMediaItem
        var titleString: String = tune!.title
        var albumString: String = tune!.album
        var tuningString: String = tune!.getTuningName()

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
        var tuneItems = Array<AnyObject>()
        if indexPath.section == 0 {
            for (i,tune : Tune) in enumerate(self.relateTunes as Array){
                if (i < indexPath.row){
                    tuneItems.append(tune.item!)
                }else if (i == indexPath.row){
                    tuneItems.insert(tune.item!,atIndex: 0)
                }else{
                    tuneItems.insert(tune.item!,atIndex: tuneItems.count - indexPath.row)
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
        }else{
            var tune = self.similarTunes[indexPath.row]
            tuneItems.insert(tune.item!,atIndex: 0)
        }
        
        // リストを再生
        var items = MPMediaItemCollection(items: tuneItems)
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
        var tune : Tune? = self.tuneCollection.getTuneByItem(item)
        if let t = tune {
            var titleString: String = t.title
            var albumString: String = t.album
            var tuning: String = self.tuneCollection.getTuningByTune(titleString, album: albumString)
            var tuningBase: String = self.tuneCollection.getTuningBaseByTune(titleString, album: albumString)
            
            var preAlbum = ""
            var preTuning = ""
            if let pt = self.playingTune {
                preAlbum = pt.album
                preTuning = pt.tuning
            }
            
            // 再生中の情報を更新
            self.playingTune = t

            if self.isAlbumMode {
                if preAlbum == albumString{
                    self.focusPlayingTuneInTunelist()
                }else{
                    self.updateTunelistForAlbum()
                }
            }else{
                if preTuning == tuningBase {
                    self.focusPlayingTuneInTunelist()
                }else{
                    self.updateTunelistForTuning()
                }
            }
            

            let artwork = item.valueForProperty(MPMediaItemPropertyArtwork) as MPMediaItemArtwork
            let aw_image = artwork.imageWithSize(CGSizeMake(80,80)) as UIImage // 90x90 にすると落ちるので 80x80にしている
            self.playingImageView?.image = aw_image
            self.playingTitleLabel.text = titleString
            self.playingAlbumLabel.text = albumString
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
        }else{
            // 該当曲なし
            return
        }
        
    }

    func focusPlayingTuneInTunelist(){
        let selectedIndex = self.tunesTable.indexPathForSelectedRow()
        if (selectedIndex != nil){
            var nextRow:Int = player.indexOfNowPlayingItem + self.playingRelateIndex
            if nextRow >= self.relateTunes.count {
                nextRow -= self.relateTunes.count
            }
            let currentIndexPath = NSIndexPath(forRow:nextRow, inSection:0)
            self.tunesTable.selectRowAtIndexPath(currentIndexPath, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
        }
    }
        
    func updateTunelistForTuning() {
        // テーブルをクリア
        self.relateTunes = []
        self.similarTunes = []
        self.tunesTable.reloadData()
        self.tunesIndicator.startAnimating()
        
        self.dispatch_async_global {
            // 別スレッド
            // チューニングが同じ曲をテーブルに表示
            var targetTunes = Array<Tune>()
            for tune : Tune in self.tuneCollection.activeTunes {
                if self.playingTune!.tuning == tune.tuning {
                    targetTunes.append(tune)
                }
            }
            
            var targetSimilarTunes = Array<Tune>()
            for tune : Tune in self.tuneCollection.activeTunes {
                let score = self.playingTune!.compareTuning(tune)
                if score >= 1 && score <= 3 {
                    targetSimilarTunes.append(tune)
                }
            }
            
            self.dispatch_async_main {
                // UIスレッド
                self.relateTunes = targetTunes
                self.similarTunes = targetSimilarTunes
                self.sections[0] = self.makeSectionText("Same Tuning - ", count: self.relateTunes.count)
                self.sections[1] = self.makeSectionText("Similar Tuning - ", count: self.similarTunes.count)

                // テーブルを更新
                self.tunesIndicator.stopAnimating()
                self.tunesTable.reloadData()
            }
        }
    }
    
    func makeSectionText(prefix: String, count: Int) -> String{
        var suffix : String = count <= 1 ? " tune" : " tunes"
        return prefix + String(count) + suffix
    }
    
    func updateTunelistForAlbum(){
        // テーブルをクリア
        self.relateTunes = []
        self.similarTunes = []
        self.tunesTable.reloadData()
        self.tunesIndicator.startAnimating()
        
        dispatch_async_global {
            // アルバムが同じ曲をテーブルに表示
            var targetTunes = Array<Tune>()
            for tune : Tune in self.tuneCollection.activeTunes {
                if tune.album == self.playingTune!.album {
                    targetTunes.append(tune)
                }
            }
            
            self.dispatch_async_main {
                // UIスレッド
                self.relateTunes = targetTunes
                self.sections[0] = self.makeSectionText("Album - ", count: self.relateTunes.count)
                
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
        var state = self.player.playbackState
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
    
    @IBAction func onClickAlbumsButton(sender: AnyObject) {
        performSegueWithIdentifier("search", sender: nil)
    }
}

