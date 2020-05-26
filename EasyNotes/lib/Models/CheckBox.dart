
class CheckBox {

  String title;
  bool checked;

  CheckBox(this.title,this.checked);

  @override
  String toString() {
    return "[${this.title} (${this.checked ? "✔️" : "❌"})]";
  }
}