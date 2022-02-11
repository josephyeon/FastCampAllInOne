//
//  BountyViewController.swift
//  ch9_OnePiece
//
//  Created by 정현준 on 2021/03/24.
//  Copyright © 2021 hyeon. All rights reserved.
//

// MARK: Ch9. 코드리뷰
/* 1. 현상금 순위대로 정렬되어야 하는데 안되어 있음
   2. 코드 깔끔하게 정리되어있지 않음*/

// MARK: MVVM ... 디자인 패턴으로 코드 정리하기
// Model
// - BountyInfo
// > BountyInfo 만들자

// View
// - GridCell
// > GridCell 필요한 정보를 ViewModel한테서 받아야겠다
// > GridCell은 ViewModel로 부터 받은 정보로 뷰 업데이트 하기

// ViewModel
// - BountyViewModel
// > BountyViewModel을 만들고, 뷰레이어에서 필요한 메서드 만들기
// > 모델 가지고 있기 ,, BountyInfo 들

import UIKit

class BountyViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    let viewModel = BountyViewModel()

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            let vc = segue.destination as? DetailViewController
            if let index = sender as? Int {
                let bountyInfo = viewModel.bountyInfo(at:index)
                vc?.viewModel.update(model:bountyInfo)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: UICollectionViewDataSource
    // 몇개를 보여줄까?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numOfBountyInfoList
    }

    // 셀은 어떻게 표현할까 ... Table 작성했을 때 재사용 원리와 같음!
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as? GridCell else {
            return UICollectionViewCell()
        }

        let bountyInfo = viewModel.bountyInfo(at:indexPath.item)
            cell.update(info: bountyInfo)
        cell.update(info: bountyInfo)
        return cell
    }

    //MARK: UICollectionViewDelegate
    // 셀이 클릭 되었을 때 어떻게 될까?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            performSegue(withIdentifier: "showDetail", sender: indexPath.item)
    }

    //MARK: UICollectionViewDelegateFlowLayout
    // 셀 사이즈가 디바이스마다 균형적으로 바뀌게 계산하기 (필수 구현은 아님)
    // 왜?) (이미지 등의) 사이즈가 너무 크면 1줄에 1개씩 나오는 테이블 형태로만 출력될 수 있음

    // > 한 줄에 두개씩 배치하고 컬렉션 간격, 줄 간격 각각 10이 되도록 설정해보자
    // 사전 전제조건
    // 각 컬렉션 너비 = (전체 너비 - 컬렉션 간격) / 2
    // 컬렉션 높이 = 이미지 height (= 너비 * (10/7) ) + 65 (레이블 표시 구역)
    // (10 / 7 ) .... 이미지 비율 7:10 고정하기 위해

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let itemSapcing: CGFloat = 10 // 컬렉션 간격, 줄 간격
        let textAreaHeight: CGFloat = 65 // 레이블 표시 구역

        let width: CGFloat = (collectionView.bounds.width - itemSapcing) / 2
        let height: CGFloat = (width * (10/7) + textAreaHeight) // 이미지 height (= 너비 * (10/7) ) + 65 (레이블 표시 구역)
        return CGSize(width: width, height: height)
    }

}

// MARK: MVVM(1): Model - BountyInfo
// 코드가 길어져서 BountyInfo.swift 파일로 빼냄 거기가서 참고 (NSObject)

// MARK: MVVM(2): ViewModel - BountyViewModel
class BountyViewModel {
    // 뷰 모델은 모델(데이터를) 가지고 있어야 한다
    let bountyInfoList: [BountyInfo] = [
        BountyInfo(name: "brook", bounty: 33000000),
        BountyInfo(name: "chopper", bounty: 50),
        BountyInfo(name: "franky", bounty: 44000000),
        BountyInfo(name: "luffy", bounty: 300000000),
        BountyInfo(name: "nami", bounty: 16000000),
        BountyInfo(name: "robin", bounty: 80000000),
        BountyInfo(name: "sanji", bounty: 77000000),
        BountyInfo(name: "zoro", bounty: 120000000)
    ]

    var sortedList: [BountyInfo] {     //MARK: 현상금 랭킹 설정하기
        let sortedList = bountyInfoList.sorted { prev, next in
            return prev.bounty > next.bounty
        }
        return sortedList
    }

    // 모델에 직접 엑세스가 아닌 뷰 모델을 통해 우회하여 엑세스 하도록 메서드 생성
    var numOfBountyInfoList: Int{
        return bountyInfoList.count
    }

    func bountyInfo(at index: Int) -> BountyInfo {
        return sortedList[index]
    }
}

class GridCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bountyLabel: UILabel!

    func update(info: BountyInfo) {
             imgView.image = info.image
             nameLabel.text = info.name
             bountyLabel.text = "\(info.bounty)"
    }
}
