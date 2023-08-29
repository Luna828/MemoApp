//
//  CatAPI.swift
//  Memo
//
//  Created by t2023-m0050 on 2023/08/29.
//

import Foundation
import Alamofire

struct CatAPIRequest: Encodable {
    var limit: Int?
    var page: Int?
}

struct CatAPIResponse: Decodable {
    var id: String?
    var url: String?
}

class CatDataManager {
    let url = "https://api.thecatapi.com/v1/images/search"
    func catDataManager(_ parameters: CatAPIRequest, _ viewController: AlamofireViewController) {
        AF.request(url, method: .get, parameters: parameters).validate().responseDecodable(of: [CatAPIResponse].self) { response in
            switch response.result {
            case .success(let result):
                print("성공\(result)")
                viewController.successAPI(result)
            case .failure(let error):
                print("실패\(error)")
            }
        }
    }
}
/**
 responseDecodable을 사용하면 Codable 프로토콜을 준수하는 데이터 모델을 정의하고, 이 모델을 사용하여 응답 데이터를 간단하게 파싱할 수 있습니다. 이렇게 함으로써 데이터의 타입 안정성을 확보하고, 코드의 유지보수성을 높일 수 있습니다. 반면에 responseJSON을 사용할 경우에는 응답 데이터를 수동으로 파싱하고 처리해야 하므로 번거로울 수 있습니다.
 */
