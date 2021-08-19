class BsDatatableController {
  BsDatatableController({
    this.draw = 1,
    this.start = 0,
    this.length = 10,
    this.searchValue = '',
    this.searchRegex = 'false',
    this.orders = const [],
    this.columns = const [],
  });

  int draw;

  int start;

  int length;

  String searchValue;

  String searchRegex;

  List<Map<String, String>> orders;

  List<Map<String, String>> columns;

  Function? _reload;

  /// Before processing serverSide requests, datatable
  /// configuration must be converted to json
  Map<String, String> toJson() {
    Map<String, String> json = Map<String, String>();
    json.addAll({'draw': draw.toString()});
    json.addAll({'start': start.toString()});
    json.addAll({'length': length.toString()});
    json.addAll({'search[value]': searchValue});
    json.addAll({'search[regex]': searchRegex});

    columns.forEach((column) {
      json.addAll({
        'columns[${columns.indexOf(column)}][data]': column['data'].toString()
      });
      json.addAll({
        'columns[${columns.indexOf(column)}][name]': column['name'].toString()
      });
      json.addAll({
        'columns[${columns.indexOf(column)}][orderable]':
            column['searchable'] != null
                ? column['orderable'].toString()
                : 'false'
      });
      json.addAll({
        'columns[${columns.indexOf(column)}][searchable]':
            column['searchable'] != null
                ? column['searchable'].toString()
                : 'false'
      });
      json.addAll({
        'columns[${columns.indexOf(column)}][search][value]':
            column['searchvalue'] != null
                ? column['searchvalue'].toString()
                : ''
      });
      json.addAll({
        'columns[${columns.indexOf(column)}][search][regex]':
            column['searchregex'] != null
                ? column['searchregex'].toString()
                : 'false'
      });
    });

    orders.forEach((order) {
      json.addAll({
        'order[${orders.indexOf(order)}][column]': order['column'].toString()
      });
      json.addAll({
        'order[${orders.indexOf(order)}][dir]': order['dir'].toString()
      });
    });

    return json;
  }

  /// Reloading data with create serverSide reqeust
  void reload({bool load = true}) {
    if(_reload == null)
      print('Failed to reload data: Undefined event reload listener');

    else
      _reload!(load);
  }

  /// Set reload listener function
  void onReloadListener(Function(bool load) function) {
    _reload = function;
  }
}
