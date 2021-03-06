//
//  TuneCollection.swift
//  iKota
//
//  Created by Naoki KODAMA on 2015/01/04.
//  Copyright (c) 2015年 Naoki KODAMA. All rights reserved.
//

import Foundation
import MediaPlayer

class Tune {
    var title: String
    var album: String
    var tuning: String
    var capo: Int
    var pitches: [Int] = []
    let basePitches: [Int] = [7,0,5,10,2,7] // 6弦から最低音高 G C F A# D G
    var item: AnyObject?
    
    init(album: String, title: String, tuning: String, capo: Int){
        self.album = album
        self.title = title
        self.tuning = tuning
        self.capo = capo
        self.pitches = self.parseTuning(tuning)
    }
    
    // チューニング + capo を取得
    func getTuningName() -> String {
        if self.capo == 0 {
            return self.tuning
        }else{
            return self.tuning + " " + String(self.capo) + "capo"
        }
    }
    
    func compareTuning(_ target: Tune) -> Int
    {
        if (self.pitches.count != 6 || target.pitches.count != 6) {
            return 100
        }
        
        // 結果を判断
        var result : [Int] = [0,0,0,0,0,0]
        var score = 0
        var sameDistance = true
        for i in 0..<6 {
            result[i] = target.pitches[i] - self.pitches[i]
            if (result[i] != 0){
                score += 1
            }
            if (i > 0 && result[i-1] != result[i]){
                sameDistance = false
            }
        }
        
        if (sameDistance){
            score = abs(result[0])
        }
        return score
    }

    func getCompareUpDownTuning(_ target: Tune) -> String
    {
        if (self.pitches.count != 6 || target.pitches.count != 6) {
            return ""
        }
        
        // 結果を判断
        var upDownResult : String = ""
        for i in 0..<6 {
            let result = target.pitches[i] - self.pitches[i]
            if result == 0 {
                upDownResult += "ー"
            }else if result > 0 {
                upDownResult += "↑"
            }else{
                upDownResult += "↓"
            }
        }
        return upDownResult
    }

    //音程を数字に変換
    func convPitchToInt(_ pitch: String, index: Int) -> Int {
        var pitchNumber: Int = 0
        switch pitch {
        case "C","B#" :
            pitchNumber = 0
        case "C#", "Db" :
            pitchNumber = 1
        case "D" :
            pitchNumber = 2
        case "D#", "Eb" :
            pitchNumber = 3
        case "E" :
            pitchNumber = 4
        case "F" :
            pitchNumber = 5
        case "F#","Gb" :
            pitchNumber = 6
        case "G" :
            pitchNumber = 7
        case "G#","Ab" :
            pitchNumber = 8
        case "A" :
            pitchNumber = 9
        case "A#","Bb" :
            pitchNumber = 10
        case "B" :
            pitchNumber = 11
        default :
            return 99
        }
        pitchNumber -= self.basePitches[index]
        if pitchNumber < 0 {
            pitchNumber += 12
        }
        
        return pitchNumber
    }
    
    // チューニングの類似度を求めるプログラム
    func parseTuning(_ source : String) -> [Int]{
        var baseTuning = source
        if baseTuning == "Standard" {
            baseTuning = "EADGBE"
        }
        
        // parseする。分割して配列に入れる
        var source_array : [Int] = []
        let length = baseTuning.characters.count
        
        var pitch_index : Int  = 0
        for i in (0 ..< length){
            let current_pitch: Character = source[source.characters.index(source.startIndex, offsetBy: i)]
            // #かbの場合は含めて確定する
            if (current_pitch == "#" || current_pitch == "b"){
                let pitchString: String = source[(source.characters.index(source.startIndex, offsetBy: i-1) ..< source.characters.index(source.startIndex, offsetBy: i+1))]
                source_array.append(convPitchToInt(pitchString, index: pitch_index))
                pitch_index += 1
            }else{
                if (i > 0){
                    let pre_pitch: Character = source[source.characters.index(source.startIndex, offsetBy: i-1)]
                    if (pre_pitch != "#" && pre_pitch != "b")
                    {
                        let pitchString: String = source[(source.characters.index(source.startIndex, offsetBy: i-1) ..< source.characters.index(source.startIndex, offsetBy: i))]
                        source_array.append(convPitchToInt(pitchString, index: pitch_index))
                        pitch_index += 1
                    }
                    
                    if (i == length - 1){
                        let pitchString: String = source[(source.characters.index(source.startIndex, offsetBy: i) ..< source.characters.index(source.startIndex, offsetBy: i+1))]
                        source_array.append(convPitchToInt(pitchString, index: pitch_index))
                        pitch_index += 1
                    }
                }
            }
        }
        return source_array
    }
    
    func addPlayCount(){
        let ud = UserDefaults.standard
        let count = ud.integer(forKey: album + ":" + title)
        ud.set(count + 1, forKey: album + ":" + title)
    }
    
    func getPlayCount() -> Int{
        let ud = UserDefaults.standard
        return ud.integer(forKey: album + ":" + title)
    }
}

class TuneCollection {
    
    // シングルトン化
    class var sharedInstance :TuneCollection {
        struct Static {
            static let instance = TuneCollection()
        }
        return Static.instance
    }
    
    var tunes: [Tune] = []
    var activeTunes: [Tune] = []
    var activeAlbums: [Tune] = []
    var activeTunings: [Tune] = []
    
    fileprivate init(){
        self.tunes = []
        self.tunes.append(Tune(album:"KTR×GTR", title:"Creativetime Ragtime", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"KTR×GTR", title:"Together !!!", tuning:"AAEF#AE", capo: 0))
        self.tunes.append(Tune(album:"KTR×GTR", title:"同級生 ～Innocent Days～", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"KTR×GTR", title:"my best season", tuning:"BEADF#B", capo: 0))
        self.tunes.append(Tune(album:"KTR×GTR", title:"風と空のワルツ", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"KTR×GTR", title:"えんぴつと五線譜", tuning:"Standard", capo: 5))
        self.tunes.append(Tune(album:"KTR×GTR", title:"蜃気楼", tuning:"CGDGBbD", capo: 0))
        self.tunes.append(Tune(album:"KTR×GTR", title:"茜色のブランコ", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"KTR×GTR", title:"Moment", tuning:"AEEF#BE", capo: 0))
        self.tunes.append(Tune(album:"KTR×GTR", title:"JOKER", tuning:"BEADF#B", capo: 0))
        self.tunes.append(Tune(album:"KTR×GTR", title:"勿忘草", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"KTR×GTR", title:"Birthday", tuning:"C#G#EF#BE", capo: 0))
        self.tunes.append(Tune(album:"KTR×GTR", title:"Plastic Love", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"KTR×GTR", title:"BE UP !", tuning:"GGDGAD", capo: 0))
        self.tunes.append(Tune(album:"KTR×GTR", title:"Magical Beautiful Seasons feat.DEPAPEPE&NAOTO", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"KTR×GTR", title:"同級生 with Yuuki Ozaki(from Galileo Galilei)", tuning:"Standard", capo: 0))

        self.tunes.append(Tune(album:"Tussie mussie II ～loves cinema～", title:"Melody Fair", tuning:"CGDGBD", capo: 3))
        self.tunes.append(Tune(album:"Tussie mussie II ～loves cinema～", title:"Shape Of My Heart", tuning:"CGBGBD", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie II ～loves cinema～", title:"Mission Impossible Theme", tuning:"C#G#EF#BE", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie II ～loves cinema～", title:"The Never Ending Story", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie II ～loves cinema～", title:"風の谷のナウシカ", tuning:"FCGCEG", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie II ～loves cinema～", title:"Stand By Me", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie II ～loves cinema～", title:"The Last Emperor", tuning:"BEDGBE", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie II ～loves cinema～", title:"Calling You", tuning:"BF#DEAD", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie II ～loves cinema～", title:"Ben", tuning:"C#G#EF#BE", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie II ～loves cinema～", title:"The Godfather Medley", tuning:"CGDGBbD", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie II ～loves cinema～", title:"Smile", tuning:"DADGBE", capo: 0))

        self.tunes.append(Tune(album:"PANDORA", title:"In the beginning", tuning:"CGDGBbD", capo: 0))
        self.tunes.append(Tune(album:"PANDORA", title:"彼方へ", tuning:"C#G#EF#BE", capo: 0))
        self.tunes.append(Tune(album:"PANDORA", title:"いつか君と", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"PANDORA", title:"誘惑", tuning:"CGDGBbEb", capo: 0))
        self.tunes.append(Tune(album:"PANDORA", title:"月のナミダ", tuning:"DADF#BD", capo: 0))
        self.tunes.append(Tune(album:"PANDORA", title:"亡き王女のためのパヴァーヌ", tuning:"AECF#BD", capo: 0))
        self.tunes.append(Tune(album:"PANDORA", title:"恋の夢", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"PANDORA", title:"キラキラ", tuning:"Standard", capo: 5))
        self.tunes.append(Tune(album:"PANDORA", title:"Legend ～時の英雄たち～", tuning:"GGDGAD", capo: 0))
        self.tunes.append(Tune(album:"PANDORA", title:"Marble", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"PANDORA", title:"タイムカプセル", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"PANDORA", title:"星の贈り物", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"PANDORA", title:"NOW OR NEVER", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"PANDORA", title:"美しき人生", tuning:"Standard", capo: 0))
        
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 1]", title:"Ready, Go!", tuning:"AAEGAE", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 1]", title:"One Love, ～T's theme～", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 1]", title:"Weather Report", tuning:"DAEF#BE", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 1]", title:"nanairo", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 1]", title:"Midnight Rain", tuning:"BBDF#BD", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 1]", title:"MISSION", tuning:"CGEbFBbEb", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 1]", title:"キミノコト", tuning:"C#G#EF#BE", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 1]", title:"STEALTH", tuning:"C#G#EF#BE", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 1]", title:"Kiwi & Avocado", tuning:"Standard", capo: 0))
        
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 2]", title:"瞳をとじて", tuning:"", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 2]", title:"IF YOU WANT", tuning:"", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 2]", title:"時の過ぎゆくままに", tuning:"", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 2]", title:"瞳をとじれば", tuning:"", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 2]", title:"... & Smile", tuning:"", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 2]", title:"Smile Blue", tuning:"", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 2]", title:"Shape Of My Heart", tuning:"", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 2]", title:"ナイト・ウェイブ [Live]", tuning:"", capo: 0))

        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"MOTHER", tuning:"C#G#EF#BE", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"黄昏", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"Merry Christmas Mr.Lawrence", tuning:"DADGAC", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"Misty Night", tuning:"EADGBD", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"天使の日曜日", tuning:"EbBbEbAbCbEb", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"ナユタ", tuning:"C#G#D#G#CD#", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"風の詩", tuning:"DADGBE", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"DREAMING", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"オアシス", tuning:"AEEF#BE", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"桜・咲くころ", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"日曜日のビール", tuning:"GCFBbDG", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"木もれ陽", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"Earth Angel", tuning:"AEEF#BE", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"ずっと...", tuning:"Standard", capo: 0))
        
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side", title:"翼 〜Hoping For The Future〜", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side", title:"Hard Rain", tuning:"GGDGGD", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side", title:"Relation!", tuning:"DADF#AE", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side", title:"Landscape", tuning:"CGDGBD", capo: 3))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side", title:"Over Drive", tuning:"AAEEAE", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side", title:"Fantasy!", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side", title:"Tension", tuning:"CGDGBbD", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side", title:"Pink Candy", tuning:"BBDG#BF#", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side", title:"太陽のダンス", tuning:"AEEF#BE", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side", title:"Treasure", tuning:"DADGBD", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side", title:"Snappy!", tuning:"AAEGAE", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side", title:"Heart Beat!", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side", title:"Big Blue Ocean", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side", title:"Jet", tuning:"GGDGAC", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side", title:"Rushin'", tuning:"AAEGAE", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side", title:"ファイト!", tuning:"BEADF#B", capo: 0))

        self.tunes.append(Tune(album:"Hand to Hand", title:"Brand New Wings", tuning:"C#G#EF#BE", capo: 0))
        self.tunes.append(Tune(album:"Hand to Hand", title:"Jet", tuning:"GGDGAC", capo: 0))
        self.tunes.append(Tune(album:"Hand to Hand", title:"雨上がり", tuning:"EbBbEbAbBbEb", capo: 0))
        self.tunes.append(Tune(album:"Hand to Hand", title:"手のひら", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Hand to Hand", title:"Good Times", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"Hand to Hand", title:"fly to the dream", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"Hand to Hand", title:"Over Drive", tuning:"AAEEAE", capo: 0))
        self.tunes.append(Tune(album:"Hand to Hand", title:"Little Prayer", tuning:"GCFBbDG", capo: 0))
        self.tunes.append(Tune(album:"Hand to Hand", title:"草笛", tuning:"DADF#BD", capo: 0))
        self.tunes.append(Tune(album:"Hand to Hand", title:"予感", tuning:"CGDGBbD", capo: 0))
        self.tunes.append(Tune(album:"Hand to Hand", title:"もっと強く", tuning:"BAbDbGbBbEb", capo: 0))
        self.tunes.append(Tune(album:"Hand to Hand", title:"ナユタ", tuning:"C#G#D#G#CD#", capo: 0))
        self.tunes.append(Tune(album:"Hand to Hand", title:"HEART BEAT!", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Hand to Hand", title:"Go Ahead", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"Hand to Hand", title:"また明日。", tuning:"Standard", capo: 0))
        
        self.tunes.append(Tune(album:"Eternal Chain", title:"Prelude ～sunrise～", tuning:"CGDGBD", capo: 3))
        self.tunes.append(Tune(album:"Eternal Chain", title:"Landscape", tuning:"CGDGBD", capo: 3))
        self.tunes.append(Tune(album:"Eternal Chain", title:"Road Goes On", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"Eternal Chain", title:"Always", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Eternal Chain", title:"Interlude ～forestbeat～", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Eternal Chain", title:"Snappy!", tuning:"AAEGAE", capo: 0))
        self.tunes.append(Tune(album:"Eternal Chain", title:"旅の途中", tuning:"C#G#EF#BE", capo: 0))
        self.tunes.append(Tune(album:"Eternal Chain", title:"Interlude ～sunshine～", tuning:"C#G#D#G#CD#", capo: 0))
        self.tunes.append(Tune(album:"Eternal Chain", title:"楽園", tuning:"C#G#D#G#CD#", capo: 0))
        self.tunes.append(Tune(album:"Eternal Chain", title:"日曜日のビール", tuning:"Standard", capo: 3))
        self.tunes.append(Tune(album:"Eternal Chain", title:"Believe", tuning:"CGDGBD", capo: 2))
        self.tunes.append(Tune(album:"Eternal Chain", title:"Interlude ～starlight～", tuning:"C#G#EF#BE", capo: 0))
        self.tunes.append(Tune(album:"Eternal Chain", title:"絆", tuning:"C#G#EF#BE", capo: 0))
        self.tunes.append(Tune(album:"Eternal Chain", title:"Earth Angel", tuning:"AEEF#BE", capo: 0))
        self.tunes.append(Tune(album:"Eternal Chain", title:"ハピネス", tuning:"GCFBbDG", capo: 0))
        self.tunes.append(Tune(album:"Eternal Chain", title:"Coda ～sunset～", tuning:"CGDGBD", capo: 3))

        self.tunes.append(Tune(album:"Tussie mussie", title:"LOVIN' YOU", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie", title:"CLOSE TO YOU", tuning:"C#G#D#G#B#D#", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie", title:"そして僕は途方に暮れる", tuning:"C#G#D#G#B#D#", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie", title:"元気を出して", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie", title:"FIRST LOVE", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie", title:"CAN'T TAKE MY EYES OFF OF YOU ～君の瞳に恋してる～", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie", title:"SOMEDAY", tuning:"C#G#C#F#A#C#", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie", title:"TIME AFTER TIME", tuning:"C#G#D#G#B#D#", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie", title:"涙のキッス", tuning:"C#G#D#G#B#D#", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie", title:"LOVE", tuning:"Standard", capo: 0))

        self.tunes.append(Tune(album:"Nature Spirit", title:"Deep Silence", tuning:"AAEGAE", capo: 0))
        self.tunes.append(Tune(album:"Nature Spirit", title:"Rushin'", tuning:"AAEGAE", capo: 0))
        self.tunes.append(Tune(album:"Nature Spirit", title:"DREAMING", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Nature Spirit", title:"My Home Town", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Nature Spirit", title:"TREASURE (アルバム・バージョン)", tuning:"DADGBD", capo: 0))
        self.tunes.append(Tune(album:"Nature Spirit", title:"Buzzer Beater", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"Nature Spirit", title:"ノスタルジア", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Nature Spirit", title:"永遠の青い空", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Nature Spirit", title:"Hangover", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Nature Spirit", title:"PEACE!", tuning:"DADGBD", capo: 0))
        self.tunes.append(Tune(album:"Nature Spirit", title:"スマイル", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Nature Spirit", title:"Christmas Rose", tuning:"CGDGBD", capo: 0))

        self.tunes.append(Tune(album:"COLOR of LIFE", title:"Big Blue Ocean", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"COLOR of LIFE", title:"YELLOW SUNSHINE", tuning:"GGDGGD", capo: 0))
        self.tunes.append(Tune(album:"COLOR of LIFE", title:"Indigo Love", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"COLOR of LIFE", title:"Red Shoes Dance", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"COLOR of LIFE", title:"クリスタル", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"COLOR of LIFE", title:"グリーンスリーブス", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"COLOR of LIFE", title:"ブラックモンスター", tuning:"DADGAC", capo: 0))
        self.tunes.append(Tune(album:"COLOR of LIFE", title:"PINK CANDY", tuning:"BBDG#BF#", capo: 0))
        self.tunes.append(Tune(album:"COLOR of LIFE", title:"セピア色の写真", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"COLOR of LIFE", title:"星砂 ～金色に輝く砂浜～", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"COLOR of LIFE", title:"Purple Highway", tuning:"CGDGBbD", capo: 0))
        self.tunes.append(Tune(album:"COLOR of LIFE", title:"あの夏の白い雲", tuning:"DADGAD", capo: 0))
        
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"Blue sky (exciting version)", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"HARD RAIN (type:D)", tuning:"GGDGGD", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"Fantasy!", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"桜・咲くころ", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"SPLASH", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"翼 ～you are the HERO～", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"Departure", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"ハッピー・アイランド", tuning:"DADGBD", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"Chaser", tuning:"CGCGBbD", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"ボレロ", tuning:"CGCGBE", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"カノン", tuning:"DADGBD", capo: 5))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"Merry Christmas Mr. Lawrence", tuning:"DADGAC", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"オアシス", tuning:"AEEF#BE", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"風の彼方", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"ラスト・クリスマス", tuning:"DADGBD", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"Friend (CM ver.)", tuning:"Standard", capo: 3))

        self.tunes.append(Tune(album:"Panorama", title:"Departure", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"Panorama", title:"オアシス", tuning:"AEEF#BE", capo: 0))
        self.tunes.append(Tune(album:"Panorama", title:"サバンナ", tuning:"DADF#AD", capo: 0))
        self.tunes.append(Tune(album:"Panorama", title:"オーロラ", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"Panorama", title:"コンドルは飛んで行く", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"Panorama", title:"Passion", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Panorama", title:"空色のみずうみ", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Panorama", title:"Friend", tuning:"Standard", capo: 3))
        self.tunes.append(Tune(album:"Panorama", title:"Brilliant Road", tuning:"DAEAC#E", capo: 0))
        self.tunes.append(Tune(album:"Panorama", title:"家路", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Panorama", title:"Carnival", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Panorama", title:"夢のつづき", tuning:"Standard", capo: 0))

        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"ボレロ", tuning:"CGCGBE", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"ブルー・ホール", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"AQUA-MARINE", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"Blue sky", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"ミスティ・ナイト", tuning:"EADGBD", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"Breeze", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"Merry Christmas Mr.Lawrence", tuning:"DADGAC", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"オールド・フレンド", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"Dear...", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"見上げてごらん夜の星を", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"Busy2", tuning:"AAC#GBE", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"HARD RAIN", tuning:"GGDGGD", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"翼～you are the HERO～", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"ちいさな輝き", tuning:"Standard", capo: 0))

        self.tunes.append(Tune(album:"Be Happy", title:"TSUBASA  you are the HERO", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"翼 ～you are the HERO～", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"MISTY NIGHT", tuning:"EADGBD", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"ミスティ・ナイト", tuning:"EADGBD", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"TENSI NO NICHIYOUBI", tuning:"EbBbEbAbCbEb", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"天使の日曜日", tuning:"EbBbEbAbCbEb", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"Jupiter", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"ジュピター", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"Dear...", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"AQUA-MARINE", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"miagetegoran yoru no hosi wo", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"見上げてごらん夜の星を", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"fight!", tuning:"BEADF#B", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"ファイト!", tuning:"BEADF#B", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"Busy2", tuning:"AAC#GBE", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"sakura saku koro", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"桜咲く頃", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"坂の上の公園", tuning:"Standard", capo: 0))
        
        self.tunes.append(Tune(album:"Dramatic", title:"SPLASH", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"Dramatic", title:"太陽のダンス", tuning:"AEEF#BE", capo: 0))
        self.tunes.append(Tune(album:"Dramatic", title:"風の詩", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Dramatic", title:"ハッピー・アイランド", tuning:"DADGBD", capo: 0))
        self.tunes.append(Tune(album:"Dramatic", title:"カノン", tuning:"DADGBD", capo: 5))
        self.tunes.append(Tune(album:"Dramatic", title:"ボレロ", tuning:"CGCGBE", capo: 0))
        self.tunes.append(Tune(album:"Dramatic", title:"そらはキマグレ", tuning:"DADF#AD", capo: 0))
        self.tunes.append(Tune(album:"Dramatic", title:"約束", tuning:"CGDGAD", capo: 5))
        self.tunes.append(Tune(album:"Dramatic", title:"Chaser", tuning:"CGCGBbD", capo: 0))
        self.tunes.append(Tune(album:"Dramatic", title:"プロローグ", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Dramatic", title:"Again...", tuning:"Standard", capo: 0))
 
        self.tunes.append(Tune(album:"STARTING POINT", title:"Fantasy!", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"STARTING POINT", title:"Destiny", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"STARTING POINT", title:"ティコ", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"STARTING POINT", title:"Breeze", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"STARTING POINT", title:"黄昏", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"STARTING POINT", title:"Merry Christmas Mr. Lawrence", tuning:"DADGAC", capo: 0))
        self.tunes.append(Tune(album:"STARTING POINT", title:"Blue Sky [Exciting Version]", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"STARTING POINT", title:"初恋", tuning:"AEEF#BE", capo: 0))
        self.tunes.append(Tune(album:"STARTING POINT", title:"Tension", tuning:"CGDGBbD", capo: 0))
        self.tunes.append(Tune(album:"STARTING POINT", title:"ハリーライムのテーマ", tuning:"DGDGBE", capo: 0))
        self.tunes.append(Tune(album:"STARTING POINT", title:"木もれ陽 [Cinema Version]", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"STARTING POINT", title:"Hard Rain (type:D)", tuning:"GGDGGD", capo: 0))
        
        self.tunes.append(Tune(album:"LOVE STRINGS", title:"Blue Sky", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"LOVE STRINGS", title:"In The Morning", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"LOVE STRINGS", title:"リボンの騎士", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"LOVE STRINGS", title:"ライムライト", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"LOVE STRINGS", title:"ピアノレッスン", tuning:"CADGBE", capo: 0))
        self.tunes.append(Tune(album:"LOVE STRINGS", title:"LOVE STRINGS", tuning:"FCGDAE", capo: 0))
        self.tunes.append(Tune(album:"LOVE STRINGS", title:"宵待月", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"LOVE STRINGS", title:"ニューシネマパラダイス", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"LOVE STRINGS", title:"遥かなる大地", tuning:"EEBEF#B", capo: 0))
        self.tunes.append(Tune(album:"LOVE STRINGS", title:"HARD RAIN", tuning:"GGDGGD", capo: 0))
        self.tunes.append(Tune(album:"LOVE STRINGS", title:"リベルタンゴ", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"LOVE STRINGS", title:"いつか王子様が", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"LOVE STRINGS", title:"ずっと…", tuning:"Standard", capo: 0))

        self.tunes.append(Tune(album:"押尾コータロー", title:"光のつばさ", tuning:"CGDGCD", capo: 0))
        self.tunes.append(Tune(album:"押尾コータロー", title:"彩音", tuning:"CGDGCD", capo: 0))
        self.tunes.append(Tune(album:"押尾コータロー", title:"第三の男", tuning:"DGDGBE", capo: 0))
        self.tunes.append(Tune(album:"押尾コータロー", title:"禁じられた遊び", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"押尾コータロー", title:"アイルランドの風", tuning:"AAEGAD", capo: 0))
        self.tunes.append(Tune(album:"押尾コータロー", title:"木もれ陽", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"押尾コータロー", title:"Dancin' コオロギ", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"押尾コータロー", title:"戦場のメリークリスマス", tuning:"DADGAC", capo: 0))
        self.tunes.append(Tune(album:"押尾コータロー", title:"カバティーナ", tuning:"DGDGBD", capo: 0))
        self.tunes.append(Tune(album:"押尾コータロー", title:"ボレロ", tuning:"CGCGBE", capo: 0))
        self.tunes.append(Tune(album:"押尾コータロー", title:"星砂", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"押尾コータロー", title:"アトランティス大陸", tuning:"GGDGGG", capo: 0))
        self.tunes.append(Tune(album:"押尾コータロー", title:"ちいさな輝き", tuning:"Standard", capo: 0))
        
    }
    
    func loadTunes() {        
        // 端末に保存されている押尾コータローさんの曲を保持する
        let query = MPMediaQuery.artists()
        let pred : MPMediaPropertyPredicate! = MPMediaPropertyPredicate(value:"押尾コータロー", forProperty:MPMediaItemPropertyArtist)
        query.addFilterPredicate(pred)
        
        for item : AnyObject in query.items!{
            if let _ = self.registItem(item){
            }else{
                let titleString: String = item.value(forProperty: MPMediaItemPropertyTitle) as! String
                let albumString: String = item.value(forProperty: MPMediaItemPropertyAlbumTitle) as! String
                print("unregist - " + titleString + " : " + albumString)
            }
        }
        
        for tune : Tune in self.tunes {
            if let _: AnyObject = tune.item {
                self.activeTunes.append(tune)
                
                // アルバムを登録
                var isAlbumFound = false
                for at in self.activeAlbums {
                    if tune.album == at.album {
                        isAlbumFound = true
                        break
                    }
                }
                if !isAlbumFound {
                    self.activeAlbums.append(tune)
                }
                
                // チューニングを登録
                if tune.pitches.count == 6 {
                    var isTuningFound = false
                    for at in self.activeTunings {
                        if tune.compareTuning(at) == 0 {
                            isTuningFound = true
                            break
                        }
                    }
                    if !isTuningFound {
                        self.activeTunings.append(tune)
                    }
                }
            }
        }
    }
    
    func registItem(_ item : AnyObject) -> Tune? {
        let titleString: String = item.value(forProperty: MPMediaItemPropertyTitle) as! String
        let albumString: String = item.value(forProperty: MPMediaItemPropertyAlbumTitle) as! String
        
        for tune : Tune in self.tunes{
            if tune.title == titleString && tune.album == albumString {
                tune.item = item
                return tune
            }
        }
        return nil
    }
    
    func getTuneByItem(_ item : AnyObject) -> Tune?{
        for tune : Tune in self.activeTunes{
            if tune.item === item {
                return tune
            }
        }
        return nil
    }
    
    func isTuning(_ tuning: String, title: String, album: String) -> Bool{
        if tuning == "" {
            return false
        }
        for tune : Tune in self.tunes{
            if tune.title == title && tune.tuning == tuning && tune.album == album {
                return true
            }
        }
        return false
    }

    // チューニング + capo を取得
    func getTuningByTune(_ title: String, album: String) -> String{
        for tune : Tune in self.tunes{
            if tune.title == title && tune.album == album {
                if tune.capo == 0 {
                    return tune.tuning
                    
                }else{
                    return tune.tuning + " " + String(tune.capo) + "capo"
                }
            }
        }
        return ""
    }
    
    // チューニング名のみ取得
    func getTuningBaseByTune(_ title: String, album: String) -> String{
        for tune : Tune in self.tunes{
            if tune.title == title && tune.album == album {
                return tune.tuning
            }
        }
        return ""
    }
    

    // アルバムが同じ曲を取得
    func getSameAlbumTunes(_ album : String) -> [Tune]{
        var tunes = [Tune]()
        for tune : Tune in self.activeTunes{
            if tune.album == album {
                tunes.append(tune)
            }
        }
        
        return tunes
    }

    // チューニングが同じ曲を取得
    func getSameTuningTunes(_ targetTune: Tune) -> [Tune]{
        var tunes = [Tune]()
        for tune : Tune in self.activeTunes{
            if tune.compareTuning(targetTune) == 0 {
                tunes.append(tune)
            }
        }
        
        return [Tune](tunes.sorted(by: {$0.getPlayCount() > $1.getPlayCount()}))
    }

    // チューニングが近い曲を取得
    func getSimilarTuningTunes(_ targetTune: Tune) -> [Tune]{
        var tunes = [Tune]()
        for tune : Tune in self.activeTunes{
            let score = tune.compareTuning(targetTune)
            if score >= 1 && score <= 2 {
                tunes.append(tune)
            }
        }
        
        return [Tune](tunes.sorted(by: {$0.compareTuning(targetTune) < $1.compareTuning(targetTune)}))
    }

    // 再生回数上位の曲を取得
    func getUpperLevelCountTunes() -> [Tune]{
        return [Tune](self.activeTunes.sorted(by: {$0.getPlayCount() > $1.getPlayCount()})[0...30])
    }
}
