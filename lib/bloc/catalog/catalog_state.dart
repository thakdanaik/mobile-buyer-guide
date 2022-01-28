part of 'catalog_bloc.dart';

class CatalogState {
  final List<Mobile> mobileList;
  final int currentPage;

  CatalogState({this.mobileList = const <Mobile>[], this.currentPage = 0});
}

class LoadingState extends CatalogState {
  LoadingState({required int currentPage}) : super(currentPage: currentPage);
}