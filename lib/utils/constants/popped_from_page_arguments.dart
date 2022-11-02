enum PoppedFromPage {
  userVerifyCode,
  showLocation,
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
