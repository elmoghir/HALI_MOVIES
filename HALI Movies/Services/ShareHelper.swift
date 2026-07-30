//
//  ShareHelper.swift
//  Hali Cinema
//

import UIKit

enum ShareHelper {
    @MainActor
    static func shareItems(_ items: [Any]) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let root = scene.windows.first(where: \.isKeyWindow)?.rootViewController
            ?? scene.windows.first?.rootViewController
        guard let root else { return }
        let presenter = root.presentedViewController ?? root
        let activity = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if let popover = activity.popoverPresentationController {
            popover.sourceView = presenter.view
            popover.sourceRect = CGRect(
                x: presenter.view.bounds.midX,
                y: presenter.view.bounds.midY,
                width: 0,
                height: 0
            )
            popover.permittedArrowDirections = []
        }
        presenter.present(activity, animated: true)
    }

    static func copyToPasteboard(_ string: String) {
        UIPasteboard.general.string = string
        HapticFeedback.success()
    }
}
