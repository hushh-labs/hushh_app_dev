import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Section {
  final String heading;
  final String image;
  final String desc;

  Section({required this.heading, required this.image, required this.desc});
}

class DiscoverPageHeader extends StatefulWidget {
  const DiscoverPageHeader({super.key});

  @override
  State<DiscoverPageHeader> createState() => _DiscoverPageHeaderState();
}

class _DiscoverPageHeaderState extends State<DiscoverPageHeader> {
  bool get isAgent => sl<CardWalletPageBloc>().isAgent;

  List<Section> sections = [
    Section(
      heading: 'Featured Collections',
      image:
      'https://images.unsplash.com/photo-1542513217-0b0eedf7005d?q=80&w=1528&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      desc: 'Discover handpicked styles that elevate your wardrobe with the latest trends.',
    ),
    Section(
      heading: 'Timeless Treasures',
      image:
      'https://images.unsplash.com/photo-1645857656936-b1bdb9a52059?q=80&w=1587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      desc: 'Explore classic pieces that never go out of style and define elegance.',
    ),
    Section(
      heading: 'Must-Have Essentials',
      image:
      'https://images.unsplash.com/photo-1629580626780-7fe7fb0523e9?q=80&w=1528&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      desc: 'Stock up on essential wardrobe staples that form the foundation of every outfit.',
    ),
    Section(
      heading: 'Explore Your Aesthetic',
      image:
      'https://images.unsplash.com/photo-1571513800374-df1bbe650e56?q=80&w=1587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      desc: 'Find unique pieces that resonate with your personal style and express who you are.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      collapseMode: CollapseMode.parallax,
      background: Stack(
        fit: StackFit.expand,
        children: [
          CarouselSlider.builder(
              itemCount: sections.length,
              options: CarouselOptions(
                enlargeCenterPage: false,
                viewportFraction: 1,
                disableCenter: true,
              ),
              itemBuilder: (context, index, realIndex) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      sections[index].image,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: 36.h + kTextTabBarHeight + kToolbarHeight,
                      width: 100.w,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            stops: [0.5, 1],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                            Colors.transparent,
                            Colors.black45.withOpacity(.45)
                          ])),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AutoSizeText(
                              sections[index].heading,
                              maxLines: 1,
                              minFontSize:
                                  context.headlineSmall?.fontSize ?? 12,
                              style: context.displaySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                  shadows: [
                                    const BoxShadow(
                                        color: Colors.black87, blurRadius: 56)
                                  ]),
                            ),
                            const SizedBox(height: 6),
                            Text(sections[index].desc, style: const TextStyle(
                              color: Colors.white60,
                              fontWeight: FontWeight.w600
                            ),),
                            const SizedBox(height: 42),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CarouselIndicator(
                    count: sections.length,
                    index: 0,
                    height: 8,
                    width: 8,
                    cornerRadius: 20,
                    activeColor: Colors.black,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
