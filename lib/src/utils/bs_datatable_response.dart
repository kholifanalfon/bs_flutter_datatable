class BsDatatableResponse {

  const BsDatatableResponse({
    this.draw = 0,
    this.start = 1,
    this.countData = 0,
    this.countFiltered = 0,
    this.data = const [],
  });

  final List data;

  final int draw;

  final int start;

  final int countData;

  final int countFiltered;

  factory BsDatatableResponse.createFromJson(Map<String, dynamic> map) {
    return BsDatatableResponse(
      draw: map['draw'],
      start: map['start'],
      countData: map['recordsTotal'],
      countFiltered: map['recordsFiltered'],
      data: map['data'],
    );
  }
}