//
//  ContentView.swift
//  crown_type
//
//  Created by shirane kaoru on 2023/10/06.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @State private var startFlag = false
    @State private var end = false
    @State private var startTime:Date = Date()
    @State private var CPM:String = ""
    @State var inputName = ""
    @ObservedObject private var connector = WatchConnector()
    var body: some View {
        VStack {
            
            Text(connector.receivedMessage)
                .bold()

        }
        .padding()
    }
}

class CSVFileManager{
    
    var filename: String
    var fileManager: FileManager
    
    var folder_name = "dial_crown/shirane"
   
    
    //初期化:filenameのファイルがなかった場合新たにファイルを作製
    init(filename: String) {
        //fileの設定
        self.filename = filename
        fileManager = FileManager.default
        let docPath = NSHomeDirectory() + "/Documents/" + folder_name
        let filePath = docPath + "/" + self.filename
        //csvデータに書き込むデータを定義
        let csv = "user,method,sessionID,phrase,phraseID,keystroke,TIME,CPM,TER\r\n"
        let data = csv.data(using: .utf8)
        
        let fileManager = FileManager.default
        do {
            try fileManager.createDirectory(atPath: docPath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            // エラーの場合
    
        }
        //ファイルが存在するかチェック
        if !fileManager.fileExists(atPath: filePath){
            fileManager.createFile(atPath: filePath, contents:data,attributes: [:])
        }else{
            print("すでに存在します")
        }
    }
    
    //csvファイル書き込み
    func write(content: String){
        let path = NSHomeDirectory() + "/Documents/" + folder_name + "/" + self.filename
        let tmpFile: URL = URL(fileURLWithPath: path)
        if let strm = OutputStream(url: tmpFile,append: false){
            strm.open()
            let BOM = "\u{feff}"
            // U+FEFF：バイトオーダーマーク（Byte Order Mark, BOM）
            // Unicode の U+FEFFは、表示がない文字。「ZERO WIDTH NO-BREAK SPACE」（幅の無い改行しない空白）
            strm.write(BOM, maxLength: 3)// UTF-8 の BOM 3バイト 0xEF 0xBB 0xBF 書き込み
            
            let new_content = "user,method,sessionID,phrase,phraseID,keystroke,TIME,CPM,TER\r\n" + content
            
            let data = new_content.data(using: .utf8)
            // string.data(using: .utf8)メソッドで文字コード UTF-8 の
            // Data 構造体を得る
            _ = data?.withUnsafeBytes {//dataのバッファに直接アクセス
                strm.write($0.baseAddress!, maxLength: Int(data?.count ?? 0))
                // 【$0】
                // 連続したメモリ領域を指す UnsafeRawBufferPointer パラメーター
                // 【$0.baseAddress】
                // バッファへの最初のバイトへのポインタ
                // 【maxLength:】
                // 書き込むバイトdataバッファのバイト数（全長）
                // 【data?.count ?? 0】
                // ?? は、Nil結合演算子（Nil-Coalescing Operator）。
                // data?.count が nil の場合、0。
                // 【_ = data】
                // 戻り値を利用しないため、_で受け取る。
            }
            strm.close() // ストリームクローズ
        }
//        let old_datas = self.read()
//        let datas = old_datas + content
//        do{
//            try datas.write(toFile: path, atomically: true,encoding: .utf8)
//        }catch{
//            print("failure")
//        }
        
    }
    
    //csvファイル読み込み
    func read() -> String{
        
        let path = NSHomeDirectory() + "/Documents/" + folder_name + "/" + self.filename
        
        do{
            let csvString = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
            return csvString
        }catch let error as NSError{
            print("エラー：\(error)")
            return ""
        }
    }
    
}


class WatchConnector: NSObject,ObservableObject,WCSessionDelegate{
    @Published var receivedMessage = ""
    @Published var timestamp = "0.0"
    @Published var count = 0
    @Published var file_name = ""
    @Published var user = "ashizawa"
    @Published var method = "layout_notouch_dial"
    @Published var sessionID = "0" //0:練習，１:本番
    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        print("activationDidCompleteWith state= \(activationState.rawValue)")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("sessionDidDeactivate")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        print("didReceiveMessage: \(message)")

        
        let file_name = "pstudy_ashizawa_notouch_dial_s1.csv"
        let file = CSVFileManager(filename: file_name)
        DispatchQueue.main.async {
            
            //csvファイルに書き込むために文字列を作成
            
            self.receivedMessage += "\(self.user),"
            self.receivedMessage += "\(self.method),"
            self.receivedMessage += "\(self.sessionID),"
            self.receivedMessage += "\(message["phrase"] as! String),"
            self.receivedMessage += "\(message["phraseID"] as! Int),"
            self.receivedMessage += "\(message["Keystroke"] as! Int),"
            self.receivedMessage += "\(message["Time"] as! String),"
            self.receivedMessage += "\(message["CPM"] as! String),"
            self.receivedMessage += "\(message["TER"] as! Double),"
            self.receivedMessage += "\(message["DeleteCnt"] as! Double)\r\n"
            print(self.receivedMessage)
            file.write(content:self.receivedMessage)
        }
    }
    
    //iPhoneに出力させる関数
    func data_print()->Text{
//        addfile(datas:self.receivedMessage)
        return Text(self.receivedMessage)
    }
}
