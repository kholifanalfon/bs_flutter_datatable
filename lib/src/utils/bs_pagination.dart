import 'package:bs_flutter_datatable/bs_flutter_datatable.dart';

class BsPagination {

  static const List<BsPaginationButtons> buttons = [
    BsPaginationButtons.firstPage, BsPaginationButtons.previous,
    BsPaginationButtons.button,
    BsPaginationButtons.next, BsPaginationButtons.lastPage,
  ];

  static const List<BsPaginationButtons> simplyButtons = [
    BsPaginationButtons.previous,
    BsPaginationButtons.button,
    BsPaginationButtons.next,
  ];

  static const List<BsPaginationButtons> input = [
    BsPaginationButtons.firstPage, BsPaginationButtons.previous,
    BsPaginationButtons.input,
    BsPaginationButtons.next, BsPaginationButtons.lastPage,
  ];

  static const List<BsPaginationButtons> simplyInput = [
    BsPaginationButtons.previous,
    BsPaginationButtons.button,
    BsPaginationButtons.lastPage,
  ];
}