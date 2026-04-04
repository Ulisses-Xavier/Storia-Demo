import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storia/mobile/color_theme.dart';
import 'package:storia/providers/tags_provider.dart';
import 'package:storia/utilities/utilities.dart';

class PreferenceItem extends StatelessWidget {
  final String title;
  final bool selected;
  final ValueChanged<String> setFunction;
  final String id;
  const PreferenceItem({
    super.key,
    required this.title,
    required this.selected,
    required this.id,
    required this.setFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          setFunction(id);
        },
        child: Ink(
          height: 55,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.transparent,
                  ),
                  child:
                      selected
                          ? Center(
                            child: Container(
                              height: 18,
                              width: 18,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.white,
                              ),
                            ),
                          )
                          : null,
                ),
                SizedBox(width: 7),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AllContentsSectionPreferenceBottomSheet extends ConsumerStatefulWidget {
  final String orderBy;
  final bool isOrderBy;
  final List<String>? idsList;
  const AllContentsSectionPreferenceBottomSheet({
    super.key,
    required this.orderBy,
    required this.isOrderBy,
    this.idsList,
  });

  @override
  ConsumerState<AllContentsSectionPreferenceBottomSheet> createState() =>
      _AllContentsSectionPreferenceBottomSheetState();
}

class _AllContentsSectionPreferenceBottomSheetState
    extends ConsumerState<AllContentsSectionPreferenceBottomSheet> {
  //TAGS PREFERENCES
  late List<String> tagsIdsToSave;

  void setTag(String id) {
    if (tagsIdsToSave.contains(id)) {
      setState(() {
        tagsIdsToSave.remove(id);
      });
      return;
    }

    setState(() {
      tagsIdsToSave.add(id);
    });
  }

  //DATA FOR SORTBY PREFERENCES
  List<Map<String, dynamic>> itensList = [
    {'id': 'popular', 'title': 'Popular'},
    {'id': 'newChap', 'title': 'Capítulo recente'},
    {'id': 'newContent', 'title': 'Obra recente'},
  ];

  late String sortId;

  void setSort(String id) {
    if (sortId != id) {
      setState(() {
        sortId = id;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    sortId = widget.orderBy;
    if (widget.idsList != null) {
      tagsIdsToSave = List.from(widget.idsList!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tagsAsync = ref.watch(tagProvider);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorTheme.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 2,
              width: 70,
              decoration: BoxDecoration(
                color: ColorTheme.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 10),
            if (!widget.isOrderBy)
              tagsAsync.when(
                data: (data) {
                  if (data == null) {
                    return Text(
                      'Erro | Tente novamente',
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    );
                  }

                  return ScrollConfiguration(
                    behavior: ScrollBehavior().copyWith(overscroll: false),
                    child: ListView.builder(
                      itemCount: data.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return PreferenceItem(
                          title: item.title!,
                          selected: tagsIdsToSave.contains(item.id),
                          setFunction: setTag,
                          id: item.id!,
                        );
                      },
                    ),
                  );
                },
                loading:
                    () => Center(
                      child: CircularProgressIndicator(color: ColorTheme.blue),
                    ),
                error: (_, _) {
                  return Center(
                    child: Text(
                      'Erro | Tente novamente',
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  );
                },
              ),

            if (widget.isOrderBy)
              ScrollConfiguration(
                behavior: ScrollBehavior().copyWith(overscroll: false),
                child: ListView.builder(
                  itemCount: itensList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = itensList[index];
                    return PreferenceItem(
                      title: item['title'],
                      selected: sortId == item['id'],
                      setFunction: setSort,
                      id: item['id'],
                    );
                  },
                ),
              ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: MyButton(
                    isSelected: false,
                    height: 40,
                    color: Colors.transparent,
                    borderRadius: 10,
                    border: Border.all(color: ColorTheme.grey.withAlpha(100)),
                    text: 'Cancelar',
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    textColor: Colors.white,
                    spaceBetween: 0,
                    splashColor: Colors.transparent,
                    alignment: MainAxisAlignment.center,
                    onTap: () => Navigator.pop(context, null),
                  ),
                ),
                SizedBox(width: 4),
                Expanded(
                  flex: 1,
                  child: MyButton(
                    height: 40,
                    isSelected: false,
                    color: ColorTheme.blue,
                    borderRadius: 10,
                    text: 'Continuar',
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    textColor: Colors.white,
                    spaceBetween: 0,
                    splashColor: Colors.transparent,
                    alignment: MainAxisAlignment.center,
                    onTap: () {
                      if (widget.isOrderBy) {
                        Navigator.pop(context, sortId);
                        return;
                      }

                      Navigator.pop(context, tagsIdsToSave);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
