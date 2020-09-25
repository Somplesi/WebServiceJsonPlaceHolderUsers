//
//  ContentView.swift
//  WebServiceJsonPlaceHolderUsers
//
//  Created by Rodolphe DUPUY on 25/09/2020.
//

import SwiftUI

struct ContentView: View {
    @State var userList: [User] = []
    @State var isLoading = false
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Chargement des utilisateurs")
            } else {
                List(userList) { user in
                    Text(user.name)
                }.padding(.all, 10)
            }
        }.onAppear { loadUserList() } // Lancement de la fonction
    }
    func loadUserList() {
        isLoading = true
        guard let userListApiUrl = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        let urlSession = URLSession.shared
        // Preparer la Requête
        var request = URLRequest(url: userListApiUrl)
        request.httpMethod = "GET"
        // Créer la Tâche
        let dataTask = urlSession.dataTask(with: request) {
            ( data, response, error ) in
            guard error == nil,
                  let httpResponse = response as? HTTPURLResponse,  // si connexion ok
                  httpResponse.statusCode >= 200 && httpResponse.statusCode < 300, // si connexion JSON ok
                  let userListJsonData = data, // Si récupération données JSON ok
                  let downloadedUserList = try? JSONDecoder().decode([User].self, from: userListJsonData) else { return } // et si décodage JSON ok
                    DispatchQueue.main.async { // alors lancer traitement sur le thread principal pour l'affichage
                        self.userList = downloadedUserList
                        isLoading = false
            }
        }
        // Lancer la récupération des données
        dataTask.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
