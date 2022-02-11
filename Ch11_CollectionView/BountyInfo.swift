//
//  BountyInfo.swift
//  ch9_OnePiece
//
//  Created by 정현준 on 2021/03/26.
//  Copyright © 2021 hyeon. All rights reserved.
//

import UIKit

struct BountyInfo {
    let name: String
    let bounty: Int
    var image: UIImage? {
        return UIImage(named: "\(name).jpg")
    }

    init(name:String, bounty: Int){
        self.name = name
        self.bounty = bounty
    }
}
