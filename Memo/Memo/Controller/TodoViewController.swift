import UIKit

class TodoViewController: UIViewController {
    private let tableView = UITableView()
    private var todoView: TodoView!

    override func viewDidLoad() {
        super.viewDidLoad()
        todoView = TodoView(frame: view.bounds)
        view.addSubview(todoView)
        title = "TODO"
    }
}


