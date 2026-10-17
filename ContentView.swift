import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var selectedTab = 0
    @State private var tasbihCount = 0
    @State private var selectedIcon = "moon"

    var body: some View {
        TabView(selection: $selectedTab) {
            // علامة تبويب الرئيسية (الأذكار)
            NavigationView {
                ScrollView {
                    VStack(spacing: 16) {
                        // بطاقة ذكر اليوم الترحيبية
                        VStack(alignment: .leading, spacing: 8) {
                            Text("ذكر اليوم")
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(8)
                            
                            Text("سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ")
                                .font(.custom("Aref Ruqaa", size: 22))
                                .multilineTextAlignment(.leading)
                            
                            Text("كلمتان خفيفتان على اللسان، ثقيلتان في الميزان")
                                .font(.subheadline)
                                .opacity(0.85)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .foregroundColor(.white)
                        .cornerRadius(22)
                        .padding(.horizontal)

                        // قسم القبلة السريع
                        VStack(spacing: 8) {
                            HStack {
                                Image(systemName: "safari")
                                    .font(.title2)
                                Text("اتجاه القبلة الحي")
                                    .font(.headline)
                                Spacer()
                            }
                            
                            if let location = locationManager.userLocation {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("خط العرض: \(location.latitude, specifier: "%.2f")")
                                        Text("خط الطول: \(location.longitude, specifier: "%.2f")")
                                    }
                                    Spacer()
                                    Text("\(locationManager.qiblaBearing, specifier: "%.1f")°")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(.green)
                                }
                            } else {
                                Text("جارٍ تحديد الموقع عبر GPS...")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(22)
                        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                        .padding(.horizontal)
                    }
                    .padding(.top)
                }
                .navigationTitle("الأذكار")
            }
            .tag(0)
            .tabItem {
                Label("الرئيسية", systemImage: "house.fill")
            }

            // علامة تبويب السبحة
            VStack(spacing: 24) {
                Text("السبحة الذكية")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Button(action: {
                    tasbihCount += 1
                }) {
                    ZStack {
                        Circle()
                            .stroke(Color.blue.opacity(0.3), lineWidth: 12)
                            .frame(width: 220, height: 220)
                        
                        Circle()
                            .trim(from: 0.0, to: CGFloat(tasbihCount % 33) / 33.0)
                            .stroke(Color.blue, lineWidth: 12)
                            .frame(width: 220, height: 220)
                            .rotationEffect(.degrees(-90))
                            .animation(.easeOut, value: tasbihCount)

                        VStack {
                            Text("\(tasbihCount)")
                                .font(.system(size: 64, weight: .bold))
                            Text("من ٣٣")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Button("تصفير العدّاد") {
                    tasbihCount = 0
                }
                .buttonStyle(.bordered)
            }
            .tag(1)
            .tabItem {
                Label("السبحة", systemImage: "circle.grid.hex.fill")
            }

            // علامة تبويب الإعدادات (مع مبدل الأيقونات)
            NavigationView {
                Form {
                    Section(header: Text("أيقونة التطبيق")) {
                        Picker("اختر الأيقونة", selection: $selectedIcon) {
                            Text("الهلال (الأصلية)").tag("moon")
                            Text("المسبحة").tag("beads")
                            Text("القبة").tag("dome")
                        }
                        .onChange(of: selectedIcon) { newIcon in
                            IconManager.changeAppIcon(to: newIcon == "moon" ? nil : "AppIcon-\(newIcon.capitalized)")
                        }
                    }
                    
                    Section(header: Text("الإشعارات")) {
                        Button("تفعيل الإشعارات اليومية") {
                            NotificationManager.shared.requestAuthorization()
                        }
                    }
                }
                .navigationTitle("الإعدادات")
            }
            .tag(2)
            .tabItem {
                Label("الإعدادات", systemImage: "gearshape.fill")
            }
        }
        .onAppear {
            NotificationManager.shared.requestAuthorization()
        }
    }
}