import 'package:flutter/material.dart';
import 'package:storia/models/tags_model.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class MainTag extends StatefulWidget {
  final List<TagsModel> items;
  final ValueChanged<TagsModel> setMainTag;
  final TagsModel? mainTag;
  const MainTag({
    super.key,
    required this.setMainTag,
    required this.items,
    this.mainTag,
  });

  @override
  State<MainTag> createState() => _MainTagState();
}

class _MainTagState extends State<MainTag> {
  late String? dropdownValue;

  @override
  void initState() {
    dropdownValue = widget.items.isEmpty ? null : widget.items[0].title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Verifica se o valor atual ainda existe na lista
    if (dropdownValue != null &&
        !widget.items.any((item) => item.id == dropdownValue)) {
      dropdownValue = null; // Reseta se o valor sumiu
    }

    if (widget.mainTag != null) {
      dropdownValue = widget.mainTag!.id;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Qual a categoria principal?',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 15),

        SizedBox(
          width: 250,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: DashboardTheme.secondary,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color.fromARGB(255, 42, 42, 42)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: dropdownValue,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                hint: Text(
                  widget.items.isNotEmpty ? 'Selecione' : 'Sem opções',
                  style: TextStyle(
                    color: Colors.white54,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                  ),
                ),
                dropdownColor: const Color.fromARGB(255, 40, 40, 40),
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 16,
                ),

                onChanged: (String? newValue) {
                  try {
                    setState(() {
                      dropdownValue = newValue;
                      widget.setMainTag(
                        widget.items.where((x) => x.id == newValue).first,
                      );
                    });
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                },

                items:
                    widget.items.map((item) {
                      final String title = item.title!;
                      final String id = item.id!;
                      return DropdownMenuItem<String>(
                        value: id,
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 16, // Consistente com o estilo principal
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
