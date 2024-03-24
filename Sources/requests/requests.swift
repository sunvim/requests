// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

public class RestClient {
  let session: URLSession
  let baseURL: String

  public init(baseURL: String, configuration: URLSessionConfiguration = .default) {
    self.baseURL = baseURL
    self.session = URLSession(configuration: configuration)
  }

  public func get(
    url: String, headers: [String: String] = [:],
    completion: @escaping (Data?, URLResponse?, Error?) -> Void
  ) {
    let fullUrl = baseURL + url
    var request = URLRequest(url: URL(string: fullUrl)!)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers

    session.dataTask(with: request) { data, response, error in
      completion(data, response, error)
    }.resume()
  }

  public func post<T: Encodable>(
    url: String, headers: [String: String] = [:], body: T,
    completion: @escaping (Data?, URLResponse?, Error?) -> Void
  ) {
    var request = URLRequest(url: URL(string: baseURL + url)!)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers

    if let contentType = headers.first(where: { $0.key.lowercased() == "content-type" }) {
      request.setValue(contentType.value, forHTTPHeaderField: "Content-Type")
    } else {
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }

    do {
      let jsonData = try JSONEncoder().encode(body)
      request.httpBody = jsonData
    } catch {
      completion(nil, nil, error)
      return
    }

    session.dataTask(with: request) { data, response, error in
      completion(data, response, error)
    }.resume()

  }

  public func put<T: Encodable>(
    url: String, headers: [String: String] = [:], body: T,
    completion: @escaping (Data?, URLResponse?, Error?) -> Void
  ) {
    var request = URLRequest(url: URL(string: baseURL + url)!)
    request.httpMethod = "PUT"
    request.allHTTPHeaderFields = headers

    if let contentType = headers.first(where: { $0.key.lowercased() == "content-type" }) {
      request.setValue(contentType.value, forHTTPHeaderField: "Content-Type")
    } else {
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }

    do {
      let jsonData = try JSONEncoder().encode(body)
      request.httpBody = jsonData
    } catch {
      completion(nil, nil, error)
      return
    }

    session.dataTask(with: request) { data, response, error in
      completion(data, response, error)
    }.resume()
  }

  public func delete<T: Encodable>(
    url: String, headers: [String: String] = [:], body: T? = nil,
    completion: @escaping (Data?, URLResponse?, Error?) -> Void
  ) {
    var request = URLRequest(url: URL(string: baseURL + url)!)
    request.httpMethod = "DELETE"
    request.allHTTPHeaderFields = headers

    if let body = body {
      do {
        let jsonData = try JSONEncoder().encode(body)
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      } catch {
        completion(nil, nil, error)
        return
      }
    }

    session.dataTask(with: request) { data, response, error in
      completion(data, response, error)
    }.resume()
  }

}
