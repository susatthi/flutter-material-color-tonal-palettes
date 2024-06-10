import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/ui/component/bottom_sheet.dart';
import '../../../../core/ui/component/material.dart';
import '../../../color/state/current_seed_color.dart';
import '../../entity/seed_color_history.dart';
import '../../state/current_seed_color_history_collection.dart';
import '../../use_case/delete_seed_color_history.dart';

class SeedColorHistoryBottomSheet extends StatelessWidget {
  const SeedColorHistoryBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return const BottomSheetContainer(
      child: SeedColorHistoryPanel(),
    );
  }
}

class SeedColorHistoryPanel extends ConsumerWidget {
  const SeedColorHistoryPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collection = ref.watch(currentSeedColorHistoryCollectionProvider);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 44,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Text(
                'Seed Color History',
                style: context.titleSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const Gap(8),
        ...collection.histories.map(
          (e) => _ListTile(
            history: e,
          ),
        ),
        if (collection.histories.isEmpty)
          Text(
            'NO HISTORY',
            style: context.caption,
          ),
        const Gap(16),
      ],
    );
  }
}

class _ListTile extends ConsumerWidget {
  const _ListTile({
    required this.history,
  });

  final SeedColorHistory history;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: const EdgeInsets.only(
        left: 16,
        right: 2,
      ),
      leading: _ColorAvatar(
        history: history,
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(history.name),
      ),
      trailing: _DeleteButton(
        history: history,
      ),
    );
  }
}

class _ColorAvatar extends ConsumerStatefulWidget {
  const _ColorAvatar({
    required this.history,
  });

  final SeedColorHistory history;

  @override
  ConsumerState<_ColorAvatar> createState() => _ColorAvatarState();
}

class _ColorAvatarState extends ConsumerState<_ColorAvatar> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => ref
          .read(currentSeedColorNotifierProvider.notifier)
          .updateValue(widget.history.color),
      onHover: (value) {
        setState(() {
          isHover = value;
        });
      },
      child: CircleAvatar(
        backgroundColor: isHover
            ? widget.history.color.withOpacity(0.5)
            : widget.history.color,
      ),
    );
  }
}

class _NameTextField extends StatefulWidget {
  const _NameTextField();

  @override
  State<_NameTextField> createState() => __NameTextFieldState();
}

class __NameTextFieldState extends State<_NameTextField> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return const TextField();
  }
}

class _DeleteButton extends ConsumerWidget {
  const _DeleteButton({
    required this.history,
  });

  final SeedColorHistory history;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useCaseState = ref.watch(deleteSeedColorHistoryUseCaseProvider);
    return IconButton(
      onPressed: useCaseState.isLoading
          ? null
          : () => ref
              .read(deleteSeedColorHistoryUseCaseProvider.notifier)
              .invoke(history: history),
      icon: const Icon(Icons.remove),
      color: context.outlineVariant,
      iconSize: 20,
      tooltip: 'Delete color',
    );
  }
}
