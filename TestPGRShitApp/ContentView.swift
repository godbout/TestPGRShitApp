//
//  ContentView.swift
//  TestPGRShitApp
//
//  Created by Guillaume Leclerc on 21/12/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Form {
            Button("get AX info") {
                let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
                _ = AXIsProcessTrustedWithOptions(options)
                
                sleep(3)
                
                let axSystemWideElement = AXUIElementCreateSystemWide()
                var axError: AXError!
                
                var axFocusedElement: AnyObject?
                axError = AXUIElementCopyAttributeValue(axSystemWideElement, kAXFocusedUIElementAttribute as CFString, &axFocusedElement)
                guard axError == .success else {
                    print("can't get system wide element")
                    
                    return                    
                }
                
                var axSelectedTextRange: AnyObject?
                axError = AXUIElementCopyAttributeValue(axFocusedElement as! AXUIElement, kAXSelectedTextRangeAttribute as CFString, &axSelectedTextRange)
                guard axError == .success else {
                    print("can't get text range")
                    
                    return
                }
                
                var selectedTextRange = CFRange()
                AXValueGetValue(axSelectedTextRange as! AXValue, .cfRange, &selectedTextRange)
                var currentLine: AnyObject?
                axError = AXUIElementCopyParameterizedAttributeValue(axFocusedElement as! AXUIElement, kAXLineForIndexParameterizedAttribute as CFString, selectedTextRange.location as CFTypeRef, &currentLine)
                guard axError == .success else {
                    print("can't get current line")
                    
                    return
                }
                
                var lineRangeValue: AnyObject?
                axError = AXUIElementCopyParameterizedAttributeValue(axFocusedElement as! AXUIElement, kAXRangeForLineParameterizedAttribute as CFString, currentLine as CFTypeRef, &lineRangeValue)
                guard axError == .success else {
                    print("can't get line range")
                    
                    return
                }
                
                var lineRange = CFRange()
                AXValueGetValue(lineRangeValue as! AXValue, .cfRange, &lineRange)
                
                print(lineRange)
            }
            .padding()
            
            Button("set AX info") {
                let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
                _ = AXIsProcessTrustedWithOptions(options)
                
                sleep(3)
                
                let axSystemWideElement = AXUIElementCreateSystemWide()
                var axError: AXError!
                
                var axFocusedElement: AnyObject?
                axError =  AXUIElementCopyAttributeValue(axSystemWideElement, kAXFocusedUIElementAttribute as CFString, &axFocusedElement)
                guard axError == .success else {
                    print("can't get system wide element")
                    
                    return                    
                }
                
                var selectedTextRange = CFRange()
                selectedTextRange.location = 6
                selectedTextRange.length = 9
                let newValue = AXValueCreate(.cfRange, &selectedTextRange)
                axError = AXUIElementSetAttributeValue(axFocusedElement as! AXUIElement, kAXSelectedTextRangeAttribute as CFString, newValue!)
                guard axError == .success else {
                    print("can't set new location and selected text")
                    
                    return
                }
                
                let selectedText = "sixty-nine LMAO"
                axError = AXUIElementSetAttributeValue(axFocusedElement as! AXUIElement, kAXSelectedTextAttribute as CFString, selectedText as CFTypeRef)
                guard axError == .success else {
                    print("can't update selected text")
                    
                    return
                }
            }
            .padding()
        }
        .frame(width: 200, height: 200, alignment: .center)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
