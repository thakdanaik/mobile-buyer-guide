part of 'catalog_bloc.dart';

class CatalogState extends Equatable {
  final List<Mobile> mobileList;
  final List<Mobile> favoriteList;
  final int currentPage;
  final SortBy sortBy;

  const CatalogState({this.mobileList = const <Mobile>[], this.favoriteList = const <Mobile>[], this.currentPage = 0, this.sortBy = SortBy.priceLowToHigh});

  @override
  List<Object> get props => [mobileList, favoriteList, currentPage, sortBy];
}

class LoadingState extends CatalogState {

  LoadingState(CatalogState state) : super(mobileList: state.mobileList, favoriteList: state.favoriteList, sortBy: state.sortBy, currentPage: state.currentPage);
}

class ExceptionState extends CatalogState {
  final String errorMsg;

  ExceptionState(CatalogState state, {required this.errorMsg}) : super(mobileList: state.mobileList, favoriteList: state.favoriteList, sortBy: state.sortBy, currentPage: state.currentPage);

  @override
  List<Object> get props => [mobileList, favoriteList, currentPage, sortBy, errorMsg];
}