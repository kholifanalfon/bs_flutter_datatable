/// Handle jquery datatable.net response format
class BsDatatableResponse {

  BsDatatableResponse({
    this.draw = 0,
    this.countData = 0,
    this.countFiltered = 0,
    this.data = const [],
  });

  List data;

  final int draw;

  final int countData;

  final int countFiltered;

  factory BsDatatableResponse.createFromJson(Map<String, dynamic> map) {
    return BsDatatableResponse(
      draw: map['draw'],
      countData: map['recordsTotal'],
      countFiltered: map['recordsFiltered'],
      data: map['data'],
    );
  }
}
