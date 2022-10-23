enum PoppedFromPage {
  userVerifyCode,
  selectLocation,
  addPost;
}

class PoppedFromPageArguments {
  PoppedFromPageArguments({
    required this.page,
    this.arguments,
  });

  final PoppedFromPage page;
  final Map<String, dynamic>? arguments;
}
