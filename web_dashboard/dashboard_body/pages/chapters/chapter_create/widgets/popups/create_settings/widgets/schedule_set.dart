import 'package:flutter/material.dart';
import 'package:storia/utilities/utilities.dart';
import 'package:storia/web_dashboard/dashboard_theme.dart';

class ScheduleSet extends StatelessWidget {
  final ValueChanged<DateTime> date;
  final ValueChanged<TimeOfDay> time;
  final DateTime currentDate;
  const ScheduleSet({
    super.key,
    required this.date,
    required this.currentDate,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 220,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color.fromARGB(255, 42, 42, 42)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: const Color.fromARGB(31, 255, 255, 255),
                onTap: () async {
                  final data = await showDatePicker(
                    context: context,
                    firstDate: currentDate,
                    lastDate: DateTime(2030),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.dark(
                            primary: DashboardTheme.blue,
                            onPrimary: Colors.white,
                            surface: DashboardTheme.secondary,
                            onSurface: Colors.white,
                            secondary: DashboardTheme.blue,
                            onSecondary: Colors.white,
                            tertiary: DashboardTheme.blue,
                            outline: const Color.fromARGB(46, 158, 158, 158),
                          ),
                          textTheme: Theme.of(context).textTheme.copyWith(
                            bodyLarge: TextStyle(color: Colors.white),
                            bodyMedium: TextStyle(color: Colors.white),
                            bodySmall: TextStyle(color: Colors.white),
                          ),
                        ),

                        child: child!,
                      );
                    },
                  );
                  if (data == null) return;

                  date(data);
                },
                hoverColor: const Color.fromARGB(8, 62, 62, 62),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                child: Ink(
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      formatDate(currentDate),
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 35,
            width: 1,
            color: Color.fromARGB(255, 42, 42, 42),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: const Color.fromARGB(31, 255, 255, 255),
                  onTap: () async {
                    final data = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(
                        hour: currentDate.hour,
                        minute: currentDate.minute,
                      ),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.dark(
                              primary: DashboardTheme.blue,
                              onPrimary: Colors.white,
                              surface: DashboardTheme.secondary,
                              onSurface: Colors.white,
                              secondary: DashboardTheme.blue,
                              onSecondary: Colors.white,
                              tertiary: DashboardTheme.blue,
                              outline: const Color.fromARGB(46, 158, 158, 158),
                            ),
                            textTheme: Theme.of(context).textTheme.copyWith(
                              bodyLarge: TextStyle(color: Colors.white),
                              bodyMedium: TextStyle(color: Colors.white),
                              bodySmall: TextStyle(color: Colors.white),
                            ),
                          ),

                          child: child!,
                        );
                      },
                    );
                    if (data == null) return;

                    time(data);
                  },
                  hoverColor: const Color.fromARGB(8, 62, 62, 62),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  child: Ink(
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        formatHour(currentDate),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
