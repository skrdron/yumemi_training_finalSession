//
//  WeatherViewControllerTests.swift
//  ExampleTests
//
//  Created by 渡部 陽太 on 2020/04/01.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest
import YumemiWeather
@testable import Example

class WeatherViewControllerTests: XCTestCase {

    var weahterViewController: WeatherViewController!
    var weahterModel: WeatherModelMock!
    var disasterModel : DisasterModelMock!
    
    override func setUpWithError() throws {
        weahterModel = WeatherModelMock()
        disasterModel = DisasterModelMock()
        weahterViewController = R.storyboard.weather.instantiateInitialViewController()!
        weahterViewController.weatherModel = weahterModel
        weahterViewController.disasterModel = disasterModel
        _ = weahterViewController.view
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_天気予報がsunnyだったらImageViewのImageにsunnyが設定されること_TintColorがredに設定されること() throws {
        weahterModel.fetchWeatherImpl = { (area, date, completion)  in
            completion(.success(Response(weather: .sunny, maxTemp: 0, minTemp: 0, date: date)))
        }
        let testButton = UIButton()
        weahterViewController.loadWeather(testButton)
        XCTAssertEqual(weahterViewController.weatherImageView.tintColor, R.color.red())
        XCTAssertEqual(weahterViewController.weatherImageView.image, R.image.sunny())
    }
    
    func test_天気予報がcloudyだったらImageViewのImageにcloudyが設定されること_TintColorがgrayに設定されること() throws {
        weahterModel.fetchWeatherImpl = { (area, date, completion)  in
            completion(.success(Response(weather: .cloudy, maxTemp: 0, minTemp: 0, date: date)))
        }
        let testButton = UIButton()
        weahterViewController.loadWeather(testButton)
        XCTAssertEqual(weahterViewController.weatherImageView.tintColor, R.color.gray())
        XCTAssertEqual(weahterViewController.weatherImageView.image, R.image.cloudy())
    }
    
    func test_天気予報がrainyだったらImageViewのImageにrainyが設定されること_TintColorがblueに設定されること() throws {
        weahterModel.fetchWeatherImpl = { (area, date, completion) in
            completion(.success(Response(weather: .rainy, maxTemp: 0, minTemp: 0, date: date)))
        }
        let testButton = UIButton()
        weahterViewController.loadWeather(testButton)
        XCTAssertEqual(weahterViewController.weatherImageView.tintColor, R.color.blue())
        XCTAssertEqual(weahterViewController.weatherImageView.image, R.image.rainy())
    }
    
    func test_最高気温_最低気温がUILabelに設定されること() throws {
        weahterModel.fetchWeatherImpl = { (area, date, completion) in
            completion(.success(Response(weather: .sunny, maxTemp: 0, minTemp: 0, date: date)))
        }
        let testButton = UIButton()
        weahterViewController.loadWeather(testButton)
        XCTAssertEqual(weahterViewController.minTempLabel.text, "-100")
        XCTAssertEqual(weahterViewController.maxTempLabel.text, "100")
    }
}

/*
 func fetchWeather(at area: String, date: Date, completion: @escaping (Result<Response, WeatherError>) -> Void)
 これを満たす必要あり
*/
class WeatherModelMock: WeatherModel {
    var fetchWeatherImpl:  ((String, Date, @escaping (Result<Response, WeatherError>) -> Void) -> Void)?
    
    func fetchWeather(at area: String, date: Date, completion: @escaping (Result<Response, WeatherError>) -> Void) {
        fetchWeatherImpl?(area, date, completion)
    }
}

class DisasterModelMock: DisasterModel {
    var fetchDisasterImpl: ((@escaping (Result<String, DisasterError>) -> Void) -> Void)?

    func fetchDisaster(completion: @escaping (Result<String, DisasterError>) -> Void) {
        fetchDisasterImpl?(completion)
    }
}
