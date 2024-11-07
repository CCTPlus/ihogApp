//
//  NumericKeypadView.swift
//  iHog
//
//  Created by Jay Wilson on 9/24/20.
//

import SwiftUI

struct NumericKeypadView: View {
    @EnvironmentObject var osc: OSCHelper
    var buttonSize: CGFloat = BASE_BUTTON_SIZE
    
    var body: some View {
        VStack(spacing: 1){
            HStack(spacing: 1){
                Button("<-"){
                    print("Backspace")
                }.buttonStyle(FrontPanelButton(width: buttonSize, backgroundColor: .gray))
                    .pressActions {
                        print("Pressed")
                        pushButton(buttonFunction: .backspace)
                    } onRelease: {
                        print("Releasing")
                        releaseButton(buttonFunction: .backspace)
                    }
                Button("/"){
                    print("Slash")
                }.buttonStyle(FrontPanelButton(width: buttonSize, backgroundColor: .gray))
                    .pressActions {
                        print("Pressed")
                        pushButton(buttonFunction: .slash)
                    } onRelease: {
                        print("Releasing")
                        releaseButton(buttonFunction: .slash)
                    }
                Button("-"){
                    print("Minus")
                }.buttonStyle(FrontPanelButton(width: buttonSize, backgroundColor: .gray))
                    .pressActions {
                        print("Pressed")
                        pushButton(buttonFunction: .minus)
                    } onRelease: {
                        releaseButton(buttonFunction: .minus)
                    }
                Button("+"){
                    print("plus")
                }.buttonStyle(FrontPanelButton(width: buttonSize, backgroundColor: .gray))
                    .pressActions {
                        print("Pressed")
                        pushButton(buttonFunction: .plus)
                    } onRelease: {
                        print("Releasing")
                        releaseButton(buttonFunction: .plus)
                    }
            }
            HStack(spacing: 1){
                Button("7"){print(7)}
                .buttonStyle(FrontPanelButton(width: buttonSize, backgroundColor: .gray))
                .pressActions {
                    pushButton(number: "seven")
                } onRelease: {
                    releaseButton(number: "seven")
                }
                
                Button("8"){print(8)}
                .buttonStyle(FrontPanelButton(width: buttonSize, backgroundColor: .gray))
                .pressActions {
                    pushButton(number: "eight")
                } onRelease: {
                    releaseButton(number: "eight")
                }
                Button("9"){print(9)}
                .buttonStyle(FrontPanelButton(width: buttonSize, backgroundColor: .gray))
                .pressActions {
                    pushButton(number: "nine")
                } onRelease: {
                    releaseButton(number: "nine")
                }
                Button("thru"){print("thru")}
                .buttonStyle(FrontPanelButton(width: buttonSize, backgroundColor: .gray))
                .pressActions {
                    pushButton(buttonFunction: .thru)
                } onRelease: {
                    releaseButton(buttonFunction: .thru)
                }
            }
            HStack(spacing: 1){
                Button("4"){print(4)}
                .buttonStyle(FrontPanelButton(width: buttonSize, backgroundColor: .gray))
                .pressActions {
                    pushButton(number: "four")
                } onRelease: {
                    releaseButton(number: "four")
                }
                
                Button("5"){print(5)}
                .buttonStyle(FrontPanelButton(width: buttonSize, backgroundColor: .gray))
                .pressActions {
                    pushButton(number: "five")
                } onRelease: {
                    releaseButton(number: "five")
                }
                Button("6"){print(6)}
                .buttonStyle(FrontPanelButton(width: buttonSize, backgroundColor: .gray))
                .pressActions {
                    pushButton(number: "six")
                } onRelease: {
                    releaseButton(number: "six")
                }
                Button("full"){print("full")}
                .buttonStyle(FrontPanelButton(width: buttonSize, backgroundColor: .gray))
                .pressActions {
                    pushButton(buttonFunction: .full)
                } onRelease: {
                    releaseButton(buttonFunction: .full)
                }
            }
            HStack(spacing: 1){
                Button("1"){print(1)}
                .buttonStyle(FrontPanelButton(width: buttonSize, backgroundColor: .gray))
                .pressActions {
                    pushButton(number: "one")
                } onRelease: {
                    releaseButton(number: "one")
                }
                
                Button("2"){print(2)}
                .buttonStyle(FrontPanelButton(width: buttonSize, backgroundColor: .gray))
                .pressActions {
                    pushButton(number: "two")
                } onRelease: {
                    releaseButton(number: "two")
                }
                Button("3"){print(3)}
                .buttonStyle(FrontPanelButton(width: buttonSize, backgroundColor: .gray))
                .pressActions {
                    pushButton(number: "three")
                } onRelease: {
                    releaseButton(number: "three")
                }
                Button("@"){print("@")}
                .buttonStyle(FrontPanelButton(width: buttonSize, backgroundColor: .gray))
                .pressActions {
                    pushButton(buttonFunction: .at)
                } onRelease: {
                    releaseButton(buttonFunction: .at)
                }
            }
            HStack(spacing: 1){
                Button("0"){print(0)}
                .buttonStyle(FrontPanelButton(width: buttonSize, backgroundColor: .gray))
                .pressActions {
                    pushButton(number: "zero")
                } onRelease: {
                    releaseButton(number: "zero")
                }
                
                Button("."){print(".")}
                .buttonStyle(FrontPanelButton(width: buttonSize, backgroundColor: .gray))
                .pressActions {
                    pushButton(buttonFunction: .period)
                } onRelease: {
                    releaseButton(buttonFunction: .period)
                }
                Button("Enter"){print("Enter")}
                .buttonStyle(FrontPanelButton(width: ((buttonSize*2)+10), backgroundColor: .gray))
                .pressActions {
                    pushButton(buttonFunction: .enter)
                } onRelease: {
                    releaseButton(buttonFunction: .enter)
                }
            }
        }
        .padding(.bottom)
    }
    
    // MARK: Used for all buttons not a number key
    func pushButton(buttonFunction: ButtonFunctionNames){
        osc.pushFrontPanelButton(button: buttonFunction.rawValue)
    }
    
    // MARK: Only used for number keys
    func pushButton(number: String){
        osc.pushFrontPanelButton(button: number)
    }
    
    // MARK: RELEASE BUTTONS
    
    func releaseButton(buttonFunction: ButtonFunctionNames){
        osc.releaseFrontPanelButton(button: buttonFunction.rawValue)
    }
    
    // MARK: Only used for number keys
    func releaseButton(number: String){
        osc.releaseFrontPanelButton(button: number)
    }
}

struct NumericKeypadView_Previews: PreviewProvider {
    static var previews: some View {
        NumericKeypadView()
    }
}
