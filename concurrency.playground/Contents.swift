import UIKit
import Foundation

var greeting = "Hello, playground"

let operationQueue = OperationQueue()


let fetchBenificiariesOperation = BlockOperation {
    print("Benificiary are being fetched")
    for i in 1...3 {
        Thread.sleep(forTimeInterval: 1)
        print(".")
    }

    print("Benificiary fetched!")
}

let fetchBalanceOperation = BlockOperation {
    print("Account balance is being fetched")
    for i in 0...1 {
        Thread.sleep(forTimeInterval: 1)
        print(".")
    }
    print("Account balance fetched!")
}

fetchBenificiariesOperation.addDependency(fetchBalanceOperation)
operationQueue.addOperations([fetchBenificiariesOperation, fetchBalanceOperation], waitUntilFinished: false)

print("All good at then end!!!")


let group = DispatchGroup()
let queue = DispatchQueue.global()

group.enter()

queue.async {
    // Fetch master list
    print("Master list is being fetched")
    for i in 1...3 {
        Thread.sleep(forTimeInterval: 1)
        print("ML.")
    }

    print("Master list fetched!")

    group.leave()
}

queue.async {
    // Fetch account balance
    print("Account balance is being fetched")
    for i in 0...1 {
        Thread.sleep(forTimeInterval: 1)
        print("AB.")
    }
    print("Account balance fetched!")
    
    group.leave()
}

group.notify(queue: .main) {
    print("We are ready to show transfer screen!!!")
}
