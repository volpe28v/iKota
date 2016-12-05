//
//  YoutubePlayerViewController.swift
//  iKota
//
//  Created by Naoki KODAMA on 2016/08/23.
//  Copyright © 2016年 Naoki KODAMA. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class YoutubePlayerViewController: UIViewController, YTPlayerViewDelegate {
    var youtube: YoutubeInfo = YoutubeInfo()
    var youtubeData: Array<YoutubeInfo> = []
    var youtubeIndex: Int = 0
    
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var playModeSegment: UISegmentedControl!
    
    func dispatch_async_main(_ block: @escaping () -> ()) {
        DispatchQueue.main.async(execute: block)
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.delegate = self;

        playYoutubeWithIndex(self.youtubeIndex)
    }
    
    func playYoutubeWithIndex(_ index: Int){
        let youtube = self.youtubeData[index]
        self.playerView.load(withVideoId: youtube.videoId, playerVars: ["playsinline":1])
        self.titleLabel.text = youtube.title
        self.authorLabel.text = youtube.author
        self.descriptionLabel.text = youtube.description
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IBAction
    @IBAction func tapNext(_ sender: AnyObject) {
        self.youtubeIndex += 1
        if (self.youtubeIndex >= self.youtubeData.count){
            self.youtubeIndex = 0
        }
        
        playYoutubeWithIndex(self.youtubeIndex)
    }
    @IBAction func tapPrev(_ sender: AnyObject) {
        self.youtubeIndex -= 1
        if (self.youtubeIndex < 0){
            self.youtubeIndex = self.youtubeData.count - 1
        }
        
        playYoutubeWithIndex(self.youtubeIndex)
    }
    @IBAction func tapPlay(_ sender: AnyObject) {
        self.playerView.playVideo()
    }
    @IBAction func tapPause(_ sender: AnyObject) {
        self.playerView.pauseVideo()
    }
    @IBAction func tapStop(_ sender: AnyObject) {
        self.playerView.stopVideo()
    }

    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.playerView.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch (state) {
        case YTPlayerState.unstarted:
            break
        case YTPlayerState.playing:
            break
        case YTPlayerState.paused:
            break
        case YTPlayerState.buffering:
            break
        case YTPlayerState.ended:
            switch(self.playModeSegment.selectedSegmentIndex){
            case 0:
                self.playerView.playVideo()
                break;
            case 1:
                self.youtubeIndex += 1
                if (self.youtubeIndex >= self.youtubeData.count){
                    self.youtubeIndex = 0
                }
                
                playYoutubeWithIndex(self.youtubeIndex)
                break;
            default:
                break;
            }

            break
        default:
            break
        }
    }
}
