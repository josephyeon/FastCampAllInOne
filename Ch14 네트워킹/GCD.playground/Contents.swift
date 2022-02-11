import UIKit

// MARK: Queue - Main, Global, Custom

// - main queue
DispatchQueue.main.async {
    //UI update
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
}

// - global queue
DispatchQueue.global(qos: .userInteractive).async{
    // 지금 당장 해야하는 것
}

DispatchQueue.global(qos: .userInitiated).async{
    // 거의 바로 해줘야 하는 것
    // 사용자가 결과를 기다리는 경우
}

DispatchQueue.global(qos: .default).async{
    // 이건 굳이..?
    // DispatchQueue.global().async 이렇게 쓰는거랑 비슷할지도
}

DispatchQueue.global(qos: .utility).async {
    // 시간이 좀 걸리는 일들
    // 사용자가 당장 기다리지 않는 것
    // 네트워킹, 큰 파일 불러올 때
}

DispatchQueue.global(qos: .background).async {
    // 사용자에게 당장 인식될 필요가 없는 것들
    // 뉴스데이터 미리 받기
    // 위치 업데이트
    // 고해상도 영상 다운로드
    // 주의!) 개인정보를 빼가는 경우가 있으니 보안에 주의!
}

// - custom queue

let concurrentqueue = DispatchQueue(label: "concurrent", qos: .background, attributes: .concurrent)
let serialQueue = DispatchQueue(label: "serial", qos: .background)


// MARK: 복잡한 상황: 작업간 의존

func downloadImageFromServer() -> UIImage {
    // heavy task
    return UIImage()
}

func updateUI(image: UIImage){

}

DispatchQueue.global(qos: .background).async {
    let image = downloadImageFromServer() // 이미지 다운로드

    DispatchQueue.main.async {
        updateUI(image:image) // 다운로드 받은 이미지로 업데이트 -> 인터페이스 변경이기 때문에 메인 스레드에서 처리!
    }
}

// MARK: Sync, Async

// async: 동시성을 잘 제공하기 위해서 대부분 사용
DispatchQueue.global(qos: .background).async {
    for i in 0...5 {
        print("😈 \(i)")
    }
}

DispatchQueue.global(qos: .userInteractive).async {
    for i in 0...5 {
        print("😢 \(i)")
    }
}

// sync: 인과관계가 정말 명확한 경우에 사용
DispatchQueue.global(qos: .background).sync {
    for i in 0...5 {
        print("😈 \(i)")
    }
}

DispatchQueue.global(qos: .userInteractive).sync {
    for i in 0...5 {
        print("😢 \(i)")
    }
}
