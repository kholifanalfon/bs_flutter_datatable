class BsDatatableLanguage {
  const BsDatatableLanguage({
    this.perPageLabel = 'Perpage',
    this.searchLabel = 'Search',
    this.hintTextSearch = 'Search ...',
    this.firstPagination = 'First Page',
    this.lastPagination = 'Last Page',
    this.previousPagination = 'Previous',
    this.nextPagination = 'Next',
    this.information = 'Show __START__ to __END__ of __FILTERED__ entries',
    this.informationFiltered = 'filtered from __DATA__ total enteries',
  });

  final String? perPageLabel;

  final String? searchLabel;

  final String hintTextSearch;

  final String firstPagination;

  final String lastPagination;

  final String previousPagination;

  final String nextPagination;

  /// To customize information data message, you can use this word
  /// the system will replaced with avaible data
  /// - __START__
  /// - __END__
  /// - __FILTERED__
  /// - __DATA__
  final String information;

  /// To customize information on search data message, you can use this word
  /// the system will replaced with avaible data
  /// - __START__
  /// - __END__
  /// - __FILTERED__
  /// - __DATA__
  final String informationFiltered;
}
