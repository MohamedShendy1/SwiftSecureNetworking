//
//  Pinning.swift
//  SwiftSecureNetworking
//
//  Created by Mohamed Shendy  on 30/06/2026.
//
import Foundation
import Security
import CryptoKit
// ============================================================
// FIX 7 — Certificate Pinning via URLSessionDelegate
// ============================================================

// WHY: URLSession.shared trusts any cert signed by a trusted CA.
// A MITM attacker with a rogue CA (trivially installed on a test device)
// can intercept all tokens and payloads. Pinning binds the app to YOUR
// certificate's public key hash — rogue CA certs are rejected at the TLS layer.

final class PinningSessionDelegate: NSObject, URLSessionDelegate {

    private let pinnedHashes: Set<String>

    /// Pass the SHA-256 base64 hashes of your server's public key(s).
    /// Run: openssl x509 -in cert.pem -pubkey -noout |
    ///      openssl pkey -pubin -outform DER |
    ///      openssl dgst -sha256 -binary | base64
    init(pinnedHashes: Set<String>) {
        self.pinnedHashes = pinnedHashes
    }

    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        guard
            challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
            let serverTrust = challenge.protectionSpace.serverTrust
        else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        // Extract the leaf certificate's public key data
        guard
            let certChain = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate],
            let leaf = certChain.first
        else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        let certData = SecCertificateCopyData(leaf) as Data
        let hash = SHA256.hash(data: certData)
            .map { String(format: "%02x", $0) }
            .joined()

        // Also check base64 variant for interoperability
        let hashBase64 = Data(SHA256.hash(data: certData)).base64EncodedString()

        if pinnedHashes.contains(hash) || pinnedHashes.contains(hashBase64) {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            // Pin mismatch — reject the connection entirely
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}
