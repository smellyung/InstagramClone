import Foundation

protocol LoginViewModelDelegate: class {
//    func loginViewModel(_ loginViewModel: LoginViewModel, didUpdateEmail email: String)
}

class LoginViewModel {
    weak var delegate: LoginViewModelDelegate?

    var email: String?
    var password: String?

    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }

    func textDidUpdate(to text: String?, for section: String) {
        print("text updated to: \(String(describing: text))")
        switch section {
        case "email":
            self.email = text
        case "password":
            self.password = text
        default:
            break
        }
    }
}
