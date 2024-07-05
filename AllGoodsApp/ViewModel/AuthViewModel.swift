//
//  AuthViewModel.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 04.07.24.
//

import Foundation
import FirebaseAuth

class AuthViewModel {
    
    func register(email: String, password: String, username: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = authResult?.user else { return }
            
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = username
            changeRequest.commitChanges { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                let userModel = UserModel(email: email, uid: user.uid, username: username)
                completion(.success(userModel))
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = authResult?.user else { return }
            
            let userModel = UserModel(email: email, uid: user.uid, username: user.displayName ?? "")
            completion(.success(userModel))
        }
    }
}
