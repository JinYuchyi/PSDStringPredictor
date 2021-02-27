enum StringAlignment:String, CaseIterable{
    case left, center, right
}

extension StringAlignment{
    func index () -> Int {
        switch self {
            case .left: return 1
            case .center: return 2
            case .right: return 3
        }
    }
    
    func imageName() -> String {
        switch self {
            case .left: return "alignLeft-round"
            case .center: return "alignCenter-round"
            case .right: return "alignRight-round"
        }
    }
}
