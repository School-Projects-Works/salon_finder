import 'package:flutter/material.dart';
import 'package:salon_finder/app/data/rating_model.dart';
import 'package:salon_finder/app/services/rating_services.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_dialog.dart';

Future<RatingModel?> showSalonReviewSheet(
  BuildContext context, {
  required String salonId,
  required String userId,
  int initialRating = 0,
  String initialComment = '',
}) {
  return showModalBottomSheet<RatingModel>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (ctx) => _ReviewSheet(
      salonId: salonId,
      userId: userId,
      initialRating: initialRating,
      initialComment: initialComment,
    ),
  );
}

/// Optional alert dialog version
Future<RatingModel?> showSalonReviewDialog(
  BuildContext context, {
  required String salonId,
  required String userId,
  int initialRating = 0,
  String initialComment = '',
}) {
  return showDialog<RatingModel>(
    context: context,
    builder: (ctx) => AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      content: _ReviewForm(
        salonId: salonId,
        userId: userId,
        initialRating: initialRating,
        initialComment: initialComment,
        onSubmit: (rev) => Navigator.pop(ctx, rev),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}

class _ReviewSheet extends StatelessWidget {
  final String salonId;
  final String userId;
  final int initialRating;
  final String initialComment;
  const _ReviewSheet({
    required this.salonId,
    required this.userId,
    required this.initialRating,
    required this.initialComment,
  });

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: _ReviewForm(
        salonId: salonId,
        userId: userId,
        initialRating: initialRating,
        initialComment: initialComment,
        onSubmit: (rev) => Navigator.pop(context, rev),
      ),
    );
  }
}

class _ReviewForm extends StatefulWidget {
  final String salonId;
  final String userId;
  final int initialRating;
  final String initialComment;
  final ValueChanged<RatingModel> onSubmit;

  const _ReviewForm({
    required this.salonId,
    required this.userId,
    required this.initialRating,
    required this.initialComment,
    required this.onSubmit,
  });

  @override
  State<_ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<_ReviewForm> {
  final _formKey = GlobalKey<FormState>();
  int _rating = 0;
  String _comment = '';

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
    _comment = widget.initialComment;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rate your experience',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _StarRow(
              rating: _rating,
              onChanged: (val) => setState(() => _rating = val),
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: _comment,
              decoration: const InputDecoration(
                labelText: 'Write a review',
                hintText: 'Share details that help others',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              minLines: 3,
              maxLength: 500,
              onChanged: (v) => _comment = v,
              validator: (v) {
                if (_rating < 1 || _rating > 5) {
                  return 'Please select 1 to 5 stars';
                }
                if ((v ?? '').trim().length < 5) return 'Add a few words';
                return null;
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      if (_rating < 1 || _rating > 5) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Select a rating')),
                        );
                        return;
                      }
                      if (!_formKey.currentState!.validate()) return;
                      final review = RatingModel(
                        id: '',
                        salonId: widget.salonId,
                        userId: widget.userId,
                        rating: double.parse(_rating.toString()),
                        comment: _comment.trim(),
                      );
                      _createAReview(review);
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _createAReview(RatingModel review) async {
    // Call your API or service to create the review
    CustomDialog.loading();

    final response = await RatingServices.createRating(
      review.copyWith(id: RatingServices.generateDocId()),
    );
    if (response.success) {
      CustomDialog.closeDialog();
      CustomDialog.showSnackBar(message: response.message);
      Navigator.pop(context);
    } else {
      CustomDialog.closeDialog();
      CustomDialog.showSnackBar(message: response.message);
    }
  }
}

class _StarRow extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onChanged;
  const _StarRow({required this.rating, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(5, (i) {
        final idx = i + 1;
        final isFilled = idx <= rating;
        return IconButton(
          tooltip: '$idx star${idx == 1 ? '' : 's'}',
          iconSize: 32,
          onPressed: () => onChanged(idx),
          icon: Icon(isFilled ? Icons.star : Icons.star_border),
        );
      }),
    );
  }
}
