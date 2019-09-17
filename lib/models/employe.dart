class Employe {
  final String name;
  final String image;
  bool isChecked;

  Employe({this.name = 'Nameless !!', this.image, this.isChecked = false});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
    };
  }

  @override
  String toString() {
    return 'Employee{name: $name}';
  }
}
