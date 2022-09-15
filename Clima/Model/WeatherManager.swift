//
//  WeatherManager.swift
//  Clima
//
//  Created by MacBook on 27.02.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//  koyduğumuz self kelimesi kullanılan şu anki struct'ı işaret ediyor.

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = Constants.weatherURL
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(latitude:CLLocationDegrees,longitude:CLLocationDegrees){
            let urlString="\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: urlString)
        }
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
        print(urlString)
    }
    
    func performRequest(urlString : String){
        //1. Create URL
        //2. Create a URLSession
        //3. Give the session task
        //4. Start the task
        
        //Step 1
        if let url = URL(string: urlString) {
            //Step 2
            let session = URLSession(configuration: .default) //bu kod bizim internette gördüğümüz gibi bi yazımı tanımlıyor
            
            //Step 3 let task = session.dataTask(with: urlString, completionHandler: handle(data:response:error))
            //networkte error olursa session çalışmaz ve hata meydana gelir.
            let task = session.dataTask(with: url ) { (data, response, error) in //closuse kullanmış olduk
                if error != nil {
                    //print(error!) önceden burda direkt error yazdırırdık ama şimdi daha güzel bi şekilde yazacağız.
                    delegate?.didFailWithError(error: error!)
                    
                    return //burdaki return break gibi bir komut. Eğer error varsa erroru yazdırıcak ve fonksiyondan çıkıcak
                }
                
                if let safeData = data {
                    if let weather = parseJSON(weatherData: safeData) {
                        delegate?.didUpdateWeather(weather: weather) //burda bir delegate tanımladık ve bu delegate sayesinde de kimin delegate yani temsilci ise bu özelliği kullanabilmesini sağlıyoruz.
                        
                        /*
                        eğer ki aşağıdaki satırlar kullanılırsa sadece weatherVC durumu için kullanılabilecek.Tek bir amaca bağlı hareket edecek. Ama biz çok amaçlı kullanılmasını tercih edeceğimiz için delegate kullandık.
                        let weatherVC = WeatherViewController()
                        weatherVC.didUpdateWeather(weather: weather)
                        */
                    } //weather adında bir değişkeni ParseJSON fonksiyonu sayesinde bize geri dönen weatherModel tipinde bir eleman yaptık.
                    
                    /*
                    let dataString = String(data: safeData, encoding: .utf8)
                    print(dataString) //bunun sonunda artık chrome'daki gibi bir arayüzümüz var artık
                    burda yazdırdığımız data stringi okumak çok zor bu nedenle bunu bi json formata
                    dönüştürmemiz gerekiyor
                     */
                }
            }
            //Step 4
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        // ilk parametre hangi tipteki değişkeni dönüştüreceğimizi belirtiyor. Biz name parametresi belirlemiştik WeatherData struct'ı içerisinde ve bu struct içindekilerin tipi de WeatherData olmuş oluyor. Biz bir de Data tipinde bir değişken belirledik ki bu ilerde safeData olacak.
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            //print(decodedData.name) //decodedData artık o sayfadaki verileri görüp okuyabiliyor.
            //print(decodedData.main.temp)
            //print(decodedData.weather[0].description) //weather sadece bir liste olduğu için ve direkt o listeye dalmak için 0 veriyoruz.
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            //weather modelden nesne yarattık
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            //print(weather.getConditionName(weatherId: id)) //weather modelde yorum satırı yaptığım fonksyionu bu çağırıyordu. aynı işlevi aşağıdaki satırla da yapabiliriz.
            return weather
            
        } catch {
            //print(error) direkt erroru yazdırmak yerine delegate methodu kullanacağız
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    /*
    func handle(data: Data?, response : URLResponse?, error : Error? ){
        if error != nil {
            print(error!)
            return //burdaki return break gibi bir komut. Eğer error varsa erroru yazdırıcak ve fonksiyondan çıkıcak
        }
        
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString) //bunun sonunda artık chrome'daki gibi bir arayüzümüz var artık
        }
        
    }
    */
    
}
