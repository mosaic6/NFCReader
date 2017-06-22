//
//  ViewController.swift
//  NFCTest
//
//  Created by Joshua Walsh on 6/11/17.
//  Copyright © 2017 Joshua Walsh. All rights reserved.
//

import UIKit
import CoreNFC
import GoogleMobileAds

class ViewController: UIViewController, NFCNDEFReaderSessionDelegate, GADBannerViewDelegate {
    
    // MARK: Private variables
    
    private var nfcSession: NFCNDEFReaderSession!
    private var nfcMessages: [[NFCNDEFMessage]] = []
    
    // MARK: Variables
    
    var bannerView: GADBannerView?
    
    // MARK: Outlets
    
    @IBOutlet weak var bannerContainerView: UIView?
    
    // MARK: Actions
    
    @IBAction func startNFCSession(_ sender: Any) {
        self.startNFCSession()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("Error reading NFC: \(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("New NFC Tag detected:")
        for message in messages {
            for record in message.records {
                print("Type name format: \(record.typeNameFormat)")
                print("Payload: \(record.payload)")
                print("Type: \(record.type)")
                print("Identifier: \(record.identifier)")
            }
        }
        self.nfcMessages.append(messages)
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        guard let banner = bannerView else { return }
        self.bannerContainerView?.addSubview(banner)
        banner.adUnitID = "ca-app-pub-3940256099942544/6300978111" // Prod Ad unit id - ca-app-pub-7320328396082907/7566271672
        banner.rootViewController = self
        banner.load(GADRequest())
        
        // TODO: Remove before prod
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID,
            "3a0843b7f4b4edcac021363356c40d9f446bf737" ];
    }
}

// MARK: CORE NFC

extension ViewController {
    func startNFCSession() {
        self.nfcSession = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.global(qos: .background), invalidateAfterFirstRead: true)
        self.nfcSession?.begin()
    }
}

// MARK: Ads

extension ViewController {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        bannerView.transform = translateTransform
        
        UIView.animate(withDuration: 0.5) {
            bannerView.transform = CGAffineTransform.identity
        }
    }
}
