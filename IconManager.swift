import UIKit

class IconManager {
    static func changeAppIcon(to iconName: String?) {
        guard UIApplication.shared.supportsAlternateIcons else { return }
        
        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error {
                print("خطأ في تغيير الأيقونة: \(error.localizedDescription)")
            } else {
                print("تم تغيير أيقونة التطبيق بنجاح!")
            }
        }
    }
}