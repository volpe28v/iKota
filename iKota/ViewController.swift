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
    var ncenter : NotificationCenter!
    var tuneCollection : TuneCollection! = TuneCollection.sharedInstance
    var relateTunes : Array<Tune>! = []
    var similarTunes : Array<Tune>! = []
    var playingTune : Tune? = nil
    var isAlbumMode : Bool = true
    var youtubeConnector : YoutubeConnector! = YoutubeConnector()
    var youtubeData: Array<YoutubeInfo> = []

    var sections: Array<String> = ["Same Tuning", "Similar Tuning"]

    var displayAlbum : String?
    var displayTuneForTuning : Tune?
    var displayTuneForCount : Tune?
    
    @IBOutlet weak var playingImageView: UIImageView!
    @IBOutlet weak var playingTitleLabel: UILabel!
    @IBOutlet weak var playingTuningLabel: UILabel!
    @IBOutlet weak var playingAlbumLabel: UILabel!

    @IBOutlet weak var youtubeImage: UIImageView!
    @IBOutlet weak var listModeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tunesTable: UITableView!
    @IBOutlet weak var tunesIndicator: UIActivityIndicatorView!

    @IBOutlet weak var playOrStopButton: UIBarButtonItem!
    
    func dispatch_async_global(_ block: @escaping () -> ()) {
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: block)
    }
    
    func dispatch_async_main(_ block: @escaping () -> ()) {
        DispatchQueue.main.async(execute: block)
    }
    
    func setCurrentPlayOrStopButtonLabel(){
        switch (self.player.playbackState){
        case MPMusicPlaybackState.stopped,MPMusicPlaybackState.paused:
            self.playOrStopButton.title = "▶︎"
        case MPMusicPlaybackState.playing,MPMusicPlaybackState.interrupted,MPMusicPlaybackState.seekingForward,MPMusicPlaybackState.seekingBackward:
            self.playOrStopButton.title = "■"
        }
        
        if self.player.playbackState != MPMusicPlaybackState.stopped && self.player.playbackState != MPMusicPlaybackState.paused {
        }else{
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tunesTable.dataSource = self;
        self.tunesTable.delegate = self;

        // メディアライブラリへのアクセスを要求する
        MPMediaLibrary.requestAuthorization{ (authStatus) in
            self.buildPlayer()
        }
    }
    
    func buildPlayer(){
        // 押尾コータローの全曲を取得して登録
        self.tuneCollection.loadTunes()
        self.player = MPMusicPlayerController.systemMusicPlayer()
        
        // 再生変更通知を登録
        self.ncenter = NotificationCenter.default
        self.ncenter.addObserver(
            self,
            selector: #selector(ViewController.handle_NowPlayingItemChanged),   // 再生曲変更
            name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange,
            object: self.player
        )
        self.ncenter.addObserver(
            self,
            selector: #selector(ViewController.handle_PlaybackStateDidChanged), // 再生状態変更
            name: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange,
            object: self.player
        )
        
        self.player.beginGeneratingPlaybackNotifications()
        self.setCurrentPlayOrStopButtonLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if self.similarTunes.count == 0 {
            return 1;
        }else{
            return sections.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section] as String
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.relateTunes.count
        }else{
            return self.similarTunes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
        var cellTmp = tableView.dequeueReusableCell(withIdentifier: "tune") as UITableViewCell?
        
        if cellTmp == nil {
            cellTmp = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "tune")
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.lightGray
            cellTmp!.selectedBackgroundView = backgroundView
            cellTmp!.detailTextLabel?.textColor = UIColor.darkGray
        }
        
        let cell = cellTmp!
        
        var tune : Tune? = nil
        var upDown : String = ""
        if indexPath.section == 0 {
            tune = self.relateTunes[indexPath.row]
        }else {
            tune = self.similarTunes[indexPath.row]
            upDown = self.displayTuneForTuning!.getCompareUpDownTuning(tune!)
        }
        
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
        
        // 再生中マークを付ける
        let playingMark = cell.viewWithTag(4) as! UILabel
        if let pt = self.playingTune {
            if pt === tune! {
                playingMark.text = "▶︎"
            }else{
                playingMark.text = ""
            }
        }else{
            playingMark.text = ""
        }
        
        let playCount = cell.viewWithTag(5) as! UILabel
        let count = tune!.getPlayCount()
        if count > 0 {
            playCount.text = String(count)
        }else{
            playCount.text = ""
        }

        let upDownTuning = cell.viewWithTag(6) as! UILabel
        upDownTuning.text = upDown
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        var tuneItems = Array<MPMediaItem>()
        var tune : Tune? = nil
        if indexPath.section == 0 {
            // 選択曲を先頭にしたプレイリストを作成する
            for (i, tune): (Int, Tune) in (self.relateTunes as Array).enumerated(){
                if (i < indexPath.row){
                    tuneItems.append(tune.item! as! MPMediaItem)
                }else if (i == indexPath.row){
                    tuneItems.insert(tune.item! as! MPMediaItem,at: 0)
                }else{
                    tuneItems.insert(tune.item! as! MPMediaItem,at: tuneItems.count - indexPath.row)
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
            
            tune = self.relateTunes[indexPath.row]
        }else{
            // 選択された類似曲と同じチューニングのプレイリストを作成する
            tune = self.similarTunes[indexPath.row]

            var beforeItems = Array<MPMediaItem>()
            var afterItems = Array<MPMediaItem>()
            var isFound = false
            for activeTune : Tune in self.tuneCollection.activeTunes {
                if activeTune.compareTuning(tune!) == 0 {
                    if activeTune === tune! {
                        beforeItems.append(tune!.item! as! MPMediaItem)
                        isFound = true
                    }else if isFound {
                        beforeItems.append(activeTune.item! as! MPMediaItem)
                    }else{
                        afterItems.append(activeTune.item! as! MPMediaItem)
                    }
                }
            }

            tuneItems = beforeItems + afterItems
        }
        
        // リストを再生
        let items = MPMediaItemCollection(items: tuneItems)
        self.player.setQueue(with: items)
        self.player.shuffleMode = MPMusicShuffleMode.off
        self.player.repeatMode = MPMusicRepeatMode.all       //全曲でリピート
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
        let item = player.nowPlayingItem as MPMediaItem!
        let tune : Tune? = self.tuneCollection.getTuneByItem(item!)
        if let t = tune {
            let titleString: String = t.title
            let albumString: String = t.album
            let tuning: String = self.tuneCollection.getTuningByTune(titleString, album: albumString)
            print(titleString)
            
            self.playingTune = t

            if self.isAlbumMode {
                if self.displayAlbum == albumString{
                    self.tunesTable.reloadData()
                }else{
                    self.displayAlbum = albumString
                    self.updateTunelistForAlbum()
                }
            }else{
                if self.displayTuneForTuning?.compareTuning(t) == 0 {
                    self.tunesTable.reloadData()
                }else{
                    self.displayTuneForTuning = t
                    self.updateTunelistForTuning()
                }
                /*
                if let pt = preTune {
                    if t.compareTuning(pt) == 0 {
                        self.tunesTable.reloadData()
                    }else{
                        self.updateTunelistForTuning()
                    }
                }else{
                    self.updateTunelistForTuning()
                }
                */
            }

            if let artwork = item?.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork {
                let aw_image = artwork.image(at: CGSize(width: 80,height: 80))! as UIImage // 90x90 にすると落ちるので 80x80にしている
                self.playingImageView?.image = aw_image
            }
            self.playingTitleLabel.text = titleString
            self.playingAlbumLabel.text = albumString
            self.playingTuningLabel.text = tuning
            
            self.youtubeConnector.getYoutube(titleString, resultNum: 10, completionHandler: { youtubeData in
                if youtubeData.count > 0 {
                    self.dispatch_async_main {
                        self.youtubeData = youtubeData
                        let youtube = youtubeData[0]
                        let imgData: Data
                        
                        do {
                            let thumbnail = URL(string: youtube.thumbnail);
                            imgData = try Data(contentsOf: thumbnail!,options: NSData.ReadingOptions.mappedIfSafe)
                            self.youtubeImage.image = UIImage(data:imgData);
                        } catch {
                            print("Error: can't create image.")
                        }

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
            self.displayTuneForTuning = pt
            
            self.dispatch_async_global {
                // 別スレッド
                // チューニングが同じ曲をテーブルに表示
                let targetTunes = self.tuneCollection.getSameTuningTunes(pt)
                let targetSimilarTunes = self.tuneCollection.getSimilarTuningTunes(pt)
                
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
    
    func makeSectionText(_ prefix: String, count: Int) -> String{
        let suffix : String = count <= 1 ? " tune" : " tunes"
        return prefix + String(count) + suffix
    }
    
    func updateTunelistForAlbum(){
        if let pt = self.playingTune {
            // テーブルをクリア
            self.relateTunes = []
            self.similarTunes = []
            self.tunesTable.reloadData()
            self.tunesIndicator.startAnimating()
            self.displayAlbum = pt.album
            
            dispatch_async_global {
                // アルバムが同じ曲をテーブルに表示
                let targetTunes = self.tuneCollection.getSameAlbumTunes(pt.album)
                
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

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch: UITouch in touches {
            let tag = touch.view!.tag
            switch tag {
            case 10:    // youtube画像をタップ
                performSegue(withIdentifier: "youtubePlayer", sender: nil)

            default:
                break
            }
        }
    }
    
    @IBAction func onClickPlayOrStopButton(_ sender: AnyObject) {
        _ = self.player.playbackState
        if self.player.playbackState == MPMusicPlaybackState.playing {
            self.playOrStopButton.title = "▶︎"
            self.player.pause()
        }else{
            self.playOrStopButton.title = "■"
            self.player.play()
        }
    }
    
    @IBAction func onClickRewindButton(_ sender: AnyObject) {
        self.player.skipToPreviousItem()
    }
    
    @IBAction func onClickForwardButton(_ sender: AnyObject) {
        self.player.skipToNextItem()
    }
    
    @IBAction func onClickShuffleButton(_ sender: AnyObject) {
        var targetItems = Array<MPMediaItem>()
        for tune : Tune in self.tuneCollection.activeTunes {
            targetItems.append(tune.item! as! MPMediaItem)
        }

        let items = MPMediaItemCollection(items: targetItems)
        self.player.setQueue(with: items)
        self.player.shuffleMode = MPMusicShuffleMode.songs
        self.player.repeatMode = MPMusicRepeatMode.all       //全曲でリピート
        self.player.play()
    }
    
    @IBAction func onClickTuningButton(_ sender: AnyObject) {
        self.isAlbumMode = false
        self.updateTunelistForTuning()
    }

    @IBAction func onClickAlbumButton(_ sender: AnyObject) {
        self.isAlbumMode = true
        self.updateTunelistForAlbum()
    }
    
    @IBAction func onClickYoutubeButton(_ sender: AnyObject) {
        performSegue(withIdentifier: "youtube", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "youtube" {
            if let item = self.player.nowPlayingItem as MPMediaItem? {
                let titleString: String = item.value(forProperty: MPMediaItemPropertyTitle) as! String
                let youtubeController = segue.destination as! YoutubeViewController
                youtubeController.playingTitle = titleString
            }
        }
        
        if segue.identifier == "youtubePlayer" {
            let youtubeController = segue.destination as! YoutubePlayerViewController
            youtubeController.youtubeData = self.youtubeData
            youtubeController.youtubeIndex = 0
        }

    }
    
    @IBAction func onClickAlbumsButton(_ sender: AnyObject) {
        performSegue(withIdentifier: "search", sender: nil)
    }
    
    @IBAction func onClickListMode(_ sender: UISegmentedControl) {
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
    
    @IBAction func playListReturnActionForSegue(_ segue: UIStoryboardSegue) {
        if let album = self.displayAlbum {
            self.relateTunes = []
            self.similarTunes = []
            self.tunesTable.reloadData()
            self.tunesIndicator.startAnimating()

            dispatch_async_global {
                let targetTunes = self.tuneCollection.getSameAlbumTunes(album)

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
    
    @IBAction func playListReturnActionWiteTuningForSegue(_ segue: UIStoryboardSegue) {
        if let dt = self.displayTuneForTuning {
            self.relateTunes = []
            self.similarTunes = []
            self.tunesTable.reloadData()
            self.tunesIndicator.startAnimating()
            
            dispatch_async_global {
                // チューニングが同じ曲をテーブルに表示
                let targetTunes = self.tuneCollection.getSameTuningTunes(dt)
                let targetSimilarTunes = self.tuneCollection.getSimilarTuningTunes(dt)

                self.dispatch_async_main {
                    // UIスレッド
                    self.isAlbumMode = false
                    self.listModeSegmentedControl.selectedSegmentIndex = 1
                    self.relateTunes = targetTunes
                    self.similarTunes = targetSimilarTunes
                    self.sections[0] = self.makeSectionText(dt.getTuningName() + " - ", count: self.relateTunes.count)
                    self.sections[1] = self.makeSectionText("Similar Tuning - ", count: self.similarTunes.count)

                    // テーブルを更新
                    self.tunesIndicator.stopAnimating()
                    self.tunesTable.reloadData()
                }
            }
        }
    }

    @IBAction func playListReturnActionWiteTuneCountForSegue(_ segue: UIStoryboardSegue) {
        // 再生回数の多い上位曲を選択された曲から再生開始する
        if let dt = self.displayTuneForCount {
            var targetItems = Array<MPMediaItem>()
            var beforeItems = Array<MPMediaItem>()
            var afterItems = Array<MPMediaItem>()
            var isFound = false
            for activeTune : Tune in self.tuneCollection.getUpperLevelCountTunes() {
                if activeTune === dt {
                    beforeItems.append(dt.item! as! MPMediaItem)
                    isFound = true
                }else if isFound {
                    beforeItems.append(activeTune.item! as! MPMediaItem)
                }else{
                    afterItems.append(activeTune.item! as! MPMediaItem)
                }
            }
            
            targetItems = beforeItems + afterItems

            let items = MPMediaItemCollection(items: targetItems)
            self.player.setQueue(with: items)
            self.player.shuffleMode = MPMusicShuffleMode.off
            self.player.repeatMode = MPMusicRepeatMode.all       //全曲でリピート
            self.player.play()
            
            dt.addPlayCount()
        }
    }

}
