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
                        .frame(width: 250, height: 250)
                        .padding()
                        .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.green, lineWidth: 4))
                                .shadow(radius: 10)
                                
                    
                } else {
                    Image(systemName: "theatermask.and.paintbrush")
                        .resizable()
                        .frame(width: 64, height: 64)
                        .padding()
                        .foregroundColor(.gray)
                    Text("Enter a description for AI.")
                }
                Spacer()
                
                TextField("Two frogs on the bench.", text: $text)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .fontWeight(.bold)
                Button("Generate"){
                    if !text.trimmingCharacters(in: .whitespaces).isEmpty {
                        Task {
                            let result = await viewModel.generateImage(prompt: text)
                            if result == nil {
                                print("Failed!")
                                
                            }
                            
                            self.image = result
                            
                        }
                    }
                }
                .foregroundColor(.black)
                .padding()
                .fontWeight(.bold)
                
                      
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
