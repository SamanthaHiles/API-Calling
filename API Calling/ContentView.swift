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

    var id: String { key }
}

struct ContentView: View {
    @State private var books: [Book] = []

    var body: some View {
        NavigationView {
            List(books) { book in
                NavigationLink(destination: BookDetailView(book: book)) {
                    VStack(alignment: .leading) {
                        Text(book.title)
                            .font(.headline)
                        Text(book.author_name?.joined(separator: ", ") ?? "Unknown Author")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Trending Romance Books")
            .task {
                await fetchBooks()
            }
        }
    }

    func fetchBooks() async {
        let urlString = "https://openlibrary.org/search.json?q=romance&limit=10"
        guard let url = URL(string: urlString) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(SearchResult.self, from: data)
            books = response.docs
        } catch {
            print("Error fetching books: \(error)")
        }
    }
}

struct BookDetailView: View {
    let book: Book

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(book.title)
                .font(.largeTitle)
                .bold()
            Text("By \(book.author_name?.joined(separator: ", ") ?? "Unknown Author")")
                .font(.title2)
                .foregroundColor(.secondary)
            if let year = book.first_publish_year {
                Text("First Published: \(year)")
                    .font(.body)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .navigationTitle(book.title)
    }
}

struct SearchResult: Decodable {
    let docs: [Book]
}

#Preview {
    ContentView()
}


