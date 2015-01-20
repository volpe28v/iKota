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
    var ncenter : NSNotificationCenter!
    var tuneCollection : TuneCollection! = TuneCollection.sharedInstance
    var relateTunes : Array<Tune>! = []
    var similarTunes : Array<Tune>! = []
    var playingTune : Tune? = nil
    var playingBeginingRelateIndex : Int!
    var isAlbumMode : Bool = true
    var youtubeConnector : YoutubeConnector! = YoutubeConnector()
    var sections: Array<String> = ["Same Tuning", "Similar Tuning"]

    var displayAlbum : String?
    
//    var avplayer : AVAudioPlayer!
    
    @IBOutlet weak var playingImageView: UIImageView!
    @IBOutlet weak var playingTitleLabel: UILabel!
    @IBOutlet weak var playingTuningLabel: UILabel!
    @IBOutlet weak var playingAlbumLabel: UILabel!
    @IBOutlet weak var playingWebView: UIWebView!

    @IBOutlet weak var listModeSegmentedControl: UISegmentedControl!
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
            self.playOrStopButton.title = "▶︎"
        case MPMusicPlaybackState.Playing,MPMusicPlaybackState.Interrupted,MPMusicPlaybackState.SeekingForward,MPMusicPlaybackState.SeekingBackward:
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
        var upDown : String = ""
        if indexPath.section == 0 {
            tune = self.relateTunes[indexPath.row]
        }else {
            tune = self.similarTunes[indexPath.row]
            upDown = tune!.getCompareUpDownTuning(self.playingTune!)
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
        
        // 再生中マークを付ける
        var playingMark = cell.viewWithTag(4) as UILabel
        if let pt = self.playingTune {
            if pt === tune! {
                playingMark.text = "▶︎"
            }else{
                playingMark.text = ""
            }
        }else{
            playingMark.text = ""
        }
        
        var playCount = cell.viewWithTag(5) as UILabel
        let count = tune!.getPlayCount()
        if count > 0 {
            playCount.text = String(count)
        }else{
            playCount.text = ""
        }

        var upDownTuning = cell.viewWithTag(6) as UILabel
        upDownTuning.text = upDown
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath!) {
        var tuneItems = Array<AnyObject>()
        var tune : Tune? = nil
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
            
            self.playingBeginingRelateIndex = indexPath.row
            tune = self.relateTunes[indexPath.row]
        }else{
            tune = self.similarTunes[indexPath.row]
            tuneItems.insert(tune!.item!,atIndex: 0)
        }
        
        // リストを再生
        var items = MPMediaItemCollection(items: tuneItems)
        self.player.setQueueWithItemCollection(items)
        self.player.shuffleMode = MPMusicShuffleMode.Off
        self.player.repeatMode = MPMusicRepeatMode.All       //全曲でリピート
        self.player.play()
        
        // 選択した曲の再生回数をDBに保存する
        tune!.addPlayCount()
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
                preTuning = pt.tuning
            }
            
            // 再生中の情報を更新
            self.playingTune = t

            if self.isAlbumMode {
                if self.displayAlbum == albumString{
                    self.tunesTable.reloadData()
                }else{
                    self.displayAlbum = albumString
                    self.updateTunelistForAlbum()
                }
            }else{
                if preTuning == tuningBase {
                    self.tunesTable.reloadData()
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

    func updateTunelistForTuning() {
        if let pt = self.playingTune {
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
                    if pt.tuning == tune.tuning {
                        targetTunes.append(tune)
                    }
                }
                
                var targetSimilarTunes = Array<Tune>()
                for tune : Tune in self.tuneCollection.activeTunes {
                    let score = pt.compareTuning(tune)
                    if score >= 1 && score <= 3 {
                        targetSimilarTunes.append(tune)
                    }
                }
                
                self.dispatch_async_main {
                    // UIスレッド
                    self.relateTunes = targetTunes
                    self.similarTunes = targetSimilarTunes
                    self.sections[0] = self.makeSectionText(self.playingTune!.getTuningName() + " - ", count: self.relateTunes.count)
                    self.sections[1] = self.makeSectionText("Similar Tuning - ", count: self.similarTunes.count)
                    
                    // テーブルを更新
                    self.tunesIndicator.stopAnimating()
                    self.tunesTable.reloadData()
                }
            }
        }
    }
    
    func makeSectionText(prefix: String, count: Int) -> String{
        var suffix : String = count <= 1 ? " tune" : " tunes"
        return prefix + String(count) + suffix
    }
    
    func updateTunelistForAlbum(){
        if let pt = self.playingTune {
            // テーブルをクリア
            self.relateTunes = []
            self.similarTunes = []
            self.tunesTable.reloadData()
            self.tunesIndicator.startAnimating()
            
            dispatch_async_global {
                // アルバムが同じ曲をテーブルに表示
                var targetTunes = Array<Tune>()
                for tune : Tune in self.tuneCollection.activeTunes {
                    if tune.album == pt.album {
                        targetTunes.append(tune)
                    }
                }
                
                self.dispatch_async_main {
                    // UIスレッド
                    self.relateTunes = targetTunes
                    self.sections[0] = self.makeSectionText("", count: self.relateTunes.count)
                    
                    // テーブルを更新
                    self.tunesIndicator.stopAnimating()
                    self.tunesTable.reloadData()
                }
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
        var targetItems = Array<AnyObject>()
        for tune : Tune in self.tuneCollection.activeTunes {
            targetItems.append(tune.item!)
        }

        var items = MPMediaItemCollection(items: targetItems)
        self.player.setQueueWithItemCollection(items)
        self.player.shuffleMode = MPMusicShuffleMode.Songs
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
        
        if segue.identifier == "youtube" {
            if let item = self.player.nowPlayingItem as MPMediaItem? {
                var titleString: String = item.valueForProperty(MPMediaItemPropertyTitle) as String
                var youtubeController = segue.destinationViewController as YoutubeViewController
                youtubeController.playingTitle = titleString
            }
        }
    }
    
    @IBAction func onClickAlbumsButton(sender: AnyObject) {
        performSegueWithIdentifier("search", sender: nil)
    }
    
    @IBAction func onClickListMode(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            self.isAlbumMode = true
            self.updateTunelistForAlbum()
        case 1:
            self.isAlbumMode = false
            self.updateTunelistForTuning()
        default:
            break; 
        }
    }
    
    @IBAction func playListReturnActionForSegue(segue: UIStoryboardSegue) {
        if let album = self.displayAlbum {
            self.relateTunes = []
            self.similarTunes = []
            self.tunesTable.reloadData()
            self.tunesIndicator.startAnimating()

            dispatch_async_global {
                var targetItems = Array<AnyObject>()
                var targetTunes = Array<Tune>()
                for tune : Tune in self.tuneCollection.activeTunes {
                    if tune.album == album {
                        targetItems.append(tune.item!)
                        targetTunes.append(tune)
                    }
                }
                self.playingBeginingRelateIndex = 0

                self.dispatch_async_main {
                    // UIスレッド
                    self.isAlbumMode = true
                    self.listModeSegmentedControl.selectedSegmentIndex = 0
                    self.relateTunes = targetTunes
                    self.sections[0] = self.makeSectionText("", count: self.relateTunes.count)
                    
                    // テーブルを更新
                    self.tunesIndicator.stopAnimating()
                    self.tunesTable.reloadData()
                }
            }
        }
    }
}
