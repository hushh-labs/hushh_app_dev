import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/inventory_schema_response.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/inventory_bloc/bloc.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FieldsInventoryBottomSheet extends StatefulWidget {
  final String sheetId;
  final InventorySchemaResponse schemaResponse;

  const FieldsInventoryBottomSheet(
      {super.key, required this.sheetId, required this.schemaResponse});

  @override
  State<FieldsInventoryBottomSheet> createState() =>
      _FieldsInventoryBottomSheetState();
}

class _FieldsInventoryBottomSheetState
    extends State<FieldsInventoryBottomSheet> {
  final List<InventoryColumn> definedColumns = [
    InventoryColumn('Name', InventoryFieldType.text,
        code: 'product_name_identifier'),
    InventoryColumn('Image', InventoryFieldType.text,
        code: 'product_image_identifier'),
    InventoryColumn('SKU ID', InventoryFieldType.numeric,
        code: 'product_sku_unique_id_identifier'),
    InventoryColumn('Price', InventoryFieldType.numeric,
        code: 'product_price_identifier'),
    InventoryColumn('Currency', InventoryFieldType.text,
        code: 'product_currency_identifier'),
    InventoryColumn('Description', InventoryFieldType.text,
        code: 'product_description_identifier'),
  ];

  Map<String, InventoryColumn> mappedColumns = {};

  @override
  void initState() {
    for (InventoryColumn column in definedColumns) {
      mappedColumns[column.code!] = InventoryColumn("", column.fieldType);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Please select the columns',
                style: TextStyle(
                    fontFamily: 'Figtree',
                    fontSize: 20,
                    letterSpacing: -0.4,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                        color: Color(0xFF4C4C4C), fontFamily: 'Figtree'),
                    children: [
                      TextSpan(
                        text:
                            'Select all the columns that you want to import in',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 20.w,
                child: Divider(
                  color: const Color(0xFF50555C).withOpacity(0.2),
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  definedColumns.length,
                  (index) {
                    return Row(
                      children: [
                        Expanded(child: Text(definedColumns[index].name)),
                        Expanded(
                            child: InventoryDropdown(
                                inventorySchema: widget.schemaResponse,
                                onChanged: (value) {
                                  if (mappedColumns[
                                          definedColumns[index].code!] ==
                                      null) return;

                                  mappedColumns[definedColumns[index].code!]!
                                      .name = value;
                                }))
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 46,
                child: BlocBuilder(
                    bloc: sl<InventoryBloc>(),
                    builder: (context, state) {
                      return HushhLinearGradientButton(
                        text: 'Create Inventory',
                        loader: state is InsertingInventoryConfigurationState ||
                            state is InventoryConfigurationInsertedState,
                        onTap: () {
                          sl<InventoryBloc>().add(
                              CreateInventoryWithGoogleSheetsEvent(
                                  widget.sheetId,
                                  mappedColumns,
                                  AppLocalStorage.agent!.agentBrandId,
                                  context));
                        },
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InventoryDropdown extends StatefulWidget {
  final InventorySchemaResponse inventorySchema;
  final Function(String) onChanged;

  const InventoryDropdown(
      {Key? key, required this.inventorySchema, required this.onChanged})
      : super(key: key);

  @override
  _InventoryDropdownState createState() => _InventoryDropdownState();
}

class _InventoryDropdownState extends State<InventoryDropdown> {
  String? selectedColumn;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedColumn,
      hint: const Text('Select Column'),
      items: widget.inventorySchema.columns.map((InventoryColumn column) {
        return DropdownMenuItem<String>(
          value: column.name,
          child: Text(column.name),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) widget.onChanged(newValue);
        setState(() {
          selectedColumn = newValue;
        });
      },
    );
  }
}
