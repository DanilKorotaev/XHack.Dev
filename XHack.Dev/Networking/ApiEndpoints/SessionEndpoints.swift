import Foundation

enum SessionEndpoints {
    class SignIn: ApiRequest<SignInResponse> {
        init(credentials: Credentials) {
            super.init(resource: "http://localhost:3000/api/auth/login",
                       method: .post,
                       json: SignInRequest(email: credentials.email, password: credentials.password).toJson())
        }
    }
    
    class SignOut: ApiRequest<VoidResponse> {
        init() {
            super.init(resource: "logout",
                       method: .post)
        }
    }
    
    class SignUp: ApiRequest<SignUpResponse> {
        init(content: SignUpRequest) {
            super.init(resource: "http://localhost:3000/api/auth/register",
                       method: .post,
                       json: content.toJson())
        }
    }
}
