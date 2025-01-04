import SwiftUI

struct CategoryListView: View {
    @StateObject private var viewModel = CategoryListViewModel()
    @State private var isNavigating = false

    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        NavigationView {
            VStack( spacing: 20) {
                if !viewModel.latestCategories.isEmpty {
                    HStack {
                        Text("Ostatnie").bold()
                        Spacer()
                    }.padding(.top, 20)
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 20) {
                            ForEach(viewModel.latestCategories) { category in
                                NavigationLink(
                                    destination: CategoryView(
                                        categoryId: category.id, isNavigating: $isNavigating
                                    ).navigationBarBackButtonHidden(isNavigating)
                                ) {
                                    CategoryCard(
                                        title: category.name, iconName: category.icon)
                                }
                            }
                        }
                        
                    }
                }
                
                HStack {
                    Text("Wszystkie").bold()
                    Spacer()
                }
                LazyVGrid(columns: [ GridItem(.adaptive(minimum: 160), alignment: .leading)],spacing: 16) {
                    ForEach(viewModel.allCategories) { category in
                        NavigationLink(
                            destination: CategoryView(
                                categoryId: category.id, isNavigating: $isNavigating
                            ).navigationBarBackButtonHidden(isNavigating)
                        ) {
                            CategoryCard(
                                title: category.name, iconName: category.icon
                            )
                        }
                    }
                }
                
                
                Spacer()
            }.padding(.horizontal)
            .navigationTitle("Rozpocznij quiz").navigationBarBackButtonHidden(
                true)
        }
    }
}

#Preview {
    CategoryListView()
}
