import BRYXBanner

class ErrorHandler {
    static func handleError(_ error: Error) {
        let errorResponse = error as? ErrorResponse
        let banner = Banner(title: "Error", subtitle: errorResponse?.error, backgroundColor: #colorLiteral(red: 0.8596960616, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
        banner.show(duration: 2.0)
    }
}
