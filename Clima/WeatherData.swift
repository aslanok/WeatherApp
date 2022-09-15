//
//  WeatherData.swift
//  Clima
//
//  Created by MacBook on 28.02.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
//Decodable parametresini ekleyerek hem decoding işlemini yaparak aldığımız json veriyi kullanabiliyoruz.
struct WeatherData: Codable {
    let name: String //buraya çözülecek bir değişken yazdık. hangisini çözeceksek eğer onu yazıyoruz.
    let main: Main
    let weather: [Weather]
}


//burda bize döndürülen api bir liste formatında olduğu için biz de weather'ı bir liste için tanımladık.
struct Weather: Codable {
    let description: String
    let id : Int
}



struct Main: Codable {
    let temp: Double
}


//Api'nin urlsine girdiğimde bakınca main adlı değişkenin içinde 4 tane daha değişken vardı. Bu nedenle Main değişkenin içine girmeden o temperature değerini almamızın imkanı yok. Onu alabilmek için yeni bir veritipi belirledik ve bu veri tipine de Decodable yani çözülebilirlik verdik. Bu sayede de artık veriyi çekebilecek hale geldik.
