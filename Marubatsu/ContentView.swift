//
//  ContentView.swift
//  Marubatsu
//
//  Created by hiroyuki takahashi on R 7/11/08.
//

import SwiftUI

struct Quiz: Identifiable,Codable,Hashable{
    var id = UUID()//設問を区別するID
    var question: String//問題文
    var answer: Bool//解凍
}

struct ContentView: View {
    // 問題
    let quizExamples: [Quiz] = [
        Quiz(question: "iPhoneアプリを開発する統合環境はZcodeである", answer: false),
        Quiz(question: "Xcode画面の右側にはユーティリティーズがある", answer: true),
        Quiz(question: "Textは文字列を表示する際に利用する", answer: true)
    ]

    //UserDefaultsから問題を読み込む(Data型)
    @AppStorage("quiz") var quizzesData = Data()
    @State var quizzesArray:[Quiz] = []

    @State var currentQuestionNum: Int = 0//今、何問目の数字
    @State var showingAlert = false//アラートの表示・非表示を管理
    @State var alertTitle = ""//正解か不正解かの文字を入れるようの変数


    //起動時に読み込んだ値(Data型)を[Quiz]型にデコードしてquizzesArrayに入れる。
    init(){
        if let decodedQuizzes = try? JSONDecoder().decode([Quiz].self, from: quizzesData) {
            _quizzesArray = State(initialValue: decodedQuizzes)
        }
    }

    var body: some View {
        NavigationStack{
            GeometryReader {geometry in
                VStack {
                    Text(showQuestion())
                        .padding()//上下左右の余白
                    //横幅を親ビューんお横幅の0.85倍に、左寄せに
                        .frame(width: geometry.size.width * 0.85,
                               alignment: .leading)//横幅250、左寄せに
                        .font(.system(size:25))//フォントサイズを25に
                        .fontDesign(.rounded)//丸みのあるフォントに
                        .background(.yellow)//背景を黄色に

                    Spacer()//余白

                    HStack{
                        Button {
                            print("O")//ボタンが押された時の処理
                            checkAnswer(yourAnswer: true)
                        } label: {
                            Text("O")//ボタンの見た目
                        }
                        //横幅と高さを親ビューの横幅の0.4倍を指定
                        .frame(width: geometry.size.width * 0.4,
                               height: geometry.size.width * 0.4)
                        .font(.system(size: 100,weight: .bold))//フォントサイズ100,太字
                        .foregroundStyle(.white)//文字を白に
                        .background(.red)//背景を赤に

                        Button {
                            print("X")//ボタンが押された時の処理
                            checkAnswer(yourAnswer: false)
                        } label: {
                            Text("X")//ボタンの見た目
                        }
                        .frame(width: geometry.size.width * 0.4,
                               height: geometry.size.width * 0.4)
                        .font(.system(size: 100,weight: .bold))//フォントサイズ100,太字
                        .foregroundStyle(.white)//文字を白に
                        .background(.blue)//背景を赤に

                    }

                }
                .padding()
                //ズレを治すのに親ビューのサイズをVstackに適用
                .frame(width: geometry.size.width,
                       height: geometry.size.height)
                .navigationTitle("マルバツクイズ")
                //回答時のアラート
                .alert(alertTitle, isPresented: $showingAlert) {
                    Button("OK",role:.cancel){}//ボタンを押した時の処理なし
                }
                //問題作成画面へ遷移するボタン
                .toolbar{
                    //配置する場所を画面上部のバーの右端に設定
                    ToolbarItem(placement: .topBarTrailing){
                        NavigationLink {
                            CreateView(quizzesArray: $quizzesArray)//遷移先の画面
                                .navigationTitle("問題を作ろう!")
                        } label: {
                            Image(systemName: "plus")
                                .font(.title)
                        }

                    }
                }
            }
        }
        .onAppear(){
            currentQuestionNum = 0
        }
    }

        //問題を表示する関数
        func showQuestion() -> String {
            //配列から⚪︎⚪︎問目の問題文を取り出して代入
            //        let question = quizExamples[currentQuestionNum].question
            var question = "問題がありません"


            //問題があるかどうかのチェック
            if !quizzesArray.isEmpty{ //問題が存在する時
                let quiz = quizzesArray[currentQuestionNum]
                question = quiz.question
            }
            return question
        }

        //回答を表示する関数、正解なら次の問題を表示
        func checkAnswer(yourAnswer: Bool) {

            if quizzesArray.isEmpty {return}//問題がない時は解答チェックしない。


            let quiz = quizzesArray[currentQuestionNum]//表示されているクイズを取り出す。
            let ans = quiz.answer//クイズから回答を取り出す。

            if yourAnswer == ans {//正解の時
                alertTitle = "正解"
                //現在の問題番号が問題数(quizzesArray.count)を超えないように場合分け
                if currentQuestionNum + 1 < quizzesArray.count {
                    //currentQuestionNumに1を足して次の問題に進む
                    currentQuestionNum += 1
                    //上記は省略表記
                    //currentQuestionNum = currentQuestionNum + 1

                } else{
                    //超える時は0に戻す
                    currentQuestionNum = 0
                }

            }else{
                //不正解の時
                alertTitle = "不正解"
            }
            showingAlert = true //アラートを表示させる
        }
    }

    #Preview {
        ContentView()
    }
