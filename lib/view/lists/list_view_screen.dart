import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../model/base/songext.dart';
import '../../navigator/main_navigator.dart';
import '../../navigator/mixin/back_navigator.dart';
import '../../navigator/route_names.dart';
import '../../theme/theme_colors.dart';
import '../../vm/lists/list_view_vm.dart';
import '../../widget/general/labels.dart';
import '../../widget/general/list_items.dart';
import '../../widget/inputs/form_input.dart';
import '../../widget/progress/line_progress.dart';
import '../../widget/provider/provider_widget.dart';
import '../../widget/search/add_songs.dart';

/// Screen for viewing a song list
class ListViewScreen extends StatefulWidget {
  static const String routeName = RouteNames.listScreen;

  const ListViewScreen({Key? key}) : super(key: key);

  @override
  ListViewScreenState createState() => ListViewScreenState();
}

@visibleForTesting
class ListViewScreenState extends State<ListViewScreen>
    with BackNavigatorMixin
    implements ListViewNavigator {
  @override
  Widget build(BuildContext context) {
    var tr = AppLocalizations.of(context)!;
    Size size = MediaQuery.of(context).size;

    return ProviderWidget<ListViewVm>(
      create: () => GetIt.I()..init(this),
      consumerWithThemeAndLocalization: (ctx, vm, child, theme, localization) {
        vm.tr = AppLocalizations.of(context)!;
        var listContainer = Container(
          height: size.height * 0.8,
          padding: const EdgeInsets.only(right: 2),
          child: ListView.builder(
            itemCount: vm.listSongs!.length,
            padding: EdgeInsets.all(
              size.height * 0.0082,
            ),
            itemBuilder: (ctx, index) {
              final SongExt song = vm.listSongs![index];
              return SongItem(
                song: song,
                isSearching: true,
                height: size.height,
                onPressed: () {
                  vm.localStorage.song = vm.setSong = song;
                  vm.navigator.goToSongPresentor();
                },
              );
            },
          ),
        );
        var mainContainer = ContextMenuOverlay(
          cardBuilder: (_, children) => Container(
            decoration: const BoxDecoration(
              color: ThemeColors.accent,
              boxShadow: [BoxShadow(blurRadius: 5)],
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Column(children: children),
          ),
          child: Container(
            height: size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, ThemeColors.accent, Colors.black],
              ),
            ),
            child: SingleChildScrollView(
              child: vm.isLoading
                  ? const ListLoading()
                  : vm.listeds!.isNotEmpty
                      ? listContainer
                      : NoDataToShow(
                          title: tr.itsEmptyHere,
                          description: tr.itsEmptyHereBody,
                        ),
            ),
          ),
        );
        return Scaffold(
          appBar: AppBar(
            title: Text(vm.listTitle),
            actions: <Widget>[
              InkWell(
                onTap: () => editListForm(context, vm),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.edit),
                ),
              ),
              InkWell(
                onTap: () => vm.confirmDelete(context),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.delete),
                ),
              ),
            ],
          ),
          body: mainContainer,
          floatingActionButton: FloatingActionButton(
            backgroundColor: ThemeColors.primary,
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: AddSongs(context, vm.homeVm!, vm, size.height),
              );
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  Future<void> editListForm(BuildContext context, ListViewVm vm) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Update This List',
          style: TextStyle(
            fontSize: 22,
            color: ThemeColors.primaryDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FormInput(
                iLabel: 'Title',
                iController: vm.titleController!,
              ),
              FormInput(
                iLabel: 'Description (Optional)',
                iController: vm.contentController!,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              vm.saveChanges();
              vm.titleController!.clear();
              vm.contentController!.clear();
              Navigator.pop(context);
            },
            child: const Text("SAVE CHANGES"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL"),
          ),
        ],
      ),
    );
  }

  @override
  void goToSongPresentor() => MainNavigator.of(context).goToSongPresentor();

  @override
  void goToSongPresentorPc() => MainNavigator.of(context).goToSongPresentorPc();
}
