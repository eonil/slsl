import Foundation

struct Stat: CustomStringConvertible {
    var timeTaken: TimeInterval
    
    var description: String {
        let sec = round(timeTaken * 1000) / 1000
        return "Time: \(sec)s"
    }
}
