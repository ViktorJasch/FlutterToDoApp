class AppData {
  static final AppData _appData = new AppData._internal();

  int doneSteps = 0;
  int totalSteps = 0;
  factory AppData() {
    return _appData;
  }
  AppData._internal();
}

final appData = AppData();
