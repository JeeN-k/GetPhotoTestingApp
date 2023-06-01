//
//  NetworkService.swift
//  GetPhotoTestingApp
//
//  Created by user on 30.05.2023.
//

import Foundation

enum RequestErrors: String, Error {
    case invalidEndPoint = "Недопустимые символы в строке, используйте только буквы или цифры"
    case responseError = "Произошла ошибка, попробуйте позднее"
    case serverError = "Кажется сервис сейчас недоступен, попробуйте позднее"
}

protocol NetworkCoreProtocol {
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Data, RequestErrors>) -> Void)
}

final class NetworkService {
    static let instance: NetworkCoreProtocol = NetworkService()
}

extension NetworkService: NetworkCoreProtocol {
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Data, RequestErrors>) -> Void) {
        guard let url = URL(string: request.baseUrl + request.urlPath) else {
            completion(.failure(RequestErrors.invalidEndPoint))
            return
        }
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                return completion(.failure(RequestErrors.serverError))
            }
            
            guard let data else {
                return completion(.failure(RequestErrors.responseError))
            }
            
            DispatchQueue.main.async {
                completion(.success(data))
            }
            
        }.resume()
    }
}
