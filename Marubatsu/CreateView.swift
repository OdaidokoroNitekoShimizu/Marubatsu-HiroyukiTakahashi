//
//  CreateView.swift
//  Marubatsu
//
//  Created by hiroyuki takahashi on R 7/11/08.
//

import SwiftUI

struct CreateView: View {
    @Binding var quizzesArray:[Quiz]//解答画面で読み込んだ問題を受け取る。
    @State private var questionText = ""//テキストフィールドの文字を受け取る変数
    @State private var selectedAnswer = "O"//ピッカーで選ばれた解答を受け取る。
    let answers = ["O","X"]

    var body: some View {
        VStack{
            Text("問題文と解答を入力して追加ボタンを押してください")
                .foregroundStyle(.gray)
                .padding()

            TextField(text: $questionText) {
                Text("問題文を入力してください")
            }
            .padding()
            .textFieldStyle(.roundedBorder)

            //回答を選択するピッカー
            Picker("解答", selection: $selectedAnswer){
                ForEach(answers, id: \.self) { answer in
                    Text(answer)

                }
                //↑これの意味
                //                Text("O")
                //                Text("X")

            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 300)
            .padding()

            //追加して保存
            Button("追加"){
                //追加ボタンを押された時の処理
                addQuiz(question: questionText, answer: selectedAnswer)
            }
            .padding()

            //全削除ボタン
            Button {
                quizzesArray.removeAll()//配列を空に
                UserDefaults.standard.removeObject(forKey: "quiz")//保存されているものも全削除
            } label: {
                Text("全削除")
            }
            .foregroundStyle(.red)
            .padding()

        }

    }

    func addQuiz(question:String,answer:String){
        if question.isEmpty{//未入力の時 「""」←これも未入力扱い
            print("問題文が入力されていません")
            return

        }
        //問題文があったときは以下に処理が続く
        var savingAnswer = true
        //"O""X"かでtrue/falseを切り替える
        switch answer {
        case "O":
            savingAnswer = true
        case "X":
            savingAnswer = false
        default:
            print("適切な答えが入っていません")
            break//処理を終えて抜ける
        }
        let newQuiz = Quiz(question: question, answer: savingAnswer)

        var array: [Quiz] = quizzesArray//読み込んでできた問題を一時的に別の配列へ
        //Quizの配列を用意[]からの配列の場合
        array.append(newQuiz)
        let storeKey = "quiz"

        if let encodedQuizzes = try? JSONEncoder().encode(array) {
            UserDefaults.standard.set(encodedQuizzes, forKey: storeKey)
            questionText = ""//テキストフィールドを空白に戻す
            quizzesArray = array//[既存問題+新問題]となった配列に更新
            print(array)
        }

    }
}

//#Preview {
//    CreateView()
//}
