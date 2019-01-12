final List<Profile> demoProfiles = [
  Profile(photos: [
    'assets/foto_1.jpg',
    'assets/foto_2.jpg',
    'assets/foto_3.jpg',
    'assets/foto_4.jpg',
    'assets/foto_5.jpeg',
  ], name: 'Something Special', bio: 'This is the person you want'),
  Profile(photos: [
    'assets/foto_5.jpeg',
    'assets/foto_4.jpg',
    'assets/foto_3.jpg',
    'assets/foto_2.jpg',
    'assets/foto_1.jpg',
  ], name: 'Something Special', bio: 'This is the person you want'),
];

class Profile {
  final List<String> photos;
  final String name;
  final String bio;

  Profile({this.photos, this.name, this.bio});
}
