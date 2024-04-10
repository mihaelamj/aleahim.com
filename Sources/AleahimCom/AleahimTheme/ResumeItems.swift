//
//  ResumeItems.swift
//  
//
//  Created by Mihaela MJ on 10.04.2024..
//

import Plot
import Foundation
import Publish

//struct ResumeItems<Site: Website>: Component {
//    let myResume = FullResume.me
//    var site: Site
//    
//    var body: Component {
//        Div {
//            H1("Mihaela M's Resume")
//            
//            // Personal Information
//            Div {
//                H2("Personal Information")
//                Paragraph("Address: \(myResume.perfonalInformation.address)")
//                Paragraph("Email: \(myResume.perfonalInformation.email)")
//                Paragraph("LinkedIn: \(myResume.perfonalInformation.linkedin)")
//                Paragraph("GitHub: \(myResume.perfonalInformation.github)")
//                Paragraph("Skype: \(myResume.perfonalInformation.skype)")
//                Paragraph("Twitter: \(myResume.perfonalInformation.twitter)")
//                Paragraph("Facetime: \(myResume.perfonalInformation.facetime)")
//            }
//            
//            // Education
//            Div {
//                H2("Education")
//                Paragraph("Degree: \(myResume.education.degree)")
//                Paragraph("University: \(myResume.education.university)")
//            }
//            
//            // Work Experience
//            Div {
//                H2("Work Experience")
//                for workExperience in myResume.workExperiences {
//                    Div {
//                        H3("\(workExperience.title) at \(workExperience.company)")
//                        Paragraph("Location: \(workExperience.location)")
//                        Paragraph("Start Date: \(workExperience.startDate)")
//                        Paragraph("End Date: \(workExperience.endDate)")
//                        if !workExperience.responsibilities.isEmpty {
//                            H4("Responsibilities:")
//                            List(workExperience.responsibilities.map {
//                                Text($0.title)
//                            })
//                        }
//                    }
//                }
//            }
//            
//            // Previous Experience
//            Div {
//                H2("Previous Experience")
//                for project in myResume.previousExperiences.projects {
//                    Div {
//                        H3(project.title)
//                        Paragraph(project.description)
//                    }
//                }
//                H3("Employments")
//                List(myResume.previousExperiences.employments.map {
//                    Text($0.title)
//                })
//            }
//        }
//    }
//}

