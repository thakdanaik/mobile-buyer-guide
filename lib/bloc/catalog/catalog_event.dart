part of 'catalog_bloc.dart';

@immutable
abstract class CatalogEvent {}

class GetMobileDataEvent extends CatalogEvent {}

class ChangePageViewEvent extends CatalogEvent {
  final int pageIndex;

  ChangePageViewEvent({required this.pageIndex});
}
