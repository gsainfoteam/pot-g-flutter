import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pot_g/gen/assets.gen.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({
    super.key,
    required this.banners,
    this.height = 70,
    this.horizontalPadding = 16,
    this.verticalPadding = 16,
    this.autoScrollDuration = const Duration(seconds: 5),
    this.borderRadius = 12,
  });

  final List<SvgGenImage> banners;
  final double height;
  final double horizontalPadding;
  final double verticalPadding;
  final Duration autoScrollDuration;
  final double borderRadius;

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  late PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.banners.length > 1) {
      _timer = Timer.periodic(widget.autoScrollDuration, (_) => _nextPage());
    }
  }

  void _nextPage() {
    if (!_pageController.hasClients || widget.banners.isEmpty) return;
    final current = _pageController.page?.round() ?? 0;
    final next = (current + 1) % widget.banners.length;
    _pageController.animateToPage(
      next,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banners = widget.banners;
    if (banners.isEmpty) return const SizedBox.shrink();

    final content = banners.length == 1
        ? _BannerItem(
            asset: banners.first,
            height: widget.height,
            borderRadius: widget.borderRadius,
          )
        : SizedBox(
            height: widget.height,
            child: PageView.builder(
              controller: _pageController,
              itemCount: banners.length,
              itemBuilder: (context, index) => _BannerItem(
                asset: banners[index],
                height: widget.height,
                borderRadius: widget.borderRadius,
              ),
            ),
          );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.horizontalPadding,
        vertical: widget.verticalPadding,
      ),
      child: content,
    );
  }
}

class _BannerItem extends StatelessWidget {
  const _BannerItem({
    required this.asset,
    required this.height,
    required this.borderRadius,
  });

  final SvgGenImage asset;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: asset.svg(fit: BoxFit.cover),
      ),
    );
  }
}
