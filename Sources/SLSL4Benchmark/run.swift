import Foundation

func run(_ name:String, _ fx:() -> Stat) {
    print("-------------")
    print(name)
    let stat = fx()
    print()
    print(stat.description)
    print()
}
