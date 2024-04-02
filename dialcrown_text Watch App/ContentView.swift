//
//  ContentView.swift
//  dialcrown_text Watch App
//
//  Created by shirane kaoru on 2023/12/05.
//

import SwiftUI
import WatchConnectivity
import Foundation


var vowels:[String] = ["あ行","か行","さ行","た行","な行","は行","ま行","や行","ら行","わ行","\",゜"]

var consonant: [[String]] = [
    ["あ","い","う","え","お"],
    ["か","き","く","け","こ"],
    ["さ","し","す","せ","そ"],
    ["た","ち","つ","て","と"],
    ["な","に","ぬ","ね","の"],
    ["は","ひ","ふ","へ","ほ"],
    ["ま","み","む","め","も"],
    ["や","ゆ","よ"],
    ["ら","り","る","れ","ろ"],
    ["わ","を","ん"],
    ["\"","゜","小"]
]


var henkan : [String:[String]] = ["あ":["ぁ","あ"],"い":["ぃ","い"],"う":["ぅ","う"],"え":["ぇ","え"],"お":["ぉ","お"],"か":["が","か"],"き":["ぎ","き"],"く":["ぐ","く"],"け":["げ","け"],"こ":["ご","こ"],"さ":["ざ","さ"],"し":["じ","し"],"す":["ず","す"],"せ":["ぜ","せ"],"そ":["ぞ","そ"],"は":["ば","ぱ","は"],"ひ": ["び","ぴ","ひ"],"ふ":["ぶ","ぷ","ふ"],"へ":["べ","ぺ","へ"],"ほ":["ぼ","ぽ","ほ"],"た":["だ","た"],"ち":["ぢ","ち"],"つ":["っ","づ","つ"],"て":["で","て"],"と":["ど","と"],"や":["ゃ","や"],"ゆ":["ゅ","ゆ"],"よ":["ょ","よ"],"わ":["ゎ","わ"],]

// 入力フレーズ
var phrase: [String] = [
"つくばだいがく",
"あしたはかいぎ",
"しめきりがちかい",
"ごごきゅうこう",
"あしたはやすみ",
"ろんぶんよむ",
"いんたらくしょん",
"れんしゅうする",
"うるしをぬる",
"すいどうだい",
"やさいをとる",
"ていしゅつきげん",
"ふみんふきゅう",
"そうじとうばん",
"ことしきせいする",
"どうもありがとう",
"わかりました",
"ごめんなさい",
"てんきわるい",
"あしたはあめ",
"きょうははれ",
"あしたはくもり",
"あきたにいく",
"なまはげをみる",
"だいがくにいく",
"おなかすいた",
"すいみんをとる",
"あしたあそぼ",
"おひさしぶり",
"おつかれさま",
"めんどくさい",
"かぜをひいた",
"いまどこにいる",
"きどくがつく",
"ききかんをもつ",
"ぷろぐらみんぐ",
"つうわをする",
"きをつけてね",
"えきについた",
"らくたんしてた",
"たんいをとる",
"そつぎょうする",
"けんきゅうしつ",
"ひるめしたべた",
"ひるねをする",
"ぱわぽをつかう",
"りしゅうとうろく",
"やちんをはらう",
"りんじんとらぶる",
"ぽいんとをためる",
"すたんぷをつかう",
"あしたよていある",
"がぞうをほぞん",
"らいんをかえす",
"こうぎのめも",
"ほんをよんでた",
"きょうしつにいく",
"じゅうでんきどこ",
"じてんしゃのる",
"まうすでそうさ",
"すまほわすれた"


]

var offset_vowel_angle: CGFloat = 360.0 / 11.0
var offset_cons_angle: CGFloat = 360.0 / 5.0
var start_angle: CGFloat = 0.0
var padding_angle: CGFloat = 1.0
let CenterX:CGFloat = 86.0
let CenterY:CGFloat = 69.0
let MAX_WIDTH:CGFloat = 172.0 - 20
let MAX_HEIGHT:CGFloat = 138.0
let length: CGFloat = 40
let vowel_size:Int = 11

struct StartListView: View {
    @State private var Rotation_Dir = false
    @State private var Vive = true

    @State private var CROWN_CNT = 12.0
    
    var body: some View {
        NavigationView{
            List{
//                NavigationLink(
//                    destination: ConfigView(Rotation_Dir: $Rotation_Dir, CROWN_CNT: $CROWN_CNT,Vive:$Vive),
//                    label: {Text("config")})
//                NavigationLink(
//                    destination: DemoView(Rotation_Dir: $Rotation_Dir, CROWN_CNT: $CROWN_CNT,Vive:$Vive),
//                    label: {Text("demo")})
                NavigationLink(
                    destination: PracticeType1View(),
                    label: {Text("practive_type1")})
                NavigationLink(
                    destination: PracticeType2View(),
                    label: {Text("practive_type2")})
                NavigationLink(
                    destination: Type1(),
                    label: {Text("type1")})
                NavigationLink(
                    destination: DialCrownView(),
                    label: {Text("type2")})
                    
                
            }.navigationTitle("Option")
        }
    }
}

////パラメータを調整できるView
//struct ConfigView: View{
//    
//    @Binding var Rotation_Dir: Bool
//    @Binding var CROWN_CNT: Double
//    @Binding var Vive:Bool
//    var body: some View{
//    
//        List{
//            Toggle("Rotation Dir", isOn: $Rotation_Dir)
//            Toggle("触覚フィードバック", isOn: $Vive)
//            Text("回転感度:\(CROWN_CNT)")
//            Slider(value: $CROWN_CNT, in:5...25, step:1)
//            
//            
//        }.navigationTitle("config")
//    }
//    
//}
// Use a Stepper to edit the stress level of an item
struct DialCrownView: View {
    
    @State private var degital_rotate: CGFloat = 0.0
    @State private var old_degital_rotate: CGFloat = 0.0
    @State private var old_crownSpeed:CGFloat = 0.0
    @State private var crownSpeed:CGFloat = 0.0
    
    @State private var crownAcce:CGFloat = 0.0
    @State private var circlePositionX: CGFloat = length * cos(270 * Double.pi / 180.0) + CenterX
    @State private var circlePositionY: CGFloat = length * sin(270 * Double.pi / 180.0) + CenterY
    
    
    @State private var bar_color = [Color.red,Color.white,Color.white,Color.white,Color.white,Color.white,Color.white,Color.white,Color.white,Color.white,Color.white]
    
    @State private var bar_cons_color = [Color.red,Color.white,Color.white,Color.white,Color.white]
    
    // 子音および母音をさすインデックス
    @State private var vowel_index = 0
    @State private var cons_index = 0
    
    //子音選択，母音選択の状態を管理するフラグ
    @State private var is_vowel = true
    
    //入力文字関連レジスタ
    @State private var enter_text = "" //入力文字を記憶する
    @State private var enter_pre_index = 0 //入力した文字の一個前の文字を指すインデックス
    @State private var enter_log = "" //すべての入力ログを記録する
    @State private var DeleteFlag = false //削除操作を行ったかどうか
    @State private var StartFlag = false //デジタルクラウン動かしたか
    let DeleteSpeed = 3.0 //削除操作が実行されるスピード
    let CircleSpeed = 4.0
    @State private var HenkanCnt = 0 //変換の際に何回実行したか記憶する
    @State private var DeleteCnt:Double = 0.0 //削除した回数
    @State private var prev_text = "" //変換される文字を記憶する
    
    //フレーズ入力関連レジスタ
    @State private var phrase_cnt = Int.random(in: 0 ..< phrase.count-1) //現在入力しているフレーズ
    @State private var session_maxcnt = 10
    @State private var phrase_dic = [Int:Int]() //フレーズの辞書
    @State private var isFinishSession = false //セッションが終わったかどうか
    
    //時間計測関連レジスタ
    @State var dateText = ""
    @State var CER = 0
    @State var CPM:String = ""
    @State var entry_time:String = ""
    @State var isFinish = false
    @State var TER:Double = 0.0
    @State var startTime:Date = Date()
    @State var isStartTime = false
    
    //iPhoneに送信するモジュール宣言
    @ObservedObject private var connector = PhoneConnector()
    
    init(){
        _phrase_dic = State(initialValue: [phrase_cnt:1])
    }
    
    func LevenshteinDistance(s1:String,s2:String)->Int{
        
        if s1.isEmpty {
            return s2.count
        }
        var d:[[Int]] = Array(repeating: Array(repeating: 0, count: s2.count + 1),count: s1.count + 1)
        
        for i1 in 0 ..< s1.count+1{
            d[i1][0] = i1
        }
        
        for i2 in 0 ..< s2.count+1{
            d[0][i2] = i2
        }
        
        for i1 in 1 ..< s1.count+1{
            for i2 in 1 ..< s2.count+1{
                let cost = s1[s1.index(s1.startIndex,offsetBy: i1-1)] == s2[s2.index(s2.startIndex,offsetBy: i2-1)] ? 0 : 1
                d[i1][i2] = min(d[i1-1][i2]+1,d[i1][i2-1]+1,d[i1-1][i2-1]+cost)
                
                
            }
        }
        
        return d[s1.count][s2.count]
    }
    
    func CheckVowelObj(){
        for i in 0 ..< vowel_size {
            
            if degital_rotate >= (start_angle + offset_vowel_angle * CGFloat(i) + padding_angle).truncatingRemainder(dividingBy: CGFloat(360.0)) && degital_rotate  <= (start_angle + offset_vowel_angle * CGFloat(i + 1) - padding_angle).truncatingRemainder(dividingBy: CGFloat(360.0)) {
                bar_color[i] = Color.red
                vowel_index = i
            }else{
                bar_color[i] = Color.white
            }
            
        }
    }
    
    func CheckConsObj(){
        for i in 0 ..< consonant[vowel_index].count {
            
            if degital_rotate >= (start_angle + offset_cons_angle * CGFloat(i) + padding_angle).truncatingRemainder(dividingBy: CGFloat(360.0)) && degital_rotate  <= (start_angle + offset_cons_angle * CGFloat(i + 1) - padding_angle).truncatingRemainder(dividingBy: CGFloat(360.0)) {
                bar_cons_color[i] = Color.red
                cons_index = i
            }else{
                bar_cons_color[i] = Color.white
            }
           
        }
    }
    
    func Henkan(){
        
        
        enter_text.removeLast()
        enter_log.removeLast()
        
        enter_text.append((henkan[prev_text]?[HenkanCnt % henkan[prev_text]!.count])!)
        enter_log.append((henkan[prev_text]?[HenkanCnt % henkan[prev_text]!.count])!)
    }
    
    func SetCirclePos(){
        circlePositionX = length * cos((degital_rotate - 90) * Double.pi / 180.0) + CenterX
        circlePositionY = length * sin((degital_rotate - 90) * Double.pi / 180.0) + CenterY
    }
    var body: some View {
//        GeometryReader { geometry in
//            VStack{
//                
//                Text("親ビューの横幅: \(geometry.size.width)")
//                Text("親ビューの高さ: \(geometry.size.height)")
//            }
//        }
        if isFinishSession{
            ZStack{
                Text("Finish")
            }
        } else {
            ZStack{
                //            Text("\(degital_rotate)")
                // 中央に入力文字を描画
                //            Text(enter_log)
                VStack{
                    Text(phrase[phrase_cnt])
                    Text(enter_text)
                    //                Text("\(degital_rotate)")
                }
                //外枠のオブジェクトの描画
                if is_vowel {
                    //子音
                    ForEach(0 ..< vowel_size, id: \.self){ i in
                        AShape(start_angle: (start_angle - 90) + offset_vowel_angle * CGFloat(i), offset_angle: offset_vowel_angle)
                            .stroke(style:StrokeStyle(lineWidth: 20))
                            .fill(bar_color[i])
                            .frame(width: MAX_WIDTH , height: MAX_HEIGHT)
                            .position(x: CenterX, y : CenterY)
                    }
                } else {
                    //母音
                    ForEach(0 ..< consonant[vowel_index].count, id: \.self){ i in
                        AShape(start_angle: (start_angle - 90) + offset_cons_angle * CGFloat(i), offset_angle: offset_cons_angle)
                            .stroke(style:StrokeStyle(lineWidth: 20))
                            .fill(bar_cons_color[i])
                            .frame(width: MAX_WIDTH , height: MAX_HEIGHT)
                        
                    }
                }
                // デジタルクラウンによって，回転する円カーソル
                Circle()
                    .fill(Color.green) // 円の色を設定
                    .frame(width: 15, height: 15) // 円のサイズを設定
                    .position(x: circlePositionX, y: circlePositionY) // 円の位置を指定
                    .focusable()
                
                    .digitalCrownRotation(
                        detent: $degital_rotate,
                        from:0, through: 360, by: CircleSpeed,
                        sensitivity:.high, isContinuous:true)
                { event in
                    old_crownSpeed = crownSpeed
                    crownSpeed = event.velocity
                    if StartFlag{
//                        print("Old:\(old_crownSpeed)")
//                        print("New:\(crownSpeed)")
                        if old_crownSpeed - crownSpeed == 0{
                            print("0")
                        }
                    }
                    if crownSpeed > DeleteSpeed { //削除操作（デジタルクラウンを高速に上回転させたかどうか）
                        StartFlag = false
                        if !DeleteFlag && !enter_text.isEmpty {
                            DeleteCnt += 1
                            if is_vowel{
                                enter_text.removeLast() //末尾の文字を削除
                            } else {
                                is_vowel = true
                            }
                            
                            DeleteFlag = true //フラグON
                            
                        }
                    } else if crownSpeed <= 0.04 && crownSpeed >= -0.04{ //速度がゼロ
                        
                        
                        DeleteFlag = false
                        
                        if StartFlag{
                            StartFlag = false
                            if is_vowel {
                                if vowels[vowel_index] == "\",゜" {
                                    if !enter_text.isEmpty {
                                        if HenkanCnt == 0{
                                            prev_text = String(enter_text.last!)
                                        }
                                        if henkan.keys.contains(prev_text) {
                                            Henkan()
                                            HenkanCnt += 1
                                        }
                                    }
                                    
                                } else {
                                    offset_cons_angle = 360 / CGFloat(consonant[vowel_index].count)
                                    is_vowel.toggle()
                                    CheckConsObj()
                                    HenkanCnt = 0
                                }
                            } else {
                                
                                enter_text.append(consonant[vowel_index][cons_index])
                                enter_log.append(consonant[vowel_index][cons_index])
                                is_vowel.toggle()
                                CheckVowelObj()
                            }
                            
                        }
                        
                        degital_rotate = 0.0
                        SetCirclePos()
                        
                        if is_vowel {
                            CheckVowelObj()
                        } else {
                            CheckConsObj()
                        }
                        
                        
                        
                    } else { // デジタルクラウンを動かしている時
                        
                        StartFlag = DeleteFlag ? false : true//DeleteしているときはStarFlagはOFF
                        SetCirclePos()
                        if !isStartTime{
//                            print("start")
                            startTime = Date()
                            isStartTime = true
                        }
                        // 選択中のオブジェクトの色を赤くする
                        if is_vowel {
                            //　子音
                            CheckVowelObj()
                        } else {
                            //　母音
                            CheckConsObj()
                        }
                    }
                    
                }
                
                
                // ラベル
                if is_vowel {
                    // 子音
                    ForEach(0 ..< vowel_size, id: \.self){ i in
                        let rad_angle = ((start_angle - 90) + offset_vowel_angle * CGFloat(i) + offset_vowel_angle / 2) * Double.pi / 180.0
                        Text(vowels[i])
                            .position(x: (length + 37) * cos(rad_angle) + CenterX, y: (length + 37) * sin(rad_angle) + CenterY)
                            .foregroundColor(Color.black)
                            .font(Font.system(size: 13).bold())
                    }
                } else {
                    // 母音
                    ForEach(0 ..< consonant[vowel_index].count, id: \.self){ i in
                        let rad_angle = ((start_angle - 90) + offset_cons_angle * CGFloat(i) + offset_cons_angle / 2) * Double.pi / 180.0
                        Text(consonant[vowel_index][i])
                            .position(x: (length + 37) * cos(rad_angle) + CenterX, y: (length + 37) * sin(rad_angle) + CenterY)
                            .foregroundColor(Color.black)
                            .font(Font.system(size: 20).bold())
                    }
                }
            }
            .onTapGesture(){ touch_pos in
                if touch_pos.x >= 100{
                    if phrase_dic.count <= session_maxcnt {
                        isStartTime = false
                        let timeInterval = Date().timeIntervalSince(startTime)
                        let time = Int(timeInterval)
                        
                        
                        let m = time / 60 % 60
                        let s = time % 60
                        
                        // ミリ秒
                        let ms = Int(timeInterval * 100) % 100
                        
                        entry_time = String(format: "%dm%d.%ds",  m, s, ms)
                        CPM = String(Double(phrase[phrase_cnt].count)/(Double(m)+(Double(s)+Double(ms)/100.0)/60.0))
                        TER = Double(LevenshteinDistance(s1: phrase[phrase_cnt], s2: enter_log)) / Double(enter_log.count)
                        
                        connector.send(phrase:phrase[phrase_cnt],phraseID:phrase_cnt,keystroke:enter_log.count,Time:entry_time,CPM:CPM,TER:TER,DeleteCnt:DeleteCnt)
                        
                        
                        phrase_cnt = Int.random(in: 0 ..< phrase.count-1)
                        
                        while phrase_dic.keys.contains(phrase_cnt){
                            phrase_cnt = Int.random(in: 0 ..< phrase.count-1)
                            
                        }
                        phrase_dic[phrase_cnt] = 1
                        enter_text.removeAll()
                        enter_log.removeAll()
                        
                    }else{
                        isFinishSession = true
                    }
                    
                }
            }
        }
       
    }
    
}



#Preview {
    DialCrownView()
}


struct AShape: Shape {
    var st_ang:CGFloat
    var oft_ang:CGFloat
    
    init(start_angle:CGFloat, offset_angle: CGFloat){
        self.st_ang = start_angle
        self.oft_ang = offset_angle
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.midY),
            radius: rect.maxX / 2,
            startAngle: Angle(degrees: self.st_ang +  padding_angle),
            endAngle: Angle(degrees: self.st_ang + self.oft_ang - padding_angle),
            clockwise: false
        )
        
        return path
            
    }
}


class PhoneConnector: NSObject, ObservableObject, WCSessionDelegate {
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith state= \(activationState.rawValue)")
    }
    
    
    
    func send(phrase:String,phraseID:Int,keystroke:Int,Time:String,CPM:String,TER:Double,DeleteCnt:Double) -> Text{
        if WCSession.default.isReachable {
            
            
            WCSession.default.sendMessage(["phrase":phrase,"phraseID":phraseID,"Keystroke":keystroke,"Time":Time,"CPM": CPM,"TER": TER,"DeleteCnt":DeleteCnt], replyHandler: nil) {
                error in
                print(error)
            }
        }
        return Text("")
    }
}
