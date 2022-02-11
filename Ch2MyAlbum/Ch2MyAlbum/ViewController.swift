//
//  ViewController.swift
//  Ch2MyAlbum
//
//  Created by 정현준 on 2021/03/22.
//  Copyright © 2021 hyeon. All rights reserved.
//

// 사진 어플 만들기
// 인터페이스 빌드 구성: 타이틀 텍스트, 이미지, 가격 텍스트, 리프레시 버튼

import UIKit

class ViewController: UIViewController {

    var currentValue = 0

    // 인터페이스상의 UIImageView 바로 아래에 있는 가격 레이블과 프로퍼티 연결
    @IBOutlet weak var priceLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshPrice() // 가격 레이블이 어플리케이션 실행때부터 랜덤값이 나오도록 설정

    }

    @IBAction func showAlert(_ sender: Any) {
        let message = "가격은 ₩\(currentValue)입니다."

        let alert = UIAlertController(title: "금액", message: message, preferredStyle:.alert)

        // refresh해서 알림창 끄고난 뒤 값이 바뀌도록 하려면 블럭 맨 아래 refreshPrice()를
        // handler: 에 클로저 형태로 옮겨 넣어줘야 함!
        // 만약, handler: nil이고, 마지막에 refreshPrice 있으면
        // 숫자가 먼저 바뀌고 알림창이 뜸
        let action = UIAlertAction(title: "OK", style: .default, handler: { action in self.refreshPrice() })
        alert.addAction(action)

        present(alert, animated:true, completion: nil)

//        refreshPrice()

    }

    // 가격 레이블 랜덤값 생성 메서드 (리프레시를 위해 입력하는 코드가 중복되기 때문에 앞에 함수로 빼내서 만들었음)
    func refreshPrice() {

        // 가격 레이블에 처음부터 랜덤값이 나오도록 설정하기
        let randomPrice = arc4random_uniform(10000) + 1 // 무작위로 나온 수를 randomPrice라고 설정
        currentValue = Int(randomPrice) // randomPrice가 Uint32이라서 타입이 미묘하게 다름

        priceLabel.text = "₩ \(currentValue)"

    }






}


