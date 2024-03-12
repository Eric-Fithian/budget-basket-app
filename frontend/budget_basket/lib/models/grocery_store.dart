enum GroceryStore {
  Walmart,
  Kroger,
  KingSoopers,
  Safeway,
  WholeFoods,
  TraderJoes,
  Publix,
  Aldi,
  Target,
  Costco,
  Meijer,
}

String groceryStoreToString(GroceryStore store) {
  return store
      .toString()
      .split('.')
      .last
      .replaceAll(RegExp(r'(?<=[a-z])(?=[A-Z])'), ' ');
}
