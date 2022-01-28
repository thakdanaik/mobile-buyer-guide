part of 'catalog_bloc.dart';

@immutable
abstract class CatalogEvent {}

class GetMobileDataEvent extends CatalogEvent {}

class ChangePageViewEvent extends CatalogEvent {
  final int pageIndex;

  ChangePageViewEvent({required this.pageIndex});
}

class AddFavoriteEvent extends CatalogEvent {
  final Mobile mobile;

  AddFavoriteEvent({required this.mobile});
}

class RemoveFavoriteEvent extends CatalogEvent {
  final Mobile mobile;

  RemoveFavoriteEvent({required this.mobile});
}
