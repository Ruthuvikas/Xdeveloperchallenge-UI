
import SwiftUI

struct ContentView: View {
    @State private var tweetText: String = ""
    @State private var twitterHandles: [String] = []  // Array to store multiple Twitter handles
    let trendingTweets = ["Just discovered a new planet!", "SwiftUI makes UI development so easy!", "Did anyone catch that incredible game last night?"]

    var body: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 40)  // Provides top spacing for aesthetics

            Text("X Assist")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
            
            // Display top trending tweets
            VStack(spacing: 10) {
                Text("Top Positive Tweets Today")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .padding(.bottom, 5)

                ForEach(trendingTweets, id: \.self) { tweet in
                    Text(tweet)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(Color.white)
                }
            }
            .padding(.horizontal)

            // Text field for entering tweet with custom placeholder
            ZStack(alignment: .leading) {
                if tweetText.isEmpty {
                    Text("Enter your tweet here...")
                        .foregroundColor(Color.white.opacity(0.7))
                        .padding(.horizontal, 30)
                        .padding(.vertical, 14)
                }
                TextField("", text: $tweetText)
                    .foregroundColor(Color.white)
                    .padding()
                    .frame(height: 50)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            // Submit button with blue background
            Button(action: submitTweet) {
                Text("Submit Tweet")
                    .fontWeight(.semibold)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(10)
                    .foregroundColor(Color.white)
            }
            .padding(.horizontal)
            .shadow(radius: 2)

            // Display Twitter handles
            if !twitterHandles.isEmpty {
                VStack(spacing: 10) {
                    Text("Best X handles for you!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(.bottom, 5)
                    HStack {
                        ForEach(twitterHandles, id: \.self) { handle in
                            Text(handle)
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                                .padding([.leading, .bottom], 10)
                        }
                    }
                }
            }

            // Refresh icon button with a blue icon
            Button(action: clearHandles) {
                Image(systemName: "arrow.clockwise")
                    .font(.title)
                    .foregroundColor(Color.blue)
            }
            .padding(.top, 5)

            Spacer()
        }
        .padding()
        .background(Color.black) // Set the background to black
        .edgesIgnoringSafeArea(.all) // Ignore safe areas to extend the background color
    }

    func submitTweet() {
        let url = URL(string: "http://127.0.0.1:5000/submit_tweet")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: String] = ["tweetText": tweetText]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let data = data else { return }
            if let response = try? JSONDecoder().decode(ServerResponse.self, from: data) {
                DispatchQueue.main.async {
                    // Update the handles based on the response; assuming the response has them
                    self.twitterHandles = ["@newhandle1", "@newhandle2", "@newhandle3"] // Example response handles
                    print("Server response: \(response.message)")
                }
            }
        }.resume()
        
        tweetText = ""  // Clear the text field after submitting
    }

    func clearHandles() {
        twitterHandles = []  // Clear the stored Twitter handles
    }
    
    struct ServerResponse: Codable {
        let status: String
        let message: String
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

