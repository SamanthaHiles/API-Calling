//
//  ContentView.swift
//  API Calling
//
//  Created by Samantha Hiles on 3/6/25.
//

import SwiftUI


struct Book: Identifiable, Decodable {
    let key: String
    let title: String
    let author_name: [String]?
    let first_publish_year: Int?
    //Declaring variables for the information and API

    var id: String { key }
    //Allowing the API Key
}

struct ContentView: View {
    @State private var books: [Book] = []
    //Book= Array

    var body: some View {
        NavigationView {
            List(books) { book in
                NavigationLink(destination: BookDetailView(book: book)) {
                    //Link to API information
                    VStack(alignment: .leading) {
                        Text(book.title)
                            .font(.headline)
                        //Takes title from API
                        //Font inforation
                        Text(book.author_name?.joined(separator: ", ") ?? "Unknown Author")
                        //If unknown author, app says unknown author
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        //Font information
                        //First screen author information
                    }
                }
            }
            .navigationTitle("1800's Romance Books")
            //Name of first navigation view
            .task {
                await fetchBooks()
                //Gets book titles
            }
        }
    }
    //First View of book information, Title and Author

    func fetchBooks() async {
        let urlString = "https://openlibrary.org/search.json?q=romance&limit=10"
        //Full API link
        guard let url = URL(string: urlString) else { return }
        //Return URL to app

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            //Takes data from the API
            let response = try JSONDecoder().decode(SearchResult.self, from: data)
            //Load data into the app
            books = response.docs
            //API format
        } catch {
            print("Error fetching books: \(error)")
            //If API doesnt load, error message
        }
    }
}

struct BookDetailView: View {
    //Second View
    let book: Book

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(book.title)
            //Title information from API
                .font(.largeTitle)
                .bold()
            //Font information
            //Book title
            Text("By \(book.author_name?.joined(separator: ", ") ?? "Unknown Author")")
            //Author from API, if unknown, app says Unknown Author
                .font(.title2)
                .foregroundColor(.secondary)
            //Font Information
            //Book author
            if let year = book.first_publish_year {
                Text("First Published: \(year)")
                //Publishh date from API
                    .font(.body)
                    .foregroundColor(.gray)
                //Font information
                // Book publish date
            }
            Spacer()
        }
        .padding()
        .navigationTitle(book.title)
        //Navigation name is the title of the book
    }
}

struct SearchResult: Decodable {
    //Makes it able to be viewed in Swift UI
    let docs: [Book]
}

#Preview {
    ContentView()
}


