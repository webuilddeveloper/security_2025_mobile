// import Flutter
// import UIKit

// @main
// @objc class AppDelegate: FlutterAppDelegate {

//     override func application(
//         _ application: UIApplication,
//         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//     ) -> Bool {

//         GeneratedPluginRegistrant.register(with: self)

//         return super.application(
//             application,
//             didFinishLaunchingWithOptions: launchOptions
//         )
//     }
// }

 
import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  // Flutter 3.35 predates FlutterImplicitEngineDelegate. Keep one explicit
  // engine so plugins can register before UIKit connects the scene window.
  let flutterEngine = FlutterEngine(name: "marine")

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR KEY HERE")
    flutterEngine.run()
    GeneratedPluginRegistrant.register(with: flutterEngine)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

// Flutter 3.35.3 uses FlutterAppDelegate for plugin callbacks.
// Keep this bridge in the Runner target without requiring newer Flutter APIs.
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  private var appDelegate: AppDelegate? {
    UIApplication.shared.delegate as? AppDelegate
  }

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = scene as? UIWindowScene,
          let appDelegate = appDelegate else { return }

    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = FlutterViewController(
      engine: appDelegate.flutterEngine, nibName: nil, bundle: nil
    )
    self.window = window
    // Plugins in this Flutter version still look up the app delegate's window.
    appDelegate.window = window
    window.makeKeyAndVisible()

    // Cold-start links arrive here instead of in didFinishLaunchingWithOptions.
    self.scene(scene, openURLContexts: connectionOptions.urlContexts)
    for userActivity in connectionOptions.userActivities {
      self.scene(scene, continue: userActivity)
    }
  }

  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    for context in URLContexts {
      var options: [UIApplication.OpenURLOptionsKey: Any] = [
        .openInPlace: context.options.openInPlace
      ]
      if let sourceApplication = context.options.sourceApplication {
        options[.sourceApplication] = sourceApplication
      }
      if let annotation = context.options.annotation {
        options[.annotation] = annotation
      }
      _ = appDelegate?.application(
        UIApplication.shared, open: context.url, options: options
      )
    }
  }

  func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    _ = appDelegate?.application(
      UIApplication.shared, continue: userActivity, restorationHandler: { _ in }
    )
  }
}
