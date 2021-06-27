class BsOrderColumn {
  static const String def = '';
  static const String desc = 'desc';
  static const String asc = 'asc';

  const BsOrderColumn(
      {this.ordered = false, this.orderType = BsOrderColumn.def});

  final bool ordered;

  final String orderType;
}
