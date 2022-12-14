//
//  ContentView.swift
//  openAiKit-imageGenerator
//
//  Created by Osman Esad on 14.12.2022.
//

import SwiftUI
import OpenAIKit

// MARK: - Kurulum - Setup
// Buradaki key'i "https://beta.openai.com/account/api-keys" adrsinde üyeliğimizle giriş yaptıktan sonra ilgili bölümden kendimize bir api anahtarı oluşturabiliyoruz.

final class ViewModel: ObservableObject{
    private var openai: OpenAI?
    func setup() {
        openai = OpenAI(Configuration(
            organization: "Personal",
            apiKey: "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" // Buraya kenid api anahtarınızı girin.
        ))
    }
    
    func generateImage(prompt: String) async -> UIImage? {
        guard let openai = openai else {
            return nil
        }
        
        do{
            let params = ImageParameters(
            prompt: prompt,
            resolution: .medium,
            responseFormat: .base64Json
            )
            let result = try await openai.createImage(parameters: params)
            let data = result.data[0].image
            let image = try openai.decodeBase64Image(data)
            return image
            
        }catch {
            print(String(describing: error))
            return nil
        }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    @State var text = ""
    @State var image: UIImage?
    
    var body: some View {
        NavigationView {
            VStack{
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFit()
                        .frame(width: 200, height: 350)
                    
                } else {
                    Image(systemName: "theatermask.and.paintbrush")
                        .resizable()
                        .frame(width: 64, height: 64)
                        .padding()
                    Text("Resmin oluşması için bir tanım girin.")
                }
                Spacer()
                
                TextField("Two frogs on the bench.", text: $text)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(16)
                Button("Generate"){
                    
                }
                .foregroundColor(.black)
                
                      
            }
            .onAppear{
                viewModel.setup()
            }
            .padding()
            .navigationTitle("AI - Image Generator")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
