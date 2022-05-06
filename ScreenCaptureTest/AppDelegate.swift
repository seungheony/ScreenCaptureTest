//
//  AppDelegate.swift
//  ScreenCaptureTest
//
//  Created by shkim-mac on 2022/05/06.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var window: UIWindow? {
        return (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        lunchScreen()
        startPreventingScreenshot()
        startPreventingRecording()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func startPreventingScreenshot() {
        NotificationCenter.default.addObserver(self, selector: #selector(didDetectScreenshot), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }
        
    func startPreventingRecording() {
        NotificationCenter.default.addObserver(self, selector: #selector(didDetectRecording), name: UIScreen.capturedDidChangeNotification, object: nil)
    }
    
    @objc private func didDetectScreenshot() {
        let alert = UIAlertController(title: "스크린캡처가 감지되었습니다.", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)

        alert.addAction(cancelAction)

        DispatchQueue.main.async {
            self.hideScreen()
            
            if var topController = self.window?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                topController.present(alert, animated: false, completion: nil)
            }
        }
    }
    
    @objc private func didDetectRecording() {
        let alert = UIAlertController(title: "화면 녹화가 감지되었습니다.", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)

        alert.addAction(cancelAction)

        DispatchQueue.main.async {
            self.hideScreen()
            
            if var topController = self.window?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                topController.present(alert, animated: false, completion: nil)
            }
        }
    }
    private func hideScreen() {
        if UIScreen.main.isCaptured {
            window?.isHidden = true
        } else {
            window?.isHidden = false
        }
    }
    func lunchScreen() {
        if UIScreen.main.isCaptured {
            DispatchQueue.main.async {
                self.hideScreen()
            }
        }
    }
}

