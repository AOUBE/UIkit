//
//  SceneDelegate.swift
//  Checklists
//
//  Created by mittwoch on 2024/11/4.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    //启动的时候，在window中放置对UIWindow的引用
    var window: UIWindow?
    
    //关键字类（如DataModel）定义的对象是引用类型。变量或常量不包含实际对象，仅包含对对象的引用——引用只是存储对象的内存位置。
    let dataModel = DataModel()
    
    
    //scene(_:willConnectTo:connectionOptions:)方法，该方法在应用程序启动后立即被调用。
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        
        
        //查看navigationController的viewControllers数组才能找到AllListsViewController：
        let navigationController = window!.rootViewController as! UINavigationController
        let controller = navigationController.viewControllers[0] as! AllListsViewController
        controller.dataModel = dataModel
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        saveData()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        saveData()
    }
    
    
    //MARK: - Helper Methods
    func saveData(){
        //查看navigationController的viewControllers数组才能找到AllListsViewController：
        //        let navigationController = window!.rootViewController as! UINavigationController
        //        let controller = navigationController.viewControllers[0] as! AllListsViewController
        dataModel.saveChecklists()
    }
}
