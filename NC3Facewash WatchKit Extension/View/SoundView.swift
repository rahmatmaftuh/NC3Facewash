//
//  SoundView.swift
//  NC3Facewash WatchKit Extension
//
//  Created by Local Administrator on 15/07/22.
//


import SwiftUI

struct SoundView: View {
    @State private var isStarted = false
    @State var isPlayingGuide = false
    
    
    var body: some View {
        NavigationView {
            
        
            VStack{
                NavigationLink("", destination: TimerView(), isActive: $isStarted)
                ZStack{
                    Circle()
                        .foregroundColor(Color("startColor"))
                    Text("START")
                        .foregroundColor(Color.black)
                        .font(.system(size: 19))
                        .bold()
                        .italic()



                }
                .onTapGesture {
                    isStarted.toggle()
                    isPlayingGuide.toggle()
                    if isPlayingGuide {
                        AVService.shared.playMusic()
                    }
                    
            }

//                NavigationLink(destination: TimerView(), label: {
//                    ZStack{
//                        Circle()
//                        Text("START")
//                            .foregroundColor(.black)
//                    }
//                })
            .navigationTitle("Acnecare")
            .navigationBarTitleDisplayMode(.inline)
            //belum bisa warnanya
            .foregroundColor(Color("navColor"))
            
            }
            
            
           
        }
}
}

struct SoundView_Previews: PreviewProvider {
    static var previews: some View {
        SoundView()
    }
}


