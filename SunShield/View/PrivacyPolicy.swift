//
//  PrivacyPolicy.swift
//  SunShield
//
//  Created by Matthew Auciello on 5/7/2024.
//

import SwiftUI

struct PrivacyPolicy: View {
    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("SunShield Privacy Policy")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 8)
                    
                    Text("This Privacy Policy governs the collection and use of information through SunShield's applications for iPhone and other devices or platforms.")
                        .padding(.bottom, 12)
                    
                    Text("1. Information Collection")
                        .font(.headline)
                    
                    Text("SunShield gathers geolocation coordinates from your device to access weather data.")
                        .padding(.bottom, 8)
                    
                    Text("2. Technical Information")
                        .font(.headline)
                    
                    Text("SunShield transmits your location data to its servers, where a record of requests and basic technical details (such as your device's IP address) is temporarily stored. This information is periodically deleted.")
                        .padding(.bottom, 8)
                    
                    Text("3. Use of Information")
                        .font(.headline)
                    
                    Text("The collected information is used to obtain weather data and improve the SunShield app. Personal information is shared with external parties only when SunShield is legally required to do so or as necessary to fulfill the app's functions. We may also disclose your information to exercise legal rights or defend against legal claims, investigate suspected fraud or abuse, or protect our rights and property. Your location data is never sold to third parties or used for targeted advertising.")
                        .padding(.bottom, 8)
                    
                    Text("4. Security Measures")
                        .font(.headline)
                    
                    Text("SunShield takes measures to protect your information. We collect only the minimum data necessary for the app's functions and secure communications between the app and SunShield's servers using HTTPS.")
                        .padding(.bottom, 8)
                    
                    Text("5. California Online Privacy Protection Act (CalOPPA) Compliance")
                        .font(.headline)
                    
                    Text("SunShield complies with the California Online Privacy Protection Act. In line with CalOPPA, we provide clear information about our data collection and usage practices. Users can review and request changes to their personal information. We also respect Do Not Track (DNT) signals and do not track or plant cookies when a DNT browser mechanism is enabled.")
                        .padding(.bottom, 8)
                    
                    Text("6. International Data Transfers")
                        .font(.headline)
                    
                    Text("Your information may be processed, stored, and used outside your home country. Data privacy laws differ across jurisdictions, and various laws may apply to your data based on its location. If you are in the European Union, by using SunShield, you consent to the collection, use, and storage of your information outside the European Union.")
                        .padding(.bottom, 8)
                    
                    Text("7. Consent")
                        .font(.headline)
                    
                    Text("By using SunShield, you agree to this Privacy Policy.")
                        .padding(.bottom, 8)
                }
                .padding(.horizontal)
            }
            .navigationBarTitle("Privacy Policy", displayMode: .inline)
        }
}

#Preview {
    PrivacyPolicy()
}
