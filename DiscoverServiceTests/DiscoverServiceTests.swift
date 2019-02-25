//
//  DiscoverServiceTests.swift
//  DiscoverServiceTests
//
//  Created by 강준영 on 21/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import XCTest
//import CoreData
@testable import CoCo

class DiscoverServiceTests: XCTestCase {

    let networkManagerType = MockShoppingNetworkManager.shared
    let algorithmManagerType = Algorithm()
    let searchWordDoreDataManagerType = MockSearchWordCoreDataManager()
    let myGoodsCoreDataManagerType = MockMyGoodsCoreDataManager()
    let petKeywordCoreDataManagerType = MockPetKeywordCoreDataManager()
    var discoverService: DiscoverService?

    override func setUp() {
        discoverService = DiscoverService(networkManagerType: MockShoppingNetworkManager.shared, algorithmManagerType: Algorithm(), searchWordDoreDataManagerType: MockSearchWordCoreDataManager(), myGoodsCoreDataManagerType: MockMyGoodsCoreDataManager(), petKeywordCoreDataManagerType: PetKeywordCoreDataManager())
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchPet() {
        guard let discoverService = discoverService else {
            return
        }
        discoverService.fetchPet()
        XCTAssertEqual(PetDefault.shared.pet, discoverService.pet)
        XCTAssert(discoverService.pet.rawValue != "고양이")
    }

    func testFetchMyGoods() {
        guard let discoverService = discoverService else {
            return
        }
        let result =  discoverService.fetchMyGoods()
        print(result)
        XCTAssert(discoverService.myGoods.count != 0, "최근본 상품과 즐겨찾기 한 상품이 없습니다.")
    }

    func testFetchSearchword() {
        guard let discoverService = discoverService else {
            return
        }
        let result = discoverService.fetchSearchWord()
        print(result)
        print(result.count != 0, "최근본 상품이 없습니다.")
    }

    func testFetchPetKeyword() {
        guard let discoverService = discoverService else {
            return
        }
        let result = discoverService.fetchPetKeywords()
        print(result)
        XCTAssert(result != nil, "펫과 키워드 정보가 없습니다.")
    }

    func testMixedWord() {
        guard let discoverService = discoverService else {
            return
        }
        // keyword guard
        discoverService.keyword = nil
        let result = discoverService.mixedWord()
        XCTAssert(result.count == 0)
        
        // 정상작동
        discoverService.fetchMyGoods()
        discoverService.fetchSearchWord()
        discoverService.fetchPetKeywords()
        discoverService.mixedWord()
        XCTAssert(discoverService.mixedletSearches.count > 0, "데이터를 섞는 데 실패했습니다.")
        
        
    }

    func testRequest() {
        guard let discoverService = discoverService else {
            return
        }

        var result = false
        discoverService.fetchMyGoods()
        discoverService.fetchSearchWord()
        discoverService.fetchPetKeywords()
        discoverService.mixedWord()
        discoverService.request { (isSuccess, error, count) in
            print(count)
            XCTAssertEqual(count, 20)
            XCTAssertEqual(isSuccess, true)
        }
    }
}

// MockData
class MockShoppingNetworkManager: NetworkManagerType {

    // MARK: - Initializer
    static let shared = MockShoppingNetworkManager()
    private init() { }

    // MARK: - Methods
    func getAPIData(_ params: ShoppingParams, completion: @escaping (APIResponseShoppingData) -> Void, errorHandler: @escaping (Error) -> Void) {
        let data = Data(MockShoppingNetworkManagerDummy.successDummyString.utf8)
        let responseAPI = ResponseAPI()
        do {
            try responseAPI.parse(data: data, completion: completion)
        } catch let err {
            print(err)
            errorHandler(err)
        }
    }

    func getImageData(url: String, completion: @escaping (Data?, Error?) -> Void) {
        completion(nil, nil)
    }

    func cancelImageData(url: String) {
        print(url)
    }

}

class MockShoppingNetworkManagerDummy {
    static let search = "강아지 간식"
    static let failSearch = "실패"
    static let params = ShoppingParams(search: "강아지 간식", count: 20, start: 21, sort: .similar)
    static let failDummyString = """
{
    "lastBuildDate": "Fri, 22 Feb 2019 17:25:55 +0900",
    "total": 0,
    "start": 21,
    "display": 0,
    "items": []
}
"""
    static let successDummyString = """
{
"lastBuildDate": "Thu, 21 Feb 2019 15:34:11 +0900",
"total": 2227778,
"start": 21,
"display": 20,
"items": [
{
"title": "<b>강아지</b> 시저 통조림 사각캔 습식사료 <b>간식</b> 파우치 100g 퍼피프랜드 100g",
"link": "http://search.shopping.naver.com/gate.nhn?id=12768417958",
"image": "https://shopping-phinf.pstatic.net/main_1276841/12768417958.jpg",
"lprice": "640",
"hprice": "0",
"mallName": "제이엠트레이더스",
"productId": "12768417958",
"productType": "2"

},
{
"title": "네이월 눈물해방 소간육포 <b>강아지</b>수제<b>간식</b>",
"link": "http://search.shopping.naver.com/gate.nhn?id=16599429302",
"image": "https://shopping-phinf.pstatic.net/main_1659942/16599429302.20181213151213.jpg",
"lprice": "4200",
"hprice": "8300",
"mallName": "네이버",
"productId": "16599429302",
"productType": "1"

},
{
"title": "덴티페어리 2박스 (SS/S/M)/개별포장/<b>강아지</b>/덴탈껌",
"link": "http://search.shopping.naver.com/gate.nhn?id=12674572957",
"image": "https://shopping-phinf.pstatic.net/main_1267457/12674572957.1.jpg",
"lprice": "43570",
"hprice": "0",
"mallName": "인터파크",
"productId": "12674572957",
"productType": "2"

},
{
"title": "[한국사료] 포켄스 카누들 덴탈껌 (S) 소형견용 100p",
"link": "http://search.shopping.naver.com/gate.nhn?id=14648565666",
"image": "https://shopping-phinf.pstatic.net/main_1464856/14648565666.jpg",
"lprice": "23780",
"hprice": "0",
"mallName": "현대Hmall",
"productId": "14648565666",
"productType": "2"

},
{
"title": "포켄스 덴탈스틱 (작은별) 220g 블루베리 오메가 칼슘",
"link": "http://search.shopping.naver.com/gate.nhn?id=16869335064",
"image": "https://shopping-phinf.pstatic.net/main_1686933/16869335064.jpg",
"lprice": "5250",
"hprice": "0",
"mallName": "인터파크",
"productId": "16869335064",
"productType": "2"

},
{
"title": "아침애 오리버거 100g",
"link": "http://search.shopping.naver.com/gate.nhn?id=13098986042",
"image": "https://shopping-phinf.pstatic.net/main_1309898/13098986042.20171228101740.jpg",
"lprice": "380",
"hprice": "128900",
"mallName": "네이버",
"productId": "13098986042",
"productType": "1"

},
{
"title": "ANF 화이트 밀크스틱 4P",
"link": "http://search.shopping.naver.com/gate.nhn?id=12413925674",
"image": "https://shopping-phinf.pstatic.net/main_1241392/12413925674.20171009141912.jpg",
"lprice": "1530",
"hprice": "11190",
"mallName": "네이버",
"productId": "12413925674",
"productType": "1"

},
{
"title": "거성푸드 네츄럴펫스낵 오리목뼈 <b>애견</b><b>간식</b>",
"link": "http://search.shopping.naver.com/gate.nhn?id=16256754284",
"image": "https://shopping-phinf.pstatic.net/main_1625675/16256754284.20181122150441.jpg",
"lprice": "3700",
"hprice": "3900",
"mallName": "네이버",
"productId": "16256754284",
"productType": "1"

},
{
"title": "<b>간식</b>증정/ 포켄스 뉴트리션트릿 800g /눈물/피부/관절",
"link": "http://search.shopping.naver.com/gate.nhn?id=16597109767",
"image": "https://shopping-phinf.pstatic.net/main_1659710/16597109767.jpg",
"lprice": "39560",
"hprice": "0",
"mallName": "인터파크",
"productId": "16597109767",
"productType": "2"

},
{
"title": "[롯데아이몰][더그린]더그린 덴탈껌스틱 54P+17P 세트구성/총71P",
"link": "http://search.shopping.naver.com/gate.nhn?id=15885536019",
"image": "https://shopping-phinf.pstatic.net/main_1588553/15885536019.jpg",
"lprice": "8920",
"hprice": "0",
"mallName": "인터파크",
"productId": "15885536019",
"productType": "2"

},
{
"title": "네추러스 국내산 수제껌 16종 1p 3p 5p 10p 개껌",
"link": "http://search.shopping.naver.com/gate.nhn?id=10757731157",
"image": "https://shopping-phinf.pstatic.net/main_1075773/10757731157.jpg",
"lprice": "1170",
"hprice": "0",
"mallName": "인터파크",
"productId": "10757731157",
"productType": "2"

},
{
"title": "덴티스츄 레귤러 283g /치석제거용/먹는치약/덴티스껌",
"link": "http://search.shopping.naver.com/gate.nhn?id=15243056198",
"image": "https://shopping-phinf.pstatic.net/main_1524305/15243056198.jpg",
"lprice": "16010",
"hprice": "0",
"mallName": "인터파크",
"productId": "15243056198",
"productType": "2"

},
{
"title": "프레스키 터키츄 칠면조힘줄 하드링 하드본 (S/M/L)",
"link": "http://search.shopping.naver.com/gate.nhn?id=81643451541",
"image": "https://shopping-phinf.pstatic.net/main_8164345/81643451541.1.jpg",
"lprice": "1000",
"hprice": "0",
"mallName": "아인팩토리",
"productId": "81643451541",
"productType": "2"

},
{
"title": "내추럴EX 한우 불리스틱 1p (초소형 소형 중형 대형)/<b>강아지</b>불리스틱",
"link": "http://search.shopping.naver.com/gate.nhn?id=80043354013",
"image": "https://shopping-phinf.pstatic.net/main_8004335/80043354013.jpg",
"lprice": "1040",
"hprice": "0",
"mallName": "라임펫",
"productId": "80043354013",
"productType": "2"

},
{
"title": "초대박 대용량300-400g/애견간식 <b>강아지간식</b> 모음상품",
"link": "http://search.shopping.naver.com/gate.nhn?id=9831077732",
"image": "https://shopping-phinf.pstatic.net/main_9831077/9831077732.5.jpg",
"lprice": "1750",
"hprice": "0",
"mallName": "막둥이펫",
"productId": "9831077732",
"productType": "2"

},
{
"title": "<b>강아지</b>사료 <b>간식</b> 시저캔 6개입",
"link": "http://search.shopping.naver.com/gate.nhn?id=10235056524",
"image": "https://shopping-phinf.pstatic.net/main_1023505/10235056524.9.jpg",
"lprice": "8000",
"hprice": "0",
"mallName": "한국마즈공식온라인몰",
"productId": "10235056524",
"productType": "2"

},
{
"title": "마도로스펫 연어트릿 130g",
"link": "http://search.shopping.naver.com/gate.nhn?id=12340505370",
"image": "https://shopping-phinf.pstatic.net/main_1234050/12340505370.20180723145226.jpg",
"lprice": "22000",
"hprice": "22000",
"mallName": "네이버",
"productId": "12340505370",
"productType": "1"

},
{
"title": "<b>강아지</b> 개껌 포켄스 덴티페어리 모음 대용량",
"link": "http://search.shopping.naver.com/gate.nhn?id=10958996818",
"image": "https://shopping-phinf.pstatic.net/main_1095899/10958996818.3.jpg",
"lprice": "29000",
"hprice": "0",
"mallName": "개밥왕",
"productId": "10958996818",
"productType": "2"

},
{
"title": "수제간식 우유껌 덴탈껌 비스켓 강아지우유 건국목장 에버그로 아이펫밀크 180ml 대용량간식 <b>강아지간식</b>",
"link": "http://search.shopping.naver.com/gate.nhn?id=80331126569",
"image": "https://shopping-phinf.pstatic.net/main_8033112/80331126569.3.jpg",
"lprice": "1250",
"hprice": "0",
"mallName": "마이너펫",
"productId": "80331126569",
"productType": "2"

},
{
"title": "내추럴코어 네츄럴코어 미트스틱 실꼬리돔 참치 7g",
"link": "http://search.shopping.naver.com/gate.nhn?id=10508329175",
"image": "https://shopping-phinf.pstatic.net/main_1050832/10508329175.20161019180854.jpg",
"lprice": "250",
"hprice": "8620",
"mallName": "네이버",
"productId": "10508329175",
"productType": "1"

}
]
}
"""
}

class MockSearchWordCoreDataManager: SearchWordCoreDataManagerType {

    @discardableResult func insert<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool {
        if coreDataStructType is SearchWordData {
            return true
        } else {
            return false
        }
    }

    func fetchOnlySearchWord(pet: String) throws -> [String]? {
        if pet == "고양이" || pet == "강아지" {
            return ["쿠션", "신발", "옷"]
        } else {
            return nil
        }
    }

    func fetchObjects(pet: String? = nil) throws -> [CoreDataStructEntity]? {
        if let pet = pet {
            return [SearchWordData(pet: pet, searchWord: "배변용품")]
        } else {
            return [SearchWordData(pet: "고양이", searchWord: "배변용품"), SearchWordData(pet: "강아지", searchWord: "강아지간식")]
        }
    }

    func updateObject<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool {
        if coreDataStructType is SearchWordData {
            return true
        } else {
            return false
        }
    }

    @discardableResult func updateObject(searchWord: String, pet: String) throws -> Bool {
        if pet == "고양이" || pet == "강아지" {
            return true
        } else {
            return false
        }
    }

    func deleteObject<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool {
        if coreDataStructType is SearchWordData {
            return true
        } else {
            return false
        }
    }

    @discardableResult func deleteAllObjects(pet: String) throws ->  Bool {
        if pet == "고양이" || pet == "강아지" {
            return true
        } else {
            return false
        }
    }
}

class MockPetKeywordCoreDataManager: PetKeywordCoreDataManagerType {
    func fetchOnlyKeyword(pet: String) throws -> [String]? {
        return ["배변", "놀이", "뷰티", "스타일"]
    }

    func fetchOnlyPet() throws -> String? {
        return "고양이"
    }

    func deleteAllObjects(pet: String) throws -> Bool {
        if pet == "고양이" || pet == "강아지" {
            return true
        } else {
            return false
        }
    }

    func insert<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool {
        if coreDataStructType is PetKeywordData {
            return true
        } else {
            return false
        }
    }

    func fetchObjects(pet: String?) throws -> [CoreDataStructEntity]? {
        if let pet = pet {
            return [PetKeywordData(pet: pet, keywords: ["배변", "뷰티", "놀이"])]
        } else {
            return [PetKeywordData(pet: "강아지", keywords: ["배변", "뷰티", "놀이"]), PetKeywordData(pet: "고양이", keywords: ["배변", "뷰티", "놀이"])]
        }
    }

    func updateObject<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool {
        if coreDataStructType is PetKeywordData {
            return true
        } else {
            return false
        }
    }

    func deleteObject<T>(_ coreDataStructType: T) throws -> Bool where T: CoreDataStructEntity {
        if coreDataStructType is PetKeywordData {
            return true
        } else {
            return false
        }
    }
}

class MockMyGoodsCoreDataManager: MyGoodsCoreDataManagerType {

    func fetchFavoriteGoods(pet: String?) throws -> [MyGoodsData]? {
        if let pet = pet {
            return [MyGoodsData(pet: pet, title: "강아지옷", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: false, price: "12000", productID: "12345", searchWord: "뷰티", shoppingmall: "네이버")]
        } else {
            return [MyGoodsData(pet: "강아지", title: "강아지옷", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: false, price: "12000", productID: "999999", searchWord: "뷰티", shoppingmall: "네이버"), MyGoodsData(pet: "고양이", title: "고양이옷", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: false, price: "12000", productID: "55555", searchWord: "뷰티", shoppingmall: "네이버")]
        }
    }

    func fetchLatestGoods(pet: String?, isLatest: Bool, ascending: Bool) throws -> [MyGoodsData]? {
        if let pet = pet {
            return [MyGoodsData(pet: pet, title: "강아지샴푸", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: true, price: "12000", productID: "54321", searchWord: "뷰티", shoppingmall: "네이버")]
        } else {
            return [MyGoodsData(pet: "고양이", title: "고양이샴푸", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: true, price: "12000", productID: "9875", searchWord: "뷰티", shoppingmall: "네이버"), MyGoodsData(pet: "강아지", title: "강아지샴푸", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: true, price: "12000", productID: "58765", searchWord: "뷰티", shoppingmall: "네이버")]
        }
    }

    func fetchProductID(productID: String) -> MyGoods? {
        if productID.contains(productID) {
            return MyGoods()
        } else {
            return nil
        }
    }

    func deleteFavoriteAllObjects(pet: String) throws -> Bool {
        if pet == "고양이" || pet == "강아지" {
            return true
        } else {
            return false
        }
    }

    func deleteLatestAllObjects(pet: String, isLatest: Bool) throws -> Bool {
        if pet == "고양이" || pet == "강아지" {
            if isLatest == true {
                return true
            }
            return false
        } else {
            return false
        }
    }

    func insert<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool {
        if coreDataStructType is MyGoodsData {
            return true
        } else {
            return false
        }
    }

    func fetchObjects(pet: String?) throws -> [CoreDataStructEntity]? {
        if let pet = pet {
            if pet == "고양이" || pet == "강아지" {
                return [MyGoodsData(pet: pet, title: "강아지간식", link: "www.naver.com", image: "www.naver.com", isFavorite: true, isLatest: true, price: "12000", productID: "66666", searchWord: "푸드", shoppingmall: "네이버")]
            }
            return nil
        } else {
            return nil
        }
    }

    func updateObject<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool {
        if coreDataStructType is MyGoodsData {
            return true
        } else {
            return false
        }
    }

    func deleteObject<T: CoreDataStructEntity>(_ coreDataStructType: T) throws -> Bool {
        if coreDataStructType is MyGoodsData {
            return true
        } else {
            return false
        }
    }

}
