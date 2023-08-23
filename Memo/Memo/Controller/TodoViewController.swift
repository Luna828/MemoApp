import UIKit

class TodoViewController: UIViewController {
    let todoManager = TodoManager()
    
    let tableView = UITableView()
    
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        // TableView 설정
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        view.addSubview(tableView)
        title = "TODO"
    }
}

extension TodoViewController: UITableViewDelegate {}

extension TodoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoManager.getTodos().count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let todos = todoManager.getTodos() // 메모 배열 가져오기
        if indexPath.row < todos.count {
            let todo = todos[indexPath.row]
            cell.textLabel?.text = todo.content
            
            let switchView = UISwitch()
            switchView.isOn = todo.isCompleted
            switchView.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
            cell.accessoryView = switchView
        } else {
            let switchView = UISwitch()
            switchView.isOn = false
            cell.accessoryView = switchView
            
            cell.textLabel?.text = "No todo" // 메모가 없는 경우 대비
            cell.textLabel?.textColor = .gray
            
        }
        
        return cell
    }
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        // 스위치의 상태가 변경되었을 때 처리하는 로직을 구현
        if let cell = sender.superview as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell),
           indexPath.row < todoManager.getTodos().count {
            let todo = todoManager.getTodos()[indexPath.row]
            todoManager.updateTodo(at: indexPath.row, with: todo.content, isCompleted: sender.isOn)
            tableView.reloadData()
        }
    }
}
