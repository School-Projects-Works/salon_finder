import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_finder/app/data/rating_model.dart';

import '../../../provider/rating_provider.dart';

Future<void> showSalonReviewsSheet(
  BuildContext context, {
  required String salonId,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (ctx) => ProviderScope.containerOf(
      context,
      listen: false,
    ).read(_sheetInjectorProvider).buildSheet(salonId),
  );
}

// Inject the parent ProviderContainer so the sheet has access to the same providers
final _sheetInjectorProvider = Provider<_SheetInjector>(
  (ref) => _SheetInjector(ref.container),
);

class _SheetInjector {
  final ProviderContainer parent;
  _SheetInjector(this.parent);

  Widget buildSheet(String salonId) {
    return UncontrolledProviderScope(
      container: parent,
      child: _ReviewsSheet(salonId: salonId),
    );
  }
}

class _ReviewsSheet extends ConsumerWidget {
  final String salonId;
  const _ReviewsSheet({required this.salonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(
      ratingAverageStreamProvider(salonId));

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (ctx, controller) {
        return Material(
          color: Theme.of(context).colorScheme.surface,
          child: reviewsAsync.when(
            data: (reviews) {
              final stats = _calcStats(reviews.reviews);
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: _Header(stats: stats),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        // Pull-to-refresh hook. Re-subscribe if your repo supports it.
                        await Future<void>.delayed(
                          const Duration(milliseconds: 300),
                        );
                      },
                      child: reviews.reviews.isEmpty
                          ? ListView(
                              controller: controller,
                              children: const [
                                SizedBox(height: 120),
                                Center(child: Text('No reviews yet')),
                                SizedBox(height: 120),
                              ],
                            )
                          : ListView.separated(
                              controller: controller,
                              itemCount: reviews.reviews.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (ctx, i) =>
                                  _ReviewTile(review: reviews.reviews[i]),
                            ),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, st) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Failed to load reviews'),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final _ReviewStats stats;
  const _Header({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              stats.avg.toStringAsFixed(1),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(width: 8),
            _Stars(rating: stats.avg),
            const Spacer(),
            Text('${stats.count} reviews'),
          ],
        ),
        const SizedBox(height: 8),
        Column(
          children: List.generate(5, (i) {
            final r = 5 - i;
            final ratio = stats.count == 0
                ? 0.0
                : stats.buckets[r]! / stats.count;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  SizedBox(width: 18, child: Text('$r')),
                  const SizedBox(width: 6),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(value: ratio),
                    ),
                  ),
                  const SizedBox(width: 6),
                  SizedBox(width: 28, child: Text('${stats.buckets[r]}')),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final RatingModel review;
  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.fromMillisecondsSinceEpoch(review.createdAt);
    return ListTile(
      leading: _Avatar(seed: review.userId),
      title: Row(
        children: [
          _Stars(rating: review.rating),
          const SizedBox(width: 8),
          Text(
            _relativeTime(date),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      subtitle: Text(review.comment),
    );
  }
}

class _Stars extends StatelessWidget {
  final double rating;
  const _Stars({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final idx = i + 1;
        final filled = idx <= rating;
        return Icon(filled ? Icons.star : Icons.star_border, size: 18);
      }),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String seed;
  const _Avatar({required this.seed});

  @override
  Widget build(BuildContext context) {
    final color = _colorFromSeed(seed);
    final letter = seed.isNotEmpty ? seed.characters.first.toUpperCase() : '?';
    return CircleAvatar(
      backgroundColor: color.withOpacity(0.2),
      child: Text(letter, style: TextStyle(color: color)),
    );
  }
}

Color _colorFromSeed(String seed) {
  final hash = seed.codeUnits.fold(0, (a, b) => a + b);
  final hue = hash % 360;
  return HSVColor.fromAHSV(1, hue.toDouble(), 0.5, 0.8).toColor();
}

class _ReviewStats {
  final int count;
  final double avg;
  final Map<int, double> buckets;
  _ReviewStats({required this.count, required this.avg, required this.buckets});
}

_ReviewStats _calcStats(List<RatingModel> items) {
  if (items.isEmpty) {
    return _ReviewStats(
      count: 0,
      avg: 0,
      buckets: {1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
    );
  }
  final count = items.length;
  final sum = items.fold<double>(0, (a, b) => a + b.rating);
  final avg = sum / count;
  final buckets = {1: 0.0, 2: 0.0, 3: 0.0, 4: 0.0, 5: 0.0};
  for (final r in items) {
    final k = r.rating.clamp(1, 5).round();
    buckets[k] = buckets[k]! + 1;
  }
  return _ReviewStats(count: count, avg: avg, buckets: buckets);
}

String _relativeTime(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);
  if (diff.inMinutes < 1) return 'now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m';
  if (diff.inHours < 24) return '${diff.inHours}h';
  if (diff.inDays < 7) return '${diff.inDays}d';
  final weeks = (diff.inDays / 7).floor();
  if (weeks < 5) return '${weeks}w';
  final months = (diff.inDays / 30).floor();
  if (months < 12) return '${months}mo';
  final years = (diff.inDays / 365).floor();
  return '${years}y';
}
