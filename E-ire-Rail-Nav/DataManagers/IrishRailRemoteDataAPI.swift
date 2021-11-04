//
//  IrishRailRemoteDataAPI.swift
//  E-ire-Rail-Nav
//
//  Created by Georgi Georgiev on 24.10.21.
//

import Foundation

class IrishRailRemoteDataAPI:RemoteDataAPI
{
    func getAllStations(completionHandler:@escaping (Data?, Error?)->Void){
        let url = URL(string: "http://api.irishrail.ie/realtime/realtime.asmx/getAllStationsXML")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { data, response, error in
            completionHandler(data, error)
        }

        task.resume()
    }
    
    func getTrainsForStation(stationName: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        var urlString = "http://api.irishrail.ie/realtime/realtime.asmx/getStationDataByNameXML?StationDesc=\(stationName)"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: urlString)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { data, response, error in
            completionHandler(data, error)
        }

        task.resume()
    }
    
    func getTrainStops(trainCode: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date)

        let url = URL(string: "http://api.irishrail.ie/realtime/realtime.asmx/getTrainMovementsXML?TrainId=\(trainCode)&TrainDate=\(dateString)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { data, response, error in
            completionHandler(data, error)
        }

        task.resume()
    }

}
