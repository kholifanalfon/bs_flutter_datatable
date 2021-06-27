import 'package:bs_flutter_datatable/bs_flutter_datatable.dart';

class BsDataRow {
  const BsDataRow({
    required this.index,
    required this.cells,
  });

  final int index;

  final List<BsDataCell> cells;
}
