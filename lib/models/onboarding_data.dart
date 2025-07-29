class OnboardingData {
  final String title;
  final String description;
  final String imagePath;

  OnboardingData({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

List<OnboardingData> onboardingPages = [
  OnboardingData(
    title: "",
    description: "",
    imagePath: "assets/images/onboarding1.png",
  ),
  OnboardingData(
    title: "Temukan Dunia Membaca & Inspirasi Baru",
    description: "Jelajahi berbagai artikel, resensi buku, dan konten yang memberkaya wawasanmu setiap hari.",
    imagePath: "assets/images/onboarding2.png",
  ),
  OnboardingData(
    title: "Belajar Bersama & Tingkatkan Minat Baca",
    description: "Gabung dengan komunitas literasi, diskusikan ide, dan temukan rekomendasi bacaan menarik.",
    imagePath: "assets/images/onboarding3.png",
  ),
  OnboardingData(
    title: "Nikmati Literasi Secara Interaktif",
    description: "Dapatkan pengalaman membaca yang menyenangkan dengan artikel pilihan, fitur resensi, dan video edukasi.",
    imagePath: "assets/images/onboarding4.png",
  ),
];