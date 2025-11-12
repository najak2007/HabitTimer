//
//  MainContentView.swift
//  HabitTimer
//
//  Created by najak on 11/12/25.
//

import SwiftUI

struct PostitListView: View {
    let postItName = [
        "Post_IT_Y",
        "Post_IT_B",
    ]
 
    @StateObject private var toDoListViewModel = ToDoListViewModel()
    @State private var isEditMode: Bool = false
    
    let coloredNavAppearance = UINavigationBarAppearance()
    
    init() {
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = UIColor.white
        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
    }
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                List {
                    ForEach(toDoListViewModel.toDoList.indices, id: \.self) { index in
                        ZStack {
                            Image(getImageName(index: index))
                                .resizable()
                            
                            Text(toDoListViewModel.toDoList[index].messageText)
                                .font(.custom("GmarketSansTTFMedium", size: 24))
                                .frame(width: 300, height: 300)
                                .id(toDoListViewModel.toDoList[index].id)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.white)
                        .listRowInsets(EdgeInsets())
                    }
                }
                .scrollContentBackground(.hidden)
                .background(.white)
                .contentMargins(.horizontal, 0)
                .padding(.top, 0)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button(action: {
                    
                }, label: {
                    Text("편집")
                        .font(.custom("GmarketSansTTFMedium", size: 18))
                        .foregroundColor(.black)
                })
                .buttonStyle(PlainButtonStyle())
            )

        }
    }
    
    func getImageName(index: Int) -> String {
        var remaining = index % postItName.count
        
        if remaining >= postItName.count {
            remaining = 0
        }
        return postItName[remaining]
    }
}
