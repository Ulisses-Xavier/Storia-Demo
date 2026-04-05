import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storia/models/content/content_model.dart';
import 'package:storia/web_dashboard/dashboard_body/pages/chapters/widgets/top_bar/error_content_select.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';
import 'package:storia/web_dashboard/providers/user_contents_provider.dart';

typedef SetContent = void Function(ContentModel, String status);

class ContentSelect extends ConsumerStatefulWidget {
  final SetContent setcontent;
  final ValueChanged<String> setWarn;
  final String status;
  const ContentSelect({
    super.key,
    required this.setcontent,
    required this.setWarn,
    required this.status,
  });

  @override
  ConsumerState<ContentSelect> createState() => _ContentSelectState();
}

class _ContentSelectState extends ConsumerState<ContentSelect> {
  ContentModel? dropdownValue;
  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    final userContents = ref.watch(userContentsProvider);
    return userContents.when(
      data: (contents) {
        if (contents.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.setWarn('no content');
          });
          return ErrorContentSelect(text: 'Sem conteúdo');
        }

        if (dropdownValue == null && mounted) {
          if (!initialized) {
            initialized = true;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;

              final first = contents[0];

              setState(() {
                dropdownValue = first;
              });

              widget.setcontent(first, widget.status);
            });
          }
        }

        return SizedBox(
          width: 250,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: DashboardTheme.secondary,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color.fromARGB(255, 42, 42, 42)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<ContentModel>(
                value:
                    contents.any((e) => e == dropdownValue)
                        ? dropdownValue
                        : null,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                hint: Text(
                  contents.isNotEmpty ? 'Selecione' : 'Sem opções',
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white54,
                    fontFamily: 'Poppins',
                    fontSize: 13,
                  ),
                ),
                dropdownColor: DashboardTheme.secondary,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 13,
                ),

                onChanged: (ContentModel? newValue) {
                  if (mounted) {
                    setState(() {
                      dropdownValue = newValue;
                      widget.setcontent(newValue!, widget.status);
                    });
                  }
                },

                items:
                    contents.map((item) {
                      final String title = item.title!;
                      return DropdownMenuItem<ContentModel>(
                        value: item,
                        child: Row(
                          children: [
                            Image.network(
                              item.coverMini!,
                              height: 35,
                              width: 10,
                            ),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize:
                                      13, // Consistente com o estilo principal
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        );
      },
      loading: () {
        return Container(
          height: 45,
          width: 250,
          decoration: BoxDecoration(
            color: DashboardTheme.secondary,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color.fromARGB(255, 42, 42, 42)),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(30, 5, 5, 5),
                blurRadius: 5,
                spreadRadius: 5,
                offset: Offset.fromDirection(1, 2),
              ),
            ],
          ),
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
              backgroundColor: Colors.transparent,
              color: DashboardTheme.blue,
            ),
          ),
        );
      },
      error: (_, _) => ErrorContentSelect(text: 'Erro desconhecido'),
    );
  }
}
