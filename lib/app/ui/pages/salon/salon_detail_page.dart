import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:salon_finder/app/data/salon_model.dart';
import 'package:salon_finder/app/provider/current_user_provider.dart';
import 'package:salon_finder/app/provider/new_appointment_provider.dart';
import 'package:salon_finder/app/services/appointment_services.dart';
import 'package:salon_finder/app/services/helper_functions.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_button.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_drop_down.dart';
import 'package:salon_finder/app/ui/global_widgets/custom_input.dart';
import 'package:salon_finder/app/ui/theme/colors.dart';
import 'package:salon_finder/app/ui/theme/text_styles.dart';

import '../../../provider/rating_provider.dart';
import 'new_review_page.dart';
import 'salon_reviews_page.dart';

class SalonDetailPage extends ConsumerStatefulWidget {
  const SalonDetailPage({super.key, required this.salon});
  final SalonModel salon;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SalonDetailPageState();
}

class _SalonDetailPageState extends ConsumerState<SalonDetailPage> {
  String _payType = "Pay Cash at Salon";
  final formKey = GlobalKey<FormState>();

  Future<bool> get _userHavePendingAppointments async {
    var user = ref.watch(currentUserProvider).user;
    if (user == null) return false;
    var salon = widget.salon;
    bool hasPendingAppointments =
        await AppointmentServices.getPendingAppsForUserAndSalon(
          user.id,
          salon.id,
        );
    return hasPendingAppointments;
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(currentUserProvider).user;
    var rating = ref.watch(ratingAverageStreamProvider(widget.salon.id));
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(200),
          child: Container(
            height: 200,
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: widget.salon.imageUrl.contains('assets/images')
                    ? AssetImage(widget.salon.imageUrl)
                    : NetworkImage(widget.salon.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    //back button
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(color: Colors.black54),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 8.0,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.salon.name,
                                      style: AppTextStyles.title(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  rating.when(
                                    error: (error, stack) => Text(
                                      '',
                                      style: AppTextStyles.body(
                                        color: Colors.red,
                                      ),
                                    ),
                                    loading: () => SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: const CircularProgressIndicator(),
                                    ),
                                    data: (data) {
                                      return InkWell(
                                        onTap: () {
                                          showSalonReviewsSheet(
                                            context,
                                            salonId: widget.salon.id,
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                            vertical: 4.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius: BorderRadius.circular(
                                              8.0,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 4.0),
                                              Text(
                                                data.rating.toStringAsFixed(1),
                                                style: AppTextStyles.body(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Text(
                                    '${widget.salon.address.city}, ${widget.salon.address.region}',
                                    style: AppTextStyles.body(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  const Spacer(),
                                  TextButton.icon(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.black54,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                        vertical: 4.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      launchMap(
                                        widget.salon.address.latitude,
                                        widget.salon.address.longitude,
                                      );
                                    },
                                    label: Text(
                                      "View Location",
                                      style: AppTextStyles.body(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                //salon Services
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      Text('Our Services', style: AppTextStyles.body()),
                    ],
                  ),
                ),
                //chip of services
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Wrap(
                    spacing: 4.0,
                    runSpacing: 8.0,
                    children: widget.salon.services
                        .map(
                          (service) => InkWell(
                            onTap: () {
                              ref
                                  .read(newAppointmentProvider.notifier)
                                  .toggleService(service);
                            },
                            child: Chip(
                              padding: const EdgeInsets.all(5.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              color:
                                  ref
                                      .watch(newAppointmentProvider)
                                      .services
                                      .contains(service)
                                  ? WidgetStateProperty.all(
                                      AppColors.primaryColor.withValues(
                                        alpha: .2,
                                      ),
                                    )
                                  : WidgetStateProperty.all(Colors.white),
                              side: BorderSide(
                                color:
                                    ref
                                        .watch(newAppointmentProvider)
                                        .services
                                        .contains(service)
                                    ? AppColors.primaryColor
                                    : Colors.transparent,
                                width: 2.0,
                              ),
                              avatar: CircleAvatar(
                                backgroundImage:
                                    service.category.imageUrl.contains(
                                      'assets/images',
                                    )
                                    ? AssetImage(service.category.imageUrl)
                                    : NetworkImage(service.category.imageUrl),
                              ),

                              label: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service.name,
                                    style: AppTextStyles.body(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Gh₵${service.price}',
                                    style: AppTextStyles.body(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 8.0),
                //show working hours
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.amber, size: 20),
                      Text('Working Hours', style: AppTextStyles.body()),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Day',
                              style: AppTextStyles.body(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              "Opening Hours",
                              style: AppTextStyles.body(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              'Closing Hours',
                              style: AppTextStyles.body(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      for (var time in widget.salon.openCloseHours)
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                time.day,
                                style: AppTextStyles.body(fontSize: 11),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Center(
                                child: Text(
                                  time.openTime,
                                  style: AppTextStyles.body(fontSize: 11),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Center(
                                child: Text(
                                  time.closeTime,
                                  style: AppTextStyles.body(fontSize: 11),
                                ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 8.0),
                      //now date and time picker fields in a row
                      Text("When do you want your appointment?"),
                      const SizedBox(height: 12.0),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFields(
                              label: "Select Date",
                              validator: (date) {
                                if (date == null || date.isEmpty) {
                                  return "Please select a date";
                                }
                                return null;
                              },
                              controller: TextEditingController(
                                text: DateFormat('EEE, dd MMM yyyy').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    ref.watch(newAppointmentProvider).date,
                                  ),
                                ),
                              ),
                              isReadOnly: true,
                              onTap: () {
                                //open date picker
                                showDatePicker(
                                  // initialEntryMode:
                                  //     DatePickerEntryMode.calendarOnly,
                                  //text font style
                                  builder: (context, child) {
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        buttonTheme: ButtonThemeData(
                                          textTheme: ButtonTextTheme.primary,
                                        ),
                                        textTheme: TextTheme(
                                          labelLarge: AppTextStyles.body(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                ).then((selectedDate) {
                                  if (selectedDate != null) {
                                    ref
                                        .read(newAppointmentProvider.notifier)
                                        .setDate(
                                          selectedDate.millisecondsSinceEpoch,
                                        );
                                  }
                                });
                              },
                              suffixIcon: InkWell(
                                onTap: () {
                                  //open date picker
                                  showDatePicker(
                                    // initialEntryMode:
                                    //     DatePickerEntryMode.calendarOnly,
                                    //text font style
                                    builder: (context, child) {
                                      return Theme(
                                        data: ThemeData.light().copyWith(
                                          buttonTheme: ButtonThemeData(
                                            textTheme: ButtonTextTheme.primary,
                                          ),
                                          textTheme: TextTheme(
                                            labelLarge: AppTextStyles.body(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                  ).then((selectedDate) {
                                    if (selectedDate != null) {
                                      ref
                                          .read(newAppointmentProvider.notifier)
                                          .setDate(
                                            selectedDate.millisecondsSinceEpoch,
                                          );
                                    }
                                  });
                                },
                                child: Icon(Icons.calendar_today),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: CustomTextFields(
                              label: "Select Time",
                              validator: (time) {
                                if (time == null || time.isEmpty) {
                                  return "Please select a time";
                                }
                                return null;
                              },
                              controller: TextEditingController(
                                text: DateFormat('hh:mm a').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    ref.watch(newAppointmentProvider).time,
                                  ),
                                ),
                              ),
                              isReadOnly: true,
                              onTap: () {
                                //open time picker
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((selectedTime) {
                                  if (selectedTime != null) {
                                    final date =
                                        DateTime.fromMillisecondsSinceEpoch(
                                          ref
                                              .watch(newAppointmentProvider)
                                              .date,
                                        );
                                    final newDate = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      selectedTime.hour,
                                      selectedTime.minute,
                                    );
                                    ref
                                        .read(newAppointmentProvider.notifier)
                                        .setTime(
                                          newDate.millisecondsSinceEpoch,
                                        );
                                  }
                                });
                              },
                              suffixIcon: InkWell(
                                onTap: () {
                                  //open time picker
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((selectedTime) {
                                    if (selectedTime != null) {
                                      final date =
                                          DateTime.fromMillisecondsSinceEpoch(
                                            ref
                                                .watch(newAppointmentProvider)
                                                .date,
                                          );
                                      final newDate = DateTime(
                                        date.year,
                                        date.month,
                                        date.day,
                                        selectedTime.hour,
                                        selectedTime.minute,
                                      );
                                      ref
                                          .read(newAppointmentProvider.notifier)
                                          .setTime(
                                            newDate.millisecondsSinceEpoch,
                                          );
                                    }
                                  });
                                },
                                child: Icon(Icons.access_time),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomTextFields(
                        label: "Any additional notes",
                        maxLines: 3,
                        onChanged: (value) {
                          ref
                              .read(newAppointmentProvider.notifier)
                              .setNotes(value);
                        },
                      ),
                      const SizedBox(height: 16),
                      //total cost
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Cost",
                              style: AppTextStyles.title(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Gh₵${ref.watch(newAppointmentProvider).totalPrice}",
                              style: AppTextStyles.title(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      //payment method
                      CustomDropDown<String>(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select a payment method";
                          }
                          return null;
                        },
                        items: ["Pay Cash at Salon", "Pay Online"]
                            .map(
                              (e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                        label: "Payment Method",
                        onChanged: (value) {
                          setState(() {
                            _payType = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),

                FutureBuilder<bool>(
                  future: _userHavePendingAppointments,
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (asyncSnapshot.hasError) {
                      return Center(
                        child: Text("Error: ${asyncSnapshot.error}"),
                      );
                    }
                    if (asyncSnapshot.data == true) {
                      if (user == null) return SizedBox.shrink();
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomButton(
                            text: 'Write a Review',
                            onPressed: () {
                              showSalonReviewDialog(
                                context,
                                salonId: widget.salon.id,
                                userId: user.id,
                              );
                            },
                          ),
                        ),
                      );
                    }
                    return CustomButton(
                      text: "Book Appointment",
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (ref
                              .watch(newAppointmentProvider)
                              .services
                              .isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Please select at least one service",
                                ),
                              ),
                            );
                            return;
                          }
                          ref
                              .read(newAppointmentProvider.notifier)
                              .bookAppointment(
                                salon: widget.salon,
                                ref: ref,
                                payType: _payType,
                                context: context,
                              );
                          // Book appointment
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
