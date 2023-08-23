import Foundation

// 저장을 원하는 타입에 Codable protocol 채택
struct Todo: Codable {
    var uuid: UUID = UUID()
    var section: String
    var content: String
    var isCompleted: Bool = false
}

class TodoManager {
    private let todoKey = "todoKey"
    
    var workTodos: [Todo] = []
    var lifeTodos: [Todo] = []
    
    // 메모 읽어오기
    func getTodos() -> [Todo] {
        if let todosData = UserDefaults.standard.data(forKey: todoKey),
           // JsonDecoder를 사용하여 저장된 데이터 가져오기
           let todos = try? JSONDecoder().decode([Todo].self, from: todosData)
        {
            return todos
        }
        return []
    }
    
    // 메모 추가
    func addTodo(_ todo: Todo) {
        var savedTodos = getTodos()
        savedTodos.append(todo)
        saveTodos(savedTodos) // 메소드 이름 수정: saveMemo -> saveMemos
    }
    
    // 메모 수정
    func updateTodo(at index: Int, with newContent: String, isCompleted: Bool) {
        var savedTodos = getTodos()
        
        guard index >= 0, index < savedTodos.count else {
            return
        }
        
        var todoToUpdate = savedTodos[index]
        todoToUpdate.isCompleted = isCompleted
        todoToUpdate.content = newContent
        savedTodos[index] = todoToUpdate
        
        saveTodos(savedTodos)
    }
    
    // 메모 삭제
    func deleteMemo(at index: Int) {
        var savedTodos = getTodos()
        savedTodos.remove(at: index)
        saveTodos(savedTodos) // 메소드 이름 수정: savedMemos -> saveMemos
    }
    
    // 메모 저장
    private func saveTodos(_ todos: [Todo]) { // 메소드 이름 수정: saveMemos -> saveMemos
        // JsonEncoder를 사용하여 데이터 저장
        if let todosData = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(todosData, forKey: todoKey)
        }
    }
}
