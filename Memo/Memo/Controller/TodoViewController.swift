import UIKit

class TodoViewController: UIViewController {
    let todoManager = TodoManager()
    
    let tableView = UITableView()
    
    let cellReuseIdentifier = "cell"
    let sectionNames = ["Work", "Life"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.systemGray3
        
        // TableView 설정
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        view.addSubview(tableView)
        title = "TODO"
        
        // 섹션별로 Todo 배열을 초기화
        todoManager.workTodos = todoManager.getTodos().filter { $0.section == "Work" }
        todoManager.lifeTodos = todoManager.getTodos().filter { $0.section == "Life" }
    }
}

extension TodoViewController: UITableViewDelegate {}

extension TodoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoManager.getTodos().count
    }
    
    // 섹션 헤더 뷰 설정
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        headerView.backgroundColor = .white
        
        let titleLabel = UILabel(frame: headerView.bounds)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.text = sectionNames[section]
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
        
        return headerView
    }
    
    // 섹션 푸터 뷰 설정
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        tableView.tableFooterView = footerView
        footerView.backgroundColor = .white
        
        // 푸터 뷰의 오토레이아웃 설정
        footerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 50) // 푸터 뷰의 높이 설정
        ])
        
        let titleLabel = UILabel(frame: footerView.bounds)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.text = "\(todoManager.getTodos().count)"
        footerView.addSubview(titleLabel)
        
        return footerView
    }
    
    // 섹션 헤더 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // 섹션 푸터 높이 설정
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var todos = todoManager.getTodos() // 메모 배열 가져오기

        let sectionName = sectionNames[indexPath.section] // 현재 섹션 이름 가져오기

        if sectionName == "Work" {
            todos = todoManager.workTodos
        } else if sectionName == "Life" {
            todos = todoManager.lifeTodos
        }
        
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
           indexPath.row < todoManager.getTodos().count
        {
            let todo = todoManager.getTodos()[indexPath.row]
            todoManager.updateTodo(at: indexPath.row, with: todo.content, isCompleted: sender.isOn)
            print("찍? \(sender.isOn)")
            tableView.reloadData()
        }
    }
//    @objc func switchValueChanged(_ sender: UISwitch) {
//        // 스위치의 상태가 변경되었을 때 처리하는 로직을 구현
//        if let cell = sender.superview as? UITableViewCell,
//           let indexPath = tableView.indexPath(for: cell),
//           indexPath.row < todoManager.getTodos().count
//        {
//            let todo = todoManager.getTodos()[indexPath.row]
//            todoManager.updateTodo(at: indexPath.row, with: todo.content)
//            tableView.reloadData()
//        }
//    }
}
