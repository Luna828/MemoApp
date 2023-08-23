import UIKit

class ViewController: UIViewController {
    let apiManager = APIManager()
    private let todoManager = TodoManager()
    let IMG_URL = "https://static.wikia.nocookie.net/shinchan/images/d/d8/Shinnoske.jpg/revision/latest?cb=20131020030755&path-prefix=ko"

    override func viewDidLoad() {
        super.viewDidLoad()

        var imageView: UIImageView?
        view.backgroundColor = UIColor.white
        // 짱구 사진 불러오기
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
                        let done = UIButton().homeButton(title: "CREATE", target: self, action: #selector(self?.doneBtn))
                        
                        stackView.addArrangedSubview(todo)
                        stackView.addArrangedSubview(done)
                        
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

    @objc func todoBtn() {
        print("Go to Todo Page")

        guard navigationController != nil else {
            print("❌")
            return
        }
        
        let todoViewController = TodoViewController()
        navigationController?.pushViewController(todoViewController, animated: true)
    }

//    @objc func doneBtn() {
//        print("Go to Done Page")
//
//        let alertController = UIAlertController(title: "Todo 생성", message: nil, preferredStyle: .alert)
//
//        // 알림창에 입력 필드 추가
//        alertController.addTextField { textField in
//            textField.placeholder = "할 일을 입력해주세요"
//        }
//
//        // 알림창 버튼 추가
//        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
//        alertController.addAction(UIAlertAction(title: "생성", style: .default) { _ in
//            // 사용자 입력 정보 확인 및 처리
//            if let contentField = alertController.textFields?.first,
//               let content = contentField.text
//            {
//                let newTodo = Todo(uuid: UUID(), content: content, isCompleted: false)
//
//                self.todoManager.addTodo(newTodo)
//                print("UUID\(newTodo.uuid)")
//            }
//        })
//        // 알림창 표시
//        present(alertController, animated: true, completion: nil)
//    }
    @objc func doneBtn() {
        print("Go to Done Page")
        
        let alertController = UIAlertController(title: "Todo 생성", message: nil, preferredStyle: .alert)
        
        // 알림창에 입력 필드 추가
        alertController.addTextField { textField in
            textField.placeholder = "Content"
        }
        
        let pulldownButton = UIAlertAction(title: "섹션 선택", style: .default) { _ in
            // 섹션 선택 팝업 표시
            let sectionAlertController = UIAlertController(title: "섹션 선택", message: nil, preferredStyle: .actionSheet)
            
            let sectionNames = ["Work", "Life"] // 섹션 이름 목록
            for sectionName in sectionNames {
                sectionAlertController.addAction(UIAlertAction(title: sectionName, style: .default) { _ in
                    if let contentField = alertController.textFields?.first,
                       let content = contentField.text
                    {
                        let newTodo = Todo(section: sectionName, content: content, isCompleted: false)
                        
                        self.todoManager.addTodo(newTodo)
                        print("UUID: \(newTodo.uuid)")
                    }
                })
            }
            
            sectionAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(sectionAlertController, animated: true, completion: nil)
        }
        
        // 알림창 버튼 추가
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alertController.addAction(pulldownButton)
        
        // 알림창 표시
        present(alertController, animated: true, completion: nil)
    }

}
