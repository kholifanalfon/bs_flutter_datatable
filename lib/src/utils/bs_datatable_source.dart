import 'package:bs_flutter_datatable/bs_flutter_datatable.dart';

abstract class BsDatatableSource {

  /// Variable to handle response from jQuery datatable.net
  BsDatatableResponse response = BsDatatableResponse();

  /// Variable to save datatable config
  BsDatatableController controller = BsDatatableController();

  /// Get count data from [response]
  int get countData => response.countData;

  /// Get count filtered data from [response]
  int get countFiltered => response.countFiltered;

  /// Get count data in page using [response].data length
  int get countDataPage => response.data.length;

  /// Set row widgets
  BsDataRow getRow(int index);
}
