//
//  AdmobBanner.swift
//  SakeLog
//
//  Created by Takane on 2025/12/13.
//


import SwiftUI
import Foundation
import GoogleMobileAds

protocol BannerViewControllerWidthDelegate: AnyObject {
    func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat)
}

class BannerViewController: UIViewController {
    weak var delegate: BannerViewControllerWidthDelegate?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.bannerViewController(
            self,
            didUpdate: view.frame.inset(by: view.safeAreaInsets).size.width
        )
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate { _ in
        } completion: { _ in
            self.delegate?.bannerViewController(
                self,
                didUpdate: self.view.frame.inset(by: self.view.safeAreaInsets).size.width
            )
        }
    }
}

struct AdmobBannerView: UIViewControllerRepresentable {
    @State private var viewWidth: CGFloat = .zero

    // ★ あなたの SDK では BannerView の名前が正しい
    private let bannerView = BannerView()

    private let adUnitID = "ca-app-pub-4739003769773423/8764917387"

    func makeUIViewController(context: Context) -> some UIViewController {
        let bannerVC = BannerViewController()

        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = bannerVC
        bannerView.delegate = context.coordinator

        bannerVC.view.addSubview(bannerView)
        bannerVC.delegate = context.coordinator

        return bannerVC
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        guard viewWidth != .zero else { return }

        // ★ あなたの SDK は Request() ではなく GADRequest()
        let request = Request()

        // ★ AdSize ではなく “旧 API の C 関数” を使う必要がある
        bannerView.adSize = currentOrientationAnchoredAdaptiveBanner(width: viewWidth)

        bannerView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, BannerViewControllerWidthDelegate, BannerViewDelegate {

        let parent: AdmobBannerView

        init(_ parent: AdmobBannerView) {
            self.parent = parent
        }

        func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat) {
            parent.viewWidth = width
        }

        // MARK: - BannerViewDelegate

        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
            print("bannerViewDidReceiveAd")
        }

        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
            print("didFailToReceiveAdWithError: \(error.localizedDescription)")
        }

        func bannerViewDidRecordImpression(_ bannerView: BannerView) {
            print("bannerViewDidRecordImpression")
        }

        func bannerViewWillPresentScreen(_ bannerView: BannerView) {
            print("bannerViewWillPresentScreen")
        }

        func bannerViewWillDismissScreen(_ bannerView: BannerView) {
            print("bannerViewWillDismissScreen")
        }

        func bannerViewDidDismissScreen(_ bannerView: BannerView) {
            print("bannerViewDidDismissScreen")
        }
    }
}

