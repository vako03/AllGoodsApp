//
//  AuthViewModel.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 04.07.24.
//

import Foundation
import FirebaseAuth

final class AuthViewModel {

    // MARK: - Registration
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

    // MARK: - Login
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

    // MARK: - Logout
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch let signOutError as NSError {
            completion(.failure(signOutError))
        }
    }

    // MARK: - User State
    var isLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }

    var currentUser: UserModel? {
        guard let user = Auth.auth().currentUser else { return nil }
        return UserModel(email: user.email ?? "", uid: user.uid, username: user.displayName ?? "")
    }
}
