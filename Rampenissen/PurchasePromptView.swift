import SwiftUI

struct PurchasePromptView: View {
    @Binding var showPurchasePrompt: Bool
    @Binding var isProVersionPurchased: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    showPurchasePrompt = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            
            Spacer(minLength: 0) // Pushes content to the top
            
            Text("Rampenissen PRO")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 25)
            
            Text("Denne appen er laget av en småbarnsfar til andre småbarnsforeldre for å lette litt på det kreative presset i jula. Spander gjerne en kaffe hvis du liker appen og få tilgang på:")
                .padding(.bottom, 15)
            
            VStack(alignment: .leading, spacing: 2) {
                BulletPoint(text: "Daglige påminnelser om rigging av rampenisse.")
                    .padding(.bottom, 15)
                BulletPoint(text: "Savage-mode for de dagene du trenger det ekstra.")
                    .padding(.bottom, 15)
                BulletPoint(text: "Nye rampestreker som krever minimal innsats.")
                    .padding(.bottom, 15)
            }
            
            Text("Har du dårlig råd kan du få det gratis uten å spandere kaffe. God jul!")
                .padding(.bottom, 5)
            .padding(.bottom, 10)
            
            HStack(spacing: 10) {
                Button(action: {
                    // TODO: Initiate purchase process
                    isProVersionPurchased = true
                    showPurchasePrompt = false
                }) {
                    HStack {
                        Image(systemName: "cup.and.saucer")
                        Text("Spander kaffe")
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16) // Adjust the padding to change button size
                    .background(Color.green)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                }
                
                Button(action: {
                    // Unlock PRO content without payment
                    isProVersionPurchased = true
                    showPurchasePrompt = false
                }) {
                    Text("Ikke spander kaffe")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16) // Adjust the padding to change button size
                        .background(Color.red)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
            }
            .frame(maxWidth: .infinity) // Ensures that the buttons expand to half the available width
            
            Spacer(minLength: 0) // Pushes content to the bottom
        }
        .padding()
                .fixedSize(horizontal: false, vertical: true) // Adding fixedSize
                .frame(width: 400, height: 550) // Adjust the frame size here
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
    }
    
    struct BulletPoint: View {
        var text: String
        
        var body: some View {
            HStack(alignment: .top) {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 5, height: 5)
                    .foregroundColor(.blue)
                    .padding(.top, 5)
                Text(text)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct PurchasePromptView_Previews: PreviewProvider {
    static var previews: some View {
        PurchasePromptView(showPurchasePrompt: .constant(true), isProVersionPurchased: .constant(false))
    }
}
