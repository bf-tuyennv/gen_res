extension ListExtend on List {
  bool containPath(String path) {
    //Two path assets/images/ and assets/images are the same
    final String otherPath = path.endsWith('/') ? path.substring(0, path.length - 1) : '$path/';
    return contains(path) || contains(otherPath);
  }
}
