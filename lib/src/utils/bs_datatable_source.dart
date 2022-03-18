import 'package:bs_flutter_datatable/bs_flutter_datatable.dart';

abstract class BsDatatableSource {
  BsDatatableSource(
      {List data = const [],
      BsDatatableResponse? response,
      BsDatatableController? controller}) {
    if (response == null) response = BsDatatableResponse(data: List.from([]));

    _response = response;
    _response.data.insertAll(0, data);

    if (controller == null) controller = BsDatatableController();

    _controller = controller;
  }

  /// Variable to handle response from jQuery datatable.net
  BsDatatableResponse _response = BsDatatableResponse(data: List.from([]));

  /// Variable to save datatable config
  BsDatatableController _controller = BsDatatableController();

  BsDatatableResponse get response => _response;
  set response(BsDatatableResponse value) => _response = value;

  BsDatatableController get controller => _controller;
  set controller(BsDatatableController value) => _controller = controller;

  /// Get count data from [response]
  int get countData => response.countData;

  /// Get count filtered data from [response]
  int get countFiltered => response.countFiltered;

  /// Get count data in page using [response].data length
  int get countDataPage => response.data.length;

  /// Set row widgets
  BsDataRow getRow(int index);

  void update(List? values) {
    if (values != null) response.data = values;

    controller.reload(load: false);
  }

  void clear() {
    response.data.clear();

    controller.reload(load: false);
  }

  void insert(int index, dynamic element) {
    response.data.insert(index, element);
    controller.reload(load: false);
  }

  void add(dynamic value) {
    response.data.add(value);
    controller.reload(load: false);
  }

  dynamic get(int index) {
    if (response.data[index] != null) return response.data[index];

    return null;
  }

  void put(int index, dynamic value) {
    if (response.data[index] != null) response.data[index] = value;

    controller.reload(load: false);
  }

  void removeAt(int index) {
    response.data.removeAt(index);
    controller.reload(load: false);
  }

  void remove(dynamic value) {
    response.data.remove(value);
    controller.reload(load: false);
  }

  void addAll(List values) {
    response.data.addAll(values);
    controller.reload(load: false);
  }

  void insertAll(int index, dynamic iterable) {
    response.data.insertAll(index, iterable);
    controller.reload(load: false);
  }

  void reload() {
    List currentDataFiltered = response.data.where((data) {
      bool matched = true;
      for (int i = 0; i < controller.columns.length; i++) {
        bool datamatched = false;

        String value = controller.searchValue.toLowerCase().trim();
        Map<String, String> column = controller.columns[i];

        if (column['searchable'] == 'true' && !value.isEmpty) {
          if (data[column['name']] != null) {
            String field = data[column['name']].toString().toLowerCase().trim();

            if (field.contains(value)) {
              datamatched = true;
            }
          }

          matched = datamatched;

          if (datamatched) break;
        }
      }

      return matched;
    }).toList();

    List currentData = currentDataFiltered
        .skip(controller.start)
        .take(controller.length)
        .toList();
    _response = BsDatatableResponse(
        data: currentData,
        countData: response.data.length,
        countFiltered: currentDataFiltered.length);
  }
}
