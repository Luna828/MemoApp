import UIKit

struct APIManager {
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void){
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error  in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
}


