import 'package:bs_flutter_datatable/bs_flutter_datatable.dart';

abstract class BsDatatableSource {

  int get countData;

  int get countFiltered;

  int get countDataPage;

  BsDataRow getRow(int index);
}