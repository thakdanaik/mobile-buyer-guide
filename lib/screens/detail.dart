import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_buyer_guide/bloc/detail/detail_bloc.dart';
import 'package:mobile_buyer_guide/models/mobile.dart';
import 'package:mobile_buyer_guide/services/mobile_service.dart';
import 'package:mobile_buyer_guide/theme/theme.dart';

class Detail extends StatefulWidget {
  final Mobile mobile;

  const Detail({Key? key, required this.mobile}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late final DetailBloc _detailBloc;

  @override
  void initState() {
    _detailBloc = DetailBloc(mobileService: MobileService(Dio()), mobile: widget.mobile);
    super.initState();
  }

  @override
  void dispose() {
    _detailBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _detailBloc,
      child: DetailView(
        detailBloc: _detailBloc,
      ),
    );
  }
}

class DetailView extends StatefulWidget {
  final DetailBloc detailBloc;

  const DetailView({Key? key, required this.detailBloc}) : super(key: key);

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  @override
  void initState() {
    super.initState();
    widget.detailBloc.add(GetMobileImageEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailBloc, DetailState>(
      bloc: widget.detailBloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${state.mobile.name}'),
          ),
          body: ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Stack(
                  children: [
                    _buildImagePageView(context),
                    _buildPriceAndRating(context),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _buildMobileDetail(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePageView(BuildContext context) {
    if (widget.detailBloc.state is LoadingState) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return PageView(
      children: widget.detailBloc.state.imageList.isEmpty
          ? [
              Container(
                color: Colors.white,
                child: const Center(child: Text('No Image')),
              ),
            ]
          : widget.detailBloc.state.imageList
              .map(
                (e) => Image.network(
                  e.url!,
                  fit: BoxFit.fitHeight,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.white,
                    child: const Center(child: Text('Invalid Image')),
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildPriceAndRating(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.topRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(5.0),
              color: Colors.white.withOpacity(0.5),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Rating : ', style: Theme.of(context).textTheme.normal.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
                    TextSpan(text: widget.detailBloc.state.mobile.rating!.toStringAsFixed(1), style: Theme.of(context).textTheme.normal.copyWith(color: Colors.black)),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              color: Colors.white.withOpacity(0.5),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Price : ', style: Theme.of(context).textTheme.normal.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
                    TextSpan(text: '\$${widget.detailBloc.state.mobile.price!.toStringAsFixed(2)}', style: Theme.of(context).textTheme.normal.copyWith(color: Colors.black)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileDetail(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'Brand : ', style: Theme.of(context).textTheme.large.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
                TextSpan(text: widget.detailBloc.state.mobile.brand, style: Theme.of(context).textTheme.large.copyWith(color: Colors.black)),
              ],
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 5),
          Text(widget.detailBloc.state.mobile.description!),
        ],
      ),
    );
  }
}
