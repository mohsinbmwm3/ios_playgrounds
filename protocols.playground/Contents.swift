import UIKit

protocol List {
    associatedtype Item
    
    var items: [Item] { get set }
    mutating func add(_ item: Item)
    func get(at index: Int) -> Item
}

struct IntegerList: List {
    var items: [Int] = []
    mutating func add(_ item: Int) {
        items.append(item)
    }
    
    func get(at index: Int) -> Int {
        return items[index]
    }
}

struct DoubleList: List {
    var items: [Double] = []
    mutating func add(_ item: Double) {
        items.append(item)
    }
    
    func get(at index: Int) -> Double {
        return items[index]
    }
}

struct ListOperations {
    func makeIntegerList() -> any List {
        return IntegerList()
    }
}

let listOperation = ListOperations()
let intList = listOperation.makeIntegerList()
let value = intList.get(at: 1)

// Type erasure example
struct AnyList<T>: List {
    private let _add: (T) -> Void
    private let _get: (Int) -> T
    
    init<L: List>(_ list: L) where L.Item == T {
        var copy = list
        
        _add = { item in copy.add(item) }
        _get = { index in copy.get(at: index) }
    }
    
    mutating func add(_ item: T) {
        _add(item)
    }
    
    func get(at index: Int) -> T {
        _get(index)
    }
    
}
