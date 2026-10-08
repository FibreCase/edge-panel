import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:edge_panel/providers/weather_provider.dart';
import 'package:edge_panel/providers/sensor_provider.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Consumer2<WeatherProvider, SensorProvider>(
      builder: (context, weatherProvider, sensorProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: weatherProvider.isWarningColor
                ? colorScheme.error
                : colorScheme.secondary,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(96, 0, 0, 0),
                blurRadius: 8,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: SvgPicture.asset(
                        weatherProvider.currentWeatherIconPath,
                        colorFilter: ColorFilter.mode(
                          weatherProvider.isWarningColor
                              ? colorScheme.onError
                              : colorScheme.onSecondary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      children: [
                        if (weatherProvider.currentWeather.length > 10)
                          SizedBox(
                            width: 190,
                            height: 45,
                            child: Marquee(
                              text: weatherProvider.currentWeather,
                              style: TextStyle(
                                fontSize: 35,
                                height: 1.0,
                                fontWeight: FontWeight.normal,
                                color: weatherProvider.isWarningColor
                                    ? colorScheme.onError
                                    : colorScheme.onSecondary,
                              ),
                              scrollAxis: Axis.horizontal,
                              blankSpace: 50.0,
                              velocity: 50.0,
                              pauseAfterRound: const Duration(seconds: 1),
                              startPadding: 0.0,
                            ),
                          )
                        else
                          Text(
                            weatherProvider.currentWeather,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 35,
                              height: 1.1,
                              fontWeight: FontWeight.normal,
                              color: weatherProvider.isWarningColor
                                  ? colorScheme.onError
                                  : colorScheme.onSecondary,
                            ),
                          ),
                        Text(
                          weatherProvider.currentTemperature,
                          style: TextStyle(
                            fontSize: 60,
                            height: 1.0,
                            fontWeight: FontWeight.w600,
                            color: weatherProvider.isWarningColor
                                ? colorScheme.onError
                                : colorScheme.onSecondary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: weatherProvider.currentAqiColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(96, 0, 0, 0),
                                blurRadius: 8,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              weatherProvider.currentAqi.toString(),
                              style: GoogleFonts.notoSansSc(
                                fontSize: 36,
                                height: 1.2,
                                color: weatherProvider.currentAqiFrontColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final textPainter = TextPainter(
                            text: TextSpan(
                              text: weatherProvider.currentTextNotification,
                              style: GoogleFonts.notoSansSc(
                                fontSize: 32,
                                height: 1.2,
                                color: weatherProvider.isWarningColor
                                    ? colorScheme.onError
                                    : colorScheme.onSecondary,
                              ),
                            ),
                            textDirection: TextDirection.ltr,
                          );
                          textPainter.layout();

                          // 如果文字宽度超出容器，显示 Marquee，否则显示普通 Text
                          if (textPainter.width > constraints.maxWidth) {
                            return SizedBox(
                              height: 38,
                              child: Marquee(
                                text: weatherProvider.currentTextNotification,
                                style: GoogleFonts.notoSansSc(
                                  fontSize: 32,
                                  height: 1.2,
                                  color: weatherProvider.isWarningColor
                                      ? colorScheme.onError
                                      : colorScheme.onSecondary,
                                ),
                                scrollAxis: Axis.horizontal,
                                blankSpace: 100.0,
                                velocity: 100.0,
                                pauseAfterRound: const Duration(seconds: 1),
                                startPadding: 0.0,
                              ),
                            );
                          } else {
                            return Text(
                              weatherProvider.currentTextNotification,
                              style: GoogleFonts.notoSansSc(
                                fontSize: 32,
                                height: 1.2,
                                color: weatherProvider.isWarningColor
                                    ? colorScheme.onError
                                    : colorScheme.onSecondary,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                  color: weatherProvider.isWarningColor
                      ? colorScheme.onError
                      : colorScheme.onSecondary,
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      sensorProvider.temperature,
                      style: TextStyle(
                        fontSize: 42,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        color: weatherProvider.isWarningColor
                            ? colorScheme.onError
                            : colorScheme.onSecondary,
                      ),
                    ),
                    Text(
                      "℃",
                      style: TextStyle(
                        fontSize: 24,
                        height: 1.2,
                        fontWeight: FontWeight.w500,
                        color: weatherProvider.isWarningColor
                            ? colorScheme.onError
                            : colorScheme.onSecondary,
                      ),
                    ),
                    Spacer(),
                    Text(
                      sensorProvider.humidity,
                      style: TextStyle(
                        fontSize: 42,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        color: weatherProvider.isWarningColor
                            ? colorScheme.onError
                            : colorScheme.onSecondary,
                      ),
                    ),
                    Text(
                      "%",
                      style: TextStyle(
                        fontSize: 24,
                        height: 1.2,
                        fontWeight: FontWeight.w500,
                        color: weatherProvider.isWarningColor
                            ? colorScheme.onError
                            : colorScheme.onSecondary,
                      ),
                    ),
                    Spacer(),
                    Text(
                      sensorProvider.eco2,
                      style: TextStyle(
                        fontSize: 42,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        color: weatherProvider.isWarningColor
                            ? colorScheme.onError
                            : colorScheme.onSecondary,
                      ),
                    ),
                    Text(
                      "ppm",
                      style: TextStyle(
                        fontSize: 24,
                        height: 1.2,
                        fontWeight: FontWeight.w500,
                        color: weatherProvider.isWarningColor
                            ? colorScheme.onError
                            : colorScheme.onSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
