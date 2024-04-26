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
    private var fetchDisasterHandler: ((Result<String, DisasterError>) -> Void)?
    
    init(yumemiDisaster: YumemiDisaster = YumemiDisaster()) {
        self.yumemiDisaster = yumemiDisaster
        self.yumemiDisaster.delegate = self
    }
    func fetchDisaster(completion: @escaping (Result<String, DisasterError>) -> Void) {
        self.fetchDisasterHandler = completion
        yumemiDisaster.fetchDisaster()
    }
}

extension DisasterModelImpl: YumemiDisasterHandleDelegate {
    
    func handle(disaster: String) {
        self.fetchDisasterHandler?(.success(disaster))
    }
      
    func handleError() {
        self.fetchDisasterHandler?(.failure(.unknownError))
    }
}
