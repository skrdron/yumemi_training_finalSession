//
//  DisasterModel.swift
//  Example
//
//  Created by 渡部 陽太 on 2020/04/19.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Foundation
import YumemiWeather

class DisasterModelImpl: DisasterModel {
        
    private let yumemiDisaster: YumemiDisaster
    //成功時には文字列を、失敗時にはエラー情報を適切に返すように変更
    private var fetchDisasterHandler: ((Result<String, DisasterError>) -> Void)?
    
    init(yumemiDisaster: YumemiDisaster = YumemiDisaster()) {
        self.yumemiDisaster = yumemiDisaster
        self.yumemiDisaster.delegate = self
    }
    //成功時には文字列を、失敗時にはエラー情報を適切に返すように変更
    func fetchDisaster(completion: @escaping (Result<String, DisasterError>) -> Void) {
        self.fetchDisasterHandler = completion
        yumemiDisaster.fetchDisaster()
    }
}

extension DisasterModelImpl: YumemiDisasterHandleDelegate {
    
    func handle(disaster: String) {
        self.fetchDisasterHandler?(.success(disaster))
    }
      
    //成功時と同様失敗時の挙動も実装
    func handleError() {
        self.fetchDisasterHandler?(.failure(.unknownError))
    }
}
