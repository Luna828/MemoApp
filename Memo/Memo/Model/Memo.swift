import Foundation

//저장을 원하는 타입에 Codable protocol 채택
struct Memo: Codable {
    let uuid: UUID
    var title: String
    var content: String
}

class MemoManager {
    private let memoKey = "memoKey"
    
    // 메모 읽어오기
    func getMemos() -> [Memo] {
        if let memosData = UserDefaults.standard.data(forKey: memoKey),
           //JsonDecoder를 사용하여 저장된 데이터 가져오기
           let memos = try? JSONDecoder().decode([Memo].self, from: memosData) {
            return memos
        }
        return []
    }
    
    // 메모 추가
    func addMemo(_ memo: Memo) {
        var savedMemos = getMemos()
        savedMemos.append(memo)
        saveMemos(savedMemos) // 메소드 이름 수정: saveMemo -> saveMemos
    }
    
    // 메모 수정
    func updateMemo(at index: Int, with newTitle: String, newContent: String) {
        var savedMemos = getMemos()
        
        guard index >= 0, index < savedMemos.count else {
            return
        }
        
        var memoToUpdate = savedMemos[index]
        memoToUpdate.title = newTitle
        memoToUpdate.content = newContent
        savedMemos[index] = memoToUpdate
        
        saveMemos(savedMemos)
    }
    
    // 메모 삭제
    func deleteMemo(at index: Int) {
        var savedMemos = getMemos()
        savedMemos.remove(at: index)
        saveMemos(savedMemos) // 메소드 이름 수정: savedMemos -> saveMemos
    }
    
    // 메모 저장
    private func saveMemos(_ memos: [Memo]) { // 메소드 이름 수정: saveMemos -> saveMemos
        //JsonEncoder를 사용하여 데이터 저장
        if let memosData = try? JSONEncoder().encode(memos) {
            UserDefaults.standard.set(memosData, forKey: memoKey)
        }
    }
}
