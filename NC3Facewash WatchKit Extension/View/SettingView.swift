//
//  SettingView.swift
//  NC3Facewash WatchKit Extension
//
//  Created by Local Administrator on 15/07/22.
//


import SwiftUI

struct SettingView: View {
    var colors = ["Red", "Blue", "Green"]
    @State private var selectedTime = "Red"
 //   @Binding var date : Date
    
    var body: some View {
        
        VStack {
            Text("You selected: \(selectedTime)")
           // DatePicker("$se", selection: $date)
            
            Picker("", selection: $selectedTime){
                ForEach(colors, id: \.self) {
                    Text($0)
                }
                
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
