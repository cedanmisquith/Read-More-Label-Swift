//
//  ViewController.swift
//  ReadMoreLabel
//
//  Created by Cedan Misquith on 06/07/20.
//  Copyright © 2020 Cedan Misquith. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class TTTAttributeLableParameters: NSObject {
    var labelText: String
    var readMoreText: String
    var readLessText: String
    var font: UIFont
    var charatersBeforeReadMore: Int
    var activeLinkColor: UIColor
    var isReadMoreTapped: Bool
    var isReadLessTapped: Bool
    init(labelText: String, readMoreText: String, readLessText: String, font: UIFont, charatersBeforeReadMore: Int, activeLinkColor: UIColor, isReadMoreTapped: Bool, isReadLessTapped: Bool) {
        self.labelText = labelText
        self.readMoreText = readMoreText
        self.readLessText = readLessText
        self.font = font
        self.charatersBeforeReadMore = charatersBeforeReadMore
        self.activeLinkColor = activeLinkColor
        self.isReadMoreTapped = isReadMoreTapped
        self.isReadLessTapped = isReadLessTapped
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var readMoreLabel: TTTAttributedLabel!

    var isReadmoreEnabled: Bool = false
    let characterLimitBeforReadMore =  80
    var fullString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        configureReadMoreLabel()
    }
    func configureReadMoreLabel() {
        fullString = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        readMoreLabel.showTextOnTTTAttributeLable(
            parameters: TTTAttributeLableParameters.init(labelText: fullString,
                                                         readMoreText: "\nRead more",
                                                         readLessText: "\nRead less",
                                                         font: UIFont.systemFont(ofSize: 17),
                                                         charatersBeforeReadMore: characterLimitBeforReadMore,
                                                         activeLinkColor: .blue,
                                                         isReadMoreTapped: false,
                                                         isReadLessTapped: false))
        readMoreLabel.delegate = self
    }
    func readMore(readMore: Bool) {
    readMoreLabel.showTextOnTTTAttributeLable(
        parameters: TTTAttributeLableParameters.init(labelText: fullString,
                                                     readMoreText: "\nRead more",
                                                     readLessText: "\nRead less",
                                                     font: UIFont.systemFont(ofSize: 17),
                                                     charatersBeforeReadMore: characterLimitBeforReadMore,
                                                     activeLinkColor: .blue,
                                                     isReadMoreTapped: readMore,
                                                     isReadLessTapped: false))
    }
    func readLess(readLess: Bool) {
        readMoreLabel.showTextOnTTTAttributeLable(
            parameters: TTTAttributeLableParameters.init(labelText: fullString,
                                                         readMoreText: "\nRead more",
                                                         readLessText: "\nRead less",
                                                         font: UIFont.systemFont(ofSize: 17),
                                                         charatersBeforeReadMore: characterLimitBeforReadMore,
                                                         activeLinkColor: .blue,
                                                         isReadMoreTapped: readLess,
                                                         isReadLessTapped: true))
    }
}
extension ViewController: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWithTransitInformation components: [AnyHashable: Any]!) {
        if components != nil {
            if let value = components["ReadMore"] as? String, value == "1" {
                self.readMore(readMore: true)
            }
            if let value = components["ReadLess"] as? String, value == "1" {
                self.readLess(readLess: true)
            }
        }
    }
}
extension TTTAttributedLabel {
    func showTextOnTTTAttributeLable(parameters: TTTAttributeLableParameters) {
        let text = parameters.labelText + parameters.readLessText
        let fullTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
        let attributedFullText = NSMutableAttributedString.init(string: text, attributes: fullTextAttributes)
        let rangeLess = NSString(string: text).range(of: parameters.readLessText, options: String.CompareOptions.caseInsensitive)
        var subStringWithReadMore = ""
        if text.count > parameters.charatersBeforeReadMore {
            let start = String.Index(utf16Offset: 0, in: text)
            let end = String.Index(utf16Offset: parameters.charatersBeforeReadMore, in: text)
            subStringWithReadMore = String(text[start..<end]) + "..." + parameters.readMoreText
        }
        let lessTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
        let attributedLessText = NSMutableAttributedString.init(string: subStringWithReadMore, attributes: lessTextAttributes)
        let nsRange = NSString(string: subStringWithReadMore).range(of: parameters.readMoreText, options: String.CompareOptions.caseInsensitive)
        attributedLessText.addAttributes([NSAttributedString.Key.foregroundColor: parameters.activeLinkColor], range: nsRange)
        self.attributedText = attributedLessText
        self.activeLinkAttributes = [NSAttributedString.Key.foregroundColor: parameters.activeLinkColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
        self.linkAttributes = [NSAttributedString.Key.foregroundColor: parameters.activeLinkColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
        self.addLink(toTransitInformation: ["ReadMore": "1"], with: nsRange)
        if parameters.isReadMoreTapped {
            self.numberOfLines = 0
            self.attributedText = attributedFullText
            self.addLink(toTransitInformation: ["ReadLess": "1"], with: rangeLess)
        }
        if parameters.isReadLessTapped {
            self.numberOfLines = 3
            self.attributedText = attributedLessText
        }
    }
}
