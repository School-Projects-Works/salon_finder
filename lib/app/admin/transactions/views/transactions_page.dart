import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salon_finder/app/admin/provider/admin_provider.dart';
import 'package:salon_finder/app/ui/theme/colors.dart';
import '../../../ui/global_widgets/custom_input.dart';
import '../../core/styles.dart';

class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage> {
  @override
  Widget build(BuildContext context) {
    var style = Styles(context);
    var titleStyles = style.title(color: Colors.white, fontSize: 15);
    var rowStyles = style.body(fontSize: 13);
    var transactions = ref.watch(transactionsFilterProvider).filter;
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Transactions List'.toUpperCase(),
              style: style.title(fontSize: 30, color: AppColors.primaryColor)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: style.width * 0.5,
                child: CustomTextFields(
                  hintText: 'Search Transactions',
                  onChanged: (query) {
                    ref
                        .read(transactionsFilterProvider.notifier)
                        .filterTransactions(query);
                  },
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: DataTable2(
              columnSpacing: 30,
              horizontalMargin: 12,
              empty: Center(
                  child: Text(
                'No Transactions found',
                style: rowStyles,
              )),
              minWidth: 600,
              headingRowColor: WidgetStateColor.resolveWith(
                  (states) => AppColors.primaryColor.withOpacity(0.6)),
              headingTextStyle: titleStyles,
              columns: [
                DataColumn2(
                    label: Text(
                      'INDEX',
                      style: titleStyles,
                    ),
                    fixedWidth: style.largerThanMobile ? 80 : null),
                DataColumn2(
                  label: Text('App Id'.toUpperCase()),
                ),
                DataColumn2(
                  label: Text('Reference'.toUpperCase()),
                ),
                DataColumn2(
                  label: Text('Amount'.toUpperCase()),
                ),
                DataColumn2(
                  label: Text('Payment method'.toUpperCase()),
                ),
                DataColumn2(
                  label: Text('Status'.toUpperCase()),
                ),
              ],
              rows: List<DataRow>.generate(transactions.length, (index) {
                var transaction = transactions[index];
                return DataRow(
                  cells: [
                    DataCell(Text('${index + 1}', style: rowStyles)),
                    DataCell(
                      Text(transaction.id, style: rowStyles)
                    ),
                    DataCell(Text(transaction.reference, style: rowStyles)),
                    DataCell(Text('Gh ${transaction.amount}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: rowStyles)),
                    DataCell(Text(transaction.paymentMethod, style: rowStyles)),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: transaction.status == 'Paid'|| transaction.status == 'Completed'
                              ? Colors.green
                              : transaction.status == 'Pending'|| transaction.status == 'Unpaid'
                              ? Colors.orange
                              : Colors.red,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          transaction.status,
                          style: rowStyles.copyWith(color: Colors.white),
                        ),
                      ),
                    
                    )
                  ],
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
