import PKHUD

class ErrorHandler {
    static func handleError(_ error: Error) {
        HUD.flash(.error)
        let errorResponse = error as? ErrorResponse
        print(errorResponse?.error)
    }
}
