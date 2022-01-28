part of 'catalog_bloc.dart';

class CatalogState {
  final List<Mobile> mobileList;
  final List<Mobile> favoriteList;
  final int currentPage;
  final SortBy sortBy;

  CatalogState({this.mobileList = const <Mobile>[], this.favoriteList = const <Mobile>[], this.currentPage = 0, this.sortBy = SortBy.priceLowToHigh});
}

class LoadingState extends CatalogState {
  LoadingState({required int currentPage}) : super(currentPage: currentPage);
}