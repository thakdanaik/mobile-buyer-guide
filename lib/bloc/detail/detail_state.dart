part of 'detail_bloc.dart';

class DetailState extends Equatable {
  final Mobile mobile;
  final List<MobileImage> imageList;

  const DetailState({required this.mobile, this.imageList = const <MobileImage>[]});

  @override
  List<Object> get props => [mobile, imageList];
}

class LoadingState extends DetailState {
  LoadingState(DetailState state) : super(mobile: state.mobile, imageList: state.imageList);
}

class ExceptionState extends DetailState {
  final String errorMsg;

  ExceptionState(DetailState state, {required this.errorMsg}) : super(mobile: state.mobile, imageList: state.imageList);

  @override
  List<Object> get props => [mobile, imageList, errorMsg];
}
