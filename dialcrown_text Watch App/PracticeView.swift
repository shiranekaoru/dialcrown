//
//  PracticeView.swift
//  dialcrown_text Watch App
//
//  Created by shirane kaoru on 2024/03/28.
//

import Foundation
import SwiftUI


var r_phrase: [String] = [
    "おはよう",
    "こんにちは",
    "こんばんわ",
    "おやすみ",
    "げんきです",
    "ねむいです",
    "さようなら",
    "ひさしぶり",
    "やっぱいいや",
    "どうでもいいよ",
    "すごくいいね",
    "おなかすいた",
    "べんきょうする",
    "きたくします",
    "ただいま",
    "ばんごはんなに",
    
    
]
struct PracticeType2View: View {
    
    @State private var degital_rotate: CGFloat = 0.0
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
    @State private var prev_text = "" //変換される文字を記憶する
    
    //フレーズ入力関連レジスタ
    @State private var phrase_cnt = Int.random(in: 0 ..< r_phrase.count-1) //現在入力しているフレーズ
    @State private var session_maxcnt = 10
    @State private var phrase_dic = [Int:Int]() //フレーズの辞書
    @State private var isFinishSession = false //セッションが終わったかどうか
    
    
    
    
    
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
                Text(r_phrase[phrase_cnt])
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
                
                let crownSpeed = event.velocity
                
                
                if crownSpeed > DeleteSpeed { //削除操作（デジタルクラウンを高速に上回転させたかどうか）
                    StartFlag = false
                    if !DeleteFlag && !enter_text.isEmpty {
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
                if phrase_dic.count < session_maxcnt {
                    
                    
                    
                    phrase_cnt = Int.random(in: 0 ..< r_phrase.count-1)
                    
                    while phrase_dic.keys.contains(phrase_cnt){
                        phrase_cnt = Int.random(in: 0 ..< r_phrase.count-1)
                        
                    }
                    phrase_dic[phrase_cnt] = 1
                    enter_text.removeAll()
                    enter_log.removeAll()
                    
                }else{
                    isFinishSession = true
                }
                //                if is_vowel {
                //                    if vowels[vowel_index] == "\",゜" {
                //                        if !enter_text.isEmpty {
                //                            if HenkanCnt == 0{
                //                                prev_text = String(enter_text.last!)
                //                            }
                //                            if henkan.keys.contains(prev_text) {
                //                                Henkan()
                //                                HenkanCnt += 1
                //                            }
                //                        }
                //
                //                    } else {
                //                        offset_cons_angle = 360 / CGFloat(consonant[vowel_index].count)
                //                        is_vowel.toggle()
                //                        CheckConsObj()
                //                        HenkanCnt = 0
                //                    }
                //                } else {
                //
                //                    enter_text.append(consonant[vowel_index][cons_index])
                //                    enter_log.append(consonant[vowel_index][cons_index])
                //                    is_vowel.toggle()
                //                    CheckVowelObj()
                //                }
                
                
                
                
                
                
            }
            
        }
        }
       
    }
    
}


// Use a Stepper to edit the stress level of an item
struct PracticeType1View: View {
    
    @State private var degital_rotate: CGFloat = 0.0
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
    let DeleteSpeed = 3.5 //削除操作が実行されるスピード
    let DecisionSpeed = -3.5//決定操作
    let CircleSpeed = 4.0
    @State private var HenkanCnt = 0 //変換の際に何回実行したか記憶する
    @State private var DeleteCnt:Double = 0.0
    @State private var prev_text = "" //変換される文字を記憶する
    
    
    //フレーズ入力関連レジスタ
    @State private var phrase_cnt = Int.random(in: 0 ..< r_phrase.count-1) //現在入力しているフレーズ
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
            
            if degital_rotate >= start_angle + offset_cons_angle * CGFloat(i) + padding_angle && degital_rotate  <= start_angle + offset_cons_angle * CGFloat(i + 1) - padding_angle {
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
                    Text(r_phrase[phrase_cnt])
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
                        sensitivity:.high, isContinuous:true){ event in
                            let crownSpeed = event.velocity
                            //                        print(crownSpeed)
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
                            }  else if crownSpeed == 0 {
                                DeleteFlag = false
                                
                            }else { // デジタルクラウンを動かしている時
                                
                                StartFlag = DeleteFlag ? false : true//DeleteしているときはStarFlagはOFF
                                SetCirclePos()
                                
                                
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
                    if phrase_dic.count < session_maxcnt {
                        
                        
                        
                        phrase_cnt = Int.random(in: 0 ..< r_phrase.count-1)
                        
                        while phrase_dic.keys.contains(phrase_cnt){
                            phrase_cnt = Int.random(in: 0 ..< r_phrase.count-1)
                            
                        }
                        phrase_dic[phrase_cnt] = 1
                        enter_text.removeAll()
                        enter_log.removeAll()
                        
                    }else{
                        isFinishSession = true
                    }
                    
                    
                }else{
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
            }
        }
       
    }
    
}

