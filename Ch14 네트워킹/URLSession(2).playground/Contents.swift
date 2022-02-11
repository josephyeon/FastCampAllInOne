import UIKit

// URLSession을 이용한 네트워킹

// MARK: URLSession
// 1. URLSessionConfiguration
// 2. URLSession
// 3. URLSessionTask를 이용해 서버와 네트워킹

// MARK: URLSessionTask
// - dataTask
// - uploadTask
// - downloadTask

let config = URLSessionConfiguration.default // URLSessionConfiguration
let session = URLSession(configuration: config) // URLSessionConfiguration바탕으로 URLSession 생성

// URL (URL Components)
var urlComponents = URLComponents(string: "https://itunes.apple.com/search?")! // 옵셔널 강제 해제
let mediaQuery = URLQueryItem(name: "media", value: "music")
let entityQuery = URLQueryItem(name: "entity", value: "musicVideo")
let termQuery = URLQueryItem(name: "term", value: "보아")

urlComponents.queryItems?.append(mediaQuery)
urlComponents.queryItems?.append(entityQuery)
urlComponents.queryItems?.append(termQuery)

let requestURL = urlComponents.url!

// MARK: URLSession 심화 ... response 받은 데이터를 이용해 필요한 object를 만들자
// 목표: 트랙리스트 오브젝트로 가져오기

/* 하고 싶은 욕구 목록
1) data -> Track 목록으로 가져오고 싶다: [Track]
2) Track이라는 Object를 만들어야곘다
3) Data에서 struct로 파싱하고 싶다 > ToDoList에서 사용한 Codable 이용해서 만들자
      3-1) JSON형태 파일, 데이터를 object로 만들 때 Codable을 이용!
      3-2) postman을 통해 검색기록을 보면 "results": [{검색결과}, {검색결과}, ... ] 으로 구성됨
            => Response 구조를 만들고 그 안에 track이 여러개 구성되도록 작성
            => 따라서, Response와 Track 이렇게 두 개를 만들어야겠다
 */
/* 해야 할 일
 1. Response, Track 구조체 작성
 2. struct의 프로퍼티 이름과 실제 데이터의 키를 맞추기 (Codable 디코딩이 가능하도록)
 3. 파싱하기 (디코딩)
 4. 실제 트랙리스트 가져오기
 */

// URLSession 심화 1
// Response, Track 구조체 작성하고, CodingKeys라는 이름으로 프로퍼티 이름과 실제 데이터의 키를 맞추기
struct Response: Codable { // postman에서 get 요청을 보내 얻은 값
    let resultCount: Int
    let tracks: [Track]

    enum CodingKeys: String, CodingKey {
        case resultCount
        case tracks = "results"
    }
}

struct Track: Codable {
    let title: String
    let artistName: String
    let thumbnailPath: String

    enum CodingKeys: String, CodingKey {
        case title = "trackName"
        case artistName
        case thumbnailPath = "artworkUrl100"
    }

    // trackName
    // artistName
    // artworkUrl30
}

// - dataTask 생성
let dataTask = session.dataTask(with: requestURL) {(data, response, error) in
    // 에러 있는지 먼저 확인
    guard error == nil else {return}

    // statusCode가 2xx가 나와야지 성공이기 때문에 이를 확인한다
    guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {return}
    let successRange = 200..<300

    guard successRange.contains(statusCode) else {
        // 성공 아닌 경우 에러 처리
        return
    }

    // data가 옵셔널이기 때문에 해제 필요
    guard let resultData = data else {return}
    let resultSring = String(data: resultData, encoding: .utf8)

//    print("-------> result: \(resultData)") // 거래량 출력
//    print("-------> result: \(resultSring)") // 거래 데이터 출력

    // URLSession 심화 2
    // 파싱 및 트랙 가져오기

    do {
        let decoder = JSONDecoder()
        let response = try decoder.decode(Response.self, from: resultData)
        // 성공한다는 보장이 없기 때문에 try문을 걸어두고 에러 발생시 catch문으로 넘어간다
        let tracks = response.tracks

        // 검색 결과량, 마지막 트랙 타이틀명, 썸네일 URL 출력 (썸네일은 해상도 작은걸 사용함)
        print("=> tracks: \(tracks.count).  -\(tracks.last?.title), \(tracks.last?.thumbnailPath)")
    } catch let error {
        print("=> Error: \(error.localizedDescription)")
    }
}

// 만들어낸 dataTask를 실행 -> 실제 네트워킹 진행
dataTask.resume()
// 실제 진행된 거래량(resultData), 데이터 출력됨(resultSring)
// 데이터의 경우, postman에서 requestURL 값을 입력하면 내용이 일치해 검색 성공 확인 가능
