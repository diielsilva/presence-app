abstract class Model {
  int? id;

  bool wasSuccessfullySaved() {
    return id != null && id! > 0;
  }

  bool canSave();
}
