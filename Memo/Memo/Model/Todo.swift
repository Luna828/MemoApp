import Foundation

// 저장을 원하는 타입에 Codable protocol 채택
struct Todo: Codable {
    var uuid: UUID = .init()
    var content: String
    var isCompleted: Bool
}

class TodoManager {
    private let todoKey = "todoKey"
    
    // 메모 읽어오기
    func getTodos(for section: String) -> [Todo] {
        if let todosData = UserDefaults.standard.data(forKey: "\(todoKey)_\(section)"),
           let todos = try? JSONDecoder().decode([Todo].self, from: todosData)
        {
            return todos
        }
        return []
    }
    
    // 메모 추가
    func addTodo(_ todo: Todo, to section: String) {
        var savedTodos = getTodos(for: section)
        savedTodos.append(todo)
        saveTodos(savedTodos, for: section)
    }
    
    // 메모 수정
    func updateTodo(at index: Int, with newContent: String, isCompleted: Bool, in section: String) {
        var savedTodos = getTodos(for: section)
        
        guard index >= 0, index < savedTodos.count else {
            return
        }
        
        var todoToUpdate = savedTodos[index]
        todoToUpdate.isCompleted = isCompleted
        todoToUpdate.content = newContent
        savedTodos[index] = todoToUpdate
        
        saveTodos(savedTodos, for: section)
    }
    
    func deleteTodo(at index: Int, in section: String) {
        var savedTodos = getTodos(for: section)
        savedTodos.remove(at: index)
        saveTodos(savedTodos, for: section)
    }
    
    private func saveTodos(_ todos: [Todo], for section: String) {
        if let todosData = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(todosData, forKey: "\(todoKey)_\(section)")
        }
    }
}
