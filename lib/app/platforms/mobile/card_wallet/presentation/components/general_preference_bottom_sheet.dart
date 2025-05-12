import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GeneralPreferenceBottomSheet {
  final BuildContext context;
  final String question;

  GeneralPreferenceBottomSheet(this.context, this.question);

  void text({
    required ValueChanged<String> onChanged,
    String? value,
    TextInputType type = TextInputType.text,
  }) {
    final controller = TextEditingController(text: value);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: TextField(
            onSubmitted: (value) {
              Navigator.pop(context);
              onChanged(value);
            },
            controller: controller,
            keyboardType: type,
            decoration: InputDecoration(
              labelText: 'Enter Text',
            ),
          ),
        );
      },
    );
  }

  void choice({
    required ValueChanged<String> onChanged,
    required List<String> choices,
    String? value,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      question.toUpperCase(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 22,
                    )
                  ],
                ),
                SizedBox(height: 20),
                ListView.builder(
                  itemCount: choices.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: InkWell(
                        onTap: () {
                          onChanged(choices[index]);
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 5.h,
                          decoration: value == choices[index]
                              ? BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: const [
                                      Color(0xff118CFD),
                                      Color(0xff118CFD),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(05),
                                )
                              : BoxDecoration(
                                  borderRadius: BorderRadius.circular(05),
                                  border: Border.all(color: Colors.black)),
                          child: Center(
                            child: Text(
                              choices[index],
                              style: TextStyle(
                                  color: value == choices[index]
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void calendar({
    required ValueChanged<DateTime> onChanged,
    DateTime? value,
  }) async {
    DateTime? selectedDateTime;
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: CalendarDatePicker(
            initialDate: selectedDateTime ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            onDateChanged: (value) {
              selectedDateTime = value;
            },
          ),
        );
      },
    );
    if(value != selectedDateTime && selectedDateTime != null) {
      onChanged(selectedDateTime!);
    }
  }
}
