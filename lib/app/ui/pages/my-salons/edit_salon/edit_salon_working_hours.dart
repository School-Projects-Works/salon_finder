import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/salon_open_close_model.dart';
import '../../../../provider/edit_salon_provider.dart';

class EditSalonWorkingHours extends ConsumerStatefulWidget {
  const EditSalonWorkingHours({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditSalonWorkingHoursState();
}

class _EditSalonWorkingHoursState extends ConsumerState<EditSalonWorkingHours> {

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editSalonProvider);
    final notifier = ref.read(editSalonProvider.notifier);
    return Column(
              children: [
                ...List.generate(7, (i) {
                  final days = [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun',
                  ];
                  final existing = i < state.salon.openCloseHours.length
                      ? state.salon.openCloseHours[i]
                      : SalonOpenCloseModel.initial().copyWith(day: days[i]);
                  return Row(
                    children: [
                      Expanded(child: Text(existing.day)),
                      Expanded(
                        child: TextFormField(
                          initialValue: existing.openTime,
                          decoration: const InputDecoration(labelText: 'Open'),
                          onChanged: (v) {
                            final list = List<SalonOpenCloseModel>.from(
                              state.salon.openCloseHours,
                            );
                            if (i < list.length) {
                              list[i] = SalonOpenCloseModel(
                                day: existing.day,
                                openTime: v,
                                closeTime: existing.closeTime,
                              );
                            } else {
                              list.add(
                                SalonOpenCloseModel(
                                  day: existing.day,
                                  openTime: v,
                                  closeTime: existing.closeTime,
                                ),
                              );
                            }
                            notifier.setOpenClose(list);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          initialValue: existing.closeTime,
                          decoration: const InputDecoration(labelText: 'Close'),
                          onChanged: (v) {
                            final list = List<SalonOpenCloseModel>.from(
                              state.salon.openCloseHours,
                            );
                            if (i < list.length) {
                              list[i] = SalonOpenCloseModel(
                                day: existing.day,
                                openTime: existing.openTime,
                                closeTime: v,
                              );
                            } else {
                              list.add(
                                SalonOpenCloseModel(
                                  day: existing.day,
                                  openTime: existing.openTime,
                                  closeTime: v,
                                ),
                              );
                            }
                            notifier.setOpenClose(list);
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ],
            )
           ;
  }
}