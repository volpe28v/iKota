//
//  TuneCollection.swift
//  iKota
//
//  Created by Naoki KODAMA on 2015/01/04.
//  Copyright (c) 2015年 Naoki KODAMA. All rights reserved.
//

import Foundation

class TuneCollection {
    class Tune {
        var title: String?
        var album: String?
        var tuning: String?
        var capo: Int?
        
        init(album: String, title: String, tuning: String, capo: Int){
            self.album = album
            self.title = title
            self.tuning = tuning
            self.capo = capo
        }
    }
    
    var tunes: [Tune]
    
    init(){
        self.tunes = []
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"オアシス", tuning:"AEEF#BE", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"ずっと...", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"ナユタ", tuning:"C#G#D#G#CD#", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"DREAMING", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"Earth Angel", tuning:"AEEF#BE", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"Merry Christmas Mr.Lawrence", tuning:"DADGAC", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"Misty Night", tuning:"EADGBD", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"MOTHER", tuning:"C#G#EF#BE", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"黄昏", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"桜・咲くころ", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"天使の日曜日", tuning:"EbBbEbAbCbEb", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"日曜日のビール", tuning:"GCFBbDG", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"風の詩", tuning:"DADGBE", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary BEST - Ballade Side", title:"木もれ陽", tuning:"Standard", capo: 0))
        
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side",title:"ファイト!", tuning:"BEADF#B", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side",title:"翼 〜Hoping For The Future〜", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side",title:"Big Blue Ocean", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side",title:"Fantasy!", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side",title:"Hard Rain", tuning:"GGDGGD", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side",title:"Heart Beat!", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side",title:"Jet", tuning:"GGDGAC", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side",title:"Landscape", tuning:"CGDGBD", capo: 3))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side",title:"Over Drive", tuning:"AAEEAE", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side",title:"Pink Candy", tuning:"BBDG#BF#", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side",title:"Relation!", tuning:"DADF#AE", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side",title:"Rushin'", tuning:"AAEGAE", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side",title:"Snappy!", tuning:"AAEGAE", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side",title:"Tension", tuning:"CGDGBbD", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side", title:"Treasure", tuning:"DADGBD", capo: 0))
        self.tunes.append(Tune(album:"10th Anniversary Best - Upper Side", title:"太陽のダンス", tuning:"AEEF#BE", capo: 0))
        
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
        
        self.tunes.append(Tune(album:"Tussie mussie", title:"涙のキッス", tuning:"C#G#D#G#B#D#", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie", title:"CAN'T TAKE MY EYES OFF OF YOU ～君の瞳に恋してる～", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie", title:"LOVE", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie", title:"そして僕は途方に暮れる", tuning:"C#G#D#G#B#D#", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie", title:"LOVIN' YOU", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie", title:"TIME AFTER TIME", tuning:"C#G#D#G#B#D#", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie", title:"FIRST LOVE", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie", title:"SOMEDAY", tuning:"C#G#C#F#A#C#", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie", title:"CLOSE TO YOU", tuning:"C#G#D#G#B#D#", capo: 0))
        self.tunes.append(Tune(album:"Tussie mussie", title:"元気を出して", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Nature Spirit", title:"PEACE!", tuning:"DADGBD", capo: 0))
        self.tunes.append(Tune(album:"Nature Spirit", title:"TREASURE (アルバム・バージョン)", tuning:"DADGBD", capo: 0))
        self.tunes.append(Tune(album:"Nature Spirit", title:"Buzzer Beater", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"Nature Spirit", title:"Christmas Rose", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"Nature Spirit", title:"Hangover", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Nature Spirit", title:"Rushin'", tuning:"AAEGAE", capo: 0))
        self.tunes.append(Tune(album:"Nature Spirit", title:"スマイル", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Nature Spirit", title:"Deep Silence", tuning:"AAEGAE", capo: 0))
        self.tunes.append(Tune(album:"Nature Spirit", title:"永遠の青い空", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Nature Spirit", title:"ノスタルジア", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Nature Spirit", title:"My Home Town", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Nature Spirit", title:"DREAMING", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Dramatic", title:"ハッピー・アイランド", tuning:"DADGBD", capo: 0))
        self.tunes.append(Tune(album:"Dramatic", title:"プロローグ", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Dramatic", title:"SPLASH", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"Dramatic", title:"風の詩", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Dramatic", title:"そらはキマグレ", tuning:"DADF#AD", capo: 0))
        self.tunes.append(Tune(album:"Dramatic", title:"Chaser", tuning:"CGCGBbD", capo: 0))
        self.tunes.append(Tune(album:"Dramatic", title:"ボレロ", tuning:"CGCGBE", capo: 0))
        self.tunes.append(Tune(album:"Dramatic", title:"カノン", tuning:"DADGBD", capo: 5))
        self.tunes.append(Tune(album:"Dramatic", title:"約束", tuning:"CGDGAD", capo: 5))
        self.tunes.append(Tune(album:"Dramatic", title:"Again...", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Dramatic", title:"太陽のダンス", tuning:"AEEF#BE", capo: 0))
        self.tunes.append(Tune(album:"Eternal Chain", title:"Prelude ～sunrise～", tuning:"CGDGBD", capo: 3))
        self.tunes.append(Tune(album:"Eternal Chain", title:"Interlude ～starlight～", tuning:"C#G#EF#BE", capo: 0))
        self.tunes.append(Tune(album:"Eternal Chain", title:"楽園", tuning:"C#G#D#G#CD#", capo: 0))
        self.tunes.append(Tune(album:"Eternal Chain", title:"Road Goes On", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"Eternal Chain", title:"Interlude ～forestbeat～", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Eternal Chain", title:"Interlude ～sunshine～", tuning:"C#G#D#G#CD#", capo: 0))
        self.tunes.append(Tune(album:"Eternal Chain", title:"日曜日のビール", tuning:"Standard", capo: 3))
        self.tunes.append(Tune(album:"Eternal Chain", title:"Landscape", tuning:"CGDGBD", capo: 3))
        self.tunes.append(Tune(album:"Eternal Chain", title:"絆", tuning:"C#G#EF#BE", capo: 0))
        self.tunes.append(Tune(album:"Eternal Chain", title:"Earth Angel", tuning:"AEEF#BE", capo: 0))
        self.tunes.append(Tune(album:"Eternal Chain", title:"ハピネス", tuning:"GCFBbDG", capo: 0))
        self.tunes.append(Tune(album:"Eternal Chain", title:"Coda ～sunset～", tuning:"CGDGBD", capo: 3))
        self.tunes.append(Tune(album:"Eternal Chain", title:"Believe", tuning:"CGDGBD", capo: 2))
        self.tunes.append(Tune(album:"Eternal Chain", title:"Always", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Eternal Chain", title:"Snappy!", tuning:"AAEGAE", capo: 0))
        self.tunes.append(Tune(album:"Eternal Chain", title:"旅の途中", tuning:"C#G#EF#BE", capo: 0))
        self.tunes.append(Tune(album:"COLOR of LIFE", title:"Red Shoes Dance", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"COLOR of LIFE", title:"セピア色の写真", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"COLOR of LIFE", title:"YELLOW SUNSHINE", tuning:"GGDGGD", capo: 0))
        self.tunes.append(Tune(album:"COLOR of LIFE", title:"ブラックモンスター", tuning:"DADGAC", capo: 0))
        self.tunes.append(Tune(album:"COLOR of LIFE", title:"グリーンスリーブス", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"COLOR of LIFE", title:"星砂 ～金色に輝く砂浜～", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"COLOR of LIFE", title:"Purple Highway", tuning:"CGDGBbD", capo: 0))
        self.tunes.append(Tune(album:"COLOR of LIFE", title:"PINK CANDY", tuning:"BBDG#BF#", capo: 0))
        self.tunes.append(Tune(album:"COLOR of LIFE", title:"Indigo Love", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"COLOR of LIFE", title:"クリスタル", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"COLOR of LIFE", title:"あの夏の白い雲", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"COLOR of LIFE", title:"Big Blue Ocean", tuning:"DADGAD", capo: 0))
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
        self.tunes.append(Tune(album:"Be Happy", title:"坂の上の公園", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"Dear...", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"AQUA-MARINE", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"Jupiter", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"ジュピター", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"TENSI NO NICHIYOUBI", tuning:"EbBbEbAbCbEb", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"天使の日曜日", tuning:"EbBbEbAbCbEb", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"sakura saku koro", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"桜咲く頃", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"miagetegoran yoru no hosi wo", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"見上げてごらん夜の星を", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"fight!", tuning:"BEADF#B", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"ファイト!", tuning:"BEADF#B", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"MISTY NIGHT", tuning:"EADGBD", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"ミスティ・ナイト", tuning:"EADGBD", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"Busy2", tuning:"AAC#GBE", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"TSUBASA  you are the HERO", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"Be Happy", title:"翼 ～you are the HERO～", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"LOVE STRINGS", title:"ライムライト", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"LOVE STRINGS", title:"いつか王子様が", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"LOVE STRINGS", title:"ずっと…", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"LOVE STRINGS", title:"リベルタンゴ", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"LOVE STRINGS", title:"リボンの騎士", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"LOVE STRINGS", title:"ピアノレッスン", tuning:"CADGBE", capo: 0))
        self.tunes.append(Tune(album:"LOVE STRINGS", title:"Blue Sky", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"LOVE STRINGS", title:"LOVE STRINGS", tuning:"FCGDAE", capo: 0))
        self.tunes.append(Tune(album:"LOVE STRINGS", title:"ニューシネマパラダイス", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"LOVE STRINGS", title:"宵待月", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"LOVE STRINGS", title:"遥かなる大地", tuning:"EEBEF#B", capo: 0))
        self.tunes.append(Tune(album:"LOVE STRINGS", title:"In The Morning", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"LOVE STRINGS", title:"HARD RAIN", tuning:"GGDGGD", capo: 0))
        self.tunes.append(Tune(album:"押尾コータロー", title:"Dancin' コオロギ", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"押尾コータロー", title:"ボレロ", tuning:"CGCGBE", capo: 0))
        self.tunes.append(Tune(album:"押尾コータロー", title:"星砂", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"押尾コータロー", title:"禁じられた遊び", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"押尾コータロー", title:"カバティーナ", tuning:"DGDGBD", capo: 0))
        self.tunes.append(Tune(album:"押尾コータロー", title:"光のつばさ", tuning:"CGDGCD", capo: 0))
        self.tunes.append(Tune(album:"押尾コータロー", title:"彩音", tuning:"CGDGCD", capo: 0))
        self.tunes.append(Tune(album:"押尾コータロー", title:"木もれ陽", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"押尾コータロー", title:"ちいさな輝き", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"押尾コータロー", title:"第三の男", tuning:"DGDGBE", capo: 0))
        self.tunes.append(Tune(album:"押尾コータロー", title:"アトランティス大陸", tuning:"GGDGGG", capo: 0))
        self.tunes.append(Tune(album:"押尾コータロー", title:"アイルランドの風", tuning:"AAEGAD", capo: 0))
        self.tunes.append(Tune(album:"押尾コータロー", title:"戦場のメリークリスマス", tuning:"DDGAC", capo: 0))
        self.tunes.append(Tune(album:"STARTING POINT", title:"ハリーライムのテーマ", tuning:"DGDGBE", capo: 0))
        self.tunes.append(Tune(album:"STARTING POINT", title:"Fantasy!", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"STARTING POINT", title:"Destiny", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"STARTING POINT", title:"Hard Rain (type:D)", tuning:"GGDGGD", capo: 0))
        self.tunes.append(Tune(album:"STARTING POINT", title:"木もれ陽 [Cinema Version]", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"STARTING POINT", title:"ティコ", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"STARTING POINT", title:"Tension", tuning:"CGDGBbD", capo: 0))
        self.tunes.append(Tune(album:"STARTING POINT", title:"黄昏", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"STARTING POINT", title:"初恋", tuning:"AEEF#BE", capo: 0))
        self.tunes.append(Tune(album:"STARTING POINT", title:"Breeze", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"STARTING POINT", title:"Blue Sky [Exciting Version]", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"STARTING POINT", title:"Merry Christmas Mr. Lawrence", tuning:"DADGAC", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 1]", title:"nanairo", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 1]", title:"Weather Report", tuning:"DAEF#BE", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 1]", title:"Kiwi & Avocado", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 1]", title:"Ready, Go!", tuning:"AAEGAE", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 1]", title:"STEALTH", tuning:"C#G#EF#BE", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 1]", title:"キミノコト", tuning:"C#G#EF#BE", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 1]", title:"MISSION", tuning:"CGEbFBbEb", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 1]", title:"One Love, ～T's theme～", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 1]", title:"Midnight Rain", tuning:"BBDF#BD", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"桜・咲くころ", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"ハッピー・アイランド", tuning:"DADGBD", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"カノン", tuning:"DADGBD", capo: 5))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"風の彼方", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"Friend (CM ver.)", tuning:"Standard", capo: 3))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"Merry Christmas Mr. Lawrence", tuning:"DADGAC", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"Chaser", tuning:"CGCGBbD", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"ボレロ", tuning:"CGCGBE", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"HARD RAIN (type:D)", tuning:"GGDGGD", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"SPLASH", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"Blue sky (exciting version)", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"ラスト・クリスマス", tuning:"DADGBD", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"Departure", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"翼 ～you are the HERO～", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"Fantasy!", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"Blue sky -Kotaro Oshio Best Album-", title:"オアシス", tuning:"AEEF#BE", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"AQUA-MARINE", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"翼～you are the HERO～", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"ちいさな輝き", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"ブルー・ホール", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"Dear...", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"オールド・フレンド", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"Busy2", tuning:"AAC#GBE", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"Blue sky", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"HARD RAIN", tuning:"GGDGGD", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"ミスティ・ナイト", tuning:"EADGBD", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"見上げてごらん夜の星を", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"Merry Christmas Mr.Lawrence", tuning:"DADGAC", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"Breeze", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"ボレロ! Be HAPPY LIVE", title:"ボレロ", tuning:"CGCGBE", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 2]", title:"ナイト・ウェイブ [Live]", tuning:"", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 2]", title:"IF YOU WANT", tuning:"", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 2]", title:"Shape Of My Heart", tuning:"", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 2]", title:"... & Smile", tuning:"", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 2]", title:"Smile Blue", tuning:"", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 2]", title:"瞳をとじれば", tuning:"", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 2]", title:"瞳をとじて", tuning:"", capo: 0))
        self.tunes.append(Tune(album:"Reboot & Collabo. [Disc 2]", title:"時の過ぎゆくままに", tuning:"", capo: 0))
        self.tunes.append(Tune(album:"Panorama", title:"Departure", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"Panorama", title:"オアシス", tuning:"AEEF#BE", capo: 0))
        self.tunes.append(Tune(album:"Panorama", title:"家路", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Panorama", title:"Passion", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Panorama", title:"空色のみずうみ", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Panorama", title:"夢のつづき", tuning:"Standard", capo: 0))
        self.tunes.append(Tune(album:"Panorama", title:"Brilliant Road", tuning:"DAEAC#E", capo: 0))
        self.tunes.append(Tune(album:"Panorama", title:"コンドルは飛んで行く", tuning:"CGDGBD", capo: 0))
        self.tunes.append(Tune(album:"Panorama", title:"オーロラ", tuning:"DADGAD", capo: 0))
        self.tunes.append(Tune(album:"Panorama", title:"Friend", tuning:"Standard", capo: 3))
        self.tunes.append(Tune(album:"Panorama", title:"サバンナ", tuning:"DADF#AD", capo: 0))
        self.tunes.append(Tune(album:"Panorama", title:"Carnival", tuning:"Standard", capo: 0))
        
        
    }
    
    func getAllTuning() -> [String] {
        return ["Standard","DADGAD"]
    }
    
    func isTuning(tuning: String, title: String, album: String) -> Bool{
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
    func getTuningByTune(title: String, album: String) -> String{
        for tune : Tune in self.tunes{
            if tune.title == title && tune.album == album {
                if tune.capo == 0 {
                    return tune.tuning!
                    
                }else{
                    return tune.tuning! + " " + String(tune.capo!) + "capo"
                }
            }
        }
        return ""
    }
    
    // チューニング名のみ取得
    func getTuningBaseByTune(title: String, album: String) -> String{
        for tune : Tune in self.tunes{
            if tune.title == title && tune.album == album {
                return tune.tuning!
            }
        }
        return ""
    }
    
    // チューニングが同じ曲を取得
    func getRelateTunes(title: String, album: String) -> Array<String>{
        var tunes = Array<String>()
        var tuning = self.getTuningBaseByTune(title, album: album)
        for tune : Tune in self.tunes{
            if tune.tuning == tuning && tune.title != title {
                tunes.append(tune.title!)
            }
        }
        
        return tunes
    }
}