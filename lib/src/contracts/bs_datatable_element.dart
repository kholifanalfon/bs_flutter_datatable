import 'package:bs_flutter_datatable/src/bs_datatable.dart';
import 'package:flutter/material.dart';

abstract class BsDatatableElement {
  Widget table();

  Widget searchForm({
    double width = 200,
    BoxDecoration? decoration,
    InputDecoration? inputDecoration,
    BsDatatableSearchLabel? builderLabel,
  });

  Widget informationData();

  Widget title();

  Widget pageLength();

  Widget pagination();

  Widget footer();
}
