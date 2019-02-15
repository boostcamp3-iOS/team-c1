//
//  SearchWordDummy.swift
//  CoCo
//
//  Created by 강준영 on 13/02/2019.
//  Copyright © 2019 Team CoCo. All rights reserved.
//

import Foundation

func searchCoreDataPrint() {
    let searchCoreDataManager = SearchWordCoreDataManager()
    let dummy = SearchWordDummy().searchDatas

    do {
        for data in  dummy {
            let insert = try searchCoreDataManager.insert(data)
            print(insert)
        }
        let fetch = try searchCoreDataManager.fetchObjects()
        print(fetch)

    } catch let error {
        print(error)
    }

}

struct SearchWordDummy {
    private let cat = "고양이"
    private let dog = "강아지"
    var searchDatas: [SearchWordData] = []

    init() {
        let searchData1: SearchWordData = SearchWordData(pet: cat, searchWord: "고양이 옷")
        let searchData2: SearchWordData = SearchWordData(pet: cat, searchWord: "고양이 장난감")
        let searchData3: SearchWordData = SearchWordData(pet: cat, searchWord: "고양이 한복")
        let searchData4: SearchWordData = SearchWordData(pet: cat, searchWord: "고양이 간식")
        let searchData5: SearchWordData = SearchWordData(pet: dog, searchWord: "강아지 옷")
        let searchData6: SearchWordData = SearchWordData(pet: dog, searchWord: "강아지 장난감")
        let searchData7: SearchWordData = SearchWordData(pet: dog, searchWord: "강아지 한복")
        let searchData8: SearchWordData = SearchWordData(pet: dog, searchWord: "강아지 간식")
        searchDatas.append(searchData1)
        searchDatas.append(searchData2)
        searchDatas.append(searchData3)
        searchDatas.append(searchData4)
        searchDatas.append(searchData5)
        searchDatas.append(searchData6)
        searchDatas.append(searchData7)
        searchDatas.append(searchData8)
    }

}
