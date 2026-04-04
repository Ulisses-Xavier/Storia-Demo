import 'package:flutter/material.dart';
import 'package:storia/mobile/app/sub_widgets/content_card.dart';
import 'package:storia/models/content/content_model.dart';

class ContentGrid extends StatefulWidget {
  final List<ContentModel> data;
  final bool? isAppSearch;
  const ContentGrid({super.key, required this.data, this.isAppSearch});

  @override
  State<ContentGrid> createState() => _ContentGridState();
}

class _ContentGridState extends State<ContentGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(vertical: 0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.data.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, //Número por linha
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 1 / 1.8,
      ),
      itemBuilder: (context, index) {
        final content = widget.data[index];

        return ContentCard(content: content, isAppSearch: widget.isAppSearch);
      },
    );
  }
}
