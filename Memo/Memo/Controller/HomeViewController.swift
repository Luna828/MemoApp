import UIKit

class HomeViewController: UIViewController {
    let apiManager = APIManager()
    private let todoManager = TodoManager()
    let IMG_URL = "https://static.wikia.nocookie.net/shinchan/images/d/d8/Shinnoske.jpg/revision/latest?cb=20131020030755&path-prefix=ko"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // 짱구 사진 불러오기
        urlImage()
    }
    
    private func urlImage() {
        var imageView: UIImageView?
        
        apiManager.downloadImage(from: IMG_URL) { [weak self] image in
            if let image = image {
                DispatchQueue.main.async {
                    imageView = image.customImageView(self?.view ?? UIView(), x: 0, y: 0, width: 200, height: 200)
                    
                    if let imageView = imageView {
                        let stackView = UIStackView()
                        stackView.axis = .horizontal
                        stackView.spacing = 10
                        stackView.alignment = .center
                        
                        let todo = UIButton().homeButton(title: "TODO LIST", target: self, action: #selector(self?.todoBtn))
                        let create = UIButton().homeButton(title: "CREATE", target: self, action: #selector(self?.createBtn))
                        let alamofire = UIButton().homeButton(title: "ALAMOFIRE", target: self, action: #selector(self?.alamofireBtn))
                        
                        stackView.addArrangedSubview(todo)
                        stackView.addArrangedSubview(create)
                        stackView.addArrangedSubview(alamofire)
                        
                        self?.view.addSubview(stackView)
                        
                        stackView.translatesAutoresizingMaskIntoConstraints = false
                        NSLayoutConstraint.activate([
                            stackView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
                            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10)
                        ])
                    }
                }
            } else {
                print("이미지 로드 ❌")
            }
        }
    }
    
    @objc func alamofireBtn() {
        let alamofireVC = AlamofireViewController()
        navigationController?.pushViewController(alamofireVC, animated: true)
    }
    
    @objc func todoBtn() {
        guard navigationController != nil else {
            print("❌")
            return
        }
        
        let todoViewController = TodoViewController()
        navigationController?.pushViewController(todoViewController, animated: true)
    }

    @objc func createBtn() {
        let alertController = UIAlertController(title: "Todo 생성", message: nil, preferredStyle: .alert)
        
        // 알림창에 입력 필드 추가
        alertController.addTextField { textField in
            textField.placeholder = "할 일을 입력해주세요"
        }
        
        // 사용 가능한 섹션 이름들을 배열에 저장
        let availableSections = ["Work", "Life"]
        
        // 알림창 버튼 추가
        for section in availableSections {
            alertController.addAction(UIAlertAction(title: section, style: .default) { _ in
                if let contentField = alertController.textFields?.first,
                   let content = contentField.text
                {
                    if content.isEmpty {
                        let alertEmpty = UIAlertController(title: "할일을 작성해주세요", message: nil, preferredStyle: .alert)
                        alertEmpty.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                        self.present(alertEmpty, animated: true, completion: nil)
                    } else {
                        let newTodo = Todo(content: content, isCompleted: false)
                        self.todoManager.addTodo(newTodo, to: section)
                    }
                }
            })
        }
            
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))

        // 알림창 표시
        present(alertController, animated: true, completion: nil)
    }
}
