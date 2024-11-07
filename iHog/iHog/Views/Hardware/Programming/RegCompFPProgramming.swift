//
//  RegCompFPProgrammer.swift
//  iHog
//
//  Created by Jay Wilson on 9/25/20.
//

import SwiftUI

struct RegCompFPProgramming: View {
    @EnvironmentObject var osc: OSCHelper
    
    @State private var isEncoderShown: Bool = false
    @State private var isActionShown: Bool = false
    @State private var isFunctionShown: Bool = false
    
    let buttonSize: CGFloat = BASE_BUTTON_SIZE
    
    var body: some View {
        HStack{
            VStack{
                HStack{
                    Button("<-"){
                        pushButton(buttonFunction: .backspace)
                        releaseButton(buttonFunction: .backspace)
                        print("Backspace")
                    }
                    .buttonStyle(FrontPanelButton(width: 65, height: 65*1.25, backgroundColor: .gray))
                    VStack{
                        Button("-"){
                            print("Minus")
                        }.buttonStyle(FrontPanelButton(width: 65, height: (65/2), backgroundColor: .gray))
                            .pressActions {
                                print("Pressed")
                                pushButton(buttonFunction: .minus)
                            } onRelease: {
                                releaseButton(buttonFunction: .minus)
                            }
                        Button("/"){
                            print("Slash")
                        }.buttonStyle(FrontPanelButton(width: 65, height: (65/2), backgroundColor: .gray))
                            .pressActions {
                                print("Pressed")
                                pushButton(buttonFunction: .slash)
                            } onRelease: {
                                releaseButton(buttonFunction: .slash)
                            }
                    }
                    VStack{
                        Button("+"){
                            print("Plus")
                        }.buttonStyle(FrontPanelButton(width: 65, height: (65/2), backgroundColor: .gray))
                            .pressActions {
                                print("Pressed")
                                pushButton(buttonFunction: .plus)
                            } onRelease: {
                                releaseButton(buttonFunction: .plus)
                            }
                        Button("Full"){
                            print("Full")
                        }.buttonStyle(FrontPanelButton(width: 65, height: (65/2), backgroundColor: .gray))
                            .pressActions {
                                print("Pressed")
                                pushButton(buttonFunction: .full)
                            } onRelease: {
                                releaseButton(buttonFunction: .full)
                            }
                    }
                    VStack{
                        Button("Thru"){
                            print("Thru")
                        }.buttonStyle(FrontPanelButton(width: 65, height: (65/2), backgroundColor: .gray))
                            .pressActions {
                                print("Pressed")
                                pushButton(buttonFunction: .thru)
                            } onRelease: {
                                releaseButton(buttonFunction: .thru)
                            }
                        Button("@"){
                            print("@")
                        }.buttonStyle(FrontPanelButton(width: 65, height: (65/2), backgroundColor: .gray))
                            .pressActions {
                                print("Pressed")
                                pushButton(buttonFunction: .at)
                            } onRelease: {
                                releaseButton(buttonFunction: .at)
                            }
                    }
                }
                HBCButtonView()
                // Used to open windows with different sets of buttons in them.
                HStack{
                    // Encoders
                    Button {
                        isEncoderShown.toggle()
                    } label: {
                        Image(systemName: "dial.max")
                    }.buttonStyle(FrontPanelButton(width: 65, backgroundColor: .systemGray3))
                        .sheet(isPresented: $isEncoderShown, content: {
                            EncodersKindsSheet()
                                .environmentObject(osc)
                        })
                    // Object Keys, Action Keys, & utility keys
                    Button {
                        isActionShown.toggle()
                    } label: {
                        Image(systemName: "rectangle.3.offgrid")
                    }.buttonStyle(FrontPanelButton(width: 65, backgroundColor: .systemGray3))
                        .sheet(isPresented: $isActionShown) {
                            isActionShown = false
                        } content: {
                            ObjActUtilKeys().environmentObject(osc)
                        }
                    // Function keys
                    Button {
                        isFunctionShown.toggle()
                    } label: {
                        Image(systemName: "square.grid.3x3")
                    }.buttonStyle(FrontPanelButton(width: 65, backgroundColor: .systemGray3))
                        .sheet(isPresented: $isFunctionShown) {
                            isFunctionShown = false
                        } content: {
                            FunctionKeySheet().environmentObject(osc)
                        }
                }
                SelectButtonView()
            }
            Spacer()
            // NUMBER PAD
            VStack(spacing: 1){
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
                    .buttonStyle(FrontPanelButton(width: buttonSize, backgroundColor: .gray))
                    .pressActions {
                        pushButton(buttonFunction: .enter)
                    } onRelease: {
                        releaseButton(buttonFunction: .enter)
                    }
                }
            }
        }
        .padding(.horizontal)
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

struct RegCompFPProgrammer_Previews: PreviewProvider {
    static var previews: some View {
        RegCompFPProgramming()
    }
}
