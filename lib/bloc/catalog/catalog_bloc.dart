import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mobile_buyer_guide/constants/constant.dart';
import 'package:mobile_buyer_guide/models/mobile.dart';
import 'package:mobile_buyer_guide/services/mobile_service.dart';

part 'catalog_event.dart';

part 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final MobileService mobileService;

  CatalogBloc({required this.mobileService}) : super(CatalogState()) {
    on<GetMobileDataEvent>(_getMobileData);
    on<ChangePageViewEvent>(_changePageView);
    on<AddFavoriteEvent>(_addFavorite);
    on<RemoveFavoriteEvent>(_removeFavorite);
    on<SortDataEvent>(_sortData);
  }

  Future<void> _getMobileData(
    GetMobileDataEvent event,
    Emitter<CatalogState> emit,
  ) async {
    emit(LoadingState(currentPage: state.currentPage));
    List<Mobile> mobileList = await mobileService.getMobiles();
    _sortMobileList(mobileList, state.sortBy);
    emit(CatalogState(mobileList: mobileList, currentPage: state.currentPage));
  }

  void _changePageView(
    ChangePageViewEvent event,
    Emitter<CatalogState> emit,
  ) {
    if (state is LoadingState) {
      emit(LoadingState(currentPage: event.pageIndex));
    } else {
      emit(CatalogState(mobileList: state.mobileList, favoriteList: state.favoriteList, currentPage: event.pageIndex, sortBy: state.sortBy));
    }
  }

  void _addFavorite(
    AddFavoriteEvent event,
    Emitter<CatalogState> emit,
  ) {
    event.mobile.isFavorite = true;
    emit(CatalogState(mobileList: state.mobileList, favoriteList: state.mobileList.where((e) => e.isFavorite ?? false).toList(), currentPage: state.currentPage, sortBy: state.sortBy));
  }

  void _removeFavorite(
    RemoveFavoriteEvent event,
    Emitter<CatalogState> emit,
  ) {
    event.mobile.isFavorite = false;
    emit(CatalogState(mobileList: state.mobileList, favoriteList: state.mobileList.where((e) => e.isFavorite ?? false).toList(), currentPage: state.currentPage, sortBy: state.sortBy));
  }

  void _sortData(
      SortDataEvent event,
      Emitter<CatalogState> emit,
      ) {
    List<Mobile> mobileList = state.mobileList;
    emit(LoadingState(currentPage: state.currentPage));
    _sortMobileList(mobileList, event.sortBy);
    emit(CatalogState(mobileList: mobileList, favoriteList: mobileList.where((e) => e.isFavorite ?? false).toList(), currentPage: state.currentPage, sortBy: event.sortBy));
  }

  void _sortMobileList(List<Mobile> mobileList, SortBy sortBy){
    if(mobileList.isNotEmpty) {
      mobileList.sort((a, b) {
        switch (sortBy) {
          case SortBy.priceLowToHigh:
            return a.price!.compareTo(b.price!);
          case SortBy.priceHighToLow:
            return b.price!.compareTo(a.price!);
          case SortBy.rating:
            return b.rating!.compareTo(a.rating!);
        }
      });
    }
  }
}
