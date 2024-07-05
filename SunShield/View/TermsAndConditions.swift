//
//  TermsAndConditions.swift
//  SunShield
//
//  Created by Matthew Auciello on 5/7/2024.
//

import SwiftUI

struct TermsAndConditions: View {
    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Terms and Conditions")
                        .font(.largeTitle)
                        .bold()
                    
                    Group {
                        Text("1. About the Application")
                            .font(.title2)
                            .bold()
                        Text("The application is called SunShield. It is owned by Matthew Auciello.")
                        Text("By using, browsing, and/or reading the application, you signify that you have read, understood, and agree to be bound by these terms. If you do not agree with these terms, you must cease usage of the application or any of its services immediately.")
                        Text("Matthew Auciello reserves the right to review and change any of these terms by updating this page at its sole discretion. When Matthew Auciello updates the terms, he will use reasonable endeavors to provide you with notice of updates to the terms. Any changes to the terms take immediate effect from the date of their publication.")
                    }
                    
                    Group {
                        Text("2. Acceptance of the Terms")
                            .font(.title2)
                            .bold()
                        Text("You accept the terms by remaining on the application.")
                    }
                    
                    Group {
                        Text("3. Your Obligations as a Member")
                            .font(.title2)
                            .bold()
                        Text("Access and use of the application are limited, non-transferable, and allow for the sole use of the application by you for the purposes of Matthew Auciello providing the services.")
                        Text("You will not use the services or the application in connection with any commercial endeavors except those that are specifically endorsed or approved by the management of Matthew Auciello.")
                        Text("You will not use the services or the application for any illegal and/or unauthorized use.")
                        Text("You agree that commercial advertisements, affiliate links, and other forms of solicitation may be removed from the application without notice and may result in termination.")
                        Text("You acknowledge and agree that any automated use of the application or its services is prohibited.")
                    }
                    
                    Group {
                        Text("4. Copyright and Intellectual Property")
                            .font(.title2)
                            .bold()
                        Text("The application is subject to copyright. The material on the application is protected by copyright under the laws of Australia and through international treaties. Unless otherwise indicated, all rights (including copyright) in the services and compilation of the application (including but not limited to text, graphics, logos, button icons, video images, audio clips, application code, scripts, design elements, and interactive features) or the services are owned or controlled for these purposes and are reserved by Matthew Auciello or its contributors.")
                        Text("You may not, without the prior written permission of Matthew Auciello and the permission of any other relevant rights owners, broadcast, republish, upload to a third party, transmit, post, distribute, show or play in public, adapt or change in any way the content of the application for any purpose, unless otherwise provided by these terms.")
                    }
                    
                    Group {
                        Text("5. Privacy")
                            .font(.title2)
                            .bold()
                        Text("Matthew Auciello takes your privacy very seriously, and any information provided through your use of the application and/or services is subject to Matthew Auciello's privacy policy, which is available on the application.")
                    }
                    
                    Group {
                        Text("6. General Disclaimer")
                            .font(.title2)
                            .bold()
                        Text("Nothing in the terms limits or excludes any guarantees, warranties, representations, or conditions implied or imposed by law, including the Australian Consumer Law (or any liability under them), which by law may not be limited or excluded.")
                        Text("Subject to this clause and to the extent permitted by law:")
                        Text("All terms, guarantees, warranties, representations, or conditions which are not expressly stated in the terms are excluded.")
                        Text("Matthew Auciello will not be liable for any special, indirect, or consequential loss or damage, loss of profit or opportunity, or damage to goodwill arising out of or in connection with the services or these terms.")
                        Text("USE OF THE APPLICATION IS AT YOUR OWN RISK. Everything on the application and the service is provided to you \"as is\" and \"as available\" without warranty or condition of any kind. None of the affiliates, directors, officers, employees, agents, contributors, and licensors of Matthew Auciello make any express or implied representation or warranty about the services or any products or services referred to on the application. This includes (but is not restricted to) loss or damage you might suffer as a result of any of the following:")
                        Text("Failure of performance, error, omission, interruption, deletion, defect, failure to correct defects, delay in operation or transmission, computer virus, or other harmful component.")
                        Text("Loss of data, communication line failure, unlawful third-party conduct, or theft.")
                        Text("Destruction, alteration, or unauthorized access to records.")
                        Text("The accuracy, suitability, or currency of any information on the application, the services, or any of its services-related products.")
                        Text("This application is a guide and is intended to serve as an indication of sun protection only. It does not protect you from sun damage. Always follow professional medical advice and take necessary precautions to protect your skin from sun exposure. Matthew Auciello assumes no liability for any physical or health damages incurred as a result of using the application. You acknowledge and agree that the application should not be relied upon as a substitute for professional medical advice and that you use the application at your own risk.")
                    }
                    
                    Group {
                        Text("7. Limitation of Liability")
                            .font(.title2)
                            .bold()
                        Text("Matthew Auciello's total liability arising out of or in connection with the application or these terms, however arising, including under contract, tort, in equity, under statute, or otherwise, will not exceed the resupply of the services to you.")
                        Text("You expressly understand and agree that Matthew Auciello, his affiliates, employees, agents, contributors, and licensors shall not be liable to you for any direct, indirect, incidental, special, consequential, or exemplary damages which may be incurred by you, however caused and under any theory of liability.")
                    }
                    
                    Group {
                        Text("8. Indemnity")
                            .font(.title2)
                            .bold()
                        Text("You agree to indemnify Matthew Auciello, his affiliates, employees, agents, contributors, third-party content providers, and licensors from and against all actions, suits, claims, demands, liabilities, costs, expenses, loss, and damage incurred, suffered, or arising out of or in connection with your content, any direct or indirect consequences of you accessing, using, or transacting on the application or attempts to do so, and/or any breach of the terms.")
                    }
                    
                    Group {
                        Text("9. Links to Other Websites")
                            .font(.title2)
                            .bold()
                        Text("Our service may contain links to third-party websites or services that are not owned or controlled by Matthew Auciello.")
                        Text("Matthew Auciello has no control over, and assumes no responsibility for, the content, privacy policies, or practices of any third-party website or service. You further acknowledge and agree that Matthew Auciello shall not be responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with the use of or reliance on any such content.")
                        Text("We strongly advise you to read the terms and conditions and privacy policies of any third-party websites or services that you visit.")
                    }
                    
                    Group {
                        Text("10. Venue and Jurisdiction")
                            .font(.title2)
                            .bold()
                        Text("The services offered by Matthew Auciello are intended to be viewed globally. However, any disputes arising out of or in connection with the application or these terms shall be exclusively governed by the laws of Australia.")
                        Text("You agree to submit to the exclusive jurisdiction of the courts located in Australia for the resolution of any disputes.")
                        Text("For European Union (EU) users: If you are a European Union consumer, you will benefit from any mandatory provisions of the law of the country in which you are a resident.")
                        Text("For United States federal government end users: If you are a U.S. federal government end user, our service is a \"commercial item\" as that term is defined at 48 C.F.R. 2.101.")
                    }
                    
                    Group {
                        Text("11. Governing Law")
                            .font(.title2)
                            .bold()
                        Text("These terms are governed by and construed in accordance with the laws of Australia. You agree to submit to the exclusive jurisdiction of the courts located in Australia for the resolution of any disputes.")
                    }
                    
                    Group {
                        Text("12. Severance")
                            .font(.title2)
                            .bold()
                        Text("If any part of these terms is found to be void or unenforceable by a court of competent jurisdiction, that part shall be severed, and the rest of the terms shall remain in force.")
                    }
                    
                    Group {
                        Text("13. Contact Us")
                            .font(.title2)
                            .bold()
                        Text("If you have any questions about these Terms and Conditions, you can contact us: sunshield@gmail.com")
                        
                        Text("Last updated: July 5, 2024")
                    }
                }
                .padding()
            }
            .navigationBarTitle("Terms and Conditions", displayMode: .inline)
        }
}

#Preview {
    TermsAndConditions()
}
