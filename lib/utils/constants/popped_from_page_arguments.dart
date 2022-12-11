enum PoppedFromPage {
  userVerifyCode,
  showLocation,
  storeLocation,
  selectLocation,
  addPost,
  updateUser;
}

class PoppedFromPageArguments {
  PoppedFromPageArguments({
    required this.page,
    this.arguments,
  });

  final PoppedFromPage page;
  final Map<String, dynamic>? arguments;
}
