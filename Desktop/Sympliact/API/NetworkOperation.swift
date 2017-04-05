
import Foundation

class NetworkOperation {
    
    lazy var config: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: self.config)
    let queryURL: URL
    var authHeader = "cd201003212cd9e7b787d7d783261272e201b5038055f5ee2ac3415d1e8b7b4dcdae9074"
    
    typealias JSONDictionaryCompletion = (([String: AnyObject]?) -> Void)
    
    init(url: URL) {
//        if let user = User.current {
//            self.authHeader = user.token ?? ""
//        }
        self.queryURL = url
    }
    
    func downloadJSONFromURL(_ completion: @escaping JSONDictionaryCompletion) {
        
        let request = NSMutableURLRequest(url: queryURL)
            if (authHeader != "") {
//    
//                let authorized = User.current != nil
//    
//                if authorized {
//                    request.setValue(authHeader, forHTTPHeaderField: "X-Authorization")
//                } else {
//                    print("Unauthorized with auth header: \(authHeader)")
//                    request.setValue(authHeader, forHTTPHeaderField: "Authorization")
//                }
            }
        
        print("Using URL: \(queryURL)")
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            // 1. Check HTTP response for successful GET request
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    // 2. Create JSON object with data
                    do {
                        let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                        OperationQueue.main.addOperation {
                            completion(jsonDictionary)
                        }
                    } catch {
                        OperationQueue.main.addOperation {
                            completion(nil)
                        }
                    }
                default:
                    OperationQueue.main.addOperation {
                        completion(nil)
                    }
                    print("GET request not successful. HTTP status code: \(httpResponse.statusCode)")
                    print("Query URL: \(self.queryURL.absoluteString)")
                }
            } else {
                print("Error: Not a valid HTTP response")
            }
        })
        
        dataTask.resume()
    }
    
    /**
     TO BE USED FOR POST, PUT OR DELETE REQUESTS
     */
    func request(_ body: Dictionary<String, String>?, method: String, completion: @escaping JSONDictionaryCompletion) {
        
        //temporary solution
        //        authHeader = "Basic am9objpwYXNzd29yZA=="
        
        print("Using method: \(method)")
        let headers = [
            "X-Authorization": authHeader,
            "content-type": "application/x-www-form-urlencoded",
            "cache-control": "no-cache",
            ]
//        let authorized = User.current != nil
//        
//        if authorized {
//            headers["X-Authorization"] = authHeader
//        } else {
//            headers["Authorization"] = authHeader
//        }
        
        let request = NSMutableURLRequest(url: queryURL)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        if method == "POST" || method == "PUT" || method == "DELETE" {
            if let body = body {
                request.httpBody = getBodyContentFromDictionary(body)
            }
        }
        
        print(request)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            
            // 1. Check HTTP response for successful GET request
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    print("\(method) request successful")
                    // 2. Create JSON object with data
                    do {
                        let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                        OperationQueue.main.addOperation {
                            completion(jsonDictionary)
                        }
                    } catch {
                        OperationQueue.main.addOperation {
                            completion(nil)
                        }
                    }
                default:
                    OperationQueue.main.addOperation {
                        completion(nil)
                    }
                    print("POST request not successful. HTTP status code: \(httpResponse.statusCode)")
                    print(httpResponse.description)
                    print(String(data: data!, encoding: String.Encoding.utf8) ?? "Can't read HTTP data")
                }
            } else {
                print("Error: Not a valid HTTP response")
            }
        })
        
        dataTask.resume()
    }
    
    func post(_ body: Dictionary<String, String>, completion: @escaping JSONDictionaryCompletion) {
        let request = NSMutableURLRequest(url: queryURL)
        
        request.setValue(authHeader, forHTTPHeaderField: "X-Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        let data : Data = NSKeyedArchiver.archivedData(withRootObject: getBodyContentFromDictionary(body))
        request.httpBody = data
        
        NSLog("Using auth header: " + authHeader)
        
        let dataTas = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            
            // 1. Check HTTP response for successful GET request
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 201:
                    // 2. Create JSON object with data
                    do {
                        let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                        OperationQueue.main.addOperation {
                            completion(jsonDictionary)
                        }
                    } catch {
                        OperationQueue.main.addOperation {
                            completion(nil)
                        }
                    }
                default:
                    OperationQueue.main.addOperation {
                        completion(nil)
                    }
                    print("POST request not successful. HTTP status code: \(httpResponse.statusCode)")
                    print(httpResponse.description)
                    print(String(data: data!, encoding: String.Encoding.utf8) ?? "Can't read HTTP data")
                }
            } else {
                print("Error: Not a valid HTTP response")
            }
        }
        
        dataTas.resume()
    }
    
    
    func getBodyContentFromDictionary(_ contentMap: Dictionary<String, String>) -> Data {
        let data = NSMutableData()
        var firstOneAdded = false
        let contentKeys:Array<String> = Array(contentMap.keys)
        for contentKey in contentKeys {
            if(!firstOneAdded) {
                data.append((contentKey + "=" + contentMap[contentKey]!).data(using: String.Encoding.utf8)!)
                firstOneAdded = true
            }
            else {
                data.append(("&" + contentKey + "=" + contentMap[contentKey]!).data(using: String.Encoding.utf8)!)
            }
        }
        return data as Data
    }
}
