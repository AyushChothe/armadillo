import 'package:armadillo/pages/terminal_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tabbed_view/tabbed_view.dart';

class TerminalTabViewPage extends HookConsumerWidget {
  const TerminalTabViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabLength = useState(0);
    final tabCtrl = useState(TabbedViewController([]));

    void addTab() {
      if (tabCtrl.value.tabs.length >= 5) return;
      tabCtrl.value.addTab(
        TabData(
          text: "Tab " "${tabLength.value + 1}",
          value: tabLength.value,
          keepAlive: true,
        ),
      );
      tabLength.value++;
    }

    void removeTab(int idx) {
      if (tabCtrl.value.tabs.isEmpty) return;
      int _idx = 0;

      for (var t in tabCtrl.value.tabs) {
        if (t.value == idx) {
          break;
        }
        _idx++;
      }
      tabCtrl.value.removeTab(_idx);
      if (tabCtrl.value.tabs.isEmpty) Navigator.pop(context);
    }

    useEffect(() {
      addTab();
      return null;
    }, const []);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => addTab(),
      ),
      body: TabbedViewTheme(
        data: TabbedViewThemeData(
          menu: MenuThemeData(
            color: Theme.of(context).backgroundColor,
            textStyle: Theme.of(context).textTheme.subtitle2,
            // dividerColor: Theme.of(context).dividerColor,
            // dividerThickness: 1,
            menuItemPadding: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.all(2.0),
            hoverColor: Theme.of(context).colorScheme.secondary,
            border: Border.all(
              width: 1,
            ),
          ),
          tab: TabThemeData(
            textStyle: Theme.of(context).textTheme.subtitle2,
            buttonsOffset: 8,
            margin: const EdgeInsets.only(top: 4.0),
            buttonPadding: const EdgeInsets.all(2.0),
            closeIcon: IconProvider.data(Icons.close),
            normalButtonColor: Theme.of(context).colorScheme.surface,
            normalButtonBackground: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).disabledColor,
            ),
            hoverButtonColor: Theme.of(context).colorScheme.onError,
            hoverButtonBackground: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.error,
            ),
            disabledButtonColor: Theme.of(context).colorScheme.surface,
            disabledButtonBackground: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).disabledColor,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 6.0,
              horizontal: 10.0,
            ),
            selectedStatus: TabStatusThemeData(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
          ),
          tabsArea: TabsAreaThemeData(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
                width: 2,
              ),
            ),
            middleGap: 4,
            color: Theme.of(context).colorScheme.surface,
            menuIcon: IconProvider.data(Icons.more_horiz_rounded),
            buttonIconSize: 20,
            buttonPadding: const EdgeInsets.all(6),
            buttonsAreaDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
          ),
        ),
        child: TabbedView(
          controller: tabCtrl.value,
          contentBuilder: (_, int idx) => TerminalPage(
            onClosed: () => removeTab(idx),
          ),
          onTabClose: (_, __) {
            if (tabCtrl.value.tabs.isEmpty) Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
