import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:storia/models/banners_model.dart';
import 'package:storia/repositories/banners_repository.dart';
import 'package:storia/utilities/utilities.dart';

class BannersList extends StatefulWidget {
  final BannersModel? chosenBanner;
  final bool editing;
  final VoidCallback editingToggle;
  final ValueChanged<BannersModel> setChosenBanner;
  final ValueChanged<List<Map<String, dynamic>>> setEditedBanners;

  const BannersList({
    super.key,
    required this.setChosenBanner,
    required this.chosenBanner,
    required this.editing,
    required this.editingToggle,
    required this.setEditedBanners,
  });

  @override
  State<BannersList> createState() => _BannersListState();
}

class _BannersListState extends State<BannersList> {
  final List<Map<String, dynamic>> bannersManipulate = [];
  final List<BannersModel> bannersBeforeManipulate = [];
  late final Stream<List<BannersModel>> stream;

  bool initialized = false;

  void _syncLocalState(List<BannersModel> data) {
    bannersManipulate
      ..clear()
      ..addAll(data.map((e) => e.toJson()));

    bannersBeforeManipulate
      ..clear()
      ..addAll(data);

    initialized = true;
  }

  void _emitEditedBanners() {
    final List<Map<String, dynamic>> bannersToSet = [];

    for (var banner in bannersManipulate) {
      final original = bannersBeforeManipulate.firstWhere(
        (b) => b.id == banner['id'],
      );

      if (banner['order'] != original.order) {
        bannersToSet.add({'id': banner['id'], 'order': banner['order']});
      }
    }

    widget.setEditedBanners(bannersToSet);
  }

  void up(int index) {
    if (index == 0) return;

    setState(() {
      final temp = bannersManipulate[index]['order'];
      bannersManipulate[index]['order'] = bannersManipulate[index - 1]['order'];
      bannersManipulate[index - 1]['order'] = temp;

      bannersManipulate.sort((a, b) => a['order'].compareTo(b['order']));
    });

    _emitEditedBanners();
  }

  void down(int index) {
    if (index == bannersManipulate.length - 1) return;

    setState(() {
      final temp = bannersManipulate[index]['order'];
      bannersManipulate[index]['order'] = bannersManipulate[index + 1]['order'];
      bannersManipulate[index + 1]['order'] = temp;

      bannersManipulate.sort((a, b) => a['order'].compareTo(b['order']));
    });

    _emitEditedBanners();
  }

  @override
  void initState() {
    super.initState();
    stream = BannersRepository().watchAll();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 8.0,
        right: 8,
        bottom: 8,
        left: widget.editing ? 0 : 8,
      ),
      child: StreamBuilder<List<BannersModel>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const SizedBox(
              height: 40,
              width: 40,
              child: ColoredBox(color: Colors.red),
            );
          }

          final data =
              snapshot.data!..sort((a, b) => a.order!.compareTo(b.order!));

          bool ordersChanged = false;

          for (BannersModel banner in data) {
            for (var bannerMap in bannersManipulate) {
              if (bannerMap['id'] == banner.id) {
                if (bannerMap['order'] != banner.order) {
                  ordersChanged = true;
                }
              }
            }
          }

          // 🔒 só sincroniza com o banco se NÃO estiver editando
          if (data.length != bannersManipulate.length ||
              (ordersChanged && !widget.editing)) {
            _syncLocalState(data);
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final banner = data[index];
              final bannerEdit = bannersManipulate[index];
              final isChosen = widget.chosenBanner == banner;
              bool deleting = false;
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap:
                      widget.editing
                          ? null
                          : () => widget.setChosenBanner(banner),
                  borderRadius: BorderRadius.circular(10),
                  child: Ink(
                    height: 70,
                    decoration: BoxDecoration(
                      color:
                          isChosen
                              ? const Color.fromARGB(255, 27, 27, 27)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              if (widget.editing)
                                MyButton(
                                  height: 40,
                                  width: 40,
                                  isSelected: false,
                                  borderRadius: 10,
                                  isLoading: deleting,
                                  loadingColor: Colors.red,
                                  loadingSize: 0.4,
                                  color: Colors.transparent,
                                  icon: LucideIcons.trash,
                                  splashColor: Colors.transparent,
                                  spaceBetween: 0,
                                  iconColor: Colors.red,
                                  alignment: MainAxisAlignment.center,
                                  iconSize: 20,
                                  onTap: () async {
                                    await FirebaseFunctions.instanceFor(
                                      region: "southamerica-east1",
                                    ).httpsCallable("deleteBanner").call({
                                      'url': bannerEdit['imageUrl'],
                                      'id': bannerEdit['id'],
                                      'order': bannerEdit['order'],
                                    });
                                  },
                                ),

                              Container(
                                height: double.infinity,
                                width: 62,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      widget.editing
                                          ? bannerEdit['imageUrl']
                                          : banner.imageUrl!,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.editing
                                    ? '${bannerEdit['order']}. ${bannerEdit['title']}'
                                    : '${banner.order}. ${banner.title}',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          if (widget.editing)
                            Row(
                              children: [
                                _arrowButton(
                                  icon: LucideIcons.chevronDown100,
                                  onTap: () => down(index),
                                ),
                                const SizedBox(width: 7),
                                _arrowButton(
                                  icon: LucideIcons.chevronUp100,
                                  onTap: () => up(index),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _arrowButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color.fromARGB(51, 255, 255, 255),
        ),
        child: Center(child: Icon(icon, color: Colors.white, size: 13)),
      ),
    );
  }
}
