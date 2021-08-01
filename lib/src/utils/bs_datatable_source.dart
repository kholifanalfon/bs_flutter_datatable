import 'package:bs_flutter_datatable/bs_flutter_datatable.dart';

abstract class BsDatatableSource {

  BsDatatableSource({
    List? data,
    BsDatatableResponse? response,
    BsDatatableController? controller
  }) {

    if(data != null)
      datas = data;

    if(response == null)
      response = BsDatatableResponse(
          data: List.from([])
      );

    _response = response;

    if(controller == null)
      controller = BsDatatableController();

    _controller = controller;
  }

  List datas = List.from([]);

  /// Variable to handle response from jQuery datatable.net
  BsDatatableResponse _response = BsDatatableResponse(
    data: List.from([])
  );

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
    if(values != null)
      datas = values;

    controller.reload();
  }

  void clear() {
    datas.clear();

    controller.reload();
  }

  void add(dynamic value) {
    datas.add(value);
    controller.reload();
  }

  dynamic get(int index) {
    if(datas[index] != null)
      return datas[index];

    return null;
  }

  void put(int index, dynamic value) {
    if(datas[index] != null)
      datas[index] = value;

    controller.reload();
  }

  void removeAt(int index) {
    datas.removeAt(index);
    controller.reload();
  }

  void remove(dynamic value) {
    datas.remove(value);
    controller.reload();
  }

  void addAll(List values) {
    datas.addAll(values);
    controller.reload();
  }

  void reload() {
    List currentDataFiltered = datas.where((datas) {
      bool matched = false;
      for(int i = 0; i < controller.columns.length; i++) {
        bool datamatched = false;
        Map<String, String> column = controller.columns[i];

        if(column['searchable'] == 'true') {
          if(datas[column['name']] != null) {
            String data = datas[column['name']].toString().toLowerCase().trim();
            String value = controller.searchValue.toLowerCase().trim();

            if(data.contains(value)) {
              datamatched = true;
            }
          }

          matched = datamatched;

          if(datamatched)
            break;
        }
      }

      return matched;
    }).toList();

    List currentData = currentDataFiltered.skip(controller.start).take(controller.length).toList();
    _response = BsDatatableResponse(
      data: currentData,
      countData: datas.length,
      countFiltered: currentDataFiltered.length
    );
  }
}
