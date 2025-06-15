//
//  AppDelegate.swift
//  SayItStraight
//
//  Created by Zack Boutchyard on 6/10/25.
//

import UIKit
import Supabase

class AppDelegate: NSObject, UIApplicationDelegate {
    static var supabase: SupabaseClient!

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        AppDelegate.supabase.auth.handle(url)
        return true
    }
}
