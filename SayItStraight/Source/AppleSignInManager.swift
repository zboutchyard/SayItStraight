//
//  AppleSignInManager.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/8/25.
//

import Foundation
import AuthenticationServices
import SwiftUI

final class AppleSignInManager: NSObject,
                                ASAuthorizationControllerDelegate,
                                ASAuthorizationControllerPresentationContextProviding {
    static let shared: AppleSignInManager = AppleSignInManager()
    
    private var completion: ((ASAuthorizationAppleIDCredential?) -> Void)?

    func startSignIn(completion: @escaping (ASAuthorizationAppleIDCredential?) -> Void) {
        self.completion = completion
        let provider: ASAuthorizationAppleIDProvider = ASAuthorizationAppleIDProvider()
        let request: ASAuthorizationAppleIDRequest = provider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller: ASAuthorizationController = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization) {
        // swiftlint:disable:next explicit_type_interface
        let credential = authorization.credential as? ASAuthorizationAppleIDCredential
        completion?(credential)
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Sign-In failed: \(error.localizedDescription)")
        completion?(nil)
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? UIWindow()
    }
}
