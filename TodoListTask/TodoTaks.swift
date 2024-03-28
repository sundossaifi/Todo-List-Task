

import UIKit

struct TodoTaks {
    let title: String
    let isComplete: Bool
    init(title: String , isComplete: Bool = false) {
        self.title = title
        self.isComplete = isComplete
    }
}

