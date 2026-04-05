import 'package:flutter/material.dart';
import 'package:storia/models/tags_model.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class TagsOptions extends StatefulWidget {
  final ValueChanged<TagsModel> addTag;
  final ValueChanged<TagsModel> removeTag;
  final ValueChanged<bool> removeLast;
  final Future<List<TagsModel>?> future;
  final List<TagsModel> tagsList;
  const TagsOptions({
    required this.future,
    required this.removeTag,
    required this.removeLast,
    required this.addTag,
    required this.tagsList,
    super.key,
  });

  @override
  State<TagsOptions> createState() => _TagsOptionsState();
}

class _TagsOptionsState extends State<TagsOptions> {
  @override
  Widget build(BuildContext context) {
    final chosenTagsId = widget.tagsList.map((tag) => tag.id).toList();
    return FutureBuilder<List<TagsModel>?>(
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: DashboardTheme.blue),
          );
        }

        if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        }

        if (!snapshot.hasData ||
            snapshot.data!.isEmpty ||
            snapshot.data == null) {
          return Text('Nenhuma tag encontrada');
        }

        final tags = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Escolha entre uma e três categorias:',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 15),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  tags.map((tag) {
                    //Botão
                    return MyButton(
                      isSelected: chosenTagsId.contains(tag.id),
                      text: tag.title,
                      height: 30,
                      width: tag.title!.length * 2 + 100,
                      alignment: MainAxisAlignment.center,
                      spaceBetween: 0,
                      color: DashboardTheme.secondary,
                      selectedColor: DashboardTheme.blue,
                      fontSize: 10,
                      fontFamily: 'Poppins',
                      textColor: Colors.white,
                      splashColor: const Color.fromARGB(30, 255, 255, 255),
                      border:
                          chosenTagsId.contains(tag.id)
                              ? null
                              : Border.all(
                                color: const Color.fromARGB(45, 158, 158, 158),
                              ),
                      borderRadius: 10,
                      onTap: () {
                        if (!chosenTagsId.contains(tag.id) &&
                            widget.tagsList.length < 3) {
                          widget.addTag(tag);
                        } else if (chosenTagsId.contains(tag.id)) {
                          widget.removeTag(tag);
                        } else if (widget.tagsList.length == 3) {
                          widget.removeLast(true);
                          widget.addTag(tag);
                        }
                      },
                    );
                  }).toList(),
            ),
          ],
        );
      },
    );
  }
}
