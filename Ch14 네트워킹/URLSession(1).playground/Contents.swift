import UIKit

// MARK: URL

let urlString = "https://itunes.apple.com/search?media=music&entity=musicVideo&term=BoABETTER"
let url = URL(string: urlString) // 옵셔널 타입으로 출력

// MARK: URL 프로퍼티 확인
url?.absoluteString // 실제 urlString 출력
url?.scheme // 어떤 방식으로 네트워킹을 하고있는지 출력 (프로토콜명)
url?.host // 사이트 호스트
url?.path //
url?.query // 리퀘스트를 보낼 때의 쿼리 정보
url?.baseURL


// url?.baseURL이 nil이 안나오도록 재구성
let baseURL = URL(string: "https://itunes.apple.com/")
let relativeURL = URL(string: "search?media=music&entity=musicVideo&term=BoA", relativeTo: baseURL) // baseURL에다가 string을 추가한다는 의미

relativeURL?.absoluteString
relativeURL?.scheme
relativeURL?.host
relativeURL?.path
relativeURL?.query
relativeURL?.baseURL

// MARK: URLComponents
// query에 대한 아이템들을 string이 아닌 object 형식으로 추가하거나 접근
// 만약, term 부분을 BoA가 아닌, 한글명 '보아'로 바꿔 입력하면 인식을 못해서 프로퍼티 값 모두 nil 출력됨 (영어가 아닌 다른나라 언어로 입력하면 다 nil 뜸) (띄어쓰기도 같은 결과)
// => URLComponents를 이용해서 컴퓨터가 이해할 수 있게 변환시켜 해결!

var urlComponents = URLComponents(string: "https://itunes.apple.com/search?")
let mediaQuery = URLQueryItem(name: "media", value: "music")
let entityQuery = URLQueryItem(name: "entity", value: "musicVideo")
let termQuery = URLQueryItem(name: "term", value: "보아")

urlComponents?.queryItems?.append(mediaQuery)
urlComponents?.queryItems?.append(entityQuery)
urlComponents?.queryItems?.append(termQuery)
let requestURL = urlComponents?.url!

urlComponents?.url
urlComponents?.string // "보아" 라는 이름은 %EB%B3%B4%EC%95%84 이라는 이름으로 변환되어 검색에 입력됨
urlComponents?.queryItems
