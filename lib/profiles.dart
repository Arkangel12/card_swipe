final List<Profiles> demoProfile =[
  Profiles(
    photos: [
      'assets/foto_1.jpg',
      'assets/foto_2.jpg',
      'assets/foto_3.jpg',
      'assets/foto_4.jpg',
      'assets/foto_5.jpeg',
    ],
    name: 'Someone Special',
    bio: 'This is the one you want!',
  ),
  Profiles(
    photos: [
      'assets/foto_5.jpeg',
      'assets/foto_4.jpg',
      'assets/foto_3.jpg',
      'assets/foto_2.jpg',
      'assets/foto_1.jpg',
    ],
    name: 'Someone Gross',
    bio: 'You better go left!',
  ),
];

class Profiles{
  final List<String> photos;
  final String name;
  final String bio;

  Profiles({this.photos, this.name, this.bio});
}