class ShoppingList {
  List<String> items = List<String>();
  List<int> quantities = List<int>();

  ShoppingList(this.items, this.quantities);

  Map toJson() {
    return {'items': this.items, 'quantities': this.quantities};
  }
}
