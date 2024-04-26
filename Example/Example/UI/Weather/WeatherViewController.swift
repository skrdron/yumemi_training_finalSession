//
//  ViewController.swift
//  Example
//
//  Created by 渡部 陽太 on 2020/03/30.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

//エラーを定義
enum DisasterError: Error {
    case unknownError
}

protocol WeatherModel {
    func fetchWeather(at area: String, date: Date, completion: @escaping (Result<Response, WeatherError>) -> Void)
}

protocol DisasterModel {
    func fetchDisaster(completion: @escaping (Result<String, DisasterError>) -> Void)
}

class WeatherViewController: UIViewController {
    
    var weatherModel: WeatherModel!
    var disasterModel: DisasterModel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var disasterLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        NotificationCenter.default.addObserver(
          self,
          selector:#selector(didBecomeActive),
          name: UIApplication.didBecomeActiveNotification,
          object: nil
        )
    }
    
    deinit {
        print("解放されるよ")
    }
    
     @objc func didBecomeActive(_ notification: Notification) {
         loadWeather(notification.object)
         print("didBecomeActiveが呼ばれた")
     }
    
    @IBAction func dismiss(_ sender: Any) {
        print("Closeボタンが押された")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loadWeather(_ sender: Any?) {
        print("loadWeatherが呼ばれた")
        self.activityIndicator.startAnimating()
        weatherModel.fetchWeather(at: "tokyo", date: Date()) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.handleWeather(result: result)
                print("Weatherデータをフェッチ")
            }
        }
        disasterModel.fetchDisaster { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let disaster):
                    self?.disasterLabel.text = disaster
                case .failure:
                    self?.disasterLabel.text = "災害情報の取得に失敗しました"
                }
                print("災害データをフェッチ")
            }
        }
    }
    
    func handleWeather(result: Result<Response, WeatherError>) {
        switch result {
        case .success(let response):
            self.weatherImageView.set(weather: response.weather)
            self.minTempLabel.text = String(response.minTemp)
            self.maxTempLabel.text = String(response.maxTemp)
            
        case .failure(let error):
            let message: String
            switch error {
            case .jsonEncodeError:
                message = "JSONエンコードに失敗しました。"
            case .jsonDecodeError:
                message = "JSONデコードに失敗しました。"
            case .unknownError:
                message = "エラーが発生しました。"
            }
            print(message)
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.dismiss(animated: true) {
                    print("アラート出現後ボタンを押してViewControllerを閉じた")
                }
            })
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

private extension UIImageView {
    func set(weather: Weather) {
        switch weather {
        case .sunny:
            self.image = R.image.sunny()
            self.tintColor = R.color.red()
        case .cloudy:
            self.image = R.image.cloudy()
            self.tintColor = R.color.gray()
        case .rainy:
            self.image = R.image.rainy()
            self.tintColor = R.color.blue()
        }
    }
}
