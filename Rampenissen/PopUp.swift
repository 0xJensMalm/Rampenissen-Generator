import SwiftUI

struct PopUpView: View {
    var title: String
    var message: String
    var closeAction: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image("PopUp")
                .resizable()
                .scaledToFit()
                .frame(height: 100) // Adjust size as needed

            Text(title).font(.headline)
            Text(message)
            
            Button("Close", action: closeAction)
                .foregroundColor(.blue)
                .padding()
        }
        .padding()
        .frame(width: 300, height: 300) // Adjust size as needed
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}
