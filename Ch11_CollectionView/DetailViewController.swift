//
//  DetailViewController.swift
//  ch9_OnePiece
//
//  Created by 정현준 on 2021/03/24.
//  Copyright © 2021 hyeon. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: Chapter10 기존 MVC에서 MVVM으로 리팩터링
    // Model
    // - BountyInfo
    // > BountyInfo 만들자

    // View
    // - imgView, nameLabel, bountylabel
    // > view들은 viewModel를 통해서 구성되기 ?


    // ViewModel
    // - DetailViewModel
    // > 뷰레이어에서 필요한 메서드 만들기
    // > 모델 가지고 있기 ,, BountyInfo 들

    // MARK: Chapter11. Animation 작업
    // 작업1: 레이블이 오른 -> 왼 방향으로 수평으로만 움직이며 중앙에 나타나게 만들기
        // +) 뷰 단위로 Animation 작업하기 ... 오른쪽에서 커졌다 작아지기 + 회전하기 구현
        // +) 레이블이 투명이였다가 진해지도록 만들기
    // 작업2: 이미지가 뒤집어져서(flipping) 나타나게 만들기




    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bountyLabel: UILabel!

    // MARK:애니메이션 작업 1-1 일직선 상에서만 움직이게 이름, 현상금 레이블 x좌표 outlet 설정
    @IBOutlet weak var nameLabelCenterX: NSLayoutConstraint!
    @IBOutlet weak var bountyLabelCenterX: NSLayoutConstraint!


    // MARK: MVVM(1): Model - BountyInfo
    let viewModel = DetailViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        prepareAnimation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimation()
    }

    private func prepareAnimation(){

        // +) 이름에 오른쪽에서부터 커졌다 작아지면서 들어오도록 기본환경 세팅
            // scaledBy로 x, y축 3배씩 확대
            // rotated로 180도 회전
        nameLabel.transform = CGAffineTransform(translationX: view.bounds.width, y: 0).scaledBy(x:3, y:3).rotated(by: 180)
        bountyLabel.transform = CGAffineTransform(translationX: view.bounds.width, y: 0).scaledBy(x:3, y:3).rotated(by: 180)

        // 레이블 투명하게 세팅하기
        nameLabel.alpha = 0
        bountyLabel.alpha = 0
    }

    private func showAnimation(){

        // nameLabel, bountyLabel 따로 설정하여 구현하기
        // 왜?) 한번에 만들어도 되는데 따로 떼서 만들면 생동감이 좀 더 느껴짐

        // nameLabel
        UIView.animate(withDuration: 1, delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 2,
                       options: .allowUserInteraction, animations: {
                        // .identity를 이용하여 변하기 이전의 모습으로 접근
                        self.nameLabel.transform = CGAffineTransform.identity
                        self.nameLabel.alpha = 1

        },completion: nil)

        // bountyLabel ... nameLabel 보다 살짝 늦게 나타나게 하기위해 delay를 0.2초 준다
        UIView.animate(withDuration: 1, delay: 0.2,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 2,
                       options: .allowUserInteraction, animations: {
                        // .identity를 이용하여 변하기 이전의 모습으로 접근
                        self.bountyLabel.transform = CGAffineTransform.identity
                        self.bountyLabel.alpha = 1
        },completion: nil)

         UIView.transition(with: imgView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }

    func updateUI() {
        if let bountyInfo = viewModel.bountyInfo {
                   imgView.image = bountyInfo.image
                   nameLabel.text = bountyInfo.name
                   bountyLabel.text = "\(bountyInfo.bounty)"
               }
    }

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: MVVM(2): ViewModel - DetailViewModel
class DetailViewModel {
    var bountyInfo: BountyInfo?

    func update(model: BountyInfo) {
        bountyInfo = model

    }

}



