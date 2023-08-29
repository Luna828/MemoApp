import Kingfisher
import UIKit
import Alamofire

class AlamofireViewController: UIViewController {
    var collectionView: UICollectionView!
    let cellReuseIdentifier = "cellReuseIdentifier"
    var data: [CatAPIResponse] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 100)

        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white

        view.addSubview(collectionView)

        fetchCatImages()
    }

    func fetchCatImages() {
        let parameters = CatAPIRequest(limit: 100, page: 1)
        CatDataManager().catDataManager(parameters, self)
    }
}

extension AlamofireViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        cell.backgroundColor = UIColor.lightGray

        if let urlString = data[indexPath.row].url {
            let url = URL(string: urlString)

            if cell.contentView.subviews.isEmpty {
                let imageView = UIImageView(frame: cell.contentView.bounds)
                imageView.contentMode = .scaleAspectFit
                imageView.kf.setImage(with: url)
                
                cell.contentView.subviews.forEach { $0.removeFromSuperview() }
                cell.contentView.addSubview(imageView)
            }
        }

        return cell
    }
}

extension AlamofireViewController {
    func successAPI(_ result: [CatAPIResponse]) {
        data = result
        collectionView.reloadData()
    }
}
